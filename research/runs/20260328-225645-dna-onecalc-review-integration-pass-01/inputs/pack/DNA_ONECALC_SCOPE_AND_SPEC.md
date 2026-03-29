# DNA OneCalc Scope And Specification

Status: `active_scope_and_spec`
Date: 2026-03-27
Supersedes:
1. `DNA_ONECALC_INITIAL_SCOPE.md` as the active Foundation note for this topic
2. the fragmented planning spread across the initial scope note and the first review passes

## 1. Purpose
This document is the current single Foundation note for `DNA OneCalc`.

It is intended to be complete enough to:
1. define the repo mission,
2. define the host boundary,
3. define the product direction,
4. define the artifact model,
5. define the dependency and gate model,
6. define the staged work shape,
7. drive repo bootstrap and repo-bound agent work without needing to reconstruct the plan from multiple scattered notes.

It is not the authoritative semantic owner for:
1. formula semantics,
2. function semantics,
3. replay semantics,
4. VBA semantics.

Those remain in the `Ox*` repos.

## 2. Role In The Program
`DNA OneCalc` is:
1. a downstream proving host,
2. a serious user-facing application,
3. a co-development and scope-discovery program for the `Ox*` repos,
4. the first product-stage single-node proving surface for the formula, function, replay, and Excel-comparison stack.

It is not:
1. a new semantics lane,
2. a replacement for `OxFml`, `OxFunc`, `OxReplay`, or `OxVba`,
3. a general spreadsheet grid host,
4. a workbook dependency engine,
5. an `OxCalc` host,
6. a claim of “Excel except for some missing pieces.”

The right reading is:
1. Excel as a single isolated calculation node,
2. with explicit host context,
3. with first-class replay and comparison,
4. without workbook graph semantics.

## 3. Core Thesis
The core mission of `DNA OneCalc` is:
1. accept a formula string of arbitrary supported complexity,
2. evaluate it through `OxFml` and `OxFunc`,
3. present the result and effective display state in an attractive interactive host,
4. emit replayable evidence through `OxReplay`,
5. compare and replay scenarios against Excel through `OxXlObs`,
6. grow a durable scenario library that validates the stack against Excel and pressures the upstream repos productively.

The strongest product direction is:
1. `DNA OneCalc` as the stack’s `Twin Oracle Workbench`,
2. with `Live Formula Semantic X-Ray` as the primary product expression of that workbench.

That means the central user experience is not merely:
1. type a formula,
2. see a value.

It is:
1. author a scenario,
2. run it in DNA,
3. inspect the parse tree,
4. inspect the evaluation trace,
5. inspect semantic provenance,
6. compare against Excel on Windows,
7. explain mismatches,
8. distill witnesses,
9. emit upstream-ready handoff packets.

In short:
1. every meaningful session should be capable of becoming retained evidence,
2. every retained evidence item should be capable of becoming an upstream work request.

## 4. Ownership And Dependency Constitution
Primary runtime dependencies:
1. `OxFml`
2. `OxFunc`
3. `OxReplay`

Primary empirical validation dependency:
1. `OxXlObs`

Staged later dependency:
1. `OxVba`

Explicit non-dependency for the initial repo mission:
1. `OxCalc`

Ownership split:
1. `DnaOneCalc` owns product shell, host policy, UI, persistence, extension hosting, scenario orchestration, and upstream handoff production.
2. `OxFml` owns formula-language semantics, host-policy seams, semantic formatting, formula-semantic conditional-formatting carriers, and the canonical formula-edit language-service substrate used by hosts.
3. `OxFunc` owns value and function semantics, library/runtime context seams, registered-external function machinery, and the authoritative function-help or signature-metadata truth that OxFml should project into host-facing editor packets.
4. `OxReplay` owns replay bundle, replay execution, diff, explain, witness, and adapter/conformance infrastructure.
5. `OxXlObs` owns live Excel-facing observation and capture.
6. `OxVba` owns VBA semantics and later VBA-backed extension tooling.

Important rule:
1. `DnaOneCalc` consumes lane semantics,
2. it does not locally redefine them,
3. it should produce structured downstream pressure and actionable upstream work rather than pretending the current libraries are frozen.

### 4.0 Upstream Reference Rule
`DNA OneCalc` should design and implement against the authoritative upstream slices recorded in Section `19`.

Working rule:
1. prefer each upstream repo's root `CHARTER.md`, `docs/spec/README.md`, non-archive spec docs named there, and the current `docs/IN_PROGRESS_FEATURE_WORKLIST.md` plus `CURRENT_BLOCKERS.md`,
2. treat worksets, handoff notes, execution records, and test-run notes as current-status or evidence docs rather than semantic authority unless Section `19` explicitly names them as temporary downstream references,
3. ignore archive paths, mirrors, local snapshots, and historical synthesis material unless doing archaeology or drift resolution,
4. preserve `prelim`, `draft`, `working-draft`, `design-draft`, or similar status markers as real scope constraints rather than hand-waving past them,
5. if a required downstream surface has no good stable upstream doc, treat that as upstream documentation debt rather than local permission to invent a private contract.

### 4.1 OxCalc/OxFml Seam Reference Rule
`OxCalc` is not a runtime library dependency of `DNA OneCalc`.

But the host-facing seam used to drive `OxFml` is materially related to the seam already documented between `OxCalc` and `OxFml`.

Therefore:
1. `OxCalc` seam documentation is also reference material for `DNA OneCalc`,
2. the fact that `DNA OneCalc` does not depend on the `OxCalc` library does not mean the `OxCalc` spec set is irrelevant,
3. if `DNA OneCalc` discovers that the consumed `OxFml` interface needs to change, the corresponding `OxCalc` seam reference material may also need updating to prevent cross-repo drift.

The most relevant current OxCalc reference is:
1. `OXCALC_REFERENCE.md`

Interpretation rule:
1. `OxFml` remains authoritative for evaluator-side semantics and canonical shared seam meaning,
2. `OxCalc` remains an important reference owner for coordinator-facing and consumed-host-packet seam shape,
3. `DNA OneCalc` should treat both repos as part of the reference surface for this seam even while only consuming `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs` at runtime.

