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
