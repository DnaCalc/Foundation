# Applied DNA OneCalc Spec Refinement Summary

This note records the concrete changes applied to the canonical OneCalc spec from this integration pass.

Updated canonical target:
- [DNA_ONECALC_SCOPE_AND_SPEC.md](/C:/Work/DnaCalc/Foundation/notes/DNA_ONECALC_SCOPE_AND_SPEC.md)

## 1. Core Refinements
1. Added explicit product promises and mode-gate discipline so `Twin Oracle Workbench` and `Live Formula Semantic X-Ray` now translate into concrete host obligations.
2. Expanded the artifact spine with identity classes, minimum artifact-field expectations, and an explicit `requested_action_kind` taxonomy for `HandoffPacket`.
3. Added a OneCalc-local packet taxonomy to keep `OC-H1` explicit-input and non-grid while still allowing bounded reference-bearing probes where upstream seam reality requires them.
4. Reworked formatting and conditional-formatting scope so carried style state, effective display, returned presentation hints, and promoted comparison claims are explicitly separated.
5. Added a platform honesty matrix, Leptos proving criteria, and a sharper formula-edit integration boundary between host-local UI state and upstream semantic truth.
6. Added a workbench mode gate matrix and comparison reliability badge policy for replay and Excel-comparison surfaces.
7. Adopted worksheet-per-instance as the default `SpreadsheetML 2003` persistence mapping.
8. Split the extension lane into OneCalc native ABI, OxFml/OxFunc registered-external semantics, and later OxVba tooling.
9. Added the bootstrap control set and tightened the work breakdown around those expected deliverables.
10. Reclassified open questions into freeze-before-bootstrap, provisional-at-bootstrap, and safe-to-defer groups.

## 2. Upstream Reference Integration
The pass also tightened the live use of upstream material rather than treating the review as purely local commentary.

1. `OxCalc` seam-reference material remains explicitly tied to the OneCalc host boundary through the existing seam-reference sections.
2. `OxReplay`'s OneCalc-facing consumption note is now explicitly named in the replay and scenario-growth reference slice, not just in the appendix.
3. The broader authoritative appendix remains the live integration filter for `OxFml`, `OxFunc`, `OxReplay`, `OxXlObs`, `OxCalc`, and `OxVba`.

## 3. What This Pass Did Not Do
1. It did not create new downstream repo-local control documents such as `SEAM_MANIFEST` or `REPLAY_FLOOR_POLICY`; it only made them required bootstrap artifacts in the spec.
2. It did not freeze upstream-owned contracts that still belong in `OxFml`, `OxFunc`, `OxReplay`, `OxXlObs`, or `OxVba`.
3. It did not widen current honest claims about replay distillation, broad Excel parity, or broad conditional-formatting parity beyond what retained evidence justifies.

## 4. Remaining Good Follow-On Work
The strongest next follow-on work after this pass is:
1. bootstrap the actual `DnaOneCalc` repo with the named control documents,
2. run prompt-based clarification passes in `OxFml`, `OxFunc`, `OxXlObs`, and `OxVba` using the now-sharper downstream asks,
3. keep the Foundation OneCalc note monolithic and current while those upstream clarifications land.
