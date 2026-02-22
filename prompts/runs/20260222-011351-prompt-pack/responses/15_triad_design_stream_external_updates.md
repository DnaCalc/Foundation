# Triad Prompt - Design
Task: Define STREAM + external updates semantics for DnaVisiCalc.

## 1) Decision framing
### Must be decided now
- Canonical mutation path: every external update that can affect persisted workbook meaning must be represented as an OpLog operation (no side channel state mutation).
- STREAM semantic contract at profile level: define what `STREAM(topic)` means under `profile_id + profile_version`, including staleness visibility and deterministic replay mode.
- Epoch attachment rules: define how external updates relate to `committed_epoch`, `stabilized_epoch`, and `value_epoch`, and what users/API observe while recomputation is pending.
- Capability negotiation contract: define how clients/providers declare support for STREAM semantics version and external update feature gates.
- Graceful degradation rules: define behavior when STREAM/external updates are unsupported, partially supported, or unknown in a negotiated profile.
- Obligation coverage for readiness: define the minimum pack obligations required to call the profile stabilized for stream behavior (`PACK.stream.basic` at minimum).

### Can be deferred
- Full RTD topic lifecycle parity and advanced subscription economics (Round 1+).
- Collaboration policy for external oracle values (local-only vs shared oracle stream) beyond deterministic single-node semantics.
- Provider QoS policies (priority tiers, backpressure classes, fairness policy details).
- Async UDF continuation interplay with STREAM beyond an explicit "not in Pathfinder" boundary.
- Non-core UX polish for stream diagnostics, beyond required stale/pending observability.

## 2) Proposed spec shape
### Module A: Stream Semantics Core
Boundary:
- Inside core semantics/profile: meaning of `STREAM(topic)` as a formula primitive.
- Outside core: provider transport and acquisition mechanics.

Spec responsibilities:
- Value model for STREAM outputs.
- Topic identity normalization contract.
- Deterministic replay semantics for conformance/oracle runs.

### Module B: External Update Operation Contract
Boundary:
- Core accepts versioned `ExternalUpdateOp` records through protocol/OpLog path only.
- Adapters/providers may observe external systems, but they cannot mutate state except by emitting operations.

Spec responsibilities:
- Operation schema versioning.
- Ordering/idempotence expectations at protocol boundary.
- Replayability and evidence hooks for minimized traces.

### Module C: Epoch and Visibility Contract
Boundary:
- Core defines epoch transitions and stale/pending exposure.
- UI/API consume status; they do not infer hidden state.

Spec responsibilities:
- Mapping from accepted external update ops to invalidation/recompute obligations.
- Observable `value_epoch` and stale/pending requirements.
- Deterministic guarantees for pinned snapshots.

### Module D: Capability and Feature-Gate Contract
Boundary:
- Negotiation surface is protocol/profile metadata.
- Feature realization is profile-scoped, not implementation-scoped.

Spec responsibilities:
- Stream semantics version token (example: `stream_semantics_version`).
- Feature gates (example set): `FG_STREAM_BASE`, `FG_EXTERNAL_UPDATE_OPLOG`, `FG_RTD_LIFECYCLE`.
- Cross-version compatibility and downgrade behavior.

### Module E: Degradation and Error Contract
Boundary:
- Core defines explicit deterministic outcomes.
- Adapters may add diagnostics but cannot alter canonical error classes.

Spec responsibilities:
- Unknown/unsupported STREAM function behavior.
- Unsupported provider/update payload handling.
- Required diagnostics for conformance and user-visible warnings.

### Profile / feature-gate implications
- `DnaVisiCalc` profile must require `FG_STREAM_BASE + FG_EXTERNAL_UPDATE_OPLOG` and must not require full RTD lifecycle.
- A profile that lacks STREAM support must still load/round-trip documents and surface deterministic unsupported-feature outcomes.
- Version bumps:
  - Non-breaking semantic extension: minor profile version bump.
  - Breaking change to STREAM meaning, update ordering guarantees, or stale visibility contract: major profile version bump.

