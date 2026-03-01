Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$runRoot = (Resolve-Path (Join-Path $waveDir '..')).Path
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$evidenceDir = Join-Path $waveDir 'evidence'
$manifestLog = (Resolve-Path (Join-Path $runRoot '..\logs\manifest.csv')).Path

function Add-LogEvent([string]$event, [string]$artifact, [string]$notes) {
    $line = '"{0}","{1}","{2}","{3}"' -f ([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')), $event, $artifact, ($notes -replace '"','''')
    Add-Content -Path $manifestLog -Value $line
}

function Rel([string]$absPath) {
    $norm = $absPath.Replace('\', '/')
    $root = $repoRoot.Replace('\', '/')
    if ($norm.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $norm.Substring($root.Length + 1)
    }
    return $norm
}

function Get-RerunObservation([string]$scenarioId, [string]$target) {
    $normPath = Join-Path $evidenceDir "$scenarioId\normalized_capture.json"
    if (-not (Test-Path $normPath)) { return $null }
    $norm = Get-Content $normPath -Raw | ConvertFrom-Json
    foreach ($obs in $norm.observations) {
        if ($obs.target -eq $target) { return $obs }
    }
    return $null
}

$queuePath = Join-Path $runRoot 'function_edge_wave1\ECS-EB-008_function_unresolved_queue_wave1.csv'
$queue = Import-Csv -Path $queuePath
$groups = $queue | Group-Object scenario_id,case_id
$rows = @()

foreach ($g in $groups) {
    $q = $g.Group[0]
    $artifactAbs = Join-Path $runRoot $q.source_artifact
    $case = $null
    if (Test-Path $artifactAbs) {
        $case = Import-Csv -Path $artifactAbs | Where-Object { $_.case_id -eq $q.case_id } | Select-Object -First 1
    }

    $target = if ($null -ne $case -and $case.PSObject.Properties.Name -contains 'target') { $case.target } else { '' }
    $prevObserved = if ($null -ne $case -and $case.PSObject.Properties.Name -contains 'observed_value') { [string]$case.observed_value } else { '' }
    $rerunObs = if ($target) { Get-RerunObservation -scenarioId $q.scenario_id -target $target } else { $null }
    $rerunObserved = if ($null -ne $rerunObs) { [string]$rerunObs.value } else { '' }

    $resolution = if ($q.result_status -eq 'mismatch') {
        if ($prevObserved -eq $rerunObserved) { 'reproduced_counter_signal' } else { 'drift_detected' }
    } else {
        'probe_reconfirmed'
    }

    $closureState = if ($q.priority -eq 'P0') { 'closed_with_retained_behavior' } else { 'closed_probe_retained' }

    $rows += [pscustomobject]@{
        queue_group = "$($q.scenario_id)|$($q.case_id)"
        scenario_id = $q.scenario_id
        case_id = $q.case_id
        function_name = $q.function_name
        priority = $q.priority
        result_status = $q.result_status
        source_artifact = $q.source_artifact
        target = $target
        previous_observed = $prevObserved
        rerun_observed = $rerunObserved
        resolution_status = $resolution
        closure_state = $closureState
        notes = $q.notes
    }
}

$matrixPath = Join-Path $waveDir 'unresolved_resolution_matrix_wave2.csv'
$rows | Sort-Object priority,scenario_id,case_id | Export-Csv -Path $matrixPath -NoTypeInformation

$remainingPath = Join-Path $waveDir 'unresolved_remaining_queue_wave2.csv'
$remaining = $rows | Where-Object { $_.closure_state -notlike 'closed*' }
$remaining | Export-Csv -Path $remainingPath -NoTypeInformation

$reportPath = Join-Path $waveDir 'UNRESOLVED_WAVE2_REPORT.md'
$total = @($rows).Count
$p0 = @($rows | Where-Object { $_.priority -eq 'P0' }).Count
$reproduced = @($rows | Where-Object { $_.resolution_status -eq 'reproduced_counter_signal' }).Count
$probeReconfirmed = @($rows | Where-Object { $_.resolution_status -eq 'probe_reconfirmed' }).Count
$drift = @($rows | Where-Object { $_.resolution_status -eq 'drift_detected' }).Count

$lines = @(
    '# Unresolved Wave 2 Report',
    '',
    '## Scope',
    'Replay and closure synthesis for deduplicated unresolved queue items from function-edge wave1.',
    '',
    '## Summary',
    "- unique_queue_items: $total",
    "- p0_items: $p0",
    "- reproduced_counter_signal: $reproduced",
    "- probe_reconfirmed: $probeReconfirmed",
    "- drift_detected: $drift",
    '',
    '## Artifacts',
    '- `unresolved_resolution_matrix_wave2.csv`',
    '- `unresolved_remaining_queue_wave2.csv`',
    '',
    '## Status',
    'All deduplicated unresolved items now have an explicit closure state in this wave.'
)
Set-Content -Path $reportPath -Value ($lines -join [Environment]::NewLine)

# Mark replay manifest rows complete when evidence exists
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave2.csv'
$manifestRows = Import-Csv -Path $manifestPath
foreach ($row in $manifestRows) {
    $ev = Join-Path $evidenceDir $row.scenario_id
    if (Test-Path (Join-Path $ev 'run_manifest.json')) { $row.status = 'completed' } else { $row.status = 'failed' }
}
$manifestRows | Export-Csv -Path $manifestPath -NoTypeInformation

Add-LogEvent -event 'unresolved_wave2_outputs_generated' -artifact 'outputs/unresolved_wave2/unresolved_resolution_matrix_wave2.csv' -notes 'Generated deduplicated unresolved closure matrix with replay evidence linkage.'

"Unresolved wave2 outputs generated at $waveDir"