Current concrete read from the refreshed OxCalc seam docs:
1. the first implementation-backed host packet already carries more than a bare formula string, including caller-anchor facts, structure-context versioning, typed host-query facts, table-context carriage, and a `library_context_snapshot`,
2. that packet is still seam-reference material only and must not be mistaken for a frozen production host API,
3. `DNA OneCalc` should use this packet family to understand what the live seam currently needs, then narrow and productize that shape explicitly in its own host profiles rather than pretending the wider packet does not exist.

The authoritative OxCalc seam-reference slice is enumerated in Section `19.6`.

### 4.2 OxFml Formula-Editing Language-Service Reference Rule
`DNA OneCalc` should also treat the OxFml editor and language-service surface as a first-class upstream dependency seam.

That surface includes, or should include:
1. immutable formula-edit request and result packets,
2. unified live diagnostics and squiggle-ready spans,
3. deterministic completion proposals,
4. validated completion application through the ordinary parse/bind path,
5. signature-help context,
6. function-help lookup and payload flow,
7. external intelligent-completion context and validation boundaries.

The most relevant current OxFml reference is:
1. `OXFML_REFERENCE.md`

Current read of the OxFml floor:
1. there is already a real local language-service packet layer in OxFml,
2. the current local floor includes `FormulaEditRequest` / `FormulaEditResult`, `LiveDiagnosticSnapshot`, deterministic completion, completion validation and application, `SignatureHelpContext`, `FunctionHelpLookupRequest`, and intelligent-completion context packets,
3. deterministic local test evidence already exists in OxFml for that floor.

Current residuals that matter to `DNA OneCalc`:
1. no OxFunc-backed help or signature payload retrieval is frozen yet,
2. no shared host or OxCalc immutable formula-edit packet is frozen yet,
3. no shared host-facing packet for validated intelligent-completion results is frozen yet,
4. editor packet evidence is still local deterministic evidence rather than replay-appliance projection.

Interpretation rule:
1. `DNA OneCalc` should exercise and integrate this OxFml language-service surface rather than inventing a second parser/binder/editor truth locally,
2. if `DNA OneCalc` pressures changes to these packets, that should be treated as a real cross-repo seam update request,
3. where the same packet family is also reflected from the coordinator side, the OxCalc seam-reference material may need updating as well.

The authoritative OxFml language-service and host/runtime slice is enumerated in Section `19.2`.

### 4.3 Function Surface Truth Rule
`DNA OneCalc` must pin its function surface against the current OxFunc admission overlays rather than against the broadest exported catalog view.

Working rule:
1. treat the OxFunc library-context snapshot export as the current downstream catalog and metadata seed,
2. read that export together with `W050` and `W051`, not by itself,
3. prefer scenario families whose rows are already function-phase-complete or at least `doc_modeled` with a clear seam contract,
4. treat `LET`, `LAMBDA`, helper-family functions, `CALL`, `REGISTER.ID`, `IMAGE`, `GROUPBY`, `PIVOTBY`, and `OP_IMPLICIT_INTERSECTION` as explicit scope markers rather than as silently complete surface,
5. make the admitted function surface visible in product and scenario metadata so the app does not overclaim current-version parity.

The authoritative OxFunc surface and overlay slice is enumerated in Section `19.3`.

## 5. Product Expression
`DNA OneCalc` should be a serious product, not only a harness.

The defining surface is `Live Formula Semantic X-Ray`.

That surface should make the following first-class:
1. formula text,
2. explicit inputs,
3. live diagnostics,
4. deterministic completion and validated completion application,
5. function and argument help during editing,
6. result and effective display,
7. parse tree,
8. evaluation trace,
9. replay state,
10. semantic diff,
11. provenance,
12. witness state,
13. upstream handoff readiness.

The named workbench modes are:
1. `DNA-only`
2. `Excel-observed`
3. `Twin compare`
4. `Replay`
5. `Diff`
6. `Explain`
7. `Distill`
8. `Handoff`

These should be treated as named product modes with explicit capability gates, not as vague inspiration words.

## 6. Canonical Artifact Spine
The repo should revolve around stable artifacts, not around ad hoc UI state.

### 6.1 Scenario
The canonical authored unit.

A `Scenario` contains:
1. formula text,
2. explicit inputs,
3. host profile selection,
4. function-surface and library-context snapshot refs,
5. display context,
6. capability declarations,
7. retained notes and intent,
8. extension state if relevant,
9. stable identifiers.

### 6.2 ScenarioRun
A concrete execution of a scenario under:
1. a specific build,
2. a specific profile version,
3. a specific dependency seam set,
4. a specific runtime environment.

It records:
1. result,
2. effective display state,
3. replay capture identity,
4. the exact upstream seam pin set and capability floor actually relied upon,
5. execution metadata.

### 6.3 Observation
An external truth artifact, most importantly:
1. Windows-only Excel-observed output through `OxXlObs`.

### 6.4 Comparison
A typed comparison between:
1. a `ScenarioRun` and an `Observation`,
2. or two `ScenarioRun` instances.

It should classify:
1. value agreement,
2. type agreement,
3. display agreement,
4. formatting agreement,
5. conditional-formatting agreement,
6. trace-level or provenance-level divergence where available.

### 6.5 Witness
A retained unreduced or reduced counterexample artifact.

It should preserve lineage back to:
1. scenario,
2. run,
3. comparison,
4. replay bundle,
5. reduction state.

### 6.6 HandoffPacket
A repo-addressable upstream pressure artifact that points to:
1. scenario,
2. run,
3. comparison,
4. witness,
5. exact seam versions,
6. exact requested upstream action.

### 6.7 Document
A persisted container that may hold:
1. one or more isolated scenarios or instances,
2. formatting state,
3. conditional-formatting state,
4. retained local metadata.

The document container must not silently imply workbook-graph semantics.

Current upstream reference slice for the artifact spine:
1. OXREPLAY_REFERENCE.md,
2. OXXLOBS_REFERENCE.md,
3. OXFML_REFERENCE.md.

## 7. Host Profile Ladder
`DnaOneCalc` should use an explicit host-profile ladder over a single-node substrate.

### 7.1 OC-H0: Literal And Function Core
Purpose:
1. stand up the narrowest honest host,
2. prove formula string to parse/bind/evaluate/result/replay end to end.

In scope:
1. literals,
2. operators,
3. built-in functions that require no external provider or workbook state,
4. locale and date-system context,
5. result display with semantic formatting consequences where already available upstream,
6. replay capture for every executed scenario,
7. attractive but honest result presentation.

Coverage rule:
1. `OC-H0` claims must still be filtered through the admitted OxFunc current surface,
2. exported catalog presence alone is not enough,
3. promoted H0 scenario families should start with rows that are already function-phase-complete or explicitly modeled with a stable seam contract.

Out of scope:
1. references,
2. defined names,
3. host queries,
4. external providers,
5. add-ins,
6. VBA-backed functions,
7. workbook state.

### 7.2 OC-H1: Explicit-Input Host
Purpose:
1. make the first serious single-node host truth real,
2. remain clearly narrower than `OxCalc`.

In scope:
1. one authoritative formula under test,
2. explicit host-bound input slots surfaced by stable symbols,
3. typed host query or profile input,
4. explicit recalc trigger,
5. replay-visible host-context consequences,
6. base formatting state,
7. effective-display projection,
8. isolated-instance conditional-formatting rules,
9. narrowly bounded seam-sensitive packet only if evidence requires it.

Important rules:
1. the default product claim must not expose a generic cell environment,
2. it must not expose a workbook-style name manager,
3. it must not expose an open reference-binding map,
4. caller-sensitive or anchor-sensitive context may only be admitted as a tightly bounded proving packet if empirical evidence forces it,
5. even then, `DNA OneCalc` must stay visibly narrower than `OxCalc`.

Out of scope:
1. formula dependency graphs,
2. multi-node recalculation,
3. scheduler policy,
4. workbook structural edits,
5. cross-instance interaction.

### 7.2.1 Current Upstream Tension And Resolution
There is a real tension between the intended `DNA OneCalc` product boundary and the current upstream seam floor.

The tension is:
1. `DNA OneCalc` should remain an explicit-input host rather than sliding toward a worksheet engine,
2. the current OxFml reduced-profile host baseline still admits mutable defined-name inputs and direct cell bindings for specific semantic lanes,
3. the current OxCalc seam-reference packet also carries caller-anchor, direct cell fixture, table-context, and library-context facts.

The working resolution is:
1. the default `DNA OneCalc` product model remains explicit-input and non-grid,
2. when a semantic lane genuinely requires reference-bearing truth such as `@`, `_xlfn.SINGLE`, or reference-sensitive `CELL(...)`, the host may admit a bounded reference-bearing scenario packet,
3. that bounded packet must remain explicit, replay-visible, and clearly narrower than a generic worksheet environment,
4. such probes are seam-sensitive exceptions, not the default authoring model or a license to grow toward `OxCalc`.

### 7.3 OC-H2: Host Extensions And Add-ins
Purpose:
1. widen into real external function surfaces without drifting into a spreadsheet engine.

In scope:
1. registered external providers,
2. desktop add-ins over a declared portable C ABI,
3. Windows `.xll` packaging,
4. Linux `.so` packaging over the same extension ABI,
5. replay-visible extension invocation,
6. later `OxVba`-backed shim paths when upstream is ready.

Out of scope for the initial honest claim:
1. workbook macro model,
2. scheduler semantics,
3. arbitrary Office add-in breadth,
4. fake web parity for native extensions.

### 7.4 Current Function Surface Rule
`DNA OneCalc` should explicitly carry a function-surface admission layer in its own planning and UI.

That layer should distinguish:
1. promoted current surface,
2. in-scope but not-complete surface,
3. deferred current-version surface,
4. scenario families being used primarily to pressure upstream seam closure.

Initial practical rule:
1. the first comparison and replay spines should avoid using `W051` rows as baseline product claims unless the scenario is explicitly marked as provisional or upstream-pressure driven,
2. help and completion should still be able to show admitted metadata for those rows, but the app should not present them as settled parity.

Current upstream reference slice for the host-profile ladder:
1. OXFML_REFERENCE.md,
2. OXFUNC_REFERENCE.md,
3. OXCALC_REFERENCE.md.

## 8. Formatting And Conditional Formatting Plane
Formatting and conditional formatting are a good fit for this project and should be treated as first-class host scope.

But they must be staged honestly.

### 8.1 Why They Belong Here
They fit because `DNA OneCalc` is:
1. a single isolated calculation host,
2. an effective-display proving surface,
3. a replay-visible comparison surface,
4. a good place to validate formatting behavior without inheriting workbook-graph complexity.

### 8.2 Authority Split
1. `OxFml` remains authoritative for semantic formatting, formatting-sensitive evaluator behavior, and conditional-formatting formula carriers where those are formula-significant.
2. `DNA OneCalc` owns persisted style state, carrier records, rendering, effective-format computation in the product host, and honest cross-platform capability declaration.
3. `OxReplay` must see formatting-significant and conditional-formatting-significant consequences.
4. `OxXlObs` is the empirical comparison source for Excel-facing formatting and conditional-formatting truth on Windows.

Current carrier split:
1. hosts own conditional-formatting and data-validation carrier records, target-range attachment, rule fields, and rendering policy,
2. `OxFml` owns admission, restriction classification, and the formula-semantic meaning of the currently modeled host fields for `CF` and `DV` carriers,
3. the current OxFml floor treats `CF` and `DV` as distinct restricted carrier profiles rather than as ordinary worksheet-cell formulas.

### 8.3 Delivery Shape
Formatting support should widen in this order:
1. base formatting and effective display,
2. honest font and color subset,
3. broader format-string interpretation,
4. isolated-instance conditional-formatting rules,
5. deeper Excel comparison families.

Current conservative upstream floor:
1. presentation-aware return hints already matter for a narrow but real slice such as `NOW`, `TODAY`, and `HYPERLINK`,
2. the current OxFml `CF` / `DV` floor rejects union, intersection, spill-reference, and external-reference families,
3. broader structured-reference, table-aware, and full `MS-OE376` parity for `CF` / `DV` remains later scope,
4. `DNA OneCalc` should therefore start with explicit restricted-carrier scenarios and widen only as upstream semantics and evidence justify it.

Important rule:
1. formatting and conditional formatting do not imply workbook dependency graphs,
2. they apply to isolated instances and their result or input display surfaces,
3. broader workbook precedence systems remain outside initial scope.

Current upstream reference slice for this plane:
1. OXFML_REFERENCE.md,
2. OXFUNC_REFERENCE.md,
3. OXXLOBS_REFERENCE.md.

## 9. UI, Runtime, And Platform Model
### 9.1 Runtime Shape
The intended runtime split is:
1. shared `Leptos` UI and state model,
2. Tauri desktop shell for Windows and Linux,
3. browser/WASM host over the same shared application core,
4. optional non-UI harness later if justified.

Important rule:
1. Tauri is not the web host,
2. desktop and browser are separate hosts over a shared core.

### 9.2 Leptos Position
`Leptos` is the chosen UI framework for this app.

It should also be treated as:
1. a deliberate proving lane for the program,
2. something to validate with explicit evidence,
3. not an unquestioned premise.

This project should therefore produce:
1. proof-of-life evidence,
2. keyboard and IME viability evidence,
3. WASM and runtime-size evidence,
4. explicit escalation criteria if the stack does not hold up.

### 9.3 UX Priorities
1. immediate parse and bind diagnostics,
2. live error highlighting,
3. keyboard-first command flow,
4. completion and suggestion help where deterministic local truth exists,
5. function and argument help during editing,
6. result surfaces that make value shape, type, and effective formatting obvious,
7. visible host profile and extension state,
8. visible replay state,
9. first-class X-Ray views,
10. fast scenario capture and inspection.

### 9.4 Formula Editing Language-Service Integration
`DNA OneCalc` should explicitly exercise and integrate the OxFml language-service surface as part of the product scope.

That means the app should consume, not re-invent:
1. immutable formula-edit request and result flows,
2. live diagnostics and squiggle-ready spans,
3. deterministic completion proposals,
4. validated completion application that re-enters the ordinary parse/bind path,
5. signature-help context,
6. function-help and argument-help surfaces where the upstream payloads exist,
7. intelligent-completion context and validation boundaries for later external completion lanes.

Working rules:
1. `DNA OneCalc` may add presentation, interaction, and command affordances, but it should not invent a second parser/binder/editor truth locally,
2. diagnostics should remain OxFml-derived wherever the canonical meaning lives in OxFml,
3. function-help content should come from OxFunc through OxFml packetization rather than duplicated host prose,
4. intelligent completion remains host-owned and non-canonical until it re-enters OxFml through the normal validation path.

Current practical read:
1. the first useful help and completion metadata path is the OxFunc library-context snapshot export plus its stable ids, arity, gating, interface-contract refs, and metadata-status fields,
2. that export is a stabilization artifact and not yet the final cross-repo ABI,
3. the preferred longer-term direction is the OxFunc runtime provider and immutable snapshot model, not permanent CSV-only ingestion,
4. `DNA OneCalc` should therefore be designed to consume an immutable snapshot-shaped help/catalog source even if the first implementation is export-backed.

Current upstream reference slice for formula editing:
1. OXFML_REFERENCE.md,
2. OXFUNC_REFERENCE.md.

### 9.5 Multi-Instance Rule
The app may eventually show multiple isolated instances at once.

Initial rule:
1. instances remain semantically isolated,
2. there are no inter-instance references,
3. there is no shared recalc graph,
4. copy/paste and file-level management are allowed.

## 10. Replay, Comparison, And Scenario Library
Replay is not optional garnish. It is one of the project’s reasons to exist.

`DNA OneCalc` should be the first user-facing host that routinely makes this possible:
1. author scenario,
2. run scenario,
3. emit retained replay evidence,
4. compare with Excel-facing evidence,
5. explain mismatch,
6. retain witness,
7. emit handoff.

Required directions:
1. `DNA OneCalc -> OxReplay -> compare to Excel/OxXlObs evidence`
2. `OxXlObs/Excel capture -> OxReplay -> replay/explain against DNA OneCalc`

Windows-only rule:
1. live Excel-facing comparison is Windows-only,
2. Linux desktop and browser/WASM must not imply live Excel availability.

### 10.1 Current Conservative Comparison And Replay Floor
`DNA OneCalc` should assume the following current honest floor unless retained upstream evidence says otherwise:
1. `OxFml` replay support is currently honest through `C3.explain_valid`; do not assume `C4.distill_valid` or `C5.pack_valid`,
2. `OxFunc` has useful local replay artifacts and manifests, but no accepted direct `OxReplay` intake floor that OneCalc should depend on separately from `OxFml`,
3. `OxXlObs` currently provides a retained Windows live-driver baseline through `O5.stable_driver_valid`, but the live exercised scenario family is still narrow,
4. the current `OxXlObs` replay-facing normalized view is explicitly `lossy`,
5. `OxVba` replay-facing consumption remains later scope.

Operational consequence:
1. OneCalc should surface replay capability floors, observation provenance, and projection or lossiness markers directly in the UI and retained artifacts,
2. it should not present Windows Excel comparison or replay distillation maturity as broader than the current retained evidence justifies.

### 10.2 Scenario Promotion Rule
The first scenario families promoted into comparison and replay spines should favor:
1. OxFunc rows with stable semantic closure or explicit doc-modeled seam contracts,
2. OxFml lanes whose host and replay artifacts are already deterministic and typed,
3. OxXlObs scenarios with retained provenance-rich bundle emission and no hidden capture assumptions.

Avoid making these the first product-claim families unless the scenario is explicitly marked provisional:
1. `W051` OxFunc rows whose broader promotion packet is still open,
2. broad conditional-formatting or `DV` lanes beyond the current restricted-carrier floor,
3. Excel-comparison claims that depend on the current lossy replay projection as if it were complete semantic equivalence truth.

Required scenario families:
1. formula-language edge cases,
2. function-semantic cases,
3. formatting-sensitive cases,
4. base-formatting and effective-display cases,
5. conditional-formatting cases,
6. host-profile-sensitive cases,
7. later extension cases.

The scenario library must also produce:
1. structured requirement deltas,
2. seam clarification requests,
3. repo-addressable upstream work requests.

Current upstream reference slice for replay, comparison, and scenario growth:
1. OXREPLAY_REFERENCE.md,
2. OXXLOBS_REFERENCE.md,
3. OXFML_REFERENCE.md,
4. OXFUNC_REFERENCE.md.

## 11. Persistence
The initial externally meaningful persistence target is `SpreadsheetML 2003`.

Why:
1. it is simpler than OOXML,
2. it is externally meaningful,
3. it matches the Foundation reference direction.

Working rules:
1. a `DNA OneCalc` document may contain one or more isolated instances,
2. the workbook envelope is only a container,
3. it is not permission to introduce workbook graph semantics,
4. formatting state and conditional-formatting state must round-trip,
5. the instance-to-envelope mapping must be explicitly resolved before hardening the persistence implementation.

Important rule:
1. `SpreadsheetML 2003` is the first persistence target,
2. it is not necessarily the only long-term persisted truth artifact.

Current upstream-reference note:
1. there is currently no stable `Ox*`-owned persistence contract for the isolated-instance `SpreadsheetML 2003` mapping,
2. until one exists, persistence design should treat the `Ox*` repos as semantic-input owners only and treat the actual container mapping as a `DnaOneCalc` responsibility informed by the Foundation reference corpus and the public `SpreadsheetML 2003` sources already curated there,
3. this documentation gap is recorded explicitly again in Section `19.8`.

## 12. Extension And Add-In Model
The desktop extension path should be defined as a portable C ABI contract.

That means:
1. the portability claim is about the extension ABI,
2. not about literally reusing Windows `.xll` binaries on Linux.

Platform model:
1. Windows desktop uses native `.xll` packaging,
2. Linux desktop uses native `.so` packaging over the same declared extension ABI,
3. hosted web and browser/WASM begin without native add-in support.

This keeps the extension lane honest while preserving the portability goal.

`OxVba` role:
1. OxVba is currently best treated as an embedded host runtime and later add-in toolchain, not as an already-shipped add-in producer,
2. `.basproj` already defines `Library` and `Addin` output kinds in a normative-draft project model,
3. current host-export discovery and embedded-host execution are the real current floor,
4. XLL generation is still planned rather than implemented,
5. Linux shared-library support should therefore be pursued first through the OneCalc portable native-extension ABI, not by pretending the OxVba add-in toolchain is already portable and complete.

Current upstream reference slice for the extension lane:
1. OXFML_REFERENCE.md,
2. OXFUNC_REFERENCE.md,
3. OXVBA_REFERENCE.md.

Important current limitation:
1. the relevant `OxVba` docs are still mostly draft-grade rather than a frozen downstream contract,
2. `DNA OneCalc` should therefore treat the current `OxVba` surface as design input and co-development pressure rather than as a fully frozen consumer ABI,
3. Windows COM and Office-style root-object hosting remain Windows-only assumptions unless the host supplies explicit cross-platform replacements.

## 13. Hierarchical Work Breakdown
For now, planning should use one numbered hierarchical work breakdown.

Working rule:
1. top-level items cover the whole scope,
2. detailed items carry explicit `depends_on` attributes,
3. detailed items also name the evidence or gate expectation,
4. repo-local workset documents can be created later from these items, but this document should speak in one planning language only.

### W1: Bootstrap, Governance, And Seam Freeze
This item establishes the project’s planning and interface baseline.

#### W1.1: Host Charter And Profile Freeze
- `depends_on`: none
- Scope:
  1. declare the host profiles,
  2. publish the acceptance/degradation or equivalent gate tables,
  3. define the repo `meta-check` shape,
  4. declare the first serious scope honestly.
- Evidence:
  1. bootstrap charter text exists,
  2. host profiles are explicit,
  3. repo readiness can be stated in one command.

#### W1.2: Upstream Seam Inventory And Pin Set
- `depends_on`: `W1.1`
- Scope:
  1. pin the consumed `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs` seams,
  2. identify still-provisional seams,
  3. record the specific OxCalc seam-reference docs reviewed,
  4. record the current admitted OxFunc surface overlays and replay capability floors actually assumed,
  5. record whether any seam-sync handoff is already required.
- Evidence:
  1. seam manifest exists,
  2. OxCalc seam-reference review is recorded,
  3. residual seam risks are explicit,
  4. the host can say exactly which provisional seams and capability ceilings it is relying on.

#### W1.3: Scenario And Handoff Artifact Freeze
- `depends_on`: `W1.1`, `W1.2`
- Scope:
  1. freeze `Scenario`, `ScenarioRun`, `Observation`, `Comparison`, `Witness`, and `HandoffPacket`,
  2. define stable IDs,
  3. define the minimum upstream handoff packet.
- Evidence:
  1. artifact schema set exists,
  2. one scenario can be traced through to handoff without ad hoc interpretation.

### W2: UI And Runtime Proving
This item proves the chosen host stack is viable.

#### W2.1: Leptos/Desktop/Browser Proof Of Life
- `depends_on`: `W1.1`, `W1.2`
- Scope:
  1. prove the shared `Leptos` UI core,
  2. prove desktop shell viability,
  3. prove browser/WASM viability.
- Evidence:
  1. minimal app runs in desktop and browser hosts,
  2. bundle/runtime measurements are recorded.

#### W2.2: Keyboard, IME, And Editing Viability
- `depends_on`: `W2.1`
- Scope:
  1. prove keyboard-first editing,
  2. prove IME and cursor behavior are acceptable,
  3. prove the formula editor can support the intended interaction model.
- Evidence:
  1. editing spike results are recorded,
  2. explicit escalation path exists if the stack fails this test.

### W3: Formula Editing And Language-Service Integration
This item makes the editor a real upstream-consumer of OxFml language services.

#### W3.1: Immutable Formula Edit Integration
- `depends_on`: `W1.2`, `W2.1`, `W2.2`
- Scope:
  1. consume OxFml immutable formula-edit request and result packets,
  2. integrate edit-driven parse/bind updates into the host editor,
  3. keep the host from inventing a second parser/binder truth.
- Evidence:
  1. real editor actions flow through OxFml edit packets,
  2. artifact identity and change ranges are visible in the host.

#### W3.2: Diagnostics And Error Highlighting
- `depends_on`: `W3.1`
- Scope:
  1. surface OxFml unified live diagnostics,
  2. integrate squiggle spans, lists, and navigation,
  3. preserve stage-aware diagnostic identity where available.
- Evidence:
  1. OxFml-derived diagnostics are visible and trustworthy in the editor.

