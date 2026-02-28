# Prompt Pass 2 - Function Inventory and Interesting-Function Classification

## Canonical inventory anchors
- `Excel functions (alphabetical)` and `Excel functions (by category)` are the canonical public index anchors.
- Category page includes version markers (for example `2021`, `2024`, `Microsoft 365`) that are useful for compatibility profiling.

## Classification framework
- `Regular`: pure/stateless numeric-text-logical transforms with no grid-shape, volatility, external source, or spill semantics sensitivity.
- `Interesting`: one or more of:
  - Volatile or recalculation-sensitive.
  - Grid/reference-shape sensitive (range construction, indirection, implicit intersection interaction).
  - Dynamic-array producer or spill-behavior sensitive.
  - Functional meta-formula constructs (LET/LAMBDA and helper family).
  - External/live-data integration (RTD, linked-data-type extraction, STOCKHISTORY).
  - Formatting-visible side effects or format-sensitive behavior.

## Initial interesting-function candidate groups
1. Volatile/perf-sensitive: NOW, TODAY, RANDBETWEEN, OFFSET, INDIRECT, INFO(*), CELL(*), SUMIF(*)
2. Dynamic-array and spill-sensitive: FILTER, SORT, SORTBY, UNIQUE, RANDARRAY, TAKE, DROP, CHOOSECOLS, CHOOSEROWS, EXPAND, TOCOL, TOROW, WRAPROWS, WRAPCOLS, VSTACK, HSTACK, TRANSPOSE, GROUPBY, PIVOTBY, TRIMRANGE
3. Functional/LAMBDA family: LET, LAMBDA, MAP, BYROW, BYCOL, REDUCE, SCAN, MAKEARRAY, ISOMITTED
4. Reference/grid structure-sensitive: INDIRECT, OFFSET, INDEX (range-returning contexts), ROW, COLUMN, AREAS, FORMULATEXT, ADDRESS, CELL, INFO
5. External/data-type aware: RTD, FIELDVALUE, STOCKHISTORY
6. Format-visible behavior: NOW/TODAY general-format behavior, TEXT, DOLLAR, VALUETOTEXT

## Caveats
- "Interesting" is a compatibility-risk heuristic, not a correctness judgment.
- Some functions become interesting only under specific argument patterns (for example CELL/INFO/SUMIF volatility notes).

## Known unknowns from pass 2
- Need machine-readable extraction of all built-ins from canonical index into tracked catalog.
- Need per-function "interesting reason codes" with authoritative evidence links.
- Need explicit coverage for each new M365-only function and channel rollout status.