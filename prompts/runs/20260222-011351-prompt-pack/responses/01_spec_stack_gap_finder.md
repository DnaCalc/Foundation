# Round 0 Missing Pieces Report (DnaVisiCalc)

## Contradictions / ambiguity collisions and single resolution

| ID | Observation | Why it blocks execution | Coherent resolution |
|---|---|---|---|
| C-01 | `stabilization` is overloaded: runtime calc state (`stabilized_epoch`) vs release gate state (profile stabilized/green). | Teams can ship with different meanings of “stable.” | Split terms: **CalcStabilized(epoch, scope)** for runtime; **ProfileGreen(profile_id, profile_version)** for release gate. Reserve `meta-epoch` for the latter only. |
| C-02 | Pathfinder UDF scope is partly open (`optional range inputs`, async continuations open question). | Lean/OCaml/TLA+ packs cannot be finalized without fixed surface. | Round 0 freeze: UDF inputs = scalar + rectangular range, outputs = scalar only, no async continuation, metadata only `volatile` + `thread_safe`. |
| C-03 | Structural-edit scope is implied as broad, but proof target says “one disruptive rewrite.” | Scope creep into full Excel rewrite semantics. | Round 0 freeze to **one operation**: `InsertRow` rewrite semantics only. Defer all other structural transforms. |

## 1) Minimum semantic features required for a meaningful Pathfinder

Ruthless minimum semantic contract for Round 0:

| Area | Must-have semantic feature | Hard cut line |
|---|---|---|
| Value model | `Number`, `String`, `Bool`, `Blank`, `Error` plus deterministic coercion/error propagation rules. | No date-system quirks, no array spill semantics, no locale-dependent coercion. |
| Formula core | Literal expressions, cell refs, range refs, function-call form, and a small fixed function set sufficient to prove dependency + recompute behavior. | No long-tail Excel compatibility surface. |
| Dependency semantics | Deterministic dependency extraction and invalidation closure over cell/range refs and oracle nodes (`STREAM`, UDF callsites). | No volatile-function zoo beyond UDF volatility flag. |
| Recalc semantics | Manual vs auto recalc behavior, with explicit trigger rules and visibility guarantees. | No advanced calc chain heuristics/prioritization policies. |
| Epoch semantics | Normative meanings for `committed_epoch`, `stabilized_epoch`, `value_epoch`; stale/pending status lattice exposed in API/UI. | No partial-workbook stabilization policies beyond a single initial policy. |
| External STREAM | `STREAM(topic)` modeled as replayable external-update ops with deterministic topic/value timeline in conformance runs. | No full RTD topic lifecycle semantics. |
| External UDF subset | Registration contract + invocation semantics with deterministic oracle contract in spec/proofs. | No XLL ABI/lifetime/marshalling compatibility. |
| Structural rewrite | Exactly one atomic structural edit (`InsertRow`) with reference rewrite semantics + one proof target. | No full row/column/table/name rewrite matrix. |
| Error/unsupported policy | Deterministic `Unsupported`/`OpaquePreserved` outcomes; never crash. | No broad degrade matrix across all Excel features yet. |

A meaningful pathfinder is achieved when these semantics are executable in OCaml, constrained in TLA+, and partially proven in Lean, then matched by at least one engine through packs.

## 2) Underspecified terms with crisp definitions

| Term | Proposed crisp definition |
|---|---|
| `profile` | A named, versioned semantic contract: formula semantics, recalc semantics, supported feature classes, degrade rules, and required packs. |
| `profile_version` | Monotonic semantic version for a profile; any breaking behavior change requires a version bump. |
| `feature gate` | A profile-level switch that either enables normative semantics or routes to defined degrade behavior. |
| `op` | The smallest persistent state mutation record in the OpLog. |
| `transaction` | Ordered set of ops that commits atomically to one new `committed_epoch`. |
| `committed_epoch` | Monotonic document-state version after an atomic transaction commit. |
| `stabilized_epoch` | Highest committed epoch for which required derived values are computed for the declared scope. |
| `value_epoch` | Epoch at which a specific derived cell value was computed. |
| `stale` | `value_epoch < committed_epoch` and no in-flight computation claim that this value is final for current epoch. |
| `pending` | The system has accepted dependencies requiring recompute for the current epoch, and completion has not yet been committed. |
| `CalcStabilized` | Runtime condition: for scope `S`, all required derived nodes at epoch `E` are committed and not pending. |
| `ProfileGreen` | Release condition: all required packs for `(profile_id, profile_version)` pass and artifacts are emitted. |
| `meta-epoch` | Versioned release snapshot of profile + required pack results + capability manifests (project/process state, not workbook calc state). |
| `deterministic mode` | Execution mode with fixed scheduling/reduction choices and replayable oracle inputs, required for conformance/minimization. |
| `obligation pack` | Computed, named check bundle required to claim `ProfileGreen`. |
| `capability manifest` | Machine-readable declaration of supported profiles/protocol versions/features and latest pack outcomes. |
| `lowered` | Feature represented via semantics-preserving translation to supported constructs. |
| `opaque` | Feature data preserved and round-tripped but not executed semantically by the engine. |
| `rejected` | Feature not accepted for execution/load under active profile; deterministic diagnostic required. |

