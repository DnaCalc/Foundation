# Formula Language Pass-2 Synthesis Note

## Scope
This note synthesizes pass-2 empirical outcomes into concrete rule-status implications for the Excel formula-language lane.

Run pack:
- `research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/`

## Completed Evidence
1. `37/37` seeded scenarios executed with evidence bundles.
2. No run-level failures.
3. No expected-vs-observed mismatches on rows with explicit accepted/rejected expectation class.

## Status Implications Applied
1. `FML-R-001` promoted to `provisional` with pass-2 operator corpus support.
2. `FML-R-002` promoted to `provisional` with pass-2 precedence checksum support.
3. `FML-R-003` promoted to `provisional` with expanded `@`/`#` interaction evidence.
4. `FML-R-006` promoted to `provisional` with helper-form and external-reference pass-2 coverage.
5. `FML-R-007` promoted to `provisional` with broadened normalization corpus.
6. `FML-R-008` promoted to `provisional` after targeted dual-scope name-lane execution.
7. `FML-R-009` promoted to `provisional` with structured-reference pass-2 matrix coverage.

## Major Behavioral Captures
1. Argument-gap forms (`SUM`/`IF`/`LET`) were accepted in current build (`FMLP2-001..005`).
2. Dot-field and `FIELDVALUE` shapes parsed as accepted and evaluated to `#FIELD!` in current harness (`FMLP2-006..009`).
3. Helper family (`MAP`, `BYROW`, `BYCOL`, `SCAN`, `REDUCE`) parsed/evaluated as accepted.
4. `=-2^2` observed `4`; `=1+2&3` observed `33`.
5. `=@A1#` and `=@SEQUENCE(3)` stored without `@` in tested forms.
6. Targeted pass-2c lane captures:
   - `=MyName` observed `4` under explicit workbook+sheet-scope setup.
   - `=Sheet1!MyName` observed `1` in same setup (policy wording now documented as provisional).
   - external workbook-present lane observed `77` when support workbook was explicitly opened.

## Remaining Unresolved Lanes
1. Linked-data semantic branch for `FML-R-011` remains unresolved without true linked-data fixture setup in the runner.
2. Scoped-name qualification semantics now have provisional wording; cross-build replay is still required.
3. External-reference lane needs link-update/open-state expansion and cross-build replay.
4. Cross-build/channel replay is still required before any `validated` promotion.

## Follow-up Lane Status
1. Pass-4 policy/trace sync: complete.
2. Pass-5 replay-pack preparation: complete.
3. Pass-3 interactive review/planning: prepared and intentionally deferred for interactive execution.

## Documents Updated in Foundation
1. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`
2. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`
3. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`
4. `reference/conformance/excel-worksheet-engine/model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`
5. `reference/conformance/excel-worksheet-engine/EXCEL_CONFORMANCE_SPEC.md`
6. `reference/conformance/excel-worksheet-engine/README.md`
7. `reference/conformance/excel-worksheet-engine/model/README.md`
8. `TARGETED_PASS2C_LANES_REPORT.md`
