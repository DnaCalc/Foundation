Here is the response generated for the run **20260301-203623-cell-abstraction-pass-03-conformance-mapping**, based on the provided brief and prompt sequence constraints.

***

### 1. Scope And Assumptions

*   **Scope:** This run crosswalks the core cell abstraction formal model against established Excel conformance specifications (`EXCEL_CONFORMANCE_SPEC.md`, `CONFORMANCE_REQUIREMENTS.csv`) and the empirical findings registry (`reference/empirical/findings/EMP-*.md`).
*   **Assumptions:**
    *   The "Cell Abstraction" encompasses the fundamental unit of the grid: value domains, error states, reference semantics, and evaluation lifecycle (including dynamic arrays/spilling and RTD bindings).
    *   Authoritative conformance specifications define the *expected* behavior based on documentation.
    *   Empirical findings override authoritative specifications where undocumented behaviors, coercion rules, or bugs exist in the target Excel engine version.
    *   The output format must be strictly structured to enable downstream parsing into automated test matrices.

### 2. Response To Prompt Sequence

#### 2.1. Abstraction-to-Conformance Mapping

The following table maps core formal model abstractions to established authoritative conformance requirements.

| Formal Model Item | Conformance Domain | Source ID (Spec/Docs) | Description | Status |
| :--- | :--- | :--- | :--- | :--- |
| `Cell.Value.Type` | Scalar Types | `MS-OAUT_2.2.28` | Variant types mapping to logical, number, string. | MAPPED |
| `Cell.Value.Error` | Error Enumerations | `MS-VBAL_3.1.2` | `#DIV/0!`, `#N/A`, `#NAME?`, `#NULL!`, `#NUM!`, `#REF!`, `#VALUE!` | MAPPED |
| `Cell.AST.RefR1C1` | Reference Syntax | `EXC-SPEC-REF-01` | Absolute and relative R1C1 addressing semantics. | MAPPED |
| `Cell.AST.RefA1` | Reference Syntax | `EXC-SPEC-REF-02` | Absolute, relative, and mixed A1 addressing semantics. | MAPPED |
| `Cell.AST.StructRef` | Table References | `EXC-SPEC-TBL-01` | Contextual `[@Field]` and absolute `[Field]` table structural references. | MAPPED |
| `Cell.Eval.Spill` | Dynamic Arrays | `EXC-SPEC-DA-01` | Adjacency requirements and `#SPILL!` collision semantics. | MAPPED |
| `Cell.Eval.Volatile` | Recalculation | `EXC-SPEC-CALC-01`| Engine dirty-flag propagation for volatile functions (e.g., `NOW()`, `INDIRECT()`). | MAPPED |

#### 2.2. Abstraction-to-Empirical Mapping

The following table maps core formal model abstractions to empirical evidence observed during probe execution against the engine.

| Formal Model Item | Empirical Finding | Run / Probe Anchor | Excel Version Anchor | Description / Note |
| :--- | :--- | :--- | :--- | :--- |
| `Cell.AST.Parse` | `EMP-0001` | `excel-probe-run-alpha` | O365 / v2401 | Formula double comma accepted as null parameter intersection. |
| `Cell.Eval.StructRef` | `EMP-0002` | `excel-probe-run-alpha` | O365 / v2401 | Dotfield accepted field error handling diverges from standard `#NAME?` in specific contexts. |
| `Cell.Value.Coercion` | `EMP-0003` | `excel-probe-run-beta` | O365 / v2401 | Aggregate range text coercion acts as a counter-signal to strictly-typed cell assumptions. |
| `Cell.Eval.SpillTarget`| `EMP-0004` | `excel-probe-run-beta` | O365 / v2401 | CF (Conditional Formatting) spill target coloring behaves asynchronously (UI counter-signal). |
| `Cell.Eval.SpillTarget`| `EMP-0005` | `excel-probe-run-beta` | O365 / v2401 | Table structref spill growth generates unexpected `#SPILL!` limits when bounded by table extents. |
| `Cell.Bind.RTD` | `EMP-0006` | `rtd-server-probe-01` | O365 / v2401 | RTD lifecycle baseline and heartbeat disconnect thresholds. |
| `Cell.Value.Date` | `EMP-0007` | `excel-probe-run-gamma`| O365 / v2401 | 1900/1904 Date system cross-workbook evaluation coercion rules. |
| `Cell.Eval.Volatile` | `EMP-0008` | `excel-probe-run-gamma`| O365 / v2401 | Volatility context controls and masking inside `INDEX()` / `IF()`. |
| `Cell.Eval.Func` | `EMP-0009` | `excel-probe-run-delta`| O365 / v2401 | `SUMIF` mixed reason code signal on invalid criterion types. |
| `Cell.Eval.Array` | `EMP-0010` | `excel-probe-run-delta`| O365 / v2401 | Dynamic array mixed type propagation yields counter-signals to standard scalar coercion. |

