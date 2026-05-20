# Corpus Campaign Workflow

This workflow keeps the formula corpus campaign state durable in Foundation instead of relying on transient terminal memory.

## Goals

- keep a latest-known case ledger across many reruns,
- separate external OneCalc truth from local repo witness progress,
- track current repo-worker state without directly inspecting sibling repos,
- make stalled prompts and ownership splits visible quickly.

## Source Artifacts

Current external truth comes from retained batch reports under:

> `reference/test-corpus/workspace/results/`
- per-batch `verification-bundle-report.json`
- targeted rerun directories such as `FTC_0600_FTC_0600/`
- historical baseline summaries such as `full_corpus_nonmatch_by_category.txt`

Corpus definitions live under:

> `reference/test-corpus/formula/single-cell/`
- `formulas.jsonl`
- `CORPUS_MANIFEST.json`

## Monitoring Tool

Use:

```powershell
tools\corpus-monitor\corpus-monitor.ps1 snapshot
tools\corpus-monitor\corpus-monitor.ps1 watch --interval-seconds 60
```

Generated monitoring outputs live under:

> `reference/test-corpus/workspace/monitoring/`
- `corpus-campaign-status.json`
- `corpus-campaign-status.md`
- `subagent-monitor-status.json`
- `subagent-monitor-status.md`
- optional `campaign-notes.jsonl`

## Operating Loop

1. Run or rerun a corpus batch from Foundation.
2. Run `corpus-monitor snapshot`.
3. Review `corpus-campaign-status.md` for the latest open-case ledger.
4. Review `subagent-monitor-status.md` for worker state and prompt-pending detection.
5. Route new semantic failures to the owning repo worker.
6. Add or update coordinator notes in `campaign-notes.jsonl` when ownership, escalation, or next action changes.
7. Re-run targeted cases through OneCalc after repo-local fixes land.

## Classification Discipline

- `matched`: latest retained external run is green.
- `blocked`: OneCalc lane could not complete comparison.
- `display_only`: value matches but display diverges.
- `volatile_deferred`: uses `RAND`, `RANDBETWEEN`, or `RANDARRAY`; normally deferred.
- `semantic_or_runtime`: real semantic/runtime mismatch until narrowed further by worker evidence.

When repo-local witness evidence changes the interpretation, record that in `campaign-notes.jsonl` instead of mutating old batch artifacts.

## Locale Context Policy

Locale-sensitive behavior must be treated as explicit host-provided input, not as an implicit evaluator default.

Rules:

- `OxFml` must not use a silent `en-US` fallback as verification truth for corpus-facing or programmatic verification paths.
- For the formula corpus lane, `DnaOneCalc` is the current owner of default verification context. Its steady-state responsibility is to provide explicit default host context for these runs:
  - locale: `en-US`
  - normal/default formatting settings for the corpus host profile
- The desired corpus path is therefore:
  - `DnaOneCalc` provides explicit default locale/formatting context,
  - `OxFml` consumes that context honestly,
  - the corpus flows through to `Matched` where behavior agrees.
- Honest `Blocked` results remain useful as temporary diagnostics while the host path is being wired, but they are not the intended long-term outcome for ordinary formula corpus cases.
- Host-driven locale-sensitive validation belongs at the higher-level verification lane where a real host/environment is present.
- Repo-local convenience tests may use explicit locale fixtures, but they must name that locale in the test setup rather than depending on an implicit fallback.

Cleanup rule:

- When this policy changes, remove or rewrite old-policy residue in code, tests, and docs rather than leaving deprecated fallback paths available for accidental reuse.
- For any case where local green differs from external verification, first check whether the local path injected locale/format context that the external path did not.
- If the corpus lane is blocking only because locale/format context is absent, treat that as a `DnaOneCalc` host-path gap to close, not as the desired steady-state verdict.

## Worker Monitoring

The monitor polls the active panes:

- `OxReplay`
- `OxXlPlay`
- `DnaOneCalc`
- `OxFml`
- `OxFunc`

Prompt visibility detection is intentionally simple: if a fresh capture still ends with a visible `›` prompt and there is no nearby active `Working` indicator, the coordinator should suspect the pane may need `Enter`.

## Escalation Use

Mark `needs_user_review=true` in `campaign-notes.jsonl` for:

- policy/compatibility questions,
- cross-repo ownership splits that remain unresolved,
- cases that are locally green but externally red after rerun,
- host-formatting-context disputes and locale/default-environment anomalies.