#### W3.3: Completion And Validated Completion Application
- `depends_on`: `W3.1`, `W3.2`
- Scope:
  1. surface deterministic completion proposals,
  2. integrate validated completion application through the ordinary parse/bind path,
  3. keep intelligent completion explicitly non-canonical until validated upstream.
- Evidence:
  1. deterministic completion works end to end,
  2. validated completion re-entry is visible and stable.

#### W3.4: Function Help And Signature Help
- `depends_on`: `W3.1`, `W1.2`
- Scope:
  1. integrate OxFml signature-help context,
  2. integrate function and argument help,
  3. consume OxFunc-backed help payloads as far as the upstream seam currently allows,
  4. start from the current library-context snapshot export floor while keeping the host ready for the later provider-backed snapshot model.
- Evidence:
  1. function and argument help appear during editing,
  2. any still-open OxFunc metadata residuals are explicitly tracked.

### W4: H0 Evaluation And Result Surface
This item proves the narrowest honest single-node host path.

#### W4.1: Formula To Typed Result Path
- `depends_on`: `W1.2`, `W2.1`
- Scope:
  1. formula string to parse/bind/evaluate,
  2. typed result projection,
  3. visible host profile.
- Evidence:
  1. one retained executed scenario exists,
  2. the H0 path works end to end.

#### W4.2: Result And Display Surface
- `depends_on`: `W4.1`
- Scope:
  1. present value shape and type clearly,
  2. present effective display honestly,
  3. keep the first product slice attractive without hiding unsupported behavior.
- Evidence:
  1. result surface is usable and explicit about state.

### W5: Replay And Live Semantic X-Ray
This item makes replay and explain part of the product, not a sidecar.

#### W5.1: Replay Capture Baseline
- `depends_on`: `W4.1`, `W1.2`
- Scope:
  1. emit replay artifacts for executed scenarios,
  2. surface replay state in the UI,
  3. validate retained replay artifacts through `OxReplay`,
  4. preserve projection status, capture-loss, capability floor, and source-provenance markers.
- Evidence:
  1. retained replay artifacts exist and validate.

#### W5.2: Parse Tree, Trace, Diff, And Provenance
- `depends_on`: `W5.1`, `W4.1`
- Scope:
  1. surface parse tree,
  2. surface evaluation trace,
  3. surface semantic diff and provenance,
  4. make these part of the main workbench.
- Evidence:
  1. `Live Formula Semantic X-Ray` is real in the UI.

#### W5.3: Witness And Handoff Flow
- `depends_on`: `W5.1`, `W1.3`
- Scope:
  1. retain witnesses,
  2. integrate explain and distill entry points,
  3. emit upstream handoff packets from real scenarios.
- Evidence:
  1. one retained witness and one emitted handoff packet exist.

### W6: Explicit-Input Host Packet
This item makes the real `OC-H1` host boundary concrete.

#### W6.1: Explicit Input Slots And Host Queries
- `depends_on`: `W4.1`, `W5.1`
- Scope:
  1. stable explicit input-slot model,
  2. typed host queries or profile inputs,
  3. visible host packet consequences.
- Evidence:
  1. `OC-H1` is real without implying a worksheet environment.

#### W6.2: Seam-Sensitive Packet And Reference-Probe Admission Rule
- `depends_on`: `W6.1`
- Scope:
  1. decide whether bounded caller-sensitive or anchor-sensitive context is actually needed,
  2. decide which direct-cell, caller-anchor, table-context, or aggregate-context facts are genuinely required by current upstream semantics,
  3. if needed, admit them only as explicit bounded proving packets.
- Evidence:
  1. no accidental slide toward `OxCalc`,
  2. seam-required reference-bearing probes are visible as exceptions rather than disguised as the default host model.

### W7: Formatting And Effective Display
This item establishes formatting as a first-class proving surface.

#### W7.1: Base Formatting State
- `depends_on`: `W6.1`
- Scope:
  1. persisted base formatting state,
  2. honest font and color subset,
  3. explicit effective-display projection,
  4. presentation-aware result hints where the upstream function or value lanes already emit them.
- Evidence:
  1. formatting state is visible and honest.

#### W7.2: Formatting Scenario Spine
- `depends_on`: `W7.1`, `W5.1`
- Scope:
  1. retain formatting-significant scenarios,
  2. identify the first promoted formatting proving family.
- Evidence:
  1. formatting-sensitive retained scenarios exist.

### W8: Persistence
This item establishes a real persisted container without implying workbook semantics.

#### W8.1: SpreadsheetML Mapping Resolution
- `depends_on`: `W6.1`, `W7.1`
- Scope:
  1. resolve instance-to-envelope mapping for `SpreadsheetML 2003`,
  2. keep the workbook envelope as container only.
- Evidence:
  1. mapping decision is explicit and testable.

#### W8.2: Round-Trip Persistence Baseline
- `depends_on`: `W8.1`
- Scope:
  1. round-trip isolated instances,
  2. round-trip formatting and conditional-format state as admitted,
  3. keep persistence narrower than workbook-graph semantics.
- Evidence:
  1. persisted documents round-trip honestly.

### W9: Conditional Formatting
This item widens into isolated-instance conditional formatting.

#### W9.1: Isolated-Instance CF Rule Model
- `depends_on`: `W7.1`, `W5.1`
- Scope:
  1. implement the first honest conditional-formatting subset from the current OxFml restricted-carrier floor,
  2. preserve carrier-owned rule records and target ranges in the host,
  3. make rule consequences replay-visible.
- Evidence:
  1. retained conditional-formatting scenarios exist.

#### W9.2: Conditional-Formatting Comparison Families
- `depends_on`: `W9.1`, `W10.1`
- Scope:
  1. compare conditional-formatting outcomes against Excel on Windows,
  2. retain conditional-formatting witnesses and handoffs.
- Evidence:
  1. first retained CF comparison family exists.

### W10: Excel Comparison
This item establishes the Windows-only twin-oracle lane.

#### W10.1: Windows Twin-Oracle Baseline
- `depends_on`: `W5.2`, `W7.2`
- Scope:
  1. integrate `OxXlObs`,
  2. compare DNA and Excel-observed results,
  3. preserve provenance, capture-loss, and lossy-projection markers,
  4. keep the platform boundary explicit.
