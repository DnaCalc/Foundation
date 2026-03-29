# DNA OneCalc Repo Readiness And Outstanding Work

Run id: `20260326-200003-dna-onecalc-scope-pass-01`

## Executive judgment
`DnaOneCalc` can be bootstrapped now.

It should not wait for:
1. `OxCalc` TreeCalc maturity,
2. full `.xll` breadth,
3. full `OxVba` host/add-in closure,
4. pack-grade replay closure in every sibling repo.

But the repo must start with an honest dependency map:
1. integrate `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs` immediately,
2. treat `OxVba` as a staged lane,
3. treat `OxCalc` as informative but non-blocking for the initial host,
4. build replay and retained evidence into the first wave rather than bolting them on later,
5. treat cell formatting and conditional formatting as first-class product scope rather than cosmetic follow-on work,
6. treat the repo as a co-development and upstream-pressure program rather than a frozen downstream consumer.

The most strategically valuable expression of that is:
1. `DnaOneCalc` as a `Twin Oracle Workbench`,
2. not just a single-cell calculator, but the interactive place where DNA behavior, Excel-observed behavior, replay, diff/explain, witness distillation, and upstream handoff all meet.

## Fresh executable evidence used in this pass
Commands run during this research pass:

1. `C:\Work\DnaCalc\OxReplay> pwsh ./scripts/meta-check.ps1 -Fast -NoArtifacts`
   - passed
2. `C:\Work\DnaCalc\OxXlObs> pwsh ./scripts/meta-check.ps1 -Fast -NoArtifacts`
   - passed
3. `C:\Work\DnaCalc\OxFml> cargo test -p oxfml_core --test replay_retained_and_host_policy_tests --test w047_host_readiness_tests --test host_tests`
   - passed
4. `C:\Work\DnaCalc\OxFunc> cargo test -p oxfunc_core call_register_id -- --nocapture`
   - passed

Additional executable evidence from the earlier cross-repo status pass remains relevant:
1. `OxCalc` workspace tests passed in that pass, while `cargo fmt --check` showed current formatting drift.
2. `OxFunc` broader `--tests --lib` cargo test coverage passed, while full-crate hygiene remained red because example probes lagged current surface changes.
3. `OxVba` meta-check had already been observed to fail on formatting drift after substantial smoke/governance execution.

## Primary repo assessments

### OxFml
Readiness for `DnaOneCalc`: high, for a narrow single-formula host.

What is already real:
1. `SingleFormulaHost`, typed host output, and first replay capture packet exist in code.
2. Host-policy docs already define DNA OneCalc as a downstream reduced-profile host, not as a coordinator.
3. Current retained fixture families already cover defined-name recalc, direct host-query cases, `@`, `_xlfn.SINGLE`, `LET`, `LAMBDA`, spill publication via `SEQUENCE`, and format-sensitive `TEXT`.
4. OxFml already has semantic-formatting work and explicit format/display consequence artifacts.
5. OxFml already has an initial conditional-formatting/data-validation restricted-carrier floor.
6. The targeted host-readiness and replay-policy tests passed in this pass.

What `DnaOneCalc` can safely consume now:
1. the current single-formula host model,
2. typed host query bundle and return-surface shape,
3. semantic formatting as a real evaluator seam rather than a UI-only concern,
4. the first bounded CF/DV carrier model as an upstream design floor,
5. a narrower explicit-input profile carved from the broader OxFml host packet.

Main open work that matters:
1. broader host/runtime packet closure beyond the current first host slice,
2. broader replay promotion and run-grade retained evidence packaging,
3. wider `CALL` / `REGISTER.ID` and external-provider seam freeze,
4. broader semantic-formatting family coverage and richer display-boundary closure,
5. full conditional-formatting parity beyond the current restricted carrier floor,
6. continued widening beyond the current reduced host packet.

Practical implication:
1. start the repo against the current `OxFml` host packet,
2. pin the seam version explicitly,
3. narrow the first product claim to explicit host-bound inputs rather than an open cell/reference environment,
4. use formatting support in the first repo wave,
5. treat full conditional-formatting support as explicit staged widening rather than a hidden assumption,
6. reserve any caller-sensitive or anchor-sensitive context for a later proving-mode packet only if empirical evidence forces it,
7. do not wait for wider coordinator-style policy or full host breadth.

### OxFunc
Readiness for `DnaOneCalc`: high enough for the first host, but seam-freeze and provider breadth remain partial.

What is already real:
1. current library-context export and runtime consumer model,
2. broad built-in function implementation,
3. callable and higher-order runtime slices,
4. early `CALL` / `REGISTER.ID` registration seam,
5. generated XLL bridge and export-spec path,
6. retained local replay bundle and capability manifest.

What the research pass verified:
1. targeted `CALL` / `REGISTER.ID` tests passed,
2. the narrower core test surfaces are healthy,
3. warnings and stale example/test hygiene still exist.

Main open work that matters:
1. no real host-backed `RegisteredExternalProvider` is yet closed in-repo,
2. typed context/query and return-surface freezes are still partial,
3. callable transport and some helper formation still cross into `OxFml`-owned territory,
4. `HYPERLINK` and `IMAGE` publication/provider boundaries remain open,
5. broader replay promotion remains below pack-grade.

Practical implication:
1. use `OxFunc` now for built-ins and pinned runtime/library seams,
2. define a narrow registered-external story for `DnaOneCalc`,
3. do not promise full add-in/UDF breadth in the first repo milestone.

### OxReplay
Readiness for `DnaOneCalc`: high.

What is already real:
1. canonical bundle validation and indexing,
2. adapter conformance validation,
3. replay, diff, explain, and witness-distillation core,
4. `DNA ReCalc` CLI host,
5. retained test-runs across validate/replay/diff/explain/pack export,
6. current intake of `OxCalc`, `OxFml`, and `OxXlObs` artifacts.

What the research pass verified:
1. current repo meta-check passed,
2. workspace tests are green,
3. the repo is beyond bootstrap and is already a usable infrastructure dependency.

Main open work that matters:
1. worksets `W004` through `W006` remain active,
2. broader adapter intake is still widening,
3. `BLK-REPLAY-002` exists around an `OxCalc` manifest lifecycle gap.

Practical implication:
1. `DnaOneCalc` should depend on `OxReplay` from day one,
2. that `OxCalc`-specific blocker does not block the new repo,
3. the app should emit replay artifacts immediately rather than inventing a local tracing format,
4. replay capture, replay execution, diff, explain, and witness handling should be fully surfaced in the UI rather than remaining CLI-only.

### OxXlObs
Readiness for `DnaOneCalc`: high for empirical comparison on the first retained family.

Platform boundary:
1. `OxXlObs` and live Excel-facing comparison are Windows-only.

What is already real:
1. live Windows capture driver,
2. retained Excel environment/provenance/bridge envelopes,
3. replay-ready bundle emission,
4. normalized replay projection,
5. first `OxReplay` consumption path over live Excel evidence.

What the research pass verified:
1. current repo meta-check passed,
2. the retained live capture family is present and coherent,
3. the repo already provides concrete Excel-facing evidence, not just planning docs.

Main open work that matters:
1. `W007` remains open on the `OxCalc` comparison leg,
2. narrower `OxFml` and `OxVba`-oriented scenario families have not yet been widened much,
3. formatting and conditional-formatting comparison families for future `DnaOneCalc` output need explicit widening,
4. scenario-library governance with future `DnaOneCalc` output needs explicit planning.

Practical implication:
1. `DnaOneCalc` should use `OxXlObs` immediately for the first empirical comparison lane,
2. start with a small bounded scenario family,
3. include formatting or conditional-formatting truth early,
4. keep the lane explicitly Windows-only,
5. do not wait for broad differential coverage.

### OxVba
Readiness for `DnaOneCalc`: useful later, not a start blocker.

What is already real:
1. very broad compiler/runtime/host/COM/project substrate,
2. strong host and COM evidence base,
3. project/add-in/XLL planning has matured substantially,
4. code already contains XLL shim generation and XLOPER support surfaces,
5. bounded host-extension attach truth and real COM oracle evidence exist.

What remains open for the app's intended add-in story:
1. `IP-10` oracle closure and `IP-11` formal foldback remain open,
2. current hygiene is not fully clean,
3. the add-in/XLL product lane is still staged work rather than an already-proved downstream integration surface.

Practical implication:
1. do not block repo creation on `OxVba`,
2. treat `OxVba` integration as the later desktop extension milestone,
3. keep the first add-in/UDF claim narrow and explicit.

### OxCalc
Readiness for `DnaOneCalc`: informative, but not required for the first repo scope.

What matters here:
1. `OxCalc` is already materially advanced and has real TreeCalc and replay evidence,
2. it demonstrates strong downstream proving patterns,
3. but its mission is multi-node calculation, not single-node product hosting.

Practical implication:
1. borrow repo patterns and retained-evidence discipline from `OxCalc`,
2. do not make it a hard dependency for the initial app mission,
3. keep the new repo's identity distinct from TreeCalc.

### OxIde
Readiness for `DnaOneCalc`: low direct dependency value.

What matters here:
1. `OxIde` proves that a thin Rust editor shell is already acceptable in the program,
2. but it is tightly focused on `OxVba`,
3. and it does not yet carry the same evidence/governance maturity as the other sibling repos.

Practical implication:
1. do not force `DnaOneCalc` to share editor architecture with `OxIde`,
2. treat it as an optional inspiration source, not as an upstream dependency.

## True blockers versus staged later work

### Not true blockers for repo bootstrap
1. `OxCalc` TreeCalc widening
2. `OxReplay` `OxCalc` manifest `C4` dispute
3. `OxVba` full parity closure
4. broad `.xll` support across all hosts
5. broad `OxXlObs` differential families

### Real constraints that must shape the bootstrap
1. `DnaOneCalc` must pin the current `OxFml` host packet and treat it as a working contract rather than an assumed stable forever ABI.
2. `DnaOneCalc` must pin the current `OxFunc` library-context and registered-external seams and keep the first extension claim narrow.
3. The first product claim should use explicit host-bound inputs rather than a generic cell/reference environment.
4. If caller-sensitive or anchor-sensitive context is ever admitted, it must remain a bounded proving packet rather than the default host model.
5. Cell formatting must be first-wave product scope rather than a later visual add-on.
6. Full conditional-formatting support should be planned explicitly against the current bounded OxFml carrier floor rather than assumed to come for free.
7. Replay must be first-wave architecture, fully visible, and fully controllable through the UI.
8. The repo should produce structured upstream requirement deltas and repo-addressable work requests rather than pretending the current libraries are frozen.
9. The first Excel comparison family must be bounded, retained, and explicitly Windows-only.
10. The desktop add-in story must be clearly separated from hosted web and browser/WASM hosts, which start with no add-in support.

## Recommended dependency order
1. Integrate `OxFml`.
2. Integrate `OxFunc`.
3. Integrate `OxReplay`.
4. Wire the first bounded empirical lane through `OxXlObs`.
5. Add SpreadsheetML 2003 persistence.
6. Stage desktop Windows/Linux extension work and `OxVba` experiments later.

## Start-now recommendation
Create `..\DnaOneCalc` now, with this declared floor:
1. `OC-H0` and `OC-H1` are the first repo target,
2. `OC-H1` is the explicit-input host profile, not a generic cell/reference environment,
3. cell formatting is in first-wave scope,
4. replay is built in and fully surfaced through the UI,
5. Excel comparison starts with one bounded retained Windows-only family, ideally formatting-sensitive,
6. full conditional-formatting support is explicitly planned as an early widening lane,
7. desktop add-ins are staged for Windows and Linux only,
8. hosted web and browser/WASM begin without add-in support,
9. upstream requirement and handoff production is part of the repo mission,
10. `OxCalc` is not pulled into the repo mission.

That is the narrowest honest scope that still makes the project strategically valuable.
