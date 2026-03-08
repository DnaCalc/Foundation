# Run README

Run ID: 20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01
Purpose: Parallel deep-design runs on the same base prompt with iterative self-review.

Models:
- Claude: `claude-opus-4-6` with `--effort high`
- OpenAI: `gpt-5.4` with `model_reasoning_effort="xhigh"`

Response capture policy:
- Keep every pass output (base, review1, review2/final) in `responses/<lane>/`.
- Keep command stdout/stderr logs in `logs/`.
- Record run metadata in `logs/model_runs.csv` and `logs/manifest.csv`.
