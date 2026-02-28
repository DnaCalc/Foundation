# Coercion Wave 1 Execution Report

## Scope
Executed wave-1 coercion scenarios covering `ECS-EB-024`, `ECS-EB-025`, `ECS-EB-026`, and generated confidence synthesis for `ECS-EB-027`.

## Execution status
- Case rows: 38
- Matches expected: 28
- Mismatch rows: 3
- Probe rows: 7
- Run-failed rows: 0

## Task breakdown
- ECS-EB-024: 8 rows, mismatches 0
- ECS-EB-025: 21 rows, mismatches 3
- ECS-EB-026: 9 rows, mismatches 0

## Key outcomes
1. Operator coercion baseline (`ECS-EB-024`) produced an evidence-backed truth table for numeric-text, boolean, concat, and date arithmetic contexts.
2. Function-family coercion probes (`ECS-EB-025`) captured direct-arg vs range coercion differences and left explicit probe lanes where behavior is context-sensitive.
3. Compatibility/precedence probes (`ECS-EB-026`) captured precedence-sensitive outcomes including unary/exponent and ambiguity constructs.
4. Confidence scoring (`ECS-EB-027`) was generated for every case with explicit follow-up flags.

### Mismatch detail (first 5)
- `CW1-022` (Sheet1!B2) expected value [2|] observed value [3|3]
- `CW1-024` (Sheet1!B4) expected value [2|] observed value [1.5|1.5]
- `CW1-025` (Sheet1!B5) expected value [1|] observed value [2|2]

## Artifacts
- `ECS-EB-024_operator_coercion_truth_table_wave1.csv`
- `ECS-EB-025_function_family_coercion_probe_wave1.csv`
- `ECS-EB-026_compatibility_coercion_probe_wave1.csv`
- `ECS-EB-027_coercion_confidence_scores_wave1.csv`
- `scenario_manifest_wave1.csv`
- `evidence/<scenario_id>/*`
