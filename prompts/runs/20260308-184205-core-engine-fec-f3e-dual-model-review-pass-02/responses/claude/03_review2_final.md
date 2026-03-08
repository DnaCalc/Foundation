I now have comprehensive knowledge of all source files. Let me produce the second-pass critique and final revised answer.

---

## SECOND-PASS CRITIQUE

### Defects in prior answer (Pass-01 GPT memo)

| # | Severity | Defect | Detail |
|---|----------|--------|--------|
| C1 | **Critical** | Missing deliverables 1–9 | The prior answer is a reconnaissance memo, not the required deliverable-ordered output. None of the nine required sections (Findings, Design Options, Target Architecture, Normative Contract Draft, Recalc/Overlay Semantics, Concurrency Model, Adoption Roadmap, Open Questions, Pack/Proof Checklist) are present. |
| C2 | **High** | No design options or trade-off matrix | The prompt requires 2–3 coherent design options with explicit trade-offs; the prior answer offers none. |
| C3 | **High** | No normative contract text | The prompt requires key types/interfaces, commit result/reject taxonomy, epoch/token rules. Prior answer only references them narratively. |
| C4 | **High** | No overlay/recalc semantics section | Structural dependency graph rules, calc-time overlay rules, spill/format/visibility interaction rules are absent. |
| C5 | **High** | No concurrency model section | Coordinator responsibilities, snapshot fences, contention/retry behavior are absent. |
| C6 | **Medium** | Incomplete coverage of DAG research synthesis | Transfer matrix (doc 04), conformance obligations (doc 10), and empirical packs (doc 11) are not incorporated. |
| C7 | **Medium** | No adoption roadmap with phased gates | The prior answer lists gaps but does not propose phases, shims, or blocker gates. |
| C8 | **Medium** | Formatting/visibility overlay omitted | DEC-CALC-007 (formatting-sensitive overlay) and DEC-CALC-008 (visibility-first optional policy) are not analyzed. |
| C9 | **Low** | F3C terminology note is correct but shallow | The prior answer correctly notes no F3C token exists; this is sufficient. |

### Remaining risks/gaps for the final answer

| # | Risk | Mitigation in final answer |
|---|------|---------------------------|
| R1 | Pure-calc fast-path guard conditions are underspecified in sources | Flag as open question; propose guard invariant sketch. |
| R2 | Overlay retention/eviction semantics have no source-level specification | Flag as gap; propose epoch-pinned eviction rule. |
| R3 | Parallel reduction determinism is asserted but not mechanized | Bind to DAG-PO-010 and PACK.dag.parallel_determinism_signature. |
| R4 | Causal callgraph fidelity is explicitly deferred in b4 | Carry forward as open item. |

---

## FINAL REVISED ANSWER

# Core DAG Recalc + FEC/F3E Seam — Design Synthesis Report

**Source authority**: all files under `inputs/source/`. Terminology: FEC/F3E consistently; no F3C token found in source set.

---

## 1. Findings (ordered by severity)

### 1.1 Critical

**F-CRIT-1: Deliverable-ready concurrency model is absent.**
The coordinator is single-thread oriented (REDESIGN_OBSERVATIONS:L20). No contention replay harness exists (REDESIGN_SPEC:L100). Multi-session commit conflict resolution policy is unspecified. Without this, epoch/MVCC snapshot semantics (ARCHITECTURE:§3.3) cannot be validated under parallel recalc.

**F-CRIT-2: Overlay lifecycle boundaries are undefined.**
The layered model (CORE_ENGINE_FORMAL_MODEL:§6.2) declares S→R→D→V layers, and the design draft (synthesis-context:L21–25) adds calc-time overlay, spill overlay, and format overlay. But no source defines: when overlays are created, when they are published to snapshot consumers, or when they are evicted. This blocks epoch-safe GC (synthesis-context:L52).

### 1.2 High

**F-HIGH-1: Identity drift between evidence and spec.**
Evidence summary lists both `FecFormulaStableId` and `FecFormulaId` (IMPL_EVIDENCE:L28), while the redesign spec normalizes on `FecFormulaId` with `stable_id()` accessor (REDESIGN_SPEC:L19). Dependency deltas in evidence use `names` (IMPL_EVIDENCE:L31); spec uses `name_ids` (REDESIGN_SPEC:L31–32). This must be reconciled before Foundation contract freeze.

**F-HIGH-2: Spill event vocabulary drift.**
EXAM_SUMMARY still uses `spill_shape_delta=created/cleared` (EXAM_SUMMARY:L26–27); b4 spec requires typed objects `SpillTakeover|SpillClearance|SpillBlocked` (REDESIGN_SPEC:L37–40). The compact evidence summary is updated (IMPL_EVIDENCE:L33), but trace artifacts lag.

**F-HIGH-3: Scope gap — structural rewrites, controls, charts, formatting.**
DnaVisiCalc v0 scope includes structural rewrites (SPEC_v0:L15), controls/charts (ENGINE_REQUIREMENTS:L232–243), change tracking, and formatting (ENGINE_REQUIREMENTS:L221, L257). FEC/F3E seam only covers formula evaluation. Foundation core needs explicit adapter or extension contracts for these.

**F-HIGH-4: Callgraph fidelity.**
Current callgraph is adjacency-derived (REDESIGN_OBS:L22, REDESIGN_SPEC:L101). Causal attribution is needed for precise incremental invalidation of dynamic-dependency chains and for conformance artifact quality.

### 1.3 Medium

**F-MED-1: Pure-calc fast-path guards unspecified.** (synthesis-context:L54)
**F-MED-2: Published-state semantics during in-flight recalculation unspecified.** (synthesis-context:L57)
**F-MED-3: Formatting-sensitive overlay interaction rules provisional.** DEC-CALC-007 (synthesis-context:L31–34) sets direction but no invariant text exists.
**F-MED-4: Scheduler policy variation proof obligation not bound.** DEC-CALC-008 requires visible-first to preserve determinism; no proof obligation row covers this (synthesis-context:L79).

---

## 2. Design Options with Trade-off Matrix

### Option A: Conservative Layered (Baseline-First)

**Approach**: Strict layered model. Full rebuild as default recalc. FEC/F3E seam adopted as-is with minimal extension. Single-coordinator thread with explicit mutex for epoch advancement. Overlays are ephemeral per-recalc-cycle.

- Structural layer (S): immutable green-tree with ID-based identity.
- Reference layer (R): rebuilt on structural edit; bind context per CORE_ENGINE_FORMAL_MODEL:§6.3.
- Dependency layer (D): rebuilt from R after each structural change; static + observed dynamic edges.
- Value layer (V): full topological recompute; early-cutoff optional.
- Overlays: spill regions rebuilt each cycle; format tokens attached per DEC-CALC-007; visibility metadata maintained but not used for scheduling.

**FEC/F3E**: Adopted as internal seam with shim adapter to DvcEngine API. No multi-session concurrency.

### Option B: Incremental Overlay (Recommended Target)

**Approach**: Layered model with persistent overlays and incremental maintenance. Calc-time overlay survives across recalc cycles with epoch-tagged validity. FEC/F3E seam extended with explicit overlay mutation protocol. Coordinator supports concurrent sessions with snapshot fencing.

- S: immutable green-tree, spine-respin on structural edits.
- R: incremental rebind on structural deltas (affected scope only).
- D: persistent with incremental edge-set maintenance via FEC topology_delta.
- V: incremental dirty-closure recalc (topo+SCC baseline); full rebuild as fallback.
- Calc-time overlay: persistent observed-dependency graph, epoch-tagged, with explicit invalidation on dependency-set changes.
- Spill overlay: persistent with explicit lifecycle events (SpillTakeover/Clearance/Blocked) driving targeted invalidation.
- Format overlay: explicit format-dependency tokens per DEC-CALC-007; invalidated on style/format edits.
- Visibility overlay: optional scheduling priority per DEC-CALC-008; deterministic queue key preserved.

**FEC/F3E**: Extended with overlay-aware commit protocol. Multi-session coordinator with snapshot fence and bounded retry.

### Option C: Ambitious Differential (Future-Oriented)

