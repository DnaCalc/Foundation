# Prompt Pack: XLL Non-Interesting Functions Implementation (Language-Independent)

## Purpose
Define a repeatable prompt sequence to plan and execute a differential implementation of all non-interesting Excel functions via an `.xll` add-in, without binding to a specific implementation language.

## Inputs Required
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `reference/conformance/excel-worksheet-engine/EXCEL_CONFORMANCE_SPEC.md`
5. `reference/conformance/excel-worksheet-engine/CONFORMANCE_REQUIREMENTS.csv`
6. `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
7. `reference/conformance/excel-worksheet-engine/functions/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`
8. `reference/conformance/excel-worksheet-engine/functions/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.csv`
9. Function catalog sources:
   - `research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_catalog_full.csv`
   - `research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_interest_index.csv`
10. Empirical findings:
    - `reference/empirical/findings_registry.jsonl`
11. Excel-runner tooling context:
    - `tools/excel-probe/README.md`
    - `tools/excel-probe/tools/ExcelProbe/Program.cs`

## Expected Outputs
1. Complete non-interesting function inventory and implementation scope freeze.
2. Per-function semantic contract rows (arguments, coercion, errors, return adaptation, host interaction).
3. Language-independent `.xll` contract model (registration, invocation, caller context, volatility controls).
4. Differential test matrix (native Excel vs add-in function behavior).
5. Open-issue register for parity failures and classification updates.
6. Pack-ready artifact set under `prompts/runs/<run-id>/`.

## Constraints
1. Keep implementation language unspecified.
2. Treat operators-as-functions requirements as in-scope for semantic coverage, but prioritize non-interesting named functions first.
3. Do not assume unresolved function-policy decisions are settled; tag uncertainties explicitly.
4. Keep clean-room compliance and evidence traceability explicit.

## Run Structure
Execute in seven passes.

### Pass 1: Scope Freeze and Inventory
Prompt:
```
Using the provided function catalog and interest tiers, produce the authoritative non-interesting function set (tiers 1/2 by default unless explicitly overridden). Output:
1) frozen inventory list,
2) excluded list with reason,
3) count summary by category.
No implementation details yet.
```

### Pass 2: Semantic Contract Extraction
Prompt:
```
For each non-interesting function in scope, create a semantic contract row with:
- canonical name
- arity and optional/omitted argument policy
- argument coercion policy class
- error policy class
- return kind (scalar/array/reference-like) and post-call adaptation notes
- host interaction class
- determinism/volatility class
- compatibility-version sensitivity (known/unknown)
- confidence and missing evidence markers
Output CSV + markdown summary.
```

### Pass 3: XLL Contract Model (Language-Independent)
Prompt:
```
Define a language-independent XLL implementation contract for the scoped function set:
1) registration model and metadata schema,
2) invocation and caller-context handling,
3) reference/value argument handling contract,
4) volatility and recalc policy hooks,
5) result marshaling contract (including array and reference-like returns),
6) explicit non-goals.
Do not assume C++/C#/Rust specifics.
```

### Pass 4: Differential Test Design
Prompt:
```
Produce a differential test plan comparing native Excel functions to add-in implementations:
1) test dimensions (value types, references, errors, omitted args, locale profile, compatibility version),
2) deterministic replay requirements,
3) expected artifact schema per scenario,
4) pass/fail rules and triage classes.
Include dedicated probes for candidate boundary cases (e.g., XLOOKUP reference-output behavior).
```

### Pass 5: Batch Implementation Backlog
Prompt:
```
Create an execution backlog for implementing non-interesting functions in batches.
For each batch provide:
1) function list,
2) shared coercion/error patterns,
3) expected risk level,
4) required tests,
5) exit criteria.
Order batches to maximize early confidence.
```

### Pass 6: Parity-Hypothesis Challenge Pass
Prompt:
```
Attempt to falsify the hypothesis that every non-interesting function can be implemented with full fidelity via XLL-style UDFs.
Output:
1) potential counterexample functions,
2) why they may violate the hypothesis,
3) empirical probe designs to confirm/refute,
4) proposed class-axis updates if violations hold.
```

### Pass 7: Synthesis and Promotion Pack
Prompt:
```
Synthesize passes 1-6 into a promotion-ready package:
1) accepted decisions,
2) unresolved decisions,
3) required doc updates (exact files/sections),
4) empirical run plan additions,
5) readiness statement for starting implementation.
Keep output tightly mapped to conformance ids and function-definition rows.
```

## Output Contract for `prompts/runs/<run-id>/`
1. `outputs/non_interesting_inventory.csv`
2. `outputs/non_interesting_semantic_contracts.csv`
3. `outputs/xll_language_independent_contract.md`
4. `outputs/differential_test_matrix.csv`
5. `outputs/implementation_batch_backlog.md`
6. `outputs/parity_hypothesis_challenges.md`
7. `outputs/synthesis_promotion_pack.md`
8. `logs/run_manifest.json`
9. `logs/source_manifest.csv`

## Notes
1. This pack is planning/spec-first scaffolding; it does not itself execute code.
2. Empirical execution should run through established research/runner infrastructure and then feed back into conformance artifacts.
