# Reference Spec Processing Format and Conformance Doctrine

This document defines the normalized artifact shape produced from mirrored external specification packs.

## Design goals
- Preserve provenance and reproducibility for every extracted claim.
- Keep extraction and interpretation separate.
- Keep incomplete extraction visible (never silent data loss).
- Support deterministic diffs across tool runs.

## Layer model
1. Raw mirror layer
- Location: `reference/downloads/`
- Authority: byte-preserved source mirrors with SHA-256 in `reference/index.csv`.

2. Normalized reference layer
- Location: `reference/runs/<run-id>/outputs/`
- Authority: extracted text segments plus source anchors.

3. Conformance-candidate layer
- Location: same run directory (`conformance_items.jsonl`)
- Authority: machine-generated candidate requirements that must be reviewed before being promoted into test packs or formal models.

## Required output files per run
- `run_manifest.json`
- `documents.csv`
- `selected_sources.csv`
- `conformance_items.jsonl`
- `conformance_excluded.jsonl`
- `llm/classification_tasks.jsonl`
- `docs/<document_id>/document_manifest.json`
- `docs/<document_id>/segments.jsonl`
- `docs/<document_id>/sentences.jsonl`
- `docs/<document_id>/conformance_candidates.jsonl`
- `docs/<document_id>/conformance_excluded.jsonl`

All JSON/JSONL records use `snake_case` property names.

## Segment requirements
Each segment record must include:
- stable `segment_id`
- `document_id`
- segment `kind` (`heading`, `paragraph`, `table_cell`, `image_ref`, `pdf_pending`, ...)
- normalized text
- source back-reference (`source_url`, mirrored `local_path`, and finest available anchor)

## Conformance candidate requirements
Each candidate item must include:
- stable `item_id`
- source sentence reference
- normative classification (`must`, `shall`, `should`, `may`, etc.)
- priority
- verification-hint tag
- source back-reference

Excluded normative records (`conformance_excluded.jsonl`) must retain the same source linkage and include an explicit `exclusion_reason`.

## LLM usage constraints
- LLM classification must operate over deterministic extraction outputs.
- Classification artifacts must be stored as run outputs.
- Human review or additional synthesis is required before doctrine promotion.

## Coverage and uncertainty policy
- Any unsupported/unextracted content (especially OCR-pending PDFs) must emit explicit pending entries.
- Pending counts are mandatory run-level metrics.
- No step may silently drop tables/images/sections.

## Planned Extensions (Deferred, Implement As Needed)
1. External LLM ingestion:
- import reviewed classifier outputs and attach them as auditable overlays on sentence records.
2. Expanded PDF/image extraction:
- OCR adapters and richer image extraction for PDF-heavy sources.

The baseline pipeline should remain useful without these extensions; add them only when scope pressure requires them.
