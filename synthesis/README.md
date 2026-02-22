# Synthesis Runs

## Purpose
Convert prompt-run and research-run outputs into disciplined, traceable edits to the foundation source-of-truth documents.

## Inputs Required
- One or more completed runs from:
  - `prompts/runs/<run-id>/responses/`
  - `research/runs/<run-id>/outputs/`
- Foundation docs:
  - `CHARTER.md`
  - `ARCHITECTURE_AND_REQUIREMENTS.md`
  - `OPERATIONS.md`
  - `notes/RESEARCH_NOTES.md`
  - `notes/BRAINSTORM_NOTES.md` (supporting context)

## Expected Outputs
- Explicit per-suggestion decisions
- Document edits to foundation docs and/or `notes/RESEARCH_NOTES.md`
- Run logs and change summary under `synthesis/runs/<run-id>/`
- Internal artifacts should not include external-publication attribution headers unless explicitly requested.

## When To Use / When Not To Use
- Use when folding a batch of prompt/research outputs into authoritative documents.
- Do not use for raw ideation capture; raw ideation belongs in prompt runs or brainstorm notes.

## Source-of-Truth Precedence
If suggestions conflict with existing doctrine, use:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `notes/RESEARCH_NOTES.md`
5. `notes/BRAINSTORM_NOTES.md`

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
7. Mark source run manifests/registries as synthesized.
8. Emit `outputs/synthesis_report.md` and update manifest.

## Guardrails
- Treat prompt and research outputs as suggestions/evidence only.
- Do not silently drop suggestions; use explicit `defer` or `reject` entries.
- Keep one synthesis commit per run for traceability.
- Treat run artifacts as audit/history records; source-of-truth is the core docs plus retained notes.

## Completion Criteria
A synthesis run is complete when:
- source input hashes are frozen,
- every scoped suggestion has a decision entry,
- accepted/adapted items are applied to source-of-truth docs,
- source runs are marked `synthesized` with the synthesis run id,
- the synthesis report and manifest are emitted.
