# OPERATIONS.md — DNA Calc Operations

## 1. Purpose
Operations defines how DNA Calc is developed, stabilized, and evolved under the Mission and Doctrine. It is designed to withstand “agentic coding weather” and frequent plan changes.

## 2. Structure (Green/Red/Blue) and Veto
### 2.1 Responsibilities
**Green (Spec & Assurance)**
- Owns DSL specs, proofs, protocol specs, OCaml oracle, cases, conformance packs.
- Owns profile definitions, profile versioning rules, and negotiation schemas.
- Owns `CORE_ENGINE_FORMAL_MODEL.md` as the detailed formal-semantics working document.
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
   - For behavior-sensitive changes, execute a coupled evidence lane: semantics/spec delta, proof/model output, deterministic replay artifacts, and scaling signature evidence.
5. **Stabilization**
   - A profile is stabilized when its required obligation packs pass and artifacts are emitted.
6. **Meta-epoch Commit**
   - Publish capability manifest + conformance report + regression updates.

### 3.3 Sequence-Only Planning Doctrine (No Time Schedules)
Project execution planning is sequence-based, not calendar-based.

Mandatory rule:
1. Plans and execution notes must not use date-based or duration-based commitments (for example deadlines, ETA dates, week-based schedules, or "finish by X time").
2. Execution order must be expressed using:
   - priority,
   - dependency/`depends_on` relations,
   - blocker status,
   - gate/pack readiness criteria,
   - risk and impact ordering.
3. Progress is reported by state transitions and obligation closure (for example `planned -> in_progress -> blocked -> complete`), not by elapsed time targets.
4. If temporal metadata is captured for audit/provenance (timestamps in artifacts), it is observational only and must not be used as a planning commitment axis.

### 3.4 Auto vs Manual Modes (dev analogy)
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

Additional Round 1 candidate packs informed by pathfinder evidence:
- `PACK.control.basic` (control definition, validation, dependency participation)
- `PACK.chart.basic` (chart definition, sink-node evaluation, chart-output determinism)
- `PACK.calcdelta.basic` (typed delta entries, epoch tagging, emission/drain semantics)
- `PACK.volatility.three_cat` (Standard/Volatile/ExternallyInvalidated invalidation behavior)

Pack status terminology:
- `exercised`: implementation-level behavior exists with local tests.
- `green-validated`: Green-owned pack artifacts and required conformance evidence are complete.
- `exercised` is not sufficient for stabilization claims.

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

### 6.4 Tooling Language Policy
- Repository tooling implementations are .NET-first (C# or F#) unless explicitly approved otherwise.
- Python is not an allowed tooling implementation language in this repository by default.
- Any Python exception requires an explicit logged approval record, including:
  - scope and owner,
  - rationale for exception,
  - sunset/replacement plan.
- PowerShell (`pwsh`) is permitted for convenience orchestration and launcher scripts, but behavior-critical tool runtime logic (for example empirical Excel driving and artifact emission) must remain in stable .NET tools.

## 7. Deliverable Names per Round
- Round 0: **DnaVisiCalc** (Pathfinder) — proves the verification + meta-control loop.
- Round 1: **DnaPreCalc** — first full end-to-end implementation and spec push.
- Round 2: **DnaSuperCalc** — refactor/polish and “too-perfect” exploration.
- Round 3: **DnaCalc** — streamlined, maintainable Goldilocks product.

### 7.1 Round 0 Functional Scope Authority
- For DnaVisiCalc pathfinder v0 functional-scope questions, use:
  - `..\\DnaVisiCalc\\docs\\SPEC_v0.md`
  - `..\\DnaVisiCalc\\docs\\ENGINE_REQUIREMENTS.md`
  - `..\\DnaVisiCalc\\docs\\ENGINE_API.md`
- Foundation docs remain the source of truth for doctrine, architecture framing, and operations process, and must stay consistent with that upstream functional contract.
- Proposed functional-scope expansions discovered in implementation (for example from gap-analysis style docs) are tracked as follow-on backlog and routed through synthesis before any doctrine/policy promotion.

## 8. Managed-Run Discipline (Prompt, Research, Synthesis, Reference)
Prompt execution, deep research, synthesis, and reference-spec processing are treated as managed operational activities with run artifacts.

### 8.0 Managed-Run Task Types
- `prompt_run`: reusable prompt execution runs under `prompts/runs/<run-id>/`.
- `research_run`: deep research runs under `research/runs/<run-id>/`.
- `synthesis_run`: synthesis/decision runs under `synthesis/runs/<run-id>/`.
- `reference_run`: reference-spec processing and conformance-candidate extraction runs under `reference/runs/<run-id>/`.

### 8.1 Prompt Runs
- Prompt-run operating procedure lives in `prompts/README.md`.
- Prompt runs must capture raw outputs, manifests, and trace artifacts under `prompts/runs/<run-id>/`.
- Prompt outputs are inputs to decision-making, not source-of-truth policy.

### 8.2 Synthesis Runs
- Synthesis-run operating procedure lives in `synthesis/README.md`.
- Synthesis runs must record per-suggestion decisions (`accept` / `adapt` / `defer` / `reject`) with rationale and target-document references.
- No synthesis edit should be applied without a corresponding decision-log record.
- Synthesis artifacts are audit/history records; source-of-truth remains `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, and `notes/RESEARCH_NOTES.md` for non-doctrinal retained knowledge.

### 8.3 Research Runs
- Deep-research prompt templates live in `prompts/PROMPT_PACK_DEEP_RESEARCH.md`.
- Research topic and source registries live under `research/`.
- Research runs must capture exact prompt input text, source links, and output artifacts under `research/runs/<run-id>/`.
- Research outputs are evidence inputs; they do not become doctrine until synthesized into source-of-truth docs.

### 8.4 Document Precedence During Synthesis
When synthesis suggestions conflict, precedence remains:
1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. `notes/RESEARCH_NOTES.md`
5. `notes/BRAINSTORM_NOTES.md`

### 8.5 Synthesis Completion and Status Model
- A synthesis run is complete only when all of the following exist:
  - frozen input hashes,
  - full suggestion index and decision log coverage for the scoped run set,
  - applied/adapted changes reflected in source-of-truth docs,
  - output synthesis report,
  - source run manifests or registries marked `synthesized` with reference to the synthesis run id.
- Suggested lifecycle states:
  - `captured` (raw run outputs present),
  - `synthesized` (decisions recorded and knowledge promoted),
  - `archived` (run retained for audit/history, no longer active working set).

### 8.6 Working Directory Semantics
- `prompts/runs/*`, `research/runs/*`, `synthesis/runs/*`, and `reference/runs/*` are managed run evidence directories.
- Their outputs must be assumed non-authoritative until synthesis promotion.
- After synthesis, these directories remain audit inputs; day-to-day guidance comes from source-of-truth docs and `notes/RESEARCH_NOTES.md`.
- Temporary agent-generated files should default to a repository-local `.tmp/` directory that is `.gitignore`d.
- Prefer repository-local `.tmp/` over OS user temp directories unless an explicit task requires system temp location semantics.

### 8.7 Pathfinder Feedback Pattern
- Pathfinder teams should follow a repeatable upstream-feedback loop:
  1. implement against Foundation docs,
  2. capture gaps/ambiguities from implementation reality,
  3. document local evidence and proposal set,
  4. route proposals through synthesis (`accept` / `adapt` / `defer` / `reject`) before doctrine promotion.
- Pathfinder feedback documents are proposal inputs, not source-of-truth edits by themselves.
- Proposal sets should include target-section references, rationale, and dependency notes to support deterministic synthesis decisions.

### 8.8 Legacy Guidance Hand-off
- When an upstream pathfinder guide is superseded (for example gap-analysis/proposal/mapping docs), synthesis must do one of:
  - promote the relevant content into source-of-truth docs, or
  - retain it explicitly in Foundation notes as deferred backlog with rationale.
- Current retained example: `notes/VISICALC_V0_SCOPE_ALIGNMENT_NOTES.md`.
- Superseded guides can then be archived without losing material planning knowledge.

### 8.9 Reference Spec Processing and Conformance Extraction
- Raw external-spec mirrors remain under `reference/downloads/` with indexed provenance in `reference/index.csv`.
- Managed spec-processing runs emit normalized reference artifacts under `reference/runs/<run-id>/outputs/` and are the preferred input layer for conformance extraction and formal-model cross-referencing work.
- Required processed-run outputs:
  - `run_manifest.json`,
  - `documents.csv`,
  - `selected_sources.csv`,
  - `spec_items.jsonl`,
  - `conformance_items.jsonl`,
  - `conformance_excluded.jsonl`,
  - `llm/classification_tasks.jsonl`,
  - per-document `document_manifest.json`, `segments.jsonl`, `sentences.jsonl`, `spec_items.jsonl`, `conformance_candidates.jsonl`, and `conformance_excluded.jsonl`.
- Every extracted segment/sentence/conformance item must retain source back-references (source URL, mirrored local path, and finest available anchor such as page/section/table/cell/image reference).
- Coverage must be explicit: if any source artifact cannot be fully extracted (for example OCR-pending PDF), the run must emit pending markers/counters rather than silently dropping content.
- LLM-assisted classification is allowed only as an auditable layer on top of deterministic extraction; prompts/responses or imported classifier outputs must be captured as run artifacts.
- Detailed format contract for this layer is maintained in `REFERENCE_SPEC_FORMAT_AND_CONFORMANCE.md`.

### 8.10 Empirical Findings as Reference-Conformance Inputs
- Empirical run outputs under `research/runs/<run-id>/` remain working evidence by default; they do not become standing conformance references automatically.
- High-value empirical observations (for example behavior that resolves spec ambiguity, contradicts expectation, or materially constrains compatibility design) must be curated into `reference/empirical/` as promoted finding records (`findings_registry.jsonl` + human index/docs).
- Promoted empirical findings are first-class conformance-source inputs alongside processed spec items, with explicit provenance links back to:
  - research run id and scenario/task id,
  - captured evidence artifacts,
  - Excel build/version metadata and `EXCEL.EXE` hash,
  - runner/tool version and source revision.
- Empirical promotions must be selective: not every executed probe is promoted; only findings with durable conformance relevance.
- Conformance requirement synthesis must allow source binding to either:
  - spec-derived evidence (`SPEC-*` lineage), or
  - empirical-derived evidence (`EMP-*` lineage),
  and should support mixed-source justification where both apply.

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

### 10.1 Round Exit Track Decomposition
- For planning clarity, round-progress reports may decompose work into:
  - Track A: implementation scope,
  - Track B: formal/assurance obligations,
  - Track C: beyond-minimum exploratory artifacts.
- Decomposition is informational; gate authority remains required artifacts and required packs.

### 10.2 Open Decisions Register
- Open cross-team policy decisions are tracked as `DEC-###` entries with:
  - owner, target round, current status, blocking impact.
- No critical ambiguity should remain implicit in brainstorm-only notes once it affects stabilization criteria.
