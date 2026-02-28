# Synthesis Run README

- Run ID: 20260227-180934-formal-model-consolidation-pass-01
- Date (UTC): 2026-02-27
- Scope: Consolidate formal-model knowledge into `CORE_ENGINE_FORMAL_MODEL.md`, reduce architecture duplication, and archive superseded formal notes.

## Inputs
- Consolidated source notes:
  - `notes/archive/formal-model/FORMAL_MODELS_IDEAS.md`
  - `notes/archive/formal-model/FORMAL_MODEL_REMAINING_NOTES.md`
  - `notes/archive/formal-model/FORMAL_CORE_STATUS_AND_SUGGESTIONS_DRAFT.md`
- Context doctrine/architecture docs:
  - `CHARTER.md`
  - `ARCHITECTURE_AND_REQUIREMENTS.md`
  - `OPERATIONS.md`
  - `README.md`

## Outputs
- Suggestion index: `analysis/suggestion_index.csv`
- Decision log: `decisions/decision_log.csv`
- Synthesis report: `outputs/synthesis_report.md`
- Input freeze: `inputs/source_hashes.csv`
- Consolidated active doc: `CORE_ENGINE_FORMAL_MODEL.md`
- Archived superseded notes: `notes/archive/formal-model/*`

## Completion status
- Source hashes frozen.
- Suggestion index complete.
- Decision log complete.
- Consolidation edits applied to core docs.
- Superseded notes archived and replaced with path-stable redirects.
