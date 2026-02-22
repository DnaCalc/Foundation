# Run 2 — Concurrency protocol and MVCC epochs for DNA Calc

## Concurrency pillar: target semantics and scope framing

DNA Calc’s concurrency/event-processing pillar is explicitly shaped around three hard boundaries—**OpLog → DocSnapshot → CalcDeltas**—with a versioned/epoch model where **inputs are truth and derived values are caches**. fileciteturn0file1 The core concurrency goal is therefore not “prevent staleness”, but “make staleness **detectable**, **monotone**, and **non-corrupting**,” while allowing parallel evaluation and out-of-order completion. fileciteturn0file1

The project’s “MVCC-style” contract (even though this is not a database) is: the system advances a **committed epoch** when document changes (ops/transactions) are accepted, and advances a **stabilized epoch** when derived computation is complete (for a declared scope). Each value/delta is tagged with `value_epoch` and explicit status (ready/pending/error + stale visibility relative to committed). fileciteturn0file1 This is paired with snapshot pinning and GC policies: clients can request a consistent read pinned to an epoch while newer epochs progress; pinned epochs constrain garbage collection. fileciteturn0file1

The concurrency protocol’s “must not fail” invariants are already sketched in your architecture notes: **no stale commit** (a derived result may commit only if produced against the same epoch it claims), explicit stale/pending signaling, and **exclusive mutation** for structural edits (no overlapping structural mutation commit windows). fileciteturn0file1 This protocol discipline is also operationally enforced by the project’s doctrine: deterministic modes are required for debugging and regression minimization, and concurrency/TLA+ checks are intended to be obligating pack gates (e.g., `PACK.concurrent.epochs`). fileciteturn0file2turn0file3

In practice, this looks like an **epoch-tagged task graph**: ops advance the epoch; background tasks evaluate against a specific immutable snapshot; results are “fenced” by epoch so that late completions cannot overwrite newer epochs; stabilization advances when the “frontier of unfinished work” for an epoch collapses to empty. This is the same family of ideas used in (a) generation counters / fencing tokens, (b) snapshot caches with revision numbers, and (c) logical-time dataflow systems that provide “completion notifications” once all work for a timestamp has been observed. fileciteturn0file1turn19view0turn9view0turn25view0turn12view0

## Best sources and exemplars

1. **entity["book","Specifying Systems","lamport 2002"]** (Lamport) — Still the most directly useful public reference for: turning a concurrent design into `Init /\ [][Next]_vars`, encoding invariants, and structuring specs so that a model checker can explore meaningful interleavings. It also contains practical TLC discussions (including symmetry/liveness caveats) that translate cleanly to “small-model, high-signal” discovery. citeturn16search17

2. **“Hiding, Refinement, and Auxiliary Variables”** (Lamport note) — A compact, deeply practical guide to refinement mappings, hiding internal variables, and using auxiliary/history/prophecy variables when the concurrent protocol’s steps don’t line up one-for-one with the sequential spec. This is the closest “pattern book” for your stated ladder: protocol spec ↔ sequential spec ↔ implementation checks. citeturn21view0

3. **“Model Checking TLA+ Specifications”** (Yu, Manolios, Lamport) — Explains TLC’s finite-model approach and, crucially, the *workflow* that matters here: pick a finite model by bounding processor counts/queue lengths, encode the bound as a constraint, then have TLC search for invariant violations and deadlocks while producing counterexample traces. It also explicitly calls out refinement step-simulation under a refinement mapping as a core verification move. citeturn27view0

4. **TLA+ Toolbox docs: “Model Values and Symmetry”** — The most actionable official doc for *how* to get tractable state spaces: substitute model values for symmetric sets (workers, tasks, keys), use dedicated symmetry sets, and understand the sharp edges (TLC doesn’t validate your symmetry claim; symmetry should not be used for liveness checking). citeturn18view0

5. **entity["organization","TLA+ Examples","tla+ examples repository"]** (tlaplus/Examples) — A curated corpus of real specs and `.cfg` models, with explicit guidance to study/use features like `SYMMETRY`, `CONSTRAINT`, `DEADLOCK`, and more. It’s particularly valuable as a “pattern library” for how other specs structure models to remain checkable. citeturn22view0

