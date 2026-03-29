# DNA OneCalc Review Delta Assessment

This note evaluates the review suggestions in `inputs/reviews/` against the current Foundation OneCalc doctrine and the current upstream repo authority set.

## 1. Accepted Now
The following review directions were accepted into the canonical OneCalc note in this pass.

1. Translate "serious product" into concrete promises.
Result:
`DNA_ONECALC_SCOPE_AND_SPEC.md` now includes an explicit product-promise subsection covering keyboard-first editing, visible host profile and packet kind, visible provisionality, retained scenario authoring, first-class replay controls, and no silent overclaim.

2. Add explicit mode-gate discipline for the named workbench modes.
Result:
The note now requires each mode to declare dependencies, capability floor, platform scope, output artifacts, and labeling rules, and it includes a workbench mode gate matrix for `DNA-only`, `Excel-observed`, `Twin compare`, `Replay`, `Diff`, `Explain`, `Distill`, and `Handoff`.

3. Sharpen artifact identity and the `Scenario` / `Document` / `ScenarioRun` distinction.
Result:
The note now defines artifact identity classes, explicit authoring-versus-container-versus-run roles, and minimum field expectations for `Scenario`, `ScenarioRun`, `Observation`, `Comparison`, `Witness`, and `HandoffPacket`.

4. Normalize handoff action kinds.
Result:
The note now carries a first normalized `requested_action_kind` taxonomy instead of leaving handoff action semantics as free-form prose.

5. Freeze OneCalc-local packet taxonomy early.
Result:
The note now defines `ExplicitInputPacket`, `ReferenceProbePacket`, `StructuredReferenceProbePacket`, and `RegisteredExternalProbePacket` as OneCalc-local classification names, with narrow scope and explicit non-grid intent.

6. Distinguish formatting carriage from promoted parity claims.
Result:
The note now explicitly separates carried style state, evaluator-returned presentation hints, effective display, and promoted comparison truth. It also states that full format-string carriage and full conditional-formatting rule carriage are target directions while promoted execution/comparison claims widen in justified subsets.

7. Define first promoted formatting and conditional-formatting subsets.
Result:
The note now names a first promoted formatting subset and a first promoted conditional-formatting subset while keeping broader parity later and evidence-driven.

8. Add platform honesty and Leptos proving criteria.
Result:
The note now includes a platform matrix for Windows desktop, Linux desktop, and browser/WASM, plus explicit proving exit criteria for the first Leptos wave.

9. Separate host-local authoring state from upstream semantic truth.
Result:
The formula-editing section now explicitly distinguishes allowed host-local presentation state from parse/bind/diagnostic/help truths that remain upstream-owned.

10. Add comparison reliability labeling.
Result:
The note now includes a `direct` / `derived` / `lossy` / `provisional` comparison reliability badge rule.

11. Adopt a default `SpreadsheetML 2003` mapping decision.
Result:
The note now defaults to worksheet-per-instance inside a workbook container while preserving the explicit rule that this does not imply workbook graph semantics.

12. Split extension scope into three surfaces.
Result:
The note now distinguishes the OneCalc native extension ABI, the OxFml/OxFunc registered-external semantic seam, and the later OxVba toolchain lane.

13. Add a bootstrap control set.
Result:
The note now names the initial local control documents or equivalent artifacts expected at repo bootstrap, including seam manifest, host profile matrix, packet kind register, replay floor policy, display-and-format model, scenario schema, handoff schema, and provisionality badge policy.

14. Classify open questions by freeze urgency.
Result:
The note now distinguishes items that must freeze before bootstrap, items that may remain provisional at bootstrap, and items that are safe to defer until after the first real host slice.

## 2. Accepted In Spirit But Kept As Future Repo Deliverables
The following review directions were accepted as valid, but were not expanded into separate Foundation-owned documents in this pass.

1. `HOST_CAPABILITY_MATRIX.md`
Interpretation:
This is now represented as required repo bootstrap output through `HOST_PROFILE_MATRIX` and the workbench mode gate matrix in the canonical note.

2. `SEAM_MANIFEST.md`
Interpretation:
This is now part of the required bootstrap control set and `W1.2`, but Foundation did not create a separate file because the task here was to refine the OneCalc spec rather than pre-bootstrap the downstream repo.

3. `DISPLAY_AND_FORMAT_MODEL.md`, `FORMATTING_SUBSET_REGISTER.md`, `REPLAY_FLOOR_POLICY.md`, `PROVISIONALITY_BADGE_POLICY`, and related repo-local artifacts
Interpretation:
These are now expected outputs in the canonical note. They remain downstream repo deliverables rather than additional Foundation notes.

## 3. Intentionally Deferred Or Kept Provisional
The following review directions were not promoted to Foundation-level certainty because current upstream authority does not justify them yet.

1. Inventing a final OxFml immutable shared editor packet.
Reason:
That belongs in OxFml and must not be silently frozen in Foundation.

2. Inventing a final OxFunc help/signature payload contract.
Reason:
The canonical owner remains OxFunc, with OxFml projecting the payload into host-facing editor packets.

3. Inventing a final non-`DNA ReCalc` app-facing OxReplay service freeze.
Reason:
The note now references the real `OxReplay` OneCalc consumption model and uses it, but it does not claim a more frozen contract than the upstream repo currently owns.

4. Treating current `OxXlObs` lossy projection as broad semantic equivalence truth.
Reason:
That would violate the retained evidence and capability honesty rules.

5. Claiming broad conditional-formatting or replay distillation maturity now.
Reason:
The current upstream floors remain narrower than that.

## 4. Net Assessment
The review materially improved the OneCalc note. The strongest gains came from:
1. converting abstract direction into enforceable host promises and gate rules,
2. making artifacts, packet kinds, and provisionality far more explicit,
3. tightening the boundary between carried product ambition and promoted claim scope,
4. preventing silent drift toward either a hidden mini-worksheet engine or an overclaimed replay/comparison story.

No blocking doctrinal conflict was found between the accepted review changes and current Foundation authority. The remaining important gaps still belong in the upstream repos and should continue to be addressed there through the clarified downstream pressure model.
