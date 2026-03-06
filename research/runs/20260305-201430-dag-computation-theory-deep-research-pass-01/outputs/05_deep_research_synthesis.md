# Deep Research Synthesis: DAG Computation Theory for Spreadsheet Engines

## Executive synthesis
The strongest foundation for a spreadsheet-style DAG engine is not a single theory but a layered stack:
1. **Graph-theoretic skeleton** (topological order + SCC decomposition),
2. **Fixed-point semantics** for stabilization and cycle policy,
3. **Incremental maintenance discipline** (dirty/stale/necessary + dynamic dependency handling),
4. **Selective advanced incrementalization** (SAC/delta/differential) where cost justifies complexity.

This layered model aligns well with DNA Calc's existing architecture commitments (epochs, deterministic replay, profile-governed behavior) and gives clear proof/pack obligations.

## Core architecture implications

### 1) Separate semantic truth from scheduling mechanics
- Semantic truth: fixed-point or acyclic evaluation result definition.
- Scheduling mechanics: concrete algorithm (full rebuild, dynamic-topo, trace repair).

Why:
- Enables swapping runtime algorithms without semantic drift.
- Supports profile-based guarantees and deterministic mode.

### 2) Make invalidation state a formal object
Adopt explicit state model for each node/cell class:
- `clean`, `stale`, `necessary`, `recomputed` (names can vary).

Why:
- This is where most "hidden behavior" bugs occur.
- SAC and Incremental literature show this is key to tractable debugging and analyzability.

### 3) Treat dynamic dependencies as first-class
Dynamic references (INDIRECT-like, external lookups) should not be bolted onto static DAG assumptions.

Use explicit lanes:
- static dependencies (compile-time discoverable),
- dynamic dependencies (evaluation-time observed, tokenized/provenance tracked).

### 4) Reserve heavy math for high-leverage lanes
Not every part needs full differential/timely machinery.

Recommended:
- baseline: graph + invalidation + deterministic scheduling,
- advanced: delta/differential model for external streaming and high-update hotspots.

## Theoretical "best fit" shortlist

### A. Mandatory baseline theories
1. Topological ordering and SCC decomposition.
2. Fixed-point reasoning for cycle/iteration semantics.
3. Deterministic replay and dependency soundness invariants.

### B. High-value extension theories
1. Self-adjusting computation for dynamic incremental repair.
2. Dynamic cycle/topo maintenance for edit-heavy workloads.
3. Incremental lambda-calculus / change-theory for function-level optimization and formal proofs.

### C. Strategic future theories
1. Timely/Differential model for external update semantics.
2. Semiring provenance for explainability and algebraic trace reasoning.

## Risks if theory is ignored
1. Hidden non-determinism in parallel/invalidation handling.
2. Over-recompute and performance collapse under dynamic references.
3. Unprovable behavior drift between implementations.
4. Inability to explain conflicting outputs in conformance investigations.

## Recommended next execution sequence
1. Formalize minimal DAG state transition model and invariants (clean/stale/necessary/recomputed).
2. Add explicit conformance requirements for dynamic dependency token lifecycle.
3. Build empirical comparison pack: full rebuild vs dynamic-topo maintenance.
4. Add targeted SAC-inspired prototype for one dynamic dependency lane.
5. Reassess whether differential/timely model is required for external-stream-heavy profiles.

## Quality notes
- Source set is strong on primary papers/specs and implementation references.
- Some transfer conclusions are synthesis-level (inferred), not direct theorem statements.
- Best immediate value is to convert this into explicit requirement/proof-pack rows, not to over-generalize architecture prematurely.