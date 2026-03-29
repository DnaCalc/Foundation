# OxXlObs Reference

This document consolidates the current DNA OneCalc-relevant reference set from `OxXlObs`.

Repo role: Windows Excel observation, provenance-rich capture, replay-ready observation bundle emission, and retained Excel-side scenario evidence.

Included source documents:
- `OxXlObs/CHARTER.md`
- `OxXlObs/CURRENT_BLOCKERS.md`
- `OxXlObs/docs/IN_PROGRESS_FEATURE_WORKLIST.md`
- `OxXlObs/docs/spec/OXXLOBS_ARCHITECTURE_AND_CAPTURE_MODEL.md`
- `OxXlObs/docs/spec/OXXLOBS_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`
- `OxXlObs/docs/spec/OXXLOBS_CAPABILITY_AND_PACK_TRACEABILITY.md`
- `OxXlObs/docs/spec/OXXLOBS_CLI_CONTRACT.md`
- `OxXlObs/docs/spec/OXXLOBS_ENVIRONMENT_AND_PROVENANCE_MODEL.md`
- `OxXlObs/docs/spec/OXXLOBS_IMPLEMENTATION_BASELINE.md`
- `OxXlObs/docs/spec/OXXLOBS_SCENARIO_REGISTER.md`
- `OxXlObs/docs/spec/OXXLOBS_SCOPE_AND_BOUNDARY.md`
- `OxXlObs/docs/spec/README.md`
- `OxXlObs/docs/test-runs/W006_STABLE_WINDOWS_EXECUTION_DRIVER.md`
- `OxXlObs/docs/test-runs/W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION.md`
- `OxXlObs/README.md`

The sources are reproduced below in full so the pack remains self-contained even after flattening.

## Source: `OxXlObs/CHARTER.md`

# CHARTER.md — OxXlObs Charter

## 1. Mission
OxXlObs defines, implements, and proves the Excel observation harness for DNA Calc.

It owns the reusable observation substrate for scenario planning, Excel-run fingerprinting, observable-surface capture, lossiness reporting, replay-ready bundle emission, and differential witness seeding while preserving Foundation and lane ownership of semantics and replay governance.

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
1. Scenario declarations for reproducible Excel observation runs.
2. Workbook, environment, Excel-build, and trigger fingerprint capture.
3. Stable capture of observable values, formulas, diagnostics, and other declared surfaces.
4. Lossiness and uncertainty labeling for every retained observation artifact.
5. Compilation of canonical replay-ready bundles and bundle sidecars for `OxReplay`.
6. Differential witness seeding for Excel-vs-DNA investigation.

Out of scope:
1. Semantic ownership of Excel behavior.
2. Replay doctrine, lifecycle governance, or pack policy authority.
3. Lane-local semantic interpretation for `OxFunc`, `OxFml`, `OxCalc`, or `OxVba`.
4. Generic Office automation unrelated to observation-to-replay evidence flow.

## 4. Ownership boundary rule
1. OxXlObs may observe and record Excel behavior through declared clean-room harnesses.
2. OxXlObs may normalize and package observations for replay use.
3. OxXlObs may not redefine Excel semantics or assert semantic truth beyond retained observation evidence.
4. Foundation owns doctrine; `OxReplay` owns shared replay runtime; lane repos own DNA Calc semantics.

## 5. Observation-to-replay rule
1. The primary output of OxXlObs is not raw logs or pass/fail status.
2. The primary output is a replay-ready evidence bundle with explicit provenance and capture-loss metadata.
3. Every retained divergence should be shaped so it can later be replayed, diffed, explained, and, where suitable, distilled.

## 6. Clean-room rule
Allowed sources:
1. public specifications and documentation,
2. published research,
3. reproducible black-box observations of Excel behavior.

Disallowed sources:
1. proprietary or restricted sources,
2. reverse engineering of Excel internals,
3. decompilation/disassembly of Excel internals.

## 7. Definition of done
An observation-harness change is done only when:
1. repo-local spec text is updated,
2. relevant Foundation doctrine links still hold,
3. capability and pack impact are stated,
4. affected replay-handoff evidence is updated,
5. the change does not widen OxXlObs into semantic ownership or replay-governance ownership.

## Source: `OxXlObs/CURRENT_BLOCKERS.md`

# CURRENT_BLOCKERS.md — OxXlObs

Status: no active blockers.

Last reviewed: 2026-03-20 (`W007` OxReplay seam activation review, no active blockers).

---

## Active Blockers

(none)

---

## Resolved Blockers

(none)

---

## Entry Template

```text
### BLK-XLOBS-NNN: <title>

- **Status**: active | resolved | closed
- **Impact**: <which worksets/features are blocked>
- **Current state**: <what has been attempted, what failed>
- **Exact unblock steps**: <specific actions needed>
- **Recommendation**: wait | escalate | workaround
- **Opened**: YYYY-MM-DD
- **Resolved**: YYYY-MM-DD (if applicable)
```

