# Scaling Characterization Suite for DnaVisiCalc (Early Big-O Signals)

## 0) Source-of-Truth Check (Universal Wrapper Requirement)

### Contradictions found
- No hard contradiction across `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `notes/BRAINSTORM_NOTES.md` for this topic.
- One explicit open ambiguity exists in `notes/BRAINSTORM_NOTES.md` section **N**: deterministic policy under parallelism (especially float reduction order).

### Single coherent resolution for this suite
- `PACK.scaling.signature` runs in deterministic mode by default with fixed reduction order and fixed scheduler policy.
- A second, non-gating exploratory lane may run parallel nondeterministic throughput checks, but those results never drive pass/fail.

## 1) Suite Goal and Scope

Goal: detect algorithmic growth regressions early (Big-O smell detection), before absolute latency budgets are exceeded.

Scope for Round 0 (`DnaVisiCalc`):
- Measure per-phase growth for `parse`, `bind`, `closure`, `schedule`, `eval`, `commit`.
- Run canonical synthetic workloads that isolate graph shape effects.
- Compute log-log slopes and compare to baselines for regression gates.
- Emit durable artifacts for trend analysis and CI gating.

Non-goals (Round 0):
- Cross-machine absolute latency comparison.
- Full Excel-sized interop workload replay.
- Auto-tuning scheduler policy.

## 2) End-to-End Harness Shape

```text
Workload Generator -> Trace/Workbook Builder -> Deterministic Runner
-> Phase Counters + Timers -> Aggregator -> Log-Log Slope Fit
-> Regression Classifier -> Artifact Writer -> CI Gate
```

## 3) Workload Generators

Use geometric size ladder per workload (example): `N = 64, 128, 256, 512, 1024, 2048`.

| Workload | Generator definition | Primary signal | Expected slope smell target |
|---|---|---|---|
| Chain | `c1 = seed`, `c(i)=f(c(i-1))` for `i=2..N` | Closure traversal depth, schedule frontier width=1 | ~O(N) total work |
| Fan-in | `N` independent leaves feeding one sink (`SUM`, `MIN`, etc.) | Bind edge fan-in, eval combine cost | ~O(N) |
| Fan-out | One source feeding `N` dependents | Invalidation fan-out, delta fan-out | ~O(N) |
| Grid | `R x C` formulas (usually `R=C=sqrt(N)`), row/col dependencies | Graph density effects and cache locality | typically ~O(N) to O(N log N), flag near O(N^2) |
| Random sparse | Graph with `N` nodes, expected degree `d` (fixed), seeded RNG | Scheduler/eval under irregular topology | ~O(N) for fixed `d` |
| Structural insert | Start from grid/sparse workbook, issue row/col insert in middle, measure reference rewrite + downstream recompute | Rewrite complexity and invalidation explosion | target near affected-set linearity |

Generator rules:
- Emit both workbook build recipe and seed.
- Separate workbook construction time from measured recalculation phases.
- Structural insert workload must include mixed relative/absolute refs and at least one named range.

## 4) Metrics and Counters Per Phase

Collect both duration and operation counters. Time-only metrics are insufficient for complexity diagnosis.

| Phase | Required timers | Required counters | Notes |
|---|---|---|---|
| Parse | `parse_ns_total`, `parse_ns_p50/p95` | `formulas_parsed`, `tokens_total`, `ast_nodes_total`, `parse_cache_hit/miss` | Measure only changed formulas for incremental runs |
| Bind | `bind_ns_total`, `bind_ns_p50/p95` | `refs_resolved`, `edges_created`, `name_resolutions`, `bind_cache_hit/miss` | Include structured-ref/name lookup counts |
| Closure | `closure_ns_total`, `closure_ns_p50/p95` | `dirty_seed_count`, `dirty_closure_nodes`, `closure_edges_scanned` | Core invalidation growth signal |
| Schedule | `schedule_ns_total`, `schedule_ns_p50/p95` | `tasks_enqueued`, `tasks_dequeued`, `ready_queue_peak`, `worker_steals` | Deterministic mode still records queue behavior |
| Eval | `eval_ns_total`, `eval_ns_p50/p95` | `cells_evaluated`, `udf_calls`, `stream_reads`, `volatile_evals`, `numeric_reductions` | Include error-value count for churn visibility |
| Commit | `commit_ns_total`, `commit_ns_p50/p95` | `values_committed`, `deltas_emitted`, `stale_marks_set/cleared`, `epoch_advance_count` | Align to epoch model requirements |

Run metadata (required):
- `git_sha`, `engine` (`red`/`blue`), `profile_id`, `profile_version`, `deterministic_mode=true/false`.
- `machine_class`, `cpu_model`, `core_count`, `os`, `runtime_version`.
- `workload_id`, `seed`, `N`, `thread_count`, `iteration_index`.

## 5) Slope Computation and Regression Detection

### 5.1 Fit method
For each workload-phase metric pair:
1. Use aggregated per-size value `y(N)` from stable statistic (median of post-warmup iterations).
2. Transform to log space: `x = log10(N)`, `z = log10(max(y, 1))`.
3. Fit `z = a + b*x` (ordinary least squares).
4. Report `b` (slope), `R^2`, and bootstrap 95% CI for `b`.

Interpretation bands (heuristic labels):
- `b < 0.2`: near constant.
- `0.8 <= b <= 1.2`: near linear.
- `1.8 <= b <= 2.2`: near quadratic.

### 5.2 Regression rules
A gate compares candidate run vs baseline for identical `{engine, profile_version, machine_class, workload, phase}`.

Hard fail (algorithmic regression):
- `b_candidate - b_baseline > 0.20` and lower CI bound of candidate slope exceeds `b_baseline + 0.10`.

Soft fail (constant-factor regression):
- Predicted `y` at reference size `N_ref` worsens by >25% while slope delta stays <=0.20.

Noise guardrails:
- Require minimum 5 size points and minimum 8 measured iterations/size (after warmup trimming).
- If `R^2 < 0.90`, mark result unstable and require rerun before gating decision.

Diagnostic split:
- If time slope regresses but counter slope does not, classify as runtime/system regression.
- If both regress, classify as algorithmic/data-structure regression.

## 6) Determinism Rules for Stable Measurements

Mandatory for gating runs:
- `CONSTR-005` deterministic mode on.
- Fixed seed per workload and size.
- Fixed thread-count profile (at least `1` for canonical gate; optional separate fixed `P` lane).
- Fixed task ordering policy and fixed reduction order for floating aggregations.
- No network/file I/O in measured region; preload fixtures.
- Warmup iterations excluded from fit.
- Disable adaptive behavior that changes plan per run (or pin it and record config hash).
- Run on reserved CI machine class; capture machine fingerprint in artifact.

Recommended stability controls:
- Pin process affinity and priority.
- Keep thermal/power policy constant.
- Record background load indicator; discard outlier runs above threshold.

## 7) Artifact Model and Storage

Directory contract:

```text
artifacts/scaling-signature/
  <timestamp_utc>/
    manifest.json
    <engine>/<profile>/<workload>/
      raw_runs.ndjson
      aggregates.json
      slope_report.json
      slope_report.md
```

`manifest.json` should include:
- run identity: timestamp, git sha, branch, dirty flag.
- environment identity: machine_class + runtime/tool versions.
- executed workload matrix and size ladder.
- gate result summary.

Data contracts:
- `raw_runs.ndjson`: one record per iteration-size-phase.
- `aggregates.json`: median/p95/count summaries per size-phase.
- `slope_report.json`: fit coefficients, CI, quality metrics, baseline deltas, classifications.
- `slope_report.md`: human-readable summary with top regressions table.

Retention policy:
- Keep all gate-failing artifacts.
- Keep at least last `K` green runs (example `K=30`) per branch for trend charts.
- Nightly job compacts long history into weekly snapshots.

## 8) Gating Plan (Now and Later)

### PR gate (fast)
- Run reduced ladder (example `N=128..1024`) on critical workloads: `chain`, `fan-out`, `structural-insert`.
- Gate only deterministic single-thread slopes.

### Nightly gate (full)
- Full ladder and all workloads.
- Add fixed parallel lane (`P` threads) as non-blocking warning channel in Round 0, promote to blocking after noise stabilizes.

### Pack integration
- `OPERATIONS.md` already names `PACK.scaling.signature`.
- This suite defines the pack contract: workloads, metrics schema, fit method, thresholds, artifact paths, and rerun policy.

## 9) Exact Doc Edits to Codify This

- `OPERATIONS.md` → section `4.1 Packs`: expand `PACK.scaling.signature` with a normative pointer to a schema section.
- `OPERATIONS.md` → add section `4.3 PACK.scaling.signature Contract`: workload matrix, deterministic requirements, gate thresholds, artifact schema.
- `ARCHITECTURE_AND_REQUIREMENTS.md` → section `4. Architectural Constraints`: add `CONSTR-006` requiring phase-level perf counters and deterministic perf harness compatibility.
- `ARCHITECTURE_AND_REQUIREMENTS.md` → section `5. Core Requirements`: add `REAL-PERF-001` log-log slope reporting and baseline regression policy per profile.

## 10) Smallest High-Leverage Next Actions

1. Freeze the metric schema (`raw_runs`, `aggregates`, `slope_report`) and check it into the repo.
2. Implement the six workload generators with deterministic seed contract.
3. Wire phase counters in both engines to emit identical schema.
4. Stand up baseline capture on one CI machine class and record first green baseline set.
5. Enable PR fast gate with hard-fail on slope regression and unstable-fit rerun policy.
