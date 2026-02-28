$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$runner = "research/tools/excel-probe/excel-probe.cmd"
$manifest = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/volatility_wave2/scenario_manifest_wave2.csv"
$baseDir = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/volatility_wave2"
$outRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/volatility_wave2/evidence"

& $runner run-manifest --manifest $manifest --base-dir $baseDir --out-root $outRoot --visible false --timeout-sec 180
if ($LASTEXITCODE -ne 0) { throw "Wave2 run-manifest failed with exit code $LASTEXITCODE" }
