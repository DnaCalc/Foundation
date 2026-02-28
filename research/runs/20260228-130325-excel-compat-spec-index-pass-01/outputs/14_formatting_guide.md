# Pass 14 - Formatting Semantics Guide

## Coverage
- Cell number-format behavior and custom format code guidance (high priority).
- Conditional formatting user-level model and Open XML schema references (medium priority).
- Merge/unmerge behavior and operational constraints.
- Excel limits relevant to format/structure compatibility.

## Priority posture
1. Number format semantics and code behavior.
2. Merge-cell interactions with formula/spill workflows.
3. Conditional formatting rule interactions and overlaps.

## Known unknowns
- Full precedence/conflict semantics for overlapping conditional formatting rules at deep formal level.
- Exhaustive mapping of formatting interactions with dynamic-array spill and table expansion.

## Pass-32 empirical update
Wave-1 conditional-format probes for `ECS-EB-031/032/033` are now executed under:
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/`

Key observed signal:
1. Overlap and stop-if-true precedence behavior is now empirically anchored for baseline fixture cases.
2. Spill-interaction behavior remains partially unresolved; spill-target color expectations (`C3/C4`) did not match seeded assumptions and remain explicit follow-up items.
