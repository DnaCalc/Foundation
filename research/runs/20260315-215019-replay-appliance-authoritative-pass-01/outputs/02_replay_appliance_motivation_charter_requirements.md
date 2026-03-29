# Replay Appliance Motivation, Charter, and Requirements

## 1. Position
The Replay appliance is a cross-lane Logistics subsystem.

It is not:
1. a replacement for lane-owned semantics,
2. a replacement for OxFml trace schema ownership,
3. a replacement for OxCalc `TraceCalc`,
4. a replacement for OxFunc empirical packs,
5. a replacement for OxVba conformance and clause catalogs.

It is:
1. the portable bundle contract for replayable runs,
2. the shared runner/diff/explain/distill surface spanning lanes,
3. the normalizer between lane-native artifacts and pack-grade cross-lane evidence,
4. the place where deterministic replay and minimized witness extraction become reusable instruments instead of four parallel customs,
5. the rollout-governance surface for adapter capabilities, registry ids, and witness lifecycle state.

## 2. Motivation

### 2.1 Why the program needs this now
The current work is increasingly lane-specialized:
1. `OxFml` is hardening evaluator artifacts, typed rejects, and session traces.
2. `OxCalc` is hardening candidate/publication separation, reference-machine conformance, and replay classes.
3. `OxFunc` is hardening empirical identity through manifest-driven dual-run replay and evidence ids.
4. `OxVba` is hardening profile and policy fingerprints, clause-traced conformance, and deterministic host behavior.

Without a shared Replay appliance:
1. each lane will keep solving bundle format and diff tooling locally,
2. cross-lane explanation will remain manual,
3. pack promotion will continue to require per-lane glue,
4. regressions will remain local assets instead of program assets,
5. counterexamples will remain larger and noisier than they need to be,
6. cross-engine divergence will stay harder to explain and retain than it needs to be.

### 2.2 Why this is accretive rather than disruptive
The Replay appliance does not require the active lanes to stop.
It compounds their work by:
1. preserving lane-native outputs,
2. projecting them into a shared bundle format,
3. enabling one replay/diff/explain/distill toolchain,
4. making every new scenario, fixture, conformance lane, and divergence record reusable across the program,
5. turning large divergences into minimized, replay-closed witnesses fit for packs and issue triage.

## 3. Charter

### 3.1 Mission
The Replay appliance exists to make any meaningful DNA Calc execution reproducible, comparable, and explainable across lanes, hosts, and proving surfaces.

### 3.2 Outcome
Given a run from `OxCalc`, `OxFml`, `OxFunc`, or `OxVba`, the program should be able to answer:
1. what configuration and profile were active,
2. what scenario or corpus slice ran,
3. what semantically relevant events occurred,
4. what was published, rejected, deferred, or unsupported,
5. what artifacts prove that claim,
6. how another engine or lane differed,
7. why the difference matters,
8. what the smallest retained witness is that still proves the difference.

### 3.3 Primary users
1. Green, when turning a behavior claim into a replayable witness.
2. Red and Blue, when diagnosing semantic drift or explaining a divergence.
3. Logistics, when building pack orchestration, artifact retention, and conformance dashboards.
4. Lane maintainers, when promoting local evidence into program-level conformance assets.
5. Triage and pack authors, when shrinking a broad failure into a retained witness.

### 3.4 Ownership model
1. Foundation/Logistics owns the Replay appliance bundle contract, CLI contract, diff/explain contract, and pack-binding policy.
2. Each `Ox*` repo owns its local adapter, emitted lane-native artifacts, and semantics-specific trace details.
3. No lane loses authority over its current canonical artifact vocabulary.
4. Shared projection rules are additive and versioned.

### 3.5 Working name
The overall tool and bundle system should use the working name `DNA ReCalc`.

The name is appropriate because it:
1. evokes deterministic recalculation,
2. fits the project's recalc-as-development doctrine,
3. covers capture, replay, diff, and explain rather than only log playback.

## 4. Scope

### 4.1 In scope
1. Portable replay-bundle contract.
2. Shared runner-selection and configuration fingerprint contract.
3. Shared event, counter, view, diff, and explain surfaces.
4. Lane-adapter contracts for `OxCalc`, `OxFml`, `OxFunc`, and `OxVba`.
5. Witness distillation, reduced-witness bundles, and reduction manifests.
6. Pack-grade export and conformance-ready artifact projection.
7. Performance-sensitive capture modes and hot-path rules.
8. Adapter capability and conformance declarations.
9. Canonical registries for predicate, mismatch, severity, outcome, and lifecycle ids.
10. Witness lifecycle, retention, supersession, and quarantine policy.

### 4.2 Out of scope
1. Replacing lane-native local test harnesses.
2. Freezing final binary encodings for all in-process emitters.
3. Forcing every lane into one event granularity.
4. Replacing empirical-source promotion discipline in Foundation.
5. Declaring all current open concurrency/replay questions resolved.
6. Performing arbitrary source rewrites without lane-owned transform declarations.

