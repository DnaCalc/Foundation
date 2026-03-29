# DNA OneCalc Independent Review Memo

Run id: `20260327-085833-dna-onecalc-review-pass-01`

## Findings
1. The current planning artifacts are slightly doctrine-unsafe around scope. Foundation currently defines `DNA OneCalc` as a no-reference-resolution proving host on a single-cell or defined-name substrate, while the planning note admits optional caller-sensitive or anchor-sensitive packets and early full conditional-formatting breadth. That is a real interpretation shift and should be resolved by explicit doctrine edits or by narrowing the plan, not by quiet drift.

2. The current readiness judgment is too dependency-heavy and not sufficiently `DnaOneCalc`-owned. The planning run proves that `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs` are usable inputs, but it does not yet freeze the core `DnaOneCalc` artifact spine: host profiles, scenario schema, capability matrix, seam pins, replay-control contract, persistence mapping, and upstream handoff artifacts.

3. The `OC-H0` / `OC-H1` / `OC-H2` ladder is a useful scope ladder, but it is not yet a formal readiness model. It is not currently bound to explicit `profile_id`, `profile_version`, capability gates, required packs, or a repo `meta-check` contract. Until that exists, the ladder is descriptive rather than governable.

4. The plan is hardening second-order product choices before first-order artifact choices. Picking `Leptos`, Tauri, browser/WASM, and a future WASI harness is fine, but the more urgent question is: what is the canonical unit of truth in `DnaOneCalc`? Right now scenario, instance, workbook envelope, replay bundle, and handoff packet all appear, but there is no single declared primary artifact model.

5. Conditional formatting, SpreadsheetML persistence, and add-ins are still too prominent in the early identity of the repo. They are strategically good directions, but they should be staged widening lanes rather than identity-defining bootstrap scope. The more stable early identity is a scenario-native `Twin Oracle Workbench`.

## Best Direction
The single smartest direction is to make `DnaOneCalc` a scenario-native `Twin Oracle Workbench`, not a “single-cell spreadsheet app.”

That means the primary object is a durable scenario artifact:
1. formula,
2. explicit inputs,
3. display context,
4. host capability profile,
5. replay capture,
6. optional Excel observation,
7. upstream handoff metadata.

From one surface, the user should be able to run:
1. `DNA-only`
2. `Excel-observed`
3. `Twin compare`
4. `Replay`
5. `Diff`
6. `Explain`
7. `Distill`
8. `Handoff`

This is the most accretive direction because every user action can become retained evidence and upstream pressure, rather than disposable UI state.

## One Level Deeper
1. Freeze doctrine first.
   - Either keep `DnaOneCalc` strictly within the current no-reference-resolution Foundation definition, or explicitly amend Foundation doctrine before the repo bootstrap claims broaden further.

2. Define the four primary repo-owned planning artifacts before implementation hardens:
   - `DNA_ONECALC_PROFILE_LADDER.md`
   - `DNA_ONECALC_PLATFORM_CAPABILITY_MATRIX.csv`
   - `DNA_ONECALC_SCENARIO_SCHEMA.md`
   - `DNA_ONECALC_UPSTREAM_HANDOFF_ARTIFACTS.md`

3. Recenter the milestone ladder around the scenario artifact spine:
   - `P0` profile and seam freeze,
   - `P1` scenario-native workbench core,
   - `P2` first retained Windows-only twin-run family,
   - `P3` explicit-input widening,
   - `P4+` formatting/CF/persistence/add-in widening lanes.

4. Add a `DnaOneCalc`-owned readiness matrix alongside the sibling-repo readiness matrix.
   - Measure profile freeze, seam pins, capability declarations, scenario schema, first replay family, first Excel family, UI replay surfaces, and handoff emission.

5. Make the first retained proving family narrow and high-signal.
   - Best candidate: formatting-sensitive `TEXT`, locale, and date-system cases before full conditional-formatting breadth.

6. Treat replay UI as a first-wave contract, not a later embellishment.
   - `Run`, `Capture`, `Import`, `Replay`, `Diff`, `Explain`, `Distill`, and `Emit Handoff` need visible, named affordances early.

7. Split “nice product shell” work from “semantic proving spine” work.
   - This avoids polishing an interface before the core scenario model and evidence pipeline are stable.

8. Defer full conditional-formatting parity, SpreadsheetML hardening, and desktop add-in breadth into explicit widening lanes after the scenario spine is working.
