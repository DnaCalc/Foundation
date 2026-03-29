# Foundation Repo Creation Guidance Changes

## 1. Purpose
This note defines the changes Foundation guidance should make before the next repo bootstrap, so that new DnaCalc repos start with the bead-based execution model instead of the older workset-document model.

## 2. Core Model To Adopt
The intended default model for new DnaCalc repos should be:
1. one engineering spec or equivalent scope-and-spec authority,
2. one living all-worksets register,
3. one `.beads/` graph for execution truth,
4. execution through `workset -> epic -> bead`,
5. serialized bead mutation through `br`,
6. optional graph-aware triage through `bv`.

This replaces the older pattern of:
1. large narrative workset sets,
2. one document per workset,
3. execution tracked mainly in prose.

## 3. Recommended Bootstrap Ingredients For Every New Repo
Every new repo bootstrap should include the following from the start.

Root docs:
1. `README.md`
2. `AGENTS.md`

Planning and spec surfaces:
1. `docs/CHARTER.md`,
2. `docs/OPERATIONS.md`,
3. one engineering spec or scope-and-spec authority,
4. one living `WORKSET_REGISTER.md` as the all-worksets document,
5. any minimal repo-specific control artifacts that the engineering spec truly requires.

Bead doctrine and tooling:
1. `.beads/` initialized and tracked in git,
2. one bead-doctrine note, preferably `docs/BEADS.md`,
3. `scripts/invoke-br-serialized.ps1`,
4. a small register-shape checker,
5. optional traceability validator when the repo uses canonical matrices or evidence tables.

Reduction rule:
1. do not create a separate `CURRENT_BLOCKERS.md` by default,
2. do not split `OPERATIONS.md` and `LOCAL_EXECUTION_DOCTRINE.md` unless the repo genuinely grows enough process complexity to justify it,
3. do not create a default `docs/spec/README.md` plus multi-file spec tree for a repo that still has one main engineering spec,
4. do not copy a multi-file beads-doc tree into a new repo unless the single bead-doctrine note proves insufficient.

`BEADS.md` should normally include:
1. the local bead working method,
2. `br` and `bv` usage guidance,
3. the serialized mutation rule,
4. the bead quality bar,
5. the workset to epic to bead rollout pattern,
6. one compact rollout template,
7. one compact worked example where useful.

## 4. Workset Register Shape
The all-worksets register should replace the idea of one document per workset by default.

The register should minimally carry:
1. workset id,
2. title,
3. purpose or scope,
4. depends_on,
5. parent spec sections,
6. primary upstream dependencies,
7. closure condition,
8. initial epic lanes,
9. execution notes where needed.

Default rule:
1. the workset register is mandatory,
2. it owns workset truth only: ordered workset set, meaning, dependency shape, and default sequencing,
3. it must not become a second execution-status system,
4. a separate workset document is optional and should only be added when the workset needs substantial narrative treatment that does not fit the register.

Blocker rule:
1. blocker truth should normally live in the bead graph rather than in the workset register or in a second dedicated blockers document,
2. a standalone blockers file should be exceptional rather than part of the bootstrap baseline.

## 5. Epic And Bead Breakdown Rule
The bead graph should carry the actual execution breakdown.

Required execution rules:
1. each workset chosen for execution should have explicit epic children,
2. some epics and child beads may be created directly during initial rollout,
3. some epics should begin with a rollout bead when the child path still needs to be created or refreshed,
4. the ready set, not narrative momentum, chooses the next bead by default,
5. bead closure requires explicit outcome plus evidence,
6. uncovered required work must be added to the graph before a closing claim.

## 6. `br` And `bv` Guidance
Foundation guidance should make the tool split explicit.

Recommended wording:
1. `br` is the authoritative mutation tool for the bead graph,
2. `bv` is the supported graph-aware triage and analysis tool,
3. agents must use only non-interactive robot-style inspection forms,
4. direct manual editing of `.beads/` state is prohibited,
5. parallel `br` mutations are prohibited.

