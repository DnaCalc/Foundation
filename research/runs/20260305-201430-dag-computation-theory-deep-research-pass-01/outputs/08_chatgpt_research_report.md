# DAG-Based Incremental Computation for Deterministic Spreadsheet Engines

## Executive Summary

Source-backed: A rigorous spreadsheet computation core can be treated as **(i)** a pure(ish) functional semantics for acyclic dependencies, **(ii)** a **fixed-point semantics** for cyclic regions (when permitted), and **(iii)** a **trace/dependency-recording semantics** for value-dependent (“dynamic”) dependencies such as `INDIRECT`-like constructs. These three viewpoints are individually well-supported in the literature (lattice fixed points [R1], operational spreadsheet semantics independent of evaluation mechanism [R25], and demanded/dynamic dependency graphs with from-scratch consistency [R5], [R7]) and collectively cover the problem surface of modern deterministic spreadsheet engines. citeturn12view1turn46view0turn26view0turn51view1

Source-backed: For baseline engineering, the best risk-adjusted path is the standard “spreadsheet recalc” architecture: maintain a dependency structure, mark dependents dirty on edits, and recompute in a valid order, using SCC condensation to isolate cycles. This matches both major commercial documentation (dependency tree → calculation chain) and academic spreadsheet implementation experience (support graph / minimal recalculation). citeturn6search17turn44view1

Source-backed: **Dynamic dependencies are the hard boundary**: in practice, systems that want correctness with `INDIRECT`-like constructs either (a) over-approximate (treat as volatile / broad invalidation) or (b) switch to a more dynamic approach where evaluation discovers dependencies and the graph is updated accordingly—an approach explicitly identified as requiring major architectural change in a production spreadsheet engine context. citeturn52search4turn44view0turn41view1

Source-backed: **Parallel computation is tractable** only if determinism is designed into the semantics: even if each node computes deterministically, event ordering or schedule changes can introduce nondeterminism at the system level (as formalized for timely-dataflow-style systems). A deterministic spreadsheet engine must therefore define a stable evaluation/synchronization policy, and constrain or specify reduction orders for floating-point aggregates. citeturn39view1turn46view1turn6search6

Inference: The “best mathematical framing” for a deterministic spreadsheet DAG engine is a **hybrid**:  
- **Functional semantics** for the acyclic fragment (fast, proofable, deterministic),  
- **Tarski-style fixed points** for cyclic SCCs when iterative mode is enabled (plus pragmatic convergence caps), and  
- **From-scratch-consistent trace repair** for dynamic dependencies (optional, staged in later milestones).  
This hybrid maximizes semantic clarity and conformance while keeping implementation risk staged and controllable. citeturn12view1turn46view0turn51view1

## Source Quality and Method

Source-backed: This dossier prioritizes **primary sources**: foundational papers (lattice fixed points, SCC, dynamic topo/cycle detection, incremental computation), formal semantics papers, and official docs/specs for spreadsheet recalculation behavior and formula semantics. When classic sources are paywalled (notably the original CACM topological sorting paper), claims are anchored in the DOI landing page plus open instructional material that explicitly attributes the algorithm to the original work. citeturn18search0turn17search13turn15view1turn12view1

Source-backed: For spreadsheet engine practice, this report relies on: (a) Excel’s published description of dependency tree and calculation chain, plus multithreaded recalculation docs; (b) Open XML documentation clarifying that the stored calculation chain is *not* a dependency tree; (c) Corecalc/Funcalc technical documentation that directly studies minimal recalculation, volatile functions, and support graphs; and (d) HyperFormula’s documentation and design discussions for dependency graphs and `INDIRECT` limitations. citeturn6search17turn6search20turn44view1turn52search0turn52search4

Inference: “Deterministic replay / conformance” has relatively sparse direct coverage in mainstream spreadsheet documentation (which often focuses on performance and user-visible behavior). To compensate, the dossier uses (i) formal semantics work that separates meaning from evaluation mechanism, and (ii) models that explicitly locate nondeterminism in event ordering/scheduling—then maps those ideas into spreadsheet-like constraints (stable ordering policies, deterministic reductions). citeturn46view0turn39view1turn6search6

## Theory Map (Math + Semantics)

### Acyclic spreadsheets as evaluation of a partial function over cell addresses

Source-backed: A common formalization models a “sheet” as a mapping from addresses to formulas (and a separate mapping from addresses to values), where evaluation yields values or errors; modern semantics explicitly accounts for error values and volatile/nondeterministic functions, and aims to specify results *independently of evaluation mechanism*. This is directly stated as a goal for spreadsheet semantics work in the Funcalc line. [R25] citeturn46view0turn46view1

Source-backed: Under static dependencies (no cycles), a dependency graph induces a partial order; any topological order consistent with edges is a valid evaluation schedule. HyperFormula explicitly frames evaluation order as a topological order that exists iff there is no cycle in the dependency graph. [R22] citeturn52search1turn52search0

Inference: For a deterministic engine, “any topological order” is not enough—one must pick a **canonical** order (e.g., stable sort by address, sheet ID, creation order) to ensure replay equality. The need for schedule specification is reinforced by models where nondeterminism is introduced by ordering of events. citeturn39view1turn6search6

### Cycles as fixed points and SCC-local iteration

Source-backed: The lattice-theoretic fixed-point theorem states that for an increasing (monotone) function on a complete lattice, the set of fixed points is non-empty and forms a complete lattice, giving least/greatest fixed points. This is the core theoretical foundation for interpreting cyclic dependencies as fixed points when the semantic domain is a suitable lattice and cell update functions are monotone. [R1] citeturn12view1turn12view0

Source-backed: Practical spreadsheet systems often treat cycles as errors by default, but may optionally enable iterative evaluation with bounds such as maximum iterations and convergence thresholds (“max change”), as exposed in official Excel APIs/docs for iterative calculation. [R21] citeturn5search15turn6search13

Inference: A defensible deterministic spreadsheet spec should therefore offer two distinct cycle semantics:
1) **Error semantics** (default): cycles yield a circular-reference error;  
2) **Iterative semantics** (opt-in): SCCs are evaluated by a deterministic iteration scheme with explicit caps and tolerance, and the semantics is “the reported iterate after N steps / within ε,” unless a monotone fragment is enforced (in which case least fixed point becomes the target). The gap between Tarski-style guarantees and Excel-style pragmatic iteration is a key spec choice. citeturn12view1turn5search15

### Dynamic dependencies as trace repair / demanded computation graphs

Source-backed: Self-adjusting computation introduces **dynamic dependence graphs (DDGs)** whose dependence structure can change during change propagation, and argues for correctness via “from-scratch equivalence/consistency.” [R5] citeturn26view1turn26view0

Source-backed: In the Adapton lineage, a **demanded computation graph (DCG)** records which computations (thunks/cells) were forced and what mutable references were read; changing inputs “dirties” the graph and change propagation “cleans” it, restoring consistency. From-scratch consistency is explicitly stated and illustrated. [R7] citeturn51view1turn51view0

Source-backed: Build-systems theory draws the same boundary: **static dependencies** can be extracted without doing the work (e.g., by inspecting a formula syntax tree), but **dynamic dependencies** for monadic tasks must be observed by running the task in a tracing context that records dependencies. This is explained with explicit reference to Excel formulas as an instance of syntax-tree dependency extraction, and contrasted with dynamic dependency tracking via “track.” [R14] citeturn41view1turn41view0

Inference: Spreadsheet `INDIRECT`-like functions are semantically “monadic”: the set of precedents depends on runtime values, so a deterministic engine must either (a) conservatively approximate dependencies, or (b) adopt a trace-driven model where evaluation discovers and records the actual edges, and the dependency graph is updated accordingly.

### Delta-based semantics for incremental and streaming updates

Source-backed: Incremental λ-calculus / “Theory of Changes” formalizes changes as first-class entities and provides a source-to-source transformation `Derive` satisfying an equation of the form  
`f (a ⊕ da) ≅ (f a) ⊕ (Derive(f) a da)`  
with correctness formalized (machine-checked) and a plugin interface defining change representations for primitives. [R8] citeturn30view0turn29view0

Source-backed: Differential dataflow generalizes incremental computation by associating state with **partially ordered versions** and retaining indexed updates, enabling nested iteration plus incremental updates; this is positioned as addressing limitations of sequential incremental computation when both iteration and updates are present. [R9] citeturn32view0turn32view1

Source-backed: Timely dataflow provides a timestamped dataflow model with formal semantics; local computations may be deterministic, while nondeterminism is introduced by event ordering. This separation is crucial when mapping streaming theory into a deterministic spreadsheet setting. [R12] citeturn39view1turn39view0

Inference: For spreadsheets, delta semantics is most valuable as an *internal optimization layer* (e.g., for large-range aggregates and streaming external inputs), rather than as the sole semantic foundation—because spreadsheet formula languages include partiality (errors), dynamic references, and non-monotone functions for which generic derivatives are nontrivial.

## Algorithm Family Map

### Static scheduling and cycle partitioning

Source-backed: SCC decomposition is the standard way to isolate cycles; the classic DFS-based SCC algorithm runs in linear time/space in vertices+edges, and produces strongly connected components suitable for SCC-condensation DAG scheduling. [R2] citeturn15view1turn14view1

Source-backed: Acyclic evaluation scheduling is typically based on a topological order. “Topological sorting of large networks” is the classic reference, and open teaching material describes the linear-time “start nodes / indegree-zero” method while citing the 1962 source. [R3], [R4] citeturn18search0turn17search13

Inference: For deterministic replay, the engine should define a canonical topological order (or canonical SCC order + within-SCC rule) to avoid schedule-dependent differences, especially with floating-point aggregation and volatile-like semantics.

### Dynamic graph edits under formula changes

Source-backed: Dynamic topological ordering has a deep literature. Representative results include:  
- Incremental topological ordering with total update cost \(O(n^2 \log n)\) across edge insertions via label-based maintenance. [R16] citeturn20view0turn19view0  
- Fully dynamic (insert/delete) topological order algorithms that emphasize practical simplicity despite inferior asymptotic complexity, and provide experimental comparisons. [R17] citeturn22view0turn21view0  
- Incremental cycle detection/topological sort with improved expected total time bounds in certain sparsity regimes (randomized). [R15] citeturn24view1turn24view0

Source-backed: Spreadsheet implementation experience notes that maintaining a topological ordering under edits can be difficult and that small edits may radically change the order; it also flags that online algorithms exist but “are not fast” in this context. [R24] citeturn43view2turn44view0

Inference: For spreadsheet engines, dynamic-topo algorithms are best treated as an optional later-stage optimization: correctness can be achieved by recomputing order/schedule for the affected region or reconstructing a calculation chain, while leaving dynamic-topo for throughput scaling.

### Invalidation and stabilization (incremental recomputation)

