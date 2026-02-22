# Research Report

- Run ID: 20260222-123425-run4-janestreet-oxcaml-incremental-internal
- Topic ID: R-TOPIC-007
- Source prompt: targeted internal deep research (Jane Street sweep + OxCaml + Incremental)
- Date (UTC): 2026-02-22

## Scope
- Research question: perform a broad current-state sweep of Jane Street's OCaml stdlib/extensions ecosystem, then a deep implementation-focused study of Incremental, then assess fit for DNA Calc Green track.
- Exclusions: no doctrine/charter/architecture edits in this run.

## Findings
- Jane Street's OCaml ecosystem is broad (367 repos, 322 OCaml-tagged) and layered beyond Base/Core; ppx and async/incremental/UI ecosystems are substantial.
- OxCaml is an active compiler/toolchain track with explicit extension roadmap and upstreaming posture; docs currently show both merged and in-flight features.
- Incremental is a strong reference for spreadsheet-like recomputation architecture: node invariants, necessary/stale semantics, topological height ordering, scoped invalidation for dynamic binds, and analyzer/debug hooks.
- For DNA Calc Green, Incremental-style recomputation discipline is immediately transferrable; full OxCaml adoption should be treated as a strategic/toolchain decision, not default.

## Source Summary
- Total sources captured: 26
- External primary sources (docs/repos/package pages): 16
- Local derived analysis artifacts: 10

## Gaps
- This run did not benchmark Incremental against alternative incremental engines using standardized workloads.
- OxCaml evolution analysis used public docs/API snapshots only; no private roadmap artifacts.

## Follow-up Queries
- Produce a Green-specific invariant draft mapped to Incremental concepts (`necessary`, `stale`, `height`, `scope`).
- Run a side-by-side design comparison: Incremental vs HyperFormula vs CoreCalc-style recalculation models.
- Decide explicit OxCaml strategy (observe-only vs experimental branch) with toolchain cost model.