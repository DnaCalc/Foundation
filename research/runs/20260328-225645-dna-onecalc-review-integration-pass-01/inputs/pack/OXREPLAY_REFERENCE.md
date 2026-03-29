# OxReplay Reference

This document consolidates the current DNA OneCalc-relevant reference set from `OxReplay`.

Repo role: Replay bundle/runtime infrastructure, adapter and capability model, diff/explain surfaces, witness lifecycle mechanics, and the generic DNA ReCalc replay host.

Included source documents:
- `OxReplay/CHARTER.md`
- `OxReplay/CURRENT_BLOCKERS.md`
- `OxReplay/docs/IN_PROGRESS_FEATURE_WORKLIST.md`
- `OxReplay/docs/spec/DNA_RECALC_CLI_CONTRACT.md`
- `OxReplay/docs/spec/DNA_RECALC_HOST.md`
- `OxReplay/docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`
- `OxReplay/docs/spec/OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md`
- `OxReplay/docs/spec/OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md`
- `OxReplay/docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md`
- `OxReplay/docs/spec/OXREPLAY_INITIAL_ADAPTER_INTAKE_PLAN.md`
- `OxReplay/docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md`
- `OxReplay/docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md`
- `OxReplay/docs/spec/OXREPLAY_WITNESS_LIFECYCLE_TRANSITIONS.md`
- `OxReplay/docs/spec/README.md`

The sources are reproduced below in full so the pack remains self-contained even after flattening.

## Source: `OxReplay/CHARTER.md`

# CHARTER.md — OxReplay Charter

## 1. Mission
OxReplay defines, implements, and proves the shared Replay appliance runtime for DNA Calc.

It owns the reusable replay substrate for bundle validation, replay execution, diff/explain, witness distillation, adapter capability validation, and the `DNA ReCalc` host surface while preserving lane ownership of semantics.

## 2. Precedence
When guidance conflicts, precedence is:
1. `../Foundation/CHARTER.md`
2. `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
3. `../Foundation/OPERATIONS.md`
4. `../Foundation/REPLAY_APPLIANCE.md`
5. this `CHARTER.md`
6. this repo `OPERATIONS.md`

## 3. Scope
In scope:
1. Canonical replay bundle runtime and validation surfaces.
2. Shared runtime types for replay, diff, explain, and witness distillation.
3. Adapter SDK, loader, capability-manifest validation, and conformance harnesses.
4. Registry and witness-lifecycle runtime support.
5. `DNA ReCalc` as the replay host over the shared runtime.

Out of scope:
1. Lane-native semantic ownership for `OxFunc`, `OxFml`, `OxCalc`, or `OxVba`.
2. Lane-local event-family truth and reject taxonomy authority.
3. Lane-local reduction rewrite permissions.
4. Spreadsheet proving-host semantics.
5. UI/product doctrine outside replay-host concerns.

## 4. Ownership boundary rule
1. `OxReplay` may normalize and operate on lane artifacts through declared adapter contracts.
2. `OxReplay` may not reinterpret lane-native artifacts outside those declared adapter contracts.
3. Lane repos remain authoritative for semantic meaning; `OxReplay` owns shared mechanics only.

## 5. `DNA ReCalc` rule
1. `DNA ReCalc` is the host surface over `OxReplay`.
2. It is not part of the spreadsheet host progression ladder.
3. It must not become a second semantic authority.

## 6. Clean-room rule
Allowed sources:
1. public specifications and documentation,
2. published research,
3. reproducible black-box observations,
4. Foundation-promoted replay doctrine and lane-provided clean-room handoff artifacts.

Disallowed sources:
1. proprietary or restricted sources,
2. reverse engineering of internals,
3. decompilation/disassembly of Excel internals.

## 7. Definition of done
A shared-runtime change is done only when:
1. repo-local spec text is updated,
2. relevant Foundation doctrine links still hold,
3. capability and pack impact are stated,
4. affected adapter or host conformance evidence is updated,
5. the change does not widen `OxReplay` into lane-semantic ownership.

## Source: `OxReplay/CURRENT_BLOCKERS.md`

# CURRENT_BLOCKERS.md — OxReplay

Status: active blockers present.

Last reviewed: 2026-03-18.

---

## Active Blockers

### BLK-REPLAY-002: OxCalc manifest C4 lifecycle gap

- **Status**: active
- **Impact**: `W003` sibling-manifest acceptance, `W004` honest capability intake, and any local acceptance of `OxCalc` `cap.C4.distill_valid`
- **Current state**: the retained `OxReplay` W003 conformance baseline rejects `../OxCalc/docs/spec/core-engine/CORE_ENGINE_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json` because it claims `cap.C4.distill_valid` without declaring lifecycle states
- **Exact unblock steps**: either add explicit lifecycle states to the `OxCalc` manifest and keep the `C4` claim, or downgrade the current claim to `C3` and keep `C4` as target or scaffolded until lifecycle evidence is exposed
- **Recommendation**: escalate
- **Opened**: 2026-03-18

---

## Resolved Blockers

### BLK-REPLAY-001: First implementation stack undeclared

- **Status**: resolved
- **Impact**: `W002` through `W006` activation packet quality
- **Current state**: Rust-first implementation direction is now declared, the active Cargo workspace root is `src/`, workspace checks are explicit, and the workset packets now reference the chosen stack
- **Exact unblock steps**: none; resolved by the Rust-first baseline update and execution-packet expansion
- **Recommendation**: workaround
- **Opened**: 2026-03-16
- **Resolved**: 2026-03-16

---

## Entry Template

```text
### BLK-REPLAY-NNN: <title>

- **Status**: active | resolved | closed
- **Impact**: <which worksets/features are blocked>
- **Current state**: <what has been attempted, what failed>
- **Exact unblock steps**: <specific actions needed>
- **Recommendation**: wait | escalate | workaround
- **Opened**: YYYY-MM-DD
- **Resolved**: YYYY-MM-DD (if applicable)
```

## Source: `OxReplay/docs/IN_PROGRESS_FEATURE_WORKLIST.md`

# IN_PROGRESS_FEATURE_WORKLIST.md — OxReplay

## Active bootstrap worksets

1. `W001_REPO_BOOTSTRAP_AND_RUNTIME_STRATA`
   - status: complete
   - objective: lock repo skeleton, runtime strata, and first package map.
2. `W002_BUNDLE_AND_SCHEMA_RUNTIME`
   - status: complete
   - objective: stand up canonical bundle parsing, validation, and indexing.
3. `W003_ADAPTER_CAPABILITY_AND_CONFORMANCE_HARNESS`
   - status: complete
   - objective: validate adapter manifests and capability claims.
4. `W004_OXCALC_OXFML_ADAPTER_INTAKE_AND_REPLAY_PATH`
   - status: in_progress
   - objective: exercise initial adapters from the first two integrated lanes.
5. `W005_DNA_RECALC_CLI_SHELL_AND_PACK_EXPORT_BASELINE`
   - status: in_progress
   - objective: provide the first usable host shell and pack-facing replay export path.
6. `W006_WITNESS_DISTILLATION_AND_LIFECYCLE_GOVERNANCE_BASELINE`
   - status: in_progress
   - objective: stand up predicate-driven witness reduction and lifecycle/quarantine handling.

## Activation note
1. The Rust-first stack is now declared for the repo.
2. `W002` has now emitted retained validator fixtures and baseline outputs for the first bundle/runtime slice.
3. `W003` has now emitted retained conformance fixtures and baseline outputs, including current sibling-manifest acceptance and rejection cases.
4. `W004` is now active over the first retained `OxCalc` and `OxFml` replay intake baselines and the first shared diff control/mismatch runs.
5. `W005` is now active over the first usable `DNA ReCalc` host shell baselines for validate, replay, diff, explain, adapter validation, distill, witness-state, and pack export.
6. `W006` is now active over retained distillation and lifecycle-governance examples; broad adapter `C4` and `C5` claims remain later evidence lanes.

## Reserved follow-on lane entry
1. `OxCalc` remains the first lane expected to drive toward `C5.pack_valid`.
2. `OxFml` should first prove ingest, replay, diff, and explain before distillation is widened.
3. `OxFunc` and `OxVba` are later and narrower intake lanes; do not imply broad replay or pack-valid scope for them by default.

## Downstream host note
1. `DNA OneCalc` consumes current `OxReplay` surfaces as shared infrastructure, not as a second replay-host contract.
2. The current honest floor for that consumer is accepted `OxFml` `C0` through `C3` plus the first accepted `OxXlObs` observation-source seam.
3. Direct `OxFunc` and `OxVba` replay intake remain later narrower lanes.

## Activation rule
Move a workset to `in_progress` only when:
1. scope is explicit,
2. dependencies are known,
3. capability and pack impact are named,
4. no lane-semantic ownership drift is introduced.

## Source: `OxReplay/docs/spec/DNA_RECALC_CLI_CONTRACT.md`

# DNA_RECALC_CLI_CONTRACT.md

## 1. Position
This document defines the initial CLI contract for `DNA ReCalc`.

It refines `DNA_RECALC_HOST.md` into an activation-ready command surface for `W005`.

## 2. Command families
The baseline command families are:
1. `validate-bundle`
2. `replay`
3. `diff`
4. `explain`
5. `distill`
6. `validate-adapter`
7. `witness-state`
8. `pack-export`

## 3. Invocation shape
The initial executable name is:
1. `dna-recalc`

General invocation form:
1. `dna-recalc <command> [options]`

## 4. Input model
Common input flags should include:
1. `--bundle <path>`
2. `--adapter <path>`
3. `--kind <kind>` for replay, diff, explain, and distill inputs
4. `--case-id <id>` when a fixture family requires a stable case selection
5. `--predicate-id <id>` and `--predicate-description <text>` for distillation
6. `--format json|text`
7. `--output <path>`
8. `--run-id <id>` when a retained or transient run id is required

## 5. Output model
Rules:
1. `--format json` is the machine-usable baseline
2. `--format text` is human-readable convenience output
3. retained outputs use repo-relative artifact paths when checked in
4. command output should name the active scenario id, bundle id, adapter id, or witness id when applicable

## 6. Exit codes
1. `0` success
2. `1` validation or replay failure with a deterministic machine-readable outcome
3. `2` usage or argument error
4. `3` unsupported capability or incompatible adapter/bundle shape
5. `4` internal error where no deterministic replay-governed result could be produced

## 7. Command-specific baseline expectations
1. `validate-bundle`
   - validates schema compatibility, sidecars, registry refs, and bundle indexing floor
2. `replay`
   - executes deterministic replay over a canonical bundle
3. `diff`
   - compares candidate versus baseline replay surfaces using typed mismatch output
4. `explain`
   - returns causal explanation records for replay, diff, reject, or lifecycle questions
5. `distill`
   - emits predicate-bound reduction manifests and quarantine outcomes without moving distillation into hot-path replay
6. `validate-adapter`
   - validates adapter manifest shape, capability claims, registry refs, and declared limits
7. `witness-state`
   - queries or updates witness lifecycle state through governed transitions only
8. `pack-export`
   - emits pack-facing replay outputs without implying pack readiness unless evidence exists

## 8. Machine-readable floor
The machine-readable floor for baseline commands should include:
1. command id
2. status
3. capability impact
4. pack impact
5. artifact refs
6. scenario ids when relevant
7. typed validation, diff, explain, or lifecycle records

## 9. Non-goals
This pass does not define:
1. a GUI contract
2. free-form interactive debugging UX
3. lane-semantic direct-link shortcuts

## Source: `OxReplay/docs/spec/DNA_RECALC_HOST.md`

# DNA_RECALC_HOST.md

## 1. Position
This document defines the initial repo-local scope of `DNA ReCalc` as the host surface over `OxReplay`.

## 2. Host role
`DNA ReCalc` is the replay appliance host for:
1. bundle ingest and validation,
2. replay execution,
3. diff and explain queries,
4. witness distillation,
5. adapter capability validation,
6. pack-facing replay export and witness lifecycle operations.

It is the generic replay host reference surface for `OxReplay`.

## 3. Not this host
`DNA ReCalc` is not:
1. a spreadsheet proving host like `DNA OneCalc` or `DNA TreeCalc`,
2. a new semantics authority,
3. a universal sink for arbitrary logs with no bundle or adapter discipline.

## 4. Relationship to other hosts
A non-`DNA ReCalc` host such as `DNA OneCalc` may:
1. call `OxReplay` libraries,
2. embed replay, diff, explain, or witness views in its own UI,
3. retain `OxReplay` outputs as part of its own scenario or handoff model.

That does not make it `DNA ReCalc`.

Working rule:
1. `DNA ReCalc` remains the canonical shared replay-host contract,
2. `DNA OneCalc` remains a separate proving host that consumes shared replay mechanics,
3. any app-facing `DNA OneCalc` replay UX is a host-local projection over `OxReplay`, not a rewrite of the `DNA ReCalc` host contract.

## 5. Initial command families
The initial host should expect to cover:
1. ingest and validate,
2. replay,
3. diff,
4. explain,
5. distill,
6. adapter validation,
7. witness-state or lifecycle operations,
8. pack export.

## 6. UX boundary
1. CLI first.
2. Optional later UI over the same runtime surfaces.
3. Explanations should remain queryable and machine-usable, not only human prose.

## 7. Dependency rule
`DNA ReCalc` depends on `OxReplay`.

It should consume lane behavior through adapters and canonical bundles rather than by linking directly to lane-semantic internals.

## 8. First bootstrap goals
1. Provide a usable CLI shell over bundle validation.
2. Exercise initial `OxCalc` and `OxFml` adapters.
3. Surface typed diffs and causal explanations.
4. Delay broader UI ambitions until the shared runtime is stable.

## Source: `OxReplay/docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`

# OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md

## 1. Position
This document defines how `OxReplay` should host adapters and capability validation without taking lane ownership away from the source repos.

## 2. Adapter contract rule
An adapter is the lane-declared bridge between lane-native artifacts and the normalized replay model.

`OxReplay` owns:
1. adapter interfaces,
2. adapter loading and execution runtime,
3. manifest parsing and capability validation,
4. conformance harnesses,
5. shared bundle emission and validation utilities.

Lane repos own:
1. source artifact meaning,
2. source schema truth,
3. closure and safe-rewrite authority for distillation,
4. semantic interpretation of lane-local payloads.

## 3. Supported adapter patterns
The runtime should support:
1. direct canonical-bundle emitters from lane repos,
2. narrow adapter packages referencing `OxReplay` abstractions,
3. plugin-style adapters loaded by `DNA ReCalc`,
4. conformance-only test adapters and fixtures.

## 4. Downstream host consumer rule
A non-`DNA ReCalc` host such as `DNA OneCalc` may consume `OxReplay` through:
1. shared bundle schemas,
2. shared replay runtime types,
3. adapter capability validation,
4. in-process or wrapped replay, diff, explain, distill, or witness-state services.

That host must still:
1. rely on declared adapter meaning,
2. state the capability level it actually depends on,
3. treat missing or provisional capability as a real product constraint,
4. avoid presenting local product UX as the `DNA ReCalc` host contract.

## 5. Capability ladder
Shared capability levels are:
1. `C0.ingest_valid`
2. `C1.replay_valid`
3. `C2.diff_valid`
4. `C3.explain_valid`
5. `C4.distill_valid`
6. `C5.pack_valid`

`OxReplay` must treat capability claims as validated evidence surfaces, not mere metadata strings.

Downstream packs, hosts, and promotion packets must state the required capability level explicitly rather than assuming Replay support generically.

## 6. Bootstrap rollout baseline
Foundation rollout expectations for initial lane growth are:
1. `OxCalc` is the first lane expected to drive toward `C5.pack_valid` and the first proving ground for shared diff and witness-distillation flows.
2. `OxFml` should first prove ingest, replay, diff, and explain; distillation follows only after seam evidence stabilizes.
3. `OxFunc` joins later through narrower initial replay surfaces and later capability growth.
4. `OxVba` joins later through narrower initial conformance and host-policy replay surfaces.

## 7. Current conservative downstream floor
For a downstream consumer such as `DNA OneCalc`, the current honest local floor is:

| Surface | Conservative assumption | Local basis |
|---|---|---|
| `OxFml` | accepted through `C3.explain_valid`; do not assume `C4` or `C5` | `docs/test-runs/w003-conformance-oxfml-replay-adapter-v1-baseline/report.json`, `docs/upstream/NOTES_FOR_OXFML.md` |
| `OxFunc` | no accepted local direct replay-intake floor yet | `docs/IN_PROGRESS_FEATURE_WORKLIST.md`, `docs/upstream/NOTES_FOR_OXFUNC.md` |
| `OxXlObs` | accepted first-pass observation-source seam without a formal adapter capability claim; current replay-facing view remains `lossy` | `docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md`, `docs/test-runs/oxxlobs-seam-xlobs_capture_values_formulae_001-baseline/` |
| `OxVba` | later and narrower lane with no accepted local replay capability floor yet | `docs/IN_PROGRESS_FEATURE_WORKLIST.md`, `docs/upstream/NOTES_FOR_OXVBA.md` |

Interpretation rule:
1. absence of accepted local capability evidence means `no accepted capability claim`,
2. planning docs and worklists do not upgrade that floor by themselves.

## 8. Required adapter manifest content
1. adapter id and version,
2. lane id,
3. supported source schemas,
4. supported bundle schemas,
5. supported capture modes,
6. claimed capability levels,
7. known limits,
8. conformance artifact refs,
9. registry version refs.

## 9. Conformance runtime duties
`OxReplay` should provide shared machinery to:
1. validate manifest shape,
2. validate capability claims against shared rules,
3. surface registry-version mismatches,
4. report missing lifecycle support for distillation or pack claims,
5. emit machine-readable validation results for CI and `DNA ReCalc`.

## 10. Distillation boundary
`OxReplay` may execute reduction search, but:
1. preservation predicates remain explicit inputs,
2. closure rules come from the adapter,
3. safe rewrite transforms must be lane-declared,
4. unstable predicates or insufficient capture must produce explicit outcomes,
5. witness lifecycle and quarantine handling remain governed outputs.

## 11. Resulting rule
`OxReplay` hosts the adapter runtime and conformance machinery, but the lane repos remain the semantic owners of what their adapters mean.

## Source: `OxReplay/docs/spec/OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md`

# OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md

## 1. Position
This document defines the local `OxReplay` implementation boundary for bundle, witness, registry, and lifecycle handling.

Foundation remains the owner of replay doctrine and normative cross-program constraints.
Lane repos remain the owners of source semantic meaning.
`OxReplay` owns the shared mechanics needed to ingest, validate, index, operate on, and emit replay-governed artifacts.

## 2. Shared artifact families
The shared runtime is expected to handle these artifact families:
1. canonical replay bundles,
2. adapter capability manifests,
3. registry refs and optional registry snapshots,
4. witness bundles and reduction manifests,
5. witness lifecycle records,
6. explanation and conformance outputs where they are retained as evidence.

## 3. Ownership split
1. Foundation defines the doctrine, compatibility expectations, lifecycle policies, and registry governance.
2. Lane repos define the source artifact meaning, source schema truth, closure rules, and safe rewrite permissions.
3. `OxReplay` implements:
   - schema-aware ingest,
   - sidecar resolution,
   - lineage-preserving normalization,
   - compatibility checking,
   - replay and explanation execution over canonical forms,
   - witness emission and lifecycle handling.

## 4. Required local runtime responsibilities
`OxReplay` must be able to:
1. validate bundle and manifest schema/version compatibility,
2. preserve source lane, adapter id, schema lineage, capture mode, projection status, capture-loss or downgraded-instrumentation status when present, and registry pinning,
3. resolve sidecars and external artifact refs without silently mutating tracked inputs,
4. surface lifecycle state, quarantine reason, supersession lineage, and pack-eligibility state explicitly,
5. use canonical registry ids when a replay-governed registry family exists and snapshot the required registry versions in retained artifacts,
6. expose machine-usable failure classes for invalid bundles, unsupported capabilities, incompatible registries, or unstable distillation outcomes.

## 5. Non-`DNA ReCalc` host artifact use
A downstream host such as `DNA OneCalc` may keep product-level artifacts such as scenarios, scenario runs, comparisons, and handoff packets outside `OxReplay`.

When those artifacts rely on `OxReplay`, they should retain or point to:
1. the replay bundle or view id,
2. source lane and adapter identity,
3. source schema lineage,
4. capture mode and projection status,
5. registry refs when present,
6. lifecycle state and quarantine status when present,
7. retained diff, explain, or reduction artifact refs.

Rule:
1. `OxReplay`-governed evidence should remain retained evidence,
2. it should not be collapsed into UI-only or product-only state with no replay lineage.

## 6. Non-goals
`OxReplay` must not:
1. invent missing source semantics,
2. infer lane-local safe rewrites,
3. silently coerce incompatible source schemas into "best effort" runtime behavior,
4. treat witness lifecycle state as optional decoration.

## 7. Suggested retained roots
The initial retained artifact layout should prefer:
1. `docs/test-corpus/bundles/`
   - canonical retained sample bundles and bundle-shape fixtures.
2. `docs/test-corpus/witnesses/`
   - retained witness bundles and reduction examples.
3. `states/registry/`
   - registry snapshots, compatibility baselines, and validator reference state.
4. `states/lifecycle/`
   - retained lifecycle examples, quarantine examples, or transition fixtures when checked-in state is required.
5. `docs/test-runs/<run-id>/`
   - human-readable summaries of validation, conformance, and retained replay runs.

## 8. Canonical registry families
The initial replay-governed registry families are:
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

Current conservative consumer rule:
1. if a retained upstream artifact arrives without registry refs, treat that intake as provisional rather than silently upgrading it to a registry-pinned surface,
2. do not make broad witness or pack claims over a lossy or registry-unpinned observation projection unless retained conformance says that is acceptable for the exact claim being made.

## 9. Bootstrap validation slices
The initial implementation sequence for these artifact families should be:
1. ingest and validate canonical bundles,
2. ingest and validate adapter capability manifests,
3. pin and validate registry refs,
4. support replay and diff/explain inputs,
5. add witness emission and lifecycle handling after the above are stable.

## 10. Evidence rule
Any runtime feature that claims support for one of the artifact families above must identify:
1. the tracked artifact root,
2. the relevant schema or registry versions,
3. the validator or replay command used to exercise it,
4. the resulting capability or lifecycle outcome.

## Source: `OxReplay/docs/spec/OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md`

# OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md

## 1. Position
This document maps capability levels and replay-governed packs to the first `OxReplay` worksets, replay classes, and evidence roots.

The mappings below are planning bindings.
They are not capability claims by themselves.

## 2. Capability ladder bindings
| Capability level | Minimum workset floor | Required replay classes | Required evidence roots |
|---|---|---|---|
| `C0.ingest_valid` | `W002`, `W003` | `bundle_manifest_valid`, `manifest_shape_valid` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `C1.replay_valid` | `W004` | `oxcalc_intake`, `oxfml_intake`, `shared_replay` | `docs/test-corpus/bundles/`, lane-import roots, `docs/test-runs/` |
| `C2.diff_valid` | `W004`, `W005` | `shared_diff`, `cli_diff` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `C3.explain_valid` | `W005` | `cli_explain` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `C4.distill_valid` | `W006` | `distill_stable`, `distill_unstable`, `quarantine_required`, `lifecycle_transition` | `docs/test-corpus/witnesses/`, `states/lifecycle/`, `docs/test-runs/` |
| `C5.pack_valid` | successor workset beyond `W006` | pack-specific bound set | pack-specific retained evidence roots |

## 3. Pack bindings
| Pack | Required workset floor | Required replay classes | Minimum retained roots |
|---|---|---|---|
| `PACK.replay.appliance` | `W002` through `W005` | `bundle_manifest_valid`, `bundle_manifest_invalid`, `sidecar_resolution`, `manifest_shape_valid`, `capability_claim_matrix`, `shared_replay`, `cli_validate`, `cli_replay`, `cli_adapter_validate`, `pack_export` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `PACK.diff.cross_engine.continuous` | `W004`, `W005` | `shared_diff`, `cli_diff` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `PACK.trace.forensic_plane` | `W006` | `distill_stable`, `lifecycle_transition` | `docs/test-corpus/witnesses/`, `states/lifecycle/`, `docs/test-runs/` |
| `PACK.reject.calculus` | `W006` when reject replay evidence is in scope | `quarantine_required`, reject-bearing `shared_diff` or host explain scenarios | `docs/test-corpus/witnesses/`, `docs/test-runs/` |

## 4. Report-back rule
Every later completion or status report should be able to point from:
1. a capability level,
2. to the governing workset,
3. to the replay class,
4. to the stable scenario id,
5. to the retained artifact root.

## 5. Conservative claim rule
If any link in that chain is missing, the capability or pack reference remains planning-only.

## Source: `OxReplay/docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md`

# OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md

## 1. Position
This document defines how `DNA OneCalc` should consume `OxReplay` as shared replay infrastructure.

It is a local consumer note for a downstream proving host.
It does not redefine Foundation replay doctrine, lane-semantic ownership, or the `DNA ReCalc` host contract.

## 2. Consumer rule
`DNA OneCalc` is a spreadsheet proving host that consumes `OxReplay` for:
1. replay capture,
2. replay validation,
3. diff,
4. explain,
5. witness handling,
6. scenario-library growth,
7. comparison against retained Excel observation artifacts from `OxXlObs`,
8. replay-visible UI state and user controls.

`DNA OneCalc` may:
1. call `OxReplay` library or runtime surfaces directly,
2. emit canonical replay bundles or normalized replay views for executed scenarios,
3. invoke validation, replay, diff, explain, distill, witness-state, or pack-export flows over declared inputs,
4. project those results into its own UI, persistence, and handoff model.

`DNA OneCalc` may not:
1. present itself as `DNA ReCalc`,
2. bypass lane adapters or canonical bundle contracts,
3. claim replay capability beyond retained `OxReplay` evidence,
4. move replay doctrine, registry governance, or witness-lifecycle policy out of Foundation and into the host.

## 3. Relationship to `DNA ReCalc`
`DNA ReCalc` remains the generic replay host surface over `OxReplay`.

The split is:
1. `DNA ReCalc` is the shared replay host and CLI reference surface,
2. `DNA OneCalc` is a separate spreadsheet proving host that embeds or invokes shared replay mechanics,
3. the same `OxReplay` runtime may sit under both hosts without collapsing them into one host identity.

Working rule:
1. if `DNA OneCalc` needs app-facing replay UX, it should build that UX over `OxReplay`,
2. if a generic replay operator surface is needed, `DNA ReCalc` remains the canonical host reference,
3. local `DNA OneCalc` UI affordances must not be described as the `DNA ReCalc` contract.

## 4. Current conservative upstream floor
`DNA OneCalc` should assume only the following current local `OxReplay` floor.

| Source surface | Conservative assumption for `DNA OneCalc` today | Evidence anchors |
|---|---|---|
| `OxFml` | accepted local adapter floor through `C3.explain_valid`; treat `C4` and beyond as later evidence lanes | `docs/test-runs/w003-conformance-oxfml-replay-adapter-v1-baseline/report.json`, `docs/upstream/NOTES_FOR_OXFML.md`, `docs/IN_PROGRESS_FEATURE_WORKLIST.md` |
| `OxFunc` | no accepted local replay-intake floor yet; consume current function semantics through `OxFml` and lane-native contracts rather than assuming direct `OxReplay` capability | `docs/IN_PROGRESS_FEATURE_WORKLIST.md`, `docs/upstream/NOTES_FOR_OXFUNC.md` |
| `OxXlObs` | accepted first-pass observation-source seam: source observation bundle plus canonical `replay.bundle.v1` manifest and first normalized replay view; treat it as a `lossy` observation intake, not as a broad equivalence or formal adapter-capability claim | `docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md`, `docs/test-runs/oxxlobs-seam-xlobs_capture_values_formulae_001-baseline/`, `../OxXlObs/docs/test-runs/W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION.md` |
| `OxVba` | later and narrower lane; no accepted local replay capability floor yet | `docs/IN_PROGRESS_FEATURE_WORKLIST.md`, `docs/upstream/NOTES_FOR_OXVBA.md` |

Important non-dependency note:
1. `OxCalc` remains a seam-reference repo for `DNA OneCalc`,
2. it is not part of the initial `DNA OneCalc` runtime dependency set,
3. the active local `OxCalc` blocker on `C4.distill_valid` does not change that runtime split.

## 5. Artifact use rule
`DNA OneCalc` may keep its own product artifacts such as scenario documents, scenario runs, comparisons, and handoff packets.

When those artifacts rely on `OxReplay`, they should preserve:
1. replay bundle id,
2. source lane id,
3. adapter id and version,
4. source schema lineage,
5. capture mode,
6. projection status,
7. registry refs when present,
8. witness lifecycle state when present,
9. retained artifact refs for replay, diff, explain, or distill outputs.

If an upstream replay surface is explicitly lossy or registry-unpinned, `DNA OneCalc` should surface that explicitly in retained artifacts and UI state rather than hiding it.

## 6. UI and control rule
`DNA OneCalc` may expose:
1. replay capture state,
2. replay validation status,
3. diff and explain results,
4. witness lifecycle and distill controls,
5. scenario-library controls over retained replay evidence.

The UI should make these replay facts visible when they affect interpretation:
1. capability floor actually relied upon,
2. source lane or observation source,
3. capture mode,
4. projection status,
5. capture-loss or downgraded-instrumentation markers,
6. Windows-only availability for live Excel comparison.

Platform rule:
1. retained `OxXlObs` artifacts may be replayed or diffed anywhere `DNA OneCalc` runs,
2. live Excel-backed comparison remains Windows-only because the current live observation path remains Windows-only in `OxXlObs`.

## 7. Scenario-library growth rule
The intended growth path is:
1. author scenario,
2. run scenario,
3. emit retained replay evidence,
4. compare against retained Excel or other replay evidence,
5. explain mismatch,
6. retain witness,
7. emit upstream handoff.

`DNA OneCalc` should treat the replay corpus as provenance-bearing retained evidence, not as disposable UI cache state.

Current caution:
1. the first `OxXlObs` normalized replay view is useful for replay-path activation and coarse comparison wiring,
2. it is not yet the right basis for broad semantic equivalence, formatting-complete parity, or registry-heavy witness claims.

## 8. Current local limits
The following limits remain explicit:
1. this repo still has no app-facing `DNA OneCalc` host contract analogous to `DNA_RECALC_HOST.md`,
2. `OxFunc` has no accepted local direct replay-intake floor yet,
3. `OxVba` has no accepted local replay-intake floor yet,
4. the `OxXlObs` seam still lacks a formal adapter capability manifest and richer registry-pinned diff structure,
5. the current `OxXlObs` replay-facing normalized view remains explicitly `lossy`,
6. broad lane `C4` or `C5` claims remain later evidence lanes unless retained conformance says otherwise.

## 9. Resulting rule
`DNA OneCalc` should use `OxReplay` as shared replay infrastructure, not as a substitute product host, lane semantics owner, or replacement for `DNA ReCalc`.

## Source: `OxReplay/docs/spec/OXREPLAY_INITIAL_ADAPTER_INTAKE_PLAN.md`

# OXREPLAY_INITIAL_ADAPTER_INTAKE_PLAN.md

## 1. Position
This document defines the first adapter-intake plan for `OxCalc`, `OxFml`, and the initial `OxXlObs` observation seam.

It is a local planning companion for `W004`.
It does not redefine lane adapter semantics.
For downstream hosts such as `DNA OneCalc`, read this file as current intake ordering and current evidence floor, not as a host-facing API contract.

## 2. Intake sequence
1. intake `OxCalc` first because Foundation already treats it as the first expected lane toward higher replay capability growth
2. intake `OxFml` second in the same workset, with initial emphasis on ingest/replay/diff/explain rather than distillation
3. prepare the `OxXlObs` seam as an observation-source contract before direct intake begins
4. defer `OxFunc` and `OxVba` to later narrower lanes after the first two lanes have stabilized inside `OxReplay`
5. downstream hosts like `DNA OneCalc` should not read this ordering as permission to assume direct `OxFunc` or `OxVba` replay support before local intake evidence exists

## 3. OxCalc intake expectations
`OxReplay` expects these source surfaces from `OxCalc`:
1. replay-facing scenario ids and replay-class bindings
2. source labels plus normalized event-family projection
3. retained views, reject sets, counters, and diff surfaces
4. adapter capability manifest and registry pin

Current planning scenario:
1. `oxcalc_tracecalc_accept_publish_001`

Current retained source and observations:
1. source anchor: `../OxCalc/docs/test-corpus/core-engine/tracecalc/hand-auditable/tc_accept_publish_001.json`
2. current alias mapping: `tc_accept_publish_001` -> `oxcalc_tracecalc_accept_publish_001`
3. current conformance result in `OxReplay`: manifest loads, but current `cap.C4.distill_valid` claim is rejected locally until lifecycle states are declared

Questions to answer during activation:
1. which retained `TraceCalc` artifacts should be mirrored locally versus referenced remotely
2. whether `engine_diff` is already sufficient for shared diff intake or requires a narrower projection pass
3. which `OxCalc` capability level is honestly claimable at intake time

## 4. OxFml intake expectations
`OxReplay` expects these source surfaces from `OxFml`:
1. typed session, candidate, commit, and reject projections
2. fixture-family import discipline with stable scenario ids
3. adapter capability manifest and registry pin
4. explicit current limits on replay-safe transforms and distillation claims

Current planning scenario:
1. `oxfml_fec_accept_publication_001`

Current retained source and observations:
1. source anchor: `../OxFml/crates/oxfml_core/tests/fixtures/fec_commit_replay_cases.json` with case id `fec_001_accept`
2. current alias mapping: `fec_001_accept` -> `oxfml_fec_accept_publication_001`
3. current conformance result in `OxReplay`: manifest passes the local `C0` through `C3` validator floor and keeps `C4` scaffolded

Questions to answer during activation:
1. which fixture family should act as the first retained shared replay import
2. what the first shared explain surface should consume
3. what remains local-only evidence versus retained shared replay evidence

## 5. Shared intake invariants
1. `OxReplay` consumes declared adapter meaning; it does not reinterpret lane semantics
2. source scenario ids remain authoritative
3. local retained imports must preserve source-lane identity and schema lineage
4. any normative pressure discovered during intake must route back through outbound notes or handoff packets

## 6. OxXlObs seam expectations
`OxReplay` expects these source surfaces from `OxXlObs`:
1. replay-ready observation artifacts rather than opaque automation logs
2. explicit direct-observation versus inference markers
3. Excel build, version, channel, workbook fingerprint, and trigger-recipe provenance
4. capture-loss, downgraded-instrumentation, unavailable-surface, or nondeterminism declarations when applicable
5. either direct canonical replay-bundle emission or a narrow declared observation-contract phase

Reserved first seam classes:
1. `xlobs_manifest_shape_valid`
2. `xlobs_observation_bundle_valid`
3. `xlobs_capture_loss_declared`
4. `xlobs_diff_ready_against_dna`

Acknowledged current emitted shapes from `OxXlObs`:
1. source observation bundle: `../OxXlObs/states/excel/xlobs_capture_values_formulae_001/bundle.json`
2. canonical replay manifest: `../OxXlObs/states/excel/xlobs_capture_values_formulae_001/oxreplay-manifest.json`
3. normalized replay view: `../OxXlObs/states/excel/xlobs_capture_values_formulae_001/views/normalized-replay.json`
4. accepted first-pass seam choices:
   - `lane_id`: `oxxlobs`
   - `capture_mode`: `excel_black_box_observation`
   - `projection_status`: `lossy`
   - `source_schema`: `oxxlobs.replay_bundle_seed.v1`
   - empty `registry_refs` for the first non-claiming intake pass

Questions to answer during activation:
1. what is the first deterministic enough workbook or scenario family for retained comparison
2. which observation surfaces are in the first equality and diff envelope
3. when should a formal adapter manifest be added beyond the accepted canonical-manifest path
4. when should registry pinning begin for retained Excel-origin diff and explain outputs

## 7. Planned outbound observation triggers
Write or update outbound notes if intake discovers:
1. missing adapter manifest fields needed by shared validation
2. missing source identity fields needed by shared replay/explain
3. lane-local naming drift that requires explicit adapter normalization
4. lifecycle or registry requirements that are not yet exposed by the lane repo

Current triggered outbound notes:
1. `NOTES_FOR_OXCALC.md` for the current `C4` lifecycle-state gap and retained alias mapping
2. `NOTES_FOR_OXFML.md` for the retained case-id alias mapping and first shared replay intake expectations
3. `NOTES_FOR_OXXLOBS.md` for the initial observation-to-replay seam expectations

## Source: `OxReplay/docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md`

# OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md

## 1. Position
This document defines the initial `OxReplay` integration seam for `OxXlObs`.

`OxXlObs` is treated as an Excel observation harness and bundle-emission source, not as a semantics-owning lane in the same sense as `OxCalc` or `OxFml`.

## 2. Seam objective
The seam exists so `OxXlObs` can emit replay-ready evidence that `OxReplay` can:
1. ingest and validate,
2. replay and diff against DNA Calc lanes,
3. explain and retain as governed evidence,
4. later distill into minimized witnesses when the capture surface is sufficient.

## 3. Boundary rule
`OxReplay` owns:
1. canonical bundle validation and indexing,
2. normalized replay runtime surfaces,
3. diff, explain, witness, lifecycle, and host mechanics,
4. adapter manifest validation and conformance rules.

`OxXlObs` owns:
1. Excel driving or observation harness behavior,
2. source observation schema truth,
3. declared meaning of Excel-observed fields,
4. capture-loss declarations and uncertainty annotations at the observation boundary.

`OxReplay` must not:
1. drive Excel directly,
2. infer missing observation meaning from partial logs,
3. reinterpret Excel behavior as semantic doctrine,
4. silently discard capture-loss or uncertainty markers emitted by `OxXlObs`.

## 4. Preferred integration shapes
The seam should support these shapes in descending preference:
1. direct canonical replay-bundle emission from `OxXlObs`,
2. `OxXlObs` observation bundles plus a narrow declared adapter projection,
3. plugin-style adapter loading by `DNA ReCalc` if bundle emission is not yet direct.

Preferred rule:
1. emit replay-ready bundles as early as possible,
2. keep Excel-driving specifics outside `OxReplay`,
3. use adapter manifests only for declared projection and capability boundaries.

Current acknowledged model from `OxXlObs`:
1. a rich `OxXlObs` observation bundle remains the source-observation contract,
2. an `OxReplay`-canonical `replay.bundle.v1` manifest is emitted as the replay-facing intake artifact over that richer bundle,
3. a normalized replay view may be emitted as a first-pass lossy projection for ingest and replay-path activation.

## 5. Required preserved provenance
For `OxXlObs`-originating retained artifacts, `OxReplay` should expect preserved fields for:
1. source repo or adapter identity,
2. observation source kind `excel`,
3. Excel product surface where relevant, such as desktop or automation path,
4. Excel build, version, and channel when available,
5. host environment facts needed for reproducibility,
6. workbook or input fingerprint,
7. scenario id or observation run id,
8. trigger recipe or action sequence,
9. calculation mode and relevant host settings when observable,
10. observed surface inventory such as values, formulas, errors, or timing envelopes,
11. capture-loss, downgraded-instrumentation, unavailable-surface, or nondeterminism markers,
12. registry and lifecycle pinning when the evidence is retained.

## 6. Observation-specific contract expectations
The first `OxXlObs` handoff into `OxReplay` should make these surfaces explicit:
1. what was directly observed versus inferred,
2. which workbook surfaces are in scope for equality or diff checks,
3. which host settings materially affect reproducibility,
4. which surfaces are intentionally omitted from the first pass,
5. what counts as deterministic enough for retained replay evidence,
6. how capture-loss is encoded when Excel does not expose a surface.

## 7. Initial retained acceptance packet
The first useful `OxXlObs` delivery into `OxReplay` should include:
1. one adapter manifest or equivalent declared observation contract,
2. one minimal valid observation bundle seed,
3. one deliberately capture-incomplete or downgraded observation example,
4. one differential comparison-ready scenario against a DNA Calc lane,
5. explicit source ids and retained scenario aliases if aliasing is required.

## 8. First replay classes reserved for `OxXlObs`
The initial reserved replay classes for `OxXlObs` intake are:
1. `xlobs_manifest_shape_valid`
2. `xlobs_observation_bundle_valid`
3. `xlobs_capture_loss_declared`
4. `xlobs_diff_ready_against_dna`

These are reserved planning classes only until retained artifacts exist.

## 9. Processed response status
`OxReplay` has now locally validated the first acknowledged `OxXlObs` intake artifacts:
1. canonical manifest: `../OxXlObs/states/excel/xlobs_capture_values_formulae_001/oxreplay-manifest.json`
2. normalized replay view: `../OxXlObs/states/excel/xlobs_capture_values_formulae_001/views/normalized-replay.json`

Accepted first-pass seam answers:
1. `lane_id = oxxlobs` is acceptable as an observation-source intake id and does not imply semantic ownership of Excel behavior
2. `projection_status = lossy` is the right first-pass declaration for the current normalized replay view
3. an empty `registry_refs` list is acceptable for the first intake pass while no registry-dependent capability claim is being made
4. the direct canonical-manifest path is acceptable without an immediate formal adapter manifest; a formal adapter manifest becomes useful when the projection surface or capability claim surface broadens
5. encoding observed values into normalized replay-family strings is acceptable only as a bootstrap activation surface, not as the long-term shared diff contract

Still provisional:
1. the first Excel-vs-DNA comparison-ready scenario is not yet retained inside `OxReplay`
2. value-sensitive differential structure should widen beyond string-encoded normalized families before broad equivalence claims are made
3. registry pinning should be added once emitted outputs depend on canonical mismatch, severity, capability, or lifecycle families

## 10. `DNA OneCalc` comparison use
`DNA OneCalc` may consume retained `OxXlObs` artifacts through `OxReplay` for:
1. replay against retained Excel observation artifacts,
2. diff and explain over retained observation inputs,
3. witness creation and scenario-library growth,
4. replay-visible comparison controls in its own UI.

Current consumer rule:
1. `DNA OneCalc` should treat the current `OxXlObs` replay-facing normalized view as a first-pass observation projection,
2. it should not treat that projection as broad semantic equivalence truth,
3. it must keep source observation identity, projection status, and capture-loss visible when those affect interpretation.

Platform rule:
1. live Excel-backed comparison remains Windows-only because the current live `OxXlObs` capture path remains Windows-only,
2. non-Windows hosts may still replay, diff, and explain retained `OxXlObs` artifacts through `OxReplay`.

## 11. Resulting rule
The `OxXlObs` seam is ready when `OxXlObs` can hand `OxReplay` declared, provenance-rich, replay-ready observation artifacts without forcing `OxReplay` to absorb Excel-driving logic or semantic ownership.

## Source: `OxReplay/docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md`

# OXREPLAY_SCOPE_AND_BOUNDARY.md

## 1. Position
This document defines what `OxReplay` is allowed to own and what it must leave to Foundation and the lane repos.

## 2. Repo purpose
`OxReplay` is the shared implementation substrate for the Replay appliance.

It exists to provide reusable mechanics for:
1. bundle validation and indexing,
2. normalized replay runtime surfaces,
3. diff and explain execution,
4. witness distillation,
5. registry and lifecycle tooling,
6. adapter capability validation,
7. `DNA ReCalc`,
8. downstream host consumption through declared shared-runtime surfaces.

## 3. In scope
1. Shared replay abstractions and runtime types.
2. Bundle parsing, serialization, validation, and indexing.
3. Replay execution over canonical bundles.
4. Shared mismatch, explain, and reduction runtime surfaces.
5. Registry snapshot handling and witness lifecycle mechanics.
6. Adapter SDK, loader, and conformance harnesses.
7. Pack-facing export mechanics for replay-governed packs.
8. Shared runtime surfaces that a non-`DNA ReCalc` host may embed or invoke without taking semantic ownership.

## 4. Out of scope
1. Semantic ownership of evaluator, function, coordinator, or VBA behavior.
2. Lane-local event-family truth.
3. Lane-local reject taxonomy authority.
4. Lane-local safe-rewrite policy for distillation.
5. Spreadsheet product-host behavior outside replay-host concerns.

## 5. Ownership split
1. Foundation owns doctrine and governance.
2. Lane repos own semantic meaning.
3. `OxReplay` owns shared runtime mechanics.
4. `DNA ReCalc` is the generic host surface over those mechanics.
5. Downstream product hosts may consume those mechanics, but they remain separate hosts with their own UI, persistence, and orchestration policy.

## 6. Non-`DNA ReCalc` host consumer rule
A downstream spreadsheet proving host such as `DNA OneCalc` may:
1. call `OxReplay` libraries or runtime services directly,
2. emit canonical replay artifacts over its own scenarios or retained comparisons,
3. surface replay, diff, explain, witness, and scenario-library controls in its own UI.

It may not:
1. redefine itself as `DNA ReCalc`,
2. bypass adapters or canonical bundle contracts,
3. move replay doctrine or witness-governance authority out of Foundation,
4. use shared-runtime convenience to absorb lane-semantic meaning.

## 7. Module boundary model
The intended initial module split is:
1. `Abstractions`
2. `Bundle`
3. `Core`
4. `Diff`
5. `Explain`
6. `Distill`
7. `Governance`
8. `Conformance`
9. `DNA ReCalc`

This split is a starting model, not a frozen package map.

## 8. Dependency constitution
Allowed:
1. dependence on shared schemas and local abstractions,
2. adapter loading through declared contracts,
3. lane-provided fixtures or plugins for conformance.

Forbidden without explicit override:
1. importing lane-semantic internals into shared runtime interpretation,
2. turning adapter helpers into semantic-core dependencies,
3. letting `DNA ReCalc` become the semantic authority instead of the replay host,
4. letting a downstream product host bypass shared replay contracts by linking directly to lane-semantic internals.

## 9. First bootstrap goals
1. Stand up bundle and schema validation.
2. Validate adapter capability manifests.
3. Load and exercise initial `OxCalc` and `OxFml` adapters.
4. Prove the first shared diff and explain flows.
5. Delay broader extraction until the shared surface is empirically stable.

## Source: `OxReplay/docs/spec/OXREPLAY_WITNESS_LIFECYCLE_TRANSITIONS.md`

# OXREPLAY_WITNESS_LIFECYCLE_TRANSITIONS.md

## 1. Position
This document defines the initial witness lifecycle transition model used by `W006`.

It is a local operational companion to Foundation lifecycle doctrine.

## 2. Lifecycle states
The initial governed states are:
1. `explanatory-only`
2. `retained-local`
3. `retained-shared`
4. `promoted-pack`
5. `superseded`
6. `quarantined`
7. `gc-eligible`

## 3. Transition floor
Allowed baseline transitions are:
1. `explanatory-only -> quarantined`
2. `explanatory-only -> retained-local`
3. `retained-local -> retained-shared`
4. `retained-local -> superseded`
5. `retained-local -> quarantined`
6. `retained-shared -> promoted-pack`
7. `retained-shared -> superseded`
8. `retained-shared -> quarantined`
9. `quarantined -> retained-local` when the quarantine reason is cleared by fresh evidence
10. `superseded -> gc-eligible`

## 4. Forbidden transitions
1. `explanatory-only -> promoted-pack`
2. `quarantined -> promoted-pack`
3. any transition that drops supersession lineage
4. any transition that removes quarantine reason history silently

## 5. Quarantine reasons
The initial structured reasons are:
1. `unstable_oracle_or_predicate`
2. `insufficient_capture`
3. `missing_source_artifacts`
4. `adapter_failure`
5. `schema_incompatibility`

## 6. Required retained fields
Lifecycle records should retain:
1. witness id
2. source lane
3. source scenario id
4. current lifecycle state
5. quarantine reason when present
6. supersession lineage when present
7. pack-eligibility state

## 7. Artifact roots
Baseline retained roots are:
1. `docs/test-corpus/witnesses/`
2. `states/lifecycle/`
3. `docs/test-runs/`

## 8. Working rule
Lifecycle state governs retention, promotion, quarantine, and GC policy.
It never rewrites the semantic meaning of the source witness artifact.

## Source: `OxReplay/docs/spec/README.md`

# OxReplay Spec Index

This directory is the OxReplay-owned mutable spec set after bootstrap.

## Canonical local spec ownership
1. `docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md`
2. `docs/spec/OXREPLAY_RUNTIME_STRATA_AND_PACKAGE_MAP.md`
3. `docs/spec/OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md`
4. `docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`
5. `docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md`
6. `docs/spec/DNA_RECALC_HOST.md`
7. `docs/spec/OXREPLAY_IMPLEMENTATION_BASELINE.md`
8. `docs/spec/OXREPLAY_REPLAY_CLASS_AND_SCENARIO_REGISTER.md`
9. `docs/spec/OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md`
10. `docs/spec/OXREPLAY_INITIAL_ADAPTER_INTAKE_PLAN.md`
11. `docs/spec/DNA_RECALC_CLI_CONTRACT.md`
12. `docs/spec/OXREPLAY_WITNESS_LIFECYCLE_TRANSITIONS.md`
13. `docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md`

## Consumed doctrine
Foundation remains higher-precedence doctrine owner for:
1. Replay architecture and governance,
2. pack and promotion rules,
3. repo and host topology,
4. lifecycle and registry policy.

Primary Foundation references:
1. `../../../Foundation/REPLAY_APPLIANCE.md`
2. `../../../Foundation/CHARTER.md`
3. `../../../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
4. `../../../Foundation/OPERATIONS.md`

