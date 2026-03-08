# Foundation Notes and Design Draft Context (Compact)

## Purpose
This compact source retains design-relevant content from notes and draft docs while removing run-history noise. It captures unresolved architecture asks, stable decisions, and synthesis framing for the next core-engine design pass.

## Replaced Sources
- `foundation-design-draft__design_brief.md`
- `foundation-design-draft__01_gap_map.md`
- `foundation-design-draft__03_stable_topic_entries.md`
- `foundation-design-draft__06_fec_f3e_b4_pointer_intake.md`
- `foundation-notes__BRAINSTORM_NOTES.md`
- `foundation-notes__RESEARCH_NOTES.md`
- `dag-research-synthesis__01_scope_and_question_map.md`
- `dag-research-synthesis__02_theory_and_math_catalog.md`
- `dag-research-synthesis__03_algorithm_family_map.md`
- `dag-research-synthesis__09_external_report_reconciliation.md`
- `fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SYNTHESIS.md`

## Core Design Direction to Preserve
1. Layered model:
   - immutable structural model (green-tree style),
   - structural dependency layer,
   - calc-time dependency/reference overlay,
   - spill/virtual-region overlay,
   - pure-calc fast path when overlay mutation is not needed.
2. FEC/F3E transactional seam as evaluation boundary.
3. Async/high-concurrency recalc with epoch/MVCC and deterministic publish semantics.
4. Explicit handling of formatting-sensitive calculations and visibility-priority scheduling as optional policy lanes.

## Stable Decisions Captured
### DEC-CALC-007 Formatting-Sensitive Overlay
- Default: `TEXT(value, format_text)` depends on explicit format string, not ambient cell style.
- Formula visibility of conditional-format effective style is profile-gated and provisional.
- Add explicit formatting dependency tokens to calc-time overlay for formatting-observable functions.

### DEC-CALC-008 Visibility Representation + Optional Visible-First
- Model must include explicit visibility state (`visible_regions`, `visible_nodes`, `visibility_version`, priority policy).
- Visibility can alter scheduling priority but not final semantics.
- Deterministic queue key remains required (`priority_class`, topo order, stable node id).
- Starvation prevention remains mandatory under visible-first policy.

### DEC-CALC-009 FEC/F3E Seam Adoption Gate
- Direction is conditional-go for transactional seam.
- Required hardening themes:
  - coordinator snapshot fencing,
  - runtime name/spill dependency delta use in incremental invalidation,
  - robust rejection taxonomy + structured details,
  - spill selective invalidation with conservative fallback retained.

## High-Impact Gaps to Resolve in Core Synthesis
1. Precise structural graph vs calc-time overlay lifecycle and publish boundary.
2. Overlay retention/eviction and epoch-safe garbage collection.
3. Spill invalidation algebra for prior/current spill regions.
4. Pure-calc fast-path guard conditions.
5. Deterministic parallel reduction/tie-break rules.
6. Function-catalog/profile-version invalidation triggers.
7. Published-state semantics during in-flight recalculation.
8. Exact FEC pre-resolution vs F3E semantic ownership boundary.

## DAG Research Context to Retain
Research framing and prior reconciliation converge on:
- staged adoption (baseline deterministic topo/SCC first, dynamic-topo/SAC next, differential or timely only where stream semantics justify complexity),
- obligation-driven synthesis (proof/conformance and empirical packs),
- explicit separation of dependency discovery vs execution ordering artifacts,
- trace-first evidence discipline for dynamic dependency behavior.

## Program-Level Constraints Carried Forward
1. Deterministic replay artifacts are mandatory for conformance and regression work.
2. Clean-room interop posture remains in force.
3. Epoch-tagged stale/pending visibility is user-facing contract behavior.
4. Controls/charts/names must remain first-class in engine architecture, not bolt-ons.
5. Pack-contract coupling should be explicit in architecture text and test planning.

## Open Questions to Keep Active
1. How to define canonical publication ordering when value, dependency overlay, spill overlay, and formatting overlay all change in one transaction.
2. Which deterministic replay schema becomes canonical across concurrent evaluator traces.
3. How to encode degradation classes for dynamic reference and visibility-priority edge behavior.
4. Which proofs are required for scheduler policy variation equivalence (`None` vs visible-first).

## How to Use This Compact Doc
- Treat this file as context and issue backlog for synthesis prompts.
- Treat doctrine files (`CHARTER`, `ARCHITECTURE_AND_REQUIREMENTS`, `OPERATIONS`) plus current FEC/F3E spec set as authority.
- Use DAG synthesis docs (`04`, `05`, `10`, `11`) for algorithm and assurance anchors.
