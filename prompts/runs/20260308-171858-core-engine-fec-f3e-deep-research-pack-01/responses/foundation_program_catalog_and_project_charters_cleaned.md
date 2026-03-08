# Foundation Program Catalog, Component Boundaries, and Project Charters  
## Cleaned Draft for Foundation Integration

**Status:** synthesis candidate / cross-repo handoff draft  
**Audience:** Foundation, DnaVisiCalc, OxVba, OxFunc, OxFml, OxCalc, and host project maintainers  
**Authority model:** this document is intended to seed Foundation source-of-truth updates; it is not itself source-of-truth until promoted through Foundation synthesis

---

## 1. Purpose

This document expands the current repo and project catalog into a Foundation-facing program map that is simpler than the earlier draft and intentionally less architecturally specific.

It is written to do six things:

1. clarify the relationship between **Foundation doctrine**, **component repos**, and **host applications**;
2. describe a cleaner direct mapping between repos and the preparatory host sequence now envisioned;
3. define the ownership split for **OxVba**, **OxFunc**, **OxFml**, and **OxCalc**;
4. give detailed charter guidance for the new projects that are about to start;
5. provide reusable charter boilerplate for repo-level and host-level `CHARTER.md` files;
6. make it easy to update Foundation `README.md`, `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `OPERATIONS.md` without preserving more staging complexity than is useful.

This draft keeps **DnaVisiCalc** in its important historical and empirical role, but treats the next work as a clearer family of sibling repos and host projects. That is consistent with Foundation’s current distinction between source-of-truth doctrine and pathfinder evidence, and with the existing lane split around formula grammar/binding, function semantics, and host/model responsibility. fileciteturn5file2L1-L6 fileciteturn5file8L26-L30

---

## 2. Architectural baseline assumed by this document

This document assumes only the architectural baseline that is already required by the rest of the program, and deliberately avoids locking in a more precise core-engine design than is needed here.

The minimum baseline assumed is:

- Foundation remains the doctrine, architecture, and operations authority; fileciteturn5file13L3-L5
- all persistent mutations remain operation-driven; hidden mutation paths are forbidden; fileciteturn5file4L8-L11 fileciteturn5file12L53-L56
- the system keeps a strict boundary between single-node formula evaluation and multi-node calculation policy; fileciteturn5file12L41-L50
- unsupported constructs must degrade explicitly and deterministically rather than crash; fileciteturn5file4L1-L7
- dynamic dependencies, invalidation classes, cycle behavior, and replayability are first-class concerns that the architecture must surface explicitly; fileciteturn5file7L9-L18 fileciteturn5file14L1-L10
- formalization seams and shared trace/evidence discipline remain mandatory. fileciteturn5file11L22-L25 fileciteturn5file15L36-L58

This means the document does **not** require Foundation to accept one exact concurrency or overlay shape right now. It only assumes the already-established need for:

- an explicit single-node evaluator seam,
- an explicit multi-node core engine,
- replayable and versioned contracts between them,
- a structure that can evolve from simpler hosts toward the later full spreadsheet program.

---

## 3. Authority and precedence model

### 3.1 Foundation authority remains unchanged

This draft does not replace the current authority stack. The intended precedence remains:

1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. retained research/synthesis notes
5. brainstorm or lane-local proposal notes

That matches current Foundation operations guidance. fileciteturn5file8L38-L44

### 3.2 DnaVisiCalc remains a pathfinder and evidence source

DnaVisiCalc remains important as:

- the early executable pathfinder,
- a source of seam evidence,
- a source of lessons and synthesized observations,
- a practical precursor to the cleaner repo split now being adopted.

But it is **not** treated here as the long-term ownership home for the future evaluator lane or core engine lane.

### 3.3 What this document is allowed to do

This document may:

- define proposed repo and host boundaries,
- define proposed charters for the new projects,
- define how those repos fit together,
- propose Foundation edits.

It may not silently change:

- Foundation doctrine,
- clean-room rules,
- conformance/pack discipline,
- protocol versioning expectations,
- the conceptual split already described in Foundation between formula/bind semantics, function semantics, and host/model responsibility. fileciteturn5file12L41-L50

---

## 4. Program taxonomy: simplified repo and host map

The earlier draft distinguished rounds, repos, lanes, and hosts. For current planning, that is more elaborate than needed.

This cleaned version uses a simpler model:

- **Foundation** is the doctrine and architecture authority.
- **Component repos** own reusable lanes of implementation/specification.
- **Host repos** are the preparatory applications used to prove those lanes in increasingly realistic combinations.

### 4.1 Component repos

The relevant component repos are:

- **Foundation** — doctrine, architecture, operations, formal model framing, conformance expectations
- **DnaVisiCalc** — historical/empirical pathfinder
- **OxVba** — VBA compiler/runtime and hosting surface
- **OxFunc** — value types, function profiles, and function catalog universe
- **OxFml** — formula language, formula services, single-node evaluator seam, formatting/criteria language rules
- **OxCalc** — multi-node core calculation engine

### 4.2 Host repo progression

The main preparatory host progression is:

1. **DNA VbCalc** — independent OxVba host path
2. **DNA OneCalc** — single-node formula/function host
3. **DNA TreeCalc** — multi-node tree-structured calculation host
4. **DNA PreCalc** — first host with full tree/grid-hybrid scope

These hosts form the direct proving sequence for the next generation of work.

### 4.3 Later host progression placeholders

Two further host/product stages are acknowledged, but not chartered here:

- **DNA SuperCalc** — later high-performance / high-feature refinement of DNA PreCalc scope
- **DNA Calc** — the ultimate project target

These are intentionally kept light in this document.

### 4.4 Stable interpretation rule

Use this as the interpretation rule for planning and documentation:

> **Component repos own reusable lanes. Host repos prove those lanes in a practical sequence. Foundation owns doctrine and cross-lane rules.**

---

## 5. Component repo ownership map

### 5.1 Foundation

**Role:** doctrine, architecture framing, formal model framing, conformance/pack obligations, operations mechanics, cross-repo handoff rules

**Owns:**
- mission and doctrine,
- architecture and requirement text,
- operations rules and gates,
- formal-model framing,
- handoff format,
- profile and evidence discipline,
- conformance promotion rules.

**Does not own:**
- primary lane implementations,
- local implementation detail unless promoted,
- repo-local experimental notes as standing doctrine.

### 5.2 DnaVisiCalc

**Role:** pathfinder and evidence source

**Owns:**
- pathfinder realizations,
- seam evidence from the early implementation path,
- empirical artifacts and design lessons that may feed Foundation synthesis.

**Does not own long-term:**
- permanent ownership of the future evaluator lane,
- permanent ownership of the future core engine.

### 5.3 OxVba

**Role:** VBA compiler/runtime and VBA host-integration lane

**Owns:**
- VBA parser/compiler/runtime,
- VBA execution model,
- host interop surface for VBA,
- VBA UDF and macro execution behavior,
- future workbook-host bridges needed for VBA integration.

**Does not own:**
- OxFunc value/function semantics,
- OxFml formula-language parsing/binding,
- OxCalc scheduler/core-engine behavior.

**Important dependency rule:** OxVba does **not** depend on OxFunc or OxFml. It is an independent lane. That matches the user’s intended program split and keeps the VBA path cleanly separable.

### 5.4 OxFunc

**Role:** value universe, function catalog, and per-function semantic/profile owner

**Owns:**
- value-type definitions and semantics,
- coercion/result algebra assigned to the value/function universe,
- function catalog,
- per-function metadata and property schemas,
- calculation/interaction property profiles,
- Lean/Rust formalization of value and function semantics.

**Does not own:**
- formula parsing and binding,
- document structure,
- scheduler policy,
- VBA runtime,
- host application behavior.

### 5.5 OxFml

**Role:** formula language and single-node evaluator lane

**Owns:**
- formula grammar,
- lexer, parser, AST, binder, language services,
- formula-language-specific reference forms and bind outputs,
- single-node execution contracts,
- evaluation context definitions,
- formula-language-specific formatting and criteria semantics,
- conditional-format criteria evaluation rules,
- the evaluator-side seam used by the core engine.

**Does not own:**
- global multi-node scheduling,
- persistent document structure,
- structural graph ownership across the whole host,
- VBA runtime,
- canonical function/value semantics already assigned to OxFunc.

### 5.6 OxCalc

**Role:** multi-node core calculation engine

**Owns:**
- multi-node calculation policy,
- document-structure-side engine behavior,
- invalidation and dependency maintenance,
- scheduling and stabilization,
- commit/publication policy at multi-node scope,
- structural rewrite handling,
- the substrate-specific realization needed first for tree hosts and later for tree/grid-hybrid hosts.

**Does not own:**
- formula parsing,
- authoritative function semantics,
- VBA runtime,
- UI,
- file adapters.

---

## 6. Cross-repo dependency graph

The intended dependency graph should stay as close to acyclic as possible.

### 6.1 Component-level dependency rules

- **Foundation** sits above the program as doctrine/spec authority.
- **OxVba** is an independent lane and should remain dependency-light.
- **OxFunc** is semantically foundational and should remain dependency-light.
- **OxFml** depends on **OxFunc**.
- **OxCalc** depends on **OxFml** and **OxFunc**.

### 6.2 Host-level dependency rules

- **DNA VbCalc** depends only on **OxVba**.
- **DNA OneCalc** depends on **OxFml** and **OxFunc**, with **OxVba** optional where VBA/UDF integration is desired.
- **DNA TreeCalc** depends on **OxCalc**, **OxFml**, and **OxFunc**, with **OxVba** as an optional later integration.
- **DNA PreCalc** depends on **OxCalc**, **OxFml**, and **OxFunc**, and may later integrate **OxVba** according to host needs.
- **DNA SuperCalc** and **DNA Calc** are acknowledged later hosts/products, but dependency detail is intentionally left light here.

### 6.3 General dependency direction rules

#### Rule 1 — OxFunc remains reusable below any one host
OxFunc should not depend on OxFml, OxCalc, or OxVba.

#### Rule 2 — OxVba remains independent
OxVba should not be forced into dependency on the spreadsheet formula/value lanes unless a later adapter layer is intentionally introduced outside the OxVba core.

#### Rule 3 — OxFml remains replaceable
OxCalc should depend on stable evaluator contracts from OxFml, not on deep OxFml internals that would make replacement impossible.

#### Rule 4 — OxCalc must not absorb language ownership
Anything making OxCalc specific to one formula language should be pushed upward into OxFml or OxFunc.

#### Rule 5 — host repos compose lanes but do not become doctrine owners
Host applications prove and integrate lanes. They do not redefine Foundation doctrine.

---

## 7. Integration rules for the lane split

This section stays intentionally general.

### 7.1 Single-node vs multi-node boundary

A concern belongs to **OxFml** when it is about:

- formula syntax,
- formula parsing,
- formula binding,
- single-node evaluator context,
- evaluator-visible dependency observation,
- evaluator-visible formatting/criteria semantics,
- node-local result packages and diagnostics.

A concern belongs to **OxCalc** when it is about:

- multi-node structure,
- dirty propagation,
- scheduling,
- invalidation closure,
- cross-node publication,
- stabilization,
- host-wide dependency maintenance,
- substrate evolution from tree to tree/grid hybrid.

This remains consistent with the current Foundation lane split for grammar/parse/bind, function semantics, and host/model responsibility. fileciteturn5file12L41-L50

### 7.2 Persistent truth vs derived calculation state

Foundation already requires operation-driven mutation and forbids hidden mutation pathways. fileciteturn5file4L8-L11 fileciteturn5file12L53-L56

For this document, that is enough to establish the practical rule:

- single-node evaluators may discover information needed by calculation,
- but multi-node engine state and persistent host structure remain under OxCalc/host authority,
- and no lane may quietly bypass the explicit core contracts.

### 7.3 Profile/version ownership rule

- Foundation owns doctrine for profiles and version treatment. fileciteturn5file13L26-L38
- OxFunc owns function/value profile content.
- OxFml owns formula-language-specific profile binding and evaluator-facing interpretation.
- OxCalc consumes profile decisions in multi-node calculation policy.
- Host repos select and expose profiles; they do not define doctrine.

### 7.4 VBA integration rule

VBA runtime behavior lives outside the core calculation engine. Foundation’s formal model already treats VBA/macro hosts as non-core layers that feed the core through explicit pathways. fileciteturn5file14L84-L89

That means:

- OxVba remains its own lane,
- host repos decide whether and how to integrate OxVba,
- such integration must still respect explicit mutation/replay discipline.

---

## 8. Host progression and intended role of each host

## 8.1 DNA VbCalc — independent VBA host path

DNA VbCalc is the independent host used to exercise OxVba in a controlled environment.

Its role is to:

- prove OxVba host interaction,
- exercise VBA functions and subroutines in a small host,
- harden the VBA lane without waiting for the formula or core-engine lanes.

It is intentionally independent of OxFunc, OxFml, and OxCalc.

## 8.2 DNA OneCalc — single-node formula/function host

DNA OneCalc is the first host in the main spreadsheet-oriented path.

Its role is to:

- prove OxFml as a serious formula/evaluator lane,
- prove OxFunc function/value semantics in a real host,
- optionally integrate OxVba for UDF and subroutine hosting,
- avoid multi-node and reference-graph complexity.

## 8.3 DNA TreeCalc — first serious multi-node host

DNA TreeCalc is the first host that makes OxCalc real.

Its role is to:

- prove the multi-node core on a tree substrate,
- validate invalidation, scheduling, replay, and stabilization,
- support relative/global references in tree space,
- validate dynamic dependency and external update behavior before the full grid arrives.

## 8.4 DNA PreCalc — first full tree/grid-hybrid host

DNA PreCalc is the first host intended to carry the full tree/grid-hybrid scope.

Its role is to:

- introduce the first complete host with grid support on top of the OxCalc lane,
- integrate the spreadsheet-oriented lanes into a true pre-product host,
- become the immediate precursor to later refinement and eventual product realization.

## 8.5 Later host/product placeholders

### DNA SuperCalc
Not scoped yet. No charter here. Treated only as a later refinement stage over DNA PreCalc scope.

### DNA Calc
Not scoped yet. No charter here. Treated only as the true long-term project target.

---

## 9. Detailed charter: OxFml

### 9.1 Charter status
**Type:** new component repo charter guidance  
**Priority:** immediate  
**Depends on:** Foundation, OxFunc, current seam evidence from DnaVisiCalc  
**Enables:** DNA OneCalc, DNA TreeCalc, DNA PreCalc

### 9.2 Mission

OxFml is the Rust-based formula language and single-node evaluator lane for the DNA Calc program. It owns the spreadsheet-formula world from the perspective of one formula-bearing node: grammar, parse, bind, node-local execution contracts, evaluator context, formula-specific formatting/criteria rules, and the evaluator-side seam consumed by the multi-node core.

### 9.3 Core responsibility statement

OxFml is responsible for answering:

> “Given one formula-bearing node, its formula-language context, its bind environment, and the relevant evaluator capabilities, what does this node mean and what result package does it produce?”

### 9.4 In scope

- lexical analysis,
- parsing,
- AST and syntax services,
- binder and normalized reference outputs,
- formula diagnostics,
- language services,
- evaluation request/response model for a single node,
- evaluator-visible dependency observations,
- formatting and criteria languages specific to the formula world,
- conditional-format criteria evaluation logic,
- formula-language-specific profile behavior,
- integration with OxFunc for function calls and value semantics.

### 9.5 Out of scope

- global document structure,
- multi-node scheduling,
- host-wide dirty propagation,
- structural graph ownership across the document,
- VBA runtime implementation,
- authoritative function/value semantics already assigned to OxFunc,
- UI and file adapters.

### 9.6 Relationship to OxFunc

OxFml consumes OxFunc’s value and function universe.

Practical rule:

- if the issue is about **how a function is expressed, bound, surfaced, or invoked from the formula language**, it belongs to OxFml;
- if the issue is about **what the function means**, it belongs to OxFunc.

### 9.7 Relationship to OxCalc

OxFml exposes the single-node evaluator seam that OxCalc drives.

Practical rule:

- OxFml emits node-local meaning and evidence,
- OxCalc owns host-wide calculation policy.

### 9.8 Required early milestones

#### OXFML-1 — canonical seam draft
Produce the first OxFml-local canonical version of:
- evaluator contract types,
- result package shape,
- diagnostics and rejection taxonomy,
- trace schema,
- capability/profile integration notes,
- core seam scenarios.

#### OXFML-2 — no-reference profile
Support the formula-language surface required by DNA OneCalc, including explicit diagnostics for constructs outside that profile.

#### OXFML-3 — tree-reference profile
Define the formula-language profile used by DNA TreeCalc.

#### OXFML-4 — grid-reference profile
Define the formula-language profile intended for DNA PreCalc and later hosts with tree/grid-hybrid scope.

### 9.9 Required artifacts

- repo-level `CHARTER.md`,
- `ARCHITECTURE.md` or equivalent,
- evaluator seam draft spec,
- conformance matrix,
- trace schema docs,
- managed-run handoff records when proposing Foundation text,
- minimized seam regressions,
- capability/profile manifest fragments.

### 9.10 Non-goals for the first OxFml phase

- solving global concurrency,
- owning host structure,
- becoming a full spreadsheet host,
- becoming a macro runtime.

### 9.11 Definition of success

OxFml is successful when:

- DNA OneCalc becomes a strong proving ground for it,
- DNA TreeCalc can consume it without forcing OxCalc to own formula semantics,
- DNA PreCalc can later consume it as the spreadsheet-formula lane,
- Foundation can treat OxFml as the practical home of formula-language and single-node evaluator work.

---

## 10. Detailed charter: OxCalc

### 10.1 Charter status
**Type:** new component repo charter guidance  
**Priority:** immediate  
**Depends on:** Foundation, OxFml, OxFunc  
**Enables:** DNA TreeCalc, DNA PreCalc

### 10.2 Mission

OxCalc is the Rust implementation lane for the multi-node core engine defined by Foundation. It owns the document-structure side of calculation: dependency maintenance, invalidation, scheduling, stabilization, publication, and substrate-specific host evolution.

### 10.3 Core responsibility statement

OxCalc is responsible for all semantics that live **above the single-node evaluator** and **below the full host application layer**.

### 10.4 In scope

- multi-node calculation policy,
- operation-driven structural evolution,
- host-wide dependency maintenance,
- invalidation and dirty propagation,
- scheduling,
- cycle handling integration,
- replay and publication behavior,
- substrate realization first for tree hosts and later for tree/grid-hybrid hosts,
- explicit support for later formalization and evidence generation.

### 10.5 Out of scope

- formula parsing,
- binder internals,
- authoritative function semantics,
- VBA runtime,
- UI,
- file adapters,
- COM automation surface.

### 10.6 Initial implementation target

The first serious OxCalc target should be the smallest meaningful multi-node substrate that still exercises core-engine responsibilities. In practice, that means a tree substrate suitable for DNA TreeCalc before the full tree/grid-hybrid host arrives.

### 10.7 Relationship to OxFml

OxCalc drives OxFml as the node evaluator lane. It should know as little as possible about formula-language internals.

### 10.8 Required early milestones

#### OXCALC-1 — core engine contract draft
Define the OxCalc-local canonical form of:
- multi-node state model,
- dependency/invalidation model,
- scheduling/publication concepts,
- change/replay artifact surfaces,
- host integration contracts.

#### OXCALC-2 — tree substrate
Implement the first usable tree substrate for DNA TreeCalc.

#### OXCALC-3 — dynamic dependency and invalidation lane
Support host-wide dependency/invalidation behavior beyond the static trivial case.

#### OXCALC-4 — concurrent coordinator pilot
Add explicit coordination rules suitable for later scale-up.

#### OXCALC-5 — tree/grid-hybrid substrate
Expand the substrate to support DNA PreCalc.

### 10.9 Required artifacts

- repo-level `CHARTER.md`,
- `ARCHITECTURE.md`,
- state model/type schema docs,
- scheduler/invalidation docs,
- replay/change artifact docs,
- managed-run handoff records back to Foundation,
- minimized regression corpus.

### 10.10 Non-goals for the first OxCalc phase

- immediate full worksheet parity,
- file interop breadth,
- full VBA hosting,
- forcing the full grid into the first proving step,
- hiding uncertainty rather than tagging it explicitly.

### 10.11 Definition of success

OxCalc is successful when:

- DNA TreeCalc becomes a convincing first multi-node host,
- the tree/grid-hybrid expansion to DNA PreCalc feels evolutionary,
- Foundation can treat OxCalc as the practical home of core-engine implementation work.

---

## 11. Detailed charter: DNA VbCalc

### 11.1 Charter status
**Type:** light host pointer  
**Priority:** independent path / optional timing  
**Depends on:** OxVba only

### 11.2 Mission

DNA VbCalc is the small host used to exercise OxVba in a controlled environment where VBA can call host functions and the host can call VBA-defined code.

### 11.3 Program role

DNA VbCalc is intentionally separate from the spreadsheet-formula and core-engine path. Its job is to mature the OxVba lane without forcing early coupling.

### 11.4 In scope

- load and run VBA projects,
- call VBA procedures and functions,
- host/VBA interaction experiments,
- small deterministic regression fixtures for the VBA host surface.

### 11.5 Out of scope

- formula-engine ownership,
- core-engine ownership,
- becoming a spreadsheet host,
- becoming an umbrella integration application.

### 11.6 Foundation-facing rule

When DNA VbCalc reveals behavior that materially affects replay, mutation pathways, or later host integration, those implications should be handed back to Foundation through normal handoff discipline. fileciteturn5file3L39-L48

---

## 12. Detailed charter: DNA OneCalc

### 12.1 Charter status
**Type:** new host repo charter guidance  
**Priority:** immediate  
**Depends on:** OxFml, OxFunc  
**Optional dependency:** OxVba

### 12.2 Mission

DNA OneCalc is an Excel-compatible single-node calculator and testbed host. It exists to exercise formula language, value/function semantics, diagnostics, display behavior, and optional VBA/UDF integration without requiring a multi-node structure or reference engine.

### 12.3 Core idea

DNA OneCalc is “Excel if only a single cell or defined name existed.”

### 12.4 In scope

- formula entry,
- formula parsing/binding/evaluation through OxFml,
- function semantics through OxFunc,
- no-reference formula compatibility behavior,
- explicit diagnostics for unsupported reference-bearing constructs,
- persistence/reload of formula and host state,
- optional VBA project loading and UDF invocation through OxVba,
- regression fixtures for single-node behavior.

### 12.5 Out of scope

- reference resolution across a host graph,
- multi-node invalidation,
- graph scheduling,
- structural rewrites,
- tree/grid host behavior,
- being the eventual spreadsheet product.

### 12.6 Why this host matters

DNA OneCalc gives a low-complexity but real proving ground for OxFml and OxFunc, and optionally for early OxVba integration, before OxCalc is ready.

### 12.7 Required milestones

#### ONECALC-1 — formula workbench
Support formula entry, result display, diagnostics, profile visibility, and save/load.

#### ONECALC-2 — function catalog validation host
Add function browsing, profile/property inspection, and targeted regression running.

#### ONECALC-3 — optional VBA host integration
Add VBA project load and UDF/procedure invocation where desired.

#### ONECALC-4 — preferred fast proving ground
Use DNA OneCalc as the preferred place to prove new formula-language behavior before pushing it into more complex hosts.

### 12.8 Required artifacts

- app charter,
- app architecture note,
- save/load format note,
- integration notes with OxFml/OxFunc/(optional) OxVba,
- regression corpus,
- managed-run evidence when behavior influences Foundation or lane docs.

### 12.9 Definition of success

DNA OneCalc is successful when:

- it becomes the fast proving ground for OxFml and OxFunc,
- optional VBA/UDF integration can be exercised without a full sheet/tree engine,
- no-reference compatibility can advance far before OxCalc is mature.

---

## 13. Detailed charter: DNA TreeCalc

### 13.1 Charter status
**Type:** new host repo charter guidance  
**Priority:** immediate after OxFml/OxCalc basic seams are usable  
**Depends on:** OxCalc, OxFml, OxFunc  
**Optional later dependency:** OxVba

### 13.2 Mission

DNA TreeCalc is an Excel-compatible tree-structure calculator that implements most of the intended engine model except the worksheet grid.

### 13.3 Core idea

DNA TreeCalc proves the core engine with a host structure that is multi-node, dependency-driven, and semantically interesting, while deliberately avoiding first-wave grid complexity.

### 13.4 Model

- the document is a hierarchical tree of nodes,
- each node has a stable identity and human-facing name,
- leaves may hold formulas and values,
- references may be relative or global in tree space,
- names are first-class,
- dynamic references, volatility, streaming, and external invalidation still exist where meaningful.

### 13.5 In scope

- hierarchical node structure,
- leaf formulas and calculated values,
- relative/global reference semantics in tree space,
- dirty propagation,
- dynamic dependencies where meaningful,
- invalidation classes,
- streaming/external topics where meaningful,
- cycle behavior,
- deterministic replay and change deltas,
- operation-driven mutations,
- persistence/reload of tree documents.

### 13.6 Out of scope

- worksheet-grid semantics,
- row/column insert/delete rewrite semantics,
- rectangular spill geometry as a primary substrate,
- full worksheet UX expectations.

### 13.7 Why DNA TreeCalc matters

DNA TreeCalc is the first host that truly validates OxCalc because it requires multi-node dependency semantics, global dirty propagation, scheduling, stabilization, replay, and explicit calculation policy without yet forcing every decision to be entangled with the grid.

### 13.8 Required milestones

#### TREECALC-1 — tree substrate and leaf evaluation
Support node creation, node naming, leaf evaluation, and value/state display.

#### TREECALC-2 — tree reference language
Support global references, relative tree references, and deterministic unresolved-reference diagnostics.

#### TREECALC-3 — full core behavior without grid
Support invalidation classes, cycles/iteration, external updates, dynamic dependency tracking, and replay bundles.

#### TREECALC-4 — concurrency and proving host
Support explicit advanced coordination behavior in a serious host.

#### TREECALC-5 — optional VBA bridge
Optionally support VBA UDF integration through OxVba.

### 13.9 Required artifacts

- app charter,
- app architecture note,
- tree reference model doc,
- persistence format doc,
- regression corpus,
- replay traces,
- performance fixtures relevant to tree workloads.

### 13.10 Definition of success

DNA TreeCalc is successful when:

- OxCalc’s first real host is convincing,
- most core-engine semantics are validated before the grid arrives,
- the later move to DNA PreCalc feels like substrate expansion rather than architectural replacement.

---

## 14. Detailed charter: DNA PreCalc

### 14.1 Charter status
**Type:** new host repo charter guidance  
**Priority:** after DNA TreeCalc establishes the first serious core host  
**Depends on:** OxCalc, OxFml, OxFunc  
**Optional later dependency:** OxVba

### 14.2 Mission

DNA PreCalc is the first host intended to carry the full tree/grid-hybrid scope for the next-generation spreadsheet engine.

### 14.3 Core idea

DNA PreCalc is the first host where the preparatory lanes come together in a genuinely spreadsheet-shaped host with grid support, while still remaining a preparatory program rather than the final project target.

### 14.4 In scope

- full tree/grid-hybrid host substrate,
- grid references and grid-aware formula behavior through OxFml,
- multi-node calculation through OxCalc,
- integration of the spreadsheet-oriented lanes into one serious host,
- explicit handling of structural rewrites, spill behavior, and grid-specific invalidation as the architecture matures,
- persistence/reload and replayability suitable for a serious proving host.

### 14.5 Out of scope

- assuming final product polish,
- collapsing component boundaries for convenience,
- treating preparatory implementation as the end-state project.

### 14.6 Required milestones

#### PRECALC-1 — first full host substrate
Stand up the first host with tree/grid-hybrid support.

#### PRECALC-2 — full spreadsheet-oriented formula profile
Support the grid-aware OxFml profile needed for the first full host.

#### PRECALC-3 — grid-aware core behavior
Support the OxCalc behavior required for grid-oriented structure and invalidation.

#### PRECALC-4 — integrated proving host
Become the main proving host for the first complete architecture combination.

### 14.7 Required artifacts

- app charter,
- app architecture note,
- host integration notes across OxCalc/OxFml/OxFunc/(optional) OxVba,
- replay/change corpus,
- grid-structure and rewrite behavior notes,
- managed-run handoff records for any Foundation-facing implications.

### 14.8 Definition of success

DNA PreCalc is successful when:

- it becomes the first serious full host with tree/grid-hybrid scope,
- it proves that the lane split survives contact with a real spreadsheet-shaped host,
- it forms a clean base for later DNA SuperCalc refinement and the eventual DNA Calc target.

---

## 15. Later host placeholders

### 15.1 DNA SuperCalc

Acknowledged only as a later, higher-performance and higher-feature refinement stage over DNA PreCalc scope. No charter here.

### 15.2 DNA Calc

Acknowledged only as the true long-term project target. No charter here.

---

## 16. Shared charter boilerplate guidance

This section is meant to be copied into each new repo-level or host-level `CHARTER.md` with project-specific substitutions.

### 16.1 Boilerplate background template

```md
# <PROJECT>.md — Charter

