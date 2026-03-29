# Cross-Repo Status Review

Run id: `20260326-004351-cross-repo-status-pass-01`

## Scope
- In scope: `OxCalc`, `OxFml`, `OxFunc`, `OxVba`, `OxReplay`, `OxXlObs`, `OxIde`
- Out of scope: `Foundation`
- Explicitly excluded by user direction after run start: `DnaVisiCalc`

## Method
- Read each repo's top doctrine and scope docs where present.
- Read current blockers, in-progress worklists, representative code, and retained artifact roots.
- Prefer fresh executable evidence when the repo exposes a runnable command surface.
- Treat documentation as claims, then compare those claims against code and retained outputs.

## Overall Assessment
- The program is materially real, but uneven by lane.
- `OxVba`, `OxFunc`, `OxFml`, and `OxCalc` are all well beyond bootstrap; they have substantial code, doctrinal structure, and retained evidence.
- `OxReplay` and `OxXlObs` are younger but already useful as shared proving and observation infrastructure.
- `OxIde` is still a thin slice: implemented enough to be real, but far behind the doctrine/evidence maturity of the other repos.
- The most common current gap is not "no implementation"; it is mismatch between doctrine, retained evidence style, and current verification hygiene.

## Cross-Repo Findings
- The strongest implementation breadth today sits in `OxVba`.
- The broadest function-semantic surface today sits in `OxFunc`.
- The strongest cross-lane proving substrate today is the `OxCalc` + `OxReplay` + `OxXlObs` cluster.
- `OxFml` is advanced and test-rich, but its retained evidence is still more fixture-oriented than run-oriented.
- `OxIde` is the least systematized repo in the set and will likely need the most structural cleanup relative to its current size.

## Repo Detail

### OxCalc
- Intended scope: the multi-node core calculation engine lane, with Rust-first realization of structural state, dependency/invalidation, coordinator/publication semantics, TraceCalc/TreeCalc harnesses, and replay-backed staged progression.
- Current implemented floor: real Rust workspace with `oxcalc-core`, `oxcalc-tracecalc`, and CLI crates; local TreeCalc flow, TraceCalc reference machine, retained-failure handling, replay bundle machinery, and seam-backed upstream-host scaffolding are all present.
- Fresh executable evidence: `cargo test --workspace --quiet` passed. Explorer corroboration also reported passing compare scripts for `w019` and `w025`. A repo-local `cargo fmt --check` currently fails, so validation hygiene is not fully clean.
- Current outputs: checked-in run trees under `docs/test-runs/core-engine/`. The current TreeCalc local baseline `w025-treecalc-local-baseline` reports `13` cases, `0` expectation mismatches, and `9 published / 3 rejected / 1 verified_clean`.
- Outstanding work: `W024` program-grade replay widening plus `W025`-`W031` TreeCalc semantic completion. The main open lanes are broader OxFml bind/reference intake, richer runtime-derived effects and overlays, broader oracle/replay breadth, and assurance refresh.
- Important mismatch: some canonical plan docs still speak as if no TreeCalc-ready workset has executed, but the code and retained `w025` baseline show that a real partial TreeCalc pipeline already exists.
- Assessment: advanced and productive, with real retained proving artifacts; the main problem is document lag and remaining closure work, not lack of implementation.

### OxFml
- Intended scope: the formula-language and single-node evaluator lane, including grammar/parse/bind, evaluator session lifecycle, FEC/F3E ownership, commit/reject/trace schema, and formula-semantic formatting effects.
- Current implemented floor: `oxfml_core` contains real syntax, parse, bind, session/runtime, host-facing, replay, library-context, language-service, and higher-order callable surfaces. Lean and TLA artifacts are checked in and active.
- Fresh executable evidence: `cargo test -p oxfml_core --quiet` passed in the local audit.
- Current outputs: there is no checked-in `docs/test-runs` root today. Instead the repo retains many canonical fixtures under `crates/oxfml_core/tests/fixtures/`, including replay cases, pack-candidate bundles, witness-distillation manifests, and pinned OxFunc seam corpora. TLA states are checked under `formal/tla/states/26-03-26-*`.
- Outstanding work: broader grammar and table semantics, stand-in host/coordinator packet work, `CALL` / `REGISTER.ID` boundary freezing, broader OxFunc seam closure, and stronger retained evidence packaging.
- Important nuance: OxFml looks advanced in code and tests, but compared with OxCalc or OxReplay it has less checked-in run-level evidence packaging. Its proving style is still more fixture-first than run-first.
- Assessment: advanced and healthy. It does not look blocked, but it does look like a candidate for later evidence-shape cleanup.

### OxFunc
- Intended scope: the F3E value/function slice, owning worksheet value types, coercion, function/operator semantics, XLL-facing boundary surfaces, and the contract/formal/runtime/test/evidence stack for function semantics.
- Current implemented floor: very large Rust library and large Lean surface. Broad function families, extended values, replay bundle emission, XLL export generation, and library-context export are real. Current code also already contains in-flight `GROUPBY` / `PIVOTBY` scaffolding.
- Fresh executable evidence: `cargo test --manifest-path crates/oxfunc_core/Cargo.toml --tests --lib --quiet` passed `1042` tests. The broader `cargo test --manifest-path crates/oxfunc_core/Cargo.toml --quiet` currently fails compiling example probes because `WorksheetErrorCode::Busy` is not handled in two example files.
- Current outputs: the repo retains both checked-in artifacts and live local outputs. Key current artifacts include the `W21` replay bundle under `.tmp/replay-bundles/oxfunc-w15-v1/`, the `OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv` export, many execution-record docs, and a very large `.tmp` corpus of empirical probe results.
- Outstanding work: `HYPERLINK` and `IMAGE` seam closure, callable and implicit-intersection (`@`) closure, runtime library-context provider/consumer modeling, broader replay promotion, and current-version backlog handling.
- Important mismatch: current docs still overstate full `cargo test` cleanliness. The core function/test surface is strong, but the repo-level example/test hygiene is currently red.
- Assessment: very advanced semantically, but currently carrying verification-hygiene drift. This is a repo where the next cleanup pass can buy a lot without implying the underlying implementation is weak.

