# Synthesis Report

Run ID: `20260309-004109-improvement-notes-synthesis-pass-01`
Date: 2026-03-09
Scope: Evaluate two improvement notes (CODEX1/CODEX2) and promote high-value guidance into Foundation source-of-truth docs.

## Inputs
- `notes/IMPROVEMENT_SUGGESTIONS_CODEX1.md`
- `notes/IMPROVEMENT_SUGGESTIONS_CODEX2.md`
- Doctrine/context docs: `README.md`, `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, `notes/BRAINSTORM_NOTES.md`

## Synthesis Outcome
- Accepted: 10
- Adapted: 6
- Deferred: 0 (after follow-up ODR closure)
- Rejected: 0

## Promoted Changes
1. `OPERATIONS.md`
- Added host-conformance ladder policy (`8.12`) requiring host semantic commitments, acceptance matrix, degradation matrix, and required gate artifacts.
- Added explicit promotion-packet contract (`8.13`) requiring target text, evidence, open questions, and pack/gate impact before doctrine promotion.
- Added dependency-constitution and theory-to-pack mapping policy (`8.14`) and linked register location.
- Added improvement-pass candidate packs in `4.1` for host ladders, forensic traces/replay appliance, continuous differential cockpit, reject taxonomy, and overlay fallback economics.

2. `ARCHITECTURE_AND_REQUIREMENTS.md`
- Added `CONSTR-023`: semantic truth must remain invariant under runtime strategy/optimization choices.
- Added `CONSTR-024`: required profiles must emit portable replay bundles and forensic traces for deterministic causality/differential triage.
- Added INT/REAL for cross-engine differential divergence indexing with replay handles.

3. `README.md`
- Added pointer to `notes/THEORY_TO_PACK_REGISTER.md`.

4. `notes/THEORY_TO_PACK_REGISTER.md` (new)
- Seeded theory-to-pack mapping register with promoted and deferred entries.

## Key Adaptations
- Promotion-gate suggestion was adapted because managed-run synthesis gating already existed; this pass made the gate contract explicit.
- Continuous differential cockpit was adapted as candidate-pack + architecture realization, not yet a hard release gate requirement.
- Typed reject calculus was adapted because base structured reject semantics already existed; this pass added explicit pack-level closure direction.

## ODR Closure Update
- ODR-009 locked with staged policy:
  - minimum `PACK.overlay.fallback_economics` counter schema is now doctrine-locked,
  - thresholds remain pack-owner calibrated per profile/version.
- ODR-010 locked:
  - no hard single-lane rule,
  - bounded advanced-lanes policy adopted (max two concurrent by default, synthesis override only, explicit owner/exit/kill-switch requirements).

## Applied Source-of-Truth Targets
- `OPERATIONS.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `README.md`
- `notes/THEORY_TO_PACK_REGISTER.md`
