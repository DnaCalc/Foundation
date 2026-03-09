# Excel Worksheet-Engine Conformance Workspace

This folder is the authoritative working conformance specification area for Excel worksheet-engine compatibility scope.

## Active core documents
- `EXCEL_CONFORMANCE_SPEC.md`: single working conformance spec contract.
- `CONFORMANCE_REQUIREMENTS.csv`: itemized requirement rows and conformance status.
- `SOURCE_BINDINGS.csv`: evidence/source registry bridge used by requirements.
- `KNOWN_GAPS_AND_UNCERTAINTIES.md`: explicit unresolved/provisional lanes.
- `model/README.md`: model-lane index and archival boundaries.
- `model/EXCEL_CELL_CONCRETE_MODEL.md`: concrete in-cell semantics model.
- `model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`: concrete formula-language rules.
- `model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`: formula rule coverage and status.
- `model/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`: formatting/visibility model lanes.
- `model/fec-f3e/README.md`: active FEC/F3E detail set index.
- `model/fec-f3e/FEC_F3E_REDESIGN_SPEC.md`: active seam contract baseline.
- `model/fec-f3e/FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv`: active current protocol matrix.

## Active external references
- `../../../../OxFunc/CHARTER.md`: OxFunc charter.
- `../../../../OxFunc/docs/function-lane/*`: mutable function/value working docs (OxFunc-owned).
- `functions/XLL_SDK_REGISTRATION_AND_TYPES_REFERENCE.md`: Foundation-owned XLL reference artifact.

## Active empirical/formal run lanes
- `../../../research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/`
- `../../../research/runs/20260302-100724-excel-nonfunction-closure-pass-01/outputs/`
- `../../../reference/runs/20260305-ms-formatting-formal-pass-01/outputs/`
- `../../../research/runs/20260305-235500-excel-formatting-hierarchy-empirical-pack-01/outputs/`

## Archival policy
- Legacy FEC/F3E drafts are archived at `model/archive/fec-f3e-legacy/`.
- Old compatibility file names are kept as redirect stubs in `model/` to avoid link rot.

## Evidence lineage model
- `ECS-*`: legacy source ids from prior research source registry.
- `REFX-*`: mirrored reference-spec entries from `reference/index.csv` and processed-run artifacts.
- `EMP-*`: curated empirical finding ids from `reference/empirical/findings_registry.jsonl`.
- `INT-*`: internal normative design artifacts for FEC/F3E protocol and boundary modeling.
