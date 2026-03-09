# RUNNING_PROJECT_NOTES.md — DNA Calc Running Project Notes

This file captures small, off-the-top-of-my-head ideas and to-do style notes.
These are exploratory notes (similar status to `notes/BRAINSTORM_NOTES.md`), not implementation commitments.

## 2026-02-22

### 1) Charter principle: "Alien Artifact" math-leverage approach
- Note: Consider adding the "Alien Artifact" math-leverage approach as a key principle in the Charter.
- Status: Adopted in Charter synthesis pass (`20260222-152845-foundation-pass-02-prompt-and-research`).

### 2) Charter principle: "Design for Evolution"
- Note: Consider making "Design for Evolution" a named key principle in the Charter.
- Status: Adopted in Charter synthesis pass (`20260222-152845-foundation-pass-02-prompt-and-research`).

### 3) Potential fourth implementation track ("Black")
- Note: Consider adding a later implementation track beyond Green/Red/Blue:
  - "Black": TinyGrad-based GPU calculation core.
  - Idea: lift calculation trees into TinyGrad for GPU-backed evaluation.
- Status: Captured exploration note (future consideration).

### 4) Green track research: Jane Street stack (OxCaml + Incremental)
- Note: Add a focused investigation item for the Jane Street OCaml stack as input for Green spec/reference work.
  - Priority subtopic: OxCaml (language/tooling model and fit for reference implementation ergonomics).
  - Priority subtopic: `Incremental` library (dependency graph maintenance, recomputation semantics, and potential transfer to spreadsheet-style incremental evaluation).
- Status: Investigated in run `20260222-123425-run4-janestreet-oxcaml-incremental-internal`; findings synthesized into core docs and `notes/RESEARCH_NOTES.md`.

### 5) License attribution update
- Note: Update MIT license copyright attribution to "DNA Kode, Inc."
- Status: Captured legal/packaging note (pending update).

## 2026-02-23

### 1) Roslyn red/green tree design as dependency/snapshot input
- Note: Study Roslyn's Red/Green tree model as a potential fit for dependency-tree restructuring and snapshot semantics:
  - mostly-immutable structures with optimized mutation fragments,
  - spine-defined snapshot identity,
  - syntax vs semantic tree separation with coupling boundaries,
  - full-fidelity parse/storage representations (including whitespace and formatting metadata).
- Note: Evaluate whether this is an alternative to epoch MVCC, an implementation strategy for it, or a hybrid.
- Status: Captured for deep research and architecture comparison.

### 2) Person/library backlog: Eric Lippert
- Note: Add Eric Lippert to the list of high-value references (posts/books) for language/compiler and semantic design insights.
- Status: Captured research/library curation note.

### 3) Core principle reinforcement: headless operation
- Note: Reaffirm headless operation as a core system principle (engine/protocol-first operation without GUI dependency).
- Status: Captured principle reminder for future doctrine/spec pass.

### 4) Next deep research backlog: Run 3 (concurrency protocol verification)
- Note: Add a dedicated deep-research run for concurrency protocol verification:
  - TLA+ model planning for variables/actions/invariants around committed/stabilized epochs, external updates, exclusive mutation windows, and snapshot pinning.
  - Define tiered TLC/Apalache pack gates.
  - Define artifact formats optimized for counterexample minimization.
- Status: Captured as next-run candidate.

### 5) Next deep research backlog: Run 4 (collaboration semantics)
- Note: Add a dedicated deep-research run for spreadsheet collaboration semantics:
  - compare server-sequenced op-log vs CRDT/OT under structural edits and reference rewriting,
  - propose operation schema with idempotency/causality envelope,
  - define first concrete candidate protocol slice for evaluation.
- Status: Captured as next-run candidate.

### 6) Open clarification item: meaning and role of `PACK.*`
- Note: Clarify what `PACK.xxx` denotes (scope, lifecycle stage, acceptance gates, artifact obligations).
- Status: Captured as explicit terminology/doctrine clarification question.

### 7) Spec hierarchy completeness principle
- Note: System behavior should be fully self-described by the spec hierarchy.
- Note: "Design for Evolution" should explicitly include "design for customization" so adaptation mechanisms are intentional, versioned, and spec-governed.
- Status: Captured for doctrine wording and architecture constraint review.
