# DNA OneCalc Clarification Worklist

Status: active working note
Purpose: track the decision sequence needed to close design holes in `DNA_ONECALC_SCOPE_AND_SPEC.md` without adding more provisionality to the canonical spec before decisions are made.

Working rule:
1. Each item is resolved interactively.
2. Once a decision is accepted, the answer should be folded back into `notes/DNA_ONECALC_SCOPE_AND_SPEC.md`.
3. This file is a closure queue, not a second source of truth.

## Decision Queue

### Q01. Exact `OC-H0` Packet Freeze
Status: resolved
Question:
What is the exact frozen `OC-H0` host packet, field by field, and which formula families force each optional field?
Why it matters:
This is the narrowest executable host contract. If this is vague, every later boundary drifts.
Decision:
1. Freeze `OC-H0` as the upstream-aligned semantic minimum rather than an ultra-minimal placeholder or an H1-shaped future-proof packet.
2. Mandatory H0 fields are:
   - `FormulaSourceRecord`
   - `formula_channel_kind`
   - `structure_context_version`
   - `LibraryContextProvider`
   - immutable `LibraryContextSnapshot`
   - `LocaleFormatContext`
3. Optional H0 fields are admitted only when the active semantic lane requires them:
   - `now_serial` for volatile time/date families
   - `random_value` for `RAND` / `RANDBETWEEN`
4. H0 remains out of scope for:
   - `defined_name_bindings`
   - caller-anchor or direct cell bindings
   - `HostInfoProvider`
   - `RtdProvider`
   - registered-external providers
   - workbook state or generic grid state
5. Runtime recalc behavior should model a single Excel cell:
   - edit-and-accept triggers recalculation, even when the accepted formula text is unchanged,
   - manual recalc key should behave like Excel-style volatile recalc when volatile or push-driven inputs are present,
   - a separate forced-recalc path should be available for unconditional rerun,
   - `RTD` support is part of the intended host-awareness model, with recalculation triggered by push updates when admitted later through the proper host packet.
Note:
The earlier “trigger rule” wording referred to when optional H0 fields such as `now_serial` and `random_value` must be included, not to runtime recalc timing. The runtime recalc decision is now also captured here because it materially constrains later host-packet and UI design.

### Q02. Exact `OC-H1` Packet Freeze
Status: resolved
Question:
What is the exact frozen `OC-H1` packet, field by field, and are `defined_name_bindings` really the public input mechanism we want?
Why it matters:
This is the first real host model and the main risk of accidental drift toward `OxCalc`.
Decision:
1. Do not make `OC-H1` an explicit-input host for the initial `DNA OneCalc` project slice.
2. Do not exercise `defined_name_bindings`, name-binding, or reference-binding aspects of the OxFml seam in OneCalc at this stage.
3. Do not admit the `HostInfoProvider` / host-query world in the first widened host slice.
4. The first widened host step after `OC-H0` should instead favor out-of-band and push-style driving mechanisms for repeated runs and scenario families.
5. The preferred initial driving model is:
   - formula edit and accept,
   - manual recalculation,
   - forced recalculation,
   - scriptable or host-driven formula replacement,
   - `RTD`-backed push input where admitted,
   - later extension-backed push or provider functions where needed.
6. `LET(...)` should be treated as the primary in-formula factoring mechanism for splitting value setup from calculation logic inside a single formula.
7. If OneCalc later needs value-entry-like behavior for demonstrations or scenario driving, prefer:
   - `RTD`,
   - add-in functions,
   - other explicitly external provider mechanisms,
   rather than partial defined-name or reference binding.
8. This project does not exercise the dereference seam between `OxCalc` and `OxFml`; that seam remains reference material only for a later project.
Implication:
The current label `OC-H1: Explicit-Input Host` is no longer correct.
Chosen replacement:
`OC-H1: Driven Single-Formula Host`

### Q03. Probe-Packet Admission
Status: resolved
Question:
Which probe-only fields are actually admitted in `ReferenceProbePacket`, `StructuredReferenceProbePacket`, and `RegisteredExternalProbePacket` for the first product slice?
Why it matters:
This decides whether OneCalc stays narrow or quietly becomes a worksheet environment.
Decision:
1. `DNA OneCalc` does not admit `ReferenceProbePacket`.
2. `DNA OneCalc` does not admit `StructuredReferenceProbePacket`.
3. `DNA OneCalc` does not admit worksheet `REGISTER.ID` / `CALL` semantics as part of its current scope.
4. `DNA OneCalc` does admit host-loaded extension registration as a separate lane.
5. The add-in path is:
   - the host loads an `.xll` add-in,
   - the add-in calls into `DNA OneCalc`,
   - `DNA OneCalc` registers the exposed user-defined functions into the active function catalog,
   - formulas may then call those functions by name.
6. This is not the same as admitting the broader registered-external worksheet seam.
7. The first admitted external-extension surface should therefore be modeled as a narrower host-managed registration packet family rather than by adopting the broader `RegisteredExternalProbePacket` as-is.
Scope rule:
Use current-scope wording only. Do not describe excluded seams as part of a planned staged support ladder unless and until the canonical spec is intentionally widened.

### Q04. Upstream Packet-Name And Field-Name Mirroring
Status: resolved
Question:
Which packet names and field names are we committing to mirror directly from upstream `OxFml`, and which remain OneCalc-local classification names only?
Why it matters:
Otherwise the host taxonomy and seam taxonomy will drift.
Decision:
1. From the `DNA OneCalc` perspective, `OxFml` is the normative seam authority and `OxCalc` is informative seam-reference material.
2. `DNA OneCalc` is a consumer of the `OxFml` library and should accept the seam contract from `OxFml`.
3. `OxCalc` should still be consulted as informative reference material because the practical seam is shared and its docs may clarify intent or current exercised shapes.
4. When `OxFml` and `OxCalc` disagree, `DNA OneCalc` should follow `OxFml` and may note the discrepancy for cross-repo cleanup.
5. Where the same seam concept is documented under different names, a name-resolution and unification pass is desirable, but `DNA OneCalc` should not fork its own third competing seam vocabulary.
6. Use OneCalc-local terminology for product-level concepts, UI concepts, and workbench concepts.
7. Use OxFml field names and packet names at the actual consumed seam.
8. Remove or retire local packet names that no longer correspond to the consumed seam or to the chosen OneCalc scope.

### Q05. Returned-Value Surface Freeze
Status: resolved
Question:
Which returned-value classes are in the first implementation slice: ordinary value, value-with-presentation, typed provider outcome, rich value?
Why it matters:
This controls rendering, persistence, replay, and comparison together.
Decision:
1. Freeze the first-class returned-value surface to four classes:
   - `OrdinaryValue`
   - `ValueWithPresentation`
   - `TypedProviderOutcome`
   - `BoundedRichValue`
2. `BoundedRichValue` means evaluator-surfaced rich consequences that `DNA OneCalc` can render, persist, replay, and compare honestly under the current scope.
3. This includes cases such as:
   - hyperlink publication intent,
   - image display intent,
   - callable-value identity where surfaced for display.
4. This does not define or require a general arbitrary object-value or universal rich-value runtime.
5. The returned-value model should remain aligned to the current OxFml seam taxonomy rather than inventing a competing local result universe.

### Q06. Effective-Display Composition Rule
Status: resolved
Question:
What are the first concrete rules for composing evaluator-returned presentation hints with host style state?
Why it matters:
Without this, formatting mismatches will be hard to explain and harder to test.
Decision:
1. Excel behavior is normative for effective-display composition.
2. `DNA OneCalc` should use the current seam reading as the working implementation model:
   - evaluator-returned presentation or publication hints,
   - composed with persisted host style state,
   - then conditional-formatting consequences,
   - yielding computed effective-display state.
3. That ordering is a working model, not a self-justifying local rule.
4. Promoted composition rules and parity claims must be empirically verified against Excel through the available observation path.
5. If retained Excel evidence contradicts the current local composition reading, the spec and implementation should be corrected to match the verified Excel behavior.
6. The separate planes must remain inspectable even when the main rendered display uses the composed effective-display result.

### Q07. First Conditional-Formatting Subset
Status: resolved
Question:
What exact conditional-formatting rule families and consequence actions are admitted in wave one?
Why it matters:
“Full conditional formatting” is too broad without a rule-family register.
Decision:
1. `DNA OneCalc` should broaden the admitted conditional-formatting scope beyond the narrowest first subset, but it must not describe that scope as the complete Excel conditional-formatting feature set.
2. The promoted conditional-formatting rule families are:
   - formula-expression rules,
   - scalar comparisons including `between`,
   - blank / nonblank,
   - error / non-error,
   - text predicates including contains, begins with, and ends with.
3. The promoted consequence actions are:
   - fill color,
   - font color,
   - bold / italic / underline,
   - simple border changes,
   - number-format override,
   - icon-set outcomes where the threshold model and icon family are explicit and local to the isolated instance.
4. Broader visual conditional-formatting families may be carried and rendered where the host can do so honestly, including:
   - richer icon-set families,
   - data bars,
   - two-color and three-color scales.
5. Those broader visual families should not be treated as promoted Excel-parity claims unless and until empirical evidence supports the exact claim being made.
6. The current spec still excludes:
   - workbook-global ranking semantics,
   - multi-range priority or stop-if-true graph claims,
   - table-aware or structured-reference conditional-format semantics,
   - semantics that depend on a broader worksheet environment than `DNA OneCalc` owns.

### Q08. Canonical Internal Artifact Schemas
Status: resolved
Question:
What are the frozen field-level schemas for `Scenario`, `ScenarioRun`, `Observation`, `Comparison`, `Witness`, `HandoffPacket`, and `Document`?
Why it matters:
The current note has schema minimums, but not yet final engineering contracts.
Decision:
1. Freeze the shared artifact envelope and the exact top-level block layout for every canonical artifact now.
2. Fully freeze the inner fields for the operationally critical blocks that drive execution, replay, comparison, persistence, and handoff.
3. Keep large payloads and heavy sidecars referenced by stable attachment refs rather than forcing everything to be embedded.
4. Apply the freeze as follows:
   - `Scenario`: freeze identity, formula source, host profile, host-driving block, library-context ref, display-context block, extension-state block, notes or intent, and seam pins.
   - `ScenarioRun`: freeze identity, scenario ref, environment, execution-input snapshot, result-summary block, replay refs, capability or provisionality block, and timing summary.
   - `Observation`: freeze identity, source-system block, provenance, capture envelope, observed-surface table, capture-loss and uncertainty table, and replay-view refs.
   - `Comparison`: freeze left/right refs, comparison envelope, typed mismatch table, reliability block, explanation refs, and witness-candidate refs.
   - `Witness`: freeze source comparison ref, predicate block, retained mismatch core, reduction state, lifecycle or quarantine state, and pack-eligibility flags.
   - `HandoffPacket`: freeze target-lane block, requested-action block, supporting-artifact refs, assumption and warning block, readiness checklist, and export metadata.
   - `Document`: freeze identity, document metadata, instance manifest, retained-artifact index, attachment index, UI view-state block, and persistence-format metadata.
5. The schema freeze should also remove stale explicit-input assumptions and replace them with the current driven-host model where required.
6. No artifact may rely on UI-local state for identity, lineage, or referential integrity.

### Q09. Embedded vs External Artifact Storage
Status: resolved
Question:
Which artifacts are embedded in `Document` and which are attached externally?
Why it matters:
This affects persistence, portability, duplication, and evidence hygiene.
Decision:
1. Keep the `Document` compact and embed only authored or current-instance truth plus small summaries and indexes.
2. Keep large, replay-heavy, retained, or externally sourced evidence as attached artifacts referenced by stable ids.
3. The `Document` should embed:
   - document metadata,
   - instance manifest,
   - authored `Scenario` records,
   - current display/style/conditional-format carrier state for each instance,
   - attachment index,
   - retained-artifact index,
   - compact summaries for linked `ScenarioRun`, `Comparison`, `Witness`, and `HandoffPacket`,
   - UI view-state.
