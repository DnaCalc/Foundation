# ARCHITECTURE_AND_REQUIREMENTS.md — DNA Calc Architecture and Requirements

## 1. Overview
DNA Calc is a near-formal spreadsheet system with two independent engines (Rust and .NET) sharing identical protocol surfaces and validated against a Green-owned spec stack: Lean (semantics proofs), TLA+ (concurrency protocol checks), OCaml oracle (executable reference), and conformance packs.

### 1.1 Three Hard Boundaries (core architectural shape)
1. **OpLog (Operations)**
   - All persistent state changes are operations (including structural edits, external updates, macro edits).
2. **DocSnapshot (Versioned Document State)**
   - Immutable snapshots per epoch/meta-epoch. Inputs are truth; derived values are caches.
3. **CalcDeltas (Derived Outputs)**
   - Engine produces deltas tagged with version info (epoch/value_epoch) and explicit stale/pending status.

## 2. Requirements Taxonomy (how to write requirements)
### 2.1 Architecture-independent requirements (REQ-)
Observable behaviors and quality targets, independent of internal mechanisms.

### 2.2 Architecture-dependent constraints (CONSTR-)
Enforceable structural rules derived from Mission/Doctrine.

### 2.3 Architecture-anchored intents and realizations (INT-/REAL-)
- **Intent (INT-)**: desired outcome, mechanism-agnostic.
- **Realization (REAL-)**: precise, testable specification anchored to chosen architecture.

## 3. System Architecture (A1)
This section now includes a formal-core layer model intended to be shared by Green proofs/models, the OCaml oracle, and both delivery engines.

### 3.1 Protocol Surface (identical across Red/Blue)
- **Dispatch ops/transactions**
- **Query snapshots**
- **Subscribe to deltas/events**
- **Capability negotiation**

This protocol is versioned, negotiated, and fully schema-defined.

### 3.2 Profiles, Feature Gates, and Compatibility
- Documents bind to `profile_id` + `profile_version`.
- Profiles define:
  - semantics (formula behavior, recalc rules, structural edit rules),
  - supported object-model facets,
  - obligation packs required for readiness,
  - degrade policy classes for unsupported features: `Native` / `Lowered` / `Opaque` / `Rejected`.
- “Compatibility versions” exist as profile versions (Excel-style notion).
- Feature-gate tokens are profile-scoped and versioned (for example `stream_semantics_version`, `FG_STREAM_BASE`, `FG_EXTERNAL_UPDATE_OPLOG`, `FG_RTD_LIFECYCLE`).

### 3.3 Epoch Model (MVCC-style)
- `committed_epoch`: latest accepted document changes.
- `stabilized_epoch`: latest epoch with completed derived computation (for a scope or whole workbook).
- Values carry `value_epoch`.
- Stale values are allowed but **must be detectable** (UI/API).

Snapshot pinning:
- clients can pin an epoch for consistent reads while newer epochs progress.
- GC retains pinned epochs/caches per policy.

#### 3.3.1 Epoch Status Lattice and Invariants
- Value status is explicit and monotonic per epoch view: `pending` -> `ready` (or `error`), with `stale` as a visibility flag relative to `committed_epoch`.
- A derived result may commit only if produced against the same input epoch it claims (`no stale commit` invariant).
- Structural edits run in exclusive mutation mode; no concurrent structural mutation may overlap their commit window.
- Replay of local or remote operations must preserve epoch ordering guarantees and produce deterministic stale/pending signaling.
- Stream updates are monotonic per topic stream sequence; duplicate/out-of-order updates are deterministically deduped/rejected per profile policy.
- Epoch GC must not reclaim any snapshot or derived cache still reachable from pinned epochs.

#### 3.3.2 CalcDelta Shape and Delivery Contract
- CalcDeltas are typed derived-output entries, not mutation records (mutations are represented by OpLog).
- A valid baseline shape is:

```text
ChangeEntryKind =
  | CellValue
  | NameValue
  | ChartOutput
  | SpillRegion
  | CellFormat
```

- Each entry carries:
  - target identity (cell/name/chart/spill anchor),
  - change payload (old/new value or old/new extent where applicable),
  - `epoch` of the snapshot that produced the entry.
- Baseline emission rule: value/output entries emit only on actual change (`old != new`); metadata deltas are profile-governed.
- Baseline delivery contract: drain-based retrieval is valid for pathfinder/embedding APIs; subscription/callback delivery may be layered as an adapter.

### 3.4 Calculation Engine Pipeline (conceptual)
- Parse → bind/resolve refs → dependency graph → invalidation closure → schedule → evaluate → commit results.
- Incremental recompute based on dependency closure.
- Deterministic mode exists (fixed scheduling, fixed reduction order where needed, and replayable event traces).
- Numeric reduction policy (for floating-point aggregation order) is profile-defined and must be explicit in compatibility documentation.
- Dependency discovery and execution order are distinct artifacts; persisted calc order traces (for example calc-chain imports/exports) are treated as caches/diagnostics, not semantic truth.
- The dependency graph operates over a unified identity domain:

```text
NodeId =
  | Cell(CellId)
  | Name(NameId)
  | Chart(ChartId)
```

- Controls are modeled as named-value nodes with attached control metadata (no separate control node kind required).
- Layer D "evaluable nodes" are `NodeId` values.

#### 3.4.1 Incremental Graph Invariant Model
- Green specifies node-level invariants inspired by production incremental systems: `necessary`, `stale`, `height`, and `scope`.
- Dynamic dependency rewiring (bind-like behavior) must carry explicit scope invalidation rules and deterministic re-stabilization behavior.
- Recompute diagnostics must be analyzable: dependency graph and stabilization traces are exportable as deterministic artifacts.

#### 3.4.2 Baseline Dirty-Closure Propagation Model (Pathfinder-Validated)
- A valid Round 0 baseline implementation uses:
  - `dirty_nodes: Set<NodeId>`
  - `reverse_deps: Map<NodeId, Set<NodeId>>`
- Baseline flow:
  1. Mark source nodes dirty from applied operations/external invalidations.
  2. Expand transitive dirty closure through `reverse_deps`.
  3. Evaluate dirty subgraph in deterministic order (with SCC handling for cyclic components).
- Formula-structure mutations may force full graph rebuild.
- Value-only mutations and targeted external invalidations should prefer incremental dirty-closure propagation.

### 3.5 External Streaming and RTD-like Behavior
- Pathfinder: `STREAM("topic")` is acceptable and deterministic (epoch-scoped external provider).
- Full system: RTD support (topic lifecycle, updates, invalidations) is a core interop feature.
- External updates must appear as explicit `OpExternalUpdate` ops (`topic_id`, `topic_seq`, payload ref/envelope) and be replayable for test harnesses where required.
- STREAM/external update semantics include explicit topic identity, dedupe rules, ordering guarantees, and coalescing policy.
- Profile policy defines whether oracle values are local-only or shared for collaboration scenarios.
- A stream replay bundle (topic declarations, updates, timing/order envelope) is a required artifact for conformance and minimization.

#### 3.5.1 External Invalidation vs Volatile Invalidation
- External functions (`STREAM`, RTD, and profile-marked externally-invalidated UDFs) recalculate on explicit external signal, not on every volatile cycle.
- Volatile functions recalculate on invalidation cycles triggered by host policy.
- Distinct invalidation pathways are required:
  - volatile invalidation scope (global or class-based),
  - external invalidation scope (targeted by provider/topic/UDF identity).
- Both pathways converge on the same dirty-closure propagation and deterministic evaluation pipeline.

### 3.6 External UDFs / XLL-like integration
Pathfinder scope includes:
- external UDF registration with explicit volatility class and thread-safety flag,
- scalar + optional range inputs (scoped decision), scalar outputs initially,
- thread-safe vs single-thread execution constraints,
- UDFs treated as pure-oracle from Lean/TLA+ perspective (semantics parameterized by oracle results).
- deterministic-mode rule: thread-safe UDF work may run in parallel but externally observable commit order must remain replayable.

Volatility classification:
- `Standard`: recalculates when upstream dependencies change.
- `Volatile`: recalculates on host invalidation cycle.
- `ExternallyInvalidated`: recalculates on explicit external signal.

Built-in and UDF volatility classification is profile-governed and must be reflected in capability/profile artifacts.

Full system adds:
- full XLL compatibility including marshalling/lifetime contracts and RTD integration.
- XLL is in-process with the engine; boundary contracts are formally specified and validated by Green packs.

### 3.6.1 Controls and Charts as Engine Entities
- Controls and charts are engine-managed entities, not UI-only caches.
- Controls are named-value entities with attached control metadata (kind/constraints) and act as source nodes.
- Charts are sink nodes consuming referenced values and producing structured chart outputs.
- Both participate in Layer D via `NodeId` and incremental dirty-closure propagation.
- Persistent creation/removal/update flows through explicit operations (`OpDefineControl`, `OpDefineChart`) and replay artifacts.

### 3.7 VBA and Macros (outside core)
- VBA runtime and editor live outside the core engine.
- Core engine stores the VBA project as a document object:
  - opaque blob (e.g., `vbaProject.bin`) + minimal metadata.
- Application layer glues:
  - file I/O ↔ engine (store/retrieve blob),
  - VBA runtime ↔ engine (macros emit ops via protocol),
  - macro execution occurs in an exclusive mutation mode (serialized event stream).

Windows-only COM automation is a separate facade layered on top of the identical protocol surface.

### 3.8 File I/O (outside core, full fidelity)
- File adapters are external components that translate to/from the object model and ops.
- For Excel interop:
  - preserve unknown/unsupported OOXML parts where feasible (opaque attachments),
  - never silently drop meaning on round-trip,
  - lowering pipeline may translate internal constructs to Excel-safe constructs or explicit loss markers,
  - degrade outcomes must be surfaced through diagnostics with policy class (`Native` / `Lowered` / `Opaque` / `Rejected`).

### 3.9 Collaboration (designed-in seam)
- Collaboration modeled as replication of the OpLog.
- Initial design preference: server-sequenced ops (deterministic shared log).
- Identity under structural edits is considered early (stable IDs where needed).
- Derived calc is generally local; external oracles (RTD) may be local or shared depending on profile policy.
- Replication envelope requires operation idempotency, causal ordering metadata, and transaction grouping.

### 3.10 UI Architecture (intended stack)
- Tauri shell with web UI.
- Grid rendering:
  - Canvas/WebGL for the giant grid (virtualized; no DOM-per-cell).
  - DOM overlay editor for Excel-grade editing (IME, selection, clipboard).
- UI state machine (“reducer” style) with explicit modes (selecting, editing, formula ref picking, fill, resize).
- Geometry spec and hit-test invariants.
- RenderPlan IR used for deterministic testing (avoid screenshot brittleness).
- View state is partially document-backed (saved view settings) and partially session state.
- UI reliability requires property-level invariants for geometry/hit-test consistency and deterministic RenderPlan validation.

### 3.11 Formal State Kernel (tree-grid hybrid with persistence facades)
DNA Calc uses a Roslyn-style persistence split for document structure:
- **Green state**: immutable, parentless, context-free persistent structures.
- **Red state**: ephemeral facade views that attach context (epoch, path, address projection, viewport caches).

Coordinates are not identity. Identity is stable under structural edits.

Grid representation assumptions (explicit):
- The worksheet grid is **gigantic** and must not be modeled as eagerly instantiated per-cell objects.
- Real content is expected to be either:
  - sparse (small set of non-trivial cells), or
  - highly structured (large regular regions representable by low-complexity virtual/backed forms).
- Therefore the implementation is expected to use alternative data representations where appropriate (for example sparse maps, in-memory arrays, database-backed chunks, generator-backed regions), while preserving identical observable semantics.

```text
type Epoch = u64
type WorkbookId = opaque
type SheetId = opaque
type RowId = opaque
type ColId = opaque
type CellId = RowId * ColId
type Label = totally ordered token

type AxisOrder<Id> = persistent ordered sequence<Id>
type CellStore = persistent map<CellId, CellPayload>
type AugTree = finite labeled tree<AugNode>

GreenSheet = {
  sheet_id: SheetId,
  row_order: AxisOrder<RowId>,
  col_order: AxisOrder<ColId>,
  cell_store: CellStore,
  aug_root: AugTree
}

GreenWorkbook = {
  workbook_id: WorkbookId,
  sheets: persistent map<SheetId, GreenSheet>,
  names_root: AugTree
}

DocSnapshot = {
  epoch: Epoch,
  root: persistent ordered tree<Label, GreenWorkbook + global nodes>,
  refs: ReferenceLayer,
  deps: DependencyLayer,
  values: ValueLayer,
  oplog_head: OpId
}

RedSheetView = {
  snapshot_epoch: Epoch,
  sheet_id: SheetId,
  row_index_cache: map<RowIndex, RowId>,
  col_index_cache: map<ColIndex, ColId>,
  addr_cache: map<A1Ref, CellId>
}

VirtualRegionAnchor =
  | CellAnchor(CellId)
  | NameAnchor(NameId)

VirtualGridRegion = {
  anchor: VirtualRegionAnchor,
  region_extent: RegionShape,
  value_source: ValueProducerRef,   // computed/derived source
  participates_in_refs: bool
}
```

Kernel invariants:
- Green structures are immutable and share unchanged substructure across epochs.
- Edits respin only edited leaves plus ancestor spine; untouched subgraphs retain identity.
- `RowId` and `ColId` stability is preserved across insert/delete except when explicitly removed.
- Address projection (`A1`, `R1C1`) is computed from axis order maps and is never the source of truth.
- Virtual grid regions are overlays for grid-value semantics and reference participation; they do not require materializing per-cell structural nodes in Layer S.
- Virtual grid regions do not mutate immutable green structure except through explicit operations.

### 3.12 Layered Semantics (structure, refs, deps, values, ops)
The semantic layers are:
1. **Layer S (Structure)**: tree-grid hybrid (`DocSnapshot.root`).
2. **Layer R (References)**: normalized reference graph over real nodes + virtual region nodes + error references.
3. **Layer D (Dependencies)**: derived evaluation graph over `NodeId` evaluable nodes.
4. **Layer V (Values/iteration)**: computed values, status lattice, and iterative control state.
5. **Cross-cutting O (Operations)**: only mutation path between snapshots.

Layer contracts:
- `R` is derived from `S` plus bind environment and dynamic-reference outcomes.
- `D` is derived from `R` by region expansion and dependency normalization.
- `V` commits are valid only against the exact input epoch they claim.
- `O` transitions must preserve `S`/`R`/`D`/`V` well-formedness invariants.

### 3.13 OpLog Formal Transition Semantics
All persistent change is represented by an envelope:

```text
OpEnvelope = {
  op_id: OpId,
  tx_id: TxId?,
  actor_id: ActorId,
  base_epoch: Epoch,
  profile_id: string,
  profile_version: string,
  op_kind: OpKind,
  payload: bytes/schema,
  causality: CausalityMeta,
  wall_clock_utc: instant
}

OpKind =
  | OpSetFormula
  | OpSetLiteral
  | OpStructural
  | OpDefineName
  | OpDefineControl
  | OpDefineChart
  | OpExternalUpdate
  | OpMacroMutation
  | OpCalcControl
```

Canonical transition relation:

```text
apply_op(profile, snapshot_e, op) -> Result(snapshot_e_plus_1, OpError)
```

Transition phases (normative):
1. Validate envelope (`profile`, schema, idempotency, causal admissibility).
2. Apply mutation to affected layers according to `op_kind` (structural ops mutate Layer S; non-structural ops may target Layer S and/or Layer V state carriers under profile rules).
3. Re-bind/normalize affected references in Layer R.
4. Recompute dependency closure in Layer D for affected scope.
5. Mark dirty/pending in Layer V.
6. Emit deterministic calc tasks and eventual `CalcDeltas`.
7. Publish `snapshot_e_plus_1` with `committed_epoch = e + 1`.

Op invariants:
- `base_epoch` mismatch is deterministically rejected or rebased per profile policy.
- Structural op commits require exclusive mutation window.
- Replaying the same admissible OpLog suffix produces equivalent snapshots and deltas.

