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

## Execution note
These artifacts are prepared for execution and have one completed smoke run (`SCN-EB010-SUM-UNRELATED-EDIT`) against the C# Excel runner.
Remaining result columns are pre-created and mostly marked `queued` where empirical values are pending.
