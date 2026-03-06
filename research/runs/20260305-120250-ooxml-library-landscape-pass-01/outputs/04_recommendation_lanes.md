# Recommendation Lanes

## Lane A - Rust-first pragmatic split (recommended)
1. Reader lane: `calamine`.
2. Writer lane: `rust_xlsxwriter`.
3. Optional consolidation experiment: `umya-spreadsheet` behind adapter interface.

Why:
- Minimizes immediate risk while keeping Rust-native path.
- Avoids overcommitting to one mixed-maturity Rust library for full interop.

## Lane B - Reference/oracle lane (recommended)
1. Low-level package semantics reference: `dotnet/Open-XML-SDK`.
2. High-level comparative reference: `apache/poi` and/or `qax-os/excelize`.

Why:
- Provides practical differential checks for OOXML package and spreadsheet feature behavior.
- De-risks macro/relationship/unknown-part edge cases.

## Lane C - Defer/monitor lane
1. `xlnt` and `OpenXLSX` as C++ alternatives.
2. `libxlsxwriter` as specialized high-quality writer helper only.
3. `NPOI` as fallback for legacy compatibility contexts.

Why:
- Useful as targeted tools, not primary architecture lane today.

## Acceptance gates before adoption elevation
1. License confirmation gate (for any `NOASSERTION` API signal).
2. xlsm/vbaProject no-op roundtrip gate.
3. Unknown OOXML part preservation gate.
4. Deterministic diff gate against selected reference implementation.
5. Large-sheet memory/streaming gate.