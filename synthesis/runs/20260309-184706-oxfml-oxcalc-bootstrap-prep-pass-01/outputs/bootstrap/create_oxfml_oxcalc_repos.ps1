param(
  [switch]$DryRun,
  [switch]$Overwrite
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$foundationRoot = (Resolve-Path (Join-Path $scriptRoot '..\..\..\..\..')).Path
$dnaCalcRoot = Split-Path -Parent $foundationRoot
$manifestPath = Join-Path $scriptRoot 'SPEC_TRANSFER_MANIFEST.csv'
$templateRoot = Join-Path $scriptRoot 'templates'

$repoRoots = @{
  OxFml  = Join-Path $dnaCalcRoot 'OxFml'
  OxCalc = Join-Path $dnaCalcRoot 'OxCalc'
}

function Write-Step($text) {
  Write-Host "[bootstrap] $text"
}

function Ensure-Dir($path) {
  if (-not (Test-Path $path)) {
    if ($DryRun) {
      Write-Step "mkdir $path"
    } else {
      New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
  }
}

Write-Step "Foundation root: $foundationRoot"
Write-Step "DnaCalc root: $dnaCalcRoot"

foreach ($repoName in $repoRoots.Keys) {
  $repoRoot = $repoRoots[$repoName]
  Ensure-Dir $repoRoot

  $templateRepoRoot = Join-Path $templateRoot ($repoName.ToLower())
  if (-not (Test-Path $templateRepoRoot)) {
    throw "Missing template directory: $templateRepoRoot"
  }

  Write-Step "Applying templates to $repoName ($repoRoot)"
  $templateFiles = Get-ChildItem -Path $templateRepoRoot -File -Recurse
  foreach ($file in $templateFiles) {
    $relative = [System.IO.Path]::GetRelativePath($templateRepoRoot, $file.FullName)
    $dest = Join-Path $repoRoot $relative
    Ensure-Dir (Split-Path -Parent $dest)
    if ((Test-Path $dest) -and -not $Overwrite) {
      Write-Step "skip existing template file: $dest"
      continue
    }
    if ($DryRun) {
      Write-Step "copy template $($file.FullName) -> $dest"
    } else {
      Copy-Item -Path $file.FullName -Destination $dest -Force
    }
  }
}

$rows = Import-Csv -Path $manifestPath
foreach ($row in $rows) {
  $repoName = $row.repo
  if (-not $repoRoots.ContainsKey($repoName)) {
    throw "Unknown repo in manifest: $repoName"
  }

  $src = Join-Path $foundationRoot $row.source_relative_path
  $dst = Join-Path $repoRoots[$repoName] $row.target_relative_path

  if (-not (Test-Path $src)) {
    throw "Missing source file: $src"
  }

  Ensure-Dir (Split-Path -Parent $dst)

  if ((Test-Path $dst) -and -not $Overwrite) {
    Write-Step "skip existing spec file: $dst"
    continue
  }

  if ($DryRun) {
    Write-Step "copy spec $src -> $dst"
  } else {
    Copy-Item -Path $src -Destination $dst -Force
  }
}

Write-Step 'Bootstrap complete.'
Write-Step 'Next: initialize git in OxFml/OxCalc if needed and review copied docs for local lane edits.'
