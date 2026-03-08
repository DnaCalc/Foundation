Terminology note: the authoritative seam material in this pack is the current **FEC/F3E** set, so I use **F3E** terms throughout. If a downstream lane says **F3C**, map it 1:1 to the evaluator-side role described here as **F3E**. The current consolidated FEC/F3E set explicitly excludes historical review logs, which is the right baseline for this synthesis.

## 1. Findings

1. **The biggest unresolved risk is the publication boundary between structural truth and calc-time overlays.**
   The pack already converges on an immutable structural model plus structural dependency layer, calc-time dependency/reference overlay, spill overlay, and pure-calc fast path, but it still flags as unresolved the exact lifecycle/publish boundary, overlay retention and GC, spill invalidation algebra, pure-calc guard conditions, deterministic parallel tie-breaks, and published-state semantics during in-flight recalculation. That is the most important design gap because correctness under concurrency depends on it.

2. **Snapshot fencing is materially good at the seam, but it has not yet been promoted into a full concurrent coordinator model.**
   The current b4 seam binds sessions to `(formula_id, expected_token?, snapshot_epoch)`, validates capability decisions at commit, and fences commit against both session/transaction snapshot equality and coordinator snapshot equality. But the spec and observations still call out a single-thread-oriented coordinator and a missing deterministic contention replay pack as open items. This is the highest practical concurrency blocker.

3. **Structural dependencies and runtime-observed dependencies must be separate objects.**
   Foundation baseline is explicit about immutable snapshots, operation-only persistent mutation, ID-based identity, normalized references, and a layered `S/R/D/V/O` model. Separately, the DAG synthesis says dynamic dependencies must be treated as first-class rather than bolted onto static DAG assumptions. That implies a structural dependency graph plus an epoch-scoped runtime overlay, not one mutable “everything graph.”

4. **Spill topology is now explicit enough to standardize, but not yet formal enough to prove.**
   The seam has stable typed spill events (`SpillTakeover`, `SpillClearance`, `SpillBlocked`) and topology impacts (`DependencySetChanged`, `SpillRangeChanged`, `SpillBlocked`). Evidence also shows deterministic dynamic-retargeting and spill-shape transitions at commit. What is still missing is a normative invalidation algebra for prior range, new range, blocked range, and dependent observer behavior.

5. **The policy boundary is currently correct and should be preserved.**
   The current spec is explicit that FEC provides topology evidence and the engine owns recalc policy. That separation is reinforced in the handoff prompt and runtime evidence, including incremental dirty-name routing and conservative spill fallback vs external scheduler selection. This is the right seam shape for Foundation.

6. **Formatting and visibility should stay above value semantics by default.**
   The current v0 contract says formatting is metadata-only, while the synthesis notes add a narrower rule: formatting-observable formulas use explicit format tokens, and visible-first is an optional scheduler policy that may affect priority but not final semantics. That separation is sound and should become normative.

7. **The scheduler baseline should remain Topo+SCC plus bounded fixed-point and dirty closure; more advanced incrementalization should be staged.**
   The DAG transfer matrix and synthesis are aligned: topo+SCC, fixed-point framing, and explicit dirty/stale/necessary state are immediate adoption candidates; dynamic topo and SAC are near-term research lanes; differential/timely belongs only in stream-heavy profiles. That is the correct “state-of-the-art but disciplined” posture.

8. **Assurance is already structured enough to drive design, but the canonical artifact bundle still needs promotion.**
   The proof obligations and pack contracts are strong: acyclic from-scratch equivalence, deterministic replay, SCC correctness, dynamic dependency soundness, early-cutoff safety, external ordering determinism, and parallel schedule confluence all already map to concrete packs. That means the architecture should be designed to emit the exact traces those packs need, not retrofitted later.

---

## 2. Design options

### Option A — Conservative snapshot-rebuild core

Immutable `DocSnapshot`; structural refs/deps rebuilt on every structural or formula-shape change; runtime dynamic/spill behavior carried in a short-lived overlay but any topology ambiguity falls back to full recalc.

### Option B — Layered MVCC core with epoch-scoped runtime overlays **(recommended)**

Immutable structural truth (`S/R/D`) plus per-snapshot calc arena carrying value cache, runtime dependency overlay, spill overlay, display overlay, and dirty/scheduler state. Hybrid recalc chooses full, incremental, or conservative fallback by policy.

### Option C — Specialized multi-lane engine

