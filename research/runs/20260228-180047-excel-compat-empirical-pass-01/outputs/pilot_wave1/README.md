# Pilot Wave 1 - High-Signal Tasks

## Scope
This folder contains runnable planning artifacts for the first high-signal backlog tasks:
- `ECS-EB-010` (recalc event matrix),
- `ECS-EB-011` (volatility probe wave 1),
- `ECS-EB-014` (INDIRECT/OFFSET structural dependency probes),
- `ECS-EB-023` (locale coercion harness plan).

## Artifacts
- `scenario_manifest_wave1.csv`
- `ECS-EB-010_recalc_event_matrix.csv`
- `ECS-EB-011_volatility_probe_results_wave1.csv`
- `ECS-EB-014_indirect_offset_structural_probe.csv`
- `ECS-EB-023_locale_coercion_harness_plan.md`
- `ECS-EB-023_locale_matrix_seed.csv`
- `scenarios/*.json` (scenario files conforming to `artifacts/empirical_scenario_schema.v0.json`)
- `RUN_INSTRUCTIONS.md`
- `run_wave1.ps1` (PowerShell launcher that calls .NET `excel-probe run-manifest`)
- `pilot_wave1_result_summary.csv`
- `PILOT_WAVE1_EXECUTION_REPORT.md`

## Execution note
These artifacts have now been executed as a complete pilot wave (`14/14` scenarios) against the C# Excel runner.
Follow-up result interpretation tables still need a dedicated analysis pass over captured evidence bundles.
