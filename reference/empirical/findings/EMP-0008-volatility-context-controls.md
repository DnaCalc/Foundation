# EMP-0008

## Header
- finding_id: `EMP-0008`
- status: `confirmed`
- claim: volatility context controls showed expected divergence between volatile (`RAND`) and non-volatile (`SUM`) behavior in recalc sequences; `INFO("recalc")` reflected mode transitions.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-012 / SCN-EB012-*`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/volatility_wave2/ECS-EB-012_volatility_context_probe.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/volatility_wave2/WAVE2_EXECUTION_REPORT.md`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/volatility_wave2/scenario_manifest_wave2.csv`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: volatility-wave fixture with recalc and edit controls.
- operation: run six argument-conditional volatility scenarios.
- observed_behavior: RAND changed on recalc; SUM stayed stable under unrelated edit+recalc; `INFO("recalc")` tracked calc mode changes.
- expected_behavior: volatility-control baseline.
- divergence_or_match: match.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FN-009`
  - `XLS-CF-VP-006`
- source_basis: `empirical_plus_spec`
- notes: supports separation between volatile and non-volatile invalidation paths.

## Follow-up
- next_actions: extend to additional argument-sensitive volatile candidates.
- supersedes:
- superseded_by:
