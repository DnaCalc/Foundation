# EMP-0004

## Header
- finding_id: `EMP-0004`
- status: `provisional`
- claim: conditional-format spill-target cells (`C3`,`C4`) did not show seeded expected color in table+spill interaction probe.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-033 / SCN-EB033-CF-TABLE-SPILL / CFW1-021,CFW1-022`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv`
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
- setup: conditional formatting table+spill fixture.
- operation: apply/observe CF with spill targets.
- observed_behavior: expected yellow (`65535`) not observed; white (`16777215`) observed.
- expected_behavior: seeded expected color on spill targets.
- divergence_or_match: divergence retained with closure state.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FM-006`
- source_basis: `empirical_conflicts_spec`
- notes: spill+CF interaction remains a high-value edge lane requiring explicit compatibility policy.

## Follow-up
- next_actions: isolate rule-order, applies-to range, and spill timing dimensions.
- supersedes:
- superseded_by:
