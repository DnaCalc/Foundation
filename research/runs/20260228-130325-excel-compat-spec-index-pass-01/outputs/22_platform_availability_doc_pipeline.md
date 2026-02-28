# Pass 22 - Platform Availability Documentation Pipeline

## Purpose
Define a source-first, machine-readable documentation pipeline for platform/channel/build availability tracking before full empirical parity closure.

Primary backlog link:
- `ECS-BL-10` in `17_follow_up_execution_backlog.md`

## Input artifacts
- `platform_probe_selected_functions.csv`
- `platform_notes.md`
- `source_list.csv`
- `platform_availability_source_matrix_seed.csv` (generated in this pass)
- `platform_availability_source_matrix_full_interest_seed.csv` (added in pass 26)

## Pipeline stages
1. Source capture:
   - Collect function-page "applies to" metadata with capture timestamp.
2. Normalization:
   - Expand pipe-delimited applies-to values to one row per function-platform token.
3. Evidence-state tagging:
   - Mark rows as `source_only` until empirical probes exist.
4. Probe merge:
   - Attach empirical run IDs and outcome fields after Track B execution.
5. Drift monitoring:
   - Re-capture selected pages periodically and diff by function/token.

## Row contract (source matrix seed)
Current row fields:
- `function_name`
- `source_title`
- `source_url`
- `applies_to_raw`
- `source_capture_utc`
- `evidence_type` (`source_only` initially)
- `probe_status` (`pending` initially)
- `note`

## Important interpretation rules
1. "Applies to" is availability metadata, not behavior-parity proof.
2. External dependency functions (RTD/CUBE/etc.) need capability-aware empirical interpretation.
3. Platform names should remain raw in source capture, with optional derived normalization columns added later.

## Required empirical linkage
Use this pipeline as Track A input for:
- `ECS-EB-037` availability crawler/probe merger workflow,
- `ECS-EB-038` build metadata capture integration,
- `ECS-EB-039` parity regression log generation,
- `ECS-EB-046` capability-profile annotation of untestable rows.

## Status decision
Platform/channel/build tracking now has a concrete documentation pipeline and seed matrix ready for empirical merge.
