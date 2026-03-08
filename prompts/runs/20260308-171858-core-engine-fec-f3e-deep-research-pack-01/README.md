# Run README

- Run ID: 20260308-171858-core-engine-fec-f3e-deep-research-pack-01
- Purpose: Single-directory source bundle + prompt for external Pro/Deep Research and local multi-model design cycles.

## Contents
- `inputs/source/`: copied source corpus (Foundation + DnaVisiCalc + research/synthesis artifacts)
- `inputs/source_index.csv`: source mapping and rationale
- `inputs/source_hashes.csv`: frozen hashes for reproducibility
- `inputs/prompt_pro_deep_research_core_engine_fec_f3e_design.md`: primary deep research prompt
- `logs/manifest.csv`: run activity log
- `responses/`: place model outputs here

## Suggested execution loop
1. Run prompt with ChatGPT Pro deep research.
2. Run same prompt with Claude (or Claude deep research equivalent).
3. Run local Codex xhigh using the same bundle/prompt.
4. Produce a cross-synthesis response that compares all three and resolves conflicts by citing bundle evidence.

## Notes
- Treat `inputs/source/dnavisicalc-fec/ENGINE_FEC_F3E_FOUNDATION_UPDATED_SPEC_POINTERS_PROMPT.md` as the canonical post-review FEC/F3E handoff pointer set.
- Use `inputs/source/dnavisicalc-fec-current/` as the consolidated current-best FEC/F3E spec set for synthesis runs.
- Treat Foundation FEC/F3E draft docs under `inputs/source/foundation-reference/` as legacy context, not primary contract authority for this run.
- This bundle is an input package; it does not itself promote doctrine text.
