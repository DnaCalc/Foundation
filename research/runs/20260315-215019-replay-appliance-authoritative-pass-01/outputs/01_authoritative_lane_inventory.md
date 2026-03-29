# Authoritative Lane Inventory For Replay Appliance Design

## 1. Executive Reading
The four `Ox*` repos are no longer converging toward replay from a blank page. They already contain four different but compatible partial architectures:
1. `OxCalc` has a self-contained scenario corpus, a validator-runner contract, a reference-machine oracle direction, and explicit Stage 1 replay classes.
2. `OxFml` has the strongest typed artifact model: identity categories, artifact families, minimum seam schemas, typed rejects, and replay fixture planning.
3. `OxFunc` has the strongest empirical replay discipline: scenario manifests, dual-run labels, evidence ids, execution records, and boundary-invariant tracking.
4. `OxVba` has the strongest runner-policy and clause-traceability discipline: profile fingerprints, clause catalogs, structured conformance outputs, and deferred-oracle governance.

The Replay appliance should therefore be specified as:
1. a cross-lane bundle, runner, diff, and explain contract,
2. implemented through lane adapters,
3. without displacing lane-owned semantics or lane-native artifact vocabularies.

## 2. OxCalc Inventory

### 2.1 Current authoritative surfaces
- `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`
- `docs/spec/core-engine/CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
- `docs/spec/core-engine/CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
- `docs/spec/core-engine/CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
- `docs/worksets/W009_REPLAY_AND_PACK_BINDING_FOR_STAGE1_SEAM_AND_COORDINATOR_BEHAVIOR.md`

### 2.2 Replay-relevant conclusions
1. OxCalc already distinguishes `AcceptedCandidateResult` from committed publication and treats reject as explicit no-publish behavior.
2. OxCalc already wants deterministic scenario files, validator-enforced admissibility, typed failure classes, and canonical per-run artifact roots.
3. OxCalc already has the seed of a cross-engine oracle/diff workflow in `TraceCalc Reference Machine` plus `engine_diff.json`.
4. OxCalc replay is currently scoped around Stage 1 coordinator behavior, pinned views, overlay retention, and reject taxonomy.

### 2.3 Implication for the Replay appliance
The Replay appliance must not invent a new OxCalc-local replay model. It must absorb and generalize:
1. `TraceCalc` scenario identity and artifact layout,
2. candidate-versus-publication boundary preservation,
3. pinned-view and published-view separation,
4. typed mismatch kinds for diffing,
5. pack bindings from `R1..R8` replay classes.

## 3. OxFml Inventory

### 3.1 Current authoritative surfaces
- `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
- `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
- `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
- `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
- `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
- `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`

### 3.2 Replay-relevant conclusions
1. OxFml already distinguishes stable identity, version keys, content fingerprints, runtime handles, and fence members. The Replay appliance must preserve those distinctions rather than flatten them into one run-local id.
2. OxFml already has a canonical artifact ladder:
   - `FormulaSourceRecord`
   - `GreenTreeRoot`
   - `BoundFormula`
   - `SemanticPlan`
   - `PreparedCall`
   - `PreparedResult`
   - evaluator facts
   - `AcceptedCandidateResult`
   - `CommitBundle` or `RejectRecord`
3. OxFml already treats trace schema, reject taxonomy, and minimum schema objects as part of the seam conformance surface.
4. OxFml already recognizes the open problem of subsystem trace schema versus unified trace schema merge strategy.

### 3.3 Implication for the Replay appliance
The Replay appliance must be a projection layer over OxFml artifacts, not a replacement schema. It should:
1. preserve lane-native artifact ids and schema ids,
2. normalize correlation and transport only,
3. keep typed deltas, facts, rejects, and session lifecycle events first class,
4. allow fixture families to be re-emitted as portable replay bundles.

## 4. OxFunc Inventory

### 4.1 Current authoritative surfaces
- `docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
- `docs/function-lane/DOCTRINE_DECISION_FULL_EMPIRICAL_FUNCTION_IDENTITY_20260309.md`
- `docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
- `docs/function-lane/CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md`
- workset-specific probe runtime requirement docs such as `W15_PROBE_RUNTIME_REQUIREMENTS.md`

### 4.2 Replay-relevant conclusions
1. OxFunc evidence is already manifest-driven and artifact-rich. It tracks scenario seeds, execution records, output files, compatibility labels, locale profile, and evidence ids.
2. OxFunc replay is usually row- or packet-oriented rather than micro-event-oriented. The Replay appliance must support coarse-grained empirical replay, not force everything into per-step engine events.
3. OxFunc explicitly requires shared contracts, manifests, and correlation artifacts to keep Excel behavior, contracts, Rust, and Lean aligned.
4. OxFunc boundary invariants span formula evaluation, interop ingress, reference reuse, persistence, interchange, and optional XLL lanes.

### 4.3 Implication for the Replay appliance
The Replay appliance must support:
1. scenario manifest ingestion as a first-class replay source,
2. evidence ids and run labels as durable metadata,
3. declared boundary invariants and XLL limitation markers,
4. packet-level dual-run replay and diff without demanding intrusive runtime instrumentation where the lane already works by empirical replay.

## 5. OxVba Inventory

### 5.1 Current authoritative surfaces
- `docs/spec/HOST_RUNNER_POLICY_BOOTSTRAP_V1.md`
- `docs/spec/HAL_CONFORMANCE_SUITE.md`
- `docs/spec/HAL_FORMALIZATION_PROGRAM.md`
- `docs/CONFORMANCE.md`
- additional COM and PMR conformance drafts under `docs/spec/`

### 5.2 Replay-relevant conclusions
1. OxVba already treats runner profile and policy selection as reproducible auditable input with a required startup fingerprint.
2. OxVba already emits artifact-rich conformance outputs under controlled evidence paths and has a strong distinction between tracked evidence and temporary no-artifact runs.
3. OxVba already structures verification around clause catalogs, machine-readable mappings, profile ids, deferred-oracle gates, and deterministic unsupported behavior.
4. OxVba host/COM/formal lanes often cannot be meaningfully replayed from raw runtime objects; they need replay-safe projections of host facts, diagnostics, and clause coverage.

### 5.3 Implication for the Replay appliance
The Replay appliance must support:
1. configuration fingerprint capture as part of replay identity,
2. clause coverage and deferred-oracle status as replay metadata,
3. replay-safe host projections instead of opaque external handles,
4. both tracked evidence runs and local no-artifact validation modes.

## 6. Cross-Lane Synthesis

### 6.1 What is already convergent
Across the four repos, the following ideas already align:
1. deterministic execution and replay are mandatory, not optional niceties,
2. typed artifacts beat unstructured logs,
3. runner/config fingerprints are part of semantic reproducibility,
4. stable ids and version keys matter,
5. candidate-versus-publication and reject-is-no-publish distinctions must survive into artifacts,
6. pack and conformance claims need machine-readable evidence.

### 6.2 What is still fragmented
The following are not yet unified:
1. one portable replay bundle contract,
2. one shared event-envelope model for cross-lane tooling,
3. one diff/explain plane spanning empirical packets, seam events, coordinator traces, and host-policy runs,
4. one explicit performance model for how capture is woven into hot paths,
5. one shared tool surface for capture, normalize, replay, diff, explain, and pack export.

## 7. Resulting Design Rule
The Replay appliance should be specified as a cross-lane Logistics tool and bundle contract with four adapter families:
1. `OxCalc` adapter for self-contained scenarios, reference-machine runs, and engine diffs,
2. `OxFml` adapter for seam fixtures, session traces, candidate/commit/reject artifacts, and schema witness packs,
3. `OxFunc` adapter for manifest-driven empirical packets and evidence-id-linked alignment runs,
4. `OxVba` adapter for profile/policy-configured conformance runs, clause coverage, and replay-safe host projections.

