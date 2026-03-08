Let me check memory for any relevant prior context.

<tool_calls>
<tool_call>
<tool_name>Read</tool_name>
<tool_input>{"file_path": "C:/Users/GovertvanDrimmelen/.claude/projects/C--Work-DnaCalc-Foundation/memory/MEMORY.md"}
</tool_input>
</tool_call>
</tool_calls>
<tool_results>
<tool_result>
<status>success</status>
<output>
# DNA Calc Foundation — Project Memory

## Project Overview
- **DNA Calc** is a spreadsheet calculation engine (clean-room, no Excel source reference)
- Foundation repo contains research, specs, and design documents (no application code yet)
- Key products: DnaVisiCalc (Round 0), DnaPreCalc (Round 1), DnaSuperCalc (Round 2+)

## Repository Structure
- `specs/` — formal specifications (core engine, FEC/F3E contracts, formal model)
- `research/` — deep research runs with topic registry and synthesis outputs
- `prompts/` — prompt packs for model invocations
- `synthesis/` — synthesis run outputs
- `notes/` — working notes and archives

## Key Specifications
- **Five-Layer Model (S/R/D/V/O)**: Structural, Reference, Dependency, Value, Overlay
- **FEC/F3E**: Formula Evaluation Contract / Formula-Function-Feature Evaluator
  - Plan B "b4" transaction lane is the selected design direction
  - Core contracts: prepare → install → open_session → capability_view → commit
- **Epoch semantics**: committed_epoch vs stabilized_epoch; monotonic advancement

## Terminology
- F3E and F3C are used interchangeably in some docs; prefer F3E in outputs
- "Plan B" / "b4" = the selected transaction lane design for FEC/F3E

## Research Topics
- DAG computation theory (topological sort, SCC, incremental recalc, SAC model)
- Transfer matrix maps concepts to Round 0/1/2+ adoption timeline
- Proof obligations (DAG-PO-001 through DAG-PO-010) defined with testable predicates
- Empirical packs (PACK.dag.*) define test scenarios and pass criteria

## Active Work Patterns
- Deep research runs produce synthesis documents in `synthesis/runs/`
- Prompt packs in `prompts/runs/` feed model invocations
- Dual-model review passes use compact source packs as single-file input
- Topic registry in `research/topic_registry.csv` tracks all research topics

## User Preferences
- Concise, rigorous technical writing
- Formal model terminology preferred
- No "production ready" language (per global CLAUDE.md)
- Structured deliverables with clear section ordering
</thinking>
</output>
</tool_result>
</tool_calls>

Good — I have full grounding in the source material. Here is the critique followed by the complete revised answer.

---

## Self-Review Round 1: Critique

### Errors

1. **CALC-OVL-001 misstatement**: Claims "E_r ⊇ E_s for formulas without dynamic references." This is wrong — E_r is the *runtime-observed* edge set, not a superset of the structural set. For non-dynamic formulas, E_r should *equal* E_s. For conditionally-evaluated formulas (IF branches), E_r can be a *strict subset* of E_s. Fix: state the correct relationship.

