# Synthesis Report

- Run ID: 20260225-222801-formal-model-pass-01
- Date (UTC): 2026-02-25
- Source set: formal-model notes corpus + doctrine context docs

## Scope
- Documents updated:
  - `ARCHITECTURE_AND_REQUIREMENTS.md`
  - `notes/FORMAL_MODEL_REMAINING_NOTES.md`
- Inputs considered:
  - 10 scoped source files frozen in `inputs/source_hashes.csv`
  - 20 synthesized suggestions (`FM001`-`FM020`)

## Decision Summary
- Accepted: 18
- Adapted: 0
- Deferred: 2
- Rejected: 0

## Applied Changes
- `ARCHITECTURE_AND_REQUIREMENTS.md`:
  - Added formal state kernel with Roslyn-style green/red persistence-facade model and stable-ID semantics.
  - Added layered formal semantics model (Structure, References, Dependencies, Values, Operations).
  - Added OpLog transition relation and operation-envelope semantics.
  - Added structural rewrite semantics and required rewrite classifications.
  - Added reference resolution/binding model and reference-grid delta obligations.
  - Added SCC-based cycle handling semantics with deterministic iterative-mode contract.
  - Added Lean/OCaml formalization seam and module split for next-step work.
  - Extended constraints and requirements to include replay parity, structural rewrite diagnostics, and cycle determinism.
  - Extended Round 0 artifacts to require formal-core traces.
- `notes/FORMAL_MODEL_REMAINING_NOTES.md`:
  - Captured deferred representation strategies and unresolved semantic decisions.
  - Captured unresolved OpLog compaction/conflict decisions and research probes.
  - Captured deferred doctrine-conflicting suggestion (single-engine/no-OCaml early-round alternative).

## Conflict Handling Notes
- Deferred `FM019` explicitly due to precedence conflict with current doctrine:
  - Current baseline (dual-engine + OCaml oracle) is already embedded in `CHARTER.md` and architecture scope.
  - Proposed edit path: raise as explicit `DEC-###` policy decision (targeting doctrine-level update) before any architecture contraction.

## Open Follow-ups
- Finalize `RowId`/`ColId` scoping policy and canonical address-text policy.
- Define value algebra and array/lifting semantics for formal evaluation layer.
- Specify dynamic-reference (`INDIRECT`-class) dependency policy and spill-overlap rewrite behavior.
- Define OpLog compaction semantics and post-server-sequenced collaboration conflict strategy.

## Complete-run status
- Input freeze complete.
- Suggestion index complete.
- Decision coverage complete (20/20).
- Accepted items applied to target docs.
- Deferred/unused ideas retained explicitly in a dedicated notes file.
