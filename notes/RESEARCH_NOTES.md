# RESEARCH_NOTES.md - Synthesized research knowledge base

## 1. Purpose and synthesis status
- This file stores retained, non-doctrinal knowledge synthesized from prompt and research runs.
- Source-of-truth doctrine remains `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `OPERATIONS.md`.
- This notes file is the live knowledge base for details not yet promoted to doctrine.
- Current baseline snapshot reflects the 2026-03-09 synthesis consolidation (core-engine, FEC/F3E, and program-layout passes complete).
- 2026-03 synthesis promotions for core engine and FEC/F3E are reflected in source-of-truth docs, `CORE_ENGINE_FORMAL_MODEL.md`, and conformance/model artifacts under `reference/conformance/excel-worksheet-engine/model/fec-f3e/`.

## 2. Inputs synthesized in this pass
- Prompt run set: `prompts/runs/20260222-011351-prompt-pack/responses/*` (18 responses).
- 2026-03 synthesis inputs (core-engine/FEC-F3E/program-layout):
  - `synthesis/runs/20260308-213253-core-engine-fec-f3e-synthesis-pass-02/outputs/synthesis_report.md`
  - `synthesis/runs/20260309-004109-improvement-notes-synthesis-pass-01/outputs/synthesis_report.md`
  - `synthesis/runs/20260309-072109-core-engine-program-layout-synthesis-pass-01/outputs/synthesis_report.md`
  - Deep research/review packs under `prompts/runs/20260308-*`
- Research run set:
  - `research/runs/20260222-082019-run1-master-landscape/outputs/deep-research-report.md` (external)
  - `research/runs/20260222-082019-run2-concurrency-mvcc/outputs/deep-research-report.md` (external)
  - `research/runs/20260222-083307-run1-master-landscape-internal/outputs/response.md`
  - `research/runs/20260222-083307-run2-concurrency-mvcc-internal/outputs/response.md`
  - `research/runs/20260222-083307-run2-concurrency-mvcc-internal/outputs/combined_findings.md`
  - `research/runs/20260222-084640-run3-asupersync-deep-dive-internal/outputs/response.md`
  - `research/runs/20260222-123425-run4-janestreet-oxcaml-incremental-internal/outputs/response.md`

## 3. Cross-run conclusions now retained
- Dependency discovery and execution order must remain separate artifacts; persisted calc order artifacts are cache/diagnostic only.
- Epoch-tagged stale/pending visibility is core user contract, not UI decoration.
- External updates are explicit operations with replay envelopes; stream ordering and dedupe are profile-governed.
- Deterministic replay artifacts are mandatory for conformance and regression minimization.
- Clean-room interop posture requires preserving unsupported OOXML/macros as opaque payloads when feasible.
- TLA+ model-checking plus minimized traces is the default mechanism for concurrency risk retirement.
- "Design for Evolution" requires versioned profiles, protocol negotiation, and explicit degradation classes.
- Asupersync indicates the quality bar is a coupling discipline (semantics -> proofs -> tests -> CI gates), not a single algorithm.
- Incremental indicates high-value Green invariants: `necessary`, `stale`, `height`, and `scope`, with analyzable graph exports.
- OxCaml is strategically interesting but should remain a deliberate toolchain decision, not default adoption.

## 4. Prompt run synthesis check
- Status: Prompt run suggestions were already mostly integrated in synthesis pass 01.
- Net new from this pass: reinforce stabilization terminology and doctrine wording via core doc updates; no prompt-run-only architecture shift required.
- Prompt run artifacts remain useful as ideation/reference but are not authoritative once synthesized.

## 5. Topic-by-topic retained findings

### 5.1 R-TOPIC-001 - Master landscape (external + internal)
- Sources: external run1 report plus internal run1 response/report.
- Retained findings:
  - Excel docs give a clean-room decomposition for recalc behavior (dependency discovery, calc order, execution).
  - OOXML + Microsoft Open Specs define the compatibility baseline and extension boundary.
  - RTD/XLL lifecycle details are sufficient to define explicit external-op and UDF boundary contracts.
  - Sestoft/CoreCalc and Hermans research remain high-signal anchors for spreadsheet implementation and quality practice.
  - UI architecture should be tested as standards contracts (IME/input/clipboard), not screenshot-only behavior.
- Promoted to core docs in this pass:
  - calc-order-as-cache rule,
  - explicit external update op envelope,
  - stream monotonicity and pinned-epoch GC constraints.
- Outstanding backlog:
  - Round-0 precise Excel compatibility surface definition (functions, coercion, error semantics).
  - OOXML unknown-part edge cases (encryption/signatures/embedded object handling limits).
  - WebView-specific UI capability partitioning tests.

### 5.2 R-TOPIC-002 - Concurrency and MVCC epochs (external + internal)
- Sources: external run2 report plus internal run2 response/report/combined findings.
- Retained findings:
  - TLA+-first modeling is appropriate for epoch fencing, stale-drop, exclusive structural edits, and liveness progress checks.
  - Tiered TLC model strategy (tiny safety model first, then liveness-focused model) is suitable for CI gating.
  - Snapshot pinning and GC policy need explicit invariants in protocol specs and tests.
  - Cancellation semantics should be modeled as protocol behavior, not left as implementation trivia.
- Promoted to core docs in this pass:
  - additional epoch invariants (stream sequence monotonicity, no pinned-epoch GC),
  - stronger deterministic replay and external-op semantics.
- Outstanding backlog:
  - Dedicated deterministic replay source set for parallel evaluators.
  - First minimal public TLA module draft for `SetCell`, `StructuralEdit`, `OpExternalUpdate`, task completion, stale-drop, and stabilization.

### 5.3 R-TOPIC-003 - Asupersync deep dive (internal)
- Sources: run3 response/report.
- Retained findings:
  - Asupersync quality comes from meta-stack coupling across doctrine, semantics, formalization, conformance, deterministic tests, and CI gates.
  - The project scale confirms formal/test/governance artifacts are first-class subsystems, not optional side docs.
  - Transferable part is execution discipline; full algorithmic breadth should be staged.
- Practical adaptation matrix:
  - Required now:
    - semantics/proof/test/gate coupling for high-risk claims,
    - machine-readable coverage and evidence manifests,
    - deterministic replay bundles for failures.
  - Stage later:
    - deeper optional math modules once interfaces and invariants are stable.
  - Optional/experimental:
    - advanced schedule geometry/probabilistic layers unless they retire concrete DNA Calc risks.
- Outstanding backlog:
  - deeper archaeology on scheduler/obligation/trace subsystems for implementation playbooks,
  - subsystem-level diff-volume analysis for process transferability.

### 5.4 R-TOPIC-007 - Jane Street stack, OxCaml, Incremental (internal)
- Sources: run4 response/report.
- Retained findings:
  - Jane Street ecosystem breadth confirms value in selective adoption, not monolithic import.
  - Incremental is directly relevant to spreadsheet-style recomputation invariants and dynamic graph maintenance.
  - OxCaml has meaningful innovation/upstream signals but requires explicit tooling budget and risk posture.
- Promoted to core docs in this pass:
  - new incremental graph invariant model section (`necessary`, `stale`, `height`, `scope`),
  - analyzable dependency/stabilization artifact expectations.
- Outstanding backlog:
  - side-by-side comparison: Incremental vs HyperFormula vs CoreCalc recalculation strategies,
  - explicit OxCaml strategy decision (observe-only vs experimental branch).

### 5.5 Pending tracked topics not yet synthesized from dedicated runs
- `R-TOPIC-004` OpenClaw / design-for-evolution patterns:
  - current status is pending and source resolution is still required.
- `R-TOPIC-005` spreadsheet implementation and extension research:
  - seeded with Sestoft/Hermans and student-project index; dedicated deep run pending.
- `R-TOPIC-006` spreadsheet systems landscape beyond Excel:
  - seeded with OpenOffice/WPS and landscape sweep placeholder; dedicated deep run pending.

## 6. What is in doctrine vs what stays here
- Doctrine/core docs now carry:
  - named principles (`Alien Artifact leverage`, `Design for Evolution`),
  - calc-order-as-cache and external-op envelope rules,
  - strengthened epoch/stream invariants,
  - synthesis lifecycle/working-directory doctrine.
- This file keeps:
  - detailed adaptation/backlog items,
  - unresolved research questions,
  - comparative analysis tasks not yet doctrinally settled.

### 5.6 FEC/F3E Deep Research Findings (2026-03 synthesis)
- FEC/F3E session lifecycle (`prepare -> open_session/capability_view -> execute -> commit`) is confirmed as the baseline evaluator seam contract.
- Atomic derived bundle publication (`value_delta` + `topology_delta` + `shape_delta` + optional display/format deltas) is locked as the commit output shape.
- Structured reject detail (`reject_code` + typed context) is required for deterministic replay diagnostics.
- Overlay lifecycle keying (`snapshot_epoch`, `wave_id`, `formula_stable_id`, `formula_token`, `bind_hash`, `profile_version`) is locked with epoch-safe eviction policy.
- Co-defined protocol authority between OxFml (evaluator-side) and OxCalc (coordinator-facing) is the resolved ownership model.
- Concurrency-hardening gates are Stage 2 prerequisites; Stage 1 sequential coordinator is sufficient for DNA OneCalc and DNA TreeCalc.
- Detailed spec artifacts: `reference/conformance/excel-worksheet-engine/model/fec-f3e/FEC_F3E_REDESIGN_SPEC.md` and related files.

## 7. Next synthesis-triggering questions
- How should Green pack coverage be staged against the now-stabilized DnaVisiCalc v0 functional contract (`SPEC_v0`, `ENGINE_REQUIREMENTS`, `ENGINE_API`)? *Open.*
- Which deterministic replay schema is canonical for concurrent evaluator traces? *Open (Stage 2 prerequisite).*
- What is the chosen OxCaml posture for Green (observe-only, experimental, or committed)? *Open.*
- Which OpenClaw source corpus is canonical for topic 004? *Open.*
- FEC/F3E spec artifact migration plan to OxFml — what is the handoff format and which artifacts transfer vs mirror? *New, open.*
- DNA OneCalc minimum viable profile definition — which function subset, coercion rules, and format behavior are in scope? *New, open.*
- Tree-host semantic gap register baseline — what is the initial gap set between tree-only and tree-grid-hybrid phases? *New, open (see `PACK.treehost_to_gridhost.semantic_gap_registry`).*
