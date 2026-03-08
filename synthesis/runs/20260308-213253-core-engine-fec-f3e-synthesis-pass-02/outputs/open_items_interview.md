# Open Items Interview Ledger

Run: `20260308-213253-core-engine-fec-f3e-synthesis-pass-02`
Date: 2026-03-09
Mode: interview-style decision closure

## Method
For each open decision:
1. Capture user intent in plain language.
2. Convert to normative wording target.
3. Record risks accepted.
4. Record required pack/proof follow-up.
5. Set status: `proposed` -> `locked`.

## Decisions

### ODR-001 Publish Ordering Contract
Status: locked (atomicity + reject-cause tracing)
Question focus: when value/dependency/spill/format/display deltas co-occur, what canonical publication sequence and atomicity boundary do we commit to?
Answer: Yes. Keep one atomic publish unit per committed node. Rejects publish nothing. Also track why reject/error occurred.
Normative text draft:
- `commit(Applied)` SHALL publish exactly one atomic derived bundle for the node.
- Bundle fields SHALL include at minimum: `value_delta`, `topology_delta`, `shape_delta`, and optional `display_delta`/`format_delta`.
- `commit(Rejected)` SHALL publish no value/topology/shape/display deltas.
- Every `Rejected` result SHALL carry `reject_code` plus structured `reject_detail` (expected/actual token, expected/actual snapshot fence, capability denial context, and formula/session identity).
Risks accepted:
- Slightly larger commit payload and trace volume.
- More rejection classes to maintain across lanes.
Follow-up packs:
- `PACK.fec.commit_atomicity`
- `PACK.fec.reject_detail_replay`
- `PACK.concurrent.epochs` (reject-fence determinism)

### ODR-002 Cycle Semantics Compatibility Wording
Status: locked (3-mode profile enum)
Question focus: how do we encode v0 non-iterative carry-forward behavior alongside Foundation target modes without ambiguity?
Answer: Use explicit 3-mode profile enum with direct v0 mapping.
Normative text draft:
- Profile MUST declare `CycleSemantics` as one of:
  - `PriorValueFallback`
  - `CycleError`
  - `Iterative`
- `PriorValueFallback` MUST preserve v0 semantics:
  - recalc remains non-fatal for circularity,
  - circular reads use prior stabilized values when available, otherwise `0.0`,
  - non-fatal diagnostic emission is required.
- `CycleError` and `Iterative` remain target modes for non-v0 profiles.
Risks accepted:
- Adds one more explicit mode to maintain in conformance matrix.
- Requires profile-aware reporting in host UX.
Follow-up packs:
- `PACK.dag.cycle_iterative_semantics`
- v0 compatibility lane in `PACK.visicalc.core`
- cycle diagnostic replay lane in `PACK.concurrent.epochs`

### ODR-003 Stream Semantics Version Mapping
Status: locked (3-version profile enum)
Question focus: exact profile versioning and compatibility mapping for pathfinder stream behavior vs future RTD-like behavior.
Answer: Lock 3 explicit stream versions and remove `Dvc` prefix.
Normative text draft:
- Profile MUST declare `StreamSemanticsVersion` as one of:
  - `ExternalInvalidationV0`
  - `TopicEnvelopeV1`
  - `RtdLifecycleV2`
- Mapping:
  - `ExternalInvalidationV0`: pathfinder externally-driven invalidation behavior.
  - `TopicEnvelopeV1`: topic/sequence envelope with deterministic ordering and dedupe replay.
  - `RtdLifecycleV2`: full RTD-style topic lifecycle semantics.
Risks accepted:
- Version proliferation across adapters if mapping is not centrally enforced.
- Transitional dual-support period between V0 and V1.
Follow-up packs:
- `PACK.stream.basic`
- `PACK.dag.external_stream_ordering`
- stream version cross-profile replay matrix in `PACK.concurrent.epochs`

### ODR-004 Overlay Lifecycle and Epoch-safe GC
Status: locked (strict key + watermark GC)
Question focus: create/retain/evict policy keyed by epoch/token/bind/profile and GC guardrails.
Answer: Lock strict overlay keying and deterministic eviction policy.
Normative text draft:
- Overlay identity key SHALL be:
  `(snapshot_epoch, wave_id, formula_stable_id, formula_token, bind_hash, profile_version)`
- Overlay reuse SHALL be allowed only when all key fields match.
- Immediate eviction triggers SHALL include:
  - snapshot epoch change for the node,
  - formula token/bind/profile mismatch,
  - structural rewrite impacting bound references.
- GC policy SHALL retain overlays only for:
  - active sessions, and
  - current stabilization window.
- Non-pinned overlays older than `min_active_session_epoch` SHALL be evicted.
Risks accepted:
- Higher recalculation frequency after structural churn due to strict reuse policy.
- More coordinator bookkeeping for pinned debug/replay windows.
Follow-up packs:
- `PACK.fec.overlay_lifecycle`
- `PACK.concurrent.epochs` (pin/unpin/GC safety)
- `PACK.dag.dynamic_dependency_bind_semantics`

### ODR-005 Formatting Observability Boundary
Status: locked (default-off ambient observability + seam-owned semantic formatting lanes)
Question focus: `TEXT` explicit format semantics, ambient/effective format visibility, and CF-effective-style observability policy.
Answer: Lock default-off ambient observability. Also explicitly route semantic formatting evaluation through OxFml via FEC/F3E seam, not display-only layer.
Normative text draft:
- `TEXT(value, format_text)` SHALL be treated as explicit format-string conversion semantics.
- Ambient/effective style SHALL NOT be formula-visible by default.
- Conditional-format effective-style observability SHALL remain profile-gated and disabled by default.
- If observability is enabled by profile, it SHALL use explicit dependency token lanes (`FormatDepToken`, `CFDepToken`) with deterministic invalidation.
- Formatting behavior that is formula-semantic, including format-string interpretation and conditional-format configuration evaluation lanes, SHALL execute in the OxFml layer and traverse the FEC/F3E seam. It SHALL NOT be modeled as a pure display-layer-only concern.
Risks accepted:
- Added seam complexity for formatting-semantic lanes.
- Need clear boundary to avoid duplicate logic between evaluator and renderer.
Follow-up packs:
- `PACK.format.semantic_vs_display_boundary`
- `PACK.fec.format_dependency_tokens`
- `XLS-CF-FM-013` / `XLS-CF-FM-014` empirical closure lanes

### ODR-006 Visibility-first Fairness and Equivalence
Status: locked (optional policy, deterministic order, fairness bound)
Question focus: fairness bound and equivalence proof obligations when visibility-first is enabled.
Answer: Lock optional visibility-first policy with deterministic queue key and fairness default `max_deferred_waves = 8`.
Normative text draft:
- `VisibleFirst` SHALL be optional and profile/policy controlled.
- Scheduler order key SHALL be deterministic:
  `(priority_class, topo_bucket, stable_node_id)`.
- Fairness constraint SHALL hold:
  no ready non-visible node may be deferred beyond `max_deferred_waves` scheduling waves.
- Default `max_deferred_waves` SHALL be `8`, profile-tunable.
- Policy equivalence requirement:
  given identical operations and visibility-event stream, stabilized semantics SHALL be equivalent under `None` and `VisibleFirst`.
Risks accepted:
- Slight throughput tradeoff from fairness forcing.
- More policy-surface testing burden.
Follow-up packs:
- `PACK.visibility.policy_equivalence`
- `PACK.visibility.starvation_bound`
- `PACK.concurrent.epochs` (visibility-event replay determinism)

### ODR-007 Tree-host Spill Analog Policy
Status: locked (explicit defer)
Question focus: does tree-host model spill analog explicitly or defer/forbid it in early phases?
Answer: Explicitly defer spill-analog semantics in early tree-host phases.
Normative text draft:
- Early tree-host phases SHALL NOT model spreadsheet-style spill-region semantics.
- Multi-result behavior in tree hosts SHALL use explicit node/value constructs, not implicit spill overlays.
- Spill-analog reconsideration SHALL be gated behind core overlay/publish/concurrency pack closure.
Risks accepted:
- Temporary behavior gap between tree-host and grid-host semantics.
- Requires migration note when/if spill analog is introduced later.
Follow-up packs:
- `PACK.treehost.multiresult.explicit`
- `PACK.treehost_to_gridhost.semantic_gap_registry`

### ODR-008 CURRENT_SPEC_SET Pointer Hygiene
Status: locked (prompt-pack maintenance rule)
Question focus: update pointer file scope and maintenance rule.
Answer: Lock pointer hygiene rule and require same-change updates for renamed/replaced files.
Normative text draft:
- `CURRENT_SPEC_SET.md` SHALL list only current-best files that are actually present and maintained in the curated pack.
- When a referenced file is renamed/replaced (for example `*_cleaned.md` adoption), `CURRENT_SPEC_SET.md` SHALL be updated in the same change.
- This rule is prompt-pack hygiene (managed-run input integrity), not doctrine text.
Risks accepted:
- Minor overhead on prompt-pack maintenance.
- Requires reviewer discipline to catch pointer drift.
Follow-up packs:
- N/A (hygiene rule)
- Enforced via managed-run checklist and source-hash freeze validation
