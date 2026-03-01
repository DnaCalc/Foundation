# Run 20260301-203623-cell-abstraction-pass-01-model-frame

## 1. Scope And Assumptions

**In scope.** Everything that happens *inside* a single cell from input acceptance through value resolution and display. Specifically:

- Parsing user input into a cell-input representation
- Classifying the cell-input (empty, literal, formula)
- Evaluating a formula expression to a value, given an environment of resolved references
- Implicit type coercion at operator and function-argument boundaries
- Value typing (the cell's resolved type tag)
- Formatting a value into a display string
- Empty-cell semantics (the behavioral meaning of "nothing")

**Out of scope** (per brief constraint — do not re-specify unless needed for in-cell semantics):

- Workbook-level dependency graph construction and topological scheduling
- Cross-sheet and cross-workbook reference resolution mechanics
- Volatile/non-volatile recalculation policy
- Concurrency and multi-threaded calc

**Boundary assumption.** The cell receives its *reference environment* (the resolved values of all cells it depends on) as a given input. How that environment is assembled is the calc-graph's job, not the cell's.

**Domain-neutrality assumption.** Names, notation, and domain boundaries are chosen to be specializable to Excel but not dependent on it. Excel is treated as the primary *conformance anchor*, not as the definition.

---

## 2. Response To Prompt Sequence

### 2.1 — Abstract Domains And Entities

Six domains are needed. Each is listed with its role and constituent entities.

**Domain A — Input (what the user commits to the cell)**

| Entity | Description |
|---|---|
| `RawInput` | The byte/character sequence the user submits (pre-parse). |
| `CellInput` | The parsed, classified result. Tagged union: `Empty`, `Literal(v)`, `Formula(ast)`. |
| `ParseRule` | The heuristic or grammar that maps `RawInput → CellInput`. This is where quote-prefix, leading-equals, and auto-type-detection live. |

**Domain B — Expression (the structure of a formula)**

| Entity | Description |
|---|---|
| `Expr` | AST node. Leaf nodes: `Ref(addr)`, `Lit(v)`, `Name(n)`. Interior nodes: `BinOp(op, l, r)`, `UnaryOp(op, e)`, `FnCall(name, args)`, `Array(rows)`. |
| `Addr` | Abstract cell address. Parameterized by style (A1, R1C1) only at parse/serialize boundaries; internally a `(sheet?, row, col)` triple with absolute semantics. |

**Domain C — Value (the resolved content of a cell)**

| Entity | Description |
|---|---|
| `CellValue` | Tagged union over a closed set of value types. |
| `ValTag` | The discriminator: `Num`, `Text`, `Bool`, `Error`, `Empty`, `Array`. |
| `ErrorKind` | Sub-discriminator for errors: `DIV0`, `VALUE`, `REF`, `NAME`, `NULL`, `NUM`, `NA`, `SPILL`, `CALC`, `GETTING_DATA`, etc. |

The `Empty` tag deserves special treatment — it is *not* the same as `Text("")` or `Num(0)`, even though coercion may map it to those. A cell that has never been touched is `Empty`; a cell containing `=""` is `Text("")`.

**Domain D — Coercion (implicit type conversion)**

| Entity | Description |
|---|---|
| `CoercionContext` | The expected type at a particular position: `WantNum`, `WantText`, `WantBool`, `WantAny`. |
| `CoercionRule` | A partial function `(CellValue, CoercionContext) → CellValue`. If undefined, produces `Error(VALUE)`. |

Coercion is the single largest source of subtle behavioral difference across engines. It must be modeled explicitly rather than folded into evaluation.

**Domain E — Evaluation (resolving an expression to a value)**

| Entity | Description |
|---|---|
| `Env` | A mapping `Addr → CellValue` representing the resolved reference environment. |
| `EvalJudgment` | The core judgment: given `Env` and `Expr`, produce `CellValue`. |

**Domain F — Presentation (formatting a value for display)**

| Entity | Description |
|---|---|
| `NumberFormat` | A format code (e.g., `#,##0.00`, `yyyy-mm-dd`, `0%`). Structured as up to four sections: positive; negative; zero; text. |
| `DisplayString` | The rendered output string. |
| `FormatJudgment` | `(CellValue, NumberFormat) → DisplayString`. |

---

### 2.2 — Notation And Judgment Forms

The following notation is intended for a living document — readable by engineers, precise enough to anchor conformance tests, but not requiring a proof assistant.

**Environments and lookup:**

```
Γ : Addr → CellValue          -- reference environment
Γ(a) = v                      -- lookup; Γ(a) = Empty if a ∉ dom(Γ)
```

**Evaluation judgment:**

```
Γ ⊢ e  ⇓  v
```

Read: "In environment Γ, expression e evaluates to value v."

Core rules (sketch):

```
────────────────────────  [E-Lit]
Γ ⊢ Lit(v)  ⇓  v

Γ(a) = v
────────────────────────  [E-Ref]
Γ ⊢ Ref(a)  ⇓  v

Γ ⊢ e₁ ⇓ v₁    v₁ ▷ Num ⇒ n₁
Γ ⊢ e₂ ⇓ v₂    v₂ ▷ Num ⇒ n₂
n₂ ≠ 0
──────────────────────────────────  [E-Div]
Γ ⊢ BinOp(/, e₁, e₂)  ⇓  Num(n₁/n₂)

Γ ⊢ e₂ ⇓ v₂    v₂ ▷ Num ⇒ Num(0)
──────────────────────────────────  [E-Div0]
Γ ⊢ BinOp(/, e₁, e₂)  ⇓  Error(DIV0)
```

**Coercion judgment:**

```
v ▷ τ  ⇒  v'
```

Read: "Value v coerced toward type τ yields v'." Undefined cases produce `Error(VALUE)`.

**Formatting judgment:**

```
v ⊕ fmt  ⇒  s
```

Read: "Value v formatted under format code fmt yields display string s."

**Parse judgment:**

```
raw  ⊳  ci
```

Read: "Raw input string raw is parsed to CellInput ci."

**Cell lifecycle (composite):**

A full cell update for a formula cell is the composition:

```
raw ⊳ Formula(e)    Γ ⊢ e ⇓ v    v ⊕ fmt ⇒ s
─────────────────────────────────────────────────
         raw  ⟹[Γ, fmt]  (v, s)
```

For a literal cell, the `⊢ ⇓` step is trivially `Lit(v) ⇓ v`.

---

### 2.3 — Excel-Anchored Examples

Each example is tagged with the domain it exercises. Names use the abstract model; Excel-specific terms appear in parentheses.

**Domain A — Input / Parse**

| RawInput | CellInput | Notes |
|---|---|---|
| _(nothing)_ | `Empty` | Cell never touched. |
| `42` | `Literal(Num(42))` | Numeric auto-detection. |
| `hello` | `Literal(Text("hello"))` | No leading `=`, not a number. |
| `'42` | `Literal(Text("42"))` | Quote-prefix forces text. Excel stores the prefix flag; the `'` is not part of the value. |
| `=A1+1` | `Formula(BinOp(+, Ref((nil,1,1)), Lit(Num(1))))` | Standard formula. |
| `=1/0` | `Formula(BinOp(/, Lit(Num(1)), Lit(Num(0))))` | The error arises at *evaluation*, not parse. |
| `3/14/2026` | `Literal(Num(46112))` | Date auto-detection — locale dependent. The *stored* value is a serial number. |

**Domain C — Value / ValTag**

| Expression (Excel syntax) | Resolved CellValue | ValTag |
|---|---|---|
| `=1+1` | `Num(2)` | Num |
| `="hello"&" world"` | `Text("hello world")` | Text |
| `=TRUE` | `Bool(TRUE)` | Bool |
| `=1/0` | `Error(DIV0)` | Error |
| _(empty cell)_ | `Empty` | Empty |
| `=""` | `Text("")` | Text — distinct from Empty |

**Domain D — Coercion**

| Context | Input value | Coercion result | Rule key |
|---|---|---|---|
| `WantNum` (arithmetic operator) | `Text("2")` | `Num(2)` | Text→Num parse succeeds |
| `WantNum` | `Text("hello")` | `Error(VALUE)` | Text→Num parse fails |
| `WantNum` | `Bool(TRUE)` | `Num(1)` | Bool→Num: TRUE→1, FALSE→0 |
| `WantNum` | `Empty` | `Num(0)` | Empty→Num: always 0 |
| `WantText` (& operator) | `Num(42)` | `Text("42")` | Num→Text: unformatted decimal |
| `WantText` | `Bool(TRUE)` | `Text("TRUE")` | Bool→Text |
| `WantText` | `Empty` | `Text("")` | Empty→Text: empty string |
| `WantBool` | `Num(0)` | `Bool(FALSE)` | Num→Bool: 0→FALSE, nonzero→TRUE |
| `WantBool` | `Empty` | `Bool(FALSE)` | Empty→Bool: FALSE |

**Domain E — Evaluation (compound example)**

Cell B2 contains `=A1+A2*2`. Environment: `Γ = {A1: Num(10), A2: Text("3")}`.

```
Γ ⊢ Ref(A2) ⇓ Text("3")
Text("3") ▷ Num ⇒ Num(3)        -- coercion at * boundary
Γ ⊢ BinOp(*, Ref(A2), Lit(2))  ⇓  Num(6)
Γ ⊢ Ref(A1) ⇓ Num(10)
Γ ⊢ BinOp(+, Ref(A1), …)      ⇓  Num(16)
```

**Domain F — Presentation**

| CellValue | NumberFormat (Excel code) | DisplayString |
|---|---|---|
| `Num(0.5)` | `0%` | `50%` |
| `Num(46112)` | `yyyy-mm-dd` | `2026-03-14` |
| `Num(1234.5)` | `#,##0.00` | `1,234.50` |
| `Num(-5)` | `#,##0;(#,##0)` | `(5)` |
| `Text("hello")` | `@` | `hello` |
| `Bool(TRUE)` | _(General)_ | `TRUE` |

---

## 3. Uncertainties And Evidence Needs

Each item classified as **spec-gap** (ECMA-376/ISO 29500 is silent or ambiguous) or **empirical-gap** (spec may speak but behavior must be verified in Excel).

### Spec-gaps

| ID | Topic | Detail |
|---|---|---|
| SG-1 | **Empty vs. blank vs. zero-length string** | The spec uses "blank" inconsistently. Is a cell containing `=""` "blank" for purposes of COUNTBLANK? (Empirical evidence says yes, but the spec text is unclear.) |
| SG-2 | **Coercion table completeness** | ECMA-376 Part 1 §18.17.2 defines implicit intersection and some coercions, but the full coercion matrix (every ValTag × every CoercionContext) is not tabulated. |
| SG-3 | **Error precedence in multi-argument functions** | When a function receives two error-valued arguments, which error propagates? The spec does not mandate left-to-right. |
| SG-4 | **Quote-prefix semantics** | The spec defines the `quotePrefix` attribute on `xf` but does not specify evaluation implications (e.g., does a quote-prefixed cell coerce to 0 in numeric context, or to `#VALUE!`?). |
| SG-5 | **Dynamic array spill semantics** | Not present in ECMA-376 5th edition. Entirely a post-spec feature. |

### Empirical-gaps

| ID | Topic | Detail | Verification method |
|---|---|---|---|
| EG-1 | **Num→Text coercion precision** | When `=1/3&""` is evaluated, how many decimal digits appear? Is it the same as General format? | Test in Excel; compare across builds. |
| EG-2 | **Date serial boundary** | Does Excel (Windows) accept serial number 0 as a valid date? What does `=TEXT(0,"yyyy-mm-dd")` return? What about the Lotus 1-2-3 Feb 29, 1900 bug (serial 60)? | Test in Excel; known historical issue but must confirm current behavior. |
| EG-3 | **Coercion of Error values** | Is `Error ▷ Num` always an error propagation, or do some functions trap errors before coercion? (E.g., AGGREGATE, IFERROR.) | Construct test matrix: each error kind × representative functions. |
| EG-4 | **Format code parsing edge cases** | Four-section format codes with color tokens, conditions (`[>100]`), locale codes (`[$-409]`). Behavior when sections are malformed. | Build format-code test corpus. |
| EG-5 | **Empty cell in boolean context for IF** | `=IF(A1, "yes", "no")` where A1 is empty. Does Empty coerce to FALSE or does IF treat empty specially? | Test; compare with `=IF(0,…)` and `=IF("",…)`. |
| EG-6 | **LAMBDA / LET scoping** | Are LAMBDA-bound names lexically scoped? Can a LAMBDA close over a LET binding? | Construct nested scope tests. |

---

## 4. Promotion-Ready Draft Content

The following is ready to be promoted into a living formal-model document, subject to editorial pass.

---

### Cell Abstraction — Formal Model (Draft v0.1)

#### 4.1 Value Domain

```
CellValue  ::=  Num(n)           where n ∈ IEEE 754 double
             |  Text(s)          where s ∈ UTF-16 string
             |  Bool(b)          where b ∈ {TRUE, FALSE}
             |  Error(ek)        where ek ∈ ErrorKind
             |  Empty
             |  Array(rows)      where rows : [[CellValue]]

ErrorKind  ::=  DIV0 | VALUE | REF | NAME | NULL | NUM | NA
             |  SPILL | CALC | GETTING_DATA | BLOCKED | CONNECT | ...
```

**Conformance note.** `Num` uses IEEE 754 binary64. Excel further constrains to 15 significant digits for display. The `Array` variant covers dynamic-array spill; it is post-ECMA-376 and flagged as extension.

#### 4.2 Cell Input Classification

```
CellInput  ::=  Empty
             |  Literal(v : CellValue)
             |  Formula(e : Expr)

raw ⊳ ci    (parse judgment)
```

**Parse rules (Excel specialization):**

1. If `raw` is the empty string or the cell has never been written → `Empty`.
2. If `raw` starts with `=` → `Formula(parse_formula(raw[1..]))`.
3. If `raw` starts with `'` → `Literal(Text(raw[1..]))`, with quote-prefix flag.
4. If `raw` is numeric (per locale-sensitive grammar) → `Literal(Num(parse_number(raw)))`.
5. If `raw` matches a date pattern (locale-sensitive) → `Literal(Num(date_to_serial(raw)))`.
6. If `raw` is `TRUE` or `FALSE` (case-insensitive) → `Literal(Bool(...))`.
7. Otherwise → `Literal(Text(raw))`.

Rule priority is as listed. This ordering is a critical conformance target.

#### 4.3 Coercion Matrix

| Source ↓ / Target → | `WantNum` | `WantText` | `WantBool` |
|---|---|---|---|
| `Num(n)` | `Num(n)` | `Text(decimal(n))` | `Bool(n≠0)` |
| `Text(s)` | `Num(parse(s))` or `Error(VALUE)` | `Text(s)` | `Error(VALUE)` ᵃ |
| `Bool(b)` | `Num(b ? 1 : 0)` | `Text(b ? "TRUE":"FALSE")` | `Bool(b)` |
| `Empty` | `Num(0)` | `Text("")` | `Bool(FALSE)` |
| `Error(ek)` | `Error(ek)` — propagates | `Error(ek)` — propagates | `Error(ek)` — propagates |

ᵃ — Some functions (e.g., IF condition) accept `Text("TRUE")` → `Bool(TRUE)`. This is function-level override, not general coercion. Needs empirical confirmation (→ EG-5).

#### 4.4 Evaluation Judgment

```
Γ ⊢ e  ⇓  v
```

**Error propagation convention.** In the default case, if any sub-expression evaluates to `Error(ek)`, the enclosing expression evaluates to `Error(ek)`. Functions that suppress errors (IFERROR, IFNA, AGGREGATE) override this at the function-call rule level.

#### 4.5 Format Judgment

```
v ⊕ fmt  ⇒  s
```

Format codes follow ECMA-376 §18.8.31 (numFmt). The format engine is a pure function from `(CellValue, NumberFormat) → DisplayString`. It does not alter the stored value.

**Key invariant:** `v` is always recoverable from the cell — formatting is lossy on display only, never on storage.

---

## 5. Follow-Up Backlog

| Priority | Item | Depends on |
|---|---|---|
| **P0** | Build empirical test matrix for coercion (EG-1 through EG-5). Run against Excel desktop and Excel Online. | Conformance corpus tooling |
| **P0** | Verify parse-rule priority order (§4.2) against Excel. Especially date auto-detection vs. numeric. | Empirical pass |
| **P1** | Draft full `Expr` AST grammar with operator precedence table. Cross-ref to ECMA-376 §18.17. | Spec-pack |
| **P1** | Extend coercion matrix with `WantArray` context for dynamic-array functions. | SG-5 resolution |
| **P1** | Formalize error-precedence rule (SG-3). Propose left-to-right default, verify empirically. | Empirical pass |
| **P2** | Model LAMBDA/LET scoping (EG-6). Determine if `Env` needs a lexical-scope stack or if flat environment suffices. | Empirical pass |
| **P2** | Format-code parser: formalize the four-section grammar, including conditional and locale tokens (EG-4). | Spec-pack §18.8.31 |
| **P3** | Investigate whether the model needs a `Pending` or `Calculating` state for async functions (STOCKHISTORY, web queries). | Scope decision |
| **P3** | Cross-engine comparison: run coercion and parse tests against Google Sheets and LibreOffice Calc to establish portability envelope. | After Excel baseline |
