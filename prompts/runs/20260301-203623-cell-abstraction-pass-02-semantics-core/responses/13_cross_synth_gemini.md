# Response — Synthesis: Cell Abstraction Pass 02 (Semantics Core)

## 1. Consolidated Best Output

This section synthesizes the formal rules governing expression evaluation, implicit value coercion, error propagation, function volatility classifications, and visual formatting side effects for the core calculation engine.

### 1.1 Expression Evaluation and Value Coercion Semantics

**Value Type Universe:**
A cell's computed result resolves to exactly one of the following internal primitive types:
*   `Number`: IEEE 754 double-precision float (encodes all numeric values, including dates/times as serial numbers).
*   `String`: UTF-16 text.
*   `Boolean`: `TRUE` or `FALSE`.
*   `Error`: A specific error token/code.
*   `Empty`: Sentinel for an uninitialized cell or omitted argument (distinct from `0` or `""`).
*   `Array`: Intermediate rectangular matrix. In a single-cell context, resolves to a scalar via implicit intersection (legacy mode) or spills to adjacent cells (dynamic array mode).

**Evaluation Order:**
Evaluation follows strict operator precedence and left-to-right execution. Sub-expression elimination is not guaranteed.

**Coercion Rules:**
Coercion is context-dependent, triggered exclusively by the consuming operator or function parameter, never the producing cell.
*   **Arithmetic Context (`+`, `-`, `*`, `/`, `^`):** `Number` is identity. `Boolean` → `1`/`0`. `Empty` → `0`. `String` → Parsed as number if valid in locale, else `#VALUE!`.
*   **Logical Context:** `Boolean` is identity. `Number` → `0` is `FALSE`, non-zero is `TRUE`. `Empty` → `FALSE`. `String` → `#VALUE!` (except in legacy aggregate functions).
*   **Text Context (`&`):** `String` is identity. `Number` → Base-10 string (General format max 15 digits). `Boolean` → `"TRUE"`/`"FALSE"`. `Empty` → `""`.
*   **Comparison Context (`=`, `<`, `>`):** Follows type-rank ordering: `Number` (rank 0) < `String` (rank 1) < `Boolean` (rank 2). Differing types do not coerce; the lower rank is mathematically "less than."
*   **Function Arguments:** Functions utilize three coercion modes:
    1.  *Strict-typed:* No coercion (yields `#VALUE!`).
    2.  *Arithmetic-coercing:* Applies standard arithmetic coercion rules.
    3.  *Aggregate-scanning:* When scanning *ranges* (e.g., `SUM(A1:A10)`), differing types are typically **skipped** rather than coerced. However, if passed as direct literals (e.g., `SUM(TRUE)`), they are coerced.

### 1.2 Error Behavior and Propagation Lattice

**Error Universe:**
*   *Classic:* `#NULL!`, `#DIV/0!`, `#VALUE!`, `#REF!`, `#NAME?`, `#NUM!`, `#N/A`.
*   *Modern/Dynamic:* `#SPILL!`, `#CALC!`, `#BLOCKED!`, `#CONNECT!`, `#GETTING_DATA`, `#FIELD!`.

**Propagation Model (No Severity Lattice):**
There is **no formal priority or severity lattice** among error types. Propagation is strictly spatial/temporal:
*   **Strict Contexts:** Most operators and functions propagate errors. When multiple operands evaluate to errors, the **first-evaluated (leftmost)** error dictates the result. Formally: `join_error(a,b) = earlier_origin(a,b)`.
*   **Short-Circuit Functions:** `IF`, `IFS`, `CHOOSE`, `SWITCH` evaluate conditions lazily. Errors in untaken branches are suppressed and do not propagate.
*   **Masking Functions:** `IFERROR` catches any error; `IFNA` catches only `#N/A`.
*   **Aggregate Functions:** An error anywhere in a scanned range forces the entire aggregation to yield that error, unless explicitly ignored (e.g., via `AGGREGATE`).

### 1.3 Function Semantics Classification

To optimize the dependency graph and calculation cycles, functions are classified into orthogonal tags representing their side-effects and volatility:

1.  **Pure ($\mathbb{P}$):** Deterministic on explicit input values. No host state dependency. Recalculates only when precedents change. (e.g., `SUM`, `VLOOKUP`).
2.  **Volatile ($\mathbb{V}$):** Output may change without input alterations. Must recalculate on *every* engine calculation cycle. Marks dependent sub-graphs as dirty. (e.g., `RAND`, `NOW`, `TODAY`). *Note:* Functions like `INDIRECT` and `OFFSET` are designated volatile primarily due to the engine's inability to statically resolve their dynamic reference dependencies.
3.  **Host-Context ($\mathbb{H}$):** Depends on workbook/sheet metadata, locale, or UI state. (e.g., `CELL`, `INFO`, `ROW`).
4.  **External / Async ($\mathbb{E}$):** Relies on out-of-process data streams or network services. Triggers transitional error states (`#GETTING_DATA`). (e.g., `RTD`, `WEBSERVICE`).
5.  **Structural-Reference Sensitive ($\mathbb{S}$):** Semantics and dependency footprints shift based on table geometry or address topology rather than underlying cell values. (e.g., `ROWS`, `COLUMNS`).

*Formalization note: The engine should track a metadata schema per function: `FunctionMeta = { strictness, volatility, host_context, externality, ref_sensitivity }`.*

### 1.4 Value-to-Display Formatting Semantics

Calculations strictly operate over the raw mathematical value ($V_{calc}$). Formatting is a uni-directional visual projection that **never mutates $V_{calc}$**.

**The Display Pipeline:**
1.  **Raw Value:** Computed typed result from AST evaluation.
2.  **Number Format:** Transforms value to string via format codes (e.g., `positive_format;negative_format;zero_format;text_format`). Dates utilize the underlying serial number.
3.  **Conditional Formatting (CF):** Evaluated as a separate overlay AST *after* $V_{calc}$ is locked. Rules are evaluated in priority order. `Stop If True` halts execution. CF may override the number format, fill, or font, but never alters $V_{calc}$.
4.  **Column Width:** May trigger text truncation or numerical overflow placeholders (`###`).

*Note:* Auto-formatting (e.g., typing `1/1/2026` and the cell adopting a Date format) is an input-parsing UI side-effect, not an evaluation semantic. Programmatic formula writes do not inherently trigger auto-formatting.

---

## 2. Conflict Resolution Notes

*   **Error Precedence vs. Severity Lattice:** A common misconception is that errors have a hierarchical "severity" (e.g., `#REF!` beating `#VALUE!`). Synthesis favored Claude and Codex's empirical evidence: propagation is purely determined by left-to-right AST evaluation order (`earlier_origin`). Gemini's mention of a "lattice" was recontextualized to clarify this temporal strictness.
*   **Coercion Nuance:** Gemini and Codex provided broad coercion matrices, but Claude correctly highlighted the critical behavioral split in Excel between *direct argument coercion* (where `SUM(TRUE)` coerces to `1`) and *aggregate range scanning* (where `SUM(A1:A10)` skips a `TRUE` in the range). This split was formalized in the final output.
*   **Volatility of INDIRECT/OFFSET:** While Codex correctly listed these as volatile, Claude provided the architectural rationale: they are volatile due to dynamic graph limitations, not pure non-determinism. This nuance was retained as it impacts future engine optimization strategies.

---

## 3. Residual Uncertainties

Promotion of these rules requires empirical resolution of the following uncertainties against the target conformance baseline (Excel 365).

| ID | Description | Required Evidence / Test Vector |
| :--- | :--- | :--- |
| **U-01** | String Collation & Type Comparison | Matrix testing `=A1>A2` comparing differing type ranks, and string collation across locales (e.g., Turkish dotless-i). |
| **U-02** | Multi-Error Aggregate Propagation | Given a range with `#N/A` and `#VALUE!` at different coordinates, verify which error the `SUM` function propagates. |
| **U-03** | Localized Boolean Coercion | Test `=TRUE&""` in English vs. French/German locales. Does it yield `"TRUE"` or `"VRAI"`? |
| **U-04** | Volatile-Once Semantics | Do functions like `INFO("directory")` recalculate on *every* cycle, or just once per session (as in LibreOffice)? |
| **U-05** | Format Inheritance on Formula Overwrite | If a user formats a cell as a Date, and a subsequent formula writes a numeric float to it, does the Date format perfectly persist? |
| **U-06** | Volatility Cascade in Spill Arrays | If a dynamic array formula features `RAND()` inside an `IF(FALSE, ...)` untaken branch, is the whole spilled array flagged as volatile? |
| **U-07** | Modern Array Error Precedence | When `#SPILL!` intersects structurally with an internal calculation error like `#CALC!` or `#DIV/0!`, which error dominates the cell output? |

---

## 4. Immediate Next Actions

1.  **Generate Conformance Fixtures:** Use the `tools/excel-probe/` directory to create a test workbook suite resolving uncertainties `U-01` through `U-07`.
2.  **Define `FunctionMeta` Schema:** Draft a machine-readable JSON/CSV registry mapping standard Excel functions to their specific `strictness`, `volatility`, and `coercion_mode` classes.
3.  **Lift to Formal Model:** Once `U-07` (Array Error Precedence) is empirically resolved, lift Section 1 of this document directly into `CORE_ENGINE_FORMAL_MODEL.md`.
4.  **Schedule Follow-up Passes:**
    *   *Reference Model Pass:* To formalize range intersection (`:` , ` `) and structured reference semantics.
    *   *External Functions Pass:* To document `#GETTING_DATA` RTD lifecycle hooks and throttle bridging.
