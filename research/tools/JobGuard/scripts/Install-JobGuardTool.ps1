param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$pkgOut = Join-Path $repoRoot "artifacts\\packages"

New-Item -ItemType Directory -Path $pkgOut -Force | Out-Null

Write-Host "Packing JobGuard tool..."
& dotnet pack (Join-Path $repoRoot "tools\\JobGuard\\JobGuard.csproj") -c Release -o $pkgOut
if ($LASTEXITCODE -ne 0) {
    throw "dotnet pack failed with exit code $LASTEXITCODE."
}

if (-not (Test-Path -LiteralPath (Join-Path $repoRoot "dotnet-tools.json"))) {
    Write-Host "Creating local tool manifest..."
    & dotnet new tool-manifest --force
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet new tool-manifest failed with exit code $LASTEXITCODE."
    }
}

$packageId = "XllLambda.JobGuard"
$csprojPath = Join-Path $repoRoot "tools\\JobGuard\\JobGuard.csproj"
[xml]$csproj = Get-Content -LiteralPath $csprojPath
$version = ($csproj.Project.PropertyGroup | Where-Object { $_.Version } | Select-Object -First 1).Version
if ([string]::IsNullOrWhiteSpace($version)) {
    throw "Could not determine <Version> from $csprojPath"
}

$installed = & dotnet tool list --local | Select-String -Pattern ("^\\s*" + [Regex]::Escape($packageId) + "\\s+") -SimpleMatch -ErrorAction SilentlyContinue
if ($null -eq $installed) {
    Write-Host "Installing local tool $packageId $version..."
    & dotnet tool install --local --add-source $pkgOut $packageId --version $version
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet tool install failed with exit code $LASTEXITCODE."
    }
}
else {
    Write-Host "Updating local tool $packageId $version..."
    & dotnet tool update --local --add-source $pkgOut $packageId --version $version
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet tool update failed with exit code $LASTEXITCODE."
    }
}

Write-Host "Tool ready. Usage:"
Write-Host "  dotnet tool run jobguard -- help"

