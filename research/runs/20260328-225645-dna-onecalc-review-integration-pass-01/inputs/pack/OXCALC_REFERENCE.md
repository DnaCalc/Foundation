# OxCalc Reference

This document consolidates the current DNA OneCalc-relevant reference set from `OxCalc`.

Repo role: Multi-node coordinator and publication semantics plus the downstream seam-reference reading of the shared OxFml interface.

Included source documents:
- `OxCalc/CHARTER.md`
- `OxCalc/CURRENT_BLOCKERS.md`
- `OxCalc/docs/IN_PROGRESS_FEATURE_WORKLIST.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_ARCHITECTURE.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md`
- `OxCalc/docs/spec/core-engine/CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`
- `OxCalc/docs/spec/README.md`
- `OxCalc/README.md`

The sources are reproduced below in full so the pack remains self-contained even after flattening.

## Source: `OxCalc/CHARTER.md`

# CHARTER.md — OxCalc Charter

## 1. Mission
OxCalc defines, implements, and proves the multi-node core engine model for DNA Calc.

It owns coordinator behavior, scheduling policy, invalidation policy, and epoch-safe publication semantics while preserving profile-defined semantic equivalence across runtime strategies.

## 2. Precedence
When guidance conflicts, precedence is:
1. `../Foundation/CHARTER.md`
2. `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
3. `../Foundation/OPERATIONS.md`
4. this `CHARTER.md`
5. this repo `OPERATIONS.md`

## 3. Scope
In scope:
1. Core graph/overlay state model and coordinator transitions.
2. Commit publication fences and deterministic rejection handling.
3. Stage 1 baseline sequential coordinator and staged concurrency promotion criteria.
4. Visibility-priority policy (`VisibleFirst`) with semantic-equivalence and fairness constraints.
5. Tree-only to tree-grid-hybrid progression semantics and gap tracking.
6. Rust-first realization of OxCalc-owned executable artifacts for the core engine and `TraceCalc` tooling/runtime.

Out of scope:
1. Formula grammar and evaluator protocol ownership (OxFml).
2. Function semantic kernels (OxFunc).
3. UI rendering and file-adapter implementation concerns.

## 4. FEC/F3E Co-definition Rule
1. OxCalc co-defines coordinator-facing clauses of the shared FEC/F3E contract.
2. Canonical shared protocol files remain owned by OxFml.
3. OxCalc contributions must be sent via explicit handoff packets with replay evidence.

## 5. Clean-room Rule
Allowed sources:
1. public specifications and documentation,
2. published research,
3. reproducible black-box observations.

Disallowed sources:
1. proprietary or restricted sources,
2. reverse engineering of internals,
3. decompilation/disassembly of Excel internals.

## 6. Definition of Done (Lane)
A coordinator policy/spec change is done only when:
1. spec text and realization notes are updated,
2. required pack expectations are updated,
3. deterministic replay evidence exists,
4. FEC/F3E cross-repo impact is recorded.

## 7. Implementation Direction
1. OxCalc-owned executable realization is Rust-first from this point onward.
2. The active repo implementation is the Rust workspace under `src/`.
3. Historical baseline runs and checked-in artifacts remain valid evidence, but they are not a second live implementation lane.
4. Rust realization must be treated as an ab initio implementation against OxCalc specs, replay artifacts, and executable comparison surfaces, not as a mechanical translation of older non-Rust shapes or idioms.

## Source: `OxCalc/CURRENT_BLOCKERS.md`

# CURRENT_BLOCKERS.md — OxCalc

Status: no active blockers.

Last reviewed: 2026-03-15.

---

## Active Blockers

(none)

---

## Resolved Blockers

(none)

---

## Entry Template

```
### BLK-CALC-NNN: <title>

- **Status**: active | resolved | closed
- **Impact**: <which worksets/features are blocked>
- **Current state**: <what has been attempted, what failed>
- **Exact unblock steps**: <specific actions needed>
- **Recommendation**: wait | escalate | workaround
- **Opened**: YYYY-MM-DD
- **Resolved**: YYYY-MM-DD (if applicable)
```

## Source: `OxCalc/docs/IN_PROGRESS_FEATURE_WORKLIST.md`

# IN_PROGRESS_FEATURE_WORKLIST.md — OxCalc

Canonical repo-level register of feature areas that are in-progress under workset completion doctrine.

Status: active.
Last updated: 2026-03-24.

## Status Vocabulary

- `in-progress`: partial implementation or canonical spec work exists, parity/completeness not yet achieved.
- `blocked`: in-progress with active blocker (see CURRENT_BLOCKERS.md).
- `planned`: explicitly accepted into scope, no shipped work yet.

## Active Feature Register

### IP-01: Core Rewrite and Canonicalization

- **Status**: in-progress
- **Current floor**: rewritten canonical core-engine spec set drafted; bootstrap set archived; repo integration now includes first OxFml seam handoff and receiving-side acknowledgment tracking.
- **Remaining gaps**: final integration tightening, follow-on seam alignment wording, workset closure discipline, operational execution of W013, and later replay-backed evidence.
- **Why still open**: the canonical set is established, but realization and assurance closure are still outstanding.
- **Canonical owner**: W001.

### IP-02: TreeCalc Structural State and Snapshot Kernel

- **Status**: in-progress
- **Current floor**: immutable structural snapshot, builder, projection lookup, and pinned structural view are now scaffolded in code with passing tests over snapshot construction, successor identity stability, and pinning behavior.
- **Remaining gaps**: richer structural edit operations, formula-artifact integration depth, replay artifacts, and formal or assurance bindings.
- **Why still open**: the kernel now exists as executable code, but only at the initial TreeCalc floor and without downstream assurance artifacts.
- **Canonical owner**: W002.

### IP-03: Stage 1 Coordinator and Publication Baseline

- **Status**: in-progress
- **Current floor**: canonical coordinator and publication architecture is drafted, and the local Stage 1 floor is now scaffolded in code with candidate intake, accepted-candidate recording, typed reject handling, atomic publish, pinned publication views, and passing tests for candidate-versus-publication separation and reject-is-no-publish behavior.
- **Remaining gaps**: richer publication artifact emission, replay-oriented reject-detail binding, concurrency-facing safety realization, and emitted publication diagnostics.
- **Why still open**: the sequential coordinator floor exists, but assurance, artifact emission, and broader realization remain partial.
- **Canonical owner**: W003.

### IP-04: Incremental Recalc and Overlay Baseline

- **Status**: in-progress
- **Current floor**: canonical recalc and overlay architecture is drafted, and the local Stage 1 floor now executes a widened planner-driven slice with deterministic multi-node DAG scheduling, first SCC-oriented handling, fallback re-entry, emitted per-scenario counters, and passing tests plus a checked-in widened baseline run.
- **Remaining gaps**: richer runtime-effect handling, broader overlay-economics reporting, replay-appliance bundle validation and explain emission, and later concurrency-facing widening.
- **Why still open**: the widened Stage 1 slice now exists, but later evidence, replay projection, and Stage 2-facing lanes remain partial.
- **Canonical owner**: W004.

### IP-05: OxFml Seam Hardening and Handoff Closure

- **Status**: in-progress
- **Current floor**: OxCalc-local seam requirements are drafted; `HANDOFF-CALC-001` is filed and acknowledged; the stronger OxFml downstream note and `HANDOFF-FML-001` are now also received locally, giving OxCalc a stronger minimum-schema, typed reject-context, runtime-effect, and host-boundary floor to consume.
- **Remaining gaps**: replay artifacts for candidate-result versus publication boundaries, broader runtime-derived effect taxonomy beyond the Stage 1 subset, exact trace-schema mapping, and any narrower follow-on handoff if exercised evidence later requires it.
- **Why still open**: the first bilateral seam round is incorporated, but the broader seam and replay-consumption area remains active and is now carried by a successor integration packet rather than by reopening W005.
- **Canonical owner**: W020.

### IP-06: Core Formalization and Gate Binding

- **Status**: in-progress
- **Current floor**: formalization and assurance direction is drafted, W006 is active, W007 contains the first Lean-facing object inventory and transition-boundary packet, W008 contains the first TLA+-oriented coordinator-state and safety-boundary packet plus explicit Stage 1 transition bindings, W009 contains the replay-class and pack-binding matrix through `R8`, W010 contains the experiment-register and measurement-schema packet, and the repo now includes Lean, TLA+, replay-seed, measurement-schema, emitted counter, and widened baseline run artifacts; the Lean state file has been typechecked locally and the TLA+ smoke model has been checked once with TLC.
- **Remaining gaps**: theorem authoring, richer TLA+ model exploration, replay-appliance bundle validation, pack artifact creation, and later retained-witness evidence.
- **Why still open**: the assurance lane now has real widened Stage 1 evidence, but its later proof, pack, and replay-appliance lanes remain partial.
- **Canonical owner**: W006.

### IP-07: Self-Contained Test Harness Planning

- **Status**: in-progress
- **Current floor**: `W011` now includes an exercised 12-scenario `TraceCalc` corpus, validator and runner paths under [src/oxcalc-tracecalc](/C:/Work/DnaCalc/OxCalc/src/oxcalc-tracecalc), a CLI host under [src/oxcalc-tracecalc-cli](/C:/Work/DnaCalc/OxCalc/src/oxcalc-tracecalc-cli), crate-local tests, and checked-in emitted baseline runs at `w013-sequence-a-baseline`, `w014-stage1-widening-baseline`, and `w017-rust-parity-baseline`.
- **Remaining gaps**: replay-appliance bundle export, richer retained-failure handling, larger generated-corpus lanes, and later OxFml-integrated harness coverage.
- **Why still open**: the widened self-contained harness slice is exercised, but later replay, retained-witness, and integrated-host lanes remain partial.
- **Canonical owner**: W011.

### IP-08: TraceCalc Reference Machine and Conformance Oracle

- **Status**: in-progress
- **Current floor**: `W012` now includes an executable `TraceCalc Reference Machine`, an engine adapter, conformance comparison logic, planner-driven DAG and SCC coverage, and checked-in emitted oracle/conformance baseline runs for both the original and widened 12-scenario corpora.
- **Remaining gaps**: richer trace comparison policy beyond the first conformance surface, replay-appliance bundle validation, reduced-witness flows, and later continuous engine-versus-oracle series beyond the current baseline runs.
- **Why still open**: the oracle is exercised over the widened Stage 1 slice, but later replay-appliance and retained-witness lanes remain partial.
- **Canonical owner**: W012.

### IP-09: Replay Appliance Adapter Rollout

- **Status**: in-progress
- **Current floor**: `W015` now has an execution-ready packet, local replay-coherence refactor direction, explicit adapter and capability-manifest docs, normalized event-family projection embodied in runner output, typed local mismatch projection fields, and replay-facing scenario metadata carried in the checked-in corpus and active widened baseline run.
- **Remaining gaps**: normalized replay-appliance bundle emission, bundle-validator conformance artifacts, explain records, capability promotion beyond the current conservative floor, and later pack-facing rollout.
- **Why still open**: local replay coherence and adapter doctrine are now in place, but the emitted-bundle and capability-promotion lane is now carried by `W018`.
- **Canonical owner**: W015.

### IP-10: Rust-First Reimplementation of Current Realized Scope

- **Status**: in-progress
- **Current floor**: the declared current realized scope now has a Rust execution path under `src/` covering the structural snapshot kernel, coordinator/publication baseline, recalc/overlay baseline, `TraceCalc` runner/reference-machine lane, and Rust CLI host, all validated under `cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings`, and `cargo test`, with a distinct emitted run at `w017-rust-parity-baseline` and a passing parity comparison against `w014-stage1-widening-baseline`.
- **Remaining gaps**: later Stage 2 and concurrency realization in Rust, replay-appliance bundle emission in Rust, retained-witness flows after W016, and later archival policy for superseded historical implementation artifacts.
- **Why still open**: W017 reached its final gate for the current declared scope, but the broader Rust-first feature area remains active for later widening, replay, and retained-witness lanes.
- **Canonical owner**: W017.

### IP-11: Witness Distillation and Retained Failure Packs

- **Status**: in-progress
- **Current floor**: `W016` has reached its declared gate with deterministic witness-seed artifacts, explicit lifecycle-state handling for `wit.generated_local`, `wit.explanatory_only`, `wit.quarantined`, one replay-valid retained-local witness family, a retained-failure fixture runner, and a checked-in retained-failure baseline run.
- **Remaining gaps**: candidate journals, richer witness bundles beyond scenario copies, additional retained-local mismatch families, later pack-facing promotion evidence, and any successor workset for broader retained-failure widening.
- **Why still open**: W016 has discharged its declared scope, but the broader retained-witness feature area remains active beyond this first retained-failure baseline.
- **Canonical owner**: W016.

### IP-12: Replay Appliance Bundle Emission and Capability Promotion

- **Status**: in-progress
- **Current floor**: `W019` has now reached its declared gate with additive replay-appliance bundle roots for ordinary and retained-failure runs, bundle-validator artifacts, explain records, checked-in ordinary and retained-failure baselines, replay-valid reduced-witness distillation artifacts, run-level `distill_validation.json`, and a refreshed capability claim through `cap.C4.distill_valid`. `W021` then converted the pack-grade gap into bounded emitted blockers, and `W022` added both a checked-in direct-binding-sensitive retained-local baseline in `w022-sequence1-direct-binding-family` and a checked-in retained-shared family baseline in `w022-sequence2-shared-lifecycle-family`, plus an explicit `pack_grade_decision.json` that keeps `cap.C5.pack_valid` unclaimed for the current semantic-only scope and defers any narrower handoff. `W023` then emitted explicit program-grade contract, validation, and decision sidecars across `w023-sequence1-program-scope-contract`, `w023-sequence2-host-sensitive-family`, and `w023-sequence3-program-decision`, keeping `cap.C5.pack_valid` unclaimed and packetizing the broader residual in `W024`.
- **Remaining gaps**: broader program-scope pack evidence beyond the current exercised host-sensitive `TraceCalc` family, broader mismatch-family explain coverage, any narrower handoff if later pack-grade promotion creates stronger seam pressure, and later pack-grade replay governance.
- **Why still open**: W023 reached its declared gate by making the broader program-grade capability and handoff decisions explicit, but the broader pack-promotion feature area remains active and is now carried by W024.
- **Canonical owner**: W024.

### IP-13: OxFml Downstream Integration Rounds

- **Status**: in-progress
- **Current floor**: OxCalc now has a local receipt for `HANDOFF-FML-001`, an outbound `NOTES_FOR_OXFML.md` reply, a returned OxFml topic-by-topic classification pass, the later OxFml clarification that the current OxFunc refinement adds no new OxCalc-facing seam trigger, a processed intake of `OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md` as the bounded host/runtime packet for the next coordinator-host round, and an explicit OxFml reply agreeing that the host/runtime packet is strong enough for the first implementation slice. W019 has now also exercised the previously bounded dependency-projection and semantic-display questions without producing a new formal seam trigger.
- **Current seam-reference rule**: downstream hosts that use OxCalc docs as seam-reference material should use `docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` plus `CORE_ENGINE_OXFML_SEAM.md` as the local authority floor, and treat `CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md` as a residual-topic tracker rather than as seam authority.
- **Remaining gaps**: later downstream rounds may still be needed if stronger coordinator pressure appears around execution-restriction transport, publication/topology consequence breadth, or caller-anchor/address-mode carriage for the first TreeCalc relative-reference subset. Those three residuals are now being carried as an explicit three-sequence W026 narrowing packet, and the latest OxFml reply keeps all three as `canonical but narrower` with no current handoff trigger. Availability/provider-failure and callable-publication remain watch lanes only.
- **Why still open**: round 01 is materially processed and the host/runtime packet is now consumed as a planning floor with explicit OxFml agreement, but the broader downstream integration feature area remains active for future OxFml/OxFunc pressure and any later narrower handoff.
- **Canonical owner**: W020.

### IP-14: TreeCalc Semantic Completion

- **Status**: in-progress
- **Current floor**: the target and execution line are now defined in `CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`, packetized into `W025` through `W031`, and the first TreeCalc local implementation floor now exists in Rust: widened structural snapshots with formula/bind attachment points, relative-reference context, immutable structural edits, a TreeCalc-local formula and reference model, an OxFml-backed direct-host translation/bind/evaluate slice in the local sequential runtime, dependency graph build seeded from the translated OxFml bind preparation plus explicit residual carriers, verified-clean handling, coordinator-facing candidate adaptation and publication through the seam-backed path, a reusable widened minimal upstream host packet and adapter in `src/oxcalc-core/src/upstream_host.rs` for deterministic OxFml-facing automated scaffolding, richer typed host-info stand-ins, RTD stand-ins, in-memory runtime catalog snapshot carriage, first replay-capture packet projection, explicit crate-level scaffolding tests in `src/oxcalc-core/tests/upstream_host_scaffolding.rs`, a first checked-in upstream-host fixture corpus under `docs/test-fixtures/core-engine/upstream-host` that now also covers the agreed first table-context packet plus four bounded evaluator-facing structured-reference families, first local runtime-effect emission for host-sensitive and dynamic-reference families, a first local runtime-effect overlay carrier, a checked-in thirteen-case TreeCalc fixture corpus under `docs/test-fixtures/core-engine/treecalc`, a first emitted local run root at `docs/test-runs/core-engine/treecalc-local/w025-treecalc-local-baseline` with local oracle, conformance, trace, explain, and post-edit rebind, recalc-only, downstream dependency-chain, post-edit runtime-effect/overlay, mixed branch-sensitive seam behavior, move-triggered, and removal sidecars against fixture-declared expectations, and a first compare script at `scripts/compare-treecalc-local-run.ps1` so that local TreeCalc baselines are rerunnable and comparable rather than inspect-only.
- **Remaining gaps**: broader consumed OxFml bind/reference intake beyond the current direct-host slice, broader dependency graph build from richer bind products than the current translated name-backed carrier subset, runtime-derived effect closure beyond the first local rejection-sidecar and overlay floor, first TreeCalc corpus and baseline beyond the current local pre-oracle local-fixture shape, replay/diff/explain widening beyond the current local sidecars, broader structural-edit and successor-snapshot families beyond the current representative set, and assurance refresh.
- **Why still open**: the first seam-backed TreeCalc local pipeline now exists, but the broader first TreeCalc-ready engine scope and assurance lane are not realized yet.
- **Canonical owner**: W025.

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_ARCHITECTURE.md`

