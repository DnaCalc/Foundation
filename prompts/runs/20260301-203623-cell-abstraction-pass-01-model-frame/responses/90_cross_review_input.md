# Cross Review Input
Run id: 20260301-203623-cell-abstraction-pass-01-model-frame

## Codex Base Output
## 1. Scope And Assumptions

**Trace anchors from the provided run text**
- `RB-1`: Build a rigorous but practical abstraction for in-cell behavior.
- `RB-2`: Must specialize to Excel and be reusable in other domains.
- `RB-3`: Keep conformance traceability explicit.
- `RB-4`: Separate current-state facts from proposal choices.
- `RB-5`: Do not re-specify workbook-wide scheduling/calc graph unless needed.
- `PS-1..4`: Execute the four prompt-sequence tasks.

**Current-state facts (from prompt text only)**
| ID | Fact | Trace |
|---|---|---|
| `F-1` | Target is in-cell semantics abstraction. | `RB-1` |
| `F-2` | Excel is a required specialization target. | `RB-2` |
| `F-3` | Cross-domain reuse is required. | `RB-2` |
| `F-4` | Traceability must be explicit. | `RB-3` |
| `F-5` | Facts vs proposals must be separated. | `RB-4` |
| `F-6` | Workbook-level scheduling is out of scope unless required by cell semantics. | `RB-5` |

**Proposal-level choices in this response**
| ID | Choice | Why | Trace |
|---|---|---|---|
| `P-1` | Use a profile-parameterized semantics (`Profile` as pluggable policy). | Enables Excel specialization + reuse. | `F-2`,`F-3`,`PS-2` |
| `P-2` | Model one cell evaluation against a provided snapshot context. | Avoids calc-graph respecification. | `F-6` |
| `P-3` | Represent result as `(value or error, deps, events)`. | Supports conformance + debugging. | `F-4`,`PS-2` |
| `P-4` | Include explicit gap typing (`spec-gap`, `empirical-gap`). | Makes uncertainty actionable. | `PS-4` |

---

## 2. Response To Prompt Sequence

### 2.1 Extract abstract domains and entities for in-cell behavior

| Domain ID | Abstract domain | Core entities | Excel-anchored example | Reuse note |
|---|---|---|---|---|
| `D-1` | Addressing | `CellId`, `Ref`, `RangeRef` | `A1`, `B2:C4` | Any grid/table DSL can map here. |
| `D-2` | Cell input syntax | `CellInput` (`literal` or `formula`), `Expr` AST | `=A1+2` parses to `Add(Ref(A1),Num(2))` | Works for SQL computed columns, BI measures, rule engines. |
| `D-3` | Evaluation context | `Snapshot` (reference->observed value/error), `Ambient` | Referenced cells resolved from current sheet/workbook state | Snapshot abstraction decouples from scheduler. |
| `D-4` | Value space | `Scalar`, `Blank`, `ArrayValue`, `ErrorValue` | Number/text/boolean/error, spill arrays | Domain-neutral typed value algebra. |
| `D-5` | Coercion policy | `CoercionContext`, `CoercionRule` | Text `"2"` coerced in arithmetic context | Policy profile controls engine-specific conversions. |
| `D-6` | Operators/functions | `OpSem`, `FuncSem`, `Registry` | `SUM(A1:A3)`, `IF(...)` | Registry pattern generalizes to other formula languages. |
| `D-7` | Error semantics | `ErrorKind`, `PropagationRule`, `InterceptRule` | `#DIV/0!`, `IFERROR(...)` | Cross-domain error lattice can vary by profile. |
| `D-8` | Observation/trace | `DepSet`, `EventLog`, `EvalTraceId` | Reads `{A1,B1}`, invoked `/` | Required for conformance replay and diagnostics. |
| `D-9` | Determinism boundary | `AmbientToken` (time/random/locale) | `NOW()`, `RAND()` depend on ambient inputs | Keeps volatile behavior explicit and testable. |

**Entity set (minimal)**
- `CellState = { id, input }`
- `EvalRequest = { cellId, snapshot, profile, ambient }`
- `EvalResult = Ok(value, deps, events) | Fail(error, deps, events)`
- `ConformanceCase = { caseId, request, expectedResult, evidenceRef }`

### 2.2 Notation and judgment forms for a living formal model

**Core notation**
- `Π`: profile (Excel or other engine policy bundle)
- `Σ`: reference snapshot
- `Λ`: operator/function semantics registry
- `Ξ`: ambient tokens (time/random/locale/etc.)
- `e`: normalized expression
- `ρ`: evaluation result

