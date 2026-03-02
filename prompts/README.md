# Prompts Directory

## Purpose
Define reusable prompt assets and store prompt-run artifacts as versioned project inputs.

## Inputs Required
- `CHARTER.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `OPERATIONS.md`
- `notes/BRAINSTORM_NOTES.md`

## Expected Outputs
- Structured prompt responses in `prompts/runs/<run-id>/responses/`
- Run logs/manifests in `prompts/runs/<run-id>/logs/`
- Reusable role/pack prompt files in this directory tree
- Internal artifacts should not include external-publication attribution headers unless explicitly requested.

## When To Use / When Not To Use
- Use when generating design/assurance/delivery refinements from the foundation docs.
- Do not use as the source of truth for policy or architecture; the core docs remain authoritative.

## Layout
- `PROMPT_PACK.md`: general improvement prompt pack.
- `PROMPT_PACK_DEEP_RESEARCH.md`: deep research prompt pack.
- `MODEL_EXECUTION_NOTES.md`: pinned CLI model ids and one-shot execution templates.
- `triad.md`: triad execution pattern and sequencing.
- `deep-research.md`: deep research run guidance.
- `packs/cell-abstraction-formalization.md`: prompt sequence for in-cell abstraction/formalization passes.
- `packs/xll-non-interesting-functions-implementation.md`: language-independent prompt sequence for `.xll`-based non-interesting function implementation planning and differential validation.
- `roles/`: role-scoped prompt templates.
- `packs/`: phase-scoped prompt curation.
- `runs/`: timestamped executed runs and captured outputs.

## Triad Run Flow
1. Pick one scoped task statement.
2. Run `roles/design.md`, `roles/assurance.md`, and `roles/delivery.md` on the same task.
3. Run synthesis from `triad.md` using those three outputs.
4. Save raw outputs before interpretation.

## Deep Research Flow
1. Start with the master landscape prompt.
2. Run 2 focused deep dives on highest uncertainty.
3. Save source links and output artifacts before doc edits.
