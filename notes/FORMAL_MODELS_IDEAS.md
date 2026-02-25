# DNA Calc - Formal Models

The (1+4D) structure is a fundamental semantic substrate of the core engine
* Process / Global
* Workbook
* Worksheet
* Cell Grid 2D

(1 for the singleton service + 4D for the book/sheet/grid)

Each object (book/sheet/cell) can have associated augmentation object trees (simlar to WPF trees or better - Avalonia re-implementation) that can partake in calculation
Canonical example would be graph with features updated froim cell(s) and allowing mouse-drags to update cell(s) in turn
The augmentation tree partake in the formal calculation 'from the outside', so look more like add-ins than formulas
Some features implemented like this:
* Notes and Comments
* Disply formatting, conditional formatting, charts
* Tables and ListObjects
* Pictures, Shapes, Controls (anchored (rooted) to a cell, or a sheet)
* Sparklines, Pivot Tables
* Names and Name management
* UDF function maps
* Watch windows
* Macros - can write etc. - are dealt outside the core engine, like augmented trees above

A key design area will be the uniform mechanisms for layering of the augmented tree on the core engine and 'into' the calculation tree and process.
Doing this in a uniform way is a fundamental feature of DnaCalc.

We don't have aribtrary bags of calculation nodes - they are rooted as tree(s) in the 1+4D structure.

Can "Formula" be semantically part of the augmentation trees of cells (and of Names in books etc.) - yes, it must be so.

It's easy to see how the spill array is attached to its root cell. How is the spill array formally related to the interior spill cells?
So that =A3 inside A1:A5 spill range works as part of the calc tree, when it means a racalc can set / clear A3 'from A1')

--- 

The core calculation engine semantics defines no types and no functions or operations (?)
Perhaps some meta-type story - enough to define the calculation structures, and how they are updated etc..
The Cell/Scalar vs 2D Array is a fundamental semantic distinction, though.
It introduces the tension of the dynamic arrays and similar 'beyond-cell' types.

Types, values and functions (which will always include unary and binary operators) are formally (in the Lean sense) defined
We have different classes of functions:
* Pure - may not affect the calculation tree, known dependents. Includes dynamic array pure functions!!!
* Impure - may interact with the dependency tree during evaluation, may dereference unknown precedents (e.g. INDIRECT / GET.XXX) May not change structure of calc tree or write?
* Volatile is a cell state?

We must formally define the semantics of function types so that we can describe how they interact with the value types and the core engine strucutres.

==================================================================================================
## Summary from chat with ChatGPT on 24 February 2026 

# DNA Calc — Formal Spreadsheet System Model

*(Tree–Grid Hybrid, Reference Layer, Calculation Layer, Operations Model)*

---

## 0. Purpose

This document consolidates the architectural and semantic decisions made so far about the **formal model** of DNA Calc.

The goal is to:

* Define a **rigorous mathematical model** of the spreadsheet system.
* Separate concerns into clean layers.
* Enable:

  * Formal specification (Lean or similar)
  * Concurrency modeling (TLA+)
  * Deterministic recalculation
  * Clean reasoning about structural changes
  * Future optimization without semantic compromise

This is a *semantic specification*, not an implementation guide. Optimization strategies are explicitly out of scope at this level.

---

# 1. High-Level Layered Architecture

We now have a clear multi-layer conceptual model:

| Layer                    | Name                                 | Purpose                                                                |
| ------------------------ | ------------------------------------ | ---------------------------------------------------------------------- |
| **Layer 1**              | Tree–Grid Hybrid (Bedrock Structure) | Core structural model of system                                        |
| **Layer 2**              | Reference Layer                      | Directed reference graph (including region nodes and error references) |
| **Layer 3**              | Dependency / Calculation Graph       | Derived evaluation graph for recalculation                             |
| **Layer 4 (Conceptual)** | Value / Iteration State              | Current computed values and iteration state                            |
| Cross-cutting            | Operations Model                     | Controlled transformations of the system                               |

Each layer has distinct invariants.

---

# 2. Layer 1 — The Tree–Grid Hybrid Structure

