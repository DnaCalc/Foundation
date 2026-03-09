# THEORY_TO_PACK_REGISTER.md

Tracks mapping from theory-level claims to executable proof/pack obligations.

| Theory ID | Theory Claim | Mapping Type | Target Artifact(s) | Status | Notes |
|---|---|---|---|---|---|
| TH-001 | Deterministic SCC ordering and cycle terminal behavior must be profile-governed and replayable | Conformance pack + trace | PACK.dag.cycle_iterative_semantics; SCC iteration trace | promoted | Includes `PriorValueFallback`/`CycleError`/`Iterative` modes |
| TH-002 | Commit/reject publication semantics require atomic bundles and no-op rejects | Conformance pack | PACK.fec.commit_atomicity; PACK.fec.reject_detail_replay | promoted | Typed reject detail required for replay diagnostics |
| TH-003 | Calc-time overlays require strict identity keying and epoch-safe eviction | Conformance pack | PACK.fec.overlay_lifecycle | promoted | Overlay key and eviction triggers locked in profile model |
| TH-004 | Visibility-priority scheduling must preserve semantics with bounded starvation | Conformance pack | PACK.visibility.policy_equivalence; PACK.visibility.starvation_bound | promoted | Equivalence under identical op + visibility stream |
| TH-005 | External stream semantics must be versioned to preserve replay determinism | Conformance pack | PACK.dag.external_stream_ordering; PACK.stream.basic | promoted | `ExternalInvalidationV0`/`TopicEnvelopeV1`/`RtdLifecycleV2` |
| TH-006 | Runtime overlays should report incremental-vs-fallback economics | Empirical + conformance pack | PACK.overlay.fallback_economics | partially-locked | Counter schema locked; thresholds calibrated per profile by pack owners |
| TH-007 | Cross-engine divergence should be continuously surfaced as indexed replayable artifacts | Conformance pack | PACK.diff.cross_engine.continuous | accepted-planned | Promote as standing differential cockpit lane |
| TH-008 | Structural rewrite determinism must cover all reference classes and produce totality evidence | Conformance pack + deferred proof | PACK.structural.insert; deferred rewrite totality proof | promoted | Deterministic rewrite functions required per CONSTR-011 |
| TH-009 | Replay equivalence under same profile must be observational | Deferred | PACK.replay.appliance (dependency) | deferred | Depends on replay appliance portable bundle definition |
| TH-010 | INDIRECT-class dynamic dependency must have explicit bind semantics | Conformance pack | PACK.dag.dynamic_dependency_bind_semantics | promoted | Calc-time bind delta behavior under dynamic refs |
| TH-011 | Invalidation state must be explicit, not inferred from absence | Candidate conformance pack | PACK.dag.baseline_recalc_core (candidate) | accepted-planned | Explicit dirty/pending/ready/error visibility |
| TH-012 | Formatting through evaluator seam must be modeled, not inferred from renderer | Conformance pack | PACK.format.semantic_vs_display_boundary | promoted | Formula-semantic formatting crosses FEC/F3E seam per CONSTR-022 |