## Source: `OxXlObs/docs/IN_PROGRESS_FEATURE_WORKLIST.md`

# IN_PROGRESS_FEATURE_WORKLIST.md — OxXlObs

## Active bootstrap worksets

1. `W001_REPO_BOOTSTRAP_AND_BOUNDARY`
   - status: complete
   - objective: lock repo skeleton, observation boundary, and first package map.
   - current baseline: doctrine surfaces, spec index, local execution doctrine, canonical retained roots, and first Rust workspace model are explicit.
2. `W002_SCENARIO_AND_CAPTURE_CONTRACT_BASELINE`
   - status: complete
   - objective: stand up scenario declarations, observable surfaces, and lossiness markers.
   - current baseline: retained manifest and capture-shape fixtures exist under `docs/test-corpus/excel/`; `capture_surface_basic` now also has a stable live-driver family exercised under `states/excel/`.
3. `W003_ENVIRONMENT_FINGERPRINT_AND_BRIDGE_ENVELOPE`
   - status: complete
   - objective: pin Excel build, host environment, and bridge metadata for retained runs.
   - current baseline: retained provenance, bridge, and environment fingerprint fixtures exist and validate for the declared W003 scope; live driver exercise remains deferred to `W006`.
4. `W004_REPLAY_READY_BUNDLE_EMISSION_AND_HANDOFF`
   - status: complete
   - objective: emit canonical replay-ready bundles for `OxReplay`.
   - current baseline: canonical bundle seed and handoff validation fixtures exist and validate for the declared W004 scope.
5. `W005_DIFFERENTIAL_WITNESS_SEED_BASELINE`
   - status: complete
   - objective: shape Excel-vs-DNA divergences into replay/diff/explain-ready witness seeds.
   - current baseline: canonical witness-seed fixture exists and validates for the declared W005 scope.
6. `W006_STABLE_WINDOWS_EXECUTION_DRIVER`
   - status: complete
   - objective: stand up the first stable Windows execution path for repeatable observation runs.
   - current baseline: `dna-xl-obs capture-run` drives Excel through the retained PowerShell COM bridge and emits replay-ready retained evidence under `states/excel/xlobs_capture_values_formulae_001/`.
7. `W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION`
   - status: in_progress
   - objective: stand up the first cross-repo consumption pass through `OxReplay` and `OxCalc` over retained live Excel evidence.
   - current baseline: `OxReplay` now validates an `OxXlObs`-emitted canonical replay manifest and replay-loads the first normalized replay view from `states/excel/xlobs_capture_values_formulae_001/`; the `OxCalc` comparison leg remains open.

## Activation note
1. The Rust-first stack is declared for the repo.
2. OxXlObs is centered on observation-to-replay compilation from the first workset.
3. `W006` remains sequenced after `W005`; activation still depends on explicit scope, named capability/pack impact, and declared dependencies.
4. `W006` now retains the first live Excel-driven capture family and associated replay-ready bundle evidence.
5. `W007` is now active over the first `OxReplay` ingestion pass and remains open until the `OxCalc` comparison leg and seam clarifications are retained.

## Reserved follow-on lane entry
1. `OxReplay` is the first consumer expected to validate bundle quality and replay readiness.
2. `OxCalc` is the first DNA lane expected to use OxXlObs evidence for broad differential growth.
3. `OxFml` and `OxVba` should join through narrower initial scenario families.

## Activation rule
Move a workset to `in_progress` only when:
1. scope is explicit,
2. dependencies are known,
3. capability and pack impact are named,
4. no semantic-ownership drift is introduced.

## Source: `OxXlObs/docs/spec/OXXLOBS_ARCHITECTURE_AND_CAPTURE_MODEL.md`

# OXXLOBS_ARCHITECTURE_AND_CAPTURE_MODEL.md

## 1. Position
This document translates the repo mission into an initial observation-strata and capture model.

## 2. Intended strata
The initial split is:
1. `Abstractions`
2. `Scenario`
3. `Capture`
4. `Provenance`
5. `Bundle`
6. `Bridge`
7. `CLI`

## 3. Observation pipeline
The normalized pipeline is:
1. scenario declaration,
2. workbook and trigger preparation,
3. Excel execution through a declared bridge,
4. observable-surface capture,
5. provenance and lossiness attachment,
6. replay-ready bundle assembly,
7. retained run summary and handoff.

## 4. Source preservation rule
Retained artifacts must preserve:
1. scenario id,
2. workbook identity or fingerprint,
3. Excel build/version metadata,
4. trigger recipe,
5. directly observed versus derived status,
6. capture-loss or uncertainty markers when present.

