# DNA OneCalc Scope And Host Profile Plan

Run id: `20260326-200003-dna-onecalc-scope-pass-01`

## Scope decision
`DnaOneCalc` should be started as a downstream host repo, not as a new semantics lane.

It should also be treated as:
1. a co-development program for the `Ox*` repos,
2. a structured downstream scope-discovery and spec-discovery program,
3. a retained-evidence producer that generates explicit upstream requirements and work requests rather than consuming a frozen snapshot of the libraries.

Its job is to make one isolated Excel-like calculation instance real:
1. author a formula,
2. evaluate it through `OxFml` + `OxFunc`,
3. show the result and effective display state in a serious user-facing application,
4. capture replay evidence through `OxReplay`,
5. compare and grow scenario truth against Excel through `OxXlObs`,
6. later admit staged extension surfaces such as `.xll` and `OxVba`-based UDF paths.

It should not start life as:
1. a mini spreadsheet grid engine,
2. an `OxCalc` host,
3. a hidden replay harness with a thin UI on top,
4. a product claim of "Excel except for some missing pieces."

The coherent product statement is:
`DNA OneCalc` is "Excel as a single calculation node with explicit host context and first-class replay."

The strongest strategic direction for the repo is:
`DNA OneCalc` as a `Twin Oracle Workbench`.

Meaning:
1. an interactive semantic laboratory for the stack,
2. one place to author a formula, run `DNA-only`, compare against Excel-observed truth on Windows, inspect replay traces, diff/explain outcomes, distill witnesses, and emit upstream-ready handoff packets,
3. with `Live Formula Semantic X-Ray` as the primary product surface:
   - parse tree,
   - evaluation trace,
   - semantic diff,
   - provenance.

## Dependency constitution
Primary runtime dependencies:
1. `OxFml`
2. `OxFunc`
3. `OxReplay`

Primary empirical validation dependency:
1. `OxXlObs` for Windows-only Excel-facing empirical validation

Staged later dependency:
1. `OxVba`

Explicit non-dependency for the initial repo mission:
1. `OxCalc`

Interpretation rule:
1. `DnaOneCalc` owns product shell, host policy, UI, persistence, and scenario orchestration.
2. It consumes lane semantics.
3. It must not redefine formula, function, replay, or VBA semantics locally.
4. It should not be framed as "freeze the current libraries and merely validate them."
5. It should generate explicit requirement deltas, seam clarifications, and actionable upstream requests as part of normal work.

## Recommended initial product shape
`DnaOneCalc` should start as a host-profile ladder over a single-node substrate.

### OC-H0: Literal and function core
Use this to stand up the repo honestly and quickly.

In scope:
1. formula string input,
2. parse/bind/evaluate/result path through `OxFml` + `OxFunc`,
3. built-in functions that need no external provider or workbook state,
4. explicit locale/date-system context,
5. full format-string support and formatted-display projection,
6. replay capture for every executed scenario,
7. attractive result presentation and keyboard-first editing.

Out of scope:
1. references,
2. defined names,
3. host queries,
4. external/UDF providers,
5. `.xll`,
6. VBA-backed functions.

### OC-H1: Explicit-input host
Use this for the first serious Excel-like host truth.

In scope:
1. one authoritative formula under test,
2. explicit host-bound input slots surfaced by stable symbols,
3. typed host query/profile input,
4. optional bounded caller-context or anchor packet only for specifically admitted seam-sensitive scenarios,
5. explicit recalc trigger,
6. replay-visible candidate, commit, reject, and host-context consequences,
7. explicit cell-like base formatting state for the isolated instance,
8. conditional-formatting rule sets attached to the isolated instance.

Important rule:
1. the default product claim must not expose a generic cell environment, workbook-style name manager, or open reference-binding map,
2. if a later empirical lane truly needs caller-sensitive or anchor-sensitive context, it should be admitted only as a bounded proving-mode packet,
3. this still does not imply workbook graph semantics.

### OC-H2: Host extensions and add-ins
Use this to widen into real external function surfaces without drifting into a spreadsheet engine.

In scope:
1. registered external providers,
2. portable C-ABI desktop add-in functions,
3. Windows `.xll` and Linux `.so` host packaging over that ABI,
4. `OxVba`-based VBA-to-`.xll` shim paths on Windows and equivalent Linux shared-library packaging when the upstream toolchain supports it,
5. replay-visible extension invocation and capability state,
6. desktop-only add-in loading for Windows and Linux.

