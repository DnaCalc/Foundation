# Formula Parse Wave 1 Execution Report

## Scope
Executed `ECS-EB-028`, `ECS-EB-029`, and `ECS-EB-030` wave-1 scenarios from the seeded corpus registry.

## Execution status
- Scenario rows: 20
- Observed accepted: 16
- Observed rejected: 4
- Probe-expected rows: 1
- Mismatch rows: 1
- Run-failed rows: 0

## Key outcomes
1. Parse acceptance corpus produced expected accept/reject outcomes for most baseline constructs.
2. Normalization captures observed stored-form canonicalization in 2/2 accepted normalization rows.
3. Dot-field probe (=A1.Price) was accepted syntactically and evaluated to a field-related worksheet error in this environment.
4. One ambiguity mismatch was observed (=SUM(A1,,B1) accepted and evaluated rather than rejecting).
5. All scenarios completed with zero run-level failures in the final rerun.

### Mismatch detail
- `SCN-EB030-AMBIG-DOUBLE-COMMA`: expected `rejected`, observed `accepted`, stored formula `=SUM(A1,,B1)`.

## Artifacts
- `ECS-EB-028_formula_parse_acceptance_corpus_wave1.csv`
- `ECS-EB-029_formula_normalization_capture_wave1.csv`
- `ECS-EB-030_grammar_ambiguity_probe_wave1.csv`
- `formula_parse_case_registry_wave1.csv`
- `scenario_manifest_wave1.csv`
- `evidence/<scenario_id>/*`
