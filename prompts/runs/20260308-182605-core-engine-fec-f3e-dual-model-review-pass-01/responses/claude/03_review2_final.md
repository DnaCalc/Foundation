

**SPILL-OVL-003** *(continued)*: …enters `SpillBlocked` state. In `SpillBlocked`: the anchor's value is `#SPILL!`, the prior region is cleared, and all prior spill children revert. The blocking cell set is recorded for future unblock detection.

**SPILL-OVL-004**: Spill recovery. When a blocking cell becomes empty (edit or spill clearance of the blocker), the coordinator re-evaluates the blocked anchor. If the new spill region is conflict-free, the anchor transitions from `SpillBlocked` to `SpillTakeover`.

**SPILL-OVL-005**: Spill anchors in cycles. For Round 0-1: a dynamic array formula (spill anchor) participating in a cycle (|SCC| > 1) is classified as an error condition. The anchor evaluates to `#SPILL!` with a diagnostic indicating cycle membership. This avoids the meta-instability where spill region changes alter cycle membership (per DAG Research Review §5 OQ-CYC-1). For Round 2+: evaluate joint shape+value iteration.

### 5.4 Format Overlay Rules

**FMT-OVL-001**: Tracks formatting dependency per formula node via `FormatToken` (defined in §4.1). Tokens are created by `on_format_read` observation hooks in `ObservingCapabilityView`.

**FMT-OVL-002**: Format invalidation. When a cell's formatting changes, all formula nodes holding a `FormatToken` referencing that cell are marked `Stale`. This is profile-gated (DEC-CALC-007): when the gate is off, format changes do not trigger recalc.

### 5.5 Visibility Overlay Rules

**VIS-OVL-001**: The visibility overlay records which cell regions are currently visible to the user. Updated by host (scroll, tab switch, resize). Does not affect semantic correctness — only scheduling priority.

**VIS-OVL-002**: Under `SchedulePolicy::VisibleFirst`, the scheduler prioritizes `Necessary` nodes within visible regions. Starvation prevention: after `max_deferred_waves` scheduling waves, all non-visible `Necessary` nodes must be scheduled regardless of visible-region state (DEC-CALC-008). The value of `max_deferred_waves` is a coordinator configuration parameter.

**VIS-OVL-003**: Visibility changes during in-flight recalc do not alter the epoch or invalidate any overlay. They only update the scheduler's priority input for future `next_batch` calls.

---

## 6. Concurrency Model

### 6.1 Coordinator Responsibilities

The `Coordinator` is the central serialization point for all state transitions. It is logically single-threaded but may be implemented as an async event loop with message passing.

| Responsibility | Description |
|---|---|
| **Epoch management** | Advances `committed_epoch` on structural mutation; advances `stabilized_epoch` when all nodes reach `Clean`. |
| **Session lifecycle** | Creates sessions bound to a snapshot epoch; tracks active sessions; rejects stale sessions on epoch advancement; detects and reclaims abandoned sessions (F-013). |
| **Overlay ownership** | Owns all overlay instances; applies deltas from committed evaluations; manages GC via session watermark (CALC-OVL-005). |
| **Commit serialization** | Processes `commit` calls sequentially; validates tokens/epochs; applies deltas atomically. |
| **Scheduler dispatch** | Invokes `Scheduler::next_batch`; dispatches evaluation requests to worker pool; collects results. |
| **Publication control** | Publishes deltas in INV-007 order; determines when to expose intermediate state to host (stale/pending) vs. final state (stabilized). |

### 6.2 Snapshot Fences

**FENCE-001**: A snapshot fence is established at each epoch boundary. All reads within an evaluation session see exactly the state at the session's `snapshot_epoch`. No write from a concurrent session or structural edit is visible until the session commits and a new session is opened at a later epoch.

**FENCE-002**: `DocSnapshot` is an immutable persistent data structure (structural sharing). Creating a new epoch clones the snapshot with copy-on-write. Evaluation sessions hold a reference to the snapshot at their epoch — no locks required for reads.

