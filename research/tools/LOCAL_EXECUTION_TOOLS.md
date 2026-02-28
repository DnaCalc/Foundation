# Local Execution Tools Note

This note applies to repository-local research and empirical tooling under `research/tools/`.

## SDK policy
- Use the latest installed **release** .NET 10 SDK: `10.0.103`.
- Do not use preview SDKs for research tooling runs.
- SDK pinning is enforced by [`global.json`](/C:/Work/DnaCalc/Foundation/research/tools/global.json).

## Language policy
- Core research execution tooling should be implemented as stable .NET tools (C# or F#).
- `pwsh`/PowerShell is allowed for convenience orchestration (for example directory traversal, batch invocation, or helper wrappers), but not as the core Excel-driving runtime implementation.
- Python is disallowed for repo tooling unless an explicit exception is granted and logged in policy/doctrine docs.

## Run metadata policy
Tool outputs must include:
- tool build/version,
- current repo git commit (and dirty state when available),
- exact Excel binary path/version/hash for Excel-driven empirical runs.

## Tooling routine
- Treat tooling as long-lived project infrastructure.
- Improve tools incrementally as research needs evolve.
- Prefer backward-compatible command contracts and explicit output schemas.
