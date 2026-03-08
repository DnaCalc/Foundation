# Prompt Pack Draft: Core Engine DAG + FEC/F3E Synthesis

## Prompt 01 - Layered semantic model draft
Draft a normative layered model for core calculation engine semantics that integrates:
1. immutable structural green tree,
2. structural reference/dependency graph,
3. calc-time dependency/refinement overlay,
4. spill/virtual-region overlay,
5. pure-calc fast path.
Return state sets, transition rules, and invariants.

## Prompt 02 - FEC/F3E call protocol hardening
Given FEC/F3E draft specs, produce an implementation-ready protocol contract:
1. call ordering,
2. context payloads,
3. dependency token/version lifecycle,
4. violation/error mapping,
5. deterministic trace artifacts.
Highlight required profile/version fields.

## Prompt 03 - Dynamic references and spill overlays
Formalize INDIRECT-class and dynamic-array spill behaviors as overlay mechanics:
1. overlay edge creation/update/removal,
2. old/new spill invalidation semantics,
3. fallback behavior under capability denial,
4. conformance/proof obligations.

## Prompt 03B - Formatting-sensitive calc overlay semantics
Formalize formatting-aware evaluation semantics where formula values depend on formatting context/state (for example TEXT):
1. formatting dependency declaration and tokenization,
2. overlay invalidation triggers from formatting changes,
3. deterministic publication ordering with value and format overlays,
4. fast-path criteria when formatting dependencies are unchanged.

## Prompt 04 - Concurrency, epochs, and async recalc visibility
Design an epoch/MVCC-compatible async recalculation model that supports:
1. snapshot reads during recalculation,
2. deterministic publish boundaries,
3. lock/await discipline,
4. replay equivalence.
Return failure modes and mitigation constraints.

## Prompt 04B - Visibility-state model and prioritized scheduling
Design a core-model visibility representation and optional priority policy:
1. how visible nodes/regions are represented and versioned,
2. when visibility changes invalidate scheduling priorities,
3. deterministic rules for visible-first scheduling (without semantic drift),
4. interaction with epochs, overlays, and pure fast-path mode.

## Prompt 05 - Pack and proof closure
Convert the final model into:
1. obligation IDs (theorems/invariants),
2. pack contracts (scope, fixtures, thresholds, emitted artifacts),
3. staged promotion criteria (Now -> Next -> Later).
Align with Operations pack contract discipline.

## Prompt 06 - Architecture promotion diff plan
Produce explicit edits to:
1. CORE_ENGINE_FORMAL_MODEL.md,
2. ARCHITECTURE_AND_REQUIREMENTS.md,
3. OPERATIONS.md,
4. notes/RESEARCH_NOTES.md.
Each suggestion must include `accept/adapt/defer/reject` rationale and source references.
