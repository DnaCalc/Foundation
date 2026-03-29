# Foundation Replay Appliance Promotion Plan

## 1. Position
This document plans how the Replay appliance research outputs should be promoted into Foundation source-of-truth documents.

It is a planning artifact, not doctrine.

The plan is intentionally Foundation-scoped:
- promote cross-program replay doctrine, architecture, operations, and rollout policy into Foundation,
- keep lane-owned replay semantics in the sibling `Ox*` repos,
- keep lane addenda and rollout prompts as handoff artifacts, not Foundation doctrine mirrors.

## 2. Governing rules for promotion
The promotion pass should obey the existing Foundation doctrine:

1. document precedence remains:
   - `CHARTER.md`
   - `ARCHITECTURE_AND_REQUIREMENTS.md`
   - `OPERATIONS.md`
   - supporting notes
2. Foundation may define cross-lane replay contracts and governance, but may not take ownership of lane-native semantics from `OxFunc`, `OxFml`, `OxCalc`, or `OxVba`,
3. detailed policy should live in the most specific Foundation document practical, with brief anchors in `README.md`,
4. the Replay appliance remains the cross-lane concept, `OxReplay` is the intended shared replay repo and library family, and `DNA ReCalc` is the intended CLI, UI, and replay-host surface,
5. no Foundation update should duplicate lane-local event taxonomies, reduction rules, or artifact schemas unless those are explicitly elevated to cross-lane canonical status.

## 3. Promotion model
The cleanest Foundation update model is a two-layer promotion:

### 3.1 Layer 1: Anchor the concept in the main source-of-truth docs
Update:
- `CHARTER.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `OPERATIONS.md`
- `README.md`

These edits should establish:
- why Replay exists,
- what architectural boundary it occupies,
- what operational governance it requires,
- where detailed Replay doctrine lives.

### 3.2 Layer 2: Create one dedicated Foundation replay document
Create:
- `REPLAY_APPLIANCE.md`

This new file should become the detailed Foundation home for:
- Replay appliance scope and boundary,
- normalized replay architecture,
- bundle and adapter contracts,
- witness distillation,
- capability manifests,
- canonical registries,
- witness lifecycle and quarantine policy,
- rollout phases and adoption targets,
- schema and compatibility evolution policy.

This is the most specific home for detailed replay policy and prevents `ARCHITECTURE_AND_REQUIREMENTS.md` and `OPERATIONS.md` from absorbing too much low-level detail.

### 3.3 Why a dedicated file is the best option
Without a dedicated file, the required replay material becomes too large and too specific for the current top-level docs.

With a dedicated file:
- `CHARTER.md` stays doctrinal,
- `ARCHITECTURE_AND_REQUIREMENTS.md` stays architectural,
- `OPERATIONS.md` stays operational,
- the Replay appliance gets one stable detailed home,
- future replay changes do not require repeated large edits across the entire Foundation doc stack.

## 4. Source material to promote

| Research output | Promotion target | Promotion rule |
|---|---|---|
| `02_replay_appliance_motivation_charter_requirements.md` | `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `REPLAY_APPLIANCE.md` | promote motivation, charter, requirements, and constraints; do not copy requirement numbering wholesale into `CHARTER.md` |
| `03_replay_appliance_architecture.md` | `ARCHITECTURE_AND_REQUIREMENTS.md`, `REPLAY_APPLIANCE.md` | promote architectural layers, boundary rules, and canonical object framing; keep detailed object shapes in `REPLAY_APPLIANCE.md` |
| `04_replay_appliance_performance_sensitive_design.md` | `ARCHITECTURE_AND_REQUIREMENTS.md`, `REPLAY_APPLIANCE.md`, `OPERATIONS.md` | promote hot-path and offline-distillation rules; keep tuning detail out of `CHARTER.md` |
| `05_dna_recalc_tool_proposal.md` | `REPLAY_APPLIANCE.md`, `OPERATIONS.md` | promote tool role, `OxReplay`/`DNA ReCalc` split, and rollout phases; keep command examples subordinate |
| `10_witness_distillation_and_counterexample_reduction.md` | `REPLAY_APPLIANCE.md`, `OPERATIONS.md` | promote witness-distillation architecture and policy; keep lane-local rewrite rules out |
| `11_adapter_conformance_and_capability_matrix.md` | `OPERATIONS.md`, `REPLAY_APPLIANCE.md` | promote shared capability model and conformance evidence rules |
| `12_predicate_mismatch_and_status_registry.md` | `REPLAY_APPLIANCE.md`, `OPERATIONS.md` | promote registry families and governance; keep full tables in the dedicated replay doc |
| `13_witness_lifecycle_retention_and_quarantine_policy.md` | `OPERATIONS.md`, `REPLAY_APPLIANCE.md` | promote lifecycle and quarantine governance with pack/promotion impact |
| `06_oxcalc_addendum.md` to `09_oxvba_addendum.md` | no direct Foundation promotion | remain lane handoff documents |
| `14_prompt_oxfml_replay_appliance_rollout.md` to `17_prompt_oxvba_replay_appliance_rollout.md` | no direct Foundation promotion | remain repo-local rollout prompts |
| `19_oxreplay_repo_scope_and_model.md` | `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `REPLAY_APPLIANCE.md`, `README.md` | promote repo and host topology, ownership boundary, and dependency-constitution implications |

## 5. Foundation document-by-document plan

### 5.1 `CHARTER.md`
Purpose of update:
- establish Replay as doctrine-supported program behavior,
- keep changes short and high-level,
- avoid schema, CLI, or lane-specific detail.

Planned edits:
1. strengthen Hygiene Doctrine item `4. Regressions are assets` so that the normalized expectation becomes:
   - bugs should become replayable witnesses,
   - minimized witnesses are preferred end-state,
   - replay artifacts remain part of the durable corpus.
2. tighten Hygiene Doctrine item `5. Determinism-first debugging` so it explicitly includes:
   - deterministic replay,
   - deterministic diff/explain,
   - explicit handling of nondeterministic or quarantined cases.
3. extend the Foundation bullet in `3.2 Component Repos` so Foundation is clearly the owner of:
   - replay doctrine,
   - cross-lane replay governance,
   - conformance policy for Replay adapters and witness promotion.
4. add an `OxReplay` bullet in `3.2 Component Repos` that states:
   - it is the shared replay implementation repo and library family,
   - it is not a semantics lane,
   - `DNA ReCalc` is the replay host surface built from it.
5. add short glossary entries for:
   - `Replay appliance`,
   - `Replay witness`,
   - `Replay adapter capability manifest`,
   - `DNA ReCalc` as the replay host surface if a glossary entry is useful.

What must not be added here:
- bundle layout,
- registry tables,
- lifecycle states,
- tool commands,
- lane rollout specifics.

Acceptance check:
- `CHARTER.md` clearly explains why Replay matters without becoming an implementation spec.

### 5.2 `ARCHITECTURE_AND_REQUIREMENTS.md`
Purpose of update:
- define Replay as a first-class architectural plane,
- bind it to existing constraints such as deterministic replay and forensic trace obligations,
- preserve lane boundaries.

Recommended structural changes:
1. add a new architectural subsection after `3.20 Program Repo and Host Mapping`:
   - `3.21 Replay Appliance`
2. update `3.20 Program Repo and Host Mapping` to include:
   - `OxReplay` as the shared replay implementation repo,
   - `DNA ReCalc` as the replay host surface distinct from the spreadsheet host progression.
3. add new architecture-level constraints after `CONSTR-027`.
4. add one or two `INT/REAL` examples if useful, but only if they materially sharpen the architecture contract.

Planned content for new section `3.21 Replay Appliance`:
- architectural thesis:
  - Replay is a cross-lane causality, replay, diff, explain, and witness-distillation plane,
  - it is owned by Foundation at the cross-program level and implemented through lane adapters,
  - lane-native semantics remain owned by the lane repos.
- normalized layers:
  - lane-native capture,
  - lane adapter,
  - normalized replay model,
  - portable bundle packaging,
  - shared tool surface.
- architectural boundary rule:
  - Replay may normalize lane artifacts for cross-program use,
  - Replay may not redefine lane-owned semantics.
- tool role:
  - shared validator / normalizer / replay / diff / explain / distill / pack export surfaces exist,
  - `OxReplay` is the intended shared implementation home,
  - `DNA ReCalc` is the intended replay host surface,
  - the architecture should still treat the appliance concept as primary.
- pack integration:
  - Replay serves `PACK.replay.appliance`,
  - Replay feeds `PACK.trace.forensic_plane`,
  - Replay feeds `PACK.diff.cross_engine.continuous`.
- performance rule:
  - capture is performance-sensitive and should avoid hot-path collapse,
  - distillation is offline and closure-aware.

Planned new constraints:
- `CONSTR-028`: Replay is a cross-lane adapter-mediated plane; lane-native semantics remain lane-owned.
- `CONSTR-029`: Required Replay bundles must preserve source identity, capture loss, and schema versions explicitly.
- `CONSTR-030`: Replay outputs must use canonical registry ids when a registry family exists.
- `CONSTR-031`: Adapter capability claims must be machine-readable and conformance-validated before downstream reliance.
- `CONSTR-032`: Witness lifecycle, quarantine, and pack eligibility must be explicit and machine-readable.
- `CONSTR-033`: Distillation must be offline, replay-closed, and must fail explicitly when predicates or capture are unstable.
- `CONSTR-034`: Replay bundle, adapter, and registry evolution must classify additive, tightening, breaking, experimental, deprecated, and removed changes.
- `CONSTR-035`: Shared replay implementation may be centralized in `OxReplay`, but lane-native semantics and adapter meaning remain lane-owned.

Potential `INT/REAL` addition:
- `INT`: regressions should become reusable evidence, not disposable incidents.
- `REAL`: required profiles emit replay bundles, forensic traces, and reduced witnesses or explicit quarantine records where reduction is not yet valid.

What should stay out of this document:
- full canonical object schemas,
- full registry enumerations,
- lane-specific event-family mappings,
- detailed command surface examples.

Acceptance check:
- `ARCHITECTURE_AND_REQUIREMENTS.md` explains the Replay appliance as part of the system architecture and sharpens the constraint surface around the existing `CONSTR-024`.

### 5.3 `OPERATIONS.md`
Purpose of update:
- make Replay operationally real,
- define how adapters, witnesses, packs, and promotion packets are handled,
- bind rollout sequencing to existing Wave logic without distorting lane ownership.

Recommended structural changes:
1. expand `4.3 Pack Contract Discipline`,
2. update `7.2 Program Repo and Host Layout Baseline` to include `OxReplay` as the shared replay/tooling repo,
3. update `8.14 Dependency Constitution and Theory-to-Pack Mapping` to include `OxReplay` dependency rules,
4. add a new replay-governance subsection under Section `8`,
5. add a replay rollout subsection near Section `10.3 Sequence Baseline`.

Planned edits in `4.3 Pack Contract Discipline`:
- specify minimum contract expectations for:
  - `PACK.replay.appliance`,
  - `PACK.trace.forensic_plane`,
  - `PACK.diff.cross_engine.continuous`,
  - `PACK.reject.calculus` where replay evidence depends on reject-class stability.
- require emitted artifacts such as:
  - replay bundles,
  - adapter capability manifests,
  - registry version refs,
  - witness lifecycle records,
  - reduced witnesses or explicit quarantine records.

Planned new operational subsection under Section `8`:
- recommended section title:
  - `8.17 Replay Appliance Governance (Normative)`
- recommended contents:
  - adapter capability levels `C0` through `C5`,
  - capability-manifest publication rules,
  - conformance evidence expectations per level,
  - canonical registry governance,
  - witness lifecycle and quarantine policy,
  - `OxReplay` and lane-adapter ownership boundaries,
  - promotion-packet requirements for replay doctrine changes,
  - schema and compatibility evolution policy.

Planned rollout subsection near Section `10.3`:
- recommended section title:
  - `10.4 Replay Appliance Rollout Baseline`
- recommended contents:
  - Replay appliance promotion is a Logistics-owned cross-wave substrate, not a lane replacement,
  - Foundation doctrine promotion comes first,
  - `OxReplay` is the shared implementation target after the first adapter surfaces are proved,
  - `DNA ReCalc` is the shared replay host surface over `OxReplay`,
  - `OxCalc` is the first lane expected to drive toward `C5.pack_valid`,
  - `OxFml` follows with early capability target through explain and later distillation,
  - `OxFunc` and `OxVba` follow with narrower early scopes,
  - no pack or host downstream claim may rely on adapter capabilities that are not yet declared and evidenced.

Operational rules that should be promoted:
- reduced witnesses are not automatically pack-eligible,
- quarantined witnesses remain visible to triage but block promotion,
- registry versions must be pinned in relevant artifacts,
- Replay-related Foundation promotion requires managed-run promotion packets,
- host claims relying on Replay must name the required capability level.

What should stay out of `OPERATIONS.md`:
- full registry tables,
- full canonical object schemas,
- lane-local reduction grammars,
- detailed lane addenda copied from the research run.

Acceptance check:
- `OPERATIONS.md` becomes sufficient to govern Replay rollout and promotion without duplicating the detailed spec.

### 5.4 `README.md`
Purpose of update:
- make the new Replay guidance discoverable,
- keep the repo entrypoint short.

Planned edits:
1. add one short current-phase note that Replay appliance doctrine promotion is now part of the Foundation logistics scope from Wave B onward,
2. add a pointer to `REPLAY_APPLIANCE.md` once it exists,
3. clarify that Replay appliance doctrine is Foundation-owned but lane-native replay semantics remain in sibling repos,
4. add a short note that `OxReplay` is the intended shared replay implementation repo and `DNA ReCalc` is the replay host surface.

Acceptance check:
- a new contributor can find the detailed Replay policy from `README.md` without reading the research run first.

### 5.5 `REPLAY_APPLIANCE.md` (new)
Purpose of update:
- hold the detailed normalized Replay doctrine that is too specific for the top-level docs,
- serve as the stable source for future replay-focused work in Foundation.

Recommended structure:
1. position, scope, and precedence,
2. motivation and charter,
3. cross-lane architectural thesis,
4. normalized architectural layers,
5. canonical replay objects and bundle layout,
6. event families and source-preservation rule,
7. replay / diff / explain architecture,
8. witness distillation and counterexample reduction,
9. performance-sensitive capture and offline normalization design,
10. adapter capability manifest and conformance matrix,
11. canonical registries and version governance,
12. witness lifecycle, quarantine, retention, and supersession,
13. pack integration and promotion policy,
14. `OxReplay` repo scope, adapter ownership model, and `DNA ReCalc` host split,
15. rollout order and lane expectations,
16. schema and compatibility evolution policy,
17. explicit non-goals and lane-owned details that remain outside Foundation.

Inputs:
- primary from outputs `02`, `03`, `04`, `10`, `11`, `12`, `13`,
- selective tool/rollout material from `05`,
- repo-topology material from `19`.

Explicit non-goals:
- it should not become a mirror of `06` to `09`,
- it should not embed repo-specific prompts,
- it should not rename lane-local artifact vocabularies unless those are promoted to cross-lane canonical registries.

Acceptance check:
- future Replay-specific Foundation work can target this file directly instead of repeatedly re-reading the research run set.

### 5.6 `AGENTS.md` (optional but recommended)
Purpose of update:
- if `REPLAY_APPLIANCE.md` is created, agents should load it when the task is replay-specific.

Minimal edit:
- under context-loading doctrine, add a replay-specific rule:
  - for Replay appliance architecture, governance, or rollout work, read `REPLAY_APPLIANCE.md` after the core source-of-truth docs.

Reason this is optional:
- it changes agent operating instructions,
- it should only be done once `REPLAY_APPLIANCE.md` exists and is stable enough to be worth loading by default for replay work.

### 5.7 `notes/RESEARCH_NOTES.md` and `notes/THEORY_TO_PACK_REGISTER.md` (follow-on alignment)
Purpose of update:
- retain the research lineage and make the pack mapping explicit.

Planned edits:
1. `notes/RESEARCH_NOTES.md`
   - add a short synthesized note that the Replay appliance research run has been promoted and where the doctrine now lives.
2. `notes/THEORY_TO_PACK_REGISTER.md`
   - add or update mappings for:
     - deterministic replay obligations,
     - forensic trace obligations,
     - witness distillation obligations,
     - adapter capability evidence obligations,
     - lifecycle and quarantine obligations.

Reason these are follow-on rather than first edits:
- the main doctrinal/architectural/operational promotion should happen first,
- then the notes/register can point to the stabilized Foundation text rather than to the research run alone.

## 6. What should not be promoted yet
The Foundation promotion pass should explicitly defer these items:

1. lane-specific addenda in outputs `06` to `09`,
2. repo rollout prompt files in outputs `14` to `17`,
3. detailed lane event-family mappings,
4. lane-local reduction rewrite permissions,
5. detailed `OxReplay` package or assembly layout as if already frozen,
6. full command-line surface commitments for every future `DNA ReCalc` mode beyond the currently proposed family,
7. any pack-level threshold values that have not yet been calibrated by pack owners.

## 7. Work sets for the Foundation update pass

### WS-FDN-RA-001: Create the detailed Foundation replay spec
Scope:
- create `REPLAY_APPLIANCE.md`
- consolidate the replay research into one detailed Foundation document

Inputs:
- outputs `02`, `03`, `04`, `05`, `10`, `11`, `12`, `13`, `19`

Deliverable:
- first complete draft of `REPLAY_APPLIANCE.md`

Done when:
- the file exists,
- it states scope and precedence clearly,
- it covers architecture, distillation, registries, capability, and lifecycle at usable detail.

### WS-FDN-RA-002: Patch `CHARTER.md`
Scope:
- short doctrine-only changes

Dependencies:
- none beyond the current plan

Done when:
- Replay is visible in doctrine and glossary form without low-level bleed.

### WS-FDN-RA-003: Patch `ARCHITECTURE_AND_REQUIREMENTS.md`
Scope:
- add architectural section and constraints
- update repo and host mapping for `OxReplay` and `DNA ReCalc`

Dependencies:
- should be aligned with the new `REPLAY_APPLIANCE.md` structure

Done when:
- Replay is represented as an architectural plane and linked to explicit constraints.

### WS-FDN-RA-004: Patch `OPERATIONS.md`
Scope:
- add pack contract detail, governance rules, rollout baseline, and dependency-constitution updates for `OxReplay`

Dependencies:
- should follow the capability, registry, and lifecycle sections in `REPLAY_APPLIANCE.md`

Done when:
- operational governance for Replay is explicit enough to support lane rollout and promotion packets.

### WS-FDN-RA-005: Patch `README.md`
Scope:
- add discoverability and current-phase pointer

Dependencies:
- `REPLAY_APPLIANCE.md` should already exist

Done when:
- `README.md` points new readers to the detailed Replay spec directly.

### WS-FDN-RA-006: Align support docs
Scope:
- optional `AGENTS.md`,
- follow-on `notes/RESEARCH_NOTES.md`,
- follow-on `notes/THEORY_TO_PACK_REGISTER.md`

Dependencies:
- main doctrine promotion complete

Done when:
- replay-specific work has stable load guidance and theory-to-pack mapping.

### WS-FDN-RA-007: Coherence verification
Scope:
- final consistency and no-conflict pass across Foundation docs

Checks:
- lane ownership language remains consistent everywhere,
- `Replay appliance` terminology is used consistently,
- `OxReplay` and `DNA ReCalc` roles are used consistently everywhere,
- `CONSTR-024` and the new Replay constraints do not conflict,
- operational rules in `OPERATIONS.md` match the detailed policy in `REPLAY_APPLIANCE.md`,
- no Foundation doc accidentally mirrors lane-local semantics.

Done when:
- the Foundation stack reads as one coherent replay doctrine instead of a stitched research import.

## 8. Suggested execution sequence
Use this order for the actual document-edit pass:

1. create `REPLAY_APPLIANCE.md`,
2. patch `CHARTER.md`,
3. patch `ARCHITECTURE_AND_REQUIREMENTS.md`,
4. patch `OPERATIONS.md`,
5. patch `README.md`,
6. patch optional/supporting files,
7. run a final coherence review across the full Foundation stack.

This sequence keeps the detailed source available before the high-level docs point at it.

## 9. Key open decisions to settle during the edit pass
These decisions do not block planning, but they should be settled before the final promotion patch is merged:

1. whether `DNA ReCalc` is mentioned in `ARCHITECTURE_AND_REQUIREMENTS.md` at all, or only in `REPLAY_APPLIANCE.md`,
2. whether `CHARTER.md` should list `DNA ReCalc` explicitly or only mention `OxReplay` and leave the host name to replay-specific docs,
3. whether `AGENTS.md` should be updated immediately or only after one promotion cycle proves the replay doc is stable,
4. whether the registry tables should live entirely in `REPLAY_APPLIANCE.md` or partly in an appendix file if they grow quickly,
5. whether the rollout baseline in `OPERATIONS.md` should be a dedicated new section `10.4` or a short addition inside `10.3`,
6. whether witness-lifecycle detail in `OPERATIONS.md` should be concise summary only or moderately detailed operational text.

## 10. Resulting recommendation
The best Foundation update path is:

1. create one dedicated detailed replay doc in Foundation,
2. anchor Replay doctrine and the `OxReplay` role in `CHARTER.md`,
3. anchor Replay architecture, `OxReplay`, and `DNA ReCalc` boundaries in `ARCHITECTURE_AND_REQUIREMENTS.md`,
4. anchor Replay governance, dependency rules, and rollout in `OPERATIONS.md`,
5. use `README.md` as the pointer layer,
6. leave lane-specific replay details in the sibling repos and their handoff artifacts.

That gives Foundation a coherent Replay appliance doctrine without collapsing lane ownership or forcing the main docs to carry every schema and workflow detail directly.
