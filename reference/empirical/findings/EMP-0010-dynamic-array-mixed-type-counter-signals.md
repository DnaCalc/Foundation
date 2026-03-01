# EMP-0010

## Header
- finding_id: `EMP-0010`
- status: `provisional`
- claim: dynamic-array mixed-type rows for FILTER/UNIQUE and selected LAMBDA-helper outputs were reproduced as counter-signals in unresolved wave2 closure.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-018/ECS-EB-019 unresolved wave2 replay (T45W1-002,T45W1-003,T45W1-012,T45W1-013)`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/ECS-EB-018_dynamic_array_mixed_type_probe_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/ECS-EB-019_lambda_helper_edge_probe_wave1.csv`
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
- setup: tier4/5 dynamic-array and lambda-helper wave fixtures with unresolved replay.
- operation: replay deduplicated unresolved rows.
- observed_behavior: counter-signals reproduced for targeted rows.
- expected_behavior: seeded expected rows differed.
- divergence_or_match: divergence retained with explicit closure status.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FN-008`
  - `XLS-CF-TV-010`
- source_basis: `empirical_conflicts_spec`
- notes: retain as provisional compatibility lane pending additional build/platform confirmations.

## Follow-up
- next_actions: extend scenario corpus for mixed-type lifting semantics per function family.
- supersedes:
- superseded_by:
