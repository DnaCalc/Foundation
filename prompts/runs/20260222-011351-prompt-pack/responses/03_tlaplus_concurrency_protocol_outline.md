# TLA+ Concurrency Protocol Model Outline (Smallest Useful Model)

## Source-of-truth check
- Documents treated as source of truth: `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `notes/BRAINSTORM_NOTES.md`.
- Contradictions found: none material for this prompt.
- Coherent resolution: proceed with the shared architecture seam `OpLog -> DocSnapshot -> CalcDeltas`, MVCC epochs (`committed_epoch`, `stabilized_epoch`), exclusive structural mutation, and explicit stale handling.

## 1) Minimal model scope (why this is the smallest that still finds real bugs)
- Single coordinator, bounded worker pool, bounded event queue.
- Immutable `DocSnapshot` per epoch; mutable derived cache with `value_epoch` and stale marker.
- Event types limited to required actions only.
- Structural edits modeled as exclusive mutation mode (no overlap with ordinary commits).

This is enough to catch:
- stale task commit after newer epoch exists,
- task finish racing with structural rewrite,
- missing stale-drop causing non-stabilizing runs.

## 2) State variables

| Variable | Type | Purpose |
|---|---|---|
| `committedEpoch` | `Nat` | Latest accepted document epoch |
| `stabilizedEpoch` | `Nat` | Latest epoch fully computed (no pending work for that epoch) |
| `docSnap` | `[Nat -> DocState]` (bounded domain in TLC) | Immutable document snapshot by epoch |
| `eventQ` | `Seq(Event)` | Pending external/user events |
| `inFlight` | `SUBSET Task` | Currently running compute tasks |
| `finished` | `SUBSET TaskResult` | Completed task results waiting to apply/drop |
| `valueCache` | `[Cell -> [value, valueEpoch, stale]]` | Derived outputs exposed to UI/API |
| `mode` | `{Normal, Exclusive}` | Exclusive mode for structural mutation |
| `structEpoch` | `Nat` | Epoch in which current/last structural rewrite occurred |
| `dropCount` | `Nat` | Accounting for dropped stale results (debug/coverage) |

Task/task-result records (minimal fields):
- `Task == [id: TaskId, kind: {Recalc}, snapEpoch: Nat, touched: SUBSET Cell]`
- `TaskResult == [taskId: TaskId, snapEpoch: Nat, writes: [Cell -> Value]]`

Commit rule (explicit state predicate):
- `CanCommit(r) == /\ r.snapEpoch = committedEpoch
                  /\ mode = Normal`

## 3) Actions (required set)

```tla
Init ==
  /\ committedEpoch = 0
  /\ stabilizedEpoch = 0
  /\ mode = Normal
  /\ eventQ = << >>
  /\ inFlight = {}
  /\ finished = {}
  /\ structEpoch = 0
  /\ dropCount = 0

SetCell(c, v) ==
  /\ mode = Normal
  /\ eventQ' = Append(eventQ, [type |-> "SetCell", cell |-> c, val |-> v])
  /\ UNCHANGED <<committedEpoch, stabilizedEpoch, docSnap, inFlight, finished, valueCache, mode, structEpoch, dropCount>>

ExternalUpdate(topic, v) ==
  /\ eventQ' = Append(eventQ, [type |-> "ExternalUpdate", t |-> topic, val |-> v])
  /\ UNCHANGED <<committedEpoch, stabilizedEpoch, docSnap, inFlight, finished, valueCache, mode, structEpoch, dropCount>>

StructuralEdit(edit) ==
  /\ mode = Normal
  /\ inFlight = {}                        \* exclusive mutation gate
  /\ mode' = Exclusive
  /\ committedEpoch' = committedEpoch + 1
  /\ structEpoch' = committedEpoch'
  /\ docSnap' = [docSnap EXCEPT ![committedEpoch'] = Rewrite(@, edit)]
  /\ mode'' = Normal                      \* atomic in abstract model (or split begin/end in larger model)

TaskFinish(r) ==
  /\ r \in finished
  /\ IF CanCommit(r)
        THEN ApplyResult(r)
        ELSE DropStale(r)

DropStale(r) ==
  /\ finished' = finished \ {r}
  /\ dropCount' = dropCount + 1
  /\ UNCHANGED <<committedEpoch, stabilizedEpoch, docSnap, eventQ, inFlight, valueCache, mode, structEpoch>>

Stabilize ==
  /\ inFlight = {}
  /\ finished = {}
  /\ stabilizedEpoch < committedEpoch
  /\ stabilizedEpoch' = committedEpoch
  /\ UNCHANGED <<docSnap, eventQ, inFlight, finished, valueCache, mode, structEpoch, dropCount, committedEpoch>>
