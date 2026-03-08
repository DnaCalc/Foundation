# Deep Research Prompt: Core DAG Recalc + FEC/F3E Seam (Compact Curated Pack)

You are reviewing a compact source set for DNA Calc Foundation. This pack is intentionally reduced for design synthesis and contains only current, design-relevant material.

## Objective
Produce a state-of-the-art architecture/design (or 2-3 coherent design options) for:
1. Core calculation engine model:
   - immutable structural model (green-tree style persistence),
   - layered references world,
   - structural dependency graph,
   - calc-time dependency/reference overlay,
   - recalc cycles (full/incremental/hybrid),
   - pure-calc fast paths.
2. FEC/F3E formula evaluation seam:
   - interface contracts for prepare/session/capability/execute/commit,
   - interaction with structural reference graph building,
   - calc-time dynamic reference resolution (INDIRECT/OFFSET/etc.),
   - spill-region lifecycle and invalidation overlays,
   - value + formatting -> display evaluation dependencies,
   - scheduler and policy boundaries.
3. Concurrency and visibility:
   - async/high-concurrency recalc,
   - epoch/MVCC snapshot correctness,
   - optional visible-first prioritization preserving semantic determinism.

## Source handling rules
- Use only files under `inputs/source/`.
- Ignore `inputs/retired/` (superseded material).
- Cite source paths for key claims.
- If a lane uses `F3C`, map `F3E -> F3C` terminology explicitly.
- Preserve clean-room discipline.
- `inputs/source/` is a flat directory with prefixed filenames.
- For FEC/F3E contracts, treat files prefixed `fec-f3e-current-spec__` as authoritative.
- Use compact summaries as the source of implementation/evidence context unless you need to challenge them.

## Required analysis focus
1. Transaction boundary correctness: snapshot fencing, token/version semantics, deterministic failure behavior.
2. Layer model fit: structural graph vs calc-time overlay vs display/format overlay.
3. Invalidation semantics: structural edits, runtime dependency deltas, spill-shape/topology events.
4. Scheduler policy: incremental selection, fallback policy, visible-first optional policy, fairness/starvation.
5. FEC/F3E contract quality: stable IDs, delta payload decomposition, policy-vs-evidence boundary.
6. Migration path: current DnaVisiCalc seam -> Foundation-ready core model.
7. Assurance plan: formal obligations, conformance packs, empirical harnesses, trace schema needs.

## Deliverables (strict order)
1. Findings (ordered by severity).
2. Design options (2-3 options) with trade-off matrix.
3. Recommended target architecture.
4. Normative contract draft:
   - key types/interfaces,
   - commit result/reject taxonomy,
   - required deltas/events,
   - epoch/token rules.
5. Recalc and overlay semantics:
   - structural dependency graph rules,
   - calc-time overlay rules,
   - spill/format/visibility overlay interaction rules.
6. Concurrency model:
   - coordinator responsibilities,
   - snapshot fences,
   - contention/retry behavior.
7. Adoption roadmap:
   - phased plan,
   - compatibility shims,
   - blocker gates.
8. Open questions and decisive experiments.
9. Pack/proof checklist (concrete and testable).

## Output quality bar
- Prefer explicit invariants over narrative.
- Separate policy from mechanism.
- Call out ambiguities and propose exact contract text where possible.
- Include at least one conservative and one ambitious design path before final recommendation.

## Entry point
Start with:
- `inputs/source/foundation-core__CHARTER.md`
- `inputs/source/foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md`
- `inputs/source/foundation-core__CORE_ENGINE_FORMAL_MODEL.md`
- `inputs/source/fec-f3e-current-spec__CURRENT_SPEC_SET.md`
- `inputs/source/fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md`
- `inputs/source/fec-f3e-summary__implementation_and_runtime_evidence_compact.md`
- `inputs/source/synthesis-context__foundation_notes_and_design_draft_compact.md`
- `inputs/source/dag-research-synthesis__05_deep_research_synthesis.md`
- `inputs/source/dag-research-synthesis__10_conformance_and_proof_obligations.md`

Then expand to the remaining files in `inputs/source/` as needed.
