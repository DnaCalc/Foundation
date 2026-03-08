Now I have all the source material. Let me produce the full three-round deliverable. I'll perform the self-review iterations internally and return only the final refined answer.

---

# Deep Research Synthesis: Core DAG Recalc + FEC/F3E Seam

**Run**: `20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01`
**Model**: Claude Opus 4.6 — final self-reviewed output (base + 2 review passes)
**Source authority**: `inputs/source/` (compact curated pack)

---

## 1. Findings (ordered by severity)

### Critical

**F-001. Calc-time overlay lifecycle has no formal specification.**
The five-layer model (S/R/D/V/O) in `foundation-core__CORE_ENGINE_FORMAL_MODEL.md` describes layer roles but does not define: (a) when a calc-time dependency overlay is instantiated, (b) how it interacts with epoch transitions, (c) when it becomes eligible for eviction, or (d) how publication of overlay state is ordered relative to value publication. The structural dependency layer and the calc-time overlay layer have no explicit publish boundary. This is the single largest correctness gap—without it, incremental recalc correctness cannot be formally stated.
*Sources*: `CORE_ENGINE_FORMAL_MODEL.md` §Five-layer model; `synthesis-context compact` Gap #1, Open Question #1.

**F-002. Coordinator is single-threaded; no contention/retry protocol.**
The FEC/F3E seam coordinator is explicitly single-threaded (`ENGINE_FEC_F3E_REDESIGN_SPEC.md` open items; `REDESIGN_OBSERVATIONS.md` remaining gaps). There is no defined behavior for: concurrent `open_session` calls on the same formula, contention between a structural edit and an in-flight evaluation, or retry semantics after `RejectedSnapshotConflict`. This blocks async/high-concurrency recalc (objective §3).
*Sources*: `ENGINE_FEC_F3E_REDESIGN_SPEC.md` open items; `REDESIGN_OBSERVATIONS.md`; `implementation_and_runtime_evidence_compact.md` §Design-Phase Takeaway #3.

**F-003. Spill invalidation algebra is undefined.**
When a spill region changes shape (takeover, clearance, blocked→recovered), the exact set of cells and dependents requiring re-evaluation is not formally specified. The prior-region / current-region difference calculation, interaction with blocked cells, and cascade through dependent formulas all need algebraic precision. Without this, the `SpillDeltaEvent` contract is observationally defined but not semantically grounded.
*Sources*: `synthesis-context compact` Gap #3; `ENGINE_FEC_F3E_REDESIGN_SPEC.md` §Spill Event Contract.

### High

**F-004. Dynamic dependency token lifecycle is underspecified.**
Dynamic references (INDIRECT, OFFSET, runtime name resolution) create evaluation-time-observed dependencies. The tokenization scheme (what is a token?), retention policy (how long does an observed dependency set survive?), and invalidation semantics across epoch boundaries are not formally defined. `DAG-PO-006` and `DAG-PO-007` require this for soundness proofs but the mechanism is left to implementation.
*Sources*: `dag-research-synthesis__05` §3; `conformance_and_proof_obligations.md` DAG-PO-006/007; `ENGINE_FEC_F3E_REDESIGN_SPEC.md`.

**F-005. Formatting-sensitive calculation overlay lacks binding specification.**
`DEC-CALC-007` establishes that formatting-observable functions (e.g., `TEXT(value, format_text)`) need explicit formatting dependency tokens in the calc-time overlay. However, no concrete token schema, overlay layer interaction rule, or invalidation trigger mechanism is defined. The profile-gated provisional path for conditional-format visibility makes this worse—there are two modes with no formal boundary.
*Sources*: `synthesis-context compact` DEC-CALC-007.

**F-006. Publication ordering during composite commits is undefined.**
A single `commit` call can produce `value_delta`, `shape_delta`, and `topology_delta` simultaneously. The order in which these become visible to downstream consumers, the atomicity guarantee (all-or-nothing vs. partial visibility), and the interaction with `committed_epoch` / `stabilized_epoch` advancement are not specified.
*Sources*: `synthesis-context compact` Open Question #1; `implementation_and_runtime_evidence_compact.md` §CommitStatus.

**F-007. Pure-calc fast-path guard conditions are informal.**
The concept of a "pure-calc fast path" (bypassing overlay mutation tracking when a formula has no dynamic dependencies, no spill, no formatting observation) is referenced but there are no formal predicates. Without testable guard conditions, the optimization cannot be safely enabled.
*Sources*: `synthesis-context compact` Gap #4; `CORE_ENGINE_FORMAL_MODEL.md`.

### Medium

**F-008. Deterministic parallel reduction tie-break rules are incomplete.**
`DAG-PO-010` requires parallel schedule confluence under canonical reduction policy. For floating-point-sensitive operations (SUM over parallel partitions), the canonical reduction ordering is acknowledged but not specified.
*Sources*: `conformance_and_proof_obligations.md` DAG-PO-010; `synthesis-context compact` Gap #5.

**F-009. Function-catalog/profile-version invalidation triggers are missing.**
When a profile version changes (function added/removed/behavior-altered) or the function catalog is updated at runtime, the invalidation scope across the dependency graph is undefined. Does every formula re-parse? Only affected SCCs? Only formulas referencing changed functions?
*Sources*: `synthesis-context compact` Gap #6.

**F-010. Visibility-priority scheduling lacks starvation bound.**
`DEC-CALC-008` mandates starvation prevention under visible-first scheduling but specifies no concrete bound, fairness algorithm, or maximum delay guarantee.
*Sources*: `synthesis-context compact` DEC-CALC-008.

**F-011. Concurrent evaluator trace replay schema is not canonical.**
Multiple trace formats exist (`fec-f3e-trace/b4`, seam event counts, callgraph edges). No single canonical schema is defined for replaying concurrent evaluation with deterministic outcome verification.
*Sources*: `synthesis-context compact` Open Question #2; `implementation_and_runtime_evidence_compact.md` §Trace Schema.

### Low

**F-012. Early-cutoff value equality semantics need per-type declaration.**
`DAG-PO-008` requires equality semantics declared per value type to suppress downstream propagation safely. The value type catalog (`Number`, `Text`, `Boolean`, `Error`, `Array`) does not include equality specifications (e.g., NaN equality, array structural vs. element-wise comparison).
*Sources*: `conformance_and_proof_obligations.md` DAG-PO-008.

**F-013. Degradation class encoding for unsupported dynamic references is open.**
How a profile represents "INDIRECT is not supported in this profile" vs. "INDIRECT is supported but may degrade" has no concrete encoding.
*Sources*: `synthesis-context compact` Open Question #3.

---

## 2. Design Options with Trade-off Matrix

### Option A: Conservative Layered (Baseline-First)

**Core concept**: Implement the structural model and full-rebuild recalc engine with static dependencies first. Add dynamic dependency tracking, incremental invalidation, and spill overlays as explicit extension layers behind profile gates.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree; ID-based identity (`NodeId` = sheet×row×col stable hash) |
| Dependency graph | Static-only at baseline; dependency edges extracted at parse/bind time |
| Recalc | Deterministic topological sort + SCC decomposition; full rebuild as sole strategy |
| FEC/F3E | Adopt Plan B b4 transaction lane as-is; single-threaded coordinator |
| Overlay model | Single calc-time overlay with epoch-scoped lifetime; no retained overlays across epochs |
| Concurrency | Sequential evaluation within epoch; external host serializes all mutation |
| Spill | Conservative full-recalc on any spill shape change |
| Visibility-first | Not supported; deferred |

### Option B: Incremental-Ready (Dual-Layer Overlay)

**Core concept**: Build with dual-layer dependency tracking (structural + runtime-observed) and incremental invalidation from the start. Use SAC-inspired dirty/stale/necessary state machine with early cutoff. Separate overlay instances for dependencies, spill, and formatting.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree with structural sharing; path-indexed `NodeId` |
| Dependency graph | Dual-layer: structural edges (parse-time) + runtime-observed edges (eval-time, tokenized) |
| Recalc | Dynamic topological maintenance; dirty/stale/necessary/clean state machine; early cutoff; full-rebuild fallback |
| FEC/F3E | Extended Plan B with multi-session capability; coordinator manages session queues |
| Overlay model | Separate overlay instances: `DepOverlay`, `SpillOverlay`, `FormatOverlay`, `VisibilityOverlay` — each epoch-versioned |
| Concurrency | Partition-parallel evaluation; deterministic merge with canonical tie-break; epoch/MVCC snapshots |
| Spill | Algebraic invalidation: `invalidate(prior_region ∆ current_region) ∪ blocked_deps` |
| Visibility-first | Optional policy lane with bounded starvation (`max_deferred_waves`) |

### Option C: Ambitious Differential (Stream-Native)

**Core concept**: Design for differential/timely change-propagation semantics. External streams, collaboration updates, and formula edits all enter a unified change-propagation framework. Full incrementality with lattice-based cycle convergence.

| Aspect | Design |
|---|---|
| Structural model | Log-structured immutable store with structural sharing and persistent indexing |
| Dependency graph | Full differential dataflow graph; edges carry change types (insert/delete/update) |
| Recalc | Differential maintenance; lattice-based convergence for cycles; stream-aligned epochs |
| FEC/F3E | Distributed coordinator; CAS-based contention; per-formula epoch advancement |
| Overlay model | Unified change-propagation operators; overlays are dataflow subgraphs |
| Concurrency | Fully concurrent with capability-based isolation; progress tracking per frontier |
| Spill | Spill as dataflow operator with output-port semantics |
| Visibility-first | Natural via frontier priority; visible regions advance first |

### Trade-off Matrix

| Criterion | Option A (Conservative) | Option B (Incremental-Ready) | Option C (Differential) |
|---|---|---|---|
| Implementation complexity | **Low** | Medium | High |
| Time to Round 0 delivery | **Shortest** | Medium | Longest |
| Proof obligation count | ~5 core | ~10 core + ~5 overlay | ~15+ |
| Incremental recalc | No (full rebuild) | **Yes (from day one)** | **Yes (native)** |
| Dynamic dependency support | Deferred | **First-class** | **First-class** |
| Spill correctness | Conservative (safe, slow) | **Algebraic (correct, efficient)** | **Algebraic** |
| Concurrency scaling | None | **Good (partition-parallel)** | **Best (fully concurrent)** |
| Stream/RTD support | Basic (full-invalidate) | Good (selective) | **Native** |
| Visibility-first scheduling | No | Optional | **Natural** |
| Risk of over-engineering | **None** | Low | **High** |
| Migration from DnaVisiCalc | **Direct** | Moderate | Major rewrite |
| Clean-room discipline | **Easiest** | Moderate | Hardest |
| Conformance pack coverage | Good for Round 0 | Good for Rounds 0-1 | Aspirational |
| Fallback to full rebuild | Always (by design) | Explicit fallback | Requires fallback path |

---

## 3. Recommended Target Architecture

**Recommendation: Option B (Incremental-Ready) as primary target, with Option A as the Phase 1 delivery gate.**

### Rationale

1. **Option A is not a terminal state**. DNA Calc's charter requires high-fidelity Excel-compatible behavior including dynamic arrays, INDIRECT/OFFSET, and eventually streaming data. Full-rebuild-only cannot scale, and retrofitting incremental invalidation into a system not designed for it introduces higher total cost than building it correctly from the start.

2. **Option C is premature**. Differential dataflow is powerful but introduces complexity that the current team size, proof infrastructure, and Round 0 scope do not justify. The stream/collaboration use cases are Round 2+ (DnaSuperCalc). The transfer matrix (`dag-research-synthesis__04`) correctly classifies differential/timely as "advanced/future."

3. **Option B delivers both correctness and performance trajectory**. The dual-layer dependency model, explicit overlay lifecycle, and partition-parallel evaluation directly address all Critical and High findings (F-001 through F-007). The SAC-inspired state machine has strong theoretical grounding (DAG-PO-001, DAG-PO-006, DAG-PO-007, DAG-PO-008) and proven implementation patterns.

4. **Phase 1 gate uses Option A semantics**. The first delivery milestone (DnaVisiCalc Round 0) uses full-rebuild recalc with the Option B structural model and overlay infrastructure in place but with incremental paths disabled behind profile gates. This gives the team a correct, testable baseline while the incremental paths are proven.

