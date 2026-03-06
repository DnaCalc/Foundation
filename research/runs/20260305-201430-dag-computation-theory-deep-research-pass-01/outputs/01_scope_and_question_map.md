# Scope and Question Map

## Research question
What mathematics, theory, and algorithm families provide the strongest foundation for a spreadsheet-like DAG computation engine with deterministic incremental recomputation, dynamic dependency edits, and formal verification potential?

## Sub-questions
1. What is the right formal model of recomputation: fixed-point, self-adjusting semantics, or differential dataflow style?
2. Which dynamic graph algorithms are practical for dependency updates (row/column edits, formula rewrites)?
3. How should invalidation and stabilization be specified so deterministic replay and conformance proofs are tractable?
4. Which algebraic tools (deltas, semirings, monotonicity) help avoid ad-hoc behavior rules?
5. Which proven runtime designs are transferable now versus later?

## Output framing
- Theory catalog (`02_*`): claims, theorem hooks, and evidence strength.
- Algorithm map (`03_*`): update model, complexity signal, engineering fit.
- Transfer matrix (`04_*`): immediate adoption vs research-lane.
- Synthesis (`05_*`): recommended architecture principles and proof obligations.

## Evidence policy
- Source-first; prioritize papers/spec docs/repos.
- Mark claims as:
  - `direct`: explicitly stated in source,
  - `inferred`: synthesis from multiple direct signals.