**Approach**: All of Option B plus differential/timely dataflow integration for external streams and SAC-inspired trace repair for dynamic dependencies. Semiring provenance for explainability.

- Adds: differential update lane for STREAM/RTD-heavy profiles.
- Adds: SAC trace repair for INDIRECT-class dynamic dependencies.
- Adds: semiring provenance pilot for dependency trace reasoning.

**Complexity**: Significantly higher. Requires substantial theory-to-implementation transfer.

### Trade-off Matrix

| Criterion | A: Conservative | B: Incremental | C: Differential |
|-----------|:-:|:-:|:-:|
| Implementation complexity | Low | Medium | High |
| Recalc performance (large sheets) | Poor (full rebuild) | Good (incremental) | Best (targeted) |
| Concurrency support | None | Yes (bounded) | Yes (full) |
| Dynamic dependency correctness | Rebuild-safe | Overlay-tracked | SAC-repaired |
| Spill invalidation precision | Coarse | Targeted | Targeted |
| Formal verification burden | Low | Medium | High |
| Migration from DnaVisiCalc | Direct shim | Phased adoption | Requires substantial new infra |
| External stream handling | Polling/rebuild | Epoch-batched | Differential/streaming |
| Time to first conformance pack | Shortest | Medium | Longest |
| DAG-PO coverage achievable | PO-001..004 | PO-001..008 | PO-001..010 |

**Recommendation**: **Option B** as target architecture. Option A as Phase 0 stepping stone. Option C elements adopted selectively in later rounds per profile need.

---

## 3. Recommended Target Architecture

### 3.1 Layer Model

```
Layer S  (Structure):    Immutable green-tree. ID-based (RowId/ColId/CellId/NameId/ChartId).
                         Spine-respin on structural edits. Coordinate projection derived.

Layer R  (References):   BoundRef graph derived from S + bind context.
                         Incremental rebind on structural deltas.
                         Forward/reverse dependency indices explicit.
                         Unresolved/error references explicit.

Layer D  (Dependencies): Persistent dependency graph with NodeId vertices.
                         Static edges from R. Dynamic edges from calc-time observation.
                         SCC decomposition maintained incrementally.
                         Invalidation states: clean | stale | necessary | recomputed.

Layer V  (Values):       Epoch-tagged per-node values.
                         Commit via FEC/F3E seam (formula nodes) or direct engine eval.
                         Early-cutoff propagation suppression.

Overlay C (Calc-time):   Observed dynamic dependencies (INDIRECT/OFFSET targets).
                         Epoch-tagged validity. Invalidated on dependency-set-changed events.
                         Merged into D for scheduling; separable for GC.

Overlay P (Spill):       Spill region topology.
                         Lifecycle: SpillTakeover | SpillClearance | SpillBlocked.
                         Drives targeted invalidation of spill children + observers.

Overlay F (Format):      Format-dependency tokens per DEC-CALC-007.
                         Invalidated on style/conditional-format edits.
                         Profile-gated (provisional).

Overlay W (Visibility):  visible_regions, visible_nodes, visibility_version.
                         Optional scheduling priority. Does not alter final values.
                         Deterministic queue key: (priority_class, topo_order, stable_node_id).

Cross-cutting O (Operations): Exclusive persistent mutation pathway.
                               OpEnvelope with epoch/profile/causality metadata.
```

### 3.2 Calculation Pipeline

```
parse → bind → dependency_update → invalidation_closure → schedule → evaluate → commit → publish
         ↓              ↓                    ↓                ↓          ↓          ↓
     Layer R         Layer D            Overlay C+P        Topo+SCC   FEC/F3E    Layer V
                                        Overlay F                    seam
```

### 3.3 FEC/F3E Seam Position

FEC/F3E is the **formula evaluation boundary** between the engine scheduler and the formula evaluator:

```
Engine (scheduler/coordinator)
  │
  ├── prepare(formula_text, bounds, ctx) → FormulaPlan
  ├── install_plan(formula_id, plan) → FormulaToken
  │
  │ ┌─ Per evaluation cycle: ──────────────────────────┐
  │ │  open_session(formula_id, token, snapshot_epoch)  │
  │ │  capability_view(session_id, required_caps)       │
  │ │  execute(evaluator, eval_request)                 │
  │ │  commit(eval_transaction) → CommitResult          │
  │ └──────────────────────────────────────────────────┘
  │
  └── Engine consumes: value_delta, shape_delta, topology_delta
      Engine owns: recalc policy, scheduling, overlay management
```

