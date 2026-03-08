# Synthesis Report

- Run ID: 20260308-213253-core-engine-fec-f3e-synthesis-pass-02
- Source prompt runs:
  - prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01
  - prompts/runs/20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01
  - prompts/runs/20260308-184205-core-engine-fec-f3e-dual-model-review-pass-02
- Date (UTC): 2026-03-08

## Scope
- Documents updated:
  - synthesis run artifacts only (no source-of-truth doctrine/architecture edits in this pass)
- Responses considered:
  - external ChatGPT and Claude outputs from first prompt run
  - internal dual-model final outputs (Claude and GPT-5.4)
  - Codex program/repo plan draft (cleaned catalog)
  - prior synthesis pass outputs and stable topic entries

## Integrated Findings (severity ordered)
1. Critical: publication law for derived state is still underspecified at Foundation level.
   - Multiple inputs converge on the same gap: atomicity and ordering across `value_delta`, `topology_delta`, `shape_delta`, and optional display/format effects must be explicit and replay-testable.
2. Critical: runtime overlay lifecycle lacks normative contract text.
   - Overlay creation, retention, publication boundary, eviction, and epoch-safe GC are repeatedly identified as blockers for correctness proofs and concurrency rollout.
3. High: there is a live profile-compatibility tension on cycle behavior.
   - Foundation formal/architecture text currently frames cycle mode as `CycleError` or `Iterative`, while DnaVisiCalc v0 requires non-iterative carry-forward behavior when iterative mode is disabled.
4. High: stream semantics should be explicitly versioned at profile level.
   - Foundation describes topic-based STREAM/RTD evolution while v0 pathfinder behavior is externally invalidated and handle-driven; synthesis should freeze a profile-semantic version lane to avoid drift.
5. High: FEC/F3E seam direction is suitable, but adoption remains conditional on concurrency-hardening gates.
   - Transaction lane, stable IDs, and split deltas are strong; contention replay, richer reject details, and coordinator-level fencing remain required before broad promotion.
6. High: runtime dependency deltas are useful but must be fully consumed by scheduler invalidation policy.
   - Name/spill/runtime deltas must drive incremental invalidation deterministically; otherwise fallback-to-full remains overused and weakens scalability claims.
7. Medium: formatting boundary is converging and should be frozen as profile-gated.
   - Current best direction: `TEXT(value, format_text)` is explicit-format conversion by default, while conditional-format effective-style observability remains provisional until empirical closure.
8. Medium: visibility-first scheduling is viable only as optional policy with fairness bound and equivalence proof.
   - It can affect priority/latency, never stabilized semantics.

## Conflict Map and Resolution Path

| Conflict ID | Conflict | Sources | Doctrine precedence | Resolution for promotion |
|---|---|---|---|---|
| CFG-001 | Cycle semantics (`CycleError|Iterative` vs non-iterative carry-forward) | foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md; dnavisicalc-spec__SPEC_v0.md; dnavisicalc-spec__ENGINE_REQUIREMENTS.md | CHARTER -> A&R, with Round-0 authority note in A&R section 6 | Add profile-explicit cycle lane that preserves v0 compatibility while keeping Foundation target modes explicit |
| CFG-002 | STREAM/external update semantic framing differs across layers | foundation-core__ARCHITECTURE_AND_REQUIREMENTS.md; dnavisicalc-spec__ENGINE_API.md | CHARTER -> A&R | Introduce profile `StreamSemanticsVersion` field and map v0 behavior explicitly |
| CFG-003 | FEC seam says coordinator snapshot fence equality; earlier implementation review flagged local/session-only risk | fec-f3e-current-spec__ENGINE_FEC_F3E_REDESIGN_SPEC.md; synthesis pass-01 redesign review | A&R + Operations evidence discipline | Keep conditional-go; require deterministic contention replay + reject-detail evidence before promotion |
| CFG-004 | Formatting observability default vs future CF-visible behavior | synthesis-context compact; formatting hierarchy model; conformance FM-013/FM-014 lanes | A&R Round-0 scope + conformance provisional lanes | Freeze default non-ambient behavior; keep CF-effective-style visibility as provisional/profile-gated lane |
| CFG-005 | `CURRENT_SPEC_SET` references `ENGINE_FEC_F3E_REDESIGN_SYNTHESIS.md` while curated source bundle may omit it | fec-f3e-current-spec__CURRENT_SPEC_SET.md; user intake notes | Operations managed-run hygiene | Adapt pointer text to the actual maintained current-best files in future prompt-pack refresh |