## 1. Purpose
<PROJECT> is a <component repo | host repo | product host> in the DNA Calc program.
It exists to own and advance <one-sentence ownership focus>.
It is developed under Foundation doctrine and must remain consistent with Foundation source-of-truth documents.

## 2. Relationship to Foundation
This project is not a doctrine owner.
Foundation remains the source of truth for mission, doctrine, architecture framing, operations rules, and cross-lane conformance expectations.
Any proposed normative change to Foundation must be routed through managed-run handoff records and synthesis.

## 3. Program role
This project’s role is:
- component role: <if applicable>
- host role: <if applicable>
- dependency position: <what it depends on / what it enables>

## 4. Ownership statement
This project owns:
- <owned area 1>
- <owned area 2>
- <owned area 3>

This project explicitly does not own:
- <excluded area 1>
- <excluded area 2>
- <excluded area 3>
```

### 16.2 Boilerplate doctrine template

```md
## 5. Governing doctrine inherited from Foundation

### 5.1 Spec-first
Behavior work is not done until spec, fixtures, and required evidence are updated.

### 5.2 Determinism-first
Deterministic modes, replay artifacts, and minimized regression cases are mandatory for behavior-sensitive work.

### 5.3 No hidden mutation
Persistent state changes must flow through the relevant explicit operation or contract model; no hidden side channels are allowed.

