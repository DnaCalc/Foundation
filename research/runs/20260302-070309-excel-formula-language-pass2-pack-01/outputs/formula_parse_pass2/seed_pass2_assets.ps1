Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$passDir = $PSScriptRoot
$runRoot = (Resolve-Path (Join-Path $passDir '..\..')).Path
$repoRoot = (Resolve-Path (Join-Path $passDir '..\..\..\..\..')).Path

$seedPath = Join-Path $runRoot 'inputs/formula_language_pass2_scenario_seed.csv'
$scenarioDir = Join-Path $passDir 'scenarios'
$fixtureRootRel = 'research/runs/20260302-070309-excel-formula-language-pass2-pack-01/fixtures/formula_parse_pass2'
$fixtureRootAbs = Join-Path $repoRoot $fixtureRootRel

New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path $fixtureRootAbs | Out-Null

if (-not (Test-Path $seedPath)) {
    throw "Seed CSV not found: $seedPath"
}

$taskByProbeId = @{
    'P2-FML-001' = 'ECS-EB-031'
    'P2-FML-002' = 'ECS-EB-032'
    'P2-FML-003' = 'ECS-EB-033'
    'P2-FML-004' = 'ECS-EB-034'
    'P2-FML-005' = 'ECS-EB-035'
    'P2-FML-006' = 'ECS-EB-036'
    'P2-FML-007' = 'ECS-EB-037'
    'P2-FML-008' = 'ECS-EB-038'
    'P2-FML-009' = 'ECS-EB-039'
    'P2-FML-010' = 'ECS-EB-040'
}

$probeKindByProbeId = @{
    'P2-FML-001' = 'argument_gap'
    'P2-FML-002' = 'dot_field'
    'P2-FML-003' = 'intersection'
    'P2-FML-004' = 'helper_forms'
    'P2-FML-005' = 'name_resolution'
    'P2-FML-006' = 'external_reference'
    'P2-FML-007' = 'structured_reference'
    'P2-FML-008' = 'at_hash_interaction'
    'P2-FML-009' = 'normalization'
    'P2-FML-010' = 'precedence'
}

$sourceRefs = @(
    '../../../../reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md',
    '../../../../reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv',
    '../../../../reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md',
    '../../../../reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv'
)

function Get-ManualPrepNote {
    param(
        [Parameter(Mandatory = $true)][string]$Profile
    )

    switch ($Profile) {
        'manual_linked_data' {
            return 'Convert Sheet1!A1 into a linked data type and ensure field "Price" is available before execution.'
        }
        default {
            return ''
        }
    }
}

function Get-FixtureProfile {
    param(
        [Parameter(Mandatory = $true)][string]$FixtureRequirements
    )

    $req = $FixtureRequirements.ToLowerInvariant()
    if ($req.Contains('linked data type')) { return 'manual_linked_data' }
    if ($req.Contains('book2.xlsx present')) { return 'external_workbook_present' }
    if ($req.Contains('book2.xlsx missing')) { return 'external_workbook_missing' }
    if ($req.Contains('sheet-local myname')) { return 'name_shadowing' }
    if ($req.Contains('workbook name myname configured')) { return 'workbook_name' }
    if ($req.Contains('table tblparse') -or $req.Contains('inside table row context')) { return 'table_tblparse' }
    if ($req.Contains('spill anchor')) { return 'spill_anchor' }
    return 'baseline'
}

function Normalize-FormulaInput {
    param(
        [Parameter(Mandatory = $true)][string]$FormulaInput
    )

    # Guard against escaped-quote artifacts from CSV transport.
    return $FormulaInput.Replace('\"', '"')
}

