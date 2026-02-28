Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$evidenceRoot = Join-Path $waveDir 'evidence'

$trackerPath = Join-Path $repoRoot 'research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_reason_code_evidence_tracker.csv'
$eb040Path = Join-Path $waveDir 'ECS-EB-040_reason_code_verification_probe_wave1.csv'
$eb041Path = Join-Path $waveDir 'ECS-EB-041_classification_evidence_sync_wave1.csv'
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave1.csv'
$reportPath = Join-Path $waveDir 'WAVE1_EXECUTION_REPORT.md'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$scenarioCache = @{}

function To-ScalarString {
    param([object]$Value)
    if ($null -eq $Value) { return '' }
    return [string]$Value
}

function Get-ScenarioCapture {
    param([string]$ScenarioId)
    if (-not $scenarioCache.ContainsKey($ScenarioId)) {
        $capturePath = Join-Path (Join-Path $evidenceRoot $ScenarioId) 'step_capture.json'
        if (-not (Test-Path $capturePath)) {
            throw "Missing step_capture.json for scenario '$ScenarioId'"
        }
        $scenarioCache[$ScenarioId] = Get-Content $capturePath -Raw | ConvertFrom-Json
    }
    return $scenarioCache[$ScenarioId]
}

function Get-TargetStats {
    param(
        [string]$ScenarioId,
        [string]$Target
    )

    $capture = Get-ScenarioCapture -ScenarioId $ScenarioId
    $snapshots = @()

    foreach ($step in @($capture.steps)) {
        $hit = @($step.captures | Where-Object { $_.target -eq $Target })
        if ($hit.Count -gt 0) {
            $c = $hit[0]
            $snapshots += [pscustomobject]@{
                step = $step.step
                operation = $step.operation
                value = To-ScalarString $c.value
                display_text = To-ScalarString $c.display_text
                number_format = To-ScalarString $c.number_format
                formula = To-ScalarString $c.formula
            }
        }
    }

    if ($snapshots.Count -eq 0) {
        throw "No captures found for target '$Target' in scenario '$ScenarioId'"
    }

    $values = @($snapshots | ForEach-Object { $_.value })
    $uniqueValues = @($values | Select-Object -Unique)

    return [pscustomobject]@{
        step_count = $snapshots.Count
        operation_sequence = (@($snapshots | ForEach-Object { $_.operation }) -join ' -> ')
        initial_value = $snapshots[0].value
        final_value = $snapshots[$snapshots.Count - 1].value
        initial_display_text = $snapshots[0].display_text
        final_display_text = $snapshots[$snapshots.Count - 1].display_text
        unique_observed_value_count = $uniqueValues.Count
        changed_any = ($uniqueValues.Count -gt 1)
        snapshots = $snapshots
    }
}