Source-backed: Excel describes a **dependency tree** used to build a **calculation chain**; during recalculation Excel may revise this chain when encountering dependencies on not-yet-calculated cells. This indicates a mutable scheduling structure distinct from merely “one topological sort per build.” [R18] citeturn6search17turn6search20

Source-backed: Corecalc/Funcalc describes “minimal recalculation” in terms of **recalculation roots** (edited cells plus volatile cells) and guarantees that all cells are up to date after recalculation unless a cycle prevents it; it also emphasizes that volatile functions require care and that formulas should be evaluated at most once to preserve volatile semantics. [R24] citeturn44view1turn53view0

Source-backed: HyperFormula documents a multi-phase approach including dependency graph construction and emphasizes that correct processing order requires a dependency graph; it also highlights that for large ranges it uses optimizations affecting precedent reporting. [R22], [R27] citeturn52search0turn52search3

### Dynamic dependencies (INDIRECT-like)

Source-backed: HyperFormula maintainers state that with `INDIRECT`, the engine cannot build the dependency graph properly without first evaluating cells, and that supporting it would require rewriting a big part of the engine. They contrast this with attempts to handle `OFFSET`, characterizing the problem as “more dynamic.” [R23] citeturn52search4

Source-backed: Build-systems theory provides an explicit conceptual tool: applicative tasks have static dependencies extractable without execution, while monadic tasks require runtime tracing to discover dependencies; the paper uses Excel formulas as an example of syntax-tree-based static dependency extraction. [R14] citeturn41view1

Inference: A spreadsheet engine that targets deterministic conformance with `INDIRECT`-like behavior should implement either:
- **Conservative dependency approximation** (treat as volatile / broad dependencies), or
- **Runtime dependency discovery** (evaluate, record accessed cells/ranges, update edges), with from-scratch consistency as the correctness condition.

### Optional streaming/external updates

Source-backed: Naiad/timely dataflow models integrate streaming, iteration, and incremental computation via logically timestamped messages and progress/notification mechanisms, explicitly supporting cycles in the dataflow graph (structured loops). [R10] citeturn34view0turn34view1

Source-backed: Differential dataflow explains why sequential incremental computation struggles to combine iteration and updates simultaneously, and motivates partial-order versioning as the remedy. [R9] citeturn32view1turn32view0

Inference: For a spreadsheet engine, external updates can initially be modeled as deterministic sequences of cell edits; later, a timely/differential-style internal engine can be introduced to efficiently maintain selected incremental views (e.g., streaming tables, large joins, recursive computations) while preserving deterministic replay behavior through a fixed event order and deterministic operators.

image_group{"layout":"carousel","aspect_ratio":"16:9","query":["spreadsheet dependency graph diagram","strongly connected components directed graph illustration","timely dataflow graph loop context diagram","differential dataflow partially ordered timestamps diagram"],"num_per_query":1}

## Comparative Scoring Matrix

Scoring convention (1–5): higher is better. For **implementation complexity**, 5 = simpler/lower risk; 1 = hardest/highest risk.

| Family (major theory/algorithm cluster) | Semantic clarity | Proofability | Implementation complexity | Runtime performance potential | Dynamic references suitability | Determinism / replay friendliness |
|---|---:|---:|---:|---:|---:|---:|
| Classical spreadsheet DAG recalc (dirty → topological schedule) [R18], [R24] | 4 | 4 | 4 | 3 | 2 | 4 |
| SCC + iterative mode (fixed-point-inspired cycles) [R1], [R21] | 3 | 3 | 3 | 2 | 3 | 3 |
| Trace-based self-adjusting computation (DCG/DDG; from-scratch consistency) [R5], [R7] | 4 | 4 | 2 | 4 | 5 | 4 |
| Incremental λ-calculus / Theory of Changes (static differentiation) [R8] | 4 | 5 | 2 | 4 | 2 | 5 |
| Build systems framework (static/dynamic deps, traces, rebuilder/scheduler separation) [R14] | 5 | 4 | 3 | 3 | 4 | 4 |
| Timely + differential dataflow (streaming + iteration + incremental deltas on partial orders) [R9], [R12] | 3 | 4 | 1 | 5 | 3 | 2 |
| Dynamic graph algorithms (incremental topo / cycle detection) [R15], [R16], [R17] | 3 | 4 | 2 | 4 | 3 | 4 |

Rationale highlights (short, axis-linked):

Source-backed: Classical recalc scores well on semantic clarity/proofability because it aligns with widely published spreadsheet recalculation models (dependency tree and calculation chain; minimal recalculation roots), and it can be specified independently of implementation details (e.g., any chosen canonical topo order). [R18], [R24] citeturn6search17turn44view1

Source-backed: Trace-based self-adjusting computation scores highest on dynamic references because it is explicitly designed for runtime-discovered dependencies and includes from-scratch consistency as a correctness contract, but implementation complexity is high due to maintaining and garbage-collecting dependency graphs/traces. [R5], [R7] citeturn26view1turn51view1

Source-backed: Incremental λ-calculus scores highest on proofability/determinism due to a formal change semantics and a correctness equation for `Derive`, but its direct applicability to sheet languages is limited by the need to supply change structures (derivatives) for a large primitive set and handle reference/dynamic dependency features. [R8] citeturn30view0turn30view1

Source-backed: Timely/differential dataflow has very high performance potential for streaming and iterative incremental workloads, but determinism is harder because nondeterminism is introduced by ordering of events unless the system enforces a deterministic event schedule and deterministic operators. [R12], [R10] citeturn39view1turn34view1