This is the **bedrock semantic structure** of the spreadsheet system.

## 2.1 Core Tree Structure

We define a rooted, finite tree.

### 2.1.1 Root Node

* There exists exactly **one root node**.
* The root represents the running spreadsheet system instance.
* It has zero or more children.

### 2.1.2 Node Structure

Every node in the tree:

* Has zero or more child nodes.
* Each outgoing edge to a child carries a **label**.
* Labels come from a type `Label` equipped with a **total order**.

This guarantees:

* Deterministic child ordering.
* Stable traversal order.
* Deterministic evaluation order when required.

### 2.1.3 Formal Properties

Let:

* `Node` be the set of nodes.
* `children(n)` be a finite mapping from labels to nodes.

Then:

* For every node `n`, `children(n)` is finite.
* Labels are totally ordered.
* Child ordering is deterministic.

---

## 2.2 Structural Hierarchy

### 2.2.1 Root Level

Root → Workbooks (and possibly other global trees)

### 2.2.2 Workbook Level

Workbook → Worksheets (and possibly other nodes)

### 2.2.3 Worksheet Level

Each worksheet:

* Has exactly one **Cell Grid**
* May have zero or more additional child nodes

---

## 2.3 The Cell Grid (First-Class Structure)

This is a crucial design decision.

We do **not** model the grid as a tree expansion.
We model it as a **native 2D structure**.

Each worksheet contains as its first child node a CellGrid:

```
CellGrid : (RowIndex × ColumnIndex) → CellNode
```

Where:

* Indices are finite.
* Grid is rectangular.
* Each cell is a node.

### Why First-Class?

Because:

* The system is specifically a spreadsheet.
* Optimization strategies will depend on grid semantics.
* Structural edits (insert/delete row/column) operate at grid level.
* Many semantics depend on rectangular regions.

This avoids awkward encoding of rows/columns as tree layers.

---

## 2.4 Cell Nodes

Each cell:

* Is a node in the tree–grid hybrid.
* May have augmentation children.
* May contain:

  * Formula tree
  * Metadata
  * Formatting
  * Value state

---

## 2.5 Augmentation Trees

Every node in the tree–grid hybrid may have:

```
Zero or more augmentation subtrees
```

These are finite trees used for:

* Chart representations
* Formatting structures
* Formula syntax trees
* Metadata
* Named ranges
* Comments
* etc.

They are fully part of Layer 1.

---

## 2.6 Formula Trees

If a cell contains a formula:

* The formula is represented as a syntax tree.
* This includes:

  * Parse structure
  * Tokens
  * Possibly whitespace
* It is attached as a subtree to the cell.

This allows:

* Formal semantic evaluation.
* Proof of parsing correctness.
* Structural invariants on formula shape.

Reference note:
The Roslyn compiler design pattern of immutable green trees with red facade nodes is relevant background for persistent syntax model choices in this layer:
https://learn.microsoft.com/en-us/archive/blogs/ericlippert/persistence-facades-and-roslyns-red-green-trees

---

# 3. Layer 2 — The Reference Layer

This layer overlays directed references on top of Layer 1.

Key principle:

> References are **not structural nodes** in Layer 1.

They exist in a separate reference graph.

---

## 3.1 Basic Reference Rule

Any node may have references to:

* Another node
* A cell region

References:

* Are attributes of nodes.
* Nodes may have zero or more outgoing references.

---

## 3.2 Cell Regions

A core difficulty: ranges.

We resolved this via:

### Reference-Level Virtual Region Nodes

Cell regions:

* Are **not part of Layer 1**
* Exist only in Layer 2
* Are virtual nodes in the reference graph

Each region is:

```
(sheet, rectangular coordinate set)
```

Regions are finite rectangular sets of cells.

---

## 3.3 Reference Targets

A reference may target:

* A real node (Layer 1)
* A virtual region node (Layer 2)
* An error reference

Thus, references form edges in:

```
ReferenceGraph = Directed graph over:
    RealNodes ∪ RegionNodes ∪ ErrorReferences
```

---

## 3.4 Reverse Dependencies

Dependency calculation requires reverse edges.

If:

```
A → Region R
```

