# Excel Compatibility Empirical Pass 01

- Run ID: `20260228-180047-excel-compat-empirical-pass-01`
- Status: scaffolded/planned with runner smoke-test completed
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

## Directory layout
- `START_HERE.md`: deferred execution entrypoint and readiness checklist.
- `inputs/context_snapshot.md`: frozen context and source references used by this pass.
- `outputs/EMPIRICAL_TASK_INDEX.md`: master index and execution ordering.
- `outputs/01_known_known_empirical_tasks.md`: comprehensive empirical tasks for covered topic areas (excluding follow-up unknown backlog).
- `outputs/02_backlog_linked_empirical_tasks.md`: empirical task decomposition for `17_follow_up_execution_backlog.md`.
- `outputs/pilot_wave1/`: high-signal pilot artifacts for `ECS-EB-010/011/014/023`.
- `outputs/platform_availability/`: seeded artifacts for `ECS-EB-037/038/046`.
- `logs/`: execution manifests and run logs for future empirical runs.

## Working rule
All future empirical evidence produced for this pass should link back to task IDs from this run before being promoted or synthesized.

## Runner
- Excel runner CLI source: `../../tools/excel-probe/tools/ExcelProbe/ExcelProbe.csproj`
- Job helper tooling: `../../tools/JobGuard/`