## Transfer to Spreadsheet Engine Design

### Deterministic core semantics and conformance envelope

Source-backed recommendation: Specify spreadsheet meaning with an operational semantics that is independent of the evaluation mechanism (i.e., independent of whether the engine uses top-down, bottom-up, caching, compilation, or parallel evaluation), while explicitly modeling errors and nondeterministic/volatile functions. This matches the stated goal of modern spreadsheet semantics work and directly supports “deterministic replay / conformance” as a first-class requirement. [R25], [R24] citeturn46view0turn53view0

Inference: Conformance should be defined as: given the same initial workbook state and the same ordered sequence of edits/external events, the engine yields the same observable results (cell values, errors, and any exposed intermediate outputs) regardless of internal scheduling/parallelism—subject to explicit rules for volatile/nondeterministic functions.

### Dependency representation under edits

Source-backed recommendation: Use a dependency representation that can handle both **cell-to-cell edges** and **range dependencies** without exploding memory. Two practical patterns are explicitly documented:
- Compact/static support-graph representations and “minimal recalculation roots” (Corecalc/Funcalc), motivated by the combinatorial growth of range-induced edges. [R24] citeturn44view0turn44view1  
- Spatial indexing (e.g., R-tree) for dependencies over areas (ClosedXML), enabling efficient lookup of dependents when a cell or region changes. [R26] citeturn4search5

Inference: A “two-tier graph” is often the best engineering compromise:
1) A **cell graph** for normal references and named expressions.  
2) A **range index** (interval tree/R-tree) keyed by rectangles, returning candidate dependents intersecting an edited area; this is then filtered/refined by exact dependency metadata.

### Scheduling: calculation chain vs canonical topological order

Source-backed recommendation: Maintain an explicit scheduling structure akin to a calculation chain, but define it in the *spec* as a canonical schedule derived from the dependency structure, not as an opaque “implementation artifact.” Excel documents that it constructs a calculation chain from the dependency tree and may revise the chain during recalculation. [R18] citeturn6search17

Source-backed recommendation: For deterministic replay, pick a canonical order even when multiple topological orders exist (HyperFormula explicitly notes multiplicity). [R22] citeturn52search1

Inference: A defensible deterministic scheduling policy is:
- Condense SCCs; order SCCs topologically using a stable tie-break (e.g., by minimal cell address in SCC).
- Within each acyclic SCC (size=1), evaluate deterministically.
- Within cyclic SCCs, evaluate by a deterministic iteration scheme (see below).

### Cycle handling

Source-backed recommendation: Implement SCC detection (linear-time) and represent the SCC-condensation DAG for scheduling. [R2] citeturn15view1

Source-backed recommendation: Provide two user-visible cycle modes:
- Default: error on circular reference.
- Optional iterative: iterate to a tolerance/iteration cap (as reflected in Excel’s iterative settings). [R21] citeturn5search15turn6search13

Inference: To connect theory to practice, the engine can define an **information-order lattice** for values (e.g., “unknown ⊑ number ⊑ error” or a richer domain) and require that “iterative mode with fixed-point guarantees” applies only to a monotone/contractive fragment, otherwise semantics is “bounded iteration with deterministic stop rule,” not “least fixed point.” This avoids promising Tarski-style guarantees where spreadsheet functions violate monotonicity. citeturn12view1turn6search13

### Dynamic dependencies (INDIRECT-like)

Source-backed recommendation: Treat dynamic dependency support as a staged capability. HyperFormula’s `INDIRECT` discussion shows that solving it “properly” requires evaluation-before-graph or a more dynamic architecture. [R23] citeturn52search4

Source-backed recommendation: When implementing dynamic dependencies, align with “dynamic dependency tracking” patterns from build systems (track dependencies by executing in a tracing context) and self-adjusting computation (record reads into a dependency graph; restore from-scratch consistency after mutations). [R14], [R7] citeturn41view1turn51view1

Inference: A deterministic spreadsheet engine can implement dynamic dependencies via:
- **Instrumented evaluation**: every cell/range read registers an edge `(current_cell → read_cell_or_range_instance)` in a runtime “observed dependency set.”
- **Edge stabilization**: after recalculation, persist the observed edges as the current dependency set for that formula cell, replacing prior observed edges.
- **Soundness rule**: if a dynamic read fails (e.g., invalid reference string), the error value is produced deterministically and the observed dependency set includes at least the inputs needed to determine that failure.

### Parallel execution

Source-backed recommendation: Parallelize only across independent regions of the dependency structure, but ensure determinism by specifying stable evaluation order where it matters (notably floating-point reductions and volatile functions). Spreadsheet semantics work notes that cost semantics can guide parallelization, and Excel documents support for multithreaded calculation. [R25], [R19] citeturn46view0turn6search6

Source-backed recommendation: Treat nondeterminism as coming from event ordering/scheduling and control it explicitly; timely dataflow formalizes deterministic local computations with nondeterminism introduced by ordering of events. [R12] citeturn39view1

Inference: To preserve replay friendliness, define:
- A deterministic task graph (SCC DAG),
- A deterministic tie-breaker for ready tasks,
- Deterministic aggregation orders inside functions (e.g., iterate ranges in a canonical cell order even if range evaluation is parallelized internally).

### Streaming/external updates

Source-backed recommendation: Model external updates as timestamped events and define a deterministic order for their application. Timely dataflow and Naiad show how timestamps and progress/notification boundaries allow streaming + iteration while keeping coherent views. [R10], [R12] citeturn34view1turn39view1