6. **TLA+ Examples: KeyValueStore snapshot isolation package** (README + specs + cfg) — A direct MVCC/snapshot exemplar, and unusually close to your needs:
   * `KeyValueStore.tla` models snapshot transactions, write sets, and conflict detection. citeturn30view0  
   * `KVsnap.tla` is a PlusCal model that explicitly invites the core concurrency move you need: “add more yield points / make actions smaller and see what breaks,” i.e., intentionally exposing race windows to TLC. citeturn30view1  
   * `MCKVsnap.cfg` demonstrates a minimal finite model with symmetry enabled (keys, tx IDs) and checks snapshot isolation as an invariant (with optional serializability check commented). citeturn30view2  
   * The README frames the exact learning: snapshot isolation can be model-checked quickly, and you can surface a counterexample when asserting serializability. citeturn29view0

7. **entity["organization","Ubisoft","video game publisher"] task-scheduler + `TaskScheduler.tla`** — A rare public, real-world example of a multithreaded scheduler where TLA+ isn’t academic garnish: the repo claims TLA+ validation against deadlocks/reordering/task-loss, and the TLA+ model codifies the tricky part you care about—splitting operations so intermediate states become visible and checkable. citeturn23view0turn3view0

8. **“BWoS: Formally Verified Block-based Work Stealing for Parallel Processing” (OSDI 2023)** — A modern exemplar of **verified scheduling**: work-stealing queues are notoriously subtle under weak memory models, and this paper explicitly combines a pragmatic design with formal verification/model-checking-based validation under weak memory and emphasizes correctness pitfalls that show up in real runtimes. Even if you don’t use work stealing, the invariants and the verification mindset port directly to “worker pool + cancellation + fences.” citeturn17view0

9. **Linux kernel docs: “Sequence counters and sequential locks (seqlock)”** — A clean generation/epoch pattern for consistent reads with lockless readers: readers take a version, read a dataset, re-check the version, and retry if it changed; writers bracket writes by incrementing the sequence. This is the canonical reference for “generation tagging + stale result dropping” in non-database systems, including an explicit note that latch sequence counters are an MVCC mechanism switching between two copies. citeturn19view0

10. **entity["organization","Apache Kafka","distributed event streaming platform"] protocol documentation** — A production-grade “epoch fencing” exemplar: the protocol defines errors like “member epoch is fenced” and “member epoch is stale,” and many requests carry a `generation_id_or_member_epoch`. This is a direct, mainstream reference for the pattern “include epoch in request/commit; coordinator rejects stale or fenced epochs,” which is the same logical move as “drop stale derived results.” citeturn9view0

11. **entity["organization","Kubernetes","container orchestration project"] API Concepts: `resourceVersion` semantics** — A strong public reference for “MVCC-like snapshots + pinning semantics” *outside* databases: list/watch semantics distinguish “start at most recent,” “start at any (possibly stale),” and “start at exact,” and define what happens when resource versions are too old to serve (HTTP 410). This maps cleanly onto pinned epoch reads and GC constraints. citeturn10view0

12. **Kubernetes KEP-3157 (watch-list)** — A detailed, real system design doc for building consistent list snapshots by streaming from a watch cache:
   * compute a target ResourceVersion,
   * wait until the cache has observed it,
   * stream current objects,
   * then send a bookmark at that ResourceVersion.  
   This is extremely close to “stabilized_epoch”: define the target, wait for progress, then publish a “checkpoint marker” that clients can treat as consistent. citeturn12view0

13. **“Naiad: A Timely Dataflow System” (SOSP 2013)** — A foundational non-DB reference for logical time/epochs applied to asynchronous computation graphs: stateful vertices process timestamped records and receive notifications once they have received all records for a given round/iteration, which the paper frames as enabling consistent results at outputs/intermediate stages despite streaming/iteration. citeturn25view0

14. **“Timely Dataflow: A Model” (Abadi & Isard)** — A complementary (more formal) reference: it defines timely dataflow semantics using a linear-time temporal logic, models virtual times that need not be linearly ordered, and formalizes completion notifications via a “could-result-in” relation. If DNA Calc’s stabilization semantics become subtle (partial order across scopes, structural edits), this paper is the closest existing formal template. citeturn24view0

15. **Oxide RFD 400: “Dealing with cancel safety in async Rust”** — A high-quality public reference for **cancellation semantics** that are directly relevant to your Rust/.NET implementations:
   * futures are canceled by being dropped,
   * cancellation happens at await points,
   * cancellation propagates to owned children,
   * “cancel safety” vs “cancel correctness” is framed as local vs global properties,
   * and it provides concrete failure modes (losing data, violating invariants, fairness loss) plus strategies (resume futures in `select!` loops, isolate cancel-unsafe operations behind tasks). citeturn20view0

