## Source-of-truth check

Using `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `notes/BRAINSTORM_NOTES.md` as authoritative input.

### Contradictions found

No hard contradictions for this topic. One operational tension exists:

- `CHARTER.md` requires one-command readiness (`meta check`) and computed obligations.
- `OPERATIONS.md` allows local manual mode deferring heavy packs.

Coherent resolution:

- Keep `meta check` as the single readiness entrypoint.
- Add mode policy: `meta check --mode local` may defer heavy packs; `meta check --mode ci` is non-deferable and merge-gating.

## Current state (from docs)

- Logistics owns `meta` orchestration and CI wiring (`OPERATIONS.md` 2.1, 6).
- Packs are readiness units; Green vetoes stabilization (`OPERATIONS.md` 2.1, 4).
- Obligations must be computed from diffs/profiles, not hand-picked (`CHARTER.md` 2.1).
- Red and Blue must expose identical protocol surfaces (`ARCHITECTURE_AND_REQUIREMENTS.md` 3.1, CONSTR-004).

## Proposal: .NET `meta` CLI

### 1) Command list

| Command | Purpose | Key inputs | Key outputs |
|---|---|---|---|
| `meta check` | One-command readiness; resolve + run + gate | changed files, profile pin/matrix, pack catalog | exit code, conformance summary, required-fail list |
| `meta resolve` | Compute affected DAG closure and required packs only | changed files, profile defs, pack schema, capabilities | `resolution.json` (nodes, packs, reasons, topo order) |
| `meta run-pack` | Execute one pack or resolved set | pack id(s), engine/profile matrix, cache policy | pack reports, traces, junit/sarif |
| `meta report` | Aggregate outputs into human/CI artifacts | run ids, pack reports, capabilities | conformance report md/json, trend deltas |
| `meta pin-profile` | Set local/default profile for commands | profile id/version | local pin file + echoed effective matrix |
| `meta list-packs` | Discover available packs/versions/owners | pack catalog | table/json list |
| `meta explain` | Why a pack is required (traceability) | resolution graph, pack id | dependency/explanation tree |
| `meta capabilities` | Emit or validate runtime/build manifest | engine build metadata | capability manifest json |
| `meta cache` (`stats|gc|warm`) | Manage local/remote caches | cache root, retention policy | cache diagnostics |
| `meta doctor` | Environment/toolchain sanity check | toolchain presence, schema versions | actionable diagnostics |

Minimal aliases:

- `meta r` -> `resolve`
- `meta rp` -> `run-pack`
- `meta c` -> `check`

### 2) Inputs and outputs

#### Inputs

- Doctrine/docs (read-only policy context):
  - `CHARTER.md`
  - `OPERATIONS.md`
  - `ARCHITECTURE_AND_REQUIREMENTS.md`
  - `notes/BRAINSTORM_NOTES.md` (supporting)
- Profile definitions:
  - `profiles/<profile_id>/<profile_version>.profile.yaml`
- Obligation pack declarations:
  - `packs/<pack_id>.pack.yaml`
- Dependency map:
  - `meta/dependency-map.yaml` (path globs -> DAG nodes)
- Changed files set:
  - `git diff --name-only <base>...<head>` or explicit `--changed-file`
- Capability manifests (per engine/build):
  - `artifacts/capabilities/<engine>/<build>.capabilities.json`

#### Outputs

- `artifacts/meta/<run_id>/resolution.json`
  - dirty roots, affected nodes, required packs, topological execution order, reason graph
- `artifacts/meta/<run_id>/conformance.json`
  - pack pass/fail/skipped, profile gating outcome, minimized-case links
- `artifacts/meta/<run_id>/conformance.md`
  - human report for PR/release workflows
- `artifacts/meta/<run_id>/capabilities-merged.json`
  - resolved engine capabilities used by resolver
- `artifacts/meta/<run_id>/junit.xml` and `sarif.json`
  - CI integration formats

### 3) Obligation pack schema + resolver closure

#### Pack declaration schema (YAML)

```yaml
id: PACK.structural.insert
version: 1.3.0
owner: Green
stage: assurance
applies_to:
  profiles:
    - visicalc.v1
    - precalc.v1
  engines:
    - red
    - blue
requires:
  packs:
    - PACK.visicalc.core
  capabilities:
    protocol_surface: ">=1.0.0"
    deterministic_mode: true
