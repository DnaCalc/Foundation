# Replay Appliance Architecture

## 1. Architectural Thesis
The Replay appliance should be a layered architecture:
1. lane-native capture remains local,
2. lane adapters project local artifacts into a shared normalized model,
3. a portable bundle carries the normalized model plus source-native sidecars,
4. shared runners, diff tools, explain tools, and witness distillers operate on the bundle,
5. pack export is produced from the bundle rather than from ad hoc lane scripts.

This preserves lane freedom while converging program-level tooling.

## 2. Architectural Layers

### 2.1 Layer A: Lane-native capture
Each lane emits its own current best artifact shape:
1. `OxCalc`: `TraceCalc` scenario runs, reference-machine runs, engine diffs, counters, views, rejects.
2. `OxFml`: fixture payloads, session lifecycle traces, candidate/commit/reject artifacts, schema witness packs.
3. `OxFunc`: manifest packets, execution records, output rows, evidence ids, correlation rows.
4. `OxVba`: conformance CSV/JSONL/markdown outputs, profile gates, clause coverage, deferred-oracle registers.

### 2.2 Layer B: Lane adapter
Each lane owns an adapter that maps lane-native artifacts into the shared Replay appliance model.

The adapter is responsible for:
1. projecting source ids and schema ids without losing meaning,
2. declaring missing or opaque fields explicitly,
3. mapping source artifact roots into bundle artifact refs,
4. preserving lane-native sidecars.

### 2.3 Layer C: Normalized replay model
This is the shared, portable model used by `DNA ReCalc`.

It is not source semantics.
It is the shared transport and explanation model.

### 2.4 Layer D: Bundle packaging
The normalized replay model is serialized into a portable bundle with:
1. manifests,
2. events,
3. views,
4. counters,
5. diffs,
6. reductions,
7. adapter capabilities,
8. registry snapshots and lifecycle records,
9. sidecars,
10. indexes,
11. source references.

### 2.5 Layer E: Shared tool surface
The bundle is the input to:
1. replay runner,
2. diff engine,
3. explain engine,
4. witness distiller,
5. pack exporter,
6. corpus indexer,
7. retention and GC tooling.

## 3. Canonical Objects

### 3.1 `ReplayBundleManifest`
Top-level bundle descriptor.

Required fields:
1. `bundle_schema_id`
2. `bundle_schema_version`
3. `bundle_id`
4. `source_lanes`
5. `created_by`
6. `normalizer_version`
7. `artifact_layout_version`
8. `source_inventory_ref`

### 3.2 `ReplayRunManifest`
One concrete run or imported source-run descriptor.

Required fields:
1. `run_id`
2. `lane_id`
3. `run_kind`
4. `profile_id`
5. `profile_version`
6. `config_fingerprint_ref`
7. `selection_ref`
8. `result_state_counts`
9. `source_artifact_roots`

### 3.3 `ReplayScenarioManifest`
Stable scenario or packet identity.

Required fields:
1. `scenario_id`
2. `scenario_kind`
3. `description`
4. `tags`
5. `pack_tags`
6. `generator_ref` or `source_manifest_ref`
7. `evidence_ids`
8. `clause_ids`

### 3.4 `ReplayEvent`
The shared event-envelope unit.

Required fields:
1. `replay_schema_id`
2. `source_schema_id`
3. `lane_id`
4. `run_id`
5. `scenario_id`
6. `event_id`
7. `event_seq`
8. `phase_kind`
9. `event_kind`
10. `profile_id`
11. `profile_version`
12. `correlation`
13. `payload_mode`
14. `payload`
15. `causal_parent_ids`
16. `tags`

### 3.5 `ReplayCounterSet`
Named counter collection for one scenario or run scope.

Required fields:
1. `scope_kind`
2. `scope_id`
3. `counters`
4. `source_counter_schema_id`

### 3.6 `ReplayView`
Materialized observable state.

Initial view families:
1. `published_view`
2. `pinned_view`
3. `reject_set`
4. `assertion_result_set`
5. `clause_coverage_view`
6. `manifest_row_result_view`

### 3.7 `ReplayDiff`
Typed comparison record between two bundles or bundle subsets.

Required fields:
1. `diff_id`
2. `left_ref`
3. `right_ref`
4. `comparison_scope`
5. `mismatch_kind`
6. `mismatch_path`
7. `severity`
8. `explanation_hint`

### 3.8 `ReplayExplainRecord`
Precomputed or query-produced explanation result.

Required fields:
1. `query_id`
2. `query_kind`
3. `scope_ref`
4. `supporting_refs`
5. `explanation_text`
6. `confidence_class`

### 3.9 `ReplayPreservationPredicate`
Typed statement of what a reduced witness must preserve.

Required fields:
1. `predicate_id`
2. `predicate_kind`
3. `scope_ref`
4. `required_outcome_refs`
5. `required_mismatch_kinds`
6. `required_supporting_refs`
7. `policy_ref`

### 3.10 `ReplayReductionManifest`
Auditable record of one witness-distillation run.

Required fields:
1. `reduction_id`
2. `source_bundle_ref`
3. `source_scope_ref`
4. `predicate_ref`
5. `strategy_id`
6. `unit_kinds`
7. `retained_units`
8. `removed_units`
9. `rewritten_units`
10. `closure_rules_applied`
11. `iteration_count`
12. `final_status`
13. `witness_bundle_ref`

### 3.11 `ReplayAdapterCapabilityManifest`
Machine-readable claim of what one lane adapter can currently do.

Required fields:
1. `adapter_id`
2. `lane_id`
3. `adapter_version`
4. `supported_source_schema_ids`
5. `supported_bundle_schema_versions`
6. `capability_levels`
7. `known_limits`
8. `conformance_artifact_refs`
9. `registry_version_refs`

### 3.12 `ReplayRegistryRef`
Reference to one canonical registry entry used by the bundle or toolchain.

Required fields:
1. `registry_family`
2. `registry_version`
3. `entry_id`
4. `entry_status`
5. `semantics_ref`

### 3.13 `ReplayWitnessLifecycleRecord`
Current lifecycle state and promotion status for one witness.

Required fields:
1. `witness_id`
2. `lifecycle_state`
3. `retention_policy_id`
4. `promotion_refs`
5. `supersedes`
6. `quarantine_reason`
7. `gc_eligibility`

## 4. Correlation Model
`ReplayEvent.correlation` must be an explicit typed object, not a free-form map.

Optional correlation members include:
1. `formula_stable_id`
2. `node_id`
3. `session_id`
4. `candidate_result_id`
5. `commit_attempt_id`
6. `reject_record_id`
7. `view_id`
8. `evidence_id`
9. `clause_id`
10. `function_id`
11. `module_id`
12. `project_id`

Rule:
1. source lanes may populate only the members that make sense,
2. normalizers may not invent semantic ids,
3. correlation must preserve the source-lane distinction between stable ids, version keys, fingerprints, and runtime handles.

## 5. Event Families
The normalized replay model should define broad event families, while preserving source-native subtypes.

Initial families:
1. `run.*`
2. `config.*`
3. `selection.*`
4. `session.*`
5. `candidate.*`
6. `publication.*`
7. `reject.*`
8. `dependency.*`
9. `spill.*`
10. `overlay.*`
11. `function.*`
12. `host_query.*`
13. `conformance.*`
14. `clause.*`
15. `oracle.*`
16. `diff.*`
17. `reduction.*`

Rule:
1. the normalized family is a projection axis,
2. source-native `event_kind` remains preserved,
3. family projection must be deterministic and versioned.

## 6. Portable Bundle Layout
The first portable layout should be:

```text
bundle_manifest.json
source_inventory.json
runs/<run_id>/run_manifest.json
runs/<run_id>/config_fingerprint.json
runs/<run_id>/selection.json
runs/<run_id>/scenarios/<scenario_id>/scenario_manifest.json
runs/<run_id>/scenarios/<scenario_id>/events.jsonl
runs/<run_id>/scenarios/<scenario_id>/counters.json
runs/<run_id>/scenarios/<scenario_id>/views/*.json
runs/<run_id>/scenarios/<scenario_id>/assertions.json
runs/<run_id>/scenarios/<scenario_id>/source_refs.json
runs/<run_id>/diff/*.json
runs/<run_id>/explain/*.json
reductions/<reduction_id>/reduction_manifest.json
reductions/<reduction_id>/candidate_journal.jsonl
reductions/<reduction_id>/witness_bundle/*
adapter_capabilities/<lane_id>.json
registries/predicate_kind.json
registries/mismatch_kind.json
registries/reduction_status.json
registries/witness_lifecycle_state.json
witnesses/<witness_id>/lifecycle.json
sidecars/<hash>/<payload>
indexes/scenario_index.csv
indexes/evidence_index.csv
indexes/clause_index.csv
indexes/event_kind_index.csv
indexes/reduction_index.csv
indexes/witness_index.csv
```

Portable rules:
1. canonical payload files are JSON, CSV, or JSONL,
2. sidecars may be compressed,
3. implementations may keep transient binary buffers during capture, but normalized bundle output must converge to the canonical file contract.

## 7. Source Preservation Rule
Every normalized bundle must preserve source-native provenance:
1. source file paths,
2. source schema ids,
3. source run ids,
4. source artifact paths,
5. source line or row identity where applicable.

This is required because:
1. lane maintainers need to debug in their own artifact language,
2. bundle projection must be auditable,
3. pack promotion depends on traceable lineage.

