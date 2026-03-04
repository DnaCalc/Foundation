## 1. Scope Freeze And Inventory Rule
- Freeze `nif_v1` as: prior best synthesis function set + this run’s FEC overlay only.
- No function enters/leaves `nif_v1` after freeze without a tracked change request.
- Clean-room rule: only black-box Excel behavior observations are admissible evidence.
- Traceability rule: every semantic claim must map `requirement -> contract -> adapter behavior -> kernel behavior -> differential test -> evidence artifact`.

| Field | Requirement |
|---|---|
| `function_id` | Stable unique id (`FN_*`) |
| `excel_name` | Registered Excel name |
| `signature_id` | Typed signature reference |
| `fec_dependency_profile` | One of approved profile values |
| `fec_facility_tags` | Optional tags, explicit only |
| `contract_id` | Preconditions/postconditions/invariants record |
| `reg_id` | `xlfRegister`/`pxTypeText` record |
| `test_pack_id` | Differential test corpus id |
| `evidence_id` | Native-vs-add-in result artifact |

## 2. Semantic Contract Schema (Per Function)
Use one contract record per function:

| Contract Field | Description |
|---|---|
| `function_id`, `excel_name` | Identity |
| `arity_min`, `arity_max` | Call shape |
| `arg_types` | Typed kernel argument model |
| `coercion_rules` | Scalar/reference/array coercion matrix |
| `reference_normalization` | Area flattening, implicit intersection/spill policy |
| `error_precedence` | Error exit ordering and propagation rules |
| `result_shape_rule` | Scalar/spill/array result semantics |
| `determinism_class` | Pure, deterministic-with-FEC, or externalized |
| `fec_dependency_profile`, `fec_facility_tags` | FEC declaration boundary |
| `preconditions`, `postconditions`, `invariants` | Formal contract clauses |
| `conformance_tests` | Required validation ids |
| `assumptions_open` | Unresolved semantic assumptions |

## 3. FEC Contract Overlay (profiles, capability tags, enforcement)
FEC is host-provided context external to pure function core.

### Approved capability families
- `cap_reference_resolution`
- `cap_caller_context`
- `cap_time_provider`
- `cap_random_provider`
- `cap_external_provider`
- `cap_locale_parse_format`
- `cap_feature_gate`
- `cap_error_detail_enrichment`

### Approved profile values
| `fec_dependency_profile` | Minimum allowed capability set |
|---|---|
| `none` | `{}` |
| `ref_only` | `{cap_reference_resolution}` |
| `caller_context` | `{cap_caller_context}` |
| `time_provider` | `{cap_time_provider}` |
| `random_provider` | `{cap_random_provider}` |
| `external_provider` | `{cap_external_provider}` |
| `locale_profile` | `{cap_locale_parse_format}` |
| `composite` | Explicit declared subset of families above |

### Enforcement
1. Declaration-time: manifest lint checks profile/capability consistency.
2. Adapter-time: function receives only a restricted FEC view for declared capabilities.
3. Runtime: access attempt outside declared capabilities fails closed and maps to contract violation handling.
4. Test-time: negative tests prove undeclared capability access is impossible.

**Normative rule:** A function MUST NOT observe, call, infer, or depend on undeclared FEC facilities.

## 4. XLL Registration/Type Mapping Plan (`xlfRegister`, `pxTypeText`, caller context)
- Keep a language-neutral registration manifest as source of truth.
- Generate `xlfRegister` calls from manifest only.
- Maintain a versioned `pxTypeText` mapping artifact per target ABI/version, validated empirically.
- Do not embed unverified token assumptions directly in kernels.

| Manifest Field | Purpose |
|---|---|
| `excel_name`, `dll_export_name` | Registration identity |
| `pxTypeText` | Return+argument type encoding |
| `arg_names`, `function_help`, `arg_help` | UX/help metadata |
| `category`, `visibility` | Excel function organization |
| `flags` | Thread-safe/cluster/macro semantics as applicable |
| `caller_context_mode` | Whether adapter may call `xlfCaller` |

Caller context rule:
- If profile includes `caller_context` (or `composite` containing it), adapter may resolve caller via `xlfCaller`.
- Otherwise, adapter must not query caller context.

## 5. Two-Layer Implementation Template (Adapter vs Typed Core)
| Layer | Responsibilities | Forbidden |
|---|---|---|
| Layer A: Declarative Adapter | `xlfRegister` binding, input coercion, reference normalization, error-exit precedence, FEC restricted-view acquisition, result marshaling | Business math/logic; undeclared FEC access |
| Layer B: Typed Core Kernel | Pure typed logic, deterministic computation over typed args + explicitly injected FEC primitives | Excel C API calls, raw host handles, implicit global context |