## Adaptable TLA+ model patterns

The patterns below are written as “copyable shapes” you can lift into a DNA Calc TLA+ module. Each is backed by at least one concrete spec or production protocol above.

**Epoch-fenced completion (stale-drop as a safety property)**  
Core idea: every worker result carries `epoch_tag`; the commit action requires `epoch_tag = committed_epoch` (or `epoch_tag = target_epoch_for_commit`), otherwise the result is either ignored or recorded as stale-but-not-applied. This is exactly the “fenced epoch” move used in real protocols (Kafka member epochs / stale member epochs), and it is the same logic as seqlock’s “retry if version changed.” citeturn9view0turn19view0  
Direct adaptation: model `CompleteTask(taskId)` producing a `result` record `{cell, epoch, status}`; model `ApplyResult(result)` guarded by `result.epoch = committed_epoch`. Any late completion becomes `DropResult(result)`.

**Snapshot transaction / MVCC mini-kernel (versioned reads, write sets, conflict detection)**  
Use the KeyValueStore snapshot isolation example as a scaffold: it models snapshot stores per transaction, `written` sets, `missed` sets, and a commit rule that rejects write-write conflicts. citeturn30view0turn29view0  
Direct adaptation: treat each “calc task batch” as a mini-transaction over a snapshot epoch:
* snapshot = `DocSnapshot[epoch]`
* writes = “cells computed in this batch”
* conflict = “epoch changed under me” (or structural edit fence tripped)  
This gives you a ready-made place to encode “no stale commit” as a small invariant and to explore counterexamples by splitting the commit action (as encouraged explicitly by `KVsnap.tla`). citeturn30view1

**Worker pool + queues + explicit wake/signal semantics (scheduler as a state machine, not an oracle)**  
The Ubisoft TaskScheduler model shows a concrete approach to modeling a real scheduler:
* explicit front/ready/waiting queues,
* explicit task status fields,
* deliberate splitting of operations so race windows become visible,
* symmetry sets for threads/tasks. citeturn3view0turn23view0  
Direct adaptation: use the same decomposition for DNA Calc:
* `FrontQueue` = “dirtying events / invalidation requests”
* `ReadyQueue` = “(cell, epoch) tasks ready to eval”
* `WaitingQueue` (optional) = “deferred tasks (e.g., background priority)”  
The key is to avoid modeling “the scheduler magically picks the right work”; instead, model “scheduler role” actions that move tasks between queues and can be interrupted by new ops/cancellations.

**Progress frontier and stabilization (completion notifications generalized)**  
Timely dataflow provides a powerful abstraction: computations are tagged with logical times, and components can request notification when all messages for a time have been received; the Naiad paper motivates this as enabling consistent intermediate results. citeturn25view0 The model paper formalizes virtual time and completion in temporal logic. citeturn24view0  
Direct adaptation: model `Pending(epoch)` as the set of “work still possibly producing results for epoch”; define `stabilized_epoch` as the greatest epoch whose pending set is empty (or whose frontier is above it). Then prove/MC:  
*Safety:* a “stabilization marker” is never advanced past an epoch with pending work.  
*Liveness (under fairness assumptions):* if no new ops arrive, eventually `stabilized_epoch = committed_epoch`.

**Refinement ladder: concurrent protocol spec ↔ sequential spec ↔ trace/implementation checks**  
Lamport’s refinement note is the most direct “how-to” for proving/validating that a low-level concurrent spec implements a high-level sequential one using hiding and auxiliary variables. citeturn21view0 The TLC paper describes step-simulation under a refinement mapping as a key technique, alongside invariants. citeturn27view0  
Direct adaptation:
1. **Sequential spec**: a single `ApplyOpsAndRecalc` action that atomically advances from epoch `e` to `e+1`, producing complete derived state (or a complete delta set) for that epoch.  
2. **Concurrent spec**: tasks evaluate pieces; results commit in some order; cancellations and fences exist.  
3. **Refinement mapping**: map the concurrent state to the sequential state by projecting away internal queues/tasks and mapping “visible” derived values to the sequential atomic outcome for the current committed epoch, while accounting for stuttering steps and partial progress.

## Failure modes and invariants to encode

The failure modes below are phrased as they tend to appear in event-processed, epoch-tagged systems; each includes the kind of invariant that catches it early in TLC.

**Stale overwrite (late result commits over newer epoch)**  
Symptom: a task computed against epoch `e` finishes after `committed_epoch > e` and still mutates derived state, corrupting the view. This is exactly what epoch fencing prevents in protocols (Kafka) and what generation counters detect via mismatch (seqlock). citeturn9view0turn19view0  
Invariant shape: `AppliedResults ⊆ { r : r.epoch = committed_epoch }` (or per-cell: a cell’s applied value_epoch equals the epoch of the snapshot used).

**Split-brain commits during “exclusive mutation” windows (structural edit overlap)**  
Your architecture requires structural edits to run under exclusive mutation such that no concurrent structural mutation overlaps the commit window. fileciteturn0file1  
Invariant shape: `StructuralEditInFlight => (no other structural commit enabled)` and `StructuralCommit` implies “worker tasks observe either old snapshot or new snapshot, but cannot interleave structural rewrite with derived commits.”

**Status non-monotonicity (pending/ready/error transitions regress)**  
DNA Calc’s value status lattice is intended to be explicit and monotone per epoch view. fileciteturn0file1  
Invariant shape: for each `(cell, epoch)`, `status` only moves forward (e.g., `pending → ready/error`, never back), and `stale` visibility is derived from `value_epoch < committed_epoch` rather than stored as a mutable flag.

**Lost invalidation / missed work (stabilized advances without all required work complete)**  
This is the “false stabilization” bug: you advance `stabilized_epoch` but some dependent value was never recomputed. Timely dataflow’s notification condition (“notify only after no more messages ≤ t will occur”) is the same correctness constraint in different clothing. citeturn25view0turn24view0  
Invariant shape: `stabilized_epoch = e` implies that every required “work item” for epoch `e` is either completed and applied or proven unnecessary by the dependency closure abstraction used in the model.

**Cancellation correctness bugs (cancellation leaves shared state invalid or loses data)**  
RFD 400’s core distinction is: cancel-safety is local (a future can be dropped without bad global effects) while cancel-correctness is global (system invariants survive cancellations). citeturn20view0  
Invariant shapes:
* “No shared invalid state across yield points”: any shared mutable structure must satisfy its representation invariants in every state (especially after any action that represents an await/yield boundary). citeturn20view0  
* “No data loss”: if you model event streams/queues, cancellation cannot cause message disappearance unless explicitly modeled as allowed. citeturn20view0turn27view0

**Snapshot isolation ≠ serializability (write skew / anomaly acceptance is explicit)**  
The KeyValueStore example explicitly demonstrates that snapshot-style semantics can pass a “snapshot isolation” invariant while violating serializability when you enable the serialization invariant. This is valuable because it forces you to decide which anomalies are permitted by design and encode them as *spec choices*, not accidents. citeturn29view0turn30view1  
Invariant strategy: decide and encode the strongest correctness property you actually want (likely “consistent snapshot reads + no stale derived commit”), and add separate “would-be-stronger” invariants that you expect to fail (as regression bait / documentation).

**Ghost duplication (duplicate delta publication / double-apply)**  
This appears when commit and publish are not idempotent under retries. Kafka’s protocol-level epoch/generation tagging exists partly to prevent “zombie” commits from older generations. citeturn9view0  
Invariant shape: for each `(cell, epoch)`, there is at most one applied commit (or applied commits are equivalent), and any published delta must correspond to a committed derived state for its epoch.

## TLC configurations for small-model discovery

TLC finds the best bugs when the model is *tiny* but the interleavings are *rich*. The following strategies are directly supported by TLC practice as described in the TLC paper, with concrete knobs shown in the Toolbox docs and real `.cfg` examples in the TLA+ Examples repo and KeyValueStore configs. citeturn27view0turn18view0turn22view0turn30view2

Build at least two model tiers:

A **safety-first model** that maximizes interleavings while keeping the state space finite:
* Use very small sets: `Cells = {c1,c2}`, `Epochs = 0..2`, `Workers = {w1,w2}`, `Ops = {op1,op2}`, and “maybe 1 structural edit op.” This follows the TLC paper’s explicit guidance: models are made finite by bounding participants and message/queue sizes. citeturn27view0  
* Constrain queue lengths / in-flight tasks using **constraints** (the TLC paper demonstrates encoding a queue-length bound predicate as a constraint used by the model checker). citeturn27view0  
* Turn on symmetry wherever components are interchangeable (workers, tasks, keys, transactions). Use model values + symmetry sets, and follow the Toolbox warning: TLC won’t validate that your symmetry set is actually safe, and symmetry has liveness caveats. citeturn18view0turn30view2  
* Make concurrency bugs visible by splitting actions: the Ubisoft scheduler spec explicitly splits multi-step operations into separate actions, and `KVsnap.tla` explicitly suggests pulling pieces out of an atomic commit to see what breaks. This is the most effective way to “manufacture race windows” in a model. citeturn3view0turn30view1

