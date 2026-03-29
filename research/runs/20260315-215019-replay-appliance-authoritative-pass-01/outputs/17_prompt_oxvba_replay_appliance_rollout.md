# Prompt: OxVba Replay Appliance Rollout

You are working inside the `OxVba` repository.
Follow local `AGENTS.md` and local doctrine or spec-precedence rules first.

## Mission
Incorporate the Replay appliance handoff from `..\Foundation` into the OxVba conformance, runner-policy, and host-projection spec set.

Preserve OxVba ownership of:
1. clause-first traceability,
2. deterministic host and policy behavior,
3. profile and runtime-class semantics,
4. deferred-oracle governance,
5. replay-safe host projection rules.

## Authority and conflict rules
1. Respect local precedence in this repo: `CHARTER.md`, then `OPERATIONS.md`, then `MACH1000_PLAN.md`, then current canonical spec docs.
2. The Foundation replay research run from `2026-03-15` is the authoritative handoff package for cross-lane replay rollout policy.
3. If Foundation wording conflicts with OxVba semantics or governance, preserve OxVba meaning, call out the conflict explicitly, and adapt the rollout wording instead of copying it verbatim.
4. Do not edit `..\Foundation` or any sibling repo.
5. Do not depend on raw host handles or nondeterministic host state for replay identity.

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
1. `CHARTER.md`
2. `OPERATIONS.md`
3. `MACH1000_PLAN.md`
4. `docs/spec/README.md`
5. `docs/spec/HOST_RUNNER_POLICY_BOOTSTRAP_V1.md`
6. `docs/spec/HAL_CONFORMANCE_SUITE.md`
7. `docs/spec/HAL_FORMALIZATION_PROGRAM.md`
8. `docs/CONFORMANCE.md`
9. `docs/LOCAL_EXECUTION_DOCTRINE.md`
10. `README.md`

## Mandatory Foundation reads
1. `01_authoritative_lane_inventory.md`
2. `02_replay_appliance_motivation_charter_requirements.md`
3. `03_replay_appliance_architecture.md`
4. `04_replay_appliance_performance_sensitive_design.md`
5. `05_dna_recalc_tool_proposal.md`
6. `09_oxvba_addendum.md`
7. `10_witness_distillation_and_counterexample_reduction.md`
8. `11_adapter_conformance_and_capability_matrix.md`
9. `12_predicate_mismatch_and_status_registry.md`
10. `13_witness_lifecycle_retention_and_quarantine_policy.md`
11. `source_list.csv`

## Required deliverables

### Create these new OxVba-local artifacts
Prefer these exact filenames unless a local collision or stronger existing naming rule forces a small adjustment.

