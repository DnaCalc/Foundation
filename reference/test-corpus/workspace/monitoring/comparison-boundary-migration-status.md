# Comparison boundary migration status

Date: 2026-04-19

## Goal
Move normalized comparison/equivalence ownership into `OxReplay` while keeping final host verdict policy in `DnaOneCalc`.

## Foundation local doctrine edits already made
- `CHARTER.md`
- `ARCHITECTURE_AND_REQUIREMENTS.md`
- `OPERATIONS.md`
- `REPLAY_APPLIANCE.md`

## Implementation status
- Cross-repo migration implementation: complete
- Post-implementation repo reviews: complete
- Narrow migration follow-ups: complete
- Live host smoke-check after follow-ups: complete
- Residual-risk bedding-down patches: complete
- Requested cleanup/polish sweep: complete

## Harvested repo outcomes

### OxXlPlay
#### Initial migration commit
- Commit: `d64f4bb` — `Publish explicit execution outcome evidence`
- Files changed:
  - `docs/spec/OXXLPLAY_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`
  - `docs/spec/OXXLPLAY_CLI_CONTRACT.md`
  - `docs/spec/OXXLPLAY_SCENARIO_REGISTER.md`
  - `scripts/invoke-excel-observation.ps1`
  - `tests/programmatic-formula-authoring-failure.ps1`
  - `tests/programmatic-formula-effective-display-text.ps1`

#### Follow-up commit
- Commit: `26a71de` — `Publish failure execution outcome replay artifacts`
- Files changed:
  - `docs/spec/OXXLPLAY_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md`
  - `docs/spec/OXXLPLAY_CLI_CONTRACT.md`
  - `scripts/invoke-excel-observation.ps1`
  - `tests/programmatic-formula-authoring-failure.ps1`
  - `tests/programmatic-formula-effective-display-text.ps1`
  - `tests/programmatic-formula-batch-authoring-failure.ps1`
- Reported tests:
  - `pwsh ./tests/programmatic-formula-effective-display-text.ps1`
  - `pwsh ./tests/programmatic-formula-authoring-failure.ps1`
  - `pwsh ./tests/programmatic-formula-batch-authoring-failure.ps1`
  - `pwsh ./tests/programmatic-formula-calc-error.ps1`
  - `pwsh ./tests/programmatic-formula-text-grouping-context.ps1`
- Outcome:
  - Renamed adapter-local readiness field from `comparison_ready` toward `replay_view_ready`
  - Publishes replay-facing failure artifacts for single-run and batch pre-capture failures:
    - `outcome.json`
    - `views/normalized-replay.json`
    - `views/execution-outcome.json`
    - `oxreplay-manifest.json`
    - `driver-run.json`
  - Keeps a single replay-facing family `execution_outcome`

#### Cleanup/polish commit
- Commit: `d2360de` — `Polish execution outcome payload shape`
- Files changed:
  - `scripts/invoke-excel-observation.ps1`
  - `tests/programmatic-formula-effective-display-text.ps1`
  - `tests/file-backed-workbook-open-failure.ps1`
- Reported tests:
  - `pwsh ./tests/programmatic-formula-effective-display-text.ps1`
  - `pwsh ./tests/programmatic-formula-authoring-failure.ps1`
  - `pwsh ./tests/programmatic-formula-batch-authoring-failure.ps1`
  - `pwsh ./tests/file-backed-workbook-open-failure.ps1`
- Outcome:
  - Accepted `execution_outcome` payloads now omit no-error fields instead of serializing empty-string `error_kind` / `error_message`
  - Added a non-authoring replay-facing failure regression for file-backed workbook-open failure
  - Confirmed that this non-authoring failure still emits `outcome.json`, `oxreplay-manifest.json`, `views/normalized-replay.json`, and `views/execution-outcome.json` using the single replay-facing family `execution_outcome`
- Residual risk:
  - Failure replay artifacts are still intentionally sparse and outcome-only when no real capture/provenance artifacts exist yet

### OxReplay
#### Initial migration commit
- Commit: `2449c3a` — `Own normalized comparison and outcome equivalence`

#### Follow-up commit
- Commit: `cfc79c3` — `Require explicit execution outcome payload shape`
- Files changed:
  - `docs/spec/DNA_RECALC_CLI_CONTRACT.md`
  - `docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md`
  - `docs/spec/OXREPLAY_IMPLEMENTATION_BASELINE.md`
  - `src/oxreplay-core/src/lib.rs`
  - `src/oxreplay-diff/src/lib.rs`
- Reported tests / commands:
  - `cargo fmt --all`
  - `cargo test -p oxreplay-core -p oxreplay-diff -p oxreplay-explain`
  - `cargo fmt --all --check`
  - `cargo clippy -p oxreplay-core -p oxreplay-diff -p oxreplay-explain --all-targets --all-features -- -D warnings`
