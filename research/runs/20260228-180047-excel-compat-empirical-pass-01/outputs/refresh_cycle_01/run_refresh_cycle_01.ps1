Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\..')).Path
Set-Location $repoRoot

$cycleDir = $PSScriptRoot
$platformDir = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/platform_availability'
$matrixPath = Join-Path $platformDir 'function_availability_matrix.csv'
$beforeMatrix = Join-Path $cycleDir 'function_availability_matrix.before.csv'
$afterMatrix = Join-Path $cycleDir 'function_availability_matrix.after.csv'
$eb039Path = Join-Path $platformDir 'platform_parity_regression_log.csv'
$eb039CyclePath = Join-Path $cycleDir 'ECS-EB-039_platform_parity_regression_log_wave1.csv'
$driftProbePath = Join-Path $cycleDir 'drift_probe_refresh_results.csv'
$reportPath = Join-Path $cycleDir 'REFRESH_CYCLE_01_REPORT.md'
$logManifestPath = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/logs/manifest.csv'
$cycleUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')

New-Item -ItemType Directory -Force -Path $cycleDir | Out-Null

if (Test-Path $matrixPath) {
    Copy-Item -Force $matrixPath $beforeMatrix
}

# Refresh source/availability matrix (ECS-EB-037 recrawl lane)
powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $platformDir 'run_ecs_eb_037.ps1')
if ($LASTEXITCODE -ne 0) { throw "run_ecs_eb_037.ps1 failed with exit code $LASTEXITCODE" }

Copy-Item -Force $matrixPath $afterMatrix

# Refresh env snapshot
& research/tools/excel-probe/excel-probe.cmd env --out $platformDir
if ($LASTEXITCODE -ne 0) { throw "excel-probe env refresh failed with exit code $LASTEXITCODE" }

function Build-DiffRows {
    param(
        [string]$BeforePath,
        [string]$AfterPath,
        [string]$CycleUtc
    )

    $before = @()
    $after = @()
    if (Test-Path $BeforePath) { $before = Import-Csv $BeforePath }
    if (Test-Path $AfterPath) { $after = Import-Csv $AfterPath }

    $beforeBy = @{}
    foreach ($r in $before) { $beforeBy[$r.function_name] = $r }
    $afterBy = @{}
    foreach ($r in $after) { $afterBy[$r.function_name] = $r }

    $allFns = @($beforeBy.Keys + $afterBy.Keys | Select-Object -Unique | Sort-Object)
    $fields = @('source_applies_to','source_status','windows_desktop_status','mac_desktop_status','web_status','mobile_status','probe_status','last_probe_utc')

    $diffs = @()
    foreach ($fn in $allFns) {
        $b = if ($beforeBy.ContainsKey($fn)) { $beforeBy[$fn] } else { $null }
        $a = if ($afterBy.ContainsKey($fn)) { $afterBy[$fn] } else { $null }
        if ($null -eq $b -or $null -eq $a) {
            $diffs += [pscustomobject]@{
                cycle_utc = $CycleUtc
                function_name = $fn
                field = '__row__'
                before_value = if ($b) { 'present' } else { 'missing' }
                after_value = if ($a) { 'present' } else { 'missing' }
                change_type = 'row_add_remove'
            }
            continue
        }
        foreach ($f in $fields) {
            $bv = [string]$b.$f
            $av = [string]$a.$f
            if ($bv -ne $av) {
                $diffs += [pscustomobject]@{
                    cycle_utc = $CycleUtc
                    function_name = $fn
                    field = $f
                    before_value = $bv
                    after_value = $av
                    change_type = 'field_change'
                }
            }
        }
    }
    if ($diffs.Count -eq 0) {
        $diffs += [pscustomobject]@{
            cycle_utc = $CycleUtc
            function_name = '__none__'
            field = '__none__'
            before_value = ''
            after_value = ''
            change_type = 'no_change'
        }
    }
    return $diffs
}

$diffRows = Build-DiffRows -BeforePath $beforeMatrix -AfterPath $afterMatrix -CycleUtc $cycleUtc
$diffRows | Export-Csv -NoTypeInformation -Path $eb039Path
$diffRows | Export-Csv -NoTypeInformation -Path $eb039CyclePath

# Drift-sensitive probe refresh (targeted)
$refreshProbeDefs = @(
    [pscustomobject]@{
        probe_id = 'REFRESH-001'
        label = 'formula_parse_double_comma'
        scenario_path = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/formula_parse_wave1/scenarios/SCN-EB030-AMBIG-DOUBLE-COMMA.json'
    },
    [pscustomobject]@{
        probe_id = 'REFRESH-002'
        label = 'reason_code_sumif_unrelated'
        scenario_path = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/scenarios/SCN-EB040-SUMIF-UNRELATED-EDIT.json'
    },
    [pscustomobject]@{
        probe_id = 'REFRESH-003'
        label = 'reason_code_now_recalc'
        scenario_path = 'research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reason_code_wave1/scenarios/SCN-EB040-NOW-RECALC.json'
    }
)

