# RTD Wave 1 - Lifecycle Probes

## Scope
This wave executes `ECS-EB-015` lifecycle probes against a local C# RTD server (`DnaCalc.Tools.RtdServer`).

## Artifacts
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `rtd_lifecycle_probe.csv` (filled after execution)
- `RTD_WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`

## Preconditions
1. Register the local RTD server:
   - `research\tools\excel-rtd-server\excel-rtd-server.cmd register`
2. Confirm registration:
   - `research\tools\excel-rtd-server\excel-rtd-server.cmd info`

## Execution command
`research\tools\excel-probe\excel-probe.cmd run-manifest --manifest research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\rtd_wave1\scenario_manifest_wave1.csv --base-dir research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\rtd_wave1 --out-root research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\rtd_wave1\evidence --visible false --timeout-sec 240`
