# DNA OneCalc: Systematic Clarifications, Suggestions, and Upstream Prompt Pack

Date: 2026-03-28  
Prepared from the current flattened OneCalc reference pack:
- `DNA_ONECALC_SCOPE_AND_SPEC.md`
- `OXFML_REFERENCE.md`
- `OXFUNC_REFERENCE.md`
- `OXREPLAY_REFERENCE.md`
- `OXXLOBS_REFERENCE.md`
- `OXCALC_REFERENCE.md`
- `OXVBA_REFERENCE.md`
- `README.md`

## 1. Executive Read

## 1.1 What the current spec already establishes well

The current `DNA OneCalc` scope note is materially strong. It already fixes the most important boundary decisions:

1. `DNA OneCalc` is a downstream proving host and serious product shell, not a new semantics lane.
2. It is intentionally narrower than `OxCalc`.
3. Its central product identity is not “type a formula, get a value,” but `Twin Oracle Workbench` / `Live Formula Semantic X-Ray`.
4. Replay, comparison, provenance, witness retention, and upstream handoff are first-class, not sidecars.
5. The core runtime dependency set is `OxFml`, `OxFunc`, and `OxReplay`, with `OxXlObs` as the empirical comparison lane and `OxVba` as staged-later.
6. The work is already shaped around a durable artifact spine: `Scenario`, `ScenarioRun`, `Observation`, `Comparison`, `Witness`, `HandoffPacket`, and `Document`.
7. The host is explicitly single-node and explicit-input by default, with bounded exceptions for seam-sensitive reference-bearing probes.
8. Formatting and conditional formatting belong in scope, but without workbook-graph semantics.
9. The first persistence target is `SpreadsheetML 2003`.
10. The first extension story is a portable C ABI, not “Windows `.xll` everywhere.”

Those are the right strategic decisions to carry into repo bootstrap.

## 1.2 What is still materially under-frozen

The OneCalc note is conceptually coherent, but several cross-repo seams remain only partially frozen. The biggest pre-build uncertainties are:

1. **OxFml host/runtime contract**  
   A real implementation-facing draft exists, and OxCalc treats it as sufficient for first planning, but it is not yet a fully frozen shared seam. OneCalc can build against it, but must treat it as provisional and pin the exact consumed subset explicitly.

2. **Explicit-input product model vs current seam reality**  
   The intended OneCalc product model is explicit-input and non-grid, but the real OxFml/OxCalc seam floor still admits mutable direct cell bindings, caller anchors, table context, and library-context facts for specific semantic lanes. This tension is acknowledged but not yet fully productized.

3. **Editor/language-service freeze**  
   OxFml now has a real local language-service packet layer, but the shared immutable edit packet, shared validated-completion result packet, and OxFunc-backed help/signature payload contracts are not yet frozen.

4. **OxFunc downstream integration contract**  
   The current downstream seed is the library-context snapshot export, but that export is explicitly a stabilization artifact, not the final ABI. It must be read through `W050` and `W051`, not as broad catalog truth by itself.

5. **Replay consumption contract for a non-`DNA ReCalc` host**  
   OxReplay has a strong local OneCalc consumption note, but it still does not provide an app-facing OneCalc host contract analogous to `DNA_RECALC_HOST.md`. OneCalc can embed replay services, but should not pretend that embed contract is already frozen.

6. **Excel comparison contract**  
   OxXlObs already has a real Windows live-driver baseline and replay-ready bundle emission, but the exercised comparison surface is still narrow and the current replay-facing normalized view is explicitly `lossy`.

7. **Extension / OxVba maturity**  
   OxVba is relevant, but its add-in and XLL story remains future direction. OneCalc should treat OxVba as design input and later co-development pressure, not as a frozen downstream ABI.

8. **Persistence mapping ownership**  
   There is no stable `Ox*`-owned persistence contract for isolated-instance `SpreadsheetML 2003` mapping. OneCalc itself must own the first concrete mapping design.

## 1.3 Bottom-line judgment

`DNA OneCalc` should be started now, but only with a **disciplined seam manifest**, a **visible capability-floor matrix**, and a **tight provisional/frozen split**. The pre-build problem is not “insufficient upstream existence.” The pre-build problem is “too many real surfaces are available, but they have not yet been narrowed into one OneCalc-safe contract.”

That is a good place to start from, as long as the bootstrap work does not hide the provisionality.

---

## 2. Non-Negotiable Interpretation Rules For Bootstrap

The following rules should be treated as preamble doctrine for every OneCalc workset and every upstream prompt.

### 2.1 Preserve the host boundary

OneCalc must remain:
- a single-node proving host,
- explicit-input by default,
- narrower than `OxCalc`,
- non-grid as a public product claim,
- capable of bounded reference-bearing probes only where evidence forces them.

### 2.2 Preserve semantics ownership

OneCalc must consume:
- formula semantics from `OxFml`,
- function/value semantics from `OxFunc`,
- replay mechanics from `OxReplay`,
- Excel observation evidence from `OxXlObs`,
- later VBA/runtime surfaces from `OxVba`.

It must not redefine any of those locally.

### 2.3 Preserve accepted-candidate vs publication discipline

OneCalc UI and artifacts should never collapse:
- parse/bind/evaluate result,
- accepted candidate,
- commit bundle,
- published/retained state,
- replay projection,
- Excel observation.

These must remain visibly distinct where the upstream lanes distinguish them.

### 2.4 Preserve capability honesty

OneCalc should never say “supported” when the real state is:
- `promoted current surface`,
- `in scope but not complete`,
- `deferred current-version surface`,
- `available only as an upstream-pressure scenario`,
- `Windows-only live path`,
- `lossy replay-facing projection`,
- `planning artifact only`.

### 2.5 Preserve retained evidence lineage

