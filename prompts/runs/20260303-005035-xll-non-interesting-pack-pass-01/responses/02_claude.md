# XLL Non-Interesting Functions — Implementation Specification

**Run:** `20260303-005035-xll-non-interesting-pack-pass-01`
**Date:** 2026-03-03
**Status:** Planning / Spec Draft

---

## 1. Scope Freeze And Inventory Rule

### Definition of "Non-Interesting"

A function is **non-interesting** if and only if ALL of the following hold:

| Gate | Criterion |
|------|-----------|
| G1 — Deterministic | Same inputs always produce the same result (excludes `RAND`, `NOW`, `TODAY`, `INDIRECT`). |
| G2 — No side-effects | Does not mutate workbook state, trigger recalc chains, or depend on caller position beyond what is passed as arguments. |
| G3 — No async/streaming | Returns synchronously from a single `xlcall` round-trip. |
| G4 — No UI/dialog | Does not invoke dialog boxes, commandbar manipulation, or user-facing prompts. |
| G5 — Documented coercion | Input coercion and error propagation rules are fully documented or empirically recoverable from Excel. |
| G6 — Scalar or simple aggregate | Operates on scalar values or rectangular `XLOPER` ranges with well-defined iteration semantics. No sparse/dynamic-array-only semantics required. |

### Inventory Rule

1. Start from the full function list in `EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`.
2. Apply gates G1–G6 as a filter. Every exclusion must cite the failing gate.
3. The surviving set is the **frozen scope** for this pack. No function is added after freeze without a new pack revision.
4. Partition the frozen set into **families**:

| Family | Examples | Shared trait |
|--------|----------|-------------|
| Math-Trig | `SIN`, `COS`, `TAN`, `ABS`, `SQRT`, `LN`, `LOG`, `POWER`, `MOD`, `ROUND`, `TRUNC`, `CEILING`, `FLOOR` | `double → double` or `(double, double) → double` |
| Statistical-Agg | `SUM`, `AVERAGE`, `COUNT`, `COUNTA`, `MIN`, `MAX` | Range iteration → scalar |
| Text | `LEN`, `LEFT`, `RIGHT`, `MID`, `UPPER`, `LOWER`, `TRIM`, `SUBSTITUTE`, `REPT`, `CONCATENATE` | `string → string` or `(string, int) → string` |
| Logical | `AND`, `OR`, `NOT`, `IF`, `IFERROR`, `IFNA` | Boolean coercion, short-circuit semantics |
| Lookup-Simple | `CHOOSE`, `INDEX` (array form only) | Positional index into known-shape range |
| Info-Type | `ISBLANK`, `ISERROR`, `ISNA`, `ISNUMBER`, `ISTEXT`, `TYPE` | `XLOPER → bool` or `XLOPER → int` |
| Date-Pure | `DATE`, `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND` | Serial-number ↔ component decomposition (deterministic subset only) |

5. Each family shares an adapter template (Section 4). Deviations are noted per-function.

### Unresolved Assumptions — Scope

- **UA-S1:** `INDEX` is included only in its **array form** (not the reference form that returns a reference). Empirical confirmation required.
- **UA-S2:** `IF` is included despite short-circuit semantics; the XLL receives all arguments pre-evaluated by Excel, so the kernel only selects. Confirm that Excel does not skip evaluation of the unused branch when called as an XLL-registered function.
- **UA-S3:** `CONCATENATE` vs `CONCAT` vs `TEXTJOIN` — only `CONCATENATE` is frozen. `CONCAT`/`TEXTJOIN` have dynamic-array-era coercion changes that may fail G5.

---

## 2. Semantic Contract Schema (Per Function)

Every function in the frozen set gets a **contract record** using this schema:

```
FUNCTION_CONTRACT:
  name:               <string>          # Excel function name
  family:             <enum>            # From Section 1 families
  arity:              <int | range>     # e.g., 1, 2, "1..255"
  
  INPUT_SLOTS:
    - slot:           <int>             # 0-based
      excel_name:     <string>          # Argument name per Excel docs
      xloper_accept:  <set<xloper_type>>  # {xltypeNum, xltypeStr, xltypeMulti, ...}
      coerce_to:      <core_type>       # double | int64 | string | bool | range_iter
      coerce_rule:    <enum>            # NUMERIC_STANDARD | TEXT_STANDARD | BOOL_TRUTHY | RANGE_ELEMENT_WISE | NONE
      missing_rule:   <enum>            # ERROR | DEFAULT(value) | OMIT
      default_value:  <value | null>
  
  ERROR_PROPAGATION:
    any_input_error:  <enum>            # PROPAGATE_FIRST | PROPAGATE_SPECIFIC | ABSORB
    domain_error:     <error_type>      # #NUM! | #VALUE! | #DIV/0! | #N/A
    type_mismatch:    <error_type>      # #VALUE! typically
  
  OUTPUT:
    core_type:        <core_type>       # double | string | bool | int
    xloper_type:      <xloper_type>     # xltypeNum | xltypeStr | xltypeBool | xltypeErr
    special_values:   <list>            # e.g., ["+Inf → #NUM!", "NaN → #NUM!"]
  
  PARITY_NOTES:       <free text>       # Known divergence risks
  EVIDENCE_REF:       <list<string>>    # Empirical probe IDs or doc references
```

### Key Design Decisions

- **Coerce rules are named, not inline.** Each rule (e.g., `NUMERIC_STANDARD`) is defined once with its own spec (Section 4, Layer A). Functions reference rules by name.
- **Missing-argument handling is per-slot**, not per-function, because Excel allows trailing optional arguments with different default semantics.
- **`EVIDENCE_REF`** ties every contract claim to either a documentation citation or an empirical probe run ID. No contract field may be "assumed" without being flagged in `PARITY_NOTES`.

---

## 3. XLL Registration / Type Mapping Plan

### `xlfRegister` Field Map

Each function is registered via `xlfRegister` (or `Excel4`/`Excel12` calling `xlfRegister`). The critical fields:

| Register Arg | Field | Strategy |
|-------------|-------|----------|
| `pxModuleText` | DLL path | Runtime-resolved; passed once at `xlAutoOpen`. |
| `pxProcedure` | C export name | Convention: `XLL_<FamilyPrefix>_<NAME>`, e.g., `XLL_MT_SIN`. |
| `pxTypeText` | Type string | See type-string plan below. |
| `pxFunctionText` | Worksheet name | Matches Excel name exactly (e.g., `"SIN"`). Register under category to avoid collision. |
| `pxArgumentText` | Arg names | From contract schema `excel_name` fields, comma-separated. |
| `pxMacroType` | Function type | `1` (worksheet function) for all non-interesting functions. Never `2` (macro). |
| `pxCategory` | Category | Custom category string (e.g., `"DnaCalc"`) or map to Excel's built-in category int. |

### `pxTypeText` Encoding Plan

The `pxTypeText` string encodes the return type followed by each parameter type. The critical mapping:

| Core type | `pxTypeText` char (XLOPER12) | `pxTypeText` char (XLOPER) | Notes |
|-----------|------|------|-------|
| `XLOPER12` (generic) | `Q` | `P` | Used when adapter receives raw `XLOPER` and coerces internally. |
| `XLOPER12*` (modify-in-place) | `U` | `R` | **Preferred for return**: caller-allocated, avoids `xlAutoFree`. |
| `double` | `B` | `B` | Direct double; bypasses `XLOPER` entirely. Layer B kernels can use this. |
| `int` | `J` | `J` | 32-bit signed int. |
| `string (Pascal)` | `F%` / `F` | `F` | Length-prefixed wide string (XLOPER12). |
| `boolean` | `L` | `L` | Short int (0/1). |
| Range (by-ref) | `U` | `R` | `XLOPER12*` with `xltypeMulti` or `xltypeRef`. |

### Registration Strategy Per Family

| Family | Return via | Param via | Rationale |
|--------|-----------|-----------|-----------|
| Math-Trig (unary) | `B` (double) | `Q` (XLOPER12) | Return is always double. Input needs adapter coercion (strings, bools → double). |
| Math-Trig (binary) | `B` | `Q Q` | Same rationale. |
| Statistical-Agg | `U` (XLOPER12*) | `Q Q Q ...` (var-args) | Return might be error. Variable arity requires XLOPER params. |
| Text | `U` | `Q Q ...` | Return is string or error; needs XLOPER return. |
| Logical | `U` | `Q Q ...` | `IF` returns polymorphic type; must use XLOPER. |
| Info-Type | `L` or `U` | `Q` | Some always return bool, but `TYPE` returns int. Use `U` uniformly for simplicity. |
| Date-Pure | `B` or `U` | `Q Q ...` | `DATE` returns serial double; `YEAR`/`MONTH` return int. Uniform `U` is safest. |

### Caller-Context Considerations

- **Thread safety:** All non-interesting functions are marked thread-safe by appending `$` to `pxTypeText` (Excel 2007+). This is valid because G1–G2 guarantee no shared mutable state.
- **Cluster safety:** Append `&` if targeting HPC cluster compute. Defer decision — mark as **UA-R1**.
- **`xlAutoFree12`:** Required if any function returns a heap-allocated `XLOPER12*`. Use a tagged-allocation scheme: set `xlbitDLLFree` on returned `XLOPER12`, and `xlAutoFree12` dispatches on the type to free string/multi memory.

### Unresolved Assumptions — Registration

- **UA-R1:** Cluster-safe registration (`&` suffix) — decide after empirical validation of Excel's cluster compute behavior with these functions.
- **UA-R2:** For var-args functions (`SUM` accepts up to 255 args), Excel's `xlfRegister` requires each arg to be declared in `pxTypeText`. Strategy: register with a fixed maximum (e.g., 29 `Q` params) and handle fewer at runtime via `xltypeMissing` checks. Confirm Excel's actual ceiling for XLL var-args.
- **UA-R3:** Name collision strategy — if native `SIN` and XLL `SIN` coexist, which wins? Test with `=SIN(1)` vs `=DnaCalc.SIN(1)` fully-qualified. Decide whether to shadow or namespace.

---

## 4. Two-Layer Implementation Template

### Architecture

```
┌─────────────────────────────────────────────────────┐
│  Excel calls via xlcall                              │
│         │                                            │
│         ▼                                            │
│  ┌─────────────────────────────────────┐             │
│  │  LAYER A: Adapter                    │             │
│  │  - Receives XLOPER12* args           │             │
│  │  - Applies named coercion rules      │             │
│  │  - Checks for input errors           │             │
│  │  - Handles xltypeMissing (defaults)  │             │
│  │  - Calls Layer B                     │             │
│  │  - Wraps result into XLOPER12*       │             │
│  │  - Applies output error mapping      │             │
│  └──────────────┬──────────────────────┘             │
│                 │                                     │
│                 ▼                                     │
│  ┌─────────────────────────────────────┐             │
│  │  LAYER B: Typed Core Kernel          │             │
│  │  - Pure function                     │             │
│  │  - No XLOPER awareness               │             │
│  │  - No Excel SDK dependency           │             │
│  │  - Returns result or error enum      │             │
│  └─────────────────────────────────────┘             │
└─────────────────────────────────────────────────────┘
```

### Layer A — Adapter Template (Pseudocode)

```
// Generated or table-driven per contract schema.
FUNCTION XLL_MT_SIN(arg0: XLOPER12*) -> XLOPER12*:

    // 1. Error gate: propagate input errors
    IF is_error(arg0):
        RETURN wrap_error(extract_error(arg0))

    // 2. Coercion: apply named rule
    val0: CoerceResult = coerce(arg0, NUMERIC_STANDARD)
    IF val0.failed:
        RETURN wrap_error(xlerrValue)   // #VALUE!

    // 3. Delegate to typed kernel
    result: KernelResult<double> = kernel_sin(val0.as_double)

    // 4. Output mapping
    MATCH result:
        Ok(v)  => RETURN wrap_double(v)
        Err(e) => RETURN wrap_error(map_kernel_error(e))
```

### Named Coercion Rules (Layer A Library)

| Rule Name | Input XLOPER types | Behavior |
|-----------|--------------------|----------|
| `NUMERIC_STANDARD` | Num→passthrough, Str→parse as double (fail→#VALUE!), Bool→0.0/1.0, Blank→0.0 | Matches Excel's implicit numeric coercion. |
| `TEXT_STANDARD` | Str→passthrough, Num→format to string, Bool→"TRUE"/"FALSE", Blank→"" | Matches Excel's implicit text coercion. |
| `BOOL_TRUTHY` | Bool→passthrough, Num→(0=FALSE, else TRUE), Str→#VALUE!, Blank→FALSE | Matches `AND`/`OR` input coercion for direct args. |
| `RANGE_ELEMENT_WISE` | Multi→iterate elements, applying inner rule per element. Ref→dereference then iterate. | Used by aggregates. |
| `INT_TRUNCATE` | Apply `NUMERIC_STANDARD`, then truncate to integer. | For `LEFT(text, num_chars)`. |

### Layer B — Typed Core Kernel (Pseudocode)

```
// Pure, no-SDK, testable independently.
ENUM KernelError { DomainError, DivByZero, Overflow }

FUNCTION kernel_sin(x: double) -> KernelResult<double>:
    // Precondition: x is finite (adapter guarantees non-error, non-missing)
    IF NOT is_finite(x):
        RETURN Err(DomainError)
    RETURN Ok(sin(x))

FUNCTION kernel_sum(values: Iterator<double?>) -> KernelResult<double>:
    acc = 0.0
    FOR v IN values:
        IF v IS SOME(d):
            acc += d
        // v IS NONE means blank/text in range — skip (SUM semantics)
    IF NOT is_finite(acc):
        RETURN Err(Overflow)
    RETURN Ok(acc)
```

### Layer A — Aggregate Adapter Variant

```
FUNCTION XLL_SA_SUM(args: XLOPER12*[0..N]) -> XLOPER12*:

    // 1. Build lazy iterator over all args
    iter = empty_iterator()
    FOR i IN 0..N:
        IF is_missing(args[i]): BREAK
        IF is_error(args[i]):
            RETURN wrap_error(extract_error(args[i]))
        iter = iter.chain(coerce_range(args[i], RANGE_ELEMENT_WISE, NUMERIC_STANDARD))

    // 2. Delegate
    result = kernel_sum(iter)

    // 3. Output
    MATCH result:
        Ok(v)  => RETURN wrap_double(v)
        Err(e) => RETURN wrap_error(map_kernel_error(e))
```

### Code Generation / Table-Driven Strategy

Layer A adapters are **mechanically derivable** from the contract schema (Section 2). Implementation options:

1. **Code generation** — emit adapter source from contract JSON/YAML at build time.
2. **Table-driven dispatch** — single generic adapter that reads a function-descriptor table at runtime.
3. **Macro/template** — language-specific metaprogramming (C macros, Rust proc-macros, etc.).

Decision deferred to implementation language selection. The spec is language-independent; all three strategies are viable.

---

## 5. Formal Contract Candidates

### Contract Language

Contracts are expressed as:

- **PRE(slot):** Precondition on an input after coercion (Layer B entry).
- **POST:** Postcondition on the return value.
- **INV:** Invariant that holds across all invocations.
- **ERR-MAP:** Error mapping rule (which precondition violation maps to which Excel error).

### Example 1: `SIN` (Math-Trig, unary)

```
CONTRACT SIN:
  LAYER_A:
    PRE(0):   arg0 coerces via NUMERIC_STANDARD to double
    ERR-MAP:  coercion failure → #VALUE!
    ERR-MAP:  input is error xloper → propagate that error

  LAYER_B:
    SIGNATURE: kernel_sin(x: double) -> KernelResult<double>
    PRE:      is_finite(x)
    POST:     is_finite(result) AND -1.0 <= result <= 1.0
    ERR-MAP:  PRE violation → #VALUE!  [Note: Excel actually returns #VALUE!
              for =SIN(1E+308) when platform sin() returns NaN. Verify.]
    INV:      kernel_sin(0.0) == 0.0
    INV:      |kernel_sin(x) - kernel_sin(-x)| < ε  (odd-function symmetry)
    INV:      kernel_sin(PI) == ~0.0  (within platform double precision)
```

### Example 2: `SUM` (Statistical-Aggregate)

```
CONTRACT SUM:
  LAYER_A:
    PRE(0..254): each arg is scalar, range, or missing
    RULE:     missing args are ignored (not an error)
    RULE:     error in any arg → propagate first error encountered
    RULE:     range iteration: numbers are included, text/logical in
              ranges are SKIPPED (not coerced, not errors)
    RULE:     direct scalar text arg → #VALUE! (different from range text!)
    ERR-MAP:  direct text scalar → #VALUE!

  LAYER_B:
    SIGNATURE: kernel_sum(values: Iterator<double?>) -> KernelResult<double>
    PRE:      iterator is finite (bounded by Excel range limits)
    POST:     result == Σ(v for v in values where v is SOME)
    POST:     is_finite(result)  [else → #NUM! via ERR-MAP]
    ERR-MAP:  overflow/infinite result → #NUM!  [UA-C1: verify Excel behavior
              for SUM of values near ±1.7E+308]
    INV:      kernel_sum(empty) == 0.0
    INV:      kernel_sum([a]) == a for any finite a
    INV:      kernel_sum([a, b]) == kernel_sum([b, a])  (commutativity — note:
              floating-point: this is approximate, not exact. See Parity §7.)
```

### Example 3: `TYPE` (Info-Type, reference-sensitive)

```
CONTRACT TYPE:
  LAYER_A:
    PRE(0):    arg0 is ANY xloper type (no coercion applied)
    RULE:      DO NOT coerce — TYPE inspects the xloper type tag directly
    RULE:      error xloper → return 16 (NOT propagate the error)
    NOTE:      This is the ONLY non-interesting function where error
              propagation is suppressed.

  LAYER_B:
    SIGNATURE: kernel_type(tag: XloperTypeTag) -> int
    PRE:       tag is valid enum member
    POST:      result IN {1, 2, 4, 16, 64, 128}
    MAP:
      xltypeNum   → 1
      xltypeStr   → 2
      xltypeBool  → 4
      xltypeErr   → 16
      xltypeMulti → 64
      xltypeRef / xltypeSRef → 64  [UA-C2: verify — does TYPE see
                                     the ref or the dereferenced value?]
    INV:       kernel_type is total (defined for all valid tags)
    ERR-MAP:   (none — function never errors)

  PARITY_RISK:
    - XLL receives XLOPER after Excel may have dereferenced refs.
      If Excel resolves xltypeRef before passing to XLL, TYPE will see
      the value type, not "reference". This changes the result from 8 to
      the underlying type. CRITICAL EMPIRICAL TEST REQUIRED.
    - Registration with pxTypeText 'Q' may force coercion that TYPE
      must avoid. May need 'R'/'U' registration to receive raw xloper.
```

---

## 6. Differential Validation Matrix

Every function must be validated for **parity** between the native Excel built-in and the XLL implementation. The matrix defines what to test:

### Test Dimensions

| Dimension | Values to cover |
|-----------|----------------|
| D1 — Normal inputs | Representative values from the function's domain |
| D2 — Boundary inputs | Domain edges (0, ±1, MAX_DOUBLE, MIN_POSITIVE, empty string, max-length string) |
| D3 — Type coercion | Each input type that Excel accepts: number, text-that-looks-like-number, boolean, blank, range-of-mixed |
| D4 — Error inputs | Each Excel error type as input: #VALUE!, #REF!, #N/A, #NUM!, #DIV/0!, #NULL!, #NAME? |
| D5 — Missing args | Each optional arg omitted; trailing args omitted |
| D6 — Range shapes | 1×1, 1×N, N×1, N×M, empty range, range with mixed types |
| D7 — Special values | Text "TRUE"/"FALSE", text "1", text "1.5", text with leading/trailing spaces, text with locale decimal separator |

### Validation Matrix Template

| Test ID | Function | Dimension | Input | Expected (Excel native) | Actual (XLL) | Match? | Notes |
|---------|----------|-----------|-------|------------------------|--------------|--------|-------|
| `MT-SIN-N01` | SIN | D1 | `0` | `0` | — | — | |
| `MT-SIN-N02` | SIN | D1 | `PI()/2` | `1` | — | — | Note: PI() is volatile — use literal `1.5707963...` |
| `MT-SIN-B01` | SIN | D2 | `1E+307` | `<some double>` | — | — | Platform-dependent sin() for huge args |
| `MT-SIN-B02` | SIN | D2 | `1E+308` | `#VALUE!` or `<some double>`? | — | — | **UA-V1:** Confirm Excel behavior |
| `MT-SIN-C01` | SIN | D3 | `TRUE` | `0.8414709...` (sin(1)) | — | — | |
| `MT-SIN-C02` | SIN | D3 | `"1"` | `0.8414709...` | — | — | Text coerced to number |
| `MT-SIN-C03` | SIN | D3 | `""` (blank) | `0` | — | — | Blank → 0 |
| `MT-SIN-E01` | SIN | D4 | `#N/A` | `#N/A` | — | — | Error propagation |
| `SA-SUM-R01` | SUM | D6 | `{1,"x",TRUE,3}` range | `4` | — | — | Text and bool in ranges skipped |
| `SA-SUM-R02` | SUM | D3 | `SUM(1,"2",TRUE)` scalar | `#VALUE!` (from "2") or `4`? | — | — | **UA-V2:** Scalar text coercion in SUM — verify |
| `IT-TYPE-S01` | TYPE | Special | `TYPE(1)` | `1` | — | — | |
| `IT-TYPE-S02` | TYPE | Special | `TYPE(A1)` where A1=1 | `1`? or `8` (ref)? | — | — | **UA-V3:** Critical ref test |

### Automation Strategy

1. **Reference workbook** — An `.xlsx` with one sheet per family, formulas in column A (native), corresponding XLL calls in column B, `=EXACT(A,B)` in column C.
2. **Probe script** — Automated via `xlcall` or COM/automation to fill the matrix programmatically and export results.
3. **Tolerance** — Numeric comparison uses `|a - b| < ε` where `ε = 2^-48` (~3.55E-15) unless tighter tolerance is specified per-function.

---

## 7. Parity-Hypothesis Challenge List

These are **candidate counterexamples** — scenarios where the XLL implementation might diverge from native Excel behavior despite passing the standard validation matrix.

| ID | Hypothesis | Risk | Test Strategy |
|----|-----------|------|---------------|
| PH-01 | **Floating-point summation order.** `SUM` over a large range may differ by ULP due to Excel potentially using a different accumulation order or extended precision internally. | Medium | Compare `SUM(A1:A100000)` with known Kahan-sum reference value. Test with adversarial sequences (alternating large/small values). |
| PH-02 | **`ROUND` banker's rounding.** Excel's `ROUND` uses arithmetic rounding (round-half-away-from-zero), not IEEE 754 round-half-to-even. Platform `round()` may differ. | High | Test `ROUND(0.5,0)`, `ROUND(1.5,0)`, `ROUND(2.5,0)`, `ROUND(-0.5,0)`. Expect 1,2,3,-1. |
| PH-03 | **Text-to-number locale sensitivity.** `"1,5"` may parse as `1.5` in European locales. Does the XLL receive locale-coerced values or raw text? | High | Test under both US and European locale settings. If XLL receives raw text, it must implement locale-aware parsing. |
| PH-04 | **`MOD` sign convention.** Excel `MOD(a,b)` uses `a - b*INT(a/b)`, which differs from C `fmod(a,b)` for negative values. `MOD(-3,2)` = `1` in Excel, `-1` in C. | High | Direct comparison: `MOD(-3,2)`, `MOD(3,-2)`, `MOD(-3,-2)`. |
| PH-05 | **`INT` vs `TRUNC` for negatives.** Excel `INT(-1.5)` = `-2` (floor), `TRUNC(-1.5)` = `-1`. Platform `(int)` cast truncates toward zero. | Medium | `INT(-1.5)`, `INT(-0.1)`, `TRUNC(-1.5)`, `TRUNC(-0.1)`. |
| PH-06 | **Range iteration order for aggregates.** If the XLL iterates a range row-by-row vs column-by-column, floating-point accumulation order may change, producing different ULP results from native Excel. | Low | Compare aggregates on transposed ranges: `SUM(A1:J10)` vs `SUM(TRANSPOSE(A1:J10))`. |
| PH-07 | **`CONCATENATE` with error in range.** If passed a multi-cell range (not supported by CONCATENATE but testable), does native Excel error or silently ignore? XLL might differ. | Low | `CONCATENATE(A1:A3)` where A2=#N/A. |
| PH-08 | **`TYPE` on an XLL return value.** If another XLL function returns a value, does `TYPE()` on that cell see the same type as for a native function's return? Tests XLOPER type tag fidelity. | Medium | `=TYPE(XLL_SIN(1))` vs `=TYPE(SIN(1))`. Must both return 1. |
| PH-09 | **`IFERROR`/`IFNA` short-circuit.** In native Excel, `IFERROR(1/0, "safe")` does not propagate `#DIV/0!`. The XLL version receives the error as an already-evaluated XLOPER. Does the XLL adapter correctly detect the error without propagating? | Medium | `IFERROR(1/0, "safe")`, `IFNA(#N/A, "safe")`, `IFNA(#VALUE!, "should not catch")`. |
| PH-10 | **Date serial number edge cases.** Excel treats 1900-02-29 as valid (Lotus 1-2-3 bug compatibility). Date functions must reproduce this. `DATE(1900,2,29)` = serial 60. | High | `DATE(1900,2,29)`, `YEAR(60)`, `MONTH(60)`, `DAY(60)`. |

---

## 8. Promotion Pack

### Decisions Made

| ID | Decision | Rationale |
|----|----------|-----------|
| D1 | Two-layer architecture (Adapter + Kernel) | Separates Excel SDK concerns from pure logic. Enables independent testing of kernels. Enables future non-XLL hosts. |
| D2 | Named coercion rules, not per-function inline | Reduces duplication. Ensures consistent coercion across families. One fix propagates everywhere. |
| D3 | `pxTypeText` strategy: use `Q`/`U` (XLOPER12) for most params/returns | Maximizes adapter control over coercion. Avoids Excel's implicit coercion which may not match our contract. |
| D4 | Thread-safe registration (`$`) for all non-interesting functions | Justified by G1 (deterministic) + G2 (no side effects). |
| D5 | Frozen scope defined by gates G1–G6 | Clear, auditable inclusion/exclusion criteria. No ad-hoc scope creep. |
| D6 | Contract schema is the single source of truth | Registration, adapter code gen, tests, and docs all derive from the contract. |

### Unresolved Items

| ID | Item | Blocking? | Resolution Path |
|----|------|-----------|-----------------|
| UA-S1 | `INDEX` array-form-only inclusion | No | Empirical probe: register both forms, test `INDEX` returning a reference. |
| UA-S2 | `IF` branch evaluation in XLL context | Yes (for `IF`) | Probe: `=XLL_IF(TRUE, 1, 1/0)` — if XLL receives `#DIV/0!` as arg2, Excel evaluated both branches. |
| UA-S3 | `CONCAT`/`TEXTJOIN` scope boundary | No | Deferred to a future pack. |
| UA-R1 | Cluster-safe registration | No | Deferred until HPC target is confirmed. |
| UA-R2 | Max var-args for XLL registration | Yes (for aggregates) | Empirical: register SUM with 29 params, test with 30+. Check `xlcall` docs for hard limit. |
| UA-R3 | Name collision / shadowing strategy | Yes | Decision required before registration. Options: (a) shadow with identical name, (b) prefix `DC.SIN`, (c) register under different category only. |
| UA-V1 | `SIN(1E+308)` native behavior | No | Probe workbook test. |
| UA-V2 | `SUM` scalar text coercion | Yes (for SUM contract) | Probe: `=SUM(1,"2",TRUE)` in Excel. Expected: `#VALUE!` but verify. |
| UA-V3 | `TYPE` on cell reference vs value | Yes (for TYPE) | Probe: `=TYPE(A1)` where A1=1, check if 1 (number) or 8 (reference). |
| UA-C1 | `SUM` overflow behavior | No | Probe: `=SUM(1E+308, 1E+308)`. |
| UA-C2 | `TYPE` ref-tag visibility in XLL | Yes (for TYPE) | Registration experiment: `Q` vs `U` vs `R` type text, check what xloper type tag arrives. |

### Documentation Updates Required

1. **`EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`** — Add column: `non_interesting_pack_status` with values `{frozen, excluded:<gate>, deferred}`.
2. **`EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`** — Add section linking to this spec for the non-interesting subset.
3. **`XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`** — Cross-reference the `pxTypeText` decisions from Section 3.
4. **New artifact:** `contracts/non-interesting/` directory with one YAML per function, conforming to the schema in Section 2.

### Empirical Plan

| Phase | Action | Artifact |
|-------|--------|----------|
| E1 — Scope validation | Run gates G1–G6 against full function list. Produce frozen-set CSV. | `scope-freeze.csv` |
| E2 — Coercion probes | For each coercion rule, build probe workbook testing all input-type combinations. | `probes/coercion-matrix.xlsx` |
| E3 — Parity-hypothesis probes | Build probe workbook for all PH-01 through PH-10 items. | `probes/parity-challenges.xlsx` |
| E4 — Registration smoke test | Register one function per family with proposed `pxTypeText`. Verify Excel calls the XLL and returns correct type. | `probes/registration-smoke.xlsx` |
| E5 — TYPE deep-dive | Dedicated probe for UA-C2 (ref-tag visibility). Multiple registration variants. | `probes/type-ref-probe.xlsx` |
| E6 — Full validation matrix | Generate from contract schemas, run against both native and XLL. | `validation/full-matrix.xlsx` |

### Exit Criteria for Pack Promotion

This pack promotes to **implementation-ready** when:

1. All "Yes (blocking)" unresolved items are resolved.
2. Phases E1–E5 are complete with results recorded.
3. Contract schemas exist for every function in the frozen set.
4. At least one function per family has a passing E4 registration smoke test.
5. PH-02 (`ROUND`), PH-04 (`MOD`), PH-10 (1900 date bug) are empirically confirmed and kernel implementations verified.

---

*End of spec. All claims without `EVIDENCE_REF` are provisional pending empirical confirmation.*
