# Prompt: OxFunc Replay Appliance Rollout

You are working inside the `OxFunc` repository.
Follow local `AGENTS.md` and local doctrine or spec-precedence rules first.

## Mission
Incorporate the Replay appliance handoff from `..\Foundation` into the OxFunc function-lane working set.

Preserve OxFunc ownership of:
1. function and operator semantic targets,
2. manifest-driven empirical replay shape,
3. evidence-id and correlation-ledger discipline,
4. boundary-invariant statements,
5. XLL and host-limitation distinctions.

## Authority and conflict rules
1. OxFunc canonical docs remain authoritative for OxFunc semantics and evidence meaning.
2. The Foundation replay research run from `2026-03-15` is the authoritative handoff package for cross-lane replay rollout policy.
3. If Foundation wording conflicts with OxFunc semantic or evidence discipline, preserve OxFunc meaning, call out the conflict explicitly, and adapt the rollout wording instead of copying it verbatim.
4. Do not edit `..\Foundation` or any sibling repo.
5. Do not force OxFunc into a fake event-stream shape if packet or row structure is the honest witness.

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
1. `docs/function-lane/README.md`
2. `docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
3. `docs/function-lane/FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md`
4. `docs/function-lane/DOCTRINE_DECISION_FULL_EMPIRICAL_FUNCTION_IDENTITY_20260309.md`
5. `docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
6. `docs/function-lane/CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md`
7. `docs/function-lane/W15_PROBE_RUNTIME_REQUIREMENTS.md`
8. `docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md`
9. `docs/worksets/README.md`
10. `docs/worksets/W015_CELL_AND_INFO_HOST_QUERY_FUNCTIONS.md`
11. `docs/worksets/W016_BULK_NON_INTERESTING_FUNCTIONS_AND_OPERATORS.md`

## Mandatory Foundation reads
1. `01_authoritative_lane_inventory.md`
2. `02_replay_appliance_motivation_charter_requirements.md`
3. `03_replay_appliance_architecture.md`
4. `04_replay_appliance_performance_sensitive_design.md`
5. `05_dna_recalc_tool_proposal.md`
6. `08_oxfunc_addendum.md`
7. `10_witness_distillation_and_counterexample_reduction.md`
8. `11_adapter_conformance_and_capability_matrix.md`
9. `12_predicate_mismatch_and_status_registry.md`
10. `13_witness_lifecycle_retention_and_quarantine_policy.md`
11. `source_list.csv`

## Required deliverables

### Create these new OxFunc-local artifacts
Prefer these exact filenames unless a local collision or stronger existing naming rule forces a small adjustment.

1. `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`
2. `docs/function-lane/OXFUNC_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
3. `docs/worksets/W017_REPLAY_APPLIANCE_PACKET_ADAPTER_BASELINE.md`
4. `docs/worksets/W018_PACKET_WITNESS_DISTILLATION_AND_RETENTION_BASELINE.md`

### Update these canonical docs
1. `docs/function-lane/README.md`
2. `docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
3. `docs/function-lane/FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md`
4. `docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
5. `docs/function-lane/CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md`
6. `docs/function-lane/W15_PROBE_RUNTIME_REQUIREMENTS.md`
7. `docs/worksets/README.md`

## What the new adapter doc must contain
In `docs/function-lane/OXFUNC_REPLAY_APPLIANCE_PACKET_ADAPTER_V1.md`, define:
1. scope and non-goals,
2. authority split between OxFunc semantic evidence and Foundation replay governance,
3. packet-first and row-first replay model,
4. preserved evidence, correlation, compatibility, locale, and environment metadata,
5. normalized views and event families that do not distort packet semantics,
6. boundary-invariant incorporation,
7. adapter capability target and known limits,
8. registry version pins,
9. witness lifecycle and quarantine usage rules,
10. open gaps and evidence requirements.

## What the updated canonical docs must incorporate

### `FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
Add:
1. replay-bundle and witness references,
2. lifecycle and supersession considerations for reduced witnesses,
3. registry-id usage where shared vocabulary is needed.

### `FUNCTION_ADAPTER_LAYERING_PRELIM_SPEC.md`
Add:
1. packet-adapter role in the Replay appliance,
2. allowed reduction-unit hierarchy,
3. prohibition on inventing fake internal event streams.

### `FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
Add:
1. replay-bundle and evidence-correlation binding,
2. capability-level evidence path,
3. witness-lifecycle effect on formal and empirical claims.

### `CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md`
Add:
1. replay and witness-distillation binding fields,
2. predicate references for invariant failures,
3. retention or quarantine expectations for invariant-based witnesses.

### `W15_PROBE_RUNTIME_REQUIREMENTS.md`
Add or reference:
1. packet replay import path into `DNA ReCalc`,
2. normalized output expectations,
3. explain and future distill eligibility notes.

## Capability target for this pass
Be honest and conservative.

1. Target documented support through `cap.C0.ingest_valid`, `cap.C1.replay_valid`, `cap.C2.diff_valid`, and `cap.C3.explain_valid`.
2. Scaffold `cap.C4.distill_valid` in packet-first form, but do not claim it complete unless local evidence proves reduced packet or row witnesses replay-valid.
3. Do not claim `cap.C5.pack_valid` in this pass.

## Required capability manifest contents
`docs/function-lane/OXFUNC_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json` must include:
1. adapter id and version,
2. lane id `oxfunc`,
3. supported source schema ids,
4. supported replay bundle schema versions,
5. claimed capability levels,
6. known limits,
7. conformance artifact refs,
8. registry version refs,
9. rollout notes.

If local repo policy strongly prefers `.md` over `.json`, use a machine-readable fenced block in Markdown and state why.

## Workset requirements

### `W017_REPLAY_APPLIANCE_PACKET_ADAPTER_BASELINE`
This workset should:
1. depend on `W015` and `W016`,
2. block `W018`,
3. cover spec incorporation, adapter-note creation, manifest scaffolding, registry pinning, packet-view mapping, and explain-surface binding,
4. explicitly exclude fake event-stream semantics and overclaiming distillation.

### `W018_PACKET_WITNESS_DISTILLATION_AND_RETENTION_BASELINE`
This workset should:
1. depend on `W017`,
2. cover row-level and packet-level witness reduction planning,
3. define lifecycle, quarantine, limitation-aware retention, and evidence supersession policy,
4. stay out of scope for pack-grade promotion unless evidence exists.

Update `docs/worksets/README.md` so the planned sequence reflects the new replay rollout worksets after `W016`.

## Mandatory constraints
1. Do not create a fake OxFunc event stream for the sake of cross-lane symmetry.
2. Do not conflate XLL seam limitations with core semantic failures.
3. Do not overclaim reduced-witness pack eligibility.
4. Do not erase evidence-id or correlation-ledger discipline.
5. Do not claim `cap.C4` unless packet-first reduced witnesses are actually proven.

## Validation before finishing
Before finalizing, verify all of the following:
1. every new normalized or lifecycle id comes from the Foundation registry handoff or is clearly marked as a local-only OxFunc id,
2. the adapter manifest does not overclaim capability,
3. the updated docs preserve OxFunc authority over semantic claims, evidence ids, and invariants,
4. worksets follow the local template and naming rules,
5. any conflict between local semantics and Foundation wording is called out explicitly.

## Final response requirements
In your final response:
1. list every file changed,
2. state the highest capability level honestly claimed after the edits,
3. call out any semantic or evidence conflicts that remain open,
4. name the next concrete evidence step needed to move from OxFunc replay support toward packet-first witness distillation.
