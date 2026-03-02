# Excel Cell Concrete Model

## 1. Purpose
This document defines a concrete, Excel-first model for in-cell behavior.

It is intended to be:
1. nitpickable and implementation-oriented,
2. explicitly traceable to source evidence and conformance requirements,
3. the precursor to later abstraction extraction.

## 2. Scope Boundary
In scope:
1. Cell input classification and parse rules.
2. Formula language syntax, operators, and reference forms.
3. Value/tag universe and coercion behavior in operator/function contexts.
4. In-cell evaluation semantics (including errors, array/spill behavior visible from formulas).
5. Function behavior classes relevant to in-cell semantics.
6. Value-to-display and conditional-format interaction at the cell boundary.
7. Table/structured-reference behavior as visible from formulas.

Out of scope:
1. Workbook-wide scheduling and dependency graph orchestration.
2. Power Query/DAX languages.
3. MDX internals (while CUBE worksheet functions remain in scope at worksheet boundary).

## 3. Statement and Trace Contract
Concrete model statements use `ECM-*` ids.

Every statement must be traceable via `EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl` to:
1. one or more `XLS-CF-*` requirement ids, and
2. one or more evidence ids (`ECS-*`, `REFX-*`, `EMP-*`).

## 4. Concrete Model Sections

### 4.1 Input and Parse Classification
- `ECM-INP-001` (draft): Cell input is classified as empty, literal, or formula with Excel parse heuristics.
- `ECM-INP-002` (draft): Quote-prefix text forcing remains distinct from semantic value and can affect parse/classification behavior.
- `ECM-INP-003` (draft): Date/time and numeric auto-detection are locale/build sensitive and must be represented with caveat flags.

### 4.2 Formula Language and Grammar
- `ECM-FML-001` (draft): Formula parser supports Excel reference operators `:`, `,`, and intersection (space) with documented precedence constraints.
- `ECM-FML-002` (provisional): Dynamic-array operators `@` and `#` are first-class syntax with explicit evaluation semantics.
- `ECM-FML-003` (draft): Structured references are first-class formula syntax and not UI-only sugar.
- `ECM-FML-004` (provisional): Grammar coverage follows formal MS-XLSX anchors plus observed worksheet behavior; divergence requires explicit note.

Detailed rule set:
1. `EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md` is the concrete rule table and empirical linkage artifact for `ECM-FML-*`.
2. `EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv` is the status/evidence/probe control table for `FML-R-*` progression.
3. `EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md` defines deferred empirical scenarios for unresolved formula-language lanes.

Initial concrete rules (draft):
1. Reference operators are recognized as distinct AST operators:
   - range `:`,
   - union `,`,
   - intersection ` ` (space operator).
2. Operator-precedence ordering (highest to lowest) is modeled with explicit reference-operator tier above arithmetic/comparison tiers; exact parse ambiguities remain tracked in open questions.
3. `@` is parsed as explicit implicit-intersection operator node, not as decoration.
4. `#` is parsed as explicit spilled-range reference operator node bound to a spill anchor expression/reference.
5. Structured references (table column selectors, row selectors, qualifiers) are parsed as first-class reference syntax and flow into normal formula binding/evaluation.
6. Parser behavior that diverges from baseline formal grammar must be retained as explicit compatibility notes with evidence ids; no silent grammar widening.

### 4.3 Value Universe and Type Tags
- `ECM-TYP-001` (draft): Worksheet-visible core value tags include number, text, boolean, error, blank/empty, and array semantics at formula boundary.
- `ECM-TYP-002` (draft): Extended/linked data-type behavior is modeled at worksheet-observable boundary with limited depth.
- `ECM-TYP-003` (draft): Date serial behavior is represented explicitly with 1900/1904 system caveats.

### 4.4 Coercion and Comparison Semantics
- `ECM-COE-001` (draft): Coercion is context-dependent and driven by consuming operator/function behavior.
- `ECM-COE-002` (draft): Coercion matrices are required for arithmetic, comparison, logical, concatenation, and aggregate contexts.
- `ECM-COE-003` (draft): Locale-sensitive parse/coercion behavior is a first-class conformance axis.

Initial concrete rules (draft):
1. Coercion trigger source is the consuming context (operator/function argument position), never producer-side cell storage type.
2. Coercion matrix is context-scoped:
   - arithmetic context,
   - comparison context,
   - logical context,
   - text/concatenation context,
   - aggregate scan context.
