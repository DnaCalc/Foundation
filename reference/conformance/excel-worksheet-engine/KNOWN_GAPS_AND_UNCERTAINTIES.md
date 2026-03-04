# Known Gaps and Uncertainties

This file tracks open/provisional conformance lanes that remain intentionally explicit.

## A. Provisional Requirements (Current)
1. `XLS-CF-FL-010` (`EMP-0001`): parser ambiguity for `=SUM(A1,,B1)`.
2. `XLS-CF-FL-011` (`EMP-0002`): dot-field parse/eval behavior outside linked-data payloads.
3. `XLS-CF-FL-012` (`ECS-109;ECS-110;ECS-111;ECS-112`): function-call admission vs runtime error boundary (required args/coercion/domain/array-lift).
4. `XLS-CF-FL-006` (`EMP-0011`): external-reference open-state policy remains build-scoped and cross-build incomplete.
5. `XLS-CF-FN-009` (`EMP-0009`): SUMIF mixed reason-code signal.
6. `XLS-CF-FN-011` (`EMP-0010`): dynamic-array mixed-type counter-signals.
7. `XLS-CF-TV-008` (`EMP-0003`): aggregate range text coercion mismatches.
8. `XLS-CF-TB-004` (`EMP-0005`): structured-reference spill growth mismatch lane.
9. `XLS-CF-FM-005` (`EMP-0004`): conditional-format spill-target mismatch lane.

## B. Known Unknown Families (Retained)
1. Full per-function edge-case matrix across all functions.
2. Full coercion matrix completeness across locales and compatibility modes.
3. Per-function admission-vs-runtime boundary matrix (missing args, coercion failure, domain failure, array-lift error propagation).
4. Conditional-format deep formal semantics for overlap/priority/spill interactions.
5. Stable machine-readable platform/build function availability for full function set.

## C. Required Follow-up Pattern
1. Keep affected requirement rows `provisional` until reconciliation evidence is promoted.
2. Promote new high-value empirical findings to `EMP-*` with full provenance.
3. Add/refresh requirement evidence ids and rerun affected conformance lanes.
