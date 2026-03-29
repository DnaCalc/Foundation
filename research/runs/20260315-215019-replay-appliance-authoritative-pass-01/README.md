# Replay Appliance Authoritative Pass 01

- Run ID: `20260315-215019-replay-appliance-authoritative-pass-01`
- Topic ID: `R-TOPIC-011`
- Status: `captured`
- Scope: derive a full cross-lane Replay appliance specification from the current authoritative `OxCalc`, `OxFml`, `OxFunc`, and `OxVba` specs, then package it as a Foundation research project with lane-specific implementation addenda, a first-class witness-distillation design, and rollout-ready governance clarifications.
- Exclusions: no doctrine promotion in this run; no edits to sibling lane repos; no attempt to replace lane-owned semantics with Foundation-owned mirrors.

## Goals
1. Inventory the current authoritative replay, trace, artifact, runner, evidence, and conformance surfaces in the four `Ox*` repos.
2. Define the Replay appliance motivation, charter, requirements, and architecture in a form consistent with the current lane ownership split.
3. Define a performance-sensitive design so replay capture can be woven into the system without collapsing hot-path behavior into logging.
4. Specify the shared replay implementation and host split under `OxReplay` and `DNA ReCalc`.
5. Produce repo-specific addenda for `OxCalc`, `OxFml`, `OxFunc`, and `OxVba`.
6. Specify witness distillation and counterexample reduction as a first-class Replay appliance capability.
7. Specify rollout governance for adapter capabilities, canonical registries, and witness lifecycle or quarantine policy.

## Primary Outputs
- `inputs/prompt.txt`
- `inputs/topic_context.md`
- `outputs/source_list.csv`
- `outputs/01_authoritative_lane_inventory.md`
- `outputs/02_replay_appliance_motivation_charter_requirements.md`
- `outputs/03_replay_appliance_architecture.md`
- `outputs/04_replay_appliance_performance_sensitive_design.md`
- `outputs/05_dna_recalc_tool_proposal.md`
- `outputs/06_oxcalc_addendum.md`
- `outputs/07_oxfml_addendum.md`
- `outputs/08_oxfunc_addendum.md`
- `outputs/09_oxvba_addendum.md`
- `outputs/10_witness_distillation_and_counterexample_reduction.md`
- `outputs/11_adapter_conformance_and_capability_matrix.md`
- `outputs/12_predicate_mismatch_and_status_registry.md`
- `outputs/13_witness_lifecycle_retention_and_quarantine_policy.md`
- `outputs/14_prompt_oxfml_replay_appliance_rollout.md`
- `outputs/15_prompt_oxcalc_replay_appliance_rollout.md`
- `outputs/16_prompt_oxfunc_replay_appliance_rollout.md`
- `outputs/17_prompt_oxvba_replay_appliance_rollout.md`
- `outputs/18_foundation_replay_appliance_promotion_plan.md`
- `outputs/19_oxreplay_repo_scope_and_model.md`

## Method
1. Read Foundation doctrine and research-workspace conventions.
2. Read the current authoritative spec indices and high-signal replay/conformance docs in `OxCalc`, `OxFml`, `OxFunc`, and `OxVba`.
3. Treat sibling lane repos as authoritative for lane-owned semantics and artifact contracts, per current ownership and the user request.
4. Synthesize a cross-lane replay specification that standardizes bundle, runner, diff, and explain contracts without reassigning lane ownership.
5. Extend the replay specification with a dedicated witness-distillation design that can minimize divergences into replay-closed reduced witnesses.
6. Add rollout-governance specs that define adapter capability claims, canonical registry vocabularies, and witness lifecycle or quarantine handling.
