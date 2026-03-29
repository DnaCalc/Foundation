# OxReplay Repo Bootstrap Plan

## Objective
Prepare the first starter-doc pack for `OxReplay`, the shared Replay appliance implementation repo and library family for DNA Calc.

## Decided ownership
1. Foundation owns Replay doctrine, architecture, governance, registries, lifecycle policy, and rollout rules.
2. `OxFunc`, `OxFml`, `OxCalc`, and `OxVba` remain authoritative for lane-native replay semantics and adapter meaning.
3. `OxReplay` owns the shared implementation substrate for bundle validation, replay, diff/explain, witness distillation, registry/lifecycle tooling, adapter conformance, and the `DNA ReCalc` host surface.
4. `DNA ReCalc` is the replay host over `OxReplay`; it is not a spreadsheet proving host and not a semantics lane.

## Included in this pack
1. Bootstrap templates for repo-level `README`, `CHARTER`, `OPERATIONS`, and `AGENTS`.
2. A starter mutable spec set under `docs/spec/`.
3. Explicit scope and boundary text so `OxReplay` starts with the right ownership split instead of drifting into lane semantics.

## Why this is doc-only
1. The key requirement at this stage is scope lock, not automation.
2. `OxCalc` and `OxFml` now have prompt-based Replay integration underway, so the immediate need is a repo charter and spec seed for shared infrastructure.
3. A repo-creation script can follow later if the physical `OxReplay` repo should be generated from templates.

## Immediate post-bootstrap actions
1. Initialize the `../OxReplay` repo when desired and copy in this starter doc set.
2. Confirm whether `OxCalc` and `OxFml` adapter surfaces are stable enough to define the first `OxReplay` abstractions package boundary.
3. Open the first `OxReplay` workset around:
   - bundle and schema runtime,
   - adapter capability manifest validation,
   - `OxCalc` and `OxFml` adapter harness loading,
   - initial `DNA ReCalc` CLI shell.
4. Keep all lane-semantic interpretations in the lane repos; only the shared mechanics move into `OxReplay`.

## Known follow-ups
1. Decide when to extract common code from lane repos versus implementing directly in `OxReplay`.
2. Add a repo-bootstrap script only if the repo is going to be instantiated from Foundation templates repeatedly.
3. Add CI/readiness notes once the first concrete `OxReplay` package graph is chosen.
