`DNA OneCalc` is the single-node proving host and product shell that combines `OxFml`, `OxFunc`, `OxReplay`, and `OxXlPlay` into an interactive `Twin Oracle Workbench`. It must stay narrower than `OxCalc`, keep replay and comparison first-class, preserve retained evidence lineage, and remain explicit about Windows-only live Excel capture, lossy projections, and provisional comparison floors.

You are working inside the `OxXlPlay` repo.

Goal:
Do a narrower docs-first pass that creates or tightens the canonical OneCalc-facing observation-consumer contract for `OxXlPlay`. Do not change code. Only touch docs needed to make the downstream comparison baseline and observation-envelope story clear.

Read only these first:
1. `.\README.md`
2. `.\CHARTER.md`
3. `.\docs\spec\README.md`
4. `.\docs\spec\OXXLPLAY_SCOPE_AND_BOUNDARY.md`
5. `.\docs\spec\OXXLPLAY_ARCHITECTURE_AND_CAPTURE_MODEL.md`
6. `.\docs\spec\OXXLPLAY_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`
7. `.\docs\spec\OXXLPLAY_SCENARIO_REGISTER.md`
8. `.\docs\spec\OXXLPLAY_IMPLEMENTATION_BASELINE.md`
9. `.\docs\test-runs\W006_STABLE_WINDOWS_EXECUTION_DRIVER.md`
10. `.\docs\test-runs\W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION.md`
11. `..\Foundation\notes\DNA_ONECALC_SCOPE_AND_SPEC.md`

Task:
Improve the docs so `DNA OneCalc` can understand:
1. the first honest comparison-ready observation family,
2. the first comparison envelope,
3. which surfaces are direct, derived, unavailable, or capture-loss-labeled,
4. how current lossy replay-facing normalized views must be labeled and interpreted,
5. that live Excel capture is Windows-only.

Preferred output:
1. add one narrow canonical spec note under `docs\spec\` for `DNA OneCalc` as a downstream consumer of `OxXlPlay`,
2. update `docs\spec\README.md` to index it,
3. update whichever of the existing spec docs most directly need cross-links or clarifications,
4. update `docs\IN_PROGRESS_FEATURE_WORKLIST.md` only if needed to reflect the new downstream-consumer clarification.

Constraints:
1. `OxXlPlay` owns observation and retained evidence, not replay doctrine and not Excel semantic truth.
2. Do not overclaim current comparison breadth.
3. Keep direct observation distinct from derived or lossy normalized views.
4. Be explicit where the current floor is narrow or Windows-only.

Deliverables:
1. updated docs,
2. a short final summary listing changed files, the authoritative `OxXlPlay` doc set `DNA OneCalc` should use, and remaining gaps.
