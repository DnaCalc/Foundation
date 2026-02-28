# Helper library for safely tracking and stopping only the processes we started.
# Rationale: don't kill unrelated EXCEL/dotnet processes on the machine; guard against PID reuse.

Set-StrictMode -Version Latest

function Get-RepoRootFromScriptRoot([string]$scriptRoot) {
    return (Resolve-Path (Join-Path $scriptRoot "..\\..")).Path
}

function Get-OwnedProcessLogPath([string]$repoRoot) {
    $runDir = Join-Path $repoRoot "artifacts\\runs"
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null
    return (Join-Path $runDir "owned-processes.jsonl")
}

function Get-ProcessSnapshot([int]$ProcessId) {
    # Use CIM so we can capture CommandLine + CreationDate for PID-reuse defense.
    $p = Get-CimInstance Win32_Process -Filter "ProcessId=$ProcessId" -ErrorAction SilentlyContinue
    if ($null -eq $p) {
        return $null
    }

    return [pscustomobject]@{
        pid          = [int]$p.ProcessId
        name         = [string]$p.Name
        exe          = [string]$p.ExecutablePath
        cmdline      = [string]$p.CommandLine
        creationDate = [string]$p.CreationDate
    }
}

function New-OwnedProcessRecord {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,
        [Parameter(Mandatory = $true)]
        [string]$Kind,
        [Parameter(Mandatory = $true)]
        [int]$ProcessId,
        [string]$Note
    )

    $snap = Get-ProcessSnapshot -ProcessId $ProcessId
    if ($null -eq $snap) {
        return $null
    }

    return [pscustomobject]@{
        ts_utc        = (Get-Date).ToUniversalTime().ToString("o")
        run_id        = $RunId
        kind          = $Kind
        pid           = $snap.pid
        name          = $snap.name
        exe           = $snap.exe
        cmdline       = $snap.cmdline
        creationDate  = $snap.creationDate
        note          = $Note
    }
}

function Write-OwnedProcessRecord {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LogPath,
        [Parameter(Mandatory = $true)]
        [object]$Record
    )

    if ($null -eq $Record) {
        return
    }

    $line = ($Record | ConvertTo-Json -Compress -Depth 6)
    Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8
}

function Stop-OwnedProcessRecord {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Record,
        [switch]$Force
    )

    if ($null -eq $Record) {
        return
    }

    $targetPid = [int]$Record.pid
    $expectedCreationDate = [string]$Record.creationDate
    $expectedExe = [string]$Record.exe

    $snap = Get-ProcessSnapshot -ProcessId $targetPid
    if ($null -eq $snap) {
        return
    }

    if (-not [string]::IsNullOrWhiteSpace($expectedCreationDate) -and ($snap.creationDate -ne $expectedCreationDate)) {
        Write-Warning ("Refusing to stop PID {0}: CreationDate mismatch (expected {1}, got {2}). Possible PID reuse." -f $targetPid, $expectedCreationDate, $snap.creationDate)
        return
    }

    if (-not [string]::IsNullOrWhiteSpace($expectedExe) -and ($snap.exe -ne $expectedExe)) {
        Write-Warning ("Refusing to stop PID {0}: ExecutablePath mismatch (expected '{1}', got '{2}')." -f $targetPid, $expectedExe, $snap.exe)
        return
    }

    if ($Force) {
        Stop-Process -Id $targetPid -Force -ErrorAction SilentlyContinue
    } else {
        Stop-Process -Id $targetPid -ErrorAction SilentlyContinue
    }
}
