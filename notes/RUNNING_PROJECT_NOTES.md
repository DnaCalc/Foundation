# RUNNING_PROJECT_NOTES.md — Active Scratchpad

Use this file only for current short-lived notes that have not yet been synthesized.

Rules:
1. Keep entries terse and date-scoped.
2. Promote durable decisions to source-of-truth docs via synthesis runs.
3. Move stale entries to `notes/archive/running-project/`.

## Active entries
- **2026-05-20 — DnaTreeCalc repo created.** `DNA TreeCalc` transitioned from Foundation-hosted planning notes to its own host repo at `..\DnaTreeCalc\`. Created `CHARTER.md` (mission/north-star + program/repo context) and migrated the full planning document set out of `Foundation/notes/` into `..\DnaTreeCalc\docs\` (reorganized into `model/`, `interop/`, `ux/` + `docs/INDEX.md`; cross-references and memory canonical-paths updated). README program-map and bootstrap note updated to register the repo.
  - **Done in the same session (execution-doctrine simplification pass):** wrote a deliberately lean doctrine doc set into `..\DnaTreeCalc\` as the new family template — root `AGENTS.md` (<100 lines), `OPERATIONS.md` (~150, OxIde-shaped), `README.md`; `docs/SPEC.md` (renamed from INDEX.md — the spec/design SET index), `docs/WORKSET_REGISTER.md` (seeded W001–W010), `docs/handovers/README.md` (bead loop is a section of OPERATIONS §5, not a separate BEADS.md); `scripts/invoke-br-serialized.ps1` (copied from OxVba); `.gitignore`. Top-level CHARTER/AGENTS/OPERATIONS by the user's instruction.
  - **Back-patched into Foundation §8.18:** TreeCalc is now the reference instance for the slim host-repo template: `docs/SPEC.md` as spec/design entrypoint, top-level `CHARTER.md`/`AGENTS.md`/`OPERATIONS.md`, a coarse `OPEN -> IN PROGRESS -> CLOSED` workset register paired with epic beads, same-file `HANDOVER_` handovers, optional wrappers/checkers, and lightweight verification/read-through closure.
  - **Follow-on:** scaffold the Rust workspace; roll the updated template into sibling repos over time during repo-local housekeeping or real work.
