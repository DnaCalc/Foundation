# Prompt: OxCalc Replay Appliance Rollout

You are working inside the `OxCalc` repository.
Follow local `AGENTS.md` and local doctrine or spec-precedence rules first.

## Mission
Incorporate the Replay appliance handoff from `..\Foundation` into the canonical OxCalc core-engine and `TraceCalc` realization docs.

Preserve OxCalc ownership of:
1. coordinator semantics,
2. `TraceCalc` scenario and runner contracts,
3. reference-machine behavior,
4. Stage 1 replay classes and engine-diff meaning.

## Authority and conflict rules
1. OxCalc canonical docs remain authoritative for OxCalc semantics.
2. The Foundation replay research run from `2026-03-15` is the authoritative handoff package for cross-lane replay rollout policy.
3. If Foundation wording conflicts with OxCalc semantics, preserve OxCalc semantics, call out the conflict explicitly, and adapt the rollout wording instead of copying it verbatim.
4. Do not edit `..\Foundation` or any sibling repo.
5. Do not weaken `TraceCalc`, engine-diff, or publication semantics to fit a generic replay abstraction.

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
2. `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`
3. `docs/spec/core-engine/CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
4. `docs/spec/core-engine/CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
5. `docs/spec/core-engine/CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
6. `docs/spec/core-engine/CORE_ENGINE_FORMALIZATION_AND_ASSURANCE.md`
7. `docs/worksets/README.md`
8. `docs/worksets/W009_REPLAY_AND_PACK_BINDING_FOR_STAGE1_SEAM_AND_COORDINATOR_BEHAVIOR.md`
9. `docs/worksets/W011_CORE_ENGINE_TEST_HARNESS_AND_SELF_CONTAINED_FIXTURE_PLAN.md`
10. `docs/worksets/W012_TRACECALC_REFERENCE_MACHINE_AND_CONFORMANCE_ORACLE.md`
11. `docs/worksets/W014_EXECUTION_SEQUENCE_B_STAGE1_WIDENING_AND_EVIDENCE_HARDENING.md`

## Mandatory Foundation reads
1. `01_authoritative_lane_inventory.md`
2. `02_replay_appliance_motivation_charter_requirements.md`
3. `03_replay_appliance_architecture.md`
4. `04_replay_appliance_performance_sensitive_design.md`
5. `05_dna_recalc_tool_proposal.md`
6. `06_oxcalc_addendum.md`
7. `10_witness_distillation_and_counterexample_reduction.md`
8. `11_adapter_conformance_and_capability_matrix.md`
9. `12_predicate_mismatch_and_status_registry.md`
10. `13_witness_lifecycle_retention_and_quarantine_policy.md`
11. `source_list.csv`

## Required deliverables

### Create these new OxCalc-local artifacts
Prefer these exact filenames unless a local collision or stronger existing naming rule forces a small adjustment.

1. `docs/spec/core-engine/CORE_ENGINE_REPLAY_APPLIANCE_ADAPTER.md`
2. `docs/spec/core-engine/CORE_ENGINE_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
3. `docs/worksets/W015_REPLAY_APPLIANCE_ADAPTER_AND_BUNDLE_VALIDATOR_ROLLOUT.md`
4. `docs/worksets/W016_WITNESS_DISTILLATION_AND_RETAINED_FAILURE_PACKS.md`

