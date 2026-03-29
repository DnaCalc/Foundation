# DnaOneCalc Repo Bootstrap Ingredients

## 1. Purpose
This note defines the intended ingredient set for bootstrapping the `DnaOneCalc` repo under the bead-based model.

It assumes:
1. `notes/DNA_ONECALC_SCOPE_AND_SPEC.md` remains the current engineering-spec authority in Foundation,
2. the repo bootstrap should install bead doctrine from the start,
3. repo execution should not be spread across one workset document per workset.

## 2. Bootstrap Objectives
The first bootstrap should produce a repo that is immediately honest about:
1. mission and host boundary,
2. upstream dependency constitution,
3. bead-based execution doctrine,
4. current blocker handling,
5. initial owned spec set,
6. living workset register,
7. initialized bead graph,
8. initial ready path.

## 3. Required Repo-Level Files
At repo root:
1. `README.md`
2. `AGENTS.md`
3. `.gitignore`

Under `docs/`:
1. `docs/CHARTER.md`,
2. `docs/OPERATIONS.md`,
3. one main engineering spec, preferably `docs/SCOPE_AND_SPEC.md`,
4. `docs/WORKSET_REGISTER.md`,
5. one bead-doctrine note, preferably `docs/BEADS.md`

Under `scripts/`:
1. `scripts/invoke-br-serialized.ps1`
2. `scripts/check-worksets.ps1` or equivalent minimal register-shape checker
3. optional later: `scripts/validate-bead-traceability.ps1`

Execution state:
1. `.beads/` initialized and tracked,
2. the first worksets, epics, and rollout beads created at bootstrap time.

Deliberate omissions from the bootstrap baseline:
1. no `CURRENT_BLOCKERS.md`,
2. no separate `docs/LOCAL_EXECUTION_DOCTRINE.md`,
3. no default `docs/spec/README.md`,
4. no default multi-file spec tree unless the spec actually grows beyond one main file,
5. no default multi-file beads-doc tree unless the single bead-doctrine note proves insufficient,
6. no separate bead-template file by default if the rollout template and example fit cleanly inside `docs/BEADS.md`.

## 4. Required Repo-Owned Spec Surfaces
The repo should not begin with only root governance docs.
It should also start with the minimum owned control set extracted from the OneCalc spec.

Recommended initial owned control set:
1. host-profile matrix,
2. upstream seam manifest and pin set,
3. artifact identity and envelope rules,
4. workset register contract,
5. minimal scenario and handoff field rules.

Recommended deferral rule:
1. richer control artifacts such as capability-center view-model detail, broader schema families, or larger policy notes should be created when the first chosen worksets actually need them,
2. the bootstrap should not fan out into many small policy documents by default.

## 4.2 Cross-Repo Read-Only Boundary Rule
`DnaOneCalc` should start with an explicit sibling-repo boundary doctrine.

The doctrine should be strong and always-on:
1. this repo may read sibling repos under the shared `DnaCalc` root,
2. this repo may not write to sibling repos,
3. shared filesystem visibility must not be treated as permission to repair or tidy neighboring repos,
4. any sibling-repo change required by OneCalc discovery must be routed through a handoff, prompt packet, or a separate repo-scoped execution run.

Recommended placement:
1. concise constitutional form in `docs/OPERATIONS.md`,
2. direct binding instruction in `AGENTS.md`.

Recommended `docs/OPERATIONS.md` text:
`Agents working from the DnaOneCalc repo may read files in sibling repositories under the shared DnaCalc root when needed for seam consumption, integration, evidence intake, or architectural alignment. Those sibling repositories are read-only from the perspective of this repo. Required changes outside DnaOneCalc must be routed through an explicit handoff, prompt, or separate repo-scoped run.`

Recommended `AGENTS.md` text:
`You may inspect sibling repositories under the shared DnaCalc root for context, upstream contracts, reference docs, and retained evidence. You must not modify, create, delete, rename, or reformat files outside this repo. Do not use shared filesystem access to make opportunistic fixes in another repo. If another repo needs changes, capture the need and route it through a handoff or a separate repo-local execution flow.`

## 4.1 `BEADS.md` Scope
`docs/BEADS.md` should be the whole local beads story in one file.

It should include:
1. the local execution rule that work proceeds through `workset -> epic -> bead`,
2. `br` mutation rules and `bv` triage rules,
3. the serialized mutation rule and `invoke-br-serialized.ps1`,
4. the bead quality contract,
5. the rollout pattern for a chosen workset,
6. one compact rollout template,
7. one compact example showing how a workset fans into epics and then into beads.

It should avoid:
1. splitting into multiple bead-method files unless the repo later becomes large enough to justify that,
2. copying a template directory tree just to hold a small amount of bead guidance.

## 5. All-Worksets Register Model
`DnaOneCalc` should start with one living `docs/WORKSET_REGISTER.md` rather than one workset document per workset.

Recommended register fields:
1. workset id,
2. title,
3. purpose or scope,
4. depends_on,
5. parent spec sections,
6. primary upstream repo dependencies,
7. closure condition,
8. initial epic lanes,
9. execution notes where needed.

Recommended naming:
1. use stable repo-local workset ids such as `WS-01`,
2. use bead ids from the bead tool rather than inventing a second ad hoc epic/bead numbering scheme in prose.

## 6. Initial DnaOneCalc Workset Set
The current `DnaOneCalc` repo now uses a single ordered `WS-##` workset sequence in `..\..\..\..\DnaOneCalc\docs\WORKSET_REGISTER.md`.

Interpretation rule:
1. do not describe those worksets as status-bearing execution objects,
2. use the register to define workset meaning and sequencing,
3. use the bead graph to define actual readiness and execution progress.

## 7. Epic Structure Rule
Each workset chosen for execution should be rolled out into epics rather than directly into an unstructured bead pile.

Recommended recurring epic pattern:
1. rollout epic,
2. first implementation lane,
3. second implementation or integration lane,
4. validation/evidence lane,
5. cleanup or upstream-pressure lane where needed.

This does not mean every workset must have exactly five epics.
It means the repo should begin with a believable execution structure instead of a flat bead dump.

## 8. First Bootstrap Ready Path
The initial sequencing should not try to activate the whole repo at once.

Recommended first sequence:
1. repo bootstrap and local execution doctrine,
2. seam manifest and host-profile basis,
3. host shell and formula-editing vertical slice,
4. first end-to-end H0 execution and replay baseline.

That gives the repo a real vertical slice before it widens into:
1. driven scenarios,
2. persistence,
3. comparison,
4. extensions.

## 9. Validation Tooling To Add At Bootstrap
Because `DnaOneCalc` should not use one-doc-per-workset as the default, the OxVba-style `validate-workset-rollout.ps1` pattern should be adapted rather than copied unchanged.

Recommended new validator behavior:
1. validate that the register exists and exposes a coherent workset sequence,
2. validate that workset ids are unique,
3. validate that required register fields exist,
4. optionally validate traceability from bead ids to canonical evidence families once the scenario corpus matures.

## 10. Immediate Design Cleanup Needed In The Foundation Note
The current Foundation OneCalc spec will need a follow-on cleanup before direct bootstrap templating:
1. collapse the current large `WS-*` register into the smaller repo-local workset set above,
2. remove wording that points toward one future document per workset,
3. keep the engineering-spec work hierarchy, but stop using it as the direct repo execution register,
4. make the new repo-local `docs/WORKSET_REGISTER.md` the workset-truth bridge between the spec and the bead graph,
5. reduce the implied bootstrap document count and default control-set fan-out.

## 11. Recommendation
Bootstrap `DnaOneCalc` with:
1. a strong engineering spec,
2. a small living workset register,
3. an initialized bead graph,
4. explicit rollout epics,
5. serialized bead mutation tooling,
6. no default one-doc-per-workset doctrine,
7. an explicit cross-repo read-only doctrine in both `AGENTS.md` and `docs/OPERATIONS.md`.
