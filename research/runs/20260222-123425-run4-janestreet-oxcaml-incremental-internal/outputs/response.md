# Internal Deep Research Run 4 - Jane Street Stack, OxCaml, Incremental

- Run ID: `20260222-123425-run4-janestreet-oxcaml-incremental-internal`
- Topic ID: `R-TOPIC-007`
- Method: web-backed source sweep + GitHub API inventory + source-level implementation analysis
- Date (UTC): 2026-02-22
- Scope posture: gather and reflect only; no direct doctrine incorporation

## 1) Executive Summary

This run confirms three important points for DNA Calc:

1. Jane Street's OCaml ecosystem is broad and layered, not just "Base/Core".
2. OxCaml is an actively developed compiler+toolchain track with explicit upstreaming intent and language-extension focus.
3. Incremental is a high-signal reference for graph-based, invariant-driven recomputation design that maps directly to spreadsheet-style semantics.

Top practical takeaway:
- For Green, the highest-value import is not "use all Jane Street tech"; it is adopting the Incremental-style discipline (explicit graph invariants, scoped invalidation, analyzability) while being selective about language-fork risk (OxCaml).

## 2) Wide Sweep: Jane Street OCaml Standard Library + Extensions (Current Snapshot)

### 2.1 Inventory breadth

From GitHub org snapshot (`janestreet`):
- Total repos: `367`
- OCaml-tagged repos: `322`

Prefix-density signals (coarse ecosystem shape):
- `ppx_*`: 73
- `async*`: 21
- `bonsai*`: 12
- `incr*`: 10
- `core*`: 7
- `base*`: 5

Inference: ecosystem weight is distributed across stdlib overlay, concurrency, ppx tooling, serialization, incremental/UI, and testing infrastructure.

### 2.2 Foundational stack map (curated)

Standard-library and core platform layer:
- `base` (stdlib replacement)
- `core`, `core_kernel`, `core_unix`
- `stdio`

Concurrency/runtime layer:
- `async`, `async_kernel`, `async_rpc_kernel`

Serialization and type-conversion layer:
- `sexplib`, `bin_prot`

Metaprogramming/testing layer:
- `ppx_jane`, `ppxlib`, `fieldslib`, expectation-test helpers

Incremental/UI layer:
- `incremental`, `bonsai`, `virtual_dom`, `incr_dom`

### 2.3 Current package-version signal

OPAM package pages observed in this run:
- `base`: current version shown as `0.18.1`
- `core`: current version shown as `0.18.1`
- `incremental`: current version shown as `v0.18.0`

This indicates active, coordinated package stream continuity in the v0.18 line.

## 3) OxCaml Evolution Focus

### 3.1 What OxCaml currently looks like structurally

From `oxcaml` org/API snapshot:
- Repos in org: `14`
- Includes `oxcaml/oxcaml` (compiler) plus companion forks/integration repos (`merlin`, `ocaml-lsp`, `dune`, `utop`, `ocamlformat`, `opam-repository`, etc.).

From `oxcaml/oxcaml` metadata snapshot:
- Active recent pushes
- High branch density (100 branches on first API page)
- Active commit stream on language/runtime/compiler internals (recent commit sample includes kinds/type-system/runtime changes)

### 3.2 Language-extension set and upstreaming trajectory

From OxCaml docs index:
- Extension set shown includes: local, layouts, unboxed types, kinds, mode-axes, modes, affine, comprehensions, immutable arrays, include functor, module strengthening.

The same docs page includes explicit upstreaming status notes:
- Included in OCaml: include functors, immutable arrays
- Included in OCaml with syntax changes: local
- Under review: kinds, unboxed-types
- Planned after summer 2025: layouts, mode-axes, modes, affine, comprehensions

Interpretation:
- OxCaml is being positioned as both an innovation track and an upstream feeder, not purely a permanent divergence branch.

### 3.3 Toolchain packaging model

From `oxcaml.org/get`:
- Installation centers around an OxCaml opam switch (`5.2.1+ox` shown in docs).
- Tooling requires a custom opam repository for editor/format tooling integration (`merlin`, `ocaml-lsp-server`, `utop`, `ocamlformat`).

Implication for us:
- OxCaml adoption is not only compiler syntax/features; it is a toolchain ecosystem decision.

