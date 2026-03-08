# DNA Calc Transfer Matrix

## Immediate adoption candidates (high confidence)

| Theory/idea | DNA Calc lane | Action | Evidence | Confidence |
|---|---|---|---|---|
| Topo + SCC as explicit scheduling primitives | Core eval pipeline | Keep as normative scheduler baseline | DAG-023, DAG-024 | High |
| Fixed-point framing for cycle/iterative semantics | Cycle semantics + profile policy | Formalize `CycleError` vs `Iterative` as policy over fixed-point operators | DAG-020 | High |
| Dirty/stale/necessary state vocabulary | FEC/F3E + scheduler interaction | Introduce explicit invalidation-state model in conformance rows | DAG-007, DAG-028, DAG-029 | High |
| Build-system taxonomy for recompute policy choices | Operations/design doctrine | Use taxonomy language for policy docs and packs | DAG-005, DAG-006 | High |

## Near-term research/adoption candidates (medium confidence)

| Theory/idea | DNA Calc lane | Action | Evidence | Confidence |
|---|---|---|---|---|
| Dynamic topo/cycle maintenance | Structural rewrite-heavy workloads | Prototype for edit-intensive scenarios and compare against full rebuild | DAG-021, DAG-022 | Medium |
| SAC trace repair model | Function-heavy dynamic dependency lanes | Trial in selected subgraph classes (INDIRECT-like) | DAG-007, DAG-008, DAG-010 | Medium |
| Incremental lambda/delta transforms | Non-interesting function acceleration | Investigate codegen/verification lane for delta kernels | DAG-011, DAG-012 | Medium |

## Advanced/future candidates (lower immediate confidence)

| Theory/idea | DNA Calc lane | Action | Evidence | Confidence |
|---|---|---|---|---|
| Differential/timely full model integration | STREAM/RTD-heavy profiles | Consider as dedicated external-update engine lane | DAG-015, DAG-016, DAG-017 | Medium-Low |
| Semiring provenance | Explainability/formal trace layer | Pilot on limited dependency provenance features | DAG-026 | Low-Medium |

## Proposed proof obligations
1. Dependency soundness theorem:
   - recomputation trace respects dependency graph relation.
2. Deterministic replay theorem (profile-scoped):
   - identical op sequence yields observationally equivalent outputs.
3. Stabilization theorem:
   - recomputation reaches terminal stabilized state or explicit bounded failure state.
4. Dynamic-edge safety theorem:
   - graph rewrites preserve ordering invariants or isolate cycle regions deterministically.

## Proposed empirical packs (derived)
1. `PACK.dag.dynamic_topo_vs_rebuild`
2. `PACK.dag.dynamic_dependency_bind_semantics`
3. `PACK.dag.parallel_determinism_signature`
4. `PACK.dag.external_stream_progress_model`