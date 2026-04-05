# Test Corpus

This directory holds curated test corpora for verifying DNA Calc formula evaluation and workbook behavior against Excel. It is a conformance-source artifact, alongside `conformance/` and `empirical/`.

## Layout

- `EXTERNAL_CORPORA_INDEX.csv`: references to external test suites on GitHub and elsewhere (not copied into this repo).
- `formula/`: formula-level test corpora.
  - `single-cell/`: formulas evaluable in a single cell/call (suitable for OxFml / DnaOneCalc).
  - `multi-cell/`: future -- formulas requiring multi-cell interaction.
- `workbook/`: future -- workbook-level test scenarios.

## Governance

- **Clean-room rule applies**: all test material derives from public documentation, published research, reproducible Excel observation, or attributed open-source test suites (MIT/Apache-2.0/MPL-2.0).
- **Provenance is mandatory**: every test entry tracks its source via `source_ids` linking to `research/sources.csv` (`R-SRC-*`) or `EXTERNAL_CORPORA_INDEX.csv` (`EXT-TC-*`).
- **Evidence linkage**: entries may cross-reference conformance requirements (`XLS-CF-*` in `conformance/`) and empirical findings (`EMP-*` in `empirical/`).
- **Canonical format**: JSONL (one JSON object per line), matching the pattern established by `empirical/findings_registry.jsonl`.

## Relationship to Other Conformance Infrastructure

| Artifact | Purpose | Location |
|---|---|---|
| Conformance requirements | What must hold | `reference/conformance/` |
| Empirical findings | What was observed | `reference/empirical/` |
| **Test corpus** | **What to evaluate** | `reference/test-corpus/` |
| Research runs | How we investigated | `research/runs/` |

The test corpus feeds into DnaOneCalc proving and future `PACK.formula.*` obligation packs.
