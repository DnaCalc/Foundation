`DNA OneCalc` is the single-node proving host and product shell that combines `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs` into an interactive `Twin Oracle Workbench`. It must remain narrower than `OxCalc`, keep replay and comparison first-class, preserve retained evidence lineage, expose full replay visibility and control in the UI, and stay honest about platform limits, capability floors, lossy projections, and provisional upstream seams.

You are working inside the `OxXlObs` repo.

Goal:
Improve the `OxXlObs` documentation set so `DNA OneCalc` can consume Excel-observation evidence cleanly and honestly. This is a docs-first pass. Do not change runtime code unless a tiny supporting doc-generation fix is unavoidable; if so, keep it minimal and explain why.

Read first:
1. `.\README.md`
2. `.\CHARTER.md`
3. `.\OPERATIONS.md`
4. `.\docs\spec\README.md`
5. `.\docs\IN_PROGRESS_FEATURE_WORKLIST.md`
6. `.\CURRENT_BLOCKERS.md`

Then read:
1. `..\Foundation\notes\DNA_ONECALC_SCOPE_AND_SPEC.md`

Focus especially on:
1. `docs\spec\OXXLOBS_SCOPE_AND_BOUNDARY.md`
2. `docs\spec\OXXLOBS_ARCHITECTURE_AND_CAPTURE_MODEL.md`
3. `docs\spec\OXXLOBS_ENVIRONMENT_AND_PROVENANCE_MODEL.md`
4. `docs\spec\OXXLOBS_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`
5. `docs\spec\OXXLOBS_CAPABILITY_AND_PACK_TRACEABILITY.md`
6. `docs\spec\OXXLOBS_SCENARIO_REGISTER.md`
7. `docs\spec\OXXLOBS_CLI_CONTRACT.md`
8. `docs\spec\OXXLOBS_IMPLEMENTATION_BASELINE.md`
9. `docs\test-runs\W006_STABLE_WINDOWS_EXECUTION_DRIVER.md`
10. `docs\test-runs\W007_FIRST_CROSS_REPO_REPLAY_AND_DIFF_CONSUMPTION.md`

Task:
Review the current docs and improve them so the OneCalc team can understand exactly how `DNA OneCalc` should consume `OxXlObs` for:
1. Windows live Excel observation,
2. provenance-rich retained evidence,
3. bundle and handoff emission,
4. the first honest comparison envelope,
5. the current lossy replay-facing normalized view,
6. platform limits and labeling rules,
7. future richer diff or equality evolution.

Priority outcomes:
1. Make the first OneCalc-facing comparison baseline explicit.
2. Define the first honest comparison envelope in canonical local docs.
3. Clarify which surfaces are directly observed, derived, unavailable, or capture-loss-labeled.
4. Clarify what `DNA OneCalc` should show in the UI when it consumes retained Excel evidence.
5. Keep the Windows-only live path explicit and impossible to misread.
6. Clarify the current role and limits of the lossy normalized replay projection.
7. If there is no good canonical local note for OneCalc as a downstream consumer, add one narrow canonical spec note under `docs\spec\`.

Important constraints:
1. `OxXlObs` owns observation and evidence capture, not Excel semantics and not replay semantics.
2. Do not overclaim the current live-driver surface beyond what the retained evidence and current test-run docs justify.
3. Keep lossy or inferred surfaces visibly distinct from direct observation.
4. Preserve Foundation and `OxReplay` precedence for replay doctrine and generic replay-host concerns.
5. Be explicit where the current comparison floor is still narrow.

Deliverables:
1. Updated `OxXlObs` docs.
2. If needed, one improved canonical local downstream-consumer note for `DNA OneCalc`.
3. A short final summary listing:
   - files changed,
   - the authoritative `OxXlObs` doc set `DNA OneCalc` should now use,
   - remaining gaps that still belong in Foundation, `OxReplay`, or sibling repos.

Verification:
1. Verify internal links and file references you touched.
2. Check that `docs\spec\README.md` matches the post-edit canonical set.
3. Check that no wording implies broader Excel equivalence than the current direct evidence supports.
4. Keep the repo’s authority model clean: canonical specs in `docs\spec`, implementation evidence in `docs\test-runs`, status truth in worklist/blockers.
