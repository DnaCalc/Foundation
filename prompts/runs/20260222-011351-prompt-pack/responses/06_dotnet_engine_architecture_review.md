*Posted by Codex agent on behalf of @govert*

# 06 dotnet engine architecture review

## Source-of-truth check and conflict handling
No hard contradictions were found across `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `notes/BRAINSTORM_NOTES.md`.

The following tensions will cause divergent implementations if left unresolved:

| Tension | Where it appears | Proposed single resolution |
|---|---|---|
| Determinism vs parallel evaluation order (especially floating-point reductions) | `ARCHITECTURE_AND_REQUIREMENTS.md` 3.4, `notes/BRAINSTORM_NOTES.md` N | Define profile-level numeric reduction policy: deterministic left-fold in conformance mode; optional fast parallel reduction only in non-conformance mode and explicitly labeled. |
| Pathfinder UDF boundary (range I/O, async continuation scope) | `ARCHITECTURE_AND_REQUIREMENTS.md` 3.6, `notes/BRAINSTORM_NOTES.md` N | Freeze Pathfinder to scalar outputs, scalar + bounded range inputs, no async continuation completion into same epoch. |
| External oracle behavior under collaboration (local vs shared RTD semantics) | `ARCHITECTURE_AND_REQUIREMENTS.md` 3.9, `notes/BRAINSTORM_NOTES.md` N | For Round 0, make STREAM/RTD local-oracle only; collaborative shared-oracle is deferred and must be a separate profile capability bit. |

## 1) .NET architecture plan (independent compiler mindset)
Goal: mirror protocol surfaces exactly while using idiomatic .NET concurrency and remaining independently implementable from Rust.

```text
Adapters/Protocol
  -> Protocol Gateway (version/capability negotiation)
  -> Mutation Coordinator (single-writer op intake)
  -> OpLog + Snapshot Store (immutable epoch snapshots)
  -> Dirty Closure + Scheduler (epoch-scoped work plans)
  -> Worker Lanes (calc, UDF-threadsafe, UDF-serialized)
  -> Delta Committer (stale/pending/value_epoch tagging)
  -> Event Stream (subscriptions, checkpoints, diagnostics)
