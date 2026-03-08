**1. Findings**
1. The highest-risk gap is the missing normative publish boundary across `value`, `topology`, `spill`, and future `format/display` overlays. Foundation already requires immutable snapshots, epoch-tagged derived deltas, stale/pending visibility, no stale commit, and structural commit exclusivity, but the compact design notes still leave overlay lifecycle, publish ordering, and epoch-safe GC open. Without an atomic `CalcPublication(epoch)` contract, async recalc can expose cross-plane inconsistency. Sources: [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md#L6), [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L81), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L51), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L75)

2. The current FEC/F3E seam is strong on fence checks but not yet Foundation-ready for concurrency. It already has session/token/capability/snapshot validation, but the spec itself still lists threaded coordinator work and contention replay as open, while the current pathfinder API forbids concurrent use of one engine handle and relies on ephemeral handle-local reject state. Commit authority therefore has to move into a single publisher/coordinator layer. Sources: [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L46), [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L99), [FEC Evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md#L42), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md#L1320), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md#L1342)

3. The layer split is directionally correct but still underspecified: structural refs and structural DAG as baseline, runtime overlay for dynamic refs/spills, and optional format/visibility overlay. The missing piece is one normative overlay contract that says what is persistent truth, what is derived cache, when overlay deltas are reusable, and when they force fallback. Sources: [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L186), [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L201), [DAG Synthesis](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__05_deep_research_synthesis.md#L30), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L20)

4. The current FEC delta split is a good base: `value_delta`, `shape_delta`, and `topology_delta`, with stable IDs and explicit spill events. What it still lacks for the long-term model is a generic typed overlay-token channel for format/display-observable dependencies, and the `prepare -> token/install -> session` handoff is clearer in evidence than in the top-level spec text. Sources: [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L25), [FEC Evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md#L31), [FEC Evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md#L111)

5. The policy boundary is correct: FEC emits evidence, the engine owns recalc policy. The pack consistently points to staged adoption: deterministic topo/SCC first, then dynamic-topo/SAC, then heavier differential/timely machinery only where stream-heavy profiles justify it. That argues against jumping straight to a self-adjusting core. Sources: [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L54), [DAG Synthesis](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__05_deep_research_synthesis.md#L40), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L62)

6. There is an explicit source-tension on cycle semantics. Foundation currently frames cycle mode as `CycleError` vs `Iterative`, but pathfinder v0 requires non-iterative prior-value/`0.0` carry-forward plus diagnostics. I would not silently pick one; the fix is to expand the profile enum to include `NonIterativeCarry`. Sources: [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md#L178), [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L272), [SPEC_v0](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__SPEC_v0.md#L92), [ENGINE_REQUIREMENTS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_REQUIREMENTS.md#L63)

**2. Design Options**
- Option A, conservative: persistent structural model plus ephemeral runtime overlay, single publisher, incremental on value-only dirties, full rebuild on any structural/topology/spill/format uncertainty.
- Option B, balanced: persistent structural world plus retained calc overlay plus display/format overlay, hybrid incremental policy, single publisher with parallel evaluators, thresholded fallback.
- Option C, ambitious: DDG/SAC trace-repair core with dynamic-topo maintenance and optional differential stream lane.

| Option | Correctness Risk | Runtime Gain | Impl Cost | Migration Fit | Assurance Load |
|---|---|---|---|---|---|
| A | Low | Medium-low | Low | High | Low |
| B | Low | High | Medium | High | Medium |
| C | Medium-high | Very high | High | Medium-low | High |

The pack’s own staged-adoption guidance favors B over C. Sources: [DAG Synthesis](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__05_deep_research_synthesis.md#L66), [DAG Packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md#L125), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L62)

**3. Recommended Target Architecture**
Option B.

- `StructureSnapshot(e)`: immutable green-tree structural truth with stable IDs; addresses stay projections, not identity.
- `ReferenceWorld(e)`: binder-derived static refs plus explicit dynamic-site markers.
- `StructuralGraph(e)`: persistent graph from static refs only; dynamic sites are annotations, not guessed edges.
- `CalcOverlay(e)`: observed dynamic deps, spill registry, overlay tokens, invalidation state, and fast-path fingerprints.
- `DisplayOverlay(e)`: derived display/value-format plane; separate from semantic value graph.
- `RecalcCoordinator`: single publisher, multi evaluator, atomic `CalcPublication(e)` across all derived planes.

Core invariants:
- Evaluators read exactly one pinned snapshot.
- Only the coordinator may publish or advance `stabilized_epoch`.
- Scheduler policy may change ready-node order, never final publication contents.
- Overlay state is derived cache, not persistent truth.  
Sources: [Charter](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CHARTER.md#L37), [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md#L6), [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L165), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L20)

**4. Normative Contract Draft**
```text
prepare(formula_text, bind_ctx, profile_version) -> PreparedPlan
open_session(formula_id, expected_token?, snapshot_epoch) -> EvalSession
capability_view(session_id, required_caps) -> CapabilityView
execute(session_id, eval_request) -> EvalTxn
commit(eval_txn) -> CommitResult
```

```text
PreparedPlan = { formula_stable_id, static_refs, dynamic_sites, required_caps, plan_digest }
EvalSession = { session_id, formula_id, formula_token, snapshot_epoch, capability_digest }
EvalTxn = { session_id, formula_id, formula_token, snapshot_epoch, value_result, observed_deps, spill_event?, topology_impact, overlay_tokens, trace_ref }
CommitResult = { status, value_delta, shape_delta, topology_delta, impacted_nodes, display_invalidation? }
```

- Reject taxonomy: `SessionNotFound`, `FormulaNotRegistered`, `FormulaMismatch`, `ExpectedTokenMismatch`, `TransactionTokenMismatch`, `SnapshotConflict(Session|Coordinator|Profile)`, `CapabilityNotBound`, `CapabilityDecisionMismatch`, `CapabilityDenied`, `OverlayBaseEvicted`. Every reject is deterministic and a no-op.
- Required deltas/events: `value_delta` carries `value_changed`, `value_epoch`, semantic hash; `shape_delta` carries `SpillTakeover|SpillClearance|SpillBlocked`, prior/new `RangeId`, entered/exited cells; `topology_delta` carries added/removed `cells`, `name_ids`, `spill_children`, `overlay_tokens`, impacted nodes, and `None|DependencySetChanged|SpillRangeChanged|SpillBlocked|OverlayTokenChanged`.
- Epoch/token rules: `formula_token` changes on formula/bind/profile/function-catalog change; `open_session` pins one `snapshot_epoch`; `commit` is accepted only if formula id, token, session epoch, tx epoch, coordinator target epoch, and capability digest all match.

Migration note: current `install_plan` remains a shim that registers `PreparedPlan` and issues `formula_token`; it need not survive as a long-term public seam verb. Sources: [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L17), [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L46), [FEC Evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md#L17)

**5. Recalc and Overlay Semantics**
- Structural dependency graph rules: build from static bound refs only; rebuild on structural ops, formula/name edits, profile changes, and function-catalog changes.
- Calc-time overlay rules: store runtime-observed deps and invalidation state for dynamic refs, spill membership, and future format/display tokens; overlay mutation is only via successful `commit`.
- Recalc cycles: incremental reuses the last stabilized overlay; full discards it and rebuilds from scratch; hybrid rebuilds affected structural scope and overlay partitions only, with thresholded fallback to full.
- Pure-calc fast path: allowed only when the plan declares no dynamic sites, no spill mutation, no overlay tokens, and no capability/profile drift; emit `value_delta` only.
- Spill rules: old spill region, new spill region, and all spill observers are invalidated as one topology event; blocked spills are first-class events, not implicit failures.
- Format/display/visibility rules: semantic value stays format-free unless a formula explicitly observes a `FormatToken`; display nodes depend on value plus effective formatting; visibility changes scheduling priority only and never dependency truth. Sources: [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L107), [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L201), [FEC Evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md#L55), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L31), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L36)

**6. Concurrency Model**
- Coordinator responsibilities: serialize persistent ops, assign `committed_epoch`, materialize pinned `SnapshotBundle`, open sessions, validate fences, merge commit proposals, publish `CalcPublication`, manage overlay GC.
- Snapshot fences: each worker evaluates against one immutable snapshot; no commit may publish results for any other epoch.
- Contention/retry behavior: `SnapshotConflict` retries by reopening on the latest dirty snapshot; token/profile/capability drift forces re-prepare; repeated topology/spill churn escalates to hybrid or full recalc.
- Visible-first policy: ready queues may prioritize visible work, but canonical selection key remains `(priority_class, topo_rank, stable_node_id)` and fairness uses quota/aging so starvation is impossible.
- Lock discipline: no await, I/O, or user callback while holding mutation-critical locks. Sources: [Charter](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CHARTER.md#L19), [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md#L210), [FEC Evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md#L110), [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L37)

**7. Adoption Roadmap**
1. Freeze vocabulary: ratify `CalcPublication`, reject codes, epoch/token rules, and the expanded cycle-mode enum.
2. Add a coordinator shim behind the current `dvc_*` API; project today’s change journal from coordinator publications so the external API stays stable.
3. Split structural refs/DAG from runtime overlay; keep conservative full fallback for uncertain spill/topology cases.
4. Add pinned snapshots plus parallel evaluators under the single publisher; keep visible-first disabled by default.
5. Add format/display tokens and only then prototype dynamic-topo/SAC lanes.

Compatibility shims:
- Keep `dvc_recalculate`, `dvc_invalidate_volatile`, `dvc_tick_streams`, and `dvc_invalidate_udf` as API verbs, but route them through op/coordinator semantics.
- Keep `dvc_change_*` as a projection of `CalcPublication`.
- Keep `install_plan` only as a bridge to token registration.

Blocker gates:
- resolve the cycle-mode conflict in source-of-truth docs,
- freeze a unified trace schema,
- land contention replay harnesses,
- pass epoch, dynamic-dependency, and spill-lifecycle packs. Sources: [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md#L599), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md#L1140), [FEC Spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md#L85), [DAG Packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md#L41)

**8. Open Questions and Decisive Experiments**
1. What is the break-even point where local structural/topology repair loses to full rebuild? Run `PACK.dag.dynamic_topo_vs_rebuild`.
2. Which generic overlay-token taxonomy is enough for format/display-observable semantics without another seam redesign?
3. Which retry policy is best under interleaved commits and external updates: immediate reopen, batch restart, or wave abort?
4. Can visible-first scheduling prove publication-equivalence to normal priority across wide DAGs and floating-point stress workloads?
5. Should blocked spill state preserve prior visible region until publication, or publish blocked overlay immediately? Pick one and trace it.
6. Resolve the cycle enum and patch the conflicting docs rather than carrying dual semantics. Sources: [Synthesis Context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md#L74), [DAG Packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md#L24), [DAG Obligations](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__10_conformance_and_proof_obligations.md#L27)

**9. Pack/Proof Checklist**
- [ ] `DAG-PO-001`: acyclic incremental recompute equals full recompute.
- [ ] `DAG-PO-002` plus `PACK.concurrent.epochs`: deterministic replay and deterministic typed fence rejects.
- [ ] `DAG-PO-006/007`: dynamic dependency soundness and from-scratch consistency for `INDIRECT`/`OFFSET` lanes.
- [ ] Spill lifecycle pack: blocked, recovery, and re-block with dependent observers.
- [ ] `DAG-PO-010` plus `PACK.dag.parallel_determinism_signature`: same publication hash across thread counts.
- [ ] Visible-first equivalence pack: same outputs/publications as normal priority plus bounded starvation.
- [ ] Trace schema pack: op trace, structural rewrite trace, ref-grid delta trace, FEC seam trace, scheduler trace, value-commit trace, display-commit trace all share epoch/node IDs and schema versions.
- [ ] Overlay GC pack: no overlay eviction while pinned reader or active session references it.
- [ ] Migration pack: current `dvc_change_*` output matches projected `CalcPublication`.
- [ ] Source-of-truth patch set: ratify `prepare/token/session` handoff and resolve cycle-mode terminology. Sources: [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md#L286), [DAG Obligations](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__10_conformance_and_proof_obligations.md#L10), [DAG Packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md#L75)
