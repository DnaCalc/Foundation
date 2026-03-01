Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir '..\..\..\..\..')).Path
$empiricalRunRoot = (Resolve-Path (Join-Path $waveDir '..\..')).Path
$outputsRoot = Join-Path $empiricalRunRoot 'outputs'
$parentOutputs = Join-Path $repoRoot 'research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs'
$logManifestPath = Join-Path $empiricalRunRoot 'logs/manifest.csv'

$catalogPath = Join-Path $parentOutputs 'function_catalog_full.csv'
$interestPath = Join-Path $parentOutputs 'function_interest_index.csv'

$eb005Path = Join-Path $waveDir 'ECS-EB-005_function_template_plan_wave1.csv'
$eb006Path = Join-Path $waveDir 'ECS-EB-006_function_edge_wave1_manifest.csv'
$eb007Path = Join-Path $waveDir 'ECS-EB-007_function_edge_matrix_schema_wave1.csv'
$eb008Path = Join-Path $waveDir 'ECS-EB-008_function_unresolved_queue_wave1.csv'
$eb009Path = Join-Path $waveDir 'ECS-EB-009_function_edge_evidence_index_wave1.csv'
$reportPath = Join-Path $waveDir 'WAVE1_EXECUTION_REPORT.md'

New-Item -ItemType Directory -Force -Path $waveDir | Out-Null

$catalog = Import-Csv $catalogPath
$interest = Import-Csv $interestPath

# ECS-EB-005 template plan
$templateRows = @()
$groups = $catalog | Group-Object category | Sort-Object Name
foreach ($g in $groups) {
    $templateRows += [pscustomobject]@{
        template_id = ('TPL-{0:D3}' -f ($templateRows.Count + 1))
        category = $g.Name
        function_count = $g.Count
        representative_functions = (@($g.Group | Select-Object -ExpandProperty function_name | Select-Object -First 5) -join '|')
        scenario_classes = 'arg_type_matrix|error_propagation|array_lifting|recalc_stability|version_platform'
        priority = if ($g.Name -match 'Lookup|Reference|Date|Time|Financial|Information') { 'P1' } else { 'P2' }
    }
}
$templateRows | Export-Csv -NoTypeInformation -Path $eb005Path

# ECS-EB-006 wave1 manifest seed (tier4+tier5 plus tier3 flagged)
$manifestRows = @()
foreach ($row in $interest | Sort-Object {[int]$_.tier}, function_name) {
    $tier = [int]$row.tier
    if ($tier -gt 4) { continue }
    $scenarioClasses = if ($tier -eq 5) {
        'connector_lifecycle|dependency_mutation|platform_caveat'
    }
    elseif ($tier -eq 4) {
        'mixed_type_array|spill_interaction|lambda_helper'
    }
    else {
        'reason_code_verifier|stability_probe'
    }
    $manifestRows += [pscustomobject]@{
        manifest_id = ('FMW1-{0:D3}' -f ($manifestRows.Count + 1))
        function_name = $row.function_name
        tier = $row.tier
        category = $row.category
        reason_codes = $row.reason_codes
        scenario_classes = $scenarioClasses
        status = 'seeded'
        notes = 'Wave1 manifest seed generated from function_interest_index.'
    }
}
$manifestRows | Export-Csv -NoTypeInformation -Path $eb006Path

# ECS-EB-007 edge matrix schema
$schemaRows = @(
    [pscustomobject]@{ column_name='function_name'; type='string'; required='true'; description='Worksheet function identifier' },
    [pscustomobject]@{ column_name='scenario_class'; type='string'; required='true'; description='Probe scenario class key' },
    [pscustomobject]@{ column_name='argument_signature'; type='string'; required='false'; description='Argument-shape variant descriptor' },
    [pscustomobject]@{ column_name='expected_behavior_source'; type='string'; required='false'; description='Source-anchored expectation summary' },
    [pscustomobject]@{ column_name='observed_behavior'; type='string'; required='false'; description='Observed behavior summary from empirical probe' },
    [pscustomobject]@{ column_name='result_status'; type='string'; required='true'; description='matches_expected|mismatch|probe|run_failed' },
    [pscustomobject]@{ column_name='platform'; type='string'; required='true'; description='windows_desktop|mac_desktop|web|mobile' },
    [pscustomobject]@{ column_name='excel_build'; type='string'; required='false'; description='Excel build observed' },
    [pscustomobject]@{ column_name='confidence'; type='string'; required='true'; description='high|medium|low' },
    [pscustomobject]@{ column_name='evidence_ref'; type='string'; required='true'; description='Evidence bundle or artifact reference' },
    [pscustomobject]@{ column_name='source_ref'; type='string'; required='false'; description='Primary source ID/URL reference' },
    [pscustomobject]@{ column_name='unresolved_flag'; type='string'; required='true'; description='true|false unresolved semantic marker' }
)
$schemaRows | Export-Csv -NoTypeInformation -Path $eb007Path

