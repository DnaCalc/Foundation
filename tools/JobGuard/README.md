# JobGuard

Windows Job helper tooling used to contain and clean up empirical-run processes (including Excel and runner processes).

## Contents
- `tools/JobGuard/`: C# command-line tool source.
- `scripts/Install-JobGuardTool.ps1`: local tool install helper.
- `scripts/Stop-OwnedProcesses.ps1`: owned-process cleanup helper.
- `scripts/_lib/ProcessGuardian.ps1`: process ownership/cleanup library.

## Intended use
- Keep empirical runs from leaking background processes.
- Provide deterministic cleanup in failure and timeout paths.