---

## 4. Normative Contract Draft

### 4.1 Key Types

```
// Identity
type Epoch         = u64
type NodeId        = Cell(CellId) | Name(NameId) | Chart(ChartId)
type FecFormulaId  = opaque { stable_id() → FecFormulaStableId }
type FecNameId     = opaque
type FecRangeId    = opaque
type FormulaToken  = opaque  // monotonic, issued by install_plan

// Session
type EvalSessionId = opaque
type SnapshotEpoch = Epoch

// Capability
type FecCapabilityTag      = enum { ReadCell, ReadName, ReadRange, Spill, ... }
type FecCapabilityDecision = Granted | Denied(reason)
type FecCapabilityView     = Map<FecCapabilityTag, FecCapabilityDecision>

// Evaluation
type EvalRequest     = { session_id, formula_id, input_snapshot }
type EvalTransaction = { session_id, result, observations }
type EvalObservation = { observed_deps: F3eObservedDependencies, ... }

// Commit result
type CommitResult = {
    status:         CommitStatus,
    value_delta:    FecValueDelta,
    shape_delta:    FecShapeDelta,
    topology_delta: FecTopologyDelta,
    reject_detail?: CommitRejectDetail,
}

type CommitStatus = Applied | Rejected(CommitRejectClass)
```

### 4.2 Commit Reject Taxonomy

```
CommitRejectClass =
  | RejectedSessionNotFound
  | RejectedFormulaNotRegistered
  | RejectedFormulaMismatch
  | RejectedExpectedTokenMismatch
  | RejectedTransactionTokenMismatch
  | RejectedCapabilityNotBound
  | RejectedCapabilityDecisionMismatch
  | RejectedCapabilityDenied
  | RejectedSnapshotConflict        // session vs coordinator epoch mismatch

CommitRejectDetail = {
    reject_class:     CommitRejectClass,
    expected_token?:  FormulaToken,
    actual_token?:    FormulaToken,
    expected_epoch?:  Epoch,
    actual_epoch?:    Epoch,
    coordinator_epoch?: Epoch,
    denied_cap?:      FecCapabilityTag,
}
```

**Invariant**: `commit` is total — it always returns `CommitResult`, never panics. Reject detail is machine-typed and sufficient for deterministic retry or escalation decisions.

### 4.3 Required Deltas/Events

```
FecValueDelta = {
    value_changed: bool,
    prior_value?:  CellValue,
    new_value:     CellValue,
}

FecShapeDelta = {
    spill_event: SpillDeltaEvent,
}

SpillDeltaEvent =
  | None
  | SpillTakeover  { anchor, entered_cells, prior_owner? }
  | SpillClearance  { anchor, exited_cells }
  | SpillBlocked    { anchor, blocked_at, blocking_cell }

FecTopologyDelta = {
    dep_delta_cells:       Set<CellId>,    // cell dependency changes
    dep_delta_name_ids:    Set<FecNameId>,  // name dependency changes
    dep_delta_spill_children: Set<CellId>, // spill-child dependency changes
    impacted_cells:        Set<CellId>,
    impacted_name_ids:     Set<FecNameId>,
    topology_impact:       TopologyImpact,
}

TopologyImpact =
  | None
  | DependencySetChanged
  | SpillRangeChanged
  | SpillBlocked
```

### 4.4 Epoch/Token Rules

| Rule | Statement |
|------|-----------|
| E1 | `committed_epoch` advances monotonically on each accepted operation. |
| E2 | `stabilized_epoch` advances to `committed_epoch` only when all dirty nodes in scope reach `clean` or terminal error. |
| E3 | `value_epoch` per node records the epoch at which its value was last recomputed. |
| E4 | `open_session` captures `snapshot_epoch`. `commit` validates `session.snapshot_epoch == coordinator.current_epoch`. Mismatch → `RejectedSnapshotConflict`. |
| E5 | `FormulaToken` is monotonic per formula. `commit` validates `transaction.token == formula.current_token`. Mismatch → `RejectedExpectedTokenMismatch`. |
| E6 | No stale commit: a value may only be published if its input epoch matches the session's snapshot epoch. |
| E7 | Structural commits are exclusive: no concurrent formula evaluation during structural edit application. |

