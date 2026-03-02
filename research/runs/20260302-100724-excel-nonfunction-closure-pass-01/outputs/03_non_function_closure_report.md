# Non-Function Closure Report

## Scope Closed in This Run
1. Formula/link replay for key provisional grammar/reference lanes.
2. Table/spill and conditional-format spill replay on current environment.
3. Direct merge/unmerge empirical probe using dedicated runner ops.
4. Non-function conformance/doc updates prepared with explicit blocker linkage to function-definition work.

## Closures Achieved
1. External-reference open-state behavior is now explicitly bounded for current build:
   - support workbook open -> linked value observed (`77`),
   - support workbook not opened -> `#REF!`,
   - missing workbook -> `#REF!`,
   - `update_links=0` and `update_links=3` behaved the same in this capture.
2. Merge/unmerge behavior now has direct empirical evidence (no longer only indirect linkage):
   - merged range state observable via `merge_cells`/`merge_area_address`,
   - unmerge operation returns independent cell state in final capture.
3. Formula ambiguity lanes were re-confirmed:
   - `=SUM(A1,,B1)` accepted/evaluated,
   - dot-field parse accepted with field error outcome under current non-linked path.

## Lanes Still Open (Intentionally)
1. `XLS-CF-FL-011` linked-data branch remains unresolved in this harness (conversion op still `allowed_error`).
2. `XLS-CF-FM-005` CF spill-target mismatch persisted (`C3/C4` lane).
3. `XLS-CF-TB-004` structured-reference spill-growth mismatch persisted (`E4` lane).
4. Cross-build/channel replay remains pending for final promotion from `provisional` to `validated`.

## Function-Definition Dependencies
The following non-function lanes remain partly coupled to function-definition policy decisions:
1. `XLS-CF-FL-010` (parser/evaluator ambiguity policy boundary),
2. `XLS-CF-TV-008` (aggregate coercion policy),
3. spill-related lanes where function-family semantics influence expected behavior profiles.

These are tracked as explicit blockers for full closure pending the function-definition phase.

## Function-Definition Handoff Artifacts
1. `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
2. `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`
3. `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_DISCUSSION.md`
4. `outputs/05_function_definition_prelim_scope.md`
5. `outputs/06_function_definition_discussion_topics.md`
