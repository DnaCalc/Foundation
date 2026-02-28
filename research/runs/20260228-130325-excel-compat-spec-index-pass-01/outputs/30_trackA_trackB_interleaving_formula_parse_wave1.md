# Pass 30 - Track A/B Interleaving: Formula Parse Wave 1

## Scope
Interleaved closure batch for `ECS-BL-07` through:
- Track A: corpus-registry status promotion and formal-mapping handoff updates.
- Track B: empirical wave execution for `ECS-EB-028`, `ECS-EB-029`, `ECS-EB-030`.

Primary references:
- `19_formula_language_formal_mapping_dossier.md`
- `25_formula_parse_corpus_registry_seed.md`
- empirical outputs under `../../20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/`

## Empirical outputs linked
1. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/ECS-EB-028_formula_parse_acceptance_corpus_wave1.csv`
2. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/ECS-EB-029_formula_normalization_capture_wave1.csv`
3. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/ECS-EB-030_grammar_ambiguity_probe_wave1.csv`
4. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/WAVE1_EXECUTION_REPORT.md`

## Track A registry promotion
Updated artifact:
- `formula_parse_corpus_registry.csv`

Status transitions applied:
1. `planned` -> `wave1_executed` for `FPC-028-AT-HASH`, `FPC-028-TABLE-REF`, `FPC-028-LAMBDA-LET`, `FPC-029-NORMALIZATION`.
2. `planned` -> `wave1_executed_probe` for `FPC-028-DATA-TYPE-FIELD` (accepted syntax with field-context runtime errors).
3. `planned` -> `wave1_executed_mixed` for `FPC-028-REF-OPS` due one ambiguity mismatch.

## Key synthesis decisions
1. `=SUM(A1,,B1)` is now an explicit ambiguity finding: accepted/evaluated in this environment, contrary to initial reject expectation.
2. Dot-field syntax (`=A1.Price`) parsed successfully and produced field-related worksheet errors under non-linked-type inputs; syntax acceptance is separated from semantic availability.
3. Normalization behavior is now empirically anchored: canonical uppercasing and identifier normalization were observed in both wave-1 normalization cases.

## Status decision
Track A/B interleaving advanced `ECS-BL-07` from seeded planning artifacts to evidence-backed corpus outcomes with explicit mismatch triage and updated registry status tags.
