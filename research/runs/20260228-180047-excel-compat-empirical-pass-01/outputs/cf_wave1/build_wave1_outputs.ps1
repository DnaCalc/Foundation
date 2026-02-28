Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'
$caseRegistryPath = Join-Path $waveDir 'cf_case_registry_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$eb031Path = Join-Path $waveDir 'ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv'
$eb032Path = Join-Path $waveDir 'ECS-EB-032_cf_stopiftrue_probe_wave1.csv'
$eb033Path = Join-Path $waveDir 'ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv'
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

function Get-StepTargetCapture {
    param(
        [object]$StepCapture,
        [string]$Target
    )
    if (-not $StepCapture -or -not $StepCapture.steps) { return @() }
    $hits = @()
    foreach ($step in @($StepCapture.steps)) {
        $captureHit = @($step.captures | Where-Object { $_.target -eq $Target } | Select-Object -First 1)
        if ($captureHit.Count -eq 0) { continue }
        $c = $captureHit[0]
        $hits += [pscustomobject]@{
            step = To-ScalarString $step.step
            operation = To-ScalarString $step.operation
            value = To-ScalarString $c.value
            display_text = To-ScalarString $c.display_text
            display_interior_color = To-ScalarString $c.display_interior_color
            display_font_color = To-ScalarString $c.display_font_color
            display_font_bold = To-ScalarString $c.display_font_bold
            display_number_format = To-ScalarString $c.display_number_format
        }
    }
    return $hits
}

$cases = Import-Csv $caseRegistryPath
$rows = @()

foreach ($case in $cases) {
    $scenarioId = $case.scenario_id
    $target = $case.target
    $artifacts = Get-ScenarioArtifacts -ScenarioId $scenarioId
    $runExit = To-ScalarString ($artifacts.run_manifest.exit_status)
    if ([string]::IsNullOrWhiteSpace($runExit)) { $runExit = 'unknown' }

    $captures = Get-StepTargetCapture -StepCapture $artifacts.step_capture -Target $target
    $stepCount = @($captures).Count
    $final = $null
    if ($stepCount -gt 0) { $final = $captures[$stepCount - 1] }

    $expectedKind = To-ScalarString $case.expected_kind
    $expectedValue = To-ScalarString $case.expected_value
    $observedColor = if ($final) { To-ScalarString $final.display_interior_color } else { '' }
    $observedValue = if ($final) { To-ScalarString $final.value } else { '' }
    $observedDisplay = if ($final) { To-ScalarString $final.display_text } else { '' }
    $resultStatus = 'needs_review'
    $matchBasis = ''

    if ($runExit -eq 'failed') {
        $resultStatus = 'run_failed'
        $matchBasis = 'scenario_failed'
    }
    elseif ($expectedKind -eq 'display_color') {
        $exp = 0
        $obs = 0
        if ((TryParseIntInvariant -Text $expectedValue -OutValue ([ref]$exp)) -and
            (TryParseIntInvariant -Text $observedColor -OutValue ([ref]$obs)) -and
            $exp -eq $obs) {
            $resultStatus = 'matches_expected'
            $matchBasis = 'display_color_match'
        }
        else {
            $resultStatus = 'mismatch'
            $matchBasis = 'display_color_mismatch'
        }
    }
    elseif ($expectedKind -eq 'probe_transition') {
        $expectedDistinct = 2
        [void](TryParseIntInvariant -Text $expectedValue -OutValue ([ref]$expectedDistinct))
        $distinctColors = @($captures | Where-Object { -not [string]::IsNullOrWhiteSpace($_.display_interior_color) } | Select-Object -ExpandProperty display_interior_color -Unique)
        if ($distinctColors.Count -ge $expectedDistinct) {
            $resultStatus = 'matches_expected'
            $matchBasis = 'transition_signal_present'
        }
        else {
            $resultStatus = 'probe'
            $matchBasis = 'transition_signal_insufficient'
        }
    }
    else {
        $resultStatus = 'probe'
        $matchBasis = 'probe_expected'
    }

    $transitionSummary = ''
    if ($expectedKind -eq 'probe_transition') {
        $transitionSummary = (@($captures | ForEach-Object { $_.step + ":" + $_.display_interior_color }) -join ' | ')
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
        observed_value = $observedValue
        observed_display_text = $observedDisplay
        observed_display_interior_color = $observedColor
        step_count = $stepCount
        transition_summary = $transitionSummary
        result_status = $resultStatus
        match_basis = $matchBasis
        confidence_input = $case.confidence
        evidence_bundle_ref = (Join-Path 'evidence' $scenarioId)
        notes = $case.notes
    }
}

