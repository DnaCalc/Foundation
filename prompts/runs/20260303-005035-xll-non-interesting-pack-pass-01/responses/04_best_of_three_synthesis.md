# XLL Non-Interesting Functions — Best-of-Three Consolidated Spec

Run: `20260303-005035-xll-non-interesting-pack-pass-01`
Source blend: `01_codex.md` + `02_claude.md` + `03_gemini.md`
Status: Draft synthesis for promotion review

Legend:
- `E-SPEC`: backed by reference/spec docs already indexed in repo.
- `E-EMP`: backed by empirical finding or probe evidence.
- `U`: unresolved/assumption; must be tested or sourced before lock.

## 1. Scope Freeze And Inventory Rule

### 1.1 Non-Interesting Admission Gates
A function is in-scope for this pack only if all gates pass:

| Gate | Rule |
|---|---|
| G1 Deterministic | Same inputs and context give same output. |
| G2 No side effects | No workbook mutation, no format mutation, no calculation-mode mutation. |
| G3 Sync-only | No async/streaming lifecycle (for example RTD-like patterns excluded). |
| G4 No external dependency | No network/file/process/host callback dependency for value result. |
| G5 Coercion describable | Argument coercion and error-exit behavior can be defined contractually. |
| G6 Host interaction bounded | Any host interaction is limited to reference/caller resolution that is explicitly modeled. |

### 1.2 Inventory Freeze Procedure
1. Start from full catalog in `function_catalog_full.csv` and current classification CSV.
2. Apply G1-G6 per function and record pass/fail reason.
3. Freeze an inventory revision ID (`NI-INV-vN`) with:
   - in-scope set,
   - exclusions with failing gate,
   - deferred set (insufficient evidence).
4. No additions to `NI-INV-vN` without a new revision and semantic delta note.

### 1.3 Family Partition (for template reuse)
| Family | Typical core shape |
|---|---|
| Math/Trig | `double -> double`, `double*double -> double` |
| Aggregate | `seq<T> -> T` with range flattening policy |
| Text | `string/... -> string` |
| Logical | `bool/... -> bool or value` |
| Info/Type | `value -> tag/int/bool` |
| Reference-sensitive deterministic | `ref? + caller? -> scalar/array` |

### 1.4 Scope Assumptions To Lock
- `U-SCOPE-01`: borderline functions with structural behavior (`INDEX` reference form, some lookup/reference duals) may require split treatment.
- `U-SCOPE-02`: dynamic-array-era behavior changes may alter historical coercion assumptions.

## 2. Semantic Contract Schema (Per Function)

Each function row must be machine-readable and evidence-tagged.

```yaml
FunctionContract:
  FunctionId: string           # stable id, e.g. F-SIN
  ExcelName: string
  InventoryRevision: string    # e.g. NI-INV-v1
  Family: enum
  Arity:
    min: int
    max: int | "var"
  Inputs:
    - index: int
      name: string
      accepted_kinds: [scalar, array, reference, missing, error]
      coercion_profile: enum   # e.g. NUMERIC_STANDARD, TEXT_STANDARD
      default_policy: enum     # ERROR | DEFAULT(value) | OMIT
      evidence: [E-SPEC|E-EMP|U]
  ErrorPolicy:
    propagation_mode: enum     # PROPAGATE_FIRST | FUNCTION_SPECIFIC
    domain_error_map: enum     # #NUM!/#VALUE!/etc
    precedence_rule: string
    evidence: [E-SPEC|E-EMP|U]
  ReturnPolicy:
    core_type: string
    excel_kind: enum           # scalar/array/error/reference-like
    post_call_adaptation: enum # e.g. scalar box, array spill-anchor adaptation
    evidence: [E-SPEC|E-EMP|U]
  HostInteractionClass:
    class: enum                # NONE | REF_DEREF | CALLER_CONTEXT | OTHER
    notes: string
    evidence: [E-SPEC|E-EMP|U]
  DeterminismClass:
    class: enum                # PURE | CONTEXT_DETERMINISTIC
  Formal:
    preconditions: [string]
    postconditions: [string]
    invariants: [string]
  Trace:
    req_ids: [string]
    test_ids: [string]
    evidence_ids: [string]
```

Decision: keep coercion/error policy as reusable named profiles, not duplicated prose per function.

## 3. XLL Registration/Type Mapping Plan (`xlfRegister`, `pxTypeText`, caller context)

### 3.1 Registration Model
- Register worksheet functions through `xlfRegister` with manifest output per function (`EV-REG-*`).
- Keep a symbolic type layer first, then resolve to concrete `pxTypeText` strings.

| Symbolic token | Intent |
|---|---|
| `ARG_XVAL` | Generic worksheet argument boundary value |
| `ARG_REF` | Reference-preserving input path |
| `RET_XVAL` | Generic return value/error boundary |
| `ARG_CTX` | Caller context dependency |

### 3.2 Type-Text Strategy
Default policy for parity work:
1. Prefer generic boundary types (`Q`/`U` style) where coercion must stay under adapter control.
2. Allow direct primitive registrations (`B`, `J`, `L`, etc.) only when parity evidence proves no semantic loss.
3. Preserve and test variants where reference visibility may change behavior.

`U-REG-01`: exact final `pxTypeText` per family remains evidence-gated.

### 3.3 Caller Context Rules
| Rule | Contract |
|---|---|
| Context required functions | Must declare `HostInteractionClass=CALLER_CONTEXT`. |
| Context retrieval | Adapter fetches once and passes typed metadata to core or resolves before core call. |
| Failure behavior | Return contract-defined error if required context unavailable. |

### 3.4 Thread/Memory Constraints
- Thread-safe flags are opt-in per function class after evidence, not assumed globally (`U-REG-02`).
- If heap-backed return objects are used, ownership/free contract must be explicit and test-covered.

## 4. Two-Layer Implementation Template (Adapter vs Typed Core)

### 4.1 Layer Responsibilities
| Layer | Responsibilities |
|---|---|
| Layer A Adapter | Arity checks, coercion, error precedence, reference/caller normalization, marshaling. |
| Layer B Typed Core | Pure typed computation over normalized inputs; no Excel container semantics. |

### 4.2 Refinement Contract
Layer A guarantees to Layer B:
1. Inputs satisfy declared typed-domain preconditions.
2. Any boundary errors/coercion failures are handled before core call.
3. Host/context metadata is explicit, not implicit global state.

Layer B guarantees to Layer A:
1. Output matches postconditions for valid input domain.
2. Error enum surface is restricted to declared core error set.

### 4.3 Template (language-independent)
```text
AdapterInvoke(spec, rawArgs):
  validate_arity(spec, rawArgs) or return #VALUE!
  ctx = spec.needs_ctx ? get_caller_context() : None
  norm = normalize_and_coerce(spec, rawArgs, ctx)
  if norm.is_error: return encode_excel_error(norm.error)
  core = CoreInvoke(spec.core_sig, norm.typed_args)
  return marshal(core, spec.return_policy)
```

## 5. Formal Contract Candidates (with examples: SIN, one aggregate, one reference-sensitive function)

### 5.1 `SIN` (pure numeric)
- Signature: `sin_core(x: double) -> double`
- Preconditions:
  - input argument coercible under `NUMERIC_STANDARD`.
  - finite-domain policy as declared.
- Postconditions:
  - result numeric or mapped error.
  - if successful, bounded trigonometric range invariant applies.
- Invariants:
  - odd symmetry (within tolerance profile).
- Key unresolved:
  - `U-SIN-01`: large-magnitude precision/error boundary behavior parity.

### 5.2 `SUM` (aggregate/coercion-heavy)
- Signature: `sum_core(xs: seq<double>) -> double`
- Preconditions:
  - adapter flattens references/arrays per traversal rule.
  - inclusion policy (text/bool/blank direct-vs-referenced) explicitly selected.
- Postconditions:
  - numeric sum or mapped overflow/domain error.
- Invariants:
  - identity on empty numeric sequence.
  - deterministic traversal order.
- Key unresolved:
  - `U-SUM-01`: direct scalar text/bool vs referenced text/bool treatment.
  - `U-SUM-02`: multi-error precedence order in mixed ranges.

### 5.3 `ROW` (reference/caller-sensitive deterministic)
- Signature: `row_core(ref_opt, caller_ctx_opt) -> int|array`
- Preconditions:
  - either valid reference input or caller context available when arg omitted.
- Postconditions:
  - 1-based row index result following scalar/array mode contract.
- Invariants:
  - no side effects; output determined by input reference/caller position.
- Key unresolved:
  - `U-ROW-01`: dynamic array / implicit intersection interaction policy.

## 6. Differential Validation Matrix (native Excel vs add-in)

### 6.1 Required Dimensions
| Dimension | Coverage |
|---|---|
| D-TYPE | num, text, bool, blank, missing, error, array, ref |
| D-COERCE | literal vs referenced coercion differences |
| D-ERR | single and mixed error precedence |
| D-CTX | caller-position/context-sensitive behavior |
| D-LOCALE | decimal/list separator profile variants |
| D-VERSION | workbook compatibility/version mode where relevant |

### 6.2 Test Record Shape
| Field |
|---|
| `test_id`, `function_id`, `input_descriptor`, `native_result`, `xll_result`, `compare_rule`, `pass_fail`, `excel_build`, `excel_hash`, `evidence_id` |

### 6.3 Initial Matrix (minimum)
| Test ID | Function | Focus |
|---|---|---|
| TC-SIN-001..003 | SIN | numeric baseline + coercion + large magnitude |
| TC-SUM-001..006 | SUM | direct vs referenced coercion, mixed errors, traversal |
| TC-ROW-001..004 | ROW | omitted arg context, ref arg, scalar/array mode |

Pass criterion: exact type+error parity, numeric parity under declared tolerance class.

## 7. Parity-Hypothesis Challenge List (possible counterexamples)

Hypothesis: every non-interesting function is fully implementable with parity through this XLL adapter/core split.

| ID | Counterexample Risk | Why it matters |
|---|---|---|
| H-01 | Numeric library divergence | Core math may drift from Excel edge behavior. |
| H-02 | Locale coercion drift | Text-to-number conversion may not match host parsing rules. |
| H-03 | Aggregate inclusion mismatch | Direct args vs range elements often differ semantically. |
| H-04 | Error precedence mismatch | Multi-error ranges may expose hidden traversal precedence. |
| H-05 | Reference visibility mismatch | Registration path can change whether function sees ref vs value. |
| H-06 | Caller-context mismatch | Omitted-arg semantics can differ in array/spill contexts. |
| H-07 | Date-system compatibility edges | Date serial conventions can break “pure” assumptions. |
| H-08 | Thread-safety overclaim | Some functions may be deterministic but not safely threaded due to adapter internals. |

Each hypothesis needs dedicated empirical probe IDs and closure criteria.

## 8. Promotion Pack (decisions, unresolved items, doc updates, empirical plan)

### 8.1 Accepted Decisions
| ID | Decision |
|---|---|
| D-01 | Use two-layer architecture with strict adapter/core separation. |
| D-02 | Use policy profiles for coercion/error rules; avoid per-function prose duplication. |
| D-03 | Enforce `REQ -> CONTRACT -> TEST -> EVIDENCE` traceability chain. |
| D-04 | Freeze inventory revisions and require explicit deltas for scope changes. |

### 8.2 Unresolved Decisions
| ID | Topic | Needed to close |
|---|---|---|
| U-REG-01 | Final per-family `pxTypeText` map | registration A/B probes + spec cross-check |
| U-REG-02 | Thread-safe flag policy by family | concurrency probe and adapter audit |
| U-SUM-01 | Direct-vs-referenced coercion matrix | targeted empirical matrix |
| U-ROW-01 | implicit intersection / spill mode | context probes and version notes |
| U-TOL-01 | tolerance classes for transcendentals | calibrated oracle comparison |

### 8.3 Required Doc Updates
1. Add this synthesis as baseline to run outputs (`responses/04_best_of_three_synthesis.md`).
2. Derive structured artifacts in run outputs:
   - `outputs/non_interesting_inventory.csv`
   - `outputs/non_interesting_semantic_contracts.csv`
   - `outputs/xll_registration_type_mapping.csv`
   - `outputs/differential_test_matrix.csv`
3. Feed accepted decisions into:
   - `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
   - `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`

### 8.4 Empirical Plan (next)
1. Lock baseline environment metadata (Excel version/build/hash/locale).
2. Run registration-path probes to settle `pxTypeText` and reference visibility.
3. Run coercion/error matrices for `SIN`, `SUM`, `ROW` as calibration trio.
4. Promote policy classes only when evidence IDs exist for each class rule.

### 8.5 Readiness Statement
This synthesis is implementation-oriented but still evidence-gated. It is ready to drive artifact generation and targeted probes; it is not yet a final parity claim.