1. `docs/spec/OXVBA_REPLAY_APPLIANCE_ADAPTER_V1.md`
2. `docs/spec/OXVBA_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
3. `docs/worksets/WORKSET_2026-03-15_REPLAY_APPLIANCE_ADAPTER_BASELINE.md`
4. `docs/worksets/WORKSET_2026-03-15_WITNESS_LIFECYCLE_AND_QUARANTINE_BASELINE.md`

### Update these canonical docs
1. `docs/spec/README.md`
2. `docs/spec/HOST_RUNNER_POLICY_BOOTSTRAP_V1.md`
3. `docs/spec/HAL_CONFORMANCE_SUITE.md`
4. `docs/spec/HAL_FORMALIZATION_PROGRAM.md`
5. `docs/CONFORMANCE.md`
6. `docs/LOCAL_EXECUTION_DOCTRINE.md`
7. `README.md`

## What the new adapter doc must contain
In `docs/spec/OXVBA_REPLAY_APPLIANCE_ADAPTER_V1.md`, define:
1. scope and non-goals,
2. authority split between OxVba semantics and Foundation replay governance,
3. configuration fingerprint as part of replay identity,
4. conformance-case, clause, gate, and host-projection bundle mapping,
5. replay-safe host projection rules,
6. adapter capability target and known limits,
7. registry version pins,
8. witness lifecycle and quarantine usage rules,
9. open gaps and deferred-oracle implications.

## What the updated canonical docs must incorporate

### `HOST_RUNNER_POLICY_BOOTSTRAP_V1.md`
Add:
1. replay-bundle identity bindings for profile, runtime class, policy preset, overrides, and persistence mode,
2. capability manifest expectations,
3. lifecycle and quarantine references where unstable or incomplete runs must be blocked from promotion.

### `HAL_CONFORMANCE_SUITE.md`
Add:
1. `DNA ReCalc` ingest and normalize path for OxVba conformance outputs,
2. normalized view family bindings,
3. mismatch and predicate registry usage,
4. retained-witness and reduced-case expectations for clause or gate failures.

### `HAL_FORMALIZATION_PROGRAM.md`
Add:
1. capability-level evidence ladder,
2. relationship between formal lanes and replay or witness lifecycle status,
3. quarantine handling for unstable or deferred-oracle cases.

### `docs/CONFORMANCE.md`
Add:
1. replay-bundle and witness lifecycle terminology,
2. explicit distinction between pack-eligible, explanatory-only, and quarantined witnesses,
3. references to the new adapter spec and capability manifest.

### `docs/LOCAL_EXECUTION_DOCTRINE.md`
Add:
1. local execution rules for replay-safe artifact generation,
2. no-artifact versus tracked-artifact lifecycle implications,
3. quarantine behavior for insufficient local evidence.

## Capability target for this pass
Be honest and conservative.

1. Target documented support through `cap.C0.ingest_valid`, `cap.C1.replay_valid`, `cap.C2.diff_valid`, and `cap.C3.explain_valid`.
2. Scaffold selective `cap.C4.distill_valid` for case, clause, and gate failures, but do not claim it complete unless local evidence proves reduced witness validity.
3. Do not claim `cap.C5.pack_valid` in this pass.

## Required capability manifest contents
`docs/spec/OXVBA_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json` must include:
1. adapter id and version,
2. lane id `oxvba`,
3. supported source schema ids,
4. supported replay bundle schema versions,
5. claimed capability levels,
6. known limits,
7. conformance artifact refs,
8. registry version refs,
9. rollout notes.

If local repo policy strongly prefers `.md` over `.json`, use a machine-readable fenced block in Markdown and state why.

## Workset requirements

### `WORKSET_2026-03-15_REPLAY_APPLIANCE_ADAPTER_BASELINE`
This workset should:
1. cover spec incorporation, adapter-note creation, manifest scaffolding, registry pinning, and conformance-surface mapping,
2. define concrete entry and exit gates,
3. explicitly preserve clause-first and profile-first semantics,
4. stay out of scope for overclaiming distillation or pack-grade status.

### `WORKSET_2026-03-15_WITNESS_LIFECYCLE_AND_QUARANTINE_BASELINE`
This workset should:
1. depend on the adapter baseline workset,
2. cover lifecycle, quarantine, supersession, and retained reduced-case policy,
3. define explicit quarantine reasons for oracle instability, insufficient capture, and schema incompatibility,
4. stay out of scope for claiming pack-grade witnesses unless evidence exists.

If the repo has no canonical workset index file, do not invent one unless local style requires it.

## Mandatory constraints
1. Do not depend on raw COM pointers or opaque host handles as replay identity.
2. Do not weaken clause-first traceability to fit generic replay prose.
3. Do not claim explanatory-only or quarantined witnesses are pack-eligible.
4. Do not claim selective `cap.C4` unless replay-safe reduced cases are actually proven.
5. Do not silently downgrade deferred-oracle items into normal retained evidence.

## Validation before finishing
Before finalizing, verify all of the following:
1. every new normalized or lifecycle id comes from the Foundation registry handoff or is clearly marked as a local-only OxVba id,
2. the adapter manifest does not overclaim capability,
3. the updated docs preserve OxVba authority over host semantics, clause semantics, and deferred-oracle governance,
4. workset names and content fit existing local style,
5. any conflict between local semantics and Foundation wording is called out explicitly.

## Final response requirements
In your final response:
1. list every file changed,
2. state the highest capability level honestly claimed after the edits,
3. call out any semantic, host, or oracle-governance conflicts that remain open,
4. name the next concrete evidence step needed to move from OxVba replay support toward selective reduced-witness support.