function New-SheetWrites {
    param(
        [Parameter(Mandatory = $true)][string]$Profile,
        [Parameter(Mandatory = $true)][string]$TargetAddress
    )

    $writes = @()
    switch ($Profile) {
        'table_tblparse' {
            $writes += @(
                [ordered]@{ kind = 'value'; address = 'A1'; value = 'Amount' },
                [ordered]@{ kind = 'value'; address = 'B1'; value = 'Value' },
                [ordered]@{ kind = 'value'; address = 'A2'; value = 10 },
                [ordered]@{ kind = 'value'; address = 'A3'; value = 20 },
                [ordered]@{ kind = 'value'; address = 'B2'; value = 1 },
                [ordered]@{ kind = 'value'; address = 'B3'; value = 2 }
            )
        }
        'spill_anchor' {
            $writes += @(
                [ordered]@{ kind = 'formula'; address = 'A1'; value = '=SEQUENCE(3,1,10,1)' },
                [ordered]@{ kind = 'value'; address = 'B1'; value = 1 },
                [ordered]@{ kind = 'value'; address = 'B2'; value = 2 },
                [ordered]@{ kind = 'value'; address = 'B3'; value = 3 }
            )
        }
        'manual_linked_data' {
            $writes += @(
                [ordered]@{ kind = 'value'; address = 'A1'; value = 'LinkedDataCandidate' },
                [ordered]@{ kind = 'value'; address = 'B1'; value = 1 },
                [ordered]@{ kind = 'value'; address = 'B2'; value = 2 },
                [ordered]@{ kind = 'value'; address = 'B3'; value = 3 }
            )
        }
        default {
            $writes += @(
                [ordered]@{ kind = 'value'; address = 'A1'; value = 1 },
                [ordered]@{ kind = 'value'; address = 'A2'; value = 2 },
                [ordered]@{ kind = 'value'; address = 'A3'; value = 3 },
                [ordered]@{ kind = 'value'; address = 'B1'; value = 4 },
                [ordered]@{ kind = 'value'; address = 'B2'; value = 5 },
                [ordered]@{ kind = 'value'; address = 'B3'; value = 6 },
                [ordered]@{ kind = 'value'; address = 'C1'; value = 7 },
                [ordered]@{ kind = 'value'; address = 'C2'; value = 8 },
                [ordered]@{ kind = 'value'; address = 'C3'; value = 9 }
            )
        }
    }

    if ($Profile -eq 'workbook_name' -or $Profile -eq 'name_shadowing') {
        $writes += [ordered]@{
            kind = 'name'
            address = ''
            value = [ordered]@{
                name = 'MyName'
                refers_to = '=Sheet1!$A$1'
            }
        }
    }
    if ($Profile -eq 'name_shadowing') {
        $writes += [ordered]@{
            kind = 'name'
            address = ''
            value = [ordered]@{
                name = 'MyName'
                refers_to = '=Sheet1!$B$1'
                scope = 'sheet'
                sheet = 'Sheet1'
            }
        }
    }

    $writes += [ordered]@{ kind = 'value'; address = $TargetAddress; value = 0 }
    return ,$writes
}

function New-Operations {
    param(
        [Parameter(Mandatory = $true)][string]$Profile,
        [Parameter(Mandatory = $true)][string]$TargetCell,
        [Parameter(Mandatory = $true)][string]$FormulaInput,
        [Parameter(Mandatory = $true)][string]$ExpectedOutcomeClass,
        [Parameter(Mandatory = $true)][string]$SupportWorkbookFixtureRel
    )

    $operations = @(
        [ordered]@{ op = 'set_calc_mode'; target = 'workbook'; args = [ordered]@{ mode = 'automatic' } }
    )

    if ($Profile -eq 'table_tblparse') {
        $operations += [ordered]@{ op = 'create_table'; target = 'Sheet1!A1:B3'; args = [ordered]@{ name = 'TblParse'; has_headers = $true } }
    }
    if ($Profile -eq 'manual_linked_data') {
        $operations += [ordered]@{
            op = 'convert_to_linked_data_type'
            target = 'Sheet1!A1'
            args = [ordered]@{
                service_ids = @(1, 2)
                culture = 1033
                allow_error = $true
            }
        }
    }
    if ($Profile -eq 'external_workbook_present') {
        $operations += [ordered]@{
            op = 'open_support_workbook'
            target = 'workbook'
            args = [ordered]@{
                source_workbook_fixture = $SupportWorkbookFixtureRel
                update_links = 0
                read_only = $true
                allow_error = $true
            }
        }
    }

    $editArgs = [ordered]@{ formula = $FormulaInput }
    if ($ExpectedOutcomeClass -ne 'accepted') {
        $editArgs.allow_error = $true
    }

    $operations += [ordered]@{ op = 'edit_cell'; target = $TargetCell; args = $editArgs }
    $operations += [ordered]@{ op = 'recalc'; target = 'workbook' }
    return ,$operations
}

