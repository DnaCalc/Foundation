# External Report Reconciliation (Claude + ChatGPT)

## Current state
- Baseline synthesis artifact: `outputs/05_deep_research_synthesis.md`.
- External artifacts ingested: `outputs/07_claude_research_report.md`, `outputs/08_chatgpt_research_report.md`.
- This document reconciles deltas and promotes concrete obligation and pack-definition artifacts.

## Consensus retained
1. Baseline scheduler semantics should remain explicit `Topo + SCC` with deterministic ordering and replayability.
2. Dynamic dependencies are a distinct capability lane and should not be hidden inside static-DAG assumptions.
3. Cycle handling needs two explicit modes: default error mode and bounded iterative mode.
4. Differential/timely-style machinery is high-value only for external-stream-heavy lanes, not baseline recalc.
5. Proof obligations and empirical packs should be staged `Now -> Next -> Later` to control implementation risk.

## Divergences and reconciliation decisions

| Area | Claude report | ChatGPT report | Reconciled decision |
|---|---|---|---|
| Baseline engine shape | Pushes hybrid demand + height-ordered recompute as near-term baseline | Recommends conservative classical recalc core first | Keep classical deterministic `Topo + SCC + explicit invalidation state` as baseline; reserve hybrid internals for targeted next-step prototype lanes |
| Dynamic topo maintenance timing | Strongly favors Pearce-Kelly as practical upgrade path | Treats dynamic topo as optional optimization after baseline | Promote dynamic-topo as a gated optimization pack (`PACK.dag.dynamic_topo_vs_rebuild`) with hard promotion criteria |
| Cycle/fixed-point interpretation | Emphasizes formal fixed-point framing and monotone SCC convergence | Emphasizes bounded deterministic iteration semantics and explicit non-fixed-point caveat | Keep both: profile default `CycleError`; optional iterative mode uses bounded deterministic semantics, with monotone fixed-point guarantee only when assumptions are declared |
| External-stream model | Recommends DBSP-inspired lane earlier for high-update flows | Recommends later selective timely/differential adoption | Keep epoch-op baseline now; add stream-ordering pack and reserve differential/timely for high-rate profile triggers |
| Early cutoff policy | Treats early cutoff as key practical win | Supports canonical schedule determinism first, then optimization | Promote early cutoff as a proof + empirical obligation, not as unconditional baseline doctrine |

## Resolved promotion set
- Concrete conformance/proof obligations: `outputs/10_conformance_and_proof_obligations.md`.
- Concrete empirical pack definitions: `outputs/11_empirical_pack_definitions.md`.

## Deferred items
1. Full DCG/DDG runtime as default recompute engine.
2. Full-program incremental lambda-calculus differentiation for broad formula language.
3. General-purpose timely/differential integration for non-stream-heavy profiles.

## Source anchors used in reconciliation
- Spreadsheet recalculation and cycle behavior: `DAG-001`, `DAG-002`, `DAG-003`, `DAG-004`, `DAG-020`, `DAG-023`, `DAG-024`.
- Dynamic dependency and self-adjusting theory: `DAG-005`, `DAG-006`, `DAG-007`, `DAG-008`, `DAG-010`, `DAG-028`, `DAG-029`.
- Dynamic graph algorithms: `DAG-021`, `DAG-022`.
- Streaming/incremental algebra: `DAG-013`, `DAG-014`, `DAG-015`, `DAG-016`, `DAG-017`, `DAG-018`, `DAG-019`.
