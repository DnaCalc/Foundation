1. Scope And Assumptions
- This run defines semantics for in-cell formula computation: expression evaluation, coercion, error propagation, function behavior classes, and display/format side effects.
- Target behavior is Excel-compatible first, with dynamic arrays enabled, A1 references, and workbook snapshot semantics per recalc cycle.
- The output is designed as model fragments that can be lifted into `CORE_ENGINE_FORMAL_MODEL.md`.
- Out of scope for this pass: VBA/UDF side effects, iterative circular calc tuning, security/policy around external connectors.
- Constraint note: this draft is produced from the provided text only, so unresolved behavior is explicitly tagged `U-*` with evidence links.

2. Response To Prompt Sequence

2.1 Formalize expression evaluation and value coercion semantics
```text
Value ::= Num(f64) | Text(string) | Bool(bool) | Blank | Err(ErrorCode) | Ref(RefSet) | Arr(rows, cols, Value)
Result ::= Ok(Value, Meta) | Fail(ErrorToken)
ErrorToken ::= (origin_index, ErrorCode, phase)
phase ::= bind | eval | spill | async
```

```text
Eval(cell, expr, env) -> Result
env = {workbook_snapshot, calc_epoch, locale, timezone, date_system, array_mode}

Rules:
1) Bind references/names.
2) Evaluate AST left-to-right unless function strictness class overrides.
3) In scalar-required contexts, apply scalarization to Ref/Arr (implicit-intersection/array rules) [U-05].
4) Apply context coercion policy.
5) Return first effective error token unless function masks/catches it.
```

Coercion policies (default engine rules):
- `NumCtx`:
  - `Num(n) -> n`
  - `Bool(TRUE/FALSE) -> 1/0`
  - `Blank -> 0`
  - `Text(s) -> parse_number(s, locale)` or `Err(VALUE)` [U-09]
  - `Err(e) -> Err(e)`
  - `Ref/Arr -> scalarize or array-eval depending context` [U-05]
- `BoolCtx`:
  - `Bool(b) -> b`
  - `Num(n) -> (n != 0)`
  - `Blank -> FALSE`
  - `Text("TRUE"/"FALSE") -> Bool` or `Err(VALUE)` [U-02]
- `TextCtx`:
  - `Text(s) -> s`
  - `Num(n) -> general_format(n, locale)`
  - `Bool -> "TRUE"/"FALSE"`
  - `Blank -> ""`
  - `Err(e) -> Err(e)`

Operator defaults:
- Arithmetic (`+ - * / ^`): strict numeric coercion.
- Concatenation (`&`): text coercion.
- Comparison (`= <> < <= > >=`): same-type compare direct; cross-type ordering/equality behavior needs conformance lock [U-01].
- Function-specific coercion can override defaults (example class: aggregators vs strict operators) [U-11].

2.2 Formalize error behavior and propagation lattice
Error universe (core + modern):  
`{NULL, DIV0, VALUE, REF, NAME, NUM, NA, SPILL, CALC, FIELD, BLOCKED, CONNECT, GETTING_DATA, UNKNOWN}`

Propagation model:
- Base element: `⊥` (no error).
- Each sub-expression yields either value or `ErrorToken(origin_index, code, phase)`.
- Strict composition uses `join_error(a,b) = earlier_origin(a,b)` (deterministic first-error-by-eval-order).
- This produces deterministic behavior even under parallel execution if each AST node has stable `origin_index`.

Function error policies:
- `strict`: any argument error propagates (most arithmetic/text functions).
- `mask_any`: catches any error from first arg (`IFERROR`).
- `mask_na`: catches only `NA` (`IFNA`).
- `branch_lazy`: evaluate selector first, then selected branch only (`IF`, `CHOOSE`) [U-04].
- `eager_logical`: evaluate all args before result (`AND`, `OR`) [U-03].
- `aggregate_ignore_mode`: ignores selected errors by option (e.g., class like `AGGREGATE`).

Array/spill behavior:
- Element-wise ops keep per-element errors.
- Anchor-level spill obstruction returns `SPILL` at anchor.
- External async can produce transitional states (`GETTING_DATA` etc.) [U-10].

2.3 Classify function semantics
Function classes are orthogonal tags (not mutually exclusive).