```

### Component choices
- `ProtocolGateway`
  - Validates protocol version and capability manifest.
  - Converts wire commands to internal `EngineCommand`.
- `MutationCoordinator` (single writer)
  - `Channel<EngineCommand>` input.
  - Only this component can advance `committed_epoch`.
  - Enforces `CONSTR-001` (no hidden mutation paths).
- `SnapshotStore`
  - Immutable snapshot objects (`record` + pooled arrays).
  - Epoch pinning handles for consistent reads.
  - Atomic pointer swap when new epoch is committed.
- `Scheduler`
  - Builds deterministic work plan from dirty closure.
  - Uses stable `NodeId` ordering as canonical tie-break.
- `Worker lanes`
  - Calc lane: parallel tasks for pure formula nodes.
  - UDF thread-safe lane: bounded parallelism.
  - UDF serialized lane: single-thread executor.
- `DeltaCommitter`
  - Produces `CalcDelta` with `value_epoch`, `stale/pending`, diagnostics.
  - Drops obsolete results if epoch advanced.
- `EventStream`
  - `IAsyncEnumerable<EngineEvent>` for subscribers.
  - Includes deterministic replay metadata IDs.

### .NET concurrency patterns
- `System.Threading.Channels` for command and update ingestion.
- `Task`/`ValueTask` for async boundaries.
- `Parallel.ForEachAsync` or custom bounded scheduler for pure eval batches.
- `CancellationToken` tied to epoch supersession.
- Immutable data + atomic publication, not coarse locks.

## 2) Top 10 spec ambiguity traps

| # | Ambiguity trap | Why it will diverge | Needed spec sharpening |
|---|---|---|---|
| 1 | Floating-point aggregation order | Parallel evaluators yield different rounding | Profile rule for reduction order in conformance vs perf modes |
| 2 | Volatile function recalc triggers | Manual/auto/partial recalc semantics differ by engine defaults | Explicit trigger matrix by mode and epoch transition |
| 3 | Structural edit identity rules | A1-based identity causes rewrite differences | Stable object/cell identity requirements + rewrite precedence |
| 4 | Error precedence | Mixed error sources produce inconsistent visible results | Deterministic error ordering table |
| 5 | UDF type coercion | .NET and Rust runtime conversions differ | Exact coercion and null/blank/error mapping rules |
| 6 | UDF cancellation semantics | Late completion may commit stale values | Rule: epoch-bound tokens and mandatory stale-drop behavior |
| 7 | STREAM topic lifecycle | Duplicate or out-of-order external updates behave differently | Topic identity, dedupe key, and ordering contract |
| 8 | Snapshot pin GC policy | Readers may see reclaimed caches or unbounded memory | Pin lifetime contract + retention ceilings |
| 9 | Capability downgrade behavior | Unknown features may be rejected vs opaque-preserved | Mandatory Native/Lowered/Opaque/Rejected matrix |
| 10 | Deterministic mode scope | Some subsystems stay nondeterministic | Enumerate deterministic guarantees per subsystem (scheduler, UDF lane, external updates, clocks) |

## 3) Deterministic mode and schedule-sensitive bug reproduction

### Deterministic mode
- Fixed scheduling:
  - Stable topological order, tie-break by `NodeId` then `SheetId` then `CellId`.
- Fixed numeric policy:
  - Deterministic reduction for non-associative floating operations in conformance mode.
- Fixed external inputs:
  - STREAM/UDF results from recorded timeline files.
- Fixed runtime entropy:
  - Seeded hash/random sources, frozen logical clock.
- Fixed publication rules:
  - Delta emission sorted by deterministic key.

### Reproducing schedule-sensitive bugs
- Record every run as an execution trace:
  - op IDs, epoch transitions, task spawn/finish, queue dequeue order, cancellation points.
- Replay runner:
  - consumes trace + schedule script and enforces exact interleaving.
- Delay/fault injection points:
  - before dependency read, before commit, before UDF completion callback.
- Minimization:
  - shrink failing trace by operation deletion, then schedule simplification while preserving failure.
- Output artifact:
  - one zipped repro bundle usable by OCaml/.NET/Rust runners.

## 4) Minimal internal IR/data layout (performance-safe)

### Core representation
- `CellId`/`NodeId`: dense 32-bit IDs, stable across recalcs.
- `ExprIR`: interned compact AST/bytecode per formula.
- `DepGraph`: CSR-style adjacency arrays for fast closure and cache-friendly traversal.
- `ValueStore`: typed columnar arrays per sheet region (number, text, bool, error, blank tags).
- `DirtySet`: bitsets keyed by `NodeId`.
- `EpochState`: immutable header + references to pooled arrays.

### Why this is minimal and acceptable
- Dense IDs avoid string-heavy A1 addressing internally.
- CSR + bitsets keeps invalidation closure fast.
- Interned IR reduces allocation churn and speeds equality/caching.
- Immutable epoch headers keep snapshot pinning simple and safe.

## 5) Triangulated test strategy: OCaml oracle vs .NET vs Rust

### Test pyramid
- Level 0: Schema/protocol conformance
  - All three consume the same trace/snapshot formats.
- Level 1: Deterministic golden traces
  - Same input traces; compare checkpoints (`value`, `error`, `value_epoch`, `stale/pending`, diagnostics).
- Level 2: Differential generation
  - Property-generated operation sequences; oracle is tie-break reference.
- Level 3: Schedule stress
  - Deterministic replay with adversarial interleavings.
- Level 4: Scaling signatures
  - Compare slope trends and detect algorithmic regressions.

### Mismatch triage rules
- OCaml != (.NET and Rust agree): open spec ambiguity review (Green triad).
- .NET != (OCaml and Rust agree): Blue bug until disproven.
- Rust != (OCaml and .NET agree): Red bug until disproven.
- All three differ: schema/spec gap or invalid test fixture.

### Pack mapping
- `PACK.concurrent.epochs`: replay + stale-drop + exclusive mutation checks.
- `PACK.udf.basic`: coercion matrix + thread-safe/serialized lane behavior.
- `PACK.stream.basic`: topic lifecycle ordering + deterministic replay.
- `PACK.scaling.signature`: slope capture with deterministic workload seeds.

## Proposed doc edits (exact headings)

| File | Heading to edit | Edit |
|---|---|---|
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `3.4 Calculation Engine Pipeline (conceptual)` | Add deterministic ordering requirements and numeric reduction policy hooks by profile. |
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `3.6 External UDFs / XLL-like integration` | Freeze Pathfinder UDF scope (coercion table, range input bounds, no async continuation commit). |
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `3.3 Epoch Model (MVCC-style)` | Specify pin/unpin lifecycle and retention/GC guarantees. |
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `3.5 External Streaming and RTD-like Behavior` | Define topic identity/dedupe/order contract and replay format requirement. |
| `OPERATIONS.md` | `4.1 Packs` | Add explicit cross-engine triangulation exit criteria per pack. |

## Smallest next actions (highest risk reduction)
1. Freeze deterministic mode contract text in `ARCHITECTURE_AND_REQUIREMENTS.md` sections 3.3/3.4/3.5/3.6.
2. Define a single canonical trace schema used by OCaml/.NET/Rust runners.
3. Implement Blue deterministic scheduler + trace recorder before parallel perf work.
4. Land `PACK.concurrent.epochs` first with replay-based regression fixtures.
5. Run first three-way differential batch and open ambiguity tickets for every non-bug mismatch.