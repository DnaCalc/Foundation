# EMP-0011

## Header
- finding_id: `EMP-0011`
- status: `provisional`
- claim: external workbook references resolved when the support workbook was explicitly opened, and returned `#REF!` when closed or missing; `update_links=0` and `update_links=3` produced the same observed result in this environment.
- captured_utc: `2026-03-02T08:16:35.4605542Z`

## Source Traceability
- source_run_id: `20260302-100724-excel-nonfunction-closure-pass-01`
- source_task_or_scenario_id: `ECS-EB-036 / NFCP1-LINK-PRESENT-OPEN-UPD0, NFCP1-LINK-PRESENT-OPEN-UPD3, NFCP1-LINK-PRESENT-CLOSED, NFCP1-LINK-MISSING`
- source_evidence_paths:
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/TARGETED_RESULTS.csv`
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/evidence/NFCP1-LINK-PRESENT-OPEN-UPD0/run_manifest.json`
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/evidence/NFCP1-LINK-PRESENT-OPEN-UPD3/run_manifest.json`
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/evidence/NFCP1-LINK-PRESENT-CLOSED/run_manifest.json`
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/evidence/NFCP1-LINK-MISSING/run_manifest.json`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+a02a0cf9d63f2958660ef8bdb731e09aebe879c4`
- tool_commit: `a02a0cf9d63f2958660ef8bdb731e09aebe879c4`

## Observation
- setup: workbook with external reference formula and controlled support-workbook open/missing permutations.
- operation: run lane with support workbook open (`update_links=0` and `update_links=3`), closed, and missing.
- observed_behavior: open support workbook yielded `77`; closed/missing yielded `#REF!`.
- expected_behavior: lane was previously provisional with incomplete open-state mapping.
- divergence_or_match: match with prior provisional hypothesis for this build; remains unresolved cross-build/channel.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FL-006`
- source_basis: `empirical_plus_spec`
- notes: supports build-scoped wording for external-reference open-state policy while leaving broader link-update semantics provisional.

## Follow-up
- next_actions: replay the same scenario matrix across additional builds/channels and link-update permutations.
- supersedes:
- superseded_by:
