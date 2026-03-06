# Theory and Math Catalog for DAG Computation

This catalog focuses on theories that can become explicit engine invariants, proof obligations, or algorithm-selection constraints.

## 1. Order-Theoretic Fixed-Point Foundations
Primary sources: `DAG-020`, `DAG-001`.

### Core idea
Many recalculation systems can be modeled as finding a stable point of an update operator `F` over a partially ordered state space.

### Math frame
- Domain: `(L, <=)` complete lattice.
- Update operator: `F: L -> L` monotone.
- Tarski: fixed points exist; least fixed point `lfp(F)` exists.

### Why it matters
1. Gives formal language for "stabilized epoch" and convergence policies.
2. Lets iterative/cyclic behavior be specified as explicit fixed-point search with bounded/guarded policies.
3. Separates semantic question (what is the stable result) from operational question (how we schedule recomputation).

### DNA Calc transfer
- Strong for cycle-mode semantics (`CycleError` vs `Iterative`) and proof obligations around stabilization.

Evidence strength: `direct`.

## 2. Static DAG Semantics and Classical Graph Foundations
Primary sources: `DAG-023`, `DAG-024`, `DAG-001`.

### Core idea
For acyclic dependency graphs, topological order gives a deterministic linearization of evaluation.

### Math frame
- Directed graph `G=(V,E)`.
- Acyclicity implies existence of topo order `tau` such that `(u,v) in E => tau(u) < tau(v)`.
- SCC decomposition partitions cyclic regions for explicit cycle policy.

### Why it matters
1. Baseline deterministic execution for non-cyclic regions.
2. Foundation for SCC-isolated iterative semantics.
3. Gives explicit correctness condition for dependency maintenance after edits.

Evidence strength: `direct`.

## 3. Dynamic Graph Algorithms (Incremental Cycle/Topo Maintenance)
Primary sources: `DAG-021`, `DAG-022`.

### Core idea
Dependency graphs are edited continuously; recomputing full topo/SCC from scratch is often avoidable.

### Math frame
- Online edge insert/delete with maintenance of:
  - cycle detection status,
  - valid topological labeling/order (if acyclic).
- Data structures maintain order labels and local repairs.

### Why it matters
1. Directly maps to row/column insertions and formula reference rewrites.
2. Enables stronger complexity guarantees for edit-heavy workloads.
3. Supports deterministic local repair over global rebuild.

Evidence strength: `direct` on algorithms, `inferred` on direct spreadsheet mapping.

## 4. Self-Adjusting Computation (SAC)
Primary sources: `DAG-007`, `DAG-008`, `DAG-009`, `DAG-010`, `DAG-028`, `DAG-029`.

### Core idea
Represent computation as an execution/dependency trace; when inputs change, propagate only required repairs.

### Math frame
- Trace consistency semantics.
- Incremental cost semantics (update cost bounded by affected trace region + overhead).
- Demand-driven adaptation via memoized thunks plus change propagation.

### Why it matters
1. Closest conceptual match to spreadsheet recalculation under frequent local edits.
2. Gives language for `necessary`, `stale`, and scoped invalidation.
3. Supplies analyzable runtime state for debugging and conformance checks.

### Key design implications
1. Invalidation is first-class state, not side effect.
2. Equality/cutoff policy is semantic control knob for churn.
3. Dynamic dependency edges (INDIRECT-like patterns) must be explicit and auditable.

Evidence strength: `direct` for SAC, `inferred` for spreadsheet-specific policy adaptation.

## 5. Incremental Lambda-Calculus / Derivative-of-Programs View
Primary sources: `DAG-011`, `DAG-012`.

### Core idea
Compute output changes from input changes via program derivatives (delta semantics), not full reevaluation.

### Math frame
- Change structures `Delta A` per type `A`.
- Derivative transform `D[f]: A x Delta A -> Delta B` for `f: A->B`.