Replay equivalence target (provisional):
- Primary target is **observational equivalence** (same externally observable query results, deltas, and diagnostics under the same profile).
- Additional equality notions remain explicitly open for formalization:
  - structural equality of persistent state representation,
  - ID-preservation equality (stable IDs preserved for surviving entities),
  - canonical serialization equality.

### 3.14 Structural Rewrite Semantics (rows/cols/sheets)
Structural ops define total coordinate rewrite functions over axis order:

```text
mu_row : RowIndex_old -> RowIndex_new | Invalid
mu_col : ColIndex_old -> ColIndex_new | Invalid
```

Reference rewrite classification (required output for each affected bound reference):
- `Preserved` (same logical target),
- `Shifted` (same target moved by axis rewrite),
- `Expanded` / `Contracted` (range boundary change),
- `Invalidated` (target removed; becomes explicit error reference).

Semantics rules:
- Insert row/col creates new `RowId`/`ColId` and rewrites address projection, not pre-existing IDs.
- Delete row/col removes IDs and rewrites all bound references through `mu_row`/`mu_col`.
- Sheet/workbook rename/move rewrites qualified references deterministically; unresolved names become error references.
- Structural rewrite traces are emitted as deterministic artifacts for pack replay.

### 3.15 Reference Resolution and Reference-Grid Update Semantics
Binding context:

```text
BindCtx = {
  workbook_id,
  sheet_id,
  anchor_cell: CellId?,
  address_mode: A1 | R1C1,
  name_scope_chain,
  profile_semantics
}
```

Normalized references:

```text
BoundRef =
  | CellRef(CellId)
  | RegionRef(SheetId, RowIdRange, ColIdRange)   // virtual region node in Layer R (provisional shape)
  | NameRef(NameId, resolved_target?)
  | ExternalRef(ProviderId, TopicId)
  | ErrorRef(ErrorKind, origin_span)
```

Open design question (intentionally unresolved):
- `RegionRef` remains one of the hardest unresolved formal-model elements.
- We have not yet fixed the canonical domain/normal form for region identity across structural rewrites (index-domain, ID-domain, or mixed authored+normalized form).
- This question stays explicitly open until we lock rewrite/equality semantics and cross-engine replay artifacts.

Reference-grid obligations:
- Maintain forward refs (`source -> target`) and reverse refs (`target -> dependent`) as explicit indices.
- Region refs are expanded into member-cell reverse dependencies for Layer D construction.
- Dynamic refs (for example `INDIRECT`-style) are tracked with discovered-target set + conservative fallback policy.
- On structural edits, recompute reference-grid delta using rewrite classification and preserve old-to-new provenance.
- Unresolvable refs must persist as `ErrorRef`; they are never silently dropped.
- Reference layer must support dereferencing virtual grid regions (for example dynamic-array spill regions) as first-class reference targets without forcing per-cell structural materialization.

### 3.16 Cycle Detection, Iteration, and Stabilization Semantics
Dependency/cycle processing is SCC-based and deterministic:
1. Build affected subgraph from Layer D.
2. Compute strongly connected components (SCCs) in stable node order.
3. For acyclic SCCs, evaluate in topological order.
4. For cyclic SCCs, apply profile cycle mode:
   - `CycleError`: publish deterministic cycle errors.
   - `Iterative`: run bounded fixed-point iteration in stable order.

Iterative mode contract:
- Profile defines `max_iterations`, convergence metric, and tolerance rules.
- Each iteration emits monotonic progress state (`pending(iter=k)` -> `ready` or `error`).
- Non-convergence at limit yields deterministic terminal error state.
- `stabilized_epoch` advances only when all dirty SCCs in scope have terminal states.

### 3.17 Formalization Seams for Lean and OCaml
The following artifacts are the handoff seam for next-round formalization:
- **Lean core**: algebraic data types for `DocSnapshot`, `OpEnvelope`, `BoundRef`, SCC iteration state, and transition relation lemmas.
- **OCaml oracle core**: executable interpreter for `apply_op`, reference rewrite, dependency rebuild, and cycle mode execution.
- **Shared trace schema**: operation trace, structural rewrite trace, reference-grid delta trace, SCC iteration trace, and value-commit trace.

Minimum module split for next discussion:
- `CoreIds` (`WorkbookId`, `SheetId`, `RowId`, `ColId`, `CellId`),
- `CoreStructure` (green tree-grid and axis order maps),
- `CoreRefs` (bind + normalized refs + rewrite),
- `CoreDeps` (graph + SCC),
- `CoreEval` (value semantics hook + iteration),
- `CoreOps` (transition system and OpLog replay).

## 4. Architectural Constraints (A2 / CONSTR- examples)
- **CONSTR-001:** All persistent mutations are ops; direct document mutation is forbidden outside the coordinator.
- **CONSTR-002:** File and network I/O are adapters outside core; core engine has no socket/file dependencies.
- **CONSTR-003:** Unsupported constructs never crash; they preserve or degrade explicitly.
- **CONSTR-004:** Protocol surfaces are identical across Red/Blue; compatibility negotiation is mandatory.
- **CONSTR-005:** Deterministic mode must exist and be used for conformance and minimization runs.
- **CONSTR-006:** Spec stack/oracle/tool integration contracts are file/CLI-based with schema-versioned artifacts.
- **CONSTR-007:** Compatibility claims require linked clean-room evidence records tied to REQ/INT/REAL identifiers.
- **CONSTR-008:** Engine lock discipline forbids awaiting or user-callback execution while holding mutation-critical locks.
- **CONSTR-009:** Performance readiness uses deterministic phase counters and published scaling signatures per required profile.
- **CONSTR-010:** Snapshot identity is ID-based (`RowId`/`ColId`/`CellId`), not coordinate-string-based; address projection is derived.
- **CONSTR-011:** Every structural op must define deterministic axis rewrite functions and explicit rewrite classification for affected references.
- **CONSTR-012:** Reference layer must model region nodes and error references explicitly; unresolved references cannot be silently discarded.
- **CONSTR-013:** Cycle handling mode (`CycleError` or `Iterative`) is profile-defined and deterministic with explicit terminal behavior.
- **CONSTR-014:** Op envelopes require idempotency/causality metadata sufficient for deterministic replay and replication safety.
- **CONSTR-015:** Green/Red persistence-facade split must preserve immutable core semantics and avoid hidden mutation in facade caches.
- **CONSTR-016:** Function invalidation classes (`Standard` / `Volatile` / `ExternallyInvalidated`) must have deterministic, non-ambiguous trigger semantics per profile.
- **CONSTR-017:** Control/chart lifecycle mutations must be represented as explicit operations and replay artifacts, never as UI-only hidden state.

## 5. Core Requirements (REQ- and INT-/REAL- examples)
### REQ (architecture-independent)
- Excel interop: load/save macro-enabled workbooks with no unexpected loss; preserve VBA project unless explicitly edited.
- Manual and auto recalc behaviors must match the profile definition.
- Streaming updates propagate to dependents; system exposes progress and staleness.
- UI remains responsive under defined workloads (scrolling/edit feedback targets per profile).
- System never crashes on unsupported features; must yield deterministic errors/warnings or preserve opaque.
- Structural edits must preserve or invalidate references deterministically with explicit diagnostics and replayable rewrite traces.
- OpLog replay of an accepted operation sequence must reproduce equivalent snapshot/value states across engines.
- Cycle behavior (error or iterative) must be observable, deterministic, and profile-consistent.
- Reference-grid updates must be incrementally maintained and auditable after every structural or formula mutation.
- CalcDelta outputs must be epoch-tagged, typed, and observationally consistent with committed snapshot transitions.

### INT/REAL (architecture-anchored)
- **INT:** Users can trust what they see during recalculation.  
  **REAL:** Every value carries `value_epoch` and explicit stale/pending status in UI/API.
- **INT:** Custom features must not break other builds.  
  **REAL:** Unknown extension payloads round-trip; unsupported semantic extensions evaluate to explicit deterministic errors and emit diagnostics.
- **INT:** STREAM/external updates must be predictable and replayable across engines.  
  **REAL:** External updates are explicit OpLog operations with versioned stream semantics, deterministic replay bundles, and pack-validated ordering/dedupe behavior.
- **INT:** Volatile and externally-signaled recalculation must not be conflated.  
  **REAL:** Profiles classify functions as `Standard` / `Volatile` / `ExternallyInvalidated` with explicit invalidation triggers and deterministic dirty-scope behavior.
- **INT:** UI correctness must be testable without screenshot dependence.  
  **REAL:** Geometry/hit-test invariants and RenderPlan determinism are required and pack-gated.
- **INT:** Performance claims must be trend-checkable, not anecdotal.  
  **REAL:** Required profiles publish deterministic phase counters and slope-based scaling signatures with regression thresholds.
- **INT:** Clean-room compatibility claims must be auditable.  
  **REAL:** Every compatibility claim links to admissible evidence records and review status.
- **INT:** Structural change semantics must be predictable and formally checkable.  
  **REAL:** Structural ops produce deterministic axis rewrite mappings plus per-reference rewrite classification artifacts.
- **INT:** Reference resolution ambiguity must be bounded and diagnosable.  
  **REAL:** Binder outputs normalized references (`CellRef`/`RegionRef`/`NameRef`/`ErrorRef`) and explicit unresolved diagnostics.
- **INT:** The formal core must be implementable consistently in Lean, OCaml, Rust, and .NET.  
  **REAL:** Shared algebraic data schemas and transition traces are normative artifacts for proofs, oracle runs, and engine conformance.
- **INT:** Cycles should not produce hidden nondeterminism.  
  **REAL:** SCC decomposition order, iteration bounds, convergence policy, and terminal-state rules are profile-governed and replayable.

## 6. Pathfinder Scope Anchor (DnaVisiCalc)
- VisiCalc-sized formula language and functions (minimal deterministic subset, explicitly versioned by profile).
- Manual and auto recalc.
- STREAM external provider.
- External UDF registration and invocation (XLL-like subset).
- Async/multithread scheduling + event processing scaffolding.
- Lean proofs for core semantics + one disruptive structural rewrite.
- TLA+ verification of epoch/scheduling/invalidation invariants.
- OCaml CLI oracle + trace minimizer.
- UI stack: Tauri + canvas grid + DOM overlay editor, with stale markers.

### 6.1 Round 0 Normative Contract (minimum)
- Required semantics: core expressions, references, deterministic dependency closure, manual/auto recalc, STREAM basics, and one structural rewrite path.
- Required obligations: core semantics packs, epoch/concurrency invariants, oracle alignment, and basic scaling signature.
- Required artifacts: capability manifest, conformance report, minimized trace corpus, replay bundles for stream cases, and formal-core traces (structural rewrite + reference-grid delta + SCC iteration).

### 6.2 Explicit Non-goals for Round 0
- Full XLL marshalling/lifetime compatibility.
- Full RTD lifecycle parity.
- Full OOXML fidelity breadth outside the pathfinder subset.
- Multi-writer collaboration semantics beyond seam validation.

### 6.3 Round 0 Track Status Decomposition (Pathfinder Feedback Snapshot)
As of **February 26, 2026**, synthesis of `DnaVisiCalc` pathfinder feedback indicates:

- Track A — Engine implementation scope:
  - status: substantially exercised in pathfinder (including structural rewrites, SCC iteration, incremental dirty-closure, UDF registration, and streaming invalidation paths).
- Track B — Green formal artifacts and assurance packs:
  - status: remains the principal Round 0 exit blocker (Lean/TLA+/oracle/pack artifacts still required by doctrine).
- Track C — beyond-minimum artifacts:
  - status: design/API artifacts exist and should be treated as evidence inputs for Round 1 shaping, not as Round 0 gate substitutes.

Round 0 exit remains blocked until required Track B obligations are completed, regardless of Track A progress.

## 7. Rounds 1–3 Forward Compatibility
DnaVisiCalc must already validate the meta-architecture and the discipline that enables:
- DnaPreCalc to expand feature surface without abandoning proofs/packs,
- DnaSuperCalc to explore deeper refactors and extensibility,
- DnaCalc to synthesize a maintainable, optimized foundation for long-term evolution.
