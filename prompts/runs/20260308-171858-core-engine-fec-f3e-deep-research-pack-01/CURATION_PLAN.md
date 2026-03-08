# Curation Plan (Future-Focused Pack)

Goal: keep current and decision-relevant material; remove historical/process noise and stale contracts.

## Must Keep (current + high signal)
> inputs/source/foundation-core/
- `README.md`
- `CHARTER.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `OPERATIONS.md`
- `CORE_ENGINE_FORMAL_MODEL.md`

> inputs/source/dnavisicalc-fec-current/
- `CURRENT_SPEC_SET.md`
- `ENGINE_FEC_F3E_FOUNDATION_UPDATED_SPEC_POINTERS_PROMPT.md`
- `ENGINE_FEC_F3E_REDESIGN_SPEC.md`
- `ENGINE_FEC_F3E_REDESIGN_SYNTHESIS.md`
- `ENGINE_FEC_F3E_REDESIGN_OBSERVATIONS.md`

> inputs/source/dnavisicalc-impl/
- `contracts.rs`
- `fec_host.rs`
- `f3e_engine.rs`
- `trace.rs`
- `engine.rs`
- `fec_f3e_seam_scenarios_tests.rs`

> inputs/source/dnavisicalc-traces/
- `EXAM_SUMMARY.md`
- `seam_trace.event_counts.tsv`
- `seam_trace.callgraph.edges.csv`

> inputs/source/research-dag-run/
- `01_scope_and_question_map.md`
- `02_theory_and_math_catalog.md`
- `03_algorithm_family_map.md`
- `04_dnacalc_transfer_matrix.md`
- `05_deep_research_synthesis.md`
- `09_external_report_reconciliation.md`
- `10_conformance_and_proof_obligations.md`
- `11_empirical_pack_definitions.md`

> inputs/source/synthesis-current/
- `design_brief.md`
- `01_gap_map.md`
- `03_stable_topic_entries.md`
- `06_fec_f3e_b4_pointer_intake.md`

> inputs/source/dnavisicalc-spec/
- `SPEC_v0.md`
- `ENGINE_REQUIREMENTS.md`
- `ENGINE_API.md`

## Must Delete (outdated/duplicate/history-heavy)
> inputs/source/dnavisicalc-fec/
- entire folder (legacy duplicates + review/history-heavy files)

> inputs/source/foundation-reference/
- `FEC_F3E_INTERFACE_DRAFT_SPEC.md` (legacy draft)
- `FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv` (likely stale)

> inputs/source/research-dag-run/
- `06_follow_up_prompt_pack.md` (prompt-process artifact, not design content)
- `07_claude_research_report.md` (raw external intermediate)
- `08_chatgpt_research_report.md` (raw external intermediate)
- `source_list.csv` (source registry; process metadata)

> inputs/source/synthesis-current/
- `synthesis_report.md` (run/process summary)
- `open_decisions_register.md` (process tracker)

> inputs/source/dnavisicalc-traces/
- `seam_trace.log` (full raw trace history)
- `seam_trace.callgraph.dot` (render artifact)
- `dynamic_retargeting_trace.log` (raw scenario log)
- `spill_takeover_clearance_trace.log` (raw scenario log)

## Recommended Rename (clarity)
1. `inputs/source/dnavisicalc-fec-current` -> `inputs/source/fec-f3e-current-spec`
2. `inputs/source/dnavisicalc-impl` -> `inputs/source/fec-f3e-implementation`
3. `inputs/source/dnavisicalc-traces` -> `inputs/source/fec-f3e-evidence`
4. `inputs/source/research-dag-run` -> `inputs/source/dag-research-synthesis`
5. `inputs/source/synthesis-current` -> `inputs/source/foundation-design-draft`

## Optional Keep (if you want extra context)
> inputs/source/foundation-notes/
- `RESEARCH_NOTES.md` (recommended keep)
- `BRAINSTORM_NOTES.md` (optional)
- `VISICALC_V0_SCOPE_ALIGNMENT_NOTES.md` (optional)

> inputs/source/foundation-reference/
- `EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md` (optional legacy reference)

> inputs/source/dnavisicalc-impl/
- `eval.rs` (optional; useful for observation capture semantics, but large)

## PowerShell Execution (manual)
```powershell
$base = "C:\Work\DnaCalc\Foundation\prompts\runs\20260308-171858-core-engine-fec-f3e-deep-research-pack-01\inputs\source"

# Deletes
Remove-Item -Recurse -Force "$base\dnavisicalc-fec"
Remove-Item -Force "$base\foundation-reference\FEC_F3E_INTERFACE_DRAFT_SPEC.md"
Remove-Item -Force "$base\foundation-reference\FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv"
Remove-Item -Force "$base\research-dag-run\06_follow_up_prompt_pack.md","$base\research-dag-run\07_claude_research_report.md","$base\research-dag-run\08_chatgpt_research_report.md","$base\research-dag-run\source_list.csv"
Remove-Item -Force "$base\synthesis-current\synthesis_report.md","$base\synthesis-current\open_decisions_register.md"
Remove-Item -Force "$base\dnavisicalc-traces\seam_trace.log","$base\dnavisicalc-traces\seam_trace.callgraph.dot","$base\dnavisicalc-traces\dynamic_retargeting_trace.log","$base\dnavisicalc-traces\spill_takeover_clearance_trace.log"

# Renames
Rename-Item "$base\dnavisicalc-fec-current" "fec-f3e-current-spec"
Rename-Item "$base\dnavisicalc-impl" "fec-f3e-implementation"
Rename-Item "$base\dnavisicalc-traces" "fec-f3e-evidence"
Rename-Item "$base\research-dag-run" "dag-research-synthesis"
Rename-Item "$base\synthesis-current" "foundation-design-draft"
```

After delete/rename, regenerate:
1. `inputs/source_index.csv`
2. `inputs/source_hashes.csv`
3. prompt entrypoint paths in `inputs/prompt_pro_deep_research_core_engine_fec_f3e_design.md`
