# Research Tools

This directory holds local tooling used by research/empirical runs.

## Current tools
- `excel-probe/`
  - .NET (C#) Excel empirical runner (`run`, `run-manifest`, and `env` commands).
  - Optional wrappers (`.cmd` / `.ps1`) are convenience launchers only; runtime logic is in `tools/ExcelProbe/`.
- `JobGuard/`
  - Local Windows Job helper tooling (source/scripts) for process containment and cleanup.
- `global.json`
  - Pins local research tools to .NET SDK `10.0.103` (latest installed release, preview disallowed).
- `LOCAL_EXECUTION_TOOLS.md`
  - Local tooling policy note (SDK pin, language policy, and run metadata expectations).

## Usage note
Tool outputs should be written into the target run directory and referenced from that run's `logs/manifest.csv`.
