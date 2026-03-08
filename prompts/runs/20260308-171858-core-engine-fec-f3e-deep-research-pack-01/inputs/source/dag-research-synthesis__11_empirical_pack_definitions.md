# Empirical Pack Definitions (DAG Theory Lane)

## Scope
Concrete empirical-pack contracts derived from reconciled DAG theory findings. Contract fields follow `OPERATIONS.md` pack discipline (scope, fixtures, deterministic requirements, thresholds, emitted artifacts).

## PACK.dag.baseline_recalc_core
- Scope:
  - Baseline deterministic recalc over static dependencies with `Topo + SCC`.
  - Validates baseline stabilization and replay invariants on acyclic and mixed-cycle fixture sets.
- Required fixtures:
  - Generated DAG suites (`n`, `avg_degree`, depth/width variants).
  - Real spreadsheet-shaped fixture set with named ranges and range formulas.
- Deterministic requirements:
  - Fixed profile + engine mode.
  - Stable tie-break order by node identity.
- Pass/fail thresholds:
  - Zero semantic divergence vs full recompute oracle.
  - Zero nondeterministic replay divergence over repeated runs with same inputs.
- Emitted artifacts:
  - `baseline_summary.json`
  - `baseline_case_results.csv`
  - `baseline_replay_diffs.jsonl`

## PACK.dag.dynamic_topo_vs_rebuild
- Scope:
  - Compare dynamic topological maintenance against full rebuild for edge-edit workloads.
- Required fixtures:
  - Synthetic sparse dependency graphs with controlled edit locality.
  - Workbook edit traces (formula insert/delete/reference rewrite).
- Deterministic requirements:
  - Same edit stream replayed across both strategies.
  - Cycle detection outcome must match across strategies.
- Pass/fail thresholds:
  - Correctness parity: 100 percent output equivalence vs rebuild baseline.
  - Promotion threshold: dynamic strategy median latency improves by declared margin without increasing failure/rollback rate.
- Emitted artifacts:
  - `dynamic_topo_benchmark.csv`
  - `dynamic_topo_correctness_parity.json`
  - `dynamic_topo_fallback_events.jsonl`

## PACK.dag.dynamic_dependency_bind_semantics
- Scope:
  - Validate runtime-observed dependency capture for dynamic reference functions.
- Required fixtures:
  - `INDIRECT`-like scenario family with changing target addresses.
  - Control scenarios with static references for false-positive detection.
- Deterministic requirements:
  - Dependency-capture traces persisted per stabilization wave.
  - Volatile/external allowances explicitly labeled.
- Pass/fail thresholds:
  - No stale-read violations in recorded dependency traces.
  - Dynamic lane results equivalent to from-scratch reevaluation on supported subset.
- Emitted artifacts:
  - `dynamic_bind_trace.jsonl`
  - `dynamic_bind_stale_violation_report.json`
  - `dynamic_bind_equivalence_report.json`

## PACK.dag.early_cutoff.signature
- Scope:
  - Quantify and validate early-cutoff behavior under realistic and synthetic workloads.
- Required fixtures:
  - Long-chain sensitivity workloads.
  - Branch-heavy models with localized changes.
- Deterministic requirements:
  - Value-equality comparator policy fixed by profile.
  - Cutoff decisions logged with dependent suppression counts.
- Pass/fail thresholds:
  - Zero incorrect suppression events.
  - Signature metrics reported: cutoff ratio, recompute reduction, stabilization latency.
- Emitted artifacts:
  - `early_cutoff_metrics.csv`
  - `early_cutoff_decisions.jsonl`
  - `early_cutoff_incorrect_suppression.json`

## PACK.dag.parallel_determinism_signature
- Scope:
  - Validate deterministic outcomes under parallel scheduling variants.
- Required fixtures:
  - Wide and deep DAG families.
  - Floating-point aggregation stress workloads.
- Deterministic requirements:
  - Fixed seed and canonical reduction policy.
  - Run matrix over thread counts (`1,2,4,8,16`).
- Pass/fail thresholds:
  - Bit-identical outputs across thread-count matrix (or explicitly bounded profile exception).
  - Stable replay hashes across repeated runs.
- Emitted artifacts:
  - `parallel_replay_hashes.csv`
  - `parallel_output_diffs.json`
  - `parallel_scaling_signature.csv`

## PACK.dag.cycle_iterative_semantics
- Scope:
  - Validate cycle handling for both `CycleError` and `Iterative` profile modes.
- Required fixtures:
  - SCC templates: convergent monotone, oscillating, divergent, and bounded-pragmatic cases.
- Deterministic requirements:
  - Deterministic iteration ordering within SCCs.
  - Explicit iteration cap and epsilon configured in fixture metadata.
- Pass/fail thresholds:
  - `CycleError` mode must report deterministic diagnostics with no silent fallback.
  - `Iterative` mode must match declared bounded semantics and report termination reason.
- Emitted artifacts:
  - `cycle_mode_results.csv`
  - `cycle_iteration_traces.jsonl`
  - `cycle_termination_reasons.json`

## PACK.dag.external_stream_ordering
- Scope:
  - Validate deterministic ordering and dedupe behavior for external update envelopes.
- Required fixtures:
  - Topic streams with duplicates, out-of-order arrivals, and coalescing cases.
  - Mixed internal edits + external updates traces.
- Deterministic requirements:
  - Explicit total order policy for replay.
  - Topic-sequence rules fixed per profile.
- Pass/fail thresholds:
  - No replay divergence with identical ordered envelope stream.
  - Dedupe/coalescing behavior matches profile policy exactly.
- Emitted artifacts:
  - `stream_ordering_results.csv`
  - `stream_dedupe_events.jsonl`
  - `stream_replay_equivalence.json`

## Staging and maturity
1. Stage Now:
   - `PACK.dag.baseline_recalc_core`
   - `PACK.dag.cycle_iterative_semantics`
2. Stage Next:
   - `PACK.dag.dynamic_topo_vs_rebuild`
   - `PACK.dag.dynamic_dependency_bind_semantics`
   - `PACK.dag.early_cutoff.signature`
3. Stage Later:
   - `PACK.dag.parallel_determinism_signature`
   - `PACK.dag.external_stream_ordering`
