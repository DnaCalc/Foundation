# Excel Compatibility Research Master Guide

This document is the consolidated entry point for this research project.

## Primary outputs
- `research_index.md` (project overview and known unknowns)
- `source_list.csv` and `source_digest.md` (authoritative-first source map)
- `function_catalog_full.csv` (full built-in inventory)
- `function_interest_index.csv` + `function_tier_summary.csv` (interesting-function triage)
- `06_tier5_semantics_response.md` and `08_tier4_family_semantics_response.md` (high-priority semantics)
- `coercion_matrix_seed.csv` and `coercion_matrix_expanded.csv` (value/coercion seeds)
- `10_formula_language_guide.md`
- `11_function_catalog_guide.md`
- `12_value_types_guide.md`
- `13_table_semantics_guide.md`
- `14_formatting_guide.md`
- `15_version_platform_guide.md`
- `16_scope_completion_audit.md`
- `17_follow_up_execution_backlog.md` (structured next-phase execution list and empirical validation plan)
- `18_trackA_doc_search_execution_pass.md`
- `19_formula_language_formal_mapping_dossier.md`
- `20_reason_code_dictionary_and_coverage.md`
- `21_conditional_format_semantics_model_scaffold.md`
- `22_platform_availability_doc_pipeline.md`
- `23_excel_financial_functions_watch_note.md`
- `24_tier45_function_evidence_binding_expansion.md`
- `25_formula_parse_corpus_registry_seed.md`
- `26_full_interest_platform_matrix_seed_expansion.md`
- `27_trackA_continuation_execution_pass.md`
- `28_tier45_source_index_completion_pass.md`
- `function_reason_code_evidence_tracker.csv`
- `platform_availability_source_matrix_seed.csv`
- `tier45_function_evidence_dossier.csv`
- `formula_parse_corpus_registry.csv`
- `platform_availability_source_matrix_full_interest_seed.csv`

## What is complete
- Full scope indexing and authoritative source mapping.
- Exhaustive built-in function catalog extraction for worksheet engine scope.
- 5-tier interesting-function classification with CUBE functions explicitly included.
- Priority semantics passes for critical and high-interest families.

## What remains intentionally open
- Deep per-function edge-case extraction across all 500 functions.
- Full coercion truth-table completeness in every context and locale.
- Empirical test corpus generation and minimization fixtures.

These are now documented as intentional next-depth tasks rather than blind spots.

## Current follow-up state
- Track A (documentation/search execution): progressed through passes 18-28, including continuation closure for the remaining items listed in pass 18 and tier-5/4 source-index completion.
- Track B (empirical execution): active in `../../20260228-180047-excel-compat-empirical-pass-01/`, with runner baseline complete and pilot evidence started.
