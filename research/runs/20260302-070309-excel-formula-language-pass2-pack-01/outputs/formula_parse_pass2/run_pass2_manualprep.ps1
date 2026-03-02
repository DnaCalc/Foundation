param(
    [int]$TimeoutSec = 480
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..')).Path
Set-Location $repoRoot

$baseRel = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2'
$fixtureRoot = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/fixtures/formula_parse_pass2'
$baseAbs = Join-Path $repoRoot $baseRel
$fixtureRootAbs = Join-Path $repoRoot $fixtureRoot
$evidenceRootAbs = Join-Path $baseAbs 'evidence'
$evidenceRoot = "$baseRel/evidence"
$manualManifest = "$baseRel/scenario_manifest_pass2_manualprep.csv"
$manualReport = "$baseRel/MANUAL_PREP_PASS2B_REPORT.md"

$targetScenarioIds = @('FMLP2-008', 'FMLP2-009', 'FMLP2-019', 'FMLP2-021')

& powershell -NoProfile -ExecutionPolicy Bypass -File "$baseRel/seed_pass2_assets.ps1"
if ($LASTEXITCODE -ne 0) {
    throw "seed_pass2_assets.ps1 failed with exit code $LASTEXITCODE"
}

foreach ($sid in $targetScenarioIds) {
    $fixturePath = Join-Path $fixtureRootAbs "$sid.xlsx"
    $evidenceDir = Join-Path $evidenceRootAbs $sid
    if (Test-Path $fixturePath) { Remove-Item -Force $fixturePath }
    if (Test-Path $evidenceDir) { Remove-Item -Recurse -Force $evidenceDir }
}

# Manual-prep automation 1/2: name shadowing scenario (FMLP2-019).
# Pre-create fixture with a sheet-local name (Sheet1!MyName) that points to B1.
$excel = $null
$wb = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false

    $fixture019 = Join-Path $fixtureRootAbs 'FMLP2-019.xlsx'
    New-Item -ItemType Directory -Force -Path $fixtureRootAbs | Out-Null
    $wb = $excel.Workbooks.Add()
    $ws = $wb.Worksheets.Item(1)
    $ws.Name = 'Sheet1'
    $wb.Names.Add('Sheet1!MyName', '=Sheet1!$B$1') | Out-Null
    $wb.SaveAs($fixture019, 51)
    $wb.Close($false)
    $wb = $null

    # Manual-prep automation 2/2: external workbook scenario (FMLP2-021).
    # Create Book2.xlsx adjacent to target fixture so relative external reference can resolve.
    $book2 = Join-Path $fixtureRootAbs 'Book2.xlsx'
    $wb = $excel.Workbooks.Add()
    $ws2 = $wb.Worksheets.Item(1)
    $ws2.Name = 'Sheet1'
    $ws2.Range('A1').Value2 = 77
    $wb.SaveAs($book2, 51)
    $wb.Close($false)
    $wb = $null
}
finally {
    if ($wb) { try { $wb.Close($false) } catch {} }
    if ($excel) { try { $excel.Quit() } catch {} }
}

$allManifest = Import-Csv "$baseRel/scenario_manifest_pass2.csv"
$manualRows = @($allManifest | Where-Object { $_.scenario_id -in $targetScenarioIds })
$manualRows | Export-Csv -Path $manualManifest -NoTypeInformation -Encoding UTF8

& tools/excel-probe/excel-probe.cmd run-manifest `
    --manifest "$manualManifest" `
    --base-dir "$baseRel" `
    --out-root "$evidenceRootAbs" `
    --visible false `
    --timeout-sec $TimeoutSec
if ($LASTEXITCODE -ne 0) {
    throw "manual-prep pass2b run-manifest failed with exit code $LASTEXITCODE"
}

& powershell -NoProfile -ExecutionPolicy Bypass -File "$baseRel/build_pass2_outputs.ps1"
if ($LASTEXITCODE -ne 0) {
    throw "build_pass2_outputs.ps1 failed after manual-prep rerun with exit code $LASTEXITCODE"
}

$resultRows = Import-Csv "$baseRel/FORMULA_PARSE_PASS2_RESULTS.csv" |
    Where-Object { $_.scenario_id -in $targetScenarioIds } |
    Sort-Object scenario_id

$lines = @(
    '# Formula Parse Pass-2b Manual-Prep Rerun',
    '',
    "Target scenarios: $($targetScenarioIds -join ', ')",
    '',
    '## Automated prep applied',
    '1. `FMLP2-019`: injected sheet-local name `Sheet1!MyName -> Sheet1!$B$1` before rerun.',
    '2. `FMLP2-021`: created adjacent `Book2.xlsx` (`Sheet1!A1 = 77`) before rerun.',
    '',
    '## Linked-data limitation',
    '1. `FMLP2-008` and `FMLP2-009` still require manual linked-data conversion of `A1` for high-confidence semantic validation.',
    '2. This rerun captures current behavior with standard cell content and marks it as probe-only evidence.',
    '',
    '## Rerun outcomes'
)

foreach ($r in $resultRows) {
    $lines += ("- {0}: observed={1}, result_class={2}, display=`"{3}`"" -f $r.scenario_id, $r.observed_acceptance, $r.result_class, $r.final_display_text)
}

Set-Content -Path $manualReport -Value ($lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host 'manual-prep pass2b rerun complete.'
