# OxVba Addendum For The Replay Appliance

## 1. Purpose
This addendum defines how `OxVba` should incorporate the Replay appliance while preserving its current doctrine:
1. clause-first traceability,
2. deterministic host and policy behavior,
3. profile- and runtime-class-aware conformance,
4. explicit deferred-oracle handling,
5. clean-room evidence discipline.

## 2. Current authoritative anchors
Primary anchors:
1. `CHARTER.md`
2. `OPERATIONS.md`
3. `MACH1000_PLAN.md`
4. `docs/CONFORMANCE.md`
5. `docs/LOCAL_EXECUTION_DOCTRINE.md`
6. `docs/BYTECODE_FORMAT.md`
7. `docs/spec/HAL_RUNTIME_PROFILE_MATRIX_V1.md`
8. `docs/spec/HAL_POLICY_PRESETS.md`
9. `docs/spec/HAL_CONFORMANCE_SUITE.md`
10. `docs/spec/PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md`
11. `docs/spec/COM_EARLY_BINDING_TYPELIB_CONFORMANCE_V1.md`
12. clause catalogs and conformance evidence under `docs/spec/*.csv` and `docs/evidence/*`

## 3. OxVba-specific replay rule
For `OxVba`, replay truth is not just runtime event order.
It is the combination of:
1. profile and runtime class,
2. policy preset and overrides,
3. deterministic unsupported-mode behavior,
4. clause coverage,
5. conformance-case results,
6. replay-safe host projections,
7. deferred-oracle status.

The Replay appliance must therefore preserve configuration and governance metadata as first-class replay inputs.

## 4. Mandatory preserved configuration fingerprint
Every OxVba replay bundle must preserve:
1. `profile`
2. `runtime_class`
3. `policy_preset`
4. explicit policy overrides
5. `deterministic_mode`
6. `unsupported_feature_mode`
7. host-backed flags where applicable
8. run mode such as tracked-artifact versus `-NoArtifacts`

This is not optional metadata. It is part of replay identity.

## 5. Required source-run families
The Replay appliance should support at least these OxVba source-run families:
1. HAL conformance suite runs,
2. profile-gate runs,
3. PMR conformance runs,
4. PMR oracle runs,
5. project integration suite runs,
6. COM late-bound conformance runs,
7. COM early-binding conformance runs,
8. formal lane runs where replay-safe output exists.

## 6. Required normalized views
The OxVba adapter should emit these normalized view families.

### 6.1 `conformance_case_result_view`
Per-test or per-lane result state with artifact refs.

### 6.2 `clause_coverage_view`
Coverage totals plus clause ids, statuses, failures, and notices.

### 6.3 `profile_gate_view`
Profile id, required matrix cells, gate result, and linked evidence files.

### 6.4 `deferred_oracle_view`
Deferred-oracle items, foldback requirement, close condition, and linked scaffolds.

### 6.5 `host_projection_view`
Replay-safe projections of host-facing state or result, never raw host handles.

## 7. Replay-safe host projection rule
The Replay appliance must not depend on:
1. raw COM interface pointers,
2. opaque host object handles,
3. transient process-local identity values.

Instead, OxVba adapter output should preserve replay-safe host facts such as:
1. ProgID,
2. interface or member selector,
3. HRESULT or translated error family,
4. policy denial class,
5. runtime-class and profile context,
6. deterministic result projection.

This respects OxVba's existing one-boundary host model without inventing a second hidden semantic model.

## 8. Clause-first traceability incorporation
The Replay appliance should preserve clause ids and verification mappings as first-class bundle data.

Required preserved fields:
1. clause id list,
2. evidence path,
3. verification lane id,
4. profile scope,
5. source-anchor or Foundation conformance ref where present,
6. status and maturity class.

This is essential because OxVba claims are often clause- and ladder-driven rather than scenario-only.

