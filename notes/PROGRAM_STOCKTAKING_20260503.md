# PROGRAM_STOCKTAKING_20260503.md — DNA Calc Program Stock-Taking

Purpose: capture the observed cross-repo state before the execution-doctrine rationalization pass and before preparing the `DnaTreeCalc` host repo.

Status: working note, not doctrine. Promote durable decisions through the managed synthesis/promotion path.

## 1. Coordination baseline

- Foundation is the coordination/doctrine home for cross-repo stock-taking, doctrine alignment, and new repo preparation.
- `wtd` is available at `C:\Work\WinTermDriver\target\release\wtd` and has a running `DnaCalc-pi` workspace.
- Observed active `DnaCalc-pi` panes: `Foundation`, `OxReplay`, `OxXlPlay`, `DnaOneCalc` (exited), `OxFml`, `OxFunc`, plus one unnamed pane.
- A first `wtd ask` was sent to `OxFml`; `OxFunc` also produced a status response. Some `wtd ask` calls timed out or hit host availability friction, so this note mixes direct filesystem inspection with partial agent responses.

## 2. Repo/folder inventory observed under `C:\Work\DnaCalc`

Recognized Foundation program repos/folders:
- `Foundation`
- `DnaVisiCalc`
- `DnaOneCalc`
- `OxFunc`
- `OxFml`
- `OxCalc`
- `OxVba`
- `OxReplay`
- `OxIde`
- `OxXlPlay`
- `DnaOxIde`

Not observed:
- `DnaTreeCalc` repo/folder does not yet exist under `C:\Work\DnaCalc`.

## 3. Current source-of-truth program state from Foundation docs

- Round 0 `DnaVisiCalc` implementation scope is exercised; formal artifact exit remains outstanding.
- Current execution waves:
  - Wave B: OxFml/OxFunc seam hardening.
  - Wave C: DNA OneCalc proving host.
  - Wave D: OxCalc tree-substrate realization and coordinator baseline.
  - Wave E: DNA TreeCalc proving host.
- Foundation owns doctrine/architecture/operations/conformance policy.
- Lane ownership remains:
  - `OxFunc`: value/function semantics.
  - `OxFml`: formula language, bind, evaluator-facing FEC/F3E seam.
  - `OxCalc`: multi-node core engine and tree-substrate coordinator policy.
  - `OxReplay`: shared replay implementation and `DNA ReCalc` tooling host.
  - `OxVba`: VBA runtime/compiler lane.
- New DNA Calc repos should follow `OPERATIONS.md` Section `8.18`: slim bootstrap, `.beads/`, `README.md`, `AGENTS.md`, `docs/CHARTER.md`, `docs/OPERATIONS.md`, `docs/SCOPE_AND_SPEC.md`, `docs/WORKSET_REGISTER.md`, `docs/BEADS.md`, and serialized `br` wrapper/check scripts.

## 4. Observed repo state snapshot

This is an observational snapshot only. Dirty worktrees may be active user/agent work.

| Repo | Branch observed | Dirty-state summary | Notes |
|---|---:|---:|---|
| `Foundation` | `master` | dirty | Several pre-existing modified/untracked research/reference/tooling files; this stock-taking pass only intends to add `AGENTS.md` coordination doctrine and this note. |
| `DnaVisiCalc` | `main` | clean | Pathfinder implementation repo; README lists broad exercised v0 scope. |
| `DnaOneCalc` | `main` | dirty | Only `.claude/` observed untracked in direct status. `wtd` pane was exited. |
| `OxFunc` | `main` | clean | Agent reported clean at `47b89b7 Prepare W089 axis witness sweep`. |
| `OxFml` | `main` | dirty | Agent reported uncommitted W067 diagnostic-span work; `cargo test -p oxfml_core` had passed before a downstream-note clear. |
| `OxCalc` | `main` | dirty | TreeCalc-local implementation/test-run changes observed, including `treecalc.rs`, runner, upstream host, and local test-run docs. |
| `OxVba` | `master` | dirty | Native-ready/runtime/compiler evidence and code changes observed. |
| `OxReplay` | `main` | clean | Pane was open but not actively loaded with a status response during this pass. |
| `OxIde` | `main` | dirty | Firehorse/mockup review and UX audit lab docs observed. |
| `OxXlPlay` | `main` | clean | Excel-playback/support repo present. |
| `DnaOxIde` | not observed | unclear | Folder exists but appeared empty/non-standard in quick inspection. |

## 5. Sibling-agent observations captured through `wtd`

### OxFunc

Reported state:
- Clean worktree at `47b89b7 Prepare W089 axis witness sweep`.
- Post-W070 bead-based execution model: `.beads/` is live execution/blocker truth; `docs/WORKSET_REGISTER.md` is ordered workset truth.
- Active lanes include semantic witness/runtime-provider bridge, current function-surface gaps, smart-fuzzer/exactness work, and cross-repo seam follow-ups.

Reported blockers/open pressure:
- Blocked beads include financial exactness drift, numeric comparison tolerance follow-up, and multi-area value materialization follow-up.
- Open ready issues include statistical exactness, non-statistical exactness/shape drifts, `BESSELY`, `MINVERSE`, and `TAKE` 1x1 publication mismatch likely tied to host/seam policy.
- Unacknowledged handoffs: `HO-FN-001`, `HO-FN-005`, `HO-FN-006`, `HO-FN-007`, `HO-FN-008`, `HO-FN-010`.

Reported doctrine drift/risk:
- Mostly aligned with Foundation doctrine.
- Local stale text remains in some beads/workset docs.
- OxFunc's Excel app/channel + workbook compatibility axes must not be confused with Foundation profile semantics in program-level claims.
- OxFunc local `function-phase-complete` must not be read as Foundation `green-validated`.

DnaTreeCalc implications:
- Consume OxFunc semantics through OxFml/OxCalc seams, not by local reinterpretation.
- Track `HO-FN-010` for 1x1 array publication/comparator policy.
- Treat exactness residuals as known risk inputs for any TreeCalc conformance corpus.

### OxFml

Reported state:
- Worktree has uncommitted W067 diagnostic-span changes and planning/doc updates.
- W067 beads/epic are closed in `br`, but repo state and tracker state remain temporarily out of sync until commit/push.
- `docs/upstream/NOTES_FOR_DNAONECALC.md` was cleared per user request in that repo.
- Last reported validation before note-clear: `cargo test -p oxfml_core` passed.

Reported blocker:
- `BLK-FML-004`: `FTC-0902` exact reduced `row(...)` witnesses collapse into existing built-in collision frontier.

Reported doctrine drift/risk:
- No intentional Foundation/AGENTS conflict observed.
- Main risk is closed beads with uncommitted changes.
- Integration remains partial until downstream consumers consume W067.

DnaTreeCalc implications:
- No formal DnaTreeCalc handoff currently exists.
- If DnaTreeCalc consumes OxFml editor/live diagnostics, request a concise handoff covering source-fidelity/editor-token invariant, worksheet cell-entry behavior, diagnostic fields (`code`, `primary_span`, `related_spans`, `worksheet_error_class`), and exact expected spans for representative formulas.
- Clarify canonical downstream naming: product name `DNA TreeCalc`, repo/folder token `DnaTreeCalc`.

## 6. Execution-doctrine rationalization starting observations

Current sibling `AGENTS.md` files are not uniform:
- Foundation had attribution/context/source-of-truth/change/output rules; now updated with coordinator and `wtd` guidance.
- `DnaOneCalc` is close to the slim bootstrap pattern and includes cross-repo read-only rules.
- `OxFml`, `OxCalc`, `OxReplay`, and `OxXlPlay` share a similar numbered pattern: context loading, source-of-truth precedence, anti-premature completion, continuation, blocker handling, attribution, change discipline.
- `OxFunc` has stronger local function-specific doctrine and anti-premature-completion language.
- `DnaVisiCalc`, `OxVba`, and `OxIde` have more bespoke execution guides.

Rationalization target:
1. Preserve repo-specific authority and doctrine.
2. Normalize shared clauses for public attribution, clean-room/evidence, source-of-truth precedence, cross-repo read-only boundary, `wtd` coordination, beads/`br` mutation rules where applicable, continuation/blocker handling, and completion-claim discipline.
3. Avoid retrofitting old repos into the full new-repo bootstrap shape unless explicitly chosen; instead distinguish mandatory common doctrine from repo-local conventions.

## 7. DnaTreeCalc preparation notes

Initial repo-prep assumptions:
- Product/host display name: `DNA TreeCalc`.
- Repo/folder token: `DnaTreeCalc`.
- Role: first serious multi-node proving host for OxCalc on tree substrate before grid complexity.
- Start from `OPERATIONS.md` Section `8.18` slim bootstrap, not a multi-file spec tree.
- Main engineering spec should likely be `docs/SCOPE_AND_SPEC.md`.
- The first spec should define tree-only substrate scope, host charter/conformance ladder, OxCalc consumption boundary, accepted/deferred feature families, artifact obligations, and handoff intake process.

Likely required handoffs before or during bootstrap:
- `OxCalc`: tree-substrate runtime/consumer interface, current W026-W031 state, TreeCalc-local residual baseline, host API expectations.
- `OxFml`: formula/bind/evaluator diagnostic and FEC/F3E seam expectations needed by a tree host.
- `OxFunc`: function/value semantics seam risks, exactness residuals, comparator/publication policy such as `HO-FN-010`.
- `OxReplay`: minimum replay bundle/adapter expectations for TreeCalc host evidence.
- `DnaOneCalc`: reusable host acceptance/verification patterns and lessons from single-node proving host.

## 8. Immediate proposed next actions

1. Complete Foundation AGENTS update for coordinator + `wtd` role.
2. Use this note as the seed inventory for a managed execution-doctrine rationalization pass.
3. Ask or inspect `OxCalc` specifically before drafting `DnaTreeCalc` bootstrap text, because OxCalc is the lane owner for tree-substrate coordinator policy.
4. Draft a common AGENTS clause set and per-repo delta matrix before editing sibling repos.
5. Prepare a `DnaTreeCalc` slim bootstrap packet aligned with `OPERATIONS.md` Section `8.18`.
