# Formatting Empirical Task List

## A. Style hierarchy and precedence
1. `FMT-EK-001`:
   - question: How does effective style resolve across workbook default, row style, column style, and cell style index?
   - method: controlled matrix workbook with one varying layer at a time, plus XML extraction of `styles.xml` and sheet `s` references.
2. `FMT-EK-002`:
   - question: What is precedence when row-style and column-style conflict and cell has/has not explicit style index?
   - method: two-axis conflict matrix and display capture on targeted cells.
3. `FMT-EK-003`:
   - question: How do table style regions overlay direct cell formatting?
   - method: table style toggles (`headerRow`, `bandedRows`, etc.) + direct format writes before/after.
4. `FMT-EK-004`:
   - question: How do conditional-format overlays interact with direct and table-applied formatting?
   - method: overlapping CF rules with explicit priorities and stop-if-true variants.

## B. Defaults and origin
1. `FMT-EK-005`:
   - question: What are default font, size, and base style identifiers in a new workbook in this environment?
   - method: generate fresh workbook, inspect style tables, compare UI-observed effective style on untouched cells.
2. `FMT-EK-006`:
   - question: Are defaults workbook/template-derived or machine/build profile derived for practical conformance purposes?
   - method: compare fresh workbook created from blank vs template variant and across profile toggles.
3. `FMT-EK-007`:
   - question: How are `sheetFormatPr` defaults (`baseColWidth`, `defaultRowHeight`) reflected in runtime behavior?
   - method: mutate values via file artifact and observe Excel open/render normalization.

## C. Locale/regional interaction
1. `FMT-EK-008`:
   - question: How does `Use system separators` (decimal/list) affect number-format render results?
   - method: run same workbook under separator variants and capture display text and recalculated values.
2. `FMT-EK-009`:
   - question: Which formatting effects are locale profile only (render) versus parse/coercion affecting?
   - method: pair `TEXT`, `VALUE`, direct cell entry parse probes with identical style/formula setup.

## D. Formula visibility of formatting
1. `FMT-EK-010`:
   - question: Does `TEXT(cell, "...")` read ambient cell formatting, or only explicit format-string input?
   - method: vary cell formatting while holding `TEXT` format string constant; then vary format string while holding cell formatting constant.
2. `FMT-EK-011`:
   - question: What formatting metadata is observable through `CELL(...)` and `INFO(...)` in modern Excel?
   - method: baseline matrix across documented info-types and formatting mutations.
3. `FMT-EK-012`:
   - question: Can formula pathways observe conditional-format effective style directly?
   - method: compare formula outputs before/after CF-triggered visual change; include `CELL`/`INFO` candidates.
4. `FMT-EK-013`:
   - question: What can legacy compatibility techniques (`GET.CELL`/XLM macro lanes) observe, and does that include CF-effective style?
   - method: controlled named-formula/XLM compatibility probe with explicit safety boundary and version tagging.

## E. Output synthesis targets
1. Promote stable findings to `reference/empirical/findings_registry.jsonl` (`EMP-*`).
2. Update `CONFORMANCE_REQUIREMENTS.csv` status for affected `XLS-CF-FM-*` rows.
3. Update `EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md` with validated precedence/default/visibility rules.
