# XLL Non-Interesting Functions: Implementation Spec with FEC Contract Boundary

**Run:** `20260303-093804-xll-non-interesting-pack-pass-02-fec`
**Date:** 2026-03-03
**Status:** Planning / Spec Draft

---

## 1. Scope Freeze And Inventory Rule

### Scope boundary

The **non-interesting** function set is defined negatively: every worksheet function that does NOT require any of the following is in scope:

- Volatile recalculation semantics (`RAND`, `NOW`, `OFFSET`, `INDIRECT` — these require `cap_time_provider`, `cap_random_provider`, or dynamic reference resolution beyond static input)
- Array-formula / dynamic-array spill behavior (post-`LAMBDA` era spill engine)
- External data connectivity (`RTD`, `WEBSERVICE`)
- Macro-sheet-only invocation (`GET.CELL`, `GET.WORKBOOK`, etc.)

### Inventory rule

| Rule | Statement |
|------|-----------|
| **IR-1** | A function enters the non-interesting inventory **iff** its `fec_dependency_profile` resolves to `none` or `ref_only`. |
| **IR-2** | If during contract drafting a function is discovered to require a higher FEC profile, it is **promoted out** of the non-interesting set with an explicit promotion memo. |
| **IR-3** | The inventory is frozen per pass. Mid-pass additions require a new run id. |
| **IR-4** | Each function in inventory must carry a conformance-traceable evidence tag linking to the authoritative Excel behavioural source (observation, documentation, or SDK reference). |

### Indicative partitions

| Partition | Examples | Expected FEC profile |
|-----------|----------|---------------------|
| Pure math scalar | `SIN`, `COS`, `ABS`, `SQRT`, `LN`, `POWER`, `MOD`, `SIGN` | `none` |
| Pure text scalar | `LEN`, `LEFT`, `RIGHT`, `MID`, `UPPER`, `LOWER`, `TRIM`, `REPT` | `none` |
| Pure logical scalar | `AND`, `OR`, `NOT`, `XOR` (scalar overloads) | `none` |
| Type-test / info scalar | `ISNUMBER`, `ISTEXT`, `ISBLANK`, `ISERROR`, `ISNA`, `TYPE` | `none` |
| Stat/aggregate (range) | `SUM`, `AVERAGE`, `MIN`, `MAX`, `COUNT`, `COUNTA` | `ref_only` |
| Lookup (range, non-volatile) | `VLOOKUP`, `HLOOKUP`, `INDEX`, `MATCH` | `ref_only` |
| Reference-sensitive info | `ROW`, `COLUMN`, `ROWS`, `COLUMNS` | `ref_only` or `caller_context` — **see assumption UA-1** |

---

## 2. Semantic Contract Schema (Per Function)

Every function in the inventory must be described by exactly this schema before implementation begins.

```
FunctionContract ::=
  function_id          : string          -- canonical Excel name, e.g. "SIN"
  category             : enum            -- Math, Text, Logical, Info, Stat, Lookup, ...
  arity                : AritySpec       -- fixed(n) | variadic(min, max?)
  parameter_spec       : [ParamContract] -- ordered
  return_spec          : ReturnContract
  fec_dependency_profile : FecProfile
  fec_facility_tags    : [CapabilityTag] -- empty if profile = none
  error_propagation    : ErrorPropRule
  coercion_table       : CoercionSpec    -- adapter-layer input coercion rules
  invariants           : [Invariant]
  preconditions        : [Precondition]
  postconditions       : [Postcondition]
  evidence_refs        : [EvidenceRef]
  notes                : string?

ParamContract ::=
  name                 : string
  logical_type         : LogicalType     -- Number | Text | Logical | Reference | Variant | ...
  optional             : bool
  default_value        : Value?
  coercion_rule        : CoercionRuleId  -- e.g. "text_to_number_implicit"
  error_pass_through   : bool            -- does an error input short-circuit?

ReturnContract ::=
  logical_type         : LogicalType
  possible_errors      : [ErrorKind]     -- #VALUE!, #NUM!, #REF!, #N/A, #DIV/0!, #NULL!

FecProfile ::= none | ref_only | caller_context | time_provider
             | random_provider | external_provider | locale_profile | composite

CapabilityTag ::= cap_reference_resolution | cap_caller_context | cap_time_provider
                | cap_random_provider | cap_external_provider | cap_locale_parse_format
                | cap_feature_gate | cap_error_detail_enrichment
```

