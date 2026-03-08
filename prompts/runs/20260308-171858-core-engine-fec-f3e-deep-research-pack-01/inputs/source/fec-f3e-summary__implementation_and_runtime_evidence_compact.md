# FEC/F3E Implementation and Runtime Evidence (Compact)

## Purpose
This compact source replaces large Rust implementation and raw trace files for design-phase synthesis. It retains the seam contract shape, runtime behaviors, and empirically observed boundary-event patterns.

## Replaced Sources
- `fec-f3e-implementation__contracts.rs`
- `fec-f3e-implementation__f3e_engine.rs`
- `fec-f3e-implementation__fec_host.rs`
- `fec-f3e-implementation__engine.rs`
- `fec-f3e-implementation__eval.rs`
- `fec-f3e-implementation__trace.rs`
- `fec-f3e-implementation__fec_f3e_seam_scenarios_tests.rs`
- `fec-f3e-evidence__seam_trace.event_counts.tsv`
- `fec-f3e-evidence__seam_trace.callgraph.edges.csv`

## Transactional Seam Shape (Implemented)
1. `prepare(formula_text,bounds,ctx) -> FormulaPlan`
2. `install_plan(formula_id,plan) -> FormulaToken`
3. `open_session(formula_id,expected_token,snapshot_epoch) -> EvalSessionId`
4. `capability_view(session_id,formula_id,required_caps) -> FecCapabilityView`
5. `execute(evaluator,EvalRequest) -> EvalTransaction`
6. `commit(EvalTransaction) -> CommitResult`

Coordinator epoch is explicitly tracked and checked at commit time against session snapshot.

## Key Contract Types (Current)
- Stable identity: `FecNameId`, `FecRangeId`, `FecFormulaStableId`, `FecFormulaId`.
- Capability model: `FecCapabilityTag`, `FecCapabilityDecision`, `FecCapabilityView`.
- Eval envelope: `EvalRequest`, `EvalTransaction`, `F3eResultKind`, `EvalObservation`.
- Dependency deltas: `F3eObservedDependencies`, `F3eDependencyDelta` (`cells`, `names`, `spill_children`).
- Shape/topology deltas:
  - `SpillDeltaEvent`: `None | SpillTakeover | SpillClearance | SpillBlocked`.
  - `FecShapeDelta`, `FecTopologyDelta` with `TopologyImpact`.
- Commit outcome:
  - `CommitStatus` with applied/rejected taxonomy,
  - `CommitRejectDetail` with structured reject metadata,
  - split payload: `value_delta`, `shape_delta`, `topology_delta`.
- Perf counters: seam call counts, reject counters, dependency/spill delta totals.

## Implemented Failure Semantics
`commit` reject classes are explicit and deterministic:
- `RejectedSessionNotFound`
- `RejectedFormulaNotRegistered`
- `RejectedFormulaMismatch`
- `RejectedExpectedTokenMismatch`
- `RejectedTransactionTokenMismatch`
- `RejectedCapabilityNotBound`
- `RejectedCapabilityDecisionMismatch`
- `RejectedCapabilityDenied`
- `RejectedSnapshotConflict` (session mismatch and coordinator mismatch variants via reject detail code)

Reject payload fields include expected/actual token, expected/actual snapshot epoch, coordinator epoch, and denied capability.

## Dependency + Spill Delta Sufficiency (Observed)
Current deltas support policy-ready invalidation inputs:
- runtime dependency changes on cells/names/spill-children,
- explicit spill lifecycle events with entered/exited cells,
- topology impact tags (`DependencySetChanged`, `SpillRangeChanged`, `SpillBlocked`).

This is sufficient for a scheduler to choose between selective invalidation and conservative fallback policies.

## Engine Integration Signals
The engine integrates seam calls in both full and incremental recalc flows:
- `evaluate_cell_via_f3e`
- `evaluate_name_via_f3e`
- `recalculate_full`
- `recalculate_incremental`
- `incremental_spill_fallback`

Engine tracks `committed_epoch` and `stabilized_epoch`, applies runtime dependency deltas into reverse maps, and supports spill policy modes:
- `ConservativeFullRecalc`
- `ExternalScheduler`

## Runtime Trace Schema
Trace utilities emit boundary events with schema tag:
- `trace_version=fec-f3e-trace/b4`
- monotonic `seq`
- `schema_valid` field-level validation indicator

## Empirical Evidence Snapshot
From seam event counts:
- `fec.open_session`: 83
- `fec.capability_view`: 83
- `f3e.execute`: 83
- `fec.commit`: 83
- `f3e.prepare`: 36
- `fec.install_plan`: 37
- `engine.recalculate_full`: 50
- `engine.recalculate_incremental`: 30
- `engine.incremental_spill_fallback`: 1

Observed stable phase pattern:
- `fec.open_session -> fec.capability_view -> f3e.execute -> fec.commit -> engine.evaluate_cell_via_f3e`

## Scenario Coverage (Seam Tests)
Implemented scenario tests include:
- static/no-dependency and static-reference formulas,
- name-chain and name-delta routing,
- dynamic reference retargeting (`INDIRECT`/`OFFSET` behavior),
- spill takeover/clearance and spill blocked/recovery,
- incremental dirty closure skip behavior,
- recalc mode behavior (manual vs automatic),
- policy signal tests for external-scheduler spill hints and conservative fallback,
- perf snapshot scaffolding checks.

## Design-Phase Takeaways
1. Transaction boundary and reject semantics are concrete enough to synthesize normative contracts.
2. Runtime deltas (dependency + spill shape + topology impact) are concrete enough to specify scheduler invalidation policy tiers.
3. Epoch fencing and token checks are present, but broader multi-session contention/retry policy should still be made explicit in architecture docs.
4. Formatting-sensitive formula dependencies and visibility-priority scheduling remain primarily architecture-level requirements; they are not the dominant seam signal in current traces.
