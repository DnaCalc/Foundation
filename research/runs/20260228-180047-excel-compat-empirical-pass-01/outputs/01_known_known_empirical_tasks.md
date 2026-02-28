# Known-Known Empirical Tasks

## Intent
This catalog defines empirical tasks for topic areas already documented as covered in the parent run.
It explicitly excludes depth-expansion and unresolved work already tracked in `17_follow_up_execution_backlog.md`.

## Systematic source sweep (parent outputs -> known-known extraction)
| Parent output artifact | Known-known content extracted for empirical confirmation |
|---|---|
| `01_landscape_response.md` | Domain map and baseline coverage confidence for formula/functions/types/tables/formatting/versioning |
| `02_functions_response.md` | Canonical index anchors and initial "interesting" family framing |
| `03_gap_closure_response.md` | Final index structure for in-scope topics |
| `04_catalog_extraction_response.md` | 500-function inventory and tier counts |
| `05_interesting_semantics_response.md` | Family-level semantic framing for high-interest clusters |
| `06_tier5_semantics_response.md` | Baseline documented semantics for 5 critical functions |
| `07_coercion_matrix_response.md` | High-confidence coercion anchors |
| `08_tier4_family_semantics_response.md` | Tier-4 family decomposition and representative functions |
| `09_coercion_matrix_expansion_response.md` | Expanded coercion contexts and confidence posture |
| `10_formula_language_guide.md` | Covered formula syntax and compatibility focus areas |
| `11_function_catalog_guide.md` | Catalog status and highlighted families |
| `12_value_types_guide.md` | Covered type/coercion scope and date-system linkage |
| `13_table_semantics_guide.md` | Covered table semantics and included context |
| `14_formatting_guide.md` | Covered formatting scope and priority posture |
| `15_version_platform_guide.md` | Versioning/platform posture and artifacts |
| `16_scope_completion_audit.md` | Scope-completion baseline confirmation |
| `research_index.md` | Current completeness snapshot and anchor families |
| `source_digest.md`, `source_list.csv`, `source_digest.csv`, `source_summaries_full.md` | Source traceability and authority tiers |
| `coverage_matrix.csv` | Coverage tagging across scoped domains |
| `function_catalog_full.csv`, `function_interest_index.csv`, `function_tier_summary.csv` | Full function target set and tier slicing |
| `coercion_matrix_seed.csv`, `coercion_matrix_expanded.csv` | Empirical target matrix seed for known-high-confidence rows |
| `platform_notes.md`, `platform_probe_selected_functions.csv` | Platform caveats and initial selected probes |

## Task list
Status defaults to `planned`.