The product should revolve around retained evidence, not UI-only state. Every meaningful action should be traceable back to:
- source scenario id,
- host profile,
- seam pin set,
- function-surface admission state,
- replay floor relied upon,
- observation provenance,
- witness/handoff lineage where applicable.

---

## 3. Systematic Review Of The OneCalc Spec

## 3.1 Sections 1–5: Purpose, role, thesis, dependencies, product expression

### What is already clear

These sections do the most important strategic work well:
- they define OneCalc as a downstream proving host and product,
- they separate it from `OxCalc`,
- they center the app on the `Twin Oracle Workbench`,
- they make replay and comparison part of the core thesis,
- they establish the correct dependency constitution.

### Clarifications needed

1. **“Serious product” should be translated into concrete host promises.**  
   The note says OneCalc is a serious user-facing application, but the contract still needs a practical distinction between:
   - product-level promises,
   - proving-host allowances,
   - upstream-pressure scenarios.

2. **The “workbench modes” need an explicit gate table.**  
   `DNA-only`, `Excel-observed`, `Twin compare`, `Replay`, `Diff`, `Explain`, `Distill`, and `Handoff` are the right mode names, but each should be tied to:
   - required dependencies,
   - capability floor,
   - platform availability,
   - admissible artifact outputs,
   - “provisional” labeling rules.

3. **Dependency constitution should be mirrored into a repo-local seam manifest.**  
   The spec gives a human-readable constitution, but bootstrap needs a machine-usable equivalent.

### Suggestions

1. Add a `HOST_CAPABILITY_MATRIX.md` or `host_capability_matrix.json` with rows such as:
   - `mode_id`
   - `requires_windows_live_excel`
   - `requires_oxreplay_capability_floor`
   - `requires_oxxlobs_projection_kind`
   - `requires_function_surface_policy`
   - `allowed_output_artifacts`
   - `label_if_provisional`

2. Add a `SEAM_MANIFEST.md` with four explicit categories:
   - runtime dependency,
   - empirical dependency,
   - seam-reference dependency,
   - staged-later design input.

3. Make “serious product” mean:
   - keyboard-first editing,
   - visible host profile,
   - visible capability/provisionality state,
   - retained scenario authoring,
   - replay/diff/explain controls in UI,
   - no hidden overclaim.

---

## 3.2 Section 6: Canonical artifact spine

### What is already clear

The artifact spine is one of the strongest parts of the note. The distinction between `Scenario`, `ScenarioRun`, `Observation`, `Comparison`, `Witness`, `HandoffPacket`, and `Document` is exactly the right backbone for the repo.

### Clarifications needed

1. **Identity policy is still too implicit.**  
   The spec says “stable identifiers,” but OneCalc should freeze which identities are:
   - stable logical ids,
   - content fingerprints,
   - version pins,
   - run-local operational ids.

2. **`Document` vs `Scenario` needs a sharper rule.**  
   The note correctly says a document container may hold one or more isolated scenarios and must not imply workbook graph semantics. What is still missing is the exact mapping between:
   - authoring unit,
   - persisted container unit,
   - replay unit,
   - comparison unit.

3. **`HandoffPacket` needs an action taxonomy.**  
   “Exact requested upstream action” should be normalized enough that OneCalc does not produce free-form issue prose only.

### Suggestions

Freeze the following minimum schemas.

#### Scenario
Minimum recommended fields:
- `scenario_id`
- `scenario_slug`
- `formula_text`
- `formula_channel_kind`
- `host_profile_id`
- `input_packet_kind`
- `input_bindings`
- `typed_query_context`
- `display_context`
- `library_context_snapshot_ref`
- `function_surface_policy_id`
- `extension_profile_id`
- `notes`
- `created_at`
- `created_by_surface` (`ui`, `import`, `reduction`, `hand-authored`)

#### ScenarioRun
Minimum recommended fields:
- `scenario_run_id`
- `scenario_id`
- `build_id`
- `seam_pin_set_id`
- `host_profile_id`
- `runtime_platform`
- `result_surface_ref`
- `candidate_ref`
- `commit_ref`
- `reject_ref`
- `trace_ref`
- `replay_capture_ref`
- `function_surface_effective_id`
- `projection_status`
- `executed_at`

#### Observation
Minimum recommended fields:
- `observation_id`
- `source_lane_id`
- `source_schema`
- `source_artifact_ref`
- `capture_mode`
- `projection_status`
- `provenance_ref`
- `capture_loss_ref`
- `platform_scope`

#### Comparison
Minimum recommended fields:
- `comparison_id`
- `lhs_artifact_ref`
- `rhs_artifact_ref`
- `comparison_kind`
- `value_agreement`
- `type_agreement`
- `display_agreement`
- `format_agreement`
- `cf_agreement`
- `projection_limitations`
- `diff_ref`
- `explain_ref`

#### Witness
Minimum recommended fields:
- `witness_id`
- `source_comparison_id`
- `source_replay_bundle_refs`
- `lifecycle_state`
- `quarantine_reason`
- `reduction_ref`
- `predicate_ref`
- `retained_root`

#### HandoffPacket
Minimum recommended fields:
- `handoff_id`
- `target_repo`
- `target_surface`
- `requested_action_kind`
- `requested_action_text`
- `source_scenario_id`
- `source_run_id`
- `source_comparison_id`
- `source_witness_id`
- `seam_pin_set_id`
- `capability_floor_relied_on`
- `expected_behavior`
- `observed_behavior`
- `supporting_artifact_refs`
- `status`

Recommended `requested_action_kind` values:
- `freeze_contract`
- `clarify_contract`
- `close_gap`
- `promote_surface`
- `narrow_scope`
- `document_limit`
- `accept_provisionality`
- `define_registry`
- `define_payload`
- `define_projection`

