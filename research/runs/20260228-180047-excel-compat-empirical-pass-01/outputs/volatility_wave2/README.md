# Volatility Wave 2 - Argument-Conditional Candidates

## Scope
This wave executes `ECS-EB-012` and derives `ECS-EB-013` reason-code mapping from observed stepwise behavior.

## Artifacts
- `scenario_manifest_wave2.csv`
- `scenarios/*.json`
- `ECS-EB-012_volatility_context_probe.csv` (filled after execution)
- `ECS-EB-013_volatility_reason_codes_observed.csv` (filled after analysis)
- `ECS-EB-013_volatility_reason_codes.md`
- `WAVE2_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`

## Execution command
`research\tools\excel-probe\excel-probe.cmd run-manifest --manifest research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\volatility_wave2\scenario_manifest_wave2.csv --base-dir research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\volatility_wave2 --out-root research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\volatility_wave2\evidence --visible false --timeout-sec 180`

## Execution note
Wave 2 has been executed (`6/6` scenarios) with outputs populated in the artifacts listed above.
