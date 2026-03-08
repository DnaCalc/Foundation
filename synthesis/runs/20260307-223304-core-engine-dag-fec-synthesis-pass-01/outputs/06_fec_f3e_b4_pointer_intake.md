# FEC/F3E B4 Pointer Intake (DnaVisiCalc)

## Intake source
- `C:\Work\DnaCalc\DnaVisiCalc\docs\ENGINE_FEC_F3E_FOUNDATION_UPDATED_SPEC_POINTERS_PROMPT.md`

## Ingested pointer-linked docs and artifacts
1. Primary spec/synthesis docs:
   - `docs/ENGINE_FEC_F3E_REDESIGN_SPEC.md`
   - `docs/ENGINE_FEC_F3E_REDESIGN_SYNTHESIS.md`
   - `docs/ENGINE_FEC_F3E_REDESIGN_OBSERVATIONS.md`
2. Review input docs:
   - `docs/review/dec_f3e_plan_b/FOUNDATION_REVIEW.md`
   - `docs/review/dec_f3e_plan_b/OXFUNC_REVIEW.md`
3. Executable evidence and traces:
   - `crates/dnavisicalc-core-fml/tests/fec_f3e_seam_scenarios_tests.rs`
   - `artifacts/fec_f3e/seam_trace.log`
   - `artifacts/fec_f3e/seam_trace.event_counts.tsv`
   - `artifacts/fec_f3e/seam_trace.callgraph.edges.csv`
   - `artifacts/fec_f3e/seam_trace.callgraph.dot`
4. Key implementation surfaces:
   - `crates/dnavisicalc-core-fml/src/fec_f3e/contracts.rs`
   - `crates/dnavisicalc-core-fml/src/fec_f3e/fec_host.rs`
   - `crates/dnavisicalc-core-fml/src/fec_f3e/f3e_engine.rs`
   - `crates/dnavisicalc-core-fml/src/fec_f3e/trace.rs`
   - `crates/dnavisicalc-core-fml/src/engine.rs`

## Notes for synthesis queue
1. This intake supersedes earlier pointer ambiguity and anchors to the current post-review b4 handoff set.
2. Requested focus from pointer prompt (stable ids, split commit deltas, explicit spill events, policy boundary, scheduler readiness, traceability, coordinator contention gaps) should drive the next formal synthesis pass.
3. Include the new scenario `seam_end_to_end_spill_fail_and_recovery_with_dynamic_extent` in evidence review and pack planning.