### Update these canonical and supporting docs
1. `docs/spec/README.md`
2. `docs/spec/core-engine/CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
3. `docs/spec/core-engine/CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
4. `docs/spec/core-engine/CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
5. `docs/spec/core-engine/CORE_ENGINE_FORMALIZATION_AND_ASSURANCE.md`
6. `docs/worksets/README.md`

Update additional core-engine docs if needed, but keep the primary changes concentrated in the files above.

## What the new adapter doc must contain
In `docs/spec/core-engine/CORE_ENGINE_REPLAY_APPLIANCE_ADAPTER.md`, define:
1. scope and non-goals,
2. authority split between OxCalc semantics and Foundation replay governance,
3. `TraceCalc` scenario and artifact projection into the Replay appliance bundle,
4. normalized event-family mapping and known label drift resolution,
5. required preserved view surfaces,
6. engine-diff severity and mismatch mapping,
7. adapter capability target and known limits,
8. registry version pins,
9. witness lifecycle and quarantine usage rules,
10. open alignment items and follow-on evidence requirements.

## What the updated canonical docs must incorporate

### `CORE_ENGINE_TEST_SCENARIO_SCHEMA_AND_TRACECALC.md`
Add:
1. replay-class metadata projection,
2. pack tag and required-equality surface declarations,
3. normalized event-family mapping references,
4. witness reduction-unit anchors at scenario, phase block, event group, reject record, and view-slice levels.

Do not replace `TraceCalc` authoring with a new DSL.

### `CORE_ENGINE_TEST_VALIDATOR_AND_RUNNER_CONTRACT.md`
Add:
1. normalized bundle emission path,
2. capability manifest output expectations,
3. registry-id usage expectations,
4. witness lifecycle and quarantine behavior for replay and distill flows,
5. explicit handling for unsupported or degraded capture.

### `CORE_ENGINE_TRACECALC_REFERENCE_MACHINE.md`
Add:
1. acceptance-oracle role in witness distillation,
2. typed diff severity mapping,
3. retained-failure and reduced-witness artifact expectations,
4. explicit rule that reduced witnesses remain replay-valid or are marked explanatory-only.

### `CORE_ENGINE_FORMALIZATION_AND_ASSURANCE.md`
Add:
1. adapter capability evidence ladder,
2. `C0..C4` conformance targets,
3. lifecycle and quarantine effects on pack and assurance claims.

## Capability target for this pass
OxCalc is the first proving lane for this system.

1. Target documented support through `cap.C0.ingest_valid`, `cap.C1.replay_valid`, `cap.C2.diff_valid`, `cap.C3.explain_valid`, and `cap.C4.distill_valid`.
2. Do not claim `cap.C5.pack_valid` unless this repo already contains real pack-grade evidence for it.
3. If current local evidence cannot honestly support `cap.C4`, scaffold it explicitly and stop at the highest proven level.

## Required capability manifest contents
`docs/spec/core-engine/CORE_ENGINE_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json` must include:
1. adapter id and version,
2. lane id `oxcalc`,
3. supported source schema ids,
4. supported replay bundle schema versions,
5. claimed capability levels,
6. known limits,
7. conformance artifact refs,
8. registry version refs,
9. rollout notes.

If local repo policy strongly prefers `.md` over `.json`, use a machine-readable fenced block in Markdown and state why.

## Workset requirements

### `W015_REPLAY_APPLIANCE_ADAPTER_AND_BUNDLE_VALIDATOR_ROLLOUT`
This workset should:
1. depend on `W009`, `W011`, `W012`, and `W014`,
2. block `W016`,
3. cover spec incorporation, adapter-note creation, manifest scaffolding, registry pinning, event-family normalization, and bundle-validator expectations,
4. define concrete exit gates for bundle-valid adapter specification and capability-manifest completion.

### `W016_WITNESS_DISTILLATION_AND_RETAINED_FAILURE_PACKS`
This workset should:
1. depend on `W015`,
2. cover reduced witness planning for `TraceCalc`, `engine_diff`, and view mismatches,
3. define lifecycle, quarantine, retained-failure, and witness-pack binding rules,
4. explicitly stay out of scope for overclaiming pack-grade status unless evidence exists.

Update `docs/worksets/README.md` so the planned sequence reflects the new replay rollout worksets after `W014`.

## Mandatory constraints
1. Do not create a replacement for `TraceCalc`.
2. Do not collapse candidate-versus-publication states into a single success event.
3. Do not flatten engine diffs into prose-only narratives.
4. Do not claim explanatory-only or quarantined witnesses are pack-eligible.
5. Do not silently choose between label-drift variants; normalize them explicitly and document the mapping.

## Required OxCalc-specific integration points
Make sure the edited docs explicitly address:
1. replay classes `R1..R8`,
2. candidate label drift such as `candidate_recorded` versus `candidate_emitted`,
3. publication label drift such as `candidate_published` versus `publication_committed`,
4. view surfaces `published_view`, `pinned_view`, reject sets, and assertions,
5. diff severity split across semantic, instrumentation, and informational classes,
6. witness reduction units and closure rules grounded in scenario and event-group structure.

## Validation before finishing
Before finalizing, verify all of the following:
1. every new normalized or lifecycle id comes from the Foundation registry handoff or is clearly marked as a local-only OxCalc id,
2. the adapter manifest does not overclaim capability,
3. the updated docs preserve OxCalc authority over `TraceCalc`, engine-diff, and reference-machine meaning,
4. worksets follow the local template and naming rules,
5. any conflict between local semantics and Foundation wording is called out explicitly.

## Final response requirements
In your final response:
1. list every file changed,
2. state the highest capability level honestly claimed after the edits,
3. call out any semantic or schema conflicts that remain open,
4. name the next concrete evidence step needed to move from OxCalc replay support toward retained reduced witnesses and eventual pack-grade adoption.
