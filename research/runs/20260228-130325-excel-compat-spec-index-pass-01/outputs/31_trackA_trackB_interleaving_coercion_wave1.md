# Pass 31 - Track A/B Interleaving: Coercion Wave 1

## Scope
Interleaved closure batch for `ECS-BL-06` through:
- Track A: coercion dossier update and backlog/progress promotion.
- Track B: empirical wave execution for `ECS-EB-024`, `ECS-EB-025`, `ECS-EB-026`, and `ECS-EB-027`.

Primary references:
- `07_coercion_matrix_response.md`
- `09_coercion_matrix_expansion_response.md`
- empirical outputs under `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/`

## Empirical outputs linked
1. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-024_operator_coercion_truth_table_wave1.csv`
2. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-025_function_family_coercion_probe_wave1.csv`
3. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-026_compatibility_coercion_probe_wave1.csv`
4. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-027_coercion_confidence_scores_wave1.csv`
5. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/WAVE1_EXECUTION_REPORT.md`

## Wave summary
1. Scenario execution: 4/4 scenarios complete.
2. Case rows: 38 total.
3. Result split: 28 `matches_expected`, 3 `mismatch`, 7 `probe`, 0 `run_failed`.
4. Mismatch set: `CW1-022`, `CW1-024`, `CW1-025` (`SUM`/`AVERAGE`/`COUNT` mixed-range coercion expectations).

## Key synthesis decisions
1. `ECS-BL-06` is promoted from seed-only matrix status to evidence-backed wave-1 status with explicit triage retention.
2. Mixed text+numeric range coercion expectations are now explicitly marked as empirical counter-signals rather than implicit low-confidence assumptions.
3. Probe rows remain open by design and are preserved with follow-up flags in `ECS-EB-027`.

## Status decision
Track A/B interleaving advanced `ECS-BL-06` to empirical wave-1 closure with auditable outputs, explicit mismatch triage, and updated progress/index references in the empirical run.
