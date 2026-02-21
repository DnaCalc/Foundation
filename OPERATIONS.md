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
   - Any change marks a set of nodes dirty (modules, packs, profiles, protocols).
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
- `PACK.stream.basic` (STREAM/external updates propagation)
- `PACK.structural.insert` (insert row/col rewrite + traces)
- `PACK.ui.viewport` (geometry/hit-test invariants + RenderPlan checks)
- `PACK.scaling.signature` (growth suite and slope reporting)

### 4.2 Gate Rules
- A profile cannot be declared “stabilized” unless all required packs for that profile are green.
- Failing packs must generate or update minimized cases.

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

## 7. Deliverable Names per Round
- Round 0: **DnaVisiCalc** (Pathfinder) — proves the verification + meta-control loop.
- Round 1: **DnaPreCalc** — first full end-to-end implementation and spec push.
- Round 2: **DnaSuperCalc** — refactor/polish and “too-perfect” exploration.
- Round 3: **DnaCalc** — streamlined, maintainable Goldilocks product.