---

## 3.3 Section 7: Host profile ladder

This section is the conceptual center of the build.

## 3.3.1 OC-H0

### What is already clear

`OC-H0` is correctly narrow:
- literals,
- operators,
- built-ins with no external provider/workbook state,
- locale/date-system context,
- result display,
- replay capture.

### Clarifications needed

1. The phrase “built-in functions that require no external provider or workbook state” should be tied to the OxFunc admission overlays, not intuition.
2. `OC-H0` needs an explicit “promotion rule”: which functions can appear in marketing/demo/default scenarios versus “pressure” scenarios.

### Suggestions

Define:
- `product_promoted_surface`
- `provisional_surface`
- `pressure_surface`

Then explicitly map:
- `W050` rows -> never product-promoted for H0,
- `W051` rows -> only provisional/pressure, unless individually upgraded,
- function-phase-complete rows -> eligible for promoted surface.

## 3.3.2 OC-H1 explicit-input host

### What is already clear

This is the right default OneCalc product model.

### Clarifications needed

The current “upstream tension and resolution” is good prose, but repo bootstrap needs an actual packet taxonomy. Right now the note says “bounded reference-bearing scenario packet” without freezing its kinds.

### Strong suggestion: freeze exactly four packet kinds

1. **`ExplicitInputPacket`**  
   The default.  
   No caller anchor. No direct cell fixture. No table context. No open reference map.

2. **`ReferenceProbePacket`**  
   For strictly bounded lanes such as:
   - `@`
   - `_xlfn.SINGLE`
   - reference-sensitive `CELL(...)`

   Allowed extras:
   - direct cell fixture,
   - caller anchor,
   - maybe active selection anchor.

3. **`StructuredReferenceProbePacket`**  
   For strictly bounded table-context and structured-reference lanes.  
   Allowed extras:
   - `table_catalog`
   - `enclosing_table_ref`
   - `caller_table_region`

4. **`RegisteredExternalProbePacket`**  
   For `CALL`, `REGISTER.ID`, and later add-in/provider seams.  
   Allowed extras:
   - registered external provider/catalog refs,
   - extension runtime context,
   - explicit provider capability declarations.

Everything else should be rejected as outside the initial OneCalc host identity.

### Additional suggestion

Create a `HOST_PROFILE_RULES.md` table with columns:
- `profile_id`
- `default_packet_kind`
- `allowed_extra_fields`
- `forbidden_fields`
- `requires_ui_label`
- `requires_provisional_label`
- `eligible_for_product_promoted_surface`

That will keep OneCalc from drifting into “generic worksheet host by accumulation.”

## 3.3.3 OC-H2 extensions and add-ins

### What is already clear

The spec is right to define the portability claim at the ABI level, not at the binary format level.

### Clarifications needed

1. The extension ABI should be split into:
   - OneCalc-owned ABI surface,
   - OxFml/OxFunc semantic integration surface,
   - OxVba later shim surface.

2. The first contract should distinguish:
   - registration-time metadata,
   - call-time argument/result transport,
   - lifecycle hooks,
   - replay visibility hooks,
   - error/result publication class.

### Suggestions

Freeze extension ABI v0 around:
- `register_function`
- `unregister_function`
- `invoke`
- `describe_function`
- `get_capabilities`

And require these metadata fields:
- stable function id
- display name
- argument list
- volatility/host-interaction flags
- thread-safety
- return-surface class
- replay visibility policy
- platform support matrix

Do **not** make `.xll` itself the semantic contract.  
Make `.xll` and `.so` merely packaging shapes over the ABI.

---

## 3.4 Section 8: Formatting and conditional formatting plane

### What is already clear

This section has the correct ownership split:
- `OxFml` owns semantic formatting and CF/DV carrier semantics,
- OneCalc owns style state, rendering, and effective-format computation,
- `OxReplay` sees format-significant consequences,
- `OxXlObs` provides Excel-facing empirical truth.

### Clarifications needed

1. **OneCalc needs a first promoted formatting subset.**  
   “Formatting belongs here” is correct, but bootstrap needs a named first slice.

2. **The first CF subset should be frozen before UI work starts.**  
   Otherwise rendering, persistence, replay projection, and comparison will all diverge.

3. **OneCalc should distinguish `returned presentation hint` from `host style state`.**  
   The current upstream floor already makes presentation-aware return hints real for functions like `NOW`, `TODAY`, and `HYPERLINK`.

### Suggested first honest formatting subset

#### Base formatting subset v1
- number format code
- date/time format code
- text/general distinction
- font weight (`normal` / `bold`)
- font style (`normal` / `italic`)
- foreground color from a narrow portable palette
- hyperlink presentation intent as separate from clickability

#### Effective display subset v1
- raw value
- returned presentation hint
- applied host style
- computed display text
- display-loss note if approximation occurs

#### Conditional formatting subset v1
Restrict to:
- isolated-instance target scope,
- formula-based rule carriers using current restricted OxFml CF profile,
- no union/intersection/spill-reference/external-reference families,
- no workbook precedence system,
- no cross-instance interaction.

### Suggestions

1. Add a OneCalc-local `DISPLAY_AND_FORMAT_MODEL.md`.
2. Add a `FORMATTING_SUBSET_REGISTER.md` with statuses:
   - promoted
   - provisional
   - deferred
3. Make replay and comparison preserve:
   - raw value,
   - returned presentation hint,
   - host style state,
   - effective display text,
   - projection status.

---

## 3.5 Section 9: UI, runtime, and platform model

## 3.5.1 Runtime split

### What is already clear

The intended split is sound:
- shared `Leptos` application core,
- Tauri desktop shell for Windows/Linux,
- browser/WASM host over same shared core.

### Clarifications needed

Need a build matrix that distinguishes:
- supported runtime host,
- supported comparison mode,
- supported extension mode,
- supported replay mode.

### Suggested platform matrix

#### Windows desktop
- Full target for initial serious host
- Live Excel comparison allowed
- Native extensions allowed
- OxVba/COM-sensitive later lanes possible

#### Linux desktop
- No live Excel comparison
- Replay/diff/explain on retained artifacts allowed
- Native `.so` ABI allowed
- COM-sensitive OxVba lanes unavailable by default

#### Browser/WASM
- No native add-ins
- No live Excel comparison
- Replay/diff/explain over retained artifacts allowed
- Editing / X-Ray / scenario authoring allowed
- OxVba only if later sandboxed host path is explicitly added

## 3.5.2 Leptos proving criteria

### Clarifications needed

The note correctly says Leptos is a proving lane, not unquestioned premise. But the proof criteria are still open.

### Suggested exit criteria for W2

A Leptos/Tauri/browser stack is “good enough to continue” only if all hold:

1. **Editing**
   - correct caret behavior on formulas with parentheses, commas, quotes, and Unicode,
   - IME composition is stable,
   - no systematic cursor jumps on incremental diagnostics,
   - no destructive re-render on completion popup interactions.

2. **Keyboard**
   - command palette and editor commands are keyboard-first,
   - undo/redo is reliable,
   - signature-help/completion navigation works without pointer dependency.

3. **Latency**
   - visible edit-to-diagnostics response stays within an acceptable interactive band on representative formulas,
   - no frame-stall behavior when parse/bind/completion surfaces refresh.

4. **WASM viability**
   - bundle size is acceptable for the intended browser scope,
   - browser host can render the editor and X-Ray views without pathological slowdown.

5. **Escape hatch**
   - repo documents what would trigger an editor-stack rethink.

## 3.5.3 Formula-editing integration

### What is already clear

This section is directionally excellent. OneCalc should consume OxFml edit packets rather than building a second parser/binder truth.

### Clarifications needed

1. A host-local editor session model is still needed, but only as presentation/cache state.
2. The exact freeze line between:
   - OxFml canonical packet,
   - OneCalc editor state,
   - OxFunc help payload source,
   is not yet explicit enough.

### Suggestions

Define OneCalc editor state as:
- `EditorBufferState`
- `OxFmlEditProjection`
- `UiOverlayState`

Where only `OxFmlEditProjection` carries canonical semantics.

#### OneCalc should never locally own:
- parse tree meaning,
- bind diagnostics meaning,
- completion canonicality,
- function signature truth.

#### OneCalc may own:
- selection state,
- viewport state,
- popup placement,
- recent command history,
- local pinning/folding of X-Ray panes,
- cached presentation of help payloads.

---

## 3.6 Section 10: Replay, comparison, and scenario library

### What is already clear

This section gets the philosophy right: replay is one reason the product exists.

### Clarifications needed

1. The first replay-enabled UI wave needs a narrower contract than “all replay surfaces.”
2. The mode names `Replay`, `Diff`, `Explain`, `Distill`, and `Handoff` need explicit capability gates.
3. `Distill` should not appear as settled product surface if OneCalc only honestly depends on `C3.explain_valid`.

### Strong suggestion: gate the workbench modes

#### `Replay`
Requires:
- retained bundle or normalized replay view
- `C1.replay_valid`

#### `Diff`
Requires:
- two replay inputs with compatible lineage
- `C2.diff_valid`

#### `Explain`
Requires:
- accepted explain payload surface
- `C3.explain_valid`

#### `Distill`
Should be labeled experimental/conditional until exact upstream evidence supports it.
Do not present as broad product entitlement until the depended-on lane path is truly available.

#### `Handoff`
Requires:
- retained source lineage,
- witness or comparison artifact,
- exact requested upstream action,
- capability floor actually relied upon.

### Suggestions

1. Add `REPLAY_FLOOR_POLICY.md` to the repo.
2. Make every replay-facing UI pane show:
   - source lane,
   - capability floor,
   - projection status,
   - registry-pinned or not,
   - Windows-only note where relevant.
3. Add a “comparison reliability badge” for Excel comparisons:
   - retained observation, lossy
   - retained observation, richer structured
   - live Windows capture
   - broad equivalence not authorized

---

## 3.7 Section 11: Persistence

### What is already clear

The spec correctly keeps persistence external and meaningful while refusing workbook graph drift.

### Clarifications needed

The major missing decision is the instance-to-envelope mapping for `SpreadsheetML 2003`.

### Suggested options

#### Option A: worksheet-per-instance mapping
Each isolated instance becomes one worksheet.
Best properties:
- easiest to understand externally,
- simplest lossless container story,
- avoids hidden inter-instance coupling,
- easiest to round-trip formatting/CF state.

This is the recommended option.

#### Option B: table-per-instance mapping within one worksheet
Possible, but introduces unnecessary layout and range-collision complexity early.

#### Option C: stacked instance blocks in one worksheet
Not recommended for initial serious scope because it makes identity, formatting, and user inspection worse.

### Recommended decision

Adopt **Option A** now:
- one workbook document contains one or more worksheets,
- each worksheet maps to one isolated OneCalc instance,
- cross-worksheet references are forbidden in initial scope,
- workbook-level features do not imply dependency graph semantics,
- workbook envelope is a storage container only.

### Additional suggestions

Create `SPREADSHEETML_2003_MAPPING_DECISION.md` and freeze:
- where formula text is stored,
- where input bindings are stored,
- where style state is stored,
- how OneCalc-only metadata is embedded,
- how unsupported workbook-level features are rejected or ignored,
- how replay/witness lineage refs are stored (inside document or sidecar only).

---

## 3.8 Section 12: Extension and add-in model

### What is already clear

