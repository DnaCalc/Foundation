# Reason-Code Wave 1 Execution Report

## Scope
Executed `ECS-EB-040` targeted weak-evidence reason-code probes and applied `ECS-EB-041` classification sync updates for all tier-3 tracker functions.

## Execution status
- Scenarios executed: 8
- Probe rows synthesized: 24
- Supports reason code: 23
- Counter-signal rows: 1
- Needs-review rows: 0

## Key outcomes
1. Volatility controls (`NOW`, `RAND`, `RANDBETWEEN`) showed recalc-driven value changes.
2. Grid/reference-sensitive set stayed stable where expected (`ROW`, `COLUMN`, `ROWS`, `COLUMNS`, `ADDRESS`, `AREAS`, `FORMULATEXT`, `SHEET`, `SHEETS`) and changed where dependency edits should propagate (`INDEX`).
3. Format-visible functions (`TEXT`, `DOLLAR`, `FIXED`) produced stable text-form outputs in the captured locale.
4. Type/coercion set (`VALUE`, `TYPE`, `N`, `T`, `VALUETOTEXT`) matched expected literal outcomes in the scenario matrix.
5. `SUMIF` produced a mixed signal: related-edit change observed, but unrelated-edit+recalc remained stable; tier-3 classification is flagged for reason-code review.

## Artifacts
- `ECS-EB-040_reason_code_verification_probe_wave1.csv`
- `ECS-EB-041_classification_evidence_sync_wave1.csv`
- `scenario_manifest_wave1.csv` (status updated to `completed`)
- `evidence/<scenario_id>/*`