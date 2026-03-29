# Prompt: OxFml Replay Appliance Rollout

You are working inside the `OxFml` repository.
Follow local `AGENTS.md` and local doctrine or spec-precedence rules first.

## Mission
Incorporate the Replay appliance handoff from `..\Foundation` into the canonical `OxFml` spec set.

Do not mirror Foundation prose mechanically.
Adapt the cross-lane replay, witness-distillation, capability, registry, and witness-lifecycle design into OxFml-owned canonical docs while preserving OxFml ownership of:
1. formula-language semantics,
2. evaluator and seam artifacts,
3. canonical identity and fence rules,
4. typed reject and effect semantics.

## Authority and conflict rules
1. OxFml canonical docs remain authoritative for OxFml semantics.
2. The Foundation replay research run from `2026-03-15` is the authoritative handoff package for cross-lane replay rollout policy.
3. If Foundation wording conflicts with OxFml semantics, preserve OxFml semantics, call out the conflict explicitly in the edited docs or workset, and adapt the rollout text instead of copying it verbatim.
4. Do not edit `..\Foundation` or any sibling repo.
5. Do not weaken current OxFml semantics in order to fit a generic replay model.

## Use this Foundation source root
Assume repo root as current working directory.
Resolve all Foundation handoff files relative to:

```text
..\Foundation
```

Primary handoff run:

```text
..\Foundation\research\runs\20260315-215019-replay-appliance-authoritative-pass-01\outputs\
```

## Mandatory local reads before editing
1. `docs/spec/README.md`
2. `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
3. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
4. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
5. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
6. `docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`
7. `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
8. `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
9. `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
10. `docs/worksets/README.md`
11. `docs/worksets/W005_replay_and_formal_kickoff_for_core_surfaces.md`
12. `docs/worksets/W007_execution_profiles_and_concurrency_contract_baseline.md`
13. `docs/worksets/W008_single_formula_host_and_empirical_oracle_bootstrap.md`

## Mandatory Foundation reads
1. `01_authoritative_lane_inventory.md`
2. `02_replay_appliance_motivation_charter_requirements.md`
3. `03_replay_appliance_architecture.md`
4. `04_replay_appliance_performance_sensitive_design.md`
5. `05_dna_recalc_tool_proposal.md`
6. `07_oxfml_addendum.md`
7. `10_witness_distillation_and_counterexample_reduction.md`
8. `11_adapter_conformance_and_capability_matrix.md`
9. `12_predicate_mismatch_and_status_registry.md`
10. `13_witness_lifecycle_retention_and_quarantine_policy.md`
11. `source_list.csv`

## Required deliverables

### Create these new OxFml-local artifacts
Prefer these exact filenames unless a local collision or stronger existing naming rule forces a small adjustment.

1. `docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
2. `docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
3. `docs/worksets/W009_replay_appliance_adapter_and_witness_rollout.md`
4. `docs/worksets/W010_witness_distillation_and_retained_fixture_promotion.md`

### Update these canonical docs
1. `docs/spec/README.md`
2. `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
3. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
4. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
5. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
6. `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
7. `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
8. `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
9. `docs/worksets/README.md`

## What the new adapter doc must contain
In `docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`, define:
1. scope and non-goals,
2. authority split between OxFml semantics and Foundation replay governance,
3. bundle projection rules for the OxFml artifact ladder,
4. preserved identity categories and fence-related keys,
5. fixture-family import rules,
6. normalized event-family mapping for session, candidate, commit, reject, and effect boundaries,
7. adapter capability target and known limits,
8. registry version pins,
9. witness lifecycle and quarantine usage rules,
10. open alignment items carried from current OxFml gaps.

## What the updated canonical docs must incorporate

### `OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
Add explicit replay-preserved identity rules for:
1. stable ids,
2. version keys,
3. fingerprints,
4. runtime handles,
5. session and commit ids,
6. configuration and profile version context where relevant.

### `OXFML_CANONICAL_ARTIFACT_SHAPES.md`
Add:
1. projection from OxFml artifact families into Replay appliance bundle objects,
2. sidecar rules for large artifact bodies,
3. witness reduction-unit anchors for candidates, commit attempts, reject contexts, and effect slices.

