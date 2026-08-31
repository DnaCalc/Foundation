# DNA Calc housekeeping list — 2026-08-31

Working note, not doctrine. Companion to `PROGRAM_INVESTIGATION_2026-08-30.md`.

This pass: save useful uncommitted work on `main`/`master`, park junk in
`C:\Work\DnaCalc\_housekeeping_delete_review`, ignore cargo-target clutter,
remove extra git worktrees (branches kept), push repos that already have GitHub
remotes.

## Delete-review directory

`C:\Work\DnaCalc\_housekeeping_delete_review` (not a git repo; not pushed)

| Parked | Why |
|---|---|
| `DnaTreeCalc/scratch/` | Local review notes / logs / lambda export; not source of truth |
| `Foundation/output/` | Generated PDFs of the investigation report |
| `OxFunc/wait_erfc_r1z0r0.py` | Machine-specific SSH waiter for a firehorse campaign |
| `OxForms/.W010*.capture-staging-*` | Duplicate capture staging leftovers; canonical capture kept in-tree |
| `OxVba-worktrees/win14-excel-oracle-artifacts/` | Untracked worktree artifacts |
| `OxVba-worktrees/win0-handoff-projected.diff` | Uncommitted diff from a detached worktree |

Review then delete that folder when satisfied.

## Local cargo trees not copied (too large)

OxFunc has many untracked `target-*` directories (cargo `--target-dir` leftovers),
on the order of tens of gigabytes. They are now gitignored (`/target-*/`). They
were **not** moved. Safe local delete once you confirm no unique non-build files:

```
Get-ChildItem C:\Work\DnaCalc\OxFunc -Directory -Filter 'target-*'
```

## GitHub remotes

| Repo | Remote | Notes |
|---|---|---|
| Most lane/host repos | `https://github.com/DnaCalc/<name>.git` | present |
| **OxForms** | **none** | no `DnaCalc/OxForms` on GitHub; local commits only until a repo is created |
| DnaOxIde | not a git repo | design mockups only |

## Branches kept (not merged, not deleted)

Do not delete these until a later review. They were left in place because they
are not obviously empty of unique work.

### DnaTreeCalc (local-only unless noted)

- `atlas-phase-b-wrapup`
- `atlas-phase-b2`
- `atlas-skin-refinement`
- `atlas-spine-flow`
- `claude/modest-nobel-989bb3` (also on origin; ancestor of current `main`)
- `claude/vibrant-wilbur-5920f0`
- `s2-notebook`
- `s3-sheet`

### OxCalc (local-only)

- `ctro-graph-model-rework`
- `name-error-for-missing-names`

### OxFml (local-only)

- `name-error-for-missing-names`
- `wip/oxfml-a1-grammar-extraction`

### OxFunc

- `docs/reconcile-deviation-catalog-fixer-quickstart` (local)
- `name-error-for-missing-names` (local)
- `w100-w102-cleanup-pass` (local)
- `w105-d1-catalog-conformance` (also origin)
- `w108-excel-numeric-core` (local)

### OxVba

Large `codex/bd-*` and `claude/*` set, mostly also on `origin`. Unique commits
exist vs `master` on many of these (parallel AutoRun lanes, not necessarily
unmerged-by-patch). Also local-only: `improve-2026-07`, `oxir-vm3-m3`,
`codex/bd-59co-2-2-16-vbarecord-transaction`, `codex/bd-59co-2-2-17-*`,
`codex/bd-59co-2-2-20-variant-provenance`, `codex/bd-59co-2-2-21-variantcore-init`,
`codex/bd-59co-2-2-8-linux-ci`, `codex/bd-59co-3-1-4-win0-fixtures`.
`oxir-vm3-finish` is on origin.

**Follow-up:** cherry-pick audit of OxVba `master..<branch>` for anything not
already landed under a different hash, then delete merged `codex/*` branches
and origin counterparts.

## Worktrees

Extra worktrees were removed on 2026-08-31. Canonical checkouts:

- `DnaTreeCalc` → `main` only
- `OxVba` → `master` only

Named branches remain. `OxVba-wt-*` directories are gone.

## OxForms GitHub

Created `https://github.com/DnaCalc/OxForms` (public) and pushed `master`.
GitHub warned that `msforms_parity_ledger.v1.json` is 52.37 MB (over the 50 MB
recommendation). Follow-up: LFS or split the ledger.

## Not a git repo

- `DnaOxIde` — mockups only; decide later whether to init or ignore.
