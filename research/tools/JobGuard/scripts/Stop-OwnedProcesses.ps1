param(
    [string]$RunId,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "_lib\\ProcessGuardian.ps1")

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$logPath = Get-OwnedProcessLogPath -repoRoot $repoRoot

if (-not (Test-Path $logPath)) {
    Write-Host "No owned-process log found at: $logPath"
    exit 0
}

$lines = Get-Content -LiteralPath $logPath -ErrorAction SilentlyContinue
if ($null -eq $lines -or $lines.Count -eq 0) {
    Write-Host "Owned-process log is empty: $logPath"
    exit 0
}

$records = @()
foreach ($line in $lines) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    try {
        $records += ($line | ConvertFrom-Json -ErrorAction Stop)
    } catch {
        # Ignore malformed lines; keep going.
    }
}

if ([string]::IsNullOrWhiteSpace($RunId)) {
    $RunId = ($records | Select-Object -Last 1).run_id
}

$toStop = @($records | Where-Object { $_.run_id -eq $RunId })
if ($toStop.Count -eq 0) {
    Write-Host "No owned processes recorded for RunId '$RunId'."
    exit 0
}

# Stop in a sensible order: debugger/capture first, then runner, then Excel.
$order = @("capture", "cdb", "runner", "dotnet", "excel", "EXCEL")
foreach ($kind in $order) {
    foreach ($rec in @($toStop | Where-Object { $_.kind -eq $kind })) {
        Stop-OwnedProcessRecord -Record $rec -Force:$Force
    }
}

# Stop any remaining kinds.
foreach ($rec in @($toStop | Where-Object { $order -notcontains $_.kind })) {
    Stop-OwnedProcessRecord -Record $rec -Force:$Force
}

Write-Host "Stop-OwnedProcesses complete for RunId '$RunId'."

