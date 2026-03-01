# MS-VBAL + VBA Web Reference Comparison (Latest Baseline)

Run root: `reference/runs/20260301-ms-vbal-webref-compare-v5-latest`

## Scope
- Official baseline (latest):
  - `[MS-VBAL]-250520.docx`
  - `[MS-VBAL].pdf` (undated filename, internal marker shows `v20250520`)
  - Learn OpenSpecs page for `MS-VBAL`
- Additional reference pages:
  - `office/vba/api/overview/language-reference`
  - `office/vba/language/reference/functions-visual-basic-for-applications`
  - `office/vba/language/reference/user-interface-help/visual-basic-language-reference`

## Tooling/Run Extensions Implemented
- Mirror script now requests markdown for all `learn.microsoft.com` seed pages, not only OpenSpecs pages.
- Added seeds for the three Office VBA Learn references in `reference/spec_seeds.csv`.
- `spec-pack-processor` now supports:
  - PDF fallback extraction via in-process `PdfPig` (`extraction_mode=pdf_pdfpig`),
  - HTML/HTM extraction (`extraction_mode=html_text_strip`),
  - run-level and per-document `spec_items.jsonl` output (in addition to conformance outputs),
  - improved markdown ingestion (front-matter metadata removal, list-item capture).
- Added reusable source-group comparison helper:
  - `tools/spec-pack-processor/compare-source-groups.ps1`

## Results (v5 latest baseline)
- Comparison report: `outputs/comparison_report.md`
- Metrics JSON: `outputs/comparison_metrics.json`
- High-level findings:
  - Official unique normalized spec items: `17058`
  - Reference unique normalized spec items: `158`
  - Official unique normalized conformance items: `409`
  - Reference unique normalized conformance items: `0`

Interpretation:
- The three VBA Learn pages are primarily catalog/overview/index material in this extraction pass.
- They contribute useful **spec-index entries** (function/topic catalogs), but do not currently add normative conformance statements under the current heuristic.

## PDF Redundancy Note (MS-VBAL)
- Latest-vs-latest extraction overlap remains low between DOCX and PDF in this pass:
  - Spec items overlap (`docx` vs `pdf`): intersection `47`, Jaccard `0.0028`
  - Conformance overlap (`docx` vs `pdf`): intersection `0`, Jaccard `0.0`
- This does **not** necessarily imply semantic divergence; it indicates extraction-shape divergence between DOCX parsing and current PDF text reconstruction.
- Prior run including both dated PDFs (`v3`) shows the two PDFs are near-duplicates of each other:
  - `pdf_old_vs_pdf_new` spec Jaccard `0.9699`
  - `pdf_old_vs_pdf_new` conformance Jaccard `0.9057`
  - See: `reference/runs/20260301-ms-vbal-webref-compare-v3/outputs/pdf_redundancy_metrics.json`

Practical conclusion:
- Treat PDF as a secondary delivery format for audit/fallback ingestion.
- Treat DOCX + OpenSpecs markdown as primary structured inputs for conformance extraction.
- Keep version filtering explicit (exclude older dated PDFs from "latest" compare baselines).

## Merge Guidance for Clear Work/Check Lists
- Maintain two lanes in managed outputs:
  - `spec_items.jsonl`: discovery/index/catalog coverage (including Learn catalogs),
  - `conformance_items.jsonl`: normative implementation obligations (primarily official specs).
- Generate source-group diffs for each run and track coverage deltas in `comparison_metrics.json`.
- Promote items into implementation worklists by lane:
  - Conformance lane -> test/proof obligations,
  - Spec lane -> backlog/index coverage and follow-up retrieval targets.
