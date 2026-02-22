# OPERATIONS.md — DNA Calc Operations

## 1. Purpose
Operations defines how DNA Calc is developed, stabilized, and evolved under the Mission and Doctrine. It is designed to withstand “agentic coding weather” and frequent plan changes.

## 2. Structure (Green/Red/Blue) and Veto
### 2.1 Responsibilities
**Green (Spec & Assurance)**
- Owns DSL specs, proofs, protocol specs, OCaml oracle, cases, conformance packs.
- Owns profile definitions, profile versioning rules, and negotiation schemas.
- Curates minimized regressions and “known quirks” documentation.
- **Has veto on declaring a profile “stabilized/green.”**

**Red (Rust engine)**
- Implements the protocol surface and passes Green’s packs.
- Focuses on hard-rock correctness under concurrency and performance scaling.

**Blue (.NET engine)**
- Implements the identical protocol surface and passes Green’s packs.
- Provides independent confirmation of spec clarity and implementation feasibility.

**Logistics (Tooling & Coordination)**
- Builds and maintains `meta` orchestration, CI wiring, artifact storage/reporting, dashboards.
- Keeps cycle time low and reproducibility high.
- Generally .NET-first tooling, with small Rust utilities when warranted.

### 2.2 Module Triads
Every major spec/module area is managed by a **triad**:
- **Design** representative (spec intent and structure),
- **Assurance** representative (packs, proofs, test strategy),
- **Delivery** representative (Red/Blue implementation implications).

Triads resolve ambiguity early and ensure artifacts remain consistent.

## 3. Development Recalc Cycle (mirrors calculation)
The project evolves through a “recalc” cycle operating on DAGs.

### 3.1 DAGs
- **Spec DAG**: Lean modules, TLA+ modules, schemas/IDL, profiles.
- **Assurance DAG**: obligation packs, oracle runs, minimized cases, perf signatures.
- **Implementation DAG**: Red modules, Blue modules, adapters, protocol surfaces.
- **Interop DAG** (later/heavier): Excel differential packs, file adapter conformance.

### 3.2 Phase Model
1. **Edit / Dirty Marking**
   - Any change marks a set of nodes dirty (modules, packs, profiles, protocols), including `OpExternalUpdate`.
2. **Dependency Closure**
   - `meta` computes impacted obligations and required version bumps.
3. **Scheduling**
   - Work is dispatched along parallel tracks: Design / Assurance / Delivery / Logistics.
4. **Execution**
   - Proofs/model checks, oracle runs, engine conformance, perf signatures.
5. **Stabilization**
   - A profile is stabilized when its required obligation packs pass and artifacts are emitted.
6. **Meta-epoch Commit**
   - Publish capability manifest + conformance report + regression updates.

### 3.3 Auto vs Manual Modes (dev analogy)
- **Auto**: CI runs the full required packs for affected profiles.
- **Manual**: local development may defer heavy packs, but merge requires stabilization.

## 4. Obligation Packs and Gates
### 4.1 Packs
Packs are the unit of readiness (examples):
- `PACK.visicalc.core` (Pathfinder semantics)
- `PACK.concurrent.epochs` (TLA+ invariants and schedule tests)
- `PACK.udf.basic` (external UDF registration + calls)
- `PACK.lean.ocaml.alignment.core` (Lean-bounded fixtures aligned with OCaml oracle outcomes)
- `PACK.stream.basic` (STREAM/external updates propagation)
- `PACK.stream.oracle.diff` (cross-engine + oracle stream replay parity)
- `PACK.structural.insert` (insert row/col rewrite + traces)
- `PACK.ui.viewport` (geometry/hit-test invariants + RenderPlan checks)
- `PACK.scaling.signature` (growth suite and slope reporting)
- `PACK.interop.degrade_matrix` (Native/Lowered/Opaque/Rejected policy conformance)
- `PACK.interop.roundtrip.opaque` (unknown-part round-trip guarantees)
- `PACK.collab.replication.core` (OpLog replication envelope and idempotency checks)

### 4.2 Gate Rules
- A profile cannot be declared “stabilized” unless all required packs for that profile are green.
- Failing packs must generate or update minimized cases.
- Required packs for a claim must include triangulation evidence across OCaml oracle, Red (Rust), and Blue (.NET) where applicable.
- STREAM readiness for Round 0 requires `PACK.stream.basic` and stream cases in `PACK.concurrent.epochs`.

