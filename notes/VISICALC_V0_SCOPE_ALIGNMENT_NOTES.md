# VISICALC_V0_SCOPE_ALIGNMENT_NOTES.md

## 1. Purpose
This note retains material from the DnaVisiCalc guidance set used during Foundation alignment:
- `..\\DnaVisiCalc\\docs\\GAP_ANALYSIS.md`
- `..\\DnaVisiCalc\\docs\\FOUNDATION_REQUIREMENTS_MAPPING.md`
- `..\\DnaVisiCalc\\docs\\FOUNDATION_PROPOSALS.md`

These docs can be archived after synthesis because their valuable guidance is either promoted into Foundation source-of-truth docs or retained here as explicit deferred backlog.

## 2. Authoritative v0 Functional Scope Anchor
For pathfinder functional behavior, the authority set is:
- `..\\DnaVisiCalc\\docs\\SPEC_v0.md`
- `..\\DnaVisiCalc\\docs\\ENGINE_REQUIREMENTS.md`
- `..\\DnaVisiCalc\\docs\\ENGINE_API.md`

## 3. Promoted Outcomes (Now in Foundation Core Docs)
- Concrete CalcDelta/change-entry shape and drain-style delivery contract.
- Unified `NodeId` dependency identity (cell/name/chart) and dirty-closure baseline model.
- Clear split between volatile invalidation and externally-invalidated pathways.
- Three-category volatility classification (`Standard`, `Volatile`, `ExternallyInvalidated`).
- Controls/charts as engine entities with explicit operation-model lifecycle.
- Round-exit track decomposition and explicit pathfinder feedback loop process.
- Explicit Round 0 functional-scope authority mapping in Foundation docs.

## 4. Retained Deferred Expansion Backlog (From Gap Analysis)
The following are intentionally not required by pathfinder-v0 functional scope:
- full number-format code language behavior,
- full date/time serial compatibility system,
- comprehensive coercion-matrix parity,
- implicit intersection (`@`) compatibility breadth,
- multi-sheet/workbook reference semantics,
- broader lambda helper coverage (for example `REDUCE`, `SCAN`, `BYROW`, `BYCOL`, `MAKEARRAY`).

These items remain candidate scope for post-freeze v0+ work and Round 1 planning.

## 5. Process Retention
- `FOUNDATION_REQUIREMENTS_MAPPING.md` confirmed doctrine-level alignment and reinforced clean-room, determinism-first, and layered-boundary consistency.
- `FOUNDATION_PROPOSALS.md` remains the pattern example for implementation-feedback upstreaming via synthesis (`accept`/`adapt`/`defer`/`reject`) instead of direct doctrine edits.