A **liveness-focused model** that is smaller and more constrained:
* Keep constants even smaller and avoid symmetry if it risks unsoundness for the specific liveness properties you check; the Toolbox docs explicitly warn against using symmetry sets for liveness checking. citeturn18view0  
* Add explicit weak fairness only where you mean it (e.g., “if a cell’s eval task is continuously enabled, eventually it runs”), similar to how `KVsnap.tla` adds fairness (`WF_vars`) for each process. citeturn30view1  
* Expect liveness checks to be slower; keep the model minimal and prefer proving progress as a derived safety property when possible (e.g., monotone decrease of a bounded “remaining work” measure) before asking TLC for temporal guarantees. citeturn24view0turn27view0

Configuration patterns worth copying directly from public examples:

* **Symmetry in `.cfg`**: `MCKVsnap.cfg` shows a minimal, concrete pattern: small constants + `SYMMETRY` + invariants + (optionally) properties. citeturn30view2  
* **Model values instead of integers** for symmetric identifiers (workers/tasks/cells). The Toolbox doc explains why model values are preferable: they prevent accidental arithmetic on identifiers and enable symmetry reduction. citeturn18view0  
* **Deliberate “bait invariants”**: The KeyValueStore README describes enabling an invariant (serializability) that should fail under snapshot isolation to get a counterexample; this is a powerful way to document what you *don’t* guarantee while keeping a regression-ready trace. citeturn29view0turn30view1  
* **Queue-bounding constraints**: The TLC paper’s example of bounding `Len(inq[p])` generalizes directly to “ready queue length”, “front queue length”, and “max in-flight tasks.” citeturn27view0

## Translating DNA Calc terms into TLA+ state and actions

This is a practical mapping guide for taking the DNA Calc concurrency vocabulary (as defined in your architecture/operations docs) into a state-machine model that TLC can explore. fileciteturn0file1turn0file3

**Choose a minimal observable surface first**  
Your protocol surface includes dispatch ops/transactions, query snapshots, and subscribe to deltas/events. fileciteturn0file1 For TLA+, treat clients as the environment that non-deterministically submits ops, pins/unpins epochs, and consumes delta streams—exactly the “open system” style used in most practical TLA+ specs and in timely dataflow reasoning (components + external producer). citeturn25view0turn27view0

**Translate nouns to state variables**  
A workable first model usually needs only:

* `committedEpoch` — Nat (or small bounded set)  
* `stabilizedEpoch` — Nat with invariant `stabilizedEpoch <= committedEpoch` (your architecture defines both and their relationship) fileciteturn0file1  
* `opLog` — a sequence or set of ops already accepted (optionally modeled as just “there exists an op that advanced epoch”) fileciteturn0file1  
* `snapshots[e]` — abstract immutable “document snapshot at epoch e” (you typically don’t model full spreadsheet semantics; model only the parts that affect scheduling/invalidations) fileciteturn0file1  
* `dirty[e]` / `work[e]` — the set of work items required to stabilize epoch `e` (“cells to compute”, or “nodes in dependency closure”)  
* `tasks` — in-flight tasks, each with fields like `{id, epoch, item, state ∈ {queued,running,done,canceled}}`  
* `results` — produced but not yet applied results, tagged `{epoch, item, status, value_epoch}`  
* `applied[item]` — the visible derived cache for each item (value_epoch + status) fileciteturn0file1  
* `pins` — set of epochs pinned by clients; used to constrain GC fileciteturn0file1

This aligns with your architecture’s intent: snapshots are immutable per epoch, derived values are caches, and staleness/status are explicit in the API. fileciteturn0file1

**Translate verbs to actions (the “small steps” that create race windows)**  
Start with a `Next` that is a disjunction of actions, each updating a small part of state. The actions below mirror patterns in the scheduler spec (explicit queues and status transitions) and the KeyValueStore snapshot model (explicit begin/commit + conflict checks). citeturn3view0turn30view0turn27view0

* `SubmitOp(op)`  
  *Effect:* advances `committedEpoch' = committedEpoch + 1`, creates `snapshots[committedEpoch']`, initializes/updates `work[committedEpoch']`.  
  *Why:* this is your MVCC “write transaction commit” step. fileciteturn0file1

