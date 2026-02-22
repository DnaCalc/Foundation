*Posted by Codex agent on behalf of @govert*

# OpLog Replication Seam and Evolution Plan

## Source-of-truth check
- Documents used: `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `notes/BRAINSTORM_NOTES.md`.
- Hard conflict check: no direct contradictions found.
- Ambiguity to resolve explicitly: `notes/BRAINSTORM_NOTES.md` section J asks whether oracle/RTD values are local or shared. Resolution below: default `local` in Round 0, policy-gated `shared oracle channels` in later profiles.

## Collaboration seam (deterministic first)

```text
Client op -> Server sequencer -> Global OpLog (total order)
                                -> Clients replay ops -> local calc -> local deltas
```

- Keep collaboration as replication of the same OpLog used in single-user mode.
- Server assigns canonical order; clients never invent shared order.
- All persistent changes still obey `CONSTR-001` (ops only).

## 1) Minimal replication op schema (idempotency, ordering, tx grouping)

| Field | Required now | Purpose |
|---|---|---|
| `op_id` | Yes | Global unique op identity (UUIDv7/ULID). Idempotency key for apply/replay. |
| `author_client_id` | Yes | Stable author identity for dedupe/audit. |
| `author_op_nonce` | Yes | Monotonic per-client nonce to detect duplicates/replays before sequencing. |
| `tx_id` | Yes | Groups ops atomically. |
| `tx_index` | Yes | Order of op inside transaction. |
| `tx_size` | Yes | Validates complete transaction receipt. |
| `base_epoch` | Yes | Precondition epoch seen by author when creating tx. |
| `server_seq` | Yes (assigned by server) | Canonical total ordering key. |
| `committed_epoch` | Yes (assigned at commit) | Epoch produced by accepting tx. |
| `op_kind` + `payload` | Yes | Typed mutation payload. |
| `schema_version` | Yes | Op schema evolution/negotiation. |

### Apply rules (minimal)
- Idempotency: drop op if `op_id` already applied.
- Ordering: apply only in `server_seq` order.
- Transaction atomicity: apply `tx_id` only when all `tx_index in [0..tx_size-1]` are present and contiguous.
- Epoch precondition: if `base_epoch` is stale at submit time, server rejects tx deterministically (`conflict_stale_base`) and client must rebase/resubmit.

## 2) Identity strategy for structural edits

| Identity target | Stable now (Round 0) | Stable later (Round 1+) |
|---|---|---|
| Workbook | `workbook_id` | same |
| Sheet | `sheet_id` | same |
| Named items/tables/charts/shapes | Stable object IDs | same + richer subtype schemas |
| Cell addressing for ops | A1-style coordinates + `base_epoch` precondition | add stable row/col segment IDs for offline/optimistic merges |
| Formula references across inserts/deletes | Deterministic rewrite at commit based on server order | rewrite + anchor IDs for low-conflict concurrent editing |
| Opaque attachments/extensions | Attached to stable host object/sheet IDs | same + move/copy provenance metadata |

### Boundary decision
- Must be stable now: sheet/object/name identities and deterministic structural rewrite rules.
- Can defer: stable row/column identity graph needed for CRDT/OT/offline-first behavior.

## 3) Epochs and stabilization with remote ops

- Server commit of tx `T` creates new `committed_epoch = E+1` and broadcasts `(server_seq, committed_epoch, tx)`.
- Client replay updates DocSnapshot to `committed_epoch`; this is shared truth.
- `stabilized_epoch` remains local per client until local recalculation catches up.
- Remote ops are never blocked by a client’s local calc backlog.
- UI/API must expose staleness (`value_epoch < committed_epoch`) as required by architecture.

### Minimal invariant set
- `I1`: no client applies `server_seq = n+1` before `n`.
- `I2`: transaction visibility is atomic (no partial `tx_id` state).
- `I3`: any shown value is tagged with `value_epoch` and stale/pending status.
- `I4`: replaying the same OpLog prefix yields identical DocSnapshot.

## 4) Shared vs local state policy

| State | Replicated/shared now | Local now | Later option |
|---|---|---|---|
| Document structure/content (cells, formulas, structural edits, metadata) | Yes | No | stays shared |
| Calculation scheduling and caches | No | Yes | stays local |
| Calculated values/deltas | No (derived locally) | Yes | optional shared warm-cache hints only |
| STREAM/RTD/oracle values | No by default | Yes | profile-gated shared oracle channels as explicit ops |
| Presence (cursor, selection, viewport) | No | Yes | shared on separate ephemeral channel |
| Diagnostics/conformance artifacts | No | Yes | optional aggregated telemetry channel |

## 5) Staged evolution plan

### Stage A: Seam now (DnaVisiCalc)
- Add replication envelope fields to Op schema (`op_id`, `tx_*`, `base_epoch`, `server_seq`, `committed_epoch`).
- Implement a deterministic sequencer (single leader service or loopback server).
- Keep local-first calc (no shared value replication).
- Add pack: `PACK.collab.replication.core` (idempotency, ordering, tx atomicity, replay determinism).

### Stage B: Basic presence (early DnaPreCalc)
- Add separate ephemeral presence channel (cursor/selection/user status).
- Presence is explicitly non-semantic: never mutates OpLog document state.
- Add pack: `PACK.collab.presence.isolation` (presence cannot affect calc/doc determinism).

### Stage C: Richer collaboration (DnaPreCalc -> DnaSuperCalc)
- Add optimistic submits with deterministic rebase protocol on server reject.
- Introduce stable row/col anchor identities for higher structural-edit concurrency.
- Add optional shared oracle topics as explicit replicated events under profile policy.
- Add packs: `PACK.collab.rebase`, `PACK.collab.structural.anchor_ids`, `PACK.collab.oracle.policy`.

## Proposed doc edits (exact headings/IDs)
- `ARCHITECTURE_AND_REQUIREMENTS.md`:
  - Extend `3.9 Collaboration (designed-in seam)` with normative replication envelope fields and deterministic server sequencing rules.
  - Extend `3.3 Epoch Model (MVCC-style)` with remote-op replay semantics (`committed_epoch` shared vs `stabilized_epoch` local).
  - Extend `3.5 External Streaming and RTD-like Behavior` with profile policy for local vs shared oracle events.
- `OPERATIONS.md`:
  - Extend `4.1 Packs` with collaboration packs (`PACK.collab.replication.core`, `PACK.collab.presence.isolation`, `PACK.collab.rebase`).

## Smallest next actions (highest risk reduction)
1. Freeze the replication envelope schema and add protocol negotiation for `schema_version`.
2. Build a replay harness test: same OpLog prefix across two clients must produce identical DocSnapshot hash.
3. Add one structural edit case (insert row with formula rewrite) under replicated sequencing and assert deterministic results.
4. Define profile policy default: oracle values are local in Round 0; shared oracle requires explicit opt-in profile capability.
