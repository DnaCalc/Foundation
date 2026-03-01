# EMP-0001

## Header
- finding_id: `EMP-0001`
- status: `provisional`
- claim: `=SUM(A1,,B1)` is accepted and evaluated in the captured Windows Current Channel environment.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-030 / SCN-EB030-AMBIG-DOUBLE-COMMA`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/ECS-EB-030_grammar_ambiguity_probe_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/evidence/SCN-EB030-AMBIG-DOUBLE-COMMA/raw_capture.json`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: formula parse ambiguity scenario fixture.
- operation: enter and recalc `=SUM(A1,,B1)`.
- observed_behavior: accepted and evaluated; stored formula retained.
- expected_behavior: seeded expectation was reject.
- divergence_or_match: divergence (retained as counter-signal).

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FL-011`
- source_basis: `empirical_only`
- notes: parser compatibility lane should treat this as build-scoped behavior until further spec anchor exists.

## Follow-up
- next_actions: recheck on additional channels/platforms and include explicit parser mode decision.
- supersedes:
- superseded_by:
