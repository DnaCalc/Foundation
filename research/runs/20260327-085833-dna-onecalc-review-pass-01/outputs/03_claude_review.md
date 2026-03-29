---

# DNA OneCalc Design Review — External Review Report

**Reviewer stance:** rigorous, unsentimental, scope-honest, bootstrap-executable.
**Date:** 2026-03-27
**Source corpus:** Foundation doctrine (`CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `BRAINSTORM_NOTES.md`) + DnaOneCalc planning files (`DNA_ONECALC_INITIAL_SCOPE.md`, `01_scope_and_host_profile_plan.md`, `02_repo_readiness_and_outstanding_work.md`).

---

## 1. Findings

Ordered by severity (highest first).

### F-01 [CRITICAL] — Host Charter Conformance Ladder is missing

**Doctrine reference:** `OPERATIONS.md:380-386` (Section 8.12) requires every host charter to declare: semantic surface commitments by feature family (`Committed`/`Experimental`/`Deferred`), degradation-class expectations (`Native`/`Lowered`/`Opaque`/`Rejected`), and required pack set before downstream hosts may rely on its claims.

**Current state:** Neither `DNA_ONECALC_INITIAL_SCOPE.md` nor the research output `01_scope_and_host_profile_plan.md` includes any of these declarations. The host profiles OC-H0/H1/H2 are described in prose, not as machine-readable conformance artifacts. The plan skips the conformance ladder entirely and goes straight to worksets and milestones.

**Risk:** Without the conformance ladder, the host has no doctrine-compliant way to declare readiness, block premature downstream reliance, or gate milestone transitions. This is not optional per Foundation doctrine — it is normative.

### F-02 [CRITICAL] — No pack requirements declared for any milestone

**Doctrine reference:** `OPERATIONS.md:79-113` (Section 4.1), `OPERATIONS.md:145-149` (Section 4.2).

**Current state:** Milestones M0–M4 in the research plan describe deliverables in prose, but declare zero required obligation packs. No `PACK.*` identifiers are named. No gate criteria exist. The plan says "deliver X" without saying "prove X."

**Risk:** This directly contradicts the doctrine requirement that profiles cannot be declared stabilized without green packs. Without pack declarations, the milestone ladder is aspirational prose, not an executable gate sequence.

### F-03 [HIGH] — Formatting scope is overcommitted relative to the "narrowest honest scope" claim

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:134-153` (Section 5.4), `01_scope_and_host_profile_plan.md:117-136`.

**Current state:** The plan claims formatting is "first-class" and includes: full format-string support, persisted base cell-formatting, fonts with honest cross-platform mapping, colors, effective-display projection, and full conditional-formatting support. This is bundled into the early milestones.

**Contradiction:** The same plan repeatedly insists on "the narrowest honest scope." Full format-string support alone (Excel's format-string mini-language is enormous — locale-dependent, section-conditional, color codes, fill characters, date/time patterns) is a multi-month lane. Full conditional formatting on top of that is another major lane. Together these are likely larger than the core formula evaluation pipeline.

**Recommendation:** Split formatting into tiers: (a) literal value display with OxFml-native format tokens (M0), (b) format-string interpretation for a bounded subset (M1), (c) full conditional formatting (M2+). Do not claim "full" anything in M0/M1.

### F-04 [HIGH] — Leptos choice is undocumented and unvalidated

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:193-204` (Section 6.1), `01_scope_and_host_profile_plan.md:148-152`.

**Current state:** Leptos is declared as the chosen UI framework. No evaluation, risk assessment, alternative comparison, or proof-of-concept spike is referenced. No evidence that Leptos + Tauri + WASM target has been validated for this workload.

**Risks:**
- Leptos is a relatively young Rust web framework. Ecosystem maturity, component library depth, and production evidence are thin compared to alternatives.
- The plan requires rich interactive formula editing with live diagnostics, IME support, keyboard-first navigation, and replay control surfaces. These are demanding UI requirements.
- No WASM bundle size budget exists. OxFml + OxFunc + OxReplay compiled to WASM through Leptos could produce a very large bundle.
- No fallback or kill-switch is declared per `OPERATIONS.md:436-445` (Section 8.16 advanced experimental lane policy).

**Recommendation:** Add a bounded Leptos+Tauri proof-of-concept spike as the first work packet. Validate: formula input → evaluation → result display → basic replay capture. Measure WASM bundle size. Document the decision with evidence before committing the full repo to this stack.

### F-05 [HIGH] — Linux .xll support is asserted without acknowledging the ABI problem

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:246-255` (Section 8.1), `01_scope_and_host_profile_plan.md:108`.

**Current state:** The plan repeatedly states "desktop-only `.xll` admission path for Windows and Linux." The `.xll` format is a Windows DLL with XLL callback conventions — it is inherently Windows-specific. Running .xll on Linux requires either a compatibility layer (Wine/Proton), a custom ABI bridge, or a fundamentally different add-in format that happens to share the .xll label.

**Risk:** Asserting Linux .xll parity without acknowledging the ABI gap is either hand-waving or a hidden massive work item. This is exactly the kind of "we can figure it out later" claim the review should not accept.

**Recommendation:** Either (a) make first-wave desktop add-ins Windows-only and defer Linux to a separate research spike, or (b) explicitly define the Linux add-in format as something other than native .xll, with an honest scope statement.

### F-06 [HIGH] — "Twin Oracle Workbench" is a name without a contract

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:57-58` (Section 3), `01_scope_and_host_profile_plan.md:30-35`.

**Current state:** "Twin Oracle Workbench" is named as the strongest strategic direction. Seven mode names are listed (`DNA-only`, `Excel-observed`, `Twin compare`, `Replay`, `Diff`, `Explain`, `Distill`, `Handoff`). But no contract exists: no mode definitions, no mode transitions, no required capabilities per mode, no pack bindings.

**Risk:** An inspiring name without a specification is a scope magnet. Each of those eight modes is a significant feature. Without a contract, they will either all be half-built or scope will silently expand.

**Recommendation:** Define a one-page mode contract: for each mode, state (a) what it does, (b) minimum required capabilities, (c) which milestone it enters, (d) required pack. Lock this before repo bootstrap.

### F-07 [MEDIUM] — Replay "fully visible and controllable through the UI" from M0 is unrealistic

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:296-299` (Section 9.1), `01_scope_and_host_profile_plan.md:256-259`.

**Current state:** M0 requires "first in-app replay visibility/control surface" and "first visible Twin Oracle Workbench mode switch surface." The broader plan requires "replay capture, replay execution, diff, explain, witness inspection, and retained-scenario promotion are fully visible and controllable through the UI."

**Risk:** Building a full replay control surface in-app is a substantial UI engineering effort — likely comparable to the formula evaluation pipeline itself. Demanding it at M0 alongside formula entry, evaluation, result display, and the Leptos/Tauri stack standup is overloading the first milestone.

**Recommendation:** M0 should require: (a) replay capture that emits OxReplay-compatible bundles, (b) a minimal replay status indicator in the UI. Full replay control surfaces (replay execution, diff, explain, witness inspection) should enter at M1 or M2. CLI-based replay interaction is acceptable for M0.

### F-08 [MEDIUM] — Promotion Packet Contract is not addressed

**Doctrine reference:** `OPERATIONS.md:388-395` (Section 8.13) requires that no host/pathfinder finding may be promoted into Foundation doctrine without a promotion packet.

**Current state:** The plan describes DnaOneCalc as a "co-development program" that produces "structured requirement deltas" and "upstream seam clarification requests." But no promotion packet format, no handoff contract, and no workflow for routing these findings upstream is specified.

**Risk:** Without this, the "co-development" framing is aspirational. DnaOneCalc findings will either informally leak into upstream repos or pile up in undiscoverable notes.

### F-09 [MEDIUM] — SpreadsheetML 2003 mapping is an unresolved research dependency

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:226-239` (Section 7), `01_scope_and_host_profile_plan.md:199-211`.

**Current state:** SpreadsheetML 2003 is chosen as the first file format. The plan explicitly acknowledges an "open mapping question" about how instances map to worksheets or regions. This is not a cosmetic detail — it determines the document model.

**Risk:** Starting persistence implementation before resolving the mapping creates rework risk. The plan correctly flags it as needing resolution "before repo bootstrap hardens" but doesn't schedule the resolution as a pre-bootstrap work item.

### F-10 [MEDIUM] — No `meta check` equivalent or CI story

**Doctrine reference:** `CHARTER.md:16` (Doctrine 2.1.3: "one-command readiness"), `OPERATIONS.md:197-205` (Section 6.1).

**Current state:** No mention of a `meta check` command, CI pipeline, build gates, or automated readiness checks for the DnaOneCalc repo.

### F-11 [MEDIUM] — Wave B/C alignment is implicit, not explicit

**Doctrine reference:** `OPERATIONS.md:518-519` (Section 10.3, Waves B and C).

**Current state:** Wave C is defined as "DNA OneCalc proving host — no-reference-resolution profile proving, formula language completeness, OxFunc function catalog validation, Stage 1 sequential coordinator." The DnaOneCalc plan doesn't reference the wave sequence at all, doesn't map milestones to waves, and doesn't confirm that its scope satisfies Wave C gate criteria.

### F-12 [LOW] — Multi-instance support adds complexity with unclear justification

**File references:** `DNA_ONECALC_INITIAL_SCOPE.md:215-222` (Section 6.3).

**Current state:** The plan allows multiple visible isolated calculation instances. No justification is given for why this is needed in the initial scope versus simply having one formula instance per document/tab.

**Recommendation:** Defer multi-instance to M2+. It adds persistence, UI, and state management complexity with no stated need for the proving mission.

### F-13 [LOW] — WASI host is mentioned but never justified

**File references:** `01_scope_and_host_profile_plan.md:163`.

**Current state:** "Optional later non-UI/WASI or CLI harness" is mentioned. No justification for why WASI would be needed when a CLI harness could simply be a native binary.

---

## 2. Best Direction

**Question:** What's the single smartest and most radically innovative and accretive and useful and compelling feature or direction we can consider for DnaOneCalc at this point?

**Answer: Live Formula Semantic X-Ray.**

Make DnaOneCalc the world's first **interactive formula semantic debugger** — a tool where you type any Excel formula and see, in real time:

1. **The parse tree** — every token, operator binding, function resolution, with live error annotation.
2. **The evaluation trace** — step-by-step evaluation with intermediate values at every node, showing which OxFunc semantics fired, which coercion rules applied, which profile-governed policy decided an ambiguous case.
3. **The Excel comparison** (Windows) — the same formula evaluated live in Excel via OxXlObs, with a structured semantic diff showing exactly where and why DNA and Excel diverge.
4. **The provenance record** — for every intermediate step, a link to the spec clause, empirical finding, or open question that governs that behavior.

The radical innovation is that **every formula typed into DnaOneCalc is simultaneously a product interaction, a test case, a corpus entry, and an upstream work request generator.** Using the tool IS building the evidence base. Every user session grows the program's semantic atlas of Excel formula behavior.

No tool like this exists anywhere. Excel's own formula evaluation is a black box. DnaOneCalc can be the first transparent formula engine — a semantic microscope that makes formula behavior inspectable, comparable, and provable.

This is more compelling than "single-cell calculator with replay" because it makes the replay infrastructure *visible and interactive* rather than a background plumbing concern. The evaluation trace IS the product. The diff IS the product. The provenance IS the product.

This also solves F-07 naturally: the replay/trace UI isn't a separate control surface bolted on — it IS the primary product surface. The formula semantic debugger is the Twin Oracle Workbench made concrete.

---

## 3. One Level Deeper

### Proposed artifact model

The current plan uses prose milestones and worksets without machine-readable contracts. Replace with:

| Artifact | Format | Owner | Gate role |
|---|---|---|---|
| Host charter | YAML frontmatter + markdown | DnaOneCalc repo | Required before first milestone claim |
| Host profile schema (OC-H0, OC-H1, OC-H2) | Machine-readable profile declarations | DnaOneCalc repo, conforming to Foundation schema | Required per OPERATIONS 8.12 |
| Acceptance matrix | CSV: feature family × status (`Committed`/`Experimental`/`Deferred`) | DnaOneCalc repo | Required per OPERATIONS 8.12 |
| Degradation matrix | CSV: feature family × class (`Native`/`Lowered`/`Opaque`/`Rejected`) | DnaOneCalc repo | Required per OPERATIONS 8.12 |
| Pack declarations | `PACK.onecalc.*` with scope/threshold/artifact contract | DnaOneCalc repo | Required before milestone gate |
| Upstream handoff packets | Structured markdown per OPERATIONS 8.13 | DnaOneCalc repo → Ox* repos | Required for co-development claim |
| Capability manifest | JSON | DnaOneCalc repo | Required for downstream reliance |
| Seam version pins | Lock file or manifest section | DnaOneCalc repo | Required at bootstrap |

### Proposed milestone ladder (sharper)

**M0: Vertical Slice** (replaces current M0)
- Gate: formula string → OxFml parse → OxFunc evaluate → typed result → rendered display → OxReplay bundle emitted.
- Required packs: `PACK.onecalc.h0.core` (end-to-end path green), `PACK.onecalc.replay.capture` (at least one bundle validates through OxReplay).
- Artifacts: host charter, OC-H0 profile declaration, acceptance matrix, seam version pins.
- Explicit non-scope: no formatting beyond literal display, no replay UI controls, no persistence, no multi-instance, no Twin Oracle modes.

**M1: Explicit-Input Host + Formatting Floor** (replaces current M1 + parts of M2)
- Gate: OC-H1 profile with explicit host-bound input slots, bounded format-string subset, base formatting state.
- Required packs: `PACK.onecalc.h1.input`, `PACK.onecalc.format.basic`.
- Artifacts: OC-H1 profile declaration, first upstream handoff packet.
- Explicit non-scope: no conditional formatting, no full format-string language, no add-ins.

**M2: Persistence + Evaluation Trace UI** (replaces current approach of front-loading everything)
- Gate: SpreadsheetML 2003 round-trip for OC-H1 instances with formatting state, first in-app evaluation trace/replay view.
- Required packs: `PACK.onecalc.persist.spreadsheetml`, `PACK.onecalc.replay.ui.basic`.
- Pre-requisite: SpreadsheetML mapping resolution (WP-06).

**M3: Twin Oracle Baseline (Windows)** (sharpens the strategic direction)
- Gate: Live formula evaluation in DNA + live Excel evaluation via OxXlObs + structured semantic diff, all in one flow. First retained comparison family.
- Required packs: `PACK.onecalc.twin.compare.basic`, `PACK.onecalc.scenario.retained.first`.
- Platform: Windows-only for the comparison leg.

**M4: Conditional Formatting + Scenario Library Growth**
- Gate: conditional-formatting rules on isolated instances, replay-visible CF consequences, growing scenario corpus.
- Required packs: `PACK.onecalc.format.cf.basic`.

**M5: Extension Lane** (current M4, pushed later)
- Gate: desktop-only external provider registration, first .xll admission (Windows only initially).
- Linux .xll deferred pending explicit ABI research.

### Concrete early work packets

**WP-01: Host Charter & Conformance Ladder Declaration**
- Write the DnaOneCalc host charter per `OPERATIONS.md` Section 8.12.
- Produce: acceptance matrix, degradation matrix, required pack set.
- Must complete before repo creation is considered doctrine-compliant.

**WP-02: Leptos + Tauri + WASM Proof-of-Concept Spike**
- Build a minimal app: text input → call a Rust function → display result → measure WASM bundle size.
- Kill-switch: if WASM bundle exceeds 10MB uncompressed or Leptos cannot handle IME/keyboard requirements, escalate before committing.
- Output: spike report with measurements, go/no-go recommendation.

**WP-03: OxFml/OxFunc Seam Version Pin & Integration Contract**
- Document exactly which OxFml host packet types and OxFunc library-context exports DnaOneCalc will consume.
- Produce a seam contract document with version pins, break-glass policy, and expected evolution cadence.

**WP-04: H0 Vertical Slice Implementation**
- The narrowest end-to-end path: formula string → parse → bind → evaluate → typed result → rendered value → OxReplay bundle.
- No formatting, no persistence, no replay UI, no multi-instance.
- Output: working binary + `PACK.onecalc.h0.core` green.

**WP-05: SpreadsheetML 2003 Instance Mapping Research**
- Resolve the open question: how do isolated instances map to the SpreadsheetML envelope?
- Output: mapping decision document with round-trip test evidence.

**WP-06: Twin Oracle Mode Contract**
- Define each of the eight named modes (`DNA-only`, `Excel-observed`, `Twin compare`, `Replay`, `Diff`, `Explain`, `Distill`, `Handoff`).
- For each: definition, minimum capability, milestone entry, required pack.
- Lock which modes are M0, which are later.

**WP-07: Upstream Handoff Format Definition**
- Define the structured format for requirement deltas, seam clarification requests, and work packets flowing from DnaOneCalc to Ox* repos.
- Must conform to `OPERATIONS.md` Section 8.13 promotion packet contract.

**WP-08: Evaluation Trace Schema Design**
- Design the trace schema that makes formula evaluation inspectable in the UI (the "semantic X-ray").
- This must align with OxReplay trace schemas and OxFml evaluator trace output.
- Output: trace schema spec + first rendering prototype.

**WP-09: Formatting Tier Model**
- Define three formatting tiers: (T1) literal value display, (T2) bounded format-string subset, (T3) full format-string + conditional formatting.
- For each tier: scope boundary, required OxFml/OxFunc surface, pack requirement.
- Lock which tier enters which milestone.

**WP-10: Wave C Alignment Verification**
- Explicitly map the DnaOneCalc milestone ladder to Foundation Wave C criteria (`OPERATIONS.md:519`).
- Confirm or flag gaps between the plan and the wave gate requirements.

### What must be deferred

| Item | Reason |
|---|---|
| Linux .xll support | ABI gap unresolved; Windows-only first |
| Multi-instance | Adds complexity with no stated proving need |
| WASI host | No justification; native CLI suffices |
| Full conditional-formatting | Depends on OxFml carrier maturity; tier explicitly |
| Full format-string language | Enormous scope; subset first |
| OxVba integration | Upstream not ready; staged later per readiness assessment |
| Completion/autocomplete | Nice UX but not proving-mission-critical for M0-M2 |
| OxCalc integration | Explicitly out of scope per plan (correct) |
| Browser/WASM add-in support | Correctly deferred in plan |
| Collaboration | Correctly out of scope |

---

**Summary judgment:** The plan's strategic instincts are sound — the host/lane distinction is correct, the dependency model is honest, the "start now" judgment is defensible. But the plan is currently a product vision document, not a doctrine-compliant host charter. The gap between what Foundation doctrine requires (conformance ladders, pack declarations, gate criteria, promotion packets) and what the plan provides (prose milestones, workset lists, aspirational scope statements) is the single largest risk. Close that gap before creating the repo, or the repo will start life out of compliance with its own program's rules.
