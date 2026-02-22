# Internal Deep Research Run 2 - Concurrency Protocol and MVCC Epochs (TLA+-first)

- Run ID: `20260222-083307-run2-concurrency-mvcc-internal`
- Topic ID: `R-TOPIC-002`
- Prompt basis: `prompts/PROMPT_PACK_DEEP_RESEARCH.md` Run 2
- Method: internal web-backed research, primary-source preference, run1 carry-over for relevant references

## 1) Best Sources (10-15) with Annotated Notes

1. **Specifying Systems (Lamport)**  
   https://lamport.org/tla/book.html  
   Why: canonical safety/liveness modeling foundation and refinement style.

2. **TLA+ Hyperbook**  
   https://lamport.org/tla/hyperbook.html  
   Why: practical idioms for action systems, fairness, and decomposition.

3. **TLA+ Toolbox**  
   https://lamport.azurewebsites.net/tla/toolbox.html  
   Why: concrete execution path for TLC model checks and spec debugging.

4. **Apalache documentation**  
   https://apalache-mc.org/docs/  
   Why: symbolic model-checking option to complement bounded explicit-state TLC runs.

5. **AWS formal methods case study**  
   https://cacm.acm.org/research/how-amazon-web-services-uses-formal-methods/  
   Why: production calibration on where TLA+ catches design errors earliest.

6. **A Critique of ANSI SQL Isolation Levels**  
   https://arxiv.org/abs/cs/0701157  
   Why: anomaly taxonomy and snapshot-isolation precision for MVCC semantics.

7. **FoundationDB Developer Guide**  
   https://apple.github.io/foundationdb/developer-guide.html  
   Why: strict serializability model with explicit conflict ranges and retry discipline.

8. **FoundationDB Known Limitations**  
   https://apple.github.io/foundationdb/known-limitations.html  
   Why: realistic constraints (e.g., transaction window) useful for liveness assumptions.

9. **CockroachDB Architecture - Transaction Layer**  
   https://www.cockroachlabs.com/docs/stable/architecture/transaction-layer.html  
   Why: modern MVCC transaction protocol and timestamp/intent conflict handling.

10. **PostgreSQL MVCC intro**  
    https://www.postgresql.org/docs/current/mvcc-intro.html  
    Why: stable baseline vocabulary for snapshot/read-write visibility semantics.

11. **Excel Recalculation**  
    https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation  
    Why: spreadsheet-specific recompute and asynchronous completion realities.

12. **Excel performance and limits improvements (RTD/thread-safe UDF context)**  
    https://learn.microsoft.com/en-us/office/vba/excel/concepts/excel-performance/excel-performance-and-limit-improvements  
    Why: real-world async/RTD scheduling pressure points relevant to stale-drop behavior.

13. **Apache POI Formula Evaluation**  
    https://poi.apache.org/components/spreadsheet/eval.html  
    Why: practical evaluator invalidation/cache behavior for trace/test design ideas.

14. **Jepsen consistency models (anomaly framing)**  
    https://jepsen.io/consistency  
    Why: operational anomaly language for tests and failure triage.

15. **The Morning Paper - TLA+ and PlusCal**  
    https://blog.acolyer.org/2015/01/20/tlaplus-and-pluscal/  
    Why: secondary but useful onboarding lens for communication and team ramp-up.

## 2) TLA+ Model Patterns to Adapt (3-5)

1. **Epoch-tagged result commitment pattern**
- State includes `committedEpoch`, `stabilizedEpoch`, and per-task `inputEpoch`.
- Commit action guarded by `task.inputEpoch = committedEpochAtSchedule` or explicit stale-drop path.
- Directly supports no-stale-commit guarantees.

2. **Operation queue + in-flight workers pattern**
- Separate mutation queue from compute queue.
- Structural edits require exclusive mutation token.
- Worker completions are modeled as non-deterministic arrivals, then filtered by epoch validity.

3. **Snapshot pinning and GC eligibility pattern**
- Explicit set `PinnedEpochs` and retention bound.
- GC transition allowed only for epochs `< min(PinnedEpochs)` and not required by in-flight tasks.

4. **External update envelope pattern**
- Represent external updates as explicit operations carrying `topic`, `seq`, `payload`.
- Reject duplicate/out-of-order sequences deterministically.

5. **Two-tier checking pattern (TLC + symbolic)**
- TLC for tiny bounded state spaces and quick counterexample discovery.
- Symbolic checking (Apalache) for deeper arithmetic/data-path constraints when state explosion begins.

## 3) Common Failure Modes and Invariants

### Failure modes
- Stale task result commits after a newer mutation has advanced epoch.
- Structural edit interleaves with normal mutation, creating inconsistent rewrites.
- Pinned snapshot reclaimed too early, breaking read consistency.
- External updates processed out of sequence, causing non-deterministic downstream values.
- Liveness stall where stabilization never advances due to queue starvation or unfair scheduling.

### Invariants to catch them
- `Inv_NoStaleCommit`: committed results must match declared input epoch policy.
- `Inv_ExclusiveStructuralEdit`: at most one structural mutation token holder.
- `Inv_SnapshotConsistency`: reads at pinned epoch see a stable snapshot projection.
- `Inv_StreamSeqMonotonic`: per-topic sequence monotonicity or deterministic reject.
- `Inv_StabilizedLeCommitted`: `stabilizedEpoch <= committedEpoch` always.

## 4) TLC Configuration Strategy

### Smallest interesting bounds (Tier 0)
- Sheets: 1
- Cells: 2-4
- Workers: 1-2
- Topics: 1
- Queue length: 3-5
- Structural edits: enabled for one action type

### Tier 1 (interaction pressure)
- Workers: 3-4
- Mixed operations: set-cell + structural-edit + external-update interleavings
- Add pin/unpin and GC transitions

### Tier 2 (stress mini-scale)
- Multiple topics and transaction groups
- Increased queue length and delayed completions
- Fairness assumptions toggled to isolate liveness from starvation artifacts

### Operational advice
- Keep constants centralized and profile-tunable.
- Save and archive every counterexample trace as run artifact.
- Minimize before triage and map each minimized trace back to a named invariant.

## 5) Translation Guide: DNA Calc Terms -> TLA+ State/Actions

| DNA Calc term | TLA+ variable/action suggestion |
|---|---|
| `committed_epoch` | `CommittedEpoch` |
| `stabilized_epoch` | `StabilizedEpoch` |
| Snapshot pin | `PinnedEpochs` set |
| OpLog mutation | `OpQueue` element + `ApplyOp` action |
| Structural edit | `StructuralEdit` action requiring `ExclusiveMutation = TRUE` |
| External update op | `OpExternalUpdate(topic, seq, payload)` action |
| Worker task | `InFlightTasks` record with `inputEpoch` |
| Stale drop | `DropStale(task)` action |
| Result commit | `CommitResult(task)` action with epoch guard |
| Stabilization step | `AdvanceStabilizedEpoch` action |

## 6) Recommended next engineering move (post-research)
- Build a minimal TLA+ spec with only: `SetCell`, `StructuralEdit`, `OpExternalUpdate`, `TaskFinish`, `DropStale`, `AdvanceStabilizedEpoch`.
- Run Tier 0 TLC in CI on every protocol change.
- Add one minimized trace corpus immediately to ensure regression lock-in.
