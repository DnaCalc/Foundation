# Pass 26 - Full Interesting-Function Platform Matrix Seed Expansion

## Purpose
Expand platform availability coverage from selected-function seed to all interesting functions.

Primary backlog link:
- `ECS-BL-10` (platform/channel/build matrix)

## Artifacts produced
- `platform_availability_source_matrix_full_interest_seed.csv`

## What was done
1. Preserved all existing extracted applies-to rows from `platform_availability_source_matrix_seed.csv`.
2. Added queued source rows for every interesting function missing applies-to extraction.
3. Marked missing extraction rows with `applies_to_raw=__PENDING_CAPTURE__` and explicit crawl note.

## Coverage snapshot
- Interesting functions represented: `71/71`
- Existing expanded applies-to rows carried forward: `53`
- Queued function rows pending applies-to extraction: `65`

## Interpretation
This is a full-coverage queue artifact, not a completed applies-to extraction. It removes blind spots by ensuring every interesting function is explicitly represented.

## Status decision
Track A platform pipeline now has full interesting-function coverage and a concrete extraction queue for `ECS-EB-037`.
