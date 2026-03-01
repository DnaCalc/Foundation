# excel-probe

Local empirical runner for Excel worksheet scenario execution.

## Scope
- Executes scenario JSON files (from empirical run artifacts).
- Drives Excel via COM (Windows Desktop Excel target).
- Emits machine-readable run artifacts.
- Records exact Excel executable metadata and SHA256 hash on every run.
- Records tool build metadata and current repo git commit metadata in run outputs.

## Implementation language policy
- Primary runtime language: **C#** (`tools/ExcelProbe/`).
- Optional shell wrappers (`excel-probe.cmd`, `excel-probe.ps1`) are convenience launchers only.
- Process-containment helper language: **C#** (`tools/JobGuard/tools/JobGuard`) where Windows Job semantics are needed.
- Policy alignment:
  - Excel-driving and artifact emission are in the .NET tool.
  - PowerShell may be used for convenience orchestration only (batch loops, wrappers).
  - Python is not used for repo tooling unless an explicit exception is logged.

## Commands
- `run`: execute one scenario.
- `run-manifest`: execute all scenarios listed in a manifest CSV.
- `env`: capture environment metadata only.

## Usage
From repo root (recommended):

```cmd
tools\\excel-probe\\excel-probe.cmd env --out research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\platform_availability
```

```cmd
tools\\excel-probe\\excel-probe.cmd run --scenario research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\pilot_wave1\scenarios\SCN-EB010-SUM-UNRELATED-EDIT.json --out research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\pilot_wave1\evidence\SCN-EB010-SUM-UNRELATED-EDIT --visible false --timeout-sec 180
```

```cmd
tools\\excel-probe\\excel-probe.cmd run-manifest --manifest research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\pilot_wave1\scenario_manifest_wave1.csv --base-dir research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\pilot_wave1 --out-root research\runs\20260228-180047-excel-compat-empirical-pass-01\outputs\pilot_wave1\evidence --visible false --timeout-sec 180
```

Direct `dotnet run` usage is also supported, but run it from `tools/` to honor pinned SDK policy in `tools/global.json`.

## Output files for `run`
- `run_manifest.json`
- `raw_capture.json`
- `normalized_capture.json`
- `step_capture.json`
- `stdout.log`
- `stderr.log`

## Notes
- Default is invisible Excel (`--visible false`).
- Relative scenario/fixture paths are resolved from current working directory.
- If `workbook_fixture` does not exist, the runner creates a new workbook and applies `sheet_setup`.
- Scenario operations support an `args.allow_error=true` flag for expected-failure probes; these are captured as `operation_trace.status=allowed_error` without failing the whole scenario.
- Scenario operations include `create_table` for ListObject setup in worksheet-level probes.
- Scenario operations include conditional-format helpers: `clear_cf`, `add_cf_expression`, `set_cf_priority`, and `set_cf_stop_if_true`.
- Cell capture now includes direct and rendered display-format properties: interior color, font color, bold, and display number format.
- Tool run outputs include tool version/build, git commit, and repo dirty-state metadata when available.

## Runner structure for empirical tasks
1. Scenario source:
   - `research/runs/<empirical-run>/outputs/pilot_wave1/scenarios/*.json`
2. Execution entry:
   - `tools\\excel-probe\\excel-probe.cmd run --scenario ... --out ...`
3. Artifacts per scenario:
   - `run_manifest.json` (includes Excel version and `EXCEL.EXE` hash)
   - `raw_capture.json`
   - `normalized_capture.json`
4. Batch execution:
   - `run-manifest` command or `research/runs/<empirical-run>/outputs/pilot_wave1/run_wave1.ps1` wrapper
5. Platform metadata support:
   - `research/runs/<empirical-run>/outputs/platform_availability/*`