### 5.4 Versioned interfaces
Profiles, protocols, schemas, and trace formats are versioned. Breaking semantic changes require explicit version treatment.

### 5.5 Clean-room evidence discipline
Compatibility claims must rely only on admissible evidence:
- public documentation/specifications,
- published research,
- reproducible black-box observation.

### 5.6 Sequence-only planning
Plans must be expressed using priority, dependency, blockers, gates, and state transitions, not ETA promises.

### 5.7 Pack/gate discipline
“Exercised” behavior is not enough. Claims of readiness require the applicable pack results and emitted artifacts.

### 5.8 Cross-repo handoff discipline
Any proposed Foundation text or cross-lane normative contract must be accompanied by a managed-run handoff record containing:
- scope/profile bounds,
- exact candidate text,
- evidence/replay links,
- unresolved decisions and risk impact.
```

### 16.3 Boilerplate project-structure template

```md
## 6. In scope
- <item>
- <item>
- <item>

## 7. Out of scope
- <item>
- <item>
- <item>

## 8. Dependencies
Upstream:
- <repo/project>
- <repo/project>

Downstream / enabled projects:
- <repo/project>
- <repo/project>

## 9. Required artifacts
- CHARTER.md
- ARCHITECTURE.md
- managed-run handoff records where applicable
- minimized regression corpus
- schema and trace docs for any boundary contracts

