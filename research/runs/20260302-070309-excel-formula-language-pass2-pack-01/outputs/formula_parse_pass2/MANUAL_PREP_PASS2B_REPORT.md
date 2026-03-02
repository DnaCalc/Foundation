# Formula Parse Pass-2b Manual-Prep Rerun

Target scenarios: FMLP2-008, FMLP2-009, FMLP2-019, FMLP2-021

## Automated prep applied
1. `FMLP2-019`: injected sheet-local name `Sheet1!MyName -> Sheet1!$B$1` before rerun.
2. `FMLP2-021`: created adjacent `Book2.xlsx` (`Sheet1!A1 = 77`) before rerun.

## Linked-data limitation
1. `FMLP2-008` and `FMLP2-009` still require manual linked-data conversion of `A1` for high-confidence semantic validation.
2. This rerun captures current behavior with standard cell content and marks it as probe-only evidence.

## Rerun outcomes
- FMLP2-008: observed=accepted, result_class=probe, display="#FIELD!"
- FMLP2-009: observed=accepted, result_class=probe, display="#FIELD!"
- FMLP2-019: observed=accepted, result_class=probe, display="1"
- FMLP2-021: observed=accepted, result_class=probe, display="#REF!"
