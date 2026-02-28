# Start Here - Deferred Execution Guide

## Why this file exists
This run is intentionally prepared for later execution without relying on prior agent context.
Use this file as the entry point.

## Current state
- Planning and scaffolding complete.
- Pilot wave scenarios prepared.
- Runner migration complete (`excel-probe` C# runtime).
- Smoke execution completed for `SCN-EB010-SUM-UNRELATED-EDIT`; remaining wave scenarios are still pending.

## First read order
1. `README.md`
2. `outputs/EMPIRICAL_TASK_INDEX.md`
3. `outputs/02_backlog_linked_empirical_tasks.md`
4. `outputs/pilot_wave1/RUN_INSTRUCTIONS.md`
5. `outputs/artifacts/desktop_runner_contract_v0.md`

## Execution boundary
Start with pilot scenarios only:
- `ECS-EB-010`
- `ECS-EB-011`
- `ECS-EB-014`
- `ECS-EB-023`

Then continue with platform/version starters:
- `ECS-EB-037`
- `ECS-EB-038`
- `ECS-EB-046`

## Working directory assumptions
- For manual commands in `RUN_INSTRUCTIONS.md`, run from:
  `research/runs/20260228-180047-excel-compat-empirical-pass-01/`
- For `run_wave1.ps1`, run from any directory (script resolves local paths from its own location).

## Readiness checklist
1. Windows Desktop Excel automation is available.
2. `excel-probe` .NET runner is available at:
   - `research/tools/excel-probe/tools/ExcelProbe/ExcelProbe.csproj`
   - launcher: `research/tools/excel-probe/excel-probe.cmd` (recommended).
   - SDK policy pinned by `research/tools/global.json` (`10.0.103`, non-preview).
3. Output schemas are available:
   - `outputs/artifacts/empirical_scenario_schema.v0.json`
   - `outputs/artifacts/normalized_capture_schema.v0.json`
4. Capability profile is captured:
   - `outputs/platform_availability/platform_capability_profile.template.json` cloned and filled for actual environment.
5. Build metadata capture format is in place:
   - `outputs/platform_availability/platform_build_metadata_schema.v0.json`

## Definition of done for pilot wave
1. Every scenario in `outputs/pilot_wave1/scenario_manifest_wave1.csv` has a generated evidence bundle.
2. `ECS-EB-011_volatility_probe_results_wave1.csv` is populated with observed values/status.
3. `ECS-EB-014_indirect_offset_structural_probe.csv` is populated with observed outcomes.
4. `locale_coercion_probe_wave1.csv` is created and linked.
5. Bundle validation reports are produced per scenario.
6. `logs/manifest.csv` is updated with execution records.

## Known deferred items
- Full function-wide empirical passes and deep backlog tasks remain intentionally queued.
- External dependency scenarios (RTD/CUBE/connectors) may be `not_testable` depending on environment; mark explicitly, do not skip silently.
