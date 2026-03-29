# OPERATIONS.md — OxReplay Operations

## 1. Purpose
Define day-to-day execution rules for the shared Replay appliance runtime and the `DNA ReCalc` host.

## 2. Operating principles
1. Shared replay mechanics are centralized; semantic meaning remains lane-owned.
2. All shared outputs must preserve source identity and schema lineage explicitly.
3. Canonical registry ids and witness lifecycle state are first-class runtime concerns, not optional metadata.
4. Distillation is offline and must remain predicate-driven and replay-closed.

## 3. Working strata
Initial implementation strata are:
1. `Abstractions`
   - adapter interfaces, ids, manifest types, registry refs, lifecycle refs.
2. `Bundle`
   - manifest parsing, validation, sidecar resolution, indexing.
3. `Core`
   - normalized replay runtime types and orchestration context.
4. `Diff` and `Explain`
   - typed mismatch and causal-query surfaces.
5. `Distill`
   - predicate execution, reduction search, reduction-manifest emission.
6. `Governance` and `Conformance`
   - capability validation, registry snapshots, lifecycle transitions, conformance harnesses.
7. `DNA ReCalc`
   - CLI first, optional later UI host over the same runtime surfaces.

## 4. Required packs baseline
1. `PACK.replay.appliance`
2. `PACK.trace.forensic_plane`
3. `PACK.diff.cross_engine.continuous`

## 5. Adapter intake rule
When shared runtime changes affect lane adapters:
1. confirm the change is mechanical rather than semantic,
2. identify affected capability levels,
3. record required migration or fallback behavior,
4. route doctrine-affecting changes back to Foundation through managed-run promotion packets.

## 6. Initial implementation order
1. Bundle and schema runtime.
2. Capability-manifest and registry validation.
3. `OxCalc` and `OxFml` adapter harness loading.
4. Diff and explain runtime.
5. Witness distillation runtime.
6. `DNA ReCalc` command shell and pack-facing export surface.

## 7. Promotion gate
No shared Replay runtime promotion without:
1. updated spec text for affected strata,
2. declared adapter and capability impact,
3. replay-governed pack impact notes,
4. explicit check that no lane-semantic authority was absorbed into `OxReplay`.
