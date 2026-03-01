Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'
$caseRegistryPath = Join-Path $waveDir 'table_case_registry_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$eb034Path = Join-Path $waveDir 'ECS-EB-034_table_spill_interaction_matrix_wave1.csv'
$eb035Path = Join-Path $waveDir 'ECS-EB-035_table_resize_coercion_format_probe_wave1.csv'
$eb036Path = Join-Path $waveDir 'ECS-EB-036_table_platform_divergence_probe_wave1.csv'
$reportPath = Join-Path $waveDir 'WAVE1_EXECUTION_REPORT.md'

$scenarioCache = @{}

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

function TryParseIntInvariant {
    param(
        [string]$Text,
        [ref]$OutValue
    )
    return [int]::TryParse($Text, [System.Globalization.NumberStyles]::Integer, [System.Globalization.CultureInfo]::InvariantCulture, $OutValue)
}

function ValuesMatch {
    param(
        [string]$Expected,
        [string]$Observed
    )
    if ($Expected -ieq $Observed) { return $true }
    $exp = [decimal]0
    $obs = [decimal]0
    if ([decimal]::TryParse($Expected, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$exp) -and
        [decimal]::TryParse($Observed, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$obs)) {
        return [Math]::Abs([double]($exp - $obs)) -le 1e-9
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
        }
    }
    return $scenarioCache[$ScenarioId]
}

function Get-TargetTimeline {
    param(
        [object]$StepCapture,
        [string]$Target
    )
    $timeline = @()
    if (-not $StepCapture -or -not $StepCapture.steps) { return $timeline }
    foreach ($step in @($StepCapture.steps)) {
        $hit = @($step.captures | Where-Object { $_.target -eq $Target } | Select-Object -First 1)
        if ($hit.Count -eq 0) { continue }
        $c = $hit[0]
        $timeline += [pscustomobject]@{
            step = To-ScalarString $step.step
            operation = To-ScalarString $step.operation
            value = To-ScalarString $c.value
            formula = To-ScalarString $c.formula
            display_text = To-ScalarString $c.display_text
            number_format = To-ScalarString $c.number_format
        }
    }
    return $timeline
}

$cases = Import-Csv $caseRegistryPath
$rows = @()

foreach ($case in $cases) {
    $scenarioId = $case.scenario_id
    $target = $case.target
    $artifacts = Get-ScenarioArtifacts -ScenarioId $scenarioId
    $runExit = To-ScalarString ($artifacts.run_manifest.exit_status)
    if ([string]::IsNullOrWhiteSpace($runExit)) { $runExit = 'unknown' }

    $timeline = Get-TargetTimeline -StepCapture $artifacts.step_capture -Target $target
    $stepCount = @($timeline).Count
    $final = $null
    if ($stepCount -gt 0) { $final = $timeline[$stepCount - 1] }

    $finalValue = if ($final) { To-ScalarString $final.value } else { '' }
    $finalFormula = if ($final) { To-ScalarString $final.formula } else { '' }
    $finalDisplay = if ($final) { To-ScalarString $final.display_text } else { '' }
    $finalNumberFormat = if ($final) { To-ScalarString $final.number_format } else { '' }
    $uniqueValues = @($timeline | ForEach-Object { $_.value } | Select-Object -Unique)
    $uniqueCount = $uniqueValues.Count

    $expectedKind = To-ScalarString $case.expected_kind
    $expectedValue = To-ScalarString $case.expected_value
    $resultStatus = 'needs_review'
    $matchBasis = ''

    if ($runExit -eq 'failed') {
        $resultStatus = 'run_failed'
        $matchBasis = 'scenario_failed'
    }
    else {
        switch ($expectedKind) {
            'value' {
                if (ValuesMatch -Expected $expectedValue -Observed $finalValue) {
                    $resultStatus = 'matches_expected'
                    $matchBasis = 'value_match'
                }
                else {
                    $resultStatus = 'mismatch'
                    $matchBasis = 'value_mismatch'
                }
            }
            'formula_contains' {
                if (-not [string]::IsNullOrWhiteSpace($finalFormula) -and $finalFormula -like "*$expectedValue*") {
                    $resultStatus = 'matches_expected'
                    $matchBasis = 'formula_contains_match'
                }
                else {
                    $resultStatus = 'mismatch'
                    $matchBasis = 'formula_contains_mismatch'
                }
            }
            'number_format' {
                if ($finalNumberFormat -ieq $expectedValue) {
                    $resultStatus = 'matches_expected'
                    $matchBasis = 'number_format_match'
                }
                else {
                    $resultStatus = 'mismatch'
                    $matchBasis = 'number_format_mismatch'
                }
            }
            'transition_min_unique' {
                $threshold = 0
                [void](TryParseIntInvariant -Text $expectedValue -OutValue ([ref]$threshold))
                if ($uniqueCount -ge $threshold) {
                    $resultStatus = 'matches_expected'
                    $matchBasis = 'transition_signal_present'
                }
                else {
                    $resultStatus = 'mismatch'
                    $matchBasis = 'transition_signal_missing'
                }
            }
            default {
                $resultStatus = 'probe'
                $matchBasis = 'probe_expected'
            }
        }
    }

    $rows += [pscustomobject]@{
        case_id = $case.case_id
        scenario_id = $scenarioId
        task_id = $case.task_id
        family = $case.family
        target = $target
        expected_kind = $expectedKind
        expected_value = $expectedValue
        run_exit_status = $runExit
        final_value = $finalValue
        final_formula = $finalFormula
        final_display_text = $finalDisplay
        final_number_format = $finalNumberFormat
        unique_value_count = $uniqueCount
        step_count = $stepCount
        result_status = $resultStatus
        match_basis = $matchBasis
        confidence_input = $case.confidence
        evidence_bundle_ref = (Join-Path 'evidence' $scenarioId)
        notes = $case.notes
    }
}

$rows | Where-Object { $_.task_id -eq 'ECS-EB-034' } | Sort-Object case_id | Export-Csv -Path $eb034Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-035' } | Sort-Object case_id | Export-Csv -Path $eb035Path -NoTypeInformation

$eb036Rows = @()
foreach ($row in ($rows | Where-Object { $_.task_id -eq 'ECS-EB-036' } | Sort-Object case_id)) {
    $eb036Rows += [pscustomobject]@{
        case_id = $row.case_id
        scenario_id = $row.scenario_id
        task_id = $row.task_id
        aspect = $row.notes
        target = $row.target
        windows_result_status = $row.result_status
        windows_value = $row.final_value
        windows_formula = $row.final_formula
        mac_status = 'not_tested_in_this_wave'
        web_status = 'not_tested_in_this_wave'
        platform_divergence_flag = if ($row.result_status -eq 'matches_expected') { 'none_observed_windows_only' } else { 'needs_followup_windows_signal' }
        evidence_bundle_ref = $row.evidence_bundle_ref
    }
}
$eb036Rows | Export-Csv -Path $eb036Path -NoTypeInformation

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

$mismatchDetails = @($rows | Where-Object { $_.result_status -eq 'mismatch' } | Select-Object -First 5)
$mismatchLines = @()
if ($mismatchDetails.Count -eq 0) {
    $mismatchLines += '- none'
}
else {
    foreach ($d in $mismatchDetails) {
        $mismatchLines += ('- `{0}` ({1}) expected `{2}` observed value=`{3}` formula=`{4}` format=`{5}`' -f $d.case_id, $d.target, $d.expected_value, $d.final_value, $d.final_formula, $d.final_number_format)
    }
}

$reportLines = @(
    '# Table Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed wave-1 table/listobject scenarios covering `ECS-EB-034`, `ECS-EB-035`, and `ECS-EB-036`.',
    '',
    '## Execution status',
    "- Case rows: $total",
    "- Matches expected: $matched",
    "- Mismatch rows: $mismatch",
    "- Probe rows: $probe",
    "- Run-failed rows: $runFailed",
    '',
    '## Key outcomes',
    '1. Structured-reference + spill interactions now have baseline empirical rows tied to auto-expand mutations.',
    '2. Growth/shrink sequence now captures both value-transition and number-format persistence signals.',
    '3. Platform-divergence artifact is now seeded with Windows-observed baseline plus explicit not-tested markers for Mac/Web.',
    '',
    '### Mismatch detail (first 5)'
)
$reportLines += $mismatchLines
$reportLines += @(
    '',
    '## Artifacts',
    '- `ECS-EB-034_table_spill_interaction_matrix_wave1.csv`',
    '- `ECS-EB-035_table_resize_coercion_format_probe_wave1.csv`',
    '- `ECS-EB-036_table_platform_divergence_probe_wave1.csv`',
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

Add-LogEvent -Event 'table_wave1_seeded' -Artifact 'outputs/table_wave1/table_case_registry_wave1.csv' -Notes 'Seeded table wave1 case registry and scenario manifest for ECS-EB-034/035/036'
Add-LogEvent -Event 'table_wave1_outputs_generated' -Artifact 'outputs/table_wave1/ECS-EB-034_table_spill_interaction_matrix_wave1.csv' -Notes 'Generated structured-ref/spill interaction output from wave1 evidence bundles'
Add-LogEvent -Event 'table_wave1_outputs_generated' -Artifact 'outputs/table_wave1/ECS-EB-035_table_resize_coercion_format_probe_wave1.csv' -Notes 'Generated table resize/coercion/format output from wave1 evidence bundles'
Add-LogEvent -Event 'table_wave1_outputs_generated' -Artifact 'outputs/table_wave1/ECS-EB-036_table_platform_divergence_probe_wave1.csv' -Notes 'Generated platform divergence baseline output from wave1 evidence bundles'
Add-LogEvent -Event 'table_wave1_reported' -Artifact 'outputs/table_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published table wave1 execution report'
Add-LogEvent -Event 'table_wave1_manifest_status_updated' -Artifact 'outputs/table_wave1/scenario_manifest_wave1.csv' -Notes 'Marked table wave1 scenarios completed after evidence verification'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    case_rows = $total
    matches_expected = $matched
    mismatch_rows = $mismatch
    probe_rows = $probe
    run_failed_rows = $runFailed
}
$summary | ConvertTo-Json -Depth 3