## 3) Crisp definitions (new terms)
- STREAM topic key: Canonical profile-defined identity string used by `STREAM(topic)` for dependency binding.
- External update op: Versioned OpLog record representing externally sourced value change intent for one topic key in one workbook context.
- Stream semantics version: Negotiated version token that fixes interpretation rules for STREAM and external update ops.
- Stream stabilization point: Earliest `stabilized_epoch` in which all accepted external update ops up to a declared boundary are reflected in derived values for the declared scope.
- Degradation class: Deterministic category for unsupported/unknown stream behavior (`unsupported_feature`, `unknown_payload`, `provider_unavailable`, `profile_mismatch`).
- Replay bundle (stream): Deterministic artifact set containing external update op sequence, profile/version, and required diagnostics for re-run and minimization.

## 4) Scope: Pathfinder minimum and forward-compatible 0->1->2->3
### Round 0 (DnaVisiCalc) - minimum viable
- Define `STREAM(topic)` in one profile with explicit stream semantics version.
- Accept external updates only via versioned external update ops through protocol -> OpLog.
- Require stale/pending/value_epoch observability in API/UI contract.
- Require deterministic replay mode for stream cases.
- Gate readiness with `PACK.stream.basic` plus existing epoch/concurrency invariants.
- Explicitly out of scope: full RTD lifecycle parity, distributed/shared oracle semantics, advanced QoS.

### Round 1 (DnaPreCalc) - full-system foundation
- Add RTD-like lifecycle semantics as profile-gated extension without breaking Round 0 docs.
- Expand negotiation matrix for provider capabilities and update payload forms.
- Define stronger interop degradation/round-trip rules for file/protocol edges.

### Round 2 (DnaSuperCalc) - refactor/perfection
- Normalize cross-engine behavioral signatures for stream-heavy schedules.
- Tighten formal invariants around update ordering, eventual stabilization, and exclusive mutation interactions.
- Introduce stricter pack partitions for throughput/signature regressions without semantic drift.

### Round 3 (DnaCalc) - synthesized long-term product
- Consolidate stream and RTD semantics under stable profile family and long-lived negotiation policy.
- Freeze backward-compatibility commitments for stream semantics versions and documented downgrade paths.
- Keep graceful degradation guarantees as non-negotiable compatibility surface.

## 5) Smallest doc edit set needed
No source conflict detected across the four docs for this topic; notes are consistent with charter/operations/architecture precedence.

### `ARCHITECTURE_AND_REQUIREMENTS.md`
Add/adjust headings:
- Under `3.5 External Streaming and RTD-like Behavior`, add:
  - `3.5.1 STREAM semantic contract (profile-scoped)`
  - `3.5.2 External update op contract (versioned, replayable)`
  - `3.5.3 Epoch visibility and stabilization semantics for stream updates`
  - `3.5.4 Degradation classes and deterministic error outcomes`
- Under `3.2 Profiles, Feature Gates, and Compatibility`, add explicit stream feature-gate/version negotiation bullets.
- Under `5 Core Requirements`, add explicit REAL statements for stream replay determinism and degradation classes.
Remove:
- Any ambiguous wording that implies external updates may bypass OpLog (none currently explicit, but add one clarifying sentence that they may not).

### `OPERATIONS.md`
Add/adjust headings:
- Under `4.1 Packs`, expand `PACK.stream.basic` with required evidence artifacts:
  - replay bundle,
  - minimized failing trace requirements,
  - stale/pending visibility assertions.
- Under `3.2 Phase Model`, clarify stream update-induced dirty marking/closure expectations as a profile obligation.
Remove:
- Nothing required.

### `CHARTER.md`
Add/adjust headings:
- Under `5. Glossary`, add short terms:
  - `External update op`
  - `Stream semantics version`
  - `Degradation class`
Remove:
- Nothing required.

### `notes/BRAINSTORM_NOTES.md`
Add/adjust headings:
- Under `G. External inputs, UDFs, XLL, RTD`, add a note that canonical semantics now live in architecture/operations sections above and treat brainstorm items as non-normative.
Remove:
- Optionally prune now-resolved open question entries once captured in normative docs; keep unresolved items only.
