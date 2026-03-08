# Deep Research Output: Core DAG Recalc + FEC/F3E Seam Design

**Model lane:** Claude Opus 4.6 (high effort)
**Source pack:** `20260308-171858-core-engine-fec-f3e-deep-research-pack-01`
**Source handling:** Only `inputs/source/` files used. `inputs/retired/` ignored. F3E terminology used throughout; no F3C mapping needed in this source set.

---

## 1. Findings (ordered by severity)

### FINDING-01 [Critical] Structural-to-calc-time overlay lifecycle is unspecified
The layered model (S/R/D/V/O) is well-defined structurally, but the lifecycle boundary between the structural dependency graph (Layer D, built from Layer R at bind-time) and the calc-time dependency overlay (runtime-observed dependencies from INDIRECT/OFFSET/dynamic references) has no normative contract text.

**Impact:** Without an explicit lifecycle rule, the calc-time overlay may accumulate stale entries across epochs, or be prematurely evicted, causing either correctness violations or unbounded memory growth.
**Evidence:** `synthesis-context__foundation_notes_and_design_draft_compact.md` gap #1; `dag-research-synthesis__05_deep_research_synthesis.md` §3 ("dynamic dependencies as first-class").
**Required resolution:** Normative epoch-scoped retention/eviction contract for calc-time overlay entries.

### FINDING-02 [Critical] Concurrent multi-session coordinator is architecturally absent
The FEC/F3E seam has well-defined single-session transaction semantics (prepare/open/execute/commit), but the coordinator that manages concurrent evaluation sessions, contention resolution, and retry policy exists only as an open item.

**Impact:** Without a coordinator contract, concurrent recalc is not safely implementable. All current evidence is single-threaded sequential.
**Evidence:** `fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md` §11 item 1; `fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_OBSERVATIONS.md` gap #1; `fec-f3e-summary__implementation_and_runtime_evidence_compact.md` takeaway #3.
**Required resolution:** Coordinator type with session registry, contention policy, and retry/abort contract.

### FINDING-03 [High] Spill invalidation algebra is incomplete
Spill events (SpillTakeover/SpillClearance/SpillBlocked) are explicit commit-level events, but the algebra for computing the invalidation scope of a spill shape transition (which cells become dirty, which observers are affected, how prior vs current spill regions interact) is not specified.

**Impact:** Incremental recalc after spill-shape changes may over- or under-invalidate. Current evidence shows a single `incremental_spill_fallback` event in 80+ recalc cycles, suggesting the conservative fallback is doing the heavy lifting.
**Evidence:** `fec-f3e-summary__implementation_and_runtime_evidence_compact.md` event counts (1 fallback out of 50 full + 30 incremental); `synthesis-context__foundation_notes_and_design_draft_compact.md` gap #3.
**Required resolution:** Formal spill-invalidation-scope function mapping (prior_region, current_region, observers) → dirty_set.

### FINDING-04 [High] Pure-calc fast-path guard conditions undefined
The synthesis context identifies a "pure-calc fast path when overlay mutation is not needed" as a core design direction, but no guard predicate is defined.

**Impact:** Without a precise guard, the fast path is either never taken (pessimistic) or unsafely taken (risking missed invalidation).
**Evidence:** `synthesis-context__foundation_notes_and_design_draft_compact.md` §Core Design Direction #5; gap #4.
**Required resolution:** Boolean predicate `can_fast_path(formula_plan, session_context) -> bool` with soundness proof obligation.

### FINDING-05 [High] Formatting-dependency token semantics are provisional
DEC-CALC-007 establishes that `TEXT(value, format_text)` depends on its explicit format string, but conditional-format visibility of effective style is "profile-gated and provisional." No token type or dependency-graph participation model exists.

**Impact:** Display-layer correctness for formatting-sensitive functions cannot be validated until the token model is specified.
**Evidence:** `synthesis-context__foundation_notes_and_design_draft_compact.md` DEC-CALC-007.
**Required resolution:** `FormatDependencyToken` type and overlay participation rules.

### FINDING-06 [Medium] Epoch-safe overlay GC has no contract
Overlay data (calc-time dependencies, spill regions, formatting tokens) must be retained for pinned-epoch readers but evicted when no longer needed. No GC contract exists.

**Impact:** Unbounded memory growth or stale-read hazard for snapshot consumers.
**Evidence:** `synthesis-context__foundation_notes_and_design_draft_compact.md` gap #2.
**Required resolution:** Epoch-pinning GC protocol with explicit eviction-safe-epoch computation.

### FINDING-07 [Medium] Deterministic parallel reduction rules unspecified
DAG-PO-010 requires bit-identical outputs across thread counts, but the canonical reduction policy (float summation order, etc.) is not specified.

**Impact:** Parallel recalc may produce non-deterministic results for associative-but-not-commutative-under-floating-point operations.
**Evidence:** `dag-research-synthesis__10_conformance_and_proof_obligations.md` DAG-PO-010.
**Required resolution:** Canonical reduction order policy per aggregate function family.

### FINDING-08 [Medium] Visibility-priority scheduling lacks starvation bound
DEC-CALC-008 requires starvation prevention under visible-first policy, but no concrete bound (e.g., max priority inversion count, fairness quantum) is specified.

