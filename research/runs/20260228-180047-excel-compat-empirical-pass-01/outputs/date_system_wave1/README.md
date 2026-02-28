# Date-System Wave 1 - NOW/TODAY + Cross-Workbook Copy

## Scope
This wave executes `ECS-EB-016` covering:
- NOW/TODAY behavior under 1900/1904 date-system transitions,
- cross-workbook copy/paste of NOW/TODAY formulas,
- cross-workbook copy/paste of date serial values.

## Artifacts
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `now_today_date_system_probe.csv` (filled after execution)
- `DATE_SYSTEM_WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`

## Execution command
`research\tools\excel-probe\excel-probe.cmd run-manifest --manifest research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\date_system_wave1\scenario_manifest_wave1.csv --base-dir research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\date_system_wave1 --out-root research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\date_system_wave1\evidence --visible false --timeout-sec 240`