- Evidence:
  1. first retained Windows-only comparison family exists.

#### W10.2: First Proving Spine Family
- `depends_on`: `W10.1`
- Scope:
  1. choose and promote the first comparison family,
  2. likely start with formatting-sensitive `TEXT`, locale, and date-system cases.
- Evidence:
  1. first proving spine family is retained and reusable.

### W11: Extension ABI And Add-ins
This item opens the desktop extension lane honestly.

#### W11.1: Portable C-ABI Contract
- `depends_on`: `W6.1`, `W1.2`
- Scope:
  1. freeze the portable extension ABI,
  2. define Windows `.xll` and Linux `.so` packaging expectations,
  3. keep browser/WASM explicitly without native add-ins,
  4. separate the generic OneCalc native-extension ABI from later OxVba-specific add-in generation.
- Evidence:
  1. extension contract is explicit by platform.

#### W11.2: Registered-External And Add-in Integration
- `depends_on`: `W11.1`
- Scope:
  1. integrate registered-external functions,
  2. stage native add-in loading,
  3. later admit `OxVba`-backed shims when upstream is ready,
  4. keep Windows-first OxVba add-in generation separate from the portable host ABI until the upstream toolchain is real.
- Evidence:
  1. extension support is either real for the declared host or still explicitly out of scope.

### W12: Upstream Pressure, Corpus Governance, And Cleanup
This item keeps the repo aligned with its co-development mission.

#### W12.1: Requirement Delta And Handoff Discipline
- `depends_on`: `W1.3`, `W5.3`
- Scope:
  1. emit structured upstream requirement deltas,
  2. emit seam clarification packets,
  3. track seam-sync updates across `OxFml`, `OxCalc`, `OxFunc`, and `OxReplay` where needed,
  4. explicitly route OneCalc-driven seam pressure into the new OxCalc and OxReplay downstream-consumption reference notes where applicable.
- Evidence:
  1. real upstream handoff artifacts exist and are reusable.

#### W12.2: Corpus Hardening And Cleanup Pass
- `depends_on`: `W10.2`, `W9.2`, `W11.2`
- Scope:
  1. consolidate the retained scenario corpus,
  2. clean up provisional packet names and stale local assumptions,
  3. prepare the repo for a broader hardening pass.
- Evidence:
  1. the retained corpus and the declared interfaces match the actual repo surface.

## 14. Current Conservative Upstream Consumption Baseline
This section summarizes the current honest floor that `DNA OneCalc` should design against now.

### 14.1 Host And Evaluator Seam Floor
1. the primary upstream host/runtime contract is still OxFml's host/runtime packet plus its reduced-profile `DNA OneCalc` supplement,
2. that current OxFml floor is already rich enough to require typed host queries, locale/date-system context, deterministic recalc, and candidate or commit or reject or trace artifacts,
3. the current OxFml reduced-profile baseline still admits mutable defined-name inputs and direct cell bindings for specific semantic lanes,
4. the current OxCalc seam-reference packet confirms that live deterministic driving may also require caller-anchor, structure-context, table-context, and library-context facts,
5. `DNA OneCalc` should therefore keep its public model explicit-input and non-grid while still supporting bounded reference-bearing probes where the upstream seam genuinely requires them.

### 14.2 Function, Catalog, And Help Floor
1. the current downstream catalog and metadata seed is the OxFunc library-context snapshot export,
2. that export is useful and real, but it is a stabilization artifact rather than a final cross-repo ABI,
3. the OxFunc current surface must always be read through the `W050` deferred overlay and the `W051` in-scope-not-complete overlay,
4. the current first help or signature path is therefore snapshot-backed and metadata-limited,
5. the preferred long-term direction remains a provider-backed immutable snapshot model rather than permanent CSV-shaped integration.

### 14.3 Replay And Excel-Comparison Floor
1. `OxReplay` now has an explicit `DNA OneCalc` consumption model, but `DNA ReCalc` remains the generic replay host,
2. the current honest replay floor for OneCalc is `OxFml` through `C3.explain_valid`, not broad `C4` or `C5`,
3. `OxFunc` does not yet provide a separately accepted direct replay-intake floor that OneCalc should depend on,
4. `OxXlObs` currently offers a real Windows live-driver baseline and replay-ready bundle emission, but the live exercised surface is still narrow and the current normalized replay view is explicitly `lossy`,
5. live Excel comparison is Windows-only, while retained replay, diff, and explain over emitted artifacts may be used on other platforms.

### 14.4 Extension And VBA Floor
1. the portable native-extension ABI is a `DNA OneCalc` design objective and can be pursued independently of OxVba's add-in tooling maturity,
2. OxVba's real current floor is embedded host runtime execution with host-provided root objects and partial host-export discovery,
3. `.basproj` is now the canonical project-format direction and already names `Library` and `Addin` outputs,
4. XLL generation and add-in packaging are still planned rather than implemented,
5. Windows COM and Office-style root-object hosting remain Windows-only assumptions unless the host explicitly supplies cross-platform replacements.

## 15. Start-Now Judgment
`DnaOneCalc` should be started now.

That is honest because:
1. `OxFml` already has a real single-formula host floor,
2. `OxFunc` already has a real library/runtime seam,
3. `OxReplay` is already usable infrastructure,
4. `OxXlObs` already provides a live Excel evidence lane,
5. `OxCalc` now has an explicit downstream-host seam-reference note,
6. `OxReplay` now has an explicit `DNA OneCalc` consumption model,
7. the missing work is now mostly about host definition, integration, gating, and product shaping rather than waiting for a hypothetical future lane to exist.

What must remain explicit:
1. `OxFml` and `OxFunc` seams are usable but not forever-frozen,
2. `DNA OneCalc` must not quietly slide toward `OxCalc`,
3. formatting and conditional formatting belong here, but honest staged delivery still matters,
4. the OxFml editor-language-service floor is already real enough to integrate against, but shared host packet freezing and OxFunc-backed help payload closure are still active seam work,
5. live Excel comparison is Windows-only,
6. hosted web and browser/WASM begin without native add-ins,
7. the current replay and Excel-observation floor is still narrower than a broad parity story and must stay labeled that way,
8. the primary product expression is `Live Formula Semantic X-Ray`,
9. the execution model is the numbered hierarchical work breakdown with explicit dependency attributes and evidence gates, not a milestone parade.

