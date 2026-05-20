# Corpus Monitor

Foundation-local monitoring tool for the formula corpus campaign.

Purpose:
- build a durable latest-known ledger from retained `verification-bundle-report.json` artifacts,
- merge optional coordinator notes for case ownership and next actions,
- poll the active repo panes through `wtd capture`,
- write machine-readable and human-readable status snapshots into the formula workspace.

Default output directory:
- `reference/test-corpus/workspace/monitoring/`

Primary generated artifacts:
- `corpus-campaign-status.json`
- `corpus-campaign-status.md`
- `subagent-monitor-status.json`
- `subagent-monitor-status.md`

Optional coordinator overlay:
- `campaign-notes.jsonl`

Each line in `campaign-notes.jsonl` should be a JSON object keyed by `case_id`.

Example:
```json
{"case_id":"FTC-0600","owner_repo":"OxFunc","local_repro_status":"fixed_local_and_external","next_action":"none","needs_user_review":false}
{"case_id":"FTC-0288","owner_repo":"DnaOneCalc","issue_family":"display_context","next_action":"confirm host-side formatting context before further engine edits","needs_user_review":true}
```

Usage:
```powershell
tools\corpus-monitor\corpus-monitor.ps1 snapshot
tools\corpus-monitor\corpus-monitor.ps1 watch --interval-seconds 60
```

Notes:
- `watch` rewrites the monitoring artifacts on each interval.
- Pane polling is best-effort; failures are recorded in the output instead of aborting the snapshot.
- This tool is for campaign bookkeeping and coordinator visibility; it does not replace per-run retained bundle reports.
