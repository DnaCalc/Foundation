# EMP-0002

## Header
- finding_id: `EMP-0002`
- status: `provisional`
- claim: dot-field formula `=A1.Price` is accepted syntactically and evaluates to a field-related worksheet error in the captured environment.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-030 / SCN-EB030-DOTFIELD-PROBE`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/ECS-EB-030_grammar_ambiguity_probe_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/evidence/SCN-EB030-DOTFIELD-PROBE/raw_capture.json`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: dot-field ambiguity probe fixture.
- operation: evaluate `=A1.Price`.
- observed_behavior: parse accepted; evaluation returned field-related error.
- expected_behavior: probe-only (no strict pass/fail seed).
- divergence_or_match: probe signal captured.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FL-012`
- source_basis: `empirical_plus_spec`
- notes: pair with linked-data-type field-reference docs for bounded behavior definition.

## Follow-up
- next_actions: test with true linked data-type cell payloads and explicit field names.
- supersedes:
- superseded_by:
