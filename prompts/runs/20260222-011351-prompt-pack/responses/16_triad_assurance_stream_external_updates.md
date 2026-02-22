# Triad Prompt - Assurance
Task: Define STREAM + external updates semantics for DnaVisiCalc.

## Baseline semantics to validate
- `STREAM(topic)` reads from an epoch-scoped external topic value.
- Every external update is represented as an explicit OpLog operation (`OpExternalUpdate`) so traces are replayable.
- Applying `OpExternalUpdate` advances `committed_epoch`; recompute produces `CalcDeltas` tagged with `value_epoch`.
- Dependents of a changed topic are invalidated by dependency closure and recomputed incrementally.
- Until recompute stabilizes, prior values may remain visible but must be explicitly marked stale/pending.
- Deterministic conformance mode is mandatory: fixed update ordering, fixed scheduler policy, and replay from canonical traces.

## 1) Failure modes: what can go wrong and how we'll detect it
1. Lost external update (update accepted but no dependent invalidation).
Detection:
- Runtime assertion: every `OpExternalUpdate` yields non-empty invalidation set unless topic is unbound.
- Trace check: op count vs invalidation events must satisfy `affected_topics(op) subset_of invalidated_topics`.
2. Duplicate or out-of-order update application per topic.
Detection:
- Runtime assertion keyed by `(topic_id, source_seq)` monotonicity.
- Oracle replay check flags sequence violations as deterministic diagnostics.
3. Non-deterministic outcomes between identical replays.
Detection:
- Determinism pack re-runs identical trace N times; hash of final snapshot + delta stream must match bit-for-bit.
4. Stale value not marked stale/pending.
Detection:
- Property test: if `value_epoch < committed_epoch` then UI/API status must include stale or pending.
- Runtime assertion on delta emission.
5. Epoch regression (new delta carries older `value_epoch` than prior committed result for same cell without explicit rewind op).
Detection:
- Runtime monotonicity assertion per cell under forward-only trace.
- TLA+ invariant over epoch progression.
6. Cross-engine drift (Red vs Blue differ on same trace).
Detection:
- Differential run comparing canonicalized delta streams and final snapshots.
7. Oracle mismatch (engine diverges from OCaml reference semantics).
Detection:
- Differential run: engine outputs vs OCaml oracle for same trace and deterministic mode.
8. Scheduler race causing externally visible impossible state (e.g., dependent computed from mixed topic versions).
Detection:
- TLA+ model check of snapshot consistency and stale-commit prevention.
- Concurrency stress traces with schedule recording + replay.
9. Unbounded backlog/perf collapse under update bursts.
Detection:
- Perf signature pack tracks throughput slope, max queue depth, and stabilization latency percentiles under fixed loads.
10. Crash or undefined behavior on unsupported/unknown external payload.
Detection:
- Negative conformance corpus requiring explicit deterministic error/warning and non-crash outcome.

## 2) Required obligation packs to claim readiness
Minimum readiness set for DnaVisiCalc STREAM semantics:

1. `PACK.stream.basic`
Required artifacts:
- Spec cases for topic bind, update, invalidation, recompute, stale/pending exposure.
- Golden traces with expected `CalcDeltas`.
Pass gate:
- 100% case pass in deterministic mode for Red and Blue.

2. `PACK.stream.lean.core`
Required artifacts:
- Lean model of STREAM expression evaluation parameterized by external topic map.
- Theorems: determinism (given fixed update trace), dependency invalidation soundness, epoch-label consistency.
Pass gate:
- Lean check succeeds in CI with no admitted lemmas.

3. `PACK.concurrent.epochs`
Required artifacts:
- TLA+ spec for committed/stabilized/value epochs with external update actions.
- Invariants: no stale-commit, snapshot consistency, eventual stabilization under fairness assumptions.
Pass gate:
- TLC exhaustive/parameterized model runs complete with zero invariant violations.

4. `PACK.stream.oracle.diff`
Required artifacts:
- OCaml oracle CLI trace runner for STREAM update semantics.
- Differential harness Red/Blue vs oracle on same canonical traces.
Pass gate:
- Zero semantic diffs on required corpus.

5. `PACK.stream.traces.min`
Required artifacts:
- Failing traces automatically minimized to smallest op sequence reproducing failure.
- Persisted minimized fixtures and triage metadata.
Pass gate:
- Every failing CI run emits minimized repro artifact.

6. `PACK.scaling.signature` (STREAM profile slice)
Required artifacts:
- Fixed-load burst scenarios with deterministic seed/config.
- Metrics: update->stable latency, invalidation fanout cost, queue depth, memory growth slope.
Pass gate:
- Signature within profile thresholds; no monotonic degradation beyond budget.

## 3) Test strategy
Goldens:
- Canonical trace files (`ops.jsonl`) with expected canonical deltas (`deltas.jsonl`) and final snapshot hash.
- Include single-topic, multi-topic, burst, duplicate, out-of-order, and manual/auto recalc transition scenarios.

Property tests:
- Generate DAGs + topic update streams.
- Assert invariants: epoch monotonicity, stale visibility, idempotence on duplicate `(topic, seq)` rejection policy, replay determinism.
- Run with fixed seeds in conformance mode; random seeds only for exploratory non-gating runs.

Differential tests:
- Red vs Blue differential on all required traces.
- Red/Blue vs OCaml oracle differential on same traces.
- Canonicalization step removes non-semantic ordering noise before compare.

Shrink/minimization plan:
- Delta-debugging over operation trace:
  1. Remove contiguous op chunks.
  2. Minimize topic set.
  3. Minimize payload values to smallest counterexample.
  4. Freeze schedule to deterministic replay.
- Output minimized trace + expected/actual diff bundle for regression corpus ingestion.

## 4) Proposed invariants and checker mapping
1. INV-L1 Deterministic replay:
Statement: identical initial snapshot + identical external op trace => identical final values and delta stream.
Tool: Lean theorem (semantic determinism), OCaml differential replay, runtime snapshot hash assertion in deterministic mode.

2. INV-L2 Invalidation soundness:
Statement: any cell transitively dependent on updated topic is eventually marked dirty before stabilization.
Tool: Lean theorem for dependency relation; runtime assertion in dependency closure module.

3. INV-T1 No stale-commit overwrite:
Statement: older compute result cannot overwrite newer committed epoch state.
Tool: TLA+ invariant + runtime compare-and-swap guard assertions.

4. INV-T2 Snapshot consistency:
Statement: a read under pinned epoch observes a single coherent epoch view.
Tool: TLA+ invariant + integration tests with pinned snapshot API.

5. INV-T3 Eventual stabilization:
Statement: under finite external updates and fairness assumptions, system reaches stabilized epoch equal to committed epoch.
Tool: TLA+ liveness property; perf pack watchdog for practical bounded runs.

6. INV-R1 Stale visibility contract:
Statement: if `value_epoch < committed_epoch`, exported value status is never "fresh."
Tool: runtime assertion + property tests + golden UI/API status checks.

7. INV-R2 Op-only mutation:
Statement: STREAM-visible state transitions occur only via OpLog operations.
Tool: runtime audit hook + trace completeness checker.

8. INV-R3 External update sequencing policy:
Statement: per-topic source sequence is strictly increasing (or explicit deterministic reject).
Tool: runtime assertion + negative corpus tests.

## 5) Evidence requirements for Excel compatibility claims
For DnaVisiCalc, direct Excel parity claims should be limited and explicitly scoped because `STREAM(topic)` is a pathfinder construct and full RTD compatibility is a later-stage requirement.

If any Excel compatibility claim is made (RTD-like behavior), require:
1. Public-source mapping:
- Claim mapped to public Excel docs or reproducible observation protocol.
2. Reproducible observation harness:
- Scripted workbook + update driver + captured timeline artifacts.
- Versioned environment manifest (Excel version/channel/build, locale, recalc mode).
3. Comparable trace schema:
- Normalize observed behavior into canonical event trace format comparable with engine traces.
4. Clean-room evidence log:
- Store artifacts and interpretation notes; no proprietary internals.
5. Claim classification:
- `Equivalent`, `Compatible-with-documented-difference`, or `Unsupported`.
- Each classification tied to deterministic test evidence.

## Spec ambiguities that currently block full validation sign-off
1. External update persistence scope:
- Architecture text says updates must be explicit ops and replayable "where required"; unclear whether this is mandatory for all production runs or only harness mode.
Blocker impact:
- Cannot finalize gate criteria for trace completeness and retention.

2. Duplicate/out-of-order policy:
- No normative rule yet for per-topic duplicate sequence numbers and out-of-order arrivals.
Blocker impact:
- Deterministic oracle behavior and minimizer expectations remain underspecified.

3. Multi-update coalescing semantics:
- Unclear whether multiple updates between scheduler slices are evaluated one-by-one or coalesced last-write-wins before recompute.
Blocker impact:
- Affects theorem statements, golden traces, and cross-engine differential expectations.

4. Manual vs auto recalc interaction with STREAM:
- Docs require both modes but do not fully specify when STREAM invalidations surface in manual mode.
Blocker impact:
- Cannot freeze expected stale/pending timeline for conformance goldens.

5. Collaboration policy for external oracles (future seam, but model-impacting):
- Local vs shared oracle semantics are unresolved.
Blocker impact:
- TLA+ model parameters and future profile compatibility proofs remain provisional.