4. The `Document` should attach externally by stable ref:
   - full replay bundles,
   - full trace sidecars,
   - normalized replay views,
   - Excel observation bundles and provenance sidecars,
   - screenshots and extracted images,
   - large comparison diff tables,
   - witness-reduction sidecars,
   - exported handoff payloads,
   - large extension or load-diagnostic artifacts.
5. The `Document` is the portable authored and workbench container; the retained evidence corpus remains a linked artifact set.
6. Duplication or forking of a document must preserve logical artifact identity and update attachment bookkeeping without rewriting stable artifact ids.

### Q10. Exact `SpreadsheetML 2003` Mapping
Status: resolved
Question:
What is the exact worksheet-per-instance mapping, including where lineage, host metadata, and retained artifact refs live?
Why it matters:
Persistence is still OneCalc-owned and needs a sharper engineering decision.
Decision:
1. `SpreadsheetML 2003` is the first Excel-readable persistence envelope for `DNA OneCalc`.
2. The Excel-compatible subset is important, but it is not required to be the complete long-term OneCalc persistence story.
3. XML extension lanes may be used where that is safe and where Excel will harmlessly ignore them.
4. One XML file means one isolated `DNA OneCalc` instance.
5. The top-level host UI may manage multiple isolated instances by opening a directory or workspace of OneCalc files.
6. The current persistence spec does not require or imply multiple OneCalc instances inside a single XML file.
7. No saved container or workspace grouping may imply workbook-graph semantics, cross-instance recalc, or reference-sharing semantics.
8. If `SpreadsheetML 2003` proves too limited, widening or adding another persistence format requires an explicit later spec change rather than being implied by the current scope.

### Q11. Concrete Repo-Internal Module Layout
Status: resolved
Question:
What app-core package and module structure do we actually want in the repo?
Why it matters:
The note now defines strata and services, but not the concrete repo layout.
Decision:
1. Use a medium-grained workspace layout rather than a single large app package or a highly fragmented microcrate layout.
2. The repo should be structured around separate host entrypoints plus shared core packages aligned to the real architectural strata.
3. The preferred layout is:
   - `apps/desktop-tauri` for the Windows/Linux desktop host shell, menus, filesystem entry points, and native extension loading,
   - `apps/web` for the browser/WASM host shell,
   - `crates/app_core` for workbench orchestration, commands, mode switching, and artifact lifecycle,
   - `crates/editor` for formula-buffer integration, diagnostics, completion, and signature/help bridging,
   - `crates/execution` for host-packet construction, OxFml/OxFunc driving, and result-surface normalization,
   - `crates/replay_compare` for OxReplay/OxXlObs integration and comparison flows,
   - `crates/persistence` for `Document` mapping, `SpreadsheetML 2003`, and attachment bookkeeping,
   - `crates/extensions` for native extension ABI, discovery, enablement, and registration bridging,
   - `crates/evidence_store` for retained artifacts, indexes, attachments, and local evidence caching,
   - `tests/` for integration and end-to-end seam tests.
4. Desktop and browser hosts remain separate host shells over a shared core and must not be collapsed into one host identity.
5. The repo layout should preserve real boundaries for replay, persistence, and extensions rather than burying them inside one generic application crate.

### Q12. Persistent vs Ephemeral UI State Boundary
Status: resolved
Question:
What is the exact boundary between persistent artifact-bearing state and ephemeral workbench UI state?
Why it matters:
Rich clients rot quickly if persistence and live UI state are mixed carelessly.
Decision:
1. Persist only artifact-bearing state and explicitly user-meaningful workspace state.
2. Keep transient interaction state session-local.
3. Persist:
   - current `Document` identity and instance selection,
   - open scenario or instance refs,
   - panel layout and major view mode,
   - saved filters and saved library views,
   - attached observation refs,
   - selected comparison envelope when explicitly saved with the document,
   - retained artifact index and attachment index,
   - extension enabled or disabled set where that state is intended to be durable.