## 5. Observable surfaces
The initial baseline surfaces should support:
1. workbook and workbook-part identity,
2. declared input mutations or trigger actions,
3. final observed cell or name values,
4. formula text where accessible,
5. error and status surfaces where accessible,
6. environment metadata needed to replay or compare the run honestly.

## 6. W002 retained shape baseline
The retained W002 baseline uses JSON fixture files inside declared scenario roots.

### 6.1 Scenario manifest file
1. Scenario declarations use `scenario.json`.
2. Minimum retained fields are:
   - `scenario_id`
   - `replay_class`
   - `retained_root`
   - `workbook_ref`
   - `trigger`
   - `observable_surfaces`
3. `observable_surfaces` entries carry:
   - `surface_id`
   - `surface_kind`
   - `locator`
   - `required`
4. Scenario validation rejects blank scenario ids, blank retained roots, empty surface lists, blank surface ids, blank locators, and duplicated surface ids.

### 6.2 Capture file
1. Capture-shape fixtures use `capture.json`.
2. Each captured surface carries:
   - `surface`
   - `status`
   - `value_repr`
   - `capture_loss`
   - `uncertainty`
3. `status` remains the baseline declaration of `direct`, `derived`, or `unavailable`.
4. `capture_loss` remains explicit even when the surface is unavailable rather than silently omitted.
5. `uncertainty` remains explicit even when currently `none` so later retained artifacts do not need a shape break to express it.

### 6.3 Validation rule
1. Direct or derived surfaces must carry an observed value representation.
2. Unavailable surfaces must not carry an observed value representation.
3. Unavailable surfaces must carry a non-`none` capture-loss marker.
4. These rules establish the W002 baseline for `O0.scenario_valid` and `O1.capture_valid` without claiming Excel-run evidence beyond retained fixture shapes.

## 7. W006 live driver baseline
1. `W006` introduces the first stable Windows execution path for `capture_surface_basic`.
2. The declared path is `dna-xl-obs capture-run --scenario <path> --output-dir <repo-relative-dir>`.
3. The current stable scenario family is `xlobs_capture_values_formulae_001`.
4. The current bridge opens the declared workbook through Excel COM automation, applies `open_then_recalc`, and retains direct cell-value and formula-text surfaces.
5. Live driver outputs are retained under `states/excel/<scenario_id>/` and remain observational evidence, not semantic authority.

## Source: `OxXlObs/docs/spec/OXXLOBS_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`

# OXXLOBS_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md

## 1. Position
This document defines how OxXlObs should turn retained observations into replay-ready evidence for `OxReplay`.

## 2. Primary output rule
The primary output is a replay-ready bundle seed, not an opaque automation dump.

The bundle seed should package:
1. scenario declaration,
2. observed surfaces,
3. provenance metadata,
4. capture-loss metadata,
5. sidecar refs for larger retained artifacts,
6. handoff metadata naming intended replay and differential consumers.

## 3. Handoff contract
Bundle output must be shaped so `OxReplay` can later:
1. ingest and validate it deterministically,
2. compare it against DNA lane bundles,
3. explain divergences with preserved provenance,
4. distill retained failures into smaller witnesses.

## 4. W004 retained bundle baseline
The retained W004 baseline uses canonical JSON fixtures for replay-ready bundle seeds and handoff validation output.

### 4.1 Bundle fixture
1. The `bundle_seed_basic` scenario root retains `bundle.json`.
2. Minimum retained fields are:
   - `bundle_schema`
   - `scenario`
   - `provenance`
   - `capture`
   - `sidecars`
   - `handoff`
3. Each sidecar ref retains:
   - `kind`
   - `path`
   - `media_type`
4. Sidecar refs must remain repo-relative.

### 4.2 Handoff metadata
1. Handoff metadata retains:
   - `intended_replay_consumers`
   - `intended_diff_consumers`
   - `capability_hints`
   - `pack_hints`
2. At least one replay consumer must be declared.
3. The W004 baseline names `OxReplay` explicitly as the replay consumer.

### 4.3 Handoff validation output
1. The `bundle_seed_basic` scenario root also retains `handoff-validation.json`.
2. Handoff validation output retains:
   - `bundle_schema`
   - `checked_consumers`
   - `valid`
   - `notes`
3. The validation output is a retained handoff witness, not a semantics claim.

## 5. W005 retained witness baseline
The retained W005 baseline uses canonical JSON fixtures for differential witness seeds.

### 5.1 Witness fixture
1. The `witness_seed_diff` scenario root retains `witness-seed.json`.
2. Minimum retained fields are:
   - `witness_schema`
   - `source_bundle`
   - `comparison_refs`
   - `divergences`
   - `lifecycle_state`
   - `quarantine_reason`
3. `source_bundle` preserves the originating Excel-side provenance and capture-loss lanes.

### 5.2 DNA-side comparison refs
1. Comparison refs retain:
   - `lane_id`
   - `producer_id`
   - `artifact_ref`
   - `adapter_id`
   - `adapter_version`
   - `capability_level`
   - `engine_config_ref`
2. W005 uses retained comparison refs rather than live sibling-repo execution.

### 5.3 Divergence records
1. Divergence records retain:
   - `surface_id`
   - `mismatch_kind`
   - `severity`
   - `excel_value_repr`
   - `comparison_value_repr`
   - `comparison_capture_loss_note`
   - `explanatory_note`
2. The retained divergence fixture must preserve enough provenance and lossiness to remain replay/diff/explain-ready without claiming semantic authority.

## 6. W006 live bundle retention
1. `W006` retains a live replay-ready bundle under `states/excel/xlobs_capture_values_formulae_001/bundle.json`.
2. The live bundle preserves the stable driver bridge provenance emitted during the retained Excel run rather than reusing the fixture-backed W004 provenance.
3. Sidecar refs for live driver bundles remain repo-relative and may point into `states/excel/` for retained environment and bridge witnesses.

## 7. W007 canonical replay-manifest alignment
1. `W007` begins aligning `OxXlObs` emission with the `OxReplay` canonical bundle manifest shape.
2. The current alignment model is dual-artifact:
   - the rich `OxXlObs` observation bundle remains the source observation contract,
   - an `OxReplay`-canonical `replay.bundle.v1` manifest is emitted over that source bundle for shared-runtime intake.
3. The first retained canonical manifest is `states/excel/xlobs_capture_values_formulae_001/oxreplay-manifest.json`.
4. The first retained normalized replay view is `states/excel/xlobs_capture_values_formulae_001/views/normalized-replay.json`.
5. If the replay-facing view is only a partial or lossy projection, the canonical manifest must state that explicitly and the richer observation sidecars must remain retained.

## Source: `OxXlObs/docs/spec/OXXLOBS_CAPABILITY_AND_PACK_TRACEABILITY.md`

# OXXLOBS_CAPABILITY_AND_PACK_TRACEABILITY.md

## 1. Position
This document maps OxXlObs bootstrap surfaces to local capabilities and Foundation pack touchpoints.

## 2. Local capability ladder
1. `O0.scenario_valid`
2. `O1.capture_valid`
3. `O2.provenance_valid`
4. `O3.bundle_seed_valid`
5. `O4.diff_seed_valid`
6. `O5.stable_driver_valid`

These are local observation capabilities, not Foundation replay capability claims.

## 3. Capability traceability

| Local capability | Workset | Replay classes | Artifact roots |
|---|---|---|---|
| `O0.scenario_valid` | `W002` | `scenario_manifest_valid`, `scenario_manifest_invalid` | `docs/test-corpus/excel/`, `docs/test-runs/` |
| `O1.capture_valid` | `W002` | `capture_surface_basic`, `capture_loss_marked` | `docs/test-corpus/excel/`, `docs/test-runs/` |
| `O2.provenance_valid` | `W003` | `provenance_minimal` | `docs/test-corpus/excel/`, `states/excel/`, `docs/test-runs/` |
| `O3.bundle_seed_valid` | `W004` | `bundle_seed_basic` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `O4.diff_seed_valid` | `W005` | `witness_seed_diff` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `O5.stable_driver_valid` | `W006` | `capture_surface_basic`, `bundle_seed_basic`, `witness_seed_diff` | `docs/test-runs/`, `states/excel/` |

## 4. Pack traceability

| Pack | Workset | Replay classes | Artifact roots |
|---|---|---|---|
| `PACK.replay.appliance` | `W004`, `W005` | `bundle_seed_basic`, `witness_seed_diff` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `PACK.diff.cross_engine.continuous` | `W005`, `W006` | `witness_seed_diff` | `docs/test-corpus/bundles/`, `docs/test-runs/` |
| `PACK.trace.forensic_plane` | `W002` through `W006` | `capture_surface_basic`, `capture_loss_marked`, `provenance_minimal`, `witness_seed_diff` | `docs/test-corpus/excel/`, `docs/test-runs/`, `states/excel/` |

## 5. W006 retained execution note
1. `O5.stable_driver_valid` is exercised through `states/excel/xlobs_capture_values_formulae_001/` and `docs/test-runs/W006_STABLE_WINDOWS_EXECUTION_DRIVER.md`.
2. The current retained live driver evidence directly supports `PACK.trace.forensic_plane` and provides the Excel-side retained run needed before later continuous differential work can widen.

## Source: `OxXlObs/docs/spec/OXXLOBS_CLI_CONTRACT.md`

# OXXLOBS_CLI_CONTRACT.md

## 1. Position
This document defines the initial command families for the OxXlObs CLI.

## 2. Initial command families
1. `validate-scenario`
2. `capture-run`
3. `fingerprint-env`
4. `emit-bundle`
5. `emit-diff-seed`
6. `validate-handoff`

## 3. W006 stable path
1. The first stable Windows execution path is `capture-run`.
2. Initial invocation contract:
   - `dna-xl-obs capture-run --scenario <scenario-json-path> [--output-dir <repo-relative-output-dir>]`
3. `capture-run` invokes the declared repo-local PowerShell bridge at `scripts/invoke-excel-observation.ps1`.
4. The initial stable output family emits `capture.json`, `provenance.json`, `bridge.json`, `environment.json`, `driver-run.json`, and `bundle.json`.
5. The current `W007` alignment pass also emits:
   - `oxreplay-manifest.json`
   - `views/normalized-replay.json`
6. These replay-facing files are emitted as canonical shared-runtime intake artifacts over the richer `OxXlObs` observation bundle rather than replacing it.
7. Other command families remain scaffolded until later worksets advance them beyond planning.

## Source: `OxXlObs/docs/spec/OXXLOBS_ENVIRONMENT_AND_PROVENANCE_MODEL.md`

# OXXLOBS_ENVIRONMENT_AND_PROVENANCE_MODEL.md

## 1. Position
This document defines the retained provenance required for trustworthy Excel observation artifacts.

## 2. Required provenance fields
Every retained observation artifact should carry:
1. scenario id,
2. run id,
3. workbook ref or workbook fingerprint,
4. Excel version/build/channel metadata,
5. host OS and architecture metadata,
6. bridge kind and bridge version,
7. macro/security mode and automation policy where relevant,
8. timestamp and timezone metadata,
9. declared observable surfaces,
10. capture-loss and uncertainty summary.

## 3. Bridge provenance rule
If a non-Rust bridge is used, the retained artifact must state:
1. bridge kind,
2. bridge version,
3. executable or assembly identity when applicable,
4. transport or invocation mode,
5. known bridge limits that affect interpretation.

## 4. W003 retained provenance baseline
The retained W003 baseline uses JSON fixture files to pin environment and bridge facts before stable live execution is introduced.

### 4.1 Provenance fixture
1. The `provenance_minimal` scenario root retains `provenance.json`.
2. Minimum retained fields are:
   - `scenario_id`
   - `run_id`
   - `workbook_ref`
   - `workbook_fingerprint`
   - `excel_version`
   - `excel_build`
   - `excel_channel`
   - `host_os`
   - `host_architecture`
   - `macro_mode`
   - `automation_policy`
   - `captured_at_utc`
   - `timezone`
   - `declared_surface_ids`
   - `capture_loss_summary`
   - `uncertainty_summary`
   - `bridge`
3. `capture_loss_summary` and `uncertainty_summary` are summary lanes and therefore do not retain `none`; an empty list is the no-summary case.

### 4.2 Bridge fixture
1. The `provenance_minimal` scenario root also retains `bridge.json`.
2. Bridge envelopes retain:
   - `scenario_id`
   - `bridge_kind`
   - `bridge_version`
   - `executable_identity`
   - `command_channel`
   - `invocation_mode`
   - `interpretation_limits`
3. Non-`pure_rust` bridges must state an executable or assembly identity explicitly.

### 4.3 Environment fingerprint fixture
1. Environment fingerprints for W003 retain a parallel `states/excel/<scenario_id>/environment.json` snapshot.
2. The state snapshot is a retained environment witness, not a semantic authority.

### 4.4 Capture influence rule
1. Capture outputs may declare `bridge_influenced: true` when a bridge constrains interpretation.
2. If `bridge_influenced` is true, at least one interpretation limit must be retained.

## 5. W006 live provenance baseline
1. `W006` retains live driver provenance under `states/excel/xlobs_capture_values_formulae_001/`.
2. The current stable bridge envelope is:
   - `bridge_kind`: `external_process`
   - `bridge_version`: `w006-powershell-com.v1`
   - `executable_identity`: `pwsh:scripts/invoke-excel-observation.ps1`
   - `command_channel`: `json-file`
   - `invocation_mode`: `com_automation`
3. Live provenance may retain the raw local Office channel string when the host reports a Click-to-Run URL rather than a normalized channel label.
4. The retained state snapshot remains a host-bound environment witness and must keep workbook fingerprint, Excel build, macro mode, and bridge provenance explicit.

## Source: `OxXlObs/docs/spec/OXXLOBS_IMPLEMENTATION_BASELINE.md`

# OXXLOBS_IMPLEMENTATION_BASELINE.md

## 1. Position
This document freezes the current Rust-first implementation baseline without pretending the final package graph is permanent.

## 2. Active implementation direction
1. OxXlObs is Rust-first.
2. The active implementation lives under `src/` as a repo-root Cargo workspace.
3. A narrow external bridge seam remains allowed for Windows-specific Excel driving where required.
4. The current W006 bridge seam is a repo-local PowerShell COM driver invoked from the Rust CLI rather than an embedded semantic engine.