### Coercion taxonomy (adapter-layer)

| CoercionRuleId | Description |
|----------------|-------------|
| `numeric_strict` | Input must resolve to IEEE 754 double; text/bool → `#VALUE!` |
| `numeric_implicit` | Bool → 0/1; numeric text → double; other text → `#VALUE!` |
| `text_strict` | Input must resolve to string |
| `text_coerce` | Number → formatted text; Bool → "TRUE"/"FALSE" |
| `logical_coerce` | 0 → FALSE, nonzero → TRUE; text → `#VALUE!` |
| `range_resolve` | Dereference reference to value array; single-cell → scalar |
| `variant_passthrough` | No coercion; pass raw typed value to kernel |

---

## 3. FEC Contract Overlay

### 3.1 Concept

The **Formula Evaluation Context (FEC)** is the host-provided context that is *external to the pure formula/function core*. It is the single gateway through which a function may observe anything beyond its declared typed inputs.

**Cardinal rule:** A function **must not observe undeclared FEC facilities**. If a function's `fec_dependency_profile` is `none`, it receives a null/opaque FEC handle and any attempt to call through it is a contract violation (enforced at adapter boundary).

### 3.2 Capability families

| Capability family | Tag | Provides | Example consumer |
|---|---|---|---|
| Reference resolution | `cap_reference_resolution` | Resolve `XLOPER12` references to value arrays; handle multi-area refs | `SUM`, `VLOOKUP` |
| Caller context | `cap_caller_context` | Calling cell address, sheet name, formula-array dimensions | `ROW()`, `COLUMN()` (no-arg form) |
| Time provider | `cap_time_provider` | Current date/time stamp | `NOW`, `TODAY` |
| Random provider | `cap_random_provider` | Deterministic or host-seeded random stream | `RAND`, `RANDBETWEEN` |
| External provider | `cap_external_provider` | External data fetch, RTD channel | `WEBSERVICE`, `RTD` |
| Locale / parse / format | `cap_locale_parse_format` | Decimal separator, date format, thousand separator, string comparison locale | `TEXT`, `VALUE`, `FIXED` |
| Feature gate | `cap_feature_gate` | Dynamic array spill enabled? `LAMBDA` enabled? Compatibility mode? | Spill-aware overloads |
| Error detail enrichment | `cap_error_detail_enrichment` | Attach diagnostic metadata to error values | Debug/tracing layer |

### 3.3 Profiles

| Profile value | Required capabilities | Typical function class |
|---|---|---|
| `none` | ∅ | Pure scalar math/text/logical |
| `ref_only` | `cap_reference_resolution` | Aggregates, lookups over ranges |
| `caller_context` | `cap_reference_resolution` + `cap_caller_context` | `ROW()`, `COLUMN()` zero-arg |
| `time_provider` | `cap_time_provider` | `NOW`, `TODAY` |
| `random_provider` | `cap_random_provider` | `RAND`, `RANDBETWEEN` |
| `external_provider` | `cap_external_provider` | `RTD`, `WEBSERVICE` |
| `locale_profile` | `cap_locale_parse_format` | `TEXT`, `VALUE`, `FIXED` |
| `composite` | 2+ families | Any function needing multiple |

### 3.4 Enforcement model

```
┌─────────────────────────────────────┐
│         XLL Entry Point             │
│  (xlAutoOpen / xlfRegister)         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Layer A: Declarative Adapter       │
│  ┌───────────────────────────────┐  │
│  │ 1. Read XLOPER12 args         │  │
│  │ 2. Error-exit shortcircuit    │  │
│  │ 3. Coerce per CoercionTable   │  │
│  │ 4. Build FEC-view (scoped to  │  │
│  │    declared profile ONLY)     │  │
│  │ 5. Call Layer B               │  │
│  │ 6. Marshal return → XLOPER12  │  │
│  └───────────────────────────────┘  │
└──────────────┬──────────────────────┘
               │  typed args + scoped FEC handle
               ▼
┌─────────────────────────────────────┐
│  Layer B: Typed Core Kernel         │
│  - Receives only typed values       │
│  - FEC handle is opaque; only       │
│    declared capabilities callable   │
│  - Pure logic; no XLOPER awareness  │
│  - Returns typed Result | Error     │
└─────────────────────────────────────┘
```