This section is directionally right and appropriately conservative about OxVba.

### Clarifications needed

The contract still needs a sharper split between:

1. **OneCalc v0 native extension ABI**
2. **OxFml/OxFunc registered-external semantics**
3. **OxVba add-in/toolchain future path**

### Suggestions

#### Freeze the OneCalc-native extension story independently
Do not wait for OxVba XLL maturity.

#### Explicitly classify extension surfaces:
- `native_extension_v0`
- `registered_external_probe`
- `oxvba_embedded_runtime_future`
- `xll_packaging_future`
- `web_no_native_extensions`

#### Publish a platform honesty table
- Windows desktop: `.xll` packaging over portable ABI, later richer Windows-native paths possible
- Linux desktop: `.so` packaging over same ABI
- Browser/WASM: no native add-ins in initial serious scope

#### Ask OxVba for a “current executable consumer floor”
OneCalc needs a short answer to: “What can a downstream host rely on today, not aspirationally?”

---

## 3.9 Section 13: Hierarchical work breakdown

### What is already clear

The numbered work breakdown is good and materially better than milestone prose.

### Clarifications needed

The work breakdown should be mirrored into:
- explicit gate ids,
- artifact outputs,
- “frozen vs provisional” decisions per item.

### Suggestions

Add to every work item:
- `outputs`
- `consumes`
- `depends_on`
- `gate_kind`
- `provisionality_effect`

Example for `W1.2`:
- outputs: seam manifest, capability floor register, reviewed seam-reference set
- consumes: current OxFml/OxFunc/OxReplay/OxXlObs/OxCalc references
- gate kind: bootstrap freeze
- provisionality effect: host may proceed, but must display pinned provisional seams

---

## 3.10 Sections 14–19: Conservative upstream floor, start-now judgment, success criteria, open questions, authoritative references

### What is already clear

These sections are the best current operational reading of reality.

### Clarifications needed

1. The conservative floor should be turned into a repo-local consumable register, not remain prose only.
2. Open questions should be classified into:
   - must freeze before build,
   - can stay provisional,
   - safe to defer after first host.

### Suggested classification

#### Must freeze before repo bootstrap
1. host profile declarations and gate tables
2. first scenario schema
3. seam pin set / seam manifest
4. exact bounded reference-bearing packet taxonomy
5. replay floor actually relied on in product
6. first formatting subset
7. persistence envelope mapping
8. portable extension ABI v0 shape
9. minimum handoff packet contract

#### Can stay provisional at bootstrap but must be labeled
1. OxFunc-backed help/signature payload final contract
2. shared immutable formula-edit packet freeze
3. validated intelligent-completion result packet freeze
4. richer OxXlObs diff/equality envelope
5. formal adapter manifest for OxXlObs seam
6. broader extension/toolchain integration via OxVba

#### Safe to defer until after first real host slice
1. broader CF parity
2. richer structured-reference/table-aware CF/DV carriers
3. broad pack-grade replay claims
4. final distributed/runtime policies
5. broad Office-style add-in breadth

---

## 4. Cross-Repo Seam Matrix

| Repo | OneCalc role | Current usable floor | What is still missing | Immediate build policy |
|---|---|---|---|---|
| `OxFml` | primary evaluator / editor / host-runtime semantic owner | real single-formula host floor; host/runtime draft sufficient for first implementation planning; real editor packet layer exists | frozen shared host contract; frozen shared immutable edit packet; frozen validated completion result packet; frozen OxFunc-backed help payload path | build now against a pinned subset and record provisional seams |
| `OxFunc` | function/value semantics, metadata seed, later extension seam | library-context snapshot export is real; runtime provider/snapshot model is normative direction; W050/W051 overlays are authoritative qualifiers | consolidated downstream integration contract; help/signature payload contract; `IMAGE` rich-value end-to-end closure; broader promotion/freeze around `GROUPBY`/`PIVOTBY`, `CALL`, `REGISTER.ID` | consume snapshot export + overlays, never broad catalog alone |
| `OxReplay` | shared replay infrastructure | accepted OneCalc consumer note; honest downstream floor is OxFml through `C3`; first OxXlObs seam accepted as lossy | app-facing non-`DNA ReCalc` service contract; stronger OneCalc-facing artifact/service guidance; broader `C4/C5` story | embed only declared shared-runtime mechanics; label exact capability floor |
| `OxXlObs` | Windows Excel observation lane | real W006 live driver; W007 replay-facing seam active; retained artifacts replayable through OxReplay | dedicated OneCalc comparison contract; richer diff/equality envelope; non-lossy replay-facing structure; formal adapter-manifest decision | use as retained evidence lane with explicit lossy / Windows-only labeling |
| `OxCalc` | seam-reference owner, not runtime dependency | first implementation-backed host packet exists; downstream seam-reference note exists | OneCalc-safe narrowing of minimal packet; closure of residual caller-anchor/address-mode topics | treat as seam-reference only and sync when OneCalc pressures shared OxFml interface |
| `OxVba` | staged-later runtime/toolchain/design input | embedded runtime + partial host-export discovery; `.basproj` with `Library`/`Addin` exists; runtime profiles documented | actual frozen consumer ABI; generated XLL/add-in pipeline; non-draft add-in contract | do not block OneCalc bootstrap on OxVba maturity |

---

## 5. Clarification Packets For Each Upstream Repo

Each section below is designed to be directly reusable as prompt input.

## 5.1 Packet for `OxFml`

### Objective

Freeze the first OneCalc-safe evaluator, editor, and host/runtime subset without broadening OneCalc into an `OxCalc`-like host.

### What OneCalc needs from `OxFml`

