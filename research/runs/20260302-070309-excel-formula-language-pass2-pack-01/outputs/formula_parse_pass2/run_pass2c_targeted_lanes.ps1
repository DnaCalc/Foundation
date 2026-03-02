param(
    [int]$TimeoutSec = 480
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..')).Path
Set-Location $repoRoot

$baseRel = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2'
$baseAbs = Join-Path $repoRoot $baseRel
$fixtureRootRel = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/fixtures/formula_parse_pass2'
$fixtureRootAbs = Join-Path $repoRoot $fixtureRootRel
$evidenceRootAbs = Join-Path $baseAbs 'evidence'
$targetManifest = Join-Path $baseAbs 'scenario_manifest_pass2_targeted_lanes.csv'
$targetReport = Join-Path $baseAbs 'TARGETED_PASS2C_LANES_REPORT.md'

$targetScenarioIds = @(
    'FMLP2-008', 'FMLP2-009', # linked-data lane
    'FMLP2-019', 'FMLP2-020', # name-resolution lane
    'FMLP2-021', 'FMLP2-022'  # external-reference lane
)

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

# Ensure support workbook for external-reference present scenario.
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

$allManifest = Import-Csv (Join-Path $baseAbs 'scenario_manifest_pass2.csv')
$targetRows = @($allManifest | Where-Object { $_.scenario_id -in $targetScenarioIds })
$targetRows | Export-Csv -Path $targetManifest -NoTypeInformation -Encoding UTF8

& tools/excel-probe/excel-probe.cmd run-manifest `
    --manifest "$targetManifest" `
    --base-dir "$baseAbs" `
    --out-root "$evidenceRootAbs" `
    --visible false `
    --timeout-sec $TimeoutSec
if ($LASTEXITCODE -ne 0) {
    throw "targeted-lanes run-manifest failed with exit code $LASTEXITCODE"
}

& powershell -NoProfile -ExecutionPolicy Bypass -File "$baseRel/build_pass2_outputs.ps1"
if ($LASTEXITCODE -ne 0) {
    throw "build_pass2_outputs.ps1 failed after targeted-lanes rerun with exit code $LASTEXITCODE"
}

$results = Import-Csv (Join-Path $baseAbs 'FORMULA_PARSE_PASS2_RESULTS.csv') |
    Where-Object { $_.scenario_id -in $targetScenarioIds } |
    Sort-Object scenario_id

$lines = @(
    '# Targeted Pass-2c Lanes Report',
    '',
    'Target scenarios:',
    "- $($targetScenarioIds -join ', ')",
    '',
    '## Outcome summary'
)

foreach ($row in $results) {
    $lines += ("- {0}: observed={1}, display=`"{2}`", linked_data_op={3}, support_wb_op={4}" -f `
        $row.scenario_id, $row.observed_acceptance, $row.final_display_text, $row.linked_data_operation_status, $row.support_workbook_operation_status)
}

$lines += ''
$lines += '## Notes'
$lines += '1. Linked-data conversion attempts are captured via `linked_data_operation_status` and may remain `allowed_error` where environment/service support is unavailable.'
$lines += '2. External-reference present lane depends on support workbook open behavior (`open_support_workbook`).'
$lines += '3. Name-resolution lane compares `=MyName` and `=Sheet1!MyName` against explicit workbook/sheet-scoped setup.'

Set-Content -Path $targetReport -Value ($lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host 'targeted pass-2c lanes rerun complete.'
