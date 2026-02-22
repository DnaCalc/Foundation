# Triad Prompt Pattern

## Purpose
Run one problem through Design, Assurance, and Delivery lenses, then synthesize into a single action plan.

## Inputs Required
- Four core docs (`CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `notes/BRAINSTORM_NOTES.md`)
- One explicit task statement
- Three role outputs (for synthesis step)

## Expected Outputs
- `design` report
- `assurance` report
- `delivery` report
- `synthesis` report with a recommended decision set and execution sequence

## When To Use / When Not To Use
- Use when a topic spans spec shape, validation rigor, and implementation impact.
- Do not use for simple editorial fixes or single-file cleanup tasks.

## Sequence
1. Run Design role prompt.
2. Run Assurance role prompt.
3. Run Delivery role prompt.
4. Run Synthesis prompt over those three reports.

## Synthesis Prompt
You will be given three reports: DESIGN, ASSURANCE, DELIVERY for the same task.

Synthesize them into:
1) A single recommended decision set (what we do now vs later).
2) A unified plan with explicit sequencing: Spec -> Packs -> Implementations -> Stabilization.
3) A list of required doc changes (exact headings/IDs).
4) A list of obligation packs and success criteria for "green."
5) Open questions tagged by owner: Design vs Assurance vs Delivery.

Rules:
- If there is conflict, prefer the option that preserves evolvability and validation rigor.
- Keep Pathfinder scope minimal but future-compatible (0->1->2->3).
- The final plan must be actionable in one development cycle.