1. A OneCalc-facing host/runtime subset derived from the current host/runtime draft.
2. An explicit taxonomy of packet kinds:
   - `ExplicitInputPacket`
   - `ReferenceProbePacket`
   - `StructuredReferenceProbePacket`
   - `RegisteredExternalProbePacket`
3. Clear statement of which fields are:
   - required for all OneCalc runs,
   - required only for bounded probe packets,
   - not part of the initial OneCalc host claim.
4. Freeze or near-freeze for:
   - immutable formula-edit request/result packet,
   - validated completion application packet/result,
   - signature-help packet shape,
   - function-help lookup request/result split,
   - host-visible returned value surface classification,
   - first host replay-capture projection.
5. Clear mapping from returned value classes to host obligations:
   - ordinary value,
   - value with presentation,
   - host/provider outcome,
   - rich value / non-ordinary value,
   - provider failure / capability denial.

### Clarifications requested

1. Which exact current host/runtime fields are mandatory for OneCalc H0/H1?
2. Which fields are only required for seam-sensitive probes?
3. Which currently exercised lanes force direct cell bindings and caller anchors?
4. What is the minimal shared packet family OneCalc should treat as semantically canonical now?
5. What exact packet should OneCalc consume for:
   - live diagnostics,
   - deterministic completion,
   - validated completion application,
   - signature help,
   - function help lookup?
6. What exact currently covered output families should OneCalc expose in UI from day one?
7. What should OneCalc do with editor packet surfaces that are real locally but not yet replay-projected?

### Requested output from `OxFml`

Please produce:
1. a **OneCalc-safe consumed subset** of `OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`,
2. an explicit **packet taxonomy** for default explicit-input runs vs bounded reference-bearing probes,
3. a **shared editor/language-service packet freeze proposal** for first host integration,
4. a **returned value / presentation / rich-value contract note** that states current host obligations cleanly,
5. a short **“not authorized for initial OneCalc claim”** list.

### Acceptance bar

The result is good enough when OneCalc can:
- implement its first host without inventing semantics,
- know which probe packets are exceptional rather than default,
- integrate editor packets without a second parser/binder truth,
- surface current non-ordinary result classes honestly,
- write a seam manifest with no ambiguous required-vs-optional fields.

---

## 5.2 Packet for `OxFunc`

### Objective

Turn the current metadata/catalog/help situation into a OneCalc-safe downstream contract without overclaiming broad function parity.

### What OneCalc needs from `OxFunc`

1. A clean statement that the current downstream metadata seed is:
   - library-context snapshot export,
   - read together with `W050` and `W051`,
   - not equivalent to broad current-version completion.
2. A help/signature payload contract that OneCalc can surface in editor UX.
3. A stable downstream interpretation of key snapshot fields such as:
   - `surface_stable_id`
   - `metadata_status`
   - `special_interface_kind`
   - `admission_interface_kind`
   - `runtime_boundary_kind`
   - `interface_contract_ref`
4. A first explicit OneCalc-facing policy for `W051` rows:
   - how they may appear in help/completion,
   - how they must be labeled in product and scenario metadata.
5. End-to-end clarification for:
   - `IMAGE`
   - `GROUPBY`
   - `PIVOTBY`
   - `CALL`
   - `REGISTER.ID`
   - `OP_IMPLICIT_INTERSECTION`

### Clarifications requested

1. Which snapshot export fields are safe for OneCalc to treat as stable now?
2. What exact shape should function-help payloads and signature payloads take?
3. How should OneCalc label `W050` vs `W051` vs function-phase-complete rows?
4. Which `W051` rows are blocked by true semantic incompleteness vs cross-repo promotion/documentation lag?
5. What is the honest current OneCalc reading of `HYPERLINK`, `IMAGE`, `GROUPBY`, and `PIVOTBY`?
6. What is the preferred transition path from export-backed ingestion to runtime provider/snapshot consumption?

### Requested output from `OxFunc`

Please produce:
1. a **OneCalc downstream metadata contract note**,
2. a **help/signature payload proposal** aligned with current snapshot/runtime model,
3. a **UI labeling policy** for `W050`, `W051`, and promoted current surface,
4. a **focused status note** for `IMAGE`, `GROUPBY`, `PIVOTBY`, `CALL`, `REGISTER.ID`, and `OP_IMPLICIT_INTERSECTION`,
5. a short **snapshot field stability guide**.

### Acceptance bar

The result is good enough when OneCalc can:
- build editor help without duplicated host prose,
- show completion/help metadata without overstating parity,
- present function-surface admission truth in UI and scenario metadata,
- avoid using the broad export as silent “everything is supported” truth.

---

## 5.3 Packet for `OxReplay`

### Objective

Give OneCalc a practical, embeddable replay-service contract while preserving `DNA ReCalc` as the generic replay host.

### What OneCalc needs from `OxReplay`

1. A clean non-`DNA ReCalc` host embedding contract.
2. In-process or wrapped service shapes for:
   - validate bundle
   - replay
   - diff
   - explain
   - distill
   - witness-state
   - pack export
3. Clear artifact-lineage requirements OneCalc must preserve.
4. A OneCalc-facing explanation of which replay modes are currently safe to expose.
5. Explicit guidance for lossy or registry-unpinned upstream inputs.

### Clarifications requested

1. What exact service surface should a downstream proving host embed?
2. Which command/result schemas from `DNA ReCalc` are the stable baseline for those services?
3. How should OneCalc expose `Distill` if the local honest floor is still uneven across lanes?
4. What exact lineage fields must OneCalc preserve in its own artifacts?
5. What exact UI/status fields are mandatory when the upstream input is lossy, provisional, or registry-unpinned?

### Requested output from `OxReplay`

Please produce:
1. a **non-`DNA ReCalc` replay service contract** for downstream hosts,
2. a **OneCalc artifact-lineage requirements note**,
3. a **current mode-gating note** for replay/diff/explain/distill/handoff in OneCalc,
4. a **lossy/provisional intake handling note**.