```text
invoke(fn_id, raw_args, host_fec):
  c = contract_catalog[fn_id]
  fec = host_fec.restrict(c.fec_dependency_profile, c.fec_facility_tags)
  normalized = adapter.normalize_and_coerce(raw_args, c, fec)
  if normalized.is_error: return adapter.error_exit(normalized.error, c)
  typed_fec_inputs = adapter.materialize_declared_fec_inputs(fec, c)
  core_out = kernel[fn_id](normalized.typed_args, typed_fec_inputs)
  return adapter.marshal(core_out, c)
```

## 6. Formal Contract Candidates (with examples: SIN, one aggregate, one reference-sensitive function)
| Function | FEC Profile | Preconditions | Postconditions | Invariants |
|---|---|---|---|---|
| `SIN(x)` | `none` | Arity = 1; `x` is coercible to numeric or already an error | If coercion fails: `#VALUE!` (candidate); else returns IEEE-754 double approximating `sin(x)` (radians) | Deterministic; no FEC access; scalar result |
| `SUM(args...)` (aggregate) | `ref_only` | Arity >= 1; args may be scalar/array/reference/error | Returns numeric accumulation over included numeric values after reference normalization; propagates non-maskable errors per precedence | Deterministic for fixed normalized traversal order; no caller/time/random/external FEC |
| `ROW([ref])` (reference-sensitive) | `composite` (`cap_reference_resolution` + `cap_caller_context`) | Arity 0..1; if omitted arg, caller context must be available | Returns 1-based row index of top-left cell of resolved reference/caller; invalid reference yields `#REF!` | Integer result >= 1; no undeclared FEC use |

Open assumptions to resolve empirically:
- Exact text/boolean/blank inclusion behavior in `SUM` across direct vs referenced arguments.
- Exact error precedence when mixed arrays/references/errors appear.

## 7. Differential Validation Matrix (native Excel vs add-in)
| Axis | Native Oracle | Add-in Check | Pass Criterion |
|---|---|---|---|
| Scalar coercion | Workbook formula corpus | Same formulas via XLL | Exact match (`value`/`error`) |
| Reference normalization | Multi-area/ref-edge corpus | Same inputs | Exact match (`value`/shape/error) |
| Caller context | `ROW()`/contextual formulas | Same workbook positions | Exact row/column parity |
| Aggregate semantics | `SUM` edge corpus | Same formulas | Exact/error parity; numeric tolerance where required |
| Floating-point trig | `SIN` stress set | Same inputs | Tight numeric tolerance (defined per function) |
| Error precedence | Mixed-error inputs | Same formulas | Exact error code parity |
| FEC gating | Negative undeclared-access tests | Inject forbidden access attempts | Must fail closed per contract |
| Registration/type mapping | Registration smoke workbook | `xlfRegister` + invocation | All registered functions callable with expected marshaling |

## 8. Parity-Hypothesis Challenge List (possible counterexamples)
| Hypothesis | Counterexample Risk | Check |
|---|---|---|
| `SIN` parity is trivial | Different libm edge behavior for huge magnitudes | High-magnitude sweep |
| `SUM` inclusion is stable | Text/logical handling differs by argument form | Direct vs reference matrix tests |
| Reference flatten order is obvious | Multi-area order differences | Multi-area deterministic corpus |
| Caller context is always available | Named formula/UDF invocation contexts differ | Context-mode matrix |
| Error precedence is linear | Array + reference mixed errors reorder precedence | Precedence stress corpus |
| Locale independence holds | Hidden parse/format path leaks locale | Locale-variant harness |
| No undeclared FEC leakage | Accidental clock/RNG/global reads in adapter/core | Capability-denial tests + static checks |
| Registration is portable | `pxTypeText` differences by Excel ABI/version | Versioned registration probe |

## 9. Promotion Pack (decisions, unresolved items, doc updates, empirical plan)
### Decisions
- Adopt FEC as first-class contract boundary for every function.
- Require explicit `fec_dependency_profile` and optional facility tags per function.
- Enforce strict two-layer architecture (adapter vs typed core).
- Gate promotion on differential parity evidence and traceability completeness.

### Unresolved Items
- Final `pxTypeText` token mapping per target Excel ABI/version.
- Finalized `SUM` text/boolean/blank semantics in all argument forms.
- Contract-violation runtime error mapping policy (developer-fail vs user-facing Excel error).

### Doc Updates
- Add `Function Contract Catalog` spec with schema in Section 2.
- Add `FEC Overlay` policy page with profiles/capabilities/enforcement.
- Add `XLL Registration Manifest` spec and generation rules.
- Add `Conformance Trace Index` linking contracts to evidence artifacts.

### Empirical Plan
1. Freeze `nif_v1` inventory and contract records.
2. Build native Excel oracle workbook corpus for covered functions.
3. Run add-in differential harness and collect evidence IDs.
4. Resolve open assumptions using corpus outcomes and update contracts.
5. Promote only functions with full parity pass and complete trace chain.
