# Excel Worksheet-Engine Conformance Workspace

This folder is the authoritative working conformance specification area for Excel worksheet-engine compatibility scope.

## Authoritative documents
- `EXCEL_CONFORMANCE_SPEC.md`: single working spec for implementation and conformance testing.
- `CONFORMANCE_REQUIREMENTS.csv`: itemized requirements with evidence ids and status.
- `SOURCE_BINDINGS.csv`: source registry bridge for evidence ids used by requirements.
- `KNOWN_GAPS_AND_UNCERTAINTIES.md`: explicit open/provisional areas.

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