### `OXFML_MINIMUM_SEAM_SCHEMAS.md`
Add only additive replay-facing fields and structures such as:
1. bundle envelope refs,
2. registry ids where needed,
3. capability manifest refs,
4. witness lifecycle refs,
5. explicit missing or opaque markers.

Do not redefine current seam semantics to fit those fields.

### `OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
Add:
1. mapping from local trace or reject families to normalized mismatch and predicate families,
2. severity alignment where applicable,
3. explicit statement that local taxonomy remains authoritative.

### `FEC_F3E_TESTING_AND_REPLAY.md`
Add:
1. `DNA ReCalc` ingest, normalize, validate, explain, and future distill workflow for OxFml fixture families,
2. adapter capability claim path,
3. witness lifecycle and quarantine rules,
4. pack-eligibility guardrails.

### `FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
Add witness-distillation planning for:
1. reduction units,
2. preservation predicates,
3. closure rules,
4. allowed subset and projection transforms,
5. explicit prohibition on formula, bind, fence, or capability-view rewrites unless OxFml later declares them replay-safe.

### `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
Add:
1. adapter conformance evidence expectations,
2. capability-level evidence targets,
3. witness-lifecycle and quarantine references where they affect assurance claims.

## Capability target for this pass
Be honest and conservative.

1. Target documented support through `cap.C0.ingest_valid`, `cap.C1.replay_valid`, `cap.C2.diff_valid`, and `cap.C3.explain_valid`.
2. Scaffold `cap.C4.distill_valid`, but do not claim it complete unless local evidence in this repo actually proves reduced-witness replay validity.
3. Do not claim `cap.C5.pack_valid` in this pass.

## Required capability manifest contents
`docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json` must include:
1. adapter id and version,
2. lane id `oxfml`,
3. supported source schema ids,
4. supported replay bundle schema versions,
5. claimed capability levels,
6. known limits,
7. conformance artifact refs,
8. registry version refs,
9. rollout notes.

If local repo policy strongly prefers `.md` over `.json`, use a machine-readable fenced block in Markdown and state why.

## Workset requirements

### `W009_replay_appliance_adapter_and_witness_rollout`
This workset should:
1. depend on `W005`, `W007`, and `W008`,
2. block `W010`,
3. cover spec incorporation, adapter-note creation, manifest scaffolding, registry pinning, and explain-surface binding,
4. explicitly exclude any claim that formula or bind rewrites are replay-safe,
5. define concrete exit gates for spec incorporation and capability-manifest completion.

### `W010_witness_distillation_and_retained_fixture_promotion`
This workset should:
1. depend on `W009`,
2. cover reduced witness planning for commit, reject, and effect fixtures,
3. define lifecycle, quarantine, and retained-fixture promotion policy for OxFml,
4. stay out of scope for full pack-grade promotion unless evidence already exists.

Update `docs/worksets/README.md` so the planned sequence reflects the new replay rollout worksets after `W008`.

## Mandatory constraints
1. Do not create a new OxFml-local scenario DSL.
2. Do not flatten typed OxFml artifacts into generic replay prose.
3. Do not authorize formula-text rewrites, bind rewrites, fence rewrites, or capability-view rewrites in this pass.
4. Do not claim that explanatory-only or quarantined witnesses are pack-eligible.
5. Do not silently replace OxFml taxonomy ids with Foundation text labels; map them explicitly.

## Validation before finishing
Before finalizing, verify all of the following:
1. every new normalized or lifecycle id comes from the Foundation registry handoff or is clearly marked as a local-only OxFml id,
2. the adapter manifest does not overclaim capability,
3. the updated docs preserve OxFml authority over artifact meaning and reject semantics,
4. worksets follow the local template and naming rules,
5. any conflict between local semantics and Foundation wording is called out explicitly.

## Final response requirements
In your final response:
1. list every file changed,
2. state the highest capability level honestly claimed after the edits,
3. call out any semantic or schema conflicts that remain open,
4. name the next concrete evidence step needed to move from OxFml replay support toward OxFml witness distillation.
