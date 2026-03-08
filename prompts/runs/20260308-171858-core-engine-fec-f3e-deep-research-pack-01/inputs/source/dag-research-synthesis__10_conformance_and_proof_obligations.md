# Conformance and Proof Obligations (Promoted Set)

## Scope
This artifact converts reconciled DAG-theory findings into concrete candidate obligations for Green formalization and conformance-pack binding.

## Proof obligations

| Obligation ID | Statement (candidate theorem/property) | Assumptions/profile bounds | Source anchors | Candidate pack binding |
|---|---|---|---|---|
| DAG-PO-001 | Acyclic from-scratch equivalence: incremental recompute equals full recompute on acyclic dependency graphs | Static dependencies resolved; canonical schedule defined | DAG-001, DAG-002, DAG-003, DAG-024 | PACK.visicalc.core; PACK.lean.ocaml.alignment.core |
| DAG-PO-002 | Deterministic replay: identical ordered op stream yields identical observable values/errors | Deterministic operator semantics and stable tie-break policy | DAG-001, DAG-005, DAG-006 | PACK.concurrent.epochs; PACK.dag.parallel_determinism_signature |
| DAG-PO-003 | SCC partition correctness: SCC decomposition is sound/complete for cycle region isolation | Graph extracted from current snapshot/reference layer | DAG-023, DAG-024 | PACK.visicalc.core; PACK.dag.cycle_iterative_semantics |
| DAG-PO-004 | Bounded iterative determinism: iterative mode output is deterministic under fixed iteration/tolerance policy | Profile declares `max_iterations`, `epsilon`, deterministic numeric policy | DAG-001, DAG-020 | PACK.dag.cycle_iterative_semantics |
| DAG-PO-005 | Monotone SCC fixed-point guarantee (optional): declared monotone SCCs converge to least fixed point | Monotone operators over declared complete lattice domain | DAG-020 | PACK.dag.cycle_iterative_semantics (monotone subset lane) |
| DAG-PO-006 | Observed dynamic-dependency soundness: if recorded dependency set is unchanged, result is unchanged (excluding volatile/external allowances) | Instrumented evaluator with explicit dependency capture | DAG-005, DAG-006, DAG-010 | PACK.dag.dynamic_dependency_bind_semantics |
| DAG-PO-007 | Dynamic from-scratch consistency for DCG/DDG lane: propagated state equals full reevaluation | Dynamic lane enabled for supported function class | DAG-007, DAG-008, DAG-010, DAG-028 | PACK.dag.dynamic_dependency_bind_semantics |
| DAG-PO-008 | Early-cutoff safety: unchanged node values may suppress downstream propagation without semantic drift | Equality semantics declared per value type; no hidden side effects | DAG-005, DAG-006, DAG-028 | PACK.dag.early_cutoff.signature |
| DAG-PO-009 | External update ordering and dedupe determinism: topic-sequence policy is replay-stable | Ordered external op envelope (`topic_id`, `topic_seq`) | DAG-001, DAG-015, DAG-016, DAG-017 | PACK.stream.basic; PACK.dag.external_stream_ordering |
| DAG-PO-010 | Parallel schedule confluence under canonical reduction policy | Fixed canonical order for non-associative/float-sensitive reductions | DAG-001, DAG-025 | PACK.dag.parallel_determinism_signature; PACK.scaling.signature |

## Conformance-row candidates

| Conformance row ID | Requirement statement | Evidence sources | Pack linkage | Readiness |
|---|---|---|---|---|
| DAG-CONF-001 | Engine emits deterministic canonical recalculation order metadata for audit/replay checks | DAG-001, DAG-002, DAG-024 | PACK.visicalc.core | Draft |
| DAG-CONF-002 | SCC/cycle diagnostics include region membership and declared cycle mode used at evaluation time | DAG-023, DAG-020 | PACK.dag.cycle_iterative_semantics | Draft |
| DAG-CONF-003 | Dynamic-dependency formulas emit dependency-set trace artifact for each stabilization wave | DAG-005, DAG-010, DAG-028 | PACK.dag.dynamic_dependency_bind_semantics | Draft |
| DAG-CONF-004 | Early-cutoff decisions are observable through per-node "value-changed" trace fields | DAG-005, DAG-028 | PACK.dag.early_cutoff.signature | Draft |
| DAG-CONF-005 | External update envelopes are replayable with deterministic dedupe outcome | DAG-001, DAG-015, DAG-017 | PACK.stream.basic; PACK.dag.external_stream_ordering | Draft |
| DAG-CONF-006 | Parallel runs at fixed profile/seed produce bit-identical value outputs | DAG-001, DAG-025 | PACK.dag.parallel_determinism_signature | Draft |
| DAG-CONF-007 | Dynamic-topo lane publishes fallback-to-full-rebuild counts and correctness parity checks | DAG-021, DAG-022 | PACK.dag.dynamic_topo_vs_rebuild | Draft |
| DAG-CONF-008 | Iterative cycle mode declares whether result is fixed-point-guaranteed or bounded-pragmatic | DAG-020, DAG-001 | PACK.dag.cycle_iterative_semantics | Draft |

## Promotion notes
1. These IDs are candidate artifacts for synthesis promotion into conformance registries; they are not doctrine by themselves.
2. `DAG-PO-005` is explicitly profile-gated and should not be treated as universal spreadsheet-cycle behavior.