**Impact:** Pathological visible-region churn could starve background cells indefinitely.
**Evidence:** `synthesis-context__foundation_notes_and_design_draft_compact.md` DEC-CALC-008.
**Required resolution:** Bounded starvation parameter in scheduling policy.

### FINDING-09 [Low] Causal callgraph is adjacency-derived
Current FEC/F3E trace callgraphs are adjacency-based, not causally attributed. This limits root-cause analysis for commit-reject investigations.

**Impact:** Diagnostic quality, not correctness.
**Evidence:** `fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md` §11 item 3.

### FINDING-10 [Low] Published-state semantics during in-flight recalc not codified
What value does a snapshot reader see for a cell that is currently being recalculated in a concurrent session? The epoch model says "stale/pending" but doesn't specify which prior value is visible.

**Impact:** UI flicker or inconsistent display during recalc.
**Evidence:** `synthesis-context__foundation_notes_and_design_draft_compact.md` gap #7.

---

## 2. Design Options

### Option A: Conservative Layered Model ("Belt and Suspenders")

**Philosophy:** Minimize concurrency complexity. Single-writer recalc with snapshot isolation for readers. Full rebuild as default, incremental as optimization with conservative fallback.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree with ID-based identity; epoch-stamped snapshots |
| Dependency graph | Static deps built at bind-time; overlay appended at eval-time; full flush on structural edit |
| Calc-time overlay | Per-stabilization-wave ephemeral map; discarded after commit |
| Recalc modes | Full (default) with incremental dirty-closure optimization; no parallel eval |
| FEC/F3E seam | Single-session sequential coordinator; prepare→session→execute→commit with pessimistic locking |
| Spill handling | Conservative full-recalc on any spill-shape change |
| Concurrency | Single-writer for mutations + recalc; MVCC snapshots for readers |
| Visibility-first | Not supported; deterministic topo order only |

**Strengths:**
- Simplest to prove correct.
- Minimal coordinator complexity.
- Matches current DnaVisiCalc implementation evidence.
- Full-rebuild correctness is trivially verifiable.

**Weaknesses:**
- No concurrency benefit for large workbooks.
- Full-recalc-on-spill is O(n) where incremental could be O(affected).
- No visible-first scheduling.
- Doesn't exercise the concurrent coordinator seam needed for Round 1+.

### Option B: Layered Model with Staged Concurrency ("Incremental Growth")

**Philosophy:** Build the layered model with explicit overlay lifecycle and coordinator seam, but stage concurrency introduction behind feature gates.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree with spine-respin persistence; epoch-versioned |
| Dependency graph | Two-layer: structural deps (bind-time, persisted in green tree) + calc-time overlay (eval-time, epoch-scoped) |
| Calc-time overlay | Retained per stabilization epoch; GC'd when no readers pin prior epoch |
| Recalc modes | Full / incremental / hybrid (incremental with fallback-to-full threshold) |
| FEC/F3E seam | Multi-session coordinator with session registry; optimistic commit with structured reject/retry |
| Spill handling | Selective invalidation using spill-event algebra; conservative fallback retained |
| Concurrency | Stage 1: single-writer sequential. Stage 2: partitioned parallel eval with coordinator. Stage 3: full pipeline parallelism |
| Visibility-first | Optional policy with bounded starvation; deterministic queue key preserved |

**Strengths:**
- Provides the coordinator seam from day one without requiring concurrent implementation.
- Calc-time overlay lifecycle is explicit and epoch-safe.
- Spill-selective invalidation unlocks performance for dynamic-array-heavy workbooks.
- Stages are independently testable with existing pack infrastructure.

**Weaknesses:**
- More complex coordinator contract to specify up front.
- Overlay retention/GC adds a new subsystem.
- Stage 2–3 concurrency requires MVCC snapshot fencing that is non-trivial.

### Option C: Full Concurrent Pipeline ("All-In")

**Philosophy:** Design for full concurrent pipeline from the start: parallel eval, streaming publish, MVCC snapshots, differential update where justified.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree with persistent data structure (HAMTs/ropes); epoch-versioned |
| Dependency graph | Three-layer: structural + calc-time + streaming overlay |
| Calc-time overlay | Log-structured overlay with MVCC versioning; compaction during quiescent epochs |
| Recalc modes | Always incremental with parallel work-stealing scheduler; full rebuild as diagnostic mode only |
| FEC/F3E seam | Fully concurrent coordinator with CAS-based session management and speculative execution |
| Spill handling | Lock-free spill region manager with epoch-fenced CAS transitions |
| Concurrency | Full pipeline: parallel parse/bind, parallel eval with work-stealing, parallel commit with MVCC |
| Visibility-first | Integrated priority scheduler with real-time viewport feedback |

**Strengths:**
- Maximum throughput for large workbooks.
- Streaming overlay supports external-update-heavy profiles.
- Fully exercises the concurrency model needed for DnaCalc Round 3.

**Weaknesses:**
- Highest specification and proof complexity.
- Speculative execution introduces abort/replay overhead.
- Lock-free spill region management is a research-level problem.
- Significantly exceeds Round 0 scope and evidence base.
- Very difficult to achieve deterministic replay guarantee.

### Trade-off Matrix