### 4.3 Pack Contract Discipline
- Every pack publishes:
  - scope, required fixtures, deterministic mode requirements, pass/fail thresholds, emitted artifacts.
- `PACK.scaling.signature` contract must include:
  - required workload families, phase-level counter schema, slope calculation method, regression thresholds.
- `PACK.concurrent.epochs` contract must include:
  - tiered model-check configurations and archived minimized counterexample traces.
- `PACK.visicalc.core` contract must include:
  - minimum semantic coverage and required artifact set for Round 0 profile readiness.

## 5. Regression Handling (AAR-driven)
- Every failure produces:
  - a minimized trace,
  - a conformance report entry,
  - a triage record (root cause classification).
- Periodic AARs consolidate learnings into:
  - refined packs,
  - clarified profile specs,
  - updated doctrine (rare).

## 6. Tooling Interface Rules
- Cross-language integration is file/CLI-based (schemas, traces, manifests).
- OCaml oracle runs as CLI.
- Lean and TLC run under orchestration; no manual “tribal incantations.”

### 6.1 Meta CLI Contract
Canonical command families include:
- `meta check`
- `meta resolve`
- `meta run-pack`
- `meta report`
- `meta pin-profile`

Each command must emit machine-readable artifacts suitable for CI gating and local replay.

### 6.2 Obligation Resolver Semantics
- Resolver inputs include:
  - changed files, profile definitions, pack declarations, capability manifests, previous pack fingerprints.
- Resolver outputs include:
  - impacted obligation closure, execution plan, cache hit/miss report, required version-bump notes.
- Caching must be fingerprinted and deterministic; cache reuse is allowed only on matching fingerprints and schema versions.

### 6.3 Local vs CI Modes
- Local mode may skip heavyweight packs for cycle-time, but must still compute full impacted closure.
- CI mode executes full required closure and is the authority for merge readiness.

## 7. Deliverable Names per Round
- Round 0: **DnaVisiCalc** (Pathfinder) — proves the verification + meta-control loop.
- Round 1: **DnaPreCalc** — first full end-to-end implementation and spec push.
- Round 2: **DnaSuperCalc** — refactor/polish and “too-perfect” exploration.
- Round 3: **DnaCalc** — streamlined, maintainable Goldilocks product.

## 8. Prompt and Synthesis Run Discipline
Prompt execution and synthesis are treated as operational activities with run artifacts.

### 8.1 Prompt Runs
- Prompt-run operating procedure lives in `prompts/README.md`.
- Prompt runs must capture raw outputs, manifests, and trace artifacts under `prompts/runs/<run-id>/`.
- Prompt outputs are inputs to decision-making, not source-of-truth policy.

### 8.2 Synthesis Runs
- Synthesis-run operating procedure lives in `synthesis/README.md`.
- Synthesis runs must record per-suggestion decisions (`accept` / `adapt` / `defer` / `reject`) with rationale and target-document references.
- No synthesis edit should be applied without a corresponding decision-log record.

### 8.3 Document Precedence During Synthesis
When synthesis suggestions conflict, precedence remains:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `notes/BRAINSTORM_NOTES.md`

## 9. Clean-room Evidence Workflow
- Compatibility claims require an evidence record that includes:
  - claim identifier, linked REQ/INT/REAL IDs, admissible source type, capture/reproduction steps, reviewer decision.
- Admissible evidence sources:
  - public documentation/specifications,
  - published research,
  - reproducible black-box observation harness outputs.
- Non-admissible sources:
  - proprietary or restricted materials,
  - reverse-engineered internals.
- Evidence review is a gate input for stabilization claims involving compatibility behavior.

## 10. Round Progression and Exit Coupling
- Round progression is coupled to artifact freezes and required pack sets.
- Minimum exit artifacts per round include:
  - capability manifest,
  - conformance report,
  - updated minimized regression corpus,
  - pack result index for required profiles.
- Round transitions are blocked when required artifacts or pack obligations are missing.

### 10.1 Open Decisions Register
- Open cross-team policy decisions are tracked as `DEC-###` entries with:
  - owner, target round, current status, blocking impact.
- No critical ambiguity should remain implicit in brainstorm-only notes once it affects stabilization criteria.
