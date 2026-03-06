# OOXML Library Landscape Research Run

- Run ID: 20260305-120250-ooxml-library-landscape-pass-01
- Topic ID: R-TOPIC-009
- Status: captured
- Scope: Rust and other high-quality open-source libraries for Excel-relevant Office Open XML processing (read/write/manipulation), with compatibility and implementation-fit comparison for DnaCalc.
- Exclusions: Non-open-source/commercial-only libraries as primary candidates; Power Query/DAX; full calc-engine parity analysis.

## Goals
1. Identify best available Rust options and realistic integration strategies.
2. Compare with mature non-Rust libraries used in production ecosystems.
3. Produce a decision matrix and recommendation lanes (direct use / reference implementation / fallback toolchain).
4. Capture reproducible source evidence with date-stamped metadata.

## Primary outputs
- `outputs/01_research_report.md`
- `outputs/02_library_inventory_github_snapshot.csv`
- `outputs/03_library_comparison_matrix.csv`
- `outputs/04_recommendation_lanes.md`
- `outputs/05_follow_up_queries.md`
- `outputs/source_list.csv`

## Method summary
- Prompt-driven deep-research framing from `prompts/PROMPT_PACK_DEEP_RESEARCH.md` adapted to Office XML library landscape.
- Source collection from official project repos/docs and Microsoft/OpenXML standard references.
- GitHub API metadata snapshot for activity/license/release signals captured on run date.