- Outcome:
  - Typed outcome comparison now requires a single replay-facing family `execution_outcome`
  - The typed path now requires explicit payload fields such as `outcome_kind`, `outcome_stage`, and `class_id`
  - Legacy family-name repair / stage inference no longer participates in typed outcome equivalence

#### Bedding-down commit
- Commit: `c375b06` — `Flag legacy outcome families as seam drift`
- Files changed:
  - `src/oxreplay-diff/src/lib.rs`
- Reported tests / checks:
  - `cargo fmt --all`
  - `cargo test -p oxreplay-diff -p oxreplay-explain`
  - `cargo fmt --all --check`
  - `cargo clippy -p oxreplay-diff -p oxreplay-explain --all-targets --all-features -- -D warnings`
  - ad hoc CLI diff repro with legacy `authoring_outcome` versus normalized `execution_outcome`
- Outcome:
  - Legacy replay-facing outcome families like `authoring_outcome`, `bind_outcome`, and `publication_outcome` are now surfaced as explicit instrumentation seam-drift on the typed outcome path
  - The reproduced legacy-family diff now reports one explicit seam-drift mismatch instead of two generic `projection_coverage_gap` records

#### Cleanup/polish commit
- Commit: `ed1f69f` — `Clarify legacy outcome seam drift in explain`
- Files changed:
  - `src/oxreplay-explain/src/lib.rs`
- Reported tests / checks:
  - `cargo fmt --all`
  - `cargo test -p oxreplay-explain -p oxreplay-diff`
  - `cargo fmt --all --check`
  - `cargo clippy -p oxreplay-explain -p oxreplay-diff --all-targets --all-features -- -D warnings`
- Outcome:
  - `explain` now summarizes the same legacy typed-outcome seam drift explicitly instead of using the generic `typed outcome diverged on ...` wording
  - Diff/explain/user-facing reporting is now aligned for legacy outcome-family publication on the migrated typed-outcome boundary
- Residual risk:
  - Any retained legacy-family artifact still remains unsupported on the typed outcome path, but it now fails with explicit boundary labeling in both diff and explain output

### OxFml
#### Initial migration commit
- Commit: `3d6417f` — `Publish typed execution outcome surfaces`

#### Follow-up commit
- Commit: `f737867` — `Move managed execution outcome ownership into runtime`
- Files changed:
  - `crates/oxfml_core/src/consumer/runtime/mod.rs`
  - `crates/oxfml_core/src/consumer/replay/mod.rs`
  - `crates/oxfml_core/tests/runtime_consumer_facade_tests.rs`
  - `crates/oxfml_core/tests/replay_consumer_facade_tests.rs`
- Reported tests:
  - `cargo test -p oxfml_core runtime_session_facade_runs_managed_session_through_commit -- --nocapture`
  - `cargo test -p oxfml_core runtime_session_facade_reports_managed_abort_with_session_snapshot -- --nocapture`
  - `cargo test -p oxfml_core runtime_session_facade_executes_and_commits_managed_in_one_step -- --nocapture`
  - `cargo test -p oxfml_core replay_projection_service_projects_runtime_managed_session_results -- --nocapture`
  - `cargo test -p oxfml_core replay_projection_service_projects_runtime_managed_termination_results -- --nocapture`
- Outcome:
  - Managed commit / termination `execution_outcome_surface` is now runtime-owned canonically
  - Replay no longer synthesizes those managed outcome surfaces locally
  - Keeps the single replay-facing family `execution_outcome`

#### Bedding-down commit
- Commit: `4bf1811` — `Project managed session execution outcomes`
- Files changed:
  - `crates/oxfml_core/src/consumer/runtime/mod.rs`
  - `crates/oxfml_core/src/consumer/replay/mod.rs`
  - `crates/oxfml_core/tests/runtime_consumer_facade_tests.rs`
  - `crates/oxfml_core/tests/replay_consumer_facade_tests.rs`
- Reported tests / checks:
  - `cargo test -p oxfml_core runtime_session_facade_runs_managed_session_through_commit -- --nocapture`
  - `cargo test -p oxfml_core runtime_session_facade_reports_managed_abort_with_session_snapshot -- --nocapture`
  - `cargo test -p oxfml_core replay_projection_service_projects_runtime_managed_session_results -- --nocapture`
  - `cargo test -p oxfml_core replay_projection_service_projects_runtime_managed_termination_results -- --nocapture`
- Outcome:
  - `RuntimeManagedSessionSnapshot` now carries `execution_outcome_surface`
  - `runtime_managed_session` replay projection now forwards the runtime-owned managed session outcome surface instead of hardcoding `None`
  - Managed session snapshots now preserve canonical committed / terminated outcome classification while pre-commit executed snapshots remain `None`