## 3. Initial crate responsibilities
1. `oxxlobs-abstractions`
2. `oxxlobs-scenario`
3. `oxxlobs-capture`
4. `oxxlobs-provenance`
5. `oxxlobs-bundle`
6. `oxxlobs-bridge`
7. `oxxlobs-cli`

## 4. Validation floor
1. `cargo fmt --all --check`
2. `cargo clippy --workspace --all-targets --all-features -- -D warnings`
3. `cargo test --workspace`
4. `pwsh ./scripts/meta-check.ps1`

## Source: `OxXlObs/docs/spec/OXXLOBS_SCENARIO_REGISTER.md`

# OXXLOBS_SCENARIO_REGISTER.md

## 1. Position
This document assigns stable scenario ids for the first OxXlObs bootstrap worksets.

## 2. Scenario register

| Replay class | Scenario id | Retained root |
|---|---|---|
| `scenario_manifest_valid` | `xlobs_manifest_minimal_valid_001` | `docs/test-corpus/excel/xlobs_manifest_minimal_valid_001/` |
| `scenario_manifest_invalid` | `xlobs_manifest_invalid_missing_surface_001` | `docs/test-corpus/excel/xlobs_manifest_invalid_missing_surface_001/` |
| `capture_surface_basic` | `xlobs_capture_values_formulae_001` | `docs/test-corpus/excel/xlobs_capture_values_formulae_001/` |
| `capture_loss_marked` | `xlobs_capture_loss_formula_unavailable_001` | `docs/test-corpus/excel/xlobs_capture_loss_formula_unavailable_001/` |
| `provenance_minimal` | `xlobs_provenance_excel_build_001` | `docs/test-corpus/excel/xlobs_provenance_excel_build_001/` |
| `bundle_seed_basic` | `xlobs_bundle_seed_handoff_001` | `docs/test-corpus/bundles/xlobs_bundle_seed_handoff_001/` |
| `witness_seed_diff` | `xlobs_witness_seed_divergence_001` | `docs/test-corpus/bundles/xlobs_witness_seed_divergence_001/` |

## 3. W002 retained files
1. `scenario_manifest_valid` and `scenario_manifest_invalid` roots retain `scenario.json`.
2. `capture_surface_basic` and `capture_loss_marked` roots retain both `scenario.json` and `capture.json`.
3. Later-workset roots may remain scaffolded until their worksets advance beyond planning.

## 4. W003 retained files
1. `provenance_minimal` retains `provenance.json` and `bridge.json`.
2. `provenance_minimal` also retains `states/excel/xlobs_provenance_excel_build_001/environment.json`.

## 5. W004 retained files
1. `bundle_seed_basic` retains `bundle.json` and `handoff-validation.json`.

## 6. W005 retained files
1. `witness_seed_diff` retains `witness-seed.json`.

## 7. W006 retained files
1. `capture_surface_basic` also retains `workbook.xlsx` under `docs/test-corpus/excel/xlobs_capture_values_formulae_001/`.
2. `capture_surface_basic` retains live driver outputs under `states/excel/xlobs_capture_values_formulae_001/`:
   - `capture.json`
   - `provenance.json`
   - `bridge.json`
   - `environment.json`
   - `driver-run.json`
   - `bundle.json`

## 8. W007 retained files
1. `capture_surface_basic` now also retains the first `OxReplay`-facing canonical intake artifacts under `states/excel/xlobs_capture_values_formulae_001/`:
   - `oxreplay-manifest.json`
   - `views/normalized-replay.json`
   - `oxreplay-validate-bundle-report.json`
   - `oxreplay-replay-report.json`

## Source: `OxXlObs/docs/spec/OXXLOBS_SCOPE_AND_BOUNDARY.md`

# OXXLOBS_SCOPE_AND_BOUNDARY.md

## 1. Position
This document defines what OxXlObs is allowed to own and what it must leave to Foundation, `OxReplay`, and the DNA Calc lane repos.

## 2. Repo purpose
OxXlObs is the shared implementation substrate for Excel observation and observation-to-replay compilation.

It exists to provide reusable mechanics for:
1. scenario planning,
2. Excel-run observation,
3. provenance capture,
4. lossiness reporting,
5. replay-ready bundle emission,
6. witness-seed preparation for later replay analysis.

## 3. In scope
1. Shared observation abstractions and scenario types.
2. Controlled Excel trigger and capture recipes.
3. Provenance and environment fingerprint handling.
4. Replay-ready bundle assembly and sidecar emission.
5. Differential witness-seed scaffolding for Excel-vs-DNA comparisons.
6. CLI and local tool surfaces for repeatable observation runs.

## 4. Out of scope
1. Semantic ownership of Excel behavior.
2. Replay execution, diff, explain, and witness lifecycle governance.
3. Lane-local semantic ownership for DNA Calc repos.
4. Broad Office automation unrelated to retained observation evidence.

