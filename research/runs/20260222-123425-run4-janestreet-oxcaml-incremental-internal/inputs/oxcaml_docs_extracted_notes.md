# OxCaml Docs Extraction Notes

Date (UTC): 2026-02-22

## Sources
- https://oxcaml.org/documentation/language-extensions/
- https://oxcaml.org/get/
- https://discuss.ocaml.org/t/oxcaml-tools-and-language-for-modern-ocaml-programming/16759
- https://icfp24.sigplan.org/details/ocaml-2024-papers/3/Towards-Merging-OxCaml-and-OCaml

## Language-extension set visible in docs index
The language extensions index currently lists:
- local
- layouts
- unboxed types
- kinds
- mode-axes
- modes
- affine
- comprehensions
- immutable arrays
- include functor
- module strengthening

## Upstreaming-status notes from docs index
The index currently includes an "Upstreaming" status summary:
- Included in OCaml: include functors, immutable arrays.
- Included in OCaml with syntax changes: local.
- Under review: kinds, unboxed-types.
- Planned after summer 2025: layouts, mode-axes, modes, affine, comprehensions.

## Toolchain/distribution notes from get page
The get page currently describes:
- Installation of OxCaml via opam switch command using `5.2.1+ox`.
- Recommendation to pin an `opam-repository` branch for OxCaml.
- A "custom opam repository" requirement for tools:
  - merlin
  - ocaml-lsp-server
  - utop
  - ocamlformat

## Evolution signals
- `oxcaml/oxcaml` has active recent commits and high branch density.
- `oxcaml` organization includes companion tool forks (merlin, ocaml-lsp, dune, utop, ocamlformat, js_of_ocaml) indicating ecosystem-integration work around the compiler fork.