---

## 5. Recalc and Overlay Semantics

### 5.1 Structural Dependency Graph Rules

1. **Construction**: D is derived from R. For each `BoundRef` in a formula's parsed/bound form, a directed edge `(source_node → target_node)` is added. Forward and reverse indices are maintained.
2. **SCC decomposition**: Maintained over D. Acyclic SCCs evaluate in topological order. Cyclic SCCs evaluate in profile-governed mode (`CycleError` or `Iterative` with bounded iterations and epsilon).
3. **Structural edit impact**: On structural edit (insert/delete row/col), R is incrementally rebound (affected scope per rewrite maps `μ_row`, `μ_col`). D is incrementally updated from R delta. Full D rebuild is the conservative fallback.
4. **Identity stability**: Nodes are identified by `NodeId` (ID-based), not by coordinate. Structural edits rewrite coordinate projections but preserve node identity.

### 5.2 Calc-time Overlay Rules

1. **Observed dependencies**: During `f3e.execute`, the evaluator records all runtime-discovered dependencies (INDIRECT targets, OFFSET results, computed range references) in `F3eObservedDependencies`.
2. **Overlay merge**: On `commit`, `topology_delta` carries the observed dependency changes. The engine merges these into the persistent dependency graph (Layer D + Overlay C).
3. **Invalidation**: When `topology_impact == DependencySetChanged`, the engine must re-run dirty-closure propagation from the affected node using the updated dependency set.
4. **Epoch tagging**: Each observed-dependency record is tagged with the epoch at which it was observed. Records from epochs older than `stabilized_epoch - retention_window` are eligible for eviction.
5. **Pure-calc guard**: A formula evaluation is eligible for the pure-calc fast path if and only if: (a) no dynamic dependencies were observed in the prior evaluation, (b) no spill participation, (c) no format-dependency tokens, and (d) all input dependencies are `clean`. Pure-calc evaluations may bypass session/capability overhead.

### 5.3 Spill/Format/Visibility Overlay Interaction Rules

**Spill overlay (P)**:
1. Spill region topology is maintained as a set of `(anchor_cell, spill_range)` pairs.
2. `SpillTakeover` invalidates: (a) all entered cells (prior content → spill child), (b) all observers of entered cells, (c) the anchor's own observers.
3. `SpillClearance` invalidates: (a) all exited cells (spill child → empty/restored), (b) all observers of exited cells.
4. `SpillBlocked` marks the anchor with `#SPILL!` error and invalidates the anchor's observers.
5. Spill invalidation algebra: `prior_spill_region ⊕ current_spill_region` yields entered/exited cell sets. This is the invalidation input.

**Format overlay (F)** (per DEC-CALC-007):
1. Format-dependency tokens are attached to formulas that call formatting-observable functions (e.g., `TEXT(value, format_text)` where format comes from cell style).
2. Token invalidation occurs on: conditional-format rule edit, cell style edit, or profile format-policy change.
3. Format overlay invalidation feeds into standard dirty-closure propagation.

**Visibility overlay (W)** (per DEC-CALC-008):
1. `visible_regions` and `visible_nodes` are maintained by UI/host and communicated to engine.
2. Under visible-first policy, scheduler uses deterministic queue key: `(priority_class, topo_order, stable_node_id)` where `priority_class = 0` for visible nodes, `1` for non-visible.
3. **Invariant**: Visible-first alters only scheduling order, never final computed values. Same inputs → same outputs regardless of visibility state.
4. **Starvation prevention**: Non-visible nodes must advance within bounded delay (configurable fairness window).

---

## 6. Concurrency Model

### 6.1 Coordinator Responsibilities

