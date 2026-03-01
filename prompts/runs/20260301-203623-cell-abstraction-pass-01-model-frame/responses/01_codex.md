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