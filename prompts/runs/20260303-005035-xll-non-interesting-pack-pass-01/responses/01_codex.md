Run: `20260303-005035-xll-non-interesting-pack-pass-01`

## 1. Scope Freeze And Inventory Rule
| Item | Rule |
|---|---|
| Scope target | Language-independent `.xll` parity implementation for **non-interesting** worksheet functions only. |
| Non-interesting definition | Deterministic, synchronous, no side effects, no external I/O, no workbook mutation, no macro-sheet behavior requirements. |
| Clean-room discipline | Only black-box behavioral observation of Excel outputs is allowed; no reuse of Microsoft source/internal artifacts. |
| Freeze boundary | Function set, coercion rules, error-exit precedence, and array/reference behavior are frozen for this run. |
| Change control | Any change to frozen behavior requires new run id and explicit semantic delta record. |
| Traceability | Every function must map `REQ -> CONTRACT -> TEST -> EVIDENCE` IDs. |
| Assumption A-0 | This spec is drafted from prompt text only; repository docs were not consulted in this run. |

**Initial frozen inventory (pilot):**

| Func ID | Excel Name | Class | Arity | Ref-sensitive | Volatile | Status |
|---|---|---|---|---|---|---|
| F-SIN | `SIN` | scalar math | 1 | no | no | in scope |
| F-SUM | `SUM` | aggregate | 1..N | yes (via refs) | no | in scope |
| F-ROW | `ROW` | reference-sensitive | 0..1 | yes | no | in scope |

## 2. Semantic Contract Schema (Per Function)
| Field | Description |
|---|---|
| `FunctionId` | Stable ID (`F-SIN`, etc.) |
| `ExcelName` | Canonical worksheet name |
| `VersionAnchor` | Excel build/channel used as oracle baseline |
| `NormalizedSignature` | Typed kernel signature (language-independent) |
| `AdapterArityRule` | Allowed argument count and optionality |
| `CoercionProfile` | Declarative coercion per argument kind |
| `ArrayRule` | Flattening/shape behavior |
| `ReferenceRule` | Ref resolution, intersection/spill handling |
| `ErrorExitPrecedence` | Which error wins when multiple errors present |
| `DeterminismClass` | Pure/contextual deterministic/volatile |
| `NumericToleranceClass` | Exact / integer exact / ULP-bounded |
| `Contracts` | Preconditions, postconditions, invariants |
| `Assumptions` | Unresolved semantics requiring empirical lock |
| `TraceLinks` | `REQ-*`, `CT-*`, `TC-*`, `EV-*` |

## 3. XLL Registration/Type Mapping Plan (`xlfRegister`, `pxTypeText`, caller context)
**Registration plan**
| Step | Action |
|---|---|
| 1 | Define adapter entrypoints (Layer A) per frozen function. |
| 2 | Build `pxTypeText` from symbolic type tokens, not hardcoded literals. |
| 3 | Bind symbolic tokens to authoritative Excel SDK mapping table for target API generation. |
| 4 | Call `xlfRegister` with function name, arg text, category, help, and flags (threading/cluster-safe as applicable). |
| 5 | Persist registration manifest as evidence artifact (`EV-REG-*`). |

**Symbolic type mapping (language-independent contract view)**
| Symbolic token | Boundary meaning | Core mapping |
|---|---|---|
| `RET_XVAL` | Return Excel value union | Encoded from typed result or Excel error |
| `ARG_XVAL` | Accept general Excel arg | Coerced by profile |
| `ARG_REF` | Accept reference argument | Resolved to typed ref metadata |
| `ARG_CTX` | Caller context (implicit, not user arg) | `CallerContext` struct |
| `FLAG_THREADSAFE` | Registration capability flag | Allowed only if contract permits caller API usage |

**Caller context plan**
| Rule | Behavior |
|---|---|
| Context needed | Only for contracts marked `context_required` (example: `ROW()` no arg). |
| Retrieval | Adapter obtains caller metadata once per invocation. |
| Failure path | If required context unavailable, return contract-defined error (`#VALUE!` candidate). |
| Traceability | Log context mode in evidence for ref-sensitive tests (`EV-CTX-*`). |

**Unresolved assumption U-REG-1:** Exact `pxTypeText` byte sequence depends on chosen Excel C API generation and must be locked from SDK docs before coding.

## 4. Two-Layer Implementation Template (Adapter vs Typed Core)
**Layer A (Declarative Adapter) responsibilities**
| Responsibility | Notes |
|---|---|
| Arity validation | Enforce function-specific arg count rules. |
| Coercion | Apply declarative coercion profiles only. |
| Error exit | Apply frozen precedence and early exits. |
| Reference/caller handling | Resolve refs and caller metadata into typed forms. |
| Marshaling | Convert typed core result back to Excel boundary value. |

**Layer B (Typed Core Kernel) responsibilities**
| Responsibility | Notes |
|---|---|
| Pure computation | No Excel API types or calls. |
| Strong typing | Example: `SIN: double -> double`. |
| Determinism | Stable outputs for same typed inputs. |
| No policy drift | No coercion/error precedence logic inside core. |

**Language-independent template**
```text
AdapterInvoke(spec, rawArgs):
  assert arity(rawArgs, spec.arityRule) else return ErrValue
  ctx <- spec.needsCaller ? getCallerContext() : None
  typedArgs <- coerceAll(rawArgs, spec.coercionProfile, spec.errorExitPrecedence)
  if typedArgs is Error: return encodeError(typedArgs.error)
  coreOut <- CoreInvoke(spec.coreId, typedArgs, ctx)
  return marshal(coreOut)

Core SIN(x: f64) -> f64
Core SUM(xs: seq<f64>) -> f64
Core ROW(refOpt: RefMeta?, ctxOpt: CallerContext?) -> i32
```

## 5. Formal Contract Candidates (with examples: SIN, one aggregate, one reference-sensitive function)
| Function | Preconditions | Postconditions | Invariants | Example cases |
|---|---|---|---|---|
| `SIN` (`CT-SIN-v1`) | Exactly 1 argument; argument coercible under `NumericScalar` profile. | Success: numeric `y`; `y ≈ sin(x)` within tolerance class `T-TRIG-ULP`; finite `x` implies `-1 <= y <= 1`. Failure: contract-defined Excel error. | Core is pure; adapter-only coercion/error behavior. | `SIN(0)=0`; `SIN(PI()/2)=1` (within tolerance). |
| `SUM` (`CT-SUM-v1`) | Arity within declared max; each arg may be scalar/array/ref. | Success: sum of included numeric terms under frozen inclusion policy; identity candidate `SUM(empty)=0` (if callable). Error precedence follows traversal rule. | Flattening order deterministic; core receives normalized numeric sequence only. | `SUM(1,2,3)=6`; range cases validated vs oracle. |
| `ROW` (`CT-ROW-v1`) | 0 or 1 arg; if 0 arg, caller context must be available. | With arg ref: returns 1-based row derived from ref rule. Without arg: returns caller row. | No workbook mutation; result depends only on ref/caller metadata. | In cell `D7`, `ROW()` => `7`; `ROW(B8:D10)` scalar-context candidate => `8`. |

**Open assumptions requiring lock:**
| ID | Assumption |
|---|---|
| U-SUM-1 | Treatment of text/booleans differs by literal-arg vs referenced-cell position. |
| U-SUM-2 | Multi-error precedence in aggregates must be empirically fixed. |
| U-ROW-1 | Dynamic-array/spill behavior for `ROW(reference)` needs explicit baseline decision. |
| U-SIN-1 | Transcendental tolerance threshold (ULP bound) must be calibrated on target build. |

## 6. Differential Validation Matrix (native Excel vs add-in)
| Test ID | Function | Input/Context | Native Oracle Capture | Comparator | Pass Criterion |
|---|---|---|---|---|---|
| `TC-SIN-001` | `SIN` | `SIN(0)` | Evaluate in baseline workbook | numeric exact | exact `0` |
| `TC-SIN-002` | `SIN` | `SIN(PI()/2)` | same | numeric tolerance | within `T-TRIG-ULP` |
| `TC-SIN-003` | `SIN` | text-coercion probe | same | type+value/error | exact parity |
| `TC-SUM-001` | `SUM` | literals only | same | numeric exact | exact parity |
| `TC-SUM-002` | `SUM` | range with text/blank/bool | same | type+value | exact parity |
| `TC-SUM-003` | `SUM` | mixed errors in inputs | same | error code+precedence | exact parity |
| `TC-ROW-001` | `ROW` | `ROW()` in known cell | same | integer exact | exact parity |
| `TC-ROW-002` | `ROW` | `ROW(reference)` scalar mode | same | integer/array shape | exact parity |
| `TC-ROW-003` | `ROW` | spill-enabled context | same | shape+elements | exact parity or flagged unresolved |

**Evidence artifacts per test:** input workbook hash, observed result tuple (type/value/error/shape), build metadata, and comparator output.

## 7. Parity-Hypothesis Challenge List (possible counterexamples)
| Hypothesis ID | Parity risk | Counterexample probe |
|---|---|---|
| `H-01` | Transcendental library mismatch vs Excel internals | high-magnitude `SIN` inputs and edge IEEE values |
| `H-02` | Locale coercion drift | decimal comma vs decimal point text inputs |
| `H-03` | Aggregate inclusion mismatch | `SUM` with booleans/text as literals and in ranges |
| `H-04` | Empty vs empty-string confusion | ranges containing truly blank and `""` formulas |
| `H-05` | Error precedence mismatch | mixed `#N/A`, `#VALUE!`, `#NUM!` in aggregates |
| `H-06` | Caller context mismatch | `ROW()` in normal cell, array formula, spill anchor |
| `H-07` | Multi-area ref traversal order drift | `SUM((A1:A2,C1:C2))`-style probes |
| `H-08` | Registration type text mismatch | same function registered with alternate `pxTypeText` forms |
| `H-09` | Threading flag behavioral differences | recalc under single vs multithread mode |
| `H-10` | Excel version drift | rerun matrix on pinned and newer build channels |

## 8. Promotion Pack (decisions, unresolved items, doc updates, empirical plan)
**Decisions**
| Decision ID | Decision |
|---|---|
| `D-01` | Freeze pilot scope to `SIN`, `SUM`, `ROW`. |
| `D-02` | Enforce strict two-layer separation: adapter policy vs typed kernel math. |
| `D-03` | Use symbolic registration/type mapping with SDK-bound resolution step. |
| `D-04` | Require `REQ -> CT -> TC -> EV` trace links for promotion. |

**Unresolved items**
| ID | Item | Needed to close |
|---|---|---|
| `U-REG-1` | Final `pxTypeText` encoding | SDK-verified mapping table |
| `U-SUM-1` | Text/bool coercion semantics in aggregates | targeted oracle tests |
| `U-ROW-1` | Spill/implicit-intersection mode for `ROW` | explicit baseline policy |
| `U-SIN-1` | Numeric tolerance bound for trig | calibration run on target build |

**Doc updates (planned artifacts)**
| Artifact | Purpose |
|---|---|
| `spec/non-interesting-scope.md` | frozen inventory + admission/exclusion rules |
| `spec/contracts/{SIN,SUM,ROW}.md` | formal per-function contracts |
| `spec/xll-registration-mapping.md` | `xlfRegister` + symbolic `pxTypeText` plan |
| `validation/diff-matrix.csv` | executable parity test matrix |
| `validation/evidence/` | hashed oracle vs add-in result bundles |

**Empirical plan**
1. Pin Excel oracle environment (build/channel/locale) and record baseline metadata.
2. Finalize SDK-backed type mapping and registration manifest.
3. Implement Layer A and Layer B for pilot set using contract IDs.
4. Execute differential matrix, collect evidence bundles, classify mismatches by hypothesis.
5. Promote only if all non-waived tests pass and unresolved items are either closed or explicitly deferred with risk acceptance.
