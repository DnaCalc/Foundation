# EMP-0007

## Header
- finding_id: `EMP-0007`
- status: `confirmed`
- claim: date-system wave1 confirmed NOW/TODAY sensitivity to 1900/1904 toggles and distinct behavior for formula copy vs serial-value copy across workbooks.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-016 / SCN-EB016-*`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/date_system_wave1/now_today_date_system_probe.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/date_system_wave1/scenario_manifest_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/date_system_wave1/DATE_SYSTEM_WAVE1_EXECUTION_REPORT.md`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: source/destination workbook fixtures with date-system toggles.
- operation: execute NOW/TODAY toggle and cross-workbook copy scenarios.
- observed_behavior: formulas remained formula-driven in destination; serial-value copy preserved numeric serial while display shifted by date system.
- expected_behavior: date-system model behavior.
- divergence_or_match: match.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-TV-006`
- source_basis: `empirical_plus_spec`
- notes: high-value baseline for date serial conformance and inter-workbook operations.

## Follow-up
- next_actions: expand to locale format and leap-year edge rows.
- supersedes:
- superseded_by:
