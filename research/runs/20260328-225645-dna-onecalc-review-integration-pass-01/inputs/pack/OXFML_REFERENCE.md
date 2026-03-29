# OxFml Reference

This document consolidates the current DNA OneCalc-relevant reference set from `OxFml`.

Repo role: Formula language, evaluator semantics, host/runtime packets, FEC/F3E seam meaning, formatting-sensitive evaluator behavior, and editor-grade language services.

Included source documents:
- `OxFml/CHARTER.md`
- `OxFml/CURRENT_BLOCKERS.md`
- `OxFml/docs/IN_PROGRESS_FEATURE_WORKLIST.md`
- `OxFml/docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`
- `OxFml/docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
- `OxFml/docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
- `OxFml/docs/spec/formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`
- `OxFml/docs/spec/formula-language/MS_OE376_FORMULA_AND_FORMATTING_REVIEW.md`
- `OxFml/docs/spec/formula-language/OXFML_CF_DV_RESTRICTED_SUBLANGUAGES.md`
- `OxFml/docs/spec/formula-language/OXFML_EDITOR_LANGUAGE_SERVICE_AND_HOST_INTEGRATION_PLAN.md`
- `OxFml/docs/spec/formula-language/OXFML_OXFUNC_LIBRARY_CONTEXT_RUNTIME_INTERFACE.md`
- `OxFml/docs/spec/formula-language/OXFML_REGISTERED_EXTERNAL_PROVIDER_AND_CALL_REGISTER_ID_BOUNDARY.md`
- `OxFml/docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
- `OxFml/docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
- `OxFml/docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
- `OxFml/docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
- `OxFml/docs/spec/OXFML_EMPIRICAL_PACK_PLANNING.md`
- `OxFml/docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`
- `OxFml/docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`
- `OxFml/docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
- `OxFml/docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
- `OxFml/docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
- `OxFml/docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
- `OxFml/docs/spec/OXFML_SYSTEM_DESIGN.md`
- `OxFml/docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
- `OxFml/docs/spec/README.md`
- `OxFml/docs/worksets/W048_editor_language_service_and_immutable_formula_host_plan.md`

The sources are reproduced below in full so the pack remains self-contained even after flattening.

## Source: `OxFml/CHARTER.md`

# CHARTER.md — OxFml Charter

## 1. Mission
OxFml defines and validates the formula-language and evaluator seam for DNA Calc.

It is the permanent specification owner for the FEC/F3E contract and provides stable evaluator-side interfaces consumed by OxCalc coordinators.

## 2. Precedence
When guidance conflicts, precedence is:
1. `../Foundation/CHARTER.md`
2. `../Foundation/ARCHITECTURE_AND_REQUIREMENTS.md`
3. `../Foundation/OPERATIONS.md`
4. this `CHARTER.md`
5. this repo `OPERATIONS.md`

## 3. Scope
In scope:
1. Formula grammar, parse, bind, and normalized reference representation.
2. Evaluator execution semantics for single-node calculation sessions.
3. FEC/F3E protocol ownership for evaluator-side clauses.
4. Commit output contract for `value_delta`, `shape_delta`, `topology_delta`, and optional display/format deltas.
5. Trace schema and reject-detail taxonomy for deterministic replay.
6. Formula-semantic formatting behavior crossing the seam.

Out of scope:
1. Multi-node scheduling policy and global recalc policy ownership (OxCalc).
2. Function kernel semantics (OxFunc).
3. UI/rendering-only display behavior.

## 4. FEC/F3E Ownership Rule
1. OxFml is the canonical owner of the shared FEC/F3E protocol specification files.
2. OxCalc co-defines coordinator-facing clauses through explicit handoff packets.
3. Foundation keeps a read-only mirror for cross-program conformance governance.

## 5. Clean-room Rule
Allowed sources:
1. public specifications and documentation,
2. published research,
3. reproducible black-box observations.

Disallowed sources:
1. proprietary or restricted sources,
2. reverse engineering of internals,
3. decompilation/disassembly of Excel internals.

## 6. Definition of Done (Lane)
A spec/policy change is done only when:
1. seam contract text is updated,
2. conformance matrix rows are updated,
3. replay/trace impact is documented,
4. cross-repo handoff impact is recorded when coordinator-facing clauses change.

## Source: `OxFml/CURRENT_BLOCKERS.md`

# CURRENT_BLOCKERS.md — OxFml

Status: no active blockers.

Last reviewed: 2026-03-23 after `W040` higher-order callable validation.

---

## Active Blockers

(none)

---

## Resolved Blockers

### BLK-FML-002: OxFunc `call_register_id_family` derive regression blocked 2026-03-22 validation

- **Status**: resolved
- **Impact**: blocked `W042` validation because `cargo test -p oxfml_core` could not compile the sibling `oxfunc_core` dependency
- **Current state**: OxFunc carried `Eq` derives on types containing `f64` in `../OxFunc/crates/oxfunc_core/src/functions/call_register_id_family.rs`; the minimal sibling unblock was to drop those `Eq` derives and rerun OxFml validation
- **Exact unblock steps**: completed; patched the sibling derive regression, reran focused OxFml tests, and validation resumed
- **Recommendation**: workaround
- **Opened**: 2026-03-22
- **Resolved**: 2026-03-22

### BLK-FML-001: OxFunc sibling compile failure blocks OxFml validation

- **Status**: resolved
- **Impact**: blocked `W004`, `W009`, and `W010` gate closure because required `cargo test -p oxfml_core` validation could not complete
- **Current state**: subsequent rerun of `cargo test -p oxfml_core` completed successfully after the sibling compile surface recovered
- **Exact unblock steps**: completed; rerun validation succeeded
- **Recommendation**: workaround
- **Opened**: 2026-03-16
- **Resolved**: 2026-03-16

---

## Entry Template

```
### BLK-FML-NNN: <title>

- **Status**: active | resolved | closed
- **Impact**: <which worksets/features are blocked>
- **Current state**: <what has been attempted, what failed>
- **Exact unblock steps**: <specific actions needed>
- **Recommendation**: wait | escalate | workaround
- **Opened**: YYYY-MM-DD
- **Resolved**: YYYY-MM-DD (if applicable)
```

## Source: `OxFml/docs/IN_PROGRESS_FEATURE_WORKLIST.md`

# IN_PROGRESS_FEATURE_WORKLIST.md — OxFml

Canonical repo-level register of feature areas that are in-progress under workset completion doctrine.

Status: active.
Last updated: 2026-03-27.

## Status Vocabulary

- `in-progress`: partial implementation exists, parity/completeness not yet achieved.
- `blocked`: in-progress with active blocker (see CURRENT_BLOCKERS.md).
- `planned`: explicitly accepted into scope, no shipped work yet.

## Active Feature Register

### IP-01: Formula Grammar, Parse, and Bind

- **Status**: in-progress
- **Current floor**: architectural baseline plus exercised implementation slices for formula source records, explicit formula-channel identity, tokenization, green syntax, red projections, a widened expression parser subset including additional qualified-name handling, a first local `WorksheetR1C1` floor with absolute/relative cell translation and qualified area normalization, normalized reference ADTs, bind fixture scaffolding with richer assertions, first host-owned table packet types (`table_catalog`, `enclosing_table_ref`, `caller_table_region`) and a widened local structured-reference floor covering `Table1[Amount]`, `[@Amount]`, section-only selectors such as `Table1[#Headers]` and `Table1[#Totals]`, first multi-column section-qualified selectors such as `Table1[[#All],[Amount]:[Tax]]` and `Table1[[#Data],[Amount]:[Tax]]`, defined-name collision disambiguation, illegal `#This Row` combination rejection, and first host-path evaluation for explicit-column, current-row-sensitive, section-only, and multi-column section-qualified lanes, host-path incremental parse/red/bind reuse, semantic-plan compilation with helper-environment profiling, stage-aware availability summaries, external library-context snapshot refs, narrower per-surface library-context fields (`surface_stable_id`, `name_resolution_table_ref`, `semantic_trait_profile_ref`, `gating_profile_ref`) plus first-pass seam-facing export fields (`metadata_status`, `special_interface_kind`, `admission_interface_kind`, `preparation_owner`, `runtime_boundary_kind`, `arity_shape_note`, `interface_contract_ref`), a newly explicit preferred runtime `LibraryContextProvider` / immutable `LibraryContextSnapshot` interface model so implementation use does not depend on build-time catalog-file ingestion, first local `TypedContextQueryBundle` / `TypedContextQueryBundleSpec` packet types with grouped `INFO` / `CELL` / `RTD` host-run evidence, dedicated deterministic classification for accepted-unresolved-name, semantic-plan gated, runtime capability denied, and post-dispatch provider-unavailable lanes plus a checked Lean artifact for that stage split, direct local consumption of the downstream `W044` export for selected ordinary, seam-heavy, and higher-order helper rows, prepared-call/result lowering with blankness, caller-context provenance, typed callable carriers plus callable-profile detail, helper/scalarization prepared-call traces, a first `ReturnedValueSurface` packet propagated through evaluation, host, candidate, and commit carriers for ordinary-value lanes plus live typed host/provider outcome lanes for `RTD` value and capability-denied outcomes, `INFO` unsupported-query outcomes, and `CELL` provider-failure outcomes, first local restricted-carrier validation for conditional-formatting and data-validation host-managed formula lanes, local evaluation semantics for `_xlfn.SINGLE`, `LET`, callable `LAMBDA`, exact free-helper lexical capture, adopted defined-name callable transport with distinct `DefinedNameCallable` origin preservation, `ROW`, `COLUMN`, `INDIRECT`, `OFFSET`, `IFERROR`, and `RTD`, first local end-to-end higher-order callable execution for `MAP`, `REDUCE`, `SCAN`, `BYROW`, `BYCOL`, and `MAKEARRAY` through a typed callable invoker, first higher-order execution through an adopted defined-name callable carrier (`MAP(...,NamedLambda)`), direct and higher-order `ISOMITTED` present-argument evidence, explicit local evidence that direct lambda under-application remains distinct from an omitted-placeholder lane, a first draft host-managed name/external-name boundary packet, and semantic-plan recognition of `NameKind::MixedOrDeferred` as a first explicit `name_formula_carrier` lane.
- **Remaining gaps**: fuller Excel grammar closure, broader structured-reference qualifier unions and mixed-section selector breadth, richer external reference coverage, broader OxFunc catalog coverage, final shared callable transport, broader callable-family breadth beyond the current first application seam floor, exact host-managed name/external-name resolution boundary, and replay-backed evidence beyond the current local witness tier.
- **Why still open**: `W032`, `W036`, and `W038` still own broader catalog/callable freeze work, broader table semantics beyond the current section-only and first multi-column slice, and host-managed name/external-name boundary work beyond the now-exercised `W037`, `W039`, and `W040` local floors, so the repo-level feature remains broader than the current exercised slice.
- **Canonical owner**: `W001` now; exercised follow-on `W002`, `W003`, `W013`, `W014`, `W019`, `W020`, `W026`, `W027`, `W031`, `W037`, `W039`, and `W040`; active next owners `W032` and `W036`; explicit next seam-freeze owners `W041`, `W043`, and `W045`; planned follow-on owner `W038`.

### IP-02: FEC/F3E Evaluator Session

- **Status**: in-progress
- **Current floor**: OxFml-owned seam design and exercised implementation now include accepted-candidate, commit-bundle, reject-record, fence snapshots, typed no-publish fence rejection, single-formula host recalc wiring, a managed `prepare -> open_session -> capability_view -> execute -> commit` session-service slice with abort/expire handling, invalid-phase structural-conflict rejection, surfaced execution-restriction effect facts, runtime contention enforcement across sessions, async-coupled external-provider consequence surfacing, runtime-async overlay registration, explicit `HYPERLINK` publication-intent preservation in the current return-surface lane, explicit packet-level rich-value return classification, and checked local formal artifacts for the external capability gate plus busy-locus session contention, retry-after-release, overlay-cleanup, pinned-epoch overlay, distributed-placement, retry-ordering fairness, and placement-deferral expiry boundaries.
- **Remaining gaps**: broader async/distributed runtime behavior beyond the local external-provider, contention, first placement-outcome floor, non-overtaking retry-order floor, and deferred-placement expiry floor, pack-grade replay/model artifacts, and broader host integration beyond the single-formula proving path.
- **Why still open**: `W029` materially widened the local async-facing runtime floor and the current pass adds checked session-contention, retry-after-release, overlay-cleanup, pinned-epoch overlay, distributed-placement, retry-ordering fairness, and placement-deferral expiry boundary models, but repo-level runtime scope still extends beyond the exercised local contention, placement, retry-order, deferral-expiry, and external-provider model.
- **Canonical owner**: `W001` now; exercised follow-on `W004`, `W015`, `W018`, `W021`, `W024`, and `W029`; planned next owners `W034` and `W035`.

### IP-03: Commit Output Contract

- **Status**: in-progress
- **Current floor**: atomic bundle, schema, and fixture-planning baseline exist in OxFml-owned docs, and the exercised implementation now constructs commit bundles from accepted candidate results under matching fences, derives seam-significant `format_delta` and `display_delta` from prepared-result hints where applicable, rejects mismatched fences with typed no-publish outcomes, and surfaces typed dependency consequence facts inside `topology_delta`.
- **Remaining gaps**: broader commit bundle construction beyond the current local publication families, wider distributed publication policy, and pack-grade replay evidence.
- **Why still open**: `W028` materially widened the local publication and topology floor, but the repo-level feature still does not represent the full evaluator publication pipeline or pack-grade coverage.
- **Canonical owner**: `W001` now; exercised follow-on `W004`, `W015`, `W017`, `W018`, `W021`, `W023`, and `W028`; planned next owner `W034`.

### IP-04: Reject Taxonomy and Trace Schema

- **Status**: in-progress
- **Current floor**: reject and trace taxonomy, minimum schemas, and formal/replay planning baseline exist, with exercised typed reject records for fence mismatch, capability denial, abort, expire, and contention-sensitive paths; local replay fixtures for semantic-plan, prepared-call/result, execution-contract, session lifecycle, FEC commit/reject, single-formula host, and empirical-oracle slices; broadened local reduced-witness artifacts; local normalized replay bundles; plus checked local Lean artifacts for session lifecycle, external-reference deferment, deferred-name-carrier classification, failure-stage split, and external-name carrier typing, and checked local TLA+ models for session lifecycle, external capability gate, higher-order callable boundary, session contention boundary, retry-after-release boundary, overlay-cleanup boundary, pinned-epoch overlay boundary, distributed-placement boundary, retry-ordering fairness boundary, and placement-deferral expiry boundary behavior.
- **Remaining gaps**: broader typed reject coverage, pack-grade deterministic replay infrastructure, and broader formal families beyond the first checked runs.
- **Why still open**: `W022` and `W023` materially widened the local witness/formal floor, but the evidence remains local and not yet promoted into pack-grade corpus or wider formal coverage.
- **Canonical owner**: `W001` now; exercised follow-on `W004`, `W005`, `W015`, `W016`, `W017`, `W022`, and `W023`; planned next owners `W033`, `W034`, and `W035`.

### IP-05: Formula-Semantic Formatting

- **Status**: in-progress
- **Current floor**: formatting behavior crossing the seam is chartered and exercised through `TEXT`, `VALUE`, `NOW`, `TODAY`, `CELL`, and `INFO` with explicit locale-format and host-query context, prepared-result format/publication hints, locale format-dependency facts surfaced through the proving host, seam-significant `format_delta` and `display_delta` publication artifacts, empirical-oracle scenarios covering formatting and host-query lanes, and a first restricted conditional-formatting/data-validation carrier floor with explicit formula-semantic host fields and restriction profiles.
- **Remaining gaps**: broader semantic formatting family coverage, fuller display-boundary closure beyond the current seam-significant subset, richer `MS-OE376` carrier parity, and pack-grade proving scenarios.
- **Why still open**: `W030` and `W039` widened the local semantic-format and non-cell carrier floor, but the repo-level feature remains much broader than the exercised slice.
- **Canonical owner**: exercised follow-on `W006`, `W014`, `W018`, `W020`, `W021`, `W024`, `W030`, `W031`, and `W039`; explicit next seam-freeze owner `W042`; planned follow-on owner `W036`.

### IP-06: Replay Appliance Adapter and Witness Governance

- **Status**: in-progress
- **Current floor**: OxFml-local replay adapter governance is written into the canonical spec set, including the adapter note, conservative capability manifest through `cap.C3.explain_valid`, additive registry bindings, witness lifecycle usage rules, passing local conformance tests, broadened local reduced-witness artifacts across FEC commit/reject, session lifecycle, execution-contract, host, and empirical-oracle outcome classes, local normalized replay bundle and pack-candidate evidence, and machine-readable promotion-readiness indices.
- **Remaining gaps**: pack-grade replay promotion, broader reduced-witness breadth beyond the current local families, and any claim toward `cap.C4.distill_valid` or `cap.C5.pack_valid` remain open.
- **Why still open**: `W025` materially widened the promotion-governance floor, but the replay evidence remains local-only and intentionally non-pack-eligible.
- **Canonical owner**: exercised follow-on `W009` through `W017`, `W022`, `W023`, and `W025`; planned next owners `W033` and `W035`.

### IP-09: Host Runtime and External Requirements Freeze

- **Status**: in-progress
- **Current floor**: host/runtime truth is currently split across `OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`, `OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`, the live `W041` / `W042` / `W043` successor packets, and the outbound OxCalc seam note. A new canonical unifying draft now exists in `docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`.
- **Remaining gaps**: broader `W041` / `W042` / `W043` packet execution remains partial; caller-anchor and address-mode carriage for the first TreeCalc relative-reference subset remains in the `W026` note lane; execution-restriction transport shape and publication/topology breadth remain narrower than final shared closure; full product-host policy and broader distributed/runtime ownership remain outside the current packet.
- **Why still open**: OxCalc now reads the unified host/runtime draft as sufficient for the first implementation slice, but the packet is still anchored to a partial local floor and has not yet been promoted into shared seam-freeze text.
- **Canonical owner**: active next owner `W045`; upstream coordination counterpart is the next bounded OxCalc seam round keyed to the new host/runtime draft.

### IP-10: First Host Implementation Packet

- **Status**: in-progress
- **Current floor**: the host/runtime draft now includes a first implementation workflow, readiness assessment, and replay-integration path; the current direct-host packet exposes `TypedContextQueryBundleSpec`, `ReturnedValueSurface`, candidate, commit, reject, and trace outputs through `HostRecalcOutput`; unsupported or unavailable `INFO` / `CELL` / `RTD` behavior is explicit for the currently exercised slice; and `HostRecalcOutput::to_first_host_replay_capture_packet()` now provides a first dedicated host-side replay-capture projection helper.
- **Remaining gaps**: broader language and built-in-function closure remain outside the first host packet; the helper packet is not yet a pack-grade replay bundle builder; broader host-query/provider families remain outside the current first-host slice.
- **Why still open**: `W046` froze the first honest implementation packet for the current exercised slice, but repo-level host implementation scope is broader than that first slice.
- **Canonical owner**: exercised next owner `W046`; broader follow-on owners remain `W041`, `W042`, `W043`, and `W045`.

### IP-11: First Host Readiness

- **Status**: in-progress
- **Current floor**: the bounded `W047` batch has now executed the immediate first-host-readiness slice:
  - `W037` first local `R1C1` channel floor,
  - `W039` first restricted `CF` / `DV` carrier floor,
  - `W046` first-host packet and replay-capture freeze.
- **Remaining gaps**: the supporting `W041` / `W042` / `W043` packet work remains partial at repo scope; broader full-Excel and broad built-in closure remain out of scope for the first-host packet.
- **Why still open**: the immediate batch blockers are no longer implicit, but broader host readiness still depends on follow-on language and seam work outside the executed batch.
- **Canonical owner**: executed batch owner `W047`; active follow-on owners remain `W041`, `W042`, `W043`, and `W045`.

### IP-12: Editor Language Service And Immutable Formula Host Integration

- **Status**: in-progress
- **Current floor**: OxFml now has a first local language-service packet layer in `crates/oxfml_core/src/language_service/mod.rs`, including canonical syntax-tree tokens with owned leading/trailing trivia, editor syntax snapshots built from those owned tokens, immutable formula-edit request/result packets with explicit text-change ranges plus incremental parse/red/bind reuse and optional semantic-plan follow-on, unified live diagnostics spanning syntax/bind/semantic-plan stages, deterministic completion packets over visible functions/names/tables/structured selectors plus first `R1C1` syntax assists, completion-candidate validation and proposal application that re-enter the normal parse/bind pipeline, cursor-sensitive signature-help context, deterministic function-help lookup-request construction keyed to the current library-context snapshot, and intelligent-completion context packets for external non-canonical completion. Deterministic local evidence exists in `crates/oxfml_core/tests/language_service_tests.rs` and `crates/oxfml_core/tests/language_service_fixture_tests.rs`.
- **Remaining gaps**: no OxFunc-backed help/signature payload retrieval exists yet; no shared host/OxCalc immutable formula-edit packet is frozen yet; no shared host-facing packet for validated intelligent-completion results is frozen yet; editor packet evidence is deterministic local evidence rather than replay-appliance projection.
- **Why still open**: the real internal OxFml mechanics are now materially stronger, but the broader editor-grade host integration surface still depends on OxFunc help-metadata freezing, OxCalc/host immutable-edit packet freezing, and later evidence projection beyond the current local deterministic fixture floor.
- **Canonical owner**: active owner `W048`.

### IP-13: OxFunc Seam Integration Adapter And Fixture Artifacts

- **Status**: in-progress
- **Current floor**: the OxFml/OxFunc seam is converged enough at note level around `W041`, `W042`, `W043`, and the committed `W044` snapshot/export that OxFunc now wants a real OxFml-backed preparation/evaluation adapter and pinned seam-fixture corpus rather than continued mock-only confidence. A first local adapter floor now exists in `crates/oxfml_core/src/oxfunc_adapter/mod.rs`, projecting canonical preparation, evaluation, and mismatch artifacts over the real `SingleFormulaHost` path while preserving `TypedContextQueryBundle`, `ReturnedValueSurface`, and runtime library-context snapshot refs. Deterministic local evidence exists in `crates/oxfml_core/tests/w049_oxfunc_adapter_tests.rs` for direct-scalar vs array-like preparation, caller-anchor carriage, pinned snapshot selection, typed `RTD` provider outcomes, and structured mismatch packets. A first local pinned `W050` fixture corpus now exists in `crates/oxfml_core/tests/fixtures/w050_oxfunc_admitted_fixture_cases.json` plus `crates/oxfml_core/tests/fixtures/w050_oxfunc_deferred_fixture_register.json`, exercised by `crates/oxfml_core/tests/w050_oxfunc_pinned_fixture_tests.rs`. `W053` now also exercises grouped-aggregation adapter carriage for both inline `LAMBDA(...)` and bare built-in aggregation callables (`SUM`) across bounded `GROUPBY` / `PIVOTBY` lanes, plus bind-time duplicate/malformed `LAMBDA` rejection evidence.
- **Remaining gaps**: the authoritative published first-wave table is now confirmed by OxFunc to be 45 scenario ids and the local machine-readable corpus now admits all 45 of those ids; mismatch reporting against downstream packet artifacts is still narrow; worksheet `CALL` / `REGISTER.ID` remains outside the first adapter floor and now has a separate bounded owner; grouped-aggregation/publication-class expansion is still partial even though OxFunc now treats the current callable-heavy corpus as a real regression floor.
- **Why still open**: `W049` now has a real local adapter artifact and `W050` now covers the whole current pinned scenario table with explicit OxFml-side publication and bind-reject rules for the former `C12`/`C14` residuals; `W053` now has real local `GROUPBY` / `PIVOTBY` adapter cases across default, built-in callable, visible-header, subtotal, row/column sort, and bounded filter/totals lanes plus duplicate/malformed `LAMBDA` bind-rejection evidence; `W042` now preserves generic extended top-level return surfaces and non-ordinary publication classes more honestly across host and commit carriage, but broader packet-diff scaling, the next runtime lane under `W052`, and the remaining end-to-end `IMAGE` publication-class gap still remain.
- **Canonical owner**: active owners `W049`, `W050`, `W052`, and `W053`.

### IP-15: Worksheet CALL And REGISTER.ID Runtime Boundary

- **Status**: in-progress
- **Current floor**: OxFml now has a first exercised `W052` packet floor for worksheet `REGISTER.ID`, worksheet `CALL`, reference-visible `CALL` arguments, host API registration, VBA shim registration, and unregister packet carriage. The local packet now includes `RegisteredExternalProvider`, `RegisterIdRequest`, `RegisteredExternalDescriptor`, `RegisteredExternalCatalogMutationRequest`, `RegisteredExternalCatalogMutationResult`, and `RegisteredExternalCatalogController`, with host-facing support through `SingleFormulaHost::recalc_with_registered_external_provider(...)` and `SingleFormulaHost::apply_registered_external_catalog_mutation(...)`. Built-in catalog truth and runtime register/unregister semantics are now explicitly treated as OxFunc-owned, while OxFml preserves channel-specific host/VBA provenance and worksheet-visible consequence typing.
- **Remaining gaps**: OxFunc and OxCalc have not yet both acknowledged the sharpened packet wording; descriptor-driven dereference/coercion ownership is not yet frozen as shared seam text; later snapshot-generation consequences from register/unregister remain narrower than final closure.
- **Why still open**: the local packet and evidence now exist, OxFml now adopts the OxFunc-owned request/result packet types directly and exposes normalized worksheet `REGISTER.ID` / `CALL` packets in trace/adapter artifacts, but the shared seam still needs the next bounded note round and any resulting field-level freeze.
- **Canonical owner**: active owner `W052`.

### IP-14: Fixture Host And Coordinator Stand-In Packet

- **Status**: in-progress
- **Current floor**: a canonical first stand-in host/coordinator packet now exists in `docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`; OxCalc has reviewed it as the right bounded deterministic packet for fixture-host and first TreeCalc-facing integration reuse; accepted refinements now include `fixture_input_id`, explicit structure-context identity, optional `formula_slot_id`, optional `RegisteredExternalProvider`, and the explicit rule that candidate/commit/reject capture stays a separate projection layer.
- **Remaining gaps**: the packet is still only converged for the current narrow first wave; broader reuse across later formula-bearing slot families and any promotion into shared coordinator-API freeze remain open.
- **Why still open**: `W051` is now past draft-only planning, but the stand-in packet remains intentionally narrower than the production coordinator API and still depends on later implementation reuse or mismatch evidence for further freezing.
- **Canonical owner**: active owner `W051`.

## Source: `OxFml/docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`

# FEC/F3E Design Specification

## 1. Purpose
This document is the canonical OxFml-owned specification for the evaluator seam between OxFml and OxCalc.

The seam exists to let OxFml evaluate one formula instance against a versioned workbook snapshot and produce either:
1. an accepted candidate result payload suitable for coordinator-controlled atomic publication, or
2. a typed reject outcome with no accepted-state publication.

Baseline transaction lane:
1. `prepare`
2. `open_session`
3. `capability_view`
4. `execute`
5. `commit`

Canonical posture:
1. this document defines the live seam contract,
2. `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md` defines how the contract is supposed to be witnessed,
3. archive material and later run packs are support inputs, not bootstrap authority.

## 2. Scope and Ownership
OxFml owns:
1. evaluator session lifecycle,
2. evaluator-side capability requirements,
3. commit bundle shape,
4. evaluator-side trace and reject-detail schema,
5. overlay participation rules for dynamic references, spill, and format-sensitive evaluation.

OxCalc owns:
1. coordinator scheduling policy,
2. publication fencing policy beyond the evaluator contract,
3. dirty-closure and global recalc policy,
4. contention handling policy for concurrent evaluators.

OxFunc owns:
1. function semantic definitions,
2. coercion and evaluation traits exposed through the OxFunc catalog,
3. function-family reduction and evaluation rules consumed by OxFml semantic planning.

The prepared semantic boundary consumed by OxFunc is defined in:
1. `../formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`

The canonical identity/version vocabulary used by this seam is defined in:
1. `../OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`

The canonical field surfaces for accepted candidate results, commit bundles, and reject records are defined in:
1. `../OXFML_CANONICAL_ARTIFACT_SHAPES.md`

The canonical minimum schema objects for deltas, spill events, reject contexts, and trace payloads are defined in:
1. `../OXFML_MINIMUM_SEAM_SCHEMAS.md`

The canonical taxonomy layer for delta families, evaluator facts, reject contexts, and trace events is defined in:
1. `../OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`

## 3. Evidence and Assurance Posture
This seam spec is policy-first.
It should remain stable enough to drive implementation and cross-repo handoff work even before replay artifacts are refreshed.

Working rule:
1. live seam clauses belong in this document and the assurance map,
2. replay packs, run outputs, and handoff packets are evidence layers that support but do not replace the canonical seam wording,
3. stage-promotion or closure claims still require replay and cross-repo acknowledgment.

## 4. Architectural Position
FEC/F3E sits between:
1. OxFml parse/bind/semantic-plan/evaluation logic, and
2. OxCalc coordinator publication and scheduling logic.

It is the transactional evaluator publication seam.

FEC/F3E session state is evaluator-operational state.
It must not be confused with ownership of canonical formula syntax, bind artifacts, or higher workbook/document versions.
Those canonical artifacts remain externalized and versionable above the session boundary.

## 5. Session Identity and Fences
### 5.0 Prepare semantics
`prepare` is the pre-session validation and request-shaping step.

It exists to:
1. validate that the formula identity is known,
2. capture the current fence tuple before session open,
3. determine whether session open is admissible for the requested profile and capability scope,
4. reject early when the request cannot legally progress to evaluation.

### 5.1 Stable identity
Every session is anchored by stable evaluator identity:
1. `formula_stable_id`
2. `formula_token`
3. `snapshot_epoch`
4. `bind_hash`
5. `profile_version`

Human-readable labels are metadata only. They are not contractual identity.
Typed supporting identities such as name ids and spill-range ids remain part of seam evidence where the evaluator exposes them.

These fence members are intentionally a mixed category:
1. `formula_stable_id` is stable logical identity,
2. `formula_token`, `snapshot_epoch`, and `profile_version` are version/fence keys,
3. `bind_hash` is a bind-result fingerprint used operationally as a fence key.

### 5.2 Fence rules
`commit` must reject when any required fence no longer matches:
1. formula token mismatch,
2. snapshot epoch mismatch,
3. bind hash mismatch,
4. profile-version mismatch,
5. capability-view mismatch,
6. expired or aborted session.

Fence consequence rule:
1. incompatible or stale candidate work is rejected rather than partially published,
2. fence incompatibility must yield typed reject detail sufficient for deterministic replay,
3. no evaluator-side accepted state may be treated as published state until commit acceptance succeeds.

## 6. Capability Model
`capability_view` is the evaluator-side declaration and validation step for optional or profile-gated behaviors.

Rules:
1. capability decisions are session-bound,
2. capability denial must be machine-typed,
3. capability state must be revalidated at commit,
4. no hidden capability assumptions are allowed between execute and commit.

Host-query rule:
1. when function semantics depend on cell, workbook, or environment facts, the capability view must expose typed host-query capabilities rather than raw host objects or ad hoc callbacks.

## 7. Overlay Model
FEC/F3E mediates session-local overlay participation.

The baseline overlay families are:
1. calc-time dependency overlay,
2. spill overlay,
3. format dependency overlay.

Overlay rules:
1. overlays are derived state, never mutation of canonical structural truth,
2. overlay writes are session-local until commit,
3. overlay reuse requires exact fence match on epoch, token, bind hash, and profile version,
4. overlay eviction must be deterministic and epoch-safe.

## 8. Execute Semantics
`execute` runs one semantic plan against one fenced session context.

Execution may:
1. materialize prepared arguments for OxFunc,
2. discover dynamic references,
3. register spill and format overlay entries,
4. produce typed evaluator facts for later publication,
5. construct an `AcceptedCandidateResult` when evaluation succeeds under the active session fences,
6. terminate with a typed reject when the session cannot legally continue.

Execution must not:
1. publish partial global state,
2. mutate OxCalc-owned scheduler policy,
3. replace typed evaluator failures with opaque error strings.

## 9. Accepted Candidate Result Contract
Successful evaluation is not itself publication.

The accepted evaluator outcome is an `AcceptedCandidateResult`.
It is a non-published candidate payload presented for coordinator-controlled commit acceptance.

The canonical candidate-result shape is defined in:
1. `../OXFML_CANONICAL_ARTIFACT_SHAPES.md`

Rules:
1. accepted candidate results and committed publication are distinct layers,
2. accepted candidate results must carry enough structured content for one coherent atomic publication if the coordinator accepts them,
3. accepted candidate results must carry the compatibility basis needed for deterministic accept-versus-reject decisions,
4. accepted candidate results must surface or make derivable any runtime-discovered evaluator effects that materially affect coordinator correctness.

Coordinator-relevant runtime-derived effect families include at least:
1. dynamic-reference discoveries,
2. spill discoveries, conflicts, and typed spill events,
3. format-dependency discoveries,
4. capability-sensitive execution observations where they affect accept/reject or publication consequences,
5. execution-profile or execution-restriction facts where safe scheduling or publication interpretation depends on them.

## 10. Commit Bundle Contract
Accepted commits promote an `AcceptedCandidateResult` into one atomic published derived bundle.

Evaluator success does not itself imply publication.
Publication occurs only when the coordinator accepts the candidate result under compatible fences.

The baseline bundle shape is:
1. `value_delta`
2. `shape_delta`
3. `topology_delta`
4. optional `format_delta`
5. optional `display_delta`
6. trace fragment or trace correlation metadata

`topology_delta` carries evaluator facts and dependency evidence, not scheduler policy judgments.
Global recalc policy remains OxCalc-owned.

The current minimum field sets for these payloads are defined in:
1. `../OXFML_MINIMUM_SEAM_SCHEMAS.md`

## 11. Spill Event Contract
Spill semantics are explicit shape facts, not inferred side effects.

The baseline spill-event families are:
1. `SpillTakeover`
2. `SpillClearance`
3. `SpillBlocked`

Each spill event must carry enough typed context to let OxCalc derive invalidation behavior without guessing.

## 12. Reject Taxonomy
Rejects are typed, replay-stable, and non-publishing.

Baseline reject families include:
1. token and snapshot fence mismatch,
2. capability denial,
3. session expiry or session abort,
4. bind mismatch,
5. structural conflict,
6. dynamic-reference failure classes,
7. profile-version mismatch,
8. resource exhaustion,
9. internal invariant violation.

Reject consequence rule:
1. rejected work publishes no accepted state,
2. fence and capability incompatibilities must produce structured reject detail rather than ambiguous failure classes,
3. reject detail must be sufficient for deterministic replay and coordinator diagnostics,
4. the minimum typed reject-context schemas are defined in `../OXFML_MINIMUM_SEAM_SCHEMAS.md`.

## 13. Trace Contract
Tracing is part of the seam contract.

Each traced event must be:
1. versioned,
2. schema-validatable,
3. correlated to formula/session identity,
4. sufficient to replay session outcome classification.

Trace correlation must be sufficient to distinguish:
1. candidate-result construction,
2. commit acceptance versus commit rejection,
3. reject-with-no-publish outcomes,
4. surfaced runtime-derived effect reporting that influences coordinator correctness.

## 14. Formal Modeling Hooks
FEC/F3E must be specified so the seam can be checked as part of DNA Calc's near-formal core.

Lean-oriented seam artifacts should include:
1. typed session-state ADTs,
2. commit bundle shape,
3. reject taxonomy,
4. no-publish-on-reject rule,
5. fence-soundness rules for the sequential baseline.

TLA+-oriented seam artifacts should include:
1. session lifecycle and state transitions,
2. snapshot/token/capability fence behavior,
3. concurrent commit contention and retry behavior,
4. session expiry and abort cleanup,
5. publish authority and atomicity rules.

Replay artifacts remain the concrete witness layer tying these models back to executable behavior.

The canonical seam-level witness map is defined in:
1. `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`

## 15. Boundary Discipline
### 15.1 OxCalc boundary
FEC/F3E publishes evaluator facts and typed outcomes.
OxCalc consumes those facts and owns scheduler and global publication policy.

### 15.2 OxFunc boundary
OxFml prepares arguments and results for OxFunc while preserving reference- and provenance-sensitive distinctions.
OxFunc semantic rules do not erase OxCalc policy boundaries.

## 16. Stage Guidance
The baseline spec is written for Stage 1 sequential coordinator semantics first.

Stage 2 and beyond require additional closure for:
1. deterministic contention replay,
2. session-registry concurrency hardening,
3. epoch-pinning overlay GC safety,
4. parallel reduction determinism where applicable.

## 17. Related Documents
1. `README.md`
2. `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
3. `FEC_F3E_TESTING_AND_REPLAY.md`
4. `../OXFML_SYSTEM_DESIGN.md`
5. `../OXFML_FORMALIZATION_AND_VERIFICATION.md`
6. `../formula-language/OXFML_FORMULA_ENGINE_ARCHITECTURE.md`

## Source: `OxFml/docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`

# FEC/F3E Formal and Assurance Map

## 1. Purpose
This document is the canonical OxFml assurance map for the FEC/F3E seam.

It makes explicit:
1. which live documents define the seam contract,
2. how the conformance matrix references those documents,
3. which seam clause families are expected to gain replay, Lean, and TLA+ coverage,
4. which assurance lanes remain open.

This is a bootstrap document.
It is not a dated execution report or a transition note.

## 2. Canonical Source Documents
The live FEC/F3E seam is defined by:
1. `FEC_F3E_DESIGN_SPEC.md`
2. `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
3. `FEC_F3E_TESTING_AND_REPLAY.md`
4. `FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
5. `../OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
6. `../OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
7. `../OXFML_SYSTEM_DESIGN.md`
8. `../OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
9. `../OXFML_IMPLEMENTATION_BASELINE.md`
10. `../OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
11. `../OXFML_CANONICAL_ARTIFACT_SHAPES.md`
12. `../OXFML_MINIMUM_SEAM_SCHEMAS.md`
13. `../OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
14. `../OXFML_FORMALIZATION_AND_VERIFICATION.md`
15. `../OXFML_FORMAL_ARTIFACT_REGISTER.md`
16. `../formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`
17. `../OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
18. `../OXFML_EMPIRICAL_PACK_PLANNING.md`

Archive material may support evidence work later, but it is not bootstrap authority.

## 3. Conformance Matrix Document Identifiers
The FEC/F3E conformance matrix uses these document evidence identifiers:

| evidence_id | meaning |
|---|---|
| `DOC-FEC-DESIGN` | Canonical seam contract in `FEC_F3E_DESIGN_SPEC.md`. |
| `DOC-FEC-ASSURANCE` | Canonical seam assurance map in this document. |
| `DOC-FEC-TEST` | Testing, replay, and pack strategy in `FEC_F3E_TESTING_AND_REPLAY.md`. |
| `DOC-FEC-FIXTURE-PLAN` | Schema replay fixture plan in `FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`. |
| `DOC-OXFML-REPLAY-ADAPTER` | OxFml-local replay adapter rollout contract in `../OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`. |
| `DOC-OXFML-REPLAY-MANIFEST` | OxFml adapter capability manifest in `../OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`. |
| `DOC-OXFML-SYSTEM` | OxFml-wide ownership and subsystem boundaries in `../OXFML_SYSTEM_DESIGN.md`. |
| `DOC-OXFML-OPTIONS` | OxFml implementation-shape constraints in `../OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`. |
| `DOC-OXFML-BASELINE` | OxFml code-start implementation baseline in `../OXFML_IMPLEMENTATION_BASELINE.md`. |
| `DOC-OXFML-IDS` | OxFml identity/version vocabulary in `../OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`. |
| `DOC-OXFML-SHAPES` | OxFml canonical artifact field surfaces in `../OXFML_CANONICAL_ARTIFACT_SHAPES.md`. |
| `DOC-OXFML-SCHEMAS` | OxFml minimum schema objects for seam payload families in `../OXFML_MINIMUM_SEAM_SCHEMAS.md`. |
| `DOC-OXFML-TAXONOMY` | OxFml taxonomy layer for deltas, facts, rejects, and traces in `../OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`. |
| `DOC-OXFML-FORMAL` | OxFml-wide formalization posture in `../OXFML_FORMALIZATION_AND_VERIFICATION.md`. |
| `DOC-OXFML-FORMAL-REGISTER` | OxFml formal artifact register in `../OXFML_FORMAL_ARTIFACT_REGISTER.md`. |
| `DOC-OXFML-OXFUNC` | OxFml to OxFunc semantic boundary in `../formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`. |
| `DOC-OXFML-DNA-HOST` | DNA OneCalc host-policy baseline in `../OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`. |
| `DOC-OXFML-EMP-PACK` | Empirical-pack planning baseline in `../OXFML_EMPIRICAL_PACK_PLANNING.md`. |

These identifiers mean "specified by the current live spec set".
They are not claims that replay or formal artifacts already exist.

## 4. Assurance Coupling Rule
Every important FEC/F3E seam clause should map to:
1. a canonical prose clause,
2. a conformance matrix row,
3. a replay or scenario-pack obligation,
4. a Lean-friendly typed surface, a TLA+ property, or both when appropriate.

If one of these is missing, the gap remains open and must stay visible in status reporting.

## 5. Clause Families and Expected Witnesses
| clause_family | primary seam focus | replay expectation | Lean expectation | TLA+ expectation |
|---|---|---|---|---|
| Session lifecycle | `prepare -> open_session -> capability_view -> execute -> commit` | deterministic phase traces and accept/reject cases | typed session-state ADTs and transition admissibility | lifecycle state machine and legal transition invariants |
| Fences and identity | session identity, token/epoch/bind/profile fences | reject-on-mismatch replay corpus | typed fence tuple and mismatch classification | stale-commit exclusion and publish safety |
| Candidate/publication boundary | accepted candidate result distinct from published bundle | candidate-vs-published replay corpus | candidate/bundle relation invariants | accept/reject/publication separation |
| Atomic commit bundle | one publishable bundle with typed deltas | accept/reject bundle witness packs | bundle-shape invariants | atomic publish/no-publish split |
| Minimum payload schemas | minimum field sets for candidate, commit, reject, and trace payload families | schema-validation replay packs | ADT field-preservation invariants | payload sufficiency for accept/reject/publication outcomes |
| Reject taxonomy | typed non-publishing failures | reject-detail replay pack | reject-code families and no-publish-on-reject theorem surface | reject transitions and abort cleanup |
| Overlay lifecycle | dynamic refs, spill, format overlays | overlay creation/reuse/eviction scenarios | overlay token and delta typing | visibility, pinning, and epoch-safe eviction |
| Spill event semantics | takeover, clearance, blocked | spill event replay bundles | event payload typing | interaction with concurrent sessions and retries |
| Runtime-derived effect surfacing | coordinator-relevant evaluator facts and derived effects | effect-report replay packs including async-coupled external-provider lanes | fact/delta typing | coordinator-visible consequences under concurrency |
| OxFunc preparation boundary | prepared args/results and caller context | prepared-call trace packs | prepared-call ADTs and invariants | not primary unless concurrency affects evaluation context |
| Host-mode compatibility | OxCalc-integrated vs DNA OneCalc reduced profile | reduced-profile acceptance packs | profile-gated contract surfaces | reduced-profile state-space constraints |

## 6. Initial Pack Alignment
The initial pack families expected to witness the seam are:
1. `PACK.fec.transaction_boundary`
2. `PACK.fec.commit_atomicity`
3. `PACK.fec.reject_detail_replay`
4. `PACK.fec.overlay_lifecycle`
5. `PACK.fec.format_dependency_tokens`
6. `PACK.oxfml.oxfunc.prepared_contract`
7. `PACK.fec.minimum_payload_schemas`

These pack names describe intended witness families.
They are not evidence of exercised packs yet.

## 7. Adapter Capability And Replay Appliance Evidence
OxFml replay rollout claims must be backed by explicit adapter evidence.

Current evidence targets:
1. `cap.C0.ingest_valid`
   - proving artifacts should include source fixture import and normalized bundle-validation evidence
2. `cap.C1.replay_valid`
   - proving artifacts should include deterministic replay rerun for supported fixture families plus explicit unsupported-state surfacing
3. `cap.C2.diff_valid`
   - proving artifacts should include typed mismatch-family evidence over candidate, commit, reject, and effect surfaces
4. `cap.C3.explain_valid`
   - proving artifacts should include why-rejected or why-not-published explanation evidence with source refs
5. `cap.C4.distill_valid`
   - remains scaffolded only until OxFml has broader retained-local witness breadth, at least one irreducibility or unsupported case, and stronger promotion-grade governance over those retained sets
6. `cap.C5.pack_valid`
   - remains out of scope in this pass

Current rollout target:
1. OxFml claims through `cap.C3.explain_valid`,
2. OxFml scaffolds but does not claim `cap.C4.distill_valid`,
3. OxFml does not claim `cap.C5.pack_valid`.

## 8. Witness Lifecycle And Quarantine Assurance
Witness lifecycle state affects assurance claims whenever replay outputs are promoted beyond local witness tier.

Current rules:
1. explanatory-only witnesses may support local understanding but not pack-facing assurance,
2. quarantined witnesses may support triage but not promotion claims,
3. retained or promoted witness claims require explicit lifecycle refs and resolved capability preconditions,
4. lifecycle governance is additive and does not change OxFml semantic truth.

## 9. Open Assurance Lanes
The following remain explicitly open:
1. the current replay corpus is still local and not yet promoted into pack-grade seam artifacts,
2. the first local Lean and TLA+ session lifecycle artifacts are now checked locally, but broader formal families remain unproved,
3. no TLA+ model has yet been authored for concurrent evaluator sessions or publish fences beyond the checked local sequential lifecycle model,
4. recorded OxCalc-facing seam handoffs remain open for ad hoc future coordination where coordinator-facing clauses materially change,
5. minimum provenance vocabulary for prepared-call and prepared-result structures is still being tightened with the OxFunc boundary,
6. timeout, abort, and overlay-cleanup closure remains open before Stage 2 promotion,
7. current adapter capability claims still rely on local witness-tier evidence rather than pack-grade corpus,
8. witness lifecycle and quarantine governance are now specified and broadened local reduced-witness coverage exists across host and oracle families, but pack-facing promotion does not exist yet,
9. local normalized pack-candidate bundles now exist as rehearsal evidence, but remain intentionally non-pack-eligible,
10. DNA OneCalc host-policy and empirical-pack planning are now explicit, but they remain planning-only and do not imply host or pack maturity.

Current checked local formal floor also includes:
1. `formal/lean/OxFmlExternalReferenceDeferred.lean`
   - external-provider admissibility plus async-capability consequence lemmas
2. `formal/lean/OxFmlNameCarrierDeferred.lean`
   - mixed/deferred name carrier plans require explicit deferred evaluation and capability markers
3. `formal/lean/OxFmlFailureStageSplit.lean`
   - edit rejection remains distinct from accepted-unresolved, semantic-plan gated, runtime-capability denied, and post-dispatch provider-unavailable outcomes
4. `formal/lean/OxFmlExternalNameCarrier.lean`
   - explicit external-book identity, same-external-book restriction, and provider-stage outcomes remain distinct for external-name carriers
5. `formal/tla/FecExternalCapabilityGate.tla`
   - external-provider gate with checked async-consequence invariant
6. `formal/tla/FecHigherOrderCallableBoundary.tla`
   - catalog-admitted higher-order lanes may still reject at the callable-invoker boundary without collapsing back into catalog or parse/bind failure
7. `formal/tla/FecSessionContentionBoundary.tla`
   - busy-locus multi-session rejection remains distinct from publishable execution and does not imply scheduler-policy closure
8. `formal/tla/FecRetryAfterReleaseBoundary.tla`
   - retry-admissibility after busy-locus rejection is modeled separately from scheduler fairness or placement policy
9. `formal/tla/FecOverlayCleanupBoundary.tla`
   - session-local overlays are cleaned on commit, abort, and expiry and do not survive epoch advance as stale active overlays
10. `formal/tla/FecPinnedEpochOverlayBoundary.tla`
   - retained overlay epochs may be reused only on exact snapshot-epoch match and are evictable only after executed-session pins are released
11. `formal/tla/FecDistributedPlacementBoundary.tla`
   - local placement admission remains distinct from remote-placement deferral and no publishable result exists until a locally admitted execution reaches commit
12. `formal/tla/FecRetryOrderingBoundary.tla`
   - once retry-admissibility ordering is surfaced, later retries do not overtake earlier admissible retries without explicit rejection or release
13. `formal/tla/FecPlacementDeferralExpiryBoundary.tla`
   - deferred remote-placement lanes may expire or reject without acquiring a local claim and without becoming publishable
14. `formal/run_formal.ps1`
   - canonical local runner for those checked artifacts

## 10. Working Rule
Use the live design and assurance docs for bootstrap and implementation planning.
Use archive materials only for migration history or later evidence work.

## Source: `OxFml/docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`

# FEC/F3E Testing and Replay Strategy

## 1. Purpose
This document defines the initial OxFml testing, replay, and evaluation strategy for the formula engine and FEC/F3E seam.

The goal is to make OxFml testable in isolation, testable with OxFunc, and testable at the OxCalc seam without conflating those layers.

This document should be read together with:
1. `FEC_F3E_DESIGN_SPEC.md`
2. `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
3. `FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
4. `../OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
5. `../OXFML_MINIMUM_SEAM_SCHEMAS.md`
6. `../OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
7. `../OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
8. `../OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
9. `../OXFML_EMPIRICAL_PACK_PLANNING.md`

## 1A. Test Ladder
The canonical OxFml test ladder is defined in:
1. `../OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`

This document applies that ladder to FEC/F3E-specific testing and replay obligations.

## 2. Assurance Layers
OxFml testing is split into six layers:

1. **Syntax fidelity**
   - tokenization,
   - parse acceptance/rejection,
   - full-fidelity round-tripping,
   - entered-text vs stored-text capture.
2. **Bind and normalization**
   - name scope resolution,
   - structured reference binding,
   - relative/absolute address normalization,
   - explicit unresolved-reference classification.
3. **Minimal local bootstrap evaluator**
   - literals and operators,
   - tiny fixture function set or probe/test-only functions,
   - defined-name supplied values,
   - fast OxFml-owned bring-up and benchmark loops.
4. **OxFunc preparation contract**
   - prepared-argument provenance,
   - reference-preserving dispatch,
   - lazy/eager/reference-preserved evaluation modes,
   - format/locale service injection.
5. **FEC/F3E transaction boundary**
   - session lifecycle,
   - snapshot/token/capability fences,
   - candidate-result versus published-bundle distinction,
   - atomic commit bundle shape,
   - minimum delta and reject-context payload schemas,
   - typed reject detail,
   - surfaced runtime-derived effect families.
6. **Replay and integration**
   - dynamic dependency rediscovery,
   - spill takeover/clearance/blocked flows,
   - format dependency invalidation,
   - single-formula proving host,
   - DNA OneCalc single-node proving and OxCalc seam proving,
   - Excel empirical oracle comparison runs.

## 3. Required Artifact Types
Each exercised OxFml behavior should eventually produce one or more of:
1. deterministic scenario definitions,
2. replay bundles,
3. structured trace logs,
4. normalized parse/bind snapshots,
5. conformance-matrix rows with evidence links,
6. schema-validation fixtures for typed seam payload objects.

## 3A. Evidence Tiers
OxFml currently distinguishes two assurance tiers for replay evidence:

1. **Local witness evidence**
   - deterministic fixtures and tests living inside the repo,
   - sufficient for local workset-gate closure where the declared scope is an implementation-start baseline,
   - not sufficient by itself for program-level assurance claims.
2. **Pack-grade evidence**
   - promoted scenario packs with stable identifiers, scenario metadata, and explicit clause mapping,
   - required for stronger program-level assurance, broader promotion claims, and cross-repo conformance narratives.

Working rule:
1. local witness evidence may satisfy a local workset gate when the workset explicitly targets a baseline slice,
2. local witness evidence must not be described as if it were already pack-grade corpus,
3. spec and status docs should state which tier is currently present.

## 3B. DNA ReCalc Workflow For OxFml Fixture Families
The OxFml replay rollout adopts the Foundation `DNA ReCalc` workflow additively.

Current OxFml workflow:
1. ingest
   - import lane-native fixture families and local witness artifacts as OxFml-owned source material
2. normalize
   - emit additive replay bundle envelopes while preserving source schema ids, typed payloads, and sidecar refs
3. validate
   - validate bundle shape, source-schema compatibility, and explicit projection gaps
4. replay
   - rerun supported fixture scenarios deterministically against preserved OxFml semantics
5. diff
   - compare normalized replay outputs using additive mismatch families while preserving OxFml source kinds
6. explain
   - answer why-changed, why-rejected, and why-not-published questions from bundle artifacts and source refs
7. distill
   - planned for future rollout only after replay-valid reduced witnesses are locally evidenced

Workflow rule:
1. OxFml fixture import does not flatten typed artifacts into generic replay prose,
2. normalization is additive transport only,
3. witness distillation is offline and remains outside the current claimed capability level.

## 3C. Adapter Capability Claim Path
The OxFml replay adapter capability path is:
1. publish a conservative capability manifest,
2. bind each claimed level to local witness-tier conformance artifacts,
3. surface known limits explicitly,
4. keep pack-grade promotion separate from current capability claims.

Current target:
1. claim `cap.C0.ingest_valid`
2. claim `cap.C1.replay_valid`
3. claim `cap.C2.diff_valid`
4. claim `cap.C3.explain_valid`
5. scaffold but do not claim `cap.C4.distill_valid`
6. do not claim `cap.C5.pack_valid`

Current rule:
1. the capability manifest is honest only if known gaps stay explicit,
2. local witness-tier evidence is sufficient for the current OxFml local rollout target,
3. local witness-tier evidence is not sufficient to imply pack-grade maturity.

## 4. Initial Pack Map
The baseline OxFml pack map is:

1. `PACK.oxfml.parse.full_fidelity`
2. `PACK.oxfml.bind.reference_normalization`
3. `PACK.oxfml.bootstrap_evaluator.minimal`
4. `PACK.oxfml.oxfunc.prepared_contract`
5. `PACK.oxfml.single_formula_host.recalc`
6. `PACK.oxfml.empirical_formula_oracle`
7. `PACK.fec.commit_atomicity`
8. `PACK.fec.reject_detail_replay`
9. `PACK.fec.overlay_lifecycle`
10. `PACK.fec.format_dependency_tokens`
11. `PACK.format.semantic_vs_display_boundary`
12. `PACK.fec.transaction_boundary`
13. `PACK.fec.minimum_payload_schemas`

## 4A. Witness Lifecycle, Quarantine, and Pack Eligibility
OxFml adopts the Foundation witness lifecycle and quarantine model as rollout governance.

Current rules:
1. explanatory-only witnesses are not pack-eligible,
2. quarantined witnesses are not pack-eligible,
3. reduced witnesses remain local evidence until they carry explicit lifecycle refs and satisfy replay-valid policy,
4. pack eligibility additionally requires the adapter capability surface to meet the pack-required level,
5. current OxFml rollout does not declare formula-text, bind, fence, or capability-view rewrites replay-safe,
6. local replay bundles and normalized fixtures may remain useful for ingest, replay, diff, and explain even when not pack-eligible,
7. local normalized pack-candidate bundles are rehearsal artifacts only and must remain explicitly non-pack-eligible.
8. retained-local witness sets may broaden across host and empirical-oracle families, but retained-local breadth alone does not imply `cap.C4.distill_valid`.

## 5. Local Bootstrap Evaluator Role
OxFml should maintain a minimal local bootstrap evaluator surface for fast OxFml-owned testing.

Its role is:
1. not to replace OxFunc,
2. to exercise parser/binder/evaluator/seam paths quickly,
3. to support local regression and benchmark loops with a tiny fixture function set,
4. to support defined-name-driven single-formula proving before full downstream breadth is available.

This local kernel must remain intentionally small.

## 6. OxFunc-Backed Semantic Role
Beyond the minimal bootstrap kernel, OxFml should use OxFunc outputs for downstream function-semantic testing.

That means:
1. OxFml should test prepared-call/result behavior against OxFunc semantics,
2. OxFml should avoid broad local reimplementation of real function families,
3. the wider function-semantic corpus should come from OxFunc-backed runs.

## 7. Single-Formula Proving Host Role
Before full DNA OneCalc host specification, OxFml should exercise a single-formula proving host with:
1. one formula under test,
2. mutable defined-name inputs,
3. mutable direct cell bindings where a reference-sensitive formula needs concrete resolution,
4. full update and full recalc semantics,
5. no multi-formula dependency graph,
6. candidate/commit/reject/trace output capture.

Current exercised local floor:
1. reuse-sensitive recalc over changed host inputs,
2. scalarization-sensitive host runs for `@` and `_xlfn.SINGLE`,
3. helper-form host runs for `LET` and callable `LAMBDA`,
4. spill-sensitive host runs for `SEQUENCE`,
5. formatting-sensitive host runs for `TEXT`,
6. host-query-sensitive host runs for `INFO` and `CELL("filename", ...)`.

## 8. Empirical Oracle Role
OxFml should maintain formula-oriented empirical validation scaffolding that uses Excel behavior as oracle.

The scaffolding should make it easy to verify:
1. stored-form vs entered-form behavior,
2. single-formula evaluation behavior,
3. defined-name input update behavior,
4. high-risk lanes such as `@`, `#`, `SINGLE`, `LET`, `LAMBDA`, spill publication, formatting-sensitive semantics, and host-query semantics.

Current exercised local floor:
1. formatting oracle scenarios via `TEXT`,
2. host-query oracle scenarios via `INFO("directory")` and `CELL("filename", ref)`,
3. scalarization oracle scenarios via `@` and `_xlfn.SINGLE`,
4. helper-form oracle scenarios via `LET` and callable `LAMBDA`,
5. spill-shaped oracle scenarios via `SEQUENCE(2)`.

## 9. Formal and Model-Checking Obligations
OxFml testing is coupled to formal assurance from the start.

The initial formal obligations are:
1. Lean-friendly type definitions for syntax, bind outputs, prepared-call contracts, commit bundles, and reject taxonomy,
2. TLA+ models for session lifecycle, commit atomicity, snapshot/token fences, session expiry, and concurrent contention behavior,
3. explicit mapping from each pack family to the prose contract sections it validates,
4. replay artifacts that witness the same clauses concretely.

The first TLA+ priority is the FEC/F3E transaction and concurrency surface.
The first Lean priority is the typed contract surface and structural invariants.

The clause-to-witness mapping used for seam planning is defined in:
1. `FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`

## 10. DNA OneCalc Evaluation Role
DNA OneCalc is the preferred early proving host for:
1. parser correctness,
2. binder/reference normalization,
3. OxFunc integration,
4. single-node evaluation semantics,
5. reduced-profile FEC/F3E transaction exercises.

DNA OneCalc is not allowed to redefine OxFml semantics.
Its role is to exercise the OxFml/OxFunc contracts without OxCalc multi-node coordination.

The current host-policy baseline and empirical-pack planning docs are:
1. `../OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
2. `../OXFML_EMPIRICAL_PACK_PLANNING.md`

## 11. OxCalc Integration Role
OxCalc integration testing should validate:
1. atomic bundle publication,
2. policy-boundary discipline,
3. replay-stable rejects,
4. coordinator consumption of topology evidence without seam policy leakage,
5. schema-sufficient candidate, commit, spill, and reject payloads for deterministic accept/reject handling.

## 12. Current Open Assurance Lanes
The following remain explicitly open:
1. contention replay for multi-session commit conflicts,
2. canonical unified trace schema versus subsystem schema merge strategy,
3. proof obligations for fast-path soundness,
4. proof obligations for parallel reduction determinism,
5. full cross-build empirical refresh of legacy Excel-compat evidence,
6. pack-grade promotion of the currently local witness corpus,
7. TLA+ and Lean artifact authoring for the now-exercised execution-profile and proving-host slices,
8. local evidence for `cap.C4.distill_valid`,
9. all policy surfaces needed for `cap.C5.pack_valid`.

## 13. Current Local Witness Floor
The current local witness floor for the exercised implementation-start slice is:
1. parse/bind fixtures: `crates/oxfml_core/tests/fixtures/parse_bind_cases.json`
2. semantic-plan fixtures: `crates/oxfml_core/tests/fixtures/semantic_plan_replay_cases.json`
3. prepared-call/result fixtures: `crates/oxfml_core/tests/fixtures/prepared_call_replay_cases.json`
4. FEC commit/reject fixtures: `crates/oxfml_core/tests/fixtures/fec_commit_replay_cases.json`
5. execution-contract fixtures: `crates/oxfml_core/tests/fixtures/execution_contract_replay_cases.json`
6. session lifecycle fixtures: `crates/oxfml_core/tests/fixtures/session_lifecycle_replay_cases.json`
   Current exercised lanes: fence rejection, contention, async-coupled external-provider execution, dependency consequence facts, and overlay-family expectations
7. single-formula host fixtures: `crates/oxfml_core/tests/fixtures/single_formula_host_replay_cases.json`
   Current exercised lanes: reuse-sensitive recalc, scalarization, helper forms, spill, formatting, host-query, and seam-significant publication-surface deltas
8. empirical-oracle scenario fixtures: `crates/oxfml_core/tests/fixtures/empirical_oracle_scenarios.json`
   Current exercised lanes: formatting, host-query, scalarization, helper-form invocation, spill publication, and seam-significant `format_delta` / `display_delta`
9. replay-adapter manifest and conformance checks: `docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`, `docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`, and `crates/oxfml_core/tests/replay_adapter_and_witness_tests.rs`
10. first local reduced-witness artifacts: `crates/oxfml_core/tests/fixtures/witness_distillation/fec_reject_formula_token_reduction_manifest.json`, `crates/oxfml_core/tests/fixtures/witness_distillation/fec_reject_formula_token_witness_bundle.json`, and `crates/oxfml_core/tests/fixtures/witness_distillation/fec_reject_formula_token_lifecycle.json`
11. broadened reduced-witness artifacts: `crates/oxfml_core/tests/fixtures/witness_distillation/fec_accept_publication_reduction_manifest.json`, `crates/oxfml_core/tests/fixtures/witness_distillation/session_capability_denied_reduction_manifest.json`, `crates/oxfml_core/tests/fixtures/witness_distillation/execution_contract_host_query_reduction_manifest.json`, and `crates/oxfml_core/tests/replay_adapter_and_witness_tests.rs`
12. local normalized pack-candidate bundles: `crates/oxfml_core/tests/fixtures/replay_bundle_normalization/fec_commit_pack_candidate_bundle.json`, `crates/oxfml_core/tests/fixtures/replay_bundle_normalization/session_lifecycle_pack_candidate_bundle.json`, and `crates/oxfml_core/tests/fixtures/replay_bundle_normalization/pack_candidate_index.json`
13. promotion-readiness planning artifacts: `crates/oxfml_core/tests/fixtures/replay_bundle_normalization/promotion_candidate_families.json` and `crates/oxfml_core/tests/fixtures/replay_bundle_normalization/promotion_readiness_index.json`

These are local witness artifacts, not yet promoted pack-grade corpus.

## Source: `OxFml/docs/spec/formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`

# Excel Formatting Hierarchy and Visibility Model

## 1. Purpose
Define a concrete, implementation-facing model for:
1. formatting hierarchy and precedence,
2. defaults and locale interaction,
3. what formula evaluation can and cannot observe about formatting (including conditional formatting).

This document is a focused companion to:
1. `EXCEL_CELL_CONCRETE_MODEL.md` (`ECM-FMT-*` lanes),
2. `fec-f3e/FEC_F3E_DESIGN_SPEC.md` (locale/profile and seam policy lanes),
3. `CONFORMANCE_REQUIREMENTS.csv` (`XLS-CF-FM-*` lanes).

It should also be read with:
1. `../OXFML_SYSTEM_DESIGN.md`
2. `../OXFML_FORMALIZATION_AND_VERIFICATION.md`
3. `../formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`

## 2. Formatting Object Families (SpreadsheetML-facing)
Working model for worksheet-visible formatting stacks:
1. workbook style primitives (`numFmts`, `fonts`, `fills`, `borders`, etc.),
2. style XF families (`cellStyleXfs`, `cellXfs`) and style linkage (`xfId` lane),
3. per-cell style index usage (`s` / style index lane),
4. differential formats (`dxf`) used by conditional formatting and related overlays,
5. sheet defaults (`sheetFormatPr`, `baseColWidth`, `defaultRowHeight`) and row/column-default style lanes.

## 3. Style Resolution Pipeline (Draft Model)
Draft effective-format pipeline for a cell:
1. workbook/sheet baseline defaults,
2. row/column style defaults (where present),
3. cell style index mapping via `cellXfs` (+ referenced `cellStyleXfs` lane),
4. table/style-region overlays where applicable,
5. conditional-format differential overlay (`dxf`) where rule conditions match and precedence permits.

Boundary rule:
1. value semantics remain independent of formatting semantics.
2. formatting pipeline computes effective display/style state, not core value identity.

## 4. Precedence and Conflict Lanes
Current explicit lanes:
1. base style vs direct cell style index,
2. row/column default style interaction with cell style index,
3. table style region interaction with direct cell style,
4. conditional-format overlap and priority ordering,
5. spill-target and dynamic-array interaction with conditional formatting.

Status:
1. precedence is partially source-anchored and partially empirical/provisional.
2. conflict lanes must remain explicit until cross-build empirical closure.

## 5. Defaults and Origin of "Normal" Formatting
Defaults are modeled as a profile-sensitive composition, not a hardcoded constant:
1. workbook/template style tables,
2. sheet defaults (`sheetFormatPr` family),
3. host/build profile behavior (for example baseline default font family/size in newly created workbooks),
4. locale profile effects on number/date/time render behavior.

Implication:
1. default font/size claims are version/profile assertions that require explicit evidence capture.

## 6. Locale/Regional Interaction Model
Locale profile affects:
1. formatting parse/render behavior (number/date tokens and separators),
2. text-to-number/date interpretation lanes used by related functions,
3. display output under equivalent stored value/style state.

Locale profile does not alter:
1. core value-tag semantics,
2. style object identity (style ids/indices), except where locale-specific format code interpretation is defined.

## 7. Formula Visibility Boundary (Key)
This lane separates:
1. core formula value computation,
2. formatted-display introspection behaviors.

Working classification:
1. `TEXT(value, format_text)`:
   - explicit format-string conversion; does not require reading ambient cell formatting.
2. `CELL(...)` / `INFO(...)`:
   - host/context-introspection family; may expose environment and selected formatting-related metadata lanes.
3. legacy XLM `GET.*`/`GET.CELL`-style techniques:
   - treated as compatibility/probe lane requiring explicit empirical capture in this project.

Conditional-format visibility question:
1. unresolved: whether effective conditional-format result is directly observable through formula/evaluation functions in supported modern contexts.
2. policy: keep as provisional empirical lane until explicitly bounded.

## 8. Grid Formatting Semantics (Workbook-level View)
Grid-formatting behavior should be represented through:
1. persisted style objects and index references,
2. non-destructive overlays (table/CF differentials),
3. precedence/merge rules for effective display state,
4. explicit separation between persisted format state and transient effective-display state where applicable.

## 9. Formal Evidence Anchors (Focused Pass)
Key promoted anchors used here:
1. style index correction lane:
   - `CONF-discovered-ms-oe376-220816-823374c7-0409` (`p:5904`)
   - `CONF-discovered-ms-oi29500-250218-d35cbb01-0387` (`p:5446`)
2. style XF cardinality/relationship underspec lane:
   - `SPEC-discovered-ms-oe376-220816-823374c7-07670` (`p:6726`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-07068` (`p:6315`)
3. `xfId` overwrite linkage lane:
   - `SPEC-discovered-ms-oe376-171212-fc69605e-19192` (`page:324:block:74`)
4. `dxfId` optional lane:
   - `SPEC-discovered-ms-oe376-220816-823374c7-07427` (`p:6464`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-06824` (`p:6050`)
5. sheet defaults lane:
   - `SPEC-discovered-ms-oe376-220816-823374c7-07309` / `-07310` (`p:6365`/`p:6366`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-06711` / `-06712` (`p:5956`/`p:5957`)
6. `numFmtId` default/constraint tension lane:
   - no-default signals: `SPEC-discovered-ms-oi29500-250218-d35cbb01-06258`, `SPEC-discovered-ms-oe376-220816-823374c7-06881`
   - constrained case signal: `CONF-discovered-ms-xlsx-250916-d16a975a-0067`

## 10. Required Empirical Closure Tracks
1. precedence collisions across row/column/cell/table/CF layers,
2. workbook/template default style origin and drift by build/profile,
3. locale profile matrix for format parse/render effects,
4. formula-visible formatting and conditional-format observability (`TEXT`, `CELL`, `INFO`, legacy compatibility probes).

## 11. Formalization Hooks
Formatting and visibility semantics should participate in the near-formal stack where practical.

Important formalizable surfaces include:
1. explicit separation between value semantics and formatting-observable semantics,
2. format dependency token families and invalidation rules,
3. locale/date-system service inputs,
4. provisional conditional-format observability boundaries,
5. replayable format-sensitive evaluation outcomes.

## 12. Status
1. This is a draft model intended to tighten conformance lanes and empirical plans.
2. Unresolved assertions are intentionally tracked as provisional in linked requirement/open-question artifacts.

## Source: `OxFml/docs/spec/formula-language/MS_OE376_FORMULA_AND_FORMATTING_REVIEW.md`

# MS-OE376 Formula And Formatting Review

## 1. Purpose
This document records the OxFml-owned review outcome for the remaining formula and formula-adjacent rule families surfaced by `MS-OE376`.

It does not mirror Microsoft prose mechanically.
It translates the reviewed source material into:
1. OxFml ownership boundaries,
2. current-coverage classification,
3. evidence posture,
4. concrete follow-on work packets.

## 2. Authority And Reading Rule
1. `MS-OE376` is treated here as an upstream source of Excel behavior and carrier-shape signals.
2. OxFml canonical docs remain authoritative for OxFml meaning, artifact boundaries, reject semantics, and replay consequences.
3. If `MS-OE376` families imply carrier or host distinctions that OxFml does not yet model, this document records them as missing or partial rather than silently importing them into live semantics.

## 3. Reviewed Source Baseline
This pass was driven from Foundation-owned reference processing rooted at:
1. `../Foundation/reference/runs/20260318-ms-oe376-full-detail-pass-01/outputs`
2. `../Foundation/reference/downloads/learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/db9b9b72-b10b-4e7e-844c-09f88c972219.md`
3. `../Foundation/reference/runs/20260305-ms-formatting-formal-pass-01/outputs/FORMATTING_FORMAL_FINDINGS.md`

High-signal source anchors used in this review:
1. structured references:
   - `SPEC-discovered-ms-oe376-88e93023-48236`
   - `CONF-discovered-ms-oe376-220816-823374c7-1423`
2. conditional-formatting formula restrictions:
   - `CONF-discovered-ms-oe376-220816-823374c7-1427`
   - `CONF-discovered-ms-oe376-220816-823374c7-1428`
   - `CONF-discovered-ms-oe376-220816-823374c7-1429`
   - `CONF-discovered-ms-oe376-220816-823374c7-1430`
3. data-validation formula restrictions:
   - `CONF-discovered-ms-oe376-220816-823374c7-1431`
4. defined-name uniqueness and carrier presence:
   - `CONF-discovered-ms-oe376-220816-823374c7-0362`
   - `CONF-discovered-ms-oe376-220816-823374c7-0363`
   - `SPEC-discovered-ms-oe376-88e93023-48424`
5. external name formulas:
   - `SPEC-discovered-ms-oe376-88e93023-48443`
   - `SPEC-discovered-ms-oe376-88e93023-48448`
   - `SPEC-discovered-ms-oe376-88e93023-48451`
6. R1C1 formulas:
   - `CONF-discovered-ms-oe376-220816-823374c7-1434`
   - `SPEC-discovered-ms-oe376-88e93023-48474`
   - `SPEC-discovered-ms-oe376-88e93023-48487`
7. historical DV/name carrier presence:
   - `SPEC-discovered-ms-oe376-171212-fc69605e-23574`
   - `SPEC-discovered-ms-oe376-88e93023-51882`

## 4. Family Classification

| family | source signal | current OxFml coverage | current local evidence posture | review classification | follow-on owner |
|---|---|---|---|---|---|
| Structured references | `MS-OE376` treats intra-table references as explicit formula syntax and carrier surface, including omitted-table-name forms and current-row-sensitive semantics. | `FML-R-009` exists in [EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md](./EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md); normalized-reference docs already mention row-context-sensitive structured refs in [OXFML_NORMALIZED_REFERENCE_ADTS.md](./OXFML_NORMALIZED_REFERENCE_ADTS.md). | local parser acceptance and some structured-reference evidence exist, but qualifier breadth, omitted-table-name binding, binder shapes, and table-context runtime meaning are still narrow. | `partial` | `W036` |
| Conditional-formatting formulas | `MS-OE376` constrains CF formulas by forbidding array constants, structured references, union/intersection, and 3-D references, while also exposing formula-bearing host fields such as `cfRule/formula` and threshold lanes such as `cfvo@val`. | formatting semantics acknowledge conditional-format overlays and observability boundaries in [EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md](../formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md). | the current local floor now has a canonical restricted-carrier contract, explicit host-field facts, and deterministic validation evidence for the admitted syntax subset, but broader `MS-OE376` parity remains open. | `partial` | `W039` |
| Name formulas | `MS-OE376` treats defined names as formula-bearing carriers with workbook/sheet scoping rules. | scoped name-resolution rule exists in `FML-R-008`; proving-host docs already allow defined-name bindings. | name collision and scope evidence exists, but non-cell formula-bearing carrier semantics are not first-class in canonical OxFml docs. | `partial` | `W038` |
| External name formulas | `MS-OE376` exposes external-name expression families and error-bearing external-name outcomes, with a narrower same-external-book restriction than generic external references. | OxFml has external references, availability taxonomy, and provider/runtime lanes, but not an explicit external-name formula carrier model. | some external-reference parsing and provider/runtime evidence exists, but external-name grammar, same-book restriction, bind shape, and carrier semantics are still under-specified. | `missing_to_partial` | `W038` |
| R1C1 formulas | `MS-OE376` treats R1C1 as a distinct formula language channel and requires R1C1-style references in that carrier. | OxFml now has a canonical `WorksheetR1C1` channel contract for the first local floor. | deterministic local evidence now covers absolute and caller-anchor-relative cell references plus qualified area translation, but broader `R1C1` parity remains open. | `partial` | `W037` |
| Data-validation formulas | `MS-OE376` exposes `dataValidation/formula1` and `formula2` as separate formula-bearing lanes, with restriction pressure similar to CF formulas but not obviously identical. | the current local floor now has a dedicated DV restricted-carrier contract and explicit formula-slot host facts. | deterministic local evidence covers the first admitted/rejected restricted-carrier slice, but broader `MS-OE376` parity remains open. | `partial` | `W039` |
| Formula-significant table or formatting surfaces | `MS-OE376` plus current formatting findings indicate formula-adjacent table and conditional-format rules that matter semantically even if they are not general UI behavior. | OxFml already distinguishes semantic format vs display and table/CF overlays in [EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md](../formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md). | local evidence covers only seam-significant format/display subsets, not the full formula-bearing carrier consequences of tables, CF, or DV. | `partial` | `W036` and `W039` |

## 5. Cross-Cutting Ownership Outcome

### 5.1 Grammar And Parsing
The review implies four distinct parser lanes, not one generic backlog:
1. structured-reference grammar and qualifier breadth,
2. broader `R1C1` formula and reference parity beyond the current local floor,
3. name and external-name formula-bearing carriers,
4. broader conditional-formatting and data-validation parity beyond the current restricted-carrier floor.

### 5.2 Bind And Reference Normalization
The reviewed material sharpens four bind lanes:
1. table-context-sensitive structured-reference resolution,
2. R1C1 relative/absolute translation under caller position,
3. explicit defined-name and external-name carrier identity,
4. typed refusal or deferment for formula carriers not yet executable in a given host/runtime profile.

Critical bind consequence:
1. omitted structured-reference table names cannot be resolved from syntax alone and require enclosing-table context,
2. structured-reference table identifiers must remain distinct from user-defined names,
3. external-name formulas need explicit external-book identity rather than generic external-reference flattening.

### 5.3 Evaluator And Runtime
The review does not authorize silent reuse of worksheet-formula semantics everywhere.
OxFml must keep open the possibility that:
1. conditional-formatting formulas are a restricted worksheet-like sublanguage,
2. data-validation formulas are a distinct host/evaluation lane,
3. external-name formulas depend on runtime/provider outcomes that differ from plain worksheet references,
4. name formulas are formula-bearing carriers whose storage and update semantics are not identical to grid-cell formulas.

Critical runtime consequence:
1. R1C1 is not just a render/view mode in this source set; it is a separate formula-entry lane whose admissibility depends on R1C1 references.

### 5.4 Semantic Formatting And Host Policy
Two consequences are important:
1. formula-significant table and conditional-formatting surfaces belong in OxFml semantics only where they alter formula admission, bind meaning, evaluator context, or seam-significant effects,
2. UI-only formatting remains out of scope for OxFml even when `MS-OE376` documents it near formula language.
3. rule-host surfaces such as `sqref`, rule type, operator, time-period, threshold fields, and priority are part of formula-host semantics for CF/DV lanes rather than generic styling noise.

## 6. Explicit Non-Authorizations
This review does not authorize:
1. blind promotion of `MS-OE376` wording into OxFml canonical rule text,
2. treating structured references, R1C1, CF formulas, and DV formulas as one interchangeable parser feature,
3. assuming name formulas and grid-cell formulas share identical host, replay, or publication semantics,
4. collapsing external-name/provider failure into a generic `#NAME?` lane without stage-aware typing,
5. treating UI formatting rules as OxFml formula semantics unless formula admission, bind, evaluation, or seam-significant effects depend on them.

## 7. High-Risk Distinctions From The Review
1. structured references are context-sensitive and are not universally admissible across all formula-bearing carriers,
2. `#This Row` is a true row-context lane, not mere surface sugar,
3. conditional-formatting and data-validation formulas should be treated as restricted sublanguages until local evidence proves wider reuse safely,
4. external-name formulas are narrower than generic external references,
5. R1C1 should be modeled as a formula channel, not only as a presentation mode.
6. conditional-formatting and data-validation restrictions are similar but not safely identical; current source support does not justify silently collapsing them into one ban list,
7. `:` remains admissible pressure for CF/DV even where union and intersection are restricted,
8. whitespace preservation on formula-bearing CF/DV fields is part of carrier fidelity rather than purely cosmetic serialization.

## 8. Follow-On Workset Shaping
This review yields the following concrete follow-on backlog:
1. `W036` structured references and table formula semantics realization,
2. `W037` R1C1 formula channels and reference translation,
3. `W038` name and external-name formula carriers,
4. `W039` conditional-formatting and data-validation formula sublanguages.

Working sequence:
1. `W036` and `W037` can proceed after the current formula-language baseline without waiting for all runtime/distributed work.
2. `W038` should follow the current OxFml/OxFunc catalog/provider narrowing so external-name carrier semantics do not race ahead of library-context truth.
3. `W039` should build on the semantic-format/display boundary already narrowed in `W030` and the future runtime consequence work from `W034` where CF/DV outcomes become seam-significant.

## 9. W031 Outcome
Current `W031` result:
1. the relevant `MS-OE376` families are now classified against current OxFml coverage,
2. the review has been converted into explicit OxFml-owned backlog shape,
3. several reviewed families remain intentionally unpromoted into live rule text because OxFml does not yet have the local replay/evaluator floor to claim stronger semantics honestly.

That means this review is useful now, but it is not itself a claim that the reviewed families are locally realized.

## Source: `OxFml/docs/spec/formula-language/OXFML_CF_DV_RESTRICTED_SUBLANGUAGES.md`

# OxFml Conditional-Formatting and Data-Validation Restricted Sublanguages

## Purpose
This document defines the first honest OxFml-local floor for conditional-formatting (`CF`) and
data-validation (`DV`) formulas as restricted, host-managed formula carriers.

These are not treated as ordinary worksheet-cell carriers.

## Carrier Ownership
Hosts own the surrounding carrier records and lifecycle for:
1. conditional-formatting rules,
2. data-validation rules,
3. target-range attachment and rule-field management.

OxFml owns:
1. formula admission for the exercised restricted floor,
2. restriction classification,
3. the formula-semantic meaning of the currently modeled host fields,
4. the distinction between `CF` and `DV` restriction profiles.

## Current Local Floor
For the current local floor:
1. `CF` formulas use carrier kind `ConditionalFormatting`,
2. `DV` formulas use carrier kind `DataValidation`,
3. both carriers currently reuse the ordinary worksheet parser/binder for the admitted syntax
   subset,
4. both carriers are validated through an explicit restricted-carrier validation step.

The current local restriction floor rejects these reference/operator families for both carriers:
1. union reference operator,
2. intersection reference operator,
3. spill-reference operator,
4. external references.

The current local floor does not claim broader parity for:
1. structured references,
2. table-context-sensitive formulas,
3. array-constant or 3-D reference policy,
4. UI/rendering policy.

## Formula-Semantic Host Fields
The current local floor models the following host fields explicitly:

### Conditional Formatting
1. `target_ranges`
2. `rule_kind`
3. optional `operator`
4. threshold-bearing fields such as `cfvo@val`

### Data Validation
1. `target_ranges`
2. `validation_kind`
3. optional `operator`
4. formula slot identity such as `formula1` or `formula2`

These are treated as formula-semantic carrier facts, not generic styling noise.

## Distinct Restriction Profiles
The current local floor keeps the carrier profiles distinct:
1. `CF` uses `cf_restricted_not_equal_to_dv`
2. `DV` uses `dv_restricted_not_equal_to_cf`

Similarity is not treated as license to collapse them into one identical profile.

## Explicit Residuals
The following remain outside the current local floor:
1. broader carrier-specific admissibility rules from the full `MS-OE376` family,
2. rendering or UI policy,
3. broader runtime/coordinator consequence handling for non-cell carriers,
4. structured-reference/table-aware `CF`/`DV` semantics.

## Current Deterministic Evidence
The current local evidence lives in:
1. `crates/oxfml_core/tests/w047_host_readiness_tests.rs`
2. `crates/oxfml_core/src/carrier.rs`

## Source: `OxFml/docs/spec/formula-language/OXFML_EDITOR_LANGUAGE_SERVICE_AND_HOST_INTEGRATION_PLAN.md`

# OxFml Editor Language Service And Host Integration Plan

## 1. Purpose
Define the extended-scope plan for turning OxFml's formula parser and binder into an editor-grade language substrate suitable for:
1. larger immutable host document trees,
2. live diagnostics and squiggle surfaces,
3. function help and signature help,
4. completion and intelligent-completion integration,
5. edit-driven incremental syntax/bind updates without hidden semantic mutation.

This is primarily a planning document for future scope, but it now also records the first OxFml-local execution slice for editor-facing packets.
It is not a claim that the current OxFml local floor already provides a full editor-grade service surface.

Read together with:
1. `OXFML_FORMULA_ENGINE_ARCHITECTURE.md`
2. `OXFML_PARSER_AND_BINDER_REALIZATION.md`
3. `OXFML_OXFUNC_LIBRARY_CONTEXT_RUNTIME_INTERFACE.md`
4. `../OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`
5. `../OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`

## 2. Current Read
Current OxFml already has the right broad architectural direction:
1. immutable green tree,
2. contextual red view,
3. explicit bind artifacts,
4. explicit runtime library-context provider direction.

But the current local floor is still narrower than a true editor-grade language-service substrate.

Main current gaps:
1. trivia is preserved only as plain tokens, not as carefully owned leading/trailing trivia on syntax elements,
2. no canonical edit/change packet exists for formula-in-document spine updates,
3. diagnostics are parser/bind/runtime artifacts, not yet a unified live language-service stream,
4. function help/signature help are not surfaced as live editor packets,
5. no canonical completion or intelligent-completion request/response packet exists.

## 2.1 Current first local floor
OxFml now has a first internal language-service packet layer in `crates/oxfml_core/src/language_service/mod.rs`.

That local floor currently includes:
1. canonical syntax-tree tokens with leading/trailing trivia owned directly in the green tree, plus `EditorSyntaxSnapshot` built from that owned trivia while the retained full token stream stays available for correlation and round-trip text recovery,
2. `FormulaEditRequest` / `FormulaEditResult` plus explicit text-change ranges and subtree-reuse summaries over incremental parse/red/bind and optional semantic-plan follow-on,
3. `LiveDiagnosticSnapshot` unifying syntax, bind, and semantic-plan diagnostics for squiggle/list use,
4. deterministic completion packets over visible functions, names, tables, table columns, structured selectors, and first `R1C1` syntax assists,
5. cursor-sensitive `SignatureHelpContext`,
6. deterministic `FunctionHelpLookupRequest` construction so OxFml can ask OxFunc for help payloads without guessing at call context,
7. `IntelligentCompletionContext` so an external intelligent completer can work from one normalized context packet,
8. deterministic completion-candidate validation and proposal application that re-enter the normal parse/bind/plan pipeline rather than bypassing it.

This is still narrower than the full target outcome:
1. no OxFunc-backed help payload retrieval exists yet,
2. no shared host/OxCalc immutable formula-edit packet is frozen yet,
3. no shared host-facing packet for validated intelligent-completion results is frozen yet,
4. editor packet evidence is deterministic local evidence, not replay-appliance projection.

## 3. Target Outcome
The target outcome is not "an editor inside OxFml".
The target outcome is a clean immutable language-service substrate that external hosts can use.

That substrate should allow:
1. OxCalc-integrated hosts and direct hosts to embed formula green trees as canonical immutable children in larger immutable workbook/document trees,
2. formula edits to rebuild only the edited leaf payloads plus ancestor spine,
3. live parse/bind/semantic diagnostics to be surfaced continuously,
4. OxFunc-backed function help to appear in the editor stream,
5. deterministic local completion plus optional external intelligent completion to operate over the same immutable context packet.

## 4. Green Tree And Trivia Plan
### 4.1 Required extension
Green trees should move from "token-retaining" to "carefully trivia-owning".

Required direction:
1. every syntax token should preserve exact source text,
2. trivia should be preserved explicitly and stably enough for round-trip and formatting-neutral editing,
3. malformed fragments should remain representable in-tree rather than only in diagnostics,
4. incremental edits should be able to reuse unchanged green subtrees without reparsing the whole formula.

### 4.2 Intended token/trivia model
The preferred editor-grade model is:
1. `GreenToken`
   - `kind`
   - `text`
   - `leading_trivia`
   - `trailing_trivia`
   - `span` or span-derivable width
2. `GreenTrivia`
   - `kind`
   - `text`
3. `GreenNode`
   - immutable
   - parentless
   - context-free
   - children = nodes or tokens

The exact storage layout remains open.
The semantic requirement is not.

### 4.3 Formula-text update rule
Canonical update direction should be host-driven:
1. host owns the larger immutable workbook/document tree,
2. host submits a formula-text edit request against one formula-bearing slot,
3. OxFml returns:
   - new green root,
   - subtree-reuse metadata,
   - updated diagnostics,
   - optional updated bind and semantic-plan artifacts when requested,
4. host then rebuilds only the containing immutable document spine.

Working rule:
1. OxFml should not own the whole workbook tree,
2. OxFml should own the immutable formula artifact transforms,
3. larger document-spine replacement remains host/coordinator work.

### 4.4 Change packet
The first future edit packet should include:
1. `formula_stable_id`
2. `previous_formula_token`
3. `previous_green_tree_key`
4. `new_formula_text`
5. optional textual change ranges
6. `structure_context_version`
7. requested follow-on stages:
   - parse only
   - parse + bind
   - parse + bind + semantic-plan

Expected return packet:
1. `new_formula_token`
2. `green_tree_key`
3. subtree reuse summary
4. diagnostics stream snapshot
5. optional `bind_hash`
6. optional `semantic_plan_key`

## 5. Live Diagnostics Plan
### 5.1 Unified language-service diagnostics
OxFml should expose one live diagnostics family with typed origin/stage rather than separate host-specific ad hoc lists.

Minimum diagnostics classes:
1. `syntax_error`
2. `syntax_recovery_info`
3. `bind_error`
4. `bind_warning`
5. `semantic_plan_warning`
6. `capability_info`
7. `host-service-unavailable_info`

### 5.2 Display model
The language-service packet should support:
1. list views,
2. squiggle spans,
3. hover detail,
4. quick navigation to the span,
5. change-stable diagnostic identity where possible.

Minimum fields:
1. `diagnostic_id`
2. `severity`
3. `stage`
4. `message`
5. `primary_span`
6. optional `related_spans`
7. optional `code`
8. optional `suggested_fix_kind`

### 5.3 Suggestions and fix-its
OxFml may eventually provide bounded structured suggestions where semantics are local and deterministic.

Examples:
1. missing closing delimiter,
2. malformed structured-reference qualifier combination,
3. omitted-table-name without enclosing table context,
4. unsupported function/query family in current host profile.

Working rule:
1. suggestions are advisory,
2. they must never silently mutate canonical formula text,
3. they must stay deterministic and replay-stable.

## 6. Function Help And Signature Help Plan
### 6.1 Source of truth
Function help should come from OxFunc, not from duplicated prose inside OxFml.

Preferred source:
1. OxFunc function catalog/runtime snapshot metadata,
2. optionally paired help/signature documentation packet from OxFunc,
3. versioned by the same library-context snapshot identity already used for semantic planning.

### 6.2 Why OxFunc is the right source
OxFunc already owns:
1. function identity,
2. semantic traits,
3. arity and argument-shape truth,
4. deferred-function classification,
5. profile/gating truth for built-ins and registered extensions.

So the editor/help layer should not invent a second function-definition source of truth in OxFml.

### 6.3 First function-help packet
The first future packet should support:
1. `lookup_key`
   - typed function id or surface token
2. `library_context_snapshot_ref`
3. `display_name`
4. `signature_forms`
5. `argument_help`
6. `short_description`
7. `availability/gating_summary`
8. `deferred_or_profile_limited` flags where applicable

### 6.4 Signature-help trigger model
Signature help should be driven by:
1. current cursor position,
2. current bound/red syntax position,
3. current active argument index,
4. current library-context snapshot.

OxFml should compute:
1. whether the cursor is inside a call,
2. active callee syntax,
3. active argument ordinal,
4. parse/bind ambiguity notes if the call is currently malformed.

OxFunc should supply:
1. the function signatures and argument help payloads for the identified function.

## 7. Completion And Intelligent Completion Plan
### 7.1 Deterministic local completion
OxFml should first expose deterministic local completion categories:
1. function names from the current library-context snapshot,
2. defined names visible in bind context,
3. table names and column names where structured-reference context is active,
4. syntax keywords/selector families such as `#Headers`, `#Data`, `#Totals`, `#All`, `#This Row`,
5. channel-specific syntax assists such as `R1C1` forms where applicable.

### 7.2 Intelligent completion boundary
External intelligent completion is allowed, but it must remain non-canonical and host-owned.

Working rule:
1. OxFml provides the structured context packet,
2. an external intelligent completer may propose candidate edits or insertions,
3. OxFml remains the canonical validator through parse/bind/semantic diagnostics,
4. no intelligent suggestion becomes semantic truth until it re-enters OxFml through the ordinary edit path.

### 7.3 First intelligent-completion context packet
The minimum packet should include:
1. `formula_text`
2. `formula_channel_kind`
3. `cursor_span_or_offset`
4. `green_tree_key`
5. `red_context_summary`
6. visible name/table scope summaries
7. `library_context_snapshot_ref`
8. active diagnostics near cursor
9. active call/signature-help context if present

Optional richer fields later:
1. nearby formula snippets,
2. surrounding host object kind:
   - cell
   - defined name
   - external name
   - conditional-formatting rule
   - data-validation rule
3. target profile/capability summary

### 7.4 Completion result packet
Deterministic and intelligent completion results should normalize to one insertion-oriented shape:
1. `proposal_id`
2. `proposal_kind`
3. `display_text`
4. `insert_text`
5. optional `replacement_span`
6. optional `documentation_ref`
7. optional `requires_revalidation` flag

## 8. Host And OxCalc Integration
### 8.1 Direct host
A direct single-formula host should be able to use the same language-service packet family without OxCalc.

That means:
1. formula edit packets are independent of coordinator scheduling,
2. diagnostics/help/completion are derived from immutable formula artifacts plus explicit context,
3. live editing does not require a multi-node engine.

### 8.2 OxCalc-integrated host
In OxCalc-integrated mode:
1. the larger immutable workbook/document tree stays host/coordinator-owned,
2. OxFml remains the canonical formula-language service for formula-bearing nodes,
3. OxCalc may add cross-cell orchestration, but should not redefine formula syntax or local editor semantics.

### 8.3 Name/table/object ownership
This plan does not change the existing ownership split:
1. host/coordinator owns workbook objects,
2. OxFml owns formula-language meaning,
3. OxFunc owns function help/semantic catalog truth for functions.

### 8.4 OxFml best-effort proposal for OxCalc/direct host
Current OxFml best-effort proposal is that the first shared editor packet should be split into:
1. immutable edit request,
2. immutable edit result,
3. validated completion application result.

Proposed immutable edit request:
1. `formula_stable_id`
2. `previous_formula_token`
3. `previous_green_tree_key`
4. `new_formula_text`
5. optional `text_change_range`
6. `formula_channel_kind`
7. `structure_context_version`
8. explicit bind-visible context summary:
   - visible names
   - visible tables
   - caller anchor when already part of the formula slot
9. requested follow-on stage

Proposed immutable edit result:
1. `new_formula_token`
2. `green_tree_key`
3. `text_change_range`
4. subtree reuse summary
5. diagnostics snapshot
6. optional `bind_hash`
7. optional `semantic_plan_key`

Proposed validated-completion application result:
1. `proposal_id`
2. applied replacement span
3. updated immutable edit result
4. explicit rule that host/coordinator still owns the containing document-spine replacement

Working rule:
1. OxFml should not mutate the workbook/document tree,
2. OxFml should only return replacement-ready immutable formula artifacts,
3. host or coordinator remains responsible for accepting the result and rebuilding the containing immutable spine.

## 9. OxFunc Seam Implications
This extended scope creates one likely future seam packet with OxFunc:
1. editor/help-facing function-definition packet or provider surface.

Expected future questions for OxFunc:
1. what is the smallest help/signature packet derivable from runtime library-context truth,
2. which fields are semantic truth versus prose/help presentation,
3. how registered runtime extensions participate,
4. whether function-help retrieval rides the existing runtime library-context provider or a sibling metadata provider.

Working recommendation:
1. keep semantic-planning truth and help/signature truth related by shared stable ids,
2. avoid making OxFml scrape or duplicate OxFunc docs,
3. keep editor/help metadata versioned by library-context snapshot identity where practical.

### 9.1 OxFml best-effort proposal for OxFunc
Current OxFml best-effort proposal is:
1. keep semantic planning on the existing runtime `LibraryContextSnapshot`,
2. expose help/signature metadata through a sibling help provider keyed by the same snapshot identity rather than overloading the hot-path semantic snapshot,
3. let OxFml compute call-site context locally and ask OxFunc only for help payloads.

Proposed request:
1. `lookup_key`
2. `library_context_snapshot_ref`

Proposed response:
1. `stable_function_id`
2. `display_name`
3. `signature_forms`
   - parameter display labels
   - minimum arity
   - maximum arity or open-ended marker
4. `short_description`
5. `availability_summary`
6. `deferred_or_profile_limited`
7. optional `documentation_ref`

Working rule:
1. OxFunc remains the source of truth for signatures/help text,
2. OxFml remains the source of truth for cursor position, active argument index, parse ambiguity, and whether the user is inside a call at all.

## 10. First Work Breakdown
The likely execution order for this editor-grade extension is:
1. green-tree trivia and token ownership freeze,
2. immutable formula-edit and subtree-reuse packet,
3. live diagnostics packet and stage taxonomy,
4. deterministic completion packet,
5. OxFunc-backed function-help/signature-help seam,
6. external intelligent-completion context packet,
7. host/OxCalc integration packet.

## 10A. Open-Lane Closure Strategy
The remaining `W048` lanes should be handled in this order:
1. OxFml-only execution:
   - trivia-owning green-token realization,
   - deterministic completion breadth,
   - editor replay/evidence widening,
2. OxFunc seam freeze:
   - help/signature provider shape,
   - minimal help/signature payload,
3. OxCalc seam freeze:
   - immutable edit request/result packet,
   - validated intelligent-completion result packet.

This matters because two visible open lanes are now mainly packet-shape freeze rather than formula-semantics uncertainty:
1. OxFunc help/signature payloads,
2. OxCalc immutable-edit and validated-completion integration.

## 11. Non-Goals
Out of scope for the first extension wave:
1. a full IDE/workspace implementation inside OxFml,
2. auto-fix mutation applied without host approval,
3. AI/LLM completion becoming a semantic authority,
4. storing the whole workbook object model inside OxFml,
5. conflating editor services with FEC/F3E runtime session semantics.

## 12. Current Recommendation
The next honest planning owner should:
1. freeze the editor-grade green-tree/trivia model first,
2. keep the update path host-driven and immutable-spine-friendly,
3. treat diagnostics/help/completion as explicit typed packets,
4. source function help from OxFunc through stable runtime/catalog truth,
5. keep intelligent completion external and non-canonical.

## Source: `OxFml/docs/spec/formula-language/OXFML_OXFUNC_LIBRARY_CONTEXT_RUNTIME_INTERFACE.md`

# OxFml/OxFunc Library Context Runtime Interface

## Purpose
Define the preferred OxFml/OxFunc integration shape for built-in catalog truth and runtime catalog extension.

This document is not a claim that the current cross-repo interface is fully locked.
It is the OxFml-side proposal for the next stabilization round:
1. the normative interface should be a runtime-ingested, versioned library-context interface,
2. file exports such as `W044` should remain conformance, pinning, and mismatch-discovery artifacts,
3. runtime registration and removal of user-defined or host-provided functions must fit the same model without hidden global state.

## Scope
This proposal covers:
1. built-in catalog ingestion for OxFml parse, bind, semantic planning, and evaluation,
2. dynamic registration and removal of later callable or external surfaces,
3. snapshot identity and replay correlation,
4. minimum object families and invariants.

This proposal does not lock:
1. Rust trait names,
2. transport encoding for cross-process cases,
3. a final generalized provider/subscription contract,
4. final UDF execution ABI.

## Boundary Position
The OxFml/OxFunc boundary should not be a build-time catalog-file ingestion contract.

The preferred shape is:
1. OxFunc owns catalog truth and catalog-generation logic,
2. OxFml consumes immutable library-context snapshots through a formal runtime interface,
3. snapshot exports such as `OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv` remain:
   - conformance artifacts,
   - test-pinning artifacts,
   - mismatch-discovery artifacts,
   - evidence for replay correlation,
   not the normative runtime contract itself.

## Core Runtime Object Families
The minimum formal object families OxFml wants are:

### 1. LibraryContextProvider
An externally supplied provider that can hand OxFml a concrete versioned snapshot.

Minimum required semantic operations:
1. `current_snapshot() -> LibraryContextSnapshot`
2. `snapshot_by_identity(snapshot_ref) -> Option<LibraryContextSnapshot>`
3. `lookup_surface(snapshot_ref, surface_key) -> Option<LibraryContextEntry>`

Optional but desirable later operations:
1. `subscribe_snapshot_changes()`
2. `diff_snapshots(old_ref, new_ref)`

### 2. LibraryContextSnapshot
An immutable versioned catalog view suitable for parse, bind, semantic planning, evaluation gating, and replay correlation.

Minimum required properties:
1. `snapshot_id`
2. `snapshot_generation`
3. source provenance:
   - `source_commit_short`
   - `source_commit_full`
   - `source_tree_state`
4. stable lane identity
5. stable entry collection keyed by `surface_stable_id`

### 3. LibraryContextEntry
A single built-in or registered surface row projected into runtime-consumable form.

Minimum required semantic fields:
1. `surface_stable_id`
2. `entry_kind`
3. `registration_source_kind`
4. `canonical_surface_name`
5. `name_resolution_table_ref`
6. `semantic_trait_profile_ref`
7. `gating_profile_ref`
8. `metadata_status`
9. `special_interface_kind`
10. `admission_interface_kind`
11. `preparation_owner`
12. `runtime_boundary_kind`
13. `interface_contract_ref`

Compatibility/interoperability metadata should remain attachable without replacing primary identity:
1. `xlcall_builtin_symbol`
2. `xlcall_builtin_code`

### 4. RegistrationDescriptor
A host/OxFml-supplied descriptor for runtime-added surfaces.

Minimum semantic intent:
1. stable registration/catalog id or stable pending id,
2. surface name,
3. registration source kind,
4. declared arity/signature metadata,
5. callable or provider/runtime boundary posture,
6. origin kind sufficient to distinguish built-in from registered external/function host surfaces.

### 5. SnapshotUpdate
The result of successful registration or removal.

Minimum semantic intent:
1. old snapshot ref,
2. new snapshot ref,
3. reason class:
   - registration_added
   - registration_removed
   - catalog_refresh
   - profile_gate_change
4. affected surface ids.

## Runtime Lifecycle Model
The preferred runtime lifecycle is:
1. OxFml acquires a `LibraryContextSnapshot` through the provider,
2. parse/bind/semantic-plan artifacts preserve the snapshot ref explicitly,
3. evaluation and higher-level session work use that pinned snapshot ref rather than querying hidden mutable global state,
4. registration or removal produces a new snapshot generation rather than mutating an already-pinned snapshot in place,
5. later sessions or recompilations may adopt the newer snapshot explicitly.

Working rule:
1. snapshot generations are explicit semantic facts,
2. snapshot drift must not be hidden inside evaluation,
3. replay and proving artifacts must be able to name the exact snapshot generation used.

## Dynamic Registration Direction
For runtime extension, OxFml prefers this split:
1. host or OxFml receives registration/unregistration requests,
2. OxFunc remains steward of the catalog identity and semantic descriptor shape,
3. the host remains owner of raw external invocation/runtime exposure,
4. successful registration or removal yields a new immutable `LibraryContextSnapshot`.

This allows:
1. built-ins and registered rows to share one consumable snapshot world,
2. runtime add/remove semantics without build-time regeneration dependence,
3. deterministic replay pinning to a specific snapshot generation.

Current invalidation reading:
1. if runtime registration/removal creates or removes an ordinary formula-callable surface by name, that is a bind-visible function-catalog change,
2. OxFunc should therefore publish a new immutable snapshot generation,
3. hosts and OxFml should treat affected formulas pinned to the older snapshot as stale for bind/semantic-plan purposes,
4. this is the function-catalog analogue of host-owned defined-name structural change,
5. narrower registered-external descriptor mutation used only through worksheet `CALL` / `REGISTER.ID` does not automatically imply broad bind invalidation unless a bind-visible function-name world also changed.

## Invariants
The runtime interface should preserve these invariants:
1. snapshots are immutable once published,
2. snapshot generations are monotonic and explicitly identified,
3. parse/bind/semantic-plan artifacts always know which snapshot they consumed,
4. session/evaluation work never silently switches snapshots mid-flight,
5. `surface_stable_id` remains the primary semantic identity,
6. legacy `xlf*` metadata remains compatibility metadata, not replacement identity,
7. registration source kind remains explicit for built-in versus registered surfaces,
8. hidden global mutable registry state is not required to explain semantic outcomes.

## Current Relationship To W044
`W044` remains useful and should continue.

Current OxFml reading:
1. `W044` is the best current mismatch-discovery and test-pinning artifact,
2. OxFml should keep consuming it in tests,
3. but OxFml does not want that CSV export to become the normative runtime interface boundary.

Preferred role split:
1. runtime interface:
   - normative
   - versioned
   - used by implementations
2. export artifact:
   - descriptive
   - diffable
   - test-pinnable
   - replay-correlatable

## Current First-Freeze Working Rule
OxFml now reads the latest OxFunc note as convergent on a two-track working rule:
1. consume the committed `W044` snapshot/export now for pinning, test synthesis, and semantic-plan validation,
2. model the normative runtime seam in parallel as:
   - `LibraryContextProvider`
   - immutable `LibraryContextSnapshot`
   - generation-producing registration/removal,
3. use concrete mismatches between those two tracks as the trigger for narrower seam changes,
4. do not wait for the full runtime provider shape to be coded before consuming the committed snapshot in OxFml tests and semantic-plan fixtures.

Current OxFml reading is that these are compatible rather than competing paths.

## Current Relationship To Adapter-Test Artifacts
The first OxFml-backed OxFunc integration adapter should consume the same runtime library-context direction described here.

Working rule:
1. use the committed export for fixture pinning and mismatch reports,
2. allow the adapter request to name a pinned `library_context_snapshot_ref`,
3. keep the runtime-only provider/snapshot model and the CSV/export mapping split visible in the adapter rather than letting the export shape silently become the runtime API.

Current next local owners:
1. `W049` OxFunc preparation adapter and consumer harness
2. `W050` OxFunc snapshot-pinned seam fixture families

## Current Coverage Goal
The target for this seam-hardening round is:
1. the full Excel cell-formula language as scoped in OxFml,
2. nearly all built-in functions currently covered in OxFunc,
3. a working parse -> bind -> semantic-plan -> evaluate cycle ready for implementation use,
4. explicit deferral only for the few OxFunc-local packets still intentionally deferred.

The runtime library-context interface is important because that scope is too large and too dynamic to manage honestly through build-time catalog-file ingestion alone.

## Formalization Candidates
These are good candidates for later Lean/TLA+ support:
1. snapshot immutability,
2. generation monotonicity,
3. session pinning to snapshot generation,
4. no mid-session hidden catalog drift,
5. registration/removal yielding explicit new snapshot refs,
6. stable-id preservation across export and runtime surfaces.

## Current OxFml Ask To OxFunc
For the next sync, OxFml wants OxFunc to respond to this direction directly:
1. can OxFunc support a formal runtime `LibraryContextProvider` / immutable `LibraryContextSnapshot` model,
2. which `W044` fields are already part of that runtime truth versus export-only description,
3. what minimum runtime registration descriptor OxFunc needs for add/remove support,
4. whether any currently proposed field families should move out of the runtime interface and remain export-only,
5. whether OxFunc sees any semantic reason the normative interface should remain file-export ingestion rather than runtime snapshot ingestion.

Current processed OxFunc response:
1. yes, OxFunc supports the long-term runtime `LibraryContextProvider` / immutable `LibraryContextSnapshot` direction,
2. yes, the committed snapshot/export should be used now as the immediate pinning artifact,
3. yes, registration/removal should produce explicit new snapshot generations,
4. built-in `xlf*` metadata should remain compatibility metadata rather than replacing `surface_stable_id`,
5. current first-pass callable-minimum facts may remain in contract docs for now rather than requiring immediate direct snapshot columns.

## Current OxFml First-Pass Freeze Answers
For the current successor-packet round, OxFml's first-pass answers are:
1. the runtime consumer/model shape should be cleaner runtime-only structure plus an explicit CSV/export mapping layer, not a runtime object model forced to mirror every export column,
2. the committed `W044` export remains the current pinning and mismatch artifact for tests, validation, and cross-repo correlation,
3. runtime-semantic truth should be modeled primarily through:
   - `snapshot_id`
   - `snapshot_generation`
   - source provenance
   - `surface_stable_id`
   - `entry_kind`
   - `registration_source_kind`
   - `canonical_surface_name`
   - `name_resolution_table_ref`
   - `semantic_trait_profile_ref`
   - `gating_profile_ref`
   - `metadata_status`
   - `special_interface_kind`
   - `admission_interface_kind`
   - `preparation_owner`
   - `runtime_boundary_kind`
   - `interface_contract_ref`,
4. compatibility/export description such as `xlf*` metadata, snapshot formatting details, or explanatory notes may remain export-facing side metadata as long as they do not replace the runtime-semantic fields above,
5. callable-minimum semantic facts remain acceptable in contract/interface docs for one more round rather than direct snapshot columns.

Current processed OxFunc confirmation:
1. OxFunc now also reads the seam as close enough to work toward a first freezable application seam for the already-covered scope,
2. OxFunc agrees that the remaining work is primarily:
   - typed context/query bundle freeze,
   - return-surface and publication-hint freeze,
   - runtime provider/snapshot consumer modeling,
   rather than another callable-row sufficiency round,
3. OxFunc still prefers the committed `W044` export as the immediate shared pinning artifact while the runtime-only consumer model is being shaped in parallel,
4. OxFunc still treats callable-minimum facts as semantic truth that may stay in contract/interface documentation for now rather than requiring immediate direct snapshot columns.

## Current Next-Lock Questions
The next bounded OxFml/OxFunc interface locks should therefore be:
1. the first shared typed context/query bundle for the already-covered seam-heavy rows,
2. the first shared returned-value and publication-aware split,
3. the first real OxFml consumer/model packet for the runtime `LibraryContextProvider` and immutable `LibraryContextSnapshot` direction.

## Source: `OxFml/docs/spec/formula-language/OXFML_REGISTERED_EXTERNAL_PROVIDER_AND_CALL_REGISTER_ID_BOUNDARY.md`

# OXFML_REGISTERED_EXTERNAL_PROVIDER_AND_CALL_REGISTER_ID_BOUNDARY.md

## Purpose
This note captures OxFml's current bounded runtime boundary for worksheet `CALL` / `REGISTER.ID`, host-driven external registration, and runtime unregister so the next OxFml <-> OxFunc and OxFml <-> OxCalc rounds can narrow concrete packets instead of reopening broad host/runtime theory.

## Ownership Split
Current OxFml reading:
1. OxFunc owns the built-in function/operator catalog and the semantic truth for built-in surface admission and execution.
2. OxFunc also owns runtime catalog mutation semantics for registered externals:
   - initial built-in catalog population,
   - runtime registration,
   - runtime unregister,
   - descriptor truth used by worksheet `CALL`.
3. OxFml owns formula parsing, bind classification, typed request normalization, and worksheet-visible consequence classification.
4. OxCalc or a direct host owns higher-level external-library policy, security policy, and source-specific registration initiation.
5. OxFml should therefore expose typed runtime packets that let a host funnel registration intent into OxFunc-owned catalog mutation rather than mutating catalog truth locally.

## Registration Channels
Current OxFml reading is that registered external functions may enter the OxFunc-owned catalog through three channels that all converge on the same OxFunc-owned mutation seam:
1. worksheet `REGISTER.ID`
   - initiated from formula evaluation,
   - resolved through `RegisteredExternalProvider::resolve_register_id(...)`,
   - yields descriptor truth used later by worksheet `CALL`,
2. host API registration
   - initiated by a host-side API call,
   - funneled through OxFml as a `RegisteredExternalCatalogMutationRequest::Register(...)`,
   - preserves richer host hints such as display/help text or execution profile,
3. VBA shim registration
   - initiated after host-owned VBA project loading,
   - funneled through the same OxFml mutation packet as host API registration,
   - preserves source-project, source-module, and source-procedure provenance.

Current unregister rule:
1. unregister should be the same bounded mutation seam,
2. OxFml should preserve the initiating channel and stable registration identity,
3. OxFunc should remain the owner of resulting catalog truth and snapshot-generation effects.

## Provider Separation
`RegisteredExternalProvider` should remain separate from `HostInfoProvider`.

Why:
1. `HostInfoProvider` serves typed worksheet host facts such as `INFO` and `CELL`.
2. `RegisteredExternalProvider` is about registration and external invocation lifecycle, not host-info query semantics.
3. Collapsing them would blur capability, safety, and runtime-policy boundaries that should stay explicit.

## First Bounded Typed Packet
The first bounded consumer model should carry direct typed runtime lanes:
1. `RegisterIdRequest`
2. `RegisteredExternalDescriptor`
3. `RegisteredExternalCallRequest`
4. `RegisteredExternalProvider`
5. `RegisteredExternalCatalogMutationRequest`
6. `RegisteredExternalCatalogMutationResult`
7. `RegisteredExternalCatalogController`

Current OxFml reading:
1. these are runtime request/result packets, not merely library-context snapshot metadata,
2. they should therefore cross the seam directly where the host/runtime path needs them,
3. OxFml should adopt the OxFunc-owned request/result packet types directly rather than wrapping them in a second OxFml-local vocabulary when no extra OxFml-owned fields are required,
4. the current local host and adapter path now does this for `RegisterIdRequest`, `RegisteredExternalCallRequest`, and `RegisteredExternalDescriptor`,
5. normalized worksheet `REGISTER.ID` and `CALL` packets should therefore be visible in OxFml artifacts as first-class packet facts, not only implied by provider callbacks,
6. the runtime library-context snapshot may still carry capability and profile truth about whether worksheet `CALL` / `REGISTER.ID` is admitted or gated in a given environment,
7. but the snapshot/provider layer should not be the only place where per-request registration, invocation, and unregister packets can be observed.
8. current local OxFml host support now exposes:
   - `SingleFormulaHost::recalc_with_registered_external_provider(...)`
   - `SingleFormulaHost::apply_registered_external_catalog_mutation(...)`
   as the first internal host-facing surface for that packet family.
9. current local OxFml trace and adapter artifacts also expose normalized request packets through `PreparedCall` for:
   - worksheet `REGISTER.ID`
   - worksheet `CALL` direct-library targets
   - worksheet `CALL` register-id targets

## Reference And Conversion Reading
Current OxFml reading should align worksheet `CALL` more closely with the built-in function seam:
1. OxFml already preserves reference-visible versus pre-dereferenced argument lanes for built-ins based on OxFunc-owned argument-preparation policy,
2. worksheet `CALL` should follow the same principle,
3. if a registered external target or direct `{ library, procedure, type_text }` call requires reference-sensitive or conversion-sensitive handling, OxFml should not eagerly flatten that into one generic value lane,
4. OxFunc should be able to consult registration metadata or direct call metadata to decide:
   - whether a reference argument must remain reference-visible,
   - whether a reference should be dereferenced before native invocation,
   - which general type coercions apply at the worksheet-to-external boundary.

Current implication:
1. `RegisteredExternalDescriptor` must be rich enough for OxFunc to see argument-policy-relevant registration facts,
2. the bounded runtime packet must let OxFunc obtain that descriptor for register-id targets and direct-call targets,
3. OxFml should preserve reference-visible prepared arguments where the descriptor may require them, rather than hard-coding one eager dereference rule in OxFml.
4. the same descriptor-driven reading should govern general worksheet-to-external type conversion rather than treating coercion as an OxFml-owned pre-flattening step.

## Suggested First Packet Shape
Current best-effort OxFml packet split:

### `RegisterIdRequest`
1. `library_name`
2. `procedure_name`
3. optional `type_text`
4. `caller_anchor`
5. optional `host_execution_profile`

### `RegisteredExternalDescriptor`
1. `register_id`
2. `library_name`
3. `procedure_name`
4. optional `type_text`
5. `descriptor_state`

### `RegisteredExternalCallRequest`
1. adopt OxFunc's current packet directly:
   - `target`
   - `invocation_args`
2. `target` remains:
   - `RegisterId(f64)`
   - `Direct(RegisterIdRequest)`
3. OxFml-owned caller-anchor and host execution profile facts remain adjacent host/adaptor packet facts, not reasons to fork the underlying call-request type

### `RegisteredExternalProvider`
1. `register_id`
2. `describe_registration`
3. `invoke_registered`
4. `invoke_direct`

### `RegisteredExternalCatalogMutationRequest`
1. `Register`
   - `registration_channel`
   - `register_id_request`
   - optional `stable_registration_id_hint`
   - optional `display_name_hint`
   - optional `help_text_hint`
   - optional VBA source provenance
   - optional `host_execution_profile`
2. `Unregister`
   - `registration_channel`
   - `stable_registration_id`
   - optional `host_execution_profile`

### `RegisteredExternalCatalogMutationResult`
1. `RegisterApplied`
   - `descriptor`
   - optional `host_execution_profile`
2. `UnregisterApplied`
   - `stable_registration_id`
   - optional `host_execution_profile`

### `RegisteredExternalCatalogController`
1. host-facing OxFml funnel surface that applies a typed mutation packet into OxFunc-owned catalog mutation logic,
2. not a claim that OxFml owns catalog mutation semantics,
3. intended to preserve the initiating channel while OxFunc remains the owner of catalog truth.

## Current Non-Claims
This note does not claim:
1. that the final host/coordinator safety model is frozen,
2. that the exact field names above are canonically frozen,
3. that OxFunc must consume raw native-library details or own external invocation,
4. that VBA project loading policy belongs in OxFml,
5. that runtime snapshot-generation side effects for register/unregister are already frozen beyond the current best-effort ownership split.

## Current OxFml Reply Direction
If OxFunc asks for a current best-effort answer, OxFml's reply is:
1. keep `RegisteredExternalProvider` separate from `HostInfoProvider`,
2. carry `RegisterIdRequest`, `RegisteredExternalDescriptor`, `RegisteredExternalCallRequest`, and typed catalog-mutation packets directly in the bounded runtime packet,
3. prefer direct adoption of those OxFunc-owned request/result packet types rather than a parallel OxFml wrapper vocabulary,
4. expose normalized `REGISTER.ID` and `CALL` packets in OxFml artifacts so adapter and host evidence can prove the seam shape directly,
5. let OxFunc use registration metadata or direct-call metadata to decide reference dereference and general type coercion at the worksheet `CALL` boundary,
6. treat built-in catalog truth and runtime registered-external catalog mutation as OxFunc-owned,
7. treat host API registration and VBA shim registration as host-initiated channels that OxFml funnels into the same OxFunc-owned mutation seam,
8. keep the library-context snapshot/provider lane for admission/profile truth rather than as the sole carrier of live registration/invocation packets,
9. keep worksheet `CALL` runtime above OxFunc except for request normalization, descriptor-driven argument handling, and worksheet-visible result projection unless concrete evidence forces a narrower split.

## Source: `OxFml/docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`

# OxFml Artifact Identities and Version Keys

## 1. Purpose
This document defines the current OxFml vocabulary for artifact identity, versioning, fingerprints, and runtime handles.

The immediate goal is not to lock exact encodings.
The goal is to prevent semantic drift by making the categories explicit before implementation work begins.

This document should be read together with:
1. `OXFML_SYSTEM_DESIGN.md`
2. `OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
3. `formula-language/OXFML_FORMULA_ENGINE_ARCHITECTURE.md`
4. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`

## 2. Working Rule
OxFml should not overload one token to mean all of:
1. logical identity,
2. version identity,
3. content fingerprint,
4. runtime residency handle,
5. fence eligibility.

These are different categories and should stay different even when some implementations encode them compactly.

## 3. Identity Categories
The canonical categories are:

1. stable logical identity
   - "which logical formula/artifact is this?"
2. version key
   - "which declared revision of that artifact is this?"
3. content fingerprint
   - "what exact semantic or syntactic payload does this artifact currently have?"
4. runtime handle
   - "where is a currently resident copy of this artifact stored?"
5. fence tuple member
   - "which keys must match before an operational step may publish?"

Not every artifact family needs all five categories, but the distinction remains mandatory.

## 4. Formula-Level Vocabulary
### 4.1 `formula_stable_id`
`formula_stable_id` is the stable logical identity of a formula-bearing locus as exposed to OxFml.

Working meaning:
1. it identifies the logical formula slot under the host/coordinator model,
2. it survives ordinary formula-text edits,
3. it may survive some structure edits if the enclosing host preserves locus identity,
4. it is not a content hash.

Open detail:
1. whether this identity is cell-based, node-based, or host-object-based depends on the enclosing host model.

### 4.2 `formula_text_version`
`formula_text_version` is the declared version key for entered/stored formula text associated with a `formula_stable_id`.

Working meaning:
1. it changes when the formula source text changes,
2. it does not need to change when only workbook structure changes,
3. it is distinct from any content hash or parse-tree key.

### 4.3 `formula_token`
`formula_token` is the evaluator-facing fence token for the current formula payload.

Working meaning:
1. it is the token used in FEC/F3E fence checks,
2. it must change whenever a publish-relevant formula payload change would invalidate a prepared evaluation,
3. it may be derived from one or more lower-level version keys,
4. it should not be treated as the stable logical identity of the formula.

## 5. Syntax Artifact Vocabulary
### 5.1 `green_tree_key`
`green_tree_key` identifies a specific immutable green-tree root value.

Working meaning:
1. it corresponds to one exact full-fidelity syntax payload,
2. unchanged subtrees may be structurally reused across different `green_tree_key` roots,
3. it may be implemented as an interning key, content fingerprint, or explicit versioned object id.

### 5.2 `green_tree_fingerprint`
`green_tree_fingerprint` is the content fingerprint of a green-tree root.

Working meaning:
1. it reflects exact full-fidelity syntax content,
2. it is useful for replay, deduplication, and integrity checks,
3. it must not replace `formula_stable_id` or `formula_text_version`.

### 5.3 `red_view_key`
`red_view_key` identifies a contextual view over a green tree.

Working meaning:
1. it depends on at least the green tree plus contextual projection inputs,
2. it is normally ephemeral,
3. it should not be treated as durable semantic truth.

## 6. Structure and Bind Vocabulary
### 6.1 `structure_context_version`
`structure_context_version` is the declared version key for workbook structure relevant to binding.

Examples of contributors:
1. name scopes,
2. sheet/workbook identity graph,
3. table metadata,
4. caller anchor movement,
5. profile-gated grammar or feature enablement where binding is affected.
6. defined-name world changes that affect visible name resolution.

### 6.2 `bind_input_key`
`bind_input_key` is the conceptual key of one bind attempt.

Minimum contributors:
1. `formula_stable_id`
2. the current formula syntax identity
3. `structure_context_version`
4. `profile_version`

### 6.3 `bind_hash`
`bind_hash` is the content fingerprint of the bind result used for seam fencing.

Working meaning:
1. it changes when bound meaning changes,
2. it is stronger than a plain text-version key,
3. it may remain stable across some non-semantic changes if the binding result is identical,
4. it is not itself the stable identity of the bound formula.

### 6.4 `bound_formula_id`
`bound_formula_id` is the stable identity of a bound artifact when such an identity is needed by a repository-style implementation.

Working meaning:
1. it is optional in a purely stateless API,
2. it becomes useful in repository or cache-oriented implementations,
3. if present, it must remain distinct from `bind_hash`.

## 7. Semantic-Plan Vocabulary
### 7.1 `semantic_plan_key`
`semantic_plan_key` identifies one semantic-plan payload.

Minimum contributors:
1. `bind_hash`
2. relevant OxFunc catalog/profile information
3. evaluation-mode-affecting profile/version information

### 7.2 `semantic_plan_fingerprint`
`semantic_plan_fingerprint` is the content fingerprint of the compiled evaluator-facing plan.

Working meaning:
1. it is useful for replay and cache equivalence,
2. it must not be mistaken for a runtime handle.

## 8. Evaluation and Session Vocabulary
### 8.1 `snapshot_epoch`
`snapshot_epoch` is the version key for the workbook snapshot visible to evaluation.

Working meaning:
1. it changes when publish-relevant workbook state changes,
2. it is a fence input for evaluator sessions,
3. it is coordinator-facing in integrated mode.

Related rule:
1. `snapshot_epoch` is not the same thing as function-catalog snapshot generation,
2. function-catalog changes that alter bind-visible function-name resolution should instead be expressed through the pinned runtime `LibraryContextSnapshotRef`,
3. hosts/coordinators should keep workbook-structure versioning and function-catalog versioning distinct even when a single implementation update causes both to change.

### 8.2 `profile_version`
`profile_version` is the declared version key for enabled semantics/features/profile rules relevant to parsing, binding, or evaluation.

### 8.3 `capability_view_key`
`capability_view_key` identifies the evaluated capability surface for one session.

Working meaning:
1. it should change when capability-affecting rules or grants change,
2. it is distinct from `profile_version`,
3. it may contribute to commit fencing.

### 8.4 `session_id`
`session_id` is the runtime identity of an evaluator session.

Working meaning:
1. it is operational, not canonical semantic truth,
2. it may be short-lived,
3. it must still be traceable and replay-correlatable.

## 9. Overlay Vocabulary
### 9.1 `overlay_family`
The baseline overlay families are:
1. dependency overlay,
2. spill overlay,
3. format dependency overlay.

### 9.2 `overlay_scope_key`
`overlay_scope_key` identifies the fence scope under which an overlay entry is valid.

Minimum contributors:
1. `formula_stable_id`
2. `snapshot_epoch`
3. `bind_hash`
4. `profile_version`
5. overlay family

Additional contributors may be required for capability-sensitive lanes.

### 9.3 `overlay_entry_id`
`overlay_entry_id` is the runtime identity of one overlay record.

Working meaning:
1. it may be local to a repository or session store,
2. it is not a substitute for the overlay scope key,
3. replay should be expressible without depending on opaque local ids.

## 10. Publication Vocabulary
### 10.1 `commit_attempt_id`
`commit_attempt_id` identifies one publish attempt.

Working meaning:
1. it is useful for trace correlation,
2. it is not itself proof of publish success.

### 10.2 `commit_bundle_fingerprint`
`commit_bundle_fingerprint` is the fingerprint of one atomic publishable bundle.

Working meaning:
1. it is useful for replay equivalence and witness packs,
2. it must reflect the full published semantic payload, not just one delta family.

### 10.3 `reject_record_fingerprint`
`reject_record_fingerprint` is the fingerprint of a typed reject payload.

Working meaning:
1. it supports replay equivalence,
2. it does not replace the typed reject code and context fields themselves.

## 11. Minimum FEC/F3E Fence Tuple
The current minimum seam fence tuple remains:
1. `formula_stable_id`
2. `formula_token`
3. `snapshot_epoch`
4. `bind_hash`
5. `profile_version`

This document adds vocabulary around that tuple; it does not replace it.

Open question:
1. whether `capability_view_key` should become an explicit first-class fence member rather than a separately checked requirement.

## 12. Runtime Handles vs Canonical Keys
Repository-style implementations may introduce:
1. parse repository handles,
2. bound artifact handles,
3. semantic plan handles,
4. overlay store handles,
5. session handles.

Working rule:
1. runtime handles are allowed,
2. canonical replay and formal reasoning must not depend on opaque handles alone,
3. every publish-relevant outcome must be explainable in terms of canonical keys and explicit inputs.

## 13. Formalization Implications
Lean-oriented posture:
1. stable identities, version keys, and fingerprints should be modeled as distinct types or tagged aliases.

TLA+-oriented posture:
1. session ids and runtime handles may exist in the state machine,
2. publish eligibility should be defined in terms of fence members and explicit artifact relations, not accidental store addresses.

Replay posture:
1. replay packs should capture canonical keys and fingerprints,
2. local runtime handles may appear only as auxiliary debugging metadata.

## 14. Replay-Preserved Identity Rules
The Replay appliance projection for OxFml must preserve identity categories explicitly rather than compressing them into one bundle-local token.

Replay-preservation rules:
1. stable ids remain stable ids
   - `formula_stable_id` remains the logical formula-locus identity,
   - it may appear in replay correlation fields,
   - it may not be substituted by `session_id`, `commit_attempt_id`, or sidecar hash.
2. version keys remain version keys
   - `formula_text_version`, `structure_context_version`, `snapshot_epoch`, and `profile_version` remain separate version contexts,
   - replay normalization may add bundle-level configuration refs,
   - replay normalization may not reinterpret version keys as fingerprints.
3. content fingerprints remain fingerprints
   - `green_tree_fingerprint`, `bind_hash`, `semantic_plan_fingerprint`, `commit_bundle_fingerprint`, and `reject_record_fingerprint` remain content-equivalence markers,
   - fingerprints support replay equivalence and sidecar integrity,
   - fingerprints do not replace logical ids or version keys.
4. runtime handles remain auxiliary
   - `session_id`, repository handles, and overlay entry ids remain operational correlation aids,
   - replay bundles may preserve them when they are causally relevant,
   - replay-valid interpretation must remain possible without depending on opaque process-local handles alone.
5. fence-relevant keys remain explicit
   - at minimum `formula_stable_id`, `formula_token`, `snapshot_epoch`, `bind_hash`, and `profile_version` remain replay-visible for publish-safety reasoning,
   - `capability_view_key` must be preserved where present even while its final fence status remains open.
6. publication correlation ids remain explicit
   - `session_id` and `commit_attempt_id` are replay-correlatable ids and may not be folded into one generic run id,
   - replay bundles must preserve the distinction between candidate lineage and commit lineage.
7. configuration and profile context is additive, not substitutive
   - replay bundles may add capture mode, adapter version, and configuration fingerprint refs,
   - those additive refs do not replace `profile_version` or other OxFml semantic keys.

Current replay-governance pin:
1. registry-family pins for normalized replay governance are currently anchored to `oxfml.local.registry_pin.foundation_handoff_20260315_pass01`,
2. that pin governs registry interpretation, not OxFml artifact meaning.

## 15. Open Decisions
The following remain open:
1. exact derivation rule for `formula_token`,
2. whether `green_tree_key` and `green_tree_fingerprint` collapse in practice,
3. whether repository-style implementations expose `bound_formula_id` and `semantic_plan_key` publicly,
4. whether `structure_context_version` is global, partitioned, or lane-specific,
5. whether overlay scope must include capability-view identity explicitly,
6. final names for some of these keys once implementation starts.

## 16. Working Rule
Until implementation begins:
1. use this document's distinctions in prose specs,
2. avoid introducing new overloaded identity terms without defining their category,
3. prefer "stable id", "version key", "fingerprint", and "runtime handle" as separate terms.

## Source: `OxFml/docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`

# OxFml Canonical Artifact Shapes

## 1. Purpose
This document defines the current canonical field surfaces for the main OxFml artifacts.

The goal is to stabilize:
1. what information each artifact family must carry,
2. which distinctions are canonical versus optional,
3. where later implementation work may add internal detail without changing semantics.

This document does not freeze exact language-level types or wire encodings.
It defines the semantic shape that implementations and later formal artifacts should preserve.

This document should be read together with:
1. `OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
2. `OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
3. `formula-language/OXFML_FORMULA_ENGINE_ARCHITECTURE.md`
4. `formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`
5. `OXFML_MINIMUM_SEAM_SCHEMAS.md`
6. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`
7. `OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`

## 2. Shape Rule
Each canonical artifact shape should separate:
1. identity/version metadata,
2. semantic payload,
3. diagnostics or evidence metadata,
4. optional implementation-only residency data.

Only the first three belong in the canonical semantic surface.

## 3. Formula Source Record
The formula source record captures the worksheet-surface formula input state before and after normalization.

Minimum fields:
1. `formula_stable_id`
2. `formula_text_version`
3. `entered_formula_text`
4. optional `stored_formula_text`
5. source span or host-locus metadata
6. parse-time diagnostics set

Working rule:
1. entered and stored text must remain distinguishable when the host surface distinguishes them,
2. this record is the textual entry point for parse and replay.

## 4. Green Tree Root
The canonical green-tree root should carry at least:
1. `green_tree_key`
2. optional `green_tree_fingerprint`
3. root syntax kind
4. full-fidelity token/trivia tree
5. recovery/error nodes where present
6. parse diagnostics

Canonical property:
1. no workbook-specific or caller-specific context belongs in the green tree.

## 5. BoundFormula
`BoundFormula` is the canonical binding output for one formula under one structure/profile context.

Minimum fields:
1. `formula_stable_id`
2. syntax identity reference
   - at least the relevant green-tree/root identity
3. `structure_context_version`
4. `profile_version`
5. optional `bound_formula_id`
6. `bind_hash`
7. bound expression root
8. normalized reference set
9. dependency seed set
10. unresolved-reference records
11. capability requirements
12. bind diagnostics

Bound expression root should preserve:
1. operator/function structure,
2. normalized names and references,
3. caller-context-dependent bindings where they are already resolved at bind stage,
4. explicit unresolved nodes where binding cannot finish honestly.

Canonical rule:
1. a formula edit may still be rejected before `BoundFormula` exists when the submitted text cannot honestly enter the canonical artifact ladder,
2. once a `BoundFormula` exists, unresolved-name or unresolved-bind facts are preserved as artifact truth rather than being silently converted into edit rejection.

What does not belong in `BoundFormula`:
1. evaluator session state,
2. mutable overlay state,
3. commit/publication decisions.

## 6. SemanticPlan
`SemanticPlan` is the evaluator-facing artifact compiled from `BoundFormula` plus OxFunc metadata.

Minimum fields:
1. semantic-plan identity
   - `semantic_plan_key`
   - optional `semantic_plan_fingerprint`
2. `formula_stable_id`
3. `bind_hash`
4. relevant library-context snapshot identity
5. relevant OxFunc catalog/profile identity
6. operator/function dispatch graph
7. evaluation-mode requirements
8. reduction policy requirements
9. reference-preservation requirements
10. helper-environment profile
   - at minimum whether `LET`, `LAMBDA`, and helper invocation are present
   - and whether lexical helper capture is required by the formula shape
11. overlay participation flags
12. locale/format service requirements
13. execution and scheduling profile requirements
14. availability/gating summary where formula admission or runtime capability depends on catalog/profile/provider state
15. fast-path classification
16. semantic diagnostics or unsupported-lane markers

Current local floor:
1. `library_context_snapshot_ref` records the consumed external library-context snapshot identity when present,
2. `availability_summaries` preserve parse/bind, semantic-plan, runtime-capability, and post-dispatch/provider states per surfaced function lane,
3. `availability_summaries` now also preserve a smaller concrete per-surface identity floor:
   - `surface_stable_id`
   - `name_resolution_table_ref`
   - `semantic_trait_profile_ref`
   - `gating_profile_ref`

Canonical property:
1. `SemanticPlan` explains how evaluation should proceed,
2. it does not itself contain runtime session state,
3. it may carry library-context and availability truth needed to preserve semantic admission distinctions without owning mutable registry state.
4. it must preserve the distinction between:
   - edit rejection before artifact adoption,
   - accepted formula text with bind-time unresolved-name or unsupported-lane diagnostics,
   - later runtime capability denial or provider-failure outcomes.

## 7. PreparedArgument
Prepared arguments are the canonical OxFml-to-OxFunc call-shape units.

Minimum fields:
1. argument ordinal or named-position identity
2. `structure_class`
3. `source_class`
4. `value_view`
5. optional `reference_identity`
6. `evaluation_mode`
7. `blankness_class`
8. `caller_context`
9. optional provenance metadata
10. preparation diagnostics if the argument is representable but degraded

Canonical property:
1. prepared arguments must carry enough structure for OxFunc to apply Excel-compatible function semantics without reconstructing lost provenance.

## 8. PreparedCall
`PreparedCall` is the canonical evaluator-to-function dispatch package.

Minimum fields:
1. function identity
2. function profile/trait reference from OxFunc
3. prepared argument list
4. call-site caller context
5. locale/date-system/format service context
6. optional host-query capability view
7. evaluation mode summary for the call
8. optional replay correlation metadata

Working rule:
1. `PreparedCall` may be materialized eagerly or lazily,
2. its semantic content must remain reconstructible for replay.

## 9. PreparedResult
Prepared results are the canonical function-to-evaluator result units.

Minimum fields:
1. `result_class`
2. `structure_class`
3. `payload`
4. optional `reference_identity`
5. optional `format_hint`
6. optional `publication_hint`
7. optional typed callable carrier
   - at minimum origin kind, invocation model, capture mode, and arity
8. optional callable-value profile and structured callable detail
9. optional provenance/derivation marker
10. result diagnostics if the result carries degraded or version-scoped semantics

Canonical property:
1. prepared results must distinguish scalar, array, reference, and error outcomes without collapsing them prematurely.
2. callable helper values may remain semantically first-class even when publication carriers remain narrower than the full callable transport problem.
3. callable capture detail should reflect exact free-helper capture when OxFml can know it, not merely every helper symbol visible in the surrounding environment.
4. the current callable floor may also be preserved through defined-name bindings when OxFml has adopted a callable value into name context, but that does not by itself settle wider publication or transport policy.

## 10. Evaluator Facts
Evaluator facts are the intermediate execution facts that later feed the seam.

Minimum field families:
1. dynamic reference discoveries
2. spill discoveries and conflicts
3. format dependency discoveries
4. capability-sensitive execution observations
5. host-query execution observations where host facts or denials affect replay or publication
6. trace correlation metadata

Working rule:
1. evaluator facts are inputs to commit-bundle construction,
2. they are not themselves scheduler policy,
3. they may still surface scheduler-relevant execution facts where coordinator correctness depends on them.

## 11. AcceptedCandidateResult
`AcceptedCandidateResult` is the canonical non-published accepted evaluator outcome.

It is the candidate payload presented for coordinator-controlled commit acceptance.

Minimum fields:
1. identity/correlation
   - `formula_stable_id`
   - optional `session_id`
   - optional candidate-result fingerprint
   - fence tuple snapshot
   - optional `capability_view_key`
2. candidate value/shape/topology payloads
   - `value_delta`
   - `shape_delta`
   - `topology_delta`
3. optional `format_delta`
4. optional `display_delta`
5. optional spill-event set
6. surfaced evaluator facts needed for coordinator correctness where not already derivable from the deltas
7. trace fragment or trace correlation metadata

Canonical property:
1. `AcceptedCandidateResult` is structured evaluator output, not publication,
2. it must be rich enough for one coherent atomic publication if accepted,
3. it must carry enough compatibility basis for deterministic accept-versus-reject decisions.

## 12. CommitBundle
`CommitBundle` is the canonical published seam artifact produced when an `AcceptedCandidateResult` is accepted for publication.

Minimum fields:
1. identity/correlation
   - `formula_stable_id`
   - `commit_attempt_id`
   - fence tuple snapshot
   - optional `commit_bundle_fingerprint`
2. `value_delta`
3. `shape_delta`
4. `topology_delta`
5. optional `format_delta`
6. optional `display_delta`
7. optional spill-event set
8. trace fragment or trace correlation metadata

`value_delta` should contain:
1. the publishable value payload changes,
2. error payload changes where the worksheet-visible value is an error.

`shape_delta` should contain:
1. spill or shape-visible occupancy changes,
2. array shape changes that affect worksheet visibility.

`topology_delta` should contain:
1. dependency and invalidation-relevant evaluator facts,
2. dynamic-reference facts,
3. typed dependency consequence facts for additions, removals, or reclassifications,
4. other coordinator-consumable facts that are not scheduler policy.

What does not belong in `CommitBundle`:
1. scheduler decisions,
2. opaque host-only side effects,
3. untyped free-form error strings as the sole explanation of behavior.

## 13. RejectRecord
`RejectRecord` is the canonical non-publishing seam artifact on rejected evaluation or commit.

Minimum fields:
1. identity/correlation
   - `formula_stable_id`
   - optional `session_id`
   - optional `commit_attempt_id`
   - optional `reject_record_fingerprint`
2. `reject_code`
3. typed reject context
4. fence snapshot or mismatch detail where relevant
5. trace correlation metadata
6. optional diagnostics/supporting evidence fields

Canonical property:
1. `RejectRecord` must be machine-typed and replay-stable,
2. it must not be only a message string,
3. fence or capability incompatibility must be expressible without ambiguity.

## 14. Trace Event Shape
The seam trace event shape should minimally carry:
1. schema/version id
2. event kind
3. formula/session/attempt correlation ids
4. relevant fence members or references to them
5. event payload
6. event ordering metadata

Canonical property:
1. trace events must be sufficient to correlate execution with either a `CommitBundle` or a `RejectRecord`.

## 15. Shape Relationship Summary
The canonical artifact flow is:
1. `FormulaSourceRecord`
2. `GreenTreeRoot`
3. `BoundFormula`
4. `SemanticPlan`
5. `PreparedCall`
6. `PreparedResult`
7. evaluator facts
8. `AcceptedCandidateResult`
9. `CommitBundle` or `RejectRecord`

Not every implementation needs to persist every artifact.
Every implementation must preserve the semantic distinctions these shapes require.

## 16. Replay Bundle Projection
The Replay appliance projects OxFml artifacts into bundle objects without replacing their meaning.

Projection guidance:
1. `FormulaSourceRecord`
   - scenario input record plus source-artifact refs
2. `GreenTreeRoot`
   - source-artifact ref or sidecar-backed syntax payload
3. `BoundFormula`
   - source-artifact ref plus bind identity/fingerprint fields
4. `SemanticPlan`
   - source-artifact ref plus execution-profile and helper-profile summary
5. `PreparedCall`
   - normalized replay event payload or sidecar-backed prepared-call packet
6. `PreparedResult`
   - candidate-facing event payload or sidecar-backed prepared-result packet
7. evaluator facts
   - normalized effect events, fact refs, or topology delta payload
8. `AcceptedCandidateResult`
   - normalized `candidate.*` events plus candidate-view material
9. `CommitBundle`
   - normalized `publication.*` events plus published-view material
10. `RejectRecord`
   - normalized `reject.*` events plus reject-set material
11. promotion-readiness and retained-witness material
   - replay-family refs, lifecycle refs, and reduction-manifest lineage remain additive sidecars rather than replacements for OxFml artifact meaning

Projection rule:
1. source schema ids remain preserved,
2. source artifact refs remain auditable,
3. normalized replay family mapping is additive only.

## 17. Sidecar And Large Artifact Rules
Large OxFml artifact bodies may be sidecar-backed in replay bundles.

Initial sidecar-capable families:
1. full-fidelity green trees,
2. full `BoundFormula` bodies,
3. full `SemanticPlan` bodies,
4. large `PreparedCall` or `PreparedResult` packets,
5. candidate or reject payload bodies that exceed inline replay practicality.

Sidecar rules:
1. sidecars must preserve content fingerprint and source schema id,
2. replay bundles must remain able to distinguish inline, sidecar-backed, missing-explicit, and opaque-preserved payload states,
3. sidecar externalization may not erase replay-causal keys needed for candidate, commit, reject, or effect interpretation.

## 18. Witness Reduction-Unit Anchors
The replay rollout requires stable anchor points for future witness distillation.

Current OxFml local-only reduction-unit anchors are:
1. `oxfml.local.reduction_unit.fixture_case`
2. `oxfml.local.reduction_unit.lifecycle_block`
3. `oxfml.local.reduction_unit.candidate_attempt`
4. `oxfml.local.reduction_unit.commit_attempt`
5. `oxfml.local.reduction_unit.reject_context_slice`
6. `oxfml.local.reduction_unit.effect_slice`
7. `oxfml.local.reduction_unit.artifact_sidecar`

Anchor rules:
1. these are OxFml-local planning ids, not Foundation registry ids,
2. candidate and commit anchors must preserve candidate-versus-publication lineage,
3. reject-context and effect-slice anchors must preserve typed family identity and causal lifecycle phase,
4. sidecar reduction may prune large artifact bodies only where replay closure remains intact.

## 19. Open Decisions
The following remain open:
1. exact field naming once implementation starts,
2. whether some identity/fingerprint fields are carried directly or via nested metadata objects,
3. the minimum provenance metadata for prepared arguments/results,
4. exact delta substructure inside `value_delta`, `shape_delta`, `topology_delta`, `format_delta`, and `display_delta`,
5. whether some evaluator facts are persisted separately from `CommitBundle`.

## 20. Working Rule
Until implementation begins:
1. use these shapes as the semantic baseline,
2. add fields only when they preserve rather than blur distinctions,
3. do not remove a field category without updating the boundary and replay rationale.

Exact delta/effect/reject/trace family taxonomies are defined in:
1. `OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`

The current minimum schema objects for those families are defined in:
1. `OXFML_MINIMUM_SEAM_SCHEMAS.md`

## Source: `OxFml/docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`

# OxFml Delta, Effect, Trace, and Reject Taxonomies

## 1. Purpose
This document defines the current canonical taxonomy layer for:
1. seam delta families,
2. evaluator-fact families,
3. reject-context families,
4. trace-event families.

The artifact-shapes document defines which containers exist.
This document defines the expected semantic contents of the most important families inside those containers.

This document should be read together with:
1. `OXFML_CANONICAL_ARTIFACT_SHAPES.md`
2. `OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
3. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`
4. `fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`

## 2. Working Rule
The seam must not use broad buckets like "other topology info" or "generic reject detail" as a substitute for typed taxonomies.

Until implementation begins:
1. taxonomy families should be explicit,
2. exact field names may remain open,
3. new families should be added only when replay or coordinator correctness requires them.

## 3. Delta Family Taxonomy
### 3.1 `value_delta`
`value_delta` carries worksheet-visible value consequences.

The current minimum families are:
1. scalar value replacement
2. error value replacement
3. array payload publication where the value consequence is visible at the formula locus
4. blankness transition where worksheet-visible cell value semantics change

`value_delta` must not be used for:
1. dependency-only changes,
2. scheduler policy,
3. purely display-only formatting effects.

### 3.2 `shape_delta`
`shape_delta` carries occupancy and shape consequences.

The current minimum families are:
1. spill extent establishment
2. spill extent shrink/expand
3. spill occupancy clearance
4. blocked-shape state at intended spill targets
5. array-shape publication changes that affect visible occupied region

### 3.3 `topology_delta`
`topology_delta` carries coordinator-consumable evaluator facts and dependency consequences.

The current minimum families are:
1. dynamic dependency additions
2. dynamic dependency removals
3. dependency classification changes
4. typed dependency consequence facts that explain why additions or reclassifications were surfaced
5. runtime-discovered reference target facts
6. invalidation-relevant spill facts
7. format-dependency facts that affect future invalidation behavior
8. capability-sensitive execution facts when they alter coordinator interpretation

`topology_delta` must not contain:
1. global scheduling decisions,
2. fairness policy,
3. coordinator-local publication heuristics.

### 3.4 `format_delta`
`format_delta` carries semantic formatting consequences that must cross the seam.

The current minimum families are:
1. format recommendation or adjustment linked to formula semantics
2. semantic format changes required for stable downstream evaluation meaning

Open boundary:
1. the exact split between `format_delta` and prepared-result `format_hint` remains profile-sensitive.
2. the current local floor derives `format_delta` from explicit prepared-result `format_hint` only when the hint is treated as seam-significant publication evidence.

### 3.5 `display_delta`
`display_delta` is optional and only for publication-surface consequences that are explicit seam obligations.

Current rule:
1. if a display-facing consequence is purely renderer/UI-local, it does not belong here,
2. if a display-facing consequence is required for evaluator/publication semantics, it may appear here,
3. the current local floor derives `display_delta` from prepared-result `publication_hint` only when the publication surface itself is seam-significant.

## 4. Evaluator-Fact Taxonomy
Evaluator facts are pre-publication execution observations that may feed `topology_delta`, typed event sets, or trace payloads.

### 4.1 Dynamic Reference Facts
Current minimum families:
1. discovered target region identity
2. discovered target shape/classification
3. failure-to-resolve dynamic target
4. change in discovered target compared with previously known shape

### 4.2 Spill Facts
Current minimum families:
1. intended spill anchor and intended extent
2. spill blocked reason and blocking loci
3. spill takeover confirmation
4. spill clearance confirmation
5. spill reconfiguration under changed result shape

### 4.3 Format Dependency Facts
Current minimum families:
1. formula depends on semantic format state
2. formula depends on locale/date-system-sensitive rendering/parsing context
3. format-dependency token/classification needed for later invalidation

### 4.4 Capability-Sensitive Execution Facts
Current minimum families:
1. feature/capability path exercised
2. capability-denied path classification
3. fallback path chosen due to capability profile
4. async-coupled runtime transport requirement
5. scheduler-visible serial or single-flight restriction that remains evaluator/runtime fact rather than coordinator policy

### 4.5 Dependency Consequence Facts
Current minimum families:
1. semantic-diagnostic-backed dependency addition
2. dynamic-reference-deferred reclassification
3. retained topology explanation needed for replay or publication interpretation

### 4.6 Fact Relationship Rule
Evaluator facts:
1. may remain local if they have no coordinator or replay consequence,
2. must be surfaced or made derivable when they affect accept/reject/publication correctness,
3. must remain typed rather than collapsed into free-form diagnostics.

## 5. Spill Event Taxonomy
The canonical spill-event families remain:
1. `SpillTakeover`
2. `SpillClearance`
3. `SpillBlocked`

Required typed context for every spill event should include at least:
1. anchor identity
2. intended extent or affected extent
3. blocking or cleared loci where applicable
4. correlation to candidate result / commit attempt

## 6. Reject Taxonomy Refinement
The seam already defines top-level reject families.
This section defines the current minimum typed-context families inside `RejectRecord`.

### 6.1 Fence Mismatch Context
Minimum context:
1. mismatched fence member kind
2. expected versus observed values where capturable
3. stale-versus-incompatible classification

### 6.2 Capability Denial Context
Minimum context:
1. denied capability or profile gate
2. phase where denial occurred
3. whether fallback existed

### 6.3 Session Expiry / Abort Context
Minimum context:
1. expiry versus explicit abort
2. affected session identity
3. whether evaluation had already produced a candidate result

### 6.4 Bind Mismatch Context
Minimum context:
1. relevant bind artifact identity/fingerprint
2. mismatch classification
3. whether the mismatch was discovered before or during commit

### 6.5 Structural Conflict Context
Minimum context:
1. conflicting structural locus or shape
2. conflict kind
3. whether the conflict is recoverable by retry

### 6.6 Dynamic-Reference Failure Context
Minimum context:
1. failing dynamic-reference family
2. resolution failure class
3. any partial target identity that was available

### 6.7 Resource / Invariant Context
Minimum context:
1. resource exhaustion versus invariant violation classification
2. replay-safe machine detail
3. optional implementation-only debug detail kept out of canonical minimums

## 7. Trace Event Taxonomy
Trace events must be sufficient to replay and diagnose the seam lifecycle without confusing candidate construction with publication.

### 7.1 Lifecycle Events
Current minimum families:
1. `PrepareStarted`
2. `PrepareRejected`
3. `SessionOpened`
4. `CapabilityViewResolved`
5. `ExecuteStarted`
6. `ExecuteCompleted`

### 7.2 Candidate / Commit Events
Current minimum families:
1. `AcceptedCandidateResultBuilt`
2. `CommitStarted`
3. `CommitAccepted`
4. `CommitRejected`

### 7.3 Reject Events
Current minimum families:
1. `RejectIssued`
2. `FenceMismatchRejected`
3. `CapabilityDeniedRejected`
4. `SessionExpiredRejected`

This does not mean each family must be a separate top-level enum variant in every implementation.
It means replay must be able to distinguish them.

### 7.4 Effect and Overlay Events
Current minimum families:
1. `DynamicReferenceDiscovered`
2. `SpillEventObserved`
3. `FormatDependencyObserved`
4. `OverlayRegistered`
5. `OverlayEvicted`
6. `RuntimeAsyncOverlayRegistered`
7. `PublicationSurfaceOverlayRegistered`

### 7.5 Correlation Rule
Every trace event should be able to correlate to some combination of:
1. formula identity
2. session identity
3. candidate-result identity or fingerprint
4. commit attempt identity
5. reject identity or fingerprint

## 8. Candidate-vs-Published Consequence Rule
When a candidate result exists and commit later rejects it:
1. trace and reject artifacts must show that a candidate existed,
2. no published bundle is emitted,
3. the failure reason must remain machine-typed and replayable.

## 9. Testing and Replay Implications
The minimum replay families implied by this taxonomy are:
1. candidate-result built then commit accepted
2. candidate-result built then commit rejected on fence mismatch
3. execution rejected before candidate-result construction
4. spill blocked / cleared / reconfigured with surfaced effects
5. format dependency discovery affecting later invalidation behavior

## 10. Replay Appliance Mapping
Foundation replay registries provide normalized mismatch, predicate, and severity families.
OxFml local taxonomy remains authoritative for source meaning and source family membership.

### 10.1 Predicate-Family Mapping
The current additive predicate mapping is:
1. typed reject-family preservation
   - normalized predicate: `pred.reject.family_present`
   - local source authority: `RejectRecord.reject_code` plus typed reject-context family
2. no-publish reason preservation
   - normalized predicate: `pred.publication.not_published_reason`
   - local source authority: candidate-versus-commit boundary plus typed reject context
3. mismatch-presence preservation over effect or topology surfaces
   - normalized predicate: `pred.diff.mismatch_present`
   - local source authority: typed delta, fact, and trace families in this document
4. invariant or failure preservation where resource or machine rules matter
   - normalized predicate: `pred.invariant.failed`
   - local source authority: `ResourceInvariantContext`

### 10.2 Mismatch-Family Mapping
The current additive mismatch mapping is:
1. candidate or commit value/shape/view consequence mismatch
   - normalized mismatch: `mm.result.state` and/or `mm.view.value`
2. typed reject-family or reject-context mismatch
   - normalized mismatch: `mm.reject.kind`
3. lifecycle or effect trace mismatch
   - normalized mismatch: `mm.trace.event`
4. missing required replay sidecar payload where semantic surface is otherwise preserved
   - normalized mismatch: `mm.sidecar.payload`
5. missing required capability, lifecycle, or registry binding used for replay governance
   - normalized mismatch: `mm.evidence.binding`

Mapping rule:
1. normalized mismatch ids classify cross-lane comparison surface,
2. local taxonomy ids still determine what the underlying OxFml event, reject, or effect means.

### 10.3 Severity Alignment
The current additive severity alignment is:
1. `sev.semantic`
   - value, shape, topology, reject, candidate, commit, and required effect mismatches
2. `sev.coverage`
   - missing lifecycle, registry, or required evidence bindings that affect assurance or promotion claims
3. `sev.instrumentation`
   - missing optional enrichments, sidecars, or opaque-preserved payloads that do not alter replay truth
4. `sev.informational`
   - optional explanation-text or advisory projection differences only

### 10.4 Authority Rule
Normalized replay mappings:
1. are additive and versioned,
2. may be used for shared diff and explain tooling,
3. may not silently replace OxFml taxonomy ids or typed family meanings.

## 11. Open Decisions
The following remain open:
1. exact nested payload structure inside each delta family
2. whether some evaluator facts appear only in `topology_delta` versus separate fact sets
3. exact trace event naming and granularity
4. whether some reject-context families should be split further for Stage 2 concurrency work

## 12. Working Rule
Until implementation begins:
1. use these taxonomies as the semantic baseline,
2. keep publication-facing consequences typed,
3. defer only where exercised evidence is genuinely still missing.

## Source: `OxFml/docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`

# OxFml DNA OneCalc Host Policy Baseline

## 1. Purpose
This document defines the current OxFml-owned policy baseline for future DNA OneCalc host consumption.

It exists to separate:
1. OxFml semantic authority,
2. the current single-formula proving-host floor,
3. later DNA OneCalc host specification work.

Status rule:
1. this document remains the reduced-profile DNA OneCalc host-policy companion,
2. `OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md` is now the primary host/runtime coordination packet,
3. this document should be read as a narrower downstream-host policy supplement rather than a full host/runtime contract.

Read together with:
1. `OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
2. `OXFML_EMPIRICAL_PACK_PLANNING.md`
3. `fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
4. `OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`

## 2. Authority Boundary
OxFml remains authoritative for:
1. formula parsing, bind, and semantic-plan meaning,
2. evaluator-owned candidate, commit, reject, and trace artifacts,
3. typed capability, effect, and reject semantics,
4. replay-safe identity and fence rules.

DNA OneCalc, as a downstream host, may own:
1. host-supplied input binding surfaces,
2. local recalc trigger policy,
3. host-query provider implementation,
4. packaging and user-facing harness policy.

DNA OneCalc must not:
1. redefine OxFml formula semantics,
2. collapse candidate versus publication boundaries,
3. replace typed reject outcomes with host-specific generic failures,
4. introduce scheduler-policy meaning into OxFml artifacts.

## 3. Current Supported Host Shape
The current OxFml proving-host baseline is a single-formula host with:
1. one formula under test,
2. mutable defined-name inputs,
3. mutable direct cell bindings where semantic truth depends on concrete cell resolution,
4. optional typed host-query capability/profile input,
5. locale and date-system context,
6. deterministic recalc producing candidate, commit, reject, and trace artifacts.

This is a proving-host baseline, not a full host-product definition.

## 4. Direct Cell Binding Rule
DNA OneCalc host policy must preserve direct cell bindings anywhere the exercised semantic lane depends on concrete cell state.

Current explicit cases include:
1. `@` scalarization,
2. `_xlfn.SINGLE`,
3. reference-sensitive `CELL(...)` lanes,
4. any future spill-linked or reference-sensitive host scenario with concrete cell resolution truth.

Defined names alone are insufficient for those lanes.

## 5. Typed Host Responsibilities
The downstream host is expected to supply typed context, not hidden side effects.

Current typed host responsibilities are:
1. defined-name value or reference bindings,
2. direct cell bindings where required,
3. typed host-query profile or provider access,
4. locale profile and date-system context,
5. recalc invocation boundary and requested backend choice.

The host should not leak:
1. raw workbook objects,
2. raw scheduler state,
3. ad hoc capability side channels.

## 6. Current Host Policy Profiles
The current planning profiles for DNA OneCalc host consumption are recorded in:
1. `crates/oxfml_core/tests/fixtures/empirical_pack_planning/dna_onecalc_host_policy_profiles.json`

These profiles are planning artifacts only.
They are not product configuration files and they do not authorize pack-grade promotion.

## 7. Relationship To OxCalc
DNA OneCalc remains a reduced-profile single-node proving host.

It differs from OxCalc-integrated hosting because it does not own:
1. multi-formula dependency coordination,
2. global scheduler policy,
3. multi-session publish arbitration,
4. broader workbook graph lifecycle policy.

That difference is intentional and does not change OxFml semantics.

## 8. Current Explicit Gaps
The following remain open beyond the current baseline:
1. full DNA OneCalc product specification,
2. host policy for broader workbook structure ownership,
3. broader external-provider and async host policy,
4. pack-grade empirical capture and promotion policy,
5. host behavior for later richer callable-value carriers.

## 9. Working Rule
Use this document to keep the current DNA OneCalc-facing host boundary explicit.

Do not use it to overclaim:
1. full host maturity,
2. full OxCalc equivalence,
3. pack-grade scenario promotion.

## Source: `OxFml/docs/spec/OXFML_EMPIRICAL_PACK_PLANNING.md`

# OxFml Empirical Pack Planning

## 1. Purpose
This document defines the current OxFml empirical-pack planning surface for host and oracle scenarios.

It exists to:
1. group exercised proving-host and oracle scenarios into future promotion families,
2. keep promotion blockers explicit,
3. avoid mistaking planning artifacts for pack-grade promotion.

Read together with:
1. `OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
2. `OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
3. `fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`

## 2. Current Planning Artifacts
The current machine-readable planning artifacts are:
1. `crates/oxfml_core/tests/fixtures/empirical_pack_planning/dna_onecalc_host_policy_profiles.json`
2. `crates/oxfml_core/tests/fixtures/empirical_pack_planning/empirical_pack_candidate_groups.json`

These artifacts are planning inputs only.
They do not authorize pack-grade promotion and they do not replace OxFml replay governance.

## 3. Scenario Grouping Rule
Future empirical-pack promotion should group scenarios by semantic pressure, not just by function name.

Current planning groups are:
1. scalarization and reference resolution,
2. helper invocation and callable-value lanes,
3. spill-shaped publication,
4. semantic formatting,
5. host-query environment lanes,
6. reference-sensitive host-query lanes.

## 4. Preservation Rules
Any future empirical-pack capture must preserve:
1. entered formula text,
2. stored formula text when different,
3. defined-name inputs,
4. direct cell bindings where semantic truth depends on concrete resolution,
5. host-query profile or capability assumptions,
6. locale and date-system context,
7. typed expected result summary and replay-facing consequence facts.

Direct cell bindings may not be collapsed into prose-only notes where they matter semantically.

## 5. Non-Goals In This Pass
This planning pass does not:
1. create pack-grade artifacts,
2. declare any empirical group promotion-ready,
3. authorize replay-safe rewrites,
4. define a new scenario DSL.

## 6. Promotion Blockers
Current promotion blockers remain:
1. local witness tier only,
2. missing pack-grade capture governance,
3. missing broader Excel-oracle pack authoring,
4. missing broader retained-witness promotion beyond the current local floor,
5. open runtime and semantic breadth outside the current exercised scenarios.

## 7. Relationship To Replay Governance
Empirical-pack planning is subordinate to OxFml replay governance.

That means:
1. retained-local witness rules still apply,
2. quarantined or explanatory-only witnesses remain non-pack-eligible,
3. empirical pack planning does not weaken replay-safe transform constraints,
4. pack planning remains planning-only until replay governance and evidence both permit promotion.

## 8. Working Rule
Use this document to organize future empirical scenario promotion without overstating current maturity.

Current empirical-pack planning is:
1. machine-readable,
2. tied to exercised host/oracle scenarios,
3. intentionally non-pack-grade.

## Source: `OxFml/docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`

# OxFml Fixture Host And Coordinator Stand-In Packet

## Purpose
Define the first bounded OxFml-side packet for deterministic fixture hosts and coordinator stand-ins used by integration artifacts such as the OxFunc adapter wave.

This packet is not the production OxCalc coordinator API.
It is the smallest honest stand-in host packet that can:
1. drive real OxFml parse, bind, semantic-plan, and evaluation work,
2. stand in for coordinator-owned truths where needed,
3. remain compatible with the converged first-slice OxFml/OxCalc host/runtime packet.

## Why This Exists
The new OxFunc adapter and seam-fixture work under `W049` and `W050` cannot be purely OxFunc-facing.

Some of the required fixture inputs are actually stand-ins for host or coordinator-owned truths, including:
1. caller anchor,
2. direct cell bindings,
3. defined-name bindings,
4. table metadata,
5. typed host-query and provider surfaces,
6. runtime library-context snapshot selection.

OxFml therefore needs a clear rule for what the test harness may stand in for locally without pretending to have already frozen the full OxCalc coordinator API.

## Boundary Position
The fixture host packet should:
1. be sufficient to drive the current first-application seam and first host slice,
2. reuse the same semantic packet families already converged in the host/runtime contract,
3. stay deterministic and machine-readable,
4. make OxCalc-owned versus OxFml-owned truth explicit.

The fixture host packet should not:
1. replace the production OxCalc coordinator API,
2. silently widen current host/runtime ownership beyond the converged first slice,
3. collapse typed host or provider outcomes into mock-only shortcuts that hide real seam meaning.

## First Packet Families
The first stand-in fixture packet should be composed from the current converged host/runtime families.

### 1. Formula slot facts
1. `fixture_input_id`
2. optional `formula_slot_id`
3. `formula_text`
4. `formula_channel`
5. `caller_anchor`
6. optional `active_selection_anchor`
7. structure-context identity or version

### 2. Binding-world facts
1. `cell_fixture`
2. optional `defined_name_bindings`
3. optional `table_catalog`
4. optional `enclosing_table_ref`
5. optional `caller_table_region`

### 3. Typed host/query facts
1. optional `ReferenceResolver`
2. optional `HostInfoProvider`
3. optional `RtdProvider`
4. optional `RegisteredExternalProvider`
5. `LocaleFormatContext`
6. scalar context:
   - `now_serial`
   - `random_value`
   - date-system context

### 4. Runtime catalog facts
1. `library_context_snapshot_ref`
2. a local or pinned `LibraryContextProvider`

## Ownership Rule
For the fixture packet, ownership should be read as:

### OxFml-owned
1. parse, bind, semantic-plan, and evaluator meaning,
2. candidate, commit, reject, trace, and typed effect meaning,
3. packet projection into OxFunc-facing preparation and evaluation artifacts.

### Host/OxCalc-owned, even when fixture-backed
1. caller location and selection context,
2. direct cell and defined-name bindings,
3. table metadata and enclosing-table truth,
4. host-query answers and typed capability denial,
5. RTD and registered-external provider behavior,
6. runtime library-context selection and snapshot drift policy.

Working rule:
1. the fixture harness may stand in for these host/coordinator-owned truths locally,
2. but the packet must still mark them as host/coordinator-supplied inputs rather than evaluator-owned meaning.

## First Reuse Goal
The first reuse goal is:
1. OxFunc adapter tests can use this packet as their deterministic host/coordinator stand-in,
2. later direct-host tests can use the same packet families,
3. later OxCalc-integrated tests can either reuse the packet directly or wrap it in a larger coordinator transport without changing semantic meaning.

## Current Open Questions For OxCalc
The next bounded OxCalc round should answer:
1. is this the right first stand-in packet for coordinator-owned truths in test artifacts,
2. should `RegisteredExternalProvider` stay present in the fixture packet from the start even if the first OxFunc wave keeps `CALL` / `REGISTER.ID` deferred,
3. should validated candidate/commit/reject packet capture be part of the same stand-in fixture packet or remain a separate host/runtime projection layer,
4. does OxCalc want any additional identity or acknowledgment fields before this packet is useful for later TreeCalc-facing integration tests.

## Current OxCalc Intake
OxCalc's latest reply is now convergent on this packet direction.

Current accepted reading:
1. yes, this is the right first bounded stand-in packet for deterministic integration artifacts,
2. yes, `RegisteredExternalProvider` may stay present as an optional stand-in field from the start,
3. yes, candidate/commit/reject capture should remain a separate projection layer,
4. no, this does not freeze the production OxCalc coordinator API.

Current accepted packet refinements:
1. add a stand-in packet identity or `fixture_input_id`,
2. keep explicit structure-context identity,
3. allow explicit `formula_slot_id` when the same packet is reused across multiple formula-bearing slot families.

Current next step:
1. keep this packet narrow,
2. drive further change only from implementation reuse or concrete mismatch,
3. do not widen it into a broader coordinator API packet prematurely.

## Source: `OxFml/docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`

# OxFml Host Runtime and External Requirements

## 1. Purpose and Status
This document defines the current OxFml-owned host/runtime and external-interface requirements for implementation of a host that drives the OxFml and OxFunc combination.

It exists to unify three surfaces that were previously documented separately:
1. the code-facing transform and service sketch,
2. the reduced-profile direct-host baseline,
3. the coordinator-facing seam with OxCalc.

Status:
1. canonical OxFml draft for host/runtime requirements,
2. implementation-facing for the currently covered local scope,
3. reviewed by OxCalc as sufficient for first implementation planning on the current covered slice, with the current host/runtime note round now converged on that first-slice reading,
4. not yet promoted as shared seam-freeze text,
5. intended as the bounded coordination packet for the current OxCalc round and any later mismatch-driven refinement.

Read together with:
1. `OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
2. `OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
3. `OXFML_CANONICAL_ARTIFACT_SHAPES.md`
4. `OXFML_MINIMUM_SEAM_SCHEMAS.md`
5. `OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
6. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`
7. `formula-language/OXFML_OXFUNC_LIBRARY_CONTEXT_RUNTIME_INTERFACE.md`
8. `formula-language/OXFML_R1C1_FORMULA_CHANNEL.md`
9. `formula-language/OXFML_CF_DV_RESTRICTED_SUBLANGUAGES.md`
10. `formula-language/OXFML_STRUCTURED_REFERENCE_AND_TABLE_BOUNDARY.md`
11. `formula-language/OXFML_NAME_WORLD_AND_RUNTIME_REGISTRATION_INVALIDATION.md`

## 2. Authority Boundary
OxFml remains authoritative for:
1. formula grammar, parse, bind, and semantic-plan meaning,
2. evaluator-owned candidate, commit, reject, trace, and replay-safe artifact meaning,
3. typed capability, fence, effect, and reject semantics,
4. runtime library-context snapshot correlation where evaluator semantics depend on catalog truth.

OxFunc remains authoritative for:
1. built-in function semantic truth,
2. value-type universe and worksheet-error payload meaning,
3. runtime library-context catalog truth and snapshot generation.

Hosts consuming the OxFml and OxFunc combination may own:
1. host-supplied bindings and provider implementations,
2. recalc trigger policy,
3. scheduler and publication policy where that is outside OxFml evaluator meaning,
4. process and packaging concerns.

Hosts must not:
1. redefine candidate, commit, reject, fence, or capability semantics,
2. collapse accepted candidate into committed publication,
3. replace typed evaluator/runtime outcomes with generic host failures,
4. hide snapshot drift or host/provider truth behind opaque mutable globals.

## 3. Host Modes
Two host modes are in scope for the current OxFml contract.

### 3.1 Direct Host Mode
Direct host mode is a proving or single-formula application host with no OxCalc coordinator involved.

Current direct-host scope:
1. one formula or one narrow local recalc surface,
2. mutable defined-name and direct-cell bindings,
3. typed host-query providers,
4. deterministic candidate, commit, reject, and trace production through OxFml-owned artifacts.

Direct host mode does not imply:
1. graph-wide dependency coordination,
2. multi-session publication arbitration,
3. distributed placement policy,
4. OxCalc-equivalent coordinator semantics.

### 3.2 OxCalc-Integrated Host Mode
OxCalc-integrated mode is the coordinator-facing host path where OxCalc drives scheduling, intake, and publication policy across a broader workbook or graph.

Current OxCalc-integrated host contract requires:
1. explicit candidate versus commit separation,
2. typed reject and runtime-effect carriage,
3. stable artifact and correlation identities,
4. no host-side reinterpretation of OxFml artifact meaning.

## 4. Required Inputs
Every conforming host must supply the following explicitly for the currently covered scope.

### 4.1 Formula and Structure Inputs
1. `FormulaSourceRecord`
2. formula-stable identity
3. structure-context identity or version
4. caller anchor and address-mode context where relative or host-sensitive meaning depends on it
5. direct cell bindings where semantic truth depends on concrete resolution
6. defined-name bindings

### 4.1A Host-Owned Table Context Inputs
When a formula channel permits structured references, the host must also supply explicit table context rather than expecting OxFml to recover it from workbook globals.

Required first semantic packet:
1. `table_catalog`
2. `enclosing_table_ref`
3. `caller_table_region`

Required first packet meaning:
1. `table_catalog` carries stable table identity, range, column map, and header/totals presence,
2. `enclosing_table_ref` identifies the effective table for omitted-table-name forms such as `[@Amount]`,
3. `caller_table_region` carries row/region-sensitive meaning needed for `#This Row`, header, data, or totals-sensitive bind.

Working rule:
1. direct hosts and OxCalc-integrated hosts should supply the same semantic packet even if their surrounding transport differs,
2. host ownership of tables matches the broader rule that workbook objects remain host/coordinator-owned,
3. OxFml owns grammar, bind, and evaluator consequences once the packet is supplied.

### 4.2 Runtime Catalog Inputs
1. `LibraryContextProvider`
2. immutable `LibraryContextSnapshot`
3. explicit snapshot identity and generation
4. runtime lookup over that pinned snapshot during bind or semantic-plan work
5. for runtime catalog mutation lanes, a host-facing OxFunc-owned registered-external mutation/controller surface rather than host-local catalog mutation

Working rule:
1. runtime catalog truth is a runtime interface, not a build-time-only ingestion step,
2. registration or removal must yield a new snapshot generation,
3. a host must not mutate a pinned snapshot in place and still claim stable replay or bind truth,
4. built-in catalog population remains OxFunc-owned from the start,
5. runtime registration and unregister of external functions should be funneled through OxFml packet normalization into OxFunc-owned catalog mutation rather than implemented as host-local side tables.

Current invalidation rule:
1. if runtime registration/removal creates or removes an ordinary formula-callable surface by name, treat that as a bind-visible name-world change,
2. if host-owned defined names are added, removed, renamed, or reclassified, treat that as the same broad invalidation class,
3. if a change only affects worksheet `CALL` / `REGISTER.ID` descriptor/runtime truth, treat it as a narrower reevaluation lane unless it also changes a bind-visible function-name world.

### 4.3 Typed Context and Query Inputs
For the currently covered local scope, a host must be able to supply the first typed context/query bundle families:
1. `ReferenceResolver`
2. `HostInfoProvider`
   - `query_cell_info(...)`
   - `query_info(...)`
   - `query_formula_text(reference)`
   - `query_sheet_index(CurrentSheet | Reference | SheetNameText)`
   - `query_sheet_count(Workbook | Reference)`
   - `query_aggregate_reference_context(reference)`
   - `query_width_conversion_mode(function)`
3. `RtdProvider`
   - `RtdRequest { prog_id, server_name, topic_strings }`
   - `RtdProviderResult::{ Value, NoValueYet, CapabilityDenied, ConnectionFailed, ProviderError }`
4. `RegisteredExternalProvider`
   - `resolve_register_id(RegisterIdRequest)`
   - `lookup_registered_external(register_id)`
   - `invoke_registered_external(descriptor, args)`
5. for host-initiated runtime registration and unregister:
   - `RegisteredExternalCatalogMutationRequest`
   - `RegisteredExternalCatalogController`
6. scalar context inputs:
   - `now_serial`
   - `random_value`
   - `LocaleFormatContext`
   - date-system context

Deferred-provider rule:
1. provider families explicitly deferred in OxFml or OxFunc remain outside this host contract,
2. hosts must not infer support for a deferred provider family from the existence of a generic typed-provider slot,
3. worksheet `CALL` / `REGISTER.ID` and host/VBA registration channels should share the same OxFunc-owned registered-external catalog truth rather than independent side channels.

### 4.4 Capability and Fence Inputs
Where the session path is used, a host must also supply:
1. capability view or capability profile identity,
2. snapshot and token fence basis,
3. commit-attempt identity where publication is attempted.

## 5. Required Operations
The minimum implementation-facing operation chain is:
1. `parse`
2. `project_red_view`
3. `bind`
4. `compile_semantic_plan`
5. `evaluate`
6. `commit`

Optional operational layers may exist:
1. repository services,
2. session services,
3. trace capture services,
4. proving-host helpers.

Working rule:
1. service layers are allowed,
2. canonical transform meaning remains normative,
3. a host implementation must be explainable in terms of explicit transform inputs and outputs even when caches or services are used internally.

## 6. Required Outputs
For the currently covered scope, a host implementation must preserve the following output families.

### 6.1 Artifact Outputs
1. `ParseResult`
2. `BindResult`
3. `CompileSemanticPlanResult`
4. `EvaluationOutput`
5. `AcceptedCandidateResult | RejectRecord`
6. `CommitBundle | RejectRecord`

### 6.2 Return-Surface Outputs
The host-visible return surface must preserve the first three-way split:
1. ordinary value,
2. `ValueWithPresentation`,
3. typed host/provider outcome projection.

### 6.3 Coordinator-Relevant Outputs
An OxCalc-integrated host must preserve:
1. `candidate_result_id`
2. `commit_attempt_id` where present
3. `reject_record_id`
4. optional `fence_snapshot_ref`
5. typed effect, reject, and topology-sensitive consequence surfaces
6. trace and replay correlation sufficient for deterministic diagnosis

## 7. Candidate, Commit, and Reject Rules
The host contract must preserve the following distinctions.

### 7.1 Edit Rejection Versus Accepted-Unresolved
1. a host may reject an edit before canonical artifact adoption when the formula cannot honestly enter the parse/bind/plan ladder,
2. a host may also accept formula text into canonical artifact state while preserving unresolved-name or bind-diagnostic facts,
3. accepted-unresolved is not the same thing as edit rejection.

### 7.2 Evaluation Versus Publication
1. `evaluate` yields an accepted candidate or a typed reject,
2. accepted candidate is not committed publication,
3. `commit` yields a published bundle or a typed no-publish reject.

### 7.3 Host Failure Projection Rule
Where an exercised host-query or provider lane projects through OxFml today:
1. the host must preserve the typed outcome family,
2. the host must not replace it with a generic exception or opaque transport error,
3. the host may add local diagnostics only if canonical typed meaning remains preserved.

## 8. Direct-Binding and Host-Sensitive Truth
Hosts must preserve direct cell bindings for lanes where semantic truth depends on concrete resolution.

Current explicit families include:
1. `@` scalarization,
2. `_xlfn.SINGLE`,
3. reference-sensitive `CELL(...)`,
4. other host-sensitive or spill-sensitive lanes where the canonical artifact still depends on direct cell identity.

Defined names alone are insufficient for these families.

## 9. Runtime Library-Context Requirements
The normative runtime seam to OxFunc is:
1. `LibraryContextProvider`
2. immutable `LibraryContextSnapshot`
3. explicit snapshot identity and generation
4. runtime-consumable surface lookup from OxFml

The CSV or other exported catalog artifact is:
1. useful for pinning,
2. useful for mismatch reporting,
3. useful for generated tests,
4. not the normative runtime interface by itself.

Implementation rule:
1. a host may ingest exported artifacts for testing or cold-start preparation,
2. runtime semantic truth must still be representable through the provider/snapshot interface.

## 10. Currently Covered Implementation Scope
For the currently covered local floor, a host implementation is expected to be sufficient for:
1. direct-host execution of the proving-host slice,
2. OxCalc consumption of candidate, commit, reject, trace, and runtime-effect families already carried canonically,
3. formula-entry channels already exercised locally:
   - ordinary worksheet A1 formulas
   - `WorksheetR1C1` for the current translated cell-and-area floor
4. typed host-query/provider lanes already exercised locally:
   - `INFO`
   - `CELL`
   - `RTD`
5. current OxFml/OxFunc higher-order callable floor already exercised locally:
   - `LET`
   - `LAMBDA`
   - `MAP`
   - `REDUCE`
   - `SCAN`
   - `BYROW`
   - `BYCOL`
   - `MAKEARRAY`

This section is intentionally narrower than “full Excel and all functions”.
Broader language and function coverage remains driven by the open worksets and exercised-evidence floor.

## 11. Explicit Deferrals
The following are not authorized by this host/runtime requirements draft:
1. full workbook-graph scheduler policy,
2. pack-grade replay claims,
3. deferred external/provider families,
4. final cross-process ABI,
5. full distributed placement policy,
6. full UI or rendering policy,
7. unexercised built-in or sublanguage families beyond the current local evidence floor.

## 12. OxCalc Coordination Questions
The next OxCalc coordination round should answer:
1. whether this direct-host versus OxCalc-integrated split is sufficient for implementation planning,
2. whether the required input families are enough for the first coordinator-host implementation slice,
3. whether the current required output families are sufficient for coordinator-controlled publication,
4. whether any currently covered host-query or effect family is still too narrow to implement a host honestly,
5. whether any narrower handoff is required now or whether note-level convergence is enough for this packet.

Current OxCalc intake after the first review pass is:
1. yes for the first direct-host and coordinator-host implementation slice,
2. no for broader shared seam-freeze promotion yet,
3. remaining residuals stay concentrated in:
   - caller-anchor and address-mode carriage for the first TreeCalc relative-reference subset,
   - execution-restriction transport shape beyond the current semantic minimum,
   - publication and topology breadth beyond the current local exercised floor,
   - provider-failure and callable-publication only if they later become coordinator-visible.

Current OxCalc intake after the latest confirmation pass is:
1. the first host/runtime packet is settled enough for first implementation planning,
2. caller-anchor and address-mode carriage remains in the `W026` note lane,
3. provider-failure and callable-publication remain watch lanes only,
4. no new formal handoff is warranted from the current host/runtime packet alone.

## 13. Working Rule
Use this document as the current canonical OxFml draft for host/runtime and external requirements.

Do not over-read it as:
1. OxCalc agreement,
2. full product-host specification,
3. full language or built-in-function closure,
4. permission to bypass the canonical OxFml artifact and seam docs.

## 14. First Host Implementation Workflow
For a first direct single-cell host implementation, the expected implementation workflow is:

1. bootstrap runtime catalog truth
   - create or obtain a `LibraryContextProvider`,
   - pin one immutable `LibraryContextSnapshot`,
   - keep the chosen snapshot identity visible to parse, bind, and semantic-plan work,
2. create host state
   - construct the host formula source and stable identity,
   - configure caller location and structure-context identity,
   - load direct-cell bindings and defined-name bindings,
3. attach typed providers and scalar context
   - attach `HostInfoProvider` if the formula may use host-query functions,
   - attach `RtdProvider` if `RTD` is in scope,
   - attach locale/date-system context,
   - attach `now_serial` and `random_value` if the selected scope needs them,
4. run the canonical transform chain
   - `parse`
   - `project_red_view`
   - `bind`
   - `compile_semantic_plan`
   - `evaluate`
   - `commit`,
5. consume the host-facing output packet
   - `SemanticPlan`
   - `ExecutionContract`
   - frozen `TypedContextQueryBundleSpec`
   - `EvaluationOutput`
   - `ReturnedValueSurface`
   - `AcceptedCandidateResult`
   - `CommitBundle` or `RejectRecord`
   - `trace_events`,
6. decide local host action
   - for a direct host, render or report the ordinary value or typed host/provider outcome,
   - for an OxCalc-integrated host, hand candidate, commit, reject, and trace families onward without redefining their meaning.

For the current local floor, the direct host path is concretely represented by the single-formula host API, including:
1. `recalc(...)`
2. `recalc_with_backend(...)`
3. `recalc_with_interfaces(...)`
4. `recalc_with_rtd_provider(...)`

## 15. Current Implementation Readiness Assessment
For a first single-cell host implementation, the current local floor is:

### 15.1 In place now
1. a direct host can already execute a single formula through the current host path,
2. runtime library-context provider consumption exists locally,
3. grouped typed-query evidence exists for the currently exercised host-query/provider slice:
   - `INFO`
   - `CELL`
   - `RTD`,
4. the first host-visible return-surface split exists and is exercised:
   - ordinary value,
   - `ValueWithPresentation`,
   - typed host/provider outcome projection,
5. candidate, commit, reject, and trace outputs already exist in the direct-host path,
6. current higher-order callable execution exists locally for the currently exercised slice:
   - `LET`
   - `LAMBDA`
   - `MAP`
   - `REDUCE`
   - `SCAN`
   - `BYROW`
   - `BYCOL`
   - `MAKEARRAY`.

### 15.2 Not in place now
1. this is not yet a full Excel cell-formula implementation,
2. this is not yet coverage for nearly all built-in functions,
3. broader language families remain open, including work still owned by:
   - structured references and table formulas,
   - broader name and external-name host-boundary work,
4. restricted conditional-formatting and data-validation carriers are now specified, but they are not part of the first ordinary single-cell host packet,
5. broader host-query/provider families beyond the current `INFO` / `CELL` / `RTD` slice remain outside the current exercised floor,
6. broader runtime/distributed host policy remains outside the first direct-host slice,
7. pack-grade replay promotion is not in place.

Working rule:
1. the current host packet is sufficient for a first single-cell implementation over the currently covered slice,
2. it is not yet honest to describe the whole OxFml + OxFunc combination as full Excel formula coverage.

## 16. Replay Appliance Integration Path
The replay appliance can already be integrated into a first host through an explicit first-host capture packet.

For the current local floor, a host should retain and project:
1. formula source and stable identity,
2. pinned library-context snapshot identity,
3. frozen `TypedContextQueryBundleSpec`,
4. `SemanticPlan` identity and execution contract summary,
5. `EvaluationOutput`,
6. `ReturnedValueSurface`,
7. `AcceptedCandidateResult`,
8. `CommitBundle` or `RejectRecord`,
9. `trace_events`.

The direct-host packet already exposes the needed raw surfaces through `HostRecalcOutput`.
For the current local floor, hosts may project that output through the first helper packet:
1. `HostRecalcOutput::to_first_host_replay_capture_packet()`

Current replay-integration rule:
1. the host may project `HostRecalcOutput` into the replay appliance using the existing adapter and canonical artifact families,
2. the host must preserve candidate-versus-commit distinction and typed reject meaning when doing so,
3. the host must preserve direct-binding-sensitive and host-query-sensitive truth where the replay witness depends on it,
4. the host must not treat replay projection as permission to rewrite formula text, bind payloads, fence tuples, or capability views.

Current limitation:
1. the helper packet is a first-host capture projection, not a pack-grade replay bundle builder,
2. hosts still need to map that packet into the wider replay appliance import families,
3. replay evidence remains local-witness-tier rather than pack-grade.

## 17. Relationship To Fixture Hosts And Stand-In Coordinator Packets
The current host/runtime contract is also the source packet family for deterministic fixture hosts used in integration artifacts such as the OxFunc adapter wave.

Working rule:
1. fixture hosts may stand in for host/coordinator-owned truths locally,
2. they should still reuse the same semantic packet families described in this document,
3. that reuse must not be over-read as production OxCalc coordinator API freeze.

Current first stand-in packet direction is tracked in:
1. `docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`

Current intended reuse:
1. OxFunc-facing adapter fixtures under `W049` and `W050`,
2. later direct-host integration tests,
3. later OxCalc-integrated test packets where the coordinator wraps or reuses the same semantic host inputs.

## Source: `OxFml/docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`

# OxFml Minimum Seam Schemas

## 1. Purpose
This document defines the current minimum schema objects for the most important seam payload families.

It is narrower than the artifact-shapes document and more concrete than the taxonomy document.
Its job is to say what the minimum typed payloads must carry without prematurely freezing final wire encodings or implementation structs.

This document should be read together with:
1. `OXFML_CANONICAL_ARTIFACT_SHAPES.md`
2. `OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
3. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`
4. `formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`

## 2. Working Rule
For the schema objects below:
1. field families are canonical,
2. exact concrete type names remain open,
3. optional implementation-only debug fields do not belong in the canonical minimum,
4. typed variant payloads are preferred over generic maps or free-form strings.

## 3. Delta Schema Objects
### 3.1 `ValueDelta`
`ValueDelta` carries worksheet-visible value publication consequences.

Minimum fields:
1. `delta_family`
2. `formula_stable_id`
3. `primary_locus`
4. `affected_value_loci`
5. `published_value_class`
6. `published_payload`
7. optional `blankness_transition`
8. optional `result_extent`
9. optional correlation to candidate result or commit attempt

Minimum rules:
1. `published_value_class` must distinguish scalar, error, array-anchor payload, and explicit blank-like publication,
2. if the value consequence depends on an array extent, `result_extent` must be capturable,
3. `ValueDelta` must not carry dependency-only or policy-only information.

### 3.2 `ShapeDelta`
`ShapeDelta` carries occupancy and shape publication consequences.

Minimum fields:
1. `delta_family`
2. `formula_stable_id`
3. `anchor_locus`
4. `intended_extent`
5. optional `published_extent`
6. optional `blocked_loci`
7. `shape_outcome_class`
8. optional correlation to candidate result or commit attempt

Minimum rules:
1. `shape_outcome_class` must distinguish at least established, reconfigured, cleared, and blocked shape outcomes,
2. blocked outcomes must carry explicit blocking loci when capturable,
3. shape publication must remain distinct from value publication even when both arise from one result.

### 3.3 `TopologyDelta`
`TopologyDelta` carries coordinator-consumable evaluator facts and dependency consequences.

Minimum fields:
1. `delta_family`
2. `formula_stable_id`
3. optional `dependency_additions`
4. optional `dependency_removals`
5. optional `dependency_reclassifications`
6. optional `dependency_consequence_fact_refs`
7. optional `dynamic_reference_fact_refs`
8. optional `spill_fact_refs`
9. optional `format_dependency_tokens`
10. optional `capability_effect_refs`
11. optional correlation to candidate result or commit attempt

Minimum rules:
1. topology facts must be typed and machine-comparable,
2. topology payloads must not contain scheduler or fairness policy,
3. if a surfaced evaluator fact is coordinator-relevant but carried outside `TopologyDelta`, this delta must still make the publication consequence derivable,
4. dependency consequence facts are additive evidence and do not replace explicit removals or reclassifications where those are already contractual.

### 3.4 `FormatDelta`
`FormatDelta` carries semantic formatting consequences that must cross the seam.

Minimum fields:
1. `delta_family`
2. `formula_stable_id`
3. `target_loci`
4. `format_effect_class`
5. `format_effect_payload`
6. optional `dependency_token_refs`

Working rule:
1. `FormatDelta` may be derived from prepared-result `format_hint` when the hint crosses the seam as a publication obligation,
2. a local prepared-result hint alone does not imply a seam-significant `FormatDelta`.

### 3.5 `DisplayDelta`
`DisplayDelta` is optional and exists only when a publication-surface consequence is a seam obligation.

Minimum fields:
1. `delta_family`
2. `formula_stable_id`
3. `target_loci`
4. `display_effect_class`
5. `display_effect_payload`

Working rule:
1. `DisplayDelta` may be derived from prepared-result `publication_hint` when the publication surface itself is seam-significant,
2. renderer-only display changes remain out of scope.

## 4. Evaluator Fact and Event Schema Objects
### 4.1 `DynamicReferenceFact`
Minimum fields:
1. `fact_kind`
2. `formula_stable_id`
3. `discovery_site`
4. optional `reference_identity`
5. optional `target_extent`
6. optional `resolution_failure_class`
7. optional prior-versus-current comparison marker

### 4.2 `SpillFact`
Minimum fields:
1. `fact_kind`
2. `formula_stable_id`
3. `anchor_locus`
4. `intended_extent`
5. optional `published_extent`
6. optional `blocked_loci`
7. optional `blocked_reason_class`

### 4.3 `FormatDependencyFact`
Minimum fields:
1. `fact_kind`
2. `formula_stable_id`
3. `dependency_token`
4. `dependency_class`
5. optional locale/date-system/format-service scope

### 4.4 `CapabilityEffectFact`
Minimum fields:
1. `fact_kind`
2. `formula_stable_id`
3. `capability_kind`
4. `phase_kind`
5. `effect_class`
6. optional `fallback_class`

Current local exercised families additionally include:
1. `async_coupling`
2. `serial_scheduler_lane`
3. `single_flight`
4. `thread_affinity`

### 4.5 `DependencyConsequenceFact`
Minimum fields:
1. `fact_kind`
2. `formula_stable_id`
3. `dependency_identity`
4. `consequence_kind`
5. `evidence_class`
6. `projection_state`

### 4.6 `SpillEvent`
Minimum fields:
1. `spill_event_kind`
2. `formula_stable_id`
3. `anchor_locus`
4. `intended_extent`
5. optional `affected_extent`
6. optional `blocking_loci`
7. optional `blocking_reason_class`
8. correlation to candidate result or commit attempt

## 5. Typed Reject-Context Schemas
### 5.1 `FenceMismatchContext`
Minimum fields:
1. `mismatch_member_kind`
2. `expected_value`
3. `observed_value`
4. `mismatch_class`

### 5.2 `CapabilityDenialContext`
Minimum fields:
1. `capability_kind`
2. `phase_kind`
3. `denial_class`
4. `fallback_available`

### 5.3 `SessionTerminationContext`
Minimum fields:
1. `termination_class`
2. `session_id`
3. `candidate_already_built`
4. optional `termination_cause`

### 5.4 `BindMismatchContext`
Minimum fields:
1. `bind_hash`
2. optional `bound_formula_id`
3. `mismatch_class`
4. `discovery_phase`

### 5.5 `StructuralConflictContext`
Minimum fields:
1. `conflict_kind`
2. `conflicting_loci`
3. optional `conflicting_extent`
4. `retry_admissibility`

### 5.6 `DynamicReferenceFailureContext`
Minimum fields:
1. `dynamic_reference_family`
2. `failure_class`
3. optional `partial_reference_identity`
4. optional `discovery_site`

### 5.7 `ResourceInvariantContext`
Minimum fields:
1. `failure_family`
2. `machine_detail_code`
3. optional `resource_class`
4. optional implementation-only debug detail kept outside the canonical minimum

## 6. Host-Query Capability Schema
### 6.1 `HostQueryCapabilityView`
This schema supports functions like `CELL` and `INFO`.

Minimum fields:
1. `capability_view_key`
2. `profile_version`
3. `available_cell_query_kinds`
4. `available_workbook_fact_kinds`
5. `available_environment_fact_kinds`
6. optional `selection_context_support_class`
7. `denial_policy_class`

Boundary rule:
1. this view exposes typed fact families,
2. it must not expose raw workbook object handles,
3. when omitted-reference host-query lanes depend on active selection, the view must be able to report whether active-selection context is available,
4. it may be absent in call paths that do not admit host-query semantics.

## 7. Trace Event Schema
### 7.1 `TraceEvent`
Minimum fields:
1. `trace_schema_id`
2. `event_kind`
3. `formula_stable_id`
4. optional `session_id`
5. optional `candidate_result_id`
6. optional `commit_attempt_id`
7. optional `reject_record_id`
8. optional `fence_snapshot_ref`
9. `event_order_key`
10. typed `event_payload`

Minimum rules:
1. trace events must distinguish candidate construction from publication,
2. reject events must be correlatable to typed reject contexts,
3. surfaced evaluator effects must be representable either directly in `event_payload` or by stable typed references.

## 8. Replay Adapter Additive Schema Fields
The replay rollout adds optional projection-facing fields without changing OxFml seam meaning.

### 8.1 `ReplayBundleEnvelopeRef`
Optional additive fields:
1. `bundle_id`
2. `run_id`
3. `scenario_id`
4. `source_schema_id`
5. `bundle_schema_id`
6. `bundle_schema_version`

Working rule:
1. this object links a local seam payload to a normalized replay envelope,
2. it does not replace OxFml-local identity or fence fields.

### 8.2 `ReplayRegistryBinding`
Optional additive fields:
1. `registry_family`
2. `registry_version`
3. `entry_id`

Working rule:
1. registry bindings reference Foundation replay governance families,
2. registry bindings may annotate a seam payload or fixture scenario,
3. registry bindings do not redefine the local typed payload they annotate.

### 8.3 `CapabilityManifestRef`
Optional additive fields:
1. `adapter_id`
2. `adapter_version`
3. `lane_id`
4. `manifest_ref`

Working rule:
1. this ref links a replay-normalized payload to the current adapter capability manifest,
2. capability claims remain rollout governance, not semantic truth.

### 8.4 `WitnessLifecycleRef`
Optional additive fields:
1. `witness_id`
2. `lifecycle_state`
3. optional `retention_policy_id`
4. optional `quarantine_reason`
5. optional `reduction_manifest_ref`

Working rule:
1. lifecycle refs may annotate replay witnesses or reduced witness bundles,
2. lifecycle refs must not change the semantic meaning of candidate, commit, reject, or effect payloads.

### 8.5 `ProjectionFieldStatus`
Optional additive fields:
1. `field_path`
2. `status_class`
3. optional `reason_class`
4. optional `source_sidecar_ref`

Allowed `status_class` values in this pass:
1. `present`
2. `missing_explicit`
3. `opaque_preserved`

Working rule:
1. these markers exist to prevent invented defaults during normalization,
2. they are additive replay metadata only.

Additive replay rule:
1. any schema object in this document may carry optional `bundle_envelope_ref`, `registry_bindings`, `capability_manifest_ref`, `witness_lifecycle_ref`, or `projection_field_status` members,
2. these members are optional and additive,
3. no existing OxFml seam field is redefined to fit them.

## 9. Open Decisions
The following remain open:
1. whether `ValueDelta` and `ShapeDelta` are best represented as one-per-family object or as containers over entry lists,
2. exact payload typing for `published_payload` and `format_effect_payload`,
3. whether some fact refs are embedded objects versus stable ids,
4. whether Stage 2 concurrency needs finer-grained reject contexts for retry versus terminal failure,
5. exact encoding of `event_order_key` for cross-engine replay portability.

## 10. Working Rule
Until implementation begins:
1. use these schemas as the minimum typed surface,
2. prefer additive refinement over collapsing fields,
3. keep coordinator-visible consequences derivable without ad hoc interpretation.

## Source: `OxFml/docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`

# OxFml Public API and Runtime Service Sketch

## 1. Purpose
This document defines the first code-facing OxFml public surface sketch.

It is not a language-level signature freeze.
It is the current API-shape baseline that implementation work should target unless a later workset narrows it further.

Status rule:
1. this document remains the detailed code-surface sketch,
2. `OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md` is now the primary host/runtime coordination packet,
3. this document should be read as a supporting code-shape companion to that host/runtime packet rather than a separate peer host contract.

Read together with:
1. `OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
2. `OXFML_IMPLEMENTATION_BASELINE.md`
3. `OXFML_CANONICAL_ARTIFACT_SHAPES.md`
4. `OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
5. `formula-language/OXFML_PARSER_AND_BINDER_REALIZATION.md`
6. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`
7. `OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`

## 2. Surface Rule
The public OxFml surface should separate:
1. canonical artifact transforms,
2. optional repositories and runtime services,
3. evaluator-session and commit operations,
4. proving-host helpers.

The canonical artifact transforms are normative.
Repositories and services are optional operational layers over the same semantics.

## 3. Canonical Transform Surface
The current canonical transform chain is:
1. `parse`
2. `project_red_view`
3. `bind`
4. `compile_semantic_plan`
5. `evaluate`
6. `commit`

Each step must accept explicit inputs and return explicit typed outputs.

## 4. Current Request and Result Shapes
### 4.1 `ParseRequest` -> `ParseResult`
Minimum request fields:
1. `FormulaSourceRecord`
2. parse profile or compatibility context

Minimum result fields:
1. `GreenTreeRoot`
2. parse diagnostics
3. optional token-stream or trivia projection

### 4.2 `RedProjectionRequest` -> `RedProjection`
Minimum request fields:
1. `GreenTreeRoot`
2. `formula_stable_id`
3. source-span and caller/workbook context as needed

Minimum result fields:
1. red root view
2. span/parent-position helpers
3. contextual diagnostic helpers

### 4.3 `BindRequest` -> `BindResult`
Minimum request fields:
1. `GreenTreeRoot` and/or red projection
2. `formula_stable_id`
3. `formula_token`
4. `structure_context_version`
5. scope and table metadata
6. caller anchor and address-mode context
7. library-context snapshot or function/operator lookup surface
8. profile and capability context

Minimum result fields:
1. `BoundFormula`
2. bind diagnostics
3. unresolved-reference records

Result rule:
1. `bind` may reject a formula edit when the submitted text cannot honestly enter the bound-artifact world,
2. `bind` may also accept the formula text and produce a `BoundFormula` with unresolved-reference or bind-diagnostic records,
3. accepting the formula into bound-artifact state is not the same thing as claiming later evaluation success.

### 4.4 `CompileSemanticPlanRequest` -> `CompileSemanticPlanResult`
Minimum request fields:
1. `BoundFormula`
2. library-context snapshot identity or handle
3. OxFunc catalog or trait surface identity
4. locale, date-system, and format-service context
5. per-surface availability identity sufficient to explain:
   - stable surface identity
   - name-resolution table reference
   - semantic trait/profile reference
   - gating/profile reference

Minimum result fields:
1. `SemanticPlan`
2. semantic diagnostics and unsupported-lane markers
3. execution-profile summary
4. helper-environment profile summary
5. availability/gating summary where formula admission or runtime capability depends on catalog/profile/provider state
6. typed callable-carrier summary where semantically callable results must remain recoverable in replay or later dispatch, including callable values preserved through adopted defined-name context in the current local floor

Result rule:
1. `compile_semantic_plan` must preserve the difference between:
   - edit rejection before canonical artifact adoption,
   - accepted formula text with bind-time unresolved-name or unsupported-lane diagnostics,
   - runtime capability/provider outcomes that only become knowable later.
2. when a formula is accepted into the canonical artifact ladder but still has unresolved-name meaning, OxFml preserves that classification and OxFunc remains authoritative for the eventual `#NAME?` value payload and related value-universe behavior.

### 4.5 `EvaluateRequest` -> `AcceptedCandidateResult | RejectRecord`
Minimum request fields:
1. `SemanticPlan`
2. explicit evaluation context
3. host-query capability view where required
4. snapshot, token, and capability fence members
5. replay-correlation ids

Minimum result rule:
1. evaluation returns an accepted candidate or a typed reject,
2. evaluation does not publish.
3. evaluation is not the place where edit rejection is decided; edit rejection belongs to earlier parse/bind/plan acceptance rules.

### 4.6 `CommitRequest` -> `CommitBundle | RejectRecord`
Minimum request fields:
1. `AcceptedCandidateResult`
2. commit-attempt identity
3. accept-or-reject fence basis

Minimum result rule:
1. commit returns a published bundle or a typed no-publish reject,
2. commit consequences remain distinct from evaluator success.

## 5. Optional Repository and Runtime Surfaces
The first implementation may also expose optional services such as:
1. `SyntaxRepository`
2. `BindRepository`
3. `SemanticPlanRepository`
4. `EvaluationSessionService`
5. `TraceCaptureService`
6. `LibraryContextProvider`
7. host capability providers such as:
   - `HostInfoProvider`
   - `RtdProvider`

Working rule:
1. these services may own caches, indexes, or runtime handles,
2. they must not be the only explanation of semantic truth,
3. all service-backed results must remain reproducible through the canonical transform surface.

## 6. Current Handle Vocabulary
If handle-based services exist, the first handle families should remain narrow:
1. syntax artifact handle
2. bound-formula handle
3. semantic-plan handle
4. session handle
5. trace or replay handle

Working rule:
1. handles are operational conveniences,
2. canonical artifacts remain the semantic baseline,
3. handles must be mappable back to artifact identities and version keys.

## 7. Single-Formula Proving Host Surface
OxFml should also expose a small proving-host helper surface for the ladder defined in `OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`.

The current intended operations are:
1. create or refresh single-formula host state
2. update defined-name inputs
3. trigger full recalc
4. retrieve candidate, commit, reject, and trace outputs
5. project a first-host replay-capture packet from the resulting host output
6. run an empirical-oracle scenario through the same proving-host surface

Working rule:
1. this surface is a proving host, not a second scheduler,
2. it should exercise the same canonical transform and seam outputs,
3. it should not require OxCalc multi-node infrastructure.

## 8. Execution-Profile and Concurrency Surface
The public surface must leave room for scheduler-relevant execution metadata from the start.

The first exposed shape should allow:
1. formula-level execution profile summary from `SemanticPlan`
2. helper-environment profile summary from `SemanticPlan`
3. call-site or operator-level restrictions where needed
4. explicit flags for host-query, thread-affine, async, single-flight, or serial-only lanes

Working rule:
1. OxFml surfaces execution restrictions,
2. OxCalc or a host consumes them for scheduling,
3. OxFml also surfaces helper-environment shape where downstream semantic coordination depends on it,
4. OxFml does not become the scheduler-policy owner.

## 8A. First Shared Typed Context/Query Bundle
For the current covered OxFunc scope, OxFml should be able to consume a first shared typed context/query bundle without reopening broad seam theory.

Current first-pass families are:
1. `ReferenceResolver`
2. `HostInfoProvider`
   - `query_cell_info(...)`
   - `query_info(...)`
   - `query_formula_text(reference)`
   - `query_sheet_index(CurrentSheet | Reference | SheetNameText)`
   - `query_sheet_count(Workbook | Reference)`
   - `query_aggregate_reference_context(reference)`
   - `query_width_conversion_mode(function)`
   - `query_translate(request)`
3. `RtdProvider`
   - `RtdRequest { prog_id, server_name, topic_strings }`
   - `RtdProviderResult::{ Value, NoValueYet, CapabilityDenied, ConnectionFailed, ProviderError }`
4. host-supplied scalar context providers:
   - `now_serial`
   - `random_value`
   - `LocaleFormatContext`

Working rule:
1. OxFml prefers capability-scoped typed providers over raw host objects,
2. the current OxFunc query names and result partitioning are acceptable as the first freeze candidate,
3. exact names may still be merged or split later if a concrete consumer mismatch appears,
4. any such merge/split must preserve the same semantic families,
5. the remaining clarification is now implementation-facing rather than semantic: whether actual OxFml consumer modeling exposes a concrete need to merge or split any first-pass family.

## 8B. First Shared Returned Value Surface
For the current covered scope, the first returned-value split should remain explicit.

Current first-freeze candidate:
1. ordinary value
2. `ValueWithPresentation`
3. typed host/provider outcome projection

Working rule:
1. OxFml currently accepts that explicit split as the first shared freeze candidate,
2. richer publication-facing or display-facing factoring should not be invented until a concrete mismatch appears,
3. publication-aware value hints remain distinct from typed host/provider outcome projection,
4. the remaining clarification is now implementation-facing rather than semantic: whether actual return-carrier freezing exposes a concrete need to refactor the current first-pass split.

## 8C. First Runtime Library-Context Consumer Model
For the current covered OxFunc scope, OxFml should also model a real runtime consumer for built-in catalog truth rather than rely only on export-file pinning.

Current first-pass direction:
1. `LibraryContextProvider`
   - `current_snapshot()`
   - `snapshot_by_identity(snapshot_ref)`
   - `lookup_surface(snapshot_ref, surface_key)`
2. immutable `LibraryContextSnapshot`
3. runtime-consumable `LibraryContextEntry`
4. explicit snapshot identity and generation on parse, bind, and semantic-plan artifacts

Working rule:
1. OxFml prefers a cleaner runtime-only consumer shape plus an explicit CSV/export mapping layer,
2. the committed `W044` export remains the immediate pinning and mismatch artifact,
3. runtime registration or removal must yield explicit new snapshot generations rather than mutate a pinned snapshot in place,
4. snapshot drift must not be hidden inside evaluation or session execution,
5. the remaining clarification is now implementation-facing rather than semantic: whether actual OxFml consumer modeling exposes any runtime-only versus export-mapping mismatch that forces a narrower shape.

## 9. Current Preferred Packaging Shape
The current preferred packaging shape is:
1. a stateless canonical-core module set,
2. optional repository/service modules,
3. an FEC/F3E session service layer,
4. an optional proving-host helper layer.

This is the API reflection of the hybrid implementation baseline.

## 10. Deferred Decisions
The following remain open:
1. exact trait/interface/function names,
2. whether the direct transform surface is free-function based or service-object based,
3. whether red projection is publicly exposed or kept as an internal helper surface,
4. whether proving-host helpers live in the main library or a sibling support package,
5. exact error/result carrier style for language bindings,
6. the smallest honest library-context snapshot shape beyond the current local minimum field floor,
7. the final callable-value carrier beyond the current typed minimum plus replay-summary floor.
8. whether the first typed context/query bundle needs a narrower capability-family merge or split after initial consumer modeling.
9. whether the runtime `LibraryContextProvider` model should mirror the CSV artifact closely or use a cleaner runtime-only shape plus explicit mapping layer.
10. exact shared field names for the first frozen typed context/query bundle and returned-value split.

## 11. Workset Implications
Current expected primary owners:
1. `W002`: parser, red-projection, bind, and artifact-surface narrowing
2. `W003`: semantic-plan, evaluation, and execution-profile surface narrowing
3. `W004`: session and commit service surface narrowing
4. `W008`: single-formula proving-host helper surface narrowing
5. `W041`: typed context and query bundle freeze
6. `W042`: return surface and publication-hint freeze
7. `W043`: runtime library-context provider consumer model

## 12. Working Rule
Implementation should treat this document as the current public-surface baseline:
1. direct transforms first,
2. optional services second,
3. publication and reject consequences typed,
4. proving-host helpers narrow and explicit.

## Source: `OxFml/docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`

```json
{
  "adapter_id": "oxfml.replay_adapter.v1",
  "adapter_version": "v1-draft",
  "lane_id": "oxfml",
  "supported_source_schema_ids": [
    "oxfml.local.source_schema.parse_bind_cases.v1",
    "oxfml.local.source_schema.semantic_plan_replay_cases.v1",
    "oxfml.local.source_schema.prepared_call_replay_cases.v1",
    "oxfml.local.source_schema.fec_commit_replay_cases.v1",
    "oxfml.local.source_schema.execution_contract_replay_cases.v1",
    "oxfml.local.source_schema.session_lifecycle_replay_cases.v1",
    "oxfml.local.source_schema.single_formula_host_replay_cases.v1",
    "oxfml.local.source_schema.empirical_oracle_scenarios.v1"
  ],
  "supported_replay_bundle_schema_versions": [
    "dna-replay-bundle/v1"
  ],
  "claimed_capability_levels": [
    "cap.C0.ingest_valid",
    "cap.C1.replay_valid",
    "cap.C2.diff_valid",
    "cap.C3.explain_valid"
  ],
  "scaffolded_capability_levels": [
    "cap.C4.distill_valid"
  ],
  "known_limits": [
    "No replay-safe formula-text rewrite family is declared in this pass.",
    "No replay-safe bind rewrite family is declared in this pass.",
    "No replay-safe fence rewrite family is declared in this pass.",
    "No replay-safe capability-view rewrite family is declared in this pass.",
    "The adapter does not claim cap.C5.pack_valid in this pass.",
    "Current supported source schema ids are OxFml-local ids, not yet published machine-readable schema ids.",
    "Unified trace-schema merge strategy versus subsystem-preserved schemas remains open."
  ],
  "conformance_artifact_refs": [
    "docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md",
    "docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md",
    "docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md",
    "docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md",
    "crates/oxfml_core/tests/fixtures/fec_commit_replay_cases.json",
    "crates/oxfml_core/tests/fixtures/session_lifecycle_replay_cases.json",
    "crates/oxfml_core/tests/fixtures/prepared_call_replay_cases.json",
    "crates/oxfml_core/tests/fixtures/execution_contract_replay_cases.json",
    "crates/oxfml_core/tests/fixtures/single_formula_host_replay_cases.json",
    "crates/oxfml_core/tests/fixtures/empirical_oracle_scenarios.json",
    "crates/oxfml_core/tests/fixtures/library_context_snapshot_cases.json",
    "crates/oxfml_core/tests/fixtures/witness_distillation/fec_accept_publication_reduction_manifest.json",
    "crates/oxfml_core/tests/fixtures/witness_distillation/session_capability_denied_reduction_manifest.json",
    "crates/oxfml_core/tests/fixtures/witness_distillation/execution_contract_host_query_reduction_manifest.json",
    "crates/oxfml_core/tests/fixtures/witness_distillation/single_formula_host_scalarization_reduction_manifest.json",
    "crates/oxfml_core/tests/fixtures/witness_distillation/empirical_oracle_host_query_reference_reduction_manifest.json",
    "crates/oxfml_core/tests/fixtures/witness_distillation/retained_witness_set_index.json",
    "docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md",
    "docs/spec/OXFML_EMPIRICAL_PACK_PLANNING.md",
    "crates/oxfml_core/tests/fixtures/replay_bundle_normalization/promotion_candidate_families.json",
    "crates/oxfml_core/tests/fixtures/replay_bundle_normalization/promotion_readiness_index.json",
    "crates/oxfml_core/tests/fixtures/replay_bundle_normalization/pack_candidate_index.json",
    "crates/oxfml_core/tests/replay_adapter_and_witness_tests.rs",
    "crates/oxfml_core/tests/replay_retained_and_host_policy_tests.rs"
  ],
  "registry_version_refs": [
    {
      "registry_family": "predicate_kind",
      "registry_version": "oxfml.local.registry_pin.foundation_handoff_20260315_pass01"
    },
    {
      "registry_family": "mismatch_kind",
      "registry_version": "oxfml.local.registry_pin.foundation_handoff_20260315_pass01"
    },
    {
      "registry_family": "severity_class",
      "registry_version": "oxfml.local.registry_pin.foundation_handoff_20260315_pass01"
    },
    {
      "registry_family": "reduction_status",
      "registry_version": "oxfml.local.registry_pin.foundation_handoff_20260315_pass01"
    },
    {
      "registry_family": "witness_lifecycle_state",
      "registry_version": "oxfml.local.registry_pin.foundation_handoff_20260315_pass01"
    },
    {
      "registry_family": "capability_level",
      "registry_version": "oxfml.local.registry_pin.foundation_handoff_20260315_pass01"
    }
  ],
  "rollout_notes": [
    "OxFml remains authoritative for artifact meaning, typed rejects, fence semantics, and trace taxonomy.",
    "Normalized replay families are additive cross-lane transport and explanation aids only.",
    "Current capability claims are local-witness-tier claims and do not imply pack-grade promotion.",
    "Witness distillation is locally evidenced for a broader retained-local floor, including host and empirical-oracle families, but is not claimed as a capability level in this manifest.",
    "Normalized pack-candidate bundles are local non-pack-eligible evidence and do not imply cap.C5.pack_valid."
  ]
}
```

## Source: `OxFml/docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`

# OxFml Replay Appliance Adapter V1

## 1. Purpose
This document defines the OxFml-local adapter contract for the Foundation Replay appliance rollout.

It adapts the Foundation `DNA ReCalc` replay governance model into the OxFml canonical spec set without transferring OxFml semantic ownership to Foundation or to generic replay tooling.

Read together with:
1. `OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
2. `OXFML_CANONICAL_ARTIFACT_SHAPES.md`
3. `OXFML_MINIMUM_SEAM_SCHEMAS.md`
4. `OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
5. `fec-f3e/FEC_F3E_DESIGN_SPEC.md`
6. `fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
7. `fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
8. `fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`

## 2. Scope and Non-Goals
### 2.1 Scope
This adapter specification covers:
1. projection from OxFml artifact families into replay bundle objects,
2. replay-preserved identity and fence rules,
3. fixture-family import into `DNA ReCalc` bundle workflows,
4. normalized event-family mapping,
5. adapter capability claims and limits,
6. registry version pins and witness lifecycle usage,
7. rollout rules for local witness evidence versus future retained and promoted witnesses.

### 2.2 Non-goals
This pass does not:
1. replace OxFml-owned formula semantics, evaluator facts, reject meanings, or trace kinds,
2. authorize formula-text rewrites,
3. authorize bind-payload rewrites,
4. authorize fence-tuple rewrites,
5. authorize capability-view rewrites,
6. claim `cap.C4.distill_valid`,
7. claim `cap.C5.pack_valid`,
8. define a new OxFml-local scenario DSL.

## 3. Authority Split and Explicit Conflict Handling
The authority split is:
1. OxFml owns formula-language semantics, evaluator and seam artifact meanings, canonical identity categories, fence rules, typed reject semantics, and typed effect semantics.
2. Foundation owns replay rollout governance for normalized bundle transport, registry ids, capability-level governance, witness lifecycle states, and cross-lane replay tooling policy.
3. `DNA ReCalc` may normalize transport, correlation, comparison, and lifecycle metadata, but it may not redefine OxFml artifact meaning.

Explicit conflict rule:
1. if Foundation generic replay wording would flatten a typed OxFml artifact into a generic event label, OxFml semantics win and the replay adapter must preserve the OxFml source kind plus a normalized family mapping,
2. if Foundation distillation policy would permit generic rewrites, OxFml currently constrains replay-safe transforms to subset and projection transforms only,
3. if Foundation bundle policy implies one generic id family, OxFml preserved identity categories remain distinct inside the normalized bundle.

## 4. Bundle Projection Rules For The OxFml Artifact Ladder
The adapter projects the OxFml artifact ladder as follows:

1. `FormulaSourceRecord`
   - projected as scenario input identity and source-artifact references,
   - large textual bodies may remain sidecar-backed.
2. `GreenTreeRoot`
   - projected by source-artifact reference or sidecar,
   - never required inline at every lifecycle event.
3. `BoundFormula`
   - projected by source-artifact reference, bind identity fields, and optional sidecar.
4. `SemanticPlan`
   - projected by plan identity, execution-profile summary, helper-environment profile, and optional sidecar.
5. `PreparedCall`
   - projected as event payload or sidecar-backed call packet at prepare/execute boundaries.
6. `PreparedResult`
   - projected as candidate-facing result payload or sidecar-backed call-result packet.
7. evaluator facts
   - projected either inline in normalized event payloads or by typed fact refs,
   - never flattened into prose-only diagnostics.
8. `AcceptedCandidateResult`
   - projected to normalized `candidate.*` families and candidate view material.
9. `CommitBundle`
   - projected to normalized `publication.*` families and published-view material.
10. `RejectRecord`
   - projected to normalized `reject.*` families and reject-set material.

Projection rules:
1. the normalized replay model is additive transport, not replacement semantics,
2. source schema ids and source artifact refs remain mandatory,
3. if a payload body is too large for inline replay transport, the adapter must preserve a sidecar ref plus content fingerprint,
4. explicit missing or opaque markers must be used where a normalized field cannot be populated honestly.

## 5. Preserved Identity Categories And Fence-Related Keys
The adapter must preserve the OxFml identity categories from `OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`:
1. stable ids,
2. version keys,
3. content fingerprints,
4. runtime handles,
5. fence tuple members.

The minimum replay-preserved identity and fence set is:
1. `formula_stable_id`,
2. `formula_text_version` where the source fixture or host surface distinguishes it,
3. `formula_token`,
4. `green_tree_key` and/or `green_tree_fingerprint` where syntax bodies are projected,
5. `structure_context_version`,
6. `bind_hash`,
7. `semantic_plan_key` and optional `semantic_plan_fingerprint`,
8. `snapshot_epoch`,
9. `profile_version`,
10. `capability_view_key` where present,
11. `session_id`,
12. `commit_attempt_id`,
13. `commit_bundle_fingerprint` where present,
14. `reject_record_fingerprint` where present.

Replay rule:
1. runtime handles may appear only as auxiliary correlation metadata,
2. runtime handles may not become the only replay identity,
3. configuration and capture-mode context may be additive replay metadata,
4. additive replay metadata may not rewrite or substitute for OxFml fence meaning.

## 6. Fixture-Family Import Rules
The adapter imports current OxFml fixture families as first-class replay sources.

Current import mapping:
1. `parse_bind_cases.json`
   - source family: parse/bind witness
   - replay role: source artifact and schema witness import
2. `semantic_plan_replay_cases.json`
   - source family: semantic-plan witness
   - replay role: semantic plan, helper profile, and execution-profile import
3. `prepared_call_replay_cases.json`
   - source family: prepared-call/result witness
   - replay role: prepare/execute call packet import
4. `fec_commit_replay_cases.json`
   - source family: candidate/commit/reject witness
   - replay role: transaction-boundary scenario import
5. `execution_contract_replay_cases.json`
   - source family: execution-profile witness
   - replay role: scheduler-facing effect and restriction import
6. `session_lifecycle_replay_cases.json`
   - source family: session lifecycle witness
   - replay role: lifecycle phase and reject-path import
7. `single_formula_host_replay_cases.json`
   - source family: proving-host witness
   - replay role: host-level scenario import
   - first-host helper note: the direct host may first project `HostRecalcOutput` through `to_first_host_replay_capture_packet()` before wider replay normalization
8. `empirical_oracle_scenarios.json`
   - source family: empirical-oracle witness
   - replay role: oracle comparison and explain import

Import rules:
1. source fixture family names remain preserved,
2. scenario ids must remain stable across repeated normalization of the same fixture case,
3. import may add bundle envelope, registry bindings, and lifecycle metadata,
4. import may not rewrite formula text, bind payloads, fence tuples, or capability views in this pass.

## 7. Normalized Event-Family Mapping
The normalized family mapping for OxFml is:

1. session boundaries
   - `PrepareStarted`, `PrepareRejected`, `SessionOpened`, `CapabilityViewResolved`, `ExecuteStarted`, `ExecuteCompleted`
   - normalized families: `session.*`
2. candidate boundaries
   - `AcceptedCandidateResultBuilt`
   - normalized families: `candidate.*`
3. commit/publication boundaries
   - `CommitStarted`, `CommitAccepted`
   - normalized families: `publication.*`
4. reject boundaries
   - `RejectIssued`, `FenceMismatchRejected`, `CapabilityDeniedRejected`, `SessionExpiredRejected`
   - normalized families: `reject.*`
5. effect boundaries
   - `DynamicReferenceDiscovered`, `SpillEventObserved`, `FormatDependencyObserved`, `OverlayRegistered`, `OverlayEvicted`
   - normalized families: `dependency.*`, `spill.*`, `host_query.*`, or `overlay.*` as appropriate

Mapping rules:
1. OxFml source event kinds remain authoritative and must be preserved in bundle payloads,
2. normalized families are used for cross-lane diff and explain indexing only,
3. candidate-versus-publication distinction is mandatory and may not be collapsed into one result family,
4. reject-is-no-publish semantics remain OxFml-owned and must survive normalization.

## 8. Adapter Capability Target And Known Limits
The OxFml target for this rollout is:
1. claim `cap.C0.ingest_valid`,
2. claim `cap.C1.replay_valid`,
3. claim `cap.C2.diff_valid`,
4. claim `cap.C3.explain_valid`,
5. scaffold but do not claim `cap.C4.distill_valid`,
6. do not claim `cap.C5.pack_valid`.

Known limits for this pass:
1. no replay-safe formula-text rewrite family is declared,
2. no replay-safe bind rewrite family is declared,
3. no replay-safe fence rewrite family is declared,
4. no replay-safe capability-view rewrite family is declared,
5. subsystem schema merge strategy versus one unified replay trace schema remains open,
6. current source schema ids for adapter import are still OxFml-local identifiers rather than published machine-readable schema ids,
7. witness distillation is now locally evidenced for a narrow retained-local floor, but not yet at pack-grade breadth,
8. normalized pack-candidate bundle evidence is local-only and non-pack-eligible in this pass.

## 9. Registry Version Pins
Until Foundation publishes machine-readable registry snapshots, OxFml pins the replay governance families to the authoritative Foundation handoff package:
1. local pin name: `oxfml.local.registry_pin.foundation_handoff_20260315_pass01`
2. source root: `..\\Foundation\\research\\runs\\20260315-215019-replay-appliance-authoritative-pass-01\\outputs`

Pinned registry families for this pass:
1. `predicate_kind`
2. `mismatch_kind`
3. `severity_class`
4. `reduction_status`
5. `witness_lifecycle_state`
6. `capability_level`

Pinning rule:
1. registry entry ids come from the Foundation handoff vocabulary,
2. OxFml may add local-only auxiliary ids for reduction-unit anchors or source schema ids,
3. any local-only auxiliary id must carry the `oxfml.local.*` prefix and must not be confused with Foundation registry ids.

## 10. Witness Lifecycle And Quarantine Usage Rules
OxFml adopts the Foundation witness lifecycle and quarantine families as rollout governance, not as semantic truth.

Rules:
1. local replay bundles and replay fixtures may be normalized and replayed without immediately becoming retained witnesses,
2. explanatory-only and quarantined witnesses are not pack-eligible,
3. quarantined witnesses remain indexable and explain-addressable,
4. retained or promoted witness claims require explicit lifecycle refs,
5. witness lifecycle state never changes the meaning of OxFml candidate, commit, or reject artifacts,
6. lifecycle state only governs retention, promotion, quarantine, and GC policy.

Current expected lifecycle use in OxFml:
1. current local fixtures are local witness evidence,
2. future reduced witnesses from `W010` begin at `wit.generated_local`,
3. explanatory-only reductions should use `wit.explanatory_only`,
4. quarantine reasons should use Foundation families such as `oracle_unstable`, `capture_insufficient`, `schema_incompatible`, or `replay_invalid`.

Current local extension:
1. reduced witnesses broadened after `W010` may move directly to `wit.retained_local` when replay-valid closure is exercised and no quarantine reason applies,
2. normalized pack-candidate bundles remain local-only evidence and are not themselves witness lifecycle promotions,
3. the current retained-local floor now spans FEC commit/reject, session rejection, execution contract, single-formula host, and empirical-oracle families.

## 11. Open Alignment Items
The current OxFml replay rollout still carries these alignment items:
1. `capability_view_key` is checked today but remains open as a first-class fence tuple member,
2. subsystem schema merge strategy versus one unified replay trace schema remains open,
3. some code and minimum-schema surfaces still need closure around fields such as `reject_record_id` and `fence_snapshot_ref`,
4. `BindMismatchContext` still needs tighter exercised closure between prose, code, and replay normalization,
5. helper-form and scalarization provenance continue to narrow with the OxFunc boundary,
6. current reduced-witness breadth is still narrow and local,
7. normalized pack-candidate bundle evidence exists only as local rehearsal and remains intentionally non-pack-eligible,
8. current retained-witness set breadth is stronger than the first rehearsal floor but still not broad enough for a `cap.C4.distill_valid` claim,
9. DNA OneCalc host-policy and empirical-pack planning are now explicit, but remain planning-only and non-pack-grade.

## 12. Working Rule
Use this adapter document as the OxFml-local replay rollout authority for:
1. bundle projection over typed OxFml artifacts,
2. conservative capability claims,
3. registry and lifecycle pinning for current replay governance,
4. witness rollout planning into `W009` and `W010`.

Do not use this document to weaken OxFml-owned semantic meaning or to authorize generic replay rewrites that OxFml has not declared replay-safe.

## Source: `OxFml/docs/spec/OXFML_SYSTEM_DESIGN.md`

# OxFml System Design

## 1. Purpose
This document is the top-level OxFml system design for the formula-processing and single-node evaluation lane.

It defines:
1. the canonical internal structure of the OxFml library and repository,
2. the relationship between formula parsing, binding, semantic planning, evaluation, and FEC/F3E publication,
3. the boundaries with OxFunc and OxCalc,
4. the formal-model and verification posture that OxFml must carry from the start.

## 2. Architectural Role in DNA Calc
OxFml is the permanent lane owner for:
1. Excel-compatible formula language processing,
2. full-fidelity syntax and versioned formula views,
3. bind/reference normalization and evaluator-side dependency evidence,
4. single-node evaluation semantics,
5. the evaluator side of the FEC/F3E seam,
6. evaluator-side reject and trace structures.

OxFml is not:
1. the owner of global scheduling policy,
2. the owner of workbook-wide dependency closure strategy,
3. the owner of function-kernel semantics,
4. a host-specific pathfinder implementation repo.

## 3. Canonical Bootstrap Reading Order
When bootstrapping OxFml design work, read this local spec set in this order:
1. `docs/spec/OXFML_SYSTEM_DESIGN.md`
2. `docs/spec/OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
3. `docs/spec/OXFML_IMPLEMENTATION_BASELINE.md`
4. `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
5. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
6. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
7. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
8. `docs/spec/OXFML_HIGH_RISK_AND_EARLY_ATTENTION_AREAS.md`
9. `docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
10. `docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
11. `docs/spec/OXFML_FORMALIZATION_AND_VERIFICATION.md`
12. `docs/spec/OXFML_FORMAL_ARTIFACT_REGISTER.md`
13. `docs/spec/formula-language/README.md`
14. `docs/spec/formula-language/OXFML_FORMULA_ENGINE_ARCHITECTURE.md`
15. `docs/spec/formula-language/OXFML_PARSER_AND_BINDER_REALIZATION.md`
16. `docs/spec/formula-language/OXFML_NORMALIZED_REFERENCE_ADTS.md`
17. `docs/spec/formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`
18. `docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`
19. `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
20. `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
21. `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
22. `docs/spec/formula-language/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`
23. `docs/spec/formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`

Historical transition material lives under archive paths and is not part of bootstrap reading.

## 4. Internal Library Structure
OxFml should be organized as a coherent library with these major subsystems:

1. `syntax`
   - tokenization,
   - green syntax trees,
   - red contextual views,
   - full-fidelity round-tripping.
2. `binding`
   - name and table resolution,
   - address-mode and caller-context application,
   - normalized references,
   - dependency seed extraction.
3. `semantics`
   - operator and function dispatch planning,
   - OxFunc catalog integration,
   - evaluation-mode classification,
   - fast-path classification.
4. `evaluation`
   - prepared-argument/result construction,
   - reference-preserving execution,
   - dynamic dependency discovery,
   - spill and formatting overlay discovery.
5. `fec_f3e`
   - evaluator session lifecycle,
   - capability view,
   - commit bundle construction,
   - reject taxonomy,
   - seam trace emission.
6. `replay_and_conformance`
   - scenario definitions,
   - replay bundles,
   - conformance-matrix integration,
   - deterministic trace validation.
7. `formal`
   - Lean-oriented ADT/spec surfaces,
   - TLA+-oriented session/concurrency models,
   - proof/pack obligation mapping.

This decomposition is conceptual first and implementation-oriented second. Exact source-tree layout may evolve, but the separation of concerns must remain.

## 5. Layer Relationships
The canonical OxFml flow is:
1. formula text enters `syntax`,
2. contextual views flow into `binding`,
3. bound formulas compile into `semantics`,
4. execution uses `evaluation` plus OxFunc metadata,
5. publication uses `fec_f3e`,
6. replay and proofs consume emitted artifacts from all prior layers.

No layer is allowed to erase distinctions that a downstream layer depends on semantically.

## 6. Ownership and Stateful-vs-Stateless Posture
The implementation plan for API shape and runtime ownership is still intentionally open.

The canonical option analysis for this topic is:
1. `docs/spec/OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`

The canonical vocabulary for identities, version keys, fingerprints, and runtime handles is:
1. `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`

The canonical field surfaces for the main artifact families are:
1. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`

The canonical minimum schema objects for seam payload families are:
1. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`

The canonical taxonomy layer for deltas, evaluator facts, reject contexts, and trace events is:
1. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`

The current implementation-start baseline is:
1. `docs/spec/OXFML_IMPLEMENTATION_BASELINE.md`

The current early-risk register is:
1. `docs/spec/OXFML_HIGH_RISK_AND_EARLY_ATTENTION_AREAS.md`

The current public API and runtime-service baseline is:
1. `docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`

The current test ladder and proving-host model are:
1. `docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`

The current formal planning register is:
1. `docs/spec/OXFML_FORMAL_ARTIFACT_REGISTER.md`

What is already fixed:
1. parse trees and other core semantic artifacts must admit immutable versioned representations,
2. those artifacts must be suitable for inclusion in larger immutable workbook/document structures above OxFml,
3. formula meaning must be explainable from explicit artifacts plus explicit context, not from hidden mutation.

What remains open:
1. whether the public implementation surface is mostly stateless or exposed as long-lived services,
2. whether parse-tree and bind-artifact storage is primarily host-owned, OxCalc-owned, or packaged behind OxFml repositories,
3. how much execution-state residency is retained between evaluations.

Constraint:
1. even if implementations maintain caches, indexes, or evaluator session registries, those must be optimization state,
2. canonical semantic truth must still be representable in a stateless, replayable form,
3. persistent workbook/document ownership above the evaluator belongs to the enclosing host or coordinator, not to ephemeral execution sessions.

## 7. Boundary with OxFunc
OxFunc is the downstream semantic companion library.

OxFml depends on OxFunc for:
1. function identifiers,
2. function profiles and traits,
3. argument evaluation rules,
4. coercion rules,
5. may-return-reference behavior,
6. locale and format service needs,
7. reduction-order constraints where deterministic execution depends on them,
8. query classification and result-shaping policy for typed host-query functions such as `CELL` and `INFO`.

OxFml must not force OxFunc to recover distinctions that OxFml erased.

The canonical OxFml-local statement of this boundary is:
1. `docs/spec/formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`

That document is the primary local promotion of the active OxFunc upstream `NOTES_FOR_OXFML` requirements.

## 8. Boundary with OxCalc
OxCalc is the upstream coordinator and multi-node engine owner.

OxFml provides OxCalc with:
1. typed commit bundles,
2. overlay-derived topology facts,
3. typed rejects,
4. replay-stable traces,
5. evaluator-side capability and bind evidence.

OxCalc retains ownership of:
1. dirty closure,
2. scheduling and publication policy,
3. fairness and visibility policy,
4. multi-session contention policy.

OxCalc is also the likely owner of higher immutable workbook/document structures in the integrated mode, though the precise storage surface remains open.

## 9. Host Modes
OxFml must support two major consumption modes:

1. **OxCalc-integrated mode**
   - full evaluator seam usage against coordinator-owned snapshot and policy state.
2. **DNA OneCalc mode**
   - single-node proving host using OxFml and OxFunc without OxCalc dependency closure or scheduler policy.

The pre-DNA-OneCalc proving-host ladder is defined in:
1. `docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`

DNA OneCalc proves the OxFml/OxFunc lane. It does not define the lane.

## 10. Formal and Assurance Posture
OxFml is part of DNA Calc's near-formal core.

From the start, OxFml specs must be written so they can support:
1. Lean ADTs and invariants for syntax, bind outputs, prepared-call contracts, and reject structures,
2. TLA+ models for concurrent evaluator sessions and commit/publish rules,
3. deterministic replay bundles for semantic and concurrency-sensitive scenarios,
4. explicit mapping from each important contract clause to a proof, model check, or conformance pack.

## 11. Working Rule
Canonical OxFml design docs must describe:
1. the intended baseline architecture,
2. the intended formal and replay obligations,
3. the declared open lanes.

They must not present legacy pathfinder implementation text as the current OxFml baseline.

## Source: `OxFml/docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`

# OxFml Test Ladder and Proving Hosts

## 1. Purpose
This document defines the canonical OxFml test ladder and the proving-host model used to exercise the lane before full multi-node integration.

It exists to make explicit:
1. the minimal local bootstrap evaluator surface inside OxFml,
2. the boundary between OxFml-local testing and OxFunc-backed semantic testing,
3. the single-formula host model that precedes broader DNA OneCalc specification work,
4. the role of Excel empirical runs as behavior oracle for whole-formula semantics.

Read together with:
1. `OXFML_IMPLEMENTATION_BASELINE.md`
2. `OXFML_HIGH_RISK_AND_EARLY_ATTENTION_AREAS.md`
3. `OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
4. `OXFML_EMPIRICAL_PACK_PLANNING.md`
5. `fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
6. `fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`

## 2. Working Rule
OxFml should not wait for a full downstream function universe before it can test its own parser, binder, evaluator, and seam surfaces.

At the same time, OxFml should not re-implement OxFunc.

The test ladder therefore separates:
1. a very small local bootstrap semantic kernel,
2. OxFunc-backed downstream semantic execution,
3. host-level formula proving,
4. empirical Excel-oracle verification.

## 3. Canonical Test Ladder
The current canonical ladder is:

### 3.1 Layer 1: Local Unit and Artifact Fixtures
Purpose:
1. validate parser, green/red, binder, normalized references, schema objects, and trace shapes.

Typical coverage:
1. syntax fidelity,
2. bind normalization,
3. artifact identity/version behavior,
4. minimum schema objects,
5. candidate/commit/reject/trace structural fixtures.

### 3.2 Layer 2: Minimal Local Bootstrap Evaluator
Purpose:
1. let OxFml exercise evaluator-owned behavior quickly without depending on the full OxFunc function surface.

Boundary rule:
1. this layer is intentionally tiny,
2. it exists only to bootstrap OxFml-owned testing and benchmark loops,
3. it must not become a shadow OxFunc.

Current intended scope:
1. literals,
2. basic operators,
3. a tiny fixture function set or probe/test-only functions,
4. defined-name lookup with mutable supplied values,
5. enough execution to exercise parse -> bind -> evaluate -> candidate/commit/reject/trace paths.

### 3.3 Layer 3: OxFunc-Backed Semantic Execution
Purpose:
1. test OxFml prepared-call/result behavior against the real downstream function-semantic lane.

Boundary rule:
1. beyond the minimal bootstrap kernel, OxFml should use OxFunc outputs rather than re-implementing function semantics locally.

Expected inputs from OxFunc:
1. function definitions and traits,
2. prepared-call/result expectations,
3. semantic baselines or fixture outputs where available.

### 3.4 Layer 4: Single-Formula Recalc Host
Purpose:
1. exercise hosting, update, recompute, and FEC/F3E behavior in a controlled proving environment.

The current intended scope is:
1. one formula under test,
2. no upstream formula dependency graph,
3. defined names, direct cell bindings, or host-supplied bindings as mutable inputs,
4. full recompute or full update semantics,
5. candidate/commit/reject/trace behavior,
6. enough host structure to model caller context, profile, locale, date-system, host-query capabilities, and artifact reuse where needed.

Current exercised local floor:
1. defined-name update and reuse-sensitive recalc,
2. reference-sensitive scalarization through `@` and `_xlfn.SINGLE`,
3. helper-form evaluation through `LET` and callable `LAMBDA`,
4. spill-shaped publication through `SEQUENCE`,
5. formatting-sensitive host runs through `TEXT`,
6. host-query-sensitive host runs through `INFO` and `CELL("filename", ...)`.

This is the direct precursor to the later DNA OneCalc host specification.
It is an OxFml proving-host model first, not a full host/product definition.
The current DNA OneCalc-facing host policy baseline is recorded in:
1. `OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`

### 3.5 Layer 5: Excel Empirical Oracle Runs
Purpose:
1. use Excel behavior as the executable oracle for formula-level semantics.

Current target use:
1. parse/normalization behavior,
2. formula evaluation behavior in the single-formula host model,
3. `@`, `#`, `SINGLE`, `LET`, `LAMBDA`, host-query, spill, and formatting-sensitive lanes,
4. update/recalc behavior when defined-name inputs change.

Current exercised local floor:
1. `TEXT` locale-sensitive formatting,
2. `INFO("directory")` host-query semantics,
3. `CELL("filename", ref)` host-query semantics with typed reference input,
4. `@` and `_xlfn.SINGLE` scalarization over reference-like inputs,
5. helper-form invocation through `LET` and `LAMBDA`,
6. spill-shaped array publication through `SEQUENCE(2)`.

Rule:
1. empirical Excel runs are not implementation substitutes,
2. they are the behavior oracle for disputed or under-specified formula semantics.

Current machine-readable empirical-pack planning artifacts are:
1. `crates/oxfml_core/tests/fixtures/empirical_pack_planning/dna_onecalc_host_policy_profiles.json`
2. `crates/oxfml_core/tests/fixtures/empirical_pack_planning/empirical_pack_candidate_groups.json`

### 3.6 Layer 6: Replay and Formal Witnesses
Purpose:
1. turn tested behavior into durable replay, Lean, and TLA+ witness artifacts.

This layer closes the loop between:
1. local fixtures,
2. bootstrap evaluator runs,
3. OxFunc-backed runs,
4. single-formula host runs,
5. Excel oracle comparisons.

## 4. Minimal Local Bootstrap Evaluator Rule
The minimal local bootstrap evaluator must stay intentionally constrained.

Allowed goals:
1. quick OxFml-owned regression checks,
2. parser/binder/evaluator path bring-up,
3. seam payload and trace bring-up,
4. benchmark and profiling harnesses for OxFml-owned code paths.

Disallowed drift:
1. broad function-family reimplementation,
2. independent semantic ownership for real Excel functions,
3. divergence from OxFunc function semantics for non-fixture lanes.

## 5. Single-Formula Proving Host Model
The current proving-host model should support:
1. one formula source record,
2. one green/root and bind/semantic-plan path,
3. mutable defined-name inputs supplied by the host,
4. mutable direct cell bindings where a reference-sensitive formula needs concrete cell resolution,
5. explicit recalc trigger and full recompute semantics,
6. replay-stable candidate, commit, reject, and trace outputs.

Working rule:
1. direct cell bindings are not an optional convenience where reference-sensitive truth depends on concrete cell state,
2. host models that omit them should not claim coverage of scalarization, spill-linked, or host-query lanes that require real cell resolution.

It should not require:
1. a workbook-wide formula graph,
2. dependency closure across multiple formulas,
3. OxCalc scheduler policy.

## 6. Empirical Oracle Scaffolding Rule
OxFml should have empirical scaffolding similar in spirit to OxFunc's Excel-compat runs, but formula-oriented.

The scaffolding should make it easy to capture:
1. entered formula,
2. stored formula if different,
3. bound or normalized context summary,
4. input binding set for defined names and any required direct cell bindings,
5. observed Excel result class and value,
6. any relevant host/query/format context,
7. reproducible scenario ids for replay comparison.

Working rule:
1. empirical-oracle scenarios should not hide direct cell state inside ad hoc prose when that state is semantically required,
2. if a scenario depends on concrete cell resolution, the cell bindings belong in the scenario artifact.

## 7. Workset Implications
Current expected primary owners:
1. `W002`: local unit and artifact fixtures; minimal bootstrap evaluator framing; single-formula host artifact model
2. `W003`: OxFunc-backed semantic execution boundary and fixture planning
3. `W004`: single-formula recalc host behavior through FEC/F3E and schema fixtures
4. `W005`: replay/formal witnesses for the ladder outputs
5. `W006`: formatting and host-query proving scenarios within the same ladder

## 8. Working Rule
Before implementation broadens:
1. make the ladder explicit,
2. keep the local bootstrap evaluator minimal,
3. use OxFunc for real downstream semantic breadth,
4. build the single-formula host model before broader host assumptions,
5. keep Excel empirical runs as the behavior oracle for whole-formula semantics.

## 9. Current Local Witness Floor
The current local witness floor for the ladder is:
1. Layer 1 parse/bind fixtures: `crates/oxfml_core/tests/fixtures/parse_bind_cases.json`
2. Layer 3 OxFunc-backed prepared-call/result fixtures: `crates/oxfml_core/tests/fixtures/prepared_call_replay_cases.json`
3. Layer 4 single-formula host fixtures: `crates/oxfml_core/tests/fixtures/single_formula_host_replay_cases.json`
   Current exercised lanes: reuse-sensitive recalc, `@`, `_xlfn.SINGLE`, `LET`, `LAMBDA`, `SEQUENCE`, `TEXT`, `INFO`, and `CELL("filename", ...)`
4. Layer 5 empirical-oracle scenario shapes: `crates/oxfml_core/tests/fixtures/empirical_oracle_scenarios.json`
   Current exercised lanes: formatting, host-query, scalarization, helper forms, spill publication, and seam-significant `format_delta` / `display_delta`
5. Layer 6 execution/replay fixtures: `crates/oxfml_core/tests/fixtures/semantic_plan_replay_cases.json`, `crates/oxfml_core/tests/fixtures/fec_commit_replay_cases.json`, and `crates/oxfml_core/tests/fixtures/execution_contract_replay_cases.json`

Current proving-host discipline:
1. direct cell bindings are preserved where scalarization, host-query, or reference-sensitive replay depends on them,
2. host and empirical fixtures should expand in the same wave when new seam-significant format, display, or topology facts are added,
3. promotion-readiness planning for host and empirical families remains local-only until broader replay promotion work authorizes more.

## Source: `OxFml/docs/spec/README.md`

# OxFml Spec Index

This directory is the canonical OxFml spec set for the formula-processing and single-node evaluator lane.

## Bootstrap Set
When starting OxFml design or implementation work, read these documents and ignore archive paths unless you are doing migration archaeology:

1. `docs/spec/OXFML_SYSTEM_DESIGN.md`
2. `docs/spec/OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
3. `docs/spec/OXFML_IMPLEMENTATION_BASELINE.md`
4. `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
5. `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
6. `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
7. `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
8. `docs/spec/OXFML_HIGH_RISK_AND_EARLY_ATTENTION_AREAS.md`
9. `docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
10. `docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`
11. `docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`
12. `docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
13. `docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
14. `docs/spec/OXFML_EMPIRICAL_PACK_PLANNING.md`
15. `docs/spec/OXFML_FORMALIZATION_AND_VERIFICATION.md`
16. `docs/spec/OXFML_FORMAL_ARTIFACT_REGISTER.md`
17. `docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
18. `docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
19. `docs/spec/formula-language/OXFML_FORMULA_ENGINE_ARCHITECTURE.md`
20. `docs/spec/formula-language/OXFML_PARSER_AND_BINDER_REALIZATION.md`
21. `docs/spec/formula-language/OXFML_NORMALIZED_REFERENCE_ADTS.md`
22. `docs/spec/formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`
23. `docs/spec/formula-language/OXFML_OXFUNC_LET_LAMBDA_PIN_DOWN_PREP.md`
24. `docs/spec/formula-language/OXFML_OXFUNC_LIBRARY_CONTEXT_RUNTIME_INTERFACE.md`
25. `docs/spec/formula-language/OXFML_R1C1_FORMULA_CHANNEL.md`
26. `docs/spec/formula-language/OXFML_CF_DV_RESTRICTED_SUBLANGUAGES.md`
27. `docs/spec/formula-language/OXFML_HOST_MANAGED_NAME_AND_EXTERNAL_NAME_BOUNDARY.md`
28. `docs/spec/formula-language/OXFML_STRUCTURED_REFERENCE_AND_TABLE_BOUNDARY.md`
29. `docs/spec/formula-language/OXFML_EDITOR_LANGUAGE_SERVICE_AND_HOST_INTEGRATION_PLAN.md`
30. `docs/spec/formula-language/OXFML_OXFUNC_EVALUATION_ADAPTER_AND_TEST_ARTIFACTS.md`
31. `docs/spec/formula-language/OXFML_REGISTERED_EXTERNAL_PROVIDER_AND_CALL_REGISTER_ID_BOUNDARY.md`
32. `docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`
33. `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
34. `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
35. `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
36. `docs/spec/formula-language/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`
37. `docs/spec/formula-language/MS_OE376_FORMULA_AND_FORMATTING_REVIEW.md`
38. `docs/spec/formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`

## Canonical Document Groups
### System and formal posture
- `docs/spec/OXFML_SYSTEM_DESIGN.md`
- `docs/spec/OXFML_IMPLEMENTATION_SURFACES_AND_STATE_OPTIONS.md`
- `docs/spec/OXFML_IMPLEMENTATION_BASELINE.md`
- `docs/spec/OXFML_ARTIFACT_IDENTITIES_AND_VERSION_KEYS.md`
- `docs/spec/OXFML_CANONICAL_ARTIFACT_SHAPES.md`
- `docs/spec/OXFML_MINIMUM_SEAM_SCHEMAS.md`
- `docs/spec/OXFML_DELTA_EFFECT_TRACE_AND_REJECT_TAXONOMIES.md`
- `docs/spec/OXFML_HIGH_RISK_AND_EARLY_ATTENTION_AREAS.md`
- `docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
- `docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`
- `docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
- `docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
- `docs/spec/OXFML_EMPIRICAL_PACK_PLANNING.md`
- `docs/spec/OXFML_FORMALIZATION_AND_VERIFICATION.md`
- `docs/spec/OXFML_FORMAL_ARTIFACT_REGISTER.md`
- `docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
- `docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`

### Replay appliance rollout
- `docs/spec/OXFML_REPLAY_APPLIANCE_ADAPTER_V1.md`
- `docs/spec/OXFML_REPLAY_ADAPTER_CAPABILITY_MANIFEST_V1.json`
- `docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
- `docs/spec/OXFML_EMPIRICAL_PACK_PLANNING.md`
- `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
- `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
- `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`

### Host and runtime contract
- `docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`
- `docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`
- `docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
- `docs/spec/OXFML_TEST_LADDER_AND_PROVING_HOSTS.md`
- `docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`

### Formula engine
- `docs/spec/formula-language/README.md`
- `docs/spec/formula-language/OXFML_FORMULA_ENGINE_ARCHITECTURE.md`
- `docs/spec/formula-language/OXFML_PARSER_AND_BINDER_REALIZATION.md`
- `docs/spec/formula-language/OXFML_NORMALIZED_REFERENCE_ADTS.md`
- `docs/spec/formula-language/OXFML_OXFUNC_SEMANTIC_BOUNDARY.md`
- `docs/spec/formula-language/OXFML_OXFUNC_LET_LAMBDA_PIN_DOWN_PREP.md`
- `docs/spec/formula-language/OXFML_OXFUNC_LIBRARY_CONTEXT_RUNTIME_INTERFACE.md`
- `docs/spec/formula-language/OXFML_R1C1_FORMULA_CHANNEL.md`
- `docs/spec/formula-language/OXFML_CF_DV_RESTRICTED_SUBLANGUAGES.md`
- `docs/spec/formula-language/OXFML_HOST_MANAGED_NAME_AND_EXTERNAL_NAME_BOUNDARY.md`
- `docs/spec/formula-language/OXFML_STRUCTURED_REFERENCE_AND_TABLE_BOUNDARY.md`
- `docs/spec/formula-language/OXFML_EDITOR_LANGUAGE_SERVICE_AND_HOST_INTEGRATION_PLAN.md`
- `docs/spec/formula-language/OXFML_OXFUNC_EVALUATION_ADAPTER_AND_TEST_ARTIFACTS.md`
- `docs/spec/formula-language/OXFML_REGISTERED_EXTERNAL_PROVIDER_AND_CALL_REGISTER_ID_BOUNDARY.md`
- `docs/spec/formula-language/EXCEL_FORMULA_LANGUAGE_CONCRETE_RULES.md`
- `docs/spec/formula-language/EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv`
- `docs/spec/formula-language/MS_OE376_FORMULA_AND_FORMATTING_REVIEW.md`

### FEC/F3E seam
- `docs/spec/fec-f3e/README.md`
- `docs/spec/fec-f3e/FEC_F3E_DESIGN_SPEC.md`
- `docs/spec/fec-f3e/FEC_F3E_FORMAL_AND_ASSURANCE_MAP.md`
- `docs/spec/fec-f3e/FEC_F3E_TESTING_AND_REPLAY.md`
- `docs/spec/fec-f3e/FEC_F3E_SCHEMA_REPLAY_FIXTURE_PLAN.md`
- `docs/spec/fec-f3e/FEC_F3E_PROTOCOL_CONFORMANCE_MATRIX.csv`

### Formatting semantics
- `docs/spec/formatting/EXCEL_FORMATTING_HIERARCHY_AND_VISIBILITY_MODEL.md`

## Archive Rule
Historical transition material is kept under archive paths and is not part of the required bootstrap path.

## Mirror Policy
Foundation keeps read-only mirrors for conformance governance and cross-lane references.

## Source: `OxFml/docs/worksets/W048_editor_language_service_and_immutable_formula_host_plan.md`

# W048: Editor Language Service And Immutable Formula Host Plan

## Purpose
Plan the extended-scope formula-editor and language-service surface so OxFml can later serve as:
1. the canonical immutable formula subtree owner inside larger host document trees,
2. the source of live diagnostics and squiggle-ready spans,
3. the source of deterministic completion context,
4. the OxFunc-linked bridge for function help and signature help,
5. the validator for external intelligent completion proposals.

## Position and Dependencies
- **Depends on**: `W032`, `W041`, `W043`, `W045`
- **Blocks**: future implementation work for editor-grade parse/bind services, host editor integration, and OxFunc help-metadata seam narrowing
- **Cross-repo**: future OxFunc seam packet for function-help/signature metadata; future OxCalc/host packet for immutable formula-edit integration

## Scope
### In scope
1. Freeze the intended editor-grade green-tree and trivia model at planning level.
2. Freeze the intended immutable formula-edit packet and host-driven spine update rule at planning level.
3. Freeze the intended live diagnostics packet and severity/stage taxonomy at planning level.
4. Freeze the intended deterministic completion, function-help, signature-help, and external intelligent-completion packet boundaries at planning level.
5. Record the expected OxFunc and OxCalc seam consequences for later bounded rounds.

### Out of scope
1. Implementing the editor-grade substrate.
2. Delivering a real editor UI.
3. Delivering an LLM or external intelligent-completion service.
4. Promoting any new seam packet to shared frozen text.

## Deliverables
1. Canonical planning spec for the extended editor/language-service scope.
2. Explicit work breakdown for future execution slices.
3. Explicit OxFunc- and OxCalc-facing future seam questions.
4. Explicit rule that intelligent completion remains external and non-canonical.

## Closure Plan
The remaining `W048` lanes are no longer one undifferentiated backlog.
They now split cleanly into OxFml-internal execution work versus seam-freeze work.

### A. OxFml-internal execution work
These slices can continue locally without waiting for another repo:
1. trivia-owning green-token realization
   - extend the canonical green token/storage model so trivia is owned directly rather than projected later,
   - keep the current editor snapshot builder as a compatibility projection during transition,
   - add deterministic incremental-edit evidence proving unchanged subtrees survive trivia-preserving edits,
2. deterministic completion breadth
   - widen local completion beyond the current function/name/table/selector slice,
   - cover channel-sensitive assists such as more `R1C1` entry help and restricted-carrier assists,
   - keep all completion proposals replay-stable and deterministic,
3. editor replay evidence
   - add replay-facing or retained local witness artifacts for edit-result packets, diagnostics, and validated completion re-entry,
   - prove that editor packet identity is stable enough for later host/editor integration,
4. local packet hardening
   - keep refining `FormulaEditResult`, `LiveDiagnosticSnapshot`, and completion-validation artifacts until the host-facing seam packet is mostly a projection rather than a reinvention.

### B. Seam-freeze-only work
These lanes are now mostly a cross-repo packet-shape decision rather than an OxFml semantic unknown.

#### B1. OxFunc seam: function help and signature help
What remains here is mainly packet freeze, not local semantic discovery.
OxFml can already:
1. detect the active call site,
2. compute active argument index,
3. construct a deterministic `FunctionHelpLookupRequest`.

What now needs freezing with OxFunc:
1. whether help retrieval rides the existing runtime `LibraryContextProvider` or a sibling metadata/help provider,
2. the minimum help/signature response packet,
3. which fields are semantic truth versus presentation-only prose,
4. how runtime-registered extension functions participate under snapshot identity.

#### B2. OxCalc seam: immutable edit and validated intelligent-completion packets
What remains here is also mainly packet freeze, not formula semantics.
OxFml can already:
1. accept immutable formula-edit requests,
2. return new artifact identities, reuse summaries, diagnostics, and change ranges,
3. revalidate intelligent-completion proposals through the normal parse/bind path.

What now needs freezing with OxCalc:
1. the exact host/coordinator-facing edit packet,
2. the exact return packet for editor updates,
3. whether validated completion application is a host-local packet or a coordinator-visible packet,
4. how larger immutable workbook/document spine replacement is keyed and acknowledged outside OxFml.

## Next Execution Order
The recommended next order is:
1. finish OxFml-local trivia-owning green-token design and first exercised slice,
2. widen deterministic completion and editor replay evidence locally,
3. run a bounded `NOTES_FOR_OXFUNC` round on help/signature packet freezing,
4. run a bounded `NOTES_FOR_OXCALC` round on immutable edit and validated-completion packet freezing,
5. only after those packets converge, promote the editor host packet from local OxFml layer to shared seam text.

## Gate Model
### Entry gate
- Current parser/green/red architecture is strong enough to support a narrower extension plan.
- Host/runtime packet direction is converged enough to describe host-driven immutable updates honestly.

### Exit gate
- There is one canonical planning document for the editor-grade extension.
- The immutable update path, diagnostics/help/completion packet families, and seam implications are explicit rather than implied.
- Future execution order is explicit.

## Pre-Closure Verification Checklist

| # | Check | Yes/No |
|---|-------|--------|
| 1 | Spec text updated for all in-scope items? | |
| 2 | Conformance matrix rows updated? | |
| 3 | At least one deterministic replay artifact exists per in-scope behavior? | |
| 4 | Cross-repo impact assessed and handoff filed if needed? | |
| 5 | All required tests pass? | |
| 6 | No known semantic gaps remain in declared scope? | |
| 7 | Completion language audit passed (no premature "done"/"complete" per AGENTS.md Section 3)? | |
| 8 | IN_PROGRESS_FEATURE_WORKLIST.md updated? | |
| 9 | CURRENT_BLOCKERS.md updated (new/resolved)? | |

## Status
- execution_state: in_progress
- scope_completeness: scope_partial
- target_completeness: target_partial
- integration_completeness: partial
- open_lanes:
  - function help and signature help still stop at deterministic lookup-request construction; OxFunc-backed help payload retrieval is not yet integrated
  - OxCalc now reads the immutable edit request / result / validated completion split as the right first packetization, but no shared host/OxCalc immutable edit packet is frozen yet
  - containing-spine replacement and validated-completion acceptance are now converged as host/coordinator-owned, but no shared host-facing packet for validated intelligent-completion results is frozen yet
- current_local_floor:
  - `crates/oxfml_core/src/language_service/mod.rs` now provides a first OxFml-local language-service packet layer
  - live internal packet types now exist for editor syntax snapshots, formula-edit requests/results, explicit text-change ranges, live diagnostics, deterministic completion, completion-validation, signature-help context, function-help lookup requests, and intelligent-completion context
  - `apply_formula_edit(...)` now drives incremental parse/red/bind reuse plus optional semantic-plan follow-on for editor-host flows and reports the smallest local text-change range when a previous green tree is supplied
  - `build_live_diagnostics(...)` now unifies syntax, bind, and semantic-plan diagnostics into one squiggle/list-ready packet family
  - syntax-tree tokens now own canonical leading/trailing trivia directly in the green tree while the raw lexer stream remains available in `full_fidelity_tokens`
  - `collect_completion_proposals(...)`, `signature_help_context_at_cursor(...)`, `build_function_help_lookup_request(...)`, `validate_completion_candidate(...)`, `apply_completion_proposal(...)`, and `build_intelligent_completion_context(...)` now provide the first local deterministic editor-support floor, including `R1C1` syntax assists
  - deterministic local evidence now exists in `crates/oxfml_core/tests/language_service_tests.rs` and `crates/oxfml_core/tests/language_service_fixture_tests.rs`
- claim_confidence: draft

