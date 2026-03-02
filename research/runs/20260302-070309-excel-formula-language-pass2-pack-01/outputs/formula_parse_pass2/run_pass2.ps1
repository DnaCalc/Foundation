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
$fixtureRootAbs = Join-Path $repoRoot $fixtureRoot
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

# Prepare support workbook for external-reference scenarios.
$supportWorkbook = Join-Path $fixtureRootAbs 'Book2.xlsx'
$excel = $null
$wb = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $wb = $excel.Workbooks.Add()
    $ws = $wb.Worksheets.Item(1)
    $ws.Name = 'Sheet1'
    $ws.Range('A1').Value2 = 77
    $wb.SaveAs($supportWorkbook, 51)
    $wb.Close($false)
    $wb = $null
}
finally {
    if ($wb) { try { $wb.Close($false) } catch {} }
    if ($excel) { try { $excel.Quit() } catch {} }
}

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