Out of scope for the initial honest claim:
1. workbook macro model,
2. scheduler semantics,
3. arbitrary Office add-in breadth,
4. fake web parity for native add-ins.

## Formatting and conditional formatting scope
Formatting must be first-class in the product plan.

The intended support shape is:
1. full format-string support for displayed values,
2. persisted base cell-formatting state for isolated instances,
3. fonts where cross-platform mapping is explicit and honest,
4. colors,
5. effective-format and effective-display projection,
6. full conditional-formatting support within the isolated-instance model.

Authority split:
1. `OxFml` owns semantic formatting, formatting-sensitive evaluator behavior, and conditional-formatting formula-carrier semantics where those are formula-significant,
2. `DnaOneCalc` owns persisted style state, effective-format computation in the product host, rendering, and honest cross-platform declaration,
3. `OxReplay` must see formatting-significant and conditional-formatting-significant scenario consequences,
4. `OxXlObs` is the empirical comparison source for Excel-facing formatting and conditional-formatting truth.

Important rule:
1. base formatting and conditional formatting do not imply a workbook dependency graph,
2. they are attached to isolated result/input presentation surfaces inside a single instance,
3. grid-wide precedence and large workbook style systems remain later and explicit work rather than hidden scope creep.

## Product and host architecture
The repo should be organized around a product host split, not around the lane split.

### Layer model
1. `OneCalc application core`
   - session state,
   - host profile management,
   - command model,
   - replay/scenario orchestration,
   - persistence mapping.
2. `Leptos UI application`
   - primary web UI framework for desktop and browser hosts,
   - deliberate proving lane for `Leptos` in this program rather than an already-settled assumption,
   - interactive editing, display, and replay control surfaces,
   - shared UI/state model across desktop and browser hosts.
3. `Evaluation host adapter`
   - consumes `OxFml` host packet and `OxFunc` runtime/library context seams,
   - assembles evaluation requests,
   - receives typed result and trace consequences,
   - projects them into app state.
4. `Replay adapter`
   - emits retained replay bundles and witness candidates through `OxReplay`,
   - imports retained Excel-facing or sibling-produced bundles for compare/explain.
5. `Product shells`
   - Tauri desktop shell for Windows and Linux over the shared `Leptos` UI,
   - browser/WASM shell over the same `Leptos` UI and application core,
   - optional later non-UI/WASI or CLI harness.

### Platform rule
Do not pretend Tauri is the web host.

The intended split is:
1. shared `Leptos` app/UI model below,
2. desktop shell above,
3. browser shell above,
4. optional WASI harness beside them.

### Multi-instance rule
The app may present multiple visible instances.

Initial restriction:
1. instances remain semantically isolated,
2. no inter-instance references,
3. no shared recalc graph,
4. copy/paste and file-level management are allowed.

## Editing and UX scope
The app should be a serious formula workstation from the first product slice.

Priority areas:
1. formula editing with immediate parse/bind diagnostics,
2. live error highlighting,
3. keyboard-first command flow,
4. result surfaces that make value shape, type, and effective formatting obvious,
5. visible host-profile and replay-state indicators,
6. visible conditional-formatting consequences,
7. live formula semantic X-ray views:
   - parse tree,
   - evaluation trace,
   - semantic diff,
   - provenance,
8. full replay capture/replay/diff/explain control in the UI,
9. fast scenario capture and replay inspection.

Completion/help should be treated as a first-wave investigation area, not as a deferred luxury.

## Persistence scope
The initial file format should be `SpreadsheetML 2003`.

Why this is the right first target:
1. it is externally meaningful,
2. it is much simpler than OOXML,
3. it matches the Foundation reference-library direction already being built out.

Recommended working direction:
1. a `DnaOneCalc` document may contain one or more isolated instances,
2. the workbook envelope is used as a container, not as permission to introduce workbook graph semantics,
3. each instance should map to a stable isolated payload inside that workbook envelope,
4. formatting state and conditional-formatting rules must round-trip with the instance,
5. the exact worksheet/region/envelope mapping should be resolved in a dedicated persistence pass before bootstrap hardens.

## Replay and scenario-library doctrine
Replay is not optional product garnish. It is one of the project's reasons to exist.

`DnaOneCalc` should be the first user-facing host that makes the following routine:
1. author scenario in-app,
2. run it,
3. emit retained replay evidence,
4. compare it with Excel-facing evidence,
5. explain mismatches,
6. retain minimized witnesses.

That is the core of the `Twin Oracle Workbench` direction.

