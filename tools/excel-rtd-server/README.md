# excel-rtd-server

Local C# RTD COM server tooling for Excel empirical probes.

## Purpose
- Provide a deterministic, local RTD server for `ECS-EB-015` lifecycle testing.
- Keep RTD probe dependencies inside repository-managed tooling.
- Align with COM contract guidance from Kenny Kerr RTD posts and Microsoft RTD/COM documentation.

## Layout
- `tools/ExcelRtdServer/`: COM-visible RTD server implementation (`IRtdServer`).
- `excel-rtd-server.ps1`: build/register/unregister/info helper.
- `excel-rtd-server.cmd`: launcher wrapper for convenience.

## Commands
From repo root:

```cmd
tools\\excel-rtd-server\\excel-rtd-server.cmd build
```

```cmd
tools\\excel-rtd-server\\excel-rtd-server.cmd register
```

```cmd
tools\\excel-rtd-server\\excel-rtd-server.cmd unregister
```

```cmd
tools\\excel-rtd-server\\excel-rtd-server.cmd info
```

## Notes
- Targets `.NET Framework` for straightforward COM exposure (`ComVisible` + classic COM contracts).
- Registers per-user via `RegAsm /regfile` + HKCU import (no admin HKLM write required).
- Default `ProgId`: `DnaCalc.Tools.RtdServer`.
- Topic contract for probes:
  - `TIME` -> formatted current local time.
  - `TICKS` -> monotonic tick counter.
  - `ECHO,<text>` -> static text.
  - `PULSE` -> toggling integer value.
- RTD behavior is deterministic enough for lifecycle probes but not intended as a production feed.


