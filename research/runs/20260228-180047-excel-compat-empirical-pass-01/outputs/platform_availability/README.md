# Platform Availability Artifacts

## Scope
Platform/version artifacts for:
- `ECS-EB-037` (availability crawler/probe merge workflow),
- `ECS-EB-038` (platform/build metadata capture),
- `ECS-EB-046` (platform capability profile for explicit testability annotation).

## Files
- `function_availability_matrix.csv`
- `source_matrix_full_interest_enriched.csv`
- `ECS-EB-037_EXECUTION_REPORT.md`
- `run_ecs_eb_037.ps1`
- `platform_build_metadata_schema.v0.json`
- `platform_capability_profile.template.json`

## Note
`run_ecs_eb_037.ps1` crawls pending function pages from:
`../../20260228-130325-excel-compat-spec-index-pass-01/outputs/platform_availability_source_matrix_full_interest_seed.csv`
and regenerates:
- `source_matrix_full_interest_enriched.csv` (expanded per-function applies-to tokens)
- `function_availability_matrix.csv` (merged function-level matrix preserving prior probe-status columns)

`function_availability_matrix.csv` currently includes merged Windows probe outcomes for:
- `RTD` (from `outputs/rtd_wave1/`)
- `NOW` and `TODAY` (from `outputs/date_system_wave1/`)

Remaining platform status columns still require empirical probe updates.
