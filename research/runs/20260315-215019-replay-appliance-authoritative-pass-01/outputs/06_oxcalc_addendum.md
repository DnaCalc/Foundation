# OxCalc Addendum For The Replay Appliance

## 1. Purpose
This addendum defines how `OxCalc` should incorporate the Replay appliance without surrendering local authority over:
1. coordinator semantics,
2. `TraceCalc`,
3. reference-machine conformance,
4. Stage 1 replay classes.

`OxCalc` should be the first full-fidelity adapter for `DNA ReCalc`.

## 2. Current authoritative anchors
Primary anchors:
1. `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`
2. `docs/spec/core-engine/CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
3. `docs/spec/core-engine/CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
4. `docs/spec/core-engine/CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
5. `docs/worksets/W009_REPLAY_AND_PACK_BINDING_FOR_STAGE1_SEAM_AND_COORDINATOR_BEHAVIOR.md`
6. `docs/test-corpus/core-engine/tracecalc/MANIFEST.json`
7. `formal/replay/stage1-hand-authored/*`

## 3. Why OxCalc should go first
`OxCalc` is the strongest first adapter because it already has:
1. explicit scenario identity,
2. explicit validator-runner contract,
3. explicit canonical artifact roots,
4. explicit replay classes,
5. explicit oracle and diff direction.

The Replay appliance should therefore adopt `OxCalc` as the first proving host for the bundle contract rather than asking `OxCalc` to wait for a more abstract future.

## 4. Required incorporation points

### 4.1 `TraceCalc` remains the source scenario contract
The Replay appliance must treat:
1. `MANIFEST.json`,
2. per-scenario JSON files,
3. scenario ids,
4. scenario tags,
5. expected view and counter surfaces
as canonical `OxCalc` inputs.

`DNA ReCalc` may add bundle projection.
It may not replace `TraceCalc` authoring with a new OxCalc-local scenario DSL.

### 4.2 Reference-machine output becomes bundle-native
The current canonical artifact root:
1. `docs/test-runs/core-engine/tracecalc-reference-machine/<run_id>/`

should be declared replay-appliance-compatible by projection, not by replacement.

Required mapping:
1. `run_summary.json` -> `ReplayRunManifest`
2. `manifest_selection.json` -> selection ref
3. `trace.json` -> normalized `ReplayEvent` stream
4. `counters.json` -> `ReplayCounterSet`
5. `published_view.json` -> `published_view`
6. `pinned_views.json` -> `pinned_view`
7. `rejects.json` -> `reject_set`
8. `engine_diff.json` -> `ReplayDiff`

### 4.3 Stage 1 replay classes become first-class scenario metadata
Replay classes `R1..R8` from W009 should be promoted into normalized metadata:
1. `replay_class`
2. `pack_bindings`
3. `safety_properties`
4. `transition_labels`

This lets `DNA ReCalc` understand pack intent without re-reading prose workset text.

### 4.4 Event-family mapping must be explicit
OxCalc should define a stable mapping from current scenario and replay labels into normalized families.

Minimum mapping:
1. `candidate_admitted` -> `candidate.admitted`
2. `candidate_recorded` or `candidate_emitted` -> `candidate.built`
3. `candidate_rejected` -> `reject.issued`
4. `publication_committed` or `candidate_published` -> `publication.committed`
5. `reader_pinned` -> `session.reader_pinned`
6. `reader_unpinned` -> `session.reader_unpinned`
7. `overlay_retained` -> `overlay.retained`
8. `overlay_released` -> `overlay.released`
9. `node_verified_clean` -> `candidate.verified_clean`
10. `fallback_forced` -> `candidate.fallback_forced`

Current label drift such as:
1. `candidate_emitted` versus `candidate_recorded`
2. `candidate_published` versus `publication_committed`

must be normalized deliberately, not left implicit.

### 4.5 View surfaces remain first-class
The following view surfaces must remain separately emitted:
1. published view,
2. pinned views,
3. reject set,
4. assertion failures,
5. counter set.

OxCalc must not reduce replay to trace labels alone.

### 4.6 Candidate-versus-publication must remain hard
The adapter must preserve:
1. candidate admitted,
2. candidate recorded,
3. reject with no publish,
4. later publish,

as distinct states.

No OxCalc adapter is allowed to collapse these into one "evaluation succeeded" event.

## 5. Required schema additions inside OxCalc

### 5.1 Add replay-appliance projection metadata
OxCalc should add a small adapter contract that states:
1. bundle schema version supported,
2. source schema versions supported,
3. lossy and lossless projections,
4. normalized event-family mapping,
5. normalized view mapping.

### 5.2 Add stable replay-class tagging to scenario corpus
`TraceCalc` scenarios should carry or derive:
1. replay class,
2. pack tags,
3. required equality surface,
4. optional forensic surface.

### 5.3 Add typed diff severity
`engine_diff.json` should classify:
1. semantic mismatch,
2. instrumentation mismatch,
3. informational mismatch.

This is necessary so `DNA ReCalc` explain output can distinguish real regressions from richer optional payload differences.

## 6. Witness distillation design for OxCalc
`OxCalc` should be the first lane to receive a full witness-distillation implementation.

### 6.1 Reduction units
The OxCalc adapter should declare this reduction hierarchy:
1. scenario selection,
2. scenario phase block,
3. normalized event group keyed by candidate, publish attempt, reject, or overlay transition,
4. view slice such as published cell set or pinned-view slice,
5. reject record,
6. sidecar payload block.

### 6.2 Preservation predicates
Initial OxCalc predicate families should include:
1. same `engine_diff` mismatch kind and severity,
2. same candidate-versus-publication outcome,
3. same reject family and reject context class,
4. same published-view or pinned-view mismatch,
5. same assertion failure class.

### 6.3 Closure rules
At minimum, the adapter must enforce:
1. retaining a publication event also retains the producing candidate lineage and relevant scenario inputs,
2. retaining a reject record also retains the candidate, triggering boundary event, and typed reject context,
3. retaining a view mismatch also retains the minimal source scenario slice and events needed to reconstruct the view,
4. retaining an overlay lifecycle mismatch also retains the adjacent retention and release boundaries.

### 6.4 Search strategy
OxCalc distillation should use:
1. explain-guided seeding from `engine_diff` and view mismatches,
2. coarse scenario-phase elimination first,
3. event-group elimination second,
4. fine view-slice pruning last,
5. lane-declared rewrites only after subset reduction stalls.

### 6.5 Allowed rewrites
Allowed rewrites should be narrow and explicit:
1. scenario subset reduction,
2. optional assertion or sidecar pruning,
3. lane-owned scenario simplifications only if `TraceCalc` declares them as replay-safe transforms.

No generic Replay appliance layer may rewrite OxCalc scenario meaning on its own.

## 7. Pack binding requirements
OxCalc should be the first lane to make `PACK.replay.appliance` concrete.

Minimum bindings:
1. `R1` and `R3` compatible branch -> `PACK.fec.commit_atomicity`
2. `R2` and `R6` -> `PACK.fec.reject_detail_replay`
3. `R4` and `R5` -> `PACK.concurrent.epochs` Stage 1 subset
4. `R5` and `R8` -> `PACK.fec.overlay_lifecycle`
5. `R8` -> `PACK.dag.dynamic_dependency_bind_semantics`
6. selected `TraceCalc` scenarios -> `PACK.replay.appliance`

## 8. Performance notes for OxCalc
1. The adapter should hook at scenario-step and coordinator-boundary transitions only.
2. Full invalidation-graph internals should not be serialized on the hot path.
3. Candidate, reject, publish, pin, and unpin are mandatory semantic boundaries.
4. Richer dependency or overlay payloads should move to sidecars when they become large.

## 9. Open OxCalc-specific alignment items
1. Resolve label drift between schema docs, seed replay artifacts, and future runner outputs.
2. Align self-contained reject/effect taxonomies with the broader Stage 1 seam packet where necessary.
3. Decide which richer trace payload fields stay optional in the first diff surface.
4. Close the gap between hand-authored seed artifacts and emitted runner artifacts.

## 10. Target docs for future incorporation
This addendum should eventually be incorporated into:
1. `docs/spec/core-engine/CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
2. `docs/spec/core-engine/CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
3. `docs/spec/core-engine/CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
4. `docs/spec/core-engine/CORE_ENGINE_FORMALIZATION_AND_ASSURANCE.md`
5. `docs/worksets/W009_REPLAY_AND_PACK_BINDING_FOR_STAGE1_SEAM_AND_COORDINATOR_BEHAVIOR.md`

## 11. Summary
For `OxCalc`, the Replay appliance should look like:
1. `TraceCalc` plus reference-machine output,
2. normalized into a portable bundle,
3. with event/view/diff rules made explicit,
4. with first-class witness distillation over scenario, event-group, and view-slice reductions,
5. so `PACK.replay.appliance` can become real without changing coordinator semantics.