**Judgments**
1. Parse/normalize: `Π ⊢ input ⇝ e | parseErr`
2. Reference resolution: `Σ ⊢ ref ↦ v | err`
3. Coercion: `Π, κ ⊢ v ⇢ v' | err`
4. Expression evaluation: `⟨Λ, Π, Σ, Ξ⟩ ⊢ e ⇓ ρ`
5. Cell evaluation: `⟨cell, Λ, Π, Σ, Ξ⟩ ⇓ ρ`
6. Conformance: `Impl(profile=Π) ⊨ caseId` iff observed result equals expected under declared comparison rule.

**Living-doc metadata per rule**
- `RuleId`
- `Status` (`draft`, `provisional`, `validated`)
- `ProfileScope` (`core`, `excel`, `domain-x`)
- `Evidence` (spec citation and/or test artifact id)

### 2.3 Excel-anchored examples per domain (without overfitting names)

| Domain | Abstract statement | Excel anchor |
|---|---|---|
| `D-1` | Resolve a reference to a value in snapshot context. | `Ref(A1)` resolves to current observed `A1`. |
| `D-2` | Formula text becomes an AST before evaluation. | `=A1+2` -> `Add(Ref(A1),2)`. |
| `D-3` | Cell semantics consume a supplied snapshot, not schedule logic. | Evaluate `B1` using already-available values for referenced cells. |
| `D-4` | Result may be scalar, array, blank, or error. | `SEQUENCE(2,2)` yields array value; `1/0` yields error. |
| `D-5` | Coercion depends on operation context. | In numeric addition, text numeral may coerce to number. |
| `D-6` | Function semantics are registry-driven. | `SUM` aggregates argument set using numeric accumulation rule. |
| `D-7` | Error propagation/interception is explicit. | `IFERROR(1/0,99)` intercepts error and returns fallback. |
| `D-8` | Evaluation emits dependency and event trace. | `=A1/B1` records reads of `A1`,`B1` and divide operation. |
| `D-9` | Volatile results depend on ambient token values. | `NOW()` depends on evaluation timestamp in `Ξ`. |

### 2.4 Ambiguities and missing evidence (classified)

| Gap ID | Question | Class |
|---|---|---|
| `G-1` | Exact coercion matrix by operator/function context. | `spec-gap` |
| `G-2` | Blank handling in arithmetic, comparison, and aggregation contexts. | `spec-gap` |
| `G-3` | Error precedence when multiple argument errors exist. | `spec-gap` |
| `G-4` | Dynamic-array spill conflict behavior in pure in-cell model boundary. | `spec-gap` |
| `G-5` | Cross-version differences (desktop/web/channel) for coercion edge cases. | `empirical-gap` |
| `G-6` | Floating-point corner behavior and equality tolerances in Excel conformance tests. | `empirical-gap` |
| `G-7` | Locale-sensitive parse/coercion variations for numeric/date text. | `empirical-gap` |

---

## 3. Uncertainties And Evidence Needs

| Priority | Gap ID | Evidence needed | Acceptance criterion |
|---|---|---|---|
| High | `G-1` | Normative rule table per operator/function context | Deterministic coercion outcomes for conformance suite |
| High | `G-2` | Explicit blank semantics document + executable tests | No ambiguity for `blank` in core operators |
| High | `G-3` | Error ordering/selection policy definition | Single reproducible expected error per case |
| Medium | `G-5` | Version matrix test runs (Excel desktop/web/build) | Profile flags capture observed divergence |
| Medium | `G-6` | Numerical edge-case corpus with expected outcomes | Stable tolerance/comparison rule in conformance harness |
| Medium | `G-7` | Locale-based parse/coercion test corpus | Locale token in `Ambient` fully explains outcome variance |
| Low | `G-4` | Boundary statement for spill interactions vs out-of-scope scheduling | Clear inclusion/exclusion in cell model section |

---

## 4. Promotion-Ready Draft Content

### In-Cell Semantics Core (Draft)

This section defines a profile-parameterized abstraction of **single-cell evaluation**. It is intentionally scoped to in-cell semantics and assumes referenced inputs are provided as a snapshot context.

A cell has `CellInput`, either a literal or a formula text. Formula text is normalized into an expression AST under a `Profile` (`Π`). Evaluation occurs against `(Σ, Λ, Ξ)`: a reference snapshot `Σ`, a semantics registry `Λ` for operators/functions, and ambient tokens `Ξ` (for volatile or locale-dependent behavior).

The primary judgment is:

`⟨cell, Λ, Π, Σ, Ξ⟩ ⇓ ρ`

where `ρ` is either:
- `Ok(value, deps, events)`, or
- `Fail(error, deps, events)`.

Supporting judgments are:
- `Π ⊢ input ⇝ e | parseErr`
- `Σ ⊢ ref ↦ v | err`
- `Π, κ ⊢ v ⇢ v' | err`
- `⟨Λ, Π, Σ, Ξ⟩ ⊢ e ⇓ ρ`

`deps` records resolved references used by evaluation. `events` records operation/function steps sufficient for conformance replay and diagnostics.

A profile supplies:
- syntax normalization rules,
- value/coercion policy,
- operator/function semantics,
- error taxonomy and propagation rules.

Excel specialization is one concrete profile instance. Other domains specialize by replacing profile policies without changing the core judgment forms.

Conformance is case-based. A conformance case is:
`{ caseId, profile, input, snapshot, ambient, expectedResult, evidenceRef }`.
An implementation conforms for a case when observed and expected results match under the case’s declared comparison rule.

This model does not define workbook scheduling or dependency graph recomputation. It only defines behavior once evaluation inputs for a specific cell are fixed.

---

## 5. Follow-Up Backlog

1. Define the `Profile` schema fields and freeze v1 keys.
2. Write the coercion decision table for arithmetic, comparison, logical, and aggregation contexts.
3. Define the error lattice and precedence/interception rules.
4. Create a minimal conformance case format (`json`) and 20 seed cases.
5. Add an Excel profile appendix mapping common Excel outcomes to core domains.
6. Run empirical validation across at least two Excel environments and record divergences.
7. Mark each rule with `draft/provisional/validated` and attach evidence ids.
8. Add explicit boundary text for spill/scheduling interactions to avoid scope creep.

## Claude Base Output
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


## Gemini Base Output
# Scope And Assumptions

**Scope:** 
This abstraction focuses strictly on the internal mechanics of a single cell—specifically, how a cell maintains its state, parses its content, and evaluates its expressions. The goal is to provide a formal language for "in-cell" semantics that maps cleanly to Excel's behavior but is generic enough to apply to other spreadsheet paradigms or reactive engines.

**Assumptions & Exclusions:**
- **Exclusion of Global Scheduling:** We assume the existence of an external calculation engine that determines *when* a cell evaluates. This model does not specify the topological sort or dependency graph traversal.
- **Pure Evaluation (Mostly):** We assume the cell evaluation function is generally pure with respect to its provided environment, handling volatility or non-determinism via explicit environment context rather than hidden side effects.
- **Cell as the Atomic Unit:** The cell is treated as the fundamental unit of state. Rendering, UI concerns, and macro/VBA side effects out-of-bounds of standard formula evaluation are excluded.

---

# Response To Prompt Sequence

### 1. Abstract Domains and Entities

To model in-cell behavior, we need the following abstract domains:

*   **`AddressSpace` ($A$):** The addressing scheme used to uniquely identify a cell within the system.
*   **`Value` ($V$):** The semantic result of an evaluation. This includes primitives (Numbers, Strings, Booleans), complex types (Arrays, Matrices), and explicit Error states.
*   **`Expression` ($E$):** The internal representation (AST) of a cell's formula or literal value before evaluation.
*   **`Environment` ($\Gamma$):** The external context required to evaluate an expression. This includes a mapping of `AddressSpace -> Value` (to resolve references) and ambient state (e.g., system time for volatile functions, locale settings).
*   **`CellState` ($S$):** The comprehensive internal state of a cell, defined as a tuple of its raw input, its parsed `Expression`, its current evaluated `Value`, and metadata (formatting, parse errors).

### 2. Proposed Notation and Judgment Forms

For a living formal model document, standard operational semantics notation is recommended:

*   **Evaluation Judgment:** $\Gamma \vdash e \Downarrow v$
    *   *Reads as:* Under environment $\Gamma$, expression $e$ evaluates to value $v$.
*   **Cell State Transition:** $S \xrightarrow{update} S'$
    *   *Reads as:* A cell in state $S$ transitions to state $S'$ after an update event (e.g., user edit or recalculation).
*   **Reference Resolution:** $\Gamma(a) = v$
    *   *Reads as:* Looking up address $a$ in environment $\Gamma$ yields value $v$.
*   **Typing/Validity (Optional but useful for coercion):** $\Gamma \vdash e : \tau$
    *   *Reads as:* Under environment $\Gamma$, expression $e$ has type $\tau$.

### 3. Excel-Anchored Examples

*   **`AddressSpace`:** 
    *   *Excel Anchor:* `Sheet1!A1` or `R1C1`. 
    *   *Abstract Domain:* `Coordinate(x: 1, y: 1, namespace: "Sheet1")`.
*   **`Value`:** 
    *   *Excel Anchor:* `#DIV/0!`, `42.5`, `"Total"`. 
    *   *Abstract Domain:* `Error(DivByZero)`, `Float(42.5)`, `Text("Total")`.
*   **`Expression`:** 
    *   *Excel Anchor:* `=SUM(A1:A10) + B1`. 
    *   *Abstract Domain:* `Add( Call("SUM", Range(Coord(1,1), Coord(1,10))), Ref(Coord(2,1)) )`.
*   **`Environment`:** 
    *   *Excel Anchor:* The workbook's current calculation state and the OS clock (for `=NOW()`). 
    *   *Abstract Domain:* A context object providing `resolve(Coord) -> Value` and `get_volatile(Time) -> Value`.

### 4. Ambiguities and Missing Evidence

*   **Ambiguity 1: Type Coercion Matrix.** How do empty strings, blank cells, and boolean values coerce during arithmetic operations?
    *   **Classification:** *Spec-Gap*. ISO/MS-XLSX specifications are often incomplete or contradictory regarding edge-case coercions.
*   **Ambiguity 2: Short-Circuit Evaluation.** Do functions like `IF()`, `CHOOSE()`, or `IFS()` strictly short-circuit, preventing the evaluation (and potential side-effects/errors) of unselected branches?
    *   **Classification:** *Empirical-Gap*. Needs validation via custom User Defined Functions (UDFs) that log execution to observe if unselected branches are evaluated.
*   **Ambiguity 3: Array Spilling vs. Intersection.** The exact rules for when a dynamic array spills versus when it triggers a `#SPILL!` error due to implicit intersection or occupied cells.
    *   **Classification:** *Spec-Gap* (Newer feature, poorly formalized in open specs) and *Empirical-Gap* (Behavior nuances in edge cases).

---

# Uncertainties And Evidence Needs

1.  **Implicit Intersection Rules:** We lack a formal map of when implicit intersection is enforced vs. when an array is passed wholesale to a function. 
    *   *Evidence Need:* Construct empirical tests using `excel-probe` to pass ranges to various scalar-expecting and array-expecting functions.
2.  **Error Propagation Priority:** When an expression contains multiple errors (e.g., `#N/A` + `#DIV/0!`), which error takes precedence in the AST evaluation?
    *   *Evidence Need:* Empirical tests combining different error types in single expressions.
3.  **Volatile Function Lifecycle:** Does a volatile function in an unreferenced, hidden sheet trigger graph invalidation on every workbook mutation?
    *   *Evidence Need:* Tracing calculation chains using `excel-probe` and RTD server mockups.

---

# Promotion-Ready Draft Content

## In-Cell Semantics: Core Abstraction

### 1. The Cell State Model
A Cell $C$ is defined by its state tuple $S = \langle I, E, V, M \rangle$:
*   $I \in String$: The raw input provided by the user or system (e.g., `"=A1+1"` or `"Hello"`).
*   $E \in Expression \cup \{ \bot \}$: The abstract syntax tree resulting from parsing $I$. $\bot$ represents a parse failure.
*   $V \in Value \cup \{ \bot \}$: The cached result of the last evaluation. $\bot$ represents an uncalculated state.
*   $M \in Metadata$: Attributes such as formatting, protection status, and data validation rules.

### 2. Evaluation Semantics
Evaluation is defined as a transition mapped by an Evaluator function. Given an environment $\Gamma$, evaluation is the judgment:
$$ \Gamma \vdash E \Downarrow V $$

The environment $\Gamma$ exposes two critical interfaces:
1.  **`resolve(Address) -> Value`**: Fetches the current $V$ of a dependent cell. If the dependent cell is in state $\bot$, the behavior is undefined at the cell level (delegated to the global scheduler).
2.  **`ambient(Key) -> Value`**: Fetches system-level volatile data (e.g., `NOW`, `RAND`).

### 3. Traceability to Excel Conformance
*   **[MS-XLSX] 2.2.2 (Formulas):** Maps directly to the $E$ (Expression) domain.
*   **[MS-XLSX] 2.5.97 (Cell Values):** Maps directly to the $V$ (Value) domain, encompassing primitive types and standard Excel Error codes.

---

# Follow-Up Backlog

1.  **Generate `excel-probe` payloads:** Create test scripts to resolve the empirical gaps identified (short-circuiting of `IF`, error propagation precedence).
2.  **Draft Coercion Matrix:** Review `MS-XLSX` and `MS-OAUT` to draft a formal matrix of type coercions (e.g., Boolean to Int, Empty to Float) and validate it empirically.
3.  **Formalize the AST:** Create a strict BNF grammar for the `Expression` domain that captures the core formula language requirements without being tied to a specific parser generator.
4.  **Integrate with Global Graph:** Draft the interface between `CellState` and the external dependency graph (e.g., how $\Gamma$ is populated and how invalidation flows outwards from $S$).

