# OxFunc Reference

This document consolidates the current DNA OneCalc-relevant reference set from `OxFunc`.

Repo role: Value universe, function/operator semantics, typed host-query bundles, catalog metadata, replay-facing function packets, and extension-facing function seams.

Included source documents:
- `OxFunc/CHARTER.md`
- `OxFunc/CURRENT_BLOCKERS.md`
- `OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`
- `OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
- `OxFunc/docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
- `OxFunc/docs/function-lane/FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md`
- `OxFunc/docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv`
- `OxFunc/docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
- `OxFunc/docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md`
- `OxFunc/docs/function-lane/FUNCTION_SLICE_HYPERLINK_IMAGE_VALUE_MODEL_PRELIM.md`
- `OxFunc/docs/function-lane/FUNCTION_SLICE_RETURN_SURFACE_AND_PUBLICATION_HINT_CONTRACT_PRELIM.md`
- `OxFunc/docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md`
- `OxFunc/docs/function-lane/FUNCTION_SLICE_RUNTIME_LIBRARY_CONTEXT_PROVIDER_CONSUMER_MODEL_PRELIM.md`
- `OxFunc/docs/function-lane/FUNCTION_SLICE_TYPED_CONTEXT_AND_QUERY_BUNDLE_CONTRACT_PRELIM.md`
- `OxFunc/docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1_README.md`
- `OxFunc/docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`
- `OxFunc/docs/function-lane/OXFUNC_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
- `OxFunc/docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`
- `OxFunc/docs/function-lane/RTD_REFERENCE_CAPTURE_AND_SEAM_NOTES.md`
- `OxFunc/docs/function-lane/VALUE_UNIVERSE_PRELIM_SPEC.md`
- `OxFunc/docs/function-lane/W49_RUNTIME_LIBRARY_CONTEXT_CONSUMER_WALKTHROUGH.md`
- `OxFunc/docs/function-lane/XLL_ADDIN_BRIDGE_SHIM_CONTRACT_PRELIM.md`
- `OxFunc/docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md`
- `OxFunc/docs/IN_PROGRESS_FEATURE_WORKLIST.md`
- `OxFunc/docs/worksets/W050_DEFERRED_CURRENT_VERSION_SURFACE.md`
- `OxFunc/docs/worksets/W051_IN_SCOPE_CURRENT_VERSION_NOT_COMPLETE_SURFACE.md`
- `OxFunc/README.md`

The sources are reproduced below in full so the pack remains self-contained even after flattening.

## Source: `OxFunc/CHARTER.md`

# OxFunc Charter

## 1. Mission
OxFunc is the function-semantics and implementation lane for DNA Calc worksheet compatibility.

Its mission is to define, formalize, implement, and verify worksheet value and function behavior so compatibility claims are explicit, auditable, and reproducible.

OxFunc converts function behavior from folklore into:
1. explicit formal semantics,
2. executable implementation contracts,
3. machine-checkable proof obligations,
4. reproducible conformance evidence.

## 2. Doctrine Alignment and Values
When guidance conflicts, precedence is:
1. `../Foundation/CHARTER.md` (program doctrine),
2. `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md` (architecture constraints),
3. `../Foundation/OPERATIONS.md` (program operations),
4. `CHARTER.md` in this repository (OxFunc lane scope and execution constraints under Foundation doctrine),
5. `OPERATIONS.md` in this repository,
6. `TUX1000_PLAN.md` in this repository (aspirational, non-overriding).

Values ordering for OxFunc decisions:
1. Correctness with explicit semantics.
2. Compatibility with worksheet-observable behavior.
3. Reproducibility and evidence provenance.
4. Throughput and automation velocity.
5. Presentation elegance.

Mandatory carry-over from Foundation doctrine:
1. clean-room evidence discipline,
2. coupled assurance stack (spec/model/proof/test/evidence),
3. sequence-only planning (no date-commitment planning),
4. profile-scoped claims with explicit version context,
5. regressions as replayable permanent assets.

Non-negotiable OxFunc-specific doctrine:
1. function implementation targets full semantic identity with Excel for the declared version axes,
2. bounded or seed-only semantic coverage is scaffolding, not implementation closure,
3. when public documentation and empirical Excel behavior differ, OxFunc records the discrepancy and implements the empirically observed behavior,
4. the only allowed limitation is in the XLL test/verification seam, where host-surface reproduction may be incomplete even though OxFunc runtime semantics must still target full Excel parity,
5. XLL verification-seam limitations must be documented centrally in seam artifacts and repeated in function verification records wherever those limitations materially qualify a function claim.
6. in the current implementation phase, a function may be reported as `function-phase-complete` when its reference-baseline semantics are characterized with high confidence, the function/evaluation seam is understood and documented, the Rust implementation is thorough and tested, and the Lean/formal work required by `docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md` for the function's primary semantic substrate and admitted slice has been attended to and aligned; this may be a substrate-level executable model, binding, and alignment layer rather than a full duplicate Lean implementation for the function. No known function-semantic gap may remain in current-phase scope.
7. locale and alternate Excel-version sweeps are orthogonal validation phases unless a workset explicitly declares them in scope; they do not by themselves prevent `function-phase-complete` status.

## 3. Clean-room Rule (Non-negotiable)
Allowed inputs:
1. public specifications/documentation,
2. published research,
3. reproducible black-box observation of Excel behavior.

Not allowed:
1. proprietary or restricted materials,
2. reverse engineering of internals,
3. decompilation/disassembly of Office binaries.

## 4. Scope
In scope:
1. OxFunc as the F3E value/function slice:
   - worksheet value type semantics,
   - function/operator semantics,
   - function-level FEC capability declarations.
2. Built-in function universe and operator-as-function (`OP_*`) semantics.
3. Function call boundary semantics:
   - admission,
   - coercion,
   - kernel behavior,
   - post-call adaptation.
4. Value-universe formalization:
   - scalar/error/array/reference-like/extended-value lanes,
   - versioned edge behavior and ambiguity handling.
5. UDF surface contract semantics (XLL/VBA/JS/Automation) at function boundary depth.
6. Lean-facing formal model slices and proof obligations for selected families.
7. Rust implementation of value/function kernels and adapters.
8. Empirical edge characterization and replay artifacts for unresolved/spec-thin lanes.
9. Dual-axis version behavior tracking:
   - Excel app version/channel,
   - workbook Compatibility Version.

Out of scope:
1. Formula grammar/parse/bind ownership (OxFml lane).
2. Full FEC scheduler/protocol/lifecycle ownership (Foundation model lane).
3. Workbook-level scheduling semantics and engine concurrency internals.
4. Power Query/M, DAX, MDX internals.
5. Full VBA runtime semantics.

## 5. Boundary Contract (FEC/F3E)
Normative OxFunc boundary commitments:
1. F3E owns value semantics.
2. FEC provides context capabilities and host lifecycle policy.
3. OxFunc defines function-facing declarations (`deterministic`, `volatile`, `host-interaction`, `fec_dependency_profile`, capability tags).
4. FEC consumes those declarations for invalidation/scheduling/publication policy.
5. Any seam ambiguity is logged as an explicit boundary decision, never silently absorbed.

Implementation-seam rule:
1. OxFunc contracts must remain compatible with the active Foundation FEC/F3E interaction model.
2. Supported interaction shapes may include either:
   - `CompileFormula -> DeclareDependencies -> Evaluate -> Publish/Render`, or
   - `prepare -> open_session/capability_view -> execute -> commit`.
3. In all supported shapes, function-library invocation occurs only after FEC admission and capability decision.

## 6. Required Artifact Stack
Every promoted function slice must carry synchronized artifacts:
1. Contract artifact (`docs/function-lane/*` rows/spec notes).
2. Formal artifact (Lean module + theorem inventory).
3. Runtime artifact (Rust kernel/adapter implementation).
4. Verification artifact (contract/differential/property tests as required).
5. Evidence artifact (spec and/or empirical source bindings with reproducible provenance).
6. Correlation artifact (machine-readable linkage across the five artifacts).

## 7. Status and Gate Semantics
OxFunc uses three orthogonal status planes.

### 7.1 Execution State
For worksets and slice execution flow:
1. `planned`
2. `in_progress`
3. `blocked`
4. `complete`

### 7.2 Contract Confidence State
For function-definition rows/claims:
1. `draft`
2. `provisional`
3. `validated`

### 7.3 Assurance Maturity State
Mapped to Foundation pack language:
1. `exercised`: OxFunc-local artifacts and checks pass.
2. `green-validated`: required Foundation-level packs/evidence are complete.

Rule:
1. OxFunc may mark a slice `validated` only with explicit scope and evidence.
2. Program-level profile-green claims require `green-validated` Foundation pack closure.

### 7.4 Completeness Reporting Semantics (Mandatory)
All report-back messages and execution records must separate completion claims across these axes:
1. `execution_state`:
   - planned/in_progress/blocked/complete.
2. `scope_completeness`:
   - `scope_complete`: all obligations for the declared slice/profile scope are done.
   - `scope_partial`: some declared-scope obligations remain open.
3. `target_completeness`:
   - `target_complete`: no declared out-of-scope semantic lanes remain for the target behavior set.
   - `target_partial`: one or more semantic lanes are explicitly bounded/deferred.
4. `integration_completeness`:
   - `integrated`: admitted in all declared runtime surfaces (for example core dispatch/export lanes) for the claim.
   - `partial`: implemented but not admitted in all declared runtime surfaces.

Function-phase status term:
1. `function-phase-complete`:
   - allowed for function slices that satisfy the current implementation-phase goal over the current reference Excel baseline.
   - requires no known function-semantic gap in current-phase scope.
   - does not imply that later locale/version validation sweeps are finished.

Language rule:
1. Do not use unqualified "done/complete" claims.
2. Use `complete for declared scope` only when the declared function scope already represents full known Excel semantics for the tracked version axes and only integration or external-host limits remain partial.
3. Do not use `complete for declared scope` for semantically bounded function slices or packets; those remain `scope_partial`.
4. Always list explicit open lanes when `target_completeness = target_partial` or `integration_completeness = partial`.
5. Use `function-phase-complete` for a function only when the current implementation-phase goal is satisfied and the only remaining work is orthogonal validation-phase expansion (for example locale/version sweeps) or external XLL seam hardening.

## 8. Kickoff Program and Dependency Intent
Current kickoff bundle is the ordered `TUX1000` workset chain (`W1..W7`):
1. `PI()` method seed,
2. floating-point behavior characterization,
3. value-universe closure,
4. coercion and reference-resolution seam closure,
5. `ABS` full-formality slice,
6. `XMATCH` deterministic-quirks closure,
7. string normalization/comparison characterization.

Dependency policy:
1. W3 depends on W2 outputs.
2. W4 depends on W3 closure.
3. W5 depends on W2 + W3 + W4.
4. W6 depends on W3 + W4 + W7 (and consumes W2 numeric-edge outcomes).
5. W3 may begin before W7 closure but must absorb W7 outputs before W3 validation closure.

## 9. Definition of Done
A function slice is done for declared scope only when all hold:
1. coverage: explicit id and complete contract fields.
2. traceability: contract/formal/runtime/test/evidence linkage is machine-readable.
3. formalization: required theorem obligations for its slice class pass.
4. runtime: Rust implementation and required tests pass.
5. evidence: source bindings and empirical findings (where needed) are replayable.
6. version context: both required axes are explicit.
7. semantic identity: no known semantic gap remains between OxFunc and empirically determined Excel behavior for the function over the declared version axes.
8. discrepancy handling: any public-doc vs empirical divergence is explicitly recorded and resolved in favor of empirical Excel behavior.
9. XLL limitation disclosure: any XLL verification-seam limitation relevant to the function claim is explicitly documented in both seam-level and function-level verification records.
10. boundaries: unresolved behavior is explicit and policy-bounded, except that function-semantic omissions are not treated as acceptable closure; only XLL verification-seam limits may remain external to the function implementation claim.
11. maturity: status and assurance maturity are clearly stated (`draft/provisional/validated` and `exercised/green-validated`).

Completeness claim rule:
1. Any "done" claim must include completeness qualifiers from section 7.4.
2. For function slices, prefer `function-phase-complete` over bare "done" when the current implementation-phase goal is satisfied but later orthogonal validation sweeps remain.

## 10. Non-goal Guardrails
1. Do not claim behavior proof beyond stated contract scope.
2. Do not hide uncertainty behind broad compatibility language.
3. Do not overfit to a single Excel build while presenting unbounded claims.
4. Do not let large-catalog closure block small complete end-to-end slices.

## 11. Relationship to Operating and Aspirational Docs
1. `OPERATIONS.md` in this repository is the lane-level execution doctrine.
2. `TUX1000_PLAN.md` is the aspirational execution adjunct.
3. Workset files under `docs/worksets/` define sequence-level execution packets under this charter.
4. Foundation conformance/model docs remain authoritative for cross-program protocol and evidence governance.

## Source: `OxFunc/CURRENT_BLOCKERS.md`

# CURRENT_BLOCKERS.md — OxFunc

Status: active blockers recorded.

Last reviewed: 2026-03-27.

---

## Active Blockers

### BLK-FN-003: W023 remaining `IMAGE` publication/provider residual still needs richer host seams

- **Status**: active
- **Impact**: `W023` remains partial until the remaining `IMAGE` publication/provider seam is pinned honestly.
- **Current state**: `ISFORMULA`, `SUBTOTAL`, and `AGGREGATE` now have typed host-query seams and admitted current-baseline OxFunc closure. `HYPERLINK` is complete on the OxFunc side: value semantics and presentation intent are modeled, while actual style/clickability application remains host-owned above the OxFunc boundary. `IMAGE` now has a real OxFunc runtime surface in `crates/oxfunc_core/src/functions/image_fn.rs`: strict Excel-style argument validation, typed host/provider request normalization, provider-classified `#CONNECT!` / `#BLOCKED!` / provider-error mapping, and an extended `_webimage` rich-value return path. The remaining blocker is no longer missing OxFunc runtime plumbing; it is that the admitted end-to-end `IMAGE(...)` evaluator/adapter lane is still not evidenced, and ordinary `EvalValue` propagation still cannot carry rich values natively.
- **Exact unblock steps**: prove an admitted end-to-end `IMAGE(...)` seam lane through OxFml while preserving `ReturnedValueSurfaceKind::RichValue` with `_webimage`, and decide whether richer non-ordinary propagation beyond the current provider-supplied plain fallback is required in the current phase.
- **Recommendation**: workaround
- **Opened**: 2026-03-15

## Resolved Blockers

### BLK-FN-015: Latest OxFml generic return-surface widening reopened broad seam-fixture alignment, then was reconciled as stale local fixtures

- **Status**: resolved
- **Impact**: had temporarily reopened OxFunc-side `oxfml_seam_integration` after the latest OxFml return-surface widening.
- **Current state**: the mismatch was fixture-side, not runtime-side. OxFunc already publishes `NOW` and `TODAY` as `ValueWithPresentation` with date-like presentation hints, and OxFml's current tests and authoritative `W050` corpus agree. The stale local OxFunc rows were `E03` in `crates/oxfunc_core/tests/fixtures/w050_oxfunc_admitted_fixture_cases.json` and `FN-TODAY-01` in `crates/oxfunc_core/tests/fixtures/oxfunc_adapter_function_corpus.json`. After correcting those expectations and reverting accidental unrelated flips on `A01` / `FN-EDATE-01`, `cargo test --manifest-path crates/oxfunc_core/Cargo.toml --test oxfml_seam_integration -- --nocapture` passes cleanly again.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-27
- **Resolved**: 2026-03-27

### BLK-FN-014: Low-order current-baseline publication drift in `PV`, `FV`, and `PMT` is repaired

- **Status**: resolved
- **Impact**: had kept the broad function corpus partial and finance publication confidence qualified after the OxFml seam corrections.
- **Current state**: `W053` first narrowed the issue with direct Excel `Value2` evidence, then showed the residual was not finance-specific: live Excel `POWER(base, integer_n)` publication matched an exponentiation-by-squaring path rather than the earlier platform `powf` path. OxFunc now applies that integer-exponent publication path in `crates/oxfunc_core/src/functions/power_fn.rs`, and the finance growth helper in `crates/oxfunc_core/src/functions/financial_time_value_family.rs` consumes the same helper. `cargo test --manifest-path crates/oxfunc_core/Cargo.toml --test oxfml_seam_integration -- --nocapture` now passes cleanly.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-26
- **Resolved**: 2026-03-26

### BLK-FN-012: OxFml seam handling of unary negative literals is now verified clean

- **Status**: resolved
- **Impact**: had blocked honest interpretation of `SIGN`, `PV`, and `FV` in the broad `W049` / `W050` adapter corpus because the failure sat before value comparison.
- **Current state**: OxFml processed the March 26 residual note in `../OxFml/docs/upstream/NOTES_FOR_OXFUNC.md` Section 29, reported local parser/binder correction for unary signed literals, and OxFunc-side rerun confirmed that the prior seam failures are gone. The remaining `PV` / `FV` rows are now ordinary low-order value mismatches rather than seam failures.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-26
- **Resolved**: 2026-03-26

### BLK-FN-013: OxFml blank single-cell stand-in resolution is now verified clean

- **Status**: resolved
- **Impact**: had blocked honest interpretation of blank-sensitive seam cases, surfaced by `ISBLANK(A1)` in the broad function corpus.
- **Current state**: OxFml processed the March 26 residual note in `../OxFml/docs/upstream/NOTES_FOR_OXFUNC.md` Section 29, reported local correction so absent single-cell worksheet references materialize as blank-cell stand-ins rather than unresolved-reference failures, and OxFunc-side rerun confirmed the prior `ISBLANK` seam failure is gone.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-26
- **Resolved**: 2026-03-26

### BLK-FN-008: Odd-bond `ODDL*` parity is not yet closure-grade

- **Status**: resolved
- **Impact**: had blocked `W027` odd-last promotion.
- **Current state**: `W027` replaced the old odd-last discounted-boundary model with the Excel-style normalized quasi-coupon accumulation and the US 30/360 modify-both-dates hack. Native worksheet replay in `.tmp/w27-bond-odd-bond-results.csv` now matches `ODDLPRICE(...)=99.87828601472134` and `ODDLYIELD(...,99.87828601472134,...)=0.04050000000000125`.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-18

### BLK-FN-010: `XNPV` / `XIRR` negative-rate and root-finding parity is reopened by `W29`

- **Status**: resolved
- **Impact**: had blocked `W032` cashflow-rate repair.
- **Current state**: `W32` repaired `XNPV` negative-rate worksheet admission to match direct Excel `#NUM!`, repaired the reopened `XIRR` negative-root lane, and repaired the negative-guess rejection lane for the positive-root-only benchmark case. The previously extracted large-root precision lane is now also repaired and closed by `W037`.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-19

### BLK-FN-011: `XIRR` large positive-root publication mismatch after `W32`

- **Status**: resolved
- **Impact**: had blocked full finance closure after `W32`.
- **Current state**: `W037` characterized Excel's published-result policy on the large positive-root two-cashflow lane directly, replaced the old exact closed-form shortcut with an Excel-like bracket-and-bisection publication solver for the admitted slice, reran the `W29` benchmark, and matched the installed Excel guess matrix exactly.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-21

### BLK-FN-009: `COUPDAYS` leap-year actual/actual parity is reopened by `W29`

- **Status**: resolved
- **Impact**: had blocked `W032` coupon-family repair.
- **Current state**: `W32` repaired `COUPDAYS` on the reopened leap-year actual/actual lane by using the maturity-day nominal previous coupon date for period-size calculation while preserving the aligned `COUPDAYBS` / `COUPDAYSNC` lanes.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-19

### BLK-FN-006: `NUMBERVALUE` default separators and `TRANSLATE` provider behavior do not fit the ordinary pure mega-batch

- **Status**: resolved
- **Impact**: had blocked honest closure claims inside the ordinary mega-batch and then `W030` / `W031`.
- **Current state**: `W30` and `W31` completed as seam-definition/reconciliation packets. `NUMBERVALUE` now moves to `W035`, and `TRANSLATE` now moves to `W036`.
- **Exact unblock steps**: none inside `W030` / `W031`; successor worksets now own the residual function work.
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-19

### BLK-FN-005: `ASC` / `DBCS` / `JIS` are host-profile-sensitive rather than ordinary pure text functions

- **Status**: resolved
- **Impact**: had blocked honest closure claims inside the ordinary mega-batch and then `W030`.
- **Current state**: `W30` completed as a seam-definition/reconciliation packet. `ASC`, `DBCS`, and `JIS` now move to `W034`.
- **Exact unblock steps**: none inside `W030`; successor workset `W034` now owns the residual function work.
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-19

### BLK-FN-007: Bond core basis-`1` parity is not yet closure-grade for `PRICEMAT` / `YIELDMAT`

- **Status**: resolved
- **Impact**: had blocked `W027` bond-core promotion.
- **Current state**: `W027` corrected `PRICEMAT` / `YIELDMAT` to use the Excel-style `DaysInYear(issue,settlement)` denominator on the admitted maturity-security slice. Native worksheet replay in `.tmp/w27-bond-odd-bond-results.csv` now matches `PRICEMAT(...)=98.59811340546048` and `YIELDMAT(...)=0.06100000000000056`.
- **Exact unblock steps**: none
- **Recommendation**: continue
- **Opened**: 2026-03-18
- **Resolved**: 2026-03-18

### BLK-FN-004: W021 first live OxFunc replay-adapter run is blocked by missing adapter implementation and runner surfaces

- **Status**: resolved
- **Impact**: had blocked `W021` from producing any exercised proving artifact for `cap.C0.ingest_valid` through `cap.C3.explain_valid`.
- **Current state**: `tools/replay-adapter/run-w15-replay-adapter-baseline.ps1` now emits the first live local W15 replay bundle under `.tmp/replay-bundles/oxfunc-w15-v1/`, validates the required layout/fields, replays the row views deterministically, and emits diff/explain artifacts recorded in `docs/function-lane/W21_EXECUTION_RECORD.md`.
- **Exact unblock steps**: none
- **Recommendation**: continue from the emitted W15 bundle toward reduced-witness and external replay-host evidence
- **Opened**: 2026-03-16
- **Resolved**: 2026-03-17

### BLK-FN-002: Existing `text_scalar_misc` full-suite failures block clean packet-wide cargo test runs

- **Status**: resolved
- **Impact**: had qualified packet-wide verification hygiene for `W016`; until resolved, only targeted family verification could be claimed.
- **Current state**: W16 Batch 31 promoted the existing `text_scalar_misc` family (`CHAR`,`CODE`,`LOWER`,`UPPER`,`TRIM`,`REPT`) into the runtime/export/formal surface and aligned the stale unit-test expectations with the adapter's explicit domain-error contract. Full `cargo test --manifest-path crates/oxfunc_core/Cargo.toml` now passes cleanly.
- **Exact unblock steps**: none
- **Recommendation**: remove the packet-wide verification qualification and continue W16 family expansion
- **Opened**: 2026-03-15
- **Resolved**: 2026-03-15

### BLK-FN-001: W15 upstream typed host-query seam acknowledgment

- **Status**: resolved
- **Impact**: had blocked a full W015 completion claim and kept `IP-08` open even though the local current-baseline `CELL` / `INFO` semantics were replay-clean.
- **Current state**: OxFunc has local typed seam/runtime/formal/evidence closure for the admitted `CELL` / `INFO` slice, including dual-run (`default` + `compat_template`) native probes and dual-run generated XLL bridge parity. OxFml has now acknowledged `HO-FN-002` in both `docs/upstream/NOTES_FOR_OXFUNC.md` and `docs/handoffs/HANDOFF_REGISTER.csv`.
- **Exact unblock steps**: none
- **Recommendation**: close W015 locally and remove `IP-08` from the in-progress register.
- **Opened**: 2026-03-15
- **Resolved**: 2026-03-15

---

## Entry Template

```
### BLK-FN-NNN: <title>

- **Status**: active | resolved | closed
- **Impact**: <which worksets/features are blocked>
- **Current state**: <what has been attempted, what failed>
- **Exact unblock steps**: <specific actions needed>
- **Recommendation**: wait | escalate | workaround
- **Opened**: YYYY-MM-DD
- **Resolved**: YYYY-MM-DD (if applicable)
```

## Source: `OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`

```csv
"fdef_id","title","statement","status","evidence_ids","affected_requirement_ids","decision_needed","fec_dependency_profile","fec_facility_tags","notes"
"FDEF-001","Volatile vs non-deterministic separation","Function definitions shall model volatility and non-determinism as separate axes, not synonyms.","draft","ECS-037;ECS-039;ECS-059;EMP-0008","XLS-CF-FN-008;XLS-CF-VP-005","yes","none","","Need final taxonomy and examples policy."
"FDEF-002","Host interaction taxonomy","Function definitions shall declare host interaction dependency class (none/workbook/app/environment/external-provider).","draft","ECS-037;ECS-040;ECS-053;ECS-054;EMP-0006","XLS-CF-FN-007;XLS-CF-FN-010;XLS-CF-VP-003","yes","composite","cap_reference_resolution;cap_caller_context;cap_time_provider;cap_external_provider","Key for reproducible conformance replay."
"FDEF-003","Invalidation trigger declaration","Each function definition shall declare invalidation triggers (T-DEP,T-VOL,T-HOST,T-EXT,T-VERSION).","draft","ECS-037;EMP-0008","XLS-CF-FN-008;XLS-CF-VP-004;XLS-CF-VP-005","yes","composite","cap_reference_resolution;cap_time_provider;cap_external_provider;cap_feature_gate","Needed for reason-code and recalc semantic tests."
"FDEF-004","Aggregate coercion policy boundary","Aggregate function definitions shall distinguish direct-arg coercion from range-scan coercion policies.","provisional","EMP-0003;ECS-003;ECS-018;ECS-019","XLS-CF-TV-008;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","Blocked on function-policy decisions for aggregate family."
"FDEF-005","Argument-gap handling policy","Function-definition policy shall specify accepted/rejected/mapped behavior for missing-argument patterns.","provisional","EMP-0001;ECS-008","XLS-CF-FL-010","yes","locale_profile","cap_locale_parse_format","Current behavior is build-scoped provisional."
"FDEF-006","Dynamic-array function spill semantics","Function definitions for dynamic-array producers/transformers shall declare spill-shape and blocking expectations.","provisional","ECS-006;ECS-007;EMP-0010;EMP-0005;EMP-0004","XLS-CF-FL-005;XLS-CF-TB-004;XLS-CF-FM-005","yes","composite","cap_reference_resolution;cap_feature_gate","Links function semantics to table/CF spill mismatch lanes."
"FDEF-007","External reference and open-state policy","Function-policy and formula-policy interpretation shall include workbook-open/link-update state effects for external references.","provisional","EMP-0011;ECS-008;ECS-009","XLS-CF-FL-006","yes","composite","cap_reference_resolution;cap_feature_gate","Same-build baseline exists; cross-build convergence pending."
"FDEF-008","Merge/formula interaction follow-up","Function definitions interacting with merged ranges shall declare behavior expectations or explicit caveats.","draft","EMP-0012;ECS-031","XLS-CF-FM-003","yes","ref_only","cap_reference_resolution","New direct merge evidence now available; functional interactions not yet mapped."
"FDEF-009","Operator-as-function inventory","Evaluable operators shall be represented as pseudo-function rows (`OP_*`) in the function-definition lane.","draft","ECS-003;ECS-004;ECS-005;ECS-008","XLS-CF-FL-001;XLS-CF-FL-002;XLS-CF-FL-003;XLS-CF-FL-004","yes","ref_only","cap_reference_resolution","Includes reference operators and trim-reference family."
"FDEF-010","Parse delimiter separation","Parse-only delimiters (for example argument separators) shall be modeled as syntax-layer items, not evaluable function rows.","draft","ECS-008","XLS-CF-FL-006","yes","locale_profile","cap_locale_parse_format","Locale token profile retained in language concrete rules."
"FDEF-011","Pre-call argument coercion","Function definitions shall declare host-side argument coercion behavior before invocation.","draft","ECS-003;ECS-018;ECS-019;EMP-0003","XLS-CF-TV-007;XLS-CF-TV-008","yes","composite","cap_reference_resolution;cap_locale_parse_format","Key for non-interesting-function UDF parity hypothesis."
"FDEF-012","Post-call return adaptation","Function definitions shall declare host-side return adaptation behavior, including array-to-anchor adaptation boundaries.","draft","ECS-006;ECS-007;EMP-0010","XLS-CF-FL-005","yes","composite","cap_reference_resolution;cap_feature_gate","Spill projection details stay outside this doc."
"FDEF-013","Extended value boundary","Function/value model shall distinguish primary values from extended-value wrappers used at worksheet boundary.","draft","ECS-026;ECS-027;ECS-021;ECS-024;ECS-025","XLS-CF-TV-005;XLS-CF-FM-002","yes","composite","cap_error_detail_enrichment;cap_feature_gate","Includes formatting hints, rich error detail, virtual anchor-relative values."
"FDEF-014","XLL UDF registration and context","XLL UDF function definitions shall include registration signature, caller-context, volatility, and reference argument/return semantics.","provisional","ECS-040;W9-XLL-BL-20260308","XLS-CF-FN-007;XLS-CF-FN-010","yes","composite","cap_reference_resolution;cap_caller_context;cap_external_provider","W9 bridge now uses profile-derived registration/export generation from core function metadata, with generated U-vs-Q variants across the catalog in `tools/xll-addin/oxfunc_xll/export_specs.csv`. Remaining closure: deeper non-scalar payload lanes and broader caller-context/volatility conformance packs."
"FDEF-015","VBA UDF semantics","VBA UDF definitions shall capture scope, argument/reference behavior, and mutation constraints during recalculation.","draft","ECS-035","XLS-CF-FN-007;XLS-CF-VP-003","yes","composite","cap_reference_resolution;cap_caller_context;cap_locale_parse_format","Open questions retained: Range return semantics and allowed side effects."
"FDEF-016","Automation Add-in UDF semantics","Automation Add-in UDF definitions shall capture COM registration and invocation semantics sufficient for compatibility classification.","draft","ECS-035","XLS-CF-FN-007;XLS-CF-VP-003","yes","composite","cap_reference_resolution;cap_external_provider;cap_locale_parse_format","Lower priority depth in this phase."
"FDEF-017","JavaScript custom function semantics","JavaScript custom function definitions shall include async/external behavior and extended data-type return implications.","draft","ECS-021;ECS-024","XLS-CF-FN-007;XLS-CF-TV-005","yes","composite","cap_external_provider;cap_feature_gate","Includes custom/linked data-type style returns."
"FDEF-018","Implicit intersection canonicalization","`@` shall be modeled as canonical operator-function with legacy alias metadata for `SINGLE`/`_xlfn.SINGLE` compatibility contexts.","provisional","ECS-004;ECS-008;W14-20260322-BASELINE","XLS-CF-FL-003;XLS-CF-FL-007","yes","composite","cap_reference_resolution;cap_caller_context;cap_feature_gate","Current baseline now pins scalar passthrough, single-row/single-column caller-relative selection, array top-left scalarization, spill-anchor scalarization after upstream spill resolution, 2-D seeded range lane `#VALUE!`, and Formula-vs-Formula2 explicit-@ normalization. Remaining gaps: precise compatibility-version mapping plus scalarization provenance across OxFml/FEC/F3E."
"FDEF-019","Compatibility-version-scoped definitions","Function definitions shall support workbook-level compatibility-version scoping and explicit divergence metadata.","draft","ECS-034;ECS-035;ECS-036","XLS-CF-VP-001;XLS-CF-VP-002","yes","composite","cap_feature_gate","Axis required in conformance replay matrices."
"FDEF-020","RTD topic lifecycle semantics","RTD semantics shall define topic registration, topic->cell mapping, update-driven invalidation, and disconnection behavior.","provisional","ECS-040;EMP-0006","XLS-CF-FN-010","yes","external_provider","cap_external_provider","Refine with targeted empirical traces for connect/reconnect/disconnect paths."
"FDEF-021","Reference operator pre-call normalization","`#` and structured-reference operands shall have explicit pre-call normalization/dereference policy in function evaluation contract.","draft","ECS-005;ECS-012;ECS-013;ECS-014","XLS-CF-FL-004;XLS-CF-FL-009;XLS-CF-TB-001","yes","ref_only","cap_reference_resolution","Open question: observability by non-interesting functions."
"FDEF-022","Non-interesting function UDF parity hypothesis","Non-interesting functions should be implementable with full fidelity via UDF-style implementations under explicit coercion/reference policies.","draft","ECS-001;ECS-002;EMP-0003","XLS-CF-FN-001;XLS-CF-FN-002","yes","composite","cap_reference_resolution;cap_caller_context;cap_locale_parse_format","Needs systematic differential implementation/test campaign."
"FDEF-023","XLOOKUP reference-return behavior","XLOOKUP reference-output semantics shall be confirmed and classified for host-interaction and determinism axes.","draft","ECS-001;ECS-002","XLS-CF-FN-002","yes","ref_only","cap_reference_resolution","Run targeted empirical matrix and include reference-vs-value output distinctions."
"FDEF-024","Interesting function classification coverage","All interesting functions (tiers 3/4/5) shall have initial axis classification rows, marked provisional where uncertain.","draft","ECS-001;ECS-002","XLS-CF-FN-002","yes","composite","cap_reference_resolution;cap_caller_context;cap_time_provider;cap_random_provider;cap_external_provider;cap_locale_parse_format;cap_feature_gate","Initial inventory/classification file added for iterative refinement."
"FDEF-025","Function admission vs runtime error contract","Function definitions shall declare parse-admission vs runtime-error boundaries for required arguments, scalar coercion, numeric domain, and array-lift error propagation.","draft","ECS-008;ECS-109;ECS-110;ECS-111;ECS-112","XLS-CF-FL-012;XLS-CF-TV-007;XLS-CF-FN-001","yes","composite","cap_reference_resolution;cap_locale_parse_format;cap_feature_gate","Canonical seed family: SIN(), SIN(""asd""), SIN({1,""asd"",3}), ASIN(2). Baseline evidence captured in docs/function-lane/FORMULA_ADMISSION_BEHAVIOR_NOTES.md and tools/formula-admission-probe/run-formula-admission-baseline.ps1."
"FDEF-026","PI end-to-end seed slice","`PI()` shall be used as the first cross-lane seed slice with linked contract, Lean obligations, Rust implementation/tests, and correlation ledger entry.","provisional","POL-TUX1000-001;W1-FA-BL-20260305","XLS-CF-FN-001;XLS-CF-FN-002","no","none","","W1 is `function-phase-complete` for the current implementation phase in docs/worksets/W001_PI_END_TO_END_SLICE.md and docs/function-lane/FUNCTION_SLICE_PI_CONTRACT_PRELIM.md, with admission-boundary supplement in docs/function-lane/FORMULA_ADMISSION_BEHAVIOR_NOTES.md. Declared thread safety class: `safe_pure`, `arg_preparation_profile=values_only_pre_adapter`, `coercion_lift_profile=none`, `kernel_signature_class=nullary_const`, adapter-level `fec_dependency_profile=none`, and surface-level `surface_fec_dependency_profile=none`. Remaining cross-build/channel, locale, compatibility, and direct C API replay are orthogonal validation-phase follow-up."
"FDEF-027","Floating-point edge normalization characterization","Function/value policy shall explicitly characterize worksheet-visible behavior for IEEE edge values (`-0`, `+/-inf`, NaN variants, subnormals) across formula evaluation, sheet materialization, and reference reuse boundaries.","provisional","W2-RUN-20260305;W2-LEDGER-20260305;EMP-CAND-FP-001;EMP-CAND-FP-002;EMP-CAND-FP-003;EMP-CAND-FP-004","XLS-CF-TV-005;XLS-CF-FN-001;XLS-CF-FN-002","yes","composite","cap_feature_gate;cap_reference_resolution","Baseline closure recorded in docs/function-lane/FLOATING_POINT_EXECUTION_RECORD.md with reproducible suite tooling in tools/fp-probe/run-fp-suite.ps1; promotion to Foundation EMP registry deferred pending multi-build/compat coverage."
"FDEF-028","Value universe and extended-value taxonomy","OxFunc shall define a version-scoped formal value universe, including boundary distinctions across cell content, formula-eval values, reference-like values, and extended-value wrappers.","draft","TBD-SPEC-VALUE-001;W3-VU-BL-20260305;W7-STR-BL-20260305","XLS-CF-TV-005;XLS-CF-FN-001;XLS-CF-FN-002","yes","composite","cap_reference_resolution;cap_error_detail_enrichment;cap_feature_gate","W3 baseline artifacts include VALUE_UNIVERSE_PRELIM_SPEC/VALUE_UNIVERSE_TAG_TABLE with Rust/Lean mirrors. W7 baseline feed adds text-cap and UTF-16 boundary constraints (including interop truncation edge cases)."
"FDEF-029","Coercion primitives and Ref->Val seam","Function semantics shall use explicit conversion/coercion primitives and a formally declared out-of-model reference-resolution seam that maps references to evaluable values under FEC capability contracts.","provisional","TBD-SPEC-COERCE-001;W4-COERCE-BL-20260307","XLS-CF-TV-007;XLS-CF-TV-008;XLS-CF-FN-001","yes","composite","cap_reference_resolution;cap_locale_parse_format;cap_feature_gate","W4 baseline closure recorded with selected capability-record seam and executable+empirical artifacts in docs/worksets/W004_COERCION_AND_REFERENCE_RESOLUTION_PRIMITIVES.md, docs/function-lane/COERCION_AND_CONVERSION_PRELIM_SPEC.md, docs/function-lane/REF_RESOLUTION_SEAM_OPTIONS.md, docs/function-lane/COERCION_DECISION_TABLE.csv, and docs/function-lane/COERCION_EXECUTION_RECORD.md; includes external/open-state reference row (`CO4-018`) with closed-vs-open observed divergence."
"FDEF-030","ABS full-formality seed","`ABS` shall be formalized with explicit admission/coercion/domain/array-lift/floating-point edge behavior and correlated Lean/Rust/evidence artifacts.","provisional","TBD-SPEC-ABS-001;W2-RUN-20260305;W4-COERCE-BL-20260307;W5-ABS-BL-20260308;W5-ABS-ENTRY-20260308;W5-ABS-FP-20260310","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FL-012","yes","none","cap_reference_resolution","W5 closure is now `function-phase-complete` for the current implementation phase in docs/worksets/W005_ABS_FULL_FORMALITY.md, with linked contract/formal/runtime/evidence artifacts: docs/function-lane/FUNCTION_SLICE_ABS_CONTRACT_PRELIM.md, docs/function-lane/ABS_SCENARIO_MANIFEST_SEED.csv, docs/function-lane/ABS_PROBE_RUNTIME_REQUIREMENTS.md, docs/function-lane/ABS_EXECUTION_RECORD.md, formal/lean/OxFunc/FloatingPointEnv.lean, formal/lean/OxFunc/Functions/Abs.lean, formal/lean/OxFunc/Functions/AbsSurface.lean, crates/oxfunc_core/src/functions/abs.rs, crates/oxfunc_core/src/functions/adapters.rs, and tools/abs-probe/*. Empirical suite enforces dual run labels (`default` + `compat_template`) and includes entrypoint mechanism evidence plus floating-point follow-back evidence. Declared thread safety class: `safe_pure`, `arg_preparation_profile=values_only_pre_adapter`, adapter-level `fec_dependency_profile=none`, and surface-level `surface_fec_dependency_profile=ref_only`."
"FDEF-031","XMATCH deterministic-quirks scaffolding","`XMATCH` shall be formalized and empirically characterized across mode defaults, search/match variants, coercion, and error propagation to confirm deterministic/nonvolatile classification and current-phase semantic closure for the tracked reference baseline.","provisional","TBD-SPEC-XMATCH-001;W7-STR-BL-20260305;W6-XMATCH-SEED-20260308;W6-XMATCH-BL-20260308;W6-XMATCH-EXP-20260310","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FL-012","yes","ref_only","cap_reference_resolution","W6 is now `function-phase-complete` for the current implementation phase. Linked artifacts and empirical dual-run replay evidence include docs/function-lane/FUNCTION_SLICE_XMATCH_CONTRACT_PRELIM.md, docs/function-lane/XMATCH_EXECUTION_RECORD.md, docs/function-lane/XMATCH_SCENARIO_MANIFEST_SEED.csv, docs/function-lane/XMATCH_PROBE_RUNTIME_REQUIREMENTS.md, docs/function-lane/LOOKUP_XLL_BRIDGE_SCENARIO_MANIFEST_SEED.csv, tools/xmatch-probe/*, tools/xll-addin/run-lookup-xll-bridge-suite.ps1, formal/lean/OxFunc/Functions/Xmatch.lean, formal/lean/OxFunc/Functions/XmatchSurface.lean, crates/oxfunc_core/src/functions/xmatch.rs, crates/oxfunc_core/src/functions/xmatch_surface.rs, and correlation row FUNC.XMATCH. Blank-vs-empty lookup behavior, wildcard escaping, binary duplicate selection, selected unsorted binary invalid-result lanes, and array-constant XLL parity are now pinned for the current reference baseline; broader locale/version replay remains orthogonal validation-phase work."
"FDEF-032","String normalization and comparison characterization","Function/value policy shall explicitly characterize Excel string comparison, normalization, limits, and control/unicode handling across formula, cell, reference, and persistence boundaries.","provisional","W7-STR-BL-20260305","XLS-CF-TV-005;XLS-CF-TV-007;XLS-CF-FN-001;XLS-CF-FN-002","yes","composite","cap_locale_parse_format;cap_feature_gate;cap_reference_resolution","Baseline closure recorded in STRING_EXECUTION_RECORD.md and STRING_NORMALIZATION_AND_COMPARISON_POLICY_MAP.md with reproducible scenarios in STRING_SCENARIO_MANIFEST_SEED.csv and tools/string-probe/run-string-excel-baseline.ps1. Promotion beyond provisional requires multi-build/compat/locale replay."
"FDEF-033","Function thread safety classification","Function definitions shall declare thread safety class (`safe_pure`, `host_serialized`, `not_thread_safe`) and bind it to reproducible verification evidence.","provisional","TBD-SPEC-THREAD-001;POL-TUX1000-001;W5-ABS-BL-20260308","XLS-CF-FN-001;XLS-CF-FN-007;XLS-CF-VP-003","yes","composite","cap_feature_gate","Axis added to function contracts and executable metadata (Rust/Lean) for PI/ABS seed slices; broader rollout pending."
"FDEF-034","Layered adapter decomposition","Function definitions shall separate kernel semantics, coercion/lift adapter policy, and argument-preparation/dereference policy with explicit profile fields and dual-level FEC dependency declaration.","provisional","TBD-SPEC-ADAPTER-001;W4-COERCE-BL-20260307;W5-ABS-BL-20260308","XLS-CF-FN-001;XLS-CF-TV-007;XLS-CF-TV-008","yes","composite","cap_reference_resolution;cap_feature_gate","Preliminary model documented in docs/function-lane/FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md and applied to ABS with values-only adapter profile; aggregate/reference-sensitive families remain follow-on."
"FDEF-035","W10 ten-function mixed seam scaffolding packet","A ten-function mixed packet (`SUM`,`IF`,`INDEX`,`MATCH`,`ISNUMBER`,`NOW`,`XLOOKUP`,`INDIRECT`,`SEQUENCE`,`OP_ADD`) shall maintain explicit layered profiles, runtime/formal artifact pairing, and replayable scenario manifests while remaining open until each function reaches full Excel semantics.","provisional","W10-TENMIX-SEED-20260308;W10-LOOKUP-XLL-20260310;W10-CLOSEOUT-20260311","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007;XLS-CF-TV-007;XLS-CF-TV-008","yes","composite","cap_reference_resolution;cap_time_provider;cap_caller_context;cap_feature_gate","W10 is now function-phase-complete across all ten functions for the current reference baseline. The `2026-03-11` closeout pinned INDEX omitted row/column defaults and same-sheet multi-area `area_num`, INDIRECT explicit-blank `a1_style` behavior plus whole-axis references, and SEQUENCE omitted-argument defaults with payload materialization. Remaining limits are external XLL verification-seam constraints, tracked separately in docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md."
"FDEF-036","XLL registration flag evidence-first mapping","XLL registration modifiers (`!`,`$`,`#`) shall be mapped from function profiles only after reproducible positive/control evidence for volatile/thread-safe/macro-type behavior.","provisional","W9-XLL-BL-20260308;W11-XLL-FLAGS-BL-20260309","XLS-CF-FN-007;XLS-CF-FN-010;XLS-CF-VP-003","yes","composite","cap_reference_resolution;cap_time_provider;cap_caller_context;cap_feature_gate","W11 introduces an evidence-first lane (`docs/function-lane/XLL_REGISTRATION_FLAG_EVIDENCE_PLAN.md`) with runtime-only alias probes; profile-derived mapping in `xll_export_specs` remains intentionally deferred until volatile/thread-safe/macro evidence gates close."
"FDEF-037","W12 moderate function expansion packet","A moderate fifteen-function packet (`AVERAGE`,`COUNT`,`COUNTA`,`IFERROR`,`ROUND`,`TEXTJOIN`,`TODAY`,`RAND`,`OFFSET`,`CELL`,`AND`,`CLEAN`,`DATE`,`EXACT`,`HSTACK`) shall maintain explicit profile rows, runtime/formal pairing, bounded scenario manifests, and a pre-implementation `CELL` probe before promotion.","provisional","W12-CELL-PRE-20260309;W12-MODERATE-BL-20260309","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007;XLS-CF-TV-007;XLS-CF-TV-008","yes","composite","cap_reference_resolution;cap_time_provider;cap_random_provider;cap_caller_context;cap_feature_gate","W12 closure records fifteen new contract slices plus Rust/Lean/runtime/test artifacts, a bounded `CELL` preprobe, and dual-run Excel replay tooling in docs/function-lane/W12_EXECUTION_RECORD.md and tools/w12-probe/*. Volatile and caller-context follow-back scenarios are captured for W11 mapping readiness while registration-flag mapping itself remains deferred."


"FDEF-038","W13 deceptively simple boundary-function packet and local locale-format seam","The W13 packet (`SIN`,`ASIN`,`N`,`T`,`TYPE`,`VALUE`,`ROW`,`COLUMN`,`TEXT`,`DOLLAR`,`FIXED`) shall either close individual functions honestly or make their seam blockers explicit; for the locale-sensitive subset, OxFunc shall maintain an explicit Rust/Lean locale-format seam with grounded host-profile evidence rather than ad hoc per-function formatting logic.","provisional","W13-NONLOCALE-BL-20260314;W13-LOCALE-SHIM-20260314;W9-XLL-GETINFO-20260314","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007;XLS-CF-FN-007","yes","composite","cap_locale_parse_format;cap_reference_resolution;cap_caller_context","W13 is now packet-complete for the current reference baseline. The non-locale closure pinned numeric-text admission and domain policy (`SIN`/`ASIN`), explicit blank single-cell classification (`N`/`T`/`TYPE`), and caller-context plus one-dimensional spill behavior (`ROW`/`COLUMN`). The locale-sensitive subset closes on top of the selected split parse/render seam (`LocaleValueParser` + `FormatCodeEngine`) with local `en-US` and `current_excel_host` profiles, machine-readable manifests, Rust/Lean substrate artifacts, and tester-XLL `GET.*` wrappers. Broader locale/format-language and alternate-version sweeps remain orthogonal validation work."
"FDEF-039","Spill-anchor reference operator","`OP_SPILL_REF` shall be modeled as a real operator-function that preserves spill-anchor reference identity distinctly from plain references and array payloads.","provisional","CO4-015;P2-FML-008;W14-SPILL-REF-20260314","XLS-CF-FL-005;XLS-CF-FN-001;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution;cap_feature_gate","W14 reference-family prework now makes spill-anchor formation explicit in Rust/Lean/docs via `crates/oxfunc_core/src/functions/op_spill_ref.rs`, `formal/lean/OxFunc/Functions/SpillRef.lean`, and `docs/function-lane/FUNCTION_SLICE_OP_SPILL_REF_CONTRACT_PRELIM.md`. Spill existence/materialization remains a downstream resolver/host concern rather than an operator-formation concern."
"FDEF-040","CELL and INFO typed host-query seam","`CELL` and `INFO` shall be modeled as OxFunc-owned query-semantics over typed FEC host-query facilities rather than as pure local kernels or arbitrary evaluator callbacks.","provisional","W12-CELL-PRE-20260309;W9-XLL-GETINFO-20260314;W15-INFO-PRE-20260315;W15-CELL-HOST-PRE-20260315;W15-XLL-BRIDGE-20260315","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007;XLS-CF-TV-007","yes","composite","cap_reference_resolution;cap_caller_context;cap_workbook_info;cap_application_info;cap_environment_info","W15 now has typed seam/runtime/formal/evidence closure for the admitted current-baseline `CELL` / `INFO` slice, including dual-run workbook replay and generated XLL bridge parity, and the cross-repo handoff `HO-FN-002` is acknowledged on both repo ledgers."
"FDEF-041","Criteria-family mismatched-shape policy","The criteria family shall distinguish top-left anchoring of an explicit mismatched target range in `SUMIF` and `AVERAGEIF` from the exact-shape policy used by `COUNTIFS`, `SUMIFS`, `AVERAGEIFS`, `MAXIFS`, and `MINIFS` on the current baseline.","provisional","W16-B51-CRITERIA-20260316;W22-CRITERIA-SHAPE-20260318;W52-SUMIF-BL-20260326","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007;XLS-CF-TV-008","yes","ref_only","cap_reference_resolution","`SUMIF` and `AVERAGEIF` anchor from the top-left of an explicit A1-style `sum_range` / `average_range`, while the `*IFS` members remain exact-shape and return `#VALUE!` on equivalent mismatch lanes. `SUMIF` omitted `sum_range` and `AVERAGEIF` omitted `average_range` both use the criteria range directly. No criteria-family-specific XLL seam limitation is currently known for the admitted slice."
"FDEF-042","SWITCH deterministic branch-selection policy","`SWITCH` shall be modeled as a deterministic pure branch-selection function with typed candidate comparison, left-to-right first-match selection, lazy result forcing, optional default, and `#N/A` on unmatched calls without default.","provisional","W16-BATCH49-SWITCH-20260316;W24-B01-SWITCH-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","none","cap_reference_resolution","The current baseline is case-insensitive for text candidates, does not match numeric text to numeric values, propagates a selected result error, and does not force later result branches after an earlier match."
"FDEF-043","Date-value family admitted host-profile text parsing","`DATEVALUE` and `TIMEVALUE` shall declare their admitted locale-profile text subset explicitly, while `DAYS360` and `DATEDIF` preserve the current-baseline serial and day-count quirks under pure deterministic semantics.","provisional","W16-BATCH48-DATEVALUE-20260316;W24-B02-DATEVALUE-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007;XLS-CF-TV-008","yes","composite","cap_locale_parse_format;cap_reference_resolution","The current admitted slice is the empirically pinned `en-US` host-like profile: ISO date text, `d-MMM-yyyy`, optional trailing `h:mm[:ss] [AM|PM]`, and pure time text. Slash-date text remains rejected in this slice; `DATEDIF(\"MD\")` quirks are preserved exactly as observed."
"FDEF-044","Text delimiter family scalar baseline","`TEXTAFTER` and `TEXTBEFORE` shall preserve the current-baseline scalar delimiter semantics, including signed `instance_num`, empty-delimiter polarity, explicit `if_not_found`, bounded binary flags, and current observed ASCII-only case-insensitive matching.","provisional","W16-BATCH61-TEXT-DELIM-20260316;W24-B03-TEXT-DELIM-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted current-baseline slice is scalar and values-only at the adapter seam. `match_mode` and `match_end` are bounded to binary flags, no-match without fallback yields `#N/A`, and broader locale/Unicode collation questions remain outside this closure slice."
"FDEF-045","Array text split family admitted array-render and scalar split witness baseline","`ARRAYTOTEXT` and `TEXTSPLIT` shall preserve the current-baseline concise/strict array rendering and the admitted scalar-delimiter split semantics evidenced through scalar `ARRAYTOTEXT(TEXTSPLIT(...),1)` witnesses.","provisional","W16-BATCH67-ARRAY-TEXT-SPLIT-20260316;W24-B04-ARRAY-TEXT-SPLIT-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers `ARRAYTOTEXT` concise/strict rendering, `TEXTSPLIT` row/column delimiters, multi-delimiter arrays, `ignore_empty`, ASCII-only case-insensitive `match_mode`, default `#N/A` padding, and explicit `pad_with`. Broader spill-host publication questions remain outside this closure slice."
"FDEF-046","Confidence/test helper family survivor-policy baseline","`CONFIDENCE.T` and `Z.TEST` shall preserve the current-baseline scalar confidence lane and the admitted `Z.TEST` survivor policy, including non-numeric survivor skipping and error propagation from the sample array.","provisional","W16-BATCH62-CONFIDENCE-TEST-20260316;W24-B05-CONFIDENCE-TEST-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","composite","cap_reference_resolution","The admitted slice covers scalar `CONFIDENCE.T`, `Z.TEST` with supplied or inferred sigma, survivor ignoring for text/logical/blank entries, and propagation of an error survivor from the sample array."
"FDEF-047","Special-distribution family admitted numeric baseline","`ERF`, `ERF.PRECISE`, `ERFC`, `ERFC.PRECISE`, `GAMMA`, `GAMMALN`, `GAMMALN.PRECISE`, `WEIBULL`, and `WEIBULL.DIST` shall preserve the admitted current-baseline numeric and domain semantics, including the zero-density `WEIBULL.DIST` rule at `x = 0`.","provisional","W16-BATCH54-SPECIAL-DIST-20260316;W24-B06-SPECIAL-DIST-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers ERF interval behavior, gamma/gammaln domain and overflow lanes, and `WEIBULL`/`WEIBULL.DIST` cumulative-density parity with `WEIBULL.DIST(x=0,...,FALSE) -> 0` across the pinned alpha lanes."
"FDEF-048","Statistical test family current-baseline reshape and survivor policy","`CHISQ.TEST`, `CHITEST`, `F.TEST`, `FTEST`, `T.TEST`, `TTEST`, and `ZTEST` shall preserve the admitted current-baseline statistical-test semantics, including `CHISQ.TEST` equal-cardinality reshape by first-argument layout and the mixed-survivor policies on the sample-array families.","provisional","W16-BATCH72-TEST-ALIASES-20260316;W16-BATCH78-STAT-TESTS-20260316;W24-B07-STAT-TESTS-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers direct modern and alias names accepted on the current baseline, `CHISQ.TEST` / `CHITEST` equal-cardinality reshape, `F.TEST` / `FTEST` survivor ignoring for text/logical/blank array entries with error propagation, `T.TEST` / `TTEST` paired and sample modes with domain checks, and `ZTEST` delegation to `Z.TEST`."
"FDEF-049","Lookup/probability/frequency family admitted numeric baseline","`LOOKUP`, `FREQUENCY`, `PROB`, and `MODE.MULT` shall preserve the admitted current-baseline numeric slice, including the array-form `LOOKUP` heuristic, vertical-array witnesses for `FREQUENCY` and `MODE.MULT`, and the `PROB` non-unit-sum `#NUM!` rule.","provisional","W16-BATCH77-LOOKUP-PROB-FREQUENCY-20260316;W24-B08-LOOKUP-PROB-FREQ-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers ascending approximate `LOOKUP`, `FREQUENCY` numeric counts, strict discrete `PROB`, and vertical sorted `MODE.MULT`, while broader mixed-type and spill-host nuances remain outside this packet."
"FDEF-050","Regression/forecast family admitted multivariate raw-result baseline","`GROWTH`, `TREND`, `LINEST`, and `LOGEST` shall preserve the admitted current-baseline multivariate raw-result slice, including row-oriented multivariate `new_x`, single-predictor matrix-shape preservation, and trailing intercept/base cells even when `const=FALSE`.","provisional","W16-BATCH66-REGRESSION-FORECAST-20260316;W24-B09-REGRESSION-FORECAST-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers multivariate numeric `known_x`, scalar/vector/matrix `new_x` for single-predictor cases, multivariate row-oriented prediction, raw `LINEST`/`LOGEST` coefficient rows with reverse predictor order, and strict positive-domain rejection for the exponential members. Full `stats=TRUE` blocks and rank-deficient-design policy remain outside this packet."
"FDEF-051","Regex trio admitted current-baseline pure subset","`REGEXEXTRACT`, `REGEXREPLACE`, and `REGEXTEST` shall preserve the admitted current-baseline pure regex subset, including shorthand classes like `\\d`, bounded occurrence handling, and the current ASCII-only case-sensitivity flag semantics.","provisional","W16-BATCH75-NUMBER-REGEX-TRANSLATE-20260316;W24-B10-REGEX-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","none","cap_reference_resolution","The admitted slice covers literals, `.`, character classes, ASCII-aware ranges, `\\d`/`\\w`/`\\s`, postfix quantifiers, first-match extraction, bounded nth replacement, and logical test results. Richer Excel regex syntax remains outside this packet."
"FDEF-052","Financial time-value family admitted scalar and sequence baseline","`PV`, `FV`, `PMT`, `NPER`, `NPV`, `RATE`, `IPMT`, `PPMT`, `ISPMT`, `MIRR`, `FVSCHEDULE`, `PDURATION`, `RRI`, `NOMINAL`, and `EFFECT` shall preserve the admitted current-baseline scalar and numeric-sequence time-value slice, including the corrected `ISPMT` period-index rule.","provisional","W16-BATCH55-FINANCIAL-TIME-VALUE-20260316;W24-B11-FINANCIAL-TIME-VALUE-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers scalar annuity identities, the seeded `RATE` inversion lane, numeric cashflow/schedule vectors for `NPV`/`MIRR`/`FVSCHEDULE`, and the observed `ISPMT` linear schedule behavior where period `1` yields `-75` and period `0` yields `-100` for `(0.1,4,1000)`-style lanes."
"FDEF-053","Cashflow rate family admitted numeric vector baseline","`IRR`, `XNPV`, and `XIRR` shall preserve the admitted current-baseline numeric cashflow/date-vector slice, including sign-change rejection, date-vector shape checks, and pre-anchor-date `#NUM!` rejection on the irregular-date lanes.","provisional","W16-BATCH71-CASHFLOW-RATE-20260316;W24-B12-CASHFLOW-RATE-20260318;W29-FINANCE-BENCHMARK-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers `IRR` with optional scalar guess, `XNPV` with scalar rate plus numeric cashflow/date vectors, and `XIRR` with numeric cashflow/date vectors plus optional guess. Dates are truncated Excel serials and discounting is anchored at the first supplied date. `W29` reopened direct Excel parity for negative-rate/root-finding `XNPV` / `XIRR` lanes; successor repair ownership now sits in `W032`."
"FDEF-054","Coupon family admitted regular-schedule baseline","`COUPDAYBS`, `COUPDAYS`, `COUPDAYSNC`, `COUPNCD`, `COUPNUM`, and `COUPPCD` shall preserve the admitted current-baseline regular coupon-schedule slice, including basis-specific period sizing, quarterly end-of-month stepping, serial-`0` date admission, and settlement-on-coupon-date period advance behavior.","provisional","W16-BATCH69-COUPON-20260316;W24-B13-COUPON-20260318;W29-FINANCE-BENCHMARK-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers the 1900 date system, frequency values `1/2/4`, basis `0-4`, regular schedules stepped backward from maturity, serial-`0` clipping for early-date day/date lanes, and `COUPNUM` returning `#NUM!` before the first positive coupon date. `W29` reopened direct Excel parity for a leap-year actual/actual `COUPDAYS` lane; successor repair ownership now sits in `W032`."
"FDEF-055","AMOR depreciation family admitted scalar baseline","`AMORDEGRC` and `AMORLINC` shall preserve the admitted current-baseline scalar depreciation slice, including the support-example lanes, basis-specific first-period depreciation, and the current fractional-period normalization rules.","provisional","W16-BATCH81-AMOR-DEPRECIATION-20260316;W24-B14-AMOR-DEPRECIATION-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","none","cap_reference_resolution","The admitted slice covers scalar-only 1900-date-system arguments, bases `0/1/3/4`, `AMORLINC` straight-line first-period prorating, and `AMORDEGRC` coefficient/rounding behavior matching the replayed support examples."
"FDEF-056","Misc ordinary conversion triad baseline","`BAHTTEXT`, `CONVERT`, and `PERCENTOF` shall preserve the admitted current-baseline ordinary slice, while `EUROCONVERT` and `RANDARRAY` are explicitly excluded from this closure row because native replay showed they are not ordinary current-host worksheet surfaces on the reference baseline.","provisional","W16-BATCH82-MISC-CONVERSION-20260316;W24-B15-MISC-ORDINARY-CONVERSION-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","composite","cap_reference_resolution","The admitted slice covers Thai-script `BAHTTEXT`, the bounded `CONVERT` catalog already wired in core, and the scalar-first `PERCENTOF` ratio rule. `EUROCONVERT` and `RANDARRAY` moved to `W025` after native replay returned `#NAME?` on the current host baseline."
"FDEF-057","Bond core family direct Excel parity baseline","`ACCRINT`, `ACCRINTM`, `DURATION`, `MDURATION`, `PRICE`, `PRICEMAT`, `YIELD`, `YIELDDISC`, and `YIELDMAT` shall preserve the admitted current-baseline scalar bond-core slice, including the repaired Excel-style `DaysInYear(issue,settlement)` denominator on the basis-`1` maturity-security lane.","provisional","W27-BOND-ODD-BOND-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers the 1900 date system, basis `0..4`, frequency `1/2/4`, the regular coupon schedule used by `PRICE` / `YIELD` / `DURATION` / `MDURATION`, and the direct maturity-security algebra used by `PRICEMAT` / `YIELDMAT`. `W27` replaces the older bounded year-fraction model with direct Excel-valued parity on the basis-`1` blocker lane."
"FDEF-058","Odd bond family direct Excel parity baseline","`ODDFPRICE`, `ODDFYIELD`, `ODDLPRICE`, and `ODDLYIELD` shall preserve the admitted current-baseline scalar odd-bond slice, including the repaired odd-last normalized quasi-coupon accumulation and US 30/360 modify-both-dates hack.","provisional","W27-BOND-ODD-BOND-20260318","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","none","cap_reference_resolution","The admitted slice covers the current short odd-first packet lanes and the repaired odd-last packet lanes. `W27` replaces the older odd-last discounted-boundary model with direct Excel-valued parity on `ODDLPRICE` / `ODDLYIELD`."
"FDEF-059","Information predicates admitted current-baseline split","`ISBLANK`, `ISERR`, `ISERROR`, `ISLOGICAL`, `ISNA`, `ISNONTEXT`, `ISODD`, `ISREF`, and `ISTEXT` shall preserve the admitted current-baseline worksheet split between values-only predicates and the reference-visible `ISREF` lane.","provisional","W33-INFO-FORECAST-20260319","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","composite","cap_reference_resolution","The admitted slice covers true blank vs empty-string distinction, the `ISERR` / `ISERROR` / `ISNA` error split, `ISODD` numeric-text acceptance with logical rejection, and `ISREF` truth on direct and reference-returning expressions without dereference."
"FDEF-060","Forecast compatibility pair admitted current-baseline scalar/vector slice","`FORECAST` and `FORECAST.LINEAR` shall preserve the admitted current-baseline scalar/vector linear-prediction slice, including identical observed behavior on seeded lanes and `#N/A` on mismatched `known_y` / `known_x` lengths.","provisional","W33-INFO-FORECAST-20260319","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","ref_only","cap_reference_resolution","The admitted slice covers scalar `x`, row/column numeric vectors for `known_y` / `known_x`, direct reference-fed parity with array-literal lanes, and the current compatibility position that `FORECAST` is a compatibility surface with no observed divergence from `FORECAST.LINEAR` on the seeded baseline."
"FDEF-061","Reference metadata and formula visibility admitted callback baseline","`ADDRESS`, `AREAS`, `FORMULATEXT`, `SHEET`, and `SHEETS` shall preserve the admitted current-baseline reference-metadata slice, with `ADDRESS` and `AREAS` remaining OxFunc-local once args/ref shape are admitted and `FORMULATEXT` / `SHEET` / `SHEETS` using the typed host callback surface for stored formula text and sheet topology truth.","provisional","W40-REFMETA-BL-20260321","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007;XLS-CF-TV-007","yes","composite","cap_reference_resolution;cap_caller_context;cap_workbook_info","The admitted slice covers `ADDRESS` absolute/A1/R1C1 rendering with explicit sheet text, `AREAS` multi-area cardinality, `FORMULATEXT` plain-value `#N/A`, `SHEET` current/reference/text sheet identity, and `SHEETS` workbook/single-sheet/3D-span counting. The exact first-pass callback surface is `query_formula_text(reference)`, `query_sheet_index(CurrentSheet|Reference|SheetNameText)`, and `query_sheet_count(Workbook|Reference)`."
"FDEF-062","ISFORMULA admitted typed host-query baseline","`ISFORMULA` shall preserve the admitted current-baseline reference-only semantics, where the operand must remain a visible reference, the host owns the truth of whether the referenced cell contains a formula, and non-reference operands project `#VALUE!`.","provisional","W23-ISF-BL-20260321","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007","yes","composite","cap_reference_resolution;cap_formula_metadata","The admitted slice covers formula cells, plain-value cells, and formulas returning text. The pinned callback surface is `query_cell_info(CellInfoQuery::IsFormula, Some(reference))`, and the current XLL host-info bridge already supports this query."
"FDEF-063","SUBTOTAL and AGGREGATE admitted row-visibility reference-form baseline","`SUBTOTAL` and reference-form `AGGREGATE` shall preserve the admitted current-baseline row-visibility semantics, using a typed per-cell aggregate-reference context to split nested aggregate treatment, manual-hidden rows, filtered rows, and error suppression.","provisional","W23-STA-BL-20260321","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007;XLS-CF-TV-007","yes","composite","cap_reference_resolution;cap_row_visibility_context","The pinned callback surface is `query_aggregate_reference_context(reference) -> AggregateReferenceContext`. `SUBTOTAL` always ignores filtered rows and nested aggregates, `101..111` also ignore manually hidden rows, and reference-form `AGGREGATE` options `0..3` ignore nested aggregates while options `4..7` keep nested aggregate values. Full XLL end-to-end bridge parity remains a documented seam limitation rather than a function-semantic gap."
"FDEF-064","Width-conversion functions admitted host/profile baseline","`ASC`, `DBCS`, and `JIS` shall preserve the admitted current-baseline host/profile split, where the active width-conversion behavior is supplied as a typed host/profile mode and OxFunc owns the actual UTF-16 transform once that mode is known.","provisional","W34-WIDTH-CONV-20260321","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007","yes","composite","cap_reference_resolution;cap_width_conversion_profile","The current baseline is `ASC -> pass-through`, `DBCS -> pass-through`, `JIS -> unavailable/#NAME?`. The pinned callback surface is `query_width_conversion_mode(function) -> WidthConversionMode`, with modes `PassThrough`, `NarrowBasicWidthAndKana`, `WidenBasicWidthAndKana`, and defensive `Unavailable`."
"FDEF-065","NUMBERVALUE admitted locale-default baseline","`NUMBERVALUE` shall preserve the admitted current-baseline split between explicit-separator pure parsing and omitted-default locale/profile parsing, with omitted separator defaults supplied from the active locale profile.","provisional","W35-NUMBERVALUE-LOCALE-20260321","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-TV-007","yes","locale_profile","cap_reference_resolution;cap_locale_profile","The current baseline rejects `NUMBERVALUE(""1,234.5%"")` under current-host defaults while `NUMBERVALUE(""1,234.5%"",""."","","")` succeeds. The pinned seam is `LocaleFormatContext.profile.decimal_separator` and `.thousands_separator` for omitted-default lanes only."
"FDEF-066","TRANSLATE provider-language seam baseline","`TRANSLATE` shall preserve the characterized provider-language split between local same-language passthrough and provider-bound cross-language translation, with actual translation coming from a typed provider request/result seam above OxFunc.","provisional","W36-TRANSLATE-PROVIDER-20260321","XLS-CF-FN-001;XLS-CF-FN-002;XLS-CF-FN-007","yes","external_provider","cap_reference_resolution;cap_provider_language","The pinned seam is `query_translate(TranslateRequest) -> TranslateProviderResult`. The characterized baseline keeps `TRANSLATE(""hola"",""es"",""es"") -> ""hola""` local, while `TRANSLATE(""hello"",""en"",""es"") -> #BUSY!` is provider-bound. `W036` owns this seam baseline; `W050` now owns the current-version deferment."
```

## Source: `OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`

# Excel Function Definition Preliminary Spec

## 1. Purpose
Define a preliminary, implementation-facing frame for Excel worksheet function semantics.

This document is intentionally not final:
1. it captures current decisions and unresolved policy choices,
2. it marks which non-function conformance lanes depend on these choices,
3. it prepares structured interactive review.

## 2. Scope
In scope:
1. Function semantic classes (pure, volatile, non-deterministic, host-interactive, external-source).
2. Invalidation/recalc trigger classes and observable consequences.
3. Function evaluation context dependencies (workbook/session/environment).
4. Function-declared Formula Evaluation Context (`FEC`) capability usage.
5. Argument/return coercion and adaptation framing.
6. Value vs extended-value boundary at function call/return interface.
7. UDF surface taxonomy and compatibility posture.
8. Traceability from function-policy rows to `XLS-CF-*` lanes.

Out of scope:
1. Full per-function final semantics table for all 500 functions.
2. Workbook scheduler internals beyond worksheet-observable effects.
3. Full spill layout mechanics (tracked in non-function formula/table lanes).

## 3. Preliminary Function Class System

### 3.1 Class Axes
Each function can carry multiple orthogonal tags:
1. `determinism_class`: `deterministic | pseudo_random | time_dependent | external_event_dependent`.
2. `volatility_class`: `nonvolatile | volatile_full | volatile_contextual | undecided`.
3. `host_interaction_class`: `none | workbook_state | application_state | environment_state | external_provider`.
4. `thread_safety_class`: `safe_pure | host_serialized | not_thread_safe`.
5. `arg_preparation_profile`: `values_only_pre_adapter | refs_visible_in_adapter`.
6. `coercion_lift_profile`: declarative coercion+array-lift adapter profile id.
7. `kernel_signature_class`: `nullary_const | num_to_num | nums_to_num | text_to_text | lookup_match | custom`.
8. `error_policy_class`: `strict_propagate | conditional_mask | branch_selective | custom`.
9. `compat_version_policy`: `stable_across_versions | version_scoped | unknown`.
10. `fec_dependency_profile`: function-adapter-level FEC profile.
11. `surface_fec_dependency_profile`: surface pipeline FEC profile (including pre-adapter preparation).
12. `compile_eval_class`: `const_foldable_when_closed | runtime_ref_dependent | runtime_context_dependent`.

### 3.2 Working Definitions (Preliminary)
1. Volatile:
   - Volatility is invalidation policy, not output determinism.
   - A volatile cell can be scheduled for recalculation without direct dependency input edits.
2. Non-deterministic:
   - Function output can vary between evaluations with same explicit inputs and same workbook state.
   - Non-determinism can arise from time/random/external-source dependencies.
3. Host-interactive:
   - Function semantics depend on host/application/session state not fully represented in cell inputs.
   - Includes platform capability and feature availability boundaries.
4. FEC dependency profile:
   - Declares which host-context facilities are required/allowed by function semantics.
   - See `../../../Foundation/reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md` for capability families and policy framing.
5. Thread safety:
   - `safe_pure`: function evaluation has no shared mutable host state dependence in declared scope.
   - `host_serialized`: function is safe only under host-serialized invocation policy.
   - `not_thread_safe`: function semantics rely on non-thread-safe state and cannot be safely concurrent.
6. Argument preparation profile:
   - `values_only_pre_adapter`: reference dereference/normalization occurs before function adapter.
   - `refs_visible_in_adapter`: function adapter receives reference-bearing arguments and controls dereference behavior.
7. Coercion/lift profile:
   - declarative profile identifier for scalar coercion and array mapping behavior.
8. Kernel signature class:
   - pure function core shape independent from preparation/coercion seam.

9. `volatile_full` vs `volatile_contextual`:
   - retained as unresolved terminology pending interactive policy finalization.
   - current provisional intent:
     - `volatile_full`: always participates in volatile invalidation cycle.
     - `volatile_contextual`: participates only under function/context-specific conditions.

10. Compile-time evaluability class:
   - `const_foldable_when_closed`: expression can be reduced at compile/prepare time when all arguments are constant-closed.
   - `runtime_ref_dependent`: requires runtime value fetch/resolution from references.
   - `runtime_context_dependent`: requires runtime host context (for example caller/time/external context), so deterministic compile-time reduction is not valid.

Illustrative examples (planning):
1. `SIN(4)` and `SIN(2*PI())` can be treated as constant-closed reductions if desired.
2. `SIN(A1)` is runtime reference-dependent.
3. `ROW()` and `NOW()` are runtime context-dependent.

### 3.3 Current High-Risk Class Anchors
1. `NOW`, `TODAY`: volatile + time-dependent.
2. `RAND`, `RANDARRAY`: volatile + pseudo-random.
3. `RTD`: external-event-dependent + external-provider.
4. `INDIRECT`, `OFFSET`: reference-structural functions with high dependency impact.
5. CUBE family (`CUBESET`, `CUBEVALUE`, etc.): external-provider class with deferred depth.

### 3.4 FEC Integration Contract (First Pass)
FEC is now a first-class contract axis for this lane.

Normative planning rule:
1. Every function/operator row shall declare both:
   - function-adapter `fec_dependency_profile`,
   - surface pipeline `surface_fec_dependency_profile`.
2. Where needed, row notes shall include explicit facility tags (for example `cap_reference_resolution`, `cap_time_provider`).
3. A function must not observe undeclared FEC facilities in conformance-positive implementations.

Working profile vocabulary:
1. `none`: no external context dependency.
2. `ref_only`: depends on reference resolution facilities only.
3. `caller_context`: depends on caller position/shape context.
4. `time_provider`: depends on host time/date source.
5. `random_provider`: depends on host pseudo-random source.
6. `external_provider`: depends on external topic/provider lifecycle.
7. `locale_profile`: depends on locale parsing/format profile.
8. `composite`: depends on multiple facility families.

Reference:
1. `../../../Foundation/reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md`.

### 3.4.1 FEC Admission and Failure Classification
1. Function-library execution is permitted only after FEC/F3E admission for the invocation context succeeds.
2. Seam-level admission outcomes (`Applied`/`Rejected*` or equivalent) are boundary-policy signals and must be tracked separately from function semantic result classification.
3. Function semantic conformance claims are evaluated on admitted executions; rejected admissions are only function failures when the function contract explicitly requires admission for that scenario.
4. Empirical manifests for adversarial seam tests must encode expected seam status so intentional rejections are treated as expected behavior.

### 3.5 Layered Function Pipeline Contract
Normative decomposition:
1. Kernel:
   - pure semantic core (`num_to_num`, etc.).
2. Coercion/lift adapter:
   - declarative conversion and array-map behavior.
3. Argument preparation adapter:
   - dereference/normalization policy according to `arg_preparation_profile`.

Design rule:
1. Non-interesting scalar families should default to:
   - `arg_preparation_profile=values_only_pre_adapter`,
   - kernel-focused proofs and tests.
2. Reference-sensitive/aggregate families may require:
   - `arg_preparation_profile=refs_visible_in_adapter`,
   - argument-structure-sensitive semantics (for example direct-scalar vs array-scan behavior in `SUM`-like families).

## 4. Invalidation and Recalc Trigger Model (Preliminary)
Trigger classes:
1. `T-DEP`: dependency graph input changed.
2. `T-VOL`: volatility tick (recalc cycle trigger without direct precedent edit).
3. `T-HOST`: host/application state changed (mode/session/calc-state axes).
4. `T-EXT`: external provider/event update.
5. `T-VERSION`: build/channel/platform behavior drift.

Preliminary rule:
1. Function definition rows must declare expected trigger classes.
2. Conformance probes must isolate trigger class in scenario design where feasible.
3. Workbook compatibility version is part of trigger context when version-scoped behavior applies.

### 4.1 Volatility mechanics (provisional)
1. Working model: volatility leaves a recalculation eligibility marker on the calling cell.
2. Marker semantics are not equivalent to dirty-edit semantics; volatility can still place cell in future recalc candidate set.
3. UDF-triggered volatility controls (`xlfVolatile` / `Application.Volatile`) are treated as policy hooks that can modify marker behavior.
4. Exact mechanics remain an explicit policy topic and empirical target.

### 4.2 RTD lifecycle mechanics (provisional)
1. First RTD evaluation for a topic establishes a topic connection and topic->cell association at worksheet boundary.
2. External topic updates trigger targeted invalidation for associated cells.
3. Recalculation can either refresh topic value (if topic remains referenced) or disconnect lifecycle path (if no longer referenced).
4. This lifecycle is modeled as external invalidation semantics, distinct from volatile invalidation.

## 5. Argument and Return Conversion Boundary
### 5.1 Pre-call argument coercion
1. Arguments can be coerced before function invocation according to function signature and evaluator policy.
2. Coercion source is host/evaluator policy, not function implementation internals.
3. Reference-like arguments may be normalized/dereferenced in either:
   - pre-adapter preparation (`values_only_pre_adapter`), or
   - function adapter (`refs_visible_in_adapter`).

### 5.2 Post-call return adaptation
1. Function return values can be adapted by host after function execution.
2. Array returns can be adapted into dynamic-array anchor representation at the calling cell.
3. Post-evaluation format-hinting is part of this boundary:
   - some functions return a normal semantic value plus a caller-cell formatting hint/action that the engine may apply after evaluation.
   - canonical seed examples are `NOW` and `TODAY` when entered into a cell previously formatted as `General`.
4. Spill-cell virtual value projection is tracked as related but primarily non-function-lane behavior.

### 5.3 Value vs extended value
1. `value`: primary scalar/reference/array semantic payload.
2. `extended_value`: value plus host metadata/structure used at worksheet boundary.
3. Candidate extended-value families to refine:
   - format-hint enriched value,
   - error with detail payload (`source`, `description`, etc.),
   - virtual value relative to anchor.
4. Working distinction:
   - the function semantic result can include a format hint,
   - application of that hint to the worksheet surface is an engine/FEC/F3E responsibility rather than a pure kernel obligation.

### 5.4 Formula admission vs runtime error boundary
1. Function contracts need two separate outcome surfaces:
   - formula-admission surface (parser accepts or rejects formula entry),
   - runtime-evaluation surface (accepted formula returns value/error/array result).
2. Required-argument omission can belong to admission policy for specific shapes (for example canonical seed `SIN()`).
3. Accepted formula calls can still produce runtime coercion/domain errors (for example canonical seeds `SIN("asd")`, `ASIN(2)`).
4. Array-lift behavior must be explicit:
   - mixed-type array inputs (for example `SIN({1,"asd",3})`) need a declared policy for scalar fail-fast vs elementwise result with internal errors.
5. Current public function references are too thin to close this lane alone; empirical evidence remains mandatory for final policy.

## 6. Operator Functions and Syntax Delimiters
1. Evaluable operators are represented as pseudo-functions (`OP_*`) in this lane.
2. Parse-only delimiters are not function rows.
3. Current split:
   - semantic/evaluable example: `OP_UNION_REF`, `OP_IMPLICIT_INTERSECTION`, `OP_SPILL_REF`.
   - parse-only example: `SYN_ARG_SEPARATOR` with locale token profile.
4. Trim references are modeled as one operator family:
   - `OP_TRIM_REF(mode=leading|trailing|both)`.

## 7. UDF Surface Taxonomy (Preliminary)
1. XLL UDFs:
   - registration/lifetime/signature model (SDK + `xlfRegister` + caller context).
   - includes volatility and execution-context flags.
   - working SDK digest for this lane:
     `../../../Foundation/reference/conformance/excel-worksheet-engine/functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`.
2. VBA UDFs:
   - scope rules differ workbook module vs add-in context.
   - COM object interaction and mutation restrictions remain explicit open questions.
3. Automation Add-in UDFs:
   - COM registration and invocation model.
   - lower detail priority for current pass.
4. JavaScript custom functions:
   - async/external and custom data-type implications.
   - extended value returns and custom entity payloads in scope for compatibility classification.
   - post-evaluation format-hint application is a separate surface concern and must not be assumed to be uniformly available across all add-in surfaces.

## 8. Compatibility-Version Semantics
1. Function definitions may be workbook-compatibility-version scoped.
2. Conformance matrix must include compatibility-version axis in addition to build/channel/platform.
3. Version divergence is modeled explicitly; not treated as automatic regression.

## 9. Implicit Intersection (`@`) as Operator Function
1. Canonical semantic id: `OP_IMPLICIT_INTERSECTION`.
2. Legacy/interop alias context:
   - historical preview representation included `SINGLE(...)`,
   - compatibility serialization may include `_xlfn.SINGLE(...)` in pre-DA contexts.
3. Alias forms are compatibility representations, not separate modern semantic operators.
4. Behavioral summary (source-backed, provisional wording):
   - `@` enforces single-value extraction behavior where formulas would otherwise return arrays/ranges in dynamic-array Excel.
   - when opening legacy formulas, Excel can insert `@` to preserve historical implicit-intersection behavior.
   - behavior remains context-dependent on argument/reference shape and surrounding formula context.

## 10. Coupling Into Non-Function Lanes
Function-definition decisions directly affect:
1. `XLS-CF-TV-008` aggregate coercion policy boundary.
2. `XLS-CF-FL-010` argument-gap rationale and parser/evaluator policy.
3. `XLS-CF-FL-005`, `XLS-CF-TB-004`, `XLS-CF-FM-005` where dynamic-array function semantics influence spill expectations.
4. `XLS-CF-FL-006` external-reference behavior interpretation in host/open-state contexts.
5. `XLS-CF-FL-012` function-call admission vs runtime error boundary and array-lift error propagation policy.

## 11. Evidence Model for This Lane
Evidence classes:
1. `spec_anchor`: public formal/help references (`ECS-*`, `REFX-*`).
2. `empirical_anchor`: promoted empirical findings (`EMP-*`).
3. `policy_decision`: explicit interactive decision logs (to be introduced in this lane).

Promotion principle:
1. Function-policy rows remain `draft` or `provisional` until supported by spec and/or empirical anchors with explicit policy decisions.

## 12. Immediate Next Step
1. Use `EXCEL_FUNCTION_DEFINITION_DISCUSSION.md` to resolve open policy decisions.
2. Update `EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv` with confirmed decisions and FEC profile tags.
3. Run language-independent prompt pack for non-interesting-function `.xll` implementation planning and differential validation, including FEC dependency declarations in contract rows.

## Source: `OxFunc/docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`

# Formalization Strategy - Executable Semantic Model

Status: `active`
Owner lane: `OxFunc`

## 1. Purpose
Define how OxFunc should use Lean over time without creating an unmaintainable second production implementation.

This note treats Lean as an executable semantic model and proof substrate, not as a duplicate of every Rust/runtime detail.

## 2. Core Position
The best long-run shape is:
1. Rust is the production implementation.
2. Lean is the canonical executable semantic model for the semantics we understand well enough to state cleanly.
3. Shared contracts, manifests, and correlation rows keep the two aligned.
4. Host/XLL behavior is described as seam contracts and evidence, not reimplemented in full inside Lean.

## 3. What “Function Family” Should Mean
`Function family` should not mean Excel’s presentation categories such as “Lookup”, “Text”, or “Math & Trig” unless those happen to match a real semantic reuse boundary.

For OxFunc formalization work, the useful grouping is a rough semantic partition used for:
1. planning reusable Lean semantic modules
2. assigning each function a single primary semantic home
3. keeping discussions about reuse understandable at a higher level than the full profile matrix

It must not become an informal overlay that re-encodes the formal profile system.

The profile fields already capture orthogonal characteristics such as:
1. `arg_preparation_profile`
2. `coercion_lift_profile`
3. `kernel_signature_class`
4. adapter-level and surface-level FEC dependency profiles
5. volatility and host-interaction classes

Those remain the authoritative multi-axis description.

Function families should instead be used as a rough primary partition:
1. one primary family/home per function
2. chosen for semantic centrality, not for exhaustively encoding every trait
3. supported by cross-cutting notes where necessary, but without assigning the function to several equal-status families

Examples:
1. `MATCH`, `XMATCH`, and `XLOOKUP` belong to a lookup-selection substrate family.
2. `SUM`, `AVERAGE`, `COUNT`, and `COUNTA` belong to an aggregate argument-structure policy family.
3. `AND` belongs more naturally to a logical-fold substrate, even though some of its current Excel-observed lanes share aggregate-style direct-scalar versus array-like distinctions.
4. `INDEX` belongs to a reference-selection family.
5. `OFFSET` belongs to a reference-construction family.
6. `INDIRECT` belongs to a reference-text-interpretation family.
7. `TEXTJOIN`, `EXACT`, and `CLEAN` belong to a text coercion/text normalization family.
8. `NOW`, `TODAY`, and `RAND` belong to a provider/effect-metadata family, even though their value semantics differ.

## 4. Distinction From Profiles
Profiles answer:
1. how the function is prepared
2. what coercion/kernel shape it has
3. what host/FEC capabilities it needs
4. what volatility/host-interaction class it has

Families answer:
1. where the function primarily belongs in the rough semantic map
2. which reusable semantic module should usually own its Lean description
3. which other functions should be discussed with it first when extracting shared semantics

So:
1. profiles are formal, multi-axis, and authoritative
2. families are rough, single-home, and organizational

## 5. Better Term Than “Family”
When needed, prefer:
1. `semantic substrate`
2. `formalization unit`
3. `behavior class`

These are more precise than `family` when a function participates in several reusable semantic structures.

## 6. Layering Rule
Lean should primarily formalize layers `1` and `2`, describe layer `3`, and usually avoid duplicating layer `4`.

1. Pure semantic substrate
   - comparison
   - wildcard semantics
   - duplicate selection
   - approximate/binary selection
   - array/reference selection
   - blank/empty/error distinctions
2. Declared adapter policy
   - defaulting
   - coercion class
   - direct-scalar versus array-like behavior and other declared preparation distinctions
   - admitted preparation assumptions
3. FEC/F3E seam contract
   - what prepared arguments/results may contain
   - what metadata/effects may cross the boundary
4. Host realization
   - XLL bridge behavior
   - COM/entrypoint quirks
   - registration mechanics
   - test-seam limitations

## 7. Executable Semantic Model Rule
Lean should be executable enough to run representative semantic cases for the admitted slice.

That means:
1. a Lean module should compute outcomes for the slice it claims to model
2. empirical examples should be runnable as Lean equalities/examples
3. the model should be observationally aligned with Rust on the admitted semantic surface

This is better than a purely narrative formal note, and better than a second production engine.

## 8. What Not To Mirror
Lean should not try to mirror every Rust helper or infrastructure choice.

Avoid:
1. one-to-one duplication of production module decomposition
2. XLL bridge implementation detail duplication
3. Excel host plumbing recreation
4. reproducing optimization-oriented code paths as if they were semantics

Rust may change structure for engineering reasons. Lean should track semantics.

## 9. How Alignment Should Work
Alignment should be artifact-driven, not memory-driven.

Use these shared anchors:
1. function slice contracts
2. machine-readable correlation rows
3. shared empirical manifests
4. execution records
5. shared terminology for substrate classes and seam assumptions

Expected alignment chain:
1. Excel empirical behavior
2. contract statement
3. Rust behavior
4. Lean executable model

If any one of those moves, the correlation row and/or shared manifest should expose the drift.

### 9A. Replay-Bundle and Evidence-Correlation Binding
Replay appliance bundle projections are an additional alignment carrier, not a replacement semantic authority.

For OxFunc they should bind:
1. source manifest rows,
2. execution-record summaries,
3. evidence ids,
4. correlation-ledger refs,
5. function-contract refs,
6. formal artifact refs,
7. limitation refs,
8. invariant refs.

Replay rule:
1. normalized replay views may summarize or index these bindings,
2. but they must not sever the direct path back to the local contract/evidence/correlation artifacts that define OxFunc meaning.

### 9B. Capability-Level Evidence Path
Replay adapter capability claims and formal maturity claims are related but not identical.

Current OxFunc rollout rule:
1. `cap.C0.ingest_valid` through `cap.C3.explain_valid` may be claimed through bundle-valid packet import, replay, diff, and explain surfaces over manifest-driven empirical packets.
2. `cap.C4.distill_valid` requires a locally proven reduced witness that remains replay-valid under an explicit preservation predicate.
3. `cap.C5.pack_valid` requires pack-policy evidence and witness-lifecycle promotion evidence.

Formal consequence:
1. a replay capability claim does not by itself strengthen a semantic claim,
2. and a reduced witness cannot strengthen a formal or empirical claim unless its lifecycle state and replay-valid status are explicit.

### 9C. Witness Lifecycle Effect On Claims
Witness lifecycle state affects how replay artifacts may be used in OxFunc reasoning.

Rules:
1. `wit.explanatory_only` witnesses may support explanation but do not upgrade semantic closure claims.
2. `wit.quarantined` witnesses may remain indexable and analyzable but are not promotion-grade evidence.
3. `wit.superseded` witnesses remain traceable but should not silently replace the primary source evidence path.
4. only replay-valid retained witnesses may support a future `cap.C4.distill_valid` claim.

## 10. Recommended Formalization Shape
Recommended structure over time:

1. substrate modules
   - reusable semantics shared across multiple functions
   - examples: lookup selection, aggregate argument-structure policy, text coercion, date serial arithmetic, reference selection
2. function binding modules
   - function-specific admission/defaulting/result-adaptation binding into the substrate
3. seam contract modules
   - types and invariants for prepared arguments/results and effect metadata
4. proof layers
   - reusable invariants on the substrate
   - lighter per-function closure lemmas on top

## 11. Proof Strategy
Proof effort should concentrate on reusable invariants, not on reproducing every branch of Rust.

High-value proof targets:
1. determinism
2. duplicate-selection invariants
3. monotonicity or order-selection properties for approximate/binary lookup rules
4. preservation of reference identity under selection
5. separation of blank cell vs empty string vs omitted argument
6. provider/result metadata invariants

Lower-value proof targets:
1. host bridge details
2. registration/export mechanics
3. exact duplication of every production helper

## 12. Suggested Maturity Ladder
For a semantic substrate or function slice:

1. `descriptive`
   - Lean metadata and minimal examples exist
2. `executable`
   - Lean model computes admitted outcomes for representative cases
3. `aligned`
   - shared scenarios show Lean and Rust agree on the admitted slice
4. `proved`
   - reusable invariants are proved for the substrate

Not every function needs to reach `proved` before useful formalization value appears.

## 13. Practical Rule For New Work
For each nontrivial function or substrate:
1. characterize Excel empirically
2. update the contract
3. implement Rust
4. implement Lean at the semantic/adaptor layer
5. align both against shared cases
6. only then call the function `function-phase-complete`

This keeps Lean from lagging silently behind Rust.

## 13A. Completion Consequence
`Function-phase-complete` does not mean every function must have a full standalone duplicate implementation in Lean.

It does mean the formal work required by this strategy for the function's primary semantic substrate and admitted slice has been attended to and aligned.

That may mean:
1. a reusable substrate module exists and computes the relevant semantics
2. the function has the necessary Lean binding into that substrate
3. shared examples or alignment artifacts cover the admitted slice
4. any required invariants or seam-contract notes for that substrate are in place

If that required formal work is still missing or stale, the function is not `function-phase-complete` even when Rust and empirical replay look strong.

## 14. Current Implication For OxFunc
Current lookup-family work is a good example:
1. the useful formalization unit is not the user-facing “lookup category”
2. it is the lookup-selection substrate:
   - comparable formation
   - wildcard matching
   - exact/reverse/approximate/binary selection
   - blank-vs-empty policy
   - return selection/reference preservation
3. `XMATCH`, `MATCH`, and `XLOOKUP` then become function bindings whose primary home is still the lookup family
4. cross-cutting concerns like reference-return or text comparison remain notes on the family boundary, not separate equal-status homes for the same function

The same pattern should apply later to:
1. aggregate argument structure
2. reference-return selection
3. text coercion and text comparison
4. date/time serial handling
5. provider/result-metadata behavior

## 15. Operational Guidance
When deciding whether to introduce a new Lean module, ask:
1. is this a reusable semantic substrate, or only a Rust implementation detail
2. can at least two functions benefit from the abstraction
3. can it be aligned against shared cases
4. is there a stable contract vocabulary for it already

If the answer is mostly no, keep the Lean work local to the function binding for now.

## 16. Seed Rule
Seed rule for OxFunc formalization:

`Lean should model semantic substrates and declared adapter policies, while Rust remains the production implementation. Alignment must be maintained through shared contracts, manifests, and correlation artifacts rather than by attempting a full duplicate engine.`

## Source: `OxFunc/docs/function-lane/FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md`

# Function Adapter Layering Preliminary Spec

Status: `provisional`
Owner lane: `OxFunc`

## 1. Purpose
Define a reusable layered function pipeline that separates:
1. pure function kernels,
2. declarative coercion/array-lift adapters,
3. declarative dereference/argument-preparation adapters.

## 2. Layer Contract
1. Layer K (`kernel`):
   - pure core semantics (for example `num -> num`).
   - no reference-resolution seam access.
2. Layer C (`coercion_lift_adapter`):
   - declarative conversion profile and array-map/error policy.
   - consumes prepared value arguments.
3. Layer P (`arg_preparation_adapter`):
   - dereference/normalization profile.
   - may consume FEC reference capabilities.

Pipeline shape:
1. `surface_args -> P -> prepared_values -> C -> kernel -> result`.

### 2.1 Admission and Failure Accounting
1. Function pipeline execution (`P/C/K`) runs only after FEC/F3E admission for the call context has succeeded.
2. Admission failures (for example token/snapshot/capability rejection at seam level) are boundary outcomes and must not be counted as function semantic failures.
3. Function semantic outcomes and failures are evaluated only on admitted calls.

## 3. Profiles
### 3.1 Argument Preparation Profile
1. `values_only_pre_adapter`:
   - references are resolved before function adapter entry.
   - function adapter sees values only.
2. `refs_visible_in_adapter`:
   - references are visible to function adapter.
   - function controls dereference timing/strategy.

### 3.2 Coercion/Lift Profile
1. `unary_numeric_scalar_only`
2. `unary_numeric_scalar_or_array_elementwise`
3. `aggregate_direct_and_range_dual_policy`
4. `lookup_match_profile`
5. `custom`

### 3.3 Kernel Signature Class
1. `nullary_const`
2. `num_to_num`
3. `nums_to_num`
4. `text_to_text`
5. `lookup_match`
6. `custom`

## 4. ABS Mapping (Reference Example)
1. kernel:
   - `abs_num : Number -> Number`.
2. coercion/lift adapter:
   - `unary_numeric_scalar_or_array_elementwise`.
3. argument preparation:
   - `values_only_pre_adapter`.
4. FEC split:
   - adapter-level `fec_dependency_profile = none`.
   - surface-level `surface_fec_dependency_profile = ref_only`.

## 5. SUM/Family Mapping (Value-Only Aggregate Example)
1. kernel:
   - numeric fold.
2. coercion/lift adapter:
   - aggregate dual policy (direct-scalar vs array-like scan behavior).
3. argument preparation:
   - `values_only_pre_adapter`, with dereference and array expansion happening before the numeric fold sees inputs.

## 6. Large-Sweep Guidance
For broad non-interesting-function rollout:
1. default to `values_only_pre_adapter` where behavior does not depend on source provenance.
2. maximize reusable declarative coercion/lift profiles instead of per-function bespoke adapters.
3. keep kernels minimal and proof-first.

For interesting/reference-sensitive families:
1. use `refs_visible_in_adapter` only when required by observable behavior.
2. require explicit policy rows that say whether the function depends on direct-scalar versus array-like structure, on preserved reference identity, or on both.
3. attach focused empirical lanes that distinguish those observable outcomes.

## 7. Required Tracking Fields
Function contracts should explicitly state:
1. `arg_preparation_profile`
2. `coercion_lift_profile`
3. `kernel_signature_class`
4. `fec_dependency_profile` (adapter level)
5. `surface_fec_dependency_profile` (pipeline level)

## 8. Rust/Lean Coupling Pattern
For each promoted function slice, keep an explicit two-level model:
1. Adapter/kernel level:
   - Rust: adapter/kernel module (`functions::<f>.rs`).
   - Lean: adapter/kernel module (`Functions.<F>.lean`).
2. Surface execution level:
   - Rust: pre-adapter composition path (either `functions::<f>_surface.rs` or a shared declarative runner path from `functions::adapters`).
   - Lean: surface composition module (`Functions.<F>Surface.lean` or equivalent).

Required cross-level linkage:
1. at least one theorem showing surface-prepared path corresponds to adapter path for prepared inputs.
2. at least one runtime test showing surface execution equals adapter execution on prepared-value cases.
3. correlation ledger row must include both modules and both theorem/test inventories.

### 8.1 Declarative Surface Runner Policy
For non-interesting functions with `values_only_pre_adapter` and no custom surface quirks:
1. use shared surface helpers in `crates/oxfunc_core/src/functions/adapters.rs`:
   - `run_values_only_prepared`
   - `map_values_only_prepared`
2. keep function-specific surface wrappers minimal (or inline in the function module) and avoid bespoke pre-adapter boilerplate.
3. reserve dedicated `*_surface.rs` modules for functions that need custom surface behavior:
   - lazy/selective argument evaluation,
   - source-structure-sensitive or reference-identity-sensitive dereference timing,
   - reference-return/caller-context custom paths,
   - other non-standard boundary semantics.
4. decision template:
   - if function behavior fits shared values-only preparation, keep surface in the main function module.
   - if function needs bespoke boundary logic, use a dedicated `*_surface.rs` companion module.

Current adoption baseline (Rust):
1. `ABS` surface wrappers now use shared declarative runner helpers.
2. `ISNUMBER`, `OP_ADD`, `SUM`, `SEQUENCE`, and `INDIRECT` route values-only surface preparation through the shared runner.
3. `XMATCH` remains split (`xmatch.rs` + `xmatch_surface.rs`) because it still needs custom surface behavior.

## 9. Replay Appliance Packet Adapter Role
The Replay appliance packet adapter sits above the `P/C/K` function pipeline.

It does not replace or reinterpret function semantics.
It projects packet-native evidence into Replay bundle form.

Adapter role:
1. preserve source schema ids and source artifact refs for manifests, execution records, evidence rows, correlation rows, invariant notes, and limitation notes,
2. expose packet and row results as normalized replay views,
3. preserve run labels, compatibility descriptors, locale/environment metadata, and verification-surface distinctions,
4. support replay, diff, and explain over those packet witnesses without changing how the underlying function pipeline is defined.

Allowed reduction-unit hierarchy for OxFunc replay rollout:
1. packet,
2. row cluster,
3. row,
4. analysis summary,
5. invariant declaration,
6. limitation marker,
7. sidecar partition.

Replay rule:
1. packet-adapter normalization may emit derived event families for indexing or explanation,
2. but it must never invent a fake internal evaluator event stream merely for cross-lane symmetry.

## 10. Deferred Considerations (Post-W6 XMATCH)
1. Do not promote a new global evaluation-strategy axis yet (`eager_full_scan` vs `selective_probe` remains `to_consider`).
2. Near-term selective behavior should be expressed per function via `refs_visible_in_adapter` and function-owned dereference policy, not as a mandatory cross-function abstraction.
3. If introduced later, selective dereference capability must support reference-subset probing (sub-array/window dereference), not only whole-reference materialization.
4. Non-standard error/coercion behavior should remain function-local until multiple independent functions demonstrate a stable reusable abstraction.
5. Do not assume a generic "lookup function class" for semantic reuse; function-specific quirks remain first-class.
6. Keep counterexample replay loop mandatory when Excel behavior diverges (contract + runtime + formal + evidence + correlation).
7. Keep Q-vs-U side-by-side performance/semantic benching as planned follow-on, lower priority for current closure.

## Source: `OxFunc/docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv`

```csv
"function_name","function_url","category","version_marker","tier","tier_label","interesting","reason_codes","context_note","platform_note","description"
"ABS","https://support.microsoft.com/en-us/office/abs-function-3420200f-5628-4e8c-99da-c99d7c87713c","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the absolute value of a number"
"ACCRINT","https://support.microsoft.com/en-us/office/accrint-function-fe45d089-6722-4fb3-9379-e1f911d8dc74","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the accrued interest for a security that pays periodic interest"
"ACCRINTM","https://support.microsoft.com/en-us/office/accrintm-function-f62f01f9-5754-4cc4-805b-0e70199328a7","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the accrued interest for a security that pays interest at maturity"
"ACOS","https://support.microsoft.com/en-us/office/acos-function-cb73173f-d089-4582-afa1-76e5524b5d5b","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the arccosine of a number"
"ACOSH","https://support.microsoft.com/en-us/office/acosh-function-e3992cc1-103f-4e72-9f04-624b9ef5ebfe","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse hyperbolic cosine of a number"
"ACOT","https://support.microsoft.com/en-us/office/acot-function-dc7e5008-fe6b-402e-bdd6-2eea8383d905","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the arccotangent of a number"
"ACOTH","https://support.microsoft.com/en-us/office/acoth-function-cc49480f-f684-4171-9fc5-73e4e852300f","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic arccotangent of a number"
"ADDRESS","https://support.microsoft.com/en-us/office/address-function-d0c26c0d-3991-446b-8de4-ab46431d4f89","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a reference as text to a single cell in a worksheet"
"AGGREGATE","https://support.microsoft.com/en-us/office/aggregate-function-43b9278e-6aa7-4f17-92b6-e19993fa26df","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns an aggregate in a list or database"
"AMORDEGRC","https://support.microsoft.com/en-us/office/amordegrc-function-a14d0ca1-64a4-42eb-9b3d-b0dededf9e51","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the depreciation for each accounting period by using a depreciation coefficient"
"AMORLINC","https://support.microsoft.com/en-us/office/amorlinc-function-7d417b45-f7f5-4dba-a0a5-3451a81079a8","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the depreciation for each accounting period"
"AND","https://support.microsoft.com/en-us/office/and-function-5f19b2e8-e1df-4408-897a-ce285a19e9d9","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if all of its arguments are TRUE"
"ARABIC","https://support.microsoft.com/en-us/office/arabic-function-9a8da418-c17b-4ef9-a657-9370a30a674f","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a Roman number to Arabic, as a number"
"AREAS","https://support.microsoft.com/en-us/office/areas-function-8392ba32-7a41-43b3-96b0-3695d2ec6152","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of areas in a reference"
"ARRAYTOTEXT","https://support.microsoft.com/en-us/office/arraytotext-function-9cdcad46-2fa5-4c6b-ac92-14e7bc862b8b","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns an array of text values from any specified range"
"ASC","https://support.microsoft.com/en-us/office/asc-function-0b6abf1c-c663-4004-a964-ebc00b723266","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Changes full-width (double-byte) English letters or katakana within a character string to half-width (single-byte) characters"
"ASIN","https://support.microsoft.com/en-us/office/asin-function-81fb95e5-6d6f-48c4-bc45-58f955c6d347","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the arcsine of a number"
"ASINH","https://support.microsoft.com/en-us/office/asinh-function-4e00475a-067a-43cf-926a-765b0249717c","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse hyperbolic sine of a number"
"ATAN","https://support.microsoft.com/en-us/office/atan-function-50746fa8-630a-406b-81d0-4a2aed395543","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the arctangent of a number"
"ATAN2","https://support.microsoft.com/en-us/office/atan2-function-c04592ab-b9e3-4908-b428-c96b3a565033","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the arctangent from x- and y-coordinates"
"ATANH","https://support.microsoft.com/en-us/office/atanh-function-3cd65768-0de7-4f1d-b312-d01c8c930d90","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse hyperbolic tangent of a number"
"AVEDEV","https://support.microsoft.com/en-us/office/avedev-function-58fe8d65-2a84-4dc7-8052-f3f87b5c6639","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the average of the absolute deviations of data points from their mean"
"AVERAGE","https://support.microsoft.com/en-us/office/average-function-047bac88-d466-426c-a32b-8f33eb960cf6","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the average of its arguments"
"AVERAGEA","https://support.microsoft.com/en-us/office/averagea-function-f5f84098-d453-4f4c-bbba-3d2c66356091","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the average of its arguments, including numbers, text, and logical values"
"AVERAGEIF","https://support.microsoft.com/en-us/office/averageif-function-faec8e2e-0dec-4308-af69-f5576d8ac642","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the average (arithmetic mean) of all the cells in a range that meet a given criteria"
"AVERAGEIFS","https://support.microsoft.com/en-us/office/averageifs-function-48910c45-1fc0-4389-a028-f7c5c3001690","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the average (arithmetic mean) of all cells that meet multiple criteria"
"BAHTTEXT","https://support.microsoft.com/en-us/office/bahttext-function-5ba4d0b4-abd3-4325-8d22-7a92d59aab9c","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a number to text, using the ? (baht) currency format"
"BASE","https://support.microsoft.com/en-us/office/base-function-2ef61411-aee9-4f29-a811-1c42456c6342","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a number into a text representation with the given radix (base)"
"BESSELI","https://support.microsoft.com/en-us/office/besseli-function-8d33855c-9a8d-444b-98e0-852267b1c0df","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the modified Bessel function In(x)"
"BESSELJ","https://support.microsoft.com/en-us/office/besselj-function-839cb181-48de-408b-9d80-bd02982d94f7","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Bessel function Jn(x)"
"BESSELK","https://support.microsoft.com/en-us/office/besselk-function-606d11bc-06d3-4d53-9ecb-2803e2b90b70","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the modified Bessel function Kn(x)"
"BESSELY","https://support.microsoft.com/en-us/office/bessely-function-f3a356b3-da89-42c3-8974-2da54d6353a2","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Bessel function Yn(x)"
"BETA.DIST","https://support.microsoft.com/en-us/office/beta-dist-function-11188c9c-780a-42c7-ba43-9ecb5a878d31","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the beta cumulative distribution function"
"BETA.INV","https://support.microsoft.com/en-us/office/beta-inv-function-e84cb8aa-8df0-4cf6-9892-83a341d252eb","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the cumulative distribution function for a specified beta distribution"
"BETADIST","https://support.microsoft.com/en-us/office/betadist-function-49f1b9a9-a5da-470f-8077-5f1730b5fd47","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the beta cumulative distribution function"
"BETAINV","https://support.microsoft.com/en-us/office/betainv-function-8b914ade-b902-43c1-ac9c-c05c54f10d6c","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the cumulative distribution function for a specified beta distribution"
"BIN2DEC","https://support.microsoft.com/en-us/office/bin2dec-function-63905b57-b3a0-453d-99f4-647bb519cd6c","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a binary number to decimal"
"BIN2HEX","https://support.microsoft.com/en-us/office/bin2hex-function-0375e507-f5e5-4077-9af8-28d84f9f41cc","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a binary number to hexadecimal"
"BIN2OCT","https://support.microsoft.com/en-us/office/bin2oct-function-0a4e01ba-ac8d-4158-9b29-16c25c4c23fd","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a binary number to octal"
"BINOM.DIST","https://support.microsoft.com/en-us/office/binom-dist-function-c5ae37b6-f39c-4be2-94c2-509a1480770c","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the individual term binomial distribution probability"
"BINOM.DIST.RANGE","https://support.microsoft.com/en-us/office/binom-dist-range-function-17331329-74c7-4053-bb4c-6653a7421595","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the probability of a trial result using a binomial distribution"
"BINOM.INV","https://support.microsoft.com/en-us/office/binom-inv-function-80a0370c-ada6-49b4-83e7-05a91ba77ac9","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the smallest value for which the cumulative binomial distribution is less than or equal to a criterion value"
"BINOMDIST","https://support.microsoft.com/en-us/office/binomdist-function-506a663e-c4ca-428d-b9a8-05583d68789c","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the individual term binomial distribution probability"
"BITAND","https://support.microsoft.com/en-us/office/bitand-function-8a2be3d7-91c3-4b48-9517-64548008563a","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a 'Bitwise And' of two numbers"
"BITLSHIFT","https://support.microsoft.com/en-us/office/bitlshift-function-c55bb27e-cacd-4c7c-b258-d80861a03c9c","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a value number shifted left by shift_amount bits"
"BITOR","https://support.microsoft.com/en-us/office/bitor-function-f6ead5c8-5b98-4c9e-9053-8ad5234919b2","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a bitwise OR of 2 numbers"
"BITRSHIFT","https://support.microsoft.com/en-us/office/bitrshift-function-274d6996-f42c-4743-abdb-4ff95351222c","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a value number shifted right by shift_amount bits"
"BITXOR","https://support.microsoft.com/en-us/office/bitxor-function-c81306a1-03f9-4e89-85ac-b86c3cba10e4","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a bitwise 'Exclusive Or' of two numbers"
"BYCOL","https://support.microsoft.com/en-us/office/bycol-function-58463999-7de5-49ce-8f38-b7f7a2192bfb","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Applies a LAMBDA to each column and returns an array of the results"
"BYROW","https://support.microsoft.com/en-us/office/byrow-function-2e04c677-78c8-4e6b-8c10-a4602f2602bb","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Applies a LAMBDA to each row and returns an array of the results"
"CALL","https://support.microsoft.com/en-us/office/call-function-32d58445-e646-4ffd-8d5e-b45077a5e995","User defined functions that are installed with add-ins","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calls a procedure in a dynamic link library or code resource"
"CEILING","https://support.microsoft.com/en-us/office/ceiling-function-0a5cd7c8-0720-4f0a-bd2c-c943e510899f","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number to the nearest integer or to the nearest multiple of significance"
"CEILING.MATH","https://support.microsoft.com/en-us/office/ceiling-math-function-80f95d2f-b499-4eee-9f16-f795a8e306c8","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number up, to the nearest integer or to the nearest multiple of significance"
"CEILING.PRECISE","https://support.microsoft.com/en-us/office/ceiling-precise-function-f366a774-527a-4c92-ba49-af0a196e66cb","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number the nearest integer or to the nearest multiple of significance. Regardless of the sign of the number, the number is rounded up."
"CELL","https://support.microsoft.com/en-us/office/cell-function-51bd39a5-f338-4dbe-a33f-955d67c2b2cf","Information functions","","5","critical_interest","true","volatile_or_recalc_sensitive|grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns information about the formatting, location, or contents of a cell"
"CHAR","https://support.microsoft.com/en-us/office/char-function-bbd249c8-b36e-4a91-8017-1c133f9b837a","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the character specified by the code number"
"CHIDIST","https://support.microsoft.com/en-us/office/chidist-function-c90d0fbc-5b56-4f5f-ab57-34af1bf6897e","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the one-tailed probability of the chi-squared distribution"
"CHIINV","https://support.microsoft.com/en-us/office/chiinv-function-cfbea3f6-6e4f-40c9-a87f-20472e0512af","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the one-tailed probability of the chi-squared distribution"
"CHISQ.DIST","https://support.microsoft.com/en-us/office/chisq-dist-function-8486b05e-5c05-4942-a9ea-f6b341518732","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cumulative beta probability density function"
"CHISQ.DIST.RT","https://support.microsoft.com/en-us/office/chisq-dist-rt-function-dc4832e8-ed2b-49ae-8d7c-b28d5804c0f2","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the one-tailed probability of the chi-squared distribution"
"CHISQ.INV","https://support.microsoft.com/en-us/office/chisq-inv-function-400db556-62b3-472d-80b3-254723e7092f","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cumulative beta probability density function"
"CHISQ.INV.RT","https://support.microsoft.com/en-us/office/chisq-inv-rt-function-435b5ed8-98d5-4da6-823f-293e2cbc94fe","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the one-tailed probability of the chi-squared distribution"
"CHISQ.TEST","https://support.microsoft.com/en-us/office/chisq-test-function-2e8a7861-b14a-4985-aa93-fb88de3f260f","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the test for independence"
"CHITEST","https://support.microsoft.com/en-us/office/chitest-function-981ff871-b694-4134-848e-38ec704577ac","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the test for independence"
"CHOOSE","https://support.microsoft.com/en-us/office/choose-function-fc5c184f-cb62-4ec7-a46e-38653b98f5bc","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Chooses a value from a list of values"
"CHOOSECOLS","https://support.microsoft.com/en-us/office/choosecols-function-bf117976-2722-4466-9b9a-1c01ed9aebff","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the specified columns from an array"
"CHOOSEROWS","https://support.microsoft.com/en-us/office/chooserows-function-51ace882-9bab-4a44-9625-7274ef7507a3","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the specified rows from an array"
"CLEAN","https://support.microsoft.com/en-us/office/clean-function-26f3d7c5-475f-4a9c-90e5-4b8ba987ba41","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Removes all nonprintable characters from text"
"CODE","https://support.microsoft.com/en-us/office/code-function-c32b692b-2ed0-4a04-bdd9-75640144b928","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a numeric code for the first character in a text string"
"COLUMN","https://support.microsoft.com/en-us/office/column-function-44e8c754-711c-4df3-9da4-47a55042554b","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the column number of a reference"
"COLUMNS","https://support.microsoft.com/en-us/office/columns-function-4e8e7b4e-e603-43e8-b177-956088fa48ca","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of columns in a reference"
"COMBIN","https://support.microsoft.com/en-us/office/combin-function-12a3f276-0a21-423a-8de6-06990aaf638a","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of combinations for a given number of objects"
"COMBINA","https://support.microsoft.com/en-us/office/combina-function-efb49eaa-4f4c-4cd2-8179-0ddfcf9d035d","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of combinations with repetitions for a given number of items"
"COMPLEX","https://support.microsoft.com/en-us/office/complex-function-f0b8f3a9-51cc-4d6d-86fb-3a9362fa4128","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts real and imaginary coefficients into a complex number"
"CONCAT","https://support.microsoft.com/en-us/office/concat-function-9b1a9a3f-94ff-41af-9736-694cbd6b4ca2","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Combines the text from multiple ranges and/or strings, but it doesn't provide the delimiter or IgnoreEmpty arguments."
"CONCATENATE","https://support.microsoft.com/en-us/office/concatenate-function-8f8ae884-2ca8-4f7a-b093-75d702bea31d","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Joins two or more text strings into one string"
"CONFIDENCE","https://support.microsoft.com/en-us/office/confidence-function-75ccc007-f77c-4343-bc14-673642091ad6","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the confidence interval for a population mean"
"CONFIDENCE.NORM","https://support.microsoft.com/en-us/office/confidence-norm-function-7cec58a6-85bb-488d-91c3-63828d4fbfd4","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the confidence interval for a population mean"
"CONFIDENCE.T","https://support.microsoft.com/en-us/office/confidence-t-function-e8eca395-6c3a-4ba9-9003-79ccc61d3c53","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the confidence interval for a population mean, using a Student's t distribution"
"CONVERT","https://support.microsoft.com/en-us/office/convert-function-d785bef1-808e-4aac-bdcd-666c810f9af2","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a number from one measurement system to another"
"COPILOT","https://support.microsoft.com/en-us/office/copilot-function-5849821b-755d-4030-a38b-9e20be0cbf62","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.",""
"CORREL","https://support.microsoft.com/en-us/office/correl-function-995dcef7-0c0a-4bed-a3fb-239d7b68ca92","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the correlation coefficient between two data sets"
"COS","https://support.microsoft.com/en-us/office/cos-function-0fb808a5-95d6-4553-8148-22aebdce5f05","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cosine of a number"
"COSH","https://support.microsoft.com/en-us/office/cosh-function-e460d426-c471-43e8-9540-a57ff3b70555","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic cosine of a number"
"COT","https://support.microsoft.com/en-us/office/cot-function-c446f34d-6fe4-40dc-84f8-cf59e5f5e31a","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cotangent of an angle"
"COTH","https://support.microsoft.com/en-us/office/coth-function-2e0b4cb6-0ba0-403e-aed4-deaa71b49df5","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic cotangent of a number"
"COUNT","https://support.microsoft.com/en-us/office/count-function-a59cd7fc-b623-4d93-87a4-d23bf411294c","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to count how many numbers are in the list of arguments. You can use COUNTA to count how many values are in the list of arguments."
"COUNTA","https://support.microsoft.com/en-us/office/counta-function-7dc98875-d5c1-46f1-9a82-53f3219e2509","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Counts how many values are in the list of arguments"
"COUNTBLANK","https://support.microsoft.com/en-us/office/countblank-function-6a92d772-675c-4bee-b346-24af6bd3ac22","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Counts the number of blank cells within a range"
"COUNTIF","https://support.microsoft.com/en-us/office/use-the-countif-function-in-microsoft-excel-e0de10c6-f885-4e71-abb4-1f464816df34","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Counts the number of cells within a range that meet the given criteria"
"COUNTIFS","https://support.microsoft.com/en-us/office/countifs-function-dda3dc6e-f74e-4aee-88bc-aa8c2a866842","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to count the number of cells within a range that meet multiple criteria."
"COUPDAYBS","https://support.microsoft.com/en-us/office/coupdaybs-function-eb9a8dfb-2fb2-4c61-8e5d-690b320cf872","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of days from the beginning of the coupon period to the settlement date"
"COUPDAYS","https://support.microsoft.com/en-us/office/coupdays-function-cc64380b-315b-4e7b-950c-b30b0a76f671","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of days in the coupon period that contains the settlement date"
"COUPDAYSNC","https://support.microsoft.com/en-us/office/coupdaysnc-function-5ab3f0b2-029f-4a8b-bb65-47d525eea547","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of days from the settlement date to the next coupon date"
"COUPNCD","https://support.microsoft.com/en-us/office/coupncd-function-fd962fef-506b-4d9d-8590-16df5393691f","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the next coupon date after the settlement date"
"COUPNUM","https://support.microsoft.com/en-us/office/coupnum-function-a90af57b-de53-4969-9c99-dd6139db2522","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of coupons payable between the settlement date and maturity date"
"COUPPCD","https://support.microsoft.com/en-us/office/couppcd-function-2eb50473-6ee9-4052-a206-77a9a385d5b3","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the previous coupon date before the settlement date"
"COVAR","https://support.microsoft.com/en-us/office/covar-function-50479552-2c03-4daf-bd71-a5ab88b2db03","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns covariance, the average of the products of paired deviations"
"COVARIANCE.P","https://support.microsoft.com/en-us/office/covariance-p-function-6f0e1e6d-956d-4e4b-9943-cfef0bf9edfc","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns covariance, the average of the products of paired deviations"
"COVARIANCE.S","https://support.microsoft.com/en-us/office/covariance-s-function-0a539b74-7371-42aa-a18f-1f5320314977","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sample covariance, the average of the products deviations for each data point pair in two data sets"
"CRITBINOM","https://support.microsoft.com/en-us/office/critbinom-function-eb6b871d-796b-4d21-b69b-e4350d5f407b","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the smallest value for which the cumulative binomial distribution is less than or equal to a criterion value"
"CSC","https://support.microsoft.com/en-us/office/csc-function-07379361-219a-4398-8675-07ddc4f135c1","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cosecant of an angle"
"CSCH","https://support.microsoft.com/en-us/office/csch-function-f58f2c22-eb75-4dd6-84f4-a503527f8eeb","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic cosecant of an angle"
"CUBEKPIMEMBER","https://support.microsoft.com/en-us/office/cubekpimember-function-744608bf-2c62-42cd-b67a-a56109f4b03b","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Returns a key performance indicator (KPI) property and displays the KPI name in the cell. A KPI is a quantifiable measurement, such as monthly gross profit or quarterly employee turnover, that is used to monitor an organization's performance."
"CUBEMEMBER","https://support.microsoft.com/en-us/office/cubemember-function-0f6a15b9-2c18-4819-ae89-e1b5c8b398ad","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Returns a member or tuple from the cube. Use to validate that the member or tuple exists in the cube."
"CUBEMEMBERPROPERTY","https://support.microsoft.com/en-us/office/cubememberproperty-function-001e57d6-b35a-49e5-abcd-05ff599e8951","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Returns the value of a member property from the cube. Use to validate that a member name exists within the cube and to return the specified property for this member."
"CUBERANKEDMEMBER","https://support.microsoft.com/en-us/office/cuberankedmember-function-07efecde-e669-4075-b4bf-6b40df2dc4b3","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Returns the nth, or ranked, member in a set. Use to return one or more elements in a set, such as the top sales performer or the top 10 students."
"CUBESET","https://support.microsoft.com/en-us/office/cubeset-function-5b2146bd-62d6-4d04-9d8f-670e993ee1d9","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Defines a calculated set of members or tuples by sending a set expression to the cube on the server, which creates the set, and then returns that set to Microsoft Excel."
"CUBESETCOUNT","https://support.microsoft.com/en-us/office/cubesetcount-function-c4c2a438-c1ff-4061-80fe-982f2d705286","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Returns the number of items in a set."
"CUBEVALUE","https://support.microsoft.com/en-us/office/cubevalue-function-8733da24-26d1-4e34-9b3a-84a8f00dcbe0","Cubes","","4","high_interest","true","cube_context","Used with OLAP/Data Model cube connections and Pivot-based analytics; often includes MDX expressions in arguments. MDX semantics are out-of-scope for this project.","Cube functions depend on cube/data-model connectivity; platform support varies by connector stack and product SKU.","Returns an aggregated value from the cube."
"CUMIPMT","https://support.microsoft.com/en-us/office/cumipmt-function-61067bb0-9016-427d-b95b-1a752af0e606","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cumulative interest paid between two periods"
"CUMPRINC","https://support.microsoft.com/en-us/office/cumprinc-function-94a4516d-bd65-41a1-bc16-053a6af4c04d","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cumulative principal paid on a loan between two periods"
"DATE","https://support.microsoft.com/en-us/office/date-function-e36c0c8c-4104-49da-ab83-82328b832349","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of a particular date"
"DATEDIF","https://support.microsoft.com/en-us/office/datedif-function-25dba1a4-2812-480b-84dd-8b32a451b35c","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates the number of days, months, or years between two dates. This function is useful in formulas where you need to calculate an age."
"DATEVALUE","https://support.microsoft.com/en-us/office/datevalue-function-df8b07d4-7761-4a93-bc33-b7471bbff252","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a date in the form of text to a serial number"
"DAVERAGE","https://support.microsoft.com/en-us/office/daverage-function-a6a2d5ac-4b4b-48cd-a1d8-7b37834e5aee","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the average of selected database entries"
"DAY","https://support.microsoft.com/en-us/office/day-function-8a7d1cbb-6c7d-4ba1-8aea-25c134d03101","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a day of the month"
"DAYS","https://support.microsoft.com/en-us/office/days-function-57740535-d549-4395-8728-0f07bff0b9df","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of days between two dates"
"DAYS360","https://support.microsoft.com/en-us/office/days360-function-b9a509fd-49ef-407e-94df-0cbda5718c2a","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates the number of days between two dates based on a 360-day year"
"DB","https://support.microsoft.com/en-us/office/db-function-354e7d28-5f93-4ff1-8a52-eb4ee549d9d7","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the depreciation of an asset for a specified period by using the fixed-declining balance method"
"DBCS","https://support.microsoft.com/en-us/office/dbcs-function-a4025e73-63d2-4958-9423-21a24794c9e5","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Changes half-width (single-byte) English letters or katakana within a character string to full-width (double-byte) characters"
"DCOUNT","https://support.microsoft.com/en-us/office/dcount-function-c1fc7b93-fb0d-4d8d-97db-8d5f076eaeb1","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Counts the cells that contain numbers in a database"
"DCOUNTA","https://support.microsoft.com/en-us/office/dcounta-function-00232a6d-5a66-4a01-a25b-c1653fda1244","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Counts nonblank cells in a database"
"DDB","https://support.microsoft.com/en-us/office/ddb-function-519a7a37-8772-4c96-85c0-ed2c209717a5","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the depreciation of an asset for a specified period by using the double-declining balance method or some other method that you specify"
"DEC2BIN","https://support.microsoft.com/en-us/office/dec2bin-function-0f63dd0e-5d1a-42d8-b511-5bf5c6d43838","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a decimal number to binary"
"DEC2HEX","https://support.microsoft.com/en-us/office/dec2hex-function-6344ee8b-b6b5-4c6a-a672-f64666704619","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a decimal number to hexadecimal"
"DEC2OCT","https://support.microsoft.com/en-us/office/dec2oct-function-c9d835ca-20b7-40c4-8a9e-d3be351ce00f","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a decimal number to octal"
"DECIMAL","https://support.microsoft.com/en-us/office/decimal-function-ee554665-6176-46ef-82de-0a283658da2e","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a text representation of a number in a given base into a decimal number"
"DEGREES","https://support.microsoft.com/en-us/office/degrees-function-4d6ec4db-e694-4b94-ace0-1cc3f61f9ba1","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts radians to degrees"
"DELTA","https://support.microsoft.com/en-us/office/delta-function-2f763672-c959-4e07-ac33-fe03220ba432","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Tests whether two values are equal"
"DETECTLANGUAGE","https://support.microsoft.com/en-us/office/detectlanguage-function-0748e285-1912-4d24-b735-57d18142fa3b","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Identifies the language of a specified text"
"DEVSQ","https://support.microsoft.com/en-us/office/devsq-function-8b739616-8376-4df5-8bd0-cfe0a6caf444","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of squares of deviations"
"DGET","https://support.microsoft.com/en-us/office/dget-function-455568bf-4eef-45f7-90f0-ec250d00892e","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Extracts from a database a single record that matches the specified criteria"
"DISC","https://support.microsoft.com/en-us/office/disc-function-71fce9f3-3f05-4acf-a5a3-eac6ef4daa53","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the discount rate for a security"
"DMAX","https://support.microsoft.com/en-us/office/dmax-function-f4e8209d-8958-4c3d-a1ee-6351665d41c2","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the maximum value from selected database entries"
"DMIN","https://support.microsoft.com/en-us/office/dmin-function-4ae6f1d9-1f26-40f1-a783-6dc3680192a3","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the minimum value from selected database entries"
"DOLLAR","https://support.microsoft.com/en-us/office/dollar-function-a6cd05d9-9740-4ad3-a469-8109d18ff611","Text functions","","3","medium_interest","true","format_visible_behavior","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a number to text, using the $ (dollar) currency format"
"DOLLARDE","https://support.microsoft.com/en-us/office/dollarde-function-db85aab0-1677-428a-9dfd-a38476693427","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a dollar price, expressed as a fraction, into a dollar price, expressed as a decimal number"
"DOLLARFR","https://support.microsoft.com/en-us/office/dollarfr-function-0835d163-3023-4a33-9824-3042c5d4f495","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a dollar price, expressed as a decimal number, into a dollar price, expressed as a fraction"
"DPRODUCT","https://support.microsoft.com/en-us/office/dproduct-function-4f96b13e-d49c-47a7-b769-22f6d017cb31","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Multiplies the values in a particular field of records that match the criteria in a database"
"DROP","https://support.microsoft.com/en-us/office/drop-function-1cb4e151-9e17-4838-abe5-9ba48d8c6a34","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Excludes a specified number of rows or columns from the start or end of an array"
"DSTDEV","https://support.microsoft.com/en-us/office/dstdev-function-026b8c73-616d-4b5e-b072-241871c4ab96","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates the standard deviation based on a sample of selected database entries"
"DSTDEVP","https://support.microsoft.com/en-us/office/dstdevp-function-04b78995-da03-4813-bbd9-d74fd0f5d94b","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates the standard deviation based on the entire population of selected database entries"
"DSUM","https://support.microsoft.com/en-us/office/dsum-function-53181285-0c4b-4f5a-aaa3-529a322be41b","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Adds the numbers in the field column of records in the database that match the criteria"
"DURATION","https://support.microsoft.com/en-us/office/duration-function-b254ea57-eadc-4602-a86a-c8e369334038","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the annual duration of a security with periodic interest payments"
"DVAR","https://support.microsoft.com/en-us/office/dvar-function-d6747ca9-99c7-48bb-996e-9d7af00f3ed1","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates variance based on a sample from selected database entries"
"DVARP","https://support.microsoft.com/en-us/office/dvarp-function-eb0ba387-9cb7-45c8-81e9-0394912502fc","Database functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates variance based on the entire population of selected database entries"
"EDATE","https://support.microsoft.com/en-us/office/edate-function-3c920eb2-6e66-44e7-a1f5-753ae47ee4f5","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of the date that is the indicated number of months before or after the start date"
"EFFECT","https://support.microsoft.com/en-us/office/effect-function-910d4e4c-79e2-4009-95e6-507e04f11bc4","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the effective annual interest rate"
"ENCODEURL","https://support.microsoft.com/en-us/office/encodeurl-function-07c7fb90-7c60-4bff-8687-fac50fe33d0e","Web functions","","4","high_interest","true","external_data_or_services","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a URL-encoded string"
"EOMONTH","https://support.microsoft.com/en-us/office/eomonth-function-7314ffa1-2bc9-4005-9d66-f49db127d628","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of the last day of the month before or after a specified number of months"
"ERF","https://support.microsoft.com/en-us/office/erf-function-c53c7e7b-5482-4b6c-883e-56df3c9af349","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the error function"
"ERF.PRECISE","https://support.microsoft.com/en-us/office/erf-precise-function-9a349593-705c-4278-9a98-e4122831a8e0","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the error function"
"ERFC","https://support.microsoft.com/en-us/office/erfc-function-736e0318-70ba-4e8b-8d08-461fe68b71b3","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the complementary error function"
"ERFC.PRECISE","https://support.microsoft.com/en-us/office/erfc-precise-function-e90e6bab-f45e-45df-b2ac-cd2eb4d4a273","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the complementary ERF function integrated between x and infinity"
"ERROR.TYPE","https://support.microsoft.com/en-us/office/error-type-function-10958677-7c8d-44f7-ae77-b9a9ee6eefaa","Information functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a number corresponding to an error type"
"EUROCONVERT","https://support.microsoft.com/en-us/office/euroconvert-function-79c8fd67-c665-450c-bb6c-15fc92f8345c","User defined functions that are installed with add-ins","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a number to euros, converts a number from euros to a euro member currency, or converts a number from one euro member currency to another by using the euro as an intermediary (triangulation)"
"EVEN","https://support.microsoft.com/en-us/office/even-function-197b5f06-c795-4c1e-8696-3c3b8a646cf9","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number up to the nearest even integer"
"EXACT","https://support.microsoft.com/en-us/office/exact-function-d3087698-fc15-4a15-9631-12575cf29926","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Checks to see if two text values are identical"
"EXP","https://support.microsoft.com/en-us/office/exp-function-c578f034-2c45-4c37-bc8c-329660a63abe","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns e raised to the power of a given number"
"EXPAND","https://support.microsoft.com/en-us/office/expand-function-7433fba5-4ad1-41da-a904-d5d95808bc38","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Expands or pads an array to specified row and column dimensions"
"EXPON.DIST","https://support.microsoft.com/en-us/office/expon-dist-function-4c12ae24-e563-4155-bf3e-8b78b6ae140e","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the exponential distribution"
"EXPONDIST","https://support.microsoft.com/en-us/office/expondist-function-68ab45fd-cd6d-4887-9770-9357eb8ee06a","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the exponential distribution"
"F.DIST","https://support.microsoft.com/en-us/office/f-dist-function-a887efdc-7c8e-46cb-a74a-f884cd29b25d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the F probability distribution"
"F.DIST.RT","https://support.microsoft.com/en-us/office/f-dist-rt-function-d74cbb00-6017-4ac9-b7d7-6049badc0520","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the F probability distribution"
"F.INV","https://support.microsoft.com/en-us/office/f-inv-function-0dda0cf9-4ea0-42fd-8c3c-417a1ff30dbe","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the F probability distribution"
"F.INV.RT","https://support.microsoft.com/en-us/office/f-inv-rt-function-d371aa8f-b0b1-40ef-9cc2-496f0693ac00","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the F probability distribution"
"F.TEST","https://support.microsoft.com/en-us/office/f-test-function-100a59e7-4108-46f8-8443-78ffacb6c0a7","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the result of an F-test"
"FACT","https://support.microsoft.com/en-us/office/fact-function-ca8588c2-15f2-41c0-8e8c-c11bd471a4f3","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the factorial of a number"
"FACTDOUBLE","https://support.microsoft.com/en-us/office/factdouble-function-e67697ac-d214-48eb-b7b7-cce2589ecac8","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the double factorial of a number"
"FALSE","https://support.microsoft.com/en-us/office/false-function-2d58dfa5-9c03-4259-bf8f-f0ae14346904","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the logical value FALSE"
"FDIST","https://support.microsoft.com/en-us/office/fdist-function-ecf76fba-b3f1-4e7d-a57e-6a5b7460b786","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the F probability distribution"
"FILTER","https://support.microsoft.com/en-us/office/filter-function-f4f7cb66-82eb-4767-8f7c-4877ad80c759","Our 10 featured functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to filter a range of data based on criteria you define."
"FILTERXML","https://support.microsoft.com/en-us/office/filterxml-function-4df72efc-11ec-4951-86f5-c1374812f5b7","Web functions","","4","high_interest","true","external_data_or_services","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns specific data from the XML content by using the specified XPath"
"FIND, FINDB","https://support.microsoft.com/en-us/office/find-function-c7912941-af2a-4bdf-a553-d0d89b0a0628","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Finds one text value within another (case-sensitive)"
"FINV","https://support.microsoft.com/en-us/office/finv-function-4d46c97c-c368-4852-bc15-41e8e31140b1","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the F probability distribution"
"FISHER","https://support.microsoft.com/en-us/office/fisher-function-d656523c-5076-4f95-b87b-7741bf236c69","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Fisher transformation"
"FISHERINV","https://support.microsoft.com/en-us/office/fisherinv-function-62504b39-415a-4284-a285-19c8e82f86bb","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the Fisher transformation"
"FIXED","https://support.microsoft.com/en-us/office/fixed-function-ffd5723c-324c-45e9-8b96-e41be2a8274a","Text functions","","3","medium_interest","true","format_visible_behavior","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Formats a number as text with a fixed number of decimals"
"FLOOR","https://support.microsoft.com/en-us/office/floor-function-14bb497c-24f2-4e04-b327-b0b4de5a8886","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number down, toward zero"
"FLOOR.MATH","https://support.microsoft.com/en-us/office/floor-math-function-c302b599-fbdb-4177-ba19-2c2b1249a2f5","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number down, to the nearest integer or to the nearest multiple of significance"
"FLOOR.PRECISE","https://support.microsoft.com/en-us/office/floor-precise-function-f769b468-1452-4617-8dc3-02f842a0702e","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number down to the nearest integer or to the nearest multiple of significance. Regardless of the sign of the number, the number is rounded down."
"FORECAST","https://support.microsoft.com/en-us/office/forecast-and-forecast-linear-functions-50ca49c9-7b40-4892-94e4-7ad38bbeda99","Statistical functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a value along a linear trend"
"FORECAST.LINEAR","https://support.microsoft.com/en-us/office/forecast-and-forecast-linear-functions-50ca49c9-7b40-4892-94e4-7ad38bbeda99","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a value along a linear trend"
"FORMULATEXT","https://support.microsoft.com/en-us/office/formulatext-function-0a786771-54fd-4ae2-96ee-09cda35439c8","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the formula at the given reference as text"
"FREQUENCY","https://support.microsoft.com/en-us/office/frequency-function-44e3be2b-eca0-42cd-a3f7-fd9ea898fdb9","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a frequency distribution as a vertical array"
"FTEST","https://support.microsoft.com/en-us/office/ftest-function-4c9e1202-53fe-428c-a737-976f6fc3f9fd","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the result of an F-test"
"FV","https://support.microsoft.com/en-us/office/fv-function-2eef9f44-a084-4c61-bdd8-4fe4bb1b71b3","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the future value of an investment"
"FVSCHEDULE","https://support.microsoft.com/en-us/office/fvschedule-function-bec29522-bd87-4082-bab9-a241f3fb251d","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the future value of an initial principal after applying a series of compound interest rates"
"GAMMA","https://support.microsoft.com/en-us/office/gamma-function-ce1702b1-cf55-471d-8307-f83be0fc5297","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Gamma function value"
"GAMMA.DIST","https://support.microsoft.com/en-us/office/gamma-dist-function-9b6f1538-d11c-4d5f-8966-21f6a2201def","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the gamma distribution"
"GAMMA.INV","https://support.microsoft.com/en-us/office/gamma-inv-function-74991443-c2b0-4be5-aaab-1aa4d71fbb18","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the gamma cumulative distribution"
"GAMMADIST","https://support.microsoft.com/en-us/office/gammadist-function-7327c94d-0f05-4511-83df-1dd7ed23e19e","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the gamma distribution"
"GAMMAINV","https://support.microsoft.com/en-us/office/gammainv-function-06393558-37ab-47d0-aa63-432f99e7916d","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the gamma cumulative distribution"
"GAMMALN","https://support.microsoft.com/en-us/office/gammaln-function-b838c48b-c65f-484f-9e1d-141c55470eb9","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the natural logarithm of the gamma function, ?(x)"
"GAMMALN.PRECISE","https://support.microsoft.com/en-us/office/gammaln-precise-function-5cdfe601-4e1e-4189-9d74-241ef1caa599","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the natural logarithm of the gamma function, ?(x)"
"GAUSS","https://support.microsoft.com/en-us/office/gauss-function-069f1b4e-7dee-4d6a-a71f-4b69044a6b33","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns 0.5 less than the standard normal cumulative distribution"
"GCD","https://support.microsoft.com/en-us/office/gcd-function-d5107a51-69e3-461f-8e4c-ddfc21b5073a","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the greatest common divisor"
"GEOMEAN","https://support.microsoft.com/en-us/office/geomean-function-db1ac48d-25a5-40a0-ab83-0b38980e40d5","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the geometric mean"
"GESTEP","https://support.microsoft.com/en-us/office/gestep-function-f37e7d2a-41da-4129-be95-640883fca9df","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Tests whether a number is greater than a threshold value"
"GETPIVOTDATA","https://support.microsoft.com/en-us/office/getpivotdata-function-8c083b99-a922-4ca0-af5e-3af55960761f","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns data stored in a PivotTable report"
"GROUPBY","https://support.microsoft.com/en-us/office/groupby-function-5e08ae8c-6800-4b72-b623-c41773611505","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Helps a user group, aggregate, sort, and filter data based on the fields you specify"
"GROWTH","https://support.microsoft.com/en-us/office/growth-function-541a91dc-3d5e-437d-b156-21324e68b80d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns values along an exponential trend"
"HARMEAN","https://support.microsoft.com/en-us/office/harmean-function-5efd9184-fab5-42f9-b1d3-57883a1d3bc6","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the harmonic mean"
"HEX2BIN","https://support.microsoft.com/en-us/office/hex2bin-function-a13aafaa-5737-4920-8424-643e581828c1","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a hexadecimal number to binary"
"HEX2DEC","https://support.microsoft.com/en-us/office/hex2dec-function-8c8c3155-9f37-45a5-a3ee-ee5379ef106e","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a hexadecimal number to decimal"
"HEX2OCT","https://support.microsoft.com/en-us/office/hex2oct-function-54d52808-5d19-4bd0-8a63-1096a5d11912","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a hexadecimal number to octal"
"HLOOKUP","https://support.microsoft.com/en-us/office/hlookup-function-a3034eec-b719-4ba3-bb65-e1ad662ed95f","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Looks in the top row of an array and returns the value of the indicated cell"
"HOUR","https://support.microsoft.com/en-us/office/hour-function-a3afa879-86cb-4339-b1b5-2dd2d7310ac7","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to an hour"
"HSTACK","https://support.microsoft.com/en-us/office/hstack-function-98c4ab76-10fe-4b4f-8d5f-af1c125fe8c2","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Appends arrays horizontally and in sequence to return a larger array"
"HYPERLINK","https://support.microsoft.com/en-us/office/hyperlink-function-333c7ce6-c5ae-4164-9c47-7de9b76f577f","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Creates a shortcut or jump that opens a document stored on a network server, an intranet, or the Internet"
"HYPGEOM.DIST","https://support.microsoft.com/en-us/office/hypgeom-dist-function-6dbd547f-1d12-4b1f-8ae5-b0d9e3d22fbf","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hypergeometric distribution"
"HYPGEOMDIST","https://support.microsoft.com/en-us/office/hypgeomdist-function-23e37961-2871-4195-9629-d0b2c108a12e","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hypergeometric distribution"
"IF","https://support.microsoft.com/en-us/office/if-function-69aed7c9-4e8a-4755-a9bc-aa8bbff73be2","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to return one value if a condition is true and another value if it's false. Here's a video about using the IF function ."
"IFERROR","https://support.microsoft.com/en-us/office/iferror-function-c526fd07-caeb-47b8-8bb6-63f3e417f611","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a value you specify if a formula evaluates to an error; otherwise, returns the result of the formula"
"IFNA","https://support.microsoft.com/en-us/office/ifna-function-6626c961-a569-42fc-a49d-79b4951fd461","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the value you specify if the expression resolves to #N/A, otherwise returns the result of the expression"
"IFS","https://support.microsoft.com/en-us/office/ifs-function-36329a26-37b2-467c-972b-4a39bd951d45","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Checks whether one or more conditions are met and returns a value that corresponds to the first TRUE condition."
"IMABS","https://support.microsoft.com/en-us/office/imabs-function-b31e73c6-d90c-4062-90bc-8eb351d765a1","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the absolute value (modulus) of a complex number"
"IMAGE","https://support.microsoft.com/en-us/office/image-function-7e112975-5e52-4f2a-b9da-1d913d51f5d5","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns an image from a given source"
"IMAGINARY","https://support.microsoft.com/en-us/office/imaginary-function-dd5952fd-473d-44d9-95a1-9a17b23e428a","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the imaginary coefficient of a complex number"
"IMARGUMENT","https://support.microsoft.com/en-us/office/imargument-function-eed37ec1-23b3-4f59-b9f3-d340358a034a","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the argument theta, an angle expressed in radians"
"IMCONJUGATE","https://support.microsoft.com/en-us/office/imconjugate-function-2e2fc1ea-f32b-4f9b-9de6-233853bafd42","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the complex conjugate of a complex number"
"IMCOS","https://support.microsoft.com/en-us/office/imcos-function-dad75277-f592-4a6b-ad6c-be93a808a53c","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cosine of a complex number"
"IMCOSH","https://support.microsoft.com/en-us/office/imcosh-function-053e4ddb-4122-458b-be9a-457c405e90ff","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic cosine of a complex number"
"IMCOT","https://support.microsoft.com/en-us/office/imcot-function-dc6a3607-d26a-4d06-8b41-8931da36442c","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cotangent of a complex number"
"IMCSC","https://support.microsoft.com/en-us/office/imcsc-function-9e158d8f-2ddf-46cd-9b1d-98e29904a323","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cosecant of a complex number"
"IMCSCH","https://support.microsoft.com/en-us/office/imcsch-function-c0ae4f54-5f09-4fef-8da0-dc33ea2c5ca9","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic cosecant of a complex number"
"IMDIV","https://support.microsoft.com/en-us/office/imdiv-function-a505aff7-af8a-4451-8142-77ec3d74d83f","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the quotient of two complex numbers"
"IMEXP","https://support.microsoft.com/en-us/office/imexp-function-c6f8da1f-e024-4c0c-b802-a60e7147a95f","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the exponential of a complex number"
"IMLN","https://support.microsoft.com/en-us/office/imln-function-32b98bcf-8b81-437c-a636-6fb3aad509d8","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the natural logarithm of a complex number"
"IMLOG10","https://support.microsoft.com/en-us/office/imlog10-function-58200fca-e2a2-4271-8a98-ccd4360213a5","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the base-10 logarithm of a complex number"
"IMLOG2","https://support.microsoft.com/en-us/office/imlog2-function-152e13b4-bc79-486c-a243-e6a676878c51","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the base-2 logarithm of a complex number"
"IMPOWER","https://support.microsoft.com/en-us/office/impower-function-210fd2f5-f8ff-4c6a-9d60-30e34fbdef39","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a complex number raised to an integer power"
"IMPRODUCT","https://support.microsoft.com/en-us/office/improduct-function-2fb8651a-a4f2-444f-975e-8ba7aab3a5ba","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the product of from 2 to 255 complex numbers"
"IMREAL","https://support.microsoft.com/en-us/office/imreal-function-d12bc4c0-25d0-4bb3-a25f-ece1938bf366","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the real coefficient of a complex number"
"IMSEC","https://support.microsoft.com/en-us/office/imsec-function-6df11132-4411-4df4-a3dc-1f17372459e0","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the secant of a complex number"
"IMSECH","https://support.microsoft.com/en-us/office/imsech-function-f250304f-788b-4505-954e-eb01fa50903b","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic secant of a complex number"
"IMSIN","https://support.microsoft.com/en-us/office/imsin-function-1ab02a39-a721-48de-82ef-f52bf37859f6","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sine of a complex number"
"IMSINH","https://support.microsoft.com/en-us/office/imsinh-function-dfb9ec9e-8783-4985-8c42-b028e9e8da3d","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic sine of a complex number"
"IMSQRT","https://support.microsoft.com/en-us/office/imsqrt-function-e1753f80-ba11-4664-a10e-e17368396b70","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the square root of a complex number"
"IMSUB","https://support.microsoft.com/en-us/office/imsub-function-2e404b4d-4935-4e85-9f52-cb08b9a45054","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the difference between two complex numbers"
"IMSUM","https://support.microsoft.com/en-us/office/imsum-function-81542999-5f1c-4da6-9ffe-f1d7aaa9457f","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of complex numbers"
"IMTAN","https://support.microsoft.com/en-us/office/imtan-function-8478f45d-610a-43cf-8544-9fc0b553a132","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the tangent of a complex number"
"INDEX","https://support.microsoft.com/en-us/office/index-function-a5dcf0dd-996d-40a4-a822-b56b061328bd","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Uses an index to choose a value from a reference or array"
"INDIRECT","https://support.microsoft.com/en-us/office/indirect-function-474b3a3a-8a26-4f44-b491-92b6306fa261","Lookup and reference functions","","5","critical_interest","true","volatile_or_recalc_sensitive|grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a reference indicated by a text value"
"INFO","https://support.microsoft.com/en-us/office/info-function-725f259a-0e4b-49b3-8b52-58815c69acae","Information functions","","5","critical_interest","true","volatile_or_recalc_sensitive|grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns information about the current operating environment"
"INT","https://support.microsoft.com/en-us/office/int-function-a6c4af9e-356d-4369-ab6a-cb1fd9d343ef","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number down to the nearest integer"
"INTERCEPT","https://support.microsoft.com/en-us/office/intercept-function-2a9b74e2-9d47-4772-b663-3bca70bf63ef","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the intercept of the linear regression line"
"INTRATE","https://support.microsoft.com/en-us/office/intrate-function-5cb34dde-a221-4cb6-b3eb-0b9e55e1316f","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the interest rate for a fully invested security"
"IPMT","https://support.microsoft.com/en-us/office/ipmt-function-5cce0ad6-8402-4a41-8d29-61a0b054cb6f","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the interest payment for an investment for a given period"
"IRR","https://support.microsoft.com/en-us/office/irr-function-64925eaa-9988-495b-b290-3ad0c163c1bc","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the internal rate of return for a series of cash flows"
"ISBLANK","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is blank"
"ISERR","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is any error value except #N/A"
"ISERROR","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is any error value"
"ISEVEN","https://support.microsoft.com/en-us/office/iseven-function-aa15929a-d77b-4fbb-92f4-2f479af55356","Information functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the number is even"
"ISFORMULA","https://support.microsoft.com/en-us/office/isformula-function-e4d1355f-7121-4ef2-801e-3839bfd6b1e5","Information functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if there is a reference to a cell that contains a formula"
"ISLOGICAL","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is a logical value"
"ISNA","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is the #N/A error value"
"ISNONTEXT","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is not text"
"ISNUMBER","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is a number"
"ISO.CEILING","https://support.microsoft.com/en-us/office/iso-ceiling-function-e587bb73-6cc2-4113-b664-ff5b09859a83","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a number that is rounded up to the nearest integer or to the nearest multiple of significance"
"ISODD","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the number is odd"
"ISOMITTED","https://support.microsoft.com/en-us/office/isomitted-function-831d6fbc-0f07-40c4-9c5b-9c73fd1d60c1","Information functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Checks whether the value in a LAMBDA is missing and returns TRUE or FALSE"
"ISOWEEKNUM","https://support.microsoft.com/en-us/office/isoweeknum-function-1c2d0afe-d25b-4ab1-8894-8d0520e90e0e","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of the ISO week number of the year for a given date"
"ISPMT","https://support.microsoft.com/en-us/office/ispmt-function-fa58adb6-9d39-4ce0-8f43-75399cea56cc","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates the interest paid during a specific period of an investment"
"ISREF","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is a reference"
"ISTEXT","https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665","Information functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if the value is text"
"JIS","https://support.microsoft.com/en-us/office/jis-function-b72fb1a7-ba52-448a-b7d3-d2610868b7e2","Compatibility","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.",""
"KURT","https://support.microsoft.com/en-us/office/kurt-function-bc3a265c-5da4-4dcb-b7fd-c237789095ab","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the kurtosis of a data set"
"LAMBDA","https://support.microsoft.com/en-us/office/lambda-function-bd212d27-1cd1-4321-a34a-ccbf254b8b67","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Create custom, reusable functions and call them by a friendly name"
"LARGE","https://support.microsoft.com/en-us/office/large-function-3af0af19-1190-42bb-bb8b-01672ec00a64","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the k-th largest value in a data set"
"LCM","https://support.microsoft.com/en-us/office/lcm-function-7152b67a-8bb5-4075-ae5c-06ede5563c94","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the least common multiple"
"LEFT, LEFTB","https://support.microsoft.com/en-us/office/left-function-9203d2d2-7960-479b-84c6-1ea52b99640c","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the leftmost characters from a text value"
"LEN, LENB","https://support.microsoft.com/en-us/office/len-function-29236f94-cedc-429d-affd-b5e33d2c67cb","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of characters in a text string"
"LET","https://support.microsoft.com/en-us/office/let-function-34842dd8-b92b-4d3f-b325-b8b8f9908999","Our 10 featured functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to assign names to calculation results."
"LINEST","https://support.microsoft.com/en-us/office/linest-function-84d7d0d9-6e50-4101-977a-fa7abf772b6d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the parameters of a linear trend"
"LN","https://support.microsoft.com/en-us/office/ln-function-81fe1ed7-dac9-4acd-ba1d-07a142c6118f","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the natural logarithm of a number"
"LOG","https://support.microsoft.com/en-us/office/log-function-4e82f196-1ca9-4747-8fb0-6c4a3abb3280","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the logarithm of a number to a specified base"
"LOG10","https://support.microsoft.com/en-us/office/log10-function-c75b881b-49dd-44fb-b6f4-37e3486a0211","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the base-10 logarithm of a number"
"LOGEST","https://support.microsoft.com/en-us/office/logest-function-f27462d8-3657-4030-866b-a272c1d18b4b","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the parameters of an exponential trend"
"LOGINV","https://support.microsoft.com/en-us/office/loginv-function-0bd7631a-2725-482b-afb4-de23df77acfe","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the lognormal cumulative distribution function"
"LOGNORM.DIST","https://support.microsoft.com/en-us/office/lognorm-dist-function-eb60d00b-48a9-4217-be2b-6074aee6b070","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cumulative lognormal distribution"
"LOGNORM.INV","https://support.microsoft.com/en-us/office/lognorm-inv-function-fe79751a-f1f2-4af8-a0a1-e151b2d4f600","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the lognormal cumulative distribution"
"LOGNORMDIST","https://support.microsoft.com/en-us/office/lognormdist-function-f8d194cb-9ee3-4034-8c75-1bdb3884100b","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the cumulative lognormal distribution"
"LOOKUP","https://support.microsoft.com/en-us/office/lookup-function-446d94af-663b-451d-8251-369d5e3864cb","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Looks up values in a vector or array"
"LOWER","https://support.microsoft.com/en-us/office/lower-function-3f21df02-a80c-44b2-afaf-81358f9fdeb4","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts text to lowercase"
"MAKEARRAY","https://support.microsoft.com/en-us/office/makearray-function-b80da5ad-b338-4149-a523-5b221da09097","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a calculated array of a specified row and column size, by applying a LAMBDA"
"MAP","https://support.microsoft.com/en-us/office/map-function-48006093-f97c-47c1-bfcc-749263bb1f01","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns an array formed by mapping each value in the array(s) to a new value by applying a LAMBDA to create a new value"
"MATCH","https://support.microsoft.com/en-us/office/match-function-e8dffd45-c762-47d6-bf89-533f4a37673a","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Looks up values in a reference or array"
"MAX","https://support.microsoft.com/en-us/office/max-function-e0012414-9ac8-4b34-9a47-73e662c08098","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the maximum value in a list of arguments"
"MAXA","https://support.microsoft.com/en-us/office/maxa-function-814bda1e-3840-4bff-9365-2f59ac2ee62d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the maximum value in a list of arguments, including numbers, text, and logical values"
"MAXIFS","https://support.microsoft.com/en-us/office/maxifs-function-dfd611e6-da2c-488a-919b-9b6376b28883","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the maximum value among cells specified by a given set of conditions or criteria"
"MDETERM","https://support.microsoft.com/en-us/office/mdeterm-function-e7bfa857-3834-422b-b871-0ffd03717020","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the matrix determinant of an array"
"MDURATION","https://support.microsoft.com/en-us/office/mduration-function-b3786a69-4f20-469a-94ad-33e5b90a763c","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Macauley modified duration for a security with an assumed par value of $100"
"MEDIAN","https://support.microsoft.com/en-us/office/median-function-d0916313-4753-414c-8537-ce85bdd967d2","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the median of the given numbers"
"MID, MIDB","https://support.microsoft.com/en-us/office/mid-function-d5f9e25c-d7d6-472e-b568-4ecb12433028","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a specific number of characters from a text string starting at the position you specify"
"MIN","https://support.microsoft.com/en-us/office/min-function-61635d12-920f-4ce2-a70f-96f202dcc152","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the minimum value in a list of arguments"
"MINA","https://support.microsoft.com/en-us/office/mina-function-245a6f46-7ca5-4dc7-ab49-805341bc31d3","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the smallest value in a list of arguments, including numbers, text, and logical values"
"MINIFS","https://support.microsoft.com/en-us/office/minifs-function-6ca1ddaa-079b-4e74-80cc-72eef32e6599","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the minimum value among cells specified by a given set of conditions or criteria."
"MINUTE","https://support.microsoft.com/en-us/office/minute-function-af728df0-05c4-4b07-9eed-a84801a60589","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a minute"
"MINVERSE","https://support.microsoft.com/en-us/office/minverse-function-11f55086-adde-4c9f-8eb9-59da2d72efc6","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the matrix inverse of an array"
"MIRR","https://support.microsoft.com/en-us/office/mirr-function-b020f038-7492-4fb4-93c1-35c345b53524","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the internal rate of return where positive and negative cash flows are financed at different rates"
"MMULT","https://support.microsoft.com/en-us/office/mmult-function-40593ed7-a3cd-4b6b-b9a3-e4ad3c7245eb","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the matrix product of two arrays"
"MOD","https://support.microsoft.com/en-us/office/mod-function-9b6cd169-b6ee-406a-a97b-edf2a9dc24f3","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the remainder from division"
"MODE","https://support.microsoft.com/en-us/office/mode-function-e45192ce-9122-4980-82ed-4bdc34973120","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the most common value in a data set"
"MODE.MULT","https://support.microsoft.com/en-us/office/mode-mult-function-50fd9464-b2ba-4191-b57a-39446689ae8c","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a vertical array of the most frequently occurring, or repetitive values in an array or range of data"
"MODE.SNGL","https://support.microsoft.com/en-us/office/mode-sngl-function-f1267c16-66c6-4386-959f-8fba5f8bb7f8","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the most common value in a data set"
"MONTH","https://support.microsoft.com/en-us/office/month-function-579a2881-199b-48b2-ab90-ddba0eba86e8","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a month"
"MROUND","https://support.microsoft.com/en-us/office/mround-function-c299c3b0-15a5-426d-aa4b-d2d5b3baf427","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a number rounded to the desired multiple"
"MULTINOMIAL","https://support.microsoft.com/en-us/office/multinomial-function-6fa6373c-6533-41a2-a45e-a56db1db1bf6","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the multinomial of a set of numbers"
"MUNIT","https://support.microsoft.com/en-us/office/munit-function-c9fe916a-dc26-4105-997d-ba22799853a3","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the unit matrix or the specified dimension"
"N","https://support.microsoft.com/en-us/office/n-function-a624cad1-3635-4208-b54a-29733d1278c9","Information functions","","3","medium_interest","true","type_or_coercion_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a value converted to a number"
"NA","https://support.microsoft.com/en-us/office/na-function-5469c2d1-a90c-4fb5-9bbc-64bd9bb6b47c","Information functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the error value #N/A"
"NEGBINOM.DIST","https://support.microsoft.com/en-us/office/negbinom-dist-function-c8239f89-c2d0-45bd-b6af-172e570f8599","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the negative binomial distribution"
"NEGBINOMDIST","https://support.microsoft.com/en-us/office/negbinomdist-function-f59b0a37-bae2-408d-b115-a315609ba714","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the negative binomial distribution"
"NETWORKDAYS","https://support.microsoft.com/en-us/office/networkdays-function-48e717bf-a7a3-495f-969e-5005e3eb18e7","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of whole workdays between two dates"
"NETWORKDAYS.INTL","https://support.microsoft.com/en-us/office/networkdays-intl-function-a9b26239-4f20-46a1-9ab8-4e925bfd5e28","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of whole workdays between two dates using parameters to indicate which and how many days are weekend days"
"NOMINAL","https://support.microsoft.com/en-us/office/nominal-function-7f1ae29b-6b92-435e-b950-ad8b190ddd2b","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the annual nominal interest rate"
"NORM.DIST","https://support.microsoft.com/en-us/office/norm-dist-function-edb1cc14-a21c-4e53-839d-8082074c9f8d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the normal cumulative distribution"
"NORM.INV","https://support.microsoft.com/en-us/office/norm-inv-function-54b30935-fee7-493c-bedb-2278a9db7e13","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the normal cumulative distribution"
"NORM.S.DIST","https://support.microsoft.com/en-us/office/norm-s-dist-function-1e787282-3832-4520-a9ae-bd2a8d99ba88","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the standard normal cumulative distribution"
"NORM.S.INV","https://support.microsoft.com/en-us/office/norm-s-inv-function-d6d556b4-ab7f-49cd-b526-5a20918452b1","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the standard normal cumulative distribution"
"NORMDIST","https://support.microsoft.com/en-us/office/normdist-function-126db625-c53e-4591-9a22-c9ff422d6d58","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the normal cumulative distribution"
"NORMINV","https://support.microsoft.com/en-us/office/norminv-function-87981ab8-2de0-4cb0-b1aa-e21d4cb879b8","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the normal cumulative distribution"
"NORMSDIST","https://support.microsoft.com/en-us/office/normsdist-function-463369ea-0345-445d-802a-4ff0d6ce7cac","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the standard normal cumulative distribution"
"NORMSINV","https://support.microsoft.com/en-us/office/normsinv-function-8d1bce66-8e4d-4f3b-967c-30eed61f019d","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the standard normal cumulative distribution"
"NOT","https://support.microsoft.com/en-us/office/not-function-9cfc6011-a054-40c7-a140-cd4ba2d87d77","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Reverses the logic of its argument"
"NOW","https://support.microsoft.com/en-us/office/now-function-3337fd29-145a-4347-b2e6-20c904739c46","Date and time functions","","3","medium_interest","true","volatile_or_recalc_sensitive|format_visible_behavior","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of the current date and time"
"NPER","https://support.microsoft.com/en-us/office/nper-function-240535b5-6653-4d2d-bfcf-b6a38151d815","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of periods for an investment"
"NPV","https://support.microsoft.com/en-us/office/npv-function-8672cb67-2576-4d07-b67b-ac28acf2a568","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the net present value of an investment based on a series of periodic cash flows and a discount rate"
"NUMBERVALUE","https://support.microsoft.com/en-us/office/numbervalue-function-1b05c8cf-2bfa-4437-af70-596c7ea7d879","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts text to number in a locale-independent manner"
"OCT2BIN","https://support.microsoft.com/en-us/office/oct2bin-function-55383471-3c56-4d27-9522-1a8ec646c589","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts an octal number to binary"
"OCT2DEC","https://support.microsoft.com/en-us/office/oct2dec-function-87606014-cb98-44b2-8dbb-e48f8ced1554","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts an octal number to decimal"
"OCT2HEX","https://support.microsoft.com/en-us/office/oct2hex-function-912175b4-d497-41b4-a029-221f051b858f","Engineering functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts an octal number to hexadecimal"
"ODD","https://support.microsoft.com/en-us/office/odd-function-deae64eb-e08a-4c88-8b40-6d0b42575c98","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number up to the nearest odd integer"
"ODDFPRICE","https://support.microsoft.com/en-us/office/oddfprice-function-d7d664a8-34df-4233-8d2b-922bcf6a69e1","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the price per $100 face value of a security with an odd first period"
"ODDFYIELD","https://support.microsoft.com/en-us/office/oddfyield-function-66bc8b7b-6501-4c93-9ce3-2fd16220fe37","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the yield of a security with an odd first period"
"ODDLPRICE","https://support.microsoft.com/en-us/office/oddlprice-function-fb657749-d200-4902-afaf-ed5445027fc4","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the price per $100 face value of a security with an odd last period"
"ODDLYIELD","https://support.microsoft.com/en-us/office/oddlyield-function-c873d088-cf40-435f-8d41-c8232fee9238","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the yield of a security with an odd last period"
"OFFSET","https://support.microsoft.com/en-us/office/offset-function-c8de19ae-dd79-4b9b-a14e-b4d906d11b66","Lookup and reference functions","","5","critical_interest","true","volatile_or_recalc_sensitive|grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a reference offset from a given reference"
"OR","https://support.microsoft.com/en-us/office/or-function-7d17ad14-8700-4281-b308-00b131e22af0","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns TRUE if any argument is TRUE"
"PDURATION","https://support.microsoft.com/en-us/office/pduration-function-44f33460-5be5-4c90-b857-22308892adaf","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of periods required by an investment to reach a specified value"
"PEARSON","https://support.microsoft.com/en-us/office/pearson-function-0c3e30fc-e5af-49c4-808a-3ef66e034c18","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Pearson product moment correlation coefficient"
"PERCENTILE","https://support.microsoft.com/en-us/office/percentile-function-91b43a53-543c-4708-93de-d626debdddca","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the k-th percentile of values in a range"
"PERCENTILE.EXC","https://support.microsoft.com/en-us/office/percentile-exc-function-bbaa7204-e9e1-4010-85bf-c31dc5dce4ba","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the k-th percentile of values in a range, where k is in the range 0..1, exclusive"
"PERCENTILE.INC","https://support.microsoft.com/en-us/office/percentile-inc-function-680f9539-45eb-410b-9a5e-c1355e5fe2ed","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the k-th percentile of values in a range"
"PERCENTOF","https://support.microsoft.com/en-us/office/percentof-function-7c66da0a-ac30-45d0-bfc7-834a8bd7c962","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Sums the values in the subset and divides it by all the values"
"PERCENTRANK","https://support.microsoft.com/en-us/office/percentrank-function-f1b5836c-9619-4847-9fc9-080ec9024442","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the percentage rank of a value in a data set"
"PERCENTRANK.EXC","https://support.microsoft.com/en-us/office/percentrank-exc-function-d8afee96-b7e2-4a2f-8c01-8fcdedaa6314","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the rank of a value in a data set as a percentage (0..1, exclusive) of the data set"
"PERCENTRANK.INC","https://support.microsoft.com/en-us/office/percentrank-inc-function-149592c9-00c0-49ba-86c1-c1f45b80463a","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the percentage rank of a value in a data set"
"PERMUT","https://support.microsoft.com/en-us/office/permut-function-3bd1cb9a-2880-41ab-a197-f246a7a602d3","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of permutations for a given number of objects"
"PERMUTATIONA","https://support.microsoft.com/en-us/office/permutationa-function-6c7d7fdc-d657-44e6-aa19-2857b25cae4e","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of permutations for a given number of objects (with repetitions) that can be selected from the total objects"
"PHI","https://support.microsoft.com/en-us/office/phi-function-23e49bc6-a8e8-402d-98d3-9ded87f6295c","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the value of the density function for a standard normal distribution"
"PHONETIC","https://support.microsoft.com/en-us/office/phonetic-function-9a329dac-0c0f-42f8-9a55-639086988554","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Extracts the phonetic (furigana) characters from a text string"
"PI","https://support.microsoft.com/en-us/office/pi-function-264199d0-a3ba-46b8-975a-c4a04608989b","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the value of pi"
"PIVOTBY","https://support.microsoft.com/en-us/office/pivotby-function-de86516a-90ad-4ced-8522-3a25fac389cf","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Helps a user group, aggregate, sort, and filter data based on the row and column fields that you specify"
"PMT","https://support.microsoft.com/en-us/office/pmt-function-0214da64-9a63-4996-bc20-214433fa6441","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the periodic payment for an annuity"
"POISSON","https://support.microsoft.com/en-us/office/poisson-function-d81f7294-9d7c-4f75-bc23-80aa8624173a","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Poisson distribution"
"POISSON.DIST","https://support.microsoft.com/en-us/office/poisson-dist-function-8fe148ff-39a2-46cb-abf3-7772695d9636","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Poisson distribution"
"POWER","https://support.microsoft.com/en-us/office/power-function-d3f2908b-56f4-4c3f-895a-07fb519c362a","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the result of a number raised to a power"
"PPMT","https://support.microsoft.com/en-us/office/ppmt-function-c370d9e3-7749-4ca4-beea-b06c6ac95e1b","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the payment on the principal for an investment for a given period"
"PRICE","https://support.microsoft.com/en-us/office/price-function-3ea9deac-8dfa-436f-a7c8-17ea02c21b0a","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the price per $100 face value of a security that pays periodic interest"
"PRICEDISC","https://support.microsoft.com/en-us/office/pricedisc-function-d06ad7c1-380e-4be7-9fd9-75e3079acfd3","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the price per $100 face value of a discounted security"
"PRICEMAT","https://support.microsoft.com/en-us/office/pricemat-function-52c3b4da-bc7e-476a-989f-a95f675cae77","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the price per $100 face value of a security that pays interest at maturity"
"PROB","https://support.microsoft.com/en-us/office/prob-function-9ac30561-c81c-4259-8253-34f0a238fc49","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the probability that values in a range are between two limits"
"PRODUCT","https://support.microsoft.com/en-us/office/product-function-8e6b5b24-90ee-4650-aeec-80982a0512ce","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Multiplies its arguments"
"PROPER","https://support.microsoft.com/en-us/office/proper-function-52a5a283-e8b2-49be-8506-b2887b889f94","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Capitalizes the first letter in each word of a text value"
"PV","https://support.microsoft.com/en-us/office/pv-function-23879d31-0e02-4321-be01-da16e8168cbd","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the present value of an investment"
"QUARTILE","https://support.microsoft.com/en-us/office/quartile-function-93cf8f62-60cd-4fdb-8a92-8451041e1a2a","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the quartile of a data set"
"QUARTILE.EXC","https://support.microsoft.com/en-us/office/quartile-exc-function-5a355b7a-840b-4a01-b0f1-f538c2864cad","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the quartile of the data set, based on percentile values from 0..1, exclusive"
"QUARTILE.INC","https://support.microsoft.com/en-us/office/quartile-inc-function-1bbacc80-5075-42f1-aed6-47d735c4819d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the quartile of a data set"
"QUOTIENT","https://support.microsoft.com/en-us/office/quotient-function-9f7bf099-2a18-4282-8fa4-65290cc99dee","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the integer portion of a division"
"RADIANS","https://support.microsoft.com/en-us/office/radians-function-ac409508-3d48-45f5-ac02-1497c92de5bf","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts degrees to radians"
"RAND","https://support.microsoft.com/en-us/office/rand-function-4cbfa695-8869-4788-8d90-021ea9f5be73","Math and trigonometry functions","","3","medium_interest","true","volatile_or_recalc_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a random number between 0 and 1"
"RANDARRAY","https://support.microsoft.com/en-us/office/randarray-function-21261e55-3bec-4885-86a6-8b0a47fd4d33","Math and trigonometry functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns an array of random numbers between 0 and 1. However, you can specify the number of rows and columns to fill, minimum and maximum values, and whether to return whole numbers or decimal values."
"RANDBETWEEN","https://support.microsoft.com/en-us/office/randbetween-function-4cc7f0d1-87dc-4eb7-987f-a469ab381685","Math and trigonometry functions","","3","medium_interest","true","volatile_or_recalc_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a random number between the numbers you specify"
"RANK","https://support.microsoft.com/en-us/office/rank-function-6a2fc49d-1831-4a03-9d8c-c279cf99f723","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the rank of a number in a list of numbers"
"RANK.AVG","https://support.microsoft.com/en-us/office/rank-avg-function-bd406a6f-eb38-4d73-aa8e-6d1c3c72e83a","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the rank of a number in a list of numbers"
"RANK.EQ","https://support.microsoft.com/en-us/office/rank-eq-function-284858ce-8ef6-450e-b662-26245be04a40","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the rank of a number in a list of numbers"
"RATE","https://support.microsoft.com/en-us/office/rate-function-9f665657-4a7e-4bb7-a030-83fc59e748ce","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the interest rate per period of an annuity"
"RECEIVED","https://support.microsoft.com/en-us/office/received-function-7a3f8b93-6611-4f81-8576-828312c9b5e5","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the amount received at maturity for a fully invested security"
"REDUCE","https://support.microsoft.com/en-us/office/reduce-function-42e39910-b345-45f3-84b8-0642b568b7cb","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Reduces an array to an accumulated value by applying a LAMBDA to each value and returning the total value in the accumulator"
"REGEXEXTRACT","https://support.microsoft.com/en-us/office/regexextract-function-4b96c140-9205-4b6e-9fbe-6aa9e783ff57","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Extracts strings within the provided text that matches the pattern"
"REGEXREPLACE","https://support.microsoft.com/en-us/office/regexreplace-function-9c030bb2-5e47-4efc-bad5-4582d7100897","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Replaces strings within the provided text that matches the pattern with replacement"
"REGEXTEST","https://support.microsoft.com/en-us/office/regextest-function-7d38200b-5e5c-4196-b4e6-9bff73afbd31","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Determines whether any part of text matches the pattern"
"REGISTER.ID","https://support.microsoft.com/en-us/office/register-id-function-f8f0af0f-fd66-4704-a0f2-87b27b175b50","User defined functions that are installed with add-ins","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the register ID of the specified dynamic link library (DLL) or code resource that has been previously registered"
"REPLACE, REPLACEB","https://support.microsoft.com/en-us/office/replace-function-8d799074-2425-4a8a-84bc-82472868878a","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Replaces characters within text"
"REPT","https://support.microsoft.com/en-us/office/rept-function-04c4d778-e712-43b4-9c15-d656582bb061","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Repeats text a given number of times"
"RIGHT, RIGHTB","https://support.microsoft.com/en-us/office/right-function-240267ee-9afa-4639-a02b-f19e1786cf2f","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the rightmost characters from a text value"
"ROMAN","https://support.microsoft.com/en-us/office/roman-function-d6b0b99e-de46-4704-a518-b45a0f8b56f5","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts an Arabic numeral to Roman, as text"
"ROUND","https://support.microsoft.com/en-us/office/round-function-c018c5d8-40fb-4053-90b1-b3e7f61a213c","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number to a specified number of digits"
"ROUNDDOWN","https://support.microsoft.com/en-us/office/rounddown-function-2ec94c73-241f-4b01-8c6f-17e6d7968f53","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number down, toward zero"
"ROUNDUP","https://support.microsoft.com/en-us/office/roundup-function-f8bc9b23-e795-47db-8703-db171d0c42a7","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Rounds a number up, away from zero"
"ROW","https://support.microsoft.com/en-us/office/row-function-3a63b74a-c4d0-4093-b49a-e76eb49a6d8d","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the row number of a reference"
"ROWS","https://support.microsoft.com/en-us/office/rows-function-b592593e-3fc2-47f2-bec1-bda493811597","Lookup and reference functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of rows in a reference"
"RRI","https://support.microsoft.com/en-us/office/rri-function-6f5822d8-7ef1-4233-944c-79e8172930f4","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns an equivalent interest rate for the growth of an investment"
"RSQ","https://support.microsoft.com/en-us/office/rsq-function-d7161715-250d-4a01-b80d-a8364f2be08f","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the square of the Pearson product moment correlation coefficient"
"RTD","https://support.microsoft.com/en-us/office/rtd-function-e0cc001a-56f0-470a-9b19-9455dc0eb593","Lookup and reference functions","","5","critical_interest","true","external_data_or_services","","RTD is COM Automation based; treat as Windows-first behavior and track cross-platform parity gaps explicitly.","Retrieves real-time data from a program that supports COM automation"
"SCAN","https://support.microsoft.com/en-us/office/scan-function-d58dfd11-9969-4439-b2dc-e7062724de29","Logical functions","","4","high_interest","true","functional_lambda_family","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Scans an array by applying a LAMBDA to each value and returns an array that has each intermediate value"
"SEARCH, SEARCHB","https://support.microsoft.com/en-us/office/search-function-9ab04538-0e55-4719-a72e-b6f54513b495","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Finds one text value within another (not case-sensitive)"
"SEC","https://support.microsoft.com/en-us/office/sec-function-ff224717-9c87-4170-9b58-d069ced6d5f7","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the secant of an angle"
"SECH","https://support.microsoft.com/en-us/office/sech-function-e05a789f-5ff7-4d7f-984a-5edb9b09556f","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic secant of an angle"
"SECOND","https://support.microsoft.com/en-us/office/second-function-740d1cfc-553c-4099-b668-80eaa24e8af1","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a second"
"SEQUENCE","https://support.microsoft.com/en-us/office/sequence-function-57467a98-57e0-4817-9f14-2eb78519ca90","Math and trigonometry functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Generates a list of sequential numbers in an array, such as 1, 2, 3, 4"
"SERIESSUM","https://support.microsoft.com/en-us/office/seriessum-function-a3ab25b5-1093-4f5b-b084-96c49087f637","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of a power series based on the formula"
"SHEET","https://support.microsoft.com/en-us/office/sheet-function-44718b6f-8b87-47a1-a9d6-b701c06cff24","Information functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sheet number of the referenced sheet"
"SHEETS","https://support.microsoft.com/en-us/office/sheets-function-770515eb-e1e8-45ce-8066-b557e5e4b80b","Information functions","","3","medium_interest","true","grid_reference_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number of sheets in a reference"
"SIGN","https://support.microsoft.com/en-us/office/sign-function-109c932d-fcdc-4023-91f1-2dd0e916a1d8","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sign of a number"
"SIN","https://support.microsoft.com/en-us/office/sin-function-cf0e3432-8b9e-483c-bc55-a76651c95602","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sine of the given angle"
"SINH","https://support.microsoft.com/en-us/office/sinh-function-1e4e8b9f-2b65-43fc-ab8a-0a37f4081fa7","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic sine of a number"
"SKEW","https://support.microsoft.com/en-us/office/skew-function-bdf49d86-b1ef-4804-a046-28eaea69c9fa","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the skewness of a distribution"
"SKEW.P","https://support.microsoft.com/en-us/office/skew-p-function-76530a5c-99b9-48a1-8392-26632d542fcb","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the skewness of a distribution based on a population: a characterization of the degree of asymmetry of a distribution around its mean"
"SLN","https://support.microsoft.com/en-us/office/sln-function-cdb666e5-c1c6-40a7-806a-e695edc2f1c8","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the straight-line depreciation of an asset for one period"
"SLOPE","https://support.microsoft.com/en-us/office/slope-function-11fb8f97-3117-4813-98aa-61d7e01276b9","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the slope of the linear regression line"
"SMALL","https://support.microsoft.com/en-us/office/small-function-17da8222-7c82-42b2-961b-14c45384df07","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the k-th smallest value in a data set"
"SORT","https://support.microsoft.com/en-us/office/sort-function-22f63bd0-ccc8-492f-953d-c20e8e44b86c","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Sorts the contents of a range or array"
"SORTBY","https://support.microsoft.com/en-us/office/sortby-function-cd2d7a62-1b93-435c-b561-d6a35134f28f","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Sorts the contents of a range or array based on the values in a corresponding range or array"
"SQRT","https://support.microsoft.com/en-us/office/sqrt-function-654975c2-05c4-4831-9a24-2c65e4040fdf","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a positive square root"
"SQRTPI","https://support.microsoft.com/en-us/office/sqrtpi-function-1fb4e63f-9b51-46d6-ad68-b3e7a8b519b4","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the square root of (number * pi)"
"STANDARDIZE","https://support.microsoft.com/en-us/office/standardize-function-81d66554-2d54-40ec-ba83-6437108ee775","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a normalized value"
"STDEV","https://support.microsoft.com/en-us/office/stdev-function-51fecaaa-231e-4bbb-9230-33650a72c9b0","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates standard deviation based on a sample"
"STDEV.P","https://support.microsoft.com/en-us/office/stdev-p-function-6e917c05-31a0-496f-ade7-4f4e7462f285","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates standard deviation based on the entire population"
"STDEV.S","https://support.microsoft.com/en-us/office/stdev-s-function-7d69cf97-0c1f-4acf-be27-f3e83904cc23","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates standard deviation based on a sample"
"STDEVA","https://support.microsoft.com/en-us/office/stdeva-function-5ff38888-7ea5-48de-9a6d-11ed73b29e9d","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates standard deviation based on a sample, including numbers, text, and logical values"
"STDEVP","https://support.microsoft.com/en-us/office/stdevp-function-1f7c1c88-1bec-4422-8242-e9f7dc8bb195","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates standard deviation based on the entire population"
"STDEVPA","https://support.microsoft.com/en-us/office/stdevpa-function-5578d4d6-455a-4308-9991-d405afe2c28c","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates standard deviation based on the entire population, including numbers, text, and logical values"
"STEYX","https://support.microsoft.com/en-us/office/steyx-function-6ce74b2c-449d-4a6e-b9ac-f9cef5ba48ab","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the standard error of the predicted y-value for each x in the regression"
"STOCKHISTORY","https://support.microsoft.com/en-us/office/stockhistory-function-1ac8b5b3-5f62-4d94-8ab8-7504ec7239a8","Information functions","","4","high_interest","true","external_data_or_services","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Retrieves historical data about a financial instrument"
"SUBSTITUTE","https://support.microsoft.com/en-us/office/substitute-function-6434944e-a904-4336-a9b0-1e58df3bc332","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Substitutes new text for old text in a text string"
"SUBTOTAL","https://support.microsoft.com/en-us/office/subtotal-function-7b027003-f060-4ade-9040-e478765b9939","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a subtotal in a list or database"
"SUM","https://support.microsoft.com/en-us/office/sum-function-043e1c7d-7726-4e80-8f32-07b23e057f89","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to add the values in cells."
"SUMIF","https://support.microsoft.com/en-us/office/sumif-function-169b8c99-c05c-4483-a712-1697a653039b","Math and trigonometry functions","","3","medium_interest","true","volatile_or_recalc_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Adds the cells specified by a given criteria"
"SUMIFS","https://support.microsoft.com/en-us/office/sumifs-function-c9e748f5-7ea7-455d-9406-611cebce642b","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function when you need to add the cells in a range that meet multiple criteria."
"SUMPRODUCT","https://support.microsoft.com/en-us/office/sumproduct-function-16753e75-9f68-4874-94ac-4d2145a2fd2e","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of the products of corresponding array components"
"SUMSQ","https://support.microsoft.com/en-us/office/sumsq-function-e3313c02-51cc-4963-aae6-31442d9ec307","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of the squares of the arguments"
"SUMX2MY2","https://support.microsoft.com/en-us/office/sumx2my2-function-9e599cc5-5399-48e9-a5e0-e37812dfa3e9","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of the difference of squares of corresponding values in two arrays"
"SUMX2PY2","https://support.microsoft.com/en-us/office/sumx2py2-function-826b60b4-0aa2-4e5e-81d2-be704d3d786f","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of the sum of squares of corresponding values in two arrays"
"SUMXMY2","https://support.microsoft.com/en-us/office/sumxmy2-function-9d144ac1-4d79-43de-b524-e2ecee23b299","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum of squares of differences of corresponding values in two arrays"
"SWITCH","https://support.microsoft.com/en-us/office/switch-function-47ab33c0-28ce-4530-8a45-d532ec4aa25e","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Evaluates an expression against a list of values and returns the result corresponding to the first matching value. If there is no match, an optional default value may be returned."
"SYD","https://support.microsoft.com/en-us/office/syd-function-069f8106-b60b-4ca2-98e0-2a0f206bdb27","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the sum-of-years' digits depreciation of an asset for a specified period"
"T","https://support.microsoft.com/en-us/office/t-function-fb83aeec-45e7-4924-af95-53e073541228","Text functions","","3","medium_interest","true","type_or_coercion_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts its arguments to text"
"T.DIST","https://support.microsoft.com/en-us/office/t-dist-function-4329459f-ae91-48c2-bba8-1ead1c6c21b2","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Percentage Points (probability) for the Student t-distribution"
"T.DIST.2T","https://support.microsoft.com/en-us/office/t-dist-2t-function-198e9340-e360-4230-bd21-f52f22ff5c28","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Percentage Points (probability) for the Student t-distribution"
"T.DIST.RT","https://support.microsoft.com/en-us/office/t-dist-rt-function-20a30020-86f9-4b35-af1f-7ef6ae683eda","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Student's t-distribution"
"T.INV","https://support.microsoft.com/en-us/office/t-inv-function-2908272b-4e61-4942-9df9-a25fec9b0e2e","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the t-value of the Student's t-distribution as a function of the probability and the degrees of freedom"
"T.INV.2T","https://support.microsoft.com/en-us/office/t-inv-2t-function-ce72ea19-ec6c-4be7-bed2-b9baf2264f17","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the Student's t-distribution"
"T.TEST","https://support.microsoft.com/en-us/office/t-test-function-d4e08ec3-c545-485f-962e-276f7cbed055","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the probability associated with a Student's t-test"
"TAKE","https://support.microsoft.com/en-us/office/take-function-25382ff1-5da1-4f78-ab43-f33bd2e4e003","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a specified number of contiguous rows or columns from the start or end of an array"
"TAN","https://support.microsoft.com/en-us/office/tan-function-08851a40-179f-4052-b789-d7f699447401","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the tangent of a number"
"TANH","https://support.microsoft.com/en-us/office/tanh-function-017222f0-a0c3-4f69-9787-b3202295dc6c","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the hyperbolic tangent of a number"
"TBILLEQ","https://support.microsoft.com/en-us/office/tbilleq-function-2ab72d90-9b4d-4efe-9fc2-0f81f2c19c8c","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the bond-equivalent yield for a Treasury bill"
"TBILLPRICE","https://support.microsoft.com/en-us/office/tbillprice-function-eacca992-c29d-425a-9eb8-0513fe6035a2","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the price per $100 face value for a Treasury bill"
"TBILLYIELD","https://support.microsoft.com/en-us/office/tbillyield-function-6d381232-f4b0-4cd5-8e97-45b9c03468ba","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the yield for a Treasury bill"
"TDIST","https://support.microsoft.com/en-us/office/tdist-function-630a7695-4021-4853-9468-4a1f9dcdd192","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Student's t-distribution"
"TEXT","https://support.microsoft.com/en-us/office/text-function-20d5ac4d-7b94-49fd-bb38-93d29371225c","Text functions","","3","medium_interest","true","format_visible_behavior","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Formats a number and converts it to text"
"TEXTAFTER","https://support.microsoft.com/en-us/office/textafter-function-c8db2546-5b51-416a-9690-c7e6722e90b4","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns text that occurs after given character or string"
"TEXTBEFORE","https://support.microsoft.com/en-us/office/textbefore-function-d099c28a-dba8-448e-ac6c-f086d0fa1b29","Our 10 featured functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to return text that occurs before a given character or string. You can use TEXTAFTER to return text that occurs after a given character or string."
"TEXTJOIN","https://support.microsoft.com/en-us/office/textjoin-function-357b449a-ec91-49d0-80c3-0e8fc845691c","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Text: Combines the text from multiple ranges and/or strings"
"TEXTSPLIT","https://support.microsoft.com/en-us/office/textsplit-function-b1ca414e-4c21-4ca0-b1b7-bdecace8a6e7","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Splits text strings by using column and row delimiters"
"TIME","https://support.microsoft.com/en-us/office/time-function-9a5aff99-8f7d-4611-845e-747d0b8d5457","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of a particular time"
"TIMEVALUE","https://support.microsoft.com/en-us/office/timevalue-function-0b615c12-33d8-4431-bf3d-f3eb6d186645","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a time in the form of text to a serial number"
"TINV","https://support.microsoft.com/en-us/office/tinv-function-a7c85b9d-90f5-41fe-9ca5-1cd2f3e1ed7c","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the inverse of the Student's t-distribution"
"TOCOL","https://support.microsoft.com/en-us/office/tocol-function-22839d9b-0b55-4fc1-b4e6-2761f8f122ed","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the array in a single column"
"TODAY","https://support.microsoft.com/en-us/office/today-function-5eb3078d-a82c-4736-8930-2f51a028fdd9","Date and time functions","","3","medium_interest","true","volatile_or_recalc_sensitive|format_visible_behavior","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of today's date"
"TOROW","https://support.microsoft.com/en-us/office/torow-function-b90d0964-a7d9-44b7-816b-ffa5c2fe2289","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the array in a single row"
"TRANSLATE","https://support.microsoft.com/en-us/office/translate-function-d34f71c7-2ffe-409a-9a63-5eb5e91aa3dd","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Translates a text from one language to another"
"TRANSPOSE","https://support.microsoft.com/en-us/office/transpose-function-ed039415-ed8a-4a81-93e9-4b6dfac76027","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the transpose of an array"
"TREND","https://support.microsoft.com/en-us/office/trend-function-e2f135f0-8827-4096-9873-9a7cf7b51ef1","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns values along a linear trend"
"TRIM","https://support.microsoft.com/en-us/office/trim-function-410388fa-c5df-49c6-b16c-9e5630b479f9","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Removes spaces from text"
"TRIMMEAN","https://support.microsoft.com/en-us/office/trimmean-function-d90c9878-a119-4746-88fa-63d988f511d3","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the mean of the interior of a data set"
"TRIMRANGE","https://support.microsoft.com/en-us/office/trimrange-function-d7812248-3bc5-4c6b-901c-1afa9564f999","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Scans in from the edges of a range or array until it finds a non-blank cell (or value), it then excludes those blank rows or columns"
"TRUE","https://support.microsoft.com/en-us/office/true-function-7652c6e3-8987-48d0-97cd-ef223246b3fb","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the logical value TRUE"
"TRUNC","https://support.microsoft.com/en-us/office/trunc-function-8b86a64c-3127-43db-ba14-aa5ceb292721","Math and trigonometry functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Truncates a number to an integer"
"TTEST","https://support.microsoft.com/en-us/office/ttest-function-1696ffc1-4811-40fd-9d13-a0eaad83c7ae","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the probability associated with a Student's t-test"
"TYPE","https://support.microsoft.com/en-us/office/type-function-45b4e688-4bc3-48b3-a105-ffa892995899","Information functions","","3","medium_interest","true","type_or_coercion_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a number indicating the data type of a value"
"UNICHAR","https://support.microsoft.com/en-us/office/unichar-function-ffeb64f5-f131-44c6-b332-5cd72f0659b8","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Unicode character that is references by the given numeric value"
"UNICODE","https://support.microsoft.com/en-us/office/unicode-function-adb74aaa-a2a5-4dde-aff6-966e4e81f16f","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the number (code point) that corresponds to the first character of the text"
"UNIQUE","https://support.microsoft.com/en-us/office/unique-function-c5ab87fd-30a3-4ce9-9d1a-40204fb85e1e","Our 10 featured functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function to return a list of unique values in a list or range."
"UPPER","https://support.microsoft.com/en-us/office/upper-function-c11f29b3-d1a3-4537-8df6-04d0049963d6","Text functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts text to uppercase"
"VALUE","https://support.microsoft.com/en-us/office/value-function-257d0108-07dc-437d-ae1c-bc2d3953d8c2","Text functions","","3","medium_interest","true","type_or_coercion_sensitive","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a text argument to a number"
"VALUETOTEXT","https://support.microsoft.com/en-us/office/valuetotext-function-5fff61a2-301a-4ab2-9ffa-0a5242a08fea","Text functions","","3","medium_interest","true","type_or_coercion_sensitive|format_visible_behavior","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns text from any specified value"
"VAR","https://support.microsoft.com/en-us/office/var-function-1f2b7ab2-954d-4e17-ba2c-9e58b15a7da2","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates variance based on a sample"
"VAR.P","https://support.microsoft.com/en-us/office/var-p-function-73d1285c-108c-4843-ba5d-a51f90656f3a","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates variance based on the entire population"
"VAR.S","https://support.microsoft.com/en-us/office/var-s-function-913633de-136b-449d-813e-65a00b2b990b","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates variance based on a sample"
"VARA","https://support.microsoft.com/en-us/office/vara-function-3de77469-fa3a-47b4-85fd-81758a1e1d07","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Estimates variance based on a sample, including numbers, text, and logical values"
"VARP","https://support.microsoft.com/en-us/office/varp-function-26a541c4-ecee-464d-a731-bd4c575b1a6b","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates variance based on the entire population"
"VARPA","https://support.microsoft.com/en-us/office/varpa-function-59a62635-4e89-4fad-88ac-ce4dc0513b96","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Calculates variance based on the entire population, including numbers, text, and logical values"
"VDB","https://support.microsoft.com/en-us/office/vdb-function-dde4e207-f3fa-488d-91d2-66d55e861d73","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the depreciation of an asset for a specified or partial period by using a declining balance method"
"VLOOKUP","https://support.microsoft.com/en-us/office/vlookup-function-0bbc8083-26fe-4963-8ab8-93a18ad188a1","Lookup and reference functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Looks in the first column of an array and moves across the row to return the value of a cell"
"VSTACK","https://support.microsoft.com/en-us/office/vstack-function-a4b86897-be0f-48fc-adca-fcc10d795a9c","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Appends arrays vertically and in sequence to return a larger array"
"WEBSERVICE","https://support.microsoft.com/en-us/office/webservice-function-0546a35a-ecc6-4739-aed7-c0b7ce1562c4","Web functions","","4","high_interest","true","external_data_or_services","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns data from a web service"
"WEEKDAY","https://support.microsoft.com/en-us/office/weekday-function-60e44483-2ed1-439f-8bd0-e404c190949a","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a day of the week"
"WEEKNUM","https://support.microsoft.com/en-us/office/weeknum-function-e5c43a03-b4ab-426c-b411-b18c13c75340","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a number representing where the week falls numerically with a year"
"WEIBULL","https://support.microsoft.com/en-us/office/weibull-function-b83dc2c6-260b-4754-bef2-633196f6fdcc","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Weibull distribution"
"WEIBULL.DIST","https://support.microsoft.com/en-us/office/weibull-dist-function-4e783c39-9325-49be-bbc9-a83ef82b45db","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the Weibull distribution"
"WORKDAY","https://support.microsoft.com/en-us/office/workday-function-f764a5b7-05fc-4494-9486-60d494efbf33","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of the date before or after a specified number of workdays"
"WORKDAY.INTL","https://support.microsoft.com/en-us/office/workday-intl-function-a378391c-9ba7-4678-8a39-39611a9bf81d","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the serial number of the date before or after a specified number of workdays using parameters to indicate which and how many days are weekend days"
"WRAPCOLS","https://support.microsoft.com/en-us/office/wrapcols-function-d038b05a-57b7-4ee0-be94-ded0792511e2","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Wraps the provided row or column of values by columns after a specified number of elements"
"WRAPROWS","https://support.microsoft.com/en-us/office/wraprows-function-796825f3-975a-4cee-9c84-1bbddf60ade0","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Wraps the provided row or column of values by rows after a specified number of elements"
"XIRR","https://support.microsoft.com/en-us/office/xirr-function-de1242ec-6477-445b-b11b-a303ad9adc9d","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the internal rate of return for a schedule of cash flows that is not necessarily periodic"
"XLOOKUP","https://support.microsoft.com/en-us/office/xlookup-function-b7fd680e-6d10-43e6-84f9-88eae8bf5929","Our 10 featured functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Use this function when you need to search a range or an array, and return an item corresponding to the first match it finds. If a match doesn't exist, then XLOOKUP can return the closest (approximate) match."
"XMATCH","https://support.microsoft.com/en-us/office/xmatch-function-d966da31-7a6b-4a13-a1c6-5a33ed6a0312","Lookup and reference functions","","4","high_interest","true","dynamic_array_or_spill","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the relative position of an item in an array or range of cells."
"XNPV","https://support.microsoft.com/en-us/office/xnpv-function-1b42bbf6-370f-4532-a0eb-d67c16b664b7","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the net present value for a schedule of cash flows that is not necessarily periodic"
"XOR","https://support.microsoft.com/en-us/office/xor-function-1548d4c2-5e47-4f77-9a92-0533bba14f37","Logical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns a logical exclusive OR of all arguments"
"YEAR","https://support.microsoft.com/en-us/office/year-function-c64f017a-1354-490d-981f-578e8ec8d3b9","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Converts a serial number to a year"
"YEARFRAC","https://support.microsoft.com/en-us/office/yearfrac-function-3844141e-c76d-4143-82b6-208454ddc6a8","Date and time functions","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the year fraction representing the number of whole days between start_date and end_date"
"YIELD","https://support.microsoft.com/en-us/office/yield-function-f5f5ca43-c4bd-434f-8bd2-ed3c9727a4fe","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the yield on a security that pays periodic interest"
"YIELDDISC","https://support.microsoft.com/en-us/office/yielddisc-function-a9dbdbae-7dae-46de-b995-615faffaaed7","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the annual yield for a discounted security; for example, a Treasury bill"
"YIELDMAT","https://support.microsoft.com/en-us/office/yieldmat-function-ba7d1809-0d33-4bcb-96c7-6c56ec62ef6f","Financial functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the annual yield of a security that pays interest at maturity"
"Z.TEST","https://support.microsoft.com/en-us/office/z-test-function-d633d5a3-2031-4614-a016-92180ad82bee","Statistical functions","","1","regular_pure_or_low_risk","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the one-tailed probability-value of a z-test"
"ZTEST","https://support.microsoft.com/en-us/office/ztest-function-8f33be8a-6bd6-4ecc-8e3a-d9a4420c4a6a","Compatibility","","2","baseline_context","false","","","Union target across Desktop/Mac/Web. Track exceptions per-function as discovered.","Returns the one-tailed probability-value of a z-test"
```

## Source: `OxFunc/docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`

# Function Lane Evidence ID Registry (Provisional)

Status: `active`
Owner lane: `OxFunc`

Purpose:
1. keep local evidence IDs stable and traceable before Foundation promotion,
2. avoid ad-hoc ID drift across function-lane docs.

## Registry Rows

| evidence_id | scope | status | source_artifacts | notes |
| --- | --- | --- | --- | --- |
| `W1-FA-BL-20260305` | W1 `PI()` admission-boundary baseline (COM + file-ingress) | provisional | `docs/function-lane/FORMULA_ADMISSION_BEHAVIOR_NOTES.md`; `tools/formula-admission-probe/run-formula-admission-baseline.ps1`; `.tmp/formula-admission-results.csv` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, compatibility `default|CalculationVersion=191029|CheckCompatibility=False|FileFormat=51`, locale `en-US`. |
| `W2-RUN-20260305` | W2 floating-point characterization empirical baseline (`FP-A/B/C/D`) | provisional | `docs/function-lane/FLOATING_POINT_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/FLOATING_POINT_EXECUTION_RECORD.md`; `tools/fp-probe/run-fp-suite.ps1`; `.tmp/fp-results-excel-all.csv`; `.tmp/fp-results-lean.csv` | Baseline run scope and divergence outcomes are recorded in `FLOATING_POINT_EXECUTION_RECORD.md`; includes Excel and Lean comparative outputs for declared lanes. |
| `W3-VU-BL-20260305` | W3 value-universe baseline taxonomy/spec + Lean/Rust scaffold closure | provisional | `docs/function-lane/VALUE_UNIVERSE_PRELIM_SPEC.md`; `docs/function-lane/VALUE_UNIVERSE_TAG_TABLE.csv`; `docs/function-lane/VALUE_UNIVERSE_RESEARCH_AND_OPEN_QUESTIONS.md`; `crates/oxfunc_core/src/value.rs`; `formal/lean/OxFunc/ValueUniverse.lean` | Baseline taxonomy run under W3 on 2026-03-05; Rust tests (`cargo test -p oxfunc_core`) and Lean build (`lake build`) passed. |
| `W7-STR-BL-20260305` | W7 string normalization/comparison/limit baseline (worksheet + interop + persistence lanes) | provisional | `docs/function-lane/STRING_BEHAVIOR_RESEARCH_NOTES.md`; `docs/function-lane/STRING_EXECUTION_RECORD.md`; `docs/function-lane/STRING_NORMALIZATION_AND_COMPARISON_POLICY_MAP.md`; `docs/function-lane/STRING_SCENARIO_MANIFEST_SEED.csv`; `tools/string-probe/run-string-excel-baseline.ps1`; `.tmp/string-results-excel.csv` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, compatibility `default|CalculationVersion=191029|CheckCompatibility=False|FileFormat=51` plus CSV reopen `FileFormat=6`, locale `en-US`. |
| `W4-COERCE-BL-20260307` | W4 coercion/ref-resolution empirical baseline (scalar/array/aggregate/ref seam lanes) | provisional | `docs/function-lane/COERCION_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/COERCION_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/COERCION_EXECUTION_RECORD.md`; `tools/coercion-probe/run-coercion-excel-baseline.ps1`; `.tmp/coercion-results-excel.csv`; `.tmp/coercion-analysis-report.csv` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, locale `en-US`, run label `default`. Baseline captured `18` rows (`17` observed + `1` intentional admission failure) with `expectation_mismatched=0`; includes external-open-state row (`CO4-018`) showing closed `#REF!` vs open resolved value. |
| `W5-ABS-BL-20260308` | W5 `ABS` full-formality baseline (admission/coercion/floating-point/array-lift/reference/persistence lanes) | provisional | `docs/function-lane/FUNCTION_SLICE_ABS_CONTRACT_PRELIM.md`; `docs/function-lane/ABS_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/ABS_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/ABS_EXECUTION_RECORD.md`; `tools/abs-probe/run-abs-suite.ps1`; `.tmp/abs-results-default.csv`; `.tmp/abs-results-compat.csv`; `.tmp/abs-results-excel.csv`; `.tmp/abs-analysis-report.csv`; `.tmp/abs-analysis-summary.json` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, locale `en-US`. Dual-run baseline captured `32` rows (`30` observed + `2` intentional admission failures) with `expectation_mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. |
| `W5-ABS-ENTRY-20260308` | W5 `ABS` entrypoint mechanism baseline (`Range.Formula`, `Application.Evaluate`, `Worksheet.Evaluate`, `WorksheetFunction.Abs`) | provisional | `docs/function-lane/ABS_ENTRYPOINT_SCENARIO_MANIFEST_SEED.csv`; `tools/abs-probe/run-abs-entrypoint-baseline.ps1`; `tools/abs-probe/analyze-abs-entrypoint-results.ps1`; `.tmp/abs-entrypoint-results.csv`; `.tmp/abs-entrypoint-analysis-summary.json` | Single-build baseline for mechanism-specific admission/runtime behavior. Captured `8` rows with `expectation_mismatched=0`, `failed_expected=3`, `failed_unexpected=0`; includes `Range.Formula` omission sentinel and observed COM dispatch absence for `WorksheetFunction.Abs` in this baseline. |
| `W5-ABS-FP-20260310` | W5 `ABS` floating-point follow-up (tiny-value reciprocal follow-back over direct and reference-fed ABS lanes) | provisional | `docs/function-lane/FUNCTION_SLICE_ABS_CONTRACT_PRELIM.md`; `docs/function-lane/ABS_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/ABS_EXECUTION_RECORD.md`; `docs/function-lane/LEAN_FLOAT_MODEL_NOTES.md`; `formal/lean/OxFunc/FloatingPointEnv.lean`; `formal/lean/OxFunc/Functions/Abs.lean`; `tools/abs-probe/run-abs-suite.ps1`; `.tmp/abs-fp-followup/abs-results-default.csv`; `.tmp/abs-fp-followup/abs-results-compat.csv`; `.tmp/abs-fp-followup/abs-results-excel.csv`; `.tmp/abs-fp-followup/abs-analysis-report.csv`; `.tmp/abs-fp-followup/abs-analysis-summary.json` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, locale `en-US`. Dual-run follow-up captured `36` rows (`34` observed + `2` intentional admission failures) with `expectation_mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. The new ABS rows (`ABS5-017`, `ABS5-018`) showed worksheet-visible zero collapse for tiny negative inputs, with reciprocal follow-back yielding `#DIV/0!` in both run labels. |
| `W6-XMATCH-SEED-20260308` | W6 `XMATCH` exploration seed scaffold (contract + Lean/Rust + correlation + empirical runner scaffold) | provisional | `docs/worksets/W006_XMATCH_DETERMINISTIC_QUIRKS.md`; `docs/function-lane/FUNCTION_SLICE_XMATCH_CONTRACT_PRELIM.md`; `docs/function-lane/XMATCH_EXECUTION_RECORD.md`; `docs/function-lane/XMATCH_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/XMATCH_PROBE_RUNTIME_REQUIREMENTS.md`; `tools/xmatch-probe/run-xmatch-excel-baseline.ps1`; `tools/xmatch-probe/run-xmatch-suite.ps1`; `tools/xmatch-probe/analyze-xmatch-results.ps1`; `formal/lean/OxFunc/Functions/Xmatch.lean`; `formal/lean/OxFunc/Functions/XmatchSurface.lean`; `crates/oxfunc_core/src/functions/xmatch.rs`; `crates/oxfunc_core/src/functions/xmatch_surface.rs`; `docs/function-lane/FUNCTION_SLICE_CORRELATION_LEDGER.csv` | Seed captures deterministic exact-match/default/reverse lanes and explicit unsupported-mode boundaries. Empirical baseline replay closure is tracked by `W6-XMATCH-BL-20260308`. |
| `W6-XMATCH-BL-20260308` | W6 `XMATCH` empirical baseline (mode/coercion/array/reference/error/persistence lanes) | provisional | `docs/function-lane/XMATCH_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/XMATCH_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/XMATCH_EXECUTION_RECORD.md`; `tools/xmatch-probe/run-xmatch-suite.ps1`; `.tmp/xmatch-results-default.csv`; `.tmp/xmatch-results-compat.csv`; `.tmp/xmatch-results-excel.csv`; `.tmp/xmatch-analysis-report.csv`; `.tmp/xmatch-analysis-summary.json` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, locale `en-US`. Dual-run baseline captured `40` rows (`38` observed + `2` intentional admission failures) with `expectation_mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. |
| `W6-XMATCH-EXP-20260310` | W6 `XMATCH` expanded empirical matrix (blank-vs-empty, binary duplicates, binary invalid-result, XLL differential follow-up) | provisional | `docs/function-lane/XMATCH_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/LOOKUP_XLL_BRIDGE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/XMATCH_EXECUTION_RECORD.md`; `tools/xmatch-probe/run-xmatch-suite.ps1`; `tools/xll-addin/run-lookup-xll-bridge-suite.ps1`; `.tmp/lookup-pass/xmatch-results-default.csv`; `.tmp/lookup-pass/xmatch-results-compat.csv`; `.tmp/lookup-pass/xmatch-results-excel.csv`; `.tmp/lookup-pass/xmatch-analysis-summary.json`; `.tmp/lookup-pass/lookup-xll-bridge-results.csv` | Local follow-up on `2026-03-10`: dual-run XMATCH replay captured `56` rows (`54` observed + `2` intentional admission failures) with `expectation_mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. Array-constant XLL bridge parity rows for `XMATCH` also matched after the binary/blank/defaulting fixes landed. |
| `W9-XLL-BL-20260308` | W9 XLL add-in bridge baseline (`OxFunc64.xll` build + registration + native-vs-bridge workbook replay) | provisional | `docs/worksets/W009_XLL_ADDIN_BRIDGE.md`; `docs/function-lane/XLL_ADDIN_BRIDGE_SHIM_CONTRACT_PRELIM.md`; `docs/function-lane/XLL_ADDIN_BRIDGE_REGISTRATION_NOTES.md`; `docs/function-lane/XLL_ADDIN_BRIDGE_VALIDATION_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/XLL_ADDIN_BRIDGE_EXECUTION_RECORD.md`; `crates/oxfunc_core/src/xll_export_specs.rs`; `tools/xll-addin/oxfunc_xll/*`; `tools/xll-addin/sync-export-specs.ps1`; `tools/xll-addin/build-oxfunc-xll.ps1`; `tools/xll-addin/run-oxfunc-xll-bridge-baseline.ps1`; `.tmp/oxfunc-xll-bridge-results.csv`; `.tmp/xll-housekeeping/oxfunc-xll-bridge-results.csv`; `.tmp/xll-arity-fix/oxfunc-xll-bridge-results.csv`; `.tmp/textjoin-closeout/oxfunc-xll-bridge-results.csv`; `.tmp/exact-clean-closeout/oxfunc-xll-bridge-results.csv`; `.tmp/w12-final-xll/oxfunc-xll-bridge-results.csv` | Excel `16.0 (build 19725)`, channel `http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60`, locale `en-US`. Current baseline replay covers `28` rows with `matched=28`, `mismatched=0`. ABS/PI/scalar rows remain green, aggregate `SUM` rows match through the bridge after capping high-arity `type_text` and omitting oversized `arg_names`, lookup/reference rows remain green, admitted `TEXTJOIN` flattening rows match through the bridge after trimming trailing omitted XLL arguments before core dispatch, `EXACT` comparison rows are green, `DATE(1900,1,0)` now matches after rebuilding the XLL against the serial-zero fix, and the extra-`CLEAN`-C1 row is now parity-closed as well. |
| `W10-TENMIX-SEED-20260308` | W10 ten-function mixed-seam scaffolding packet (contracts + Rust/Lean slices + scenario packs + side-notes) | provisional | `docs/worksets/W010_TEN_FUNCTION_MIXED_SEAMS.md`; `docs/function-lane/W10_EXECUTION_RECORD.md`; `docs/function-lane/FUNCTION_SLICE_*_CONTRACT_PRELIM.md` (W10 set); `docs/function-lane/W10_S1_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_S2_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_S3_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_S4_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W10_PROFILE_SYSTEM_SIDE_NOTES.md`; `tools/w10-probe/run-w10-suite.ps1`; `tools/w10-probe/analyze-w10-results.ps1`; `tools/w10-probe/new-w10-compat-template.ps1`; `crates/oxfunc_core/src/functions/*`; `formal/lean/OxFunc/Functions/*`; `.tmp/w10-results-default.csv`; `.tmp/w10-results-compat.csv`; `.tmp/w10-results-excel.csv`; `.tmp/w10-analysis-report.csv`; `.tmp/w10-analysis-summary.json` | Local rerun through `2026-03-11`: `cargo test -p oxfunc_core`, `cargo check --manifest-path tools/xll-addin/oxfunc_xll/Cargo.toml`, `tools/xll-addin/sync-export-specs.ps1`, and `lake build` passed. Excel empirical replay executed with dual labels (`default` + `compat_template`) over `90` rows (`matched=90`, `mismatched=0`, `failed_unexpected=0`, `dual_run_satisfied=true`). W10 is now packet-complete for the current phase; all ten functions satisfy current-phase closure individually, with remaining open items limited to external XLL verification-seam constraints. |
| `W10-LOOKUP-XLL-20260310` | W10 lookup-family expansion and XLL differential follow-up (`MATCH`, `XLOOKUP`) | provisional | `docs/function-lane/W10_S2_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_S4_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/LOOKUP_XLL_BRIDGE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_EXECUTION_RECORD.md`; `tools/w10-probe/run-w10-suite.ps1`; `tools/xll-addin/run-lookup-xll-bridge-suite.ps1`; `.tmp/lookup-pass/w10-results-default.csv`; `.tmp/lookup-pass/w10-results-compat.csv`; `.tmp/lookup-pass/w10-results-excel.csv`; `.tmp/lookup-pass/w10-analysis-summary.json`; `.tmp/lookup-pass/lookup-xll-bridge-results.csv`; `.tmp/xll-housekeeping/lookup-xll-bridge-results.csv` | Local follow-up through `2026-03-11`: W10 dual-run replay captured `84` rows with `matched=84`, `mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. The dedicated lookup XLL bridge manifest now captures `17` rows with all relation checks matched, including `MATCH` approximate-unsorted rows, `XLOOKUP` blank lookup rows, and `XLOOKUP` reference-return address/range-composition parity. |
| `W10-CLOSEOUT-20260311` | W10 INDEX / INDIRECT / SEQUENCE closure follow-up | provisional | `docs/function-lane/W10_S2_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_S3_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_S4_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W10_EXECUTION_RECORD.md`; `docs/worksets/W010_TEN_FUNCTION_MIXED_SEAMS.md`; `tools/w10-probe/run-w10-suite.ps1`; `.tmp/w10-closeout/w10-results-default.csv`; `.tmp/w10-closeout/w10-results-compat.csv`; `.tmp/w10-closeout/w10-results-excel.csv`; `.tmp/w10-closeout/w10-analysis-summary.json`; `crates/oxfunc_core/src/functions/a1_refs.rs`; `crates/oxfunc_core/src/functions/index.rs`; `crates/oxfunc_core/src/functions/indirect.rs`; `crates/oxfunc_core/src/functions/sequence.rs`; `formal/lean/OxFunc/Functions/Index.lean`; `formal/lean/OxFunc/Functions/Indirect.lean`; `formal/lean/OxFunc/Functions/Sequence.lean` | Local follow-up on `2026-03-11`: W10 dual-run replay captured `122` rows with `matched=122`, `mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. This closeout pinned INDEX omitted row/column defaults and same-sheet multi-area `area_num`, INDIRECT explicit-blank `a1_style` behavior plus whole-axis references, and SEQUENCE omitted middle-argument defaults with payload materialization. |
| `W11-XLL-FLAGS-BL-20260309` | W11 XLL registration-flag evidence lane (`!`, `$`, `#`) | provisional | `docs/worksets/W011_XLL_REGISTRATION_FLAGS_EVIDENCE.md`; `docs/function-lane/XLL_REGISTRATION_FLAG_EVIDENCE_PLAN.md`; `docs/function-lane/XLL_REGISTRATION_FLAG_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/XLL_REGISTRATION_FLAG_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/XLL_REGISTRATION_FLAG_EXECUTION_RECORD.md`; `tools/xll-addin/run-registration-flag-evidence.ps1`; `tools/xll-addin/run-registration-flag-suite.ps1`; `tools/xll-addin/analyze-registration-flag-results.ps1`; `.tmp/xll-registration-flags-results-default.csv`; `.tmp/xll-registration-flags-results-compat.csv`; `.tmp/xll-registration-flags-results-excel.csv`; `.tmp/xll-registration-flags-analysis-report.csv`; `.tmp/xll-registration-flags-analysis-summary.json` | Local rerun through `2026-03-10`: `18` observed rows across dual labels (`default` + `compat_template`) with `matched=16`, `mismatched=2`, `failed=0`, `dual_run_satisfied=true`. Experimental volatile control alias `ox_NOW_F_BASE()` still changed unexpectedly, but user-facing `ox_NOW()` and `ox_RAND()` now tick alongside built-in `NOW()` and `RAND()` after ordinary `volatile_full` export mapping was enabled in generated registration text. Thread-safe lane remains parity-only (no concurrency trace yet); macro lane remains admission-only under current reference-return bridge bounds. |
| `W9-XLL-NIL-20260312` | W9 XLL raw `xltypeNil` propagation/publication characterization | provisional | `docs/function-lane/XLL_NIL_PROPAGATION_EXECUTION_RECORD.md`; `docs/function-lane/XLL_NIL_PROPAGATION_SCENARIO_MANIFEST_SEED.csv`; `tools/xll-addin/run-xll-nil-probe.ps1`; `tools/xll-addin/oxfunc_xll/src/lib.rs`; `.tmp/xll-nil-probe-results.csv` | Local probe on `2026-03-12`: direct scalar raw `xltypeNil` returned through the XLL published as numeric zero and outer functions/operators observed it as number/zero rather than `empty_cell`. Raw `xltypeNil` array elements, however, remained visible to outer XLL observers as `empty_cell`-like array elements until scalarization/publication, after which they also collapsed to numeric-zero semantics. |
| `W10-W12-TFMT-20260310` | Built-in time/date format-hint baseline (`NOW`, `TODAY`) | provisional | `docs/function-lane/TIME_FORMAT_HINT_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/TIME_FORMAT_HINT_EXECUTION_RECORD.md`; `tools/time-format-hint-probe/run-time-format-hint-baseline.ps1`; `tools/time-format-hint-probe/run-time-format-hint-suite.ps1`; `.tmp/time-format-hint-results-default.csv`; `.tmp/time-format-hint-results-compat.csv`; `.tmp/time-format-hint-results.csv`; `.tmp/time-format-hint-summary.json` | Local dual-run suite on `2026-03-10`: `8` observed rows (`4` default + `4` compat_template) with `matched=8`, `mismatched=0`, `failed=0`, and `dual_run_satisfied=true`. Built-in `NOW()` changed a `General` caller cell to `yyyy/mm/dd hh:mm`, `TODAY()` changed a `General` caller cell to `yyyy/mm/dd`, and both functions preserved an explicit preformatted `0.000` caller format in the observed baseline. This evidence characterizes post-evaluation format-hinting as part of current-phase function semantics while leaving application responsibility to the engine/FEC/F3E layer. |
| `W12-CELL-PRE-20260309` | W12 bounded `CELL` pre-implementation empirical probe | provisional | `docs/function-lane/W12_CELL_PRE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_PROBE_RUNTIME_REQUIREMENTS.md`; `tools/w12-probe/run-w12-cell-preprobe.ps1`; `tools/w12-probe/run-w12-suite.ps1`; `tools/w12-probe/analyze-w12-results.ps1`; `.tmp/w12-cell-pre-results-default.csv`; `.tmp/w12-cell-pre-results-compat.csv`; `.tmp/w12-cell-pre-results-excel.csv`; `.tmp/w12-cell-pre-analysis-report.csv`; `.tmp/w12-cell-pre-analysis-summary.json` | Local dual-run preprobe on `2026-03-09`: `10` observed rows (`5` default + `5` compat_template) with `matched=10`, `mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. Selected bounded W12 `CELL` scope: `address`, `row`, `col`, `contents`, and `type` for explicit two-argument reference form only. |
| `W12-MODERATE-BL-20260309` | W12 moderate fifteen-function expansion baseline | provisional | `docs/worksets/W012_MODERATE_FUNCTION_EXPANSION.md`; `docs/function-lane/W12_EXECUTION_RECORD.md`; `docs/function-lane/W12_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W12_S1_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_S2_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_S3_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_S4_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_S5_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_S6_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W12_PROFILE_SYSTEM_SIDE_NOTES.md`; `docs/function-lane/FUNCTION_SLICE_*_CONTRACT_PRELIM.md` (W12 set); `tools/w12-probe/run-w12-suite.ps1`; `tools/w12-probe/analyze-w12-results.ps1`; `tools/w12-probe/new-w12-compat-template.ps1`; `crates/oxfunc_core/src/functions/*`; `formal/lean/OxFunc/Functions/*`; `.tmp/w12-results-default.csv`; `.tmp/w12-results-compat.csv`; `.tmp/w12-results-excel.csv`; `.tmp/w12-analysis-report.csv`; `.tmp/w12-analysis-summary.json`; `.tmp/textjoin-closeout/w12-results-default.csv`; `.tmp/textjoin-closeout/w12-results-compat.csv`; `.tmp/textjoin-closeout/w12-results-excel.csv`; `.tmp/textjoin-closeout/w12-analysis-summary.json`; `.tmp/exact-clean-closeout/w12-results-default.csv`; `.tmp/exact-clean-closeout/w12-results-compat.csv`; `.tmp/exact-clean-closeout/w12-results-excel.csv`; `.tmp/exact-clean-closeout/w12-analysis-summary.json`; `.tmp/w12-final-closeout-7/w12-results-default.csv`; `.tmp/w12-final-closeout-7/w12-results-compat.csv`; `.tmp/w12-final-closeout-7/w12-results-excel.csv`; `.tmp/w12-final-closeout-7/w12-analysis-summary.json` | Local rerun through `2026-03-12`: `cargo test -p oxfunc_core`, `tools/w12-probe/run-w12-suite.ps1`, and `lake build` passed. Excel dual-run baseline now captures `112` observed rows (`56` default + `56` compat_template) with `matched=112`, `mismatched=0`, `failed_unexpected=0`, and `dual_run_satisfied=true`. The added rows close the aggregate trio (`AVERAGE`/`COUNT`/`COUNTA`), `IFERROR`, `ROUND`, `RAND`, `DATE`, `AND`, `OFFSET`, and `HSTACK`. The W12 suite now reruns seven mixed reference/dynamic rows in isolated out-of-process invocations before final analysis because the in-process combined runner showed Excel COM instability on those rows even though the isolated cases matched cleanly. |

| `W13-NONLOCALE-BL-20260314` | W13 non-locale boundary-function closure (`SIN`,`ASIN`,`N`,`T`,`TYPE`,`ROW`,`COLUMN`) | provisional | `docs/worksets/W013_DECEPTIVELY_SIMPLE_BOUNDARY_FUNCTIONS.md`; `docs/function-lane/W13_EXECUTION_RECORD.md`; `docs/function-lane/FUNCTION_SLICE_SIN_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_ASIN_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_N_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_T_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_TYPE_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_ROW_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_COLUMN_CONTRACT_PRELIM.md`; `formal/lean/OxFunc/Functions/Sin.lean`; `formal/lean/OxFunc/Functions/Asin.lean`; `formal/lean/OxFunc/Functions/N.lean`; `formal/lean/OxFunc/Functions/T.lean`; `formal/lean/OxFunc/Functions/Type.lean`; `formal/lean/OxFunc/Functions/Row.lean`; `formal/lean/OxFunc/Functions/Column.lean` | Local follow-up on `2026-03-14`: the remaining W13 functions are now characterized for the current reference baseline, including `ASIN` domain failure, `N/T/TYPE` blank single-cell semantics, and `ROW/COLUMN` caller-context plus one-dimensional spill behavior. |
| `W13-LOCALE-SHIM-20260314` | W13 local locale-format seam closure (`VALUE`,`TEXT`,`DOLLAR`,`FIXED` substrate and host/en-US shim) | provisional | `docs/function-lane/LOCALE_FORMAT_SEAM_EXECUTION_RECORD.md`; `docs/function-lane/FORMAT_PROFILE_SEED.csv`; `docs/function-lane/VALUE_PARSE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/FORMAT_RENDER_SCENARIO_MANIFEST_SEED.csv`; `crates/oxfunc_core/src/locale_format.rs`; `crates/oxfunc_core/src/functions/value_fn.rs`; `crates/oxfunc_core/src/functions/text_fn.rs`; `crates/oxfunc_core/src/functions/dollar_fn.rs`; `crates/oxfunc_core/src/functions/fixed_fn.rs`; `formal/lean/OxFunc/LocaleFormat.lean`; `formal/lean/OxFunc/Functions/Value.lean`; `formal/lean/OxFunc/Functions/Text.lean`; `formal/lean/OxFunc/Functions/Dollar.lean`; `formal/lean/OxFunc/Functions/Fixed.lean` | Local seam closure on `2026-03-14`: explicit `en-US` plus `current_excel_host` profiles, admitted parser/render subset, Rust tests, and Lean executable substrate all in place. The admitted local parse/render slice is now sufficient for current-phase function closure of the four locale-sensitive W13 functions; broader locale/format-language expansion remains an orthogonal validation phase. |
| `W9-XLL-GETINFO-20260314` | W9 tester-XLL legacy `GET.*` wrapper evidence | provisional | `docs/function-lane/XLL_GET_INFO_EXECUTION_RECORD.md`; `docs/function-lane/XLL_GET_INFO_SCENARIO_MANIFEST_SEED.csv`; `tools/xll-addin/run-get-info-probe.ps1`; `tools/xll-addin/oxfunc_xll/src/lib.rs` | Local probe on `2026-03-14`: tester `OxFunc64.xll` exposes worksheet-callable wrappers for selected `GET.CELL`, `GET.WORKBOOK`, and `GET.WORKSPACE` lanes so locale/profile and cell-info behavior can be exercised without the Excel-DNA sample add-in. |
| `W15-INFO-PRE-20260315` | W15 `INFO(type_text)` dual-run empirical baseline | provisional | `docs/worksets/W015_CELL_AND_INFO_HOST_QUERY_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_INFO_CONTRACT_PRELIM.md`; `docs/function-lane/CELL_INFO_HOST_QUERY_SEAM_PRELIM.md`; `docs/function-lane/W15_INFO_PRE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W15_EXECUTION_RECORD.md`; `tools/w15-probe/run-w15-info-preprobe.ps1`; `.tmp/w15-info-pre-results.csv`; `.tmp/w15-info-pre-results-compat.csv` | Dual-run probe on `2026-03-15` captured current-host `INFO` outcomes for `directory`, `numfile`, `origin`, `osversion`, `recalc`, `release`, `system`, and the memory lanes on both `default` and `compat_template` workbook descriptors. Both runs observed `#N/A` for `memavail`, `memused`, and `totmem`. Replay-adapter binding candidate: packet manifests and result CSVs remain local packet schemas, with these rows feeding `manifest_row_result_view` and `evidence_binding_view`. |
| `W15-CELL-HOST-PRE-20260315` | W15 `CELL` host-sensitive and omitted-reference dual-run baseline | provisional | `docs/worksets/W015_CELL_AND_INFO_HOST_QUERY_FUNCTIONS.md`; `docs/function-lane/CELL_INFO_HOST_QUERY_SEAM_PRELIM.md`; `docs/function-lane/W15_CELL_HOST_PRE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W15_PROBE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W15_EXECUTION_RECORD.md`; `tools/w15-probe/run-w15-cell-host-preprobe.ps1`; `.tmp/w15-cell-host-pre-results.csv`; `.tmp/w15-cell-host-pre-results-compat.csv` | Dual-run probe on `2026-03-15` pinned explicit-reference, omitted-reference, width-array, and cross-sheet `CELL` lanes across `default` and `compat_template` workbook descriptors. The omitted-reference matrix now covers the admitted `row`, `address`, `col`, `contents`, `type`, `filename`, `format`, `color`, `prefix`, `protect`, `width`, and `parentheses` lanes. Replay-adapter binding candidate: these rows demonstrate packet-first host-query explanation without needing an internal event stream. |
| `W15-XLL-BRIDGE-20260315` | W15 `CELL` / `INFO` XLL bridge dual-run parity baseline | provisional | `docs/worksets/W015_CELL_AND_INFO_HOST_QUERY_FUNCTIONS.md`; `docs/function-lane/W15_XLL_BRIDGE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W15_EXECUTION_RECORD.md`; `tools/w15-probe/run-w15-xll-bridge.ps1`; `tools/xll-addin/build-oxfunc-xll.ps1`; `.tmp/w15-xll-bridge-results.csv`; `.tmp/w15-xll-bridge-results-compat.csv` | Dual-run parity replay on `2026-03-15` matched generated `ox_INFO(...)` exports against native `INFO(...)` for all ten seeded lanes and generated `ox_CELL(...)` exports against native `CELL(...)` for explicit-reference, omitted-reference active-selection, width-array, and cross-sheet lanes on both `default` and `compat_template` workbook descriptors. Provider-backed generated `ox_CELL` / `ox_INFO` exports still worked without the `#` macro-type suffix in this path. Replay-adapter binding candidate: this row is the first concrete example where diff/explain must preserve XLL seam qualification rather than defaulting every mismatch to a semantic failure. |
| `W16-INVENTORY-FREEZE-20260315` | W16 authoritative non-interesting-function inventory freeze | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_NON_INTERESTING_REMAINING_INVENTORY.csv`; `docs/function-lane/W16_NON_INTERESTING_REMAINING_CATEGORY_COUNTS.csv`; `docs/function-lane/W16_EXECUTION_RECORD.md` | Local inventory freeze on `2026-03-15` fixed the initial W16 named-function scope at `412` rows after subtracting locally tracked interesting functions and already-closed non-interesting rows from the `500`-row authoritative catalog. |
| `W16-BATCH1-UNARY-NUMERIC-20260315` | W16 Batch 1 pure unary numeric family baseline (`ACOS`,`ACOSH`,`ATAN`,`COS`,`COSH`,`DEGREES`,`EXP`,`RADIANS`,`SINH`,`TAN`,`TANH`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH1_UNARY_NUMERIC_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `crates/oxfunc_core/src/functions/unary_numeric.rs`; `crates/oxfunc_core/src/functions/acos.rs`; `crates/oxfunc_core/src/functions/acosh.rs`; `crates/oxfunc_core/src/functions/atan.rs`; `crates/oxfunc_core/src/functions/cos.rs`; `crates/oxfunc_core/src/functions/cosh.rs`; `crates/oxfunc_core/src/functions/degrees.rs`; `crates/oxfunc_core/src/functions/exp_fn.rs`; `crates/oxfunc_core/src/functions/radians.rs`; `crates/oxfunc_core/src/functions/sinh.rs`; `crates/oxfunc_core/src/functions/tan.rs`; `crates/oxfunc_core/src/functions/tanh.rs`; `formal/lean/OxFunc/Functions/Acos.lean`; `formal/lean/OxFunc/Functions/Acosh.lean`; `formal/lean/OxFunc/Functions/Atan.lean`; `formal/lean/OxFunc/Functions/Cos.lean`; `formal/lean/OxFunc/Functions/Cosh.lean`; `formal/lean/OxFunc/Functions/Degrees.lean`; `formal/lean/OxFunc/Functions/Exp.lean`; `formal/lean/OxFunc/Functions/Radians.lean`; `formal/lean/OxFunc/Functions/Sinh.lean`; `formal/lean/OxFunc/Functions/Tan.lean`; `formal/lean/OxFunc/Functions/Tanh.lean` | Local batch wiring on `2026-03-15` established the reusable values-only unary numeric helper and admitted eleven low-seam math functions through runtime dispatch, generated XLL exports, and Lean bindings. |
| `W16-BATCH2-TRIG-DOMAIN-20260315` | W16 Batch 2 domain-aware trig family baseline (`ACOT`,`ACOTH`,`ASINH`,`ATAN2`,`ATANH`,`COT`,`COTH`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH2_TRIG_DOMAIN_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch2-trig-probe.csv`; `crates/oxfunc_core/src/functions/acot.rs`; `crates/oxfunc_core/src/functions/acoth.rs`; `crates/oxfunc_core/src/functions/asinh.rs`; `crates/oxfunc_core/src/functions/atan2.rs`; `crates/oxfunc_core/src/functions/atanh.rs`; `crates/oxfunc_core/src/functions/cot.rs`; `crates/oxfunc_core/src/functions/coth.rs`; `formal/lean/OxFunc/Functions/Acot.lean`; `formal/lean/OxFunc/Functions/Acoth.lean`; `formal/lean/OxFunc/Functions/Asinh.lean`; `formal/lean/OxFunc/Functions/Atan2.lean`; `formal/lean/OxFunc/Functions/Atanh.lean`; `formal/lean/OxFunc/Functions/Cot.lean`; `formal/lean/OxFunc/Functions/Coth.lean` | Native Excel COM spot probe on `2026-03-15` pinned the critical singularity lanes for the batch and the local runtime/formal wiring carries those `#NUM!` / `#DIV/0!` outcomes through the standard values-only math seam. |
| `W16-BATCH3-LOG-SQRT-20260315` | W16 Batch 3 log and square-root family baseline (`LN`,`LOG10`,`SQRT`,`SQRTPI`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH3_LOG_SQRT_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch3-log-sqrt-probe.csv`; `crates/oxfunc_core/src/functions/ln_fn.rs`; `crates/oxfunc_core/src/functions/log10_fn.rs`; `crates/oxfunc_core/src/functions/sqrt_fn.rs`; `crates/oxfunc_core/src/functions/sqrtpi.rs`; `formal/lean/OxFunc/Functions/Ln.lean`; `formal/lean/OxFunc/Functions/Log10.lean`; `formal/lean/OxFunc/Functions/Sqrt.lean`; `formal/lean/OxFunc/Functions/SqrtPi.lean` | Native Excel COM spot probe on `2026-03-15` pinned the expected `#NUM!` boundary lanes for the batch and the local runtime/formal wiring carries those outcomes through the same unary numeric helper seam. |
| `W16-BATCH4-INTEGER-SIGN-20260315` | W16 Batch 4 integer-rounding and sign family baseline (`INT`,`SIGN`,`EVEN`,`ODD`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH4_INTEGER_SIGN_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch4-integer-sign-probe.csv`; `crates/oxfunc_core/src/functions/int_fn.rs`; `crates/oxfunc_core/src/functions/sign_fn.rs`; `crates/oxfunc_core/src/functions/even_fn.rs`; `crates/oxfunc_core/src/functions/odd_fn.rs`; `formal/lean/OxFunc/Functions/IntFn.lean`; `formal/lean/OxFunc/Functions/Sign.lean`; `formal/lean/OxFunc/Functions/Even.lean`; `formal/lean/OxFunc/Functions/Odd.lean` | Native Excel COM spot probe on `2026-03-15` pinned the negative-number rounding behavior for the batch and the local runtime/formal wiring carries those outcomes through the same unary numeric helper seam. |
| `W16-BATCH5-RECIPROCAL-TRIG-20260315` | W16 Batch 5 reciprocal trig family baseline (`CSC`,`CSCH`,`SEC`,`SECH`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH5_RECIPROCAL_TRIG_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch5-reciprocal-trig-probe.csv`; `crates/oxfunc_core/src/functions/csc.rs`; `crates/oxfunc_core/src/functions/csch.rs`; `crates/oxfunc_core/src/functions/sec.rs`; `crates/oxfunc_core/src/functions/sech.rs`; `formal/lean/OxFunc/Functions/Csc.lean`; `formal/lean/OxFunc/Functions/Csch.lean`; `formal/lean/OxFunc/Functions/Sec.lean`; `formal/lean/OxFunc/Functions/Sech.lean` | Native Excel COM spot probe on `2026-03-15` pinned the reciprocal singularity lanes for the batch and the local runtime/formal wiring carries those outcomes through the same unary numeric helper seam. |
| `W16-BATCH6-FACTORIAL-20260315` | W16 Batch 6 factorial family baseline (`FACT`,`FACTDOUBLE`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH6_FACTORIAL_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch6-factorial-probe.csv`; `crates/oxfunc_core/src/functions/factorial_common.rs`; `crates/oxfunc_core/src/functions/fact.rs`; `crates/oxfunc_core/src/functions/factdouble.rs`; `formal/lean/OxFunc/Functions/Fact.lean`; `formal/lean/OxFunc/Functions/FactDouble.lean` | Native Excel COM spot probe on `2026-03-15` pinned the truncation and negative-boundary behavior for the factorial family, including the empirical `FACTDOUBLE(-1) -> 1` lane, and the local runtime/formal wiring carries those outcomes through the same unary numeric helper seam. |
| `W16-BATCH7-BINARY-NUMERIC-20260315` | W16 Batch 7 binary numeric scalar baseline (`POWER`,`MOD`,`QUOTIENT`,`MROUND`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH7_BINARY_NUMERIC_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch7-binary-probe.csv`; `crates/oxfunc_core/src/functions/binary_numeric.rs`; `crates/oxfunc_core/src/functions/power_fn.rs`; `crates/oxfunc_core/src/functions/mod_fn.rs`; `crates/oxfunc_core/src/functions/quotient_fn.rs`; `crates/oxfunc_core/src/functions/mround.rs`; `formal/lean/OxFunc/Functions/PowerFn.lean`; `formal/lean/OxFunc/Functions/ModFn.lean`; `formal/lean/OxFunc/Functions/QuotientFn.lean`; `formal/lean/OxFunc/Functions/Mround.lean` | Native Excel COM spot probe on `2026-03-15` pinned the exact-binary sign, midpoint, and singularity lanes for the batch and the local runtime/formal wiring carries those outcomes through a reusable binary numeric helper seam. |
| `W16-BATCH8-COMBINATORICS-20260315` | W16 Batch 8 discrete combinatorics baseline (`COMBIN`,`COMBINA`,`MULTINOMIAL`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH8_COMBINATORICS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch8-combinatorics-probe.csv`; `.tmp/w16-batch8-combinatorics-edge-probe.csv`; `crates/oxfunc_core/src/functions/combinatorics_common.rs`; `crates/oxfunc_core/src/functions/combin.rs`; `crates/oxfunc_core/src/functions/combina.rs`; `crates/oxfunc_core/src/functions/multinomial.rs`; `formal/lean/OxFunc/Functions/Combin.lean`; `formal/lean/OxFunc/Functions/Combina.lean`; `formal/lean/OxFunc/Functions/Multinomial.lean` | Native Excel COM spot probes on `2026-03-15` pinned the truncation and domain lanes for the combinatorics batch, including `COMBINA(0,0) -> 1`, `COMBINA(0,1) -> #NUM!`, and `MULTINOMIAL(0,0) -> 1`. |
| `W16-BATCH9-GCD-LCM-20260315` | W16 Batch 9 integer divisor/reducer baseline (`GCD`,`LCM`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH9_GCD_LCM_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch9-gcd-lcm-probe.csv`; `crates/oxfunc_core/src/functions/gcd_lcm_common.rs`; `crates/oxfunc_core/src/functions/gcd_fn.rs`; `crates/oxfunc_core/src/functions/lcm_fn.rs`; `formal/lean/OxFunc/Functions/GcdFn.lean`; `formal/lean/OxFunc/Functions/LcmFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the truncation, zero, and negative-input lanes for `GCD`/`LCM`, including `GCD(0,0) -> 0`, `LCM(0,0) -> 0`, and `LCM(-1,5) -> #NUM!`. |
| `W16-BATCH10-BITOPS-20260315` | W16 Batch 10 bitwise integer baseline (`BITAND`,`BITOR`,`BITXOR`,`BITLSHIFT`,`BITRSHIFT`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH10_BITOPS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch10-bitops-probe.csv`; `.tmp/w16-batch10-bitops-edge-probe.csv`; `crates/oxfunc_core/src/functions/bit_common.rs`; `crates/oxfunc_core/src/functions/bitand_fn.rs`; `crates/oxfunc_core/src/functions/bitor_fn.rs`; `crates/oxfunc_core/src/functions/bitxor_fn.rs`; `crates/oxfunc_core/src/functions/bitlshift_fn.rs`; `crates/oxfunc_core/src/functions/bitrshift_fn.rs`; `formal/lean/OxFunc/Functions/BitAndFn.lean`; `formal/lean/OxFunc/Functions/BitOrFn.lean`; `formal/lean/OxFunc/Functions/BitXorFn.lean`; `formal/lean/OxFunc/Functions/BitLshiftFn.lean`; `formal/lean/OxFunc/Functions/BitRshiftFn.lean` | Native Excel COM spot probes on `2026-03-15` pinned the bitwise integer-domain lanes, including reverse-direction negative shift counts, the `281474976710655` operand ceiling, and `#NUM!` on out-of-range shifts. |
| `W16-BATCH11-CONSTANTS-THRESHOLDS-20260315` | W16 Batch 11 constants and thresholds baseline (`TRUE`,`FALSE`,`NA`,`DELTA`,`GESTEP`,`TRUNC`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH11_CONSTANTS_THRESHOLDS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch11-constants-thresholds-probe.csv`; `crates/oxfunc_core/src/functions/true_fn.rs`; `crates/oxfunc_core/src/functions/false_fn.rs`; `crates/oxfunc_core/src/functions/na_fn.rs`; `crates/oxfunc_core/src/functions/delta_fn.rs`; `crates/oxfunc_core/src/functions/gestep_fn.rs`; `crates/oxfunc_core/src/functions/trunc_fn.rs`; `formal/lean/OxFunc/Functions/TrueFn.lean`; `formal/lean/OxFunc/Functions/FalseFn.lean`; `formal/lean/OxFunc/Functions/NaFn.lean`; `formal/lean/OxFunc/Functions/DeltaFn.lean`; `formal/lean/OxFunc/Functions/GestepFn.lean`; `formal/lean/OxFunc/Functions/TruncFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the nullary constant, threshold, and truncation lanes, including `NA() -> #N/A`, `GESTEP(5) -> 1`, and `TRUNC(314.159,-10) -> 0`. |
| `W16-BATCH12-PRODUCT-SUMSQ-20260315` | W16 Batch 12 aggregate arithmetic baseline (`PRODUCT`,`SUMSQ`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH12_PRODUCT_SUMSQ_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch12-product-sumsq-probe.csv`; `crates/oxfunc_core/src/functions/product.rs`; `crates/oxfunc_core/src/functions/sumsq.rs`; `formal/lean/OxFunc/Functions/Product.lean`; `formal/lean/OxFunc/Functions/SumSq.lean` | Native Excel COM spot probe on `2026-03-15` pinned the direct-scalar vs reference-derived inclusion lanes for the aggregate arithmetic batch, including `PRODUCT(TRUE,\"2\") -> 2`, `PRODUCT(G1:G2) -> 0`, and `SUMSQ(G1:G3) -> #N/A`. |
| `W16-BATCH13-LOGICAL-AGGREGATES-20260315` | W16 Batch 13 logical aggregate baseline (`OR`,`XOR`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH13_LOGICAL_AGGREGATES_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch13-logical-probe.csv`; `crates/oxfunc_core/src/functions/or_fn.rs`; `crates/oxfunc_core/src/functions/xor_fn.rs`; `formal/lean/OxFunc/Functions/OrFn.lean`; `formal/lean/OxFunc/Functions/XorFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the direct-text vs reference-derived inclusion lanes for the logical aggregate batch, including `OR(\"x\") -> #VALUE!`, `OR(A1:A2) -> #VALUE!`, and `XOR(TRUE,FALSE,TRUE) -> FALSE`. |
| `W16-BATCH14-MIN-MAX-20260315` | W16 Batch 14 extremum aggregate baseline (`MIN`,`MAX`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH14_MIN_MAX_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch14-min-max-probe.csv`; `crates/oxfunc_core/src/functions/min_fn.rs`; `crates/oxfunc_core/src/functions/max_fn.rs`; `formal/lean/OxFunc/Functions/MinFn.lean`; `formal/lean/OxFunc/Functions/MaxFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the direct-scalar vs reference-derived inclusion lanes for the extremum aggregate batch, including `MAX(TRUE,\"2\") -> 2`, `MIN(TRUE,\"2\") -> 1`, and `MAX(G1:G2) -> 0`. |
| `W16-BATCH15-MINA-MAXA-20260315` | W16 Batch 15 inclusive extremum baseline (`MINA`,`MAXA`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH15_MINA_MAXA_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch15-mina-maxa-probe.csv`; `crates/oxfunc_core/src/functions/mina_fn.rs`; `crates/oxfunc_core/src/functions/maxa_fn.rs`; `formal/lean/OxFunc/Functions/MinAFn.lean`; `formal/lean/OxFunc/Functions/MaxAFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the inclusive-reference aggregate lanes for the batch, including `MAXA(G1:G2) -> 1`, `MINA(G1:G2) -> 0`, and `MAXA(\"x\") -> #VALUE!`. |
| `W16-BATCH16-NOT-MEDIAN-20260315` | W16 Batch 16 logical negation and median baseline (`NOT`,`MEDIAN`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH16_NOT_MEDIAN_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch16-not-median-probe.csv`; `crates/oxfunc_core/src/functions/not_fn.rs`; `crates/oxfunc_core/src/functions/median_fn.rs`; `formal/lean/OxFunc/Functions/NotFn.lean`; `formal/lean/OxFunc/Functions/MedianFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the scalar coercion and empty-survivor order-statistic lanes for the batch, including `NOT(G1) -> #VALUE!`, `MEDIAN(G1:G2) -> #NUM!`, and `MEDIAN(F1:F2) -> 2.5`. |
| `W16-BATCH17-LARGE-SMALL-20260315` | W16 Batch 17 k-th order statistic baseline (`LARGE`,`SMALL`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH17_LARGE_SMALL_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch17-large-small-probe.csv`; `crates/oxfunc_core/src/functions/large_fn.rs`; `crates/oxfunc_core/src/functions/small_fn.rs`; `formal/lean/OxFunc/Functions/LargeFn.lean`; `formal/lean/OxFunc/Functions/SmallFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the rank-selection lanes for the batch, including `LARGE({TRUE,\"2\"},1) -> #NUM!`, `LARGE(F1:F3,1.9) -> 2`, and `SMALL(F1:F3,0) -> #NUM!`. |
| `W16-BATCH18-GEO-HARMEAN-20260315` | W16 Batch 18 multiplicative mean baseline (`GEOMEAN`,`HARMEAN`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH18_GEO_HARMEAN_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch18-geo-harmean-probe.csv`; `crates/oxfunc_core/src/functions/geomean_fn.rs`; `crates/oxfunc_core/src/functions/harmean_fn.rs`; `formal/lean/OxFunc/Functions/GeoMeanFn.lean`; `formal/lean/OxFunc/Functions/HarMeanFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the multiplicative mean domain and empty-survivor lanes for the batch, including `GEOMEAN(G1:G2) -> #NUM!`, `HARMEAN(G1:G2) -> #N/A`, and direct-logical coercion on `TRUE`/`FALSE`. |
| `W16-BATCH19-AVERAGEA-AVEDEV-DEVSQ-20260315` | W16 Batch 19 inclusive average and deviation baseline (`AVERAGEA`,`AVEDEV`,`DEVSQ`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH19_AVERAGEA_AVEDEV_DEVSQ_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch19-averagea-avedev-devsq-probe.csv`; `crates/oxfunc_core/src/functions/averagea_fn.rs`; `crates/oxfunc_core/src/functions/avedev_fn.rs`; `crates/oxfunc_core/src/functions/devsq_fn.rs`; `formal/lean/OxFunc/Functions/AverageAFn.lean`; `formal/lean/OxFunc/Functions/AveDevFn.lean`; `formal/lean/OxFunc/Functions/DevSqFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the inclusive-average and deviation lanes for the batch, including `AVERAGEA(G1:G2) -> 0.5`, `AVEDEV(G1:G2) -> #NUM!`, and `DEVSQ(G1:G2) -> #NUM!`. |
| `W16-BATCH20-VARIANCE-STDEV-20260315` | W16 Batch 20 variance and standard-deviation baseline (`STDEV.S`,`STDEV.P`,`STDEVA`,`STDEVPA`,`VAR.S`,`VAR.P`,`VARA`,`VARPA`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH20_VARIANCE_STDEV_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch20-stdev-var-probe.csv`; `crates/oxfunc_core/src/functions/variance_common.rs`; `crates/oxfunc_core/src/functions/stdev_s_fn.rs`; `crates/oxfunc_core/src/functions/stdev_p_fn.rs`; `crates/oxfunc_core/src/functions/stdeva_fn.rs`; `crates/oxfunc_core/src/functions/stdevpa_fn.rs`; `crates/oxfunc_core/src/functions/var_s_fn.rs`; `crates/oxfunc_core/src/functions/var_p_fn.rs`; `crates/oxfunc_core/src/functions/vara_fn.rs`; `crates/oxfunc_core/src/functions/varpa_fn.rs`; `formal/lean/OxFunc/Functions/StdevSFn.lean`; `formal/lean/OxFunc/Functions/StdevPFn.lean`; `formal/lean/OxFunc/Functions/StdevAFn.lean`; `formal/lean/OxFunc/Functions/StdevPAFn.lean`; `formal/lean/OxFunc/Functions/VarSFn.lean`; `formal/lean/OxFunc/Functions/VarPFn.lean`; `formal/lean/OxFunc/Functions/VarAFn.lean`; `formal/lean/OxFunc/Functions/VarPAFn.lean` | Native Excel COM spot probes on `2026-03-15` pinned the divisor and inclusion policy split for the batch, including `STDEV.S(TRUE) -> #DIV/0!`, `STDEVA(G1:G2) -> 0.7071067811865476`, and `VARPA(G1:G2) -> 0.25`. |
| `W16-BATCH21-VARIANCE-COMPAT-ALIASES-20260315` | W16 Batch 21 variance compatibility alias baseline (`STDEV`,`STDEVP`,`VAR`,`VARP`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH21_VARIANCE_COMPAT_ALIASES_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch21-stdev-var-compat-probe.csv`; `crates/oxfunc_core/src/functions/stdev_fn.rs`; `crates/oxfunc_core/src/functions/stdevp_fn.rs`; `crates/oxfunc_core/src/functions/var_fn.rs`; `crates/oxfunc_core/src/functions/varp_fn.rs`; `formal/lean/OxFunc/Functions/StdevFn.lean`; `formal/lean/OxFunc/Functions/StdevCompatFn.lean`; `formal/lean/OxFunc/Functions/StdevPCompatFn.lean`; `formal/lean/OxFunc/Functions/VarFn.lean`; `formal/lean/OxFunc/Functions/VarCompatFn.lean`; `formal/lean/OxFunc/Functions/VarPCompatFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned compatibility-alias parity with the modern variance substrate, including `STDEV(TRUE,"2") -> 0.7071067811865476`, `STDEVP(F1:F3) -> 1.247219128924647`, and `VARP(G1:G2) -> #DIV/0!`. |
| `W16-BATCH22-RANKING-20260315` | W16 Batch 22 ranking baseline (`RANK.EQ`,`RANK.AVG`,`RANK`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH22_RANKING_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch22-rank-probe.csv`; `.tmp/w16-batch22-rank-edge-probe.csv`; `.tmp/w16-batch22-rank-order-probe.csv`; `crates/oxfunc_core/src/functions/rank_common.rs`; `crates/oxfunc_core/src/functions/rank_eq_fn.rs`; `crates/oxfunc_core/src/functions/rank_avg_fn.rs`; `crates/oxfunc_core/src/functions/rank_fn.rs`; `formal/lean/OxFunc/Functions/RankEqFn.lean`; `formal/lean/OxFunc/Functions/RankAvgFn.lean`; `formal/lean/OxFunc/Functions/RankCompatFn.lean` | Native Excel COM spot probes on `2026-03-15` pinned the ranking lanes for the batch, including `RANK.EQ(20,F1:F4) -> 2`, `RANK.AVG(20,F1:F4) -> 2.5`, `RANK.EQ("2",F1:F4) -> #N/A`, and `RANK.EQ(20,F1:F4,"1") -> #VALUE!`. |
| `W16-BATCH23-PERMUTATIONS-20260315` | W16 Batch 23 permutation baseline (`PERMUT`,`PERMUTATIONA`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH23_PERMUTATIONS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch23-permut-probe.csv`; `crates/oxfunc_core/src/functions/permut_fn.rs`; `crates/oxfunc_core/src/functions/permutationa_fn.rs`; `formal/lean/OxFunc/Functions/PermutFn.lean`; `formal/lean/OxFunc/Functions/PermutationAFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the permutation truncation and boundary lanes for the batch, including `PERMUT(10.9,3.2) -> 720`, `PERMUT(3,4) -> #NUM!`, `PERMUTATIONA(0,0) -> 1`, and `PERMUTATIONA(0,1) -> 0`. |
| `W16-BATCH24-BASE-ARABIC-20260315` | W16 Batch 24 numeral conversion baseline (`BASE`,`ARABIC`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH24_BASE_ARABIC_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch24-base-arabic-probe.csv`; `crates/oxfunc_core/src/functions/base_fn.rs`; `crates/oxfunc_core/src/functions/arabic_fn.rs`; `formal/lean/OxFunc/Functions/BaseFn.lean`; `formal/lean/OxFunc/Functions/ArabicFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the conversion and validation lanes for the batch, including `BASE(31.9,16,4.8) -> "001F"`, `BASE(31,1) -> #NUM!`, `ARABIC("") -> 0`, and `ARABIC("ABC") -> #VALUE!`. |
| `W16-BATCH25-MODE-SNGL-20260315` | W16 Batch 25 single-mode baseline (`MODE.SNGL`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH25_MODE_SNGL_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch25-mode-sngl-probe.csv`; `crates/oxfunc_core/src/functions/mode_sngl_fn.rs`; `formal/lean/OxFunc/Functions/ModeSnglFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the single-mode lanes for the batch, including `MODE.SNGL(1,2,2,3) -> 2`, `MODE.SNGL(TRUE,"2") -> #N/A`, `MODE.SNGL("x") -> #N/A`, and tie selection `MODE.SNGL(2,2,3,3,4) -> 2`. |
| `W16-BATCH26-PERCENTILE-QUARTILE-20260315` | W16 Batch 26 percentile/quartile baseline (`PERCENTILE.INC`,`PERCENTILE.EXC`,`QUARTILE.INC`,`QUARTILE.EXC`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH26_PERCENTILE_QUARTILE_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch26-percentile-quartile-probe.csv`; `crates/oxfunc_core/src/functions/percentile_common.rs`; `crates/oxfunc_core/src/functions/percentile_inc_fn.rs`; `crates/oxfunc_core/src/functions/percentile_exc_fn.rs`; `crates/oxfunc_core/src/functions/quartile_inc_fn.rs`; `crates/oxfunc_core/src/functions/quartile_exc_fn.rs`; `formal/lean/OxFunc/Functions/PercentileIncFn.lean`; `formal/lean/OxFunc/Functions/PercentileExcFn.lean`; `formal/lean/OxFunc/Functions/QuartileIncFn.lean`; `formal/lean/OxFunc/Functions/QuartileExcFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the interpolation and boundary lanes for the batch, including `PERCENTILE.INC(F1:F5,0.3) -> 2.2`, `PERCENTILE.EXC(F1:F5,0.3) -> 1.8`, `QUARTILE.INC(F1:F5,4) -> 5`, and `QUARTILE.EXC(F1:F5,4) -> #NUM!`. |
| `W16-BATCH27-PERCENTRANK-20260315` | W16 Batch 27 percentrank baseline (`PERCENTRANK.INC`,`PERCENTRANK.EXC`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH27_PERCENTRANK_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch27-percentrank-probe.csv`; `.tmp/w16-batch27-percentrank-sig-probe.csv`; `crates/oxfunc_core/src/functions/percentrank_common.rs`; `crates/oxfunc_core/src/functions/percentrank_inc_fn.rs`; `crates/oxfunc_core/src/functions/percentrank_exc_fn.rs`; `formal/lean/OxFunc/Functions/PercentRankIncFn.lean`; `formal/lean/OxFunc/Functions/PercentRankExcFn.lean` | Native Excel COM spot probes on `2026-03-15` pinned the percentrank interpolation and significance lanes for the batch, including `PERCENTRANK.INC(F1:F5,3.5) -> 0.625`, `PERCENTRANK.EXC(F1:F5,3.5) -> 0.583`, `PERCENTRANK.EXC(F1:F5,3.5,6) -> 0.583333`, and significance `0 -> #NUM!`. |
| `W16-BATCH28-PAIRED-STATS-20260315` | W16 Batch 28 paired statistics baseline (`CORREL`,`PEARSON`,`RSQ`,`SLOPE`,`INTERCEPT`,`COVARIANCE.P`,`COVARIANCE.S`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH28_PAIRED_STATS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch28-paired-stats-probe.csv`; `crates/oxfunc_core/src/functions/paired_stats_common.rs`; `crates/oxfunc_core/src/functions/correl_fn.rs`; `crates/oxfunc_core/src/functions/pearson_fn.rs`; `crates/oxfunc_core/src/functions/rsq_fn.rs`; `crates/oxfunc_core/src/functions/slope_fn.rs`; `crates/oxfunc_core/src/functions/intercept_fn.rs`; `crates/oxfunc_core/src/functions/covariance_p_fn.rs`; `crates/oxfunc_core/src/functions/covariance_s_fn.rs`; `formal/lean/OxFunc/Functions/CorrelFn.lean`; `formal/lean/OxFunc/Functions/PearsonFn.lean`; `formal/lean/OxFunc/Functions/RsqFn.lean`; `formal/lean/OxFunc/Functions/SlopeFn.lean`; `formal/lean/OxFunc/Functions/InterceptFn.lean`; `formal/lean/OxFunc/Functions/CovariancePFn.lean`; `formal/lean/OxFunc/Functions/CovarianceSFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the paired-statistics substrate, including equal-cardinality `#N/A`, pairwise numeric filtering, `SLOPE(H1:H2,F1:F2) -> 0`, `INTERCEPT(F1:F2,H1:H2) -> #DIV/0!`, and scalar/direct lanes like `COVARIANCE.P(1,2) -> 0`. |
| `W16-BATCH29-LOG-ROUNDING-20260315` | W16 Batch 29 logarithm and directional rounding baseline (`LOG`,`ROUNDDOWN`,`ROUNDUP`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH29_LOG_ROUNDING_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch29-log-rounding-probe.csv`; `crates/oxfunc_core/src/functions/log_fn.rs`; `crates/oxfunc_core/src/functions/rounddown_fn.rs`; `crates/oxfunc_core/src/functions/roundup_fn.rs`; `formal/lean/OxFunc/Functions/LogFn.lean`; `formal/lean/OxFunc/Functions/RoundDownFn.lean`; `formal/lean/OxFunc/Functions/RoundUpFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the logarithm and rounding-direction lanes, including `LOG(8,1) -> #DIV/0!`, `LOG(TRUE,10) -> 0`, `ROUNDDOWN(-3.14159,3) -> -3.141`, and `ROUNDUP(314.159,-2) -> 400`. |
| `W16-BATCH30-SCALAR-STATS-20260315` | W16 Batch 30 scalar statistical transform baseline (`FISHER`,`FISHERINV`,`PHI`,`GAUSS`,`STANDARDIZE`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH30_SCALAR_STATS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch30-scalar-stats-probe.csv`; `crates/oxfunc_core/src/functions/normal_dist_common.rs`; `crates/oxfunc_core/src/functions/fisher_fn.rs`; `crates/oxfunc_core/src/functions/fisherinv_fn.rs`; `crates/oxfunc_core/src/functions/phi_fn.rs`; `crates/oxfunc_core/src/functions/gauss_fn.rs`; `crates/oxfunc_core/src/functions/standardize_fn.rs`; `formal/lean/OxFunc/Functions/FisherFn.lean`; `formal/lean/OxFunc/Functions/FisherInvFn.lean`; `formal/lean/OxFunc/Functions/PhiFn.lean`; `formal/lean/OxFunc/Functions/GaussFn.lean`; `formal/lean/OxFunc/Functions/StandardizeFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the scalar statistical transform lanes, including `FISHER(0.5) -> 0.549306144334055`, `FISHER(1) -> #NUM!`, `GAUSS(0) -> 0`, and `STANDARDIZE(42,40,0) -> #NUM!`. |
| `W16-BATCH31-TEXT-SCALAR-MISC-20260315` | W16 Batch 31 text scalar helper baseline (`CHAR`,`CODE`,`LOWER`,`UPPER`,`TRIM`,`REPT`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH31_TEXT_SCALAR_MISC_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch31-text-scalar-misc-probe.csv`; `crates/oxfunc_core/src/functions/text_scalar_misc.rs`; `formal/lean/OxFunc/Functions/CharFn.lean`; `formal/lean/OxFunc/Functions/CodeFn.lean`; `formal/lean/OxFunc/Functions/LowerFn.lean`; `formal/lean/OxFunc/Functions/UpperFn.lean`; `formal/lean/OxFunc/Functions/TrimFn.lean`; `formal/lean/OxFunc/Functions/ReptFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the text-scalar helper lanes, including `CHAR(0) -> #VALUE!`, `CODE("") -> #VALUE!`, `TRIM(CHAR(160)&"A"&CHAR(160))` preserving non-breaking spaces, and `REPT(TRUE,2) -> "TRUETRUE"`. |
| `W16-BATCH32-CEILING-FLOOR-20260315` | W16 Batch 32 significance-rounding baseline (`CEILING`,`CEILING.MATH`,`CEILING.PRECISE`,`ISO.CEILING`,`FLOOR`,`FLOOR.MATH`,`FLOOR.PRECISE`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH32_CEILING_FLOOR_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch32-ceiling-floor-probe.csv`; `.tmp/w16-batch32-ceiling-floor-edge-probe.csv`; `.tmp/w16-batch32-ceiling-floor-defaults-probe.csv`; `crates/oxfunc_core/src/functions/ceiling_floor_family.rs`; `formal/lean/OxFunc/Functions/CeilingFloorFamily.lean` | Native Excel COM spot probes on `2026-03-15` pinned the legacy-sign and modern-abs-significance lanes, including `CEILING(4.3,-2) -> #NUM!`, `FLOOR(5,0) -> #DIV/0!`, `CEILING.MATH(-4.3,2,1) -> -6`, `FLOOR.MATH(4.3,-2) -> 4`, and `ISO.CEILING(4.3) -> 5`. |
| `W16-BATCH33-DECIMAL-20260315` | W16 Batch 33 scalar radix-decoding baseline (`DECIMAL`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH33_DECIMAL_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch33-roman-decimal-probe.csv`; `crates/oxfunc_core/src/functions/decimal_fn.rs`; `formal/lean/OxFunc/Functions/DecimalFn.lean` | Native Excel COM spot probe on `2026-03-15` pinned the radix-validation and whitespace lanes for `DECIMAL`, including lowercase acceptance, leading-whitespace acceptance, trailing-whitespace rejection, `DECIMAL(TRUE,2) -> #NUM!`, and radix truncation on `DECIMAL("10",2.9) -> 2`. |
| `W16-BATCH34-ROMAN-20260316` | W16 Batch 34 Roman numeral rendering baseline (`ROMAN`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH34_ROMAN_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch33-roman-decimal-probe.csv`; `.tmp/w16-roman-modes-probe.csv`; `crates/oxfunc_core/src/functions/roman_fn.rs`; `crates/oxfunc_core/src/functions/mod.rs`; `crates/oxfunc_core/src/functions/surface_dispatch.rs`; `crates/oxfunc_core/src/xll_export_specs.rs`; `formal/lean/OxFunc/Functions/RomanFn.lean`; `formal/lean/OxFunc.lean` | Native Excel COM probe rows on `2026-03-15` and `2026-03-16` pinned the current-baseline `ROMAN` slice, including form tiers `0..4`, optional-form behavior, simplification boundaries such as `49 -> VLIV -> IL`, blank-first-argument empty-string output, truncation on `ROMAN(499.9)`, and `#VALUE!` on out-of-range forms and numbers. |
| `W16-BATCH35-TEXT-UNICODE-20260316` | W16 Batch 35 Unicode text helper baseline (`UNICHAR`,`UNICODE`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH35_TEXT_UNICODE_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `docs/function-lane/STRING_BEHAVIOR_RESEARCH_NOTES.md`; `docs/function-lane/STRING_NORMALIZATION_AND_COMPARISON_POLICY_MAP.md`; `docs/function-lane/STRING_SCENARIO_MANIFEST_SEED.csv`; `crates/oxfunc_core/src/functions/text_unicode_fn.rs`; `formal/lean/OxFunc/Functions/TextUnicodeFn.lean` | This batch reuses the deterministic W7 string baseline, including `LEN(UNICHAR(128512)) -> 2`, `UNICODE(UNICHAR(128512)) -> 128512`, combining-sequence first-code-point behavior, and dangling-surrogate-tail `#VALUE!`. |
| `W16-BATCH36-TEXT-SLICE-20260316` | W16 Batch 36 text-slice baseline (`LEN`,`LEFT`,`RIGHT`,`MID`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH36_TEXT_SLICE_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `docs/function-lane/STRING_BEHAVIOR_RESEARCH_NOTES.md`; `docs/function-lane/STRING_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/STRING_EXECUTION_RECORD.md`; `docs/function-lane/TEXT_FUNCTION_EMPIRICAL_EXPANSION_NOTES.md`; `.tmp/w16-batch35-36-text-probe.csv`; `.tmp/w16-batch36-text-slice-emoji-probe.csv`; `crates/oxfunc_core/src/functions/text_slice_family.rs`; `formal/lean/OxFunc/Functions/TextSliceFamily.lean` | Deterministic W7/W12 evidence plus focused `2026-03-16` probe rows pin the admitted baseline split: `LEN` and `MID` expose raw UTF-16 code-unit behavior, while `LEFT` and `RIGHT` preserve a leading or trailing surrogate pair when a one-character slice lands on that boundary. |
| `W16-BATCH37-DOLLAR-FRACTION-20260316` | W16 Batch 37 dollar fraction conversion baseline (`DOLLARDE`,`DOLLARFR`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH37_DOLLAR_FRACTION_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch37-dollar-fraction-probe.csv`; `.tmp/w16-batch37-dollar-fraction-ref-probe.csv`; `crates/oxfunc_core/src/functions/dollar_fraction_family.rs`; `formal/lean/OxFunc/Functions/DollarFractionFamily.lean` | Native Excel COM spot probes on `2026-03-16` pinned denominator truncation, negative and zero denominator behavior, numeric-text acceptance, logical rejection, omitted-arg `#N/A`, blank-reference zero/`#DIV/0!` lanes, and roundtrip rows like `DOLLARDE(1.02,16) -> 1.125` / `DOLLARFR(1.125,16) -> 1.02`. |
| `W16-BATCH38-DATE-PARTS-20260316` | W16 Batch 38 date-serial part baseline (`DAY`,`MONTH`,`YEAR`,`DAYS`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH38_DATE_PARTS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-date-part-probe.csv`; `.tmp/w16-date-part-blank-probe.csv`; `crates/oxfunc_core/src/functions/date_parts_family.rs`; `formal/lean/OxFunc/Functions/DatePartsFamily.lean` | Native Excel COM spot probes on `2026-03-16` pinned the 1900-date-system part-extraction lanes, including serial `0 -> 1900-01-00`, fake leap-day serial `60 -> 1900-02-29`, truncated `DAYS` subtraction, and blank-reference coercion to zero for the admitted slice. |
| `W16-BATCH39-TIME-PARTS-20260316` | W16 Batch 39 time-serial part baseline (`HOUR`,`MINUTE`,`SECOND`,`TIME`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH39_TIME_PARTS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch39-time-parts-probe.csv`; `.tmp/w16-batch39-time-parts-edge-probe.csv`; `crates/oxfunc_core/src/functions/date_parts_family.rs`; `formal/lean/OxFunc/Functions/DatePartsFamily.lean` | Native Excel COM spot probes on `2026-03-16` pinned fractional-day extraction, time-component truncation and normalization, the `32767` component ceiling, omitted-argument zeroing, and negative-total `#NUM!` behavior for `TIME`. |
| `W16-BATCH40-HELPER-CONCAT-20260316` | W16 Batch 40 helper and concatenation baseline (`ISEVEN`,`ERROR.TYPE`,`IFNA`,`COUNTBLANK`,`CONCAT`,`CONCATENATE`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH40_HELPER_CONCAT_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch40-helper-concat-probe.csv`; `crates/oxfunc_core/src/functions/iseven_fn.rs`; `crates/oxfunc_core/src/functions/error_type_fn.rs`; `crates/oxfunc_core/src/functions/ifna_fn.rs`; `crates/oxfunc_core/src/functions/countblank_fn.rs`; `crates/oxfunc_core/src/functions/concat_family.rs`; `formal/lean/OxFunc/Functions/IsEvenFn.lean`; `formal/lean/OxFunc/Functions/ErrorTypeFn.lean`; `formal/lean/OxFunc/Functions/IfNaFn.lean`; `formal/lean/OxFunc/Functions/CountBlankFn.lean`; `formal/lean/OxFunc/Functions/ConcatFamily.lean` | Native Excel COM spot probe on `2026-03-16` pinned the helper/control and concatenation lanes, including blank-cell `ISEVEN`, classic-only `ERROR.TYPE` numbering, `IFNA` catching only `#N/A`, `COUNTBLANK` counting both empty cells and `""`, `CONCAT` range flattening, and `CONCATENATE` rejecting a multi-cell range. |
| `W16-BATCH41-ENGINEERING-RADIX-20260316` | W16 Batch 41 engineering radix conversion baseline (`DEC2BIN`,`DEC2HEX`,`DEC2OCT`,`BIN2DEC`,`BIN2HEX`,`BIN2OCT`,`HEX2BIN`,`HEX2DEC`,`HEX2OCT`,`OCT2BIN`,`OCT2DEC`,`OCT2HEX`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH41_ENGINEERING_RADIX_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch41-engineering-radix-probe.csv`; `crates/oxfunc_core/src/functions/engineering_radix_family.rs`; `formal/lean/OxFunc/Functions/EngineeringRadixFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned the engineering radix family ranges, ten-character signed two's-complement interpretation, ignored `places` for negative decimal inputs, and cross-radix overflow `#NUM!` behavior. |
| `W16-BATCH42-TEXT-SEARCH-REPLACE-20260316` | W16 Batch 42 text search/replace baseline (`PROPER`,`SUBSTITUTE`,`REPLACE`,`FIND`,`SEARCH`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH42_TEXT_SEARCH_REPLACE_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch42-text-search-replace-probe.csv`; `.tmp/w16-batch42-text-search-replace-edge-probe.csv`; `crates/oxfunc_core/src/functions/text_search_replace_family.rs`; `formal/lean/OxFunc/Functions/TextSearchReplaceFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned UTF-16-unit indexing for `REPLACE`,`FIND`,`SEARCH`, ASCII-seeded wildcard semantics for `SEARCH`, and baseline capitalization/substitution behavior for `PROPER` and `SUBSTITUTE`. |
| `W16-BATCH43-CHOOSE-IFS-20260316` | W16 Batch 43 lazy branch-helper baseline (`CHOOSE`,`IFS`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH43_CHOOSE_IFS_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch43-choose-ifs-probe.csv`; `crates/oxfunc_core/src/functions/choose_ifs_family.rs`; `formal/lean/OxFunc/Functions/ChooseIfsFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned one-based truncated `CHOOSE` indexing, left-to-right lazy `IFS` scanning, `#N/A` on no match, and `#VALUE!` on direct text conditions such as `IFS(\"2\",\"hit\")`. |
| `W16-BATCH44-DATE-WEEK-20260316` | W16 Batch 44 date week/month-offset baseline (`EDATE`,`EOMONTH`,`WEEKDAY`,`WEEKNUM`,`ISOWEEKNUM`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH44_DATE_WEEK_FAMILY_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch44-date-week-probe.csv`; `.tmp/w16-batch44-date-week-edge-probe.csv`; `crates/oxfunc_core/src/functions/date_week_family.rs`; `formal/lean/OxFunc/Functions/DateWeekFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned serial-0 pseudo-date behavior, fake-leap serial `60`, serial-timeline weekday numbering, ISO-week boundary handling, and `#NUM!` lanes for negative serials and invalid return types. |

| `W16-BATCH45-MATRIX-FAMILY-20260316` | W16 Batch 45 matrix baseline (`MDETERM`,`MINVERSE`,`MMULT`,`MUNIT`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH45_MATRIX_FAMILY_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch45-matrix-probe.csv`; `.tmp/w16-batch45-matrix-edge-probe.csv`; `crates/oxfunc_core/src/functions/matrix_family.rs`; `formal/lean/OxFunc/Functions/MatrixFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned square-matrix, scalar-1x1, singular-inverse, and nonnumeric-cell lanes, including `MDETERM({1,2;3,4}) -> -2`, `MINVERSE(5) -> 0.2`, `MMULT(5,2) -> 10`, and `MMULT({1,2;3,4},{5;6;7}) -> #VALUE!`. |
| `W16-BATCH50-NORMAL-LOGNORM-20260316` | W16 Batch 50 normal/lognormal baseline (`CONFIDENCE`,`CONFIDENCE.NORM`,`NORM.DIST`,`NORM.INV`,`NORM.S.DIST`,`NORM.S.INV`,`NORMDIST`,`NORMINV`,`NORMSDIST`,`NORMSINV`,`LOGNORM.DIST`,`LOGNORM.INV`,`LOGNORMDIST`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH50_NORMAL_LOGNORM_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch50-normal-lognorm-probe.csv`; `.tmp/w16-batch50-normal-lognorm-edge-probe.csv`; `crates/oxfunc_core/src/functions/normal_log_family.rs`; `formal/lean/OxFunc/Functions/NormalLogFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned density-vs-cumulative behavior, open-interval inverse-normal `#NUM!` lanes, lognormal domain rejection on `x <= 0`, and alias parity for `CONFIDENCE`, `NORMDIST`, and `LOGNORMDIST`. |
| `W16-BATCH47-SUMPRODUCT-20260316` | W16 Batch 47 product/series baseline (`SUMPRODUCT`,`SUMX2MY2`,`SUMX2PY2`,`SUMXMY2`,`SERIESSUM`) | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_BATCH47_SUMPRODUCT_NOTES.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `.tmp/w16-batch47-sumproduct-probe.csv`; `.tmp/w16-batch47-sumproduct-edge-probe.csv`; `crates/oxfunc_core/src/functions/sumproduct_family.rs`; `formal/lean/OxFunc/Functions/SumproductFamily.lean` | Native Excel COM probe rows on `2026-03-16` pinned zero-coercion for nonnumeric `SUMPRODUCT` cells, `#N/A` shape mismatch for the `SUMX*` family, `#DIV/0!` when no numeric pair survives, and numeric-text scalar admission for `SERIESSUM`. |
| `W16-SCOPE-RECONCILIATION-20260316` | W16 packet closure reconciliation | provisional | `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`; `docs/function-lane/W16_EXECUTION_RECORD.md`; `docs/function-lane/W16_SCOPE_RECONCILIATION.csv` | Raw `W16` inventory rows were fully reconciled on `2026-03-16`: `288` rows closed in `W16`, `7` grouped alias rows mapped to implemented member functions, and `117` residual functions extracted to `W017`. |
| `W17-DEFERRED-LOW-INTEREST-20260316` | W17 deferred low-interest residual inventory | provisional | `docs/worksets/W017_DEFERRED_LOW_INTEREST_FUNCTIONS_REQUIRING_HARDENING_AND_HOST_SEAMS.md`; `docs/function-lane/W17_DEFERRED_LOW_INTEREST_INVENTORY.csv`; `CURRENT_BLOCKERS.md` | `W17` was opened on `2026-03-16` to own `117` low-interest residual functions extracted from `W16`, separating host-seam blockers from semantic-hardening families. The active inventory is now `110` after `W022` reconciled the criteria-family shape row out of `W17`. |
| `W18-REPLAY-ADAPTER-20260316` | W18 replay appliance packet-adapter incorporation baseline | provisional | `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`; `docs/function-lane/OXFUNC_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`; `docs/worksets/W018_REPLAY_APPLIANCE_PACKET_ADAPTER_BASELINE.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\08_oxfunc_addendum.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\11_adapter_conformance_and_capability_matrix.md` | Replay rollout baseline on `2026-03-16` pins OxFunc packet-first adapter semantics, local-only source schema ids, Foundation registry snapshot bindings, and the conservative capability ceiling through `cap.C3.explain_valid`. |
| `W19-WITNESS-LIFECYCLE-20260316` | W19 packet witness-distillation and retention baseline | provisional | `docs/worksets/W019_PACKET_WITNESS_DISTILLATION_AND_RETENTION_BASELINE.md`; `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\10_witness_distillation_and_counterexample_reduction.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\12_predicate_mismatch_and_status_registry.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\13_witness_lifecycle_retention_and_quarantine_policy.md` | Replay witness baseline on `2026-03-16` binds packet-first reduction units, predicate and lifecycle vocabulary, supersession/quarantine doctrine, and the explicit non-claim posture for `cap.C4.distill_valid` and `cap.C5.pack_valid`. |
| `W18-W15-BUNDLE-SKELETON-20260316` | W18 worked-example normalized bundle skeleton for W15 | provisional | `docs/function-lane/W15_REPLAY_BUNDLE_SKELETON_V1.md`; `docs/function-lane/W15_EXECUTION_RECORD.md`; `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`; `docs/worksets/W018_REPLAY_APPLIANCE_PACKET_ADAPTER_BASELINE.md` | Documentation target on `2026-03-16` defining the expected normalized bundle shape for the first OxFunc worked packet example. This is a bundle-target artifact only and does not imply a live adapter emission run. |
| `W18-W15-CONFORMANCE-CHECKLIST-20260316` | W18 first live-run conformance checklist for the W15 replay adapter packet | provisional | `docs/function-lane/W15_REPLAY_ADAPTER_CONFORMANCE_CHECKLIST_V1.md`; `docs/function-lane/W15_REPLAY_BUNDLE_SKELETON_V1.md`; `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`; `docs/worksets/W018_REPLAY_APPLIANCE_PACKET_ADAPTER_BASELINE.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\11_adapter_conformance_and_capability_matrix.md` | Checklist target on `2026-03-16` defining bundle-field presence, replay/diff/explain acceptance, and projection-gap versus semantic-gap versus seam-limit classification for the first future live W15 adapter run. This is an acceptance target only and not yet a proving artifact. |
| `W18-W15-DIFF-EXPLAIN-SHAPES-20260316` | W18 expected diff and explain object shapes for the W15 worked packet | provisional | `docs/function-lane/W15_REPLAY_DIFF_EXPLAIN_SHAPES_V1.md`; `docs/function-lane/W15_REPLAY_ADAPTER_CONFORMANCE_CHECKLIST_V1.md`; `docs/function-lane/W15_REPLAY_BUNDLE_SKELETON_V1.md`; `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\12_predicate_mismatch_and_status_registry.md` | Target-shape note on `2026-03-16` defining the first live replay diff and explain objects for `W15`, including pinned mismatch/severity/predicate ids and seam-limitation-aware classification. This is not yet a proving artifact. |
| `W20-BUNDLE-LAYOUT-INDEX-20260316` | W20 emitted replay bundle layout and index baseline | provisional | `docs/worksets/W020_OXFUNC_REPLAY_BUNDLE_LAYOUT_AND_INDEX_BASELINE.md`; `docs/function-lane/OXFUNC_REPLAY_BUNDLE_LAYOUT_AND_INDEX_V1.md`; `docs/function-lane/W15_REPLAY_BUNDLE_SKELETON_V1.md`; `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs\\03_replay_appliance_architecture.md` | Layout baseline on `2026-03-16` adapts the Foundation canonical bundle filesystem contract to OxFunc packet-first bundles and pins the first W15 emitted-bundle root, directories, and index file set. This is a target-layout artifact only. |
| `W21-RUN-CONTRACT-20260316` | W21 first live W15 replay-adapter run contract | provisional | `docs/worksets/W021_W15_FIRST_LIVE_REPLAY_ADAPTER_RUN_BASELINE.md`; `docs/function-lane/W21_W15_FIRST_LIVE_REPLAY_RUN_CONTRACT_V1.md`; `CURRENT_BLOCKERS.md` | Run-contract note on `2026-03-16` defined the first live W15 replay-adapter execution contract before the runner existed; the contract is now exercised by `W21-W15-LIVE-RUN-20260317` and `BLK-FN-004` is resolved. |
| `W21-W15-LIVE-RUN-20260317` | W21 first live local W15 replay-adapter emission/validation/replay/diff/explain run | provisional | `tools/replay-adapter/run-w15-replay-adapter-baseline.ps1`; `docs/function-lane/W21_EXECUTION_RECORD.md`; `.tmp/replay-bundles/oxfunc-w15-v1/bundle_manifest.json`; `.tmp/replay-bundles/oxfunc-w15-v1/sidecars/normalized/w15.validation.json`; `.tmp/replay-bundles/oxfunc-w15-v1/sidecars/normalized/w15.replay_result.json`; `.tmp/replay-bundles/oxfunc-w15-v1/diff/emitted/w15.default_vs_compat.json`; `.tmp/replay-bundles/oxfunc-w15-v1/explain/emitted/w15.explain.json` | Live local run on `2026-03-17` emitted the first real OxFunc replay bundle for `W15`, evidenced `cap.C0` through `cap.C3` locally, preserved source/evidence/limitation bindings without projection gaps, and kept `cap.C4` / `cap.C5` explicitly unclaimed. |
| `W22-CRITERIA-SHAPE-20260318` | W22 criteria-family shape hardening baseline | provisional | `docs/worksets/W022_CRITERIA_FAMILY_SHAPE_HARDENING.md`; `docs/function-lane/FUNCTION_SLICE_CRITERIA_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W22_CRITERIA_SHAPE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W22_CRITERIA_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W22_EXECUTION_RECORD.md`; `tools/w22-probe/run-w22-criteria-shape-baseline.ps1`; `.tmp/w22-criteria-shape-results.csv`; `crates/oxfunc_core/src/functions/criteria_family.rs` | Native Excel replay on `2026-03-18` pinned the current-baseline split: `AVERAGEIF` top-left anchors an explicit mismatched `average_range`, while `COUNTIFS`, `SUMIFS`, `AVERAGEIFS`, `MAXIFS`, and `MINIFS` remain exact-shape and return `#VALUE!` on the same mismatch patterns. W22 now also carries the family contract and conformance promotion via `FDEF-041`. |
| `W24-B01-SWITCH-20260318` | W24 Batch 01 SWITCH baseline | provisional | `docs/function-lane/FUNCTION_SLICE_SWITCH_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH01_SWITCH_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH01_SWITCH_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH01_SWITCH_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch01-switch-baseline.ps1`; `.tmp/w24-batch01-switch-results.csv`; `crates/oxfunc_core/src/functions/misc_switch_info_family.rs` | Native Excel replay on `2026-03-18` pinned first-match selection, default fallback, no-default `#N/A`, typed text-vs-number non-match, case-insensitive text comparison, lazy skipping of later result errors, and propagation of a selected result error for the admitted current-baseline `SWITCH` slice. |
| `W24-B02-DATEVALUE-20260318` | W24 Batch 02 date-value family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_DATE_VALUE_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH02_DATEVALUE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH02_DATEVALUE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH02_DATEVALUE_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch02-datevalue-baseline.ps1`; `.tmp/w24-batch02-datevalue-results.csv`; `crates/oxfunc_core/src/functions/date_value_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline slice for `DATEVALUE`, `TIMEVALUE`, `DAYS360`, and `DATEDIF`, including the host-profile text subset, February-end `DAYS360` divergences, and the quirky `DATEDIF(\"MD\")` lanes. |
| `W24-B03-TEXT-DELIM-20260318` | W24 Batch 03 text delimiter family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_TEXT_DELIM_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH03_TEXT_DELIM_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH03_TEXT_DELIM_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH03_TEXT_DELIM_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch03-text-delim-baseline.ps1`; `.tmp/w24-batch03-text-delim-results.csv`; `crates/oxfunc_core/src/functions/text_delim_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline scalar slice for `TEXTAFTER` and `TEXTBEFORE`, including signed `instance_num`, empty-delimiter polarity, explicit fallback, bounded binary flags, and the real optional-argument order. |
| `W24-B04-ARRAY-TEXT-SPLIT-20260318` | W24 Batch 04 array/text split family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_ARRAY_TEXT_SPLIT_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH04_ARRAY_TEXT_SPLIT_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH04_ARRAY_TEXT_SPLIT_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH04_ARRAY_TEXT_SPLIT_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch04-array-text-split-baseline.ps1`; `.tmp/w24-batch04-array-text-split-results.csv`; `crates/oxfunc_core/src/functions/array_text_split_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline slice for `ARRAYTOTEXT` and `TEXTSPLIT`, using scalar strict-array witnesses for the `TEXTSPLIT` array outputs. |
| `W24-B05-CONFIDENCE-TEST-20260318` | W24 Batch 05 confidence/test helper family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_CONFIDENCE_TEST_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH05_CONFIDENCE_TEST_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH05_CONFIDENCE_TEST_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH05_CONFIDENCE_TEST_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch05-confidence-test-baseline.ps1`; `.tmp/w24-batch05-confidence-test-results.csv`; `crates/oxfunc_core/src/functions/confidence_test_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline slice for `CONFIDENCE.T` and `Z.TEST`, including the `Z.TEST` survivor policy for mixed non-error and error-bearing sample arrays. |
| `W24-B06-SPECIAL-DIST-20260318` | W24 Batch 06 special-distribution family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_SPECIAL_DIST_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH06_SPECIAL_DIST_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH06_SPECIAL_DIST_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH06_SPECIAL_DIST_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch06-special-dist-baseline.ps1`; `.tmp/w24-batch06-special-dist-results.csv`; `crates/oxfunc_core/src/functions/special_dist_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline special-distribution slice, including the corrected zero-density `WEIBULL.DIST` rule at `x = 0`. |
| `W24-B07-STAT-TESTS-20260318` | W24 Batch 07 statistical test family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_STATISTICAL_TEST_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH07_STATISTICAL_TESTS_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH07_STATISTICAL_TESTS_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH07_STATISTICAL_TESTS_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch07-statistical-tests-baseline.ps1`; `.tmp/w24-batch07-statistical-tests-results.csv`; `crates/oxfunc_core/src/functions/statistical_tests_family.rs`; `crates/oxfunc_core/src/functions/test_alias_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline statistical-test slice, including `CHISQ.TEST` equal-cardinality reshape by first-argument layout and acceptance of the legacy alias names on the current baseline. |
| `W24-B08-LOOKUP-PROB-FREQ-20260318` | W24 Batch 08 lookup/probability/frequency family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_LOOKUP_PROB_FREQUENCY_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH08_LOOKUP_PROB_FREQUENCY_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH08_LOOKUP_PROB_FREQUENCY_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH08_LOOKUP_PROB_FREQUENCY_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch08-lookup-prob-frequency-baseline.ps1`; `.tmp/w24-batch08-lookup-prob-frequency-results.csv`; `crates/oxfunc_core/src/functions/lookup_prob_frequency_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline lookup/probability/frequency slice, including the corrected `PROB` non-unit-sum `#NUM!` rule. |
| `W24-B09-REGRESSION-FORECAST-20260318` | W24 Batch 09 regression/forecast family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_REGRESSION_FORECAST_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH09_REGRESSION_FORECAST_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH09_REGRESSION_FORECAST_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH09_REGRESSION_FORECAST_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch09-regression-forecast-baseline.ps1`; `.tmp/w24-batch09-regression-forecast-results.csv`; `crates/oxfunc_core/src/functions/regression_forecast_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline regression/forecast slice, including multivariate `known_x`, row-oriented multivariate `new_x`, matrix-shape preservation for single-predictor `TREND`, and the trailing intercept/base cells kept by `LINEST` / `LOGEST` when `const=FALSE`. |
| `W24-B10-REGEX-20260318` | W24 Batch 10 regex triad baseline | provisional | `docs/function-lane/FUNCTION_SLICE_REGEX_TRIAD_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH10_REGEX_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH10_REGEX_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH10_REGEX_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch10-regex-baseline.ps1`; `.tmp/w24-batch10-regex-results.csv`; `crates/oxfunc_core/src/functions/number_regex_translate_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline pure regex trio, including shorthand class support (`\\d`), no-match `#N/A`, nth-occurrence replacement, and the current ASCII-only case-sensitivity flag semantics. |
| `W24-B11-FINANCIAL-TIME-VALUE-20260318` | W24 Batch 11 financial time-value family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_FINANCIAL_TIME_VALUE_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH11_FINANCIAL_TIME_VALUE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH11_FINANCIAL_TIME_VALUE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH11_FINANCIAL_TIME_VALUE_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch11-financial-time-value-baseline.ps1`; `.tmp/w24-batch11-financial-time-value-results.csv`; `crates/oxfunc_core/src/functions/financial_time_value_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted scalar/sequence financial family and exposed the corrected `ISPMT` behavior: period `1` yields `-75` and period `0` yields `-100` for the seeded `(0.1,4,1000)`-style lanes. |
| `W24-B12-CASHFLOW-RATE-20260318` | W24 Batch 12 cashflow rate family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_CASHFLOW_RATE_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH12_CASHFLOW_RATE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH12_CASHFLOW_RATE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH12_CASHFLOW_RATE_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch12-cashflow-rate-baseline.ps1`; `.tmp/w24-batch12-cashflow-rate-results.csv`; `crates/oxfunc_core/src/functions/cashflow_rate_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted current-baseline numeric cashflow/date-vector slice for `IRR`, `XNPV`, and `XIRR`, including sign-change rejection, length-mismatch rejection, and pre-anchor-date rejection on the irregular-date lanes. |
| `W24-B13-COUPON-20260318` | W24 Batch 13 coupon family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_COUPON_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH13_COUPON_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH13_COUPON_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH13_COUPON_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch13-coupon-baseline.ps1`; `.tmp/w24-batch13-coupon-results.csv`; `crates/oxfunc_core/src/functions/coupon_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted regular coupon-schedule slice, including basis-specific period sizing, quarterly end-of-month stepping, serial-`0` admission for early-date day/date lanes, and settlement-on-coupon-date advance behavior. |
| `W24-B14-AMOR-DEPRECIATION-20260318` | W24 Batch 14 AMOR depreciation family baseline | provisional | `docs/function-lane/FUNCTION_SLICE_AMOR_DEPRECIATION_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH14_AMOR_DEPRECIATION_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH14_AMOR_DEPRECIATION_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH14_AMOR_DEPRECIATION_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch14-amor-depreciation-baseline.ps1`; `.tmp/w24-batch14-amor-depreciation-results.csv`; `crates/oxfunc_core/src/functions/amor_depreciation_family.rs` | Native Excel replay on `2026-03-18` pinned the admitted scalar AMOR depreciation slice, including the support-example lanes, basis-specific first-period behavior, and the current fractional-period normalization rules. |
| `W24-B15-MISC-ORDINARY-CONVERSION-20260318` | W24 Batch 15 misc ordinary conversion packet | provisional | `docs/function-lane/FUNCTION_SLICE_MISC_ORDINARY_CONVERSION_TRIAD_CONTRACT_PRELIM.md`; `docs/function-lane/W24_BATCH15_MISC_ORDINARY_CONVERSION_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W24_BATCH15_MISC_ORDINARY_CONVERSION_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W24_BATCH15_MISC_ORDINARY_CONVERSION_EXECUTION_RECORD.md`; `tools/w24-probe/run-w24-batch15-misc-ordinary-conversion-baseline.ps1`; `.tmp/w24-batch15-misc-ordinary-conversion-results.csv`; `crates/oxfunc_core/src/functions/misc_conversion_family.rs` | Native Excel replay on `2026-03-18` pinned the ordinary `BAHTTEXT` / `CONVERT` / `PERCENTOF` triad and simultaneously proved that `EUROCONVERT` and `RANDARRAY` are `#NAME?` outliers on the current host baseline. |
| `W24-SCOPE-RECONCILIATION-20260318` | W24 ordinary mega-batch scope reconciliation | provisional | `docs/worksets/W024_ORDINARY_FUNCTIONS_MEGA_BATCH_EXECUTION_PLAN.md`; `docs/function-lane/W24_EXECUTION_RECORD.md`; `docs/function-lane/W24_SCOPE_RECONCILIATION.csv`; `docs/function-lane/W24_ORDINARY_FUNCTIONS_MEGA_BATCH_CHECKLIST.csv` | The `W24` mega-batch checklist was fully reconciled on `2026-03-18`: `67` rows closed inside `W24`, `2` rows extracted to `W025`, `5` rows extracted to `W026`, and `13` rows extracted to `W027`. |
| `W26-HOST-PROFILE-PROVIDER-20260318` | W26 host/profile/provider characterization packet | provisional | `docs/worksets/W026_DEFERRED_LOCALE_PROFILE_AND_PROVIDER_SENSITIVE_ORDINARY_OUTLIERS.md`; `docs/function-lane/W26_HOST_PROFILE_PROVIDER_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W26_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W26_EXECUTION_RECORD.md`; `docs/function-lane/W26_SCOPE_RECONCILIATION.csv`; `tools/w26-probe/run-w26-host-profile-provider-baseline.ps1`; `.tmp/w26-host-profile-provider-results.csv` | Native Excel replay on `2026-03-18` pinned the current-host characterization of `ASC`, `DBCS`, `JIS`, `NUMBERVALUE`, and `TRANSLATE`, proving that the packet belongs to successor locale/profile and provider-language seam work rather than ordinary pure-function closure. |
| `W27-BOND-ODD-BOND-20260318` | W27 bond core and odd-bond direct Excel parity packet | provisional | `docs/worksets/W027_DEFERRED_ADVANCED_BOND_AND_ODD_BOND_HARDENING.md`; `docs/function-lane/FUNCTION_SLICE_BOND_CORE_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_ODD_BOND_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W27_BOND_ODD_BOND_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W27_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W27_EXECUTION_RECORD.md`; `tools/w27-probe/run-w27-bond-odd-bond-baseline.ps1`; `.tmp/w27-bond-odd-bond-results.csv`; `crates/oxfunc_core/src/functions/bond_core_family.rs`; `crates/oxfunc_core/src/functions/odd_bond_family.rs`; `formal/lean/OxFunc/Functions/BondCoreFamily.lean`; `formal/lean/OxFunc/Functions/OddBondFamily.lean` | Native Excel replay on `2026-03-18` pinned one direct worksheet lane for each in-scope bond-core and odd-bond function and confirmed the repaired `PRICEMAT` / `YIELDMAT` basis-`1` convention and the repaired `ODDLPRICE` / `ODDLYIELD` odd-last convention. |
| `W28-FUNCTION-NAME-LOCALIZATION-HARVEST-20260318` | W28 official support localization harvest and catalog reconciliation | provisional | `docs/worksets/W028_FUNCTION_NAME_LOCALIZATION_LIBRARY_DISCOVERY.md`; `docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_DISCOVERY_PRELIM.md`; `docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv`; `docs/function-lane/W28_SUPPORT_FUNCTION_CATALOG_RECONCILIATION.csv`; `docs/function-lane/W28_EXECUTION_RECORD.md`; `tools/w28-probe/run-w28-support-function-localization-harvest.ps1`; `.tmp/w28-support-function-localization-summary.json` | Official support harvest on `2026-03-18` captured `40` locale pages, `20,360` localized rows, `509` English unique names, and explicit anomalies/reconciliation differences against the older `500`-row catalog freeze. |
| `W28-FUNCTION-NAME-RESOLUTION-20260319` | W28 direct Excel function-name resolution and local catalog promotion | provisional | `docs/function-lane/W28_FUNCTION_NAME_EXISTENCE_PROBE_RESULTS.csv`; `docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv`; `docs/function-lane/W28_EXECUTION_RECORD.md`; `tools/w28-probe/run-w28-function-name-resolution-probe.ps1` | Direct Excel probing on `2026-03-19` showed that `BETA.INV` / `IMAGINARY` / `FORECAST` / `FORECAST.LINEAR` and the missing `IS*` functions exist on the installed baseline while `BETA.INVn` does not; OxFunc now carries a corrected local current-baseline catalog with `511` names. |
| `W29-FINANCE-BENCHMARK-20260318` | W29 three-way finance benchmark across OxFunc, public ExcelFinancialFunctions F#, and direct Excel | provisional | `docs/worksets/W029_FINANCE_FUNCTIONS_FSHARP_BENCHMARK_CROSSCHECK.md`; `docs/function-lane/W29_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W29_FINANCE_BENCHMARK_DISCREPANCY_LEDGER.csv`; `docs/function-lane/W29_EXECUTION_RECORD.md`; `tools/w29-probe/run-w29-finance-benchmark-crosscheck.ps1`; `crates/oxfunc_core/examples/w29_finance_probe.rs`; `.tmp/w29-finance-summary.json`; `.tmp/w29-finance-oxfunc-results.csv`; `.tmp/w29-finance-fsharp-results.csv`; `.tmp/w29-finance-excel-results.csv` | The `2026-03-18` benchmark aligned six targeted lanes across all three systems, reopened `COUPDAYS`, `XNPV`, and `XIRR` parity concerns, and confirmed that the repaired `W27` `PRICEMAT` / `YIELDMAT` / `ODDL*` lanes already match both the public F# formulas and direct Excel. |
| `W30-LOCALE-PROFILE-SEAM-20260319` | W30 locale/profile-sensitive text and number seam-definition packet | provisional | `docs/worksets/W030_DEFERRED_LOCALE_PROFILE_SENSITIVE_TEXT_AND_NUMBER_FUNCTIONS.md`; `docs/function-lane/W30_EXECUTION_RECORD.md`; `docs/function-lane/W30_SCOPE_RECONCILIATION.csv`; `docs/function-lane/W26_EXECUTION_RECORD.md`; `.tmp/w26-host-profile-provider-results.csv` | `W30` used the existing native W26 host/profile artifact to complete an honest seam-definition/reconciliation packet: `ASC`/`DBCS`/`JIS` now move to `W034`, and `NUMBERVALUE` omitted-default behavior now moves to `W035`. |
| `W31-PROVIDER-LANGUAGE-SEAM-20260319` | W31 provider-language seam-definition packet | provisional | `docs/worksets/W031_DEFERRED_PROVIDER_LANGUAGE_FUNCTIONS.md`; `docs/function-lane/W31_EXECUTION_RECORD.md`; `docs/function-lane/W31_SCOPE_RECONCILIATION.csv`; `docs/function-lane/W26_EXECUTION_RECORD.md`; `.tmp/w26-host-profile-provider-results.csv` | `W31` used the existing native W26 provider-state artifact to complete an honest seam-definition/reconciliation packet for `TRANSLATE`, which now moves to `W036`. |
| `W32-FINANCE-REPAIR-20260319` | W32 reopened finance parity repair and reconciliation | provisional | `docs/worksets/W032_REOPENED_FINANCE_PARITY_GAPS_FROM_BENCHMARK.md`; `docs/function-lane/W32_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W32_SCOPE_RECONCILIATION.csv`; `docs/function-lane/W32_EXECUTION_RECORD.md`; `docs/function-lane/W29_FINANCE_BENCHMARK_DISCREPANCY_LEDGER.csv`; `.tmp/w29-finance-summary.json`; `.tmp/w29-finance-oxfunc-results.csv`; `.tmp/w29-finance-fsharp-results.csv`; `.tmp/w29-finance-excel-results.csv`; `crates/oxfunc_core/src/functions/coupon_family.rs`; `crates/oxfunc_core/src/functions/cashflow_rate_family.rs`; `crates/oxfunc_core/examples/w29_finance_probe.rs` | `W32` repaired the reopened `COUPDAYS` leap-year actual/actual lane, the negative-rate `XNPV` lanes, and the reopened `XIRR` negative-root / negative-guess lanes. The formerly extracted large-root `XIRR` publication lane is now closed by `W037`. |
| `W37-XIRR-LARGE-ROOT-20260321` | W37 large positive-root `XIRR` publication-policy repair | provisional | `docs/worksets/W037_REOPENED_XIRR_LARGE_ROOT_SOLVER_PRECISION.md`; `docs/function-lane/W37_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W37_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W37_EXECUTION_RECORD.md`; `tools/w37-probe/run-w37-xirr-large-root-baseline.ps1`; `crates/oxfunc_core/examples/w37_xirr_large_root_probe.rs`; `crates/oxfunc_core/src/functions/cashflow_rate_family.rs`; `.tmp/w37-xirr-large-root-oxfunc-results.csv`; `.tmp/w37-xirr-large-root-excel-results.csv`; `.tmp/w37-xirr-large-root-results.csv`; `docs/function-lane/W29_FINANCE_BENCHMARK_DISCREPANCY_LEDGER.csv` | `W37` pinned the installed Excel published-result policy for the large positive-root two-cashflow `XIRR` lane, replaced the old exact shortcut with an Excel-like bracket-and-bisection publication solver for the admitted slice, and eliminated the last `all_diverge_or_inconclusive` finance benchmark lane. |
| `W33-INFO-FORECAST-20260319` | W33 information predicates and forecast compatibility baseline | provisional | `docs/worksets/W033_INFORMATION_PREDICATES_AND_FORECAST_COMPATIBILITY_CLOSURE.md`; `docs/function-lane/FUNCTION_SLICE_INFORMATION_PREDICATES_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_FORECAST_COMPATIBILITY_PAIR_CONTRACT_PRELIM.md`; `docs/function-lane/W33_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W33_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W33_EXECUTION_RECORD.md`; `tools/w33-probe/run-w33-info-forecast-baseline.ps1`; `.tmp/w33-info-forecast-results.csv`; `crates/oxfunc_core/src/functions/is_predicates_family.rs`; `crates/oxfunc_core/src/functions/regression_forecast_family.rs`; `formal/lean/OxFunc/Functions/IsPredicatesFamily.lean`; `formal/lean/OxFunc/Functions/RegressionForecastFamily.lean` | Native Excel replay on `2026-03-19` pinned the admitted current-baseline split between values-only information predicates and the reference-visible `ISREF` lane, and confirmed that `FORECAST` and `FORECAST.LINEAR` are semantically identical on the seeded scalar/vector packet with `#N/A` on mismatched vector lengths. |
| `W38-LAMBDA-HELPER-STAGE1-20260319` | W38 helper/callable Stage 1 native baseline (`LET`, immediate `LAMBDA`, direct `ISOMITTED`) | provisional | `docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md`; `docs/function-lane/FUNCTION_SLICE_FUNCTIONAL_LAMBDA_AND_HELPER_STAGE1_CONTRACT_PRELIM.md`; `docs/function-lane/W38_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W38_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W38_EXECUTION_RECORD.md`; `tools/w38-probe/run-w38-lambda-helper-stage1-baseline.ps1`; `.tmp/w38-lambda-helper-stage1-results.csv` | Native Excel replay on `2026-03-19` pinned the Stage 1 helper/callable slice across `18` seeded rows: sequential `LET`, lexical capture into immediately invoked `LAMBDA`, bare-lambda `#CALC!`, direct arity-mismatch `#VALUE!`, explicit omitted-placeholder visibility for `ISOMITTED`, and the distinct fact that ordinary under-application does not expose an omitted-argument channel. |
| `W38-MAP-REDUCE-SCAN-STAGE2-20260319` | W38 higher-order helper Stage 2 native baseline (`MAP`, `REDUCE`, `SCAN`) | provisional | `docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md`; `docs/function-lane/FUNCTION_SLICE_FUNCTIONAL_LAMBDA_HELPERS_STAGE2_MAP_REDUCE_SCAN_CONTRACT_PRELIM.md`; `docs/function-lane/W38_STAGE2_MAP_REDUCE_SCAN_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W38_STAGE2_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W38_EXECUTION_RECORD.md`; `tools/w38-probe/run-w38-map-reduce-scan-stage2-baseline.ps1`; `.tmp/w38-map-reduce-scan-stage2-results.csv` | Native Excel replay on `2026-03-19` pinned the admitted higher-order helper slice: `MAP` spills array results and uses `#N/A` for a seeded missing partner element, `REDUCE` folds to a scalar, `SCAN` spills intermediate accumulations without a visible initial-accumulator element, and helper lambda arity mismatches surface as `#VALUE!` on the seeded runtime lanes. |
| `W38-BYROW-BYCOL-MAKEARRAY-DEFINED-NAMES-STAGE3-20260319` | W38 helper/callable Stage 3 native baseline (`BYROW`,`BYCOL`,`MAKEARRAY`, workbook Defined Name callable preservation) | provisional | `docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md`; `docs/function-lane/FUNCTION_SLICE_FUNCTIONAL_LAMBDA_HELPERS_STAGE3_BYROW_BYCOL_MAKEARRAY_DEFINED_NAMES_CONTRACT_PRELIM.md`; `docs/function-lane/W38_STAGE3_BYROW_BYCOL_MAKEARRAY_DEFINED_NAMES_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W38_STAGE3_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W38_EXECUTION_RECORD.md`; `tools/w38-probe/run-w38-stage3-byrow-bycol-makearray-defined-names-baseline.ps1`; `.tmp/w38-stage3-byrow-bycol-makearray-defined-names-results.csv` | Native Excel replay on `2026-03-19` pinned the admitted Stage 3 helper slice: `BYROW`/`BYCOL` require scalar lambda results and yield `#CALC!` on the seeded non-scalar lanes, `MAKEARRAY` uses 1-based generated coordinates and seeded present-argument `ISOMITTED` semantics, and workbook Defined Names preserve callable lambdas for direct invocation, helper use, lexical capture, and bare `#CALC!` publication. |
| `W43-RTD-SEAM-FIRSTPASS-20260320` | W43 RTD first-pass OxFunc-local seam and runtime surface | provisional | `docs/worksets/W043_RTD_COM_ACTIVATION_AND_TOPIC_LIFECYCLE_SEAM.md`; `docs/function-lane/RTD_REFERENCE_CAPTURE_AND_SEAM_NOTES.md`; `docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md`; `docs/function-lane/W43_EXECUTION_RECORD.md`; `crates/oxfunc_core/src/functions/rtd_fn.rs`; `crates/oxfunc_core/src/functions/surface_dispatch.rs`; `crates/oxfunc_core/src/xll_export_specs.rs`; `tools/xll-addin/oxfunc_xll/export_specs.csv` | First-pass local RTD seam on `2026-03-20`: OxFunc admits the `RTD(prog_id,server,topic...)` call, preserves ordered topic strings, projects host-supplied provider outcomes into worksheet values/errors, and explicitly leaves COM activation, topic subscription lifetime, callbacks, and recalc scheduling above OxFunc. |
| `W44-LIBCTX-SNAPSHOT-EXPORT-20260320` | W44 first-pass OxFunc library-context snapshot export | provisional | `docs/worksets/W044_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_BASELINE.md`; `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`; `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1_README.md`; `docs/function-lane/W44_EXECUTION_RECORD.md`; `docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv`; `docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv` | First explicit downstream library-context snapshot export on `2026-03-20`: `511` built-in function rows with snapshot identity, stable function ids, localization-table pointer, semantic/gating reference fields, and OxFml-facing reading guidance. |
| `W45-OP-ARITH-WAVEA-20260320` | W45 Wave A operator arithmetic baseline (`OP_UNARY_PLUS`,`OP_NEGATE`,`OP_ADD`,`OP_SUBTRACT`,`OP_MULTIPLY`,`OP_DIVIDE`,`OP_POWER`,`OP_PERCENT`) | provisional | `docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md`; `docs/function-lane/FUNCTION_SLICE_OPERATOR_ARITHMETIC_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W45_WAVEA_OPERATOR_ARITHMETIC_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W45_WAVEA_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W45_EXECUTION_RECORD.md`; `.tmp/w45-wavea-operator-arithmetic-results.csv`; `tools/w45-probe/run-w45-wavea-operator-arithmetic-baseline.ps1`; `crates/oxfunc_core/src/functions/operator_arithmetic_family.rs`; `formal/lean/OxFunc/Functions/OperatorArithmeticFamily.lean` | Native Excel replay on `2026-03-20` pinned unary plus numeric-text coercion, unary negate over `TRUE`, postfix percent, divide-by-zero `#DIV/0!`, and real-domain invalid power `(-1)^0.5 -> #NUM!`. |
| `W45-OP-CMP-WAVEB-20260320` | W45 Wave B operator compare/concat baseline (`OP_CONCAT`,`OP_EQUAL`,`OP_NOT_EQUAL`,`OP_LESS_THAN`,`OP_LESS_EQUAL`,`OP_GREATER_THAN`,`OP_GREATER_EQUAL`) | provisional | `docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md`; `docs/function-lane/FUNCTION_SLICE_OPERATOR_COMPARE_CONCAT_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W45_WAVEB_OPERATOR_COMPARE_CONCAT_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W45_WAVEB_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W45_EXECUTION_RECORD.md`; `.tmp/w45-waveb-operator-compare-concat-results.csv`; `tools/w45-probe/run-w45-waveb-operator-compare-concat-baseline.ps1`; `crates/oxfunc_core/src/functions/operator_compare_concat_family.rs`; `formal/lean/OxFunc/Functions/OperatorCompareConcatFamily.lean` | Native Excel replay on `2026-03-20` pinned scalar concat, case-insensitive text equality, direct `1=\"1\" -> FALSE`, blank-cell comparison coercion, and the seeded mixed-type ordering lanes. |
| `W45-OP-REF-WAVEC-20260320` | W45 Wave C operator reference baseline (`OP_RANGE_REF`,`OP_INTERSECTION_REF`,`OP_UNION_REF`,`OP_SPILL_REF`,`OP_TRIM_REF_LEADING`,`OP_TRIM_REF_TRAILING`,`OP_TRIM_REF_BOTH`) | provisional | `docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md`; `docs/function-lane/FUNCTION_SLICE_OPERATOR_REFERENCE_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/FUNCTION_SLICE_OP_SPILL_REF_CONTRACT_PRELIM.md`; `docs/function-lane/W45_WAVEC_OPERATOR_REFERENCE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W45_WAVEC_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W45_EXECUTION_RECORD.md`; `.tmp/w45-wavec-operator-reference-results.csv`; `tools/w45-probe/run-w45-wavec-operator-reference-baseline.ps1`; `crates/oxfunc_core/src/functions/operator_reference_family.rs`; `crates/oxfunc_core/src/functions/op_spill_ref.rs`; `formal/lean/OxFunc/Functions/OperatorReferenceFamily.lean`; `formal/lean/OxFunc/Functions/SpillRef.lean` | Native Excel replay on `2026-03-20` pinned structural range formation, overlap and `#NULL!` intersection behavior, union-as-multi-area shape consumable by `INDEX`, and whitespace-trim transparency for the trim-ref family. |
| `W39-RESHAPE-BL-20260320` | W39 dynamic-array shaping and reshaping family baseline (`CHOOSECOLS`,`CHOOSEROWS`,`DROP`,`EXPAND`,`FILTER`,`SORT`,`SORTBY`,`TAKE`,`TOCOL`,`TOROW`,`TRANSPOSE`,`UNIQUE`,`VSTACK`,`WRAPCOLS`,`WRAPROWS`) | provisional | `docs/worksets/W039_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY.md`; `docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W39_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W39_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W39_EXECUTION_RECORD.md`; `docs/function-lane/W39_SCOPE_RECONCILIATION.csv`; `tools/w39-probe/run-w39-dynamic-array-reshape-baseline.ps1`; `.tmp/w39-dynamic-array-reshape-results.csv`; `crates/oxfunc_core/src/functions/dynamic_array_reshape_family.rs`; `formal/lean/OxFunc/Functions/DynamicArrayReshapeFamily.lean` | Native Excel replay on `2026-03-20` pinned the admitted current-baseline slice for all fifteen reshaping functions, including selector order, negative axis slices, `#N/A` pad behavior, seeded filter/sort/key-array behavior, row/column flattening, transpose, deduplication, and row-major wrap behavior. |
| `W40-REFMETA-BL-20260321` | W40 reference metadata and formula visibility baseline (`ADDRESS`,`AREAS`,`FORMULATEXT`,`SHEET`,`SHEETS`) | provisional | `docs/worksets/W040_REFERENCE_METADATA_AND_FORMULA_VISIBILITY_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_REFERENCE_METADATA_AND_FORMULA_VISIBILITY_CONTRACT_PRELIM.md`; `docs/function-lane/W40_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W40_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W40_EXECUTION_RECORD.md`; `docs/function-lane/W40_SCOPE_RECONCILIATION.csv`; `tools/w40-probe/run-w40-reference-metadata-baseline.ps1`; `.tmp/w40-reference-metadata-results.csv`; `crates/oxfunc_core/src/functions/reference_metadata_family.rs`; `crates/oxfunc_core/src/host_info.rs`; `formal/lean/OxFunc/Functions/ReferenceMetadataFamily.lean`; `formal/lean/OxFunc/HostInfoSeam.lean` | Native Excel replay on `2026-03-21` pinned the admitted current-baseline slice: `ADDRESS` text rendering, `AREAS` multi-area counting, `FORMULATEXT` formula visibility with plain-cell `#N/A`, `SHEET` current/ref/text sheet identity, and `SHEETS` workbook/single-sheet/3D-span counting. The packet now also has a typed OxFunc-side callback surface and Lean substrate for the admitted slice. |
| `W23-DB-BL-20260321` | W23 database family baseline (`DAVERAGE`,`DCOUNT`,`DCOUNTA`,`DGET`,`DMAX`,`DMIN`,`DPRODUCT`,`DSTDEV`,`DSTDEVP`,`DSUM`,`DVAR`,`DVARP`) | provisional | `docs/worksets/W023_DEFERRED_HOST_METADATA_AND_DATABASE_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_DATABASE_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W23_DATABASE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W23_DATABASE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W23_EXECUTION_RECORD.md`; `tools/w23-probe/run-w23-database-baseline.ps1`; `.tmp/w23-database-results.csv`; `crates/oxfunc_core/src/functions/database_family.rs`; `formal/lean/OxFunc/Functions/DatabaseFamily.lean` | Native Excel replay on `2026-03-21` pinned the admitted current-baseline database slice across all twelve `D*` functions, including omitted-field `DCOUNT`, duplicate-header OR criteria rows, `DGET` uniqueness/error lanes, and the statistical family over the matched record set. |
| `W23-ISF-BL-20260321` | W23 `ISFORMULA` baseline | provisional | `docs/worksets/W023_DEFERRED_HOST_METADATA_AND_DATABASE_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_ISFORMULA_CONTRACT_PRELIM.md`; `docs/function-lane/W23_ISFORMULA_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W23_ISFORMULA_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W23_EXECUTION_RECORD.md`; `tools/w23-probe/run-w23-isformula-baseline.ps1`; `.tmp/w23-isformula-results.csv`; `crates/oxfunc_core/src/functions/misc_switch_info_family.rs`; `formal/lean/OxFunc/Functions/MiscSwitchInfoFamily.lean`; `formal/lean/OxFunc/HostInfoSeam.lean` | Native Excel replay on `2026-03-21` pinned `ISFORMULA` as a reference-only typed host query: formula cells and formulas returning text yield `TRUE`, plain value cells yield `FALSE`, and non-reference operands yield `#VALUE!`. |
| `W23-STA-BL-20260321` | W23 `SUBTOTAL` / `AGGREGATE` reference-form row-visibility baseline | provisional | `docs/worksets/W023_DEFERRED_HOST_METADATA_AND_DATABASE_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_SUBTOTAL_AGGREGATE_CONTRACT_PRELIM.md`; `docs/function-lane/W23_SUBTOTAL_AGGREGATE_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W23_SUBTOTAL_AGGREGATE_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W23_EXECUTION_RECORD.md`; `tools/w23-probe/run-w23-subtotal-aggregate-baseline.ps1`; `.tmp/w23-subtotal-aggregate-results.csv`; `crates/oxfunc_core/src/functions/subtotal_aggregate_family.rs`; `formal/lean/OxFunc/Functions/SubtotalAggregateFamily.lean`; `formal/lean/OxFunc/HostInfoSeam.lean` | Native Excel replay on `2026-03-21` pinned the admitted reference-form row-visibility slice: `SUBTOTAL` always ignores filtered rows and nested aggregates, while `AGGREGATE` options `0..3` ignore nested aggregates and options `4..7` keep nested aggregate values while splitting hidden/filter/error handling. |
| `W23-HOST-CLASS-BL-20260321` | W23 host/provider classification baseline (`HYPERLINK`,`IMAGE`,`COPILOT`) | provisional | `docs/worksets/W023_DEFERRED_HOST_METADATA_AND_DATABASE_FUNCTIONS.md`; `docs/function-lane/W23_HOST_PROVIDER_CLASSIFICATION_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W23_EXECUTION_RECORD.md`; `tools/w23-probe/run-w23-host-provider-classification.ps1`; `.tmp/w23-host-provider-classification-results.csv`; `crates/oxfunc_core/src/functions/hyperlink_fn.rs` | Native Excel replay on `2026-03-21` pinned `HYPERLINK` as ordinary text value plus hyperlink-style formatting hints, `IMAGE` as provider/media-bound with `#CONNECT!` in the seeded lane, and `COPILOT` as an absent feature/add-in lane with `#NAME?` on the current installed baseline. |
| `W23-HI-VALMODEL-20260321` | W23 `HYPERLINK` / `IMAGE` value-model and publication-baseline note | provisional | `docs/worksets/W023_DEFERRED_HOST_METADATA_AND_DATABASE_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_HYPERLINK_IMAGE_VALUE_MODEL_PRELIM.md`; `docs/function-lane/W23_EXECUTION_RECORD.md`; `tools/w23-probe/run-w23-hyperlink-image-value-model-baseline.ps1`; `.tmp/w23-hyperlink-image-value-model-results.csv` | Native Excel replay on `2026-03-21` pinned `HYPERLINK` as plain text at the value boundary with formula-cell-local hyperlink styling, while the Microsoft support-example `IMAGE` lane preserved a non-ordinary payload across reference (`TYPE=128`) and therefore pressures a richer host-managed value/publication model. |
| `W41-WEBTEXTXML-BL-20260321` | W41 web text/xml local baseline (`ENCODEURL`,`FILTERXML`) | provisional | `docs/worksets/W041_EXTERNAL_DATA_PROVIDER_AND_CUBE_FUNCTIONS.md`; `docs/function-lane/FUNCTION_SLICE_WEB_TEXT_XML_LOCAL_FUNCTIONS_CONTRACT_PRELIM.md`; `docs/function-lane/W41_WEB_TEXT_XML_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W41_WEB_TEXT_XML_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W41_EXECUTION_RECORD.md`; `tools/w41-probe/run-w41-web-text-xml-baseline.ps1`; `.tmp/w41-web-text-xml-results.csv`; `crates/oxfunc_core/src/functions/web_text_xml_family.rs`; `formal/lean/OxFunc/Functions/WebTextXmlFamily.lean` | Native Excel replay on `2026-03-21` pinned `ENCODEURL` scalar-to-text percent encoding and the admitted `FILTERXML` node-set-only XPath slice, including vertical spill, malformed-XML `#VALUE!`, and non-node-set XPath `#VALUE!` behavior. |
| `W34-WIDTH-CONV-20260321` | W34 width-conversion host/profile seam baseline (`ASC`,`DBCS`,`JIS`) | provisional | `docs/worksets/W034_DEFERRED_WIDTH_CONVERSION_HOST_PROFILE_CAPABILITY_BASELINE.md`; `docs/function-lane/FUNCTION_SLICE_WIDTH_CONVERSION_HOST_PROFILE_CONTRACT_PRELIM.md`; `docs/function-lane/W34_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W34_EXECUTION_RECORD.md`; `docs/function-lane/W26_EXECUTION_RECORD.md`; `.tmp/w26-host-profile-provider-results.csv`; `crates/oxfunc_core/src/functions/text_compat_locale_family.rs`; `crates/oxfunc_core/src/host_info.rs`; `formal/lean/OxFunc/Functions/TextCompatLocaleFamily.lean`; `formal/lean/OxFunc/HostInfoSeam.lean` | Native Excel replay reused from `W26` pinned current-host pass-through for `ASC` / `DBCS` and non-admission for `JIS`; the `2026-03-21` OxFunc closure adds a typed width-conversion mode seam so OxFunc owns the transform once the active host/profile mode is known. |
| `W35-NUMBERVALUE-LOCALE-20260321` | W35 `NUMBERVALUE` locale-default seam baseline | provisional | `docs/worksets/W035_DEFERRED_NUMBERVALUE_LOCALE_DEFAULT_PROFILE_BASELINE.md`; `docs/function-lane/FUNCTION_SLICE_NUMBERVALUE_LOCALE_DEFAULT_CONTRACT_PRELIM.md`; `docs/function-lane/W35_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W35_EXECUTION_RECORD.md`; `docs/function-lane/W26_EXECUTION_RECORD.md`; `.tmp/w26-host-profile-provider-results.csv`; `crates/oxfunc_core/src/functions/number_regex_translate_family.rs`; `formal/lean/OxFunc/Functions/NumberRegexTranslateFamily.lean` | Native Excel replay reused from `W26` pinned omitted-default rejection on the current host profile and explicit-separator success; the `2026-03-21` OxFunc closure makes omitted defaults come from `LocaleFormatContext` while leaving explicit-separator lanes pure OxFunc parsing. |
| `W36-TRANSLATE-PROVIDER-20260321` | W36 `TRANSLATE` provider-language seam baseline | provisional | `docs/worksets/W036_DEFERRED_PROVIDER_LANGUAGE_CAPABILITY_BASELINE.md`; `docs/function-lane/FUNCTION_SLICE_TRANSLATE_PROVIDER_LANGUAGE_CONTRACT_PRELIM.md`; `docs/function-lane/W36_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W36_EXECUTION_RECORD.md`; `docs/function-lane/W26_EXECUTION_RECORD.md`; `.tmp/w26-host-profile-provider-results.csv`; `crates/oxfunc_core/src/functions/number_regex_translate_family.rs`; `crates/oxfunc_core/src/host_info.rs`; `formal/lean/OxFunc/Functions/NumberRegexTranslateFamily.lean`; `formal/lean/OxFunc/HostInfoSeam.lean` | Native Excel replay reused from `W26` pinned same-language passthrough and cross-language `#BUSY!`; the `2026-03-21` OxFunc closure adds a typed `TranslateRequest -> TranslateProviderResult` seam and keeps actual translation above OxFunc. |
| `W46-XLCALL-CATALOG-20260321` | W46 local `XLCALL.H` built-in code ingest and registration seam baseline | provisional | `docs/worksets/W046_CALL_AND_REGISTER_ID_UDF_REGISTRATION_SEAM.md`; `docs/function-lane/XLCALL_CODE_CATALOG.csv`; `docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md`; `docs/function-lane/W46_EXECUTION_RECORD.md`; `tools/w46-probe/generate-xlcall-code-catalog.ps1`; `.tmp/excelxllsdk_extracted/2013 Office System Developer Resources/Excel2013XLLSDK/INCLUDE/XLCALL.H`; `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv` | Local SDK ingest on `2026-03-21` parses `XLCALL.H` auxiliary, built-in, command, and `xlUDF` rows, matches built-in `xlf*` codes against the current OxFunc catalog where possible, and exposes those built-in C API identities in the `W044` snapshot for the next OxFml registration/catalog round. |
| `W52-SUMIF-BL-20260326` | W52 standalone `SUMIF` completion baseline | provisional | `docs/worksets/W052_SUMIF_CRITERIA_FAMILY_COMPLETION.md`; `docs/function-lane/FUNCTION_SLICE_CRITERIA_FAMILY_CONTRACT_PRELIM.md`; `docs/function-lane/W52_SUMIF_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W52_SUMIF_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W52_EXECUTION_RECORD.md`; `tools/w52-probe/run-w52-sumif-baseline.ps1`; `.tmp/w52-sumif-results.csv`; `crates/oxfunc_core/src/functions/criteria_family.rs`; `formal/lean/OxFunc/Functions/CriteriaFamily.lean`; `tools/xll-addin/oxfunc_xll/export_specs.csv`; `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv` | Native Excel replay on `2026-03-26` pinned the missing `SUMIF`-specific current-baseline lanes: omitted `sum_range`, anchored mismatched A1-style `sum_range`, numeric-only target aggregation, and reached target-error propagation. The packet also promotes `SUMIF` into the runtime export and published library-context surfaces. |
| `W46-CALL-REGISTER-RUNTIME-20260322` | W46 admitted `CALL` / `REGISTER.ID` runtime and Excel4 baseline | provisional | `docs/worksets/W046_CALL_AND_REGISTER_ID_UDF_REGISTRATION_SEAM.md`; `docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md`; `docs/function-lane/W46_SCENARIO_MANIFEST_SEED.csv`; `docs/function-lane/W46_RUNTIME_REQUIREMENTS.md`; `docs/function-lane/W46_EXECUTION_RECORD.md`; `tools/w46-probe/run-w46-call-register-id-baseline.ps1`; `.tmp/w46-call-register-id-results.csv`; `crates/oxfunc_core/src/functions/call_register_id_family.rs`; `formal/lean/OxFunc/Functions/CallRegisterIdFamily.lean` | Native Excel4 replay on `2026-03-22` pins seeded `REGISTER.ID` and `CALL` Win32 lanes (`GetTickCount`, `MulDiv`), while OxFunc adds the typed `RegisteredExternalProvider` seam plus `CALL` / `REGISTER.ID` request normalization and worksheet result projection. |

## Rules
1. IDs are immutable once referenced from conformance or correlation rows.
2. IDs remain `provisional` until multi-build/channel + compatibility coverage is complete or Foundation accepts a promoted `EMP-*` ID.
3. If promoted, append a row mapping local ID -> Foundation ID rather than reusing/removing the local ID.
4. Replay bundles and reduced witnesses are secondary artifact refs; they must bind back to the source evidence id, source manifest rows, and output sidecars rather than replacing them.
5. If witness distillation is later used, record lifecycle state, supersession refs, and reduction-manifest refs adjacent to the source evidence id.
6. Shared Replay vocabulary ids must use a pinned Foundation snapshot or be marked explicitly as `oxfunc.local.*`.

## Source: `OxFunc/docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md`

# FUNCTION SLICE - CALL and REGISTER.ID UDF Registration Seam Prelim

## 1. Purpose
Pin the admitted OxFunc-side runtime seam for worksheet/macro `REGISTER.ID` and macro-sheet `CALL` without collapsing raw Excel C API exposure, DLL/code-resource loading, or external invocation execution into OxFunc.

## 2. Current OxFunc Reading
OxFunc is steward of the function registration catalog and of the worksheet-facing normalization for `REGISTER.ID` / `CALL`.

That means:
1. OxFunc owns the catalog identity of built-in worksheet functions and their legacy `XLCALL.H` codes where those exist.
2. OxFunc should also own the catalog identity of host-registered external functions once the host/OxFml side supplies registration descriptors.
3. OxFunc owns:
   - `REGISTER.ID` request normalization,
   - `CALL` target normalization,
   - register-id lookup vs direct-call target split,
   - worksheet result projection.
4. Host/OxFml still owns:
   - raw Excel C API dispatch,
   - registration handle allocation,
   - DLL/code-resource lookup and loading,
   - actual external invocation.

## 3. Built-In Function Identity Layer
Current built-in ingest artifacts:
1. `docs/function-lane/XLCALL_CODE_CATALOG.csv`
2. `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`

Current intended reading:
1. `XLCALL.H` built-in `xlf*` numbers are legacy built-in aliases for OxFunc catalog rows, not replacements for OxFunc stable ids.
2. The preferred downstream identity remains `surface_stable_id`.
3. `xlf*` code and symbol travel as compatibility/interoperability metadata for host C API routing.

## 4. Admitted Current-Baseline Excel Reading
Pinned from `ExecuteExcel4Macro(...)` on the seeded Windows baseline:
1. `REGISTER.ID("Kernel32","GetTickCount","J!")` returns a numeric register id.
2. `CALL(register_id)` succeeds for the seeded zero-argument `GetTickCount` lane.
3. `CALL("Kernel32","GetTickCount","J!")` succeeds directly.
4. `CALL("Kernel32","MulDiv","JJJJ",6,7,3)` succeeds and returns `14`.
5. `CALL(register_id,6,7,3)` succeeds for the seeded `MulDiv` lane and returns `14`.
6. The seeded zero-argument `GetTickCount` lane also succeeds when `type_text` is omitted:
   - `REGISTER.ID("Kernel32","GetTickCount")`
   - `CALL("Kernel32","GetTickCount")`
7. This does not yet pin a general omission rule for argument-bearing direct-call lanes.

Important admission distinction:
1. Microsoft documents `CALL` as an Excel 4 macro-sheet function.
2. `REGISTER.ID` is documented as worksheet-usable.
3. The current replay artifact uses `ExecuteExcel4Macro(...)` to avoid conflating host sheet admission rules with the function-side registration seam.

## 5. Typed OxFunc Runtime Seam
Current first-pass runtime seam is:
1. `RegisterIdRequest`
2. `RegisteredExternalDescriptor`
3. `RegisteredExternalCallRequest`
4. `RegisteredExternalProvider`

Current request/target shape:
1. `REGISTER.ID`
   - `library_name`
   - `procedure`
   - optional `declared_type_text`
2. `CALL`
   - by register id, or
   - direct target `{ library_name, procedure, optional declared_type_text }`
   - plus trailing invocation args preserved as raw `CallArgValue`

Current descriptor shape:
1. `stable_registration_id`
2. `register_id`
3. `origin_kind`
4. `display_name`
5. `library_name`
6. `procedure`
7. `declared_type_text`

## 6. Provider Ownership Split
Current first-pass split:
1. host/OxFml resolves `REGISTER.ID` requests into a `RegisteredExternalDescriptor`,
2. host/OxFml looks up existing descriptors by numeric register id,
3. host/OxFml performs the actual external invocation,
4. OxFunc returns the projected worksheet value/error from the host-supplied outcome.

Why this is above OxFunc:
1. registration state is global host state,
2. external routine loading/execution is not function-kernel work,
3. registration/removal must later align with `W049` immutable snapshot generation.

## 7. Relation To W047 / W049
This packet pressures the first-freeze runtime seam in two places:
1. `W047`
   - `RegisteredExternalProvider` should be a distinct typed bundle member rather than hidden inside `HostInfoProvider`.
2. `W049`
   - future registered-external additions/removals should publish a fresh immutable `LibraryContextSnapshot` generation.

## 8. Current Honest Status
This is no longer only a note-only seam.

What is real now:
1. local SDK `XLCALL.H` ingest is reproducible,
2. built-in `xlf*` codes are cataloged against current OxFunc stable ids where possible,
3. native Excel macro replay exists for seeded `REGISTER.ID` / `CALL` lanes,
4. OxFunc core now has:
   - typed `RegisteredExternalProvider`,
   - typed request/descriptor/call-request structs,
   - `REGISTER.ID` runtime surface,
   - `CALL` runtime surface.

What remains open:
1. OxFml now has a real proving-host floor for:
   - worksheet `REGISTER.ID`,
   - worksheet `CALL`,
   - reference-visible `CALL` arguments,
   - host API registration,
   - VBA shim registration,
   - unregister packet carriage.
2. direct adoption of OxFunc-owned `RegisterIdRequest`, `RegisteredExternalDescriptor`, and `RegisteredExternalCallRequest` packet types is now exercised on the OxFml side.
3. the broader argument-bearing omitted-`type_text` matrix is not pinned yet.
4. worksheet-vs-macro-sheet admission/version matrix is not fully pinned yet.
5. exact shared field naming and first frozen packet ownership for `RegisteredExternalCatalogMutation*` / controller surfaces are not locked yet.
6. minimum register/unregister consequences for `LibraryContextSnapshot` generation are not locked yet.

## Source: `OxFunc/docs/function-lane/FUNCTION_SLICE_HYPERLINK_IMAGE_VALUE_MODEL_PRELIM.md`

# Function Slice Note (Prelim) - HYPERLINK() / IMAGE() Value and Publication Model

## 1. Purpose
Capture the current-baseline OxFunc-side reading of what crosses the value boundary for `HYPERLINK` and `IMAGE`.

## 2. Evidence Surface
1. `tools/w23-probe/run-w23-hyperlink-image-value-model-baseline.ps1`
2. `.tmp/w23-hyperlink-image-value-model-results.csv`
3. `tools/w23-probe/run-w23-host-provider-classification.ps1`
4. `.tmp/w23-host-provider-classification-results.csv`
5. Microsoft Support `IMAGE` example URL:
   - `https://support.microsoft.com/en-us/office/image-function-7e112975-5e52-4f2a-b9da-1d913d51f5d5`

## 3. Current-Baseline Findings
1. `HYPERLINK("https://example.com","Go")` crosses the value boundary as ordinary text:
   - the formula cell has text/value `Go`,
   - `TYPE(...) = 2`,
   - `CELL("contents", ...) = "Go"`,
   - `T(...) = "Go"`,
   - `N(...) = 0`.
2. A referencing cell `=A1` receives the same plain text value, but does not preserve the hyperlink-style underline/publication treatment seen on the formula cell.
3. On the current baseline, `HYPERLINK` therefore looks like:
   - ordinary scalar text value in OxFunc,
   - plus host-side publication metadata/click behavior attached to the formula cell.
4. `IMAGE(...)` does not currently look like an ordinary scalar value on the baseline:
   - provider/binding failure lanes project worksheet-visible provider-style errors such as `#CONNECT!`,
   - a successful Microsoft support-example URL produces a non-ordinary payload where `TYPE(...) = 128`,
   - `CELL("contents", ...)` returns an opaque sentinel rather than a user text/number value,
   - and a referencing cell preserves the same non-ordinary payload shape.
5. This pressures an extended/rich host-managed value or publication-object model for `IMAGE`, not a plain scalar OxFunc value.

## 4. Current OxFunc Design Reading
1. `HYPERLINK` should be modeled as:
   - ordinary text value owned by OxFunc,
   - plus a presentation/style hint (`style=hyperlink`) carried alongside that text value,
   - with OxFml or the host-facing publication layer responsible for applying the hint to the formula cell.
2. the current OxFunc runtime shape for that is:
   - plain value path: `eval_hyperlink_surface(...) -> EvalValue::Text(...)`
   - extended publication-aware path: `eval_hyperlink_surface_extended(...) -> ValueWithPresentation(value=text, style=hyperlink)`
3. `IMAGE` should remain deferred until the value/publication seam is pinned more carefully:
   - the current OxFunc runtime shape is now:
     - plain value path: provider-supplied fallback text on success, or classified provider-style worksheet errors such as `#CONNECT!` / `#BLOCKED!`
     - extended publication-aware path: `ExtendedValue::RichValue(_webimage)` with typed request-normalized metadata
   - file/web access itself remains host/provider-owned through upstream helpers
   - the admitted end-to-end OxFml adapter/evaluator lane is still open

## 5. Status
1. runtime_status: `evidenced`
2. seam_status: `value_boundary_characterized_but_not_locked`
3. closure_reading:
   - `HYPERLINK` value side and first-pass presentation-hint carrier are now understood,
   - `IMAGE` runtime is now real on the OxFunc side, but it remains an open rich-value / publication seam.

## Source: `OxFunc/docs/function-lane/FUNCTION_SLICE_RETURN_SURFACE_AND_PUBLICATION_HINT_CONTRACT_PRELIM.md`

# Function Slice - Return Surface And Publication Hint Contract (Prelim)

Workset: `W048`

## 1. Purpose
Freeze the first shared return-surface split for the already-covered OxFunc scope.

The current shared split is:
1. ordinary value
2. `ValueWithPresentation`
3. typed host/provider outcome projection

## 2. Shared Reading
The first freeze candidate is:
1. preserve ordinary `EvalValue` as the default function result surface,
2. preserve `ExtendedValue::ValueWithPresentation { value, hint }` as the publication-aware wrapper when Excel changes formatting/style without changing the underlying scalar value,
3. preserve typed host/provider outcome enums on the callback boundary where the host/provider classification is semantically important, with OxFunc projecting them into worksheet-visible values/errors.

Current reading:
1. the third class is not a demand for a new general published-value carrier,
2. it is the current pattern where OxFunc consumes a typed upstream result family and projects it into the worksheet-visible result universe,
3. only concrete implementation evidence should force a narrower or broader factorization.

## 3. Return Classes
### 3.1 Ordinary Value
Representation:
1. `EvalValue`

Current covered examples:
1. `CELL`
2. `INFO`
3. `ISFORMULA`
4. `FORMULATEXT`
5. `SHEET`
6. `SHEETS`
7. `SUBTOTAL`
8. `AGGREGATE`
9. `ASC`
10. `DBCS`
11. `JIS`
12. `NUMBERVALUE`
13. plain `HYPERLINK` value path
14. plain `NOW` / `TODAY` value path
15. `RAND`

### 3.2 `ValueWithPresentation`
Representation:
1. `ExtendedValue::ValueWithPresentation { value, hint }`

Current hint fields:
1. `hint.number_format`
2. `hint.style`

Current covered examples:
1. `NOW`
   - numeric serial
   - plus number-format hint
2. `TODAY`
   - numeric serial
   - plus number-format hint
3. `HYPERLINK`
   - ordinary text value
   - plus `style=hyperlink`

Current ownership split:
1. OxFunc owns emission of the presentation-aware return shape,
2. OxFml / host owns application/publication of the hint,
3. the hint does not change the underlying scalar value semantics.

### 3.3 Typed Host / Provider Outcome Projection
Representation pattern:
1. a typed upstream outcome family remains explicit at the callback boundary,
2. OxFunc projects that typed outcome into worksheet-visible values/errors,
3. the projected worksheet result itself normally lands back in the ordinary value universe.

Current covered examples:
1. `TRANSLATE`
   - input typed outcome: `TranslateProviderResult`
   - projected outputs:
     - `Text(text) -> text`
     - `Busy -> #BUSY!`
     - `CapabilityDenied -> #BLOCKED!`
     - `ProviderError(code) -> code`
2. `RTD`
   - input typed outcome: `RtdProviderResult`
   - projected outputs:
     - `Value(v) -> v`
     - `NoValueYet -> #N/A`
     - `CapabilityDenied -> #BLOCKED!`
     - `ConnectionFailed -> #CONNECT!`
     - `ProviderError(code) -> code`

Current reading:
1. typed outcome projection is part of the shared seam even when the final worksheet-visible result is an ordinary value or worksheet error,
2. this keeps provider/runtime classification explicit above OxFunc while avoiding ad hoc stringly result channels.

## 4. What This Packet Does Not Freeze
This packet does not freeze:
1. full rich-value publication semantics,
2. final callable publication policy,
3. future provider families beyond the current covered seams,
4. any requirement that OxFunc itself apply presentation hints.

Clarification:
1. `IMAGE` remains in the current overall completion scope,
2. but as a sibling rich-value/publication packet rather than as a reason to widen `W048` prematurely.

## 5. Covered Function Mapping
### 5.1 Ordinary Value Class
1. `CELL`
2. `INFO`
3. `ISFORMULA`
4. `FORMULATEXT`
5. `SHEET`
6. `SHEETS`
7. `SUBTOTAL`
8. `AGGREGATE`
9. `ASC`
10. `DBCS`
11. `JIS`
12. `NUMBERVALUE`
13. `RAND`

### 5.2 Presentation-Aware Class
1. `NOW`
2. `TODAY`
3. `HYPERLINK`

### 5.3 Typed Outcome Projection Class
1. `TRANSLATE`
2. `RTD`

## 6. Evidence Posture
This packet freezes a shared return reading from already exercised surfaces in:
1. `docs/function-lane/VALUE_UNIVERSE_PRELIM_SPEC.md`
2. `docs/function-lane/FUNCTION_SLICE_NOW_CONTRACT_PRELIM.md`
3. `docs/function-lane/FUNCTION_SLICE_TODAY_CONTRACT_PRELIM.md`
4. `docs/function-lane/FUNCTION_SLICE_HYPERLINK_IMAGE_VALUE_MODEL_PRELIM.md`
5. `docs/function-lane/FUNCTION_SLICE_TRANSLATE_PROVIDER_LANGUAGE_CONTRACT_PRELIM.md`
6. `docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md`
7. `docs/function-lane/W36_EXECUTION_RECORD.md`
8. `docs/function-lane/W43_EXECUTION_RECORD.md`

## 7. Artifact Bindings
1. workset: `docs/worksets/W048_RETURN_SURFACE_AND_PUBLICATION_HINT_FREEZE.md`
2. mapping table: `docs/function-lane/W48_RETURN_SURFACE_CLASS_MAP.csv`
3. execution record: `docs/function-lane/W48_EXECUTION_RECORD.md`
4. core value model:
   - `crates/oxfunc_core/src/value.rs`
   - `formal/lean/OxFunc/ValueUniverse.lean`

## Source: `OxFunc/docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md`

# FUNCTION SLICE - RTD Contract Prelim

## 1. Purpose
Pin the current OxFunc-local semantic contract for `RTD` without collapsing COM server activation and topic lifecycle machinery into OxFunc.

## 2. Current-Baseline Surface
Worksheet surface:
1. `RTD(prog_id, server_name, topic1, [topic2], ...)`

Current admitted OxFunc-local request shape:
1. `prog_id: text`
2. `server_name: text`
3. `topic_strings: ordered text vector`

Arity:
1. minimum `3`
2. maximum `255`

## 3. OxFunc-Owned Semantics
OxFunc owns:
1. arity admission,
2. values-only argument preparation,
3. text coercion of `prog_id`, `server_name`, and all topic arguments,
4. ordered preservation of the topic-string payload,
5. result projection from a host-supplied provider outcome into the worksheet value/error universe.

## 4. Host / OxFml / Application-Owned Machinery
OxFunc does not own:
1. COM activation of the `IRtdServer`,
2. topic subscription tables,
3. topic lifetime tracking,
4. callback threading and `UpdateNotify`,
5. workbook/cell subscription maps,
6. recalculation triggering policy,
7. saved-value / reconnect lifecycle.

Those responsibilities stay above OxFunc, between OxFml and the higher-level host application.

## 5. Current Minimal OxFml <-> OxFunc Interface
Current OxFunc-side interface direction:
1. `RtdRequest`
   - `prog_id`
   - `server_name`
   - `topic_strings`
2. `RtdProvider`
   - typed host callback for resolving the current RTD result for a prepared request
3. `RtdProviderResult`
   - `Value(EvalValue)`
   - `NoValueYet`
   - `CapabilityDenied`
   - `ConnectionFailed`
   - `ProviderError(WorksheetErrorCode)`

Uniform current reading:
1. the host/OxFml side owns any RTD server startup, topic connect/disconnect, cached-topic state, and cell-topic mapping,
2. the host callback returns either the current RTD value or a classified provider/runtime outcome,
3. OxFunc then returns the projected worksheet value/error for that supplied outcome.

This is a best-attempt local seam design, not a locked cross-repo ABI.

## 6. Current Result Mapping
Current OxFunc-local worksheet projection:
1. `Value(v)` -> `v`
2. `NoValueYet` -> `#N/A`
3. `CapabilityDenied` -> `#BLOCKED!`
4. `ConnectionFailed` -> `#CONNECT!`
5. `ProviderError(code)` -> `code`

Current local admission/runtime failures:
1. arity mismatch -> `#VALUE!`
2. text coercion failure -> propagated worksheet error when present, otherwise `#VALUE!`
3. no provider wired -> `#VALUE!`

## 7. Evidence
Code:
1. `crates/oxfunc_core/src/functions/rtd_fn.rs`
2. `crates/oxfunc_core/src/functions/surface_dispatch.rs`
3. `crates/oxfunc_core/src/xll_export_specs.rs`

Tests and exercised surfaces:
1. unit tests in `rtd_fn.rs`
2. export-catalog test in `xll_export_specs.rs`
3. dispatch-path regression in `surface_dispatch.rs`

Reference captures:
1. `RTD_REFERENCE_CAPTURE_AND_SEAM_NOTES.md`

## 8. Known Limits
1. This contract intentionally does not model live-server startup/disconnect/save-value edge cases inside OxFunc, because those belong to the host-side RTD lifecycle and subscription state above OxFunc.
2. The plain XLL bridge in this repo does not supply a real RTD provider, so end-to-end RTD host replay remains above the current OxFunc test seam.
3. Workbook-saved-value and reconnect semantics remain host-side concerns unless a later seam need proves otherwise.

## Source: `OxFunc/docs/function-lane/FUNCTION_SLICE_RUNTIME_LIBRARY_CONTEXT_PROVIDER_CONSUMER_MODEL_PRELIM.md`

# Function Slice - Runtime Library Context Provider Consumer Model (Prelim)

Status: `active`
Packet: `W049`

## 1. Purpose
Pin the first runtime-only `LibraryContextProvider` / immutable `LibraryContextSnapshot` model for the already-covered scope, while keeping the CSV snapshot export as the bounded interchange and debugging artifact.

## 2. Current Freeze Candidate
The current first-freeze runtime model is:
1. `LibraryContextProvider`
2. immutable `LibraryContextSnapshot`
3. explicit generation changes when registration/removal changes library-context truth
4. explicit mapping from the runtime model to the current CSV export artifact

## 3. Runtime Model Shape
Current runtime-only shape should not mirror the CSV column-for-column. It should group fields by runtime responsibility.

### 3.1 Provider
`LibraryContextProvider` should expose:
1. `current_snapshot() -> LibraryContextSnapshot`
2. optionally `snapshot_by_generation(generation_id) -> Option<LibraryContextSnapshot>` for debugging/replay support

Current reading:
1. consumers should treat the provider as the authority for the latest snapshot,
2. consumers should not depend on mutable in-place catalog updates,
3. registration/removal should publish a new snapshot generation rather than mutating the currently observed snapshot.

### 3.2 Snapshot
`LibraryContextSnapshot` should carry:
1. snapshot identity and provenance
2. immutable entry set
3. resolution indexes
4. stable generation identity

Current runtime snapshot fields:
1. `snapshot_family_id`
2. `snapshot_generation`
3. `source_commit_short`
4. `source_commit_full`
5. `source_tree_state`
6. `entries_by_stable_id`
7. `entries_by_canonical_name`
8. `entries_by_xlcall_code` where applicable
9. `name_resolution_source`

### 3.3 Entry
`LibraryContextEntry` should group fields into:
1. identity
2. surface naming
3. planner-visible semantics
4. seam guidance
5. provenance

Current runtime entry fields:
1. identity:
   - `surface_stable_id`
   - `entry_kind`
   - `registration_source_kind`
2. surface naming:
   - `canonical_surface_name`
   - `name_resolution_table_ref`
3. planner-visible semantics:
   - `semantic_trait_profile_ref`
   - `gating_profile_ref`
   - `version_marker`
   - `category`
   - `interesting`
   - `arity`
   - `arg_preparation_profile`
   - `coercion_lift_profile`
   - `kernel_signature_class`
   - `determinism_class`
   - `volatility_class`
   - `host_interaction_class`
   - `thread_safety_class`
   - `fec_dependency_profile`
   - `surface_fec_dependency_profile`
4. seam guidance:
   - `metadata_status`
   - `special_interface_kind`
   - `admission_interface_kind`
   - `preparation_owner`
   - `runtime_boundary_kind`
   - `arity_shape_note`
   - `interface_contract_ref`
5. provenance:
   - `source_catalog_ref`
   - `xlcall_builtin_symbol`
   - `xlcall_builtin_code`

## 4. Why Runtime Should Not Mirror CSV Directly
The CSV export is useful because it is:
1. stable
2. inspectable
3. easy to diff
4. easy to pin in cross-repo mismatch reports

But the runtime model should differ because:
1. runtime consumers want grouped semantics rather than flat stringly columns,
2. lookup indexes matter at runtime but are flattened awkwardly in CSV,
3. immutable snapshot semantics are clearer in object form than in tabular form,
4. later registered-external entries should be addable without redefining the CSV as the normative runtime ABI.

## 5. Generation Behavior
Current generation rule:
1. built-in-only steady state may reuse the committed generation from the currently pinned export artifact,
2. any future registered-external addition or removal should produce a new `LibraryContextSnapshot`,
3. downstream consumers should compare `snapshot_generation` rather than infer change from incidental row ordering,
4. `W046` owns the worksheet registration seam, but the generation behavior belongs here.

## 6. Consumer Walkthrough Summary
First-pass consumer model:
1. OxFml gets `current_snapshot()` from `LibraryContextProvider`.
2. Name resolution binds formulas against `canonical_surface_name` plus `name_resolution_table_ref`.
3. Binder preserves `surface_stable_id` and planner-facing profile fields on the bound call/operator node.
4. For seam-heavy rows, consumer also preserves:
   - `special_interface_kind`
   - `admission_interface_kind`
   - `preparation_owner`
   - `runtime_boundary_kind`
   - `arity_shape_note`
   - `interface_contract_ref`
5. Evaluation then combines:
   - runtime snapshot entry
   - `W047` typed context/query bundle
   - `W048` return-surface split
6. If registration/removal changes library-context truth, a fresh immutable snapshot generation is requested instead of mutating the bound meaning of the current snapshot silently.

## 7. Covered Current-Scope Pressure Cases
This runtime model is already sufficient for the currently covered seam-heavy scope:
1. `LET` / `LAMBDA` planning rows from `W044`
2. `RTD`
3. `TRANSLATE`
4. `CALL`
5. `REGISTER.ID`
6. `OP_IMPLICIT_INTERSECTION`
7. presentation-aware functions such as `NOW`, `TODAY`, and `HYPERLINK`

## 8. Boundaries
This packet does not freeze:
1. final cross-repo ABI naming
2. final registered-external descriptor shape
3. host/provider runtime capability state
4. callable minimum carrier beyond already-converged first-freeze needs

## 9. Artifacts
This packet currently binds:
1. `docs/worksets/W049_RUNTIME_LIBRARY_CONTEXT_PROVIDER_CONSUMER_MODEL.md`
2. `docs/function-lane/W49_RUNTIME_LIBRARY_CONTEXT_CSV_TO_RUNTIME_MAPPING.csv`
3. `docs/function-lane/W49_RUNTIME_LIBRARY_CONTEXT_CONSUMER_WALKTHROUGH.md`
4. `docs/function-lane/W49_EXECUTION_RECORD.md`
5. `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`

## Source: `OxFunc/docs/function-lane/FUNCTION_SLICE_TYPED_CONTEXT_AND_QUERY_BUNDLE_CONTRACT_PRELIM.md`

# Function Slice - Typed Context And Query Bundle Contract (Prelim)

Workset: `W047`

## 1. Purpose
Freeze the first shared typed context/query bundle for the already-covered seam-heavy OxFunc scope.

The goal of this packet is not to invent a new abstraction layer. It is to pin the exact current OxFunc-side callback and context floor that the already-covered functions now depend on, so OxFml can consume the covered scope without side channels.

## 2. Bundle Members
The current first-freeze candidate is:
1. `ReferenceResolver`
2. time/random providers:
   - `NowProvider`
   - `TodayProvider`
   - `RandomProvider`
3. `LocaleFormatContext`
4. `HostInfoProvider`
5. `RtdProvider`
6. `RegisteredExternalProvider`

## 3. Current Shared Reading
1. the bundle stays capability-scoped and typed,
2. OxFunc keeps Excel semantic classification, worksheet-visible projection, and error policy,
3. OxFml / host provides the live workbook/application/environment/provider facts through typed queries or typed provider traits,
4. the current query names and result partitions are the first freeze candidate,
5. no pre-freeze merge or split is needed unless a concrete OxFml consumer mismatch appears.

## 4. Exact Current Bundle Surface
### 4.1 `ReferenceResolver`
Current trait:
1. `capabilities() -> ResolverCapabilities`
2. `resolve_reference(reference: ReferenceLike) -> Result<EvalValue, RefResolutionError>`
3. `caller_context() -> Option<CallerContext>`

### 4.2 Time / Random Provider Surface
Pinned current traits:
1. `NowProvider::now_serial() -> f64`
2. `TodayProvider::today_serial() -> f64`
3. `RandomProvider::random_unit() -> f64`

### 4.3 `LocaleFormatContext`
Pinned current fields:
1. `profile`
2. `date_system`
3. `parser`
4. `formatter`

Current emphasized profile fields for the covered seam-heavy slice:
1. `decimal_separator`
2. `thousands_separator`
3. `list_separator`
4. `currency_symbol`
5. `date_separator`
6. `time_separator`
7. `currency_decimals`

### 4.4 `HostInfoProvider`
Pinned current query families:
1. `query_cell_info(query: CellInfoQuery, reference: Option<ReferenceLike>) -> Result<EvalValue, HostInfoError>`
2. `query_info(query: InfoQuery) -> Result<EvalValue, HostInfoError>`
3. `query_formula_text(reference: ReferenceLike) -> Result<EvalValue, HostInfoError>`
4. `query_sheet_index(spec: SheetIdentitySpec) -> Result<EvalValue, HostInfoError>`
5. `query_sheet_count(spec: SheetCountSpec) -> Result<EvalValue, HostInfoError>`
6. `query_aggregate_reference_context(reference: ReferenceLike) -> Result<AggregateReferenceContext, HostInfoError>`
7. `query_width_conversion_mode(function: WidthConversionFunction) -> Result<WidthConversionMode, HostInfoError>`
8. `query_translate(request: TranslateRequest) -> Result<TranslateProviderResult, HostInfoError>`

### 4.5 `RtdProvider`
Pinned current request:
1. `RtdRequest`
   - `prog_id`
   - `server_name`
   - `topic_strings`

Pinned current result:
1. `RtdProviderResult::Value(EvalValue)`
2. `RtdProviderResult::NoValueYet`
3. `RtdProviderResult::CapabilityDenied`
4. `RtdProviderResult::ConnectionFailed`
5. `RtdProviderResult::ProviderError(WorksheetErrorCode)`

### 4.6 `RegisteredExternalProvider`
Pinned current typed surface:
1. `resolve_register_id(request: RegisterIdRequest) -> Result<RegisteredExternalDescriptor, RegisteredExternalProviderError>`
2. `lookup_registered_external(register_id: f64) -> Result<RegisteredExternalDescriptor, RegisteredExternalProviderError>`
3. `invoke_registered_external(descriptor: RegisteredExternalDescriptor, args: [CallArgValue]) -> Result<EvalValue, RegisteredExternalProviderError>`

Pinned current request/descriptor families:
1. `RegisterIdRequest`
   - `library_name`
   - `procedure`
   - optional `declared_type_text`
2. `RegisteredExternalDescriptor`
   - `stable_registration_id`
   - `register_id`
   - `origin_kind`
   - `display_name`
   - `library_name`
   - `procedure`
   - optional `declared_type_text`

## 5. Covered Function Dependencies
The current already-covered seam-heavy rows depend on the bundle as follows:
1. `CELL`
   - `ReferenceResolver`
   - `HostInfoProvider.query_cell_info`
2. `INFO`
   - `HostInfoProvider.query_info`
3. `ISFORMULA`
   - `HostInfoProvider.query_cell_info(CellInfoQuery::IsFormula, Some(reference))`
4. `FORMULATEXT`
   - `HostInfoProvider.query_formula_text`
5. `SHEET`
   - `HostInfoProvider.query_sheet_index`
6. `SHEETS`
   - `HostInfoProvider.query_sheet_count`
7. `SUBTOTAL`
   - `ReferenceResolver`
   - `HostInfoProvider.query_aggregate_reference_context`
8. `AGGREGATE`
   - `ReferenceResolver`
   - `HostInfoProvider.query_aggregate_reference_context`
9. `ASC` / `DBCS` / `JIS`
   - `HostInfoProvider.query_width_conversion_mode`
10. `NUMBERVALUE`
   - `LocaleFormatContext` for omitted-default separator lanes
11. `TRANSLATE`
   - `HostInfoProvider.query_translate`
12. `RTD`
   - `RtdProvider`
13. `NOW`
   - `NowProvider`
14. `TODAY`
   - `TodayProvider`
15. `RAND`
   - `RandomProvider`
16. `REGISTER.ID`
   - `RegisteredExternalProvider.resolve_register_id`
17. `CALL`
   - `RegisteredExternalProvider.lookup_registered_external`
   - `RegisteredExternalProvider.resolve_register_id`
   - `RegisteredExternalProvider.invoke_registered_external`

## 6. Ownership Split
OxFunc owns:
1. argument admission and coercion,
2. query-kind classification,
3. worksheet-visible result/error projection,
4. local deterministic subcases such as:
   - `TRANSLATE` same-language passthrough,
   - `ADDRESS` rendering,
   - width-conversion kernels once mode is known.

OxFml / host owns:
1. live workbook/application/environment/provider truth,
2. stored formula text retrieval,
3. sheet topology truth,
4. aggregate-region visibility and nested-aggregate context truth,
5. width-conversion profile truth,
6. translation provider invocation,
7. RTD lifecycle and current topic result resolution.
8. registered-external lookup, handle allocation, and actual external invocation.

## 7. First-Freeze Candidate Reading
The current first shared freeze candidate is:
1. keep the current query/result names,
2. keep the current typed result partitions,
3. keep the bundle capability-scoped rather than collapsing it into raw host objects,
4. only merge, split, or rename if concrete consumer modeling proves the current shape insufficient.

## 8. Evidence Posture
This packet does not claim new function evidence by itself.

It freezes one shared bundle from already exercised packet-local evidence in:
1. `docs/function-lane/CELL_INFO_HOST_QUERY_SEAM_PRELIM.md`
2. `docs/function-lane/FUNCTION_SLICE_REFERENCE_METADATA_AND_FORMULA_VISIBILITY_CONTRACT_PRELIM.md`
3. `docs/function-lane/FUNCTION_SLICE_ISFORMULA_CONTRACT_PRELIM.md`
4. `docs/function-lane/FUNCTION_SLICE_WIDTH_CONVERSION_HOST_PROFILE_CONTRACT_PRELIM.md`
5. `docs/function-lane/FUNCTION_SLICE_NUMBERVALUE_LOCALE_DEFAULT_CONTRACT_PRELIM.md`
6. `docs/function-lane/FUNCTION_SLICE_TRANSLATE_PROVIDER_LANGUAGE_CONTRACT_PRELIM.md`
7. `docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md`
8. `docs/function-lane/FUNCTION_SLICE_NOW_CONTRACT_PRELIM.md`
9. `docs/function-lane/FUNCTION_SLICE_RAND_CONTRACT_PRELIM.md`
10. `docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md`
11. execution records:
   - `W15_EXECUTION_RECORD.md`
   - `W34_EXECUTION_RECORD.md`
   - `W35_EXECUTION_RECORD.md`
   - `W36_EXECUTION_RECORD.md`
   - `W40_EXECUTION_RECORD.md`
   - `W43_EXECUTION_RECORD.md`
   - `W46_EXECUTION_RECORD.md`

## 9. Artifact Bindings
1. workset: `docs/worksets/W047_TYPED_CONTEXT_AND_QUERY_BUNDLE_FREEZE.md`
2. dependency map: `docs/function-lane/W47_TYPED_CONTEXT_QUERY_DEPENDENCY_MAP.csv`
3. execution record: `docs/function-lane/W47_EXECUTION_RECORD.md`
4. core traits:
   - `crates/oxfunc_core/src/resolver.rs`
   - `crates/oxfunc_core/src/locale_format.rs`
   - `crates/oxfunc_core/src/host_info.rs`
   - `crates/oxfunc_core/src/functions/rtd_fn.rs`
   - `crates/oxfunc_core/src/functions/call_register_id_family.rs`
   - `crates/oxfunc_core/src/functions/now_fn.rs`
   - `crates/oxfunc_core/src/functions/today_fn.rs`
   - `crates/oxfunc_core/src/functions/rand_fn.rs`

## Source: `OxFunc/docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1_README.md`

# OxFunc Library Context Snapshot Export V1

## 1. Purpose
This is the first explicit OxFunc-local export artifact intended to serve as the external library-context snapshot for OxFml parse, bind, semantic planning, and replay correlation.

Artifact:
1. `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`

This is a stabilization artifact, not a final cross-repo ABI.

## 2. Current Coverage
Current scope:
1. built-in worksheet functions
2. current exported evaluable operator surface plus one explicitly modeled special operator row
3. current-baseline OxFunc local canonical catalog plus operator rows
4. `534` total rows:
   - `511` functions
   - `23` operators

Current exclusions:
1. non-exported operator universe beyond the current exported operator set plus the explicitly modeled implicit-intersection row
2. externally registered functions
3. callable-value entries as direct catalog rows
4. runtime capability or provider/session state

## 3. Export Fields
Current fields:
1. `snapshot_id`
2. `snapshot_generation`
3. `source_commit_short`
4. `source_commit_full`
5. `source_tree_state`
6. `lane_id`
7. `entry_kind`
8. `registration_source_kind`
9. `surface_stable_id`
10. `xlcall_builtin_symbol`
11. `xlcall_builtin_code`
12. `canonical_surface_name`
13. `name_resolution_table_ref`
14. `semantic_trait_profile_ref`
15. `gating_profile_ref`
16. `version_marker`
17. `category`
18. `interesting`
19. `arity_min`
20. `arity_max`
21. `arg_preparation_profile`
22. `coercion_lift_profile`
23. `kernel_signature_class`
24. `determinism_class`
25. `volatility_class`
26. `host_interaction_class`
27. `thread_safety_class`
28. `fec_dependency_profile`
29. `surface_fec_dependency_profile`
30. `metadata_status`
31. `special_interface_kind`
32. `admission_interface_kind`
33. `preparation_owner`
34. `runtime_boundary_kind`
35. `arity_shape_note`
36. `interface_contract_ref`
37. `source_catalog_ref`

## 4. Field Meaning
1. `snapshot_id`
   - stable id for this exported snapshot family
2. `snapshot_generation`
   - generation date for this emitted export
3. `source_commit_short`
   - current repo commit that produced this snapshot export
4. `source_commit_full`
   - full current repo commit hash that produced this snapshot export
5. `source_tree_state`
   - `clean` or `dirty` tree state for the snapshot generation run
6. `lane_id`
   - current lane owner; fixed here as `oxfunc`
7. `entry_kind`
   - currently `built_in_function` or `built_in_operator`
8. `registration_source_kind`
   - first-pass statement of where the row comes from:
     - `built_in_catalog_function`
     - `built_in_operator_export`
     - `doc_modeled_operator`
9. `surface_stable_id`
   - current OxFunc-local stable function id candidate, emitted as `FUNC.<CANONICAL_NAME>`
10. `xlcall_builtin_symbol`
   - current `XLCALL.H` built-in `xlf*` symbol when a matched built-in code exists for the row
11. `xlcall_builtin_code`
   - current `XLCALL.H` numeric built-in function code when a matched built-in code exists for the row
12. `canonical_surface_name`
   - canonical English surface name from the current local catalog, or current operator canonical name
13. `name_resolution_table_ref`
   - pointer to the current multilingual name table seed used for localized function resolution work, or the current operator-name placeholder ref
14. `semantic_trait_profile_ref`
   - current OxFunc-local profile-family ref for function-surface semantics/admission
15. `gating_profile_ref`
   - current OxFunc-local static gating family ref
16. `version_marker`
   - current support-harvest version marker when present
17. `category`
   - support-page category carried through from the canonical catalog
18. `interesting`
   - current planning-interest flag from the canonical catalog
19. `arity_min` / `arity_max`
   - first-pass arity exposure for OxFml parse/bind work
20. `arg_preparation_profile`
   - first-pass statement of whether arguments are expected values-only or refs-visible at the adapter seam
21. `coercion_lift_profile`
   - current OxFunc-local coercion/admission family indicator
22. `kernel_signature_class`
   - coarse kernel-shape classification
23. `determinism_class`
   - deterministic, time-dependent, pseudo-random, or external-event dependent
24. `volatility_class`
   - current recalc/invalidation posture
25. `host_interaction_class`
   - current host/session interaction class
26. `thread_safety_class`
   - current runtime thread-safety posture
27. `fec_dependency_profile`
   - current adapter-level dependency summary
28. `surface_fec_dependency_profile`
   - current surface pipeline dependency summary
29. `metadata_status`
   - current extraction status for the detailed profile columns:
     - `function_meta_extracted`
     - `catalog_only`
     - `doc_modeled`
30. `special_interface_kind`
   - first-pass signal that a row is seam-heavy rather than ordinary
31. `admission_interface_kind`
   - first-pass indication of whether the row is an ordinary call, helper-formation form, higher-order call, operator form, or host-subscription call
32. `preparation_owner`
   - first-pass indication of where preparation/formation responsibility mainly sits
33. `runtime_boundary_kind`
   - first-pass indication of the runtime seam OxFml should expect after preparation
34. `arity_shape_note`
   - free-form first-pass note for special argument-shape or helper/operator admission details
35. `interface_contract_ref`
   - current best contract/workset artifact to follow for seam-heavy rows
36. `source_catalog_ref`
   - authoritative source row family for this export generation

## 5. Reading Guidance For OxFml
Current intended use:
1. parse/name recognition:
   - use `canonical_surface_name`
   - join to `name_resolution_table_ref` for localized names when the row is a function
2. bind:
   - use `surface_stable_id`
   - use `entry_kind`
   - use `gating_profile_ref`
   - use the detailed profile columns when `metadata_status = function_meta_extracted` or `doc_modeled`
   - when `special_interface_kind <> ordinary`, also use:
     - `admission_interface_kind`
     - `preparation_owner`
     - `runtime_boundary_kind`
     - `arity_shape_note`
     - `interface_contract_ref`
3. semantic planning:
   - preserve `surface_stable_id`
   - preserve `semantic_trait_profile_ref`
   - preserve snapshot identity fields
   - preserve detailed profile fields where present
   - preserve `special_interface_kind`
   - preserve `interface_contract_ref`
4. replay/proving-host correlation:
   - preserve `snapshot_id`
   - preserve `snapshot_generation`
   - preserve `source_commit_short`
   - preserve `source_commit_full`
   - preserve `source_tree_state`
   - preserve `surface_stable_id`
   - preserve `xlcall_builtin_symbol`
   - preserve `xlcall_builtin_code`

## 6. Current Honest Limits
1. This export includes the full current `W45` non-`@` operator surface plus one explicitly modeled `FUNC.OP_IMPLICIT_INTERSECTION` row, not the full future operator universe.
2. Some seam-heavy rows such as `LET` and `LAMBDA` still have blank detailed profile columns; that currently means "follow `interface_contract_ref`", not "treat as ordinary default semantics".
3. The current export is generated from the current local tree and now states that explicitly via `source_commit_short`, `source_commit_full`, and `source_tree_state`; a `dirty` row set is still useful for bounded integration rounds, but it is not the same thing as a clean committed release artifact.
4. `semantic_trait_profile_ref` and `gating_profile_ref` are currently family refs, not fully dereferenceable per-row downstream contracts.
5. `admission_interface_kind`, `preparation_owner`, `runtime_boundary_kind`, and `arity_shape_note` are first-pass OxFunc guidance fields, not yet locked shared vocabulary.
6. This export does not itself inline localized names; it points to the current multilingual seed table.
7. This export does not carry runtime capability, provider availability, caller-context, or host-query payload facts.
8. The exact final shared field set and field names are still not locked cross-repo.

Current built-in C API interop examples:
1. `FUNC.SUM`
2. `FUNC.CALL`
3. `FUNC.REGISTER.ID`
4. `FUNC.RTD`

Those rows now expose:
1. `xlcall_builtin_symbol`
2. `xlcall_builtin_code`
3. the OxFunc stable id on the same row,
4. seam refs through `interface_contract_ref`.

Current presentation-aware examples:
1. `FUNC.NOW`
2. `FUNC.TODAY`
3. `FUNC.HYPERLINK`

Those rows now expose:
1. extracted `FunctionMeta` profile columns,
2. `special_interface_kind = presentation_hinting_function`,
3. `runtime_boundary_kind = extended_value_with_presentation_hint`,
4. specific `interface_contract_ref` values back to the current function-slice contract or value-model note.

Current locale/profile/provider seam examples:
1. `FUNC.ASC`
2. `FUNC.DBCS`
3. `FUNC.JIS`
4. `FUNC.NUMBERVALUE`
5. `FUNC.TRANSLATE`

Those rows now expose:
1. curated detailed profile columns,
2. `special_interface_kind = width_conversion_host_profile` for `ASC` / `DBCS` / `JIS`,
3. `special_interface_kind = locale_default_profiled_parse` for `NUMBERVALUE`,
4. `special_interface_kind = provider_language_request` for `TRANSLATE`,
5. `runtime_boundary_kind = typed_host_width_conversion_mode` for the width-conversion family,
6. `runtime_boundary_kind = ordinary_eval_with_locale_defaults` for `NUMBERVALUE`,
7. `runtime_boundary_kind = host_provider_projection` for `TRANSLATE`,
8. direct `interface_contract_ref` pointers to the current `W034` / `W035` / `W036` contract notes.

## 7. Authoritative Sources
Current authoritative source surfaces:
1. `docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv`
2. `docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv`
3. `docs/function-lane/OXFML_OXFUNC_MINIMUM_STABILIZATION_RESPONSE_V1.md`
4. `docs/function-lane/OXFML_OXFUNC_MINIMUM_STABILIZATION_RESPONSE_V2.md`
5. `docs/worksets/W044_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_BASELINE.md`

## 8. Next Expected Refinements
1. widen operator coverage beyond the current exported operator set plus `OP_IMPLICIT_INTERSECTION`,
2. normalize direct detailed-profile fields for seam-heavy rows like `LET` and `LAMBDA`,
3. improve per-entry semantic/admission profile dereferenceability,
4. refine gating-profile projection beyond the current packet-wide default plus version-marker split,
5. add explicit export-reading examples if OxFml needs them,
6. adjust the first-pass seam-facing fields if OxFml wants a different split or naming.

## 9. Preferred Long-Term Runtime Direction
Current OxFunc reading:
1. this CSV export is the right pinned interchange artifact for bounded integration rounds, test pinning, and mismatch reporting,
2. but the preferred long-term implementation seam should be a runtime-ingested:
   - `LibraryContextProvider`
   - immutable `LibraryContextSnapshot`
3. function registration or removal should produce explicit new snapshot generations rather than mutating downstream state invisibly,
4. OxFml should therefore treat CSV ingestion as a current integration mechanism, not as the desired permanent runtime coupling.

## Source: `OxFunc/docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`

```csv
"snapshot_id","snapshot_generation","source_commit_short","source_commit_full","source_tree_state","lane_id","entry_kind","registration_source_kind","surface_stable_id","xlcall_builtin_symbol","xlcall_builtin_code","canonical_surface_name","name_resolution_table_ref","semantic_trait_profile_ref","gating_profile_ref","version_marker","category","interesting","arity_min","arity_max","arg_preparation_profile","coercion_lift_profile","kernel_signature_class","determinism_class","volatility_class","host_interaction_class","thread_safety_class","fec_dependency_profile","surface_fec_dependency_profile","metadata_status","special_interface_kind","admission_interface_kind","preparation_owner","runtime_boundary_kind","arity_shape_note","interface_contract_ref","source_catalog_ref"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ABS","xlfAbs","24","ABS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ACCRINT","xlfAccrint","469","ACCRINT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ACCRINTM","xlfAccrintm","470","ACCRINTM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ACOS","xlfAcos","99","ACOS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ACOSH","xlfAcosh","233","ACOSH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ACOT","xlfAcot","548","ACOT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ACOTH","xlfAcoth","549","ACOTH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ADDRESS","xlfAddress","219","ADDRESS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","5","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AGGREGATE","xlfAggregate","485","AGGREGATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","3","255","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","Composite","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AMORDEGRC","xlfAmordegrc","466","AMORDEGRC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AMORLINC","xlfAmorlinc","467","AMORLINC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AND","xlfAnd","36","AND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ARABIC","xlfArabic","583","ARABIC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AREAS","xlfAreas","75","AREAS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ARRAYTOTEXT","","","ARRAYTOTEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ASC","xlfAsc","214","ASC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","1","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","ApplicationState","HostSerialized","Composite","Composite","function_meta_curated","width_conversion_host_profile","ordinary_call","oxfml_then_oxfunc","typed_host_width_conversion_mode","single text arg; host profile supplies pass-through or narrow conversion mode","docs/function-lane/FUNCTION_SLICE_WIDTH_CONVERSION_HOST_PROFILE_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ASIN","xlfAsin","98","ASIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ASINH","xlfAsinh","232","ASINH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ATAN","xlfAtan","18","ATAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ATAN2","xlfAtan2","97","ATAN2","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ATANH","xlfAtanh","234","ATANH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AVEDEV","xlfAvedev","269","AVEDEV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AVERAGE","xlfAverage","5","AVERAGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AVERAGEA","xlfAveragea","361","AVERAGEA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AVERAGEIF","xlfAverageif","483","AVERAGEIF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.AVERAGEIFS","xlfAverageifs","484","AVERAGEIFS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BAHTTEXT","xlfBahttext","368","BAHTTEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","3","3","ValuesOnlyPreAdapter","Custom","Custom","PseudoRandom","VolatileFull","ApplicationState","HostSerialized","RandomProvider","RandomProvider","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BASE","xlfBase","571","BASE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BESSELI","xlfBesseli","428","BESSELI","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BESSELJ","xlfBesselj","425","BESSELJ","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BESSELK","xlfBesselk","426","BESSELK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BESSELY","xlfBessely","427","BESSELY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BETA.DIST","xlfBeta_dist","525","BETA.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BETA.INV","xlfBeta_inv","526","BETA.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BETADIST","xlfBetadist","270","BETADIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BETAINV","xlfBetainv","272","BETAINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BIN2DEC","xlfBin2dec","393","BIN2DEC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BIN2HEX","xlfBin2hex","395","BIN2HEX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BIN2OCT","xlfBin2oct","394","BIN2OCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BINOM.DIST","xlfBinom_dist","486","BINOM.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BINOM.DIST.RANGE","xlfBinom_dist_range","574","BINOM.DIST.RANGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BINOM.INV","xlfBinom_inv","487","BINOM.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BINOMDIST","xlfBinomdist","273","BINOMDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BITAND","xlfBitand","562","BITAND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BITLSHIFT","xlfBitlshift","565","BITLSHIFT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BITOR","xlfBitor","563","BITOR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BITRSHIFT","xlfBitrshift","566","BITRSHIFT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BITXOR","xlfBitxor","564","BITXOR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BYCOL","","","BYCOL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","higher_order_call","oxfml_then_oxfunc","callable_helper_runtime","array plus callable applied per column","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.BYROW","","","BYROW","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","higher_order_call","oxfml_then_oxfunc","callable_helper_runtime","array plus callable applied per row","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CALL","xlfCall","150","CALL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","User defined functions that are installed with add-ins","false","1","255","RefsVisibleInAdapter","Custom","Custom","ExternalEventDependent","VolatileContextual","ApplicationState","HostSerialized","ExternalProvider","Composite","function_meta_extracted","registered_external_invocation","macro_or_host_registered_call","oxfml_then_oxfunc_then_host_registered_external","registered_external_provider_projection","either numeric register_id target or direct library/procedure[/type_text] target; trailing args stay raw for host external invocation","docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CEILING","xlfCeiling","288","CEILING","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CEILING.MATH","xlfCeiling_math","591","CEILING.MATH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CEILING.PRECISE","xlfCeiling_precise","546","CEILING.PRECISE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CELL","xlfCell","125","CELL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","1","2","RefsVisibleInAdapter","Custom","Custom","Deterministic","VolatileContextual","WorkbookState","HostSerialized","CallerContext","CallerContext","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHAR","xlfChar","111","CHAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","1","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHIDIST","xlfChidist","274","CHIDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHIINV","xlfChiinv","275","CHIINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHISQ.DIST","xlfChisq_dist","527","CHISQ.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHISQ.DIST.RT","xlfChisq_dist_rt","528","CHISQ.DIST.RT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHISQ.INV","xlfChisq_inv","529","CHISQ.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHISQ.INV.RT","xlfChisq_inv_rt","530","CHISQ.INV.RT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHISQ.TEST","xlfChisq_test","490","CHISQ.TEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHITEST","xlfChitest","306","CHITEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHOOSE","xlfChoose","100","CHOOSE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","2","255","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHOOSECOLS","","","CHOOSECOLS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CHOOSEROWS","","","CHOOSEROWS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CLEAN","xlfClean","162","CLEAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","1","ValuesOnlyPreAdapter","None","TextToText","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CODE","xlfCode","121","CODE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COLUMN","xlfColumn","9","COLUMN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","0","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","CallerContext","CallerContext","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COLUMNS","xlfColumns","77","COLUMNS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COMBIN","xlfCombin","276","COMBIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COMBINA","xlfCombina","568","COMBINA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COMPLEX","xlfComplex","411","COMPLEX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CONCAT","","","CONCAT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","253","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CONCATENATE","xlfConcatenate","336","CONCATENATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CONFIDENCE","xlfConfidence","277","CONFIDENCE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CONFIDENCE.NORM","xlfConfidence_norm","488","CONFIDENCE.NORM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CONFIDENCE.T","xlfConfidence_t","489","CONFIDENCE.T","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","3","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CONVERT","xlfConvert","468","CONVERT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COPILOT","","","COPILOT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CORREL","xlfCorrel","307","CORREL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COS","xlfCos","16","COS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COSH","xlfCosh","230","COSH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COT","xlfCot","550","COT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COTH","xlfCoth","551","COTH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUNT","xlfCount","0","COUNT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUNTA","xlfCounta","169","COUNTA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUNTBLANK","xlfCountblank","347","COUNTBLANK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUNTIF","xlfCountif","346","COUNTIF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUNTIFS","xlfCountifs","481","COUNTIFS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUPDAYBS","xlfCoupdaybs","452","COUPDAYBS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUPDAYS","xlfCoupdays","453","COUPDAYS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUPDAYSNC","xlfCoupdaysnc","454","COUPDAYSNC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUPNCD","xlfCoupncd","455","COUPNCD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUPNUM","xlfCoupnum","456","COUPNUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COUPPCD","xlfCouppcd","457","COUPPCD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COVAR","xlfCovar","308","COVAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COVARIANCE.P","xlfCovariance_p","492","COVARIANCE.P","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.COVARIANCE.S","xlfCovariance_s","493","COVARIANCE.S","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CRITBINOM","xlfCritbinom","278","CRITBINOM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CSC","xlfCsc","552","CSC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CSCH","xlfCsch","553","CSCH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBEKPIMEMBER","xlfCubekpimember","477","CUBEKPIMEMBER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBEMEMBER","xlfCubemember","381","CUBEMEMBER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBEMEMBERPROPERTY","xlfCubememberproperty","382","CUBEMEMBERPROPERTY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBERANKEDMEMBER","xlfCuberankedmember","383","CUBERANKEDMEMBER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBESET","xlfCubeset","478","CUBESET","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBESETCOUNT","xlfCubesetcount","479","CUBESETCOUNT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUBEVALUE","xlfCubevalue","380","CUBEVALUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Cubes","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUMIPMT","xlfCumipmt","448","CUMIPMT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.CUMPRINC","xlfCumprinc","447","CUMPRINC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DATE","xlfDate","65","DATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","3","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DATEDIF","xlfDatedif","351","DATEDIF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DATEVALUE","xlfDatevalue","140","DATEVALUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DAVERAGE","xlfDaverage","42","DAVERAGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DAY","xlfDay","67","DAY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DAYS","xlfDays","573","DAYS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DAYS360","xlfDays360","220","DAYS360","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DB","xlfDb","247","DB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DBCS","xlfDbcs","215","DBCS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","1","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","ApplicationState","HostSerialized","Composite","Composite","function_meta_curated","width_conversion_host_profile","ordinary_call","oxfml_then_oxfunc","typed_host_width_conversion_mode","single text arg; host profile supplies pass-through or narrow conversion mode","docs/function-lane/FUNCTION_SLICE_WIDTH_CONVERSION_HOST_PROFILE_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DCOUNT","xlfDcount","40","DCOUNT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DCOUNTA","xlfDcounta","199","DCOUNTA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DDB","xlfDdb","144","DDB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DEC2BIN","xlfDec2bin","387","DEC2BIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DEC2HEX","xlfDec2hex","388","DEC2HEX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DEC2OCT","xlfDec2oct","389","DEC2OCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DECIMAL","xlfDecimal","572","DECIMAL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DEGREES","xlfDegrees","343","DEGREES","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DELTA","xlfDelta","418","DELTA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","1","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DETECTLANGUAGE","","","DETECTLANGUAGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DEVSQ","xlfDevsq","318","DEVSQ","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DGET","xlfDget","235","DGET","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DISC","xlfDisc","435","DISC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DMAX","xlfDmax","44","DMAX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DMIN","xlfDmin","43","DMIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DOLLAR","xlfDollar","13","DOLLAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","true","1","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","LocaleProfile","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DOLLARDE","xlfDollarde","443","DOLLARDE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DOLLARFR","xlfDollarfr","444","DOLLARFR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DPRODUCT","xlfDproduct","189","DPRODUCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DROP","","","DROP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DSTDEV","xlfDstdev","45","DSTDEV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DSTDEVP","xlfDstdevp","195","DSTDEVP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DSUM","xlfDsum","41","DSUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DURATION","xlfDuration","458","DURATION","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DVAR","xlfDvar","47","DVAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.DVARP","xlfDvarp","196","DVARP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Database functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EDATE","xlfEdate","449","EDATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EFFECT","xlfEffect","446","EFFECT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ENCODEURL","xlfEncodeurl","597","ENCODEURL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Web functions","true","1","1","ValuesOnlyPreAdapter","Custom","TextToText","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EOMONTH","xlfEomonth","450","EOMONTH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ERF","xlfErf","423","ERF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ERF.PRECISE","xlfErf_precise","543","ERF.PRECISE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ERFC","xlfErfc","424","ERFC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ERFC.PRECISE","xlfErfc_precise","544","ERFC.PRECISE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ERROR.TYPE","","","ERROR.TYPE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EUROCONVERT","","","EUROCONVERT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","User defined functions that are installed with add-ins","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EVEN","xlfEven","279","EVEN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EXACT","xlfExact","117","EXACT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","2","2","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EXP","xlfExp","21","EXP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EXPAND","","","EXPAND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","4","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EXPON.DIST","xlfExpon_dist","494","EXPON.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.EXPONDIST","xlfExpondist","280","EXPONDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.F.DIST","xlfF_dist","531","F.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.F.DIST.RT","xlfF_dist_rt","532","F.DIST.RT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.F.INV","xlfF_inv","533","F.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.F.INV.RT","xlfF_inv_rt","534","F.INV.RT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.F.TEST","xlfF_test","491","F.TEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FACT","xlfFact","184","FACT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FACTDOUBLE","xlfFactdouble","415","FACTDOUBLE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FALSE","xlfFalse","35","FALSE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","0","0","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FDIST","xlfFdist","281","FDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FILTER","","","FILTER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","true","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FILTERXML","xlfFilterxml","595","FILTERXML","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Web functions","true","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FIND, FINDB","","","FIND, FINDB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FINV","xlfFinv","282","FINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FISHER","xlfFisher","283","FISHER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FISHERINV","xlfFisherinv","284","FISHERINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FIXED","xlfFixed","14","FIXED","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","true","1","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","LocaleProfile","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FLOOR","xlfFloor","285","FLOOR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FLOOR.MATH","xlfFloor_math","592","FLOOR.MATH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FLOOR.PRECISE","xlfFloor_precise","547","FLOOR.PRECISE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FORECAST","xlfForecast","309","FORECAST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FORECAST.LINEAR","","","FORECAST.LINEAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FORMULATEXT","xlfFormulatext","588","FORMULATEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FREQUENCY","xlfFrequency","252","FREQUENCY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FTEST","xlfFtest","310","FTEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FV","xlfFv","57","FV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.FVSCHEDULE","xlfFvschedule","476","FVSCHEDULE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMA","xlfGamma","575","GAMMA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMA.DIST","xlfGamma_dist","495","GAMMA.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMA.INV","xlfGamma_inv","496","GAMMA.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMADIST","xlfGammadist","286","GAMMADIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMAINV","xlfGammainv","287","GAMMAINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMALN","xlfGammaln","271","GAMMALN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAMMALN.PRECISE","xlfGammaln_precise","545","GAMMALN.PRECISE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GAUSS","xlfGauss","577","GAUSS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GCD","xlfGcd","473","GCD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GEOMEAN","xlfGeomean","319","GEOMEAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GESTEP","xlfGestep","419","GESTEP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","1","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GETPIVOTDATA","xlfGetpivotdata","358","GETPIVOTDATA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GROUPBY","","","GROUPBY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","3","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.GROWTH","xlfGrowth","52","GROWTH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HARMEAN","xlfHarmean","320","HARMEAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HEX2BIN","xlfHex2bin","384","HEX2BIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HEX2DEC","xlfHex2dec","385","HEX2DEC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HEX2OCT","xlfHex2oct","386","HEX2OCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HLOOKUP","xlfHlookup","101","HLOOKUP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HOUR","xlfHour","71","HOUR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HSTACK","","","HSTACK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HYPERLINK","xlfHyperlink","359","HYPERLINK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","1","2","ValuesOnlyPreAdapter","Custom","TextToText","Deterministic","NonVolatile","EnvironmentState","HostSerialized","Composite","Composite","function_meta_extracted","presentation_hinting_function","ordinary_call","oxfml_then_oxfunc","extended_value_with_presentation_hint","link location plus optional friendly name; extended path returns text value plus style=hyperlink hint","docs/function-lane/FUNCTION_SLICE_HYPERLINK_IMAGE_VALUE_MODEL_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HYPGEOM.DIST","xlfHypgeom_dist","535","HYPGEOM.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.HYPGEOMDIST","xlfHypgeomdist","289","HYPGEOMDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IF","","","IF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","2","3","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IFERROR","xlfIferror","480","IFERROR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","2","2","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IFNA","xlfIfna","590","IFNA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","2","2","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IFS","","","IFS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMABS","xlfImabs","399","IMABS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMAGE","","","IMAGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMAGINARY","xlfImaginary","409","IMAGINARY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMARGUMENT","xlfImargument","407","IMARGUMENT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMCONJUGATE","xlfImconjugate","408","IMCONJUGATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMCOS","xlfImcos","405","IMCOS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMCOSH","xlfImcosh","594","IMCOSH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMCOT","xlfImcot","557","IMCOT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMCSC","xlfImcsc","558","IMCSC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMCSCH","xlfImcsch","559","IMCSCH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMDIV","xlfImdiv","397","IMDIV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMEXP","xlfImexp","406","IMEXP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMLN","xlfImln","401","IMLN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMLOG10","xlfImlog10","403","IMLOG10","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMLOG2","xlfImlog2","402","IMLOG2","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMPOWER","xlfImpower","398","IMPOWER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMPRODUCT","xlfImproduct","413","IMPRODUCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMREAL","xlfImreal","410","IMREAL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSEC","xlfImsec","560","IMSEC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSECH","xlfImsech","561","IMSECH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSIN","xlfImsin","404","IMSIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSINH","xlfImsinh","593","IMSINH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSQRT","xlfImsqrt","400","IMSQRT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSUB","xlfImsub","396","IMSUB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMSUM","xlfImsum","412","IMSUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IMTAN","xlfImtan","556","IMTAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.INDEX","xlfIndex","29","INDEX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","4","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.INDIRECT","xlfIndirect","148","INDIRECT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","VolatileContextual","WorkbookState","HostSerialized","CallerContext","CallerContext","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.INFO","xlfInfo","244","INFO","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","VolatileContextual","WorkbookState","HostSerialized","Composite","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.INT","xlfInt","25","INT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.INTERCEPT","xlfIntercept","311","INTERCEPT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.INTRATE","xlfIntrate","433","INTRATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IPMT","xlfIpmt","167","IPMT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.IRR","xlfIrr","62","IRR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISBLANK","xlfIsblank","129","ISBLANK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISERR","xlfIserr","126","ISERR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISERROR","xlfIserror","3","ISERROR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISEVEN","xlfIseven","420","ISEVEN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISFORMULA","xlfIsformula","589","ISFORMULA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","Composite","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISLOGICAL","xlfIslogical","198","ISLOGICAL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISNA","xlfIsna","2","ISNA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISNONTEXT","xlfIsnontext","190","ISNONTEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISNUMBER","xlfIsnumber","128","ISNUMBER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","1","1","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISO.CEILING","xlfIso_ceiling","523","ISO.CEILING","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISODD","xlfIsodd","421","ISODD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISOMITTED","","","ISOMITTED","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","callable_runtime_helper","oxfml_then_oxfunc","callable_helper_runtime_after_formation","single argument; meaning is helper-runtime-sensitive","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISOWEEKNUM","xlfIsoweeknum","584","ISOWEEKNUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISPMT","xlfIspmt","350","ISPMT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISREF","xlfIsref","105","ISREF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ISTEXT","xlfIstext","127","ISTEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.JIS","","","JIS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","1","1","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","ApplicationState","HostSerialized","Composite","Composite","function_meta_curated","width_conversion_host_profile","ordinary_call","oxfml_then_oxfunc","typed_host_width_conversion_mode","single text arg; host profile supplies widen or unavailable mode","docs/function-lane/FUNCTION_SLICE_WIDTH_CONVERSION_HOST_PROFILE_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.KURT","xlfKurt","322","KURT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LAMBDA","","","LAMBDA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_formation","helper_formation","oxfml_then_oxfunc","callable_helper_runtime_after_formation","trailing arg is body; preceding args are parameter names","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LARGE","xlfLarge","325","LARGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LCM","xlfLcm","475","LCM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LEFT, LEFTB","","","LEFT, LEFTB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LEN, LENB","","","LEN, LENB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LET","","","LET","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","true","","","","","","","","","","","","catalog_only","callable_helper_formation","helper_formation","oxfml_then_oxfunc","callable_helper_runtime_after_formation","odd-style helper shape: final arg is body; preceding args form name/value pairs","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LINEST","xlfLinest","49","LINEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LN","xlfLn","22","LN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOG","xlfLog","109","LOG","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOG10","xlfLog10","23","LOG10","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOGEST","xlfLogest","51","LOGEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOGINV","xlfLoginv","291","LOGINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOGNORM.DIST","xlfLognorm_dist","536","LOGNORM.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOGNORM.INV","xlfLognorm_inv","537","LOGNORM.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOGNORMDIST","xlfLognormdist","290","LOGNORMDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOOKUP","xlfLookup","28","LOOKUP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.LOWER","xlfLower","112","LOWER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MAKEARRAY","","","MAKEARRAY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","higher_order_call","oxfml_then_oxfunc","callable_helper_runtime","rows, cols, callable producing each coordinate cell","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MAP","","","MAP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","higher_order_call","oxfml_then_oxfunc","callable_helper_runtime","trailing arg callable; preceding args are mapped arrays","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MATCH","xlfMatch","64","MATCH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","2","3","RefsVisibleInAdapter","LookupMatchProfile","LookupMatch","Deterministic","NonVolatile","None","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MAX","xlfMax","7","MAX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MAXA","xlfMaxa","362","MAXA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MAXIFS","","","MAXIFS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MDETERM","xlfMdeterm","163","MDETERM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MDURATION","xlfMduration","459","MDURATION","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MEDIAN","xlfMedian","227","MEDIAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MID, MIDB","","","MID, MIDB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MIN","xlfMin","6","MIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MINA","xlfMina","363","MINA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MINIFS","","","MINIFS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MINUTE","xlfMinute","72","MINUTE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MINVERSE","xlfMinverse","164","MINVERSE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MIRR","xlfMirr","61","MIRR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MMULT","xlfMmult","165","MMULT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MOD","xlfMod","39","MOD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MODE","xlfMode","330","MODE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MODE.MULT","xlfMode_mult","497","MODE.MULT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MODE.SNGL","xlfMode_sngl","498","MODE.SNGL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MONTH","xlfMonth","68","MONTH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MROUND","xlfMround","422","MROUND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MULTINOMIAL","xlfMultinomial","474","MULTINOMIAL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.MUNIT","xlfMunit","582","MUNIT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.N","xlfN","131","N","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NA","xlfNa","10","NA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","false","0","0","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NEGBINOM.DIST","xlfNegbinom_dist","538","NEGBINOM.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NEGBINOMDIST","xlfNegbinomdist","292","NEGBINOMDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NETWORKDAYS","xlfNetworkdays","472","NETWORKDAYS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NETWORKDAYS.INTL","xlfNetworkdays_intl","520","NETWORKDAYS.INTL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NOMINAL","xlfNominal","445","NOMINAL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORM.DIST","xlfNorm_dist","499","NORM.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORM.INV","xlfNorm_inv","500","NORM.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORM.S.DIST","xlfNorm_s_dist","539","NORM.S.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORM.S.INV","xlfNorm_s_inv","540","NORM.S.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORMDIST","xlfNormdist","293","NORMDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORMINV","xlfNorminv","295","NORMINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORMSDIST","xlfNormsdist","294","NORMSDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NORMSINV","xlfNormsinv","296","NORMSINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NOT","xlfNot","38","NOT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NOW","xlfNow","74","NOW","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","true","0","0","ValuesOnlyPreAdapter","None","Custom","TimeDependent","VolatileFull","ApplicationState","HostSerialized","TimeProvider","TimeProvider","function_meta_extracted","presentation_hinting_function","ordinary_call","oxfml_then_oxfunc","extended_value_with_presentation_hint","nullary ordinary call; extended path returns numeric value plus number_format hint","docs/function-lane/FUNCTION_SLICE_NOW_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NPER","xlfNper","58","NPER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NPV","xlfNpv","11","NPV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.NUMBERVALUE","xlfNumbervalue","585","NUMBERVALUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","LocaleProfile","LocaleProfile","function_meta_curated","locale_default_profiled_parse","ordinary_call","oxfml_then_oxfunc","ordinary_eval_with_locale_defaults","text plus optional decimal/group separators; omitted separators come from locale profile","docs/function-lane/FUNCTION_SLICE_NUMBERVALUE_LOCALE_DEFAULT_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.OCT2BIN","xlfOct2bin","390","OCT2BIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.OCT2DEC","xlfOct2dec","392","OCT2DEC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.OCT2HEX","xlfOct2hex","391","OCT2HEX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Engineering functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ODD","xlfOdd","298","ODD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ODDFPRICE","xlfOddfprice","462","ODDFPRICE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ODDFYIELD","xlfOddfyield","463","ODDFYIELD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ODDLPRICE","xlfOddlprice","460","ODDLPRICE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ODDLYIELD","xlfOddlyield","461","ODDLYIELD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.OFFSET","xlfOffset","78","OFFSET","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","3","5","RefsVisibleInAdapter","Custom","Custom","Deterministic","VolatileContextual","WorkbookState","HostSerialized","CallerContext","CallerContext","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.OR","xlfOr","37","OR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PDURATION","xlfPduration","570","PDURATION","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PEARSON","xlfPearson","312","PEARSON","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTILE","xlfPercentile","328","PERCENTILE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTILE.EXC","xlfPercentile_exc","501","PERCENTILE.EXC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTILE.INC","xlfPercentile_inc","502","PERCENTILE.INC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTOF","","","PERCENTOF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTRANK","xlfPercentrank","329","PERCENTRANK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTRANK.EXC","xlfPercentrank_exc","503","PERCENTRANK.EXC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERCENTRANK.INC","xlfPercentrank_inc","504","PERCENTRANK.INC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERMUT","xlfPermut","299","PERMUT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PERMUTATIONA","xlfPermutationa","567","PERMUTATIONA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PHI","xlfPhi","578","PHI","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PHONETIC","xlfPhonetic","360","PHONETIC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PI","xlfPi","19","PI","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","0","0","ValuesOnlyPreAdapter","None","NullaryConst","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PIVOTBY","","","PIVOTBY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","4","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PMT","xlfPmt","59","PMT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.POISSON","xlfPoisson","300","POISSON","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.POISSON.DIST","xlfPoisson_dist","505","POISSON.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.POWER","xlfPower","337","POWER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PPMT","xlfPpmt","168","PPMT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PRICE","xlfPrice","441","PRICE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PRICEDISC","xlfPricedisc","436","PRICEDISC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PRICEMAT","xlfPricemat","431","PRICEMAT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PROB","xlfProb","317","PROB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PRODUCT","xlfProduct","183","PRODUCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PROPER","xlfProper","114","PROPER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.PV","xlfPv","56","PV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.QUARTILE","xlfQuartile","327","QUARTILE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.QUARTILE.EXC","xlfQuartile_exc","506","QUARTILE.EXC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.QUARTILE.INC","xlfQuartile_inc","507","QUARTILE.INC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.QUOTIENT","xlfQuotient","417","QUOTIENT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RADIANS","xlfRadians","342","RADIANS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RAND","xlfRand","63","RAND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","true","0","0","ValuesOnlyPreAdapter","None","Custom","PseudoRandom","VolatileFull","ApplicationState","HostSerialized","RandomProvider","RandomProvider","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RANDARRAY","","","RANDARRAY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RANDBETWEEN","xlfRandbetween","464","RANDBETWEEN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","true","2","2","ValuesOnlyPreAdapter","Custom","Custom","PseudoRandom","VolatileFull","ApplicationState","HostSerialized","RandomProvider","RandomProvider","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RANK","xlfRank","216","RANK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RANK.AVG","xlfRank_avg","508","RANK.AVG","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RANK.EQ","xlfRank_eq","509","RANK.EQ","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RATE","xlfRate","60","RATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RECEIVED","xlfReceived","434","RECEIVED","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REDUCE","","","REDUCE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","higher_order_call","oxfml_then_oxfunc","callable_helper_runtime","initial accumulator, array, callable","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REGEXEXTRACT","","","REGEXEXTRACT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REGEXREPLACE","","","REGEXREPLACE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REGEXTEST","","","REGEXTEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REGISTER.ID","xlfRegisterId","267","REGISTER.ID","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","User defined functions that are installed with add-ins","false","2","3","ValuesOnlyPreAdapter","Custom","Custom","ExternalEventDependent","NonVolatile","ApplicationState","HostSerialized","ExternalProvider","ExternalProvider","function_meta_extracted","registered_external_registration","registered_external_lookup","oxfml_then_oxfunc_then_host_registered_external","registered_external_provider_projection","library name, procedure name/ordinal, optional type_text; returns numeric register id from host registration seam","docs/function-lane/FUNCTION_SLICE_CALL_REGISTER_ID_UDF_REGISTRATION_SEAM_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REPLACE, REPLACEB","","","REPLACE, REPLACEB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.REPT","xlfRept","30","REPT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RIGHT, RIGHTB","","","RIGHT, RIGHTB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ROMAN","xlfRoman","354","ROMAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ROUND","xlfRound","27","ROUND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","UnaryNumericScalarOnly","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ROUNDDOWN","xlfRounddown","213","ROUNDDOWN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ROUNDUP","xlfRoundup","212","ROUNDUP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ROW","xlfRow","8","ROW","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","0","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","CallerContext","CallerContext","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ROWS","xlfRows","76","ROWS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RRI","xlfRri","579","RRI","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RSQ","xlfRsq","313","RSQ","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.RTD","xlfRtd","379","RTD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","3","255","ValuesOnlyPreAdapter","Custom","Custom","ExternalEventDependent","VolatileContextual","ExternalProvider","HostSerialized","ExternalProvider","ExternalProvider","function_meta_extracted","host_subscription_provider","host_subscription_call","host_above_oxfunc_then_oxfunc_projection","host_provider_projection","prog_id, server_name, then ordered topic strings","docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SCAN","","","SCAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","true","","","","","","","","","","","","catalog_only","callable_helper_runtime","higher_order_call","oxfml_then_oxfunc","callable_helper_runtime","initial accumulator, array, callable","docs/worksets/W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SEARCH, SEARCHB","","","SEARCH, SEARCHB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SEC","xlfSec","554","SEC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SECH","xlfSech","555","SECH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SECOND","xlfSecond","73","SECOND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SEQUENCE","","","SEQUENCE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","true","1","4","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SERIESSUM","xlfSeriessum","414","SERIESSUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SHEET","xlfSheet","586","SHEET","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","0","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","Composite","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SHEETS","xlfSheets","587","SHEETS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","0","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","RefOnly","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SIGN","xlfSign","26","SIGN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SIN","xlfSin","15","SIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SINH","xlfSinh","229","SINH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SKEW","xlfSkew","323","SKEW","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SKEW.P","xlfSkew_p","576","SKEW.P","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SLN","xlfSln","142","SLN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SLOPE","xlfSlope","315","SLOPE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SMALL","xlfSmall","326","SMALL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SORT","","","SORT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","4","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SORTBY","","","SORTBY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","30","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SQRT","xlfSqrt","20","SQRT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SQRTPI","xlfSqrtpi","416","SQRTPI","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STANDARDIZE","xlfStandardize","297","STANDARDIZE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","3","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STDEV","xlfStdev","12","STDEV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STDEV.P","xlfStdev_p","511","STDEV.P","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STDEV.S","xlfStdev_s","510","STDEV.S","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STDEVA","xlfStdeva","366","STDEVA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STDEVP","xlfStdevp","193","STDEVP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STDEVPA","xlfStdevpa","364","STDEVPA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STEYX","xlfSteyx","314","STEYX","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.STOCKHISTORY","","","STOCKHISTORY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUBSTITUTE","xlfSubstitute","120","SUBSTITUTE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUBTOTAL","xlfSubtotal","344","SUBTOTAL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","2","255","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","Composite","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUM","xlfSum","4","SUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMIF","xlfSumif","345","SUMIF","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","true","2","3","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","RefOnly","RefOnly","function_meta_curated","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMIFS","xlfSumifs","482","SUMIFS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMPRODUCT","xlfSumproduct","228","SUMPRODUCT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMSQ","xlfSumsq","321","SUMSQ","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMX2MY2","xlfSumx2my2","304","SUMX2MY2","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMX2PY2","xlfSumx2py2","305","SUMX2PY2","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SUMXMY2","xlfSumxmy2","303","SUMXMY2","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SWITCH","","","SWITCH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","3","255","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.SYD","xlfSyd","143","SYD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T","xlfT","130","T","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","true","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T.DIST","xlfT_dist","512","T.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T.DIST.2T","xlfT_dist_2t","513","T.DIST.2T","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T.DIST.RT","xlfT_dist_rt","514","T.DIST.RT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T.INV","xlfT_inv","515","T.INV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T.INV.2T","xlfT_inv_2t","516","T.INV.2T","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.T.TEST","xlfT_test","541","T.TEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TAKE","","","TAKE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TAN","xlfTan","17","TAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TANH","xlfTanh","231","TANH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","1","ValuesOnlyPreAdapter","UnaryNumericScalarOrArrayElementwise","NumToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TBILLEQ","xlfTbilleq","438","TBILLEQ","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TBILLPRICE","xlfTbillprice","439","TBILLPRICE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TBILLYIELD","xlfTbillyield","440","TBILLYIELD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TDIST","xlfTdist","301","TDIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TEXT","xlfText","48","TEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","true","2","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","LocaleProfile","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TEXTAFTER","","","TEXTAFTER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TEXTBEFORE","","","TEXTBEFORE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TEXTJOIN","","","TEXTJOIN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","3","255","ValuesOnlyPreAdapter","Custom","TextToText","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TEXTSPLIT","","","TEXTSPLIT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TIME","xlfTime","66","TIME","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TIMEVALUE","xlfTimevalue","141","TIMEVALUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TINV","xlfTinv","332","TINV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TOCOL","","","TOCOL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TODAY","xlfToday","221","TODAY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","true","0","0","ValuesOnlyPreAdapter","None","Custom","TimeDependent","VolatileFull","ApplicationState","HostSerialized","TimeProvider","TimeProvider","function_meta_extracted","presentation_hinting_function","ordinary_call","oxfml_then_oxfunc","extended_value_with_presentation_hint","nullary ordinary call; extended path returns numeric value plus number_format hint","docs/function-lane/FUNCTION_SLICE_TODAY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TOROW","","","TOROW","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRANSLATE","","","TRANSLATE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","ExternalProvider","HostSerialized","ExternalProvider","ExternalProvider","function_meta_curated","provider_language_request","ordinary_call","oxfml_then_oxfunc","host_provider_projection","text plus optional source/target language tags; same-language local passthrough, otherwise provider query","docs/function-lane/FUNCTION_SLICE_TRANSLATE_PROVIDER_LANGUAGE_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRANSPOSE","xlfTranspose","83","TRANSPOSE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TREND","xlfTrend","50","TREND","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRIM","xlfTrim","118","TRIM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRIMMEAN","xlfTrimmean","331","TRIMMEAN","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRIMRANGE","","","TRIMRANGE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","4","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRUE","xlfTrue","34","TRUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","0","0","ValuesOnlyPreAdapter","None","Custom","Deterministic","NonVolatile","None","SafePure","None","None","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TRUNC","xlfTrunc","197","TRUNC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Math and trigonometry functions","false","1","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TTEST","xlfTtest","316","TTEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.TYPE","xlfType","86","TYPE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Information functions","true","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.UNICHAR","xlfUnichar","580","UNICHAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.UNICODE","xlfUnicode","581","UNICODE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.UNIQUE","","","UNIQUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","true","1","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.UPPER","xlfUpper","113","UPPER","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VALUE","xlfValue","33","VALUE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","true","1","1","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","LocaleProfile","Composite","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VALUETOTEXT","","","VALUETOTEXT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Text functions","true","1","2","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VAR","xlfVar","46","VAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VAR.P","xlfVar_p","518","VAR.P","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VAR.S","xlfVar_s","517","VAR.S","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VARA","xlfVara","367","VARA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VARP","xlfVarp","194","VARP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VARPA","xlfVarpa","365","VARPA","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","1","255","ValuesOnlyPreAdapter","AggregateDirectAndRangeDualPolicy","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VDB","xlfVdb","222","VDB","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VLOOKUP","xlfVlookup","102","VLOOKUP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.VSTACK","","","VSTACK","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WEBSERVICE","xlfWebservice","596","WEBSERVICE","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Web functions","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WEEKDAY","xlfWeekday","70","WEEKDAY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WEEKNUM","xlfWeeknum","465","WEEKNUM","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WEIBULL","xlfWeibull","302","WEIBULL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WEIBULL.DIST","xlfWeibull_dist","519","WEIBULL.DIST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WORKDAY","xlfWorkday","471","WORKDAY","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WORKDAY.INTL","xlfWorkday_intl","521","WORKDAY.INTL","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WRAPCOLS","","","WRAPCOLS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.WRAPROWS","","","WRAPROWS","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","3","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/function-lane/FUNCTION_SLICE_DYNAMIC_ARRAY_SHAPING_AND_RESHAPING_FAMILY_CONTRACT_PRELIM.md","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.XIRR","xlfXirr","429","XIRR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.XLOOKUP","","","XLOOKUP","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Our 10 featured functions","true","3","6","RefsVisibleInAdapter","Custom","LookupMatch","Deterministic","NonVolatile","WorkbookState","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.XMATCH","","","XMATCH","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Lookup and reference functions","true","2","4","ValuesOnlyPreAdapter","LookupMatchProfile","LookupMatch","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.XNPV","xlfXnpv","430","XNPV","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.XOR","xlfXor","569","XOR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Logical functions","false","1","255","ValuesOnlyPreAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.YEAR","xlfYear","69","YEAR","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.YEARFRAC","xlfYearfrac","451","YEARFRAC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Date and time functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.YIELD","xlfYield","442","YIELD","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.YIELDDISC","xlfYielddisc","437","YIELDDISC","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.YIELDMAT","xlfYieldmat","432","YIELDMAT","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Financial functions","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.Z.TEST","xlfZ_test","542","Z.TEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Statistical functions","false","2","3","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","None","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_function","built_in_catalog_function","FUNC.ZTEST","xlfZtest","324","ZTEST","docs/function-lane/W28_FUNCTION_NAME_LOCALIZATION_LIBRARY_SEED.csv","oxfunc.local.profile.function_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Compatibility","false","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","","docs/function-lane/FUNCTION_CATALOG_CURRENT_BASELINE_LOCAL.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_ADD","","","OP_ADD","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","2","2","ValuesOnlyPreAdapter","Custom","NumsToNum","Deterministic","NonVolatile","None","SafePure","None","RefOnly","function_meta_extracted","ordinary","operator_form","oxfml_then_oxfunc","ordinary_eval","binary operator operands","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_CONCAT","","","OP_CONCAT","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_DIVIDE","","","OP_DIVIDE","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_EQUAL","","","OP_EQUAL","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_GREATER_EQUAL","","","OP_GREATER_EQUAL","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_GREATER_THAN","","","OP_GREATER_THAN","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","doc_modeled_operator","FUNC.OP_IMPLICIT_INTERSECTION","","","OP_IMPLICIT_INTERSECTION","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","HostSerialized","Composite","Composite","doc_modeled","implicit_intersection_operator","operator_form","oxfml_then_oxfunc","caller_context_scalarization","single operand/operator source","docs/function-lane/IMPLICIT_INTERSECTION_OPERATOR_INVESTIGATION.md","docs/function-lane/IMPLICIT_INTERSECTION_OPERATOR_INVESTIGATION.md"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_INTERSECTION_REF","","","OP_INTERSECTION_REF","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_LESS_EQUAL","","","OP_LESS_EQUAL","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_LESS_THAN","","","OP_LESS_THAN","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_MULTIPLY","","","OP_MULTIPLY","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_NEGATE","","","OP_NEGATE","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_NOT_EQUAL","","","OP_NOT_EQUAL","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_PERCENT","","","OP_PERCENT","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_POWER","","","OP_POWER","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_RANGE_REF","","","OP_RANGE_REF","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","2","2","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_SPILL_REF","","","OP_SPILL_REF","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","1","1","RefsVisibleInAdapter","Custom","Custom","Deterministic","NonVolatile","WorkbookState","SafePure","RefOnly","RefOnly","function_meta_extracted","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_SUBTRACT","","","OP_SUBTRACT","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_TRIM_REF_BOTH","","","OP_TRIM_REF_BOTH","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_TRIM_REF_LEADING","","","OP_TRIM_REF_LEADING","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_TRIM_REF_TRAILING","","","OP_TRIM_REF_TRAILING","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_UNARY_PLUS","","","OP_UNARY_PLUS","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
"oxfunc-libctx-v1","2026-03-26","6a14e66","6a14e667271be0de8adb32ccf21c6a69052cf9c7","dirty","oxfunc","built_in_operator","built_in_operator_export","FUNC.OP_UNION_REF","","","OP_UNION_REF","oxfunc.local.names.operators.current_baseline.v1","oxfunc.local.profile.operator_surface.current_baseline.v1","oxfunc.local.gating.current_baseline.default.v1","","Operators","true","","","","","","","","","","","","catalog_only","ordinary","ordinary_call","oxfml_then_oxfunc","ordinary_eval","","docs/worksets/W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md","tools/xll-addin/oxfunc_xll/export_specs.csv"
```

## Source: `OxFunc/docs/function-lane/OXFUNC_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`

```json
{
  "adapter_id": "oxfunc.replay.packet_adapter",
  "adapter_version": "1.0.0-draft",
  "lane_id": "oxfunc",
  "supported_source_schema_ids": [
    {
      "source_schema_id": "oxfunc.local.packet_manifest.csv.v1",
      "status": "local_only",
      "summary": "Manifest-driven packet definition CSV used by OxFunc workset probes."
    },
    {
      "source_schema_id": "oxfunc.local.packet_results.csv.v1",
      "status": "local_only",
      "summary": "Observed packet row results CSV emitted by local OxFunc probe runs."
    },
    {
      "source_schema_id": "oxfunc.local.execution_record.md.v1",
      "status": "local_only",
      "summary": "Execution-record markdown summary with packet outcome and limitation narrative."
    },
    {
      "source_schema_id": "oxfunc.local.evidence_registry.table.v1",
      "status": "local_only",
      "summary": "Evidence-id registry rows binding packet artifacts to stable local evidence ids."
    },
    {
      "source_schema_id": "oxfunc.local.correlation_ledger.csv.v1",
      "status": "local_only",
      "summary": "Correlation-ledger rows binding Excel, contract, Rust, and Lean artifacts."
    },
    {
      "source_schema_id": "oxfunc.local.limitation_note.md.v1",
      "status": "local_only",
      "summary": "Limitation note describing XLL or host-surface qualification without reclassifying semantics."
    }
  ],
  "supported_bundle_schema_versions": [
    {
      "bundle_schema_id": "dna-replay-bundle/v1",
      "bundle_schema_version": "1",
      "status": "targeted"
    }
  ],
  "claimed_capability_levels": [
    "cap.C0.ingest_valid",
    "cap.C1.replay_valid",
    "cap.C2.diff_valid",
    "cap.C3.explain_valid"
  ],
  "known_limits": [
    {
      "limit_id": "oxfunc.local.limit.packet_first_only",
      "summary": "The adapter is packet-first and row-first; it does not claim a fine-grained source-semantic event stream."
    },
    {
      "limit_id": "oxfunc.local.limit.no_fake_event_stream",
      "summary": "Normalized event families are projection views only and may not invent internal evaluator steps."
    },
    {
      "limit_id": "oxfunc.local.limit.c4_scaffold_only",
      "summary": "Packet-first witness distillation is scaffolded but not proven replay-valid in this pass."
    },
    {
      "limit_id": "oxfunc.local.limit.no_pack_claim",
      "summary": "No cap.C5.pack_valid claim is made in this pass."
    },
    {
      "limit_id": "oxfunc.local.limit.xll_seam_preserved",
      "summary": "XLL and host-bridge limitations remain classified separately from core semantic failures."
    }
  ],
  "conformance_artifact_refs": [
    "docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md",
    "docs/worksets/W018_REPLAY_APPLIANCE_PACKET_ADAPTER_BASELINE.md",
    "docs/worksets/W019_PACKET_WITNESS_DISTILLATION_AND_RETENTION_BASELINE.md",
    "docs/worksets/W020_OXFUNC_REPLAY_BUNDLE_LAYOUT_AND_INDEX_BASELINE.md",
    "docs/worksets/W021_W15_FIRST_LIVE_REPLAY_ADAPTER_RUN_BASELINE.md",
    "docs/function-lane/W21_EXECUTION_RECORD.md",
    "docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md",
    "docs/function-lane/FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md",
    "docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md",
    "docs/function-lane/CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md",
    "docs/function-lane/W15_PROBE_RUNTIME_REQUIREMENTS.md",
    ".tmp/replay-bundles/oxfunc-w15-v1/bundle_manifest.json",
    ".tmp/replay-bundles/oxfunc-w15-v1/sidecars/normalized/w15.validation.json",
    ".tmp/replay-bundles/oxfunc-w15-v1/sidecars/normalized/w15.replay_result.json",
    ".tmp/replay-bundles/oxfunc-w15-v1/diff/emitted/w15.default_vs_compat.json",
    ".tmp/replay-bundles/oxfunc-w15-v1/explain/emitted/w15.explain.json"
  ],
  "registry_version_refs": [
    {
      "registry_family": "capability_level",
      "registry_version": "foundation-handoff-20260315-pass-01",
      "status": "foundation_snapshot"
    },
    {
      "registry_family": "predicate_kind",
      "registry_version": "foundation-handoff-20260315-pass-01",
      "status": "foundation_snapshot"
    },
    {
      "registry_family": "mismatch_kind",
      "registry_version": "foundation-handoff-20260315-pass-01",
      "status": "foundation_snapshot"
    },
    {
      "registry_family": "witness_lifecycle_state",
      "registry_version": "foundation-handoff-20260315-pass-01",
      "status": "foundation_snapshot"
    },
    {
      "registry_family": "reduction_status",
      "registry_version": "foundation-handoff-20260315-pass-01",
      "status": "foundation_snapshot"
    },
    {
      "registry_family": "oxfunc.local.source_schema_id",
      "registry_version": "oxfunc-local-v1",
      "status": "local_only"
    }
  ],
  "rollout_notes": [
    "This manifest preserves OxFunc authority over semantic claims, evidence ids, and boundary invariants.",
    "The adapter maps packet and row artifacts into Replay bundle form without fabricating a fake event stream.",
    "The first live local W15 bundle now exists under .tmp/replay-bundles/oxfunc-w15-v1 and evidences cap.C0 through cap.C3 for the local adapter surface.",
    "cap.C4.distill_valid is not claimed; W019 only establishes packet-first reduction and lifecycle policy baseline.",
    "cap.C5.pack_valid is not claimed in this pass."
  ]
}
```

## Source: `OxFunc/docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`

# OxFunc Replay Appliance Packet Adapter V1

Status: `provisional`
Owner lane: `OxFunc`
Adapter id: `oxfunc.replay.packet_adapter`
Adapter version: `1.0.0-draft`

## 1. Scope and Non-Goals
This note defines the OxFunc-local packet adapter contract for Replay appliance rollout.

In scope:
1. packet-first and row-first projection of existing OxFunc empirical artifacts into Replay bundle form,
2. preservation of OxFunc semantic authority, evidence ids, correlation links, boundary invariants, and seam limitations,
3. conservative capability claims for ingest, replay, diff, and explain over current packet artifacts,
4. packet-first witness-distillation scaffolding with explicit non-claim language.

Non-goals:
1. inventing a fake internal event stream for OxFunc,
2. replacing OxFunc semantic contracts with Replay bundle prose,
3. claiming reduced-witness replay validity without local proving artifacts,
4. claiming pack-grade promotion support in this pass,
5. erasing XLL or host-limitation distinctions by flattening them into semantic mismatches.

## 2. Authority Split and Conflict Handling
Authority split:
1. OxFunc remains authoritative for function and operator semantic meaning, evidence meaning, boundary invariants, correlation-ledger meaning, and XLL limitation classification.
2. The Foundation replay handoff from `2026-03-15` is authoritative for cross-lane replay governance, shared capability vocabulary, shared registry families, witness lifecycle vocabulary, and Replay bundle host expectations.
3. `DNA ReCalc` is a Logistics-layer replay host surface, not a new OxFunc semantic authority.

Explicit adaptation rule:
1. Foundation architecture defines a shared `ReplayEvent` object and generalized event families.
2. OxFunc does not currently produce an honest fine-grained semantic event stream.
3. Therefore the OxFunc adapter treats packet rows, analysis summaries, evidence bindings, invariant declarations, and limitation records as the primary witnesses.
4. Any normalized event family emitted for OxFunc is a derived projection view over those packet witnesses, not a source-semantic truth source.

Conflict note:
1. If generic Replay wording suggests event-stream-first treatment, OxFunc adapts that wording to packet-first and row-first semantics.
2. This is an adaptation of rollout wording, not a redefinition of OxFunc function semantics.

## 3. Packet-First and Row-First Replay Model
Primary OxFunc replay units:
1. packet/workset replay run,
2. manifest row cluster where one workset uses several related manifests,
3. individual manifest row,
4. execution-record summary,
5. evidence-binding record,
6. invariant declaration,
7. limitation marker,
8. source-native sidecar artifact partition.

Source-native inputs remain first-class:
1. scenario manifest CSVs,
2. output result CSVs,
3. execution records,
4. function-slice contract notes,
5. evidence-id registry rows,
6. correlation-ledger rows,
7. seam-limitation notes.

Packet replay rule:
1. replay validity for OxFunc means the packet can be re-run or re-import so that packet rows, run labels, compatibility descriptors, locale/environment metadata, and required sidecar references remain auditable.
2. replay does not require a stepwise simulation trace if row results and packet summaries are the honest witness.

## 4. Preserved Metadata
Every OxFunc replay bundle projection must preserve or reference:
1. `workset_id`,
2. `packet_id` or source manifest id,
3. `scenario_id` or row id,
4. `function_id` or slice id where applicable,
5. `evidence_id` refs,
6. correlation-ledger refs,
7. run label,
8. compatibility descriptor,
9. locale profile,
10. environment metadata including Excel build/channel where relevant,
11. source manifest path,
12. output artifact refs,
13. execution-record refs,
14. invariant refs,
15. limitation refs,
16. verification-surface classification,
17. semantic-target status.

Compatibility and environment rule:
1. locale, Excel build/channel, and workbook-compatibility descriptors are not optional decoration.
2. They are part of the replay identity for packet evidence and must remain visible in bundle-normalized views.

## 5. Normalized Views and Event Families Without Packet Distortion
Required normalized views:
1. `manifest_row_result_view`
2. `run_summary_view`
3. `analysis_summary_view`
4. `evidence_binding_view`
5. `correlation_binding_view`
6. `invariant_view`
7. `limitation_view`
8. `source_inventory_view`

Allowed derived event families:
1. `packet.started`
2. `packet.completed`
3. `row.observed`
4. `row.mismatched`
5. `analysis.completed`
6. `evidence.bound`
7. `invariant.bound`
8. `limitation.noted`

Projection rule:
1. these event families are normalized convenience views only,
2. they must be reproducible from packet rows or packet summaries,
3. they must not imply hidden internal evaluator steps that OxFunc did not capture,
4. if a source packet does not justify an event, the adapter must emit no event rather than fabricate one.

## 6. Boundary-Invariant Incorporation
Boundary invariants remain OxFunc-owned.

Replay bundle incorporation must preserve:
1. invariant id,
2. statement,
3. covered boundaries,
4. scenario ids,
5. expected observation,
6. status,
7. supporting evidence ids,
8. related limitation refs where applicable.

Required boundary families remain:
1. formula evaluation,
2. interop ingress,
3. reference reuse,
4. persistence,
5. interchange,
6. optional UDF/XLL.

Invariant failure rule:
1. invariant failures should map to shared predicate vocabulary such as `pred.invariant.failed`,
2. but the invariant statement and its semantic meaning stay OxFunc-local and must be cited from OxFunc docs or packet records.

## 7. Adapter Capability Target and Known Limits
Highest capability honestly claimed in this pass:
1. `cap.C0.ingest_valid`
2. `cap.C1.replay_valid`
3. `cap.C2.diff_valid`
4. `cap.C3.explain_valid`

Current non-claims:
1. `cap.C4.distill_valid` is scaffolded only in packet-first form and is not claimed complete.
2. `cap.C5.pack_valid` is not claimed.

Current proving path:
1. existing manifest-driven packet artifacts already define stable source inputs,
2. existing execution records and evidence ids already define row/result and summary surfaces,
3. current W15 packet artifacts give a concrete packet replay import example with run labels, compatibility descriptors, and host-limitation distinctions,
4. `tools/replay-adapter/run-w15-replay-adapter-baseline.ps1` now emits a live local `W15` replay bundle under `.tmp/replay-bundles/oxfunc-w15-v1/`,
5. `docs/function-lane/W21_EXECUTION_RECORD.md` records the first local proving artifact for `cap.C0` through `cap.C3`.

Known limits:
1. no fake internal event stream will be emitted for OxFunc,
2. XLL verification seam limits must remain classified as seam limits unless OxFunc explicitly promotes them to semantic failures,
3. reduced packet or row witnesses are not yet proven replay-valid,
4. no pack-grade export or witness-promotion claim is made,
5. schema ids for OxFunc source packets are still local-only adapter ids in this pass.

## 8. Registry Version Pins
Foundation-shared registries pinned in this pass:
1. `capability_level` -> snapshot `foundation-handoff-20260315-pass-01`
2. `predicate_kind` -> snapshot `foundation-handoff-20260315-pass-01`
3. `mismatch_kind` -> snapshot `foundation-handoff-20260315-pass-01`
4. `witness_lifecycle_state` -> snapshot `foundation-handoff-20260315-pass-01`
5. `reduction_status` -> snapshot `foundation-handoff-20260315-pass-01`

Local-only OxFunc ids used in this pass must be prefixed `oxfunc.local.`.

Current local-only ids:
1. `oxfunc.local.packet_manifest.csv.v1`
2. `oxfunc.local.packet_results.csv.v1`
3. `oxfunc.local.execution_record.md.v1`
4. `oxfunc.local.evidence_registry.table.v1`
5. `oxfunc.local.correlation_ledger.csv.v1`
6. `oxfunc.local.limitation_note.md.v1`

## 9. Witness Lifecycle and Quarantine Usage Rules
Current packet-adapter rule set:
1. source packets and source sidecars remain the primary local evidence assets,
2. any future reduced witness must carry a lifecycle record and a reduction manifest ref,
3. explanatory-only reduced witnesses may support explain surfaces but are not pack-eligible,
4. quarantined witnesses remain indexable and explainable but are not promotion-eligible,
5. superseded reduced witnesses must retain traceability back to the source packet, source evidence ids, and the replacing witness id.

Current OxFunc rollout position:
1. W018 only establishes the adapter binding and capability baseline.
2. W019 defines packet-first reduction units, lifecycle expectations, quarantine rules, and supersession policy.
3. No reduced witness is promoted in this pass.

## 10. Open Gaps and Evidence Requirements
Open gaps:
1. no locally proven reduced packet witness yet exists for OxFunc,
2. no conformance artifact yet proves packet-first `cap.C4.distill_valid`,
3. no `cap.C5.pack_valid` evidence exists,
4. local source schema ids remain adapter-local pending shared `OxReplay` ingestion conventions,
5. no live `DNA ReCalc` import run has yet been exercised against an OxFunc packet bundle in this repo.

Evidence required next:
1. one external replay-host import, preferably `DNA ReCalc`, over the emitted `W15` bundle,
2. one reduced packet or row witness that replays validly before any `cap.C4.distill_valid` claim is made,
3. one follow-up packet beyond `W15` proving the local adapter surface is not packet-specific.

## 11. Worked Example - W15 Packet Binding
`W15` is the first concrete packet example for this adapter baseline.

Source packet elements:
1. manifests:
   - `docs/function-lane/W15_INFO_PRE_SCENARIO_MANIFEST_SEED.csv`
   - `docs/function-lane/W15_CELL_HOST_PRE_SCENARIO_MANIFEST_SEED.csv`
   - `docs/function-lane/W15_XLL_BRIDGE_SCENARIO_MANIFEST_SEED.csv`
2. result sidecars:
   - `.tmp/w15-info-pre-results.csv`
   - `.tmp/w15-info-pre-results-compat.csv`
   - `.tmp/w15-cell-host-pre-results.csv`
   - `.tmp/w15-cell-host-pre-results-compat.csv`
   - `.tmp/w15-xll-bridge-results.csv`
   - `.tmp/w15-xll-bridge-results-compat.csv`
3. execution/evidence/limitation anchors:
   - `docs/function-lane/W15_EXECUTION_RECORD.md`
   - `docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
   - `docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md`

Projection intent:
1. the three manifests remain packet-definition inputs under `oxfunc.local.packet_manifest.csv.v1`,
2. the six result CSVs remain packet-result sidecars under `oxfunc.local.packet_results.csv.v1`,
3. `W15_EXECUTION_RECORD.md` provides packet summary and explain-facing narrative,
4. the three W15 evidence ids remain the stable local evidence-binding spine,
5. XLL limitation references remain limitation metadata, not semantic-failure defaults.

Explain expectation for the worked example:
1. replay explain should be able to answer why a `CELL` lane is host-query classified,
2. why a bridge row is parity-clean or parity-mismatched,
3. and why a mismatch is classified as seam-limited rather than semantically divergent when the limitation record says so.

Concrete target artifact:
1. `docs/function-lane/W15_REPLAY_BUNDLE_SKELETON_V1.md` now defines the expected normalized bundle skeleton for this first worked example.
2. `docs/function-lane/W15_REPLAY_ADAPTER_CONFORMANCE_CHECKLIST_V1.md` now defines the first live-run acceptance checklist for the same packet.
3. `docs/function-lane/W15_REPLAY_DIFF_EXPLAIN_SHAPES_V1.md` now defines the expected diff/explain output objects for the same packet.
4. `.tmp/replay-bundles/oxfunc-w15-v1/` is now the first emitted local proving artifact for the same packet.

## Source: `OxFunc/docs/function-lane/RTD_REFERENCE_CAPTURE_AND_SEAM_NOTES.md`

# RTD Reference Capture And Seam Notes

## 1. Purpose
Record the local reference captures for `RTD` and the current OxFunc-side seam reading.

This note is intentionally narrow:
1. fetch and store the primary public references for `RTD`,
2. extract the parts that matter to OxFunc,
3. keep the OxFunc role minimal rather than collapsing host/application responsibilities into the function kernel.

## 2. Stored Reference Captures
Raw captures stored locally:
1. [ms-rtd-reference-aa140060-office10-20260320.html](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/ms-rtd-reference-aa140060-office10-20260320.html)
2. [excel-dna-rtd-tutorial-readme-20260320.md](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/excel-dna-rtd-tutorial-readme-20260320.md)
3. [excel-dna-rtd-tutorial-root-api-20260320.json](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/excel-dna-rtd-tutorial-root-api-20260320.json)
4. [excel-dna-rtd-functions-20260320.cs](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/excel-dna-rtd-functions-20260320.cs)
5. [excel-dna-rtd-server-20260320.cs](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/excel-dna-rtd-server-20260320.cs)

Primary source URLs:
1. `https://learn.microsoft.com/en-us/previous-versions/office/developer/office-xp/aa140060(v=office.10)`
2. `https://github.com/Excel-DNA/Tutorials/tree/master/SpecialTopics/RTD`

## 3. What The Microsoft RTD FAQ Pins
The archived Microsoft FAQ is still useful for the canonical RTD interaction model:
1. `RTD` is COM Automation based and uses an `IRtdServer` plus an `IRTDUpdateEvent` callback.
2. Excel tracks the cell-rooted `=RTD(...)` formulas and the server does not need to track worksheet locations itself.
3. Topic connection is established through `ConnectData`, updates are signalled through `UpdateNotify`, and Excel later pulls updated values with `RefreshData`.
4. Excel throttles update fetches and only refreshes when it is in a good state to change cell values.
5. The topic parameters are strings.
6. Saved workbook values interact with `ConnectData` through the `GetNewValues` flag.

## 4. What The Excel-DNA Tutorial Adds
The Excel-DNA tutorial adds useful implementation context:
1. wrapper functions commonly hide the raw `=RTD(...)` call behind user-facing functions,
2. the visible `RTD` function call effectively passes a COM ProgID plus a list of topic strings,
3. the RTD server can update topic values asynchronously and then notify Excel,
4. cleanup runs per topic and per server,
5. the callback/update path must be handled carefully on the Excel side.

The minimal sample in:
1. [excel-dna-rtd-functions-20260320.cs](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/excel-dna-rtd-functions-20260320.cs)
2. [excel-dna-rtd-server-20260320.cs](/C:/Work/DnaCalc/OxFunc/docs/function-lane/reference-captures/rtd/excel-dna-rtd-server-20260320.cs)

shows the clearest reference shape:
1. formula/wrapper emits `XlCall.RTD(progId, server, topic0, topic1, ...)`,
2. the server receives `IList<string> topicInfo`,
3. topic updates later arrive through `topic.UpdateValue(...)`.

## 5. OxFunc-Side Seam Reading
Current OxFunc reading:
1. OxFunc should own the semantic admission and shape of the `RTD` function call.
2. OxFunc should not own COM activation, topic registration tables, topic lifetime tracking, callback threading, update scheduling, or workbook/cell subscription maps.
3. Those responsibilities sit between OxFml and the higher-level host application.
4. OxFunc should only need enough seam surface to:
   - recognize `RTD`,
   - preserve the ProgID/server/topic-string payload honestly,
   - classify the function as external-provider and external-invalidation dependent,
   - accept a host-supplied current topic value when one is available,
   - distinguish capability-denied, provider-failed, disconnected, and normal-value states at the function result boundary.

## 6. Minimal Candidate OxFml <-> OxFunc Boundary
This is a candidate direction, not a locked interface:
1. prepared call surface:
   - `RtdRequest`
   - `prog_id: text`
   - `server_name: blank-preserved text`
   - `topic_strings: ordered text vector`
2. prepared evaluation context:
   - host supplies an `RtdProvider`-like resolution hook
   - any stable topic handle or subscription identity may exist above OxFunc, but OxFunc does not need to allocate or own it
3. value arrival surface:
   - OxFunc should see either a current resolved external value or a classified external-provider outcome
4. topic lifetime and update notification stay outside OxFunc

## 7. Immediate Modeling Consequence
For OxFunc, `RTD` is not primarily an algorithmic function.

It is better modeled as:
1. a function-call surface that creates or refers to an external topic subscription above OxFunc,
2. a host-managed invalidation/update channel,
3. and a value/result projection back into the formula from that host-managed state.

## 8. Open Questions For Dedicated RTD Work
These move to the dedicated `RTD` workset:
1. exact treatment of the second `server` argument on current Excel baselines,
2. classification of startup / no-server / disconnected / no-value-yet / provider-error outcomes,
3. whether workbook-saved prior values need explicit seam representation or remain a host-only concern,
4. whether OxFunc should ever see a stable topic handle, or only the resolved current value/result class.

## 9. Current Local Implementation
Current OxFunc-local first pass:
1. `crates/oxfunc_core/src/functions/rtd_fn.rs` implements `RtdRequest`, `RtdProvider`, and `RtdProviderResult`.
2. `RTD` is wired into the normal dispatch and export catalog.
3. The current result mapping is:
   - `Value(v)` -> `v`
   - `NoValueYet` -> `#N/A`
   - `CapabilityDenied` -> `#BLOCKED!`
   - `ConnectionFailed` -> `#CONNECT!`
   - `ProviderError(code)` -> `code`
4. This is intentionally only the OxFunc-local semantic boundary, not a full RTD host implementation.

## 10. Current OxFml Sync Bundle
For the next OxFml sync, the current bounded RTD bundle is:
1. this note,
2. `docs/function-lane/FUNCTION_SLICE_RTD_CONTRACT_PRELIM.md`,
3. `docs/function-lane/W43_EXECUTION_RECORD.md`,
4. `docs/worksets/W043_RTD_COM_ACTIVATION_AND_TOPIC_LIFECYCLE_SEAM.md`,
5. the stored raw captures under `docs/function-lane/reference-captures/rtd/`.

Current message from OxFunc to OxFml:
1. lifecycle/state ownership stays above OxFunc,
2. OxFunc only needs the prepared `RtdRequest` and a typed host callback returning current value or classified outcome,
3. OxFunc then projects that result into the worksheet value/error universe.

## Source: `OxFunc/docs/function-lane/VALUE_UNIVERSE_PRELIM_SPEC.md`

# Value Universe Preliminary Spec (W3)

Status: `active`
Workset: `W3`

## 1. Purpose
Define a boundary-scoped value universe for OxFunc/F3E so function contracts, coercion rules, and formal/runtime artifacts use one shared tag vocabulary.

## 2. Boundary Sets
The universe is decomposed into boundary-specific sets:
1. `CellContentValue`
2. `RawFunctionReturn`
3. `PublishedFormulaResult`
4. `CallArgValue`
5. `ReferenceLike`
6. `ExtendedValue`
7. `RichValueData`

Interpretation rule:
1. these sets are boundary views over one common tag algebra,
2. not every tag is admitted at every boundary,
3. the current Rust `EvalValue` type corresponds most closely to `PublishedFormulaResult`, not to the broadest raw interop/UDF return universe.

## 3. Tag Algebra
Canonical tag list for W3 baseline:
1. `number`
2. `text`
3. `logical`
4. `error`
5. `array`
6. `reference_like`
7. `missing_arg`
8. `empty_cell`
9. `lambda_value`
10. `rich_value`
11. `extended_wrapper`
12. `null_like` (reserved disputed category; not admitted in baseline boundaries)

Machine-readable table:
1. `VALUE_UNIVERSE_TAG_TABLE.csv`

## 4. Baseline Boundary Admission Policy
1. `CellContentValue` admits:
   - `number`, `text`, `logical`, `error`, `empty_cell`
2. `RawFunctionReturn` admits:
   - `number`, `text`, `logical`, `error`, `array`, `rich_value`, `reference_like`, `lambda_value`, `empty_cell`
   - and explicitly does **not** admit `missing_arg`, `null_like`
3. `PublishedFormulaResult` admits:
   - `number`, `text`, `logical`, `error`, `array`, `rich_value`, `reference_like`, `lambda_value`
   - and explicitly does **not** admit `missing_arg`, `empty_cell`, `null_like`
4. `CallArgValue` admits:
   - all `PublishedFormulaResult` tags plus `missing_arg` and `empty_cell`
5. `ReferenceLike` boundary admits:
   - `reference_like` only
6. `ExtendedValue` boundary admits:
   - `extended_wrapper` plus pass-through of core evaluable tags
7. `RichValueData` admits:
   - scalar data (`number`, `text`, `logical`, `error`, `empty_cell`)
   - `rich_array`
   - nested `rich_value`

## 5. Disputed Categories
### 5.1 Missing
1. represented as `missing_arg`,
2. treated as call-boundary specific, not published-result specific.

### 5.2 Empty
1. represented as `empty_cell`,
2. treated as cell/call-boundary representable,
3. admitted in `RawFunctionReturn` for interop/UDF raw-return characterization,
4. not admitted in `PublishedFormulaResult`.

### 5.3 Null
1. represented only as reserved `null_like` tag in baseline algebra,
2. not admitted in any baseline boundary until direct evidence exists.
3. `#NULL!` is modeled as `error`, not `null_like`.

## 6. Error Taxonomy and Versioning
Error values remain scalar `error` tags with code-level metadata.

Code-level registry split (provisional):
1. legacy transferable family (`#NULL!`, `#DIV/0!`, `#VALUE!`, `#REF!`, `#NAME?`, `#NUM!`, `#N/A`)
2. extended worksheet-era family (for example `#SPILL!`, `#CALC!`, `#FIELD!`, `#BLOCKED!`, `#CONNECT!`)

Versioning rule:
1. code family membership is version-scoped by Excel build/channel and compatibility mode.

## 7. Text Subtype Baseline (W7 Feed)
For boundary-faithful modeling in this baseline scope:
1. text is treated as UTF-16 code-unit sequence at worksheet/interop boundaries.
2. observed cap for materialized text is `32767` UTF-16 code units.
3. interop ingress (`Range.Value2`) truncates over-cap strings to cap without set-time exception in tested rows.
4. truncation of surrogate-pair streams can yield dangling high-surrogate tail states (observed in emoji overflow scenario).
5. formula-generated overflow behavior is distinct from interop ingress:
   - formula path above cap produced `#VALUE!` in tested `REPT` rows.

Evidence binding:
1. `W7-STR-BL-20260305` (`STR8-019..STR8-046`).

## 8. Arrays, Lambda, and References
1. arrays are first-class `RawFunctionReturn` and `PublishedFormulaResult` tags; materialization policy is downstream (W4/W5/W6).
2. the current `array` tag models ordinary worksheet arrays (`EvalArray`) whose cells are scalar worksheet-like atoms.
3. spec `rich array` is different: it is a rich-value-data container whose elements may themselves be rich value data, including nested rich values.
4. lambda values are intermediate-eval tags, not baseline cell content tags.
5. 3D references are modeled as a `reference_like` subtype (`reference_kind=three_d`) and require resolver-policy handling in W4.

## 9. Rich Value Alignment
The value universe now uses the SpreadsheetML rich-value vocabulary explicitly:
1. `rich value`
   - represented as:
     - `rich value type`
     - `rich value fallback`
     - key/value pairs
2. `rich value type`
   - represented as:
     - type name
     - required keys
     - key-flag declarations
3. `rich value data`
   - represented as the recursive domain:
     - scalar atom
     - `rich array`
     - nested `rich value`
4. `rich array`
   - represented as a shaped 2D container over `rich value data`
5. `extended_wrapper`
   - remains as a backward-compatible bucket for non-rich extensions such as format hints and enriched error-surface metadata.

Current design reading:
1. `IMAGE` pressures `rich_value`, not just `extended_wrapper`.
2. `HYPERLINK` still looks like ordinary text plus publication/style behavior, not a rich value.
3. dynamic-array functions currently operate over ordinary worksheet arrays, but the model now has an explicit place for future rich-array-bearing cells and nested rich-data values.

## 9A. Presentation Hint Alignment
For worksheet-facing cases where Excel applies formatting or styling without changing the underlying scalar value, the model now uses a uniform presentation wrapper:
1. `ValueWithPresentation`
   - carries an ordinary `EvalValue`
   - plus a `PresentationHint`
2. `PresentationHint`
   - `number_format`
   - `style`
3. baseline examples:
   - `TODAY()` / `NOW()`:
     - numeric serial value
     - plus `number_format` hint
   - `HYPERLINK(...)`:
     - ordinary text value
     - plus `style=hyperlink` hint

Design consequence:
1. number-format hints and style hints remain distinct semantic subfields,
2. but they share one wrapper so OxFml and the host-facing publication layer can consume them uniformly.
3. the current first-pass runtime hook for these cases is `eval_surface_extended_call(...)` in `crates/oxfunc_core/src/functions/surface_dispatch.rs`.

## 10. Lean/Rust Mirror Rule
W3 baseline requires shared tag vocabulary in:
1. Rust: `crates/oxfunc_core/src/value.rs`
2. Lean: `formal/lean/OxFunc/ValueUniverse.lean`

Invariant objectives for baseline:
1. `PublishedFormulaResult` excludes `missing_arg`, `empty_cell`, `null_like`.
2. `RawFunctionReturn` admits `empty_cell` but excludes `missing_arg` and `null_like`.
3. text-cap primitive encodes `<= 32767` UTF-16 code units.

## 11. Integration Hooks
1. W4 consumes tag/boundary policy for coercion and `Ref -> PublishedFormulaResult` seam typing.
2. W5 consumes numeric/error/array policy for `ABS`.
3. W6 consumes text/reference/error policy for `XMATCH`.
4. W9 consumes raw-return versus publication normalization policy for XLL/UDF seam characterization.

## 12. Raw Return vs Published Result Rule
Observed XLL/UDF probe evidence on `2026-03-12` (`W9-XLL-NIL-20260312`) now pins the following baseline rule:
1. raw scalar `xltypeNil` can be returned from an XLL function,
2. but it does not survive as an outer-observable scalar value in ordinary nested formula evaluation,
3. instead it normalizes to numeric-zero semantics before outer argument binding and final worksheet publication,
4. raw `xltypeNil` inside arrays is different:
   - it can survive as `empty_cell`-like element state inside an intermediate array value,
   - but it also collapses to numeric-zero semantics when scalarized or published into worksheet cells.

Design consequence for the current model:
1. `RawFunctionReturn` is broader than `PublishedFormulaResult`.
2. The publication/scalarization map is semantically important and must stay explicit in doctrine.
3. Built-in function completion should continue to target `PublishedFormulaResult` semantics even when OxFunc also models broader raw interop/UDF return shapes.

## 13. Open Points
1. explicit handling for modern dynamic-array error transfer across UDF/XLL boundaries,
2. empirical evidence for any first-class `null_like` behavior,
3. final decision on whether internal OxFunc runtime should store text as UTF-16 code-unit vectors end-to-end or only at boundary adapters,
4. whether ordinary worksheet arrays (`array`) and spec rich arrays should share one runtime carrier or stay split,
5. whether the W3 Lean/Rust mirrors should grow a first-class `publish_result` normalization model rather than staying boundary-table only.

## Source: `OxFunc/docs/function-lane/W49_RUNTIME_LIBRARY_CONTEXT_CONSUMER_WALKTHROUGH.md`

# W49 Runtime Library Context Consumer Walkthrough

Status: `active`
Packet: `W049`

## 1. Purpose
Show one honest first-pass consumer flow over the current covered scope using:
1. runtime `LibraryContextProvider`
2. immutable `LibraryContextSnapshot`
3. `W047` typed context/query bundle
4. `W048` return-surface split

## 2. Consumer Example - Built-In Function
Formula example:
1. `=NOW()`

Consumer flow:
1. OxFml asks `LibraryContextProvider.current_snapshot()`.
2. Binder resolves `NOW` to the snapshot entry with:
   - `surface_stable_id = FUNC.NOW`
   - `entry_kind = built_in_function`
   - `runtime_boundary_kind = extended_value_with_presentation_hint`
3. Bound node preserves:
   - `surface_stable_id`
   - `arity`
   - `arg_preparation_profile`
   - seam-facing guidance fields
4. Evaluator uses `W047`:
   - `NowProvider.now_serial()`
5. OxFunc returns according to `W048`:
   - `ValueWithPresentation`
   - numeric serial value
   - `number_format` hint
6. OxFml/host applies or ignores the presentation hint according to publication policy.

## 3. Consumer Example - Host Query Function
Formula example:
1. `=FORMULATEXT(A1)`

Consumer flow:
1. Binder resolves `FORMULATEXT` from the current snapshot entry.
2. Entry guidance tells OxFml this is not a pure value-only kernel.
3. Evaluator uses `W047`:
   - `HostInfoProvider.query_formula_text(reference)`
4. OxFunc receives the typed result and returns an ordinary worksheet value.

## 4. Consumer Example - Provider Projection Function
Formula example:
1. `=RTD("Prog.Id", , "topic1", "topic2")`

Consumer flow:
1. Binder resolves `RTD` from the current snapshot entry.
2. Entry guidance preserves:
   - `special_interface_kind = host_subscription_provider`
   - `runtime_boundary_kind = host_provider_projection`
3. OxFml/host owns:
   - server activation
   - topic lifecycle
   - cell-to-topic mapping
   - current value availability
4. Evaluator passes prepared `RtdRequest` to `RtdProvider`.
5. OxFunc projects the typed `RtdProviderResult` into worksheet-visible value/error result.

## 5. Consumer Example - Registration Change
Event example:
1. host registers a new external worksheet entry through the future `W046` path

Consumer flow:
1. host/OxFml updates library-context truth above OxFunc
2. `LibraryContextProvider` emits a fresh immutable `LibraryContextSnapshot`
3. new snapshot gets a fresh `snapshot_generation`
4. existing consumers may:
   - continue using the prior snapshot deterministically
   - or explicitly switch to the newer generation
5. CSV export remains useful for debugging and fixture pinning, but does not define the runtime mutation model.

## 6. Why This Is Better Than CSV-Only Consumption
1. runtime lookup indexes are natural in object form
2. immutability is explicit
3. generation changes become explicit events
4. consumer code groups entry fields by meaning instead of parsing many flat CSV columns at runtime

## 7. Current Honest Limit
This walkthrough is a first-pass consumer model. It does not claim:
1. final ABI naming lock
2. final registered-external descriptor shape
3. a requirement that runtime objects be serialized exactly like the CSV

## Source: `OxFunc/docs/function-lane/XLL_ADDIN_BRIDGE_SHIM_CONTRACT_PRELIM.md`

# XLL Add-in Bridge Shim Contract (Prelim)

Status: `provisional`
Workset: `W9`

## 1. Purpose
Define the seed caller/shim contract for mapping XLL entrypoint arguments into OxFunc function calls without coupling core semantics to XLL ABI details.

## 2. Bridge Components
1. Rust-only XLL transport, registration, and type-conversion layer:
   - `tools/xll-addin/oxfunc_xll/src/lib.rs`
2. Generated export/registration layer:
   - `tools/xll-addin/oxfunc_xll/build.rs`
3. Core source-of-truth for export rows:
   - `crates/oxfunc_core/src/xll_export_specs.rs`
4. Generated CSV snapshot (for review/replay artifacts):
   - `tools/xll-addin/oxfunc_xll/export_specs.csv`
5. Core dispatch/semantics owner:
   - `crates/oxfunc_core/src/functions/surface_dispatch.rs`
6. Function kernels/adapters owner:
   - `crates/oxfunc_core`

## 3. Export Set (Profile-Derived)
1. Export rows are generated for every function in the OxFunc function catalog.
2. U-vs-Q variants are derived by rule from `FunctionMeta` profile fields in `crates/oxfunc_core/src/xll_export_specs.rs`.
3. Current generated snapshot is `tools/xll-addin/oxfunc_xll/export_specs.csv` (for example `OX_ABS`, `OX_IF`, `OX_SUM`, `OX_XLOOKUP`, `OX_XMATCH`, with profile-admitted Q variants such as `OX_ABS_Q`, `OX_OP_ADD_Q`, `OX_PI`).

## 4. Shim Mapping (Current Scope)
Bridge policy is declarative per export row:
1. registration row (`export_name`, `worksheet_name`, `type_text`, `arg_names`),
2. bound `function_id` (for core dispatch),
3. U-surface lift policy (`scalar_only` or `unary_scalar_or_array_elementwise`),
4. reference-preservation flag (`preserve_refs`) derived from `arg_preparation_profile`,
5. export wrapper signature kind (`u_arity_N`, `q_unary_number`, `q_binary_number`, `q_nullary_number`).

For `U` surface rows:
1. Incoming `LPXLOPER12` categories handled by generic converter:
   - `xltypeNum` -> number,
   - `xltypeInt` -> number,
   - `xltypeStr` -> UTF-16 text (pascal length-prefixed),
   - `xltypeBool` -> logical,
   - `xltypeErr` -> worksheet error code,
   - `xltypeMissing` -> missing arg,
   - `xltypeNil` -> empty cell,
   - `xltypeMulti` -> full array payload translation.
2. Reference lanes (generic):
   - if `preserve_refs=false`, `xltypeRef` / `xltypeSRef` are dereferenced through `xlCoerce` before shim translation.
   - if `preserve_refs=true`, reference-like tokens are passed through as `CallArgValue::Reference`.
3. `xltypeMulti` array lanes (policy-driven):
   - for `unary_scalar_or_array_elementwise`, shape-preserving elementwise scalar dispatch by `function_id`.
   - result returned as `xltypeMulti` with Excel-owned lifetime (`xlbitDLLFree` + `xlAutoFree12`).
4. Core invocation is by `function_id` through core dispatch entrypoints, not function-specific bridge logic.
5. Result mapping currently supports:
   - scalar worksheet values,
   - `xltypeMulti` array payloads in admitted lanes,
   - admitted reference results returned as `xltypeSRef` or `xltypeRef` when the shim can preserve that identity.
6. Manual probe lane for raw-return characterization:
   - the shim can return raw `xltypeNil` scalars and `xltypeMulti` payloads containing `xltypeNil` elements for dedicated evidence functions.
   - current baseline evidence shows scalar raw `xltypeNil` is normalized by Excel to numeric-zero semantics before outer argument binding and worksheet publication.
   - raw `xltypeNil` elements inside arrays can remain visible to an outer XLL function as `empty_cell` element state until scalarization/publication.
7. Registration shaping policy for generated U rows:
   - worksheet-callable `type_text` is capped to the current Excel baseline limit (`len <= 255`),
   - high-arity UI-only `arg_names` metadata is omitted when it would exceed Excel's practical dialog limit.
8. Fixed-width U call normalization:
   - trailing `xltypeMissing` arguments are trimmed back to the effective call arity before core dispatch,
   - internal missing arguments are preserved,
   - this keeps variadic worksheet calls such as `TEXTJOIN(...)` aligned with Excel's actual supplied-argument count.

For `Q` surface rows:
1. numeric unary, binary, and nullary calls are routed by `function_id` through core dispatch entrypoints.

## 5. Error Mapping (Seed)
1. OxFunc worksheet errors map to XLL `xlerr*` codes (`#DIV/0!`, `#VALUE!`, `#N/A`, etc.).
2. Coercion/ref-resolution/unsupported shim cases default to `#VALUE!` unless a specific worksheet error is already declared.

## 6. Bounded Lanes
1. Array payload semantics remain shape-bounded in core for several functions; U bridge preserves this boundary.
2. Asynchronous/RTD callback model.
3. Production-hardening beyond current `xlbitDLLFree` + `xlAutoFree12` ownership discipline.
4. Registration-flag mapping (`!`, `$`, `#`) is intentionally not profile-derived yet; W11 uses runtime-only experimental alias registrations for evidence collection.

## 7. Verification-Seam Limitation Disclosure
1. This shim contract is part of the XLL verification seam, not the semantics-owning function layer.
2. Known seam limitations are tracked centrally in `docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md`.
3. Any function or packet using XLL evidence must repeat the relevant limitation notes in its own verification record when those limits qualify the claim.

## Source: `OxFunc/docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md`

# XLL Verification Seam Limitations

Status: `active`
Owner lane: `OxFunc`

## 1. Purpose
Record known limitations in the Rust XLL verification seam so they are not mistaken for function-semantic gaps and are not omitted from function verification records when relevant.

## 2. Scope Rule
1. These are external seam limitations, not acceptable justifications for incomplete core function semantics.
2. When any limitation below materially affects a function evidence claim, the affected function or packet verification record must cite it explicitly.

## 3. Current Limitation Set
1. Registration-flag mapping is only partially profile-derived:
   - ordinary `volatile_full` user-facing exports now emit `!`, but broader `!`, `$`, and `#` mapping remains under dedicated evidence work rather than full normal export generation.
2. Macro-type and caller-context behavior are only partially evidenced through the bridge:
   - admission and limited parity rows exist, but macro-required host behavior is not fully reproduced.
3. Reference-return and non-scalar payload lanes are still bounded in the bridge:
   - some functions can export or return shape/reference-like outcomes, but the bridge evidence does not yet demonstrate full Excel parity for all such lanes.
   - current lookup-family bridge replay is green for the admitted manifest scope:
      - `XMATCH`, `MATCH`, and scalar `XLOOKUP` rows match directly through `LOOKUP_XLL_BRIDGE_SCENARIO_MANIFEST_SEED.csv`,
      - `XLOOKUP` reference-return address and range-composition rows also match in the current bridge scope.
   - current baseline replay is also green for the admitted `SUM` aggregate rows (`direct scalar`, `array literal`, `reference-derived`) through `XLL_ADDIN_BRIDGE_VALIDATION_SCENARIO_MANIFEST_SEED.csv`.
   - current baseline replay is also green for admitted `TEXTJOIN`, `DATE`, `OFFSET`, and `HSTACK` rows through `XLL_ADDIN_BRIDGE_VALIDATION_SCENARIO_MANIFEST_SEED.csv`.
   - remaining bounded lanes now include broader reference construction/info functions and general non-scalar payload coverage outside that manifest scope.
4. Concurrency/thread-safety evidence is incomplete:
   - current probes show registration acceptance and scalar parity, not full scheduler or multithread execution behavior.
5. Host-entrypoint parity is contextual:
   - worksheet formula behavior, COM evaluate paths, and XLL invocation are related but not interchangeable evidence surfaces.
6. Modern worksheet-only error classes are not yet fully preserved through the XLL seam:
   - legacy XLL error transport is narrower than the current worksheet error universe,
   - observed modern errors such as `#CALC!` may currently degrade to `#VALUE!` when returned through the XLL bridge.
7. Post-evaluation format-hinting is not currently exercised through the XLL test seam:
   - caller-cell format mutation/application (for example `NOW` or `TODAY` entered into a `General` cell) is treated as an engine-surface responsibility above the core function result.
   - XLL verification may check value and recalc semantics for such functions, but absence of caller-format application in the XLL seam is not a function-semantic failure by itself.
8. The bridge baseline can improve independently of core function closure:
   - `CLEAN` extra-C1 removal and `DATE(1900,1,0)` are now parity-closed through the rebuilt XLL baseline,
   - but that kind of bridge improvement does not change the rule that XLL limitations must be documented whenever they materially affect evidence claims.
9. Callable/lambda worksheet values are not yet transportable through the current XLL bridge:
   - helper-family worksheet surfaces such as `MAP`, `REDUCE`, `SCAN`, `BYROW`, `BYCOL`, `MAKEARRAY`, and workbook Defined Name callable invocation may be wired through core dispatch/export admission,
   - but the present XLL seam does not yet carry callable worksheet values or workbook Defined Name callable bindings into OxFunc in a way that can prove Excel parity end-to-end through the bridge,
   - so `W38` evidence remains a combination of native Excel worksheet replay and core/runtime dispatch tests rather than XLL bridge replay.

## 4. Primary Evidence Records
1. `docs/function-lane/XLL_ADDIN_BRIDGE_EXECUTION_RECORD.md`
2. `docs/function-lane/XLL_ADDIN_BRIDGE_SHIM_CONTRACT_PRELIM.md`
3. `docs/function-lane/XLL_REGISTRATION_FLAG_EXECUTION_RECORD.md`
4. `docs/function-lane/XLL_NIL_PROPAGATION_EXECUTION_RECORD.md`

## Source: `OxFunc/docs/IN_PROGRESS_FEATURE_WORKLIST.md`

# IN_PROGRESS_FEATURE_WORKLIST.md — OxFunc

Canonical repo-level register of feature areas that are in-progress under workset completion doctrine.

Status: active.
Last updated: 2026-03-26.

## Status Vocabulary

- `in-progress`: partial implementation exists, parity/completeness not yet achieved.
- `blocked`: in-progress with active blocker (see CURRENT_BLOCKERS.md).
- `planned`: explicitly accepted into scope, no shipped work yet.

## Active Feature Register

### IP-01: Function Catalog Expansion

- **Status**: in-progress
- **Current floor**: 40+ functions at `function-phase-complete` across W001-W015 and follow-on closure packets, with the standalone `SUMIF` gap now closed through `W052` and the low-order `ASINH` / `PV` / `FV` / `PMT` publication residuals now closed through `W053`.
- **Remaining gaps**: current-version backlog tracking is now centralized in `W050` and `W051`. `W050` owns deferred-current-version rows (`W041` family plus `TRANSLATE` and `EUROCONVERT`), while `W051` owns in-scope not-complete rows (`W014`, residual `W023` now narrowed to `IMAGE`, `W038`, `W046`, and the current `GROUPBY` / `PIVOTBY` promotion lane after the new OxFunc runtime implementation and bounded OxFml adapter proof).
- **Current narrowing**: `W014` and `W038` are no longer "missing OxFunc kernel" packets. Their remaining work is now mostly seam-vocabulary, compatibility/serialization, and bind/admission ownership tightening after the OxFml adapter validated the admitted `@` and callable-helper slices end-to-end.
- **Why still open**: `W016` is closed, `W022` closes the criteria-family residual, `W024` is reconciled, `W025` is resolved as a classification packet, `W026` is resolved as a characterization-and-extraction packet, `W027` is packet-complete for its declared scope, `W028` corrected the local canonical catalog to `511` names, `W029` is complete as a benchmark/classification packet, `W030` and `W031` are now closed as seam-definition packets, `W032` repaired the reopened finance packet, `W033` closes the newly promoted information-predicate and forecast-compatibility packet, `W034` / `W035` now close the locale/profile residual seam packets, `W036` remains the provenance/evidence owner for the extracted `TRANSLATE` seam baseline while `W050` now carries the current-target deferment, `W037` closes the remaining large-root `XIRR` publication lane, `W040` closes the reference-metadata family, and `W045` closes the current non-`@` operator universe.
- **Canonical owner**: aggregate current-version tracking now lives in `W050` / `W051`; family provenance and execution ownership remain with the narrower packets (`W014`, `W023`, `W038`, `W041`, `W045`, `W046`, `W025`).

### IP-02: Locale and Version Sweeps

- **Status**: planned
- **Current floor**: dual-axis version tracking infrastructure in place; no systematic sweep execution yet.
- **Remaining gaps**: locale-sensitive coercion and formatting behavior across Excel app versions/channels and workbook Compatibility Versions.
- **Why still open**: orthogonal validation phase; functions declared `function-phase-complete` under reference baseline only.
- **Canonical owner**: workset TBD (orthogonal validation phase).

### IP-03: UDF Surface Contract (VBA/JS/Automation)

- **Status**: planned
- **Current floor**: XLL surface contract partially exercised through W009/W011; VBA/JS/Automation boundaries not yet characterized.
- **Remaining gaps**: VBA UDF call semantics, JavaScript API UDF boundary, Automation-facing function invocation semantics.
- **Why still open**: chartered in CHARTER.md Section 4 item 5; not yet targeted by a workset.
- **Canonical owner**: workset TBD.

### IP-04: Formalization Deepening

- **Status**: in-progress
- **Current floor**: Lean substrate-level executable models and bindings for admitted slices per formalization strategy.
- **Remaining gaps**: deeper proof obligations beyond substrate alignment; property and metamorphic proof coverage for complex function families; and the explicit missing-function-id formalization backlog now pinned in `W054`.
- **Why still open**: formalization strategy permits substrate-level work for current phase; deeper obligations are tracked but deferred, and `W054` now owns the first explicit Rust-vs-Lean function-id gap reconciliation pass.
- **Canonical owner**: `W054` for explicit missing-function-id reconciliation, with deeper proof work ongoing across function packets.

### IP-05: XLL Seam Hardening

- **Status**: in-progress
- **Current floor**: XLL add-in bridge exercised through W009/W011; registration flags and basic invocation evidence collected.
- **Remaining gaps**: comprehensive seam limitation catalog; adversarial seam tests; seam-level vs function-semantic status separation in all verification records.
- **Why still open**: seam limitations are documented but not yet systematically hardened across all function families.
- **Canonical owner**: W009/W011 continuation + future worksets.

### IP-06: OxFml/FEC/F3E Interface Refinement

- **Status**: in-progress
- **Current floor**: interface constraints documented in `docs/upstream/NOTES_FOR_OXFML.md`; provisional sketches for provenance carriers and boundary contracts.
- **Remaining gaps**: first shared typed context/query bundle, first shared return-surface split, runtime provider/snapshot consumer model, finalized upstream provenance vocabulary, reference-identity carrier, prepared-call contract, evaluation-mode contract.
- **Why still open**: the latest OxFml note now accepts the first-freeze working rule and the current `W044` callable-row split for one round, but the next seam locks still need explicit packet owners and shared artifacts. Callable field-lock follow-up remains deferred to `W042`; the next agreed seam-hardening owners are `W047`, `W048`, and `W049`.
- **Canonical owner**: cross-repo; tracked via upstream observation ledger, with OxFunc-local seam hardening in `W042`, `W047`, `W048`, and `W049`.
- **Immediate follow-on after seam freeze**: continue current-scope completion through `W014` (`@`), `W046` (`CALL` / `REGISTER.ID` exact packet freeze plus admission/snapshot closure), and the residual `W023` `IMAGE` lane rather than treating it as deferred out-of-scope.

### IP-07: Implicit Intersection and Scalarization Semantics

- **Status**: in-progress
- **Current floor**: canonicalization row `FDEF-018`; native Excel replay for seeded `@` lanes; Rust runtime in `op_implicit_intersection.rs`; Lean binding in `ImplicitIntersection.lean`; and OxFml adapter evidence for seeded `@` scalarization lanes `B01` through `B07`.
- **Remaining gaps**: compatibility-version mapping for `@` vs `SINGLE`/`_xlfn.SINGLE`, broader pre-dynamic-array serialization/roundtrip characterization, and structured-reference/table-context interaction outside the admitted slice.
- **Why still open**: the remaining work is now compatibility/interop characterization rather than a missing OxFunc-side scalarization kernel.
- **Canonical owner**: `W014`.
- **Scope note**: this remains in current scope; it is difficult, not deferred out-of-scope.

### IP-08: Replay Appliance Packet Adapter Rollout

- **Status**: in-progress
- **Current floor**: `W020` and `W021` now have a first live local proving artifact under `.tmp/replay-bundles/oxfunc-w15-v1/`, with `W21_EXECUTION_RECORD.md` and the emitted bundle validation/replay/diff/explain sidecars evidencing local `cap.C0` through `cap.C3` for the `W15` worked packet.
- **Remaining gaps**: live `DNA ReCalc` import against an OxFunc packet bundle, replay-valid reduced packet or row witnesses, a second packet proving the adapter is not `W15`-specific, and any future pack-grade promotion evidence.
- **Why still open**: the local adapter surface is now real and exercised, but `cap.C4` / `cap.C5` remain explicitly non-claimed and the cross-lane replay-host path is still unproven.
- **Canonical owner**: `W018` through `W021`.

### IP-09: Function Name Localization Library

- **Status**: in-progress
- **Current floor**: `W28` now has a reproducible official-support harvest, `40` published `hreflang` alternates, a `20,360`-row localized-name seed, a `509`-name current English harvest, and a reconciliation artifact against the older `500`-row catalog freeze.
- **Remaining gaps**: version-marker extraction, normative variation matching against `MS-OE376`, normalization of localized function names against canonical OxFunc ids, and eventual library-context export for OxFml parse/bind use.
- **Why still open**: `W28` completed its declared discovery-and-seed scope, but the actual localization library and normative reconciliation work remain follow-on packets.
- **Canonical owner**: `W028`.

### IP-10: Library-Context Snapshot Export

- **Status**: in-progress
- **Current floor**: OxFunc now exposes a first explicit snapshot artifact in `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv` with identity/version semantics, first-pass function and operator rows, metadata profiles, and reading guidance in `OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1_README.md`.
- **Remaining gaps**: refinement of field coverage, richer per-entry semantic/gating refs, broader operator coverage beyond the currently exported universe, and a pinned runtime consumer/model beyond the CSV interchange artifact.
- **Why still open**: the first-pass snapshot is now real and usable, and OxFml has accepted the current first-freeze working rule, but the next step is a concrete runtime provider/snapshot consumer model rather than more note-only agreement.
- **Canonical owner**: `W044` for the export artifact, with follow-on consumer/model work in `W049`.

## Source: `OxFunc/docs/worksets/W050_DEFERRED_CURRENT_VERSION_SURFACE.md`

# WORKSET - Deferred Current-Version Surface (W50)

## 1. Purpose
Centralize the Excel function rows that are explicitly deferred from the current OxFunc completion target.

This packet exists to stop older family packets from doubling as the active deferred-scope tracker.

## 2. Provenance
This packet consolidates deferred-current-version ownership from:
1. `W041_EXTERNAL_DATA_PROVIDER_AND_CUBE_FUNCTIONS.md`
2. `W025_DEFERRED_MISC_ADDIN_AND_DYNAMIC_ARRAY_OUTLIERS.md`
3. `W036_DEFERRED_PROVIDER_LANGUAGE_CAPABILITY_BASELINE.md`

## 3. Scope
Machine-readable inventory:
1. `docs/function-lane/W50_DEFERRED_CURRENT_VERSION_INVENTORY.csv`

Current total:
1. `17` function rows.
2. `0` operator rows.

Members:
1. `COPILOT`
2. `CUBEKPIMEMBER`
3. `CUBEMEMBER`
4. `CUBEMEMBERPROPERTY`
5. `CUBERANKEDMEMBER`
6. `CUBESET`
7. `CUBESETCOUNT`
8. `CUBEVALUE`
9. `DETECTLANGUAGE`
10. `ENCODEURL`
11. `EUROCONVERT`
12. `FILTERXML`
13. `GETPIVOTDATA`
14. `PHONETIC`
15. `STOCKHISTORY`
16. `TRANSLATE`
17. `WEBSERVICE`

## 4. Current-Version Rule
For the current version target:
1. all `W041` family members are treated as deferred,
2. the extracted `W036` `TRANSLATE` provider-language seam is also treated as deferred from the current completion target,
3. `EUROCONVERT` is also deferred,
4. no other function or operator row should be treated as deferred unless this packet is updated explicitly.

## 5. Ownership Rule
1. `W50` is the canonical current-version deferred list.
2. The older family packets remain provenance/evidence owners for family-specific work and prior classification.
3. Changes to deferred scope should be reflected here first, then back-propagated to planning summaries.

## 6. Status
1. execution_state: `in_progress`
2. scope_completeness: `scope_complete`
3. target_completeness: `target_complete`
4. integration_completeness: `integrated`
5. open_lanes: none for the list-definition task

## Source: `OxFunc/docs/worksets/W051_IN_SCOPE_CURRENT_VERSION_NOT_COMPLETE_SURFACE.md`

# WORKSET - In-Scope Current-Version Not-Complete Surface (W51)

## 1. Purpose
Centralize the Excel function and operator rows that are still in scope for the current OxFunc version target and are not yet fully complete.

This packet exists to stop older family packets from acting as the active outstanding-scope list.

## 2. Provenance
This packet consolidates active current-version backlog ownership from:
1. `W014_IMPLICIT_INTERSECTION_OPERATOR.md`
2. `W023_DEFERRED_HOST_METADATA_AND_DATABASE_FUNCTIONS.md`
3. `W025_DEFERRED_MISC_ADDIN_AND_DYNAMIC_ARRAY_OUTLIERS.md`
4. `W038_FUNCTIONAL_LAMBDA_AND_HELPER_FAMILY.md`
5. `W045_NON_AT_OPERATOR_UNIVERSE_CLOSURE_PASS.md`
6. `W046_CALL_AND_REGISTER_ID_UDF_REGISTRATION_SEAM.md`
7. latent catalog gaps visible through `W044`

## 3. Scope
Machine-readable inventory:
1. `docs/function-lane/W51_IN_SCOPE_CURRENT_VERSION_NOT_COMPLETE_INVENTORY.csv`

Current total:
1. `14` function rows.
2. `1` operator rows.
3. `15` total rows.

Completed and removed from this inventory (moved to function-phase-complete):
- `COLUMNS`, `RANDARRAY`, `RANDBETWEEN`, `ROWS`, `TRIMRANGE`, `VALUETOTEXT` (6 functions)
- `OP_TRIM_REF_LEADING`, `OP_TRIM_REF_TRAILING`, `OP_TRIM_REF_BOTH` (3 operators, verified against W045 structural slice)

Runtime-partial (remain in inventory):
- `GROUPBY`, `PIVOTBY` (2 functions, OxFunc now has callable-backed runtime kernels and bounded OxFml adapter coverage on the admitted current-baseline slice; the remaining gap is wider completion promotion/documentation rather than first adapter proof)

Important current reading:
- some rows remain here because the cross-repo/current-surface packet is not yet fully closed, not because OxFunc still lacks a real runtime kernel.
- that narrower reading now applies to:
  - `OP_IMPLICIT_INTERSECTION`
  - the callable-helper family rows from `W038`
  - `CALL` / `REGISTER.ID`
- the rows that still represent a genuinely open OxFunc semantic boundary are now mainly:
  - `IMAGE`
  - the registered-external packet-freeze/admission/snapshot lane under `W046`
  - the broader promotion/documentation lane for `GROUPBY` / `PIVOTBY`

Functions:
1. `BYCOL`
2. `BYROW`
3. `CALL`
4. `GROUPBY`
5. `IMAGE`
6. `ISOMITTED`
7. `LAMBDA`
8. `LET`
9. `MAKEARRAY`
10. `MAP`
11. `PIVOTBY`
12. `REDUCE`
13. `REGISTER.ID`
14. `SCAN`

Operators:
1. `OP_IMPLICIT_INTERSECTION` (`@`, legacy alias `SINGLE`)

## 4. Current-Version Rule
For the current version target:
1. every row not listed in `W050` and not already complete must appear here,
2. `GROUPBY` and `PIVOTBY` are no longer W038-blocked scaffolds; they remain here because their current-surface promotion packet is still open,
3. `HYPERLINK` is now treated as complete on the OxFunc side and therefore removed from `W051`; host publication application remains above OxFunc rather than an OxFunc function gap,
4. `ROWS`, `COLUMNS`, `RANDBETWEEN`, `VALUETOTEXT`, `RANDARRAY`, `TRIMRANGE` are now function-phase-complete and removed,
5. trim-reference operators (`OP_TRIM_REF_*`) are verified against W045 structural slice and removed.

## 5. Ownership Rule
1. `W51` is the canonical current-version not-complete list.
2. Older packets remain provenance/evidence owners and, where applicable, execution owners for their family-specific work.
3. New latent gaps should be added here immediately, then extracted into narrower execution packets as needed.

## 6. Status
1. execution_state: `in_progress`
2. scope_completeness: `scope_complete`
3. target_completeness: `target_complete`
4. integration_completeness: `integrated`
5. open_lanes:
   - execution still lives across the provenance packets and future follow-on packets
   - several rows now have real OxFunc runtime/formal/evidence closure on the admitted slice, but remain in `W051` until the surrounding seam or promotion packet is explicitly closed

## Source: `OxFunc/README.md`

# OxFunc

OxFunc is the function-semantics and implementation lane for DNA Calc worksheet compatibility.

OxFunc is the canonical owner for mutable value-type/function-definition working docs.
Foundation remains the canonical owner for external Excel reference/spec corpus artifacts.

## F3E Position
OxFunc is positioned as the value/function slice of `F3E`:
1. owns worksheet value types and coercion semantics,
2. owns function/operator semantics and contracts,
3. references FEC capability dependencies needed by function evaluation.
4. defines cross-cutting function tags (`deterministic`, `volatile`, `host-interaction`) that FEC policy consumes.

Out of slice:
1. formula language grammar/parse/bind (OxFml lane),
2. FEC host protocol/scheduling/state-machine design (FEC/F3E model lane).

## Ownership Split
1. OxFunc-owned mutable docs:
   - `docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
   - `docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`
   - `docs/function-lane/EXCEL_FUNCTION_DEFINITION_DISCUSSION.md`
   - `docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.csv`
   - `docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.md`
2. Foundation-owned reference/spec docs consumed by OxFunc:
   - `../Foundation/reference/conformance/excel-worksheet-engine/functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`
   - `../Foundation/reference/conformance/excel-worksheet-engine/EXCEL_CONFORMANCE_SPEC.md`
   - `../Foundation/reference/conformance/excel-worksheet-engine/SOURCE_BINDINGS.csv`
   - `../Foundation/reference/downloads/*` and `../Foundation/reference/index.*`

## Core Files Here
- `CHARTER.md` - OxFunc charter (canonical for OxFunc lane).
- `OPERATIONS.md` - OxFunc execution doctrine (lane-level operations).
- `TUX1000_PLAN.md` - aspirational execution adjunct to the charter.
- `docs/worksets/W000_KICKOFF_PROGRAM_W001_W006.md` - combined kickoff orchestration for worksets 1..7.
- `docs/worksets/` - sequence-based execution worksets for cross-cutting slices.
- `docs/function-lane/` - mutable function/value working artifacts.
- `docs/FOUNDATION_SPEC_INDEX.md` - indexed read links into Foundation doctrine and reference corpus.
- `docs/FOUNDATION_EDITOR_PROMPTS_FROM_OXFUNC.md` - suggested Foundation repo updates from OxFunc execution.
- `crates/` - Rust runtime/function scaffolding for executable slices.
- `formal/lean/` - Lean formalization scaffolding for function/value proofs.
- `CURRENT_BLOCKERS.md` - active blocker register (`BLK-FN-NNN` entries).
- `docs/IN_PROGRESS_FEATURE_WORKLIST.md` - in-progress feature register.
- `docs/decisions/README.md` - decision register (`ODR-FN-NNN` entries).
- `docs/handoffs/HANDOFF_REGISTER.csv` - cross-repo handoff register.
- `docs/upstream/NOTES_FOR_OXFML.md` - outbound observation ledger for OxFml.

## Notes
- Function behavior now has a dual version axis (Excel app version/channel plus workbook Compatibility Version), reflected in the OxFunc charter.
- OxFunc assumes read access to Foundation artifacts but does not assume direct-write workflow to Foundation during routine iteration.
- Completeness reporting is scope-qualified by doctrine; see `CHARTER.md` section `7.4` and `OPERATIONS.md` section `11`.
- OxFunc does not accept bounded-fit function implementations. A function is only considered implemented when the runtime and the formalization work required by the executable-semantic-model strategy cover the full documented and empirically observed Excel semantics for the declared version scope; the only tolerated limitation is in the XLL verification seam.
- For the current implementation phase, function closure is reported as `function-phase-complete` when the reference-baseline semantics and evaluation seam are understood, no known function-semantic gap remains, and the Lean/formal work required by the function's primary semantic substrate and admitted slice has been attended to and aligned; locale/version sweeps are tracked as later orthogonal validation phases unless explicitly in scope.
- XLL verification-seam limitations must be documented centrally in the seam records and repeated in function verification records wherever those limitations affect the meaning of a parity or closure claim.

