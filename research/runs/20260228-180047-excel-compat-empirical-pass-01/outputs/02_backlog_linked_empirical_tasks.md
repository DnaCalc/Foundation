# Backlog-Linked Empirical Tasks

## Intent
This catalog decomposes `ECS-BL-*` follow-up backlog items into executable empirical tasks.
These tasks start the systematic follow-up work requested after building the known-known task list.

Primary backlog reference:
- `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/17_follow_up_execution_backlog.md`

Status defaults to `planned`.

| Task ID | Backlog link | Empirical objective | Method outline | Expected artifact(s) |
|---|---|---|---|---|
| ECS-EB-001 | ECS-BL-01 | Define canonical scenario manifest schema for empirical probes | Draft and validate JSON schema over representative scenarios | empirical_scenario_schema.json |
| ECS-EB-002 | ECS-BL-01 | Implement runner contract for Desktop Excel automation lane | Build command contract and probe runner wrapper | desktop_runner_contract.md |
| ECS-EB-003 | ECS-BL-01 | Define normalized capture schema for values/errors/spills/formats | Map raw outputs to normalized fields | normalized_capture_schema.json |
| ECS-EB-004 | ECS-BL-01 | Create evidence bundle completeness validator | Validate manifest/raw/normalized/rerun presence | evidence_bundle_validator_report.md |
| ECS-EB-005 | ECS-BL-02 | Generate per-function scenario templates from catalog metadata | Build template generator keyed by function family | function_template_plan.csv |
| ECS-EB-006 | ECS-BL-02 | Create first-wave edge-case probe set for all tier-5 and tier-4 functions | Use function-tier index and family templates | function_edge_wave1_manifest.csv |
| ECS-EB-007 | ECS-BL-02 | Define full per-function edge-case matrix schema | Include coercion/error/array/version/platform dimensions | function_edge_matrix_schema.csv |
| ECS-EB-008 | ECS-BL-02 | Add unresolved tagging workflow for unknown outcomes | Auto-mark low-confidence and untestable rows | function_unresolved_queue.csv |
| ECS-EB-009 | ECS-BL-02 | Link matrix rows to source and empirical evidence IDs | Enforce row-level traceability | function_edge_evidence_index.csv |
| ECS-EB-010 | ECS-BL-03 | Define recalc event matrix (edit/structural/full recalc/reopen) | Build recalc trigger scenario fixture set | recalc_event_matrix.csv |
| ECS-EB-011 | ECS-BL-03 | Run volatility probes for canonical volatile and non-volatile controls | Compare value changes by trigger type | volatility_probe_results_wave1.csv |
| ECS-EB-012 | ECS-BL-03 | Probe argument-conditional volatility candidates | Vary arguments and external state for candidate functions | volatility_context_probe.csv |
| ECS-EB-013 | ECS-BL-03 | Build reason-code mapping from observed trigger behavior | Normalize trigger classes and rationale | volatility_reason_codes.md |
| ECS-EB-014 | ECS-BL-04 | Probe `INDIRECT`/`OFFSET` dependency effects under structural edits | Script row/column insert/delete and capture dependent recalcs | indirect_offset_structural_probe.csv |
| ECS-EB-015 | ECS-BL-04 | Probe RTD lifecycle (open/close/calc-mode/reconnect) | Controlled RTD server availability and workbook state transitions | rtd_lifecycle_probe.csv |
| ECS-EB-016 | ECS-BL-04 | Probe `NOW`/`TODAY` under date-system toggles and copy/paste | Toggle 1900/1904 and perform cross-workbook paste operations | now_today_date_system_probe.csv |
| ECS-EB-017 | ECS-BL-04 | Capture tier-5 platform caveat outcomes | Execute selected tier-5 probes across available platforms | tier5_platform_caveat_report.md |
| ECS-EB-018 | ECS-BL-05 | Deep mixed-type spill/coercion probes for dynamic-array family | Generate mixed-type arrays and evaluate family outcomes | dynamic_array_mixed_type_probe.csv |
| ECS-EB-019 | ECS-BL-05 | Deep lambda/helper edge probes (scope, optional args, nested arrays) | Structured lambda edge fixture set | lambda_helper_edge_probe.csv |
| ECS-EB-020 | ECS-BL-05 | CUBE worksheet-contract probe set (context-aware) | Minimal cube-context workbook and capability checks | cube_contract_probe.csv |
| ECS-EB-021 | ECS-BL-05 | External-data deterministic replay probes | Capture and replay baseline external-data scenarios | external_data_replay_probe.csv |
| ECS-EB-022 | ECS-BL-05 | Tier-3 expansion planning based on observed mismatch density | Rank tier-3 candidates for deeper probes | tier3_expansion_queue.csv |
| ECS-EB-023 | ECS-BL-06 | Build locale matrix harness for coercion probes | Parameterize locale and parser-sensitive fixtures | locale_coercion_harness_plan.md |
| ECS-EB-024 | ECS-BL-06 | Exhaustive operator coercion probe pack | Systematically test operator/type combinations | operator_coercion_truth_table.csv |
| ECS-EB-025 | ECS-BL-06 | Function-family coercion probe pack | Coercion outcomes by family/context | function_family_coercion_probe.csv |
| ECS-EB-026 | ECS-BL-06 | Compatibility-version nested precedence coercion probes | Run nested formulas under variant compatibility settings | compatibility_coercion_probe.csv |
| ECS-EB-027 | ECS-BL-06 | Automate confidence scoring for coercion rows | Score by source support plus empirical repetition | coercion_confidence_scores.csv |
| ECS-EB-028 | ECS-BL-07 | Parse-acceptance corpus for modern syntax variants | Accepted/rejected variant sweep across constructs | formula_parse_acceptance_corpus.csv |
| ECS-EB-029 | ECS-BL-07 | Formula normalization capture for accepted constructs | Compare entered formula and normalized stored formula | formula_normalization_capture.csv |
| ECS-EB-030 | ECS-BL-07 | Ambiguity discriminator probes for grammar edge points | Probe minimal pairs for ambiguous syntax | grammar_ambiguity_probe.csv |
| ECS-EB-031 | ECS-BL-08 | Conditional-format overlap workbook generator | Auto-generate overlap and priority test fixtures | cf_overlap_fixture_manifest.csv |
| ECS-EB-032 | ECS-BL-08 | Stop-if-true and priority transition probe pack | Vary order and stop flags with deterministic inputs | cf_stopiftrue_probe.csv |
| ECS-EB-033 | ECS-BL-08 | CF interactions with tables and spills probe pack | Combine CF rules with table growth and spill ranges | cf_table_spill_interaction_probe.csv |
| ECS-EB-034 | ECS-BL-09 | Structured-ref plus spill interaction matrix probes | Mutate structured refs and spill producers/consumers | table_spill_interaction_matrix.csv |
| ECS-EB-035 | ECS-BL-09 | Table growth/shrink with coercion/format interaction probes | Resize tables and track value/format changes | table_resize_coercion_format_probe.csv |
| ECS-EB-036 | ECS-BL-09 | Table auto-behavior platform divergence probes | Compare auto-expand/auto-fill behaviors by platform | table_platform_divergence_probe.csv |
| ECS-EB-037 | ECS-BL-10 | Availability crawler plus probe merger workflow | Merge applies-to metadata with probe outcomes | function_availability_matrix.csv |
| ECS-EB-038 | ECS-BL-10 | Channel/build metadata capture format | Persist environment and build identity with probes | platform_build_metadata_schema.json |
| ECS-EB-039 | ECS-BL-10 | Platform parity regression tracker | Dated diff tracker for parity changes | platform_parity_regression_log.csv |
| ECS-EB-040 | ECS-BL-11 | Weak-evidence function reason-code empirical verifier | Targeted probes for uncertain classification reasons | reason_code_verification_probe.csv |
| ECS-EB-041 | ECS-BL-11 | Sync classification table with empirical evidence IDs | Attach evidence IDs to classification records | classification_evidence_sync.csv |