| Criterion | Option A | Option B | Option C |
|---|---|---|---|
| Correctness provability | Highest | High | Medium |
| Round 0 fit | Excellent | Good | Poor |
| Round 1–3 evolution | Requires rewrite | Staged growth | Already there |
| Concurrency benefit | None | Staged | Maximum |
| Specification effort | Low | Medium | High |
| Deterministic replay | Trivial | Achievable | Difficult |
| Spill performance | O(n) | O(affected) | O(affected) |
| Pack/proof coupling | Simple | Moderate | Complex |
| Risk | Under-investment | Balanced | Over-investment |

---

## 3. Recommended Target Architecture

**Recommendation: Option B — Layered Model with Staged Concurrency.**

### Rationale
1. **Fits the evidence.** Current DnaVisiCalc implementation is single-threaded sequential with well-tested FEC/F3E seam contracts. Option B preserves this as Stage 1 while adding the architectural seams for concurrency.
2. **Satisfies doctrine.** The charter requires "design for evolution" and "explicit, versioned seams." Option B's staged gates deliver this without over-investing ahead of the evidence.
3. **Enables incremental proof.** Each stage has a well-defined pack obligation set. Stage 1 maps directly to existing packs; Stage 2 adds `PACK.dag.parallel_determinism_signature`; Stage 3 adds MVCC proofs.
4. **Resolves the critical gaps.** Option B forces explicit specification of overlay lifecycle (FINDING-01), coordinator contract (FINDING-02), and spill algebra (FINDING-03) at design time, even if Stage 1 uses conservative implementations.
5. **Avoids over-engineering.** Option C's lock-free structures and speculative execution are research-level problems that are not justified by current workload evidence.

### Target Architecture Summary

```
┌──────────────────────────────────────────────────────────────┐
│                     Protocol Surface                         │
│  dispatch_ops · query_snapshots · subscribe_deltas · caps    │
├──────────────────────────────────────────────────────────────┤
│                     Coordinator                              │
│  session_registry · epoch_manager · contention_policy        │
│  snapshot_fence · commit_arbiter · retry_policy              │
├───────────────┬──────────────────────────────────────────────┤
│ Scheduler     │ Policy Layer                                 │
│ topo_queue    │ recalc_mode · visibility_priority            │
│ scc_processor │ spill_policy · fallback_threshold            │
│ work_partitns │ starvation_bound · parallel_reduction_order  │
├───────────────┴──────────────────────────────────────────────┤
│                     FEC/F3E Seam                             │
│  prepare · install_plan · open_session · capability_view     │
│  execute · commit                                            │
│  ──────────────────────────────────────────────────          │
│  CommitResult: value_delta + shape_delta + topology_delta    │
│  SpillEvent: Takeover | Clearance | Blocked                  │
│  DependencyDelta: cells + names + spill_children             │
├──────────────────────────────────────────────────────────────┤
│                     Evaluation Layer (V)                     │
│  formula_eval · value_types · error_model · early_cutoff     │
├──────────────────────────────────────────────────────────────┤
│              Dependency Layers (D + D_overlay)               │
│  structural_deps (bind-time, green-tree-attached)            │
│  calc_time_overlay (eval-time, epoch-scoped)                 │
│  format_dep_overlay (formatting-sensitive tokens)            │
│  spill_overlay (spill regions, anchor↔interior)              │
├──────────────────────────────────────────────────────────────┤
│                    Reference Layer (R)                        │
│  BoundRef: CellRef|RegionRef|NameRef|ExternalRef|ErrorRef    │
│  forward/reverse indices · rewrite provenance                │
├──────────────────────────────────────────────────────────────┤
│                   Structural Layer (S)                        │
│  immutable green-tree · ID-based identity                    │
│  spine-respin persistence · epoch-stamped snapshots          │
│  axis_maps · cell_store · name_store · entity_store          │
├──────────────────────────────────────────────────────────────┤
│              Operations Layer (O, cross-cutting)             │
│  OpEnvelope · apply_op · replay · OpLog                      │
└──────────────────────────────────────────────────────────────┘
```

---

## 4. Normative Contract Draft

### 4.1 Key Types and Interfaces

```
// === Identity Types ===
type Epoch = u64
type SheetId = opaque
type RowId = opaque
type ColId = opaque
type CellId = (RowId, ColId)
type NameId = opaque
type ChartId = opaque
type ControlId = opaque
type FormulaStableId = opaque  // stable across structural edits
type SessionId = opaque
type FormulaToken = u64        // changes on formula plan update

type NodeId =
  | Cell(CellId)
  | Name(NameId)
  | Chart(ChartId)
  | Control(ControlId)

// === Snapshot and Epoch ===
type Snapshot = {
  epoch: Epoch,
  structure: StructureLayer,       // immutable green-tree
  references: ReferenceLayer,      // derived from structure + bind
  structural_deps: DepGraph,       // derived from references
  values: ValueLayer,              // computed values
  overlays: OverlaySet,            // calc-time + spill + format
}

type EpochState = {
  committed_epoch: Epoch,
  stabilized_epoch: Epoch,
}

// committed_epoch >= stabilized_epoch at all times
// stabilized_epoch advances only after all dirty nodes are evaluated

// === Overlay Types ===
type CalcTimeOverlay = {
  epoch: Epoch,
  dynamic_deps: Map<NodeId, Set<NodeId>>,  // eval-time observed
  provenance: Map<NodeId, DynDepProvenance>,
}

type SpillOverlay = {
  epoch: Epoch,
  regions: Map<CellId, SpillRegion>,  // anchor → region
  interior_map: Map<CellId, CellId>,  // interior → anchor
}

type SpillRegion = {
  anchor: CellId,
  extent: (RowCount, ColCount),
  status: SpillStatus,
}

type SpillStatus = Active | Blocked(BlockingCells)

type FormatOverlay = {
  epoch: Epoch,
  format_deps: Map<NodeId, Set<FormatDependencyToken>>,
}

type FormatDependencyToken =
  | ExplicitFormatString(String)
  | CellStyleRef(CellId)         // provisional, profile-gated
  | ConditionalFormatRef(RuleId) // provisional, profile-gated

type OverlaySet = {
  calc_time: CalcTimeOverlay,
  spill: SpillOverlay,
  format: FormatOverlay,
}

// === Dependency Graph ===
type DepGraph = {
  forward: Map<NodeId, Set<NodeId>>,
  reverse: Map<NodeId, Set<NodeId>>,
}

// Invariant: forward[a] contains b ⟺ reverse[b] contains a

// Merged effective deps for scheduling:
// effective_deps(node) = structural_deps.forward[node]
//                      ∪ calc_time_overlay.dynamic_deps[node]
//                      ∪ spill_overlay.spill_deps(node)
//                      ∪ format_overlay.format_deps_if_observable(node)
```

