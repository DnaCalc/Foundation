# Witness Lifecycle, Retention, And Quarantine Policy

## 1. Position
Reduced witnesses should not appear in the system as anonymous files.
They need explicit lifecycle state, promotion rules, quarantine rules, and retention policy.

This document defines the operational state machine for witnesses produced by the Replay appliance.

## 2. Why this is needed
Without lifecycle policy:
1. explanatory-only witnesses will be confused with pack-grade evidence,
2. unstable-oracle outputs will leak into retained corpora,
3. superseded witnesses will accumulate without clear status,
4. GC will be unsafe because witness importance is implicit.

## 3. Required lifecycle record
Each retained witness should carry a `ReplayWitnessLifecycleRecord`.

Required fields:
1. `witness_id`
2. `source_bundle_ref`
3. `reduction_manifest_ref`
4. `lifecycle_state`
5. `retention_policy_id`
6. `promotion_refs`
7. `supersedes`
8. `quarantine_reason`
9. `gc_eligibility`
10. `notes`

## 4. Lifecycle states
The initial lifecycle states are:
1. `wit.generated_local`
2. `wit.explanatory_only`
3. `wit.retained_local`
4. `wit.retained_shared`
5. `wit.pack_candidate`
6. `wit.pack_promoted`
7. `wit.superseded`
8. `wit.quarantined`
9. `wit.gc_eligible`
10. `wit.archived`

## 5. State transition rules
Allowed transitions:
1. `wit.generated_local` -> `wit.explanatory_only`
2. `wit.generated_local` -> `wit.retained_local`
3. `wit.explanatory_only` -> `wit.retained_local` after replay-valid upgrade
4. `wit.retained_local` -> `wit.retained_shared`
5. `wit.retained_shared` -> `wit.pack_candidate`
6. `wit.pack_candidate` -> `wit.pack_promoted`
7. any retained state -> `wit.superseded`
8. any non-archived state -> `wit.quarantined`
9. `wit.superseded` -> `wit.gc_eligible`
10. `wit.gc_eligible` -> `wit.archived`

Disallowed rules:
1. `wit.explanatory_only` may not go directly to `wit.pack_promoted`,
2. `wit.quarantined` may not go to a pack-eligible state until the quarantine condition is cleared,
3. `wit.gc_eligible` may not return to active use without explicit restoration policy.

## 6. Pack eligibility rules
Pack-eligible states are:
1. `wit.pack_candidate`
2. `wit.pack_promoted`

Minimum conditions for pack eligibility:
1. witness is replay-valid,
2. witness is not quarantined,
3. required adapter capability levels are satisfied,
4. required registry versions are resolved,
5. retention policy allows promotion.

Non-pack-eligible states:
1. `wit.explanatory_only`
2. `wit.quarantined`
3. `wit.gc_eligible`
4. `wit.archived`

## 7. Quarantine policy
Quarantine exists to prevent false confidence.

### 7.1 Quarantine reasons
Initial `quarantine_reason` families:
1. `oracle_unstable`
2. `capture_insufficient`
3. `source_artifact_missing`
4. `schema_incompatible`
5. `adapter_bug_suspected`
6. `replay_invalid`
7. `policy_blocked`

### 7.2 Quarantine rules
1. a quarantined witness remains indexable,
2. a quarantined witness is visible to triage,
3. a quarantined witness is not pack-eligible,
4. quarantine exit requires an explicit lifecycle transition and cleared reason.

## 8. Supersession policy
Supersession means a better witness replaced an older one.

Supersession should be used when:
1. a smaller witness preserves the same predicate,
2. a richer witness closes a prior explanatory-only gap,
3. a schema migration produces an equivalent or better witness,
4. a quarantined witness is replaced by a stable witness.

Rule:
1. superseded witnesses remain traceable,
2. supersession must name the successor witness id where one exists.

## 9. Retention and GC policy
Retention should depend on lifecycle state and policy id.

Baseline rules:
1. local generated witnesses may be discarded unless promoted,
2. retained and promoted witnesses should remain indexable and traceable,
3. superseded or quarantined witnesses may become `wit.gc_eligible` under policy,
4. archived witnesses remain historical and non-active.

GC safety rule:
1. no GC action may break provenance from a promoted witness to its source bundle and reduction manifest.

## 10. Operational surfaces
The Replay appliance should index:
1. witness id,
2. lifecycle state,
3. source bundle id,
4. predicate kind,
5. pack tags,
6. quarantine reason,
7. supersession target,
8. retention policy id.

## 11. Resulting rule
A witness is not just a reduced bundle.
It is a governed evidence asset with an explicit lifecycle, and rollout should treat it that way.