Inference: In a spreadsheet engine, implement streaming as:
- A deterministic event queue that maps to cell updates,
- Optional “batch epochs” to amortize recomputation,
- Later, an internal differential/timely subsystem for high-rate streams and incremental maintenance of expensive derived views.

## Formal Proof Obligations (candidate theorem statements)

Below, “Source-backed” indicates the obligation is directly motivated by cited semantics/IC frameworks; the statements themselves are candidate formalizations for a spreadsheet engine spec.

### Functional correctness for acyclic recalculation

Source-backed (motivated by [R25], [R24]):  
**Theorem (Acyclic From-Scratch Correctness).** Let \(S\) be a spreadsheet state whose dependency graph is acyclic (after expanding named expressions and static references). Let `Recalc_inc` be the incremental recomputation algorithm (dirty marking + canonical schedule), and `Recalc_full` be full recomputation in canonical schedule. For any edit sequence that yields an acyclic graph, `Recalc_inc(S)` produces the same value mapping as `Recalc_full(S)`. citeturn46view0turn44view1

### Determinism / replay

Source-backed (motivated by [R25], [R12]):  
**Theorem (Deterministic Replay).** Given fixed initial state \(S_0\) and a fixed totally ordered sequence of edit/external events \(E\), the engine’s observable outputs (values/errors) are uniquely determined, independent of parallel execution choices, provided the engine enforces deterministic scheduling and deterministic operator semantics. citeturn46view0turn39view1

### Cycle semantics

Source-backed (motivated by [R1], [R21]):  
**Theorem (Monotone SCC Convergence).** For an SCC whose update function \(F\) is monotone over a complete lattice domain \(D\), the SCC has a least fixed point, and the engine’s iterative mode (if defined as Kleene iteration from ⊥ with fair scheduling) converges to the least fixed point (or reaches it in finite steps if \(F\) is ω-continuous and the lattice has finite height). citeturn12view1turn6search13

Inference (pragmatic):  
**Theorem (Bounded Iteration Determinism).** If iterative calculation is defined as “run \(N\) deterministic iterations or stop when `maxChange ≤ ε`,” then the reported result is deterministic (even without monotonicity), but not necessarily a fixed point; this should be stated explicitly in conformance requirements.

### Dynamic dependency soundness

Source-backed (motivated by [R14], [R7], [R23]):  
**Theorem (Observed-Dependency Soundness).** Suppose a cell formula is evaluated under an instrumented evaluator that records all cell/range reads as a dependency set \(Deps\). After the evaluation, the engine stores \(Deps\) as the cell’s dynamic dependency set. Then, for any subsequent event that changes no address in \(Deps\), re-evaluating the cell yields the same result as before (up to volatile/nondeterministic allowances). citeturn41view1turn51view1turn52search4

Source-backed (from-scratch consistency as a gold standard [R7]):  
**Theorem (Dynamic From-Scratch Consistency).** For a class of dynamic dependencies implemented via a DCG-like structure, after propagation the observable result equals re-execution from scratch. citeturn51view1turn51view0

## Recommended Staged Architecture (Now / Next / Later)

### Now

Source-backed recommendation: Implement the classical recalculation core with:
- Dependency extraction for static references (syntax-tree-based),  
- Dirty propagation from edited cells and volatile roots,  
- SCC detection and SCC-DAG scheduling,  
- Canonical evaluation order for determinism, and  
- Cycle-as-error semantics as default.  
This aligns with Excel’s dependency-tree → calculation-chain framing and with Corecalc’s minimal recalculation roots and volatile handling. [R18], [R24] citeturn6search17turn44view1turn53view0

Source-backed recommendation: Support range dependencies using compact representations/indexes (support-graph compaction ideas + spatial indexes), rather than expanding all ranges to per-cell edges. [R24], [R26] citeturn44view0turn4search5

### Next

Source-backed recommendation: Add *limited* dynamic dependency support using a conservative tiering strategy:
1) Identify known “dynamic reference” functions.  
2) For those functions, either treat them as volatile (broad invalidation) or implement runtime dependency discovery for a restricted subset (e.g., only when the referenced address string is constant after evaluation of a known stable set). This matches both the “INDIRECT requires more dynamic approach” warning and the build-systems split between static and dynamic dependencies. [R23], [R14] citeturn52search4turn41view1

Source-backed recommendation: Add iterative cycle mode with deterministic iteration caps/tolerances matching documented Excel behavior, but specify semantics precisely (what is returned, convergence criteria, determinism). [R21], [R24] citeturn6search13turn44view1

### Later

Source-backed recommendation: Introduce a DCG/DDG-style subsystem for full dynamic dependency support and high-performance incremental maintenance, using from-scratch consistency as the correctness contract. The demanded computation graph approach is explicitly built for mutable dependencies and gives a formal correctness target. [R7], [R5] citeturn51view1turn26view1

Source-backed recommendation: For high-rate external updates / complex iterative analytics inside sheets, consider a timely/differential-style internal engine for selected workloads (not necessarily the whole sheet), but only if deterministic event ordering and deterministic operators are enforced by design. [R9], [R12] citeturn32view1turn39view1

Inference: Add incremental λ-calculus-style derivatives as an optimization layer for a curated subset of primitives (e.g., associative aggregates over large ranges), where the derivative representation is stable and well-specified; do not attempt to “differentiate the whole formula language” early.

## Risk Register and Failure Modes