### OxVba
- Intended scope: the VBA 7.1 compiler/runtime/language-service lane, including syntax, IR, compiler, runtime, VM/JIT, host model, COM, eventing, declare/native, project model, CLI, conformance, oracle foldback, and formal foldback under the full-compliance program.
- Current implemented floor: extremely broad Rust workspace with many crates and a large retained conformance/evidence corpus. Late-bound COM, much of host parity, event runtime, declare/native lanes, and large parts of the COM/client stack are already materially implemented.
- Fresh executable evidence: `pwsh ./scripts/meta-check.ps1 -Fast -NoArtifacts` progressed through many governance and smoke checks but failed at `cargo fmt --check`, so the repo does not currently have a clean meta-check pass.
- Current outputs: very large retained evidence corpus under `docs/evidence/conformance/`, plus a substantial `conformance/tests/` tree of VBA files. The repo also carries a long implementation log and a detailed in-progress feature register.
- Outstanding work: the worklist explicitly reopens `IP-05` for real-library early-bound activation/model truth; `IP-10` oracle closure and `IP-11` formal foldback remain open; active blockers also still exist around oracle and formal closure.
- Important mismatch: earlier closure language was too broad, and the worklist now explicitly says so. OxVba is mature enough that the main risk is overclaiming closure, not under-implementation.
- Assessment: the most advanced single implementation repo in the program, but still carrying honest closure debt and current formatting drift.

### OxReplay
- Intended scope: shared replay infrastructure for bundle IO, adapter conformance, replay, diff, explain, witness distillation, governance, and the `DNA ReCalc` host surface.
- Current implemented floor: Rust workspace with separate abstractions, bundle, core, diff, explain, distill, governance, conformance, and CLI crates. Initial `OxCalc`, `OxFml`, and `OxXlObs` intake paths are real.
- Fresh executable evidence: `pwsh ./scripts/meta-check.ps1` passed. Workspace tests were green.
- Current outputs: retained test-runs under `docs/test-runs/` cover bundle validation, adapter conformance, replay, diff, explain, pack export, and live `OxXlObs` ingestion.
- Outstanding work: worksets `W004`, `W005`, and `W006` remain active. The key current blocker is `BLK-REPLAY-002`, an OxCalc manifest lifecycle-gap issue that blocks honest local acceptance of an OxCalc `cap.C4` claim.
- Important nuance: this repo is still young, but it is already a functioning proving tool, not just a design shell.
- Assessment: emerging but real, with strong compounding value for later program cleanup and evidence normalization.

### OxXlObs
- Intended scope: live Excel observation and capture, provenance and bridge envelopes, replay-ready bundle emission, and differential witness seeding for downstream replay/comparison consumers.
- Current implemented floor: Rust workspace with scenario, capture, provenance, bundle, bridge, and CLI crates plus a stable Windows execution driver and first cross-repo replay consumption.
- Fresh executable evidence: `pwsh ./scripts/meta-check.ps1` passed.
- Current outputs: the retained live capture family at `states/excel/xlobs_capture_values_formulae_001/` contains `capture.json`, `bundle.json`, `environment.json`, `bridge.json`, `driver-run.json`, `oxreplay-validate-bundle-report.json`, `oxreplay-replay-report.json`, and a normalized replay view.
- Outstanding work: `W007` remains open until the OxCalc comparison leg is retained. Later narrower families for OxFml and OxVba are not yet present.
- Important nuance: this repo already has the first live Excel capture evidence, so it is further along than a casual read of the bootstrap docs might suggest.
- Assessment: focused and productive. It is narrow by design, not weak.

### OxIde
- Intended scope: a console micro-IDE for OxVba, centered on editing, document/session handling, project/workspace and `.basproj` flows, target-aware build/run, language services, and later embedded/LSP paths.
- Current implemented floor: one Rust application that already has a concrete shell, document session, command mode, save/open flow, status/output region, and OxVba build/run integration via `cargo`.
- Fresh executable evidence: `cargo test --quiet` passed `23` tests.
- Current outputs: no retained run corpus or evidence roots were observed. Current evidence is the code itself and the passing tests.
- Outstanding work: most of the stated long-range product scope is still future work, especially project/workspace, `.basproj`, richer OxVba services, and target-aware flows.
- Important mismatch: unlike the other sibling `Ox*` repos, OxIde currently lacks the same doctrine scaffolding pattern. There is no `CHARTER.md`, `OPERATIONS.md`, `CURRENT_BLOCKERS.md`, or `docs/IN_PROGRESS_FEATURE_WORKLIST.md`.
- Assessment: real but thin. It is a usable first shell, not yet a mature repo in the same operational style as the others.

## Suggested Planning Implications
- Treat `OxVba`, `OxFunc`, `OxFml`, and `OxCalc` as advanced lanes that now need cleanup, closure discipline, and doc/evidence synchronization more than bootstrap work.
- Treat `OxReplay` and `OxXlObs` as leverage multipliers for the cleanup phase because they already expose cross-lane truth and retained evidence.
- Treat `OxIde` as a thin-slice repo that likely needs both product work and repo-governance work if it is going to participate on equal footing.
- Expect the next project-wide cleanup to focus heavily on:
  - status freshness and doc drift,
  - validation hygiene (`fmt`, stale examples, stale claims),
  - evidence retention consistency,
  - honest closure language.
