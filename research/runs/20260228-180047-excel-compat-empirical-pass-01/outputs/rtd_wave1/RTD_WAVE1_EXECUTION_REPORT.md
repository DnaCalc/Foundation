# RTD Wave 1 Execution Report

## Scope
Executed `ECS-EB-015` RTD lifecycle scenarios using local C# RTD server `DnaCalc.Tools.RtdServer`.

## Execution status
- Scenarios executed: 5
- Success: 5
- Failure: 0

## Key outcomes
1. RTD positive topics (`TICKS`, `PULSE`) returned observed values and updated over operation sequences.
2. Missing ProgID negative control remained `#N/A` as expected.
3. Close/open scenarios recorded workbook-close transitions and recovery after reopen.
4. Calc mode transition scenario captured manual/automatic operation path for RTD topic.

## Artifacts
- `rtd_lifecycle_probe.csv`
- `scenario_manifest_wave1.csv`
- `evidence/<scenario_id>/*`
