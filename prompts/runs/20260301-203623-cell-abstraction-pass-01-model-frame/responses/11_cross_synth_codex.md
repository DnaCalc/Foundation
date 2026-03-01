## 1. Consolidated Best Output

### 1.1 Abstract domains and entities (integrated model)

| Domain | Purpose | Core entities |
|---|---|---|
| Addressing | Identify referenced data in a grid-like model | `CellId`, `Ref`, `RangeRef`, `NameRef` |
| Input and parse | Convert user input into semantic form | `RawInput`, `CellInput = Empty | Literal(v) | Formula(e)`, `ParseRule` |
| Expression | Represent formula structure independent of UI syntax | `Expr` AST (`Lit`, `Ref`, `BinOp`, `FnCall`, `Array`, `Name`) |
| Value and error | Define runtime result space | `Value = Num | Text | Bool | Blank | Error(ErrorKind) | ArrayValue` |
| Coercion | Make implicit conversions explicit and testable | `CoercionContext`, `CoercionRule`, function-level coercion overrides |
| Eval context and determinism boundary | Separate in-cell semantics from scheduler | `Snapshot(Σ: Ref→Value)`, `Ambient(Ξ: time/random/locale)`, `Profile(Π)` |
| Evaluation execution and observability | Produce reproducible outcomes and traceability | `Registry(Λ)`, `EvalResult ρ = Ok(v,deps,events) | Fail(err,deps,events)`, `DepSet`, `EventLog` |
| Presentation and lifecycle | Distinguish stored value from display and edits | `FormatSpec`, `DisplayString`, `CellState S=<raw,ci,e,last,meta>` |

### 1.2 Notation and judgment forms for a living formal model doc

- Symbols: `Π` profile, `Σ` snapshot, `Ξ` ambient tokens, `Λ` op/function semantics, `e` expression, `v` value, `ρ` eval result, `S` cell state.
- Judgments:
1. `raw ⊳_Π ci` (parse/classify input)
2. `Π ⊢ ci ⇝ e | parseErr` (normalize to AST)
3. `Σ ⊢ r ↦ v | err` (reference resolution)
4. `Π, κ ⊢ v ⇢ v' | err` (contextual coercion)
5. `⟨Λ, Π, Σ, Ξ⟩ ⊢ e ⇓ ρ` (expression evaluation)
6. `v ⊕ fmt ⇒ s` (display formatting)
7. `S ⟶[edit|recalc] S'` (cell state transition)
8. `Impl(Π) ⊨ caseId` iff observed matches expected under declared comparator.
- Rule metadata per living doc rule: `RuleId`, `Status(draft|provisional|validated)`, `Scope(core|excel|extension)`, `EvidenceRef`.

### 1.3 Excel-anchored examples by domain (generic-first naming)

| Domain | Abstract example | Excel anchor |
|---|---|---|
| Addressing | `Ref(c1)` and `Range(c2,c5)` | `A1`, `B2:C5` |
| Input and parse | `raw="=Ref(c1)+2" -> Formula(Add(Ref(c1),Num(2)))` | `=A1+2` |
| Expression | `Call(sum,[Range(c1,c3)])` | `SUM(A1:A3)` |
| Value and error | `Blank` distinct from `Text("")` | empty cell vs `=""` |
| Coercion | `WantNum(Text("2")) -> Num(2)`; `WantNum(Text("x")) -> Error(VALUE)` | `="2"+1`, `="x"+1` |
| Eval context/determinism | `Ξ.time` consumed by `NowFn()` | `NOW()` |
| Eval output/trace | `ρ=Ok(Num(5), deps={c1,c2}, events=[read,div])` | `=A1/B1` logs reads of `A1`,`B1` |
| Presentation/lifecycle | `Num(0.5)` with `PercentFmt` renders `"50%"` | `0%` number format |

### 1.4 Ambiguities and missing evidence (spec-gap vs empirical-gap)

| ID | Gap | Class | Evidence needed |
|---|---|---|---|
| G1 | Full coercion matrix by context/operator/function | spec-gap | Normative decision table + profile rules |
| G2 | `Blank` vs `Text("")` semantics across functions (e.g., `COUNTBLANK`, `IF`) | spec-gap | Explicit rule text and conformance cases |
| G3 | Error precedence when multiple subexpressions are errors | spec-gap | Deterministic precedence rule |
| G4 | Quote-prefix semantics at evaluation/coercion boundaries | spec-gap | Rule definition tied to parse metadata |
| G5 | Dynamic array spill/intersection semantics in formal core | spec-gap + empirical-gap | Boundary spec + edge-case test corpus |
| G6 | Branch evaluation/short-circuit behavior (`IF`, `IFS`, `CHOOSE`) | empirical-gap | Probe tests with branch-side effects/errors |
| G7 | Cross-version divergence (desktop/web/channel) on coercion/parse edges | empirical-gap | Versioned matrix runs |
| G8 | Locale/date serial and Num→Text precision behavior | empirical-gap | Locale/build-specific test corpus |
| G9 | LET/LAMBDA lexical scoping and capture edge cases | empirical-gap | Nested-scope conformance tests |
| G10 | Floating-point comparison/tolerance conventions for conformance | empirical-gap | Comparator policy and numeric corpus |

---

## 2. Conflict Resolution Notes

| Conflict across base outputs | Resolution used | Why |
|---|---|---|
| Domain count/granularity differs (5 vs 6 vs 9) | Use layered 8-domain model | Keeps Claude’s clarity, Codex traceability, Gemini state framing |
| Is formatting in-cell or out-of-scope? | Include as separate presentation layer after evaluation | Needed for user-visible behavior, but does not mutate stored value |
| Volatility treatment (exclude vs include) | Recalc policy out-of-scope; volatile inputs explicit via `Ξ` | Preserves cell purity while modeling `NOW/RAND` deterministically |
| Result shape (value-only vs traced result) | Use `ρ` with `value/error + deps + events` | Better conformance, diagnostics, and replay |
| Dynamic arrays and modern features | Keep in core value domain but mark extension/provisional | Avoids hard exclusion while preserving standards uncertainty |
| Short-circuit classification | Treat as empirical-first gap with profile rule hook | Behavior is observable and must be validated in target engine |

---

## 3. Residual Uncertainties

1. Whether one global coercion matrix is sufficient, or function-local overrides dominate enough to require per-function semantics first.
2. Exact error precedence policy (left-to-right, function-defined, or error-kind priority) remains unresolved.
3. Dynamic array semantics may require a tighter interface between “in-cell” and scheduler/spill placement than currently modeled.
4. Locale-dependent parse and display rules may force locale into both parse and format judgments, not just ambient evaluation.
5. Numeric conformance may need comparator modes (`exact`, `ULP`, `tolerance`) rather than one equality rule.

---

## 4. Immediate Next Actions

1. Freeze a minimal `Profile (Π)` schema (`parse`, `coercion`, `functions`, `errors`, `format`, `extensions`).
2. Author a v1 coercion decision table for arithmetic, comparison, logical, and concatenation contexts.
3. Define error propagation and interception rules, including precedence defaults and function overrides.
4. Publish a compact conformance case format with declared comparator and evidence reference.
5. Seed 20-30 Excel-anchored cases covering G1-G4 before broader feature expansion.
6. Run empirical passes for G6-G10 across at least Excel desktop and web, then split stable vs profile-specific behavior.