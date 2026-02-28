# Prompt Pass 7 - Coercion Matrix Seed

## Outcome
- Produced initial coercion matrix seed for sheet-visible value behavior.
- Anchored high-confidence rows in official docs for `N`, `VALUE`, `TYPE`, operators, and date systems.
- Marked unresolved/low-confidence areas explicitly for dedicated follow-up.

## High-confidence anchors in this pass
- `N` conversion behavior table.
- `VALUE` numeric text conversion and failure mode.
- `TYPE` code mapping including arrays and compound data types.
- Operator-level baseline (`+`, `&`) from operator docs.
- 1900 vs 1904 date system offset and implications.

## Remaining key unknowns
1. Locale-sensitive coercion details across operators and parser contexts.
2. Dynamic-array lifting/coercion behavior for mixed-type arrays across broad function sets.
3. Exact coercion precedence interactions in nested formulas under compatibility versions.

## Artifact
- `outputs/coercion_matrix_seed.csv`

## Pass-31 empirical update
Wave-1 empirical outputs for `ECS-EB-024/025/026/027` are now linked at:
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-024_operator_coercion_truth_table_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-025_function_family_coercion_probe_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-026_compatibility_coercion_probe_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-027_coercion_confidence_scores_wave1.csv`

Observed follow-up triage from this wave:
1. Mixed text+numeric range behavior for `SUM`, `AVERAGE`, and `COUNT` diverged from seeded expectations (`CW1-022`, `CW1-024`, `CW1-025`), and is now explicitly retained as a known follow-up item.
2. Core operator baseline rows (`="2"+3`, `="x"+1`, boolean arithmetic, date serial arithmetic) matched expected behavior in the current environment.