## Newly identified empirical tasks from this decomposition pass
These tasks were not explicit in Pass 17 wording but are needed for practical execution quality.

| Task ID | Derived from | Empirical objective | Expected artifact(s) |
|---|---|---|---|
| ECS-EB-042 | ECS-BL-01, ECS-BL-08 | Capture rendered-display snapshots (value vs display text) alongside raw value for formatting-sensitive probes | display_capture_schema.json |
| ECS-EB-043 | ECS-BL-03, ECS-BL-04 | Capture calc-mode transition state before/after each probe sequence to avoid ambiguous volatility conclusions | calc_mode_transition_log.csv |
| ECS-EB-044 | ECS-BL-02, ECS-BL-06 | Add workbook reopen determinism checks for selected coercion and function edge probes | reopen_determinism_probe.csv |
| ECS-EB-045 | ECS-BL-02, ECS-BL-04 | Define minimization routine for empirical divergence cases | empirical_divergence_minimization.md |
| ECS-EB-046 | ECS-BL-10 | Define platform capability self-report schema to annotate untestable scenarios explicitly | platform_capability_profile.json |

## Immediate start set
Start execution in this order for maximum downstream unlock:
1. `ECS-EB-001` through `ECS-EB-004` (harness contract baseline)
2. `ECS-EB-010`, `ECS-EB-011`, `ECS-EB-014`, `ECS-EB-023` (high-signal pilot probes)
3. `ECS-EB-037`, `ECS-EB-038`, `ECS-EB-046` (platform/version framing and testability metadata)

## Started in this pass
- `ECS-EB-001`: initial schema published at `outputs/artifacts/empirical_scenario_schema.v0.json`
- `ECS-EB-002`: runner contract v0 published at `outputs/artifacts/desktop_runner_contract_v0.md`
- `ECS-EB-003`: normalized capture schema v0 published at `outputs/artifacts/normalized_capture_schema.v0.json`
- `ECS-EB-004`: validator rules v0 published at `outputs/artifacts/evidence_bundle_validator_v0.md`
- `ECS-EB-010`: pilot recalc matrix and scenarios published under `outputs/pilot_wave1/`
- `ECS-EB-011`: pilot volatility results template and scenarios published under `outputs/pilot_wave1/`
- `ECS-EB-014`: pilot structural probe matrix and scenarios published under `outputs/pilot_wave1/`
- `ECS-EB-023`: locale harness plan, locale seed matrix, and scenarios published under `outputs/pilot_wave1/`
- Wave execution guidance added in `outputs/pilot_wave1/RUN_INSTRUCTIONS.md` and `outputs/pilot_wave1/run_wave1.ps1` (launcher for .NET runner)
- `ECS-EB-037`: seeded availability matrix published at `outputs/platform_availability/function_availability_matrix.csv`
- `ECS-EB-038`: build metadata schema v0 published at `outputs/platform_availability/platform_build_metadata_schema.v0.json`
- `ECS-EB-046`: capability profile template published at `outputs/platform_availability/platform_capability_profile.template.json`