2. **Missing finding: no `applied_epoch` in `CommitResult`**. Source material (REDESIGN_OBSERVATIONS Remaining Gap #3) explicitly flags this. The contract draft in §4.2 omits `applied_epoch` from `CommitResult::Applied`, creating an internal inconsistency with EPOCH-004 (which requires epoch validation). The Gemini synthesis correctly has this as a separate finding.

3. **Missing finding: session timeout/abandonment protocol**. Source material (REDESIGN_OBSERVATIONS Remaining Gap #5) calls this out. The prior answer's concurrency model has no timeout, GC, or abandonment mechanism for sessions.

4. **Invented specifics without source grounding**: CONTENTION-002 invents "default 5 seconds" timeout; CONTENTION-004 invents threshold "100". These are presented as defaults but no source supports them. Should be flagged as proposed parameters.

5. **`EpochAdvanced` added to reject taxonomy without flagging it as an extension**. The source spec's `CommitRejectKind` enum does not include `EpochAdvanced` — the prior answer silently extends a closed enum while simultaneously declaring it closed.

6. **CALC-OVL-006 (pure-calc fast-path) omits volatile functions** as a guard exclusion. The formal model (§3: Volatile Functions) explicitly states volatiles bypass early cutoff and are always Necessary. A volatile formula should never qualify for fast-path, but the guard predicate doesn't mention this.

7. **`PACK.visicalc.core` is invented**. The source empirical pack definitions define `PACK.dag.*` and `PACK.concurrent.epochs` — there is no `PACK.visicalc.core`. The prior answer uses it as a gate in Phase 1 without source grounding.

8. **Phase 1 compatibility shims reference "dvc_*" C-API** which appears in no source document. Likely invented.

### Missing Coverage

9. **No treatment of OQ-CYC-1 (spill anchors in cycles)**. The research review recommends prohibiting dynamic array formulas in cycles for Round 0-1. This is a design decision with direct impact on spill overlay rules but is only mentioned as an open question (OQ-007), not integrated into the rules.

10. **Architecture diagram omits VisibilityOverlay** despite VIS-OVL rules in §5.3.

11. **No CapabilityView observation hook design**. Source material (REDESIGN_OBSERVATIONS Takeaway #2, Implementation Evidence §4) identifies CapabilityView as the natural extension point with specific hooks (`on_cell_read`, `on_format_read`, `on_name_resolve`). The prior answer's F3E evaluator has no observation mechanism — `execute` produces an `EvalTransaction` but no path for how runtime deps are captured during execution.

12. **Floating-point determinism resolution not integrated**. The research review recommends canonical ordering (sequential semantics) for Round 0-1 (OQ-FP-1). This recommendation should be stated as a design decision, not just an open question.

### Structural / Quality Issues

13. **INV-ARCH-007 (publication ordering) presented as established** when source material marks it as OQ-1. Should be flagged as a proposed resolution.

14. **NodeId typing inconsistency**: Defined as `{ sheet, row, col }` (cell-only) but used as `NodeId | NameId` in dependency sets. The structural model says names participate in the graph. Either NodeId should be a union type or the dependency edge types need a proper entity discriminator.

15. **Trade-off matrix "Risk of over-engineering" gives Option A "None"** — misleading. Option A has risk of *under-engineering* requiring costly retrofit, which is the central argument for Option B.

16. **F-004 and F-005 in prior answer are semantically adjacent but miss the concrete contract gap**. The Gemini synthesis correctly separates the *observation mechanism gap* (CapabilityView doesn't track reads) from the *feedback channel gap* (CommitResult lacks dep/format deltas). The prior answer merges these into token-lifecycle and formatting-overlay findings, losing the concrete contract deficiency.

17. **Epoch semantics don't address partial-batch commits**. If some formulas in a recalc batch commit at epoch N and then a structural edit advances to N+1, the status of the epoch-N committed values is unaddressed.

---

# Deep Research Synthesis: Core DAG Recalc + FEC/F3E Seam

**Run**: `20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01`
**Model**: Claude Opus 4.6 — self-review round 1 output
**Source authority**: `inputs/compact-source-pack.md` (curated single-file input)

---

## 1. Findings (ordered by severity)

### Critical

**F-001. Calc-time overlay lifecycle has no formal specification.**
The five-layer model (S/R/D/V/O) in the Formal Model describes overlay roles but does not define: (a) when a calc-time dependency overlay is instantiated, (b) how it interacts with epoch transitions, (c) when it becomes eligible for eviction, or (d) how publication of overlay state is ordered relative to value publication. Without this, incremental recalc correctness cannot be formally stated.
*Sources*: Formal Model §Layer O open questions; Synthesis Context Gap #1.

**F-002. Coordinator is single-threaded; no contention/retry protocol.**
The FEC/F3E seam coordinator is explicitly single-threaded (Redesign Observations §Observation 1) with no defined behavior for: concurrent `open_session` calls on the same formula, contention between a structural edit and an in-flight evaluation, or retry semantics after `SnapshotConflict`. This blocks async/high-concurrency recalc.
*Sources*: Redesign Spec §Open Items 4.1–4.2; Redesign Observations §Remaining Gaps 4; Synthesis Context Gap #2.

**F-003. Spill invalidation algebra is undefined.**
When a spill region changes shape (takeover, clearance, blocked→recovered), the exact set of cells and dependents requiring re-evaluation is not formally specified. The prior-region / current-region difference calculation, interaction with blocked cells, and cascade through dependent formulas all need algebraic precision. The `SpillDeltaEvent` contract is observationally defined but not semantically grounded.
*Sources*: Redesign Spec §Spill Semantics / Unspecified Aspects; Synthesis Context Gap #3.

### High

**F-004. Runtime dependency observation mechanism is absent.**
`CapabilityView` provides read-only document access but does not track which cells the evaluator actually reads (Redesign Observations §Observation 4). This means runtime dependencies (INDIRECT, OFFSET, INDEX) are invisible to the dependency graph. Without observation hooks, the overlay layer has no input for runtime dependency edges, and incremental invalidation for dynamic formulas is impossible.
*Sources*: Redesign Observations §Observation 4, §Takeaway 2; Implementation Evidence §CapabilityView Evidence.

**F-005. `CommitResult::Applied` lacks dependency, format, and epoch fields.**
The current `CommitResult` includes value and shape deltas but no: (a) `F3eDependencyDelta` for runtime dependency changes, (b) `FormatDelta` for formatting observation changes, (c) `applied_epoch` for epoch verification. Without (a), the dependency graph cannot be incrementally maintained. Without (b), DEC-CALC-007 has no feedback channel. Without (c), the caller cannot verify epoch alignment.
*Sources*: Redesign Observations §Remaining Gaps 1–3; Synthesis Context DEC-CALC-007; Implementation Evidence §CommitStatus Observations.

**F-006. Publication ordering during composite commits is undefined.**
A single `commit` can produce value, shape, and topology changes simultaneously. The order in which these become visible to downstream consumers, the atomicity guarantee (all-or-nothing vs. partial visibility), and the interaction with epoch advancement are not specified.
*Sources*: Redesign Spec §Open Item 4.5; Redesign Observations §Observation 3; Synthesis Context OQ-1.

**F-007. Dynamic dependency token semantics are open.**
Dynamic references (INDIRECT, OFFSET, runtime name resolution) create evaluation-time-observed dependencies. What constitutes a dependency token, how long tokens survive, and invalidation semantics across epoch boundaries are all unspecified. DAG-PO-006 and DAG-PO-007 require this for soundness proofs.
*Sources*: DAG Research Review §3 (OQ-DYN-1, OQ-DYN-2, OQ-DYN-3); Conformance and Proof Obligations DAG-PO-006/007.

**F-008. Pure-calc fast-path has no formal guard predicate.**
The concept of bypassing overlay mutation tracking for "pure" formulas is referenced but has no testable predicate. Without formal guard conditions, the optimization cannot be safely enabled.
*Sources*: Synthesis Context Gap #4.

### Medium

**F-009. Parallel reduction tie-break rules are incomplete.**
For floating-point-sensitive operations (SUM over parallel partitions), canonical reduction ordering is acknowledged as necessary but not specified. DAG-PO-010 requires bit-identical results across partition counts.
*Sources*: DAG Research Review §4 (OQ-FP-1); Conformance and Proof Obligations DAG-PO-010.

**F-010. Profile-version invalidation triggers are missing.**
When a profile version changes (function added/removed/behavior-altered) or the function catalog is updated at runtime, the invalidation scope across the dependency graph is undefined.
*Sources*: Synthesis Context Gap #6.

**F-011. Visibility-priority scheduling lacks starvation bound.**
DEC-CALC-008 mandates starvation prevention under visible-first scheduling but specifies no concrete bound, fairness algorithm, or maximum delay guarantee.
*Sources*: Synthesis Context DEC-CALC-008.

**F-012. Trace replay schema is not canonical.**
Multiple trace formats exist (fec-f3e-trace/b4, seam event counts, callgraph edges). No single canonical schema is defined for replaying concurrent evaluation with deterministic outcome verification.
*Sources*: Synthesis Context OQ-2; Implementation Evidence §Trace Schema Observations.

**F-013. Session timeout/abandonment protocol is missing.**
If an evaluator opens a session but never commits, the session remains open indefinitely, holding resources (capability view, snapshot reference). No mechanism exists for the coordinator to detect and reclaim abandoned sessions.
*Sources*: Redesign Observations §Remaining Gap 5.

### Low

**F-014. Early-cutoff equality semantics need per-type declaration.**
DAG-PO-008 requires equality semantics declared per value type. The formal model provides a table (Number: bitwise/NaN≠NaN, Text: ordinal, Boolean: value, Error: variant, Array: element-wise, Empty: always equal) but this is in the formal model, not in the contract layer. The contract must import or bind these declarations.
*Sources*: Formal Model §3 Value Identity; Conformance and Proof Obligations DAG-PO-008.

**F-015. Degradation class encoding for unsupported dynamic references is open.**
How a profile represents "INDIRECT is not supported in this profile" vs. "INDIRECT is supported but may degrade" has no concrete encoding.
*Sources*: Synthesis Context OQ-3.

**F-016. Cycle–spill interaction is unresolved.**
If a cell in a cycle is a dynamic array formula (spill anchor), the spill region may change on each iteration, altering dependency structure and potentially cycle membership. The research review recommends prohibiting this for Round 0-1.
*Sources*: DAG Research Review §5 (OQ-CYC-1).

---

## 2. Design Options with Trade-off Matrix

### Option A: Conservative Layered (Full-Rebuild Baseline)

**Core concept**: Implement the structural model and full-rebuild recalc engine with static dependencies first. All dynamic dependency tracking, incremental invalidation, and concurrency are deferred.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree; ID-based identity |
| Dependency graph | Static-only; edges extracted at parse/bind time |
| Recalc | Deterministic topological sort + SCC decomposition; full rebuild per epoch |
| FEC/F3E | Plan B b4 contracts as-is; single-threaded coordinator |
| Overlay model | None; structural deps only |
| Concurrency | Sequential evaluation; host serializes all mutation |
| Spill | Conservative full-recalc on any spill shape change |
| Visibility-first | Not supported |

### Option B: Incremental-Ready (Dual-Layer Overlay)

**Core concept**: Build with dual-layer dependency tracking (structural + runtime-observed) and incremental invalidation from the start. SAC-inspired dirty/stale/necessary state machine with early cutoff. Explicit overlay instances for dependencies, spill, and formatting.

| Aspect | Design |
|---|---|
| Structural model | Immutable green-tree with structural sharing; stable `NodeId` |
| Dependency graph | Dual-layer: structural edges (parse-time) + runtime-observed edges (eval-time, tokenized) |
| Recalc | Dynamic topological maintenance; dirty/stale/necessary/clean state machine; early cutoff; full-rebuild fallback |
| FEC/F3E | Extended Plan B: dep delta + format delta + applied_epoch in CommitResult; CapabilityView observation hooks; multi-session coordinator |
| Overlay model | Separate epoch-versioned instances: DepOverlay, SpillOverlay, FormatOverlay |
| Concurrency | Partition-parallel evaluation; deterministic merge with canonical reduction; epoch/MVCC snapshots |
| Spill | Algebraic invalidation: `invalidate(prior_region ∆ current_region) ∪ blocked_deps` |
| Visibility-first | Optional policy lane with bounded starvation |

### Option C: Differential Stream-Native

**Core concept**: Design for differential/timely change-propagation semantics. External streams, collaboration updates, and formula edits all enter a unified change-propagation framework.

| Aspect | Design |
|---|---|
| Structural model | Log-structured immutable store with persistent indexing |
| Dependency graph | Full differential dataflow graph; edges carry change types (insert/delete/update) |
| Recalc | Differential maintenance; lattice-based convergence for cycles; stream-aligned epochs |
| FEC/F3E | Distributed coordinator; CAS-based contention; per-formula epoch advancement |
| Overlay model | Unified change-propagation operators; overlays are dataflow subgraphs |
| Concurrency | Fully concurrent with capability-based isolation; progress tracking per frontier |
| Spill | Spill as dataflow operator with output-port semantics |
| Visibility-first | Natural via frontier priority |

### Trade-off Matrix

| Criterion | Option A (Conservative) | Option B (Incremental-Ready) | Option C (Differential) |
|---|---|---|---|
| Implementation complexity | **Low** | Medium | High |
| Time to Round 0 delivery | **Shortest** | Medium | Longest |
| Proof obligation count | ~5 core | ~12 core + overlay | ~15+ |
| Incremental recalc | No (full rebuild only) | **Yes (from day one)** | **Yes (native)** |
| Dynamic dependency support | Deferred | **First-class** | **First-class** |
| Spill correctness | Conservative (safe, slow) | **Algebraic (correct, efficient)** | **Algebraic** |
| Concurrency scaling | None | **Good (partition-parallel)** | **Best (fully concurrent)** |
| Stream/RTD support | Minimal (full-invalidate) | Good (selective) | **Native** |
| Visibility-first scheduling | No | Optional | **Natural** |
| Retrofit cost | **High** (under-engineering debt) | **Low** (designed for evolution) | N/A |
| Risk of over-engineering | **None** | Low | **High** |
| Migration from current state | **Direct** | Moderate | Major rewrite |
| Clean-room discipline | **Easiest** | Moderate | Hardest |
| Conformance pack coverage | Round 0 only | Rounds 0–1 | Aspirational |

---

## 3. Recommended Target Architecture

**Recommendation: Option B (Incremental-Ready) as target architecture, with Phase 1 delivered at Option A semantics.**

### Rationale

1. **Option A is not a terminal state**. DNA Calc requires dynamic arrays, INDIRECT/OFFSET, and eventually streaming data. Full-rebuild-only cannot scale, and retrofitting incremental invalidation into a system not designed for it introduces higher total cost than building correctly from the start.

2. **Option C is premature**. The transfer matrix correctly classifies differential/timely as "Advanced/Future" (Round 2+ evaluate). The complexity is not justified by current scope, team size, or proof infrastructure.

3. **Option B delivers both correctness and evolution trajectory**. The dual-layer dependency model, explicit overlay lifecycle, and partition-parallel evaluation directly address all Critical and High findings (F-001 through F-008). The SAC-inspired state machine has strong theoretical grounding and proven applicability to spreadsheet recalc.

4. **Phase 1 gate uses Option A semantics**. The first delivery milestone (DnaVisiCalc Round 0) uses full-rebuild recalc with the Option B structural model and overlay infrastructure in place but incremental paths disabled behind profile gates. This gives a correct, testable baseline while incremental paths are proven.

### Architecture Diagram

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
│  ┌─────────────┐ ┌──────────────┐ ┌───────────┐ ┌──────┐ ┌─────┐ │
│  │ DocSnapshot  │ │ DepOverlay   │ │SpillOvl   │ │FmtOvl│ │VisOvl│ │
│  │ (immutable)  │ │(struct+calc) │ │           │ │      │ │     │ │
│  └─────────────┘ └──────────────┘ └───────────┘ └──────┘ └─────┘ │
├─────────────────────────────────────────────────────────────────────┤
│                     Evaluation Layer                                │
│  ┌─────────────────────┐  ┌──────────────────────────────────────┐ │
│  │  FEC (Host-side)    │  │  F3E (Evaluator-side)                │ │
│  │  prepare / install  │  │  execute → EvalTransaction           │ │
│  │  open_session       │  │  CapabilityView w/ observation hooks │ │
│  │  capability_view    │  │    on_cell_read → runtime dep        │ │
│  │  commit             │  │    on_format_read → format dep       │ │
│  │                     │  │    on_name_resolve → name dep        │ │
│  │                     │  │  produce value + dep/spill/fmt deltas│ │
│  └─────────────────────┘  └──────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────┤
│                    Structural Model Layer                            │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Green-Tree Kernel (immutable, structurally shared)          │   │
│  │  NodeId identity │ Reference model │ Rewrite engine          │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

### Key Architectural Invariants

**INV-001**: Every `DocSnapshot` is immutable once created. Mutations produce a new snapshot at a new epoch.

**INV-002**: The structural dependency graph `G_s` is a pure function of the snapshot content. Given identical snapshot content, `G_s` is identical.

**INV-003**: Calc-time overlays (`DepOverlay`, `SpillOverlay`, `FormatOverlay`) are epoch-versioned. Each overlay instance is bound to the epoch in which it was created and may only be read by sessions bound to the same or a compatible epoch.

**INV-004**: The `Coordinator` is the sole authority for epoch advancement, session lifecycle, and overlay publication. No evaluation session may directly mutate shared state.

**INV-005**: Every `commit` call is total — it either applies all deltas atomically or rejects with a deterministic `CommitRejectDetail`. There is no partial commit.

**INV-006**: The recalc strategy (full-rebuild vs. incremental) is a policy decision owned by the `Scheduler`. It does not alter the observable semantic outcome (DAG-PO-001).

**INV-007** *(proposed resolution of OQ-1)*: Publication ordering within a committed epoch: value deltas → dependency deltas → spill deltas → format deltas → visibility update. Each phase completes before the next begins. *This is a design proposal requiring validation via multi-overlay scenario testing.*

**INV-008**: Under any scheduling policy (Deterministic, VisibleFirst, PartitionParallel), the final committed values for a given epoch are identical (DAG-PO-002, DAG-PO-010). Policy affects order of intermediate visibility, not semantic result.

---

## 4. Normative Contract Draft

### 4.1 Key Types

```
// ─── Identity ───

type NodeId       = { sheet: SheetId, row: RowIdx, col: ColIdx }
type FormulaId    = StableId<Formula>       // content-addressed or registry-assigned
type NameId       = StableId<DefinedName>
type RangeId      = StableId<Range>         // for named ranges / spill anchors
type EpochId      = u64                     // monotonically increasing
type SessionId    = Opaque<u64>
type FormulaToken = u64                     // version tag per formula registration

// ─── Graph entity discriminator ───
// NodeId and NameId are distinct types. Dependency edges use the union:
type DepTarget    = NodeId | NameId
// This avoids overloading NodeId for non-cell entities.
```

### 4.2 Core Interfaces

```
interface DocSnapshot {
    epoch:      EpochId
    cell(id: NodeId)  -> CellContent
    name(id: NameId)  -> NameDefinition
    bounds()          -> SheetBounds
    // Structural dependency extraction (pure function of content)
    structural_deps(id: NodeId) -> Set<DepTarget>
}

interface DepOverlay {
    epoch:      EpochId
    // Structural (parse-time) edges
    structural_predecessors(id: NodeId) -> Set<DepTarget>
    structural_successors(id: NodeId)   -> Set<DepTarget>
    // Runtime-observed (calc-time) edges
    runtime_predecessors(id: NodeId)    -> Set<DepTarget>
    runtime_successors(id: NodeId)      -> Set<DepTarget>
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

interface VisibilityOverlay {
    visible_regions() -> Set<CellRegion>
    update(regions: Set<CellRegion>) -> ()
    // Does not affect epoch or overlay validity — scheduler input only
}
```

### 4.3 FEC/F3E Extended Contracts

```
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
        -> Result<ObservingCapabilityView, CapabilityError>

    commit(txn: EvalTransaction)
        -> CommitResult

    abandon_session(session: SessionId) -> ()
}

// ─── Observation-enabled CapabilityView ───
// Extension of CapabilityView per Redesign Observations §Takeaway 2

interface ObservingCapabilityView extends FecCapabilityView {
    // Observation hooks — called by evaluator during execution
    on_cell_read(id: NodeId)                        // captures runtime dependency
    on_format_read(id: NodeId, prop: FormatProperty) // captures format dependency
    on_name_resolve(id: NameId)                      // captures dynamic name dep

    // Collected observations feed into EvalTransaction
    observed_cell_deps()   -> Set<NodeId>
    observed_name_deps()   -> Set<NameId>
    observed_format_deps() -> Set<FormatToken>
}

interface F3eEvaluator {
    execute(request: EvalRequest) -> EvalTransaction
}
```

### 4.4 CommitResult / Reject Taxonomy

```
enum CommitResult {
    Applied {
        applied_epoch:  EpochId,            // resolves F-005c
        value_delta:    ValueDelta,
        shape_delta:    Option<SpillDelta>,
        topology_delta: Option<TopologyDelta>,
        format_delta:   Option<FormatDelta>, // resolves F-005b
        dep_delta:      F3eDependencyDelta,  // resolves F-005a
    },
    Rejected {
        kind:   CommitRejectKind,
        detail: CommitRejectDetail,
    },
}

// NOTE: EpochAdvanced is an EXTENSION to the source spec's taxonomy.
// The source enum (Redesign Spec §2.4) does not include it.
// Added here to handle Open Item §4.2 (epoch advancement during eval).
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
    EpochAdvanced,              // EXTENSION: coordinator epoch > session epoch
    SessionExpired,             // EXTENSION: session timed out or abandoned
}

struct CommitRejectDetail {
    expected_token:    Option<FormulaToken>,
    actual_token:      Option<FormulaToken>,
    expected_epoch:    Option<EpochId>,
    actual_epoch:      Option<EpochId>,
    coordinator_epoch: Option<EpochId>,
    denied_capability: Option<FecCapabilityTag>,
    reject_code:       u32,     // machine-readable for replay harnesses
}
```

**Contract invariant**: `CommitRejectKind` is a closed enum. New reject reasons require a spec version bump. Every reject must populate `reject_code` for deterministic replay classification. The two EXTENSION entries above constitute the first spec version bump relative to the Redesign Spec baseline.

### 4.5 Delta Types

```
struct ValueDelta {
    node:          NodeId,
    prior_value:   Option<CellValue>,
    new_value:     CellValue,
    value_changed: bool,        // for early-cutoff decisions
}

struct F3eDependencyDelta {
    cells_added:              Set<NodeId>,
    cells_removed:            Set<NodeId>,
    names_added:              Set<NameId>,
    names_removed:            Set<NameId>,
    spill_children_added:     Set<NodeId>,
    spill_children_removed:   Set<NodeId>,
    topology_impact:          TopologyImpact,
}

enum TopologyImpact {
    None,
    DependencySetChanged,
    SpillRangeChanged,
    SpillBlocked,
}

struct SpillDelta {
    anchor:         NodeId,
    event:          SpillDeltaEvent,
    prior_region:   Option<CellRegion>,
    current_region: Option<CellRegion>,
    entered_cells:  Set<NodeId>,
    exited_cells:   Set<NodeId>,
}

enum SpillDeltaEvent {
    None,
    SpillTakeover,
    SpillClearance,
    SpillBlocked,
}

struct FormatDelta {
    node:            NodeId,
    tokens_added:    Set<FormatToken>,
    tokens_removed:  Set<FormatToken>,
}
```

### 4.6 Scheduler

```
interface Scheduler {
    next_batch(dep_overlay: &DepOverlay, spill_overlay: &SpillOverlay,
               policy: SchedulePolicy)
        -> Vec<NodeId>

    is_stabilized(dep_overlay: &DepOverlay) -> bool
}

enum SchedulePolicy {
    Deterministic,                           // strict topo order
    PartitionParallel { partition_count: u32 },
    VisibleFirst { visible_regions: Set<CellRegion>,
                   max_deferred_waves: u32 },
}
```

### 4.7 Epoch / Token Rules

| Rule | Statement |
|---|---|
| **EPOCH-001** | `EpochId` is monotonically increasing. The coordinator is the sole source of epoch advancement (CONSTR-010). |
| **EPOCH-002** | A `DocSnapshot` at epoch *e* is immutable. All mutations produce epoch *e+1*. |
| **EPOCH-003** | `open_session` binds a session to `snapshot_epoch`. The session sees only state ≤ that epoch. |
| **EPOCH-004** | `commit` succeeds only if `session.snapshot_epoch == coordinator.committed_epoch`. Otherwise: `SnapshotConflict`. The `applied_epoch` in `CommitResult::Applied` confirms which epoch the commit applied to. |
| **EPOCH-005** | `committed_epoch` advances when all structural mutations for an edit batch are applied. `stabilized_epoch` advances when all formula evaluations for that epoch reach `Clean` state. |
| **EPOCH-006** | `FormulaToken` changes whenever `install_plan` is called for a `FormulaId`. A session holding a stale token is rejected with `ExpectedTokenMismatch`. |
| **EPOCH-007** | Between `committed_epoch` and `stabilized_epoch`, cells may be in `Stale` or `Necessary` state. The host must expose stale/pending status to UI (CONSTR-009). |
| **EPOCH-008** | Epoch advancement during in-flight evaluation: all open sessions for the prior epoch are marked `epoch_invalidated`. In-flight `execute` calls may complete but their `commit` is rejected with `EpochAdvanced`. The evaluator must discard results, re-open sessions at the new epoch, and re-evaluate. Values committed at the prior epoch before advancement are valid and retained; they may be marked `Stale` by the new epoch's dirty set if the structural mutation affects them. |

---

## 5. Recalc and Overlay Semantics

### 5.1 Structural Dependency Graph Rules

**STRUCT-DEP-001**: The structural dependency graph `G_s = (V, E_s)` is extracted from `DocSnapshot(e)` by static analysis of formula ASTs. `V` = all cells with formulas + all defined names with formula definitions. `E_s` = {(a, b) | formula at `a` contains a syntactic reference to `b`}.

**STRUCT-DEP-002**: `G_s` is a pure function of the snapshot (INV-002). Given identical snapshot content, `G_s` is identical. This is the foundation of deterministic replay (DAG-PO-002).

**STRUCT-DEP-003**: SCC decomposition of `G_s` partitions `V` into strongly connected components. Each SCC with |SCC| > 1 is a cycle region. Evaluation order: topological order of the SCC DAG, with intra-SCC policy governed by profile (Error | Iterative(max_iter, epsilon)). Intra-SCC evaluation order is deterministic (e.g., row-major by NodeId) per Formal Model §5.

**STRUCT-DEP-004**: Structural rewrites (insert/delete row/col, move) produce a new snapshot at a new epoch. For Phase 1, the entire `G_s` is recomputed from the new snapshot. For Phase 2+, incremental maintenance of `G_s` is permitted provided it produces an identical result (verified by DAG-CONF-007 parity check).

**STRUCT-DEP-005**: Name definitions participate in `G_s`. A name `N` defined as a formula creates edges from `N` to its syntactic references. A cell referencing `N` has edge (cell, `N`). Names use `NameId`, distinct from `NodeId`.

### 5.2 Calc-time Overlay Rules

**CALC-OVL-001**: The calc-time dependency overlay records runtime-observed edges `E_r` created during F3E evaluation when the evaluator resolves references via `ObservingCapabilityView` hooks. For non-dynamic formulas, `E_r` should equal `E_s`; for formulas with conditional branches (IF), `E_r` may be a strict subset of `E_s` (only the taken branch is observed); for dynamic formulas (INDIRECT, OFFSET), `E_r` may contain edges not in `E_s`.

**CALC-OVL-002**: Each `E_r` edge carries a dependency token: `DynDepToken = { source: NodeId, target: DepTarget, observation_epoch: EpochId, evaluator_seq: u64 }`. The token supports: (a) invalidation when the target changes, (b) deterministic replay, (c) soundness proofs (DAG-PO-006).

**CALC-OVL-003**: Overlay retention across epochs. `E_r` edges are retained until explicitly invalidated. Invalidation occurs when:
- The source formula is re-parsed (structural edit) → all `E_r` edges from that source are dropped.
- A committed `F3eDependencyDelta` for that source reports `cells_removed` or `names_removed` → specific edges are dropped.
- Overlay GC: an edge is eligible for collection when (a) the source has been evaluated at an epoch later than the edge's `observation_epoch`, (b) the edge was not re-observed, and (c) no open session references `observation_epoch ≤ edge.observation_epoch` (CALC-OVL-005).

**CALC-OVL-004**: Invalidation set for incremental recalc: `dirty(e) = { n ∈ V | n was edited } ∪ { n ∈ V | ∃ (m, n) ∈ (E_s ∪ E_r) and m ∈ dirty(e) }`. The `Necessary` refinement: a `Stale` node becomes `Necessary` only if at least one predecessor has a changed value. Nodes that are `Stale` but not `Necessary` transition directly to `Clean` (early cutoff at the dirty-set level).

**CALC-OVL-005**: Overlay garbage collection. The coordinator maintains a `min_active_session_epoch` watermark. An `E_r` edge with `observation_epoch < min_active_session_epoch` that was not re-observed at a later epoch is eligible for collection. Collection must not occur while any session that could reference the edge is open.

**CALC-OVL-006**: **Pure-calc fast-path guard.** A formula evaluation may bypass overlay mutation tracking (producing no `F3eDependencyDelta`) if and only if ALL of the following hold:
1. The formula's structural dependencies (`E_s`) are identical to its prior runtime dependencies (`E_r`).
2. The formula does not invoke any function classified as `DynamicRef` or `FormatObservable`.
3. The formula is not a spill anchor.
4. The formula is not classified as `Volatile` (per Formal Model §3).

This is a closed predicate; any formula not meeting all four conditions must use full overlay tracking.

### 5.3 Spill Overlay Rules

**SPILL-OVL-001**: The spill overlay maps each spill anchor `a` to its current spill region `R(a) = { (r, c) | a spills into (r, c) }`. A cell `c ∈ R(a)` is a spill child of `a`.

**SPILL-OVL-002**: Spill invalidation algebra. On commit of `SpillDelta` for anchor `a`:
```
let prior    = delta.prior_region     // may be empty
let current  = delta.current_region   // may be empty
let exited   = prior \ current        // cells no longer in spill region
let entered  = current \ prior        // cells newly in spill region

invalidation_set =
    exited                            // exited cells revert to own content
  ∪ entered                           // entered cells now display spill values
  ∪ { n | ∃ (n, c) ∈ (E_s ∪ E_r), c ∈ (exited ∪ entered) }
                                       // dependents of changed cells
  ∪ blocked_recovery_set(a)           // if prior was Blocked, dependents of
                                       // unblocked anchor
```

**SPILL-OVL-003**: Spill conflicts. If `entered` intersects with a non-empty cell or another anchor's spill region, the anchor enters `SpillBlocked` state. In `SpillBlocked`: the anchor's value is `#SPILL!`, the prior region is cleared, and all prior spill children revert. The blocking cell set is recorded for future unblock detection.

**SPILL-OVL-004**: Spill recovery. When a blocking cell becomes empty (edit or spill clearance of the blocker), the coordinator re-evaluates the blocked anchor. If the new spill region is conflict-free, the anchor transitions from `SpillBlocked` to `SpillTakeover`.

**SPILL-OVL-005**: Spill anchors in cycles. For Round 0-1: a dynamic array formula (spill anchor) participating in a cycle (|SCC| > 1) is classified as an error condition. The anchor evaluates to `#SPILL!` with a diagnostic indicating cycle membership. This avoids the meta-instability where spill region changes alter cycle membership (per DAG Research Review §5 OQ-CYC-1). For Round 2+: evaluate joint shape+value iteration.

### 5.4 Format Overlay Rules

**FMT-OVL-001**: `FormatToken = { node: NodeId, property: FormatProperty, value_hash: u64 }`. Tracks formatting dependency per formula node. Tokens are created by `on_format_read` observation hooks in `ObservingCapabilityView`.

**FMT-OVL-002**: Format invalidation. When a cell's formatting changes, all formula nodes holding a `FormatToken` referencing that cell are marked `Stale`. This is profile-gated (DEC-CALC-007): when the gate is off, format changes do not trigger recalc.

### 5.5 Visibility Overlay Rules

**VIS-OVL-001**: The visibility overlay records which cell regions are currently visible to the user. Updated by host (scroll, tab switch, resize). Does not affect semantic correctness — only scheduling priority.

**VIS-OVL-002**: Under `SchedulePolicy::VisibleFirst`, the scheduler prioritizes `Necessary` nodes within visible regions. Starvation prevention: after `max_deferred_waves` scheduling waves, all non-visible `Necessary` nodes must be scheduled regardless of visible-region state (DEC-CALC-008). The value of `max_deferred_waves` is a coordinator configuration parameter; no default is specified here.

**VIS-OVL-003**: Visibility changes during in-flight recalc do not alter the epoch or invalidate any overlay. They only update the scheduler's priority input for future `next_batch` calls.

---

## 6. Concurrency Model

### 6.1 Coordinator Responsibilities

The `Coordinator` is the central serialization point for all state transitions. It is logically single-threaded but may be implemented as an async event loop with message passing.

| Responsibility | Description |
|---|---|
| **Epoch management** | Advances `committed_epoch` on structural mutation; advances `stabilized_epoch` when all nodes reach `Clean`. |
| **Session lifecycle** | Creates sessions bound to a snapshot epoch; tracks active sessions; rejects stale sessions on epoch advancement; detects and reclaims abandoned sessions (F-013). |
| **Overlay ownership** | Owns all overlay instances; applies deltas from committed evaluations; manages GC via session watermark (CALC-OVL-005). |
| **Commit serialization** | Processes `commit` calls sequentially; validates tokens/epochs; applies deltas atomically. |
| **Scheduler dispatch** | Invokes `Scheduler::next_batch`; dispatches evaluation requests to worker pool; collects results. |
| **Publication control** | Publishes deltas in INV-007 order; determines when to expose intermediate state to host (stale/pending) vs. final state (stabilized). |

### 6.2 Snapshot Fences

**FENCE-001**: A snapshot fence is established at each epoch boundary. All reads within an evaluation session see exactly the state at the session's `snapshot_epoch`. No write from a concurrent session or structural edit is visible until the session commits and a new session is opened at a later epoch.

**FENCE-002**: `DocSnapshot` is an immutable persistent data structure (structural sharing). Creating a new epoch clones the snapshot with copy-on-write. Evaluation sessions hold a reference to the snapshot at their epoch — no locks required for reads.

**FENCE-003**: Overlay reads during evaluation use the overlay state as of the session's `snapshot_epoch`. Concurrent overlay mutations (from other committed sessions at the same epoch) are visible only after the current session commits and re-opens.

**FENCE-004**: Cross-epoch consistency. If a structural mutation advances the epoch during an in-flight evaluation batch:
1. Mark all open sessions as `epoch_invalidated`.
2. Allow in-flight `execute` calls to complete (they may produce stale results).
3. Reject `commit` calls from invalidated sessions with `EpochAdvanced`.
4. Values committed at the prior epoch before advancement are retained; they enter the new epoch's dirty set if the structural mutation affects them.
5. Re-open sessions against the new epoch and re-schedule affected nodes.

### 6.3 Contention / Retry Behavior

**CONT-001**: Two evaluation sessions for different formulas at the same epoch do not contend — they read the same immutable snapshot and produce independent deltas.

**CONT-002**: Two sessions for the same formula at the same epoch are serialized by the coordinator. The second `open_session` call blocks until the first session commits or is abandoned. Timeout is a coordinator configuration parameter (not specified here — to be determined by benchmarking per OQ-006). On timeout: the blocked session receives `SessionOpenError::Contention`.

**CONT-003**: After `SnapshotConflict` or `EpochAdvanced` rejection, the evaluator must:
1. Discard the rejected `EvalTransaction`.
2. Re-acquire the formula plan (which may have changed if the structural edit affected the formula).
3. Open a new session at the current `committed_epoch`.
4. Re-execute.
This is a mandatory retry protocol, not an optional optimization.

**CONT-004**: Session abandonment. If a session is not committed or explicitly abandoned within the coordinator's session timeout, the coordinator reclaims it. Reclamation: release capability view, release snapshot reference, update `min_active_session_epoch` watermark. The abandoned session's `SessionId` subsequently produces `SessionNotFound` on `commit`. (Resolves F-013.)

**CONT-005**: The coordinator tracks a `contention_count` per epoch for diagnostic purposes. If contention count exceeds a configurable threshold, the coordinator logs a diagnostic and optionally falls back to sequential evaluation for that epoch.

**CONT-006**: Deterministic contention replay. For conformance testing, a `ContendedReplayLog` captures all session open/commit/reject/abandon events with their timestamps, epoch, and formula IDs. Replaying this log with a deterministic scheduler must produce identical commit outcomes (DAG-PO-002).

### 6.4 Floating-Point Determinism Under Parallelism

**FP-DET-001**: For Round 0-1, parallel evaluation uses canonical reduction ordering equivalent to sequential evaluation semantics. Partitioned partial results are combined in a fixed, deterministic order. This guarantees bit-identity across partition counts (DAG-PO-010) at the cost of limiting parallelism benefit for associative aggregations.

**FP-DET-002**: For Round 2+, partition-aware reduction (stable partition boundaries + deterministic reduction tree) may be evaluated as an alternative, contingent on passing DAG-PO-010.

---

## 7. Adoption Roadmap

### Phase 1: Structural Foundation (Round 0 target — DnaVisiCalc)

**Goal**: Deliver the immutable structural model, full-rebuild recalc, and FEC/F3E Plan B b4 transaction lane with single-threaded coordinator.

| Item | Description | Gate |
|---|---|---|
| 1.1 | Green-tree kernel: immutable `DocSnapshot`, `NodeId`/`NameId` identity, structural sharing | `PACK.dag.baseline_recalc_core` |
| 1.2 | Structural dependency extraction: `G_s`, SCC decomposition (Tarjan) | `PACK.dag.cycle_iterative_semantics` |
| 1.3 | Full-rebuild recalc: deterministic topological evaluation; cycle handling (Error + Iterative modes) | `PACK.dag.baseline_recalc_core` |
| 1.4 | FEC/F3E Plan B adoption: all source-spec reject taxonomy; single-threaded coordinator | FEC/F3E scenario suite |
| 1.5 | Conservative spill: full-recalc on any spill shape change; SpillBlocked/Takeover/Clearance events; spill-in-cycle = error (SPILL-OVL-005) | Spill scenario subset |
| 1.6 | Change tracking + metadata formatting overlay (no calc-time format deps yet) | Existing conformance baseline |
| 1.7 | Conformance baseline: DAG-CONF-001, DAG-CONF-002, DAG-CONF-008 | Green team validation |

**Compatibility note**: Phase 1 exposes `engine.recalculate_full()` as the sole recalc strategy. `engine.recalculate_incremental()` falls back to full-rebuild with a diagnostic log entry. The Phase 1 internal API is designed to accept overlay infrastructure (Phase 2) without breaking changes.

### Phase 2: Incremental Engine (Round 0+ / early Round 1)

**Goal**: Enable incremental recalc with dual-layer dependencies, algebraic spill invalidation, and partition-parallel evaluation.

| Item | Description | Gate |
|---|---|---|
| 2.1 | CapabilityView observation hooks: `on_cell_read`, `on_format_read`, `on_name_resolve` | Observation correctness tests |
| 2.2 | `CommitResult` extension: `dep_delta`, `format_delta`, `applied_epoch`, `EpochAdvanced`/`SessionExpired` reject kinds | Contract compatibility tests |
| 2.3 | Calc-time overlay infrastructure: `DepOverlay`, `SpillOverlay` with epoch versioning and GC (CALC-OVL-001..005) | `PACK.dag.dynamic_dependency_bind_semantics` |
| 2.4 | Dirty/stale/necessary state machine + early cutoff (per-type equality from Formal Model §3) | `PACK.dag.early_cutoff.signature` |
| 2.5 | Incremental invalidation: CALC-OVL-004 transitive closure; runtime dependency delta integration | PO-001 (from-scratch equivalence vs. Phase 1 baseline) |
| 2.6 | Algebraic spill invalidation (SPILL-OVL-002); replace conservative full-recalc | `PACK.spill.algebraic` |
| 2.7 | Multi-session coordinator + contention protocol (CONT-001..006) + session abandonment (CONT-004) | `PACK.concurrent.epochs` |
| 2.8 | Partition-parallel evaluation with canonical reduction (FP-DET-001) | `PACK.dag.parallel_determinism_signature` |
| 2.9 | Pure-calc fast path (CALC-OVL-006) | `PACK.fast_path` |
| 2.10 | Incremental topo maintenance (with full-rebuild fallback + parity check) | `PACK.dag.dynamic_topo_vs_rebuild` |
| 2.11 | Overlay GC with session watermark | `PACK.overlay.gc` |

### Phase 3: Policy Extensions (Round 1 — DnaPreCalc)

| Item | Description | Gate |
|---|---|---|
| 3.1 | Format overlay: `FormatOverlay`, `FormatToken`, FMT-OVL-001/002 (profile-gated DEC-CALC-007) | Format conformance suite |
| 3.2 | Visibility-first scheduling: `SchedulePolicy::VisibleFirst` + starvation bound (VIS-OVL-002, DEC-CALC-008) | `PACK.visibility.policy` |
| 3.3 | External stream integration: topic-based invalidation; `ExternallyInvalidated` class | `PACK.stream.basic` |
| 3.4 | Profile-version invalidation: function catalog change triggers selective re-parse/re-bind | Profile evolution spec |
| 3.5 | Canonical replay schema: `EvalReplayRecord` for concurrent trace replay | `PACK.concurrent.epochs` extended |

### Phase 4: Advanced (Round 2+ — DnaSuperCalc)

| Item | Description | Gate |
|---|---|---|
| 4.1 | Differential evaluation prototype: SAC-to-differential bridge for streaming hot paths | Research gate; transfer matrix reassessment |
| 4.2 | Collaboration via OpLog replication: multi-user concurrent editing | Collaboration spec (not yet drafted) |
| 4.3 | Semiring provenance: algebraic trace reasoning for explainability | Research gate |
| 4.4 | Re-evaluate spill-in-cycle prohibition: joint shape+value iteration | OQ-CYC-1 resolution |

---

## 8. Open Questions and Decisive Experiments

### Open Questions

| ID | Question | Impact | Resolution path |
|---|---|---|---|
| OQ-001 | What is the canonical publication ordering when value, dependency, spill, and format overlays all change in one commit? | Observer correctness for UI and change tracking | INV-007 proposes value→dep→spill→format→visibility; validate with multi-overlay scenario test |
| OQ-002 | Which deterministic replay schema becomes canonical across concurrent evaluator traces? | Conformance testing and regression infrastructure | Design canonical `EvalReplayRecord` schema; test with contention replay pack |
| OQ-003 | How should degradation classes be encoded for dynamic-reference edge behavior? | Profile specification and interop | Propose enum-based degradation classification; validate with profile compatibility matrix |
| OQ-004 | Is the pure-calc fast-path guard (CALC-OVL-006) sound under all profile configurations? | Correctness of performance optimization | Formal proof obligation (extend PO-001 to cover fast-path bypass); test volatile edge cases |
| OQ-005 | What is the correct GC policy for calc-time overlay edges when sessions have heterogeneous lifetimes? | Memory behavior under long-running evaluations | Prototype GC with session watermark tracking (CALC-OVL-005); measure memory under stress |
| OQ-006 | Should the coordinator contention protocol use blocking with timeout or CAS-based retry? | Throughput under high concurrency | Benchmark both approaches with synthetic contention workload |
| OQ-007 | How does the spill invalidation algebra interact with iterative cycle evaluation? | Correctness of cycle-with-spill edge case | SPILL-OVL-005 prohibits for Round 0-1; construct validation test for Round 2+ joint iteration |
| OQ-008 | What is the impact of NaN-equality semantics on early-cutoff decisions? | DAG-PO-008 soundness | Formal model declares NaN ≠ NaN (bitwise); verify recalc amplification is acceptable |

### Decisive Experiments

| ID | Experiment | Expected outcome | Decision unlocked |
|---|---|---|---|
| EXP-001 | **Full-rebuild vs. incremental baseline**: Run conformance suite with both strategies; compare outputs bit-for-bit. | Bit-identical outputs; incremental ≥2x faster on edit-recalc cycles. | Validates PO-001; unlocks Phase 2 adoption. |
| EXP-002 | **Contention stress test**: 100 concurrent formula evaluations on overlapping dependency regions. | All commits succeed or reject deterministically; no deadlock or livelock. | Validates CONT-001..006; unlocks multi-session coordinator. |
| EXP-003 | **Spill algebra correctness**: 50-case spill scenario matrix (takeover, clearance, blocked, recovery, nested spill, spill-in-cycle error). | All cases produce correct values matching full-rebuild baseline. | Validates SPILL-OVL-001..005; unlocks algebraic spill invalidation. |
| EXP-004 | **Pure-calc fast-path validation**: Identify all qualifying formulas in conformance suite; evaluate with and without tracking; compare outputs. | Bit-identical; qualifying formulas ≥30% of total. | Validates CALC-OVL-006; unlocks fast-path optimization. |
| EXP-005 | **Partition-parallel determinism**: Run conformance suite with partition counts 1, 2, 4, 8; compare value signatures. | Bit-identical across all partition counts. | Validates PO-008 + FP-DET-001; unlocks parallel evaluation. |
| EXP-006 | **Visibility-first starvation bound**: Large sheet with visible region = 1% of cells; measure maximum latency for non-visible cell stabilization under continuous scrolling. | Non-visible cells stabilize within `max_deferred_waves` waves. | Validates VIS-OVL-002; unlocks visibility-first policy. |
| EXP-007 | **Dynamic dependency token lifecycle**: INDIRECT/OFFSET-heavy workload through 100 edit-recalc cycles; verify no stale tokens persist. | Zero stale tokens after each stabilization; overlay memory bounded. | Validates CALC-OVL-003/005; unlocks dynamic dependency tracking. |
| EXP-008 | **Overlay GC under session watermark**: Long-running evaluation (simulated 60s) with concurrent short evaluations; measure overlay memory growth. | Memory bounded by O(active_sessions × avg_overlay_size). | Resolves OQ-005; validates GC policy. |

---

## 9. Pack / Proof Checklist

### Proof Obligations

| ID | Obligation | Testable predicate | Phase | Status |
|---|---|---|---|---|
| **PO-001** | Acyclic from-scratch equivalence (DAG-PO-001) | `∀ acyclic snapshot: incremental_result == full_rebuild_result` | Phase 2 | Required |
| **PO-002** | Deterministic replay (DAG-PO-002) | `∀ op_stream: replay(ops) == original_run(ops)` values and errors | Phase 1 | Required |
| **PO-003** | SCC partition correctness (DAG-PO-003) | `scc_decompose(G_s) == reference_tarjan(G_s)` for all test graphs | Phase 1 | Required |
| **PO-004** | Bounded iterative determinism (DAG-PO-004) | `∀ cyclic snapshot with (max_iter, eps): result is deterministic` | Phase 1 | Required |
| **PO-005** | Dynamic dependency soundness (DAG-PO-006) | `deps_unchanged(n, e1, e2) ∧ ¬volatile(n) ⟹ value(n, e1) == value(n, e2)` | Phase 2 | Required |
| **PO-006** | Dynamic from-scratch consistency (DAG-PO-007) | `incremental_dynamic == full_rebuild` for all dynamic functions | Phase 2 | Required |
| **PO-007** | Early-cutoff safety (DAG-PO-008) | `cutoff(n) ⟹ ∀ successors m: value_with_cutoff(m) == value_without_cutoff(m)` | Phase 2 | Required |
| **PO-008** | Parallel schedule confluence (DAG-PO-010) | `∀ partition_count ∈ {1..8}: values_identical` | Phase 2 | Required |
| **PO-009** | Commit atomicity (INV-005) | `Applied ⟹ all deltas visible; Rejected ⟹ no delta visible` | Phase 1 | Required |
| **PO-010** | Epoch monotonicity (CONSTR-010) | `∀ t1 < t2: epoch(t1) ≤ epoch(t2)` and no epoch reuse | Phase 1 | Required |
| **PO-011** | Snapshot fence correctness (FENCE-001) | `∀ session at epoch e: reads(session) ⊆ state(e)` | Phase 1 | Required |
| **PO-012** | Spill invalidation completeness (SPILL-OVL-002) | `spill_invalidation_set ⊇ all_affected_cells` (no missed invalidation) | Phase 2 | Required |
| **PO-013** | Pure-calc fast-path soundness (CALC-OVL-006) | `fast_path_result(n) == full_tracking_result(n)` when guard is true | Phase 2 | Required |
| **PO-014** | Visibility-policy equivalence (INV-008) | `∀ policy ∈ {Deterministic, VisibleFirst}: final_values_identical` | Phase 3 | Required |
| **PO-015** | Overlay GC safety (CALC-OVL-005) | No overlay edge collected while referenced by an active session | Phase 2 | Required |
| **PO-016** | Spill-in-cycle error classification (SPILL-OVL-005) | Spill anchor in SCC with |SCC|>1 produces `#SPILL!` error, not divergence | Phase 1 | Required |

### Empirical Packs

| Pack ID | Name | Phase | Pass criterion |
|---|---|---|---|
| `PACK.dag.baseline_recalc_core` | Baseline recalc validation | Phase 1 | PO-002, PO-003 pass; topo order consistent; replay bit-identical |
| `PACK.dag.cycle_iterative_semantics` | Cycle handling | Phase 1 | PO-004 pass; max_iter honored; epsilon convergence verified; SCC matches Tarjan reference |
| `PACK.dag.dynamic_dependency_bind_semantics` | Dynamic dependency tracking | Phase 2 | PO-005, PO-006 pass; zero stale tokens after stabilization |
| `PACK.dag.early_cutoff.signature` | Early cutoff behavior | Phase 2 | PO-007 pass; cutoff ratio ≥ 20% on typical workloads |
| `PACK.dag.dynamic_topo_vs_rebuild` | Dynamic topo maintenance | Phase 2 | Bit-identical results; incremental ≥ 1.5x faster; DAG-CONF-007 parity checks pass |
| `PACK.dag.parallel_determinism_signature` | Parallel determinism | Phase 2 | PO-008 pass; bit-identical across partition counts 1–8 |
| `PACK.concurrent.epochs` | Concurrent epoch management | Phase 2 | PO-009, PO-010, PO-011 pass; no deadlock; CONT-006 replay matches |
| `PACK.spill.algebraic` | Algebraic spill invalidation | Phase 2 | PO-012 pass; all 50 scenarios match full-rebuild baseline; PO-016 pass (spill-in-cycle) |
| `PACK.fast_path` | Pure-calc fast path | Phase 2 | PO-013 pass; zero guard misclassification; volatile functions excluded |
| `PACK.overlay.gc` | Overlay garbage collection | Phase 2 | PO-015 pass; memory bounded per OQ-005 criterion |
| `PACK.format.overlay` | Formatting overlay | Phase 3 | FMT-OVL-001/002 scenarios pass; profile gate on/off tested |
| `PACK.visibility.policy` | Visibility-first scheduling | Phase 3 | PO-014 pass; starvation bound ≤ max_deferred_waves |
| `PACK.stream.basic` | External stream ordering | Phase 3 | DAG-PO-009 pass; replay deterministic |

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
| DAG-CONF-008 (iterative cycle mode declaration) | `PACK.dag.cycle_iterative_semantics` | Per-SCC result classification (FixedPoint / BoundedPragmatic / Error) |

---

*End of deliverable. All claims cite sources within the compact source pack. Terminology: F3E used throughout; where source material uses F3C, the mapping F3E→F3C applies per prompt §Source handling rules. Items marked EXTENSION relative to the source Redesign Spec are explicitly flagged.*
