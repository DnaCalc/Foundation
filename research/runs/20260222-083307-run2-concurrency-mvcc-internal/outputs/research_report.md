# Research Report

- Run ID: 20260222-083307-run2-concurrency-mvcc-internal
- Topic ID: R-TOPIC-002
- Source prompt: prompts/PROMPT_PACK_DEEP_RESEARCH.md (Run 2)
- Date (UTC): 2026-02-22

## Scope
- Research question: identify strongest public references and model patterns for epoch/MVCC concurrency correctness.
- Exclusions: no architecture doc edits in this run; evidence capture only.

## Findings
- Established a TLA+-first modeling strategy with concrete invariants and tiered TLC bounds.
- Captured strong MVCC/isolation references from database literature and production systems.
- Added spreadsheet-specific async/recalc references to maintain domain relevance.

## Source Summary
- Total sources: 15
- Primary sources: 13
- Secondary sources: 2

## Gaps
- Need direct spreadsheet-engine concurrency case studies comparable to DNA Calc's external-update model.
- Need dedicated source set on deterministic replay in parallel evaluators.

## Follow-up Queries
- TLA+ specs of incremental schedulers with cancellation.
- Deterministic replay strategies for async spreadsheet evaluation.
- Formal verification case studies for UI-visible stale/pending states.
