# Pass 1 - Inventory to Reference Mapping

## Objective
Systematically walk prior Excel compatibility run artifacts and bind retained facts/assertions to conformance requirements with traceable source ids.

Target conformance area:
- `reference/conformance/excel-worksheet-engine/`

## Mapping Legend
- Capture status:
  - `captured`: represented by one or more `XLS-CF-*` requirement rows.
  - `captured_provisional`: represented by provisional rows with explicit unresolved/counter-signal handling.
  - `index_only`: retained as source/index support, no direct requirement row needed.

## Artifact Mapping
| prior artifact | artifact role | evidence class used | conformance capture | capture status | notes |
| --- | --- | --- | --- | --- | --- |
| `01_landscape_response.md` | initial scope framing | `ECS-*` | domain coverage across all `XLS-CF-*` groups | captured | scope represented in requirement corpus |
| `02_functions_response.md` | function inventory baseline | `ECS-001`,`ECS-002` | `XLS-CF-FN-001`,`XLS-CF-FN-002` | captured | function universe + tier model |
| `03_gap_closure_response.md` | gap closure framing | `ECS-*` + empirical | `XLS-CF-EV-003`,`XLS-CF-EV-004` | captured | conflict/provisional doctrine rows |
| `04_catalog_extraction_response.md` | exhaustive catalog extraction | `ECS-001`,`ECS-002` | `XLS-CF-FN-001` | captured | linked via function catalog baseline |
| `05_interesting_semantics_response.md` | interesting semantics focus | `ECS-*` | `XLS-CF-FN-003..008` | captured | tier4/5 semantics coverage |
| `06_tier5_semantics_response.md` | critical functions deepening | `ECS-039`,`040`,`057`,`058`,`059` | `XLS-CF-FN-003` | captured | tier-5 required lane |
| `07_coercion_matrix_response.md` | coercion baseline | `ECS-003`,`018`,`019` | `XLS-CF-TV-007` | captured | operator/function coercion lanes |
| `08_tier4_family_semantics_response.md` | tier4 function families | `ECS-041`,`042`,`049`,`053`,`054`,`055`,`056` | `XLS-CF-FN-004..007` | captured | modern function families represented |
| `09_coercion_matrix_expansion_response.md` | expanded coercion detail | `ECS-*` + empirical | `XLS-CF-TV-007..009` | captured | includes ambiguity lanes |
| `10_formula_language_guide.md` | formula-language synthesis | `ECS-003..009`,`010`,`011`,`012` | `XLS-CF-FL-001..009` | captured | core formula requirements |
| `11_function_catalog_guide.md` | function-domain synthesis | `ECS-001`,`002` + tier sources | `XLS-CF-FN-001..008` | captured | full function set + prioritization |
| `12_value_types_guide.md` | value/coercion synthesis | `ECS-017..021`,`024`,`025`,`060` | `XLS-CF-TV-001..006` | captured | type/conversion/date-system requirements |
| `13_table_semantics_guide.md` | table/listobject synthesis | `ECS-012`,`013`,`014` | `XLS-CF-TB-001..005` | captured | table semantics baseline |
| `14_formatting_guide.md` | formatting synthesis | `ECS-026..031`,`033` | `XLS-CF-FM-001..006` | captured | formatting + CF + limits |
| `15_version_platform_guide.md` | version/platform synthesis | `ECS-034`,`035`,`036` | `XLS-CF-VP-001..005` | captured | channel/platform/provenance lanes |
| `16_scope_completion_audit.md` | closure assertion | run-level evidence | `EXCEL_CONFORMANCE_SPEC.md` sections 2/7 | captured | closure rationale embedded |
| `17_follow_up_execution_backlog.md` | deferred execution list | empirical tracks | `KNOWN_GAPS_AND_UNCERTAINTIES.md` | captured_provisional | unresolved items promoted explicitly |
| `18_trackA_doc_search_execution_pass.md` | doc-search execution | `ECS-*` | source binding registry rows | captured | source coverage retained |
| `19_formula_language_formal_mapping_dossier.md` | formula formal mapping | `ECS-008`,`009` | `XLS-CF-FL-006`,`007` | captured | ABNF + cell-form constraints |
| `20_reason_code_dictionary_and_coverage.md` | reason-code framework | empirical + calc sources | `XLS-CF-FN-008`,`009` | captured_provisional | SUMIF mixed signal preserved |
| `21_conditional_format_semantics_model_scaffold.md` | CF model scaffold | `ECS-028`,`029`,`030` + empirical | `XLS-CF-FM-004`,`005` | captured_provisional | spill mismatch retained |
| `22_platform_availability_doc_pipeline.md` | platform availability method | `ECS-035`,`036` + empirical metadata | `XLS-CF-VP-002`,`003`,`004`,`005` | captured | platform and drift lanes |
| `23_excel_financial_functions_watch_note.md` | external implementation watch | `ECS-061` | `XLS-CF-FN-001` notes + follow-up | index_only | watch item retained, not normative requirement |
| `24_tier45_function_evidence_binding_expansion.md` | tier4/5 source binding | `ECS-*` function pages | `XLS-CF-FN-003..008` | captured | evidence links represented |
| `25_formula_parse_corpus_registry_seed.md` | parser corpus seed | empirical | `XLS-CF-FL-010`,`011` | captured_provisional | ambiguity probes promoted |
| `26_full_interest_platform_matrix_seed_expansion.md` | platform matrix seed | `ECS-*` + empirical | `XLS-CF-VP-002`,`003` | captured | availability strategy captured |
| `27_trackA_continuation_execution_pass.md` | continuation closure | source/index | source binding completion | captured | no standalone requirement row |
| `28_tier45_source_index_completion_pass.md` | source completion pass | `ECS-*` | `SOURCE_BINDINGS.csv` | captured | tier4/5 source references centralized |
| `29_trackA_trackB_interleaving_reason_code_wave1.md` | reason-code wave integration | empirical | `XLS-CF-FN-009` | captured_provisional | SUMIF mixed-signal lane |
| `30_trackA_trackB_interleaving_formula_parse_wave1.md` | formula-parse wave integration | empirical | `XLS-CF-FL-010`,`011` | captured_provisional | parser ambiguity lanes |
| `31_trackA_trackB_interleaving_coercion_wave1.md` | coercion wave integration | empirical | `XLS-CF-TV-008` | captured_provisional | aggregate coercion counter-signal |
| `32_trackA_trackB_interleaving_cf_wave1.md` | CF wave integration | empirical | `XLS-CF-FM-005` | captured_provisional | CF spill mismatch lane |
| `33_trackA_trackB_interleaving_table_wave1.md` | table wave integration | empirical | `XLS-CF-TB-004` | captured_provisional | table spill mismatch lane |
| `34_trackA_trackB_interleaving_tier45_wave1.md` | tier4/5 wave integration | empirical | `XLS-CF-FN-011` | captured_provisional | mixed-type dynamic array counter-signals |
| `35_trackA_trackB_interleaving_crosscut_function_edge_and_refresh.md` | refresh/drift crosscut | empirical + version docs | `XLS-CF-VP-005` | captured | drift cadence requirement |
| `36_trackA_trackB_run_completion.md` | completion closure | run evidence | `EXCEL_CONFORMANCE_SPEC.md` section 7 | captured | closure status captured |
| `37_trackA_trackB_empirical_full_list_completion.md` | empirical full-list closure | run evidence | `KNOWN_GAPS_AND_UNCERTAINTIES.md` | captured | explicit unresolved lanes only |
| `research_index.md` | project index | mixed | conformance scope + docs index | captured | this pass derives from same scope |
| `EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md` | canonical output index | mixed | pass1 inventory mapping | captured | input authority for this pass |
| `source_list.csv` | source registry | `ECS-*` | `SOURCE_BINDINGS.csv` | captured | upstream source ids preserved |
| `source_digest.csv` | source digest data | `ECS-*` | source bindings and req references | captured | summarized in source bindings |
| `source_digest.md` | human source digest | `ECS-*` | source bindings and req references | captured | used for curated source selection |
| `source_summaries_full.md` | source summary detail | `ECS-*` | source bindings and requirement notes | captured | large detail retained by pointer |
| `function_catalog_full.csv` | 500-function corpus | `ECS-001`,`002` | `XLS-CF-FN-001` + spec section 6 | captured | referenced, not duplicated |
| `function_interest_index.csv` | tier mapping | `ECS-*` | `XLS-CF-FN-002` + spec section 6 | captured | referenced, not duplicated |
| `function_tier_summary.csv` | tier counts | derived | spec section 6 | captured | counts embedded in conformance spec |
| `coercion_matrix_seed.csv` | coercion seed | `ECS-*` | `XLS-CF-TV-007` | captured | baseline matrix lane |
| `coercion_matrix_expanded.csv` | expanded coercion matrix | mixed + empirical | `XLS-CF-TV-007..009` | captured | expansion lane retained |
| `coverage_matrix.csv` | coverage accounting | run metadata | pass2 completeness audit | captured | used as audit input |
| `platform_notes.md` | platform caveats | `ECS-035`,`036` | `XLS-CF-VP-002`,`003` | captured | caveat posture retained |
| `platform_probe_selected_functions.csv` | platform probe seed | mixed | `XLS-CF-VP-003` | captured | availability-lane seed |
| `function_reason_code_evidence_tracker.csv` | reason-code evidence matrix | empirical | `XLS-CF-FN-008`,`009` | captured | includes mixed-signal lanes |
| `platform_availability_source_matrix_seed.csv` | availability source seed | `ECS-*` | `XLS-CF-VP-003` | captured | pipeline input retained |
| `tier45_function_evidence_dossier.csv` | tier4/5 evidence matrix | `ECS-*` + empirical | `XLS-CF-FN-003..011` | captured | high-interest evidence lane |
| `formula_parse_corpus_registry.csv` | parse corpus registry | empirical | `XLS-CF-FL-010`,`011` | captured_provisional | ambiguity lanes explicitly linked |
| `platform_availability_source_matrix_full_interest_seed.csv` | expanded availability source matrix | `ECS-*` | `XLS-CF-VP-003` | captured | full-interest source seed retained |

## Pass 1 Result
1. Prior run artifact set is fully mapped into:
   - requirement rows (`CONFORMANCE_REQUIREMENTS.csv`),
   - source/evidence registry (`SOURCE_BINDINGS.csv`),
   - provisional gap register (`KNOWN_GAPS_AND_UNCERTAINTIES.md`).
2. No previously listed artifact was dropped without explicit capture class.
