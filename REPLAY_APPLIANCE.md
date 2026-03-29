# REPLAY_APPLIANCE.md — DNA Calc Replay Appliance

## 1. Position
This document is the detailed Foundation source for the Replay appliance.

It is subordinate to:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`

Use this file for detailed Replay scope, architecture, governance, and rollout policy once the top-level doctrine and architecture framing are understood.

## 2. Charter
The Replay appliance exists to turn failures, regressions, and cross-engine disagreements into durable, machine-usable evidence.

Its program role is:
1. capture what happened,
2. replay it deterministically,
3. compare runs across lanes and engines,
4. explain why results diverged,
5. distill large failures into smaller replay-closed witnesses,
6. feed pack-grade evidence and promotion decisions.

The resulting program rule is:
- regressions are not disposable incidents,
- they are retained replay assets with explicit lifecycle and governance.

## 3. Scope and non-goals
In scope:
1. normalized replay bundle contract,
2. lane-adapter contract and capability model,
3. shared replay, diff, explain, and witness-distillation architecture,
4. canonical registry families used by replay-governed artifacts,
5. witness lifecycle, quarantine, supersession, and pack-eligibility policy,
6. `OxReplay` repo scope and `DNA ReCalc` host role,
7. rollout policy for introducing Replay across the `Ox*` repos.

Out of scope:
1. lane-local semantic definitions,
2. lane-local event-family meaning beyond normalized cross-lane bindings,
3. lane-local reject taxonomy authority,
4. lane-local reduction rewrite permissions,
5. pack threshold calibration by profile/version,
6. final UX design for future Replay UI surfaces.

## 4. Ownership and topology
Replay ownership is split deliberately.

### 4.1 Foundation
Foundation owns:
1. Replay doctrine,
2. architectural boundary rules,
3. adapter-governance policy,
4. canonical registry governance,
5. witness lifecycle and promotion policy,
6. cross-program rollout and pack integration rules.

### 4.2 Lane repos
`OxFunc`, `OxFml`, `OxCalc`, and `OxVba` own:
1. lane-native artifact meaning,
2. authoritative capture semantics,
3. lane-local event and reject semantics,
4. lane-local reduction safety rules,
5. authoritative adapter meaning for their own artifacts.

### 4.3 `OxReplay`
`OxReplay` is the shared replay implementation repo and library family.

It owns shared implementation for:
1. bundle parsing, validation, serialization, and indexing,
2. normalized replay runtime types,
3. replay executor infrastructure,
4. diff and explain engine infrastructure,
5. witness-distillation framework,
6. registry and lifecycle tooling,
7. adapter SDK, loader, and conformance harnesses,
8. shared pack-export infrastructure,
9. `DNA ReCalc` host implementation.

`OxReplay` is not a semantics lane.

### 4.4 `DNA ReCalc`
`DNA ReCalc` is the replay appliance host surface built on `OxReplay`.

It is:
1. a CLI and later optional UI,
2. a replay and evidence host,
3. distinct from spreadsheet proving hosts such as `DNA OneCalc`, `DNA TreeCalc`, or `DNA PreCalc`.

`DNA ReCalc` must not become a second source of semantic truth.

## 5. Architectural model
Replay is a cross-lane causality plane implemented through adapters.

### 5.1 Layers
The normalized architecture has five layers:

1. **Lane-native capture**
   - lane-owned traces, scenarios, packets, sessions, counters, and source artifacts.
2. **Lane adapter**
   - lane-owned semantic bridge into the normalized replay model.
3. **Normalized replay model**
   - shared bundle, event, diff, explain, predicate, and witness abstractions.
4. **Portable bundle packaging**
   - file- and CLI-friendly bundle layout with sidecars and schema-versioned manifests.
5. **Shared tool surface**
   - replay, diff, explain, distill, validate, and export surfaces implemented in `OxReplay` and hosted by `DNA ReCalc`.

### 5.2 Source preservation rule
Normalization is allowed to make cross-lane tooling possible, but it may not erase lane authority.

Replay artifacts must preserve:
1. source lane id,
2. source schema version,
3. source artifact identity,
4. capture mode,
5. lossless or lossy projection status,
6. capture loss or downgraded instrumentation when present.

### 5.3 Performance-sensitive rule
Replay capture must not collapse hot-path behavior into logging.

Therefore:
1. required semantic replay events may not be silently sampled away in replay mode,
2. large payloads should be sidecar-capable and content-addressable,
3. normalization may happen after the hot path if deterministic and schema-checked,
4. witness distillation is offline work and must not be on the hot path.

## 6. Canonical artifact families
Replay uses a shared set of artifact families. The exact serialized schema may evolve, but these families are stable.

1. `ReplayBundleManifest`
   - bundle identity, schema versions, lane ownership, capture mode, and source refs.
2. `ReplayRunManifest`
   - one captured run and its execution context.
3. `ReplayScenarioManifest`
   - scenario or packet-level grouping for replay and diff.
4. `ReplayEvent`
   - normalized event record with identity, ordering, family, and payload refs.
5. `ReplayCounterSet`
   - deterministic counters and phase or state metrics.
6. `ReplayView`
   - query-ready derived surfaces over bundle data.
7. `ReplayDiff`
   - typed divergence record between two replay surfaces.
8. `ReplayExplainRecord`
   - causal explanation over event, view, diff, or reject surfaces.
9. `ReplayPreservationPredicate`
   - explicit predicate defining what a witness distillation pass must preserve.
10. `ReplayReductionManifest`
   - reduction history, strategy, outcome, and closure status.
11. `ReplayAdapterCapabilityManifest`
   - machine-readable capability claim for one adapter.
12. `ReplayRegistryRef`
   - reference to one versioned registry family used by bundle or tool output.
13. `ReplayWitnessLifecycleRecord`
   - lifecycle, quarantine, supersession, and retention state for a witness.

## 7. Shared replay surfaces
The appliance must provide these shared surfaces.

### 7.1 Validate and ingest
The first shared duty is to ingest lane-produced artifacts and validate:
1. source-schema compatibility,
2. required field presence,
3. declared capability level,
4. registry-version compatibility,
5. pack-surface completeness where a pack claims Replay support.

### 7.2 Replay
Replay may be:
1. step-oriented,
2. scenario-oriented,
3. packet-row oriented where empirical comparison is the primary surface.

Replay must be deterministic for required modes and must surface missing or unstable prerequisites explicitly.

### 7.3 Diff
Diff compares:
1. bundle to bundle,
2. current run to baseline,
3. lane run to oracle run,
4. required surfaces only or full forensic surfaces.

Diff output must use typed mismatch classes where a registry family exists.

### 7.4 Explain
Explain surfaces must answer questions such as:
1. why a value changed,
2. why a commit was rejected,
3. why two engines diverged,
4. why a witness is quarantined or not pack-eligible.

Explain is causal and source-aware, not just textual commentary.

### 7.5 Witness distillation
Witness distillation turns large replay bundles or diffs into smaller replay-closed witnesses.

Rules:
1. every reduction pass is driven by an explicit preservation predicate,
2. closure rules come from the authoritative lane adapter,
3. only lane-declared safe rewrites may be used,
4. unstable predicates or insufficient capture must produce explicit reduction outcomes,
5. reduced witnesses remain governed artifacts, not ad hoc local files.

## 8. Adapter and capability model
Every lane adapter must publish a machine-readable capability manifest before downstream packs or hosts rely on it.

### 8.1 Capability levels
The shared capability ladder is:
1. `C0.ingest_valid`
2. `C1.replay_valid`
3. `C2.diff_valid`
4. `C3.explain_valid`
5. `C4.distill_valid`
6. `C5.pack_valid`

Interpretation rule:
- higher levels do not erase lane ownership,
- they only describe how much shared Replay behavior is proven for that adapter.

### 8.2 Required manifest content
An adapter capability manifest must declare:
1. lane id,
2. adapter id and version,
3. supported source schemas,
4. supported bundle schemas,
5. supported capture modes,
6. claimed capability levels,
7. known limits and denial conditions,
8. conformance artifact refs,
9. registry version refs.

### 8.3 Conformance rule
Capability claims are not self-asserted policy.

They become usable only when:
1. required conformance evidence exists,
2. the shared capability matrix is satisfied,
3. registry versions are pinned,
4. lifecycle support is declared when distillation or pack promotion is claimed.

## 9. Canonical registries
Replay-governed artifacts should not drift into lane-local free-text statuses where a cross-lane registry exists.

The initial registry families are:
1. predicate kind,
2. mismatch kind,
3. severity,
4. reduction outcome,
5. witness lifecycle state,
6. capability level.

Registry rule:
1. tool outputs use registry ids when a family exists,
2. bundles snapshot the registry versions they depend on,
3. lane-local labels may remain as explanatory metadata but do not replace canonical ids.

## 10. Witness lifecycle and quarantine
Every retained witness must carry explicit lifecycle state.

The policy-relevant states are:
1. explanatory-only,
2. retained-local or retained-shared,
3. promoted-pack,
4. superseded,
5. quarantined,
6. GC-eligible.

Rules:
1. quarantined witnesses remain visible to triage,
2. quarantined or explanatory-only witnesses are not pack-eligible,
3. pack promotion requires explicit lifecycle transition,
4. supersession must preserve lineage to the replaced witness,
5. GC policy may remove data only after lifecycle policy allows it.

Quarantine reasons must be structured. Initial reasons include:
1. unstable oracle or predicate,
2. insufficient capture,
3. missing source artifacts,
4. adapter failure,
5. schema incompatibility.

## 11. Pack and promotion integration
Replay integrates directly with pack and doctrine-promotion flow.

### 11.1 Replay-governed packs
The primary shared packs are:
1. `PACK.replay.appliance`
2. `PACK.trace.forensic_plane`
3. `PACK.diff.cross_engine.continuous`
4. `PACK.reject.calculus` where reject replay evidence is part of the claim

### 11.2 Required replay artifacts for pack-grade claims
Replay-governed packs must declare:
1. required adapter capability level,
2. required bundle mode and schema,
3. required registry families and versions,
4. required witness lifecycle states,
5. required diff or explain surfaces,
6. whether reduced witnesses are mandatory, optional, or forbidden for the pack claim.

### 11.3 Promotion packet rule
Foundation doctrine updates that depend on Replay must carry a promotion packet containing:
1. target text,
2. replay evidence refs,
3. capability and pack impact notes,
4. open questions or risks,
5. migration or compatibility implications where applicable.

## 12. Rollout baseline
Replay rollout is staged so shared infrastructure follows proven adapter surfaces rather than getting invented too early.

The intended order is:
1. Foundation promotes Replay doctrine and architecture,
2. `OxCalc` and `OxFml` prove the first adapter surfaces against their authoritative semantics,
3. shared stable replay mechanics are implemented or extracted in `OxReplay`,
4. `DNA ReCalc` becomes the common replay host surface,
5. `OxFunc` and `OxVba` join through narrower initial scopes and later capability growth.

Initial lane expectations:
1. `OxCalc`
   - first lane expected to reach `C5.pack_valid`,
   - first proving ground for engine diff and witness distillation.
2. `OxFml`
   - early focus on ingest, replay, diff, and explain,
   - distillation follows after the seam evidence shape is stable.
3. `OxFunc`
   - early scope is empirical packet and manifest-driven replay.
4. `OxVba`
   - early scope is conformance and host-policy replay with narrower initial bundle families.

## 13. Evolution policy
Replay schema and policy evolution must be explicit.

Change classes:
1. **Additive**
   - new optional fields or registry entries with no prior invalidation.
2. **Tightening**
   - stricter validation or clearer required behavior with compatible data shape.
3. **Breaking**
   - incompatible schema or contract change requiring coordinated version movement.
4. **Experimental**
   - declared non-baseline surfaces that may change without broad downstream commitment.
5. **Deprecated**
   - still supported for a declared window, but scheduled for removal.
6. **Removed**
   - no longer supported by the current baseline.

Rule:
1. bundle schema,
2. adapter schema,
3. registry versions,
4. capability interpretation,
5. lifecycle rules
must all evolve under explicit versioned policy rather than silent drift.

## 14. Explicit non-goals
The Replay appliance does not:
1. redefine lane semantics,
2. replace lane-owned spec sets,
3. replace spreadsheet proving hosts,
4. force one adapter implementation pattern on every lane,
5. guarantee pack readiness from raw capture alone,
6. justify retaining noisy or unstable witnesses without lifecycle labeling.

## 15. Resulting rule
The Replay appliance is the Foundation-governed cross-lane replay, diff, explain, and witness-distillation plane.

It is implemented through:
1. lane-owned semantic adapters,
2. shared `OxReplay` infrastructure,
3. `DNA ReCalc` as the replay host surface,
4. explicit capability, registry, lifecycle, and pack-governance policy.
