# Response — Pass 02: Semantics Core

**Run id:** `20260301-203623-cell-abstraction-pass-02-semantics-core`
**Model:** Claude (base pass)

---

## 1. Scope And Assumptions

**In scope:**
- Expression evaluation order within a single cell.
- Value type system and implicit coercion rules triggered by operators and function arguments.
- Error value semantics: generation, propagation, and short-circuit points.
- Volatility classification of functions and its effect on recalculation scheduling.
- The boundary between computed value and displayed representation (formatting semantics).

**Out of scope:**
- Cross-cell dependency graph and recalculation order (deferred to a dependency/calc-chain pass).
- Array formula spill mechanics and dynamic array resize behavior.
- Specific function signatures beyond what is needed to illustrate classification.
- VBA/macro interaction with cell evaluation.
- Collaborative/co-authoring conflict resolution.

**Assumptions:**
- The target conformance baseline is ECMA-376 5th Edition (ISO/IEC 29500) plus observable Excel 365 behavior where the spec is silent.
- ODF/ODS divergences are noted but not primary.
- "Cell" means a single worksheet cell; merged-cell display semantics are out of scope.

---

## 2. Response To Prompt Sequence

### 2.1 Expression Evaluation and Value Coercion Semantics

#### 2.1.1 Value Type Universe

A cell's computed result belongs to exactly one of these types:

| Type | Internal Representation | Notes |
|---|---|---|
| **Number** | IEEE 754 double-precision float | All numeric values, including dates/times (serial number encoding) |
| **String** | UTF-16 string, max 32767 chars | Text values |
| **Boolean** | TRUE / FALSE | Distinct from Number in storage, coercible in arithmetic |
| **Error** | Error code (see §2.2) | Propagates through most operations |
| **Empty** | Sentinel (not the same as zero or blank string) | Uninitialized cell, omitted argument |
| **Array** | Rectangular matrix of the above scalar types | Intermediate only; resolves to scalar on cell write unless spill context |

There is no null type distinct from Empty. A cell that has never been touched yields Empty.

**[CONFORMANCE: ECMA-376 §18.17.2 — "A cell can contain a number, a string, a Boolean, or an error value."]**

#### 2.1.2 Coercion Rules

Coercion is context-dependent. The trigger is always the consuming operator or function, never the producing cell.

**Arithmetic operators** (`+`, `-`, `*`, `/`, `^`, unary `-`, unary `+`):

| Source Type | Coerced To | Rule |
|---|---|---|
| Number | Number | Identity |
| Boolean | Number | TRUE→1, FALSE→0 |
| String (numeric parse) | Number | Parsed as locale-invariant decimal. Leading/trailing whitespace trimmed. |
| String (non-numeric) | Error | `#VALUE!` |
| Empty | Number | 0 |
| Error | Error | Propagated (see §2.2) |

**Comparison operators** (`=`, `<>`, `<`, `>`, `<=`, `>=`):

Comparisons follow a type-rank ordering when operands differ in type:

```
Number (rank 0) < String (rank 1) < Boolean (rank 2)
```

- Two values of different type rank: the lower-ranked value is always "less than." No coercion occurs.
- Two Numbers: numeric comparison (IEEE 754 rules; NaN should not arise from normal operations).
- Two Strings: case-insensitive lexicographic comparison using the workbook's collation locale.
- Two Booleans: FALSE < TRUE.
- Empty compared to Number 0 yields equal (`=` → TRUE). Empty compared to String "" yields equal. Empty compared to FALSE yields equal.

**[CONFORMANCE: ECMA-376 §18.17.3.1 — comparison semantics including type ranking.]**

**[UNCERTAINTY-01: The exact collation order for string comparison is locale-dependent. The spec defers to "implementation-defined locale." Excel uses the Windows system locale by default. Need empirical pass to document specific collation edge cases (e.g., Turkish dotless-i).]**

**String concatenation** (`&`):

| Source Type | Coerced To | Rule |
|---|---|---|
| Number | String | Formatted using General format (no thousands separator, up to 15 significant digits) |
| Boolean | String | "TRUE" / "FALSE" (locale-invariant in English Excel; localized in non-English) |
| Empty | String | "" (empty string) |
| Error | Error | Propagated |

**[UNCERTAINTY-02: Boolean-to-string via `&` — is the output locale-dependent? Empirical evidence suggests TRUE/FALSE in English, VRAI/FAUX in French. Needs conformance citation or controlled test.]**

**Function argument coercion:**

Functions define per-parameter coercion expectations. Three coercion modes exist:

1. **Strict-typed**: No coercion; wrong type → `#VALUE!`. (e.g., `LEFT(text, num_chars)` — first arg must be string or string-coercible.)
2. **Arithmetic-coercing**: Same rules as arithmetic operators. (e.g., `SUM`, `AVERAGE` for their numeric arguments.)
3. **Aggregate-scanning**: Used by functions that scan ranges. String and Boolean values in ranges are typically **skipped**, not coerced. (e.g., `SUM(A1:A10)` skips text and logical values in the range but coerces them if passed as direct arguments.)

This dual behavior (range-skip vs. direct-coerce) is a critical semantic distinction:

```
A1 = TRUE
=SUM(A1)       → 0   (range reference: Boolean skipped)
=SUM(TRUE)     → 1   (direct literal: Boolean coerced to 1)
=SUM(A1*1)     → 1   (expression: A1 coerced via arithmetic)
```

**[CONFORMANCE: ECMA-376 §18.17.7.2 — aggregate function behavior with mixed types in ranges.]**

#### 2.1.3 Evaluation Order

Within a single cell formula:

1. **Operator precedence** (highest to lowest):
   - Reference operators (`:`, `,`, ` ` [intersection])
   - Unary `+`, unary `-`
   - `%` (percent — divides by 100)
   - `^` (exponentiation — right-associative)
   - `*`, `/` (left-to-right)
   - `+`, `-` (left-to-right)
   - `&` (concatenation)
   - Comparison operators (`=`, `<>`, `<`, `>`, `<=`, `>=`)

2. **Function arguments**: Evaluated left-to-right before the function body executes. Exception: `IF`, `IFS`, `SWITCH`, `IFERROR`, `IFNA`, `CHOOSE` — these short-circuit (see §2.2.2).

3. **No guaranteed sub-expression elimination**: The engine may evaluate the same sub-expression multiple times (implementation-dependent).

**[CONFORMANCE: ECMA-376 §18.17.3 — operator precedence table.]**

---

### 2.2 Error Behavior and Propagation Lattice

#### 2.2.1 Error Values

| Error | Code | Trigger |
|---|---|---|
| `#NULL!` | 0x00 | Intersection of two ranges that don't intersect |
| `#DIV/0!` | 0x07 | Division by zero; `MOD(n,0)` |
| `#VALUE!` | 0x0F | Wrong argument type; coercion failure |
| `#REF!` | 0x17 | Reference to deleted cells/sheets |
| `#NAME?` | 0x1D | Unrecognized formula name |
| `#NUM!` | 0x24 | Numeric result out of range; invalid numeric argument |
| `#N/A` | 0x2A | Value not available; explicit `NA()` |
| `#GETTING_DATA` | 0x2B | Async data retrieval in progress (volatile/transient) |
| `#SPILL!` | — | Dynamic array spill blocked (Excel 365+) |
| `#CALC!` | — | Calculation engine limit (e.g., empty array result) |
| `#CONNECT!` | — | External data source connection failure |
| `#BLOCKED!` | — | Security policy blocked the operation |
| `#UNKNOWN!` | — | Unrecognized/future error |
| `#FIELD!` | — | Structured reference field not found |

The first seven (`#NULL!` through `#N/A`) are "classic" errors defined in the BIFF/ECMA spec. The remainder are Excel 365 extensions.

**[CONFORMANCE: ECMA-376 §18.17.2.4 — error value definitions.]**

#### 2.2.2 Propagation Rules

**Default propagation (most operators and functions):**
If any operand/argument is an Error, the Error propagates as the result. When multiple operands are errors, the **leftmost** (first-evaluated) error wins.