### Target Architecture Summary

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Host / UI Layer                              │
│   (Tauri + Web)         OpLog API          Change Tracking API     │
├─────────────────────────────────────────────────────────────────────┤
│                      Coordinator Layer                              │
│  ┌──────────┐  ┌─────────────┐  ┌────────────┐  ┌──────────────┐  │
│  │ Epoch Mgr │  │ Session Mgr │  │ Scheduler  │  │ Publish Ctrl │  │
│  └──────────┘  └─────────────┘  └────────────┘  └──────────────┘  │
├─────────────────────────────────────────────────────────────────────┤
│                    Snapshot + Overlay Layer                          │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  ┌──────────┐  │
│  │ DocSnapshot  │  │ DepOverlay   │  │SpillOverlay│  │FmtOverlay│  │
│  │ (immutable)  │  │(struct+calc) │  │            │  │          │  │
│  └─────────────┘  └──────────────┘  └────────────┘  └──────────┘  │
├─────────────────────────────────────────────────────────────────────┤
│                     Evaluation Layer                                │
│  ┌─────────────────────┐  ┌──────────────────────────────────────┐  │
│  │  FEC (Host-side)    │  │  F3E (Evaluator-side)               │  │
│  │  prepare/install    │  │  execute → EvalTransaction           │  │
│  │  open_session       │  │  observe deps + spill + format      │  │
│  │  capability_view    │  │  produce value + deltas              │  │
│  │  commit             │  │                                      │  │
│  └─────────────────────┘  └──────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────────┤
│                    Structural Model Layer                            │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Green-Tree Kernel (immutable, structurally shared)          │   │
│  │  NodeId identity │ Reference model │ Rewrite engine          │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

### Key Architectural Invariants

**INV-ARCH-001**: Every `DocSnapshot` is immutable once created. Mutations produce a new snapshot at a new epoch.

**INV-ARCH-002**: The structural dependency graph is derived deterministically from the current `DocSnapshot`. It is a pure function of the snapshot content.

**INV-ARCH-003**: Calc-time overlays (`DepOverlay`, `SpillOverlay`, `FormatOverlay`) are epoch-versioned mutable structures. Each overlay instance is bound to the epoch in which it was created and may only be read by sessions bound to the same or a compatible epoch.

**INV-ARCH-004**: The `Coordinator` is the sole authority for epoch advancement, session lifecycle, and overlay publication. No evaluation session may directly mutate shared state.

**INV-ARCH-005**: Every `commit` call is total—it either applies all deltas atomically or rejects with a deterministic `CommitRejectDetail`. There is no partial commit.

**INV-ARCH-006**: The recalc strategy (full-rebuild vs. incremental) is a policy decision owned by the `Scheduler`. It does not alter the observable semantic outcome (DAG-PO-001).

**INV-ARCH-007**: Overlay publication ordering within a committed epoch is: value deltas → dependency deltas → spill deltas → format deltas → visibility update. Each phase completes before the next begins.

**INV-ARCH-008**: Under any scheduling policy (FIFO, visible-first, priority), the final committed values for a given epoch are identical (DAG-PO-002, DAG-PO-010). Policy affects order of intermediate visibility, not semantic result.

---

## 4. Normative Contract Draft

### 4.1 Key Types and Interfaces

```
// ─── Identity ───

type NodeId       = { sheet: SheetId, row: RowIdx, col: ColIdx }
type FormulaId    = StableId<Formula>       // content-addressed or registry-assigned
type NameId       = StableId<DefinedName>
type RangeId      = StableId<Range>         // for named ranges / spill anchors
type EpochId      = u64                     // monotonically increasing
type SessionId    = Opaque<u64>
type FormulaToken = u64                     // version tag per formula registration

// ─── Snapshot ───

interface DocSnapshot {
    epoch:      EpochId
    cell(id: NodeId)  -> CellContent
    name(id: NameId)  -> NameDefinition
    bounds()          -> SheetBounds
    // Structural dependency extraction (pure function of content)
    structural_deps(id: NodeId) -> Set<NodeId | NameId>
}

// ─── Overlays ───

interface DepOverlay {
    epoch:      EpochId
    // Structural (parse-time) edges
    structural_predecessors(id: NodeId) -> Set<NodeId | NameId>
    structural_successors(id: NodeId)   -> Set<NodeId | NameId>
    // Runtime-observed (calc-time) edges
    runtime_predecessors(id: NodeId)    -> Set<NodeId | NameId>
    runtime_successors(id: NodeId)      -> Set<NodeId | NameId>
    // State machine
    node_state(id: NodeId)              -> NodeCalcState
    // Merge runtime observations from committed eval
    apply_dependency_delta(delta: F3eDependencyDelta) -> ()
}

enum NodeCalcState { Clean, Stale, Necessary, Recomputing }

interface SpillOverlay {
    epoch:         EpochId
    anchor_region(anchor: NodeId)       -> Option<CellRegion>
    is_spill_child(id: NodeId)          -> Option<NodeId>  // returns anchor
    blocked_anchors()                   -> Set<NodeId>
    apply_spill_delta(delta: SpillDelta) -> ()
}

interface FormatOverlay {
    epoch:    EpochId
    format_deps(id: NodeId) -> Set<FormatToken>
    apply_format_delta(delta: FormatDelta) -> ()
}

// ─── FEC/F3E Transaction Lane ───

interface FecHost {
    prepare(text: FormulaText, bounds: SheetBounds, ctx: ParseContext)
        -> Result<FormulaPlan, PrepareError>

    install_plan(id: FormulaId, plan: FormulaPlan)
        -> FormulaToken

    open_session(id: FormulaId, expected_token: FormulaToken,
                 snapshot_epoch: EpochId)
        -> Result<SessionId, SessionOpenError>

    capability_view(session: SessionId, id: FormulaId,
                    required: Set<FecCapabilityTag>)
        -> Result<FecCapabilityView, CapabilityError>

    commit(txn: EvalTransaction)
        -> CommitResult
}

interface F3eEvaluator {
    execute(request: EvalRequest) -> EvalTransaction
}

// ─── Scheduler ───

interface Scheduler {
    // Returns next batch of nodes to evaluate, given current overlay state
    next_batch(dep_overlay: &DepOverlay, spill_overlay: &SpillOverlay,
               policy: SchedulePolicy)
        -> Vec<NodeId>

    // Reports whether the current epoch is fully stabilized
    is_stabilized(dep_overlay: &DepOverlay) -> bool
}

enum SchedulePolicy {
    Deterministic,                          // strict topo order
    PartitionParallel { partition_count: u32 },
    VisibleFirst { visible_regions: Set<CellRegion>,
                   max_deferred_waves: u32 },
}
```

