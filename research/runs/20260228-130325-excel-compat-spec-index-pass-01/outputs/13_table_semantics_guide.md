# Pass 13 - ListObject/Table Semantics Guide

## Covered areas
- Structured reference syntax and usage patterns.
- Calculated-column behavior.
- Auto-expand/auto-fill behavior.
- Linkage to worksheet formula semantics and reference rewriting concerns.

## Included context
- Table formulas as part of core worksheet semantics, not merely UI sugar.
- Structured references treated as first-class formula language elements.

## Important compatibility notes
- Table growth and formula propagation can alter dependency and reference surfaces.
- Interactions with dynamic arrays/spill outputs should be explicitly tested.

## Known unknowns
- Full formal interaction matrix: structured references + spill behavior + coercion + formatting.
- Precise behavior differences across platform/channel for table auto-behavior edge cases.