**FENCE-003**: Overlay reads during evaluation use the overlay state as of the session's `snapshot_epoch`. Concurrent overlay mutations (from other committed sessions at the same epoch) are visible only after the current session commits and re-opens.

**FENCE-004**: Epoch advancement during in-flight evaluation:
1. Mark all open sessions as `epoch_invalidated`.
2. Allow in-flight `execute` calls to complete (they may produce stale results).
3. Reject `commit` calls from invalidated sessions with `EpochAdvanced`.
4. Values committed at the prior epoch before advancement are retained; they enter the new epoch's stale set if the structural mutation affects them.
5. Re-open sessions against the new epoch and re-schedule affected nodes.

### 6.3 Contention / Retry Behavior

**CONT-001**: Two evaluation sessions for different formulas at the same epoch do not contend — they read the same immutable snapshot and produce independent deltas.

**CONT-002**: Two sessions for the same formula at the same epoch are serialized by the coordinator. The second `open_session` call blocks until the first session commits or is abandoned. Timeout is a coordinator configuration parameter (to be determined by benchmarking per OQ-006). On timeout: the blocked session receives `SessionOpenError::Contention`.

**CONT-003**: After `SnapshotConflict` or `EpochAdvanced` rejection, the evaluator must:
1. Discard the rejected `EvalTransaction`.
2. Re-acquire the formula plan (which may have changed if the structural edit affected the formula).
3. Open a new session at the current `committed_epoch`.
4. Re-execute.
This is a mandatory retry protocol, not an optional optimization.

**CONT-004**: Session abandonment. If a session is not committed or explicitly abandoned within the coordinator's session timeout, the coordinator reclaims it. Reclamation: release capability view, release snapshot reference, update `min_active_session_epoch` watermark. The abandoned session's `SessionId` subsequently produces `SessionNotFound` on `commit`. (Resolves F-013.)

**CONT-005** *(EXTENSION — not in source)*: The coordinator tracks a `contention_count` per epoch for diagnostic purposes. If contention count exceeds a configurable threshold, the coordinator logs a diagnostic and optionally falls back to sequential evaluation for that epoch.

**CONT-006** *(EXTENSION — not in source)*: Deterministic contention replay. A `ContendedReplayLog` captures all session open/commit/reject/abandon events with their timestamps, epoch, and formula IDs. Replaying this log with a deterministic scheduler must produce identical commit outcomes (DAG-PO-002).

### 6.4 Floating-Point Determinism Under Parallelism

**FP-DET-001**: For Round 0-1, parallel evaluation uses canonical reduction ordering equivalent to sequential evaluation semantics. Partitioned partial results are combined in a fixed, deterministic order. This guarantees bit-identity across partition counts (DAG-PO-010) at the cost of limiting parallelism benefit for associative aggregations. This adopts the recommendation from DAG Research Review §4 OQ-FP-1 as a binding design decision.

**FP-DET-002**: For Round 2+, partition-aware reduction (stable partition boundaries + deterministic reduction tree) may be evaluated as an alternative, contingent on passing DAG-PO-010.

---

## 7. Adoption Roadmap

### Phase 1: Structural Foundation (Round 0 target — DnaVisiCalc)

**Goal**: Deliver the immutable structural model, full-rebuild recalc, and FEC/F3E Plan B b4 transaction lane with single-threaded coordinator. Overlay *interfaces* are designed as type signatures; overlay *instances* are not instantiated until Phase 2.

| Item | Description | Gate |
|---|---|---|
| 1.1 | Green-tree kernel: immutable `DocSnapshot`, `NodeId`/`NameId`/`DepTarget` identity, structural sharing | `PACK.dag.baseline_recalc_core` |
| 1.2 | Structural dependency extraction: `G_s`, SCC decomposition (Tarjan) | `PACK.dag.cycle_iterative_semantics` |
| 1.3 | Full-rebuild recalc: deterministic topological evaluation; cycle handling (Error + Iterative modes) | `PACK.dag.baseline_recalc_core` |
| 1.4 | FEC/F3E Plan B adoption: all source-spec reject taxonomy; single-threaded coordinator | FEC/F3E scenario suite |
| 1.5 | Conservative spill: full-recalc on any spill shape change; SpillBlocked/Takeover/Clearance events; spill-in-cycle = error (SPILL-OVL-005) | Spill scenario subset |
| 1.6 | Change tracking + metadata formatting overlay (no calc-time format deps yet) | Existing conformance baseline |
| 1.7 | Conformance baseline: DAG-CONF-001, DAG-CONF-002, DAG-CONF-008 | Conformance pack validation |

**Phase 1 internal API**: Exposes `engine.recalculate_full()` as the sole recalc strategy. Overlay interface types (`DepOverlay`, `SpillOverlay`, `FormatOverlay`) exist as trait/interface definitions but have no active instances.

### Phase 2: Incremental Engine (Round 0+ / early Round 1)

| Item | Description | Gate |
|---|---|---|
| 2.1 | CapabilityView observation hooks: `on_cell_read`, `on_format_read`, `on_name_resolve` | Observation correctness tests |
| 2.2 | `EvalTransaction` + `CommitResult` extensions: `observed_deps`, `observed_formats`, `dep_delta`, `format_delta`, `applied_epoch`, `EpochAdvanced`/`SessionExpired` reject kinds | Contract compatibility tests |
| 2.3 | Calc-time overlay instances: `DepOverlay`, `SpillOverlay` with epoch versioning and GC (CALC-OVL-001..005) | `PACK.dag.dynamic_dependency_bind_semantics` |
| 2.4 | Dirty/stale/necessary state machine + early cutoff (per-type equality from Formal Model §3.1) | `PACK.dag.early_cutoff.signature` |
| 2.5 | Incremental invalidation: CALC-OVL-004 stale-set closure; runtime dependency delta integration | PO-001 (from-scratch equivalence vs. Phase 1 baseline) |
| 2.6 | Algebraic spill invalidation (SPILL-OVL-002); replace conservative full-recalc | *Proposed*: `PACK.spill.algebraic` |
| 2.7 | Multi-session coordinator + contention protocol (CONT-001..004) + session abandonment | `PACK.concurrent.epochs` |
| 2.8 | Partition-parallel evaluation with canonical reduction (FP-DET-001) | `PACK.dag.parallel_determinism_signature` |
| 2.9 | Pure-calc fast path (CALC-OVL-006) | *Proposed*: `PACK.fast_path` |
| 2.10 | Incremental topo maintenance (with full-rebuild fallback + parity check) | `PACK.dag.dynamic_topo_vs_rebuild` |
| 2.11 | Overlay GC with session watermark | *Proposed*: `PACK.overlay.gc` |

### Phase 3: Policy Extensions (Round 1 — DnaPreCalc)

| Item | Description | Gate |
|---|---|---|
| 3.1 | Format overlay instances: `FormatOverlay`, FMT-OVL-001/002 (profile-gated DEC-CALC-007) | *Proposed*: `PACK.format.overlay` |
| 3.2 | Visibility-first scheduling: `SchedulePolicy::VisibleFirst` + starvation bound (VIS-OVL-002, DEC-CALC-008) | *Proposed*: `PACK.visibility.policy` |
| 3.3 | External stream integration: topic-based invalidation; `ExternallyInvalidated` class | *Proposed*: `PACK.stream.basic` (referenced in DAG-CONF-005) |
| 3.4 | Profile-version invalidation: function catalog change triggers selective re-parse/re-bind | Profile evolution spec |
| 3.5 | Canonical replay schema: `EvalReplayRecord` for concurrent trace replay | `PACK.concurrent.epochs` extended |

### Phase 4: Advanced (Round 2+ — DnaSuperCalc)

