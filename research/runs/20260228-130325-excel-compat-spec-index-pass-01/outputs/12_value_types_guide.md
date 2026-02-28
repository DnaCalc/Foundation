# Pass 12 - Value Types and Coercion Guide

## Scope covered
- Sheet-visible value typing and detection signals (`TYPE`, `IS*` family).
- Conversion/coercion anchors (`N`, `VALUE`, `VALUETOTEXT`).
- Date serial model linkage (`1900` and `1904` systems).
- Compound/linked data type visibility.

## Coercion artifacts
- Seed matrix: `coercion_matrix_seed.csv`.
- Expanded matrix: `coercion_matrix_expanded.csv`.

## Confidence model
- High confidence rows: directly documented in Microsoft docs.
- Medium confidence rows: strong inferred behavior from adjacent official docs.
- Low confidence rows: explicitly unresolved and marked for empirical/probe follow-up.

## High-priority unresolved areas
1. Locale-sensitive numeric/text coercion matrix completeness.
2. Mixed-type dynamic-array lifting behavior across broad function/operator contexts.
3. Cross-function coercion precedence interactions under compatibility versions.