# Formula Evaluation Context (FEC) - Planning Draft

## 1. Purpose
Define a first-pass specification frame for the `FEC` abstraction used by formula parsing, binding, function evaluation, and value rendering decisions.

Working definition:
1. `FEC` is the set of host-provided facilities that are external to the pure formula/function/format core.
2. A function or operator declares which `FEC` facilities it is allowed to observe.
3. Conformance checks validate both:
   - correct results, and
   - correct `FEC` dependency boundaries.

This is a planning/spec-structure draft, not a final normative semantics document.

## 2. Why FEC Is Needed
Without an explicit FEC model, different concerns blur together:
1. parser-local policy (locale separators, feature gates),
2. binder policy (name/reference resolution),
3. evaluator policy (time/random/external providers, caller context),
4. workbook compatibility/version behavior.

FEC creates one shared contract boundary across these lanes.

## 3. FEC Core Shape (First Pass)
Proposed abstract record:

```text
FEC =
  {
    identity: FECIdentity,
    profile: FECProfile,
    facilities: FECCapabilitySet,
    policies: FECPolicySet
  }
```

### 3.1 `FECIdentity`
Minimum provenance:
1. workbook/session identifiers,
2. Excel/build compatibility mode,
3. locale and regional formatting profile,
4. calculation mode metadata.

### 3.2 `FECProfile`
A named, versioned bundle of enabled facilities and policy defaults.

Examples:
1. `FECP-worksheet-modern-v1`
2. `FECP-worksheet-compat-v1`

### 3.3 `FECCapabilitySet`
Candidate capability families:
1. `cap_reference_resolution`:
   - sheet/workbook scope,
   - defined names,
   - structured reference context,
   - external workbook link context.
2. `cap_caller_context`:
   - caller address/region,
   - current row semantics used by structured refs and intersection behavior.
3. `cap_time_provider`:
   - wall-clock time/date access.
4. `cap_random_provider`:
   - pseudo-random source.
5. `cap_external_provider`:
   - RTD/STREAM-like topic lookup and update hooks.
6. `cap_locale_parse_format`:
   - list separator, decimal separator, localized parsing behavior.
   - number-format grammar profile variants and locale rendering conventions.
7. `cap_feature_gate`:
   - dynamic array mode, compatibility-version toggles, preview feature switches.
8. `cap_error_detail_enrichment`:
   - extended error detail source/description payloads if available.

### 3.4 `FECPolicySet`
Policy values used by parser/binder/evaluator:
1. reference precedence and ambiguity policies,
2. argument-gap and omitted-argument handling policy,
3. implicit intersection mode and spill mode policy,
4. link-resolution policy for external refs,
5. volatility/external invalidation interaction policy.
6. number-format underspec policy for formal gaps (`formatCode` bounds/content and `numFmtId` default handling).
7. conditional-format restricted-formula policy (default strict lane unless explicitly version-gated).

## 4. Interaction with Existing Specs

### 4.1 Formula Language Spec Interaction
`EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md` should remain syntax/behavior focused.
FEC supplies environment-dependent interpretation inputs for rules such as:
1. scoped name binding (`FML-R-008`),
2. structured reference interpretation (`FML-R-009`),
3. argument-gap policy (`FML-R-010`),
4. dot-field/linked-data interpretation (`FML-R-011`),
5. `@` and `#` behavior in compatibility modes (`FML-R-003`, `FML-R-004`, `FML-R-005`).

### 4.2 Function Definition Spec Interaction
Function rows should add a dedicated axis:
1. `fec_dependency_profile`: the set of FEC capabilities required/allowed by the function.

Example classes:
1. `FEC_NONE`: pure function, no external context.
2. `FEC_REF_ONLY`: depends on reference/caller resolution only.
3. `FEC_TIME`: uses time provider.
4. `FEC_EXTERNAL`: uses external provider lifecycle.
5. `FEC_COMPOSITE`: multi-capability dependency.

`host_interaction_class` remains useful, but FEC profile becomes the stricter compatibility contract.

## 5. Conformance Planning (First Pass)

### 5.1 New Requirement Family
Add `XLS-CF-FEC-*` lanes to capture:
1. FEC identity/provenance capture requirements,
2. per-function declared FEC dependency profile,
3. evaluator enforcement that no undeclared FEC facility is observed,
4. parser/binder behavior under locale and compatibility profiles.

