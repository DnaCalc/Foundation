# OCaml Oracle CLI Contract + Shrinker

## Contradiction check
- No blocking contradictions found across `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `notes/BRAINSTORM_NOTES.md` for this scope.
- One tension to lock down explicitly: Pathfinder UDF range support is described as optional in architecture notes and still open in brainstorm notes. Resolve with a profile flag (`udf_range_inputs: true|false`) in oracle inputs.

## Design goals (stable and file-based)
- Oracle runs as a standalone CLI, never as a linked runtime service.
- Inputs and outputs are canonical files with explicit `schema_version`.
- Deterministic mode is default for conformance and shrinking.
- Failure artifacts are replayable and shrinkable.

ASCII flow:

```text
trace.json + snapshot.json + expected_checkpoints.json
                  |
                  v
          dnac-oracle run-trace
                  |
      conformance_report.json (+ optional mismatch.md)
                  |
      dnac-oracle shrink-trace (if failing)
                  |
      shrunk_trace.json + shrink_report.json
```

## CLI contract
Binary name: `dnac-oracle`

| Command | Purpose | Required inputs | Outputs | Exit codes |
|---|---|---|---|---|
| `run-trace` | Replay operations and compare against expected checkpoints | `--trace`, `--expected`, `--profile` | `--report` (required), `--final-snapshot` (optional) | `0` pass, `10` mismatch, `11` invalid input, `12` internal error |
| `eval-snapshot` | Evaluate a single snapshot to produced values/statuses | `--snapshot`, `--profile` | `--eval-report` | `0` success, `11` invalid input, `12` internal error |
| `shrink-trace` | Minimize failing trace while preserving failure predicate | `--trace`, `--expected`, `--profile`, `--failure-id` | `--shrunk-trace`, `--shrink-report` | `0` shrunk, `14` not shrinkable, `11` invalid input, `12` internal error |
| `explain-mismatch` | Produce human-readable diagnosis from a failing report | `--report` | `--explanation-md` | `0` success, `11` invalid input |

Stable CLI rules:
- All options are long-form, kebab-case.
- Inputs are file paths only; no inline JSON payloads.
- Output files are always fully overwritten atomically (write temp + rename).
- `--schema-lock <major>` fails if input/output major version differs.

## Canonical file formats
All files are UTF-8 JSON with top-level fields:
- `schema`: string name
- `schema_version`: semver string (`MAJOR.MINOR.PATCH`)
- `profile_id`: string
- `profile_version`: string
- `extensions`: object (optional, unknown fields ignored)

### 1) Trace file (`trace.json`)
Purpose: deterministic replay log for oracle stepping.

```json
{
  "schema": "dnac.trace",
  "schema_version": "1.0.0",
  "profile_id": "visicalc.core",
  "profile_version": "0.1.0",
  "mode": "auto",
  "seed": 0,
  "ops": [
    {"op_id": "1", "kind": "SetCell", "cell": "A1", "formula": "=1"},
    {"op_id": "2", "kind": "SetCell", "cell": "A2", "formula": "=A1+1"},
    {"op_id": "3", "kind": "RecalcNow"}
  ],
  "checkpoints": ["cp-1", "cp-2"]
}
```

Required semantics:
- `mode`: `manual` or `auto` (drives stepper behavior).
- `ops` are ordered and immutable.
- `RecalcNow` is legal only in manual mode (or no-op warning in auto mode if profile allows).

### 2) Snapshot file (`snapshot.json`)
Purpose: immutable document state at an epoch for direct eval.

```json
{
  "schema": "dnac.snapshot",
  "schema_version": "1.0.0",
  "profile_id": "visicalc.core",
  "profile_version": "0.1.0",
  "epoch": 42,
  "cells": {
    "A1": {"expr": "=1"},
    "A2": {"expr": "=A1+1"}
  },
  "externals": {
    "STREAM:topic1": {"value": 10, "value_epoch": 42}
  }
}
```

### 3) Expected checkpoints (`expected_checkpoints.json`)
Purpose: assertions at named points during replay.

```json
{
  "schema": "dnac.expected_checkpoints",
  "schema_version": "1.0.0",
  "profile_id": "visicalc.core",
  "profile_version": "0.1.0",
  "checkpoints": [
    {
      "checkpoint_id": "cp-1",
      "after_op_id": "2",
      "expect": {
        "A2": {"value": 2, "status": "fresh", "value_epoch": 2}
      }
    }
  ]
}
```

### 4) Conformance report (`conformance_report.json`)
Purpose: machine-readable pass/fail artifact for packs and CI.

```json
{
  "schema": "dnac.conformance_report",
  "schema_version": "1.0.0",
  "profile_id": "visicalc.core",
  "profile_version": "0.1.0",
  "result": "fail",
  "failure_id": "F-00017",
  "summary": {
    "ops_total": 3,
    "checkpoints_total": 1,
    "mismatches": 1
  },
  "mismatches": [
    {
      "checkpoint_id": "cp-1",
      "cell": "A2",
      "expected": {"value": 2, "status": "fresh", "value_epoch": 2},
      "actual": {"value": 3, "status": "fresh", "value_epoch": 2},
      "kind": "value"
    }
  ],
  "artifacts": {
    "trace": "trace.json",
    "expected": "expected_checkpoints.json"
  }
}
```

## Shrinker strategy
Failure predicate:
- `run-trace(trace, expected, profile)` must produce the same `failure_id` (or stricter equivalent mismatch signature).

Algorithm (deterministic, layered):
1. Normalize:
- Canonicalize op ordering fields, remove non-semantic metadata, freeze seed.
2. Coarse reduction (ddmin over op chunks):
- Remove contiguous op blocks; keep candidate if failure predicate still holds.
3. Semantic reduction:
- Replace formulas with simpler equivalents (`=A1+0` -> `=A1`, constants to smaller integers, shorter refs).
- Simplify structural ops to smaller ranges.
4. Checkpoint reduction:
- Drop non-essential checkpoints while preserving the same failure.
5. Delta polishing:
- Try single-op deletions and single-field simplifications until fixed point.

Operational requirements:
- Cache candidate hashes to avoid duplicate oracle runs.
- Enforce max attempts/time budget with deterministic tie-breakers.
- Emit `shrink_report.json` including original size, final size, and preserved failure signature.

## Keep the oracle deliberately simple
Must include:
- Deterministic evaluator for Pathfinder scope.
- Replay stepper for trace ops.
- Checkpoint comparator and mismatch classifier.
- Shrinker that calls the same CLI contract (no hidden path).

Must not include:
- No network calls or workbook file parsing logic.
- No UI state handling, rendering logic, or editor semantics.
- No plugin discovery/loading at runtime.
- No distributed scheduling or concurrency simulation beyond deterministic stepping.
- No policy-heavy interop transforms (lowering belongs to adapters/packs).

Simplicity guardrails:
- One core evaluator path used by `run-trace` and `eval-snapshot`.
- No command-specific evaluation semantics.
- Any new feature requires: schema field, profile gate, and conformance test fixture.

## Manual and auto recalc support in the reference stepper
Stepper state:
- `snapshot`
- `dirty_set`
- `committed_epoch`
- `stabilized_epoch`
- `mode` (`manual` or `auto`)

Mode semantics:
- Auto mode:
  - Every mutating op triggers invalidation closure + evaluation before next op.
  - Checkpoints can assert both fresh and stale transitions if profile allows.
- Manual mode:
  - Mutating ops update formulas and dirty set only.
  - Re-evaluation happens on explicit `RecalcNow` op.
  - Until recalc, dependent cells are reported as stale/pending with last stable `value_epoch`.

Compatibility rule:
- Same trace in different modes may yield different intermediate checkpoints but must converge at explicit recalc boundaries defined by profile.

## Proposed doc edits (exact targets)
1. `ARCHITECTURE_AND_REQUIREMENTS.md`
- Under `## 6. Pathfinder Scope Anchor (DnaVisiCalc)`, add subsection `### 6.1 REAL-ORACLE-CLI-001 (OCaml CLI Contract)` with command list and stable file-format requirement.
- Under `## 4. Architectural Constraints`, add `CONSTR-006: Oracle/tool integration is file/CLI-based with versioned schemas; no in-process dependency.`

2. `OPERATIONS.md`
- Under `## 6. Tooling Interface Rules`, add `### 6.1 Oracle Command Contract` (exit codes, required artifacts, schema locking).
- Under `## 5. Regression Handling (AAR-driven)`, add requirement that failing traces must be shrinkable artifacts (`trace`, `expected`, `failure_id`, `shrunk_trace`, `shrink_report`).

3. `CHARTER.md`
- Under `## 2.1 Hygiene Doctrine`, in item 4 (`Regressions are assets`), add explicit pointer: minimized trace artifacts are mandatory machine-replayable oracle inputs.

## Smallest high-impact next actions
1. Freeze JSON schemas at `1.0.0` for `trace`, `snapshot`, `expected_checkpoints`, and `conformance_report`.
2. Implement `run-trace` and `eval-snapshot` first using one shared evaluator path.
3. Add `shrink-trace` with ddmin + simplification passes and deterministic caching.
4. Wire one CI pack that fails only on conformance report `result != pass` and stores shrink artifacts.
