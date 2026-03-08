# DNA Calc core DAG recalc and FEC/F3E seam architecture

**The central architectural challenge in DNA Calc is resolving the circular derivation that dynamic references and spill regions create in the layered model.** The formal layer chain S→R→D→V assumes references derive from structure alone, but INDIRECT/OFFSET make references depend on *values*, and spill regions make structure depend on *values*. Every other design decision — the FEC/F3E seam contract, the concurrency model, the incremental recalc strategy — flows downstream from how this circularity is broken. This report presents findings, three coherent design options, a recommended architecture, normative contracts, and a phased adoption plan grounded in current state-of-the-art incremental computation research and the existing b4 seam evidence.

---

## 1. Findings ordered by severity

### CRITICAL findings

**F-001. Dynamic references break the R-from-S derivation chain.** The formal model states R derives from S + bind context, but `INDIRECT("A"&B1)` creates a reference depending on B1's *value* (layer V). This creates a feedback loop R→D→V→R' that the five-layer model does not account for. Approximately 15–20% of real-world Excel workbooks use INDIRECT or OFFSET. Without a formal calc-time overlay sub-layer, the engine cannot correctly represent these dependencies, and the dirty/stale/necessary state vocabulary cannot be applied.

**F-002. FEC/F3E semantic ownership boundary is ambiguous.** The spec states "FEC provides topology evidence; engine owns recalc policy," but `topology_delta` carries `impact_class` values (`DependencySetChanged | SpillRangeChanged | SpillBlocked`) that are *interpretations*, not raw facts. When FEC emits `SpillBlocked`, it has already decided that a spill attempt failed — a semantic judgment that the spec assigns to the engine. The current b4 seam conflates evidence and policy, creating risk of split-brain recalc behavior.

**F-003. Fixed-point convergence for iterative cycles lacks formal proof.** The spec permits iterative cycle resolution (profile-gated), but no convergence proof or well-foundedness argument exists. Empirical evidence (83 session cycles) covers only tested scenarios. Non-convergence means unbounded computation. Salsa's recent `cycle_fn`/`cycle_initial` mechanism with monotone partial-order convergence guarantees provides a concrete model to follow.

**F-004. Determinism proof obligation is unaddressed for parallel evaluation.** The engine requirements mandate deterministic, externally-driven execution. But no mechanism prevents floating-point non-associativity from producing different results under different thread schedules. The NVIDIA CCCL 3.1 Reproducible Floating-point Accumulator (RFA) approach and fixed-order reduction trees are necessary for any parallel path.

### HIGH findings

**F-005. Spill regions create a V→S feedback loop.** A `SORT()` formula spilling into 10 rows creates structural reality (occupied cells, blocking) from value computation. The immutable green core must be mutated by calc results. The 51 tested spill transition events confirm the events work, but the layer model has no formal mechanism for V→S feedback. The spill sub-layer lifecycle is the highest-impact unresolved design gap.

**F-006. Epoch model has torn-state risk during in-flight recalculation.** Three epochs are defined (committed, stabilized, value) with explicit stale/pending/ready/error visibility. But during multi-step recalc, if cell A1 has been recalculated but dependent A2 has not, an observer querying both sees an inconsistent snapshot. The "published-state during in-flight recalc" gap directly threatens the deterministic guarantee for concurrent observers.

**F-007. Green/Red façade lifecycle is unspecified relative to FEC sessions.** The Tree-Grid Hybrid Kernel defines immutable green core with ephemeral red facades, but the spec does not define when red facades are created or destroyed relative to calc sessions, or whether a red facade *is* the session-scoped working copy. FEC capability guards cannot be correctly implemented without this clarity.

**F-008. FEC session lacks dynamic reference capability escalation.** If INDIRECT resolves to a cell outside the session's initial capability set, the current contract provides no escalation path. The session must either pre-declare all possible dynamic targets (impossible for arbitrary INDIRECT) or support mid-execution capability extension. Neither is specified.

**F-009. Spill invalidation algebra is incomplete.** The spec defines SpillTakeover/SpillClearance/SpillBlocked events but not priority ordering for competing spill claims. If formulas A and B both attempt to spill into the same region, the evaluation order determines the winner — but evaluation order depends on topological sort, and the spill conflict itself may alter topology. A deterministic tie-breaking rule (e.g., top-left origin cell priority) is required.

### MEDIUM findings

**F-010. Volatile functions defeat incremental optimization entirely.** INDIRECT and OFFSET are treated as volatile in Excel, forcing re-evaluation every cycle. The dirty/stale/necessary model from SAC/Adapton literature relies on lazily checking whether re-evaluation is needed — volatility bypasses this completely. At scale, volatile fan-out dominates recalc cost. A graded volatility model (truly volatile vs. "dynamic but cacheable") would recover significant performance.

**F-011. Profile-version invalidation has no layer representation.** Profile changes affect function semantics but don't touch structure (layer S). The derivation chain has no dependency on profile_version, meaning a profile upgrade could silently leave the dependency graph stale. A meta-dependency on profile_version must be added to the invalidation model.

**F-012. Session timeout/cleanup semantics are unspecified.** A hung FEC session holds capability guards indefinitely, blocking epoch advancement. The b4 spec includes no timeout, TTL, or cleanup contract.

**F-013. Rejection taxonomy is incomplete.** Missing classes include: StructuralConflict (row/col insert during session), ProfileVersionMismatch, ResourceExhaustion, DynamicRefOutOfBounds, and CausalityViolation.

---

## 2. Three design options with trade-off matrix

### Option A: Conservative layered (sequential, full-fenced)

This option preserves the clean S→R→D→V→O derivation by treating all dynamic references and spill regions as volatile, forcing full recalculation whenever they are involved. The FEC session operates on a fully committed green snapshot; all results commit atomically at epoch boundaries.

**Structural model**: Immutable green tree (RRB-tree of rows + HAMT cells). Red facades created per-session for coordinate projection. Structural ops produce new green roots via path-copying (**O(log n)** per insert/delete).

**Recalc strategy**: Full recalc on any spill-region change. Incremental recalc only for pure-cell edits with no dynamic references in the dirty subgraph. Early cutoff via value-equality check at each node (unlike Excel, which does not implement cutoff).

