# Formula Test Corpus

## Single-Cell Corpus (`single-cell/`)

Each entry in `formulas.jsonl` is a self-contained formula that can be evaluated in a single cell or call. This makes it suitable for OxFml formula evaluation and DnaOneCalc proving without requiring a workbook grid or multi-cell reference resolution.

### Canonical File

`single-cell/formulas.jsonl` is the source of truth. Files under `formulas_by_category/` are derived convenience splits and should not be edited directly.

### JSONL Schema (v1.0.0)

Each line is a JSON object with these fields:

| Field | Type | Required | Description |
|---|---|---|---|
| `test_id` | string | yes | `FTC-NNNN` (zero-padded 4-digit) |
| `formula` | string | yes | Complete formula starting with `=` |
| `category` | string | yes | Category slug (see taxonomy below) |
| `subcategory` | string | yes | Finer grouping within category |
| `tags` | string[] | yes | Searchable tags: tier labels, feature flags, edge-case markers |
| `complexity` | enum | yes | `trivial` / `simple` / `moderate` / `complex` / `expert` |
| `functions_exercised` | string[] | yes | Function names used (empty for pure operator formulas) |
| `operators_exercised` | string[] | no | Operators used |
| `expected_result` | any | conditional | Expected scalar or array result; null when non-deterministic |
| `expected_result_type` | string | yes | `number` / `text` / `logical` / `error` / `array` / `date_serial` |
| `expected_error` | string | no | `#VALUE!`, `#REF!`, `#DIV/0!`, `#NUM!`, `#N/A`, `#NAME?`, `#NULL!`, `#CALC!`, `#SPILL!` |
| `result_is_array` | boolean | yes | Whether formula produces array output |
| `array_dimensions` | string | no | e.g. `"3x1"`, `"2x3"` |
| `let_bindings` | object | no | Documents LET-rewrite provenance for adapted formulas |
| `deterministic` | boolean | yes | false for RAND/RANDBETWEEN/NOW/TODAY |
| `requires_locale` | string | no | e.g. `"en-US"` if locale-sensitive |
| `requires_date_system` | string | no | `"1900"` or `"1904"` |
| `conformance_req_ids` | string[] | no | Links to `XLS-CF-*` ids in CONFORMANCE_REQUIREMENTS.csv |
| `evidence_ids` | string[] | no | Links to `ECS-*` or `EMP-*` evidence ids |
| `source_ids` | string[] | no | Links to `R-SRC-*` in sources.csv or `EXT-TC-*` in external corpora index |
| `provenance` | enum | yes | `authored` / `extracted` / `adapted` / `generated` |
| `provenance_detail` | string | yes | Human-readable provenance explanation |
| `notes` | string | no | Additional notes |

### Category Taxonomy

| Slug | Description |
|---|---|
| `arithmetic_operators` | Operator precedence, unary minus, percentage, concatenation, comparison |
| `math_trig` | SUM, SUMPRODUCT, ABS, ROUND, MOD, POWER, LOG, SQRT, PI, CEILING, FLOOR, etc. |
| `statistical` | AVERAGE, MEDIAN, STDEV, PERCENTILE, QUARTILE, COUNT/COUNTA/COUNTBLANK |
| `text_string` | CONCAT, TEXTJOIN, LEFT/MID/RIGHT, FIND/SEARCH, SUBSTITUTE, TRIM, TEXT, VALUE |
| `logical` | IF, IFS, AND, OR, NOT, XOR, SWITCH, IFERROR, IFNA |
| `date_time` | DATE, DATEVALUE, YEAR/MONTH/DAY, EDATE, EOMONTH, NETWORKDAYS, WORKDAY, TIME |
| `lookup_nonref` | VLOOKUP/HLOOKUP/XLOOKUP/MATCH/INDEX rewritten with LET + array constants |
| `financial` | PMT, FV, PV, NPV, IRR, XNPV, XIRR, RATE, NPER, SLN, DDB, COUPDAYS, PRICE, YIELD |
| `information` | ISBLANK, ISERROR, ISNA, ISNUMBER, ISTEXT, ERROR.TYPE, TYPE, N, T |
| `let_lambda_functional` | LET nesting, LAMBDA definitions/calls, MAP, REDUCE, SCAN, BYCOL, BYROW, MAKEARRAY, ISOMITTED |
| `dynamic_array` | FILTER, SORT, SORTBY, UNIQUE, SEQUENCE, RANDARRAY, CHOOSECOLS/CHOOSEROWS, HSTACK/VSTACK, TAKE/DROP |
| `engineering` | HEX2DEC, DEC2HEX, BIN2DEC, CONVERT, COMPLEX, IMSUM |
| `type_coercion_edge` | Mixed types, implicit coercion, error propagation, empty string handling, TRUE/FALSE arithmetic |
| `nested_complex` | Deeply nested formulas, combining multiple function families, real-world patterns |
| `array_constant_literal` | `{1,2,3;4,5,6}` patterns, array constants in function arguments |
| `operator_edge` | Comparison operators with mixed types, concatenation edge cases |

### No-Reference-Resolution Constraint

All formulas must evaluate without cell reference resolution. Three rewrite strategies are used:

- **LET-bind array constants**: `=SUM(A1:A5)` becomes `=LET(data,{10;20;30;40;50},SUM(data))`
- **Inline array constants**: `=VLOOKUP(2,A1:B3,2,FALSE)` becomes `=VLOOKUP(2,{1,"a";2,"b";3,"c"},2,FALSE)`
- **Pure scalar**: `=ABS(-5)`, `=IF(1>2,"yes","no")` (no rewrite needed)

Adapted formulas document the rewrite in the `let_bindings` field.

### Provenance Types

| Type | Meaning |
|---|---|
| `authored` | Written by hand from spec/doc understanding |
| `extracted` | Pulled from an external corpus with attribution |
| `adapted` | Modified from existing Foundation probes/scenarios or external sources |
| `generated` | Programmatically generated (parameter sweeps, combinatorial) |
