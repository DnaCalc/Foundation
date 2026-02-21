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
   Every bug becomes a minimized trace/case and remains in the corpus.
5. **Determinism-first debugging**  
   Deterministic modes exist for triage and conformance runs; non-determinism is opt-in and labeled.
6. **Evidence discipline**  
   Every Excel-compatibility claim is backed by public sources and/or a reproducible observation harness.

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

## 3. Program Structure and Names
### 3.1 System Family
- **DNA Calc** (code token: `DnaCalc`) — the Goldilocks long-term foundation.
- **DNA VisiCalc** (`DnaVisiCalc`) — Round 0 pathfinder.
- **DNA PreCalc** (`DnaPreCalc`) — Round 1 full end-to-end.
- **DNA SuperCalc** (`DnaSuperCalc`) — Round 2 refactor/perfection pass.
- **DNA Calc** (`DnaCalc`) — Round 3 synthesized long-term product.

### 3.2 Team Colors
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
- **Obligation pack**: A computed set of checks required to claim readiness for a profile.
- **Capability manifest**: Runtime/Build metadata describing supported protocols, profiles, features, and pack results.