#### Cleanup/polish commit
- Commit: `271d063` — `Deduplicate execution outcome construction`
- Files changed:
  - `crates/oxfml_core/src/seam/mod.rs`
  - `crates/oxfml_core/src/host/mod.rs`
  - `crates/oxfml_core/src/consumer/runtime/mod.rs`
- Reported tests:
  - `cargo test -p oxfml_core first_host_replay_capture_packet_surfaces_bind_boundary_execution_outcome -- --nocapture`
  - `cargo test -p oxfml_core runtime_session_facade_runs_managed_session_through_commit -- --nocapture`
  - `cargo test -p oxfml_core runtime_session_facade_reports_managed_abort_with_session_snapshot -- --nocapture`
  - `cargo test -p oxfml_core replay_projection_service_projects_runtime_managed_session_results -- --nocapture`
- Outcome:
  - Shared seam-local helpers now own the common `ExecutionOutcomeSurface` payload construction for `executed_result`, `commit_boundary_reject`, and `bind_boundary_reject`
  - Host and runtime now call those shared helpers instead of rebuilding the same payload strings locally
  - Managed commit/termination ownership and managed-session snapshot projection behavior stay unchanged
- Residual risk:
  - Host and runtime still choose outcome stage by local control flow, but the common payload shape is now seam-shared and the prior drift risk has been reduced materially

### DnaOneCalc
#### Initial migration commit
- Commit: `894f607` — `Delegate verification equivalence to OxReplay`

#### Follow-up commit
- Commit: `54b297d` — `Tighten verification blocked-surface trust policy`
- Files changed:
  - `docs/SCOPE_AND_SPEC.md`
  - `src/dnaonecalc-host/src/services/verification_bundle.rs`
- Reported targeted tests:
  - `cargo test -p dnaonecalc-host --lib verification_batch_writes_mismatched_case_as_workbench_artifact`
  - `cargo test -p dnaonecalc-host --lib verification_batch_treats_pre_execution_rejection_equivalence_as_matched`
  - `cargo test -p dnaonecalc-host --lib verification_batch_blocks_separator_sensitive_text_mismatch_shape_for_0288`
  - `cargo test -p dnaonecalc-host --lib verification_batch_blocks_on_replay_validate_bundle_failure`
  - `cargo test -p dnaonecalc-host --lib materialize_synthetic_compare_ready_replay_includes_scenario_identity`
- Follow-up outcome:
  - Host now treats failed `validate-bundle` as an untrusted compare-ready input and returns `Blocked`
  - Host trims the FTC-0288 path into comparison-eligibility / trust policy instead of host-local mismatch reasoning
  - Synthetic compare-ready replay for execution-outcome-only cases now carries `scenario_id`, `lane_id`, `events`, and `registry_refs` so OxReplay can parse it directly
  - Host now blocks on non-zero OxReplay diff / explain execution failures instead of pretending a semantic verdict
- Residual risk:
  - Host still contains temporary local normalization for some `execution_outcome` classification shapes
  - FTC-0288-class gating is now framed as eligibility/trust policy, but the host still performs the local eligibility mapping until richer upstream surfaces exist

## Live host smoke-check after follow-ups
The DnaOneCalc follow-up was exercised on live formulas after the code/doc changes landed.

### FTC-0448
- Formula:
  - `=LET(dict,{"x",LAMBDA(100);"y",LAMBDA(200)},GETlambda,LAMBDA(d,LAMBDA(key,LET(keys,TAKE(d,,1),objects,DROP(d,,1),obj,XLOOKUP(key,keys,objects,"not found"),obj()))),getter,GETlambda(dict),getter("y"))`
- Output root:
  - `target/triage/ftc-0448-post-followup-2`
- Observed outcome:
  - `Matched`
  - `replay_equivalent = true`
  - `value_match = null`
  - `display_match = null`
- Interpretation:
  - The new comparison layout now matches this case through typed `execution_outcome` equivalence over the shared pre-execution rejection class rather than ordinary worksheet-value comparison

### FTC-0288
- Formula:
  - `=TEXT(1234567.89,"#,##0.00")`
- Output root:
  - `target/triage/ftc-0288-post-followup-2`
- Observed outcome:
  - `Blocked`
  - `replay_equivalent = null`
  - `value_match = null`
  - `display_match = null`
- Block reason:
  - `Comparison blocked: comparison_value is not comparison-eligible for this non-XML programmatic case because Excel render locale/separator state is unpinned while OxFml marks locale-sensitive semantic text dependency under explicit locale context`
- Interpretation:
  - The new layout keeps this honestly blocked as a trust / eligibility issue, not a semantic mismatch verdict

### FTC-0401
- Formula:
  - `=RECEIVED(44927,45292,1000,0.05)`
- Output root:
  - `target/triage/ftc-0401-post-followup-2`
- Observed outcome:
  - `Matched`
  - `replay_equivalent = true`
  - `value_match = true`
  - `display_match = null`
- Interpretation:
  - Ordinary compare-ready value matching still works cleanly under the new comparison layout

## Residual-risk sweep after follow-ups
A final repo-local sweep was requested after the live smoke-check to determine whether any migration bedding-down work still remains.

### OxReplay
- Confirmed residual risk at sweep time:
  - Legacy outcome-family names like `authoring_outcome`, `bind_outcome`, and `publication_outcome` no longer participated in typed `execution_outcome` equivalence, but were still treated as ordinary comparison-view families by generic comparison logic.
- Concrete reproducible inconsistency at sweep time:
  - A local ad hoc `dna-recalc diff` between a replay carrying `authoring_outcome` and one carrying `execution_outcome` produced two generic `projection_coverage_gap` mismatches instead of explicitly identifying legacy typed-outcome publication.
- Sweep conclusion:
  - Closed by bedding-down commit `c375b06`, which now reports explicit seam-drift for legacy replay-facing outcome families.

### OxFml
- Confirmed residual risk at sweep time:
  - Managed commit / termination packets already owned canonical `execution_outcome_surface`, but `RuntimeManagedSessionSnapshot` did not carry that surface and replay projection for `runtime_managed_session` emitted `execution_outcome_surface: None`.
  - Host/runtime also still maintained separate local outcome-constructor helpers, leaving some drift risk.
- Concrete reproducible inconsistency at sweep time:
  - A managed commit/abort/expire result packet carried canonical outcome classification while a later session snapshot still could not carry or project the same surface, so consumers retaining only the snapshot could lose the canonical managed outcome.
- Sweep conclusion:
  - Closed by bedding-down commit `4bf1811`, which adds optional `execution_outcome_surface` to `RuntimeManagedSessionSnapshot` and projects it from the runtime-owned surface.

### OxXlPlay
- Confirmed residual risk:
  - Failure-only replay artifacts remain intentionally sparse and outcome-only when capture never started.
  - Accepted `execution_outcome` payloads currently serialize `error_kind` / `error_message` as empty strings rather than null/omitted values.
  - Dedicated regression coverage still centers on authoring rejection and batch pre-capture rejection.
- Concrete reproducible inconsistency:
  - The accepted execution outcome emitted by the effective-display-text regression still serializes `error_kind = ""` and `error_message = ""` rather than null/omitted values.
- Sweep conclusion:
  - No immediate migration patch is required in `OxXlPlay`; the remaining issues are payload-shape / fidelity polish rather than a boundary gap.

### DnaOneCalc
- Confirmed residual risk:
  - The host still contains temporary local normalization for some `execution_outcome` classification shapes and for the FTC-0288-style comparison-eligibility gate.
- Concrete reproducible inconsistency:
  - No functional migrated-path failure was reproduced in the focused rerun; targeted tests stayed green and the live exercised formulas still landed `FTC-0448 => Matched`, `FTC-0288 => Blocked`, and `FTC-0401 => Matched`.
- Sweep conclusion:
  - No immediate migration patch is required in `DnaOneCalc`; the remaining risk is temporary local mapping logic rather than a current correctness hole.

## Remaining non-blocking future improvements
1. Consider whether richer explicit comparison-contract metadata should eventually move from derived behavior into shared carried artifacts/types in OxReplay
2. Consider whether any future upstream surfaces can reduce the remaining DnaOneCalc temporary local eligibility / normalization mapping without regressing honest blocked and typed-rejection behavior
3. Failure-only replay artifacts in OxXlPlay remain intentionally sparse when no real capture/provenance artifacts exist yet

## Coordinator assessment
- The migration boundary change is implemented, the initial follow-up queue landed, the live host smoke-check validated the intended layout, the residual-risk bedding-down patches landed, and the requested cleanup/polish sweep is now complete.
- Additional cleanup/polish landed across the remaining active repos:
  - `OxReplay`: explicit legacy seam-drift wording now flows through `explain` as well as `diff`
  - `OxXlPlay`: accepted `execution_outcome` payloads now omit no-error fields and non-authoring failure replay-path coverage now includes workbook-open failure
  - `OxFml`: common execution outcome payload construction is now seam-shared across host/runtime callers
  - `DnaOneCalc`: no further safe deletion was found; remaining host-local logic is still doing required orchestration / trust-policy work
- The live host smoke-check remains valid:
  - typed rejection/frontier case `FTC-0448` matches via `execution_outcome`
  - separator/render-state case `FTC-0288` remains honestly blocked
  - ordinary case `FTC-0401` remains matched
- The requested cleanup/polish work is complete; what remains is future enhancement territory rather than required migration work.
