# Platform Availability Artifacts

## Scope
Seed and schema artifacts for:
- `ECS-EB-037` (availability crawler/probe merge workflow),
- `ECS-EB-038` (platform/build metadata capture),
- `ECS-EB-046` (platform capability profile for explicit testability annotation).

## Files
- `function_availability_matrix.csv`
- `platform_build_metadata_schema.v0.json`
- `platform_capability_profile.template.json`

## Note
`function_availability_matrix.csv` is source-seeded from:
`../../20260228-130325-excel-compat-spec-index-pass-01/outputs/platform_probe_selected_functions.csv`
and still requires empirical probe updates for platform statuses.
