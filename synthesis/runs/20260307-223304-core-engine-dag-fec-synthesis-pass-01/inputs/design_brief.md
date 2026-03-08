# Design Brief: Core Engine DAG + FEC/F3E Synthesis (Discussion-First)

## Requested direction
We want a synthesis that produces a requirements/architecture/design-quality core-calculation-engine model aligned with original DNA Calc plans while incorporating the strongest state-of-the-art DAG computation ideas.

## Desired model shape
1. Layered model with explicit boundaries between:
   - immutable structural model,
   - structural reference resolution/dependency layer,
   - calc-time dynamic dependency/reference overlay,
   - virtual-region/spill overlay,
   - pure calculation fast-path execution.
2. Roslyn-style immutable green tree for structure/formulas/parse artifacts with spine-respin on mutation.
3. FEC/F3E integrated call/lifecycle model defining:
   - what functions are called,
   - what context is passed,
   - what dependencies are declared or observed,
   - how publish/invalidations happen deterministically.
4. Concurrency-safe and async-capable operation under epoch/MVCC constraints, including readable state while recalculation is in flight.

## Specific concerns to integrate
1. Structure-stable reference resolution for baseline dependency tree.
2. Calc-time dynamic reference resolution (e.g., INDIRECT) as overlay over structural dependencies.
3. Spill-created virtual regions and invalidation semantics for references into current/previous spill areas.
4. Formatting-aware calc-time overlay behavior where formula semantics depend on formatting context/state (for example `TEXT` over referenced values/format state).
5. Visibility representation in core model (visible nodes/grid regions) with optional prioritized scheduling for visible sub-area.
6. Fast-path when execution does not mutate calc-time overlay state.
7. Preservation of deterministic replay and high-concurrency goals.

## Expected synthesis outputs
1. Clear layered core model and terminology.
2. FEC/F3E protocol and state machine integrated with DAG semantics.
3. Explicit open decisions and proof/pack obligations.
4. Prompt pack for deep synthesis and external review passes.
