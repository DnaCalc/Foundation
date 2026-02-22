# Deep Research Run Checklist (Runs 1 and 2)

## Run Metadata
- Run ID:
- Topic ID:
- Prompt source:
- Owner:
- Date (UTC):

## 1) Pre-Run Setup
- [ ] Create run folder: `research/runs/<run-id>/`
- [ ] Create subfolders:
  - `inputs/`
  - `outputs/`
  - `logs/`
- [ ] Copy prompt text into `inputs/prompt.txt`
- [ ] Save topic context into `inputs/topic_context.md`
- [ ] Capture input hashes in `inputs/source_hashes.csv`
- [ ] Initialize `logs/manifest.csv` (from template)
- [ ] Record initial manifest row (`init`)

## 2) Run 1 Checklist (Master Landscape)
- [ ] Use prompt: `prompts/PROMPT_PACK_DEEP_RESEARCH.md` Run 1
- [ ] Include four core docs in prompt context
- [ ] Produce `outputs/response.md`
- [ ] Produce `outputs/source_list.csv`
- [ ] Produce `outputs/research_report.md`
- [ ] Validate output contains:
  - [ ] executive summary
  - [ ] prioritized reading order
  - [ ] research map sections
  - [ ] annotated bibliography with links
  - [ ] risk retirement table
  - [ ] follow-up run recommendations
- [ ] Record manifest row (`run1_complete`)

## 3) Run 2 Checklist (Concurrency + MVCC)
- [ ] Use prompt: `prompts/PROMPT_PACK_DEEP_RESEARCH.md` Run 2
- [ ] Include four core docs in prompt context
- [ ] Include selected Run 1 concurrency-relevant sources
- [ ] Produce `outputs/response.md`
- [ ] Produce `outputs/source_list.csv`
- [ ] Produce `outputs/research_report.md`
- [ ] Validate output contains:
  - [ ] source shortlist (10–15)
  - [ ] TLA+ model pattern shortlist
  - [ ] failure modes mapped to invariants
  - [ ] TLC config and scaling strategy
  - [ ] translation guide from project terms to TLA+ variables/actions
- [ ] Record manifest row (`run2_complete`)

## 4) Cross-Run Evidence Hygiene
- [ ] Ensure each source has URL and accessed date
- [ ] Add/merge discovered sources into `research/sources.csv`
- [ ] Update topic status in `research/topic_registry.csv`
- [ ] Keep findings in research artifacts only (no doctrine edits yet)

## 5) Post-Run Outputs
- [ ] Create `outputs/combined_findings.md` (or equivalent summary)
- [ ] List top sources and immediate obligation-pack candidates
- [ ] Record manifest row (`postrun_complete`)
- [ ] Note deferred topics (`Run 3`, `Run 4`) and rationale
