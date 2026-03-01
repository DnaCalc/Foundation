# Managed Spec Mirror

This folder stores locally mirrored external specification documents used by Foundation research.

## Scope
- Primary target: Microsoft Open Specifications pages and downloadable artifacts for Excel/Office and VBA-adjacent interoperability specs.
- Seed entry points are listed in `spec_seeds.csv`.

## Outputs
- `downloads/`: local copies of mirrored documents.
- `index.csv`: machine-readable index of mirrored and excluded candidates.
- `index.md`: human-readable run summary and index digest.

## Update Procedure
Run:

```powershell
pwsh -File research/specs/Update-SpecMirror.ps1
```

The script:
- fetches seed Open Specs pages as markdown (`?accept=text/markdown`),
- expands Office standards children from `MS-OFFSTANDLP` relative links,
- discovers downloadable artifacts (PDF/DOCX/ZIP/RSS),
- downloads in-scope files to `downloads/`,
- records `downloaded_utc` timestamps per file in `index.csv`.

## Notes
- Historical revision downloads discovered on spec pages are indexed but marked `excluded_historical` by default.
- Very large umbrella bundles (for example `Windows_Protocols.zip`) are indexed and marked `excluded_large_bundle` by default.
