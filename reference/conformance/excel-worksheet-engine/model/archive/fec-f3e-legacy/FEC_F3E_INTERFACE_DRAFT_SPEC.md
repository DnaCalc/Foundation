# FEC-F3E Interface Draft Specification (Pathfinder-Oriented)

## 1. Purpose and Status
This document defines a comprehensive draft interface between:
1. `FEC` (Formula Evaluation Context host layer), and
2. `F3E` (Formula-Function-Formatting Engine semantic layer).

Status:
1. draft, implementation-oriented,
2. intended as the immediate design baseline for refactoring `..\DnaVisiCalc` Rust pathfinder toward explicit FEC/F3E split.
3. protocol-lane obligations are tracked in `FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv` and mapped to `XLS-CF-FEC-PR-*` / `XLS-CF-FEC-REF-*` rows.

## 2. Scope and Non-Goals
In scope:
1. exact responsibilities of FEC vs F3E,
2. normative boundary rule for value semantics ownership,
3. call protocol and message/data contracts between FEC and F3E,
4. lifecycle/state-machine model for compile/dependency/evaluate/publish,
5. minimal bootstrapping profiles aligned with non-interesting function rollout,
6. Rust pathfinder mapping for first implementation pass.

Out of scope:
1. full workbook/global scheduler architecture details beyond interface obligations,
2. non-worksheet engines (Power Query, DAX),
3. final immutable protocol versioning scheme (drafted here, finalized later).

## 3. Core Boundary Rules

### 3.1 Ownership Rule
Normative:
1. The complete value type system is owned by F3E.
2. FEC does not define or reinterpret value semantics.
3. FEC provides context services and dependency graph integration.
4. F3E is stateless across calls; all persistent/per-cell execution state is FEC-owned.

Practical consequence:
1. F3E stays portable across host contexts (grid spreadsheet host, DAG/incremental host).
2. Host-specific behavior differences are represented via FEC capabilities and profile policy, not value-semantic drift.
3. Compile/eval artifacts are produced by F3E but stored and lifecycle-managed by FEC.

### 3.2 Layer Responsibilities
F3E owns:
1. formula grammar and parse/bind outputs,
2. operator/function catalog and signatures,
3. coercion/evaluation semantics,
4. value and extended-value semantics,
5. format overlay suggestion semantics.

FEC owns:
1. host facilities (`reference`, `caller`, `time`, `random`, `external`, `locale`, `feature gate`),
2. capability gating and profile selection,
3. dependency registration/invalidation routing,
4. scheduling entry points and publication pipeline.

### 3.3 F3E Workstream Partition (Program Positioning)
To keep ownership explicit, F3E work is partitioned into sibling lanes:
1. `OxFml`:
   - formula language grammar/parse/bind,
   - formula-level normalization and dependency declaration shape.
2. `OxFunc`:
   - worksheet value type universe and coercion model,
   - built-in/operator/UDF function semantics and classification,
   - function contracts and FEC capability declarations used by function evaluation.
3. Formatting lane (current draft scope, naming TBD):
   - formatting semantics and overlay/persistence policy contracts.

Normative boundary note:
1. OxFunc does not own formula parser grammar design.
2. OxFunc does not own FEC scheduling/lifecycle protocol.
3. OxFunc does own value/function semantics consumed by F3E evaluate paths.
4. Cross-cutting tags such as `deterministic`, `volatile`, and `host-interaction` are defined by OxFunc contracts and consumed by FEC policy.

### 3.4 Managed Seam Blur Policy
This boundary is intentionally practical rather than artificially rigid.

Rules:
1. If a concept is primarily about function meaning (admission/coercion/result class), OxFunc owns it.
2. If a concept is primarily about host execution policy (when/why recalculation occurs), FEC owns it.
3. If a concept spans both (for example volatility), ownership is split:
   - OxFunc defines the function-facing declaration vocabulary and semantics,
   - FEC defines policy execution and lifecycle transitions that consume those declarations.