## 16. Success Criteria
The first serious `DNA OneCalc` scope should be considered real only when:
1. the hierarchical work breakdown and explicit dependency or gate set are published,
2. a formula string can be entered and evaluated through `OxFml` and `OxFunc` against an explicitly pinned admitted function surface,
3. the host profile is explicit and visible,
4. OxFml-derived diagnostics are visible and trustworthy in the editor,
5. deterministic completion and currently-available function or argument help are integrated into the editor flow,
6. base formatting and effective-display state are visible and honest,
7. replay output can be emitted for at least one nontrivial scenario family,
8. at least one retained scenario family is validated against Excel-facing evidence through `OxXlObs` with provenance and lossiness made explicit,
9. at least one retained formatting or conditional-formatting family exists,
10. the UI is usable and keyboard-first,
11. persisted documents round-trip through the declared initial file format with formatting state intact,
12. replay capture, replay execution, diff, explain, and retained-scenario control are all available through the UI,
13. extension support is either real for the declared desktop host or explicitly out of scope for that host profile.

## 17. Current Open Questions
1. What exact host-profile declarations and gate tables should the repo publish at bootstrap?
2. What exact scenario schema should be frozen first?
3. What exact proof criteria should the `Leptos` spike satisfy?
4. What is the cleanest instance-to-envelope mapping for `SpreadsheetML 2003`?
5. What is the first honest conditional-formatting subset for isolated instances?
6. Which formatting families should be promoted first as the proving spine?
7. Which exact OxFml immutable-edit, diagnostics, completion, signature-help, and validated-completion packets should be pinned at repo bootstrap?
8. What exact OxFunc help-payload or signature-metadata seam is needed so editor help becomes fully useful in the app?
9. Which replay, trace, diff, and provenance surfaces must land in the first real UI wave?
10. What exact portable C-ABI extension contract should govern Windows `.xll` and Linux `.so`?
11. Which current upstream seams should be pinned at repo bootstrap?
12. What exact handoff-packet contract should be emitted toward upstream repos?
13. Which parts of the currently consumed `OxFml` host/runtime interface are already defined in OxCalc seam-reference docs, and how should seam-sync updates be tracked when `DNA OneCalc` pressures interface changes?
14. Which bounded reference-bearing probe packets are worth admitting early without compromising the explicit-input host identity?

## 18. Immediate Interpretation Rule
If a future repo bootstrap, charter, or work packet conflicts with this document:
1. keep `DNA OneCalc` narrower than `OxCalc`,
2. keep replay and comparison first-class,
3. keep the artifact spine explicit,
4. keep the extension contract honest by platform,
5. keep the product centered on `Live Formula Semantic X-Ray`,
6. prefer the numbered work breakdown plus explicit dependencies and evidence over vague milestone prose.

## 19. Authoritative Upstream Reference Set
This section records the current consolidated reference set that `DNA OneCalc` should use inside this flattened pack.

### 19.1 Reference Use Rule
1. Foundation doctrine remains higher-precedence than repo-local restatements where applicable, especially for replay governance and host topology.
2. In this flattened pack, each repo has been consolidated into one merged reference document.
3. Those merged docs preserve the original source filenames and contents so the pack remains self-contained even though the original hierarchy has been removed.
4. This pack keeps scope and status truth from `CHARTER.md`, `CURRENT_BLOCKERS.md`, worklists, spec indices, and the retained spec documents.
5. If a required downstream surface still has no good upstream doc, that remains upstream documentation debt rather than permission to invent a private OneCalc contract.

### 19.2 Consolidated Reference Documents
1. `OXFML_REFERENCE.md` - consolidated OxFml evaluator, host/runtime, FEC/F3E, language-service, formatting, conditional-formatting, and replay reference set.
2. `OXFUNC_REFERENCE.md` - consolidated OxFunc function/value semantics, snapshot/catalog metadata, typed host-query bundle, replay packet, and extension-seam reference set.
3. `OXREPLAY_REFERENCE.md` - consolidated OxReplay replay-consumption, bundle/witness, adapter/capability, and DNA ReCalc host reference set.
4. `OXXLOBS_REFERENCE.md` - consolidated OxXlObs Excel observation, provenance, bundle emission, capability, scenario, CLI, and retained evidence reference set.
5. `OXCALC_REFERENCE.md` - consolidated OxCalc seam-reference and coordinator-facing evaluator-consumer reference set.
6. `OXVBA_REFERENCE.md` - consolidated OxVba hosting, project model, platform profile, host bridge, and planned add-in/XLL reference set.

### 19.3 Current Upstream Documentation Gaps
1. `OxFml` still does not provide one fully frozen end-to-end `DNA OneCalc` integration contract; the current truth remains a host/runtime packet, a reduced-profile OneCalc supplement, and status companions.
2. `OxFml` language-service integration is still incomplete upstream: there is no frozen shared immutable edit packet, no frozen validated-completion result packet, and no frozen OxFunc-backed help or signature payload contract.
3. `OxFml` still admits direct cell bindings and other reference-bearing facts for specific semantic lanes, while the intended OneCalc public model stays explicit-input; that tension is explicit but not fully closed upstream.
4. `OxFunc` still does not provide one consolidated downstream integration contract for help/signature metadata, runtime snapshot delivery, replay use, and extension-facing metadata; the current truth remains stitched from multiple provisional docs plus the current-surface overlays.
5. `OxReplay` now has a `DNA OneCalc` consumption model, but OneCalc still consumes replay as infrastructure rather than through a dedicated app-facing host contract, and the accepted replay floor remains uneven across lanes.
6. `OxXlObs` still has no dedicated `DNA OneCalc` comparison contract, its live exercised surface is narrow, and its current replay-facing normalized view remains explicitly `lossy`.
7. `OxVba` now has a clearer project-format direction through `.basproj`, but add-in generation and XLL support are still planned rather than implemented.
8. No `Ox*` repo currently owns a stable `SpreadsheetML 2003` isolated-instance persistence contract for `DNA OneCalc`; that mapping remains a local OneCalc design lane informed by Foundation reference corpus rather than current upstream product docs.


