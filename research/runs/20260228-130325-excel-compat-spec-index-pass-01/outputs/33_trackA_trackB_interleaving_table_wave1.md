# Pass 33 - Track A/B Interleaving: Table Wave 1

## Scope
Interleaved closure batch for `ECS-BL-09` through:
- Track A: table/listobject semantics continuation framing.
- Track B: empirical wave execution for `ECS-EB-034`, `ECS-EB-035`, `ECS-EB-036`.

Primary references:
- `13_table_semantics_guide.md`
- `17_follow_up_execution_backlog.md`
- empirical outputs under `../../20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/`

## Empirical outputs linked
1. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/ECS-EB-034_table_spill_interaction_matrix_wave1.csv`
2. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/ECS-EB-035_table_resize_coercion_format_probe_wave1.csv`
3. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/ECS-EB-036_table_platform_divergence_probe_wave1.csv`
4. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/WAVE1_EXECUTION_REPORT.md`

## Wave summary
1. Scenario execution: 3/3 scenarios complete.
2. Case rows: 9 total.
3. Result split: 8 `matches_expected`, 1 `mismatch`, 0 `probe`, 0 `run_failed`.
4. Mismatch retained: `TBW1-002` (`SEQUENCE(ROWS([Val]),...)` growth expectation counter-signal).

## Key synthesis decisions
1. Table structured-reference plus spill interactions are now evidence-backed rather than source-only.
2. Table growth/shrink probes now include both value and formatting persistence signals.
3. Platform divergence artifact is seeded with explicit Windows observed rows and untested markers for other platforms.

## Status decision
Track A/B interleaving advanced `ECS-BL-09` to wave-1 empirical closure with explicit retained mismatch triage.