# CORE_ENGINE_ARCHITECTURE.md

## 1. Purpose and Status
This document defines the top-level architecture for the rewritten OxCalc core-engine spec set.

Status:
1. active rewrite baseline,
2. intended authoritative architecture for OxCalc core-engine work,
3. TreeCalc-first in immediate execution scope,
4. subject to supporting-detail expansion in companion documents rather than ad hoc drift.

This document is intentionally architecture-defining rather than implementation-minimal.
It exists to make the intended OxCalc engine shape explicit before realization work proceeds.

## 2. Architectural Mission
OxCalc defines the multi-node core calculation engine lane for DNA Calc.

For the current rewrite, the engine mission is:
1. build the core engine required for DNA TreeCalc first,
2. do so on a tree-based substrate with no grid as baseline scope,
3. preserve deterministic semantics under staged runtime strategy changes,
4. build from the start toward a fast, scalable, high-quality incremental engine,
5. make the OxFml evaluator boundary explicit and robust,
6. carry near-formal specification and verification into the architecture itself.

## 3. Immediate Target: DNA TreeCalc
The first serious OxCalc target is the engine needed for DNA TreeCalc.

This target deliberately constrains immediate scope:
1. tree-based structure,
2. no grid substrate,
3. no hidden grid assumptions in baseline architecture text,
4. no requirement that reference syntax exactly mirror Excel A1 surface forms,
5. explicit room for tree-host-oriented reference forms and projection rules,
6. later grid introduction as a major phase rather than a baseline premise.

Interpretation rule:
1. TreeCalc-first does not mean "toy" or "temporary."
2. TreeCalc-first means the initial executable engine proves the core architectural model on a simpler substrate before grid complexity is introduced.
3. All baseline semantics for TreeCalc must remain consistent with later expansion to a broader substrate.

## 4. Architectural Pillars

### 4.1 Immutable Structural Truth
Immutable structural truth is foundational.

The architecture must treat the following as immutable, versioned truth:
1. core tree structure,
2. stable node identity,
3. structural metadata that defines engine-observable shape,
4. immutable formula artifacts and bind products received from OxFml or derived through explicit versioned seams.

This rule exists for correctness first and reuse second:
1. runtime work must not silently mutate canonical structure,
2. stable snapshots must remain safely observable during later recalculation work,
3. replay and proof obligations become tractable only if truth is versioned and immutable,
4. future concurrency depends on readers being able to observe stable state without coordinator races.

Roslyn-style persistence lessons are adopted as architectural guidance:
1. immutable core structures should be context-free and compact,
2. context-bearing facades and cached projections should be derived and ephemeral,
3. edits should respin only the affected immutable spine and changed payloads,
4. unchanged substructures should be preserved by identity when semantics allow.

### 4.2 Versioned Runtime and MVCC-Derived State
Runtime state is not structural truth.

Runtime state includes:
1. invalidation state,
2. dependency overlays,
3. recalculation scheduling state,
4. pinned-reader and observer state,
5. publication bookkeeping,
6. reusable derived caches,
7. other epoch-scoped execution state.

The architecture requires this state to be:
1. explicitly versioned,
2. attached to immutable structural snapshots by epoch and fence rules,
3. safe under pinned-reader semantics,
4. evictable by deterministic epoch-safe rules,
5. observable through stable views even while later work is underway.

This is an MVCC-style discipline, but the engine should not rely on slogan-level MVCC language.
The spec set must define actual snapshot, fence, publish, reject, and retention semantics.

### 4.3 Single-Publisher Coordinator Authority
The baseline engine has one publication authority: the coordinator.

The coordinator is the single authority for:
1. snapshot acceptance and epoch advancement,
2. commit acceptance or rejection,
3. atomic publication of derived results,
4. runtime overlay lifecycle decisions that affect committed visibility,
5. safe observer-facing state transitions.

This is a baseline safety rule, not a performance concession.
Parallel evaluation may be introduced later, but parallel evaluators do not bypass the coordinator.

### 4.4 Staged Concurrent and Async Design
Concurrency and asynchronous recalculation are designed in from the start.

The architecture must be written so that:
1. Stage 1 sequential realization is a strict subset of the intended concurrent design,
2. later async and multithreaded work does not require replacing the structural model,
3. snapshot fences, publication rules, reject semantics, and observer visibility rules are already strong enough for staged concurrency,
4. deterministic replay remains mandatory under concurrent and async execution.

### 4.5 Near-Formal Assurance Architecture
Near-formal modeling is part of the architecture itself.

The rewritten OxCalc architecture must map claims to:
1. Lean-facing semantic models and theorem targets,
2. TLA+ concurrency and async models,
3. replay artifacts,
4. conformance packs,
5. deterministic empirical measurements where proof alone is insufficient.

Architectural text that cannot be expressed in one of these assurance forms should be treated carefully and explicitly labeled if still provisional.

## 5. Layered Engine Model
The engine is organized around explicit layers with strict truth/derived/runtime boundaries.

### 5.1 Structural Snapshot Layer
This layer contains immutable TreeCalc structural truth.

It includes:
1. node identity,
2. parent/child structural relationships,
3. structural metadata relevant to calculation,
4. references to immutable formula/bind artifacts as needed,
5. version identity for the snapshot itself.

This layer is the base object observed by higher layers.

### 5.2 Evaluator Artifact Layer
OxCalc depends on OxFml for formula-language and evaluator-facing artifacts.

For OxCalc architecture purposes, these artifacts are treated as:
1. immutable inputs to coordinator and dependency logic,
2. versioned by token/profile/bind context,
3. subject to explicit seam contracts rather than implicit mutation.

OxCalc does not own formula grammar or evaluator semantics, but it does own how these artifacts participate in coordinator, scheduling, publication, and replay behavior.

### 5.3 Structural Dependency Layer
This layer contains the dependency structure derivable from structural truth and stable evaluator artifacts.

Baseline properties:
1. deterministic derivation,
2. explicit forward and reverse dependency relations,
3. explicit cycle-region handling,
4. no hidden mutation from runtime discovery.

### 5.4 Runtime Overlay Layer
This layer contains epoch-scoped runtime-derived state that cannot be treated as immutable structural truth.

Examples include:
1. dynamic-dependency observations,
2. runtime invalidation state,
3. versioned dependency or capability overlays,
4. observer-facing scheduling metadata,
5. later-phase substrate-specific overlays.

The overlay layer is explicit because runtime-discovered behavior must not be represented as silent mutation of the structural dependency graph.

### 5.5 Publication and Observer Layer
This layer governs what stable state is visible to readers and subscribers.

It includes:
1. committed snapshot identity,
2. stabilized or published calculation view,
3. status signaling such as stale/pending/ready/error as defined by companion docs,
4. publication ordering and atomicity rules,
5. observer pinning and snapshot visibility rules.

## 6. Structural Identity and Projection Rules
Baseline identity is stable-ID based, not projection-text based.

The architecture therefore distinguishes:
1. identity,
2. projection,
3. reference syntax.

Identity:
1. engine truth is keyed by stable IDs appropriate to the tree substrate.

Projection:
1. user-facing or host-facing reference forms may be derived from structural state,
2. projection formats may differ by host or profile,
3. projection changes must not redefine engine identity.

Reference syntax:
1. TreeCalc may use reference forms that differ from Excel grid-address conventions,
2. later grid introduction may add projection families without invalidating the identity model.

## 7. Recalc and Incremental Architecture Direction
The architecture is conservative in scope but not timid in design.

### 7.1 Baseline Recalc Direction
The baseline recalc engine is deterministic and topo/SCC-based.

Required baseline traits:
1. deterministic scheduling order,
2. explicit cycle-region handling,
3. explicit invalidation-state model,
4. strong replay compatibility,
5. conservative fallback when later-stage optimization conditions are not met.

### 7.2 Incremental Ambition From The Start
Although Stage 1 realization may be conservative, the architecture is explicitly aimed at a strong incremental engine.

This means the spec must carry forward:
1. explicit invalidation-state semantics,
2. verification-oriented recalculation direction,
3. early-cutoff design intent,
4. runtime-observed dependency support through overlays,
5. instrumentation and decisive experiments to validate high-value optimization lanes.

The architecture must not pretend that dirty-closure-only thinking is sufficient for the intended long-term engine.

### 7.3 Dynamic Dependency Discipline
Dynamic references and other runtime-discovered dependency behaviors are first-class architectural concerns.

They must be handled through explicit runtime-derived state and explicit replay/proof obligations.
They must not be smuggled into the engine as ad hoc exceptions to a purely static dependency story.

### 7.4 Dynamic-Topo and SAC-Inspired Lanes
Advanced lanes such as dynamic topological maintenance and SAC-inspired repair remain intended design space, but not baseline realization commitments.

They are:
1. architecturally anticipated,
2. explicitly named in the roadmap,
3. subject to promotion by parity, replay, and economics evidence.

## 8. Snapshot, Epoch, and Publication Architecture
The engine must distinguish structural change, recalculation work, and observable publication.

At the top level, the architecture requires:
1. immutable structural snapshots,
2. epoch-bearing runtime state and publication fences,
3. stable observer-visible views,
4. atomic accepted-commit publication,
5. strict no-publish reject semantics.

Two rules are mandatory:
1. no observer may be forced to read a torn hybrid of incompatible structural/runtime state,
2. no accepted derived publication may be partially visible.

The detailed epoch model belongs in companion documents, but these invariants belong in the architecture itself.

## 9. Coordinator and OxFml Seam Architecture
OxCalc owns coordinator policy and publication semantics.
OxFml owns evaluator semantics and canonical shared seam specification.

The architecture must therefore make the coordinator-facing seam explicit.

That seam includes:
1. session and snapshot expectations,
2. token and capability fence implications,
3. commit acceptance and rejection consequences,
4. publication payload expectations for accepted work,
5. replay-oriented reject detail requirements,
6. ownership boundaries for what OxCalc may specify locally versus what must be handed off to OxFml.

The architecture should be written so that seam hardening is a normal follow-on activity, not a late clarification exercise.

## 10. Staged Realization Model

### 10.1 Stage 1
Stage 1 is the first realization baseline.

Its role is to prove:
1. immutable structural snapshot discipline,
2. deterministic topo/SCC coordinator behavior,
3. single-publisher commit and publication authority,
4. explicit epoch and replay rules,
5. stable observer view under ongoing work,
6. TreeCalc-first substrate semantics.

### 10.2 Stage 2
Stage 2 introduces partitioned or concurrent evaluator work behind the same coordinator publication authority.

Its role is to prove:
1. fence correctness under concurrency,
2. deterministic contention handling and replay,
3. safe publication under pinned-reader and observer constraints,
4. concurrency without semantic drift.

### 10.3 Stage 3 and Beyond
Stage 3 and beyond may introduce more ambitious runtime strategies, but only through explicit promotion gates.

No later-stage optimization is allowed to redefine baseline semantic truth.

## 11. TreeCalc-First, Grid-Later Boundary
This architecture intentionally separates:
1. core engine truth and coordinator design,
2. TreeCalc-first proving scope,
3. later grid introduction.

The later grid phase may add:
1. richer projection rules,
2. substrate-specific rewrite semantics,
3. more complex region and occupancy behavior,
4. later-phase overlay classes.

But it must fit into the same architectural pillars:
1. immutable structural truth,
2. versioned runtime and publication layers,
3. coordinator publication authority,
4. near-formal assurance discipline.

## 12. Formalization Direction
The architecture requires a supporting formalization program.

At minimum, the companion assurance document must define:
1. Lean-facing state and transition structures,
2. theorem targets for replay determinism and no hidden structural mutation,
3. TLA+ models for coordinator safety, async/concurrent publication, and pinned-epoch GC,
4. replay artifact requirements,
5. empirical pack obligations and decisive experiments.

Near-formal here means:
1. not every clause is proven immediately,
2. but every major architectural claim is expected to route toward proof, model-checking, or deterministic evidence.

