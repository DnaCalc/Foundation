# INDEPENDENT REVIEW: DNA Calc Foundation

**Reviewer**: Claude (Opus 4.6), commissioned independent review
**Date**: 2026-02-23
**Scope**: All foundation documents, research runs, synthesis passes, and prompt pack responses
**Method**: Full document corpus reading + extensive web research on precedents, competitors, formal methods, and project management patterns
**Supporting files**: `notes/review/` directory contains detailed annexes

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [What Is Being Attempted](#2-what-is-being-attempted)
3. [Six Thinking Hats Analysis](#3-six-thinking-hats-analysis)
4. [The Praise: What Is Genuinely Excellent](#4-the-praise-what-is-genuinely-excellent)
5. [The Criticism: Structural Concerns](#5-the-criticism-structural-concerns)
6. [Meta-Criticism: Is the Process Itself Problematic?](#6-meta-criticism-is-the-process-itself-problematic)
7. [Historical Precedent Analysis](#7-historical-precedent-analysis)
8. [Risks-Opportunities Matrix](#8-risks-opportunities-matrix)
9. [Alternative Directions](#9-alternative-directions)
10. [The Path to "Alien Artifact" Level](#10-the-path-to-alien-artifact-level)
11. [Provocations (de Bono Po Operations)](#11-provocations-de-bono-po-operations)
12. [Concrete Recommendations Hierarchy](#12-concrete-recommendations-hierarchy)
13. [The Verdict](#13-the-verdict)

---

## 1. Executive Summary

DNA Calc is one of the most ambitious software architecture documents I have ever analyzed. It proposes a clean-room, formally verified, dual-engine spreadsheet platform with Excel behavioral compatibility -- a project that would be remarkable for a well-funded team of 50, let alone what appears to be a solo or very small team effort. The foundation documents are intellectually extraordinary. They are also, in their current form, a blueprint for a project that will never ship.

This is not a condemnation. It is a diagnosis, and the disease is curable. The architecture is sound. The doctrine is thoughtful. The verification strategy is genuinely novel in the spreadsheet space. But the project is currently trapped in what I will call the **Doctrine Recursion Problem**: the process of defining how to build DNA Calc has become more elaborate than any actual building. The project has produced ~80 documents defining how it will work, zero lines of executable code, and a process discipline that requires more infrastructure to implement than most complete software products.

The core tension: DNA Calc wants to be both *the most formally rigorous spreadsheet ever built* AND *a commercially viable product that matches Excel*. These goals are not inherently contradictory, but they require radically different sequencing than what is currently planned.

**Bottom line**: The architecture should be simplified by 60%, the round structure collapsed, and a working prototype should exist within 60 days. The formal methods work should follow the code, not precede it. Everything excellent about the current design can be preserved while reversing the order of operations.

---

## 2. What Is Being Attempted

Let me state clearly what DNA Calc proposes, because the ambition deserves precise articulation:

### 2.1 The Product Vision
A spreadsheet that matches Excel's behavior with high fidelity, built from scratch using only public documentation and reproducible observations. Not a clone of Excel's code -- a clean-room reimplementation of Excel's *observable behavior*.

### 2.2 The Technical Architecture
- **Three Hard Boundaries**: OpLog (operations) -> DocSnapshot (versioned state) -> CalcDeltas (derived outputs)
- **Dual Engines**: Independent implementations in Rust (Red) and .NET (Blue)
- **Formal Verification Stack**: Lean proofs for semantics, TLA+ for concurrency, OCaml oracle for reference behavior
- **MVCC Epoch Model**: Committed/stabilized epochs with explicit staleness
- **Profile-Based Compatibility**: Versioned semantic contracts with degradation policies
- **UI Stack**: Tauri + Canvas/WebGL grid + DOM overlay editor

### 2.3 The Process Architecture
- **Four Rounds**: VisiCalc (pathfinder) -> PreCalc (full E2E) -> SuperCalc (refactor) -> DnaCalc (product)
- **Three Teams**: Green (spec/verification), Red (Rust), Blue (.NET)
- **Obligation Packs**: Computed, machine-checkable readiness gates
- **Clean-Room Evidence**: Formal evidence workflow for every compatibility claim
- **Meta CLI**: Automated obligation resolution and conformance checking

### 2.4 The Quality Bar
The stated reference point is "Asupersync" -- a project with 2,689 commits, 146 tracked theorems, 6 canonical invariants, and machine-checkable CI gates across doctrine, semantics, formalization, conformance, testing, and gates.

This is not a modest undertaking.

---

## 3. Six Thinking Hats Analysis

Applying Edward de Bono's parallel thinking framework systematically:

### White Hat (Information/Facts)

**What we know:**
- The foundation repository contains ~80 files across 7 directories, all documentation -- zero code
- All documents were created within a single 48-hour period (2026-02-22 to 2026-02-23)
- The project references Asupersync (2,689 commits in ~37 days by essentially one person) as the quality bar
- Six deep research runs have been completed, four synthesis passes
- 18 prompt pack responses have been generated and synthesized
- The architecture describes a system requiring expertise in: Rust, .NET/C#, OCaml, Lean 4, TLA+, TypeScript, Canvas/WebGL, Tauri, OOXML, XLL/COM, and formal methods
- The spreadsheet market is ~$10.25B (2024), projected ~$20.85B by 2033
- Excel has ~800M active users; the most successful clean-room reimplementations (Wine, Samba) took 15-30+ years to reach maturity
- HyperFormula built 400+ Excel-compatible formulas in 15 months with EU funding
- Gnumeric achieved 100% Excel worksheet function coverage

**What we don't know:**
- Team size, funding, and timeline expectations
- Whether any implementation work has begun in separate repositories
- The specific market segment or use case being targeted
- Whether the dual-engine (Rust + .NET) requirement is firm or exploratory
- How "agentic coding" will be leveraged (the documents reference "agentic coding weather" but don't specify the human/AI development model)

### Red Hat (Feelings/Intuitions)

**Initial gut reactions:**
- **Awe**: The intellectual depth is genuinely impressive. The epoch model, the profile system, the obligation packs -- these are sophisticated ideas that reflect deep understanding of both spreadsheet semantics and formal methods.
- **Anxiety**: The sheer scope triggers a visceral sense of "this will never be built." The gap between the documentation's ambition and any tangible artifact is enormous.
- **Recognition**: This feels like the work of someone who has spent a career in compiler/runtime/systems engineering and is applying that discipline to a new domain. The vocabulary and patterns are those of someone who has built real systems.
- **Concern**: The 48-hour creation window suggests an intense burst of ideation that has not yet been tested against the friction of implementation. Ideas that feel complete on paper often fracture on contact with code.
- **Excitement**: If even 30% of this vision were realized, it would be genuinely novel. A formally verified spreadsheet engine with deterministic replay and cross-engine conformance testing does not exist.

### Yellow Hat (Optimism/Benefits)

**What could go spectacularly right:**

1. **The clean-room approach is legally bulletproof.** If executed properly, DNA Calc faces zero IP risk from Microsoft. The Compaq BIOS precedent (1982) and the Oracle v. Google Supreme Court decision (2021) establish that API reimplementation is fair use. The evidence workflow described in the foundation documents is more rigorous than any clean-room process I've seen documented.

2. **The formal methods investment could become a permanent competitive moat.** Once proofs exist for core semantics, they are *forever*. CompCert's formally verified C compiler has never produced a miscompilation bug. If DNA Calc achieves even partial formal verification of its core calc engine, no competitor can make the same claim.

3. **The dual-engine architecture provides extraordinary confidence.** The N-version programming literature confirms: independently implemented systems that agree on outputs provide much stronger correctness evidence than any single implementation. If Red and Blue produce identical results for the same inputs, the probability of both having the same bug is negligible.

4. **The profile/degradation system is genuinely innovative.** No existing spreadsheet implementation has a formal degradation taxonomy (Native/Lowered/Opaque/Rejected). This could become the industry standard for expressing compatibility levels.

5. **The epoch/MVCC model solves real problems.** Excel's "calculating..." state is opaque and frustrating. Explicit stale/pending/fresh status with epoch tagging would be a genuine UX improvement.

6. **Agentic coding may make the impossible possible.** If AI-assisted development delivers 3-5x productivity multipliers (as reported by multiple sources in 2025-2026), a solo developer with AI agents could potentially execute what would otherwise require a team. The "agentic coding flywheel" described in the brainstorm notes is prescient.

7. **The market timing may be right.** The spreadsheet market is growing at ~9% CAGR. AI integration (Excel COPILOT(), Google =AI()) is creating a platform transition moment. Platform transitions are when incumbents are most vulnerable -- this is exactly how Excel displaced Lotus 1-2-3 during the DOS-to-Windows transition.

### Black Hat (Caution/Risk)

**What could go badly wrong:**

1. **The Second System Effect is screaming.** Fred Brooks identified this pathology precisely: the designer's second system is "the most dangerous" because they incorporate every deferred improvement from their first system. DNA Calc reads like the second system of someone who has built a simpler system and is now determined to do it "right." The result is a design that is complete on paper but may be impossible to build.

2. **Scope is the existential threat.** ReactOS has been in development for 30 years and is still alpha quality. Wine took 15 years to reach version 1.0. Both target a smaller compatibility surface than "Excel behavioral compatibility." The honest question: is DNA Calc's scope achievable in any reasonable timeframe?

3. **The formal methods tax may be unsustainable.** seL4's formal verification cost ~20 person-years for 9,000 lines of C. CompCert required ~6 person-years for a compiler. DNA Calc's calc engine alone will be orders of magnitude larger. The cost multiplier for formal verification is estimated at 5-10x. If the core engine is 50,000 lines, formal verification could require 25-50 person-years of effort.

4. **Six programming languages is a red flag.** The architecture requires Rust, .NET/C#, OCaml, Lean 4, TLA+, and TypeScript. Each language has its own toolchain, build system, dependency management, and learning curve. Even a highly polyglot developer will lose significant time to context-switching. For AI-assisted development, this means maintaining prompt engineering expertise across six different ecosystems.

5. **The dual-engine commitment doubles the work with unclear ROI.** Building two independent implementations is a powerful correctness technique, but it literally doubles the implementation effort. The Firefox/Servo experience shows that maintaining dual codebases is "extremely vulnerable to organizational changes, funding disruptions, and fatigue." Unless there is a specific commercial reason to offer both Rust and .NET engines, one should be deferred.

6. **No evidence of market validation.** The documents contain zero discussion of target users, pricing, distribution, or competitive positioning beyond "matches Excel's behavior." The spreadsheet market is dominated by free/included products (Excel with Office 365, Google Sheets free tier). What is the business model?

7. **The process infrastructure requires its own development team.** The `meta` CLI, obligation resolver, pack system, evidence workflow, synthesis runs, prompt packs, research runs, topic registries, and source tracking described in OPERATIONS.md would themselves constitute a significant software project. Building the tools to build the tools to build the product is a classic trap.

8. **Document-to-code ratio is infinity.** There are ~80 documents and zero lines of code. This is the most dangerous possible ratio. Every hour spent refining documents without writing code increases the risk that the documents describe something unbuildable.

### Green Hat (Creativity/Alternatives)

*(Covered in detail in Section 9: Alternative Directions and Section 11: Provocations)*

### Blue Hat (Meta/Process)

**Observations about the thinking process itself:**

1. The foundation documents show remarkably consistent quality, suggesting a single mind (possibly AI-assisted) producing them in a concentrated burst. This is both a strength (coherence) and a weakness (no adversarial review, no implementation feedback).

2. The synthesis-run process is well-designed in theory but has only been exercised on its own outputs. The system has never synthesized feedback from actual implementation attempts.

3. The document hierarchy (CHARTER > ARCHITECTURE > OPERATIONS > notes) is sound, but the volume of content at each level suggests insufficient editing/compression. The Charter alone is 85 lines -- a good charter fits on one page.

4. The use of prompts, research runs, and synthesis passes to generate and refine the architecture is innovative but risks creating an echo chamber. The same AI models that generated suggestions are evaluating those suggestions. This review represents the first genuinely external perspective.

---

## 4. The Praise: What Is Genuinely Excellent

### 4.1 The Three Hard Boundaries

The OpLog -> DocSnapshot -> CalcDeltas separation is architecturally beautiful and correct. This is the right decomposition. Event sourcing for spreadsheet state, immutable snapshots for computation, and explicit delta emission for UI/API consumers -- this is how you build a spreadsheet engine that can support collaboration, undo/redo, deterministic replay, and formal verification simultaneously.

This is better than what Excel does internally. It is better than what Google Sheets does. It is the correct architecture, full stop.

### 4.2 The Epoch/MVCC Model

Treating spreadsheet recalculation as an MVCC system with explicit epoch versioning is a genuinely novel contribution. The "no stale commit" invariant, the explicit stale/pending/fresh status lattice, and the snapshot pinning model are all sound engineering that solves real problems users face with Excel's opaque "calculating..." state.

The connection to Timely Dataflow's stabilization semantics (via the Naiad research) is particularly insightful. This isn't reinventing the wheel -- it's applying proven distributed systems concepts to a domain where they haven't been applied before.

### 4.3 The Clean-Room Discipline

The evidence workflow described in the documents is more rigorous than any clean-room process I found in public literature. The requirement for evidence records with linked REQ/INT/REAL IDs, the distinction between DOC/OBS/MIXED evidence classes, the anti-footgun rules -- this is genuine legal and engineering discipline.

For context: Compaq's clean-room BIOS cost $1M and used physical separation between teams. Phoenix Technologies bought a $2M insurance policy. DNA Calc's evidence workflow is more thorough than either of these historical precedents.

### 4.4 The Degradation Taxonomy

Native/Lowered/Opaque/Rejected is a crisp, complete taxonomy for handling unsupported features. No existing spreadsheet implementation has anything like this. LibreOffice silently drops or corrupts unsupported Excel features. Google Sheets silently degrades them. DNA Calc's approach of making degradation explicit, deterministic, and diagnostics-backed is genuinely superior.

### 4.5 The Obligation Pack Concept

Machine-computed readiness gates tied to profile definitions is the right way to manage quality in a complex system. The idea that "you cannot declare a profile stabilized unless all required packs pass" is exactly how formal methods should integrate with development process -- not as optional documentation, but as mandatory gates.

### 4.6 The Research Process

The systematic approach to research -- topic registries, deep research runs with provenance tracking, synthesis passes with decision logs -- is exceptional. Most projects of this ambition level operate on vibes and tribal knowledge. DNA Calc has an auditable research trail that would satisfy an academic review board.

---

## 5. The Criticism: Structural Concerns

### 5.1 The Doctrine Recursion Problem

The most serious structural issue: **the project is building infrastructure for building infrastructure for building the product.**

Current layers of indirection before code exists:
1. Charter (defines doctrine)
2. Architecture & Requirements (defines system shape)
3. Operations (defines how to develop)
4. Prompt packs (define how to generate analysis)
5. Research runs (generate domain knowledge)
6. Synthesis runs (integrate knowledge into doctrine)
7. Obligation packs (define how to verify)
8. Meta CLI (automates verification)
9. Profile definitions (define what to verify against)
10. Evidence workflow (defines how to prove compatibility)

Each layer is individually justifiable. Together, they form a recursion that never bottoms out in executable code. This is the software engineering equivalent of Zeno's paradox -- the project approaches implementation by an infinite series of halving steps.

**The fix is simple: write code first, then wrap doctrine around it.** SQLite didn't start with 146 tracked theorems. It started with a byte-code engine. TeX didn't start with literate programming. It started with a typesetter that could set mathematical formulas. Samba didn't start with an AD domain controller specification. It started with a packet sniffer.

### 5.2 The Language Proliferation Problem

Six programming languages (Rust, C#, OCaml, Lean 4, TLA+, TypeScript) is too many for any team smaller than 20 people. The cognitive overhead of maintaining fluency across six ecosystems, six build systems, and six sets of tooling is enormous.

**Comparison**: Asupersync (the stated quality bar) uses one language (Rust) with Lean and TLA+ for formal methods. That's three languages, not six. And Asupersync was built by essentially one person at extraordinary velocity (2,689 commits in 37 days). The addition of OCaml (oracle), .NET (Blue engine + tooling), and TypeScript (UI) triples the language surface area.

**Recommendation**: For Round 0, use at most three languages:
- **Rust** for the engine (primary)
- **TypeScript** for the UI
- **TLA+** for concurrency verification (small, bounded models only)

Defer Lean proofs, OCaml oracle, and the .NET engine to Round 1 or later. The OCaml oracle can be replaced by a Rust reference implementation running in deterministic mode. The .NET engine provides independent confirmation of spec clarity, but this confirmation is worthless if there is no spec to confirm (because no implementation feedback has shaped the spec yet).

### 5.3 The Dual Engine Trap

Building two independent engines (Rust + .NET) is a powerful correctness technique from the N-version programming literature. It is also, empirically, a technique that works in organizations with dedicated teams for each version. Boeing uses it for flight control. Airbus uses it for fly-by-wire. Both have hundreds of engineers.

For a solo or small team project, dual engines mean:
- Every feature takes 2x effort to implement
- Every spec change requires 2x updates
- Every bug fix must be investigated in both codebases
- The project cannot ship until both engines pass

**The Firefox/Servo lesson**: Mozilla built Servo (Rust) alongside Gecko (C++) and planned a gradual migration. The technical work succeeded (Stylo replaced 160,000 lines of C++ with 85,000 lines of Rust, achieving 30% speedups). But in 2020, Mozilla laid off 250 employees including most Servo developers, effectively killing the dual-engine effort. The organizational cost of maintaining two codebases was unsustainable even for a well-funded organization.

**Recommendation**: Build one engine (Rust) and use the OCaml oracle or a reference test suite for cross-validation. If the project succeeds and grows, the .NET engine can be added later as a second implementation for high-assurance contexts.

### 5.4 The Verification Scope Problem

The formal verification ambitions are noble but may be economically irrational:

| Project | Code Size | Proof Effort | Ratio |
|---------|-----------|-------------|-------|
| seL4 | 9,000 LOC | 20 person-years | 2.2 py/KLOC |
| CompCert | ~100,000 LOC | 6 person-years | 0.06 py/KLOC |
| DNA Calc engine (estimate) | 50,000-200,000 LOC | ??? | ??? |

Even at CompCert's favorable ratio (0.06 py/KLOC), formally verifying a 100K-line spreadsheet engine would require ~6 person-years of pure proof work. At seL4's ratio, it would be 220 person-years.

**The practical alternative**: AWS's approach -- use TLA+ to model and check critical protocol-level properties (epoch consistency, no stale commits, exclusive mutation), but do NOT attempt to formally verify the entire implementation. AWS found bugs in DynamoDB and S3 with TLA+ models of 100-900 lines of PlusCal, learned by engineers in 2-3 weeks. This is the right scope for formal methods in DNA Calc.

**Recommendation**:
- TLA+ for the epoch/concurrency protocol: **Yes, definitely, do this**
- Lean proofs for core formula semantics: **Defer until Round 1, after the engine exists**
- OCaml oracle: **Replace with a Rust reference test suite**
- Full formal verification of the engine: **Never -- use property-based testing and fuzzing instead, following SQLite's model**

### 5.5 The Round Structure Is Overengineered

Four named rounds (VisiCalc -> PreCalc -> SuperCalc -> DnaCalc) with artifact freezes, meta-epoch commits, and explicit exit criteria sounds disciplined but creates artificial phase gates that can trap the project.

**The problem with named rounds**: They create a psychological commitment to "finishing" each round before proceeding. But software development is iterative, not sequential. The most successful approach is continuous delivery -- ship incrementally, get feedback, adjust.

**Comparison**: Google Sheets launched in 2006 with basic cell editing, simple formulas (SUM, AVERAGE), and import from XLS/CSV. It didn't have "Round 0" and "Round 1" -- it had "ship something, then ship more." Twenty years later, it has 160-180 million users.

**Recommendation**: Replace the four-round structure with a single continuous delivery pipeline. Define a "minimum demonstrable product" (not MVP -- this is a platform, not a startup) and ship it. Then iterate.

### 5.6 Missing Market Analysis

The most glaring gap in the foundation documents: there is no discussion of who will use DNA Calc, why, or how it will be distributed and monetized. The Charter defines what DNA Calc *is* but not who it is *for*.

**The spreadsheet market reality**:
- Excel is included with Microsoft 365 (from $6.99/month)
- Google Sheets is free
- LibreOffice Calc is free and open-source
- The market is $10.25B but dominated by free/bundled products

**The question DNA Calc must answer**: Why would anyone use a new spreadsheet that is not Excel? Possible answers include:
- Formal guarantees of correctness (regulated industries: finance, pharma, aerospace)
- Deterministic, auditable computation (audit/compliance use cases)
- Embeddable engine (developers building spreadsheet-powered applications)
- Open-source alternative with superior architecture (developer/enthusiast community)

Each of these answers implies a radically different product strategy, pricing model, and feature priority.

---

## 6. Meta-Criticism: Is the Process Itself Problematic?

### 6.1 The Echo Chamber Risk

The current process is:
1. Generate analysis with AI (prompt packs)
2. Research topics with AI (deep research runs)
3. Synthesize with AI (synthesis passes)
4. Review with AI (this document)

At no point has a human user, potential customer, or independent engineer reviewed the architecture against the friction of implementation. The process is sophisticated but hermetic -- it lacks external input that could challenge fundamental assumptions.

**The Asupersync comparison is misleading.** Asupersync was built by one person writing *code* at extraordinary velocity. DNA Calc's planning documents reference Asupersync's quality bar without acknowledging that Asupersync achieved that bar through *implementation*, not through planning documents.

### 6.2 The Doctrine May Be Premature

Several doctrine items in the Charter are stated as "mandatory operating guidance" but are actually design decisions that should be validated through implementation:

- "Profiles are the semantics spine" -- Is a profile system needed before you have a single working formula evaluator?
- "Protocols are versioned and negotiated" -- Is protocol negotiation needed before you have a protocol?
- "Unknown parts round-trip" -- Is OOXML round-tripping needed before you can evaluate `=A1+1`?

These are all *eventually* correct requirements. But making them doctrine before implementation means the first line of code must satisfy an enormous number of constraints simultaneously. This is the opposite of iterative development.

### 6.3 The Process Is Producing Documents, Not Software

The foundation repository's commit history tells the story:
- `cb5fe27` Synthesis pass 02: integrate prompt and research runs
- `255d8b3` Housekeeping: capture external reports and run4 artifacts
- `14fa198` Add internal deep research run 3 on Asupersync
- `c1d7f4b` Record internal deep research runs 1/2 and comparison artifacts
- `bcea479` Expand research registry and add running project notes

Every commit is a document operation. The project's velocity is measured in words, not in features. This is appropriate for a brief planning phase but becomes pathological if it continues.

### 6.4 The Complexity Budget Is Spent Before Building Begins

There is a finite amount of complexity any project can sustain. DNA Calc has spent a large portion of its complexity budget on process infrastructure (synthesis runs, obligation resolvers, meta CLI, evidence workflows, pack schemas) before any product complexity exists. This leaves less complexity budget for the actual product.

**SQLite's counter-example**: SQLite started as a simple byte-code engine with a minimal SQL parser. The extraordinary testing infrastructure (590x test-to-code ratio, 100% branch coverage, 1 billion fuzz mutations/day) was built *incrementally over 25 years*, not designed upfront.

---

## 7. Historical Precedent Analysis

### 7.1 Clean-Room Implementations: What Actually Works

| Project | Scope | Duration to v1.0 | Team | Outcome | Lesson for DNA Calc |
|---------|-------|-------------------|------|---------|---------------------|
| Compaq BIOS | Small (BIOS) | ~9 months | Small, two-team | $111M year 1 | Small scope = fast success |
| Phoenix BIOS | Small (BIOS) | ~12 months | Small, two-team | Licensed to dozens | Industrialize the process |
| Apache Harmony | Large (Java SE) | Never (killed at 99%) | IBM-funded | Killed by politics | Certification gates can kill you |
| ReactOS | Enormous (full OS) | 30 years, still alpha | ~300 volunteers | Alpha quality | Full-scope reimplementation may be impossible |
| Wine | Large (Windows API) | 15 years to v1.0 | Hybrid volunteer/commercial | Commercially viable | Narrow scope + sustained funding works |
| Samba | Growing (SMB -> AD) | Grew organically | Started solo | Widely deployed | Start small, grow with demand |
| HyperFormula | Medium (calc engine) | 15 months | EU-funded team | Commercial product | Formula engine is tractable |

**The pattern**: Successful clean-room projects start small and grow. Failed ones start comprehensive and stall. DNA Calc's current trajectory is closer to ReactOS (comprehensive from day one) than Samba (start with one packet sniffer).

### 7.2 Spreadsheet Competitors: What Actually Ships

| Product | Approach | Excel Compat | Market Result |
|---------|----------|-------------|---------------|
| LibreOffice Calc | Full reimplementation | Good, imperfect | Widely used (7M+ LOC over 40 years) |
| Gnumeric | Function-focused | 100% worksheet functions | Niche (no .xlsx write) |
| Google Sheets | Different axis (collaboration) | Partial | 160-180M users |
| Apple Numbers | Deliberate non-clone | Minimal | Apple ecosystem only |
| HyperFormula | Headless engine | 400+ formulas | Commercial product |

**The lesson**: No product has achieved full Excel compatibility through reimplementation. The successful products either (a) accepted imperfect compatibility (LibreOffice), (b) competed on a different axis (Google Sheets), or (c) focused on the engine only (HyperFormula).

### 7.3 Formally Verified Software: What Actually Gets Verified

| Project | What Was Verified | LOC Verified | Effort | Maintained? |
|---------|-------------------|-------------|--------|-------------|
| seL4 | OS kernel (functional correctness) | 9,000 | 20 py | Yes (10+ years) |
| CompCert | C compiler (semantic preservation) | ~100K (passes) | 6 py | Yes (20+ years) |
| s2n-tls | TLS implementation (subset) | Subset of TLS | Ongoing (CI/CD) | Yes |
| AWS TLA+ | Distributed protocols (safety/liveness) | Models: 100-900 lines | 2-3 weeks/model | Yes |

**The pattern**: Successful formal verification targets *critical properties of small systems*, not *all properties of large systems*. AWS's TLA+ usage is the model to follow: small models, targeted invariants, integrated with engineering workflow.

---

## 8. Risks-Opportunities Matrix

### Risk Matrix

| ID | Risk | Likelihood | Impact | Mitigation | Status |
|----|------|-----------|--------|------------|--------|
| **R-01** | Project never produces executable code (infinite planning) | **HIGH** | **CRITICAL** | Set hard deadline for first executable artifact | **UNMITIGATED** |
| **R-02** | Scope too large for team size | **HIGH** | **CRITICAL** | Ruthlessly cut scope; target embeddable engine first | **UNMITIGATED** |
| **R-03** | Dual engine commitment doubles work | **HIGH** | **HIGH** | Defer Blue (.NET) engine to Round 1+ | **UNMITIGATED** |
| **R-04** | Formal verification costs exceed budget | **MEDIUM** | **HIGH** | Limit to TLA+ models; defer Lean proofs | **PARTIALLY MITIGATED** (TLA+ scoped) |
| **R-05** | Six languages exceed cognitive capacity | **HIGH** | **MEDIUM** | Reduce to 3 languages for Round 0 | **UNMITIGATED** |
| **R-06** | No market validation or business model | **HIGH** | **CRITICAL** | Define target market and test with potential users | **UNMITIGATED** |
| **R-07** | Clean-room discipline breaks down under pressure | **LOW** | **HIGH** | Evidence workflow is well-designed; maintain it | **MITIGATED** |
| **R-08** | Excel compatibility surface is effectively infinite | **HIGH** | **HIGH** | Target a specific compatibility "level" with explicit non-goals | **PARTIALLY MITIGATED** (profiles) |
| **R-09** | UI development consumes disproportionate effort | **MEDIUM** | **HIGH** | Start headless; add UI incrementally | **UNMITIGATED** |
| **R-10** | "Agentic coding weather" produces low-quality code at high velocity | **MEDIUM** | **MEDIUM** | Obligation packs and test-first discipline | **MITIGATED** (if packs exist) |
| **R-11** | Key person risk (solo/small team) | **HIGH** | **CRITICAL** | Maintain excellent documentation (already strong) | **PARTIALLY MITIGATED** |
| **R-12** | Process infrastructure becomes unmaintainable | **MEDIUM** | **HIGH** | Simplify process; use off-the-shelf tools where possible | **UNMITIGATED** |

### Opportunity Matrix

| ID | Opportunity | Feasibility | Impact | Required Action |
|----|-------------|-------------|--------|-----------------|
| **O-01** | First formally verified spreadsheet engine | **MEDIUM** | **VERY HIGH** | Focus TLA+ on epoch model; publish results |
| **O-02** | Embeddable spreadsheet engine (library) | **HIGH** | **HIGH** | Ship headless Rust engine as crate/NuGet package |
| **O-03** | Deterministic, auditable computation for regulated industries | **HIGH** | **HIGH** | Target finance/pharma compliance use cases |
| **O-04** | AI-native spreadsheet with provable semantics | **MEDIUM** | **VERY HIGH** | Combine formal semantics with AI formula generation |
| **O-05** | Best-in-class spreadsheet error detection | **HIGH** | **HIGH** | Use formal spec to detect semantic errors in user formulas |
| **O-06** | Developer platform (HyperFormula competitor) | **HIGH** | **MEDIUM** | Focus on API/SDK, not end-user UI |
| **O-07** | Research platform for spreadsheet formal methods | **HIGH** | **MEDIUM** | Publish papers on TLA+/Lean application to spreadsheets |
| **O-08** | The "agentic coding" showcase project | **MEDIUM** | **MEDIUM** | Document the AI-assisted development process publicly |

---

## 9. Alternative Directions

### 9.1 The "Headless Engine First" Path

**Instead of**: Building a complete spreadsheet application with UI, file I/O, and collaboration
**Build**: A headless calculation engine (like HyperFormula, but in Rust, with formal properties)

**Why this works**:
- HyperFormula proved the engine-only market exists (15 months to 400+ formulas)
- An embeddable engine has immediate commercial value (web apps, reporting tools, data pipelines)
- Formal verification is tractable for a pure calculation engine (no UI, no I/O, no collaboration)
- The engine can be tested against Excel's behavior using black-box observation harnesses
- The UI, file I/O, and collaboration layers can be added incrementally

**What ships**: A Rust crate and .NET NuGet package that evaluates spreadsheet formulas with formally verified core semantics.

### 9.2 The "Excel Compatibility Validator" Path

**Instead of**: Reimplementing Excel
**Build**: A tool that validates spreadsheet behavior against Excel's documented semantics

**Why this works**:
- The clean-room evidence workflow already describes how to capture and verify Excel behavior
- A validator is simpler than an implementation but equally valuable
- Regulated industries need proof that their spreadsheets compute correctly
- 86-94% of audited spreadsheets contain errors (Panko/EuSpRIG research)
- This could be a standalone product or the foundation for a later engine

**What ships**: A CLI tool that takes an .xlsx file and reports potential computation errors, semantic ambiguities, and compatibility risks.

### 9.3 The "AI + Formal Semantics" Path

**Instead of**: Competing with Excel on features
**Build**: A spreadsheet that uses formal semantics to make AI integration provably correct

**Why this works**:
- Excel's COPILOT() function and Google's =AI() function are generating results with zero formal guarantees
- A spreadsheet where AI-generated formulas can be verified against formal semantics would be unique
- The profile system could define "AI-safe" computation boundaries
- This targets the fastest-growing segment of the spreadsheet market

**What ships**: A spreadsheet where every AI-generated formula is validated against formal specifications before execution.

### 9.4 The "One Language, One Engine, Ship Fast" Path

**Instead of**: Rust + .NET + OCaml + Lean + TLA+ + TypeScript
**Build**: Everything in Rust (engine + CLI + WASM for web UI)

**Why this works**:
- Rust compiles to WASM, enabling a web-based spreadsheet with native performance
- One language means one build system, one dependency manager, one debugger
- The Rust ecosystem has strong property-based testing (proptest) and fuzzing (cargo-fuzz)
- Salsa (Rust incremental computation, used in rust-analyzer) provides a proven foundation for incremental recomputation
- The Rust + WASM + web UI approach is proven by projects like Figma

**What ships**: A web-based spreadsheet powered by a Rust/WASM engine, with property-based testing and optional TLA+ verification of the concurrency protocol.

---

## 10. The Path to "Alien Artifact" Level

The Charter names "Alien Artifact leverage" as a principle. Here is what that actually requires, based on the projects that have achieved it:

### 10.1 What "Alien Artifact" Actually Means

The term comes from the idea that sufficiently well-engineered software appears to have been built by a more advanced civilization. The canonical examples:

- **SQLite**: 590x test-to-code ratio. 100% branch coverage. 1 billion fuzz mutations per day. Two people.
- **TeX**: No bugs reported in 30 years. Source code is a publishable book. One person.
- **seL4**: Mathematical proof that the kernel never crashes, overflows, or leaks memory. ~12 people.
- **CompCert**: Mathematical proof that the compiler never miscompiles. ~7 people.

### 10.2 The Common Pattern

Every "alien artifact" project shares these properties:

1. **Started with working code, not documentation.** SQLite started as a byte-code engine. TeX started as a typesetter. seL4 started as a Haskell prototype. CompCert started as a simple compiler.

2. **Testing/verification was added incrementally.** SQLite's 590x test ratio was built over 25 years, not designed upfront. seL4's proofs were developed over a decade alongside the implementation.

3. **Scope was narrow and well-defined.** SQLite is *only* a database. TeX is *only* a typesetter. seL4 is *only* a microkernel. CompCert is *only* a C compiler. None of them tried to be a platform.

4. **The team was small and sustained.** SQLite: 2 people for 25 years. TeX: 1 person for 10 years. seL4: ~12 researchers for 10+ years. Long-term commitment with small teams beats large teams with short commitments.

5. **The testing methodology was innovative.** SQLite's dbsqlfuzz. TeX's bug bounty. seL4's refinement proofs. CompCert's Csmith validation. Each project invented a testing approach that was itself remarkable.

### 10.3 DNA Calc's Path to Alien Artifact

To achieve "alien artifact" status, DNA Calc should:

**Phase 1 (Months 1-3): Build the Core**
- Implement a minimal formula evaluator in Rust (arithmetic, references, SUM, IF)
- Implement the epoch model (committed/stabilized/value_epoch)
- Implement deterministic mode with trace replay
- Write property-based tests for every component
- **Ship a Rust crate that can evaluate simple spreadsheets deterministically**

**Phase 2 (Months 3-6): Add Verification**
- Write a TLA+ model of the epoch/concurrency protocol (the documents already have an excellent design for this)
- Add fuzz testing following SQLite's model (mutate both formulas and data)
- Begin a test corpus that grows monotonically (every bug becomes a permanent test case)
- Start tracking test-to-code ratio as a first-class metric
- **Publish the TLA+ model and invite review**

**Phase 3 (Months 6-12): Add Confidence**
- Expand formula coverage toward Excel function set (guided by Gnumeric's 100% achievement)
- Add .xlsx read support (write can come later)
- Begin Lean formalization of core semantics (now informed by 6 months of implementation)
- Add scaling signature suite (the documents' design for this is good)
- **Target: 10x test-to-code ratio, TLA+ model-checked invariants, 200+ Excel functions**

**Phase 4 (Months 12-24): Approach Artifact Status**
- Add UI (Tauri + Canvas, following the existing design)
- Add .xlsx write support with degradation diagnostics
- Expand Lean proofs for critical properties only
- Target: 50x test-to-code ratio, comprehensive fuzzing
- **Ship a beta that can open and recalculate real-world Excel files**

**Phase 5 (Year 2+): Alien Artifact**
- 100x+ test-to-code ratio
- Continuous formal verification (following Amazon s2n-tls model)
- Every regression becomes a permanent minimized test case
- TLA+ invariants checked in CI
- **The testing and verification infrastructure becomes the product's competitive moat**

### 10.4 The Key Insight

The "alien artifact" quality comes from the *ratio* of verification to code, not from the *absolute amount* of verification. A 10,000-line engine with 1,000,000 lines of tests is more impressive (and more reliable) than a 100,000-line engine with 100,000 lines of proofs. SQLite achieves its extraordinary quality through *testing at scale*, not through formal proofs. seL4 achieves it through *proofs of a tiny kernel*, not proofs of a large system.

DNA Calc's path to "alien artifact" is: **build a small, excellent engine and verify it thoroughly**, not **plan a large, comprehensive system and verify it partially**.

---

## 11. Provocations (de Bono Po Operations)

These are deliberately wrong or extreme statements, used for their *movement value* -- to challenge assumptions and generate new ideas.

### Po: DNA Calc has no UI

What if DNA Calc never had a user interface? A spreadsheet engine as a service, accessed only through APIs. Other applications build UIs on top of it. The engine is the product; the grid is someone else's problem.

**Movement**: This reframes DNA Calc from "Excel competitor" to "Excel infrastructure provider." The market for embeddable spreadsheet engines is smaller but far less competitive. And the engine is where all the hard, differentiating work lives anyway.

### Po: DNA Calc uses Excel as its own test oracle

Instead of building an OCaml oracle, use Excel itself (via COM automation or Office Scripts) as the reference oracle. Feed the same inputs to DNA Calc and Excel, compare outputs. The oracle already exists.

**Movement**: This eliminates the need for an OCaml oracle while providing much stronger compatibility evidence. It's clean-room compatible because you're observing *behavior*, not reading *code*. The evidence workflow already supports "OBS" (reproducible observation) as an evidence class.

### Po: There is only one implementation, and it is rewritten every round

Instead of Rust AND .NET, write the engine once in Round 0, then rewrite it from scratch in Round 1 using lessons learned. The rewrite validates the spec. Then rewrite again in Round 2. Each rewrite is faster because the spec is better.

**Movement**: This preserves the "independent confirmation" benefit of dual engines but uses temporal diversity instead of language diversity. Each rewrite forces the spec to be complete enough to write from. The final implementation (Round 3) benefits from three previous attempts.

### Po: The formal methods ARE the product

What if DNA Calc's commercial offering is not a spreadsheet but a formal specification of spreadsheet semantics? Sell the spec, the proofs, and the conformance test suite to spreadsheet implementers (LibreOffice, Gnumeric, Google, etc.). Become the W3C of spreadsheet semantics.

**Movement**: This inverts the relationship between spec and implementation. The spec becomes the revenue source; implementations are validation of the spec. This would be genuinely unique in the spreadsheet industry and could establish DNA Calc as the authority on spreadsheet correctness.

### Po: DNA Calc competes with Python, not Excel

Most "spreadsheet problems" that push Excel's limits (100K+ rows, complex calculations, reproducibility) are already migrating to Python/pandas. What if DNA Calc is the thing between Excel and Python -- a spreadsheet with programmatic semantics, deterministic computation, and formal guarantees, targeting data scientists who have outgrown Excel but find Python too low-level?

**Movement**: This shifts the competitive landscape entirely. Instead of matching Excel feature-for-feature (impossible), DNA Calc offers something Excel can never offer: provable correctness, deterministic computation, and seamless programmatic access. The target user is not the Excel power user but the data scientist who is frustrated with both Excel and Jupyter notebooks.

### Po: Round 0 ships in 30 days or the project is cancelled

What if the project had an absolute, non-negotiable deadline of 30 days to produce a working demo? What would be cut?

**Movement**: This forces ruthless prioritization. The answer is probably: one language (Rust), one command (evaluate a .csv file of formulas), one test (compare output to expected values), zero UI, zero file format support beyond CSV, zero formal proofs. And that would be enough. It would be a *working thing* that could grow.

---

## 12. Concrete Recommendations Hierarchy

### Tier 1: Do Immediately (This Week)

1. **Write code.** Implement a Rust function that evaluates `=A1+1` given a cell map. This is the seed crystal. Everything else grows from this.

2. **Define the minimum demonstrable product.** In one sentence: "A Rust crate that evaluates a grid of formulas deterministically and produces epoch-tagged results." Not a spreadsheet. Not a UI. Not a file format. A *calculation engine*.

3. **Cut the dual engine.** Build in Rust only. The .NET engine is a Round 2+ concern. The savings in effort are enormous.

4. **Cut Lean proofs for now.** TLA+ for concurrency invariants: yes. Lean for formula semantics: defer to after the engine exists and you know what the semantics actually are.

5. **Cut the OCaml oracle.** Use Rust property-based tests and Excel observation harnesses for conformance. The oracle is a separate project's worth of effort.

### Tier 2: Do Within 30 Days

6. **Implement the epoch model.** committed_epoch, stabilized_epoch, value_epoch, stale/pending/fresh status. This is the crown jewel of the architecture and should exist early.

7. **Implement deterministic mode with trace replay.** This is the foundation for all future testing and verification. Without it, nothing else can be trusted.

8. **Write the first TLA+ model.** The documents already have an excellent design (prompt response 03). Implement Tier 0/Tier 1 as described: 2 cells, 1 worker, 2 epochs, safety invariants only.

9. **Establish the test-to-code ratio metric.** Track it from day one. Target 10x within 90 days.

10. **Define the target market.** Who will pay for this? Why? How much? The answer to this question determines everything else.

### Tier 3: Do Within 90 Days

11. **Ship the Rust crate.** A published crate on crates.io that can evaluate spreadsheet formulas. Even with 20 functions and no Excel compatibility, this is a real product.

12. **Add property-based testing and fuzzing.** Follow SQLite's model: test the engine with random inputs at scale.

13. **Add basic .xlsx read support.** Use an existing Rust OOXML parser. Don't write your own.

14. **Begin the Excel observation harness.** Automate the process of feeding inputs to Excel and capturing outputs. This replaces the OCaml oracle and provides much better compatibility evidence.

15. **Publish the TLA+ model.** Make it open-source. Invite review. This establishes DNA Calc's formal methods credibility with zero implementation risk.

### Tier 4: Do Within 6 Months

16. **Add the UI.** Tauri + Canvas grid, following the existing design. Start with read-only viewing of computed results.

17. **Expand formula coverage.** Target 100+ Excel-compatible functions. Gnumeric achieved full coverage; this is tractable.

18. **Begin Lean formalization** of core semantics, now informed by implementation experience.

19. **Consider the .NET engine** if there is a specific commercial need. Otherwise, keep it deferred.

20. **Evaluate the market response** and adjust strategy accordingly.

### Tier 5: Long-Term (6-24 Months)

21. **Scale the formal verification** based on what the implementation reveals.
22. **Add collaboration** following the OpLog replication design.
23. **Add .xlsx write support** with the degradation diagnostics.
24. **Consider the .NET engine** for independent validation.
25. **Target "alien artifact" quality** through sustained testing investment.

---

## 13. The Verdict

DNA Calc's foundation documents describe one of the most intellectually ambitious spreadsheet projects ever conceived. The architecture is sound, the formal methods strategy is well-researched, the clean-room discipline is exemplary, and the process infrastructure is sophisticated.

But the project is currently a **cathedral being designed in the sky**. The blueprints are extraordinary. The cathedral does not exist. And the blueprints are so detailed that they may prevent the cathedral from ever being built, because no first stone can be laid until the blueprints are complete -- and the blueprints will never be complete because there is always one more research run to conduct, one more synthesis pass to execute, one more doctrine point to refine.

**The diagnosis**: The project needs to invert its order of operations. Instead of "plan completely, then build perfectly," it needs "build roughly, then verify ruthlessly." Every "alien artifact" in software history was built this way. Not one of them was designed this way.

**The prescription**:
1. Write code this week
2. Ship a crate this quarter
3. Verify what you've built, not what you've planned
4. Let implementation feedback reshape the architecture
5. Build the testing/verification infrastructure incrementally, following SQLite's 25-year model
6. Keep the excellent architecture documents as a north star, not as prerequisites

The potential is extraordinary. The architecture is right. The formal methods strategy is appropriate (if scoped correctly). The clean-room discipline is robust. The profile/degradation system is innovative. The epoch model is beautiful.

All of this can be preserved while reversing the order of operations. Build first. Verify second. Document third. The documentation and verification will be *better* because they will be grounded in implementation reality rather than theoretical planning.

**The final test**: One year from now, will DNA Calc be (a) a collection of documents describing a spreadsheet, or (b) a working spreadsheet with formal properties? The answer depends entirely on whether the next commit to this repository is a markdown file or a Rust file.

---

*This review was commissioned as an independent assessment. All criticism is offered constructively and with genuine respect for the ambition and intellectual depth of the project. The author believes DNA Calc has the potential to be genuinely extraordinary -- if it escapes the gravity well of its own documentation.*

---

**Supporting annexes in `notes/review/`:**
- `precedents.md` -- Detailed historical precedent analysis
- `market_landscape.md` -- Spreadsheet market and technology landscape
- `formal_methods_reality.md` -- Formal methods cost/benefit analysis
- `alternative_architectures.md` -- Detailed alternative direction explorations
