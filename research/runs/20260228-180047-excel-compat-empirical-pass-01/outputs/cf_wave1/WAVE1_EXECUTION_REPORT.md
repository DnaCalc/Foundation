# Conditional Format Wave 1 Execution Report

## Scope
Executed wave-1 conditional-format scenarios covering `ECS-EB-031`, `ECS-EB-032`, and `ECS-EB-033`.

## Execution status
- Case rows: 7
- Matches expected: 5
- Mismatch rows: 2
- Probe rows: 0
- Run-failed rows: 0

## Key outcomes
1. Overlap + stop-if-true baseline (`ECS-EB-031`) now has explicit rendered-color evidence rows.
2. Priority transition probe (`ECS-EB-032`) captured stepwise display-color transitions for the overlap target.
3. Table + spill interaction probe (`ECS-EB-033`) captured rendered-color behavior on appended table rows and spilled cells.

### Mismatch detail (first 5)
- `CFW1-021` (Sheet1!C3) expected color `65535` observed `16777215`
- `CFW1-022` (Sheet1!C4) expected color `65535` observed `16777215`

## Artifacts
- `ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv`
- `ECS-EB-032_cf_stopiftrue_probe_wave1.csv`
- `ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv`
- `scenario_manifest_wave1.csv`
- `evidence/<scenario_id>/*`
