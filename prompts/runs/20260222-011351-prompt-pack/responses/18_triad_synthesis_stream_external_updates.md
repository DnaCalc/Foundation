*Posted by Codex agent on behalf of @govert*

# Triad Synthesis - STREAM External Updates

## 1) Recommended decision set (now vs later)
### Do now (Round 0, required this cycle)
1. Canonical mutation path:
- All STREAM-visible external changes must enter via `OpExternalUpdate` through `DispatchOps` -> OpLog; no side-channel mutation.

2. Normative external op contract (freeze now):
- `OpExternalUpdate { topic_key, source_seq, payload, source_ts, trace_id }`.
- Per-topic sequencing policy: strictly increasing `source_seq`; duplicates/out-of-order are deterministically rejected with diagnostics.

3. STREAM semantics contract (profile-scoped):
- `STREAM(topic)` binds to canonical `topic_key`.
- Accepted external op advances `committed_epoch`, triggers dependency invalidation, then recompute.
- `value_epoch`, `fresh|stale|pending` visibility is mandatory in snapshot/API/UI.

4. Recompute/coalescing policy (Pathfinder):
- Apply accepted ops in log order (no hidden coalescing semantics in Round 0).
- Manual recalc: invalidation/staleness is visible immediately; recompute waits for recalc trigger.

5. Deterministic replay requirement:
- Deterministic mode is mandatory for conformance: fixed op ordering, fixed scheduler policy, canonical trace artifacts.

6. Capability negotiation + graceful degradation:
- Require `stream_semantics_version`, `FG_STREAM_BASE`, `FG_EXTERNAL_UPDATE_OPLOG`.
- Deterministic degradation classes: `unsupported_feature`, `unknown_payload`, `provider_unavailable`, `profile_mismatch`.

7. Pathfinder payload scope:
- Allow scalar payloads only (`number`, `text`, `error`, `null`) for Round 0.

### Do later (Round 1+)
1. Full RTD lifecycle parity (`FG_RTD_LIFECYCLE`) and advanced subscription economics.
2. Collaboration oracle policy (local vs shared stream authority).
3. Async UDF continuations interacting with STREAM.
4. Advanced QoS/backpressure/fairness classes beyond deterministic Pathfinder baseline.
5. Extended payload/range semantics and richer interop marshalling.

### Conflict resolutions applied
1. Pack breadth conflict (Design/Delivery minimal vs Assurance broader): choose Assurance-level validation for "green" to preserve rigor and cross-engine evolvability.
2. Spec ambiguity conflict (sequence/coalescing/manual mode): freeze explicit Round 0 rules now to prevent Red/Blue drift.

## 2) Unified one-cycle plan (Spec -> Packs -> Implementations -> Stabilization)
### Phase A: Spec (Days 1-2)
1. Freeze normative semantics and protocol fields in architecture doc.
2. Freeze requirement IDs for determinism, sequencing, staleness, and degradation.
3. Freeze profile/gate matrix for Round 0 vs Round 1 extensions.

Exit criteria:
- Ambiguities closed for sequence policy, coalescing policy, manual recalc interaction, payload set, and replay requirement.

### Phase B: Packs (Days 2-4)
1. Define/refresh canonical stream trace corpus (`ops.jsonl`, expected `deltas.jsonl`, final snapshot hash).
2. Wire required packs (below) with deterministic seeds/config.
3. Add minimization and artifact emission rules for every failing run.

Exit criteria:
- Packs runnable in CI with deterministic artifacts and declared pass/fail gates.

### Phase C: Implementations (Days 4-8)
1. Shared protocol/schema updates and capability negotiation wiring.
2. Red implementation of STREAM binder + external-op coordinator flow + deterministic mode.
3. Blue mirror implementation with independent internals but identical observable protocol behavior.
4. Add required instrumentation (sequence rejects, epoch guards, queue/depth/latency, mutation audit).

Exit criteria:
- Both engines pass local deterministic trace replay and produce canonicalizable delta streams.

### Phase D: Stabilization (Days 8-10)
1. Run full required pack set on Red and Blue.
2. Run Red vs Blue and engine vs oracle differential checks.
3. Publish capability manifest + conformance report + minimized regression artifacts.

Green criteria:
- All required packs pass in CI for both engines, zero unresolved Sev-1 stream correctness failures, and Green sign-off.

