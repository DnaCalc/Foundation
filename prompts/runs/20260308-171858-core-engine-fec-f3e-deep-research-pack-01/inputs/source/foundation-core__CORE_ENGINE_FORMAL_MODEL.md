# CORE_ENGINE_FORMAL_MODEL.md — Core Engine Formal Model Story (Consolidated)

## 1. Purpose and Status
This document is the consolidated story-so-far for DNA Calc core engine formal/semantic modeling.

It is not:
- the pathfinder functional-scope source (that remains in DnaVisiCalc docs),
- the final formal model design,
- the final theorem/spec artifact set.

It is:
- the single active funnel for core-engine formal ideas,
- a triaged and tagged consolidation of what we currently know, suspect, and need to decide,
- the working base for iterative review and promotion into stable formal semantics over time.

## 2. Source Corpus and Context
Core context docs used in this consolidation:
- `README.md`
- `CHARTER.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `OPERATIONS.md`
- `notes/BRAINSTORM_NOTES.md`

Archived formal-idea sources consolidated here:
- `notes/archive/formal-model/FORMAL_MODELS_IDEAS.md`
- `notes/archive/formal-model/FORMAL_MODEL_REMAINING_NOTES.md`
- `notes/archive/formal-model/FORMAL_CORE_STATUS_AND_SUGGESTIONS_DRAFT.md`

## 3. Triage Tags and Promotion Rules
This document uses explicit tags on ideas and decisions:
- `Baseline`: intended current core model baseline.
- `Provisional`: accepted direction with unresolved semantics.
- `Exploratory`: research/design-space material not yet normative.
- `Deferred`: explicit backlog item retained for later formalization.
- `Out-of-core`: important system concern, but not part of the core-engine formal model.

Promotion from `Exploratory`/`Provisional` to `Baseline` requires:
- a concrete semantic decision need (profile/pack/replay impact),
- deterministic artifact/test expression,
- doctrine consistency,
- synthesis decision logging.

## 4. Core Boundary for This Document
Core engine scope captured here includes:
- protocol-facing core semantics (`dispatch/query/subscribe/capability` behavior shape),
- profile and compatibility semantics as they constrain core behavior,
- epoch/status model and calc-delta model,
- dependency/recalc semantics (including cycles/iteration),
- operation transition/replay semantics,
- structural rewrite and reference model semantics,
- core entities participating in dependency semantics (cells, names, charts, controls as modeled source/sink nodes).

`Out-of-core` system areas are tracked only as interface/seam constraints:
- VBA runtime hosting/editor,
- full file adapters and OOXML lowering,
- UI rendering architecture,
- collaboration envelope implementation details.

## 5. Consolidated Core Semantics Baseline

### 5.1 Protocol Surface and Contracts (`Baseline`)
Protocol surface (identical across implementations):
- dispatch ops/transactions,
- query snapshots/state,
- subscribe to deltas/events,
- capability negotiation.

Contract requirements:
- versioned protocol surface,
- schema-defined payloads,
- deterministic replay-compatible semantics.

### 5.2 Profiles, Gates, and Compatibility (`Baseline`)
Profiles are semantic control planes for core behavior:
- bind behavior to `profile_id` + `profile_version`,
- define semantics and structural-edit rules,
- define required obligation packs,
- define degradation classes (`Native` / `Lowered` / `Opaque` / `Rejected`),
- define feature-gate tokens (for example stream semantics and external update policies).

### 5.3 Epoch and CalcDelta Semantics (`Baseline`)
Epoch model:
- `committed_epoch`: latest accepted changes,
- `stabilized_epoch`: latest epoch with stabilized derived outputs,
- `value_epoch`: per-derived-value epoch stamp.

Status/invariant model:
- explicit stale/pending/ready/error visibility,
- no stale commit (`value must match claimed input epoch`),
- structural commit exclusivity,
- pinned-epoch-safe GC behavior.

CalcDelta model (derived output, not mutation log):
```text
ChangeEntryKind =
  | CellValue
  | NameValue
  | ChartOutput
  | SpillRegion
  | CellFormat
```
Required properties:
- epoch tagging,
- deterministic emission policy,
- drain-style retrieval contract accepted as baseline.

### 5.4 Calculation Semantics (`Baseline`)
Pipeline semantics:
- parse -> bind -> dependency graph -> invalidation closure -> schedule -> evaluate -> commit.

Identity model for evaluation graph:
```text
NodeId =
  | Cell(CellId)
  | Name(NameId)
  | Chart(ChartId)
