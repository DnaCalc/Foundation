# DNA OneCalc Initial Scope

Status: `initial_scope_note`
Date: 2026-03-26

## 1. Purpose
This note expands the current Foundation notion of `DNA OneCalc` into an initial host-project scope.

It is not yet:
1. a repo charter,
2. a full product specification,
3. a lane-semantic authority document.

It is a Foundation planning note intended to make the next repo and research pass coherent before a repo is created.

## 2. Role In The Program
`DNA OneCalc` is a downstream proving and application host.

It is the first serious host for:
1. `OxFml` formula-language and evaluator semantics,
2. `OxFunc` value and function semantics,
3. `OxReplay` trace, replay, diff, explain, and witness flows in a real user-facing formula app,
4. optional early `OxVba`-backed UDF and add-in integration on a single-node substrate.

It is also intended as:
1. a structured scope-discovery and spec-discovery program for the `Ox*` libraries,
2. a co-development surface that produces explicit requirements, retained evidence, and usage requests for repo-bound agents working in the upstream repos,
3. more than a downstream usage and validation shell over a frozen set of library versions.

It is not:
1. a replacement for `OxFml`, `OxFunc`, or `OxReplay`,
2. a general spreadsheet host,
3. a multi-node or scheduling host,
4. an `OxCalc` proving host.

`DNA OneCalc` should be read as:
1. "Excel if only a single calculation cell or defined name existed,"
2. with enough host context to make single-node semantic truth meaningful,
3. but without a workbook graph or coordinator semantics.

## 3. Core Mission
The core mission of `DNA OneCalc` is:
1. accept a formula string of arbitrary supported complexity,
2. evaluate it with `OxFml` + `OxFunc` semantics,
3. present the result and its effective display state in an attractive interactive host,
4. capture replayable evaluation evidence through `OxReplay`,
5. compare and replay those scenarios against Excel through `OxXlObs`,
6. grow a durable single-node scenario corpus that validates the stack against Excel.

The project exists to close the gap between:
1. repo-local evaluator/function fixtures,
2. host-facing real usage,
3. retained replay/evidence workflows,
4. user-facing product shape.

Strategic direction:
1. `DNA OneCalc` should become the stack's `Twin Oracle Workbench`,
2. meaning an interactive semantic laboratory where `DNA` behavior, Excel-observed behavior, replay artifacts, diff/explain flows, and upstream handoff generation come together in one place,
3. with `Live Formula Semantic X-Ray` as the primary product expression of that direction:
   - parse tree,
   - evaluation trace,
   - Excel comparison on Windows,
   - provenance links back to evidence, specs, and open questions.

## 4. Dependency Model
Primary dependencies:
1. `OxFml`
2. `OxFunc`
3. `OxReplay`

Validation and empirical dependencies:
1. `OxXlObs` for Windows-only Excel-facing empirical comparison

Optional or staged dependencies:
1. `OxVba` for VBA-backed UDF and `.xll` shim integration

Explicit non-dependency for initial semantic scope:
1. `OxCalc`

Interpretation rule:
1. `DNA OneCalc` consumes lane semantics,
2. it does not redefine them,
3. any host policy must remain visibly downstream of the authoritative lane docs,
4. the repo is not intended to freeze the current `Ox*` libraries and merely validate them,
5. it is intended to generate structured downstream pressure, retained evidence, and actionable upstream work requests.

## 5. Coherent Initial Semantic Scope
The coherent initial scope is not "full Excel minus some things."
It is a staged host-profile ladder on a single-node substrate.

### 5.1 Host Profile OC-H0: Literal And Function Core
Purpose:
1. stand up the narrowest honest host shape,
2. prove formula-string -> parse/bind/evaluate/result/replay end to end.

Allowed:
1. literals,
2. operators,
3. built-in functions with no external host context,
4. locale/date-system context,
5. full format-string support and formatting-sensitive result rendering where the semantics are already owned by `OxFml` / `OxFunc`,
6. first cell-like display formatting for the isolated result surface.

Disallowed:
1. cell references,
2. defined names,
3. host queries,
4. add-ins,
5. VBA-backed functions,
6. general workbook state.

### 5.2 Host Profile OC-H1: Explicit-Input Host
Purpose:
1. let `DNA OneCalc` exercise the single-node host boundary that current `OxFml` docs already anticipate.

Allowed:
1. one formula under test,
2. explicit host-bound input slots surfaced by stable symbols,
3. typed host-query/profile input,
4. optional bounded caller-context or anchor packet only where a specifically admitted seam-sensitive scenario requires it,
5. explicit recalc trigger and replay capture,
6. display and format consequences that are seam-significant,
7. explicit base cell formatting and effective-display projection for the isolated instance,
8. conditional-formatting rules attached to the isolated host instance.

Working rule:
1. the default product claim must not expose a generic cell environment, workbook-style name manager, or open reference-binding map,
2. if some seam-sensitive empirical lane later requires caller-sensitive or anchor-sensitive context, that should be admitted only as a bounded proving-mode packet,
3. DNA OneCalc must stay visibly narrower than OxCalc even when it carries narrow context packets.

Disallowed:
1. upstream formula dependency graphs,
2. multi-node recalculation,
3. scheduler policy,
4. workbook-wide structural edits,
5. cross-instance interaction.

### 5.4 Formatting And Conditional Formatting Plane
Formatting support should be treated as first-class host scope, not as a late cosmetic layer.

This includes:
1. full format-string support,
2. persisted base cell-formatting state for the isolated instance,
3. fonts where cross-platform mapping is explicit and honest,
4. colors,
5. effective-display projection,
6. full conditional-formatting support within the isolated-instance model.

Authority split:
1. `OxFml` remains authoritative for semantic formatting, formatting-sensitive formula behavior, and conditional-formatting formula carriers where those are formula-semantic,
2. `DNA OneCalc` owns persisted style state, UI rendering, effective-format computation in the product host, and honest cross-platform capability declaration,
3. UI-only styling must not be smuggled into evaluator semantics,
4. conditional formatting remains host-managed but replay-visible.

Important rule:
1. formatting and conditional formatting do not imply a workbook dependency graph,
2. they apply to isolated host instances and their cell-like display surfaces,
3. richer workbook-wide precedence and grid-style interaction remain out of initial scope until explicitly modeled.

### 5.3 Host Profile OC-H2: Host Extensions And Add-ins
Purpose:
1. introduce external function surfaces without turning `DNA OneCalc` into a full spreadsheet engine.

Allowed:
1. portable C-ABI desktop add-ins that register extra functions,
2. host-declared add-in manifests,
3. Windows `.xll` packaging and Linux `.so` packaging over the same declared extension ABI,
4. `OxVba`-based VBA-to-`.xll` shim paths on Windows and equivalent Linux shared-library packaging when the upstream toolchain supports it,
5. replay capture across built-in and extension calls.

Working rule:
1. host extension support is still single-node and host-mediated,
2. it does not imply workbook macro or scheduler semantics,
3. the extension path must remain replay-visible and capability-explicit,
4. first-wave add-in support is desktop-only with a portable C ABI contract,
5. Windows uses native `.xll` packaging while Linux uses native `.so` packaging over the same declared extension ABI,
6. hosted web and browser/WASM hosts begin without add-in support.

### 5.4 Explicitly Out Of Initial Scope
1. workbook graph semantics,
2. multi-node dependency closure,
3. general cell-grid editing,
4. cross-instance formulas or links,
5. collaboration,
6. full Excel file compatibility,
7. silent fallback from unsupported semantics to host-invented behavior.

## 6. UI And Application Scope
`DNA OneCalc` should be a serious app, not only a harness.

Initial UI goals:
1. formula entry with live parse/bind/error feedback,
2. clear keyboard-first editing flow,
3. attractive and dynamic result presentation with effective formatting,
4. optional multiple visible calculation instances,
5. copy/paste and file save/load,
6. full replay/trace visibility and controllability for debugging, scenario capture, replay, diff, explain, and witness use,
7. visible conditional-formatting consequences where rules are active.

### 6.1 UI Runtime Shape
The coherent UI/runtime model is:
1. shared `Leptos` web UI and state model,
2. Tauri desktop shell for Windows and Linux over that `Leptos` UI,
3. browser/WASM host using the same `Leptos` frontend and host adapters,
4. optional WASI-oriented non-UI or harness host later.

Important rule:
1. do not pretend Tauri itself is the cross-platform answer for web,
2. `Leptos` is the chosen web UI framework for the app,
3. the repo is also an intentional proving ground for `Leptos` in this program, so the UI stack should be treated as a deliberate experimental lane with explicit evidence and fallback criteria rather than as an unquestioned premise,
3. the shared application core must sit below the desktop shell,
4. desktop and web are separate hosts over a shared UI/runtime core.

