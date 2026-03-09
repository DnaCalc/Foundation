# CHARTER.md — DNA Calc Charter

## 1. Mission
**DNA Calc Mission**  
DNA Calc is a near-formal, state-of-the-art spreadsheet platform that matches Excel’s behavior with high fidelity while remaining rigorously specified, verifiable, and built to evolve. It is a clean-room implementation based only on public documentation, published research, and reproducible observation of Excel’s behavior—never proprietary sources or reverse-engineering of internals. DNA Calc prioritizes correctness under concurrency, graceful degradation across versions and profiles, and stable, versioned interfaces that support a long-lived ecosystem of tools, add-ins, and automation.

## 2. Doctrine
Doctrine is mandatory operating guidance. **Hygiene** is listed before **Evolution**.

### 2.1 Hygiene Doctrine
1. **Spec-first (or spec-with) changes**  
   Behavior changes are not “done” until spec + cases are updated and gates pass.
2. **Computed obligations, no hand-waving**  
   Required checks are determined mechanically from diffs and profiles; bypass is rare and explicit.
3. **One-command readiness**  
   `meta check` (or equivalent) is the standard way to declare a state “green.”
4. **Regressions are assets**  
   Every bug becomes a minimized, machine-replayable trace/case artifact and remains in the corpus.
5. **Determinism-first debugging**  
   Deterministic modes exist for triage and conformance runs; non-determinism is opt-in and labeled.
6. **Evidence discipline**  
   Every Excel-compatibility claim is backed by public sources and/or a reproducible observation harness.
7. **Coupled assurance stack**  
   Claims of correctness must stay coupled across semantics, proofs/models, executable tests, and CI gate artifacts.

### 2.2 Evolution Doctrine
1. **Profiles are the semantics spine**  
   Documents bind to `profile_id` + `profile_version`. Breaking semantic changes require profile bumps.
2. **Protocols are versioned and negotiated**  
   OpLog, engine protocol surface, automation protocol, UI protocol—each has explicit versions and negotiation.
3. **Degrade gracefully; never crash**  
   Unsupported or unknown features must preserve data (opaque) and/or surface explicit deterministic errors/warnings.
4. **Unknown parts round-trip**  
   When feasible, unrecognized file parts and extension payloads are preserved byte-for-byte.
5. **Migrations are explicit and replayable**  
   Migrations are expressed as operations and are testable/replayable.
6. **No hidden mutation pathways**  
   All persistent state changes flow through the operation model; no “special cases” for UI, scripts, VBA, XLL, or collaboration.

### 2.3 Named Program Principles
1. **Alien Artifact leverage**
   Use mathematically strong methods when they remove ambiguity and increase confidence, but keep each method tied to executable invariants and artifacts.
2. **Design for Evolution**
   Keep seams explicit, versioned, and negotiable so behavior can expand without semantic drift or silent breakage.

## 3. Program Structure and Names
### 3.1 System Family
- **DNA Calc** (code token: `DnaCalc`) — the Goldilocks long-term foundation.
- **DNA VisiCalc** (`DnaVisiCalc`) — Round 0 pathfinder.  
  Functional scope authority for Round 0 is maintained in the DnaVisiCalc docs set (`SPEC_v0.md`, `ENGINE_REQUIREMENTS.md`, `ENGINE_API.md`); Foundation doctrine/process docs must remain consistent with that scope.
- **DNA PreCalc** (`DnaPreCalc`) — Round 1 full end-to-end.
- **DNA SuperCalc** (`DnaSuperCalc`) — Round 2 refactor/perfection pass.
- **DNA Calc** (`DnaCalc`) — Round 3 synthesized long-term product.

### 3.2 Component Repos
- **Foundation** — doctrine, architecture, operations, formal-model framing, and conformance policy authority.
- **DnaVisiCalc** — Round 0 pathfinder and executable seam evidence source.
- **OxFunc** — value universe and function semantics lane.
- **OxFml** — formula language and single-node evaluator/FEC-F3E seam lane. Permanent owner of FEC/F3E seam specification, evaluator contract, and trace schema.
- **OxCalc** — multi-node core calculation engine lane.
- **OxVba** — VBA runtime/compiler and host integration lane.

### 3.3 Host Progression (Execution Vehicles)
- **DNA VbCalc** — dedicated OxVba host proving path (independent lane progression).
- **DNA OneCalc** — single-node formula/function host for fast evaluator proving. Proves formula language completeness, OxFunc function semantics, and UDF/VBA host integration on a single-cell or defined-name substrate with no reference resolution or multi-node scheduling. Clean-room evaluator proving ground separate from the DnaVisiCalc pathfinder.
- **DNA TreeCalc** — first serious multi-node host for OxCalc on tree substrate.
- **DNA PreCalc** — first full tree-grid-hybrid host in the Round 1 path.
- **DNA SuperCalc** — later refinement host stage.
- **DNA Calc** — future full host/product realization.

Interpretation rule:
- Round names describe program stages.
- Repo names describe long-lived ownership lanes.
- Host names describe proving/application vehicles built from those lanes.

#### 3.3.1 Host-to-Round Mapping
- **DNA VbCalc:** independent lane, not round-bound.
- **DNA OneCalc:** lane-proving host from Wave B/C, not round-gated.
- **DNA TreeCalc:** lane-proving host from Wave D/E, proving tree-only before Round 1 grid scope.
- **DNA PreCalc:** Round 1 aligned host.

### 3.4 Team Colors
- **Green** — Spec stack + verification: DSLs, Lean proofs, TLA+ models, OCaml oracle, conformance packs.
- **Red** — Rust implementation.
- **Blue** — .NET implementation.

(“Logistics” exists as a function; it may be implemented primarily in .NET tooling.)

## 4. Clean-room Rule (Non-negotiable)
DNA Calc development relies only on:
- public specifications and documentation,
- published research,
- reproducible observation of Excel behavior.

Excluded:
- proprietary code, restricted materials, decompilation/disassembly of Excel internals, or reverse engineering of internals.

## 5. Glossary (short)
- **Profile**: A versioned semantics bundle defining meaning, compatibility rules, and required obligation packs.
- **OpLog**: The operation log—the single representation of persistent state changes.
- **Epoch / Meta-epoch**: Epoch versions document state; meta-epochs version stabilized project states (profiles + packs + implementations).
- **Calc stabilized**: A runtime/data state where derived outputs are complete for a declared scope and epoch.
- **Profile green**: A release/readiness state where all required obligation packs for a profile are passing.
- **Stabilized epoch**: The latest epoch whose derived values are complete for a declared scope.
- **Meta-epoch commit**: A published stabilization checkpoint containing capability manifest, conformance report, and regression updates.
- **Artifact freeze**: A required set of versioned artifacts that must be locked before advancing rounds or declaring a profile green.
- **External update op**: An explicit OpLog operation representing inbound STREAM/RTD-like value changes.
- **Stream semantics version**: A profile-scoped version token controlling STREAM/external update behavior.
- **Stream replay bundle**: A versioned artifact containing topic declarations and ordered update envelopes for deterministic replay.
- **Degradation class**: Policy outcome for unsupported behavior (`Native`, `Lowered`, `Opaque`, `Rejected`).
- **Obligation pack**: A computed set of checks required to claim readiness for a profile.
- **Capability manifest**: Runtime/Build metadata describing supported protocols, profiles, features, and pack results.
