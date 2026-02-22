# Synthesis Run README

- Run ID: 20260222-152845-foundation-pass-02-prompt-and-research
- Date (UTC): 2026-02-22
- Scope: Prompt run re-check plus full research-run synthesis into source-of-truth docs and retained research notes.

## Inputs
- Prompt run: `prompts/runs/20260222-011351-prompt-pack`
- Research runs:
  - `research/runs/20260222-082019-run1-master-landscape`
  - `research/runs/20260222-082019-run2-concurrency-mvcc`
  - `research/runs/20260222-083307-run1-master-landscape-internal`
  - `research/runs/20260222-083307-run2-concurrency-mvcc-internal`
  - `research/runs/20260222-084640-run3-asupersync-deep-dive-internal`
  - `research/runs/20260222-123425-run4-janestreet-oxcaml-incremental-internal`

## Outputs
- Suggestion index: `analysis/suggestion_index.csv`
- Decision log: `decisions/decision_log.csv`
- Synthesis report: `outputs/synthesis_report.md`
- Input freeze: `inputs/source_hashes.csv`

## Completion status
- Source hashes frozen.
- Decision log complete for scoped suggestions.
- Accepted/adapted changes applied to core docs and research notes.
- Prompt/research manifests and topic registry marked synthesized.