Then:

* Conceptually this expands to:

  * A depends on every cell in R

Reverse edges are computed by:

```
For each region R:
    Expand R into its member cells
```

This preserves uniformity.

No special casing in Layer 1.

---

## 3.5 Reference Mutability

References may change due to:

* Structural operations
* Recalculation (e.g. INDIRECT)
* Formula updates

Therefore:

* Reference updates are explicit state transitions.
* They are modeled formally.

---

## 3.6 Invalid References

Structural changes may invalidate references.

Design decision:

* Invalid references remain first-class.
* They do not disappear.
* They become error references.

Possible modeling strategies:

1. Reference with attached error state.
2. Reference to global invalid-target node.
3. Explicit tagged error reference type.

All remain in reference graph.

---

# 4. Layer 3 — Dependency and Calculation

This layer derives from the reference layer.

---

## 4.1 Dependency Graph

Derived from references:

* Nodes = cells (primarily)
* Edges = dependency relations

If a cell references a region:

* Expand region to member cells
* Create edges accordingly

---

## 4.2 Cyclic Dependencies

Excel semantics must be preserved.

We allow cycles.

### Two Modes:

1. Cycle detection (normal mode)
2. Iterative recalculation (enabled mode)

---

## 4.3 Deterministic Iteration

Because Layer 1 has:

* Total ordering on labels
* Deterministic traversal

We can define:

```
Stable evaluation order
```

Even in cyclic iteration:

* Iterate in fixed order.
* Stop on convergence or iteration limit.

Thus:

> Cycles are allowed without introducing semantic nondeterminism.

---

## 4.4 Iteration Convergence Insight

Important observation:

Iteration may resolve cycles.

A cycle may disappear after recalculation stabilizes.

This becomes part of formal semantics.

---

# 5. Layer 4 — Values and Iteration State

We have not fully defined the value system yet.

But:

* Values live on nodes (especially cells).
* Value types will be rich.
* Errors are values.
* Type rules are strict.

The value layer:

* Is separate from structural layer.
* Is updated by calculation.

---

# 6. Operations Model (Critical Discipline)

All changes occur through operations.

Operations are first-class semantic objects.

---

## 6.1 Types of Operations

Operations may:

1. Modify tree–grid hybrid
2. Modify references
3. Modify values
4. Trigger recalculation
5. Modify iteration state

---

## 6.2 Structural Operations

Examples:

* Insert row
* Delete column
* Add sheet
* Delete workbook

These affect Layer 1.

After structural operation:

* Reference layer is recomputed.
* Dependency graph is recomputed.

Correctness first. Optimization later.

---

## 6.3 Non-Structural Operations

Examples:

* Edit formula
* Change value

These:

* Modify a node locally.
* Trigger reference recomputation.
* Trigger dependency recalculation.

---

## 6.4 Calculation Operations

Calculation:

* Cannot modify Layer 1.
* May modify:

  * Reference layer
  * Value layer
  * Dependency structure

---

## 6.5 Logging and Undo

Because operations are explicit:

* Undo/redo is well-defined.
* Logging is structured.
* Replay is deterministic.

---

# 7. Invariants

We must formally prove invariants per layer.

---

## 7.1 Tree–Grid Hybrid Invariants

* Single root.
* Finite tree.
* Labels totally ordered.
* Worksheets contain exactly one grid.
* Grids are rectangular.
* All augmentation trees finite.

---

## 7.2 Reference Layer Invariants

* References are finite.
* Region nodes represent finite sets.
* Error references preserved.
* Reference updates explicit.

---

## 7.3 Dependency Layer Invariants

* Derived from reference graph.
* Deterministic evaluation order.
* Iteration bounded.

---

## 7.4 Operations Invariants

* All state changes occur via operations.
* Operations produce valid Layer 1 structure.
* Reference graph recalculated after structural change.
* Calculation never mutates Layer 1.

---

# 8. Formalization Strategy

## 8.1 Lean

Lean can be used to:

* Define inductive tree types.
* Define grid structure.
* Define reference graph types.
* Prove invariants.
* Prove structural preservation under operations.
* Prove determinism of iteration order.

---

## 8.2 TLA+

TLA+ can be used to:

* Model multi-threaded recalculation.
* Model iteration semantics.
* Prove absence of race conditions.
* Prove convergence properties.
* Prove reference recalculation consistency.

---

# 9. Key Architectural Insights Achieved

1. The grid is first-class.
2. Regions exist at reference layer only.
3. Invalid references are first-class.
4. Cycles are allowed and deterministic.
5. Structural changes are separated from calculation.
6. Operations are the only mutation mechanism.
7. Optimization is explicitly separated from semantics.

---

# 10. Next Areas to Formalize

The major remaining areas:

* Value type system
* Formal evaluation semantics
* Typed formula evaluation
* Region-to-scalar lifting rules
* Spill semantics
* Concurrency model in detail

---

# 11. Brainstorm: Immutable Tree-Grid Persistence Plans

This section is intentionally exploratory and proposes multiple alternatives for later synthesis.

## 11.1 Roslyn Lessons To Transfer

Useful Roslyn lessons from the red-green tree history:

* Keep immutable core nodes parentless and context-free (the "green" layer).
* Put parent/position/context in ephemeral facade objects (the "red" layer).
* Make edits rebuild only the ancestor spine from the edited location to the root.
* Preserve full fidelity in immutable nodes; avoid lossy transformations in the core representation.
* Assume most nodes survive edits unchanged; optimize for structural reuse, not raw mutation speed.
* Keep immutable-node memory compact (Roslyn packs multiple metadata fields tightly in green nodes).
* Construct facade nodes lazily and cache them safely (Roslyn red nodes are created on demand).

Primary references:

* Eric Lippert on persistence facades and red-green trees:
  https://learn.microsoft.com/en-us/archive/blogs/ericlippert/persistence-facades-and-roslyns-red-green-trees
* Roslyn syntax transformation guidance ("re-spinning" ancestor chain):
  https://learn.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/get-started/syntax-transformation
* Roslyn syntax API guidance on immutable, full-fidelity trees:
  https://learn.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/work-with-syntax
* Roslyn `GreenNode` implementation (compact metadata and slot model):
  https://github.com/dotnet/roslyn/blob/main/src/Compilers/Core/Portable/Syntax/GreenNode.cs
* Roslyn `SyntaxNode` implementation (parent/position facade and lazy child red-node creation):
  https://github.com/dotnet/roslyn/blob/main/src/Compilers/Core/Portable/Syntax/SyntaxNode.cs

Grid implication:
For spreadsheets, the equivalent of source-text position is cell addressing under structural edits.
So we likely need to decouple identity from displayed coordinates (A1/B2/...).

## 11.2 Candidate Design Space (Wide Exploration)

### Plan 0 (Control): Full Copy Grid Per Edit

Core idea:
Use a plain 2D array snapshot; every edit produces a full copy.

Why keep it:

* Baseline for correctness and implementation complexity.
* Baseline for benchmark sanity and instrumentation.

Expected outcome:

* Easy semantics.
* Catastrophic memory and latency for large sheets.

### Plan A: Axis Maps + Sparse Cell Store (Red-Green-Like For Grids)

Core idea:

* `GreenSheet` stores:
  * persistent row-order map: visible row index -> `RowId`
  * persistent col-order map: visible col index -> `ColId`
  * persistent cell map keyed by `(RowId, ColId)` -> immutable cell payload
* `RedSheet` facade resolves index/address context and caches lookups.

Edit behavior:

* Point edit: replace one cell payload path in persistent map.
* Insert row/col: rewrite only axis-order spine; existing cells stay keyed by stable IDs.
* Delete row/col: axis map update + optional tombstone/GC policy.

Strengths:

* Strong Roslyn analogy.
* Structural edits avoid touching all shifted addresses.
* Fits epoch snapshots and branch/undo naturally.

Risks:

* Dense scans require repeated map resolution unless heavily cached.
* Complexity in keeping address/render order fast.

### Plan B: Persistent Tile DAG (Copy-On-Write Pages)

Core idea:

* Partition grid into fixed tiles (for example 32x32 or 64x64).
* Top-level persistent 2D index (B-tree or radix trie) points to immutable tile blocks.
* Cell edit copies root path plus one tile.

Edit behavior:

* Point/range edits clone touched tiles only.
* Row/col insert handled with persistent row/col offset maps or tile-coordinate remapping metadata.

Strengths:

* Cache-friendly for viewport rendering and range eval.
* Good for dense and semi-dense workloads.
* Memory reuse is naturally chunked.

Risks:

* Row/col inserts are hard if tile coordinates are absolute.
* Can cause fragmentation near shifting boundaries.

### Plan C: Row Rope + Column Rope (2D Rope/RRB Family)

Core idea:

* Persistent vector/rope of rows.
* Each row is itself a persistent vector/rope of cell segments.
* Symmetric variant: dual indices for rows and columns.

Edit behavior:

* Row insert/delete is spine-local in outer rope.
* Column edits are local inside affected rows but can be broad across many rows.

Strengths:

* Elegant persistent sequence theory.
* Fast append/insert in edited regions.

Risks:

* Column operations can become expensive if representation is row-biased.
* Hard to make both row-major and column-major operations equally good.

### Plan D: Piece Table / Patch Stack Grid

Core idea:

* Keep immutable base snapshot plus immutable patch layers.
* Patches represent cell edits and structural transforms (row/col insert/delete, range paste).
* Reads resolve through layered patch index; periodic compaction materializes.

Edit behavior:

* Very cheap writes (append immutable patch node).
* Snapshot branching is almost free.

Strengths:

* Excellent undo/redo/branching characteristics.
* Operationally aligned with OpLog.

Risks:

* Read amplification if patch depth grows.
* Requires strict compaction policy and deterministic compaction triggers.

### Plan E: Persistent Rectangle Algebra (Region-First)

Core idea:

* Represent grid value assignment as immutable set of non-overlapping rectangular regions
  with a priority/stack rule.
* Cells are resolved by region lookup structures (interval trees / segment trees).

Edit behavior:

* Large pastes and format fills are cheap (one region write).
* Sparse point edits create tiny override regions.

Strengths:

* Very attractive for spreadsheet-style range operations.
* Could integrate naturally with reference-layer region nodes.

Risks:

* Canonicalization is difficult (region splitting/merging).
* Point lookup may be slower than tile/page design without heavy indexing.

### Plan F: Columnar Chunk Store (Database-Inspired)

Core idea:

* Store columns (or column groups) as immutable chunked vectors with compression (RLE/dictionary).
* Row view is reconstructed through chunk iterators.

Edit behavior:

* Column formulas and analytics are fast.
* Row edits update multiple chunks.

Strengths:

* Strong for vectorized eval kernels.
* Compression potential for repetitive spreadsheet data.

Risks:

* UI and row-local edits can be awkward.
* Harder mental model for spreadsheet users and formula dependency debugging.

### Plan G: "Knuth-Style" Balanced Blocks + Measured Cost Model

Core idea:

* Use order-statistics B-trees over rows and columns with fixed-size leaf pages.
* Pages hold compact cell records and local offsets.
* All choices driven by measured cost tables (cache misses, branch count, writes per edit).

Why include this explicitly:

* Old-fashioned but robust.
* Predictable asymptotics and practical locality.
* Friendly to clear invariants and formal reasoning if page rules are explicit.

Risks:

* More engineering upfront than hash-map approaches.
* Requires careful tuning of page sizes and split/merge policies.

## 11.3 A Roslyn-Inspired Hybrid We Should Probably Prototype Early

Proposed hybrid candidate:

* Green layer:
  * immutable axis trees (row order and column order),
  * immutable tiled cell store keyed by stable `(RowId, ColId)`,
  * immutable metadata/augment trees as already modeled.
* Red layer:
  * facade objects with cached position/address projections,
  * viewport-local traversal caches and dependency lookups.
* Edit semantics:
  * update leaf payload or tile,
  * respin only modified structure plus ancestor spines,
  * preserve untouched subgraphs by reference identity.

This keeps the Roslyn principle while respecting the 2D nature of spreadsheets.

