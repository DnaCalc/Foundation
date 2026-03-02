# Empirical Findings Index

Promoted findings are selective, high-value observations from empirical runs.

## Registry Summary
- Total findings: 12
- Status counts:
  - provisional: 8
  - confirmed: 4
  - superseded: 0
  - deprecated: 0

## Entries
| finding_id | status | claim | source_run_id | source_task_or_scenario_id | updated_utc |
| --- | --- | --- | --- | --- | --- |
| EMP-0001 | provisional | `=SUM(A1,,B1)` accepted/evaluated (ambiguity counter-signal) | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-030 / SCN-EB030-AMBIG-DOUBLE-COMMA | 2026-03-01T13:56:08.9097064Z |
| EMP-0002 | provisional | `=A1.Price` parse-accepted with field-related error | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-030 / SCN-EB030-DOTFIELD-PROBE | 2026-03-01T13:56:08.9097064Z |
| EMP-0003 | provisional | SUM/AVERAGE/COUNT mixed text range coercion counter-signal | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-025 / SCN-EB025-AGG-COERCION | 2026-03-01T13:56:08.9097064Z |
| EMP-0004 | provisional | Conditional-format spill target color mismatch | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-033 / SCN-EB033-CF-TABLE-SPILL | 2026-03-01T13:56:08.9097064Z |
| EMP-0005 | provisional | Table structured-ref spill growth mismatch | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-034 / SCN-EB034-STRUCTREF-SPILL | 2026-03-01T13:56:08.9097064Z |
| EMP-0006 | confirmed | RTD lifecycle baseline behaviors confirmed | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-015 / SCN-EB015-* | 2026-03-01T13:56:08.9097064Z |
| EMP-0007 | confirmed | Date-system toggle and cross-workbook copy baseline confirmed | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-016 / SCN-EB016-* | 2026-03-01T13:56:08.9097064Z |
| EMP-0008 | confirmed | Volatility control behaviors (RAND vs SUM) confirmed | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-012 / SCN-EB012-* | 2026-03-01T13:56:08.9097064Z |
| EMP-0009 | provisional | SUMIF mixed reason-code signal retained | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-040 / SCN-EB040-SUMIF-UNRELATED-EDIT | 2026-03-01T13:56:08.9097064Z |
| EMP-0010 | provisional | Dynamic-array mixed-type tier4/5 counter-signals retained | 20260228-180047-excel-compat-empirical-pass-01 | ECS-EB-018/ECS-EB-019 unresolved replay | 2026-03-01T13:56:08.9097064Z |
| EMP-0011 | provisional | External-reference open-state behavior captured (`open => value`, `closed/missing => #REF!`) | 20260302-100724-excel-nonfunction-closure-pass-01 | ECS-EB-036 / NFCP1-LINK-* | 2026-03-02T08:16:35.4605542Z |
| EMP-0012 | confirmed | Direct merge/unmerge state capture confirmed (`merge_cells`, `merge_area_address`) | 20260302-100724-excel-nonfunction-closure-pass-01 | ECS-EK-040 / NFCP1-MERGE-UNMERGE-DIRECT | 2026-03-02T08:17:07.8305067Z |
