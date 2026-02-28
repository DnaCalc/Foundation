# Prompt Pass 1 - Landscape Coverage Map

## Executive Summary
- Canonical function inventory is available in two Microsoft Support indexes: alphabetical and category views.
- Formula language operator semantics are documented at user level (operators/precedence, @, #) and formal grammar level (MS-XLSX ABNF).
- Table/ListObject reference syntax and behavior are documented in support docs and formal grammar notes.
- Value-type behavior is split across function-level docs (TYPE/IS/N/VALUE/VALUETOTEXT) and linked-data-type docs; there is no single public "full value semantics" spec page.
- Formatting has strong public docs for number formats and custom format codes; conditional formatting is documented but lower formal detail for rule evaluation order/edge cases.
- Version status is scattered: function pages include "Applies To" and sometimes release-channel notes; Compatibility Versions introduces workbook-scoped behavior evolution.
- Volatile and performance-sensitive behavior has partial authoritative guidance in Excel recalculation/performance docs.

## Coverage Matrix (High-Level)
- Formula syntax/operators: covered (high confidence)
- Built-in function universe: covered via canonical index pages (high confidence)
- Function deep semantics edge cases: partial
- Sheet-visible value types: partial
- ListObject/Table semantics: partial-to-covered
- Cell formatting semantics: covered for number formats, partial for broader rendering model
- Conditional formatting semantics: partial
- Merge-cell behavior and interaction constraints: covered at user-behavior level
- Version/channel rollout tracking: partial

## Primary Source Priorities
1. Microsoft Support function indexes and operator docs.
2. Microsoft Learn Open Specifications (MS-XLSX formulas grammar and related records).
3. Microsoft Learn Excel recalculation/performance docs.
4. Microsoft Support compatibility/version pages.

## Blind Spots Identified
- No single official exhaustive "all function edge-case semantics" artifact.
- Incomplete official mapping from each function to volatility classification.
- Limited public formalization of value coercion matrix across all operator/function contexts.
- Conditional-format conflict/evaluation interactions are documented piecemeal rather than as one semantic spec.
- Feature rollout by channel can lag docs; availability remains environment-dependent.