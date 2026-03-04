# Prompt Pack: XLL Non-Interesting Functions Implementation (Language-Independent)

## Purpose
Define a repeatable prompt sequence to plan and execute a differential implementation of all non-interesting Excel functions via an `.xll` add-in, without binding to a specific implementation language.

## Inputs Required
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `reference/conformance/excel-worksheet-engine/EXCEL_CONFORMANCE_SPEC.md`
5. `reference/conformance/excel-worksheet-engine/CONFORMANCE_REQUIREMENTS.csv`
6. `../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
7. `../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`
8. `../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.csv`
9. `reference/conformance/excel-worksheet-engine/functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`
10. Function catalog sources:
   - `research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_catalog_full.csv`
   - `research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_interest_index.csv`
11. Empirical findings:
    - `reference/empirical/findings_registry.jsonl`
12. Excel-runner tooling context:
    - `tools/excel-probe/README.md`
    - `tools/excel-probe/tools/ExcelProbe/Program.cs`

## Expected Outputs
1. Complete non-interesting function inventory and implementation scope freeze.
2. Per-function semantic contract rows (arguments, coercion, errors, return adaptation, host interaction).
3. Language-independent `.xll` contract model (registration, invocation, caller context, volatility controls).
4. XLL registration/type mapping tables extracted from SDK digest (`pxTypeText`, key type families, callback constraints).
5. Formal contract candidates per function family and function (`preconditions`, `postconditions`, `invariants`).
6. Type-handling factorization model:
   - declarative adapter layer (coercion/conversion/error-exit),
   - tightly typed core implementation kernel.
7. Differential test matrix (native Excel vs add-in function behavior).
8. Open-issue register for parity failures and classification updates.
9. Pack-ready artifact set under `prompts/runs/<run-id>/`.

## Constraints
1. Keep implementation language unspecified.
2. Treat operators-as-functions requirements as in-scope for semantic coverage, but prioritize non-interesting named functions first.
3. Do not assume unresolved function-policy decisions are settled; tag uncertainties explicitly.
4. Keep clean-room compliance and evidence traceability explicit.
5. Drive toward a two-layer function model for verification:
   - Layer A: declarative Excel-facing type adapter and error-exit logic,
   - Layer B: typed core kernel (for example `SIN: double -> double`).
6. Prefer template/boilerplate generation patterns for Layer A to minimize handwritten coercion logic.

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
- candidate typed-core signature (for example `double -> double`, `double*double -> double`, `array<double> -> double`)
- preconditions
- postconditions
- invariants
- confidence and missing evidence markers
Output CSV + markdown summary.
```

### Pass 3: XLL Contract Model (Language-Independent)
Prompt:
```
Define a language-independent XLL implementation contract for the scoped function set:
1) registration model and metadata schema,
2) explicit `pxTypeText` mapping table (return/arg classes + suffix behavior markers),
3) invocation and caller-context handling,
4) declarative adapter model for reference/value argument normalization and coercion,
5) explicit error-exit contract in adapter layer,
6) typed-core kernel interface contract (inputs/outputs free of Excel variant container concerns where feasible),
7) volatility and recalc policy hooks,
8) result marshaling/return-adaptation contract (including array and reference-like returns),
9) callback/thread/memory-ownership constraints,
10) explicit non-goals.
Do not assume C++/C#/Rust specifics.
```

### Pass 3b: Contract and Verification Shape
Prompt:
```
Using pass-2 contracts and pass-3 architecture, propose formal contract shapes suitable for later proof/model/oracle comparison:
1) precondition schema,
2) postcondition schema,
3) per-function invariants,
4) adapter-vs-core refinement relation (what Layer A guarantees to Layer B),
5) differential oracle check obligations.
Provide examples for at least:
- SIN (pure numeric),
- one aggregate with coercion complexity,
- one reference-sensitive non-interesting function.
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
4. `outputs/xll_registration_type_mapping.csv`
5. `outputs/non_interesting_formal_contract_candidates.md`
6. `outputs/non_interesting_typed_kernel_catalog.csv`
7. `outputs/adapter_layer_template_spec.md`
8. `outputs/differential_test_matrix.csv`
9. `outputs/implementation_batch_backlog.md`
10. `outputs/parity_hypothesis_challenges.md`
11. `outputs/synthesis_promotion_pack.md`
12. `logs/run_manifest.json`
13. `logs/source_manifest.csv`

## Notes
1. This pack is planning/spec-first scaffolding; it does not itself execute code.
2. Empirical execution should run through established research/runner infrastructure and then feed back into conformance artifacts.
