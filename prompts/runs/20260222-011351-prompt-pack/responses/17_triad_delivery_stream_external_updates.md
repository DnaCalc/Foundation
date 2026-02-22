*Posted by Codex agent on behalf of @govert*

# Triad Prompt - Delivery
Task: Define STREAM + external updates semantics for DnaVisiCalc.

## 1) Implementation impact (Red/Rust, Blue/.NET, shared protocol)
### Shared protocol surface (must be identical)
- Add versioned op schema: `OpExternalUpdate` (`topic_key`, `source_seq`, `payload`, `source_ts`, `trace_id`).
- Require capability negotiation fields:
  - `stream_semantics_version`
  - feature gates: `FG_STREAM_BASE`, `FG_EXTERNAL_UPDATE_OPLOG`
- `DispatchOps` must accept `OpExternalUpdate` exactly like any other persistent mutation path.
- `QuerySnapshot` must expose `committed_epoch`, `stabilized_epoch`, and value status (`fresh|stale|pending`) with `value_epoch`.
- `SubscribeDeltas` must emit deterministic delta envelopes: `op_id`, `cause=external_update`, affected cells, and epoch tags.

### Red (Rust) impact
- Implement `STREAM(topic)` binder node keyed by canonical `topic_key`.
- Coordinator path: append `OpExternalUpdate` -> advance `committed_epoch` -> invalidate dependency closure -> schedule recompute.
- Keep core pure: provider ingestion remains adapter-side; core receives only ops.
- Deterministic mode: fixed scheduler policy + fixed reduction order + deterministic op ordering by `(op_index, topic_key, source_seq)`.

### Blue (.NET) impact
- Mirror the same semantics with independent internals (no shared runtime/lib with Rust).
- Same canonical topic normalization and sequence policy at protocol boundary.
- Same epoch/state exposure and delta envelope contract.
- Deterministic mode must produce byte-equivalent canonical traces under the shared schema.

## 2) Minimal implementable plan (pack-passing, no overbuild)
1. Freeze protocol contracts:
- Schema for `OpExternalUpdate`, snapshot status fields, and delta envelope.
- Capability negotiation for stream semantics version/gates.

2. Implement minimal STREAM semantics in both engines:
- `STREAM(topic)` as scalar producer only.
- Deterministic canonical topic normalization.

3. Wire external updates through OpLog only:
- Adapter emits `OpExternalUpdate`.
- Core forbids any side mutation path.

4. Implement epoch/staleness behavior:
- On accepted external op: increment `committed_epoch`.
- During recompute: stale/pending visible.
- On completion: `stabilized_epoch` catches up; emit deltas.

5. Add deterministic replay + basic conformance slice:
- Canonical trace format (`ops.jsonl` -> `deltas.jsonl` + final snapshot hash).
- Run minimum required stream scenarios for `PACK.stream.basic` and epoch/concurrency checks already required by profile.

Out of scope for this pass:
- Full RTD lifecycle semantics, collaboration oracle sharing policy, async UDF continuations.

## 3) Risk hotspots and early instrumentation
1. Concurrency race (old compute overwrites newer external op)
- Instrument: epoch CAS guard failures, per-cell monotonic `value_epoch` assertion, structured rejection logs.

2. Burst update backlog and latency cliffs
- Instrument: queue depth, op->invalidate latency, invalidate->stabilize latency, fanout size histogram.

3. Cross-engine drift (same trace, different deltas)
- Instrument: canonical trace hash at checkpoints (`post-op`, `post-stabilize`) and diff artifacts in CI.

4. Duplicate/out-of-order source sequences
- Instrument: per-topic sequence tracker metrics (`accepted`, `duplicate_reject`, `out_of_order_reject`).

5. Interop ambiguity at protocol boundary
- Instrument: negotiation transcript capture (requested vs agreed `stream_semantics_version` and gates).

6. Hidden mutation regression
- Instrument: mutation audit hook asserting every stream-visible change links to an `op_id` in OpLog.

## 4) Spec areas that must be sharper to prevent divergent implementations
- Duplicate/out-of-order policy must be normative (reject vs idempotent drop vs last-write-wins).
- Coalescing semantics must be fixed (apply each op vs collapse by topic within a scheduling slice).
- Manual recalc interaction with STREAM invalidation must be explicit (what updates immediately vs deferred).
- Canonical `topic_key` normalization rules must be exact (case, whitespace, locale, Unicode normalization).
- Payload type set and conversion/error behavior must be fixed for Pathfinder (numeric/text/error/null).
- Replay retention requirement must be explicit (always persisted ops vs profile-scoped harness-only retention).

Edit path:
- Put normative rules in `ARCHITECTURE_AND_REQUIREMENTS.md` section `3.5` + `5` REAL statements.
- Put gate/evidence requirements in `OPERATIONS.md` under `PACK.stream.basic`.
- Keep brainstorm notes non-normative and aligned.

## 5) First working demo definition (ops -> snapshot -> deltas)
Demo objective:
- Prove end-to-end flow for DnaVisiCalc STREAM semantics in both engines independently.

Demo setup:
- Workbook with cells:
  - `A1 = STREAM("price:ABC")`
  - `B1 = A1*2`
  - `C1 = IF(B1>100,"HIGH","LOW")`
- Deterministic external trace: three `OpExternalUpdate` events for `price:ABC` with strict `source_seq`.

Must demonstrate:
1. Ops:
- Each update enters through `DispatchOps` as `OpExternalUpdate` and is present in OpLog.

2. Snapshot:
- `committed_epoch` increments per accepted op.
- While recompute is incomplete, queried values expose stale/pending with prior `value_epoch`.

3. Deltas:
- `SubscribeDeltas` emits dependent cell updates (`A1`, `B1`, `C1`) with cause linking to the external op and final `value_epoch`.
- `stabilized_epoch` reaches `committed_epoch` after recompute.

Cross-engine acceptance:
- Red and Blue produce equivalent canonical delta traces and final snapshot hash for the same input trace.
- Re-running the same trace in deterministic mode yields identical artifacts.
