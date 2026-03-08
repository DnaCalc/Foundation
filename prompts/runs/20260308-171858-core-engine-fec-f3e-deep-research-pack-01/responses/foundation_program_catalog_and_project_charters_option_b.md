# Foundation Program Catalog, Component Boundaries, and New Project Charters  
## Option B–Aligned Draft for Foundation Integration

**Status:** synthesis candidate / cross-repo handoff draft  
**Audience:** Foundation, OxFml, OxCalc, OxFunc, OxVba, DnaVisiCalc, and host/pathfinder project maintainers  
**Authority model:** this document is intended to seed Foundation source-of-truth updates; it is not itself source-of-truth until promoted through Foundation synthesis

---

## 1. Purpose

This document expands the current repo and project catalog into a Foundation-facing program map that assumes the previously recommended **Option B** architecture is adopted: immutable structural truth, epoch-scoped runtime overlays, and the FEC/F3E transactional seam as the evaluator boundary.

It is meant to do five jobs at once:

1. clarify the relationship between **Foundation doctrine**, **lane/component repos**, and **host/pathfinder applications**;
2. give a precise ownership split for **OxFunc**, **OxFml**, **OxCalc**, and **OxVba** under the existing Foundation architecture;
3. define detailed charters for the new projects that are about to start;
4. provide reusable charter boilerplate so that individual repo-level `CHARTER.md` files can be generated consistently;
5. make it easy to update Foundation `README.md`, `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `OPERATIONS.md`, and `CORE_ENGINE_FORMAL_MODEL.md` without re-deciding the same boundaries.

This draft intentionally treats the current **DnaVisiCalc** codebase as a pathfinder and evidence source rather than the direct basis of the next-generation implementation. The Foundation docs already distinguish Round 0 pathfinder scope from later-round shaping, and explicitly say that beyond-minimum design/API artifacts from DnaVisiCalc are evidence inputs for Round 1 rather than substitutes for Foundation doctrine. The next generation therefore needs a cleaner lane split and a clearer project catalog than DnaVisiCalc alone provides.

---

## 2. Architectural baseline assumed by this document

This draft assumes the Foundation moves forward with the previously recommended target architecture:

- immutable `DocSnapshot[e]` as structural truth,
- mutable per-epoch `CalcArena[e]` for value cache, dirty state, runtime dependency overlay, spill overlay, display overlay, effective reverse maps, and trace buffers,
- `G_struct[e]` as structural dependency truth,
- `G_rt[e]` as runtime-observed dependency and topology overlay,
- `G_eff[e] = G_struct[e] ∪ G_rt[e]` as scheduler truth for the active epoch,
- per-node atomic commit bundles,
- FEC/F3E as the transaction seam between the core engine and the formula/function/format evaluator,
- visibility as a scheduler-priority concern only, never a semantic-result concern.

That baseline is the right fit for the current Foundation architecture because the existing docs already fix the hard boundaries around **OpLog**, **DocSnapshot**, and **CalcDeltas**, insist on immutable snapshots, operation-only persistent mutation, explicit stale/pending/value epochs, and a layered `S/R/D/V/O` formal model. The design synthesis also concluded that the best target is the layered MVCC option rather than either a purely conservative rebuild core or an overly ambitious multi-lane specialized engine. Dynamic dependencies, spill lifecycle, and formatting/visibility overlays were all called out as first-class concerns that must be separated rather than hidden inside a single mutable graph. The prior synthesis also concluded that the current FEC/F3E seam is good enough to carry forward, but only if snapshot/token fencing, spill invalidation algebra, and coordinator semantics are promoted to first-class Foundation architecture.

This document therefore treats **Option B** as the assumed basis for all charters below.

---

## 3. Authority and precedence model

### 3.1 Existing Foundation authority still stands

Nothing in this draft replaces the current authority stack. The intended precedence remains:

1. `CHARTER.md`
2. `ARCHITECTURE_AND_REQUIREMENTS.md`
3. `OPERATIONS.md`
4. retained synthesized notes / research notes
5. brainstorm or lane-local proposal notes

This draft is a **promotion candidate**, not a side-channel source of truth.

### 3.2 DnaVisiCalc remains authoritative only for Round 0 pathfinder scope

For **Round 0 functional scope**, Foundation already points to DnaVisiCalc docs as the authority. This remains correct. That means this draft does **not** rewrite Round 0 scope, and does **not** reinterpret DnaVisiCalc as the long-term architecture source.

Instead:

- **Foundation** owns doctrine, architecture framing, operations discipline, formal model framing, and cross-lane integration rules.
- **DnaVisiCalc** remains the key pathfinder evidence source for the current seam and pathfinder functional behavior.
- **New lane repos** take over future implementation ownership for the long-lived architecture.

### 3.3 What this document is allowed to do

This draft is allowed to:

- define proposed repo and project boundaries,
- define proposed charters for new projects,
- define how lane repos should hand material back to Foundation,
- define how Option B changes the component map.

It is **not** allowed to silently change:

- Foundation doctrine,
- Foundation round names,
- DnaVisiCalc Round 0 authority,
- clean-room rules,
- pack/gate discipline,
- the requirement that Red and Blue share identical protocol surfaces.

---

## 4. Program taxonomy: rounds, repos, lanes, and host applications

A major source of confusion is that the program currently mixes at least four different naming axes. This section separates them.

### 4.1 Axis A — Foundation round names

These names already exist in Foundation and should remain authoritative:

- **DnaVisiCalc** — Round 0 pathfinder
- **DnaPreCalc** — Round 1 first full end-to-end
- **DnaSuperCalc** — Round 2 refactor / perfection pass
- **DnaCalc** — Round 3 synthesized long-term product

These are **round / program-stage names**, not necessarily repo names.

### 4.2 Axis B — lane/component repos

These are the repos or long-lived component lanes that own separable parts of the architecture:

- **Foundation**
- **DnaVisiCalc**
- **OxVba**
- **OxFunc**
- **OxFml**
- **OxCalc**

These are **architecture/component ownership units**.

### 4.3 Axis C — host/pathfinder applications

These are product-shaped or tool-shaped hosts used to validate particular lanes:

- **DNA OneCalc**
- **DNA VbCalc**
- **DNA TreeCalc**
- **DNA Calc** (future full host/product)

These are **execution vehicles**, not doctrine owners.

### 4.4 Axis D — conceptual ownership lanes inside the architecture

The current architecture already distinguishes:

- formula grammar / parse / bind semantics,
- value and function semantics,
- host protocol / capability / dependency lifecycle / scheduler interaction / publication lifecycle,
- multi-node core engine structure and recalc.

This draft maps those conceptual lanes onto repos more explicitly.

### 4.5 Proposed rule to avoid naming drift

Use the following sentence as the stable interpretation rule:

> **Round names describe program stages; repo names describe long-lived component ownership; host names describe applications or testbeds built from those components.**

That one rule removes most of the ambiguity.

---

## 5. Proposed repo and ownership map

### 5.1 Foundation

**Role:** doctrine, architecture, formal model framing, conformance/pack obligations, operations mechanics, cross-repo handoff rules

**Owns:**
- mission and doctrine
- architecture and requirement text
- operations rules and gates
- core formal model story and promotion rules
- cross-repo handoff format
- pack contracts and conformance promotion logic
- reference corpus policy and empirical finding promotion rules

**Does not own:**
- primary production implementation of evaluator or core engine logic
- lane-specific code decisions unless promoted through synthesis
- ad hoc lane-local policies outside source-of-truth docs

**Key principle:** Foundation is the semantic constitution, not the implementation scratchpad.

### 5.2 DnaVisiCalc

**Role:** Round 0 pathfinder and empirical/reference implementation for early engine semantics and current FEC/F3E seam evidence

**Owns:**
- Round 0 functional scope realization
- executable seam evidence for the current FEC/F3E redesign
- pathfinder API and change-journal behavior
- experimental proof-of-shape work that feeds Foundation synthesis

**Does not own long-term:**
- the final repo boundaries for next-generation implementation
- permanent ownership of FEC/F3E specification
- permanent ownership of the future core engine

**Interpretation:** DnaVisiCalc stays historically and empirically important, but is not the intended long-lived landing zone for OxFml or OxCalc.

### 5.3 OxFunc

**Role:** value universe, function catalog, function semantics, and formal function/profile specification owner

**Owns:**
- value-type definitions and semantics
- coercion and result algebra where assigned to the value/function universe
- function catalog
- per-function metadata and property schemas
- function interaction and calculation property profiles
- conformance-facing function definitions and profile/version material for the supported function library
- Lean/Rust formalization of value and function semantics

**Should not own:**
- formula language parsing or binding
- document structure
- multi-node scheduling, invalidation, or publication policy
- workbook/tree/grid host semantics beyond what function signatures require

**Interpretation rule:** OxFunc owns the **what** of function and value semantics; OxFml owns the **how they are expressed and invoked in a specific formula language**.

### 5.4 OxFml

**Role:** spreadsheet-program-specific formula language, single-node evaluation engine, and FEC/F3E seam owner for that formula world

**Owns:**
- formula grammar
- lexer, parser, AST, binder, and language services
- formula-language-specific static reference forms and bind outputs
- evaluator-side execution model for a single cell/node
- FEC/F3E seam specification, evaluator contract, and trace schema for the formula lane
- evaluation context definitions needed for single-node execution
- formatting language(s) and formatting application logic that are formula-world specific
- conditional-format criteria evaluation logic
- spreadsheet-program-specific language behavior, including what makes one formula dialect/profile distinct from another

**Should not own:**
- the global multi-node scheduler
- immutable snapshot storage
- structural graph / reference-grid maintenance across the whole document
- document operation replay model
- collaboration sequencing
- final calc publication policy across nodes

**Important reconciliation with current Foundation wording:**  
The current Foundation architecture says that OxFml owns grammar/parse/bind semantics, OxFunc owns value/function semantics, and the FEC host/model lane owns host protocol, capability policy, dependency lifecycle, scheduler interaction, and publication lifecycle. The cleanest way to reconcile that with the intended OxFml repo plan is:

- **OxFml the repo** becomes the umbrella home for the formula-world seam and evaluator stack,
- but inside OxFml there must remain a distinct **FEC host/model sublane** whose contract stays explicitly separate from OxFml parser/binder and from OxFunc function semantics,
- and OxCalc remains the owner of global recalc policy even when OxFml hosts the seam definitions.

That gives a practical repo boundary without collapsing the conceptual boundary that Foundation already relies on.

### 5.5 OxCalc

**Role:** core multi-node calculation engine implementing the Foundation core model

**Owns:**
- immutable structural model materialization for the supported host substrate
- `DocSnapshot`
- `CalcArena`
- global dependency representation and scheduler-facing effective graph materialization
- invalidation closure and scheduler logic
- epoch and publish-fence management
- calc delta emission
- concurrency coordinator behavior
- structural rewrite handling
- dirty propagation and stabilization control
- integration of runtime dependency and spill deltas into global reverse maps
- future tree-grid-hybrid core implementation

**Should not own:**
- formula grammar or formula parsing
- low-level function semantics
- VBA compiler/runtime
- file format adapters
- UI

**Interpretation rule:** OxCalc owns **multi-node semantics and global execution policy**; OxFml owns **single-node evaluator semantics**.

### 5.6 OxVba

**Role:** VBA compiler/runtime and hosting surface for VBA-oriented execution outside the core engine

**Owns:**
- VBA parser/compiler/runtime
- VBA execution model and host interop surface
- VBA-specific UDF and macro execution behavior
- future bridges needed for workbook-host integration

**Does not own:**
- core calc scheduler
- generic function catalog
- spreadsheet formula parsing
- file-adapter preservation of VBA project blobs inside the core engine

**Interpretation rule:** VBA runtime is outside the core engine; the core stores the VBA project as a document object and macros/UDFs interact through explicit host operations or evaluator calls.

---

## 6. Cross-repo dependency graph

The intended dependency graph should be as close to acyclic as possible.

### 6.1 Core dependency rule

- **Foundation** sits above all repos as doctrine/spec owner.
- **OxFunc** should be dependency-light and semantically foundational.
- **OxFml** depends on **OxFunc**.
- **OxCalc** depends on **OxFml** and **OxFunc**.
- **OxVba** may depend on **OxFunc** for value interchange, and may optionally integrate with **OxFml** host contracts where formula/VBA bridging is needed.
- **DNA OneCalc** depends on **OxFml**, **OxFunc**, and **OxVba**.
- **DNA TreeCalc** depends on **OxCalc**, **OxFml**, and **OxFunc**, with **OxVba** as later optional integration.
- **DNA Calc** depends on **OxCalc**, **OxFml**, **OxFunc**, and **OxVba**, plus adapters and UI layers.

### 6.2 Dependency direction rules

#### Rule 1 — OxFunc must remain reusable below any one host
OxFunc should not depend on OxFml or OxCalc.

#### Rule 2 — OxFml must be replaceable as a spreadsheet-language layer
OxCalc should depend on an interface or profile surface from OxFml, not on OxFml internals that prevent replacement by a different formula language or value/function universe.

#### Rule 3 — OxCalc must not absorb formula-language ownership
Anything that makes OxCalc specific to one formula language or function universe should be pushed upward into OxFml or OxFunc.

#### Rule 4 — host applications may compose multiple lanes but must not become new doctrine owners
DNA OneCalc, DNA TreeCalc, and DNA Calc are proving grounds and products, not architecture constitutions.

---

## 7. Normative integration rules under Option B

This section is not a re-statement of Foundation architecture; it is the part that makes the new repo map coherent.

### 7.1 Single-node vs multi-node boundary

A formula/node evaluation belongs to **OxFml** when the question is:

- how the formula text is parsed,
- how names and references are bound from the node’s local context,
- how the evaluator negotiates capabilities for this node,
- what dependencies are observed during execution,
- what spill or formatting/conditional-format outputs are discovered from this node’s evaluation,
- what single-node commit payload is produced.

A calculation belongs to **OxCalc** when the question is:

- how the document is structured,
- what the active immutable snapshot is,
- how dirty state is formed and propagated,
- which ready nodes run next,
- how node commit payloads change reverse maps and queues,
- when conservative fallback is invoked,
- when `stabilized_epoch` advances,
- how partial publication is exposed through stale/pending/value-epoch semantics,
- how concurrent workers are coordinated safely.

### 7.2 Persistent truth vs derived caches

The existing Foundation boundary is decisive here:

- persistent structural truth lives in immutable snapshots,
- derived values and overlays are caches,
- all persistent mutation is operation-driven,
- evaluator commits must not mutate structural truth directly.

Therefore:

- OxFml may discover runtime-observed dependencies and spill events,
- but only OxCalc may merge those into the active calculation arena and global reverse maps for the epoch.

### 7.3 Profile/version ownership rule

- Foundation owns profile doctrine and versioning rules.
- OxFunc owns function/value profile content.
- OxFml owns formula-language-specific profile binding and evaluator-facing capability interpretation.
- OxCalc consumes profile decisions when executing recalc policy, invalidation classes, and scheduler policy.
- Host apps select or expose profiles; they do not define doctrine.

### 7.4 Formatting and visibility rule

Formatting-sensitive value semantics and visible-first priority handling remain special cases that must not infect the whole engine:

- **ambient style** is not a default formula-value dependency;
- explicit formatting-observable functions are profile-gated;
- visibility is scheduler metadata only.

That means:

- OxFml may define the evaluator-facing formatting tokens and criteria semantics,
- OxCalc may use visibility state for scheduling priority,
- but neither lane may silently turn visibility or ambient style into semantic value changes unless a profile explicitly says so.

### 7.5 Spill rule

Spill lifecycle is explicit and first-class:

- spill transitions are commit-time events,
- spill observer invalidation is required,
- selective invalidation may be used,
- conservative full or affected-scope fallback must remain available.

This is a joint contract:

- OxFml must emit precise spill evidence,
- OxCalc must apply that evidence safely to the global evaluation world.

---

## 8. Proposed mapping between repos and round progression

The current Foundation round names are still good, but the new repo map means that round execution will be distributed across lanes.

### 8.1 Proposed interpretation

#### Round 0 — DnaVisiCalc
Primary vehicle:
- DnaVisiCalc

Main outcome:
- prove the verification + meta-control loop
- exercise current seam and pathfinder scope
- leave behind evidence, artifacts, traces, and hard-won clarity

#### Round 1 — DnaPreCalc
Primary vehicles:
- OxFml
- OxCalc
- OxFunc
- DNA OneCalc
- DNA TreeCalc

Main outcome:
- first full end-to-end architecture using the lane split
- first serious tree-only OxCalc realization
- first clean host/testbed for OxFml outside DnaVisiCalc

#### Round 2 — DnaSuperCalc
Primary vehicles:
- OxCalc refinement
- OxFml refinement
- deeper proof/pack growth
- ambitious dynamic/incremental lanes where justified

Main outcome:
- remove design debt
- harden and simplify
- test ambitious improvements without rewriting doctrine

#### Round 3 — DnaCalc
Primary vehicles:
- full DNA Calc host/application
- mature OxCalc tree-grid-hybrid core
- complete lane integration

Main outcome:
- streamlined, maintainable long-term product

### 8.2 Important clarification

The host/project name **DNA Calc (Future)** should be treated as the **future full host/application/product expression** of the program, aligned with the existing Round 3 `DnaCalc` name, not as a second unrelated concept.

---

## 9. Detailed charter: OxFml

## 9.1 Charter status
**Type:** new lane/component repo charter guidance  
**Priority:** immediate  
**Depends on:** Foundation, OxFunc, current FEC/F3E seam evidence from DnaVisiCalc  
**Enables:** DNA OneCalc, DNA TreeCalc, DNA Calc, future alternative formula-language hosts

## 9.2 Mission

OxFml is the Rust-based formula language and single-node evaluation lane for DNA Calc. It owns the evaluator side of the spreadsheet formula world: grammar, parse, bind, node-local execution contracts, formula-specific context definitions, formatting/criteria languages, and the spreadsheet-program-specific evaluator seam used by the multi-node core.

OxFml exists to make formula-language semantics a **replaceable lane** rather than an inseparable part of the core engine. It is the layer that would be swapped out if the program later supported a different formula language, different reference rules, or a different value/function universe.

## 9.3 Core responsibility statement

OxFml is responsible for everything needed to answer the question:

> “Given one formula-bearing node, its formula-language context, its static bind environment, its evaluator capabilities, and the relevant host callbacks, what does this node mean, what does it observe, and what single-node result package does it produce?”

## 9.4 In scope

### Formula language
- lexical analysis
- parsing
- AST and syntax services
- binder and normalized reference outputs
- formula diagnostics
- formula identity/stable-id handling where required for the seam
- future language services such as formatting, help, explain, and profile-sensitive bind behavior

### Single-node evaluator model
- evaluation request/response model
- evaluator-side observation recording
- node-local capability requests
- dependency observation capture
- spill event emission
- formatting/token observation emission where profile requires it
- conditional-format criteria evaluation logic
- display-format mini-language and related criteria logic where that belongs to the formula world rather than global UI

### FEC/F3E seam
- seam types
- transaction shape for the evaluator side
- trace schema
- evaluator contract tests
- conformance matrix for the seam
- profile/capability integration at evaluator boundary

### Spreadsheet-program-specific semantics
- expression constructs and language forms specific to the target spreadsheet dialect
- reference-style rules specific to that dialect
- function-call integration with OxFunc
- profile-specific function exposure and degradation rules at formula-language level

## 9.5 Out of scope

- global document structure
- immutable snapshot storage
- multi-node graph maintenance
- dirty-closure scheduling
- epoch advancement
- global calc publication policy
- collaboration sequencing
- file adapter behavior
- UI rendering
- VBA runtime implementation
- owning the fundamental function/value semantics already assigned to OxFunc

## 9.6 Relationship to OxFunc

OxFml consumes OxFunc’s value and function universe.

OxFml may define:

- how formulas call functions,
- what binder/evaluator metadata is needed,
- how profile rules expose or hide functions,
- how formula syntax maps to function invocation semantics.

OxFml may **not** redefine:

- the canonical meaning of core value types,
- the canonical semantics of library functions already owned by OxFunc,
- the authoritative function-profile universe.

### Practical rule
If the issue is about **how a function is spelled, referenced, or bound in the formula language**, it belongs to OxFml.  
If the issue is about **what the function means and what it returns**, it belongs to OxFunc.

## 9.7 Relationship to OxCalc

OxFml must expose a seam that OxCalc can drive without making OxCalc formula-language specific.

That means OxFml should publish:

- stable evaluator contracts,
- explicit bind outputs,
- explicit dependency/spill/shape/topology deltas,
- explicit rejection taxonomy,
- versioned traces.

OxFml should **not** take back ownership of:

- scheduler decisions,
- full vs incremental vs hybrid recalc policy,
- epoch coordination,
- cross-node invalidation policy beyond the evidence emitted by the node.

### Practical rule
OxFml emits **evidence**. OxCalc owns **global policy**.

## 9.8 Required early milestones

### Milestone OXFML-1 — seam freeze candidate
Produce the first OxFml-local canonical version of:
- FEC/F3E interface draft
- transaction types
- reject taxonomy
- trace schema
- dependency/spill delta schemas
- core seam scenarios

### Milestone OXFML-2 — no-reference language completeness lane
Support the full targeted no-reference formula-language surface needed by DNA OneCalc, including:
- expressions,
- function calls,
- literals,
- coercion entry points as delegated to OxFunc,
- explicit non-support diagnostics for reference-bearing constructs if references are outside the profile.

### Milestone OXFML-3 — tree-reference profile
Define the formula-language profile used by DNA TreeCalc:
- tree/global references
- relative reference model in tree space
- dynamic reference behavior that still makes sense without a grid
- explicit exclusions where grid semantics do not exist

### Milestone OXFML-4 — grid-reference profile
Define the formula-language profile intended for full DNA Calc:
- grid references
- spill-aware references
- structural rewrite participation rules
- profile-gated compatibility behaviors

## 9.9 Required artifacts

- repo-level `CHARTER.md`
- `ARCHITECTURE.md` or equivalent lane-architecture doc
- FEC/F3E draft spec
- seam conformance matrix
- trace schema spec
- managed-run handoff records when proposing Foundation text
- minimized seam regressions
- capability/profile manifest fragments needed by hosts/core
- replay fixtures for dynamic-reference and spill behavior

## 9.10 Required packs / assurance orientation

At minimum, OxFml work must contribute to or enable:

- dynamic dependency bind semantics
- spill invalidation semantics
- snapshot/token/capability reject cases
- deterministic replay trace validity
- early-cutoff observability support where node-local evidence matters

OxFml must assume that its outputs will be consumed by packs that require:
- dynamic dependency trace artifacts,
- replayable rejection details,
- exact spill lifecycle evidence,
- stable evaluator boundary traces.

## 9.11 Non-goals for the first OxFml phase

- solving full global concurrency
- owning tree/grid structure
- owning file interop
- becoming a full spreadsheet application
- becoming a generic macro runtime

## 9.12 Definition of success

OxFml is successful when:
- DNA OneCalc can use it as a serious no-reference evaluator host,
- DNA TreeCalc can use it as a serious tree-reference evaluator host,
- OxCalc can treat it as a replaceable formula lane rather than hardcoded logic,
- Foundation can point to OxFml as the authoritative home of the current spreadsheet formula-language seam.

---

## 10. Detailed charter: OxCalc

## 10.1 Charter status
**Type:** new lane/component repo charter guidance  
**Priority:** immediate  
**Depends on:** Foundation, OxFml, OxFunc  
**Enables:** DNA TreeCalc, DNA Calc, future alternative structure hosts

## 10.2 Mission

OxCalc is the Rust implementation lane for the multi-node core engine defined by Foundation. It owns the document-structure side of calculation: immutable snapshots, global recalc state, dependency maintenance, invalidation, scheduling, publication, and concurrency coordination.

OxCalc exists to answer the question:

> “Given a versioned document structure and a set of dirty causes, how should the system derive, schedule, coordinate, publish, and expose recalculation across many nodes while preserving deterministic semantics and explicit stale/pending visibility?”

## 10.3 Core responsibility statement

OxCalc is responsible for all semantics that live **above the single-node evaluator** and **below the application/file/UI layers**.

## 10.4 In scope

### Core state and mutation model
- immutable snapshot materialization
- core structure model for supported substrates
- operation application and snapshot evolution
- structural rewrite handling
- epoch, value-epoch, stabilized-epoch management
- calc delta emission

### Global dependency and invalidation model
- structural graph materialization
- runtime overlay integration
- reverse maps
- dirty/stale/necessary state handling
- invalidation closure
- spill/selective invalidation handling
- conservative fallback policy

### Scheduling and evaluation coordination
- ready queues
- SCC/topological scheduling baseline
- iterative/cycle handling integration
- full/incremental/hybrid mode selection
- visible-first optional policy integration
- contention handling
- worker leasing and publish-fence control

### Host substrate evolution
- initial tree-only structure model
- later tree-grid-hybrid model
- explicit first-class treatment of cells, names, controls, charts, and future host entities as required by Foundation

## 10.5 Out of scope

- formula parsing
- binder internals
- authoritative function semantics
- VBA compiler/runtime
- UI
- file adapters
- COM automation surface
- generic scripting or macro host implementation

## 10.6 Initial implementation target

The first serious OxCalc target should **not** be the full tree-grid-hybrid engine immediately.

It should begin with the smallest meaningful structure that still exercises the true core-engine responsibilities: a tree of named nodes with formulas at leaves and explicit multi-node invalidation, dependency, and stabilization behavior.

That is exactly why **DNA TreeCalc** matters. It is the first serious OxCalc host because it lets the program validate:

- immutable snapshot and calc-arena separation,
- global dirty propagation,
- epoch/status behavior,
- tree-relative and global reference handling,
- streaming/volatile/external invalidation behavior,
- dynamic dependency tracking,
- operation-driven mutation,
- scheduler correctness,

without immediately paying the full cost of grid structural rewrites and spill-region geometry.

## 10.7 Relationship to OxFml

OxCalc drives OxFml as the node evaluator lane. It should know as little as possible about formula-language internals.

OxCalc should expect from OxFml:

- prepared plans or equivalent evaluator-ready artifacts,
- session/capability/execute/commit contract surfaces,
- dependency deltas,
- spill events,
- formatting-observation tokens where needed,
- precise rejection details.

OxCalc should own:
- when and why a node is evaluated,
- how its commit payload changes global state,
- how its effects propagate to other nodes,
- when to fall back conservatively,
- when an epoch is stabilized.

## 10.8 Relationship to host applications

OxCalc should be host-agnostic over structure **within profile limits**.

That means the same OxCalc core should be able to serve:

- DNA TreeCalc
- DNA Calc
- future specialized hosts

provided the structure adapter and profile bindings are appropriately defined.

## 10.9 Required early milestones

### Milestone OXCALC-1 — core engine contract freeze candidate
Define the OxCalc-local canonical form of:
- `DocSnapshot`
- `CalcArena`
- node identity model
- structural dependency graph shape
- runtime overlay application
- commit bundle application
- epoch/state exposure
- calc-delta emission surface

### Milestone OXCALC-2 — tree substrate
Implement the first usable tree substrate:
- named nodes
- parent/child hierarchy
- leaf formulas
- tree-global and relative reference semantics
- no grid-specific rewrites

### Milestone OXCALC-3 — incremental overlay lane
Turn on:
- runtime dependency delta application,
- spill or spill-analog invalidation where applicable,
- early cutoff,
- full/incremental/hybrid mode decisions.

### Milestone OXCALC-4 — concurrent coordinator pilot
Add:
- multi-worker execution over immutable snapshots,
- deterministic queue ordering,
- snapshot/token fencing,
- contention replay harness support.

### Milestone OXCALC-5 — tree-grid-hybrid expansion
Introduce:
- grid substrate within tree shells,
- row/column structural rewrite semantics,
- grid-aware spill lifecycle,
- full DNA Calc host requirements.

## 10.10 Required artifacts

- repo-level `CHARTER.md`
- `ARCHITECTURE.md`
- state model / type schema docs
- scheduler and invalidation docs
- change delta schema docs
- replay artifact schema docs
- managed-run handoff records back to Foundation
- minimized regression corpus
- benchmark/prototype contracts if multiple representation strategies are explored

## 10.11 Required packs / assurance orientation

OxCalc should treat the following as directly relevant:

- `PACK.concurrent.epochs`
- `PACK.lean.ocaml.alignment.core`
- `PACK.stream.basic`
- `PACK.structural.insert`
- `PACK.calcdelta.basic`
- `PACK.volatility.three_cat`
- `PACK.dag.dynamic_dependency_bind_semantics`
- `PACK.dag.parallel_determinism_signature`
- `PACK.dag.cycle_iterative_semantics`

As the architecture matures, OxCalc should be the main consumer/producer of evidence for:
- deterministic replay,
- SCC correctness,
- dynamic dependency soundness,
- early-cutoff safety,
- external ordering determinism,
- parallel schedule confluence.

## 10.12 Non-goals for the first OxCalc phase

- immediate full Excel worksheet parity
- file interop breadth
- full VBA hosting
- full grid model on day one
- hiding uncertainty: unresolved semantics must remain tagged, explicit, and traceable

## 10.13 Definition of success

OxCalc is successful when:
- DNA TreeCalc becomes a serious and convincing first host,
- the lane proves the Option B boundary between structural truth and runtime overlays,
- concurrent coordinator behavior is made explicit rather than implied,
- later grid expansion is evolutionary rather than a rewrite from scratch.

---

## 11. Detailed charter: DNA OneCalc

## 11.1 Charter status
**Type:** new host/pathfinder application charter guidance  
**Priority:** immediate  
**Depends on:** OxFml, OxFunc, OxVba  
**Enables:** OxFml maturation, OxFunc maturation, OxVba formula/UDF host integration

## 11.2 Mission

DNA OneCalc is an Excel-compatible single-node calculator and testbed host. It exists to exercise the formula language, value/function semantics, and VBA integration **without** requiring a multi-node structure or reference engine.

It is the smallest serious application that can validate:
- formula-language completeness outside structural dependency concerns,
- OxFunc function semantics,
- UDF and VBA host integration,
- persistence and reload of evaluated state,
- evaluator diagnostics and display behavior in a real host.

## 11.3 Core idea

DNA OneCalc is “Excel if only a single cell or defined name existed.”

That means it should support:
- the full intended no-reference formula surface,
- the full intended function catalog for expressions that do not require references,
- VBA project loading for UDF and macro invocation,
- persistence/reload of formula and value state,
- serious UX for testing formulas, diagnostics, capabilities, and results.

## 11.4 In scope

- formula entry
- formula parsing/binding/evaluation through OxFml
- function semantics through OxFunc
- no-reference Excel-compatible expression behavior
- explicit diagnostics for reference-bearing constructs outside profile
- VBA project load/reload
- VBA UDF call path
- ability to invoke VBA procedures where host semantics make sense
- persistence of formula, last value, profile, and host metadata
- regression fixtures for single-node formula behavior

## 11.5 Out of scope

- reference resolution
- multi-node invalidation
- graph scheduling
- spill into a grid
- structural rewrites
- workbook/sheet structure
- file interop breadth
- being the future main spreadsheet product

## 11.6 Why this host matters

Without DNA OneCalc, OxFml risks being validated only through:
- pathfinder legacy code,
- synthetic unit tests,
- eventual full-engine integration.

That would delay detection of:
- parser/binder UX problems,
- evaluator capability issues,
- VBA/UDF integration gaps,
- formatting/display issues that are node-local rather than graph-global.

DNA OneCalc gives a low-complexity but real host in which OxFml, OxFunc, and OxVba can harden.

## 11.7 Required milestones

### Milestone ONECALC-1 — no-reference formula workbench
Support:
- expression entry,
- result display,
- diagnostics,
- profile/capability visibility,
- save/load.

### Milestone ONECALC-2 — OxFunc catalog validation host
Add:
- function browsing,
- function/property/profile inspection,
- targeted regression fixture running.

### Milestone ONECALC-3 — VBA host integration
Add:
- load VBA project,
- call VBA UDF from formula,
- invoke VBA procedures through explicit host commands.

### Milestone ONECALC-4 — lane proving ground
Become the preferred place to prove:
- new formula syntax,
- capability changes,
- evaluator trace behavior,
- no-reference compatibility behavior.

## 11.8 Required artifacts

- app charter
- app architecture note
- save/load format note
- integration notes with OxFml/OxFunc/OxVba
- regression corpus
- managed-run evidence when behavior is used to influence Foundation or lane docs

## 11.9 Non-goals

- replacing DNA TreeCalc
- replacing DNA Calc
- hiding unsupported reference behavior behind fake success
- becoming a permanent dumping ground for evaluator hacks that belong in OxFml

## 11.10 Definition of success

DNA OneCalc is successful when:
- it becomes the preferred fast testbed for OxFml and OxFunc,
- VBA UDF integration can be exercised without a full sheet/tree engine,
- no-reference formula compatibility can be pushed far before OxCalc is ready.

---

## 12. Detailed charter: DNA VbCalc

## 12.1 Charter status
**Type:** minimal host/pathfinder pointer  
**Priority:** optional / lane-local  
**Depends on:** OxVba  
**Scope note:** already largely specified in OxVba planning; kept brief here by design

## 12.2 Mission

DNA VbCalc is the minimal host used to exercise OxVba in a controlled environment where VBA can call host functions and the host can call VBA-defined code.

## 12.3 Intended role in the broader program

DNA VbCalc should remain:
- small,
- focused,
- OxVba-first,
- useful as a host-interop proving ground.

It should **not** grow into a second formula-engine or spreadsheet-engine program. When work becomes formula-centric, it belongs in DNA OneCalc or DNA TreeCalc. When work becomes full-sheet/product-centric, it belongs in DNA Calc.

## 12.4 Foundation-facing requirement

Whenever DNA VbCalc behavior materially affects:
- value interchange,
- UDF call contracts,
- macro-to-core mutation pathways,
- deterministic replay expectations,

the relevant normative implications must be handed back through managed-run handoff records rather than remaining trapped in OxVba notes.

---

## 13. Detailed charter: DNA TreeCalc

## 13.1 Charter status
**Type:** new host/pathfinder application charter guidance  
**Priority:** immediate after OxFml/OxCalc basic seams are usable  
**Depends on:** OxCalc, OxFml, OxFunc  
**Optional later dependency:** OxVba  
**Enables:** serious first OxCalc host; future DNA Calc

## 13.2 Mission

DNA TreeCalc is an Excel-compatible tree-structure calculator that implements most of the intended engine model **except the worksheet grid**.

It exists to prove the core engine with a host structure that is still multi-node, dependency-driven, and semantically interesting, while deliberately avoiding the first-wave complexity of rows, columns, spill geometry, and formula rewrite under grid structural edits.

## 13.3 Core idea

DNA TreeCalc answers the question:

> “If a spreadsheet behaved like a hierarchical tree of named nodes rather than a rectangular worksheet grid, how much of the core engine, evaluator contract, invalidation, volatility, streaming, and dynamic dependency behavior can already be proven?”

This is strategically valuable because it validates the difficult parts of the engine that are **not actually about the grid**.

## 13.4 Model

- the document is a hierarchical tree of nodes,
- each node has a stable identity and a human-facing name,
- leaves may hold formulas and values,
- references may be relative or global in tree space,
- names are first-class,
- dynamic references, volatility, streaming, and external invalidation still exist where meaningful,
- grid-only features do not exist unless explicitly modeled in a tree-compatible way.

## 13.5 In scope

- hierarchical node structure
- leaf formulas and calculated values
- relative and global reference semantics in tree space
- dirty propagation
- dynamic dependencies (`INDIRECT`-class and similar where meaningful)
- volatile / externally invalidated / standard invalidation classes
- streaming/external topics where meaningful
- SCC/cycle behavior
- deterministic replay and change deltas
- operation-driven mutations
- persistence/reload of tree documents

## 13.6 Out of scope

- worksheet grid semantics
- row/column insert/delete rewrite semantics
- dynamic array spilling into rectangular worksheet regions
- A1 coordinate geometry as a primary substrate
- workbook/sheet/worksheet UX expectations beyond what the tree host intentionally simulates

## 13.7 Why DNA TreeCalc matters

DNA TreeCalc is the first host that truly validates OxCalc, because it requires:

- multi-node dependency semantics,
- global dirty propagation,
- snapshot + calc-arena behavior,
- stabilization and publication,
- dynamic dependency handling,
- concurrency-safe architecture,

without yet forcing every decision to be entangled with spreadsheet-grid details.

This makes it the best proving ground for the core engine shape and the cleanest bridge between DnaVisiCalc and full DNA Calc.

## 13.8 Required milestones

### Milestone TREECALC-1 — tree substrate and leaf evaluation
Support:
- node creation,
- node naming,
- leaf formula evaluation,
- value/state display.

### Milestone TREECALC-2 — tree reference language
Support:
- global name references,
- relative tree references,
- deterministic unresolved-reference diagnostics.

### Milestone TREECALC-3 — full core behavior without grid
Support:
- invalidation classes,
- cycles/iteration,
- external updates,
- dynamic dependency tracking,
- replay bundles.

### Milestone TREECALC-4 — concurrency and overlay proving host
Support:
- Option B overlay behavior in a serious host,
- concurrent coordinator pilot,
- visible-first off by default,
- selective fallback behavior where required.

### Milestone TREECALC-5 — later VBA bridge
Optionally support:
- VBA UDF integration through OxVba,
- explicit macro mutation paths through the host.

## 13.9 Required artifacts

- app charter
- app architecture note
- tree reference model doc
- persistence format doc
- regression corpus
- replay traces
- performance fixtures and scaling signatures relevant to tree workloads

## 13.10 Required packs / assurance orientation

DNA TreeCalc should be the natural early proving ground for:
- baseline recalc core
- cycle/iterative semantics
- dynamic dependency bind semantics
- early-cutoff signature
- parallel determinism signature
- volatility three-category behavior
- calcdelta basic

## 13.11 Non-goals

- pretending to be a worksheet grid
- forcing grid concepts into the tree too early
- becoming a dead-end side project unrelated to DNA Calc
- becoming a local-only experiment with no Foundation handoff discipline

## 13.12 Definition of success

DNA TreeCalc is successful when:
- OxCalc’s first real host is convincing,
- most core-engine semantics are validated before the grid arrives,
- the later move to DNA Calc feels like substrate expansion, not architecture replacement.

---

## 14. Detailed charter: DNA Calc (future full host/product)

## 14.1 Charter status
**Type:** future host/product charter guidance  
**Priority:** later, but should be named clearly now  
**Depends on:** OxCalc, OxFml, OxFunc, OxVba, adapters, UI  
**Relationship to Foundation rounds:** intended future full product expression aligned with existing `DnaCalc` round naming

## 14.2 Mission

DNA Calc is the future full tree-grid-hybrid spreadsheet platform built on the lane split established by Foundation, OxCalc, OxFml, OxFunc, and OxVba.

It is the host/product in which the full architecture comes together:
- document structure,
- formula language,
- function/value semantics,
- core engine,
- VBA integration,
- file adapters,
- collaboration seams,
- UI.

## 14.3 Core idea

DNA Calc should realize the program’s long-term vision without undoing the clean separations established by the lane repos.

That means the full product must still preserve:
- operation-only mutation,
- immutable snapshot truth,
- explicit profile/versioning,
- explicit degradation classes,
- deterministic replay and evidence discipline,
- replaceable formula lane and replaceable core representations.

## 14.4 In scope

Eventually:
- tree-grid-hybrid structure
- worksheet-like grid semantics
- row/column structural rewrites
- spill semantics in grid space
- full host application behavior
- VBA storage and execution integration
- file I/O and degradation behavior
- UI and editing stack
- collaboration seam integration
- broad Excel-compatibility work

## 14.5 Out of scope for the first DNA Calc framing phase

- immediate full fidelity breadth across every compatibility corner
- collapsing lane boundaries for convenience
- using product urgency to bypass Foundation handoff and pack discipline

## 14.6 Success condition

DNA Calc is successful when it becomes the product-shaped realization of the architecture rather than an excuse to entangle everything again.

---

## 15. Shared charter boilerplate guidance

This section is meant to be copied into each new repo-level or host-level `CHARTER.md` with project-specific substitutions.

## 15.1 Boilerplate background template

```md
# <PROJECT>.md — Charter

## 1. Purpose
<PROJECT> is a <lane/component repo | host/pathfinder application | product host> in the DNA Calc program.
It exists to own and advance <one-sentence ownership focus>.
It is developed under Foundation doctrine and must remain consistent with Foundation source-of-truth documents.

## 2. Relationship to Foundation
This project is not a doctrine owner.
Foundation remains the source of truth for mission, doctrine, architecture framing, formal-model framing, operations rules, and pack/gate discipline.
Any proposed normative change to Foundation must be routed through managed-run handoff records and synthesis.

## 3. Program role
This project belongs to the following program axis:
- round/stage role: <if applicable>
- repo/lane role: <if applicable>
- host/product role: <if applicable>

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

## 15.2 Boilerplate doctrine template

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

## 15.3 Boilerplate project-structure template

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

## 15.4 Boilerplate wording for Foundation consistency

Each charter should include a sentence equivalent to:

> “This project advances one lane of the DNA Calc program. It may own implementation and lane-local specification detail, but Foundation remains the source of truth for mission, doctrine, architecture framing, operations rules, and cross-lane conformance expectations.”

---

## 16. Cross-repo handoff rule for these new lanes

Because the program is now splitting across multiple repos, lane-to-Foundation handoffs become more important, not less.

Every OxFml or OxCalc proposal that changes Foundation-facing meaning should be handed back using the existing normative handoff shape:

1. scope and profile bounds,
2. proposed normative text,
3. evidence and replay links,
4. unresolved decisions and risk impact.

This should become normal, lightweight practice rather than a rare heavyweight event.

Suggested repo-local folder convention for new lanes:

- `docs/handshakes/` or `docs/foundation_handoffs/`
- each handoff promoted into a managed run when it matters program-wide

---

## 17. Proposed Foundation doc adjustments

This section is written so it can be turned into direct edit work later.

## 17.1 `README.md`

Add a new section after the introductory usage guidance:

### Proposed addition
- explain the difference between Foundation docs, lane/component repos, and host/pathfinder applications;
- list `OxFunc`, `OxFml`, `OxCalc`, and `OxVba` as active sibling lanes;
- note that host/pathfinder applications such as DNA OneCalc and DNA TreeCalc consume those lanes;
- explicitly say that DnaVisiCalc remains the Round 0 authority and evidence source, while future implementation ownership is moving into lane repos.

## 17.2 `CHARTER.md`

Add a short subsection under “Program Structure and Names”:

### Proposed addition
- clarify that round names are not the same as repo names,
- clarify that component lanes include Foundation, DnaVisiCalc, OxFunc, OxFml, OxCalc, and OxVba,
- clarify that hosts/pathfinders include DNA OneCalc, DNA VbCalc, DNA TreeCalc, and DNA Calc.