## 5. Ownership split
1. Foundation owns doctrine and clean-room governance.
2. OxXlObs owns Excel observation mechanics and replay-ready evidence compilation.
3. `OxReplay` owns shared replay runtime and evidence analysis.
4. Lane repos own DNA Calc semantics and adapter meaning.

## 6. Live Excel re-execution rule
1. `OxXlObs` is the primary Excel-driving subsystem for the program.
2. If a replay workflow later needs live Excel re-execution, `OxReplay` may coordinate or request it, but the actual Excel-driving path should remain in `OxXlObs`.
3. Artifact replay inside `OxReplay` and live Excel re-execution through `OxXlObs` are related but distinct operations and must not be collapsed into one ownership surface.

## Source: `OxXlObs/docs/spec/README.md`

# OxXlObs Spec Index

This directory is the OxXlObs-owned mutable spec set after bootstrap.

## Canonical local spec ownership
1. `docs/spec/OXXLOBS_SCOPE_AND_BOUNDARY.md`
2. `docs/spec/OXXLOBS_ARCHITECTURE_AND_CAPTURE_MODEL.md`
3. `docs/spec/OXXLOBS_ENVIRONMENT_AND_PROVENANCE_MODEL.md`
4. `docs/spec/OXXLOBS_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`
5. `docs/spec/OXXLOBS_IMPLEMENTATION_BASELINE.md`
6. `docs/spec/OXXLOBS_SCENARIO_REGISTER.md`
7. `docs/spec/OXXLOBS_CAPABILITY_AND_PACK_TRACEABILITY.md`
8. `docs/spec/OXXLOBS_CLI_CONTRACT.md`

## Consumed doctrine
Foundation remains higher-precedence doctrine owner for:
1. replay architecture and governance,
2. clean-room evidence rules,
3. pack and promotion rules,
4. host and lane topology.