The coordinator is the single authority for:
- Epoch advancement (monotonic `committed_epoch`).
- Snapshot fence: current coordinator epoch for commit validation.
- Session registry: active `EvalSessionId` tracking.
- Recalc policy selection: full vs incremental vs hybrid.
- Overlay merge serialization: topology_delta application is sequenced.
- Stabilization tracking: when all dirty nodes are resolved, advance `stabilized_epoch`.

### 6.2 Snapshot Fences

```
Invariant SF-1: coordinator.snapshot_fence == committed_epoch at session open time.
Invariant SF-2: commit validates session.snapshot_epoch == coordinator.snapshot_fence.
Invariant SF-3: structural edits bump committed_epoch and invalidate all open sessions
                (sessions opened against prior epoch will be rejected at commit).
Invariant SF-4: Between structural edit start and completion, no new formula sessions may open.
```

### 6.3 Contention/Retry Behavior

| Scenario | Behavior | Policy |
|----------|----------|--------|
| Concurrent formula evaluations (same epoch) | Allowed; each opens independent session against same snapshot_epoch. | Parallel evaluation permitted. |
| Commit after epoch advance (structural edit interleaved) | `RejectedSnapshotConflict`. | Evaluator must re-open session against new epoch and re-evaluate. Bounded retry count (profile-configurable, default 3). |
| Concurrent structural edits | Serialized via exclusive lock. Second edit blocks until first completes. | Structural exclusivity rule (E7). |
| Session timeout | Sessions older than `max_session_age` are evicted. Commit returns `RejectedSessionNotFound`. | Prevents resource leak. |
| Deterministic contention replay | Commit conflict interleavings must be replayable with deterministic outcome given same operation ordering. | Required for conformance (DAG-PO-002). |

### 6.4 Concurrency Phases (Target)

**Phase 0** (DnaVisiCalc): Single-thread coordinator. Sequential recalc. No concurrent sessions.
**Phase 1** (DnaPreCalc): Multi-session coordinator with `Arc`/mutex. Parallel formula evaluation within one recalc cycle. Sequential structural edits.
**Phase 2** (DnaSuperCalc): Lock-free epoch advancement. Work-stealing scheduler. Visible-first priority.
**Phase 3** (DnaCalc): Full MVCC with pinned-epoch readers. Concurrent structural edits with OCC. Differential streams.

---

## 7. Adoption Roadmap

### Phase 0: Conservative Baseline (Round 0 — DnaVisiCalc)

**Goal**: Validate FEC/F3E seam and baseline recalc correctness.

| Step | Action | Gate |
|------|--------|------|
| 0.1 | Reconcile identity drift: normalize on `FecFormulaId` with `stable_id()`, `name_ids` in topology_delta. | Evidence + spec alignment verified. |
| 0.2 | Reconcile spill event vocabulary: retire `created/cleared` labels; enforce typed `SpillTakeover/SpillClearance/SpillBlocked` in all traces. | Trace schema validation passes. |
| 0.3 | Implement `PACK.dag.baseline_recalc_core` and `PACK.dag.cycle_iterative_semantics`. | Packs green. |
| 0.4 | DvcEngine API adapter shim: translate between DVC_REJECT_* + dvc_last_reject_context and FEC CommitRejectDetail. | All existing DnaVisiCalc tests pass through shim. |
| 0.5 | Causal callgraph: upgrade from adjacency-derived to causally attributed. | Callgraph artifacts include causal edges. |

**Blocker gate**: PACK.dag.baseline_recalc_core green + PACK.dag.cycle_iterative_semantics green.

### Phase 1: Incremental Overlay Adoption (Round 1 — DnaPreCalc)

| Step | Action | Gate |
|------|--------|------|
| 1.1 | Persistent calc-time overlay with epoch tagging. | Overlay survives across recalc cycles; GC verified. |
| 1.2 | Implement `PACK.dag.dynamic_dependency_bind_semantics` and `PACK.dag.early_cutoff.signature`. | Packs green. |
| 1.3 | Multi-session coordinator (`Arc`/sync). | Concurrent formula eval validated. |
| 1.4 | Deterministic contention replay pack. | Replay-stable under interleaved commits. |
| 1.5 | Spill invalidation algebra implementation. | Prior/current spill region diff drives targeted invalidation. |
| 1.6 | Format overlay (DEC-CALC-007) implementation. | Format-dependent formulas invalidated on style edits. |
| 1.7 | Pure-calc fast-path implementation with guard conditions. | Fast path active; correctness parity verified. |

