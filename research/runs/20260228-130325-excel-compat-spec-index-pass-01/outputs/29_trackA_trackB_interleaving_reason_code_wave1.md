# Pass 29 - Track A/B Interleaving: Tier-3 Reason-Code Wave 1

## Scope
Interleaved completion of:
- Track A: tier-3 source-bound classification records promoted to probe-linked records.
- Track B: `ECS-EB-040`/`ECS-EB-041` empirical wave for weak-evidence reason-code claims.

Primary references:
- `17_follow_up_execution_backlog.md` (`ECS-BL-11`)
- empirical run artifacts under `../../20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/`

## Evidence artifacts emitted
1. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/ECS-EB-040_reason_code_verification_probe_wave1.csv`
2. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/ECS-EB-041_classification_evidence_sync_wave1.csv`
3. `../../20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/WAVE1_EXECUTION_REPORT.md`

## Classification tracker changes
Updated artifact:
- `function_reason_code_evidence_tracker.csv`

Transition summary for tier-3 functions:
1. `evidence_probe_ids` now populated for all tier-3 rows.
2. `evidence_status` promoted from `source_bound` to:
   - `source_probe_bound` for 22 functions,
   - `source_probe_bound_with_counter_signal` for `SUMIF`.
3. `review_status` promoted from `triaged_source_bound` to:
   - `triaged_source_probe_bound` for 22 functions,
   - `needs_reason_code_review` for `SUMIF`.

## Key synthesis decision
`SUMIF` is now explicitly flagged for reason-code review because wave evidence is mixed:
1. Related-edit path changed as expected for dependency-sensitive behavior.
2. Unrelated-edit + recalc path stayed stable, counter-signaling the current `volatile_or_recalc_sensitive` tag as a standalone reason code.

This is now an explicit, auditable follow-up target rather than an implicit ambiguity.

## Status decision
Track A/B interleaving succeeded for `ECS-BL-11` wave-1 hardening: tier-3 classification records are no longer source-only and now carry probe-linked evidence with one explicitly triaged counter-signal case.
