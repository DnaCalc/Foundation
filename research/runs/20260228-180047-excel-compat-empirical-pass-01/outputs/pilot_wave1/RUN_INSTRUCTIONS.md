# Pilot Wave 1 Run Instructions

## Preconditions
1. Windows Desktop Excel automation lane is available.
2. Runner implementing `excel-probe run` contract is installed.
3. Scenario schema files from `../artifacts/` are available.
4. Run from repository path `research/runs/20260228-180047-excel-compat-empirical-pass-01/` for the commands below.

## Inputs
- Scenario manifest: `scenario_manifest_wave1.csv`
- Scenario files: `scenarios/*.json`

## Suggested execution order
1. `ECS-EB-010` scenarios (recalc matrix baseline)
2. `ECS-EB-011` scenarios (volatility wave 1)
3. `ECS-EB-014` scenarios (INDIRECT/OFFSET structural behavior)
4. `ECS-EB-023` scenarios (locale coercion seed probes)

## Single scenario run
```cmd
..\..\tools\excel-probe\excel-probe.cmd run --scenario outputs/pilot_wave1/scenarios/SCN-EB010-NOW-UNRELATED-EDIT.json --out outputs/pilot_wave1/evidence/SCN-EB010-NOW-UNRELATED-EDIT --visible false --timeout-sec 120
```

## Batch run (.NET runner)
```cmd
..\..\tools\excel-probe\excel-probe.cmd run-manifest --manifest outputs/pilot_wave1/scenario_manifest_wave1.csv --base-dir outputs/pilot_wave1 --out-root outputs/pilot_wave1/evidence --visible false --timeout-sec 180
```

## Post-run updates
1. Populate observed columns in:
   - `ECS-EB-011_volatility_probe_results_wave1.csv`
2. Record structural outcomes in:
   - `ECS-EB-014_indirect_offset_structural_probe.csv`
3. Emit locale outcomes:
   - `locale_coercion_probe_wave1.csv` (new output under this folder)
4. Validate each evidence bundle with validator rules from:
   - `../artifacts/evidence_bundle_validator_v0.md`
5. Update scenario statuses in `scenario_manifest_wave1.csv` (`queued` -> `completed` / `failed` / `not_testable`).

## Failure handling
- If a scenario is not testable (missing capability, unsupported platform), mark status as `not_testable` in normalized output and include explicit reason.
- Do not delete failed evidence bundles; retain for minimization and replay.