**Blocker gate**: All Phase 0 gates + PACK.dag.dynamic_dependency_bind_semantics green + contention replay pack green.

**Compatibility shim**: DvcEngine API adapter maintained. New Foundation API surface exposed in parallel. Callers may use either; both are validated against same conformance packs.

### Phase 2: Concurrency and Visibility (Round 2 — DnaSuperCalc)

| Step | Action | Gate |
|------|--------|------|
| 2.1 | `PACK.dag.parallel_determinism_signature` implementation. | Bit-identical outputs across thread counts. |
| 2.2 | Visible-first scheduling with starvation prevention. | DEC-CALC-008 validated. |
| 2.3 | `PACK.dag.dynamic_topo_vs_rebuild` evaluation. | Decision: adopt or defer dynamic topo maintenance. |
| 2.4 | `PACK.dag.external_stream_ordering` for STREAM/RTD profiles. | External update replay deterministic. |

### Phase 3: Advanced (Round 3 — DnaCalc)

Selective adoption of Option C elements (differential streams, SAC trace repair, semiring provenance) per profile need and empirical evidence.

---

## 8. Open Questions and Decisive Experiments

| # | Question | Decisive Experiment |
|---|----------|-------------------|
| OQ-1 | What is the canonical publication ordering when value, dependency overlay, spill overlay, and format overlay all change in one transaction? | Define and test: `commit → overlay_merge → dirty_closure → publish` sequence. Verify observers see consistent snapshot. |
| OQ-2 | Which deterministic replay schema is canonical across concurrent evaluator traces? | Implement two candidates (global-sequence vs per-node-epoch) and run PACK.dag.parallel_determinism_signature. Measure replay divergence. |
| OQ-3 | What are the exact pure-calc fast-path guard conditions? | Implement proposed guards (§5.2 rule 5) and measure false-negative rate (formulas that could have used fast path but were excluded) on realistic workbook corpus. |
| OQ-4 | Is dynamic topo maintenance worth the complexity vs full rebuild? | PACK.dag.dynamic_topo_vs_rebuild with realistic edit traces. Decision threshold: ≥2× median latency improvement with zero correctness parity violations. |
| OQ-5 | How should overlay retention/eviction interact with pinned-epoch readers? | Prototype epoch-pinned eviction with synthetic high-churn workload. Measure memory pressure and stale-read safety. |
| OQ-6 | What is the correct degradation encoding for dynamic-reference and visibility-priority edge behavior? | Define degradation class mapping (Native/Lowered/Opaque/Rejected) for each edge case. Test with profile-boundary workbooks. |
| OQ-7 | Does the FEC pre-resolution vs F3E semantic ownership boundary need to shift for structural rewrite formulas? | Test: structural rewrite that changes formula references. Trace whether FEC or engine rebinds. Determine if rebind must be in-session or pre-session. |
| OQ-8 | How should scheduler policy equivalence be proved for `None` vs visible-first? | Formalize as DAG-PO-011 candidate. Proof sketch: visible-first is a permutation of deterministic topo order; show output equivalence under associative/commutative reduction policy. |

---

## 9. Pack/Proof Checklist (Concrete and Testable)

### Proof Obligations