4. Do not persist:
   - cursor and selection,
   - completion popup state,
   - signature-help popup state,
   - transient diagnostics-panel expansion,
   - current run in-flight state,
   - replay command in progress,
   - temporary diff filters unless explicitly saved as a named view,
   - transient notifications and warnings.
5. Governing rule:
   - persist what is needed for artifact identity, reproducibility, or intentional workspace reopening,
   - do not persist transient interaction state merely because it is visible in the current session.

### Q13. Context Bar And Always-Visible Truth Contract
Status: resolved
Question:
What exact fields and badges must always be visible in the workbench and compare headers?
Why it matters:
The design pack is strong, but the visible truth contract is not yet frozen.
Decision:
1. Use a compact always-visible truth strip plus mode-specific visible expansions.
2. The invariant always-visible core should include:
   - current host profile,
   - current mode,
   - source type (`DNA`, `Excel retained`, `Excel live`),
   - run state (`dirty`, `ready`, `ran`, `compared`),
   - platform gate where relevant (`Windows-only`, `desktop only`, `browser limited`),
   - extension state where relevant (`enabled`, `declared but unavailable`, `not in this host`).
3. Mode-specific always-visible additions should include:
   - function admission label (`supported`, `preview`, `experimental`, `deferred`, `catalog_only`) where function-surface truth matters,
   - reliability/projection badge (`direct`, `derived`, `lossy`, `provisional`) where compare or replay evidence matters,
   - observation caveat badge (`capture-loss`, `uncertainty`, `unavailable`) where observation evidence matters,
   - replay capability floor relied upon where replay-facing interpretation matters,
   - product-surface maturity (`promoted`, `provisional`, `deferred`) where higher-level maturity matters.
4. The UI must not collapse the different vocabularies into one generic status chip.
5. Deeper detail belongs in the X-Ray, compare drawer, replay surfaces, and evidence views rather than being forced into the invariant header.

### Q14. First Comparison Envelope
Status: resolved
Question:
What exact comparison dimensions are in scope in wave one: value, type, display, formatting, conditional formatting, trace, provenance?
Why it matters:
The compare view risks overclaiming if the envelope is not frozen.
Decision:
1. Distinguish between:
   - the first promoted/product comparison envelope, and
   - the wider internal comparison schema envelope.
2. The first promoted/product comparison envelope is:
   - value,
   - formula text.
3. This is the current honest Excel-observed comparison floor and should govern current product claims.
4. The internal comparison schema may already include slots for:
   - value,
   - type,
   - display,
   - formatting,
   - conditional formatting,
   - provenance,
   - replay or trace divergence.
5. Those wider dimensions are only populated, surfaced, and claimed where the underlying retained source family actually supports them.
6. Every comparison artifact must declare exactly which dimensions are active for the compared artifact pair.
7. `DNA OneCalc` should not treat the narrow current envelope as a reason to stop there; the project should exert explicit downstream pressure on `OxXlObs` to widen the observation and comparison envelope.
8. Requirements for widening the envelope in `OxXlObs` should be captured as named work and dependency items rather than as vague future desire.
9. Confirmation of widened `OxXlObs` support should likewise be tied to retained evidence and explicit work completion, not assumed from design intent.

### Q15. Reliability And Projection Label Contract
Status: resolved
Question:
How should `direct`, `derived`, `lossy`, `provisional`, and `unavailable` interact in the UI and retained artifacts?
Why it matters:
Those labels come from different domains and can still confuse users if not normalized carefully.
Decision:
1. Keep the status vocabularies as separate typed axes rather than collapsing them into one merged status system.
2. Availability axis:
   - `available`
   - `unavailable`
3. `unavailable` is a hard non-comparable state, not a reliability level.
4. Reliability axis for available evidence:
   - exactly one of `direct`, `derived`, `lossy`
   - these are mutually exclusive.
5. Seam or capability confidence axis:
   - `provisional` or not
   - this may coexist with `direct`, `derived`, or `lossy`.
6. Product or scenario maturity axis remains separate:
   - `promoted`
   - `provisional`
   - `deferred`
7. Function admission axis remains separate:
   - `supported`
   - `preview`
   - `experimental`
   - `deferred`
   - `catalog_only`
8. Valid combinations include:
   - `direct` + `provisional`
   - `derived` + `provisional`
   - `lossy` + `provisional`
9. Invalid combinations include:
   - `unavailable` + `direct`
   - `unavailable` + `derived`
   - `unavailable` + `lossy`
10. Artifacts must store these as separate typed fields.
11. The UI should show only the relevant axes in the main truth strip or header and must never collapse them into one generic badge.

### Q16. OneCalc vs DNA ReCalc Service Boundary
Status: resolved
Question:
What replay services are embedded directly in OneCalc, and what remains explicitly DNA ReCalc territory?
Why it matters:
The replay host split is clearer than before, but not fully frozen.
Decision:
1. `DNA OneCalc` should embed replay services directly as app-facing workbench capabilities over shared `OxReplay` strata.
2. `DNA OneCalc` must not embed or re-expose the `DNA ReCalc` host shell as part of its own product identity.
3. The replay capabilities embedded directly in `DNA OneCalc` include:
   - replay bundle validation for artifacts it opens or produces,
   - replay views over current and retained scenario artifacts,
   - diff and explain in the workbench,
   - witness retain and review flows,
   - handoff drafting over retained replay evidence,
   - observation-artifact intake and comparison orchestration,
   - distill only where the active lane floor honestly supports it.
4. The following remain explicitly `DNA ReCalc` territory:
   - the generic replay host shell,
   - the generic replay CLI and operator contract,
   - generic cross-lane replay operations outside the OneCalc workbench context,
   - replay governance or operator surfaces presented as OneCalc-native product promises.
5. `DNA ReCalc` remains the generic replay host and neutral CLI/operator reference surface over `OxReplay`.
6. `DNA OneCalc` embeds replay mechanics, but it does not become `DNA ReCalc`.
7. `DNA OneCalc` should also act as a forcing function on:
   - `OxReplay`,
   - the replay artifact chain in `OxFml`,
   - the replay artifact chain in `OxFunc`,
   so replay gaps found through OneCalc are routed into explicit upstream requirements, work, and evidence closure rather than being worked around locally.

### Q17. First Promoted Scenario Spine Family
Status: resolved
Question:
What is the first promoted scenario family that defines the proving identity of the project?
Why it matters:
This is the first real public proving spine and should be chosen deliberately.
Decision:
1. All three of the following spine aspects are in scope for `DNA OneCalc`:
   - formula-core semantic and replay spine,
   - twin-oracle comparison spine,
   - language-service spine.
2. Their current priority order is:
   - first: formula-core semantic and replay spine,
   - second: twin-oracle comparison spine,
   - third: language-service spine.
3. The primary promoted scenario spine is therefore:
   - single-formula scenarios,
   - admitted built-in function surface,
   - `LET(...)`-friendly factoring,
   - deterministic recalc behavior,
   - the frozen returned-value classes through `BoundedRichValue`,
   - replay-visible execution and retained replay evidence,
   - formatting and effective-display behavior where upstream semantics already support it honestly.
4. The second major spine is the Windows-only twin-oracle comparison lane where the observed envelope supports it.
5. The third major spine is the formula-edit language-service lane, including diagnostics, completion, and help surfaces.
6. This ordering reflects current readiness and forcing value:
   - the formula-core semantic and replay spine should define the first proving identity,
   - the twin-oracle spine is the more driving and strategically distinctive comparison lane,
   - the language-service spine remains fully in scope and important, but it follows the first two in current proving order.

### Q18. Admission Labels In Product Behavior
Status: resolved
Question:
What exact product behavior follows from `supported`, `preview`, `experimental`, `deferred`, and `catalog_only` in help, completion, scenario metadata, and compare views?
Why it matters:
OxFunc now provides the vocabulary, but the host behavior is not yet fully pinned.
Decision:
1. Adopt the OxFunc admission labels as normative vocabulary and apply a OneCalc product-behavior layer over them.
2. `supported`
   - normal help and completion,
   - normal evaluation,
   - allowed in promoted scenario spines and default demos.
3. `preview`
   - visible `[Preview]` badge,
   - normal evaluation on the admitted slice,
   - allowed in the workbench and scenario library,
   - not part of the default promoted/product-claim spine unless the scenario is explicitly marked that way.
4. `experimental`
   - visible `[Experimental]` badge,
   - evaluation allowed where the runtime path exists,
   - the specific gap kind should be visible,
   - not part of default promoted/product-claim scenarios.
5. `deferred`
   - visible `[Deferred]` badge,
   - visible in help and browser surfaces,
   - not part of normal successful evaluation flow,
   - if invoked, produce a clear host-level not-available-in-current-scope outcome rather than silent failure,
   - used only in explicit pressure/discovery scenarios.
6. `catalog_only`
   - visible `[Catalog Only]` badge,
   - visible in catalog/help discovery surfaces,
   - not treated as evaluable,
   - used only in explicit pressure/discovery scenarios.
7. Completion behavior should be slightly stricter for usability:
   - `supported`, `preview`, and `experimental` may appear in ordinary completion,
   - `deferred` and `catalog_only` should be lower priority and may be hidden unless the user explicitly asks to see non-current surfaces.
8. Promoted/default product scenarios remain stricter than general discovery mode.

### Q19. First Native Extension ABI Surface
Status: resolved
Question:
What is the first native extension ABI surface and lifecycle we are actually freezing?
Why it matters:
Discovery, validation, enablement, registration, and invocation still need sharper closure.
Decision:
1. The first frozen native-extension surface is a tight subset of the Excel C API as defined by the Excel SDK documentation and corresponding header/code artifacts.
2. The intent is direct behavioral transfer of that subset into `DNA OneCalc`, not a merely inspired-by design.
3. On Windows:
   - `.xll` add-ins are the packaging form,
   - the extension lifecycle uses the Excel-style entry points such as `xlAutoOpen` and `xlAutoClose`,
   - host callbacks use the Excel-style `Excel12(...)` calling surface for the admitted subset.
4. On Linux:
   - the same admitted ABI and behavior should be preserved,
   - packaging uses `.so`,
   - an add-in that works under Excel and OneCalc on Windows should be portable to Linux by recompiling against the Linux target while preserving the admitted subset semantics.
5. Freeze the value boundary to `XLOPER12` support only.
6. Do not support legacy `XLOPER`.
7. The first admitted host-call subset includes:
   - `xlfRegister` Form 1 via `Excel12(...)`,
   - `xlfEvaluate`,
   - `xlUDF`,
   - `xlfRtd`.
8. The first admitted add-in capability is:
   - a minimal add-in that registers exported functions and makes them callable from formulas.
9. Support the admitted worksheet-call data types needed for those function calls, aligned as far as possible with the existing OxFunc function/value machinery.
10. Support volatility and related registration flags where declared.
11. Registration strings may include thread-safe indicators, but `DNA OneCalc` still executes on its single calculation thread.
12. This ABI freeze excludes interesting edge cases and keeps the admitted subset intentionally tight and exact.
13. `DNA OneCalc` does not admit worksheet `REGISTER.ID` / `CALL` semantics merely because it supports host-loaded add-ins.
14. RTD is in scope under this extension direction:
   - Windows should support the full RTD lifecycle for in-process COM servers,
   - Linux should provide a minimal COM-like activation registry and host contract for the admitted RTD server/interface subset,
   - browser/WASM hosts do not support native add-ins.
15. The Linux RTD activation model remains a concrete design task inside this admitted scope, but it does not change the frozen ABI direction above.

