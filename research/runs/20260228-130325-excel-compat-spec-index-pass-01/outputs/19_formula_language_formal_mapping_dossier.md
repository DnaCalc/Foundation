# Pass 19 - Formula Language Formal Mapping Dossier

## Purpose
Create a structured mapping between worksheet-visible Excel formula constructs and the strongest available public formal/behavioral anchors.

Primary backlog link:
- `ECS-BL-07` in `17_follow_up_execution_backlog.md`

## Mapping model
Anchor classes used in this dossier:
- `authoritative_formal`: open-spec grammar/record constraints.
- `authoritative_behavioral`: Microsoft support/learn behavioral docs.
- `provisional_inference`: inferred grammar/behavior not fully formalized in public specs.

## Construct mapping table
| Construct family | Example shape | Anchor class | Primary source IDs | Current confidence | Track B probe link |
|---|---|---|---|---|---|
| Arithmetic/comparison/text operators | `=1+2`, `=A1>B1`, `=A1&"x"` | authoritative_behavioral | `ECS-003` | high | `ECS-EB-028` |
| Reference operators (range/union/intersection) | `A1:B3`, `A1,B1`, `A1 A2:B2` | authoritative_behavioral + authoritative_formal | `ECS-003`, `ECS-008` | high | `ECS-EB-028`, `ECS-EB-030` |
| Implicit intersection operator | `@A1:A10` | authoritative_behavioral | `ECS-004`, `ECS-007` | high | `ECS-EB-028`, `ECS-EB-029` |
| Spilled range operator | `A1#` | authoritative_behavioral | `ECS-005`, `ECS-006` | high | `ECS-EB-028`, `ECS-EB-029` |
| A1/R1C1 base addressing | `A1`, `R1C1` | authoritative_formal | `ECS-008`, `ECS-009` | high | `ECS-EB-028` |
| Names and scoped names | `MyName`, `Sheet1!MyName` | authoritative_behavioral + authoritative_formal | `ECS-010`, `ECS-011`, `ECS-008` | medium_high | `ECS-EB-030` |
| External/workbook refs | `[Book2.xlsx]Sheet1!A1` | authoritative_formal + authoritative_behavioral | `ECS-008`, `ECS-009` | medium | `ECS-EB-030` |
| Structured table references | `Table1[Col]`, `Table1[@Col]` | authoritative_behavioral + authoritative_formal | `ECS-012`, `ECS-008` | high | `ECS-EB-028`, `ECS-EB-030`, `ECS-EB-034` |
| Dynamic-array producers and spill semantics | `SEQUENCE(...)`, `FILTER(...)` | authoritative_behavioral | `ECS-006`, `ECS-007` | medium_high | `ECS-EB-028`, `ECS-EB-029` |
| LAMBDA/LET/helper formula forms | `LET(...)`, `LAMBDA(...)`, `MAP(...)` | authoritative_behavioral + provisional_inference | `ECS-041`..`ECS-048`, `ECS-008` | medium | `ECS-EB-028`, `ECS-EB-030` |
| Data-type field access syntax | `=A1.Field`, `FIELDVALUE(A1,"Field")` | authoritative_behavioral + provisional_inference | `ECS-024`, `ECS-025` | medium | `ECS-EB-028`, `ECS-EB-030` |

## Explicit uncertainty tags
1. Public ABNF anchor (`ECS-008`) is strong for baseline formula grammar but does not fully encode all modern behavioral semantics.
2. LAMBDA/helper family syntax and edge acceptance boundaries remain partially behavioral-doc anchored.
3. Some context-sensitive parse behaviors still require empirical acceptance/rejection corpora.

## Parsing and normalization expectations
1. Distinguish `entered formula text` from `stored/normalized formula text`.
2. Capture explicit accepted/rejected syntax outcomes.
3. Record formula-bar normalization deltas for ambiguous constructs.

## Required empirical linkage
Use this dossier as input contract for:
- `ECS-EB-028` parse-acceptance corpus generation,
- `ECS-EB-029` formula normalization capture,
- `ECS-EB-030` grammar ambiguity discriminator probes.

Corpus registry anchor (added in pass 25):
- `formula_parse_corpus_registry.csv`

## Status decision
This dossier provides the Track A formal mapping baseline for modern worksheet formula syntax. Remaining ambiguity is explicitly tagged and routed to Track B probe tasks.