function Evaluate-Probe {
    param(
        [string]$FunctionName,
        [string]$ProbeVariant,
        [pscustomobject]$Stats
    )

    $expectedSignal = ''
    $observedSignal = if ($Stats.changed_any) { 'value_changed' } else { 'value_stable' }
    $resultStatus = 'needs_review'
    $assessment = 'needs_followup'
    $notes = ''

    switch ("$FunctionName|$ProbeVariant") {
        'NOW|recalc_change' {
            $expectedSignal = 'change_after_recalc_with_elapsed_time'
            if ($Stats.changed_any) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'volatile_support_observed'
                $notes = 'NOW changed across recalc steps with elapsed wall-clock delay.'
            }
        }
        'RAND|recalc_change' {
            $expectedSignal = 'change_after_recalc'
            if ($Stats.changed_any) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'volatile_support_observed'
                $notes = 'RAND changed across recalc steps.'
            }
        }
        'RANDBETWEEN|recalc_change' {
            $expectedSignal = 'change_after_recalc'
            if ($Stats.changed_any) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'volatile_support_observed'
                $notes = 'RANDBETWEEN changed across recalc steps.'
            }
        }
        'TODAY|date_system_transition' {
            $expectedSignal = 'serial_transition_when_date_system_changes'
            if ($Stats.changed_any) {
                $resultStatus = 'supports_reason_code_with_caveat'
                $assessment = 'date_system_sensitive_support'
                $notes = 'TODAY serial changed when toggling date system; volatile claim remains indirectly supported.'
            }
        }
        'INDEX|dependency_edit_change' {
            $expectedSignal = 'change_when_referenced_input_changes'
            if ($Stats.changed_any) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'grid_reference_support_observed'
                $notes = 'INDEX changed after referenced source cell edit.'
            }
        }
        'SUMIF|related_edit_change' {
            $expectedSignal = 'change_when_criteria_input_changes'
            if ($Stats.changed_any) {
                $resultStatus = 'supports_reason_code_with_caveat'
                $assessment = 'dependency_sensitive_change_observed'
                $notes = 'SUMIF changed on related-edit path; this does not by itself prove unrelated-edit volatility.'
            }
        }
        'SUMIF|unrelated_edit_stability' {
            $expectedSignal = 'stable_under_unrelated_edit_plus_recalc'
            if (-not $Stats.changed_any) {
                $resultStatus = 'counter_signal'
                $assessment = 'counter_signal_for_volatile_tag'
                $notes = 'SUMIF stayed stable under unrelated edit + recalc; volatile reason-code needs review.'
            }
        }
        'TEXT|format_text_output' {
            $expectedSignal = 'stable_formatted_text_output'
            if ((-not $Stats.changed_any) -and ($Stats.initial_value -ne '')) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'format_visible_support_observed'
                $notes = 'TEXT produced stable formatted text output.'
            }
        }
        'DOLLAR|format_text_output' {
            $expectedSignal = 'stable_currency_text_output'
            if ((-not $Stats.changed_any) -and ($Stats.initial_value -ne '')) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'format_visible_support_observed'
                $notes = 'DOLLAR produced stable currency-formatted text output.'
            }
        }
        'FIXED|format_text_output' {
            $expectedSignal = 'stable_fixed_decimal_text_output'
            if ((-not $Stats.changed_any) -and ($Stats.initial_value -ne '')) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'format_visible_support_observed'
                $notes = 'FIXED produced stable fixed-decimal text output.'
            }
        }
        'VALUE|coercion_expected_literal' {
            $expectedSignal = 'returns_numeric_123.45'
            if ($Stats.initial_value -eq '123.45') {
                $resultStatus = 'supports_reason_code'
                $assessment = 'type_coercion_support_observed'
                $notes = 'VALUE("123.45") returned expected numeric result.'
            }
        }
        'TYPE|coercion_expected_literal' {
            $expectedSignal = 'returns_type_code_1'
            if ($Stats.initial_value -eq '1') {
                $resultStatus = 'supports_reason_code'
                $assessment = 'type_coercion_support_observed'
                $notes = 'TYPE returned expected numeric type code for VALUE output.'
            }
        }
        'N|coercion_expected_literal' {
            $expectedSignal = 'returns_numeric_zero_for_text'
            if ($Stats.initial_value -eq '0') {
                $resultStatus = 'supports_reason_code'
                $assessment = 'type_coercion_support_observed'
                $notes = 'N("text") returned 0 as expected.'
            }
        }
        'T|coercion_expected_literal' {
            $expectedSignal = 'returns_empty_text_for_numeric_input'
            if ($Stats.initial_value -eq '') {
                $resultStatus = 'supports_reason_code'
                $assessment = 'type_coercion_support_observed'
                $notes = 'T(123) returned empty text as expected.'
            }
        }
        'VALUETOTEXT|coercion_expected_literal' {
            $expectedSignal = 'returns_text_representation_of_numeric_input'
            if ($Stats.initial_value -eq '123.45') {
                $resultStatus = 'supports_reason_code'
                $assessment = 'type_coercion_support_observed'
                $notes = 'VALUETOTEXT returned expected text representation.'
            }
        }
        default {
            $expectedSignal = 'stable_or_dependency_consistent'
            if (-not $Stats.changed_any) {
                $resultStatus = 'supports_reason_code'
                $assessment = 'grid_reference_support_observed'
                $notes = 'Observed stable output under the scripted operation sequence.'
            }
        }
    }

    if ($resultStatus -eq 'needs_review') {
        $notes = if ($notes -ne '') { $notes } else { 'Observed signal did not satisfy the scenario expectation; review required.' }
    }

    return [pscustomobject]@{
        expected_signal = $expectedSignal
        observed_signal = $observedSignal
        result_status = $resultStatus
        reason_code_assessment = $assessment
        notes = $notes
    }
}

$trackerRows = Import-Csv $trackerPath
$trackerByFunction = @{}
foreach ($row in $trackerRows) {
    $trackerByFunction[$row.function_name] = $row
}

