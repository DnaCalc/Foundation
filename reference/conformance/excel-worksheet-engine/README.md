# Excel Worksheet-Engine Conformance Workspace

This folder is the authoritative working conformance specification area for Excel worksheet-engine compatibility scope.

## Authoritative documents
- `EXCEL_CONFORMANCE_SPEC.md`: single working spec for implementation and conformance testing.
- `CONFORMANCE_REQUIREMENTS.csv`: itemized requirements with evidence ids and status.
- `SOURCE_BINDINGS.csv`: source registry bridge for evidence ids used by requirements.
- `KNOWN_GAPS_AND_UNCERTAINTIES.md`: explicit open/provisional areas.
- `model/EXCEL_CELL_CONCRETE_MODEL.md`: Excel-first concrete cell semantics model (nitpick target).
- `model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`: concrete worksheet formula-language rules and empirical parse anchors.
- `model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`: formula-rule status/evidence/probe mapping table.
- `model/EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md`: pass-2 probe plan plus execution status snapshot.
- `model/EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv`: seeded scenario list for pass-2 formula-language probes.
- `model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md`: open/gap ledger for the concrete model.
- `model/EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl`: machine-linkable statement-to-evidence trace records.
- `../../../research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/`: executed pass-2 artifacts and evidence bundles.

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
