`DNA OneCalc` is the single-node proving host and product shell that combines `OxFml`, `OxFunc`, `OxReplay`, and `OxXlPlay` into an interactive `Twin Oracle Workbench`. It must remain narrower than `OxCalc`, keep replay and comparison first-class, preserve retained evidence lineage, expose full replay visibility and control in the UI, and stay honest about platform limits, capability floors, and provisional upstream seams.

You are working inside the `OxReplay` repo.

Goal:
Improve the `OxReplay` documentation set so `DNA OneCalc` can consume `OxReplay` cleanly as shared replay infrastructure while preserving the rule that `DNA ReCalc` remains the generic replay host and `DNA OneCalc` is a separate proving host. This is a docs-first pass. Do not change runtime code unless a tiny supporting doc-generation fix is unavoidable; if so, keep it minimal and explain why.

Read first:
1. `.\README.md`
2. `.\CHARTER.md`
3. `.\OPERATIONS.md`
4. `.\docs\spec\README.md`
5. `.\docs\IN_PROGRESS_FEATURE_WORKLIST.md`
6. `.\CURRENT_BLOCKERS.md`

Then read:
1. `..\Foundation\notes\DNA_ONECALC_SCOPE_AND_SPEC.md`

Focus especially on the downstream-consumer and replay-governance surface:
1. `docs\spec\OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md`
2. `docs\spec\OXREPLAY_SCOPE_AND_BOUNDARY.md`
3. `docs\spec\OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`
4. `docs\spec\OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md`
5. `docs\spec\DNA_RECALC_HOST.md`
6. `docs\spec\DNA_RECALC_CLI_CONTRACT.md`
7. `docs\spec\OXREPLAY_OXXLPLAY_OBSERVATION_SEAM.md`
8. `docs\spec\OXREPLAY_INITIAL_ADAPTER_INTAKE_PLAN.md`
9. `docs\spec\OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md`

Task:
Review the current docs and improve them so the OneCalc team can understand exactly how `DNA OneCalc` should consume `OxReplay` for:
1. bundle validation,
2. replay,
3. diff,
4. explain,
5. witness handling,
6. scenario-library growth,
7. Excel-observation comparison through `OxXlPlay`,
8. full replay visibility and control through the `DNA OneCalc` UI.

Priority outcomes:
1. Make the non-`DNA ReCalc` downstream-host consumption model explicit.
2. Keep the `DNA ReCalc` boundary explicit and non-confusable.
3. Clarify what a host like `DNA OneCalc` may embed directly from `OxReplay`.
4. Clarify the current honest mode gates for `Replay`, `Diff`, `Explain`, `Distill`, and `Handoff` from a OneCalc perspective.
5. Clarify artifact-lineage obligations for downstream product hosts, including lossy or registry-unpinned inputs.
6. Clarify how `OxXlPlay` inputs should be labeled and interpreted when consumed through `OxReplay`.
7. If there is no sufficient canonical local doc for this, update or extend the existing OneCalc-facing canonical note rather than scattering truth into handoff or status docs.

Important constraints:
1. `OxReplay` must remain shared mechanics only, not a semantics lane.
2. Do not blur `DNA ReCalc` and `DNA OneCalc`.
3. Do not overclaim lane readiness or adapter capability floors that current evidence does not justify.
4. Preserve Foundation precedence for replay doctrine and lifecycle policy.
5. Be explicit wherever the current state is still provisional, lossy, or uneven across lanes.

Deliverables:
1. Updated `OxReplay` docs.
2. If needed, one improved canonical local note for `DNA OneCalc` consumption of `OxReplay`.
3. A short final summary listing:
   - files changed,
   - the authoritative `OxReplay` doc set `DNA OneCalc` should now use,
   - remaining gaps that still belong in Foundation or sibling repos.

Verification:
1. Verify internal links and file references you touched.
2. Check that `docs\spec\README.md` matches the post-edit canonical set.
3. Check that the wording does not imply `DNA OneCalc` is the same host as `DNA ReCalc`.
4. Keep the repo’s authority model clean: canonical specs in `docs\spec`, status truth in worklist/blockers, no accidental promotion of historical material.
