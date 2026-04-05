# Reference Workspace

This folder stores local mirror/index artifacts for external specification packs, managed processing runs for conformance extraction, and curated empirical findings promoted from research runs.

## Scope
- Primary target: Microsoft Open Specifications pages and downloadable artifacts for Excel/Office and VBA-adjacent interoperability specs.
- Seed entry points are listed in `spec_seeds.csv`.

## Layout
- `downloads/`: raw mirrored source artifacts that are small enough to retain in git.
- `index.csv`: machine-readable mirror index (including hashes and download timestamps).
- `index.md`: human-readable mirror summary.
- `runs/<run-id>/`: managed spec-processing run artifacts (`inputs`/`outputs`/`logs` style). Compact promoted packs stay in git; bulky processor intermediates may be moved to the local cache with tracked omission manifests.
- `empirical/`: curated empirical findings promoted as stable conformance-source references.
- `conformance/`: authoritative working conformance specification docs and requirement corpora.
- `.local/reference-cache/` (gitignored): local cache root for bulky raw bundles, expanded processor intermediates, extracted images, and other regeneration-heavy artifacts that should remain indexed but should not bloat the repository.

## Update Procedure (Mirror)
Run:

```powershell
pwsh -File reference/Update-SpecMirror.ps1
```

The script:
- fetches seed Open Specs pages as markdown (`?accept=text/markdown`),
- expands Office standards children from `MS-OFFSTANDLP` relative links,
- discovers downloadable artifacts (PDF/DOCX/ZIP/RSS),
- downloads in-scope files to `downloads/`,
- records `downloaded_utc` timestamps per file in `index.csv`.

Large umbrella bundles or other bulky cache-only artifacts may be moved after download into `.local/reference-cache/` while remaining indexed by URL, hash, size, and local-cache path.

## Processing Procedure (Managed Run)
After mirroring, normalize selected specs into text-first, anchor-preserving artifacts:

```powershell
tools\spec-pack-processor\spec-pack-processor.ps1 run --source-index reference/index.csv --out reference/runs/<run-id>/outputs
```

The processing run emits:
- segment-level extracted text with source anchors,
- sentence-level classification task list (`llm/classification_tasks.jsonl`),
- spec-item list (`spec_items.jsonl`),
- conformance candidate items (`conformance_items.jsonl`),
- excluded normative items with explicit reasons (`conformance_excluded.jsonl`),
- selected-source capture for reproducibility (`selected_sources.csv`),
- per-document manifests and explicit pending coverage markers.

When a processing run produces very large intermediate files, keep the compact promoted pack in `reference/runs/<run-id>/` and move the bulky intermediates into `.local/reference-cache/reference/runs/<run-id>/`. The tracked run should then include a concise omission manifest that records the moved artifact paths, hashes, sizes, and local-cache destinations.

Detailed artifact contract: `REFERENCE_SPEC_FORMAT_AND_CONFORMANCE.md`.

For official-vs-reference source-group comparisons on completed runs, use:

```powershell
pwsh -File tools/spec-pack-processor/compare-source-groups.ps1 -RunOutputsDir reference/runs/<run-id>/outputs
```

## Notes
- Historical revision downloads discovered on spec pages are indexed but marked `excluded_historical` by default.
- Very large umbrella bundles (for example `Windows_Protocols.zip`) are indexed and marked `excluded_large_bundle` by default. Prefer keeping those bundles in `.local/reference-cache/` rather than in the tracked repo tree.

## Test Corpus
The `test-corpus/` directory holds curated test corpora for verifying DNA Calc formula evaluation and workbook behavior against Excel. It includes:
- `EXTERNAL_CORPORA_INDEX.csv`: references to external test suites (HyperFormula, Apache POI, LibreOffice, Gnumeric, Calamine, pbartxl gists).
- `formula/single-cell/`: single-cell formula test cases (JSONL) for OxFml / DnaOneCalc proving.
- `formula/multi-cell/` and `workbook/`: future multi-cell and workbook-level test suites.

Schema and governance details: `test-corpus/README.md` and `test-corpus/formula/README.md`.

## Empirical Findings Promotion
Empirical run outputs are produced under `research/runs/<run-id>/` and remain working evidence by default.
Only high-value, conformance-relevant observations should be promoted into `reference/empirical/`.

Planning and rollout guidance: `reference/empirical/EMPIRICAL_PROMOTION_PLAN.md`.

Promoted findings must include:
- a stable empirical finding id (`EMP-*`),
- a concise claim statement,
- back-links to run/scenario evidence artifacts,
- Excel build/version and `EXCEL.EXE` hash from the run,
- runner/tool version and source revision metadata.

This keeps the conformance input corpus in `reference/` unified while preserving full provenance back into research execution artifacts.
