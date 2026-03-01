# JobGuard

`jobguard` is a local repo tool that uses Windows Job objects to prevent stray processes
(Excel, debuggers, harness runners) from leaking across failed runs and holding file locks.

## Install / Update (local tool)

From repo root:

```powershell
.\scripts\Install-JobGuardTool.ps1
```

## Usage

Run a root command inside a Job and (optionally) assign an additional PID (e.g. COM-launched Excel):

```powershell
dotnet tool run jobguard -- run --job-name MyTest.JobGuard `
  --assign-pid-file .\artifacts\runs\excel.pid `
  --require-exe-contains EXCEL.EXE `
  --require-cmdline-contains /automation `
  --verbose -- `
  dotnet .\harness\ExcelComRunner\bin\Release\net10.0-windows\ExcelComRunner.dll `
    --xll .\native\MyWork\build\x64\MyXll.xll `
    --formula '=AddTwo(2,3)' `
    --pid-file .\artifacts\runs\excel.pid
```

Notes:
- COM-launched Excel is often not a child of the runner process; assigning by PID file is expected.
- If assigning `EXCEL.EXE` fails with access denied and `in_job=true`, the target is likely already job-contained
  (or in a different job chain than another process you already assigned). Try `--breakaway-from-parent-job`
  for the root process, or fall back to owned-process logging (`scripts/_lib/ProcessGuardian.ps1` +
  `scripts/Stop-OwnedProcesses.ps1`).