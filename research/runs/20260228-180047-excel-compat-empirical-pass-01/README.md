# Excel Compatibility Empirical Pass 01

- Run ID: `20260228-180047-excel-compat-empirical-pass-01`
- Status: complete; backlog-linked (`ECS-EB-001..048`), known-known (`ECS-EK-001..048`), and unresolved closure wave artifacts are present
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
  - Including continuation closures from parent passes `24` through `37` (interleaving closure, run completion synthesis, and full-list empirical closure).

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
- `outputs/table_wave1/`: table/listobject deep interaction artifacts for `ECS-EB-034/035/036`.
- `outputs/tier45_wave1/`: tier-5 caveat + tier-4/3 deep-semantics artifacts for `ECS-EB-017/018/019/020/021/022`.
- `outputs/reopen_wave1/`: reopen-determinism probe artifacts for `ECS-EB-044`.
- `outputs/function_edge_wave1/`: function-edge planning/index artifacts for `ECS-EB-005/006/007/008/009`.
- `outputs/crosscut_wave1/`: cross-cutting schema/method artifacts for `ECS-EB-042/043/044/045/047/048`.
- `outputs/platform_availability/`: `ECS-EB-037` source-crawl/merge artifacts plus `ECS-EB-038/046` schemas/templates.
- `outputs/refresh_cycle_01/`: refresh-loop artifacts (ECS-EB-039 parity regression + targeted drift probes).
- `outputs/known_known_wave1/`: closure artifacts for `ECS-EK-001..048` (direct probes + linked evidence matrix).
- `outputs/unresolved_wave2/`: deduplicated unresolved queue replay and closure matrix.
- `logs/`: execution manifests and run logs for future empirical runs.

## Working rule
All future empirical evidence produced for this pass should link back to task IDs from this run before being promoted or synthesized.

## Runner
- Excel runner CLI source: `../../tools/excel-probe/tools/ExcelProbe/ExcelProbe.csproj`
- Job helper tooling: `../../tools/JobGuard/`