## 3) Required doc changes (exact headings/IDs)
### `ARCHITECTURE_AND_REQUIREMENTS.md`
1. Add heading `3.5.1 STREAM semantic contract (profile-scoped)`.
2. Add heading `3.5.2 External update op contract (versioned, replayable)`.
3. Add heading `3.5.3 Epoch visibility and stabilization semantics for stream updates`.
4. Add heading `3.5.4 Deterministic sequencing and coalescing policy (Pathfinder)`.
5. Add heading `3.5.5 Degradation classes and deterministic error outcomes`.
6. Under `3.2 Profiles, Feature Gates, and Compatibility`, add explicit tokens: `stream_semantics_version`, `FG_STREAM_BASE`, `FG_EXTERNAL_UPDATE_OPLOG`, `FG_RTD_LIFECYCLE`.
7. Under `5 Core Requirements`, add IDs:
- `REAL-STREAM-001` Op-only mutation for external updates.
- `REAL-STREAM-002` Deterministic replay equivalence.
- `REAL-STREAM-003` Per-topic sequence monotonicity/reject policy.
- `REAL-STREAM-004` Stale/pending visibility when `value_epoch < committed_epoch`.
- `REAL-STREAM-005` Manual recalc interaction semantics for STREAM.
- `REAL-STREAM-006` Deterministic degradation-class outcomes.

### `OPERATIONS.md`
1. Under `4.1 Packs`, define exact stream pack obligations:
- `PACK.stream.basic`
- `PACK.stream.lean.core`
- `PACK.stream.oracle.diff`
- `PACK.stream.traces.min`
2. Under `4.1 Packs`, require `PACK.concurrent.epochs` (stream action coverage) and `PACK.scaling.signature` (stream slice).
3. Under `4.2 Gate Rules`, add ID `GATE-STREAM-R0-GREEN`: all required stream packs green on Red+Blue plus artifact publication.
4. Under `3.2 Phase Model`, add explicit stream dirty-marking/closure requirement when `OpExternalUpdate` is accepted.

### `CHARTER.md`
1. Under `5. Glossary`, add terms:
- `External update op`
- `Stream semantics version`
- `Degradation class`
- `Stream replay bundle`

### `notes/BRAINSTORM_NOTES.md`
1. Under section `G. External inputs, UDFs, XLL, RTD`, add note: STREAM semantics are normative in architecture/operations docs; brainstorm entries are non-normative.

## 4) Obligation packs and success criteria for "green"
1. `PACK.visicalc.core`
- Success: baseline Pathfinder semantics remain green after STREAM integration.

2. `PACK.stream.basic`
- Success: deterministic goldens pass for topic bind/update/invalidation/recompute/stale visibility on both engines.

3. `PACK.stream.lean.core`
- Success: Lean checks pass (no admitted lemmas) for determinism + invalidation soundness + epoch-label consistency theorems.

4. `PACK.concurrent.epochs` (with external-update actions)
- Success: TLA+ invariants/liveness checks pass with zero violations.

5. `PACK.stream.oracle.diff`
- Success: Red and Blue match OCaml oracle on required canonical traces.

6. `PACK.stream.traces.min`
- Success: any failing run emits minimized reproducible trace bundle automatically.

7. `PACK.scaling.signature` (stream slice)
- Success: latency/queue-depth/memory-growth signatures stay within declared Round 0 budgets.

Global green condition:
- All packs above green in CI for Red and Blue, capability manifest advertises negotiated stream semantics/gates, and conformance report is published with no unresolved critical regressions.

## 5) Open questions (tagged by owner)
### Design
1. Define Round 1 `FG_RTD_LIFECYCLE` semantics boundary and compatibility with Round 0 traces.
2. Decide long-term collaboration oracle model (local-only vs shared authority).
3. Decide payload/range expansion policy and profile bump rules beyond Round 0 scalar set.

### Assurance
1. Finalize fairness assumptions and model bounds for liveness (`eventual stabilization`) in `PACK.concurrent.epochs`.
2. Set numeric thresholds for `PACK.scaling.signature` stream budgets per profile.
3. Define canonicalization rules for diffing delta streams when scheduling noise is non-semantic.

### Delivery
1. Confirm identical `topic_key` normalization behavior across Rust/.NET implementations with shared conformance vectors.
2. Decide retention/compaction mechanics for replay artifacts without weakening required reproducibility.
3. Finalize instrumentation schema and CI publication format for negotiation transcripts and mutation audits.

## 0->1->2->3 compatibility note
- Round 0 freezes minimal STREAM + external-op semantics and deterministic validation.
- Round 1 adds RTD lifecycle and broader interop semantics behind new gates.
- Round 2 tightens performance and invariant depth without semantic drift.
- Round 3 consolidates stable long-term compatibility guarantees.
