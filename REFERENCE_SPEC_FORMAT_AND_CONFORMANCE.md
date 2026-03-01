# Reference Spec Processing Format and Conformance Doctrine

This document defines the normalized artifact shape used to build conformance-source inputs from:
- mirrored external specification packs, and
- curated empirical findings promoted from research runs.

## Design goals
- Preserve provenance and reproducibility for every extracted claim.
- Keep extraction and interpretation separate.
- Keep incomplete extraction visible (never silent data loss).
- Support deterministic diffs across tool runs.
- Keep spec-derived and empirical-derived evidence linkable in one conformance source model.

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

4. Curated empirical finding layer
- Location: `reference/empirical/`
- Authority: selected, high-value empirical observations promoted from `research/runs/<run-id>/` with full provenance.
- Scope rule: promotion is selective; not every empirical test output is promoted.

5. Unified conformance-source layer
- Location: references from formal requirements/conformance work products.
- Authority: requirements may cite spec-derived (`SPEC-*`) and/or empirical-derived (`EMP-*`) evidence ids.

## Required output files per run
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

All JSON/JSONL records use `snake_case` property names.

## Empirical promotion files
The curated empirical layer must include:
- `reference/empirical/README.md`
- `reference/empirical/findings_registry.jsonl`
- `reference/empirical/findings_index.md`
- `reference/empirical/findings/TEMPLATE.md`

Each promoted finding record in `findings_registry.jsonl` must include:
- stable `finding_id` (`EMP-*`)
- concise `claim`
- `status` (`provisional`, `confirmed`, `superseded`, `deprecated`)
- `source_run_id`
- `source_task_or_scenario_id`
- `source_evidence_paths` (one or more run-relative or repo-relative paths)
- `excel_version`
- `excel_build`
- `excel_exe_sha256`
- `runner_name`
- `runner_version`
- `tool_commit`
- `captured_utc`
- `notes`

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

## Spec item requirements
Each spec item must include:
- stable `item_id`
- source sentence reference
- `spec_level` classification (`normative` or `informative`)
- source back-reference

## LLM usage constraints
- LLM classification must operate over deterministic extraction outputs.
- Classification artifacts must be stored as run outputs.
- Human review or additional synthesis is required before doctrine promotion.
- LLM summarization of empirical findings is allowed only if raw empirical evidence links and environment metadata remain intact.

## Coverage and uncertainty policy
- Any unsupported/unextracted content (especially OCR-pending PDFs) must emit explicit pending entries.
- Pending counts are mandatory run-level metrics.
- No step may silently drop tables/images/sections.
- PDF extraction should attempt deterministic text extraction first (`pdftotext`), then in-process fallback extraction (`PdfPig`), and emit pending markers only if both fail.
- Empirical findings that conflict with specification text must be retained as explicit dual-source records (not silently overwritten), with follow-up decision notes.

## Planned Extensions (Deferred, Implement As Needed)
1. External LLM ingestion:
- import reviewed classifier outputs and attach them as auditable overlays on sentence records.
2. Expanded PDF/image extraction:
- OCR adapters and richer image extraction for PDF-heavy sources.

The baseline pipeline should remain useful without these extensions; add them only when scope pressure requires them.
