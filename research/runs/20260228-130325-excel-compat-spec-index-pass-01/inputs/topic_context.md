# Topic Context: Excel Compatibility Specification Index

## Goal
Build a complete index of what a fully Excel-compatible spreadsheet engine should support for post-Excel-2007 scope, prioritizing exhaustive topic coverage and authoritative source mapping over immediate full-detail extraction.

## In-scope domains
1. Formula language syntax and evaluation semantics at sheet/function level (not full calc engine architecture).
2. Full built-in function inventory and function-level behavior references.
3. Sheet-visible/name-visible value types and coercion/observation behavior.
4. ListObject/Table semantics: structured references, growth/auto-expand behavior, interactions with formulas.
5. Cell formatting and number format behavior (higher priority), conditional formatting (lower depth), merges included.

## Out-of-scope domains
- Power Query / M language.
- DAX / Power BI formula language.
- Pre-Excel-2007 historical behaviors unless directly needed for current compatibility context.

## Version posture
- Prefer current Microsoft 365 and current perpetual Office behavior.
- Include preview/new features when public and document status.
- Track release/version notes and unknowns.

## Function-interest lens
Classify each built-in function as at least:
- regular
- interesting (volatile, reference-structure sensitive, dynamic-array generator, LET/LAMBDA functional family, RTD-like or side-effect-ish formatting interactions, etc.)

## Deliverable posture
- Comprehensive source map and topic index first.
- Explicit known-and-documented-unknowns second.
- Drill-down detail can be deferred to follow-up runs.