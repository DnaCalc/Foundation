# Reference Workspace

This folder stores local mirror/index artifacts for external specification packs and managed processing runs for conformance extraction.

## Scope
- Primary target: Microsoft Open Specifications pages and downloadable artifacts for Excel/Office and VBA-adjacent interoperability specs.
- Seed entry points are listed in `spec_seeds.csv`.

## Layout
- `downloads/`: raw mirrored source artifacts.
- `index.csv`: machine-readable mirror index (including hashes and download timestamps).
- `index.md`: human-readable mirror summary.
- `runs/<run-id>/`: managed spec-processing run artifacts (`inputs`/`outputs`/`logs` style).

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

## Processing Procedure (Managed Run)
After mirroring, normalize selected specs into text-first, anchor-preserving artifacts:

```powershell
tools\spec-pack-processor\spec-pack-processor.ps1 run --source-index reference/index.csv --out reference/runs/<run-id>/outputs
```

The processing run emits:
- segment-level extracted text with source anchors,
- sentence-level classification task list (`llm/classification_tasks.ndjson`),
- conformance candidate items (`conformance_items.ndjson`),
- per-document manifests and explicit pending coverage markers.

Detailed artifact contract: `REFERENCE_SPEC_FORMAT_AND_CONFORMANCE.md`.

## Notes
- Historical revision downloads discovered on spec pages are indexed but marked `excluded_historical` by default.
- Very large umbrella bundles (for example `Windows_Protocols.zip`) are indexed and marked `excluded_large_bundle` by default.
