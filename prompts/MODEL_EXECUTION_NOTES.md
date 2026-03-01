# Prompt Model Execution Notes

Last verified: 2026-03-01

## Preferred Model Pins

- Claude CLI: `claude-opus-4-6` with `--effort high` (max available effort level in this CLI).
- Gemini CLI: `gemini-3.1-pro-preview`.
- Codex CLI: `gpt-5.3-codex` with `model_reasoning_effort="xhigh"`.

## One-Shot Command Templates

### Claude
```powershell
claude -p "<PROMPT>" --model claude-opus-4-6 --effort high --output-format json
```

Verification:
- Check JSON `modelUsage` includes `claude-opus-4-6`.

### Gemini
```powershell
gemini -p "<PROMPT>" --model gemini-3.1-pro-preview --output-format json
```

Verification:
- Check JSON `stats.models` includes `gemini-3.1-pro-preview`.

### Codex
```powershell
codex exec --json -m gpt-5.3-codex -c 'model_reasoning_effort="xhigh"' "<PROMPT>"
```

Verification:
- JSONL output confirms run completion.
- Session trace under `$env:USERPROFILE\.codex\sessions\...` includes:
  - `"model":"gpt-5.3-codex"`
  - `"effort":"xhigh"` (in `turn_context`).

## Notes

- For repeatability in prompt runs, keep these model pins explicit in launcher scripts or run manifests.
- If a model id fails, capture the exact error text in the run log before switching ids.
