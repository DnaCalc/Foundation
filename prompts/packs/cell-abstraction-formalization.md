# Prompt Pack: Cell Abstraction Formalization

## Purpose
Drive iterative prompt runs that extract a reusable abstract "cell system" model from the Excel conformance corpus.

## Inputs Required
- `CHARTER.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `OPERATIONS.md`
- `CORE_ENGINE_FORMAL_MODEL.md`
- `reference/conformance/excel-worksheet-engine/` docs and indexes
- Relevant empirical findings under `reference/empirical/`

## Expected Outputs
- A formalized abstraction vocabulary (values, expressions, references, functions, formats, host context).
- A semantics baseline that can map Excel behavior into abstract operators/rules.
- A traceable mapping from abstraction items to conformance references.
- A next-pass prompt backlog for ambiguity reduction and model strengthening.

## When To Use / When Not To Use
- Use for model extraction, semantic framing, and design-space narrowing.
- Do not use as the authoritative conformance source; `reference/` remains source-backed truth.

## Recommended Prompt Order
1. Model frame extraction (domains, operators, judgments, state boundaries).
2. Semantics core pass (evaluation, coercion, function classes, error propagation).
3. Conformance mapping pass (reference anchors and unresolved uncertainty list).
4. Synthesis pass (accept/adapt/defer plus doc update plan).
