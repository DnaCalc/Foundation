# Pass 21 - Conditional Format Semantics Model Scaffold

## Purpose
Define a worksheet-visible semantics scaffold for conditional-format rule precedence and overlap behavior, with explicit uncertainty tags.

Primary backlog link:
- `ECS-BL-08` in `17_follow_up_execution_backlog.md`

## Source anchors
- `ECS-028` (conditional formatting user model)
- `ECS-029` (formula-based conditional rules)
- `ECS-030` (Open XML conditional-format structure)
- `14_formatting_guide.md` (run-local synthesis summary)

## Worksheet-visible evaluation model (scaffold)
1. Candidate-set resolution:
   - Determine rules whose applies-to ranges include target cell.
2. Priority ordering:
   - Evaluate rules in workbook-defined priority sequence.
3. Stop-if-true gating:
   - If a true rule has stop-if-true, lower-priority rules do not apply to that cell.
4. Format-component merge behavior:
   - Applied formatting is component-sensitive (number/font/fill/border/etc.) and may combine across rules when not blocked.
5. Display projection:
   - Final displayed format is derived from base cell format + resolved conditional overlay.

## Interaction surfaces requiring explicit probes
1. Overlapping conditional rules with mixed stop-if-true settings.
2. Rules spanning table ranges that auto-expand or resize.
3. Rules interacting with dynamic-array spill ranges and blocked-spill transitions.
4. Merge/unmerge transitions affecting applies-to areas and visible priority outcomes.

## Uncertainty tags
1. Full conflict-resolution semantics across all format subcomponents remain partially undocumented.
2. Platform/channel-specific conditional-format edge behavior remains uncertain.
3. Rule-manager serialization behavior under repeated structural edits remains uncertain.

## Required empirical linkage
Use this scaffold as Track A input for:
- `ECS-EB-031` conditional-format overlap fixture generation,
- `ECS-EB-032` stop-if-true/priority transition probes,
- `ECS-EB-033` table/spill interaction probes,
- `ECS-EB-042` display-vs-value capture schema support.

## Status decision
Conditional-format precedence is now modeled as an explicit worksheet-visible scaffold with clear probe targets and uncertainty boundaries.