### 6.2 Interaction Focus Areas
Priority UX areas:
1. live syntax and bind diagnostics,
2. completion/help surfaces where they materially reduce formula-authoring friction,
3. result visualization that makes value shape, type, and effective formatting obvious,
4. great keyboard navigation and command flow,
5. explicit indication of host profile, replay mode, and extension state,
6. full replay control surfaces exposed in-app rather than hidden behind CLI-only tooling.

### 6.3 Multi-Instance Rule
The app may show multiple isolated calculation instances at once.

Initial rule:
1. instances do not interact semantically,
2. no inter-instance references or shared recalc graph,
3. copy/paste and file-level management are allowed.

## 7. Persistence Scope
Initial persistence target:
1. Excel 2003 XML Spreadsheet (`SpreadsheetML 2003`) as the first checked file format.

Reason:
1. it is simple enough to start with,
2. it gives a real external format,
3. it avoids overcommitting to OOXML too early.

Initial working shape:
1. a `DNA OneCalc` document may contain one or more isolated instances,
2. each instance should persist in a workbook-like representation without implying a live multi-node dependency graph,
3. formatting state and conditional-formatting rules for each instance must persist and round-trip,
4. if multiple instances are persisted together, they remain isolated by policy.

Open mapping question:
1. whether each instance maps to a worksheet, a named sheet-local region, or a narrower host-specific envelope inside SpreadsheetML should be resolved in the research run before repo bootstrap.

## 8. Add-in And UDF Scope
Add-in support is a first-class concern, but it must be staged honestly.

### 8.1 Desktop-Native Add-ins
Desktop-only initial extension target:
1. native add-in loading and function registration for desktop hosts over a declared portable C ABI,
2. Windows uses `.xll`,
3. Linux uses `.so`.

Why:
1. it creates a clean bridge into `OxFunc` callable surfaces and `OxVba`-backed add-ins,
2. desktop hosts are the only coherent first-wave add-in targets.

Important rule:
1. the desktop add-in loader and ABI contract must be specified explicitly,
2. the portability claim is about the C ABI and host contract, not about literal reuse of Windows `.xll` binaries on Linux,
3. hosted web and browser/WASM hosts do not participate in this lane initially.

### 8.2 OxVba-Based VBA To XLL Shim
Planned scope:
1. support Windows `.xll` add-ins produced by an `OxVba`-based VBA-to-`.xll` shim,
2. allow the equivalent Linux `.so` form over the same portable C ABI where the upstream toolchain supports it,
3. thereby allow VBA-authored UDF surfaces to participate in the single-node host.

This remains:
1. a host integration surface,
2. not a claim that `DNA OneCalc` owns VBA semantics.

### 8.3 Web/WASM/WASI Constraint
Native desktop add-in loading is not a coherent direct target for browser/WASM hosts.

Therefore:
1. desktop native loading is first-class,
2. hosted web and browser/WASM hosts start with no add-in support,
3. web/WASM hosts may later use a declared alternative such as:
   - predeclared function catalogs,
   - replayed extension behavior,
   - remote/native bridge later,
4. do not hide native-loading absence behind fake parity claims.

## 9. Replay And Scenario-Library Scope
This is a defining project focus, not a sidecar.

`DNA OneCalc` should be the first user-facing host that proves:
1. `OxReplay` can trace through real `OxFml` + `OxFunc` evaluations,
2. those traces can be retained as replay bundles and witnesses,
3. scenarios can be replayed or compared against Excel-facing captures through `OxXlObs`,
4. the same scenario corpus can serve authoring, regression, diff, explain, and witness-distillation flows.

Replay is not only an artifact plane.
It must also be a first-class interactive product surface.

Named direction:
1. the app should evolve into a `Twin Oracle Workbench`,
2. where a user can run `DNA-only`, `Excel-observed` on Windows, `Twin compare`, `Replay`, `Diff`, `Explain`, `Distill`, and `Handoff` flows from one place,
3. and where the `Live Formula Semantic X-Ray` is the central surface rather than a side panel:
   - parse tree,
   - evaluator trace,
   - semantic diff,
   - provenance.

