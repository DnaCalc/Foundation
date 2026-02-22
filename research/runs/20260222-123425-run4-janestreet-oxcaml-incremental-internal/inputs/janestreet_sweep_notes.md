# Jane Street OCaml Stack Sweep Notes

Date (UTC): 2026-02-22
Primary source: GitHub org API snapshot for `janestreet`.

## Inventory size
- Total repos in `janestreet` org snapshot: 367
- Repos with language tagged OCaml: 322

## Prefix-density snapshot (proxy for ecosystem shape)
- ppx_*: 73
- async*: 21
- bonsai*: 12
- incr*: 10
- core*: 7
- base*: 5
- expect*: 4

## Curated foundational stack (selected)
- Standard-library layer:
  - base (stdlib replacement)
  - core (stdlib overlay)
  - core_kernel (portable core subset)
  - core_unix
  - stdio
- Concurrency/runtime layer:
  - async
  - async_kernel
  - async_rpc_kernel
- Data/serialization layer:
  - sexplib
  - bin_prot
- Meta-programming/tooling layer:
  - ppx_jane
  - ppxlib
  - fieldslib
  - expect_test_helpers_core
- Incremental/UI layer:
  - incremental
  - bonsai
  - virtual_dom

## Starred/top-signal repos in org snapshot
- core, base, incremental, bonsai, async, core_kernel, sexplib, ppx_expect
- Also high-profile non-stdlib adjacent projects appear (e.g., magic-trace, hardcaml).

## Key observation
The stack is broad and modular; Base/Core are only one layer in a much larger ecosystem with heavy investment in ppx tooling, incremental computation, async runtime, and UI composition.