| Item | Description | Gate |
|---|---|---|
| 4.1 | Differential evaluation prototype: SAC-to-differential bridge for streaming hot paths | Research gate; transfer matrix reassessment |
| 4.2 | Collaboration via OpLog replication: multi-user concurrent editing | Collaboration spec (not yet drafted) |
| 4.3 | Semiring provenance: algebraic trace reasoning for explainability | Research gate |
| 4.4 | Re-evaluate spill-in-cycle prohibition: joint shape+value iteration | OQ-CYC-1 resolution |

---

## 8. Open Questions and Decisive Experiments

### Open Questions

| ID | Question | Impact | Resolution path |
|---|---|---|---|
| OQ-001 | What is the canonical publication ordering when value, dependency, spill, and format overlays all change in one commit? | Observer correctness for UI and change tracking | INV-007 proposes value→dep→spill→format→visibility; validate with multi-overlay scenario test |
| OQ-002 | Which deterministic replay schema becomes canonical across concurrent evaluator traces? | Conformance testing and regression infrastructure | Design canonical `EvalReplayRecord` schema; test with contention replay pack |
| OQ-003 | How should degradation classes be encoded for dynamic-reference edge behavior? | Profile specification and interop | Propose enum-based degradation classification; validate with profile compatibility matrix |
| OQ-004 | Is the pure-calc fast-path guard (CALC-OVL-006) sound under all profile configurations? | Correctness of performance optimization | Formal proof obligation (extend PO-001 to cover fast-path bypass); test volatile edge cases |
| OQ-005 | What is the correct GC policy for calc-time overlay edges when sessions have heterogeneous lifetimes? | Memory behavior under long-running evaluations | Prototype GC with session watermark tracking (CALC-OVL-005); measure memory under stress |
| OQ-006 | Should the coordinator contention protocol use blocking with timeout or CAS-based retry? | Throughput under high concurrency | Benchmark both approaches with synthetic contention workload |
| OQ-007 | How does the spill invalidation algebra interact with iterative cycle evaluation? | Correctness of cycle-with-spill edge case | SPILL-OVL-005 prohibits for Round 0-1; construct validation test for Round 2+ joint iteration |
| OQ-008 | What is the impact of NaN-equality semantics on early-cutoff decisions? | DAG-PO-008 soundness | Formal model declares NaN ≠ NaN (bitwise); verify recalc amplification is acceptable |

### Decisive Experiments

| ID | Experiment | Expected outcome | Decision unlocked |
|---|---|---|---|
| EXP-001 | **Full-rebuild vs. incremental baseline**: Run conformance suite with both strategies; compare outputs bit-for-bit. | Bit-identical outputs; incremental ≥2x faster on edit-recalc cycles. | Validates PO-001; unlocks Phase 2 adoption. |
| EXP-002 | **Contention stress test**: Concurrent formula evaluations on overlapping dependency regions. | All commits succeed or reject deterministically; no deadlock or livelock. | Validates CONT-001..004; unlocks multi-session coordinator. |
| EXP-003 | **Spill algebra correctness**: Spill scenario matrix (takeover, clearance, blocked, recovery, nested spill, spill-in-cycle error). | All cases produce correct values matching full-rebuild baseline. | Validates SPILL-OVL-001..005; unlocks algebraic spill invalidation. |
| EXP-004 | **Pure-calc fast-path validation**: Identify all qualifying formulas in conformance suite; evaluate with and without tracking; compare outputs. | Bit-identical; qualifying formulas ≥30% of total. | Validates CALC-OVL-006; unlocks fast-path optimization. |
| EXP-005 | **Partition-parallel determinism**: Run conformance suite with partition counts 1, 2, 4, 8; compare value signatures. | Bit-identical across all partition counts. | Validates PO-008 + FP-DET-001; unlocks parallel evaluation. |
| EXP-006 | **Visibility-first starvation bound**: Large sheet with visible region = 1% of cells; measure maximum latency for non-visible cell stabilization under continuous scrolling. | Non-visible cells stabilize within `max_deferred_waves` waves. | Validates VIS-OVL-002; unlocks visibility-first policy. |
| EXP-007 | **Dynamic dependency token lifecycle**: INDIRECT/OFFSET-heavy workload through edit-recalc cycles; verify no stale tokens persist. | Zero stale tokens after each stabilization; overlay memory bounded. | Validates CALC-OVL-003/005; unlocks dynamic dependency tracking. |
| EXP-008 | **Overlay GC under session watermark**: Long-running evaluation with concurrent short evaluations; measure overlay memory growth. | Memory bounded by O(active_sessions × avg_overlay_size). | Resolves OQ-005; validates GC policy. |

