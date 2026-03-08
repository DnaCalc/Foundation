# Stable Topic Entries (Discussion-Settled in This Pass)

## Scope
This document captures stable synthesis entries for three active discussion topics:
1. `DEC-CALC-007` formatting-sensitive calc overlays (`TEXT`/format introspection/CF visibility boundary),
2. `DEC-CALC-008` visibility-state representation with optional visible-first scheduling,
3. `DEC-CALC-009` FEC/F3E transactional seam adoption gate from cross-repo redesign review.

These entries are stable for synthesis-pass guidance and ready for promotion into core docs in the next edit phase.

## DEC-CALC-007: Formatting-Sensitive Calc Overlay Semantics

### Decision statement
1. `TEXT(value, format_text)` is treated as explicit format-string conversion and does not depend on ambient/effective cell style by default.
2. Formula observability of conditional-format effective style remains a profile-scoped provisional lane; default core lane assumes non-observable.
3. Formatting-sensitive dependencies are represented explicitly in calc-time overlay state, not inferred implicitly from render pipeline effects.

### Model entry
1. Add `FormatDepToken` to calc-time overlay token families.
2. `FormatDepToken` is emitted only by functions/operators declared as formatting-observable.
3. Formatting-triggered invalidation targets only nodes with matching formatting dependency tokens.

### Determinism and boundary rules
1. Formatting overlay changes do not alter core value semantics unless a formatting-observable function is involved.
2. Publication ordering for value and format overlays must be deterministic under fixed op/event stream.
3. Compatibility lanes that expose CF-effective style (if any) must be profile-gated and explicitly marked provisional.

### Conformance/pack linkage
1. `XLS-CF-FM-013` formula-visible formatting introspection.
2. `XLS-CF-FM-014` conditional-format visibility to formulas.
3. Existing probe scenarios: `FMTP1-TEXT-AMBIENT-FORMAT`, `FMTP1-CF-VISIBLE-TO-FORMULA`.

## DEC-CALC-008: Visibility-State and Optional Visible-First Scheduling

### Decision statement
1. Core model includes explicit visibility representation for nodes/regions.
2. Visibility may influence scheduling priority, never semantic outcome.
3. Visible-first scheduling is optional and profile/policy controlled.

### Model entry
1. Add `VisibilityState`:
   - `visible_regions`,
   - `visible_nodes`,
   - `visibility_version`,
   - `priority_policy` (`None` | `VisibleFirstDeterministic`).
2. Scheduler key uses deterministic ordering:
   - `(priority_class, topo_order, node_id)`.

### Determinism and fairness invariants
1. Same operations + same visibility-event stream => same publication stream.
2. Priority policy switch (`None` vs `VisibleFirstDeterministic`) must preserve final stabilized values.
3. Non-visible work must satisfy bounded-progress/no-starvation policy.

### Conformance/pack linkage
1. Candidate proof obligations:
   - semantic equivalence under priority-policy variation,
   - deterministic replay under fixed visibility-event stream.
2. Candidate empirical pack:
   - `PACK.dag.visibility_priority_signature` (latency/throughput improvement + semantic parity + starvation checks).

## DEC-CALC-009: FEC/F3E Transactional Seam Adoption Gate

### Decision statement
1. Adopt the transactional seam direction (`prepare -> open_session -> capability_view -> execute -> commit`) as the baseline architecture direction.
2. Keep adoption status as `conditional-go` until concurrency/correctness blockers are closed.
3. Treat redesign artifacts from `DnaVisiCalc` commit `4d4c7a6` as primary intake evidence for seam hardening.

### Blockers before promotion to core seam
1. Add global coordinator snapshot fencing at commit (not session-only snapshot checks).
2. Consume name-level runtime dependency deltas in incremental invalidation policy.
3. Resolve non-formula name transaction ambiguity (avoid `RejectedTokenMismatch` for literal/static names).

### Required hardening outcomes
1. Split rejection taxonomy and add structured reject detail payloads.
2. Preserve capability denial detail across execute/commit publication boundaries.
3. Extend spill delta contract for selective invalidation, while retaining conservative full-fallback default.

### Conformance/pack linkage
1. Add adversarial seam pack for token/snapshot/capability failure branches.
2. Add contention harness for delayed execute/commit with advancing epochs.
3. Add name-dynamic invalidation pack and spill-oscillation performance pack.

## Promotion status
1. Stable in this synthesis run as discussion-settled entries.
2. Next step is doc promotion into:
   - `CORE_ENGINE_FORMAL_MODEL.md`,
   - `ARCHITECTURE_AND_REQUIREMENTS.md`,
   - linked conformance/packs notes.
