# Synthesis Prompt: Core Engine DAG + FEC/F3E + Program Plan Integration

Use the frozen source set in `inputs/source_run.txt` only.

## Primary task
Produce an integrated synthesis report and decision set that unifies:
1. The current layered core engine design direction,
2. The best FEC/F3E seam specification and evidence,
3. External model outputs (ChatGPT + Claude),
4. Internal dual-model review outputs,
5. The Codex projects/repo work plan.

## Required output structure
1. Findings (severity-ordered, with source citations).
2. Conflict map (where sources disagree; doctrine precedence and resolution path).
3. Target architecture (core layers, overlays, lifecycle boundaries, invariants).
4. FEC/F3E contract edits (field/type-level, deterministic failure semantics).
5. Overlay semantics (dynamic refs, spills, formatting/display, visibility policy).
6. Concurrency model (epoch fences, commit rules, publish atomicity, retry policy).
7. Program/repo execution plan integration (phased adoption mapped to repo boundaries).
8. Pack/proof/empirical closure matrix.
9. Open decisions register updates.

## Guardrails
- Do not collapse structural graph truth into runtime overlay truth.
- Keep policy/mechanism split explicit for scheduler behavior.
- Preserve Round-0 compatibility behavior via profile gating where needed.
- Make TEXT and conditional-format observability boundary explicit and testable.
- Treat visibility-first as optional policy that cannot alter stabilized semantics.

## Expected synthesis artifacts to update
- `analysis/suggestion_index.csv`
- `decisions/decision_log.csv`
- `decisions/open_decisions_register.md`
- `outputs/synthesis_report.md`
