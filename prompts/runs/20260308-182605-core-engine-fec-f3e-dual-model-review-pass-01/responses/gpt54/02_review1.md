**1. Critique**
- The prior answer got the overall direction right, but it blurred source-backed fact and proposal. `CalcPublication`, `DisplayOverlay`, generic overlay-token channels, `OverlayBaseEvicted`, and the exact scheduler key were presented too normatively; the pack supports epoch/delta/publish constraints, but those concrete artifacts are still design choices.
- It did not cleanly separate Round 0 authority from Foundation extension. Pathfinder v0 says formatting is metadata-only and `dvc_cell_set_format` does not trigger recalc, while the compact synthesis notes only propose format-observable dependencies as an optional future lane. Those cannot be merged into one baseline contract.
- It underplayed the current FEC seam mismatch between spec and implementation evidence. The authoritative compact spec shows `prepare -> open_session -> capability_view -> execute -> commit`, but the evidence still requires `install_plan(formula_id, plan) -> FormulaToken`. A Foundation-ready contract needs that lifecycle step made explicit.
- It identified the cycle-semantic conflict, but the fix was not stated strongly enough. Foundation says `CycleError` vs `Iterative`; pathfinder says non-iterative carry-forward with diagnostics when iteration is disabled. That requires a source-of-truth patch or an explicit profile exception, not just a suggestion.
- It also missed a sharper use of the declared lane boundary: OxFml owns parse/bind, OxFunc owns value/function semantics, and FEC host/model owns capability policy, dependency lifecycle, scheduler interaction, and publication lifecycle. That ownership split should drive the contract draft.

Sources: [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md), [FEC spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md), [FEC evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md), [ENGINE_REQUIREMENTS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_REQUIREMENTS.md), [SPEC_v0](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__SPEC_v0.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**2. Full revised answer**
No `F3C` alias appears in this pack, so the terminology below stays `FEC/F3E`.

**1. Findings**
1. The highest-risk missing contract is the derived-state publish boundary. Authority gives immutable snapshots, epoch-tagged CalcDeltas, snapshot publish, pinned-epoch GC, and FEC-owned publication lifecycle, while the compact design notes explicitly say the structural-graph vs overlay publish lifecycle is unresolved. Foundation needs a normative per-commit derived publication unit.
2. The seam contract is almost ready, but spec and evidence disagree on formula-plan registration. The spec shows the evaluation lane starting at `prepare`, while implementation evidence still has `install_plan -> FormulaToken`. Foundation should keep plan registration as an explicit formula-lifecycle step outside the eval transaction.
3. The correct layer split is `Structure -> References -> Dependencies -> Values`, with operations as the only persistent mutation path. Static refs and the structural DAG belong in derived structural layers; dynamic deps, spill state, and any future format/display observability belong in typed overlays.
4. Formatting must be split by profile. Round 0 says formatting is metadata-only and does not trigger recalc; future format-observable behavior is only an optional, profile-gated Foundation extension.
5. Concurrency requires a single coordinator/publisher. FEC already has session/snapshot/capability fences, but current evidence still calls out single-thread coordinator orientation, and the current DnaVisiCalc handle is not concurrently safe per handle.
6. There is a real source conflict on cycle semantics. Foundation summary says `CycleError | Iterative`; pathfinder authority says disabled iteration uses prior-stabilized-or-`0.0` carry semantics plus diagnostics. That must be patched explicitly.

Sources: [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md), [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md), [FEC spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md), [FEC evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md), [ENGINE_REQUIREMENTS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_REQUIREMENTS.md), [SPEC_v0](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__SPEC_v0.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**2. Design options**
- Option A, conservative: immutable structure plus static ref/DAG layers, but treat dynamic deps and spill state as mostly disposable caches; any topology uncertainty escalates quickly to full rebuild.
- Option B, balanced: immutable structure plus retained typed overlays for dynamic deps, spill state, and optional display/format observability; single publisher with parallel evaluators; hybrid incremental by default.
- Option C, ambitious: dynamic-topo/SAC-style repair as the default engine lane, with retained traces and fallback only for unsupported cases.

| Option | Correctness risk | Runtime upside | Migration fit | Assurance burden |
|---|---|---|---|---|
| A | Low | Low-Medium | High | Low |
| B | Low | High | High | Medium |
| C | Medium-High | Very High | Medium-Low | High |

Sources: [DAG synthesis](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__05_deep_research_synthesis.md), [transfer matrix](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__04_dnacalc_transfer_matrix.md), [empirical packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**3. Recommended target architecture**
Option B.

- `StructureSnapshot(e)`: immutable green-tree truth for cells, names, formats, controls, charts, profile, and calc settings; identity is ID-based, not address-string-based.
- `ReferenceWorld(e)`: derived static bind output from `StructureSnapshot + bind context + profile`; contains normalized static refs plus `DynamicSite` descriptors.
- `StructuralGraph(e)`: derived graph over static refs only. Dynamic sites are recorded as sites, not speculative edges.
- `CalcOverlay(e)`: retained derived cache partitioned into `dep_overlay`, `spill_overlay`, and optional `display_overlay`. This is cache, never persistent truth.
- Proposed new artifact: `DerivedPublication`, an atomic per-commit bundle of `value_delta + shape_delta + topology_delta + optional display delta`.
- `RecalcCoordinator`: the only publisher. Evaluators may run in parallel, but all acceptance, overlay mutation, and epoch advancement flow through the coordinator.
- External contract stays strategy-agnostic. Internal graph/scheduler choices remain implementation detail; invariants, fences, rejects, traces, and deltas are the normative surface.

Core invariants:
- Every eval session reads one pinned snapshot bundle.
- Only the coordinator may accept commits or advance `stabilized_epoch`.
- Scheduler policy may change order, never result.
- `StructureSnapshot` is truth; refs/graph/overlay/deltas are rebuildable.
- Format-observable and visible-first behavior are profile-gated extensions, not Round 0 baseline.

Sources: [CHARTER](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CHARTER.md), [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md), [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md), [ENGINE_REQUIREMENTS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_REQUIREMENTS.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**4. Normative contract draft**
Interfaces:
- `prepare(formula_text, bind_ctx, profile_id, profile_version) -> PreparedPlan`
- `register_plan(formula_id, PreparedPlan) -> FormulaToken`  
  Current `install_plan` should remain as a compatibility alias for this lifecycle step.
- `open_session(formula_id, expected_token?, snapshot_epoch) -> EvalSession`
- `capability_view(session_id, formula_id, required_caps) -> FecCapabilityView`
- `execute(session_id, EvalRequest) -> EvalTransaction`
- `commit(EvalTransaction) -> CommitResult`

Key types:
- `PreparedPlan { formula_stable_id, static_refs, dynamic_sites, required_caps, plan_digest }`
- `EvalSession { session_id, formula_id, formula_token, snapshot_epoch, capability_binding }`
- `EvalTransaction { session_id, formula_id, formula_token, snapshot_epoch, value_result, observed_deps, spill_event?, topology_impact, optional_display_tokens }`
- `CommitResult { status, value_delta, shape_delta, topology_delta, optional_display_delta }`

Commit result and reject taxonomy:
- `Applied`
- Mandatory reject classes from current seam: `SessionNotFound`, `FormulaNotRegistered`, `FormulaMismatch`, `ExpectedTokenMismatch`, `TransactionTokenMismatch`, `CapabilityNotBound`, `CapabilityDecisionMismatch`, `CapabilityDenied`, `SnapshotConflict(Session|Coordinator)`
- Profile/version/catalog drift should be represented by token mismatch unless the seam later standardizes finer reject codes.

Required deltas and events:
- `value_delta`: changed value/error/state, `value_epoch`, `value_changed`
- `shape_delta`: `None | SpillTakeover | SpillClearance | SpillBlocked`, old/new `RangeId`, entered/exited members
- `topology_delta`: added/removed `cells`, `name_ids`, `spill_children`, impacted nodes, impact class `None | DependencySetChanged | SpillRangeChanged | SpillBlocked`
- `display_delta`: optional and profile-gated; absent in Round 0 baseline

Epoch and token rules:
- `FormulaToken` must change on formula/bind/profile/function-catalog changes.
- `open_session` pins one `snapshot_epoch`.
- `commit` is a deterministic atomic no-op unless session, token, snapshot fence, and capability decision all match.
- Accepted commit publishes one `DerivedPublication`; `value_epoch` is the committed snapshot epoch being stabilized.
- `stabilized_epoch` advances only when the dirty/pending set for that epoch drains.

Sources: [FEC spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md), [FEC evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md), [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md), [SPEC_v0](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__SPEC_v0.md)

**5. Recalc and overlay semantics**
- Structural graph rules: bind produces explicit `CellRef/RegionRef/NameRef/ErrorRef`; the structural graph is built only from static refs; names/charts/controls remain first-class participants.
- Structural edits rerun bind and deterministic rewrite classification on the affected scope; invalidated refs stay explicit, never silently dropped.
- Calc-time overlay rules: dynamic deps are keyed by `(formula_id, dynamic_site_id, formula_token, base_epoch)` and are reusable only while token and base snapshot remain valid.
- Recalc modes: `full` discards overlays and rebuilds all derived layers; `incremental` reuses graph and overlays; `hybrid` rebuilds only affected structural partitions plus intersecting overlay partitions, then falls back to full if churn thresholds are exceeded.
- Pure-calc fast path is allowed only when there are no dynamic sites, no spill mutation, no optional display tokens, and no capability/profile drift.
- Spill/format/visibility interaction: spill events are explicit topology events; invalidate prior spill region, new spill region, and spill observers together. Format changes are metadata-only in Round 0; future format-observable formulas must declare explicit tokens. Visibility changes affect scheduling priority only, never dependency truth.

Sources: [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md), [ENGINE_REQUIREMENTS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_REQUIREMENTS.md), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md), [FEC evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**6. Concurrency model**
- Coordinator responsibilities: apply ops, publish snapshots, own dirty sets and overlay registry, open sessions, validate commit fences, project change journals, and manage pinned-epoch GC.
- Snapshot fences: each evaluator reads one immutable bundle `(StructureSnapshot, ReferenceWorld, StructuralGraph, CalcOverlay base)`; no commit may publish against a different bundle.
- Contention and retry: `SnapshotConflict` means reopen on latest bundle and retry; token/capability mismatch means reprepare or reregister; repeated topology/spill churn escalates incremental -> hybrid -> full.
- Visible-first is optional policy only. If enabled, priority may change, but canonical tie-break must stay deterministic and starvation prevention is mandatory.

Sources: [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md), [FEC observations](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_OBSERVATIONS.md), [FEC evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**7. Adoption roadmap**
- Phase 1: patch authority docs to define the plan-registration step, per-commit derived publication unit, and the cycle-mode fix.
- Phase 2: insert an internal coordinator behind the current DnaVisiCalc API; keep external `dvc_*` behavior stable and project `dvc_change_*` from coordinator publications.
- Phase 3: split static `ReferenceWorld/StructuralGraph` from retained `dep_overlay/spill_overlay`; keep conservative full fallback on topology uncertainty.
- Phase 4: enable parallel evaluators with pinned sessions and deterministic reject/retry, but keep single publisher.
- Phase 5: add optional `display_overlay` only under a future profile gate for format-observable or visibility-priority behavior.
- Phase 6: pilot dynamic-topo and early-cutoff lanes only after baseline packs are green.

Compatibility shims and blocker gates:
- Keep `install_plan` as alias of `register_plan`.
- Keep current per-handle external serialization even if internal evaluation becomes parallel.
- Block promotion on cycle-source conflict, unified trace schema, epoch/contention packs, and journal-parity packs.

Sources: [A&R](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md), [OPERATIONS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__OPERATIONS.md), [FEC evidence](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md), [ENGINE_API](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__ENGINE_API.md), [SPEC_v0](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dnavisicalc-spec__SPEC_v0.md)

**8. Open questions and decisive experiments**
- What churn threshold makes `hybrid` slower or less reliable than `full`? Run `PACK.dag.dynamic_topo_vs_rebuild`.
- Should `display_overlay` be a separate plane or just a typed partition inside `CalcOverlay`? Compare invalidation complexity and trace size.
- How should format-observable functions be introduced without violating Round 0 metadata-only formatting? Prototype as a profile-gated lane.
- Does visible-first preserve publication-equivalence across thread counts and float-sensitive workloads? Add a visible-first equivalence pack on top of parallel determinism.
- Should function-catalog drift be encoded only in `FormulaToken`, or surfaced separately in reject detail? Decide from conformance/reporting needs.
- Resolve the cycle-mode conflict by patching the authority docs, not by carrying dual semantics informally.

Sources: [DAG synthesis](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__05_deep_research_synthesis.md), [conformance obligations](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__10_conformance_and_proof_obligations.md), [empirical packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md), [synthesis context](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md)

**9. Pack/proof checklist**
- `DAG-PO-001`: incremental acyclic recompute equals full recompute.
- `DAG-PO-002`: identical ordered op streams and identical policy mode produce identical observable outputs and reject sequences.
- `DAG-PO-006/007`: dynamic-dependency soundness and from-scratch consistency for `INDIRECT`/`OFFSET` lanes.
- Spill lifecycle pack: blocked, recovery, and re-block flows invalidate anchors, members, and observers correctly.
- `PACK.concurrent.epochs`: no stale commit, deterministic fence rejects, and no overlay eviction while a pinned session still references it.
- `PACK.dag.parallel_determinism_signature`: identical outputs and replay hashes across thread counts.
- Journal parity pack: projected `dvc_change_*` stream matches `DerivedPublication` for cell/name/chart/format/spill entities.
- Trace schema pack: op trace, rewrite trace, ref-grid delta trace, FEC seam trace, scheduler trace, value-commit trace, and optional display trace share epoch/node/session ids and schema versions.
- Source patch checklist: cycle enum fix, explicit `register_plan/install_plan` lifecycle, and publication-boundary text in authority docs.

Sources: [Formal](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md), [OPERATIONS](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/foundation-core__OPERATIONS.md), [conformance obligations](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__10_conformance_and_proof_obligations.md), [empirical packs](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/dag-research-synthesis__11_empirical_pack_definitions.md), [FEC spec](C:/Work/DnaCalc/Foundation/prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01/inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md)