## 5. Non-goals
1. `DNA ReCalc` is not a new semantic authority over evaluator, function, coordinator, or HAL behavior.
2. `DNA ReCalc` is not a universal debug log sink.
3. `DNA ReCalc` is not allowed to erase distinctions such as candidate versus publication, reject versus unsupported, or raw return versus published result.
4. `DNA ReCalc` is not allowed to rely on opaque runtime handles as its only notion of identity.
5. `DNA ReCalc` is not a generic reducer that may rewrite lane inputs without replay-safe, lane-declared rules.

## 6. Design Principles
1. Preserve lane authority, standardize transport and explanation.
2. Treat replay artifacts as semantic evidence, not diagnostics-only exhaust.
3. Make every required field carry causal value.
4. Keep hot-path capture cheaper than after-the-fact archaeology.
5. Distinguish required semantic events from optional forensic enrichments.
6. Prefer additive refinement over flattening existing typed surfaces.
7. Distill only through auditable, replay-closed reductions.
8. Separate semantic truth from rollout capability and witness state.

## 7. Requirements

### 7.1 Core replay requirements
1. `REQ-RA-001`: Every replay bundle must declare `profile_id`, `profile_version`, source lane, schema versions, and configuration fingerprint.
2. `REQ-RA-002`: Every replay bundle must preserve stable scenario or corpus identity and selection metadata.
3. `REQ-RA-003`: The bundle model must preserve candidate-versus-publication distinction where the source lane has that distinction.
4. `REQ-RA-004`: The bundle model must preserve typed reject outcomes and reject context instead of flattening them to strings.
5. `REQ-RA-005`: The bundle model must preserve pinned or reader-stable views separately from current published view where the source lane exposes them.
6. `REQ-RA-006`: The bundle model must preserve lane-native identity categories such as stable ids, version keys, fingerprints, and runtime handles without collapsing them into one id.
7. `REQ-RA-007`: The bundle model must support both event-oriented runs and manifest-row-oriented empirical packets.
8. `REQ-RA-008`: The bundle model must support clause or requirement binding where the source lane already uses clause ids, evidence ids, correlation rows, or pack tags.
9. `REQ-RA-009`: The bundle model must support replay-safe representation of unsupported, deferred, opaque, and implementation-defined outcomes.
10. `REQ-RA-010`: The bundle model must retain source-artifact references for large or lane-native sidecars instead of forcing lossy inlining.

### 7.2 Runner, comparison, and explain requirements
11. `REQ-RA-011`: The Replay appliance must support capture, normalize, validate, replay, diff, explain, distill, and pack-export workflows.
12. `REQ-RA-012`: The replay runner must distinguish invalid input, failed assertion, execution error, and unsupported feature states.
13. `REQ-RA-013`: The diff engine must emit typed mismatch classes rather than prose-only summaries.
14. `REQ-RA-014`: The explain plane must be able to answer "why did this change?", "why did this not publish?", and "why do these runs differ?" using bundle artifacts alone.
15. `REQ-RA-015`: The toolchain must support oracle-style comparison where one bundle is treated as canonical and another as candidate.
16. `REQ-RA-016`: The toolchain must support partial replay and filtered replay by scenario id, tag, pack tag, lane, or evidence id.
17. `REQ-RA-017`: The toolchain must support no-artifact or temporary local runs without mutating tracked evidence, while still producing a replay-safe local bundle if requested.
18. `REQ-RA-018`: Pack export must preserve enough structure to satisfy current program expectations for deterministic replay, divergence indexing, and minimized-case retention.

### 7.3 Witness distillation requirements
19. `REQ-RA-019`: The toolchain must support witness distillation from a replay bundle, diff result, explain result, or pack failure scope into a reduced witness bundle.
20. `REQ-RA-020`: Every distillation run must use an explicit typed preservation predicate rather than an implicit notion of "still broken."
21. `REQ-RA-021`: Lane adapters must declare reducible unit kinds, closure dependencies, and any safe rewrite transforms they authorize.
22. `REQ-RA-022`: Distillation must emit an auditable reduction manifest that records retained units, removed units, rewritten units, strategy, iteration count, and final predicate outcome.
23. `REQ-RA-023`: A reduced witness must remain a valid replay bundle by default; if a result is explanatory-only, that status must be explicit and pack-ineligible unless later upgraded.
24. `REQ-RA-024`: The toolchain must support both subset-style reductions and lane-declared rewrite reductions without conflating the two.
25. `REQ-RA-025`: Explain and pack flows must be able to cite reduced witnesses as first-class evidence artifacts.

