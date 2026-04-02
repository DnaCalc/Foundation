# DNA OneCalc -> OxReplay Doc Improvement Prompt

`DNA OneCalc` is the single-node proving host and user-facing application for the `OxFml` + `OxFunc` + `OxReplay` stack. It is meant to behave like one isolated Excel calculation cell or defined-name context, with explicit host inputs, formatting and conditional-formatting scope, full replay visibility and control in the UI, and Windows-only twin-oracle comparison against Excel through `OxXlPlay`. It is not a worksheet engine and not `DNA ReCalc`, but it must consume `OxReplay` as shared replay infrastructure for capture, replay, diff, explain, witness handling, and scenario-library growth.

You are working inside the OxReplay repo.

Goal:
Improve the OxReplay documentation set so DNA OneCalc can use OxReplay cleanly as replay infrastructure, while preserving the rule that DNA ReCalc is the replay host and DNA OneCalc is a separate spreadsheet proving host. This is a docs-first pass. Do not change runtime code unless a tiny supporting doc-generation fix is unavoidable; if so, keep it minimal and explain why.

Read first:
1. `.\README.md`
2. `.\CHARTER.md`
3. `.\OPERATIONS.md`
4. `.\docs\spec\README.md`
5. `.\docs\IN_PROGRESS_FEATURE_WORKLIST.md`
6. `.\CURRENT_BLOCKERS.md`

Then read the Foundation consumer doc:
1. `..\Foundation\notes\DNA_ONECALC_SCOPE_AND_SPEC.md`

Focus especially on:
1. Section `3`
2. Section `5`
3. Section `6`
4. Section `10`
5. Section `12`
6. Section `19.4`
7. Section `19.8`

Task:
Review the OxReplay docs named there and improve them so the OneCalc team can understand exactly how DNA OneCalc should consume OxReplay for:
1. replay capture,
2. replay validation,
3. diff,
4. explain,
5. witness handling,
6. scenario-library growth,
7. Excel-observation comparison through OxXlPlay,
8. full replay visibility and control through the OneCalc UI,

without confusing that with:
1. DNA ReCalc's role,
2. lane-semantic ownership,
3. replay doctrine owned by Foundation.

Priority outcomes:
1. Make the OneCalc-facing consumption model explicit.
2. Keep the DNA ReCalc boundary explicit.
3. Clarify what a non-ReCalc host like DNA OneCalc may do directly with OxReplay runtime or library surfaces.
4. Clarify the minimum adapter and capability expectations OneCalc should assume today for OxFml, OxFunc, OxXlPlay, and later OxVba.
5. Clarify witness lifecycle, registry expectations, and what OneCalc should treat as stable versus still maturing.
6. If there is no good canonical local doc for DNA OneCalc-as-consumer, add one narrow canonical spec note under `docs\spec\` that defines that integration model.

Important constraints:
1. OxReplay must remain shared mechanics only, not a semantics lane.
2. Do not blur DNA ReCalc and DNA OneCalc.
3. Do not overclaim OxFunc or OxVba readiness if current capability or evidence does not justify it.
4. Preserve Foundation precedence for replay doctrine and lifecycle policy.
5. Be explicit where the current state is still baseline or provisional.

Recommended doc targets:
1. `docs\spec\README.md`
2. `docs\spec\OXREPLAY_SCOPE_AND_BOUNDARY.md`
3. `docs\spec\OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`
4. `docs\spec\OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md`
5. `docs\spec\DNA_RECALC_HOST.md`
6. `docs\spec\OXREPLAY_OXXLPLAY_OBSERVATION_SEAM.md`
7. `docs\IN_PROGRESS_FEATURE_WORKLIST.md`
8. `CURRENT_BLOCKERS.md`

Deliverables:
1. Updated OxReplay docs.
2. If needed, one new canonical narrow spec note for DNA OneCalc consumption of OxReplay.
3. A short final summary that lists:
   - files changed,
   - the authoritative OxReplay doc set DNA OneCalc should now use,
   - remaining gaps that still belong in Foundation or sibling repos.

Verification:
1. Verify internal links and file references you touched.
2. Check that `docs\spec\README.md` matches the post-edit canonical set.
3. Check that the new wording does not imply DNA OneCalc is the same host as DNA ReCalc.