| Risk / failure mode | Symptom | Likely root cause | Mitigation | Key sources |
|---|---|---|---|---|
| Dynamic dependencies produce stale results | Cell doesn’t update when indirect target changes | Static dependency graph cannot represent value-dependent edges | Conservative volatility tier; later DCG-style observed dependencies | [R23], [R14], [R7] citeturn52search4turn41view1turn51view1 |
| False cycle errors (over-approx) | Workbook rejected due to cycle that never executes | Static dependency over-approx (e.g., conditional deps); harmless static cycles exist | Distinguish static vs dynamic cycles; optional dynamic dependency refinement; SCC-local evaluation conditions | [R24], [R22] citeturn44view0turn52search1 |
| Non-convergence in iterative mode | Values oscillate or diverge | Non-monotone or unstable update functions | Specify bounded iteration semantics; optional monotone fragment for “fixed-point” guarantee | [R1], [R21] citeturn12view1turn5search15 |
| Parallelism breaks replay | Tiny numeric diffs across runs | Different reduction orders; schedule-dependent floating-point rounding | Canonical reduction order; deterministic scheduling; document volatile behavior | [R25], [R19], [R12] citeturn46view1turn6search6turn39view1 |
| Range dependency explosion | Memory/time blow up on large ranges | Expanding ranges to per-cell edges | Compact range dependency encoding + spatial index (R-tree/interval trees) | [R24], [R26] citeturn44view0turn4search5 |
| Calculation chain drift / “heisenbugs” | Rare incorrect order after edits | Mutable scheduling without canonicalization | Rebuild canonical schedule for affected SCC-DAG; verify against dependency invariants | [R18], [R24] citeturn6search17turn44view1 |
| Trace/graph space leaks (later stage) | Memory grows over time | DCG/DDG nodes and backedges retained | Explicit eviction/GC strategy; weak/strong edge discipline | [R7], [R5] citeturn51view0turn26view0 |

## Open Uncertainties and Targeted Follow-up Experiments

Source-backed uncertainty: **Dynamic dependency semantics choices** (over-approx vs runtime discovery) determine both correctness and performance. HyperFormula’s `INDIRECT` note suggests a major architectural threshold, indicating implementation risk is real. [R23] citeturn52search4  
Experiment: Implement a prototype “observed dependencies” evaluator for a restricted `INDIRECT` subset; measure (a) correctness vs a reference interpreter, (b) graph churn rate, (c) recomputation work saved vs volatility approximation.

Source-backed uncertainty: **Best scheduling structure for determinism + speed**. Excel documents that it revises calculation chain during recalculation and also supports multithreaded recalculation, implying scheduling is both dynamic and performance-sensitive. [R18], [R19] citeturn6search17turn6search6  
Experiment: Compare three determinism-preserving schedulers on real workloads: (1) recompute canonical topo each time; (2) maintain a chain with local repairs; (3) SCC-DAG + stable priority queue. Evaluate throughput and replay invariance.

Source-backed uncertainty: **Cycle semantics that users expect vs what is provable.** Tarski guarantees rely on monotonicity; practical iterative calculation is bounded and pragmatic. [R1], [R21] citeturn12view1turn6search13  
Experiment: Classify common cyclic spreadsheet patterns; test convergence under deterministic iteration schemes; determine whether a “monotone-only fixed-point guarantee” mode is viable.

Source-backed uncertainty: **Range dependency indexing strategy.** Both Corecalc and ClosedXML point to the range-edge explosion problem and to indexing/compaction as core techniques. [R24], [R26] citeturn44view0turn4search5  
Experiment: Benchmark interval-tree vs R-tree vs compressed range encodings on workloads dominated by large-range aggregates and fills.

Source-backed uncertainty: **Streaming/external update semantics.** Timely/differential models provide powerful tools but introduce event-order sensitivity. [R12], [R9] citeturn39view1turn32view1  
Experiment: Define a deterministic external-event ordering and test whether an epoch/batch abstraction satisfies latency goals without introducing nondeterminism.

## Annotated Bibliography (with URLs and access dates)

[R1] **A lattice-theoretical fixpoint theorem and its applications** — entity["people","Alfred Tarski","logician"]. *Pacific Journal of Mathematics* (1955). URL: `https://msp.org/pjm/1955/5-2/pjm-v5-n2-p11-s.pdf`. Accessed: 2026-03-05. Why it matters: foundational existence result for fixed points of monotone functions on complete lattices; supports principled semantics for cyclic SCCs under monotonicity. citeturn12view1

[R2] **Depth-First Search and Linear Graph Algorithms** — entity["people","Robert Tarjan","computer scientist"]. *SIAM Journal on Computing* (1972). URL: `https://www.cs.cmu.edu/~cdm/resources/Tarjan1972-sccs.pdf`. Accessed: 2026-03-05. Why it matters: linear-time SCC algorithm and correctness sketch; SCCs are the standard decomposition for cycle handling and SCC-DAG scheduling. citeturn15view1

[R3] **Topological sorting of large networks** — entity["people","Arthur B. Kahn","computer scientist"]. *Communications of the ACM* (1962). DOI landing page: `https://doi.org/10.1145/368996.369025`. Accessed: 2026-03-05. Why it matters: classic reference for topological scheduling of DAG dependencies. citeturn18search0

[R4] **Depth-First Search lecture notes (includes Kahn-style topological sorting attribution and linear-time method)** — University course notes (公开教材). URL: `https://courses.grainger.illinois.edu/cs473/sp2017/notes/06-dfs.pdf`. Accessed: 2026-03-05. Why it matters: open description of the indegree-zero queue method, explicitly attributing it to Kahn (1962), usable when the CACM PDF is paywalled. citeturn17search13

