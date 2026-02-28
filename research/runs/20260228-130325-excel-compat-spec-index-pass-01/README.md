# Excel Compatibility Spec Index Research Run

- Run ID: 20260228-130325-excel-compat-spec-index-pass-01
- Status: captured (extended)
- Scope: Excel worksheet formula language + built-in functions + sheet-visible value types + ListObject/Table semantics + formatting semantics
- Out of scope: Power Query/M, DAX/Power BI formula language, pre-Excel-2007 legacy history (except where needed to explain current behavior)

## Method
This run executes seven prompt passes:
1. Landscape and source coverage map.
2. Function inventory and initial interesting-function classification.
3. Blind-spot closure and final index structure pass.
4. Full function catalog extraction and 5-tier classification pass.
5. High-interest semantics extension pass (including CUBE family context).
6. Tier-5 critical-function semantics deepening pass.
7. Coercion-matrix seed pass.

## Outputs
- `outputs/01_landscape_response.md`
- `outputs/02_functions_response.md`
- `outputs/03_gap_closure_response.md`
- `outputs/04_catalog_extraction_response.md`
- `outputs/05_interesting_semantics_response.md`
- `outputs/06_tier5_semantics_response.md`
- `outputs/07_coercion_matrix_response.md`
- `outputs/research_index.md`
- `outputs/coverage_matrix.csv`
- `outputs/source_list.csv`
- `outputs/function_catalog_raw.csv`
- `outputs/function_catalog_full.csv`
- `outputs/function_tier_summary.csv`
- `outputs/function_interest_index.csv`
- `outputs/coercion_matrix_seed.csv`
- `outputs/platform_notes.md`
- `outputs/platform_probe_selected_functions.csv`

## Notes
- Prioritizes Microsoft Support, Microsoft Learn, and Open Specifications as primary sources.
- Uses secondary/community sources only for triangulation and gap discovery.
- Tracks version/channel ambiguity as explicit known unknowns.
- Maintains union-across-platform posture with caveat tracking.