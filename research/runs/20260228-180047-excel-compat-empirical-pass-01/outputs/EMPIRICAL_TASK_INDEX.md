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
- Parent Track A execution docs: `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/18_trackA_doc_search_execution_pass.md` through `37_trackA_trackB_empirical_full_list_completion.md`

## Task catalogs
- `01_known_known_empirical_tasks.md`
- `02_backlog_linked_empirical_tasks.md`
- `03_execution_progress_status.md`

Current task counts:
- Known-known empirical tasks: 48 (`ECS-EK-001..048`)
- Backlog-linked empirical tasks: 48 (`ECS-EB-001..048`)

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
Run completion state:
1. All backlog-linked tasks `ECS-EB-001..048` have emitted artifacts.
2. All known-known tasks `ECS-EK-001..048` now have closure artifacts in `outputs/known_known_wave1/`.
3. Wave outputs now cover:
   - `pilot_wave1`, `volatility_wave2`, `rtd_wave1`, `date_system_wave1`
   - `reason_code_wave1`, `formula_parse_wave1`, `coercion_wave1`, `cf_wave1`, `table_wave1`
   - `tier45_wave1`, `reopen_wave1`, `crosscut_wave1`, `function_edge_wave1`
   - `platform_availability` and `refresh_cycle_01` (including `ECS-EB-039` parity log + drift probes)
   - `known_known_wave1` (`ECS-EK` closure matrix + per-task artifacts)
   - `unresolved_wave2` (deduplicated unresolved closure matrix)
4. Explicit mismatch/counter-signal rows are retained as closed resolution rows in `unresolved_wave2`, not as open queue entries.