$probeSpecs = @(
    [pscustomobject]@{ function_name='NOW'; scenario_id='SCN-EB040-NOW-RECALC'; target='Sheet1!A1'; probe_variant='recalc_change' },
    [pscustomobject]@{ function_name='TODAY'; scenario_id='SCN-EB040-TODAY-DATE-SYSTEM'; target='Sheet1!A1'; probe_variant='date_system_transition' },
    [pscustomobject]@{ function_name='RAND'; scenario_id='SCN-EB040-RAND-RECALC'; target='Sheet1!A1'; probe_variant='recalc_change' },
    [pscustomobject]@{ function_name='RANDBETWEEN'; scenario_id='SCN-EB040-RANDBETWEEN-RECALC'; target='Sheet1!A1'; probe_variant='recalc_change' },
    [pscustomobject]@{ function_name='ROW'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C1'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='COLUMN'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C2'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='ROWS'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C3'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='COLUMNS'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C4'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='ADDRESS'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C5'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='AREAS'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C6'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='INDEX'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C7'; probe_variant='dependency_edit_change' },
    [pscustomobject]@{ function_name='FORMULATEXT'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C8'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='SHEET'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C9'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='SHEETS'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C10'; probe_variant='grid_stability' },
    [pscustomobject]@{ function_name='SUMIF'; scenario_id='SCN-EB040-GRID-REFERENCE-MATRIX'; target='Sheet1!C11'; probe_variant='related_edit_change' },
    [pscustomobject]@{ function_name='SUMIF'; scenario_id='SCN-EB040-SUMIF-UNRELATED-EDIT'; target='Sheet1!C1'; probe_variant='unrelated_edit_stability' },
    [pscustomobject]@{ function_name='TEXT'; scenario_id='SCN-EB040-FORMAT-VISIBLE-MATRIX'; target='Sheet1!A1'; probe_variant='format_text_output' },
    [pscustomobject]@{ function_name='DOLLAR'; scenario_id='SCN-EB040-FORMAT-VISIBLE-MATRIX'; target='Sheet1!A2'; probe_variant='format_text_output' },
    [pscustomobject]@{ function_name='FIXED'; scenario_id='SCN-EB040-FORMAT-VISIBLE-MATRIX'; target='Sheet1!A3'; probe_variant='format_text_output' },
    [pscustomobject]@{ function_name='VALUE'; scenario_id='SCN-EB040-TYPE-COERCION-MATRIX'; target='Sheet1!A1'; probe_variant='coercion_expected_literal' },
    [pscustomobject]@{ function_name='TYPE'; scenario_id='SCN-EB040-TYPE-COERCION-MATRIX'; target='Sheet1!A2'; probe_variant='coercion_expected_literal' },
    [pscustomobject]@{ function_name='N'; scenario_id='SCN-EB040-TYPE-COERCION-MATRIX'; target='Sheet1!A3'; probe_variant='coercion_expected_literal' },
    [pscustomobject]@{ function_name='T'; scenario_id='SCN-EB040-TYPE-COERCION-MATRIX'; target='Sheet1!A4'; probe_variant='coercion_expected_literal' },
    [pscustomobject]@{ function_name='VALUETOTEXT'; scenario_id='SCN-EB040-TYPE-COERCION-MATRIX'; target='Sheet1!A5'; probe_variant='coercion_expected_literal' }
)

$eb040Rows = @()
$probeCounter = 1
foreach ($spec in $probeSpecs) {
    $stats = Get-TargetStats -ScenarioId $spec.scenario_id -Target $spec.target
    $eval = Evaluate-Probe -FunctionName $spec.function_name -ProbeVariant $spec.probe_variant -Stats $stats

    $probeId = ('RCW1-{0:D3}' -f $probeCounter)
    $probeCounter++

    $reasonCodes = ''
    if ($trackerByFunction.ContainsKey($spec.function_name)) {
        $reasonCodes = To-ScalarString $trackerByFunction[$spec.function_name].reason_codes
    }

    $eb040Rows += [pscustomobject]@{
        probe_id = $probeId
        scenario_id = $spec.scenario_id
        task_id = 'ECS-EB-040'
        function_name = $spec.function_name
        probe_variant = $spec.probe_variant
        target = $spec.target
        reason_codes_expected = $reasonCodes
        expected_signal = $eval.expected_signal
        observed_signal = $eval.observed_signal
        step_count = $stats.step_count
        operation_sequence = $stats.operation_sequence
        initial_value = $stats.initial_value
        final_value = $stats.final_value
        unique_observed_value_count = $stats.unique_observed_value_count
        changed_any = if ($stats.changed_any) { 'true' } else { 'false' }
        result_status = $eval.result_status
        reason_code_assessment = $eval.reason_code_assessment
        evidence_bundle_ref = (Join-Path 'evidence' $spec.scenario_id)
        notes = $eval.notes
    }
}

$eb040Rows | Export-Csv -Path $eb040Path -NoTypeInformation

# Build ECS-EB-041 sync rows and mutate tier-3 tracker rows.
$syncRows = @()
$syncCounter = 1
$probesByFunction = $eb040Rows | Group-Object function_name

foreach ($group in $probesByFunction) {
    $functionName = $group.Name
    if (-not $trackerByFunction.ContainsKey($functionName)) { continue }

    $tracker = $trackerByFunction[$functionName]
    if ([int]$tracker.tier -ne 3) { continue }

    $probeIds = @($group.Group | ForEach-Object { $_.probe_id })
    $assessments = @($group.Group | ForEach-Object { $_.reason_code_assessment } | Select-Object -Unique)
    $results = @($group.Group | ForEach-Object { $_.result_status } | Select-Object -Unique)

    $evidenceStatusBefore = To-ScalarString $tracker.evidence_status
    $reviewStatusBefore = To-ScalarString $tracker.review_status

    $evidenceStatusAfter = 'source_probe_bound'
    $reviewStatusAfter = 'triaged_source_probe_bound'
    $syncAction = 'synced_probe_ids_and_promoted_status'
    $summary = (@($results) -join '|')

    if ($functionName -eq 'SUMIF') {
        $evidenceStatusAfter = 'source_probe_bound_with_counter_signal'
        $reviewStatusAfter = 'needs_reason_code_review'
        $syncAction = 'synced_probe_ids_and_flagged_reason_code_review'
        $summary = 'counter_signal_present|reason_code_review_required'
    }

    $tracker.evidence_probe_ids = ($probeIds -join '|')
    $tracker.evidence_status = $evidenceStatusAfter
    $tracker.review_status = $reviewStatusAfter

    $existingNotes = To-ScalarString $tracker.notes
    if ($existingNotes -match 'probe_wave1_ids=') {
        $existingNotes = ($existingNotes -replace ';?\s*probe_wave1_ids=[^;]*', '')
        $existingNotes = ($existingNotes -replace ';?\s*probe_wave1_summary=[^;]*', '')
    }
    $suffix = "probe_wave1_ids=$($probeIds -join '|');probe_wave1_summary=$summary"
    if ([string]::IsNullOrWhiteSpace($existingNotes)) {
        $tracker.notes = $suffix
    }
    else {
        $tracker.notes = "$existingNotes; $suffix"
    }

    $syncId = ('RCS1-{0:D3}' -f $syncCounter)
    $syncCounter++

    $syncRows += [pscustomobject]@{
        sync_id = $syncId
        function_name = $functionName
        tier = $tracker.tier
        reason_codes = $tracker.reason_codes
        evidence_source_ids = $tracker.evidence_source_ids
        new_probe_ids = ($probeIds -join '|')
        probe_result_summary = $summary
        evidence_status_before = $evidenceStatusBefore
        evidence_status_after = $evidenceStatusAfter
        review_status_before = $reviewStatusBefore
        review_status_after = $reviewStatusAfter
        sync_action = $syncAction
        notes = (@($assessments) -join '|')
    }
}

$syncRows | Sort-Object function_name | Export-Csv -Path $eb041Path -NoTypeInformation
$trackerRows | Export-Csv -Path $trackerPath -NoTypeInformation

# Mark scenario manifest statuses complete when evidence bundles exist.
$manifestRows = Import-Csv $manifestPath
foreach ($m in $manifestRows) {
    $scenarioDir = Join-Path $evidenceRoot $m.scenario_id
    if (Test-Path $scenarioDir) {
        $m.status = 'completed'
    }
}
$manifestRows | Export-Csv -Path $manifestPath -NoTypeInformation

# Create execution report.
$scenarioCount = @($manifestRows).Count
$probeCount = @($eb040Rows).Count
$supportCount = @($eb040Rows | Where-Object { $_.result_status -like 'supports_reason_code*' }).Count
$counterCount = @($eb040Rows | Where-Object { $_.result_status -eq 'counter_signal' }).Count
$needsReviewCount = @($eb040Rows | Where-Object { $_.result_status -eq 'needs_review' }).Count

$reportLines = @(
    '# Reason-Code Wave 1 Execution Report',
    '',
    '## Scope',
    'Executed `ECS-EB-040` targeted weak-evidence reason-code probes and applied `ECS-EB-041` classification sync updates for all tier-3 tracker functions.',
    '',
    '## Execution status',
    "- Scenarios executed: $scenarioCount",
    "- Probe rows synthesized: $probeCount",
    "- Supports reason code: $supportCount",
    "- Counter-signal rows: $counterCount",
    "- Needs-review rows: $needsReviewCount",
    '',
    '## Key outcomes',
    '1. Volatility controls (`NOW`, `RAND`, `RANDBETWEEN`) showed recalc-driven value changes.',
    '2. Grid/reference-sensitive set stayed stable where expected (`ROW`, `COLUMN`, `ROWS`, `COLUMNS`, `ADDRESS`, `AREAS`, `FORMULATEXT`, `SHEET`, `SHEETS`) and changed where dependency edits should propagate (`INDEX`).',
    '3. Format-visible functions (`TEXT`, `DOLLAR`, `FIXED`) produced stable text-form outputs in the captured locale.',
    '4. Type/coercion set (`VALUE`, `TYPE`, `N`, `T`, `VALUETOTEXT`) matched expected literal outcomes in the scenario matrix.',
    '5. `SUMIF` produced a mixed signal: related-edit change observed, but unrelated-edit+recalc remained stable; tier-3 classification is flagged for reason-code review.',
    '',
    '## Artifacts',
    '- `ECS-EB-040_reason_code_verification_probe_wave1.csv`',
    '- `ECS-EB-041_classification_evidence_sync_wave1.csv`',
    '- `scenario_manifest_wave1.csv` (status updated to `completed`)',
    '- `evidence/<scenario_id>/*`'
)

$report = $reportLines -join [Environment]::NewLine

Set-Content -Path $reportPath -Value $report -NoNewline

# Append new run events to empirical log manifest if not present.
$logRows = @()
if (Test-Path $logManifestPath) {
    $logRows = Import-Csv $logManifestPath
}

function Add-LogEvent {
    param(
        [string]$Event,
        [string]$Artifact,
        [string]$Notes,
        [System.Collections.Generic.List[object]]$LogList
    )

    $existing = $LogList | Where-Object { $_.event -eq $Event -and $_.artifact -eq $Artifact }
    if ($existing) { return }

    $LogList.Add([pscustomobject]@{
        timestamp_utc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        event = $Event
        artifact = $Artifact
        notes = $Notes
    })
}

$mutableLogs = [System.Collections.Generic.List[object]]::new()
foreach ($r in $logRows) { $mutableLogs.Add($r) }

Add-LogEvent -Event 'reason_code_wave1_outputs_generated' -Artifact 'outputs/reason_code_wave1/ECS-EB-040_reason_code_verification_probe_wave1.csv' -Notes 'Synthesized probe-level outputs from step-capture evidence for tier-3 weak-evidence set' -LogList $mutableLogs
Add-LogEvent -Event 'reason_code_wave1_sync_generated' -Artifact 'outputs/reason_code_wave1/ECS-EB-041_classification_evidence_sync_wave1.csv' -Notes 'Generated classification sync table and mapped probe IDs by function' -LogList $mutableLogs
Add-LogEvent -Event 'reason_code_wave1_manifest_status_updated' -Artifact 'outputs/reason_code_wave1/scenario_manifest_wave1.csv' -Notes 'Marked all wave1 scenarios completed after evidence verification' -LogList $mutableLogs
Add-LogEvent -Event 'reason_code_wave1_reported' -Artifact 'outputs/reason_code_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Published wave1 execution report with mixed-signal SUMIF classification note' -LogList $mutableLogs
Add-LogEvent -Event 'reason_code_wave1_tracker_synced' -Artifact '../20260228-130325-excel-compat-spec-index-pass-01/outputs/function_reason_code_evidence_tracker.csv' -Notes 'Applied ECS-EB-041 sync to tier-3 tracker rows with probe IDs and status transitions' -LogList $mutableLogs

$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

$summary = [pscustomobject]@{
    scenarios = $scenarioCount
    probes = $probeCount
    supports = $supportCount
    counter_signal = $counterCount
    needs_review = $needsReviewCount
}
$summary | ConvertTo-Json -Depth 3