### 4.2 FEC/F3E Seam Contract

```
// === Transactional Seam ===
trait FecHost {
  fn prepare(
    formula_text: &str,
    bounds: GridBounds,
    bind_ctx: BindContext,
  ) -> Result<FormulaPlan, PrepareError>

  fn install_plan(
    formula_id: FormulaStableId,
    plan: FormulaPlan,
  ) -> FormulaToken

  fn open_session(
    formula_id: FormulaStableId,
    expected_token: Option<FormulaToken>,
    snapshot_epoch: Epoch,
  ) -> Result<SessionId, SessionError>

  fn capability_view(
    session_id: SessionId,
    formula_id: FormulaStableId,
    required_caps: Set<FecCapabilityTag>,
  ) -> FecCapabilityView

  fn commit(
    tx: EvalTransaction,
  ) -> CommitResult
}

trait F3eEvaluator {
  fn execute(
    session: &EvalSession,
    request: EvalRequest,
  ) -> EvalTransaction
}

// === Commit Result ===
type CommitResult = {
  status: CommitStatus,
  value_delta: Option<FecValueDelta>,
  shape_delta: Option<FecShapeDelta>,
  topology_delta: Option<FecTopologyDelta>,
}

type CommitStatus =
  | Applied
  | Rejected(CommitRejectReason)

type CommitRejectReason =
  | SessionNotFound
  | FormulaNotRegistered
  | FormulaMismatch
  | ExpectedTokenMismatch { expected: FormulaToken, actual: FormulaToken }
  | TransactionTokenMismatch
  | CapabilityNotBound
  | CapabilityDecisionMismatch
  | CapabilityDenied(FecCapabilityTag)
  | SnapshotConflict(SnapshotConflictDetail)

type SnapshotConflictDetail = {
  session_epoch: Epoch,
  coordinator_epoch: Epoch,
  conflict_class: SessionMismatch | CoordinatorMismatch,
}
```

**Commit invariants:**
1. `commit` succeeds only if `tx.session_epoch == coordinator.current_epoch` (snapshot fence).
2. `commit` succeeds only if `tx.formula_token == host.current_token(formula_id)` (formula version fence).
3. On `Rejected`, no state mutation occurs; the commit is a no-op.
4. On `Applied`, `committed_epoch` increments by exactly 1.
5. All reject reasons are machine-typed; no opaque reject strings.

### 4.3 Topology and Dependency Deltas

```
type FecTopologyDelta = {
  dep_delta: F3eDependencyDelta,
  impacted_nodes: Set<NodeId>,
  impact_class: TopologyImpact,
}

type F3eDependencyDelta = {
  cells_added: Set<CellId>,
  cells_removed: Set<CellId>,
  names_added: Set<NameId>,
  names_removed: Set<NameId>,
  spill_children_added: Set<CellId>,
  spill_children_removed: Set<CellId>,
}

type TopologyImpact =
  | None
  | DependencySetChanged
  | SpillRangeChanged
  | SpillBlocked

type FecShapeDelta = {
  spill_event: SpillDeltaEvent,
  prior_extent: Option<(RowCount, ColCount)>,
  current_extent: Option<(RowCount, ColCount)>,
}

type SpillDeltaEvent =
  | None
  | SpillTakeover { entered_cells: Set<CellId>, anchor: CellId }
  | SpillClearance { exited_cells: Set<CellId>, anchor: CellId }
  | SpillBlocked { blocking_cells: Set<CellId>, anchor: CellId }
```

### 4.4 Epoch and Token Rules

| Rule ID | Statement |
|---|---|
| EPOCH-01 | `committed_epoch` is monotonically increasing and increments by exactly 1 per accepted mutation/invalidation. |
| EPOCH-02 | `stabilized_epoch ≤ committed_epoch` at all observable points. |
| EPOCH-03 | `stabilized_epoch` advances only when all dirty nodes for that epoch have been evaluated and committed. |
| EPOCH-04 | Per-value `value_epoch` indicates the epoch at which that value was last computed. A value is stale iff `value_epoch < committed_epoch`. |
| EPOCH-05 | Snapshot readers may pin any epoch ≥ `min_pinned_epoch`. Overlay and value data for pinned epochs must not be evicted. |
| EPOCH-06 | `min_pinned_epoch` is the minimum of all active reader pins and the current `stabilized_epoch`. |
| TOKEN-01 | `FormulaToken` changes on every `install_plan` for a given `FormulaStableId`. |
| TOKEN-02 | A commit with `expected_token ≠ current_token` is rejected with `ExpectedTokenMismatch`. |
| TOKEN-03 | `FormulaStableId` is invariant across structural edits within a session; it is the stable identity for formula tracking. |

