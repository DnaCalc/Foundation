$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureRoot = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/known_known_wave1'
$evidenceRoot = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/evidence'
if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/evidence --visible false --timeout-sec 3600
if ($LASTEXITCODE -ne 0) { throw "known_known_wave1 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/build_wave1_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "known_known_wave1 output synthesis failed with exit code $LASTEXITCODE" }
