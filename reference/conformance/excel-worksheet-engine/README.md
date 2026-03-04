# Excel Worksheet-Engine Conformance Workspace

This folder is the authoritative working conformance specification area for Excel worksheet-engine compatibility scope.

## Authoritative documents
- `EXCEL_CONFORMANCE_SPEC.md`: single working spec for implementation and conformance testing.
- `CONFORMANCE_REQUIREMENTS.csv`: itemized requirements with evidence ids and status.
- `SOURCE_BINDINGS.csv`: source registry bridge for evidence ids used by requirements.
- `KNOWN_GAPS_AND_UNCERTAINTIES.md`: explicit open/provisional areas.
- `model/EXCEL_CELL_CONCRETE_MODEL.md`: Excel-first concrete cell semantics model (nitpick target).
- `model/EXCEL_FORMULA_EVALUATION_CONTEXT_FEC.md`: first-pass Formula Evaluation Context planning doc for parser/binder/evaluator host-context boundaries.
- `model/FEC_F3E_INTERFACE_DRAFT_SPEC.md`: comprehensive draft FEC/F3E interface and protocol specification for implementation planning and pathfinder refactor alignment.
- `model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`: concrete worksheet formula-language rules and empirical parse anchors.
- `model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`: formula-rule status/evidence/probe mapping table.
- `model/EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`: pass-2 probe plan plus execution status snapshot.
- `model/EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv`: seeded scenario list for pass-2 formula-language probes.
- `model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`: open/gap ledger for the concrete model.
- `model/EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`: machine-linkable statement-to-evidence trace records.
- `../../../../OxFunc/CHARTER.md`: OxFunc charter for formalization and proof-oriented closure of the worksheet function universe with Rust implementation obligations.
- `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`: preliminary function-definition semantics frame for interactive tightening.
- `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`: preliminary function-definition conformance lanes and affected requirement bindings.
- `../../../../OxFunc/docs/function-lane/EXCEL_FUNCTION_DEFINITION_DISCUSSION.md`: structured discussion doc for unresolved function-policy decisions.
- `../../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.csv`: first-pass axis classification for all interesting functions (tiers 3/4/5).
- `../../../../OxFunc/docs/function-lane/INTERESTING_FUNCTIONS_INITIAL_CLASSIFICATION.md`: coverage summary and review priorities for the initial classification set.
- `functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`: curated XLL SDK digest for registration signatures, type system, caller context, callbacks, and memory ownership (Foundation-owned reference artifact).
- `../../../research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/`: executed pass-2 artifacts and evidence bundles.
  - includes pass-4 policy/trace sync, pass-5 replay pack, and pass-3 interactive planning note.
- `../../../research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/`: non-function closure run artifacts including targeted link/format/table replay and ambiguity register.

## Evidence lineage model
- `ECS-*`: source ids from prior Excel research source registry (`research/.../source_list.csv`).
- `REFX-*`: mirrored reference spec entries from `reference/index.csv`.
- `EMP-*`: curated empirical finding ids from `reference/empirical/findings_registry.jsonl`.

## Scope
- Formula language semantics.
- Built-in function set and classification.
- Value types and coercion behavior.
- Table/ListObject semantics.
- Formatting semantics.
- Version/platform caveats and build-scoped behaviors.

## Notes
- Large detail tables (for example full 500-function inventory) are referenced rather than duplicated.
- Requirement rows marked `provisional` must not be treated as fully settled compatibility truth without follow-up.
- Concrete-model work is Excel-first: define concrete behavior first, then extract abstraction later.
