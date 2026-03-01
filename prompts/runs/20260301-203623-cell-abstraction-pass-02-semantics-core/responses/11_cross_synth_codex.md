Run id: `20260301-203623-cell-abstraction-pass-02-semantics-core`

1. **Consolidated Best Output**

**(1) Formalized expression evaluation and value coercion semantics**

```text
Scalar ::= Num(f64) | Text(str) | Bool(bool) | Blank | Err(ErrorCode)
Value  ::= Scalar | Ref(RefSet) | Arr(rows, cols, Scalar|Err)
Result ::= Ok(Value, Meta) | Fail(ErrorToken)
ErrorToken ::= { code: ErrorCode, origin_index: int, phase: bind|eval|spill|async }
Env ::= { workbook_snapshot, calc_epoch, locale, timezone, date_system, array_mode }
```

`Eval(cell, expr, env)` contract:
1. Bind names/references against `workbook_snapshot`.
2. Evaluate AST with fixed precedence and stable `origin_index` per node.
3. Apply function strictness policy to control argument evaluation (`strict`, `branch_lazy`, `mask_*`, etc.).
4. Resolve scalar vs array context (implicit intersection / spill behavior by `array_mode`).
5. Apply context coercion.
6. Return value or deterministic error token.

Context coercion (default):
- `NumCtx`: `Num->Num`, `Bool(TRUE/FALSE)->1/0`, `Blank->0`, `Text->parse(locale) or #VALUE!`.
- `BoolCtx`: `Bool->Bool`, `Num(0/nonzero)->FALSE/TRUE`, `Blank->FALSE`, `Text->UNRESOLVED(U-02)`.
- `TextCtx`: `Text->Text`, `Num->General-format string`, `Bool->"TRUE"/"FALSE" (localization unresolved)`, `Blank->""`.

Operator/function notes:
- Arithmetic operators use `NumCtx`.
- `&` uses `TextCtx`.
- Comparisons are same-type deterministic; cross-type ordering remains `UNRESOLVED(U-01)` (provisional candidate: `Number < Text < Boolean`).
- Aggregators need explicit dual behavior metadata: direct literals may coerce; range scans may skip text/booleans but propagate errors (`UNRESOLVED(U-12)`).

---

**(2) Formalized error behavior and propagation lattice**

Error universe:
`{NULL, DIV0, VALUE, REF, NAME, NUM, NA, SPILL, CALC, FIELD, BLOCKED, CONNECT, GETTING_DATA, UNKNOWN}`

Lattice/propagation model:
- Base: `⊥` = no error.
- No intrinsic precedence by error code.
- In strict composition, propagate earliest evaluated error by `origin_index`:
  `join_error(e1, e2) = min_origin(e1, e2)`.
- This preserves deterministic behavior even with internal parallelism.

Function-level policies:
- `strict`: any evaluated arg error propagates.
- `mask_any`: trap any first-arg error (`IFERROR`).
- `mask_na`: trap only `#N/A` (`IFNA`).
- `branch_lazy`: evaluate selector, then selected branch only (`IF`, `CHOOSE`, `IFS`, `SWITCH`) with edge cases unresolved (`U-04`).
- `eager_logical`: `AND`/`OR` eagerness vs short-circuit unresolved (`U-03`).
- `aggregate_policy`: e.g., `AGGREGATE` options can ignore selected error classes.

Array/spill/external:
- Elementwise evaluation keeps per-element errors.
- Spill obstruction returns anchor `#SPILL!`.
- External async may surface transitional errors (`#GETTING_DATA`, `#CONNECT!`, `#BLOCKED!`) with lifecycle unresolved (`U-10`).

---

**(3) Function semantics classification (orthogonal tags)**

Per-function metadata:
```text
FunctionMeta = {
  strictness,
  volatility,
  host_context_deps,
  externality,
  ref_sensitivity,
  coercion_profile
}
```

Classes:
- `pure`: depends only on explicit inputs; recalc on dependency change.
- `volatile_epoch`: recalcs every calc cycle (`NOW`, `TODAY`, `RAND`, `RANDBETWEEN`).
- `host_context`: depends on locale/timezone/workbook/UI metadata (`TEXT`, `CELL`, `INFO`).
- `external`: depends on connectors/network/services (`RTD`, web/stock/data-linked functions).
- `structural_reference_sensitive`: output/dependency footprint changes with structural edits (`OFFSET`, `INDIRECT`, structured refs, shape-sensitive functions).

Volatility edge classifications (`OFFSET/INDIRECT` granularity, “volatile-once”) remain unresolved (`U-07`).

---

**(4) Formalized value-to-display formatting semantics and CF interaction**

Display boundary:

```text
raw_value      = Eval(cell.formula, env)
cf_style_delta = EvalCF(cell, raw_value, sheet_state)
effective_style= Merge(base_style, cf_style_delta, priority, stop_if_true)
display_text   = Render(raw_value, effective_style.number_format, locale, date_system, width)
```