$driftRows = @()
foreach ($p in $refreshProbeDefs) {
    $outDir = Join-Path $cycleDir ('evidence/' + $p.probe_id)
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    & research/tools/excel-probe/excel-probe.cmd run --scenario $p.scenario_path --out $outDir --visible false --timeout-sec 300
    $exitCode = $LASTEXITCODE
    $runManifestPath = Join-Path $outDir 'run_manifest.json'
    $stepCapturePath = Join-Path $outDir 'step_capture.json'
    $runStatus = 'missing'
    $metric = ''
    $metricValue = ''

    if (Test-Path $runManifestPath) {
        $m = Get-Content $runManifestPath -Raw | ConvertFrom-Json
        $runStatus = [string]$m.exit_status
    }
    if (Test-Path $stepCapturePath) {
        $sc = Get-Content $stepCapturePath -Raw | ConvertFrom-Json
        switch ($p.label) {
            'formula_parse_double_comma' {
                $target = 'Sheet1!D1'
                $caps = @()
                foreach ($s in @($sc.steps)) {
                    $hit = @($s.captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
                    if ($hit.Count -gt 0) { $caps += $hit[0] }
                }
                if ($caps.Count -gt 0) {
                    $metric = 'final_formula'
                    $metricValue = [string]$caps[$caps.Count - 1].formula
                }
            }
            'reason_code_sumif_unrelated' {
                $target = 'Sheet1!C1'
                $vals = @()
                foreach ($s in @($sc.steps)) {
                    $hit = @($s.captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
                    if ($hit.Count -gt 0 -and $hit[0].PSObject.Properties.Name -contains 'value') { $vals += [string]$hit[0].value }
                }
                $metric = 'unique_value_count'
                $metricValue = (@($vals | Select-Object -Unique).Count)
            }
            'reason_code_now_recalc' {
                $target = 'Sheet1!A1'
                $vals = @()
                foreach ($s in @($sc.steps)) {
                    $hit = @($s.captures | Where-Object { $_.target -eq $target } | Select-Object -First 1)
                    if ($hit.Count -gt 0 -and $hit[0].PSObject.Properties.Name -contains 'value') { $vals += [string]$hit[0].value }
                }
                $metric = 'unique_value_count'
                $metricValue = (@($vals | Select-Object -Unique).Count)
            }
        }
    }

    $driftRows += [pscustomobject]@{
        cycle_utc = $cycleUtc
        probe_id = $p.probe_id
        label = $p.label
        scenario_path = $p.scenario_path
        runner_exit_code = $exitCode
        run_exit_status = $runStatus
        metric = $metric
        metric_value = $metricValue
        evidence_ref = ('outputs/refresh_cycle_01/evidence/' + $p.probe_id)
    }
}
$driftRows | Export-Csv -NoTypeInformation -Path $driftProbePath

$changeCount = @($diffRows | Where-Object { $_.change_type -ne 'no_change' }).Count
$reportLines = @(
    '# Refresh Cycle 01 Report',
    '',
    "- Cycle UTC: $cycleUtc",
    "- Availability matrix change rows: $changeCount",
    "- Drift probes executed: $(@($driftRows).Count)",
    '',
    '## Artifacts',
    '- `function_availability_matrix.before.csv`',
    '- `function_availability_matrix.after.csv`',
    '- `ECS-EB-039_platform_parity_regression_log_wave1.csv`',
    '- `drift_probe_refresh_results.csv`',
    '- `evidence/REFRESH-*/`',
    '',
    '## Notes',
    '1. Availability matrix recrawl uses `run_ecs_eb_037.ps1` and updates `platform_availability/function_availability_matrix.csv`.',
    '2. Regression log records row/field-level changes or explicit `no_change` status.',
    '3. Drift probes rerun selected ambiguity/volatility signals for rapid change detection.'
)
$reportLines | Set-Content -Path $reportPath

# log manifest
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
Add-LogEvent -Event 'refresh_cycle_01_completed' -Artifact 'outputs/refresh_cycle_01/REFRESH_CYCLE_01_REPORT.md' -Notes 'Completed refresh cycle with availability recrawl, parity diff, and targeted drift probes'
Add-LogEvent -Event 'platform_parity_regression_logged' -Artifact 'outputs/platform_availability/platform_parity_regression_log.csv' -Notes 'Updated ECS-EB-039 platform parity regression log from before/after availability matrix diff'
$mutableLogs | Export-Csv -Path $logManifestPath -NoTypeInformation

Write-Host "Refresh cycle completed. Changes logged:" $changeCount "drift probes:" $driftRows.Count
