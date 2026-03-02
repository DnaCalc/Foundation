# Excel Cell Concrete Model Workspace

This directory is the Excel-first concrete modeling lane for in-cell worksheet-engine semantics.

## Purpose
- Provide a concrete, detailed, reviewable model of Excel in-cell behavior.
- Keep every model statement source-backed and traceable.
- Make unresolved areas explicit before any abstraction/generalization pass.

## Files
- `EXCEL_CELL_CONCRETE_MODEL.md`: concrete model document (human-readable).
- `EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`: detailed concrete formula-language rule set for `ECM-FML-*`.
- `EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`: rule-by-rule status/evidence/probe mapping for `FML-R-*`.
- `EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`: pass-2 plan with execution status and remaining unresolved lanes.
- `EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv`: seeded scenario list for pass-2 formula-language empirical execution.
- `EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`: explicit open-question ledger.
- `EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`: machine-linkable trace records for model statements.

## Trace Model
Each `trace` record should bind:
- concrete model statement id (`ECM-*`),
- related requirement id(s) (`XLS-CF-*`),
- source evidence id(s) (`ECS-*`, `REFX-*`, `EMP-*`),
- current status (`draft`, `provisional`, `validated`).

## Operating Rule
- Do not silently remove uncertainty.
- If evidence conflicts, keep both references and mark the statement/row `provisional`.
- Abstraction extraction is downstream work after this concrete model is tightened.
