Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$outputsRoot = Join-Path $empiricalRunRoot 'outputs'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$eb042Path = Join-Path $waveDir 'ECS-EB-042_display_capture_schema_wave1.json'
$eb043Path = Join-Path $waveDir 'ECS-EB-043_calc_mode_transition_log_wave1.csv'
$eb044Path = Join-Path $waveDir 'ECS-EB-044_reopen_determinism_probe.csv'
$eb045Path = Join-Path $waveDir 'ECS-EB-045_empirical_divergence_minimization_wave1.md'
$eb047Path = Join-Path $waveDir 'ECS-EB-047_stepwise_capture_schema_wave1.json'
$eb048Path = Join-Path $waveDir 'ECS-EB-048_locale_execution_profile_wave1.json'
$reportPath = Join-Path $waveDir 'WAVE1_EXECUTION_REPORT.md'

New-Item -ItemType Directory -Force -Path $waveDir | Out-Null

function Read-JsonFile {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    return Get-Content $Path -Raw | ConvertFrom-Json
}

# ECS-EB-042 display capture schema
$displaySchema = [ordered]@{
    schema_id = 'urn:dna-calc:excel-compat:display-capture-schema:wave1'
    version = 'wave1'
    description = 'Display-focused capture overlay for formatting-sensitive probes.'
    required_fields = @(
        'target',
        'value',
        'display_text',
        'number_format',
        'interior_color',
        'font_color',
        'font_bold',
        'display_interior_color',
        'display_font_color',
        'display_font_bold',
        'display_number_format'
    )
    status_values = @('observed','capture_error','workbook_closed')
    notes = @(
        'display_* fields represent rendered visual state and may differ from base cell format fields.',
        'Use together with stepwise capture for precedence and transition analysis.'
    )
}
$displaySchema | ConvertTo-Json -Depth 10 | Set-Content -Path $eb042Path