| Task ID | Domain | Empirical question to answer | Probe method | Expected artifact(s) | Parent refs |
|---|---|---|---|---|---|
| ECS-EK-001 | Formula | Do arithmetic/comparison/text operator precedence outcomes match documented precedence order? | Run fixed formula precedence workbook and capture results | precedence_probe_results.json | `10_formula_language_guide.md`, `01_landscape_response.md` |
| ECS-EK-002 | Formula | Do range (`:`), union (`,`), and intersection (space) reference operators evaluate as documented on simple and mixed ranges? | Generate range-operator scenario sheet with expected scalar checks | reference_operator_matrix.json | `10_formula_language_guide.md` |
| ECS-EK-003 | Formula | Are A1 references resolved correctly for absolute/relative/mixed addressing under copy/fill operations? | Apply formula copy/fill transformations and compare rewritten formulas/results | a1_rewrite_observations.json | `10_formula_language_guide.md` |
| ECS-EK-004 | Formula | Are R1C1 references accepted and evaluated consistently in conversion and direct-entry scenarios? | Use R1C1 mode workbook probes with A1 conversion checks | r1c1_roundtrip_probe.json | `10_formula_language_guide.md` |
| ECS-EK-005 | Formula | Do workbook- and sheet-scoped names resolve to documented targets under direct and indirect usage? | Create scoped names and evaluate from multiple sheets | name_resolution_probe.json | `10_formula_language_guide.md`, `03_gap_closure_response.md` |
| ECS-EK-006 | Formula | Do external reference formulas behave as documented when source workbook is open versus closed (baseline cases only)? | Two-workbook automation sequence with reopen and recalc | external_ref_baseline_probe.json | `10_formula_language_guide.md` |
| ECS-EK-007 | Formula | Does implicit intersection operator `@` produce expected scalarization in legacy-style and explicit formulas? | Structured test sheet with array-return formulas plus `@` variants | implicit_intersection_probe.json | `10_formula_language_guide.md` |
| ECS-EK-008 | Formula | Does spilled-range operator `#` resolve to dynamic spill extents in baseline scenarios? | Use dynamic-array producers and `#` consumers | spilled_range_reference_probe.json | `10_formula_language_guide.md` |
| ECS-EK-009 | Formula | Are blocked-spill baseline conditions (`#SPILL!`) reproducible and diagnosable in documented cases? | Introduce blockers (values/merged cells) and capture errors | spill_block_baseline_probe.json | `10_formula_language_guide.md`, `08_tier4_family_semantics_response.md` |
| ECS-EK-010 | Formula | Are structured-reference formula forms accepted and normalized in baseline table scenarios? | Parse/evaluate representative structured-ref syntax set | structured_ref_parse_probe.json | `10_formula_language_guide.md`, `13_table_semantics_guide.md` |
| ECS-EK-011 | Function catalog | Are all 500 cataloged functions parse-recognized in the current target Excel build(s)? | Automated formula parse smoke over `function_catalog_full.csv` | function_recognition_matrix.csv | `04_catalog_extraction_response.md`, `11_function_catalog_guide.md` |
| ECS-EK-012 | Function catalog | Do tier-1 math/stat sample functions return baseline documented outputs for canonical fixtures? | Evaluate canonical numeric fixtures | tier1_math_stat_smoke.json | `11_function_catalog_guide.md` |
| ECS-EK-013 | Function catalog | Do tier-1 text/logical sample functions return baseline outputs and error behavior? | Evaluate text/logical fixtures with expected outputs | tier1_text_logical_smoke.json | `11_function_catalog_guide.md` |
| ECS-EK-014 | Function catalog | Do representative lookup/reference baseline functions (`INDEX`, `MATCH`, `XLOOKUP`, `XMATCH`, `VLOOKUP`) match expected nominal results? | Use common lookup fixture matrix | lookup_baseline_probe.json | `02_functions_response.md`, `11_function_catalog_guide.md` |
| ECS-EK-015 | Function catalog | Do baseline aggregate functions over ranges and arrays match expected nominal behavior? | Use fixed numeric tables and aggregate formulas | aggregate_baseline_probe.json | `11_function_catalog_guide.md` |
| ECS-EK-016 | Function catalog | Do representative error-handling functions (`IFERROR`, `IFNA`, `ERROR.TYPE`) behave as expected for canonical errors? | Inject controlled errors and evaluate wrappers | error_handling_baseline_probe.json | `11_function_catalog_guide.md` |
| ECS-EK-017 | Dynamic arrays | Do `SEQUENCE`, `RANDARRAY`, `FILTER`, `SORT`, `UNIQUE` produce expected shape/result in simple documented cases? | Run dynamic-array baseline scenarios | dynamic_array_baseline_probe.json | `08_tier4_family_semantics_response.md`, `05_interesting_semantics_response.md` |
| ECS-EK-018 | Dynamic arrays | Do stack/reshape functions (`HSTACK`, `VSTACK`, `TOCOL`, `TOROW`, `WRAPROWS`, `WRAPCOLS`) match basic shape expectations? | Shape-check fixture workbook | dynamic_shape_probe.json | `08_tier4_family_semantics_response.md` |
| ECS-EK-019 | Lambda family | Do `LET` and `LAMBDA` basic binding/invocation scenarios match nominal worksheet behavior? | Lambda baseline fixture pack | lambda_let_baseline_probe.json | `08_tier4_family_semantics_response.md`, `05_interesting_semantics_response.md` |
| ECS-EK-020 | Lambda helpers | Do `MAP`, `BYROW`, `BYCOL`, `REDUCE`, `SCAN`, `MAKEARRAY`, `ISOMITTED` pass nominal helper scenarios? | Helper combinator baseline probes | lambda_helper_baseline_probe.json | `08_tier4_family_semantics_response.md` |
| ECS-EK-021 | External functions | Do `WEBSERVICE`, `FILTERXML`, `ENCODEURL`, `STOCKHISTORY` baseline invocations reflect documented availability/behavior gating? | Capability-aware external function smoke probes | external_function_baseline_probe.json | `08_tier4_family_semantics_response.md`, `15_version_platform_guide.md` |
| ECS-EK-022 | CUBE family | Are CUBE family functions recognized and behaviorally gated by cube-context prerequisites as expected? | Run cube-context availability and minimal invocation probes | cube_context_baseline_probe.json | `11_function_catalog_guide.md`, `08_tier4_family_semantics_response.md` |
| ECS-EK-023 | Volatile baseline | Do baseline volatile examples (`NOW`, `TODAY`, `RAND`, `RANDBETWEEN`) refresh on recalc events as expected? | Controlled recalc cycle script | volatile_baseline_probe.json | `06_tier5_semantics_response.md`, `01_landscape_response.md` |
| ECS-EK-024 | Value types | Does `TYPE` return documented codes for number/text/logical/error/array/compound baseline fixtures? | Type-code fixture workbook | type_code_baseline_probe.json | `12_value_types_guide.md`, `07_coercion_matrix_response.md` |
| ECS-EK-025 | Value types | Does `N` match documented conversion table for canonical inputs? | Execute documented `N` conversion cases | n_conversion_baseline_probe.json | `12_value_types_guide.md`, `07_coercion_matrix_response.md` |
| ECS-EK-026 | Value types | Does `VALUE` convert canonical numeric text and fail as expected for invalid text? | Locale-tagged `VALUE` baseline pack | value_conversion_baseline_probe.json | `12_value_types_guide.md`, `07_coercion_matrix_response.md` |
| ECS-EK-027 | Value types | Does `VALUETOTEXT` baseline formatting mode behavior match documented expectations? | Evaluate `VALUETOTEXT` canonical cases | valuetotext_baseline_probe.json | `12_value_types_guide.md` |
| ECS-EK-028 | Value types | Do `IS*` classifiers (`ISNUMBER`, `ISTEXT`, `ISLOGICAL`, etc.) align with baseline fixtures? | Run classifier matrix over typed fixtures | is_family_baseline_probe.json | `12_value_types_guide.md` |
| ECS-EK-029 | Value types | Does date-system offset behavior (1900 vs 1904) match documented 1462-day delta in baseline scenarios? | Toggle workbook date system and compare serial outcomes | date_system_baseline_probe.json | `12_value_types_guide.md`, `06_tier5_semantics_response.md` |
| ECS-EK-030 | Value types | Are array constants and spilled arrays typed/handled consistently in baseline `TYPE` and `N` probes? | Array-focused type/coercion fixture pack | array_type_baseline_probe.json | `07_coercion_matrix_response.md`, `09_coercion_matrix_expansion_response.md` |
| ECS-EK-031 | Tables | Does table creation and structured reference insertion produce expected baseline formulas/results? | Create tables from ranges and inject structured refs | table_creation_baseline_probe.json | `13_table_semantics_guide.md` |
| ECS-EK-032 | Tables | Do calculated columns auto-fill formulas across existing rows as expected? | Insert formula in one table row and observe propagation | calculated_column_autofill_probe.json | `13_table_semantics_guide.md` |
| ECS-EK-033 | Tables | Does row append trigger documented auto-expand and formula continuation behavior? | Append rows via UI-equivalent operations | table_autoexpand_baseline_probe.json | `13_table_semantics_guide.md` |
| ECS-EK-034 | Tables | Does table column rename rewrite dependent structured references in baseline cases? | Rename columns and compare formula rewrites | table_rename_rewrite_probe.json | `13_table_semantics_guide.md` |
| ECS-EK-035 | Tables | Do total-row baseline aggregate behaviors and references match expected results? | Toggle total row and evaluate formula outputs | table_total_row_baseline_probe.json | `13_table_semantics_guide.md` |
| ECS-EK-036 | Tables | Does table-to-range conversion preserve expected resulting values/formulas in baseline scenarios? | Convert table to range and observe formula transitions | table_to_range_baseline_probe.json | `13_table_semantics_guide.md` |
| ECS-EK-037 | Formatting | Do built-in number format categories produce expected rendered display for canonical values? | Apply category formats to fixture values and capture display text | number_format_category_probe.json | `14_formatting_guide.md` |
| ECS-EK-038 | Formatting | Do custom number format section rules (positive/negative/zero/text) behave in baseline cases? | Apply custom format code fixture matrix | custom_format_section_probe.json | `14_formatting_guide.md` |
| ECS-EK-039 | Formatting | Do date/time format tokens display expected baseline outputs for known serial values? | Serial-date formatting fixture workbook | datetime_format_baseline_probe.json | `14_formatting_guide.md`, `12_value_types_guide.md` |
| ECS-EK-040 | Formatting | Do merge/unmerge operations enforce documented baseline constraints and preserve values as expected? | Merge/unmerge scenario sheet with references and spills | merge_unmerge_baseline_probe.json | `14_formatting_guide.md`, `01_landscape_response.md` |
| ECS-EK-041 | Formatting | Does single-rule conditional formatting apply as expected in straightforward value-threshold scenarios? | Baseline CF single-rule fixture | cf_single_rule_baseline_probe.json | `14_formatting_guide.md` |
| ECS-EK-042 | Formatting | Does simple CF rule priority reorder (non-overlap and light overlap) reflect expected UI-visible outcomes? | Rule-manager reorder baseline script | cf_priority_baseline_probe.json | `14_formatting_guide.md` |
| ECS-EK-043 | Version/platform | Can function-page "Applies To" metadata for selected functions be captured and normalized repeatably? | Parse selected pages into structured metadata rows | applies_to_capture_probe.csv | `15_version_platform_guide.md`, `platform_probe_selected_functions.csv` |
| ECS-EK-044 | Version/platform | Is workbook compatibility-version state detectable and serializable in baseline workbook fixtures? | Read/write compatibility-related workbook settings and capture | compatibility_state_probe.json | `15_version_platform_guide.md`, `03_gap_closure_response.md` |
| ECS-EK-045 | Version/platform | Do selected newer functions (`GROUPBY`, `PIVOTBY`, `TRIMRANGE`) show expected availability in current probe environments? | Execute selected function availability probe pack | new_function_availability_probe.csv | `15_version_platform_guide.md`, `08_tier4_family_semantics_response.md` |
| ECS-EK-046 | Version/platform | For externally dependent functions, can baseline parity/caveat status be captured consistently across available platforms? | Capability matrix probe for RTD/CUBE/WEBSERVICE/STOCKHISTORY | external_dependency_platform_probe.csv | `15_version_platform_guide.md`, `platform_notes.md` |
| ECS-EK-047 | Evidence | Does canonical source recrawl detect and log material drift in function index and key docs? | Re-fetch source anchors and diff normalized snapshots | source_drift_report.md | `source_list.csv`, `source_digest.csv` |
| ECS-EK-048 | Evidence | Can every known-known probe produce complete evidence bundles under the contract (manifest/raw/normalized/rerun)? | Dry-run bundle validation on sample tasks across domains | evidence_contract_validation_report.md | `16_scope_completion_audit.md`, `EMPIRICAL_TASK_INDEX.md` |

## Coverage assertion
This task list covers currently documented known-known areas across all in-scope domains:
- formula language,
- function inventory and baseline behavior,
- visible value types/coercion anchors,
- table/listobject baseline behavior,
- formatting baseline behavior,
- version/platform baseline capture,
- evidence integrity for repeatable empirical work.
