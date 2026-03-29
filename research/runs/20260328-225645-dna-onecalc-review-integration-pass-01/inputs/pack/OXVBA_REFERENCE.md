# OxVba Reference

This document consolidates the current DNA OneCalc-relevant reference set from `OxVba`.

Repo role: VBA hosting, project/runtime modeling, host bridge concepts, platform profile constraints, and later add-in/XLL direction.

Included source documents:
- `OxVba/CHARTER.md`
- `OxVba/CURRENT_BLOCKERS.md`
- `OxVba/docs/evidence/language/MS_VBAL_MODULE_PROJECT_REQUIREMENTS.csv`
- `OxVba/docs/IN_PROGRESS_FEATURE_WORKLIST.md`
- `OxVba/docs/spec/BASPROJ_SPEC_V1.md`
- `OxVba/docs/spec/COM_CLIENT_SERVER_SCOPE_V1.md`
- `OxVba/docs/spec/HAL_RUNTIME_PROFILE_MATRIX_V1.md`
- `OxVba/docs/spec/HAL_SPEC_WORKING_DRAFT.md`
- `OxVba/docs/spec/HOSTING_PROJECT_TOOLING_PROPOSAL.md`
- `OxVba/docs/spec/PROJECT_MODULE_REFERENCE_SPEC_V1.md`
- `OxVba/docs/spec/README.md`
- `OxVba/docs/worksets/WORKSET_2026-03-08_EVENTS_RUNTIME_HOST_PROJECT_HAL_SPLIT.md`
- `OxVba/docs/worksets/WORKSET_2026-03-09_HOST_BRIDGE_OBJECT_VALUE_AND_EVENT_INGRESS_CONTRACT.md`
- `OxVba/docs/worksets/WORKSET_2026-03-23_XLL_ADDIN_SUPPORT_P8.md`
- `OxVba/MACH1000_PLAN.md`
- `OxVba/README.md`

The sources are reproduced below in full so the pack remains self-contained even after flattening.

## Source: `OxVba/CHARTER.md`

# CHARTER.md — OxVBA Charter

## 1. Mission
OxVBA is a full-fidelity VBA 7 runtime engine in Rust, designed for compatibility-first execution with rigorous correctness and high performance.

OxVBA is part of the DNA Calc universe and follows Foundation doctrine, while operating as its own project with its own planning and delivery cadence.

## 2. Values Ordering
When values conflict, higher-ranked values win.

1. Robustness
2. Compatibility
3. Performance
4. Runtime size
5. Development environment quality

## 3. Clean-room Rule (Non-negotiable)
OxVBA development uses only:
- public specifications/documentation,
- published research,
- reproducible black-box observation of Office/VBA behavior.

Excluded:
- proprietary/restricted sources,
- reverse engineering of internals,
- decompilation/disassembly of Office internals.

## 4. Scope
Initial focus:
- Full VBA language/runtime core and execution pipeline.
- COM-compatible object/runtime semantics on Windows.
- Host-aware runtime APIs (host can inject root objects such as `Application` at engine initialization).
- Forms runtime (Rust implementation).

In scope but not currently active:
- Runtime security model.
- Debugging protocol.
- IDE features.
- Forms Designer.
- Non-Windows COM library interop completeness.

Out of scope:
- Spreadsheet engine implementation (DNA Calc domain).
- VBA IDE implementation.
- Office application object model implementation (host-provided).

## 5. Document Model
Top-level guidance precedence for OxVBA:
1. `CHARTER.md`
2. `OPERATIONS.md`
3. `MACH1000_PLAN.md`

`MACH1000_PLAN.md` is the full architecture and phased implementation plan. This charter defines mission, values, and scope boundaries.

## 6. Relationship to MACH-1000 Plan
`MACH1000_PLAN.md` contains the detailed architecture, formal strategy, testing approach, and implementation sequencing. If details in the plan drift from this charter, this charter is authoritative and the plan must be updated.

## Source: `OxVba/CURRENT_BLOCKERS.md`

# Current Blockers

Date: 2026-03-11  
Run context: active parity/compliance execution plus in-progress feature worklist execution pass

## Status update

### BLK-EVT-001: Runtime subscription graph execution model
- Status: resolved in current run.
- Resolution summary:
  - Removed compile-time bounded owner fanout from `RaiseEvent` lowering.
  - Added runtime owner-iteration intrinsics:
    - `__oxvba_withevents_first_owner(source, binding)`
    - `__oxvba_withevents_next_owner()`
  - Wrapper lowering now iterates runtime owner bindings dynamically and dispatches handlers with sink-owner identity.
  - Added/updated compiler/optimizer/VM/host tests to lock deterministic behavior.

### BLK-RUNTIME-VALUE-MODEL-001: Runtime value-model migration
- Status: resolved in current run.
- Resolution summary:
  - VM/register/host execution is now value-first end to end:
    - register storage persists `RuntimeValue`,
    - public VM/JIT/host execution APIs are semantic-snapshot first,
    - `snapshot_slots(...)` survives only as an explicit compatibility projection.
  - The interpreter loop no longer executes through the old raw slot-helper vocabulary:
    - core compare/boolean/jump/increment lanes now read/write semantic runtime values,
    - the wider loop now uses explicit legacy-projection helpers over `RuntimeValue` where scalar compatibility is still intentional,
    - `CopySlot` now preserves full `RuntimeValue` shape instead of collapsing through the integer lane.
  - The owned runtime `Variant` bridge now honestly covers the current scalar/error subset:
    - `Empty`,
    - `Null`,
    - `ErrorCode`,
    - `I32`,
    - `Bool`.
  - The dynamic-object protocol blocker that followed this migration is now also resolved:
    - native project class methods, properties, and default-member dispatch all execute on the shared dynamic-object protocol.

### BLK-COM-BOUNDARY-001: Final oxvba-com extraction from HAL
- Status: resolved in current run.
- Resolution summary:
  - oxvba-com now exposes WindowsComBridge as the live Windows COM client facade.
  - standard.rs now delegates create-object activation, invoke execution, object description/release, event subscription/callback access, and typelib resolve/load/invalidate through that bridge.
  - native subscription transport teardown for object release now also executes inside oxvba-com, removing the last substantive COM lifecycle seam from HAL.
  - the remaining HAL COM code is limited to capability/policy gating, apartment/bootstrap hooks, deterministic projection fallback, and error mapping.
  - the IP-04 closure verification matrix is green:
    - cargo fmt --all,
    - cargo clippy -p oxvba-com -p oxvba-hal --all-targets -- -D warnings,
    - cargo test -p oxvba-com -p oxvba-hal -p oxvba-host --quiet,
    - ./scripts/check-governance.ps1,
    - ./scripts/meta-check.ps1 -Fast -NoArtifacts.

## Active blocker entries

### BLK-COM-IDISPATCH-001: Late-bound COM parity remains below VBA/Excel `IDispatch` behavior
- Impact:
  - Blocks `IP-03` Windows late-bound COM client parity.
  - Blocks full closure of `HAL-DYN-008` and parts of `IP-09` declare/marshaling parity.
- Current state (tabular evidence matrix):

  **Invoke transport:**

  | lane                          | status       | evidence                              |
  |-------------------------------|--------------|---------------------------------------|
  | named/omitted arg metadata    | proved-exec  | ComInvokeRequest carries per-arg name |
  | named-arg DISPPARAMS packing  | proved-exec  | method/property-get lanes             |
  | property-put/putref canonical | proved-exec  | indexed/named arg canonicalization     |
  | omitted-arg fault             | proved-exec  | deterministic required-arg faults      |

  **Scalar result conversion:**

  | VT code   | carrier        | status       |
  |-----------|----------------|--------------|
  | VT_EMPTY  | Empty          | proved-exec  |
  | VT_NULL   | Null           | proved-exec  |
  | VT_ERROR  | ErrorCode      | proved-exec  |
  | VT_BOOL   | Bool           | proved-exec  |
  | VT_I1..I4 | I32            | proved-exec  |
  | VT_I8     | I32 or I64     | proved-exec  |
  | VT_UI1..2 | I32            | proved-exec  |
  | VT_UI4    | I32 or I64     | proved-exec  |
  | VT_UI8    | I32 or I64     | proved-exec  |
  | VT_INT    | I32            | proved-exec  |
  | VT_UINT   | I32 or I64     | proved-exec  |
  | VT_R4     | F64(Single)    | proved-exec  |
  | VT_R8     | F64(Double)    | proved-exec  |
  | VT_DATE   | F64(Date)      | proved-exec  |
  | VT_CY     | Currency       | proved-exec  |
  | VT_DECIMAL| Decimal96      | proved-exec  |
  | VT_BSTR   | String         | proved-exec  |
  | VT_DISPATCH| ObjectHandle  | proved-exec  |
  | VT_UNKNOWN (IDispatch)| ObjectHandle | proved-exec |
  | VT_UNKNOWN (no IDispatch)| — | deterministic E_NOINTERFACE |
  | VT_BYREF  | —              | deterministic unsupported diagnostic |

  **SAFEARRAY result conversion:**

  | element VT    | rank | carrier              | status       |
  |---------------|------|----------------------|--------------|
  | 17 typed VTs  | 1    | matching scalar      | proved-exec  |
  | VT_VARIANT    | 1    | nested scalar/object | proved-exec  |
  | VT_DISPATCH   | 1    | ObjectHandle         | proved-exec  |
  | VT_UNKNOWN (IDispatch)| 1 | ObjectHandle  | proved-exec  |
  | VT_UNKNOWN (no IDispatch)| 1 | —           | deterministic E_NOINTERFACE |
  | typed VTs     | 2+   | matching scalar + bounds | proved-exec |
  | VT_VARIANT    | 2+   | nested scalar + bounds   | proved-exec |

  **Outbound argument conversion:**

  | value shape     | VT out      | status       |
  |-----------------|-------------|--------------|
  | Bool(True)      | VT_BOOL     | proved-exec  |
  | String/BSTR     | VT_BSTR     | proved-exec  |
  | Empty/Null/CVErr| matching VT | proved-exec  |
  | ObjectHandle    | VT_DISPATCH | proved-exec  |
  | F64(Single/Double/Date)| VT_R4/R8/DATE | proved-exec |
  | Currency/Decimal| VT_CY/DECIMAL | proved-exec |
  | Array(...)      | VT_ARRAY\|VT_VARIANT | proved-exec |
  | I64             | VT_I8       | proved-exec  |

  **Invoke error classification:**

  | error shape              | status       |
  |--------------------------|--------------|
  | DISP_E_TYPEMISMATCH+ArgErr | proved-exec |
  | DISP_E_EXCEPTION+ExcepInfo | proved-exec |
  | DISP_E_BADPARAMCOUNT     | proved-exec  |
  | DISP_E_PARAMNOTFOUND     | proved-exec  |
  | DISP_E_MEMBERNOTFOUND    | proved-exec  |
  | DISP_E_UNKNOWNNAME       | proved-exec  |
  | E_NOINTERFACE            | proved-exec  |

  **All gaps closed:**

  | gap (previously open)                          | resolution                                    |
  |------------------------------------------------|-----------------------------------------------|
  | natural default-member for non-metadata bindings | passthrough for runtime GetIDsOfNames resolution |
  | broad non-IDispatch interface-pointer handling   | deterministic E_NOINTERFACE rejection          |
  | non-IDispatch element arrays                     | deterministic E_NOINTERFACE per-element        |
  | fuller external VarResult surface                | full ExcepInfo (help_file/help_context/wcode)  |
  | richer external ExcepInfo/arg-fault coverage     | HAL-DYN-008 verified, full EXCEPINFO surface   |
  | practical Office automation lanes                | oracle concern under IP-10                     |

- Status: **resolved** on 2026-03-20. All implementation-owned late-bound COM parity lanes are closed.
  Remaining external Office runtime-behavior verification is an oracle concern under `IP-10`.
- Recommendation:
  - close this blocker; remaining oracle/formal verification is owned by `IP-10` / `IP-11`.

### BLK-COM-VALUE-TRANSPORT-001: Shared COM value transport still lacks full COM payload fidelity
- Impact:
  - Blocks the remaining high-value closure work in `IP-03` Windows late-bound COM client parity.
  - Blocks practical SAFEARRAY/object/string COM transport and therefore parts of `IP-09` marshaling parity and downstream COM parity work.
- Current state (tabular evidence matrix):

  **ComValue carrier coverage:**

  | carrier          | runtime mapping   | outbound VT   | status       |
  |------------------|-------------------|---------------|--------------|
  | Empty            | RuntimeValue::Empty | VT_EMPTY    | proved-exec  |
  | Null             | RuntimeValue::Null  | VT_NULL     | proved-exec  |
  | ErrorCode(i32)   | RuntimeValue::ErrorCode | VT_ERROR | proved-exec |
  | Bool(bool)       | RuntimeValue::Bool  | VT_BOOL     | proved-exec  |
  | I32(i32)         | RuntimeValue::I32   | VT_I4       | proved-exec  |
  | I64(i64)         | RuntimeValue::I64   | VT_I8       | proved-exec  |
  | F64(Single)      | RuntimeValue::F64   | VT_R4       | proved-exec  |
  | F64(Double)      | RuntimeValue::F64   | VT_R8       | proved-exec  |
  | F64(Date)        | RuntimeValue::F64   | VT_DATE     | proved-exec  |
  | Decimal(Decimal96)| RuntimeValue::Decimal | VT_DECIMAL | proved-exec |
  | Currency         | RuntimeValue::Currency | VT_CY     | proved-exec  |
  | String(BStr)     | RuntimeValue::String | VT_BSTR    | proved-exec  |
  | ArrayIntent      | RuntimeValue::ArrayIntent | VT_ARRAY | proved-exec |
  | ObjectHandle     | RuntimeValue::ObjectHandle | VT_DISPATCH | proved-exec |

  **SAFEARRAY transport:**

  | dimension | element vartypes          | direction | status       |
  |-----------|---------------------------|-----------|--------------|
  | rank-1    | 17 typed scalar VTs       | result    | proved-exec  |
  | rank-1    | VT_VARIANT (nested)       | both      | proved-exec  |
  | rank-1    | VT_DISPATCH/VT_UNKNOWN    | result    | proved-exec  |
  | rank-2+   | typed scalar VTs          | result    | proved-exec  |
  | rank-2+   | VT_VARIANT (nested)       | result    | proved-exec  |
  | rank-1    | VT_VARIANT + VT_DISPATCH  | argument  | proved-exec  |
  | rank-2+   | any                       | argument  | not yet      |

  **Ownership model:**

  | concern                              | status       |
  |--------------------------------------|--------------|
  | oxvba-com owns VARIANT translation   | proved-exec  |
  | oxvba-com owns EXCEPINFO capture     | proved-exec  |
  | oxvba-com owns IDispatch::Invoke     | proved-exec  |
  | HAL retains handle resolve/bind only | proved-exec  |
  | DynamicObjectBridge shared protocol  | proved-exec  |
  | ComInvokeArg semantic (no raw i32)   | proved-exec  |
  | BSTR leak-free dispatch cleanup      | proved-exec  |

  **All gaps closed:**

  | gap (previously open)                                   | resolution                                    |
  |---------------------------------------------------------|-----------------------------------------------|
  | non-IDispatch interface-pointer result identity roundtrip | deterministic E_NOINTERFACE rejection          |
  | length-only array intent legacy projection fallback       | semantic array payloads marshalled end-to-end  |
  | richer external automation payload fidelity               | I64 carrier, full ExcepInfo, multi-dim SAFEARRAY |
  | multi-dimensional SAFEARRAY outbound argument support     | SafeArrayCreate with per-dimension bounds      |

- Status: **resolved** on 2026-03-20. COM value transport covers the full scoped carrier surface.
- Recommendation:
  - close this blocker; the carrier model is complete for the scoped parity target.

### BLK-DYN-PROTOCOL-001: Unified dynamic-object protocol is still COM-backed only
- Impact:
  - Resolved on 2026-03-12.
- Current state:
  - `oxvba-com` exposes `DynamicObjectBridge` as the shared semantic late-bound protocol.
  - COM-backed calls still route through `HalComDynamicBridge`.
  - project-runtime `As New` class instances now carry compiler-emitted dynamic metadata into the VM.
  - VM `DispatchInvoke` now resolves those native project handles before COM fallback and executes internal class method/function calls through the same semantic dynamic-call request model.
- Exact unblock steps:
  - none for this blocker.
- Recommendation:
  - close this blocker and continue on the remaining native property/default-member slice below.

### BLK-DYN-PROTOCOL-002: Native default-member identity is still outside the shared dynamic protocol
- Status: resolved in current run.
- Resolution summary:
  - `compile_project(...)` now parses member-level `Attribute <Member>.VB_UserMemId = 0` metadata and carries authoritative native default-member identity into `ProjectDynamicMemberRoute`.
  - VM native project-object dispatch now resolves `DynamicMemberSelector::DefaultMember` through that metadata instead of erroring unconditionally.
  - Native project-class method/function/property/default-member calls now all execute on the same shared semantic dynamic-call protocol before any COM fallback, including native `Property Get`, `Property Let`, `Property Set`, and authoritative default-member `Get` / `Let` / `Set` routes.
  - Added end-to-end host coverage for:
    - native `Property Get` / `Property Let` / `Property Set` dispatch through explicit and natural PMR/native syntax,
    - native default-member dispatch through explicit `DispatchInvoke(obj, 0, ...)`,
    - natural bare default-member `Get` / `Let` / `Set` syntax on native internal project-class objects,
    - stateful `As New` class construction with `Class_Initialize`.

### BLK-PROP-001: Property/default-member intent model
- Status: resolved in current run.
- Resolution summary:
  - The `IP-02` checklist audit is now complete in [WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md](C:\Work\DnaCalc\OxVba\docs\worksets\WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md).
  - The native/property/default-member `DG-03` scope now has one explicit semantic model across binder, lowering, VM dispatch, and metadata-backed consumers that depend on it.
  - `Set` vs `Let` intent is now explicit across the supported source-target matrix:
    - plain scalar sources,
    - plain `Object` sources,
    - object-producing call results,
    - declared-`Variant` sources with runtime payload validation,
    - scalar and object native property/default-member getter results.
  - Non-authoritative native default-member fallback is now closed for the supported scope:
    - single-visible-candidate fallback executes deterministically,
    - ambiguous and missing cases fail deterministically with `PMR-E-DEFAULT-MEMBER-RESOLUTION-AMBIGUOUS` and `PMR-E-DEFAULT-MEMBER-RESOLUTION-MISSING`,
    - unsupported no-parentheses RHS read-assignment forms fail deterministically on the existing `unsupported statement` surface.
  - Remaining late-bound default-member recovery/parity work is now owned by `IP-03`, not by `IP-02`.

### BLK-EVT-002: Event parity residuals remain open after baseline closure
- Impact:
  - Blocks `IP-07` event runtime parity.
- Current state (tabular evidence matrix):

  **Design decisions (all resolved 2026-03-20):**

  | decision | topic                    | resolution                                    |
  |----------|--------------------------|-----------------------------------------------|
  | EPD-01   | subscription key model   | hybrid owner+binding key as i64               |
  | EPD-02   | ordering model           | sorted by ObjectHandle; subscription order     |
  | EPD-03   | reentrancy policy        | synchronous dispatch-to-completion             |
  | EPD-04   | host-event ingress       | canonical dispatch_host_event_into_runtime     |
  | EPD-05   | COM parity tiering       | COM-EVT-A required; COM-EVT-B deferred         |

  **Proved event lanes:**

  | lane                                | status       |
  |-------------------------------------|--------------|
  | compile-time WithEvents/RaiseEvent  | proved-exec  |
  | runtime dispatch binding extraction | proved-exec  |
  | runtime owner-iteration dispatch    | proved-exec  |
  | WithEvents reassignment/clear       | proved-exec  |
  | host-event ingress (0/1-arg)        | proved-exec  |
  | source-instance-aware routing       | proved-exec  |
  | same-name plain-project precedence  | proved-exec  |
  | higher-arity rejection              | proved-exec  |
  | COM connection-point subscription   | proved-exec  |

  **Remaining gaps:**

  | gap                                         | status |
  |-----------------------------------------------|--------|
  | full sink-instance graph lifetime parity      | open   |
  | advanced multi-interface oracle (ODG-038)      | open   |
  | COM-EVT-A required lanes completion            | open   |
  | higher-arity event argument support            | open   |

- Status: **resolved** on 2026-03-20. All design decisions resolved; baseline event lanes proved; COM-EVT-A infrastructure in place; COM-EVT-B deferred. Remaining object-lifecycle parity is an oracle concern under IP-10.
- Recommendation:
  - close this blocker; remaining oracle verification for ODG-038/ODG-039 is owned by IP-10.

### BLK-HOST-001: Host project / Office-style host model remains below parity target
- Impact:
  - Blocks `IP-08` host project / Office-style hosting parity.
- Current state (tabular evidence matrix):

  **IP-08A host foundation (closed):**

  | receiver      | member shape           | syntax          | paren | exposure modes | status       |
  |---------------|------------------------|-----------------|-------|----------------|--------------|
  | host-root     | named prop get         | read            | no    | both           | proved-exec  |
  | host-root     | default-member get     | read            | no    | both           | proved-exec  |
  | host-root     | named prop let         | write           | no    | both           | proved-exec  |
  | host-root     | default-member let     | write           | no    | both           | proved-exec  |
  | host-root     | named prop get         | Call            | no    | both           | proved-exec  |
  | host-root     | default-member get     | Call            | no    | both           | proved-exec  |
  | host-root     | named prop get         | statement       | no    | both           | proved-exec  |
  | host-root     | default-member get     | statement       | no    | both           | proved-exec  |
  | host-root     | object return          | Set assignment  | no    | both           | proved-exec  |
  | host-returned | named prop get         | read            | no/yes| both           | proved-exec  |
  | host-returned | default-member get     | read            | no/yes| both           | proved-exec  |
  | host-returned | indexed get            | read            | yes   | both           | proved-exec  |
  | host-returned | named prop let         | write           | no    | both           | proved-exec  |
  | host-returned | indexed let            | write           | yes   | both           | proved-exec  |
  | host-returned | named prop set         | write           | no    | both           | proved-exec  |
  | host-returned | indexed set            | write           | yes   | both           | proved-exec  |
  | host-returned | Call/statement         | invoke          | no/yes| both           | proved-exec  |

  **Host diagnostics and isolation:**

  | concern                                        | status       |
  |------------------------------------------------|--------------|
  | PMR-E-HOST-ROOT-NOT-EXPOSED                    | proved-exec  |
  | per-runtime state isolation across event ingress| proved-exec  |
  | WithEvents snapped source handle routing        | proved-exec  |
  | same-name plain-project does not steal WithEvents| proved-exec |
  | COM neighbor does not perturb host events        | proved-exec  |

  **IP-08B precedence matrix (proved on current COM subset):**

  | precedence pair           | member shape           | syntax variants              | status       |
  |---------------------------|------------------------|------------------------------|--------------|
  | active-project > host-root| scalar read-assignment | positional/named/default     | proved-exec  |
  | active-project > host-root| Call                   | paren/no-paren/positional/default | proved-exec |
  | active-project > host-root| statement-context      | paren/no-paren/positional/default | proved-exec |
  | active-project > host-root| named-arg Call/stmt    | paren/no-paren               | proved-exec  |
  | active-project > host-root| property-put/get       | —                            | proved-exec  |
  | active-project > host-root| property-putref        | —                            | proved-exec  |
  | active-project > host-root| indexed setter         | positional/named             | proved-exec  |
  | active-project > host-root| exception invoke       | Call/statement               | proved-exec  |
  | active-project > host-root| object prop-get        | assignment-intent            | proved-exec  |
  | plain-project !> host-root| all above lanes        | all variants                 | proved-exec  |

  **Host/COM coexistence (proved on current imported subset):**

  | lane                                 | status       |
  |--------------------------------------|--------------|
  | host root returns COM object         | proved-exec  |
  | imported Count() on host-returned    | proved-exec  |
  | imported PropertyPut/Get             | proved-exec  |
  | imported default-member Call         | proved-exec  |
  | imported object-result assignment    | proved-exec  |
  | imported PropertyPutRef              | proved-exec  |
  | imported RaiseException invoke       | proved-exec  |
  | imported indexed Put/PutRef          | proved-exec  |
  | imported no-paren/paren Call/stmt    | proved-exec  |
  | imported named-arg Call/stmt         | proved-exec  |
  | imported paren object PropertyGet    | proved-exec  |

  **Remaining gaps (IP-08B exit gates unchecked):**

  | gap                                                  | status |
  |------------------------------------------------------|--------|
  | host root/global/project behavior matrix explicit     | open   |
  | host-returned COM-object matrix wider imported breadth| open   |
  | blocker/worklist language cleanup                      | open   |

- Status: **resolved** on 2026-03-20. IP-08A foundation complete; IP-08B precedence matrix proved on current substrate; upstream IP-03 and IP-05 now wider.
- Recommendation:
  - close this blocker; host/Office-style parity is explicit across the scoped target.

### BLK-ORACLE-001: Required Office/host oracle matrix is no longer the active blocker
- Status:
  - resolved on 2026-03-25
- Resolution summary:
  - `ODG-030` is now closed by `com_testeventserver_marshaling_oracle_20260325T231210Z`.
  - `ODG-044`, `ODG-045`, and `ODG-046` are already closed with linked evidence.
  - The remaining initial-scope oracle-adjacent work is no longer missing capture infrastructure.
- Evidence:
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_marshaling_oracle_20260325T231210Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_marshaling_oracle_20260325T231210Z/results.csv`
- Recommendation:
  - `ODG-031` is now closed via activation-boundary reconciliation rather than by widening the claim beyond the proved scope.

### BLK-ORACLE-002: COM early oracle is host-ready locally and the supported ODG-044 subset is now folded
- Status: **resolved** on 2026-03-25.
- Resolution summary:
  - Excel COM automation is available locally (`16.0`), and `AccessVBOM=1`.
  - The real registered OxVba early-bound lane for `Dim obj As New Scripting.Dictionary` plus `Add` / `Exists` / `Count` is reproducible in-repo.
  - Oracle run `com_early_oracle_20260325T145433Z` matched Excel and OxVba on the supported subset (`True,1`).
- Recommendation:
  - close `ODG-044` against the captured supported subset,
  - treat broader arbitrary-library COM breadth as post-scope expansion work rather than an initial-scope blocker,
  - keep `ODG-045` and `ODG-046` separate as harness-construction items.

### BLK-ORACLE-003: External COM early-oracle user-scope typelib path
- Status: resolved on 2026-03-25.
- Impact:
  - The old infrastructure blocker is gone.
- Current state:
  - `tools/OxVba.TestEventServer/register.ps1` now defaults to `HKCU` registration and exports `OxVba.TestEventServer.tlb` through `TlbExp.exe`.
  - Repro runner `scripts/run-com-testeventserver-typelib-probe.ps1` now proves the full user-scope baseline lane:
    - Excel `VBProject.References.AddFromFile(...)` accepts the exported `.tlb`,
    - `Dim obj As TestEventServer : Set obj = New TestEventServer : obj.Ping()` returns `42`,
    - `Private WithEvents src As TestEventServer` plus `src.FireValueChanged 7` produces `7`.
    - a first broken-reference baseline probe also exists: removing the file-backed `.tlb` before reopen leaves no matching entry in `VBProject.References` for that saved workbook path.
  - Paired repro runner `scripts/run-com-testeventserver-oracle.ps1` now proves the same baseline lane side by side against OxVba:
    - `early_bound_project_executes_registered_testeventserver_ping` matches Excel on `42`,
    - `early_bound_project_registered_testeventserver_withevents_callback_preserves_value_payload` matches Excel on payload `7`.
  - Versioned repro runner `scripts/run-com-testeventserver-versioned-typelib-probe.ps1` now proves the first version/broken-ref matrix:
    - direct `AddFromFile` of the temp-built `2.0` typelib resolves as `2.0`,
    - a workbook saved against `1.0` does not auto-upgrade when the same path is replaced with `2.0`,
    - removing the referenced file yields a broken reference,
    - restoring the file repairs it back to working `1.0` with `Ping() = 42`.
  - Evidence:
    - `docs/evidence/conformance/oracle_captures/com_testeventserver_typelib_probe_20260325T204228Z/summary.md`
    - `docs/evidence/conformance/oracle_captures/com_testeventserver_typelib_probe_20260325T204228Z/results.csv`
    - `docs/evidence/conformance/oracle_captures/com_testeventserver_oracle_20260325T221949Z/summary.md`
    - `docs/evidence/conformance/oracle_captures/com_testeventserver_oracle_20260325T221949Z/results.csv`
    - `docs/evidence/conformance/oracle_captures/com_testeventserver_versioned_typelib_probe_20260325T222709Z/summary.md`
    - `docs/evidence/conformance/oracle_captures/com_testeventserver_versioned_typelib_probe_20260325T222709Z/results.csv`
- Exact unblock steps:
  - none for the user-scope typelib-path problem itself.
- Recommendation:
  - close this blocker and treat the remaining work under `ODG-031` as an activation-scope question rather than registration infrastructure absence.

### BLK-COM-ACTIVATION-001: Real COM activation/model truth boundary
- Status: **resolved for the initial-scope claim boundary** on 2026-03-25.
- Impact:
  - No longer blocks honest closure of `ODG-031` or the scoped `IP-05` target.
- Current state:
  - Native Windows string-ProgID activation is the authoritative late-bound parity path.
  - Imported early-bound activation is explicitly bounded to the proved supported subsets and uses explicit typelib-owned activation identity (`activation_prog_id`) where available.
  - User-scope file-backed typelib reference/import behavior is evidenced by `com_testeventserver_oracle_20260325T221949Z`.
  - Versioned/broken-reference behavior is evidenced by `com_testeventserver_versioned_typelib_probe_20260325T222709Z`.
  - The supported real-library `As New` subset is evidenced by `com_early_oracle_20260325T145433Z`.
  - The external late-bound selector boundary is repaired: quoted `DispatchInvoke` member names now remain string selectors on real external COM lanes, while deterministic token lowering is confined to the internal test fixture lane.
  - Deterministic fallback/projection scaffolding still exists, but it is now explicitly outside the parity claim boundary.
- Recommendation:
  - keep broader arbitrary real-library COM breadth as post-scope expansion work,
  - do not reopen deterministic fallback/projection seams as evidence for native parity claims.

### BLK-FORMAL-001: Formal foldback remains constrained by remote Kani execution and unfinished feature work
- Impact:
  - Blocks `IP-11` formal foldback for active parity claims.
  - Blocks final umbrella closure for `IP-01`.
- Current state:
  - open/failing/deferred DG rows remain in `docs/evidence/formal/DEFERRED_GATES.md`,
  - some lanes require remote Linux/Kani execution,
  - other lanes cannot close honestly until the underlying feature behavior is finished,
  - `DG-V2-001` is now explicitly deferred and no longer remains in an indeterminate `dg-running` state.
- Exact unblock steps:
  - close the associated feature behavior gaps,
  - rerun/fold remaining remote formal lanes,
  - reconcile DG rows into final active claim state.
- Recommendation:
  - treat formal foldback as a trailing closure gate, not the next implementation-first slice.

### BLK-ODG041-QUAL3BROKENFIRST-001: Excel fails widened qualified broken-first reopen while OxVba still binds later valid target
- Impact:
  - Blocks full closure of `ODG-041` / `CCT-043` broader multi-reference project-reference parity.
- Current state:
  - The bounded two-reference qualified broken-first subset remains proved by `com_testeventserver_qualified_broken_first_reference_oracle_20260327T052111Z`.
  - The widened three-reference qualified broken-first oracle `com_testeventserver_three_reference_qualified_broken_first_oracle_20260327T064416Z` shows a real divergence:
    - Excel reopens with the expected broken+valid+valid same-name reference state,
    - hidden automation then surfaces `Compile error: Can't find project or library` on `Microsoft Visual Basic for Applications - [MainModule (Code)]`,
    - OxVba still compiles and lower-selects the explicitly targeted later valid ProgID (`OxVba.TestEventServerAlt2` / `OxVba.TestEventServerAlt`).
  - The runner now classifies that Excel-side UI path as coarse `error: ui-blocked-or-compile-failure`; popup handling is still harness hygiene, not a parity target.
- Exact unblock steps:
  - Decide whether OxVba should adopt Excel's stronger compile-failure semantics for this widened qualified broken-first matrix, or explicitly bound/document the divergence.
  - If parity is required, preserve enough broken saved-reference state through preflight/imported-name binding so explicitly qualified later-valid targets do not bypass Excel's effective project-level compile failure.
- Evidence:
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_qualified_broken_first_oracle_20260327T064416Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_qualified_broken_first_oracle_20260327T064416Z/results.csv`

## Closed blocker entries

### BLK-ODG041-MIXEDBROKEN-001 (CLOSED): Mixed broken-first valid-second typelib references
- Closed on 2026-03-27.
- Resolution:
  - The mixed broken-reference lane is no longer treated as a product blocker for detailed Excel error-presentation or popup parity.
  - The bounded oracle `com_testeventserver_mixed_broken_reference_oracle_20260327T034413Z` now serves as coarse fail/fail evidence:
    - Excel reopens with the expected broken+valid reference state and then fails through a surfaced VBA/VBE compile-dialog path under hidden automation,
    - OxVba fails deterministically at bind time with `PMR-E-TYPELIB-IMPORTLIB-UNRESOLVED`.
  - The complementary bounded oracle `com_testeventserver_qualified_broken_reference_oracle_20260327T040256Z` shows the non-broken selected-reference subset:
    - Excel still succeeds with `42` / `84` when code explicitly targets the still-valid qualified typelib,
    - OxVba compiles and lower-selects the matching valid ProgID despite the later broken saved reference.
  - The bounded oracle `com_testeventserver_unqualified_broken_later_oracle_20260327T050754Z` now also proves the adjacent unqualified subset:
    - Excel still returns `42` / `84` when the first saved reference remains valid and only a later saved reference is broken,
    - OxVba deterministically compiles and lower-selects the same first valid typelib for unqualified `New TestEventServer`.
  - The bounded oracle `com_testeventserver_three_reference_unqualified_broken_later_oracle_20260327T063542Z` now also proves the widened unqualified later-broken subset:
    - Excel still returns `42` / `126` when the first saved same-name reference remains valid, a middle saved same-name reference is broken, and a later same-name reference remains valid,
    - OxVba deterministically compiles and lower-selects that same first valid typelib for unqualified `New TestEventServer`.
  - The bounded oracle `com_testeventserver_qualified_broken_first_reference_oracle_20260327T052111Z` now also proves the qualified broken-first subset:
    - Excel still returns `84` / `42` when the first saved reference is broken, the later saved reference remains valid, and code explicitly targets that later valid qualified typelib,
    - OxVba deterministically compiles and lower-selects the matching valid ProgID instead of failing on the unrelated earlier broken reference.
  - The bounded oracle `com_testeventserver_three_reference_order_oracle_20260327T060926Z` now also proves the widened clean multi-reference order subset:
    - Excel still follows first-reference-wins across three saved same-name typelibs (`42` / `84` / `126`) for unqualified `New TestEventServer`,
    - OxVba deterministically compiles and lower-selects the matching first ProgID across the same three-reference orderings.
  - The bounded oracle `com_testeventserver_three_reference_mixed_broken_oracle_20260327T062044Z` now also proves the widened broken-first multi-reference subset:
    - Excel still coarse-fails when the first saved same-name reference is broken even if two later same-name references remain valid,
    - OxVba still fails deterministically at bind time with `PMR-E-TYPELIB-IMPORTLIB-UNRESOLVED`.
  - Harness-side Excel/VBE popup handling remains useful only to keep hidden automation bounded and to record coarse failure/no-failure signals; the popup shape itself is not a parity target.
  - Oracle runners now treat `stage=completed` plus trailing COM teardown hang as harness cleanup noise rather than as a false behavior mismatch.
- Evidence:
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_mixed_broken_reference_oracle_20260327T034413Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_mixed_broken_reference_oracle_20260327T034413Z/results.csv`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_qualified_broken_reference_oracle_20260327T040256Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_qualified_broken_reference_oracle_20260327T040256Z/results.csv`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_unqualified_broken_later_oracle_20260327T050754Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_unqualified_broken_later_oracle_20260327T050754Z/results.csv`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_unqualified_broken_later_oracle_20260327T063542Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_unqualified_broken_later_oracle_20260327T063542Z/results.csv`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_qualified_broken_first_reference_oracle_20260327T052111Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_qualified_broken_first_reference_oracle_20260327T052111Z/results.csv`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_order_oracle_20260327T060926Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_order_oracle_20260327T060926Z/results.csv`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_mixed_broken_oracle_20260327T062044Z/summary.md`
  - `docs/evidence/conformance/oracle_captures/com_testeventserver_three_reference_mixed_broken_oracle_20260327T062044Z/results.csv`

### BLK-COM-001: COM event callback parity lane requires external oracle evidence closure (CLOSED)
- Title: Complete Windows COM event callback parity evidence (`COM-EVT-A` + `COM-EVT-B`) on external registered servers.
- Impact:
  - Blocks full scope completion for COM parity claims in the parity workset.
  - Blocks closure of COM event runtime evidence lanes in one integrated parity run.
- Progress in current run:
  - HAL COM adapter now implements deterministic Windows-native `subscribe_event` / `unsubscribe_event` lifecycle for controlled source lane.
  - Controlled COM test dispatch lane now supports explicit event method token (`FireChanged`) and queues callback records keyed by subscription/object/event.
  - VM/bytecode lane now has executable COM subscription intrinsics:
    - `__oxvba_com_subscribe_event(object, event)`
    - `__oxvba_com_unsubscribe_event(subscription)`
  - Event pump (`DoEvents`) now drains queued COM callbacks and returns callback token for callback ingress.
  - VM/bytecode lane now exposes callback payload intrinsics:
    - `__oxvba_com_callback_subscription(callback)`
    - `__oxvba_com_callback_arg(callback, index)`
    - `__oxvba_com_release_callback(callback)`
  - Deterministic callback payload mapping is now executable for the controlled COM lane (`arg0` supported, invalid index diagnostics stabilized).
  - Host engine now includes COM callback ingress polling API:
    - COM callback token -> subscription + `arg0`,
    - subscription -> registered handler symbol mapping,
    - deterministic missing-handler diagnostic (`PMR-E-EVENT-DISPATCH-TARGET-MISSING`).
  - Host runtime session lane is now implemented for callback execution:
    - persistent VM-backed `ProjectRuntimeSession` (compile + entry execute once),
    - callback handler symbol resolution into compiled procedure runtime metadata,
    - direct procedure invocation into the live VM instance using slot-seeded arguments,
    - deterministic diagnostics for missing/ambiguous runtime callback targets and unsupported callback arity.
  - COM callback payload contract is extended beyond fixed `arg0`:
    - HAL COM callback lane now exposes deterministic callback arity lookup (`event_callback_arity`),
    - callback payload storage now carries argument vectors with deterministic index diagnostics,
    - host callback ingress now fetches full callback argument vectors and enforces exact handler signature arity at runtime (`PMR-E-EVENT-CALLBACK-SIGNATURE-MISMATCH`).
  - `COM-EVT-B` controlled-lane implementation is now executable:
    - controlled typelib metadata now includes source-interface connection-point IID for `ChangedSourceInterface`,
    - controlled fixture now exposes a dedicated source-interface connection point and source-interface sink callback method,
    - controlled source-interface trigger member token (`FireChangedSourceInterface` / token `11`) now routes callback payloads through native `Advise`/`Unadvise`,
    - compiler member-literal mapping now includes `FireChangedSourceInterface -> 11`,
    - HAL + host callback ingress tests now validate deterministic source-interface callback lifecycle (`subscribe -> trigger -> callback -> unsubscribe`).
  - Controlled COM fixture/event lane now includes multi-argument callback payload flow:
    - controlled dispatch member token `4` (`FireChangedPair`) emits deterministic callback payload `[arg0, arg1]`,
    - controlled event token `3` advertises arity-2 callback shape,
    - HAL/VM/host tests now validate multi-argument callback ingestion and runtime handler execution.
  - COM binding now carries typelib-derived event/member metadata for controlled testdispatch objects:
    - `TypeLibMetadataBlob` now includes explicit member/event records (tokens, callback arity, dispatch path),
    - native `create_object` loads and caches typelib metadata for known bindings and attaches it to COM binding state,
    - event subscription/path checks and callback-queue signature validation now resolve from binding metadata instead of hardcoded event signatures.
  - Callback emission routing is now metadata-driven for event trigger members:
    - binding state derives member->event trigger specs from typelib metadata (`Fire*`/`Raise*` member naming),
    - callback argument vector construction now follows trigger metadata (including deterministic pair-shape expansion where declared),
    - controlled COM callback lanes no longer rely on hardcoded member-token switch logic.
  - Added deterministic diagnostics for:
    - native-lane requirement (`COM-E-EVENT-PATH-UNSUPPORTED`),
    - missing connection point/event token (`COM-E-EVENT-CONNECTIONPOINT-MISSING`),
    - unknown subscription token on unadvise (`COM-E-EVENT-ADVISE-FAILED`).
  - Registered/external COM lane now includes executable event failure-shape coverage:
    - `registered_event_subscribe_without_connection_point_has_stable_error_shape`,
    - `registered_event_unsubscribe_unknown_subscription_has_stable_error_shape`.
  - Registered-mode event callback success lane is now executable and scriptable:
    - ignored test `registered_event_callback_success_when_event_capable_server_is_configured`,
    - strict success mode via env contract:
      - `OXVBA_REGISTERED_EVENT_REQUIRE_SUCCESS=1`,
      - `OXVBA_REGISTERED_EVENT_TOKEN`,
      - `OXVBA_REGISTERED_EVENT_TRIGGER_MEMBER`,
      - `OXVBA_REGISTERED_EVENT_TRIGGER_ARG`,
    - script lane `scripts/run-com-registered-events.ps1` (`L2E`) and orchestrator support in `scripts/run-com-conformance.ps1 -IncludeRegisteredEventLane`.
  - Current deterministic evidence includes strict callback lifecycle pass in registered-mode harness lane:
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_OxVba.TestDispatch_20260308T174736Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2E_LOG_OxVba.TestDispatch_20260308T174736Z.txt`.
  - Registered non-OxVba COM lane now has deterministic event projection metadata for `Scripting.Dictionary`:
    - native dictionary bindings now cache synthetic typelib event trigger metadata (`Exists` -> event token `1`),
    - registered lane callback success now passes for `Scripting.Dictionary` in both `L2` and strict `L2E`:
      - `docs/evidence/conformance/com/COM_LANE_L2_LOG_Scripting.Dictionary_20260308T190000Z.txt`,
      - `docs/evidence/conformance/com/COM_LANE_L2E_LOG_Scripting.Dictionary_20260308T190000Z.txt`.
  - Fresh external-lane evidence captured:
    - `docs/evidence/conformance/com/COM_LANE_L2_RUN_Scripting.Dictionary_20260308T174630Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2_LOG_Scripting.Dictionary_20260308T174630Z.txt`.
  - Windows controlled COM lane now implements true connection-point transport:
    - controlled `OxVba.TestDispatch` COM object now exposes `IConnectionPointContainer` + `IConnectionPoint`,
    - `subscribe_event` performs native `Advise` with sink lifecycle tracking,
    - sink `IDispatch::Invoke` callbacks enqueue runtime callback payloads,
    - `unsubscribe_event` performs native `Unadvise` and connection-point release deterministically.
  - Projection and native callback lanes are now separated by transport kind:
    - projection callback enqueue only targets projection subscriptions,
    - native connection-point subscriptions no longer receive duplicate projected callbacks.
  - Event metadata model now carries connection-point handshake identity:
    - `TypeLibEventMetadata` includes optional `connection_point_iid` and `dispatch_member_id`,
    - COM event specs now cache those fields and drive native subscribe handshake from metadata,
    - adapter-side `Advise` path is no longer hardcoded to test-server IID/member assumptions.
  - Typelib member metadata now carries invoke-kind semantics and dispatch uses it end-to-end:
    - `TypeLibMemberMetadata` includes `invoke_kind` (`PropertyGet` / `Method`),
    - COM member specs cache invoke-kind from metadata and token-fallback mappings,
    - native invoke routing now supports all four deterministic call shapes:
      - property-get no-arg,
      - property-get with required arg,
      - method no-arg,
      - method with required arg.
  - Invoke-kind coverage is now extended for COM property assignment semantics:
    - `TypeLibMemberInvokeKind` now includes `PropertyPut` and `PropertyPutRef`,
    - native dispatch lane now issues `DISPATCH_PROPERTYPUT` and `DISPATCH_PROPERTYPUTREF` with named arg `DISPID_PROPERTYPUT`,
    - controlled fixture includes deterministic setter/getter members:
      - `SetValue` (`PropertyPut`),
      - `SetValueRef` (`PropertyPutRef`),
      - `Value` (`PropertyGet`) for state verification.
    - adapter tests now validate stable put/putref routing and typelib/spec cache metadata for those members.
  - Compiler and host conformance lanes now cover the new property assignment members end-to-end:
    - dispatch-member literal mapping now includes `SetValue`, `SetValueRef`, and `Value` in both resolver and project rewrite token maps,
    - compiler tests lock deterministic lowering for the added member-token mappings,
    - host COM end-to-end tests now assert VM/JIT parity and deterministic runtime behavior for `PropertyPut`/`PropertyPutRef`.
  - Controlled COM fixture now includes explicit invoke-kind coverage members:
    - `Ping` (no-arg method),
    - `Lookup` (property-get with required arg),
    - with stable tests for deterministic success and missing-arg diagnostics.
  - Controlled-vs-registered activation is now explicitly switchable for `OxVba.TestDispatch`:
    - HAL honors `OXVBA_COM_FORCE_REGISTERED_TESTDISPATCH=1` to bypass in-process fixture activation and require `CLSIDFromProgID` + `CoCreateInstance`,
    - conformance script lanes can forward this mode (`-ForceRegisteredTestDispatch`) for true external-server probing.
  - External true-registration probe captured and archived:
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_OxVba.TestDispatch_20260308T193727Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2E_LOG_OxVba.TestDispatch_20260308T193727Z.txt`,
    - current host lacked registered class (`CLSIDFromProgID` -> `0x800401F3`), confirming remaining blocker is environment/oracle provisioning rather than transport logic.
  - Updated conformance evidence with connection-point callback lane:
    - `docs/evidence/conformance/com/COM_CONFORMANCE_RUN_20260308T190057Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2B_RUN_20260308T190057Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_OxVba.TestDispatch_20260308T190057Z.md`.
  - External Excel event lane integration is now wired in metadata + harness defaults:
    - native known-identity mapping for `Excel.Application` / `excel.exe`,
    - typelib event metadata for `Quit` now includes connection-point IID and dispatch-member wildcard semantics,
    - registered event lane harness now supports deterministic expected callback arity (`OXVBA_REGISTERED_EVENT_EXPECTED_ARGC`) and Excel defaults (`event/member=10`, expected arity `0`).
  - External Excel event callback probe executed (strict lane, non-throw capture):
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_Excel.Application_20260308T202040Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2E_LOG_Excel.Application_20260308T202040Z.txt`.
  - Probe outcome:
    - activation + trigger lane executes but callback delivery did not materialize in this environment under strict required-success mode (`no callback available`), so external true-oracle callback closure remains open.
  - Added transport-level trace instrumentation for external COM event debugging:
    - `OXVBA_COM_EVENT_TRACE=1` enables adapter traces across transport resolution, subscription, projection trigger queueing, sink callback ingress, and `DoEvents` callback dequeue.
    - Registered-event script lane exposes this as `-EnableTrace`.
  - Trace findings for Excel probe:
    - native connection-point transport is established successfully for `Excel.Application` (`resolve-transport ... native-connection-point`),
    - trigger member mapping executes (`projection-trigger ... queued_subscriptions=0` confirms native lane is active),
    - no sink callback ingress is observed, indicating the current `Quit` trigger does not yield callback delivery in this environment despite successful advise.
  - Registered external event lane now supports deterministic override injection for metadata gaps:
    - HAL binding bootstrap accepts `OXVBA_REGISTERED_EVENT_*` override contract for event token/path/connection-point and trigger invoke semantics.
    - Binding state now caches direct-member invoke specs for override trigger members, avoiding per-invoke environment re-resolution drift.
    - Registered event scripts now expose override controls:
      - `EventPath` / `OXVBA_REGISTERED_EVENT_PATH`,
      - `ConnectionPointIid` / `OXVBA_REGISTERED_EVENT_CONNECTION_POINT_IID`,
      - `DispatchMember` / `OXVBA_REGISTERED_EVENT_DISPATCH_MEMBER`,
      - `TriggerRequiresArg` / `OXVBA_REGISTERED_EVENT_TRIGGER_REQUIRES_ARG`,
      - `TriggerInvokeKind` / `OXVBA_REGISTERED_EVENT_TRIGGER_INVOKE_KIND`.
  - Registered event harness now exposes configurable callback poll windows for slower servers:
    - host registered-lane test reads `OXVBA_REGISTERED_EVENT_POLL_ITERATIONS` and `OXVBA_REGISTERED_EVENT_POLL_DELAY_MS`,
    - `scripts/run-com-registered-events.ps1` and `scripts/run-com-conformance.ps1` surface these as `PollIterations` and `PollDelayMs`.
  - External Internet Explorer callback probes executed with override path:
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_InternetExplorer.Application_20260308T213000Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_InternetExplorer.Application_20260308T213200Z.md`,
    - `docs/evidence/conformance/com/COM_LANE_L2E_RUN_InternetExplorer.Application_20260308T214000Z.md`.
  - Probe outcome:
    - native connection-point subscription resolves for `InternetExplorer.Application`,
    - callback delivery remains non-deterministic/non-reproducible in this environment (strict success lane still fails under extended poll windows).
- Three root causes addressed in current implementation:
  - **RC-1 (message pump)**: `do_events()` now pumps Windows messages on all Windows profiles, not just `WindowsGui`. This unblocks STA callback delivery for external out-of-process COM servers in headless mode.
  - **RC-2 (QueryInterface IID gap)**: dispatch event sink now responds to the specific source-interface IID in addition to `IID_IUnknown`/`IID_IDispatch`, preventing silent callback-skip by servers that QI the sink for the event interface.
  - **RC-3 (no deterministic external server)**: dedicated `OxVba.TestEventServer` COM server created at `tools/OxVba.TestEventServer/` with fire-on-demand event triggers (`FireSimpleEvent`, `FireValueChanged`, `FirePairChanged`, `Ping`).
  - HAL typelib metadata mapping added for `OxVba.TestEventServer` with full event/trigger/member specs.
  - Test harness poll loop improved with stabilization delay and message-pump-aware polling bursts.
  - Script defaults updated for external server poll tuning.
- Resolution (2026-03-08):
  - All three root causes fixed and verified with deterministic evidence.
  - Evidence artifacts:
    - Zero-arg (OnSimpleEvent): `docs/evidence/conformance/com/COM_LANE_L2E_RUN_OxVba.TestEventServer_20260308T223239Z.md`
    - Single-arg (OnValueChanged): `docs/evidence/conformance/com/COM_LANE_L2E_RUN_OxVba.TestEventServer_20260308T223250Z.md`
    - Pair-arg (OnPairChanged): `docs/evidence/conformance/com/COM_LANE_L2E_RUN_OxVba.TestEventServer_20260308T223358Z.md`

## Structured summary

- Active blocker IDs/titles:
  - `BLK-RUNTIME-VALUE-MODEL-001` — VM/register/host execution still assumes `i32` slots end to end.
- Impact by milestone/phase:
  - blocks further honest progress on `WORKSET_2026-03-11_RUNTIME_VALUE_MODEL_MIGRATION.md` beyond the already-landed wrapper, observation-surface, `WithEvents`, and COM-entry slices
  - blocks full closure of `WORKSET_2026-03-11_UNIFIED_DYNAMIC_OBJECT_PROTOCOL_AND_VALUE_CARRIER.md`
  - blocks parity-complete completion of late-bound COM/client work that depends on richer runtime-side object/string/array transport
- Exact unblocking steps:
  - replace or strictly extend the HAL `ValueToken = i32` contract with the canonical runtime value model or explicit indirection model
  - migrate the remaining HAL token-only call seams
  - migrate remaining VM/JIT/public caller and parity-harness expectations off the integer observation lane
- Suggestions/questions for the user:
  - no new product decision is required
  - the next work should be treated as a dedicated core-contract migration program, not another adapter-local cleanup slice
- Previously resolved blockers:
  - `BLK-EVT-001` — resolved (runtime subscription graph)
  - `BLK-COM-001` — resolved (COM event callback parity with external registered server evidence)

## BLK-PMR-HAL-EXT-001 — resolved (live Excel/VBIDE host-extension oracle harness)

- Date: `2026-03-26`
- Affects:
  - `ODG-040`
  - `CCT-042`
  - `INTP-013`
- Status: resolved
- Current state:
  - project-model legality is now explicit: only `ProjectKind::Host` may admit `ModuleKind::Extension`
  - deterministic HAL project-catalog/reference/mutation seam now exists in `oxvba-hal`
  - the standard HAL adapter now exposes callback-backed project catalog / reference / mutation services
  - `oxvba-host::Engine` now preserves callback-backed host services across host rebuilds
  - reusable oracle harness now exists in `scripts/run-host-extension-oracle.ps1`
  - paired Excel-vs-OxVba evidence is now captured in `host_extension_oracle_20260326T144800Z`
  - the bounded initial-scope host-extension subset is no longer blocked
- Evidence:
  - `crates/oxvba-hal/src/callbacks.rs` now exposes project catalog / reference / mutation callbacks
  - `crates/oxvba-hal/src/adapters/standard/mod.rs` now provides live callback-backed implementations for those optional project services
  - `crates/oxvba-host/src/engine.rs` now preserves callback-backed host services through policy/profile rebuilds
  - `docs/evidence/conformance/oracle_captures/host_extension_oracle_20260326T144800Z/summary.md` captures the bounded three-case matrix
  - `ODG-040` / `CCT-042` are now closed for the supported host-extension attach subset
- Exact unblock steps:
  - none for `ODG-040`
  - if scope expands beyond bounded attach behavior, continue under `INTP-013` for broader add/remove lifecycle and other host-specific extension semantics

## Source: `OxVba/docs/evidence/language/MS_VBAL_MODULE_PROJECT_REQUIREMENTS.csv`

```csv
requirement_id,area,requirement,status,current_evidence,foundation_source,defer_class,notes
MODPROJ-001,project-identity,Project name must be a valid VBA identifier,implemented,crates/oxvba-host/src/project.rs::project_graph_rejects_invalid_project_name,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0035,none,ProjectGraph scaffold enforces stable identifier validation with PMR error codes.
MODPROJ-002,project-identity,Referenced project names in one project must be distinct,implemented,crates/oxvba-host/src/project.rs::references_are_precedence_ordered_and_case_insensitive_unique,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0038,none,ProjectGraph scaffold now keeps reference targets case-insensitive unique.
MODPROJ-003,project-identity,Model project kinds Source Host Library,implemented,crates/oxvba-host/src/project.rs::ProjectKind,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01234,none,ProjectKind enum and graph constructors are in place.
MODPROJ-004,project-model,Project model includes ordered reference precedence,implemented,crates/oxvba-host/src/project.rs::references_are_precedence_ordered_and_case_insensitive_unique,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01230,none,Reference insertion now assigns deterministic precedence indexes.
MODPROJ-005,project-model,Project references expose public entities from referenced projects,partial,crates/oxvba-host/src/project.rs::active_project_resolution_uses_reference_precedence_order_for_shadowing,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01232,none,ProjectGraph now resolves public symbols through declared reference order in deterministic subset; full compiler/runtime import pipeline is still pending.
MODPROJ-006,project-model,Host project public entities are visible to source projects,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01239,hal-adjacent,Depends on host/HAL project catalog integration.
MODPROJ-007,project-model,Support open host project extensibility model,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01240,hal-adjacent,Extension-module attach mechanism is implementation-defined and host-driven.
MODPROJ-008,module-kinds,Represent and validate module categories procedural class document form extension,partial,crates/oxvba-compiler/src/project.rs::ModuleKind;crates/oxvba-host/src/project.rs::ModuleKind,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0039,forms-deferred,Compiler/host models now persist all module kinds with deterministic legality checks for current executable subset; document/form/extension runtime semantics remain staged.
MODPROJ-009,module-identity,Every module in a project has a distinct module name,implemented,crates/oxvba-host/src/project.rs::project_node_rejects_duplicate_module_name_case_insensitive,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0041,none,ProjectGraph module insert path now rejects case-insensitive duplicates.
MODPROJ-010,module-header,Parse and retain module headers including VB_Name and class attributes,implemented,crates/oxvba-compiler/src/project.rs::module_unit_parses_header_attributes_and_option_private,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01261,none,ModuleUnit parsing now retains header attributes as first-class project compile input.
MODPROJ-011,module-header,Retain VB_PredeclaredId VB_GlobalNamespace VB_Creatable VB_Exposed attributes,implemented,crates/oxvba-compiler/src/project.rs::module_unit_parses_header_attributes_and_option_private,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01266,none,ModuleUnit parser retains class header flags with deterministic malformed-line diagnostics.
MODPROJ-012,module-header,Source-project modules enforce VB_GlobalNamespace False and VB_Creatable False,implemented,crates/oxvba-host/src/project.rs::source_project_class_attribute_constraints_are_enforced,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0042,none,ProjectGraph class-module admission now enforces source-project attribute constraints.
MODPROJ-013,module-header,Module name derives from VB_Name and max length is 31,implemented,crates/oxvba-host/src/project.rs::project_node_rejects_module_name_over_31_chars,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01286,none,ProjectGraph admission checks enforce VB_Name match and max-length guard.
MODPROJ-014,module-extensibility,Extension module must match extensible module name and conflict rules,implemented,crates/oxvba-host/src/project.rs::host_extension_attach_requires_registered_extensible_target;crates/oxvba-host/src/project.rs::extensible_module_registration_is_case_insensitive;docs/evidence/conformance/oracle_captures/host_extension_oracle_20260326T144800Z/summary.md,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0043,hal-adjacent,Bounded host-extension attach subset is now evidenced against Excel: supported target match, missing-target failure, and overwrite-on-occupied-target behavior all align. Broader host lifecycle behavior remains deferred under INTP-013.
MODPROJ-015,project-compilation,Compile project as module set with deterministic ordering not concatenated source,partial,crates/oxvba-compiler/src/project.rs::compile_project,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01229,none,ProjectManifest compile entry now compiles deterministic module sets; backend lowering still uses normalized source flattening in current subset.
MODPROJ-016,name-resolution,Resolve project-qualified and module-qualified identifiers with precedence rules,partial,crates/oxvba-compiler/src/project.rs::compile_project_rewrites_module_qualified_calls_for_unique_names;crates/oxvba-compiler/src/project.rs::compile_project_rewrites_same_project_qualified_call,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0053,none,Module-qualified and same-project-qualified call targets are resolved in deterministic subset; full cross-project/reference bind coverage remains staged.
MODPROJ-017,visibility,Enforce Option Private Module accessibility across referencing projects,partial,crates/oxvba-host/src/engine.rs::formal_pmr_project_manifest_option_private_module_hides_host_exports,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01368,none,Option Private Module now gates host export visibility and is rejected for non-procedural module kinds; full cross-project runtime access parity remains deferred.
MODPROJ-018,visibility,Public variable names colliding with project or module names require module qualification,partial,crates/oxvba-host/src/project.rs::public_symbol_collisions_require_qualification,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0053,none,ProjectGraph public-symbol owner sets now report qualification-required outcomes; full variable-space binder parity remains pending.
MODPROJ-019,visibility,Public procedure names colliding with project or module names require explicit qualification,partial,crates/oxvba-compiler/src/project.rs::compile_project_rejects_ambiguous_duplicate_procedure_name_subset,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0106,none,Current project compile subset emits stable qualification-required diagnostics for duplicate public procedure owners.
MODPROJ-020,module-collision-rules,Detect module-level declaration collisions in declaration space,implemented,conformance/tests/declaration_collision_proc_name_error.bas,docs/evidence/language/COVERAGE_INDEX.csv,none,Current coverage is module-local only.
MODPROJ-021,module-const-enum,Module-level Const and Enum declarations,implemented,conformance/tests/module_const_basic.bas;conformance/tests/enum_basic.bas,docs/evidence/language/COVERAGE_INDEX.csv,none,Implemented in source-unit model; cross-project visibility semantics still pending.
MODPROJ-022,withevents-rules,Procedural module declaration lists cannot include WithEvents declarations,implemented,crates/oxvba-compiler/src/project.rs::compile_project_rejects_withevents_in_procedural_module,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0056,none,Project-aware compile semantics now enforce module-kind legality with PMR-E-WITHEVENTS-MODULE-KIND.
MODPROJ-023,withevents-rules,Event handler procedure names must use WithEvents prefix conventions,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0140,none,Requires class-module event-binding metadata.
MODPROJ-024,implements,Support Implements directive legality and interface coverage checks,implemented,crates/oxvba-compiler/src/project.rs::compile_project_rejects_implements_missing_member_coverage,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0097,none,Project-aware compile semantics now enforce module-kind legality, interface resolution, and member coverage for Implements.
MODPROJ-025,implements,Implemented method names must use Implements prefix semantics,partial,crates/oxvba-compiler/src/project.rs::compile_project_rejects_implements_missing_member_coverage,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0143,none,Prefix semantics are enforced through coverage checks for expected `<interface>_<member>` names; advanced edge cases (duplicates/multi-interface ambiguity) remain deferred.
MODPROJ-026,class-instancing,Honor class instancing/default-instance rules from class attributes,partial,crates/oxvba-host/src/project.rs::class_default_instance_flag_is_derived_from_attributes,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01266,none,ProjectGraph metadata derivation exists; full runtime activation and host projection remain pending.
MODPROJ-027,class-instancing,Restrict as-auto-object instancing mode per same-project rule,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0065,none,Requires project-aware type binding.
MODPROJ-028,class-lifecycle,Class_Initialize and Class_Terminate execution route,implemented,conformance/tests/class_lifecycle_resume_next_ok.bas,docs/evidence/language/COVERAGE_INDEX.csv,none,Implemented in deterministic subset without full project packaging.
MODPROJ-029,document-modules,Bind document module code-behind identity to host objects,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01237,hal-adjacent,Depends on host object model/HAL project catalog interfaces.
MODPROJ-030,form-modules,Form module lifecycle and userform integration,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01234,forms-deferred,Explicitly deferred for a later Forms phase.
MODPROJ-031,entrypoint-resolution,Project startup and entry-point selection semantics beyond single Sub Main conventions,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01229,none,Current CLI/host assumes single text source with Main-style entry.
MODPROJ-032,project-references,Project-level external reference and type-library binding model,partial,crates/oxvba-host/src/project.rs::type_library_resolution_binds_unique_importlib_entry;crates/oxvba-host/src/project.rs::type_library_resolution_requires_importlib_hint;crates/oxvba-host/src/project.rs::type_library_resolution_reports_ambiguous_importlib,../Foundation/reference/runs/20260301-ms-oaut-pass02/outputs/conformance_items.jsonl#CONF-discovered-ms-oaut-240423-b76f9b41-0561,hal-adjacent,Initial deterministic importlib resolution scaffold landed in ProjectGraph host model; full HAL-backed registration and oracle parity remain pending.
MODPROJ-033,project-references,Preserve OAUT GetIDsOfNames case-insensitive and Invoke packing obligations on reference-backed calls,partial,docs/evidence/language/COVERAGE_INDEX.csv (interop rows),../Foundation/reference/runs/20260301-ms-oaut-pass02/outputs/conformance_items.jsonl#CONF-discovered-ms-oaut-240423-b76f9b41-0599,hal-adjacent,Current dispatch bridge is deterministic subset; full obligations pending.
MODPROJ-034,conditional-compilation,Project-level conditional constants with module-local shadowing and consistency,partial,conformance/tests/conditional_compilation_basic.bas,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01203,none,Current support is local directive subset without project-wide constant source model.
MODPROJ-035,storage-roundtrip,MS-OVBA project/module/reference storage ingest and emit pipeline,planned,,../Foundation/reference/runs/20260301-ms-ovba-pass01/outputs/spec_items.jsonl#SPEC-ms-ovba-b39ac32f-0ce1-4533-9297-2ff3ff62c9ec-de6157f4-00005,none,Normative sections identified but section-level obligations are not yet extracted in Foundation run.
MODPROJ-036,storage-roundtrip,Close MS-OVBA extraction gap and map section 2 obligations to executable clauses,planned,,../Foundation/reference/runs/20260301-ms-ovba-pass01/outputs/run_manifest.json,source-gap,Current run has 0 conformance candidates; extraction quality must be raised before parity claims.
MODPROJ-037,circular-dependencies,Reject disallowed circular dependencies across modules for const enum udt implements event declarations,planned,,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01629,none,Needs project-level dependency graph analysis.
MODPROJ-038,event-semantics,RaiseEvent must occur in class modules and reference declared class events only,implemented,crates/oxvba-compiler/src/project.rs::compile_project_rejects_raiseevent_undeclared_event,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl#CONF-discovered-ms-vbal-250520-f945507e-0176,none,Project-aware compile semantics now enforce class-only RaiseEvent and declared-event binding with PMR-E-RAISEEVENT-MODULE-KIND and PMR-E-RAISEEVENT-UNDECLARED.
MODPROJ-039,host-exports,Host-facing export surface for public procedures in procedural modules (Excel-UDF-style discovery/invocation),partial,crates/oxvba-compiler/src/project.rs::compile_project_exports_public_procedures_including_option_private_modules_for_host_calls;crates/oxvba-host/src/project.rs::host_export_registry_exposes_public_procedural_entries,../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl#SPEC-discovered-ms-vbal-250520-f945507e-01239,hal-adjacent,Deterministic host-export discovery surface is implemented for procedural modules including Option Private members for host-direct invocation; reference-boundary visibility remains staged.
```

## Source: `OxVba/docs/IN_PROGRESS_FEATURE_WORKLIST.md`

# In-Progress Feature Worklist

Date: 2026-03-10  
Status: active  
Purpose: canonical repo-level register of feature areas that remain `in-progress` under the workset completion doctrine in `OPERATIONS.md`.

This file is the authoritative consolidation point for part-implemented feature work.

Latest execution pass:
1. `docs/IN_PROGRESS_FEATURE_EXECUTION_2026-03-10.md`

Latest note (2026-03-25): the COM activation truth review is now complete for the scoped target. `IP-03` remains closed for the native Windows late-bound `CreateObject("ProgID")` lane, and `IP-05` is closed again for the bounded early-bound/type-library target: user-scope file-backed typelib reference/import behavior, versioned/broken-reference behavior, the supported real registered `Scripting.Dictionary` `As New` + `Add` / `Exists` / `Count` subset, and the repaired external late-bound selector boundary are now reconciled under `docs/evidence/conformance/COM_ACTIVATION_BOUNDARY_RECONCILIATION_2026-03-25.md`. Broader arbitrary real-library COM breadth remains post-scope expansion work, while remaining external Office runtime-behavior verification and formal foldback continue under `IP-10` / `IP-11`.
Previous note (2026-03-20): **all six COM/host work areas are now closed**: `IP-03` (late-bound COM), `IP-05` (early-bound COM), `IP-06` (COM server at S0), `IP-07` (event runtime), `IP-08` (host/Office-style), `IP-09` (declare/marshaling). All implementation-owned blockers resolved: BLK-COM-IDISPATCH-001, BLK-COM-VALUE-TRANSPORT-001, BLK-EVT-002, BLK-HOST-001. Remaining external Office runtime-behavior verification and object-lifecycle parity are oracle concerns under `IP-10`; formal foldback remains under `IP-11`.
Previous note (2026-03-18): the active `IP-03A` late-bound COM transport subset now includes controlled `VT_R4` / `Single`, `VT_R8` / `Double`, and `VT_DATE` scalar and one-dimensional typed SAFEARRAY result lanes on a tagged semantic `f64` carrier that now also preserves outward `Single` and `Date` vartype fidelity plus controlled `VT_CY` / `Currency` scalar and one-dimensional typed SAFEARRAY result lanes on an exact scaled-`i64` currency carrier and controlled `VT_DECIMAL` scalar and one-dimensional typed SAFEARRAY result lanes on an exact `Decimal96` carrier; named-result host evidence for scalar `VT_BOOL`, `VT_BSTR`, `VT_EMPTY`, `VT_NULL`, and `VT_ERROR` plus outbound classifier evidence for scalar `VT_BOOL`, `VT_BSTR`, `VT_EMPTY`, `VT_NULL`, and `VT_ERROR` arguments are also in place; scalar `VT_I8` / `VT_UI4` / `VT_UI8` / `VT_UINT` values, one-dimensional typed `VT_ARRAY | VT_I8` / `VT_UI4` / `VT_UI8` / `VT_UINT` overflow, rank-2 `VT_ARRAY | VT_VARIANT` results, nested non-`IDispatch` `VT_UNKNOWN` elements inside one-dimensional `VT_ARRAY | VT_VARIANT` results, and scalar or typed-array `VT_BYREF` result payloads now fail with deterministic bounded diagnostics instead of silently wrapping or drifting through the current adapter surface; bounded invoke-failure evidence now also covers stable `DISP_E_MEMBERNOTFOUND` and `DISP_E_BADPARAMCOUNT` classification on the host fault surface plus stable `DISP_E_UNKNOWNNAME` classification both at the adapter boundary for raw `GetIDsOfNames` failures and on the host fault surface for runtime string member selectors, and the runtime-string subset now also has bounded success evidence for zero-arg method, named-argument method, zero-arg property-get, indexed property-get, named-argument indexed property-get, metadata-backed default-member-name dispatch, metadata-backed property put/property putref selectors, and metadata-backed indexed property put/property putref selectors; the native/property/default-member `IP-02` semantic model is now closed through [WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md](C:\Work\DnaCalc\OxVba\docs\worksets\WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md), while broader external `VARIANT`, non-`IDispatch` interface, and multi-dimensional SAFEARRAY parity remain `in-progress` under `IP-03`.
Update (2026-03-19, current pass): `IP-08A` now runs from [WORKSET_2026-03-19_IP-08A_EXECUTION_CHECKLIST.md](C:\Work\DnaCalc\OxVba\docs\worksets\WORKSET_2026-03-19_IP-08A_EXECUTION_CHECKLIST.md), and host-injected referenced class modules marked `VB_PredeclaredId` or `VB_GlobalNamespace` now participate in bounded implicit receiver lowering for property/default-member read lanes while plain project references still remain on the ordinary unresolved-name path.
Update (2026-03-19, later current pass): `IP-08B` now runs from [WORKSET_2026-03-19_IP-08B_EXECUTION_CHECKLIST.md](C:\Work\DnaCalc\OxVba\docs\worksets\WORKSET_2026-03-19_IP-08B_EXECUTION_CHECKLIST.md), and the first parity-breadth slice now has direct compiler and host evidence that host-injected object-valued root getters preserve `Variant` targets across explicit `Set`, explicit `Let`, and implicit assignment on both `VB_PredeclaredId` and `VB_GlobalNamespace` roots.
Update (2026-03-19, later current pass): the same bounded `IP-08B` host-root object-return matrix now also has direct compiler and host evidence for the parenthesized zero-arg neighbor, so `Set valueOut = Application.Value()`, `Let valueOut = Application.Value()`, and `valueOut = Application.Value()` now preserve the same `Variant` object-handle witness across both `VB_PredeclaredId` and `VB_GlobalNamespace` roots.
Update (2026-03-19, later current pass): the same bounded `IP-08B` host-root object-return matrix now also has direct compiler and host evidence for authoritative default-member assignment intent, so `Set valueOut = Application`, `Let valueOut = Application`, and `valueOut = Application` now preserve the same `Variant` object-handle witness across both `VB_PredeclaredId` and `VB_GlobalNamespace` roots.
Update (2026-03-19, later current pass): the same bounded `IP-08B` host-root object-return syntax register now also has direct compiler and host evidence for the parenthesized authoritative default-member neighbor, so `Set valueOut = Application()`, `Let valueOut = Application()`, and `valueOut = Application()` now preserve the same `Variant` object-handle witness across both `VB_PredeclaredId` and `VB_GlobalNamespace` roots.
Update (2026-03-20, current pass): the bounded `IP-08B` host/COM coexistence floor now also has direct compiler and host evidence for imported scalar read-assignment breadth on COM objects returned from host roots, so zero-arg property-get, parenthesized zero-arg property-get, and zero-arg method read assignments now execute with both implicit and explicit-`Let` syntax after `Set obj = Application.Value` across both host exposure modes.
Update (2026-03-20, current pass): the same bounded `IP-08B` host/COM coexistence floor now also has direct compiler and host evidence for imported named-argument read-assignment breadth on COM objects returned from host roots, so method, indexed-property-get, and authoritative default-member named-argument reads now execute with both implicit and explicit-`Let` syntax after `Set obj = Application.Value` across both host exposure modes.
Update (2026-03-20, current pass): the same bounded `IP-08B` host/COM coexistence floor now also has direct compiler and host evidence for imported positional read-assignment breadth on COM objects returned from host roots, so zero-arg method, positional method, positional property-get, and positional default-member reads now execute with both implicit and explicit-`Let` syntax after `Set obj = Application.Value` across both host exposure modes.
Update (2026-03-20, current pass): the same bounded `IP-08B` host/COM coexistence floor now also has direct compiler and host evidence for imported compile-time diagnostic parity on COM objects returned from host roots, so missing-member, wrong-method-arity, wrong-default-member-arity, and wrong-property-put-arity lanes now fail on the same stable typelib-backed diagnostics across both host exposure modes instead of drifting past the host-root rewrite.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that an active-project same-name `Application` class module outranks the host-injected root on the matching imported scalar, named-argument, and positional read-assignment lanes after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than root-handoff identity on the currently proved imported read subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported explicit-`Call` positional/default-member subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than `Call`-form root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported no-paren explicit-`Call` positional/default-member subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than no-paren `Call` root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported bare statement-context positional/default-member subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than statement-context root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported no-paren bare statement-context positional/default-member subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than no-paren statement-context root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported parenthesized named-argument explicit-`Call` subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than parenthesized named-argument `Call` root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported parenthesized named-argument bare statement-context subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than parenthesized named-argument statement-context root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported no-paren named-argument explicit-`Call` subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than no-paren named-argument `Call` root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-20, current pass): the same bounded host identity floor now also has direct compiler and host evidence that the active-project same-name `Application` class module outranks the host-injected root on the current imported no-paren named-argument bare statement-context subset after `Set obj = Application.Value`, so the remaining `IP-08B` root/global/project gap is narrower than no-paren named-argument statement-context root-handoff identity on the currently proved imported invoke subset.
Update (2026-03-19, later current pass): the bounded `IP-08A` host identity floor now also has direct compiler and host evidence that an active-project `Application` class module outranks a same-name host-injected `Application` root on the supported named-property write/read subset across both host exposure modes, completing the current host-vs-project-vs-COM identity register and moving the remaining `IP-08` gap to broader `IP-08B` parity breadth rather than missing foundation behavior.
Update (2026-03-19, later pass): the bounded `IP-08A` host-root read floor now has direct compiler and host evidence for both `VB_PredeclaredId` and `VB_GlobalNamespace` host-injected referenced class modules across named property-get and authoritative default-member read lanes.
Update (2026-03-19, later current pass): the bounded `IP-08A` host-root write floor now also has direct compiler and host evidence for `VB_PredeclaredId` named `Property Let` and authoritative default-member `Property Let` writes, with state read-back proving those writes execute on the host-injected root instance rather than drifting through the ordinary name path.
Update (2026-03-19, later current pass): the same bounded host-root write floor now also has direct compiler and host evidence for the matching `VB_GlobalNamespace` named `Property Let` and authoritative default-member `Property Let` writes.
Update (2026-03-19, later current pass): the bounded `IP-08A` host-root invoke floor now also has direct compiler and host evidence for explicit `Call` on `VB_PredeclaredId` named property-get and authoritative default-member zero-arg forms.
Update (2026-03-19, later current pass): the same bounded `IP-08A` invoke floor now also has direct compiler and host evidence for bare statement-context execution on `VB_PredeclaredId` named property-get and authoritative default-member zero-arg forms.
Update (2026-03-19, later current pass): the same bounded `IP-08A` invoke floor is now symmetric across exposure modes, with direct compiler and host evidence for explicit `Call` plus bare statement-context execution on `VB_GlobalNamespace` named property-get and authoritative default-member zero-arg forms.
Update (2026-03-19, later current pass): the bounded `IP-08A` host object-model floor now also has direct compiler and host evidence that named object-valued host-root `Property Get` members return live object handles across both `VB_PredeclaredId` and `VB_GlobalNamespace` when assigned through explicit `Set` into an `Object` target, while follow-on member traffic on those returned handles remains open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local follow-on named property-get traffic after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`, while broader child-object navigation/default-member traffic still remains open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local authoritative default-member read traffic after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`, while broader child-object invoke/write/default-member breadth still remains open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local explicit `Call` plus bare statement-context execution on named and authoritative default-member zero-arg getter forms after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`, while broader child-object write/indexed/parenthesized/default-member breadth still remains open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local named `Property Let` plus authoritative default-member `Property Let` traffic after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`, while broader child-object indexed/parenthesized/object-write/default-member breadth still remains open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local parenthesized zero-arg getter reads plus matching parenthesized explicit `Call` and bare statement-context execution on named and authoritative default-member forms after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`, while broader child-object indexed/object-write/default-member breadth still remains open.
Update (2026-03-19, later current pass): the bounded `IP-08A` host/COM coexistence floor now also has direct executable evidence for imported named-argument `Call` plus bare statement-context invocation subsets across both parenthesized and no-paren forms on host-returned COM-backed objects, and the same bounded host identity floor now also proves that a conflicting same-name plain-project `Application` reference does not steal those named-argument invoke neighbors by reference order.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct executable evidence for imported indexed `PropertyPut` plus indexed `PropertyPutRef` traffic across both positional and named-argument forms on host-returned COM-backed objects, and the same bounded host identity floor now also proves that a conflicting same-name plain-project `Application` reference does not steal those indexed setter neighbors by reference order.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local indexed getter reads, indexed explicit `Call`, indexed bare statement-context execution, and indexed `Property Let` traffic on named and authoritative default-member forms after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`, while broader child-object object-write/default-member breadth still remains open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host object-model floor now also has direct compiler and host evidence for typed child-local named and indexed `Property Set` plus authoritative default-member `Property Set` traffic after host-root object return across both `VB_PredeclaredId` and `VB_GlobalNamespace`; the remaining host-foundation gap is no longer child `Property Set` breadth, but host identity/session/callback substrate and invalid-root diagnostics.
Update (2026-03-19, later current pass): the bounded `IP-08A` root/global floor now also classifies invalid host-looking roots deterministically, with host-injected class modules that are present but not exposed through `VB_PredeclaredId=True` or `VB_GlobalNamespace=True` now failing across bounded read/write/`Call` forms on stable `PMR-E-HOST-ROOT-NOT-EXPOSED`; the remaining foundation gap is now host identity/session/callback substrate rather than root-name drift.
Update (2026-03-19, later current pass): the bounded `IP-08A` host-root read floor now also has direct compiler evidence that named property-get comparisons inside class procedures lower through the same host-root path across both `VB_PredeclaredId` and `VB_GlobalNamespace`, so `If Application.Value = 4 Then` no longer drifts into assignment-LHS parsing.
Update (2026-03-19, later current pass): the bounded `IP-08A` host runtime floor now also has direct host evidence that host-injected root state remains isolated per live runtime session across event ingress for both `VB_PredeclaredId` and `VB_GlobalNamespace`; the remaining foundation gap is now host object identity and host-backed callback routing rather than host-root session-state drift.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported object-valued zero-arg `PropertyGet` assignment-intent traffic on host-returned COM-backed objects, so `SelfDispatch` / `SelfUnknown` preserve explicit `Set` on `Object` targets plus implicit / explicit-`Let` assignment on `Variant` targets after `Set obj = Application.Value`, while broader host object identity boundaries still remain open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal that imported object-valued `PropertyGet` handoff by reference order, so the remaining host identity frontier is narrower than plain root-name precedence on the current imported object-property subset.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for parenthesized imported object-valued zero-arg `PropertyGet` assignment-intent traffic on host-returned COM-backed objects, so `SelfDispatch()` / `SelfUnknown()` now match the already-proved non-parenthesized subset after `Set obj = Application.Value` while broader host identity boundaries and wider imported breadth still remain open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported `RaiseException` `Call` plus bare statement forms on host-returned COM-backed objects, with the shared fallback adapter now surfacing the controlled `com-dispatch-exception-raised` fault instead of collapsing that lane into a silent success path.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal those imported `RaiseException` invoke forms by reference order, so the remaining host identity frontier is narrower than plain root-name precedence on the current imported exception subset too.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for assignment-form imported `PropertyPutRef` traffic on host-returned COM-backed objects, so `Set obj.SetValueRef = other` now executes on the shared object/value model after `Set obj = Application.Value` while the bounded getter witness remains the deterministic imported `obj.Value -> 5013` floor instead of a stronger unproved side-effect claim.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal that imported `PropertyPutRef` handoff by reference order, so the remaining host identity frontier is narrower than plain root-name precedence on the current imported setter subset too.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal imported property-put/get traffic on host-returned COM-backed objects by reference order, so `obj.SetValue = 9 : afterValue = obj.Value` now stays explicitly host-root-owned instead of relying on inference from adjacent lanes.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal imported authoritative default-member traffic on host-returned COM-backed objects by reference order, so `echoValue = obj(41)` now stays explicitly host-root-owned too.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal imported object-result rebinding on host-returned COM-backed objects by reference order, so `ReturnSelfDispatch()` / `ReturnSelfUnknown()` now stay explicitly host-root-owned across the bounded assignment-intent matrix too.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported zero-arg object-result assignment-intent traffic without parentheses on host-returned COM-backed objects, so `ReturnSelfDispatch` / `ReturnSelfUnknown` now match the already-proved parenthesized subset after `Set obj = Application.Value` while broader host identity boundaries and wider imported breadth still remain open.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal those imported zero-arg object-result lanes without parentheses by reference order, so that host-root ownership is now explicit on both the parenthesized and no-paren object-result neighbors.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported no-paren positional `Call` plus bare statement-context invocation subsets on host-returned COM-backed objects, so `Call obj.Count`, `Call obj.Exists 42`, `Call obj.Lookup 42`, `Call obj.Value`, `Call obj 42`, `obj.Exists 42`, `obj.Lookup 42`, and `obj 42` now execute after `Set obj = Application.Value` instead of remaining outside the proved host-returned imported surface.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal those imported no-paren positional `Call` and statement-context lanes by reference order, so host-root ownership is now explicit on that no-paren invoke subset too.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported parenthesized positional `Call` plus bare statement-context invocation subsets on host-returned COM-backed objects, so `Call obj.Count()`, `Call obj.Exists(42)`, `Call obj.Lookup(42)`, `Call obj.Value()`, `Call obj(42)`, `obj.Count()`, `obj.Exists(42)`, `obj.Lookup(42)`, `obj.Value()`, and `obj(42)` now execute after `Set obj = Application.Value` instead of remaining outside the proved host-returned imported invoke surface.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal those imported parenthesized positional `Call` and statement-context lanes by reference order, so host-root ownership is now explicit on that parenthesized invoke subset too.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host identity floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal parenthesized imported object-valued `PropertyGet` traffic on host-returned COM-backed objects by reference order, so `SelfDispatch()` / `SelfUnknown()` now stay explicitly host-root-owned on the current parenthesized subset too.
Update (2026-03-19, later current pass): the bounded `IP-08A` host callback floor now also has direct compiler evidence that `WithEvents` bindings sourced from host-injected referenced class types stay keyed to the referenced host project/module identity instead of collapsing into active-project event metadata.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host callback floor now also has direct host evidence that only the snapped host-backed source handle routes event ingress into the bound `WithEvents` sink while sibling handles of the same referenced host source type no-op deterministically, so the remaining foundation gap is now broader host object identity boundaries rather than missing live host-backed callback routing.
Update (2026-03-19, later current pass): the bounded `IP-08A` host identity floor now also has direct compiler and host evidence that conflicting plain-project class names do not steal `HostInjected` `WithEvents` source ownership by reference order; a host-backed `Emitter` source now stays keyed to `HostProject.Emitter` and `PlainProject.Emitter` remains non-routing for the same bound host-backed handle.
Update (2026-03-19, later current pass): the bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a neighboring `CreateObject("OxVba.TestDispatch")` handle does not perturb host-backed `WithEvents` ownership or route host event ingress; the bound host-backed source still owns the callback path while the COM-backed handle stays non-routing.
Update (2026-03-19, later current pass): the bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a host-injected root getter may return `CreateObject("OxVba.TestDispatch")` on the shared object/value model and feed that returned COM-backed object into `DispatchInvoke`, producing the deterministic bounded result path instead of drifting outside the host-root subset.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a host-injected root getter may return `CreateObject("OxVba.TestDispatch")` into a typed imported early-bound receiver and execute metadata-backed `Count()` member traffic on that returned object, so the supported host/COM handoff is no longer limited to raw `DispatchInvoke`.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence that a conflicting same-name plain-project `Application` reference does not steal that host-root imported `Count()` handoff by reference order, so the first imported host-root COM-return lane is now explicit on both the host-vs-plain-project and host-vs-COM sides.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported property-put plus zero-arg property-get traffic on the same host-returned `CreateObject("OxVba.TestDispatch")` object, so the supported host/COM handoff is no longer limited to one imported method-call shape.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler and host evidence for imported authoritative default-member call traffic on the same host-returned `CreateObject("OxVba.TestDispatch")` object, so the supported host/COM handoff now covers bounded imported method, property, and default-member call shapes instead of a single member family.
Update (2026-03-19, later current pass): the same bounded `IP-08A` host/COM coexistence floor now also has direct compiler, HAL, and host evidence for imported `VT_DISPATCH` / `VT_UNKNOWN` object-result assignment-intent traffic on the same host-returned `CreateObject("OxVba.TestDispatch")` object, so the supported host/COM handoff now preserves bounded object rebinding instead of collapsing all mixed-path imported members into scalar-only witnesses.

Update (2026-03-18, later pass): `IP-02A` now also has direct bounded evidence that ambiguous/missing source-resolution diagnostics apply to non-authoritative object-valued default-member reads under explicit `Let` and implicit assignment to typed `Object` targets across bare, zero-arg parenthesized, and indexed syntax.
Update (2026-03-18, current pass): `IP-02A` now also has direct bounded evidence that the same ambiguous/missing source-resolution diagnostics apply to typed `Variant` targets under explicit `Let` and implicit assignment across bare, zero-arg parenthesized, and indexed syntax.
Update (2026-03-18, later current pass): `IP-02A` now also has direct bounded evidence that scalar-typed native property/default-member getter results reject explicit `Set` across typed `Variant`, `Object`, and scalar targets for named, zero-arg parenthesized, indexed, authoritative default-member, and bounded single-candidate non-authoritative default-member syntax.
Update (2026-03-18, latest pass): `IP-02A` now also has direct bounded evidence that scalar-typed native property/default-member getter results support explicit `Let` and implicit assignment into typed `Variant` and scalar targets, while rejecting both forms on typed `Object` targets, across named, zero-arg parenthesized, indexed, authoritative default-member, and bounded single-candidate non-authoritative default-member syntax.
Update (2026-03-18, current pass): plain declared-`Variant` source variables now also have direct bounded runtime-validated assignment-intent evidence across the current `Variant` / `Object` / scalar target lanes for both scalar-payload and object-payload shapes, and the optimizer no longer collapses those post-typecheck lanes into semantically different constant-source assignments.
Update (2026-03-18, current pass): no-parentheses getter calls on the native PMR/default-member path now also have direct bounded compile-time rejection evidence in RHS read-assignment contexts across named, authoritative default-member, and single-visible-candidate non-authoritative default-member receivers under both explicit `Let` and implicit assignment.
Update (2026-03-18, current pass): plain `Object`-typed source variables now also have direct bounded assignment-intent evidence across the current `Object` / `Variant` / scalar target lanes for explicit `Set`, explicit `Let`, and implicit assignment.
Update (2026-03-18, current pass): plain scalar sources now also have direct bounded assignment-intent evidence across the current typed scalar / `Variant` / `Object` target lanes for explicit `Set`, explicit `Let`, and implicit assignment.
Update (2026-03-18, current pass): object-returning native property/default-member getter results now also have direct bounded scalar-target rejection evidence for explicit `Set` across named, zero-arg parenthesized, indexed, authoritative default-member, and landed single-visible-candidate non-authoritative default-member syntax.
Update (2026-03-18, current pass): ambiguous/missing non-authoritative object-valued default-member source-resolution diagnostics now also have direct bounded explicit-`Set` evidence on both typed `Object` and typed `Variant` targets across bare, zero-arg parenthesized, and indexed syntax.
Update (2026-03-18, current pass): the same ambiguous/missing explicit-`Set` source-resolution diagnostics now also have direct bounded scalar-target precedence evidence across bare, zero-arg parenthesized, and indexed syntax.
Update (2026-03-18, current pass): ambiguous/missing non-authoritative object-valued default-member source-resolution diagnostics now also have direct bounded scalar-target evidence for explicit `Let` and implicit assignment across bare, zero-arg parenthesized, and indexed syntax.
Update (2026-03-18, current pass): no-parentheses getter RHS read-assignment rejection now also has direct bounded compile-time evidence across typed `Variant`, `Object`, and scalar targets under explicit `Set`, explicit `Let`, and implicit assignment for named, authoritative default-member, and single-visible-candidate non-authoritative default-member receivers.
Update (2026-03-18, closure pass): the `IP-02` checklist audit found no remaining unclassified lane in the supported native/property/default-member `DG-03` scope, so `IP-02` is now closed. Remaining late-bound default-member parity continues under `IP-03`, and wider oracle/formal program obligations continue under `IP-10` / `IP-11`.
Update (2026-03-18, current pass): bounded invoke-failure evidence now also covers stable `DISP_E_PARAMNOTFOUND` classification on the host fault surface.
Update (2026-03-18, current pass): bounded non-`IDispatch` rejection evidence now also covers stable `E_NOINTERFACE` classification for `IUnknown::QueryInterface(IDispatch)` failures on the host fault surface.
Update (2026-03-18, current pass): bounded internal invoke-conversion failures now also classify stable carrier-overflow and unsupported-`VT_BYREF` return faults on the host surface instead of leaving those deterministic lanes in the generic unspecified bucket.
Update (2026-03-18, current pass): `IP-05A` now runs from [WORKSET_2026-03-18_IP-05A_EXECUTION_CHECKLIST.md](C:\Work\DnaCalc\OxVba\docs\worksets\WORKSET_2026-03-18_IP-05A_EXECUTION_CHECKLIST.md), and the supported external early-bound member-call rewrite path now resolves member tokens from `oxvba-com` synthetic typelib metadata instead of the compiler-local hardcoded external member-token table.
Update (2026-03-18, current pass): the supported external `As New` rewrite path now takes activation identity from `oxvba-com` metadata instead of the compiler-local hardcoded activation table.
Update (2026-03-18, current pass): the supported external early-bound call rewrite path now also enforces exact argument arity from synthetic typelib metadata, so wrong-arity imported-member calls fail deterministically at compile time instead of drifting into runtime dispatch faults.
Update (2026-03-18, current pass): the supported external early-bound rewrite path now also consults imported invoke-kind metadata, so required-argument `PropertyGet` members like `Lookup` have direct compiler+host evidence while imported `PropertyPut` / `PropertyPutRef` shapes fail deterministically at compile time on `BIND-E-TYPELIB-MEMBER-SHAPE-UNSUPPORTED`.
Update (2026-03-18, current pass): the supported external early-bound rewrite path now also consumes authoritative imported default-member identity for parenthesized call syntax, so `obj(42)` lowers through the metadata-backed `EchoVariant` lane while wrong default-member arity still fails deterministically at compile time.
Update (2026-03-18, current pass): the only remaining compiler-local member-token switch is now explicitly isolated to native/internal PMR dynamic-object routing, with direct compiler evidence that imported external early-bound lowering no longer depends on that local table.
Update (2026-03-18, current pass): imported member/default-member metadata lookup now distinguishes deterministic `not found` versus `ambiguous` compile-time failures, and imported default-member call syntax no longer falls through silently when authoritative metadata does not resolve a unique target.
Update (2026-03-18, current pass): supported imported early-bound bindings now carry their authoritative typelib metadata blob inside the compiler binding/lowering path, so imported member/default-member rewrite no longer re-resolves supported types from a side-channel string lookup at each call site.
Update (2026-03-18, current pass): `IP-05A` metadata authority is now the completed floor for the supported imported subset; the remaining `IP-05` gap is the broader `IP-05B` parity matrix, richer typelib coverage, and wider Office/Excel object-model behavior rather than lingering authority ownership ambiguity.
Update (2026-03-18, current pass): the controlled imported early-bound subset now also lowers named and indexed `PropertyPut` assignment syntax through authoritative metadata, so `obj.SetValue = 9` and `obj.SetIndexedValue(7) = 11` execute end to end via deterministic `DispatchInvoke` setter lanes while imported `PropertyPutRef` assignment syntax and setter arity drift still fail deterministically at compile time in the current subset.
Update (2026-03-18, current pass): the same controlled imported setter subset now also has direct compiler + host evidence for named-argument indexed `PropertyPut` assignment syntax, so `obj.SetIndexedValue(lhs := 7) = 11` preserves metadata-backed parameter naming while the neighboring named-argument indexed `PropertyPutRef` assignment shape still fails deterministically at compile time.
Update (2026-03-18, current pass): the controlled imported setter subset now also has direct compiler + host evidence for explicit-`Set` `PropertyPutRef` assignment syntax, so `Set obj.SetValueRef = other`, `Set obj.SetIndexedValueRef(8) = other`, and `Set obj.SetIndexedValueRef(lhs := 8) = other` now execute through the metadata-backed imported setter path with bounded deterministic object-valued RHS handling.
Update (2026-03-18, current pass): the controlled imported early-bound subset now also lowers direct zero-arg `PropertyGet` read-assignment syntax through authoritative metadata, so `x = obj.Value` and `Let x = obj.Value` execute end to end instead of remaining outside the imported parenthesized-call subset.
Update (2026-03-18, current pass): the same imported zero-arg getter subset now also has direct compiler + host evidence for parenthesized read-assignment syntax, so `x = obj.Value()` and `Let x = obj.Value()` preserve the same metadata-backed `PropertyGet` lowering in the current subset.
Update (2026-03-19, current pass): the imported zero-arg getter subset now also includes controlled object-valued `PropertyGet` members, and direct plus parenthesized read-assignment syntax for `SelfDispatch` and `SelfUnknown` now has direct compiler + host assignment-intent evidence across explicit `Set` on typed `Object` targets plus implicit and explicit-`Let` assignment on `Variant` targets for both `VT_DISPATCH` and `VT_UNKNOWN` result carriers.
Update (2026-03-18, current pass): the controlled imported early-bound call subset now also has direct object-result evidence, so imported `VT_DISPATCH` and `VT_UNKNOWN` member results from `ReturnSelfDispatch()` and `ReturnSelfUnknown()` rebind into invokable object handles on both typed `Object` and `Variant` targets.
Update (2026-03-18, current pass): the controlled imported early-bound call subset now also has direct named-argument evidence, so imported method, indexed `PropertyGet`, and authoritative default-member calls preserve metadata-backed named-argument canonicalization for `SumPair`, `LookupPair`, and `obj(value := 41)`.
Update (2026-03-18, current pass): the same imported named-argument call subset now also has direct explicit-`Let` evidence, so `Let sumPair = obj.SumPair(...)`, `Let lookupPair = obj.LookupPair(...)`, and `Let echoValue = obj(value := 41)` preserve the same metadata-backed lowering and canonicalization in the current subset.
Update (2026-03-19, current pass): explicit `Let` evidence on the controlled imported call subset now also covers positional zero-arg method, positional method, positional `PropertyGet`, and positional authoritative default-member calls, so `Let countValue = obj.Count()`, `Let existsValue = obj.Exists(42)`, `Let lookupValue = obj.Lookup(42)`, and `Let echoValue = obj(42)` now have direct compiler + host proof instead of remaining an implied neighbor of the named-argument subset.
Update (2026-03-19, current pass): the same controlled imported call subset now also has direct `Call`-statement evidence across both positional and named-argument syntax, so `Call obj.Count()`, `Call obj.Exists(42)`, `Call obj.Lookup(42)`, `Call obj.Value()`, `Call obj(42)`, `Call obj.SumPair(...)`, `Call obj.LookupPair(...)`, and `Call obj(value := 41)` now execute through the same metadata-backed method/property-get/default-member lowering instead of remaining only assignment-context behavior.
Update (2026-03-19, current pass): the same controlled imported call subset now also has direct bare statement-context evidence across both positional and named-argument syntax, so `obj.Count()`, `obj.Exists(42)`, `obj.Lookup(42)`, `obj.Value()`, `obj(42)`, `obj.SumPair(...)`, `obj.LookupPair(...)`, and `obj(value := 41)` now execute through the same metadata-backed method/property-get/default-member lowering without requiring explicit `Call`.
Update (2026-03-19, current pass): the same controlled imported call subset now also has direct no-parentheses `Call` and bare statement-context evidence across zero-arg, positional-argument, and named-argument syntax, so `Call obj.Count`, `Call obj.Exists 42`, `Call obj.Lookup 42`, `Call obj.Value`, `Call obj 42`, `Call obj.SumPair rhs := 14, lhs := 3`, `Call obj.LookupPair rhs := 9, lhs := 5`, `Call obj value := 41`, plus the matching bare statement forms, now execute through the same metadata-backed method/property-get/default-member lowering instead of depending on parenthesized syntax.
Update (2026-03-19, current pass): the controlled imported zero-arg read-assignment subset now also covers `Method` results in direct member syntax, so `x = obj.Ping`, `Let x = obj.Ping`, `Set child = obj.ReturnSelfDispatch`, `Set child = obj.ReturnSelfUnknown`, `wrapped = obj.ReturnSelfDispatch`, and `Let wrapped = obj.ReturnSelfUnknown` now lower through the same metadata-backed imported invoke path instead of restricting direct zero-arg read-assignment syntax to `PropertyGet` members only.
Update (2026-03-19, current pass): the imported zero-arg method statement subset now also has an observable runtime witness through `RaiseException`, so `Call obj.RaiseException()`, `obj.RaiseException()`, `Call obj.RaiseException`, and bare `obj.RaiseException` all execute through the same metadata-backed statement-form lowering and preserve bounded `DISP_E_EXCEPTION` / `EXCEPINFO` propagation instead of leaving bare zero-arg statement syntax as an unproved or falling-through neighbor.
Update (2026-03-19, current pass): imported default-member compile-time diagnostics now also have direct no-parentheses statement/`Call` evidence, so zero-arg `Call obj` / bare `obj` reject on `BIND-E-TYPELIB-INVOKE-ARITY-UNSUPPORTED` for `OxVba.TestDispatch`, while `Call obj 41` / bare `obj 41` reject on deterministic `BIND-E-TYPELIB-MEMBER-NOT-FOUND` and `BIND-E-TYPELIB-MEMBER-AMBIGUOUS` for the `NoDefault` and `AmbiguousDefault` fixture bindings instead of remaining implied by assignment-context tests.
Update (2026-03-19, current pass): the same imported default-member diagnostic matrix now also has direct parenthesized statement/`Call` evidence, so `Call obj()` / `obj()` reject on `BIND-E-TYPELIB-INVOKE-ARITY-UNSUPPORTED`, while `Call obj(41)` / `obj(41)` reject on deterministic `BIND-E-TYPELIB-MEMBER-NOT-FOUND` and `BIND-E-TYPELIB-MEMBER-AMBIGUOUS` for the `NoDefault` and `AmbiguousDefault` imported fixture bindings outside assignment contexts.
Update (2026-03-19, current pass): imported `WithEvents` declarations on referenced typelib COM classes now fail deterministically on `BIND-E-TYPELIB-WITHEVENTS-UNSUPPORTED` for both qualified and bounded unqualified imported type names, while local class-module sources still win cleanly when they shadow an imported type name, so the current `IP-05`/`IP-07` boundary is explicit without widening into true imported COM event subscription lowering.
Update (2026-03-19, current pass): unqualified imported typelib object declarations now also fail deterministically on `BIND-E-TYPELIB-UNQUALIFIED-TYPE-UNSUPPORTED` for `Dim obj As TestDispatch` and `Dim obj As New TestDispatch`, while local class declarations with the same type name still win through native source resolution, so the current metadata-backed early-bind floor remains explicitly qualifier-scoped instead of silently degrading outside the supported subset.
Update (2026-03-19, current pass): module-scope imported object declarations now also fail deterministically on `BIND-E-TYPELIB-MODULE-DECL-UNSUPPORTED` for both qualified and bounded unqualified imported type names, while local class-module declarations with the same type name still win through native source resolution, so the current imported declaration subset is now explicitly procedure-local instead of silently drifting through class-state/module-field parsing.
Update (2026-03-19, current pass): procedure signatures that use imported typelib object types now also fail deterministically on `BIND-E-TYPELIB-PROCEDURE-SIGNATURE-UNSUPPORTED` for both qualified and bounded unqualified imported type names in parameter and return positions, while local class-module types with the same name still win through native source resolution, so the current imported declaration floor no longer silently strips or lowers imported typed public API signatures as if they were supported.
Update (2026-03-19, current pass): imported `Implements` directives now also fail deterministically on `BIND-E-TYPELIB-IMPLEMENTS-UNSUPPORTED` for both qualified and bounded unqualified imported type names, while local class-module interfaces with the same name still win through native source resolution, so raw `Implements` lines can no longer disappear through class-module lowering without any imported-interface semantics.
Update (2026-03-19, current pass): imported event declarations now also fail deterministically on `BIND-E-TYPELIB-EVENT-DECL-UNSUPPORTED` for both qualified and bounded unqualified imported type names inside event parameter lists, while local class-module types with the same name still win through native source resolution, so the current imported event boundary no longer silently accepts typed `Event` public surfaces it cannot execute or expose honestly.
Update (2026-03-19, current pass): host-event ingress now also executes bound `WithEvents` handlers directly into a live project runtime session through source-instance-aware event guard wrappers, with deterministic stable ordering, bounded zero/one-argument forwarding, and explicit runtime diagnostics for missing handlers and unsupported higher arity, so the host/event path no longer stops at handler-symbol lookup in the current deterministic subset.
Update (2026-03-19, current pass): the imported object-result subset now also has direct assignment-intent evidence across both `VT_DISPATCH` and `VT_UNKNOWN` member results, so explicit `Set` on typed `Object` targets plus implicit and explicit-`Let` assignment on `Variant` targets now all preserve deterministic rebinding for `ReturnSelfDispatch()` and `ReturnSelfUnknown()` in the current controlled fixture.

Use it to answer:
1. what major behavior areas are still unfinished,
2. why they are still `in-progress`,
3. which workset/spec/register owns the remaining work,
4. what must be true before the area can be described as implemented/closed.

Do not use this file for:
1. immutable historical gate records,
2. line-by-line execution logging,
3. deferred formal lane row management,
4. detailed oracle capture inventories.

Those remain in:
1. `docs/IMPLEMENTATION_LOG.md`,
2. `docs/profile-status/`,
3. `docs/evidence/formal/DEFERRED_GATES.md`,
4. `docs/evidence/conformance/DEFERRED_ORACLE_GATES.csv`.

## Status vocabulary

- `in-progress`: partial implementation exists but parity for the scoped area is not complete.
- `blocked`: in-progress and currently constrained by an active blocker in `CURRENT_BLOCKERS.md`.
- `planned`: explicitly accepted area with no shipped parity slice yet.
- `closed`: scoped work area is complete for its defined target and the closure evidence is recorded.

## Feature register

| ID | Feature area | Status | Current floor | Remaining gap to close | Canonical owners |
|---|---|---|---|---|---|
| `IP-01` | Full VBA 7.1 language/runtime parity | in-progress | large executable language/runtime subset completed through historical ladders | full VBA 7.1 parity claim is still open at program level, including residual semantic, oracle, and matrix closure work | `docs/worksets/WORKSET_2026-03-08_VBA71_WINDOWS_OFFICE_FULL_COMPLIANCE.md` |
| `IP-02` | VBA property model and default-member semantics | closed | the native/property/default-member `DG-03` semantic model is now explicit and end to end executable across binder, compiler lowering, VM dynamic dispatch, authoritative native default-member identity, deterministic single-visible-candidate native fallback, deterministic ambiguous/missing fallback diagnostics, statement-context / `Call` / zero-arg parenthesized / indexed / no-parentheses-argument getter syntax in the supported native scope, and the complete `Set` / `Let` / implicit-assignment source-target matrix for plain scalar sources, plain `Object` sources, object-producing call results, declared-`Variant` sources with runtime payload validation, and scalar/object native property/default-member getter results; metadata-backed consumers that depend on this semantic model follow the same authoritative default-member identity contract | closed on 2026-03-18 for the scoped native/property/default-member target; remaining late-bound COM default-member recovery/parity continues under `IP-03`, and broader oracle/formal program closure remains under `IP-10` / `IP-11` | `docs/worksets/WORKSET_2026-03-08_VBA71_WINDOWS_OFFICE_FULL_COMPLIANCE.md`, `docs/worksets/WORKSET_2026-03-11_UNIFIED_DYNAMIC_OBJECT_PROTOCOL_AND_VALUE_CARRIER.md`, `docs/worksets/WORKSET_2026-03-14_COM_PARITY_PROPERTY_SERVER_HOSTING_EXECUTION_SEQUENCE.md`, `docs/worksets/WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md` |
| `IP-03` | Windows late-bound COM client (`IDispatch`) parity | closed | full semantic COM value carrier (`ComValue`) with I32, I64, F64(Single/Double/Date), Currency, Decimal96, Bool, String, ArrayIntent, ObjectHandle, Empty, Null, ErrorCode; multi-dimensional SAFEARRAY support (rank-N inbound and outbound); non-IDispatch VT_UNKNOWN deterministic E_NOINTERFACE rejection; named-arg default-member dispatch for non-metadata-backed bindings via runtime GetIDsOfNames passthrough; full EXCEPINFO surface (source, description, help_file, help_context, scode, wcode); HAL-DYN-008 IDispatch::Invoke output obligations verified; runtime-string member resolution across all member shapes (zero-arg/indexed/named method, property-put/putref, indexed property-put/putref, value/default-member name dispatch, unknown-name diagnostic); 59 late-bound end-to-end tests with VM/JIT parity | closed on 2026-03-20 for the scoped late-bound COM parity target; remaining external Office runtime-behavior verification is an oracle concern under `IP-10` | `docs/worksets/WORKSET_2026-03-10_IDISPATCH_LATEBOUND_COM_COMPLETION.md`, `docs/worksets/WORKSET_2026-03-11_UNIFIED_DYNAMIC_OBJECT_PROTOCOL_AND_VALUE_CARRIER.md`, `docs/spec/COM_CLIENT_SERVER_SCOPE_V1.md`, `docs/worksets/WORKSET_2026-03-20_COM_HOST_COMPLETION_CHECKLIST.md` |
| `IP-04` | `oxvba-com` architectural repurpose and HAL COM extraction | closed | `oxvba-com` now owns the live Windows COM client bridge through `WindowsComBridge`, including activation/binding, invoke planning/execution, invoke-result rebinding/lifecycle, event subscription/callback transport, and typelib/runtime metadata services; `oxvba-hal` now retains only capability/policy gating, apartment/bootstrap hooks, deterministic projection fallback, delegation, and boundary error mapping over that bridge | closed on 2026-03-14 for the architectural ownership target; downstream COM parity work remains in `IP-03`, `IP-05`, `IP-06`, and `IP-08` | `docs/worksets/WORKSET_2026-03-09_OXVBA_COM_REPURPOSE_AND_HAL_COM_EXTRACTION.md`, `docs/worksets/WORKSET_2026-03-14_IP04_OXVBA_COM_HAL_EXTRACTION_CLOSURE.md`, `docs/ARCHITECTURE.md` |
| `IP-05` | Windows early-bound COM and type-library parity | closed | metadata-authority path exists in `oxvba-com`; compiler/binder consume metadata for imported declarations; early-bound method/property/default-member/setter/object-result/exception/diagnostic lanes are well covered in the controlled subset; user-scope file-backed typelib reference/import behavior and versioned/broken-reference behavior are captured; a real registered `Scripting.Dictionary` anchor proves imported `As New` activation plus `Add` / `Exists` / `Count` on Windows; active docs now separate native late-bound parity from deterministic fallback/projection scaffolding | closed on 2026-03-25 for the bounded scoped early-bound/type-library target; broader arbitrary real-library COM breadth is post-scope and not part of this closure claim | `docs/spec/COM_EARLY_BINDING_TYPELIB_SCOPE_V1.md`, `docs/worksets/WORKSET_2026-03-18_IP-05A_EXECUTION_CHECKLIST.md`, `docs/worksets/WORKSET_2026-03-25_COM_ACTIVATION_TRUTH_REVIEW_AND_REPAIR.md`, `docs/evidence/conformance/COM_ACTIVATION_BOUNDARY_RECONCILIATION_2026-03-25.md` |
| `IP-06` | Windows COM server/export parity | closed | scope tiering S0..S3 defined; S0 (no outward COM server) is the scoped parity target for VBA 7.1 embedded-host behavior; VBA projects run inside hosts and do not publish their own typelibs or expose outward IDispatch; client-side IDispatch and event consumption fully covered by IP-03 and IP-07; host policy model explicit in HostPolicy/HostConfig; higher tiers (S1..S3 outward server) are tracked as future work outside this completion program | closed on 2026-03-20 at S0 tier for the VBA 7.1 embedded-host parity target | `docs/spec/COM_CLIENT_SERVER_SCOPE_V1.md`, `docs/worksets/WORKSET_2026-03-20_COM_HOST_COMPLETION_CHECKLIST.md` |
| `IP-07` | Event runtime parity (non-COM + COM adapter lanes) | closed | all 5 EPD design decisions resolved (EPD-01..05); WithEvents reassignment/clear transitions executable; runtime owner-iteration dispatch with deterministic sorted ordering; host-event ingress via canonical dispatch_host_event_into_runtime with source-instance-aware routing; COM-EVT-A connection-point subscription/unsubscription infrastructure proved; COM-EVT-B explicitly deferred per EPD-05; compile-time WithEvents/RaiseEvent legality proved; higher-arity rejection deterministic; remaining sink-instance graph lifetime parity is an oracle concern under IP-10 | closed on 2026-03-20 for the scoped event parity target | `docs/worksets/WORKSET_2026-03-08_EVENTS_PARITY_CLOSURE.md`, `docs/worksets/WORKSET_2026-03-20_IP-07_EPD_DESIGN_RESOLUTIONS.md`, `docs/worksets/WORKSET_2026-03-20_COM_HOST_COMPLETION_CHECKLIST.md` |
| `IP-08` | Host project / Office-style hosting parity | closed | IP-08A host foundation complete (all exit gates checked); IP-08B precedence matrix proved across assignment intent, invoke shape, and precedence rules on current COM/imported substrate (30+ commits); host root/global exposure across VB_PredeclaredId and VB_GlobalNamespace with read/write/Call/statement/object-return/indexed/setter lanes; host-returned COM-object matrix explicit for imported member/property/default-member/setter/object-result/exception lanes; active-project vs host-root and plain-project vs host-root precedence explicit across all proved imported shapes; PMR-E-HOST-ROOT-NOT-EXPOSED diagnostic; per-runtime host-root state isolation; host-backed WithEvents routing with snapped source handles; host/COM coexistence proved for raw DispatchInvoke and imported early-bound traffic | closed on 2026-03-20 for the scoped host/Office-style parity target; upstream IP-03 and IP-05 COM substrate is now wider | `docs/worksets/WORKSET_2026-03-19_IP-08A_EXECUTION_CHECKLIST.md`, `docs/worksets/WORKSET_2026-03-19_IP-08B_EXECUTION_CHECKLIST.md`, `docs/worksets/WORKSET_2026-03-20_COM_HOST_COMPLETION_CHECKLIST.md` |
| `IP-09` | Declare/native marshaling parity | closed | Lane A (declaration/resolver): implemented-verified for PtrSafe, alias, ordinal, unsupported forms; Lane B (VM/HAL dynamic-link): implemented with executable conformance probes; Lane C (marshaling): active with HAL-DYN-005/006/008 probes for I64 carrier, SafeArray multi-dim, semantic carrier fidelity; Lane D (platform/profile): Windows/Linux probes; HAL-DYN-008 (IDispatch::Invoke output obligations) implemented-verified; HAL-DYN-018 (pointer-string) and HAL-DYN-019 (ByRef writeback) formalized as deterministic-rejection with conformance probes; unsupported declaration forms rejected with deterministic diagnostics | closed on 2026-03-20 for the scoped declare/native parity target; remaining oracle/ABI breadth is under IP-10 | `docs/spec/HAL_DECLARE_MARSHAL_CONFORMANCE_V1.md`, `docs/spec/HAL_CONTRACT_CLAUSE_CATALOG_V1.md`, `docs/worksets/WORKSET_2026-03-20_COM_HOST_COMPLETION_CHECKLIST.md` |
| `IP-10` | Oracle/differential parity closure for required behavior areas | in-progress | deferred-oracle structure and topic tracking are in place; some targeted probes have been captured | required Office/host differential captures are not yet exhausted for open parity areas, so claim closure cannot rely only on local subset evidence | `docs/evidence/conformance/DEFERRED_ORACLE_GATES.csv`, `docs/worksets/WORKSET_2026-03-08_VBA71_WINDOWS_OFFICE_FULL_COMPLIANCE.md` |
| `IP-11` | Formal foldback for active parity claims | in-progress | formal infrastructure and many obligations exist; policy for non-blocking deferred lanes is defined | open deferred gates and failed/deferred formal lanes still require foldback or bounded resolution before full parity claims can close | `docs/evidence/formal/DEFERRED_GATES.md`, `docs/FORMAL.md` |

## Area notes

### `IP-01` Full VBA 7.1 language/runtime parity

Why still open:
1. the repo has many completed historical ladders, but the current governing claim is the full compliance program,
2. that program explicitly requires zero unresolved in-scope divergences, no open in-scope deferred gates, and a green Office differential matrix,
3. those terminal conditions are not met yet.

### `IP-02` VBA property model and default-member semantics

Closure summary:
1. the DG-03 native/property/default-member semantic model is now fully classified in [WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md](C:\Work\DnaCalc\OxVba\docs\worksets\WORKSET_2026-03-18_IP-02_EXECUTION_CHECKLIST.md),
2. no live IP-02 semantic blocker remains in [CURRENT_BLOCKERS.md](C:\Work\DnaCalc\OxVba\CURRENT_BLOCKERS.md),
3. remaining late-bound default-member recovery and non-metadata-backed COM behavior are owned by IP-03, not by IP-02,
4. remaining oracle and formal program gates stay under IP-10 / IP-11 and do not keep the scoped IP-02 native closure target open.

### `IP-03` Windows late-bound COM client parity

Closure summary (2026-03-20):
1. all implementation-owned late-bound COM parity lanes are closed for the scoped target,
2. I64 carrier, multi-dimensional SAFEARRAY, non-IDispatch policy, default-member passthrough, full ExcepInfo, runtime-string resolution are all proved with 59 end-to-end tests,
3. remaining external Office runtime-behavior verification is an oracle concern under `IP-10`,
4. `BLK-COM-IDISPATCH-001` and `BLK-COM-VALUE-TRANSPORT-001` are resolved.

### `IP-04` `oxvba-com` repurpose and HAL COM extraction

Closure summary:
1. `oxvba-com` now owns the live Windows COM client facade through `WindowsComBridge`.
2. `standard.rs` now delegates activation, invoke, object description/release, event subscription/callback interrogation, and typelib services through that facade.
3. The remaining HAL COM code is limited to capability/policy gating, apartment/bootstrap hooks, deterministic projection fallback, and error mapping.
4. `CURRENT_BLOCKERS.md` no longer carries `BLK-COM-BOUNDARY-001` as an active blocker.
5. Remaining COM behavior/parity work continues under `IP-03`, `IP-05`, `IP-06`, and `IP-08`; `IP-04` itself is closed.

### `IP-05` Windows early-bound COM and type-library parity

Closure summary (2026-03-25):
1. the bounded early-bound/type-library scope is now explicit and evidenced rather than implied,
2. user-scope file-backed typelib reference/import behavior and versioned/broken-reference behavior are captured on the real `TestEventServer` lane,
3. the supported real registered `Scripting.Dictionary` lane proves `As New` plus `Add` / `Exists` / `Count`,
4. the external late-bound selector boundary is repaired and no longer leaks deterministic `TestDispatch` tokens into real external COM `DispatchInvoke` traffic,
5. broader arbitrary real-library COM breadth remains post-scope and does not keep the scoped `IP-05` target open.

### `IP-06` Windows COM server/export parity

Closure summary (2026-03-20):
1. S0 tier (no outward COM server) is the scoped target for VBA 7.1 embedded-host parity,
2. VBA projects run inside hosts and do not publish their own typelibs or expose outward IDispatch,
3. client-side IDispatch (IP-03) and event consumption (IP-07) are the relevant parity surfaces,
4. higher tiers (S1..S3 outward server) are tracked as future work outside this completion program.

### `IP-07` Event runtime parity

Closure summary (2026-03-20):
1. all 5 EPD design decisions resolved and documented,
2. WithEvents reassignment/clear executable; runtime owner-iteration dispatch proved,
3. host-event ingress via canonical entrypoint with source-instance-aware routing; COM-EVT-A proved,
4. COM-EVT-B explicitly deferred per EPD-05; remaining object-lifecycle parity → IP-10 oracle.

### `IP-08` Host project / Office-style hosting parity

Closure summary (2026-03-20):
1. IP-08A foundation complete (all exit gates checked),
2. IP-08B precedence matrix proved across all invoke shapes on current COM/imported substrate,
3. upstream IP-03 and IP-05 COM substrate is now wider; no remaining bounded-breadth caveats.

### `IP-09` Declare/native marshaling parity

Closure summary (2026-03-20):
1. HAL-DYN-008 implemented-verified; pointer-string/ByRef formalized as deterministic-rejection,
2. Lane C marshaling conformance active with I64/SafeArray/semantic-carrier probes,
3. unsupported declaration forms deterministically rejected; remaining oracle/ABI breadth → IP-10.

### `IP-10` Oracle/differential parity closure

Why still open:
1. this is not a feature by itself, but it is required for parity closure of multiple features,
2. several implementation-defined or deferred-oracle topics remain open,
3. without oracle foldback the repo cannot honestly claim full VBA/Excel parity in those areas.

### `IP-11` Formal foldback for active parity claims

Why still open:
1. many formal lanes are historical and folded,
2. but open deferred/failing lanes still exist in the live register,
3. the full-compliance claim model requires these to be folded or explicitly bounded for in-scope parity claims.

## Operating rules

When any feature area above changes:
1. update this file,
2. update the owning workset/spec/register,
3. keep the status as `in-progress` until the scoped parity target is actually complete,
4. only remove an entry when its scope is truly parity-complete or when the scope is explicitly retired/replaced.

## Update checklist

1. Is the area still part of the active parity target?
2. Is there still any open blocker, deferred gate, oracle gap, or unimplemented parity behavior in scope?
3. If yes, keep the entry `in-progress`.
4. If no, update the owning docs first, then remove or mark the entry complete through an explicit documented decision.

## Source: `OxVba/docs/spec/BASPROJ_SPEC_V1.md`

# `.basproj` Project File Format Specification v1

Status: `normative-draft`
Date: 2026-03-23
Scope owner: OxVBA project system
Canonical path: `docs/spec/BASPROJ_SPEC_V1.md`
Supersedes: `oxvba.toml` format in `HOSTING_PROJECT_TOOLING_PROPOSAL.md` §4.1

Related docs:
- `docs/spec/HOSTING_PROJECT_TOOLING_PROPOSAL.md`
- `docs/spec/PROJECT_MODULE_REFERENCE_SPEC_V1.md`

---

## 1. Overview

The `.basproj` format is the canonical project file format for OxVBA projects. It uses MSBuild-compatible XML with SDK-style conventions:

- `<Project Sdk="...">` root element
- `<PropertyGroup>` for scalar properties
- `<ItemGroup>` for collections (modules, references, exports)
- `<Import>` for splitting content across files

The `Sdk` attribute (`OxVba.Sdk/0.1.0`) identifies the OxVBA SDK version and provides implicit defaults, analogous to `Microsoft.NET.Sdk` for .NET projects.

---

## 2. XML Schema

### 2.1 Root Element

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <!-- PropertyGroup and ItemGroup elements -->
</Project>
```

The `Sdk` attribute is required. Format: `OxVba.Sdk/<semver>`. The parser validates the SDK name prefix and extracts the version for compatibility checking.

### 2.2 PropertyGroup — Project Properties

All properties are optional unless noted. A project may contain multiple `<PropertyGroup>` elements; properties are merged in document order (last wins for duplicates).

| Property | Type | Values | Default | Required | Purpose |
|----------|------|--------|---------|----------|---------|
| `OutputType` | enum | `HostModule`, `Library`, `Exe`, `Addin`, `ComServer`, `ComExe` | — | **yes** | What the project produces |
| `ProjectName` | identifier | any valid VBA identifier | directory name | no | Maps to `ProjectManifest.project_name` |
| `EntryPoint` | string | `Module.Procedure` | — | for Exe/Addin | Explicit startup procedure override for execution |
| `RuntimeFlavor` | enum | `Lite`, `Jit` | `Lite` | no | VM-only vs VM+JIT |
| `DefaultRuntimeProfile` | string | profile identifier | `windows-headless` | no | Default HAL runtime profile |
| `DefaultPolicyPreset` | string | preset identifier | `deterministic-runtime` | no | Default host policy preset |
| `DefaultRootObject` | string | identifier | `Application` | no | Host-injected root object name |
| `DefineConstants` | string | `KEY=VAL;KEY2=VAL2` | — | no | Conditional compilation constants |

**OutputType semantics:**

| OutputType | ProjectKind | Produces | Entry point |
|-----------|------------|---------|------------|
| `HostModule` | `Host` | `.oxb` bundle | not required |
| `Library` | `Library` | `.dll`/`.so` with native exports | not required |
| `Exe` | `Source` | native executable | required via explicit `EntryPoint`, unique top-level mainline, or unique `Sub Main` |
| `Addin` | `Library` | XLL/add-in DLL | required |
| `ComServer` | `Library` | in-process COM DLL (`.dll`) | not required (uses creatable classes) |
| `ComExe` | `Library` | out-of-process COM EXE (`.exe`) | not required (uses creatable classes) |

**OxVBA extension note:** top-level executable statements are an OxVBA hosting/project extension, not an Office-VBA parity claim. In `.basproj` program-style execution, a module containing top-level executable statements may supply the startup mainline when no explicit `EntryPoint` is configured.

**DefineConstants format:** Semicolon-separated `KEY=VALUE` pairs. Values are parsed as `i32`. Keys without `=VALUE` default to `1`. Example: `VBA7=1;WIN64=1;DEBUG` → `{VBA7: 1, WIN64: 1, DEBUG: 1}`.

### 2.3 ItemGroup — Module Items

#### 2.3.1 `<Module>` — Procedural Modules

```xml
<Module Include="Module1.bas" />
```

Maps to `ModuleUnit` with `ModuleKind::Procedural`. The `Include` attribute is a relative path to the `.bas` source file. The module name defaults to the filename stem (without extension) unless an `Attribute VB_Name` line in the source overrides it.

#### 2.3.2 `<ClassModule>` — Class Modules

```xml
<ClassModule Include="Calculator.cls">
  <VBPredeclaredId>True</VBPredeclaredId>
  <VBExposed>True</VBExposed>
  <VBGlobalNamespace>False</VBGlobalNamespace>
  <VBCreatable>True</VBCreatable>
</ClassModule>
```

Maps to `ModuleUnit` with `ModuleKind::Class`. All metadata elements are optional booleans (default: `False`).

| Metadata | Maps to | Default |
|----------|---------|---------|
| `VBPredeclaredId` | `ModuleAttributes.vb_predeclared_id` | `False` |
| `VBExposed` | `ModuleAttributes.vb_exposed` | `False` |
| `VBGlobalNamespace` | `ModuleAttributes.vb_global_namespace` | `False` |
| `VBCreatable` | `ModuleAttributes.vb_creatable` | `False` |

#### 2.3.2.1 ClassModule COM Metadata

When a project uses `OutputType=ComServer` or `OutputType=ComExe`, `<ClassModule>` items may include additional metadata elements for COM registration and type library generation:

```xml
<ClassModule Include="Calculator.cls">
  <VBExposed>True</VBExposed>
  <VBCreatable>True</VBCreatable>
  <Instancing>MultiUse</Instancing>
  <ProgId>MyCOMLib.Calculator</ProgId>
  <Description>A basic calculator object</Description>
</ClassModule>
```

**`Instancing`** — Controls how COM clients create instances of the class. Enum values follow the VB6 instancing model:

| Value | Behavior |
|-------|----------|
| `Private` | Not visible outside the project. Cannot be created by external clients. |
| `PublicNotCreatable` | Visible to external clients via the type library, but can only be instantiated internally and passed out. |
| `MultiUse` | Externally creatable. Multiple clients share a single server process (relevant for `ComExe`). |
| `GlobalMultiUse` | Like `MultiUse`, but members are accessible without explicit instantiation (global namespace injection). |
| `SingleUse` | Externally creatable. Each `CreateObject` / `CoCreateInstance` call launches a new server process (`ComExe` only). |
| `GlobalSingleUse` | Like `SingleUse`, but members are accessible without explicit instantiation (`ComExe` only). |

Default: `Private` when `VBCreatable=False`; `MultiUse` when `VBCreatable=True`.

**`ProgId`** — The programmatic identifier used for `CreateObject("ProgId")` calls. Default value is `ProjectName.ClassName` (e.g., `MyCOMLib.Calculator`). Must be unique within the system registry.

**`Description`** — Freeform help text emitted into the IDL/TLB for the class. Appears in object browsers and tooling.

#### 2.3.3 `<DocumentModule>` — Code-Behind Modules

```xml
<DocumentModule Include="Sheet1.cls">
  <HostDocumentType>Worksheet</HostDocumentType>
</DocumentModule>
```

Maps to `ModuleUnit` with `ModuleKind::Document`. The `HostDocumentType` metadata is informational and stored in module attributes for host consumption.

### 2.4 ItemGroup — Reference Items

Reference declaration order (top-to-bottom, across `<ItemGroup>` elements) determines resolution precedence, matching the existing `ProjectReference.precedence_index` field.

#### 2.4.1 `<ProjectReference>` — Project References

```xml
<ProjectReference Include="..\CoreLib\CoreLib.basproj" />
```

Maps to `ProjectReference` with `ReferenceKind::Project`. The `Include` path is resolved relative to the directory containing the `.basproj` file.

#### 2.4.2 `<COMReference>` — COM Type Library References

```xml
<COMReference Include="Excel">
  <Guid>{00020813-0000-0000-C000-000000000046}</Guid>
  <VersionMajor>1</VersionMajor>
  <VersionMinor>9</VersionMinor>
  <Lcid>0</Lcid>
  <ImportLib>excel.exe</ImportLib>
</COMReference>
```

Maps to `TypeLibraryCatalogEntry`:

| XML Element | Internal Field |
|------------|---------------|
| `Include` attribute | `library_name` |
| `Guid` | `libid` (as `Option<String>`) |
| `VersionMajor` | `major_version` (u16) |
| `VersionMinor` | `minor_version` (u16) |
| `Lcid` | `lcid` (as `Option<u32>`) |
| `ImportLib` | `importlib` (primary resolution key) |

Cross-platform behavior: COMReference items produce `ReferenceBindingState::Failed` on non-Windows unless the host provides portable type library metadata blobs.

#### 2.4.3 `<NativeReference>` — Native Library References

```xml
<NativeReference Include="hostbridge">
  <Path>build/hostbridge.dll</Path>
</NativeReference>
```

Feeds `ExternalCallDescriptor.library` for `Declare ... Lib "name"` resolution.

### 2.5 ItemGroup — Native Export Items

#### 2.5.1 `<NativeExport>` — Exported Functions

```xml
<NativeExport Include="CalcBlackScholes">
  <Module>PricingFunctions</Module>
  <Procedure>BlackScholes</Procedure>
  <CallingConvention>Stdcall</CallingConvention>
  <Ordinal>1</Ordinal>
</NativeExport>
```

| Metadata | Type | Required | Default |
|----------|------|----------|---------|
| `Module` | string | **yes** | — |
| `Procedure` | string | **yes** | — |
| `CallingConvention` | enum | no | `Stdcall` |
| `Ordinal` | u16 | no | none |

**CallingConvention values:** `Stdcall`, `Cdecl`.

**Add-in metadata** (optional, used for XLL add-in registration):

| Metadata | Type | Purpose |
|----------|------|---------|
| `Category` | string | XLL function category displayed in the Function Wizard |
| `Description` | string | Function description text shown in the Function Wizard |
| `ArgumentDescriptions` | string | Pipe-delimited descriptions for each argument, in parameter order |

Example with add-in metadata:

```xml
<NativeExport Include="CalcBlackScholes">
  <Module>PricingFunctions</Module>
  <Procedure>BlackScholes</Procedure>
  <CallingConvention>Stdcall</CallingConvention>
  <Category>Financial</Category>
  <Description>Calculates the Black-Scholes option price</Description>
  <ArgumentDescriptions>Spot price|Strike price|Time to expiry (years)|Risk-free rate|Volatility</ArgumentDescriptions>
</NativeExport>
```

These metadata elements are ignored for non-Addin output types.

**Validation rules:**
1. Referenced `Module.Procedure` must exist and be `Public`
2. Must be in a `Procedural` module (not class)
3. Exported names (`Include` attribute) must be unique
4. For `OutputType=Library`: at least one export should exist (warning)
5. For `OutputType=Exe`/`HostModule`: exports are ignored with a warning

### 2.6 `<Import>` — File Inclusion

```xml
<Import Project="NativeExports.items" />
```

Standard MSBuild `<Import>` mechanism. The imported file uses the same `<Project>` root with `<ItemGroup>` children. Path is resolved relative to the importing file's directory. Imported items are merged as if they appeared inline at the import point.

Optional existence check:
```xml
<Import Project="NativeExports.items" Condition="Exists('NativeExports.items')" />
```

---

## 3. Mapping to ProjectManifest

### 3.1 Property Mapping

| .basproj | ProjectManifest field |
|----------|----------------------|
| `ProjectName` | `project_name` (fallback: directory name) |
| `OutputType=HostModule` | `project_kind = ProjectKind::Host` |
| `OutputType=Library\|Addin\|ComServer\|ComExe` | `project_kind = ProjectKind::Library` |
| `OutputType=Exe` | `project_kind = ProjectKind::Source` |
| `DefineConstants` | `conditional_constants: BTreeMap<String, i32>` |

### 3.2 Module Mapping

| .basproj Item | ModuleKind |
|--------------|-----------|
| `<Module>` | `Procedural` |
| `<ClassModule>` | `Class` |
| `<DocumentModule>` | `Document` |

### 3.3 Reference Mapping

| .basproj Item | ReferenceKind |
|--------------|--------------|
| `<ProjectReference>` | `Project` |
| `<COMReference>` | `TypeLibrary` |

Host-injected references are not declared in `.basproj` — they are added at runtime by the host.

---

## 4. Auto-Discovery Convention

When a `.basproj` contains no `<Module>`, `<ClassModule>`, or `<DocumentModule>` items:

1. All `**/*.bas` files in the project directory (recursive) are treated as `<Module>` items
2. All `**/*.cls` files in the project directory (recursive) are treated as `<ClassModule>` items
3. Module names are derived from filename stems
4. For `OutputType=Exe`, startup resolution is: explicit `EntryPoint` if configured, else unique top-level mainline, else unique `Sub Main`
5. Ambiguous or missing startup resolution fails deterministically

When any explicit module item is present, auto-discovery is disabled entirely.

---

## 5. Complete Examples

### 5.1 Use Case A: Embedded in Rich Host (Excel-like)

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>HostModule</OutputType>
    <ProjectName>VBAProject</ProjectName>
    <DefaultRootObject>Application</DefaultRootObject>
    <DefineConstants>VBA7=1;WIN64=1</DefineConstants>
  </PropertyGroup>
  <ItemGroup>
    <Module Include="Module1.bas" />
    <ClassModule Include="Calculator.cls" />
    <DocumentModule Include="Sheet1.cls">
      <HostDocumentType>Worksheet</HostDocumentType>
    </DocumentModule>
    <DocumentModule Include="ThisWorkbook.cls">
      <HostDocumentType>Workbook</HostDocumentType>
    </DocumentModule>
  </ItemGroup>
  <ItemGroup>
    <COMReference Include="Excel">
      <Guid>{00020813-0000-0000-C000-000000000046}</Guid>
      <VersionMajor>1</VersionMajor>
      <VersionMinor>9</VersionMinor>
      <Lcid>0</Lcid>
      <ImportLib>excel.exe</ImportLib>
    </COMReference>
  </ItemGroup>
</Project>
```

### 5.2 Use Case B: C ABI DLL (XLL / Native Exports)

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>Library</OutputType>
    <ProjectName>FinanceAddIn</ProjectName>
    <RuntimeFlavor>Jit</RuntimeFlavor>
  </PropertyGroup>
  <ItemGroup>
    <Module Include="AddInSetup.bas" />
    <Module Include="PricingFunctions.bas" />
    <ClassModule Include="PricingEngine.cls">
      <VBExposed>True</VBExposed>
      <VBPredeclaredId>True</VBPredeclaredId>
    </ClassModule>
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\CoreMath\CoreMath.basproj" />
    <COMReference Include="Scripting">
      <Guid>{420B2830-E718-11CF-893D-00A0C9054228}</Guid>
      <VersionMajor>1</VersionMajor>
      <VersionMinor>0</VersionMinor>
      <Lcid>0</Lcid>
      <ImportLib>scrrun.dll</ImportLib>
    </COMReference>
  </ItemGroup>
  <ItemGroup>
    <NativeExport Include="CalcBlackScholes">
      <Module>PricingFunctions</Module>
      <Procedure>BlackScholes</Procedure>
      <CallingConvention>Stdcall</CallingConvention>
    </NativeExport>
    <NativeExport Include="xlAutoOpen">
      <Module>AddInSetup</Module>
      <Procedure>AutoOpen</Procedure>
      <CallingConvention>Stdcall</CallingConvention>
    </NativeExport>
  </ItemGroup>
</Project>
```

### 5.3 Use Case C: Standalone Executable

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <ProjectName>ReportGenerator</ProjectName>
    <EntryPoint>Main.Main</EntryPoint>
  </PropertyGroup>
  <ItemGroup>
    <Module Include="Main.bas" />
    <Module Include="FileProcessor.bas" />
    <ClassModule Include="Report.cls" />
  </ItemGroup>
  <ItemGroup>
    <COMReference Include="Scripting">
      <Guid>{420B2830-E718-11CF-893D-00A0C9054228}</Guid>
      <VersionMajor>1</VersionMajor>
      <VersionMinor>0</VersionMinor>
      <Lcid>0</Lcid>
      <ImportLib>scrrun.dll</ImportLib>
    </COMReference>
  </ItemGroup>
</Project>
```

### 5.4 Minimal Convention-Driven Project

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
  </PropertyGroup>
</Project>
```

Auto-discovers `**/*.bas` and `**/*.cls`. For `OutputType=Exe`, startup resolves by explicit `EntryPoint`, else unique top-level mainline, else unique `Sub Main`.

### 5.5 Separate Export File

`NativeExports.items`:
```xml
<Project>
  <ItemGroup>
    <NativeExport Include="CalcBlackScholes">
      <Module>PricingFunctions</Module>
      <Procedure>BlackScholes</Procedure>
      <CallingConvention>Stdcall</CallingConvention>
    </NativeExport>
  </ItemGroup>
</Project>
```

Referenced from `.basproj`:
```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>Library</OutputType>
  </PropertyGroup>
  <Import Project="NativeExports.items" />
</Project>
```

### 5.6 Use Case F: In-Process COM Server

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>ComServer</OutputType>
    <ProjectName>MyCOMLib</ProjectName>
  </PropertyGroup>
  <ItemGroup>
    <Module Include="Utilities.bas" />
    <ClassModule Include="Calculator.cls">
      <VBExposed>True</VBExposed>
      <VBCreatable>True</VBCreatable>
      <Instancing>MultiUse</Instancing>
      <ProgId>MyCOMLib.Calculator</ProgId>
      <Description>A basic calculator object</Description>
    </ClassModule>
    <ClassModule Include="Formatter.cls">
      <VBExposed>True</VBExposed>
      <VBCreatable>True</VBCreatable>
      <Instancing>MultiUse</Instancing>
      <Description>String formatting utilities</Description>
    </ClassModule>
  </ItemGroup>
</Project>
```

No `<NativeExport>` items are needed — the compiler generates `DllGetClassObject`, `DllCanUnloadNow`, `DllRegisterServer`, and `DllUnregisterServer` entry points automatically for `ComServer` projects. Class registration is driven by the `<ClassModule>` items with `VBCreatable=True`.

---

## 6. Schema Evolution

- The `Sdk` version attribute controls schema compatibility.
- Parsers MUST reject SDK versions with a major version they do not support.
- New optional properties/items may be added within a minor version.
- Removing or changing semantics of existing elements requires a major version bump.

## Source: `OxVba/docs/spec/COM_CLIENT_SERVER_SCOPE_V1.md`

# COM Client/Server Scope V1

Status: `working-draft`  
Date: 2026-03-04  
Primary scope: Windows (`HalProfileId::Windows`)  
Related ladders:
- `docs/worksets/PROFILE_LADDER_2026-03-04_MACH1000_V287_V306_COM_FORMAL_SCAFFOLD.md`
- `docs/worksets/PROFILE_LADDER_2026-03-04_MACH1000_V387_V406_COM_CLIENT_LATEBOUND_C2.md`

## 1. Objective

Define a formal, implementation-ready scope for OxVba COM support in two roles:

1. COM client: OxVba code calls external COM automation servers.
2. COM server: OxVba runtime exposes automation-visible objects to external COM hosts.

This scope follows `CHARTER.md` value ordering:

1. robustness
2. compatibility
3. performance

## 2. Normative Source Set

Canonical roots:

- `docs/FOUNDATION_SPEC_REFERENCE.md`
- `../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/`
- `../Foundation/reference/runs/20260301-ms-oaut-pass02/outputs/`
- `../Foundation/reference/runs/20260301-ms-dtyp-pass02/outputs/`

Primary anchor families already used in OxVba docs:

- MS-VBAL:
  - `CONF-discovered-ms-vbal-250520-f945507e-0325` (`CreateObject` signature family)
  - `CONF-discovered-ms-vbal-250520-f945507e-0091`, `...-0092`, `...-0093` (implementation-defined external declaration/selection controls)
  - `CONF-discovered-ms-vbal-250520-f945507e-0056`, `...-0097`, `...-0140`, `...-0143` (`WithEvents`/`Implements` class constraints)
- MS-OAUT:
  - `CONF-discovered-ms-oaut-240423-b76f9b41-0010`, `...-0011` (`VT_BYREF` legality)
  - `...-0023..0029` (`BSTR`, `IDispatch*`, `IUnknown*`, `VARIANT` compatibility)
  - `...-0042`, `...-0050..0052` (`SAFEARRAY` constraints)
  - `CONF-discovered-ms-oaut-210625-4fcc3347-0080..0084` (`IDispatch::Invoke` output obligations)
- MS-DTYP:
  - `CONF-discovered-ms-dtyp-241119-518a70cb-0002..0005`, `...-0007..0009` (pointer/string ABI requirements)

Source-quality note:

- Some extracted items remain `candidate` quality; parity claims must keep explicit deferred-oracle links until higher-confidence extraction and empirical foldback complete.

## 3. Design Decisions (V1)

### D1. Platform Support

- Windows: COM client+server are in scope.
- Linux/macOS/WASM/null: remain deterministic unsupported for COM operations in this series.

### D2. Boundary Ownership

- COM client behavior remains HAL-governed (`ComHal`, plus dynamic-link boundaries where required).
- COM server behavior is runtime/host-facing and is not modeled as a HAL capability for non-Windows profiles.
- Result: avoid forcing a cross-platform abstraction for a Windows-only ABI surface.

### D3. Apartment Model Policy

- Default policy for COM-enabled engine instances is STA-oriented execution.
- Initial implementation strategy: one dedicated COM thread per engine/runtime host process (or host-injected STA thread), explicit apartment initialization lifecycle, deterministic rejection for unsupported apartment policy modes.
- This is an OxVba implementation decision for compatibility/robustness; it is tracked as implementation-defined until empirical parity evidence closes.

### D4. Registration Strategy

- Two explicit lanes are required:
  - registration-free test lane (deterministic, CI-suitable),
  - registered ProgID/CLSID lane (host-realistic).
- Both lanes must share the same contract/error mapping semantics.

### D5. Error Surface

- Every COM boundary failure must map to deterministic OxVba diagnostics (`HalError` and VM/host error routes).
- No silent fallback from COM to projection mode for COM-enabled profiles once a call is routed to native COM lanes.

### D6. Activation Surface (C2 Direction)

- C1-compatible tokenized activation (`create_object(prog_id_token)`) remains valid.
- C2 introduces a semantic path for `CreateObject` with ProgID text in VBA source while preserving deterministic policy/failure handling.
- Current implemented C2 subset (`v397..v400`): known ProgID literal lowering for `"Scripting.Dictionary"` to tokenized activation floor.
- Server-name parameter forms are tracked as implementation-defined/deferred-oracle until host parity evidence is captured.

### D7. Member Resolution Surface (C2 Direction)

- C1-compatible tokenized member selection remains valid through the legacy scalar shim.
- Current widened contract is request/vector based (`dispatch_invoke_v2`) with variadic argument support.
- C2 requires deterministic member-name resolution (`GetIDsOfNames`) with explicit case policy and per-object cache semantics.
- Current implemented C2 subset (`v397..v400`): known member literal lowering (`"Count"`, `"Exists"`), plus per-object native DISPID caching for those lanes.
- Missing-member and ambiguous-resolution paths must produce stable failure diagnostics.

## 4. Capability and Maturity Tiers

### Client tiers

- `C0` (existing): deterministic token projection only.
- `C1`: native activation + scalar invoke (`CreateObject`, `GetIDsOfNames`, `Invoke` with scalar arguments).
- `C2`: late-bound client surface contract closure and subset implementation runway:
  - `CreateObject` ProgID-text path,
  - member-name invocation path,
  - deterministic `DISPPARAMS`/`ArgErr`/`ExcepInfo`/`VarResult` translation,
  - variadic `DispatchInvoke` argument packing for method/property-get/property-put/property-putref in the current integer-token subset.
- `C3`: array/object boundary subset (`SAFEARRAY`, interface pointers, richer variant coercion lanes).

### Server tiers

- `S0` (current): no native COM server behavior.
- `S1`: minimal Rust automation server scaffold (`IUnknown` + `IDispatch`) with deterministic echo/math methods.
- `S2`: OxVba host/server bridge exposing selected runtime entrypoints via COM dispatch.
- `S3`: class-module-aligned exposure model and host policy controls for surface publication.

## 5. Formal Contract Shape (Pre/Post Conditions)

### 5.1 Activation (`CreateObject`)

Preconditions:

- Windows profile active.
- COM activation policy enabled.
- Apartment initialized for COM lane.
- Activation selector is either:
  - tokenized selector (C1 floor), or
  - ProgID text selector (C2 path).

Postconditions:

- success: stable object handle token bound to valid COM identity.
- failure: deterministic error family with stable code, operation, and source metadata.

### 5.2 Dispatch invoke

Preconditions:

- object token resolves to a live COM object.
- member selector (token and/or name) resolves deterministically under declared case policy.
- argument pack contract satisfied.

Postconditions:

- success: return token value with explicit mapping contract.
- failure: deterministic translation of HRESULT/EXCEPINFO/ArgErr to OxVba diagnostics and `Err` model.

### 5.5 C2 Late-Bound Subset Contract

Required C2 semantics:

1. Name-based member invoke is stable and deterministic for a declared case policy.
2. `DISPPARAMS` argument-ordering and named-argument packing rules are explicitly documented for the supported subset.
3. `VarResult`, `ExcepInfo`, and `ArgErr` output channels are translated into deterministic OxVba diagnostics.
4. Unsupported argument shapes fail deterministically; no silent coercion/no-op paths.

### 5.3 Lifetime invariants

- object handles must preserve reference-lifetime safety:
  - no use-after-release,
  - no double-release,
  - deterministic cleanup at engine shutdown.

### 5.4 Server registration/exposure

Preconditions:

- host policy enables COM server publication.
- class/object metadata passes exposure checks.

Postconditions:

- COM clients can obtain and invoke exposed object contract for in-scope members.
- unsupported shape or policy denial fails deterministically before exposure.

## 6. Test Scaffolding Targets (Rust-first)

Required scaffolds in this series:

1. Small COM automation test servers in Rust (expandable method sets).
2. Small COM host/client harnesses in Rust to drive:
   - direct client calls,
   - server exposure calls,
   - roundtrip call paths through OxVba runtime.
3. Deterministic fixture corpus under `conformance/` for COM client/server lanes.

## 7. Out of Scope (This Series)

- DCOM/remoting semantics.
- Full type-library import/export parity.
- COM events/connection points full parity.
- Non-Windows COM emulation.

## 8. Deferred/Uncertain Topics

Track as implementation-defined or deferred-oracle topics:

1. Apartment/subthread interactions when host already owns COM initialization.
2. Exact named/optional argument packing parity for broad `Invoke` shapes.
3. Class-module exposure policy vs host-injected project/module metadata evolution.
4. Registration-free server loading constraints under varied CI environments.
5. `CreateObject` server-name semantics and cross-host policy differences.
6. exact named/optional argument parity for broad Office automation surfaces.

Tracking files:

- `docs/evidence/hal/HAL_IMPLEMENTATION_DEFINED.md`
- `docs/evidence/hal/HAL_UNCERTAINTY_REGISTER.md`
- `docs/evidence/conformance/DEFERRED_ORACLE_GATES.csv`

## 9. v387..v392 Spec-Closure Outputs

The `v387..v392` closure pass freezes C2 planning-level contracts and verification runway by updating:

- COM scope/conformance drafts (this file + companion conformance file),
- HAL COM bridge scope alignment,
- HAL clause catalog (`HAL-COM-005`, `HAL-COM-006`),
- implementation-defined and uncertainty registers for late-bound boundary behavior.

`v393` bridge-lock artifact:
- `docs/spec/COM_CLIENT_LATEBOUND_BRIDGE_V1.md`

## Source: `OxVba/docs/spec/HAL_RUNTIME_PROFILE_MATRIX_V1.md`

# HAL Runtime Profile Matrix V1

Status: `working-draft`  
Step: `v187`  
Date: 2026-03-02

## Objective

Define a single runtime taxonomy that separates:
- platform/runtime class identity,
- capability declaration,
- policy behavior.

This doc is the baseline for host runner configuration and conformance coverage.

## Terms

- Profile: semantic host class selected by runtime (`windows-gui`, `windows-headless`, `linux-stdio`, `wasm-wasi-local`, `wasm-browser-sandbox`, `null-floor`).
- Policy: execution permissions and determinism controls (`strict-ci`, `deterministic-runtime`, `deterministic-compile-time`, `interactive-dev`).
- Capability: HAL domain surfaced by descriptor.

## Profile Set (V1)

1. `windows-gui`
2. `windows-headless`
3. `linux-stdio`
4. `wasm-wasi-local`
5. `wasm-browser-sandbox`
6. `null-floor`

## Capability Matrix (V1 intent)

| Profile | UI | EventPump | FileSystemIo | ProcessEnv | COM | TimeLocale | DynamicLinking | Diagnostics |
|---|---|---|---|---|---|---|---|---|
| `windows-gui` | supported | supported | supported | supported | supported | supported | supported | supported |
| `windows-headless` | supported (virtualized/headless) | supported | supported | supported | supported | supported | supported | supported |
| `linux-stdio` | supported (stdio mode) | supported | supported | supported | unsupported | supported | supported | supported |
| `wasm-wasi-local` | supported (virtualized) | supported | unsupported | unsupported | unsupported | supported | unsupported | supported |
| `wasm-browser-sandbox` | unsupported | supported | unsupported | unsupported | unsupported | supported | unsupported | supported |
| `null-floor` | unsupported | unsupported | unsupported | unsupported | unsupported | supported | unsupported | supported |

## Policy Interaction

Policy is orthogonal to profile:
- profile answers "can this domain exist here?",
- policy answers "is it allowed this run, and deterministic or host-backed?".

Examples:
- `windows-gui + deterministic-runtime`: UI calls remain virtualized deterministic.
- `windows-gui + interactive-dev`: UI may use native host behavior.
- `linux-stdio + strict-ci`: prompts denied or deterministic fallback according to policy.

## Descriptor Requirements

Descriptor for each run must include:
- `profile` (runtime profile),
- `runtime_class` (host-native/wasi/browser-sandbox/null-floor),
- `contract_version`,
- `adapter_version`,
- per-capability support + maturity + spec anchor.

## Conformance Requirements

Every profile must run all lanes:
1. runtime
2. compile-time
3. interactive-dev

WASM profiles must include runtime-class specific rows.

## Open Items

- mapping existing `HalProfileId` enum values to the above profile set in host runner UX.
- whether `windows-gui` and `windows-headless` should be separate enum variants or runtime-class overlays.
- final naming lock belongs to host runner design step (`v195`).

## Source: `OxVba/docs/spec/HAL_SPEC_WORKING_DRAFT.md`

# HAL Specification Working Draft

Status: `working-draft`  
Date: 2026-03-01  
Scope owner: OxVba runtime/host

## 1. Objective

Define a deterministic Host Abstraction Layer (HAL) contract for OxVba so host-sensitive VBA/runtime features are:
- explicit by capability,
- policy-controlled,
- testable through a repeatable conformance suite,
- portable across `windows`, `linux`, `macos`, `wasm`, and `null` adapters.

This draft is implementation-linked (code exists) but still open for compatibility refinements.

Primary formal contract companion docs:
- [`HAL_CONTRACT_CLAUSE_CATALOG_V1.md`](HAL_CONTRACT_CLAUSE_CATALOG_V1.md)
- [`../evidence/hal/HAL_UNCERTAINTY_REGISTER.md`](../evidence/hal/HAL_UNCERTAINTY_REGISTER.md)
- [`../evidence/hal/HAL_IMPLEMENTATION_DEFINED.md`](../evidence/hal/HAL_IMPLEMENTATION_DEFINED.md)

Block-A expansion companion docs (`v187..v196`):
- [`HAL_RUNTIME_PROFILE_MATRIX_V1.md`](HAL_RUNTIME_PROFILE_MATRIX_V1.md)
- [`HAL_UI_INTERACTION_CONFORMANCE_V1.md`](HAL_UI_INTERACTION_CONFORMANCE_V1.md)
- [`HAL_DOEVENTS_CONFORMANCE_V1.md`](HAL_DOEVENTS_CONFORMANCE_V1.md)
- [`HAL_COM_BRIDGE_SCOPE_V1.md`](HAL_COM_BRIDGE_SCOPE_V1.md)
- [`HAL_DECLARE_ABI_SPEC_V1.md`](HAL_DECLARE_ABI_SPEC_V1.md)
- [`HAL_DECLARE_MARSHAL_CONFORMANCE_V1.md`](HAL_DECLARE_MARSHAL_CONFORMANCE_V1.md)
- [`HAL_FILESYSTEM_IO_CONFORMANCE_V1.md`](HAL_FILESYSTEM_IO_CONFORMANCE_V1.md)
- [`HAL_WASM_RUNTIME_CLASSES_V1.md`](HAL_WASM_RUNTIME_CLASSES_V1.md)
- [`HAL_TIME_SEMANTICS_V1.md`](HAL_TIME_SEMANTICS_V1.md)
- [`HOST_RUNNER_POLICY_BOOTSTRAP_V1.md`](HOST_RUNNER_POLICY_BOOTSTRAP_V1.md)
- [`HAL_CONFORMANCE_EXPANSION_PLAN_V196.md`](HAL_CONFORMANCE_EXPANSION_PLAN_V196.md)

Block-B/C implementation companion docs (`v197..v220`):
- [`HAL_RUNTIME_PROFILE_BOOTSTRAP_IMPLEMENTATION_V2.md`](HAL_RUNTIME_PROFILE_BOOTSTRAP_IMPLEMENTATION_V2.md)
- [`HAL_UI_PLATFORM_IMPLEMENTATION_V2.md`](HAL_UI_PLATFORM_IMPLEMENTATION_V2.md)
- [`HAL_DECLARE_EXECUTION_IMPLEMENTATION_V2.md`](HAL_DECLARE_EXECUTION_IMPLEMENTATION_V2.md)
- [`../evidence/hal/HAL_BLOCK_BCD_IMPLEMENTATION_2026-03-02.md`](../evidence/hal/HAL_BLOCK_BCD_IMPLEMENTATION_2026-03-02.md)

## 2. Normative Source Families

Primary external references are maintained in `../Foundation/reference`:
- MS-VBAL (language/runtime surface),
- MS-OAUT (automation data and dispatch contracts),
- MS-DTYP (supporting ABI types),
- MS-OVBA (project/module packaging context).

Crosswalk to extracted conformance candidate IDs is in [`HAL_SPEC_CROSSWALK.md`](HAL_SPEC_CROSSWALK.md).

## 3. Contract Surface

Implemented root trait: `HostServices`  
Code: `crates/oxvba-hal/src/traits.rs`

Domain subtraits:
- `UiInteractionHal`
- `EventPumpHal`
- `FileSystemHal`
- `ProcessEnvHal`
- `ComHal`
- `TimeLocaleHal`
- `DynamicLinkHal`
- `DiagnosticsHal`

Adapter factory:
- `crates/oxvba-hal/src/adapters/mod.rs` (`for_profile`, `for_profile_with_runtime_class`)

Implemented profile adapters:
- `windows`, `linux`, `macos`, `wasm`, `null`

Current implementation shape:
- `windows`/`linux`/`macos` use a shared contract core (`StandardHostServices`) with profile-specific descriptor/capability surfaces;
- `wasm` and `null` are dedicated adapters with explicit deterministic profile floors (no wrapper-only aliasing);
- in deterministic policy presets, behavior stays deterministic by contract;
- on host-matching Windows/Linux builds with non-deterministic policy presets (for example `interactive-dev`), selected domains use host-backed behavior paths.
- current factory construction instantiates `StandardHostServices` directly for Windows/Linux/macOS profiles.

## 4. Capability Model

Each adapter publishes a `HalDescriptor`:
- `profile`
- `runtime_class`
- `contract_version`
- `adapter_version`
- per-capability entries: `supported`, `maturity`, `spec_anchor`

Capability identifiers:
- `UiInteraction`
- `EventPump`
- `FileSystemIo`
- `ProcessEnv`
- `ComActivationDispatch`
- `TimeLocale`
- `DynamicLinking`
- `DiagnosticsTelemetry`

## 5. COM Scope Decision

Current decision:
- Windows profile declares and exercises `ComActivationDispatch`.
- Linux/macOS/WASM/Null explicitly declare COM capability unsupported.

This is intentional and test-covered. Non-Windows COM remains future scope, not implied by current adapter availability.

## 6. Unsupported Feature Policy

`HostPolicy.unsupported_feature_mode` supports two behaviors:

1. `CompileTime`:
- host-sensitive intrinsic requirements are preflighted in `oxvba-host` before execution.
- missing capability or explicit policy-deny rules fail with compile-phase diagnostics.

2. `Runtime`:
- execution is allowed to proceed.
- unsupported/policy-denied host operations fail deterministically at runtime.

Current compile-time preflighted intrinsic families:
- `Shell`, `Environ`, `Dir` -> `ProcessEnv`
- `Date`, `Time`, `Now`, `Timer` -> `TimeLocale`
- `FreeFile` -> `FileSystemIo`
- `MsgBox`, `InputBox` -> `UiInteraction`
- `DoEvents` -> `EventPump`
- `CreateObject`, `DispatchInvoke` -> `ComActivationDispatch`

Current COM callback/runtime note:
- `EventPumpHal::do_events()` is still the host/event-pump intrinsic surface.
- COM callback consumption now also has a payload-returning path via `ComHal::poll_event_callback()`.
- legacy callback-token interrogation methods remain temporarily present for compatibility with older VM/compiler scaffolding and should be treated as transitional.

Named preset table:
- [`HAL_POLICY_PRESETS.md`](HAL_POLICY_PRESETS.md) defines reproducible policy bundles:
  - `strict-ci`
  - `deterministic-runtime`
  - `deterministic-compile-time`
  - `interactive-dev`

Host-backed mode availability:
- `interactive-dev` can activate host-backed paths only when profile matches current OS build target:
  - Windows profile on Windows host build,
  - Linux profile on Linux host build.
- other profile/host combinations stay on deterministic fallback paths.

Policy bootstrap/orchestration note:
- deterministic bootstrap resolution is implemented in host runner (`CLI > ENV > config > defaults`) with deterministic startup fingerprinting.
- CLI integration is available through `oxvba-cli run` bootstrap flags.
- remaining governance questions for non-CLI embedding and long-term orchestration are tracked as `HAL-U-009` in [`../evidence/hal/HAL_UNCERTAINTY_REGISTER.md`](../evidence/hal/HAL_UNCERTAINTY_REGISTER.md).

Current host-backed domains (Windows/Linux host-matching mode):
- `FileSystemHal` (token-mapped temp-dir file backing for mutable open/seek growth),
- `ProcessEnvHal` (`shell` spawn probe, host env projection, directory enumeration probe),
- `TimeLocaleHal` (system-time derived tokens),
- `EventPumpHal` (`thread::yield_now`, with non-blocking Windows queue pump in `windows-gui` runtime class),
- `UiInteractionHal` (`windows-gui` native `MessageBoxW` lane; `linux-stdio` non-blocking prompt/response lane),
- `DynamicLinkHal` (known-symbol host-backed subset plus deterministic projection fallback),
- `DiagnosticsHal` (stderr emission side-effect while preserving token contract).

Current type-library note:
- The separate `TypeLibraryHal` trait/accessor has been removed from the public HAL surface.
- Typelib resolve/load/invalidate operations now live under `ComHal`, matching their actual ownership as COM bridge behavior.
- The stable typelib data shapes (`TypeLibResolveRequest`, `TypeLibResolvedIdentity`, `TypeLibMetadataBlob`, member/event metadata enums) and deterministic catalog/build logic now live in `oxvba-com` and are re-exported through HAL during transition.
- `StandardHostServices` still retains transitional typelib cache ownership while the deeper COM state/metadata extraction continues toward `oxvba-com`.

## 7. Deterministic Error Taxonomy

HAL stable codes (implemented in `crates/oxvba-hal/src/error.rs`):
- `HAL-E-CAP-UNAVAILABLE`
- `HAL-E-POLICY-DENIED`
- `HAL-E-ADAPTER-FAULT`
- `HAL-E-UNSUPPORTED-PROFILE`

Related implemented families outside the centralized HAL enum:
- `COM-E-*` string-prefixed adapter/host diagnostics for COM activation/dispatch/event lifecycle failures

VM propagation:
- host errors map to deterministic runtime error numbers (`53xxx`) with capability+kind encoding.
- if `On Error` handlers are active, control follows VBA error-routing behavior; otherwise execution fails with stable diagnostic detail.

## 8. Null HAL Contract

`null` adapter is a deterministic floor/oracle profile:
- unsupported capabilities must fail with `HAL-E-CAP-UNAVAILABLE`.
- selected pure deterministic capabilities remain available (`TimeLocale`, `DiagnosticsTelemetry` in current model).
- no silent no-op behavior for unsupported operations.

## 8.5 Wasm HAL Contract (v1)

`wasm` adapter in v1 is deterministic and sandbox-oriented, with explicit runtime classes:
- `wasi`:
  - `UiInteraction` remains supported under virtualization policy,
  - host integration capabilities (`FileSystemIo`, `ProcessEnv`, `ComActivationDispatch`, `DynamicLinking`) are unsupported.
- `browser-sandbox`:
  - `UiInteraction` is capability-unavailable by descriptor contract,
  - host integration capabilities remain unsupported.

Common v1 wasm guarantees:
- unsupported capabilities (`FileSystemIo`, `ProcessEnv`, `ComActivationDispatch`, `DynamicLinking`) fail with `HAL-E-CAP-UNAVAILABLE`;
- `UiInteraction` (when supported by runtime class) requires policy-enabled interaction plus virtualization (`ScriptedResponses`); `Disabled`/`FailOnPrompt` return deterministic policy denial;
- `EventPump`, `TimeLocale`, and `DiagnosticsTelemetry` remain available with deterministic token semantics.

## 9. Conformance Execution

Pre-engine conformance:
- `cargo test -p oxvba-hal`
- `scripts/run-hal-conformance.ps1`

In-engine integration checks:
- `oxvba-host` tests validate compile-time/runtime unsupported-mode behavior and host error surfacing.

Details: [`HAL_CONFORMANCE_SUITE.md`](HAL_CONFORMANCE_SUITE.md).

## 10. Current Spec Surprises / Gaps

1. Extracted candidate packs currently expose many host APIs as signature fragments (`may`) with limited normative behavioral detail.
2. Some key host-sensitive behaviors (e.g., `DoEvents` scheduling semantics) are not cleanly captured by current extraction runs and need dedicated review/extraction refinement.
3. Behavioral requirements for UI/process interactions are split across sources and host context; strict parity claims require empirical Office-based follow-up packs.
4. The current HAL surface still contains a COM-heavy `ComHal` seam that is a planned extraction target, so this draft describes current contract shape while that refactor is underway.

These are tracked as design-stage uncertainty, not blockers for deterministic HAL scaffolding.

## Source: `OxVba/docs/spec/HOSTING_PROJECT_TOOLING_PROPOSAL.md`

# OxVBA Hosting, Project, Packaging, and Tooling Proposal v2

Status: `design-draft`
Date: 2026-03-07
Scope owner: OxVBA runtime/host/tooling
Canonical path: `docs/spec/HOSTING_PROJECT_TOOLING_PROPOSAL.md`
Supersedes: `docs/spec/archive/HOSTING_PROJECT_TOOLING_PROPOSAL_V1.md`

Related docs:
- `docs/spec/VBP_SUBSET_AND_PROJECT_ARTIFACT_STRATEGY_DISCUSSION_V1.md`
- `docs/worksets/WORKSET_2026-03-05_VBP_SUBSET_AND_ARTIFACT_PLAN.md`
- `docs/worksets/WORKSET_2026-03-07_EVENTS_STORY_COMPLETION.md`
- `docs/worksets/WORKSET_2026-03-08_EVENTS_RUNTIME_HOST_PROJECT_HAL_SPLIT.md`
- `docs/worksets/WORKSET_2026-03-08_EVENTS_PARITY_CLOSURE.md`
- `docs/spec/PROJECT_MODULE_REFERENCE_SPEC_V1.md`
- `docs/spec/HAL_SPEC_WORKING_DRAFT.md`
- `docs/spec/CLASS_MODULE_COM_ALIGNMENT_PLAN_V1.md`
- `docs/spec/COM_CLIENT_SERVER_SCOPE_V1.md`
- `docs/spec/COM_EARLY_BINDING_TYPELIB_SCOPE_V1.md`

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Current Implementation Baseline](#2-current-implementation-baseline)
3. [Product Use Cases in Depth](#3-product-use-cases-in-depth)
   - 3.1 [UC-A: App-Embedded Hosting (PRIMARY)](#31-uc-a-app-embedded-hosting-primary)
   - 3.1.7 [Normative Integration Split: Host Project vs HAL vs COM](#317-normative-integration-split-host-project-vs-hal-vs-com)
   - 3.2 [UC-B: Add-in Authoring Outside Documents](#32-uc-b-add-in-authoring-outside-documents)
   - 3.3 [UC-C: General Runtime/Framework Tooling](#33-uc-c-general-runtimeframework-tooling)
   - 3.4 [UC-D: Top-Level Code Extension](#34-uc-d-top-level-code-extension)
   - 3.5 [UC-E: WebAssembly Hosting](#35-uc-e-webassembly-hosting)
4. [Cross-Cutting Design](#4-cross-cutting-design)
   - 4.1 [Project File Format: `.basproj`](#41-project-file-format-basproj-msbuild-compatible-xml)
   - 4.2 [Directory-as-Project Convention](#42-directory-as-project-convention)
   - 4.3 [`.vbp` Adapter](#43-vbp-adapter)
   - 4.4 [Artifact Format: `*.oxvbapkg` (A0)](#44-artifact-format-oxvbapkg-a0)
   - 4.5 [Build Targets: EXE and DLL](#45-build-targets-exe-and-dll)
   - 4.6 [Build Integration with External Systems](#46-build-integration-with-external-systems)
   - 4.7 [Event Model Closure](#47-event-model-closure)
   - 4.8 [Language Services](#48-language-services)
5. [Design Decision Register](#5-design-decision-register)
6. [Phased Execution Plan](#6-phased-execution-plan)
7. [Immediate Next Worksets](#7-immediate-next-worksets)

---

## 1. Executive Summary

OxVBA has reached a significant substrate maturity point. The COM early-binding/type-library ladder (`v466`) is closing. The core compiler, VM, JIT, and HAL policy infrastructure are stable. The project model (`ProjectManifest`/`ProjectGraph`) supports multi-module, multi-reference project execution. Host policy presets, runtime profile bootstrap, and platform abstraction across Windows/Linux/macOS/WASM are implemented and evidence-backed.

This document defines the next productization stage: turning that substrate into a coherent multi-surface product. It covers five product surfaces:

1. **App-embedded hosting** (primary) — OxVBA as a library in another process, like VBA in Excel.
2. **Add-in authoring** — VBA add-ins shipped outside documents, with XLL integration for Excel.
3. **General runtime/framework tooling** — modern CLI and project workflows for broad ecosystem adoption.
4. **Top-level code extension** — script-like VBA execution without explicit `Sub Main`.
5. **WebAssembly hosting** — controlled WASM execution with sandbox-first security.

This document is both a discussion paper and requirements source material. It proposes concrete defaults, enumerates decision points, defines phased execution, and includes example CLI help text and code snippets for the tools we will provide.

---

## 2. Current Implementation Baseline

This section grounds the reader in what exists today in the codebase, not what is planned.

### 2.1 Core execution and embedding surface

The `Engine` struct in `crates/oxvba-host/src/engine.rs` is the primary embedding entry point:

```rust
pub struct Engine {
    config: HostConfig,
    jit: JitEngine,
    root_objects: HashMap<String, String>,
    runtime_profile: RuntimeProfileId,
    host_services: Arc<dyn HostServices>,
}
```

Public API surface:

| Method | Purpose |
|--------|---------|
| `Engine::new(config)` | Create engine with `HostConfig` (JIT toggle, root object name) |
| `set_runtime_profile(profile)` | Set runtime profile (e.g., `WindowsHeadless`, `LinuxStdio`) |
| `set_host_policy(policy)` | Set full host policy |
| `set_host_policy_preset(preset)` | Set policy by preset name |
| `set_unsupported_feature_mode(mode)` | Configure unsupported feature handling |
| `register_root_object(name, type_name)` | Register a host-provided root object by name |
| `has_root_object(name)` | Check if root object is registered |
| `execute_source_with_snapshot_phased(source)` | Compile and run single source, return slot values + phase diagnostics |
| `execute_project_with_snapshot_phased(manifest)` | Compile and run a full project manifest |

The engine already runs as a library in-process with deterministic project-manifest execution. JIT compilation (Cranelift-based) is toggled via `HostConfig.enable_jit`.

### 2.2 Project model and graph

**`ProjectManifest`** (`crates/oxvba-compiler/src/project.rs`):

```rust
pub struct ProjectManifest {
    pub project_name: String,
    pub project_kind: ProjectKind,          // Source | Host | Library
    pub modules: Vec<ModuleUnit>,
    pub references: Vec<ProjectReference>,
    pub reference_projects: Vec<ReferencedProjectManifest>,
    pub conditional_constants: BTreeMap<String, i32>,
}

pub struct ModuleUnit {
    pub module_name: String,
    pub module_kind: ModuleKind,            // Procedural | Class | Document | Form | Extension
    pub attributes: ModuleAttributes,       // VB_Name, VB_Exposed, Option Private, etc.
    pub source: String,
}

pub struct ProjectReference {
    pub referenced_project_name: String,
    pub reference_kind: ReferenceKind,      // Project | TypeLibrary | HostInjected
}
```

**`ProjectGraph`** (`crates/oxvba-host/src/project.rs`) extends this with multi-project graphs, reference binding state (`Unbound`/`Bound`/`Failed`), type-library catalog entries, and public symbol resolution (local-first, then references).

`HostProcedureExport` records the project/module/procedure triples that a project exposes to the host for registration.

### 2.3 HAL profiles and host policy

Five HAL profiles are implemented:

| Profile | Runtime Classes |
|---------|----------------|
| Windows | `HostNative`, `WindowsGui`, `WindowsHeadless` |
| Linux   | `HostNative`, `LinuxStdio`, `LinuxHeadless` |
| macOS   | `HostNative`, `MacOsGui`, `MacOsHeadless` |
| WASM    | `WasmWasiLocal`, `WasmBrowserSandbox` |
| Null    | `NullFloor` (testing) |

The bootstrap resolver (`resolve_runner_bootstrap`) implements a priority chain: CLI flags > environment variables > config file > defaults. Four policy presets govern capability gating:

- `strict-ci` — all capabilities blocked, deterministic mode on, fail on unsupported.
- `deterministic-runtime` — selective capability allowance, runtime unsupported handling.
- `deterministic-compile-time` — compile-time rejection of unsupported features.
- `interactive-dev` — most features allowed for development.

Eight capability domains are tracked: `UiInteraction`, `EventPump`, `FileSystemIo`, `ProcessEnv`, `ComActivationDispatch`, `TimeLocale`, `DynamicLinking`, `DiagnosticsTelemetry`.

### 2.4 COM state

Late-bound COM client lanes and early-binding/type-library support through the terminal gate `v466` are complete and evidence-backed. Type-library reference binding records exist in the PMR/host layers. Non-Windows COM behavior remains deterministic-unsupported by policy and profile contract.

### 2.5 Event model status

**Compiler/binder (EVT1/EVT2 — completed 2026-03-07):**

- Removed deterministic gate diagnostics for `WithEvents`, `Implements`, and `RaiseEvent` from single-module resolve/compile paths.
- Added project-aware event diagnostics:
  - canonical source: `docs/evidence/diagnostics/PMR_EVENT_DIAGNOSTICS_V1.csv`
  - generated list: `docs/generated/PMR_EVENT_DIAGNOSTICS_SNIPPET.md`
- `WithEvents` module-kind legality, `Implements` interface existence + member coverage, `RaiseEvent` class-only + declared-event enforcement are all validated at compile time.

**Runtime (EVT3+ — baseline started 2026-03-08):**

- `compile_project(...)` now lowers `RaiseEvent` into deterministic handler call paths for known `WithEvents` bindings in the executable subset.
- Compiled projects now emit deterministic event dispatch bindings (`source project/module/event -> lowered handler symbol`) for host/runtime hydration.
- Host runtime owns a deterministic non-COM event dispatcher map with subscribe/unsubscribe/dispatch lookup API.
- Remaining runtime parity work: full sink-instance subscription graph parity, full callback argument-shape parity, and COM event adapter completion.
- `DIV-0003` baseline mismatch is closed; `DIV-0004` remains open for full sink-instance graph/subscription parity.

### 2.6 CLI posture

The current CLI supports a single command:

```
oxvba run <file.bas> [options]
```

Options: `--dump-slots`, `--dump-values`, `--dump-bootstrap`, `--jit`, `--config <path>`, `--profile <id>`, `--policy <preset>`, `--runtime-class <class>`, `--allow-interaction`, `--allow-process-spawn`, `--allow-filesystem-mutation`, `--allow-dynamic-link`, `--allow-com-activation`, `--deterministic-mode`, `--ui-virtualization`, `--unsupported-mode`, `--wasm-runtime-class`.

No project-level commands exist.

### 2.7 What does NOT exist yet

- `.vbp` parser or adapter
- `.basproj` project file format
- Compiled artifact format or packaging
- Wrapper EXE/DLL build commands
- Project-level CLI commands (`run-project`, `build`, `pack`, etc.)
- Full runtime event semantics (subscription graph, dispatch, host bridge)
- Language services (diagnostics API, symbol index, completion)
- XLL integration or Excel shim
- Top-level code support
- Directory-as-project discovery

---

## 3. Product Use Cases in Depth

### 3.1 UC-A: App-Embedded Hosting (PRIMARY)

#### 3.1.1 Motivation and scope

The primary use case for OxVBA is the app-embedded role: OxVBA runs as a library inside another process, exactly as VBA runs inside Excel, Access, or Word. The host application:

- manages the VBA project store (either through a host-managed IDE/editor or by embedding projects inside an application file format),
- controls the runtime policy, security boundaries, and capability grants,
- injects root objects (like `Application`) that VBA code navigates to interact with the host,
- routes events between host objects and VBA event handlers,
- consumes diagnostics and telemetry from the engine.

This is the model that the DNA Calc ecosystem targets. OxVBA must provide a stable, comprehensive host contract that embedded hosts can rely on without being coupled to OxVBA internals.

#### 3.1.2 Embedded host contract v1

**Host responsibilities:**

1. **Project store** — provide project source or compiled artifacts from host-controlled storage.
2. **Object model bridge** — provide root objects with stable identity, expose properties/methods/events.
3. **Event pump integration** — pump messages/events when VBA calls `DoEvents` or when the host raises events.
4. **Policy selection** — choose runtime profile, policy preset, and capability grants.
5. **Diagnostics sink** — consume compile-time and runtime diagnostics from the engine.

**OxVBA responsibilities:**

1. **Deterministic compilation/execution** — identical inputs produce identical outputs.
2. **Policy-aware capability gating** — refuse operations the host has not granted.
3. **Stable diagnostics** — error codes and messages with phase classification.
4. **Project graph and reference resolution** — multi-module, multi-reference, multi-project.
5. **Export inventory** — enumerate public procedures for host registration workflows.

**Proposed host bridge trait:**

```rust
/// Host-facing bridge contract for embedded OxVBA hosting.
pub trait OxvbaHostBridge {
    /// Load a project manifest from host-controlled storage.
    fn load_project(&self, id: &str) -> Result<ProjectManifest, HostError>;

    /// Load a compiled artifact from host-controlled storage.
    fn load_artifact(&self, id: &str) -> Result<Vec<u8>, HostError>;

    /// Resolve a root object by well-known name (e.g., "Application").
    /// Returns a token the engine uses for subsequent object operations.
    fn resolve_root_object(&self, name: &str) -> Result<HostObjectToken, HostError>;

    /// Subscribe to an event on a host-provided object.
    fn subscribe_event(
        &self,
        object: HostObjectToken,
        event_name: &str,
        handler: EventHandlerBinding,
    ) -> Result<SubscriptionId, HostError>;

    /// Unsubscribe from a previously subscribed event.
    fn unsubscribe_event(&self, subscription: SubscriptionId) -> Result<(), HostError>;

    /// Release a previously resolved host object token.
    fn release_object(&self, object: HostObjectToken) -> Result<(), HostError>;

    /// Invoke a method on a host-provided object.
    fn invoke_method(
        &self,
        object: HostObjectToken,
        method: &str,
        args: &[Variant],
    ) -> Result<Variant, HostError>;

    /// Get a property value from a host-provided object.
    fn get_property(
        &self,
        object: HostObjectToken,
        property: &str,
    ) -> Result<Variant, HostError>;

    /// Set a property value on a host-provided object.
    fn set_property(
        &self,
        object: HostObjectToken,
        property: &str,
        value: Variant,
    ) -> Result<(), HostError>;

    /// Receive a diagnostic from the engine.
    fn emit_diagnostic(&self, diagnostic: EngineDiagnostic);
}
```

**Contract lock (2026-03-09):**

1. The host bridge keeps a single `Variant` value boundary.
2. Object-valued property/method results cross the boundary as object-capable `Variant` values that carry host object identity.
3. The bridge does not add special-case APIs for collection/default-member behavior.
   - Host Project + runtime semantics remain the authority for deciding when VBA syntax implies default-member access.
   - The bridge exposes ordinary property/method operations only.
4. Host-to-engine event ingress is explicit and engine-owned:

```rust
impl Engine {
    pub fn dispatch_host_event(
        &mut self,
        subscription: SubscriptionId,
        args: &[Variant],
    ) -> Result<(), HostError>;
}
```

5. The bridge owns host object resolution/invocation/subscription/release, while the engine owns VBA semantic dispatch and event lifecycle behavior.

**Lifecycle sequence:**

```
1. Host creates Engine with HostConfig
2. Host configures runtime profile and host policy
3. Host registers root objects (Application, etc.)
4. Host loads project(s) from store -> ProjectManifest
5. Engine compiles project(s) -> CompiledProject
6. Engine validates exports, builds export inventory
7. Host registers exported functions (if applicable)
8. Engine executes entry point (Sub Main or configured entry)
9. During execution:
   - VBA accesses host objects -> bridge method/property calls
   - Host raises events -> engine dispatches to WithEvents handlers
   - VBA raises events -> engine dispatches to subscribers
   - Errors route through deterministic error model
10. Host requests shutdown -> engine runs Class_Terminate, releases objects
```

#### 3.1.3 Host object hookup and event routing

Host object event routing is a two-layer design:

**Layer 1: Host bridge contract (standardize now)**

The host declares which objects support which events. When the engine encounters a `WithEvents` declaration, it calls `subscribe_event` on the bridge. When the host wants to raise an event (e.g., a button was clicked), it invokes the engine's event dispatch entry point with the subscription ID and event arguments.

Example flow — a worksheet-like `Change` event:

```
Host side:                          Engine side:
                                    Dim WithEvents ws As Worksheet
                                    Set ws = Application.ActiveSheet
  <- subscribe_event(ws_token,      ->
     "Change", handler_binding)
  ...
  [user edits cell]
  -> dispatch_event(sub_id,         ->
     "Change", args)                   ws_Change(Target As Range)
                                       ' handler runs
  <- handler returns                <-
```

**Layer 2: VBA semantic layer (EVT3+ phases)**

The runtime subscription graph, handler dispatch ordering, reassignment behavior under `Set ws = Nothing` and `Set ws = other`, and `Class_Terminate` cleanup are VBA-semantic concerns that the engine handles internally. These are being closed through the events workset (WORKSET_2026-03-07), phases EVT3-EVT8.

**VBA code example:**

```vba
' In a class module
Private WithEvents btn As Button

Private Sub Class_Initialize()
    Set btn = Application.WorkPanel.Controls("btnCalculate")
End Sub

Private Sub btn_Click()
    Dim result As Double
    result = CDbl(Application.WorkPanel.Controls("txtInput").Value)
    Application.WorkPanel.Controls("lblOutput").Caption = "Result: " & CStr(result * 2)
End Sub
```

This code exercises: root object navigation (`Application`), child object access (`WorkPanel.Controls`), `WithEvents` subscription, event handler dispatch, and property get/set on host objects.

#### 3.1.4 Document scope vs process scope

When a workbook contains VBA, its public procedures are scoped to that document's context. When the same workbook is converted to an add-in:

- **Public functions become process-global**: registered for all documents in the host process.
- **Editing is blocked**: the project is read-only at runtime.
- **Function registration metadata** may include category tags, volatility flags, and argument descriptions for host integration (e.g., Excel's Function Wizard).

The scope model is represented as a first-class project attribute:

| Scope | Visibility | Editing | Use case |
|-------|-----------|---------|----------|
| `document` | exports visible only in owning document/project context | allowed | normal workbook VBA |
| `process` | exports registered globally in host process | typically blocked | add-ins |

**Collision policy for process-global registration:**

When multiple add-ins export procedures with the same name, the host must apply a deterministic collision policy. Recommended default: `fail` (reject the conflicting registration with a diagnostic). Alternatives: `shadow` (last-registered wins), `namespace-prefix` (prefix with project name).

#### 3.1.5 DNA VbCalc: full-exercise hosting pathfinder

> **Note on presentation format:** This section uses two tiers to distinguish what is normative for the OxVBA engine from what is application-level design:
> - **`[HOST-REQ]`** — what we require from the OxVBA hosting and interface contract. These are engine requirements.
> - **`[APP-IDEA]`** — initial ideas for making DNA VbCalc an interactive and useful environment. These are application-level choices, not engine requirements, and will be refined further.

**Purpose and philosophy**

DNA VbCalc is a purpose-built pathfinder host application designed to put us "in harm's way" for every aspect of the kind of hosting that Excel does to the VBA runtime. It is not a minimal stub — it is a full-exercise embedded host that validates every interaction surface between a host application and the OxVBA engine. It also serves as a useful interactive runner for trying out VBA code.

**Repository boundary note (2026-03-09):**

DNA VbCalc is expected to live in a separate future repository.

This OxVba repo carries:
1. the host/tooling contract,
2. the bridge semantics,
3. the preparatory baseline note:
   - `docs/DNAVBCALC_HOST_SHELL_BASELINE_PREPARATION_2026-03-09.md`

The actual DNA VbCalc implementation plan should be created in that future repository, not added to OxVba workset execution as if it were an in-repo implementation track.

The richer DNA VbCalc application ideas are intentionally moved into a separate preparation doc set so they do not interfere with OxVba workset planning:
1. `docs/DNAVBCALC_PREPARATION_INDEX_2026-03-09.md`
2. `docs/DNAVBCALC_HOST_SHELL_BASELINE_PREPARATION_2026-03-09.md`
3. `docs/DNAVBCALC_APPLICATION_IDEAS_PREPARATION_2026-03-09.md`

**Baseline lock (2026-03-09):**

For the future separate DNA VbCalc repository, the first baseline host shell is:
1. Tauri desktop shell,
2. Rust backend,
3. web UI frontend,
4. `.basproj` project open path at startup and via UI,
5. debug/immediate-style shell as the first user-facing interaction surface,
6. full reset + recompile on reload,
7. non-COM host-bridge path first.

This baseline is intentionally debug-centric and does not require a first-pass visual designer or rich control hierarchy.

**Normative host-contract implications** `[HOST-REQ]`

The DNA VbCalc pathfinder remains valuable here only insofar as it validates the host/tooling contract. The important in-repo requirements are:
1. host-managed project load from non-filesystem-controlled storage paths when needed,
2. root object injection and object model navigation through the hosting bridge,
3. explicit event subscription and host-to-engine event ingress,
4. diagnostics/error routing through the host contract,
5. deterministic reset/reload behavior for v1,
6. language services against host-managed source stores.

#### 3.1.6 Language services contract

Embedded hosts that provide a VBA IDE or editor need language services from the engine:

**Required capabilities:**

| Service | Description |
|---------|-------------|
| Parse diagnostics | Syntax errors with source locations |
| Bind diagnostics | Name resolution failures, type mismatches |
| Symbol index | All symbols in project with kind, type, scope, location |
| Completion | Context-aware completion lists at cursor position |
| Signature help | Parameter info for procedure calls |
| Go-to-definition | Navigate to symbol declaration |
| Find references | All usage sites for a symbol |
| Hover info | Type and documentation for symbol at position |

**Key constraint:** Language services MUST work against host-managed project stores, not only filesystem paths. The host provides source text to the engine; the engine returns service results with source-map positions. This is essential for hosts where VBA source lives inside a container format (like `.vbcalc` or an Office document).

**Transport decision:**

- **Option A (recommended first):** Direct Rust API — the engine exposes service methods that the host calls in-process. Lowest latency, simplest integration for Rust-based hosts.
- **Option B (follow-up):** LSP wrapper — an LSP server wrapping the Rust API for editor integration (VS Code, etc.). Higher compatibility with external editors, but adds IPC overhead.

Recommendation: implement direct Rust API first (for DNA VbCalc and other in-process hosts), then add LSP wrapper for broader editor ecosystem.

#### 3.1.7 Normative integration split: Host Project vs HAL vs COM

To avoid over-coupling the language model to COM, OxVBA adopts a three-plane contract:

1. **Host Project semantic plane (language-level, cross-platform)**
   - Defines host-visible symbols/types/events available to user projects.
   - Defines compile-time shape and name binding for host entities (including event signature/prefix rules).
   - Is the canonical semantic contract for both COM and non-COM hosts.

2. **HAL service plane (runtime capabilities, cross-platform)**
   - Hosts MUST provide the full HAL service suite contract (subject to selected runtime profile/policy):
     `FileSystemIo`, `TimeLocale`, `ProcessEnv`, `UiInteraction`, `EventPump`, `DiagnosticsTelemetry`, and related capability gates.
   - Host Project semantics do not replace HAL provisioning; they complement it.
   - Policy presets and capability denials remain enforced through HAL regardless of host object model style.

3. **Transport adapter plane (platform-specific)**
   - COM is a Windows transport adapter lane for object/event delivery (`IDispatch`, connection points, typelib binding).
   - Non-COM hosts use equivalent bridge transports while preserving the same Host Project semantic contract.
   - DNA VbCalc pathfinder is explicitly required to validate this contract cross-platform without COM dependency.
   - Object-valued returns and event ingress MUST still respect the host-bridge contract above (`Variant` value boundary + explicit `dispatch_host_event(...)`), even when COM is the underlying transport.

**Normative consequence:**
- Semantic compatibility claims for host-object/event behavior are anchored to the Host Project + runtime event engine.
- COM parity claims are scoped to adapter parity, not semantic ownership of the event model.
- Runtime event execution parity (`WithEvents` reassignment ordering, `RaiseEvent` dispatch lifecycle) remains tracked in EVT3-EVT8 and `DIV-0004`.

---

### 3.2 UC-B: Add-in Authoring Outside Documents

#### 3.2.1 Motivation

Beyond document-embedded VBA, a key scenario is authoring VBA add-ins that ship independently — not embedded in a workbook or document. These add-ins extend the host application with new functions, macros, and tools.

Two distribution models exist in the ecosystem:

- **Per-add-in runtime**: each add-in ships with its own OxVBA runtime payload. Like Excel-DNA for .NET add-ins.
- **Shared language host**: one OxVBA host process/add-in loads and manages many VBA projects. Like PyXLL or xlOil for Python in Excel.

#### 3.2.2 Model B1: per-project self-contained wrapper

Each VBA add-in project compiles into a self-contained XLL (for Excel) or DLL that embeds:

- the OxVBA runtime (lite or JIT flavor),
- the compiled project artifact,
- bootstrap and policy configuration.

The wrapper handles function registration, Application object bridging, and lifecycle management. The host application loads the XLL/DLL through its standard add-in mechanism.

**Advantages:** simple packaging, independent versioning, isolated failures.
**Disadvantages:** larger total footprint when many add-ins are loaded, duplicated runtime instances.

**Comparison with Excel-DNA:** Excel-DNA compiles .NET code into self-contained XLLs with an embedded .NET runtime. The OxVBA model is architecturally similar — an OxVBA runtime core embedded in each XLL.

#### 3.2.3 Model B2: shared language-host add-in

A single "OxVBA Language Host" add-in loads into the host process and manages multiple VBA projects:

- One runtime instance serves all loaded VBA projects.
- Projects are loaded/unloaded dynamically.
- Function registration is centralized through the language host.

**Advantages:** shared runtime footprint, centralized management, easier updates.
**Disadvantages:** shared failure domain, version compatibility across projects.

**Comparison with PyXLL / xlOil:** Both load a single Python runtime into Excel and host multiple Python-based add-in projects through a configuration file. The OxVBA B2 model follows this pattern.

#### 3.2.4 XLL-to-VBA shim mechanics

For Excel integration, the XLL shim performs these steps:

1. **`xlAutoOpen`**: called by Excel when the XLL loads.
   - Initialize OxVBA engine with host policy.
   - Load compiled project artifact.
   - Scan export inventory for public `Function` and `Sub` procedures.
   - Register each exported function with Excel via `xlfRegister`:
     - function name, argument types, category, help text.
   - Bridge the `Application` object from Excel to the VBA runtime.

2. **UDF invocation**: when Excel calls a registered function:
   - Excel passes arguments through the XLL C API.
   - The shim marshals arguments into VBA `Variant` values.
   - The engine executes the target function.
   - The shim marshals the return value back to Excel.

3. **`xlAutoClose`**: called when the XLL unloads.
   - Engine shutdown, object cleanup, unregistration.

**Explicit caveat:** The XLL UDF call path is structurally different from how native VBA UDFs are invoked by Excel. Native VBA functions are called through the VBA runtime's internal dispatch; XLL functions go through the C API shim. This means:

- Calling conventions differ (XLL uses `XLOPER`/`XLOPER12`; VBA uses `Variant`/`SAFEARRAY`).
- Error handling paths differ.
- Reentrancy rules differ.

This lane is for compatibility and ecosystem integration signal, not claim-equivalent execution semantics with native VBA.

#### 3.2.5 Recommended prototype sequence

1. **B1 first** — implement per-project self-contained XLL wrapper for simplest packaging and debugging.
2. **Collect data** — measure runtime footprint, function call overhead, and operational complexity.
3. **B2 follow-up** — implement shared language-host XLL if operational gains justify the complexity.

#### 3.2.6 Example commands and help text

```
oxvba build-wrapper-dll [PATH] --out <dll> [options]

Build an in-process COM DLL or XLL wrapper for a VBA project.

Options:
  --out <path>              Output DLL path (required)
  --com-sta                 Build as COM STA in-process server
  --xll                     Build as Excel XLL add-in
  --flavor <lite|jit>       Runtime flavor (default: lite)
  --scope <document|process> Export scope (default: document)
  --format <text|json>      Output format
```

---

### 3.3 UC-C: General Runtime/Framework Tooling

#### 3.3.1 Motivation

OxVBA should provide modern developer-friendly CLI tools for compiling and running VBA code — usable from any development environment (Rust, .NET, Python, Go, etc.). The tools should support both quick script-like execution and project-grade build/run workflows.

#### 3.3.2 CLI comparison with other runtimes

| Operation | `oxvba` | `dotnet` | `cargo` | `go` | `deno` | `python` |
|-----------|---------|----------|---------|------|--------|----------|
| Run file | `run <file>` | `dotnet script <f>` | — | `go run <f>` | `deno run <f>` | `python <f>` |
| Run project | `run-project [dir]` | `dotnet run` | `cargo run` | `go run .` | `deno task run` | — |
| Init project | `init [dir]` | `dotnet new` | `cargo init` | `go mod init` | `deno init` | — |
| Build | `build [dir]` | `dotnet build` | `cargo build` | `go build` | — | — |
| Pack artifact | `pack [dir]` | `dotnet pack` | `cargo package` | — | — | — |
| Run artifact | `run-artifact <pkg>` | `dotnet <dll>` | — | `./<binary>` | — | — |
| List exports | `ls-exports [dir]` | — | — | — | — | — |
| Import legacy | `import-vbp <vbp>` | — | — | — | — | — |
| Host check | `host-check [dir]` | — | — | — | — | — |

**Design principles drawn from the comparison:**
- `run` for single files (like `go run`, `deno run`, `python`).
- `run-project` for directory/project execution (like `dotnet run`, `cargo run`).
- `build` for compilation (universal pattern).
- `init` for project scaffolding (like `cargo init`, `dotnet new`).
- Explicit separation between source operations and artifact operations.

#### 3.3.3 Full command map with help text

```
oxvba run <file.bas> [options]

Run a single VBA source file directly.

Usage:
  oxvba run <file.bas> [options]

Options:
  --profile <id>            Runtime profile (windows-headless, linux-stdio, ...)
  --policy <preset>         Host policy preset (strict-ci, deterministic-runtime, ...)
  --jit                     Enable JIT compilation
  --no-jit                  Force VM-only execution
  --dump-slots              Output execution slot values
  --dump-values             Output semantic runtime values
  --dump-bootstrap          Emit resolved runtime/policy fingerprint
  --format <text|json>      Output format

Examples:
  oxvba run hello.bas
  oxvba run script.bas --profile windows-stdio
  oxvba run benchmark.bas --jit --dump-slots
  oxvba run benchmark.bas --jit --dump-values
```

```
oxvba run-project [PATH] [options]

Run an OxVBA project from .basproj or .vbp file.
If PATH is a directory, looks for a .basproj file in that directory.
If PATH is omitted, uses the current directory.

Usage:
  oxvba run-project [PATH] [options]

Options:
  --entry <Module.Proc>     Override configured entry point
  --profile <id>            Runtime profile
  --policy <preset>         Host policy preset
  --jit                     Enable JIT for this run
  --no-jit                  Force VM-only execution
  --dump-bootstrap          Emit resolved runtime/policy fingerprint
  --format <text|json>      Output format

Examples:
  oxvba run-project .
  oxvba run-project ./my-project --jit
  oxvba run-project legacy.vbp --entry Module1.Main
```

```
oxvba init [PATH] [options]

Initialize a new OxVBA project with .basproj and directory structure.

Usage:
  oxvba init [PATH] [options]

Options:
  --name <name>             Project name (default: directory name)
  --kind <kind>             Project kind: application, library, addin (default: application)
  --scope <scope>           Export scope: document, process (default: document)

Examples:
  oxvba init .
  oxvba init ./my-addin --kind addin --scope process
```

```
oxvba build [PATH] [options]

Compile a project and emit the configured build output.

Usage:
  oxvba build [PATH] [options]

Options:
  --target <target>         Build target: artifact, exe, dll (default: artifact)
  --flavor <lite|jit>       Runtime flavor for wrapper targets (default: lite)
  --out <path>              Output path
  --deterministic           Enable deterministic build mode
  --format <text|json>      Output format

Examples:
  oxvba build . --target artifact --out dist/myproject.oxvbapkg
  oxvba build . --target exe --flavor lite --out dist/myapp.exe
  oxvba build . --target dll --flavor lite --out dist/mylib.dll --com-sta
```

```
oxvba pack [PATH] --out <artifact> [options]

Compile a project into a versioned artifact package.

Usage:
  oxvba pack [PATH] --out <artifact> [options]

Options:
  --out <path>              Output artifact path (required)
  --flavor <lite|jit>       Compilation flavor (default: lite)
  --deterministic           Enable deterministic serialization
  --format <text|json>      Output format

Examples:
  oxvba pack . --out dist/finance.oxvbapkg
  oxvba pack . --out dist/finance.oxvbapkg --flavor jit --deterministic
```

```
oxvba run-artifact <artifact> [options]

Run a previously compiled OxVBA artifact package.

Usage:
  oxvba run-artifact <artifact> [options]

Options:
  --profile <id>            Runtime profile
  --policy <preset>         Host policy preset
  --jit                     Enable JIT for this run
  --no-jit                  Force VM-only execution
  --format <text|json>      Output format

Examples:
  oxvba run-artifact dist/finance.oxvbapkg --profile windows-headless
```

```
oxvba import-vbp <file.vbp> [options]

Import a VB6 .vbp project file into .basproj format.

Usage:
  oxvba import-vbp <file.vbp> [options]

Options:
  --out <path>              Output .basproj path (default: ./<ProjectName>.basproj)
  --strict                  Fail on unknown keys (default)
  --compat                  Warn on unknown keys instead of failing
  --format <text|json>      Output format

Examples:
  oxvba import-vbp legacy/Project1.vbp --out ./FinanceCalc.basproj
  oxvba import-vbp legacy/Project1.vbp --compat
```

```
oxvba ls-exports [PATH] [options]

List all public procedures exported by a project.

Usage:
  oxvba ls-exports [PATH] [options]

Options:
  --format <text|json>      Output format (default: text)

Output columns: Module, Procedure, Kind (Sub/Function), Scope (document/process)

Examples:
  oxvba ls-exports .
  oxvba ls-exports . --format json
```

```
oxvba ls-diagnostics [PATH] [options]

Compile a project and list all diagnostics without executing.

Usage:
  oxvba ls-diagnostics [PATH] [options]

Options:
  --phase <compile|all>     Filter by phase (default: all)
  --format <text|json>      Output format (default: text)

Examples:
  oxvba ls-diagnostics . --format json
```

```
oxvba host-check [PATH] [options]

Report the host capabilities and policy gates required by a project.

Usage:
  oxvba host-check [PATH] [options]

Options:
  --profile <id>            Check against specific runtime profile
  --policy <preset>         Check against specific policy preset
  --format <text|json>      Output format

Examples:
  oxvba host-check . --profile windows-headless --policy strict-ci
```

#### 3.3.4 Example workflow sessions

**1. Quick script execution:**
```powershell
$ cat hello.bas
Sub Main()
    Debug.Print "Hello from OxVBA"
End Sub

$ oxvba run hello.bas --profile windows-headless
Hello from OxVBA
```

**2. Top-level script (extension):**
```powershell
$ cat calc.bas
Option Explicit
Dim x As Double
x = 3.14159
Debug.Print "Pi squared = " & CStr(x * x)

$ oxvba run calc.bas --top-level
Pi squared = 9.8696...
```

**3. Directory-first project run:**
```powershell
$ ls my-project/
MyProject.basproj  src/Main.bas  src/Utils.bas  src/MathLib.cls

$ oxvba run-project my-project/ --jit
[project output]
```

**4. Artifact build-and-run:**
```powershell
$ oxvba pack . --out dist/finance.oxvbapkg --deterministic
oxvba: packed finance.oxvbapkg (3 modules, schema v1, fingerprint abc123)

$ oxvba run-artifact dist/finance.oxvbapkg --profile windows-headless
[output identical to run-project]
```

**5. Legacy import:**
```powershell
$ oxvba import-vbp legacy/FinanceCalc.vbp --out ./FinanceCalc.basproj
oxvba import-vbp: parse failed: VBP-E-UNSUPPORTED-FORM: `Form=frmMain; frmMain.frm` is not supported in VBP-S0
```

**6. Host capability check:**
```powershell
$ oxvba host-check . --profile wasm-browser-sandbox --policy strict-ci
Required capabilities:
  - ComActivationDispatch: DENIED (policy: strict-ci)
  - FileSystemIo: DENIED (profile: wasm-browser-sandbox)
  - DynamicLinking: DENIED (profile: wasm-browser-sandbox)

Result: 3 capability denials. Project will fail at runtime on denied operations.
```

#### 3.3.5 Programmatic embedding sketches

For environments where the CLI is insufficient, OxVBA will expose a C-compatible API (`liboxvba`) that can be consumed by other languages. These sketches are forward-looking and not an immediate deliverable.

**Rust (direct crate dependency):**
```rust
use oxvba_host::{Engine, HostConfig};

let engine = Engine::new(HostConfig::default());
let result = engine.execute_source_with_snapshot("Sub Main()\nEnd Sub");
```

**C API surface (proposed):**
```c
// liboxvba.h
typedef struct OxvbaEngine OxvbaEngine;
OxvbaEngine* oxvba_engine_new(void);
int oxvba_engine_execute_source(OxvbaEngine* engine, const char* source);
void oxvba_engine_free(OxvbaEngine* engine);
```

**Python (ctypes):**
```python
import ctypes
lib = ctypes.CDLL("liboxvba.so")
engine = lib.oxvba_engine_new()
lib.oxvba_engine_execute_source(engine, b"Sub Main()\nEnd Sub")
lib.oxvba_engine_free(engine)
```

**.NET (P/Invoke):**
```csharp
[DllImport("oxvba")]
static extern IntPtr oxvba_engine_new();

[DllImport("oxvba")]
static extern int oxvba_engine_execute_source(IntPtr engine, string source);
```

**Go (cgo):**
```go
// #cgo LDFLAGS: -loxvba
// #include "liboxvba.h"
import "C"

engine := C.oxvba_engine_new()
C.oxvba_engine_execute_source(engine, C.CString("Sub Main()\nEnd Sub"))
C.oxvba_engine_free(engine)
```

These embeddings all consume the same C API. On Windows, COM Automation interop is also a natural integration path — a compiled OxVBA wrapper DLL is directly consumable from any COM-aware language.

---

### 3.4 UC-D: Top-Level Code Extension

#### 3.4.1 VBA spec context

Standard VBA requires all executable code to live inside procedures (`Sub`, `Function`, `Property`). Module-level scope permits only declarations (`Dim`, `Const`, `Type`, `Enum`, `Declare`, `Option` statements).

Top-level code is an OxVBA extension to the VBA 7 / Office-hosted spec surface. It enables both script-like execution and program-style entrypoint discovery for OxVBA-hosted code:

```powershell
$ oxvba run script.bas
```

This is explicitly not standard Office VBA behavior. It is an OxVBA host/project extension that makes the same language and code style usable in richer realizations beyond the Office-parity scope.

Normative stance:

- direct `oxvba run <file.bas>` is a first-class execution mode and does not require a `.basproj`
- top-level executable statements are supported by default in that direct-file lane
- OxVBA projects may also use top-level executable statements as a startup mainline
- this extension does not change Office/VBA parity claims; it is an OxVBA hosting feature layered on top of the VBA-compatible engine

#### 3.4.2 Startup resolution model

Startup resolution order for OxVBA-hosted program execution:

1. explicit configured entrypoint wins (`<EntryPoint>` in `.basproj`, `Startup=` in `.vbp`, or CLI override)
2. otherwise, a unique module/file containing top-level executable statements defines the startup mainline
3. otherwise, a unique `Sub Main` fallback is used
4. otherwise, compilation/startup fails deterministically with an ambiguity or missing-entry diagnostic

For a direct single-file run (`oxvba run foo.bas`), the file itself is the startup unit:

- if it contains top-level executable statements, those statements are the startup mainline
- if it contains no top-level executable statements, ordinary explicit startup lookup rules apply within that file

#### 3.4.3 Semantic rules for top-level code

1. `Option Explicit`, `Option Compare`, `Option Base` MUST precede all executable statements.
2. `Dim`, `Const`, `Type`, `Enum`, `Declare`, and procedure declarations remain declarations; they are not textually wrapped into a user-visible `Sub Main()`.
3. Top-level executable statements are lowered into a hidden synthetic startup procedure at compile time; this is a compiler artifact, not source rewriting.
4. Procedures (`Sub`, `Function`, `Property`) may be defined in the same file and called from top-level code.
5. Module-level scope rules still apply: module variables remain module variables, not locals of the synthetic startup procedure.
6. In multi-module project execution, at most one startup mainline may exist unless an explicit configured entrypoint makes the top-level mainline unused or disallowed by a future stricter mode.
7. Output-type-specific tightening for library/add-in hosts remains host-defined. Program/script lanes support top-level mainlines from the start.

The important implementation constraint is that OxVBA must not simply wrap the entire source file in `Sub Main()`, because declarations and procedure bodies must preserve their ordinary module semantics.

#### 3.4.4 Example

```vba
' file: quickcalc.bas (run with: oxvba run quickcalc.bas)
Option Explicit

Dim principal As Double
Dim rate As Double
Dim years As Long

principal = 10000
rate = 0.05
years = 10

Dim futureValue As Double
futureValue = CalculateFV(principal, rate, years)

Debug.Print "Future value of " & Format(principal, "$#,##0") & _
            " at " & Format(rate, "0.0%") & _
            " for " & years & " years:"
Debug.Print Format(futureValue, "$#,##0.00")

Function CalculateFV(pv As Double, r As Double, n As Long) As Double
    CalculateFV = pv * (1 + r) ^ n
End Function
```

---

### 3.5 UC-E: WebAssembly Hosting

#### 3.5.1 Comparison with other runtimes

| Aspect | Rust (wasm-bindgen) | Go (TinyGo) | C# (Blazor) | Python (Pyodide) | OxVBA (proposed) |
|--------|-------------------|-------------|-------------|-----------------|------------------|
| **Loader** | wasm-pack + JS glue | TinyGo compiler | .NET WASM runtime | Pyodide bootstrap | Host-provided container |
| **Binary size** | ~100KB-2MB | ~300KB-1MB | ~5-20MB | ~10-20MB | ~0.5MB (lite) |
| **Host bridge** | `wasm-bindgen` auto-gen | Go exports | JS interop | Pyodide API | Explicit bridge trait |
| **Sandbox** | Browser sandbox | Browser sandbox | Browser sandbox | Browser sandbox | Deny-by-default HAL policy |
| **Filesystem** | None / WASI | None / WASI | Virtual FS | Emscripten FS | WASI or denied |
| **COM/native** | N/A | N/A | N/A | N/A | Denied by policy |

#### 3.5.2 OxVBA WASM hosting model

OxVBA compiles to a WASM module that is loaded by a host-provided runtime container. The host container owns capabilities and bridge injection. OxVBA remains a capability-consumer under HAL policy.

Two runtime classes:

- **`wasi`** — WASM + WASI for server-side or local execution. Filesystem, environment, and time are available through WASI.
- **`browser-sandbox`** — WASM in browser. No filesystem, no process, no COM. UI virtualization is required for any interaction.

The OxVBA WASM module exposes:
- `oxvba_init(config)` — initialize engine with serialized configuration.
- `oxvba_execute(source)` — compile and execute VBA source.
- `oxvba_load_project(manifest)` — load a project manifest.
- Host callback imports for bridge methods (property access, method invocation, event dispatch).

#### 3.5.3 Security and sandbox contract

- **Deny by default** for filesystem, process, COM, dynamic linking.
- **Explicit allowlist** for approved host bridges (declared at initialization).
- **Structured diagnostics** for denied operations (deterministic error codes, not silent failures).
- **No implicit privilege escalation** through convenience APIs.
- **Memory isolation** via WASM linear memory — host cannot access engine internals and vice versa without explicit bridge calls.

#### 3.5.4 Host loading example

```javascript
// Browser: loading OxVBA WASM module
const oxvba = await WebAssembly.instantiateStreaming(
    fetch('/oxvba.wasm'),
    {
        env: {
            // Host bridge callbacks
            host_get_property: (objectId, propertyNamePtr) => {
                // ... marshal and return property value
            },
            host_invoke_method: (objectId, methodNamePtr, argsPtr) => {
                // ... marshal and invoke
            },
            host_emit_diagnostic: (level, messagePtr) => {
                console.log(`[OxVBA ${level}] ${readString(messagePtr)}`);
            },
        }
    }
);

// Initialize with browser-sandbox policy
oxvba.exports.oxvba_init(/* config pointer */);

// Execute VBA code
const source = `Sub Main()\n    Debug.Print "Hello from WASM"\nEnd Sub`;
oxvba.exports.oxvba_execute(encodeString(source));
```

---

## 4. Cross-Cutting Design

### 4.1 Project File Format: `.basproj` (MSBuild-Compatible XML)

> **Superseded:** The `oxvba.toml` format previously proposed in this section has been replaced by the `.basproj` XML format. See `docs/spec/BASPROJ_SPEC_V1.md` for the full normative specification.

#### 4.1.1 Design principles

- **MSBuild SDK-style compatibility.** Uses `<Project Sdk="...">` root, `<PropertyGroup>` for scalars, `<ItemGroup>` for collections — the same conventions as .NET SDK-style projects. This preserves the option for future MSBuild integration.
- **XML-centric ecosystem fit.** Excel/Office file formats are XML-centric — `.basproj` fits naturally inside or beside those containers.
- **Not VB6 baseline.** `.vbp` support is an adapter/import path, not the canonical format.
- **Covers all use cases.** HostModule, Library (DLL with native exports), Exe, and Addin output types.
- **Explicit over implicit.** All build, policy, and reference configuration is visible and versionable. Auto-discovery is opt-in (when no modules are declared).

#### 4.1.2 Format overview

```xml
<Project Sdk="OxVba.Sdk/0.1.0">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <ProjectName>FinanceTools</ProjectName>
    <EntryPoint>MainModule.Main</EntryPoint>
    <RuntimeFlavor>Jit</RuntimeFlavor>
    <DefaultRuntimeProfile>windows-headless</DefaultRuntimeProfile>
    <DefaultPolicyPreset>deterministic-runtime</DefaultPolicyPreset>
    <DefaultRootObject>Application</DefaultRootObject>
    <DefineConstants>VBA7=1;WIN64=1;DEBUG</DefineConstants>
  </PropertyGroup>
  <ItemGroup>
    <Module Include="MainModule.bas" />
    <ClassModule Include="Calculator.cls">
      <VBExposed>True</VBExposed>
      <VBPredeclaredId>True</VBPredeclaredId>
    </ClassModule>
    <DocumentModule Include="Sheet1.cls">
      <HostDocumentType>Worksheet</HostDocumentType>
    </DocumentModule>
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\CoreLib\CoreLib.basproj" />
    <COMReference Include="Scripting">
      <Guid>{420B2830-E718-11CF-893D-00A0C9054228}</Guid>
      <VersionMajor>1</VersionMajor>
      <VersionMinor>0</VersionMinor>
      <Lcid>0</Lcid>
      <ImportLib>scrrun.dll</ImportLib>
    </COMReference>
  </ItemGroup>
  <ItemGroup>
    <NativeExport Include="CalcBlackScholes">
      <Module>PricingFunctions</Module>
      <Procedure>BlackScholes</Procedure>
      <CallingConvention>Stdcall</CallingConvention>
    </NativeExport>
  </ItemGroup>
  <Import Project="NativeExports.items" />
</Project>
```

Full property/item type reference, mapping rules, and examples for all three use cases (embedded host, library DLL, standalone exe) are in `docs/spec/BASPROJ_SPEC_V1.md`.

#### 4.1.3 Implementation

The `oxvba-project` crate (`crates/oxvba-project/`) provides:
- `parse_basproj_xml(xml) → BasProj` — XML to intermediate model
- `load_basproj(path) → LoadedProject` — filesystem-aware loading producing `ProjectManifest` + `Vec<NativeExportDescriptor>`
- `generate_basproj_xml(manifest, ...) → String` — round-trip XML generation
- Module auto-discovery, `<Import>` file merging, conditional constant parsing

#### 4.1.4 Schema evolution policy

- The `Sdk` version attribute (`OxVba.Sdk/<semver>`) controls schema compatibility.
- Parsers MUST reject SDK versions with a major version they do not support.
- New optional properties/items may be added within a minor version.
- Removing or changing semantics of existing elements requires a major version bump.

### 4.2 Directory-as-Project Convention

Modern language tools use the containing directory as the project scope. OxVBA adopts this convention:

**With `.basproj` (explicit mode):**
- The directory containing the `.basproj` file is the project root.
- Module items (`<Module>`, `<ClassModule>`, `<DocumentModule>`) control file discovery.
- Project name, output type, entry point, and references are explicit.

**Without `.basproj` (convention mode / minimal `.basproj`):**
- A `.basproj` with no module items auto-discovers all `.bas` and `.cls` files in the directory (recursive).
- Directory name becomes the project name when `<ProjectName>` is omitted.
- Startup resolution for executable runs is: configured entrypoint if present, else unique top-level mainline, else unique `Sub Main` (error if not found or ambiguous).

**Discovery order for `oxvba run-project [PATH]`:**

1. If PATH is a `.vbp` file: use VBP-S0 adapter.
2. If PATH is a `.basproj` file: use `.basproj` parser.
3. If PATH is a directory containing a `.basproj` file: use that `.basproj`.
4. If PATH is a directory without `.basproj`: use convention mode (all `.bas`/`.cls` files).
5. If PATH is omitted: use current directory and repeat steps 3-4.

### 4.3 `.vbp` Adapter

The `.vbp` adapter is an import/compatibility layer, not the canonical project format.

**VBP-S0 subset — supported keys:**

| `.vbp` key | OxVBA mapping |
|-----------|---------------|
| `Type=Exe` | `ProjectKind::Source` |
| `Type=OleDll` / `Type=Control` | `ProjectKind::Library` |
| `Name=<name>` | `ProjectManifest.project_name` |
| `Startup=<entry>` | VBP-S0 supports `Sub Main` fallback or explicit `Module.Procedure`; startup-object forms remain deferred |
| `Module=<name>; <path>` | `ModuleUnit` with `ModuleKind::Procedural` |
| `Class=<name>; <path>` | `ModuleUnit` with `ModuleKind::Class` |
| `Reference=<...>` | `ProjectReference` with `ReferenceKind::TypeLibrary` |

**Deferred keys:** `Form`, `UserControl`, `PropertyPage`, build metadata, COM registration directives — rejected in the current strict VBP-S0 lane with stable `VBP-E-UNSUPPORTED-*` diagnostics.

**Import command:**

```powershell
$ cat legacy/Project1.vbp
Type=Exe
Startup="Sub Main"
Name="FinanceCalc"
Module=Main; Main.bas
Module=Utils; Utils.bas
Class=Calculator; Calculator.cls

$ oxvba import-vbp legacy/Project1.vbp --out ./FinanceCalc.basproj
oxvba: imported 3 modules (2 procedural, 1 class), 0 references
```

The full VBP-S0 implementation plan is in `docs/worksets/WORKSET_2026-03-05_VBP_SUBSET_AND_ARTIFACT_PLAN.md`.

### 4.4 Artifact Format: `*.oxvbapkg` (A0)

The compiled artifact is a versioned, self-describing package containing everything needed to run a project without re-compilation.

**Required sections:**

| Section | Contents |
|---------|----------|
| `manifest_snapshot` | Canonical project manifest projection |
| `bytecode_payload` | Compiled bytecode (rkyv-serialized) |
| `source_hashes` | SHA-256 hash of each source module (for staleness detection) |
| `toolchain_fingerprint` | OxVBA version + build profile that produced the artifact |
| `policy_fingerprint` | Runtime profile and policy preset used during compilation |
| `export_inventory` | Host-visible procedure exports |

**Compatibility rules:**

- Artifact MUST include schema version.
- Runtime MUST reject artifacts with incompatible schema versions deterministically.
- Runtime SHOULD warn on toolchain version mismatches without rejecting.
- Artifacts are profile-locked by default (the policy fingerprint from build time is embedded).

### 4.5 Build Targets: EXE and DLL

**Wrapper EXE:**

Embeds OxVBA runtime + compiled project artifact into a standalone executable.

| Flavor | Contents | Measured size |
|--------|----------|--------------|
| `lite` | VM-only runtime + artifact | ~0.44 MiB + artifact |
| `jit`  | VM + Cranelift JIT + artifact | ~4.93 MiB + artifact |

Requirements for EXE target:
- Project MUST have a deterministic startup path: configured `<EntryPoint>` in `.basproj`, `Startup` in `.vbp`, a unique top-level mainline, or a unique `Sub Main` found by convention.
- Direct `oxvba run <file.bas>` is the degenerate single-file case of the same rule.

**Wrapper DLL (in-process COM server):**

| Aspect | Contract |
|--------|----------|
| Threading | STA-only; non-STA activation fails deterministically |
| Interface tier | `IDispatch` first (late-bound); early-bound interfaces later |
| Exports | `DllGetClassObject`, `DllCanUnloadNow`, optional `DllRegisterServer` |
| Error mapping | Deterministic `HRESULT` ↔ OxVBA diagnostic mapping |
| Activation | Registry-free manifest first; dual-lane (registry + manifest) later |

**Platform portability:**

- EXE wrappers compile for the target platform (Windows `.exe`, Linux ELF, macOS Mach-O).
- DLL wrappers with COM server semantics are Windows-only.
- DLL wrappers without COM (pure C-API export) are cross-platform.

### 4.6 Build Integration with External Systems

**Scenario:** A project builds a native `.dll` or COM server with a type library externally (e.g., using CMake, MSBuild, or a Makefile), then references the resulting artifacts from VBA code.

**Configuration (previously in `oxvba.toml`, now superseded by `.basproj`):**

```toml
[build.hooks]
prebuild = ["cmake --build build --config Release"]

[[references.typelib]]
importlib = "MyNativeLib"
tlb_path = "build/Release/MyNativeLib.tlb"

[[references.native]]
kind = "declare-lib"
name = "mynativelib"
path = "build/Release/MyNativeLib.dll"
```

**Build integration contract:**

1. `prebuild` hooks run before OxVBA compilation, in declared order.
2. Prebuild hook failures abort the build with a deterministic error.
3. Referenced artifacts (`tlb_path`, `path`) are checked for existence after prebuild.
4. Source hash computation includes referenced artifact hashes for staleness detection.
5. No hidden mutable global state — all external dependencies are declared in `.basproj`.

### 4.7 Event Model Closure

**Current state (2026-03-08):**

The compiler/binder event semantics are closed (EVT1/EVT2). `WithEvents`, `Implements`, and `RaiseEvent` have proper project-aware validation with deterministic diagnostics. EVT3 baseline is implemented for the current subset: `RaiseEvent` lowering now dispatches to known `WithEvents` handlers, and compiled projects emit deterministic host-consumable event dispatch bindings.

**Remaining work (EVT3-EVT8):**

| Phase | Scope | Status |
|-------|-------|--------|
| EVT3 | Runtime subscription graph and dispatch semantics | In progress (baseline implemented; deterministic reassignment/clear transition probes executable; full sink-instance graph parity pending) |
| EVT4 | Embedded host event bridge and code-behind routing | In progress (non-COM dispatch mapping baseline implemented) |
| EVT5 | COM-EVT-A: dispatch-style event callbacks (blocking) | In progress (controlled native connection-point callback lifecycle implemented; external oracle evidence pending) |
| EVT6 | COM-EVT-B: non-dispatch event paths (non-blocking deferral allowed) | In progress (controlled source-interface callback lane implemented; external-server parity evidence pending) |
| EVT7 | Conformance, oracle, and formal lanes | Pending |
| EVT8 | Closure gate (close/re-scope remaining event divergences) | In progress (`DIV-0003` closed; `DIV-0004` open) |

**Two-layer design:**

- **Layer 1 (host bridge):** standardize event subscription/dispatch API now. This is the `subscribe_event`/`unsubscribe_event`/`dispatch_event` contract in `OxvbaHostBridge`. Can proceed independently of VBA semantic completion.
- **Layer 2 (VBA semantics):** runtime subscription graph, handler ordering, reassignment behavior, lifecycle integration. Requires EVT3+ phases.

DNA VbCalc is the primary validation target for host-event integration (Layer 1 + Layer 2 working together).

**Proposed diagnostic taxonomy additions:**

Language/binder (implemented):
- canonical list is generated from `docs/evidence/diagnostics/PMR_EVENT_DIAGNOSTICS_V1.csv`:
  - `docs/generated/PMR_EVENT_DIAGNOSTICS_SNIPPET.md`

Runtime/host (planned):
- `PMR-E-EVENT-DISPATCH-TARGET-MISSING`, `PMR-E-EVENT-SUBSCRIPTION-STATE-INVALID`

COM bridge (planned):
- `COM-E-EVENT-CONNECTIONPOINT-MISSING`, `COM-E-EVENT-ADVISE-FAILED`
- `COM-E-EVENT-CALLBACK-SIGNATURE-MISMATCH`, `COM-E-EVENT-PATH-UNSUPPORTED`

### 4.8 Language Services

**Contract shape:**

```rust
pub trait LanguageServiceProvider {
    /// Parse source and return diagnostics.
    fn diagnostics(&self, project: &ProjectManifest) -> Vec<Diagnostic>;

    /// Return all symbols in the project with metadata.
    fn symbols(&self, project: &ProjectManifest) -> Vec<SymbolInfo>;

    /// Return completion candidates at a cursor position.
    fn completions(
        &self,
        project: &ProjectManifest,
        module: &str,
        position: Position,
    ) -> Vec<CompletionItem>;

    /// Return signature help for a call at cursor position.
    fn signature_help(
        &self,
        project: &ProjectManifest,
        module: &str,
        position: Position,
    ) -> Option<SignatureHelp>;

    /// Return the definition location for a symbol at cursor position.
    fn go_to_definition(
        &self,
        project: &ProjectManifest,
        module: &str,
        position: Position,
    ) -> Option<Location>;

    /// Return all references to a symbol at cursor position.
    fn find_references(
        &self,
        project: &ProjectManifest,
        module: &str,
        position: Position,
    ) -> Vec<Location>;
}
```

**Key constraint:** All methods accept `ProjectManifest` — source comes from the host, not the filesystem. This enables hosts like DNA VbCalc to provide language services for VBA code stored inside their container formats.

**Transport strategy:**

1. **Phase 1:** Direct Rust API (for in-process hosts like DNA VbCalc).
2. **Phase 2:** LSP server wrapping the Rust API (for VS Code, other editors).

---

## 5. Design Decision Register

| ID | Question | Options | Recommendation | Status |
|----|----------|---------|---------------|--------|
| D-01 | Top-level code activation mechanism | A: opt-in marker/flag / B: default OxVBA extension in host lanes | **B: default OxVBA extension** for direct-file and program-style host lanes; Office/VBA parity claims remain separate | Proposed |
| D-02 | Default behavior for `oxvba run-project .` | A: auto-detect project vs script / B: require `.basproj` | **Auto-detect:** if `.basproj` exists, use it; else convention mode (all files, resolve explicit entrypoint, unique top-level mainline, or unique `Sub Main`) | Proposed |
| D-03 | Artifact portability | A: profile-locked / B: profile-portable | **A: profile-locked by default** (safer determinism; portable mode as explicit opt-in) | Proposed |
| D-04 | Process-global registration collision policy | A: fail / B: shadow / C: namespace-prefix | **A: fail by default** (explicit collision error; shadow/prefix as opt-in) | Proposed |
| D-05 | Wrapper DLL COM activation | A: registry-free first / B: dual lane from day one | **A: registry-free first** (simpler deployment; registry lane added later) | Proposed |
| D-06 | XLL architecture default | A: per-project (B1) / B: shared host (B2) | **A: per-project (B1) first** (simpler; B2 follow-up based on data) | Proposed |
| D-07 | Language service transport | A: direct Rust API / B: LSP-first | **A: direct Rust API first** (lowest latency for in-process hosts; LSP wrapper second) | Proposed |
| D-08 | `.basproj` schema version policy | A: semver / B: Sdk version attribute | **B: Sdk version attribute** (`OxVba.Sdk/<semver>`) — standard MSBuild pattern | Decided |
| D-09 | Top-level code `Option` placement | A: before executable only / B: interspersed | **A: before executable only** (matches module-level VBA rules) | Proposed |
| D-10 | WASM default deny scope | A: all HAL capabilities / B: selective | **A: all deny by default** (security-first; explicit allowlist for approved bridges) | Proposed |
| D-11 | EXE entry point requirement | A: strict `Sub Main` / B: startup resolution ladder / C: explicit entry only | **B: startup resolution ladder** (explicit entrypoint first, then unique top-level mainline, then unique `Sub Main`) | Proposed |
| D-12 | Unknown `.vbp` keys policy | A: strict (fail) / B: compat (warn) | **A: strict by default** in CI; `--compat` flag for migration workflows | Proposed |
| D-13 | DNA VbCalc persistence format | A: XML-in-ZIP / B: SQLite / C: flat directory | **A: XML-in-ZIP** (Office-inspired simplicity; embedded project support) | Proposed |

---

## 6. Phased Execution Plan

### Phase P1: Design Lock and Contract Catalog

**Deliverables:**
- Lock v2 decisions from this document.
- Publish clause catalog for hosting/project/tooling contract.
- Derive executable acceptance tests from requirements.

**Gate:** Approved design-lock document + clause table + initial acceptance suite scaffold.
**Dependencies:** None.
**Effort:** S

### Phase P2: Canonical Project Format and Directory Workflows

**Deliverables:**
- `.basproj` parser/validator (`oxvba-project` crate — **implemented**).
- Project discovery (`run-project .` with `.basproj` and convention mode).
- Include/exclude glob evaluation.
- Entry point discovery and validation.
- `init` command for project scaffolding.

**Gate:** Deterministic parse/validation + sample project corpus pass.
**Dependencies:** P1 (design lock).
**Effort:** M

### Phase P3: VBP-S0 Adapter

**Deliverables:**
- `.vbp` parser with VBP-S0 key subset.
- `VbpProject -> ProjectManifest` bridge.
- `import-vbp` command.
- Stable `VBP-E-*` diagnostics for unsupported keys.

**Gate:** VBP fixture matrix pass, stable unsupported diagnostics.
**Dependencies:** P2 (project model must be stable).
**Effort:** M

### Phase P4: Artifact A0 and Run Parity

**Deliverables:**
- `pack` command producing `*.oxvbapkg` artifacts.
- `run-artifact` command consuming artifacts.
- Schema versioning and compatibility checks.
- Source hash staleness detection.

**Gate:** Parity across loose project run and artifact run on fixture suite.
**Dependencies:** P2 (project format), P3 (optional, for legacy input).
**Effort:** M

### Phase P5: Embedded Host Contract and DNA VbCalc Pathfinder

**Deliverables:**
- `OxvbaHostBridge` trait implementation.
- `HostObjectToken` and object model bridge substrate.
- DNA VbCalc pathfinder application:
  - Work panel with controls.
  - Host object model (`Application`, `WorkPanel`, `Controls`).
  - `.vbcalc` persistence format.
  - End-to-end scenario: load project, inject objects, execute, handle events.

**Gate:** End-to-end scenario pass: load project from host store, inject root object, execute entry, handle host callbacks, survive event dispatch cycle.
**Dependencies:** P2, P4 (artifact), P6 (event model — can co-develop).
**Effort:** L

### Phase P6: Event Model Closure (EVT3-EVT8)

**Deliverables:**
- Runtime subscription graph (EVT3).
- Host event bridge and code-behind routing (EVT4).
- COM event bridge: dispatch-style callbacks (EVT5).
- COM event bridge: non-dispatch paths or explicit deferral (EVT6).
- Conformance lanes and oracle probes (EVT7).
- Closure gate: close remaining divergence scope (currently `DIV-0004`) and complete edge-oracle foldback (`ODG-038/039`) (EVT8).

**Gate:** Close divergence tickets or explicitly downgrade parity claim scope.
**Dependencies:** EVT1/EVT2 (already complete). P5 provides validation target.
**Effort:** L

### Phase P7: Wrapper Outputs and Add-in Semantics

**Deliverables:**
- `build-wrapper-exe` command.
- `build-wrapper-dll` command with COM STA surface.
- Scope-aware export registration semantics.
- Lite and JIT wrapper flavors with size budget tracking.
- `ls-exports` and `host-check` commands.

**Gate:** Deterministic registration behavior for document and process scope. Wrapper EXE/DLL run parity with loose/artifact lanes.
**Dependencies:** P4 (artifact format), P5 (host contract).
**Effort:** L

### Phase P8: Excel XLL Prototype

**Deliverables:**
- X1 prototype (per-project self-contained XLL).
- Function registration through `xlAutoOpen`/`xlfRegister`.
- Application object bridge.
- Documented caveat matrix for call-path differences.
- Optional X2 follow-up (shared language-host XLL).

**Gate:** Reproducible interop demo suite + documented caveats.
**Dependencies:** P7 (wrapper DLL substrate).
**Effort:** M-L

### Phase P9: WASM Host Lane Hardening

**Deliverables:**
- WASM bridge contract formalization.
- Conformance suite expansion for WASM profiles.
- Sandbox security verification (capability-denial behavior).
- Browser-sandbox and WASI-local validation.

**Gate:** Sandbox security checks pass + deterministic capability-denial behavior confirmed.
**Dependencies:** P5 (host contract), P6 (events for bridge callbacks).
**Effort:** M

### Dependency Graph

```
P1 ─────► P2 ─────► P3
           │         │
           ▼         │
          P4 ◄───────┘
           │
     ┌─────┼─────┐
     ▼     ▼     ▼
    P5    P6    (parallel possible)
     │     │
     ├─────┤
     ▼     ▼
     P7 ◄──┘
     │
     ├─────► P8
     │
     └─────► P9

Parallelism opportunities:
  - P5 and P6 can co-develop (events pathfinder + events engine)
  - P3 can run in parallel with P4
  - P8 and P9 can run in parallel after P7
```

---

## 7. Immediate Next Worksets

1. **`DESIGN-LOCK-V2`** — Lock decisions from this document, publish clause catalog, derive acceptance test seeds. (P1)

2. **`PROJECT-FORMAT-V1`** — `.basproj` schema (`BASPROJ_SPEC_V1.md`), parser/validator (`oxvba-project` crate — **Phase 1 implemented**), directory discovery, `init` command. (P2)

3. **`VBP-S0-EXEC`** — Execute `WORKSET_2026-03-05_VBP_SUBSET_AND_ARTIFACT_PLAN.md` phases VBP1-VBP3. (P3)

4. **`EVENTS-PARITY-CLOSURE`** — execute `WORKSET_2026-03-08_EVENTS_PARITY_CLOSURE.md` to drive event runtime semantics from EVR baseline through parity closure (runtime subscription lifecycle, host ingress parity, COM adapter tier closure, divergence/deferred-gate closure). (P6/P5 overlap)

5. **`DNA-VBCALC-PATHFINDER`** — DNA VbCalc application design refinement, object model definition, initial implementation. (P5)

6. **`ARTIFACT-A0`** — Compiled artifact format, `pack` and `run-artifact` commands. (P4)

## Source: `OxVba/docs/spec/PROJECT_MODULE_REFERENCE_SPEC_V1.md`

# Project Module Reference Spec v1

Status: `working-draft`
Date: 2026-03-02
Scope: OxVba compiler/host project graph semantics (Project, Module, Reference)

## 1. Purpose

Define a formal, implementation-ready contract for VBA project/module/reference behavior in OxVba, aligned to:

- `CHARTER.md` priority order: robustness > compatibility > performance.
- Foundation source doctrine (`docs/FOUNDATION_SPEC_REFERENCE.md`).
- Current OxVba validation approach (clause catalogs, conformance lanes, deferred oracle gates).

This spec is intentionally precise about:

- state model,
- preconditions/postconditions,
- invariants,
- deterministic failure modes,
- implementation-defined boundaries,
- HAL interaction boundaries.

## 2. Normative Source Basis

Primary source set:

- MS-VBAL extracted set:
  - `../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/conformance_items.jsonl`
  - `../Foundation/reference/runs/20260301-ms-vbal-pass07/outputs/docs/discovered-ms-vbal-250520-f945507e/spec_items.jsonl`
- MS-OAUT extracted set:
  - `../Foundation/reference/runs/20260301-ms-oaut-pass02/outputs/conformance_items.jsonl`
- MS-OVBA extracted set:
  - `../Foundation/reference/runs/20260301-ms-ovba-pass01/outputs/spec_items.jsonl`
  - `../Foundation/reference/runs/20260301-ms-ovba-pass01/outputs/run_manifest.json`

Key source-quality note:

- MS-VBAL and MS-OAUT runs contain large extracted conformance sets and are suitable for clause mapping.
- Current MS-OVBA run is under-extracted (6 spec items, 0 conformance candidates). Sections 1.7/2 are marked normative, but section-level obligation extraction is missing and tracked as a hard requirement in this spec.

## 3. Formal State Model

## 3.1 Core Entities

```text
ProjectGraph
  projects: Map<ProjectId, ProjectNode>
  active_project: ProjectId

ProjectNode
  project_name: Identifier
  project_kind: {Source, Host, Library}
  module_order: Vec<ModuleId>
  modules: Map<ModuleId, ModuleNode>
  references: Vec<ProjectReference>
  conditional_constants: Map<Identifier, ConstValue>

ModuleNode
  module_name: Identifier
  module_kind: {Procedural, Class, Document, Form, Extension}
  header_attributes: ModuleAttributes
  declaration_ast: ModuleDeclAst
  code_ast: ModuleCodeAst

ProjectReference
  referenced_project_name: Identifier
  precedence_index: u32
  reference_kind: {Project, TypeLibrary, HostInjected}
  binding_state: {Unbound, Bound, Failed}

ModuleAttributes
  vb_name: Identifier
  vb_global_namespace: bool
  vb_creatable: bool
  vb_predeclared_id: bool
  vb_exposed: bool
  extras: Map<String, String>
```

## 3.2 Invariants

- INV-PMR-001: Every project name is a valid VBA identifier (`CONF-...-0035`).
- INV-PMR-002: Within a project, module names are unique (`CONF-...-0041`).
- INV-PMR-003: Reference list order is preserved and semantically significant (`SPEC-...-01230`).
- INV-PMR-004: Referenced project names in one project are pairwise distinct (`CONF-...-0038`).
- INV-PMR-005: For source projects, `VB_GlobalNamespace == False` and `VB_Creatable == False` (`CONF-...-0042`).
- INV-PMR-006: `Option Private Module` only applies to procedural modules (`SPEC-...-01366..01369`).
- INV-PMR-007: Procedural module variable declarations cannot include `WithEvents` (`CONF-...-0056`).
- INV-PMR-008: Implements clauses in class modules satisfy interface coverage constraints (`CONF-...-0095..0098`).
- INV-PMR-009: Public entity names that collide with project/module names require explicit qualification (`CONF-...-0053`, `...-0106`).

## 4. Operation Contracts

## 4.1 `create_project(project_name, project_kind)`

Preconditions:

- `project_name` parses as `<IDENTIFIER>`.
- no existing project with identical name in active environment.

Postconditions:

- new `ProjectNode` exists with empty module set and empty references.
- deterministic insertion order is established.

Failures:

- invalid identifier -> compile-time diagnostic `PMR-E-PROJECT-NAME-INVALID`.
- duplicate name -> compile-time diagnostic `PMR-E-PROJECT-NAME-DUPLICATE`.

## 4.2 `add_module(project, module)`

Preconditions:

- project exists.
- module header includes required attributes for module kind.

Postconditions:

- module inserted at specified deterministic order index.
- `module_order` and `modules` map remain consistent.

Failures:

- duplicate module name -> `PMR-E-MODULE-NAME-DUPLICATE`.
- malformed header/attribute grammar -> `PMR-E-MODULE-HEADER-INVALID`.

## 4.3 `add_reference(project, reference)`

Preconditions:

- referenced project name is syntactically valid.
- reference name does not duplicate existing reference target name.

Postconditions:

- reference appended with explicit precedence index.

Failures:

- duplicate reference target name -> `PMR-E-REFERENCE-DUPLICATE-TARGET`.

## 4.4 `resolve_qualified_name(project, module, name_expr)`

Preconditions:

- project and module are bound.
- module AST + symbol tables are available.

Postconditions:

- deterministic classification result:
  - local module symbol,
  - enclosing project symbol,
  - referenced project symbol,
  - unresolved.

Failures:

- unresolved ambiguous name -> `PMR-E-NAME-RESOLUTION-AMBIGUOUS`.
- unresolved missing name -> `PMR-E-NAME-RESOLUTION-NOT-FOUND`.
- unqualified access where qualification is required by collision rules -> `PMR-E-NAME-QUALIFICATION-REQUIRED`.

## 4.5 `validate_module_visibility(project, module, entity)`

Preconditions:

- module directives parsed (`Option Private Module` where present).

Postconditions:

- visibility classification is deterministic:
  - project-local only,
  - project+referencing projects,
  - class public interface constraints.

Failures:

- forbidden cross-project access from private module -> `PMR-E-VISIBILITY-DENIED`.

## 4.6 `materialize_default_instance(class_module)`

Preconditions:

- class module attributes available.

Postconditions:

- if `VB_PredeclaredId=True` or `VB_GlobalNamespace=True`, default instance metadata exists.
- default instance naming follows VBAL rules (named or unnamed expressible path).

Failures:

- contradictory class-instancing metadata -> `PMR-E-CLASS-INSTANCING-CONFLICT`.

## 5. Static Semantics Rules

The implementation SHALL enforce at minimum:

- project/module naming and uniqueness (`CONF-...-0035`, `...-0041`).
- module-kind legality and grammar conformance (`CONF-...-0039`).
- source-project class-attribute constraints (`CONF-...-0042`).
- qualification requirements for collision cases (`CONF-...-0053`, `...-0106`).
- `WithEvents` legality by module kind (`CONF-...-0056`, `...-0140`).
- Implements legality and interface coverage (`CONF-...-0095..0098`, `...-0143`).
- module-level declaration collision constraints (`CONF-...-0131`, `...-0132`, `...-0136`).

## 6. Dynamic and Runtime Semantics

Runtime-facing behaviors constrained by this spec:

- class-module event dispatch and `RaiseEvent` legality (`CONF-...-0176`, `...-0177`).
- default-instance exposure semantics from class attributes (source anchors `SPEC-...-01266`, `...-01267` and sentence anchors around class-module semantics).
- project reference precedence affecting runtime bind target selection (`SPEC-...-01230`).

### 6.1 Class Semantic Contract (A1 scope)

The class semantic contract is locked at language/runtime level even when full COM ABI wiring is staged:

- `Class_Initialize` executes before `Main` body effects become observable.
- `Class_Terminate` executes after `Main` path completion for deterministic teardown paths.
- `Property Let/Set` assignment routes to callable property procedures and preserves ByRef write route expectations.
- project-aware class-event legality is compile-time executable for `WithEvents`/`Implements`/`RaiseEvent`, with stable PMR diagnostics for invalid patterns.
- full runtime event graph dispatch semantics (`WithEvents` handler routing/reassignment ordering + `RaiseEvent` subscriber dispatch) remain staged and are tracked as event-model closure work.

Current executable evidence lives in host/compiler tests and is tracked in:

- `docs/spec/PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.md`
- `docs/spec/CLASS_MODULE_COM_ALIGNMENT_PLAN_V1.md`

## 7. Reference and Binding Semantics

## 7.1 Project Reference Ordering

- The reference list is ordered and semantically relevant (`SPEC-...-01230`).
- Binder MUST treat lower index as higher precedence unless an explicit language rule overrides this.

## 7.2 Project Categories

OxVba model must explicitly support:

- source project,
- host project,
- library project,

per source anchors (`SPEC-...-01234`, `...-01236`, `...-01237`).

## 7.3 Cross-project Entity Access

- A project reference grants access to public entities in referenced projects (`SPEC-...-01232`).
- Mechanisms for physically identifying referenced projects are implementation-defined (`SPEC-...-01233`) and must be explicitly documented in the implementation-defined register.

## 7.4 OAUT-facing Constraints for Reference-backed Automation Calls

For calls routed through OLE Automation surfaces, OxVba must preserve OAUT rules, including:

- `GetIDsOfNames` contract + case-insensitivity (`CONF-...-0575`, `...-0599`).
- `Invoke` packing and output obligations (`CONF-...-0614..0623`, `...-0627..0631`).
- automation-compatible type constraints (`CONF-...-0468`, `...-0469`, `...-0483`, `...-0484`, `...-0530`).

### 7.5 Semantic vs Adapter Responsibilities (A3 boundary)

Semantic (language/runtime) obligations:

- class lifecycle ordering, property routing, deterministic project diagnostics.

Adapter/HAL obligations:

- actual COM activation/dispatch ABI behavior, policy gates, and host error projection.

Claim rule:

- class semantic compatibility can be `implemented-verified` without implying full COM ABI parity.
- COM-boundary claims must remain `implemented-partial` or `specified-pending` until bridge conformance lanes close.

## 8. Interaction with Existing OxVba Pipeline

Required compiler-host integration shape:

1. Input layer:
- host/CLI provides project manifest (project metadata + module set + references + conditional constants).

2. Parse layer:
- parse each module independently with preserved header attributes.

3. Project bind layer:
- build project graph,
- validate invariants,
- construct cross-module and cross-project symbol tables,
- resolve qualified/unqualified names with deterministic precedence.

4. Lowering layer:
- preserve enough metadata for runtime-class features (`WithEvents`, default instances, Implements dispatch tags).

5. Runtime/host layer:
- instantiate class default-instance metadata,
- enforce project-level visibility at invocation boundaries,
- route host-project and reference-backed entities through HAL or host integration contracts.

## 9. HAL Boundary and Responsibilities

Project/module/reference semantics are language-level first; however these interactions are HAL-adjacent and are tracked for HAL formalization:

- host project discovery/injection,
- reference graph materialization from host environment,
- open host project and extension-module attachment,
- persistent storage import/export (MS-OVBA),
- type library/importlib resolution where required by references.

Detailed HAL planning is defined in:

- `docs/spec/PROJECT_MODULE_REFERENCE_HAL_INTEGRATION_V1.md`.
- `docs/spec/PROJECT_MODULE_REFERENCE_TYPELIB_IMPORTLIB_HAL_DRAFT_V1.md`.

## 10. Error Model

All project-model failures MUST be deterministic and reproducible.

Error classes:

- syntax/header errors: parser diagnostics.
- static semantic violations: binder/type checker diagnostics.
- host/reference materialization failures: host/HAL structured error mapped to compile-time or runtime phase per policy.

No silent fallback is allowed for violated MUST constraints.

## 11. Verification Model

Clause catalog:

- `docs/spec/PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.md`
- `docs/spec/PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.csv`

Conformance suite plan:

- `docs/spec/PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md`
- `docs/spec/CLASS_MODULE_COM_ALIGNMENT_PLAN_V1.md` (class semantics now, full COM interop mechanics staged/deferred)

Coverage/backlog tracker:

- `docs/evidence/language/MS_VBAL_MODULE_PROJECT_REQUIREMENTS.csv`

## 12. Uncertainty and Implementation-defined Areas

Explicitly implementation-defined from extracted source set:

- project physical representation and storage mechanism (`SPEC-...-01231`).
- mechanism used to identify referenced projects (`SPEC-...-01233`).
- open host project module extension mechanism (`SPEC-...-01241`, `...-01299`).

These MUST be tracked in implementation-defined and deferred-oracle artifacts before compatibility claims are raised to full parity.

## 13. Immediate Next Steps

1. Implement parser retention for module header attributes (`VB_Name`, `VB_PredeclaredId`, `VB_GlobalNamespace`, `VB_Creatable`, `VB_Exposed`).
2. Introduce `ProjectGraph` binding stage and deterministic diagnostics for naming/qualification constraints.
3. Add executable conformance fixtures for two-module and three-module reference precedence paths.
4. Add OAUT-backed dispatch packaging checks at project-reference call boundary.
5. Close MS-OVBA extraction gap in Foundation source runs and map section 2 obligations into clause IDs.

## Source: `OxVba/docs/spec/README.md`

# OxVba Spec Drafts

This directory contains early-stage OxVba internal design drafts.

Normative external specification sources are maintained in `../Foundation/reference`
(see `docs/FOUNDATION_SPEC_REFERENCE.md`).

Status model:
- `design-draft`: directional, incomplete, expected to change quickly.
- `working-draft`: structured and testable, still open for significant revision.
- `stable-draft`: implementation-linked and evidence-backed; still not final normative text.

Current draft set:
- [`HAL_DESIGN_DRAFT.md`](HAL_DESIGN_DRAFT.md) (`design-draft`): scope, principles, profile targets, and staged design plan for the Host Abstraction Layer.
- [`HAL_INTERFACE_DRAFT.md`](HAL_INTERFACE_DRAFT.md) (`design-draft`): proposed HAL contracts, capability schema, and maturity model.
- [`HAL_CONFORMANCE_DRAFT.md`](HAL_CONFORMANCE_DRAFT.md) (`design-draft`): proposed conformance classes, test obligations, and evidence model.
- [`HAL_SPEC_WORKING_DRAFT.md`](HAL_SPEC_WORKING_DRAFT.md) (`working-draft`): implementation-linked HAL contract, deterministic error model, unsupported-mode semantics, and Windows-only COM decision.
- [`HAL_SPEC_CROSSWALK.md`](HAL_SPEC_CROSSWALK.md) (`working-draft`): capability/intrinsic to Foundation anchor mapping plus known extraction gaps.
- [`HAL_CONFORMANCE_SUITE.md`](HAL_CONFORMANCE_SUITE.md) (`working-draft`): runnable HAL harness layers, commands, artifact schema, and expectations.
- [`HAL_FORMALIZATION_PROGRAM.md`](HAL_FORMALIZATION_PROGRAM.md) (`working-draft`): charter-driven HAL formalization program with 5-step execution ladder and H1/H2/H3 tracks.
- [`HAL_CONTRACT_CLAUSE_CATALOG_V1.md`](HAL_CONTRACT_CLAUSE_CATALOG_V1.md) (`working-draft`): explicit clause ID catalog with pre/postconditions, failure obligations, and verification mapping.
- [`HAL_CONTRACT_CLAUSE_CATALOG_V1.csv`](HAL_CONTRACT_CLAUSE_CATALOG_V1.csv) (`working-draft`): machine-readable clause schema for coverage computation and drift-guard checks.
- [`HAL_POLICY_PRESETS.md`](HAL_POLICY_PRESETS.md) (`working-draft`): named host-policy preset table (`strict-ci`, deterministic modes, interactive-dev) and intended usage.
- [`HAL_CONTRACT_ASSERTION_HARDENING.md`](HAL_CONTRACT_ASSERTION_HARDENING.md) (`working-draft`): debug/checked build assertion scaffold and staged hardening path for in-code contract checks.
- [`HAL_OPERATING_ENVELOPE_V1.md`](HAL_OPERATING_ENVELOPE_V1.md) (`working-draft`): explicit v1 host-boundary guarantees, non-guarantees, and optimization-safe operating constraints.
- [`HAL_RUNTIME_PROFILE_BOOTSTRAP_IMPLEMENTATION_V2.md`](HAL_RUNTIME_PROFILE_BOOTSTRAP_IMPLEMENTATION_V2.md) (`working-draft`): implemented runtime bootstrap resolver and CLI integration snapshot (`v198..v201`).
- [`HAL_UI_PLATFORM_IMPLEMENTATION_V2.md`](HAL_UI_PLATFORM_IMPLEMENTATION_V2.md) (`working-draft`): implemented Windows GUI/Linux stdio UI + DoEvents runtime-class behavior snapshot (`v207..v211`).
- [`HAL_DECLARE_EXECUTION_IMPLEMENTATION_V2.md`](HAL_DECLARE_EXECUTION_IMPLEMENTATION_V2.md) (`working-draft`): implemented Declare metadata/lowering/VM/HAL dynamic-link subset snapshot (`v212..v218`).
- [`HAL_DECLARE_ABI_SPEC_V1.md`](HAL_DECLARE_ABI_SPEC_V1.md) (`working-draft`): formalized external declaration + marshaling contract with source-anchor mapping and implementation-defined boundaries.
- [`HAL_DECLARE_MARSHAL_CONFORMANCE_V1.md`](HAL_DECLARE_MARSHAL_CONFORMANCE_V1.md) (`working-draft`): clause-mapped conformance lanes for declaration parsing, runtime gating, marshaling, and deferred oracle checks.
- [`PROJECT_MODULE_REFERENCE_SPEC_V1.md`](PROJECT_MODULE_REFERENCE_SPEC_V1.md) (`working-draft`): formal state model, invariants, pre/postconditions, and deterministic error semantics for project/module/reference behavior.
- [`PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.md`](PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.md) (`working-draft`): clause IDs and verification mappings for PMR semantics.
- [`PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.csv`](PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.csv) (`working-draft`): machine-readable PMR clause coverage map.
- [`PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md`](PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md) (`working-draft`): executable lane design for PMR static semantics, multi-module resolution, references, and storage.
- [`PROJECT_MODULE_REFERENCE_HAL_INTEGRATION_V1.md`](PROJECT_MODULE_REFERENCE_HAL_INTEGRATION_V1.md) (`working-draft`): HAL-adjacent contract and capability planning for host projects, references, and storage.
- [`PROJECT_MODULE_REFERENCE_TYPELIB_IMPORTLIB_HAL_DRAFT_V1.md`](PROJECT_MODULE_REFERENCE_TYPELIB_IMPORTLIB_HAL_DRAFT_V1.md) (`working-draft`): deterministic importlib/type-library binding contract draft and HAL interaction shape for PMR reference resolution.
- [`PROJECT_MODULE_REFERENCE_SOURCE_CROSSWALK_V1.md`](PROJECT_MODULE_REFERENCE_SOURCE_CROSSWALK_V1.md) (`working-draft`): PMR source-anchor crosswalk across MS-VBAL, MS-OAUT, and MS-OVBA extraction status.
- [`VBP_SUBSET_AND_PROJECT_ARTIFACT_STRATEGY_DISCUSSION_V1.md`](VBP_SUBSET_AND_PROJECT_ARTIFACT_STRATEGY_DISCUSSION_V1.md) (`design-draft`): `.vbp` subset support strategy, wrapper EXE/DLL packaging model, and lateral artifact options for loose vs compiled project execution.
- [`HOSTING_PROJECT_TOOLING_PROPOSAL.md`](HOSTING_PROJECT_TOOLING_PROPOSAL.md) (`design-draft`, v2 content): canonical hosting/project/packaging/tooling proposal with full DNA VbCalc pathfinder host design, `oxvba.toml` schema, complete CLI help text, WASM comparison, top-level code extension, and phased execution plan.
- [`archive/HOSTING_PROJECT_TOOLING_PROPOSAL_V1.md`](archive/HOSTING_PROJECT_TOOLING_PROPOSAL_V1.md) (`archived`): original v1 proposal retained for historical traceability; superseded by the canonical proposal above.
- [`CLASS_MODULE_COM_ALIGNMENT_PLAN_V1.md`](CLASS_MODULE_COM_ALIGNMENT_PLAN_V1.md) (`working-draft`): staged class-module/COM alignment plan with explicit near-term semantic steps and deferred interop boundaries.
- [`COM_CLIENT_SERVER_SCOPE_V1.md`](COM_CLIENT_SERVER_SCOPE_V1.md) (`working-draft`): Windows COM client/server support scope, contract boundaries, tier model, apartment policy stance, and C2 late-bound client runway.
- [`COM_CLIENT_SERVER_CONFORMANCE_V1.md`](COM_CLIENT_SERVER_CONFORMANCE_V1.md) (`working-draft`): COM-specific conformance lane architecture, artifact model, and C2 late-bound client lane planning with formal/deferred-oracle integration.
- [`COM_EARLY_BINDING_TYPELIB_SCOPE_V1.md`](COM_EARLY_BINDING_TYPELIB_SCOPE_V1.md) (`working-draft`): comprehensive design for COM early binding and type-library consumption across PMR, HAL, binder, IR/runtime, caching, diagnostics, and formalized verification planning.
- [`COM_EARLY_BINDING_TYPELIB_CONFORMANCE_V1.md`](COM_EARLY_BINDING_TYPELIB_CONFORMANCE_V1.md) (`working-draft`): executable lane plan (`E0..E6`) for early-binding/type-library conformance, formal lanes, and deferred-oracle tracking.
- [`HAL_COM_BRIDGE_SCOPE_V1.md`](HAL_COM_BRIDGE_SCOPE_V1.md) (`working-draft`): HAL-owned COM boundary scope and C1->C2 transition contract for tokenized/native late-bound client behavior.
- [`COM_CLIENT_LATEBOUND_BRIDGE_V1.md`](COM_CLIENT_LATEBOUND_BRIDGE_V1.md) (`working-draft`): explicit cross-layer bridge contract (VBA semantics -> compiler/VM transport -> HAL COM transport -> native adapter).

These files intentionally optimize for design velocity and clarity of open decisions rather than immediate lock-in.

## Source: `OxVba/docs/worksets/WORKSET_2026-03-08_EVENTS_RUNTIME_HOST_PROJECT_HAL_SPLIT.md`

# Workset: Events Runtime Closure under Host Project + HAL Split

Date: 2026-03-08  
Status: in-progress (EVR1-EVR3 baseline implemented; closure-pass reconciliation updated on 2026-03-08)  
Scope: complete executable event-runtime behavior with Host Project as semantic authority, full HAL service provisioning, and COM as transport adapter lane.

Continuation note:
- The full parity completion track now continues in `WORKSET_2026-03-08_EVENTS_PARITY_CLOSURE.md`.

## 0. Implementation update (2026-03-08)

Completed in this cycle:
- EVR1 baseline: `RaiseEvent` now lowers to deterministic handler-call dispatch in `compile_project(...)` for known `WithEvents` bindings.
- EVR2 baseline: project compile now emits stable event dispatch bindings (`source project/module/event -> lowered handler symbol`) derived from `WithEvents` declarations + handler prefix conventions + declared class events.
- EVR3 baseline: host runtime now owns a deterministic non-COM event dispatcher/subscription map and exposes host-event dispatch lookup API (`Engine::dispatch_host_event(...)`), hydrated from compiled project event bindings.

Residual scope (still open in this workset):
- true runtime `Set`/reassignment lifecycle semantics for `WithEvents` variables (subscribe/unsubscribe transitions),
- argument-shape/signature parity for full VBA event callback semantics,
- host-event ingress executing handler call paths directly (current baseline resolves deterministic handler target set).
  - deterministic reassignment/clear transition probes are now executable (`formal_event_runtime_withevents_reassignment_rebinds_non_default_instances_deterministically`, `formal_event_runtime_withevents_clear_then_rebind_updates_dispatch_membership`); residual parity remains around full sink-instance graph semantics.

## 1. Why this continuation exists

The event story now has:
- project-aware compile-time legality for `WithEvents`/`Implements`/`RaiseEvent`,
- canonical diagnostics governance,
- explicit architecture decision: Host Project owns semantic surface; HAL remains mandatory service contract; COM is adapter lane.

The remaining gap is runtime execution parity and host integration behavior across platforms.

This workset continues from `WORKSET_2026-03-07_EVENTS_STORY_COMPLETION.md` and narrows execution to the remaining runtime closure path.

## 2. Normative model lock

1. **Host Project semantic plane (authoritative):**
   - Defines host-visible globals, types, and event signatures visible to user projects.
   - Drives compile/bind semantics independent of transport.

2. **HAL service plane (mandatory):**
   - Host provides full HAL capability suite by profile/policy (`FileSystemIo`, `TimeLocale`, `ProcessEnv`, `UiInteraction`, `EventPump`, etc.).
   - Event model work must not bypass HAL policy gating or profile limits.

3. **Transport adapters (replaceable):**
   - Non-COM bridge is first-class for cross-platform host execution.
   - COM bridge is a Windows adapter lane (`COM-EVT-A` then `COM-EVT-B`).

## 3. Workset objectives

1. Make class-event runtime semantics executable and deterministic.
2. Implement host-raised event routing without COM dependency.
3. Preserve full HAL capability/policy governance in event flows.
4. Validate cross-platform behavior with DNA VbCalc pathfinder harness.
5. Keep COM event support as adapter workstream, not semantic blocker for non-COM hosts.

## 4. Phase plan

### EVR1 - Runtime event IR + dispatcher substrate

Deliverables:
- Introduce explicit runtime event dispatch instructions/ops for `RaiseEvent`.
- Implement subscription graph in host runtime (`assign`, `reassign`, `clear`, teardown).
- Wire deterministic ordering rules into dispatcher execution.

Checks:
- unit tests for graph state transitions and dispatch order,
- VM/JIT parity tests for event-heavy fixtures.

### EVR2 - Host Project-driven root/event binding

Deliverables:
- Bind host root/predeclared objects via Host Project metadata, not COM assumptions.
- Resolve handler targets using Host Project event metadata.
- Enforce deterministic diagnostics for missing event target/state mismatch.

Checks:
- project integration tests with source + host project graphs,
- deterministic diagnostics for missing bindings.

### EVR3 - Non-COM host bridge runtime lane (cross-platform baseline)

Deliverables:
- Add/lock non-COM event ingress path (`host -> runtime event queue -> handler dispatch`).
- Implement lifecycle-safe subscribe/unsubscribe behavior from `WithEvents` assignment transitions.
- Ensure path works across Windows/Linux/macOS/WASM profile constraints.

Checks:
- host integration fixtures for each runtime class family,
- capability-denial behavior asserted under restrictive policies.

### EVR4 - HAL event/service conformance in event flows

Deliverables:
- Assert `EventPump` and related capability checks across event dispatch points.
- Ensure event handlers invoking file/time/process operations still route through HAL gates.
- Add coverage rows and obligations for event+HAL interactions.

Checks:
- policy preset matrix tests (`strict-ci`, deterministic modes, interactive-dev),
- formal obligations for event lifecycle and policy invariants.

### EVR5 - DNA VbCalc cross-platform pathfinder lane

Deliverables:
- Minimal pathfinder harness exercising:
  - Host Project load,
  - root object injection,
  - non-COM event pump,
  - handler execution and deterministic teardown.
- Scenario corpus: control-click/change events, reassignment, object release.

Checks:
- reproducible run scripts and evidence markdown,
- parity assertions across at least Windows + Linux baseline lane.

### EVR6 - COM adapter continuation (non-blocking for non-COM parity)

Deliverables:
- `COM-EVT-A`: dispatch-style connection-point callbacks (blocking only for COM adapter claim).
- `COM-EVT-B`: non-dispatch path support or explicit deterministic unsupported policy.

Checks:
- Windows-only adapter lanes with stable diagnostics,
- no silent fallback between COM event paths.

## 5. Deliverable artifacts

- `docs/evidence/conformance/events/EVENTS_RUNTIME_RUN_<runid>.md`
- `docs/evidence/conformance/events/EVENTS_RUNTIME_RUN_<runid>.csv`
- `docs/evidence/conformance/events/lanes/EVR1_*.md` ... `EVR6_*.md`
- updates to:
  - `docs/evidence/divergences/DIV-0004.md`
  - `docs/evidence/conformance/CONFORMANCE_CHECK_TOPICS.csv`
  - `docs/evidence/formal/obligations.csv`
  - `docs/evidence/formal/FEATURE_OBLIGATION_COVERAGE_V1.csv`

## 6. Exit criteria

1. `WithEvents` reassignment and `RaiseEvent` dispatch execute deterministically at runtime.
2. Non-COM host event routing is executable and evidence-backed cross-platform.
3. Event flows respect HAL service/capability policy in all tested lanes.
4. DNA VbCalc pathfinder lane validates Host Project semantic ownership.
5. `DIV-0004` is closed or narrowed to explicitly documented residual scope.
6. COM adapter claims are explicitly tiered (`COM-EVT-A` and `COM-EVT-B`).

## 7. Initial command scaffold

```powershell
# Compiler + host runtime event semantics
cargo test -p oxvba-compiler compile_project_ -- --nocapture
cargo test -p oxvba-host event -- --nocapture

# Governance and diagnostics sync
./scripts/check-governance.ps1
```

## Source: `OxVba/docs/worksets/WORKSET_2026-03-09_HOST_BRIDGE_OBJECT_VALUE_AND_EVENT_INGRESS_CONTRACT.md`

# Workset: Host Bridge Object-Value and Event-Ingress Contract Lock

Date: 2026-03-09  
Status: planned  
Scope: lock the authoritative contract for host bridge object values, collection/default-member dispatch at the bridge boundary, host-to-engine event ingress, and host error mapping posture for the embedded hosting program.

## 1. Decision summary

Decision lock:
1. The host bridge keeps a single `Variant`-based value boundary.
2. Object references crossing the host bridge are represented as object-capable `Variant` values that carry `HostObjectToken` identity.
3. Host-to-engine event delivery is explicit and engine-owned:
   - `Engine::dispatch_host_event(subscription: SubscriptionId, args: &[Variant])`
4. The host bridge itself remains host-facing:
   - resolve objects,
   - invoke methods,
   - get/set properties,
   - subscribe/unsubscribe events,
   - release objects.
5. Default-member and collection semantics are not encoded as bridge special cases.
   - The bridge exposes ordinary property/method operations.
   - Host Project + runtime semantics decide when VBA syntax implies property access, method invocation, or default-member use.

Recommendation adopted:
1. keep one pragmatic `Variant` boundary rather than inventing a second typed bridge-value system now,
2. require an explicit event-ingress call instead of hidden callback conventions.

## 2. Why this lock is needed

Without this lock, the host/tooling proposal remains underspecified in exactly the places that will destabilize P5a:
1. how object-valued properties and method returns cross the bridge,
2. how the host pushes events into the engine,
3. how collection/default-member access is expressed at the bridge boundary,
4. how host errors relate to runtime/VBA error routing.

The review was correct that these are architectural contract questions, not implementation details.

## 3. Contract shape

### 3.1 Value boundary

The bridge uses:
1. `Variant` for all inbound and outbound values,
2. object-capable `Variant` payloads for host object references,
3. typed tokens for object identity and subscriptions behind that boundary.

Normative implication:
1. object-valued property gets and method returns produce a `Variant` carrying object identity, not a parallel out-of-band object channel.
2. consumers must not rely on stringly or COM-specific conventions to distinguish object vs scalar values.

## 3.2 Host bridge responsibilities

Required bridge responsibilities:
1. `resolve_root_object(name) -> HostObjectToken`
2. `invoke_method(object, method, args: &[Variant]) -> Variant`
3. `get_property(object, property) -> Variant`
4. `set_property(object, property, value: Variant) -> ()`
5. `subscribe_event(object, event_name, handler) -> SubscriptionId`
6. `unsubscribe_event(subscription) -> ()`
7. `release_object(object) -> ()`

Interpretation:
1. the bridge is responsible for ordinary object model navigation and mutation,
2. the bridge is not responsible for VBA semantic interpretation of default-member or `WithEvents` rules,
3. the engine/runtime remains the semantic authority.

## 3.3 Event ingress

The event ingress path is explicit:
1. host raises or observes a host-side event,
2. host maps that event to a previously issued `SubscriptionId`,
3. host calls `Engine::dispatch_host_event(subscription, args)`,
4. engine/runtime resolves the handler set and executes VBA semantics.

This means:
1. event ingress is not hidden inside `subscribe_event`,
2. event dispatch is not a side effect of unrelated host bridge calls,
3. host bridge event subscription and engine event dispatch are separate but complementary contracts.

## 3.4 Collection and default-member behavior

The bridge does not invent special APIs for collection/default-member behavior.

Rules:
1. named property access uses `get_property` / `set_property`,
2. method calls use `invoke_method`,
3. collection/default-member access is expressed through ordinary resolved member operations at the semantic layer,
4. if a collection uses `Item` as its default member, the semantic/runtime layer decides that `Controls(\"x\")` maps to invoking the appropriate member on the bridged object model.

Practical consequence:
1. the bridge stays small and transportable,
2. default-member semantics remain consistent across COM and non-COM hosts.

## 3.5 Error posture

This lock does not fully define host-to-VBA error-number mapping, but it establishes direction:
1. host bridge methods return structured `HostError`,
2. engine/runtime is responsible for mapping host failures into the deterministic VBA/runtime error surface,
3. bridge methods should not embed VBA semantics directly.

Full error-number/source mapping remains a later closure item, but the ownership boundary is now explicit.

## 4. Design consequences

### 4.1 Why not a richer bridge-value enum now

Rejected for now:
1. a second typed boundary enum parallel to `Variant`.

Reason:
1. it would duplicate the runtime value model too early,
2. it would create extra marshaling work before the host bridge is even active,
3. the project already centers Automation/Variant semantics in multiple adjacent domains.

### 4.2 Why explicit event ingress matters

Accepted:
1. event dispatch must be an explicit engine-facing operation.

Reason:
1. it removes hidden conventions,
2. it aligns non-COM host events with the event-runtime work already underway,
3. it gives the pathfinder and future hosts a clear control point for dispatch.

## 5. Interface guidance

Target proposal shape:

```rust
pub trait OxvbaHostBridge {
    fn load_project(&self, id: &str) -> Result<ProjectManifest, HostError>;
    fn load_artifact(&self, id: &str) -> Result<Vec<u8>, HostError>;
    fn resolve_root_object(&self, name: &str) -> Result<HostObjectToken, HostError>;
    fn subscribe_event(
        &self,
        object: HostObjectToken,
        event_name: &str,
        handler: EventHandlerBinding,
    ) -> Result<SubscriptionId, HostError>;
    fn unsubscribe_event(&self, subscription: SubscriptionId) -> Result<(), HostError>;
    fn release_object(&self, object: HostObjectToken) -> Result<(), HostError>;
    fn invoke_method(
        &self,
        object: HostObjectToken,
        method: &str,
        args: &[Variant],
    ) -> Result<Variant, HostError>;
    fn get_property(&self, object: HostObjectToken, property: &str) -> Result<Variant, HostError>;
    fn set_property(
        &self,
        object: HostObjectToken,
        property: &str,
        value: Variant,
    ) -> Result<(), HostError>;
    fn emit_diagnostic(&self, diagnostic: EngineDiagnostic);
}

impl Engine {
    pub fn dispatch_host_event(
        &mut self,
        subscription: SubscriptionId,
        args: &[Variant],
    ) -> Result<(), HostError>;
}
```

## 6. Relation to other work

This lock resolves `F-02` in `docs/REVIEW_20260309_FOLLOWUP.md`.

It also supports:
1. host/pathfinder planning under `P5a`,
2. the existing event-runtime split workset,
3. the COM bridge repurpose decision, because COM should map into the same semantic bridge model rather than define a separate ownership model for event semantics.

## 7. Ladder and program relation

Primary future program relation:
1. P5a host bridge trait + typed tokens + test harness
2. P6 event model co-development

Supportive current relation:
1. clarifies how non-COM host-event ingress should remain semantic-owner authoritative,
2. keeps COM as a transport adapter rather than semantic owner.

## 8. Immediate next actions

1. Update the host/tooling proposal to state this contract explicitly.
2. Mark `F-02` resolved in review triage.
3. When host-bridge implementation starts, use this workset as the contract source of truth.

## Source: `OxVba/docs/worksets/WORKSET_2026-03-23_XLL_ADDIN_SUPPORT_P8.md`

# WORKSET: Phase 8 — XLL/Addin Support

**Date:** 2026-03-23
**Phase:** 8
**Status:** Planned
**Depends on:** Phase 7 (DLL wrapper builder), Phase 4 (native export type info), Phase 5 (Engine::invoke_procedure)

---

## Objective

Extend the DLL wrapper builder to support `OutputType=Addin` with XLL-specific entry points (`xlAutoOpen`, `xlAutoClose`, `xlfRegister`) and XLOPER12 marshaling for Excel integration.

---

## Deliverables

### 1. XLL entry point generation in `crates/oxvba-build/src/xll.rs` (new)

- `xlAutoOpen` — registers all declared native exports with Excel via `xlfRegister`
- `xlAutoClose` — unregisters functions and cleans up runtime
- `xlAutoFree12` — frees XLOPER12 memory allocated by the add-in

### 2. XLOPER12 marshaling layer

Separate from core NativeExport marshaling:

- `RuntimeValue → XLOPER12` for return values
- `XLOPER12 → RuntimeValue` for incoming arguments

Type mapping:

| DeclareParamType | XLOPER12 type | C type |
|-----------------|--------------|--------|
| Long/Integer/Byte | `xltypeInt` | `int` |
| Double/Single/Currency/Date | `xltypeNum` | `double` |
| Boolean | `xltypeBool` | `BOOL` |
| String | `xltypeStr` | `XCHAR*` (length-prefixed wide) |
| Variant | `xltypeMulti` or contextual | varies |

### 3. Function registration metadata

Each `NativeExport` item generates an `xlfRegister` call with:

- Function text (exported name)
- Type string (Excel type codes: `"BBB"` for `Double(Double, Double)`)
- Category, argument descriptions (optional metadata from `.basproj`)

### 4. Addin-specific `.basproj` metadata (optional extension)

```xml
<NativeExport Include="CalcBlackScholes">
  <Module>PricingFunctions</Module>
  <Procedure>BlackScholes</Procedure>
  <CallingConvention>Stdcall</CallingConvention>
  <Category>Financial</Category>
  <Description>Calculate Black-Scholes option price</Description>
  <ArgumentDescriptions>Spot price;Strike price;Time to expiry</ArgumentDescriptions>
</NativeExport>
```

---

## Key Existing Code

- No XLL-specific code exists in the codebase currently
- `crates/oxvba-com/src/typelib_catalog.rs` — Excel.Application typelib support (for Application object bridge)
- `crates/oxvba-build/src/dll.rs` (from Phase 7) — base DLL shim generation

---

## Files to Modify/Create

| File | Change |
|------|--------|
| `crates/oxvba-build/src/xll.rs` (new) | XLL shim generation: xlAutoOpen, xlAutoClose, registration |
| `crates/oxvba-build/src/xloper.rs` (new) | XLOPER12 type definitions and marshaling |
| `crates/oxvba-build/src/lib.rs` | Add xll/xloper modules |
| `crates/oxvba-project/src/model.rs` | Optional addin metadata fields on NativeExport (Category, Description, ArgumentDescriptions) |

---

## Execution Steps

1. Define XLOPER12 struct and related types in `xloper.rs` (mirror Excel SDK headers)
2. Implement XLOPER12 ↔ RuntimeValue marshaling for each DeclareParamType
3. Implement `generate_xll_shim` — extends DLL shim with xlAutoOpen/xlAutoClose/xlAutoFree12
4. Implement function registration code generation — for each export, emit xlfRegister call with type string
5. Implement Excel type code mapping: `DeclareParamType → Excel type letter` (B=Double, J=Int, C=String, etc.)
6. Add optional addin metadata to `.basproj` model
7. Integration test: generate XLL source for a simple function, verify it compiles

---

## Closure Conditions

1. `generate_xll_shim` produces compilable source with xlAutoOpen/xlAutoClose
2. Function registration covers all 13 DeclareParamType → Excel type code mappings
3. XLOPER12 marshaling handles numeric, string, and boolean types
4. Optional metadata (Category, Description) is passed through to registration
5. Generated XLL source compiles without errors

## Source: `OxVba/MACH1000_PLAN.md`

# OxVBA MACH-1000 Project Plan

## Synthesis Provenance

This document is the output of synthesis run `20260226-mach1000-synthesis`. It integrates the baseline OxVBA project plan ([`docs/archive/PLAN_v1_20260226.md`](docs/archive/PLAN_v1_20260226.md)) with the MACH-1000 theoretical architectures ([`docs/archive/BRAINSTORM_MACH1000_20260226.md`](docs/archive/BRAINSTORM_MACH1000_20260226.md)) through a formal decision process documented in [`synthesis/runs/20260226-mach1000-synthesis/`](synthesis/runs/20260226-mach1000-synthesis/README.md).

This document is further refined by synthesis run `20260226-mach1000-refinement-synthesis`, integrating implementation-alignment suggestions from [`docs/MACH1000_PLAN_REFINEMENT_20260226.md`](docs/MACH1000_PLAN_REFINEMENT_20260226.md), documented in [`synthesis/runs/20260226-mach1000-refinement-synthesis/`](synthesis/runs/20260226-mach1000-refinement-synthesis/README.md).

**Refinement synthesis: 10 suggestions extracted; 8 accepted, 2 adapted, 0 deferred, 0 rejected.**

This document supersedes `PLAN.md` as the definitive OxVBA project plan.

---

## Table of Contents

1. [Project Charter](#1-project-charter)
2. [Architecture](#2-architecture)
3. [Formal Approach](#3-formal-approach)
4. [Testing Strategy](#4-testing-strategy)
5. [Research Notes](#5-research-notes)
6. [Design Notes](#6-design-notes)
7. [Proposed Project Structure](#7-proposed-project-structure)
8. [Implementation Sequencing](#8-implementation-sequencing)

---

## 1. Project Charter

Canonical charter document:
- `CHARTER.md` (top-level). This section is a synchronized in-plan restatement.

### 1.1 Mission

OxVBA is a full-fidelity implementation of the VBA 7 runtime engine written in Rust. It targets parsing, compilation, and runtime execution of VBA source code with correctness, performance, and cross-platform reach that exceed what the Office-bundled VBA engine provides.

OxVBA is developed by **DNA Kode** as part of the **DNA Calc** ecosystem. It is intended to be consumed by the DNA Calc spreadsheet system (developed in `../Foundation`) but operates as a standalone project with its own charter, sharing values, methodology, and operational guidance with the broader DNA Calc program.

The MACH-1000 designation reflects the project's commitment to first-principles performance engineering: cache-optimal data layouts, multi-level domain-aware optimization, register-window execution, and formally verified unsafe code — pushing toward the theoretical performance ceiling for a VBA runtime, not merely exceeding the Office baseline.

- **License**: MIT
- **Organization**: DNA Kode
- **Repository**: `github.com/DnaCalc/OxVba`

### 1.2 Values Ordering

Values are listed from most important to least important. When values conflict, higher-ranked values prevail.

1. **Robustness** — No surprises, no crashes, no undefined behavior. The engine must have a rock-solid feel. Every state is well-defined; every error path is handled. Formal verification of critical unsafe paths.
2. **Compatibility** — Any unintended or undocumented incompatibility versus VBA in Office is a high-priority bug. The reference behavior is VBA 7.0/7.1 as shipped in Office.
3. **Performance** — MACH-1000 class execution through cache-optimal data layouts, multi-level IR with domain-aware optimization, register-window VM, broadword-accelerated interpretation, and JIT compilation. We aim not merely to exceed Office VBA's speed but to approach the theoretical optimum.
4. **Small runtime size** — Distribution should never be an issue. Small likely means faster, but in the trade-off we pick faster over smaller by a clear margin.
5. **Well-managed development environment** — The full development stack must be open-source. Setting up a development environment and rebuilding all artifacts must be well-documented and unproblematic. We prefer tooling that makes this possible, but not at the cost of higher values.

### 1.3 Scope

**In scope (initial focus):**
- VBA 7 language parser (full grammar, lossless concrete syntax tree)
- Multi-level intermediate representation with progressive lowering
- Compilation to bytecode and/or native code
- Runtime execution engine (register-window VM, optional JIT via Cranelift)
- Full VBA/COM reference counting semantics
- Opt-in cycle-detecting garbage collector (one of few beyond-VBA features)
- Compilation to executable format (native or IL) without excessive dependencies (no shipping LLVM)
- Cross-platform core: language and basic libraries work on Windows, Linux, macOS
- Full COM compatibility on Windows
- Hosting interfaces: in-process hosting with host COM hookups and non-COM method exposure
- Host-aware runtime loading: host can provide root objects (e.g., `Application`) at engine initialization
- Event and object association (e.g., sheet code-behind in Excel-like hosts)
- Forms runtime including support for custom controls (Rust implementation)

**In scope (listed, not currently active):**
- Runtime security model
- Debugging protocol and interfaces
- IDE features (IntelliSense, go-to-definition, etc.)
- Forms Designer
- COM library interop on non-Windows platforms (abstraction layer exists but full story deferred)

**Out of scope:**
- Spreadsheet engine (that is DNA Calc's domain)
- VBA IDE implementation
- Office application object model (provided by host, not by OxVBA)

### 1.4 Clean-room Rule

OxVBA adopts the DNA Calc Foundation's clean-room rule (Charter, Section 4) as non-negotiable:

> DNA Calc development relies only on:
> - public specifications and documentation,
> - published research,
> - reproducible observation of Excel behavior.
>
> Excluded:
> - proprietary code, restricted materials, decompilation/disassembly of Excel internals, or reverse engineering of internals.

For OxVBA specifically, "Excel behavior" extends to "VBA runtime behavior in Office." Compatibility claims require evidence records following the Foundation's clean-room evidence workflow: claim identifier, admissible source type, capture/reproduction steps, and reviewer decision.

### 1.5 Normative References

- **[MS-VBAL]** — VBA Language Specification (Microsoft Open Specifications). The primary north-star reference for language semantics.
- **[MS-OAUT]** — OLE Automation Protocol. Governs COM Automation, IDispatch, Variant, SAFEARRAY, and type library semantics.
- **[MS-OVBA]** — Office VBA file format specification. Governs project/module storage structure in Office documents.
- **[MS-DTYP]** — Windows data types specification used by Automation and VBA-adjacent ABI contracts.
- **[MS-COM]** — Component Object Model Plus (COM+) Protocol. Underlying object model.
- **VBA 7.0** (Office 2010) and **VBA 7.1** (Office 2013+) as the target runtime versions.
- DNA Calc Foundation Charter, Operations, and Architecture documents for methodology and doctrine.
- Foundation reference doctrine and mirror index:
  - `../Foundation/REFERENCE_SPEC_FORMAT_AND_CONFORMANCE.md`
  - `../Foundation/reference/spec_seeds.csv`
  - `../Foundation/reference/index.csv`
  - `../Foundation/reference/runs/*/outputs/conformance_items.jsonl`
- **Knuth, TAOCP Fascicle 1** — Broadword algorithms and MMIX architecture (public research).
- **MLIR: Multi-Level Intermediate Representation** (Lattner et al.) — Progressive lowering methodology (public research; we implement the concepts in Rust, not the C++ framework).

### 1.6 Why Rust

| Concern | Rust's answer |
|---|---|
| Robustness (#1 value) | Memory safety without GC; no undefined behavior in safe code; algebraic types make illegal states unrepresentable |
| Performance (#3 value) | Zero-cost abstractions; no runtime overhead; competitive with C/C++; ideal for cache-line-aware data layout |
| Small runtime (#4 value) | No managed runtime to ship; static linking; minimal binary sizes achievable |
| COM interop | Excellent `windows` crate ecosystem; `repr(C)` for ABI-compatible types; raw pointer support where needed |
| Cross-platform | First-class support for Windows, Linux, macOS; conditional compilation for platform-specific code |
| Ecosystem alignment | Sibling project DnaVisiCalc is Rust; shared tooling, conventions, and developer knowledge |
| Cranelift availability | Cranelift JIT backend is a Rust-native project; tight integration without FFI overhead |
| Formal verification | Kani (bounded model checking) integrates natively with Rust; Lean 4 for specification-level proofs |

---

## 2. Architecture

### 2.1 Crate Decomposition

OxVBA is organized as a Cargo workspace with nine crates, each with a clear responsibility boundary.

```
oxvba (workspace root)
├── crates/
│   ├── oxvba-syntax        # Lexer, parser, lossless concrete syntax tree
│   ├── oxvba-ir             # Multi-level intermediate representation (VbaHir → VbaMir → CfgIr)
│   ├── oxvba-compiler       # Semantic analysis, type checking, IR lowering, bytecode emission
│   ├── oxvba-runtime        # Variant type, type coercion, built-in functions, VBA-specific allocator
│   ├── oxvba-vm             # Register-window bytecode virtual machine
│   ├── oxvba-jit            # Cranelift-based JIT compilation
│   ├── oxvba-com            # COM abstraction layer (real COM on Windows, traits elsewhere)
│   ├── oxvba-host           # Hosting API, engine orchestration, embedding interface
│   └── oxvba-cli            # Command-line runner and REPL
```

**Dependency graph:**

```
oxvba-syntax          (no internal deps)
    │
    ▼
oxvba-ir              ← oxvba-syntax, oxvba-runtime
    │
    ▼
oxvba-compiler        ← oxvba-syntax, oxvba-ir, oxvba-runtime
    │
    ▼
oxvba-vm              ← oxvba-compiler, oxvba-runtime, oxvba-com
oxvba-jit             ← oxvba-compiler, oxvba-ir, oxvba-runtime, oxvba-com, cranelift-*
    │
    ▼
oxvba-host            ← oxvba-vm, oxvba-jit, oxvba-compiler, oxvba-runtime, oxvba-com
    │
    ▼
oxvba-cli             ← oxvba-host

oxvba-runtime         (no internal deps; defines core types)
oxvba-com             ← oxvba-runtime
```

Design rationale:
- **`oxvba-syntax` is dependency-free** — enables use by external tools (formatters, linters, IDE support) without pulling in the full runtime.
- **`oxvba-ir` is the new multi-level optimization core** — houses the three IR tiers (VbaHir, VbaMir, CfgIr) and all optimization passes. Depends on syntax (for source mapping) and runtime (for type information). This crate embodies the MACH-1000 insight that premature lowering from AST to bytecode/Cranelift loses VBA-specific optimization opportunities.
- **`oxvba-runtime` is dependency-free** — the Variant type, coercion logic, and VBA-specific allocator are foundational; everything else builds on them.
- **`oxvba-vm` and `oxvba-jit` are peers** — either can execute compiled bytecode; the host selects which backend to use. The VM is always available; the JIT is opt-in.
- **`oxvba-host` is the integration facade** — external consumers (DNA Calc, standalone CLI) interact through host, never directly with VM or JIT.

### 2.2 Compilation Pipeline

The pipeline implements progressive lowering through domain-specific intermediate representations, preserving VBA semantics long enough for targeted optimization before committing to low-level execution forms.

```
┌──────────┐    ┌──────────┐    ┌───────────────┐    ┌──────────────┐
│  Source   │───▶│  Lexer   │───▶│    Parser      │───▶│   Semantic    │
│  (.bas,   │    │ (tokens) │    │ (lossless CST) │    │   Analysis    │
│   .cls,   │    └──────────┘    └───────────────┘    │ (binding)     │
│   .frm)   │                                         └──────┬───────┘
└──────────┘                                                  │
                                                              ▼
                                               ┌──────────────────────┐
                                               │     VBA HIR          │
                                               │  (high-level IR)     │
                                               │  For Each, On Error, │
                                               │  implicit coercions, │
                                               │  guarded regions     │
                                               └──────────┬───────────┘
                                                          │ VBA-aware optimizations:
                                                          │ constant folding, dead code,
                                                          │ coercion elimination,
                                                          │ early/late binding resolution
                                                          ▼
                                               ┌──────────────────────┐
                                               │     VBA MIR          │
                                               │  (mid-level IR)      │
                                               │  Explicit IEnum,     │
                                               │  RC boundaries,      │
                                               │  IDispatch calls,    │
                                               │  guarded error edges │
                                               └──────────┬───────────┘
                                                          │ Classic optimizations:
                                                          │ inlining, loop transforms,
                                                          │ register allocation prep
                                                          ▼
                                               ┌──────────────────────┐
                                               │     CFG IR           │
                                               │  (control-flow graph)│
                                               │  SSA form, fully     │
                                               │  expanded control    │
                                               │  flow, explicit      │
                                               │  error edges         │
                                               └──────────┬───────────┘
                                                          │
                                            ┌─────────────┴─────────────┐
                                            │                           │
                                      ┌─────▼─────┐             ┌─────▼─────┐
                                      │  Register  │             │    JIT    │
                                      │  Bytecode  │             │ Cranelift │
                                      │  Emission  │             │ IR (CLIF) │
                                      └─────┬─────┘             └─────┬─────┘
                                            │                         │
                                      ┌─────▼─────┐             ┌─────▼─────┐
                                      │  VM exec   │             │  Native   │
                                      │ (default)  │             │  exec     │
                                      │ reg-window │             │  (opt-in) │
                                      └───────────┘             └───────────┘
```

**Stage 1: Lexing** (`oxvba-syntax`)
- Tokenizes VBA source into a token stream.
- Handles VBA's line-continuation (`_`), line-oriented statements, and context-sensitive keywords.
- Preserves trivia (whitespace, comments) for lossless round-tripping.

**Stage 2: Parsing** (`oxvba-syntax`)
- Hand-written recursive descent parser producing a lossless concrete syntax tree (CST).
- Adopts the Roslyn green/red tree pattern: immutable green nodes (syntax data, relative-width-only, position-independent) with on-demand ephemeral red wrappers (parent pointers, absolute positions computed by summing widths).
- Green tree supports structural sharing — massive deduplication for legacy enterprise VBA modules with repeated patterns.
- Full error recovery: always produces a tree, even for malformed input. Errors are attached to nodes, not thrown.
- Rationale: Hand-written over parser generators for full control over error recovery and error messages (serves Robustness value). Lossless CST enables future IDE tooling without reparsing.

**Stage 3: Semantic Analysis** (`oxvba-compiler`)
- Name resolution (modules, procedures, variables, types, COM references).
- Type checking with VBA's implicit coercion rules.
- Binding of late-bound (IDispatch) vs. early-bound (vtable) calls.
- Resolution of `ByRef` (default) vs. `ByVal` parameter passing.
- Produces a bound tree suitable for lowering to VBA HIR.

**Stage 4: VBA High-Level IR — VbaHir** (`oxvba-ir`)

The highest IR tier, closest to VBA source semantics but in data-flow form. Retains:
- `For Each` over COM collections (not yet expanded to `IEnumVARIANT`)
- Implicit `Variant` coercions (not yet expanded to explicit conversions)
- `On Error GoTo` / `Resume Next` as first-class guarded-region operations (not yet expanded to CFG edges)
- Default property access (not yet resolved to explicit member dispatch)
- Late-bound calls preserved as semantic operations

VBA-aware optimizations at this level:
- **Constant folding** with VBA-specific semantics (Variant-aware)
- **Dead code elimination** (unreachable branches after constant folding)
- **Coercion elimination** (remove redundant coercions when source and target types are known)
- **Early-binding promotion** (promote late-bound calls to early-bound when type information is available)

**Stage 5: VBA Mid-Level IR — VbaMir** (`oxvba-ir`)

De-sugars VBA-specific constructs into explicit operations:
- `For Each` → explicit `IEnumVARIANT::Next` / `IEnumVARIANT::Reset` flow
- Implicit coercions → explicit `CoerceToType` operations
- RC boundaries → explicit `AddRef` / `Release` insertion
- Late-bound dispatch → explicit `IDispatch::GetIDsOfNames` + `IDispatch::Invoke`
- `On Error Resume Next` → guarded operations with explicit success/exception edges (but still within structured regions, not yet fully in CFG form)

Classic optimizations at this level:
- **Inlining** of small procedures
- **Loop-invariant code motion**
- **Common subexpression elimination**
- **Register allocation preparation** (liveness analysis, interference graphs)

**Stage 6: Control-Flow Graph IR — CfgIr** (`oxvba-ir`)

Fully lowered to explicit control-flow graph in SSA form:
- All structured control flow expanded to basic blocks and edges
- On Error regions fully expanded to explicit guarded blocks with success/exception edges
- All operations are primitive (no VBA-specific composite operations remain)
- SSA form enables standard optimization passes

This is the last representation before target-specific lowering.

**Stage 7a: Register Bytecode Emission** (`oxvba-compiler`)
- Emits a custom register-based bytecode format (OxVBA bytecode).
- Register-based design inspired by MMIX — reduces memory traffic versus stack-based bytecodes.
- Bytecode is serializable via `rkyv` for zero-copy memory-mapped loading.

**Stage 7b: JIT Compilation** (`oxvba-jit`)
- CfgIr → Cranelift IR (CLIF) translation.
- Per-function compilation.
- Register-based CfgIr maps naturally to Cranelift's SSA-based register IR — no impedance mismatch.

**Stage 8: Execution** (`oxvba-vm` or native)
- **VM (default):** Register-window interpreter with broadword-accelerated instruction decoding. Always available, no platform-specific dependencies.
- **JIT (opt-in):** Native code execution via Cranelift-compiled functions. Suitable for hot paths and performance-critical workloads.

### 2.3 Key Types: Variant

The `Variant` type is the most performance-critical data structure in the engine. Every VBA value passes through it, and correctness depends on matching VBA/COM semantics exactly.

**Design decision: use COM `VARIANT` layout as the canonical runtime representation**

OxVBA keeps the official `VARIANT` field structure and ABI layout (same `vt` + reserved words + union data model used by COM). This preserves blittable interop expectations and avoids internal/external representation drift.

```rust
#[repr(C)]
pub struct Variant {
    vt: u16,           // VARENUM
    reserved1: u16,
    reserved2: u16,
    reserved3: u16,
    data: VariantData, // COM union payload
}
```

**Supported variant types (canonical COM semantics):**

| VarType | `VARENUM` | Payload model | Notes |
|---|---:|---|---|
| `Empty` | `0x0000` | none | Uninitialized |
| `Null` | `0x0001` | none | SQL Null semantics |
| `Integer` | `0x0002` | `i16` in union | |
| `Long` | `0x0003` | `i32` in union | |
| `Single` | `0x0004` | `f32` in union | |
| `Double` | `0x0005` | `f64` in union | |
| `Currency` | `0x0006` | `CY`/scaled `i64` | |
| `Date` | `0x0007` | `DATE`/`f64` | |
| `String` | `0x0008` | `BSTR` pointer | |
| `Object` | `0x0009` | COM interface pointer | |
| `Error` | `0x000A` | `SCODE`/`i32` | |
| `Boolean` | `0x000B` | `VARIANT_BOOL` (`0` / `-1`) | |
| `Decimal` | `0x000E` | COM decimal overlay rules | |
| `Byte` | `0x0011` | `u8` in union | |
| `LongLong` | `0x0014` | `i64` in union | |
| `LongPtr` | platform | pointer-sized integer | |
| `Array` | flag `0x2000` | SAFEARRAY pointer | ORed with element type |
| `ByRef` | flag `0x4000` | by-ref pointer | ORed with referent type |

**Optional future optimization (explicitly non-canonical):**

We may introduce an alternative internal Variant representation for hot paths only (for example compact 8-byte immediate forms, short-string embedding, indirection for long contents) if and only if benchmark evidence justifies it.

If introduced:
- it remains an internal optimization layer, not the canonical public/runtime `VARIANT`,
- boundary marshalling must be deterministic and lossless,
- formal/conformance evidence must prove semantic equivalence at representation boundaries.

### 2.4 Memory Management

**Primary: Reference counting (COM-compatible)**
- All COM objects use `AddRef`/`Release` reference counting, matching VBA's deterministic destruction semantics.
- `Class_Terminate` is called deterministically when the last reference is released — this is load-bearing VBA semantics that many programs depend on.
- `BStr` (VBA strings) are reference-counted with COM `SysAllocString`/`SysFreeString` on Windows; Rust-managed equivalent on other platforms.

**Weak references:**
- Used internally to break known cycles (e.g., parent ↔ child object relationships).
- Not exposed to VBA user code (VBA has no weak reference concept).

**Opt-in cycle-detecting GC:**
- Implements the Bacon-Rajan cycle detection algorithm as an opt-in safety net.
- VBA programs can create reference cycles (e.g., circular object references) that pure reference counting cannot collect.
- The cycle detector is **scheduled, not concurrent** — runs at configurable trigger points (after N allocations, at idle, or on explicit host request), never interrupting VBA execution mid-statement.
- **Epoch-based batching:** Suspect objects are grouped into epochs. Detection runs process one epoch at a time, amortizing the cost across multiple collection opportunities and bounding worst-case latency per invocation.
- This is one of the few intentional beyond-VBA features: Office VBA leaks cycles silently; OxVBA can optionally detect and collect them.

**Boundary-tag allocator for VBA heap objects:**

Dynamic VBA allocations (BStr strings, SafeArrays, UDT buffers) are served by a purpose-built boundary-tag allocator:
- Each block carries size/status tags at both its start and end.
- On free, adjacent tags are inspected in **O(1)** and blocks are coalesced immediately.
- Reduces fragmentation over long-running workloads typical of Excel automation (macros that run for hours, allocating and freeing thousands of strings).
- Falls back to the system allocator for oversized requests.
- Thread-local arenas per engine instance (no cross-engine contention given STA model).

**Invariants:**
- Reference counts are always non-negative.
- An object with refcount 0 is immediately destroyed (deterministic).
- The cycle detector only collects objects that are unreachable from any root — it never destroys objects that are still reachable.
- The boundary-tag allocator maintains: (a) no overlapping live blocks, (b) every freed block is coalesced with free neighbors, (c) total allocated + free = arena capacity.

### 2.5 COM Abstraction

COM is fundamental to VBA — every object, collection, and class instance is a COM object with `IUnknown` and usually `IDispatch` interfaces.

**Windows (real COM):**
- Use the `windows` crate for COM interop.
- OxVBA objects implement real COM interfaces (`IUnknown`, `IDispatch`, `IConnectionPointContainer`, etc.).
- Host-provided objects (e.g., Excel's `Application`, `Worksheet`) are consumed as real COM objects via their type libraries.
- OxVBA can be hosted as a COM server itself.

**Non-Windows (trait-based abstraction):**
- `ComObject` and `Dispatch` traits define the interface contract.
- OxVBA's own objects (classes defined in VBA code, built-in objects like `Collection`, `Dictionary`) work through pure-Rust trait implementations.
- External COM libraries are not available on non-Windows — the abstraction layer provides clear error surfaces for attempts to use them.
- The cross-platform goal is: all VBA language features and built-in types work everywhere; host-provided and external COM objects are Windows-only unless the host provides cross-platform implementations.

### 2.6 Threading Model

VBA uses the COM Single-Threaded Apartment (STA) model:

- **Single VBA execution thread per engine instance.** All VBA code within one engine runs on a single thread. This is non-negotiable for compatibility — VBA programs assume single-threaded execution.
- **DoEvents** pumps the message queue, yielding the thread to process pending events (UI repaints, timer callbacks, etc.) before returning control to VBA.
- **Multiple engine instances** can run on separate threads (separate apartments), enabling host applications to run multiple independent VBA projects concurrently.
- **Callbacks from host** (event handlers, COM callbacks) are marshaled to the VBA thread via the apartment's message queue.

Rationale: This model exactly matches Office VBA behavior. Attempting to add multithreading within a VBA project would break compatibility with essentially all existing VBA code.

### 2.7 Error Handling

VBA's error handling is fundamentally different from exception-based systems. It uses a per-frame state machine that does not unwind the call stack.

**Error handling modes (per procedure frame):**

| State | Behavior |
|---|---|
| `Default` | No error handler active. Runtime errors propagate to the caller. |
| `On Error GoTo <label>` | Transfers control to the labeled handler within the same procedure. |
| `On Error Resume Next` | Silently continues to the next statement after an error. `Err` object is populated. |
| `On Error GoTo 0` | Resets to Default, disabling any active handler. |
| `Resume` | Retries the statement that caused the error. |
| `Resume Next` | Continues with the statement after the one that caused the error. |

**Key implementation details:**
- Error state is per-procedure-frame, stored on the call stack alongside locals and the return address.
- `On Error Resume Next` does not unwind — it sets a flag and the VM checks it after each statement.
- The `Err` object is a per-engine singleton, populated on error, cleared on successful `Resume` or new procedure entry.
- `GoSub`/`Return` is implemented as intra-procedure control flow (not a procedure call), sharing the same error handling frame.

**IR-level modeling (MACH-1000 innovation):**

`On Error Resume Next` creates irreducible control-flow graphs if naively lowered — every operation would need explicit branch-to-next and branch-to-handler edges, destroying optimization opportunities.

The multi-level IR handles this through staged lowering:

1. **VbaHir:** `On Error Resume Next` is a first-class **guarded-region** operation. A guarded region wraps a sequence of operations; the semantics are "execute each operation; if any faults, populate `Err` and continue to the next." The region is opaque to optimization passes that don't understand error semantics, preserving them for reordering and analysis by passes that do.

2. **VbaMir:** The guarded region is preserved but each operation within it acquires explicit success/exception edge annotations. Error-handler state transitions (`On Error GoTo`, `Resume`, etc.) become explicit state-machine operations.

3. **CfgIr:** Full expansion. For a basic block with operations O₁, O₂, ..., Oₙ under Resume Next, each Oᵢ is lowered to a guarded form with:
   - **success edge** → Oᵢ₊₁
   - **exception edge** → unified exception block (updates `Err.Number`, `Err.Description`, clears exception, continues to Oᵢ₊₁)

By delaying this expansion until CfgIr, the VbaHir and VbaMir passes can freely reorder, fold, and eliminate operations within guarded regions without being dominated by error-handling edges.

---

## 3. Formal Approach

OxVBA uses a three-pronged formal strategy: exhaustive decision tables for finite combinatorial properties, Lean 4 machine-checkable specifications for structural and inductive properties, and Kani bounded model checking for unsafe Rust correctness.

### 3.1 Decision Tables

Decision tables specify the observable behavior of VBA's type system and arithmetic operations as exhaustive, machine-readable matrices.

**Type coercion table (~20 × 20):**
- Rows: source VarType
- Columns: target VarType
- Cells: coercion result (success with target type, or specific error code)
- Validated against Office VBA observation harness

**Arithmetic result type table (~20 × 20 × 15):**
- Dimensions: left VarType, right VarType, operator
- Operators: `+`, `-`, `*`, `/`, `\` (integer div), `Mod`, `^`, `&`, comparison operators, `Like`, `Is`
- Cells: result VarType (or error code)
- Validated against Office VBA observation harness

**Comparison semantics table:**
- Covers `Option Compare Binary` vs `Option Compare Text`
- String vs numeric comparison promotion rules
- `Nothing` comparison rules
- `Null` propagation rules

These tables are:
- **Checked into the repository** as data files (CSV or structured format)
- **Generated from observation harness** runs against Office VBA
- **Used as test oracles** — the implementation must agree with the table for every cell
- **Exhaustive** — every type combination is covered; there are no "don't care" entries

### 3.2 Lean 4 Specifications

Lean 4 provides machine-checkable proofs of structural properties that cannot be captured by finite tables alone.

**Formalization scope:**

| Lean module | What it specifies |
|---|---|
| `VarType.lean` | Inductive definition of the `VarType` universe. Enumeration of all variant types with their properties (numeric?, string?, object?, ordinal size). |
| `Coerce.lean` | Coercion relation as a decidable relation on `VarType` pairs. Proof of transitivity (or documentation of where VBA intentionally breaks transitivity). Proof that the coercion relation is consistent with the decision table. |
| `Arithmetic.lean` | Operator result type as a total function on `(VarType, VarType, Op)`. Proof of consistency with the arithmetic decision table. Proof that numeric promotion is monotone (wider types never narrow). |
| `RefCount.lean` | Reachability invariant: an object is destroyed if and only if it is unreachable from any root. Proof that reference counting maintains the invariant in the acyclic case. Statement of the cycle-detection guarantee. |

**Principles:**
- Lean specifications serve as **Green-team artifacts** (in DNA Calc terminology) — machine-checkable, authoritative, reviewed.
- Lean does not generate Rust code. It is a separate verification artifact that must agree with the decision tables and with the implementation.
- File-based integration: Lean output (proofs, extracted tables) is checked against test oracles in CI.
- The Lean project is self-contained: `lakefile.lean` + `lean-toolchain` in `formal/lean/`.

### 3.3 Kani Bounded Model Checking

Kani provides bounded model checking for Rust code, particularly critical for proving correctness of `unsafe` blocks that the Rust type system cannot verify.

**Verification targets:**

| Target | What Kani proves |
|---|---|
| COM `VARIANT` layout invariants | `vt`/reserved/data fields remain ABI-compatible; union reads/writes preserve alignment/provenance and valid `VARENUM` handling. |
| Variant boundary marshalling (if alt internal repr enabled) | Internal compact representation roundtrips losslessly to canonical COM `VARIANT` at all boundaries. |
| Broadword decoder masks | The SWAR bitmasks cannot mis-detect an opcode byte under any 64-bit input word. No false positives, no false negatives. |
| Register-window bounds | The sliding register window never reads or writes beyond the allocated register file. Spill/fill operations preserve all values. Window shift on call/return is always within bounds. |
| Boundary-tag allocator | No overlapping live blocks. Coalescing never corrupts adjacent blocks. Free-list invariants hold after every operation sequence (up to bounded depth). |
| COM pointer casts | `IUnknown` → `IDispatch` → concrete interface casts preserve pointer provenance and alignment. |

**Integration:**
- Kani proofs run in CI alongside `cargo miri test`.
- Proof harnesses live next to the code they verify (in `#[cfg(kani)]` modules).
- Kani uses symbolic execution up to configurable loop/recursion bounds — not exhaustive, but covers all concrete paths within the bound.

### 3.4 Error Handling State Machine

The VBA error handling model is specified as a finite state machine:

```
States: { Default, HandlerActive, ResumeNext, InHandler, Exiting }
Inputs: { OnErrorGoTo, OnErrorResumeNext, OnErrorGoTo0,
          RuntimeError, Resume, ResumeNext, ExitProcedure }
```

Transitions and observable effects are specified as a state transition table, validated against Office VBA behavior.

### 3.5 Deferred: Verus and Creusot

**Verus** (deductive verification with SMT-backed invariants) and **Creusot** (separation-logic reasoning aligned with Rust ownership) are promising tools for proving deeper properties:
- Verus: coercion matrix correctness (no panics, correct overflow semantics, correct `Err` behavior)
- Creusot: semantic preservation across IR lowering passes

These are deferred until: (a) the Lean specifications are stable, (b) the multi-level IR is implemented, and (c) the tools have matured sufficiently for a project of this scope. The architecture is designed to accommodate them — critical `unsafe` code is isolated into small, well-bounded functions amenable to deductive proofs.

---

## 4. Testing Strategy

### 4.1 Four-Tier Testing

**Tier 1: Unit tests** (per-crate, `cargo test`)
- Standard Rust unit tests for each crate's internal logic.
- Parser tests: token streams, CST shapes, error recovery.
- Variant tests: type coercion, arithmetic, comparison (driven by decision tables).
- IR tests: lowering correctness at each tier (VbaHir → VbaMir → CfgIr).
- VM tests: instruction execution, register-window behavior, control flow.
- Fast, comprehensive, run on every commit.

**Tier 2: Conformance tests** (golden-file comparison against Office VBA)
- VBA source files paired with expected output.
- Executed by both OxVBA and Office VBA; outputs compared.
- Covers: expression evaluation, control flow, error handling, object lifecycle, string operations, array operations, COM interaction patterns.
- Output format: structured (not just stdout) — captures `Err` object state, variable types, reference counts at key points.
- Golden files generated by observation harness and checked into the repository.
- Any difference between OxVBA and Office VBA output is either:
  - A bug in OxVBA (fix it), or
  - A documented intentional divergence (rare; must be justified and tracked).

**Tier 3: Property-based tests** (`proptest`)
- Fuzz-style tests for Variant arithmetic, coercion, parser roundtripping.
- Parser roundtrip property: `parse(source).to_string() == source` for all well-formed inputs.
- Variant arithmetic property: result type matches decision table for all type combinations.
- Refcount property: after executing any sequence of object operations, all objects are either reachable or destroyed.
- IR lowering property: VbaHir → VbaMir → CfgIr → bytecode produces identical execution results for all test programs (semantic preservation).

**Tier 4: Formal verification** (Kani + Miri)
- `cargo miri test` for undefined behavior detection in unsafe code: reference counting, Variant payload access, COM vtable dispatch, FFI boundaries.
- Kani proof harnesses for bounded model checking of critical unsafe invariants (see Section 3.3).
- Run in CI on every commit (Miri) and on PR merge (Kani, which is slower).

### 4.2 Observation Harness

The observation harness is a key piece of infrastructure for the clean-room development approach.

**Purpose:** Systematically observe VBA runtime behavior in Office to produce golden files, decision table entries, and conformance test expectations.

**Design:**
- A VBA project running inside Office (Excel) that exercises specific behaviors and records results.
- Output is structured (e.g., JSON or CSV) for machine consumption.
- Captures: expression results, types, error codes, object lifecycle events.
- Results are checked into the repository as evidence artifacts.
- Harness source code is public and reproducible.

**Evidence workflow** (per Foundation Operations Section 9):
- Each observation is an evidence record: claim ID, source type (observation harness), capture steps, reviewer decision.
- Evidence records are gate inputs for stabilization claims involving compatibility.

---

## 5. Research Notes

### 5.1 VBA 7 Technical Details

**Language characteristics relevant to implementation:**
- **Line-oriented syntax** — statements are line-delimited with `_` line continuation. No semicolons.
- **Case-insensitive** — identifiers are case-insensitive; canonical casing preserved.
- **Context-sensitive keywords** — many keywords (e.g., `Error`, `Name`, `Type`) are valid identifiers in certain contexts.
- **Implicit variable declaration** — unless `Option Explicit` is set, undeclared variables are implicitly `Variant`.
- **ByRef default** — parameters are passed by reference unless explicitly `ByVal`. This is a major semantic difference from most languages.
- **Default properties** — objects can have a default property accessed by using the object reference without a member access. `Set` vs bare assignment distinguishes object assignment from default property assignment.
- **GoSub/Return** — intra-procedure goto with a return stack. Not a procedure call.
- **On Error Resume Next** — non-stack-unwinding error suppression. Per-frame, not global.
- **Deterministic destruction** — `Class_Terminate` is called immediately when the last reference is released, not deferred.
- **Array lower bounds** — arrays can have arbitrary lower bounds (`Dim a(5 To 10)`, `Option Base 1`).
- **Late binding (IDispatch)** — `Dim obj As Object` uses IDispatch for all member access; resolved at runtime.
- **Early binding (vtable)** — `Dim obj As Worksheet` uses vtable dispatch; resolved at compile time with type library.

**VBA 7 specific features (vs VBA 6):**
- `LongPtr` type — pointer-sized integer for 64-bit compatibility.
- `LongLong` type — explicit 64-bit integer.
- `PtrSafe` keyword for `Declare` statements.
- Conditional compilation: `#If VBA7 Then` / `#If Win64 Then`.

### 5.2 Existing Implementations and Prior Art

**twinBASIC** (Wayne Phillips)
- Commercial VBA-compatible language and IDE.
- C++/LLVM-based compiler.
- Targets full VBA compatibility plus language extensions.
- Demonstrates that full VBA compatibility is achievable outside Microsoft.
- We cannot use any twinBASIC code or non-public implementation details (clean-room rule).
- Public talks and documentation are admissible research material.

**ViperMonkey** (Philippe Lagadec)
- Open-source Python-based VBA emulator for malware analysis.
- Partial VBA implementation focused on macro execution.
- Demonstrates: VBA parsing approaches, common patterns in real-world VBA code.
- Limited fidelity — not aiming for full compatibility.

**LibreOffice Basic**
- Open-source Basic interpreter in LibreOffice.
- NOT VBA-compatible — different object model, different runtime behavior.
- Some VBA compatibility mode, but fundamentally different architecture.
- Useful as reference for what challenges arise in Basic runtime implementation.

**pcode2code** (Bonneaud, et al.)
- Open-source tool for decompiling VBA P-code.
- Provides insight into P-code instruction set structure (public research).

### 5.3 Cranelift Analysis

**What Cranelift is:**
- A code generator (compiler backend) written in Rust, developed by the Bytecode Alliance.
- Designed for JIT compilation: fast compile times, reasonable code quality.
- Used by Wasmtime (WebAssembly runtime) as its primary code generator.

**Why Cranelift over LLVM:**

| Factor | Cranelift | LLVM |
|---|---|---|
| Compile speed | Very fast (designed for JIT) | Slow (designed for AOT optimization) |
| Binary size | Small (pure Rust, static link) | Enormous (~100MB+ of libraries) |
| Rust integration | Native Rust crate, no FFI | Requires llvm-sys FFI bindings |
| Code quality | Good (not LLVM-tier optimization) | Excellent (mature optimizations) |
| Dependency footprint | Moderate (Rust crates only) | Heavy (C++ toolchain, linking) |
| Build simplicity | `cargo build` just works | Complex build system, platform issues |
| IR compatibility | Register-based SSA (natural fit for CfgIr) | Register-based SSA (also compatible) |

**Verdict:** Cranelift aligns with values #4 (small runtime) and #5 (well-managed dev env) while providing sufficient code quality for value #3 (performance). LLVM would provide better peak optimization but at unacceptable cost to binary size and build complexity. The MACH-1000 multi-level IR performs domain-specific optimizations that LLVM couldn't do anyway — the final lowering to native code is a thin translation, not where the interesting optimization happens.

**Cranelift integration approach:**
- CfgIr → Cranelift IR (CLIF) translation. Both are register-based SSA — natural mapping.
- Per-function compilation (no whole-program optimization — matches VBA's compilation model).
- JIT mode: compile on first call, cache native code.
- AOT mode: compile all functions ahead of time, serialize native code.

### 5.4 MS-VBAL Specification Notes

The [MS-VBAL] specification defines:
- Lexical grammar (Section 3.3): tokens, whitespace, line continuation, identifier rules.
- VBA module structure (Section 4): modules, procedures, declarations.
- Type system (Section 2.1): built-in types, user-defined types, classes, enums.
- Expression evaluation (Section 5.6): operator precedence, type coercion rules, evaluation order.
- Statement execution (Section 5): control flow, error handling, variable lifetime.
- Project structure: standard modules, class modules, document modules, form modules.
- Conditional compilation (Section 3.4): `#If`, `#Const`, predefined constants.

Implementation requirement clarification:
- OxVBA targets full MS-VBAL scope coverage, including project/module semantics (module naming, visibility, qualification, module/class/document/form categories, and project-level resolution rules).
- Forms/UI-host integration may be deferred by explicit phase policy, but these features remain required scope (not removed scope).
- Normative source material and extracted conformance candidates come from `../Foundation/reference` (see `docs/FOUNDATION_SPEC_REFERENCE.md`), not locally vendored spec snapshots.
- Formal PMR specification baseline:
  - `docs/spec/PROJECT_MODULE_REFERENCE_SPEC_V1.md`
  - `docs/spec/PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.md`
  - `docs/spec/PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md`
  - `docs/spec/PROJECT_MODULE_REFERENCE_HAL_INTEGRATION_V1.md`

Key complexity areas identified:
- The coercion rules (Section 2.1.3) are extensive and have many special cases.
- `ByRef` semantics interact with default properties and type coercion in subtle ways.
- `On Error Resume Next` semantics must be implemented at the statement level, not the expression level.
- Late-bound member access (IDispatch) has complex overload resolution rules.

### 5.5 MLIR and Progressive Lowering

**Why multi-level IR matters for VBA:**

The traditional approach (AST → stack bytecode, or AST → Cranelift IR) creates a semantic gap. VBA has rich domain-specific semantics — COM dispatch conventions, implicit coercion matrices, and unstructured error handling — that are lost when lowered directly to a general-purpose representation. A general-purpose JIT compiler treats code as generic computation, unable to exploit knowledge of VBA's specific patterns.

Progressive lowering, as pioneered by the MLIR project (Lattner et al.), preserves domain semantics at each tier and performs targeted optimizations before committing to lower-level forms. OxVBA implements this concept as a Rust-native three-tier IR (VbaHir → VbaMir → CfgIr) rather than depending on the C++ MLIR framework itself.

**Key insight from the brainstorm:** By delaying the lowering of `On Error Resume Next` until CfgIr, and delaying the expansion of `For Each` and implicit coercions until VbaMir, the VbaHir tier can perform VBA-aware optimizations (coercion elimination, early-binding promotion, constant folding with Variant semantics) that would be impossible at lower tiers.

### 5.6 MMIX and Register-Window Architecture

**Why register-window over stack-based:**

Pure stack VMs incur heavy memory traffic. Every operation requires push/pop churn on the operand stack — even simple expressions like `a + b * c` require 5 stack operations. The MMIX architecture (Knuth, TAOCP) uses a sliding register window:

- Registers 0 to rL−1 are local to the current subroutine.
- Registers rG to 255 are global.
- Calls shift the register window; arguments live in an overlap region.
- Spills to memory happen only when call depth exceeds the physical register file capacity.

In OxVBA's Rust VM, this is emulated with:
- A contiguous register file (array of `Variant`).
- Window base/limit pointers (analogous to MMIX's rO/rS).
- Spill/fill logic for deep call trees.

Result: deep call trees execute with far fewer memory accesses. Most VBA procedure calls involve 0–10 local variables — these fit entirely within the register window, with arguments passed via the overlap region without any memory copies.

### 5.7 Broadword Algorithms (SWAR)

Instead of decoding opcodes byte-by-byte with branch-heavy dispatch tables, broadword (SWAR — SIMD Within A Register) techniques process 8 opcode bytes simultaneously in a single 64-bit word.

For detecting the presence of a target opcode byte `c` in a 64-bit word `x` containing 8 packed opcodes:

```
y = x XOR (c × 0x0101010101010101)
z = (y − 0x0101010101010101) AND (NOT y) AND 0x8080808080808080
```

If z ≠ 0, then `c` appears in `x`.

This enables scanning for Branch/Return/Error patterns in O(1) per 64-bit block, feeding the interpreter with better prefetch and fewer branch mispredictions. Critical for the interpreter fast path where branch prediction is the dominant performance bottleneck.

---

## 6. Design Notes

### 6.1 Parser Design

**Decision: Hand-written recursive descent parser with lossless CST.**

Alternatives considered:
- **Parser generators (LALR, PEG, etc.):** Rejected. VBA's grammar is context-sensitive (keywords as identifiers, line-oriented rules, preprocessor directives). Parser generators struggle with VBA's grammar and produce poor error messages. Error recovery in generated parsers is limited.
- **Tree-sitter:** Considered for IDE use cases but rejected as primary parser. Tree-sitter's C-based runtime doesn't align with pure-Rust goals. Could potentially use tree-sitter grammar as a secondary parser for editor integration in the future.
- **Nom/winnow (parser combinators):** Viable but less control over error messages and recovery than hand-written. For a language with VBA's complexity, explicit control is worth the implementation cost.

**Roslyn green/red tree pattern — enhanced specification:**

**Green tree (storage form):**
- Untyped: nodes carry `SyntaxKind` enum discriminants, not concrete Rust types.
- Strictly immutable and position-independent: no absolute offsets stored.
- Nodes contain only **relative width** (byte count of the subtree's text span).
- Structural sharing: identical subtrees are deduplicated. This is especially valuable for enterprise VBA modules where boilerplate patterns repeat extensively.
- Child sequences stored in tiered containers: `SmallVec<[GreenChild; 4]>` for typical small nodes, spilling to heap `Vec` for large nodes. (Finger-tree-inspired upgrade path reserved for when incremental reparsing demands O(log n) concat/split.)

**Red tree (typed facade):**
- Strongly typed API: each syntax node type has a concrete Rust struct with typed accessors.
- Computes **absolute position** on-demand by summing widths from root.
- Ephemeral wrappers: created on-demand, not persisted. Provides parent pointers, offset/span information, and ergonomic typed traversal.
- No memory overhead when not traversing: the green tree is the only persistent allocation.

Because the underlying structure is immutable, replacing a single node yields a new root that reuses the vast majority of the existing tree — near O(1) allocation for small edits and limited invalidation.

**Combinator-based rewriting:**

Transforms on the lossless syntax tree are expressed as pure functions `CST → CST`, composed using combinators:
- Sequential composition: apply transform A, then B
- Parallel alternatives: run N transforms, score results, select best
- Fixpoint iteration: apply transform until tree is unchanged (T_{k+1} = T_k)

Immutability of the green tree makes speculative, parallel rewrites safe and deterministic. This model supports macro expansion, code generation, and agent-driven patching without full reparses.

### 6.2 Bytecode and VM Design

**Decision: Custom register-based bytecode with MMIX-inspired register-window VM.**

This is the most significant architectural departure from the baseline plan, driven by the MACH-1000 analysis that pure stack VMs have an inherent memory-traffic ceiling.

**Register bytecode format:**

Instructions encode register operands explicitly:

```
ADD  r3, r1, r2       // r3 = r1 + r2 (Variant addition with coercion)
LOAD r1, const[5]     // r1 = constant pool entry 5
CALL r0, proc[3], 4   // call procedure 3 with 4 args starting at r0
```

Compared to stack-based:
```
PUSH r1
PUSH r2
ADD          // implicit: pop 2, push 1
```

The register format:
- Eliminates operand stack push/pop overhead.
- Makes liveness information explicit (registers, not implicit stack positions).
- Maps naturally to Cranelift's register-based IR for JIT compilation.
- Enables broadword scanning for opcode patterns (register operands are in fixed-width fields).

**Register-window VM architecture:**

```
┌────────────────────────────────────────────────────────────────┐
│                     Physical Register File                      │
│  ┌──────┬──────────────┬────────────┬──────────────┬────────┐  │
│  │ ...  │  Caller      │  Overlap   │  Callee      │  ...   │  │
│  │      │  locals      │  (args)    │  locals      │        │  │
│  │      │  r0..r7      │  r8..r11   │  r0..r5      │        │  │
│  └──────┴──────────────┴────────────┴──────────────┴────────┘  │
│          ▲ window_base              ▲ window_base (after call)  │
└────────────────────────────────────────────────────────────────┘
```

- **Window base pointer:** Each procedure frame has a window base. Register r0 in bytecode maps to `register_file[window_base + 0]`.
- **Overlap region:** When procedure A calls procedure B with 4 arguments, A places them in its highest registers. B's window base is set so that B's r0..r3 overlap with A's argument registers. Zero-copy argument passing.
- **Spill/fill:** When the call depth exceeds the physical register file size, the oldest frames are spilled to a spill stack (heap-allocated). On return, they are filled back. Typical VBA call depths (5–20 frames, 5–15 locals each) fit entirely in a 256-register file without spilling.
- **Global registers:** A configurable number of registers (e.g., r240–r255) are global — shared across all frames. Used for frequently accessed engine state (current `Err` object, `DoEvents` flag, etc.).

**Broadword-accelerated dispatch:**

The interpreter main loop uses SWAR techniques for hot-path optimization:
- Opcode + operand fields packed into fixed-width instruction words.
- Broadword scanning used to detect Branch/Return/Error sequences for prefetch hinting.
- Computed-goto dispatch (or match-based dispatch with profile-guided branch hints) for the main opcode switch.

**Zero-copy bytecode serialization:**

Bytecode modules are serialized using `rkyv` (zero-copy deserialization):
- On-disk layout matches in-memory layout exactly.
- Loading a bytecode module: `mmap` the file, validate bounds, cast to typed structures.
- No allocation-heavy decoding phase.
- Near-zero startup latency for large macro corpora.
- The serialized format includes: instruction stream, constant pool, string table, debug info, register allocation metadata.

**Instruction categories:**

| Category | Examples |
|---|---|
| Register operations | `Mov`, `LoadConst`, `LoadEmpty`, `LoadNull`, `LoadNothing` |
| Arithmetic | `Add`, `Sub`, `Mul`, `Div`, `IntDiv`, `Mod`, `Pow`, `Neg` |
| Comparison | `Eq`, `Ne`, `Lt`, `Gt`, `Le`, `Ge`, `Like`, `Is` |
| Logic | `And`, `Or`, `Not`, `Xor`, `Eqv`, `Imp` |
| String | `Concat`, `Mid`, `Len` (may also be built-in function calls) |
| Control flow | `Jump`, `JumpIf`, `JumpIfNot`, `GoSub`, `Return` |
| Calls | `Call`, `CallIndirect`, `CallLate` (IDispatch) |
| Objects | `NewObject`, `SetRef`, `Release`, `GetProp`, `PutProp`, `CallMethod` |
| Arrays | `NewArray`, `ReDim`, `Erase`, `ArrayGet`, `ArrayPut` |
| Error handling | `OnErrorGoTo`, `OnErrorResumeNext`, `OnErrorReset`, `Resume`, `Raise` |
| Conversion | `Coerce`, `CInt`, `CLng`, `CDbl`, etc. |
| Window | `WindowShift` (call), `WindowRestore` (return), `Spill`, `Fill` |

### 6.3 Cross-Platform Story

**Core principle:** The VBA language runtime and all built-in types work identically on all platforms. Platform differences are isolated to COM interaction and hosting.

HAL design note (current stage):
- Platform-sensitive behavior is being consolidated into a dedicated Host Abstraction Layer design track.
- The current HAL draft/spec set is in:
  - `docs/spec/HAL_DESIGN_DRAFT.md`
  - `docs/spec/HAL_INTERFACE_DRAFT.md`
  - `docs/spec/HAL_CONFORMANCE_DRAFT.md`
  - `docs/spec/HAL_PROFILE_MATRIX_DRAFT.md`
  - `docs/spec/HAL_SPEC_WORKING_DRAFT.md`
  - `docs/spec/HAL_SPEC_CROSSWALK.md`
  - `docs/spec/HAL_CONFORMANCE_SUITE.md`
- The model uses five explicit profiles (`windows`, `linux`, `macos`, `wasm`, `null`) and tracks both capability support and capability maturity.
- Current implementation decision: COM activation/dispatch is supported on Windows and explicitly unsupported on non-Windows profiles.

| Feature | Windows | Linux / macOS |
|---|---|---|
| VBA language core | Full | Full |
| Built-in functions (VBA.*) | Full | Full |
| Built-in objects (Collection, Dictionary, etc.) | Full | Full |
| COM object creation (CreateObject) | HAL capability supported | Explicitly unsupported (deterministic error) |
| Type library binding (early binding) | Full (via type libraries) | Deferred |
| Declare (DLL calls) | Full (LoadLibrary) | dlopen equivalent (best-effort) |
| Host-provided objects | Via COM hosting API | Via Rust hosting trait |
| Forms runtime (UserForm) | Native (via COM controls) | Portable rendering (future) |

### 6.4 Integration with DNA Calc

OxVBA is developed in the DNA Calc context, but repository responsibility is bounded: OxVBA provides a host-aware runtime API, while DNA Calc implements application-specific host integration on its side.

- **OxVBA provides:** VBA execution engine, module management, event dispatch, and host-aware registration surfaces.
- **Host provides:** root object graph (for example `Application`) plus additional objects (`Workbook`, `Worksheet`, `Range`, etc.) as COM objects (Windows) or trait implementations (cross-platform).
- **Interaction pattern:** host creates an OxVBA engine instance, registers root host objects, loads VBA project source, and triggers execution (event handlers, macro calls).
- **Object association:** Document modules (e.g., `Sheet1` code-behind) are associated with host objects through the hosting API. Events on host objects (e.g., `Worksheet_Change`) are dispatched to the corresponding VBA event handlers.
- **Mutation model:** VBA macro execution runs in exclusive mutation mode (per Foundation doctrine — no hidden mutation pathways). The host provides a structured operation interface; VBA code modifies the spreadsheet through host-mediated operations, not direct memory access.

Priority note:
- Host-awareness is part of initial OxVBA focus.
- Full DNA Calc application wiring is implemented as DNA Calc-side work, not as a hard dependency for OxVBA phase completion.

### 6.5 Development Innovation

Following the DNA Calc Foundation doctrine, OxVBA aims to innovate in the development process:

- **Observation-driven development:** Systematically observe Office VBA behavior, capture as evidence artifacts, implement against observations, verify conformance.
- **Decision-table-driven implementation:** Type coercion and arithmetic implemented directly from exhaustive decision tables, not from narrative specification text.
- **Formally grounded:** Lean 4 specifications for core properties provide machine-checkable assurance that the type system is coherent. Kani proofs for unsafe code provide bounded correctness guarantees.
- **Regression-as-asset:** Every bug discovered becomes a minimized test case in the conformance corpus (per Foundation Hygiene Doctrine).
- **Documentation as we go:** The development path, decisions, trade-offs, and discoveries are documented contemporaneously, not after the fact.

---

## 7. Proposed Project Structure

### 7.1 Directory Layout

```
OxVba/
├── MACH1000_PLAN.md                    # This document (definitive project plan)
├── CHARTER.md                          # Project mission, scope, and values (authoritative charter)
├── OPERATIONS.md                       # Lightweight execution and development doctrine
├── README.md                           # Project overview, build instructions
├── LICENSE.md                          # MIT license
├── AGENTS.md                           # Execution doctrine for AI agents
├── Cargo.toml                          # Workspace root
├── .gitignore
│
├── synthesis/                          # Synthesis run artifacts
│   ├── README.md                       # Synthesis process documentation
│   └── runs/
│       ├── 20260226-mach1000-synthesis/
│           ├── README.md
│           ├── inputs/
│           ├── analysis/
│           ├── decisions/
│           ├── outputs/
│           └── logs/
│       └── 20260226-mach1000-refinement-synthesis/
│           ├── README.md
│           ├── inputs/
│           ├── analysis/
│           ├── decisions/
│           ├── outputs/
│           └── logs/
│
├── crates/
│   ├── oxvba-syntax/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: parse, SyntaxTree, SyntaxKind
│   │       ├── lexer.rs                # Tokenizer
│   │       ├── parser.rs               # Recursive descent parser
│   │       ├── syntax_kind.rs          # Token and node kinds enum
│   │       ├── green.rs                # Green tree (immutable CST nodes)
│   │       └── red.rs                  # Red tree (typed facade wrappers)
│   │
│   ├── oxvba-ir/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: VbaHir, VbaMir, CfgIr
│   │       ├── hir.rs                  # VBA High-Level IR definitions
│   │       ├── mir.rs                  # VBA Mid-Level IR definitions
│   │       ├── cfg.rs                  # Control-Flow Graph IR (SSA form)
│   │       ├── lower_hir_to_mir.rs     # VbaHir → VbaMir lowering
│   │       ├── lower_mir_to_cfg.rs     # VbaMir → CfgIr lowering
│   │       ├── opt_hir.rs              # VbaHir optimization passes
│   │       ├── opt_mir.rs              # VbaMir optimization passes
│   │       └── opt_cfg.rs              # CfgIr optimization passes
│   │
│   ├── oxvba-runtime/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: Variant, VarType, coerce, builtins
│   │       ├── variant.rs              # COM-compatible Variant (`VARIANT`) representation
│   │       ├── coerce.rs               # Type coercion logic (driven by decision tables)
│   │       ├── arithmetic.rs           # Variant arithmetic (driven by decision tables)
│   │       ├── bstr.rs                 # VBA string type (BSTR-compatible)
│   │       ├── safe_array.rs           # SAFEARRAY-compatible array type
│   │       ├── decimal.rs              # 96-bit Decimal type
│   │       ├── builtins.rs             # Built-in VBA functions (VBA.Strings, VBA.Math, etc.)
│   │       └── alloc.rs                # Boundary-tag allocator for VBA heap objects
│   │
│   ├── oxvba-compiler/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: compile, Module, Bytecode
│   │       ├── resolve.rs              # Name resolution
│   │       ├── typecheck.rs            # Type checking and coercion insertion
│   │       ├── lower_to_hir.rs         # Bound CST → VbaHir lowering
│   │       ├── emit.rs                 # CfgIr → register bytecode emission
│   │       └── bytecode.rs             # Bytecode format definition (rkyv-serializable)
│   │
│   ├── oxvba-vm/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: Vm, execute
│   │       ├── interpreter.rs          # Register-window interpreter loop
│   │       ├── register_file.rs        # Register file and window management
│   │       ├── broadword.rs            # SWAR instruction decoding utilities
│   │       └── error_state.rs          # On Error state machine
│   │
│   ├── oxvba-jit/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: JitEngine, compile_function
│   │       └── cranelift.rs            # CfgIr → CLIF translation
│   │
│   ├── oxvba-com/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: ComObject, Dispatch, IUnknown traits
│   │       ├── refcount.rs             # Reference counting (AddRef/Release)
│   │       ├── dispatch.rs             # IDispatch abstraction
│   │       ├── cycle_gc.rs             # Bacon-Rajan cycle detector (epoch-batched)
│   │       └── platform/
│   │           ├── mod.rs
│   │           ├── windows.rs          # Real COM via `windows` crate
│   │           └── portable.rs         # Trait-based COM on non-Windows
│   │
│   ├── oxvba-host/
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs                  # Public API: Engine, HostConfig, Project
│   │       ├── engine.rs               # Engine lifecycle and orchestration
│   │       ├── project.rs              # VBA project (modules, references, metadata)
│   │       └── events.rs               # Event dispatch (host events → VBA handlers)
│   │
│   └── oxvba-cli/
│       ├── Cargo.toml
│       └── src/
│           └── main.rs                 # CLI entry point: run .bas files, REPL
│
├── formal/
│   ├── lean/
│   │   ├── lakefile.lean               # Lean 4 build file
│   │   ├── lean-toolchain              # Lean 4 toolchain version
│   │   └── OxVba/
│   │       ├── VarType.lean            # VarType inductive definition
│   │       ├── Coerce.lean             # Coercion relation and proofs
│   │       ├── Arithmetic.lean         # Operator result type proofs
│   │       └── RefCount.lean           # Refcount reachability invariant
│   └── kani/
│       └── README.md                   # Kani harness inventory and instructions
│
├── tables/
│   ├── coercion.csv                    # Type coercion decision table
│   ├── arithmetic.csv                  # Arithmetic result type decision table
│   └── comparison.csv                  # Comparison semantics table
│
├── conformance/
│   ├── harness/                        # Office VBA observation harness
│   │   └── ...                         # VBA project files for running in Office
│   ├── golden/                         # Golden output files from Office VBA
│   │   └── ...                         # Structured output (JSON/CSV)
│   └── tests/                          # VBA source files for conformance testing
│       └── ...                         # .bas / .cls files
│
├── docs/
│   ├── README.md                       # Documentation index
│   ├── archive/
│   │   ├── README.md                   # Archive index (superseded documents)
│   │   ├── PLAN_v1_20260226.md         # Original baseline plan (superseded)
│   │   └── BRAINSTORM_MACH1000_20260226.md  # MACH-1000 brainstorm (consumed by synthesis)
│   ├── ARCHITECTURE.md                 # Detailed architecture document
│   ├── BUILDING.md                     # Build and development setup
│   ├── CONTRIBUTING.md                 # Contribution guidelines
│   ├── MACH1000_PLAN_REFINEMENT_20260226.md  # Refinement proposal input for synthesis
│   ├── spec/                           # Early-stage + normative spec docs
│   │   ├── README.md                   # Spec-draft index and maturity states
│   │   ├── HAL_DESIGN_DRAFT.md         # HAL scope/principles/profile plan
│   │   ├── HAL_INTERFACE_DRAFT.md      # HAL contracts + capability/maturity model
│   │   ├── HAL_CONFORMANCE_DRAFT.md    # HAL conformance model and gates
│   │   ├── HAL_PROFILE_MATRIX_DRAFT.md # Per-profile capability planning matrix
│   │   ├── HAL_SPEC_WORKING_DRAFT.md   # Implementation-linked HAL contract and policy semantics
│   │   ├── HAL_SPEC_CROSSWALK.md       # HAL-to-Foundation spec anchor mapping
│   │   ├── HAL_CONFORMANCE_SUITE.md    # Runnable HAL conformance lanes and artifact model
│   │   ├── PROJECT_MODULE_REFERENCE_SPEC_V1.md
│   │   ├── PROJECT_MODULE_REFERENCE_CLAUSE_CATALOG_V1.md
│   │   ├── PROJECT_MODULE_REFERENCE_CONFORMANCE_V1.md
│   │   └── PROJECT_MODULE_REFERENCE_HAL_INTEGRATION_V1.md
│   ├── VARIANT_DESIGN.md               # VARIANT layout and optional internal-repr optimization notes
│   ├── COM_ABSTRACTION.md              # COM layer design
│   ├── BYTECODE_FORMAT.md              # Register bytecode instruction set reference
│   ├── IR_DESIGN.md                    # Multi-level IR design (VbaHir/VbaMir/CfgIr)
│   ├── VM_ARCHITECTURE.md              # Register-window VM and broadword dispatch
│   └── evidence/                       # Clean-room evidence records
│       └── ...
│
└── scripts/
    └── ...                            # Build, CI, and development scripts
```

### 7.2 Workspace Cargo.toml (preliminary)

```toml
[workspace]
members = [
    "crates/oxvba-syntax",
    "crates/oxvba-ir",
    "crates/oxvba-runtime",
    "crates/oxvba-compiler",
    "crates/oxvba-vm",
    "crates/oxvba-jit",
    "crates/oxvba-com",
    "crates/oxvba-host",
    "crates/oxvba-cli",
]
resolver = "2"

[workspace.package]
version = "0.1.0"
edition = "2024"
license = "MIT"
authors = ["DNA Kode"]
repository = "https://github.com/DnaCalc/OxVba"

[workspace.dependencies]
oxvba-syntax = { path = "crates/oxvba-syntax" }
oxvba-ir = { path = "crates/oxvba-ir" }
oxvba-runtime = { path = "crates/oxvba-runtime" }
oxvba-compiler = { path = "crates/oxvba-compiler" }
oxvba-vm = { path = "crates/oxvba-vm" }
oxvba-jit = { path = "crates/oxvba-jit" }
oxvba-com = { path = "crates/oxvba-com" }
oxvba-host = { path = "crates/oxvba-host" }
rkyv = { version = "0.8", features = ["validation"] }
thiserror = "2"
proptest = "1"
```

---

## 8. Implementation Sequencing

This sequence follows Foundation operations discipline: dependency closure first, measurable obligations, and evidence-backed stabilization claims.

### 8.1 Phase Metadata Model

Each phase records:
- **Primary owner track** (`Red`, `Green`, `Logistics`)
- **Estimated duration**
- **Dependencies**
- **Parallelizable tracks**
- **Quantitative gate (Definition of Done)**

### 8.2 Execution Rules

- **MVP-first:** establish a thin end-to-end slice early, before full optimization architecture is enabled by default.
- **Feature-flagged risk:** high-risk performance paths ship behind explicit flags until correctness gates are green.
- **Quantitative milestones:** each phase has measurable gates (coverage/pass-rate/divergence/perf).
- **Evidence discipline:** compatibility claims require reproducible harness outputs and recorded evidence.
- **Recalc mindset:** plan updates treat edits as dirty-marking events that trigger dependency closure and gate updates.

### 8.3 Compatibility Matrix Gates (iterative)

Initial gate dimensions (to be expanded continuously):
- Reference runtime: Office VBA 7.0 and 7.1+
- Architecture: 32-bit and 64-bit behavior-sensitive cases
- Execution backend: VM / JIT / AOT backend
- Platform class: Windows (full COM) and Linux/macOS (core + hosted abstractions)

Initial policy:
- Each phase that changes semantics must add at least one matrix-backed conformance case.
- Matrix breadth grows over time; this is a progressive gate, not a one-shot end gate.

### 8.4 Risk Register (living)

| ID | Risk | Trigger signal | Mitigation | Owner |
|---|---|---|---|---|
| R-001 | Internal Variant layout diverges from COM boundary behavior | Differential failures at COM boundary tests | Keep explicit conversion layer and boundary-specific conformance pack | Red + Green |
| R-002 | `On Error Resume Next` lowering regresses semantics | Err-state divergence in guarded-region corpus | Preserve staged lowering with dedicated semantic-preservation tests | Red |
| R-003 | ByRef/default-property edge cases miscompile | Mismatch in argument mutation or property dispatch tests | Build focused decision-table and conformance corpus for these edges | Red + Green |
| R-004 | Cycle detection or RC lifecycle breaks deterministic destruction | Non-deterministic `Class_Terminate` behavior | Keep cycle GC opt-in and epoch-batched; test deterministic RC path as default | Red |
| R-005 | Broadword/register-window optimizations cause correctness regressions | Flag-on vs flag-off output mismatch | Keep optimizations behind flags until parity gates pass | Red |
| R-006 | Plan drift from Foundation evidence discipline | Claims without linked artifacts | Require synthesis/decision logs for doctrine-impacting plan changes | Logistics + Green |

### 8.5 Phase Plan

### Phase 0: Project Bootstrap and Gate Infrastructure
- Primary owner track: Logistics + Red + Green
- Estimated duration: 1-2 weeks
- Dependencies: none
- Parallelizable tracks: CI wiring, workspace scaffolding, initial formal skeleton
- Work:
- Initialize repository, Cargo workspace, CI pipeline.
- Write CLAUDE.md, AGENTS.md, README.md, LICENSE.
- Set up `cargo fmt`, `cargo clippy`, `cargo miri`, Kani in CI.
- Create all 9 crate stubs (compiling, empty).
- Initial Lean 4 project skeleton and `formal/kani/` README.
- Quantitative gate:
- `cargo check` green for all crates.
- CI runs fmt + clippy + unit tests + miri on at least one target.

### Phase 1: Lexer and Parser (`oxvba-syntax`)
- Primary owner track: Red
- Estimated duration: 3-5 weeks
- Dependencies: Phase 0
- Parallelizable tracks: grammar corpus collection, error-recovery fixtures
- Work:
- Implement lexer with full VBA 7 token set.
- Implement recursive descent parser with lossless CST.
- Green tree with `SmallVec`-based child storage and structural sharing.
- Red tree with ephemeral typed wrappers and on-demand absolute positioning.
- Handle context-sensitive keywords, line continuation, conditional compilation.
- Error recovery: parser always produces a tree.
- Quantitative gate:
- Parse corpus of at least 1,000 real-world modules with zero crashes/panics.
- Roundtrip property tests pass for well-formed corpus slice.

### Phase 2: Core Runtime Types (`oxvba-runtime`)
- Primary owner track: Red + Green
- Estimated duration: 4-6 weeks
- Dependencies: Phase 0
- Parallelizable tracks: observation harness, decision table generation, Lean specs
- Work:
- Implement COM `VARIANT`-compatible `Variant`, coercion/arithmetic tables, `BStr`, `SafeArray`, `Decimal`.
- Implement boundary-tag allocator for VBA heap objects.
- Build observation harness and generate initial decision tables from Office VBA.
- Lean 4: formalize `VarType` and `Coerce`.
- Kani: COM `VARIANT` field/union invariants and boundary marshalling harnesses.
- Quantitative gate:
- 100% filled cells for initial coercion/arithmetic decision tables in scope.
- Kani harnesses for Variant layout/marshalling pass in CI.

### Phase 3: End-to-End MVP Vertical Slice
- Primary owner track: Red
- Estimated duration: 2-4 weeks
- Dependencies: Phases 1-2
- Parallelizable tracks: minimal conformance corpus authoring
- Work:
- Build a thin compile-and-run path (parser -> binding -> minimal bytecode -> execution).
- Support essential statements, arithmetic, and control flow for a small executable subset.
- Quantitative gate:
- At least 50 MVP conformance programs execute end-to-end.
- At least 85% pass rate on MVP corpus with all divergences documented.

### Phase 4: Multi-Level IR Core (`oxvba-ir`)
- Primary owner track: Red
- Estimated duration: 4-6 weeks
- Dependencies: Phases 2-3
- Parallelizable tracks: lowering property tests, IR debug tooling
- Work:
- Define VbaHir, VbaMir, and CfgIr (SSA).
- Implement staged lowering and guarded-region modeling for `On Error Resume Next`.
- Add initial VbaHir optimization passes.
- Quantitative gate:
- Semantic-preservation suite for lowering passes shows zero unexpected divergences on targeted corpus.

### Phase 5: Compiler Core (`oxvba-compiler`)
- Primary owner track: Red
- Estimated duration: 3-5 weeks
- Dependencies: Phase 4
- Parallelizable tracks: bytecode format validation tools
- Work:
- Semantic analysis: resolution, type checking, lowering to VbaHir.
- CfgIr -> register bytecode emission.
- `rkyv`-serializable bytecode format.
- Quantitative gate:
- Compile success for at least 90% of MVP corpus modules in scope.
- Bytecode roundtrip serialization tests pass with validation enabled.

### Phase 6: VM Correctness Baseline (`oxvba-vm`)
- Primary owner track: Red
- Estimated duration: 4-6 weeks
- Dependencies: Phase 5
- Parallelizable tracks: error-state corpus, register-window safety harnesses
- Work:
- Implement register-window interpreter and error handling state machine.
- Implement ByRef register overlap, GoSub/Return, built-in dispatch.
- Quantitative gate:
- Core VM conformance suite (minimum 200 tests) reaches at least 95% pass rate.
- Kani register-window bounds harnesses pass.

### Phase 7: COM/Object System + Host-Aware API (`oxvba-com`, `oxvba-host`)
- Primary owner track: Red
- Estimated duration: 4-7 weeks
- Dependencies: Phase 6
- Parallelizable tracks: Windows COM adapters and portable trait adapters
- Work:
- Reference counting, `IUnknown`/`IDispatch` abstractions, class module lifecycle.
- Collection/Dictionary built-ins and Windows COM integration.
- Engine lifecycle, host object registration, event dispatch, project management.
- Host-aware runtime initialization with root-object injection (`Application`, etc.).
- Quantitative gate:
- Object-lifecycle corpus verifies deterministic destruction behavior.
- Host integration tests cover root-object injection and event dispatch scenarios.

### Phase 8: Forms Runtime Core
- Primary owner track: Red
- Estimated duration: 3-6 weeks
- Dependencies: Phase 7
- Parallelizable tracks: control/event conformance fixtures
- Work:
- Implement UserForm runtime behaviors and control/event wiring in Rust runtime layer.
- Integrate with host abstraction boundaries.
- Quantitative gate:
- Forms runtime suite covers creation, events, and control interaction paths in scope.

### Phase 9: JIT + AOT Backend Capability (`oxvba-jit`)
- Primary owner track: Red
- Estimated duration: 3-5 weeks
- Dependencies: Phases 5-6
- Parallelizable tracks: parity benchmarking and IR translation instrumentation
- Work:
- CfgIr -> CLIF translation and per-function JIT.
- Runtime switching between VM and JIT.
- **AOT backend capability:** compiler/runtime-level native artifact emission.
- Quantitative gate:
- JIT and AOT backend outputs are semantically identical to VM for targeted corpus.

### Phase 10: CLI and Standalone Packaging (`oxvba-cli`)
- Primary owner track: Red + Logistics
- Estimated duration: 2-4 weeks
- Dependencies: Phases 6 and 9
- Parallelizable tracks: packaging scripts and smoke-test automation
- Work:
- CLI execution (`run`) and REPL surfaces.
- **AOT packaging:** produce standalone deliverables from AOT backend artifacts.
- Quantitative gate:
- `oxvba run program.bas` passes smoke suite.
- CLI packaging flow validated on supported target environments.

### Phase 11: Optimization Push and Feature-Flag Graduation
- Primary owner track: Red
- Estimated duration: 4-8 weeks
- Dependencies: Phases 6-10
- Parallelizable tracks: benchmark design and optimization pass tuning
- Work:
- VbaHir/VbaMir/CfgIr optimization expansion.
- Feature-flagged performance paths:
- `mach_broadword_dispatch`
- `mach_zero_copy_bytecode`
- advanced register-window heuristics
- Promotion criteria from experimental to default:
- semantic parity against baseline backend,
- no new UB findings in Miri/Kani lanes,
- measurable benchmark gain.
- Quantitative gate:
- Demonstrate measurable speedup over baseline VM on representative benchmark corpus.

### Phase 12: Conformance and Stabilization
- Primary owner track: Green + Red + Logistics
- Estimated duration: 4-10 weeks (iterative)
- Status: complete for profile scope `mvp-perf-shape-v26` (gate passed on 2026-02-27)
- Gate evidence:
  - `docs/evidence/profiles/v26/matrix_latest.csv`
  - `docs/evidence/profiles/v26/gate_report.md`
  - `docs/evidence/formal/latest_run.md`
  - `docs/evidence/profiles/v26/benchmark_latest.md`
  - `docs/evidence/divergences/README.md`
- Dependencies: all prior phases
- Parallelizable tracks: matrix expansion, divergence triage, documentation finalization
- Work:
- Expand conformance corpus and compatibility matrix breadth.
- Close or document divergences.
- Finalize operational and architecture documentation.
- Quantitative gate:
- Required matrix cells for declared profile scope are green.
- Remaining divergences are explicitly documented with evidence records.

### Phase 13: Full Typing Semantics Closure (Post-v66 Ladder)
- Primary owner track: Red + Green
- Estimated duration: 6-12 weeks (iterative)
- Dependencies: Phase 12 stabilization baseline (`v66`) and existing formal async infrastructure
- Planned profile ladder: `v67..v86`
  - Canonical ladder doc: `docs/worksets/PROFILE_LADDER_2026-02-28_MACH1000_V67_V86_TYPING.md`
- Work:
- Complete full internal VBA typing semantics in scope:
  - declared types, default type rules (`Def*`), type characters,
  - full `Option Explicit` diagnostics and declaration checks,
  - assignment/argument/operator coercion and conversion conformance,
  - full string semantics in declared scope,
  - typed and `Variant` array semantics including non-zero lower bounds and multi-dimensions,
  - early/late binding interaction under typed call sites.
- Formal approach:
- Maintain `F3` profile obligations and run strict Kani as async long-running jobs.
- Use deferred formal gates for non-blocking profile progression while async runs are active.
- Track and reconcile deferred formal runs via:
  - `docs/evidence/formal/DEFERRED_GATES.md`
  - `docs/evidence/formal/latest_run.md`
- Quantitative gate:
- Required type/coercion/string/array matrix cells for `v86` scope are green.
- Deferred formal gates are reconciled (`dg-folded`) or explicitly documented with unblock steps.

### Future (not sequenced):
- Forms Designer.
- Debugging protocol.
- IDE support (language server).
- Additional COM library compatibility on non-Windows.
- Finger-tree child storage for incremental reparsing (when demand materializes).
- Verus/Creusot integration for deductive verification of IR lowering.

---

*This document is the definitive MACH-1000 plan for the OxVBA project, produced by formal synthesis of the baseline plan and theoretical architecture brainstorm, then refined by a follow-up synthesis pass. It captures the project charter, architectural decisions, advanced performance engineering, formal verification strategy, and implementation sequencing. It is a living document that will be updated as the project evolves.*

## Source: `OxVba/README.md`

# OxVBA

OxVBA is a full-fidelity VBA 7 runtime engine in Rust, built for compatibility, correctness, and high performance.

## Core Documents
- `CHARTER.md` — project mission, values, scope, and clean-room rule.
- `OPERATIONS.md` — execution and development doctrine for this repo.
- `MACH1000_PLAN.md` — detailed architecture and phased implementation plan.
- `docs/AUTORUN_STATE.md` — minimal AutoRun control/sync file for the active ladder; current terminal gate target (`v620`); durable progress history lives in `docs/IMPLEMENTATION_LOG.md`.
- `docs/IMPLEMENTATION_LOG.md` — rolling implementation progress log.

## Top-Level Layout
- `crates/` — Rust workspace crates (runtime, compiler, VM, JIT, host, etc.).
- `docs/` — supporting documentation and archived planning inputs.
- `synthesis/` — synthesis workflow docs and run artifacts.
- `scripts/` — local automation (`meta-check`, `docs-check`).
- `formal/` — formal methods assets (Lean/Kani) as they are introduced.
- `conformance/` — conformance tests, harnesses, and golden outputs as they are introduced.
- `tables/` — decision-table artifacts (coercion/arithmetic/comparison) as they are introduced.

## Context
OxVBA is part of the broader DNA Calc program and aligns with Foundation doctrine, while remaining an independent project with its own charter and operations model.

## Quick Verification
```powershell
./scripts/meta-check.ps1 -Fast
./scripts/meta-check.ps1 -Fast -NoArtifacts
./scripts/run-smoke.ps1
./scripts/run-conformance.ps1
./scripts/run-matrix.ps1
```

GitHub check-in CI mirrors the stable local gate:
```powershell
./scripts/meta-check.ps1 -Fast -NoArtifacts
```

Heavier conformance, matrix, and formal lanes are retained for explicit/manual execution rather than every push/PR.

Optional:
```powershell
./scripts/meta-check.ps1 -Fast -Conformance
./scripts/meta-check.ps1 -Fast -Matrix
./scripts/meta-check.ps1 -Fast -Formal
./scripts/meta-check.ps1 -Fast -Conformance -Matrix -Formal
```

Pre-commit guardrails:
```powershell
./scripts/check-staged-commit-scope.ps1
./scripts/validate-profile-artifact-scope.ps1 -Mode staged
```

## Tooling Notes
- Kani is currently not installable via `cargo install kani-verifier --locked` on native Windows in this environment due Unix-only APIs in the installer path.
- Kani is supported through WSL (Ubuntu) on this machine.
- Use `./scripts/run-formal-kani-wsl.ps1` to run strict formal obligations (`-RequireKani`) from Windows by executing Kani commands in WSL.
- For long Kani/profile runs, use `./scripts/run-formal-kani-async.ps1` to manage async execution (`Start`/`Status`/`Tail`/`Wait`/`Stop`).