## 8. Runner Architecture
The shared runner architecture should have seven phases:
1. ingest source artifacts,
2. normalize and validate,
3. materialize replay state,
4. execute replay or compare-only workflows,
5. emit run-local diff and explanation artifacts,
6. optionally execute witness distillation,
7. optionally export pack-grade artifacts.

Not every lane uses all seven the same way:
1. `OxCalc` may execute a semantic reference machine.
2. `OxFml` may replay fixture payloads and session traces.
3. `OxFunc` may replay manifest packets as deterministic empirical suites.
4. `OxVba` may primarily ingest conformance-run outputs and replay-safe host projections.

## 9. Diff Architecture
Diff should happen in ordered layers:
1. run presence and selection mismatch,
2. scenario presence mismatch,
3. result-state mismatch,
4. view mismatch,
5. reject mismatch,
6. trace/event mismatch,
7. counter mismatch,
8. clause/evidence coverage mismatch,
9. optional sidecar payload mismatch.

Rule:
1. required comparison surfaces are policy-configured by lane and pack,
2. richer payload comparison is opt-in until promoted to required equality.

## 10. Explain Architecture
The explain plane should support at least these query types:
1. `why_changed`
2. `why_not_published`
3. `why_rejected`
4. `why_diff`
5. `which_capability_or_policy_matters`
6. `which_evidence_supports_this_claim`

Explain output should cite:
1. scenario ids,
2. event ids,
3. view paths,
4. source refs,
5. evidence ids or clause ids where present.

## 11. Distillation Architecture
Witness distillation should be treated as a bundle-to-bundle transformation driven by an explicit preservation predicate.

Accepted distillation entry points include:
1. one scenario or scenario subset,
2. one `ReplayDiff` or mismatch class,
3. one `ReplayExplainRecord`,
4. one pack failure scope,
5. one lane-declared reject or invariant class.

The distillation pipeline should have six phases:
1. seed candidate units from diff and explain refs,
2. build a reduction-unit graph with closure dependencies,
3. apply coarse subset elimination,
4. apply finer-grained elimination or lane-declared rewrite transforms,
5. evaluate the preservation predicate through replay, diff, and explain,
6. emit a reduced witness bundle plus `ReplayReductionManifest`.

Distillation strategies should be explicit and versioned:
1. hierarchy-first elimination,
2. explain-guided slicing,
3. delta-debug partitioning,
4. lane-declared rewrite search,
5. hybrid staged search.

Witness rules:
1. a witness bundle must preserve full provenance back to the source bundle,
2. a witness bundle must remain replay-addressable, diff-addressable, and explain-addressable,
3. every retained witness must have an explicit lifecycle record,
4. explanatory-only outputs must be explicitly marked and kept separate from pack-grade witnesses,
5. reduction failure or irreducibility must be emitted as data, not implied by the absence of output.

## 12. Pack Integration Architecture
Packs should bind to bundle projections rather than raw logs.

Pack binding surfaces include:
1. selected scenario sets,
2. required view equalities,
3. required event families,
4. required counter thresholds,
5. required evidence or clause bindings,
6. required diff mismatch classes that must be absent,
7. optional witness-distillation predicates or witness-size ceilings for retained failures,
8. required witness lifecycle states and minimum adapter capability levels.

This allows current pack ideas such as:
1. `PACK.fec.reject_detail_replay`
2. `PACK.trace.forensic_plane`
3. `PACK.replay.appliance`
4. `PACK.diff.cross_engine.continuous`

to share one tool surface.

## 13. Registry And Lifecycle Governance
Registry families should be centrally versioned and referenced by id.

Governance rules:
1. tool outputs use canonical registry ids when a family exists,
2. bundles snapshot the registry versions they depend on,
3. adapter capability manifests declare current proven capability levels and known limits,
4. witness lifecycle records govern promotion, supersession, quarantine, and GC eligibility,
5. pack promotion can only consume witnesses whose lifecycle and capability state satisfy policy.

## 14. Adapter Boundary Rule
Adapters are versioned, explicit, and lane-owned.

An adapter must declare:
1. supported source schema ids,
2. supported replay schema version,
3. lossless versus lossy projections,
4. unsupported field families,
5. sidecar preservation rules,
6. reducible unit kinds,
7. closure dependencies,
8. safe rewrite transforms if any,
9. claimed capability levels,
10. conformance artifact refs,
11. registry version refs.

This prevents silent drift and makes cross-lane projection auditable.

## 15. Resulting Architectural Boundary
The Replay appliance does not ask every lane to look the same.
It asks every lane to be:
1. replay-addressable,
2. diff-addressable,
3. explain-addressable,
4. pack-addressable,
5. witness-distillable where supported,
6. governance-addressable through capability, registry, and lifecycle contracts,
through one common bundle and tool contract.