triggers:
  paths:
    - spec/structural/**
    - engines/**/structural/**
    - protocols/operations/**
  nodes:
    - Spec.StructuralRewrite
    - Impl.ReferenceRewrite
execution:
  command: ["dotnet", "run", "--project", "tools/packs/StructuralInsert", "--"]
  timeout_seconds: 1200
artifacts:
  report: conformance/PACK.structural.insert.json
  minimized_case_dir: cases/minimized/structural-insert
cache:
  inputs:
    - pack.version
    - profile.version
    - engine.capabilities_hash
    - changed_nodes_hash
    - toolchain_hash
```

#### Resolver model

DAG node classes:

- `SpecNode` (Lean/TLA/schema/profile)
- `AssuranceNode` (packs/oracle/case generators)
- `ImplNode` (Red/Blue modules)
- `InteropNode` (file adapters/diff harness)

ASCII flow:

```text
changed files
   -> dirty nodes (via dependency-map)
   -> transitive closure over DAG
   -> impacted profiles
   -> required packs (profile obligations U closure(pack.requires))
   -> capability filter (engine/profile compatibility)
   -> topo sort
   -> execute only required packs
```

Deterministic closure algorithm:

1. Build graph from `dependency-map.yaml`, profile defs, and pack declarations.
2. Map changed paths to initial dirty node set `D0`.
3. Compute transitive affected set `A = closure(D0)`.
4. Determine impacted profiles `P` where profile semantics or required nodes intersect `A`.
5. Seed required packs `R0` from profile mandatory packs for `P`.
6. Expand `R = closure(R0, requires.packs)`.
7. Filter by engine/profile capability constraints; mark unsatisfied constraints as hard failures.
8. Topologically sort `R` by pack dependencies and emit execution plan.
9. Persist explanation graph so `meta explain` can prove why each pack ran.

### 4) Caching strategy (low runtime)

Cache layers:

- L1 local CAS: `.meta/cache/objects/<sha256>`
- L2 shared CI cache/artifact store: keyed by deterministic pack fingerprint

Fingerprint key fields:

- `pack_id`, `pack_version`
- `profile_id`, `profile_version`
- `engine_id`, `engine_build_hash`
- `capabilities_hash`
- `changed_nodes_hash` (not raw file list)
- `toolchain_hash` (dotnet sdk + Lean/TLA/OCaml tool versions)
- `mode` (`deterministic` vs `fast`)

Policies:

- Reuse cache only when deterministic-relevant fields match exactly.
- Separate closure-cache (`resolution.json`) from execution-cache (pack artifacts).
- Negative cache for known schema/tooling errors (short TTL) to fail fast.
- `meta cache warm` pulls likely-needed entries from target branch baseline.
- `meta cache gc` keeps N days plus entries referenced by last M successful CI runs.

### 5) CI integration plan

#### PR pipeline

1. `meta doctor --ci`
2. `meta resolve --base origin/main --head HEAD --out artifacts/meta/$RUN_ID/resolution.json`
3. `meta check --mode ci --resolution artifacts/meta/$RUN_ID/resolution.json`
4. `meta report --run-id $RUN_ID --emit junit,sarif,md,json`
5. Upload artifacts and annotate PR with conformance summary.

Gates:

- Block merge if any required pack fails or capability constraints are unmet.
- Green-owned packs are mandatory for stabilization claims.

#### Main/nightly

- Nightly `meta check --mode ci --all-profiles --all-engines` for drift detection.
- Publish trend metrics (pack duration, cache hit rate, flaky index, failure taxonomy).

### 6) Local developer ergonomics plan

- `meta check` defaults to pinned profile and local diff against tracking branch.
- `meta pin-profile visicalc.v1` stored in `.meta/local.profile.json` (gitignored).
- `meta resolve --explain` prints concise why-tree before execution.
- `meta run-pack PACK.x --watch` for tight loop on a single obligation.
- `meta check --mode local --defer heavy` allowed locally, but emits explicit "not merge-ready" banner.
- `meta report --last --open` renders latest conformance summary quickly.

## Concrete doc edits (exact headings/IDs)

1. `OPERATIONS.md`
- Add section `6.1 meta CLI Contract` (canonical commands + required artifacts).
- Add section `6.2 Obligation Resolver Semantics` (dirty marking, closure, topo execution).
- Add section `6.3 Local vs CI Modes` (defer policy and merge gate).

2. `ARCHITECTURE_AND_REQUIREMENTS.md`
- Add `CONSTR-006`: Pack declarations must be schema-versioned and machine-validated.
- Add `CONSTR-007`: Readiness claims require emitted capability manifest + conformance report pair.

3. `CHARTER.md`
- In Glossary, add definitions for `Resolution Graph` and `Pack Fingerprint`.

4. `README.md`
- Add short pointer: "Run `meta check` for readiness" with link to `OPERATIONS.md` section `6.1`.

## Open questions

- Should profile definitions carry explicit "heavy pack" tags, or should heaviness remain pack-local metadata only?
- Should resolver treat changed docs as pack-triggering inputs or only as policy lint signals?
- For multi-engine CI, do we gate per-engine independently or require both Red and Blue green for all impacted profiles?

## Smallest high-impact next actions

1. Ratify the pack schema (`schema_version: 1`) and add validator in `meta doctor`.
2. Implement `meta resolve` with persisted explanation graph and deterministic topological plan.
3. Wire PR CI to `meta check --mode ci` and publish `conformance.json` + `capabilities-merged.json` artifacts.
4. Add `meta pin-profile` and `meta explain` to improve local adoption and reduce unnecessary pack runs.
