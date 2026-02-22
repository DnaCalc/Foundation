# 0→1→2→3 Milestone Map with Hard Exits and Artifact Freezes

## Contradictions Check (Source-of-Truth Pass)
- No hard contradictions found across `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `OPERATIONS.md`.
- `notes/BRAINSTORM_NOTES.md` contains open design questions (not binding conflicts).
- Coherent interpretation used: doctrine and constraints are fixed now; unresolved items in notes are tracked as risks until retired by pack-backed exits.

## Milestone Spine

```text
Round 0        Round 1         Round 2            Round 3
DnaVisiCalc -> DnaPreCalc ->   DnaSuperCalc ->    DnaCalc
(pathfinder)   (full E2E)      (refactor/perfect) (goldilocks)
```

## Round-by-Round Map

| Round | Objectives | Non-goals | Hard Exit Criteria | Artifacts Frozen Before Proceeding |
|---|---|---|---|---|
| **DnaVisiCalc (Round 0)** | Prove the architecture/doctrine loop works end-to-end on a constrained scope: OpLog→Snapshot→Deltas, profile binding, deterministic mode, Green packs gating, Red/Blue protocol parity, basic UI staleness visibility. | Full Excel parity; full XLL/RTD; collaboration semantics; full file interop and lowering matrix; advanced perf tuning beyond signatures. | 1) `PACK.visicalc.core`, `PACK.concurrent.epochs`, `PACK.udf.basic`, `PACK.stream.basic`, `PACK.structural.insert`, `PACK.ui.viewport`, `PACK.scaling.signature` all green for Round-0 profile. 2) Green signs profile stabilization veto gate. 3) Deterministic minimizer reproduces failures from traces. 4) Red and Blue pass identical protocol conformance pack for Round-0 feature set. | 1) `profile_id/profile_version` for Round-0 semantics. 2) Protocol schema version for dispatch/query/subscribe/capability negotiation. 3) Lean theorem set for core semantics + one structural rewrite lemma. 4) TLA+ model + checked invariant set for epochs/scheduling/invalidation. 5) OCaml oracle CLI contract + canonical trace format. 6) Capability manifest + conformance report template. |
| **DnaPreCalc (Round 1)** | Deliver first full end-to-end system shape with broader semantics/interop surface while preserving spec-first discipline and dual-engine parity. | Premature architecture rewrite; speculative collaboration model beyond seam; aggressive “perfect” abstractions that delay usable full-system behavior. | 1) Round-1 profile packs (expanded semantics + interop/UDF/stream coverage) green on both engines. 2) Adapter boundary constraints enforced (`CONSTR-002`) with no core socket/file dependencies. 3) Unsupported features follow explicit degrade/preserve policy with deterministic diagnostics. 4) Clean-room evidence records linked to key compatibility claims. | 1) Round-1 profile and compatibility/version negotiation table. 2) Degrade/preserve matrix (Native/Lowered/Opaque/Rejected) by feature category. 3) File adapter contracts (import/export + unknown-part round-trip rules). 4) Expanded obligation pack manifest and resolver rules. |
| **DnaSuperCalc (Round 2)** | Execute refactor/perfection pass to harden extensibility, observability, determinism under concurrency, and scaling behavior without semantic drift. | Broad net-new product scope; breaking profile semantics without explicit version bump; bypassing packs for “cleanup” changes. | 1) Semantic equivalence checks pass against frozen Round-1 profile(s) unless explicitly version-bumped. 2) Deterministic mode reproduces schedule-sensitive cases at targeted stress bounds. 3) Scaling signatures meet agreed slope budgets across core workloads. 4) Regression corpus shows no unresolved P0/P1 conformance failures for scoped profiles. | 1) Refactored module boundaries and invariants spec (including mutation ownership/locking rules). 2) Performance signature baselines and acceptance thresholds. 3) Determinism policy decisions (e.g., reduction order) as profile-governed rules. 4) Updated minimized regression corpus baseline. |
| **DnaCalc (Round 3)** | Synthesize maintainable, optimized Goldilocks foundation: stable versioned interfaces, repeatable stabilization workflow, long-lived extension ecosystem posture. | Experimental perfection loops; profile-churn without migration discipline; one-engine shortcuts. | 1) At least one production-target profile stabilized with full required packs and published meta-epoch artifacts. 2) Protocol/version negotiation and migration paths validated by replayable ops. 3) Long-run reliability gate: no crash-on-unsupported regressions; preserve/degrade behavior verified. 4) Operational one-command readiness (`meta check`) accepted as release gate. | 1) Production profile bundle (spec + packs + conformance baselines). 2) Versioned protocol and migration docs frozen. 3) Release-grade capability manifests and evidence index frozen. 4) Operations playbook for stabilization/release freeze. |

## Risk Retirement Map

| Risk ID | Risk | Retired In | Why Retired There | Still Open After Round? |
|---|---|---|---|---|
| R1 | Spec ambiguity causes divergent behavior | Round 0 (partially), Round 1 (fully for scoped features) | Round-0 theorem/model/oracle triangulation narrows ambiguity; Round-1 broader profile+packs closes scoped full-system gaps | Open for newly added features until each profile is stabilized |
| R2 | Hidden mutation paths violate OpLog doctrine | Round 0 | Core boundary validated in pathfinder architecture and conformance gates | Remains as regression risk; controlled by packs/code review |
| R3 | Stale/incorrect concurrent commits | Round 0 (core invariants), Round 2 (stress hardening) | TLA+ invariants in Round-0; Round-2 stress determinism and schedule-sensitive regression hardening | Residual long-tail concurrency risk always remains |
| R4 | Red/Blue protocol drift | Round 0 (baseline), Round 1 (expanded surface) | Identical protocol conformance required both rounds | Remains when new protocol versions are introduced |
| R5 | Non-deterministic bugs cannot be reproduced | Round 0 | Deterministic mode + trace minimizer are explicit exits | Residual risk if new async surfaces bypass deterministic hooks |
| R6 | Performance cliffs discovered too late | Round 2 | Scaling signature suite becomes enforced budget gate | Remains for future workload classes |
| R7 | Interop/file round-trip data loss | Round 1 (policy), Round 3 (release confidence) | Round-1 degrade/preserve matrix + adapter contracts; Round-3 release-grade verification | Residual for untested external variants |
| R8 | Unsupported features crash system | Round 1 (policy), Round 3 (reliability) | Explicit deterministic degrade behavior enforced, then validated under release gates | Residual regression risk |
| R9 | STREAM/UDF semantics destabilize recalc | Round 0 (minimal), Round 1 (broader) | Basic UDF/STREAM packs in pathfinder; expanded semantics in full system | Remains for advanced async/UDF continuation features |
| R10 | Collaboration cannot be added without rewrite | Round 1 (seam) | OpLog replication seam and identity strategy established in full-system architecture | Shared-oracle policy remains open |
| R11 | Clean-room evidence discipline drifts | Round 1 | Evidence records linked to requirements and compatibility claims | Ongoing governance risk |
| R12 | Obligation closure/gating too slow or manual | Round 0 (baseline tooling), Round 2 (scale hardening) | `meta`-driven closure and required packs; Round-2 cache/perf improvements | Remains as tooling maintenance risk |

## First 30 Days Plan for DnaVisiCalc

### Days 1-10: Freeze semantics core and executable checks
- Lock Round-0 profile skeleton (`profile_id`, `profile_version`, required packs list).
- Freeze minimal formula/function set and manual/auto recalc semantics.
- Implement canonical trace format shared by engine harness + OCaml oracle.
- Stand up Lean core semantics module and one structural rewrite target.

### Days 11-20: Prove concurrency + determinism loop
- Build minimal TLA+ epoch/scheduling model (`SetCell`, `StructuralEdit`, `ExternalUpdate`, `TaskFinish`, `Stabilize`).
- Wire deterministic run mode in both engines with reproducible trace replay.
- Implement OCaml `run-trace` + `shrink` CLI path and mismatch report format.
- Add failing-case-to-minimized-fixture automation.

### Days 21-30: End-to-end stabilization rehearsal
- Implement `PACK.visicalc.core`, `PACK.concurrent.epochs`, `PACK.udf.basic`, `PACK.stream.basic` as CI gates.
- Add basic Tauri canvas+DOM overlay path with stale/pending markers and RenderPlan checks.
- Run first full `meta check` for Round-0 profile on both engines.
- Publish first meta-epoch bundle: capability manifest, conformance report, minimized regression set.

## Proposed Minimal Doc Edits (to reduce ambiguity early)
- `ARCHITECTURE_AND_REQUIREMENTS.md` → **§6 Pathfinder Scope Anchor**: add explicit minimum function/formula list and UDF range-in/range-out scope decision.
- `OPERATIONS.md` → **§4 Obligation Packs and Gates**: add normative “required-for-Round-0” pack list with IDs and pass thresholds.
- `CHARTER.md` → **§5 Glossary**: add crisp entries for `stabilized_epoch`, `meta-epoch commit`, and `artifact freeze`.

## Smallest Next Actions (biggest risk reduction)
- Freeze Round-0 profile + required pack manifest first (unblocks all teams).
- Freeze canonical trace/schema contract (enables Lean/TLA+/OCaml/Red/Blue triangulation).
- Land deterministic replay + shrinker pipeline before broad feature work.
- Enforce protocol conformance parity gate in CI for both engines from day one.
- Publish first evidence record template tied to REQ/INT/REAL IDs.
