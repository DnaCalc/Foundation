# Excel Render Context Capture Spec And Rollout

## 1. Purpose

This note defines the long-term correct path for locale-sensitive worksheet text comparison in the formula-corpus pipeline.

Historical problem that motivated this rollout:
- `OxFml` locale-sensitive text semantics could match Excel on the host path for cases such as `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040`.
- `DnaOneCalc` previously blocked those cases because the Excel-side render locale/separator state was not captured strongly enough to make the text surface comparison-eligible.
- A short-term equality-based host-policy relaxation was possible, but it was not the preferred long-term answer.

Current status:
- that host comparison-eligibility gap is now closed by the render-context capture rollout,
- and the follow-on separator-aware execution seam for `FTC-0288` is also now closed on the normal host path.

Long-term answer:
- capture effective Excel render context as a first-class retained artifact,
- preserve it through replay artifacts,
- and make host comparison eligibility depend on that captured context rather than on a blunt unpinned-render heuristic.

This note intentionally does **not** broaden what context matters for comparison. It only specifies how to capture, reference, retain, and consume that context honestly and efficiently.

## 2. Scope And Non-Goals

### 2.1 In scope
- locale-sensitive worksheet text surfaces whose values depend on effective Excel render context,
- retained-capture contract for Excel-side render context,
- replay-friendly packaging and provenance rules,
- one-hop indirection so many test cases can share one captured context object,
- host eligibility rules based on captured context presence/trust.

### 2.2 Not in scope
- changing `OxFml` formula semantics,
- changing the set of values considered locale-sensitive,
- weakening `OxReplay` or host provenance/reliability rules,
- multi-hop context inheritance chains,
- replacing final spreadsheet-host verdict policy with `OxReplay`.

## 3. Architectural Position

This proposal follows existing Foundation doctrine:
- `OxReplay` owns normalized comparison/equivalence over declared replay-comparable surfaces.
- spreadsheet hosts such as `DnaOneCalc` still own final `Matched` / `Mismatched` / `Blocked` verdict policy,
- but that policy should be driven by stronger evidence once render context becomes a captured surface instead of a missing one.

The intended effect is:
- today: locale-sensitive text + missing Excel render context => `Blocked`,
- after rollout: locale-sensitive text + captured trusted Excel render context => comparison-eligible,
- after rollout: locale-sensitive text + missing or untrusted Excel render context => still `Blocked`.

## 4. Render Context Object

Introduce a first-class retained artifact family:
- `ExcelRenderContextCapture`

The object represents the **effective** Excel-side render context used to produce locale-sensitive text during observation.

### 4.1 Minimum required fields

Required baseline fields:
- `render_context_id`
- `capture_scope`
- `capture_source`
- `capture_status`
- `locale_profile_id` when available
- `decimal_separator`
- `thousands_separator`
- `date_separator`
- `time_separator`
- `currency_symbol` when available
- `date_system` when available
- `uses_system_separators` when observable
- `source_lane_id`
- `source_artifact_ref`

Recommended provenance fields:
- `excel_application_identity`
- `observation_machine_identity` or stable machine/session ref when policy allows
- `workbook_identity` or scenario identity when relevant
- `captured_at`
- `notes`

### 4.2 Capture-status vocabulary

The capture object should distinguish at least:
- `captured_effective` — direct effective render context was captured from the active observation environment and is trusted for comparison policy,
- `captured_partial` — some fields captured, but comparison-critical fields missing,
- `declared_default` — a default/profile-level declaration exists but effective runtime confirmation is absent,
- `unavailable` — required render context could not be captured,
- `lossy` — a normalization/projection exists but cannot claim full fidelity.

Host policy should not treat these statuses equally.

## 5. Packaging And Indirection Contract

### 5.1 Design rule

Render context may be supplied either:
- inline on the case/scenario/observation surface, or
- by exactly one level of reference to a separately captured context object.

This packaging flexibility must not change comparison semantics.

### 5.2 One-hop indirection

Allowed:
- `case -> render_context_ref -> ExcelRenderContextCapture`

Not allowed:
- `case -> ref -> ref -> ref`
- implicit unbounded inheritance chains
- external unresolved pointers with no retained target object

### 5.3 Preferred retained layout for batch runs

Preferred layout:
- run/bundle-level `render_contexts` table
- per-case `render_context_ref`

This avoids repeating identical context blobs for many tests captured under the same Excel environment.

Example shape:

```json
{
  "run_id": "run-001",
  "render_contexts": [
    {
      "render_context_id": "ctx-001",
      "capture_scope": "run",
      "capture_status": "captured_effective",
      "locale_profile_id": "en-US",
      "decimal_separator": ".",
      "thousands_separator": ",",
      "date_separator": "/",
      "time_separator": ":",
      "currency_symbol": "$",
      "date_system": "1900",
      "uses_system_separators": true
    }
  ],
  "cases": [
    {
      "case_id": "FTC-1028",
      "comparison_value": { "kind": "text", "value": "July" },
      "render_context_ref": "ctx-001"
    }
  ]
}
```

### 5.4 Optional run default

To reduce repetition further, the contract may allow:
- `default_render_context_ref` at run/scenario scope,
- with explicit case-level override.

If adopted, resolution must still remain one hop:
- case override if present,
- else run/scenario default,
- then direct object resolution.

This is an optimization only. It must not create semantic ambiguity.

## 6. Comparison Eligibility Rule

### 6.1 Before this rollout

Current host rule is effectively:
- locale-sensitive semantic text under explicit locale context,
- but Excel render locale/separator state unpinned,
- therefore `comparison_value` is not comparison-eligible.

### 6.2 After this rollout

For locale-sensitive text surfaces:

1. Resolve effective Excel render context for the case.
2. Determine whether the render-context capture is present and trusted enough for comparison.
3. If trusted, the value surface is comparison-eligible.
4. If missing, lossy, partial, or unavailable in a comparison-critical way, keep `Blocked`.

### 6.3 Important rule

Do **not** use one observed equal-text result as a substitute for captured context.

Equality may still be used as an interim local host heuristic if explicitly chosen, but it is not the long-term artifact contract.

## 7. Ownership Split

### 7.1 Foundation
Foundation owns:
- the capture contract,
- required field set,
- status vocabulary,
- one-hop indirection rule,
- rollout policy,
- cross-repo acceptance criteria.

### 7.2 OxXlPlay
`OxXlPlay` owns:
- collecting effective Excel-side render context,
- publishing `ExcelRenderContextCapture` artifacts or equivalent lane-native objects that adapt into that family,
- documenting any unavailable fields or lossy capture conditions.

### 7.3 DnaOneCalc
`DnaOneCalc` owns:
- assembling compare-ready artifacts that resolve case-to-context linkage,
- host policy for when a resolved context is sufficient to move from `Blocked` to comparison-eligible,
- preserving blocked status when context remains unavailable/untrusted.

### 7.4 OxReplay
`OxReplay` owns:
- preserving render-context artifacts and refs in normalized replay artifacts,
- exposing provenance/reliability context alongside comparison surfaces,
- diff/explain support when render-context capture differs, is missing, or is insufficient.

`OxReplay` does not own final spreadsheet-host verdict policy.

## 8. Proposed Artifact Contract

### 8.1 Case/scenario-facing fields

For any case whose comparison surface depends on render context:
- `render_context_required: true`
- exactly one of:
  - `render_context`
  - `render_context_ref`
- optional `render_context_resolution_status`

### 8.2 Bundle/run-facing fields

At bundle/run scope:
- `render_contexts: []`
- optional `default_render_context_ref`

### 8.3 Provenance requirements

Every retained render-context object must preserve:
- source lane id,
- source schema version where relevant,
- source artifact identity,
- capture mode,
- lossless/lossy status,
- capture limitations when present.

This follows existing replay appliance source-preservation rules.

### 8.4 Evidence-management and linkage rule

The pipeline must distinguish these states explicitly; they are not interchangeable:
- `no_capture_artifact_present`
- `capture_artifact_present_but_unresolved`
- `capture_artifact_resolved_but_untrusted`
- `capture_artifact_resolved_and_trusted`

Required rule:
- if an upstream retained render-context artifact exists, downstream hosts must not silently collapse that state back into a generic fallback note without also preserving that the artifact was present but not consumed.

Minimum downstream retained evidence for a locale-sensitive case should therefore include:
- whether a render-context artifact was discovered,
- which artifact path/ref was selected,
- whether resolution succeeded,
- whether the resolved context was trusted for comparison,
- fallback reason if the host still declined to trust or consume it.

This is necessary so coordinator and replay artifacts can distinguish:
- missing capture,
- capture-side success with host-side consumption failure,
- and genuinely trusted end-to-end comparison.

## 9. Explain And Diff Expectations

Once rolled out, replay/explain surfaces should make these questions answerable:
- was this locale-sensitive text compared under a trusted captured render context,
- which exact render-context object was used,
- did left and right runs use equivalent render context,
- was the case blocked because context was missing/untrusted,
- did text diverge even though context was captured and equivalent.

This is the durable long-term answer for the current locale-sensitive text family.

## 10. Rollout Plan

Sequence only; no calendar commitments.

### Stage A — Foundation contract note and acceptance criteria
Owner: `Foundation`

Deliverables:
- this spec note as the working contract draft,
- explicit required field set,
- one-hop indirection rule,
- acceptance criteria for capture sufficiency.

Acceptance criteria:
- no semantic broadening beyond current locale-sensitive comparison scope,
- explicit inline-vs-ref support,
- no multi-hop indirection.

### Stage B — OxXlPlay capture surface
Owner: `OxXlPlay`

Deliverables:
- Excel-side capture of effective render context,
- retained artifact(s) for one or more shared context objects per run,
- explicit reporting of unavailable/partial/lossy fields.

Acceptance criteria:
- at least one exercised retained run where multiple locale-sensitive text cases share one captured render context object,
- capture artifacts clearly distinguish effective capture from notes/assumptions.

### Stage C — DnaOneCalc compare-ready assembly
Owner: `DnaOneCalc`

Deliverables:
- resolve case-to-render-context linkage from retained artifacts,
- replace current blunt unpinned-render heuristic for these cases with context-resolution-based eligibility,
- keep `Blocked` when required context is still unavailable/untrusted.

Acceptance criteria:
- cases like `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` become comparison-eligible only when resolved context is present and trusted,
- `FTC-0288` remains honest under the same stronger contract,
- no blanket auto-greening of locale-sensitive text with missing context.

### Stage D — OxReplay preservation and explain
Owner: `OxReplay`

Deliverables:
- normalized support for render-context objects and refs,
- diff/explain visibility for missing, divergent, or untrusted render-context capture,
- provenance/reliability retained through replay artifacts.

Acceptance criteria:
- replay artifacts can show whether a locale-sensitive text match was made under trusted captured context or not,
- missing context remains explainable rather than collapsing into opaque host-only text.

### Stage E — Formula corpus validation reruns
Owner: coordinated from `Foundation`

Target validation family:
- `FTC-0288`
- `FTC-1021`
- `FTC-1023`
- `FTC-1024`
- `FTC-1028`
- `FTC-1040`

Acceptance criteria:
- the equal-text blocked subset can move to honest comparison-eligible outcomes once the render context is actually captured and consumed,
- unequal-text cases remain honest under the same contract,
- retained artifacts now explain *why* a case is comparable or still blocked,
- if capture-side artifacts exist but the host still falls back, retained artifacts must surface that as an evidence-management/consumption gap rather than flattening it into generic `observation_machine_default` fallback language.