## 13. Explicit Non-Baseline Items
The following are not baseline realization commitments in the immediate TreeCalc engine, even if they remain part of the broader architecture discussion:
1. grid-native substrate semantics,
2. grid-driven spill/occupancy baseline behavior,
3. default adoption of dynamic-topological maintenance,
4. default adoption of SAC-style repair as the first realization strategy,
5. speculative or lock-free publication paths.

These may remain staged-later lanes or deferred material, but they are not to be smuggled into the TreeCalc baseline through vague wording.

## 14. Relationship To Companion Documents
This top-level architecture document is complemented by:
1. `CORE_ENGINE_STATE_AND_SNAPSHOTS.md`
2. `CORE_ENGINE_RECALC_AND_INCREMENTAL_MODEL.md`
3. `CORE_ENGINE_OVERLAY_AND_DERIVED_RUNTIME.md`
4. `CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md`
5. `CORE_ENGINE_OXFML_SEAM.md`
6. `CORE_ENGINE_FORMALIZATION_AND_ASSURANCE.md`
7. `CORE_ENGINE_REALIZATION_ROADMAP.md`

Those documents provide the detailed semantics, staged realization, and assurance mapping.
This document sets the architectural frame they must remain consistent with.

## 15. Status
- execution_state: in_progress
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - supporting companion docs not yet drafted,
  - exact Stage 1 incremental wording still to be tightened in the recalc model,
  - OxFml handoff clauses not yet extracted into a handoff packet

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md`

# CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md

## 1. Purpose and Status
This document defines the OxCalc coordinator, publication, and staged concurrency model for the rewritten core-engine spec set.

Status:
1. active rewrite baseline,
2. intended canonical companion for commit and publication authority,
3. TreeCalc-first in immediate realization scope,
4. staged for later concurrent and async realization.

This document defines:
1. coordinator authority,
2. accepted and rejected work consequences,
3. publication boundaries,
4. observer-visible stability rules,
5. staged concurrency and async progression,
6. core assurance targets for coordinator behavior.

## 2. Coordinator Mission
The coordinator is the single authority that turns evaluator-produced candidate runtime work into stable engine-visible consequences.

Its mission is to:
1. govern snapshot and fence compatibility,
2. accept or reject candidate work,
3. publish accepted results atomically,
4. prevent rejected work from leaking into stable publication,
5. preserve stable views for readers and observers,
6. stage concurrency without semantic drift.

## 3. Single-Publisher Rule
The baseline engine has one publication authority: the coordinator.

This rule means:
1. no evaluator or runtime worker publishes committed state directly,
2. all observer-visible committed state transitions pass through coordinator logic,
3. accepted-commit atomicity is defined centrally,
4. reject semantics are enforced centrally.

This is a correctness rule first and a coordination rule second.

## 4. Coordinator Responsibilities
At the architecture level, the coordinator is responsible for:
1. structural snapshot and fence awareness,
2. runtime work admission and compatibility checks,
3. commit acceptance or rejection,
4. publication of stable observer-visible state,
5. retention constraints that affect pinned-reader safety,
6. staged concurrency arbitration,
7. replay-visible reject and contention behavior where required.

The coordinator may delegate computation, but it may not delegate final publication authority.

## 5. Fence and Compatibility Model

### 5.1 Fence Principle
Any candidate work intended for publication must be checked against the relevant compatibility boundaries.

These boundaries may include:
1. structural snapshot compatibility,
2. token or artifact compatibility,
3. profile or version compatibility,
4. capability or fence compatibility,
5. publication-state compatibility.

### 5.2 Why Fences Matter
Fences exist so that:
1. work computed against stale assumptions is not silently published,
2. replay can explain accept or reject outcomes,
3. staged concurrency does not weaken correctness,
4. stable observer views remain coherent.

### 5.3 Reject Consequence
When compatibility conditions do not hold, the coordinator rejects candidate work rather than publishing partially compatible state.

## 6. Accepted-Commit Publication Rule

### 6.1 Atomicity
An accepted commit publishes one atomic stable bundle of consequences for the accepted work unit.

Atomic here means:
1. the stable observer-visible consequences appear together,
2. partially visible accepted publication is forbidden,
3. publication is tied to a coherent snapshot and fence basis.

### 6.2 Publication Content
The exact bundle schema is defined by seam and supporting documents, but at architecture level the coordinator publishes a coherent derived result package rather than disconnected mutable fragments.

Where OxFml canonical seam language applies, that publication package is produced from an evaluator-side `AcceptedCandidateResult` that remains distinct from publication until coordinator acceptance.

### 6.3 Publication Ordering
Publication ordering must be deterministic for the declared mode.

The coordinator may expose progress or staged stabilization behavior where later documents allow it,
but it may not do so through semantically ambiguous partial publication.

## 7. Reject-Is-No-Publish Rule

### 7.1 Core Rule
Rejected work publishes no stable accepted state.

### 7.2 Consequences
This means:
1. no accepted result fragment is visible from rejected work,
2. no observer-visible publication state advances based on rejected work,
3. no internal optimization shortcut may treat rejected work as if it were accepted publication.

### 7.3 Diagnostics and Replay
Reject information may still be preserved for:
1. diagnostics,
2. replay,
3. pack evidence,
4. migration or seam analysis.

But diagnostic preservation is not publication.

## 8. Observer-Visible Stability Rules

### 8.1 Stable View Rule
The coordinator must preserve stable observer-visible views.

Readers and observers see:
1. a coherent structural snapshot,
2. a coherent published runtime view for that snapshot and fence basis,
3. status signaling that is valid for that view.

### 8.2 No Torn Publish Rule
The coordinator must prevent torn observer-visible states such as:
1. partially published accepted work,
2. publication from incompatible fence bases,
3. rejected work leaking into the stable view,
4. overlay consequences becoming visible without authorized publication.

### 8.3 Ongoing Recalc Rule
Ongoing work may continue while observers read stable prior state.

That ongoing work must not retroactively mutate what a pinned observer sees.

## 9. Stage 1 Baseline Coordinator

### 9.1 Scope
Stage 1 is the sequential single-publisher baseline.

### 9.2 Required Properties
Stage 1 must prove:
1. the coordinator owns publication,
2. deterministic accept or reject behavior,
3. stable observer-visible state,
4. explicit fence discipline,
5. replay-compatible rejection behavior,
6. TreeCalc-first realization on a simpler substrate.

### 9.3 What Stage 1 Does Not Need To Prove Yet
Stage 1 does not need to prove full parallel evaluation throughput.
It does need to prove the coordinator architecture that later concurrency will depend on.

## 10. Stage 2 Concurrent and Async Progression

### 10.1 Scope
Stage 2 introduces partitioned, concurrent, or asynchronous evaluator work behind the same coordinator authority.

### 10.2 Invariants That Must Not Change
Stage 2 must preserve:
1. single publication authority,
2. accept or reject fence discipline,
3. stable observer-visible state,
4. deterministic replay obligations,
5. no semantic drift from baseline truth.

### 10.3 New Obligations
Stage 2 introduces additional obligations such as:
1. deterministic contention handling,
2. replay-visible concurrency outcomes where required,
3. safe interaction with pinned readers,
4. publication discipline under overlapping runtime work.

## 11. Async and In-Flight Work
The architecture allows ongoing work to exist without becoming stable publication.

This distinction is essential.

In-flight work may:
1. produce an evaluator-side `AcceptedCandidateResult`,
2. produce internal runtime state,
3. wait on compatibility checks,
4. be rejected.

In-flight work may not:
1. redefine stable observer-visible truth by default,
2. bypass coordinator publication,
3. force torn state onto readers.

## 12. Coordinator and Overlay Interaction
The coordinator governs whether overlay-derived consequences matter to stable publication.

This means:
1. overlays may inform evaluator-produced candidate work,
2. overlays may influence accept or reject decisions,
3. overlays may be retained or evicted under coordinator-aware safety rules,
4. overlay consequences reach stable observers only through coordinator-controlled publication.

## 13. Coordinator and OxFml Interaction
The coordinator depends on OxFml evaluator work and seam discipline, but publication authority remains in OxCalc.

The coordinator therefore requires a seam that supports:
1. explicit candidate-work boundaries,
2. explicit compatibility and fence information,
3. explicit `AcceptedCandidateResult` payload structure,
4. explicit reject-detail structure suitable for replay and diagnostics.

Detailed ownership and handoff text belongs in the dedicated seam document.

## 14. Contention and Retry Direction
Later concurrent stages may require contention and retry policy.

The architecture locks only the high-level rule here:
1. contention behavior must be explicit,
2. retry behavior must be deterministic under the declared mode where replay requires it,
3. contention resolution must not bypass publication fences,
4. fallback or retry policy must be visible to assurance and evidence tooling where required.

## 15. Publication and Stabilization
The coordinator governs when evaluator-produced candidate work becomes stable published state.

The architecture distinguishes:
1. structural truth,
2. runtime in-flight work,
3. stable published view.

Stabilization and publication policy may evolve in detail, but it must remain true that:
1. stable publication is explicit,
2. accepted publication is atomic,
3. rejected work is no-publish,
4. observer-visible state remains coherent.

## 16. Stage 1 Local Candidate and Reject Packet

### 16.1 AcceptedCandidateResult Intake Minimum
The minimum Stage 1 OxCalc-local `AcceptedCandidateResult` intake packet should contain:
1. `candidate_result_id`
2. `struct_snapshot_id`
3. `artifact_token_basis`
4. `compatibility_basis`
5. `target_set`
6. `value_updates`
7. `dependency_shape_updates`
8. `runtime_effects`
9. `diagnostic_events`

This is the minimum local coordinator intake surface required to preserve candidate-versus-publication separation while still allowing atomic publish, typed reject, and replay-friendly diagnostics.

### 16.2 Publication Bundle Minimum
The minimum Stage 1 OxCalc-local publication bundle derived from an accepted candidate result should contain:
1. `publication_id`
2. `candidate_result_id`
3. `published_view_delta`
4. `published_runtime_effects`
5. `counter_deltas`
6. `trace_markers`

This is the minimum observer-facing stable publication surface for the Stage 1 coordinator.
The exact shared canonical field names may differ on the OxFml side, but the coordinator-local publication consequences are fixed to this minimum shape.

### 16.3 Stage 1 Reject Taxonomy
The minimum Stage 1 coordinator-local reject classes should be:
1. `snapshot_mismatch`
2. `artifact_token_mismatch`
3. `profile_version_mismatch`
4. `capability_mismatch`
5. `publication_fence_mismatch`
6. `dynamic_dependency_failure`
7. `synthetic_cycle_reject`
8. `host_injected_failure`

These classes are the local Stage 1 floor for coordinator reasoning, replay classification, and typed no-publish behavior.
They do not claim that the shared OxFml canonical taxonomy is closed.

## 17. Formalization Direction
Coordinator behavior is one of the highest-priority near-formal areas in the core engine.

Expected assurance consequences include:
1. TLA+ state and transition modeling for coordinator safety,
2. safety properties for no torn publication,
3. safety properties for reject-is-no-publish,
4. safety properties for pinned-reader stability,
5. liveness or progress analysis for staged concurrent and async execution where applicable,
6. replay and pack obligations for contention and reject behavior.

## 18. Open Detailed Questions
These remain detailed follow-on questions within the now-locked architecture:
1. exact in-flight progress publication policy if any,
2. exact contention and retry policies for later stages,
3. exact relationship between stabilized state markers and observer APIs,
4. exact pack and trace binding for the now-locked Stage 1 candidate and reject classes,
5. exact promotion path from the Stage 1 local packet shape to later richer comparison and replay payloads.

## 19. Status
- execution_state: in_progress
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - replay artifacts still needed for candidate-result versus publication behavior,
  - the Stage 1 local packet shape is now explicit, but pack and trace binding still need W009 realization,
  - no exercised coordinator implementation or emitted publication artifacts exist yet

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md`

# CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md

## 1. Purpose and Status
This document defines the narrow OxCalc documentation slice that downstream hosts should use as seam-reference material.

Status:
1. active canonical companion,
2. downstream-host facing in emphasis,
3. intended for hosts such as `DNA OneCalc` that drive `OxFml` but do not depend on the OxCalc runtime,
4. interpretation-only and not a production host API freeze.

## 2. Why This Exists
`OxCalc` is not a required runtime dependency for a first downstream single-node host such as `DNA OneCalc`.

But the host-facing seam used to drive `OxFml` overlaps materially with the seam already consumed and documented between `OxCalc` and `OxFml`.

This note exists so downstream hosts can answer three questions without reading planning or historical material as if it were canonical:
1. which OxCalc docs are authoritative local seam-reference material,
2. which adjacent docs are supporting or temporary companions only,
3. which local docs are historical, mirrored, or negotiation-state material and therefore must not be treated as the shared seam source of truth.

## 3. Interpretation Rule
The seam is shared, but authority is split.

Interpret the OxCalc-local seam-reference slice under these rules:
1. `OxFml` remains authoritative for evaluator-side semantics, host-policy semantics, and the canonical shared seam meaning,
2. `OxCalc` is authoritative only for its local coordinator-facing consumption, publication, and host-packet interpretation requirements,
3. downstream hosts may use OxCalc docs to understand consumed host-packet shape and coordinator-facing non-assumptions,
4. downstream hosts must not treat OxCalc docs as permission to invent a private evaluator contract when OxFml has not frozen the shared meaning.

## 4. Authoritative OxCalc Seam-Reference Slice
The authoritative local seam-reference set for downstream hosts is:
1. `README.md`
2. `CHARTER.md`
3. `OPERATIONS.md`
4. `CURRENT_BLOCKERS.md`
5. `docs/IN_PROGRESS_FEATURE_WORKLIST.md`
6. `docs/spec/README.md`
7. `docs/spec/core-engine/CORE_ENGINE_ARCHITECTURE.md`
8. `docs/spec/core-engine/CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md`
9. `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`
10. this document

These files are the local authority set because they define:
1. repo scope and ownership,
2. handoff and completion discipline,
3. current blocker and active-work status,
4. canonical spec filtering,
5. the coordinator-facing seam requirements that OxCalc expects to consume.

## 5. Supporting Companions For Downstream Hosts
The following docs are valid downstream reference material, but they are supporting companions rather than the core OxCalc authority set:
1. `docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`
2. `docs/spec/core-engine/CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`
3. `docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md`

Use them this way:
1. `CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md` is the first implementation-backed deterministic upstream-host packet companion and is useful when a downstream host needs to understand the currently exercised packet shape that drives real `OxFml` paths,
2. `CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md` is the right local reference for how OxCalc intends to consume OxFml-backed bind and evaluation products in the first TreeCalc-ready engine,
3. `CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md` is only the temporary tracker for narrower open topics and non-assumptions that remain under note exchange.

## 6. Non-Authority And Historical Material
The following local material must not be treated as the current OxCalc seam-reference source of truth:
1. `docs/spec/fec-f3e/*` because it is an OxFml-owned mirror set,
2. `docs/spec/core-engine/FOUNDATION_ARCHITECTURE_SNAPSHOT.md` and `docs/spec/core-engine/FOUNDATION_OPERATIONS_SNAPSHOT.md` because they are local Foundation snapshots,
3. `docs/upstream/*` because those are note-exchange and observation docs rather than canonical seam text,
4. `docs/handoffs/*` because handoffs and receipts are state records, not stable seam-reference docs,
5. `docs/spec/core-engine/archive/*` because archive content is historical by design.