```

Incrementality:
- invariant-oriented model (`necessary`, `stale`, `height`, `scope`) retained,
- baseline dirty-closure model retained:
  - `dirty_nodes`,
  - `reverse_deps`,
  - deterministic dirty-subgraph evaluation.

Determinism requirements:
- stable scheduling behavior,
- explicit numeric reduction policy where relevant,
- persisted calc order artifacts treated as cache/diagnostic, not semantic truth.

### 5.5 External Invalidation and UDF Semantics (`Baseline` + `Provisional`)
Three invalidation classes:
- `Standard`: upstream-dependent invalidation,
- `Volatile`: host-cycle invalidation,
- `ExternallyInvalidated`: explicit external signal invalidation.

External stream/update semantics retained:
- explicit external-update operation representation (`OpExternalUpdate`-style semantics),
- explicit topic identity and sequence handling,
- deterministic ordering/dedupe/coalescing policy by profile,
- replay-bundle expectations for conformance/minimization flows.

Required split:
- volatile invalidation path and external invalidation path are distinct,
- both converge through deterministic dirty-closure/evaluation pipeline.

UDF baseline:
- registration/unregistration,
- volatility-class declaration,
- externally driven invalidation hooks,
- caller-driven deterministic execution contract.

`Provisional`/open:
- deeper pure/impure function-class formal treatment for dependency-discovery interaction.

### 5.6 Controls and Charts as Core Entities (`Baseline`)
Controls/charts are core engine entities (not UI-only state):
- controls as named-value source entities with metadata/constraints,
- charts as sink entities producing structured outputs,
- both participate in dependency semantics and dirty propagation,
- lifecycle changes flow through explicit operation kinds and replay artifacts.

## 6. Core Formal State Kernel and Transition Semantics

### 6.1 Tree-Grid Hybrid Kernel (`Baseline`)
Persistent model shape:
- immutable green core,
- ephemeral red context facades,
- ID-based identity (`RowId`/`ColId`/`CellId`), coordinate projection derived.

Canonical identity sketch:
```text
type Epoch = u64
type WorkbookId = opaque
type SheetId = opaque
type RowId = opaque
type ColId = opaque
type CellId = RowId * ColId
```

Tree-grid hybrid concept retained from earlier notes:
- workbook/sheet/grid structural substrate,
- no arbitrary unrooted calc-node bags,
- augmentation structures may attach and participate via defined seams.

### 6.2 Layered Formal Model (`Baseline`)
```text
Layer S: Structure
Layer R: References
Layer D: Dependencies
Layer V: Values/iteration state
Cross-cutting O: Operations
```

Contracts:
- `R` derives from `S` + bind context,
- `D` derives from `R`,
- `V` commit validity is epoch-strict,
- `O` is exclusive persistent mutation pathway.

### 6.3 Reference Model (`Provisional`)
Binding context includes workbook/sheet/anchor/address-mode/profile semantics.

Normalized references:
```text
BoundRef =
  | CellRef(CellId)
  | RegionRef(SheetId, RowIdRange, ColIdRange)
  | NameRef(NameId, resolved_target?)
  | ExternalRef(ProviderId, TopicId)
  | ErrorRef(ErrorKind, origin_span)