### Acceptance bar

The result is good enough when OneCalc can:
- embed replay features without pretending to be `DNA ReCalc`,
- preserve enough lineage for retained evidence,
- expose capability floors and projection limits clearly,
- avoid accidental promotion of `C4/C5` assumptions.

---

## 5.4 Packet for `OxXlObs`

### Objective

Define the first honest OneCalc comparison contract over retained Excel evidence.

### What OneCalc needs from `OxXlObs`

1. A dedicated downstream statement of the first comparison-ready observation family.
2. A frozen first equality/diff envelope.
3. A clear list of directly observed vs inferred surfaces in that envelope.
4. A roadmap for moving from current lossy normalized replay projection to richer diff structure.
5. A decision on whether/when a formal adapter manifest should exist.

### Clarifications requested

1. What is the first deterministic enough workbook/scenario family OneCalc should depend on?
2. Which surfaces are in the first comparison envelope:
   - raw value
   - formula text
   - display text
   - errors
   - format
   - CF/DV
   - host settings/provenance?
3. Which of those surfaces are direct, derived, unavailable, or capture-loss-labeled today?
4. What exact limits should OneCalc show in UI when consuming current retained Excel evidence?
5. What is the milestone for moving beyond the current lossy projection?

### Requested output from `OxXlObs`

Please produce:
1. a **OneCalc comparison baseline note**,
2. a **first comparison envelope definition**,
3. a **capture-loss and projection-status interpretation guide** for downstream product hosts,
4. a **roadmap note** for richer diff/equality structure.

### Acceptance bar

The result is good enough when OneCalc can:
- present Excel comparison as serious but narrow,
- tell users exactly what was compared,
- keep provenance and lossiness visible,
- avoid using current retained projections as broad semantic equivalence claims.

---

## 5.5 Packet for `OxCalc`

### Objective

Keep OneCalc aligned with the shared seam without letting OxCalc’s broader coordinator needs leak into OneCalc as product scope.

### What OneCalc needs from `OxCalc`

1. A OneCalc-safe reading of the minimal upstream host interface packet.
2. Clear separation between:
   - seam-reference fields relevant to OneCalc,
   - broader coordinator/TreeCalc fields that OneCalc should not absorb by default.
3. A sync rule for changes OneCalc pressures into shared OxFml packets.

### Clarifications requested

1. Which minimal packet fields should OneCalc treat as:
   - default host requirements,
   - bounded probe-only requirements,
   - coordinator-only reference material?
2. Which residual seam topics remain open and should therefore not silently become product assumptions?
3. What exact process should OneCalc follow when it needs a shared packet change that may also affect OxCalc docs?

### Requested output from `OxCalc`

Please produce:
1. a **OneCalc-safe seam-reference subset note** over the current minimal host interface packet,
2. a **mandatory / probe-only / coordinator-only field classification**,
3. a **seam-sync update procedure** for shared packet changes.

### Acceptance bar

The result is good enough when OneCalc can:
- stay aligned with real seam needs,
- keep its product model explicit-input and non-grid,
- avoid treating the first implementation-backed OxCalc packet as a frozen host API,
- know when to trigger cross-repo doc sync.

---

## 5.6 Packet for `OxVba`

### Objective

Clarify what OneCalc can honestly rely on now, versus what remains planned future direction.

### What OneCalc needs from `OxVba`

1. A short statement of the current executable downstream-consumer floor.
2. Explicit separation between:
   - embedded runtime today,
   - project model today,
   - add-in/XLL future work.
3. Platform constraint truth for Windows, Linux, and WASM.
4. Relationship between OneCalc portable native-extension ABI and future OxVba add-in/tooling work.

### Clarifications requested

1. What can a downstream host rely on today for embedded runtime hosting?
2. What parts of `.basproj` are stable enough to treat as directional truth?
3. What should OneCalc assume about `Library` and `Addin` outputs now?
4. What is still purely planned in XLL/add-in generation?
5. Which OxVba host-sensitive capabilities are explicitly Windows-only?

### Requested output from `OxVba`

Please produce:
1. a **current consumer floor note** for downstream product hosts,
2. a **now vs planned** split for embedded runtime, `.basproj`, XLL/add-in generation, and COM-sensitive hosting,
3. a **platform constraint note** aligned with runtime profiles.

### Acceptance bar

The result is good enough when OneCalc can:
- use OxVba as design input without overclaiming it,
- pursue its own extension ABI independently,
- know exactly which future OxVba surfaces are relevant and which are not yet consumer-grade.

---

## 6. OneCalc-Local Suggestions Before The Build

## 6.1 Create a seam manifest on day one

Recommended files:
- `SEAM_MANIFEST.md`
- `seam_manifest.json`

The seam manifest should record:
- consumed repo
- consumed document(s)
- consumed subset
- status (`frozen`, `provisional`, `reference-only`)
- reason consumed
- build impact if changed
- whether OneCalc needs to surface provisionality in UI

## 6.2 Create a function-surface policy register

Recommended file:
- `FUNCTION_SURFACE_POLICY.md`

It should define:
- `promoted_current_surface`
- `provisional_current_surface`
- `deferred_current_surface`
- `pressure_surface`

And state:
- `W050` rows are deferred,
- `W051` rows are not default product claims,
- function-phase-complete rows are eligible for promoted surface.

## 6.3 Create a replay floor policy

Recommended file:
- `REPLAY_FLOOR_POLICY.md`

It should record:
- replay capability floor relied upon
- lane-specific assumptions
- lossy/provisional intake rules
- Windows-only live comparison rule
- `Distill` / `Pack` exposure policy

## 6.4 Freeze packet kinds early

