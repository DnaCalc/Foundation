# spec-pack-processor

Builds a normalized, back-referenced reference-spec corpus from mirrored Microsoft spec artifacts.

## Purpose
- Convert mirrored binary/doc artifacts into text-first segments with stable source anchors.
- Emit sentence-level classification tasks and conformance candidate items.
- Keep extraction coverage explicit (especially for PDFs that still need OCR/text tooling).

## Commands
- `run --source-index <csv> --out <dir> [--filter <text>] [--max-docs N] [--include-ext .docx,.md,.pdf]`

## Usage
From repo root:

```cmd
tools\spec-pack-processor\spec-pack-processor.cmd run --source-index reference\index.csv --out reference\runs\specproc-demo\outputs --filter MS-XLSX --max-docs 3
```

## Outputs
- `run_manifest.json`
- `documents.csv`
- `conformance_items.ndjson`
- `llm/classification_tasks.ndjson`
- `docs/<document_id>/document_manifest.json`
- `docs/<document_id>/segments.ndjson`
- `docs/<document_id>/sentences.ndjson`
- `docs/<document_id>/conformance_candidates.ndjson`
- `docs/<document_id>/images/*` (for docx image artifacts)

## Notes
- PDF extraction uses `pdftotext` when available on `PATH`.
- If no PDF extractor is available, the run records explicit `pdf_pending` segments and pending counts.
- Tool runtime is C#/.NET and follows repository tooling policy.

## Planned Extensions (Deferred Until Needed)
1. External LLM ingestion layer:
   - import reviewed classifier outputs and merge them over deterministic sentence tasks.
2. Expanded PDF/image extraction:
   - OCR adapters and richer image artifact extraction for PDF-heavy specs.
