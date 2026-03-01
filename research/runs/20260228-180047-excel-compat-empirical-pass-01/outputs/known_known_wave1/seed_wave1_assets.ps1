Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$scenarioDir = Join-Path $waveDir 'scenarios'
$fixtureRootRel = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/known_known_wave1'
$fixtureRootAbs = Join-Path $repoRoot $fixtureRootRel
New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path $fixtureRootAbs | Out-Null

$sourceFormula = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/10_formula_language_guide.md'
$sourceFunctions = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/11_function_catalog_guide.md'
$sourceTypes = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/12_value_types_guide.md'
$sourceTables = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/13_table_semantics_guide.md'
$sourceFormatting = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/14_formatting_guide.md'
$sourcePlatform = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/15_version_platform_guide.md'

function New-BaseScenario([string]$scenarioId, [string]$taskId, [string]$fixtureRel, [array]$writes, [array]$operations, [array]$targets, [array]$sources, [string]$notes) {
    $expectations = @()
    foreach ($target in $targets) {
        $expectations += [ordered]@{
            assertion_id = "ASSERT-$scenarioId-$($target -replace '[^A-Za-z0-9]+','_')"
            kind = 'manual_review'
            target = $target
            expected = [ordered]@{
                question = 'Capture observed worksheet behavior and compare against baseline expectation.'
            }
            confidence = 'medium'
        }
    }

    return [ordered]@{
        scenario_id = $scenarioId
        task_id = $taskId
        topic = 'known_known_wave1'
        priority = 'P1'
        platform_target = @('windows_desktop')
        inputs = [ordered]@{
            workbook_fixture = $fixtureRel
            sheet_setup = @(
                [ordered]@{
                    sheet = 'Sheet1'
                    writes = $writes
                }
            )
        }
        operations = $operations
        expectations = $expectations
        capture = [ordered]@{
            raw_capture = 'raw_capture.json'
            normalized_capture = 'normalized_capture.json'
            capture_fields = @('value','formula','display_text','number_format','calc_mode','display_number_format')
        }
        sources = $sources
        notes = $notes
    }
}

function Convert-ToColumnName([int]$columnIndex) {
    if ($columnIndex -lt 1) { throw "Invalid column index $columnIndex" }
    $n = $columnIndex
    $name = ''
    while ($n -gt 0) {
        $rem = ($n - 1) % 26
        $name = [char](65 + $rem) + $name
        $n = [math]::Floor(($n - 1) / 26)
    }
    return $name
}

function Get-CellAddress([int]$row, [int]$column) {
    return "$(Convert-ToColumnName $column)$row"
}

$scenarios = @()
$manifestRows = @()
$caseRows = @()

function Add-Scenario([hashtable]$record) {
    $script:scenarios += $record.scenario
    $script:manifestRows += [pscustomobject]@{
        scenario_id = $record.scenario.scenario_id
        task_id = $record.scenario.task_id
        priority = 'P1'
        domain = 'known_known'
        fixture = $record.scenario.inputs.workbook_fixture
        scenario_file = "scenarios/$($record.scenario.scenario_id).json"
        status = 'planned'
        notes = $record.notes
    }
    $script:caseRows += [pscustomobject]@{
        case_id = $record.case_id
        scenario_id = $record.scenario.scenario_id
        task_id = $record.scenario.task_id
        artifact_name = $record.artifact_name
        notes = $record.notes
    }
}