### 5.2 Evidence Model
Evidence types:
1. `E-SPEC`: authoritative docs/spec references,
2. `E-EMP`: promoted empirical findings tied to Excel build/hash,
3. `E-POL`: explicit policy decisions where specs are ambiguous.

### 5.3 Differential Probe Direction
Probe classes to add:
1. locale profile flip probes (separator and coercion behavior),
2. compatibility-version mode probes,
3. caller-context probes (`ROW()`, `@`, structured references),
4. time/random provider probes,
5. external provider invalidation probes.

## 6. Suggested File Placement and Next Artifacts
This file is the correct starting location:
1. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md`

Follow-on artifacts after review:
1. `../../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`:
   - add `fec_dependency_profile` column.
2. `model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`:
   - add `fec_profile_dependency` and/or linked FEC rule ids.
3. `EXCEL_CONFORMANCE_SPEC.md`:
   - add short FEC section and trace link to this document.
4. `KNOWN_GAPS_AND_UNCERTAINTIES.md`:
   - add FEC-specific open items and evidence gaps.
5. `model/FEC_F3E_INTERFACE_DRAFT_SPEC.md`:
   - maintain the exact protocol/call/state specification used for implementation refactors.

## 7. Open Questions to Resolve Interactively
1. Should volatility policy live fully in FEC, or split between function contract and scheduler profile?
2. Is `INDIRECT` classified as `FEC_REF_ONLY` or a stronger class because it evaluates reference text with context-sensitive parsing?
3. How should workbook compatibility-version toggles be modeled:
   - as `cap_feature_gate` in FEC, or
   - as outer profile selecting a different FEC profile?
4. Do we treat formatting-hint return adaptation as FEC or as post-eval value adaptation policy outside FEC?

## 8. Immediate Adoption Rule (Planning)
Until FEC lane is fully wired:
1. new function-policy notes should include a provisional `fec_dependency_profile`,
2. new formula-language ambiguity notes should identify which FEC facility they depend on,
3. unresolved FEC claims stay marked `provisional`.

## 9. Matching Engine Abstraction (F3E)
This FEC document now assumes a matching engine-side abstraction for formula/function/format behavior.

Working name:
1. `F3E` = Formula-Function-Formatting Engine.

Possible alternatives (open naming decision):
1. `FFFE` (Formula-Function-Format Engine),
2. `Formula Semantics Engine` (FSE),
3. `Cell Evaluation Engine` (CEE).

For now, keep `F3E` as short token.

### 9.1 F3E responsibility boundary
F3E owns:
1. formula grammar and parse/bind semantics,
2. function/operator catalog and call contracts,
3. coercion/evaluation rules for in-engine values,
4. formatting interpretation output (format hint/overlay generation),
5. the complete value type system (scalar/array/error/reference-like and extended value families).

FEC owns:
1. host context facilities (reference resolution, caller context, time, locale, feature gates, external providers),
2. capability gating and policy profile selection,
3. dependency graph integration inputs/outputs around F3E execution.

### 9.2 Value-Type Ownership Rule
Normative planning rule:
1. value semantics are fully owned by F3E.
2. FEC must not define or reinterpret value-type meaning.
3. FEC may transport/route value payloads and metadata, but as opaque or schema-versioned envelopes defined by F3E contracts.

Consequence:
1. FEC defines evaluation context, not evaluation meaning.
2. F3E is portable across host contexts (spreadsheet grid, DAG/incremental runtime) so long as host can satisfy declared FEC capabilities.

### 9.3 Stateless F3E Rule
Normative planning rule:
1. F3E is stateless across calls.
2. Per-cell/per-formula runtime state is owned by FEC execution context.
3. F3E may produce compile/eval artifacts, but FEC persists and re-attaches them to execution context for subsequent calls.

Examples:
1. `CompileFormula` returns a compiled artifact/IR; FEC stores it against formula/cell identity.
2. `Evaluate` receives context that can include the stored compiled artifact or handle.
3. Dynamic dependency or cache-like state needed across evaluations is carried by FEC-owned tokens/records, not hidden F3E mutable state.

## 10. FEC-F3E Interaction Protocol (First Pass)
Proposed cooperative protocol between host runtime (FEC side) and formula engine (F3E side):

### 10.1 Contracted calls
1. `CompileFormula(formula_text, compile_ctx) -> CompiledFormula`
2. `DeclareDependencies(compiled_formula, dep_ctx) -> DeclaredDeps`
3. `Evaluate(compiled_formula, eval_ctx) -> EvalResult`
4. `RenderValue(eval_result, render_ctx) -> RenderPayload`

### 10.2 Compile output shape
`CompiledFormula` should include:
1. normalized AST/bound expression form,
2. referenced symbol descriptors (cells/ranges/names/table refs/external refs),
3. function/operator dependency descriptors,
4. required FEC facilities inferred from expression semantics.

### 10.3 Dependency declaration handshake
`DeclareDependencies` sends to FEC:
1. static dependency candidates from compile/bind,
2. dynamic dependency markers (for constructs that may widen/narrow deps at runtime),
3. function/FEC capability dependency profile summary.

FEC returns:
1. dependency registration token/version,
2. graph update status and invalidation hooks.

### 10.4 Evaluation call
`Evaluate` receives from FEC:
1. scoped FEC facility view (capability-filtered),
2. caller identity and compatibility profile,
3. optional prepared reference handles/values (host may pre-resolve or lazy-resolve),
4. prior dependency token and evaluation mode flags.

F3E returns `EvalResult`:
1. primary value payload,
2. extended-value metadata payload (if any),
3. optional format hint/overlay suggestion,
4. runtime dependency observations (if dynamic dep lane active),
5. diagnostics (warnings/provisional notes).

Interface constraint:
1. if FEC pre-resolves references, it must return raw host cell payloads/handles only.
2. normalization into F3E value types and coercion semantics remains inside F3E.

## 11. FEC-F3E State Machine (Planning)
Cell-level state machine sketch:

1. `S0 RawFormula`
2. `S1 Compiled`
3. `S2 DependenciesDeclared`
4. `S3 Ready`
5. `S4 Evaluating`
6. `S5 Evaluated`
7. `S6 Published`
8. `Sx Invalidated` (re-entry path)

Transitions:
1. `S0 -> S1`: parse/bind success.
2. `S1 -> S2`: dependency declaration accepted by FEC graph manager.
3. `S2 -> S3`: evaluation context prepared.
4. `S3 -> S4`: evaluation scheduled.
5. `S4 -> S5`: F3E returns value/result envelope.
6. `S5 -> S6`: value/render payload committed for downstream use/UI rendering.
7. `S6 -> Sx`: invalidation from `T-DEP`, `T-VOL`, `T-HOST`, `T-EXT`, or `T-VERSION`.
8. `Sx -> S3`: context refreshed and re-evaluation path entered.

Failure edges:
1. compile failure: `S0 -> S6` with parse/bind error payload,
2. eval failure: `S4 -> S5` with deterministic error payload,
3. FEC capability violation: `S4 -> S5` with contract violation mapping (policy-defined).

## 12. Dependency Modeling and Reference Cooperation
F3E and FEC cooperation requirement:
1. F3E identifies dependency intent (what references/names/functions are semantically touched),
2. FEC resolves host objects and owns graph registration/invalidation routing,
3. F3E reports runtime-discovered dependency refinements where applicable.

Planning distinction:
1. static dependency set: compile-time discoverable,
2. dynamic dependency set: runtime-observed and tokenized by eval pass/version.

## 13. Result Model (Value, Extended Value, Formatting)
Planned result envelope:

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

Semantics:
1. `value` is the computation payload for downstream formulas.
2. `extended_value` carries optional host-enriched metadata.
3. `format_overlay` is a formatting hint/result candidate passed back to FEC/host for render/application policy.
4. render policy remains host/FEC-governed; F3E may suggest, FEC decides application path.
5. locale-profile and compatibility-profile choices in FEC are allowed to affect formatting parse/render behavior but must not redefine core value semantics.

Ownership note:
1. structure and interpretation of `value` and `extended_value` are defined by F3E type contracts.
2. FEC stores/transports them without redefining semantic behavior.

## 14. Function Registry and Name-Resolution Cooperation
Protocol needs two-way cooperation:
1. F3E publishes built-in function/operator catalog with signatures and FEC dependency profiles.
2. FEC/host may register or deregister additional function providers (XLL/VBA/Automation/JS surfaces).
3. FEC provides name-resolution services for workbook/sheet/table scopes; F3E invokes through capability-gated interfaces.

Required versioned metadata:
1. `function_catalog_version`,
2. `name_resolution_version`,
3. `feature_gate_profile_version`.

Any change in these versions can invalidate compiled formulas and force `Sx -> S3` refresh.

## 15. Minimal FEC + F3E Profile (Bootstrapping Plan)
Requested bootstrapping target:
1. Full formula language parse/bind support path,
2. non-interesting function pack in F3E,
3. minimal host environment first (optionally without reference resolution).

Two staged minimal profiles:
1. `FEC-MIN-A`:
   - capabilities: `cap_locale_parse_format` only,
   - supports `fec_dependency_profile` `none` and `locale_profile`,
   - no reference resolution.
2. `FEC-MIN-B`:
   - adds `cap_reference_resolution`,
   - enables `ref_only` non-interesting function subset.

Behavior for reference syntax under `FEC-MIN-A`:
1. parser/binder still accepts syntax,
2. evaluation of reference-dependent semantics yields deterministic explicit error/caveat (policy to finalize),
3. traces record this as profile-limited behavior, not parse failure.

## 16. Interaction with Non-Interesting Function Classification
Current classification alignment:
1. `none` profile non-interesting functions are immediately implementable in `FEC-MIN-A`.
2. `ref_only` profile non-interesting functions require `FEC-MIN-B`.
3. functions needing `caller_context` or stronger profiles remain outside minimal bootstrap set.

Recommended execution slice:
1. phase 1: `SIN`-class (`none`) functions,
2. phase 2: `SUM`-class (`ref_only`) functions,
3. phase 3: `ROW`-class (`caller_context`) calibration before broader rollout.

## 17. Next Artifact Additions
After this planning pass, add:
1. `model/FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv` (protocol/state obligations),
2. function-row fields in conformance CSV for:
   - `fec_dependency_profile`,
   - `fec_facility_tags`,
   - `f3e_phase_support` (`min-a|min-b|full`),
3. targeted empirical probe pack for:
   - dependency declaration and runtime dep refinement,
   - FEC capability denial tests,
   - value/format overlay round-trip behavior,
   - number-format underspec closure probes (`formatCode`/`numFmtId`),
   - conditional-format restricted-formula acceptance/rejection probes.

## 18. Implications of "Value System Fully in F3E"
This section captures the practical implications of the ownership rule.

### 18.1 For host runtime design
1. FEC can be spreadsheet-grid-backed or DAG/incremental-backed; both are valid.
2. Host invalidation/scheduling can stay generic, because value meaning is not host-defined.
3. Dependency edges are registered by reference/symbol identity plus F3E-declared dynamic observations.

### 18.2 For interface shape
1. FEC capability interfaces should expose context services (resolve ref, get time, get locale profile), not formula semantics.
2. F3E public contracts should define canonical value tags and coercion lattice.
3. Boundary payloads should be versioned (`value_schema_version`) to avoid silent semantic drift.

### 18.3 For conformance and verification
1. Formal value/type proofs and coercion properties attach to F3E, not FEC.
2. FEC conformance checks focus on:
   - capability gating correctness,
   - dependency/invalidation correctness,
   - context provenance correctness.
3. Differential Excel parity checks remain expressed in terms of F3E result envelopes plus FEC context metadata.

### 18.4 For non-interesting function rollout
1. `none` and `ref_only` functions can share one typed-kernel model independent of host runtime.
2. Moving from minimal FEC (`MIN-A`) to richer FEC (`MIN-B` and beyond) should not change core value semantics.
3. Any observed semantic change across FEC profiles should be treated as either:
   - declared profile feature-gate behavior, or
   - a defect.

## 19. Formatting-Specific Formal Anchor Notes
Focused formatting formal extraction (`reference/runs/20260305-ms-formatting-formal-pass-01/outputs/`) adds three FEC-relevant constraints:
1. number-format grammar uses formal ABNF-backed lanes with international-profile adjustments,
2. conditional-format formulas operate under a restricted grammar lane,
3. parts of formatting semantics remain formally underspecified and therefore require explicit policy lanes plus empirical closure.
4. formula-visible formatting boundary (`TEXT`/`CELL`/`INFO` and legacy compatibility probes) must be modeled explicitly; conditional-format effective-style visibility remains provisional.