## 7. Downstream Host Packet Rule
For downstream hosts, the current OxCalc host-packet reference rule is:
1. use `CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md` only as the first deterministic packet reference,
2. treat that packet as implementation-backed reference material rather than as a frozen production API,
3. keep any downstream interpretation aligned with `CORE_ENGINE_OXFML_SEAM.md`,
4. escalate shared seam changes through `OxFml` canonical docs and then update OxCalc local seam-reference docs as needed to avoid drift.

This matters especially for:
1. caller-anchor or relative-reference carriage,
2. execution-restriction transport,
3. publication and topology consequence breadth,
4. broader registered-external semantics.

## 8. Evidence-Backed Current Floor
The first deterministic host-packet floor described here is backed by current local code and fixtures:
1. `src/oxcalc-core/src/upstream_host.rs`
2. `src/oxcalc-core/src/treecalc.rs`
3. `src/oxcalc-core/tests/upstream_host_scaffolding.rs`
4. `docs/test-fixtures/core-engine/upstream-host/README.md`
5. `docs/test-fixtures/core-engine/upstream-host/MANIFEST.json`

Those artifacts prove the local floor is more than planning text, but they do not change the ownership split in Section `3`.

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`

# CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md

## 1. Purpose and Status
This document defines the first OxCalc-owned minimal upstream host interface package used to drive OxFml in deterministic automated scaffolding.

Status:
1. active implementation companion,
2. scoped to the first deterministic host-stand-in packet for automated tests,
3. not a freeze of the production OxCalc coordinator API,
4. intentionally narrower than the full W026 seam intake.

For downstream hosts such as `DNA OneCalc`, this document is seam-reference material only.
It describes the first implementation-backed packet that can drive real `OxFml` paths, but it does not make OxCalc a runtime dependency and it does not freeze a final host API.

## 2. Why This Exists
OxCalc now has a first seam-backed TreeCalc lane, but OxFml consumption should not depend on ad hoc host construction embedded inside one runtime path.

For automated scaffolding we need:
1. a reusable packet carrying host/coordinator-owned truths,
2. a deterministic adapter that can drive real OxFml parse, bind, semantic-plan, evaluation, candidate, and commit behavior,
3. a minimal field set that is honest about current ownership without over-freezing later coordinator APIs.

## 3. Ownership Rule
This minimal package preserves the current shared ownership split.

### 3.1 OxCalc-owned
OxCalc owns:
1. the stand-in packet as a test-host and coordinator-input carrier,
2. caller anchor and structure-context identity as host-owned truths,
3. cell fixtures, defined-name bindings, and table context supplied into OxFml,
4. the decision to widen this packet later or wrap it in a larger production coordinator transport.

### 3.2 OxFml-owned
OxFml remains authoritative for:
1. formula grammar and bind meaning,
2. evaluator semantics,
3. candidate, commit, reject, trace, and typed host-provider outcome meaning,
4. typed query bundle and library-context interpretation once the inputs are supplied.

## 4. Minimal Packet Shape
The first minimal upstream host interface package is:

### 4.1 Formula slot facts
1. `fixture_input_id`
2. optional `formula_slot_id`
3. `formula_stable_id`
4. `formula_text`
5. `formula_text_version`
6. `formula_channel_kind`
7. `caller_anchor`
8. optional `active_selection_anchor`
9. `structure_context_version`

### 4.2 Binding-world facts
1. `cell_fixture`
2. `defined_name_bindings`
3. optional `table_catalog`
4. optional `enclosing_table_ref`
5. optional `caller_table_region`

### 4.3 Typed query facts
1. `host_info_mode`
2. `rtd_mode`
3. `locale_context_kind`
4. optional `now_serial`
5. optional `random_value`
6. `registered_external_present`

### 4.4 Runtime catalog facts
1. optional `library_context_snapshot`

### 4.5 First replay capture projection
1. deterministic `FirstHostReplayCapturePacket` emission from the same minimal packet
2. carried `library_context_snapshot_ref` projection derived from the runtime catalog snapshot

## 5. Current Realized Minimal Behavior
The current realized package is intentionally narrow.

It supports:
1. direct OxFml recalculation through `SingleFormulaHost`,
2. deterministic bind-context projection for test scaffolding,
3. defined-name value and reference bindings,
4. cell fixtures,
5. first table-context carriage through `table_catalog`, `enclosing_table_ref`, and `caller_table_region`,
6. multiple bounded evaluator-facing structured-reference families on top of that same table-context packet, currently:
   - current-row structured reference
   - explicit-column aggregate
   - headers-section return
   - data-qualified multi-column aggregate
7. typed host-info stand-ins, including unsupported-query, provider-failure, directory-value, and mixed directory-value-plus-filename-provider-failure outcomes,
8. typed RTD stand-ins,
9. locale-context selection,
10. in-memory library-context snapshot carriage,
11. first replay-capture packet emission from the same deterministic host packet.

It does not yet widen to:
1. production coordinator API freeze,
2. full caller-anchor and address-mode closure,
3. final execution-restriction transport closure,
4. broader registered-external execution semantics,
5. broader TreeCalc replay and retained-witness lanes.

## 6. Automated Scaffolding Role
This packet is the first honest OxCalc-side answer to the OxFml stand-in packet lane:
1. tests can now build a deterministic packet,
2. the packet can drive real OxFml execution,
3. the same packet family can be reused by the TreeCalc seam-backed lane,
4. future fixture hosts can widen the packet without rewriting the ownership split.

For authority and interpretation:
1. `CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` defines where this document sits in the OxCalc seam-reference set,
2. `CORE_ENGINE_OXFML_SEAM.md` remains the canonical OxCalc-local seam companion,
3. `CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md` carries the narrower residual topics that are not yet closed here.

## 7. Current Code Surface
The current implementation lives in:
1. `src/oxcalc-core/src/upstream_host.rs`

The current live consumer is:
1. `src/oxcalc-core/src/treecalc.rs`

The current deterministic compare discipline is exercised through:
1. `scripts/compare-treecalc-local-run.ps1`

The current crate-level scaffolding tests live in:
1. `src/oxcalc-core/tests/upstream_host_scaffolding.rs`

The current checked-in fixture corpus lives in:
1. `docs/test-fixtures/core-engine/upstream-host`

## 8. Non-Assumptions
This document does not claim:
1. that W026 is fully discharged,
2. that the broader host/runtime seam is frozen,
3. that `registered_external_present` means broader external-provider execution scope is active,
4. that the packet already captures every later TreeCalc or product-host truth.

## 9. Immediate Use
Immediate intended use is:
1. automated OxFml-facing scaffolding in OxCalc,
2. deterministic stand-in host tests,
3. shared reuse by the current TreeCalc direct-host slice.

## 10. Status
- execution_state: in_progress
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - broader W026 bind/reference intake remains open beyond this minimal packet
  - caller-anchor/address-mode breadth, execution-restriction transport breadth, and broader publication/topology breadth remain narrower seam lanes
  - first table-context carriage and four bounded evaluator-facing structured-reference families are fixture-covered in the first corpus, but richer structured-reference evaluator families are not yet fixture-covered
  - this packet is ready for deterministic automated scaffolding, first capture-packet testing, and first data-driven fixture use, but not a production coordinator API freeze

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`

# CORE_ENGINE_OXFML_SEAM.md

## 1. Purpose and Status
This document defines the OxCalc view of the OxFml seam for the rewritten core-engine spec set.

Status:
1. active rewrite baseline,
2. intended canonical OxCalc-local seam companion,
3. coordinator-facing in emphasis,
4. partially aligned to OxFml canonical seam updates from `HANDOFF-CALC-001`.

This document does not claim canonical ownership of the shared evaluator protocol.
OxFml remains the canonical owner of shared FEC/F3E seam specification.

This document exists to make OxCalc's coordinator-facing requirements explicit.
For downstream hosts that use OxCalc as seam-reference material only, read this document together with:
1. `CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md`
2. `CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`
3. `CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md` only for narrower residual topics and non-assumptions

## 2. Ownership Rule
The seam is shared, but ownership is split.

### 2.1 OxFml Owns
OxFml owns:
1. formula grammar,
2. parse and bind semantics,
3. evaluator-side session and execution semantics,
4. canonical shared seam specification text,
5. evaluator-facing trace and result contracts where those are canonical seam artifacts.

### 2.2 OxCalc Owns
OxCalc owns:
1. coordinator acceptance and rejection consequences,
2. publication-fence requirements,
3. snapshot compatibility requirements from the coordinator side,
4. scheduling and stabilization interaction,
5. what evaluator-produced `AcceptedCandidateResult` artifacts must provide for coordinator-controlled publication.

### 2.3 Shared-Clause Rule
Where a clause is shared but canonical in OxFml, OxCalc must express its requirement locally and then hand off canonical text changes rather than silently diverging.

## 3. Why This Seam Must Be Explicit
The seam must be explicit because:
1. the evaluator is not the coordinator,
2. evaluator-produced `AcceptedCandidateResult` is not identical to committed publication,
3. replay and reject behavior depend on shared structure,
4. later concurrency makes weak seam wording unsafe.

If the seam is left implicit, publication, runtime state, and evaluator behavior will drift into one another.
The rewrite rejects that outcome.

## 4. OxCalc Expectations Of Evaluator Artifacts
OxCalc treats evaluator artifacts as immutable, versioned inputs.

The seam therefore requires that OxCalc be able to reason about:
1. which immutable evaluator artifact a candidate work unit is based on,
2. what token or version discipline guards that artifact,
3. what profile/version context applies,
4. what compatibility assumptions are being asserted by candidate work.

OxCalc does not need to own the evaluator internals to require this compatibility structure.

## 5. Candidate Work Boundary
The seam must expose a clear boundary between:
1. structural/evaluator inputs,
2. candidate evaluation work,
3. evaluator-produced `AcceptedCandidateResult`,
4. accepted publication consequences.

This distinction matters because the coordinator must be able to:
1. reject candidate work safely,
2. publish accepted work atomically,
3. preserve stable observer-visible state,
4. replay and diagnose accept/reject behavior.

## 6. Snapshot and Fence Requirements
From the OxCalc side, the seam must support coordinator reasoning about compatibility and fences.

At minimum, the seam must make it possible for the coordinator to determine:
1. which snapshot or structural basis candidate work depends on,
2. which evaluator artifact/token basis candidate work depends on,
3. whether profile/version assumptions match,
4. whether candidate work is eligible for publication under current coordinator state.

The exact canonical field names belong in shared seam specs, but the architectural requirement is fixed here.

## 7. Accepted Candidate Result Requirements
For accepted work, the seam must provide an evaluator-produced `AcceptedCandidateResult` structure rich enough for coordinator-controlled publication.

This means OxCalc must be able to receive or derive, through the seam, the information required to:
1. publish accepted results atomically,
2. update stable observer-visible derived state coherently,
3. integrate relevant topology/dependency consequences,
4. preserve replay and diagnostic fidelity.

The coordinator does not accept opaque success without adequate publication-relevant structure.

## 8. Reject Detail Requirements
Rejected work is architecturally no-publish.

But reject outcomes must still provide structured detail sufficient for:
1. deterministic replay,
2. diagnostics,
3. seam-hardening work,
4. staged concurrency analysis.

From the OxCalc side, the seam must support reject detail that distinguishes at least:
1. compatibility or fence mismatch,
2. artifact/token mismatch,
3. capability or session mismatch where relevant,
4. other coordinator-relevant reject classes that affect replay and migration understanding.

The canonical taxonomy belongs in shared seam work, but the requirement for structured detail is locked here.

## 9. Publication Ownership Rule
The seam must not blur evaluator success with committed publication.

The evaluator may produce an `AcceptedCandidateResult`.
The coordinator alone decides whether that result becomes committed published consequences.

Therefore the seam must preserve the distinction between:
1. evaluator-produced `AcceptedCandidateResult`,
2. coordinator-accepted publication,
3. rejected no-publish outcome.

## 10. Dynamic Dependency and Runtime-Derived Consequences
Where evaluator execution reveals runtime-relevant facts that matter to OxCalc coordination,
the seam must support explicit transmission or derivation of those facts.

This is necessary for cases such as:
1. runtime-observed dependency effects,
2. runtime capability or fence implications,
3. other evaluator-discovered facts that influence recalc or publication.

These effects must not be left as hidden evaluator internals if OxCalc is expected to coordinate on them.

## 11. Stage-1 Versus Later-Stage Seam Pressure

### 11.1 Stage 1
Stage 1 may realize a conservative subset of the full seam-hardening story.

But even in Stage 1, the seam must already preserve:
1. candidate-versus-publication distinction,
2. explicit compatibility or fence basis,
3. reject detail adequate for replay and diagnostics,
4. coordinator ownership of accept or reject consequences.

### 11.2 Later Stages
Later concurrent and async stages increase seam pressure.

They require stronger handling for:
1. contention and retry visibility,
2. fence mismatches under concurrent work,
3. deterministic replay of staged concurrency outcomes,
4. publication safety under overlapping candidate work.

The seam should therefore be written now with later hardening in mind.

## 12. Handoff Rule
Whenever OxCalc local requirements imply changes to canonical shared seam text, OxCalc must:
1. document the local requirement here,
2. prepare an explicit handoff packet for OxFml,
3. register the handoff,
4. avoid claiming the shared clause is fully resolved until the canonical side acknowledges it.

## 13. Formalization and Evidence Direction
This seam is assurance-relevant, not only integration-relevant.

Expected obligations include:
1. replay-visible candidate-versus-publication distinctions,
2. structured reject-detail coverage,
3. fence-safety modeling tied into coordinator assurance,
4. pack obligations for commit atomicity and reject determinism,
5. evidence artifacts sufficient for staged concurrency hardening.

## 14. Current Handoff State
`HANDOFF-CALC-001` has been filed and acknowledged.
The current shared direction now includes:
1. explicit `AcceptedCandidateResult` terminology at the OxFml seam,
2. typed no-publish reject detail for fence and capability incompatibility,
3. coordinator-relevant runtime-derived effect surfacing as a general seam rule.

Follow-on handoff pressure remains only where OxCalc later needs narrower or stronger requirements than the current shared canonical wording.

`HANDOFF-FML-001` has now also been received from OxFml.
That inbound handoff and the current OxFml downstream note strengthen the currently consumed floor with:
1. minimum typed schema objects for accepted candidate, commit, reject-context, and trace-correlation payload families,
2. a stronger managed-session baseline for stale-fence rejection, capability denial, session termination, and execution-restriction-sensitive no-publish paths,
3. a stronger replay and retained-local floor through the current OxFml-local `cap.C3.explain_valid` posture,
4. an explicit DNA OneCalc downstream host boundary that must not be mistaken for OxCalc coordinator policy.

The latest note-exchange round with OxFml also narrows several earlier uncertainties:
1. identity and fence vocabulary consumption is now treated as already canonical on the OxFml side,
2. candidate-result and commit-bundle consequence categories are now treated as already canonical on the OxFml side,
3. host-query and direct-binding-sensitive truth is now treated as already canonical on the OxFml side,
4. dependency consequence taxonomy and semantic-display boundary remain canonical but narrower rather than fully open.

