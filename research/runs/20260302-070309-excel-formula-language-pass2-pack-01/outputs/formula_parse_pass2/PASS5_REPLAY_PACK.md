# Pass 5 - Replay Pack (Parallel Lane B)

## Purpose
Prepare an execution-ready replay pack for cross-build/channel closure of provisional formula-language lanes, without running those replays in this pass.

## Pack Artifacts
1. `PASS5_REPLAY_MANIFEST.csv`: prioritized replay queue with probe/scenario coverage, prerequisites, and output contracts.
2. Existing pass-2 evidence bundle corpus (`evidence/FMLP2-*`) retained as baseline reference.
3. Existing scenario manifests retained as canonical replay starting points.

## Design Rules Used
1. No scope expansion beyond pass-2 probe families (`P2-FML-001..010`).
2. Every replay task points to concrete scenario IDs and expected output contract.
3. High-risk unresolved lanes are placed at higher priority:
   - linked-data split branch,
   - external reference link-update/open-state behavior,
   - scoped-name policy replay.
4. Tasks that only require stability confirmation are lower priority:
   - normalization replay,
   - precedence checksum replication.

## Outcome
1. Pass-5 is complete as a planning/execution-pack lane.
2. Replay work can now be started directly from `PASS5_REPLAY_MANIFEST.csv` without reconstructing context.
3. Pass-3 interactive review can choose ordering adjustments or additional scenario variants before execution begins.

