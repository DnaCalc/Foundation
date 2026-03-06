# Algorithm Family Map

## 1. Dependency Graph Construction and Maintenance

| Family | Core operation | Typical complexity signal | Strengths | Risks | Sources |
|---|---|---|---|---|---|
| Full rebuild topo/SCC | rebuild order/SCC from scratch | `O(|V|+|E|)` per rebuild | Simple, robust, easy to reason | Expensive under frequent edits | DAG-023, DAG-024 |
| Dynamic topo/cycle maintenance | local repair after edge updates | sublinear/nearlinear amortized in many regimes | Better edit responsiveness | More complex invariants/data structures | DAG-021, DAG-022 |

## 2. Invalidation and Recomputation

| Family | Core operation | Strengths | Risks | Sources |
|---|---|---|---|---|
| Dirty-closure propagation | mark dependents dirty, recompute in topo order | Implementation simplicity, clear semantics | Over-recompute under dynamic dependencies | DAG-001, DAG-024 |
| Self-adjusting trace repair | propagate changes over execution trace | Fine-grained recompute minimization | Trace/state complexity | DAG-007, DAG-008, DAG-010 |
| Demand-driven + memo | recompute only on observed demand | Efficient for partial observation/viewports | Complexity in consistency guarantees | DAG-010, DAG-028 |

## 3. Dynamic Dependency Semantics

| Family | Core operation | Strengths | Risks | Sources |
|---|---|---|---|---|
| `bind`-style dynamic graph update | dependency edges change as values change | Natural model for INDIRECT-like behavior | Requires scoped invalidation rules | DAG-028, DAG-029 |
| Delta-program transformation | compute output change from input change | Formal correctness path | Harder to engineer end-to-end for rich host semantics | DAG-011, DAG-012 |

## 4. Streaming / External Updates

| Family | Core operation | Strengths | Risks | Sources |
|---|---|---|---|---|
| Epoch-tagged external ops | push external updates into op log | Deterministic replay straightforward | Coarser granularity | DAG-001 |
| Timely/differential timestamped deltas | progress-aware delta propagation | Rich support for iterative streaming computations | Higher conceptual/runtime complexity | DAG-015, DAG-016, DAG-017 |

## 5. Parallel Scheduling

| Family | Core operation | Strengths | Risks | Sources |
|---|---|---|---|---|
| Fixed deterministic worker scheduling | reproducible execution order | Strong debugging/conformance | Lower throughput potential | DAG-001 |
| Work stealing over DAG tasks | adaptive parallel throughput | Good asymptotic bounds | Determinism challenges without additional constraints | DAG-025 |

## 6. Provenance / Explainability

| Family | Core operation | Strengths | Risks | Sources |
|---|---|---|---|---|
| Edge/path provenance metadata | keep explicit lineage for deps | Practical and direct | Metadata volume | DAG-001, DAG-026 |
| Semiring provenance | algebraic provenance composition | Strong formal explainability basis | Integration complexity | DAG-026 |

## Recommended staged algorithm stack
1. Baseline now:
   - Dirty-closure + full topo/SCC rebuild per structural wave, with explicit epoch tags.
2. Next step:
   - Dynamic-topo/cycle maintenance for high-edit workloads.
3. Advanced step:
   - Selective SAC/delta-based lanes for expensive function clusters and dynamic refs.
4. Streaming step:
   - Timely/differential-inspired progress model for external update lanes where required.