## 15. OxCalc-Local Stage 1 Minimum Seam Packet

### 15.1 AcceptedCandidateResult Minimum
For Stage 1, OxCalc requires the shared seam to preserve enough information to derive or surface a minimum local `AcceptedCandidateResult` containing:
1. `candidate_result_id`
2. consumed identity and fence basis:
   - `formula_stable_id`
   - `formula_token`
   - `snapshot_epoch`
   - `bind_hash`
   - `profile_version`
   - important-but-still-narrower `capability_view_key`
3. trace and publication correlation:
   - `commit_attempt_id` where present
   - `reject_record_id` where relevant
   - optional `fence_snapshot_ref`
4. candidate publication-consequence categories:
   - `value_delta`
   - `shape_delta`
   - `topology_delta`
   - optional `format_delta`
   - optional `display_delta`
   - optional spill-event set
5. surfaced evaluator facts needed for coordinator correctness where not already derivable from the deltas
6. diagnostic and trace correlation metadata

This is an OxCalc-local minimum requirement for coordinator-controlled publication.
It does not claim that the shared OxFml-side canonical field names or artifact layering are identical.
But it now explicitly consumes the already-canonical OxFml category split rather than compressing it into generic local buckets alone.

### 15.2 Runtime-Derived Effect Subset
For Stage 1, OxCalc expects at least the following local runtime-derived effect subset to be preservable through the seam:
1. `dynamic_ref_activated`
2. `dynamic_ref_released`
3. `region_shape_activated`
4. `region_shape_released`
5. `capability_observed`
6. `format_observed`
7. `execution_restriction_observed`

This subset is the local coordinator and overlay floor.
It is not a claim that the broader shared runtime-derived effect taxonomy is closed.
Current shared reading after the latest note round:
1. execution-restriction effects are stable enough to consume semantically now,
2. OxCalc should not yet assume one final frozen single-object carrier for those effects,
3. dependency additions, removals, and reclassifications remain intended evaluator/runtime facts, but their exact retained/reduced witness projection closure is still narrower than a fully frozen universal rule.

### 15.3 Reject Subset
For Stage 1, OxCalc expects the shared seam to support a local typed reject subset covering at least:
1. `snapshot_mismatch`
2. `artifact_token_mismatch`
3. `profile_version_mismatch`
4. `capability_mismatch`
5. `publication_fence_mismatch`
6. `dynamic_dependency_failure`
7. `synthetic_cycle_reject`
8. `host_injected_failure`

This is the minimum local reject floor needed for coordinator no-publish behavior, replay classification, and self-contained harness scenarios.
It does not claim that the shared OxFml-side canonical taxonomy or ownership split is fully closed.

The current stronger OxFml-managed baseline makes the following canonical context families especially important to preserve without coordinator reinterpretation:
1. `FenceMismatchContext`
2. `CapabilityDenialContext`
3. `SessionTerminationContext`
4. `DynamicReferenceFailureContext`

### 15.4 Host-Boundary Preservation Rule
OxCalc does not own DNA OneCalc host policy.
But where retained witnesses, pack-candidate artifacts, or replay-valid scenarios depend on concrete host-sensitive truth, OxCalc must preserve the OxFml-declared direct-binding boundary rather than collapsing those cases into name-only or prose-only artifacts.

This is a replay and evidence-preservation rule.
It is not a transfer of host-policy ownership into OxCalc.

Current shared reading after the latest note round:
1. typed host-query capability views are already canonical on the OxFml side,
2. direct-cell-binding-sensitive truth is already canonical on the OxFml side where semantic correctness depends on concrete resolution,
3. the broader naming and indexing convention for direct-binding-sensitive pack-candidate families remains open and belongs to later replay widening rather than immediate seam redefinition.

## 16. Open Detailed Questions
These remain seam-hardening questions rather than reasons to weaken the split:
1. exact accepted-result payload naming and artifact partition in shared canonical terms,
2. exact reject taxonomy ownership partition beyond the now-locked Stage 1 local subset,
3. exact broader runtime-derived effect taxonomy beyond the Stage 1 local subset, especially execution-restriction and capability-sensitive transport closure,
4. exact retained/reduced witness projection closure for dependency additions, removals, and reclassifications,
5. exact trace schema mapping for coordinator-facing replay and diagnostics, especially stable use of `candidate_result_id`, `commit_attempt_id`, `reject_record_id`, and optional fence snapshot references,
6. exact replay-facing preservation rule for direct-binding-sensitive witness and pack-candidate families once W019 broadens them,
7. exact shared reading of semantic-format versus display-facing publication consequences before broader retained and pack-candidate widening.

The latest OxFml note also makes one useful non-trigger explicit:
1. current OxFunc refinement and round-closure work does not yet introduce a new OxCalc-facing seam change,
2. availability/provider-failure handling and callable-publication restriction are the most likely future upstream semantic lanes to become coordinator-visible later,
3. OxCalc should treat those as watch lanes rather than as current seam-closure blockers.

## 17. TreeCalc Seam Negotiation Topics
The next TreeCalc-ready engine phase requires a narrower negotiation shape than the earlier Stage 1 seam passes.

The required note-exchange topics are:
1. formula and bind artifact identity carriage for formula-bearing TreeCalc nodes,
2. direct-reference versus relative-reference descriptor carriage,
3. unresolved or host-sensitive reference carrier rules,
4. dependency consequence carriage for additions, removals, and reclassifications,
5. candidate-result consequence optionality and correlation guarantees,
6. reject-context carrier and minimum diagnostic guarantee,
7. runtime-derived effect transport and projection rules,
8. direct-binding and host-sensitive witness-preservation rules,
9. semantic-format versus display-facing consequence boundary.

These topics are negotiation topics, not yet all formal handoff triggers.
The purpose is to force explicit consumption decisions before W026 and later TreeCalc execution work.

## 18. Required Consumed Topic Matrix For W026
For the first TreeCalc-ready engine phase, OxCalc should process the seam in the following topic matrix.

### 18.1 Topic A: Formula and Bind Artifact Identity
OxCalc needs:
1. stable formula artifact identity for formula-bearing nodes,
2. bind-product identity and version basis,
3. compatibility basis needed to determine whether a structure/formula edit implies rebind or only recalc.

Expected current answer shape from OxFml:
1. canonical now for `formula_stable_id`, `formula_token`, `bind_hash`, `snapshot_epoch`, and `profile_version`,
2. narrower but consumable for `capability_view_key` where compatibility-sensitive evaluation meaning depends on it.

W026 should explicitly record:
1. which of these are required on every formula-bearing node,
2. which may remain optional until candidate-result time,
3. which are replay-visible identifiers versus compatibility-only handles.

### 18.2 Topic B: Reference Descriptor Carriage
OxCalc needs:
1. direct-node reference descriptors,
2. relative-reference descriptors or already-bound relative targets,
3. explicit unresolved or host-sensitive reference forms,
4. a rule for whether relative meaning is fixed at bind time or remains contextual.

W026 should force explicit answers to:
1. what the first in-scope relative-reference subset is,
2. whether the bind product already resolves relative navigation fully,
3. which structural edits force rebind rather than recalc.

### 18.3 Topic C: Dependency Consequence Carriage
OxCalc needs:
1. static dependency facts suitable for graph build,
2. runtime-derived dependency additions, removals, and reclassifications,
3. explicit identity for dependency facts that later replay and reduced-witness lanes can preserve.

Current shared read:
1. semantic intent is stable enough to consume now,
2. exact retained/reduced witness closure remains narrower than a universal rule.

W026 should therefore separate:
1. consumed now for live dependency and recalc semantics,
2. still-open retained/reduced witness projection closure.

### 18.4 Topic D: Candidate Result and Commit Consequence Carriage
OxCalc needs:
1. `candidate_result_id`,
2. stable correlation with `commit_attempt_id` where present,
3. optional `fence_snapshot_ref` where present,
4. canonical consequence categories:
   - `value_delta`
   - `shape_delta`
   - `topology_delta`
   - optional `format_delta`
   - optional `display_delta`
   - spill or shape events
5. surfaced evaluator/runtime facts required for coordinator correctness.

W026 should make explicit:
1. which optional consequence families must still preserve explicit absence/presence semantics,
2. which families are publish-critical for the first TreeCalc phase,
3. which remain carried only for replay honesty rather than first-phase coordinator behavior.

### 18.5 Topic E: Reject Context Carriage
OxCalc needs typed reject carriers for at least:
1. snapshot mismatch,
2. token or artifact mismatch,
3. profile mismatch,
4. capability denial,
5. publication-fence mismatch,
6. execution restriction or invalid phase,
7. dynamic dependency failure,
8. host-sensitive resolution failure where relevant.

W026 should clarify:
1. which reject contexts are canonical OxFml object families already,
2. which local OxCalc labels remain merely local projections,
3. which reject families must preserve additional host-sensitive or bind-sensitive diagnostics.

### 18.6 Topic F: Runtime-Derived Effect Transport
OxCalc needs explicit carriage for:
1. dynamic dependency activation and release,
2. capability observations,
3. execution-restriction observations,
4. shape and topology-sensitive runtime effects,
5. format-sensitive runtime effects where semantically relevant.

Current shared read:
1. these are stable enough to consume semantically now,
2. the final single transport carrier is not yet frozen.

W026 should therefore force explicit recording of:
1. semantic minimum consumed now,
2. transport-shape assumptions OxCalc must not make yet,
3. what later evidence would justify a narrower handoff.

### 18.7 Topic G: Direct-Binding and Host-Sensitive Truth
OxCalc needs:
1. preserved concrete binding identity where semantic truth depends on it,
2. explicit distinction between direct-binding-sensitive families and name-only families,
3. replay-visible host-sensitive identity in retained and reduced witnesses where required.

W026 should keep explicit:
1. this is already canonical in OxFml semantic ownership,
2. OxCalc is only consuming and preserving it,
3. broader naming/indexing conventions for later pack families may still remain open.

### 18.8 Topic H: Semantic-Format Versus Display Boundary
OxCalc needs:
1. a first consumed semantic floor,
2. explicit format-sensitive consequences where they may affect runtime or later observer policy,
3. display-sensitive consequences kept visible enough not to be silently collapsed.

W026 should not force premature closure here.
It should instead record:
1. what is consumed now for the first TreeCalc phase,
2. what remains canonical but narrower,
3. what evidence in later TreeCalc runs would justify a narrower handoff.

## 19. Note-Exchange Rule For W026
W026 should treat `NOTES_FOR_OXFML.md` and `NOTES_FOR_OXCALC.md` as structured negotiation instruments rather than general commentary.

Each pass should record, for every active topic:
1. OxCalc consumed need,
2. current OxFml classification:
   - `already canonical`
   - `canonical but narrower`
   - `still open`
3. consumed-now carrier assumptions,
4. non-assumptions OxCalc must preserve,
5. explicit trigger for whether note-level clarification is enough or a narrower handoff is required.

The note passes should stop being generic once W026 starts.
They should function as a bounded seam issue ledger until the first TreeCalc-ready intake floor is locked.

The latest OxFml topic-matrix reply makes the current practical split clearer:
1. consume now:
   - formula and bind identity carriage
   - candidate consequence and correlation floor
   - reject-context typed families for the current floor
   - direct-binding-sensitive witness preservation
2. keep in note-level refinement:
   - direct and relative reference descriptor carriage
   - unresolved and host-sensitive reference carriers
   - runtime-derived effect transport shape
   - semantic-format versus display-facing boundary

This means the current seam state is clear enough to proceed into W026 planning and later implementation preparation without reopening the shared ownership split.
It does not mean every transport shape is frozen.

The latest narrower W026-focused OxFml reply further sharpens this:
1. W026 can proceed now on a narrowed first relative-reference subset,
2. W026 can proceed now on explicitly named unresolved and host-sensitive carrier families,
3. W026 can proceed now on the semantic floor for runtime-derived effects and execution-restriction transport,
4. W026 can proceed now on a semantics-first semantic-format/display split so long as broader display closure is not over-claimed.

So the seam interface is settled enough for the first TreeCalc intake phase.
What remains unsettled is not the ownership split or the consumed semantic floor; it is broader transport-shape closure beyond the first subset.

## 20. Handoff Trigger Rule For The TreeCalc Seam Phase
For the TreeCalc semantic-completion lane, a new narrower handoff should be filed only if one of the following occurs:
1. OxCalc cannot consume the first in-scope bind/reference package without OxFml changing or clarifying a coordinator-facing seam clause,
2. execution-restriction transport is too narrow for live TreeCalc coordinator semantics,
3. dependency consequence transport is too narrow for live TreeCalc graph build or publication semantics,
4. candidate-result consequence optionality is too weak for coordinator-controlled publication,
5. direct-binding-sensitive truth cannot be preserved honestly for the first TreeCalc witness families.

Otherwise the issue should remain in the note-exchange lane and be resolved there.

## 21. Host Runtime Draft Intake
OxCalc now also treats `../OxFml/docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md` as the bounded OxFml-owned packet for the next host/coordinator seam round.

Current local read is:
1. it is sufficient for first implementation planning across the reduced direct-host lane and the first OxCalc-integrated host lane,
2. it preserves the authority split correctly:
   - OxFml owns artifact meaning, typed effect/reject semantics, and runtime library-context truth,
   - OxCalc owns scheduler, publication, invalidation integration, and broader graph coordination outside OxFml artifact meaning,
3. it does not yet need to be treated as shared seam-freeze text,
4. it narrows host/coordinator seam uncertainty to a small set of remaining carrier-breadth questions.

### 21.1 Consumed-now host/runtime floor
For the first host/coordinator implementation slice, OxCalc now treats the following as consume-now:
1. direct-host versus OxCalc-integrated host split,
2. formula and structure inputs,
3. direct-cell and defined-name bindings,
4. typed host-query/provider families in the currently covered floor:
   - `INFO`
   - `CELL`
   - `RTD`
5. runtime `LibraryContextProvider` plus immutable `LibraryContextSnapshot` as the normative runtime catalog seam,
6. candidate / commit / reject / trace output families,
7. `ReturnedValueSurface` split,
8. coordinator-relevant ids:
   - `candidate_result_id`
   - `commit_attempt_id` where present
   - `reject_record_id`
   - optional `fence_snapshot_ref`

### 21.2 Host/runtime residuals that remain narrower
The remaining narrower host/runtime questions are:
1. caller-anchor and address-mode carriage for the first TreeCalc relative-reference subset,
2. execution-restriction transport shape beyond the current semantic minimum,
3. publication/topology consequence breadth beyond the current exercised local floor,
4. provider-failure and callable-publication watch lanes if they later become coordinator-visible.

Current local read:
1. these remain note-level topics,
2. no new handoff is justified yet from the host/runtime draft alone,
3. they become handoff candidates only if live TreeCalc or host evidence exposes insufficiency.
4. the latest OxFml reply explicitly agrees the host/runtime draft is strong enough for first implementation planning, while preserving these caution points as non-frozen residuals.
5. the later `W051` and `W052` stand-in packet refinements sharpen deterministic scaffolding inputs without changing this residual set:
   - stand-in packet identity, structure-context identity, and formula-slot identity are now accepted refinements,
   - `RegisteredExternalProvider` remains optional,
   - any later host-initiated registration lane should be modeled as a typed mutation request into OxFunc-owned catalog truth rather than as coordinator-owned catalog mutation.

### 21.3 Consumed-now local narrowing for the remaining residuals
OxCalc is now treating the remaining residuals as bounded consume-now topics rather than general seam uncertainty.

For caller-anchor and address-mode carriage:
1. `caller_anchor`, formula-channel, address-mode, and structure-context identity remain explicit host-supplied inputs where relative or host-sensitive meaning depends on them,
2. the first TreeCalc subset should only consume relative forms whose contextual dependence is preserved honestly in the current bound/reference artifact,
3. OxCalc must not assume full relative-reference closure or one final frozen caller-sensitive transport shape.

For execution-restriction transport breadth:
1. execution-restriction observations are already consumed semantically as surfaced evaluator/runtime facts,
2. OxCalc may consume them through current candidate-result, reject-context, topology/effect-ref, or runtime-effect families where that truth is explicitly carried,
3. OxCalc must not collapse them into scheduler policy or assume one final single-object carrier yet.

For publication/topology breadth:
1. `value_delta`, `shape_delta`, and `topology_delta` remain distinct publish-facing categories,
2. optional `format_delta` and `display_delta` remain distinct when present,
3. OxCalc must not treat the currently exercised local breadth as closure of the full publication/topology universe,
4. later evidence rather than prose-only agreement should determine whether currently optional consequence families become first-slice mandatory.

The latest OxFml residual reply further sharpens this local narrowing:
1. all three residuals remain `canonical but narrower`,
2. the current consumed-now carrier set above is sufficient for continued W026 intake planning,
3. no new narrower handoff is justified from this residual pass alone,
4. the remaining pressure is broader closure beyond the first carried subset rather than a missing first-slice seam clause.

## 22. Status
- execution_state: in_progress
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - replay artifacts not yet attached for candidate-result versus publication boundaries,
  - the Stage 1 local seam packet now consumes more of the already-canonical OxFml category split, but broader TreeCalc descriptor and transport questions remain open beyond the first consumed subset,
  - W026 now has a clear consume-now versus refine-in-notes split, but the topic-matrix pass is not yet converted into executed seam intake work,
  - a narrower follow-on handoff is not required yet, but remains an explicit later decision if W019 evidence creates stronger coordinator pressure

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md`

# CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md

## 1. Purpose and Status
This document turns the TreeCalc-facing OxCalc↔OxFml seam into a negotiation-ready matrix for the next `NOTES_FOR_*` passes.

Status:
1. active planning companion,
2. intended bridge between the canonical local seam doc and W026,
3. note-exchange oriented rather than implementation-oriented,
4. explicitly pre-handoff unless a narrower trigger is reached.

This document exists so the next seam passes are structured around concrete consumed-carrier questions, not broad prose uncertainty.
It is not the canonical local seam-reference source of truth for downstream hosts.
Use `CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` and `CORE_ENGINE_OXFML_SEAM.md` first, and then use this matrix only for narrower open topics and explicit non-assumptions.

## 2. Working Rule
For the first TreeCalc-ready engine phase:
1. OxFml remains authoritative for formula, bind, evaluator, reject, and replay-safe identity meaning,
2. OxCalc remains authoritative for coordinator consequences, invalidation integration, publication semantics, and replay meaning on the engine side,
3. note exchange is the default negotiation mechanism,
4. a narrower handoff is filed only when a coordinator-facing consumed clause cannot be stabilized through note exchange alone.

## 3. Required Reply Shape For Each Topic
Each active seam topic should be answered in the next `NOTES_FOR_*` rounds with:
1. current OxFml classification:
   - `already canonical`
   - `canonical but narrower`
   - `still open`
2. carrier surface OxCalc should consume now,
3. explicit non-assumptions OxCalc must preserve,
4. whether the topic is sufficient for W026 consumption now,
5. whether the topic is only note-level or now deserves a narrower handoff.

## 4. Topic Matrix

### 4.1 Formula and Bind Identity
OxCalc consumed need:
1. `formula_stable_id`
2. `formula_token`
3. `bind_hash`
4. `snapshot_epoch`
5. `profile_version`
6. important consumed compatibility state for `capability_view_key`

Why it matters:
1. formula-bearing nodes need immutable attachment and compatibility identity,
2. rebind versus recalc cannot be decided honestly without this split,
3. replay and witness surfaces need stable identity that is not only local node naming.

Expected current state:
1. mostly consumable now,
2. `capability_view_key` remains canonical but narrower in some clauses.

W026 output needed:
1. consumed-now node attachment fields,
2. replay-visible versus compatibility-only distinction,
3. handoff trigger only if live TreeCalc use reveals a missing coordinator-facing clause.

### 4.2 Direct and Relative Reference Descriptors
OxCalc consumed need:
1. direct named-node reference descriptors,
2. tree-relative reference descriptors or already-bound relative targets,
3. unresolved-reference and host-sensitive-reference carriers,
4. rule for what structural context anchors relative meaning.

Why it matters:
1. TreeCalc semantics are not only direct absolute references,
2. structural edits must map to rebind or recalc deterministically,
3. relative meaning cannot be left as hidden evaluator context if OxCalc must manage invalidation.

Expected current state:
1. likely narrower than the already-canonical identity floor,
2. likely a prime W026 note topic before implementation starts.

W026 output needed:
1. first in-scope relative-reference subset,
2. bind-time-fixed versus context-sensitive decision,
3. explicit list of edits that force rebind.

### 4.3 Dependency Fact Carriage
OxCalc consumed need:
1. static dependency facts,
2. runtime additions,
3. runtime removals,
4. runtime reclassifications,
5. stable dependency fact identity for replay and witness use.

Why it matters:
1. OxCalc cannot build a real graph from prose-only dependency meaning,
2. runtime dependency changes must not become hidden mutable state,
3. retained/reduced witnesses must preserve enough identity to stay diagnostic.

Expected current state:
1. semantic intent stable enough to consume now,
2. retained/reduced witness projection closure still narrower.

W026 output needed:
1. consumed-now dependency fact floor for live graph build,
2. explicit deferred closure for broader retained/reduced transport rules.

### 4.4 Candidate Consequence Carriage
OxCalc consumed need:
1. stable correlation ids
2. `value_delta`
3. `shape_delta`
4. `topology_delta`
5. optional `format_delta`
6. optional `display_delta`
7. spill or shape events
8. surfaced evaluator/runtime facts required for coordinator behavior

Why it matters:
1. candidate result is not publication,
2. coordinator-controlled publication requires explicit consequence shape,
3. verified-clean versus publish-ready requires a non-collapsed equality surface.

Expected current state:
1. canonical category split already stable enough to consume,
2. optionality breadth may still need narrower note confirmation for some families.

W026 output needed:
1. consumed-now first TreeCalc candidate package,
2. publish-critical versus replay-only carried fields,
3. exact verified-clean comparison surface for the first TreeCalc phase.

### 4.5 Reject Context Carriage
OxCalc consumed need:
1. typed reject context families for mismatch, capability, phase, execution restriction, dynamic dependency, and host-sensitive failure,
2. stable correlation ids where present,
3. enough detail to preserve no-publish reasoning without coordinator reinterpretation.

Why it matters:
1. reject must remain typed and replay-visible,
2. TreeCalc bind and host-sensitive families will widen failure shapes,
3. coordinator policy must not invent evaluator meaning after the fact.

Expected current state:
1. important canonical context families already stable,
2. local projection labels may remain local-only in some cases.

W026 output needed:
1. consumed canonical reject context subset,
2. list of purely local OxCalc projection labels,
3. explicit handoff trigger only if a required reject family is missing.

### 4.6 Runtime-Derived Effects and Execution Restrictions
OxCalc consumed need:
1. dynamic dependency activation and release,
2. capability observations,
3. execution-restriction observations,
4. shape or topology runtime effects,
5. format-sensitive runtime observations where semantically relevant.

Why it matters:
1. runtime-derived effects must become explicit engine state,
2. execution restriction is one of the few still-likely narrower handoff triggers,
3. overlay closure depends on this being real rather than hidden evaluator state.

Expected current state:
1. semantic consumption is stable enough now,
2. final transport-carrier closure is still narrower.

W026 output needed:
1. semantic minimum OxCalc consumes now,
2. transport-shape assumptions OxCalc must avoid,
3. explicit residual criteria for any later handoff.

### 4.7 Direct-Binding and Host-Sensitive Truth
OxCalc consumed need:
1. explicit distinction between direct-binding-sensitive and name-only families,
2. preserved concrete identity where semantic correctness depends on it,
3. replay and retained-witness preservation rules for those identities.

Why it matters:
1. TreeCalc witness and pack lanes must not erase real semantic identity,
2. host-sensitive truth is already known to be canonical on the OxFml side,
3. broader program-grade pack work will keep stressing this area.

Expected current state:
1. semantic ownership is already clear,
2. broader naming/indexing conventions remain open.

W026 output needed:
1. consumed direct-binding-sensitive floor for TreeCalc engine work,
2. explicit note-only residuals for later broader pack-family naming.

### 4.8 Semantic, Format, and Display Boundary
OxCalc consumed need:
1. a semantic consequence floor for the first TreeCalc-ready engine,
2. explicit format-sensitive carriage where runtime or later observer policy depends on it,
3. enough display-facing visibility that OxCalc does not accidentally collapse the categories.

Why it matters:
1. later Excel-compatible widening will care about this boundary,
2. current TreeCalc work should not overcommit display semantics too early,
3. replay honesty depends on not flattening the categories.

Expected current state:
1. canonical category split exists,
2. shared interpretation remains narrower.

W026 output needed:
1. consumed-now semantic and format floor,
2. explicit deferred display-facing questions,
3. note-only residual until live TreeCalc evidence says otherwise.

### 4.9 Host Runtime and External Requirements
OxCalc consumed need:
1. a clear direct-host versus OxCalc-integrated host split,
2. explicit required inputs for formula, structure, direct bindings, defined names, host-query/provider families, runtime library-context snapshots, and capability/fence inputs,
3. explicit required output families for candidate, commit, reject, trace, and `ReturnedValueSurface`,
4. stable coordinator-relevant ids and consequence categories preserved without host-side reinterpretation.

Why it matters:
1. TreeCalc intake should not proceed on an implicit host contract,
2. runtime library-context truth is now explicit OxFml/OxFunc-owned seam surface rather than a local convenience,
3. the first coordinator-host implementation slice needs a bounded contract that is narrower than full product-host closure but stronger than proving-host-only prose.

Expected current state:
1. sufficient now for the first host/coordinator implementation slice,
2. caller-anchor/address-mode handling for the first TreeCalc relative-reference subset remains narrower,
3. provider-failure and callable-publication remain watch lanes only.
4. OxFml has now explicitly agreed with OxCalc's `already canonical` read for this first slice.

W026 output needed:
1. consumed-now host/runtime baseline for the first integrated host slice,
2. explicit residual note-level topics that remain narrower,
3. no handoff trigger unless live host evidence reveals a missing coordinator-facing clause.

## 5. Negotiation Sequence
Recommended note sequence for W026 preparation:
1. Round A: identity, bind, direct and relative reference descriptors
2. Round B: dependency facts, candidate consequences, reject contexts
3. Round C: runtime-derived effects, execution restrictions, direct-binding preservation, semantic-format-display boundary
4. Round D: only if needed, a narrower handoff on the one remaining coordinator-facing insufficiency

### 5.1 Current Residual Packetization
After the broader topic-matrix rounds, the active residual packetization for W026 is now:
1. Sequence 1: caller-anchor and address-mode carriage for the first TreeCalc relative-reference subset
2. Sequence 2: execution-restriction transport breadth
3. Sequence 3: publication/topology consequence breadth

Working rule:
1. each residual sequence should narrow consumed-now assumptions and explicit non-assumptions separately,
2. each sequence should be able to stay note-level unless live implementation pressure shows a concrete insufficiency,
3. the residual packet should not reopen already-consumed identity, candidate, reject-context, direct-binding, stand-in, or table-context topics.

## 6. Current Topic-Matrix Intake From OxFml
The latest OxFml reply materially narrows the W026 starting state.

Current local intake is:
1. formula and bind artifact identity carriage: `already canonical`
2. direct and relative reference descriptor carriage: `canonical but narrower`
3. unresolved and host-sensitive reference carrier rules: `canonical but narrower`
4. dependency fact carriage: semantically `already canonical`, with narrower retained/reduced projection closure
5. candidate-result consequence optionality and correlation guarantees: `already canonical`
6. reject-context carrier and diagnostic guarantees: `already canonical` for the current typed families
7. runtime-derived effect and execution-restriction transport: `canonical but narrower`
8. direct-binding-sensitive witness preservation rules: `already canonical`
9. semantic-format versus display-facing consequence boundary: `canonical but narrower`

The practical consequence for W026 is:
1. identity, candidate consequence, reject-context, and direct-binding preservation should now be treated as consume-now topics,
2. relative-reference descriptor carriage, unresolved or host-sensitive reference carriers, runtime-derived effect transport shape, and semantic-format-display reading remain the main note-level refinement topics,
3. the OxFml host/runtime draft is also sufficient to consume now for the first integrated host slice,
4. no new narrower handoff is justified yet from this note round alone.

The latest narrower W026-focused reply also supplies the first practical carrier guidance for the remaining four topics:
1. relative-reference carriage is sufficient now for a narrowed first subset using current normalized reference-expression and bound-reference artifacts where contextual dependence is preserved honestly,
2. unresolved and host-sensitive carriers are sufficient now if OxCalc preserves the current accepted-unresolved versus reject distinction plus typed unresolved/bind diagnostics and host-query capability-view surfaces,
3. runtime-derived effect transport is sufficient now semantically through current surfaced evaluator facts and topology/effect refs, while final carrier closure remains open,
4. semantic-format versus display-facing consequence handling is sufficient now for a semantics-first first phase so long as `format_delta` and `display_delta` remain explicitly distinct and broader display closure is not over-claimed.

This means W026 is now blocked only by live consumption work, not by broad seam uncertainty.

### 6.1 Current Intake Of The Three-Sequence Residual Reply
OxFml has now also answered the later three-sequence residual round.

Current local intake is:
1. Sequence 1 caller-anchor and address-mode carriage: `canonical but narrower`
2. Sequence 2 execution-restriction transport breadth: `canonical but narrower`
3. Sequence 3 publication/topology consequence breadth: `canonical but narrower`

Current practical consequence:
1. all three residual sequences may remain note-level under W026,
2. all three now have explicit consumed-now carriers rather than only abstract residual labels,
3. no narrower handoff is justified unless live TreeCalc evidence later exposes a concrete insufficiency in one of those carried families.

## 7. Exit Condition For The Planning Phase
This planning companion has served its purpose when:
1. W026 has a consumed-now topic ledger for all in-scope TreeCalc seam topics,
2. any remaining uncertainty is explicitly classified as note-only residual or narrower handoff,
3. no major TreeCalc engine implementation decision still depends on compressed seam assumptions.

## 8. Status
- execution_state: planned
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - relative-reference descriptor carriage remains canonical but narrower beyond the first explicitly consumed subset
  - unresolved and host-sensitive reference carriers remain canonical but narrower beyond the first explicitly named families
  - runtime-derived effect transport and semantic-format-display reading remain canonical but narrower beyond the current semantics-first floor
  - W026 has not yet consumed this matrix into executed seam intake work; the current live residual packet is the three-sequence caller-context / execution-restriction / publication-topology narrowing lane
  - no narrower handoff has been justified yet
- claim_confidence: provisional
- reviewed_inbound_observations: latest OxFml downstream note and returned classifications consumed as the starting baseline

## Source: `OxCalc/docs/spec/core-engine/CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`

# CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md

## 1. Purpose and Status
This document defines the design and execution-planning target for the first semantically-complete TreeCalc engine phase.

Status:
1. active planning companion,
2. intended canonical bridge between the current `TraceCalc` proving substrate and the first TreeCalc-ready engine,
3. sequential and semantics-first in immediate realization scope,
4. explicitly pre-optimization, but written to preserve the intended high-performance architecture path.

This document exists because the current realized OxCalc floor proves important coordinator, recalc, replay, and retained-witness machinery, but it does not yet realize a true TreeCalc formula engine.

The purpose here is to make the next target explicit:
1. what the first TreeCalc-ready engine actually is,
2. what it must do end-to-end,
3. what the OxCalc/OxFml seam must provide,
4. what work sequence gives real line of sight to that target,
5. what must remain true so later optimization waves do not require semantic redesign.

For downstream hosts that use OxCalc as seam-reference material only, this document is a supporting consumer-model companion.
Read `CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` and `CORE_ENGINE_OXFML_SEAM.md` first, then use this document to understand how the consumed OxFml seam is expected to participate in the first TreeCalc-ready execution pipeline.

## 2. Target Outcome
The target defined by this document is:

**the first semantically-complete, sequential, TreeCalc-ready core engine**

For this repo, that means an engine that can:
1. hold a tree-structured calculation substrate of named nodes,
2. attach real formula artifacts to those nodes,
3. consume OxFml-owned parse and bind products rather than test-only scripted evaluation steps,
4. resolve direct and relative references in TreeCalc scope through the OxFml seam plus OxCalc structural truth,
5. build the structural dependency graph and runtime-derived dependency consequences required for recalculation,
6. execute deterministic evaluation and candidate-result intake,
7. apply coordinator acceptance, rejection, and publication rules,
8. preserve pinned-reader and stable-publication semantics,
9. emit deterministic replay, diff, explain, and witness artifacts for the covered TreeCalc scope.

The target does **not** yet require:
1. default parallel or async execution,
2. economics-tuned incremental strategy,
3. grid substrate semantics,
4. broader Excel surface beyond the declared TreeCalc node-and-reference scope,
5. pack-grade replay promotion beyond the already-declared replay capability floor.

## 3. Definition Of "Semantically-Complete" For This Phase
For this phase, "semantically-complete" does not mean "all future optimization and substrate work is finished."

It means the following semantic chain is real and exercised end-to-end:
1. TreeCalc structure exists as immutable structural truth.
2. Each calculation node can own a real OxFml formula artifact package.
3. Reference meaning is explicit for the covered TreeCalc forms.
4. Structural dependency and runtime-derived dependency facts are explicit and replay-visible.
5. Evaluator-produced candidate results are real seam objects, not scenario-script placeholders.
6. Coordinator publication is the only path to stable observer-visible state.
7. Reject-is-no-publish behavior is preserved across the covered formula and reference families.
8. Dynamic/runtime-derived facts that matter to semantics are not hidden in mutable implementation detail.
9. The covered TreeCalc corpus is executable through the actual engine pipeline, not only through `TraceCalc` fixture scripts.

This phase is therefore complete only when the first TreeCalc-ready engine exists as an **actual runtime pipeline**, not just as spec text or as a proving harness.

## 4. What Exists Now And What Does Not

### 4.1 What Exists Now
OxCalc already has meaningful executable foundations:
1. immutable structural snapshots and projection-path lookup,
2. sequential candidate/reject/publish coordinator logic,
3. invalidation and overlay lifecycle state,
4. planner-driven DAG/SCC handling in the `TraceCalc` proving lane,
5. deterministic replay, diff, explain, retained-witness, and replay-appliance artifact emission.

These are real assets and should be preserved.

### 4.2 What Does Not Exist Yet
The following are still absent from the live TreeCalc engine path:
1. real node-bound formula artifact ownership as the driver of evaluation,
2. real OxFml bind products as the driver of reference meaning,
3. automatic dependency-graph build from formulas and bind facts,
4. actual evaluator-produced candidate results as the active execution path,
5. real tree-relative and direct-node reference support beyond the test-only `TraceCalc` calc-space,
6. end-to-end structure -> formula -> bind -> dependency -> evaluation -> publication execution over the real engine substrate.

The work sequence below exists to close exactly that gap.

## 5. TreeCalc Engine Scope For This Phase

### 5.1 Structural Substrate
The first TreeCalc-ready engine phase assumes:
1. a tree-structured node substrate,
2. named nodes with stable IDs,
3. optional containment hierarchy used for projection and relative-reference context,
4. no grid substrate,
5. no hidden grid assumptions in semantic rules.

### 5.2 Node Kinds
The minimum TreeCalc node taxonomy for this phase should cover:
1. root/container nodes,
2. calculation nodes with formulas,
3. constant/value nodes,
4. structural grouping nodes where needed for relative-reference context,
5. explicit reserve room for later host-only or synthetic nodes without letting them become semantic smuggling channels.

### 5.3 Reference Families In Scope
The first TreeCalc-ready engine should cover at least:
1. direct named-node references,
2. tree-relative references based on explicit relative-navigation semantics,
3. static multi-dependency formulas,
4. conditional dependency selection where the effective edge set depends on runtime facts,
5. explicit direct-binding-sensitive families where semantic truth depends on concrete identity,
6. typed unsupported or out-of-scope reference paths as explicit no-publish or unsupported outcomes.

### 5.4 Reference Families Out Of Scope
Not required for this first phase:
1. grid-address references,
2. full Excel workbook-sheet-range semantics,
3. broad host-query families beyond the declared TreeCalc/OxFml seam floor,
4. advanced spilling/grid occupancy semantics outside the already bounded shape-effect categories.

## 6. End-To-End Semantic Pipeline To Realize
The first TreeCalc-ready engine must make the following pipeline real:

1. **Structural intake**
   - create or update immutable TreeCalc structural snapshots
   - preserve stable node identity
   - preserve explicit projection context for relative-reference interpretation

2. **Formula artifact attachment**
   - each formula-bearing node points to an immutable OxFml-owned formula artifact package
   - formula artifact identity participates in snapshot/version/fence discipline

3. **Bind and reference meaning intake**
   - OxCalc consumes OxFml bind products and reference descriptors
   - OxCalc does not reinterpret formula grammar locally
   - OxCalc does own how bind products participate in dependency, invalidation, and publication

4. **Structural dependency derivation**
   - build the static dependency graph derivable from structure plus bind facts
   - isolate cycle regions explicitly
   - keep dependency additions/removals/reclassifications explicit where runtime discovery changes the effective graph

5. **Invalidation and work discovery**
   - derive stale or needed work from structural edits, upstream publication, or runtime-derived dependency changes
   - keep the invalidation state model explicit

6. **Evaluation and candidate-result production**
   - invoke OxFml-backed evaluator work
   - produce real `AcceptedCandidateResult` seam objects
   - preserve typed reject and no-publish outcomes

7. **Overlay and runtime-derived fact handling**
   - dynamic dependencies, capability-sensitive effects, format-sensitive effects, execution restrictions, and shape effects are handled as explicit runtime-derived state
   - no hidden mutable caches may carry semantic truth

8. **Coordinator accept/reject/publication**
   - apply snapshot/fence/token/profile/capability compatibility checks
   - accept or reject candidate work deterministically
   - publish accepted results atomically

9. **Observer-visible stabilization**
   - preserve stable published views
   - preserve pinned-reader views
   - preserve replay-visible distinction between candidate, reject, and commit

10. **Replay and assurance emission**
   - emit trace, diff, explain, witness, and retained-failure artifacts for the covered TreeCalc scope
   - keep the ordinary engine path and assurance surfaces aligned

## 7. Design Constraints For The First TreeCalc-Ready Engine

### 7.1 No Hidden Structural Mutation
Dependency truth derived from formulas and bind artifacts must never be maintained only as mutable runtime state.

The engine may:
1. cache,
2. overlay,
3. retain derived data,
4. preserve runtime-observed edges explicitly.

The engine may not:
1. smuggle structural dependency truth into mutable side tables,
2. treat replay-only artifacts as the true engine state,
3. let runtime convenience replace versioned structural truth.

### 7.2 OxFml Owns Parse/Bind/Evaluator Meaning
OxCalc must not drift into owning formula-language semantics.

OxCalc owns:
1. structural truth,
2. dependency integration,
3. invalidation policy,
4. coordinator policy,
5. publication semantics,
6. replay and assurance binding for the engine.

OxFml owns:
1. parse and bind semantics,
2. evaluator artifact meaning,
3. typed execution and reject contexts,
4. replay-safe identity and fence meaning where evaluator/runtime artifacts are canonical.

### 7.3 Sequential First, But Concurrency-Compatible
The first TreeCalc-ready engine is sequential.

But every design choice in this phase must preserve:
1. single-publisher coordinator authority,
2. immutable structural truth,
3. explicit runtime-derived state,
4. replay-visible candidate/reject/publication distinction,
5. future Stage 2 concurrency without semantic replacement.

### 7.4 No Test-Only Semantics In The Real Engine Path
`TraceCalc` remains valuable as:
1. self-contained corpus,
2. executable semantic oracle substrate,
3. retained-witness and replay proving surface.

But the first TreeCalc-ready engine phase is not satisfied by improving `TraceCalc` alone.
It must move actual engine execution onto real formula/bind/candidate-result flows.

## 8. Engine Surfaces To Realize In OxCalc

### 8.1 Structural Model
OxCalc needs a richer structural model than the current proving-floor root-with-children shape.

This phase should explicitly realize:
1. stable node identity,
2. node symbol and projection identity,
3. parent/child and sibling relation enough for relative-reference context,
4. formula-artifact attachment at node level,
5. structural edit operations that respin immutable snapshots.

### 8.2 Formula Attachment Model
Each formula-bearing node should carry, directly or via explicit structural payload:
1. formula artifact reference,
2. bind-product reference,
3. stable formula artifact identity,
4. compatibility and version handles required for coordinator and replay.

### 8.3 Dependency Model
OxCalc should explicitly realize:
1. static dependency edges derived from bind facts,
2. reverse dependencies,
3. explicit cycle region representation,
4. runtime-derived dependency change objects,
5. dependency identity stable enough for replay and witness reduction.

### 8.4 Invalidation Model
The first TreeCalc-ready phase must carry the already-declared invalidation vocabulary into the real engine path:
1. `clean`
2. `dirty_pending`
3. `needed`
4. `evaluating`
5. `verified_clean`
6. `publish_ready`
7. `rejected_pending_repair`
8. `cycle_blocked`

### 8.5 Candidate Intake Model
The live engine path must consume real seam-produced candidate results, not only local synthetic values.

### 8.6 Publication Model
The current coordinator model should remain authoritative, but it must now be driven by real TreeCalc evaluator outputs.

### 8.7 Overlay Model
The overlay layer must move from proving-floor support to actual TreeCalc runtime relevance:
1. dynamic dependency overlay,
2. invalidation/execution-state overlay,
3. capability/fence attachment overlay,
4. format-sensitive and execution-restriction-sensitive runtime attachments where semantically relevant.

## 9. OxFml Seam Requirements For This Phase
This phase depends on a narrower, more explicit consumed seam than the current proving floor.

The goal is not to reopen seam ownership broadly.
The goal is to define the exact consumed floor needed for the first real TreeCalc engine path.

### 9.1 Required Seam Inputs
OxCalc must be able to consume, per formula-bearing node or candidate-result family:
1. formula artifact identity,
2. bind-product identity,
3. snapshot and fence compatibility basis,
4. profile/version basis,
5. candidate-result and reject identities,
6. dependency consequence facts,
7. runtime-derived effect facts,
8. publication-consequence categories.

### 9.2 Identity And Fence Floor
The consumed identity/fence floor for this phase should include:
1. `formula_stable_id`
2. `formula_token`
3. `snapshot_epoch`
4. `bind_hash`
5. `profile_version`
6. `capability_view_key` as important consumed compatibility state
7. `candidate_result_id`
8. `commit_attempt_id` where present
9. `reject_record_id` where relevant
10. optional `fence_snapshot_ref` where present

### 9.3 Bind And Reference Meaning Floor
OxCalc needs OxFml to surface, for the covered TreeCalc scope:
1. static direct references,
2. relative-reference descriptors or already-bound relative targets,
3. typed unresolved or host-query-sensitive references,
4. dependency additions/removals/reclassifications as evaluator/runtime facts,
5. dynamic selection families where the effective runtime dependency set is not fully static.

### 9.4 Candidate Result Floor
The live TreeCalc engine path must consume candidate-result categories aligned with:
1. `value_delta`
2. `shape_delta`
3. `topology_delta`
4. optional `format_delta`
5. optional `display_delta`
6. spill or shape event families where present
7. surfaced evaluator/runtime facts that matter to coordinator behavior

### 9.5 Reject Context Floor
The first TreeCalc-ready engine should rely on typed reject contexts covering at least:
1. snapshot mismatch
2. artifact/token mismatch
3. profile mismatch
4. capability denial
5. publication-fence mismatch
6. execution restriction or invalid phase outcome
7. dynamic dependency failure
8. host-sensitive resolution failure where relevant

### 9.6 Runtime-Derived Effect Floor
The consumed runtime-derived effect floor should include at least:
1. dynamic reference activation/release
2. region or shape activation/release
3. capability observations
4. format observations
5. execution-restriction observations
6. host-query-sensitive facts where they affect candidate or publication meaning

### 9.7 Direct-Binding And Host-Sensitive Truth
Where TreeCalc semantics depend on concrete binding identity rather than name-only semantics:
1. OxFml remains authoritative for the meaning of those bindings,
2. OxCalc must preserve them in replay, reduced witnesses, and pack-candidate families,
3. the first TreeCalc-ready engine should not erase or normalize those identities away.

### 9.8 Semantic-Format Versus Display Boundary
This phase should explicitly consume:
1. semantic consequences needed for stabilized engine truth,
2. format-sensitive consequences that may affect runtime or later observer policy,
3. display-sensitive consequences only to the extent needed to keep the seam honest for future widening.

This first phase does **not** need to solve broad display semantics.
It does need to avoid collapsing semantic, format, and display categories into one generic side effect.

## 10. TreeCalc Reference Semantics To Lock Locally
This section defines the local coordinator-facing questions that must be explicit before implementation starts.

### 10.1 Absolute Direct Node References
Need explicit local semantics for:
1. stable target-node identity,
2. what happens if the target node moves structurally but remains semantically the same node,
3. what happens if the target disappears,
4. replay-visible dependency identity.

### 10.2 Tree-Relative References
Need explicit local semantics for:
1. what structural context anchors relative lookup,
2. whether relative meaning is bind-time fixed or runtime-context-sensitive,
3. which structural edits force rebind or re-evaluation,
4. how relative-reference changes surface as dependency reclassification versus hard rebinding.

### 10.3 Named Or Symbolic References
Need explicit local semantics for:
1. whether they resolve to stable node identity before evaluation,
2. whether the bind product already fixes them,
3. how ambiguity or rebinding failure is represented.

### 10.4 Dynamic Reference Families
Need explicit local semantics for:
1. what part of dependency meaning is static,
2. what part is runtime-observed,
3. what candidate-result payload must surface when the effective dependency set changes,
4. what triggers fallback.

## 11. Runtime And Coordinator Semantics To Lock

### 11.1 Structural Edit Consequences
The first TreeCalc-ready engine should make structural edit consequences explicit for:
1. node rename,
2. node move in the tree,
3. formula replacement,
4. node addition/removal,
5. changes that alter relative-reference meaning.

### 11.2 Rebind Versus Recalc
Need an explicit boundary between:
1. structure or formula changes that require rebind,
2. changes that leave bind valid but require recalc,
3. runtime-derived changes that require only dynamic dependency overlay updates.

### 11.3 Candidate/Publication Consequences
Need explicit rules for:
1. when topology consequences become publication-visible,
2. when runtime-derived facts remain internal only,
3. when format-sensitive facts must remain attached to stable publication bundles,
4. when reject paths preserve diagnostics but no publish-scoped effect.

### 11.4 Verified-Clean Semantics
Need an explicit rule for what "verified clean" means in the real TreeCalc path:
1. no observable semantic change for the declared equality surface,
2. no publication emitted,
3. explicit trace and replay semantics.

## 12. Required Evidence For This Phase
The first TreeCalc-ready engine phase should not be declared reached without all of the following:

### 12.1 Structural/Formula Evidence
1. checked-in TreeCalc corpus scenarios that use real node/formula/reference families,
2. real formula artifact and bind intake through the live engine path.

### 12.2 Coordinator Evidence
1. deterministic accept/reject/publication artifacts for the covered TreeCalc scope,
2. pinned-view invariants exercised over real formula-driven runs.

### 12.3 Dependency Evidence
1. dependency graph artifacts or deterministic diagnostics showing real formula-driven dependency derivation,
2. exercised dynamic-dependency or dependency-reclassification cases where in scope.

### 12.4 Replay Evidence
1. ordinary replay-appliance bundle roots for the TreeCalc corpus,
2. engine diff and explain artifacts over the real engine path,
3. retained-witness continuation where the real engine path creates new mismatch families.

### 12.5 Assurance Evidence
1. W008 and W009 bindings refreshed against the real TreeCalc engine path,
2. at least one formal or model artifact updated where object names or transition meaning changed materially.

## 13. Work Sequence To Reach The First TreeCalc-Ready Engine
This sequence is the line-of-sight plan.
It is intentionally phrased as a work sequence that can later be broken into discrete worksets.

### TS-1: TreeCalc Structural And Formula-Carrying Substrate
Objective:
1. widen the structural model so nodes can carry real formula/bind artifact references and relative-reference context.

Exit gate:
1. immutable snapshots can represent the first real TreeCalc node/formula substrate,
2. structural edit and identity rules are explicit enough to implement rebind/recalc consequences.

### TS-2: OxFml TreeCalc Bind And Reference Intake
Objective:
1. lock and consume the first real OxFml bind/reference package needed for TreeCalc.

Exit gate:
1. OxCalc can consume formula artifact identities, bind identities, and reference meaning for the covered TreeCalc families,
2. unresolved seam items are narrowed explicitly.

### TS-3: Dependency Graph Build From Real Formula/Bind Facts
Objective:
1. replace planner-only dependency derivation with real static dependency build from consumed bind facts.

Exit gate:
1. structural dependency graph and reverse edges exist for the covered TreeCalc formula families,
2. dependency identity is replay-visible.

### TS-4: Real Candidate-Result Intake Path
Objective:
1. move candidate intake from synthetic/scripted `TraceCalc` candidates to real OxFml-backed evaluator outputs.

Exit gate:
1. the coordinator consumes real seam-produced candidate results and typed rejects for the covered TreeCalc scope.

### TS-5: Runtime-Derived Dependency And Overlay Closure
Objective:
1. make dynamic dependency, capability, execution-restriction, and shape-sensitive runtime effects real in the engine path.

Exit gate:
1. runtime-derived facts that affect recalc or publication are explicit, replay-visible, and no longer test-only constructs.

### TS-6: Real TreeCalc Recalc/Publication End-To-End Runs
Objective:
1. execute a TreeCalc corpus through structure -> dependency -> evaluation -> candidate -> publish.

Exit gate:
1. the live engine path can run the first TreeCalc corpus without `TraceCalc` scripted semantics standing in for real formula execution.

### TS-7: Corpus And Oracle Widening For TreeCalc Scope
Objective:
1. widen the corpus and oracle surface so the real TreeCalc engine can be compared deterministically.

Exit gate:
1. ordinary TreeCalc runs have conformance and replay artifacts analogous to the current `TraceCalc` lane.

### TS-8: Sequential TreeCalc-Ready Baseline
Objective:
1. emit the first baseline run that honestly represents the first TreeCalc-ready sequential engine.

Exit gate:
1. one checked-in TreeCalc-ready baseline exists,
2. semantic-equivalence statement is explicit for any strategy substitutions used along the way.

### TS-9: Assurance And Pack Refresh For The New Engine Path
Objective:
1. refresh TLA+/replay/pack bindings around the live TreeCalc path so the proving surface matches the engine we actually have.

Exit gate:
1. no major semantic clause remains bound only to the older proving substrate.

## 14. Recommended Workset Breakdown Direction
This document does not assign final workset numbers.

But the recommended decomposition is:
1. one workset for structural/future-proof TreeCalc substrate widening,
2. one workset for OxFml seam intake focused on TreeCalc formula/bind/reference packages,
3. one workset for real dependency graph build and invalidation closure,
4. one workset for evaluator-backed candidate-result integration,
5. one workset for runtime-derived dependency and overlay closure,
6. one workset for TreeCalc corpus/oracle widening and first baseline evidence,
7. one workset for assurance refresh and residual packetization.

That split keeps the major semantic boundaries visible:
1. structural truth,
2. seam intake,
3. dependency truth,
4. candidate/publication truth,
5. runtime-derived truth,
6. evidence truth.

### 14.1 Packetized Workset Mapping
The current recommended packetization of this sequence is:
1. `W025_TREECALC_STRUCTURAL_AND_FORMULA_SUBSTRATE_WIDENING.md`
   - covers `TS-1`
2. `W026_TREECALC_OXFML_BIND_REFERENCE_AND_SEAM_INTAKE.md`
   - covers the consumed-seam floor for `TS-2`
3. `W027_TREECALC_DEPENDENCY_GRAPH_AND_INVALIDATION_CLOSURE.md`
   - covers `TS-3` plus the structural invalidation closure portions of `TS-5`
4. `W028_TREECALC_EVALUATOR_BACKED_CANDIDATE_RESULT_INTEGRATION.md`
   - covers `TS-4`
5. `W029_TREECALC_RUNTIME_DERIVED_EFFECTS_AND_OVERLAY_CLOSURE.md`
   - covers the runtime-derived effect and overlay portions of `TS-5`
6. `W030_TREECALC_CORPUS_ORACLE_AND_FIRST_SEQUENTIAL_BASELINE.md`
   - covers `TS-6`, `TS-7`, and `TS-8`
7. `W031_TREECALC_ASSURANCE_REFRESH_AND_RESIDUAL_PACKETIZATION.md`
   - covers `TS-9` and any residual packetization required after the first TreeCalc-ready baseline

This decomposition is the intended line-of-sight sequence after the current replay-pack residual lane.

## 15. Non-Negotiable Guardrails For Later Performance Work
The following must remain true so later ultraperformance work still lands on the right semantic base:
1. no scheduler or caching shortcut may redefine stabilized semantic truth,
2. no optimization may bypass single-publisher coordinator authority,
3. dynamic dependencies remain explicit runtime-derived state rather than hidden mutable graph edits,
4. formula parse/bind/evaluator meaning remains OxFml-owned,
5. relative-reference meaning remains explicit and replay-visible,
6. direct-binding-sensitive truth remains preserved where semantics depend on it,
7. structural truth remains immutable and versioned,
8. concurrency arrives only after the sequential TreeCalc engine path is semantically real.

## 16. Immediate Design Questions To Resolve Early
The following questions should be resolved early in the next work sequence rather than deferred:
1. exact first TreeCalc reference-family subset,
2. exact bind-product shape OxCalc will consume,
3. exact structural edit families the first TreeCalc engine must support,
4. exact dependency artifact or diagnostic shape emitted by the live engine path,
5. exact verified-clean semantics for real formula-driven runs,
6. exact format/display consequence floor to consume without overcommitting.

## 17. Relationship To Existing Work
This document does not replace:
1. the canonical architecture docs,
2. the current roadmap,
3. the `TraceCalc` proving lane,
4. the current replay and retained-witness lanes.

It does:
1. define the next real semantic target,
2. explain the gap between today’s proving substrate and that target,
3. define the execution line needed to close that gap.

## 18. Status
- execution_state: planned
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - this document defines the target and sequence, but no new TreeCalc-ready engine workset has been executed yet
  - real TreeCalc formula/bind/evaluation flow is still absent from the live engine path
  - narrower TreeCalc-specific OxFml seam intake still needs to be packetized from this plan
- claim_confidence: provisional
- reviewed_inbound_observations: latest OxFml downstream note consumed as seam baseline; no new immediate handoff trigger exists yet

## Source: `OxCalc/docs/spec/README.md`

# OxCalc Spec Index

This directory is the OxCalc-owned mutable spec library.

## Canonical OxCalc Set
The rewritten canonical core-engine set is:
- `docs/spec/core-engine/CORE_ENGINE_ARCHITECTURE.md`
- `docs/spec/core-engine/CORE_ENGINE_STATE_AND_SNAPSHOTS.md`
- `docs/spec/core-engine/CORE_ENGINE_RECALC_AND_INCREMENTAL_MODEL.md`
- `docs/spec/core-engine/CORE_ENGINE_OVERLAY_AND_DERIVED_RUNTIME.md`
- `docs/spec/core-engine/CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md`
- `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`
- `docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md`
- `docs/spec/core-engine/CORE_ENGINE_FORMALIZATION_AND_ASSURANCE.md`
- `docs/spec/core-engine/CORE_ENGINE_REALIZATION_ROADMAP.md`
- `docs/spec/core-engine/CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`

## Downstream Host Seam-Reference Rule
If a downstream host such as `DNA OneCalc` needs OxCalc as seam-reference material only:
1. start with `README.md`, `CHARTER.md`, `OPERATIONS.md`, `CURRENT_BLOCKERS.md`, and `docs/IN_PROGRESS_FEATURE_WORKLIST.md`,
2. then use `docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` as the local authority filter,
3. read `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md` as the canonical OxCalc-local seam companion,
4. read `docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md` only as the first deterministic upstream-host packet companion,
5. treat `docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md` as a temporary narrower-topic tracker rather than as seam authority.

## Supporting Realization and Test Docs
- `docs/spec/core-engine/CORE_ENGINE_TEST_HARNESS_AND_FIXTURES.md`
  - supporting companion for self-contained fixture, scenario, and alternate calculation-space design.
- `docs/spec/core-engine/CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
  - supporting companion defining canonical JSON scenario schema and the first concrete `TraceCalc` surface.
- `docs/spec/core-engine/CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
  - supporting companion defining how the self-contained corpus is validated, executed, and emitted as run artifacts.
- `docs/spec/core-engine/CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
  - supporting companion defining the executable semantic oracle and later-engine conformance baseline.
- `docs/spec/core-engine/CORE_ENGINE_REPLAY_APPLIANCE_ADAPTER.md`
  - supporting companion defining how OxCalc-owned `TraceCalc`, runner, oracle, and diff artifacts project into the Foundation Replay appliance rollout.
- `docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md`
  - supporting planning companion defining the topic-by-topic TreeCalc seam negotiation shape for the next OxCalc↔OxFml note rounds and W026 intake work; not canonical seam authority.
- `docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`
  - supporting companion defining the first OxCalc-owned minimal upstream host packet and adapter used to drive OxFml in deterministic automated scaffolding; reference material for downstream hosts, but not a production API freeze.

## Seed Test Corpus
- `docs/test-corpus/core-engine/tracecalc/README.md`
  - first checked-in self-contained `TraceCalc` scenario corpus.

## Archived Rewrite-Control Material
The rewrite-control artifacts used to establish the canonical set are preserved for provenance under:
- `docs/spec/core-engine/archive/rewrite-control-2026-03/`

These files are historical planning and promotion-control artifacts, not active canonical guidance.

## Bootstrap Archive and Reference-Only Material
The previous bootstrap set is preserved under:
- `docs/spec/core-engine/archive/bootstrap-2026-03/`

Bootstrap redirect/reference-only files remain in `docs/spec/core-engine/` for provenance and pointer stability.
Foundation snapshot files in `docs/spec/core-engine/` are local reference support, not OxCalc-owned canonical architecture.

## Visibility and Related Policy Docs
- `docs/spec/visibility/*`
  - retained for visibility-priority and formatting-boundary policy work.

## Consumed Mirror Set
- `docs/spec/fec-f3e/*`
  - copied from OxFml-owned canonical seam specs for local implementation reference.

## Mirror Policy
1. OxCalc owns its canonical core-engine spec set in this repo.
2. OxFml owns the canonical shared FEC/F3E seam specification.
3. Foundation retains doctrine and conformance-policy ownership and keeps read-only mirrors/snapshots for cross-program assurance.

## Source: `OxCalc/README.md`

# OxCalc

OxCalc is the multi-node core calculation engine lane for DNA Calc.

## Core Responsibilities
1. Structural dependency graph management and invalidation policy.
2. Calc-time overlay lifecycle (dynamic references, spill overlays, visibility metadata).
3. Coordinator scheduling and publication semantics.
4. Deterministic staged realization (Stage 1 sequential -> Stage 2 partitioned parallel -> Stage 3 advanced lanes).

## Implementation Direction
1. OxCalc implementation work is now Rust-first for the core engine and the `TraceCalc` tool/runtime lane.
2. The active implementation lives under `src/` as a Rust workspace with separate crates for the core engine, `TraceCalc`, and the CLI host.
3. Historical baseline runs remain valuable as carried evidence, but the repo no longer carries a parallel prior-language implementation tree.
4. New implementation design should be idiomatic Rust rather than a line-by-line or pattern-by-pattern transfer of older non-Rust shapes.

## Startup Docs
- `CHARTER.md`
- `OPERATIONS.md`
- `docs/spec/README.md`
- `docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` for downstream hosts that use OxCalc as seam-reference material only

## Dependency Constitution
- May depend on: `OxFml`, `OxFunc`.
- Must not depend on: host/UI/file-adapter layers.

## Foundation Alignment
Precedence and constitutional constraints are inherited from:
1. `../Foundation/CHARTER.md`
2. `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
3. `../Foundation/OPERATIONS.md`