4. Ambiguous cases are recorded as boundary decisions and resolved explicitly during iteration.

## 4. F3E Value and Result Contracts

### 4.1 Canonical Value Universe (F3E-owned)
Draft tags:
1. `Number(f64)`
2. `Text(String)`
3. `Bool(bool)`
4. `Blank`
5. `Error(ErrorValue)`
6. `Array(ArrayValue)`
7. `Lambda(LambdaValue)` (internal/evaluable form where applicable)
8. `ReferenceLike(RefDescriptor)` (if/when needed as first-class output)

### 4.2 Extended Value Envelope
Draft:
1. `ErrorDetail` payload (`source`, `description`, diagnostics),
2. dynamic-array anchor metadata where relevant,
3. optional format-related hints at value boundary.

### 4.3 Eval Result
```text
EvalResult =
  {
    value: CellValue,
    extended_value: ExtendedValue?,
    format_overlay: FormatOverlay?,
    dep_observations: DepObservationSet?,
    diagnostics: DiagnosticSet?
  }
```

## 5. FEC Capability Model

### 5.1 Capability Families
1. `cap_reference_resolution`
2. `cap_caller_context`
3. `cap_time_provider`
4. `cap_random_provider`
5. `cap_external_provider`
6. `cap_locale_parse_format`
7. `cap_feature_gate`
8. `cap_error_detail_enrichment`

### 5.2 Function Dependency Profiles
1. `none`
2. `ref_only`
3. `caller_context`
4. `time_provider`
5. `random_provider`
6. `external_provider`
7. `locale_profile`
8. `composite`

Normative enforcement:
1. function/operator rows must declare profile + facility tags,
2. function execution must not observe undeclared capabilities.

## 6. Interface Surfaces and Calls

### 6.1 FEC -> F3E Calls
1. `CompileFormula`
2. `DeclareDependencies`
3. `Evaluate`
4. `RenderValue` (optional post-eval transformation step)

### 6.2 F3E -> FEC Capability Calls
F3E may call only through scoped capability interfaces provided in `EvalContext`.

## 7. Normative IDL (Language-Neutral)

```text
type FormulaId = string
type FormulaVersion = u64
type DependencyToken = string
type ProfileId = string
type CapabilityTag = string

record CompileContext {
  profile_id: ProfileId
  compatibility_version: string
  locale_profile: string
  feature_gate_profile: string
}

record CompiledFormula {
  formula_id: FormulaId
  formula_version: FormulaVersion
  normalized_ir: bytes | json
  static_refs: RefDescriptor[]
  static_symbols: SymbolDescriptor[]
  required_fec_facilities: CapabilityTag[]
  diagnostics: Diagnostic[]
}

record DependencyDeclContext {
  prior_token: DependencyToken?
}

record DeclaredDeps {
  token: DependencyToken
  static_edges: DependencyEdge[]
  dynamic_markers: DynamicDependencyMarker[]
}

record EvalContext {
  dependency_token: DependencyToken
  caller: CallerContext?
  profile_id: ProfileId
  capability_view: CapabilityView
  eval_mode: string
}

record PublishedResult {
  value: CellValue
  extended_value: ExtendedValue?
  format_overlay: FormatOverlay?
  published_epoch: u64
}

interface F3E {
  CompileFormula(formula_text: string, ctx: CompileContext) -> Result<CompiledFormula, CompileError>
  DeclareDependencies(compiled: CompiledFormula, ctx: DependencyDeclContext) -> Result<DeclaredDeps, DependencyDeclError>
  Evaluate(compiled: CompiledFormula, ctx: EvalContext) -> Result<EvalResult, EvalError>
  RenderValue(result: EvalResult, ctx: RenderContext) -> Result<RenderPayload, RenderError>
}
```

## 8. Rust-Oriented Trait Mapping (Pathfinder Draft)

