# EMP-0005

## Header
- finding_id: `EMP-0005`
- status: `provisional`
- claim: structured-reference spill growth row (`TBW1-002`) diverged from seeded expectation after table growth.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-034 / SCN-EB034-STRUCTREF-SPILL / TBW1-002`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/ECS-EB-034_table_spill_interaction_matrix_wave1.csv`
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
- setup: table spill interaction fixture with table growth.
- operation: evaluate `=SEQUENCE(ROWS([Val]),1,1,1)` downstream spill behavior after growth.
- observed_behavior: observed value remained `1` in mismatch row where `3` was seeded.
- expected_behavior: spill extension with table growth.
- divergence_or_match: divergence retained with closure state.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-TB-005`
- source_basis: `empirical_conflicts_spec`
- notes: implementers should treat this as environment-anchored behavior until cross-build confirmations exist.

## Follow-up
- next_actions: run controlled matrix over structured-ref form variants and calc mode transitions.
- supersedes:
- superseded_by:
