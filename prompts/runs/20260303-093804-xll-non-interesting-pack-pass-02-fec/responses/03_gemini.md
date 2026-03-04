# XLL Implementation Plan: Non-Interesting Functions & FEC Integration

This document outlines the language-independent specification and architectural plan for implementing "non-interesting" Excel functions (e.g., foundational Math, Trig, Text, and basic Statistical functions) via an `.xll` interface. It fuses rigorous semantic contracts with a strictly enforced Formula Evaluation Context (FEC) boundary.

---

## 1. Scope Freeze And Inventory Rule

To ensure clean-room evidence discipline and strict conformance traceability, the boundary for "non-interesting" functions must be rigidly defined.

*   **Scope Freeze Boundary:** Functions eligible for this implementation tier must not inherently alter the calculation chain topology (e.g., `INDIRECT`), must not require deep asynchronous state loops (e.g., `RTD`), and must have a well-defined, static, or consistently variadic signature.
*   **Inventory Rule:** A function is admitted to the implementation backlog *only if* it possesses a verified specification footprint (mapped to authoritative MS-XLSX/MS-OAUT/empirical docs), a mapped arity, and a declared FEC dependency profile. Any function discovering an undocumented side-effect during empirical testing is immediately evicted from this tier pending architectural review.

---

## 2. Semantic Contract Schema (Per Function)

Each function must be defined by a declarative semantic contract before implementation begins. This language-independent schema enforces consistency across the Layer A adapter.

| Property | Description |
| :--- | :--- |
| **`FunctionID`** | Canonical internal name (e.g., `FUNC_MATH_SIN`). |
| **`ExcelName`** | The exposed Excel function name (e.g., `SIN`). |
| **`Arity`** | Minimum and maximum arguments (e.g., `min: 1, max: 1`). |
| **`Signature`** | Conceptual types for parameters (e.g., `[Number] -> Number`). |
| **`Coercion_Profile`** | Expected implicit coercions (e.g., `Strict`, `Standard_Blank_To_Zero`, `Agg_Ignore_Text`). |
| **`Error_Propagation`** | How early exits and bubbling occur (e.g., `#VALUE!` on type failure, `#DIV/0!` on zero division). |
| **`FEC_Profile`** | The required host-environment context (see Section 3). |
| **`Thread_Safety`** | Can be calculated concurrently (`true`/`false`). |

---

## 3. FEC Contract Overlay

The Formula Evaluation Context (FEC) represents the host-provided environment external to the pure formula logic. 

**Explicit Architectural Rule:** *A function must not observe, access, or attempt to utilize undeclared FEC facilities. The host/adapter must inject a strictly narrowed capability interface containing only the requested facilities.*

### Capability Families
The FEC exposes distinct capability interfaces (capabilities):
*   `cap_reference_resolution`: Dereferencing abstract ranges into values.
*   `cap_caller_context`: Identifying the cell/range that triggered the evaluation.
*   `cap_time_provider`: Reading system or host clock (volatile).
*   `cap_random_provider`: Sourcing entropy (volatile).
*   `cap_external_provider`: Interacting with network/external data.
*   `cap_locale_parse_format`: Culture-specific string/number parsing and formatting.
*   `cap_feature_gate`: Checking active Excel calculation engine features (e.g., Dynamic Arrays).
*   `cap_error_detail_enrichment`: Appending rich diagnostic data to error types.

### FEC Dependency Profiles
Functions must statically declare one of the following profiles to request their required capabilities:
*   `none`: Pure function. Requires zero capabilities. (e.g., `SIN`)
*   `ref_only`: Requires only `cap_reference_resolution`. (e.g., `SUM`)
*   `caller_context`: Requires `cap_caller_context`. (e.g., `ROW()` with no args)
*   `time_provider`: Requires `cap_time_provider`. (e.g., `NOW`)
*   `random_provider`: Requires `cap_random_provider`. (e.g., `RAND`)
*   `external_provider`: Requires `cap_external_provider`.
*   `locale_profile`: Requires `cap_locale_parse_format`. (e.g., `VALUE`)
*   `composite`: An explicitly declared union of multiple capabilities.

---

## 4. XLL Registration/Type Mapping Plan

To bridge the conceptual contract with the C-API `.xll` interface, the registration process (`xlfRegister`) relies on a deterministic mapping algorithm based on the function's Semantic Contract.

*   **`pxTypeText` Generation:**
    *   *Inputs:* Map conceptual `Number` to `B` (double) or `Q` (XLOPER12). Use `U` or `Q` for references/arrays to intercept and handle them via Layer A.
    *   *Outputs:* Generally `Q` or `U` to allow returning rich error types or arrays.
*   **Macro Sheet Equivalent (`#`):** Excluded for pure worksheet functions unless explicitly required by the capability profile (e.g., needing macro-sheet-only evaluation context).
*   **Volatile Modifier (`!`):** Automatically appended to the `pxTypeText` string *if and only if* the `FEC_Profile` is `time_provider` or `random_provider`.
*   **Thread-Safe Modifier (`$`):** Automatically appended if `Thread_Safety` is `true` and the `FEC_Profile` does not contain `cap_external_provider` or thread-unsafe variants of `cap_caller_context`.
*   **Cluster-Safe Modifier (`&`):** Applied to strictly `none` profile functions.

---

## 5. Two-Layer Implementation Template

To satisfy the clean-room and conformance constraints, every function is split physically and logically into two layers.

### Layer A: Declarative Adapter (Boundary)
*   **Responsibility:** Interfacing with the XLL C-API (`XLOPER12`), applying the `Coercion_Profile`, verifying arity, evaluating `FEC_Profile` requirements, and normalizing references.
*   **Execution Flow:**
    1. Unpack `XLOPER12` arguments.
    2. Check arity and structural validity.
    3. Instantiate the narrowed FEC object (e.g., if `profile == none`, pass a `NullFecProvider`).
    4. Perform pre-coercion (e.g., resolving `cap_reference_resolution` into scalar primitives or memory-safe arrays).
    5. Call Layer B.
    6. Package Layer B output or standard domain errors back into `XLOPER12`.

### Layer B: Typed Core Kernel (Pure Logic)
*   **Responsibility:** The mathematical or domain-specific calculation.
*   **Execution Flow:**
    1. Accepts strictly typed language-native primitives (e.g., `f64`, `int32`, `String`, strongly typed `Matrix<T>`).
    2. Accepts the narrowed FEC Capability Interface (often omitted entirely for `none` profiles).
    3. Executes side-effect-free, host-agnostic logic.
    4. Returns a typed `Result<CoreValue, CoreError>`.

---

## 6. Formal Contract Candidates

### Candidate 1: `SIN` (Pure Math)
*   **FEC Profile:** `none`
*   **Preconditions:** Argument must be coercible to a standard 64-bit IEEE 754 float.
*   **Postconditions:** Returns a float representing the sine of the angle in radians.
*   **Invariants:** Behavior depends purely on the input scalar. No state mutated.
*   **Adapter Coercion:** Empty cell -> `0.0`. Boolean -> `1.0`/`0.0`. String -> Attempt `cap_locale_parse_format`, yield `#VALUE!` on failure.

### Candidate 2: `AVERAGE` (Aggregate)
*   **FEC Profile:** `ref_only` (Requires `cap_reference_resolution` for ranges).
*   **Preconditions:** Arity 1 to 255. 
*   **Postconditions:** Returns the arithmetic mean of all numeric values. If count is 0, returns `#DIV/0!`.
*   **Invariants:** Must ignore blank cells, logical values, and text values *when they occur inside a reference*. Must evaluate/coerce logicals/text *when provided directly as scalar arguments*.
*   **Adapter Coercion:** Layer A traverses references via FEC, filtering ignored types based on origin (inline vs ref), and passes a clean iterator of floats to Layer B.

### Candidate 3: `ROW` (Reference-Sensitive)
*   **FEC Profile:** `composite` (`cap_reference_resolution`, `cap_caller_context`).
*   **Preconditions:** Arity 0 to 1.
*   **Postconditions:** Returns the 1-based row index. If arity is 0, returns the row of the cell containing the formula.
*   **Invariants:** If the reference is a multi-row range, in legacy contexts it returns the top-left row; in dynamic array contexts (checked via `cap_feature_gate`), it returns an array of row indices.