[R5] **Self-Adjusting Computation (PhD thesis)** — entity["people","Umut A. Acar","computer scientist"]. Carnegie Mellon University (2005). URL: `https://www.cs.cmu.edu/~rwh/students/acar.pdf`. Accessed: 2026-03-05. Why it matters: introduces dynamic dependence graphs, change propagation, trace stability, and claims \(O(1)\) overhead for dependence tracking techniques; a conceptual blueprint for dynamic spreadsheet dependencies. citeturn26view0turn26view1

[R6] **miniAdapton: A Minimal Implementation of Incremental Computation in Scheme** — entity["people","Dakota Fisher","computer scientist"]; entity["people","Matthew A. Hammer","computer scientist"] et al. arXiv (2016). URL: `https://arxiv.org/pdf/1609.05337`. Accessed: 2026-03-05. Why it matters: pedagogical complete implementation of Adapton-style incremental computation; clearly states from-scratch consistency and shows a concrete DCG data structure. citeturn28view1

[R7] **Incremental Computation with Names (Extended Version)** — entity["people","Matthew A. Hammer","computer scientist"] et al. arXiv (version posted 2021; extended from PLDI/OOPSLA lineage). URL: `https://arxiv.org/pdf/1503.07792`. Accessed: 2026-03-05. Why it matters: explains demanded computation graphs for Adapton, dirty/clean propagation, and emphasizes from-scratch consistency as a formal contract; discusses space management concerns. citeturn51view1turn51view0

[R8] **A Theory of Changes for Higher-Order Languages: Incrementalizing λ-Calculi by Static Differentiation** — entity["people","Yufei Cai","computer scientist"] et al. PLDI (2014), author-final PDF. URL: `https://inc-lc.github.io/resources/pldi14-ilc-author-final.pdf`. Accessed: 2026-03-05. Why it matters: formal change structures and a correctness equation for derivatives (`Derive`), with machine-checked proof approach; informs delta-based optimizations and proof obligations. citeturn30view0turn30view1

[R9] **Differential dataflow** — entity["people","Frank McSherry","computer scientist"] et al. CIDR (2013). URL: `https://www.cidrdb.org/cidr2013/Papers/CIDR13_Paper111.pdf`. Accessed: 2026-03-05. Why it matters: partial-order versioning and retained deltas enabling nested iteration plus incremental updates; motivates advanced streaming/incremental subsystems. citeturn32view0turn32view1

[R10] **Naiad: A Timely Dataflow System** — entity["people","Derek G. Murray","computer scientist"] et al. SOSP (2013). URL: `https://sigops.org/s/conferences/sosp/2013/papers/p439-murray.pdf`. Accessed: 2026-03-05. Why it matters: unifies streaming + iteration + incremental updates; introduces timestamps, structured loops, and notifications—useful analogies for streaming spreadsheet recalculation. citeturn34view0turn34view1

[R11] **Timely Dataflow (Rust implementation)** — GitHub org: entity["organization","TimelyDataflow","github org"]. URL: `https://github.com/TimelyDataflow/timely-dataflow`. Accessed: 2026-03-05. Why it matters: concrete implementation substrate for timely dataflow concepts; relevant for “later-stage” streaming subsystems. citeturn8search4

[R12] **Timely Dataflow: A Model** — entity["people","Martín Abadi","computer scientist"]; entity["people","Michael Isard","computer scientist"]. FORTE (2015) PDF. URL: `https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43546.pdf`. Accessed: 2026-03-05. Why it matters: formal semantics locating nondeterminism in event ordering; key for designing determinism/replay rules in parallel/streaming spreadsheet engines. citeturn39view1turn39view0

[R13] **Differential Dataflow book/documentation** — timelydataflow.github.io. URL: `https://timelydataflow.github.io/differential-dataflow/`. Accessed: 2026-03-05. Why it matters: operator-level explanation of differential dataflow, useful for implementation transfer and operator semantics. citeturn8search9

[R14] **Build Systems à la Carte** — entity["people","Andrey Mokhov","computer scientist"]; entity["people","Neil Mitchell","software engineer"]; entity["people","Simon Peyton Jones","computer scientist"]. Proc. ACM Program. Lang. (2018). URL: `https://www.microsoft.com/en-us/research/wp-content/uploads/2018/03/build-systems-final.pdf`. Accessed: 2026-03-05. Why it matters: clean decomposition of scheduling vs rebuilding; formal treatment of static vs dynamic dependencies; explicitly references Excel dependency extraction and shows tracing for dynamic deps—highly transferable to spreadsheets. citeturn41view1turn41view0

[R15] **Incremental Topological Sort and Cycle Detection in \~O(m√n) Expected Total Time** — entity["people","Aaron Bernstein","computer scientist"]; entity["people","Shiri Chechik","computer scientist"]. Preprint (2018). URL: `https://wordpress.cs.rutgers.edu/aaronbernstein-cs-rutgers-edu/wp-content/uploads/sites/43/2018/12/Dynamic-Cycle-Detection.pdf`. Accessed: 2026-03-05. Why it matters: modern dynamic bounds for incremental cycle detection/topo maintenance; informs later-stage optimization choices. citeturn24view1

