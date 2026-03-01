# EMP-0006

## Header
- finding_id: `EMP-0006`
- status: `confirmed`
- claim: RTD lifecycle baseline scenarios (positive topics, missing ProgID, close/open transitions, calc-mode transition) executed successfully with expected high-level behavior.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-015 / SCN-EB015-*`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/rtd_wave1/rtd_lifecycle_probe.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/rtd_wave1/scenario_manifest_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/rtd_wave1/RTD_WAVE1_EXECUTION_REPORT.md`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: local C# RTD server and RTD lifecycle fixture workbook.
- operation: run 5 lifecycle scenarios.
- observed_behavior: successful positive topic updates, expected `#N/A` for missing ProgID, and reopen/calc-mode transitions captured.
- expected_behavior: baseline lifecycle behavior.
- divergence_or_match: match.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FN-010`
  - `XLS-CF-VP-004`
- source_basis: `empirical_plus_spec`
- notes: establishes executable baseline lane for RTD conformance harness.

## Follow-up
- next_actions: extend with multi-topic throttling and stale-value propagation scenarios.
- supersedes:
- superseded_by:
