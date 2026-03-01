# spec-pack-processor

Builds a normalized, back-referenced reference-spec corpus from mirrored Microsoft spec artifacts.

## Purpose
- Convert mirrored binary/doc artifacts into text-first segments with stable source anchors.
- Emit sentence-level classification tasks and conformance candidate items.
- Keep extraction coverage explicit (especially for PDFs that still need OCR/text tooling).

## Commands
- `run --source-index <csv> --out <dir> [--filter <text>] [--max-docs N] [--include-ext .docx,.md,.pdf,.html,.htm]`

## Usage
From repo root:

```cmd
tools\spec-pack-processor\spec-pack-processor.cmd run --source-index reference\index.csv --out reference\runs\specproc-demo\outputs --filter MS-XLSX --max-docs 3
```

## Outputs
- `run_manifest.json`
- `documents.csv`
- `selected_sources.csv`
- `spec_items.jsonl`
- `conformance_items.jsonl`
- `conformance_excluded.jsonl`
- `llm/classification_tasks.jsonl`
- `docs/<document_id>/document_manifest.json`
- `docs/<document_id>/segments.jsonl`
- `docs/<document_id>/sentences.jsonl`
- `docs/<document_id>/spec_items.jsonl`
- `docs/<document_id>/conformance_candidates.jsonl`
- `docs/<document_id>/conformance_excluded.jsonl`
- `docs/<document_id>/images/*` (for docx image artifacts)

## Notes
- PDF extraction uses `pdftotext` when available on `PATH`.
- If `pdftotext` is unavailable, the tool falls back to in-process `PdfPig` extraction (`extraction_mode=pdf_pdfpig`).
- If both paths fail, the run records explicit `pdf_pending` segments and pending counts.
- Tool runtime is C#/.NET and follows repository tooling policy.
- JSON/JSONL output records use `snake_case` keys.

## Planned Extensions (Deferred Until Needed)
1. External LLM ingestion layer:
   - import reviewed classifier outputs and merge them over deterministic sentence tasks.
2. Expanded PDF/image extraction:
   - OCR adapters and richer image artifact extraction for PDF-heavy specs.

## Comparison Helper
Use the source-group comparison script to compare official-spec inputs against auxiliary web/reference inputs in a completed run:

```powershell
pwsh -File tools/spec-pack-processor/compare-source-groups.ps1 `
  -RunOutputsDir reference/runs/<run-id>/outputs `
  -OfficialSourceIds MS-VBAL,discovered `
  -ReferenceSourceIds VBA-API-OVERVIEW,VBA-FUNCTIONS,VBA-LANG-UIHELP `
  -OfficialUrlContains MS-VBAL
```