| Class | Formal criterion | Recalc trigger | Typical examples |
|---|---|---|---|
| Pure | Depends only on explicit inputs; no host/external state | Dependency change only | `SUM`, `ABS`, `MIN` |
| Volatile | May change each calc epoch with same explicit inputs | Every recalc cycle | `RAND`, `RANDBETWEEN`, `NOW`, `TODAY` |
| Host-context | Depends on locale/timezone/workbook settings/UI state | Host context change + deps | `TEXT`, `CELL`, `INFO`, date/time render-dependent behavior |
| External | Depends on connector/network/service/add-in | External refresh/async events | `RTD`, data-linked functions, web/stock feeds |
| Structural-reference sensitive | Semantics depend on address topology, not only values | Structural edits (insert/delete/rename/table reshape) | `OFFSET`, `INDIRECT`, structured references |

Recommended metadata schema per function:
```text
FunctionMeta = {
  strictness: strict | branch_lazy | eager_logical | mask_any | mask_na | aggregate_policy,
  volatility: nonvolatile | volatile_epoch,
  host_context: set(locale, timezone, date_system, ui_state),
  externality: none | sync | async,
  ref_sensitivity: value_only | address_sensitive | shape_sensitive
}
```

2.4 Formalize value-to-display formatting semantics and conditional formatting interaction points
Display pipeline:
```text
raw_value = Eval(cell.formula)
cf_style_delta = EvalConditionalFormatting(cell, raw_value, sheet_state)
effective_style = Merge(base_style, cf_style_delta, priority_order)
display_text = Render(raw_value, effective_style.number_format, locale, date_system, column_width)
```

Normative display rules:
- Formatting does not mutate `raw_value`.
- Numeric/date/time display is format-driven; underlying value remains numeric serial.
- Display rounding is representational only.
- Error values render as error tokens and ignore numeric format sections.
- Width overflow may render placeholder hashes; value remains unchanged.

Conditional formatting interaction points:
- CF rules evaluate after formula values are available.
- CF formula rules use same coercion/error semantics as normal formulas, anchored to rule range origin.
- Rule priority and `Stop If True` determine final style.
- CF may override number format, changing display text without changing value.
- Data bars/color scales/icon sets derive from raw numeric domain; handling of errors/blanks needs conformance lock [U-08].

2.5 Produce unresolved questions with concrete evidence requirements
- Unresolved items are tagged `U-*` below with required executable evidence and source targets.
- Promotion should occur only after each `U-*` has a passing conformance fixture.

3. Uncertainties And Evidence Needs

