param(
    [Parameter(Position = 0)]
    [ValidateSet("build", "register", "unregister", "info")]
    [string]$Command = "info"
)

$ErrorActionPreference = "Stop"

$toolsRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $toolsRoot

$project = "excel-rtd-server/tools/ExcelRtdServer/ExcelRtdServer.csproj"
$outDir = "excel-rtd-server/tools/ExcelRtdServer/bin/Debug/net48"
$serverDll = Join-Path $outDir "ExcelRtdServer.dll"
$regTemplate = Join-Path $outDir "ExcelRtdServer.hkcr.reg"
$regUser = Join-Path $outDir "ExcelRtdServer.hkcu.reg"
$progId = "DnaCalc.Tools.RtdServer"
$classGuid = "{B8D5528C-16D5-4AF1-B22E-8687B13C1B6A}"
$assemblyTypeLibGuid = "{DAE7783A-A2F1-4FD1-BF7F-9869F0F63CC2}"

function Get-RegAsmPath {
    $regAsm64 = Join-Path $env:WINDIR "Microsoft.NET\\Framework64\\v4.0.30319\\RegAsm.exe"
    $regAsm32 = Join-Path $env:WINDIR "Microsoft.NET\\Framework\\v4.0.30319\\RegAsm.exe"
    if (Test-Path $regAsm64) { return $regAsm64 }
    if (Test-Path $regAsm32) { return $regAsm32 }
    throw "RegAsm.exe not found in .NET Framework paths."
}

function Ensure-Build {
    dotnet build $project -nologo
    if ($LASTEXITCODE -ne 0) { throw "dotnet build failed with exit code $LASTEXITCODE" }
    if (-not (Test-Path $serverDll)) { throw "Missing server artifact: $serverDll" }
}

function Ensure-RegistryTemplate {
    $regAsm = Get-RegAsmPath
    & $regAsm $serverDll /nologo /codebase /regfile:$regTemplate
    if ($LASTEXITCODE -ne 0) { throw "RegAsm /regfile failed with exit code $LASTEXITCODE" }
    if (-not (Test-Path $regTemplate)) { throw "Missing RegAsm template output: $regTemplate" }
}

function Write-UserRegistryFile {
    $raw = Get-Content $regTemplate -Raw
    $raw = $raw.Replace("HKEY_CLASSES_ROOT\", "HKEY_CURRENT_USER\Software\Classes\")
    Set-Content -Path $regUser -Value $raw
}

function Remove-RegistryTreeIfExists([string]$path) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
    }
}

switch ($Command) {
    "build" {
        Ensure-Build
        Write-Host "Built RTD server." -ForegroundColor Green
        Write-Host "Server DLL:  $serverDll"
    }
    "register" {
        Ensure-Build
        Ensure-RegistryTemplate
        Write-UserRegistryFile
        & reg.exe import $regUser
        if ($LASTEXITCODE -ne 0) { throw "reg import failed with exit code $LASTEXITCODE" }
        Write-Host "Registered RTD COM server in HKCU via RegAsm template." -ForegroundColor Green
        Write-Host "ProgId: $progId"
        Write-Host "Class:  $classGuid"
    }
    "unregister" {
        Remove-RegistryTreeIfExists "Registry::HKEY_CURRENT_USER\Software\Classes\$progId"
        Remove-RegistryTreeIfExists "Registry::HKEY_CURRENT_USER\Software\Classes\CLSID\$classGuid"
        Remove-RegistryTreeIfExists "Registry::HKEY_CURRENT_USER\Software\Classes\TypeLib\$assemblyTypeLibGuid"
        Write-Host "Unregistered RTD COM server keys from HKCU." -ForegroundColor Green
    }
    "info" {
        $exists = Test-Path $serverDll
        $regPath = "Registry::HKEY_CURRENT_USER\Software\Classes\$progId\CLSID"
        Write-Host "Project:      $project"
        Write-Host "Server DLL:   $serverDll (exists=$exists)"
        if (Test-Path $regPath) {
            $clsid = (Get-ItemProperty $regPath)."(default)"
            Write-Host "ProgId:       $progId (registered, CLSID=$clsid)"
        } else {
            Write-Host "ProgId:       $progId (not registered in HKCU)"
        }
        Write-Host "Usage:        excel-rtd-server.cmd [build|register|unregister|info]"
    }
}
