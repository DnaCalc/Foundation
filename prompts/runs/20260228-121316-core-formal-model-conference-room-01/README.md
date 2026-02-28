# Core Engine Formal Model Conference Room

- Run ID: 20260228-121316-core-formal-model-conference-room-01
- Run type: prompt-run workspace (conference room / planning)
- Lifecycle status: captured
- Snapshot taken: 2026-02-28T12:14:34+02:00

## Snapshot Provenance
- Foundation repo commit: 7b0a37d (7b0a37df7ecb11684c246c69954966d1c4571bbb, commit time 2026-02-28T12:00:01+02:00)
- DnaVisiCalc repo commit: 7c2be9e (7c2be9eb2850c64e89826c2fddb38a7225adf495, commit time 2026-02-28T11:57:50+02:00)

This run freezes working copies of the current document context for long-running, interactive multi-agent planning sessions focused on the core engine formal model.

## Why This Is Under `prompts/runs`
Per `OPERATIONS.md` and `prompts/README.md`, this workspace is pre-synthesis planning/ideation capture, not doctrine promotion and not source-backed external research. The outputs produced here are suggestions/work products that require synthesis before source-of-truth edits.

## Included Source Sets
1. Foundation core documents (authoritative in this repo):
   - `CHARTER.md`
   - `ARCHITECTURE_AND_REQUIREMENTS.md`
   - `OPERATIONS.md`
   - `CORE_ENGINE_FORMAL_MODEL.md`
2. Foundation notes and formal-history context:
   - `notes/BRAINSTORM_NOTES.md`
   - `notes/FORMAL_*` redirect stubs
   - `notes/archive/formal-model/*` archived full-content formal-note sources
3. DnaVisiCalc pathfinder scope docs:
   - `..\\DnaVisiCalc\\docs\\SPEC_v0.md`
   - `..\\DnaVisiCalc\\docs\\ENGINE_REQUIREMENTS.md`
   - `..\\DnaVisiCalc\\docs\\ENGINE_API.md`
   - plus `SPEC_v0_INTEGRATION_APPENDIX.md` as supporting appendix

## Source Status Matrix
See `inputs/source_index.csv` for each copied file with:
- origin path,
- copied path,
- current status in repo usage,
- authority level,
- role and notes.

## Layout
- `inputs/conference_brief.md`: session kickoff goals, assumptions, and guardrails.
- `inputs/source/`: frozen source copies for this run.
- `inputs/source_index.csv`: status/authority mapping.
- `inputs/source_hashes.csv`: SHA256 hashes for frozen copies.
- `logs/manifest.csv`: run manifest and lifecycle note.
- `responses/`: place session outputs, meeting notes, agent exchanges, or derived plans.

## Working Rule
Treat this run as a conference-room sandbox. Promote decisions only via a later synthesis run that records explicit accept/adapt/defer/reject outcomes and updates source-of-truth docs.