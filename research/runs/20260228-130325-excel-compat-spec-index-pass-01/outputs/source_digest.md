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
- ECS-062 [CELL function](https://support.microsoft.com/en-us/office/cell-function-51bd39a5-f338-4dbe-a33f-955d67c2b2cf) [official_ms_support] tags: interesting_function|function_semantics|tier5
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-063 [INFO function](https://support.microsoft.com/en-us/office/info-function-725f259a-0e4b-49b3-8b52-58815c69acae) [official_ms_support] tags: interesting_function|function_semantics|tier5
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-064 [BYCOL function](https://support.microsoft.com/en-us/office/bycol-function-58463999-7de5-49ce-8f38-b7f7a2192bfb) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-065 [CHOOSECOLS function](https://support.microsoft.com/en-us/office/choosecols-function-bf117976-2722-4466-9b9a-1c01ed9aebff) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-066 [CHOOSEROWS function](https://support.microsoft.com/en-us/office/chooserows-function-51ace882-9bab-4a44-9625-7274ef7507a3) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-067 [CUBEKPIMEMBER function](https://support.microsoft.com/en-us/office/cubekpimember-function-744608bf-2c62-42cd-b67a-a56109f4b03b) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-068 [CUBEMEMBER function](https://support.microsoft.com/en-us/office/cubemember-function-0f6a15b9-2c18-4819-ae89-e1b5c8b398ad) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-069 [CUBEMEMBERPROPERTY function](https://support.microsoft.com/en-us/office/cubememberproperty-function-001e57d6-b35a-49e5-abcd-05ff599e8951) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-070 [CUBERANKEDMEMBER function](https://support.microsoft.com/en-us/office/cuberankedmember-function-07efecde-e669-4075-b4bf-6b40df2dc4b3) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-071 [CUBESETCOUNT function](https://support.microsoft.com/en-us/office/cubesetcount-function-c4c2a438-c1ff-4061-80fe-982f2d705286) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-072 [DROP function](https://support.microsoft.com/en-us/office/drop-function-1cb4e151-9e17-4838-abe5-9ba48d8c6a34) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-073 [ENCODEURL function](https://support.microsoft.com/en-us/office/encodeurl-function-07c7fb90-7c60-4bff-8687-fac50fe33d0e) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-074 [EXPAND function](https://support.microsoft.com/en-us/office/expand-function-7433fba5-4ad1-41da-a904-d5d95808bc38) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-075 [FILTER function](https://support.microsoft.com/en-us/office/filter-function-f4f7cb66-82eb-4767-8f7c-4877ad80c759) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-076 [FILTERXML function](https://support.microsoft.com/en-us/office/filterxml-function-4df72efc-11ec-4951-86f5-c1374812f5b7) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-077 [HSTACK function](https://support.microsoft.com/en-us/office/hstack-function-98c4ab76-10fe-4b4f-8d5f-af1c125fe8c2) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-078 [SEQUENCE function](https://support.microsoft.com/en-us/office/sequence-function-57467a98-57e0-4817-9f14-2eb78519ca90) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-079 [SORT function](https://support.microsoft.com/en-us/office/sort-function-22f63bd0-ccc8-492f-953d-c20e8e44b86c) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-080 [SORTBY function](https://support.microsoft.com/en-us/office/sortby-function-cd2d7a62-1b93-435c-b561-d6a35134f28f) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-081 [STOCKHISTORY function](https://support.microsoft.com/en-us/office/stockhistory-function-1ac8b5b3-5f62-4d94-8ab8-7504ec7239a8) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-082 [TAKE function](https://support.microsoft.com/en-us/office/take-function-25382ff1-5da1-4f78-ab43-f33bd2e4e003) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-083 [TOCOL function](https://support.microsoft.com/en-us/office/tocol-function-22839d9b-0b55-4fc1-b4e6-2761f8f122ed) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-084 [TOROW function](https://support.microsoft.com/en-us/office/torow-function-b90d0964-a7d9-44b7-816b-ffa5c2fe2289) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-085 [TRANSPOSE function](https://support.microsoft.com/en-us/office/transpose-function-ed039415-ed8a-4a81-93e9-4b6dfac76027) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-086 [TRIMRANGE function](https://support.microsoft.com/en-us/office/trimrange-function-d7812248-3bc5-4c6b-901c-1afa9564f999) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-087 [UNIQUE function](https://support.microsoft.com/en-us/office/unique-function-c5ab87fd-30a3-4ce9-9d1a-40204fb85e1e) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-088 [VSTACK function](https://support.microsoft.com/en-us/office/vstack-function-a4b86897-be0f-48fc-adca-fcc10d795a9c) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-089 [WEBSERVICE function](https://support.microsoft.com/en-us/office/webservice-function-0546a35a-ecc6-4739-aed7-c0b7ce1562c4) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-090 [WRAPCOLS function](https://support.microsoft.com/en-us/office/wrapcols-function-d038b05a-57b7-4ee0-be94-ded0792511e2) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-091 [WRAPROWS function](https://support.microsoft.com/en-us/office/wraprows-function-796825f3-975a-4cee-9c84-1bbddf60ade0) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-092 [XLOOKUP function](https://support.microsoft.com/en-us/office/xlookup-function-b7fd680e-6d10-43e6-84f9-88eae8bf5929) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-093 [XMATCH function](https://support.microsoft.com/en-us/office/xmatch-function-d966da31-7a6b-4a13-a1c6-5a33ed6a0312) [official_ms_support] tags: interesting_function|function_semantics|tier4
  - relevance: Auto-seeded from function_interest_index for full tier-5/4 function source coverage; not yet screened in detail.
- ECS-094 [ADDRESS function](https://support.microsoft.com/en-us/office/address-function-d0c26c0d-3991-446b-8de4-ab46431d4f89) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-095 [AREAS function](https://support.microsoft.com/en-us/office/areas-function-8392ba32-7a41-43b3-96b0-3695d2ec6152) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-096 [COLUMN function](https://support.microsoft.com/en-us/office/column-function-44e8c754-711c-4df3-9da4-47a55042554b) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-097 [COLUMNS function](https://support.microsoft.com/en-us/office/columns-function-4e8e7b4e-e603-43e8-b177-956088fa48ca) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-098 [DOLLAR function](https://support.microsoft.com/en-us/office/dollar-function-a6cd05d9-9740-4ad3-a469-8109d18ff611) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-099 [FIXED function](https://support.microsoft.com/en-us/office/fixed-function-ffd5723c-324c-45e9-8b96-e41be2a8274a) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-100 [FORMULATEXT function](https://support.microsoft.com/en-us/office/formulatext-function-0a786771-54fd-4ae2-96ee-09cda35439c8) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-101 [INDEX function](https://support.microsoft.com/en-us/office/index-function-a5dcf0dd-996d-40a4-a822-b56b061328bd) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-102 [RAND function](https://support.microsoft.com/en-us/office/rand-function-4cbfa695-8869-4788-8d90-021ea9f5be73) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-103 [RANDBETWEEN function](https://support.microsoft.com/en-us/office/randbetween-function-4cc7f0d1-87dc-4eb7-987f-a469ab381685) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-104 [ROW function](https://support.microsoft.com/en-us/office/row-function-3a63b74a-c4d0-4093-b49a-e76eb49a6d8d) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-105 [ROWS function](https://support.microsoft.com/en-us/office/rows-function-b592593e-3fc2-47f2-bec1-bda493811597) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-106 [SHEET function](https://support.microsoft.com/en-us/office/sheet-function-44718b6f-8b87-47a1-a9d6-b701c06cff24) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-107 [SHEETS function](https://support.microsoft.com/en-us/office/sheets-function-770515eb-e1e8-45ce-8066-b557e5e4b80b) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-108 [SUMIF function](https://support.microsoft.com/en-us/office/sumif-function-169b8c99-c05c-4483-a712-1697a653039b) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-109 [T function](https://support.microsoft.com/en-us/office/t-function-fb83aeec-45e7-4924-af95-53e073541228) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-110 [TEXT function](https://support.microsoft.com/en-us/office/text-function-20d5ac4d-7b94-49fd-bb38-93d29371225c) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.
- ECS-111 [TYPE function](https://support.microsoft.com/en-us/office/type-function-45b4e688-4bc3-48b3-a105-ffa892995899) [official_ms_support] tags: interesting_function|function_semantics|tier3
  - relevance: Auto-seeded from tier-3 reason-code source binding pass for ECS-BL-11 hardening.

## history
- ECS-051 [Preview of Dynamic Arrays in Excel](https://techcommunity.microsoft.com/blog/excelblog/preview-of-dynamic-arrays-in-excel/252944) [official_ms_blog] tags: dynamic_arrays|historical_rollout
  - relevance: Secondary historical context

## implementation_watch
- ECS-061 [ExcelFinancialFunctions (F#)](https://github.com/fsprojects/ExcelFinancialFunctions) [open_source_repo] tags: financial_functions|fsharp_impl|test_suite_methodology
  - relevance: Prominent investigation target for financial-function semantics and high-quality testing approach

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

