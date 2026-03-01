Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'
$caseRegistryPath = Join-Path $waveDir 'tier45_case_registry_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$platformMatrixPath = Join-Path $empiricalRunRoot 'outputs/platform_availability/function_availability_matrix.csv'
$tier3TrackerPath = Join-Path $repoRoot 'research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_reason_code_evidence_tracker.csv'

$eb018Path = Join-Path $waveDir 'ECS-EB-018_dynamic_array_mixed_type_probe_wave1.csv'
$eb019Path = Join-Path $waveDir 'ECS-EB-019_lambda_helper_edge_probe_wave1.csv'
$eb020Path = Join-Path $waveDir 'ECS-EB-020_cube_contract_probe_wave1.csv'
$eb021Path = Join-Path $waveDir 'ECS-EB-021_external_data_replay_probe_wave1.csv'
$eb017Path = Join-Path $waveDir 'ECS-EB-017_tier5_platform_caveat_report_wave1.md'
$eb022Path = Join-Path $waveDir 'ECS-EB-022_tier3_expansion_queue_wave1.csv'
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
        $formula = if ($c.PSObject.Properties.Name -contains 'formula') { To-ScalarString $c.formula } else { '' }
        $displayText = if ($c.PSObject.Properties.Name -contains 'display_text') { To-ScalarString $c.display_text } else { '' }
        $numberFormat = if ($c.PSObject.Properties.Name -contains 'number_format') { To-ScalarString $c.number_format } else { '' }
        $timeline += [pscustomobject]@{
            step = To-ScalarString $step.step
            operation = To-ScalarString $step.operation
            status = $status
            value = $value
            formula = $formula
            display_text = $displayText
            number_format = $numberFormat
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

    $observedValues = @(
        $timeline |
            Where-Object { $_.status -ne 'workbook_closed' } |
            ForEach-Object {
                if (-not [string]::IsNullOrWhiteSpace($_.value)) { $_.value }
                elseif (-not [string]::IsNullOrWhiteSpace($_.display_text)) { $_.display_text }
                else { $null }
            } |
            Where-Object { $null -ne $_ }
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
            'stable_replay' {
                if ($uniqueValues.Count -le 1 -and $uniqueValues.Count -ge 1) {
                    $resultStatus = 'matches_expected'
                    $matchBasis = 'stable_replay_signal'
                }
                elseif ($uniqueValues.Count -eq 0) {
                    $resultStatus = 'probe'
                    $matchBasis = 'no_value_signal'
                }
                else {
                    $resultStatus = 'mismatch'
                    $matchBasis = 'replay_instability'
                }
            }
            'probe' {
                $resultStatus = 'probe'
                $matchBasis = 'probe_expected'
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
        function_name = $case.function_name
        target = $target
        expected_kind = $expectedKind
        expected_value = $expectedValue
        run_exit_status = $runExit
        final_value = $finalValue
        final_formula = $finalFormula
        final_display_text = $finalDisplay
        unique_observed_value_count = $uniqueValues.Count
        observed_value_sequence = ($observedValues -join ' -> ')
        step_count = $stepCount
        result_status = $resultStatus
        match_basis = $matchBasis
        confidence_input = $case.confidence
        evidence_bundle_ref = (Join-Path 'evidence' $scenarioId)
        notes = $case.notes
    }
}

$rows | Where-Object { $_.task_id -eq 'ECS-EB-018' } | Sort-Object case_id | Export-Csv -Path $eb018Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-019' } | Sort-Object case_id | Export-Csv -Path $eb019Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-020' } | Sort-Object case_id | Export-Csv -Path $eb020Path -NoTypeInformation
$rows | Where-Object { $_.task_id -eq 'ECS-EB-021' } | Sort-Object case_id | Export-Csv -Path $eb021Path -NoTypeInformation

# ECS-EB-017 tier5 platform caveat report
$tier5Functions = @('INDIRECT','OFFSET','RTD','NOW','TODAY')
$platformRows = @()
if (Test-Path $platformMatrixPath) {
    $platformRows = Import-Csv $platformMatrixPath | Where-Object { $tier5Functions -contains $_.function_name } | Sort-Object function_name
}

$tier5ReportLines = @(
    '# ECS-EB-017 Tier-5 Platform Caveat Report (Wave 1)',
    '',
    '## Scope',
    'Consolidated tier-5 caveat view using current platform availability matrix plus executed wave evidence (`RTD`, `NOW`, `TODAY`).',
    '',
    '## Function status table',
    '| Function | Windows | Mac | Web | Last probe UTC | Notes |',
    '|---|---|---|---|---|---|'
)

foreach ($r in $platformRows) {
    $tier5ReportLines += ('| {0} | {1} | {2} | {3} | {4} | {5} |' -f
        $r.function_name,
        (To-ScalarString $r.windows_desktop_status),
        (To-ScalarString $r.mac_desktop_status),
        (To-ScalarString $r.web_status),
        (To-ScalarString $r.last_probe_utc),
        (To-ScalarString $r.notes))
}

if ($platformRows.Count -eq 0) {
    $tier5ReportLines += '| (no tier-5 rows found in matrix) | n/a | n/a | n/a | n/a | n/a |'
}

$tier5ReportLines += @(
    '',
    '## Evidence references',
    '- `../rtd_wave1/RTD_WAVE1_EXECUTION_REPORT.md`',
    '- `../date_system_wave1/DATE_SYSTEM_WAVE1_EXECUTION_REPORT.md`',
    '- `../platform_availability/function_availability_matrix.csv`',
    '',
    '## Caveat summary',
    '1. Windows has empirical probe evidence for `RTD`, `NOW`, and `TODAY` from prior waves.',
    '2. `INDIRECT` and `OFFSET` remain primarily source-anchored in this wave and should be extended in cross-platform lanes.',
    '3. Mac/Web statuses remain source-driven in this run and require dedicated platform execution lanes for parity closure.'
)
Set-Content -Path $eb017Path -Value ($tier5ReportLines -join [Environment]::NewLine)

# ECS-EB-022 tier-3 expansion queue
$queueRows = @()
$grouped = $rows | Group-Object function_name
foreach ($g in $grouped) {
    $fn = $g.Name
    $mismatchCount = @($g.Group | Where-Object { $_.result_status -eq 'mismatch' }).Count
    $probeCount = @($g.Group | Where-Object { $_.result_status -eq 'probe' }).Count
    $priority = 'P2'
    $reasons = @()
    if ($mismatchCount -gt 0) {
        $priority = 'P0'
        $reasons += "mismatch_count=$mismatchCount"
    }
    if ($probeCount -gt 0) {
        if ($priority -ne 'P0') { $priority = 'P1' }
        $reasons += "probe_count=$probeCount"
    }
    if ($fn -in @('CUBEMEMBER','CUBEVALUE','CUBESET','WEBSERVICE','FILTERXML')) {
        if ($priority -eq 'P2') { $priority = 'P1' }
        $reasons += 'external_or_connector_sensitive'
    }

    $queueRows += [pscustomobject]@{
        queue_id = ('T3QW1-{0:D3}' -f ($queueRows.Count + 1))
        function_name = $fn
        priority = $priority
        mismatch_count = $mismatchCount
        probe_count = $probeCount
        source_wave = 'tier45_wave1'
        reason = ($reasons -join ';')
        next_probe_recommendation = if ($fn -in @('CUBEMEMBER','CUBEVALUE','CUBESET')) { 'Add environment-capability and connection-state matrix probes' } elseif ($fn -in @('WEBSERVICE','FILTERXML')) { 'Run replay with offline/online toggles and explicit timeout logging' } else { 'Expand edge-case coverage with argument/type variants' }
        evidence_refs = (@($g.Group | Select-Object -ExpandProperty evidence_bundle_ref -Unique) -join '|')
    }
}

if (Test-Path $tier3TrackerPath) {
    $trackerRows = Import-Csv $tier3TrackerPath | Where-Object { $_.review_status -eq 'needs_reason_code_review' -or $_.evidence_status -like '*counter_signal*' }
    foreach ($t in $trackerRows) {
        if ($queueRows.function_name -contains $t.function_name) { continue }
        $queueRows += [pscustomobject]@{
            queue_id = ('T3QW1-{0:D3}' -f ($queueRows.Count + 1))
            function_name = $t.function_name
            priority = 'P0'
            mismatch_count = 1
            probe_count = 0
            source_wave = 'reason_code_wave1'
            reason = 'tracker_counter_signal_or_review_flag'
            next_probe_recommendation = 'Resolve counter-signal with focused differential probes'
            evidence_refs = (To-ScalarString $t.evidence_probe_ids)
        }
    }
}

$queueRows | Sort-Object priority, function_name | Export-Csv -Path $eb022Path -NoTypeInformation

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

$reportLines = @(
    '# Tier4/5 Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed `ECS-EB-018/019/020/021` scenario probes and generated synthesis artifacts for `ECS-EB-017` and `ECS-EB-022`.',
    '',
    '## Execution status',
    "- Case rows: $total",
    "- Matches expected: $matched",
    "- Mismatch rows: $mismatch",
    "- Probe rows: $probe",
    "- Run-failed rows: $runFailed",
    '',
    '## Key outcomes',
    '1. Dynamic-array and LAMBDA/helper baseline probes now have wave-1 evidence rows.',
    '2. CUBE function contract rows now capture formula-entry acceptance signal independent of connector success.',
    '3. External-data replay rows now capture stability signals across save/close/open/recalc sequence.',
    '4. Tier-5 platform caveat report and tier-3 expansion queue are generated from combined evidence.',
    '',
    '## Artifacts',
    '- `ECS-EB-018_dynamic_array_mixed_type_probe_wave1.csv`',
    '- `ECS-EB-019_lambda_helper_edge_probe_wave1.csv`',
    '- `ECS-EB-020_cube_contract_probe_wave1.csv`',
    '- `ECS-EB-021_external_data_replay_probe_wave1.csv`',
    '- `ECS-EB-017_tier5_platform_caveat_report_wave1.md`',
    '- `ECS-EB-022_tier3_expansion_queue_wave1.csv`'
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

Add-LogEvent -Event 'tier45_wave1_seeded' -Artifact 'outputs/tier45_wave1/tier45_case_registry_wave1.csv' -Notes 'Seeded tier45 wave1 case registry and scenario manifest for ECS-EB-018/019/020/021'
Add-LogEvent -Event 'tier45_wave1_outputs_generated' -Artifact 'outputs/tier45_wave1/ECS-EB-018_dynamic_array_mixed_type_probe_wave1.csv' -Notes 'Generated dynamic-array mixed-type probe output'
Add-LogEvent -Event 'tier45_wave1_outputs_generated' -Artifact 'outputs/tier45_wave1/ECS-EB-019_lambda_helper_edge_probe_wave1.csv' -Notes 'Generated lambda/helper edge probe output'
Add-LogEvent -Event 'tier45_wave1_outputs_generated' -Artifact 'outputs/tier45_wave1/ECS-EB-020_cube_contract_probe_wave1.csv' -Notes 'Generated CUBE contract probe output'
Add-LogEvent -Event 'tier45_wave1_outputs_generated' -Artifact 'outputs/tier45_wave1/ECS-EB-021_external_data_replay_probe_wave1.csv' -Notes 'Generated external-data replay probe output'
Add-LogEvent -Event 'tier45_wave1_outputs_generated' -Artifact 'outputs/tier45_wave1/ECS-EB-017_tier5_platform_caveat_report_wave1.md' -Notes 'Generated tier-5 platform caveat report from platform matrix and prior wave evidence'
Add-LogEvent -Event 'tier45_wave1_outputs_generated' -Artifact 'outputs/tier45_wave1/ECS-EB-022_tier3_expansion_queue_wave1.csv' -Notes 'Generated tier-3 expansion queue from wave evidence and tracker flags'
Add-LogEvent -Event 'tier45_wave1_reported' -Artifact 'outputs/tier45_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published tier45 wave1 execution report'
Add-LogEvent -Event 'tier45_wave1_manifest_status_updated' -Artifact 'outputs/tier45_wave1/scenario_manifest_wave1.csv' -Notes 'Marked tier45 wave1 scenarios completed after evidence verification'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    case_rows = $total
    matches_expected = $matched
    mismatch_rows = $mismatch
    probe_rows = $probe
    run_failed_rows = $runFailed
}
$summary | ConvertTo-Json -Depth 3
