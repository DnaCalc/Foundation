@echo off
setlocal
set SCRIPT_DIR=%~dp0
set TOOLS_ROOT=%SCRIPT_DIR%..
set SPEC_PACK_PROCESSOR_INVOKE_CWD=%CD%
pushd "%TOOLS_ROOT%"
dotnet run --project ".\spec-pack-processor\tools\SpecPackProcessor\SpecPackProcessor.csproj" -- %*
set EXITCODE=%ERRORLEVEL%
popd
exit /b %EXITCODE%
