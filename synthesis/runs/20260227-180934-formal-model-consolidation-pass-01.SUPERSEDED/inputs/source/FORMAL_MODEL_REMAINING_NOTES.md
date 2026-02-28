# FORMAL_MODEL_REMAINING_NOTES.md - Deferred and unused formal-model ideas

## 1. Purpose
This file retains formal-model ideas captured during synthesis run `20260225-222801-formal-model-pass-01` that were not promoted to doctrine-level architecture requirements in this pass.

## 2. Why these items were deferred
Most deferred items are implementation-strategy choices, optimization decisions, or value-semantics details that depend on early prototype measurements and profile decisions.

## 3. Deferred representation choices (no decision yet)
- Persistent tile DAG vs axis-map sparse store vs patch-stack grid vs region-algebra representation.
- Whether one representation should serve both evaluator locality and viewport locality, or whether dual caches are required.
- Compaction ownership: snapshot core vs operations pipeline.
- Temporary non-canonical forms (patch/region) allowed before normalization.

## 4. Deferred semantic details
- Final value-type algebra (scalar, arrays, coercions, error lattice) and exact lifting rules.
- Precise semantics for volatile and impure functions in dependency discovery.
- Dynamic-reference policy details for `INDIRECT`/`GET.*` style constructs (minimal discovered set vs conservative full-scope dependency).
- Spill-range interior-cell identity and rewrite semantics under overlapping structural edits.
- Iterative cycle convergence policy details (tolerance, rounding policy, and profile-specific defaults).

## 5. Deferred ID and addressing decisions
- `RowId`/`ColId` scope policy (sheet-local + epoch namespacing vs globally unique IDs).
- Canonical text-address policy (`A1` + `R1C1`) in traces and diagnostics when both are available.

## 6. Deferred OpLog design choices
- Operation granularity for high-volume edits (single op per cell vs batched range ops).
- OpLog compaction and snapshotting policy (when/how history is folded without losing replay guarantees).
- Explicit strategy for conflict handling if future collaboration evolves beyond server-sequenced log mode.

## 7. Deferred research/implementation probes
- Roslyn-inspired hybrid prototype benchmark matrix against alternative persistence candidates.
- Comparative study: Jane Street `Incremental` invariants vs Salsa-style demand invalidation under spreadsheet workloads.
- Tooling posture for OxCaml in Green track (observe-only vs experimental branch).
- Independent-review alternative to run single-engine/no-OCaml in early rounds; requires explicit charter/operations decision before any adoption.

## 8. Promotion criteria for next pass
Promote an item from this file only when all are true:
- A profile decision requires normative semantics now.
- A pack gate needs the item to avoid ambiguity.
- The item can be expressed with deterministic artifacts and tests.
- The item does not conflict with `CHARTER.md` doctrine constraints.
