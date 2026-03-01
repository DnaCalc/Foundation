C:\Users\GovertvanDrimmelen\AppData\Roaming\npm\node_modules\@google\gemini-cli\node_modules\@lydell\node-pty\conpty_console_list_agent.js:11
var consoleProcessList = getConsoleProcessList(shellPid);
                         ^
System.Management.Automation.RemoteException
Error: AttachConsole failed
    at Object.<anonymous> (C:\Users\GovertvanDrimmelen\AppData\Roaming\npm\node_modules\@google\gemini-cli\node_modules\@lydell\node-pty\conpty_console_list_agent.js:11:26)
    at Module._compile (node:internal/modules/cjs/loader:1760:14)
    at Object..js (node:internal/modules/cjs/loader:1892:10)
    at Module.load (node:internal/modules/cjs/loader:1480:32)
    at Module._load (node:internal/modules/cjs/loader:1299:12)
    at TracingChannel.traceSync (node:diagnostics_channel:328:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:245:24)
    at Module.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:154:5)
    at node:internal/main/run_main_module:33:47
System.Management.Automation.RemoteException
Node.js v25.2.0
C:\Users\GovertvanDrimmelen\AppData\Roaming\npm\node_modules\@google\gemini-cli\node_modules\@lydell\node-pty\conpty_console_list_agent.js:11
var consoleProcessList = getConsoleProcessList(shellPid);
                         ^
System.Management.Automation.RemoteException
Error: AttachConsole failed
    at Object.<anonymous> (C:\Users\GovertvanDrimmelen\AppData\Roaming\npm\node_modules\@google\gemini-cli\node_modules\@lydell\node-pty\conpty_console_list_agent.js:11:26)
    at Module._compile (node:internal/modules/cjs/loader:1760:14)
    at Object..js (node:internal/modules/cjs/loader:1892:10)
    at Module.load (node:internal/modules/cjs/loader:1480:32)
    at Module._load (node:internal/modules/cjs/loader:1299:12)
    at TracingChannel.traceSync (node:diagnostics_channel:328:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:245:24)
    at Module.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:154:5)
    at node:internal/main/run_main_module:33:47
System.Management.Automation.RemoteException
Node.js v25.2.0
Here is the synthesized and integrated output, combining Codex's structural rigor and provenance constraints with the factual grounding of the project's actual conformance and empirical evidence base.

### 1. Consolidated Best Output

**1.1. Abstraction-to-Conformance Mapping**
This table crosswalks hypothesized Core Engine Formal Model (AM) items against authoritative normative requirements found in `CONFORMANCE_REQUIREMENTS.csv`.

| Abstract Item ID | Abstract Item | Conformance Req ID | Requirement | Status | Source IDs |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `AM-AST-001` | Formula Grammar / Operator Precedence | `XLS-CF-FL-001` | Engine shall implement operator precedence and reference operators consistent with Excel semantics. | MAPPED | `ECS-003`, `ECS-008` |
| `AM-AST-002` | Reference Operators (Union/Intersection) | `XLS-CF-FL-002` | Engine shall accept range (`:`), union (`,`), and intersection (space) reference operators. | MAPPED | `ECS-003`, `ECS-008` |
| `AM-EVAL-001` | Implicit Intersection | `XLS-CF-FL-003` | Engine shall implement `@` implicit intersection semantics. | MAPPED | `ECS-004`, `ECS-007` |
| `AM-EVAL-002` | Spilled Range Syntax | `XLS-CF-FL-004` | Engine shall implement `#` spilled-range operator behavior. | MAPPED | `ECS-005`, `ECS-006` |
| `AM-EVAL-003` | Dynamic Array Semantics | `XLS-CF-FL-005` | Engine shall implement spill placement/blocking semantics. | MAPPED | `ECS-006`, `ECS-007` |
| `AM-AST-003` | Structured Table References | `XLS-CF-FL-009` | Structured-reference grammar shall be supported as first-class constructs. | MAPPED | `ECS-012`, `ECS-013`, `ECS-014` |

**1.2. Abstraction-to-Empirical Mapping**
This table crosswalks formal model abstractions against actual observed behavior from the `excel-probe` empirical runs. All observations are anchored to a specific build context.

| Abstract Item ID | Empirical ID | Empirical Claim / Observation | Run ID Anchor | Excel Version Anchor | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `AM-AST-002` | `EMP-0001` | `=SUM(A1,,B1)` double-comma intersection is accepted and evaluated. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-AST-003` | `EMP-0002` | Dot-field formula `=A1.Price` is accepted syntactically and yields field-related worksheet error. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-VAL-001` | `EMP-0003` | Aggregate range coercion for SUM/AVERAGE/COUNT over mixed text+numeric diverges from scalars. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-UI-001` | `EMP-0004` | Conditional-format spill-target cells did not show seeded expected color (UI boundary). | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-EVAL-003` | `EMP-0005` | Structured-reference spill growth diverged from seeded expectation after table growth. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-BIND-001` | `EMP-0006` | RTD lifecycle baseline and missing ProgID behaviors executed successfully. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-VAL-002` | `EMP-0007` | Date system (1900/1904) sensitivity confirmed; formula vs serial copy differs across workbooks. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |
| `AM-EVAL-004` | `EMP-0008` | Volatility context controls diverge between volatile/non-volatile; `INFO("recalc")` reflects mode. | `20260228-180047-excel-compat-empirical-pass-01` | `16.0.19725.20126` | provisional |

### 2. Conflict Resolution Notes

When mapping theoretical formalizations to both authoritative specifications (`XLS-CF-*`) and observed engine truth (`EMP-*`), overlaps and conflicts frequently arise. 

**Governing Policy:**
1. **Empirical Preeminence:** If an `EMP-*` finding directly contradicts authoritative documentation or legacy assumptions (e.g., `EMP-0001` allowing empty union parameters that evaluate as intersections), the formal model MUST align with the empirical finding. The execution engine's behavior dictates the ultimate conformance target.
2. **Strict Provenance Gate:** No abstract model claim may be promoted to "verified" without at least one mapped `XLS-CF-*` anchor and one `EMP-*` empirical anchor (including the specific `excel_version`).
3. **UI vs. Core State Separation:** Findings related to asynchronous presentation/UI states (e.g., `EMP-0004` regarding conditional formatting spill coloring) must be bounded strictly to UI abstraction layers, preventing contamination of synchronous `CORE_ENGINE_FORMAL_MODEL` evaluation paths.

### 3. Residual Uncertainties

* **Single-Version Anchoring Constraint:** Currently, all `EMP-*` evidence is anchored to a single Excel version (`16.0.19725.20126`). We lack cross-version differential evidence, making it difficult to discern if behaviors like `EMP-0002` (dot-field acceptance) or `EMP-0010` (dynamic array mixed-type counter-signals) are stable engine semantics or transient version-specific states.
* **Implicit Intersection Boundary:** The exact execution boundaries where legacy implicit intersection (`@`) suppresses a dynamic array spill (involving `EMP-0003` type coercions) require a dedicated structural probe.
* **RTD Nested Volatility:** While `EMP-0006` establishes a baseline for RTD lifecycles, the model lacks empirical findings for cascading dirty states when RTD servers fail abruptly inside a nested volatile array.

### 4. Immediate Next Actions

**Prioritized Backlog**
| Priority | Category | Task |
| :--- | :--- | :--- |
| **P0** | Mixed Evidence | **Checklist Generator Scaffold:** Formalize the extraction of `AM-*`, `XLS-CF-*`, and `EMP-*` mappings into an automated CI test harness matrix. |
| **P0** | Empirical-Only | **Dot-field Resolution:** Execute follow-up tests for `EMP-0002` using true Linked Data-Type cell payloads to strictly bound dot-field evaluation semantics. |
| **P1** | Spec-Only | **Domain Abstraction Inventory Completion:** Exhaustively map the remaining `XLS-CF-FL-*` normative rules to distinct `AM-*` conceptual nodes in the formal model documentation. |
| **P1** | Empirical-Only | **Cross-Version Calibration:** Re-run the `excel-probe` test suite against an older Excel version (e.g., v2308) or Excel for Web to establish baseline feature flags for the empirical claims. |

**Draft Promotion Notes for `CORE_ENGINE_FORMAL_MODEL.md`**

```markdown
## Appendix B: Conformance and Empirical Crosswalk

All abstract node definitions in this formal model are strictly bound to reference conformance and empirical reality. 

Each Core Engine assertion MUST be accompanied by a provenance block:
- **`Conformance Anchor`**: The corresponding `XLS-CF-FL-*` normative constraint from `CONFORMANCE_REQUIREMENTS.csv`.
- **`Empirical Anchor`**: The corresponding `EMP-*` finding demonstrating the engine's real-world behavior, anchored to a specific Excel build (e.g., `16.0.19725.20126`).

**Example: Implicit Intersection Node (`AM-EVAL-001`)**
*   **Spec Requirement**: `XLS-CF-FL-003` dictates `@` operator semantics.
*   **Empirical Overrides**: Reference `EMP-0005` constraints where structural reference spill behavior deviates from theoretical projections bounded by the table extents.
```