The adapter constructs an **FEC-view** that exposes only the capabilities declared in `fec_facility_tags`. For `none`-profile functions the FEC-view is a null/unit value — no runtime access path exists. This is enforced structurally (type system or accessor gating), not by convention.

---

## 4. XLL Registration / Type Mapping Plan

### 4.1 `xlfRegister` parameter map

Each function registered via `xlfRegister` requires (among others):

| Register param # | Field | Planning note |
|---|---|---|
| 1 | DLL name | Resolved at `xlAutoOpen` |
| 2 | Procedure name | C export name of adapter entry point |
| 3 | **`pxTypeText`** | Type string — see mapping below |
| 4 | Function name | Excel-visible name (e.g., `"SIN"` or namespaced `"XLL.SIN"`) |
| 5 | Argument names | Pipe-delimited |
| 6 | Function type | `1` = worksheet function |
| 7 | Category | Custom or standard category string |
| 10 | Help strings | Argument-level help text |

### 4.2 `pxTypeText` character mapping

| Char | XLOPER12 type | Direction | Notes |
|------|--------------|-----------|-------|
| `B` | `double` (IEEE 754) | in | By value — preferred for scalar numeric |
| `C%` | `wchar_t*` (null-term) | in | Wide string |
| `K%` | `FP12*` | in | Floating-point array (row-major) |
| `U%` | `XLOPER12*` | in/out | General variant — required for references |
| `Q` | `XLOPER12*` | return | Return variant |
| `$` | (modifier) | — | Thread-safe marker — append to type string |
| `!` | (modifier) | — | Volatile marker — NOT used for non-interesting set |

### 4.3 Strategy per FEC profile

| FEC profile | `pxTypeText` strategy | Caller context needed? |
|---|---|---|
| `none` (pure scalar) | Prefer `B` / `C%` for typed args; return via `Q` | No |
| `ref_only` | Use `U%` for range args; adapter resolves refs → values | No |
| `caller_context` | Use `U%` + register as `R`-type to receive `xlCoerce`-able ref **or** use `xlfCaller` inside adapter | Yes — adapter calls `xlfCaller` |

### 4.4 Thread safety

All non-interesting functions should be registered with the `$` (thread-safe) suffix in `pxTypeText`. This is valid because:
- `none`-profile functions are by definition pure.
- `ref_only`-profile functions access only their input references (no global state mutation).

**Unresolved assumption UA-2:** Confirm that `xlfCaller` is safe to call from a thread-safe function context, or whether `caller_context`-profile functions must drop the `$` flag.

---

## 5. Two-Layer Implementation Template

### 5.1 Layer A — Declarative Adapter (language-independent pseudocode)

```
// Generated or table-driven per function contract.
// This is the XLL entry point registered with xlfRegister.

function XLL_SIN(arg0: XLOPER12*) -> XLOPER12*:
    // --- Phase 1: Error early exit ---
    if is_error(arg0):
        return marshal_error(extract_error(arg0))

    // --- Phase 2: Coercion per contract ---
    let coerced := coerce(arg0, rule: numeric_implicit)
    if coerced is CoercionFailure:
        return marshal_error(#VALUE!)

    // --- Phase 3: FEC-view construction ---
    // SIN has fec_dependency_profile = none → null FEC
    let fec_view := FecView.null()

    // --- Phase 4: Dispatch to typed core ---
    let result := Core.sin(coerced.as_f64(), fec_view)

    // --- Phase 5: Marshal return ---
    match result:
        Ok(value)  -> return marshal_number(value)
        Err(error) -> return marshal_error(error)
```

```
// Aggregate example: SUM with ref_only profile

function XLL_SUM(args: XLOPER12*[]) -> XLOPER12*:
    // --- Phase 1: Build FEC-view with cap_reference_resolution ---
    let fec_view := FecView.with_ref_resolution(host_resolver)

    // --- Phase 2: Resolve + coerce all args ---
    let values := []
    for arg in args:
        if is_error(arg):
            return marshal_error(extract_error(arg))  // error propagation
        if is_reference(arg):
            let resolved := fec_view.resolve_reference(arg)
            for cell in resolved:
                if is_error(cell): return marshal_error(extract_error(cell))
                if is_numeric_coercible(cell):
                    values.append(coerce(cell, numeric_implicit).as_f64())
                // non-numeric cells silently skipped per Excel SUM semantics
        else:
            let coerced := coerce(arg, numeric_implicit)
            if coerced is CoercionFailure:
                return marshal_error(#VALUE!)
            values.append(coerced.as_f64())

    // --- Phase 3: Dispatch to typed core ---
    let result := Core.sum(values, FecView.null())
    //            ↑ note: core receives only typed values; FEC is null
    //              because ref resolution happened in adapter

    // --- Phase 4: Marshal return ---
    match result:
        Ok(value)  -> return marshal_number(value)
        Err(error) -> return marshal_error(error)
```

### 5.2 Layer B — Typed Core Kernel

```
// Pure typed logic. No XLOPER12 awareness. No host calls.

module Core:

    function sin(x: f64, fec: FecView) -> Result<f64, ErrorKind>:
        assert fec.is_null()           // contract: no FEC access
        // Precondition: x is finite
        if not is_finite(x):
            return Err(#VALUE!)        // Excel returns #VALUE! for sin(inf)
        return Ok(ieee754_sin(x))

    function sum(values: [f64], fec: FecView) -> Result<f64, ErrorKind>:
        assert fec.is_null()
        let acc := 0.0
        for v in values:
            acc := acc + v
            // Postcondition check: overflow → #VALUE! (see UA-3)
        if not is_finite(acc):
            return Err(#NUM!)          // Excel behaviour for overflow
        return Ok(acc)
```

### 5.3 Key design properties

| Property | How ensured |
|---|---|
| FEC isolation | Adapter constructs scoped FEC-view; core receives only declared profile |
| No undeclared FEC observation | `none`-profile → null FEC; `ref_only`-profile → FEC used in adapter only, core gets null |
| Error propagation | Adapter handles error-exit before calling core |
| Coercion correctness | Adapter applies `coercion_table` from contract; core never sees raw XLOPER12 |
| Testability | Core is unit-testable with typed inputs; adapter is integration-testable with XLOPER12 fixtures |

---

## 6. Formal Contract Candidates

### 6.1 SIN (pure scalar, `fec_dependency_profile = none`)

```
function_id: SIN
arity: fixed(1)
fec_dependency_profile: none
fec_facility_tags: []

parameter_spec:
  - name: number
    logical_type: Number
    coercion_rule: numeric_implicit
    error_pass_through: true

return_spec:
  logical_type: Number
  possible_errors: [#VALUE!, #NUM!]

preconditions:
  PRE-SIN-1: input is finite IEEE 754 double after coercion
             violation → #VALUE!

postconditions:
  POST-SIN-1: |result| <= 1.0
  POST-SIN-2: sin(0.0) == 0.0 exactly
  POST-SIN-3: result is finite

invariants:
  INV-SIN-1: sin(-x) == -sin(x)  (odd function, within IEEE 754 rounding)
  INV-SIN-2: no FEC access occurs during evaluation

evidence_refs:
  - Excel help: SIN function
  - Empirical: probe workbook SIN_conformance.xlsx
```

### 6.2 SUM (aggregate, `fec_dependency_profile = ref_only`)

```
function_id: SUM
arity: variadic(1, 255)
fec_dependency_profile: ref_only
fec_facility_tags: [cap_reference_resolution]

parameter_spec:
  - name: number_or_range (repeated)
    logical_type: Variant (Number | Reference)
    coercion_rule: range_resolve → then numeric_implicit per cell
    error_pass_through: true (first error in scan order propagates)

return_spec:
  logical_type: Number
  possible_errors: [#VALUE!, #NUM!, #REF!, #NULL!]

preconditions:
  PRE-SUM-1: at least one argument provided
  PRE-SUM-2: all reference args are valid (no #REF! ranges)

postconditions:
  POST-SUM-1: SUM of empty qualifying set == 0.0
  POST-SUM-2: if all inputs are finite, result is finite or #NUM! on overflow
  POST-SUM-3: SUM(x) == x for single numeric input

invariants:
  INV-SUM-1: SUM is commutative over its qualifying numeric inputs
             (modulo IEEE 754 reassociation — see UA-3)
  INV-SUM-2: text cells in ranges are silently skipped (not coerced)
  INV-SUM-3: logical TRUE/FALSE in ranges are silently skipped
             UNLESS passed as direct args (then coerced: TRUE→1, FALSE→0)
  INV-SUM-4: adapter uses cap_reference_resolution; core receives only [f64]

evidence_refs:
  - Excel help: SUM function
  - Critical behavioural note: range-text vs direct-text coercion asymmetry
```

### 6.3 ROW (reference-sensitive, `fec_dependency_profile = caller_context`)

```
function_id: ROW
arity: fixed(0) | fixed(1)
fec_dependency_profile: caller_context   -- for zero-arg form
fec_facility_tags: [cap_reference_resolution, cap_caller_context]

parameter_spec:
  - name: reference (optional)
    logical_type: Reference
    coercion_rule: variant_passthrough
    error_pass_through: true

return_spec:
  logical_type: Number (or array of Number if multi-row ref)
  possible_errors: [#REF!]

preconditions:
  PRE-ROW-1: if arg provided, it must be a valid reference (not error)
  PRE-ROW-2: zero-arg form requires cap_caller_context available

postconditions:
  POST-ROW-1: ROW(single_cell_ref) returns 1-based row number
  POST-ROW-2: ROW() returns calling cell's row number
  POST-ROW-3: ROW(multi_row_ref) returns array [r1, r2, ..., rn]

invariants:
  INV-ROW-1: result is always integer >= 1
  INV-ROW-2: ROW(ref) depends only on ref metadata, not cell values
  INV-ROW-3: zero-arg form must access cap_caller_context; 
             one-arg form needs only cap_reference_resolution

evidence_refs:
  - Excel help: ROW function
  - XLL SDK: xlfCaller behaviour
```

---

## 7. Differential Validation Matrix

This matrix defines how we validate parity between native Excel and the XLL add-in implementation.

### 7.1 Validation dimensions

| Dimension | What we compare | Method |
|---|---|---|
| **D1: Scalar value** | Output value matches to ULP tolerance | `=IF(ABS(native-addin)<epsilon, "PASS", "FAIL")` |
| **D2: Error identity** | Same error type returned | `=EXACT(ERROR.TYPE(native), ERROR.TYPE(addin))` |
| **D3: Type identity** | `TYPE()` returns same code | `=TYPE(native)=TYPE(addin)` |
| **D4: Coercion edge** | Mixed-type input produces same result | Test matrix of text-numbers, booleans, empty cells |
| **D5: Range semantics** | Text-in-range skip vs text-as-arg coerce | Dedicated probe per aggregate |
| **D6: Array output** | Multi-cell output matches in shape and values | CSE / spill comparison |
| **D7: Error propagation order** | First error propagated is the same | Multi-error input sequences |

### 7.2 Per-profile test strategy

| FEC profile | Key differential risks | Test focus |
|---|---|---|
| `none` | IEEE 754 edge cases (±0, ±Inf, NaN, subnormals, large exponents) | D1, D2, D3 |
| `ref_only` | Coercion asymmetry (range vs direct), empty cell handling, multi-area refs, whole-column refs | D4, D5, D7 |
| `caller_context` | `xlfCaller` returning correct address in XLL vs native; array-formula context | D1, D6 |

### 7.3 Probe workbook structure

```
Sheet "Control"       — native Excel formulas
Sheet "XLL"           — add-in formulas (same inputs)
Sheet "Diff"          — cell-by-cell comparison per dimension
Sheet "EdgeCases"     — IEEE 754 specials, boundary values
Sheet "CoercionMatrix"— systematic type-combination inputs
```

---

## 8. Parity-Hypothesis Challenge List

These are known or suspected areas where an XLL add-in may **not** achieve exact parity with native Excel, despite correct implementation. Each item is a hypothesis to be empirically tested.

| ID | Hypothesis | Risk | Profile affected | Status |
|---|---|---|---|---|
| **PH-1** | `SUM` accumulation order over large ranges may differ from Excel's internal chunked summation, producing different IEEE 754 rounding | Medium | `ref_only` | Unresolved |
| **PH-2** | `xlfCaller` in thread-safe XLL context may return `#REF!` or different results than native function's caller awareness | High | `caller_context` | Unresolved — see UA-2 |
| **PH-3** | Empty cell coercion: XLL receives `xltypeMissing` vs `xltypeNil` vs `xltypeNum(0)` depending on how ref is resolved — may differ from native | Medium | `ref_only` | Unresolved |
| **PH-4** | Whole-column references (`A:A`): native Excel may optimize to used-range; XLL receives the full 1M+ row ref via `XLOPER12` | High (perf) | `ref_only` | Unresolved |
| **PH-5** | `TRIM` / `CLEAN` — Excel may handle Unicode whitespace differently than C runtime `iswspace` | Low-Medium | `none` | Unresolved |
| **PH-6** | `MOD` — Excel's `MOD(a,b) = a - b*INT(a/b)` vs language `fmod` — known sign-difference edge cases | Medium | `none` | Unresolved |
| **PH-7** | `TEXT` / `VALUE` — locale-sensitive parsing even when ostensibly in `none` profile — possible misclassification | High | May force `locale_profile` | Unresolved — **potential inventory escape** |
| **PH-8** | Error propagation scan order in variadic functions with multiple error inputs — left-to-right vs evaluation-order | Low | `ref_only` | Unresolved |
| **PH-9** | Boolean coercion asymmetry: `SUM(TRUE)` = 1 but `SUM(A1)` where A1=TRUE = 0 — XLL adapter must replicate the direct-vs-range distinction | High | `ref_only` | Understood but not yet validated in XLL context |
| **PH-10** | `INT` and `TRUNC` — negative number rounding direction; `INT(-1.5)` = -2 vs `TRUNC(-1.5)` = -1 — implementation must use floor not truncation | Low | `none` | Well-known; validate only |