Primary Foundation references:
1. `../../../Foundation/CHARTER.md`
2. `../../../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
3. `../../../Foundation/OPERATIONS.md`
4. `../../../Foundation/REPLAY_APPLIANCE.md`

## Source: `OxXlObs/docs/test-runs/W006_STABLE_WINDOWS_EXECUTION_DRIVER.md`

# W006_STABLE_WINDOWS_EXECUTION_DRIVER

- Date: 2026-03-18
- Execution state: `complete`
- Scope status: the first stable Windows Excel execution path is present and exercised through the repo CLI for the declared `capture_surface_basic` scenario family.

## Commands
1. `cargo run -p oxxlobs-cli -- capture-run --scenario docs/test-corpus/excel/xlobs_capture_values_formulae_001/scenario.json --output-dir states/excel/xlobs_capture_values_formulae_001`
2. `pwsh ./scripts/meta-check.ps1`

## Retained roots exercised
1. `docs/test-corpus/excel/xlobs_capture_values_formulae_001/`
2. `states/excel/xlobs_capture_values_formulae_001/`

## Driver evidence summary
1. The stable path runs through `dna-xl-obs capture-run`, which invokes `scripts/invoke-excel-observation.ps1` as a narrow external bridge seam.
2. The retained live run captured `sheet1_a1_value = 42` and `sheet1_a1_formula = =SUM(B1:B3)` from a tracked workbook input.
3. The retained live provenance records Excel `16.0` build `19725`, Windows `Microsoft Windows 11 Pro` on `x64`, macro mode `force_disable_requested`, and explicit COM bridge provenance.
4. The retained live bundle preserves repo-relative sidecars for the environment and bridge witnesses under `states/excel/xlobs_capture_values_formulae_001/`.

## Current limits
1. The stable driver path is currently exercised only for `xlobs_capture_values_formulae_001`.
2. The repo-local PowerShell bridge currently supports the bootstrap surface family needed for `capture_surface_basic`; broader scenario families remain later work.
3. The retained Office channel field may carry the raw local Click-to-Run channel string when the host reports a URL rather than a normalized label.

## Source: `OxXlObs/docs/test-runs/W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION.md`

# W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION

- Date: 2026-03-20
- Execution state: `in_progress`
- Scope status: the first `OxReplay` ingestion and replay-path activation pass is retained; the `OxCalc` comparison leg remains open.

## Commands
1. `cargo run -p oxxlobs-cli -- capture-run --scenario docs/test-corpus/excel/xlobs_capture_values_formulae_001/scenario.json --output-dir states/excel/xlobs_capture_values_formulae_001`
2. `cargo run -p oxreplay-dnarecalc-cli -- validate-bundle --bundle ../OxXlObs/states/excel/xlobs_capture_values_formulae_001/oxreplay-manifest.json --format json`
3. `cargo run -p oxreplay-dnarecalc-cli -- replay --bundle ../OxXlObs/states/excel/xlobs_capture_values_formulae_001/views/normalized-replay.json --kind normalized-replay`
4. `pwsh ./scripts/meta-check.ps1`

## Retained roots exercised
1. `states/excel/xlobs_capture_values_formulae_001/`
2. `docs/upstream/NOTES_FOR_OXREPLAY.md`

## Current W007 baseline
1. `OxXlObs` now emits an `OxReplay`-canonical replay manifest at `states/excel/xlobs_capture_values_formulae_001/oxreplay-manifest.json`.
2. The canonical manifest validates successfully through `OxReplay` and resolves the retained sidecars and normalized replay view.
3. `OxReplay` also accepts the first normalized replay view at `states/excel/xlobs_capture_values_formulae_001/views/normalized-replay.json`.
4. The richer `OxXlObs` observation bundle remains retained alongside the canonical replay-facing manifest rather than being discarded.

## Current limits
1. The `OxCalc` comparison leg of `W007` remains open.
2. The first normalized replay view is a lossy projection over observed Excel surfaces and is not yet a broad semantic equivalence surface.
3. Adapter-manifest expectations for the `OxXlObs` seam are still open for clarification with `OxReplay`.

## Source: `OxXlObs/README.md`

# OxXlObs

OxXlObs is the Excel observation harness repo for DNA Calc.

It exists to turn controlled Excel runs into replay-ready, schema-checked evidence bundles that feed the Replay appliance without turning Excel into a new semantics lane.

## Core responsibilities
1. Scenario planning for reproducible Excel observation runs.
2. Environment, build, workbook, and trigger fingerprint capture.
3. Stable capture of observable Excel surfaces and explicit lossiness markers.
4. Compilation of observations into canonical replay-ready bundles for `OxReplay`.
5. Differential-run seeding for DNA-vs-Excel investigation and witness growth.
6. CLI and local tooling for repeatable observation collection.

## Not this repo
1. Not a new semantics lane.
2. Not the owner of Excel semantic truth.
3. Not the owner of replay doctrine or witness lifecycle governance.
4. Not a generic Office automation dumping ground.

## Startup docs
`AGENTS.md` is the authoritative startup path for agents and doctrinal work.

Minimum repo-orientation read order:
1. `README.md`
2. `AGENTS.md`
3. `CHARTER.md`
4. `OPERATIONS.md`
5. `CURRENT_BLOCKERS.md`
6. `docs/IN_PROGRESS_FEATURE_WORKLIST.md`
7. `docs/worksets/README.md`
8. `docs/spec/README.md`

## Bootstrap workspace layout
1. `docs/spec/`
   - repo-owned mutable specs for observation, provenance, capture, and replay-handoff boundaries.
2. `docs/worksets/`
   - execution packets for staged delivery.
3. `docs/handoffs/`
   - structured cross-repo or Foundation-facing handoff packets.
4. `docs/upstream/`
   - outbound observation ledgers for sibling repos and hosts.
5. `docs/test-corpus/`
   - retained Excel fixtures, observation scenarios, and replay-ready bundle seeds.
6. `docs/test-runs/`
   - retained human-readable validation runs.
7. `src/`, `tests/`, `tools/`, `scripts/`, `states/`, `formal/`
   - code, harness, state, and formalization roots to be populated as implementation advances.

## Bootstrap status
The repo starts doc-first and Rust-first so the clean-room observation boundary and replay handoff contract are fixed before heavy Excel-driving work lands.
The bootstrap packet is now `complete` through `W006`, with the first retained live Excel-driven capture family exercised under `states/excel/`.
The next lane widens from local bootstrap into cross-repo replay and differential consumption.
The current `W007` direction is to emit an `OxReplay`-canonical replay manifest over the richer `OxXlObs` observation bundle rather than collapsing the observation contract into a thin shared-runtime shape.

## Implementation Direction
1. OxXlObs is Rust-first for scenario planning, provenance handling, bundle assembly, CLI surfaces, and most harness logic.
2. The active implementation lives under `src/` as a Cargo workspace with crate boundaries that follow the declared observation strata.
3. A narrow external bridge seam is allowed where stable Excel automation requires Windows-specific interop that is better hosted outside pure Rust. That seam must remain explicit, versioned, and evidence-bearing.
4. New execution should follow the local Rust quality floor:
   - `cargo fmt --all --check`
   - `cargo clippy --workspace --all-targets --all-features -- -D warnings`
   - `cargo test --workspace`
   - `pwsh ./scripts/meta-check.ps1`

## Foundation alignment
Precedence and constitutional constraints are inherited from:
1. `../Foundation/CHARTER.md`
2. `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
3. `../Foundation/OPERATIONS.md`
4. `../Foundation/REPLAY_APPLIANCE.md`

## Dependency constitution
1. May depend on shared schema and evidence contracts.
2. May emit replay-ready artifacts for `OxReplay`.
3. Must use clean-room admissible evidence sources only.
4. Must not become a second semantic authority for Excel or for DNA Calc lanes.

