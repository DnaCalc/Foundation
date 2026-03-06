# DAG-based incremental computation for deterministic spreadsheet engines

A deterministic spreadsheet engine's computation core is best grounded in a **hybrid architecture combining demand-driven dirty marking (Adapton-style) with height-ordered topological recomputation (Incremental-style), augmented by Pearce-Kelly dynamic topological ordering and early cutoff**. This conclusion emerges from cross-referencing 31 primary sources spanning lattice theory, self-adjusting computation, differential dataflow, build-system taxonomy, and production spreadsheet engines. The theoretical landscape is mature: Tarski fixed-point semantics handle cycles [S1], Adapton's demanded computation graphs handle dynamic dependencies [S6], and the Build Systems à la Carte taxonomy [S15] reveals that Excel's restarting-scheduler + dirty-bit design sacrifices minimality and early cutoff — deficiencies correctable with known algorithms. The path from theory to implementation is staged below with proof obligations and an empirical validation plan.

---

## 1. Executive Summary

Eight algorithm families address the core problems of a spreadsheet computation engine: dependency graph construction, incremental recomputation, dynamic dependencies, cycle handling, determinism, and optional parallelism. After triaging 31 sources across five research passes, the key findings are:

**The dominant trade-off is between eager (push) and lazy (pull) change propagation.** Eager propagation (Acar's SAC [S4]) recomputes all dependents immediately but wastes work when outputs are unobserved. Lazy propagation (Adapton [S6]) defers work until demanded but wastes graph-walking effort when many formulas change. The hybrid approach (Anchors [S25], Jane Street Incremental [S26]) resolves both degenerate cases by switching strategies based on cell state.

**Early cutoff is the single most impactful optimization missing from Excel's architecture.** Excel's dirty-bit rebuilder marks all transitive dependents before recomputation begins, precluding cutoff when intermediate values are unchanged [S15][S16]. Topological-order recomputation with value-equality checks (as in Incremental [S26]) enables cutoff naturally.

**Dynamic dependencies (INDIRECT-like behavior) require monadic scheduling.** The Build Systems framework proves that static (Applicative) tasks permit topological scheduling, while dynamic (Monadic) tasks require either restarting or suspending schedulers [S15]. Excel uses restarting; Shake uses suspending. For a new engine, a suspending scheduler with verifying traces offers minimality, early cutoff, and dynamic dependency support simultaneously — a combination no production spreadsheet engine currently implements.

**Deterministic replay requires a fixed evaluation order and pure cell functions.** All surveyed incremental systems guarantee deterministic output given deterministic inputs. The key constraint is that cell evaluation must be a pure function of its precedents, with any nondeterminism (volatile functions, external data) explicitly channeled through designated input ports with version-stamped values.

---

## 2. Method and Source Selection

Research proceeded in five explicit passes as specified. **Pass 1** (source discovery) used web search across ACM Digital Library, arXiv, DBLP, Microsoft Research, and GitHub to locate primary papers for all eight seed topics, expanding to 31 sources. **Pass 2** (theory extraction) extracted formal definitions, operator assumptions, convergence conditions, and complexity claims from each source, separating direct claims from inferences. **Pass 3** (algorithm mapping) mapped theoretical constructs to algorithm families addressing the six engine concerns. **Pass 4** (comparative evaluation) scored each family on six axes using a 1–5 scale. **Pass 5** (transfer design) proposed a staged architecture with proof obligations and an experiment plan.

Source selection criteria: primary sources (original papers, official documentation, canonical repositories) preferred over secondary treatments. Conference and journal publications at top venues (POPL, PLDI, OOPSLA, SOSP, ICFP, VLDB, SODA, SIAM) weighted highest. Workshop papers and blog posts used only when primary or when providing unique implementation insight. All URLs verified accessible as of March 5, 2026.

---

## 3. Pass 1 Results: Source Shortlist

### Tier 1 — Foundational theory (directly applicable, highest quality)

**[S1] Tarski fixed-point theorem.** Establishes that monotone functions on complete lattices have least and greatest fixed points. Provides the semantic foundation for iterative convergence on cyclic dependencies. The least fixed point can be computed by iterated application from ⊥ on finite lattices. *Quality: Definitive. Pacific J. Math 1955, 3190+ citations.*

**[S4] Acar, Blelloch, Harper — Adaptive Functional Programming.** Introduces modifiable references, dynamic dependence graphs (DDGs), and eager change propagation with O(1) dependency tracking. Proves change propagation equals from-scratch recomputation. Trace stability theory bounds propagation cost by edit distance between execution traces. *Quality: Definitive. POPL 2002, foundational SAC paper.*

**[S6] Hammer et al. — Adapton.** Introduces demanded computation graphs (DCGs) with lazy/pull-based change propagation. Two-phase algorithm: dirty (push, cheap) then propagate (pull, on demand). Handles dynamic dependencies naturally — edges created during evaluation, removed and recreated on re-evaluation. Proves from-scratch consistency. *Quality: Definitive. PLDI 2014 with artifact.*

**[S15] Mokhov, Mitchell, Peyton Jones — Build Systems à la Carte.** Provides the taxonomic framework: scheduler (topological/restarting/suspending) × rebuilder (dirty bit/verifying traces/constructive traces). Classifies Excel as restarting + dirty-bit. Formalizes static vs. dynamic dependencies via Applicative vs. Monad constraint on Task. *Quality: Definitive. ICFP 2018, JFP 2020, executable Haskell models.*

**[S14] Budiu et al. — DBSP.** Reduces incremental computation to four stream operators (lift, delay, integrate, differentiate) over abelian groups. Proves compositionality of incrementalization: (Q₁ ∘ Q₂)^Δ = Q₁^Δ ∘ Q₂^Δ. Machine-checked proofs in Lean. *Quality: Definitive. VLDB 2023 Best Paper.*

### Tier 2 — Algorithmic building blocks (directly implementable)

**[S2] Tarjan — SCC algorithm.** O(V+E) strongly connected component detection. Outputs SCCs in reverse topological order of the condensation DAG. Essential for cycle detection and partitioning cyclic subgraphs. *Quality: Definitive. SIAM J. Computing 1972, 7100+ citations.*

**[S3] Kahn — Topological sorting.** BFS-based O(V+E) topological sort. Natural wavefront parallelism: all zero-in-degree nodes at each level can execute concurrently. Cycle detection as by-product. *Quality: Definitive. CACM 1962.*

**[S20] Pearce, Kelly — Dynamic topological sort.** Handles both edge insertions and deletions. O(δ·log δ) per operation where δ is the affected region. Best practical performance on sparse graphs (typical of spreadsheets). Used in Google Abseil and TensorFlow. *Quality: Primary. JEA 2006.*

**[S21] Bender, Fineman, Gilbert, Tarjan — Incremental cycle detection.** State-of-the-art theoretical bounds: O(m·min{m^{1/2}, n^{2/3}}) total for sparse graphs, O(n² log n) for dense. Simpler than predecessors. *Quality: Primary. SODA 2009, TALG 2015.*

**[S26] Jane Street Incremental.** Production-grade implementation of SAC with height-based topological recomputation, observer/necessary tracking, and early cutoff. Demonstrates ~30ns per-node overhead. Seven iterations of design refinement. *Quality: Production-validated. Open-source OCaml.*

### Tier 3 — Supporting theory and implementations

**[S9] Cai et al. — Incremental lambda calculus.** Change structures generalize abelian groups. Derivatives of programs via static transformation. Machine-checked in Agda. *Quality: Primary. PLDI 2014.*

**[S11] Abadi, McSherry, Plotkin — Foundations of Differential Dataflow.** Möbius inversion on partially ordered timestamps. Extends incremental semantics to nested iteration. *Quality: Primary. FoSSaCS 2015.*

**[S12] Murray et al. — Naiad.** Timely dataflow with structured loops, progress tracking, sub-millisecond iteration latency. Formally verified protocol. *Quality: Primary. SOSP 2013 Best Paper.*

**[S8] Hammer et al. — Nominal Adapton.** First-class names for stable memo-matching under structural changes. O(1) per affected element for list operations vs. O(prefix) for standard Adapton. *Quality: Primary. OOPSLA 2015.*

**[S25] Lord — Anchors.** Hybrid Adapton + Incremental on same graph. Three-state machine (clean/dirty/necessary). Eliminates degenerate cases of both pure approaches. *Quality: Blog + open-source Rust implementation. Not peer-reviewed but contains novel algorithmic insight.*

**[S16] Microsoft — Excel Recalculation.** Authoritative description of Excel's three-stage recalc (dependency tree → calc chain → evaluation), volatile function handling, iterative calculation for cycles. *Quality: Official documentation, somewhat high-level.*

**[S17] Sestoft — Spreadsheet Implementation Technology.** Definitive academic treatment of spreadsheet implementation. Corecalc/Funcalc prototypes in C#. Support graph maintenance, cell state machine for cycle detection. *Quality: Primary. MIT Press 2014.*

**[S18] HyperFormula documentation.** Hierarchical range nodes as first-class graph entities for O(n) vs. O(n²) edge reduction. Topological scheduling. Conservative static cycle detection. *Quality: Production documentation, open-source TypeScript.*

Additional sources [S5][S7][S10][S13][S19][S22][S23][S24][S27][S28][S29][S30][S31] provide supplementary depth and are cataloged in the annotated bibliography.

---

## 4. Pass 2 Results: Theory and Mathematics

### 4.1 Fixed-point semantics for cyclic dependencies

**Tarski's theorem [S1]** states: Let (A, ≤) be a complete lattice and f : A → A be monotone (order-preserving). Then the set of fixed points of f is non-empty and forms a complete lattice. The least fixed point is **lfp(f) = ⊔{x ∈ A | x ≤ f(x)}** and can be computed iteratively as the limit of ⊥, f(⊥), f²(⊥), ... which stabilizes in at most |A| steps for finite lattices.

**Application to spreadsheets (inference):** Model a spreadsheet with n cells as a product lattice L = L₁ × L₂ × ... × Lₙ where each Lᵢ is the lattice of possible cell values extended with ⊥ (unevaluated) and ⊤ (error). The evaluation function F : L → L maps the current cell-value vector to the next by evaluating each formula. If F is monotone on this lattice, iterative evaluation converges to the least fixed point. For acyclic subgraphs, one evaluation pass suffices. For cyclic subgraphs (SCCs), iteration within the SCC converges if cell functions are monotone on the information ordering.

**Convergence guarantee:** For finite lattices, convergence is guaranteed in at most height(L) iterations. Excel's iterative calculation (max 100 iterations, convergence threshold 0.001 [S16]) is a practical approximation of this theoretical guarantee. **Note (inference):** Most spreadsheet functions (arithmetic, string ops) are NOT monotone on the standard numeric ordering, so Tarski's theorem applies only when the lattice is the *information ordering* (⊥ ≤ v for all values v, incomparable otherwise) or when the user's iterative formulas happen to be monotone. Excel's convergence check is purely numeric-threshold-based, not lattice-theoretic.

### 4.2 Graph-theoretic foundations

**Tarjan's SCC algorithm [S2]** computes all strongly connected components in O(V+E) via a single DFS. Each vertex carries an index (discovery time) and lowlink (smallest index reachable via back edges). A vertex v where lowlink(v) = index(v) is the root of an SCC; all stack vertices above v form that SCC. SCCs are produced in **reverse topological order** of the condensation DAG.

**Kahn's algorithm [S3]** produces a topological ordering by repeatedly extracting zero-in-degree vertices. Time O(V+E). Naturally supports wavefront parallelism: all vertices at the same "level" (distance from sources) can be processed concurrently.

**Dynamic topological ordering [S19][S20][S21][S22][S23]** maintains a valid topological order under edge insertions and deletions. The key results form a complexity hierarchy:

| Algorithm | Total time (m insertions) | Practical notes |
|-----------|--------------------------|-----------------|
| MNR [S19] | O(mn) | Simplest; insertion-only |
| AHRSZ [S23] | O(m^{3/2} log n) | Uses Dietz-Sleator order maintenance |
| Haeupler et al. [S22] | O(m^{3/2}) sparse, O(n^{5/2}) dense | Tight lower bound for local algorithms |
| Bender-Fineman-Gilbert-Tarjan [S21] | O(m·min{m^{1/2}, n^{2/3}}) sparse, O(n² log n) dense | Best theoretical bounds |
| Pearce-Kelly [S20] | O(δ·log δ + edges(δ)) per insertion | Best practical on sparse graphs |
| Bernstein-Chechik [S27] | Õ(m√n) expected | Randomized; best for medium density |

**Spreadsheet relevance (inference):** Spreadsheet dependency graphs are typically sparse (average cell references 2–5 other cells). Pearce-Kelly [S20] is the algorithm of choice: it handles both insertions and deletions, detects cycles on insertion, and has the best empirical performance on sparse graphs. For a spreadsheet with n cells and m dependency edges where m = O(n), the amortized cost per formula edit is O(δ·log δ) where δ is the local affected region — typically very small for single-cell edits.

### 4.3 Self-adjusting computation and demand-driven propagation

**Self-adjusting computation (SAC) [S4][S5]** introduces three primitives: `mod` (create modifiable reference), `read` (track dependency), `write` (mutate). Execution builds a **dynamic dependence graph (DDG)** where nodes are modifiable references and edges are read operations. Change propagation processes affected readers in timestamp order using a priority queue, re-executing each and stopping propagation when output values are unchanged.

**Key invariant:** From-scratch consistency — change propagation produces identical results to complete re-evaluation. Formally proven via the AFL language semantics [S4].

**Trace stability [S5][S31]:** The edit distance between execution traces on inputs I and I' bounds the change propagation cost. For many algorithms (sorting, convex hulls, dynamic trees), trace stability matches the best known special-purpose dynamic algorithms within constant factors.

**Adapton [S6]** replaces SAC's totally-ordered DDG with a **partially-ordered demanded computation graph (DCG)** using two node types (reference cells and thunks) and a two-phase algorithm:
1. **Dirtying (push):** When a ref cell is mutated, traverse downward marking dependents dirty. Cost: O(number of transitively dirty nodes).
2. **Propagation (pull):** When a thunk is forced, traverse upward re-evaluating dirty ancestors. Undemanded thunks are never re-evaluated.

**Critical capability for dynamic dependencies:** Dependencies are discovered at runtime via `get` and `force` operations within thunk evaluation. When a thunk is re-evaluated, old edges are removed and new edges created by the fresh execution. This directly models INDIRECT-like behavior: if `INDIRECT("A" & B1)` is evaluated and B1=5, edges to both B1 and A5 are created. When B1 changes to 7, the thunk is re-evaluated, the old edge to A5 is removed, and a new edge to A7 is created [S6].

**Nominal Adapton [S8]** solves the naming problem: standard Adapton uses structural matching for memo-reuse, causing O(prefix) recomputation when elements are inserted mid-list. First-class names (with deterministic `fork` for tree-structured namespaces) enable O(1) per affected element.

### 4.4 Algebraic incrementalization

**Incremental lambda calculus [S9]** defines a **change structure** (V, Δ, ⊕, ⊖) where Δᵥ is the set of valid changes for value v, ⊕ applies a change, and ⊖ computes differences, satisfying **v ⊕ (u ⊖ v) = u**. The **derivative** of f is f' such that **f(a ⊕ da) = f(a) ⊕ f'(a, da)**. The `Derive` transformation is a source-to-source program transformation producing derivatives. Proofs are machine-checked in Agda.

**DBSP [S14]** specializes this to streams over abelian groups using four operators: **lift** (pointwise application), **delay** z⁻¹, **integration** I (running sum), and **differentiation** D (successive differences). The core identity **D ∘ I = I ∘ D = id** enables mechanical incrementalization: Q^Δ = D ∘ ↑Q ∘ I. Crucially, **(Q₁ ∘ Q₂)^Δ = Q₁^Δ ∘ Q₂^Δ** — incrementalization distributes over composition. Data is represented as **Z-sets** (integer-weighted multisets) forming an abelian group. Proofs are machine-checked in Lean.

**Differential Dataflow [S10][S11]** extends to partially ordered timestamps using **Möbius inversion**. For a locally finite partial order T: S_T(f)(t) = Σ_{t'≤t} f(t') and δ_T(f)(t) = Σ_{t'≤t} μ_T(t',t)·f(t'), with S_T ∘ δ_T = id. Product partial orders T₁ × T₂ model nested iteration.

**Relationship (inference):** ILC's change structures generalize DBSP's abelian groups. DBSP's four-operator framework is a specialization of ILC to synchronous streams over groups. Both provide a "chain rule" for incremental composition, but DBSP's version is mechanically applicable while ILC requires per-primitive derivative plugins.

### 4.5 Build-system taxonomy applied to spreadsheets

**Build Systems à la Carte [S15]** models computations as `Task c k v` where constraint `c` is `Applicative` (static dependencies extractable before execution) or `Monad` (dynamic dependencies discovered during execution). Excel is classified as **Restarting scheduler + Dirty-bit rebuilder**: it maintains a linear calc chain, aborts and restarts when encountering uncomputed dependencies, and uses transitive dirty-bit closure for rebuild decisions.

**Key deficiencies identified for Excel's design [S15][S25]:**
- **No early cutoff:** Dirty bits are transitively closed before recomputation begins, so unchanged intermediate values still trigger downstream recomputation.
- **Not minimal:** Volatile/INDIRECT cells are always recomputed regardless of actual dependency changes.
- **No verifying traces:** Cannot detect that a recomputed cell produced the same hash, preventing content-addressable caching.

**The unexplored optimum for spreadsheets (inference):** A **suspending scheduler + verifying-trace rebuilder** would provide minimality (only recompute cells whose actual inputs changed), early cutoff (stop propagation when values unchanged), and dynamic dependency support (suspending scheduler handles monadic tasks). No production spreadsheet engine currently implements this combination. Shake [S15] demonstrates it for build systems.

---

## 5. Pass 3 Results: Algorithm Family Map

### Family A — Static topological recomputation

**Algorithms:** Kahn's topological sort [S3] for initial ordering; full re-sort on structural changes. Dirty-flag propagation from changed inputs; recompute in topological order.

**Scheduling:** Compute full topological order of dependency DAG. Mark dirty cells and all transitive dependents. Evaluate in topological order. Supports wavefront parallelism (all cells at same topological level evaluated concurrently).

**Complexity:** O(V+E) for topological sort. O(dirty cells + their edges) for recomputation. Early cutoff: when a cell's recomputed value equals its previous value, do not enqueue its dependents.

**Dynamic dependencies:** Not supported for Applicative-only tasks. INDIRECT-like functions require fallback to volatility (always recompute) or hybrid with Family B/C.

**Engineering constraints:** Simple to implement. Requires full dependency graph in memory. Topological sort must be recomputed when the graph structure changes (formula edits). Height assignment enables heap-based incremental recomputation (Jane Street Incremental [S26]).

### Family B — Restarting scheduler with calc chain (Excel model)

**Algorithms:** Maintain a linear calc chain from previous evaluation. Process cells in chain order. On dependency miss, abort current cell, move dependency earlier in chain, restart from it [S15][S16].

**Scheduling:** Dynamic ordering — the chain self-corrects over repeated evaluations. After a few builds, the chain stabilizes to a valid topological order. Dirty-bit closure before evaluation.

**Complexity:** O(dirty cells × average restart depth). Worst case O(n²) per recalculation for adversarial dependency patterns, but amortized O(n) for stable chains.

**Dynamic dependencies:** Natively supported — restarting naturally discovers dependencies at evaluation time. INDIRECT works because the evaluator simply follows whatever cell reference the formula produces; if the dependency is uncomputed, restart.

**Engineering constraints:** No early cutoff. Volatile-function over-approximation. Chain convergence requires multiple evaluations for new formulas. Multi-threaded recalculation possible for independent chain segments [S16].

### Family C — Demand-driven (Adapton-style) with dirty marking

**Algorithms:** Adapton's two-phase D2CP [S6]. On input mutation: push dirty flags downstream (O(reachable dependents)). On output demand: pull by re-evaluating dirty ancestors in evaluation order. miniAdapton [S7] provides a ~50-line reference implementation.

**Scheduling:** No explicit topological sort. Evaluation order determined by demand (force) operations. Inherently recursive/suspending.

**Complexity:** Dirtying: O(|dirty subgraph|). Propagation: O(work for demanded dirty thunks). If all outputs are demanded, equivalent to SAC. If few outputs demanded, dramatically cheaper.

**Dynamic dependencies:** Naturally supported. DCG edges created during thunk evaluation, removed and recreated on re-evaluation. Ideal for INDIRECT-like behavior.

**Engineering constraints:** Graph-walking overhead for dirtying can exceed recomputation cost for cheap cells [S25]. No explicit parallelism model. Garbage collection of DCG nodes requires care (Rust implementation avoids GC overhead [S6]).

### Family D — Hybrid Adapton + Incremental (Anchors model)

**Algorithms:** Three-state cell machine: **clean** (unnecessary, not dirty), **dirty** (input changed, needs recomputation), **necessary** (required by observer, in recomputation heap) [S25]. Dirty marking (Adapton algorithm) on clean/unnecessary cells. Height-ordered heap recomputation (Incremental algorithm) on necessary cells. Early cutoff: dependents enqueued only if recomputed value changes.

**Scheduling:** Observers determine necessary subgraph. On input change, dirty-mark downstream. On stabilize, recompute necessary dirty cells in height order via min-heap.

**Complexity:** O(dirty subgraph for marking) + O(necessary dirty cells × log n for heap operations). Early cutoff reduces propagation in practice. Avoids both degenerate cases: Adapton's wasted marking when all cells are observed, and Incremental's wasted graph-walking when observations shift.

**Dynamic dependencies:** Supported via `bind` (monadic restructuring). When a cell's formula dynamically determines its dependencies, re-evaluation discovers new dependencies and height must be updated (dynamic topological sort for backward edges [S26]).

**Engineering constraints:** Most complex to implement. Requires height maintenance, observer tracking, dirty-flag propagation, and heap-based recomputation. Production-validated at Jane Street [S26]. Rust implementation (Anchors [S25]) demonstrates feasibility.

### Family E — Differential / algebraic incrementalization (DBSP model)

**Algorithms:** Represent cell values as elements of an abelian group. Maintain running state via integration (I). On input change, compute difference (D), propagate differences through lifted operators. Incrementalization is mechanical: Q^Δ = D ∘ ↑Q ∘ I [S14].

**Scheduling:** Topological evaluation of the differenced computation. Each operator receives input differences and produces output differences.

**Complexity:** Proportional to change size, not data size, when operators have efficient differential implementations. Integration operators maintain state (space-time trade-off).

**Dynamic dependencies:** Not naturally supported. DBSP and Differential Dataflow operate on fixed dataflow graphs. Dynamic graph restructuring requires meta-level changes.

**Engineering constraints:** Requires all cell functions to have well-defined differential forms over the chosen group. Standard spreadsheet operations (arithmetic, aggregation) fit naturally; string operations and conditionals require careful encoding. Best suited for the aggregation/streaming update lane rather than the core recalc engine.

### Family F — Dynamic graph maintenance

**Algorithms:** Pearce-Kelly [S20] for maintaining topological order under edge insertion/deletion with cycle detection. Bender-Fineman-Gilbert-Tarjan [S21] for theoretical optimality on dense graphs.

**Scheduling:** Not a full recalculation strategy but an auxiliary algorithm maintaining the topological order as formulas change. Combined with Family A or D for actual recomputation.

**Complexity:** Pearce-Kelly: O(δ·log δ + edges(δ)) per edge operation. For sparse spreadsheet graphs with local edits, δ is typically O(1)–O(log n).

**Dynamic dependencies:** The topological order is updated when edges change. When INDIRECT resolves to a new target, the old edge is deleted and new edge inserted; PK handles both.

**Engineering constraints:** Simple implementation (adopted in Google Abseil, TensorFlow [S20]). Integrates naturally with Family A or D as the graph-maintenance layer.

---

## 6. Pass 4 Results: Comparative Scoring Matrix

Each family scored 1–5 on six axes (5 = best).

| Axis | A: Static Topo | B: Restarting (Excel) | C: Adapton | D: Hybrid | E: Differential | F: Dynamic Graph |
|------|:-:|:-:|:-:|:-:|:-:|:-:|
| **Semantic clarity** | 5 | 3 | 4 | 4 | 5 | 4 |
| **Proofability** | 5 | 2 | 4 | 3 | 5 | 4 |
| **Implementation complexity** | 5 | 3 | 3 | 2 | 2 | 4 |
| **Runtime potential** | 3 | 3 | 4 | 5 | 4 | n/a |
| **Dynamic-reference suitability** | 1 | 5 | 5 | 5 | 1 | 4 |
| **Determinism/replay** | 5 | 4 | 5 | 5 | 5 | 5 |

**Rationale by axis:**

**Semantic clarity** measures how well-defined the computation model is. Static topological (A) and differential (E) have clean mathematical definitions. Restarting (B) depends on operational details of chain ordering. Adapton (C) and hybrid (D) have formal calculi (λ_cddic [S6]) but complex operational semantics.

**Proofability** measures amenability to formal verification. Differential (E) has machine-checked proofs in Lean [S14]. Static topological (A) has straightforward correctness proofs. Adapton (C) has from-scratch consistency proofs [S6]. Excel's restarting model (B) has no formal proof of minimality or correctness beyond the Build Systems paper's classification. Hybrid (D) lacks formal treatment.

**Implementation complexity** measures engineering effort. Static topological (A) is simplest (standard library algorithms). Dynamic graph (F) is well-understood with reference implementations. Excel's restarting (B) requires careful chain management. Adapton (C) requires DCG maintenance. Hybrid (D) is most complex (three-state machine, height maintenance, observer tracking, heap). Differential (E) requires algebraic infrastructure for all cell functions.

**Runtime potential** measures best-case performance. Hybrid (D) achieves optimal performance across workload patterns by avoiding degenerate cases [S25][S26]. Adapton (C) excels when few outputs are observed. Differential (E) excels for streaming aggregation. Static topological (A) and restarting (B) lack early cutoff.

**Dynamic-reference suitability** measures handling of INDIRECT-like behavior without resorting to volatility. Restarting (B), Adapton (C), and hybrid (D) discover dependencies at evaluation time. Static topological (A) and differential (E) require static dependency graphs; INDIRECT forces volatility fallback.

**Determinism/replay** measures compatibility with deterministic replay requirements. All families except restarting (B) produce identical evaluation orders given identical inputs. Restarting (B) scores 4 because the calc chain depends on evaluation history, though it converges to a deterministic steady state.

**Overall recommendation (inference):** Family D (hybrid) with Family F (dynamic graph maintenance) as the graph-maintenance substrate provides the best overall profile: **5 on runtime potential, 5 on dynamic references, 5 on determinism**, with manageable implementation complexity. Family E (differential) should be adopted for the streaming/external update lane where its algebraic compositionality shines.

---

## 7. Pass 5 Results: Transfer to Spreadsheet Engine

### Now — High-confidence baseline (0–3 months)

**Architecture:** Dependency DAG with Pearce-Kelly dynamic topological maintenance [S20] + height-ordered recomputation heap with early cutoff + Tarjan SCC for cycle detection [S2].

**Components:**
1. **Cell state machine:** Four states — `clean`, `dirty`, `computing`, `error`. Inspired by Sestoft's Corecalc [S17] and miniAdapton [S7].
2. **Dependency graph:** Adjacency lists storing both precedents (edges from formula to referenced cells) and dependents (reverse edges for dirty propagation). Ranges as first-class nodes following HyperFormula's approach [S18] for O(n) edge reduction on overlapping ranges.
3. **Topological order maintenance:** Pearce-Kelly algorithm [S20] updates the topological order on every formula edit (edge insertion/deletion). Cycle detection integrated: inserting edge u→v where ord(v) < ord(u) triggers affected-region search; if v is reachable from u, cycle detected.
4. **Recomputation:** Min-heap keyed by topological height. On input change, mark cell dirty and enqueue. Dequeue minimum-height cell, evaluate, apply **early cutoff** (if new value = old value, do not enqueue dependents). Continue until heap empty.
5. **Cycle policy:** Cells in non-trivial SCCs receive `#CYCLE!` error by default. Optional iterative mode: extract SCC subgraph, iterate evaluation within SCC up to configurable maximum iterations or convergence threshold (justification: Tarski [S1] for monotone cases; pragmatic convergence check for non-monotone).
6. **Determinism:** Fixed evaluation order (heap order = topological order). All cell functions must be pure functions of precedent values. Volatile functions (NOW, RAND) receive values through explicit input ports with version stamps, not by calling system APIs during evaluation.

**Dynamic dependencies (INDIRECT) — initial approach:** Mark INDIRECT-containing cells as volatile (always dirty), following Excel's strategy [S16]. This is correct but not minimal. Addressed in "Next" phase.

**Parallel scheduling — initial approach:** Wavefront parallelism. Cells at the same topological height are independent and can be evaluated concurrently. Partition the heap into height levels; process each level in parallel. Requires thread-safe cell reads but no synchronization within a level.

### Next — Medium-risk high-value (3–9 months)

**Enhancement 1: Demand-driven evaluation with observer tracking.** Add observer markers on output cells (visible viewport, chart data sources, external API consumers). Maintain the "necessary" set: cells transitively required by any observer. During stabilization, only recompute necessary dirty cells. This transforms the engine from Family A to Family D (hybrid). **Justification:** Jane Street Incremental [S26] demonstrates ~30ns per-node overhead and dramatic savings when observing partial output. Anchors [S25] demonstrates the three-state machine eliminates degenerate cases.

**Enhancement 2: Dynamic dependency tracking without volatility.** Replace INDIRECT volatility with Adapton-style dynamic edge management. When evaluating a cell containing INDIRECT: (a) record all cells read during evaluation as precedents, (b) on re-evaluation, diff old precedent set against new and update edges via Pearce-Kelly. Only re-evaluate when actual precedents are dirty, not on every cycle. **Justification:** Adapton [S6] proves from-scratch consistency for this approach. **Risk:** Requires tracking the precedent set per cell and diffing on re-evaluation; overhead may exceed volatility cost for cells with many dynamic references.

**Enhancement 3: Verifying traces for rebuild decisions.** Replace dirty bits with input-hash verification. Before recomputing a cell, check whether the hashes of its actual inputs match the recorded hashes from the previous evaluation. If all match, skip recomputation (the cell is verified clean). This provides a second layer of early cutoff: even cells marked dirty by conservative propagation can be skipped if their inputs are actually unchanged. **Justification:** Build Systems à la Carte [S15] identifies this as the key advantage of Shake-style verifying traces over Excel-style dirty bits.

**Enhancement 4: Streaming external update lane.** For cells depending on external data feeds (stock prices, sensor data), implement a DBSP-inspired differential pipeline [S14]. External updates arrive as (key, old_value, new_value) triples. The difference is injected at the input port and propagated through the dependency subgraph. Aggregation functions (SUM, AVERAGE, COUNT) maintain incremental state using inverse operations where available (SUM: add new − old; COUNT: add 1 or −1). **Justification:** DBSP's compositionality theorem guarantees correctness of incremental aggregation.

### Later — Advanced/research lane (9+ months)

**Research direction 1: Nominal memoization for structural edits.** When rows/columns are inserted or deleted, cell references shift and many formulas are "different" despite being structurally identical with offset. Nominal Adapton's [S8] first-class names could provide stable identity across structural edits, enabling memo-reuse. **Risk:** Requires designing a naming scheme for spreadsheet cells that is stable under insert/delete operations.

**Research direction 2: Algebraic incrementalization of cell functions.** Derive differential forms for all built-in functions using ILC's Derive transformation [S9]. For each primitive function, implement its derivative: e.g., Derive(SUM)(old_values, changes) = SUM(changes). This would enable fully algebraic incremental propagation without re-evaluating cell formulas from scratch. **Risk:** Not all spreadsheet functions have efficient derivatives (string operations, LOOKUP, conditionals require careful treatment).

**Research direction 3: Certified recalc core.** Extract the core recalculation algorithm to a language with dependent types (Lean, Agda, or Coq) and prove from-scratch consistency, determinism, and termination. DBSP's Lean proofs [S14] and Adapton's Agda formalization attempts [S8] provide starting points. **Risk:** High effort; proof engineering for dynamic graph operations is challenging.

---

## 8. Candidate Formal Proof Obligations

**P1. From-scratch consistency.** For all input sequences I₁, I₂, ..., Iₖ and any observation point t, the incremental engine's output equals the result of evaluating all formulas from scratch on the current input state. Formally: ∀t. incremental_eval(I₁...Iₜ) = from_scratch_eval(state(I₁...Iₜ)). *Proof strategy:* Adapt Adapton's from-scratch consistency proof [S6] to the cell/formula domain. Key lemma: after stabilization, every necessary cell's value equals its formula applied to its current precedent values.

**P2. Termination of acyclic recomputation.** For any acyclic dependency graph and any finite set of dirty cells, the recomputation heap empties in finite time. Formally: the heap size is bounded by the number of dirty necessary cells, and each dequeue reduces heap size by at least one. *Proof strategy:* Induction on heap size. Each cell is enqueued at most once per stabilization (the monotonic height ordering prevents re-enqueueing).

**P3. Cycle detection soundness and completeness.** (a) Soundness: if Pearce-Kelly reports a cycle on edge insertion u→v, then a directed cycle containing u and v exists. (b) Completeness: if inserting u→v creates a cycle, Pearce-Kelly reports it. *Proof strategy:* Follows from Pearce-Kelly's correctness proof [S20], which shows the affected-region search discovers all vertices between v and u in the current topological order.

**P4. Early cutoff correctness.** If a cell c is recomputed and its new value equals its old value, then not propagating dirty to c's dependents preserves from-scratch consistency. *Proof strategy:* If value(c) is unchanged, any dependent d's formula applied to its current precedent values (including c) yields the same result as before c was "recomputed." Formal argument by induction on topological height.

**P5. Deterministic replay.** For identical input sequences, the engine produces identical output sequences and identical intermediate cell values at each step. *Proof strategy:* Show that the evaluation order (heap extraction order) is a deterministic function of the dependency graph and dirty set. Height ordering is unique given unique height assignment; tie-breaking by cell identifier ensures total order.

**P6. Iterative convergence for monotone cyclic subgraphs.** For an SCC where all cell functions are monotone on a finite lattice, iterative evaluation converges to the least fixed point in at most height(L) iterations. *Proof strategy:* Direct application of Tarski's constructive characterization [S1]. The sequence ⊥, F(⊥), F²(⊥), ... is ascending and bounded, hence convergent.

---

## 9. Empirical Experiment Plan

### Experiment 1: Baseline performance characterization

**Objective:** Measure recomputation latency as a function of graph size (n cells), change size (k dirty inputs), and graph density (average degree d). **Setup:** Generate random DAGs with n ∈ {10³, 10⁴, 10⁵, 10⁶}, d ∈ {2, 5, 10, 20}. Formulas: simple arithmetic (SUM of precedents). Change k ∈ {1, 10, 100, 1000} random input cells. **Metric:** Wall-clock time for stabilization. Compare: (a) full from-scratch evaluation, (b) static topological recomputation without early cutoff, (c) with early cutoff, (d) hybrid with observer tracking (observe 10% of cells). **Expected result:** Early cutoff provides 2–10× speedup for deep graphs with low change rates. Observer tracking provides n/observed ratio speedup.

### Experiment 2: Dynamic dependency overhead

**Objective:** Measure the cost of Adapton-style dynamic edge management vs. volatility for INDIRECT-like cells. **Setup:** Workbook with n=10⁵ cells, p% containing INDIRECT formulas (p ∈ {1, 5, 10, 25}). Change one input that affects an INDIRECT target. **Metric:** Recomputation time and number of cells evaluated. Compare: (a) all INDIRECT cells volatile (Excel strategy), (b) dynamic edge tracking with precedent-set diffing. **Expected result:** Dynamic tracking evaluates O(affected) cells; volatility evaluates O(p·n) cells. Break-even when per-cell tracking overhead × affected ≈ evaluation cost × p·n.

### Experiment 3: Early cutoff effectiveness

**Objective:** Quantify how often early cutoff prevents unnecessary propagation in realistic workloads. **Setup:** Use financial model workbooks (publicly available templates) with 10³–10⁵ formulas. Change single input cells and measure the fraction of dirty cells that are actually recomputed vs. cut off. **Metric:** Cutoff ratio = (cells marked dirty − cells actually recomputed) / cells marked dirty. **Expected result:** For deep formula chains where intermediate values are insensitive to small input changes, cutoff ratios of 50–90% [inference from S25][S26].

### Experiment 4: Parallel wavefront scalability

**Objective:** Measure parallel speedup of height-level wavefront execution. **Setup:** DAGs with varying width (maximum cells at any single height level) and depth. Thread count ∈ {1, 2, 4, 8, 16}. **Metric:** Speedup vs. single-threaded. **Expected result:** Near-linear speedup for wide, shallow graphs (many cells at each level). Minimal speedup for deep, narrow graphs (serialized by height). Puncalc [S24] achieved **16× speedup on 48 cores** for favorable workloads.

### Experiment 5: Pearce-Kelly vs. full re-sort

**Objective:** Measure incremental topological order maintenance cost vs. full Kahn re-sort on formula edits. **Setup:** Stable workbook with n=10⁵ cells. Perform m ∈ {1, 10, 100, 1000} random formula edits (each adding/removing 1–3 dependency edges). **Metric:** Time per edit for PK update vs. full Kahn sort. **Expected result:** PK is O(δ) per edit where δ ≪ n; Kahn is O(n+m_total) per sort. For single edits, PK should be 100–1000× faster.

### Experiment 6: Conformance / deterministic replay validation

**Objective:** Verify that the engine produces bit-identical outputs across: (a) single-threaded vs. multi-threaded execution, (b) different edit orderings that reach the same final state, (c) save/reload/replay cycles. **Setup:** Record a trace of 1000 edits. Replay with different thread counts and verify cell values match. Permute edit order for commutative edit pairs and verify final state matches. **Metric:** Any divergence is a conformance bug. Zero tolerance.

---

## 10. Risks, Contradictions, and Open Questions

### Contradictions across sources

**Early cutoff and dirty bits are fundamentally incompatible.** Build Systems à la Carte [S15] and the Anchors analysis [S25] agree that dirty-bit rebuilders cannot support early cutoff because dirty closure is computed before recomputation begins. This directly contradicts any attempt to add "early cutoff" to an Excel-style restarting + dirty-bit architecture without changing the rebuilder. **Resolution:** Replace dirty-bit closure with demand-driven dirtying + per-cell verification, shifting to the hybrid architecture.

**Adapton's empirical claims vs. SAC.** Adapton [S6] reports that classic SAC incurs 6.5× slowdown for mergesort while Adapton achieves 300× speedup. However, the comparison is for a specific lazy-interaction pattern where most outputs are unobserved. For fully-demanded outputs, Adapton is 1.5–3.5× slower than SAC [S6]. **Resolution:** Neither system dominates; the hybrid approach [S25][S26] is necessary for workloads with varying observation patterns.

**Tarski's theorem applicability to spreadsheet cycles.** Tarski guarantees convergence for monotone functions on complete lattices, but most spreadsheet arithmetic is NOT monotone on the standard numeric ordering. Excel's iterative calculation uses a numeric threshold, not lattice-theoretic convergence [S16]. **Resolution (inference):** For production use, iterative cycle resolution should use a convergence threshold (pragmatic) with a maximum iteration bound (safety), NOT rely on Tarski convergence unless the specific lattice and monotonicity conditions are verified per SCC.

### Open questions

**Q1: Optimal cycle policy.** Should cycles default to error (`#CYCLE!` as in HyperFormula [S18]) or iterative convergence (as in Excel [S16])? Error is safer and simpler; iteration supports legitimate use cases (e.g., goal-seeking). **Recommendation:** Default to error; provide opt-in iterative mode per SCC with explicit convergence criteria.

**Q2: Cost of dynamic dependency tracking.** No published benchmark directly compares Adapton-style dynamic edge management with Excel-style volatility for INDIRECT in a spreadsheet context. The break-even point depends on the fraction of cells with dynamic references and the cost of precedent-set diffing. Experiment 2 above is designed to answer this.

**Q3: Parallelism and determinism tension.** Wavefront parallelism (cells at same height evaluated concurrently) is deterministic only if cell functions are pure. Any cell function with observable side effects (writing to external systems, logging) creates nondeterminism. **Mitigation:** Enforce purity as a language-level constraint; side effects only via explicit output channels processed after stabilization.

**Q4: Scalability of observer tracking.** Jane Street Incremental's observer mechanism requires walking the graph to update necessary/unnecessary markings when observers change [S26]. For a spreadsheet with rapidly changing viewport (scrolling), observer churn could become expensive. **Mitigation:** Coarsen observer granularity (observe regions, not individual cells) or debounce observer updates.

**Q5: Interaction between named ranges and dynamic topological order.** Named ranges that span dynamic regions (e.g., expanding tables) create structural graph changes on data insertion. The interaction between HyperFormula-style hierarchical range nodes [S18] and Pearce-Kelly dynamic topological maintenance [S20] has not been studied. **Risk:** Range node splitting/merging could trigger large affected regions in PK.

---

## 11. Annotated Bibliography

**[S1]** Alfred Tarski. "A Lattice-Theoretical Fixpoint Theorem and Its Applications." *Pacific Journal of Mathematics* 5(2):285–309, 1955. URL: https://msp.org/pjm/1955/5-2/pjm-v5-n2-p11-s.pdf. Accessed: 2026-03-05. **Relevance:** Foundational theorem for iterative convergence of monotone operators on complete lattices. Provides semantic justification for iterative cycle resolution.

**[S2]** Robert Endre Tarjan. "Depth-First Search and Linear Graph Algorithms." *SIAM Journal on Computing* 1(2):146–160, 1972. URL: https://epubs.siam.org/doi/10.1137/0201010. Accessed: 2026-03-05. **Relevance:** O(V+E) SCC algorithm. Essential for cycle detection and condensation DAG construction.

**[S3]** Arthur B. Kahn. "Topological sorting of large networks." *Communications of the ACM* 5(11):558–562, 1962. URL: https://dl.acm.org/doi/10.1145/368996.369025. Accessed: 2026-03-05. **Relevance:** BFS-based topological sort with natural wavefront parallelism. Baseline evaluation scheduling algorithm.

**[S4]** Umut A. Acar, Guy E. Blelloch, Robert Harper. "Adaptive Functional Programming." *POPL 2002*, pp. 247–259. Extended: *TOPLAS* 28(6), 2006. URL: https://www.cs.cmu.edu/~guyb/papers/popl02.pdf. Accessed: 2026-03-05. **Relevance:** Foundational SAC paper. Introduces DDGs, modifiable references, eager change propagation. Proves from-scratch consistency.

**[S5]** Umut A. Acar. "Self-Adjusting Computation." PhD Thesis, CMU-CS-05-129, 2005. URL: https://www.cs.cmu.edu/~rwh/students/acar.pdf. Accessed: 2026-03-05. **Relevance:** Comprehensive treatment of trace stability theory, bounding change propagation cost by trace edit distance.

**[S6]** Matthew A. Hammer, Khoo Yit Phang, Michael Hicks, Jeffrey S. Foster. "Adapton: Composable, Demand-Driven Incremental Computation." *PLDI 2014*. URL: https://dl.acm.org/doi/10.1145/2594291.2594324. Accessed: 2026-03-05. **Relevance:** Introduces DCGs and demand-driven change propagation. Proves from-scratch consistency. Directly models dynamic dependencies for INDIRECT-like behavior.

**[S7]** Dakota Fisher, Matthew A. Hammer, William Byrd, Matthew Might. "miniAdapton: A Minimal Implementation of Incremental Computation in Scheme." *Scheme Workshop 2016*. URL: https://arxiv.org/abs/1609.05337. Code: https://github.com/fisherdj/miniAdapton. Accessed: 2026-03-05. **Relevance:** ~50-line pedagogical reference implementation. Demonstrates the minimal core of demand-driven incremental computation.

**[S8]** Matthew A. Hammer, Joshua Dunfield, Kyle Headley, Nicholas Labich, Jeffrey S. Foster, Michael Hicks, David Van Horn. "Incremental Computation with Names." *OOPSLA 2015*, pp. 748–766. URL: https://dl.acm.org/doi/10.1145/2814270.2814305. Accessed: 2026-03-05. **Relevance:** First-class names for stable memo-matching. Solves the prefix-recomputation problem for structural edits.

**[S9]** Yufei Cai, Paolo G. Giarrusso, Tillmann Rendel, Klaus Ostermann. "A Theory of Changes for Higher-Order Languages — Incrementalizing λ-Calculi by Static Differentiation." *PLDI 2014*, pp. 145–155. URL: https://inc-lc.github.io/resources/pldi14-ilc-author-final.pdf. Accessed: 2026-03-05. **Relevance:** Formalizes change structures and program derivatives. Machine-checked proofs in Agda.

**[S10]** Frank McSherry, Derek Murray, Rebecca Isaacs, Michael Isard. "Differential Dataflow." *CIDR 2013*. URL: https://www.cidrdb.org/cidr2013/Papers/CIDR13_Paper111.pdf. Accessed: 2026-03-05. **Relevance:** Differences on collections with partially ordered timestamps. Foundational system for incremental dataflow.

**[S11]** Martín Abadi, Frank McSherry, Gordon D. Plotkin. "Foundations of Differential Dataflow." *FoSSaCS 2015*, LNCS 9034, pp. 71–83. URL: https://homepages.inf.ed.ac.uk/gdp/publications/differentialweb.pdf. Accessed: 2026-03-05. **Relevance:** Formal algebraic foundations using Möbius inversion on partially ordered timestamps. Proves correctness of differential semantics.

**[S12]** Derek G. Murray, Frank McSherry, Rebecca Isaacs, Michael Isard, Paul Barham, Martín Abadi. "Naiad: A Timely Dataflow System." *SOSP 2013*, pp. 439–455. Best Paper. URL: https://sigops.org/s/conferences/sosp/2013/papers/p439-murray.pdf. Accessed: 2026-03-05. **Relevance:** Timely dataflow implementation with structured loops, progress tracking, sub-millisecond iteration latency.

**[S13]** Martín Abadi, Michael Isard. "Timely Dataflow: A Model." *FORTE 2015*, LNCS 9039, pp. 131–145. URL: https://research.google.com/pubs/archive/43546.pdf. Accessed: 2026-03-05. **Relevance:** Formal model of partially ordered timestamps and progress tracking in cyclic dataflow.

**[S14]** Mihai Budiu, Tej Chajed, Frank McSherry, Leonid Ryzhyk, Val Tannen. "DBSP: Automatic Incremental View Maintenance for Rich Query Languages." *PVLDB* 16(7):1601–1614, 2023. Best Paper. URL: https://www.vldb.org/pvldb/vol16/p1601-budiu.pdf. Lean proofs: https://github.com/tchajed/database-stream-processing-theory. Accessed: 2026-03-05. **Relevance:** Four-operator algebraic framework for incremental computation. Compositionality theorem. Machine-checked proofs in Lean.

**[S15]** Andrey Mokhov, Neil Mitchell, Simon Peyton Jones. "Build Systems à la Carte: Theory and Practice." *JFP* 30, E11, 2020. (Earlier: ICFP 2018.) URL: https://www.cambridge.org/core/journals/journal-of-functional-programming/article/build-systems-a-la-carte-theory-and-practice/097CE52C750E69BD16B78C318754C7A4. Accessed: 2026-03-05. **Relevance:** Definitive taxonomy of build/recalc systems. Classifies Excel. Identifies scheduler × rebuilder design space.

**[S16]** Microsoft. "Excel Recalculation." *Office Developer Documentation*. URL: https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation. Accessed: 2026-03-05. **Relevance:** Authoritative description of Excel's dependency tree, calc chain, volatile functions, iterative calculation, and multi-threaded recalculation.

**[S17]** Peter Sestoft. *Spreadsheet Implementation Technology: Basics and Extensions*. MIT Press, 2014. Technical Report: https://studwww.itu.dk/~sestoft/corecalc/ITU-TR-2011-142.pdf. Accessed: 2026-03-05. **Relevance:** Definitive academic treatment of spreadsheet implementation. Corecalc/Funcalc prototypes. Support graph maintenance and cell state machines.

**[S18]** HyperFormula Documentation. URL: https://hyperformula.handsontable.com/guide/dependency-graph.html. GitHub: https://github.com/handsontable/hyperformula. Accessed: 2026-03-05. **Relevance:** Open-source spreadsheet engine with hierarchical range nodes, topological scheduling, and conservative cycle detection.

**[S19]** Alberto Marchetti-Spaccamela, Umberto Nanni, Hans Rohnert. "Maintaining a Topological Order Under Edge Insertions." *Information Processing Letters* 59(1):53–58, 1996. **Relevance:** Pioneering work on incremental topological ordering. O(n) amortized per edge insertion.

**[S20]** David J. Pearce, Paul H. J. Kelly. "A Dynamic Topological Sort Algorithm for Directed Acyclic Graphs." *ACM Journal of Experimental Algorithmics* 11:1.7, 2006. URL: https://dl.acm.org/doi/10.1145/1187436.1210590. PDF: https://www.doc.ic.ac.uk/~phjk/Publications/DynamicTopoSortAlg-JEA-07.pdf. Accessed: 2026-03-05. **Relevance:** Best practical dynamic topological sort for sparse graphs. Handles insertions and deletions. Used in Google Abseil and TensorFlow.

**[S21]** Michael A. Bender, Jeremy T. Fineman, Seth Gilbert, Robert E. Tarjan. "A New Approach to Incremental Cycle Detection and Related Problems." *ACM TALG* 12(2):14, 2015. (Earlier: SODA 2009.) URL: https://dl.acm.org/doi/10.1145/2756553. arXiv: https://arxiv.org/abs/1112.0784. Accessed: 2026-03-05. **Relevance:** State-of-the-art theoretical bounds for incremental cycle detection. O(m·min{m^{1/2}, n^{2/3}}) for sparse graphs.

**[S22]** Bernhard Haeupler, Telikepalli Kavitha, Rogers Mathew, Siddhartha Sen, Robert E. Tarjan. "Incremental Cycle Detection, Topological Ordering, and Strong Component Maintenance." *ACM TALG* 8(1):3, 2012. URL: https://dl.acm.org/doi/10.1145/2071379.2071382. Accessed: 2026-03-05. **Relevance:** Comprehensive treatment including SCC maintenance. Tight lower bounds for local algorithms.

**[S23]** Bowen Alpern, Roger Hoover, Barry K. Rosen, Peter F. Sweeney, F. Kenneth Zadeck. "Incremental Evaluation of Computational Circuits." *SODA 1990*, pp. 32–42. URL: https://dl.acm.org/doi/pdf/10.5555/320176.320180. Accessed: 2026-03-05. **Relevance:** Original AHRSZ algorithm for dynamic topological ordering of computational circuits. Directly motivated by spreadsheet-like incremental evaluation.

**[S24]** Christian Bock, Jörg Biermann. "Puncalc: task-based parallelism and speculative reevaluation in spreadsheets." *The Journal of Supercomputing* 76(7):4977–4997, 2020. URL: https://link.springer.com/article/10.1007/s11227-019-02823-8. Accessed: 2026-03-05. **Relevance:** Parallel spreadsheet evaluation achieving 16× speedup on 48 cores. Dynamic cycle detection for INDIRECT.

**[S25]** Robert Lord. "How to Recalculate a Spreadsheet." Blog post, 2020. URL: https://lord.io/spreadsheets/. Code: https://github.com/lord/anchors. Accessed: 2026-03-05. **Relevance:** Hybrid Adapton + Incremental algorithm with three-state cell machine. Identifies and resolves degenerate cases of both pure approaches.

**[S26]** Jane Street. Incremental library. URL: https://github.com/janestreet/incremental. Blog: https://blog.janestreet.com/introducing-incremental/. Accessed: 2026-03-05. **Relevance:** Production-grade SAC implementation with height-based topological recomputation, observer/necessary tracking, and early cutoff. ~30ns per-node overhead.

**[S27]** Aaron Bernstein, Shiri Chechik. "Incremental Topological Sort and Cycle Detection in Õ(m√n) Expected Total Time." *SODA 2018*, pp. 21–34. URL: https://aaronbernstein.cs.rutgers.edu/wp-content/uploads/sites/43/2018/12/Dynamic-Cycle-Detection.pdf. Accessed: 2026-03-05. **Relevance:** Best randomized bound for medium-density graphs.

**[S28]** Andrea Brun, Sára Decova, Andrea Lattuada, Dmitriy Traytel. "Verified Progress Tracking for Timely Dataflow." *ITP 2021*, LIPIcs vol. 193. URL: https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ITP.2021.10. Accessed: 2026-03-05. **Relevance:** Isabelle/HOL verification of Naiad's progress tracking protocol.

**[S29]** Martín Abadi, Frank McSherry, Derek G. Murray, Thomas L. Rodeheffer. "Formal Analysis of a Distributed Algorithm for Tracking Progress." *FMOODS/FORTE 2013*, LNCS 7892, pp. 5–19. Accessed: 2026-03-05. **Relevance:** TLA+ specification and verification of Naiad's progress tracking.

**[S30]** Stefan Ley-Wild, Umut A. Acar, Guy Blelloch. "Non-monotonic Self-Adjusting Computation." *ESOP 2012*. **Relevance:** Extends SAC to handle non-monotonic trace changes via trace slices.

**[S31]** Umut A. Acar, Guy Blelloch, Robert Harper, Jorge Vittes, Shan Leung Maverick Woo. "Dynamizing Static Algorithms, with Applications to Dynamic Trees and History Independence." *SODA 2004*. URL: https://www.cs.cmu.edu/~guyb/papers/ABHVW04.pdf. Accessed: 2026-03-05. **Relevance:** Trace stability theory providing complexity bounds for self-adjusting computation.