Structural core plus separate dynamic-topo lane, SAC-style repair lane for dynamic references, and dedicated stream/differential lane for high-update profiles.

| Option | Strengths                                                                                                            | Costs                                                                         | Best fit                       |
| ------ | -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------ |
| A      | Easiest to prove; easiest migration from current DnaVisiCalc; simplest failure model                                 | Too many full recalcs; weak concurrency payoff; visible-first mostly cosmetic | Round-0 hardening              |
| B      | Best balance of correctness, incrementality, concurrency, and seam stability; preserves engine-owned policy boundary | Moderate complexity; needs explicit publish/GC rules                          | Foundation target              |
| C      | Highest upside for edit-heavy or stream-heavy workloads                                                              | Hardest proofs, hardest migration, highest semantic-drift risk                | Later profile-gated lanes only |

Trade-off summary: A is safest but undershoots Foundation ambition; C is attractive but premature; B matches the pack’s layered model, seam evidence, and staged DAG adoption plan.

---

## 3. Recommended target architecture

**Recommend Option B:** an immutable structural kernel plus epoch-scoped runtime overlays, with the FEC/F3E seam as the evaluator boundary.

### Core shape

* `DocSnapshot[e]` is immutable and contains structure, bound references, structural dependencies, inputs, formats, entity definitions, and profile/version data. Persistent mutation remains operations-only. Identity stays ID-based, not coordinate-string-based.
* `CalcArena[e]` is mutable and ephemeral: value cache, runtime dependency overlay, spill overlay, display overlay, effective reverse maps, dirty state, ready queues, and trace buffers. It is not persistent truth; it is an epoch-scoped derived-state arena consistent with the “inputs are truth; derived values are caches” doctrine.
* `NodeId` remains structural for semantic evaluation (`Cell`, `Name`, `Chart`), while controls stay first-class source entities through the core entity model rather than as UI-only state.

### Effective graph model

Define:

* `G_struct[e]` = structural dependency graph derived from normalized bound references in snapshot `e`
* `G_rt[e]` = runtime-observed overlay edges for dynamic refs / spill-child observation / external topics / explicit format-observation tokens
* `G_eff[e] = G_struct[e] ∪ G_rt[e]`

`G_eff[e]` is the scheduler’s truth for epoch `e`. `G_struct[e]` is the proof/oracle truth for structural semantics. Visibility is **not** part of `G_eff`; it is scheduler priority metadata only.

### Recalc modes

* **Full recalc:** structural edit, profile/version change, function-catalog change, or conservative spill fallback.
* **Incremental recalc:** value/name/external invalidation when static graph is unchanged and runtime overlay updates are bounded.
* **Hybrid recalc:** incremental by default, but promote specific subgraphs or SCCs to conservative rebuild when runtime topology or spill shape crosses a policy threshold.
* **Pure-calc fast path:** nodes whose evaluation does not require overlay mutation can bypass overlay write-back and commit only value/display changes. For dynamic-reference nodes, a second fast path exists when execution proves the observed dependency set and spill state are unchanged, making overlay write-back a no-op.

### Publication unit

Use a **per-node atomic commit bundle**:
`CalcCommitBundle = {value_delta, topology_delta, shape_delta, display_delta?}`

A node either publishes the whole bundle or nothing. Cross-node visibility may remain partial within an epoch, but that is already supported by the epoch/stale model: queries can observe some nodes at `value_epoch = committed_epoch` while others remain stale until `stabilized_epoch` catches up. This cleanly resolves the “what changes together?” question without requiring epoch-wide batch publication for every node.

---

## 4. Normative contract draft

### Key types / interfaces

```text
type SnapshotEpoch = u64
type FormulaStableId = opaque
type FormulaToken = u64
type EvalSessionId = opaque
type CapabilityBindingHash = u128

type PreparedPlan = {
  formula_stable_id,
  parsed_formula,
  bound_static_refs,
  required_capabilities,
  pure_calc_class,       // StaticPure | StaticShape | DynamicObserved
  profile_id,
  profile_version
}

prepare(formula_text, bind_ctx, bounds, profile) -> PreparedPlan
install_plan(formula_id, PreparedPlan) -> FormulaToken

open_session(formula_id, expected_token?, snapshot_epoch) -> EvalSessionId
capability_view(session_id, required_caps) -> FecCapabilityView

execute(session_id, eval_request) -> EvalTransaction
commit(EvalTransaction) -> CommitResult
```

