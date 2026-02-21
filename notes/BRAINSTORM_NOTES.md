# BRAINSTORM_NOTES.md — DNA Calc Brainstorm Notes (Captured Ideas)

This document captures additional ideas, potentials, open questions, and lower-level notes from the discussion. It is intentionally broader and less curated than the Charter/Operations/Architecture docs.

## A. Core architectural motifs
- “Small toy built like a big system”: strict boundaries, replaceable adapters, protocol-first design.
- Three hard boundaries: OpLog → DocSnapshot → CalcDeltas.
- Epoch/MVCC model:
  - committed vs stabilized epochs,
  - stale/pending cell states,
  - pin/unpin snapshots and GC policy.
- “Meta-epochs” for project stabilization (profiles + packs + conformance artifacts).
- Profiles + feature gates (core vs interop vs UI behavior).
- Clean-room compatibility philosophy: public docs + reproducible observations only.

## B. Verification stack and near-formal posture
- Lean: semantics of formula DSL + structural rewrite lemmas; determinism proofs; optional dependency-extraction soundness.
- TLA+: verify concurrency protocol (stale-commit prevention, snapshot consistency, exclusive mutation, eventual stabilization).
- OCaml: CLI oracle + trace runner + shrinking/minimization.
- File-based integration between tools; avoid in-process embedding of Lean/OCaml in v1.
- Admission rule for new “spec languages”: must have a checker + an artifact + CI integration.

## C. Development doctrine and “recalc” analogy
- Development behaves like calculation:
  - change → dirty marking → closure → scheduling → stabilization → commit.
- “Auto vs manual” mode for dev pipeline:
  - local can defer heavy packs; CI must stabilize affected profiles.
- Packs as readiness units; Green has veto on stabilization.
- Triads per module: Design + Assurance + Delivery reps.
- Logistics role: reduce cycle time and improve determinism and reporting.
- Regression discipline: every bug becomes a minimized trace fixture.

## D. Team structure
- Green: spec/proofs/TLA+/OCaml oracle/cases/packs.
- Red: Rust implementation.
- Blue: .NET implementation.
- Tooling may be .NET-first; Rust utilities may exist for high-perf targeted tools.

## E. UI ideas (Tauri/web stack)
- Canvas/WebGL grid renderer; DOM overlay editor for IME and selection.
- Never create DOM-per-cell; use virtualization.
- Tile caching (e.g., 256–512px tiles), dirty rectangles, text measurement caching.
- Explicit view-state reducer/state machine:
  - selecting, editing, formula ref-picking, fill handle, resize, scrolling.
- Geometry/hit-test pure functions; invariants (no gaps/overlaps; hit-test consistent with draw).
- RenderPlan IR for deterministic testing (avoid screenshot brittleness).
- Display staleness explicitly (value_epoch indicators).

## F. Calc engine ideas
- Pipeline: parse → bind → dependency graph → incremental recompute → caching.
- Stable IDs for cells/objects to survive structural edits; avoid raw “A1 string keys” internally.
- Structural edits treated as atomic doc transformations (exclusive mutation path).
- Prioritized recompute (viewport-first) as later optimization.
- Determinism vs parallelism:
  - fixed reduction order for SUM to avoid float nondeterminism (policy decision).
- Internal caches must be bounded; avoid logical memory leaks; avoid Arc cycles.
- Coordinator owns mutation; workers are pure computations on immutable snapshots.

## G. External inputs, UDFs, XLL, RTD
- STREAM("topic") for deterministic external data in Pathfinder.
- Full RTD support is required in full system (topic lifecycle and update-triggered invalidation).
- External UDF registration:
  - metadata: name/arity/volatile/thread-safe.
  - scheduling: thread-safe UDFs can run on worker pool; non-thread-safe run serialized.
  - async UDF continuations deferred unless absolutely needed in Pathfinder.
- XLL boundary contracts formally specified; in-process XLL host in full system.

## H. VBA and macro world
- VBA is outside core.
- Engine stores VBA project as blob + metadata; app layer wires:
  - file load/save ↔ engine blob,
  - VBA editor/runtime ↔ engine via ops.
- Macro execution in exclusive mutation mode; serialized event stream.
- COM automation facade (Windows-only) possibly built on top of the protocol surface.
- Macro recording considered “easy” relative to macro execution; COM controls integration excluded early.

## I. File I/O and interop notes
- File I/O should be adapter-based and outside core.
- Round-trip unknown OOXML parts as opaque attachments.
- “Lowering pipeline” for export: internal model → Excel-safe subset → OOXML, with explicit loss markers if needed.
- DIF suggested as a lightweight historical file format for early experiments (Pathfinder/VisiCalc).
- Clean-room rule implies evidence logs and reproducible observations for Excel behaviors.

## J. Collaboration
- Collaboration identified as important feature block; design seam early.
- Prefer server-sequenced op log replication first (deterministic shared order).
- CRDT/OT possible later; structural edits and reference rewriting make it hard.
- Choice: share doc only (clients compute locally) vs share oracle values; RTD complicates this.
- Presence/cursor sharing is separate from semantic sharing.

## K. “Agentic coding flywheel” influences
- Tool constellation: small CLIs with durable artifacts (sessions, reports, traces).
- Session capture: every run yields a bundle (diff, packs run, results, rationale).
- SQLite artifact store for searches and triage.
- Advisory “area leasing” for multi-agent work to avoid collisions.
- Inspector dashboards:
  - epoch state viewer, dirty set, in-flight tasks,
  - case explorer, conformance dashboard.

## L. Requirements vs architecture framing
- Ladder: Mission → Doctrine → Requirements → Architecture + constraints → Intent/Realization.
- Architecture-independent requirements: black-box behaviors and quality targets.
- Architecture-dependent constraints: enforceable “thou shalt” rules.
- Architecture-anchored intents: become precise only once anchored (e.g., epoch staleness rules).

## M. Names and round structure
- System family names:
  - DnaVisiCalc (Round 0 pathfinder),
  - DnaPreCalc (Round 1 full system),
  - DnaSuperCalc (Round 2 perfection/refactor),
  - DnaCalc (Round 3 Goldilocks target).
- Mission language adopted with a light nod to “Mission / Doctrine / Orders.”
- Clean-room positioning explicitly included in mission.

## N. Open questions (to keep visible)
- Determinism policy under parallelism (float reduction, scheduling).
- External oracle policy for collaboration (local vs shared).
- Export degradation: cell errors vs metadata/comments vs both.
- Range inputs/outputs in external UDFs for Pathfinder (exact scope).
- Async UDF continuations: needed in Pathfinder or later?
- How much “view state” is document-backed vs session-only.
- Minimum set of Excel semantics to define profiles early (subset selection and measurement).