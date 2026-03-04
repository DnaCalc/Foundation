# Multi-Model Results Summary

Run: `20260303-093804-xll-non-interesting-pack-pass-02-fec`
Pack base: `prompts/packs/xll-non-interesting-functions-implementation.md` (FEC-augmented run prompt)

## Models
1. Codex: `gpt-5.3-codex` (`xhigh`)
2. Claude: `claude-opus-4-6` (`high`)
3. Gemini: `gemini-3.1-pro-preview`

## Output Files
1. `01_codex.md`
2. `02_claude.md`
3. `03_gemini.md`
4. `04_best_of_three_fec_synthesis.md`

## Quick Comparison

### Codex
Strengths:
1. Best structural discipline and concise 9-section alignment.
2. Strongest explicit rule for undeclared FEC access prohibition.

Gaps:
1. Less concrete detail on registration/coercion variants.

### Claude
Strengths:
1. Richest detail on FEC capability families and implementation flow.
2. Strong examples for aggregate/reference-sensitive contracts.

Gaps:
1. A few stronger assertions (for example broad thread-safe defaults) still require evidence closure.

### Gemini
Strengths:
1. Clear concise overview.
2. Good readability for first-pass adoption.

Gaps:
1. Lower specificity and fewer concrete edge-case controls.

## Best-Value Reading Order
1. `04_best_of_three_fec_synthesis.md` (consolidated baseline)
2. `01_codex.md` (structure and enforcement clarity)
3. `02_claude.md` (implementation detail depth)
4. `03_gemini.md` (concise overview)

## Recommendation
Use `04_best_of_three_fec_synthesis.md` as the current baseline for doc promotion and FEC-aware empirical planning.
