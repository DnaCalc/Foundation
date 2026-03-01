# EMP-0003

## Header
- finding_id: `EMP-0003`
- status: `provisional`
- claim: aggregate range coercion rows for SUM/AVERAGE/COUNT over mixed text+numeric ranges diverged from seeded expectations in wave1.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-025 / SCN-EB025-AGG-COERCION / CW1-022,CW1-024,CW1-025`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/ECS-EB-025_function_family_coercion_probe_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/unresolved_resolution_matrix_wave2.csv`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: coercion wave1 aggregate function scenario.
- operation: execute SUM/AVERAGE/COUNT rows over mixed text+numeric ranges.
- observed_behavior: reproduced counter-signals across reruns.
- expected_behavior: seeded expected results differed.
- divergence_or_match: divergence retained with closure state.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-TV-009`
- source_basis: `empirical_conflicts_spec`
- notes: requires explicit test-oracle row ownership per function/context.

## Follow-up
- next_actions: expand coercion matrix with locale and compatibility-version axes.
- supersedes:
- superseded_by:
