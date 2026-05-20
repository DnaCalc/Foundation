# OPERATIONS.md — DNA Calc Operations

## 1. Purpose
Operations defines how DNA Calc is developed, stabilized, and evolved under the Mission and Doctrine. It is designed to withstand “agentic coding weather” and frequent plan changes.

## 2. Structure (Green/Red/Blue) and Veto
### 2.1 Responsibilities
**Green (Spec & Assurance)**
- Owns DSL specs, proofs, protocol specs, OCaml oracle, cases, conformance packs.
- Owns profile definitions, profile versioning rules, and negotiation schemas.
- Owns formal-semantics governance and mirror-sync gates for detailed model artifacts; canonical detailed core-engine model/spec files are lane-owned in OxCalc/OxFml.
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

Additional synthesis-promoted candidate packs (core-engine/FEC-F3E pass-02):
- `PACK.fec.commit_atomicity` (single atomic derived bundle per accepted node commit)
- `PACK.fec.reject_detail_replay` (structured reject-code/detail replay determinism)
- `PACK.fec.overlay_lifecycle` (overlay key match, eviction triggers, epoch-safe GC)
- `PACK.fec.format_dependency_tokens` (format/CF dependency-token invalidation behavior)
- `PACK.fec.oxfunc_metadata_contract` (resolved call-site handles, dispatch keys, function-facing dependency metadata, volatility/determinism/host interaction declarations)
- `PACK.optimization.semantic_equivalence` (value-only vs trace-rich execution, hoisting/cache/compiled-backend equivalence, no evaluator-local function special cases)
- `PACK.format.semantic_vs_display_boundary` (formula-semantic formatting through evaluator seam)
- `PACK.visibility.policy_equivalence` (None vs VisibleFirst stabilized-equivalence checks)
- `PACK.visibility.starvation_bound` (fairness bound enforcement under visibility-priority scheduling)
- `PACK.dag.dynamic_dependency_bind_semantics` (calc-time bind delta behavior under dynamic refs)
- `PACK.dag.cycle_iterative_semantics` (3-mode cycle semantics and diagnostics)
- `PACK.dag.external_stream_ordering` (stream ordering/dedupe behavior by declared version)
- `PACK.treehost.multiresult.explicit` (no implicit spill analog in early tree-host phases)
- `PACK.treehost_to_gridhost.semantic_gap_registry` (explicitly tracked deferred tree/grid parity gaps)
- `PACK.concurrent.epochs` follow-up lanes must include: reject-fence determinism, stream-version replay matrix, visibility-event replay determinism, and pin/unpin overlay-GC safety.

Additional synthesis-promoted candidate packs (improvement-notes pass-01):
- `PACK.host.conformance_ladder` (host charter semantics surface + gate obligations)
- `PACK.host.acceptance_matrix` (Committed/Experimental/Deferred behavior matrix per host)
- `PACK.host.degradation_matrix` (`Native`/`Lowered`/`Opaque`/`Rejected` declaration coverage per host)
- `PACK.trace.forensic_plane` (canonical trace coverage for calc causality and suppression decisions)
- `PACK.replay.appliance` (portable replay bundle usability across local/CI/cross-engine runs)
- `PACK.diff.cross_engine.continuous` (continuous Rust/.NET/OCaml differential execution and divergence indexing)
- `PACK.reject.calculus` (typed reject-class taxonomy and replay consistency)
- `PACK.overlay.fallback_economics` (incremental overlay reuse vs conservative rebuild counters and thresholds)

`PACK.overlay.fallback_economics` minimum counter schema is locked:
- `overlay_reuse_hits_total`
- `overlay_reuse_miss_total`
- `overlay_rebuild_conservative_total`
- `overlay_rebuild_reason_structural_total`
- `overlay_rebuild_reason_epoch_total`
- `overlay_rebuild_reason_token_total`
- `overlay_rebuild_reason_bind_total`
- `overlay_rebuild_reason_profile_total`
- `overlay_gc_evictions_total`

Threshold policy:
- doctrine locks the counter schema and artifact requirements now,
- pass/fail thresholds are calibrated by pack owners per profile/version and are not globally frozen in doctrine at this stage.

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
- Replay-governed pack contracts must also declare:
  - minimum required adapter capability level,
  - required bundle mode and schema,
  - required registry families and versions,
  - required witness lifecycle states,
  - whether reduced witnesses are mandatory, optional, or forbidden for the claim.
- `PACK.replay.appliance` contract must include:
  - required bundle validation surface,
  - replay mode requirements,
  - capability-manifest evidence,
  - lifecycle/quarantine handling for retained witnesses.
- `PACK.trace.forensic_plane` contract must include:
  - required trace/event families,
  - capture-loss reporting expectations,
  - explain-surface requirements for causality queries.
- `PACK.diff.cross_engine.continuous` contract must include:
  - required diff scopes,
  - baseline/oracle binding rules,
  - divergence indexing requirements,
  - reduced-witness or quarantine behavior for retained mismatches.
- `PACK.reject.calculus` contract must include replay-consistency requirements when typed reject evidence is part of the claim.
- Replay-governed comparison/equivalence semantics for declared comparison surfaces (worksheet values, display surfaces, numeric exactness classes, and typed reject/outcome classes) are centralized in `OxReplay`; spreadsheet proving hosts remain responsible for final host verdict policy and blocked/incomplete-run handling.

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

### 7.2 Program Repo and Host Layout Baseline
Component repos:
- `Foundation`: doctrine/architecture/operations authority.
- `DnaVisiCalc`: Round 0 pathfinder and seam-evidence source.
- `OxFunc`: value/function semantics lane.
- `OxFml`: formula language and single-node evaluator seam lane.
- `OxCalc`: multi-node core engine lane.
- `OxVba`: VBA runtime/compiler lane.
- `OxReplay`: shared replay/tooling repo for bundle validation, replay, diff/explain, witness distillation, adapter conformance, and `DNA ReCalc`.

Host progression:
- `DNA VbCalc` -> `DNA OneCalc` -> `DNA TreeCalc` -> `DNA PreCalc` -> `DNA SuperCalc` -> `DNA Calc`.

Replay tooling host:
- `DNA ReCalc` over `OxReplay` (not part of spreadsheet host progression).

Execution rule:
- host repos prove and compose lane repos,
- shared tooling repos may implement cross-lane infrastructure without claiming lane-semantic authority,
- replay/equivalence comparison for declared replay-comparable surfaces should be implemented once in `OxReplay` rather than reimplemented independently in hosts,
- hosts remain responsible for final host verdict policy and for deciding when missing or unavailable evidence requires a blocked/non-comparable result,
- lane repos do not silently mutate Foundation doctrine,
- Foundation promotion requires managed-run handover and synthesis decision logging.

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
- Pointer hygiene rule: when a prompt input pack includes `CURRENT_SPEC_SET.md`, that file must list only currently present curated files; any rename/replacement in the curated set must update `CURRENT_SPEC_SET.md` in the same change.
- Prompt-run input freeze validation must treat missing/stale `CURRENT_SPEC_SET.md` pointers as run-integrity failures, not warnings.

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

### 8.11 Cross-Repo Lane Handover Template (Normative)
When sibling lane repos propose cross-program policy text for Foundation adoption, include a minimal handover record in the managed run:
1. scope and profile bounds:
   - affected domains, requirement families, and profile/version applicability.
2. proposed normative text:
   - exact candidate text and target artifact paths/sections.
3. evidence and replay links:
   - source/evidence ids, run ids, and replay artifact locations.
4. unresolved decisions and risk impact:
   - explicit open decisions, blocker status, and failure/risk impact if deferred.

Handover records may be included as:
1. a dedicated `outputs/HANDOVER_<lane>.md`, or
2. a structured section inside synthesis decision logs.

### 8.12 Host Charter Conformance Ladder (Normative)
- Host/repo progression is a conformance ladder, not only a delivery sequence.
- Each host charter must declare:
  - semantic surface commitments by feature family (`Committed`, `Experimental`, `Deferred`),
  - degradation-class expectations by feature family (`Native` / `Lowered` / `Opaque` / `Rejected`),
  - required pack set and required artifact set before downstream hosts may rely on its claims.
- Foundation promotion of host outputs requires these declarations to be explicit and versioned.

### 8.13 Promotion Packet Contract (Normative)
- No host/pathfinder finding may be promoted into Foundation doctrine/architecture text without a promotion packet containing:
  - exact candidate target text and destination section,
  - linked evidence and replay artifacts,
  - explicit open questions/risks,
  - pack/gate impact notes,
  - migration/compatibility notes when applicable.
- Promotion packets are managed-run artifacts and must be referenced from synthesis decision logs.

### 8.14 Dependency Constitution and Theory-to-Pack Mapping (Normative)
- Active repos/lane groups must maintain an explicit dependency constitution (allowed dependency directions and forbidden coupling edges).
- Dependency-constitution changes are policy changes and must route through synthesis before becoming normative.
- Baseline allowed dependency direction (component lanes):
  - `OxFml` -> `OxFunc`
  - `OxCalc` -> `OxFml` and `OxFunc`
  - `OxReplay` -> shared abstractions and replay schemas only; lane semantics enter through declared adapter contracts, not semantic-core dependencies
  - lane repos may depend on narrow `OxReplay` abstractions only when that does not pull in the broad replay runtime or transfer semantic ownership
  - `OxVba` remains independent by default; optional adapters are host-level composition choices and must not backflow doctrine into lane boundaries.
- Baseline forbidden coupling edges (without synthesis override):
  - `OxFunc` -> `OxFml`/`OxCalc`/`OxVba`
  - `OxFml` -> `OxCalc`
  - `OxFml`/hosts/graph backends -> duplicated OxFunc-owned function/operator semantics for optimization shortcuts
  - `OxCalc` -> host/UI/file-adapter implementation layers
  - `OxReplay` -> lane-semantic internals outside declared adapter or conformance-test boundaries
  - lane semantic cores -> broad `OxReplay` runtime packages
- FEC/F3E protocol definition authority: FEC/F3E protocol is co-defined. OxFml defines the evaluator-side contract (session lifecycle, commit deltas, trace schema). OxCalc co-defines the coordinator-facing parts (publication fences, scheduling interaction, rejection policy). The shared protocol specification lives in OxFml as the spec owner, with OxCalc contributing coordinator-facing requirements through the cross-repo handover process.
- Full-model optimization direction: OxFunc remains canonical for worksheet value/function/operator semantics and provides contract metadata for optimized evaluators; OxFml owns formula-plan structure and trace publication policy; FEC/host/OxCalc layers own scheduling, invalidation, publication, caching, concurrency, and graph/backend execution strategy. Optimization work must route through metadata contracts and packs, not through evaluator-local function-specific shortcuts.
- Foundation maintains a theory-to-pack mapping register that links high-value theory claims to one of:
  - proof obligation,
  - conformance pack requirement,
  - empirical pack requirement,
  - explicit deferred item with rationale.
- Current register location: `notes/THEORY_TO_PACK_REGISTER.md`.
- The register must be updated during synthesis when new theory-backed guidance is accepted/adapted/deferred.

### 8.15 Spec Mirror Gate and Naming Policy (Normative)
- Canonical editable lane-owned spec sets:
  - `..\\OxFml\\docs\\spec\\` (FEC/F3E seam, formula-language, evaluator-facing formatting semantics),
  - `..\\OxCalc\\docs\\spec\\` (core-engine detailed model/realization and coordinator policy surfaces).
- Foundation mirror copies under `reference/conformance/excel-worksheet-engine/model/` and Foundation root core-model mirrors are read-only by default.
- Local Foundation edits to mirrored files are allowed only as mirror-sync changes from canonical lane repos, with:
  - source repo/path and source commit hash recorded,
  - no local-only normative divergence,
  - updated mirror status metadata in the edited file header and/or mirror index docs.
- Naming policy:
  - existing historical filenames may remain for link stability,
  - mirror files must include a top-level mirror banner (`Foundation Mirror Copy - Read-only`) plus canonical path pointer,
  - new mirror artifacts should use `_MIRROR` suffix where practical.

### 8.16 Advanced Experimental Lane Policy (Normative)
- Foundation does not enforce a hard single advanced experimental lane rule.
- Default bounded policy: at most `2` concurrent advanced experimental lanes may be active program-wide unless a synthesis decision explicitly overrides.
- Every advanced lane must declare:
  - owner,
  - objective and target scope,
  - parity/conformance pack set,
  - explicit exit criteria,
  - kill-switch criteria and fallback path.
- Advanced lanes are non-baseline by default and may not silently alter baseline semantics.
- Promotion from advanced lane to baseline requires synthesis decision plus parity evidence artifacts.

### 8.17 Replay Appliance Governance (Normative)
- Detailed Replay doctrine lives in `REPLAY_APPLIANCE.md`; this section states the operational governance contract.
- Governance ownership split:
  - Foundation owns Replay doctrine, adapter policy, registry governance, lifecycle policy, and promotion rules.
  - `OxReplay` owns shared replay implementation and `DNA ReCalc`.
  - lane repos own lane-native capture meaning and authoritative adapter semantics.
- Shared adapter capability levels are:
  - `C0.ingest_valid`
  - `C1.replay_valid`
  - `C2.diff_valid`
  - `C3.explain_valid`
  - `C4.distill_valid`
  - `C5.pack_valid`
- Every adapter claim must publish a machine-readable capability manifest with:
  - supported source schemas,
  - supported bundle schemas,
  - claimed capability levels,
  - known limits,
  - conformance artifact refs,
  - registry version refs.
- Replay-governed canonical registries are versioned and currently cover:
  - predicate kind,
  - mismatch kind,
  - severity,
  - reduction outcome,
  - witness lifecycle state,
  - capability level.
- Every retained witness must carry explicit lifecycle state and, where relevant:
  - quarantine reason,
  - supersession lineage,
  - pack-eligibility state.
- `quarantined` and explanatory-only witnesses are visible to triage but are not pack-eligible.
- New Replay doctrine, capability claims used by downstream packs, and replay-governed Foundation promotions require managed-run promotion packets with linked replay evidence.
- No host or pack may rely on undeclared adapter capability levels.

### 8.18 New Repo Bootstrap And Beads Execution Standard (Normative)
- New DNA Calc repos default to the current slim `DnaTreeCalc`-shaped template unless a synthesis decision explicitly approves a different structure.
- `DnaTreeCalc` is the current reference instance for host-repo execution doctrine.
- Default root files:
  - `README.md`
  - `AGENTS.md`
  - `CHARTER.md`
  - `OPERATIONS.md`
  - `.gitignore`
- Default required directories and files:
  - `.beads/` initialized once bootstrap reaches bead execution,
  - `docs/SPEC.md` as the spec/design entrypoint (usually an index for the repo's requirements, design, planning, and model documents),
  - `docs/WORKSET_REGISTER.md`,
  - `docs/handovers/README.md` when cross-repo coordination is expected.
- Default reduction rules:
  - do not create a `CURRENT_BLOCKERS.md` file by default,
  - do not split `OPERATIONS.md` and `LOCAL_EXECUTION_DOCTRINE.md` by default,
  - do not create `docs/BEADS.md` by default; keep bead doctrine in `OPERATIONS.md` until local complexity earns a split,
  - do not require repo-local `br` wrapper scripts by default,
  - do not require a repo-local workset checker by default,
  - do not create one document per workset or bead by default,
  - if one small repo truly has one spec document, `docs/SPEC.md` may be that document rather than an index.
- Execution-truth split for new repos:
  - `CHARTER.md` owns mission, repo role, and strategic fit,
  - the spec/design set, entered through `docs/SPEC.md`, owns requirements, design, planning, and artifact truth,
  - `docs/WORKSET_REGISTER.md` owns roadmap, large work areas, coarse lifecycle, and work history,
  - `.beads/` owns live execution truth,
  - active work executes through `workset -> epic bead -> child beads`.
- Workset-register rule:
  - use one living all-worksets register by default,
  - the register should describe the ordered workset set, workset meaning, dependency shape, and default sequencing,
  - worksets are high-level planning or scope partitions, not a live task board,
  - register status is limited to coarse `OPEN`, `IN PROGRESS`, and `CLOSED`,
  - coarse status is a scan aid for fresh agents and humans; `br` remains the execution source of truth,
  - once `.beads/` exists, adding an `OPEN` workset to the register means creating the matching epic bead in the same change,
  - bootstrap worksets may be the exception while they create `.beads/`,
  - every non-bootstrap register workset must have a matching epic bead once bead execution exists,
  - `OPEN` means the workset is known and its epic exists, but execution has not yet materially started,
  - `IN PROGRESS` and `CLOSED` should be reconciled at housekeeping or workset boundaries, not after every leaf bead,
  - the register must not track live readiness, blockers, active ownership, leaf progress, or closure evidence,
  - one document per workset is not the default operating model,
  - if a repo has a prior detailed planning breakdown worth retaining, keep it inside the register as a seed map rather than fanning out immediately into separate workset documents.
- Rollout rule:
  - some epics and child beads may be created directly during initial rollout from the register,
  - some epics may start with a rollout bead whose execution creates or refines child beads later,
  - child and rollout beads should be linked under the workset epic with `br` so the epic cannot honestly close while child work remains open,
  - `br` owns readiness, blockers, dependency edges, child closure, and close truth.
- Bead-tool rule:
  - `br` is the authoritative mutation tool,
  - `bv` is the supported graph-aware inspection tool,
  - agents may use only non-interactive robot-style inspection commands,
  - direct edits to `.beads/` state are prohibited,
  - repo-local wrapper scripts are optional operational aids, not part of the default template.
- Verification and review rule:
  - run the relevant useful checks for the touched area,
  - code checks apply once the build/test surface exists,
  - bootstrap and docs-only work may use read-through, link/reference scans, register scans, and `br` sanity checks,
  - fresh-eyes review remains part of closure: code beads need a blunder/omission/bug pass; UX beads need click-through where applicable; infra/doctrine beads need a read-through,
  - close notes should name the decisive useful check or observation, not repeat checklist boilerplate.
- Housekeeping/checker rule:
  - housekeeping should reconcile register entries against workset epic beads and stale pointers,
  - a checker, if present, is a housekeeping aid for link health, register shape, and workset-epic pairing,
  - checker policy must not duplicate `br` invariants for readiness, blockers, dependency closure, child closure, or live progress.
- Cross-repo boundary rule for new repos:
  - agents working in one repo may read sibling repos under the shared `DnaCalc` root for seam consumption, reference checks, replay evidence intake, or design alignment,
  - sibling repos are read-only from the perspective of the current repo unless the user explicitly scopes execution to that repo and the agent loads that repo's local context,
  - otherwise, required changes in another repo must be handled through a handover, prompt packet, or separate repo-local execution run,
  - handovers use `docs/handovers/HANDOVER_<TARGET>_<topic>.md` by default, with the request at the top, `Open`/`Responded`/`Done` status, and any response appended in the same file.
- This standard is the default template for new DNA Calc repos, including host repos such as `DnaOneCalc` and `DnaTreeCalc`.

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

### 10.3 Sequence Baseline for Current Program Layout
Use this dependency-ordered wave sequence for current execution planning:
1. **Wave A (completed)**: lane/host ownership freeze and Foundation text promotion (`OxFunc`/`OxFml`/`OxCalc`/`OxVba`, host progression map). OxFml/OxCalc repos are bootstrapped and Foundation now operates as read-only mirror for lane-owned specs.
2. **Wave B**: OxFml/OxFunc seam hardening (profiles, reject taxonomy, trace contracts, capability/fence contracts, OxFunc resolved-call and optimizer-metadata contract). FEC/F3E concurrency-hardening gates are Stage 2 prerequisites, not Wave B exit criteria; DNA OneCalc and DNA TreeCalc proceed under Stage 1 sequential coordinator. OCaml/Lean kickoff items are Deferred — revisit activation at Wave B when OxFml evaluator contracts are exercised and can inform the formal model shape.
3. **Wave C**: DNA OneCalc proving host — no-reference-resolution profile proving, formula language completeness, OxFunc function catalog validation, Stage 1 sequential coordinator.
4. **Wave D**: OxCalc tree-substrate realization and coordinator baseline closure — tree-only substrate realization (no grid, no spill, no structural rewrites, Stage 1 sequential coordinator).
5. **Wave E**: DNA TreeCalc proving host for serious multi-node behavior before grid complexity.
6. **Wave F**: DNA PreCalc first integrated tree-grid-hybrid host with staged concurrency policy.
7. **Wave G**: DNA SuperCalc and DNA Calc expansion lanes under bounded advanced-lane policy and parity evidence.

### 10.4 Replay Appliance Rollout Baseline
- Replay rollout is a Logistics-owned cross-wave substrate, not a replacement for lane or host progression.
- Required sequence:
  - promote Replay doctrine and architecture in Foundation first,
  - prove first adapter surfaces in `OxCalc` and `OxFml`,
  - centralize stable shared replay mechanics in `OxReplay`,
  - use `DNA ReCalc` as the common replay host surface,
  - widen later to `OxFunc` and `OxVba`.
- Initial lane expectations:
  - `OxCalc` is the first lane expected to drive toward `C5.pack_valid` for `PACK.replay.appliance`.
  - `OxFml` should first prove ingest/replay/diff/explain and add distillation after seam evidence stabilizes.
  - `OxFunc` and `OxVba` begin with narrower initial replay surfaces.
- Downstream host, pack, and promotion claims must name the required adapter capability level rather than assuming Replay support generically.
