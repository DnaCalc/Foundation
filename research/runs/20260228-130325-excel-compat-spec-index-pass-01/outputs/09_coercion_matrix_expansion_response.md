# Prompt Pass 9 - Coercion Matrix Expansion

## Outcome
- Expanded coercion matrix from seed to broader operator/function contexts.
- Added date-system and serial-model rows as explicit compatibility anchors.
- Marked unresolved behaviors explicitly where public docs are incomplete.

## Confidence posture
- High confidence: documented TYPE, N, VALUE, date-system delta, core operator framing.
- Medium confidence: contexts inferred from adjacent documented behavior but not fully tabled by Microsoft.
- Low confidence: dynamic-array mixed-type lifting and structured-reference coercion interplay.

## Artifact
- `outputs/coercion_matrix_expanded.csv`

## Pass-31 empirical update
Track B wave-1 coercion execution is now complete for:
- `ECS-EB-024` operator truth table
- `ECS-EB-025` function-family coercion probes
- `ECS-EB-026` compatibility/precedence probes
- `ECS-EB-027` confidence scoring synthesis

Linked outputs:
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-024_operator_coercion_truth_table_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-025_function_family_coercion_probe_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-026_compatibility_coercion_probe_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-027_coercion_confidence_scores_wave1.csv`

Wave summary:
1. 38 case rows executed with 0 run failures.
2. 28 rows matched seeded expectations.
3. 3 rows mismatched (`SUM`/`AVERAGE`/`COUNT` on mixed text+numeric ranges), and remain explicit triage targets.
4. 7 probe rows remain intentionally interpretation-oriented (`expected_kind=probe`), with follow-up flags preserved in confidence scoring output.
