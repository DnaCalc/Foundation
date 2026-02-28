# Excel Compatibility Spec Index Research Run

- Run ID: 20260228-130325-excel-compat-spec-index-pass-01
- Status: captured (extended; Track A continuation passes added)
- Scope: Excel worksheet formula language + built-in functions + sheet-visible value types + ListObject/Table semantics + formatting semantics
- Out of scope: Power Query/M, DAX/Power BI formula language, pre-Excel-2007 legacy history (except where needed to explain current behavior)

## Method
This run executes nine prompt passes plus Track A documentation/search execution extensions:
1. Landscape and source coverage map.
2. Function inventory and initial interesting-function classification.
3. Blind-spot closure and final index structure pass.
4. Full function catalog extraction and 5-tier classification pass.
5. High-interest semantics extension pass (including CUBE family context).
6. Tier-5 critical-function semantics deepening pass.
7. Coercion-matrix seed pass.
8. Tier-4 family semantics pass.
9. Coercion matrix expansion pass.
10. Track A execution pass (passes 18-23) for backlog-linked documentation/search scaffolding and external implementation watchlisting.
11. Track A continuation pass (passes 24-28) to close remaining doc/search items from pass 18 and complete tier-5/4 source indexing.

## Primary outputs
- `outputs/research_index.md`
- `outputs/source_list.csv`
- `outputs/source_digest.csv`
- `outputs/source_digest.md`
- `outputs/source_summaries_full.md`
- `outputs/function_catalog_full.csv`
- `outputs/function_interest_index.csv`
- `outputs/function_tier_summary.csv`
- `outputs/coercion_matrix_seed.csv`
- `outputs/coercion_matrix_expanded.csv`
- `outputs/platform_notes.md`
- `outputs/platform_probe_selected_functions.csv`
- `outputs/EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md`

## Domain guides
- `outputs/10_formula_language_guide.md`
- `outputs/11_function_catalog_guide.md`
- `outputs/12_value_types_guide.md`
- `outputs/13_table_semantics_guide.md`
- `outputs/14_formatting_guide.md`
- `outputs/15_version_platform_guide.md`
- `outputs/16_scope_completion_audit.md`
- `outputs/17_follow_up_execution_backlog.md`
- `outputs/18_trackA_doc_search_execution_pass.md`
- `outputs/19_formula_language_formal_mapping_dossier.md`
- `outputs/20_reason_code_dictionary_and_coverage.md`
- `outputs/21_conditional_format_semantics_model_scaffold.md`
- `outputs/22_platform_availability_doc_pipeline.md`
- `outputs/23_excel_financial_functions_watch_note.md`
- `outputs/24_tier45_function_evidence_binding_expansion.md`
- `outputs/25_formula_parse_corpus_registry_seed.md`
- `outputs/26_full_interest_platform_matrix_seed_expansion.md`
- `outputs/27_trackA_continuation_execution_pass.md`
- `outputs/28_tier45_source_index_completion_pass.md`
- `outputs/function_reason_code_evidence_tracker.csv`
- `outputs/platform_availability_source_matrix_seed.csv`
- `outputs/tier45_function_evidence_dossier.csv`
- `outputs/formula_parse_corpus_registry.csv`
- `outputs/platform_availability_source_matrix_full_interest_seed.csv`

## Notes
- Prioritizes Microsoft Support, Microsoft Learn, and Open Specifications as primary sources.
- Uses secondary/community sources only for triangulation and gap discovery.
- Tracks version/channel ambiguity as explicit known unknowns.
- Maintains union-across-platform posture with caveat tracking.
- Follow-on empirical planning and task decomposition is tracked in `../20260228-180047-excel-compat-empirical-pass-01/`.
