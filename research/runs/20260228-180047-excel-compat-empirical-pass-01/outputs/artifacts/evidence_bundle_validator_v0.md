# Evidence Bundle Validator v0

## Purpose
Define pass/fail rules for empirical evidence bundle completeness (`ECS-EB-004`).

## Bundle root expectations
Each executed scenario must emit a bundle directory:
`<run-id>/<task-id>/<scenario-id>/`

Required files:
- `run_manifest.json`
- `raw_capture.json`
- `normalized_capture.json`
- `step_capture.json`
- `stdout.log`
- `stderr.log`

## Validation rules
1. Identity consistency
   - `task_id`, `scenario_id`, and `run_id` must match across manifest and normalized capture.
2. Timestamp validity
   - `start_utc <= end_utc` and both parse as UTC timestamps.
3. Schema validity
   - `normalized_capture.json` validates against `normalized_capture_schema.v0.json`.
4. Reproducibility link
   - `normalized_capture.evidence.rerun_command` must exist and be non-empty.
5. Platform/build traceability
   - `excel_build`, `excel_channel`, and `platform` must be present in manifest and normalized environment block.
6. Observation completeness
   - At least one observation row exists.
   - Every observation has `status`.
7. Skip semantics
   - Any `not_testable` status must include explicit capability reason in metadata.
8. Stepwise capture completeness
   - `step_capture.json` must contain at least one `initial_after_setup` step.
   - For scenarios with `N` operations, step captures should include at least `N + 1` steps (initial + per-operation).

## Validator output format
The validator should emit:
- `bundle_validation_result.json`
- `bundle_validation_result.md`

Minimum `bundle_validation_result.json` fields:
- `bundle_path`
- `validated_at_utc`
- `result` (`pass` or `fail`)
- `checks` (array of check name + status + message)
- `errors` (array)
- `warnings` (array)
