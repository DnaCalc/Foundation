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

## Pass-32 empirical update
Wave-1 empirical outputs for `ECS-EB-031/032/033` are now linked at:
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-032_cf_stopiftrue_probe_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/WAVE1_EXECUTION_REPORT.md`

Wave highlights:
1. Overlap + stop-if-true baseline rows matched expected rendered fill-color outcomes (`ECS-EB-031`).
2. Priority transition scenario captured stepwise color transitions on the same target after stop-if-true and priority edits (`ECS-EB-032`).
3. Spill-related conditional-format expectations mismatched for `C3/C4` in the table+spill scenario (`ECS-EB-033`), and are now explicit follow-up triage items.
