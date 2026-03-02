# Function Definition Discussion Register

## 1. Purpose
Drive interactive decisions needed to move function-definition rows from `draft/provisional` to stable conformance policy.

## 2. Core Discussion Topics

### D-001: Volatile vs Non-Deterministic
Question:
1. Should volatility be treated strictly as an invalidation/recalc trigger property, with non-determinism as an output-stability property?

Why this matters:
1. Prevents conflating recalc behavior with semantic randomness/time/external variability.
2. Affects `XLS-CF-FN-008`, replay contracts, and reason-code interpretation.

Decision output needed:
1. Final axis definitions and allowed combinations.
2. Minimum required probe set per combination.

### D-002: Host Interaction During Evaluation
Question:
1. What host-state dimensions are first-class in function semantics (`workbook`, `application`, `environment`, `external-provider`)?

Why this matters:
1. Defines reproducibility boundary for empirical findings.
2. Controls capability-gating and platform caveat policy (`XLS-CF-FN-007`, `XLS-CF-VP-003`).

Decision output needed:
1. Canonical host-interaction taxonomy.
2. Required metadata contract in evidence outputs.

### D-003: Invalidation Trigger Classes
Question:
1. Which trigger classes are mandatory for function definitions and conformance tests (`T-DEP`, `T-VOL`, `T-HOST`, `T-EXT`, `T-VERSION`)?

Why this matters:
1. Drives probe design and replay determinism.
2. Reduces ambiguity in counter-signal interpretation.

Decision output needed:
1. Final trigger-class vocabulary.
2. Mapping contract from function rows to trigger-class set.

### D-004: Aggregate Coercion Policy
Question:
1. How should we formalize direct-argument coercion vs range-scan coercion, and which is normative when signals conflict?

Why this matters:
1. Blocks closure of `XLS-CF-TV-008`.
2. Impacts many aggregate functions beyond `SUMIF`.

Decision output needed:
1. Policy matrix template for aggregate families.
2. Version-scoping rule when behavior diverges.

### D-005: Argument-Gap Semantics
Question:
1. What is the compatibility policy for missing-argument forms (for example `=SUM(A1,,B1)`)?

Why this matters:
1. Blocks closure of `XLS-CF-FL-010`.
2. Affects parser/evaluator boundary assumptions.

Decision output needed:
1. Accepted/rejected/mapped classes by function family.
2. Compatibility-mode behavior plan if divergence remains.

### D-006: Dynamic-Array Function Coupling
Question:
1. Which spill-related expectations are function-definition obligations versus non-function formula/format/table obligations?

Why this matters:
1. Needed to close `XLS-CF-FL-005`, `XLS-CF-TB-004`, `XLS-CF-FM-005` coherently.
2. Prevents misclassification of mismatch causes.

Decision output needed:
1. Function-vs-non-function boundary statement.
2. Ownership mapping for each spill-related requirement lane.

## 3. Decision Log Template
For each discussion item:
1. `decision_id`
2. `topic_id`
3. `decision_text`
4. `applies_to_fdef_ids`
5. `affected_requirement_ids`
6. `evidence_basis`
7. `date_utc`
8. `owner`

## 4. Current Blocking Status
1. Non-function conformance closure is complete to current evidence boundaries.
2. Remaining blocker is function-definition policy finalization using the discussion topics above.
