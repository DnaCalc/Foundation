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

## 2. Foundation Tech-Lead and Coordination Role
Agents running in Foundation act as the development coordinator for the overall DNA Calc program when asked to do cross-repo planning, doctrine alignment, stock-taking, or new-repo preparation.

Operating rules:
- Treat Foundation as the doctrine, architecture, operations, conformance-policy, and cross-repo coordination home.
- Coordinate across independent sibling repos without directly editing them from Foundation unless the user explicitly authorizes a repo-scoped run there.
- Prefer handovers, prompt packets, managed-run notes, and sibling-repo agent coordination over unilateral cross-repo changes.
- Keep sibling-repo observations clearly labeled as observed state, not Foundation doctrine, until promoted through the documented synthesis/promotion path.
- For new host-repo bootstrap or DNA TreeCalc / `DnaTreeCalc` preparation, start from Foundation source-of-truth docs and `OPERATIONS.md` Section `8.18`; treat `DnaTreeCalc` as the current reference instance, then coordinate lane/host handovers with OxCalc, OxFml, OxFunc, OxReplay, and related host repos as needed.

### 2.1 Cross-Repo Agent Coordination with `wtd`
Use the global `wtd` tool as the default terminal/agent host coordination mechanism for sibling-repo agents.

Expected pattern:
1. Inspect available workspaces/panes with `wtd list ...` before assuming which agents are running.
2. Use `wtd ask <target> "<prompt>" --timeout <seconds>` for bounded questions to repo-local agents.
3. Use `wtd prompt` plus `wtd wait`/`wtd capture` for longer asynchronous coordination.
4. Ask sibling agents for repo-local status, blockers, handover needs, and doctrine-drift observations; do not ask them to violate their local `AGENTS.md`.
5. Record coordination outcomes in Foundation notes or managed-run artifacts when they affect program planning.

## 3. Context Loading Doctrine
Do not assume project context is already loaded.

Before proposing architecture or process changes:
1. Read `README.md` for orientation.
2. Read `CHARTER.md`.
3. Read `ARCHITECTURE_AND_REQUIREMENTS.md`.
4. Read `OPERATIONS.md`.
5. Read `notes/BRAINSTORM_NOTES.md` as supporting context.

For Replay appliance architecture, governance, or rollout work:
1. Read `REPLAY_APPLIANCE.md` after the core source-of-truth docs.

For repo-creation, repo-bootstrap, or execution-doctrine changes for sibling DNA Calc repos:
1. Read `OPERATIONS.md` Section `8.18` after the core source-of-truth docs.

Use `prompts/` only as helper material, not as source-of-truth doctrine.

## 4. Source of Truth and Conflict Handling
When docs conflict, precedence is:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `notes/BRAINSTORM_NOTES.md`

If a conflict is found, call it out explicitly and propose an edit path instead of silently choosing one interpretation.

## 5. Change Discipline
- Keep changes minimal, explicit, and testable.
- Avoid rehashing high-level mission text in operational docs.
- When adding new policy, place it in the most specific doc and cross-reference from `README.md` or `AGENTS.md` as needed.

## 6. Output Quality
- Prefer concrete decisions, clear assumptions, and short action lists.
- Distinguish current state, proposal, and open questions.
- Avoid claiming completion without naming the artifact changed.
- When listing groups of files, include a standalone relative directory path line immediately before the file list, prefixed with `> `, and without labels like `Relative path`.