### 4.2 Commit Result / Reject Taxonomy

```
enum CommitResult {
    Applied {
        value_delta:    ValueDelta,
        shape_delta:    Option<SpillDelta>,
        topology_delta: Option<TopologyDelta>,
        format_delta:   Option<FormatDelta>,
        dep_delta:      F3eDependencyDelta,
    },
    Rejected {
        kind:   CommitRejectKind,
        detail: CommitRejectDetail,
    },
}

enum CommitRejectKind {
    SessionNotFound,
    FormulaNotRegistered,
    FormulaMismatch,
    ExpectedTokenMismatch,
    TransactionTokenMismatch,
    CapabilityNotBound,
    CapabilityDecisionMismatch,
    CapabilityDenied,
    SnapshotConflict,
    EpochAdvanced,              // coordinator epoch > session epoch
}

struct CommitRejectDetail {
    expected_token:   Option<FormulaToken>,
    actual_token:     Option<FormulaToken>,
    expected_epoch:   Option<EpochId>,
    actual_epoch:     Option<EpochId>,
    coordinator_epoch: Option<EpochId>,
    denied_capability: Option<FecCapabilityTag>,
    reject_code:      u32,      // machine-readable for replay harnesses
}
```

**Contract invariant**: `CommitRejectKind` is a closed enum. New reject reasons require a spec version bump. Every reject must populate `reject_code` for deterministic replay classification.

### 4.3 Required Deltas / Events

```
struct ValueDelta {
    node:         NodeId,
    prior_value:  Option<CellValue>,
    new_value:    CellValue,
    value_changed: bool,        // for early-cutoff decisions
}

struct F3eDependencyDelta {
    cells_added:         Set<NodeId>,
    cells_removed:       Set<NodeId>,
    names_added:         Set<NameId>,
    names_removed:       Set<NameId>,
    spill_children_added:   Set<NodeId>,
    spill_children_removed: Set<NodeId>,
    topology_impact:     TopologyImpact,
}

enum TopologyImpact {
    None,
    DependencySetChanged,
    SpillRangeChanged,
    SpillBlocked,
}

struct SpillDelta {
    anchor:        NodeId,
    event:         SpillDeltaEvent,
    prior_region:  Option<CellRegion>,
    current_region: Option<CellRegion>,
    entered_cells: Set<NodeId>,
    exited_cells:  Set<NodeId>,
}

enum SpillDeltaEvent {
    None,
    SpillTakeover,
    SpillClearance,
    SpillBlocked,
}

struct FormatDelta {
    node:          NodeId,
    tokens_added:  Set<FormatToken>,
    tokens_removed: Set<FormatToken>,
}
```

### 4.4 Epoch / Token Rules

| Rule | Statement |
|---|---|
| **EPOCH-001** | `EpochId` is monotonically increasing. The coordinator is the sole source of epoch advancement. |
| **EPOCH-002** | A `DocSnapshot` at epoch *e* is immutable. All mutations produce epoch *e+1*. |
| **EPOCH-003** | `open_session` binds a session to `snapshot_epoch`. The session sees only state ≤ that epoch. |
| **EPOCH-004** | `commit` succeeds only if `session.snapshot_epoch == coordinator.committed_epoch`. Otherwise: `SnapshotConflict`. |
| **EPOCH-005** | `committed_epoch` advances when all structural mutations for an edit batch are applied. `stabilized_epoch` advances when all formula evaluations for that epoch reach `Clean` state. |
| **EPOCH-006** | `FormulaToken` changes whenever `install_plan` is called for a `FormulaId`. A session holding a stale token is rejected with `ExpectedTokenMismatch`. |
| **EPOCH-007** | Between `committed_epoch` and `stabilized_epoch`, cells may be in `Stale` or `Necessary` state. The host must expose stale/pending status to UI (per `ARCHITECTURE_AND_REQUIREMENTS.md` CONSTR-009). |
| **EPOCH-008** | Epoch advancement during in-flight evaluation causes all open sessions for the prior epoch to receive `EpochAdvanced` on `commit`. The evaluator must re-open sessions against the new epoch. |

---

## 5. Recalc and Overlay Semantics

### 5.1 Structural Dependency Graph Rules

**STRUCT-DEP-001**: The structural dependency graph `G_s = (V, E_s)` is extracted from `DocSnapshot(e)` by static analysis of formula ASTs. `V` = all cells with formulas + all defined names. `E_s` = {(a, b) | formula at `a` contains a syntactic reference to `b`}.

**STRUCT-DEP-002**: `G_s` is a pure function of the snapshot. Given identical snapshot content, `G_s` is identical. This is the foundation of deterministic replay (DAG-PO-002).

**STRUCT-DEP-003**: SCC decomposition of `G_s` partitions `V` into strongly connected components. Each SCC with |SCC| > 1 is a cycle region. Evaluation order is: topological order of the SCC DAG, with intra-SCC iteration policy governed by profile (DEC-CYCLE-MODE: `Error` | `Iterative(max_iter, epsilon)`).

**STRUCT-DEP-004**: Structural rewrites (insert/delete row/col) produce a new snapshot and invalidate the entire structural dependency graph. The rewrite engine applies reference adjustment deterministically per `ENGINE_REQUIREMENTS.md` §Structural Mutations.

**STRUCT-DEP-005**: Name definitions participate in `G_s`. A name `N` defined as a formula creates edges from `N` to its syntactic references. A cell referencing `N` has edge (cell, `N`).

### 5.2 Calc-time Overlay Rules

**CALC-OVL-001**: The calc-time dependency overlay `G_r = (V, E_r)` records runtime-observed dependencies. `E_r` edges are created during F3E evaluation when the evaluator resolves INDIRECT, OFFSET, INDEX, or other dynamic references. `E_r ⊇ E_s` for formulas without dynamic references; `E_r` may differ from `E_s` for dynamic formulas.

