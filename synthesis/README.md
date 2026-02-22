# Synthesis Runs

## Purpose
Convert prompt-run responses into disciplined, traceable edits to the foundation source-of-truth documents.

## Inputs Required
- One completed prompt run under `prompts/runs/<run-id>/responses/`
- Foundation docs:
  - `CHARTER.md`
  - `ARCHITECTURE_AND_REQUIREMENTS.md`
  - `OPERATIONS.md`
  - `notes/BRAINSTORM_NOTES.md` (supporting context)

## Expected Outputs
- Explicit per-suggestion decisions
- Document edits to the three foundation docs
- Run logs and change summary under `synthesis/runs/<run-id>/`

## When To Use / When Not To Use
- Use when folding a batch of prompt outputs into authoritative documents.
- Do not use for raw ideation capture; raw ideation belongs in prompt runs or brainstorm notes.

## Source-of-Truth Precedence
If suggestions conflict with existing doctrine, use:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `notes/BRAINSTORM_NOTES.md`

## Run Layout
Use one timestamped directory per synthesis pass:

- `synthesis/runs/<run-id>/README.md`
- `synthesis/runs/<run-id>/inputs/source_run.txt`
- `synthesis/runs/<run-id>/inputs/source_hashes.csv`
- `synthesis/runs/<run-id>/analysis/suggestion_index.csv`
- `synthesis/runs/<run-id>/decisions/decision_log.csv`
- `synthesis/runs/<run-id>/logs/manifest.csv`
- `synthesis/runs/<run-id>/outputs/synthesis_report.md`

## Decision Log Schema (minimum)
- `suggestion_id`
- `source_file`
- `target_doc`
- `target_section`
- `action` (`accept|adapt|defer|reject`)
- `rationale`
- `change_ref` (file path + line after edit)
- `owner`
- `status` (`proposed|applied|verified`)

## Workflow
1. Freeze source inputs by hash.
2. Extract suggestions from all source response files.
3. Classify suggestions by target document and section.
4. Decide each suggestion with explicit action and rationale.
5. Apply accepted/adapted edits to foundation docs.
6. Verify consistency against precedence rules.
7. Emit `outputs/synthesis_report.md` and update manifest.

## Guardrails
- Treat prompt outputs as suggestions only.
- Do not silently drop suggestions; use explicit `defer` or `reject` entries.
- Keep one synthesis commit per run for traceability.
