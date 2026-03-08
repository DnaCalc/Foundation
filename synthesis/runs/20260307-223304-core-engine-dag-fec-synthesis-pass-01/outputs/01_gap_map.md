# Gap Map: Requested Design vs Existing Architecture/Doctrine Constraints

## A. What is already strongly aligned
1. Layered semantics (S/R/D/V/O) and immutable-core direction are already present in CORE_ENGINE_FORMAL_MODEL.md and architecture sections 3.11..3.17.
2. Distinct invalidation classes (Standard / Volatile / ExternallyInvalidated) and explicit external-update ops are already mandated.
3. Deterministic replay, SCC cycle policy, and epoch-tagged visibility are already hard requirements.
4. FEC/F3E call sequence and capability-gating model already exists as a draft protocol baseline.

## B. High-impact gaps to resolve in this synthesis
1. Structural DAG vs calc-time overlay semantics:
   - Need a normative rule for when calc-time observations become overlay edges vs transient execution-only facts.
2. Overlay lifecycle and garbage collection:
   - Need epoch-safe retention/eviction rules for dependency tokens, dynamic edges, and spill-region virtual entities.
3. Spill invalidation algebra:
   - Need explicit set-based semantics for old-spill-region and new-spill-region invalidation and dependency churn.
4. Fast-path criteria:
   - Need formal guard conditions for pure-calc mode where overlay mutation is skipped.
5. Async + lock discipline integration:
   - Need explicit model that satisfies CONSTR-008 while permitting parallel/asynchronous recalculation and snapshot reads.
6. Visibility-state representation and scheduler influence:
   - Need explicit model-level representation of visible nodes/regions and deterministic policy for optional visible-first prioritization.
7. FEC/F3E boundary for reference resolution:
   - Need exact split between pre-resolved handles by FEC and semantic coercion/normalization in F3E.
8. Formatting-sensitive evaluation overlays:
   - Need explicit semantics for functions whose value depends on formatting context/state (for example TEXT) and how formatting-triggered invalidations are represented in calc-time overlay state.
9. Dynamic reference policy tiers:
   - Need profile-gated behavior for INDIRECT-class formulas: conservative invalidation vs observed-dependency tracking.
10. Published-state semantics during in-flight recalculation:
   - Need precise visibility model for readers when overlay updates are pending but not yet published.
11. Determinism under parallel reduction:
   - Need canonical reduction and tie-break policy stated in core model text, not only in pack notes.
12. Function catalog/version invalidation:
   - Need explicit recompilation/invalidation triggers tied to catalog/profile/version changes.

## C. Gaps against broader program architecture
1. Controls/charts/names are in-scope engine entities but not explicitly integrated into your overlay narrative yet.
2. Collaboration replication constraints (idempotency/causality envelopes) need explicit compatibility with overlay token/version semantics.
3. Pack-contract coupling is not yet explicit in your design narrative (required by Operations doctrine).
4. Degradation policy classes (Native/Lowered/Opaque/Rejected) are not yet mapped for dynamic-reference, spill-edge, formatting-sensitive overlay, or visibility-prioritization corner cases.

## D. Proposed synthesis decision blocks
1. DEC-CALC-001: Overlay mutation semantics and publish boundaries.
2. DEC-CALC-002: Spill-region lifecycle and reference invalidation model.
3. DEC-CALC-003: Pure-calc fast-path eligibility and fallback conditions.
4. DEC-CALC-004: FEC pre-resolution vs F3E semantic ownership contract.
5. DEC-CALC-005: Async scheduler + epoch visibility + lock discipline model.
6. DEC-CALC-006: Dynamic-reference profile tiers and promotion criteria.
7. DEC-CALC-007: Formatting-sensitive calc overlay semantics and invalidation policy.
8. DEC-CALC-008: Visibility-state model and optional visible-first scheduling policy.
