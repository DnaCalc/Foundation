# Per-Finding Detail Template

## Header
- finding_id: `EMP-XXXX`
- status: `provisional | confirmed | superseded | deprecated`
- claim: `<short claim>`
- captured_utc: `<ISO-8601 UTC>`

## Source Traceability
- source_run_id: `<research run id>`
- source_task_or_scenario_id: `<task/scenario id>`
- source_evidence_paths:
  - `<path 1>`
  - `<path 2>`

## Excel Environment
- excel_version: `<e.g. 16.0.x>`
- excel_build: `<build/channel>`
- excel_exe_sha256: `<sha256>`

## Runner/Tooling
- runner_name: `<tool name>`
- runner_version: `<version>`
- tool_commit: `<git commit>`

## Observation
- setup:
- operation:
- observed_behavior:
- expected_behavior:
- divergence_or_match:

## Conformance Impact
- proposed_requirement_links:
  - `<REQ/REAL/conformance item ids>`
- source_basis: `empirical_only | empirical_plus_spec | empirical_conflicts_spec`
- notes:

## Follow-up
- next_actions:
- supersedes:
- superseded_by:
