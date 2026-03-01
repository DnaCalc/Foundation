# Excel Compatibility Specification Index (Pass 01, Extended)

## Purpose
Create an exhaustive topic and source index for Excel compatibility work focused on worksheet-engine-visible behavior (formula language, built-ins, types, tables, formatting), emphasizing authoritative references and explicit known unknowns.

## Scope
- In scope:
  - Formula language syntax and sheet-level evaluation semantics.
  - Built-in worksheet functions (full inventory + tiered interesting-function triage).
  - Sheet-visible value types and type/coercion observation behavior.
  - ListObject/Table semantics (structured references, calculated columns, auto-expand behavior).
  - Cell formatting (high), conditional formatting (lower detail), merged-cell behavior.
- Out of scope:
  - Power Query/M and DAX/Power BI formula languages.
  - MDX language semantics (CUBE functions are in-scope; MDX internals are not).

## Current completeness snapshot
- Full deduplicated function catalog extracted: 500 functions.
- Tiered interesting-function index generated with 5 levels.
- CUBE function family fully listed and tagged as interesting with context/defer detail treatment.
- Tier-5 critical semantics pass completed (`INDIRECT`, `OFFSET`, `RTD`, `NOW`, `TODAY`).
- Coercion matrix seed pass completed with high-confidence anchors and explicit unknowns.
- Platform notes captured as union-first caveats, not a primary partitioning axis.

## 5-tier interest model
- Tier 5: critical-interest (highest compatibility risk concentration).
- Tier 4: high-interest (dynamic arrays, functional formula language, CUBE/external-data families).
- Tier 3: medium-interest (coercion/reference/meta/format-sensitive functions).
- Tier 2: baseline-context (non-pure but lower-risk context functions).
- Tier 1: regular-pure-or-low-risk.

## Core artifacts
- `outputs/function_catalog_full.csv`
- `outputs/function_tier_summary.csv`
- `outputs/function_interest_index.csv`
- `outputs/06_tier5_semantics_response.md`
- `outputs/coercion_matrix_seed.csv`
- `outputs/07_coercion_matrix_response.md`
- `outputs/source_list.csv`
- `outputs/coverage_matrix.csv`
- `outputs/platform_notes.md`
- `outputs/platform_probe_selected_functions.csv`

## Authoritative anchor families
- Function index anchors: alphabetical and category pages.
- Formula semantics: operator precedence, @ and # docs, dynamic-array docs, MS-XLSX ABNF grammar.
- Value model: TYPE/IS/N/VALUE/VALUETOTEXT + linked-data-type docs.
- Tables: structured references + calculated-column/auto-expand docs.
- Formatting: number format docs + conditional formatting docs + merge docs + limits page.
- Versioning: Compatibility Versions + channel/release notes.

## Known-and-documented unknowns
1. Full per-function edge-case matrix (coercion, error propagation, array lifting, locale/date-system interactions).
2. Definitive volatility map for all built-ins under all argument contexts.
3. Conditional-format overlap/precedence semantics at formal-spec depth.
4. Stable machine-readable per-function platform/channel/build availability matrix.
5. Deep behavioral semantics for non-tier-5 interesting functions (tier-4 then tier-3 backlog).

## Next-pass recommendations
1. Tier-4 family deep dives in this order: dynamic-array generators, LAMBDA helpers, CUBE family, external-data functions.
2. Coercion matrix expansion: operator-by-operator and function-family-by-family with locale variants.
3. Function-catalog hardening: periodic canonical-index recrawl and dated diff.
4. Conditional-format semantics pass from Open XML + observed behavior probes.

## Track A execution status update
Documentation/search execution follow-up has started and produced:
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

New machine-readable support artifacts:
- `function_reason_code_evidence_tracker.csv`
- `platform_availability_source_matrix_seed.csv`
- `tier45_function_evidence_dossier.csv`
- `formula_parse_corpus_registry.csv`
- `platform_availability_source_matrix_full_interest_seed.csv`
- `source_list.csv`/`source_digest.*` expanded with full tier-5/tier-4 function-specific source rows (`48/48` source-bound in dossier)
- `source_list.csv`/`source_digest.*` now include `ECS-061` (`ExcelFinancialFunctions` repository) as a prominent investigation resource

## Track A/B interleaving completion update
Empirical interleaving closure passes are now recorded through:
- `29_trackA_trackB_interleaving_reason_code_wave1.md`
- `30_trackA_trackB_interleaving_formula_parse_wave1.md`
- `31_trackA_trackB_interleaving_coercion_wave1.md`
- `32_trackA_trackB_interleaving_cf_wave1.md`
- `33_trackA_trackB_interleaving_table_wave1.md`
- `34_trackA_trackB_interleaving_tier45_wave1.md`
- `35_trackA_trackB_interleaving_crosscut_function_edge_and_refresh.md`
- `36_trackA_trackB_run_completion.md`
- `37_trackA_trackB_empirical_full_list_completion.md`

Result: planned interleaved batches are closed with retained mismatch/counter-signal triage made explicit as follow-on work, not unresolved scope holes.