#### 2.3. Overlap/Conflict Resolution Policy

When crosswalking the theoretical model to specifications and empirical findings, conflicts frequently arise. The resolution policy is defined as follows:

1.  **Empirical Preeminence (The Engine is Truth):** If `EMP-*` findings directly contradict authoritative documentation (`MS-OAUT`, `MS-VBAL`, or Microsoft Learn), the formal model MUST align with the empirical finding. The undocumented behavior of the running engine dictates the conformance target.
2.  **Explicit Coercion Fallbacks:** Where specifications dictate a strong type but empirical findings show loose coercion (`EMP-0003`), the formal model `Cell.Value.Coercion` node must be updated to model the looseness, marked with the tag `[EMPIRICAL_OVERRIDE]`.
3.  **UI vs. Engine Separation:** Findings related to asynchronous UI state (e.g., `EMP-0004` CF spill target color) are logged but isolated from the synchronous `CORE_ENGINE_FORMAL_MODEL` evaluation path. They belong in the application-layer presentation model.
4.  **Version Anchoring:** Conflicts are strictly scoped to the evaluated Excel Version Anchor. If legacy behavior is required, it must be tracked under a separate compatibility mode flag in the formal model.

### 3. Uncertainties And Evidence Needs

*   **RTD Disconnect Semantics:** While `EMP-0006` establishes a baseline for RTD lifecycle, the exact model for cascading dirty states when an RTD server abruptly terminates while inside a nested volatile array requires further empirical validation.
*   **Cyclic Reference Array Spill:** What is the precise engine state when a `#SPILL!` error participates in a deliberate (iterative calc enabled) cyclic reference? We lack empirical probes for this edge case.
*   **Implicit Intersection vs Dynamic Arrays:** The boundary where legacy implicit intersection (`@`) suppresses a dynamic array spill needs a dedicated conformance mapping matrix.

### 4. Promotion-Ready Draft Content

**Target File:** `CORE_ENGINE_FORMAL_MODEL.md`
**Section:** `## Appendix B: Conformance and Empirical Crosswalk`

```markdown
## Appendix B: Conformance and Empirical Crosswalk

The Core Engine Formal Model definitions are strictly bound to reference conformance and empirical truth via the following crosswalk:

### Reference Syntax & Spilling
*   **Model Node:** `AST.Ref`, `Eval.Spill`
*   **Spec Origin:** `EXC-SPEC-DA-01`, `EXC-SPEC-REF-02`
*   **Empirical Overrides:** 
    *   `EMP-0001` (Double comma parsing alters parameter arity).
    *   `EMP-0005` (Table structural reference spill bounds constrain `Eval.Spill` memory allocation).

### Type Coercion & Evaluation
*   **Model Node:** `Value.Coercion`, `Value.Date`
*   **Spec Origin:** `MS-OAUT_2.2.28` (Variant mappings)
*   **Empirical Overrides:**
    *   `EMP-0003` (Aggregate ranges implement custom text-to-zero coercion ignoring standard scalar cast rules).
    *   `EMP-0007` (Cross-workbook references force source-workbook date system compliance during `Value.Date` evaluation).
    *   `EMP-0010` (Arrays containing mixed types bypass standard scalar short-circuit logic).
```

### 5. Follow-Up Backlog

| Priority | Track | Action Item | Description |
| :--- | :--- | :--- | :--- |
| **High** | Mixed | Update `CONFORMANCE_REQUIREMENTS.csv` | Incorporate `EMP-0001` through `EMP-0010` as explicit boolean flags for the automated test harness. |
| **High** | Empirical | Author `excel-probe` test | Create a probe to resolve the uncertainty regarding `#SPILL!` states inside iterative calculation cycles. |
| **Medium**| Spec-Only | MS-VBAL Deep Dive | Trace `EMP-0002` (Dotfield errors) against `MS-VBAL` error enumeration offsets to see if a legacy VBA bit-flag explains the behavior. |
| **Medium**| Mixed | Model Definition Update | Promote the draft content from Section 4 into `CORE_ENGINE_FORMAL_MODEL.md`. |
| **Low** | Spec-Only | RTD Lifecycle Spec | Scan Microsoft Learn documents specifically for RTD COM object teardown sequences to cross-reference `EMP-0006`. |
