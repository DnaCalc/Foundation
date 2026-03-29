# Adapter Conformance And Capability Matrix

## 1. Position
The lane addenda should not roll out against prose alone.
Each lane adapter should make explicit, machine-readable capability claims that are backed by conformance artifacts.

This document defines:
1. the adapter capability levels,
2. the capability manifest shape,
3. the conformance evidence needed to claim each level,
4. the initial rollout targets for each `Ox*` lane.

## 2. Why this is needed
Without a shared capability contract:
1. lane addenda will be adopted unevenly,
2. adapter maturity will be argued in prose instead of artifacts,
3. pack promotion will not know which adapter claims can be trusted,
4. cross-lane tooling will have no stable basis for feature gating.

## 3. Capability levels
Capability levels are cumulative.

### 3.1 `C0.ingest_valid`
The adapter can:
1. ingest lane-native artifacts,
2. emit a bundle-valid normalized output,
3. declare projection gaps explicitly.

### 3.2 `C1.replay_valid`
The adapter can:
1. produce replay-valid bundles,
2. replay supported scenarios deterministically,
3. emit invalid or unsupported states explicitly.

### 3.3 `C2.diff_valid`
The adapter can:
1. compare replay-valid bundles,
2. emit typed mismatch classes,
3. separate semantic mismatches from instrumentation or informational mismatches.

### 3.4 `C3.explain_valid`
The adapter can:
1. answer required explain queries for its supported surfaces,
2. cite supporting refs,
3. expose known explain gaps explicitly.

### 3.5 `C4.distill_valid`
The adapter can:
1. declare reduction units and closure rules,
2. evaluate typed preservation predicates,
3. emit reduced witness bundles and reduction manifests,
4. surface irreducibility or instability explicitly.

### 3.6 `C5.pack_valid`
The adapter can:
1. satisfy declared pack bindings,
2. emit pack-eligible witnesses,
3. participate in retention and promotion policy without manual interpretation.

## 4. Required manifest
Each lane adapter should publish one `ReplayAdapterCapabilityManifest`.

### 4.1 Required fields
1. `adapter_id`
2. `lane_id`
3. `adapter_version`
4. `supported_source_schema_ids`
5. `supported_bundle_schema_versions`
6. `claimed_capability_levels`
7. `known_limits`
8. `conformance_artifact_refs`
9. `registry_version_refs`
10. `rollout_notes`

### 4.2 Claim rules
1. claims are additive and explicit,
2. every claimed level must have at least one proving artifact,
3. known limits must name the unsupported surface or downgraded behavior,
4. temporary or experimental claims must be marked as such.

## 5. Conformance evidence per level
Each capability level requires specific evidence.

### 5.1 `C0.ingest_valid`
Required evidence:
1. one golden source-run fixture,
2. one normalized bundle validation pass,
3. one negative test showing projection-gap surfacing.

### 5.2 `C1.replay_valid`
Required evidence:
1. deterministic replay rerun,
2. supported versus unsupported classification test,
3. runner error-state classification test.

### 5.3 `C2.diff_valid`
Required evidence:
1. mismatch-kind classification tests,
2. semantic versus instrumentation mismatch split,
3. required-surface versus optional-surface comparison test.

### 5.4 `C3.explain_valid`
Required evidence:
1. `why_changed` or lane-equivalent explain test,
2. source-ref citation test,
3. known-gap surfacing test.

### 5.5 `C4.distill_valid`
Required evidence:
1. one successful reduced witness,
2. one explicit irreducibility case,
3. one explicit unsupported or unstable-oracle case,
4. proof that reduced witnesses remain replay-valid.

### 5.6 `C5.pack_valid`
Required evidence:
1. one pack export success path,
2. one witness lifecycle promotion path,
3. one policy-blocked path such as explanatory-only or quarantined witness rejection.

## 6. Initial rollout targets by lane
These are the recommended first claimed targets.

### 6.1 `OxCalc`
Target:
1. reach `C4.distill_valid` first,
2. use `TraceCalc`, `engine_diff`, and view mismatch surfaces as the proving path,
3. be the first lane to prove `C5.pack_valid` for `PACK.replay.appliance`.

### 6.2 `OxFml`
Target:
1. reach `C3.explain_valid` quickly through fixture import and typed reject explanation,
2. then reach `C4.distill_valid` for lifecycle, reject, and effect witnesses.

### 6.3 `OxFunc`
Target:
1. reach `C3.explain_valid` through packet and row explanation,
2. then reach `C4.distill_valid` in packet-first form rather than event-stream form.

### 6.4 `OxVba`
Target:
1. reach `C3.explain_valid` over clause, gate, and host-projection surfaces,
2. then reach selective `C4.distill_valid` for conformance-case, clause, and gate failures.

## 7. Rollout gate
Before a lane addendum is considered rolled out:
1. its adapter manifest must exist,
2. claimed capability levels must be backed by conformance artifacts,
3. known limits must be recorded,
4. registry versions must be pinned,
5. witness lifecycle policy support must be declared if `C4` or higher is claimed.

## 8. Change classes
Capability manifests and supporting contracts should classify changes as:
1. `additive`,
2. `tightening`,
3. `breaking`,
4. `experimental`,
5. `deprecated`,
6. `removed`.

Rules:
1. additive and tightening changes may preserve capability level if evidence still holds,
2. breaking changes require revalidation,
3. experimental claims may not be treated as pack-grade by default,
4. deprecated claims must name the successor path if one exists.

## 9. Resulting rule
No lane should claim more Replay appliance maturity than it can prove.
The adapter capability manifest is the contract that keeps rollout honest.
