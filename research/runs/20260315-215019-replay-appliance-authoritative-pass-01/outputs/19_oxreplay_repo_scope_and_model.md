# OxReplay Repo Scope And DNA ReCalc Host Model

## 1. Position
This document captures the repo and host naming decision for the Replay appliance implementation layer.

Decision:
- `OxReplay` is the core shared replay repo and library family,
- `DNA ReCalc` is the CLI, UI, and replay-host surface built on top of `OxReplay`,
- the Replay appliance remains the cross-lane architectural concept governed by Foundation doctrine.

This does not create a new semantics lane.

## 2. Why this split is the right one
The split solves two different naming jobs:

1. `OxReplay` names the reusable implementation substrate,
2. `DNA ReCalc` names the user-facing tool and host experience,
3. `Replay appliance` remains the architectural and doctrinal concept.

This avoids overloading one name with:
- repo topology,
- internal library code,
- end-user CLI or UI identity,
- and cross-program doctrine.

## 3. Topology model
The intended cross-program structure becomes:

1. **Foundation**
   - owns Replay doctrine, architecture, governance, registries, lifecycle policy, and promotion rules.
2. **`OxFunc`, `OxFml`, `OxCalc`, `OxVba`**
   - own lane-native semantics, capture meaning, and authoritative lane-local replay semantics.
3. **`OxReplay`**
   - owns the shared implementation substrate for the Replay appliance.
4. **`DNA ReCalc`**
   - is the executable replay host built on `OxReplay`.

Interpretation rule:
- `OxReplay` is a peer repo in topology,
- but it is not a peer semantics lane to `OxFunc`, `OxFml`, `OxCalc`, or `OxVba`.

## 4. What `OxReplay` owns
`OxReplay` should own shared implementation for:

1. canonical bundle parsing, validation, serialization, and indexing,
2. normalized replay-model runtime types,
3. bundle normalization orchestration where normalization is lane-agnostic,
4. replay executor infrastructure,
5. diff engine,
6. explain engine,
7. witness-distillation framework,
8. registry and witness-lifecycle manager,
9. conformance harnesses for adapter-capability validation,
10. shared adapter SDK and loader/runtime,
11. pack-export infrastructure for replay-governed packs,
12. the `DNA ReCalc` CLI and later UI host surfaces.

This means `OxReplay` is the implementation home for shared replay machinery, not the doctrinal source of truth.

## 5. What `OxReplay` must not own
`OxReplay` must not take ownership of:

1. lane-local event semantics,
2. lane-local reject taxonomies,
3. lane-local predicate meanings beyond cross-lane canonical ids,
4. lane-local reduction rewrite permissions,
5. lane-local artifact identity rules,
6. lane-local capture instrumentation obligations,
7. any unilateral reinterpretation of `Ox*` source artifacts.

Those remain owned by the relevant lane repos and promoted to Foundation only when they become cross-lane doctrine.

## 6. Adapter ownership model
The cleanest implementation split is:

1. Foundation defines the adapter contract doctrinally,
2. `OxReplay` provides the adapter SDK, loader, validator, and conformance harness,
3. each `Ox*` repo remains the default owner of its authoritative adapter implementation or adapter-emission surface,
4. `DNA ReCalc` discovers and executes adapters through the `OxReplay` adapter surface.

Default rule:
- lane semantics stay with the lane,
- shared replay mechanics stay with `OxReplay`.

Permitted implementation patterns:
1. lane repo emits canonical bundle artifacts directly with no runtime dependency on `OxReplay`,
2. lane repo depends only on a narrow `OxReplay` adapter-abstractions package,
3. lane repo ships an adapter plugin consumed by `DNA ReCalc`,
4. `OxReplay` hosts test doubles or conformance fixtures for lane adapters, but not the lane's semantic authority.

## 7. Library and executable breakdown
An intended package or module split for `OxReplay` is:

1. `OxReplay.Abstractions`
   - adapter interfaces,
   - capability manifest types,
   - registry references,
   - witness lifecycle references,
   - shared ids and envelopes.
2. `OxReplay.Bundle`
   - bundle manifest parsing,
   - schema validation,
   - sidecar resolution,
   - indexing.
3. `OxReplay.Core`
   - normalized replay runtime model,
   - orchestration primitives,
   - shared execution context.
4. `OxReplay.Diff`
   - replay diff computation,
   - mismatch typing,
   - severity binding.
5. `OxReplay.Explain`
   - explanation queries,
   - provenance joins,
   - causal summaries.
6. `OxReplay.Distill`
   - preservation predicates,
   - reduction search,
   - reduction manifest emission,
   - witness-bundle output.
7. `OxReplay.Governance`
   - registry snapshots,
   - capability validation,
   - lifecycle transitions,
   - quarantine handling.
8. `OxReplay.Conformance`
   - capability-level evidence validation,
   - adapter conformance suites,
   - pack-facing replay validation harnesses.
9. `DNA.ReCalc.Cli`
   - command-line host over `OxReplay`.
10. `DNA.ReCalc.Ui`
   - later optional UI shell over the same runtime surfaces.

This is a model breakdown, not a package lock.

## 8. Dependency constitution impact
The intended dependency rules are:

1. `OxReplay` may depend on shared abstractions and bundle schemas, but not on lane-internal semantic engines,
2. lane repos may depend on `OxReplay.Abstractions` only if that dependency is narrow and does not pull in the full replay runtime,
3. `DNA ReCalc` depends on `OxReplay`,
4. Foundation depends on none of these code artifacts; it owns the doctrine only,
5. host repos should prefer invoking `DNA ReCalc` or consuming emitted artifacts rather than linking against lane internals through `OxReplay`.

Forbidden or discouraged patterns:

1. `OxReplay` importing lane-semantic internals to interpret meaning outside the adapter contract,
2. lane repos depending on broad `OxReplay` runtime packages for their semantic core,
3. adapters becoming a backdoor for Foundation doctrine bypass,
4. `DNA ReCalc` becoming a second source of semantic truth.

## 9. Relationship to existing host progression
`DNA ReCalc` is a replay host and tool surface.

It is not:
- a spreadsheet product-stage host like `DNA OneCalc`, `DNA TreeCalc`, or `DNA PreCalc`,
- a new program round,
- or a substitute for lane-proving hosts.

It should therefore be documented separately from the spreadsheet host progression map, while still appearing in Replay-specific architecture and repo-layout notes.

## 10. Rollout model
The intended rollout remains staged:

1. Foundation promotes the Replay appliance doctrine and architecture first,
2. `OxCalc` and `OxFml` prove the first adapter slices against the doctrinal contract,
3. shared stable replay mechanics are extracted or implemented in `OxReplay`,
4. `DNA ReCalc` becomes the primary shared CLI or UI host over that substrate,
5. later lanes widen onto the same replay plane through adapter conformance.

This sequencing avoids inventing abstractions in `OxReplay` before the first two adapters have proved the real shared surface.

## 11. Foundation implications
Foundation should eventually reflect this model as follows:

1. `CHARTER.md`
   - add `OxReplay` as a shared replay implementation repo,
   - clarify that `DNA ReCalc` is a replay host rather than a spreadsheet product host.
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
   - add `OxReplay` to the repo and ownership map,
   - state that Replay is implemented through lane adapters plus shared `OxReplay` infrastructure.
3. `OPERATIONS.md`
   - update program repo layout,
   - update dependency constitution,
   - update replay rollout governance to name `OxReplay` and `DNA ReCalc`.
4. `REPLAY_APPLIANCE.md`
   - carry the full implementation-boundary and ownership model in detail.
5. `README.md`
   - point readers to the Replay appliance doctrine and the `OxReplay`/`DNA ReCalc` split.

## 12. Resulting rule
`OxReplay` should be treated as the shared replay implementation repo and library family, while `DNA ReCalc` should be treated as the executable replay host built on top of it.

That gives the program a clear split between:
- doctrine,
- lane semantics,
- shared replay infrastructure,
- and user-facing replay tooling.
