# EMP-0012

## Header
- finding_id: `EMP-0012`
- status: `confirmed`
- claim: direct merge/unmerge operations are captured with explicit merge-state fields; merged state and merge-area metadata are present after merge and cleared after unmerge.
- captured_utc: `2026-03-02T08:17:07.8305067Z`

## Source Traceability
- source_run_id: `20260302-100724-excel-nonfunction-closure-pass-01`
- source_task_or_scenario_id: `ECS-EK-040 / NFCP1-MERGE-UNMERGE-DIRECT`
- source_evidence_paths:
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/evidence/NFCP1-MERGE-UNMERGE-DIRECT/run_manifest.json`
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/evidence/NFCP1-MERGE-UNMERGE-DIRECT/raw_capture.json`
  - `research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/TARGETED_RESULTS.csv`

## Excel Environment
- excel_version: `16.0.19725.20126`
- excel_build: `16.0.19725.20126`
- excel_exe_sha256: `78E29AF2342C4120CAE3BAE64621E3BB2517D4DC122768F107E46528C177379E`

## Runner/Tooling
- runner_name: `excel-probe`
- runner_version: `0.2.0+a02a0cf9d63f2958660ef8bdb731e09aebe879c4`
- tool_commit: `a02a0cf9d63f2958660ef8bdb731e09aebe879c4`

## Observation
- setup: dedicated merge lane with explicit merge and unmerge operations in one scenario.
- operation: capture before merge, after merge, and after unmerge with new capture fields (`merge_cells`, `merge_area_address`).
- observed_behavior: merge state toggled true/false as expected; merge area reported as `$A$2:$B$2` during merged phase.
- expected_behavior: direct state evidence for merge/unmerge lane.
- divergence_or_match: match.

## Conformance Impact
- proposed_requirement_links:
  - `XLS-CF-FM-003`
- source_basis: `empirical_plus_spec`
- notes: upgrades merge/unmerge evidence from indirect-only to direct empirical anchor.

## Follow-up
- next_actions: extend with formula/spill interaction scenarios over merged ranges.
- supersedes:
- superseded_by:
