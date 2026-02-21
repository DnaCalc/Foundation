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
  - degrade/lower/opaque rules for unsupported features.
- “Compatibility versions” exist as profile versions (Excel-style notion).

### 3.3 Epoch Model (MVCC-style)
- `committed_epoch`: latest accepted document changes.
- `stabilized_epoch`: latest epoch with completed derived computation (for a scope or whole workbook).
- Values carry `value_epoch`.
- Stale values are allowed but **must be detectable** (UI/API).

Snapshot pinning:
- clients can pin an epoch for consistent reads while newer epochs progress.
- GC retains pinned epochs/caches per policy.

### 3.4 Calculation Engine Pipeline (conceptual)
- Parse → bind/resolve refs → dependency graph → invalidation closure → schedule → evaluate → commit results.
- Incremental recompute based on dependency closure.
- Deterministic mode exists (fixed scheduling and fixed reduction order where needed).

### 3.5 External Streaming and RTD-like Behavior
- Pathfinder: `STREAM("topic")` is acceptable and deterministic (epoch-scoped external provider).
- Full system: RTD support (topic lifecycle, updates, invalidations) is a core interop feature.
- External updates must appear as explicit ops and be replayable for test harnesses where required.

### 3.6 External UDFs / XLL-like integration
Pathfinder scope includes:
- external UDF registration (name, arity, flags: volatile, thread-safe),
- scalar + optional range inputs (scoped decision), scalar outputs initially,
- thread-safe vs single-thread execution constraints,
- UDFs treated as pure-oracle from Lean/TLA+ perspective (semantics parameterized by oracle results).

Full system adds:
- full XLL compatibility including marshalling/lifetime contracts and RTD integration.
- XLL is in-process with the engine; boundary contracts are formally specified and validated by Green packs.

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
  - lowering pipeline may translate internal constructs to Excel-safe constructs or explicit loss markers.

### 3.9 Collaboration (designed-in seam)
- Collaboration modeled as replication of the OpLog.
- Initial design preference: server-sequenced ops (deterministic shared log).
- Identity under structural edits is considered early (stable IDs where needed).
- Derived calc is generally local; external oracles (RTD) may be local or shared depending on profile policy.

### 3.10 UI Architecture (intended stack)
- Tauri shell with web UI.
- Grid rendering:
  - Canvas/WebGL for the giant grid (virtualized; no DOM-per-cell).
  - DOM overlay editor for Excel-grade editing (IME, selection, clipboard).
- UI state machine (“reducer” style) with explicit modes (selecting, editing, formula ref picking, fill, resize).
- Geometry spec and hit-test invariants.
- RenderPlan IR used for deterministic testing (avoid screenshot brittleness).
- View state is partially document-backed (saved view settings) and partially session state.

## 4. Architectural Constraints (A2 / CONSTR- examples)
- **CONSTR-001:** All persistent mutations are ops; direct document mutation is forbidden outside the coordinator.
- **CONSTR-002:** File and network I/O are adapters outside core; core engine has no socket/file dependencies.
- **CONSTR-003:** Unsupported constructs never crash; they preserve or degrade explicitly.
- **CONSTR-004:** Protocol surfaces are identical across Red/Blue; compatibility negotiation is mandatory.
- **CONSTR-005:** Deterministic mode must exist and be used for conformance and minimization runs.

## 5. Core Requirements (REQ- and INT-/REAL- examples)
### REQ (architecture-independent)
- Excel interop: load/save macro-enabled workbooks with no unexpected loss; preserve VBA project unless explicitly edited.
- Manual and auto recalc behaviors must match the profile definition.
- Streaming updates propagate to dependents; system exposes progress and staleness.
- UI remains responsive under defined workloads (scrolling/edit feedback targets per profile).
- System never crashes on unsupported features; must yield deterministic errors/warnings or preserve opaque.

### INT/REAL (architecture-anchored)
- **INT:** Users can trust what they see during recalculation.  
  **REAL:** Every value carries `value_epoch` and explicit stale/pending status in UI/API.
- **INT:** Custom features must not break other builds.  
  **REAL:** Unknown extension payloads round-trip; unsupported semantic extensions evaluate to explicit deterministic errors and emit diagnostics.

## 6. Pathfinder Scope Anchor (DnaVisiCalc)
- VisiCalc-sized formula language and functions.
- Manual and auto recalc.
- STREAM external provider.
- External UDF registration and invocation (XLL-like subset).
- Async/multithread scheduling + event processing scaffolding.
- Lean proofs for core semantics + one disruptive structural rewrite.
- TLA+ verification of epoch/scheduling/invalidation invariants.
- OCaml CLI oracle + trace minimizer.
- UI stack: Tauri + canvas grid + DOM overlay editor, with stale markers.

## 7. Rounds 1–3 Forward Compatibility
DnaVisiCalc must already validate the meta-architecture and the discipline that enables:
- DnaPreCalc to expand feature surface without abandoning proofs/packs,
- DnaSuperCalc to explore deeper refactors and extensibility,
- DnaCalc to synthesize a maintainable, optimized foundation for long-term evolution.