This draft stays aligned with the implemented transactional seam shape and with the OxFml/OxFunc/FEC ownership split: OxFml owns parse/bind, OxFunc owns value semantics, and FEC owns protocol/capability/dependency lifecycle/scheduler interaction/publication lifecycle.

### Commit result / reject taxonomy

```text
CommitStatus =
  | Applied
  | RejectedSessionNotFound
  | RejectedFormulaNotRegistered
  | RejectedFormulaMismatch
  | RejectedExpectedTokenMismatch
  | RejectedTransactionTokenMismatch
  | RejectedCapabilityNotBound
  | RejectedCapabilityDecisionMismatch
  | RejectedCapabilityDenied
  | RejectedSnapshotConflict(SessionMismatch | CoordinatorFenceMismatch)
```

Normative rule: `commit` is **never partially applied**. Rejected commit publishes no value, no topology delta, no spill delta, no display delta. Reject detail must include expected/actual token where relevant, expected/actual snapshot epoch where relevant, coordinator epoch for fence failures, and denied capability where relevant.

### Required deltas / events

**Required FEC/F3E seam payloads**

* `value_delta`
* `shape_delta`
* `topology_delta`

**Required topology fields**

* `cells`
* `name_ids`
* `spill_children`
* `impacted node set`
* `TopologyImpact = None | DependencySetChanged | SpillRangeChanged | SpillBlocked`

**Required shape fields**

* `spill_event = None | SpillTakeover | SpillClearance | SpillBlocked`
* entered/exited cells or old/new range context
* anchor identity

**Required core publication extension**

* `display_delta` is **core-owned**, not FEC-owned by default. It exists because display depends on value plus format even though formatting is metadata-only for formula semantics. If absent, display is recomputed in a downstream sink stage from current value+format tokens.

### Epoch / token rules

1. `prepare` is not snapshot-bound.
2. `install_plan` mints or advances `FormulaToken` whenever the registered plan changes.
3. `open_session` binds `(formula_id, expected_token?, snapshot_epoch)`.
4. `capability_view` produces a session-bound capability decision; `commit` must validate the same bound decision.
5. `execute` must emit a transaction tagged with the same `snapshot_epoch` and `FormulaToken`.
6. `commit` is accepted **iff**:

   * session snapshot = transaction snapshot
   * coordinator publish fence = session snapshot
   * expected token (if supplied) matches current token
   * transaction token matches current token
   * capability binding is present and identical
7. On `Applied`, the node’s `value_epoch = snapshot_epoch`.
8. `stabilized_epoch` advances only when the epoch’s required dirty frontier reaches terminal state.
9. Any structural edit or formula re-install on a newer committed epoch fences off older in-flight sessions; their commits must deterministically reject with snapshot or token mismatch, not silently publish into the new world.

---

## 5. Recalc and overlay semantics

### Structural dependency graph rules

* Build the structural graph from normalized references produced by bind. References must remain explicit as `CellRef`, `RegionRef`, `NameRef`, `ExternalRef`, or `ErrorRef`; unresolved references are explicit, not silently dropped.
* Structural edits create a new snapshot and deterministic rewrite traces. Invalidated targets remain explicit. Rewrite semantics for rows/columns, ranges, names, and `A1#` spill references stay deterministic and traceable.
* For current Foundation staging, structural edits should default to full or affected-scope rebuild rather than speculative dynamic-topo maintenance. Dynamic topo is a near-term prototype lane, not baseline doctrine.

### Calc-time overlay rules

* Runtime overlay entries are keyed by `(snapshot_epoch, node_id, formula_token)`. They are invalid outside that triple.
* Overlay content may include dynamic cell edges, name-id edges, spill-child edges, external topic edges, and explicit format-observation tokens.
* Overlay update is **replace-then-diff** at node commit: old observed set is removed, new observed set is installed, reverse maps are updated atomically, and `TopologyImpact` is emitted from the diff.
* If observed dependencies are unchanged and value/shape/display are unchanged, downstream propagation may be suppressed only under an explicit comparator policy and with trace visibility of the cutoff decision.

### Spill / format / visibility interaction rules