# ECS-EK-001 precedence baseline
$writes001 = @(
    [ordered]@{ kind='value'; address='A1'; value=2 },
    [ordered]@{ kind='value'; address='B1'; value=3 },
    [ordered]@{ kind='value'; address='C1'; value=4 }
)
$ops001 = @(
    [ordered]@{ op='set_calc_mode'; target='workbook'; args=[ordered]@{ mode='automatic' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D1'; args=[ordered]@{ formula='=A1+B1*C1' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D2'; args=[ordered]@{ formula='=(A1+B1)*C1' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D3'; args=[ordered]@{ formula='=-A1^B1' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario001 = New-BaseScenario -scenarioId 'SCN-EK001-PRECEDENCE' -taskId 'ECS-EK-001' -fixtureRel "$fixtureRootRel/SCN-EK001-PRECEDENCE.xlsx" -writes $writes001 -operations $ops001 -targets @('Sheet1!D1','Sheet1!D2','Sheet1!D3') -sources @($sourceFormula) -notes 'Operator precedence baseline.'
Add-Scenario -record @{ case_id='KKW1-001'; scenario=$scenario001; artifact_name='precedence_probe_results.json'; notes='Operator precedence baseline.' }

# ECS-EK-003 A1 rewrite/copy baseline
$writes003 = @(
    [ordered]@{ kind='value'; address='A1'; value=10 },
    [ordered]@{ kind='value'; address='A2'; value=20 },
    [ordered]@{ kind='value'; address='A3'; value=30 },
    [ordered]@{ kind='value'; address='B1'; value=1 },
    [ordered]@{ kind='value'; address='B2'; value=2 },
    [ordered]@{ kind='value'; address='B3'; value=3 }
)
$ops003 = @(
    [ordered]@{ op='set_calc_mode'; target='workbook'; args=[ordered]@{ mode='automatic' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!C1'; args=[ordered]@{ formula='=A1+$B$1' } },
    [ordered]@{ op='copy_paste'; target='workbook'; args=[ordered]@{ source='Sheet1!C1'; target='Sheet1!C2' } },
    [ordered]@{ op='copy_paste'; target='workbook'; args=[ordered]@{ source='Sheet1!C1'; target='Sheet1!D1' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario003 = New-BaseScenario -scenarioId 'SCN-EK003-A1-COPY' -taskId 'ECS-EK-003' -fixtureRel "$fixtureRootRel/SCN-EK003-A1-COPY.xlsx" -writes $writes003 -operations $ops003 -targets @('Sheet1!C1','Sheet1!C2','Sheet1!D1') -sources @($sourceFormula) -notes 'A1 relative/absolute reference rewrite probe via copy.'
Add-Scenario -record @{ case_id='KKW1-002'; scenario=$scenario003; artifact_name='a1_rewrite_observations.json'; notes='A1 rewrite/copy baseline.' }

# ECS-EK-005 name resolution baseline
$writes005 = @(
    [ordered]@{ kind='value'; address='A1'; value=5 },
    [ordered]@{ kind='value'; address='A2'; value=7 },
    [ordered]@{ kind='name'; address='A1'; value=[ordered]@{ name='MyNums'; refers_to='=Sheet1!$A$1:$A$2' } }
)
$ops005 = @(
    [ordered]@{ op='set_calc_mode'; target='workbook'; args=[ordered]@{ mode='automatic' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=SUM(MyNums)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario005 = New-BaseScenario -scenarioId 'SCN-EK005-NAME-RESOLUTION' -taskId 'ECS-EK-005' -fixtureRel "$fixtureRootRel/SCN-EK005-NAME-RESOLUTION.xlsx" -writes $writes005 -operations $ops005 -targets @('Sheet1!B1') -sources @($sourceFormula) -notes 'Workbook name resolution baseline.'
Add-Scenario -record @{ case_id='KKW1-003'; scenario=$scenario005; artifact_name='name_resolution_probe.json'; notes='Workbook name resolution baseline.' }

# ECS-EK-009 spill-block baseline
$writes009 = @(
    [ordered]@{ kind='value'; address='A2'; value=99 }
)
$ops009 = @(
    [ordered]@{ op='set_calc_mode'; target='workbook'; args=[ordered]@{ mode='automatic' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!A1'; args=[ordered]@{ formula='=SEQUENCE(3,1,1,1)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario009 = New-BaseScenario -scenarioId 'SCN-EK009-SPILL-BLOCK' -taskId 'ECS-EK-009' -fixtureRel "$fixtureRootRel/SCN-EK009-SPILL-BLOCK.xlsx" -writes $writes009 -operations $ops009 -targets @('Sheet1!A1','Sheet1!A2') -sources @($sourceFormula,$sourceFormatting) -notes 'Spill block baseline with occupied downstream cell.'
Add-Scenario -record @{ case_id='KKW1-004'; scenario=$scenario009; artifact_name='spill_block_baseline_probe.json'; notes='Spill block baseline.' }

# ECS-EK-011 function recognition sweep (500 functions)
$functionCatalogPath = Join-Path $repoRoot 'research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_catalog_full.csv'
$functions = Import-Csv -Path $functionCatalogPath | Select-Object -ExpandProperty function_name
$writes011 = @(
    [ordered]@{ kind='value'; address='A1'; value=1 },
    [ordered]@{ kind='value'; address='A2'; value=2 },
    [ordered]@{ kind='value'; address='A3'; value=3 },
    [ordered]@{ kind='value'; address='A4'; value='txt' }
)
$ops011 = @(
    [ordered]@{ op='set_calc_mode'; target='workbook'; args=[ordered]@{ mode='automatic' } }
)
$targets011 = @()
$functionIndexRows = @()
$row = 1
$col = 2
$maxRow = 40
foreach ($fn in $functions) {
    $addr = Get-CellAddress -row $row -column $col
    $target = "Sheet1!$addr"
    $ops011 += [ordered]@{ op='edit_cell'; target=$target; args=[ordered]@{ formula="=$fn(1)"; allow_error=$true } }
    $targets011 += $target
    $functionIndexRows += [pscustomobject]@{
        function_name = $fn
        target = $target
    }
    $row++
    if ($row -gt $maxRow) {
        $row = 1
        $col++
    }
}
$ops011 += [ordered]@{ op='recalc'; target='workbook' }
$scenario011 = New-BaseScenario -scenarioId 'SCN-EK011-FUNCTION-RECOGNITION' -taskId 'ECS-EK-011' -fixtureRel "$fixtureRootRel/SCN-EK011-FUNCTION-RECOGNITION.xlsx" -writes $writes011 -operations $ops011 -targets $targets011 -sources @($sourceFunctions,$sourcePlatform) -notes '500-function parse/recognition sweep using generic single-arg invocation.'
Add-Scenario -record @{ case_id='KKW1-005'; scenario=$scenario011; artifact_name='function_recognition_matrix.csv'; notes='500-function recognition sweep.' }

# ECS-EK-012 tier1 math/stat baseline
$writes012 = @(
    [ordered]@{ kind='value'; address='A1'; value=0.5 },
    [ordered]@{ kind='value'; address='A2'; value=9 },
    [ordered]@{ kind='value'; address='A3'; value=2 },
    [ordered]@{ kind='value'; address='A4'; value=8 }
)
$ops012 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=SIN(A1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=SQRT(A2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=SUM(A1:A4)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B4'; args=[ordered]@{ formula='=AVERAGE(A1:A4)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario012 = New-BaseScenario -scenarioId 'SCN-EK012-TIER1-MATHSTAT' -taskId 'ECS-EK-012' -fixtureRel "$fixtureRootRel/SCN-EK012-TIER1-MATHSTAT.xlsx" -writes $writes012 -operations $ops012 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3','Sheet1!B4') -sources @($sourceFunctions) -notes 'Tier-1 math/stat baseline sample.'
Add-Scenario -record @{ case_id='KKW1-006'; scenario=$scenario012; artifact_name='tier1_math_stat_smoke.json'; notes='Tier-1 math/stat baseline.' }

# ECS-EK-013 tier1 text/logical baseline
$writes013 = @(
    [ordered]@{ kind='value'; address='A1'; value='Alpha' },
    [ordered]@{ kind='value'; address='A2'; value='Beta' },
    [ordered]@{ kind='value'; address='B1'; value=1 },
    [ordered]@{ kind='value'; address='B2'; value=0 }
)
$ops013 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!C1'; args=[ordered]@{ formula='=LEFT(A1,2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!C2'; args=[ordered]@{ formula='=RIGHT(A2,2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!C3'; args=[ordered]@{ formula='=IF(B1>B2,"yes","no")' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!C4'; args=[ordered]@{ formula='=AND(B1=1,B2=0)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario013 = New-BaseScenario -scenarioId 'SCN-EK013-TIER1-TEXTLOGIC' -taskId 'ECS-EK-013' -fixtureRel "$fixtureRootRel/SCN-EK013-TIER1-TEXTLOGIC.xlsx" -writes $writes013 -operations $ops013 -targets @('Sheet1!C1','Sheet1!C2','Sheet1!C3','Sheet1!C4') -sources @($sourceFunctions) -notes 'Tier-1 text/logical baseline sample.'
Add-Scenario -record @{ case_id='KKW1-007'; scenario=$scenario013; artifact_name='tier1_text_logical_smoke.json'; notes='Tier-1 text/logical baseline.' }

# ECS-EK-014 lookup baseline
$writes014 = @(
    [ordered]@{ kind='value'; address='A1'; value='k1' },
    [ordered]@{ kind='value'; address='A2'; value='k2' },
    [ordered]@{ kind='value'; address='A3'; value='k3' },
    [ordered]@{ kind='value'; address='B1'; value=10 },
    [ordered]@{ kind='value'; address='B2'; value=20 },
    [ordered]@{ kind='value'; address='B3'; value=30 }
)
$ops014 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!D1'; args=[ordered]@{ formula='=INDEX(B1:B3,MATCH("k2",A1:A3,0))' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D2'; args=[ordered]@{ formula='=XLOOKUP("k3",A1:A3,B1:B3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D3'; args=[ordered]@{ formula='=XMATCH("k1",A1:A3,0)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D4'; args=[ordered]@{ formula='=VLOOKUP("k2",A1:B3,2,FALSE)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario014 = New-BaseScenario -scenarioId 'SCN-EK014-LOOKUP-BASELINE' -taskId 'ECS-EK-014' -fixtureRel "$fixtureRootRel/SCN-EK014-LOOKUP-BASELINE.xlsx" -writes $writes014 -operations $ops014 -targets @('Sheet1!D1','Sheet1!D2','Sheet1!D3','Sheet1!D4') -sources @($sourceFunctions) -notes 'Lookup/reference baseline sample.'
Add-Scenario -record @{ case_id='KKW1-008'; scenario=$scenario014; artifact_name='lookup_baseline_probe.json'; notes='Lookup/reference baseline.' }

# ECS-EK-015 aggregate baseline
$writes015 = @(
    [ordered]@{ kind='value'; address='A1'; value=1 },
    [ordered]@{ kind='value'; address='A2'; value=2 },
    [ordered]@{ kind='value'; address='A3'; value=3 },
    [ordered]@{ kind='value'; address='B1'; value=4 },
    [ordered]@{ kind='value'; address='B2'; value=5 },
    [ordered]@{ kind='value'; address='B3'; value=6 }
)
$ops015 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!D1'; args=[ordered]@{ formula='=SUM(A1:B3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D2'; args=[ordered]@{ formula='=COUNTA(A1:B3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D3'; args=[ordered]@{ formula='=COUNT(A1:B3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!D4'; args=[ordered]@{ formula='=SUMPRODUCT(A1:A3,B1:B3)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario015 = New-BaseScenario -scenarioId 'SCN-EK015-AGGREGATE-BASELINE' -taskId 'ECS-EK-015' -fixtureRel "$fixtureRootRel/SCN-EK015-AGGREGATE-BASELINE.xlsx" -writes $writes015 -operations $ops015 -targets @('Sheet1!D1','Sheet1!D2','Sheet1!D3','Sheet1!D4') -sources @($sourceFunctions) -notes 'Aggregate baseline sample.'
Add-Scenario -record @{ case_id='KKW1-009'; scenario=$scenario015; artifact_name='aggregate_baseline_probe.json'; notes='Aggregate baseline.' }

# ECS-EK-016 error-handling baseline
$writes016 = @(
    [ordered]@{ kind='value'; address='A1'; value=0 },
    [ordered]@{ kind='value'; address='A2'; value='x' }
)
$ops016 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=1/A1' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=IFERROR(1/A1,99)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=IFNA(VLOOKUP("k9",A1:B1,2,FALSE),777)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B4'; args=[ordered]@{ formula='=ERROR.TYPE(B1)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario016 = New-BaseScenario -scenarioId 'SCN-EK016-ERROR-HANDLING' -taskId 'ECS-EK-016' -fixtureRel "$fixtureRootRel/SCN-EK016-ERROR-HANDLING.xlsx" -writes $writes016 -operations $ops016 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3','Sheet1!B4') -sources @($sourceFunctions) -notes 'Error-handling baseline sample.'
Add-Scenario -record @{ case_id='KKW1-010'; scenario=$scenario016; artifact_name='error_handling_baseline_probe.json'; notes='Error-handling baseline.' }

# ECS-EK-018 dynamic shape baseline
$writes018 = @(
    [ordered]@{ kind='value'; address='A1'; value=1 },
    [ordered]@{ kind='value'; address='A2'; value=2 },
    [ordered]@{ kind='value'; address='B1'; value=3 },
    [ordered]@{ kind='value'; address='B2'; value=4 }
)
$ops018 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!D1'; args=[ordered]@{ formula='=HSTACK(A1:A2,B1:B2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!G1'; args=[ordered]@{ formula='=VSTACK(A1:B1,A2:B2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!J1'; args=[ordered]@{ formula='=TOROW(A1:B2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!L1'; args=[ordered]@{ formula='=WRAPROWS(TOROW(A1:B2),2)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario018 = New-BaseScenario -scenarioId 'SCN-EK018-DYNAMIC-SHAPE' -taskId 'ECS-EK-018' -fixtureRel "$fixtureRootRel/SCN-EK018-DYNAMIC-SHAPE.xlsx" -writes $writes018 -operations $ops018 -targets @('Sheet1!D1','Sheet1!E2','Sheet1!G3','Sheet1!J1','Sheet1!L2') -sources @($sourceFunctions) -notes 'Dynamic shape baseline sample.'
Add-Scenario -record @{ case_id='KKW1-011'; scenario=$scenario018; artifact_name='dynamic_shape_probe.json'; notes='Dynamic shape baseline.' }

# ECS-EK-024 TYPE code baseline
$writes024 = @(
    [ordered]@{ kind='value'; address='A1'; value=1 },
    [ordered]@{ kind='value'; address='A2'; value='txt' },
    [ordered]@{ kind='value'; address='A3'; value=$true }
)
$ops024 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=TYPE(A1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=TYPE(A2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=TYPE(A3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B4'; args=[ordered]@{ formula='=TYPE(1/0)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B5'; args=[ordered]@{ formula='=TYPE(SEQUENCE(2,1,1,1))' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario024 = New-BaseScenario -scenarioId 'SCN-EK024-TYPE-CODES' -taskId 'ECS-EK-024' -fixtureRel "$fixtureRootRel/SCN-EK024-TYPE-CODES.xlsx" -writes $writes024 -operations $ops024 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3','Sheet1!B4','Sheet1!B5') -sources @($sourceTypes) -notes 'TYPE code baseline sample.'
Add-Scenario -record @{ case_id='KKW1-012'; scenario=$scenario024; artifact_name='type_code_baseline_probe.json'; notes='TYPE code baseline.' }

# ECS-EK-025 N conversion baseline
$writes025 = @(
    [ordered]@{ kind='value'; address='A1'; value=3.5 },
    [ordered]@{ kind='value'; address='A2'; value='x' },
    [ordered]@{ kind='value'; address='A3'; value=$true }
)
$ops025 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=N(A1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=N(A2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=N(A3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B4'; args=[ordered]@{ formula='=N(1/0)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario025 = New-BaseScenario -scenarioId 'SCN-EK025-N-CONVERSION' -taskId 'ECS-EK-025' -fixtureRel "$fixtureRootRel/SCN-EK025-N-CONVERSION.xlsx" -writes $writes025 -operations $ops025 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3','Sheet1!B4') -sources @($sourceTypes) -notes 'N conversion baseline sample.'
Add-Scenario -record @{ case_id='KKW1-013'; scenario=$scenario025; artifact_name='n_conversion_baseline_probe.json'; notes='N conversion baseline.' }

# ECS-EK-026 VALUE conversion baseline
$writes026 = @(
    [ordered]@{ kind='value'; address='A1'; value='123.45' },
    [ordered]@{ kind='value'; address='A2'; value='2024-01-31' },
    [ordered]@{ kind='value'; address='A3'; value='not_a_number' }
)
$ops026 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=VALUE(A1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=VALUE(A2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=VALUE(A3)'; allow_error=$true } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario026 = New-BaseScenario -scenarioId 'SCN-EK026-VALUE-CONVERSION' -taskId 'ECS-EK-026' -fixtureRel "$fixtureRootRel/SCN-EK026-VALUE-CONVERSION.xlsx" -writes $writes026 -operations $ops026 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3') -sources @($sourceTypes) -notes 'VALUE conversion baseline sample.'
Add-Scenario -record @{ case_id='KKW1-014'; scenario=$scenario026; artifact_name='value_conversion_baseline_probe.json'; notes='VALUE conversion baseline.' }

# ECS-EK-027 VALUETOTEXT baseline
$writes027 = @(
    [ordered]@{ kind='value'; address='A1'; value=1234.5 },
    [ordered]@{ kind='value'; address='A2'; value='text' }
)
$ops027 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=VALUETOTEXT(A1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=VALUETOTEXT(A1,1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=VALUETOTEXT(A2)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario027 = New-BaseScenario -scenarioId 'SCN-EK027-VALUETOTEXT' -taskId 'ECS-EK-027' -fixtureRel "$fixtureRootRel/SCN-EK027-VALUETOTEXT.xlsx" -writes $writes027 -operations $ops027 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3') -sources @($sourceTypes) -notes 'VALUETOTEXT baseline sample.'
Add-Scenario -record @{ case_id='KKW1-015'; scenario=$scenario027; artifact_name='valuetotext_baseline_probe.json'; notes='VALUETOTEXT baseline.' }

# ECS-EK-028 IS* baseline
$writes028 = @(
    [ordered]@{ kind='value'; address='A1'; value=5 },
    [ordered]@{ kind='value'; address='A2'; value='text' },
    [ordered]@{ kind='value'; address='A3'; value=$true }
)
$ops028 = @(
    [ordered]@{ op='edit_cell'; target='Sheet1!B1'; args=[ordered]@{ formula='=ISNUMBER(A1)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B2'; args=[ordered]@{ formula='=ISTEXT(A2)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B3'; args=[ordered]@{ formula='=ISLOGICAL(A3)' } },
    [ordered]@{ op='edit_cell'; target='Sheet1!B4'; args=[ordered]@{ formula='=ISERROR(1/0)' } },
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario028 = New-BaseScenario -scenarioId 'SCN-EK028-IS-FAMILY' -taskId 'ECS-EK-028' -fixtureRel "$fixtureRootRel/SCN-EK028-IS-FAMILY.xlsx" -writes $writes028 -operations $ops028 -targets @('Sheet1!B1','Sheet1!B2','Sheet1!B3','Sheet1!B4') -sources @($sourceTypes) -notes 'IS family baseline sample.'
Add-Scenario -record @{ case_id='KKW1-016'; scenario=$scenario028; artifact_name='is_family_baseline_probe.json'; notes='IS* baseline.' }

# ECS-EK-037 built-in format categories baseline
$writes037 = @(
    [ordered]@{ kind='value'; address='A1'; value=1234.5 },
    [ordered]@{ kind='value'; address='A2'; value=0.25 },
    [ordered]@{ kind='value'; address='A3'; value=45123 },
    [ordered]@{ kind='format'; address='A1'; value='0.00' },
    [ordered]@{ kind='format'; address='A2'; value='0.00%' },
    [ordered]@{ kind='format'; address='A3'; value='yyyy-mm-dd' }
)
$ops037 = @(
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario037 = New-BaseScenario -scenarioId 'SCN-EK037-NUMFMT-CAT' -taskId 'ECS-EK-037' -fixtureRel "$fixtureRootRel/SCN-EK037-NUMFMT-CAT.xlsx" -writes $writes037 -operations $ops037 -targets @('Sheet1!A1','Sheet1!A2','Sheet1!A3') -sources @($sourceFormatting) -notes 'Built-in number format category baseline.'
Add-Scenario -record @{ case_id='KKW1-017'; scenario=$scenario037; artifact_name='number_format_category_probe.json'; notes='Number format category baseline.' }

# ECS-EK-038 custom format baseline
$writes038 = @(
    [ordered]@{ kind='value'; address='A1'; value=12 },
    [ordered]@{ kind='value'; address='A2'; value=-12 },
    [ordered]@{ kind='value'; address='A3'; value=0 },
    [ordered]@{ kind='value'; address='A4'; value='abc' },
    [ordered]@{ kind='format'; address='A1'; value='0.00;[Red]-0.00;0.00;"txt:"@' },
    [ordered]@{ kind='format'; address='A2'; value='0.00;[Red]-0.00;0.00;"txt:"@' },
    [ordered]@{ kind='format'; address='A3'; value='0.00;[Red]-0.00;0.00;"txt:"@' },
    [ordered]@{ kind='format'; address='A4'; value='0.00;[Red]-0.00;0.00;"txt:"@' }
)
$ops038 = @(
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario038 = New-BaseScenario -scenarioId 'SCN-EK038-CUSTOM-NUMFMT' -taskId 'ECS-EK-038' -fixtureRel "$fixtureRootRel/SCN-EK038-CUSTOM-NUMFMT.xlsx" -writes $writes038 -operations $ops038 -targets @('Sheet1!A1','Sheet1!A2','Sheet1!A3','Sheet1!A4') -sources @($sourceFormatting) -notes 'Custom number format section baseline.'
Add-Scenario -record @{ case_id='KKW1-018'; scenario=$scenario038; artifact_name='custom_format_section_probe.json'; notes='Custom number format baseline.' }

# ECS-EK-039 datetime format token baseline
$writes039 = @(
    [ordered]@{ kind='value'; address='A1'; value=45123.75 },
    [ordered]@{ kind='format'; address='A1'; value='yyyy-mm-dd hh:mm:ss' },
    [ordered]@{ kind='value'; address='A2'; value=45123 },
    [ordered]@{ kind='format'; address='A2'; value='dddd, mmmm dd, yyyy' }
)
$ops039 = @(
    [ordered]@{ op='recalc'; target='workbook' }
)
$scenario039 = New-BaseScenario -scenarioId 'SCN-EK039-DATETIME-FMT' -taskId 'ECS-EK-039' -fixtureRel "$fixtureRootRel/SCN-EK039-DATETIME-FMT.xlsx" -writes $writes039 -operations $ops039 -targets @('Sheet1!A1','Sheet1!A2') -sources @($sourceFormatting,$sourceTypes) -notes 'Date/time format token baseline.'
Add-Scenario -record @{ case_id='KKW1-019'; scenario=$scenario039; artifact_name='datetime_format_baseline_probe.json'; notes='Datetime format baseline.' }

foreach ($scenario in $scenarios) {
    $scenarioPath = Join-Path $scenarioDir ($scenario.scenario_id + '.json')
    $scenario | ConvertTo-Json -Depth 40 | Set-Content -Path $scenarioPath
}

$manifestRows | Export-Csv -Path (Join-Path $waveDir 'scenario_manifest_wave1.csv') -NoTypeInformation
$caseRows | Export-Csv -Path (Join-Path $waveDir 'known_known_case_registry_wave1.csv') -NoTypeInformation
$functionIndexRows | Export-Csv -Path (Join-Path $waveDir 'function_recognition_target_map_wave1.csv') -NoTypeInformation

$readme = @(
    '# Known-Known Wave 1',
    '',
    '## Scope',
    'Direct empirical baseline scenarios for selected `ECS-EK-*` tasks not already covered by previous `ECS-EB-*` outputs.',
    '',
    '## Files',
    '- `known_known_case_registry_wave1.csv`',
    '- `scenario_manifest_wave1.csv`',
    '- `function_recognition_target_map_wave1.csv`',
    '- `scenarios/*.json`',
    '- `run_wave1.ps1`',
    '- `build_wave1_outputs.ps1`',
    '- `evidence/<scenario_id>/*`',
    '- `ECS-EK_execution_matrix_wave1.csv`',
    '- `WAVE1_EXECUTION_REPORT.md`',
    '',
    '## Notes',
    '- `SCN-EK011-FUNCTION-RECOGNITION` runs a 500-function sweep using single-argument invocation with `allow_error=true` to preserve parse/rejection traces without halting execution.'
)
Set-Content -Path (Join-Path $waveDir 'README.md') -Value ($readme -join [Environment]::NewLine)

$runScript = @(
    '$ErrorActionPreference = "Stop"',
    '$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")',
    'Set-Location $repoRoot',
    '',
    '$fixtureRoot = ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/known_known_wave1''',
    '$evidenceRoot = ''research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/evidence''',
    'if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }',
    'if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }',
    'New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null',
    'New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null',
    '',
    '& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/evidence --visible false --timeout-sec 3600',
    'if ($LASTEXITCODE -ne 0) { throw "known_known_wave1 run-manifest failed with exit code $LASTEXITCODE" }',
    '',
    '& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/known_known_wave1/build_wave1_outputs.ps1',
    'if ($LASTEXITCODE -ne 0) { throw "known_known_wave1 output synthesis failed with exit code $LASTEXITCODE" }'
)
Set-Content -Path (Join-Path $waveDir 'run_wave1.ps1') -Value ($runScript -join [Environment]::NewLine)

"Seeded $($scenarios.Count) known-known scenarios at $waveDir"
