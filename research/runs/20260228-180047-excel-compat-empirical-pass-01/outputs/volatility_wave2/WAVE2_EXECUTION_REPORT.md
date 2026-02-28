# Volatility Wave 2 Execution Report

## Scope
Executed `ECS-EB-012` argument-conditional volatility candidate probes and derived `ECS-EB-013` reason-code mapping.

## Execution status
- Scenarios executed: 6
- Success: 6
- Failure: 0

## High-signal outcomes
1. `RAND()` changed across recalc steps (expected volatile control behavior).
2. `SUM(B1:B2)` stayed stable under unrelated edit + recalc (expected non-volatile control).
3. `INFO("recalc")` reflected calc mode transitions (`Automatic`/`Manual`) and returned to `Automatic` when mode restored.
4. `CELL("address",B1)` and `INFO("directory")` remained stable in the tested trigger sequence.
5. `CELL("filename",A1)` remained stable in open state with an explicit workbook-closed transition captured during close/open operation.

## Artifacts
- `ECS-EB-012_volatility_context_probe.csv`
- `ECS-EB-013_volatility_reason_codes_observed.csv`
- `ECS-EB-013_volatility_reason_codes.md`
- `evidence/<scenario_id>/*`