```rust
pub trait FecHost {
    fn profile_id(&self) -> &str;
    fn compatibility_version(&self) -> &str;
    fn locale_profile(&self) -> &str;
    fn feature_gate_profile(&self) -> &str;

    fn register_dependencies(
        &mut self,
        formula_id: &str,
        deps: &DeclaredDeps,
    ) -> Result<DependencyToken, FecError>;

    fn capability_view(
        &self,
        required: &[CapabilityTag],
    ) -> Result<ScopedCapabilityView, FecError>;

    fn publish_result(
        &mut self,
        formula_id: &str,
        result: &EvalResult,
    ) -> Result<PublishedResult, FecError>;
}

pub trait F3eEngine {
    fn compile_formula(
        &self,
        formula_text: &str,
        ctx: &CompileContext,
    ) -> Result<CompiledFormula, CompileError>;

    fn declare_dependencies(
        &self,
        compiled: &CompiledFormula,
        ctx: &DependencyDeclContext,
    ) -> Result<DeclaredDeps, DependencyDeclError>;

    fn evaluate(
        &self,
        compiled: &CompiledFormula,
        ctx: &EvalContext,
    ) -> Result<EvalResult, EvalError>;
}
```

## 9. Call Sequence (Normative Flow)

### 9.1 Mutation/compile path
1. host receives formula mutation (`set_formula` style operation),
2. FEC calls `CompileFormula`,
3. on success, FEC calls `DeclareDependencies`,
4. FEC registers dependency edges and stores:
   - compiled artifact/handle,
   - dependency token/version,
5. formula cell enters `Ready` state.

### 9.2 Evaluation path
1. scheduler selects ready/dirty formula,
2. FEC builds scoped capability view from declared profile/tags,
3. FEC calls `Evaluate`, supplying FEC-owned execution context that includes compiled artifact/handle,
4. F3E returns `EvalResult`,
5. FEC publishes result (`value`, `extended`, `format_overlay`) and invalidates dependents if needed.

### 9.3 Dynamic dependency refinement path
1. `EvalResult.dep_observations` contains runtime dependency refinements,
2. FEC updates dependency graph using prior token,
3. new token/version recorded for next evaluation.

## 10. State Machine Model

States:
1. `RawFormula`
2. `Compiled`
3. `DependenciesDeclared`
4. `Ready`
5. `Evaluating`
6. `Evaluated`
7. `Published`
8. `Invalidated`

Primary transitions:
1. `RawFormula -> Compiled`: compile success.
2. `Compiled -> DependenciesDeclared`: dependency declaration accepted.
3. `DependenciesDeclared -> Ready`: scheduler-visible.
4. `Ready -> Evaluating`: evaluation dispatch.
5. `Evaluating -> Evaluated`: F3E returns.
6. `Evaluated -> Published`: FEC commit/publication.
7. `Published -> Invalidated`: `T-DEP | T-VOL | T-HOST | T-EXT | T-VERSION`.
8. `Invalidated -> Ready`: context refreshed.

Failure transitions:
1. compile error: `RawFormula -> Published` with deterministic error result.
2. evaluation error: `Evaluating -> Evaluated` with deterministic error result.
3. capability violation: `Evaluating -> Evaluated` with policy-mapped violation error.

## 11. Dependency Contract Details

### 11.1 Static dependency declaration
`DeclaredDeps.static_edges` should include:
1. reference edges (cell/range/table/name/external),
2. symbol edges (defined names, function-provider references),
3. metadata for graph classification (hard vs soft dependency where applicable).

### 11.2 Dynamic dependency observations
For context-sensitive constructs:
1. F3E reports runtime-observed dependency changes,
2. FEC updates graph atomically with evaluation publication.

