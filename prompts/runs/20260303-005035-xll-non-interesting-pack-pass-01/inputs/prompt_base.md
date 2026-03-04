No tool use. Work only from this text.

Run id: 20260303-005035-xll-non-interesting-pack-pass-01

Task:
Execute a planning/spec response as if you are running the prompt pack for language-independent `.xll` implementation of non-interesting Excel functions.

Constraints:
1. Keep implementation language independent.
2. Assume clean-room evidence discipline and conformance traceability.
3. Use a two-layer model:
   - Layer A: declarative type/coercion/conversion/error-exit adapter.
   - Layer B: tightly typed core kernel (e.g., `SIN: double -> double`).
4. Include formal contract candidates (preconditions/postconditions/invariants).
5. Keep unresolved assumptions explicit.

Deliver sections in this exact order:
1. Scope Freeze And Inventory Rule
2. Semantic Contract Schema (Per Function)
3. XLL Registration/Type Mapping Plan (`xlfRegister`, `pxTypeText`, caller context)
4. Two-Layer Implementation Template (Adapter vs Typed Core)
5. Formal Contract Candidates (with examples: SIN, one aggregate, one reference-sensitive function)
6. Differential Validation Matrix (native Excel vs add-in)
7. Parity-Hypothesis Challenge List (possible counterexamples)
8. Promotion Pack (decisions, unresolved items, doc updates, empirical plan)

Use concise but complete markdown with tables where useful.
