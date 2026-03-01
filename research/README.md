# Research Workspace

## Purpose
Track deep-research topics, prioritized sources, and run artifacts in a versioned evidence workspace.

## Inputs Required
- Deep-research prompt templates from `prompts/PROMPT_PACK_DEEP_RESEARCH.md`
- Foundation docs (`CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `notes/BRAINSTORM_NOTES.md`)

## Expected Outputs
- Topic queue and priority state in `research/topic_registry.csv`
- Source and author/work tracking in `research/sources.csv`
- Optional people-to-follow list in `research/people_watchlist.md`
- Managed external-spec mirror and index in `research/specs/`
- Timestamped run artifacts in `research/runs/<run-id>/`
- Run lifecycle state that distinguishes captured evidence from synthesized knowledge

## When To Use / When Not To Use
- Use for source-backed investigation and evidence gathering.
- Do not place prompt templates here; prompt templates stay in `prompts/`.
- Do not treat research outputs as doctrine without synthesis and doc updates.

## Prompts vs Research
- `prompts/` = reusable prompt templates (how to ask).
- `research/` = concrete investigations and sources (what was found).

## Lifecycle Status
- `captured`: run outputs collected but not yet synthesized.
- `synthesized`: findings promoted into core docs and/or `notes/RESEARCH_NOTES.md`.
- `archived`: retained for audit/history; no longer active working set.

## Suggested Run Layout
- `research/runs/<run-id>/README.md`
- `research/runs/<run-id>/inputs/prompt.txt`
- `research/runs/<run-id>/inputs/topic_context.md`
- `research/runs/<run-id>/outputs/response.md`
- `research/runs/<run-id>/outputs/source_list.csv`
- `research/runs/<run-id>/logs/manifest.csv`

Use `research/templates/` to bootstrap each run folder.