Required directions:
1. `DnaOneCalc -> OxReplay -> compare to OxXlObs/Excel evidence`
2. `OxXlObs/Excel capture -> OxReplay -> replay/explain against DnaOneCalc`

Windows-only rule:
1. live Excel-facing comparison and `OxXlObs`-driven empirical lanes are Windows-only,
2. Linux desktop and browser/WASM hosts must not imply live Excel-comparison availability.

Required scenario families from the first serious milestone:
1. formula-language edge cases,
2. function-semantic cases,
3. formatting-sensitive cases,
4. base-formatting and effective-display cases,
5. conditional-formatting cases,
6. host-profile-sensitive cases,
7. later extension/UDF cases.

The retained scenario library should also produce:
1. structured upstream requirement deltas,
2. seam clarification requests,
3. repo-addressable work packets for the upstream `Ox*` repos.

## Recommended dependency tree and explicit gates
The repo can start now, but planning should be expressed as dependencies plus gates, not as a simple milestone ladder.

Gate naming rule:
1. every dependency node should have an explicit entry gate,
2. those gates need stable identifiers and evidence requirements,
3. the identifiers do not need to use `PACK.*` naming if a cleaner repo-local convention is preferred.

### D0: Host charter and gate model
Depends on:
1. Foundation doctrine,
2. current `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs` seam inventory.

Gate:
1. explicit host-profile declarations,
2. acceptance/degradation or equivalent gate tables,
3. dependency tree publication,
4. upstream seam pins.

### D1: UI/runtime proving spike
Depends on:
1. `D0`.

Gate:
1. `Leptos` + desktop shell + browser/WASM proof of life,
2. keyboard/IME viability check,
3. measured bundle/runtime evidence,
4. explicit fallback or escalation rule if the spike is not convincing.

### D2: H0 evaluation path
Depends on:
1. `D0`,
2. `D1`,
3. pinned `OxFml` and `OxFunc` seams.

Gate:
1. formula string -> parse/bind/evaluate -> typed result,
2. visible host profile,
3. one retained executed scenario.

### D3: Replay capture baseline
Depends on:
1. `D2`,
2. pinned `OxReplay` seam.

Gate:
1. every executed scenario can emit a replay artifact,
2. replay capture is visible in the UI,
3. retained replay artifacts validate through `OxReplay`.

### D4: Live Formula Semantic X-Ray baseline
Depends on:
1. `D2`,
2. `D3`.

Gate:
1. parse tree is visible,
2. evaluation trace is visible,
3. provenance is visible,
4. replay/diff/explain flows are reachable from the same workbench.

### D5: Explicit-input host packet
Depends on:
1. `D2`,
2. `D3`.

Gate:
1. stable explicit input-slot model,
2. typed host queries or profile inputs,
3. no slide into a generic cell/reference environment.

### D6: Formatting and effective-display baseline
Depends on:
1. `D5`,
2. current upstream formatting seams.

Gate:
1. base formatting state is explicit,
2. effective-display projection is honest,
3. formatting-significant scenarios are retained.

### D7: SpreadsheetML 2003 persistence baseline
Depends on:
1. `D5`,
2. `D6`,
3. resolved instance-to-envelope mapping.

Gate:
1. isolated instances round-trip,
2. formatting state round-trips,
3. persistence does not imply workbook-graph semantics.

### D8: Conditional-formatting baseline
Depends on:
1. `D6`,
2. `D3`,
3. current upstream CF carrier floor.

Gate:
1. isolated-instance conditional-formatting rules work,
2. consequences are replay-visible,
3. retained CF scenario family exists.

### D9: Windows twin-oracle comparison baseline
Depends on:
1. `D4`,
2. `D6`,
3. `OxXlObs`.

Gate:
1. Windows-only Excel-observed compare path works,
2. first retained comparison family exists,
3. first upstream-ready mismatch or handoff packet exists.

### D10: Portable extension ABI baseline
Depends on:
1. `D5`,
2. `OxFunc` registered-external seam,
3. staged `OxVba` readiness.

Gate:
1. desktop extension contract is specified as portable C ABI,
2. Windows `.xll` loader works,
3. Linux `.so` loader works over the same declared ABI,
4. hosted web and browser/WASM remain explicitly without native add-in support.

## Initial repo worksets
Recommended starting workset set:

1. `W001_REPO_BOOTSTRAP_AND_CONSTITUTION`
   - charter, operations, blockers, notes, workset register, repo layout.