## 12. Formatting Interaction Contract
1. F3E may emit `format_overlay` suggestions.
2. FEC/host applies policy for whether/how overlay affects persisted formatting or render-only view.
3. Value semantics must remain independent of display formatting semantics.
4. F3E formatting grammar must support formal ABNF-backed number-format lanes plus locale-profile adjustments supplied by FEC.
5. F3E must enforce the conditional-format restricted-formula lane (no array constants, no structured references, no union/intersection operators, no 3-D references) unless profile policy explicitly enables a documented divergence.
6. Where formal sources are underspecified (`formatCode` bounds/content and `numFmtId` defaults), F3E exposes explicit policy hooks and diagnostics; FEC binds those policies to profile/version metadata.

## 13. Function Registry and Cooperative Name Resolution
Protocol obligations:
1. F3E exposes built-in function/operator catalog with FEC profiles.
2. FEC may register external function providers through explicit catalog-update calls.
3. Name-resolution for workbook/sheet/table symbols is capability-mediated and versioned.

Versioned invalidation triggers:
1. `function_catalog_version` changes,
2. `name_resolution_version` changes,
3. `feature_gate_profile_version` changes.

## 14. Minimal Bootstrap Profiles

### 14.1 `FEC-MIN-A`
Capabilities:
1. `cap_locale_parse_format`.

Supports:
1. `none` and `locale_profile` function rows.
2. parse/bind of full formula language, with deterministic evaluation errors for unsupported reference-dependent semantics.

### 14.2 `FEC-MIN-B`
Adds:
1. `cap_reference_resolution`.

Supports:
1. `ref_only` non-interesting functions.

### 14.3 Recommended staged rollout
1. Phase A: `SIN`-class (`none`) functions.
2. Phase B: `SUM`-class (`ref_only`) functions.
3. Phase C: `ROW`-class (`caller_context`) calibration.

## 15. DnaVisiCalc Pathfinder Refactor Mapping
Current crate reality (`..\DnaVisiCalc\crates\dnavisicalc-core`):
1. parsing in `parser.rs`,
2. AST in `ast.rs`,
3. dependency extraction/graph in `deps.rs`,
4. eval/value/function handling in `eval.rs`,
5. orchestration in `engine.rs`.

Proposed split (minimum disruption):
1. Treat existing `parser.rs + ast.rs + eval.rs` as initial F3E core.
2. Treat `engine.rs` orchestration as initial FEC host.
3. Introduce internal traits/interfaces (`F3eEngine`, `FecHost`) and refactor calls through them.
4. Move dependency declaration boundary:
   - F3E exports dependency declaration from compiled IR,
   - FEC owns graph registration and scheduling.
5. Keep current externally visible engine API stable while internal boundary is introduced.

## 16. Conformance Requirements for the Split
Required checks for adopting this split:
1. value-semantic parity unchanged across refactor (F3E ownership proof by tests),
2. capability gating tests proving no undeclared FEC access,
3. dependency graph parity tests before/after split on same corpus,
4. deterministic replay parity for epoch/staleness outcomes,
5. staged profile tests (`MIN-A`, `MIN-B`) with explicit expected unsupported cases.

## 17. Immediate Implementation Backlog (Pathfinder)
1. Add internal `F3eEngine` trait and adapt current parser/eval entry points.
2. Add `CompileFormula` artifact structure in core.
3. Add explicit `DeclareDependencies` return type from compiled form.
4. Add `ScopedCapabilityView` with current minimal capabilities.
5. Route `engine.recalculate()` through `Evaluate` boundary using capability view.
6. Add regression packs comparing pre-split and post-split behavior.

## 18. Open Decisions
1. Final name token: keep `F3E` or rename to `FSE/CEE`.
2. Exact policy mapping for capability violations (user-visible error vs internal fault class).
3. Whether `format_overlay` is persisted, transient, or dual-lane per profile.
4. Long-term ABI/stable protocol format for compiled IR and dependency artifacts.
5. Default-policy strategy for number-format underspec lanes (`formatCode` and `numFmtId`) before full empirical closure.
6. Formula-visible formatting boundary policy for `TEXT`/`CELL`/`INFO` and legacy compatibility probes, including whether conditional-format effective style is observable.
