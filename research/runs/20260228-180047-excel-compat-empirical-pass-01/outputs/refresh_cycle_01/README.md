# Refresh Cycle 01

## Scope
Refresh-loop execution cycle covering:
- source recrawl and matrix merge refresh (`ECS-EB-037`),
- platform parity regression logging (`ECS-EB-039`),
- targeted drift-sensitive probe reruns (formula ambiguity + volatility controls).

## Run
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/refresh_cycle_01/run_refresh_cycle_01.ps1
```
