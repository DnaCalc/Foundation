# Empirical Execution Log

This file is updated as targeted empirical batches complete.

## 2026-03-02 Execution
1. Scenario set seeded via:
   - `outputs/seed_targeted_assets.ps1`
   - manifest: `outputs/scenario_manifest.csv`
2. Batch execution command:
   - `pwsh -File outputs/run_targeted.ps1`
3. Runner:
   - `tools/excel-probe` (`dotnet_sdk_version=10.0.103` in run manifests)
4. Execution status:
   - `9/9` scenarios produced evidence bundles.
   - result summary: `outputs/TARGETED_EXECUTION_SUMMARY.md`
   - row-level extract: `outputs/TARGETED_RESULTS.csv`

## Scenario Outcomes
1. `NFCP1-FL010-DOUBLE-COMMA`: `=SUM(A1,,B1)` observed `5` (accepted/evaluated).
2. `NFCP1-FL011-DOT-FIELD`: `=A1.Price` observed `#FIELD!`; linked-data conversion op remained `allowed_error`.
3. `NFCP1-LINK-PRESENT-OPEN-UPD0`: external reference resolved to `77`.
4. `NFCP1-LINK-PRESENT-OPEN-UPD3`: external reference resolved to `77`.
5. `NFCP1-LINK-PRESENT-CLOSED`: external reference observed `#REF!`.
6. `NFCP1-LINK-MISSING`: external reference observed `#REF!`.
7. `NFCP1-CF-SPILL-TABLE`: `B3` retained formatted match; `C3/C4` remained unformatted (mismatch lane persisted).
8. `NFCP1-TBL-STRUCTREF-SPILL`: `D2` and `C4` matched; `E4` remained mismatch (`1` vs seeded `3` expectation lane).
9. `NFCP1-MERGE-UNMERGE-DIRECT`: merge/unmerge ops executed; merge-state capture fields populated and toggled as expected.

## Promoted Findings
1. `EMP-0011`: external-reference open-state policy baseline (open => value, closed/missing => `#REF!` in this build).
2. `EMP-0012`: direct merge/unmerge capture baseline using `merge_cells` and `merge_area_address`.
