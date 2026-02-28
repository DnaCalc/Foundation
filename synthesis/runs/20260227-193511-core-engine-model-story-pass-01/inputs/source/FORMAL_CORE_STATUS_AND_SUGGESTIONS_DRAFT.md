# FORMAL_CORE_STATUS_AND_SUGGESTIONS_DRAFT.md

## 1. Current Status Snapshot
- Date: 2026-02-25 (UTC)
- Latest formal-model synthesis run: `20260225-222801-formal-model-pass-01`
- Run artifacts:
  - `synthesis/runs/20260225-222801-formal-model-pass-01/README.md`
  - `synthesis/runs/20260225-222801-formal-model-pass-01/inputs/source_hashes.csv`
  - `synthesis/runs/20260225-222801-formal-model-pass-01/analysis/suggestion_index.csv`
  - `synthesis/runs/20260225-222801-formal-model-pass-01/decisions/decision_log.csv`
  - `synthesis/runs/20260225-222801-formal-model-pass-01/logs/manifest.csv`
  - `synthesis/runs/20260225-222801-formal-model-pass-01/outputs/synthesis_report.md`

## 2. Decision Outcome Summary
- Suggestions processed: 20 (`FM001`-`FM020`)
- Accepted: 18
- Deferred: 2
- Rejected: 0
- Adapted: 0

Deferred items:
- `FM019`: single-engine/no-OCaml early-round contraction (deferred due to doctrine conflict).
- `FM020`: `RowId`/`ColId` scope and address canonicalization (deferred pending explicit policy lock).

## 3. Source-of-Truth Changes Applied
Primary updated document:
- `ARCHITECTURE_AND_REQUIREMENTS.md`

New sections added:
- `3.11 Formal State Kernel (tree-grid hybrid with persistence facades)`
- `3.12 Layered Semantics (structure, refs, deps, values, ops)`
- `3.13 OpLog Formal Transition Semantics`
- `3.14 Structural Rewrite Semantics (rows/cols/sheets)`
- `3.15 Reference Resolution and Reference-Grid Update Semantics`
- `3.16 Cycle Detection, Iteration, and Stabilization Semantics`
- `3.17 Formalization Seams for Lean and OCaml`

Constraints extended:
- Added `CONSTR-010` through `CONSTR-015` to lock identity semantics, rewrite determinism, explicit reference/error modeling, deterministic cycle behavior, and replay-safe op metadata.

Requirements extended:
- Added architecture-independent requirements for deterministic structural rewrite diagnostics, replay equivalence, cycle observability, and auditable reference-grid updates.
- Added INT/REAL pairs for formal structural semantics, binder normalization outputs, cross-language formal-core compatibility, and deterministic cycle semantics.

Round 0 artifacts extended:
- `6.1` now requires formal-core traces:
  - structural rewrite traces,
  - reference-grid delta traces,
  - SCC iteration traces.

## 4. Retained Deferred/Unused Ideas
Dedicated retained-notes file created:
- `notes/FORMAL_MODEL_REMAINING_NOTES.md`

Deferred categories retained there:
- Representation strategy downselection (axis-map sparse, tile DAG, patch-stack, region algebra).
- Value algebra and function-class semantics (pure/impure/volatile).
- Dynamic-reference and spill-overlap details.
- ID/addressing policy decisions.
- OpLog compaction/conflict-policy decisions.
- Follow-up benchmark/research probes.

## 5. Conflict Record (Explicit)
Conflict identified and logged:
- Independent-review recommendation to collapse to single engine and remove OCaml oracle in early rounds conflicts with current doctrine baseline in `CHARTER.md` and current architecture commitments.
- Handling path used in this pass: defer + explicit escalation path (`DEC-###` policy decision) rather than silent override.

## 6. What Is Now Stable Enough To Start Formalizing
The following are now sufficiently explicit to begin OCaml/Lean core formalization:
- Stable core identity model (ID-based, address-derived).
- Snapshot kernel shape (green immutable structures + red facades).
- Operation-envelope and transition-phase model for OpLog.
- Structural rewrite classification outcomes.
- Normalized reference forms (`CellRef`, `RegionRef`, `NameRef`, `ExternalRef`, `ErrorRef`).
- SCC-based cycle semantics with profile-governed iterative mode.
- Named module split (`CoreIds`, `CoreStructure`, `CoreRefs`, `CoreDeps`, `CoreEval`, `CoreOps`).

## 7. Suggestions For Next Discussion (Priority)
### P0 - Must decide immediately
1. Lock `RowId`/`ColId` scoping policy:
   - sheet-local vs globally unique,
   - reuse policy after deletion,
   - copy/move/import behavior.
2. Lock canonical address-text policy for traces/diagnostics:
   - `A1` only, `R1C1` only, or dual canonical form.

### P1 - Core semantic closure
3. Define value algebra minimum set for Round 0:
   - scalar kinds,
   - array/spill representation,
   - error lattice,
   - coercion/lifting rules.
4. Define dynamic-reference policy for `INDIRECT`-class constructs:
   - discovered-target semantics,
   - conservative fallback dependency scope,
   - invalidation triggers.

### P2 - OpLog and replay specificity
5. Define OpLog granularity policy for range edits:
   - single op per range vs per-cell expansion,
   - impact on replay determinism and minimization.
6. Define compaction/snapshot boundary semantics:
   - what can be folded,
   - what must remain for deterministic replay and minimization.

### P3 - Cycle semantics completion
7. Define profile defaults for iterative cycles:
   - max iteration limits,
   - convergence metric,
   - tolerance and rounding behavior.

## 8. Suggested OCaml + Lean Kickoff Package
### OCaml (reference executable)
- Implement data types and parser for:
  - `OpEnvelope`,
  - `DocSnapshot` core shape,
  - `BoundRef` variants,
  - SCC execution trace.
- Implement `apply_op` skeleton with explicit phase outputs:
  - structure delta,
  - ref delta,
  - dep delta,
  - value pending set.

### Lean (spec and theorems backlog start)
- Define inductive/record types mirroring `CoreIds`, `CoreStructure`, `CoreRefs`, `CoreOps`.
- First theorem targets:
  - deterministic replay for admissible op suffixes,
  - structural rewrite totality (plus invalidation coverage),
  - no hidden mutation of green state.

## 9. Suggested Pack Additions/Clarifications
To support this formal-core baseline, consider extending pack specs with explicit artifacts:
- `PACK.structural.insert`: must emit rewrite classification traces.
- `PACK.concurrent.epochs`: must include SCC iteration-state replay for cycle cases.
- `PACK.visicalc.core`: must validate binder-normalized references and error-ref persistence.

## 10. Known Ambiguities Still Open
- Spill interior-cell formal identity under overlapping edits.
- Final policy for volatile/impure function interaction with dependency discovery.
- Post-server-sequenced collaboration conflict semantics (future seam).

## 11. Recommended Next-Step Sequence
1. Finalize ID/address policy (`FM020` closure).
2. Finalize Round-0 value algebra and coercion rules.
3. Draft `CoreIds/CoreStructure/CoreRefs/CoreOps` in OCaml + Lean in parallel.
4. Define OpLog compaction boundary + replay guarantees.
5. Run a focused follow-up synthesis pass to promote resolved items from `notes/FORMAL_MODEL_REMAINING_NOTES.md`.

## 12. Quick Links
- Formal synthesis report: `synthesis/runs/20260225-222801-formal-model-pass-01/outputs/synthesis_report.md`
- Formal decisions log: `synthesis/runs/20260225-222801-formal-model-pass-01/decisions/decision_log.csv`
- Deferred ideas registry: `notes/FORMAL_MODEL_REMAINING_NOTES.md`
- Updated architecture: `ARCHITECTURE_AND_REQUIREMENTS.md`