**FEC seam**: Sessions bind to `committed_epoch`. Execute sees frozen snapshot. Commit is all-or-nothing against `committed_epoch`; any concurrent structural edit forces reject and retry. SpillPolicy = `ConservativeFullRecalc` always.

**Concurrency**: Single-threaded evaluation. Observers see only committed epochs (atomic swap). No torn-state risk.

**Strengths**: Trivially correct. Easy to prove determinism (DAG-PO-002) and from-scratch equivalence (DAG-PO-001). Aligns with existing 50 full-recalc + 30 incremental-recalc evidence base.

**Weaknesses**: O(n) recalc on any spill/dynamic-ref change. No parallelism. Latency proportional to grid size. Cannot scale beyond VisiCalc bounds.

### Option B: Overlay-aware incremental (hybrid fenced, selective parallelism)

This option introduces an explicit **calc-time overlay layer** between D and V that captures dynamic references and tentative spill claims. The overlay is session-scoped, committed or discarded atomically. Incremental recalc uses Salsa-style verification with early cutoff.

**Structural model**: Same green/red tree as Option A, plus an **overlay store** keyed by `(session_id, epoch)`. The overlay records: dynamic reference resolutions (R_dynamic), tentative spill claims (S'_spill), and late-bound dependency edges (D_dynamic). The committed derivation chain becomes `S → R_static → D_static → [Overlay(R_dynamic, D_dynamic, S'_spill)] → V → commit → S_{n+1}`.

**Recalc strategy**: Two-phase incremental. Phase 1 (structural): rebuild D_static from R_static for any structurally-changed formulas. Phase 2 (eval): evaluate dirty subgraph in topological order with Salsa-style early cutoff — if a node's output matches its previous value, backdate its `changed_at` revision and skip dependents. Dynamic references are evaluated in phase 2 and recorded in the overlay; if the dynamic dependency set changes, the overlay's D_dynamic triggers re-evaluation of affected dependents. Spill claims are tentative during phase 2 and committed atomically. Spill conflicts trigger **selective fallback** (re-evaluate only the conflicting spill chain, not full recalc).

**FEC seam**: Sessions bind to `committed_epoch` with an attached overlay workspace. `capability_view` is extended with a `DynamicCapabilityExtension` protocol: if INDIRECT resolves to an uncovered cell, the session requests extension from the coordinator, which validates against the epoch fence. `topology_delta` is split into `topology_facts` (raw dependency set, spill range coordinates) and `topology_interpretation` (impact class), with the engine owning interpretation.

**Concurrency**: Level-parallel evaluation within topological waves. Nodes at the same dependency height are dispatched to a thread pool. Determinism via fixed-order reduction trees for aggregate functions (SUM, AVERAGE). Within a wave, all reads target the pinned epoch snapshot; writes go to the overlay. Wave barriers synchronize overlay state. **Epoch-based reclamation** (DEBRA+ style) for GC of superseded overlay/green-tree versions.

**Strengths**: Incremental with early cutoff recovers performance. Overlay isolates dynamic complexity. Parallel evaluation exploits independent subgraphs. Selective spill fallback avoids full recalc in most cases.

**Weaknesses**: Overlay lifecycle adds complexity. Dynamic capability extension requires coordinator round-trip during evaluation. Two-phase commit with overlay adds latency. Proof obligations for overlay correctness (from-scratch consistency of overlaid D_dynamic) are non-trivial.

### Option C: Fully reactive differential (stream-oriented, MVCC-first)

This option treats the entire calculation engine as a **differential dataflow** system inspired by DBSP (VLDB 2023 Best Paper). Every cell value, dependency edge, and spill region is a stream of versioned deltas. Recalculation is continuous maintenance of materialized views over these streams. Dynamic references and spill regions are naturally handled as data-dependent stream topology changes.

**Structural model**: Persistent columnar chunk store with MVCC. Each cell version is `(cell_id, epoch, value)`. Structural operations produce new chunk versions. The dependency graph is itself a materialized view maintained incrementally via delta propagation.

**Recalc strategy**: No distinction between "full" and "incremental" — all recalc is stream maintenance. Input deltas (cell edits) propagate through the dependency graph as output deltas. **Nested time domains** (DBSP's mechanism for recursive queries) handle iterative cycles with formal fixed-point guarantees. Dynamic references are modeled as data-dependent stream routing: when INDIRECT's argument changes, the routing changes, which produces dependency-graph deltas. Spill regions are stream outputs whose size determines downstream routing.

**FEC seam**: Replaced by a **stream operator interface**. Each formula is a stateful stream operator that consumes input deltas and produces output deltas. The prepare/session/execute/commit lifecycle becomes subscribe/process/emit/checkpoint. Spill events are delta emissions on a dedicated spill stream.

**Concurrency**: Full MVCC with epoch-tagged versions. Multiple concurrent readers at different epochs. Writers produce new versions without blocking readers. Parallel evaluation follows the dataflow graph's natural parallelism. Determinism via DBSP's algebraic guarantees (commutativity + associativity of delta operators on Z-sets).

**Strengths**: Mathematically principled (DBSP's 4-operator algebra). Natural handling of dynamic dependencies and spills as stream topology changes. Formal fixed-point for cycles. Inherent parallelism. Incremental by construction — no separate "full recalc" path.

**Weaknesses**: Radical departure from the existing b4 seam (83 tested session cycles would need reimplementation). DBSP is proven for SQL/Datalog but not yet demonstrated for spreadsheet-specific semantics (INDIRECT, OFFSET, LAMBDA). The stream operator model requires rethinking the entire FEC/F3E contract. Highest risk and longest timeline.

### Trade-off matrix

| Criterion | Option A (Conservative) | Option B (Overlay Incremental) | Option C (Differential) |
|---|---|---|---|
| **Correctness confidence** | ★★★★★ trivially correct | ★★★★☆ overlay proofs needed | ★★★☆☆ new formalism |
| **Incremental performance** | ★★☆☆☆ full recalc on dynamic | ★★★★☆ early cutoff + selective | ★★★★★ incremental by construction |
| **Parallel scalability** | ★☆☆☆☆ sequential only | ★★★☆☆ level-parallel | ★★★★★ dataflow-parallel |
| **Dynamic reference handling** | ★★☆☆☆ volatile fallback | ★★★★☆ overlay + extension | ★★★★★ stream routing |
| **Spill algebra** | ★★☆☆☆ full recalc on spill | ★★★★☆ selective fallback | ★★★★★ delta propagation |
| **Migration cost from b4** | ★★★★★ minimal change | ★★★☆☆ overlay + extension added | ★☆☆☆☆ full rewrite |
| **Proof obligation coverage** | ★★★★★ simple proofs | ★★★☆☆ overlay soundness | ★★★★☆ DBSP proofs exist |
| **VisiCalc-scope fit** | ★★★★★ perfect for 16K cells | ★★★★☆ slight overengineering | ★★☆☆☆ overkill |
| **Foundation-ready scaling** | ★★☆☆☆ will not scale | ★★★★☆ designed for scale | ★★★★★ built for scale |
| **Team skill alignment** | ★★★★★ Rust + existing code | ★★★★☆ incremental concepts | ★★☆☆☆ requires DBSP expertise |

---

## 3. Recommended target architecture

**Recommendation: Option B (Overlay-Aware Incremental) as the primary path, with Option A as the VisiCalc-round implementation and Option C design principles as strategic guidance for Round 2+.**

The rationale is threefold. First, Option B resolves all four CRITICAL findings while preserving compatibility with the existing b4 seam evidence. Second, it provides a clean migration path: VisiCalc ships with the Option A subset (sequential, conservative spill fallback) while the overlay and parallelism mechanisms are developed behind feature gates. Third, it explicitly separates policy from mechanism at every boundary, enabling progressive hardening.

### Structural model

The recommended structural representation is a **two-level persistent tree**: an RRB-tree of row-groups at the top level, with HAMT-based sparse cell storage within each row-group. This provides **O(log n)** row insert/delete via RRB split/concat, **O(1)** amortized cell access via HAMT lookup, and **O(1)** snapshot creation via root sharing. The green/red façade pattern from Roslyn applies directly: the immutable RRB+HAMT structure is the green tree (position-independent, stores widths/counts), and ephemeral red wrappers provide absolute row/column indices for formula evaluation.

Every `NodeId` must include `SheetId` from day one — `NodeId = Cell(SheetId, CellId) | Name(SheetId, NameId) | Chart(SheetId, ChartId)` — even though VisiCalc is single-sheet, to prevent a painful refactor at Round 1.

### Amended layer model

The five-layer model is amended to six layers with an explicit overlay:

```
Layer S  (Structure)        — immutable green tree, structural identity
Layer R  (Static References) — derived from S + bind context at parse/bind time
Layer D  (Static Dependencies) — derived from R_static
Layer Ω  (Calc-Time Overlay) — session-scoped, captures R_dynamic + D_dynamic + S'_spill
Layer V  (Values/Iteration)  — evaluated against D_static ∪ D_dynamic
Layer O  (Operations)        — exclusive persistent mutation pathway

