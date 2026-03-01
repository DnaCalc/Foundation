@echo off
setlocal
set SCRIPT_DIR=%~dp0
set TOOLS_ROOT=%SCRIPT_DIR%..
set EXCEL_PROBE_INVOKE_CWD=%CD%
pushd "%TOOLS_ROOT%"
dotnet run --project ".\excel-probe\tools\ExcelProbe\ExcelProbe.csproj" -- %*
set EXITCODE=%ERRORLEVEL%
popd
exit /b %EXITCODE%