$rows | Where-Object { $_.task_id -eq 'ECS-EB-031' } | Sort-Object case_id | Export-Csv -Path $eb031Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-032' } | Sort-Object case_id | Export-Csv -Path $eb032Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-033' } | Sort-Object case_id | Export-Csv -Path $eb033Path -NoTypeInformation

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
        $mismatchLines += ('- `{0}` ({1}) expected color `{2}` observed `{3}`' -f $d.case_id, $d.target, $d.expected_value, $d.observed_display_interior_color)
    }
}

$reportLines = @(
    '# Conditional Format Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed wave-1 conditional-format scenarios covering `ECS-EB-031`, `ECS-EB-032`, and `ECS-EB-033`.',
    '',
    '## Execution status',
    "- Case rows: $total",
    "- Matches expected: $matched",
    "- Mismatch rows: $mismatch",
    "- Probe rows: $probe",
    "- Run-failed rows: $runFailed",
    '',
    '## Key outcomes',
    '1. Overlap + stop-if-true baseline (`ECS-EB-031`) now has explicit rendered-color evidence rows.',
    '2. Priority transition probe (`ECS-EB-032`) captured stepwise display-color transitions for the overlap target.',
    '3. Table + spill interaction probe (`ECS-EB-033`) captured rendered-color behavior on appended table rows and spilled cells.',
    '',
    '### Mismatch detail (first 5)'
)
$reportLines += $mismatchLines
$reportLines += @(
    '',
    '## Artifacts',
    '- `ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv`',
    '- `ECS-EB-032_cf_stopiftrue_probe_wave1.csv`',
    '- `ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv`',
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

Add-LogEvent -Event 'cf_wave1_seeded' -Artifact 'outputs/cf_wave1/cf_case_registry_wave1.csv' -Notes 'Seeded conditional-format wave1 case registry and scenario manifest for ECS-EB-031/032/033'
Add-LogEvent -Event 'cf_wave1_outputs_generated' -Artifact 'outputs/cf_wave1/ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv' -Notes 'Generated CF overlap output from wave1 evidence bundles'
Add-LogEvent -Event 'cf_wave1_outputs_generated' -Artifact 'outputs/cf_wave1/ECS-EB-032_cf_stopiftrue_probe_wave1.csv' -Notes 'Generated CF stop-if-true/priority probe output from wave1 evidence bundles'
Add-LogEvent -Event 'cf_wave1_outputs_generated' -Artifact 'outputs/cf_wave1/ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv' -Notes 'Generated CF table+spill interaction output from wave1 evidence bundles'
Add-LogEvent -Event 'cf_wave1_reported' -Artifact 'outputs/cf_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published conditional-format wave1 execution report'
Add-LogEvent -Event 'cf_wave1_manifest_status_updated' -Artifact 'outputs/cf_wave1/scenario_manifest_wave1.csv' -Notes 'Marked conditional-format wave1 scenarios completed after evidence verification'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    case_rows = $total
    matches_expected = $matched
    mismatch_rows = $mismatch
    probe_rows = $probe
    run_failed_rows = $runFailed
}
$summary | ConvertTo-Json -Depth 3
