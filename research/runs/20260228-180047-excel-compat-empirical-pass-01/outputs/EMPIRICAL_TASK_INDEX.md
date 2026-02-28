# Empirical Task Index

## Purpose
This index defines the empirical work program for Excel compatibility evidence gathering.
It is split between:
- known-known validation tasks (areas already described with reasonable confidence), and
- backlog-linked tasks (areas previously marked as open/depth-expansion work).

## Inputs and traceability
- Context snapshot: `../inputs/context_snapshot.md`
- Parent run backlog: `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/17_follow_up_execution_backlog.md`
- Parent run master guide: `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md`

## Task catalogs
- `01_known_known_empirical_tasks.md`
- `02_backlog_linked_empirical_tasks.md`

Current task counts:
- Known-known empirical tasks: 48 (`ECS-EK-001..048`)
- Backlog-linked empirical tasks: 46 (`ECS-EB-001..046`)

## Execution ordering
1. Bootstrapping
   - Establish runner/evidence contract tasks from backlog-linked group `ECS-EB-001..ECS-EB-004`.
2. Known-known conformance baseline
   - Execute known-known tasks by domain order: Formula -> Functions -> Types/Coercion -> Tables -> Formatting -> Version/Platform -> Evidence integrity.
3. Backlog depth passes
   - Execute backlog-linked tasks grouped by `ECS-BL-*` mapping from Pass 17.
4. Continuous refresh loop
   - Re-run drift-sensitive tasks (function availability, source recrawl, platform probes) on a dated cadence.

## Task ID scheme
- `ECS-EK-###`: empirical tasks for known-known topics.
- `ECS-EB-###`: empirical tasks derived from follow-up backlog items.

## Evidence artifact contract (minimum per executed task)
- Task execution manifest (`task_id`, runner version, platform/build, timestamp).
- Probe workbook or scenario fixture reference.
- Raw capture output.
- Normalized result output.
- Divergence note (if any) with reproducible rerun command.

## Current execution note
Backlog bootstrapping tasks `ECS-EB-001..004` have initial v0 artifacts under `outputs/artifacts/`.
High-signal pilot tasks `ECS-EB-010/011/014/023` now have prepared wave-1 artifacts under `outputs/pilot_wave1/`.
Platform/version starter tasks `ECS-EB-037/038/046` have seeded artifacts under `outputs/platform_availability/`.