[R16] **A New Approach to Incremental Topological Ordering** — entity["people","Michael A. Bender","computer scientist"]; entity["people","Jeremy T. Fineman","computer scientist"]; entity["people","Seth Gilbert","computer scientist"]. SODA (2009). URL: `https://www3.cs.stonybrook.edu/~bender/newpub/BenderFiGi-soda09.pdf`. Accessed: 2026-03-05. Why it matters: representative incremental-topo approach with stated total cost \(O(n^2 \log n)\); helps evaluate feasibility vs complexity for spreadsheets. citeturn20view0

[R17] **A Dynamic Topological Sort Algorithm for Directed Acyclic Graphs** — entity["people","David J. Pearce","computer scientist"]; entity["people","Paul H. J. Kelly","computer scientist"]. ACM JEA (2006). URL: `https://www.doc.ic.ac.uk/~phjk/Publications/DynamicTopoSortAlg-JEA-07.pdf`. Accessed: 2026-03-05. Why it matters: practical fully dynamic topo maintenance perspective with empirical study; suggests why “simple” can outperform theoretically better methods in practice. citeturn22view0

[R18] **Excel Recalculation** — entity["company","Microsoft","software company"]. Official documentation (updated 2022). URL: `https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation`. Accessed: 2026-03-05. Why it matters: documents dependency tree → calculation chain model and chain revision behavior; anchors spreadsheet-engine scheduling concepts. citeturn6search17

[R19] **Multithreaded recalculation in Excel** — Microsoft official documentation (2022). URL: `https://learn.microsoft.com/en-us/office/client-developer/excel/multithreaded-recalculation-in-excel`. Accessed: 2026-03-05. Why it matters: official guidance on parallel calculation behavior and scheduling optimization. citeturn6search6

[R20] **Working with the calculation chain (Open XML SDK)** — Microsoft official documentation (2025). URL: `https://learn.microsoft.com/en-us/office/open-xml/spreadsheet/working-with-the-calculation-chain`. Accessed: 2026-03-05. Why it matters: clarifies that calcChain records last calculation order and not the dependency tree; important for conformance and file interoperability. citeturn6search20

[R21] **Iterative calculation settings in Excel (API / documentation)** — Microsoft documentation (Excel JS preview) and support article. URLs: `https://learn.microsoft.com/en-us/javascript/api/excel/excel.iterativecalculation?view=excel-js-preview`, `https://support.microsoft.com/en-us/office/change-formula-recalculation-iteration-or-precision-in-excel-73fc7dac-91cf-4d36-86e8-67124f6bcce4`. Accessed: 2026-03-05. Why it matters: official exposure of iterative calculation controls (enabled/maxChange/maxIteration) and multi-thread setting; anchors practical cycle semantics choices. citeturn5search15turn6search13

[R22] **Dependency graph (HyperFormula docs)** — entity["organization","Handsontable","software org"] documentation. URL: `https://hyperformula.handsontable.com/guide/dependency-graph.html`. Accessed: 2026-03-05. Why it matters: explicit DAG/topological-order framing and practical spreadsheet-engine guidance. citeturn52search0

[R23] **INDIRECT function discussion (HyperFormula)** — Handsontable/HyperFormula GitHub discussion (2022). URL: `https://github.com/handsontable/hyperformula/discussions/870`. Accessed: 2026-03-05. Why it matters: candid engineering statement that `INDIRECT` requires a more dynamic architecture; directly relevant to design staging and risk assessment. citeturn52search4

[R24] **Spreadsheet Implementation Technology in C# (Corecalc/Funcalc)** — entity["people","Peter Sestoft","computer scientist"]. Technical report (2012). URL: `https://studwww.itu.dk/~sestoft/corecalc/spreadsheet-20120115.pdf`. Accessed: 2026-03-05. Why it matters: deep practical+theoretical analysis of support graphs, minimal recalculation roots, volatile functions, and the challenges of maintaining evaluation orders incrementally. citeturn44view0turn44view1turn53view0

[R25] **On the semantics for spreadsheets with sheet-defined functions** — entity["people","Alexander Asp Bock","computer scientist"] et al. *Journal of Computer Languages* (2020). URL: `https://pure.itu.dk/ws/files/85284728/1_s2.0_S2590118420300204_main.pdf`. Accessed: 2026-03-05. Why it matters: operational semantics aiming to define results independent of evaluation mechanism, explicitly considering nondeterministic functions; provides a semantics anchor for deterministic replay. citeturn46view0turn46view1

[R26] **ClosedXML formula calculation engine docs (dependency graph & R-tree)** — ClosedXML project documentation. URL: `https://github.com/ClosedXML/ClosedXML/wiki/Formula-calculation-engine`. Accessed: 2026-03-05. Why it matters: concrete design for dependency tracking including area dependencies indexed via R-tree; highly transferable implementation guidance. citeturn4search5

[R27] **HyperFormula API: getCellPrecedents and range optimizations** — Handsontable docs. URL: `https://hyperformula.handsontable.com/api/classes/hyperformula.html`. Accessed: 2026-03-05. Why it matters: documents that precedent reporting depends on dependency-graph optimizations for large ranges, reinforcing the need for compact range dependency representations. citeturn52search3

[R28] **OpenFormula specification (OpenDocument formula format overview)** — entity["organization","OASIS Open","standards body"]. ODF 1.2 Part 2 (HTML). URL: `https://docs.oasis-open.org/office/v1.2/OpenDocument-v1.2-part2.html`. Accessed: 2026-03-05. Why it matters: standards-track description of formula syntax/semantics for interoperability; useful baseline for deterministic function definitions where applicable. citeturn10search3