# Temp Notes: Cell Concrete Model and Function Story

- Created: 2026-03-02
- Purpose: Capture iterative discussion notes and follow-up questions for later synthesis/re-processing.
- Status: working draft (temporary)

## Note 001
- User note: Add the new `. : .` style range operators to our formula-language universe.
- Clarification: Treat this as a preview-feature syntax lane that may not be fully represented in current formal spec anchors.
- Initial interpretation: Our current formula-language model likely lags this syntax and should carry an explicit provisional rule + probe lane until validated.
- Follow-up questions:
  1. What exact operator spellings should we include first (examples from real formulas)?
  2. Should we model this as parser-only (syntax acceptance) first, then evaluation semantics as phase 2?
  3. Do you want this tracked under formula-language only, or also linked to table/spill/coercion lanes now?
- Proposed next action: Add an `ECM-Q` open-question row and a `FML-R` provisional placeholder for preview range-operator syntax once examples are confirmed.

## Note 002
- User prompt: web search for relatively official Excel blog source on `. : .` operators.
- Findings:
  1. Excel Blog (TechCommunity): "Announcing TRIMRANGE and accompanying trim references" (2024-08-28).
     - https://techcommunity.microsoft.com/t5/excel-blog/announcing-trimrange-and-accompanying-trim-references/ba-p/4230202
  2. Excel Blog monthly update: "What's New in Excel (March 2025)" confirms rollout status to Windows CC/MEC.
     - https://techcommunity.microsoft.com/blog/excelblog/whats-new-in-excel-march-2025/4387484
  3. Microsoft Support (function reference): TRIMRANGE page documents trim refs explicitly:
     - `A1:.E10` (trailing), `A1.:E10` (leading), `A1.:.E10` (full trim)
     - https://support.microsoft.com/en-gb/office/trimrange-function-d7812248-3bc5-4c6b-901c-1afa9564f999
- Clarification:
  - This started as preview (blog explicitly says preview in 2024), then appears rolled out to Windows Current Channel / Monthly Enterprise by March 2025.
  - Formal openspec grammar anchors may lag this syntax; model should treat trim refs as explicit modern syntax lane with version-scoped caveat until formal anchors catch up.
- Follow-up:
  1. Add explicit syntax rows for `:.`, `.:`, `.:.` in formula-language matrix.
  2. Add release-status note per platform in conformance caveats.

## Note 003
- Mode: network-loss preparation (offline continuity).
- Actions:
  1. Freeze web-dependent discovery tasks.
  2. Continue only from local authoritative docs under `reference/conformance/excel-worksheet-engine/*` and local run artifacts.
  3. Keep external-link follow-ups queued (do not block function-discussion drafting).
- Offline work queue (safe without network):
  1. Add provisional syntax lane for trim refs (`:.`, `.:`, `.:.`) to formula matrix/open questions.
  2. Draft function taxonomy decisions in discussion doc (`volatile` vs `non-deterministic`, host interaction, invalidation classes).
  3. Build a decision table template for per-function class tags and conformance probe bindings.
- Resume trigger when network returns:
  1. Verify/cite external sources and import any missing canonical wording.

## Note 004
- Network-restored verification (as of 2026-03-02):
  1. TechCommunity Excel Blog post (2024-08-28): "Announcing TRIMRANGE and accompanying trim references" states preview status at announcement.
     - https://techcommunity.microsoft.com/blog/excelblog/announcing-trimrange-and-accompanying-trim-references/4230202
  2. TechCommunity Excel Blog update (2025-03-25): "What's New in Excel (March 2025)" states rollout to Windows CC and MEC users.
     - https://techcommunity.microsoft.com/blog/excelblog/whats-new-in-excel-march-2025/4387484
  3. Microsoft Support TRIMRANGE reference documents trim refs and concrete forms:
     - `A1.:.E10` (trim all), `A1:.E10` (trim trailing), `A1.:E10` (trim leading)
     - https://support.microsoft.com/en-gb/office/trimrange-function-d7812248-3bc5-4c6b-901c-1afa9564f999
- Clarification response:
  - Yes: this supports your point that older/open formal grammar anchors are likely behind current product behavior for this syntax family.
  - Practical modeling choice: treat trim refs as a version-scoped formula-language syntax extension lane with explicit platform/release caveat metadata.
- Suggested next note item:
  1. decide if trim refs are represented as three distinct operators (`:.`, `.:`, `.:.`) or one parameterized range-operator family in the concrete model.

## Note 005
- Decision: represent trim references as one operator family, not three unrelated operators.
- Agreed representation:
  1. Family id: `trim_ref`
  2. Modes: `leading`, `trailing`, `both`
  3. Surface syntax mapping:
     - `A1.:E10` -> `trim_ref(mode=leading, range=A1:E10)`
     - `A1:.E10` -> `trim_ref(mode=trailing, range=A1:E10)`
     - `A1.:.E10` -> `trim_ref(mode=both, range=A1:E10)`
- Follow-up checklist for later patch:
  1. Add provisional `FML-R` row for `trim_ref` family.
  2. Add `ECM-Q` lane for grammar/eval/version caveats.
  3. Add scenario seeds for parser acceptance + normalization + behavior probes.
  4. Tag as release-scoped modern syntax extension.

## Note 006
- User note: operators in the language concrete rules (including reference operators) must also be defined as functions.
- Interpretation:
  1. Treat operators as first-class function definitions in the same taxonomy as named functions.
  2. Add pseudo-identifiers so operator semantics are governed by the same conformance machinery.
- Proposed pseudo-identifier pattern:
  1. prefix: `OP_`
  2. examples:
     - `OP_RANGE` (`:`)
     - `OP_UNION` (`,`) [reference union]
     - `OP_INTERSECT` (` `)
     - `OP_IMPLICIT_INTERSECTION` (`@`)
     - `OP_SPILL_REF` (`#` suffix)
     - `OP_TRIM_REF` (`.:`, `:.`, `.:.` as mode parameter)
     - `OP_ADD`, `OP_SUB`, `OP_MUL`, `OP_DIV`, `OP_POW`, `OP_CONCAT`, `OP_PERCENT`, `OP_COMPARE_EQ`, etc.
- Why this is useful:
  1. Unifies coercion/error/volatility/host-interaction metadata under one function-definition schema.
  2. Enables shared conformance templates for parser + evaluator lanes.
- Follow-up tasks:
  1. Define operator-function inventory and arity signature table.
  2. Define metadata schema fields shared with regular functions.
  3. Link each `FML-R-*` rule to one or more `OP_*` rows in function-definition conformance.

## Note 007
- Decision refinement: split `UNION_REF` and `ARG_SEPARATOR`.
- Recommended modeling split:
  1. `UNION_REF` is evaluable semantics and should be represented as operator-function (`OP_UNION_REF`).
  2. `ARG_SEPARATOR` is primarily parse-structure (call-argument delimiter), not an evaluable function by itself.
- Localization clarification:
  1. Decimal separator and argument/list separator are locale-sensitive lexical concerns.
  2. Separator tokens (`;` vs `,`) belong to formula-language concrete rules with locale profile metadata.
  3. Keep lexical tokenization separate from semantic operator ids.
- Practical schema recommendation:
  1. In language rules: define locale token profile (`decimal_sep`, `arg_sep`, `array_row_sep`, `array_col_sep`).
  2. In function-definition lane: include only evaluable operators/functions (`OP_*`), excluding pure delimiters.
  3. If needed for traceability, keep a parser-only pseudo-id (for example `SYN_ARG_SEPARATOR`) outside function semantics tables.
- Follow-up patch items (later):
  1. Add locale token profile section to concrete language rules.
  2. Add `OP_UNION_REF` (and related reference operators) to function-definition prelim conformance.
  3. Add explicit non-goal note: `ARG_SEPARATOR` is syntax delimiter, not value-level function.

## Note 008
- Question: most comprehensive information source for how `=@function(,,,)` is resolved.
- Conclusion: there is no single canonical source; best coverage is a layered source stack.
- Layered source stack (recommended priority):
  1. Formula grammar anchor (MS-XLSX Formulas ABNF):
     - https://learn.microsoft.com/en-us/openspecs/office_standards/ms-xlsx/3d025add-118d-4413-9856-ab65712ec1b0
  2. Tokenized parse/eval model with explicit missing-arg token and operators (MS-XLSB / MS-XLS Rgce+Ptg):
     - https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-xlsb/54897b6b-9f69-4c17-868a-b09ef126c8ab
     - https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-xls/6cdf7d38-d08c-4e56-bd2f-6c82b8da752e
     - https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-xlsb/5d7c0c3f-f75f-4306-804f-6f2ebc6bf811
  3. `@` explicit implicit-intersection behavior:
     - https://support.microsoft.com/en-gb/office/implicit-intersection-operator-ce3be07b-0101-4450-a24e-c1c999be2b34
  4. Legacy/standards behavior notes for implicit intersection and range-accepting arguments:
     - https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oi29500/c45b0396-bc38-4fd6-abf7-9782b7d6f926
  5. Locale tokenization/list separator behavior:
     - https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/excel/formula-errors
- Practical resolution model for `=@function(,,,)`:
  1. Locale profile determines lexical separators (comma/semicolon, decimal separator).
  2. Parser builds function call and emits missing-argument nodes (conceptually `PtgMissArg`) for empty positions.
  3. Function binder/evaluator applies function-specific omitted-argument rules (not globally uniform).
  4. `@` applies scalarization/implicit-intersection semantics to the target expression in modern formula language.
  5. Final result/error depends on both omitted-arg policy for that function and scalarization context.
- Key caveat:
  - The exact behavior of `(,,,)` is largely function-specific and incompletely centralized in public docs; empirical conformance probes remain necessary.

## Note 009
- Topic: implicit-intersection operator as function-definition concern.
- Confirmed history:
  1. Microsoft Excel Blog (2019, Dynamic Array Improvements): initial dynamic-array release represented implicit intersection with `SINGLE`, then changed to `@` based on feedback.
     - https://techcommunity.microsoft.com/t5/excel-blog/excel-dynamic-array-improvements/ba-p/332070
  2. Microsoft Support (`@` operator): when mixed formulas are opened in pre-dynamic-array Excel, `@` can appear as `_xlfn.SINGLE(...)`.
     - https://support.microsoft.com/en-gb/office/implicit-intersection-operator-ce3be07b-0101-4450-a24e-c1c999be2b34
- Modeling decision implication:
  1. Keep canonical operator-function id: `OP_IMPLICIT_INTERSECTION` (surface `@`).
  2. Add legacy interop alias metadata: `legacy_alias = SINGLE` / serialized fallback `_xlfn.SINGLE(...)` for pre-DA compatibility paths.
  3. Treat `_xlfn.SINGLE` as compatibility/serialization representation, not a separate semantic operator in the modern model.
- Follow-up:
  1. Add this explicitly to function-definition prelim spec/conformance.
  2. Add parser/serializer caveat row in language concrete rules for pre-DA roundtrip behavior.

## Note 010
- Topic: Excel "Compatibility Versions" and workbook-level versioned function definitions.
- User note: function definitions can vary by compatibility version, selected at workbook scope.
- Modeling implications:
  1. Function-definition rows must be version-scoped (`compat_version_range`) rather than globally single-valued.
  2. Conformance expectations must include workbook compatibility version as an evaluation context axis.
  3. Divergence between versions should be first-class, not treated as regression by default.
- Proposed schema additions:
  1. Add `compat_version_policy` field to function-definition records.
  2. Add `version_toggle_effect` metadata for functions/operators affected by compatibility mode.
  3. Add probe matrix dimension: `{excel_build, channel, platform, workbook_compat_version}`.
- Follow-up tasks:
  1. Add explicit section in function prelim spec for versioned function semantics.
  2. Add preliminary conformance rows for version-scoped behavior gates.
  3. Link to existing conformance lanes `XLS-CF-VP-001` and `XLS-CF-VP-002`.

## Note 011
- Topic cluster: function-definition deepening notes (lossless capture, 2026-03-02).
- Argument/return conversion model:
  1. There can be coercion of arguments before function call and coercion/adaptation of return values after function call.
  2. Example: a function declares string parameter and host coerces numeric input to string before call.
  3. Example: function returns an array and host converts to dynamic-array anchor extended value; spill cells become virtual values relative to anchor.
  4. Spill details are mostly outside this function-definition doc, but return adaptation to anchor extended value is in-scope.
- UDF surface taxonomy (working list):
  1. XLL UDFs (Excel SDK / `xlcall.h`, `xlfRegister`, registration flags, caller context `xlfCaller`, reference argument flavors including local/process scope refs).
  2. VBA UDFs (scope behavior differs workbook vs add-in; variants/range COM object interactions).
  3. Automation Add-in UDFs (COM library registration model; lower-priority detail depth for now).
  4. JavaScript custom functions (including extended values such as linked/custom data types).
  5. Open questions retained: VBA UDF can return `Range`? what mutations/formatting are allowed in VBA UDF body?
- Value model note:
  1. Distinguish `value` vs `extended_value`.
  2. Candidate extended values include:
     - value with formatting hint,
     - error with detail payload (`source`, `description`, etc.),
     - virtual value relative to anchor.
- Function examples:
  1. `NOW` and `TODAY` are volatile + time-dependent.
  2. Working note: may include value-with-formatting behavior (or extended value carrying formatting hint).
- Volatility terminology concern:
  1. `volatile_full` vs `volatile_contextual` is currently unclear/underspecified and needs precise definition.
  2. Preferred wording: volatility is invalidation policy, not output determinism.
  3. Working hypothesis from user note: volatile behavior is akin to a per-cell flag retained after evaluation unless explicitly disabled (`xlfVolatile` / `Application.Volatile` pattern).
- Implicit intersection:
  1. Need exact write-up from official blog/support semantics; track as high-priority function/operator-definition item.
- RTD lifecycle note (cell-rooted semantics):
  1. First RTD call from a cell (or UDF rooted at a cell) establishes topic connection and topic->cell association.
  2. External RTD updates invalidate mapped cells.
  3. Recalc path either refreshes via RTD call for topic or disconnects topic if no longer referenced.
- Operator/reference adaptation note:
  1. `#` spilled-range references may be fully resolved to a range/array before function call (coercion-time operator).
  2. Similar question for structured references.
  3. Open question: can non-interesting functions observe distinction between original reference syntax vs resolved values/reference payload?
- Determinism classification question:
  1. Is `INDIRECT(...)` non-deterministic, or deterministic but context-dependent?
- Non-interesting function implementation hypothesis:
  1. Candidate claim: every non-interesting function can be implemented with full fidelity as UDF-style function (signature family like `U...`), given sufficient coercion/reference handling.
  2. Example to verify: `XLOOKUP` can produce reference-like outputs from reference inputs.
  3. Need dedicated confirmation probes for `XLOOKUP` reference-return behavior.
  4. Candidate host interaction class for non-interesting functions: argument-reference dereference only (still considered non-interesting).
- Program proposal:
  1. Find non-interesting functions that violate the above hypothesis.
  2. Build XLL implementation set for all non-interesting functions and validate implementation-vs-native across value/reference/error/coercion cases.
  3. Derive class tags (`host_interaction_class`, `coercion_policy_class`, `error_policy_class`) from implementation+differential evidence.
- Interesting-functions directive:
  1. Put full interesting-function list into function-definition docs.
  2. Attempt class-axis classification for each function now, with later refinement.

## Note 012
- Working-doc updates applied from Note 011 cluster:
  1. Function prelim spec expanded with:
     - argument/return conversion boundary,
     - value vs extended-value framing,
     - operator-as-function vs syntax-delimiter split,
     - UDF surface taxonomy (XLL/VBA/Automation/JS),
     - compatibility-version semantics,
     - implicit-intersection canonicalization (`OP_IMPLICIT_INTERSECTION` + `SINGLE` alias context).
  2. Function prelim conformance rows extended (`FDEF-009`..`FDEF-024`) to track these themes explicitly.
  3. Discussion register expanded with topics `D-007`..`D-013`.
  4. Interesting-function initial classification artifact added (`71` rows; tiers 3/4/5).
  5. Prompt pack created for language-independent `.xll` non-interesting-function implementation planning.
- Outstanding open questions retained (not silently resolved):
  1. exact volatility taxonomy (`volatile_full` vs `volatile_contextual`),
  2. VBA UDF mutation/Range-return constraints,
  3. `INDIRECT` determinism vs context-dependence,
  4. `XLOOKUP` reference-output behavior confirmation,
  5. observability of pre-call normalized references by non-interesting functions.