## 9. Event model for OxVba
The normalized event model should focus on replay-safe boundary events:
1. runner configured,
2. profile selected,
3. policy resolved,
4. conformance lane started,
5. conformance case evaluated,
6. host boundary invoked,
7. deterministic unsupported or denied result surfaced,
8. clause coverage emitted,
9. oracle deferred or closed,
10. profile gate reported.

Detailed host logs and lane CSVs should remain sidecar artifacts referenced from the bundle.

## 10. No-artifact and tracked-artifact coexistence
The OxVba adapter must preserve the distinction between:
1. tracked evidence runs that update `LATEST`-style artifacts,
2. `-NoArtifacts` validation runs that deliberately avoid tracked mutation.

Bundle metadata should declare:
1. `artifact_persistence_mode`
2. `tracked_output_root`
3. `temporary_output_root`
4. whether the bundle is eligible for retention or only local debugging.

## 11. Witness distillation design for OxVba
OxVba witness distillation must remain clause-aware, profile-aware, and host-safe.

### 11.1 Reduction units
The OxVba adapter should declare this hierarchy:
1. conformance lane or case selection,
2. clause slice,
3. profile or policy axis,
4. replay-safe host-projection field group,
5. deferred-oracle item,
6. sidecar artifact set.

### 11.2 Preservation predicates
Initial OxVba predicate families should include:
1. same clause failure set or maturity outcome,
2. same deterministic unsupported or denied result class,
3. same profile-gate failure,
4. same host-projection mismatch class,
5. same deferred-oracle status.

### 11.3 Closure rules
At minimum, the adapter must enforce:
1. retaining a case also retains the profile, runtime class, policy preset, and persistence mode that define replay identity,
2. retaining a clause failure also retains the linked case results and evidence refs,
3. retaining a host projection also retains only replay-safe selectors and result projections, never opaque handles,
4. retaining a deferred-oracle item also retains its close condition and scaffold refs.

### 11.4 Search strategy
OxVba distillation should prefer:
1. case elimination first,
2. clause-slice narrowing second,
3. profile and policy axis pruning third,
4. host-sidecar pruning last.

### 11.5 Rewrite rule
Only adapter-declared configuration narrowing or sidecar pruning may be used.
No distillation pass may invent host identities or mutate clause meanings.

## 12. Performance notes for OxVba
1. OxVba already emits many artifacts at runner boundaries; the Replay appliance should ingest those instead of re-instrumenting deep runtime paths by default.
2. Configuration fingerprint, case results, clause coverage, and gate reports are cheap mandatory boundaries.
3. Rich host logs, COM traces, and oracle-run sidecars should remain sidecar-backed.
4. Replay-safe capture must never force interactive host behavior into the hot path of normal execution.

## 13. Open OxVba alignment items
The addendum should carry forward these current gaps:
1. there is no repo-wide replay-appliance schema yet,
2. structured diagnostics snapshot export is still incomplete,
3. current general conformance outputs remain thinner than future replay needs for full object-lifecycle and error-state replay,
4. PMR and event-runtime oracle gaps remain open,
5. package and compiled-artifact shape is still draft.

These should be surfaced as explicit bundle capability limits, not silent omissions.

## 14. Target docs for future incorporation
This addendum should eventually be reflected in:
1. `docs/spec/HOST_RUNNER_POLICY_BOOTSTRAP_V1.md`
2. `docs/spec/HAL_CONFORMANCE_SUITE.md`
3. `docs/CONFORMANCE.md`
4. `docs/LOCAL_EXECUTION_DOCTRINE.md`
5. `docs/spec/PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md`
6. `docs/spec/COM_EARLY_BINDING_TYPELIB_CONFORMANCE_V1.md`
7. any future OxVba replay or debugger contract doc

## 15. Summary
For `OxVba`, the Replay appliance should look like:
1. a clause- and profile-aware bundle projection,
2. with runner fingerprints and host-policy context as first-class replay inputs,
3. with replay-safe host projections and deferred-oracle status preserved,
4. with witness distillation over cases, clauses, and configuration axes,
5. and with tracked versus no-artifact execution modes kept explicit.