---

## 5. Recalc and Overlay Semantics

### 5.1 Structural Dependency Graph Rules

1. **Derivation:** The structural dependency graph is derived from the reference layer after bind/normalize. For each formula node `n`, `structural_deps.forward[n]` contains every `NodeId` statically referenced by `n`'s bound formula AST.
2. **Rebuild trigger:** Any structural edit (insert/delete row/col, formula change, name change) triggers a targeted rebuild of the affected portion of the structural dependency graph.
3. **Rebuild scope:** Only nodes whose formulas are affected by the structural edit (rewrite classification: `Shifted`, `Expanded`, `Contracted`, `Invalidated`) have their structural deps rebuilt.
4. **Reverse index:** The reverse dependency index is maintained incrementally: when `forward[n]` changes, the corresponding `reverse` entries are updated atomically.
5. **Invariant:** `structural_deps` is a function of the current `StructureLayer` and `ReferenceLayer` only. It has no dependency on prior computation state.

### 5.2 Calc-Time Overlay Rules

1. **Population:** During evaluation of a formula node, the evaluator records all dynamically resolved dependencies (INDIRECT targets, OFFSET results, etc.) as calc-time overlay entries tagged with the current stabilization epoch.
2. **Scope:** Calc-time overlay entries apply only to the stabilization epoch in which they were recorded.
3. **Merge for scheduling:** The scheduler computes effective dependencies as: `effective(n) = structural_deps(n) ∪ calc_time_overlay(n)`.
4. **Invalidation on structural edit:** On structural edit, all calc-time overlay entries for affected nodes are invalidated (marked stale). The node must be re-evaluated to re-discover dynamic deps.
5. **Retention:** Calc-time overlay entries are retained for the duration of the epoch in which they were created, plus any pinned reader epochs. Eviction occurs when `epoch < min_pinned_epoch`.
6. **Soundness invariant:** If a formula `f` at epoch `e` has `calc_time_overlay(f, e) = D`, then `f`'s result at epoch `e` depends on all nodes in `structural_deps(f) ∪ D`. No dependency may be omitted. Over-approximation is safe; under-approximation is unsound.

### 5.3 Spill Overlay Interaction Rules

1. **Spill region registration:** When a formula evaluates to an array result, the FEC commit registers a `SpillRegion` in the spill overlay, mapping anchor → extent + interior cells.
2. **Interior cell dependency:** Each interior cell of a spill region has an implicit dependency on the anchor formula. This dependency is tracked in the spill overlay, not in the structural dependency graph.
3. **Spill event invalidation scope:**
   - `SpillTakeover(entered)`: All observers of `entered` cells are marked dirty. All cells in `entered` become spill-interior cells.
   - `SpillClearance(exited)`: All observers of `exited` cells are marked dirty. `exited` cells revert to their prior input state.
   - `SpillBlocked(blocking)`: Anchor formula value becomes `#SPILL!` error. All prior interior cells are invalidated. Observers of anchor are marked dirty.
4. **Prior/current region diff:** Invalidation scope for a spill shape change is `diff = (prior_interior \ current_interior) ∪ (current_interior \ prior_interior)`. All observers of cells in `diff` are marked dirty.
5. **Conservative fallback:** If spill invalidation scope computation fails or exceeds a policy threshold, fallback to full recalc. This fallback is logged and counted via `FecSeamPerfCounters.spill_blocked_count` or equivalent.
6. **Interaction with structural edits:** If a structural edit intersects an active spill boundary that cannot be deterministically rewritten, the structural edit is rejected (`STRUCTURAL_CONSTRAINT`). No partial mutation occurs.

### 5.4 Format and Visibility Overlay Interaction Rules

1. **Format dependency tokens:** Formatting-sensitive functions (e.g., `TEXT(value, format)`) register `FormatDependencyToken` entries in the format overlay at eval time.
2. **Default behavior (Round 0):** Only `ExplicitFormatString` tokens are supported. These are stable strings and do not trigger re-evaluation on style changes.
3. **Profile-gated extension:** `CellStyleRef` and `ConditionalFormatRef` tokens are provisional. When enabled by profile, changes to referenced styles trigger invalidation of the dependent formula.
4. **Visibility overlay (optional policy):** The visibility overlay records `visible_regions` and `visible_nodes` as reported by the UI layer. The scheduler may use this to prioritize evaluation of visible nodes.
5. **Semantic invariant:** Visibility priority alters scheduling order only. For any two scheduling policies P1 (topo-only) and P2 (visible-first), the stabilized output values must be identical.
6. **Starvation bound:** Under visible-first policy, every non-visible node must be scheduled within `max_starvation_rounds` stabilization waves. Default: `max_starvation_rounds = 3`.

### 5.5 Pure-Calc Fast-Path Guard