---

## 9. Promotion Pack

### 9.1 Decisions taken in this pass

| Decision | Rationale |
|---|---|
| FEC is a first-class contract boundary, not an afterthought | Prevents hidden host coupling; makes testability structural |
| `fec_dependency_profile` is mandatory on every function contract | Single field determines inventory membership, adapter shape, and test strategy |
| Adapter resolves references; core receives only typed values | Core remains pure and language-portable; reference resolution is host-specific |
| Non-interesting set defined as `none` ∪ `ref_only` only | Conservative scope; `caller_context` functions are borderline and may be deferred |
| Thread-safe registration (`$`) is default for all non-interesting | Valid for stateless / input-only functions; reduces recalc bottleneck |

### 9.2 Unresolved assumptions

| ID | Assumption | Impact if wrong | Next step |
|---|---|---|---|
| **UA-1** | `ROW()` / `COLUMN()` zero-arg form should be in non-interesting set | Would need `caller_context` support, complicating adapter | Decide: include with `caller_context` profile, or defer to "interesting" set |
| **UA-2** | `xlfCaller` is safe inside thread-safe (`$`) XLL function | If not, `caller_context` functions must drop `$` flag, losing concurrency | Empirical test with Excel + XLL probe |
| **UA-3** | `SUM` accumulation order is strictly left-to-right over resolved values | If Excel uses compensated summation (Kahan) or chunking, we must match | Empirical: compare SUM over pathological float sequences |
| **UA-4** | `TEXT` and `VALUE` can be classified as `none`-profile | If they observe locale, they escape to `locale_profile` and leave the non-interesting set | Review PH-7; may need `cap_locale_parse_format` |
| **UA-5** | `XLOPER12` reference resolution via `xlCoerce` gives identical cell values as native formula engine sees | Any discrepancy breaks the parity model | Empirical probe with mixed-type ranges |

### 9.3 Document updates required

| Document | Update |
|---|---|
| `EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md` | Add `fec_dependency_profile` and `fec_facility_tags` columns |
| `EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv` | Add FEC profile column; populate for all inventoried functions |
| `EXCEL_CONFORMANCE_SPEC.md` | Add FEC Contract section (§ new); reference this document |
| `XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md` | Cross-reference `pxTypeText` mapping with FEC profiles |
| `EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md` | Promote from draft to canonical FEC reference |

### 9.4 Empirical plan (next pass)

| Priority | Action | Validates |
|---|---|---|
| **P0** | Build probe workbook for PH-6 (`MOD` sign), PH-9 (bool coercion asymmetry), PH-10 (`INT` rounding) | Core contract correctness for `none`-profile |
| **P0** | Build probe workbook for PH-3 (empty cell), PH-4 (whole-column perf), PH-8 (error propagation order) | Adapter correctness for `ref_only`-profile |
| **P1** | Test `xlfCaller` in `$`-registered function | Resolves UA-2, determines `caller_context` feasibility |
| **P1** | Test `TEXT`/`VALUE` locale sensitivity with non-default Windows locale | Resolves UA-4 / PH-7, may eject from inventory |
| **P2** | Build pathological float-sequence probe for `SUM` | Resolves UA-3 / PH-1 |
| **P2** | Prototype one `none`-profile adapter + core (e.g., `SIN`) end-to-end in C | Validates two-layer template in practice |

---

*End of spec. All items marked "Unresolved" carry forward to next pass.*
