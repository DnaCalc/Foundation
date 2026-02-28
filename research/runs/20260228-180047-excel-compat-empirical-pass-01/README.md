# Excel Compatibility Empirical Pass 01

- Run ID: `20260228-180047-excel-compat-empirical-pass-01`
- Status: active; pilot wave (14/14), volatility wave2 (6/6), RTD wave1 (5/5), date-system wave1 (5/5), reason-code wave1 (8/8), formula-parse wave1 (20/20), coercion wave1 (4/4 scenarios, 38 cases), conditional-format wave1 (3/3 scenarios, 7 cases), and platform availability source merge completed with evidence bundles/artifacts
- Parent research run: `20260228-130325-excel-compat-spec-index-pass-01`
- Parent baseline commit: `0934496`
- Snapshot timestamp (local): `2026-02-28T18:01:54+02:00`
- Snapshot timestamp (UTC): `2026-02-28T16:01:54Z`

## Purpose
This run holds empirical planning and execution artifacts for Excel behavior validation.
It is designed to be executable without implicit agent memory by using explicit context snapshots, task catalogs, and evidence contracts.

## Scope
- Build empirical tasks for all currently understood (known-known) topic areas from the parent run outputs.
- Decompose follow-up backlog items into executable empirical tasks.
- Prepare stable runner/evidence scaffolding for future automated Excel probe passes.
- Maintain explicit linkage to Track A documentation/search passes from the parent run.
  - Including continuation closures from parent passes `24` through `32` (tier-5/4 evidence bindings, parse corpus registry, full interesting-function platform seed, and interleaving closures for BL-11, BL-07, BL-06, and BL-08 wave-1 passes).

## Directory layout
- `START_HERE.md`: deferred execution entrypoint and readiness checklist.
- `inputs/context_snapshot.md`: frozen context and source references used by this pass.
- `outputs/EMPIRICAL_TASK_INDEX.md`: master index and execution ordering.
- `outputs/01_known_known_empirical_tasks.md`: comprehensive empirical tasks for covered topic areas (excluding follow-up unknown backlog).
- `outputs/02_backlog_linked_empirical_tasks.md`: empirical task decomposition for `17_follow_up_execution_backlog.md`.
- `outputs/03_execution_progress_status.md`: current completed-vs-remaining interleaving progress snapshot.
- `outputs/pilot_wave1/`: high-signal pilot artifacts for `ECS-EB-010/011/014/023`.
  - includes execution summary and analysis report (`pilot_wave1_result_summary.csv`, `PILOT_WAVE1_EXECUTION_REPORT.md`).
- `outputs/volatility_wave2/`: argument-conditional volatility and reason-code artifacts for `ECS-EB-012/013`.
- `outputs/reason_code_wave1/`: tier-3 weak-evidence reason-code verification and classification sync artifacts for `ECS-EB-040/041`.
- `outputs/formula_parse_wave1/`: formula parse acceptance/normalization/ambiguity artifacts for `ECS-EB-028/029/030`.
- `outputs/coercion_wave1/`: coercion operator/function/precedence artifacts for `ECS-EB-024/025/026/027`.
- `outputs/cf_wave1/`: conditional-format overlap/priority/table-spill artifacts for `ECS-EB-031/032/033`.
- `outputs/platform_availability/`: `ECS-EB-037` source-crawl/merge artifacts plus `ECS-EB-038/046` schemas/templates.
- `logs/`: execution manifests and run logs for future empirical runs.

## Working rule
All future empirical evidence produced for this pass should link back to task IDs from this run before being promoted or synthesized.

## Runner
- Excel runner CLI source: `../../tools/excel-probe/tools/ExcelProbe/ExcelProbe.csproj`
- Job helper tooling: `../../tools/JobGuard/`
