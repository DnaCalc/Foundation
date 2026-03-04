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
13. Pass-2 execution outputs: `../../../research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/`.
14. Empirical registry: `../../empirical/findings_registry.jsonl`.
15. Prior authoritative source registry: `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/source_list.csv`.
16. Function-definition preliminary scope/spec: `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`.
17. Function-definition preliminary conformance lanes: `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`.
18. Function-definition discussion register: `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_DISCUSSION.md`.
19. Function-universe formalization charter: `../../../../OxFunc/CHARTER.md`.
20. Non-function closure empirical run outputs: `../../../research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/`.
21. Interesting-function initial classification table: `../../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.csv`.
22. Interesting-function initial classification summary: `../../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.md`.
23. XLL SDK registration/types digest: `functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`.

## 4. Evidence Lineage Model
1. `ECS-*`: source ids from prior authoritative Excel source registry.
2. `REFX-*`: mirrored Open Spec entries under `reference/index.*`.
3. `EMP-*`: curated empirical findings promoted from empirical run artifacts.

Each requirement row must cite one or more evidence ids from this model.

## 5. Conformance Status Semantics
1. `normative`: requirement is required for conformance implementation/test gates.
2. `provisional`: requirement captures unresolved or conflicting evidence and must remain explicit; it is not a sole-release gate without waiver.

## 6. Function Set Baseline
1. Built-in worksheet function baseline count: `500` (from prior run catalog).
2. Tiered interesting-function model retained:
   - Tier 5 count: `5`
   - Tier 4 count: `43`
   - Tier 3 count: `23`
3. Full inventory and classification are referenced (not duplicated) from:
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_catalog_full.csv`
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_interest_index.csv`
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_tier_summary.csv`

## 7. Source-of-Truth Rule for Implementation
Implementation and test decisions shall be derived from `CONFORMANCE_REQUIREMENTS.csv`, with evidence resolved through `SOURCE_BINDINGS.csv`.

When conflict exists between spec-derived and empirical-derived evidence:
1. keep both references explicit,
2. mark requirement `provisional` where needed,
3. record follow-up in `KNOWN_GAPS_AND_UNCERTAINTIES.md`.

## 8. Immediate Next-Step Usage
1. Bind current implementation tasks to requirement ids (`XLS-CF-*`).
2. Bind empirical probe/test outputs to the same requirement ids.
3. Promote additional high-value empirical findings to `EMP-*` ids before adding new provisional rows.
4. Use pass-2 execution artifacts (`FORMULA_PARSE_PASS2_RESULTS.csv`, `SEED_TO_EXECUTED_MAPPING_PASS2.csv`) as current formula-language empirical baseline.
5. Treat function-definition artifacts under `../../../../OxFunc/docs/function-lane/` as preliminary and discussion-driven until interactive review resolves policy lanes.

## 9. Concrete-First Modeling Lane
The current modeling strategy is Excel-first:
1. Define detailed, concrete, nitpickable in-cell Excel behavior in `model/EXCEL_CELL_CONCRETE_MODEL.md`.
2. Keep unresolved details explicit in `model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`.
3. Track each concrete model statement with requirement and evidence binding in `model/EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`.
4. Extract generalized/abstract model candidates only after concrete rules are reviewed and tightened.
