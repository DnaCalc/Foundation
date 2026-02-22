# 05_rust_engine_architecture_review

## Source-of-truth check
| Check | Result |
|---|---|
| Contradictions across CHARTER/OPERATIONS/ARCHITECTURE/BRAINSTORM | No hard contradictions found for this prompt. |
| Tension to resolve | Throughput vs determinism in multithreaded eval/UDF execution. |
| Coherent resolution | Keep deterministic mode as a first-class scheduler policy (required for packs/minimization), and allow a separate throughput mode only where profile/capability negotiation permits it. |

## Conformance-first Rust engine design

### Component diagram
```text
                +--------------------------------------+
Client/API ---> | Protocol Surface (version negotiation)|
                +-------------------+------------------+
                                    |
                                    v
                          +-------------------+
                          | Coordinator       |
                          | (single mutator)  |
                          +---+-----------+---+
                              |           |
                ops/tx apply  |           | queries/subscriptions
                              v           v
                    +----------------+   +----------------------+
                    | Snapshot Store |   | Delta Publisher      |
                    | epoch-indexed  |   | (events + backpressure)
                    +---+--------+---+   +----------+-----------+
                        |        |                    |
                        |        +-------> CalcDeltas stream
                        |
                        v
              +-----------------------+
              | Scheduler/Planner     |
              | invalidation + DAG    |
              +-----+------------+----+
                    |            |
                    |            +------------------------------+
                    v                                           v
          +-------------------+                         +--------------------+
          | Worker Pool       |                         | Serialized UDF Lane|
          | (thread-safe work)|                         | (non-thread-safe)  |
          +---------+---------+                         +---------+----------+
                    |                                             |
                    +------------------+--------------------------+
                                       v
                            +----------------------+
                            | Result Reducer/Merger|
                            | epoch-aware dropstale|
                            +-----------+----------+
                                        |
                                        v
                              +------------------+
                              | Caches           |
                              | graph/value/plan |
                              +------------------+
```

## Data ownership and locking rules
| Area | Owner | Mutation rule | Locks allowed | Locks forbidden |
|---|---|---|---|---|
| Op intake + transaction ordering | Coordinator task | Only coordinator assigns op order and `committed_epoch` | Channel internals only | Any external component mutating order/epoch |
| Document state (pre-snapshot builder) | Coordinator | Mutated only during op/tx apply | No shared lock required (single owner) | Shared `Mutex/RwLock` around core doc state |
| Snapshots (`Arc<DocSnapshot>`) | Snapshot store | Immutable after publish | Lock-free reads; brief index lock for insert/evict | In-place mutation of published snapshots |
| Dependency graph cache | Coordinator (write), workers (read) | Rebuilt/updated at epoch boundaries only | Sharded `RwLock` or epoch swap pointer | Write from workers |
| Value cache | Reducer writes, readers query | Writes tagged by target epoch, atomically installed | Sharded lock or atomic map swap | Global coarse lock for full workbook |
| UDF registry metadata | Coordinator (registration), workers (read) | Versioned immutable view per epoch | Read-only snapshot pointer | Runtime mutation without epoch bump |
| Event subscribers | Delta publisher | Append/remove subscription entries | Lock on subscriber list only | Holding subscriber lock during network/UI callback |

Lock discipline (hard rules):
- Never hold a lock across `.await`.
- Never call user code (UDF/plugin callback) while holding engine internal locks.
- Coordinator-to-worker communication is message passing, not shared mutable state.
- If two locks are unavoidable, fixed order is `snapshot_index -> cache_shard`; reverse order is disallowed.

## Epoch flow and stale/pending representation
### Epoch lifecycle
1. Coordinator receives ops/transaction and validates profile + capabilities.
2. Coordinator applies ops to mutable builder and publishes immutable snapshot `E` (`committed_epoch = E`).
3. Scheduler computes invalidation closure for `E` and emits eval tasks.
4. Workers evaluate against snapshot `E` only; each result carries `value_epoch = E`.
5. Reducer merges results:
   - installs values for `E` when still current,
   - drops stale task outputs if superseded by newer epoch.
