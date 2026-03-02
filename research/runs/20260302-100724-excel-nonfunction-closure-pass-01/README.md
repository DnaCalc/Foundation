# Research Run: Excel Non-Function Conformance Closure Pass 01

- Run ID: `20260302-100724-excel-nonfunction-closure-pass-01`
- Status: complete_blocked_on_function_definition
- Date: 2026-03-02

## Purpose
Close as much worksheet-engine conformance scope as possible outside the function-definition deep-semantics area.

Primary closure targets in this run:
1. Formula language lanes (including link/reference behavior).
2. Value/coercion and linked-data lanes where non-function-definition closure is feasible.
3. Table/listobject + spill interaction lanes.
4. Cell formatting + conditional-formatting lanes.

Explicitly deferred for interactive work:
1. Function-definition theory/model decisions.
2. Function deep-semantics policy decisions (volatile vs non-deterministic, host-interaction taxonomy, external invalidation classes).

## Inputs
- `reference/conformance/excel-worksheet-engine/EXCEL_CONFORMANCE_SPEC.md`
- `reference/conformance/excel-worksheet-engine/CONFORMANCE_REQUIREMENTS.csv`
- `reference/conformance/excel-worksheet-engine/KNOWN_GAPS_AND_UNCERTAINTIES.md`
- `reference/conformance/excel-worksheet-engine/model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`
- `research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/*`
- `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/*`

## Planned Outputs
- `outputs/01_scope_and_dependency_map.md`
- `outputs/02_empirical_execution_log.md`
- `outputs/03_non_function_closure_report.md`
- `outputs/04_spec_ambiguity_and_mismatch_register.md`
- `outputs/05_function_definition_prelim_scope.md`
- `outputs/06_function_definition_discussion_topics.md`

## Notes
All empirical captures in this run must include Excel executable hash and tool commit metadata via `excel-probe` output manifests.

Completion note:
1. Non-function closure tasks for this run are complete to current evidence boundaries.
2. Remaining blocker is the function-definition interactive policy phase.