---

## 7. Differential Validation Matrix

To ensure parity between the XLL Add-in and Native Excel, empirical testing must run automated matrices comparing outputs across these axes:

| Vector | Native Excel Behavior | XLL Add-in Target Behavior | Discrepancy Risk |
| :--- | :--- | :--- | :--- |
| **Error Bubbling** | First encountered argument error bubbles up. | Layer A must eagerly evaluate and bubble errors left-to-right. | High (Evaluation order in XLLs can differ based on `pxTypeText`). |
| **String-to-Num Coercion** | Relies on OS/App Locale settings. | Layer A must use `cap_locale_parse_format` matching the host context. | Medium |
| **Empty vs Blank vs Zero** | Context-dependent (e.g., direct arg vs ref arg in `SUM`). | Layer A handles reference origin metadata before passing to Layer B. | High |
| **Extreme Float Limits** | Custom x86 legacy truncation rules in some edge cases. | Layer B implements strict IEEE 754 unless empirical rules dictate Excel's custom epsilon/truncation. | Low/Medium |

---

## 8. Parity-Hypothesis Challenge List

These are the primary hypotheses that threaten the architectural design's ability to perfectly emulate Native Excel, requiring explicit empirical investigation:

1.  **The Implicit Intersection Bypass:** Does the `.xll` interface automatically perform implicit intersection on `XLOPER12` references before Layer A receives them if registered with standard `pxTypeText`, bypassing our ability to support Dynamic Arrays properly?
2.  **The Coercion Localization Gap:** Does Native Excel expose its exact internal number-parsing rules to `.xll` add-ins via the C-API, or will `cap_locale_parse_format` be forced to rely on close-but-imperfect OS-level standard libraries?
3.  **The #SPILL! Opacity:** Can the XLL adapter reliably detect when a returned array will cause a `#SPILL!` error, or is that strictly handled by the host post-execution? (Impacts `cap_error_detail_enrichment`).
4.  **The Volatile Edge-Cases:** Are there "non-interesting" functions that possess hidden volatility or recalculation dependencies that our `none` profile will miss (e.g., `CELL` function behaviors)?

---

## 9. Promotion Pack

**Decisions Made:**
*   Strict Layer A (Adapter) / Layer B (Core) separation is mandated.
*   FEC capabilities are strictly opt-in and provisioned by the adapter; undeclared usage is an architectural violation.
*   Registration strings (`pxTypeText`) will be procedurally generated from the Semantic Contract.

**Unresolved Items / Assumptions:**
*   *Assumption:* The XLL C-API provides sufficient metadata to differentiate between an inline array `{1,2,3}` and a reference range `A1:A3` when resolving arguments in Layer A.
*   *Assumption:* Multi-threaded recalculation (`$`) behavior in the XLL host perfectly mirrors native graph execution for pure functions.

**Documentation Updates Required:**
*   Update `ARCHITECTURE_AND_REQUIREMENTS.md` to formally adopt the two-layer template.
*   Add the `FEC Dependency Profile` vocabulary to `CORE_ENGINE_FORMAL_MODEL.md`.
*   Create `reference/conformance/excel-worksheet-engine/FEC_CAPABILITIES.md` defining the exact API for each capability.

**Empirical Action Plan (via `excel-probe`):**
1.  **Test Scope:** `SIN`, `AVERAGE`, `ROW`, `VALUE`.
2.  **Experiment 1 (Reference Traversal):** Pass mixed types (strings, bools, blanks, errors) to `AVERAGE` via inline arrays vs. cell references. Log exact inputs/outputs.
3.  **Experiment 2 (Localization):** Force `cap_locale_parse_format` failure cases in `VALUE` using distinct OS locales (e.g., `1.000,00` vs `1,000.00`) and verify native error codes (`#VALUE!`).
4.  **Experiment 3 (Caller Context):** Evaluate `ROW()` within named ranges, conditional formatting, and standard cells to map `cap_caller_context` boundaries.
