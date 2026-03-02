param(
    [switch]$ResetFixtures,
    [switch]$PreserveEvidence,
    [int]$TimeoutSec = 480
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..')).Path
Set-Location $repoRoot

$baseRel = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2'
$fixtureRoot = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/fixtures/formula_parse_pass2'
$evidenceRoot = "$baseRel/evidence"

& powershell -NoProfile -ExecutionPolicy Bypass -File "$baseRel/seed_pass2_assets.ps1"
if ($LASTEXITCODE -ne 0) {
    throw "seed_pass2_assets.ps1 failed with exit code $LASTEXITCODE"
}

if ($ResetFixtures -and (Test-Path $fixtureRoot)) {
    Remove-Item -Recurse -Force $fixtureRoot
}
if ((-not $PreserveEvidence) -and (Test-Path $evidenceRoot)) {
    Remove-Item -Recurse -Force $evidenceRoot
}
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& tools/excel-probe/excel-probe.cmd run-manifest `
    --manifest "$baseRel/scenario_manifest_pass2.csv" `
    --base-dir "$baseRel" `
    --out-root "$evidenceRoot" `
    --visible false `
    --timeout-sec $TimeoutSec
if ($LASTEXITCODE -ne 0) {
    throw "formula_parse_pass2 run-manifest failed with exit code $LASTEXITCODE"
}

& powershell -NoProfile -ExecutionPolicy Bypass -File "$baseRel/build_pass2_outputs.ps1"
if ($LASTEXITCODE -ne 0) {
    throw "build_pass2_outputs.ps1 failed with exit code $LASTEXITCODE"
}

Write-Host "formula_parse_pass2 execution complete."