$seedRows = Import-Csv -Path $seedPath
$manifestRows = @()
$caseRows = @()
$fixtureRows = @()

foreach ($seed in $seedRows) {
    $scenarioId = $seed.scenario_id
    $probeId = $seed.probe_id
    $taskId = if ($taskByProbeId.ContainsKey($probeId)) { $taskByProbeId[$probeId] } else { 'ECS-EB-000' }
    $probeKind = if ($probeKindByProbeId.ContainsKey($probeId)) { $probeKindByProbeId[$probeId] } else { 'probe' }

    $fixtureProfile = Get-FixtureProfile -FixtureRequirements $seed.fixture_requirements
    $manualPrepNote = Get-ManualPrepNote -Profile $fixtureProfile
    $manualPrepRequired = -not [string]::IsNullOrWhiteSpace($manualPrepNote)

    $targetCell = $seed.target_cell
    $targetAddress = ($targetCell -split '!')[1]
    $numericSuffix = $scenarioId -replace '^.*-', ''
    $caseOrdinal = 0
    if (-not [int]::TryParse($numericSuffix, [ref]$caseOrdinal)) {
        throw "Scenario id $scenarioId does not end with a numeric suffix."
    }
    $caseId = ('FPCP2-{0:000}' -f $caseOrdinal)
    $formulaInput = Normalize-FormulaInput -FormulaInput $seed.formula_input

    $fixtureRel = "$fixtureRootRel/$scenarioId.xlsx"
    $scenarioRel = "scenarios/$scenarioId.json"
    $scenarioPath = Join-Path $scenarioDir "$scenarioId.json"

    $writes = New-SheetWrites -Profile $fixtureProfile -TargetAddress $targetAddress
    $supportWorkbookFixtureRel = "$fixtureRootRel/Book2.xlsx"
    $operations = New-Operations -Profile $fixtureProfile -TargetCell $targetCell -FormulaInput $formulaInput -ExpectedOutcomeClass $seed.expected_outcome_class -SupportWorkbookFixtureRel $supportWorkbookFixtureRel

    $assertionQuestion = "Capture parse acceptance/rejection and stored formula/value behavior for $scenarioId."
    if (-not [string]::IsNullOrWhiteSpace($seed.expected_result_hint)) {
        $assertionQuestion = "$assertionQuestion Hint: $($seed.expected_result_hint)"
    }

    $notes = @($seed.notes)
    $notes += "probe_id=$probeId"
    $notes += "profile=$fixtureProfile"
    if ($manualPrepRequired) { $notes += "manual_prep=$manualPrepNote" }
    $noteText = ($notes -join ' | ')

    $scenario = [ordered]@{
        scenario_id = $scenarioId
        task_id = $taskId
        topic = 'formula_parse_pass2'
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
        expectations = @(
            [ordered]@{
                assertion_id = "ASSERT-$scenarioId"
                kind = 'manual_review'
                target = $targetCell
                expected = [ordered]@{
                    question = $assertionQuestion
                }
                confidence = 'medium'
            }
        )
        capture = [ordered]@{
            raw_capture = 'raw_capture.json'
            normalized_capture = 'normalized_capture.json'
            capture_fields = @(
                'value',
                'formula',
                'display_text',
                'number_format',
                'display_number_format',
                'display_interior_color',
                'display_font_color',
                'display_font_bold',
                'calc_mode'
            )
        }
        sources = $sourceRefs
        notes = $noteText
    }

    $scenario | ConvertTo-Json -Depth 30 | Set-Content -Path $scenarioPath -Encoding UTF8

    $caseRows += [pscustomobject]@{
        case_id = $caseId
        scenario_id = $scenarioId
        probe_id = $probeId
        task_id = $taskId
        probe_kind = $probeKind
        target_rules = $seed.target_rules
        fixture_requirements = $seed.fixture_requirements
        fixture_profile = $fixtureProfile
        manual_prep_required = $manualPrepRequired
        manual_prep_note = $manualPrepNote
        formula_input = $formulaInput
        target_cell = $targetCell
        expected_outcome_class = $seed.expected_outcome_class
        expected_result_hint = $seed.expected_result_hint
        notes = $seed.notes
    }

    $manifestRows += [pscustomobject]@{
        scenario_id = $scenarioId
        task_id = $taskId
        priority = 'P1'
        domain = 'formula_parse'
        fixture = $fixtureRel
        scenario_file = $scenarioRel
        status = 'planned'
        notes = "$caseId|$probeKind|expected=$($seed.expected_outcome_class)|profile=$fixtureProfile"
    }

    $fixtureRows += [pscustomobject]@{
        scenario_id = $scenarioId
        fixture_profile = $fixtureProfile
        fixture_path = $fixtureRel
        manual_prep_required = $manualPrepRequired
        manual_prep_note = $manualPrepNote
    }
}