**CALC-OVL-002**: Each `E_r` edge carries a **dependency token** `DynDepToken = { source: NodeId, target: NodeId | NameId, observation_epoch: EpochId, evaluator_seq: u64 }`. The token is used for: (a) invalidation when the target changes, (b) deterministic replay, (c) soundness proofs (DAG-PO-006).

**CALC-OVL-003**: The calc-time overlay is retained across epochs until explicitly invalidated. Invalidation occurs when:
- The source formula is re-parsed (structural edit) → all `E_r` edges from that source are dropped.
- A committed `F3eDependencyDelta` for that source reports `cells_removed` or `names_removed` → specific edges are dropped.
- The overlay is evicted by garbage collection (see CALC-OVL-005).

**CALC-OVL-004**: For incremental recalc, the invalidation set is: `dirty(e) = { n ∈ V | n was edited } ∪ { n ∈ V | ∃ (n, m) ∈ (E_s ∪ E_r) and m ∈ dirty(e) }`. The transitive closure is computed using the `Necessary` state: a node is `Necessary` if it is `Stale` AND at least one predecessor has a changed value.

**CALC-OVL-005**: Overlay garbage collection: an `E_r` edge `(a, b)` is eligible for collection when `a` has been evaluated at epoch `e_2 > e_1` (where `e_1` is the edge's `observation_epoch`) and the edge was not re-observed. The coordinator must not collect edges while any session referencing `observation_epoch ≤ e_1` is open.

**CALC-OVL-006**: **Pure-calc fast-path guard**: A formula evaluation may bypass overlay mutation tracking (producing no `F3eDependencyDelta`) if and only if:
1. The formula's structural dependencies (`E_s`) are identical to its prior runtime dependencies (`E_r`), AND
2. The formula does not invoke any function classified as `DynamicRef` or `FormatObservable`, AND
3. The formula is not a spill anchor.

This is a closed predicate; any formula not meeting all three conditions must use full overlay tracking.

### 5.3 Spill / Format / Visibility Overlay Interaction Rules

**SPILL-OVL-001**: The spill overlay maps each spill anchor `a` to its current spill region `R(a) = { (r, c) | a spills into (r, c) }`. A cell `c ∈ R(a)` is a spill child of `a`.

**SPILL-OVL-002**: Spill invalidation algebra. On commit of `SpillDelta` for anchor `a`:
```
let prior    = delta.prior_region    // may be empty
let current  = delta.current_region  // may be empty
let exited   = prior \ current       // cells no longer in spill region
let entered  = current \ prior       // cells newly in spill region

invalidation_set =
    exited                           // exited cells revert to own content
  ∪ entered                          // entered cells now display spill values
  ∪ { n | ∃ (n, c) ∈ (E_s ∪ E_r), c ∈ (exited ∪ entered) }
                                      // dependents of changed cells
  ∪ blocked_recovery_set(a)          // if prior was Blocked, dependents of unblocked anchor
```

**SPILL-OVL-003**: Spill conflicts. If `entered` intersects with a non-empty cell or another anchor's spill region, the anchor enters `SpillBlocked` state. In `SpillBlocked`: the anchor's value is `#SPILL!`, the prior region is cleared, and all prior spill children revert. The blocking cell set is recorded for future unblock detection.

**SPILL-OVL-004**: Spill recovery. When a blocking cell becomes empty (edit or spill clearance of the blocker), the coordinator re-evaluates the blocked anchor. If the new spill region is conflict-free, the anchor transitions from `SpillBlocked` to `SpillTakeover`.

**FORMAT-OVL-001**: The format overlay tracks formatting dependency tokens for formatting-observable functions. A `FormatToken = { node: NodeId, property: FormatProperty, value_hash: u64 }` represents a dependency on a specific formatting property of a cell.

**FORMAT-OVL-002**: Format invalidation. When a cell's formatting changes, all formula nodes holding a `FormatToken` referencing that cell are marked `Stale`. This is a profile-gated behavior (DEC-CALC-007); when the gate is off, format changes do not trigger recalc.

**VIS-OVL-001**: The visibility overlay records which cell regions are currently visible to the user. It is updated by the host (scroll, tab switch, resize). It does not affect semantic correctness—only scheduling priority.

**VIS-OVL-002**: Under `SchedulePolicy::VisibleFirst`, the scheduler prioritizes `Necessary` nodes within visible regions. Invariant: after `max_deferred_waves` scheduling waves, all non-visible `Necessary` nodes must be scheduled regardless of visible-region state (starvation prevention per DEC-CALC-008).

**VIS-OVL-003**: Visibility changes during in-flight recalc do not alter the epoch or invalidate any overlay. They only update the scheduler's priority input for future `next_batch` calls.

---

## 6. Concurrency Model

### 6.1 Coordinator Responsibilities

The `Coordinator` is the central serialization point for all state transitions. It is logically single-threaded but may be implemented as an async event loop with message passing.

| Responsibility | Description |
|---|---|
| **Epoch management** | Advances `committed_epoch` on structural mutation; advances `stabilized_epoch` when all nodes reach `Clean`. |
| **Session lifecycle** | Creates sessions bound to a snapshot epoch; tracks active sessions; rejects stale sessions on epoch advancement. |
| **Overlay ownership** | Owns all overlay instances; applies deltas from committed evaluations; manages GC. |
| **Commit serialization** | Processes `commit` calls sequentially; validates tokens/epochs; applies deltas atomically. |
| **Scheduler dispatch** | Invokes `Scheduler::next_batch`; dispatches evaluation requests to worker pool; collects results. |
| **Publication control** | Determines when to publish intermediate state to host (stale/pending) vs. final state (stabilized). |

### 6.2 Snapshot Fences

**FENCE-001**: A snapshot fence is established at each epoch boundary. All reads within an evaluation session see exactly the state at the session's `snapshot_epoch`. No write from a concurrent session or structural edit is visible until the session commits and a new session is opened at a later epoch.

**FENCE-002**: Implementation: `DocSnapshot` is an immutable persistent data structure (structural sharing). Creating a new epoch clones the snapshot with copy-on-write. Evaluation sessions hold a reference to the snapshot at their epoch—no locks required for reads.

**FENCE-003**: Overlay reads during evaluation use the overlay state as of the session's `snapshot_epoch`. Concurrent overlay mutations (from other committed sessions at the same epoch) are visible only after the current session commits and re-opens.

**FENCE-004**: Cross-epoch consistency: if a structural mutation advances the epoch during an in-flight evaluation batch, the coordinator:
1. Marks all open sessions as `epoch_invalidated`.
2. Allows in-flight `execute` calls to complete (they may produce stale results).
3. Rejects `commit` calls from invalidated sessions with `EpochAdvanced`.
4. Re-opens sessions against the new epoch and re-schedules affected nodes.

### 6.3 Contention / Retry Behavior

**CONTENTION-001**: Two evaluation sessions for different formulas at the same epoch do not contend—they read the same immutable snapshot and produce independent deltas.

**CONTENTION-002**: Two sessions for the same formula at the same epoch are serialized by the coordinator. The second `open_session` call blocks until the first session commits or is abandoned. Timeout: coordinator-configured, default 5 seconds. On timeout: the blocked session receives `SessionOpenError::Contention`.

**CONTENTION-003**: After `SnapshotConflict` or `EpochAdvanced` rejection, the evaluator must:
1. Discard the rejected `EvalTransaction`.
2. Re-acquire the formula plan (which may have changed if the structural edit affected the formula).
3. Open a new session at the current `committed_epoch`.
4. Re-execute.

This is a mandatory retry protocol, not an optional optimization.

**CONTENTION-004**: The coordinator tracks a `contention_count` per epoch for diagnostic purposes. If `contention_count` exceeds a threshold (`CONSTR-CONTENTION-THRESHOLD`, default 100), the coordinator logs a diagnostic and optionally falls back to sequential evaluation for that epoch.

**CONTENTION-005**: Deterministic contention replay. For conformance testing, a `ContendedReplayLog` captures all session open/commit/reject events with their timestamps, epoch, and formula IDs. Replaying this log with a deterministic scheduler must produce identical commit outcomes (DAG-PO-002).

---

## 7. Adoption Roadmap

### Phase 1: Structural Foundation (Round 0 target — DnaVisiCalc)

**Goal**: Deliver the immutable structural model, full-rebuild recalc, and FEC/F3E Plan B b4 transaction lane with single-threaded coordinator.

| Work item | Description | Blocker gate |
|---|---|---|
| 1.1 Green-tree kernel | Implement immutable `DocSnapshot` with structural sharing, `NodeId` identity, reference model | `PACK.visicalc.core` |
| 1.2 Structural dependency extraction | Implement `G_s` extraction from snapshot; SCC decomposition | `PACK.dag.cycle_iterative_semantics` |
| 1.3 Full-rebuild recalc | Deterministic topological evaluation; cycle handling (Error + Iterative modes) | `PACK.dag.baseline_recalc_core` |
| 1.4 FEC/F3E Plan B adoption | Adopt Plan B b4 contracts; single-threaded coordinator; all reject taxonomy | FEC/F3E seam scenario suite |
| 1.5 Spill support (conservative) | Full-recalc on any spill shape change; SpillBlocked/SpillTakeover/SpillClearance events | `PACK.visicalc.core` spill subset |
| 1.6 Change tracking + formatting | Metadata-only formatting overlay; change tracking iterators | Existing DnaVisiCalc conformance |
| 1.7 Conformance baseline | DAG-CONF-001 (canonical recalc order), DAG-CONF-002 (SCC diagnostics) | Green team validation |

**Compatibility shims**:
- Current DnaVisiCalc C-API (`dvc_*`) remains the host-facing surface. Internal engine replaces implementation behind same API.
- `engine.recalculate_full` maps directly to Phase 1 full-rebuild.
- `engine.recalculate_incremental` falls back to full-rebuild with a diagnostic log entry.

### Phase 2: Incremental Engine (Round 0+ / early Round 1)

**Goal**: Enable incremental recalc with dual-layer dependencies, algebraic spill invalidation, and partition-parallel evaluation.

| Work item | Description | Blocker gate |
|---|---|---|
| 2.1 Calc-time overlay infrastructure | Implement `DepOverlay`, `SpillOverlay` with epoch versioning and GC | `PACK.dag.dynamic_dependency_bind_semantics` |
| 2.2 Dirty/stale/necessary state machine | Implement `NodeCalcState` transitions; early cutoff | `PACK.dag.early_cutoff.signature` |
| 2.3 Incremental invalidation | Implement CALC-OVL-004 transitive closure; runtime dependency delta integration | DAG-PO-001 (from-scratch equivalence) |
| 2.4 Algebraic spill invalidation | Implement SPILL-OVL-002; replace conservative full-recalc | DAG-PO-006, DAG-PO-007 |
| 2.5 Multi-session coordinator | Extend coordinator for concurrent sessions; contention protocol | `PACK.concurrent.epochs` |
| 2.6 Partition-parallel evaluation | Implement `SchedulePolicy::PartitionParallel`; deterministic merge | `PACK.dag.parallel_determinism_signature` |
| 2.7 Pure-calc fast path | Implement CALC-OVL-006 guard; bypass overlay tracking for qualifying formulas | Benchmark against Phase 1 baseline |
| 2.8 Dynamic topo maintenance | Replace full SCC recomputation with incremental topo updates | `PACK.dag.dynamic_topo_vs_rebuild` |

**Compatibility shims**:
- `engine.recalculate_incremental` now uses real incremental path.
- `engine.recalculate_full` remains available as explicit fallback.
- `incremental_spill_fallback` becomes algebraic invalidation.

### Phase 3: Policy Extensions (Round 1 — DnaPreCalc)

**Goal**: Enable formatting overlay, visibility-first scheduling, external stream integration, and advanced profile features.

| Work item | Description | Blocker gate |
|---|---|---|
| 3.1 Format overlay | Implement `FormatOverlay`; `FormatToken`; FORMAT-OVL-001/002 | DEC-CALC-007 conformance |
| 3.2 Visibility-first scheduling | Implement `SchedulePolicy::VisibleFirst`; starvation bound | DEC-CALC-008 conformance; DAG-PO-010 |
| 3.3 External stream integration | STREAM function with topic-based invalidation; `ExternallyInvalidated` class | `PACK.stream.basic`; `PACK.dag.external_stream_ordering` |
| 3.4 Profile-version invalidation | Function catalog change triggers selective re-parse/re-bind | Profile evolution spec |
| 3.5 Contention replay harness | Deterministic replay of concurrent evaluation traces | `PACK.concurrent.epochs` extended |

### Phase 4: Advanced (Round 2+ — DnaSuperCalc)

**Goal**: Evaluate and selectively adopt differential/timely semantics for high-frequency streaming and collaboration.

| Work item | Description | Blocker gate |
|---|---|---|
| 4.1 Differential evaluation prototype | SAC-to-differential bridge for streaming hot paths | Research gate; transfer matrix reassessment |
| 4.2 Collaboration as OpLog replication | Multi-user concurrent editing via OpLog merge | Collaboration spec (not yet drafted) |
| 4.3 Semiring provenance | Algebraic trace reasoning for explainability | Research gate |

---

## 8. Open Questions and Decisive Experiments

### Open Questions

| ID | Question | Impact | Resolution path |
|---|---|---|---|
| OQ-001 | What is the canonical publication ordering when value, dependency, spill, and format overlays all change in one commit? | Affects observer correctness for UI and change tracking | Specify in §5.3 (proposed: INV-ARCH-007); validate with multi-overlay scenario test |
| OQ-002 | Which deterministic replay schema becomes canonical across concurrent evaluator traces? | Affects conformance testing and regression infrastructure | Design canonical `EvalReplayRecord` schema; test with contention replay pack |
| OQ-003 | How should degradation classes be encoded for dynamic-reference and visibility-priority edge behavior? | Affects profile specification and interop | Propose enum-based degradation classification; validate with profile compatibility test matrix |
| OQ-004 | Is the pure-calc fast-path guard (CALC-OVL-006) sound under all profile configurations? | Affects correctness of performance optimization | Formal proof obligation (extend DAG-PO-001 to cover fast-path bypass) |
| OQ-005 | What is the correct GC policy for calc-time overlay edges when sessions have heterogeneous lifetimes? | Affects memory behavior under long-running evaluations | Prototype GC with session watermark tracking; measure memory under stress |
| OQ-006 | Should the coordinator contention protocol use blocking or CAS-based retry? | Affects throughput under high concurrency | Benchmark both approaches with synthetic contention workload |
| OQ-007 | How does the spill invalidation algebra interact with iterative cycle evaluation (SCC containing a spill anchor)? | Affects correctness of cycle-with-spill edge case | Construct test case: cyclic formula with dynamic array spill; verify convergence |
| OQ-008 | What is the impact of NaN-equality semantics on early-cutoff decisions for floating-point values? | Affects DAG-PO-008 soundness | Declare NaN ≠ NaN for early-cutoff (conservative); measure recalc amplification |

### Decisive Experiments

| ID | Experiment | Expected outcome | Decision unlocked |
|---|---|---|---|
| EXP-001 | **Full-rebuild vs. incremental baseline**: Run DnaVisiCalc conformance suite with both strategies; compare outputs bit-for-bit. | Bit-identical outputs; incremental is ≥2x faster on edit-recalc cycles. | Validates DAG-PO-001; unlocks Phase 2 adoption. |
| EXP-002 | **Contention stress test**: Synthetic workload with 100 concurrent formula evaluations on overlapping dependency regions. | All commits succeed or reject deterministically; no deadlock or livelock within 10s. | Validates CONTENTION-001..005; unlocks multi-session coordinator. |
| EXP-003 | **Spill algebra correctness**: 50-case spill scenario matrix (takeover, clearance, blocked, recovery, nested spill, cyclic spill). | All cases produce correct values matching full-rebuild baseline. | Validates SPILL-OVL-001..004; unlocks algebraic spill invalidation. |
| EXP-004 | **Pure-calc fast-path validation**: Identify all formulas in conformance suite that qualify for fast-path; evaluate with and without tracking; compare outputs. | Bit-identical; fast-path formulas are ≥30% of total. | Validates CALC-OVL-006; unlocks fast-path optimization. |
| EXP-005 | **Partition-parallel determinism**: Run conformance suite with 1, 2, 4, 8 partitions; compare value signatures. | Bit-identical across all partition counts. | Validates DAG-PO-010; unlocks parallel evaluation. |
| EXP-006 | **Visibility-first starvation bound**: Run large sheet with visible region = 1% of cells; measure maximum latency for non-visible cell stabilization under continuous scrolling. | Non-visible cells stabilize within `max_deferred_waves` waves (≤ 10). | Validates VIS-OVL-002; unlocks visibility-first policy. |
| EXP-007 | **Dynamic dependency token lifecycle**: Run INDIRECT/OFFSET-heavy workload through 100 edit-recalc cycles; verify no stale dependency tokens persist beyond their validity. | Zero stale tokens after each stabilization; overlay memory bounded. | Validates CALC-OVL-003/005; unlocks dynamic dependency tracking. |
| EXP-008 | **Overlay GC under session watermark**: Long-running evaluation (simulated 60s) with concurrent short evaluations; measure overlay memory growth. | Memory bounded by O(active_sessions × avg_overlay_size). | Resolves OQ-005; validates GC policy. |

---

## 9. Pack / Proof Checklist (Concrete and Testable)

### Proof Obligations

| ID | Obligation | Testable predicate | Phase | Status |
|---|---|---|---|---|
| **PO-001** | Acyclic from-scratch equivalence (DAG-PO-001) | `∀ acyclic snapshot: incremental_result == full_rebuild_result` | Phase 2 | Required |
| **PO-002** | Deterministic replay (DAG-PO-002) | `∀ op_stream: replay(ops) == original_run(ops)` values and errors | Phase 1 | Required |
| **PO-003** | SCC partition correctness (DAG-PO-003) | `scc_decompose(G_s) == reference_scc(G_s)` for all test graphs | Phase 1 | Required |
| **PO-004** | Bounded iterative determinism (DAG-PO-004) | `∀ cyclic snapshot with iteration policy: result is deterministic` | Phase 1 | Required |
| **PO-005** | Dynamic dependency soundness (DAG-PO-006) | `if deps_unchanged(n, e1, e2) then value(n, e1) == value(n, e2)` (excluding volatile) | Phase 2 | Required |
| **PO-006** | Dynamic from-scratch consistency (DAG-PO-007) | `incremental_dynamic == full_rebuild` for all supported dynamic functions | Phase 2 | Required |
| **PO-007** | Early-cutoff safety (DAG-PO-008) | `cutoff(n) ⟹ ∀ successors m: value(m) unchanged` | Phase 2 | Required |
| **PO-008** | Parallel schedule confluence (DAG-PO-010) | `∀ partition_count ∈ {1..8}: values_identical` | Phase 2 | Required |
| **PO-009** | Commit atomicity | `commit(txn) == Applied ⟹ all deltas visible; commit(txn) == Rejected ⟹ no delta visible` | Phase 1 | Required |
| **PO-010** | Epoch monotonicity | `∀ t1 < t2: epoch(t1) ≤ epoch(t2)` and no epoch reuse | Phase 1 | Required |
| **PO-011** | Snapshot fence correctness | `∀ session at epoch e: reads(session) ⊆ state(e)` | Phase 1 | Required |
| **PO-012** | Spill invalidation completeness | `spill_invalidation_set ⊇ all_affected_cells` (no missed invalidation) | Phase 2 | Required |
| **PO-013** | Pure-calc fast-path soundness | `fast_path_result(n) == full_tracking_result(n)` when guard is true | Phase 2 | Required |
| **PO-014** | Visibility-policy equivalence | `∀ policy ∈ {Deterministic, VisibleFirst}: final_values_identical` | Phase 3 | Required |
| **PO-015** | Overlay GC safety | No overlay edge collected while referenced by an active session | Phase 2 | Required |

### Empirical Packs

| Pack ID | Name | Phase | Contents | Pass criterion |
|---|---|---|---|---|
| **PACK.visicalc.core** | Baseline DnaVisiCalc conformance | Phase 1 | Full DnaVisiCalc test suite; structural rewrite scenarios; cycle/iterative modes | 100% pass; bit-identical to current baseline |
| **PACK.dag.baseline_recalc_core** | Baseline recalc validation | Phase 1 | Topological ordering tests; SCC decomposition tests; full-rebuild correctness | All PO-002, PO-003, PO-004 predicates pass |
| **PACK.dag.cycle_iterative_semantics** | Cycle handling | Phase 1 | Cyclic graphs with Error/Iterative modes; convergence; determinism | PO-004 passes; max_iterations honored; epsilon convergence verified |
| **PACK.dag.dynamic_dependency_bind_semantics** | Dynamic dependency tracking | Phase 2 | INDIRECT/OFFSET/INDEX scenarios; dependency token lifecycle; cross-epoch validity | PO-005, PO-006 pass; no stale tokens after stabilization |
| **PACK.dag.early_cutoff.signature** | Early cutoff behavior | Phase 2 | Scenarios where value unchanged; downstream not re-evaluated; per-type equality check | PO-007 passes; cutoff ratio ≥ 20% on typical workloads |
| **PACK.dag.dynamic_topo_vs_rebuild** | Dynamic topo maintenance | Phase 2 | Edit-recalc cycles; compare incremental topo update vs. full SCC recomputation | Bit-identical results; incremental ≥ 1.5x faster |
| **PACK.dag.parallel_determinism_signature** | Parallel determinism | Phase 2 | Same workload at partition counts 1, 2, 4, 8; value signature comparison | PO-008 passes; bit-identical across partition counts |
| **PACK.concurrent.epochs** | Concurrent epoch management | Phase 2 | Multi-session open/commit/reject sequences; contention scenarios; epoch advancement during evaluation | PO-009, PO-010, PO-011 pass; no deadlock; deterministic replay matches |
| **PACK.spill.algebraic** | Algebraic spill invalidation | Phase 2 | Spill takeover/clearance/blocked/recovery; nested spill; cyclic spill anchor; invalidation completeness | PO-012 passes; all scenarios match full-rebuild baseline |
| **PACK.fast_path** | Pure-calc fast path | Phase 2 | Guard predicate validation; fast-path vs. full-tracking comparison | PO-013 passes; guard misclassification rate = 0% |
| **PACK.format.overlay** | Formatting overlay | Phase 3 | FORMAT-OVL-001/002 scenarios; TEXT function with format changes; profile gate on/off | PO-014 (format subset) passes |
| **PACK.visibility.policy** | Visibility-first scheduling | Phase 3 | Visible-first vs. deterministic comparison; starvation bound verification; scroll-during-recalc | PO-014 passes; starvation bound ≤ max_deferred_waves |
| **PACK.stream.basic** | External stream ordering | Phase 3 | STREAM function; topic-based invalidation; replay determinism | DAG-PO-009 passes |
| **PACK.overlay.gc** | Overlay garbage collection | Phase 2 | Long-running sessions; heterogeneous lifetimes; memory measurement | PO-015 passes; memory bounded per OQ-005 criterion |

### Conformance Row Bindings

| Conformance row | Pack binding | Artifact required |
|---|---|---|
| DAG-CONF-001 (canonical recalc order) | `PACK.dag.baseline_recalc_core` | Recalc order trace file per epoch |
| DAG-CONF-002 (SCC/cycle diagnostics) | `PACK.dag.cycle_iterative_semantics` | SCC membership + cycle mode trace per evaluation |
| DAG-CONF-003 (dynamic dep trace) | `PACK.dag.dynamic_dependency_bind_semantics` | Dependency-set trace artifact per stabilization wave |
| DAG-CONF-004 (early-cutoff observability) | `PACK.dag.early_cutoff.signature` | Per-node `value_changed` trace field |
| DAG-CONF-005 (external update replay) | `PACK.stream.basic` | Replayable external update envelope log |
| DAG-CONF-006 (parallel bit-identity) | `PACK.dag.parallel_determinism_signature` | Value signature hash per partition configuration |
| DAG-CONF-007 (dynamic-topo fallback counts) | `PACK.dag.dynamic_topo_vs_rebuild` | Fallback-to-rebuild counter + parity check log |
| DAG-CONF-008 (iterative cycle mode declaration) | `PACK.dag.cycle_iterative_semantics` | Per-SCC result classification (fixed-point / bounded-pragmatic) |

---

*End of deliverable. All claims cite sources under `inputs/source/`. Terminology mapping: F3E is used throughout; where source material uses F3C, the mapping F3E→F3C applies per base prompt §Source handling rules.*
