# Multi-Model Results Summary

Run: `20260303-005035-xll-non-interesting-pack-pass-01`  
Pack: `prompts/packs/xll-non-interesting-functions-implementation.md`

## Models
1. Codex: `gpt-5.3-codex` (`xhigh`)
2. Claude: `claude-opus-4-6` (`high`)
3. Gemini: `gemini-3.1-pro-preview`

## Output Files
1. `01_codex.md`
2. `02_claude.md`
3. `03_gemini.md`
4. `04_best_of_three_synthesis.md`

## Quick Comparison

### Codex
Strengths:
1. Clear section alignment with requested 8-section structure.
2. Strong `REQ -> CONTRACT -> TEST -> EVIDENCE` framing.
3. Useful pilot-scoping discipline and explicit unresolved assumptions.

Gaps:
1. Scope narrowed to a 3-function pilot (`SIN`, `SUM`, `ROW`) rather than a complete non-interesting inventory.
2. Less detail on concrete XLL registration/type string edge cases than Claude.

### Claude
Strengths:
1. Most comprehensive and implementation-ready response.
2. Best detail on XLL registration/type mapping strategy and adapter/core separation.
3. Richest contract and validation matrix with stronger family partitioning.

Gaps:
1. Some asserted choices (for example broad thread-safety assumptions) still need evidence confirmation.
2. A few scope gates and exclusions should be reconciled with Foundation function-tier docs before promotion.

### Gemini
Strengths:
1. Concise and clean baseline structure.
2. Good starter schema for contracts and differential probes.

Gaps:
1. Lowest depth; closely mirrors a generic pattern and leaves many details unstated.
2. Less useful for immediate doc promotion without substantial augmentation.

## Best-Value Reading Order
1. `04_best_of_three_synthesis.md` (consolidated primary)
2. `02_claude.md` (deep implementation detail source)
3. `01_codex.md` (traceability and promotion-gate structure)
4. `03_gemini.md` (concise baseline sanity check)

## Recommendation
Use `04_best_of_three_synthesis.md` as the current working baseline.
It integrates Claude depth, Codex traceability discipline, and stricter unresolved/evidence tagging for promotion safety.