Normative rules:
- Formatting never mutates `raw_value`.
- Dates/times remain numeric serials; formatting controls representation only.
- Display rounding is representational only.
- Error values render as error tokens; numeric formatting does not “fix” them.
- Width overflow may render hashes (`###`) without value mutation.

CF interaction points:
- CF evaluates after primary value computation.
- CF formula rules use same coercion/error semantics, anchored to rule range origin.
- Rule order + `Stop If True` determine style resolution.
- CF may override number format (changes display only).
- Data bars/color scales/icon sets use raw numeric domain; blanks/errors behavior unresolved (`U-08`).

---

**(5) Unresolved questions with concrete evidence requirements**

| ID | Open Question | Required Evidence |
|---|---|---|
| U-01 | Cross-type comparison semantics for `=, <, >, <=, >=` | Workbook matrix covering Number/Text/Bool/Blank pairings, captured outputs across target Excel builds/locales |
| U-02 | Text-to-bool coercion (`"TRUE"/"FALSE"` and localized variants) | Logical-context test grid (`IF`, `NOT`, direct boolean ops) in multilingual installs |
| U-03 | `AND`/`OR` eager vs short-circuit (scalar + array) | Cases like `AND(FALSE,1/0)` and dynamic-array variants with traceable evaluation |
| U-04 | Branch laziness guarantees for `IF/IFS/SWITCH/CHOOSE` under volatile/array args | Tests with untaken branches containing errors, volatile calls, and spill-producing expressions |
| U-05 | Scalarization/implicit intersection in modern array mode (`@`, legacy imports) | Paired legacy vs dynamic-array workbooks with expected-result diffs |
| U-06 | Multi-error precedence in range scans/array evaluation | Controlled placement of mixed errors in ranges; verify deterministic winner rule |
| U-07 | Canonical volatile set and trigger granularity (including `OFFSET/INDIRECT`, volatile-once) | Recalc tracing with unchanged dependencies across full/partial/manual recalc modes |
| U-08 | CF precedence, `Stop If True`, and number-format overrides including blanks/errors | Multi-rule conflict workbook with explicit expected effective styles and rendered text |
| U-09 | Locale-sensitive numeric parsing during coercion | Same formulas executed under different decimal/group/list separators with expected outcomes |
| U-10 | Async external error lifecycle and downstream propagation (`GETTING_DATA/CONNECT/BLOCKED`) | Online/offline transition tests with dependent formulas and timestamped state transitions |
| U-11 | Spill dominance vs internal calc errors (`#SPILL!` vs `#DIV/0!`, `#CALC!` precedence) | Dynamic-array obstruction and internal-error combinations with anchor/dependent cell assertions |
| U-12 | Aggregator coercion split (literal vs referenced text/boolean; unary plus behavior) | Matrix for `SUM("1",2)`, `SUM(A1,2)` where `A1="1"`, booleans, and `+` coercion probes |

2. **Conflict Resolution Notes**

- Chosen model uses Codex’s `ErrorToken(origin_index, phase)` and deterministic `join_error`, because it resolves parallel-evaluation determinism better than plain “leftmost” wording.
- Claude’s explicit type-rank comparison claim is treated as provisional, not final, because other outputs and unresolved tags indicate insufficient locked evidence.
- Function semantics are unified as orthogonal metadata tags (Codex strength) rather than a single mutually exclusive class list.
- Claude’s “volatile-once” category is retained only as a hypothesis (`U-07`), not as baseline semantics.
- Array/spill and async error behavior were kept in scope (Codex/Gemini) since they materially affect semantics core and error propagation.
- Formatting boundary and CF ordering are harmonized from all three outputs, with explicit “display-only” non-mutation rule.

3. **Residual Uncertainties**

- High risk: `U-01`, `U-03`, `U-04`, `U-05`, `U-11` (core correctness and compatibility impact).
- Medium risk: `U-06`, `U-07`, `U-08`, `U-09`, `U-10`, `U-12` (determinism, locale parity, external-state fidelity).
- Main blocker pattern: behavior varies by Excel version/channel/locale and is under-specified in text-only sources.

4. **Immediate Next Actions**

1. Build a conformance workbook pack for `U-01..U-12` with machine-checkable expected outputs and version/locale metadata.
2. Add a machine-readable `FunctionMeta` registry and enforce completeness in CI for strictness/volatility/context/externality/reference/coercion tags.
3. Implement `origin_index` error tokens and `join_error` in evaluator core before further optimization work.
4. Split coercion into explicit modules (`NumCtx`, `BoolCtx`, `TextCtx`) and add locale-matrix tests.
5. Add render-pipeline tests separating `raw_value`, `effective_style`, and `display_text`, including CF priority/`Stop If True`.
6. Promote only locked rules into `CORE_ENGINE_FORMAL_MODEL.md`; keep unresolved items as explicit `UNRESOLVED(U-xx)` gates until evidence closes.