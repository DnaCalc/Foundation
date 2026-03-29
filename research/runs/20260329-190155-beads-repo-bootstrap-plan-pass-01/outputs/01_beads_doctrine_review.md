# Beads Doctrine Review

## 1. Purpose
This note compares the recent beads-based execution doctrine in `OxVba` and `C:\Work\WinTermDriver` and evaluates what Foundation should adopt as the new default for repo creation and execution.

## 2. Sources Reviewed
Primary `OxVba` sources:
1. `..\OxVba\OPERATIONS.md`
2. `..\OxVba\docs\LOCAL_EXECUTION_DOCTRINE.md`
3. `..\OxVba\docs\methods\beads\BEADS_WORKING_METHOD.md`
4. `..\OxVba\docs\methods\beads\BEADS_UTILITIES_CHEAT_SHEET.md`
5. `..\OxVba\docs\methods\beads\BEAD_QUALITY_CONTRACT.md`
6. `..\OxVba\docs\templates\WORKSET_EPIC_BEAD_ROLLOUT_TEMPLATE.md`
7. `..\OxVba\scripts\invoke-br-serialized.ps1`
8. `..\OxVba\scripts\validate-bead-traceability.ps1`
9. `..\OxVba\scripts\validate-workset-rollout.ps1`

Primary `WinTermDriver` sources:
1. `C:\Work\WinTermDriver\AGENTS.md`
2. `C:\Work\WinTermDriver\docs\operations\BEADS_WORKING_METHOD.md`

Foundation-side comparison sources:
1. `README.md`
2. `OPERATIONS.md`
3. `notes\DNA_ONECALC_SCOPE_AND_SPEC.md`
4. previous repo-bootstrap synthesis runs under `synthesis/runs/20260309-184706-oxfml-oxcalc-bootstrap-prep-pass-01/` and `synthesis/runs/20260316-010158-oxreplay-bootstrap-prep-pass-01/`

## 3. What OxVba Establishes
`OxVba` is the stronger doctrine source for DnaCalc because it is both recent and explicit about how bead execution fits into a DnaCalc-style repo.

The important rules are:
1. worksets remain the high-level execution unit,
2. active work must execute through bead subtrees,
3. the normal hierarchy is `workset -> epic -> bead`,
4. every active workset must be rolled out into explicit epics,
5. each execution epic should start with a rollout bead when the path still needs to be created or refreshed,
6. beads are the unit of executable progress,
7. a bead only closes when both the stated outcome and the stated completion evidence exist,
8. newly discovered required work must become new beads before the current bead closes,
9. bead graph mutations must be serialized,
10. bead state and code state should travel together in git.

`OxVba` also adds two useful quality layers that are missing from older Foundation bootstrap material:
1. the `BEAD_QUALITY_CONTRACT`, which makes outcome/evidence/traceability mandatory,
2. rollout validation tooling, which checks that the declared workset and the actual bead graph still agree.

## 4. What WinTermDriver Adds
`WinTermDriver` adds useful operational patterns, but not all of them should become DnaCalc doctrine.

Useful additions:
1. clear `br` and `bv` command guidance in `AGENTS.md`,
2. explicit distinction between `br` as mutation tool and `bv` as graph-aware triage tool,
3. `bv --robot-*` discipline to avoid interactive TUI misuse by agents,
4. a practical runner pattern for sequential bead execution.

What should not become Foundation-wide doctrine by default:
1. auto-runner assumptions,
2. session-end commit/push rituals phrased as universal rules,
3. Claude-specific runner coupling,
4. a repo architecture that assumes bead execution is primarily automation-driven rather than operator-driven.

The right reading is:
1. use WinTermDriver as optional tooling inspiration,
2. use OxVba as the DnaCalc constitutional model.

## 5. Current Mismatch In Foundation
Foundation's existing bootstrap material still assumes an older pattern:
1. repo bootstrap plans create repo docs and then open worksets,
2. `DNA_ONECALC_SCOPE_AND_SPEC.md` currently includes both a detailed `W*` hierarchy and a large `WS-*` workset register,
3. that OneCalc note still assumes repo-local workset documents can be created later,
4. the previous bootstrap runs do not install bead doctrine, serialized `br` tooling, or a living all-worksets register as first-class repo ingredients.

This is no longer the best model.

The current mismatch is not that worksets exist.
The mismatch is that worksets are still being treated as the primary execution-tracking surface instead of as umbrella planning slices over a bead graph.

## 6. Recommended Doctrine Choice
Foundation should adopt the following as the default repo-execution doctrine for DnaCalc repos:
1. engineering spec remains the broad design truth,
2. each repo keeps one living all-worksets register,
3. active workset execution must roll into `workset -> epic -> bead`,
4. the bead graph under `.beads/` becomes the authoritative execution tracker,
5. `br` is the required mutation tool,
6. `bv` is the supported graph-analysis and triage tool,
7. bead mutations must be serialized,
8. one-doc-per-workset is no longer the default approach.

## 7. Consequences For DnaOneCalc
For `DnaOneCalc`, this means:
1. the existing scope/spec remains the main engineering-spec authority,
2. the repo should not start with twenty-one separate workset documents,
3. the repo should start with one all-worksets register derived from the current OneCalc scope,
4. the actual executable decomposition should live in the bead graph,
5. epics and rollout beads should be used to express the real path through the work rather than multiplying narrative workset prose.

## 8. Concrete Recommendation
Adopt the `OxVba` bead doctrine as the DnaCalc default.

Carry over from `WinTermDriver`:
1. brief `br` guidance,
2. brief `bv` guidance,
3. robot-only `bv` note for agents.

Do not carry over from `WinTermDriver` as doctrine:
1. the runner as a mandatory execution model,
2. tool-specific automation assumptions,
3. commit/push-at-session-end language as constitutional process.
