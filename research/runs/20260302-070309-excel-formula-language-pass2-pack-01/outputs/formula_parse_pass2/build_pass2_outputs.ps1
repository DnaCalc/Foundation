Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$passDir = $PSScriptRoot
$runRoot = (Resolve-Path (Join-Path $passDir '..\..')).Path
$empiricalRunRoot = (Resolve-Path (Join-Path $passDir '..\..')).Path
$evidenceRoot = Join-Path $passDir 'evidence'
$caseRegistryPath = Join-Path $passDir 'formula_parse_case_registry_pass2.csv'
$manifestPath = Join-Path $passDir 'scenario_manifest_pass2.csv'
$seedPath = Join-Path $runRoot 'inputs/formula_language_pass2_scenario_seed.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$resultsPath = Join-Path $passDir 'FORMULA_PARSE_PASS2_RESULTS.csv'
$mappingPath = Join-Path $passDir 'SEED_TO_EXECUTED_MAPPING_PASS2.csv'
$reportPath = Join-Path $passDir 'PASS2_EXECUTION_REPORT.md'

$taskOutputFiles = @{
    'ECS-EB-031' = 'ECS-EB-031_formula_argument_gap_probe_pass2.csv'
    'ECS-EB-032' = 'ECS-EB-032_dot_field_probe_pass2.csv'
    'ECS-EB-033' = 'ECS-EB-033_intersection_probe_pass2.csv'
    'ECS-EB-034' = 'ECS-EB-034_helper_forms_probe_pass2.csv'
    'ECS-EB-035' = 'ECS-EB-035_name_resolution_probe_pass2.csv'
    'ECS-EB-036' = 'ECS-EB-036_external_reference_probe_pass2.csv'
    'ECS-EB-037' = 'ECS-EB-037_structured_reference_probe_pass2.csv'
    'ECS-EB-038' = 'ECS-EB-038_at_hash_probe_pass2.csv'
    'ECS-EB-039' = 'ECS-EB-039_normalization_probe_pass2.csv'
    'ECS-EB-040' = 'ECS-EB-040_precedence_probe_pass2.csv'
}

function Read-JsonFile {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    return Get-Content $Path -Raw | ConvertFrom-Json
}

function To-ScalarString {
    param([object]$Value)
    if ($null -eq $Value) { return '' }
    return [string]$Value
}

if (-not (Test-Path $caseRegistryPath)) {
    throw "Missing case registry: $caseRegistryPath"
}

if (-not (Test-Path $manifestPath)) {
    throw "Missing scenario manifest: $manifestPath"
}

if (-not (Test-Path $evidenceRoot)) {
    New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null
}

$cases = Import-Csv $caseRegistryPath
$rows = @()

foreach ($case in $cases) {
    $scenarioId = $case.scenario_id
    $target = $case.target_cell
    $evDir = Join-Path $evidenceRoot $scenarioId
    $hasEvidence = Test-Path $evDir

    $runManifest = Read-JsonFile (Join-Path $evDir 'run_manifest.json')
    $stepCapture = Read-JsonFile (Join-Path $evDir 'step_capture.json')
    $rawCapture = Read-JsonFile (Join-Path $evDir 'raw_capture.json')

    $runExit = if ($runManifest) { To-ScalarString ($runManifest.exit_status) } else { '' }

    $editTrace = $null
    $linkedDataTrace = $null
    $supportWorkbookTrace = $null
    if ($rawCapture -and $rawCapture.operation_trace) {
        $editTrace = @($rawCapture.operation_trace | Where-Object { $_.op -eq 'edit_cell' } | Select-Object -Last 1)
        if ($editTrace.Count -gt 0) { $editTrace = $editTrace[0] } else { $editTrace = $null }
        $linkedDataTrace = @($rawCapture.operation_trace | Where-Object { $_.op -eq 'convert_to_linked_data_type' } | Select-Object -Last 1)
        if ($linkedDataTrace.Count -gt 0) { $linkedDataTrace = $linkedDataTrace[0] } else { $linkedDataTrace = $null }
        $supportWorkbookTrace = @($rawCapture.operation_trace | Where-Object { $_.op -eq 'open_support_workbook' } | Select-Object -Last 1)
        if ($supportWorkbookTrace.Count -gt 0) { $supportWorkbookTrace = $supportWorkbookTrace[0] } else { $supportWorkbookTrace = $null }
    }

    $editStatus = ''
    $editMessage = ''
    $linkedDataStatus = ''
    $linkedDataMessage = ''
    $supportWorkbookStatus = ''
    $supportWorkbookMessage = ''
    $observedAcceptance = 'not_executed'
    if ($editTrace) {
        $editStatus = if ($editTrace.PSObject.Properties.Name -contains 'status') { To-ScalarString $editTrace.status } else { '' }
        $editMessage = if ($editTrace.PSObject.Properties.Name -contains 'message') { To-ScalarString $editTrace.message } else { '' }
        switch ($editStatus) {
            'ok' { $observedAcceptance = 'accepted' }
            'allowed_error' { $observedAcceptance = 'rejected' }
            default { $observedAcceptance = 'unknown' }
        }
    }
    elseif ($runExit -eq 'failed') {
        $observedAcceptance = 'scenario_failed'
    }
    if ($linkedDataTrace) {
        $linkedDataStatus = if ($linkedDataTrace.PSObject.Properties.Name -contains 'status') { To-ScalarString $linkedDataTrace.status } else { '' }
        $linkedDataMessage = if ($linkedDataTrace.PSObject.Properties.Name -contains 'message') { To-ScalarString $linkedDataTrace.message } else { '' }
    }
    if ($supportWorkbookTrace) {
        $supportWorkbookStatus = if ($supportWorkbookTrace.PSObject.Properties.Name -contains 'status') { To-ScalarString $supportWorkbookTrace.status } else { '' }
        $supportWorkbookMessage = if ($supportWorkbookTrace.PSObject.Properties.Name -contains 'message') { To-ScalarString $supportWorkbookTrace.message } else { '' }
    }

    $initialCapture = $null
    $finalCapture = $null
    $stepCount = 0
    if ($stepCapture -and $stepCapture.steps) {
        $steps = @($stepCapture.steps)
        $stepCount = $steps.Count
        if ($steps.Count -gt 0) {
            $initialCapture = @($steps[0].captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
            if ($initialCapture.Count -gt 0) { $initialCapture = $initialCapture[0] } else { $initialCapture = $null }
            $lastStep = $steps[$steps.Count - 1]
            $finalCapture = @($lastStep.captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
            if ($finalCapture.Count -gt 0) { $finalCapture = $finalCapture[0] } else { $finalCapture = $null }
        }
    }

    $storedFormulaInitial = if ($initialCapture) { To-ScalarString $initialCapture.formula } else { '' }
    $storedFormulaFinal = if ($finalCapture) { To-ScalarString $finalCapture.formula } else { '' }
    $finalValue = if ($finalCapture) { To-ScalarString $finalCapture.value } else { '' }
    $finalDisplay = if ($finalCapture) { To-ScalarString $finalCapture.display_text } else { '' }
    $finalNumberFormat = if ($finalCapture) { To-ScalarString $finalCapture.number_format } else { '' }

    $normalizationChanged = 'unknown'
    if ($observedAcceptance -eq 'accepted') {
        $inputCanonical = To-ScalarString $case.formula_input
        $storedCanonical = To-ScalarString $storedFormulaFinal
        $normalizationChanged = if ($inputCanonical.Trim() -ceq $storedCanonical.Trim()) { 'false' } else { 'true' }
    }

    $expected = To-ScalarString $case.expected_outcome_class
    $resultClass = 'probe'
    if ($expected -eq 'accepted' -or $expected -eq 'rejected') {
        if ($observedAcceptance -eq $expected) { $resultClass = 'matches_expected' }
        elseif ($observedAcceptance -eq 'scenario_failed') { $resultClass = 'run_failed' }
        elseif ($observedAcceptance -eq 'not_executed') { $resultClass = 'not_executed' }
        elseif ($observedAcceptance -eq 'unknown') { $resultClass = 'insufficient_signal' }
        else { $resultClass = 'mismatch' }
    }

    $rows += [pscustomobject]@{
        case_id = $case.case_id
        scenario_id = $scenarioId
        probe_id = $case.probe_id
        task_id = $case.task_id
        probe_kind = $case.probe_kind
        target_rules = $case.target_rules
        fixture_profile = $case.fixture_profile
        manual_prep_required = $case.manual_prep_required
        manual_prep_note = $case.manual_prep_note
        formula_input = $case.formula_input
        target_cell = $target
        expected_outcome_class = $expected
        expected_result_hint = $case.expected_result_hint
        observed_acceptance = $observedAcceptance
        result_class = $resultClass
        run_exit_status = $runExit
        edit_operation_status = $editStatus
        edit_operation_message = $editMessage
        linked_data_operation_status = $linkedDataStatus
        linked_data_operation_message = $linkedDataMessage
        support_workbook_operation_status = $supportWorkbookStatus
        support_workbook_operation_message = $supportWorkbookMessage
        stored_formula_initial = $storedFormulaInitial
        stored_formula_final = $storedFormulaFinal
        normalization_changed = $normalizationChanged
        final_value = $finalValue
        final_display_text = $finalDisplay
        final_number_format = $finalNumberFormat
        step_count = $stepCount
        evidence_exists = $hasEvidence
        evidence_bundle_ref = if ($hasEvidence) { Join-Path 'evidence' $scenarioId } else { '' }
        notes = $case.notes
    }
}

$rows | Sort-Object scenario_id | Export-Csv -Path $resultsPath -NoTypeInformation -Encoding UTF8

foreach ($taskId in $taskOutputFiles.Keys) {
    $taskRows = @($rows | Where-Object { $_.task_id -eq $taskId } | Sort-Object scenario_id)
    $taskPath = Join-Path $passDir $taskOutputFiles[$taskId]
    $taskRows | Export-Csv -Path $taskPath -NoTypeInformation -Encoding UTF8
}

$seedRows = @()
if (Test-Path $seedPath) {
    $seedRows = Import-Csv $seedPath
}

$mappingRows = @()
foreach ($seed in $seedRows) {
    $match = @($rows | Where-Object { $_.scenario_id -eq $seed.scenario_id } | Select-Object -First 1)
    if ($match.Count -gt 0) { $match = $match[0] } else { $match = $null }

    $mappingRows += [pscustomobject]@{
        probe_id = $seed.probe_id
        scenario_id = $seed.scenario_id
        target_rules = $seed.target_rules
        expected_outcome_class = $seed.expected_outcome_class
        fixture_requirements = $seed.fixture_requirements
        formula_input = $seed.formula_input
        target_cell = $seed.target_cell
        observed_acceptance = if ($match) { $match.observed_acceptance } else { '' }
        result_class = if ($match) { $match.result_class } else { '' }
        run_exit_status = if ($match) { $match.run_exit_status } else { '' }
        evidence_bundle_ref = if ($match) { $match.evidence_bundle_ref } else { '' }
    }
}
$mappingRows | Sort-Object scenario_id | Export-Csv -Path $mappingPath -NoTypeInformation -Encoding UTF8

$manifestRows = Import-Csv $manifestPath
foreach ($m in $manifestRows) {
    if (Test-Path (Join-Path $evidenceRoot $m.scenario_id)) {
        $m.status = 'completed'
    }
}
$manifestRows | Export-Csv -Path $manifestPath -NoTypeInformation -Encoding UTF8

$total = @($rows).Count
$executed = @($rows | Where-Object { $_.evidence_exists -eq 'True' }).Count
$accepted = @($rows | Where-Object { $_.observed_acceptance -eq 'accepted' }).Count
$rejected = @($rows | Where-Object { $_.observed_acceptance -eq 'rejected' }).Count
$mismatch = @($rows | Where-Object { $_.result_class -eq 'mismatch' }).Count
$failed = @($rows | Where-Object { $_.run_exit_status -eq 'failed' }).Count
$manualRows = @($rows | Where-Object { $_.manual_prep_required -eq 'True' })
$manualExecuted = @($manualRows | Where-Object { $_.evidence_exists -eq 'True' }).Count

$reportLines = @(
    '# Formula Parse Pass 2 Execution Report',
    '',
    '## Scope',
    'Generated pass-2 consolidated outputs for scenario set `FMLP2-001..FMLP2-037`.',
    '',
    '## Execution Status',
    "- Scenario rows: $total",
    "- Evidence bundles present: $executed",
    "- Observed accepted: $accepted",
    "- Observed rejected: $rejected",
    "- Mismatch rows: $mismatch",
    "- Run-failed rows: $failed",
    "- Manual-prep rows: $($manualRows.Count) (executed: $manualExecuted)",
    '',
    '## Artifacts',
    '- `FORMULA_PARSE_PASS2_RESULTS.csv`',
    '- `SEED_TO_EXECUTED_MAPPING_PASS2.csv`',
    '- `ECS-EB-031_formula_argument_gap_probe_pass2.csv`',
    '- `ECS-EB-032_dot_field_probe_pass2.csv`',
    '- `ECS-EB-033_intersection_probe_pass2.csv`',
    '- `ECS-EB-034_helper_forms_probe_pass2.csv`',
    '- `ECS-EB-035_name_resolution_probe_pass2.csv`',
    '- `ECS-EB-036_external_reference_probe_pass2.csv`',
    '- `ECS-EB-037_structured_reference_probe_pass2.csv`',
    '- `ECS-EB-038_at_hash_probe_pass2.csv`',
    '- `ECS-EB-039_normalization_probe_pass2.csv`',
    '- `ECS-EB-040_precedence_probe_pass2.csv`',
    '- `scenario_manifest_pass2.csv`'
)
Set-Content -Path $reportPath -Value ($reportLines -join [Environment]::NewLine) -Encoding UTF8

$existingLogRows = @()
if (Test-Path $logManifestPath) {
    $existingLogRows = Import-Csv $logManifestPath
}
$mutableLogs = [System.Collections.Generic.List[object]]::new()
foreach ($r in $existingLogRows) { $mutableLogs.Add($r) }

function Add-LogEvent {
    param(
        [string]$Event,
        [string]$Artifact,
        [string]$Notes
    )
    $existing = $mutableLogs | Where-Object { $_.event -eq $Event -and $_.artifact -eq $Artifact }
    if ($existing) { return }
    $mutableLogs.Add([pscustomobject]@{
        timestamp_utc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        event = $Event
        artifact = $Artifact
        notes = $Notes
    })
}

Add-LogEvent -Event 'formula_parse_pass2_outputs_generated' -Artifact 'outputs/formula_parse_pass2/FORMULA_PARSE_PASS2_RESULTS.csv' -Notes 'Generated pass-2 consolidated scenario results.'
Add-LogEvent -Event 'formula_parse_pass2_outputs_generated' -Artifact 'outputs/formula_parse_pass2/SEED_TO_EXECUTED_MAPPING_PASS2.csv' -Notes 'Generated pass-2 seed-to-executed mapping.'
Add-LogEvent -Event 'formula_parse_pass2_reported' -Artifact 'outputs/formula_parse_pass2/PASS2_EXECUTION_REPORT.md' -Notes 'Published pass-2 execution report.'
Add-LogEvent -Event 'formula_parse_pass2_manifest_status_updated' -Artifact 'outputs/formula_parse_pass2/scenario_manifest_pass2.csv' -Notes 'Marked pass-2 scenarios completed when evidence bundle exists.'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation -Encoding UTF8

([pscustomobject]@{
    scenario_rows = $total
    evidence_rows = $executed
    observed_accepted = $accepted
    observed_rejected = $rejected
    mismatch_rows = $mismatch
    run_failed_rows = $failed
}) | ConvertTo-Json -Depth 3