### 9.1 Required Replay Capabilities
Initial `DNA OneCalc` planning should assume:
1. replay capture is built in from the start,
2. replay output is optional in the fast path but first-class in the architecture,
3. every meaningful scenario can be turned into a durable witness candidate,
4. replay capture, replay execution, diff, explain, witness inspection, and retained-scenario promotion are fully visible and controllable through the UI,
5. parse-tree, evaluation-trace, and provenance views are first-class UI surfaces in the same workbench.

### 9.2 Scenario Library Goals
The scenario library should grow across:
1. formula-language edge cases,
2. function semantics,
3. host-profile differences,
4. formatting-significant cases,
5. base-formatting and effective-display cases,
6. conditional-formatting cases,
7. add-in/UDF cases,
8. Excel empirical comparison cases.

The scenario library should also generate:
1. structured requirement deltas,
2. upstream seam clarification requests,
3. executable work requests for repo-bound agents in the upstream `Ox*` repos.

### 9.3 Comparison Direction
The architecture should support both:
1. `DNA OneCalc` -> `OxReplay` -> compare to Excel/OxXlObs evidence,
2. Excel/OxXlObs capture -> `OxReplay` -> replay/explain against `DNA OneCalc`.

Windows-only rule:
1. Excel-facing and `OxXlObs`-driven comparison lanes are Windows-only,
2. desktop Linux and browser/WASM hosts must not imply live Excel-comparison availability.

### 9.4 Delivery Framing
Planning should be expressed as a dependency tree with explicit gates, not as a simple milestone ladder.

Required rule:
1. each major capability must name its dependencies and entry gate explicitly,
2. gates need stable identifiers and evidence requirements,
3. the identifiers do not need to use `PACK.*` naming if the repo adopts a clearer local gate convention.

## 10. Initial Repo Shape
The eventual `DnaOneCalc` repo should likely be a host repo, not a semantics lane.

Likely top-level areas:
1. host/runtime core,
2. `Leptos` UI application,
3. desktop Tauri shell,
4. browser/WASM shell,
5. formatting and conditional-formatting pipeline,
6. persistence adapters,
7. replay/scenario tooling,
8. portable C-ABI extension hosting,
9. retained host scenarios and outputs,
10. upstream requirements and handoff packets.

This note does not yet lock:
1. package names,
2. exact host/runtime package boundaries below the chosen `Leptos` UI layer,
3. exact repo skeleton.

## 11. Success Criteria For The First Serious Scope
The first serious `DNA OneCalc` scope should be considered real only when all of the following are true:
1. the dependency tree and explicit gate set are published,
2. a formula string can be entered and evaluated through `OxFml` + `OxFunc`,
3. the host profile is explicit and visible,
4. base formatting and effective-display state are visible and honest,
5. replay output can be emitted for at least one nontrivial scenario family,
6. at least one retained scenario family is validated against Excel-facing evidence through `OxXlObs`,
7. at least one retained formatting or conditional-formatting family exists,
8. the UI is usable and keyboard-first,
9. persisted documents round-trip through the declared initial file format with formatting state intact,
10. replay capture, replay execution, diff, explain, and retained-scenario control are all available through the UI,
11. extension/add-in support is either real for the declared desktop host or explicitly out of scope for that host profile.

## 12. Open Questions To Answer In Research
1. What is the minimum viable host-profile ladder and naming for `DNA OneCalc`?
2. What exact bounded caller-context or anchor model, if any, is needed to keep reduced-profile host semantics honest without turning the app into a grid editor?
3. What is the right application-core split between the shared `Leptos` UI, Tauri desktop shell, and non-UI harness paths?
4. What is the cleanest formatting/state model for isolated instances, including fonts, colors, and effective-display projection?
5. What is the cleanest SpreadsheetML 2003 persistence mapping for one or more isolated instances with formatting and conditional-formatting state?
6. What is the right first honest conditional-formatting scope for a single-node host, and how should it relate to the fuller OxFml carrier backlog?
7. What is the exact portable C-ABI extension contract for Windows `.xll` and Linux `.so`, and how should it differ from hosted web and browser/WASM where add-ins are initially absent?
8. Which replay, trace, and provenance surfaces must be exposed in the first `Leptos` UI wave?
9. Which current outstanding items in `OxFml`, `OxFunc`, `OxReplay`, `OxXlObs`, and `OxVba` are the true blockers for a first `DnaOneCalc` repo?
10. What scenario-library and upstream-handoff contract should `DNA OneCalc` adopt from day one so replay artifacts remain durable and useful for co-development?