## 11.4 Evaluation Matrix (How We Compare Ideas)

Scoring scale:

* 1 = poor
* 3 = acceptable
* 5 = excellent

Suggested weighted matrix:

| Criterion | Weight | Notes |
| --- | ---: | --- |
| Point edit latency (p50/p95) | 12 | Single-cell edit + formula update overhead |
| Row/col structural edit latency | 14 | Insert/delete near top/middle/bottom |
| Range write latency | 10 | Paste/fill/clear rectangle operations |
| Read throughput (viewport scan) | 10 | UI and evaluator iteration cost |
| Snapshot memory amplification | 12 | Bytes per new epoch for representative edits |
| Structural reuse ratio | 12 | Fraction of prior structure retained |
| GC/allocation pressure | 8 | Allocation rate and pause profile |
| Dependency rewrite impact | 8 | Downstream cost to reference/dependency layers |
| Determinism friendliness | 6 | Stable traversal and replay behavior |
| Formalization complexity (Lean/TLA+) | 8 | Proof burden and model clarity |

Interpretation:

* Any candidate below 3 on structural edit latency or memory amplification is likely non-viable.
* Any candidate below 3 on determinism or formalization may conflict with project doctrine.

## 11.5 Benchmark and Validation Plan

### Phase 1 - Common Prototype Contract

Define one interface for all candidate structures:

* `GetCell(addr)`
* `SetCell(addr, payload) -> snapshot`
* `InsertRows(pos, count) -> snapshot`
* `InsertCols(pos, count) -> snapshot`
* `DeleteRows/DeleteCols`
* `WriteRange(rect, payloads)`
* `EnumerateRange(rect)`
* `SnapshotStats()` (node counts, bytes, reuse ratio)

### Phase 2 - Workload Corpus

Synthetic workloads:

* W1: random point edits on sparse and dense sheets.
* W2: top/middle/bottom row insert storms.
* W3: top/middle/bottom column insert storms.
* W4: large range paste/fill/clear.
* W5: dynamic spill growth/shrink and overwrite conflicts.
* W6: repeated undo/redo branch forks.

Trace-driven workloads:

* T1: realistic editing traces from UI sessions.
* T2: calc-heavy traces with dependency churn.
* T3: import/normalize traces from representative workbooks.

### Phase 3 - Instrumentation

For every operation, record:

* wall-clock latency (p50/p95/p99),
* allocations and retained bytes,
* number of nodes/pages/tiles touched,
* reuse ratio:
  `reused_nodes_or_bytes / total_nodes_or_bytes_in_new_snapshot`,
* spine rewrite depth,
* read amplification (steps for `GetCell` and range scan).

### Phase 4 - Correctness and Invariant Checks

All prototypes must satisfy:

* immutable snapshot semantics,
* deterministic traversal order,
* no hidden mutation paths,
* stable replay under identical op streams,
* reference/dependency layer consistency after structural edits.

### Phase 5 - Downselect Process

* Keep top 2 candidates by weighted score.
* Build one deeper prototype integrated with dependency graph updates.
* Re-run matrix with real formula/reference workloads before final selection.

## 11.6 Specific Open Questions For The Next Iteration

* Should stable `RowId`/`ColId` be globally unique or sheet-local with epoch scoping?
* Do we permit temporary non-canonical region/patch forms for speed, then normalize lazily?
* Which layer owns compaction: core snapshot engine or operations pipeline?
* How much red-layer caching is allowed before determinism/debuggability suffer?
* Can one representation serve both evaluator locality and UI locality, or do we need dual caches?

---

# Closing

We now have a coherent, layered, formally specifiable semantic model for DNA Calc:

* A deterministic tree–grid hybrid structure
* A reference graph with virtual region nodes
* A dependency graph derived from references
* Iterative calculation with deterministic order
* Operation-driven mutation discipline

This foundation is strong enough to support:

* Formal verification
* Multi-threaded evaluation
* Full Excel-compatible semantics
* Optimization without semantic compromise

---

If you’d like next, we can:

* Turn this into a Lean-style type specification draft
* Or define the formal state transition system
* Or start specifying the value semantics layer