| ID | Statement | Phase | Pack Binding | Status |
|----|-----------|-------|-------------|--------|
| DAG-PO-001 | Acyclic from-scratch equivalence | 0 | PACK.dag.baseline_recalc_core | Ready to formalize |
| DAG-PO-002 | Deterministic replay | 0 | PACK.concurrent.epochs | Ready to formalize |
| DAG-PO-003 | SCC partition correctness | 0 | PACK.dag.cycle_iterative_semantics | Ready to formalize |
| DAG-PO-004 | Bounded iterative determinism | 0 | PACK.dag.cycle_iterative_semantics | Ready to formalize |
| DAG-PO-005 | Monotone SCC fixed-point (optional) | 2 | PACK.dag.cycle_iterative_semantics | Profile-gated |
| DAG-PO-006 | Observed dynamic-dependency soundness | 1 | PACK.dag.dynamic_dependency_bind_semantics | Draft |
| DAG-PO-007 | Dynamic from-scratch consistency | 1 | PACK.dag.dynamic_dependency_bind_semantics | Draft |
| DAG-PO-008 | Early-cutoff safety | 1 | PACK.dag.early_cutoff.signature | Draft |
| DAG-PO-009 | External update ordering/dedupe determinism | 2 | PACK.dag.external_stream_ordering | Draft |
| DAG-PO-010 | Parallel schedule confluence | 2 | PACK.dag.parallel_determinism_signature | Draft |

### Empirical Packs

| Pack | Phase | Fixtures Required | Key Threshold |
|------|-------|------------------|---------------|
| PACK.dag.baseline_recalc_core | 0 (Now) | Generated DAGs + real workbook shapes | Zero divergence vs full-recompute oracle |
| PACK.dag.cycle_iterative_semantics | 0 (Now) | SCC templates (convergent/oscillating/divergent) | Deterministic diagnostics; bounded termination |
| PACK.dag.dynamic_topo_vs_rebuild | 1 (Next) | Sparse DAGs + edit traces | 100% correctness parity; latency improvement ≥ declared margin |
| PACK.dag.dynamic_dependency_bind_semantics | 1 (Next) | INDIRECT/OFFSET scenarios + static controls | Zero stale-read violations; from-scratch equivalence |
| PACK.dag.early_cutoff.signature | 1 (Next) | Long chains + branch-heavy models | Zero incorrect suppressions |
| PACK.dag.parallel_determinism_signature | 2 (Later) | Wide/deep DAGs + FP aggregation stress | Bit-identical across thread counts |
| PACK.dag.external_stream_ordering | 2 (Later) | Topic streams with dupes/reordering | Zero replay divergence |

### Conformance Rows

| Row | Requirement | Pack | Readiness |
|-----|-------------|------|-----------|
| DAG-CONF-001 | Deterministic recalc order metadata emitted | PACK.visicalc.core | Draft |
| DAG-CONF-002 | SCC/cycle diagnostics include membership + mode | PACK.dag.cycle_iterative_semantics | Draft |
| DAG-CONF-003 | Dynamic-dep formulas emit per-wave dependency trace | PACK.dag.dynamic_dependency_bind_semantics | Draft |
| DAG-CONF-004 | Early-cutoff decisions observable via trace fields | PACK.dag.early_cutoff.signature | Draft |
| DAG-CONF-005 | External update envelopes replayable with deterministic dedupe | PACK.dag.external_stream_ordering | Draft |
| DAG-CONF-006 | Parallel runs at fixed profile/seed produce bit-identical values | PACK.dag.parallel_determinism_signature | Draft |
| DAG-CONF-007 | Dynamic-topo lane publishes fallback counts + parity checks | PACK.dag.dynamic_topo_vs_rebuild | Draft |
| DAG-CONF-008 | Iterative cycle mode declares fixed-point vs bounded-pragmatic | PACK.dag.cycle_iterative_semantics | Draft |

### New Items Proposed by This Synthesis

| ID | Item | Type |
|----|------|------|
| FEC-CONF-001 | FEC commit reject detail is machine-parseable and deterministic across implementations | Conformance row |
| FEC-CONF-002 | Spill events use typed objects (not string labels) in all traces | Conformance row |
| FEC-CONF-003 | Identity drift reconciled: single `FecFormulaId` with `stable_id()` accessor; `name_ids` not `names` | Pre-freeze gate |
| DAG-PO-011 (candidate) | Visible-first scheduling permutation preserves output equivalence | Proof obligation |
| PACK.fec.contention_replay | Deterministic outcome under interleaved multi-session commits | Empirical pack |
| PACK.fec.overlay_lifecycle | Overlay creation/publish/eviction epoch correctness | Empirical pack |

---

*All citations reference files under `inputs/source/` per source-handling rules. No F3C terminology found; FEC/F3E is the consistent branding throughout the source set.*
