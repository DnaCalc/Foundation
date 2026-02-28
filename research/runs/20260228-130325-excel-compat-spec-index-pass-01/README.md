# Excel Compatibility Spec Index Research Run

- Run ID: 20260228-130325-excel-compat-spec-index-pass-01
- Status: captured (extended to completion)
- Scope: Excel worksheet formula language + built-in functions + sheet-visible value types + ListObject/Table semantics + formatting semantics
- Out of scope: Power Query/M, DAX/Power BI formula language, pre-Excel-2007 legacy history (except where needed to explain current behavior)

## Method
This run executes nine prompt passes:
1. Landscape and source coverage map.
2. Function inventory and initial interesting-function classification.
3. Blind-spot closure and final index structure pass.
4. Full function catalog extraction and 5-tier classification pass.
5. High-interest semantics extension pass (including CUBE family context).
6. Tier-5 critical-function semantics deepening pass.
7. Coercion-matrix seed pass.
8. Tier-4 family semantics pass.
9. Coercion matrix expansion pass.

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

## Notes
- Prioritizes Microsoft Support, Microsoft Learn, and Open Specifications as primary sources.
- Uses secondary/community sources only for triangulation and gap discovery.
- Tracks version/channel ambiguity as explicit known unknowns.
- Maintains union-across-platform posture with caveat tracking.