A formula evaluation can bypass overlay mutation if all of the following hold:
1. The formula plan has no dynamic reference functions (INDIRECT, OFFSET, or profile-marked dynamic-ref functions).
2. The formula plan is not an array formula (no spill region mutation possible).
3. The formula plan has no formatting-sensitive functions (no format overlay mutation).
4. The formula plan has no volatile or externally-invalidated functions.

When the guard is satisfied, evaluation proceeds without opening an overlay-mutation session, reducing per-cell overhead.

**Proof obligation:** `FAST-PATH-SOUND`: If `can_fast_path(plan) = true`, then evaluation of `plan` produces no side effects on any overlay (calc-time, spill, format), and the result depends only on nodes in `structural_deps(plan.formula_node)`.

---

## 6. Concurrency Model

### 6.1 Coordinator Responsibilities

```
type Coordinator = {
  epoch_state: AtomicEpochState,
  session_registry: SessionRegistry,
  commit_lock: CommitSerializer,
  snapshot_manager: SnapshotManager,
  contention_policy: ContentionPolicy,
}

trait CoordinatorContract {
  // Epoch management
  fn current_epoch(&self) -> Epoch
  fn advance_epoch(&self) -> Epoch  // returns new epoch

  // Session management
  fn register_session(
    formula_id: FormulaStableId,
    snapshot_epoch: Epoch,
  ) -> Result<SessionId, SessionError>

  fn deregister_session(session_id: SessionId)

  // Commit arbitration
  fn try_commit(
    session_id: SessionId,
    tx: EvalTransaction,
  ) -> CommitResult

  // Snapshot management
  fn pin_snapshot(epoch: Epoch) -> SnapshotPin
  fn release_pin(pin: SnapshotPin)
  fn min_pinned_epoch(&self) -> Epoch
}
```

### 6.2 Snapshot Fences

| Fence | Check point | Invariant |
|---|---|---|
| Session open | `open_session` | `snapshot_epoch ≤ coordinator.current_epoch` |
| Capability bind | `capability_view` | Session is registered and not expired |
| Commit session | `try_commit` | `tx.session_epoch == session.snapshot_epoch` |
| Commit coordinator | `try_commit` | `tx.session_epoch` is compatible with `coordinator.current_epoch` per contention policy |
| Structural exclusion | `apply_structural_op` | No evaluation sessions are active for affected nodes, OR structural op is serialized against all eval |

### 6.3 Contention and Retry Behavior

**Stage 1 (sequential):**
- Single writer; no contention possible.
- Commit always succeeds if snapshot fence passes.

**Stage 2 (partitioned parallel):**
- Evaluation graph is partitioned into independent subgraphs.
- Each partition has its own session scope.
- Cross-partition dependencies use message-passing, not shared-memory commits.
- Contention occurs only at partition boundaries.
- Retry policy: on `SnapshotConflict`, the partition re-reads the conflicting value from the committed snapshot and re-evaluates affected nodes. Maximum retry count per partition per stabilization wave: `max_partition_retries` (default: 3).

**Stage 3 (full pipeline):**
- CAS-based commit: `try_commit` performs compare-and-swap on `committed_epoch`.
- On CAS failure (another session committed between open and commit): structured reject with `SnapshotConflict`.
- Retry policy: re-open session at new epoch, re-evaluate formula, re-commit. Maximum retries per formula per stabilization wave: `max_formula_retries` (default: 5).
- Structural operations are serialized: a structural op acquires an exclusive epoch-advance lock, drains all active evaluation sessions, applies the structural edit, then releases.

**Invariants across all stages:**
1. **No stale commit:** A committed value always reflects inputs from the epoch it claims.
2. **No phantom dependency:** A committed topology delta reflects the actual dependencies observed during evaluation.
3. **Serializable snapshot:** The committed snapshot is equivalent to some serial execution of all committed operations.

---

## 7. Adoption Roadmap

### Phase 0: Contract Specification (current → near-term)

**Goal:** Complete normative contract text for all unspecified seams identified in Findings.

| Work item | Resolves | Deliverable |
|---|---|---|
| Calc-time overlay lifecycle contract | FINDING-01 | Normative text in `CORE_ENGINE_FORMAL_MODEL.md` §6.2 addendum |
| Coordinator type specification | FINDING-02 | Coordinator contract in `CORE_ENGINE_FORMAL_MODEL.md` §6.8 (new section) |
| Spill invalidation algebra | FINDING-03 | Formal spill-scope function in `CORE_ENGINE_FORMAL_MODEL.md` §6.5 addendum |
| Pure-calc fast-path guard | FINDING-04 | Guard predicate + proof obligation |
| Format dependency token type | FINDING-05 | Type definition + overlay rules |
| Overlay GC protocol | FINDING-06 | Epoch-pinning GC contract |
| Parallel reduction order | FINDING-07 | Per-function-family reduction policy |
| Starvation bound | FINDING-08 | Policy parameter in scheduler contract |

**Gate:** All contract text drafted and reviewed before Phase 1 implementation.

### Phase 1: Foundation Core Engine (Stage 1 sequential)

**Goal:** Implement Option B Stage 1 as the Foundation core engine, replacing DnaVisiCalc's ad-hoc engine internals.