## 3) Ranked spec modules to write first (L0/L1/L2/L3/L4/L7)

### Rank order (with dependencies)

| Rank | Module | What it must contain | Depends on |
|---|---|---|---|
| 1 | **L0: Semantic Kernel & Glossary** | Normative state model, epoch/status vocabulary, op/transaction model, deterministic-mode contract. | None |
| 2 | **L1: Formula Core Semantics** | Expression/value/error semantics, coercion rules, minimal function core, reference/range semantics. | L0 |
| 3 | **L2: Dependency + Recalc Semantics** | Dependency extraction, invalidation closure, manual/auto triggers, recompute commit rules. | L0, L1 |
| 4 | **L3: Epoch and Concurrency Protocol** | Commit/stabilize rules, stale/pending transitions, exclusive mutation rule, stale-commit prohibition invariants. | L0, L2 |
| 5 | **L4: External Oracles + Structural Rewrite** | `STREAM` op semantics, UDF subset contract, single structural rewrite (`InsertRow`) semantics. | L1, L2, L3 |
| 6 | **L7: Conformance/Gates Spec** | Pack mapping (Lean/TLA+/OCaml/engine), pass criteria, artifact schema, `ProfileGreen` decision rule. | L0-L4 |

### Dependency sketch

```text
L0 -> L1 -> L2 -> L3 -> L4 -> L7
          \--------------->/
```

### Why this order is minimal-risk

- L0 prevents term drift before any proof/model work.
- L1/L2 are the smallest executable semantic spine for OCaml oracle.
- L3 must precede meaningful TLA+ invariants and stale-state UI guarantees.
- L4 is where scope explodes; fixing it after L3 keeps it bounded.
- L7 last ensures gates reflect real semantics, not placeholders.

## 4) Non-goals to state explicitly for DnaVisiCalc

1. Full Excel formula/function compatibility is out of scope.
2. Full RTD semantics and topic lifecycle parity are out of scope (`STREAM` subset only).
3. Full XLL ABI compatibility (marshalling, memory/lifetime, async continuations) is out of scope.
4. VBA runtime/editor integration and COM automation are out of scope.
5. Full OOXML fidelity and full degrade matrix are out of scope (only minimum preserve/degrade rules needed for tested subset).
6. Collaboration semantics beyond an OpLog seam are out of scope.
7. Performance tuning beyond baseline correctness and determinism evidence is out of scope.

## Exact doc edits to remove ambiguity fast

- `CHARTER.md` add `## 5.1 Stabilization Terms` with `CalcStabilized` and `ProfileGreen` definitions.
- `ARCHITECTURE_AND_REQUIREMENTS.md` add `## 6.1 Round 0 Normative Semantic Contract` (L0-L4 cut lines).
- `ARCHITECTURE_AND_REQUIREMENTS.md` add `### 3.3.1 Epoch Status Lattice` (committed/stabilized/value/stale/pending transitions).
- `OPERATIONS.md` add `## 4.3 PACK.visicalc.core Required Contents` and explicit `ProfileGreen` artifact checklist.
- `OPERATIONS.md` add `## 3.3 Terminology Guardrails` to disambiguate runtime stabilization vs release stabilization.

## Smallest next actions (highest risk reduction)

1. Freeze L0 glossary and epoch/status lattice first; reject further module drafting until merged.
2. Freeze Round 0 UDF/STREAM/InsertRow cut lines in L4 as explicit non-goals + invariants.
3. Define `PACK.visicalc.core` pass/fail contract in L7 with exact artifacts (Lean theorem IDs, TLA+ invariant IDs, OCaml trace schema).
4. Run one end-to-end exemplar trace (op -> recalc -> stale clear) as the canonical conformance seed.
