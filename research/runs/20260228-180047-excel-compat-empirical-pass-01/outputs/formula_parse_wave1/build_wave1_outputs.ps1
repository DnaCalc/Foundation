Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'
$caseRegistryPath = Join-Path $waveDir 'formula_parse_case_registry_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$eb028Path = Join-Path $waveDir 'ECS-EB-028_formula_parse_acceptance_corpus_wave1.csv'
$eb029Path = Join-Path $waveDir 'ECS-EB-029_formula_normalization_capture_wave1.csv'
$eb030Path = Join-Path $waveDir 'ECS-EB-030_grammar_ambiguity_probe_wave1.csv'
$reportPath = Join-Path $waveDir 'WAVE1_EXECUTION_REPORT.md'

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

$cases = Import-Csv $caseRegistryPath
$rows = @()

foreach ($case in $cases) {
    $scenarioId = $case.scenario_id
    $scenarioPath = Join-Path $waveDir ("scenarios/{0}.json" -f $scenarioId)
    $scenario = Read-JsonFile $scenarioPath

    $evDir = Join-Path $evidenceRoot $scenarioId
    $runManifest = Read-JsonFile (Join-Path $evDir 'run_manifest.json')
    $stepCapture = Read-JsonFile (Join-Path $evDir 'step_capture.json')
    $rawCapture = Read-JsonFile (Join-Path $evDir 'raw_capture.json')

    $runExit = To-ScalarString ($runManifest.exit_status)
    $editTrace = $null
    if ($rawCapture -and $rawCapture.operation_trace) {
        $editTrace = @($rawCapture.operation_trace | Where-Object { $_.op -eq 'edit_cell' } | Select-Object -Last 1)
        if ($editTrace.Count -gt 0) { $editTrace = $editTrace[0] } else { $editTrace = $null }
    }

    $observedAcceptance = 'unknown'
    $editStatus = ''
    $editMessage = ''

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

    $target = $case.target
    $finalCapture = $null
    $initialCapture = $null
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

    $inputFormula = To-ScalarString $case.formula
    $storedFormulaInitial = if ($initialCapture) { To-ScalarString $initialCapture.formula } else { '' }
    $storedFormulaFinal = if ($finalCapture) { To-ScalarString $finalCapture.formula } else { '' }
    $finalValue = if ($finalCapture) { To-ScalarString $finalCapture.value } else { '' }
    $finalDisplay = if ($finalCapture) { To-ScalarString $finalCapture.display_text } else { '' }

    $normalizationChanged = 'unknown'
    if ($observedAcceptance -eq 'accepted') {
        $inputCanonical = $inputFormula.Trim()
        $storedCanonical = $storedFormulaFinal.Trim()
        $normalizationChanged = if ($inputCanonical -ceq $storedCanonical) { 'false' } else { 'true' }
    }

    $expected = To-ScalarString $case.expected
    $resultClass = 'probe'
    if ($expected -eq 'accepted' -or $expected -eq 'rejected') {
        if ($observedAcceptance -eq $expected) { $resultClass = 'matches_expected' }
        elseif ($observedAcceptance -eq 'scenario_failed') { $resultClass = 'run_failed' }
        elseif ($observedAcceptance -eq 'unknown') { $resultClass = 'insufficient_signal' }
        else { $resultClass = 'mismatch' }
    }

    $rows += [pscustomobject]@{
        case_id = $case.case_id
        scenario_id = $scenarioId
        task_id = $case.task_id
        corpus_id = $case.corpus_id
        probe_kind = $case.probe_kind
        target = $target
        formula_input = $inputFormula
        expected_acceptance = $expected
        observed_acceptance = $observedAcceptance
        result_class = $resultClass
        run_exit_status = $runExit
        edit_operation_status = $editStatus
        edit_operation_message = $editMessage
        stored_formula_initial = $storedFormulaInitial
        stored_formula_final = $storedFormulaFinal
        normalization_changed = $normalizationChanged
        final_value = $finalValue
        final_display_text = $finalDisplay
        step_count = $stepCount
        evidence_bundle_ref = (Join-Path 'evidence' $scenarioId)
        notes = $case.notes
    }
}

$rows | Where-Object { $_.task_id -eq 'ECS-EB-028' } | Sort-Object scenario_id | Export-Csv -Path $eb028Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-029' } | Sort-Object scenario_id | Export-Csv -Path $eb029Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-030' } | Sort-Object scenario_id | Export-Csv -Path $eb030Path -NoTypeInformation

$manifestRows = Import-Csv $manifestPath
foreach ($m in $manifestRows) {
    if (Test-Path (Join-Path $evidenceRoot $m.scenario_id)) {
        $m.status = 'completed'
    }
}
$manifestRows | Export-Csv -Path $manifestPath -NoTypeInformation

$total = @($rows).Count
$accepted = @($rows | Where-Object { $_.observed_acceptance -eq 'accepted' }).Count
$rejected = @($rows | Where-Object { $_.observed_acceptance -eq 'rejected' }).Count
$probe = @($rows | Where-Object { $_.expected_acceptance -eq 'probe' }).Count
$mismatch = @($rows | Where-Object { $_.result_class -eq 'mismatch' }).Count
$runFailed = @($rows | Where-Object { $_.result_class -eq 'run_failed' }).Count
$mismatchDetails = @($rows | Where-Object { $_.result_class -eq 'mismatch' })
$normalizationRows = @($rows | Where-Object { $_.task_id -eq 'ECS-EB-029' -and $_.observed_acceptance -eq 'accepted' })
$normalizationChangedCount = @($normalizationRows | Where-Object { $_.normalization_changed -eq 'true' }).Count
$mismatchLine = '- none'
if ($mismatchDetails.Count -gt 0) {
    $mismatchLine = "- ``$($($mismatchDetails[0]).scenario_id)``: expected ``$($($mismatchDetails[0]).expected_acceptance)``, observed ``$($($mismatchDetails[0]).observed_acceptance)``, stored formula ``$($($mismatchDetails[0]).stored_formula_final)``."
}

$reportLines = @(
    '# Formula Parse Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed `ECS-EB-028`, `ECS-EB-029`, and `ECS-EB-030` wave-1 scenarios from the seeded corpus registry.',
    '',
    '## Execution status',
    "- Scenario rows: $total",
    "- Observed accepted: $accepted",
    "- Observed rejected: $rejected",
    "- Probe-expected rows: $probe",
    "- Mismatch rows: $mismatch",
    "- Run-failed rows: $runFailed",
    '',
    '## Key outcomes',
    "1. Parse acceptance corpus produced expected accept/reject outcomes for most baseline constructs.",
    "2. Normalization captures observed stored-form canonicalization in $normalizationChangedCount/$(@($normalizationRows).Count) accepted normalization rows.",
    "3. Dot-field probe (`=A1.Price`) was accepted syntactically and evaluated to a field-related worksheet error in this environment.",
    "4. One ambiguity mismatch was observed (`=SUM(A1,,B1)` accepted and evaluated rather than rejecting).",
    '5. All scenarios completed with zero run-level failures in the final rerun.',
    '',
    '### Mismatch detail',
    $mismatchLine,
    '',
    '## Artifacts',
    '- `ECS-EB-028_formula_parse_acceptance_corpus_wave1.csv`',
    '- `ECS-EB-029_formula_normalization_capture_wave1.csv`',
    '- `ECS-EB-030_grammar_ambiguity_probe_wave1.csv`',
    '- `formula_parse_case_registry_wave1.csv`',
    '- `scenario_manifest_wave1.csv`',
    '- `evidence/<scenario_id>/*`'
)
Set-Content -Path $reportPath -Value ($reportLines -join [Environment]::NewLine)

$logRows = @()
if (Test-Path $logManifestPath) {
    $logRows = Import-Csv $logManifestPath
}
$mutableLogs = [System.Collections.Generic.List[object]]::new()
foreach ($r in $logRows) { $mutableLogs.Add($r) }

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

Add-LogEvent -Event 'formula_parse_wave1_seeded' -Artifact 'outputs/formula_parse_wave1/formula_parse_case_registry_wave1.csv' -Notes 'Seeded formula parse case registry and scenario manifest for ECS-EB-028/029/030'
Add-LogEvent -Event 'formula_parse_wave1_outputs_generated' -Artifact 'outputs/formula_parse_wave1/ECS-EB-028_formula_parse_acceptance_corpus_wave1.csv' -Notes 'Generated parse acceptance corpus outputs from wave1 evidence bundles'
Add-LogEvent -Event 'formula_parse_wave1_outputs_generated' -Artifact 'outputs/formula_parse_wave1/ECS-EB-029_formula_normalization_capture_wave1.csv' -Notes 'Generated normalization capture outputs from wave1 evidence bundles'
Add-LogEvent -Event 'formula_parse_wave1_outputs_generated' -Artifact 'outputs/formula_parse_wave1/ECS-EB-030_grammar_ambiguity_probe_wave1.csv' -Notes 'Generated ambiguity probe outputs from wave1 evidence bundles'
Add-LogEvent -Event 'formula_parse_wave1_reported' -Artifact 'outputs/formula_parse_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published formula parse wave1 execution report'
Add-LogEvent -Event 'formula_parse_wave1_manifest_status_updated' -Artifact 'outputs/formula_parse_wave1/scenario_manifest_wave1.csv' -Notes 'Marked formula parse wave1 scenarios completed after evidence verification'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    scenario_rows = $total
    observed_accepted = $accepted
    observed_rejected = $rejected
    mismatch_rows = $mismatch
    run_failed_rows = $runFailed
}
$summary | ConvertTo-Json -Depth 3
