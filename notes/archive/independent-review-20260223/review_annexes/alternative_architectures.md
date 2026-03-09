# Annex D: Alternative Architecture Explorations

## 1. The "Salsa-Powered" Engine

### Concept
Use Rust's Salsa framework (the incremental computation engine powering rust-analyzer) as the foundation for the spreadsheet calculation engine.

### Why This Might Work
- Salsa is specifically designed for incremental, demand-driven recomputation -- exactly what a spreadsheet needs
- It has proven scalability in rust-analyzer (handling large Rust codebases)
- Salsa 3.0 (in development) adds trivial parallelism for all databases and persistency (durable incrementality)
- It tracks dependencies automatically and recomputes only what changed
- Built-in cycle detection (relevant for circular references)
- rust-analyzer's key invariant ("typing inside a function body never invalidates global data") maps to spreadsheet semantics ("editing a cell only invalidates its dependents")

### Architecture Sketch
```
User Input -> OpLog -> Salsa Database (formulas, values, dependencies)
                            |
                            v
                   Incremental Recomputation
                   (only dirty cells re-evaluated)
                            |
                            v
                   CalcDeltas (epoch-tagged results)
```

### Tradeoffs
- **Pro**: Proven incremental computation with Rust-native parallelism
- **Pro**: Eliminates need to build custom dependency graph from scratch
- **Con**: Salsa's demand-driven model may not map perfectly to spreadsheet "push" invalidation
- **Con**: Dependency on an external framework (though rust-analyzer's usage provides confidence)

## 2. The "WASM-First" Architecture

### Concept
Build the engine in Rust, compile to WASM, and run entirely in the browser. No Tauri shell needed.

### Why This Might Work
- Figma proved that Rust + WASM + web UI can produce a high-performance creative tool
- No native application distribution needed (works in any browser)
- The same WASM module can run server-side (Node.js, Deno, Cloudflare Workers)
- WASM's sandboxing provides security guarantees

### Architecture Sketch
```
Rust Engine -> cargo build --target wasm32-unknown-unknown
                            |
                            v
                     WASM Module
                    /           \
                   v             v
           Browser (Web UI)   Server (Node.js/API)
```

### Tradeoffs
- **Pro**: Zero-install, cross-platform, server-side compatible
- **Pro**: Security sandboxing built-in
- **Con**: WASM has no direct DOM access (need JS bridge for UI)
- **Con**: WASM threading model is still evolving (SharedArrayBuffer)
- **Con**: File system access limited in browser (but Web File System Access API exists)
- **Con**: No XLL/COM/native add-in support in browser

## 3. The "Differential Dataflow" Architecture

### Concept
Model the spreadsheet as a collection of (cell_id, formula, value) tuples and use differential dataflow for incremental computation.

### Why This Might Work
- Doss built an Excel-like formula engine on Materialize (which uses differential dataflow): "formulas that took minutes now complete in under a second at 10,000x scale"
- Differential dataflow handles arbitrarily nested iteration (relevant for iterative calculation)
- Distributed by design (relevant for collaboration)
- Formal foundations (Timely Dataflow theory)

### Tradeoffs
- **Pro**: Proven at massive scale
- **Pro**: Collaboration-ready from the start
- **Con**: Likely overkill for single-machine spreadsheet workloads
- **Con**: Complex API ("too many single-letter type variables")
- **Con**: Rust-only (no .NET path)

## 4. The "Roslyn Model" Architecture

### Concept
Apply Roslyn's red/green tree model to spreadsheet state management. Immutable "green" trees represent the document; mutable "red" wrappers provide efficient edit operations.

### Why This Might Work
- Referenced in the Running Project Notes (2026-02-23, item 1)
- Roslyn's model is proven for managing large, incrementally-edited syntax trees
- Full-fidelity representation (including whitespace/formatting metadata)
- Spine-defined snapshot identity maps to epoch model
- Syntax vs semantic tree separation maps to formula parsing vs evaluation

### Architecture Sketch
```
Green Tree (immutable document state, shared across epochs)
     |
     v
Red Wrapper (provides mutation API, creates new green tree on edit)
     |
     v
Semantic Model (formula evaluation, dependency tracking)
```

### Tradeoffs
- **Pro**: Proven for language services at scale (VS Code, rider)
- **Pro**: Natural fit for snapshot/epoch semantics
- **Con**: Adds complexity to the data model
- **Con**: .NET-native pattern; Rust equivalent would need custom implementation

## 5. The "SQLite-Inspired" Quality Model

### Concept
Instead of formal proofs, achieve extraordinary quality through industrial-scale testing.

### Implementation Plan

**Phase 1: Foundation (Month 1)**
- Property-based testing with proptest for all pure functions
- Deterministic mode for all execution paths
- Every test failure produces a minimized reproduction case

**Phase 2: Fuzzing (Month 2-3)**
- Custom fuzzer that mutates both formulas and cell data simultaneously
- Target: 1M mutations/day initially, scaling to 100M/day
- Fuzz corpus grows monotonically (every crash/mismatch becomes a permanent seed)

**Phase 3: Differential Testing (Month 3-6)**
- Excel observation harness: feed same inputs to DNA Calc and Excel, compare outputs
- Target: 10,000+ differential test cases
- Every mismatch is either a bug fix or a documented compatibility decision

**Phase 4: Coverage (Month 6-12)**
- Branch coverage tracking with llvm-cov
- Target: 80%+ branch coverage initially, 95%+ within a year
- Coverage gaps in critical paths are treated as bugs

**Phase 5: Scaling (Year 1+)**
- Continuous fuzzing infrastructure (like OSS-Fuzz)
- Target: 1B mutations/day (SQLite-class)
- 100x test-to-code ratio
- Zero-tolerance for regressions in the minimized case corpus

### Why This Works
- SQLite achieves "alien artifact" quality with 2 people through testing, not proofs
- Testing finds bugs that formal methods miss (implementation bugs, platform-specific issues)
- Testing scales better than formal verification (add more CPU, find more bugs)
- Testing provides confidence across the entire codebase, not just formally specified components

## 6. Recommended Hybrid Architecture

Based on the analysis above, the recommended architecture for DNA Calc:

```
Layer 1: Core Engine (Rust)
  - Formula parser + evaluator (custom, not Salsa -- Salsa is demand-driven, spreadsheets are push)
  - Dependency graph (custom, inspired by Jane Street Incremental invariants)
  - Epoch model (OpLog -> DocSnapshot -> CalcDeltas)
  - Deterministic mode with trace replay
  - Tested with: proptest, cargo-fuzz, Excel differential harness

Layer 2: Concurrency Protocol
  - Verified with TLA+ (small model, safety invariants)
  - Coordinator + worker pool + epoch fencing
  - Tested with: deterministic replay under adversarial schedules

Layer 3: File I/O (adapters, outside core)
  - .xlsx read/write via existing Rust OOXML library (calamine for read, rust-xlsxwriter for write)
  - Native format: simple JSON or binary for development
  - Degradation taxonomy (Native/Lowered/Opaque/Rejected)

Layer 4: API Surface
  - Rust crate API for embedding
  - WASM module for browser/Node.js
  - CLI for batch evaluation and testing

Layer 5: UI (deferred)
  - Tauri + Canvas grid + DOM overlay (following existing design)
  - Added only after engine is stable and tested

Layer 6: Formal Semantics (deferred)
  - Lean proofs for core formula semantics (after AST is stable)
  - Added incrementally, following implementation
```

This architecture preserves all of DNA Calc's key innovations (epoch model, degradation taxonomy, deterministic mode, formal verification) while reducing the initial scope to something achievable.