## 10. Required packs / evidence orientation
- <pack or obligation area>
- <pack or obligation area>

## 11. Success criteria
- <criterion>
- <criterion>
- <criterion>
```

### 16.4 Boilerplate Foundation-consistency wording

Each charter should include a sentence equivalent to:

> “This project advances one lane or host of the DNA Calc program. It may own implementation and lane-local specification detail, but Foundation remains the source of truth for mission, doctrine, architecture framing, operations rules, and cross-lane conformance expectations.”

---

## 17. Cross-repo handoff rule for these lanes

Because the program is splitting across multiple repos, lane-to-Foundation handoffs become more important, not less.

Every repo that proposes Foundation-facing meaning changes should use the existing normative handoff shape:

1. scope and profile bounds,
2. proposed normative text,
3. evidence and replay links,
4. unresolved decisions and risk impact. fileciteturn5file3L39-L48

Suggested repo-local folder convention:

- `docs/foundation_handoffs/` or
- `docs/handshakes/`

---

## 18. Proposed Foundation doc adjustments

### 18.1 `README.md`

Add a section that:

- explains the difference between Foundation, component repos, and host repos;
- lists `OxVba`, `OxFunc`, `OxFml`, and `OxCalc` as active sibling component lanes;
- lists the host progression `DNA VbCalc`, `DNA OneCalc`, `DNA TreeCalc`, and `DNA PreCalc`;
- notes that `DNA SuperCalc` and `DNA Calc` are acknowledged later stages with lighter treatment for now.

### 18.2 `CHARTER.md`

Add a subsection under program structure clarifying:

- Foundation is the doctrine owner,
- component repos are Foundation, DnaVisiCalc, OxVba, OxFunc, OxFml, and OxCalc,
- host repos in the preparatory sequence are DNA VbCalc, DNA OneCalc, DNA TreeCalc, and DNA PreCalc,
- DNA SuperCalc and DNA Calc are acknowledged later targets but are not expanded here.

This cleanly replaces the need to explain current work mainly through round terminology. Existing named program principles and no-hidden-mutation doctrine remain unchanged. fileciteturn5file13L40-L44 fileciteturn5file4L8-L11

### 18.3 `ARCHITECTURE_AND_REQUIREMENTS.md`

Expand the current lane-boundary wording into a practical repo-mapping section that says:

- OxFunc owns value/function semantics,
- OxFml owns formula language and single-node evaluator semantics,
- OxCalc owns multi-node calculation policy,
- OxVba owns the VBA runtime lane,
- host repos consume these lanes in the preparatory progression.

This should preserve the existing conceptual split while making the repo map explicit. fileciteturn5file12L41-L50

### 18.4 `OPERATIONS.md`

Add guidance that:

- sibling repos may own lane-local specs and architecture docs, but Foundation remains the doctrine owner;
- host repos are proving grounds rather than doctrine owners;
- any repo proposing Foundation-facing behavior changes must emit handoff records in the existing normative shape;
- project planning should continue to use sequence-only planning language. fileciteturn5file15L60-L70

### 18.5 `CORE_ENGINE_FORMAL_MODEL.md`

Add a short note that:

- tree-first core work is a valid proving strategy for the core engine,
- later tree/grid-hybrid work belongs to the same architectural family,
- DNA TreeCalc and DNA PreCalc are host strategies, not separate doctrines.

That stays aligned with the current formal-model emphasis on deferred design choices, explicit uncertainty tagging, and non-core/layer interaction contracts. fileciteturn5file5L39-L45 fileciteturn5file14L60-L67

---

## 19. Dependency-based execution order

This uses sequence-only planning and avoids date language, consistent with Foundation operations. fileciteturn5file15L60-L70

### Wave A — repo/host map cleanup
**Priority:** highest

1. accept the simplified component-repo and host-repo taxonomy;
2. freeze the OxVba independence rule;
3. freeze the OxFunc/OxFml/OxCalc ownership split;
4. apply Foundation doc edits.

### Wave B — OxFml/OxFunc boundary hardening
**Depends on:** Wave A

1. define OxFml evaluator contracts;
2. align OxFunc/OxFml profile exposure rules;
3. define the no-reference and tree-reference profiles.

### Wave C — DNA VbCalc and DNA OneCalc
**Depends on:** Wave A, with OneCalc also depending on Wave B

1. use DNA VbCalc to advance OxVba independently;
2. use DNA OneCalc to advance OxFml/OxFunc and optional OxVba integration.

### Wave D — OxCalc tree substrate and DNA TreeCalc
**Depends on:** Wave B

1. build the first serious OxCalc substrate for tree calculation;
2. expose it through DNA TreeCalc;
3. validate multi-node behavior before grid complexity is introduced.

### Wave E — DNA PreCalc
**Depends on:** Wave D

1. introduce the first full tree/grid-hybrid host;
2. integrate the spreadsheet-oriented lanes in one serious preparatory host;
3. use it as the launch point for later refinement and the eventual full target.

---

## 20. Closing interpretation

The main simplification made by this document is deliberate:

- no elaborate round-vs-host distinction is needed for the immediate work,
- OxVba stays independent,
- the spreadsheet-oriented next-generation path is directly expressed through component repos plus the host sequence,
- and the core-engine architecture is stated only as precisely as the rest of the current program requires.

That should make this document easier to merge into Foundation and easier to use as the base for the next project charters.
