# Pass 23 - ExcelFinancialFunctions Watch Note

## Resource
- Source ID: `ECS-061`
- Repository: `https://github.com/fsprojects/ExcelFinancialFunctions`
- Why tracked: high-value public implementation reference for Excel financial functions, plus a notable test-suite approach.

## Investigation objectives
1. Implementation semantics:
   - identify which financial functions are implemented,
   - determine explicit behavior choices for edge cases and rounding/coercion behavior,
   - identify documented compatibility assumptions vs Excel behavior.
2. Testing approach:
   - extract test structure patterns and fixture strategies,
   - identify how expected values are established and validated,
   - identify reusable patterns for DNA Calc empirical and conformance packs.

## Usage posture
1. Treat as an external implementation reference, not as authoritative Excel specification.
2. Use it to generate hypotheses, test ideas, and edge-case candidate sets.
3. Confirm any compatibility claims with public Microsoft sources and/or reproducible Excel probes.

## Backlog linkage
Relevant follow-up items:
- `ECS-BL-02` (full per-function edge-case semantics matrix)
- `ECS-BL-05` (tier-4 and tier-3 interesting-function deep semantics)
- `ECS-BL-11` (classification evidence hardening)

Empirical linkage:
- `ECS-EB-005`, `ECS-EB-006`, `ECS-EB-007`, `ECS-EB-009`
- `ECS-EB-040`, `ECS-EB-041`

## Status
Added as a prominent listed resource and explicit investigation target in this run.