| Work item | Dependency | Compatibility shim |
|---|---|---|
| Green-tree structural model with spine-respin | None | DnaVisiCalc `EngineState` maps to green-tree snapshot |
| Two-layer dependency graph (structural + overlay) | Green-tree | DnaVisiCalc `DepGraph` maps to structural deps; overlay is new |
| Sequential coordinator with session registry | None | DnaVisiCalc single-threaded recalc is Stage 1 coordinator |
| FEC/F3E seam adoption (b4 contracts) | Coordinator | DnaVisiCalc FEC/F3E b4 contracts carry forward unchanged |
| Spill overlay with selective invalidation | Two-layer deps | DnaVisiCalc `ConservativeFullRecalc` remains as fallback policy |
| Pack infrastructure for Phase 1 packs | Green-tree | New; no shim needed |

**Required packs at Phase 1 exit:**
- `PACK.dag.baseline_recalc_core`
- `PACK.dag.cycle_iterative_semantics`
- `PACK.dag.dynamic_dependency_bind_semantics`
- `PACK.visicalc.core` (updated for Foundation types)

**Compatibility shim strategy:**
- DnaVisiCalc's `dvc_` C API surface maps 1:1 to Foundation Protocol Surface dispatch/query methods.
- DnaVisiCalc's `FormulaToken`/`FecFormulaId`/`FecNameId` types carry forward as Foundation identity types.
- DnaVisiCalc's `RecalcMode::Automatic/Manual` maps to Foundation scheduler policy.

**Blocker gate:** Phase 1 exit requires all Phase 1 packs green.

### Phase 2: Parallel Evaluation (Stage 2 partitioned)

**Goal:** Enable partitioned parallel evaluation for independent subgraphs.

| Work item | Dependency |
|---|---|
| Graph partitioner (connected-component + cut analysis) | Phase 1 dep graph |
| Partition-scoped session coordinator | Phase 1 coordinator |
| Cross-partition dependency message protocol | Partitioner |
| MVCC snapshot manager with epoch-pinning GC | Phase 1 overlay lifecycle |
| Parallel determinism conformance pack | Partitioner |

**Required packs at Phase 2 exit:**
- All Phase 1 packs (regression)
- `PACK.dag.parallel_determinism_signature`
- `PACK.dag.early_cutoff.signature`
- `PACK.concurrent.epochs` (TLA+ model checks)

**Blocker gate:** Phase 2 exit requires bit-identical outputs across thread-count matrix.

### Phase 3: Full Pipeline and Streaming (Stage 3)

**Goal:** Full concurrent pipeline with streaming overlay and advanced incrementalization.

| Work item | Dependency |
|---|---|
| CAS-based coordinator with speculative eval | Phase 2 coordinator |
| Streaming overlay for external updates | Phase 2 MVCC |
| Visible-first priority scheduler | Phase 2 partitioner |
| Dynamic-topo maintenance (optional) | Phase 1 dep graph |
| Differential update lane for stream-heavy profiles | Streaming overlay |

**Required packs at Phase 3 exit:**
- All Phase 2 packs (regression)
- `PACK.dag.external_stream_ordering`
- `PACK.dag.dynamic_topo_vs_rebuild`
- `PACK.scaling.signature` (scaling characterization)

**Blocker gate:** Phase 3 exit is DnaPreCalc Round 1 readiness.

---

## 8. Open Questions and Decisive Experiments

### OQ-01: Overlay retention cost under realistic workloads
**Question:** What is the memory overhead of retaining calc-time overlay entries for pinned epochs in workbooks with many INDIRECT/OFFSET formulas?
**Decisive experiment:** Instrument overlay size (entry count + memory bytes) across the DnaVisiCalc test suite with varying INDIRECT density (0%, 5%, 25%, 50% of formulas). Report overlay-to-snapshot size ratio.
**Decision threshold:** If overlay exceeds 20% of snapshot size at 25% INDIRECT density, investigate compaction or hash-consing.

### OQ-02: Spill selective invalidation vs conservative fallback break-even
**Question:** At what spill density does selective invalidation outperform conservative full-recalc?
**Decisive experiment:** Benchmark recalc latency for workbooks with N spill-producing formulas (N = 1, 10, 100, 1000) under single-cell edits. Compare selective vs conservative.
**Decision threshold:** If selective is slower for N < 10, retain conservative as default with selective opt-in for high-spill workbooks.

### OQ-03: Parallel determinism under floating-point aggregation
**Question:** Can canonical reduction order achieve bit-identical results across thread counts without unacceptable performance penalty?
**Decisive experiment:** Run `PACK.dag.parallel_determinism_signature` with pairwise and tree-reduction strategies across 1/2/4/8/16 threads. Measure correctness and throughput.
**Decision threshold:** If canonical pairwise reduction is >2x slower than tree reduction, consider profiled exceptions for specific aggregate families.

### OQ-04: Structural edit + active spill boundary interaction frequency
**Question:** How frequently do real-world structural edits intersect active spill boundaries, triggering `STRUCTURAL_CONSTRAINT` rejection?
**Decisive experiment:** Replay structural edit traces from test suites against workbooks with varying spill density. Count rejection rate.
**Decision threshold:** If rejection rate exceeds 5% of structural edits at moderate spill density, consider spill-aware structural rewrite (relocate spill region instead of rejecting).

### OQ-05: Coordinator session overhead at scale
**Question:** What is the per-session overhead of the coordinator session registry under partitioned parallel evaluation?
**Decisive experiment:** Benchmark session open/commit throughput with 100, 1000, 10000 concurrent sessions.
**Decision threshold:** If per-session overhead exceeds 1μs, investigate lock-free session registry.

