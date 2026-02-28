$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestPath = Join-Path $root "scenario_manifest_wave1.csv"
$evidenceRoot = Join-Path $root "evidence"
$repoRoot = (Resolve-Path (Join-Path $root "..\\..\\..\\..\\..")).Path
$runnerCmd = Join-Path $repoRoot "research\\tools\\excel-probe\\excel-probe.cmd"

if (-not (Test-Path $manifestPath)) {
  throw "Manifest not found: $manifestPath"
}
if (-not (Test-Path $runnerCmd)) {
  throw "Runner launcher not found: $runnerCmd"
}

New-Item -ItemType Directory -Path $evidenceRoot -Force | Out-Null
& $runnerCmd run-manifest --manifest $manifestPath --base-dir $root --out-root $evidenceRoot --visible false --timeout-sec 180