```

Notes:
- In the first usable model, `ApplyResult(r)` only writes `valueCache` and removes `r` from `finished`.
- Keep task spawning/dequeue as tiny helper actions (`StartTask`, `PopEvent`) so required actions stay focused.

## 4) Safety invariants

| ID | Invariant | TLA+ shape |
|---|---|---|
| `INV-NoStaleCommit` | Old snapshot results never overwrite current epoch as fresh data | `\A c \in Cell: valueCache[c].valueEpoch <= committedEpoch` and commits require `r.snapEpoch = committedEpoch` |
| `INV-SnapshotConsistency` | Tasks read exactly one immutable snapshot epoch | `\A t \in inFlight: docSnap[t.snapEpoch]` is unchanged while `t` exists |
| `INV-ExclusiveMutationAtomicity` | Structural rewrite has no overlapping compute commit window | `mode = Exclusive => inFlight = {} /\ finished = {}` (or no `TaskFinish` enabled) |
| `INV-StabilizedLeCommitted` | Stabilization cannot pass committed head | `stabilizedEpoch <= committedEpoch` |
| `INV-VisibleStaleFlag` | If cache epoch < committed, it is marked stale | `\A c: valueCache[c].valueEpoch < committedEpoch => valueCache[c].stale = TRUE` |

## 5) Liveness and fairness

Liveness claims:
- `LIV-QueueProgress`: if events stop arriving, queued work is eventually drained.
- `LIV-EventualStabilize`: under finite inputs, system eventually reaches `stabilizedEpoch = committedEpoch`.
- `LIV-StaleResolution`: every finished stale result is eventually dropped.

Fairness assumptions (minimal, explicit):
- `WF_vars(PopEvent)` so queue head is not starved forever.
- `WF_vars(TaskFinishOrDrop)` so completed results are resolved.
- `SF_vars(Stabilize)` if continuously enabled under quiescence (optional; use only if needed to prove eventual stabilization).

Practical note:
- Keep fairness weak first; only add strong fairness where TLC shows liveness failure due to scheduler artifacts rather than protocol flaws.

## 6) TLC configuration plan

### Tier 0: smoke (fast, seconds)
- Cells: `2`
- Topics: `1`
- Max queue length: `2`
- Max in-flight tasks: `1`
- Epoch bound: `<= 2`
- Check: all safety invariants only.

### Tier 1: first bug-catching bound (default CI gate)
- Cells: `3`
- Topics: `2`
- Max queue length: `3`
- Max in-flight tasks: `2`
- Epoch bound: `<= 3`
- Interleavings include: `SetCell -> StartTask -> StructuralEdit -> TaskFinish`.
- Check: safety + `LIV-StaleResolution`.

### Tier 2: stabilization stress (nightly)
- Cells: `4`
- Topics: `2`
- Max queue length: `4`
- Max in-flight tasks: `3`
- Epoch bound: `<= 4`
- Enable all liveness claims with fairness assumptions.

### Tier 3: targeted regressions (case-driven)
- Seed TLC with minimized counterexample traces from `PACK.concurrent.epochs` regressions.
- Keep bounds small but force problematic schedules via constrained initial states.

Scaling strategy over time:
- Increase one dimension at a time: `inFlight` before cells; cells before topics.
- Promote only configurations with stable runtime and actionable counterexamples.
- Store each counterexample as minimized trace artifact and feed back into pack corpus.

## 7) Tiny model diagram

```text
EventQ --PopEvent--> StartTask(snapshot=committedEpoch) --compute--> finished
   |                                                          |
   +--StructuralEdit(exclusive, epoch++)----------------------+
                                                              |
                                TaskFinish --> CanCommit? ----+--> ApplyResult
                                                   |                (valueEpoch=committedEpoch)
                                                   +--> DropStale

Quiescent (EventQ empty, inFlight empty, finished empty) => Stabilize
```

## 8) Exact doc edit hooks (optional but recommended)

- `ARCHITECTURE_AND_REQUIREMENTS.md` under `3.3 Epoch Model (MVCC-style)`:
  - Add IDs: `REAL-EPOCH-STALE-COMMIT-BLOCK`, `REAL-EPOCH-STABILIZE-CONDITION`, `REAL-EPOCH-EXCLUSIVE-STRUCTURAL`.
- `OPERATIONS.md` under `4.1 Packs`:
  - Clarify `PACK.concurrent.epochs` includes Tier 0/1/2 TLC configs and archived minimized counterexamples.

## 9) Smallest high-impact next actions
1. Implement Tier 1 TLC model exactly with the variables/actions above.
2. Encode and run the three core safety invariants first: no stale commit, snapshot consistency, exclusive mutation atomicity.
3. Add one liveness check (`LIV-StaleResolution`) with weak fairness only.
4. Wire first counterexample minimization into `PACK.concurrent.epochs` artifact flow.