### Q20. Windows Twin-Oracle Workflow
Status: resolved
Question:
What is the exact first Windows-only live Excel comparison workflow, and what remains unavailable on Linux and browser hosts?
Why it matters:
Platform honesty is central to the product claim.
Decision:
1. The first live twin-oracle workflow is an explicit OneCalc-first, user-invoked Windows desktop compare flow.
2. The flow is:
   - author or edit a formula in `DNA OneCalc`,
   - execute the DNA path and retain a `ScenarioRun`,
   - invoke `Compare with Excel`,
   - drive live capture through `OxXlObs`,
   - ingest the resulting observation artifacts through `OxReplay`,
   - compare the `ScenarioRun` against the captured Excel observation,
   - show value comparison, formula-text comparison, provenance, reliability/projection labels, and Windows-only live-source status,
   - allow follow-on actions such as diff/explain inspection, witness retention, and handoff drafting.
3. This first workflow is Windows desktop only.
4. `DNA OneCalc` should not require always-on mirroring or continuous live Excel linkage as part of the first twin-oracle workflow.
5. Linux and browser/WASM hosts do not support:
   - live Excel capture,
   - live Excel comparison,
   - COM-backed observation flows,
   - live Excel-side RTD/twin-oracle behavior.
6. Linux and browser/WASM hosts do support:
   - loading retained observation artifacts,
   - replay/diff/explain over retained artifacts,
   - provenance and lossiness inspection,
   - reuse of prior Windows-captured evidence.
7. The twin-oracle discipline should also support comparison across `DNA OneCalc` versions and library versions:
   - if a defect is found, the same scenario should be rerun against updated OneCalc or updated upstream libraries,
   - the resulting runs should be retained and compared against each other as well as against Excel evidence where available.
8. Version-to-version comparison is therefore part of the core proving workflow, not a side feature.

### Q21. Acceptance Matrix By Host
Status: resolved
Question:
What are the first non-negotiable acceptance tests for Windows desktop, Linux desktop, and browser or WASM?
Why it matters:
The note names verification layers, but not yet the exact acceptance matrix.
Decision:
1. Use a shared-core acceptance set plus host-specific mandatory additions.
2. Shared core, mandatory on all hosts:
   - formula edit, parse, diagnose, and run for the primary promoted scenario spine,
   - deterministic re-run and forced re-run behavior,
   - replay capture and retained `ScenarioRun`,
   - replay open/diff/explain over retained artifacts where the declared lane floor supports it,
   - persistence round-trip for one-instance-per-file `SpreadsheetML 2003`,
   - formatting/effective-display for the promoted subset,
   - conditional-formatting for the promoted subset,
   - clear status/header truth and keyboard-usable main flows.
3. Windows desktop additional mandatory acceptance:
   - live `OxXlObs` compare workflow for the first comparison envelope,
   - provenance/reliability labeling for live Excel observations,
   - version-to-version scenario replay/compare,
   - native add-in loading for the admitted Excel-C-API subset,
   - `.xll` lifecycle and registration path,
   - RTD lifecycle for the admitted in-process COM server subset.
4. Linux desktop additional mandatory acceptance:
   - no claim of live Excel comparison,
   - retained Windows-captured observation consumption works,
   - `.so` native add-in loading for the admitted ABI subset,
   - version-to-version replay/compare works,
   - the declared Linux RTD path either works for the admitted design or is explicitly outside the current host claim.
5. Browser/WASM additional mandatory acceptance:
   - no claim of native add-ins,
   - no claim of live Excel comparison,
   - formula workbench, persistence, retained replay, retained comparison, and evidence browsing all work,
   - opening retained Windows-captured observations works,
   - all unsupported host capabilities are visibly gated rather than merely absent.
6. A host is accepted only if it passes the shared core plus its host-specific mandatory items.
7. A host may not borrow acceptance from another host's stronger capability set.

### Q22. Handoff Readiness Contract
Status: pending
Question:
What is the first handoff-packet readiness checklist and requested-action contract we want enforced in-product?
Why it matters:
This is core to the co-development mission and should be pinned early.