---

## 9. Pack / Proof Checklist

### Proof Obligations

The source defines DAG-PO-001 through DAG-PO-010. This synthesis adds architectural proof obligations APO-001 through APO-006 (marked EXTENSION).

| ID | Obligation | Testable predicate | Phase | Status |
|---|---|---|---|---|
| **DAG-PO-001** | Acyclic from-scratch equivalence | `∀ acyclic snapshot: incremental_result == full_rebuild_result` | Phase 2 | Required |
| **DAG-PO-002** | Deterministic replay | `∀ op_stream: replay(ops) == original_run(ops)` values and errors | Phase 1 | Required |
| **DAG-PO-003** | SCC partition correctness | `scc_decompose(G_s) == reference_tarjan(G_s)` for all test graphs | Phase 1 | Required |
| **DAG-PO-004** | Bounded iterative determinism | `∀ cyclic snapshot with (max_iter, eps): result is deterministic` | Phase 1 | Required |
| **DAG-PO-005** | Monotone epoch advancement | `∀ t1 < t2: epoch(t1) ≤ epoch(t2)` and no epoch reuse | Phase 1 | Required |
| **DAG-PO-006** | Dynamic dependency soundness | `deps_unchanged(n, e1, e2) ∧ targets_unchanged(n, e1, e2) ∧ ¬volatile(n) ⟹ value(n, e1) == value(n, e2)` — where `targets_unchanged` means all targets of n's edges have identical values at both epochs | Phase 2 | Required |
| **DAG-PO-007** | Dynamic from-scratch consistency | `incremental_dynamic == full_rebuild` for all dynamic functions | Phase 2 | Required |
| **DAG-PO-008** | Early-cutoff safety | `cutoff(n) ⟹ ∀ m ∈ successors(n): value_with_cutoff(m) == value_without_cutoff(m)` | Phase 2 | Required |
| **DAG-PO-009** | External source ordering | `∀ source, u1 before u2: processed(u1) before processed(u2)` | Phase 3 | Required |
| **DAG-PO-010** | Parallel schedule confluence | `∀ partition_count ∈ {1..8}: values_identical` | Phase 2 | Required |
| **APO-001** | Commit atomicity (INV-005) | `Applied ⟹ all deltas visible; Rejected ⟹ no delta visible` | Phase 1 | EXTENSION |
| **APO-002** | Snapshot fence correctness (FENCE-001) | `∀ session at epoch e: reads(session) ⊆ state(e)` | Phase 1 | EXTENSION |
| **APO-003** | Spill invalidation completeness (SPILL-OVL-002) | `spill_invalidation_set ⊇ all_affected_cells` (no missed invalidation) | Phase 2 | EXTENSION |
| **APO-004** | Pure-calc fast-path soundness (CALC-OVL-006) | `fast_path_result(n) == full_tracking_result(n)` when guard is true | Phase 2 | EXTENSION |
| **APO-005** | Overlay GC safety (CALC-OVL-005) | No overlay edge collected while referenced by an active session | Phase 2 | EXTENSION |
| **APO-006** | Spill-in-cycle error classification (SPILL-OVL-005) | Spill anchor in SCC with |SCC|>1 produces `#SPILL!` error, not divergence | Phase 1 | EXTENSION |

### Empirical Packs

Source-defined packs (from output 11) are listed first. Proposed packs (EXTENSION) are listed separately.

**Source-defined packs:**

