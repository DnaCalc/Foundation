# Design Brief: Core Engine Synthesis Run (Pass 02 Intake)

## Objective
Prepare a synthesis-ready input freeze that can be used for Codex xhigh cycles, Claude cycles, and external Pro/Deep Research to converge on a coherent core engine architecture and design package.

## Required synthesis focus
1. Integrate the layered DAG engine model with the current best FEC/F3E seam.
2. Reconcile external model outputs (ChatGPT + Claude) with internal dual-model review outputs.
3. Integrate the Codex projects/repo work plan into architecture sequencing and adoption planning.
4. Resolve/standardize treatment of:
   - structural dependency graph vs calc-time dependency overlay,
   - dynamic references and spill-shape overlay lifecycle,
   - formatting and display dependencies, including TEXT and conditional-format observability boundary,
   - visibility-aware scheduling policy under deterministic semantics,
   - epoch/MVCC concurrency and deterministic publication.

## Deliverables expected from synthesis execution
1. Requirements deltas for ARCHITECTURE_AND_REQUIREMENTS.md and CORE_ENGINE_FORMAL_MODEL.md.
2. Normative contract edits for FEC/F3E lifecycle and delta semantics.
3. Decision log entries with accept/adapt/defer/reject statuses.
4. Phased adoption plan aligned to the projects/repo work plan.
5. Pack/proof and empirical closure checklist updates.

## Working constraints
- Follow doctrine precedence: CHARTER -> ARCHITECTURE_AND_REQUIREMENTS -> OPERATIONS -> synthesized notes.
- Keep compatibility profile behavior explicit where Foundation target behavior differs.
- Prefer invariant-level commitments over implementation-locking algorithm prescriptions.