3. Range-scan aggregate behavior is tracked independently from direct-literal argument behavior due known divergence lanes.
4. Locale-sensitive text-to-number behavior is modeled as an explicit axis; rules must carry locale/build caveat capability.

### 4.5 Evaluation and Error Semantics
- `ECM-EVL-001` (draft): In-cell evaluation semantics define deterministic operator/function result behavior given a resolved reference context.
- `ECM-EVL-002` (draft): Error propagation/interception behavior is explicit and function-policy aware.
- `ECM-EVL-003` (draft): Dynamic-array spill placement/blocking and spill-related error surfaces are explicit conformance lanes.

Initial concrete rules (draft):
1. In-cell evaluator consumes a resolved reference context and does not define workbook scheduling order.
2. Evaluation order and error-propagation policy must be deterministic for conformance replay.
3. Function policies can differ by function class (strict, masking, branch-dependent, external-state dependent) and must be explicit.
4. Spill behaviors are represented as formula-visible outcomes, including blocked spill errors and dependent reference effects.

### 4.6 Function Semantics and Classification
- `ECM-FUN-001` (draft): Built-in function universe tracks 500-function baseline with tiered interesting-function classification.
- `ECM-FUN-002` (draft): High-interest function classes (volatile, external, structural-reference-sensitive, modern functional/dynamic-array) are explicitly modeled.
- `ECM-FUN-003` (draft): CUBE family inclusion is required for completeness with deferred depth caveat.

### 4.7 Formatting and Conditional Formatting Boundary
- `ECM-FMT-001` (draft): Number-format grammar and render behavior are represented as worksheet-visible conformance requirements.
- `ECM-FMT-002` (draft): Value semantics and display formatting semantics are distinct layers; formatting must not silently mutate value semantics.
- `ECM-FMT-003` (draft): Conditional-format overlap/priority behavior is captured as explicit rules with provisional lanes where evidence conflicts.

Initial concrete rules (draft):
1. Stored value semantics and rendered display semantics are modeled as separate layers.
2. Number-format behavior is treated as a parse/render language with explicit grammar and section semantics.
3. Conditional-format rule evaluation and style-priority resolution are explicit conformance lanes, including spill-target conflict lanes.

### 4.8 Tables and Structured References
- `ECM-TBL-001` (draft): Table structured-reference syntax/semantics are part of formula evaluation scope.
- `ECM-TBL-002` (draft): Calculated-column auto-fill/auto-expand behavior is a required worksheet conformance lane.
- `ECM-TBL-003` (draft): Spill and table interaction behavior remains explicit, including unresolved mismatch lanes.

## 5. Review and Progression Status
Status tags:
1. `draft`: seeded statement; wording/coverage not yet tightened.
2. `provisional`: conflicting or incomplete evidence remains.
3. `validated`: statement wording and evidence are accepted for implementation/test guidance.

Current status: initial seeded draft skeleton for concrete-model tightening.

## 6. Extraction Gate
Abstraction extraction should start only after:
1. key P0/P1 concrete statements are at least `provisional` with explicit evidence binding,
2. unresolved items are enumerated in `EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`,
3. trace coverage is complete for retained `ECM-*` statements.

## 7. Requirement-Binding Snapshot
Current binding authority remains:
1. `CONFORMANCE_REQUIREMENTS.csv` for release-gate requirements.
2. `EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl` for statement-level links.

Initial domain binding snapshot:
| model_area | key_model_ids | primary_requirement_lanes |
|---|---|---|
| Input/Parse | ECM-INP-001..003 | XLS-CF-FL-006; XLS-CF-FL-010; XLS-CF-FL-011 |
| Formula Language | ECM-FML-001..004 | XLS-CF-FL-001..011 |
| Value/Types | ECM-TYP-001..003 | XLS-CF-TV-001..006 |
| Coercion | ECM-COE-001..003 | XLS-CF-TV-003; XLS-CF-TV-007; XLS-CF-TV-008 |
| Evaluation/Error | ECM-EVL-001..003 | XLS-CF-FL-005; XLS-CF-FN-003; XLS-CF-FN-011 |
| Functions | ECM-FUN-001..003 | XLS-CF-FN-001..008; XLS-CF-FN-010 |
| Formatting | ECM-FMT-001..003 | XLS-CF-FM-001..005 |
| Tables | ECM-TBL-001..003 | XLS-CF-TB-001..004 |

This table is intentionally compact; per-statement trace detail belongs in the JSONL trace file.