### 7.4 Performance and operability requirements
26. `REQ-RA-026`: The design must define a capture-mode ladder so every lane can choose between counters-only, summary, replay, and forensic modes.
27. `REQ-RA-027`: Required semantic replay events may not be sampled or silently dropped in replay mode.
28. `REQ-RA-028`: Large payloads must be sidecar-capable and content-addressable so hot paths do not depend on large inline serialization.
29. `REQ-RA-029`: Canonical persisted artifacts must remain machine-readable and file/CLI-friendly.
30. `REQ-RA-030`: Normalization from lane-native buffers into the canonical bundle may happen after the hot path, but must be deterministic and schema-checked.
31. `REQ-RA-031`: The tool must surface capture loss or downgraded instrumentation as an explicit replay artifact, never as silent omission.
32. `REQ-RA-032`: The design must support retention, indexing, and garbage-collection policy without breaking stable replay references.
33. `REQ-RA-033`: The design must permit future cross-engine continuous differential execution and witness distillation reuse without redefining the bundle contract again.

### 7.5 Rollout and governance requirements
34. `REQ-RA-034`: Every adapter must publish a machine-readable capability manifest with supported source schemas, supported bundle schemas, claimed capability levels, known limits, and conformance artifact refs.
35. `REQ-RA-035`: Adapter capability claims must be validated by a shared conformance matrix before lane rollout.
36. `REQ-RA-036`: Predicate kinds, mismatch kinds, severity classes, reduction outcomes, witness lifecycle states, and capability levels must come from canonical versioned registries.
37. `REQ-RA-037`: Bundles and tool outputs must reference canonical registry ids rather than lane-local free-text status strings when a registry family exists.
38. `REQ-RA-038`: Every reduced witness must carry an explicit lifecycle state and retention policy, including explanatory-only, retained, promoted, superseded, quarantined, or GC-eligible status where applicable.
39. `REQ-RA-039`: Quarantine reasons such as oracle instability, insufficient capture, missing source artifacts, adapter failure, or schema incompatibility must be emitted as structured lifecycle data and must block pack promotion.
40. `REQ-RA-040`: Bundle, adapter, and registry evolution policy must distinguish additive, tightening, breaking, experimental, deprecated, and removed changes.

## 8. Constraints
1. `CONSTR-RA-001`: Lane-owned canonical docs remain authoritative for lane semantics and lane-native schema details.
2. `CONSTR-RA-002`: The Replay appliance may standardize projection and transport, but may not silently redefine the meaning of source-lane artifacts.
3. `CONSTR-RA-003`: Canonical semantic ordering must be based on deterministic event sequence and causal references, not wall-clock timestamps.
4. `CONSTR-RA-004`: Portable replay must not depend on opaque memory addresses, runtime pointers, or process-local handle values alone.
5. `CONSTR-RA-005`: The replay bundle must tolerate mixed source granularity: event streams, manifest rows, clause reports, and summarized counters.
6. `CONSTR-RA-006`: Required event families must be explicitly versioned by source schema and by normalized replay schema.
7. `CONSTR-RA-007`: Any unavailable source field must be represented by an explicit missing or opaque marker rather than an invented default.
8. `CONSTR-RA-008`: Bundle generation must be file/CLI-based at the canonical boundary even if in-process emitters use cheaper local formats.
9. `CONSTR-RA-009`: Cross-lane normalization must be additive. The tool may preserve both source-native and normalized forms in one bundle.
10. `CONSTR-RA-010`: Pack-grade replay artifacts must remain stable under repeated normalization of the same source run.
11. `CONSTR-RA-011`: Distillation may not invent semantic facts or rewrite lane inputs unless the relevant adapter declares the transform family and the result is replay-validated.
12. `CONSTR-RA-012`: A reduced witness must remain replay-closed for its declared predicate even when large payloads are externalized as sidecars.
13. `CONSTR-RA-013`: Predicate failure caused by missing capability, downgraded capture mode, or unsupported source shape must be surfaced as an explicit reduction outcome, never as silent irreducibility.
14. `CONSTR-RA-014`: Registry ids and capability levels may be extended, but may not be silently redefined by lane-local addenda.
15. `CONSTR-RA-015`: Explanatory-only or quarantined witnesses are not pack-eligible.
16. `CONSTR-RA-016`: Adapter capability claims may not exceed the highest level proven by conformance artifacts.

## 9. Success Test
This effort is successful when:
1. a `TraceCalc` run, an `OxFml` fixture run, an `OxFunc` empirical packet, and an `OxVba` conformance run can all be expressed as `DNA ReCalc` bundles,
2. the tool can diff and explain those bundles using one command family,
3. at least one divergence or reject witness from those bundles can be distilled into a smaller replay-closed witness with provenance preserved,
4. lane-owned semantics remain unchanged,
5. at least one adapter capability manifest and one witness lifecycle record can be emitted and validated,
6. pack export becomes easier rather than more bespoke.
