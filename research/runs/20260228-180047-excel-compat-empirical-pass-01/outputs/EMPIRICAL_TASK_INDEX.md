# Empirical Task Index

## Purpose
This index defines the empirical work program for Excel compatibility evidence gathering.
It is split between:
- known-known validation tasks (areas already described with reasonable confidence), and
- backlog-linked tasks (areas previously marked as open/depth-expansion work).

## Inputs and traceability
- Context snapshot: `../inputs/context_snapshot.md`
- Parent run backlog: `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/17_follow_up_execution_backlog.md`
- Parent run master guide: `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md`
- Parent Track A execution docs: `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/18_trackA_doc_search_execution_pass.md` through `32_trackA_trackB_interleaving_cf_wave1.md`

## Task catalogs
- `01_known_known_empirical_tasks.md`
- `02_backlog_linked_empirical_tasks.md`
- `03_execution_progress_status.md`

Current task counts:
- Known-known empirical tasks: 48 (`ECS-EK-001..048`)
- Backlog-linked empirical tasks: 48 (`ECS-EB-001..048`)

## Execution ordering
1. Bootstrapping
   - Establish runner/evidence contract tasks from backlog-linked group `ECS-EB-001..ECS-EB-004`.
2. Known-known conformance baseline
   - Execute known-known tasks by domain order: Formula -> Functions -> Types/Coercion -> Tables -> Formatting -> Version/Platform -> Evidence integrity.
3. Backlog depth passes
   - Execute backlog-linked tasks grouped by `ECS-BL-*` mapping from Pass 17.
4. Continuous refresh loop
   - Re-run drift-sensitive tasks (function availability, source recrawl, platform probes) on a dated cadence.

## Task ID scheme
- `ECS-EK-###`: empirical tasks for known-known topics.
- `ECS-EB-###`: empirical tasks derived from follow-up backlog items.

## Evidence artifact contract (minimum per executed task)
- Task execution manifest (`task_id`, runner version, platform/build, timestamp).
- Probe workbook or scenario fixture reference.
- Raw capture output.
- Normalized result output.
- Divergence note (if any) with reproducible rerun command.

## Current execution note
Backlog bootstrapping tasks `ECS-EB-001..004` have initial v0 artifacts under `outputs/artifacts/`.
High-signal pilot tasks `ECS-EB-010/011/014/023` have executed wave-1 artifacts under `outputs/pilot_wave1/` (see `PILOT_WAVE1_EXECUTION_REPORT.md`).
Platform/version task `ECS-EB-037` has completed source extraction/merge artifacts under `outputs/platform_availability/` (`source_matrix_full_interest_enriched.csv`, `function_availability_matrix.csv`, `ECS-EB-037_EXECUTION_REPORT.md`), including merged Windows probe outcomes for `RTD`, `NOW`, and `TODAY`; starter artifacts for `ECS-EB-038/046` remain in the same directory.
Volatility context task `ECS-EB-012` and reason-code mapping task `ECS-EB-013` have executed wave-2 artifacts under `outputs/volatility_wave2/`.
Reason-code hardening tasks `ECS-EB-040` and `ECS-EB-041` have executed wave-1 artifacts under `outputs/reason_code_wave1/` (`ECS-EB-040_reason_code_verification_probe_wave1.csv`, `ECS-EB-041_classification_evidence_sync_wave1.csv`, `WAVE1_EXECUTION_REPORT.md`) with tracker sync applied to tier-3 rows.
Formula-language tasks `ECS-EB-028`, `ECS-EB-029`, and `ECS-EB-030` have executed wave-1 artifacts under `outputs/formula_parse_wave1/` with full scenario evidence bundles and a triaged ambiguity mismatch (`=SUM(A1,,B1)` accepted).
Coercion tasks `ECS-EB-024`, `ECS-EB-025`, `ECS-EB-026`, and `ECS-EB-027` have executed wave-1 artifacts under `outputs/coercion_wave1/` with full scenario evidence bundles and three explicit expectation mismatches retained for triage (`SUM/AVERAGE/COUNT` range-text handling cases).
Conditional-format tasks `ECS-EB-031`, `ECS-EB-032`, and `ECS-EB-033` have executed wave-1 artifacts under `outputs/cf_wave1/` with full scenario evidence bundles and two explicit spill-related display-color mismatches retained for triage (`C3/C4` conditional-format expectation under spill).