| Pack ID | Name | Phase | Pass criterion |
|---|---|---|---|
| `PACK.dag.baseline_recalc_core` | Baseline recalc validation | Phase 1 | DAG-PO-002, DAG-PO-003 pass; topo order consistent; replay bit-identical |
| `PACK.dag.cycle_iterative_semantics` | Cycle handling | Phase 1 | DAG-PO-004 pass; max_iter honored; epsilon convergence verified; SCC matches Tarjan reference |
| `PACK.dag.dynamic_dependency_bind_semantics` | Dynamic dependency tracking | Phase 2 | DAG-PO-006, DAG-PO-007 pass; zero stale tokens after stabilization |
| `PACK.dag.early_cutoff.signature` | Early cutoff behavior | Phase 2 | DAG-PO-008 pass; cutoff ratio ≥ 20% on typical workloads |
| `PACK.dag.dynamic_topo_vs_rebuild` | Dynamic topo maintenance | Phase 2 | Bit-identical results; incremental ≥ 1.5x faster; DAG-CONF-007 parity checks pass |
| `PACK.dag.parallel_determinism_signature` | Parallel determinism | Phase 2 | DAG-PO-010 pass; bit-identical across partition counts 1–8 |
| `PACK.concurrent.epochs` | Concurrent epoch management | Phase 2 | DAG-PO-005, APO-001, APO-002 pass; no deadlock; contention replay matches |

**Proposed packs (EXTENSION — not in source empirical pack definitions):**

| Pack ID | Name | Phase | Pass criterion |
|---|---|---|---|
| `PACK.spill.algebraic` | Algebraic spill invalidation | Phase 2 | APO-003 pass; all scenarios match full-rebuild baseline; APO-006 pass |
| `PACK.fast_path` | Pure-calc fast path | Phase 2 | APO-004 pass; zero guard misclassification; volatile functions excluded |
| `PACK.overlay.gc` | Overlay garbage collection | Phase 2 | APO-005 pass; memory bounded per OQ-005 criterion |
| `PACK.format.overlay` | Formatting overlay | Phase 3 | FMT-OVL-001/002 scenarios pass; profile gate on/off tested |
| `PACK.visibility.policy` | Visibility-first scheduling | Phase 3 | INV-008 holds under VisibleFirst; starvation bound ≤ max_deferred_waves |
| `PACK.stream.basic` | External stream ordering | Phase 3 | DAG-PO-009 pass; replay deterministic |

### Conformance Row Bindings

| Conformance row | Pack binding | Artifact required |
|---|---|---|
| DAG-CONF-001 (canonical recalc order) | `PACK.dag.baseline_recalc_core` | Recalc order trace file per epoch |
| DAG-CONF-002 (SCC/cycle diagnostics) | `PACK.dag.cycle_iterative_semantics` | SCC membership + cycle mode trace per evaluation |
| DAG-CONF-003 (dynamic dep trace) | `PACK.dag.dynamic_dependency_bind_semantics` | Dependency-set trace artifact per stabilization wave |
| DAG-CONF-004 (early-cutoff observability) | `PACK.dag.early_cutoff.signature` | Per-node `value_changed` trace field |
| DAG-CONF-005 (external update replay) | `PACK.stream.basic` | Replayable external update envelope log |
| DAG-CONF-006 (parallel bit-identity) | `PACK.dag.parallel_determinism_signature` | Value signature hash per partition configuration |
| DAG-CONF-007 (dynamic-topo fallback counts) | `PACK.dag.dynamic_topo_vs_rebuild` | Fallback-to-rebuild counter + parity check log |
| DAG-CONF-008 (iterative cycle mode declaration) | `PACK.dag.cycle_iterative_semantics` | Per-SCC result classification (FixedPoint / BoundedPragmatic / Error) |

---

*End of deliverable. All claims cite sources within the compact source pack. Terminology: F3E used throughout; where source material uses F3C, the mapping F3E→F3C applies per prompt §Source handling rules. Items marked EXTENSION are explicitly flagged as beyond the source specification baseline. Proposed pack IDs (not in source output 11) are separately listed.*
