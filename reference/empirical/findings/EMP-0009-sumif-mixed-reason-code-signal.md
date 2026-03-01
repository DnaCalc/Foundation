# EMP-0009

## Header
- finding_id: `EMP-0009`
- status: `provisional`
- claim: SUMIF showed a mixed reason-code signal: changed on related edits but remained stable on unrelated-edit+recalc in wave1 verifier.
- captured_utc: `2026-02-28T22:20:10.5318434Z`

## Source Traceability
- source_run_id: `20260228-180047-excel-compat-empirical-pass-01`
- source_task_or_scenario_id: `ECS-EB-040 / SCN-EB040-SUMIF-UNRELATED-EDIT`
- source_evidence_paths:
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/ECS-EB-040_reason_code_verification_probe_wave1.csv`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/WAVE1_EXECUTION_REPORT.md`
  - `research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/scenario_manifest_wave1.csv`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`
- tool_commit: `5d0cfc1c8021cf6eedc89ae77e5048f5578cf121`

## Observation
- setup: tier-3 reason-code verifier matrix.
- operation: execute SUMIF control sequences.
- observed_behavior: mixed behavior relative to seeded reason-code expectation.
- expected_behavior: single stable reason-code classification.
- divergence_or_match: divergence retained.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FN-011`
- source_basis: `empirical_conflicts_spec`
- notes: keep SUMIF in explicit provisional lane pending expanded matrix.

## Follow-up
- next_actions: broaden SUMIF matrix across criteria shape, range shape, and calc-mode transitions.
- supersedes:
- superseded_by:
