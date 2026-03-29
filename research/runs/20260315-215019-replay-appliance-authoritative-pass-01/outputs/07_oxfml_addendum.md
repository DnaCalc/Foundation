# OxFml Addendum For The Replay Appliance

## 1. Purpose
This addendum defines how `OxFml` should incorporate the Replay appliance while preserving its existing ownership of:
1. evaluator-side FEC/F3E semantics,
2. canonical artifact identities,
3. canonical seam payload shapes,
4. trace schema and reject taxonomy.

The Replay appliance must project OxFml artifacts.
It may not replace OxFml as the seam-spec owner.

## 2. Current authoritative anchors
Primary anchors:
1. `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
2. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
3. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
4. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
5. `docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`
6. `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
7. `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
8. `docs/spec/fec-f3e/FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv`

## 3. OxFml-specific replay rule
For `OxFml`, replay truth lives in canonical keys, typed artifacts, and typed lifecycle boundaries.

That means the Replay appliance must preserve, not flatten:
1. stable ids,
2. version keys,
3. fingerprints,
4. session ids,
5. fence tuple members,
6. candidate-versus-commit distinction,
7. typed reject contexts,
8. typed effect and topology facts.

## 4. Required artifact projection

### 4.1 Artifact ladder projection
The Replay appliance should recognize the OxFml artifact ladder directly:
1. `FormulaSourceRecord`
2. `GreenTreeRoot`
3. `BoundFormula`
4. `SemanticPlan`
5. `PreparedCall`
6. `PreparedResult`
7. evaluator facts
8. `AcceptedCandidateResult`
9. `CommitBundle`
10. `RejectRecord`

Projection rule:
1. not every artifact must become an inline replay event,
2. every artifact that is needed for replay causality must be either inlined, referenced, or sidecar-linked,
3. the adapter must declare which families are lossless versus summarized.

### 4.2 Session lifecycle projection
The normalized replay family mapping should preserve:
1. `prepare_started`
2. `prepare_rejected`
3. `session_opened`
4. `capability_view_resolved`
5. `execute_started`
6. `execute_completed`
7. `accepted_candidate_result_built`
8. `commit_started`
9. `commit_accepted`
10. `commit_rejected`
11. typed reject events
12. effect and overlay events

These remain OxFml-owned event meanings.
The Replay appliance only standardizes transport and explanation.

## 5. Mandatory preserved fields

### 5.1 Identity and fence fields
Every OxFml replay bundle projection must preserve:
1. `formula_stable_id`
2. `formula_token`
3. `snapshot_epoch`
4. `bind_hash`
5. `profile_version`
6. `capability_view_key` where present
7. `session_id`
8. `commit_attempt_id`
9. candidate-result or reject fingerprints where present

### 5.2 Delta and effect fields
The normalized bundle must preserve or sidecar-link:
1. `value_delta`
2. `shape_delta`
3. `topology_delta`
4. optional `format_delta`
5. optional `display_delta`
6. surfaced evaluator facts required for replay
7. spill event set

### 5.3 Reject context fields
The normalized bundle must preserve typed reject context by family:
1. fence mismatch,
2. capability denial,
3. session termination,
4. bind mismatch,
5. structural conflict,
6. dynamic-reference failure,
7. resource or invariant failure.

## 6. Fixture-family incorporation
The Replay appliance should treat existing OxFml fixture families as first-class import sources.

Initial family mapping:
1. `fec_commit_replay_cases.json` -> candidate/commit/reject scenario bundles
2. `session_lifecycle_replay_cases.json` -> session lifecycle bundles
3. `execution_contract_replay_cases.json` -> scheduler-facing execution-contract bundles
4. `single_formula_host_replay_cases.json` -> proving-host bundles
5. `empirical_oracle_scenarios.json` -> formula empirical-oracle bundles

This lets current witness floors become portable without forcing fixture authors to rewrite them immediately.

## 7. Schema and trace obligations

### 7.1 Source schema remains primary
Each replay event emitted from OxFml must retain:
1. source schema id,
2. source trace version,
3. source payload type family,
4. source fixture family where applicable.

### 7.2 Normalized replay envelope is additive
The Replay appliance adds:
1. lane id,
2. bundle schema id,
3. scenario id,
4. cross-lane correlation fields,
5. sidecar refs,
6. diff/explain indexing support.

It must not erase source schema identity.

## 8. Witness distillation design for OxFml
OxFml witness distillation must remain artifact-aware and fence-aware.

### 8.1 Reduction units
The OxFml adapter should declare this hierarchy:
1. fixture case,
2. lifecycle phase block,
3. candidate or commit attempt,
4. typed reject-context member group,
5. delta or effect family slice,
6. artifact sidecar snapshot.

### 8.2 Preservation predicates
Initial OxFml predicate families should include:
1. same commit-accepted versus commit-rejected outcome,
2. same reject family and context class,
3. same candidate fingerprint or bind/fence mismatch class,
4. same effect or topology mismatch class,
5. same capability-denial outcome.

### 8.3 Closure rules
At minimum, the adapter must enforce:
1. retaining a candidate or reject also retains stable ids, bind hash, snapshot epoch, and relevant session id,
2. retaining a commit outcome also retains the producing candidate lineage and commit attempt id,
3. retaining a reject context member also retains the surrounding reject family and source boundary event,
4. retaining an effect mismatch also retains the effect family identifier and the causal lifecycle phase.

### 8.4 Search strategy
OxFml distillation should prefer:
1. dropping optional artifact bodies and sidecars first,
2. removing unused lifecycle phases second,
3. shrinking effect and reject payload slices third,
4. applying lane-owned fixture rewrites only when explicitly declared replay-safe.

### 8.5 Rewrite rule
Only OxFml-owned transforms may rewrite formula text, fence tuples, bind payloads, or capability views.
Generic cross-lane distillation may only do subset and sidecar-pruning operations.

## 9. Open OxFml alignment items that the addendum should carry forward
The Replay appliance spec should explicitly record these current gaps:
1. current code and minimum schema may differ on fields such as `reject_record_id` and `fence_snapshot_ref`,
2. `BindMismatchContext` needs closure between spec and code,
3. `capability_view_key` is checked today but still open as a first-class fence member,
4. subsystem schema merge strategy versus unified replay schema remains open.

These should be explicit bundle-version notes, not hidden assumptions.

## 10. Performance notes for OxFml
1. Do not serialize full parse trees or bound artifacts inline on every lifecycle event.
2. Emit canonical keys and lightweight typed payloads at boundaries.
3. Use sidecars for large artifact bodies such as parse, bind, or semantic-plan snapshots.
4. Candidate build, commit accept, commit reject, and typed effect discovery are the mandatory semantic boundaries.
5. Richer per-call provenance can be `forensic` mode or sidecar-backed.

## 11. Target docs for future incorporation
This addendum should eventually be reflected in:
1. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
2. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
3. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
4. `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
5. `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
6. `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`

## 12. Summary
For `OxFml`, the Replay appliance should look like:
1. a projection layer over current typed seam artifacts,
2. a portable import path for existing fixture families,
3. a shared bundle envelope around OxFml-owned trace and reject semantics,
4. a first-class witness-distillation path over lifecycle, candidate, reject, and effect slices,
5. a future bridge from local witness floors to pack-grade replay assets.
