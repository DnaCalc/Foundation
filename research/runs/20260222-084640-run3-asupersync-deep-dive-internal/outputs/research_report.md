# Research Report

- Run ID: 20260222-084640-run3-asupersync-deep-dive-internal
- Topic ID: R-TOPIC-003
- Source prompt: targeted internal deep dive (asupersync)
- Date (UTC): 2026-02-22

## Scope
- Research question: If Asupersync is the quality bar, what does the project actually do across doctrine, semantics, formal methods, testing, and operations, and what must DNA Calc execute to match that standard.
- Exclusions: no direct changes to foundation doctrine/charter/architecture in this run.

## Findings
- Asupersync operates as a tightly coupled meta-stack: doctrine -> semantics -> mechanization -> conformance -> deterministic testing -> CI gates.
- The formal layer is substantial and measurable: 146 tracked theorems, 22/22 constructor coverage, 6 canonical invariants with explicit maturity split (1 fully proven, 3 partially proven, 2 unproven).
- Development pace was unusually high and single-owner coherent: 2689 commits from 2026-01-16 through 2026-02-22, with dense bursts and frequent feat/fix/refactor cycles.
- Quality discipline depends on machine-checkable artifacts and gate policy, not narrative claims: methodology gates, proof-check manifests, model-check artifacts, golden checksums, and deterministic replay bundles.
- The strongest transferable insight is the coupling discipline itself; advanced math modules are optional and should be staged.

## Source Summary
- Total sources captured: 23
- Primary repository/local artifacts: 21
- External references: 2 (GitHub repo page and docs.rs crate page)

## Gaps
- This run did not benchmark real-world adoption outcomes for downstream projects that emulated Asupersync process discipline.
- Commit-level timeline was analyzed, but not clustered by subsystem-level diff volume.

## Follow-up Queries
- Compare this internal run with user-triggered external ChatGPT Deep Research outputs for convergence/divergence.
- Perform a second-pass code archaeology focused on the evolution of specific modules (`src/runtime/scheduler`, `src/obligation`, `src/trace`) to extract implementation playbooks.
- Produce a DNA Calc adaptation matrix: required now vs defer vs optional for each Asupersync control surface.