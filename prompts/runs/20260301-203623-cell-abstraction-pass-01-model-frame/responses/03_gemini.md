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