| Tag | Uncertainty | Evidence required | Source links |
|---|---|---|---|
| U-01 | Cross-type comparison semantics (`Num` vs `Text` vs `Bool`) for `=`, `<`, `>` | Matrix workbook + expected outputs across 365 channels | [S1](https://learn.microsoft.com/en-us/office/open-xml/spreadsheet/working-with-formulas), [S5](https://support.microsoft.com/en-us/office/if-function) |
| U-02 | Text-to-bool coercion in logical contexts (`"TRUE"`, `"FALSE"`, other text) | Formula grid in `IF`, `NOT`, direct boolean tests | [S5](https://support.microsoft.com/en-us/office/if-function), [S6](https://support.microsoft.com/en-us/office/and-function), [S7](https://support.microsoft.com/en-us/office/or-function) |
| U-03 | `AND`/`OR` eagerness vs short-circuit (scalar and array cases) | Cases like `AND(FALSE,1/0)` and array variants | [S6](https://support.microsoft.com/en-us/office/and-function), [S7](https://support.microsoft.com/en-us/office/or-function) |
| U-04 | `IF` branch laziness consistency under dynamic arrays/volatile args | `IF(FALSE,1/0,1)` and spill-array branch cases | [S5](https://support.microsoft.com/en-us/office/if-function), [S2](https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation) |
| U-05 | Scalarization/implicit intersection behavior in modern array mode | Legacy workbook import + `@` operator differential tests | [S3](https://support.microsoft.com/en-us/office/implicit-intersection-operator-ce3be07b-0101-4450-a24e-c1c999be2b34), [S4](https://support.microsoft.com/en-us/office/dynamic-array-formulas-vs-legacy-cse-array-formulas-ca421f1b-fbb2-4c99-9924-df571bd4f1b4) |
| U-06 | Deterministic precedence when multiple errors exist in one expression/array | Dual-error operand and element-wise test matrix | [S2](https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation) |
| U-07 | Canonical volatile function set and trigger granularity | Recalc tracing with unchanged dependencies | [S2](https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation) |
| U-08 | Conditional formatting precedence and number-format override semantics | Multi-rule workbook with `Stop If True` and format conflicts | [S10](https://support.microsoft.com/en-us/office/use-conditional-formatting-to-highlight-information-in-excel), [S11](https://support.microsoft.com/en-us/office/number-format-codes-in-excel-for-mac-5026bbd6-04bc-48cd-bf33-80f18b4eae68) |
| U-09 | Locale-sensitive numeric text parsing during coercion | Same workbook executed under multiple locales | [S11](https://support.microsoft.com/en-us/office/number-format-codes-in-excel-for-mac-5026bbd6-04bc-48cd-bf33-80f18b4eae68) |
| U-10 | Async external error lifecycle (`GETTING_DATA`, `BLOCKED`, etc.) | Online/offline transition tests on external functions | [S2](https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation) |
| U-11 | Aggregator coercion differences (literal text arg vs referenced text cell) | `SUM("1",2)` vs `SUM(A1,2)` where `A1="1"` | [S1](https://learn.microsoft.com/en-us/office/open-xml/spreadsheet/working-with-formulas) |

4. Promotion-Ready Draft Content
```markdown
## Semantics Core: In-Cell Evaluation

### 1) Value Domain
`Value ::= Num | Text | Bool | Blank | Err | Ref | Arr`
All date/time values are stored as numeric serials; formatting controls display only.

### 2) Evaluation Contract
`Eval(cell, expr, env) -> Result`
The engine MUST:
1. Resolve names/references against workbook snapshot.
2. Evaluate AST left-to-right with stable origin indexes.
3. Apply context coercion policy before operator/function execution.
4. Preserve deterministic error choice using first-origin error token.
5. Produce scalar or array result per expression context and array mode.

### 3) Coercion Policies
The engine MUST implement coercion by context:
- `NumCtx`: Num direct, Bool->1/0, Blank->0, Text->locale parse or `#VALUE!`.
- `BoolCtx`: Bool direct, Num nonzero true, Blank false, Text parsing behavior is `UNRESOLVED(U-02)`.
- `TextCtx`: Num via general format, Bool->`TRUE/FALSE`, Blank->empty.
Function-specific policies MAY override defaults and MUST be declared in function metadata.

### 4) Error Propagation
Errors are represented as `ErrorToken(origin_index, code, phase)`.
Strict contexts MUST propagate earliest-origin error.
Masking functions MUST follow mask policy:
- `IFERROR`: catch any error from first argument.
- `IFNA`: catch only `#N/A`.
Branch functions and logical functions MUST follow declared strictness class.
Unresolved precedence details are `UNRESOLVED(U-03,U-04,U-06)`.

### 5) Function Semantics Classification
Each function MUST declare:
- `strictness`
- `volatility`
- `host_context`
- `externality`
- `ref_sensitivity`
These tags drive dependency graphing, recalc scheduling, and cache invalidation.

### 6) Display/Formatting Boundary
Display text MUST be derived by:
`Render(raw_value, effective_number_format, locale, date_system, width)`
Formatting MUST NOT mutate computed value.
Conditional formatting MUST be evaluated after value computation and MAY override number format for display.
Conditional formatting MUST NOT alter formula value.
Rule precedence/stop behavior is `UNRESOLVED(U-08)`.
```

5. Follow-Up Backlog
1. Build a conformance workbook suite covering `U-01..U-11` with expected outputs from target Excel versions.
2. Add a machine-readable `FunctionMeta` registry and enforce metadata completeness in CI.
3. Implement origin-indexed error tokens and deterministic `join_error`.
4. Implement explicit coercion policy modules (`NumCtx`, `BoolCtx`, `TextCtx`) with locale test coverage.
5. Add array-mode compatibility tests for implicit intersection and `@`.
6. Add display pipeline tests separating raw value, effective style, and rendered text.
7. Add conditional formatting precedence tests including number-format overrides and `Stop If True`.
8. Gate promotion to `CORE_ENGINE_FORMAL_MODEL.md` on closure of all `U-*` or explicit waiver records.