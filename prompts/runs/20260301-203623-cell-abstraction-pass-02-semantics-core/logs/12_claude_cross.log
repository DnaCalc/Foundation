I now have all three model outputs. Let me produce the synthesis.

---

# Cross-Model Synthesis — Pass 02: Semantics Core

**Run id:** `20260301-203623-cell-abstraction-pass-02-semantics-core`

---

## 1. Consolidated Best Output

### 1.1 Expression Evaluation and Value Coercion Semantics *(Prompt Item 1)*

#### 1.1.1 Value Type Universe

A cell's computed result belongs to exactly one type from a closed domain:

```text
Value ::= Num(f64) | Text(string) | Bool(bool) | Empty | Err(ErrorCode) | Ref(RefSet) | Arr(rows, cols, Value)
```

| Type | Internal Representation | Notes |
|---|---|---|
| **Number** | IEEE 754 double-precision float | All numeric values including date/time serial numbers |
| **String** | UTF-16 string, max 32,767 chars | Text values |
| **Boolean** | TRUE / FALSE | Distinct from Number in storage, coercible in arithmetic |
| **Error** | Error code (see §1.2) | First-class value; propagates through most operations |
| **Empty** | Sentinel | Uninitialized cell or omitted argument. Not the same as zero or empty string. |
| **Array** | Rectangular matrix of scalar types | Intermediate; resolves to scalar via implicit intersection (legacy) or spills (dynamic array mode) |
| **Reference** | RefSet (range address set) | Intermediate; resolved to value(s) by context |

There is no null type distinct from Empty. `Ref` and `Arr` are intermediate computation types, not storable cell types.

**[CONFORMANCE: ECMA-376 §18.17.2 — "A cell can contain a number, a string, a Boolean, or an error value."]**

#### 1.1.2 Evaluation Contract

```text
Eval(cell, expr, env) -> Result
Result ::= Ok(Value, Meta) | Fail(ErrorToken)
env = {workbook_snapshot, calc_epoch, locale, timezone, date_system, array_mode}
```

The engine MUST:
1. Resolve names/references against the workbook snapshot.
2. Evaluate the AST left-to-right with stable origin indexes, unless a function's strictness class overrides order (e.g., branch-lazy).
3. In scalar-required contexts, apply scalarization to Ref/Arr (implicit intersection in legacy mode, `@` operator in dynamic array mode). **[UNRESOLVED: U-05]**
4. Apply context coercion policy before operator/function execution.
5. Preserve deterministic error choice using first-origin error token.
6. Produce scalar or array result per expression context and array mode.

#### 1.1.3 Coercion Rules

Coercion is context-dependent. The trigger is always the *consuming* operator or function, never the producing cell.

**Arithmetic context** (`NumCtx` — operators `+`, `-`, `*`, `/`, `^`, unary `-`, unary `+`):

| Source | Coerced To | Rule |
|---|---|---|
| Number | Number | Identity |
| Boolean | Number | TRUE→1, FALSE→0 |
| String | Number | Locale-invariant decimal parse (leading/trailing whitespace trimmed); non-numeric → `#VALUE!` **[UNRESOLVED: U-09 for locale-sensitive parsing]** |
| Empty | Number | 0 |
| Error | Error | Propagated |

**Logical context** (`BoolCtx`):

| Source | Coerced To | Rule |
|---|---|---|
| Boolean | Boolean | Identity |
| Number | Boolean | 0→FALSE, non-zero→TRUE |
| Empty | Boolean | FALSE |
| String | Boolean | `"TRUE"`/`"FALSE"` → Bool in some contexts; other text → `#VALUE!` **[UNRESOLVED: U-02]** |
| Error | Error | Propagated |

**Text context** (`TextCtx` — concatenation operator `&`):

| Source | Coerced To | Rule |
|---|---|---|
| String | String | Identity |
| Number | String | General format (no thousands separator, up to 15 significant digits) |
| Boolean | String | `"TRUE"` / `"FALSE"` **[UNRESOLVED: U-12 — locale-dependent?]** |
| Empty | String | `""` |
| Error | Error | Propagated |

**Comparison operators** (`=`, `<>`, `<`, `>`, `<=`, `>=`):

Cross-type comparison uses a type-rank ordering — no coercion occurs between ranks:

```
Number (rank 0) < String (rank 1) < Boolean (rank 2)
```

- Different type ranks: lower-ranked value is always "less than."
- Same-rank Number: IEEE 754 numeric comparison.
- Same-rank String: case-insensitive lexicographic comparison per workbook collation locale. **[UNRESOLVED: U-01]**
- Same-rank Boolean: FALSE < TRUE.
- Empty compared to Number 0 → equal. Empty compared to `""` → equal. Empty compared to FALSE → equal.

**[CONFORMANCE: ECMA-376 §18.17.3.1 — comparison semantics including type ranking.]**

**Function argument coercion** — three modes:

1. **Strict-typed**: Wrong type → `#VALUE!` (e.g., `LEFT` first arg).
2. **Arithmetic-coercing**: Same as arithmetic operators (e.g., `SUM` on direct args).
3. **Aggregate-scanning**: String and Boolean values in *ranges* are **skipped**; when passed as *direct arguments*, they are coerced. This dual behavior is a critical semantic distinction:

```
A1 = TRUE
=SUM(A1)       → 0   (range ref: Boolean skipped)
=SUM(TRUE)     → 1   (direct literal: coerced to 1)
=SUM(A1*1)     → 1   (expression: A1 coerced via arithmetic)
```

**[CONFORMANCE: ECMA-376 §18.17.7.2 — aggregate function behavior with mixed types.]**
**[UNRESOLVED: U-11 — aggregator coercion on literal text arg vs. referenced text cell]**

#### 1.1.4 Operator Precedence

Within a single cell formula (highest to lowest):

1. Reference operators (`:`, `,`, ` ` [intersection])
2. Unary `+`, unary `-`
3. `%` (percent — divides by 100)
4. `^` (exponentiation — right-associative)
5. `*`, `/` (left-to-right)
6. `+`, `-` (left-to-right)
7. `&` (concatenation)
8. Comparison operators (`=`, `<>`, `<`, `>`, `<=`, `>=`)

Function arguments are evaluated left-to-right before the function body executes, except for short-circuit functions (IF, IFS, SWITCH, IFERROR, IFNA, CHOOSE).

**[CONFORMANCE: ECMA-376 §18.17.3 — operator precedence table.]**

---

### 1.2 Error Behavior and Propagation Lattice *(Prompt Item 2)*

#### 1.2.1 Error Value Universe

| Error | Hex Code | Trigger | Era |
|---|---|---|---|
| `#NULL!` | 0x00 | Intersection of non-intersecting ranges | Classic |
| `#DIV/0!` | 0x07 | Division by zero; `MOD(n,0)` | Classic |
| `#VALUE!` | 0x0F | Wrong argument type; coercion failure | Classic |
| `#REF!` | 0x17 | Reference to deleted cells/sheets | Classic |
| `#NAME?` | 0x1D | Unrecognized formula name | Classic |
| `#NUM!` | 0x24 | Numeric result out of range; invalid numeric argument | Classic |
| `#N/A` | 0x2A | Value not available; explicit `NA()` | Classic |
| `#GETTING_DATA` | 0x2B | Async data retrieval in progress (transient) | Modern |
| `#SPILL!` | — | Dynamic array spill blocked | 365+ |
| `#CALC!` | — | Calculation engine limit (e.g., empty array result) | 365+ |
| `#CONNECT!` | — | External data source connection failure | 365+ |
| `#BLOCKED!` | — | Security policy blocked the operation | 365+ |
| `#UNKNOWN!` | — | Unrecognized/future error | 365+ |
| `#FIELD!` | — | Structured reference field not found | 365+ |

**[CONFORMANCE: ECMA-376 §18.17.2.4 — error value definitions (classic seven).]**

#### 1.2.2 Error Token Model

```text
ErrorToken ::= (origin_index, ErrorCode, phase)
phase ::= bind | eval | spill | async
```

Each sub-expression yields either a value or an `ErrorToken`. The `origin_index` provides stable identity for deterministic error selection even under parallel evaluation.

#### 1.2.3 Propagation Rules

**Default propagation (strict):** Any operand/argument that is an Error propagates as the result. When multiple operands are errors, the **leftmost** (first-evaluated by origin index) error wins.

```
=#REF! + #VALUE!    → #REF!   (left operand evaluated first)
=SUM(#N/A, #DIV/0!) → #N/A    (first argument first)
```

**Temporal preemption:** Some errors are detected before evaluation:
- `#NAME?` — parse time (unresolved name).
- `#REF!` — formula adjustment time (deleted reference).

So `=deleted_ref + unknown_name()` yields `#NAME?` (parse preempts eval).

**There is no formal priority lattice among error types in the spec.** Propagation is determined solely by evaluation order, not by error severity. **[UNRESOLVED: U-06 — deterministic precedence in multi-error arrays]**

#### 1.2.4 Function Error Policies

| Policy | Behavior | Examples |
|---|---|---|
| `strict` | Any argument error propagates | Most arithmetic/text functions |
| `mask_any` | Catches any error from first arg | `IFERROR` |
| `mask_na` | Catches only `#N/A` | `IFNA` |
| `branch_lazy` | Evaluate selector first, then selected branch only | `IF`, `IFS`, `SWITCH`, `CHOOSE` **[UNRESOLVED: U-04]** |
| `eager_logical` | Evaluate all args before result | `AND`, `OR` **[UNRESOLVED: U-03]** |
| `aggregate_ignore_mode` | Ignores selected errors by option | `AGGREGATE` |

**Array/spill error behavior:**
- Element-wise operations keep per-element errors.
- Anchor-level spill obstruction returns `#SPILL!` at the anchor cell.
- External async can produce transitional `#GETTING_DATA` states. **[UNRESOLVED: U-10]**

**[UNRESOLVED: U-13 — when `#SPILL!` intersects with an internal `#DIV/0!`, which dominates? (Gemini)]**

---

### 1.3 Function Semantics Classification *(Prompt Item 3)*

#### 1.3.1 Taxonomy

Function classes are orthogonal tags (a function may carry multiple).

| Class | Formal Criterion | Recalc Trigger | Typical Examples |
|---|---|---|---|
| **Pure** | Output depends only on explicit input values; no side effects | Dependency change only | `SUM`, `ABS`, `MIN`, `IF`, `VLOOKUP`, `INDEX`, `MATCH` |
| **Volatile** | May change each calc epoch with same explicit inputs | Every recalc cycle | `RAND`, `RANDBETWEEN`, `NOW`, `TODAY`, `INDIRECT`, `OFFSET` |
| **Volatile-once** | Volatile on initial evaluation; pure thereafter within session | Once per workbook-open **[UNRESOLVED: U-14]** | Possibly some `INFO` variants (LibreOffice documented, Excel unclear) |
| **Host-context** | Depends on locale/timezone/workbook settings/UI state | Host context change + deps | `TEXT`, `CELL`, `INFO`, `ROW`, `COLUMN`, `SHEET`, `SHEETS` |
| **External** | Depends on connector/network/service/add-in | External refresh/async events | `RTD`, `WEBSERVICE`, `STOCKHISTORY`, linked data types |
| **Structural-reference-sensitive** | Semantics depend on address topology, not only values | Structural edits (insert/delete/rename/table reshape) | `OFFSET`, `INDIRECT`, `ROWS`, `COLUMNS`, structured references |

**`INDIRECT`/`OFFSET` volatility note:** These are marked volatile because the engine cannot statically resolve which cells they depend on. A sufficiently advanced engine could optimize constant-argument cases. **[UNRESOLVED: U-07 — canonical volatile set, U-04b — OFFSET constant-arg optimization]**

**[CONFORMANCE: ECMA-376 §18.17.5.1 — volatile function list. Spec mandates only NOW, TODAY, RAND, RANDBETWEEN. INDIRECT/OFFSET volatility is observable behavior.]**

#### 1.3.2 Metadata Schema per Function

```text
FunctionMeta = {
  strictness:    strict | branch_lazy | eager_logical | mask_any | mask_na | aggregate_policy,
  volatility:    pure | volatile_epoch | volatile_once,
  host_context:  set(locale, timezone, date_system, ui_state),
  externality:   none | sync | async,
  ref_sensitivity: value_only | address_sensitive | shape_sensitive
}
```

Every function in the catalog MUST declare all five metadata fields. These drive dependency graphing, recalc scheduling, and cache invalidation.

---

### 1.4 Value-to-Display Formatting Semantics *(Prompt Item 4)*

#### 1.4.1 Formatting Pipeline

The separation between computed value and displayed text is fundamental:

```text
raw_value       = Eval(cell.formula)
cf_style_delta  = EvalConditionalFormatting(cell, raw_value, sheet_state)
effective_style = Merge(base_style, cf_style_delta, priority_order)
display_text    = Render(raw_value, effective_style.number_format, locale, date_system, column_width)
```

Formally: `P: Value × FormatString × Locale × DateSystem × Width → RenderedText`

Calculations always operate on `raw_value`, never on `display_text`. Formatting is a pure rendering projection.

#### 1.4.2 Number Format Semantics

A number format string has up to four sections separated by `;`:

```
positive_format ; negative_format ; zero_format ; text_format
```

- 1 section: applies to all numbers; text passes through unformatted.
- 2 sections: first for positive+zero, second for negative.
- 3 sections: positive; negative; zero. Text unformatted.
- 4 sections: positive; negative; zero; text.

**The `General` format:**
- Displays up to 11 significant characters (including decimal point, minus sign).
- Suppresses trailing zeros after decimal point.
- Switches to scientific notation if the number exceeds display width.
- Shows integers without decimal point.
- Dates stored as numbers display as numbers under General.

**[CONFORMANCE: ECMA-376 §18.8.31 — numFmt format codes.]**

#### 1.4.3 Date/Time Encoding

Dates/times are stored as serial numbers (doubles):
- Integer part: days since epoch (1900-01-00 in 1900 system, 1904-01-01 in 1904 system).
- Fractional part: fraction of a 24-hour day.
- **Lotus 1-2-3 bug:** 1900 date system incorrectly treats 1900 as a leap year. Serial 60 = non-existent Feb 29, 1900. Preserved for backward compatibility.

**[CONFORMANCE: ECMA-376 §18.17.4.1 — date serial number encoding.]**

#### 1.4.4 Conditional Formatting Interaction Points

- CF rules evaluate **after** formula values are available, **before** final display rendering.
- CF formula rules use same coercion/error semantics as normal formulas, anchored to rule range origin.
- Rules are evaluated in priority order (user-defined).
- `stopIfTrue` on a matching rule halts subsequent rule evaluation.
- Multiple non-conflicting rules can stack (fill + font from different rules).
- CF may override number format, changing display text without changing value.
- CF MUST NOT alter formula value or feed back into the evaluation tree.
- Data bars/color scales/icon sets derive from raw numeric domain; handling of errors/blanks needs conformance lock. **[UNRESOLVED: U-08]**

**[CONFORMANCE: ECMA-376 §18.3.1.10 — conditionalFormatting; §18.3.1.12 — cfRule with stopIfTrue.]**

#### 1.4.5 Input Parsing Side Effects on Formatting

When a user enters a value, the input parser may auto-apply formatting:

| Input | Stored Value | Auto-Applied Format |
|---|---|---|
| `42` | Number 42 | General (no change) |
| `3/1/2026` | Serial number | Date format (e.g., `m/d/yyyy`) |
| `$1,234.56` | Number 1234.56 | Currency `$#,##0.00` |
| `10%` | Number 0.1 | Percentage `0%` |
| `1:30 PM` | Fraction 0.5625 | Time `h:mm AM/PM` |

This is a **UI-level side effect**, not an evaluation semantic. Programmatic writes do not trigger auto-format. **[UNRESOLVED: U-15 — format persistence when formula overwrites previously auto-formatted cell]**

---

### 1.5 Unresolved Questions *(Prompt Item 5)*

| Tag | Uncertainty | Evidence Required | Source |
|---|---|---|---|
| **U-01** | Cross-type comparison semantics (Num vs Text vs Bool) for `=`,`<`,`>` — and string collation locale dependency | Matrix workbook across locales; Turkish İ/i and German ß edge cases | ECMA §18.17.3.1 |
| **U-02** | Text-to-bool coercion in logical contexts (`"TRUE"`, other text) | Formula grid in `IF`, `NOT`, direct boolean tests | S5, S6, S7 |
| **U-03** | `AND`/`OR` eagerness vs short-circuit (scalar and array cases) | `AND(FALSE,1/0)` and array variants | S6, S7 |
| **U-04** | `IF` branch laziness consistency under dynamic arrays/volatile args | `IF(FALSE,1/0,1)` and spill-array branch cases | S5, S2 |
| **U-05** | Scalarization/implicit intersection behavior in modern array mode vs legacy | Legacy workbook import + `@` operator differential tests | S3, S4 |
| **U-06** | Deterministic precedence when multiple errors exist in one expression/array | Dual-error operand and element-wise test matrix | S2 |
| **U-07** | Canonical volatile function set and trigger granularity | Recalc tracing with unchanged dependencies | S2 |
| **U-08** | CF precedence and number-format override semantics; data bars/icon sets on errors/blanks | Multi-rule workbook with `stopIfTrue` and format conflicts | S10, S11 |
| **U-09** | Locale-sensitive numeric text parsing during coercion | Same workbook under multiple locales | S11 |
| **U-10** | Async external error lifecycle (`GETTING_DATA`, `BLOCKED`, etc.) | Online/offline transition tests on external functions | S2 |
| **U-11** | Aggregator coercion: literal text arg vs referenced text cell | `SUM("1",2)` vs `SUM(A1,2)` where `A1="1"` | S1 |
| **U-12** | Boolean-to-string via `&` — locale-dependent? (`TRUE`/`FALSE` vs `VRAI`/`FAUX`) | Test `=TRUE&""` across English/French/German Excel | Empirical |
| **U-13** | `#SPILL!` vs internal calc error dominance | `#SPILL!` intersecting `#DIV/0!` — which is shown? | Empirical |
| **U-14** | Volatile-once function class — does it exist in Excel or is it Calc-only? | Monitor recalc count for `INFO("directory")`, `CELL("filename")` across triggers | LibreOffice internals, empirical |
| **U-15** | Format persistence when formula overwrites previously auto-formatted cell | Set date format via input; write formula producing a number; observe display | Empirical |
| **U-16** | Volatility cascade: volatile function inside untaken `IF` branch in dynamic array formula — does spill array become volatile? | `IF(FALSE, RAND(), SEQUENCE(5))` recalc behavior | Empirical |
| **U-17** | `#CALC!` error propagation precedence vs legacy errors | Cross-reference MS-VBAL docs + empirical | Empirical |

---

## 2. Conflict Resolution Notes

| Topic | Codex | Claude | Gemini | Resolution |
|---|---|---|---|---|
| **Value domain** | Includes `Ref(RefSet)` and `Arr` as first-class types in the domain | Lists Array and Empty as types but Ref only implicitly | Distinguishes scalar vs compound (Array, Reference) | **Adopted Codex's explicit `Ref` + `Arr` in the algebraic type** plus Claude's observation that these are intermediate (not storable). |
| **Error token model** | `ErrorToken(origin_index, code, phase)` with `phase ::= bind | eval | spill | async` | No formal token structure; describes temporal preemption narratively | No formal structure | **Adopted Codex's `ErrorToken` formalism** — the `phase` tag and `origin_index` give deterministic behavior. Supplemented with Claude's temporal preemption insight (`#NAME?` at parse, `#REF!` at adjust). |
| **Error priority lattice** | "No formal priority lattice" — eval-order deterministic | Explicitly states "no formal priority lattice... common misconception" | Mentions "propagation lattice" suggesting precedence exists | **Resolved in favor of Codex+Claude**: there is no error severity ordering. Propagation is purely eval-order (leftmost-first). Gemini's "lattice" language was imprecise and the body text actually describes eval-order semantics too. |
| **Comparison semantics** | Defers to U-01 with minimal detail | Full type-rank ordering (Num < String < Bool) with Empty behavior | No detail | **Adopted Claude's type-rank model** — it's well-cited (ECMA §18.17.3.1) and provides actionable specification. Still tagged U-01 for locale-specific collation edge cases. |
| **Volatile-once class** | Not mentioned | Identifies as a possible class; flags as uncertainty | Not mentioned | **Included as U-14** — Claude correctly notes it's documented in LibreOffice internals but unconfirmed for Excel. |
| **Function metadata schema** | Provides concrete `FunctionMeta` struct with 5 fields | Implicit in classification table | Uses mathematical set notation (P, V, E, S) | **Adopted Codex's `FunctionMeta` schema** as the normative machine-readable format. Gemini's set notation is useful for proofs but not for implementation metadata. |
| **Aggregate-scanning coercion** | Mentions U-11 (literal vs ref difference) | Provides concrete `SUM(A1)` vs `SUM(TRUE)` example with explanation | Not covered | **Adopted Claude's detailed example** — this range-skip vs direct-coerce duality is a critical implementation detail. |
| **CF interaction** | Pipeline-style (`EvalCF → Merge → Render`) | Detailed evaluation order with `stopIfTrue` and stacking rules | Mathematical projection notation | **Merged Codex pipeline with Claude's operational detail** and Gemini's formal notation for the principle. |
| **Input parsing side effects** | Not covered | Detailed table of input→stored-value→auto-format mappings | Not covered | **Adopted Claude's section** — this UI-level side effect is important to document even though it's outside eval semantics proper. |
| **`#SPILL!` vs `#CALC!` precedence** | Not specifically addressed | Not specifically addressed | Raises as UNCERTAINTY-02 | **Added as U-17** — a valid gap unique to Gemini's output. |
| **Volatility in untaken branches** | Not addressed | Not addressed | Raises as UNCERTAINTY-01 | **Added as U-16** — important edge case for dynamic array engines. |
| **String comparison locale** | Tagged U-01 | Tagged UNCERTAINTY-01 with specific examples (Turkish İ/i, German ß) | Not covered | **Merged**: adopted Claude's specific edge-case examples into Codex's U-01 framing. |

---

## 3. Residual Uncertainties

**High confidence (all three agree):**
- Value type universe (5 scalar + 2 intermediate types) — settled.
- Coercion direction tables for NumCtx, BoolCtx, TextCtx — settled in broad strokes.
- Error propagation is leftmost-first by eval order, not by error severity — settled.
- Formatting never mutates computed value — settled.
- CF evaluates after formula values, before display — settled.

**Medium confidence (two agree, one silent or vague):**
- Operator precedence table — only Claude provided detail, but it's well-sourced (ECMA §18.17.3). Treat as settled pending empirical spot-check.
- Type-rank comparison — only Claude provided, but well-cited. Treat as settled.
- `FunctionMeta` schema fields — Codex's five fields are reasonable but the exact enum values for `strictness` and `ref_sensitivity` need validation against the full function catalog.

**Low confidence / genuinely open (tagged U-*):**
- U-01 through U-17 as listed above. The highest-priority items for the next empirical pass are:
  - **U-03** (`AND`/`OR` eagerness) — directly affects engine correctness.
  - **U-04** (`IF` laziness under dynamic arrays) — directly affects engine correctness.
  - **U-05** (implicit intersection / `@` operator) — foundational array-mode behavior.
  - **U-06** (multi-error determinism) — affects test reproducibility.
  - **U-11** (aggregator coercion duality) — affects `SUM`/`AVERAGE`/etc. correctness.

---

## 4. Immediate Next Actions

1. **Build conformance workbook suite for U-01..U-17.** Each unresolved item needs an `.xlsx` test fixture with expected outputs documented. Prioritize U-03, U-04, U-05, U-06, U-11 as they directly affect engine correctness.

2. **Create machine-readable `FunctionMeta` registry.** Codex's schema should be instantiated for at least the 50 most-used functions, with CI enforcing metadata completeness. Start with the functions explicitly classified in this pass.

3. **Implement origin-indexed `ErrorToken` model.** Adopt Codex's `(origin_index, ErrorCode, phase)` representation in the engine spec. This provides determinism guarantees needed for parallel evaluation.

4. **Promote settled content to `CORE_ENGINE_FORMAL_MODEL.md`.** The value type universe, coercion matrix, error propagation rules (leftmost-first), function classification taxonomy, and formatting pipeline can be promoted now — with `UNRESOLVED(U-xx)` markers inline for the open items.

5. **Gate remaining promotions on U-* closure.** Each U-* tag requires a passing conformance fixture before the associated spec text drops its `UNRESOLVED` marker.

6. **Schedule dedicated follow-up passes** for topics deferred by all three models:
   - Array/spill semantics (implicit intersection, dynamic array resize, CSE legacy)
   - `LAMBDA`/`LET` scoping rules
   - Locale/i18n input parsing
   - Circular reference handling
   - RTD lifecycle model