2. `W002_APPLICATION_CORE_AND_H0_EVALUATION`
   - app state, `Leptos` UI shell, evaluation command, result surface, host-profile declaration.
3. `W003_REPLAY_CAPTURE_AND_SCENARIO_BASELINE`
   - retained replay output plus full in-app replay visibility and control from the first host flows.
4. `W003A_LIVE_FORMULA_SEMANTIC_XRAY_AND_MODE_CONTRACT`
   - explicit `DNA-only`, `Excel-observed`, `Twin compare`, `Replay`, `Diff`, `Explain`, `Distill`, and `Handoff` product modes, plus parse-tree, evaluation-trace, semantic-diff, and provenance surfaces.
5. `W004_OC_H1_EXPLICIT_INPUT_HOST_PACKET`
   - explicit host-bound inputs, typed host queries, profile visibility, and any narrowly admitted anchor-sensitive proving packet.
6. `W005_CELL_FORMATTING_AND_EFFECTIVE_DISPLAY_BASELINE`
   - format strings, base formatting state, honest font/color subset, effective-display projection.
7. `W006_SPREADSHEETML_2003_PERSISTENCE_BASELINE`
   - first round-trip persistence for isolated instances with formatting state.
8. `W007_CONDITIONAL_FORMATTING_BASELINE`
   - full conditional-formatting support for isolated instances plus replay-visible rule outcomes.
9. `W008_EXCEL_COMPARISON_BASELINE`
   - first retained Windows-only `OxXlObs`-backed scenario comparison family, including formatting or conditional-formatting truth.
10. `W009_PORTABLE_EXTENSION_ABI_AND_REGISTERED_EXTERNAL_SEAM`
   - staged desktop-only UDF/add-in lane over a portable C ABI, with Windows `.xll`, Linux `.so`, and hosted web/browser/WASM out of scope initially.
11. `W010_UPSTREAM_REQUIREMENTS_AND_HANDOFF_BASELINE`
   - requirement deltas, seam clarifications, and repo-addressable work requests for upstream `Ox*` repos.

## Start-now judgment
`DnaOneCalc` should be started now.

That judgment is honest because:
1. `OxFml` already has a real single-formula host floor,
2. `OxFml` already has semantic-formatting work and an initial conditional-formatting/data-validation carrier floor,
3. `OxFunc` already has a real library-context export, callable/runtime seam, replay bundle, and early registered-external seam,
4. `OxReplay` is already a working tool/runtime,
5. `OxXlObs` already has a retained live Excel evidence lane.

What must remain explicit when bootstrapping:
1. `OxFml` and `OxFunc` host seams are good enough to integrate against, but not yet a forever-frozen final ABI,
2. base formatting can be first-wave, but broader conditional-formatting parity still needs careful staged widening,
3. the first product claim should use explicit host-bound inputs rather than an open cell/reference environment,
4. any caller-sensitive or anchor-sensitive packet must remain a bounded proving lane rather than a quiet slide toward OxCalc,
5. replay must be fully visible and controllable through the UI rather than hidden behind sidecar tooling,
6. `OxXlObs` and live Excel comparison are Windows-only,
7. desktop add-in support is a Windows `.xll` plus Linux `.so` lane over a portable C ABI, while hosted web and browser/WASM start without add-in support,
8. `.xll` and `OxVba` support are staged later,
9. `OxCalc` is not required for the initial repo claim,
10. replay and retained scenarios are first-wave architecture, not post-v1 cleanup,
11. the primary product expression should be `Live Formula Semantic X-Ray`, not only a calculator-like result pane,
12. planning should use a dependency tree plus explicit gates rather than a linear milestone ladder.

## Main open questions
1. What exact runtime split should the repo use between the core host/runtime and the chosen `Leptos` UI layer?
2. What is the minimal honest cell-formatting model for isolated instances, including fonts and colors?
3. What is the right first full conditional-formatting scope for a single-node host?
4. What is the minimal honest SpreadsheetML 2003 mapping for isolated instances with formatting state?
5. What is the first retained formatting or conditional-formatting scenario family that should be promoted as the repo's proving spine?
6. Which `OxFml` and `OxFunc` seam versions should be pinned on day one?
7. What exact replay, trace, diff, and provenance surfaces must be available in the first `Leptos` UI wave?
8. Does the project need any caller-sensitive or anchor-sensitive proving packet at all, and if so how narrowly should it be bounded?
9. What exact portable C-ABI extension contract should support Windows `.xll` and Linux `.so` while leaving hosted web and browser/WASM without add-ins initially?
