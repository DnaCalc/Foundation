param()
$ErrorActionPreference='Stop'
$base = Resolve-Path (Join-Path $PSScriptRoot '..')
$manifest = Join-Path $base 'outputs\scenario_manifest.csv'
$outRoot = Join-Path $base 'outputs\evidence'
$baseDir = Join-Path $base 'outputs'

if (-not (Test-Path $manifest)) { throw "manifest not found: $manifest" }

& tools\excel-probe\excel-probe.cmd run-manifest --manifest "$manifest" --base-dir "$baseDir" --out-root "$outRoot" --visible false --timeout-sec 600
if ($LASTEXITCODE -ne 0) { throw "excel-probe run-manifest failed with exit code $LASTEXITCODE" }

pwsh -File (Join-Path $base 'outputs\build_targeted_outputs.ps1')
if ($LASTEXITCODE -ne 0) { throw "build_targeted_outputs.ps1 failed with exit code $LASTEXITCODE" }

Write-Host 'targeted empirical run complete'
