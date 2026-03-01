$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureDirs = @(
  'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/tier45_wave1',
  'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/coercion_wave1',
  'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/cf_wave1',
  'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/table_wave1',
  'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/reopen_wave1'
)
foreach ($dir in $fixtureDirs) {
  if (Test-Path $dir) { Remove-Item -Recurse -Force $dir }
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$evidenceRoot = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/evidence'
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/scenario_manifest_wave2.csv --base-dir . --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/evidence --visible false --timeout-sec 900
if ($LASTEXITCODE -ne 0) { throw "unresolved_wave2 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/build_wave2_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "unresolved_wave2 output synthesis failed with exit code $LASTEXITCODE" }