### Why it matters
1. Strong formal pathway for proving correctness of incrementalization.
2. Useful for function-level optimization and symbolic change propagation.
3. Provides principled framework for mixed static/dynamic incremental lanes.

Evidence strength: `direct`.

## 6. Differential Dataflow / Timely Dataflow
Primary sources: `DAG-015`, `DAG-016`, `DAG-017`, `DAG-018`, `DAG-019`, `DAG-027`.

### Core idea
Represent updates as differences over partially ordered timestamps and propagate deltas through dataflow operators.

### Math frame
- Collections over `(data, time, diff)` tuples.
- Partially ordered time domains and frontier/progress tracking.
- Differential accumulation and compaction.

### Why it matters
1. Excellent for streaming/external update semantics (RTD/STREAM-like lanes).
2. Gives rigorous treatment of iterative computations and progress tracking.
3. Helps separate causal ordering from wall-clock order.

Evidence strength: `direct` for model, `inferred` for spreadsheet host adaptation.

## 7. Incremental View Maintenance (IVM) and Higher-Order Deltas
Primary sources: `DAG-013`, `DAG-014`.

### Core idea
Maintain derived query/view results under base updates using delta programs.

### Math frame
- First-order and higher-order delta rules.
- Materialized auxiliary state for fast updates.

### Why it matters
1. Useful analogy for maintaining dependency-derived artifacts (calc chains, affected regions, summary indexes).
2. Suggests systematic decomposition of "what to recompute" into maintainable deltas.

Evidence strength: `direct`.

## 8. Parallel DAG Scheduling (Work Stealing)
Primary sources: `DAG-025`.

### Core idea
DAG tasks can be parallelized with provable bounds under work-stealing schedulers.

### Math frame
- Runtime bound approximately `T1/P + O(T_infty)` for work `T1`, span `T_infty`, processors `P`.

### Why it matters
1. Gives principled ceiling/floor for parallel speedup claims.
2. Helps define deterministic-vs-parallel mode boundaries.
3. Encourages explicit critical-path instrumentation.

Evidence strength: `direct`.

## 9. Algebraic Provenance and Semirings
Primary sources: `DAG-026`.

### Core idea
Represent derivations with semiring annotations; combine and trace contribution algebraically.

### Math frame
- Semiring `(K, +, *, 0, 1)` annotations on derivations.
- Provenance composition through operators.

### Why it matters
1. Potentially powerful for explainability and dependency provenance in recalc traces.
2. Provides algebraic backbone for traceability beyond ad-hoc metadata.

Evidence strength: `direct` for databases; `inferred` for spreadsheet adaptation.

## 10. Build-System Theory as a Spreadsheet Analogue
Primary sources: `DAG-005`, `DAG-006`.

### Core idea
Build systems formalize dependency invalidation, scheduling, and reproducibility tradeoffs under changing inputs.

### Why it matters
1. Spreadsheet recalculation is a sibling problem: change detection + dependency closure + recompute policy.
2. "Build systems à la carte" gives a taxonomy to reason about design choices explicitly.

Evidence strength: `direct` for taxonomy, `inferred` for spreadsheet projection.

## High-Value Cross-Cutting Invariants
1. Dependency soundness:
   - if `u` influences `v`, dependency metadata must include path evidence.
2. Recompute minimality (policy-bounded):
   - only stale/necessary nodes recompute under selected policy.
3. Deterministic replay:
   - given same input ops and profile, result trace is observationally equivalent.
4. Progress/stabilization:
   - each recompute epoch reaches terminal state (or explicit bounded non-convergence diagnosis).
5. Dynamic edit safety:
   - graph edits preserve validity invariants (acyclic labels or explicit cycle state).

## Uncertainty Register (this pass)
1. Exact practical break-even between dynamic-topo maintenance and full rebuild in spreadsheet-shaped workloads.
2. How much SAC trace machinery is worth carrying in a Rust-first implementation versus simpler dirty-set models.
3. Best formal coupling between epoch model and differential/timely timestamp model for external streams.