Derivation: R_static = bind(S, profile)
            D_static = deps(R_static)
            Ω        = overlay(V, session)        // feedback loop, session-scoped
            V        = eval(D_static ∪ Ω.D_dynamic, snapshot)
            S_{n+1}  = commit(S_n, Ω.S'_spill, O)  // spill claims promoted at commit
```

Layer Ω is the key innovation. It is created when a FEC session opens and destroyed when the session commits or is rejected. During evaluation, dynamic reference resolutions and tentative spill claims accumulate in Ω. On commit, Ω's spill claims promote to the next epoch's S, and Ω's dynamic dependencies merge into the persistent D for the next cycle. On reject, Ω is discarded with no side effects.

### Dependency graph and recalc engine

The dependency graph uses the **dirty/stale/necessary** state vocabulary from the DAG research synthesis. Each node carries a `RecalcState`:

- **Clean**: value matches current epoch; no re-evaluation needed
- **Stale**: at least one upstream node has been marked dirty; needs verification
- **Necessary**: verified that at least one input actually changed; must re-evaluate
- **InProgress**: currently being evaluated (for cycle detection and parallelism)

The recalc algorithm is a **hybrid push-pull** inspired by Salsa's red-green verification:

1. **Push phase (dirty marking)**: When an input changes, walk forward edges to mark all transitive dependents as Stale. For volatile nodes, mark as Necessary directly.
2. **Pull phase (verification/evaluation)**: Process Stale nodes in topological order (min-heap by node height, à la Jane Street Incremental). For each Stale node, recursively verify its inputs. If all inputs are Clean or their values haven't changed (early cutoff via backdating), mark the node Clean without re-evaluating. If any input actually changed, mark Necessary and re-evaluate.
3. **Dynamic dependency handling**: During evaluation, if INDIRECT/OFFSET resolves to a new target, record the new dependency in Ω.D_dynamic. If the dynamic dependency set changed from the previous epoch, emit `TopologyFact::DependencySetChanged`. The coordinator may need to re-run the pull phase for nodes downstream of the new dependency.
4. **Spill handling**: After evaluating a spill-producing formula, compare the new spill envelope with the previous epoch's. If changed, record in Ω.S'_spill and check for blockage. If blocked, emit `SpillFact::Blocked` with the obstructing cell set. If unblocked, emit `SpillFact::Claimed` with the new range. Spill priority tie-breaking uses deterministic **cell-position order** (row-major, then column-major of origin cell).
5. **Cycle handling**: SCC decomposition via Tarjan's algorithm. Acyclic SCCs evaluate normally. Cyclic SCCs use profile-gated iterative mode: initialize all cycle members with a bottom value (0.0 for numeric, "" for text), evaluate in SCC-internal topological order, iterate until either all values converge (delta < ε) or the iteration bound is reached. Convergence requires monotone functions on a lattice with finite height (proof obligation DAG-PO-005).

**Early cutoff** is the single highest-leverage optimization not present in Excel's engine. The Build Systems à la Carte taxonomy classifies Excel as "restarting scheduler + dirty-bit rebuilder" — meaning it recalculates all dirty cells even if intermediate values haven't changed. By adding verifying-trace semantics (comparing output hashes before propagating dirtiness), the engine avoids **O(n)** cascading recalculation in the common case where an edit deep in the graph doesn't change a key intermediate value.

### Dynamic topological sort

The dependency graph's topological order is maintained incrementally using the **Pearce-Kelly algorithm**, which has optimal practical performance for the sparse graphs typical in spreadsheets. When a formula edit adds or removes dependency edges, Pearce-Kelly identifies the minimal set of nodes whose topological order must change and reorders only those nodes, in **O(|δ|²)** worst case where δ is the affected region. For bulk operations (paste, column insert), the **batch variant** achieves **O(v + e + b)** for b edge insertions.

---

## 4. Normative contract draft

### 4.1 Key types and interfaces

```
// === Identity ===
type SheetId    = StableId<Sheet>;
type CellId     = StableId<Cell>;
type NameId     = StableId<Name>;
type FormulaId  = StableId<Formula>;    // stable across structural rewrites
type RangeId    = StableId<Range>;       // spill-range identity
type Epoch      = u64;                   // monotonically increasing
type SessionId  = u64;                   // per-evaluation session
type SessionToken = Opaque<[u8; 16]>;    // unguessable session credential

// === Node identity ===
enum NodeId {
    Cell(SheetId, CellId),
    Name(SheetId, NameId),
    Chart(SheetId, ChartId),
}

// === Recalc state ===
enum RecalcState { Clean, Stale, Necessary, InProgress, Error(CalcError) }

// === Reference model ===
enum BoundRef {
    CellRef(SheetId, CellId),
    RegionRef(SheetId, CellId, CellId),  // top-left, bottom-right
    NameRef(SheetId, NameId),
    ExternalRef(ExternalRefId),
    SpillRef(SheetId, CellId),           // origin cell of spill range
    ErrorRef(RefError),
}

// === Dependency ===
struct DependencyEdge {
    from: NodeId,
    to: NodeId,
    kind: DependencyKind,  // Static | Dynamic | Spill
    epoch_created: Epoch,
}

enum DependencyKind { Static, Dynamic, Spill }

// === Overlay ===
struct CalcTimeOverlay {
    session_id: SessionId,
    base_epoch: Epoch,
    dynamic_refs: Vec<(NodeId, BoundRef)>,       // R_dynamic
    dynamic_deps: Vec<DependencyEdge>,            // D_dynamic
    spill_claims: Vec<SpillClaim>,                // S'_spill
    tentative_values: HashMap<NodeId, CellValue>, // in-progress results
}

struct SpillClaim {
    origin: NodeId,
    range: RegionRef,
    values: Vec<CellValue>,
    blocked_by: Option<Vec<NodeId>>,
}
```

### 4.2 FEC/F3E seam contract

```
// === Session lifecycle ===
trait FecCoordinator {
    /// Phase 1: Prepare evaluation plan
    fn prepare(&self, trigger: RecalcTrigger) -> FecPlan;

    /// Phase 2: Install plan, allocating resources
    fn install_plan(&mut self, plan: FecPlan) -> Result<PlanToken, PlanReject>;

    /// Phase 3: Open evaluation session bound to an epoch
    fn open_session(&mut self, plan_token: PlanToken, epoch: Epoch)
        -> Result<(SessionId, SessionToken), SessionReject>;

    /// Phase 4: Query capabilities for a formula
    fn capability_view(&self, session: SessionId, formula: FormulaId)
        -> Result<FecCapabilityView, CapabilityReject>;

    /// Phase 4b: Extend capabilities mid-session (for dynamic refs)
    fn extend_capability(&mut self, session: SessionId, token: SessionToken,
                         additional: Vec<BoundRef>)
        -> Result<FecCapabilityView, CapabilityReject>;

    /// Phase 5: Execute formula evaluation
    fn execute(&mut self, session: SessionId, request: EvalRequest)
        -> Result<EvalResult, EvalError>;

    /// Phase 6: Commit session results
    fn commit(&mut self, session: SessionId, token: SessionToken)
        -> CommitResult;

    /// Abort session without committing (cleanup)
    fn abort(&mut self, session: SessionId, token: SessionToken);
}
```

### 4.3 Commit result and reject taxonomy

```
enum CommitStatus { Applied(CommitPayload), Rejected(CommitRejectDetail) }

struct CommitPayload {
    value_delta: FecValueDelta,         // cell values changed
    shape_delta: FecShapeDelta,         // spill regions changed
    topology_delta: FecTopologyDelta,   // dependency graph changed
    new_epoch: Epoch,                   // epoch after commit
}

struct FecTopologyDelta {
    facts: Vec<TopologyFact>,           // RAW EVIDENCE only
    // Engine interprets facts into recalc policy decisions
}

enum TopologyFact {
    DependencySetChanged { node: NodeId, added: Vec<NodeId>, removed: Vec<NodeId> },
    SpillRangeClaimed { origin: NodeId, range: RegionRef },
    SpillRangeCleared { origin: NodeId, previous_range: RegionRef },
    SpillBlocked { origin: NodeId, intended_range: RegionRef, blockers: Vec<NodeId> },
    DynamicRefResolved { formula: FormulaId, target: BoundRef, epoch: Epoch },
}

enum CommitRejectDetail {
    // Session lifecycle rejects
    SessionNotFound,
    SessionExpired { ttl_exceeded_at: Instant },        // NEW
    TokenMismatch,

    // Capability rejects
    CapabilityNotBound,
    CapabilityDecisionMismatch,
    CapabilityDenied,

    // Snapshot rejects
    SnapshotConflict { session_epoch: Epoch, coordinator_epoch: Epoch },
    StructuralConflict { concurrent_op: OpId },          // NEW

    // Formula rejects
    FormulaNotRegistered,
    FormulaMismatch,

    // Semantic rejects
    ProfileVersionMismatch { expected: ProfileVersion, actual: ProfileVersion },  // NEW
    CycleDetected { scc: Vec<NodeId> },                  // NEW
    DynamicRefOutOfBounds { target: BoundRef },           // NEW

    // Resource rejects
    ResourceExhausted { kind: ResourceKind },             // NEW
}

enum ResourceKind { Memory, IterationBound, SessionLimit }
```

### 4.4 Epoch and token rules

**Epoch invariants:**

| Invariant | Rule |
|---|---|
| **EPOCH-INV-001** | `committed_epoch ≥ stabilized_epoch` always |
| **EPOCH-INV-002** | `value_epoch(cell) ≤ committed_epoch` for all committed cells |
| **EPOCH-INV-003** | A session binds to exactly one `base_epoch` at open time; this cannot change |
| **EPOCH-INV-004** | Commit succeeds only if `session.base_epoch == coordinator.committed_epoch` at commit time (snapshot fence) |
| **EPOCH-INV-005** | On successful commit, `committed_epoch` advances by exactly 1 |
| **EPOCH-INV-006** | No version with `epoch > committed_epoch` is visible to any observer |
| **EPOCH-INV-007** | GC may reclaim versions with `epoch < min(active_session_epochs ∪ {observer_epochs})` |

**Token rules:**

| Rule | Description |
|---|---|
| **TOKEN-001** | `SessionToken` is cryptographically random, issued at `open_session`, required for `commit` and `abort` |
| **TOKEN-002** | `PlanToken` is issued at `install_plan`, consumed by exactly one `open_session` |
| **TOKEN-003** | Tokens are single-use for commit/abort; replay of a consumed token returns `TokenMismatch` |
| **TOKEN-004** | Sessions not committed or aborted within `SESSION_TTL` (configurable, default 30s) are auto-aborted |

---

## 5. Recalc and overlay semantics

### 5.1 Structural dependency graph rules

The static dependency graph (Layer D) obeys these rules:

**D-RULE-001 (Construction):** For every formula `f` at node `n`, parse `f` to extract static references `R_static(f)`. For each `r` in `R_static(f)`, add edge `resolve(r) → n` to D. Range references `A1:A1000` add a single edge from a synthetic range node, not 1000 individual edges.

**D-RULE-002 (Structural rewrite):** When a structural operation (insert/delete row/col) applies, all references in D are rewritten via `mu_row`/`mu_col` producing Preserved/Shifted/Expanded/Contracted/Invalidated outcomes. Invalidated references produce `#REF!` error nodes. D is rebuilt for affected formulas only; unaffected portions are shared via structural sharing.

**D-RULE-003 (SCC invariant):** After every D modification, Tarjan's SCC decomposition is recomputed for the affected subgraph. The Pearce-Kelly dynamic topological sort maintains the acyclic quotient graph of SCCs.

**D-RULE-004 (No orphan nodes):** Every node in D either has at least one incoming edge (is depended upon) or is an input/volatile node. Nodes with no incoming and no outgoing edges are pruned from D.

### 5.2 Calc-time overlay rules

The overlay (Layer Ω) captures runtime-discovered information that cannot be known at parse/bind time:

**Ω-RULE-001 (Session scope):** An overlay exists only within the lifetime of a FEC session. It is created at `open_session` and destroyed at `commit` or `abort`.

**Ω-RULE-002 (Dynamic reference recording):** When formula evaluation resolves a dynamic reference (INDIRECT, OFFSET, INDEX), the resolved target is recorded in `Ω.dynamic_refs`. A corresponding `DependencyEdge` with `kind = Dynamic` is added to `Ω.dynamic_deps`.

**Ω-RULE-003 (Overlay isolation):** The overlay is visible only within its owning session. Other sessions and observers see only committed D_static. On commit, `Ω.dynamic_deps` merge into the next epoch's D with `kind = Dynamic` annotation.

**Ω-RULE-004 (Dynamic dependency diffing):** At commit, the engine compares `Ω.dynamic_deps` with the previous epoch's dynamic deps for the same formulas. If the dependency set changed, emit `TopologyFact::DependencySetChanged`. Unchanged dynamic deps are carried forward.

**Ω-RULE-005 (From-scratch consistency):** The overlay must satisfy DAG-PO-007: the result of incremental evaluation with the overlay must equal a from-scratch evaluation. The engine verifies this by checking that every dynamic dependency recorded in Ω was actually encountered during evaluation (no phantom deps) and that every dynamic reference encountered was recorded (no missing deps).

### 5.3 Spill, format, and visibility overlay interaction rules

**SPILL-RULE-001 (Tentative claim):** During evaluation, a spill-producing formula writes its output array to `Ω.spill_claims` with status `Tentative`. The claim specifies origin node, intended range, and values.

**SPILL-RULE-002 (Blockage detection):** Before a tentative claim is accepted, the coordinator checks the intended range against (a) committed structural occupancy in layer S, (b) other tentative claims in the same session with higher priority. Priority is determined by cell-position order (row-major, then column-major of origin cell) to ensure deterministic tie-breaking.

**SPILL-RULE-003 (Spill commit):** On session commit, all accepted spill claims in Ω promote to `S_{n+1}`. Blocked claims emit `SpillFact::Blocked` and the origin cell's value becomes `#SPILL!`.

**SPILL-RULE-004 (Spill invalidation):** When a spill range changes size between epochs, the invalidation scope includes: (a) all nodes with `SpillRef` to the origin cell (via `#` operator), (b) all nodes whose static references overlap the *symmetric difference* of old and new spill ranges, (c) the origin node itself.

**FORMAT-RULE-001 (Format as metadata):** Cell formatting lives in a parallel format layer (Layer F), not in D. Format-dependent functions (TEXT, conditional formatting) declare an explicit **format dependency token** in their dependency set. Changes to formatting metadata that affect a format dependency token trigger invalidation of the dependent node only.

**FORMAT-RULE-002 (Format isolation):** Format changes that do not affect any format dependency token do not trigger recalculation. This prevents cosmetic edits from causing unnecessary recalc.

**VIS-RULE-001 (Visibility as scheduling hint):** Per DEC-CALC-008, visible regions define a scheduling priority overlay. The recalc scheduler may evaluate visible-region nodes before off-screen nodes within the same topological level. This alters timing but not final semantics.

**VIS-RULE-002 (Deterministic queue key):** When visibility priority is active, the evaluation queue key is `(is_visible: bool, topological_height: u32, node_id: NodeId)`. The `node_id` component ensures deterministic ordering among nodes with equal visibility and height.

**VIS-RULE-003 (Starvation prevention):** Off-screen nodes must be evaluated within `MAX_VISIBILITY_DEFER` topological waves of their natural evaluation point. This prevents pathological cases where a long chain of visible-region nodes starves background computation.

---

## 6. Concurrency model

### 6.1 Coordinator responsibilities

The **RecalcCoordinator** is the single point of authority for epoch management, session lifecycle, and recalc policy. In the VisiCalc round, it is single-threaded. In Foundation rounds, it becomes a lightweight arbiter with concurrent worker dispatch.

```
trait RecalcCoordinator {
    // Epoch management
    fn current_epoch(&self) -> Epoch;
    fn advance_epoch(&mut self, payload: CommitPayload) -> Epoch;

    // Session management
    fn active_sessions(&self) -> Vec<SessionId>;
    fn min_active_epoch(&self) -> Epoch;  // for GC

    // Recalc policy (interprets topology facts)
    fn interpret_topology(&self, facts: &[TopologyFact]) -> RecalcDecision;

    // Dispatch
    fn schedule_evaluation(&self, dirty: &[NodeId], policy: RecalcPolicy)
        -> EvalSchedule;
}

enum RecalcDecision {
    IncrementalSubgraph(Vec<NodeId>),     // evaluate only these nodes
    IncrementalWithSpillCheck(Vec<NodeId>, Vec<NodeId>),  // nodes + spill origins to verify
    FullRecalc,                           // conservative fallback
}

enum RecalcPolicy {
    Automatic,                // recalc on every edit
    Manual,                   // recalc only on explicit trigger
    VisibleFirst(VisibleRegions),  // prioritize visible nodes
}
```

### 6.2 Snapshot fences

**Fence protocol:**

1. **Read fence**: At `open_session`, the coordinator records `session.base_epoch = committed_epoch`. All formula reads during this session observe the green tree at `base_epoch`.

2. **Write fence**: At `commit`, the coordinator checks `session.base_epoch == committed_epoch`. If a concurrent structural operation advanced the epoch, the commit is rejected with `SnapshotConflict`. The session must re-open at the new epoch and re-evaluate.

3. **Spill fence**: Spill claims are validated against `committed_epoch`'s structural occupancy. If a concurrent edit occupied a cell in the spill range, the claim is rejected and the formula re-evaluates with awareness of the new blockage.

4. **Progressive publish fence** (Foundation-ready): After each topological wave completes, the coordinator may publish intermediate results by advancing `stabilized_epoch` while keeping `committed_epoch` fixed. Observers subscribed to deltas receive progressive updates. The invariant `stabilized_epoch ≤ committed_epoch` is relaxed to `stabilized_epoch.wave ≤ committed_epoch.wave` where wave identifies sub-epoch progress.

### 6.3 Contention and retry behavior

**Contention model:** The primary contention scenario is a cell edit arriving while a recalc session is in-flight. The edit advances `committed_epoch`, invalidating the session's snapshot.

**Retry strategy:**

| Scenario | Behavior |
|---|---|
| Cell edit during recalc | Session continues to completion against stale snapshot. At commit, `SnapshotConflict` detected. Coordinator opens new session at new epoch. Dirty set = (edit's dependents) ∪ (nodes that changed in the stale session). |
| Structural edit during recalc | Immediate abort of in-flight session. New session opened at new epoch with full D_static rebuild for affected region. |
| Concurrent sessions (Foundation) | Sessions targeting non-overlapping subgraphs proceed in parallel. Overlapping sessions are serialized by the coordinator. Deterministic ordering by session_id breaks ties. |
| Spill conflict during eval | Conflicting formula re-evaluates with blockage awareness. If the conflict is within the same session (two formulas competing for the same spill range), cell-position priority resolves deterministically. |

**Retry bound:** A session may retry at most `MAX_RETRY_COUNT` (default 3) times before the coordinator forces a full recalc. This prevents livelock when edits arrive faster than recalc can complete.

**Deterministic contention replay:** For test reproducibility, the coordinator logs all contention events with `(session_id, epoch, contention_kind, resolution)`. The replay harness can reproduce any contention scenario by injecting edits at specific epoch boundaries.

---

## 7. Adoption roadmap

### Phase 0: VisiCalc hardening (current → Round 0 ship)

**Scope**: Single-sheet, 63×254, sequential evaluation, conservative spill fallback.

- **Ship Option A subset**: Single-threaded recalc with full recalc on spill changes. This matches the current 50 full-recalc + 30 incremental-recalc evidence base.
- **Add `SheetId` to `NodeId`**: Even though VisiCalc is single-sheet, bake in the abstraction now.
- **Formalize session timeout**: Add `SESSION_TTL` with auto-abort to the b4 seam. Extend rejection taxonomy with `SessionExpired`, `StructuralConflict`, `ProfileVersionMismatch`.
- **Implement early cutoff**: Add value-equality check at each node during incremental recalc. This is the single highest-leverage optimization over Excel's behavior and can be validated against the existing test suite.
- **Split topology_delta**: Separate `TopologyFact` (raw evidence) from `TopologyInterpretation` (engine policy). Update b4 trace schema to `fec-f3e-trace/b5`.
- **Blocker gate**: All DAG-PO conformance rows at PACK.dag.baseline_recalc_core level must pass.

### Phase 1: Overlay foundation (Round 1 PreCalc)

**Scope**: Multi-sheet (small), calc-time overlay, dynamic reference support, selective spill invalidation.

- **Implement Layer Ω**: Session-scoped overlay store with dynamic reference recording and tentative spill claims.
- **Add `extend_capability`**: Dynamic capability extension for INDIRECT/OFFSET mid-session.
- **Implement selective spill invalidation**: Replace `ConservativeFullRecalc` with symmetric-difference invalidation (SPILL-RULE-004).
- **Implement Pearce-Kelly dynamic topo sort**: Replace full topo rebuild with incremental maintenance.
- **Implement graded volatility**: Distinguish truly volatile functions (RAND, NOW) from "dynamic but cacheable" (INDIRECT where the argument hasn't changed). Cache INDIRECT results in the overlay; only re-evaluate if the argument's value changed.
- **Abstract `GridStore` trait**: Prepare for representation swap from dense array to RRB+HAMT.
- **Blocker gate**: DAG-PO-006 (dynamic dependency soundness) and DAG-PO-007 (dynamic from-scratch consistency) must pass. All PACK.dag.dynamic_dependency_bind_semantics tests pass.

### Phase 2: Concurrency and scale (Round 2 SuperCalc)

**Scope**: Large grids, parallel evaluation, MVCC snapshots, visibility-first scheduling.

- **Swap to RRB+HAMT structural representation**: Enable O(log n) structural operations for large grids.
- **Implement level-parallel evaluation**: Dispatch nodes at the same topological height to a thread pool. Fixed-order reduction trees for aggregate functions.
- **Implement epoch-based MVCC**: Green tree snapshots via root sharing. Epoch-based reclamation (DEBRA+ style) for GC.
- **Implement visibility-first scheduling**: Per DEC-CALC-008, with deterministic queue keys and starvation prevention.
- **Formal proof of DAG-PO-003** (fixed-point convergence) and **DAG-PO-010** (parallel schedule confluence) using TLA+ or Lean.
- **Threaded coordinator**: Replace single-threaded coordinator with Arc/sync-based design. Deterministic contention replay harness.
- **Blocker gate**: PACK.dag.parallel_determinism_signature must pass. Bit-identical outputs for parallel vs sequential evaluation on the full test suite.

### Phase 3: Foundation (Round 3 Calc)

**Scope**: Full Excel fidelity, external streams, profile evolution, cloud-ready.

- **Evaluate DBSP integration**: For external stream profiles (STREAM contract), investigate Feldera-based differential maintenance as an optional computation path.
- **Semiring provenance**: For explainability and auditing, track "why" a cell has its value using provenance annotations.
- **Profile migration engine**: Automated migration of dependency graphs across profile versions using the function-affinity tracking model.
- **Distributed evaluation**: Partition large workbooks across compute nodes using the MVCC snapshot model.

### Compatibility shims

| Shim | Purpose | Lifetime |
|---|---|---|
| `ConservativeFullRecalc` spill policy | Fallback when selective invalidation encounters unknown state | Phase 0–1 |
| `VolatileAsDynamic` flag | Treat INDIRECT/OFFSET as volatile (Phase 0) or dynamic-cacheable (Phase 1+) | Phase 0 only |
| `SingleThreadCoordinator` | Sequential coordinator impl behind `RecalcCoordinator` trait | Phase 0–1 |
| `DenseGridStore` | 63×254 dense array behind `GridStore` trait | Phase 0–1 |
| `FlatTopoSort` | Full rebuild topo sort behind `TopoSortEngine` trait | Phase 0 only |

---

## 8. Open questions and decisive experiments

### Open questions

**OQ-001. What is the optimal granularity for range dependency nodes?** A formula `SUM(A1:A1000)` could create 1000 individual dependency edges or 1 range-node edge. The range-node approach reduces graph size but complicates structural rewrite (inserting a row inside the range changes the range but not the formula). **Experiment**: Benchmark both approaches on a 1000-row SUM with row insertions at various positions. Measure graph rebuild time, invalidation precision, and memory.

**OQ-002. How should LAMBDA/MAP/REDUCE closures interact with the dependency graph?** A `MAP(A1:A10, LAMBDA(x, x+B1))` creates a dynamic dependency on B1 that is discovered only during LAMBDA body evaluation. Should the dependency be attributed to the MAP cell or to a synthetic "LAMBDA invocation" node? **Experiment**: Implement both attribution models. Test with nested LAMBDA calling INDIRECT. Measure whether the synthetic-node model correctly isolates invalidation.

**OQ-003. What is the practical early-cutoff hit rate in real workbooks?** The expected benefit of early cutoff depends on how often intermediate formula values remain unchanged after an edit. If the hit rate is low (e.g., financial models where one input changes everything), the verification overhead isn't justified. **Experiment**: Instrument the engine with cutoff counters. Run against a corpus of real-world Excel files. Measure cutoff rate per formula type.

**OQ-004. Does Pearce-Kelly outperform full topo rebuild at VisiCalc scale?** For a 16K-cell grid with sparse dependencies, full Tarjan's SCC + topo sort may be faster than maintaining dynamic topo order, due to lower constant factors. **Experiment**: Benchmark full rebuild vs Pearce-Kelly on grids of 1K, 10K, 100K, 1M cells with varying dependency density. Find the crossover point.

**OQ-005. What is the correct semantics for spill-into-spill?** If formula A spills into cells that are also the target of formula B's spill, and A is evaluated first, B gets `#SPILL!`. But if B is evaluated first, A gets `#SPILL!`. The topological sort determines evaluation order, but spill conflicts can create new dependency edges that change the topological sort. **Experiment**: Test in Excel with two competing SORT formulas. Document the actual behavior for the conformance suite.

**OQ-006. How does the overlay interact with LAMBDA recursion?** A recursive LAMBDA (via named LAMBDA) creates dependency cycles that are resolved by fixed-point iteration. But the cycle members are synthetic nodes (LAMBDA invocations), not grid cells. Does the overlay need to track LAMBDA invocation identity? **Experiment**: Implement recursive LAMBDA factorial with INDIRECT in the base case. Verify that the overlay correctly records dynamic deps at each recursion level.

### Decisive experiments (with acceptance criteria)

| Experiment | Acceptance Criterion |
|---|---|
| **EXP-001: Early cutoff validation** | Incremental recalc with cutoff produces bit-identical results to full recalc on 100% of test corpus |
| **EXP-002: Overlay from-scratch consistency** | For every formula with dynamic refs, overlay-incremental result == from-scratch result (DAG-PO-007) |
| **EXP-003: Spill priority determinism** | Competing spill claims resolve identically across 1000 randomized evaluation orders |
| **EXP-004: Parallel confluence** | Level-parallel evaluation produces bit-identical results to sequential evaluation on full test suite (DAG-PO-010) |
| **EXP-005: Snapshot fence correctness** | Injecting edits at every possible point during recalc never produces torn-state observable to any reader |
| **EXP-006: Session timeout safety** | Auto-aborted sessions leave no stale overlay state; subsequent recalc produces correct results |
| **EXP-007: Dynamic topo sort crossover** | Identify cell-count threshold where Pearce-Kelly beats full rebuild; validate against expected Phase 1 grid sizes |

---

## 9. Pack and proof checklist

### Empirical packs (testable now)

| Pack ID | Description | Phase | Status |
|---|---|---|---|
| **PACK.dag.baseline_recalc_core** | Full and incremental recalc produce identical results on acyclic graphs | 0 | Partially tested (50+30 cycles) |
| **PACK.dag.cycle_iterative_semantics** | SCC detection, iterative convergence, bounded iteration | 0 | Needs dedicated tests |
| **PACK.dag.early_cutoff.signature** | Early cutoff produces from-scratch-equivalent results | 0 | **Not yet implemented** |
| **PACK.dag.dynamic_dependency_bind_semantics** | INDIRECT/OFFSET overlay recording and replay | 1 | Partially tested (65 events) |
| **PACK.dag.spill_invalidation_algebra** | Selective spill invalidation correctness | 1 | Partially tested (51 events) |
| **PACK.dag.dynamic_topo_vs_rebuild** | Pearce-Kelly correctness and performance crossover | 1 | **Not yet implemented** |
| **PACK.dag.parallel_determinism_signature** | Parallel == sequential bit-identical | 2 | **Not yet implemented** |
| **PACK.dag.external_stream_ordering** | STREAM contract deterministic ordering | 3 | **Not yet implemented** |
| **PACK.fec.session_lifecycle** | Open/commit/abort/timeout/retry all correct | 0 | 83 cycles tested; timeout not tested |
| **PACK.fec.rejection_taxonomy** | All reject classes reachable and correctly classified | 0 | 9 classes tested; 5 new classes needed |
| **PACK.fec.topology_fact_separation** | Facts vs interpretations correctly separated | 1 | **Not yet implemented** |
| **PACK.fec.dynamic_capability_extension** | Mid-session capability extension for INDIRECT | 1 | **Not yet implemented** |
| **PACK.fec.contention_replay** | Deterministic replay of all contention scenarios | 2 | **Not yet implemented** |

### Formal proof obligations

| Obligation | Method | Phase | Status |
|---|---|---|---|
| **DAG-PO-001: Acyclic from-scratch equivalence** | Property-based testing (QuickCheck/proptest) with full-recalc oracle | 0 | Achievable empirically |
| **DAG-PO-002: Deterministic replay** | TLA+ model of calc pipeline; show identical ops → identical outputs | 0 | **Needs formal model** |
| **DAG-PO-003: SCC partition correctness** | Verify against Tarjan reference implementation on generated graphs | 0 | Achievable empirically |
| **DAG-PO-004: Bounded iterative determinism** | Lean proof: define lattice, show iteration operator is monotone, height is finite | 1 | **Needs formal proof** |
| **DAG-PO-005: Monotone SCC fixed-point** | Lean proof: convergence in ≤ lattice-height iterations | 1 | **Needs formal proof** |
| **DAG-PO-006: Dynamic dependency soundness** | Overlay from-scratch consistency test (EXP-002) + review argument | 1 | Hybrid empirical + review |
| **DAG-PO-007: Dynamic from-scratch consistency** | Property-based testing: for each dynamic-ref formula, compare overlay result with clean eval | 1 | Achievable empirically |
| **DAG-PO-008: Early cutoff safety** | Proof: if `eval(node) == prev_value`, then dependents' eval is unchanged | 1 | Short manual proof |
| **DAG-PO-009: External update ordering** | TLA+ model of STREAM + recalc interaction; show deterministic ordering | 3 | **Needs formal model** |
| **DAG-PO-010: Parallel schedule confluence** | TLA+ model of level-parallel evaluation; show all interleavings produce same result | 2 | **Needs formal model** |

### Conformance rows

| Row | Description | Verification |
|---|---|---|
| **DAG-CONF-001** | Canonical recalc order metadata emitted | Assert topo-order timestamps in trace |
| **DAG-CONF-002** | SCC/cycle diagnostics available | Assert SCC membership queryable after recalc |
| **DAG-CONF-003** | Dynamic dependency traces emitted | Assert overlay D_dynamic edges in trace |
| **DAG-CONF-004** | Early cutoff observability | Assert cutoff events in trace with node_id and prev/new value hash |
| **DAG-CONF-005** | External update replay | Assert STREAM events replayable from trace |
| **DAG-CONF-006** | Parallel bit-identical outputs | Assert hash(parallel_output) == hash(sequential_output) |
| **DAG-CONF-007** | Dynamic topo fallback check | Assert Pearce-Kelly result == full-rebuild result on every graph mutation |
| **DAG-CONF-008** | Iterative cycle mode declaration | Assert profile declares cycle mode before first SCC evaluation |

---

## Conclusion

The DNA Calc engine's most consequential design decision is the **introduction of Layer Ω (calc-time overlay)** to break the circular derivation that dynamic references and spill regions impose on the S→R→D→V chain. Without Ω, the layer model is formally incomplete for any workbook using INDIRECT, OFFSET, or dynamic arrays — precisely the features that define modern spreadsheet computation.

Three insights emerged that were not obvious from the source documents alone. First, **early cutoff is the highest-leverage single optimization** available. The Build Systems à la Carte taxonomy reveals that Excel uses dirty-bit rebuilding (no cutoff), meaning DNA Calc can outperform Excel on incremental recalc by adopting Salsa-style backdating verification — a well-proven technique from rust-analyzer. Second, **the FEC/F3E evidence-vs-policy conflation** (F-002) is not just an interface hygiene issue but a correctness hazard: if the FEC's `TopologyImpact` classifications diverge from the engine's recalc policy expectations, the engine will either over-recalculate (performance loss) or under-recalculate (stale values). Splitting `topology_delta` into `TopologyFact` and engine-side interpretation is a mandatory b5 change. Third, **spill-into-spill priority** (OQ-005) is an underspecified edge case in Excel itself, and DNA Calc has the opportunity to define cleaner semantics (cell-position deterministic ordering) that Excel may not guarantee. This is a rare case where clean-room implementation can be *more* correct than the reference.