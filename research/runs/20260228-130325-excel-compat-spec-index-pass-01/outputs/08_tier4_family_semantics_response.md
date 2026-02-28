# Prompt Pass 8 - Tier-4 Family Deep Semantics

## Scope
Tier-4 high-interest functions: 43 functions.

## Family breakdown
- dynamic_array_or_spill: 23
- functional_lambda_family: 9
- cube_context: 7
- external_data_or_services: 4

## Dynamic-array and spill family
Key semantics focus:
- Spill result-shape determination and blocked-spill conditions.
- Interaction with @ implicit intersection and # spilled-range references.
- Version/channel sensitivity for newer functions (GROUPBY, PIVOTBY, TRIMRANGE, etc.).
Representative functions:
- CHOOSECOLS, CHOOSEROWS, DROP, EXPAND, FILTER, GROUPBY, HSTACK, PIVOTBY, RANDARRAY, SEQUENCE, SORT, SORTBY, TAKE, TOCOL, TOROW, TRANSPOSE, TRIMRANGE, UNIQUE, VSTACK, WRAPCOLS, WRAPROWS, XLOOKUP, XMATCH

## Functional formula language family
Key semantics focus:
- Name binding and lexical scope in LET.
- User-defined formula behavior in LAMBDA and helper combinators.
- Array/lambda evaluation behavior as compatibility profile concerns.
Representative functions:
- BYCOL, BYROW, ISOMITTED, LAMBDA, LET, MAKEARRAY, MAP, REDUCE, SCAN

## CUBE family (included, deferred-depth)
Key semantics focus:
- Worksheet-visible contract for cube member/set/value retrieval.
- Connector/data-model dependency behavior and availability caveats.
- Explicitly out-of-scope: MDX language semantics and optimization internals.
Functions:
- CUBEKPIMEMBER, CUBEMEMBER, CUBEMEMBERPROPERTY, CUBERANKEDMEMBER, CUBESET, CUBESETCOUNT, CUBEVALUE

## External/live-data family
Key semantics focus:
- External feed updates (RTD in tier 5) and external data retrieval patterns (STOCKHISTORY, data-type field extraction).
- Recalc/update triggers and deterministic replay implications.
Functions:
- ENCODEURL, FILTERXML, STOCKHISTORY, WEBSERVICE

## Known unknowns
1. Exact edge-case coercion and error propagation for each tier-4 function under mixed-type array inputs.
2. Per-function platform rollout/build matrix at stable machine-readable granularity.
3. Formal test corpus needed for spill + structured reference + formatting interaction corners.