$manifestPath = Join-Path $passDir 'scenario_manifest_pass2.csv'
$caseRegistryPath = Join-Path $passDir 'formula_parse_case_registry_pass2.csv'
$fixtureManifestPath = Join-Path $passDir 'fixture_manifest_pass2.csv'

$manifestRows | Sort-Object scenario_id | Export-Csv -Path $manifestPath -NoTypeInformation -Encoding UTF8
$caseRows | Sort-Object scenario_id | Export-Csv -Path $caseRegistryPath -NoTypeInformation -Encoding UTF8
$fixtureRows | Sort-Object scenario_id | Export-Csv -Path $fixtureManifestPath -NoTypeInformation -Encoding UTF8

$readmeLines = @(
    '# Formula Parse Pass 2',
    '',
    '## Purpose',
    'Empirical pass-2 pack for unresolved formula-language lanes (`P2-FML-001`..`P2-FML-010`).',
    '',
    '## Files',
    '- `formula_parse_case_registry_pass2.csv`',
    '- `scenario_manifest_pass2.csv`',
    '- `fixture_manifest_pass2.csv`',
    '- `scenarios/*.json`',
    '- `seed_pass2_assets.ps1`',
    '- `run_pass2.ps1`',
    '- `run_pass2_manualprep.ps1`',
    '- `run_pass2c_targeted_lanes.ps1`',
    '- `build_pass2_outputs.ps1`',
    '- `FORMULA_PARSE_PASS2_RESULTS.csv` (generated by build script)',
    '- `SEED_TO_EXECUTED_MAPPING_PASS2.csv` (generated by build script)',
    '- `PASS2_EXECUTION_REPORT.md` (generated by build script)',
    '- `MANUAL_PREP_PASS2B_REPORT.md` (generated by manual-prep rerun)',
    '- `TARGETED_PASS2C_LANES_REPORT.md` (generated by targeted lane rerun)',
    '- `PASS2_SYNTHESIS_NOTE.md` (generated after synthesis pass)',
    '',
    '## Notes',
    'Rows flagged with `manual_prep_required=true` are intentionally generated and tracked in `fixture_manifest_pass2.csv`.',
    'These rows can run as-is, but they require manual fixture augmentation to produce high-confidence semantic outcomes.',
    'Linked-data fixture support and policy-level name/external-reference wording remain explicitly tracked as unresolved lanes.'
)
Set-Content -Path (Join-Path $passDir 'README.md') -Value ($readmeLines -join [Environment]::NewLine) -Encoding UTF8

"Seeded $($seedRows.Count) pass-2 formula-language scenarios in $passDir"