## 4) Incremental Deep Dive

### 4.1 Core idea

Incremental models computation as a DAG of nodes and maintains derived values by stabilization passes when inputs change.

It is explicitly positioned for:
- spreadsheet-like recalculation,
- GUI view updates,
- derived-data consistency.

### 4.2 Key implementation mechanics (from source)

1. Node-centric state model:
- `Node.t` tracks kind, cutoff policy, dependency links, scope, heights, staleness markers, and recomputation timestamps.

2. Two-heap stabilization strategy:
- recompute heap (necessary + stale nodes, min-height recompute order)
- adjust-heights heap (restoring topological ordering when edges are introduced/reconfigured)

3. Dynamic graph via `bind` + scope tracking:
- Nodes created on bind RHS are scope-tracked.
- LHS change triggers scoped invalidation or re-scoping behavior (configurable).
- Specialized internal nodes (`Bind_lhs_change`, `Join_lhs_change`, `If_test_change`) encode change semantics.

4. Controlled propagation policy:
- Per-node cutoff functions determine change propagation (`phys_equal` default; customizable).
- `map` preferred for static DAG flow; `bind` for dynamic graph creation/reconfiguration.

5. Debuggability/analyzability hooks:
- DOT export (`save_dot`) with bind-edge control.
- `For_analyzer` traversal interface exposes kind/cutoff/height/recompute/change stamps.
- Step-wise stabilization API (`do_one_step_of_stabilize`) exists for controlled execution loops.

### 4.3 What is particularly strong / "cool"

- Explicit invariant-centered design instead of hidden memoization heuristics.
- First-class handling of dynamic dependency topology with correctness constraints.
- Practical introspection layer built into the library (graph export + analyzer surface).
- Rich but composable API tiers: high-level combinators and lower-level expert dependencies.

### 4.4 Scale/evolution signals

Snapshot metrics:
- `.ml/.mli` files: `112`
- `src`: 77 files, ~8586 lines
- `test`: 19 files, ~5665 lines
- Largest files: `state.ml` (~1964), `incremental_intf.ml` (~1627), `node.ml` (~645)

History signals:
- commit count in repo history: `169`
- visible long-running preview cadence from v0.15 -> v0.18 era
- current default-branch head commit carries `v0.18~preview...` naming pattern

## 5) Fit Analysis for DNA Calc (Green Track)

### 5.1 High-value fit (recommended)

1. Incremental graph semantics as the Green recalculation spine:
- Adopt "necessary + stale + topological order" invariants explicitly in Green architecture docs.

2. Scoped invalidation model:
- Use bind-scope style invalidation concepts for dynamic formula structures, conditional dependencies, and model reconfiguration edges.

3. Analyzer-first diagnostics:
- Mirror `save_dot`/analyzer strategy in Green so recalculation plans and dependency deltas are inspectable from the start.

4. Cutoff discipline:
- Introduce configurable cutoff/equality policies per node/class of computation to prevent churn in large sheets.

### 5.2 Medium-value fit (candidate)

- `unordered_array_fold`-style inverse updates for aggregation formulas and table-style derived metrics where full fold is expensive.
- Stepwise stabilization APIs for deterministic debug/replay in test harnesses.

### 5.3 Caution zone

- OxCaml full adoption in Green increases toolchain coupling and maintenance cost.
- Safer path: treat OxCaml as a research feeder for ideas (especially type/kind/affine directions), not an immediate mandatory dependency.

## 6) Suggested Next Research/Design Actions (No Implementation Yet)

1. Produce a Green-specific recalculation invariant draft inspired by Incremental internals (`stale`, `necessary`, `height`, `scope`).
2. Design a minimal DOT/trace export contract for Green recomputation plans.
3. Run a focused comparison between Incremental's `bind` invalidation model and spreadsheet dependency mutations (e.g., dynamic ranges/indirection).
4. Decide OxCaml strategy explicitly:
   - observe-only,
   - optional experimental branch,
   - or committed track with tooling budget.

## 7) Bottom Line

Jane Street's ecosystem gives us a proven architecture pattern: layered base libraries + aggressive tooling + explicit incremental semantics.

For DNA Calc Green, Incremental is the immediate high-yield reference.
OxCaml is strategically interesting, but should remain a controlled research input until we deliberately choose a compiler/toolchain posture.