* Spill lifecycle is first-class. `SpillTakeover`, `SpillClearance`, and `SpillBlocked` are not inferred after the fact; they are commit-time events with invalidation scope.
* Dependents of `anchor#`, explicit spill-child observers, and display sinks for entered/exited cells invalidate on spill topology change even if the anchor formula text itself is unchanged.
* Formatting is non-semantic for formula value by default. Cell-style changes invalidate display sinks, not formula values. The only value-level exception is a profile-declared formatting-observable function using explicit format tokens; ambient style dependency is disallowed by default.
* Visibility is scheduler metadata only. It may change priority class, never final value/shape/topology/display semantics. Required deterministic ready-key baseline is `(priority_class, topo_order, stable_node_id)`, with an anti-starvation rule defined by deterministic aging rather than ad hoc stealing.

---

## 6. Concurrency model

### Coordinator responsibilities

* Serialize persistent operations into new immutable snapshots.
* Maintain `committed_epoch`, `stabilized_epoch`, and current publish fence.
* Own plan registry, token registry, capability registry, and per-snapshot calc arenas.
* Open sessions, validate capability views, accept commit bundles, update reverse maps, publish node bundles, and advance `stabilized_epoch`.
* Cancel or orphan obsolete work when a newer committed epoch supersedes a snapshot.
* Enforce lock discipline: no awaiting or user callbacks while holding mutation-critical locks.

### Snapshot fences

* Workers evaluate against immutable `DocSnapshot[e]`; they do not mutate core state.
* Session fence tuple: `(formula_id, formula_token, snapshot_epoch, capability_binding_hash)`.
* Commit fence tuple: session fence plus coordinator current publish fence.
* Structural edit on epoch `e+1` fences off all `e` sessions from publishing into the new active world.
* Query paths may either pin an old snapshot or ask for current-state values plus stale/pending status; the explicit epoch model is already the user-visible contract surface.

### Contention / retry behavior

* Current DnaVisiCalc API is only concurrent across handles; a single handle is not concurrently accessible. Foundation therefore needs a new coordinator model rather than “turn on threads” in the current handle-level contract.
* Recommended worker model: one live evaluation lease per `(snapshot_epoch, node_id)`; concurrency is across independent ready nodes, not same-node duplication.
* If a newer epoch arrives during evaluation, old sessions reject deterministically with snapshot conflict. Retry policy is engine-owned: reopen against latest snapshot if the dirty reason is still live.
* Visible-first uses deterministic aging to prevent starvation: hidden-ready nodes gain age buckets based on stable enqueue order and global dispatch count, so policy changes scheduling latency but not semantics.

---

## 7. Adoption roadmap

### Phase 1 — Freeze the semantic bundle

* Promote a Foundation contract for `CalcCommitBundle`, reject taxonomy, epoch/token rules, and required trace fields.
* Keep current b4 seam as the starting authority, not a fresh rewrite.

### Phase 2 — DnaVisiCalc compatibility shim

* Preserve the public DVC API and map current change-journal entries into the new publication bundle model.
* Keep existing change entry kinds (`CellValue`, `NameValue`, `ChartOutput`, `SpillRegion`, `CellFormat`, `Diagnostic`) as the outward delta surface while the internal coordinator changes underneath.

### Phase 3 — Split structural truth from calc arena

* Introduce immutable `DocSnapshot` and structural `S/R/D` materialization.
* Move runtime-observed dependencies and spill state out of the structural graph into overlays.
* Keep full-recalc fallback for any structural edit or unresolved overlay ambiguity.

### Phase 4 — Incremental overlay lane

* Turn on runtime dependency delta application, name-id incremental routing, spill topology invalidation, and pure-calc fast path.
* Retain conservative spill fallback as an always-available policy escape hatch.

### Phase 5 — Concurrent coordinator pilot

* Add multi-worker evaluation over immutable snapshots, deterministic ready queues, and optional visible-first policy disabled by default.
* Require a contention replay harness before enabling by profile.

### Phase 6 — Assurance promotion

* Bind the architecture to Green-owned packs, proofs, and artifacts; Track B remains the real exit gate, not mere implementation existence.

### Compatibility shims

* **DVC API shim:** preserve epochs, stale visibility, manual/automatic recalc surface, volatility split, spill queries, and change tracking.
* **Seam shim:** current `prepare/install/open_session/capability_view/execute/commit` maps directly to the new coordinator.
* **F3C alias shim:** if another lane says `F3C`, treat it as the evaluator-side endpoint behind the same FEC contract.
* **Policy shim:** default profile runs with visible-first off and conservative spill fallback on.

### Blocker gates

