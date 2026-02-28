# Source Digest (Authoritative-First)

## api_guide
- ECS-050 [Data types used by Excel](https://learn.microsoft.com/en-us/office/client-developer/excel/data-types-used-by-excel) [official_ms_learn] tags: xloper12|bridge_reference
  - relevance: Guide-only bridge not worksheet semantics spec

## calc
- ECS-037 [Excel Recalculation](https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation) [official_ms_learn] tags: volatile_functions|calc_behavior
  - relevance: Volatile function and recalc behavior anchor
- ECS-038 [Excel performance tips for optimizing performance obstructions](https://learn.microsoft.com/en-us/office/vba/excel/concepts/excel-performance/excel-tips-for-optimizing-performance-obstructions) [official_ms_learn] tags: perf_guidance|volatile_risk
  - relevance: Includes indirect and volatile risk guidance

## dates
- ECS-060 [Date systems in Excel](https://support.microsoft.com/en-us/office/date-systems-in-excel-e7fe7167-48a9-4b96-bb53-5612a800b487) [official_ms_support] tags: date_system|serial_model
  - relevance: Coercion/date-serial context anchor

## formatting
- ECS-026 [Review guidelines for customizing a number format](https://support.microsoft.com/en-us/office/review-guidelines-for-customizing-a-number-format-c0a1d1fa-d3f4-4018-96b7-9c9354dd99f5) [official_ms_support] tags: number_format_grammar
  - relevance: Number format grammar anchor
- ECS-027 [Create a custom number format](https://support.microsoft.com/en-us/office/create-a-custom-number-format-78f2a361-936b-4c03-8772-09fab54be7f4) [official_ms_support] tags: number_format_practice
  - relevance: Custom format practice and examples
- ECS-028 [Use conditional formatting to highlight information](https://support.microsoft.com/en-us/office/use-conditional-formatting-to-highlight-information-fed60dfa-1d3f-4e13-9ecb-f1951ff89d7f) [official_ms_support] tags: conditional_formatting_user_model
  - relevance: Primary conditional formatting guidance
- ECS-029 [Create conditional formulas](https://support.microsoft.com/en-us/office/create-conditional-formulas-ca916c57-abd8-4b44-997c-c309b7307831) [official_ms_support] tags: conditional_formula_rules
  - relevance: Formula-based CF rules
- ECS-030 [Working with conditional formatting Open XML](https://learn.microsoft.com/en-us/office/open-xml/spreadsheet/working-with-conditional-formatting) [official_ms_learn_openxml] tags: conditional_formatting_ooxml
  - relevance: Schema-level conditional formatting reference
- ECS-031 [Merge and unmerge cells in Excel](https://support.microsoft.com/en-us/office/merge-and-unmerge-cells-in-excel-5cbd15d5-9375-4540-907f-c673a93fcedf) [official_ms_support] tags: merge_cells_behavior
  - relevance: Merge behavior guidance
- ECS-032 [Find merged cells](https://support.microsoft.com/en-us/office/find-merged-cells-d02b2a5a-a08d-4641-8d4d-b3f233daca2c) [official_ms_support] tags: merge_cells_discovery
  - relevance: Operational impact source

## formula
- ECS-003 [Calculation operators and precedence in Excel](https://support.microsoft.com/en-us/office/calculation-operators-and-precedence-in-excel-48be406d-4975-4d31-b2b8-7af9e0e2878a) [official_ms_support] tags: operator_semantics|precedence
  - relevance: Includes reference operators and precedence table
- ECS-004 [Implicit intersection operator at](https://support.microsoft.com/en-gb/office/implicit-intersection-operator-ce3be07b-0101-4450-a24e-c1c999be2b34) [official_ms_support] tags: dynamic_arrays|implicit_intersection
  - relevance: Explains migration behavior and @ insertion
- ECS-005 [Spilled range operator](https://support.microsoft.com/en-us/office/spilled-range-operator-3dd5899f-bca2-4b9d-a172-3eae9ac22efd) [official_ms_support] tags: dynamic_arrays|spill_operator
  - relevance: Defines hash spill-range operator
- ECS-006 [Dynamic array formulas and spilled array behavior](https://support.microsoft.com/en-us/office/dynamic-array-formulas-and-spilled-array-behavior-205c6b06-03ba-4151-89a1-87a7eb36e531) [official_ms_support] tags: dynamic_arrays|spill_behavior
  - relevance: Core spill behavior guidance
- ECS-007 [Excel functions that return ranges or arrays](https://support.microsoft.com/en-us/office/excel-functions-that-return-ranges-or-arrays-7d1970e2-cbaa-4279-b59c-b9dd3900fc69) [official_ms_support] tags: dynamic_arrays|legacy_transition
  - relevance: Important for at-operator migration
- ECS-008 [MS-XLSX Formulas](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-xlsx/3d025add-118d-4413-9856-ab65712ec1b0) [official_ms_learn_open_specs] tags: abnf_grammar|structured_refs
  - relevance: Formal grammar anchor
- ECS-009 [MS-XLSX Cell Formulas](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-xlsx/bb813b21-5c61-41e8-b91c-3ebb4550666c) [official_ms_learn_open_specs] tags: cell_formula_constraints
  - relevance: Formula record constraints

## functions
- ECS-001 [Excel functions (alphabetical)](https://support.microsoft.com/en-us/office/excel-functions-alphabetical-b3944572-255d-4efb-bb96-c6d90033e188) [official_ms_support] tags: function_inventory|version_markers
  - relevance: Primary canonical function inventory anchor
- ECS-002 [Excel functions (by category)](https://support.microsoft.com/en-us/office/excel-functions-by-category-5f91f4e9-7b42-46d2-9bd1-63f26a86c0eb) [official_ms_support] tags: function_inventory|categories|version_markers
  - relevance: Primary category anchor with introduction markers
- ECS-039 [NOW function](https://support.microsoft.com/en-us/office/now-function-3337fd29-145a-4347-b2e6-20c904739c46) [official_ms_support] tags: volatile|format_behavior
  - relevance: Notes general-format auto-change behavior
- ECS-040 [RTD function](https://support.microsoft.com/en-us/office/rtd-function-e0cc001a-56f0-470a-9b19-9455dc0eb593) [official_ms_support] tags: external_realtime_data
  - relevance: Primary worksheet RTD source
- ECS-041 [LET function](https://support.microsoft.com/en-us/office/let-function-34842dd8-b92b-4d3f-b325-b8b8f9908999) [official_ms_support] tags: functional_formula
  - relevance: Core functional formula feature
- ECS-042 [LAMBDA function](https://support.microsoft.com/en-us/office/lambda-function-bd212d27-1cd1-4321-a34a-ccbf254b8b67) [official_ms_support] tags: functional_formula
  - relevance: User-defined workbook-native functions
- ECS-043 [BYROW function](https://support.microsoft.com/en-us/office/byrow-function-2e04c677-78c8-4e6b-8c10-a4602f2602bb) [official_ms_support] tags: functional_helper|dynamic_array
  - relevance: LAMBDA helper family
- ECS-044 [REDUCE function](https://support.microsoft.com/en-us/office/reduce-function-42e39910-b345-45f3-84b8-0642b568b7cb) [official_ms_support] tags: functional_helper|dynamic_array
  - relevance: LAMBDA helper family
- ECS-045 [SCAN function](https://support.microsoft.com/en-us/office/scan-function-d58dfd11-9969-4439-b2dc-e7062724de29) [official_ms_support] tags: functional_helper|dynamic_array
  - relevance: LAMBDA helper family
- ECS-046 [MAP function](https://support.microsoft.com/en-us/office/map-function-48006093-f97c-47c1-bfcc-749263bb1f01) [official_ms_support] tags: functional_helper|dynamic_array
  - relevance: LAMBDA helper family
- ECS-047 [MAKEARRAY function](https://support.microsoft.com/en-us/office/makearray-function-b80da5ad-b338-4149-a523-5b221da09097) [official_ms_support] tags: functional_helper|dynamic_array
  - relevance: LAMBDA helper family
- ECS-048 [ISOMITTED function](https://support.microsoft.com/en-us/office/isomitted-function-831d6fbc-0f07-40c4-9c5b-9c73fd1d60c1) [official_ms_support] tags: functional_helper|lambda_optional_args
  - relevance: LAMBDA optional-arg helper
- ECS-049 [RANDARRAY function](https://support.microsoft.com/en-us/office/randarray-function-21261e55-3bec-4885-86a6-8b0a47fd4d33) [official_ms_support] tags: dynamic_array|random_generation
  - relevance: Dynamic array random generator
- ECS-053 [CUBESET function](https://support.microsoft.com/en-us/office/cubeset-function-5b2146bd-62d6-4d04-9d8f-670e993ee1d9) [official_ms_support] tags: cube_family|applies_to
  - relevance: Used for cube-context and platform applies-to probe
- ECS-054 [CUBEVALUE function](https://support.microsoft.com/en-us/office/cubevalue-function-8733da24-26d1-4e34-9b3a-84a8f00dcbe0) [official_ms_support] tags: cube_family|applies_to
  - relevance: Used for cube-context and platform applies-to probe
- ECS-055 [GROUPBY function](https://support.microsoft.com/en-us/office/groupby-function-5e08ae8c-6800-4b72-b623-c41773611505) [official_ms_support] tags: dynamic_array|new_function|applies_to
  - relevance: Used for newer function availability probe
- ECS-056 [PIVOTBY function](https://support.microsoft.com/en-us/office/pivotby-function-de86516a-90ad-4ced-8522-3a25fac389cf) [official_ms_support] tags: dynamic_array|new_function|applies_to
  - relevance: Used for newer function availability probe
- ECS-057 [INDIRECT function](https://support.microsoft.com/en-us/office/indirect-function-474b3a3a-8a26-4f44-b491-92b6306fa261) [official_ms_support] tags: critical_function|reference_indirection
  - relevance: Tier-5 deep semantics anchor
- ECS-058 [OFFSET function](https://support.microsoft.com/en-us/office/offset-function-c8de19ae-dd79-4b9b-a14e-b4d906d11b66) [official_ms_support] tags: critical_function|reference_shape
  - relevance: Tier-5 deep semantics anchor
- ECS-059 [TODAY function](https://support.microsoft.com/en-us/office/today-function-5eb3078d-a82c-4736-8930-2f51a028fdd9) [official_ms_support] tags: critical_function|date_serial
  - relevance: Tier-5 deep semantics anchor

## history
- ECS-051 [Preview of Dynamic Arrays in Excel](https://techcommunity.microsoft.com/blog/excelblog/preview-of-dynamic-arrays-in-excel/252944) [official_ms_blog] tags: dynamic_arrays|historical_rollout
  - relevance: Secondary historical context

## limits
- ECS-033 [Excel specifications and limits](https://support.microsoft.com/en-us/office/excel-specifications-and-limits-1672b34d-7043-467e-8e27-269d656771c3) [official_ms_support] tags: grid_limits|format_limits|calc_limits
  - relevance: Critical compatibility limits baseline

## names
- ECS-010 [Define and use names in formulas](https://support.microsoft.com/en-us/office/define-and-use-names-in-formulas-4d0f13ac-53b7-422e-afd2-abd7ff379c64) [official_ms_support] tags: name_rules|scope
  - relevance: Primary names overview
- ECS-011 [Names in formulas](https://support.microsoft.com/en-us/office/names-in-formulas-fc2935f9-115d-4bef-a370-3aa8bb4c91f1) [official_ms_support] tags: name_syntax|precedence
  - relevance: Detailed scope and syntax notes

## objects
- ECS-015 [ListObject object Excel](https://learn.microsoft.com/en-us/office/vba/api/excel.listobject) [official_ms_learn] tags: listobject_api|table_lifecycle
  - relevance: Supplemental object model sourceECS-016

## tables
- ECS-012 [Using structured references with Excel tables](https://support.microsoft.com/en-us/office/using-structured-references-with-excel-tables-f5ed2452-2337-4f71-bed3-c8ae6d2b276e) [official_ms_support] tags: table_refs|structured_ref_syntax
  - relevance: Primary table formula syntax source
- ECS-013 [Use calculated columns in an Excel table](https://support.microsoft.com/en-au/office/use-calculated-columns-in-an-excel-table-873fbac6-7110-4300-8f6f-aafa2ea11ce8) [official_ms_support] tags: table_auto_expand|calculated_columns
  - relevance: Auto-fill and expansion behavior
- ECS-014 [Use calculated columns in a table in Excel for the web](https://support.microsoft.com/en-us/office/use-calculated-columns-in-a-table-in-excel-for-the-web-f048e0fe-120f-4717-9f07-50a0b1410263) [official_ms_support] tags: table_auto_expand|web_behavior
  - relevance: Web parity source

## triangulation
- ECS-052 [Dynamic Array functions thread with support links](https://learn.microsoft.com/en-us/answers/questions/5047632/dynamic-array-funtions) [official_ms_qna] tags: dynamic_arrays|link_discovery
  - relevance: Secondary triangulation source

## types
- ECS-017 [IS functions](https://support.microsoft.com/en-us/office/is-functions-0f2d7971-6019-40a0-a171-f2d869135665) [official_ms_support] tags: type_predicates|error_detection
  - relevance: Value-class predicates
- ECS-018 [N function](https://support.microsoft.com/en-au/office/n-function-a624cad1-3635-4208-b54a-29733d1278c9) [official_ms_support] tags: type_coercion|date_serials
  - relevance: Numeric coercion behavior
- ECS-019 [VALUE function](https://support.microsoft.com/en-us/office/value-function-257d0108-07dc-437d-ae1c-bc2d3953d8c2) [official_ms_support] tags: type_coercion|text_to_number
  - relevance: Text-to-number coercion
- ECS-020 [VALUETOTEXT function](https://support.microsoft.com/en-au/office/valuetotext-function-5fff61a2-301a-4ab2-9ffa-0a5242a08fea) [official_ms_support] tags: type_coercion|rendering
  - relevance: Controlled value-to-text rendering
- ECS-021 [Excel data types stocks and geography](https://support.microsoft.com/office/excel-data-types-stocks-and-geography-61a33056-9935-484f-8ac8-f1a89e210877) [official_ms_support] tags: linked_data_types|compound_values
  - relevance: Extended data types baseline
- ECS-022 [What linked data types are available in Excel](https://support.microsoft.com/en-us/office/what-linked-data-types-are-available-in-excel-6510ab58-52f6-4368-ba0f-6a76c0190772) [official_ms_support] tags: linked_data_types|availability
  - relevance: Availability and deprecation notes
- ECS-023 [Linked data types FAQ and tips](https://support.microsoft.com/en-us/office/linked-data-types-faq-and-tips-d48d6394-c83a-43cd-9d94-78257102f054) [official_ms_support] tags: linked_data_types|limitations
  - relevance: Requirements and limits
- ECS-024 [How to write formulas that reference data types](https://support.microsoft.com/en-au/office/how-to-write-formulas-that-reference-data-types-295d95e2-1e8a-4337-bfa9-0582b815c0b4) [official_ms_support] tags: linked_data_formula_syntax|dot_operator
  - relevance: Field dereference syntax guidance
- ECS-025 [FIELDVALUE function](https://support.microsoft.com/en-au/office/fieldvalue-function-4a579c45-7326-4168-b556-df8b5685175b) [official_ms_support] tags: linked_data_formula_syntax|field_extraction
  - relevance: Field extraction function

## versioning
- ECS-034 [Compatibility Versions](https://support.microsoft.com/en-us/office/compatibility-versions-49f5d3bf-d9a4-47a3-9db8-e776f664cbf9) [official_ms_support] tags: compat_versioning|function_behavior_deltas
  - relevance: Workbook-scoped compatibility setting
- ECS-035 [Overview of update channels for Microsoft 365 Apps](https://learn.microsoft.com/en-us/microsoft-365-apps/updates/overview-update-channels) [official_ms_learn] tags: channel_rollout
  - relevance: Channel behavior baseline
- ECS-036 [Release notes for Monthly Enterprise Channel](https://learn.microsoft.com/en-us/officeupdates/monthly-enterprise-channel) [official_ms_learn] tags: channel_release_notes
  - relevance: Feature arrival triangulation source
