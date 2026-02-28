$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/date_system_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/date_system_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/date_system_wave1/evidence --visible false --timeout-sec 240
if ($LASTEXITCODE -ne 0) { throw "Date-system wave1 run-manifest failed with exit code $LASTEXITCODE" }
