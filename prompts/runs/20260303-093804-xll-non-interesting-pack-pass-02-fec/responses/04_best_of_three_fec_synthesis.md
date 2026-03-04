# XLL Non-Interesting Functions + FEC — Best-of-Three Consolidated Spec

Run: `20260303-093804-xll-non-interesting-pack-pass-02-fec`
Source blend: `01_codex.md` + `02_claude.md` + `03_gemini.md`
Status: Draft synthesis for promotion review

Legend:
- `E-SPEC`: anchored in curated public specs/docs.
- `E-EMP`: anchored in promoted empirical findings.
- `U`: unresolved assumption (must be closed before policy lock).

## 1. Scope Freeze And Inventory Rule

### 1.1 Admission rule
A function is in the non-interesting implementation set only if:
1. It does not require volatile/non-deterministic/external lifecycle behavior.
2. It can be modeled with deterministic adapter/core contracts.
3. Its required FEC profile is `none` or `ref_only` (unless explicitly carved out as calibration exceptions like `ROW`).

### 1.2 Freeze and traceability
- Freeze inventory as `NI-INV-v1-FEC` for this pass.
- Every row must map `REQ -> CONTRACT -> TEST -> EVIDENCE`.
- Scope changes require new run id and explicit delta record.

## 2. Semantic Contract Schema (Per Function)
Each function row should carry these required fields:

| Field | Meaning |
|---|---|
| `function_id`, `excel_name` | Canonical identity |
| `arity_min`, `arity_max` | Invocation boundary |
| `arg_contracts` | Input kinds and coercion profiles |
| `reference_normalization` | Flattening/intersection/spill-normalization policy |
| `error_precedence` | Deterministic error exit ordering |
| `result_contract` | Scalar/array/error return shape |
| `determinism_class` | `pure` or context-deterministic |
| `fec_dependency_profile`, `fec_facility_tags` | Declared FEC dependencies |
| `preconditions`, `postconditions`, `invariants` | Formal contract basis |
| `test_ids`, `evidence_ids` | Differential proof chain |

## 3. FEC Contract Overlay (profiles, capability tags, enforcement)

### 3.1 Capability families
- `cap_reference_resolution`
- `cap_caller_context`
- `cap_time_provider`
- `cap_random_provider`
- `cap_external_provider`
- `cap_locale_parse_format`
- `cap_feature_gate`
- `cap_error_detail_enrichment`

### 3.2 Profile vocabulary
- `none`
- `ref_only`
- `caller_context`
- `time_provider`
- `random_provider`
- `external_provider`
- `locale_profile`
- `composite`

### 3.3 Enforcement rule
A function MUST NOT observe undeclared FEC facilities.

Enforcement layers:
1. Manifest lint at declaration time.
2. Adapter-scoped FEC view at runtime.
3. Negative conformance probes for forbidden facility access.

## 4. XLL Registration/Type Mapping Plan (`xlfRegister`, `pxTypeText`, caller context)

1. Use a registration manifest as source of truth; generate registration calls from it.
2. Keep `pxTypeText` mapping explicit and versioned.
3. Restrict caller-context access (`xlfCaller`) to profiles that declare it.
4. Treat threading flags as evidence-gated per function/profile.

Required registration metadata:
- `dll_export_name`
- `excel_name`
- `pxTypeText`
- `flags` (thread-safe/volatile/etc.)
- `caller_context_mode`
- `arg_help`/category metadata

## 5. Two-Layer Implementation Template (Adapter vs Typed Core)

| Layer | Responsibilities | Forbidden |
|---|---|---|
| Layer A Adapter | Arity checks, coercion, reference normalization, error precedence, FEC scoped-view construction, marshaling | Core business logic; undeclared FEC access |
| Layer B Typed Core | Pure typed computation over normalized args and explicit FEC inputs | Excel C API calls; implicit global context |

Template:
```text
invoke(fn, raw_args, host_fec):
  c = contract[fn]
  fec = restrict(host_fec, c.fec_dependency_profile, c.fec_facility_tags)
  norm = normalize(raw_args, c, fec)
  if norm.error: return map_error(norm.error, c)
  out = core(fn, norm.typed_args, materialize_fec_inputs(fec, c))
  return marshal(out, c)
```

## 6. Formal Contract Candidates (with examples: SIN, one aggregate, one reference-sensitive function)

| Function | FEC | Preconditions | Postconditions | Invariants |
|---|---|---|---|---|
| `SIN(x)` | `none` | one arg; numeric coercion succeeds or mapped error | numeric result or mapped error | deterministic, no FEC use |
| `SUM(args...)` | `ref_only` | args normalized from scalar/array/ref under policy | deterministic accumulation result or mapped error | traversal order fixed; no caller/time/random/external use |
| `ROW([ref])` | `caller_context`/`composite` | valid ref or available caller context | 1-based row output with explicit mode behavior | no undeclared FEC use |

Key unresolved:
- `U-SUM-01`: direct vs referenced text/bool inclusion.
- `U-SUM-02`: mixed-error precedence details.
- `U-ROW-01`: spill/implicit-intersection interaction boundaries.

## 7. Differential Validation Matrix (native Excel vs add-in)

Minimum axes:
- coercion (`D-COERCE`)
- reference normalization (`D-REF`)
- caller context (`D-CTX`)
- error precedence (`D-ERR`)
- locale (`D-LOCALE`)
- registration/marshaling (`D-REG`)
- FEC restriction enforcement (`D-FEC-GATE`)

Pass criteria:
1. exact type/error parity,
2. numeric parity under declared tolerance class,
3. explicit fail-closed behavior for undeclared FEC access.

## 8. Parity-Hypothesis Challenge List (possible counterexamples)

| ID | Risk |
|---|---|
| H-01 | libm edge divergence for trig at high magnitude |
| H-02 | `SUM` direct-vs-referenced coercion mismatch |
| H-03 | multi-area traversal/order differences |
| H-04 | caller-context availability differences across evaluation contexts |
| H-05 | locale parse/format drift |
| H-06 | undeclared FEC leakage via adapter/core glue |
| H-07 | `pxTypeText` ABI/version drift |

## 9. Promotion Pack (decisions, unresolved items, doc updates, empirical plan)

### Accepted
- FEC is now first-class in function contracts.
- `fec_dependency_profile` + `fec_facility_tags` are required row fields.
- Two-layer adapter/core split remains mandatory.

### Unresolved
- Final `pxTypeText` mapping by target ABI/build.
- Final aggregate coercion/error precedence matrix.
- Caller-context thread-safety constraints.

### Required updates
1. Keep FEC columns in function conformance CSV authoritative.
2. Add FEC-linked requirement rows (`XLS-CF-FEC-*`) in core conformance artifacts.
3. Add trace links from function rows to FEC probes.

### Empirical next steps
1. Calibration trio: `SIN`, `SUM`, `ROW` with full FEC-aware matrix.
2. Add negative tests for undeclared FEC access.
3. Promote rows only when evidence closes all `U-*` assumptions for that row.
