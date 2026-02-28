# Desktop Runner Contract v0

## Scope
This contract defines the minimum command and output behavior for Windows Desktop Excel empirical probes.
It is intended as the first executable lane for `ECS-EB-002`.

## Command shape
`excel-probe run --scenario <path-to-scenario.json> --out <output-dir> [--visible false] [--timeout-sec N]`

Batch command:
`excel-probe run-manifest --manifest <scenario_manifest.csv> --base-dir <manifest-base-dir> --out-root <evidence-root> [--visible false] [--timeout-sec N]`

Required arguments:
- `--scenario`: path to a scenario JSON document conforming to `empirical_scenario_schema.v0.json`.
- `--out`: directory for run artifacts.

Optional arguments:
- `--visible`: whether to show Excel UI (`false` default for automation runs).
- `--timeout-sec`: hard timeout guard for hangs.

## Required outputs
For each run:
1. `run_manifest.json`
2. `raw_capture.json`
3. `normalized_capture.json` (conforms to `normalized_capture_schema.v0.json`)
4. `stderr.log`
5. `stdout.log`

## Fixture resolution policy
- `inputs.workbook_fixture` is an execution hint path, relative to the run root unless absolute.
- If fixture file exists: runner opens it and applies `sheet_setup` writes as overlay.
- If fixture file does not exist: runner creates a new workbook, applies `sheet_setup`, and records the created fixture path in `run_manifest.json`.
- Runner must not fail only because the fixture path is missing when `sheet_setup` is sufficient to construct the scenario.

## Required run manifest fields
- `run_id`
- `task_id`
- `scenario_id`
- `runner_version`
- `runner_build_version`
- `excel_build`
- `excel_channel`
- `platform`
- `start_utc`
- `end_utc`
- `exit_status`
- `tooling.repo_git_commit`
- `tooling.repo_git_is_dirty`

## Error and non-testable handling
- If scenario cannot run due to missing capability (for example RTD server absent), runner must:
  - set exit status to success-with-skip,
  - emit observation status `not_testable` for affected assertions,
  - include explicit capability reason in `raw_capture.json`.
- Runner must never silently suppress failed operations.

## Determinism requirements
- Runner must log calc mode before and after execution.
- Runner must log workbook open/save/close operations with timestamps.
- Runner must include a rerun command string in normalized capture.
- Runner should record workbook date system (`1900` / `1904` / `unknown`) when observable.

## Minimal acceptance checks
- Scenario schema validation passes.
- Excel session starts and closes cleanly.
- All required output files are emitted.
- Normalized capture validates against schema.