```

Invariants:
- explicit forward/reverse dependency indices,
- explicit unresolved/error references,
- structural edit rewrite provenance retained.

Open hotspot:
- `RegionRef` canonical domain under structural rewrites.

### 6.4 Operations and Replay Model (`Baseline` + `Provisional`)
Canonical persistent-change envelope:
```text
OpEnvelope = {
  op_id,
  tx_id?,
  actor_id,
  base_epoch,
  profile_id,
  profile_version,
  op_kind,
  payload,
  causality,
  wall_clock_utc
}
```

Transition relation:
```text
apply_op(profile, snapshot_e, op) -> Result(snapshot_e_plus_1, OpError)
```

Required transition phases:
1. envelope/schema/idempotency/causality validation,
2. layer mutation by op kind,
3. reference rebind/normalize,
4. dependency closure rebuild (affected scope),
5. dirty/pending marking,
6. deterministic calc/delta emission,
7. snapshot publish.

Replay equivalence:
- `Baseline`: observational equivalence under same profile,
- `Provisional`: stronger equality targets (structural/id-preserving/serialization).

### 6.5 Structural Rewrite Model (`Baseline`)
Required rewrite functions:
```text
mu_row : RowIndex_old -> RowIndex_new | Invalid
mu_col : ColIndex_old -> ColIndex_new | Invalid
```

Required per-reference outcomes:
- `Preserved`, `Shifted`, `Expanded`, `Contracted`, `Invalidated`.

Required behavior:
- rewrite semantics are deterministic,
- invalidated references persist explicitly,
- rewrite traces are deterministic artifacts.

### 6.6 Cycles and Iteration (`Baseline` + `Deferred`)
Cycle processing baseline:
- SCC decomposition in stable order,
- acyclic SCC topological evaluation,
- cyclic SCC profile mode (`CycleError` or `Iterative`).

Iteration baseline:
- bounded policy,
- explicit progress states,
- deterministic terminal behavior on non-convergence.

`Deferred` details:
- default bounds/tolerance/rounding policy lock.

### 6.7 Formalization Seams (`Baseline`)
Seam artifacts:
- Lean core data types and theorem targets,
- OCaml oracle executable transition model,
- shared deterministic trace schemas:
  - operation trace,
  - structural rewrite trace,
  - reference-grid delta trace,
  - SCC iteration trace,
  - value-commit trace.

Baseline module split:
- `CoreIds`, `CoreStructure`, `CoreRefs`, `CoreDeps`, `CoreEval`, `CoreOps`.

## 7. Consolidated Idea Funnel (No-Loss Triage)

### 7.1 Captured High-Value Core Ideas (`Exploratory` unless noted)
From archived formal ideas and brainstorm sources, retained here:
- 1+4D substrate framing (process/workbook/worksheet/grid) (`Exploratory framing`, `Baseline-compatible`).
- augmentation-tree participation model and uniform layering mechanism (`Provisional`).
- formulas as augmentation-attached semantic structures (`Provisional`).
- spill-anchor/interior semantic relation concern (`Deferred`).
- function-class taxonomy (pure/impure/volatile/external invalidation interaction) (`Provisional/Deferred`).
- explicit region-node and error-reference first-class modeling (`Baseline` with `Provisional` details).
- operations-only mutation discipline and replay/undo implications (`Baseline`).
- Roslyn-inspired persistence facades and spine-respin semantics (`Baseline principle`, implementation shape `Exploratory`).

### 7.2 Representation Strategy Design Space (`Exploratory`)
Retained candidate families:
- full-copy control baseline,
- axis-maps + sparse cell-store,
- persistent tile DAG,
- row/column rope variants,
- piece-table / patch-stack,
- persistent rectangle algebra,
- columnar chunk store,
- balanced-block measured hybrid.

Retained evaluation/benchmark framing:
- common prototype contract,
- workload corpus (synthetic + trace-driven),
- instrumentation metrics (latency, memory, reuse ratio, read amplification),
- correctness/invariant checks,
- weighted downselect process.

### 7.3 Deferred/Open Decision Register (`Deferred`)
Priority decision buckets:
- ID/address policy (`RowId`/`ColId` scope, reuse, canonical address text).
- value algebra/coercion/lifting policy.
- dynamic-reference (`INDIRECT`-class) dependency policy.
- OpLog granularity and compaction boundaries.
- iterative-cycle defaults.
- post-server-sequenced collaboration conflict semantics.

### 7.4 Suggested Kickoff Work Items (`Provisional`)
OCaml:
- implement core ADTs and `apply_op` skeleton with phase deltas.

Lean:
- encode core ADTs and start theorem backlog:
  - replay determinism,
  - structural rewrite totality/invalidation coverage,
  - no hidden green-state mutation.

Packs/evidence implications retained:
- structural rewrite classification trace requirements,
- cycle iteration trace requirements,
- binder-normalized-reference and error-reference persistence checks.

## 8. Core vs Non-core Interaction Summary
Non-core layers and their core interaction contracts:
- UI/TUI: consume snapshots/deltas, dispatch operations; no hidden core mutation path.
- File adapters: translate external formats to/from core operations and entities; preserve degradation signaling.
- VBA/macro hosts: execute outside core, feed core through explicit operation pathway.
- Collaboration adapters: replicate operation envelopes with causality/idempotency metadata.

## 9. Uncertainty and Quality Guardrails
- Uncertain and vague material is intentionally retained with explicit tags; this avoids knowledge loss while preventing accidental elevation to baseline semantics.
- Any baseline mutation must specify:
  - affected invariants,
  - affected trace artifacts,
  - pack/gate implications,
  - migration impact on Rust/.NET/OCaml/Lean projections.

## 10. Source Coverage Index (No-Loss Map)
This index asserts where each source family is captured in this document.

- `ARCHITECTURE_AND_REQUIREMENTS.md` core sections (`3.1`, `3.2`, `3.3`, `3.4`, `3.6.1`, `3.11`..`3.17`): Sections `5` and `6`.
- `notes/BRAINSTORM_NOTES.md` core-related motifs/open questions: Sections `7.1`, `7.3`, `8`.
- `notes/archive/formal-model/FORMAL_MODELS_IDEAS.md` layered model + design-space ideas + benchmarking: Sections `6`, `7.1`, `7.2`.
- `notes/archive/formal-model/FORMAL_MODEL_REMAINING_NOTES.md` deferred decisions: Section `7.3`.
- `notes/archive/formal-model/FORMAL_CORE_STATUS_AND_SUGGESTIONS_DRAFT.md` status-derived priorities + kickoff suggestions: Sections `7.4`, `7.3`.

## 11. Superseded Notes and Active Working Rule
Active formal-model work must happen in this document.

Superseded note paths (`notes/FORMAL_*.md`) remain as archive redirects.
Full historical copies are retained under `notes/archive/formal-model/`.