* `EnqueueWork(e, item)` / `ScheduleTask(e, item)`  
  *Effect:* creates a task `{epoch=e, item}` and puts it in a queue.  
  *Why:* make the scheduler explicit (don’t let the model “teleport” from dirty to computed). citeturn3view0turn27view0

* `StartTask(taskId)` / `FinishTask(taskId)`  
  *Effect:* transitions task state; on finish, emits a result tagged with `epoch`.  
  *Why:* out-of-order completion is where stale overwrite bugs come from. fileciteturn0file1

* `ApplyResult(result)`  
  *Guard:* `result.epoch = committedEpoch` (or, more precisely, equals the epoch the result claims and that is still current for the cache shard).  
  *Effect:* updates `applied[item]` and the item’s `value_epoch`.  
  *Why:* this is your “no stale commit” invariant turned into an *action guard* (epoch fencing), mirroring Kafka’s fenced/stale epoch model and seqlock’s retry-on-change discipline. fileciteturn0file1turn9view0turn19view0

* `DropResult(result)`  
  *Guard:* `result.epoch < committedEpoch` (or `!= targetEpoch`).  
  *Effect:* discards without mutating applied caches.  
  *Why:* stale result dropping is a first-class protocol behavior, not an accident. fileciteturn0file1turn9view0

* `AdvanceStabilized(e)`  
  *Guard:* `work[e] = {}` (or frontier condition) and `e = stabilizedEpoch + 1`.  
  *Effect:* `stabilizedEpoch' = e`.  
  *Why:* this is the “completion notification” / “bookmark” event analog (timely dataflow notifications; Kubernetes bookmark RV) and should be impossible to do early. fileciteturn0file1turn25view0turn12view0

* `Pin(epoch)` / `Unpin(epoch)` / `GC(epoch)`  
  *Guard:* GC only when epoch not pinned and older than retention floor.  
  *Why:* your snapshot pinning + GC policy is part of correctness (don’t free what a reader can still observe), directly analogous to resourceVersion exact watches and “410 Gone” when history is unavailable. fileciteturn0file1turn10view0

**Encode the refinement ladder explicitly, not implicitly**  
A concrete, checkable setup (aligned with Lamport refinement guidance) is:

* `SeqSpec`: a sequential “oracle” model where each op commit atomically recalculates derived outputs for that epoch and publishes a delta batch tagged with that epoch. This is your “ideal semantics” for clients. citeturn21view0  
* `ConcSpec`: the real concurrent protocol with tasks/queues/cancellation.  
* `Mapping`: a state function from `ConcSpec` to `SeqSpec` where:
  * internal queues/tasks/results are hidden (existentially quantified / projected away),
  * visible derived values at `committedEpoch` match the sequential spec’s derived values for that epoch,
  * all other steps are stuttering w.r.t. the sequential spec. citeturn21view0turn27view0

**Make “cancellation semantics” spec-level, not library-level**  
Given the cancel-safety/cancel-correctness framing in RFD 400, model cancellation as an explicit action that can occur only at “yield boundaries,” and require that all shared-state invariants hold after every action—including cancel actions. citeturn20view0turn27view0  
For DNA Calc, the most important cancellation questions to answer *in spec* are:
* Which task states are cancelable (queued only, running only at yield points, etc.)? citeturn20view0  
* What is the global effect of cancellation (drop result only, or must it enqueue compensating work)? citeturn20view0turn9view0  
* Which resources are “held” across yields (should be “none” for mutation-critical locks, per your lock discipline constraint)? fileciteturn0file1turn0file3

**Anchor to the project’s operational gates**  
Your operations doctrine asks for tiered model-check configurations and archived minimized counterexample traces for concurrency packs. fileciteturn0file3 The KeyValueStore snapshot package’s “fast model + optional stronger invariant that yields a counterexample” is an excellent template for how `PACK.concurrent.epochs` can be structured:  
*Tier A:* fast safety model, strong invariants, symmetry. citeturn30view2turn18view0  
*Tier B:* smaller liveness/progress model with fairness. citeturn30view1turn18view0  
*Tier C:* “bait invariants” that are expected to fail and become regression seeds when they unexpectedly pass or fail differently. citeturn29view0turn30view1

Finally, keep one additional “people-to-watch” thread for transferable concurrency discipline from adjacent resilient systems work (if you want cross-pollination into this pillar). fileciteturn0file0