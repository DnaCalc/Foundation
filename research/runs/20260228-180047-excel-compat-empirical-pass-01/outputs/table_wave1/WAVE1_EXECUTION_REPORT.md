# Table Wave 1 Execution Report

## Scope
Executed wave-1 table/listobject scenarios covering `ECS-EB-034`, `ECS-EB-035`, and `ECS-EB-036`.

## Execution status
- Case rows: 9
- Matches expected: 8
- Mismatch rows: 1
- Probe rows: 0
- Run-failed rows: 0

## Key outcomes
1. Structured-reference + spill interactions now have baseline empirical rows tied to auto-expand mutations.
2. Growth/shrink sequence now captures both value-transition and number-format persistence signals.
3. Platform-divergence artifact is now seeded with Windows-observed baseline plus explicit not-tested markers for Mac/Web.

### Mismatch detail (first 5)
- `TBW1-002` (Sheet1!E4) expected `3` observed value=`1` formula=`=SEQUENCE(ROWS([Val]),1,1,1)` format=`General`

## Artifacts
- `ECS-EB-034_table_spill_interaction_matrix_wave1.csv`
- `ECS-EB-035_table_resize_coercion_format_probe_wave1.csv`
- `ECS-EB-036_table_platform_divergence_probe_wave1.csv`
- `scenario_manifest_wave1.csv`
- `evidence/<scenario_id>/*`
