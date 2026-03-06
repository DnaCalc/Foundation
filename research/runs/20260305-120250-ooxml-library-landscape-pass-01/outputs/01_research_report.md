# Research Report

- Run ID: 20260305-120250-ooxml-library-landscape-pass-01
- Topic ID: R-TOPIC-009
- Source prompt: inputs/prompt_01_master.md + prompt_02_rust_focus.md + prompt_03_comparison.md
- Date (UTC): 2026-03-05

## Scope
- Research question:
  - Which open-source libraries are best candidates for Excel-relevant Office Open XML handling, with Rust-first emphasis and cross-ecosystem comparison?
- Exclusions:
  - Proprietary/commercial-only libraries as primary adoption candidates.
  - Full Excel calc-engine compatibility analysis.

## Findings
1. No single Rust library currently gives a clearly dominant, high-confidence, full read/write + macro-preserving OOXML stack comparable to mature non-Rust ecosystems.
2. Rust options naturally separate into lanes:
   - `calamine`: strong reader lane.
   - `rust_xlsxwriter`: strong writer lane.
   - `umya-spreadsheet`: mixed read/write candidate, but higher validation risk.
3. Mature non-Rust baselines (Open XML SDK, Apache POI, excelize, ClosedXML) offer richer operational confidence and broader interop patterns today.
4. For DnaCalc near-term pragmatism, a split architecture is favored:
   - Rust-native core for selected lanes,
   - external adapter/reference lane for difficult OOXML fidelity edge cases.
5. Macro/xlsm behavior requires empirical verification regardless of library claims.
6. OOXML low-level control remains critical; Open XML SDK is the most explicit low-level baseline in this sweep.

## Source Summary
- Total sources: 20
- Primary sources: official repos/docs/spec indexes and standards pages
- Secondary sources: none used for scoring

## Candidate Ranking (current pass)

### Rust lane
1. `calamine` (reader anchor)
2. `rust_xlsxwriter` (writer anchor)
3. `umya-spreadsheet` (single-stack Rust candidate; needs stronger conformance validation)

### Cross-ecosystem high-confidence baselines
1. `dotnet/Open-XML-SDK` (low-level OOXML control)
2. `apache/poi` (mature Java Excel/OOXML stack)
3. `qax-os/excelize` (high-activity practical full-feature library)
4. `ClosedXML/ClosedXML` (high-level .NET productivity layer)

## Decision-Oriented Recommendation
1. Primary DnaCalc implementation should not depend on one Rust OOXML library as sole truth for all Excel interop semantics.
2. Near-term practical lane:
   - Use `calamine` + `rust_xlsxwriter` for constrained Rust-native read/write tasks.
   - Evaluate `umya-spreadsheet` as optional consolidation path only after targeted empirical conformance passes.
3. Keep at least one mature non-Rust reference implementation lane (Open XML SDK and/or POI/excelize) for differential validation and difficult package-level operations.
4. Track macro/xlsm and unknown-part roundtrip as first-class risk lanes with explicit empirical packs.

## Risks and Caveats
1. GitHub API rate limiting was encountered during additional README mining; core metadata snapshot was captured before the limit.
2. Some capability claims are inferred from README/docs and need pack-grade empirical confirmation.
3. License signals marked `NOASSERTION` from API must be resolved from LICENSE files before adoption.

## Gaps
1. No direct benchmark corpus comparison executed in this pass.
2. No deep per-feature API parity table (tables/charts/pivot/conditional-format) beyond top-level evidence.
3. No empirical xlsm/vbaProject roundtrip tests yet for shortlisted libraries.

## Follow-up Queries
1. For each shortlisted library, what is the observed behavior for xlsm/vbaProject roundtrip on a fixed corpus?
2. Which library best preserves unknown OOXML parts and relationship IDs under no-op open/save?
3. What are memory and throughput characteristics for large worksheet streaming scenarios?
4. Can a deterministic adapter protocol be defined so Rust core can switch OOXML backends by profile?