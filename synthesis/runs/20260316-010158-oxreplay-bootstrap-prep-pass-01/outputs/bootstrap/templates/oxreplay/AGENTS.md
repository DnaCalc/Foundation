# AGENTS.md - OxReplay Agent Execution Doctrine

This file defines how coding agents should operate in the `OxReplay` repository.

## 1. Context loading doctrine
Do not assume Replay context is already loaded.

Before proposing architecture or process changes:
1. Read `README.md`.
2. Read `CHARTER.md`.
3. Read `OPERATIONS.md`.
4. Read `docs/spec/README.md`.
5. Read `docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md`.
6. Read `docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`.
7. Read `docs/spec/DNA_RECALC_HOST.md`.
8. Read `../Foundation/REPLAY_APPLIANCE.md`.
9. Read `../Foundation/CHARTER.md`, `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`, and `../Foundation/OPERATIONS.md` when doctrine precedence matters.

## 2. Source-of-truth handling
1. Foundation owns Replay doctrine and higher-precedence governance.
2. This repo owns shared replay implementation detail and mutable local specs.
3. Lane repos remain authoritative for lane-native semantic meaning.

If guidance conflicts:
1. follow Foundation doctrine first,
2. then follow this repo charter and operations,
3. then follow local implementation detail.

## 3. Change discipline
1. Keep `OxReplay` from absorbing lane-semantic ownership.
2. Treat adapter contracts as semantic boundaries, not convenience escape hatches.
3. Place new local policy in the most specific spec file practical.
4. Require explicit capability and pack impact notes for changes touching replay-governed surfaces.
