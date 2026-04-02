# DNA OneCalc Upstream Clarification Pass 01

This run executes repo-local doc-improvement prompts for the first two upstream repos needed by `DNA OneCalc` in the current clarification wave:
1. `OxReplay`
2. `OxXlPlay`

The purpose is to improve the authoritative repo-local docs that `DNA OneCalc` depends on, using the current Foundation OneCalc scope note as the downstream consumer brief.

Expected artifacts:
> `inputs/`
- `01_oxreplay_prompt.md`
- `02_oxxlplay_prompt.md`

> `logs/`
- Claude JSON logs for each repo-local prompt run

> `responses/`
- extracted Claude text responses for each repo-local prompt run

Repos targeted by this pass:
- `C:\Work\DnaCalc\OxReplay`
- `C:\Work\DnaCalc\OxXlPlay`
