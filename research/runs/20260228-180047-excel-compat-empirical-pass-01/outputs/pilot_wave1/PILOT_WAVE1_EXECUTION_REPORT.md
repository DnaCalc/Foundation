# Pilot Wave 1 Execution Report

## Run summary
- Execution date (UTC): `2026-02-28`
- Runner: `excel-probe` C# runtime
- Scenario count: `14`
- Execution result: `14 succeeded`, `0 failed`
- Evidence location: `outputs/pilot_wave1/evidence/`
- Consolidated summary: `outputs/pilot_wave1/pilot_wave1_result_summary.csv`

## Deterministic assertion outcomes
Snapshot-assertable scenarios (`value_equals`):
1. `SCN-EB010-SUM-UNRELATED-EDIT`: `pass` (`60`)
2. `SCN-EB010-INDEX-REOPEN`: `pass` (`7`)
3. `SCN-EB011-SUM-RECALC`: `pass` (`6`)

## Manual-review scenarios (current runner limitation)
The remaining scenarios are marked `manual_review_required` because the v0 runner currently captures final state snapshots only, not per-operation intermediate snapshots.

Affected scenario groups:
1. Volatility delta checks (`NOW`, `RAND`, `OFFSET`, `INDIRECT`) requiring before/after event comparison.
2. Structural transition semantics where final state is captured but transition behavior still needs stepwise evidence.
3. Locale-targeted probes run under execution locale `en-ZA`, not under the target locales requested by scenario intent.

## Notable observed outcomes
1. `OFFSET` delete-column case (`SCN-EB014-OFFSET-DELETE-COL`) produced explicit `#REF!` with formula rewrite `=SUM(OFFSET(#REF!,0,0,1,1))`.
2. `OFFSET` insert-column case (`SCN-EB014-OFFSET-INSERT-COL`) observed rewrite to `=SUM(OFFSET(C1,0,0,1,1))`.
3. `VALUE("1,5")` and `DATEVALUE("01/02/2025")` both produced `#VALUE!` under locale `en-ZA`.
4. Many display-text captures are `########` due column-width rendering, while raw value/formula captures remain available.

## Artifacts updated from this run
1. `ECS-EB-010_recalc_event_matrix.csv` updated with observed final snapshots.
2. `ECS-EB-011_volatility_probe_results_wave1.csv` updated with captured final values and explicit `needs_stepwise_capture` statuses.
3. `ECS-EB-014_indirect_offset_structural_probe.csv` updated with observed final formula/value/display.
4. `locale_coercion_probe_wave1.csv` created with locale-caveat interpretation notes.
5. `scenario_manifest_wave1.csv` statuses set to `completed`.

## Follow-on work derived from pilot
1. Add per-operation step snapshot capture to the runner for volatility/transition assertions.
2. Add locale-controlled execution lane to run locale-sensitive scenarios under target locales.
3. Expand display-capture policy for formatting-sensitive probes to reduce `########` ambiguity.
