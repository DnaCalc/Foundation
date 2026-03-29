# DNA OneCalc One-Level-Deeper Plan

Run id: `20260327-085833-dna-onecalc-review-pass-01`

This plan sharpens the current `DnaOneCalc` scope by turning it into a governed scenario-native workbench plan.

## Guiding decision
`DnaOneCalc` should be bootstrapped as a `Twin Oracle Workbench` over a scenario artifact spine.

Interpretation:
1. the repo is not primarily “a UI over libraries,”
2. it is not primarily “a desktop calculator app,”
3. it is a scenario authoring, execution, replay, compare, explain, distill, and handoff surface over a single isolated calculation instance,
4. with `Live Formula Semantic X-Ray` as the main product expression of the workbench:
   - parse tree,
   - evaluation trace,
   - semantic diff,
   - provenance.

## Artifact spine
The bootstrap should freeze these repo-owned artifacts before UI/runtime hardening goes far:

1. `Scenario`
   - the canonical authored unit,
   - contains formula, explicit inputs, display context, host profile, capability declarations, and retained notes.
2. `ScenarioRun`
   - a concrete execution of a scenario under a specific runtime/build/profile.
3. `Observation`
   - an imported Excel-observed or other external truth artifact,
   - Windows-only for live Excel capture.
4. `Comparison`
   - a typed comparison between a `ScenarioRun` and an `Observation` or another `ScenarioRun`.
5. `Witness`
   - a retained minimized or unreduced counterexample bundle.
6. `HandoffPacket`
   - a repo-addressable upstream pressure artifact that points to the exact scenario, run, comparison, and witness lineage.

## Deeper dependency tree and explicit gates
Planning should be expressed as a dependency tree with explicit gates, not as a milestone ladder.

Gate naming rule:
1. every node needs a stable gate identifier,
2. the identifiers need explicit evidence requirements,
3. they do not need to use `PACK.*` naming if the repo adopts a clearer local gate scheme.

### D0: Scope and artifact freeze
Depends on:
1. Foundation doctrine,
2. current upstream seam inventory.

Gate:
1. `DNA_ONECALC_PROFILE_LADDER.md`
2. `DNA_ONECALC_PLATFORM_CAPABILITY_MATRIX.csv`
3. `DNA_ONECALC_SCENARIO_SCHEMA.md`
4. `DNA_ONECALC_UPSTREAM_HANDOFF_ARTIFACTS.md`
5. explicit seam-pin manifest for `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs`
6. `meta-check` definition for the repo

### D1: UI/runtime proving spike
Depends on:
1. `D0`.

Gate:
1. `Leptos` app shell proof of life,
2. desktop shell proof of life,
3. browser/WASM proof of life,
4. measured bundle/runtime evidence,
5. explicit escalation or fallback rule if the stack is not convincing.

### D2: Scenario-native workbench core
Depends on:
1. `D0`,
2. `D1`.

Gate:
1. scenario editor for formula plus explicit inputs,
2. execution flow against `OxFml` + `OxFunc`,
3. first replay capture through `OxReplay`,
4. visible workbench mode line,
5. persisted local scenario format separate from SpreadsheetML.

### D3: Live Formula Semantic X-Ray baseline
Depends on:
1. `D2`.

Gate:
1. parse tree visible in the UI,
2. evaluation trace visible in the UI,
3. semantic diff reachable from the same workbench,
4. provenance visible in the UI.

### D4: First twin-oracle lane
Depends on:
1. `D2`,
2. `D3`,
3. `OxXlObs`.

Gate:
1. Windows-only import or live-capture lane via `OxXlObs`,
2. first bounded retained comparison family,
3. compare and explain UI,
4. first witness-distill action,
5. retained scenario corpus root in the repo.

Recommended first family:
1. formatting-sensitive `TEXT`,
2. locale,
3. date-system display cases.

### D5: Explicit-input host widening
Depends on:
1. `D2`.

Gate:
1. stable explicit input-slot model,
2. typed host queries or profile inputs,
3. bounded seam-sensitive packet only if required by evidence,
4. scenario diff and compare across profile versions.

### D6: Formatting and presentation widening
Depends on:
1. `D5`,
2. current upstream formatting seams.

Gate:
1. persisted base formatting state,
2. honest font/color subset,
3. effective-display projection,
4. richer result visualization,
5. formatting-aware comparison views.

### D7: Conditional-formatting lane
Depends on:
1. `D6`,
2. current upstream CF carrier floor.

Gate:
1. isolated-instance conditional-format rule model,
2. replay-visible rule consequences,
3. Windows-only Excel comparison families for CF,
4. retained CF witnesses and handoffs.

### D8: Persistence widening
Depends on:
1. `D5`,
2. `D6`.

Gate:
1. SpreadsheetML 2003 import/export for isolated instances,
2. resolved instance-to-envelope mapping,
3. round-trip proof without workbook-graph semantics.

### D9: Portable extension ABI widening
Depends on:
1. `D5`,
2. `OxFunc` registered-external seam,
3. staged `OxVba` readiness.

Gate:
1. desktop extension surface defined as portable C ABI,
2. Windows `.xll` loading,
3. Linux `.so` loading over the same ABI,
4. browser/WASM still honestly declares no native add-in support.

## Concrete work packets
1. `WP-001 Profile Ladder Freeze`
   - define `OC-H0` and `OC-H1` as versioned profiles with explicit non-goals.

2. `WP-002 Platform Capability Matrix`
   - declare desktop Windows, desktop Linux, and browser/WASM capabilities for replay, Excel observation, persistence, and add-ins.

3. `WP-003 Scenario Schema`
   - freeze the first authored scenario schema and its stable IDs.

4. `WP-004 Seam Pin Manifest`
   - pin consumed upstream seam versions and identify provisional seams.

5. `WP-005 Workbench Action Model`
   - define the named user actions and state transitions for run, replay, compare, explain, distill, and handoff.

6. `WP-006 Live Formula Semantic X-Ray Contract`
   - define parse-tree, evaluation-trace, semantic-diff, and provenance surfaces as first-class product views.

7. `WP-007 Minimal Corpus`
   - seed the repo with a small retained scenario family focused on display-sensitive truth.

8. `WP-008 UI Mode Line And Panels`
   - define the minimal visible panel model for formula, inputs, result, replay, trace, comparison, and handoff.

9. `WP-009 Upstream Handoff Contract`
   - define the generated artifact shape for upstream requests and evidence bundles.

10. `WP-010 First Windows Twin-Run`
   - prove end-to-end capture, compare, explain, and witness retention against Excel.

11. `WP-011 Portable Extension ABI Contract`
   - define the Windows `.xll` and Linux `.so` loader contract over one declared portable C ABI.

12. `WP-012 Deferred Widening Register`
   - explicitly track additional formatting breadth, SpreadsheetML hardening, and extension work as later widening lanes instead of bootstrap ambiguity.

## Things that should now be explicitly deferred
1. full conditional-formatting parity beyond the declared isolated-instance lane,
2. SpreadsheetML as the only persisted truth artifact,
3. broad extension breadth beyond the portable C-ABI lane,
4. any broad cell/reference environment,
5. any suggestion of multi-node or `OxCalc`-style semantics.
