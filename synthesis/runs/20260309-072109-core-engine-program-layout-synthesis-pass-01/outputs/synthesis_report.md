# Synthesis Report

- Run ID: 20260309-072109-core-engine-program-layout-synthesis-pass-01
- Source run set:
  - prompts/runs/20260308-171858-core-engine-fec-f3e-deep-research-pack-01
  - research/runs/20260305-201430-dag-computation-theory-deep-research-pass-01
  - synthesis/runs/20260308-213253-core-engine-fec-f3e-synthesis-pass-02
  - synthesis/runs/20260309-004109-improvement-notes-synthesis-pass-01
- Date (UTC): 2026-03-09

## Scope
- Documents updated:
  - CHARTER.md
  - README.md
  - ARCHITECTURE_AND_REQUIREMENTS.md
  - CORE_ENGINE_FORMAL_MODEL.md
  - OPERATIONS.md
- Responses considered:
  - Core-engine deep research synthesis and obligations
  - Program catalog/project charter cleaned draft and option-B variant
  - Prior core-engine synthesis promotion pass

## Integrated Findings (severity ordered)
1. Critical: core-engine staged realization needed explicit codification in source-of-truth docs; prior material was distributed across run artifacts.
2. High: program/repo/host naming and ownership needed a stable map to avoid execution ambiguity.
3. High: dependency constitution policy needed concrete baseline edges (not only abstract requirement text).
4. High: sequence-only execution waves for the new repo/host layout needed to be explicit in operations docs.
5. Medium: detailed per-repo charter text belongs in those repos, with Foundation acting as constitutional map owner.
6. Medium: advanced dynamic-topo/SAC promotion remains correctly deferred under bounded experimental-lane policy.

## Decision Summary
- Accepted: 8 (CPL001, CPL002, CPL003, CPL004, CPL005, CPL006, CPL007, CPL009)
- Adapted: 2 (CPL008, CPL011)
- Deferred: 2 (CPL010, CPL012)
- Rejected: 0

## Applied Changes
- `CHARTER.md`:
  - Added explicit component-repo map and host progression map.
  - Added interpretation rule separating round names, repo names, and host names.
- `README.md`:
  - Added concise program map for component lanes and host progression.
- `ARCHITECTURE_AND_REQUIREMENTS.md`:
  - Added `3.19` staged core-engine realization baseline (Option-B execution plan).
  - Added `3.20` repo/host mapping and lane ownership summary.
  - Added constraints `CONSTR-025..027` for overlay lifecycle, coordinator publication authority, and lane-boundary governance.
  - Expanded forward-compatibility section with host progression and dependency-conscious progression rule.
- `CORE_ENGINE_FORMAL_MODEL.md`:
  - Added `6.8` coordinator and staged realization contract, plus baseline host proving guidance.
- `OPERATIONS.md`:
  - Added `7.2` program repo/host layout baseline.
  - Expanded `8.14` with concrete dependency constitution baseline edges.
  - Added `10.3` sequence baseline waves A-G for execution planning.

## Open Follow-ups
1. Author detailed repo-local charters in OxFml/OxCalc/OxVba/host repos and promote Foundation-facing deltas via handoff packets.
2. Calibrate Stage-2/Stage-3 thresholds (parallel determinism, overlay economics, starvation bounds) in pack-owner contracts per profile.
3. Keep advanced dynamic-topo/SAC lanes in bounded experimental policy until parity evidence is green.