# Incremental Deep-Dive Notes (Source Analysis)

Date (UTC): 2026-02-22
Repository: https://github.com/janestreet/incremental
Snapshot commit: ddbd0e21a4865b59de97a45e1cf19f317fb5147c

## What Incremental is trying to do
- Incremental computes derived values over a changing input graph and updates them efficiently.
- README explicitly frames use cases in spreadsheet-like recalculation, GUI views, and derived-data sync.

## Architecture signals from source
- Core graph type is `Node.t` with rich metadata (`kind`, `changed_at`, `recomputed_at`, parent/child links, scope, heights).
- Stabilization uses:
  - recompute heap (nodes needing computation, by min height)
  - adjust-heights heap (restore topological constraints when edges change)
- Explicit invariants in comments and interface docs:
  - parent edges only for necessary nodes
  - recompute heap iff necessary + stale
  - parent height > child height

## Bind/scoping/invalidation mechanics (the most distinctive part)
- `bind` supports dynamic graph reconfiguration.
- Nodes created under a bind RHS are tracked in a scope-linked list.
- On bind-LHS change, RHS-created nodes are either invalidated or re-scoped (config option).
- Special nodes (`Bind_lhs_change`, `Join_lhs_change`, `If_test_change`) enforce ordering and change propagation semantics.

## Practical performance levers
- Cutoff function per node controls change propagation (`phys_equal` default; user-customizable).
- `unordered_array_fold` supports update-mode reductions (including inverse-update strategy).
- `do_one_step_of_stabilize` enables stepwise stabilization for controlled execution loops.

## Introspection / tooling built into library
- Graph export (`save_dot`) with optional bind-edge emission.
- `For_analyzer` interface exposes traversal metadata (kind, cutoff, heights, changed/recomputed stamps).
- `Expert` API supports dynamic dependency sets and explicit stale/invalid accounting.

## Repo-scale indicators
- 112 `.ml/.mli` files total.
- `src` has 77 `.ml/.mli` files (~8.6k lines); tests ~5.6k lines.
- Heaviest files:
  - `src/state.ml` (~1964 lines)
  - `src/incremental_intf.ml` (~1627 lines)
  - `src/node.ml` (~645 lines)

## Evolution snapshot
- Commit history includes regular preview-version release commits (`v0.15` -> `v0.18` previews).
- OPAM package currently lists `incremental` at `v0.18.0`.

## Why it is "cool" (engineering perspective)
- It treats incremental recomputation as a graph-maintenance problem with explicit formal invariants, not ad-hoc memoization.
- It exposes both high-level combinators and low-level expert escape hatches.
- It ships analyzability hooks (dot output + analyzer module), making performance/debuggability first-class.