6. When all required tasks for `E` are resolved, coordinator marks `stabilized_epoch = E` and emits stabilization delta.

### State model exposed to UI/API
```text
Fresh(value_epoch = committed_epoch, pending = false)
Stale(value_epoch < committed_epoch, pending = true|false)
Pending(target_epoch = committed_epoch, reason = Eval|Udf|External)
Error(code, deterministic_diagnostic, value_epoch)
```

Key behavior:
- Reads may return stale values, but must include explicit status and epochs.
- Pinned reads bind to a chosen epoch and never observe mixed epochs.
- If epoch `E+1` commits before `E` stabilizes, `E` may remain partially pending while new work starts; stale tagging remains explicit.

## UDF execution strategy (determinism-safe)
### Execution lanes
- Thread-safe UDFs: run on worker pool with bounded parallelism.
- Non-thread-safe UDFs: run on a dedicated serialized executor (single lane).

### Determinism policy
- Deterministic mode (required for conformance packs):
  - Stable topological batch order.
  - Stable tie-breaker (`cell_id`, then registration order).
  - Serialized lane preserves call order exactly.
  - Volatile/time/random UDFs only via explicit profile policy and deterministic seeded oracle when required.
- Throughput mode:
  - Parallel scheduling can vary, but result merge remains epoch-gated and never violates snapshot consistency.

### Async UDF rule
- Async completion is reified as an explicit external-update op that creates a later epoch, instead of mutating in-place inside the current epoch. This preserves replayability and deterministic traces.

## Top performance risks and early instrumentation
| Risk | Failure shape | Early instrumentation |
|---|---|---|
| Invalidation closure blow-up | Superlinear recompute on structural edits | Per-epoch counters: impacted nodes/edges, closure time histogram |
| Cache contention | Throughput collapse under multithread load | Lock wait time, shard contention, cache hit ratio |
| Work imbalance | Long tails, delayed stabilization | Queue depth, worker utilization, steal count, p95/p99 task duration |
| UDF tail latency | Pending storms and stale UI | UDF lane latency histogram by function, timeout/slow-call diagnostics |
| Snapshot retention pressure | Memory growth from pinned epochs | Live snapshot count, pinned-age histogram, bytes per epoch |
| Delta fanout pressure | Backpressure and dropped subscribers | Subscriber lag, dropped event counter, publish latency |

Minimum telemetry to wire on day 1:
- `tracing` spans per pipeline phase: `apply_ops`, `build_snapshot`, `closure`, `schedule`, `eval`, `merge`, `publish`.
- Metrics: `committed_epoch`, `stabilized_epoch`, `epoch_lag`, `stale_cell_count`, `pending_cell_count`, `dropstale_result_count`.
- Perf-signature harness aligned with `PACK.scaling.signature` workloads for slope tracking from the first implementation.

## Spec sharpeners (exact edits to reduce implementation ambiguity)
- `ARCHITECTURE_AND_REQUIREMENTS.md` -> `3.3 Epoch Model`: add normative state enum and required API fields (`committed_epoch`, `stabilized_epoch`, `value_epoch`, `status`).
- `ARCHITECTURE_AND_REQUIREMENTS.md` -> `3.6 External UDFs / XLL-like integration`: add mandatory scheduler semantics for thread-safe vs serialized UDF lanes and deterministic mode ordering rules.
- `ARCHITECTURE_AND_REQUIREMENTS.md` -> `4. Architectural Constraints`: add lock-discipline constraint (`no lock across await`, `no user callback under lock`).
- `OPERATIONS.md` -> `4.1 Packs`: add a dedicated pack for scheduler determinism + UDF lane conformance (e.g., `PACK.concurrent.udf_determinism`).

## Smallest next actions with highest risk reduction
1. Freeze the epoch/status wire contract in the protocol schema and add conformance assertions immediately.
2. Implement coordinator + immutable snapshot store + drop-stale reducer before optimizing scheduler heuristics.
3. Land dual UDF lanes (thread-safe pool + serialized lane) with deterministic-mode ordering tests.
4. Add phase spans and epoch lag metrics before scaling work begins.
