# Excel Cell Concrete Model Workspace

This directory is the Excel-first concrete modeling lane for in-cell worksheet-engine semantics.

## Purpose
- Provide a concrete, detailed, reviewable model of Excel in-cell behavior.
- Keep every model statement source-backed and traceable.
- Make unresolved areas explicit before any abstraction/generalization pass.

## Files
- `EXCEL_CELL_CONCRETE_MODEL.md`: concrete model document (human-readable).
- `EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md`: planning draft for Formula Evaluation Context (FEC), including the matching F3E interaction protocol and cell-level state machine sketch.
- `FEC_F3E_INTERFACE_DRAFT_SPEC.md`: comprehensive draft interface spec for FEC/F3E responsibilities, call contracts, state model, and pathfinder-oriented Rust split mapping.
- `FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv`: protocol obligation matrix for sequence/capability/token/error policy lanes.
- `EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`: detailed concrete formula-language rule set for `ECM-FML-*`.
- `EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`: rule-by-rule status/evidence/probe mapping for `FML-R-*`.
- `EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`: pass-2 plan with execution status and remaining unresolved lanes.
- `EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv`: seeded scenario list for pass-2 formula-language empirical execution.
- `EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`: concrete formatting hierarchy/default/visibility model and precedence lanes.
- `EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`: explicit open-question ledger.
- `EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`: machine-linkable trace records for model statements.
- Pass-2 run artifact lane:
  - `research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/PASS2_SYNTHESIS_NOTE.md`
  - `research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/PASS4_POLICY_TRACE_SYNC.md`
  - `research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/PASS5_REPLAY_PACK.md`
  - `research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/PASS3_INTERACTIVE_PLAN.md`
- Formatting formal focused pass artifact lane:
  - `../../runs/20260305-ms-formatting-formal-pass-01/outputs/FORMATTING_FORMAL_FINDINGS.md`
  - `../../runs/20260305-ms-formatting-formal-pass-01/outputs/FORMATTING_HIERARCHY_FINDINGS.md`

## Trace Model
Each `trace` record should bind:
- concrete model statement id (`ECM-*`),
- related requirement id(s) (`XLS-CF-*`),
- source evidence id(s) (`ECS-*`, `REFX-*`, `EMP-*`),
- source evidence id(s) (`ECS-*`, `REFX-*`, `EMP-*`, `INT-*`),
- current status (`draft`, `provisional`, `validated`).

## Operating Rule
- Do not silently remove uncertainty.
- If evidence conflicts, keep both references and mark the statement/row `provisional`.
- Abstraction extraction is downstream work after this concrete model is tightened.
