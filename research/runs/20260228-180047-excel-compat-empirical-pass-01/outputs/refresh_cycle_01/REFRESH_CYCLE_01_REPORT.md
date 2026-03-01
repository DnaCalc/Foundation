# Refresh Cycle 01 Report

- Cycle UTC: 2026-02-28T22:19:31Z
- Availability matrix change rows: 0
- Drift probes executed: 3

## Artifacts
- `function_availability_matrix.before.csv`
- `function_availability_matrix.after.csv`
- `ECS-EB-039_platform_parity_regression_log_wave1.csv`
- `drift_probe_refresh_results.csv`
- `evidence/REFRESH-*/`

## Notes
1. Availability matrix recrawl uses `run_ecs_eb_037.ps1` and updates `platform_availability/function_availability_matrix.csv`.
2. Regression log records row/field-level changes or explicit `no_change` status.
3. Drift probes rerun selected ambiguity/volatility signals for rapid change detection.