This prevents the current names from drifting into ambiguity.

## 17.3 `ARCHITECTURE_AND_REQUIREMENTS.md`

Expand the current `3.18 FEC/F3E Lane Boundary` section into a broader “lane ownership and repo mapping” section.

### Proposed addition
- keep the conceptual split:
  - OxFml = grammar/parse/bind and evaluator lane
  - OxFunc = value/function semantics
  - FEC host/model = host protocol and evaluator-boundary contract
- add the practical repo mapping:
  - OxFml repo is the home of the spreadsheet formula/evaluator lane, including the FEC/F3E seam as a formula-world contract,
  - OxCalc repo owns the multi-node core engine,
  - OxVba repo owns VBA runtime/host integration lane.

Also add a short subsection stating that:
- the first serious OxCalc host is DNA TreeCalc,
- the first serious OxFml stand-alone host is DNA OneCalc,
- the full product target is DNA Calc.

## 17.4 `OPERATIONS.md`

Add guidance under cross-repo handoff and perhaps round progression:

### Proposed addition
- sibling lane repos may own lane-local specs and architecture docs, but Foundation remains the doctrine owner;
- every lane repo that proposes Foundation-facing behavior changes must emit handoff records in the existing normative shape;
- pathfinder/host projects should be identified as either:
  - lane proving grounds,
  - round vehicles,
  - or product hosts.

This helps prevent random local notes from becoming shadow doctrine.

## 17.5 `CORE_ENGINE_FORMAL_MODEL.md`

Add a brief section in the provisional / kickoff area that says:

- OxCalc’s first serious implementation target is a tree substrate, not the full grid,
- tree-first work is considered baseline-compatible exploration rather than out-of-model deviation,
- the tree-grid-hybrid remains the long-term model,
- the tree host is a proving strategy, not a separate doctrine.

This makes DNA TreeCalc legible inside the formal-model story.

---

## 18. Dependency-based execution order for the next projects

This uses sequence-only planning and deliberately avoids dates.

## 18.1 Wave A — semantic boundary freeze
**Priority:** highest  
**Depends on:** none beyond current Foundation and DnaVisiCalc evidence

1. freeze the Option B interpretation at Foundation level;
2. freeze the OxFunc/OxFml/OxCalc ownership split;
3. freeze the FEC/F3E carry-forward decision and handoff wording;
4. define the repo map and host map.

**Primary outputs:**
- accepted version of this catalog
- Foundation section edits
- initial repo charters

## 18.2 Wave B — OxFml/OxFunc seam hardening
**Depends on:** Wave A

1. freeze seam types, reject taxonomy, and trace schema;
2. define no-reference profile for DNA OneCalc;
3. define tree-reference profile for DNA TreeCalc;
4. align function/profile exposure rules between OxFunc and OxFml.

**Primary outputs:**
- OxFml charter
- OxFml architecture doc
- seam contracts
- no-reference and tree-reference profile notes

## 18.3 Wave C — DNA OneCalc host
**Depends on:** Wave B

1. stand up DNA OneCalc as the fast host for OxFml/OxFunc;
2. validate no-reference language behavior;
3. add VBA UDF host integration as OxVba matures.

**Primary outputs:**
- functioning single-node testbed
- regression corpus
- handoff records for formula-language issues surfaced by real hosting

## 18.4 Wave D — OxCalc tree substrate
**Depends on:** Wave B

1. build tree-only `DocSnapshot` and `CalcArena` realization;
2. implement dirty propagation, stabilization, and delta emission;
3. integrate OxFml node evaluation;
4. keep conservative fallback paths explicit.

**Primary outputs:**
- first serious OxCalc lane implementation
- tree substrate docs
- replay and pack evidence

## 18.5 Wave E — DNA TreeCalc host
**Depends on:** Wave D

1. expose the tree substrate through a usable host;
2. validate relative/global tree references;
3. validate dynamic dependency and invalidation behavior;
4. use the host as the first convincing proof of the core engine.

**Primary outputs:**
- serious host for OxCalc
- tree reference model validation
- pack-driving evidence

## 18.6 Wave F — concurrent coordinator and advanced lanes
**Depends on:** Wave D/E

