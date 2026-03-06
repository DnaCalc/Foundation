# AGENTS.md - Agent Execution Doctrine

This file defines how coding agents should operate in this repository.

## 1. Public Attribution Doctrine (Mandatory)
For any issue, pull request, email response, release note, discussion post, or any other external/public-facing message authored by an agent, the first line must be an italicized attribution line.

Required format:

*Posted by Codex agent on behalf of @govert*

If a different agent is used, replace `Codex` with the applicable identifier (for example, `Claude`).

Scope exclusions (do not add attribution line by default):
- internal run artifacts (for example `prompts/runs/*` and `synthesis/runs/*` outputs),
- repository documentation drafts and working notes,
- local analysis files that are not being published externally.

Only add attribution in these excluded contexts if explicitly requested for publication formatting.

## 2. Context Loading Doctrine
Do not assume project context is already loaded.

Before proposing architecture or process changes:
1. Read `README.md` for orientation.
2. Read `CHARTER.md`.
3. Read `ARCHITECTURE_AND_REQUIREMENTS.md`.
4. Read `OPERATIONS.md`.
5. Read `notes/BRAINSTORM_NOTES.md` as supporting context.

Use `prompts/` only as helper material, not as source-of-truth doctrine.

## 3. Source of Truth and Conflict Handling
When docs conflict, precedence is:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `notes/BRAINSTORM_NOTES.md`

If a conflict is found, call it out explicitly and propose an edit path instead of silently choosing one interpretation.

## 4. Change Discipline
- Keep changes minimal, explicit, and testable.
- Avoid rehashing high-level mission text in operational docs.
- When adding new policy, place it in the most specific doc and cross-reference from `README.md` or `AGENTS.md` as needed.

## 5. Output Quality
- Prefer concrete decisions, clear assumptions, and short action lists.
- Distinguish current state, proposal, and open questions.
- Avoid claiming completion without naming the artifact changed.
- When listing groups of files, include a standalone relative directory path line immediately before the file list, prefixed with `> `, and without labels like `Relative path`.
