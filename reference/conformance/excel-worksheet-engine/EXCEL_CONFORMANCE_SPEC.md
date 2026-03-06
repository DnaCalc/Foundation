# Excel Worksheet-Engine Conformance Specification

## 1. Purpose
This is the authoritative working conformance specification for the in-scope Excel worksheet-engine compatibility surface.

It is intended to drive:
1. implementation requirements,
2. conformance test planning/execution,
3. evidence-based compatibility decisions.

## 2. Scope
In scope:
1. Formula language semantics.
2. Built-in worksheet function set and interesting-function classification.
3. Sheet-visible value types/coercion behavior.
4. ListObject/Table semantics.
5. Cell formatting and conditional formatting behavior.
6. Version/platform caveats and release-channel awareness.

Out of scope (unchanged):
1. Power Query/M and DAX formula languages.
2. MDX internals (while CUBE worksheet functions remain in scope).

## 3. Normative Artifacts
1. Requirement corpus: `CONFORMANCE_REQUIREMENTS.csv`.
2. Source registry bridge: `SOURCE_BINDINGS.csv`.
3. Open/provisional lane register: `KNOWN_GAPS_AND_UNCERTAINTIES.md`.
4. Concrete Excel-first model: `model/EXCEL_CELL_CONCRETE_MODEL.md`.
5. Concrete formula-language rules: `model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`.
6. Formula-language conformance matrix: `model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`.
7. Formula-language pass-2 probe plan: `model/EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`.
8. Formula-language pass-2 scenario seed list: `model/EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv`.
9. Concrete-model open/gap ledger: `model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`.
10. Concrete-model trace ledger: `model/EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`.
11. FEC planning draft: `model/EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md`.
12. FEC/F3E interface draft specification: `model/FEC_F3E_INTERFACE_DRAFT_SPEC.md`.
13. FEC/F3E protocol conformance matrix: `model/FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv`.
14. Formatting hierarchy/visibility model: `model/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`.
15. Pass-2 execution outputs: `../../../research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/`.
16. Empirical registry: `../../empirical/findings_registry.jsonl`.
17. Prior authoritative source registry: `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/source_list.csv`.
18. Function-definition preliminary scope/spec: `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`.
19. Function-definition preliminary conformance lanes: `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`.
20. Function-definition discussion register: `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_DISCUSSION.md`.
21. Function-universe formalization charter: `../../../../OxFunc/CHARTER.md`.
22. Non-function closure empirical run outputs: `../../../research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/`.
23. Interesting-function initial classification table: `../../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.csv`.
24. Interesting-function initial classification summary: `../../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.md`.
25. XLL SDK registration/types digest: `functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`.
26. Formatting formal focused pass outputs: `../../runs/20260305-ms-formatting-formal-pass-01/outputs/`.
27. Formatting hierarchy empirical probe-pack scaffold: `../../../research/runs/20260305-235500-excel-formatting-hierarchy-empirical-pack-01/outputs/`.

## 4. Evidence Lineage Model
1. `ECS-*`: source ids from prior authoritative Excel source registry.
2. `REFX-*`: mirrored Open Spec entries and focused extraction anchors under `reference/index.*` and `reference/runs/*`.
3. `EMP-*`: curated empirical findings promoted from empirical run artifacts.
4. `INT-*`: internal normative design artifacts (FEC/F3E protocol and boundary docs) bound through `SOURCE_BINDINGS.csv`.

Each requirement row must cite one or more evidence ids from this model.

## 5. Conformance Status Semantics
1. `normative`: requirement is required for conformance implementation/test gates.
2. `provisional`: requirement captures unresolved or conflicting evidence and must remain explicit; it is not a sole-release gate without waiver.

## 6. Claim Confidence and Assurance Maturity Vocabulary (Normative)
Conformance rows and lane-repo consumable exports must distinguish:
1. `claim_confidence`:
   - `draft`: claim is stated and bounded but not yet closed by full evidence/program review.
   - `provisional`: claim is explicitly unresolved or conflicting.
   - `validated`: claim is evidence-closed and accepted for stable conformance targeting.
2. `assurance_maturity`:
   - `exercised`: behavior has implementation/testing evidence but not full Green-pack closure.
   - `green-validated`: required Green-owned pack closure is complete for the bounded claim/profile.

Program rule:
1. profile-green program claims require `green-validated` closure of required packs; `exercised` is insufficient.
2. lane repos consuming conformance rows must carry both fields, even when a row remains `draft`/`exercised`.

## 7. Function Set Baseline
1. Built-in worksheet function baseline count: `500` (from prior run catalog).
2. Tiered interesting-function model retained:
   - Tier 5 count: `5`
   - Tier 4 count: `43`
   - Tier 3 count: `23`
3. Full inventory and classification are referenced (not duplicated) from:
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_catalog_full.csv`
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_interest_index.csv`
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_tier_summary.csv`

## 8. Source-of-Truth Rule for Implementation
Implementation and test decisions shall be derived from `CONFORMANCE_REQUIREMENTS.csv`, with evidence resolved through `SOURCE_BINDINGS.csv`.

When conflict exists between spec-derived and empirical-derived evidence:
1. keep both references explicit,
2. mark requirement `provisional` where needed,
3. record follow-up in `KNOWN_GAPS_AND_UNCERTAINTIES.md`.

## 9. Immediate Next-Step Usage
1. Bind current implementation tasks to requirement ids (`XLS-CF-*`).
2. Bind empirical probe/test outputs to the same requirement ids.
3. Promote additional high-value empirical findings to `EMP-*` ids before adding new provisional rows.
4. Use pass-2 execution artifacts (`FORMULA_PARSE_PASS2_RESULTS.csv`, `SEED_TO_EXECUTED_MAPPING_PASS2.csv`) as current formula-language empirical baseline.
5. Treat function-definition artifacts under `../../../../OxFunc/docs/function-lane/` as preliminary and discussion-driven until interactive review resolves policy lanes.

## 10. Concrete-First Modeling Lane
The current modeling strategy is Excel-first:
1. Define detailed, concrete, nitpickable in-cell Excel behavior in `model/EXCEL_CELL_CONCRETE_MODEL.md`.
2. Keep unresolved details explicit in `model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`.
3. Track each concrete model statement with requirement and evidence binding in `model/EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`.
4. Extract generalized/abstract model candidates only after concrete rules are reviewed and tightened.