## 6.1 Cross-Repo Read And Write Boundary Doctrine
Every new DnaCalc repo should include an explicit sibling-repo boundary rule.

Recommended constitutional rule:
1. agents working in one repo may read sibling repos under the shared `DnaCalc` root when that is needed for upstream seam consumption, reference checks, replay evidence intake, or cross-repo design alignment,
2. agents may not write, patch, generate, or reformat files in sibling repos while operating from the current repo,
3. any required sibling-repo change must be handled through a handoff, prompt packet, or a separate repo-local run in that sibling repo,
4. cross-repo read access is a permission for understanding, not a permission for opportunistic cleanup or silent fixes.

Recommended placement:
1. put the concise constitutional statement in `docs/OPERATIONS.md`,
2. put the stricter binding execution rule in `AGENTS.md`.

Recommended `OPERATIONS.md` wording:
`Agents operating in this repo may read files from sibling repositories under the shared DnaCalc root when needed for integration, seam review, or evidence intake. They must treat those sibling repositories as read-only from the perspective of this repo. Any write to another repo requires switching into that repo as the active working context or using an explicit handoff/prompt flow.`

Recommended `AGENTS.md` wording:
`You may inspect sibling repositories under the shared DnaCalc root for context, upstream contracts, evidence, and seam alignment. You must not modify, create, delete, or reformat files outside the current repo. Do not treat shared filesystem access as permission to fix neighboring repos opportunistically. If another repo needs changes, stop and produce a handoff, prompt, or separate repo-scoped execution plan instead.`

## 7. What Foundation Should Change
The following Foundation surfaces should be updated in a later promotion pass.

Recommended source-of-truth changes:
1. `OPERATIONS.md`
   - add the repo-bootstrap and execution doctrine for beads,
   - make the living all-worksets register plus bead graph the default new-repo pattern,
   - remove the assumption that a separate local execution doctrine file or blockers file is part of the normal bootstrap baseline,
   - update the expected new-repo doc layout so `CHARTER.md` and `OPERATIONS.md` live under `docs/` rather than at repo root,
   - make the workset-truth vs execution-truth split explicit.
2. `README.md`
   - add a concise pointer to the beads-based repo-bootstrap doctrine.
3. `AGENTS.md`
   - add a short repo-bootstrap execution note, especially the `br`/`bv` and serialization rules for new repos,
   - add the strict cross-repo read-only doctrine for sibling repos.
4. a new specific doctrine note, preferably one of:
   - `REPO_CREATION_DOCTRINE.md`
   - or `BEADS_REPO_BOOTSTRAP_DOCTRINE.md`

That specific doctrine note should hold:
1. the bootstrap ingredient set,
2. the workset-register contract,
3. the `.beads/` contract,
4. the rollout rules,
5. the serialized mutation rule,
6. the template and validation expectations.

## 8. Recommended Deprecations
Foundation should stop treating the following as default new-repo practice:
1. one document per workset,
2. register-owned execution-state tracking,
3. narrative workset summaries as the primary operational truth,
4. repo bootstrap templates that omit bead doctrine and `.beads/` state,
5. a default `CURRENT_BLOCKERS.md` file for every new repo,
6. a default split between `OPERATIONS.md` and `LOCAL_EXECUTION_DOCTRINE.md`,
7. a default `docs/spec/README.md` plus spec-directory fan-out before the repo actually has multiple spec files to organize.

## 9. Immediate OneCalc-Specific Consequence
`DNA_ONECALC_SCOPE_AND_SPEC.md` should later be simplified to align with this doctrine:
1. keep the engineering-spec work structure that explains the whole scope,
2. reduce repo-local execution tracking to a smaller living workset register,
3. let epics and beads carry the execution state and detailed execution path,
4. remove any wording that suggests the default future shape is one document per workset.