```
=#REF! + #VALUE!    → #REF!   (left operand evaluated first)
=SUM(#N/A, #DIV/0!) → #N/A    (first argument evaluated first)
```

**Short-circuit functions** suppress propagation in unevaluated branches:

| Function | Behavior |
|---|---|
| `IF(cond, then, else)` | Only evaluates the taken branch. Error in untaken branch does not propagate. |
| `IFERROR(value, fallback)` | Evaluates `value`; if any error, evaluates and returns `fallback`. |
| `IFNA(value, fallback)` | Like `IFERROR` but only traps `#N/A`. |
| `IFS(cond1, val1, ...)` | Evaluates conditions sequentially; stops at first TRUE. |
| `SWITCH(expr, val1, result1, ...)` | Evaluates match values sequentially. |

**Aggregate functions** (`SUM`, `AVERAGE`, `COUNT`, `MAX`, `MIN`, etc.):
- Error cells within a scanned range **do propagate** (the entire aggregate returns the error).
- Exception: `AGGREGATE` function with `options` parameter can ignore error values.

**[UNCERTAINTY-03: When multiple error values exist in a range passed to SUM, which error propagates? Testing suggests the first encountered in row-major scan order, but this is not spec-cited.]**

#### 2.2.3 Error Lattice (Partial Order)

There is **no formal priority lattice** among error types in the spec. Propagation is determined solely by evaluation order (leftmost-first), not by error "severity." This is a common misconception.

However, certain errors preempt evaluation entirely:
- `#NAME?` is typically detected at parse time, before evaluation begins.
- `#REF!` from deleted references is resolved at formula adjustment time, before evaluation.

So in practice a cell containing `=deleted_ref + unknown_name()` would show `#NAME?` if the name is unresolved (parse-time), or `#REF!` if the name resolves but the reference is broken (adjust-time). The distinction is temporal, not ordinal.

---

### 2.3 Function Semantics Classification

#### 2.3.1 Classification Taxonomy

| Class | Definition | Recalc Implication |
|---|---|---|
| **Pure** | Output depends only on input values. No side effects. | Recalc only when inputs change. |
| **Volatile** | Output may change even when inputs are unchanged. | Recalc on every calculation cycle. |
| **Volatile-once** | Volatile on initial evaluation; pure thereafter within the session. | Recalc once per workbook-open, then treated as pure. |
| **Host-context** | Depends on workbook/sheet/cell metadata not modeled as cell references. | Recalc when relevant metadata changes. |
| **External** | Depends on data outside the workbook (files, databases, web services). | Recalc policy depends on connection settings. |
| **Structural-reference-sensitive** | Result depends on the structure (shape, size, position) of reference arguments, not just their values. | Recalc when structural changes occur (insert/delete rows/cols). |

#### 2.3.2 Classification of Key Functions

| Function | Class | Rationale |
|---|---|---|
| `SUM`, `AVERAGE`, `IF`, `VLOOKUP` | Pure | Deterministic on inputs |
| `NOW()`, `TODAY()` | Volatile | Time-dependent |
| `RAND()`, `RANDBETWEEN()` | Volatile | Non-deterministic |
| `INDIRECT(ref_text)` | Volatile | Depends on string evaluation at runtime; engine cannot statically resolve dependency |
| `OFFSET(ref, rows, cols, ...)` | Volatile | Dynamic reference construction |
| `INFO(type_text)` | Volatile | System-state dependent |
| `CELL(info_type, ref)` | Volatile | Cell metadata dependent |
| `ROWS(ref)`, `COLUMNS(ref)` | Structural-reference-sensitive | Returns structural dimension, not cell values |
| `ROW(ref)`, `COLUMN(ref)` | Host-context | Returns position metadata |
| `SHEET(ref)`, `SHEETS()` | Host-context | Workbook structure metadata |
| `HYPERLINK(url, text)` | Host-context + side-effect | Produces a clickable link (display side effect) |
| `RTD(...)` | External | Real-time data from COM server |
| `WEBSERVICE(url)` | External | HTTP request |
| `STOCKHISTORY(...)` | External | Financial data service |

**`INDIRECT` and `OFFSET` volatility note:** These are marked volatile by Excel because the engine cannot determine which cells they depend on without evaluating the formula. This is a limitation of the dependency tracker, not an inherent property of the computation. A sufficiently advanced engine could resolve some INDIRECT/OFFSET patterns statically.

**[CONFORMANCE: ECMA-376 §18.17.5.1 — volatile function list. Note: the spec lists only NOW, TODAY, RAND, RANDBETWEEN as "shall be volatile." INDIRECT and OFFSET volatility is observable behavior not explicitly mandated by the spec text.]**

**[UNCERTAINTY-04: Is OFFSET truly volatile in all implementations, or only when its offset arguments are non-constant? LibreOffice Calc treats OFFSET as volatile unconditionally. Google Sheets documentation says it's volatile. Need to verify whether any engine optimizes constant-offset OFFSET as non-volatile.]**

#### 2.3.3 Volatile-Once Semantics

Certain functions recalculate on workbook open but not on every recalc cycle:

- `TODAY()` — some documentation suggests it's volatile (recalculates on every change), but observable Excel behavior is volatile (recalculates when any cell changes).
- `INFO("directory")` — returns the current directory at time of evaluation. Volatile.

**[UNCERTAINTY-05: The "volatile-once" category is referenced in some engine documentation (e.g., LibreOffice internals) but not clearly delineated in ECMA-376. Need to determine whether this class exists in Excel or is a Calc-only optimization. Evidence needed: controlled test with a volatile-once candidate function and a forced recalc trigger.]**

---

### 2.4 Value-to-Display Formatting Semantics

#### 2.4.1 The Formatting Pipeline

The separation between computed value and displayed text is fundamental:

```
Formula → Evaluation → Typed Value → Format Application → Display String
                          ↑                    ↑
                    (§2.1 semantics)    (this section)
```

A cell's display is determined by:

1. The **computed value** (typed result from evaluation).
2. The **number format** (either explicitly applied or inherited from General).
3. The **conditional format rules** (zero or more overlay rules that may modify fill, font, borders, or number format).
4. The **column width** (can cause `###` overflow display).

#### 2.4.2 Number Format Semantics

A number format string has up to four sections separated by `;`:

```
positive_format ; negative_format ; zero_format ; text_format
```

Fewer sections:
- 1 section: applies to all numbers; text passes through unformatted.
- 2 sections: first for positive and zero, second for negative.
- 3 sections: positive; negative; zero. Text unformatted.
- 4 sections: positive; negative; zero; text.

**Format string does NOT change the stored value.** It is purely a display transformation. `=A1+0` on a formatted cell operates on the stored double, not the displayed string.

**The `General` format:**
- Displays up to 11 significant characters (including decimal point, minus sign).
- Suppresses trailing zeros after decimal point.
- Switches to scientific notation if the number exceeds display width.
- Shows integers without decimal point.
- Dates stored as numbers display as numbers under General (date display requires a date format, either explicitly applied or auto-applied by input parsing).

**[CONFORMANCE: ECMA-376 §18.8.31 — numFmt format codes.]**

#### 2.4.3 Date/Time Formatting Interaction

Dates and times are stored as serial numbers (doubles):
- Integer part: days since epoch (1900-01-00 in the 1900 date system, or 1904-01-01 in the 1904 system).
- Fractional part: fraction of a 24-hour day.

**The Lotus 1-2-3 bug:** The 1900 date system incorrectly treats 1900 as a leap year. Serial number 60 corresponds to the non-existent date February 29, 1900. This is preserved for backward compatibility.

**[CONFORMANCE: ECMA-376 §18.17.4.1 — date serial number encoding, including the 1900 leap year bug.]**

Date formatting applies only when:
1. The cell has an explicit date/time format, OR
2. The user entered a value that was auto-recognized as a date (which triggers auto-format application as a side effect of input parsing — see §2.4.5).

A date-formatted cell containing a negative number or a number > 2958465 (9999-12-31) displays `###` or a sequence of hashes.

#### 2.4.4 Conditional Formatting Interaction

Conditional formatting rules are evaluated **after** the cell value is computed but **before** final display rendering. They can:

- Override the number format (e.g., show negative values in red with a different decimal precision).
- Apply visual modifications (fill, font, border, icon sets, data bars).
- **Not** change the stored value.

Conditional formatting evaluation order:
1. Rules are evaluated in priority order (user-defined ordering in the CF rules list).
2. If `stopIfTrue` is set on a matching rule, subsequent rules are skipped.
3. Multiple non-conflicting rules can stack (e.g., one rule sets fill, another sets font).

**[CONFORMANCE: ECMA-376 §18.3.1.10 — conditionalFormatting element; §18.3.1.12 — cfRule with stopIfTrue.]**

#### 2.4.5 Input Parsing Side Effects on Formatting

When a user enters a value into a cell, the input parser may apply formatting as a side effect:

| Input | Stored Value | Auto-Applied Format |
|---|---|---|
| `42` | Number 42 | General (no change) |
| `3/1/2026` | Serial number for that date | Date format (e.g., `m/d/yyyy`) |
| `$1,234.56` | Number 1234.56 | Currency format `$#,##0.00` |
| `10%` | Number 0.1 | Percentage format `0%` |
| `1:30 PM` | Fraction 0.5625 | Time format `h:mm AM/PM` |
| `1 1/2` | Number 1.5 | Fraction format `# ?/?` |

This auto-formatting is a **UI-level side effect**, not an evaluation semantic. Programmatic cell writes (via API, paste-values, or formula results) do **not** trigger auto-format application.

**[UNCERTAINTY-06: When a formula result writes a serial number into a cell that previously had auto-applied date formatting, does the format persist? Empirical observation: yes, the format persists from prior user entry. But if the cell was previously General and receives a formula result, it stays General regardless of the numeric value. Need controlled test to verify edge cases around format inheritance on formula-result cells.]**

---

## 3. Uncertainties And Evidence Needs

| ID | Description | Evidence Required | Priority |
|---|---|---|---|
| UNCERTAINTY-01 | String comparison collation locale dependency | Empirical test: compare locale-sensitive characters (Turkish İ/i, German ß) in `=A1=A2` across locales | Medium |
| UNCERTAINTY-02 | Boolean-to-string coercion via `&` — is it localized? | Test `=TRUE&""` in English vs. French vs. German Excel | Low |
| UNCERTAINTY-03 | Error propagation order in multi-error ranges for aggregates | Test `=SUM(range)` where range contains `#N/A` and `#VALUE!` at known positions; vary positions | Medium |
| UNCERTAINTY-04 | OFFSET volatility — constant vs. dynamic arguments | Test OFFSET with constant arguments in Excel; observe whether it recalculates when unrelated cells change | Medium |
| UNCERTAINTY-05 | Volatile-once function class — does it exist in Excel? | Monitor recalc count for `INFO("directory")` and `CELL("filename")` across multiple recalc triggers within a single session | Low |
| UNCERTAINTY-06 | Format persistence when formula overwrites previously formatted cell | Set date format via input; then write formula that produces a number; observe displayed format | Medium |
| UNCERTAINTY-07 | Unary `+` on string — coercion or error? | Test `=+"123"` and `=+"abc"` in Excel. Expected: coerces to number or `#VALUE!` like arithmetic. | Low |
| UNCERTAINTY-08 | `#GETTING_DATA` transient error — does it propagate through formulas that reference the async cell? | Create RTD-dependent cell; reference it from another formula; observe intermediate state | Low |

---

## 4. Promotion-Ready Draft Content

The following fragments are ready for migration into `CORE_ENGINE_FORMAL_MODEL.md` after review:

---

### Fragment: Value Type System

```markdown
## Value Types

Every cell value belongs to exactly one of:

- **Number**: IEEE 754 double-precision. Encodes all numeric values including 
  date/time serial numbers.
- **String**: UTF-16, max 32767 characters.
- **Boolean**: TRUE or FALSE.
- **Error**: One of the defined error codes (see Error Values section).
- **Empty**: The value of an uninitialized cell or omitted function argument. 
  Coerces to 0 (arithmetic), "" (string), or FALSE (logical) depending on context.

Arrays are intermediate computation values. In single-cell context, an array 
result is reduced to its top-left element (implicit intersection in legacy mode)
or spills to adjacent cells (dynamic array mode).
```

---

### Fragment: Coercion Matrix (Arithmetic Context)

```markdown
## Arithmetic Coercion

When an arithmetic operator (+, -, *, /, ^, unary -, unary +) requires a 
numeric operand:

| Source    | Result         |
|-----------|---------------|
| Number    | Number (identity) |
| Boolean   | Number (TRUE→1, FALSE→0) |
| String    | Number if parseable; otherwise #VALUE! |
| Empty     | 0             |
| Error     | Error (propagated) |
```

---

### Fragment: Error Propagation

```markdown
## Error Propagation

Default rule: if any operand of an operator or argument of a function evaluates 
to an Error, the result is that Error. When multiple operands are errors, the 
first-evaluated (leftmost) error propagates.

### Short-Circuit Functions

IF, IFERROR, IFNA, IFS, SWITCH: evaluate arguments lazily. Errors in 
unevaluated branches do not propagate.

### Aggregate Functions and Errors

SUM, AVERAGE, MIN, MAX, etc.: an error value anywhere in the scanned range 
causes the entire result to be that error. Use AGGREGATE with ignore-errors 
option to suppress this.
```

---

### Fragment: Volatility Classes

```markdown
## Function Volatility Classification

- **Pure**: Deterministic on input values. Recalculated only when precedent 
  cells change. (SUM, IF, VLOOKUP, INDEX, MATCH, etc.)
- **Volatile**: Must recalculate on every calculation cycle regardless of 
  precedent changes. (NOW, TODAY, RAND, RANDBETWEEN, INDIRECT, OFFSET, INFO, CELL)
- **Host-context**: Depends on workbook/sheet/cell metadata. (ROW, COLUMN, SHEET, 
  SHEETS, HYPERLINK)
- **External**: Depends on data outside the workbook. (RTD, WEBSERVICE, STOCKHISTORY)
- **Structural-reference-sensitive**: Result depends on the shape or position of 
  references, not their values. (ROWS, COLUMNS)
```

---

### Fragment: Formatting Pipeline

```markdown
## Value-to-Display Pipeline

1. Formula evaluation produces a typed value (Number, String, Boolean, Error, Empty).
2. The cell's number format string transforms the value to a display string.
   - Format has up to 4 sections: positive; negative; zero; text.
   - Format NEVER alters the stored value.
3. Conditional formatting rules are evaluated in priority order.
   - Rules may override number format or apply visual styles.
   - `stopIfTrue` halts further rule evaluation.
4. Column width may cause overflow display (### for numbers, truncation for text).
```

---

## 5. Follow-Up Backlog

| Item | Description | Suggested Pass |
|---|---|---|
| **BACKLOG-01** | Implicit intersection vs. dynamic array spill semantics — full formalization | Dedicated array-semantics pass |
| **BACKLOG-02** | Range reference semantics (`:`, `,`, space intersection operator) and structured references | Reference-model pass |
| **BACKLOG-03** | Locale-dependent input parsing rules (date recognition, decimal separator, list separator) | Locale/i18n pass |
| **BACKLOG-04** | `LAMBDA` and `LET` — scoping rules, name shadowing, recursion depth limits | Advanced-function-semantics pass |
| **BACKLOG-05** | Thread-safe vs. thread-unsafe function marking for parallel recalculation | Engine-internals pass |
| **BACKLOG-06** | Automatic number format application heuristics on cell input (when does Excel decide "this is a date"?) | Input-parsing pass |
| **BACKLOG-07** | Error value comparison semantics (`=#N/A=#N/A` → `#N/A`, not TRUE) | Extend this pass with empirical confirmation |
| **BACKLOG-08** | `TEXT`, `VALUE`, `DATEVALUE`, `TIMEVALUE` explicit coercion functions — full semantic specification | Function-catalog pass |
| **BACKLOG-09** | Named range and table scoping rules — workbook-level vs. sheet-level name resolution | Reference-model pass |
| **BACKLOG-10** | Circular reference handling modes (iterative calculation with convergence threshold) | Dependency/calc-chain pass |
