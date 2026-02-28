# Pass 32 - Track A/B Interleaving: Conditional-Format Wave 1

## Scope
Interleaved closure batch for `ECS-BL-08` through:
- Track A: conditional-format scaffold/formatting guide updates and progress promotion.
- Track B: empirical wave execution for `ECS-EB-031`, `ECS-EB-032`, and `ECS-EB-033`.

Primary references:
- `21_conditional_format_semantics_model_scaffold.md`
- `14_formatting_guide.md`
- empirical outputs under `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/`

## Empirical outputs linked
1. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv`
2. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-032_cf_stopiftrue_probe_wave1.csv`
3. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv`
4. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/WAVE1_EXECUTION_REPORT.md`

## Wave summary
1. Scenario execution: 3/3 scenarios complete.
2. Case rows: 7 total.
3. Result split: 5 `matches_expected`, 2 `mismatch`, 0 `probe`, 0 `run_failed`.
4. Mismatch set: `CFW1-021`, `CFW1-022` (`C3`/`C4` spill-target conditional-format expectations in table+spill scenario).

## Key synthesis decisions
1. `ECS-BL-08` is promoted from scaffold-only status to evidence-backed wave-1 status.
2. Baseline overlap/stop-if-true and priority-transition behavior is now anchored with rendered display-format captures.
3. Spill-related conditional-format behavior remains explicitly triaged; seeded expectations for spill-target color propagation require refinement.

## Status decision
Track A/B interleaving advanced `ECS-BL-08` to empirical wave-1 closure with explicit mismatch retention and updated empirical progress/index references.