## Target Architecture Synthesis (Option B anchored)
1. Structural truth:
   - immutable `DocSnapshot[e]` with operation-driven mutation only.
2. Derived structural layers:
   - `RefWorld[e]` and `StructGraph[e]` as deterministic structural derivations.
3. Runtime calc overlays:
   - dependency overlay, spill/virtual-region overlay, format-observation overlay, visibility state overlay.
4. Effective scheduler graph:
   - `G_eff[e] = G_struct[e] U G_runtime[e]` with visibility as priority metadata only.
5. Publication contract:
   - accepted commit emits one atomic derived bundle at node commit boundary; rejected commit is strict no-op.
6. Concurrency model:
   - single publisher/coordinator first, parallel evaluators staged later, with strict snapshot/token/capability fences.

## Required Contract Edits for Promotion
1. Publication and rejection:
   - normative atomic commit bundle and no-partial-publish reject semantics.
2. Overlay lifecycle:
   - explicit create/retain/evict/GC contract keyed by epoch/token/bind/profile fences.
3. Reject taxonomy:
   - split and structured reject detail payload sufficient for deterministic replay and migration diagnostics.
4. Compatibility profile clauses:
   - cycle semantics and stream semantics version lanes explicitly mapped to Round-0 pathfinder behavior.
5. Invalidation routing:
   - runtime name/spill/dynamic deltas must be first-class invalidation inputs, not trace-only outputs.
6. Formatting and visibility:
   - profile-gated formatting-observation tokens and visibility-first fairness/equivalence obligations.

## Program/Repo Plan Integration (from projects/repo plan draft)
1. Accept structural split for execution planning:
   - Foundation (doctrine), OxFunc (value/function semantics), OxFml (formula/evaluator seam), OxCalc (multi-node core), OxVba (VBA runtime/host), OneCalc (single-node host), TreeCalc (first serious core host).
2. Use sequence-only wave plan as adoption skeleton:
   - Wave A semantic boundary freeze,
   - Wave B seam hardening,
   - Wave C OneCalc host,
   - Wave D OxCalc tree substrate,
   - Wave E TreeCalc host,
   - Wave F concurrency/advanced lanes,
   - Wave G full DNA Calc expansion.
3. Keep unresolved project-shape decisions explicit in DEC/ODR registers.

## Assurance and Pack Closure Set (for next pass)
- Promote/align DAG rows and packs:
  - DAG-PO-001/002/003/006/009/010
  - PACK.dag.baseline_recalc_core
  - PACK.dag.dynamic_dependency_bind_semantics
  - PACK.dag.cycle_iterative_semantics
  - PACK.dag.parallel_determinism_signature
  - PACK.dag.external_stream_ordering
- Add seam-focused packs from this synthesis:
  - PACK.fec.overlay_lifecycle
  - PACK.fec.commit_atomicity
  - PACK.visibility.policy_equivalence

## Decision Summary
- Accepted: 10 (CDS011, CDS012, CDS013, CDS014, CDS015, CDS016, CDS017, CDS018, CDS019, CDS020)
- Adapted: 1 (CDS022)
- Deferred: 1 (CDS021)
- Rejected: 0

## Applied Changes (this run)
- `analysis/suggestion_index.csv`: populated with integrated synthesis suggestions CDS011-CDS022.
- `decisions/decision_log.csv`: populated with accept/adapt/defer decisions and rationale.
- `decisions/open_decisions_register.md`: refreshed with current unresolved architecture/program decisions.
- `outputs/synthesis_report.md`: replaced template with integrated synthesis output.
- Source-of-truth promotion pass applied to:
  - `ARCHITECTURE_AND_REQUIREMENTS.md`
  - `CORE_ENGINE_FORMAL_MODEL.md`
  - `OPERATIONS.md`
  with lock-in of ODR-001..ODR-008 semantics and managed-run pointer hygiene rules.

## Open Follow-ups
1. Define concrete pack contracts/owners for promoted candidate packs (commit atomicity, reject detail replay, overlay lifecycle, visibility equivalence/starvation, formatting seam boundary).
2. Implement replay-oriented fixtures for stream version matrix and rejection-fence determinism in `PACK.concurrent.epochs`.
3. Execute first gate run with the updated profile selectors and capture minimized cases for any deterministic-equivalence failures.


