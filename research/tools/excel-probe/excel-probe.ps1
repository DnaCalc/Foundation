Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$toolsRoot = Resolve-Path (Join-Path $scriptDir "..")
$projectPath = Join-Path $scriptDir "tools\ExcelProbe\ExcelProbe.csproj"
$env:EXCEL_PROBE_INVOKE_CWD = (Get-Location).Path

Push-Location $toolsRoot
try {
    & dotnet run --project $projectPath -- @args
    exit $LASTEXITCODE
}
finally {
    Pop-Location
}
