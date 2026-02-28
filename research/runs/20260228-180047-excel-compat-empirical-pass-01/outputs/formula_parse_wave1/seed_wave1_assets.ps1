Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$scenarioDir = Join-Path $waveDir 'scenarios'
$fixtureRootRel = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/formula_parse_wave1'
$fixtureRootAbs = Join-Path $repoRoot $fixtureRootRel
New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path $fixtureRootAbs | Out-Null

$sourceRef = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/19_formula_language_formal_mapping_dossier.md'
$sourceRef2 = '../../20260228-130325-excel-compat-spec-index-pass-01/outputs/25_formula_parse_corpus_registry_seed.md'

$cases = @(
    [pscustomobject]@{ case_id='FPCW1-001'; scenario_id='SCN-EB028-REF-RANGE-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-REF-OPS'; probe_kind='parse_acceptance'; formula='=SUM(A1:B2)'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Baseline range operator acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-002'; scenario_id='SCN-EB028-REF-UNION-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-REF-OPS'; probe_kind='parse_acceptance'; formula='=SUM((A1:A2,B1:B2))'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Union reference acceptance in SUM context.' },
    [pscustomobject]@{ case_id='FPCW1-003'; scenario_id='SCN-EB028-REF-INTERSECTION-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-REF-OPS'; probe_kind='parse_acceptance'; formula='=SUM(A1:C1 A1:A3)'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Space intersection operator acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-004'; scenario_id='SCN-EB028-REF-DOUBLECOLON-REJECT'; task_id='ECS-EB-028'; corpus_id='FPC-028-REF-OPS'; probe_kind='parse_acceptance'; formula='=SUM(A1::B2)'; target='Sheet1!D1'; expected='rejected'; requires_table=$false; seed_spill=$false; notes='Malformed range token should reject.' },
    [pscustomobject]@{ case_id='FPCW1-005'; scenario_id='SCN-EB028-AT-OP-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-AT-HASH'; probe_kind='parse_acceptance'; formula='=@A1:A3'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Implicit intersection operator acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-006'; scenario_id='SCN-EB028-HASH-OP-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-AT-HASH'; probe_kind='parse_acceptance'; formula='=A1#'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$true; notes='Spill reference operator acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-007'; scenario_id='SCN-EB028-AT-HASH-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-AT-HASH'; probe_kind='parse_acceptance'; formula='=@A1#'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$true; notes='Combined @ and # operator acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-008'; scenario_id='SCN-EB028-HASH-PREFIX-REJECT'; task_id='ECS-EB-028'; corpus_id='FPC-028-AT-HASH'; probe_kind='parse_acceptance'; formula='=#A1'; target='Sheet1!D1'; expected='rejected'; requires_table=$false; seed_spill=$false; notes='Malformed prefix # token should reject.' },
    [pscustomobject]@{ case_id='FPCW1-009'; scenario_id='SCN-EB028-LET-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-LAMBDA-LET'; probe_kind='parse_acceptance'; formula='=LET(x,1,x+2)'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='LET baseline acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-010'; scenario_id='SCN-EB028-LAMBDA-INVOKE-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-LAMBDA-LET'; probe_kind='parse_acceptance'; formula='=LAMBDA(x,x+1)(2)'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Inline LAMBDA invocation acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-011'; scenario_id='SCN-EB028-LAMBDA-MISSINGPAREN-REJECT'; task_id='ECS-EB-028'; corpus_id='FPC-028-LAMBDA-LET'; probe_kind='parse_acceptance'; formula='=LAMBDA(x,x+1)(1,2'; target='Sheet1!D1'; expected='rejected'; requires_table=$false; seed_spill=$false; notes='Malformed lambda invocation should reject.' },
    [pscustomobject]@{ case_id='FPCW1-012'; scenario_id='SCN-EB028-FIELDVALUE-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-DATA-TYPE-FIELD'; probe_kind='parse_acceptance'; formula='=FIELDVALUE(A1,"Price")'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='FIELDVALUE parse acceptance regardless of runtime type availability.' },
    [pscustomobject]@{ case_id='FPCW1-013'; scenario_id='SCN-EB030-DOTFIELD-PROBE'; task_id='ECS-EB-030'; corpus_id='FPC-028-DATA-TYPE-FIELD'; probe_kind='ambiguity'; formula='=A1.Price'; target='Sheet1!D1'; expected='probe'; requires_table=$false; seed_spill=$false; notes='Dot field syntax acceptance probe under non-linked-type cell.' },
    [pscustomobject]@{ case_id='FPCW1-014'; scenario_id='SCN-EB028-TABLE-COL-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-TABLE-REF'; probe_kind='parse_acceptance'; formula='=SUM(TblParse[Amount])'; target='Sheet1!D1'; expected='accepted'; requires_table=$true; seed_spill=$false; notes='Structured table column reference acceptance.' },
    [pscustomobject]@{ case_id='FPCW1-015'; scenario_id='SCN-EB028-TABLE-THISROW-ACCEPT'; task_id='ECS-EB-028'; corpus_id='FPC-028-TABLE-REF'; probe_kind='parse_acceptance'; formula='=[@Amount]*2'; target='Sheet1!B2'; expected='accepted'; requires_table=$true; seed_spill=$false; notes='This-row structured reference acceptance inside table body.' },
    [pscustomobject]@{ case_id='FPCW1-016'; scenario_id='SCN-EB028-TABLE-BRACKET-REJECT'; task_id='ECS-EB-028'; corpus_id='FPC-028-TABLE-REF'; probe_kind='parse_acceptance'; formula='=SUM(TblParse[[#All],[Amount])'; target='Sheet1!D1'; expected='rejected'; requires_table=$true; seed_spill=$false; notes='Malformed structured-ref brackets should reject.' },
    [pscustomobject]@{ case_id='FPCW1-017'; scenario_id='SCN-EB029-NORM-CASE-WHITESPACE'; task_id='ECS-EB-029'; corpus_id='FPC-029-NORMALIZATION'; probe_kind='normalization'; formula='=sUm(a1:b2)'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Normalization capture for case-preserving input and canonical stored formula.' },
    [pscustomobject]@{ case_id='FPCW1-018'; scenario_id='SCN-EB029-NORM-TABLE-LOWERCASE'; task_id='ECS-EB-029'; corpus_id='FPC-029-NORMALIZATION'; probe_kind='normalization'; formula='=sum(tblparse[amount])'; target='Sheet1!D1'; expected='accepted'; requires_table=$true; seed_spill=$false; notes='Normalization capture for lowercase table identifiers.' },
    [pscustomobject]@{ case_id='FPCW1-019'; scenario_id='SCN-EB030-AMBIG-INTERSECTION-SINGLE'; task_id='ECS-EB-030'; corpus_id='FPC-028-REF-OPS'; probe_kind='ambiguity'; formula='=A1 B1'; target='Sheet1!D1'; expected='accepted'; requires_table=$false; seed_spill=$false; notes='Single-cell intersection parse/behavior discriminator.' },
    [pscustomobject]@{ case_id='FPCW1-020'; scenario_id='SCN-EB030-AMBIG-DOUBLE-COMMA'; task_id='ECS-EB-030'; corpus_id='FPC-028-REF-OPS'; probe_kind='ambiguity'; formula='=SUM(A1,,B1)'; target='Sheet1!D1'; expected='rejected'; requires_table=$false; seed_spill=$false; notes='Malformed comma placement should reject.' }
)

$manifestRows = @()

foreach ($case in $cases) {
    $scenarioPath = Join-Path $scenarioDir ($case.scenario_id + '.json')
    $fixtureRel = "$fixtureRootRel/$($case.scenario_id).xlsx"

    $writes = @()
    if ($case.requires_table) {
        $writes += @(
            [ordered]@{ kind='value'; address='A1'; value='Amount' },
            [ordered]@{ kind='value'; address='B1'; value='Value' },
            [ordered]@{ kind='value'; address='A2'; value=10 },
            [ordered]@{ kind='value'; address='A3'; value=20 },
            [ordered]@{ kind='value'; address='B2'; value=1 },
            [ordered]@{ kind='value'; address='B3'; value=2 }
        )
    }
    elseif ($case.seed_spill) {
        $writes += @(
            [ordered]@{ kind='formula'; address='A1'; value='=SEQUENCE(3,1,10,1)' },
            [ordered]@{ kind='value'; address='B1'; value=1 },
            [ordered]@{ kind='value'; address='B2'; value=2 },
            [ordered]@{ kind='value'; address='B3'; value=3 }
        )
    }
    else {
        $writes += @(
            [ordered]@{ kind='value'; address='A1'; value=1 },
            [ordered]@{ kind='value'; address='A2'; value=2 },
            [ordered]@{ kind='value'; address='A3'; value=3 },
            [ordered]@{ kind='value'; address='B1'; value=4 },
            [ordered]@{ kind='value'; address='B2'; value=5 },
            [ordered]@{ kind='value'; address='B3'; value=6 }
        )
    }

    $targetAddress = ($case.target -split '!')[1]
    $writes += [ordered]@{ kind='value'; address=$targetAddress; value=0 }

    $operations = @(
        [ordered]@{ op='set_calc_mode'; target='workbook'; args=[ordered]@{ mode='automatic' } }
    )

    if ($case.requires_table) {
        $operations += [ordered]@{ op='create_table'; target='Sheet1!A1:B3'; args=[ordered]@{ name='TblParse'; has_headers=$true } }
    }

    $editArgs = [ordered]@{ formula=$case.formula }
    if ($case.expected -ne 'accepted') {
        $editArgs.allow_error = $true
    }

    $operations += [ordered]@{ op='edit_cell'; target=$case.target; args=$editArgs }
    $operations += [ordered]@{ op='recalc'; target='workbook' }

    $scenario = [ordered]@{
        scenario_id = $case.scenario_id
        task_id = $case.task_id
        topic = 'formula_parse_wave1'
        priority = 'P1'
        platform_target = @('windows_desktop')
        inputs = [ordered]@{
            workbook_fixture = $fixtureRel
            sheet_setup = @(
                [ordered]@{ sheet='Sheet1'; writes=$writes }
            )
        }
        operations = $operations
        expectations = @(
            [ordered]@{
                assertion_id = "ASSERT-$($case.scenario_id)"
                kind = 'manual_review'
                target = $case.target
                expected = [ordered]@{
                    question = 'Capture parse acceptance/rejection and stored-formula normalization behavior.'
                }
                confidence = 'medium'
            }
        )
        capture = [ordered]@{
            raw_capture = 'raw_capture.json'
            normalized_capture = 'normalized_capture.json'
            capture_fields = @('value','formula','display_text','number_format','calc_mode')
        }
        sources = @($sourceRef, $sourceRef2)
        notes = $case.notes
    }

    $scenario | ConvertTo-Json -Depth 20 | Set-Content -Path $scenarioPath

    $manifestRows += [pscustomobject]@{
        scenario_id = $case.scenario_id
        task_id = $case.task_id
        priority = 'P1'
        domain = 'formula_parse'
        fixture = $fixtureRel
        scenario_file = "scenarios/$($case.scenario_id).json"
        status = 'planned'
        notes = "$($case.case_id)|$($case.probe_kind)|expected=$($case.expected)"
    }
}

$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$manifestRows | Export-Csv -Path $manifestPath -NoTypeInformation

$caseRegistryPath = Join-Path $waveDir 'formula_parse_case_registry_wave1.csv'
$cases | Select-Object case_id,scenario_id,task_id,corpus_id,probe_kind,formula,target,expected,requires_table,seed_spill,notes | Export-Csv -Path $caseRegistryPath -NoTypeInformation

$readmeLines = @(
    '# Formula Parse Wave 1',
    '',
    '## Scope',
    'Interleaved execution batch for:',
    '- `ECS-EB-028` parse acceptance corpus',
    '- `ECS-EB-029` normalization capture',
    '- `ECS-EB-030` ambiguity discriminator probes',
    '',
    '## Files',
    '- `formula_parse_case_registry_wave1.csv`',
    '- `scenario_manifest_wave1.csv`',
    '- `scenarios/*.json`',
    '- `run_wave1.ps1`',
    '- `build_wave1_outputs.ps1`',
    '- `evidence/<scenario_id>/*`',
    '- `ECS-EB-028_formula_parse_acceptance_corpus_wave1.csv`',
    '- `ECS-EB-029_formula_normalization_capture_wave1.csv`',
    '- `ECS-EB-030_grammar_ambiguity_probe_wave1.csv`',
    '- `WAVE1_EXECUTION_REPORT.md`'
)
Set-Content -Path (Join-Path $waveDir 'README.md') -Value ($readmeLines -join [Environment]::NewLine)

$runScriptLines = @(
    '$ErrorActionPreference = "Stop"',
    '$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")',
    'Set-Location $repoRoot',
    '',
    '$fixtureRoot = ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/formula_parse_wave1''',
    '$evidenceRoot = ''research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/evidence''',
    'if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }',
    'if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }',
    'New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null',
    'New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null',
    '',
    '& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/evidence --visible false --timeout-sec 300',
    'if ($LASTEXITCODE -ne 0) { throw "formula_parse_wave1 run-manifest failed with exit code $LASTEXITCODE" }',
    '',
    '& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/build_wave1_outputs.ps1',
    'if ($LASTEXITCODE -ne 0) { throw "formula_parse_wave1 output synthesis failed with exit code $LASTEXITCODE" }'
)
Set-Content -Path (Join-Path $waveDir 'run_wave1.ps1') -Value ($runScriptLines -join [Environment]::NewLine)

"Seeded $($cases.Count) formula parse scenarios at $waveDir"
