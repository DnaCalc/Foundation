# Reason-Code Verification Wave 1

## Scope
Focused `ECS-EB-040`/`ECS-EB-041` interleaved pass for tier-3 weak-evidence functions.

Covered in this wave:
- volatile/recalc signals: `NOW`, `TODAY`, `RAND`, `RANDBETWEEN`
- grid-reference-sensitive set: `ADDRESS`, `AREAS`, `ROW`, `ROWS`, `COLUMN`, `COLUMNS`, `FORMULATEXT`, `INDEX`, `SHEET`, `SHEETS`, `SUMIF`
- format-visible set: `TEXT`, `DOLLAR`, `FIXED`
- type/coercion-sensitive set: `VALUE`, `TYPE`, `N`, `T`, `VALUETOTEXT`

## Files
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `run_wave1.ps1`
- `build_wave1_outputs.ps1`
- `evidence/<scenario_id>/*`
- `ECS-EB-040_reason_code_verification_probe_wave1.csv`
- `ECS-EB-041_classification_evidence_sync_wave1.csv`
- `WAVE1_EXECUTION_REPORT.md`

## Execution
Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/run_wave1.ps1
```

Then synthesize outputs and sync tracker:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/build_wave1_outputs.ps1
```
