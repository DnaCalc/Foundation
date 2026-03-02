param()
$ErrorActionPreference='Stop'
$base = Resolve-Path (Join-Path $PSScriptRoot '..')
$manifestPath = Join-Path $base 'outputs\scenario_manifest.csv'
$outRoot = Join-Path $base 'outputs\evidence'
$resultsPath = Join-Path $base 'outputs\TARGETED_RESULTS.csv'
$summaryPath = Join-Path $base 'outputs\TARGETED_EXECUTION_SUMMARY.md'
$logPath = Join-Path $base 'logs\manifest.csv'

$manifest = Import-Csv $manifestPath
$rows = @()

foreach ($m in $manifest) {
  $evidenceDir = Join-Path $outRoot $m.scenario_id
  $normPath = Join-Path $evidenceDir 'normalized_capture.json'
  $rawPath = Join-Path $evidenceDir 'raw_capture.json'
  if (-not (Test-Path $normPath)) {
    $rows += [pscustomobject]@{scenario_id=$m.scenario_id;task_id=$m.task_id;domain=$m.domain;target='';status='missing_evidence';display_text='';value='';formula='';operation_statuses='';notes='normalized_capture missing'}
    continue
  }

  $norm = Get-Content -Raw $normPath | ConvertFrom-Json -Depth 120
  $raw = $null
  if (Test-Path $rawPath) { $raw = Get-Content -Raw $rawPath | ConvertFrom-Json -Depth 120 }

  $opStatus=''
  if ($null -ne $raw -and $null -ne $raw.operation_trace) {
    $opStatus = (($raw.operation_trace | ForEach-Object { "$($_.op):$($_.status)" }) -join '; ')
  }

  if ($null -eq $norm.observations -or $norm.observations.Count -eq 0) {
    $rows += [pscustomobject]@{scenario_id=$m.scenario_id;task_id=$m.task_id;domain=$m.domain;target='';status='no_observations';display_text='';value='';formula='';operation_statuses=$opStatus;notes='normalized observations empty'}
    continue
  }

  foreach ($o in $norm.observations) {
    $rows += [pscustomobject]@{
      scenario_id = $m.scenario_id
      task_id = $m.task_id
      domain = $m.domain
      target = $o.target
      status = $o.status
      display_text = $o.metadata.display_text
      value = $o.value
      formula = $o.metadata.formula
      operation_statuses = $opStatus
      notes = ''
    }
  }
}

$rows | Export-Csv -NoTypeInformation -Path $resultsPath

$totalScenarios = ($manifest | Measure-Object).Count
$missingCount = ($rows | Where-Object { $_.status -eq 'missing_evidence' } | Select-Object -ExpandProperty scenario_id -Unique | Measure-Object).Count
$noObsCount = ($rows | Where-Object { $_.status -eq 'no_observations' } | Select-Object -ExpandProperty scenario_id -Unique | Measure-Object).Count
$uniqueObserved = ($rows | Where-Object { $_.status -notin @('missing_evidence','no_observations') } | Select-Object -ExpandProperty scenario_id -Unique | Measure-Object).Count

$lines = @()
$lines += '# Targeted Execution Summary'
$lines += ''
$lines += "- scenarios in manifest: $totalScenarios"
$lines += "- scenarios with observations: $uniqueObserved"
$lines += "- scenarios missing evidence: $missingCount"
$lines += "- scenarios with no observations: $noObsCount"
$lines += ''
$lines += '## Key Scenario Highlights'

$highlightIds = @('NFCP1-FL010-DOUBLE-COMMA','NFCP1-FL011-DOT-FIELD','NFCP1-LINK-PRESENT-OPEN-UPD0','NFCP1-LINK-PRESENT-OPEN-UPD3','NFCP1-LINK-PRESENT-CLOSED','NFCP1-LINK-MISSING','NFCP1-CF-SPILL-TABLE','NFCP1-TBL-STRUCTREF-SPILL','NFCP1-MERGE-UNMERGE-DIRECT')
foreach ($sid in $highlightIds) {
  $matches = $rows | Where-Object { $_.scenario_id -eq $sid }
  if (-not $matches) { $lines += "- ${sid}: no rows"; continue }
  $targets = $matches | ForEach-Object { "$($_.target) -> $($_.display_text)" }
  $lines += "- ${sid}: " + ($targets -join '; ')
}

Set-Content -Path $summaryPath -Value ($lines -join "`r`n")

if (Test-Path $logPath) {
  Add-Content -Path $logPath -Value ((Get-Date).ToUniversalTime().ToString('s') + 'Z,targeted_empirical_results_generated,outputs/TARGETED_RESULTS.csv,Generated scenario-level result rows')
  Add-Content -Path $logPath -Value ((Get-Date).ToUniversalTime().ToString('s') + 'Z,targeted_empirical_summary_generated,outputs/TARGETED_EXECUTION_SUMMARY.md,Generated targeted execution summary')
}

Write-Host "Built targeted outputs: $resultsPath"
