# Spec Ambiguity and Mismatch Register

This register captures spec ambiguities, source inconsistencies, and empirical mismatches identified in this run.

## A. Formula / Link Ambiguities
1. `XLS-CF-FL-010` (`=SUM(A1,,B1)`):
   - observation: accepted/evaluated (`5`) in current build.
   - ambiguity: formal grammar anchors do not settle this edge shape clearly for modern channels.
   - impact: keep build-scoped provisional policy.
2. `XLS-CF-FL-011` (dot-field):
   - observation: parse accepted; `#FIELD!` result reproduced; linked-data conversion remained unavailable (`allowed_error` op status).
   - ambiguity: linked-data-specific branch still not bounded by empirical matrix in this environment.
   - impact: keep provisional; do not collapse to single semantic rule.
3. `XLS-CF-FL-006` (external reference behavior):
   - observation: workbook-open state controls outcome in this harness (`77` vs `#REF!`).
   - ambiguity: link-update/open-state permutations and cross-build behavior not fully mapped.
   - impact: explicit open-state policy wording retained as provisional.

## B. Formatting / Table Mismatch Lanes (Persisted)
1. `XLS-CF-FM-005` (CF spill targets):
   - replay result: `C3/C4` still did not show seeded expected color.
   - prior status: already provisional mismatch lane.
   - update: mismatch reproduced; lane remains active.
2. `XLS-CF-TB-004` (structured-ref spill growth):
   - replay result: `E4` remained `1` where seeded lane expected `3`.
   - prior status: already provisional mismatch lane.
   - update: mismatch reproduced; lane remains active.

## C. Evidence/Spec Consistency Notes
1. Existing conformance text occasionally implied wording closure where only same-build replay existed.
2. This run keeps the distinction explicit:
   - same-build replay consistency achieved for selected lanes,
   - cross-build/channel convergence still pending for final validation.

## D. Function-Definition Coupling Notes
These lanes are not pure non-function and may change when function-definition policy is finalized:
1. aggregate coercion boundary rows (`XLS-CF-TV-008`),
2. parser/evaluator ambiguity treatment for function argument-shape edges (`XLS-CF-FL-010`),
3. selected spill behavior expectations where dynamic-array function semantics drive intent.
