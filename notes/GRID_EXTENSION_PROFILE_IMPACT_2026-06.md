# Grid Extension Profile Impact Note — June 2026

Status: Impact note only. Canonical technical truth remains in OxCalc, OxFml, and OxDoc until those lane docs stabilize enough for mirror sync or doctrine promotion.

## Candidate profile/conformance impacts

- `strict-excel-grid` becomes the grid-profile name used by OxCalc planning for bounded sheets, A1/R1C1 cell references, grid-overlay tables, dynamic-array spill, and hidden-row-sensitive calculation.
- OxCalc owns the active grid semantic specs: `CORE_ENGINE_GRID_MODEL`, `CORE_ENGINE_GRID_REFINEMENT_AND_EQUIVALENCE`, `CORE_ENGINE_GRID_REFERENCE_MACHINE`, and `CORE_ENGINE_GRID_PERF_REGISTER`.
- OxFml owns the formula-language intake for `BindProfile`, symbolic relative references, R1C1-relative formula identity, A1 `$` fidelity, grid bounds, and translation/rebind APIs.
- OxDoc owns `.xlsx` read/write, `oxdoc-model`, document-event streams, fidelity ledgers, opaque preservation, and geometry-coupled opaque classification.
- OxXlPlay/OxReplay remain the Excel observation and comparison/verdict lanes.

## Evidence and pack implications

- GridCalc-Ref is the planned executable reference machine for grid semantic refinement.
- COM evidence gates are required before provisional spill and hidden-row claims stabilize.
- Performance readiness uses deterministic counters from the OxCalc grid perf register, not wall-clock gates.
- OxDoc boundary conformance requires golden event transcripts, load-save-load fixpoints, and opens-without-repair COM checks.

## Pivot-table disposition

Pivot-table semantics are not v1 calculation semantics. They are not harmless opaque bytes either: pivot definitions, caches, and report locations carry sheet-geometry anchors. Until modeled, structural edits that may stale those anchors must either rewrite the geometry-coupled refs or emit declared-lossy ledger entries and host-visible warnings. Silent stale pivots are out of bounds.

## Mirror sync path

Do not mirror the new detailed grid specs into Foundation yet. Revisit after:

1. OxCalc W061 has a reviewed grid reference floor;
2. OxFml W077 has acknowledged the public bind/profile shape;
3. OxDoc has a checked workspace skeleton and founding requirements indexed;
4. the first COM capture packets for spill and hidden rows exist or have explicit blockers.