### Stage E.1 — Host-consumption seam result

That concrete gap is now closed:
- `OxXlPlay` emits `cases/<ID>/oxxlplay/render-context.json`,
- and `DnaOneCalc` commit `e5f8ac3` now consumes that retained artifact into effective host render-context resolution instead of silently falling back.

Cross-repo rerun result at `target/triage/ftc-0288-1021-1023-1024-1028-1040-after-render-context-consumption/cases/`:
- `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` moved from policy-`Blocked` to `Matched`,
- `FTC-0288` remained red, but no longer as a missing-context case.

### Stage E.2 — New surviving finding after capture consumption

Once trusted render context was actually consumed end-to-end, the surviving `FTC-0288` evidence showed a deeper truth:
- the remaining disagreement was separator-context-sensitive formatting semantics,
- not merely comparison eligibility.

Retained evidence showed:
- under the host's default separator state, Excel observed `=TEXT(1234567.89,"#,##0.00") -> "1234,567.89"`,
- but when Excel is forced to `UseSystemSeparators = false`, `DecimalSeparator = "."`, `ThousandsSeparator = ","`, the same formula renders `"1,234,567.89"`.

Implication for rollout governance:
- render-context capture remained correct and necessary,
- but some locale/render-context facts are also semantically relevant to evaluation for format-sensitive formulas,
- so trusted captured separator state had to flow into evaluation semantics, not only host comparison eligibility.

### Stage E.3 — Separator-aware execution seam result

That follow-on gap is now also closed on the normal host path.

The final missing step was:
- `OxFml` commit `a1deee2` made the active `FTC-0288` anchor separator-aware locally,
- but `DnaOneCalc` initially reran OxFml with a `LocaleFormatContext.profile` still built from default `format_profile(profile_id)` separator fields,
- so trusted captured separator state was retained but not yet semantically effective.

DnaOneCalc commit `3110e1c` closed that host-side delivery gap by:
- overriding the concrete separator fields in the rerun `LocaleFormatContext.profile` from trusted captured render context,
- then feeding that profile through `TypedContextQueryBundle` during the post-capture trusted-context rerun.

Cross-repo proving rerun result at `target/triage/ftc-0288-1021-1023-1024-1028-1040-after-separator-aware-rerun/cases/`:
- `FTC-0288`, `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` are all `Matched`.

Retained `FTC-0288` proof now shows:
- `case-input.json` / `scenario.json` preserve trusted capture provenance `oxxlplay_capture_artifact`,
- `oxfml-execution-context.json` records `execution_phase = "post_capture_trusted_refresh"`,
- the locale query-bundle profile now carries captured separators,
- `oxfml-runtime-summary.json` and `oxfml-v1-replay-projection.json` both moved to `1234,567.89`,
- and `commands/oxreplay-diff.json` is equivalent.

## 11. Immediate Coordinator Guidance

Now that the rollout proving family has been exercised end-to-end:
- treat the capture-contract lane as proven for host comparison eligibility on the equal-text subset,
- treat the separator-aware rerun lane as proven for the active `FTC-0288` anchor,
- keep `FTC-0288` as the family anchor for future separator-sensitive widening rather than as an open blocked case,
- do not regress back to generic fallback language when captured artifacts exist,
- use the dedicated parked separator note at `monitoring/EXCEL_SEPARATOR_FORMATTING_THEORY_NOTE.md` for current family understanding and implementation state,
- and only reopen the separator lane when a fresh retained red or strategically important new witness justifies it.

## 12. Resulting Rule

The long-term correct solution for locale-sensitive worksheet text comparison is:
- capture effective Excel render context as a first-class retained artifact,
- allow either inline storage or one-hop reference to a shared context object,
- make host comparison eligibility depend on that captured context,
- and preserve provenance/reliability through the replay pipeline without widening semantic scope.
