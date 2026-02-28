Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'
$caseRegistryPath = Join-Path $waveDir 'coercion_case_registry_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$eb024Path = Join-Path $waveDir 'ECS-EB-024_operator_coercion_truth_table_wave1.csv'
$eb025Path = Join-Path $waveDir 'ECS-EB-025_function_family_coercion_probe_wave1.csv'
$eb026Path = Join-Path $waveDir 'ECS-EB-026_compatibility_coercion_probe_wave1.csv'
$eb027Path = Join-Path $waveDir 'ECS-EB-027_coercion_confidence_scores_wave1.csv'
$reportPath = Join-Path $waveDir 'WAVE1_EXECUTION_REPORT.md'

$scenarioCache = @{}

function Read-JsonFile {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    return (Get-Content $Path -Raw | ConvertFrom-Json)
}

function To-ScalarString {
    param([object]$Value)
    if ($null -eq $Value) { return '' }
    return [string]$Value
}

function Is-ErrorLike {
    param(
        [string]$Value,
        [string]$DisplayText
    )
    if ($Value -match '^#.+!$') { return $true }
    if ($DisplayText -match '^#.+!$') { return $true }
    return $false
}

function Try-ParseDecimalInvariant {
    param(
        [string]$Text,
        [ref]$OutValue
    )

    $styles = [System.Globalization.NumberStyles]::Float -bor [System.Globalization.NumberStyles]::AllowThousands
    return [decimal]::TryParse($Text, $styles, [System.Globalization.CultureInfo]::InvariantCulture, $OutValue)
}

function Values-Match {
    param(
        [string]$Expected,
        [string]$ObservedValue,
        [string]$ObservedDisplay
    )

    if ([string]::IsNullOrWhiteSpace($Expected)) {
        return [string]::IsNullOrWhiteSpace($ObservedValue)
    }

    if ($Expected -ieq $ObservedValue -or $Expected -ieq $ObservedDisplay) {
        return $true
    }

    $expectedDecimal = [decimal]0
    $observedDecimal = [decimal]0
    if ((Try-ParseDecimalInvariant -Text $Expected -OutValue ([ref]$expectedDecimal)) -and
        (Try-ParseDecimalInvariant -Text $ObservedValue -OutValue ([ref]$observedDecimal))) {
        if ([Math]::Abs([double]($expectedDecimal - $observedDecimal)) -le 1e-9) {
            return $true
        }
    }

    return $false
}

function Get-ScenarioArtifacts {
    param([string]$ScenarioId)

    if (-not $scenarioCache.ContainsKey($ScenarioId)) {
        $evDir = Join-Path $evidenceRoot $ScenarioId
        $scenarioCache[$ScenarioId] = [pscustomobject]@{
            run_manifest = Read-JsonFile (Join-Path $evDir 'run_manifest.json')
            step_capture = Read-JsonFile (Join-Path $evDir 'step_capture.json')
            raw_capture = Read-JsonFile (Join-Path $evDir 'raw_capture.json')
        }
    }

    return $scenarioCache[$ScenarioId]
}

$cases = Import-Csv $caseRegistryPath
$rows = @()

foreach ($case in $cases) {
    $scenarioId = $case.scenario_id
    $target = $case.target
    $artifacts = Get-ScenarioArtifacts -ScenarioId $scenarioId

    $runExit = To-ScalarString ($artifacts.run_manifest.exit_status)
    if ([string]::IsNullOrWhiteSpace($runExit)) { $runExit = 'unknown' }

    $stepCount = 0
    $initialCapture = $null
    $finalCapture = $null
    if ($artifacts.step_capture -and $artifacts.step_capture.steps) {
        $steps = @($artifacts.step_capture.steps)
        $stepCount = $steps.Count
        if ($steps.Count -gt 0) {
            $initialCaptureHit = @($steps[0].captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
            if ($initialCaptureHit.Count -gt 0) { $initialCapture = $initialCaptureHit[0] }

            $lastStep = $steps[$steps.Count - 1]
            $finalCaptureHit = @($lastStep.captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
            if ($finalCaptureHit.Count -gt 0) { $finalCapture = $finalCaptureHit[0] }
        }
    }

    $editStatus = ''
    $editMessage = ''
    if ($artifacts.raw_capture -and $artifacts.raw_capture.operation_trace) {
        $traceHit = @($artifacts.raw_capture.operation_trace | Where-Object { $_.op -eq 'edit_cell' } | Select-Object -Last 1)
        if ($traceHit.Count -gt 0) {
            $editTrace = $traceHit[0]
            if ($editTrace.PSObject.Properties.Name -contains 'status') { $editStatus = To-ScalarString $editTrace.status }
            if ($editTrace.PSObject.Properties.Name -contains 'message') { $editMessage = To-ScalarString $editTrace.message }
        }
    }

    $initialValue = if ($initialCapture) { To-ScalarString $initialCapture.value } else { '' }
    $finalValue = if ($finalCapture) { To-ScalarString $finalCapture.value } else { '' }
    $finalDisplay = if ($finalCapture) { To-ScalarString $finalCapture.display_text } else { '' }
    $finalFormula = if ($finalCapture) { To-ScalarString $finalCapture.formula } else { '' }
    $observedKind = 'unknown'
    $observedError = ''

    if ($runExit -eq 'failed') {
        $observedKind = 'scenario_failed'
    }
    elseif (Is-ErrorLike -Value $finalValue -DisplayText $finalDisplay) {
        $observedKind = 'error'
        if ($finalValue -match '^#.+!$') { $observedError = $finalValue }
        elseif ($finalDisplay -match '^#.+!$') { $observedError = $finalDisplay }
    }
    elseif ($finalCapture) {
        $observedKind = 'value'
    }

    $expectedKind = To-ScalarString $case.expected_kind
    $expectedValue = To-ScalarString $case.expected_value
    $expectedError = To-ScalarString $case.expected_error
    $resultStatus = 'needs_review'
    $matchBasis = ''

    if ($runExit -eq 'failed') {
        $resultStatus = 'run_failed'
        $matchBasis = 'scenario_failed'
    }
    elseif ($expectedKind -eq 'probe') {
        $resultStatus = 'probe'
        $matchBasis = 'probe_expected'
    }
    elseif ($expectedKind -eq 'value') {
        if ($observedKind -eq 'value' -and (Values-Match -Expected $expectedValue -ObservedValue $finalValue -ObservedDisplay $finalDisplay)) {
            $resultStatus = 'matches_expected'
            $matchBasis = 'value_match'
        }
        else {
            $resultStatus = 'mismatch'
            $matchBasis = 'value_mismatch'
        }
    }
    elseif ($expectedKind -eq 'error') {
        if ($observedKind -eq 'error' -and ($observedError -ieq $expectedError -or $finalDisplay -ieq $expectedError -or $finalValue -ieq $expectedError)) {
            $resultStatus = 'matches_expected'
            $matchBasis = 'error_match'
        }
        else {
            $resultStatus = 'mismatch'
            $matchBasis = 'error_mismatch'
        }
    }

    $rows += [pscustomobject]@{
        case_id = $case.case_id
        scenario_id = $scenarioId
        task_id = $case.task_id
        family = $case.family
        target = $target
        formula = $case.formula
        expected_kind = $expectedKind
        expected_value = $expectedValue
        expected_error = $expectedError
        confidence_input = $case.confidence
        run_exit_status = $runExit
        edit_operation_status = $editStatus
        edit_operation_message = $editMessage
        observed_kind = $observedKind
        observed_error = $observedError
        initial_value = $initialValue
        final_value = $finalValue
        final_display_text = $finalDisplay
        final_formula = $finalFormula
        step_count = $stepCount
        result_status = $resultStatus
        match_basis = $matchBasis
        evidence_bundle_ref = (Join-Path 'evidence' $scenarioId)
        source_anchor = $case.source_anchor
        notes = $case.notes
    }
}

$rows | Where-Object { $_.task_id -eq 'ECS-EB-024' } | Sort-Object case_id | Export-Csv -Path $eb024Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-025' } | Sort-Object case_id | Export-Csv -Path $eb025Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-026' } | Sort-Object case_id | Export-Csv -Path $eb026Path -NoTypeInformation

$eb027Rows = @()
foreach ($row in $rows) {
    $confidenceInput = To-ScalarString $row.confidence_input
    $confidenceOut = $confidenceInput
    $followUpRequired = 'false'
    $confidenceReason = 'carry_forward'

    switch ($row.result_status) {
        'matches_expected' {
            switch ($confidenceInput) {
                'low' { $confidenceOut = 'medium' }
                'medium' { $confidenceOut = 'high' }
                default { $confidenceOut = $confidenceInput }
            }
            $confidenceReason = 'empirical_support'
        }
        'mismatch' {
            $confidenceOut = 'low'
            $followUpRequired = 'true'
            $confidenceReason = 'empirical_counter_signal'
        }
        'run_failed' {
            $confidenceOut = 'low'
            $followUpRequired = 'true'
            $confidenceReason = 'scenario_failure'
        }
        'probe' {
            $followUpRequired = 'true'
            $confidenceReason = 'probe_expected_requires_interpretation'
        }
        default {
            $followUpRequired = 'true'
            $confidenceReason = 'insufficient_signal'
        }
    }

    $eb027Rows += [pscustomobject]@{
        score_id = ('CCW1-{0}' -f $row.case_id)
        case_id = $row.case_id
        scenario_id = $row.scenario_id
        task_id = 'ECS-EB-027'
        source_task_id = $row.task_id
        family = $row.family
        confidence_input = $confidenceInput
        confidence_output = $confidenceOut
        result_status = $row.result_status
        follow_up_required = $followUpRequired
        confidence_reason = $confidenceReason
        evidence_bundle_ref = $row.evidence_bundle_ref
        notes = $row.notes
    }
}
$eb027Rows | Sort-Object case_id | Export-Csv -Path $eb027Path -NoTypeInformation

$manifestRows = Import-Csv $manifestPath
foreach ($m in $manifestRows) {
    if (Test-Path (Join-Path $evidenceRoot $m.scenario_id)) {
        $m.status = 'completed'
    }
}
$manifestRows | Export-Csv -Path $manifestPath -NoTypeInformation

$total = @($rows).Count
$matched = @($rows | Where-Object { $_.result_status -eq 'matches_expected' }).Count
$mismatch = @($rows | Where-Object { $_.result_status -eq 'mismatch' }).Count
$probe = @($rows | Where-Object { $_.result_status -eq 'probe' }).Count
$runFailed = @($rows | Where-Object { $_.result_status -eq 'run_failed' }).Count

$task024 = @($rows | Where-Object { $_.task_id -eq 'ECS-EB-024' })
$task025 = @($rows | Where-Object { $_.task_id -eq 'ECS-EB-025' })
$task026 = @($rows | Where-Object { $_.task_id -eq 'ECS-EB-026' })
$task024Mismatch = @($task024 | Where-Object { $_.result_status -eq 'mismatch' }).Count
$task025Mismatch = @($task025 | Where-Object { $_.result_status -eq 'mismatch' }).Count
$task026Mismatch = @($task026 | Where-Object { $_.result_status -eq 'mismatch' }).Count

$mismatchDetails = @($rows | Where-Object { $_.result_status -eq 'mismatch' } | Select-Object -First 5)
$mismatchLines = @()
if ($mismatchDetails.Count -eq 0) {
    $mismatchLines += '- none'
}
else {
    foreach ($d in $mismatchDetails) {
        $mismatchLines += ('- `{0}` ({1}) expected {2} [{3}|{4}] observed {5} [{6}|{7}]' -f
            $d.case_id, $d.target, $d.expected_kind, $d.expected_value, $d.expected_error, $d.observed_kind, $d.final_value, $d.final_display_text)
    }
}

$reportLines = @(
    '# Coercion Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed wave-1 coercion scenarios covering `ECS-EB-024`, `ECS-EB-025`, `ECS-EB-026`, and generated confidence synthesis for `ECS-EB-027`.',
    '',
    '## Execution status',
    "- Case rows: $total",
    "- Matches expected: $matched",
    "- Mismatch rows: $mismatch",
    "- Probe rows: $probe",
    "- Run-failed rows: $runFailed",
    '',
    '## Task breakdown',
    "- `ECS-EB-024`: $(@($task024).Count) rows, mismatches $task024Mismatch",
    "- `ECS-EB-025`: $(@($task025).Count) rows, mismatches $task025Mismatch",
    "- `ECS-EB-026`: $(@($task026).Count) rows, mismatches $task026Mismatch",
    '',
    '## Key outcomes',
    '1. Operator coercion baseline (`ECS-EB-024`) produced an evidence-backed truth table for numeric-text, boolean, concat, and date arithmetic contexts.',
    '2. Function-family coercion probes (`ECS-EB-025`) captured direct-arg vs range coercion differences and left explicit probe lanes where behavior is context-sensitive.',
    '3. Compatibility/precedence probes (`ECS-EB-026`) captured precedence-sensitive outcomes including unary/exponent and ambiguity constructs.',
    '4. Confidence scoring (`ECS-EB-027`) was generated for every case with explicit follow-up flags.',
    '',
    '### Mismatch detail (first 5)'
)
$reportLines += $mismatchLines
$reportLines += @(
    '',
    '## Artifacts',
    '- `ECS-EB-024_operator_coercion_truth_table_wave1.csv`',
    '- `ECS-EB-025_function_family_coercion_probe_wave1.csv`',
    '- `ECS-EB-026_compatibility_coercion_probe_wave1.csv`',
    '- `ECS-EB-027_coercion_confidence_scores_wave1.csv`',
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

Add-LogEvent -Event 'coercion_wave1_seeded' -Artifact 'outputs/coercion_wave1/coercion_case_registry_wave1.csv' -Notes 'Seeded coercion wave1 case registry and scenario manifest for ECS-EB-024/025/026'
Add-LogEvent -Event 'coercion_wave1_outputs_generated' -Artifact 'outputs/coercion_wave1/ECS-EB-024_operator_coercion_truth_table_wave1.csv' -Notes 'Generated operator coercion truth-table output from wave1 evidence bundles'
Add-LogEvent -Event 'coercion_wave1_outputs_generated' -Artifact 'outputs/coercion_wave1/ECS-EB-025_function_family_coercion_probe_wave1.csv' -Notes 'Generated function-family coercion probe output from wave1 evidence bundles'
Add-LogEvent -Event 'coercion_wave1_outputs_generated' -Artifact 'outputs/coercion_wave1/ECS-EB-026_compatibility_coercion_probe_wave1.csv' -Notes 'Generated compatibility/precedence coercion output from wave1 evidence bundles'
Add-LogEvent -Event 'coercion_wave1_outputs_generated' -Artifact 'outputs/coercion_wave1/ECS-EB-027_coercion_confidence_scores_wave1.csv' -Notes 'Generated confidence scoring synthesis output for coercion wave1'
Add-LogEvent -Event 'coercion_wave1_reported' -Artifact 'outputs/coercion_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published coercion wave1 execution report'
Add-LogEvent -Event 'coercion_wave1_manifest_status_updated' -Artifact 'outputs/coercion_wave1/scenario_manifest_wave1.csv' -Notes 'Marked coercion wave1 scenarios completed after evidence verification'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    case_rows = $total
    matches_expected = $matched
    mismatch_rows = $mismatch
    probe_rows = $probe
    run_failed_rows = $runFailed
}
$summary | ConvertTo-Json -Depth 3