* frozen trace schema
* frozen reject taxonomy
* snapshot-conflict contention pack
* dynamic dependency soundness pack
* spill invalidation pack
* parallel determinism signature
* canonical publication bundle docs in Foundation source-of-truth

---

## 8. Open questions and decisive experiments

1. **Per-node atomic publish vs wave-batch publish**
   Experiment: compare query consistency and latency under partial per-node publish vs SCC-wave batch publish, while preserving current stale/pending semantics. Success criterion: no semantic divergence and better user-visible freshness.

2. **Overlay retention / GC policy**
   Experiment: long-running dynamic-reference workbooks with snapshot pinning. Measure reuse ratio, memory, and rejected stale-session counts. Success criterion: bounded retained memory with zero incorrect reuse.

3. **Dynamic-topo promotion threshold**
   Run `PACK.dag.dynamic_topo_vs_rebuild`. Promote only if correctness parity is 100% and median latency improves without higher fallback/rollback rate.

4. **Visible-first semantic equivalence**
   Replay identical op streams under `priority_policy=None` and `priority_policy=VisibleFirst`. Success criterion: bit-identical stabilized outputs and bounded starvation.

5. **Display overlay placement**
   Compare “display as downstream sink graph” vs “display fields inside value bundle.” Success criterion: smaller invalidation scope and better explainability without formula-semantic coupling.

6. **FEC pre-resolution vs F3E execution ownership**
   Target `INDIRECT`, `OFFSET`, `LAMBDA`, `MAP`, spill growth/shrink, and stream cases. Success criterion: exact ownership boundary with no duplicated bind logic and no missing runtime dependency evidence.

7. **Concurrent commit interleaving**
   Structural edit racing with long dynamic-reference evaluation. Success criterion: only typed snapshot/token rejects; no mixed-world publish; deterministic replay hash stable.

---

## 9. Pack / proof checklist

Use this as the concrete readiness checklist.

* **P1. Operations-only mutation**
  Verify evaluator commit never mutates structural truth or OpLog. Pass artifact: proof/trace showing only coordinator changes persistent state.

* **P2. Snapshot fence correctness**
  `commit` rejects on any session/tx/coordinator snapshot mismatch. Pass artifact: deterministic contention replay corpus plus reject traces.

* **P3. Token fence correctness**
  Old plan token can never publish after re-install. Pass artifact: token mismatch cases with zero partial publishes.

* **P4. Capability fence correctness**
  Capability decisions are session-bound and commit-validated. Pass artifact: denied/mismatch traces with typed rejects.

* **P5. Acyclic equivalence**
  Incremental = full recompute on acyclic graphs. Bind to `DAG-PO-001`.

* **P6. Deterministic replay**
  Identical op stream yields identical values/errors. Bind to `DAG-PO-002`.

* **P7. SCC / iterative determinism**
  SCC partition correctness and bounded iterative determinism. Bind to `DAG-PO-003/004` and `PACK.dag.cycle_iterative_semantics`.

* **P8. Dynamic dependency soundness**
  Recorded dependency-set unchanged ⇒ result unchanged on supported subset; dynamic lane equals from-scratch reevaluation. Bind to `DAG-PO-006/007` and `PACK.dag.dynamic_dependency_bind_semantics`.

* **P9. Early-cutoff safety**
  No incorrect downstream suppression. Bind to `DAG-PO-008` and `PACK.dag.early_cutoff.signature`.

* **P10. Parallel determinism**
  Bit-identical outputs across thread-count matrix under canonical reduction policy. Bind to `DAG-PO-010` and `PACK.dag.parallel_determinism_signature`.

* **P11. Structural rewrite + spill rules**
  Deterministic rewrite classification, explicit invalidation, valid-but-rejected spill-boundary edits, no partial mutation. Pass artifact: structural rewrite traces and reject-context traces.

* **P12. Required emitted artifacts**
  Canonical operation trace, value-commit trace, reference-grid delta trace, spill topology trace, capability/reject trace, cycle iteration trace, replay hashes, and pack result index. This follows Foundation’s trace/artifact doctrine and the promoted pack contracts.

Net recommendation: **conditionally accept the current FEC/F3E seam as Foundation input, but only inside Option B’s layered MVCC architecture, with snapshot/token fencing promoted to a first-class coordinator contract, spill invalidation algebra made normative, and visible-first kept explicitly policy-only until equivalence packs exist.**