## Lane reference rule
Lane repos remain the source for lane-native adapter meaning and semantics-specific trace details.

## Mirror policy
This repo may restate implementation-boundary detail, but may not create local doctrine that conflicts with Foundation or reassigns lane ownership.

## Consumer note
Use `docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md` when the downstream consumer is a non-`DNA ReCalc` host such as `DNA OneCalc`.

## Bootstrap reading path
For initial `OxReplay` work, read in this order after the repo root docs:
1. `docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md`
2. `docs/spec/OXREPLAY_RUNTIME_STRATA_AND_PACKAGE_MAP.md`
3. `docs/spec/OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md`
4. `docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`
5. `docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md`
6. `docs/spec/DNA_RECALC_HOST.md`
7. `docs/spec/OXREPLAY_IMPLEMENTATION_BASELINE.md`
8. `docs/spec/OXREPLAY_REPLAY_CLASS_AND_SCENARIO_REGISTER.md`
9. `docs/spec/OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md`
10. `docs/spec/OXREPLAY_INITIAL_ADAPTER_INTAKE_PLAN.md`
11. `docs/spec/DNA_RECALC_CLI_CONTRACT.md`
12. `docs/spec/OXREPLAY_WITNESS_LIFECYCLE_TRANSITIONS.md`
13. `docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md`