1. implement concurrent coordinator pilot;
2. add contention replay harness;
3. add visible-first as an optional policy lane only after equivalence evidence;
4. test whether dynamic-topo or SAC-inspired lanes justify promotion.

**Primary outputs:**
- concurrency evidence
- policy comparison evidence
- decision records on advanced incrementalization

## 18.7 Wave G — full DNA Calc expansion
**Depends on:** Wave E/F and later adapter/UI work

1. add grid substrate;
2. add structural rewrite semantics;
3. add spill-region geometry at full host level;
4. integrate file/UI/product layers.

---

## 19. Project-specific guidance on packs and evidence

## 19.1 OxFml emphasis
OxFml should be especially careful to emit evidence required by:
- dynamic dependency trace packs,
- spill lifecycle packs,
- reject taxonomy validation,
- trace schema validation,
- capability/profile negotiation checks.

## 19.2 OxCalc emphasis
OxCalc should be especially careful to emit evidence required by:
- concurrency/epoch packs,
- deterministic replay packs,
- SCC and iterative-mode packs,
- dynamic dependency soundness packs,
- calcdelta and volatility packs,
- scaling signatures.

## 19.3 DNA OneCalc emphasis
DNA OneCalc should prioritize:
- formula-surface coverage,
- diagnostics clarity,
- VBA UDF host integration correctness,
- save/load reliability,
- regression convenience.

