No tool use. Work only from this text.

Run id: 20260303-093804-xll-non-interesting-pack-pass-02-fec

Task:
Produce a planning/spec response for language-independent `.xll` implementation of non-interesting Excel functions by combining two threads:
1) prior best synthesis for function contracts and XLL implementation planning,
2) Formula Evaluation Context (FEC) as a first-class contract boundary.

Required FEC concept:
- FEC is the host-provided context external to pure formula/function core.
- Each function/operator declares a `fec_dependency_profile` and optional facility tags.
- Capability families include at least:
  - `cap_reference_resolution`
  - `cap_caller_context`
  - `cap_time_provider`
  - `cap_random_provider`
  - `cap_external_provider`
  - `cap_locale_parse_format`
  - `cap_feature_gate`
  - `cap_error_detail_enrichment`
- FEC profile values include at least:
  - `none`
  - `ref_only`
  - `caller_context`
  - `time_provider`
  - `random_provider`
  - `external_provider`
  - `locale_profile`
  - `composite`

Constraints:
1. Keep implementation language independent.
2. Assume clean-room evidence discipline and conformance traceability.
3. Keep strict two-layer architecture:
   - Layer A: declarative adapter (coercion/reference normalization/error-exit/FEC access boundary)
   - Layer B: typed core kernel (pure typed logic)
4. Include formal contract candidates (preconditions/postconditions/invariants).
5. Keep unresolved assumptions explicit.
6. Include explicit rule: function must not observe undeclared FEC facilities.

Deliver sections in this exact order:
1. Scope Freeze And Inventory Rule
2. Semantic Contract Schema (Per Function)
3. FEC Contract Overlay (profiles, capability tags, enforcement)
4. XLL Registration/Type Mapping Plan (`xlfRegister`, `pxTypeText`, caller context)
5. Two-Layer Implementation Template (Adapter vs Typed Core)
6. Formal Contract Candidates (with examples: SIN, one aggregate, one reference-sensitive function)
7. Differential Validation Matrix (native Excel vs add-in)
8. Parity-Hypothesis Challenge List (possible counterexamples)
9. Promotion Pack (decisions, unresolved items, doc updates, empirical plan)

Use concise but complete markdown with tables where useful.