Recommended file:
- `HOST_PACKET_KINDS.md`

Freeze:
- `ExplicitInputPacket`
- `ReferenceProbePacket`
- `StructuredReferenceProbePacket`
- `RegisteredExternalProbePacket`

## 6.5 Separate “authoring state” from “evidence state”

Recommended repo split:
- `editor/`
- `scenario/`
- `replay/`
- `evidence/`
- `handoff/`

Rule:
- authoring/editor state can be ephemeral,
- evidence lineage cannot.

## 6.6 Make provisionality visible in UI

Every relevant pane should be able to show compact badges such as:
- `Promoted`
- `Provisional`
- `Deferred`
- `Windows-only`
- `Lossy`
- `Replay C3`
- `Reference probe`
- `Snapshot-backed help`

That will keep the product honest without making it ugly.

---

## 7. Recommended Immediate Execution Order

1. **Freeze OneCalc-local doctrine files**
   - seam manifest
   - host profile matrix
   - packet kinds
   - function-surface policy
   - replay floor policy

2. **Run W2 proving**
   - Leptos/Tauri/browser viability
   - keyboard and IME evidence
   - fallback/escalation rule

3. **Integrate OxFml editor packets**
   - immutable edit flow
   - diagnostics
   - completion
   - signature help

4. **Integrate OxFunc snapshot-backed help/catalog**
   - never without W050/W051 overlay policy

5. **Stand up H0 path**
   - formula -> parse/bind/evaluate -> typed result -> replay capture

6. **Stand up H1 explicit-input path**
   - explicit bindings
   - typed host queries
   - visible host profile
   - bounded reference-bearing probe packet support

7. **Stand up replay UI**
   - validate
   - replay
   - diff
   - explain
   - visible capability floor

8. **Stand up retained Excel comparison**
   - Windows live path labeled
   - retained lossy path labeled
   - narrow equality envelope only

9. **Freeze SpreadsheetML 2003 instance mapping**
   - worksheet-per-instance recommended

10. **Only then widen into extensions**
   - ABI first
   - packaging second
   - OxVba integration later

---

## 8. Risk Register

## 8.1 Biggest architectural risk

**Silent drift from explicit-input host toward de facto worksheet engine.**

Mitigation:
- freeze packet kinds,
- forbid open reference maps,
- mark bounded probes explicitly,
- keep OxCalc seam docs reference-only for broader coordinator lanes.

## 8.2 Biggest UX risk

**Building a slick formula editor that quietly diverges from OxFml truth.**

Mitigation:
- all semantic editor surfaces must be OxFml-derived,
- host owns interaction/presentation only.

## 8.3 Biggest product honesty risk

**Using OxFunc catalog export or OxXlObs replay view as broader support truth than they really are.**

Mitigation:
- require overlay/policy interpretation for OxFunc,
- require lossy/provisional labeling for OxXlObs comparison paths.

## 8.4 Biggest replay risk

**Treating replay embedding in OneCalc as if OneCalc itself were the canonical replay host.**

Mitigation:
- treat `DNA ReCalc` as the generic host contract,
- embed services, do not rename that embed layer into doctrine.

## 8.5 Biggest extension risk

**Waiting for OxVba maturity before defining OneCalc’s own extension ABI.**

Mitigation:
- define portable C ABI now,
- integrate OxVba later where it fits.

---

## 9. Final Recommendations

## 9.1 What should be frozen before the OneCalc repo starts real implementation

Freeze now:
1. OneCalc seam manifest
2. host profile and packet-kind matrix
3. function-surface policy
4. replay floor policy
5. first formatting subset
6. first comparison envelope policy
7. SpreadsheetML 2003 worksheet-per-instance mapping
8. minimum handoff packet schema

## 9.2 What should stay provisional but be tracked explicitly

Keep provisional:
1. final OxFml shared immutable edit packet freeze
2. final OxFunc help/signature payload contract
3. final richer OxXlObs diff/equality envelope
4. OxReplay app-facing non-`DNA ReCalc` service freeze
5. OxVba add-in/XLL integration

## 9.3 What should not block the build

Do not block on:
1. broad pack-grade replay claims
2. broad `C4/C5` assumptions
3. full Excel parity
4. rich OxVba add-in generation
5. broad formatting/CF parity
6. broad structured-reference/table-aware comparison coverage

## 9.4 Practical summary

Start the repo now, but start it as a **host with pinned provisional seams**, not as a host pretending those seams are already final.

The most important implementation discipline is this:

> Every place where OneCalc consumes a real upstream surface that is not yet frozen should be recorded, named, and surfaced — never silently normalized into a fake certainty layer.

That discipline is what will let OneCalc do exactly what the spec wants it to do: become a serious product and a productive upstream pressure surface at the same time.

---

## 10. Compact Checklist For Repo Bootstrap

Use this as a bootstrap closeout checklist.

- [ ] `SEAM_MANIFEST.md` exists
- [ ] `HOST_PROFILE_MATRIX.md` exists
- [ ] `HOST_PACKET_KINDS.md` exists
- [ ] `FUNCTION_SURFACE_POLICY.md` exists
- [ ] `REPLAY_FLOOR_POLICY.md` exists
- [ ] `DISPLAY_AND_FORMAT_MODEL.md` exists
- [ ] `SPREADSHEETML_2003_MAPPING_DECISION.md` exists
- [ ] `SCENARIO_SCHEMA.md` exists
- [ ] `HANDOFF_PACKET_SCHEMA.md` exists
- [ ] `PROVISIONALITY_BADGE_POLICY.md` exists
- [ ] `EDITOR_CONSUMPTION_RULES.md` exists
- [ ] `COMPARISON_RELIABILITY_POLICY.md` exists

If all of those exist before the first real host slice, OneCalc should be able to build quickly without losing honesty.