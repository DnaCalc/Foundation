# ECS-EB-017 Tier-5 Platform Caveat Report (Wave 1)

## Scope
Consolidated tier-5 caveat view using current platform availability matrix plus executed wave evidence (`RTD`, `NOW`, `TODAY`).

## Function status table
| Function | Windows | Mac | Web | Last probe UTC | Notes |
|---|---|---|---|---|---|
| INDIRECT | unprobed | unprobed | unprobed |  | ECS-EB-037 merge updated source applies-to at 2026-02-28T19:35:53Z |
| NOW | observed_supported | unprobed | unprobed | 2026-02-28T19:36:30Z | ECS-EB-037 merge updated source applies-to at 2026-02-28T19:35:53Z | ECS-EB-016 date-system probe completed. |
| OFFSET | unprobed | unprobed | unprobed |  | ECS-EB-037 merge updated source applies-to at 2026-02-28T19:35:53Z |
| RTD | observed_supported | unprobed | unprobed | 2026-02-28T19:36:30Z | Seeded from platform_probe_selected_functions.csv | ECS-EB-037 merge updated source applies-to at 2026-02-28T19:35:53Z | ECS-EB-015 RTD lifecycle probe completed. |
| TODAY | observed_supported | unprobed | unprobed | 2026-02-28T19:36:30Z | ECS-EB-037 merge updated source applies-to at 2026-02-28T19:35:53Z | ECS-EB-016 date-system probe completed. |

## Evidence references
- `../rtd_wave1/RTD_WAVE1_EXECUTION_REPORT.md`
- `../date_system_wave1/DATE_SYSTEM_WAVE1_EXECUTION_REPORT.md`
- `../platform_availability/function_availability_matrix.csv`

## Caveat summary
1. Windows has empirical probe evidence for `RTD`, `NOW`, and `TODAY` from prior waves.
2. `INDIRECT` and `OFFSET` remain primarily source-anchored in this wave and should be extended in cross-platform lanes.
3. Mac/Web statuses remain source-driven in this run and require dedicated platform execution lanes for parity closure.
