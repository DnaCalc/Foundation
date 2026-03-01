Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'
$caseRegistryPath = Join-Path $waveDir 'reopen_case_registry_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$eb044Path = Join-Path $waveDir 'ECS-EB-044_reopen_determinism_probe_wave1.csv'
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
        $status = if ($c.PSObject.Properties.Name -contains 'status') { To-ScalarString $c.status } else { '' }
        $value = if ($c.PSObject.Properties.Name -contains 'value') { To-ScalarString $c.value } else { '' }
        $timeline += [pscustomobject]@{
            step = To-ScalarString $step.step
            operation = To-ScalarString $step.operation
            status = $status
            value = $value
            formula = if ($c.PSObject.Properties.Name -contains 'formula') { To-ScalarString $c.formula } else { '' }
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
    $final = $null
    if (@($timeline).Count -gt 0) { $final = $timeline[@($timeline).Count - 1] }
    $finalValue = if ($final) { To-ScalarString $final.value } else { '' }

    $observedValues = @(
        $timeline |
            Where-Object { $_.status -ne 'workbook_closed' -and -not [string]::IsNullOrWhiteSpace($_.value) } |
            Select-Object -ExpandProperty value
    )
    $uniqueValues = @($observedValues | Select-Object -Unique)

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
            'stable_replay' {
                if ($uniqueValues.Count -le 1 -and $uniqueValues.Count -ge 1) {
                    $resultStatus = 'matches_expected'
                    $matchBasis = 'stable_replay_signal'
                }
                else {
                    $resultStatus = 'mismatch'
                    $matchBasis = 'replay_instability'
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
        task_id = 'ECS-EB-044'
        target = $target
        expected_kind = $expectedKind
        expected_value = $expectedValue
        run_exit_status = $runExit
        final_value = $finalValue
        unique_observed_value_count = $uniqueValues.Count
        observed_value_sequence = ($observedValues -join ' -> ')
        result_status = $resultStatus
        match_basis = $matchBasis
        evidence_bundle_ref = (Join-Path 'evidence' $scenarioId)
        notes = $case.notes
    }
}

$rows | Sort-Object case_id | Export-Csv -Path $eb044Path -NoTypeInformation

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
$runFailed = @($rows | Where-Object { $_.result_status -eq 'run_failed' }).Count

$reportLines = @(
    '# Reopen Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed `ECS-EB-044` reopen-determinism probe scenarios.',
    '',
    '## Execution status',
    "- Case rows: $total",
    "- Matches expected: $matched",
    "- Mismatch rows: $mismatch",
    "- Run-failed rows: $runFailed",
    '',
    '## Artifacts',
    '- `ECS-EB-044_reopen_determinism_probe_wave1.csv`',
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

Add-LogEvent -Event 'reopen_wave1_seeded' -Artifact 'outputs/reopen_wave1/reopen_case_registry_wave1.csv' -Notes 'Seeded reopen wave1 case registry and scenario manifest for ECS-EB-044'
Add-LogEvent -Event 'reopen_wave1_outputs_generated' -Artifact 'outputs/reopen_wave1/ECS-EB-044_reopen_determinism_probe_wave1.csv' -Notes 'Generated reopen determinism probe output from wave1 evidence bundles'
Add-LogEvent -Event 'reopen_wave1_reported' -Artifact 'outputs/reopen_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published reopen wave1 execution report'
Add-LogEvent -Event 'reopen_wave1_manifest_status_updated' -Artifact 'outputs/reopen_wave1/scenario_manifest_wave1.csv' -Notes 'Marked reopen wave1 scenarios completed after evidence verification'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    case_rows = $total
    matches_expected = $matched
    mismatch_rows = $mismatch
    run_failed_rows = $runFailed
}
$summary | ConvertTo-Json -Depth 3
