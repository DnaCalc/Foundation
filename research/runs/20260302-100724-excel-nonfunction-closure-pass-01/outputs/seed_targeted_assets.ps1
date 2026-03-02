param()
$ErrorActionPreference='Stop'
$base = Resolve-Path (Join-Path $PSScriptRoot '..')
$scenDir = Join-Path $base 'outputs\scenarios'
$fixtureDir = Join-Path $base 'fixtures'
New-Item -ItemType Directory -Force -Path $scenDir,$fixtureDir | Out-Null

function Copy-Scenario {
  param([string]$Source,[string]$TargetName)
  $obj = Get-Content -Raw $Source | ConvertFrom-Json -Depth 50
  $obj.scenario_id = $TargetName
  return $obj
}

$scenarios = @()

# Formula/link lanes from pass2
$srcP2 = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/outputs/formula_parse_pass2/scenarios'
$sFml001 = Copy-Scenario (Join-Path $srcP2 'FMLP2-001.json') 'NFCP1-FL010-DOUBLE-COMMA'
$scenarios += $sFml001

$sFml008 = Copy-Scenario (Join-Path $srcP2 'FMLP2-008.json') 'NFCP1-FL011-DOT-FIELD'
$scenarios += $sFml008

$sFml021 = Copy-Scenario (Join-Path $srcP2 'FMLP2-021.json') 'NFCP1-LINK-PRESENT-OPEN-UPD0'
$scenarios += $sFml021

$sFml022 = Copy-Scenario (Join-Path $srcP2 'FMLP2-022.json') 'NFCP1-LINK-MISSING'
$scenarios += $sFml022

# Variant: present workbook open with update_links=3
$sFml021u3 = Copy-Scenario (Join-Path $srcP2 'FMLP2-021.json') 'NFCP1-LINK-PRESENT-OPEN-UPD3'
$openOp = $sFml021u3.operations | Where-Object { $_.op -eq 'open_support_workbook' } | Select-Object -First 1
if ($null -ne $openOp) { $openOp.args.update_links = 3 }
$scenarios += $sFml021u3

# Variant: present workbook but do not pre-open support workbook
$sFml021closed = Copy-Scenario (Join-Path $srcP2 'FMLP2-021.json') 'NFCP1-LINK-PRESENT-CLOSED'
$sFml021closed.operations = @($sFml021closed.operations | Where-Object { $_.op -ne 'open_support_workbook' })
$scenarios += $sFml021closed

# CF/Table provisional lanes from wave1
$srcCf = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/scenarios/SCN-EB033-CF-TABLE-SPILL.json'
$srcTb = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/scenarios/SCN-EB034-STRUCTREF-SPILL.json'
$scenarios += Copy-Scenario $srcCf 'NFCP1-CF-SPILL-TABLE'
$scenarios += Copy-Scenario $srcTb 'NFCP1-TBL-STRUCTREF-SPILL'

# Direct merge/unmerge probe
$mergeObj = [ordered]@{
  scenario_id = 'NFCP1-MERGE-UNMERGE-DIRECT'
  task_id = 'ECS-EK-040'
  topic = 'formatting_merge_probe'
  priority = 'P1'
  platform_target = @('windows_desktop')
  inputs = [ordered]@{
    workbook_fixture = 'research/runs/20260302-100724-excel-nonfunction-closure-pass-01/fixtures/NFCP1-MERGE-UNMERGE-DIRECT.xlsx'
    sheet_setup = @([
      ordered]@{
        sheet='Sheet1';
        writes=@(
          [ordered]@{kind='value';address='A1';value='Hdr'},
          [ordered]@{kind='value';address='A2';value=1},
          [ordered]@{kind='value';address='B2';value=2},
          [ordered]@{kind='value';address='C2';value=3},
          [ordered]@{kind='value';address='D2';value=0},
          [ordered]@{kind='value';address='E2';value=0}
        )
      }
    )
  }
  operations = @(
    [ordered]@{op='set_calc_mode';target='workbook';args=[ordered]@{mode='automatic'}},
    [ordered]@{op='merge_cells';target='Sheet1!A2:B2';args=[ordered]@{across=$false}},
    [ordered]@{op='edit_cell';target='Sheet1!D2';args=[ordered]@{formula='=A2'}},
    [ordered]@{op='edit_cell';target='Sheet1!E2';args=[ordered]@{formula='=SEQUENCE(2,1,10,10)'}},
    [ordered]@{op='recalc';target='workbook'},
    [ordered]@{op='unmerge_cells';target='Sheet1!A2:B2'},
    [ordered]@{op='recalc';target='workbook'}
  )
  expectations = @(
    [ordered]@{assertion_id='ASSERT-NFCP1-MRG-A2';kind='manual_review';target='Sheet1!A2';expected=[ordered]@{question='Capture merge-state and post-unmerge value behavior.'};confidence='medium'},
    [ordered]@{assertion_id='ASSERT-NFCP1-MRG-B2';kind='manual_review';target='Sheet1!B2';expected=[ordered]@{question='Capture merge-state and post-unmerge value behavior.'};confidence='medium'},
    [ordered]@{assertion_id='ASSERT-NFCP1-MRG-E2';kind='manual_review';target='Sheet1!E2';expected=[ordered]@{question='Capture spill interaction near merged range before/after unmerge.'};confidence='medium'},
    [ordered]@{assertion_id='ASSERT-NFCP1-MRG-E3';kind='manual_review';target='Sheet1!E3';expected=[ordered]@{question='Capture spill continuation near merged range before/after unmerge.'};confidence='medium'}
  )
  capture = [ordered]@{
    raw_capture='raw_capture.json';
    normalized_capture='normalized_capture.json';
    capture_fields=@('value','formula','display_text','number_format','display_number_format','display_interior_color','display_font_color','display_font_bold','merge_cells','merge_area_address','calc_mode')
  }
  sources = @(
    '../../../../reference/conformance/excel-worksheet-engine/CONFORMANCE_REQUIREMENTS.csv',
    '../../../../reference/conformance/excel-worksheet-engine/model/EXCEL_CELL_CONCRETE_MODEL_OPEN_QUESTIONS.md'
  )
  notes = 'Direct merge/unmerge probe for formatting lane with nearby spill expression.'
}
$scenarios += [pscustomobject]$mergeObj

$manifestRows = @()
foreach ($s in $scenarios) {
  # Use fresh per-scenario fixtures in this run to avoid collisions with pre-existing tables or stale workbook state.
  if ($null -ne $s.inputs) {
    $s.inputs.workbook_fixture = ('research/runs/20260302-100724-excel-nonfunction-closure-pass-01/fixtures/' + $s.scenario_id + '-fresh.xlsx')
  }

  $scenarioFile = Join-Path $scenDir ($s.scenario_id + '.json')
  $json = $s | ConvertTo-Json -Depth 80
  Set-Content -Path $scenarioFile -Value $json

  $fixture=''
  if ($null -ne $s.inputs -and $null -ne $s.inputs.workbook_fixture) { $fixture = [string]$s.inputs.workbook_fixture }
  $manifestRows += [pscustomobject]@{
    scenario_id = $s.scenario_id
    task_id = $s.task_id
    priority = $s.priority
    domain = $s.topic
    fixture = $fixture
    scenario_file = 'scenarios/' + $s.scenario_id + '.json'
    status = 'planned'
    notes = $s.notes
  }
}
$manifestRows | Export-Csv -NoTypeInformation -Path (Join-Path $base 'outputs\scenario_manifest.csv')
Write-Host "Seeded $($manifestRows.Count) scenarios"
