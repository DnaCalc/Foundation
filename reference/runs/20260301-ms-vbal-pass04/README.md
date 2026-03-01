# MS-VBAL First Reference Processing Pass (Validated)

Run root: `reference/runs/20260301-ms-vbal-pass04`

## Intent
- Validate that the reference processing pipeline can ingest a real Microsoft Open Spec (`MS-VBAL`) and produce stable conformance-ready artifacts.
- Use this run to identify and fix quality issues in schema, filtering, and reproducibility metadata.

## Inputs
- Source index: `reference/index.csv`
- Filter: `MS-VBAL`
- Captured source set: `outputs/selected_sources.csv`
- Foundation commit at run invocation: `inputs/foundation_commit.txt`
- Run capture UTC: `inputs/captured_utc.txt`

## Command
```powershell
tools\spec-pack-processor\spec-pack-processor.cmd run --source-index reference\index.csv --out reference\runs\20260301-ms-vbal-pass04\outputs --filter MS-VBAL
```

## Outcome
- Documents processed: 4
- Conformance candidates: 412
- Conformance excluded: 4
- Pending items: 2 (`pdf_pending_ocr` for two PDF artifacts without `pdftotext` on PATH)

## Quality Notes
- JSON/JSONL schema is now `snake_case` throughout.
- Candidate extraction now keeps an explicit excluded stream (`conformance_excluded.jsonl`) with reasons, avoiding silent drops.
- Normative keyword filtering was tightened to reduce false positives from lowercase lexical tokens (for example month `May`).
- Obvious legal/metadata front-matter noise is excluded with explicit reasons.

## Known Remaining Gaps
- PDF text extraction remains pending on environments without `pdftotext`; this run still provides explicit pending markers and counts.
- Conformance tagging/verification hints are heuristic and intentionally conservative; human review is still required before pack promotion.
