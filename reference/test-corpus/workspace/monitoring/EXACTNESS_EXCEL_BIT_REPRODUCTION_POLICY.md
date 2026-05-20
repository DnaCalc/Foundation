# Exactness Excel-Bit Reproduction Policy

## 1. Purpose

This note records the current policy for direct-function exactness work in the formula corpus.

The project goal in this lane is **Excel emulation**, not mathematical improvement over Excel.

## 2. Policy

For exactness cases, the required target is the **observed Excel machine result**:
- reproduce Excel bits,
- across widened direct-call witnesses where possible,
- even when Excel appears less accurate than a correctly rounded mathematical/library result.

Implications:
- mathematical correctness is a diagnostic aid, not the acceptance criterion,
- `libm`, closed forms, or numerically improved regroupings are only acceptable when they also reproduce Excel bits,
- if Excel behavior appears to include approximation quirks, biased rounding, or regime-specific publication behavior, matching that behavior is still the intended result for the emulator,
- do not stop an exactness lane merely because the current local result looks more mathematically correct than Excel.

## 3. Steering rules for exactness work

1. Stay owner-correct about implementation location.
   - `OxFunc` owns direct function-evaluation exactness.
   - `OxFml` owns post-function publication/canonicalization if the drift is introduced there.
2. No tolerance-based greening.
3. Prefer widened witness families over single anchor rows.
4. Document known Excel deviations from mathematical correctness when they materially affect the implementation choice.
5. If a bounded kernel rewrite or piecewise approximation is required to match Excel, that is acceptable if it is localized, evidenced, and regression-guarded.

## 4. Current active example: ERFC / FTC-0573

Current retained anchor:
- `FTC-0573`
- formula: `=ERFC(1)`

Direct OxFunc progress:
- `OxFunc` commit `8e435fb16a176120e37a65b3f6eb41147a7578b4`
- subject: `erfc: route through libm::erfc to match Excel exact bits`

Focused host proof after that commit:
- input: `target/triage/erfc-family-after-8e435fb-normal-batch.json`
- output: `target/triage/erfc-family-after-8e435fb-normal-batch-output`
- result:
  - `FTC-0573` / `=ERFC(1)` -> `Matched`
  - `=ERFC(2)` and `=ERFC.PRECISE(2)` -> still `Blocked`

Positive-tail regime map after that commit:
- input: `target/triage/erfc-positive-tail-regime-after-8e435fb-normal-batch.json`
- output: `target/triage/erfc-positive-tail-regime-after-8e435fb-normal-batch-output`
- current read:
  - `1.25` -> `Matched`
  - `1.5`, `1.75`, `2`, `2.25`, `2.5`, `3` -> `Blocked`
  - same regime for `ERFC.PRECISE`

Important policy read from that evidence:
- the earlier local conclusion that `libm::erfc` was more mathematically correct than Excel is **not** a stopping condition,
- the remaining task is to emulate the observed Excel positive-tail regime bitwise,
- any landed ERFC follow-up should explicitly document the Excel-emulation choice and the evidenced deviation from correctly rounded math/library behavior.

## 5. Related notes

> reference/test-corpus/workspace/monitoring/
- `NEXT_FORMULA_WORK_BOARD.md`
- `EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md`
- `EXACTNESS_HIGHER_LEVEL_ESCALATION_PROMPT.md`
- `EXCEL_NUMERIC_CUTOFF_AND_EXACTNESS_THEORY_NOTE.md`
