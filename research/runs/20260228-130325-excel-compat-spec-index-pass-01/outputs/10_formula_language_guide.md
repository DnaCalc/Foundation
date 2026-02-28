# Pass 10 - Formula Language Guide (Worksheet Engine Scope)

## Core syntax areas covered
1. Arithmetic, comparison, text, and reference operators with precedence.
2. Reference operators and forms:
   - range (`:`), union (`,`), intersection (space),
   - implicit intersection (`@`), spilled-range (`#`),
   - A1 and R1C1 addressing,
   - names and scoped name resolution,
   - external/workbook references,
   - structured references for tables.
3. Dynamic-array era semantics:
   - spill behavior and blocked spill,
   - migration interactions between legacy implicit intersection and explicit `@`.

## Formal/near-formal anchors
- MS-XLSX formula ABNF grammar is the formal anchor for parser-level structure.
- User-facing operator and dynamic-array docs are behavioral anchors.

## Compatibility focus points
- Parsing correctness must include structured-reference grammar and special reference operators.
- Evaluation-level compatibility must account for `@` and `#` behaviors plus spill blocking.
- Structural edits and table growth must preserve reference semantics.

## Known unknowns
- Full grammar-level mapping from every modern function/lambda construct to a stable public formal grammar artifact.
- Complete public formalization of all coercion/evaluation edge cases across operator contexts.