# ECS-EB-008 unresolved queue from all wave csv outputs with result_status
$csvFiles = Get-ChildItem -Path $outputsRoot -Filter '*.csv' -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\platform_availability\\' -and $_.FullName -notmatch '\\artifacts\\'
}

$unresolved = @()
foreach ($f in $csvFiles) {
    try { $rows = Import-Csv $f.FullName } catch { continue }
    if (-not $rows -or @($rows).Count -eq 0) { continue }
    $props = @($rows[0].PSObject.Properties.Name)
    if (-not ($props -contains 'result_status')) { continue }
    foreach ($r in $rows) {
        $status = [string]$r.result_status
        if ($status -in @('mismatch','probe','run_failed','needs_review')) {
            $fn = if ($props -contains 'function_name') { [string]$r.function_name } else { '' }
            $unresolved += [pscustomobject]@{
                queue_id = ('UNQW1-{0:D4}' -f ($unresolved.Count + 1))
                function_name = if ([string]::IsNullOrWhiteSpace($fn)) { '__non_functional__' } else { $fn }
                source_artifact = ($f.FullName -replace [regex]::Escape($empiricalRunRoot + '\'), '')
                scenario_id = if ($props -contains 'scenario_id') { [string]$r.scenario_id } else { '' }
                case_id = if ($props -contains 'case_id') { [string]$r.case_id } else { '' }
                result_status = $status
                priority = if ($status -eq 'mismatch' -or $status -eq 'run_failed') { 'P0' } else { 'P1' }
                notes = if ($props -contains 'notes') { [string]$r.notes } else { '' }
            }
        }
    }
}
$unresolved | Export-Csv -NoTypeInformation -Path $eb008Path

# ECS-EB-009 evidence index (link function to source + empirical artifacts)
$evidenceRows = @()
foreach ($row in $manifestRows) {
    $fn = $row.function_name
    $sourceHit = $catalog | Where-Object { $_.function_name -eq $fn } | Select-Object -First 1
    $empiricalRefs = @($unresolved | Where-Object { $_.function_name -eq $fn } | Select-Object -ExpandProperty source_artifact -Unique)
    $evidenceRows += [pscustomobject]@{
        index_id = ('FEI-{0:D3}' -f ($evidenceRows.Count + 1))
        function_name = $fn
        tier = $row.tier
        source_url = if ($sourceHit) { $sourceHit.function_url } else { '' }
        source_category = if ($sourceHit) { $sourceHit.category } else { '' }
        empirical_artifact_refs = ($empiricalRefs -join '|')
        empirical_ref_count = $empiricalRefs.Count
        unresolved_count = @($unresolved | Where-Object { $_.function_name -eq $fn }).Count
    }
}
$evidenceRows | Export-Csv -NoTypeInformation -Path $eb009Path

$reportLines = @(
    '# Function Edge Wave 1 Execution Report',
    '',
    '## Scope',
    'Generated function-edge planning/index artifacts for `ECS-EB-005` through `ECS-EB-009`.',
    '',
    '## Artifact counts',
    "- Template rows (`ECS-EB-005`): $(@($templateRows).Count)",
    "- Manifest rows (`ECS-EB-006`): $(@($manifestRows).Count)",
    "- Schema rows (`ECS-EB-007`): $(@($schemaRows).Count)",
    "- Unresolved rows (`ECS-EB-008`): $(@($unresolved).Count)",
    "- Evidence index rows (`ECS-EB-009`): $(@($evidenceRows).Count)",
    '',
    '## Artifacts',
    '- `ECS-EB-005_function_template_plan_wave1.csv`',
    '- `ECS-EB-006_function_edge_wave1_manifest.csv`',
    '- `ECS-EB-007_function_edge_matrix_schema_wave1.csv`',
    '- `ECS-EB-008_function_unresolved_queue_wave1.csv`',
    '- `ECS-EB-009_function_edge_evidence_index_wave1.csv`'
)
$reportLines | Set-Content -Path $reportPath

$logRows = @()
if (Test-Path $logManifestPath) { $logRows = Import-Csv $logManifestPath }
$mutableLogs = [System.Collections.Generic.List[object]]::new()
foreach ($r in $logRows) { $mutableLogs.Add($r) }
function Add-LogEvent {
    param([string]$Event,[string]$Artifact,[string]$Notes)
    $existing = $mutableLogs | Where-Object { $_.event -eq $Event -and $_.artifact -eq $Artifact }
    if ($existing) { return }
    $mutableLogs.Add([pscustomobject]@{
        timestamp_utc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        event = $Event
        artifact = $Artifact
        notes = $Notes
    })
}
Add-LogEvent -Event 'function_edge_wave1_outputs_generated' -Artifact 'outputs/function_edge_wave1/WAVE1_EXECUTION_REPORT.md' -Notes 'Generated ECS-EB-005..009 function edge planning/index artifacts'
$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

Write-Host "Function edge wave1 completed."
