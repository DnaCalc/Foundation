# Empirical Findings Reference Layer

This folder stores curated empirical findings promoted from `research/runs/*` into stable conformance-source records.

## Intent
- Keep exploratory execution artifacts in `research/runs/*`.
- Promote only high-value empirical observations that materially affect conformance requirements.
- Preserve strict provenance for every promoted finding.

## Files
- `findings_registry.jsonl`: machine-readable registry of promoted findings (`EMP-*`).
- `findings_index.md`: human-readable index and status board.
- `findings/TEMPLATE.md`: template for per-finding detail notes.

## Promotion Criteria
Promote an empirical finding when at least one is true:
- It resolves a spec ambiguity that affects implementation requirements.
- It demonstrates behavior that differs from expected/spec-derived interpretation.
- It introduces a stable caveat that should be referenced by multiple conformance items.
- It provides important platform/build/version constraints for compatibility claims.

## Mandatory Provenance
Every registry entry must include:
- `finding_id`, `claim`, `status`
- source run and scenario/task ids
- back-links to evidence artifacts in `research/runs/*`
- Excel environment metadata (`excel_version`, `excel_build`, `excel_exe_sha256`)
- runner/tool metadata (`runner_name`, `runner_version`, `tool_commit`)
- capture timestamp (`captured_utc`)

## Workflow
1. Identify a promotable finding in `research/runs/<run-id>/outputs/*`.
2. Create/update a detail note from `findings/TEMPLATE.md`.
3. Add/update a record in `findings_registry.jsonl`.
4. Add/update the summary row in `findings_index.md`.
5. Link the finding id (`EMP-*`) from conformance requirement drafts where relevant.