### OQ-06: Which deterministic replay schema becomes canonical?
**Question:** Current trace schema is `fec-f3e-trace/b4` for the FEC seam. The broader engine needs a unified trace schema covering operation replay, structural rewrite, reference-grid delta, SCC iteration, and value commit.
**Decisive experiment:** Draft a unified trace schema and validate it against all existing conformance packs. Measure schema-validation overhead per trace event.
**Decision threshold:** If unified schema adds >5% overhead vs current per-subsystem schemas, keep subsystem schemas with a trace-merge tool.

### OQ-07: Visible-first scheduling proof obligations
**Question:** What proof is required to guarantee that visible-first scheduling produces identical stabilized outputs to topo-only scheduling?
**Decisive experiment:** Formalize the scheduling equivalence theorem in Lean. Identify the required assumptions (e.g., no observation of evaluation order in formula semantics, no side effects).
**Decision threshold:** If the proof requires assumptions not met by the current function set (e.g., RAND depends on eval order), scope visible-first to deterministic-function-only subgraphs.

---

## 9. Pack/Proof Checklist

### Proof Obligations

| ID | Statement | Status | Target phase |
|---|---|---|---|
| PO-REPLAY-DET | Identical op stream → identical observable values/errors | Draft (DAG-PO-002) | Phase 1 |
| PO-SCC-CORRECT | SCC decomposition is sound/complete for cycle isolation | Draft (DAG-PO-003) | Phase 1 |
| PO-ITER-DET | Iterative mode output deterministic under fixed policy | Draft (DAG-PO-004) | Phase 1 |
| PO-DYNBIND-SOUND | Recorded dynamic deps unchanged → result unchanged | Draft (DAG-PO-006) | Phase 1 |
| PO-FASTPATH-SOUND | `can_fast_path(plan) = true` → no overlay side effects | New | Phase 1 |
| PO-INCR-EQUIV | Incremental recompute = full recompute on acyclic graphs | Draft (DAG-PO-001) | Phase 1 |
| PO-SPILL-SCOPE | Spill invalidation scope function is sound (no missed dirty) | New | Phase 1 |
| PO-OVERLAY-GC | Overlay eviction never removes data for pinned epochs | New | Phase 2 |
| PO-CUTOFF-SAFE | Early cutoff suppression never produces semantic drift | Draft (DAG-PO-008) | Phase 2 |
| PO-PARALLEL-CONF | Parallel schedule confluence under canonical reduction | Draft (DAG-PO-010) | Phase 2 |
| PO-VISIBLE-EQUIV | Visible-first scheduling ≡ topo-only scheduling on outputs | New | Phase 3 |
| PO-STREAM-ORDER | External update ordering/dedupe is replay-stable | Draft (DAG-PO-009) | Phase 3 |

### Empirical Packs

| Pack ID | Status | Target phase | Key metric |
|---|---|---|---|
| PACK.dag.baseline_recalc_core | Draft | Phase 1 | Zero divergence vs full recompute |
| PACK.dag.cycle_iterative_semantics | Draft | Phase 1 | Deterministic termination + diagnostics |
| PACK.dag.dynamic_dependency_bind_semantics | Draft | Phase 1 | Zero stale-read violations |
| PACK.dag.dynamic_topo_vs_rebuild | Draft | Phase 2 | 100% correctness parity |
| PACK.dag.early_cutoff.signature | Draft | Phase 2 | Zero incorrect suppressions |
| PACK.dag.parallel_determinism_signature | Draft | Phase 2 | Bit-identical across thread matrix |
| PACK.dag.external_stream_ordering | Draft | Phase 3 | Zero replay divergence |
| PACK.fec.transaction_boundary | New | Phase 1 | All commit rejects machine-typed; zero silent failures |
| PACK.fec.spill_invalidation_algebra | New | Phase 1 | Selective invalidation correctness vs conservative |
| PACK.overlay.gc_safety | New | Phase 2 | No data evicted while readers pinned |
| PACK.scheduler.visible_first_equivalence | New | Phase 3 | Output identity under policy variation |
| PACK.coordinator.contention_replay | New | Phase 2 | Deterministic outcomes under interleaved commits |

### Concrete Testable Assertions

1. **After any single-cell edit in automatic mode**, `stabilized_epoch == committed_epoch` after recalc completes.
2. **For every formula with `can_fast_path = true`**, evaluation produces zero overlay delta entries.
3. **For every spill takeover event**, all entered cells' observers appear in the dirty set.
4. **For every commit reject**, `CommitRejectReason` is not `Unknown` or opaque.
5. **For every structural edit**, the rewrite classification set covers all references in affected formulas (no unclassified references).
6. **For `min_pinned_epoch = E`**, no overlay entry with `epoch < E` is ever read by any active reader.
7. **For parallel recalc at thread counts 1, 2, 4, 8**, all output values are bit-identical.
8. **For visible-first scheduling with starvation bound B**, every non-visible node is evaluated within B stabilization waves.
9. **For every SCC with `CycleError` mode**, all cells in the SCC produce `#CIRC!` or equivalent error deterministically.
10. **For every SCC with `Iterative` mode**, iteration terminates within `max_iterations` and reports termination reason (`Converged` | `BoundReached`).

---

*End of deep research output.*
