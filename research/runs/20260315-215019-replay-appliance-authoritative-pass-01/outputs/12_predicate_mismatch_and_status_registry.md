# Predicate, Mismatch, And Status Registry

## 1. Position
The Replay appliance needs one canonical vocabulary for cross-lane coordination.

This document defines the initial registry families for:
1. preservation predicates,
2. diff mismatch kinds,
3. severity classes,
4. reduction outcomes,
5. witness lifecycle states,
6. adapter capability levels.

Lane repos still own local semantics.
The registries exist to standardize shared tooling and policy, not to replace local meaning.

## 2. Why this is needed
Without registries:
1. each lane will invent its own status strings,
2. diff and distill outputs will drift immediately,
3. pack policy will become string-matching prose,
4. dashboards and indexes will lose comparability.

## 3. Registry entry shape
Each registry entry should declare:
1. `registry_family`
2. `registry_version`
3. `entry_id`
4. `entry_status`
5. `summary`
6. `semantic_meaning`
7. `allowed_scopes`
8. `allowed_source_lanes`
9. `introduced_in`
10. `deprecated_in`
11. `supersedes`
12. `notes`

## 4. Predicate-kind registry
Initial `predicate_kind` entries:
1. `pred.diff.mismatch_present`
2. `pred.reject.family_present`
3. `pred.publication.not_published_reason`
4. `pred.invariant.failed`
5. `pred.clause.failure_present`
6. `pred.oracle.disagreement_present`
7. `pred.deferred_oracle.state_present`
8. `pred.result.unsupported_present`
9. `pred.evidence.claim_failed`

Rule:
1. the registry names the shared class,
2. lane-specific payload details remain lane-owned and are carried through refs and supporting fields.

## 5. Mismatch-kind registry
Initial `mismatch_kind` entries:
1. `mm.run.presence`
2. `mm.scenario.presence`
3. `mm.result.state`
4. `mm.view.value`
5. `mm.reject.kind`
6. `mm.trace.event`
7. `mm.counter.value`
8. `mm.clause.coverage`
9. `mm.evidence.binding`
10. `mm.sidecar.payload`

Rule:
1. these are the normalized mismatch families,
2. more detailed lane-specific mismatch codes may exist, but should map to one normalized family.

## 6. Severity registry
Initial `severity_class` entries:
1. `sev.semantic`
2. `sev.coverage`
3. `sev.instrumentation`
4. `sev.informational`

Meaning:
1. `sev.semantic` changes result truth or required replay truth,
2. `sev.coverage` changes claimed evidence or clause coverage,
3. `sev.instrumentation` changes supporting capture surface without changing semantic truth,
4. `sev.informational` changes optional reporting only.

## 7. Reduction-outcome registry
Initial `reduction_status` entries:
1. `red.preserved`
2. `red.not_preserved`
3. `red.invalid_candidate`
4. `red.unsupported_candidate`
5. `red.evaluation_failed`
6. `red.oracle_unstable`
7. `red.irreducible`

Rule:
1. reduction runs should use these ids rather than ad hoc phrases,
2. `red.oracle_unstable` is a policy-significant outcome and should feed quarantine.

## 8. Witness-lifecycle registry
Initial `witness_lifecycle_state` entries:
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

Rule:
1. these states describe rollout and retention status, not semantic truth,
2. `wit.explanatory_only` and `wit.quarantined` are not pack-eligible.

## 9. Capability-level registry
Initial `capability_level` entries:
1. `cap.C0.ingest_valid`
2. `cap.C1.replay_valid`
3. `cap.C2.diff_valid`
4. `cap.C3.explain_valid`
5. `cap.C4.distill_valid`
6. `cap.C5.pack_valid`

## 10. Governance rules
1. Foundation/Logistics owns the canonical registries.
2. Lane repos may propose additions but may not silently redefine existing entries.
3. New entries should be additive wherever possible.
4. Deprecated entries should remain resolvable until a declared removal point.
5. Experimental entries should carry explicit status and should not be assumed pack-grade.

## 11. Tooling rules
1. `DNA ReCalc` should emit registry ids in canonical outputs.
2. Human-readable labels may accompany ids, but may not replace them.
3. Unknown or future ids must be surfaced explicitly, not coerced to a default.
4. Registry snapshots used by a bundle should be version-pinned and indexable.

## 12. Resulting rule
The Replay appliance should speak one shared coordination vocabulary even while every lane keeps its own semantic language.
