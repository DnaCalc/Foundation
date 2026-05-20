param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$project = Join-Path $scriptDir "tools\CorpusMonitor\CorpusMonitor.csproj"

if (-not (Test-Path $project)) {
    throw "Missing project file: $project"
}

& dotnet run --project $project -- @Args
exit $LASTEXITCODE
