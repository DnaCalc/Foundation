# Pass 11 - Built-in Function Catalog Guide

## Catalog status
- Full deduplicated worksheet function catalog extracted: 500 functions.
- Interest triage model applied: 5 tiers.
- Interesting set (tiers 3-5): 71 functions.

## Tier model
- Tier 5: critical-interest.
- Tier 4: high-interest.
- Tier 3: medium-interest.
- Tier 2: baseline-context.
- Tier 1: regular-pure-or-low-risk.

## Explicitly highlighted interesting families
- Volatile/recalc-sensitive functions.
- Dynamic-array and spill-shape functions.
- Functional formula language family (LET/LAMBDA/helper combinators).
- Grid/reference-shape sensitive functions.
- External/live-data functions.
- CUBE family (`CUBEKPIMEMBER`, `CUBEMEMBER`, `CUBEMEMBERPROPERTY`, `CUBERANKEDMEMBER`, `CUBESET`, `CUBESETCOUNT`, `CUBEVALUE`) included as interesting with deferred-depth semantics.

## Out-of-scope note
- CUBE/OLAP MDX language internals are out-of-scope; worksheet-visible behavior and compatibility context are in-scope.

## Artifacts
- `function_catalog_full.csv`
- `function_tier_summary.csv`
- `function_interest_index.csv`