# ECS-EB-043 calc-mode transition log
$runManifestFiles = Get-ChildItem -Path $outputsRoot -Filter 'run_manifest.json' -Recurse -File
$calcRows = @()
foreach ($f in $runManifestFiles) {
    $manifest = Read-JsonFile $f.FullName
    if (-not $manifest) { continue }
    $opTrace = @($manifest.operation_trace)
    $setOps = @($opTrace | Where-Object { $_.op -eq 'set_calc_mode' })
    $calcRows += [pscustomobject]@{
        run_id = [string]$manifest.run_id
        task_id = [string]$manifest.task_id
        scenario_id = [string]$manifest.scenario_id
        artifact_ref = ($f.FullName -replace [regex]::Escape($empiricalRunRoot + '\'), '')
        calc_mode_manifest = [string]$manifest.calc_mode
        set_calc_mode_op_count = $setOps.Count
        has_set_calc_mode_op = if ($setOps.Count -gt 0) { 'true' } else { 'false' }
        first_set_calc_mode_started_utc = if ($setOps.Count -gt 0) { [string]$setOps[0].started_utc } else { '' }
        last_set_calc_mode_finished_utc = if ($setOps.Count -gt 0) { [string]$setOps[$setOps.Count - 1].finished_utc } else { '' }
        run_exit_status = [string]$manifest.exit_status
    }
}
$calcRows | Sort-Object task_id, scenario_id, run_id | Export-Csv -Path $eb043Path -NoTypeInformation

# ECS-EB-044 canonical reopen determinism output (merged from reopen wave + tier45 replay cases)
$mergedReopenRows = @()
$reopenWavePath = Join-Path $outputsRoot 'reopen_wave1/ECS-EB-044_reopen_determinism_probe_wave1.csv'
if (Test-Path $reopenWavePath) {
    $mergedReopenRows += Import-Csv $reopenWavePath | ForEach-Object {
        [pscustomobject]@{
            source = 'reopen_wave1'
            case_id = $_.case_id
            scenario_id = $_.scenario_id
            target = $_.target
            expected_kind = $_.expected_kind
            expected_value = $_.expected_value
            final_value = $_.final_value
            unique_observed_value_count = $_.unique_observed_value_count
            result_status = $_.result_status
            match_basis = $_.match_basis
            evidence_bundle_ref = $_.evidence_bundle_ref
            notes = $_.notes
        }
    }
}
$tier45ReplayPath = Join-Path $outputsRoot 'tier45_wave1/ECS-EB-021_external_data_replay_probe_wave1.csv'
if (Test-Path $tier45ReplayPath) {
    $mergedReopenRows += Import-Csv $tier45ReplayPath | ForEach-Object {
        [pscustomobject]@{
            source = 'tier45_wave1'
            case_id = $_.case_id
            scenario_id = $_.scenario_id
            target = $_.target
            expected_kind = $_.expected_kind
            expected_value = $_.expected_value
            final_value = $_.final_value
            unique_observed_value_count = $_.unique_observed_value_count
            result_status = $_.result_status
            match_basis = $_.match_basis
            evidence_bundle_ref = $_.evidence_bundle_ref
            notes = $_.notes
        }
    }
}
$mergedReopenRows | Export-Csv -Path $eb044Path -NoTypeInformation

# ECS-EB-045 divergence minimization routine
$minimizationDoc = @'
# ECS-EB-045 Empirical Divergence Minimization Routine (Wave 1)

## Goal
Reduce any mismatch/counter-signal case to the smallest reproducible scenario while preserving observed divergence.

## Procedure
1. Freeze environment metadata:
   - record Excel build/hash and runner commit from run manifest.
2. Pin one target assertion:
   - choose exactly one failing case row and one target cell.
3. Remove non-essential writes:
   - iteratively delete unrelated setup writes; rerun after each deletion.
4. Remove non-essential operations:
   - iteratively prune operations not required to trigger divergence.
5. Collapse ranges:
   - shrink affected ranges to the minimal cell span that still reproduces behavior.
6. Normalize formula shape:
   - simplify nested expressions while preserving mismatch class.
7. Capture minimized evidence bundle:
   - include original and minimized scenario JSON side-by-side.
8. Classify divergence:
   - expectation error, environment-dependent behavior, or potential Excel variance.

## Output contract
- `minimized_scenario.json`
- `minimized_evidence/`
- `delta_notes.md` (what was removed and why)
- link back to original case id and evidence bundle.
'@
Set-Content -Path $eb045Path -Value $minimizationDoc

# ECS-EB-047 stepwise capture schema
$stepwiseSchema = [ordered]@{
    schema_id = 'urn:dna-calc:excel-compat:stepwise-capture-schema:wave1'
    version = 'wave1'
    description = 'Schema for operation-level before/after capture emitted in step_capture.json.'
    required_top_level = @('run_id','task_id','scenario_id','targets','steps')
    step_object = [ordered]@{
        required = @('step','operation','timestamp_utc','captures')
        capture_fields = @(
            'target',
            'status',
            'value',
            'formula',
            'display_text',
            'number_format',
            'interior_color',
            'font_color',
            'font_bold',
            'display_interior_color',
            'display_font_color',
            'display_font_bold',
            'display_number_format'
        )
    }
    status_semantics = [ordered]@{
        observed = 'Normal capture row with field values.'
        capture_error = 'Cell capture failed at this step.'
        workbook_closed = 'Workbook intentionally closed during lifecycle operation.'
    }
}
$stepwiseSchema | ConvertTo-Json -Depth 10 | Set-Content -Path $eb047Path

# ECS-EB-048 locale execution profile
$culture = Get-Culture
$numberFormat = $culture.NumberFormat
$localeProfile = [ordered]@{
    profile_id = 'locale-exec-profile-wave1'
    captured_utc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    locale_name = $culture.Name
    ui_culture = (Get-UICulture).Name
    decimal_separator = $numberFormat.NumberDecimalSeparator
    group_separator = $numberFormat.NumberGroupSeparator
    list_separator = (Get-Culture).TextInfo.ListSeparator
    date_short_pattern = $culture.DateTimeFormat.ShortDatePattern
    timezone = (Get-TimeZone).Id
    lane_policy = [ordered]@{
        default_lane = 'current_locale'
        additional_lanes = @('en-US','de-DE','fr-FR')
        execution_mode = 'separate_process_per_locale'
    }
    notes = @(
        'Use this profile to parameterize locale-sensitive coercion and parser probes.',
        'Current wave captures one observed locale; additional lanes are queued for follow-up.'
    )
}
$localeProfile | ConvertTo-Json -Depth 10 | Set-Content -Path $eb048Path

$reportLines = @(
    '# Crosscut Wave 1 Execution Report',
    '',
    '## Scope',
    'Generated cross-cutting instrumentation artifacts for `ECS-EB-042/043/044/045/047/048`.',
    '',
    '## Artifacts',
    '- `ECS-EB-042_display_capture_schema_wave1.json`',
    '- `ECS-EB-043_calc_mode_transition_log_wave1.csv`',
    '- `ECS-EB-044_reopen_determinism_probe.csv`',
    '- `ECS-EB-045_empirical_divergence_minimization_wave1.md`',
    '- `ECS-EB-047_stepwise_capture_schema_wave1.json`',
    '- `ECS-EB-048_locale_execution_profile_wave1.json`',
    '',
    '## Summary',
    "1. Calc-mode transition log rows generated: $(@($calcRows).Count).",
    "2. Reopen determinism merged rows generated: $(@($mergedReopenRows).Count).",
    '3. Display and stepwise schema contracts now explicitly documented for follow-on waves.'
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

Add-LogEvent -Event 'crosscut_wave1_outputs_generated' -Artifact 'outputs/crosscut_wave1/ECS-EB-042_display_capture_schema_wave1.json' -Notes 'Generated display capture schema artifact for formatting-sensitive probes'
Add-LogEvent -Event 'crosscut_wave1_outputs_generated' -Artifact 'outputs/crosscut_wave1/ECS-EB-043_calc_mode_transition_log_wave1.csv' -Notes 'Generated calc-mode transition log from all run manifests'
Add-LogEvent -Event 'crosscut_wave1_outputs_generated' -Artifact 'outputs/crosscut_wave1/ECS-EB-044_reopen_determinism_probe.csv' -Notes 'Generated canonical reopen determinism probe output by merging reopen and replay lanes'
Add-LogEvent -Event 'crosscut_wave1_outputs_generated' -Artifact 'outputs/crosscut_wave1/ECS-EB-045_empirical_divergence_minimization_wave1.md' -Notes 'Generated divergence minimization routine guidance'
Add-LogEvent -Event 'crosscut_wave1_outputs_generated' -Artifact 'outputs/crosscut_wave1/ECS-EB-047_stepwise_capture_schema_wave1.json' -Notes 'Generated stepwise capture schema artifact'
Add-LogEvent -Event 'crosscut_wave1_outputs_generated' -Artifact 'outputs/crosscut_wave1/ECS-EB-048_locale_execution_profile_wave1.json' -Notes 'Generated locale execution profile artifact'
Add-LogEvent -Event 'crosscut_wave1_reported' -Artifact 'outputs/crosscut_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published crosscut wave1 execution report'

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    calc_mode_log_rows = @($calcRows).Count
    reopen_rows = @($mergedReopenRows).Count
}
$summary | ConvertTo-Json -Depth 3
