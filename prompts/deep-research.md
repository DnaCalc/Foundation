# Deep Research Prompt Pattern

## Purpose
Gather clean-room-safe external sources and turn them into actionable, cited research dossiers.

## Inputs Required
- Four core docs (`CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `notes/BRAINSTORM_NOTES.md`)
- Prompt from `PROMPT_PACK_DEEP_RESEARCH.md`

## Expected Outputs
- Annotated source lists with links
- Risk retirement mappings
- Follow-up query set for next research pass
- Run artifacts stored under `research/runs/<run-id>/`

## When To Use / When Not To Use
- Use when source-backed decisions are needed (interop, APIs, standards, formal methods references).
- Do not use for internal consistency edits where external research is unnecessary.

## Recommended Run Order
1. Master landscape run.
2. Two targeted deep dives on highest uncertainty.
3. One interop-focused run when profile targets are chosen.

See `PROMPT_PACK_DEEP_RESEARCH.md` for full run prompts.