## 19.4 DNA TreeCalc emphasis
DNA TreeCalc should prioritize:
- tree reference semantics,
- operation-driven mutation,
- stabilization behavior,
- dynamic references without a grid,
- proving that the core engine is real before the worksheet grid arrives.

---

## 20. Specific open decisions that should stay explicit

This catalog resolves many ownership issues, but it should not pretend that all design questions are finished.

The following must remain explicit open decisions until promoted:

1. exactly how OxFml packages formatting language ownership versus general display pipeline ownership;
2. how many profile layers exist between OxFunc function profiles and OxFml formula-language profiles;
3. the precise tree-relative reference model for DNA TreeCalc;
4. whether some non-grid analog of spill exists in tree space or whether tree hosts simply exclude spill;
5. the long-term naming convention for host apps versus round names if ambiguity becomes operationally painful;
6. whether OxCalc should support multiple structure adapters behind one kernel or whether the tree and tree-grid-hybrid will share one progressively extended structure family.

Every one of those should be carried as an explicit `DEC-*` item when it starts affecting gates or architecture text.

---

## 21. Recommended immediate acceptance statements

If this document is promoted, the following short statements should be adopted almost verbatim.

### Statement A — program taxonomy
DNA Calc uses separate names for rounds, lane repos, and host applications. Round names describe program stages; repo names describe long-lived component ownership; host names describe applications or pathfinders built from those components.

### Statement B — new lane split
OxFunc owns value and function semantics. OxFml owns the spreadsheet formula/evaluator lane and the current FEC/F3E seam. OxCalc owns the multi-node core engine. OxVba owns VBA compilation/runtime and host integration. Foundation remains the doctrine and architecture owner.

### Statement C — host strategy
DNA OneCalc is the preferred fast proving host for OxFml/OxFunc/OxVba. DNA TreeCalc is the preferred first serious host for OxCalc. DNA Calc is the future full host/product.

### Statement D — tree-first strategy
Tree-first OxCalc work is not a detour from DNA Calc; it is the shortest route to validating the core engine before paying full worksheet-grid complexity.

---

## 22. Closing summary

The program is now ready for a cleaner structure than “Foundation plus DnaVisiCalc plus a pile of ideas.”

The right next shape is:

- **Foundation** for doctrine and architecture,
- **OxFunc** for value/function semantics,
- **OxFml** for formula-language and single-node evaluator semantics,
- **OxCalc** for the multi-node core engine,
- **OxVba** for VBA runtime/host integration,
- **DNA OneCalc** as the fast formula/UDF/VBA proving host,
- **DNA TreeCalc** as the first serious OxCalc proving host,
- **DNA Calc** as the future full host/product.

That structure is consistent with the existing Foundation hard boundaries, consistent with the Option B architecture, consistent with the current FEC/F3E seam evidence, and consistent with the desire to move beyond DnaVisiCalc without losing what it already proved.
