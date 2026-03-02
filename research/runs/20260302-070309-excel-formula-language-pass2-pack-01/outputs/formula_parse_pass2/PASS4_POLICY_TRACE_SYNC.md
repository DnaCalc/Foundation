# Pass 4 - Policy/Trace Sync (Parallel Lane A)

## Purpose
Close the documentation-level pass after pass-2 execution by tightening provisional policy wording and ensuring trace alignment across the conformance model docs.

## Inputs
1. `FORMULA_PARSE_PASS2_RESULTS.csv`
2. `TARGETED_PASS2C_LANES_REPORT.md`
3. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`
4. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`
5. `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`
6. `reference/conformance/excel-worksheet-engine/model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`

## Actions Completed
1. Fixed provisional wording for scoped-name behavior (`FML-R-008`) using pass-2c evidence (`FMLP2-019/020`).
2. Tightened external-reference wording (`FML-R-006`) to separate:
   - parser acceptance,
   - workbook-present behavior with explicit support-workbook open,
   - missing-workbook behavior (`#REF!`).
3. Tightened dot-field wording (`FML-R-011`) to explicitly capture current harness limitation (linked-data conversion unavailable in current environment).
4. Updated pass-2 plan/open-question wording so closure requirements reflect current state.

## Outcome
1. Pass-2 execution scope is fully represented in conformance docs.
2. No unresolved lane was silently removed.
3. Remaining items are now execution-level, not wording-level:
   - linked-data fixture establishment,
   - link-update/open-state matrix expansion,
   - cross-build/channel replay.

