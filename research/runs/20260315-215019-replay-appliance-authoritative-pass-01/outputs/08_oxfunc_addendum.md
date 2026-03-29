# OxFunc Addendum For The Replay Appliance

## 1. Purpose
This addendum defines how `OxFunc` should incorporate the Replay appliance while preserving its current function-lane discipline:
1. full empirical function identity as the real completion target,
2. manifest-driven replay and evidence capture,
3. shared contract and correlation alignment across Excel, Rust, Lean, and seam artifacts,
4. explicit separation between function semantics and XLL or host verification limitations.

## 2. Current authoritative anchors
Primary anchors:
1. `docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_SPEC.md`
2. `docs/function-lane/EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`
3. `docs/function-lane/FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
4. `docs/function-lane/FUNCTION_SLICE_CORRELATION_LEDGER.csv`
5. `docs/function-lane/DOCTRINE_DECISION_FULL_EMPIRICAL_FUNCTION_IDENTITY_20260309.md`
6. `docs/function-lane/FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
7. `docs/function-lane/CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md`
8. workset-specific scenario manifests, runtime requirements, and execution records
9. `docs/function-lane/XLL_VERIFICATION_SEAM_LIMITATIONS.md`

## 3. OxFunc-specific replay rule
For `OxFunc`, replay is primarily empirical packet replay, not only stepwise internal event replay.

The Replay appliance must therefore support:
1. packet-level runs,
2. row-level results,
3. dual-run labels,
4. evidence ids,
5. correlation rows,
6. boundary-invariant statements,
7. XLL limitation markers.

It must not force all OxFunc evidence into a fake event-stream shape if the packet/result-row form is the real semantic witness.

## 4. Required packet projection

### 4.1 Scenario manifests are first-class inputs
The Replay appliance should treat current OxFunc scenario manifests as canonical packet definitions.

Required preserved fields include:
1. scenario or row id,
2. packet id or workset id,
3. formula or entrypoint under test,
4. expected observation class,
5. run label,
6. compatibility descriptor,
7. locale profile,
8. environment metadata,
9. artifact ref.

### 4.2 Runtime-requirements docs become adapter contracts
Workset runtime-requirements docs already define:
1. required output artifacts,
2. replay commands,
3. classification rules,
4. workbook-lane expectations.

The Replay appliance should project these into normalized run metadata rather than rediscovering them later from prose.

### 4.3 Execution records become summary and evidence views
Execution records should map into:
1. `run_summary_view`
2. `analysis_summary_view`
3. `evidence_binding_view`
4. `limitation_view`

This preserves the current OxFunc habit of promoting packet outcomes into evidence rather than leaving them as raw CSV only.

## 5. Mandatory preserved metadata
Every OxFunc replay bundle should preserve:
1. evidence id,
2. function id or slice id,
3. workset id,
4. run label,
5. compatibility descriptor,
6. locale profile,
7. Excel build and channel where relevant,
8. source manifest path,
9. output artifact refs,
10. correlation-ledger refs,
11. XLL limitation markers where relevant.

## 6. Boundary-invariant incorporation
The Replay appliance should support OxFunc boundary invariants as explicit bundle content.

Required bundle support:
1. formula evaluation boundary,
2. interop ingress boundary,
3. reference reuse boundary,
4. persistence boundary,
5. interchange boundary,
6. optional XLL or UDF boundary.

Normalized object suggestion:
1. `ReplayInvariant`
   - `invariant_id`
   - `statement`
   - `boundaries`
   - `scenario_ids`
   - `expected_observation`
   - `status`
   - `notes`

This lets OxFunc packet closure travel with its declared boundary semantics.

## 7. Correlation and formal alignment
The Replay appliance must preserve OxFunc's existing alignment chain:
1. Excel empirical behavior,
2. contract statement,
3. Rust behavior,
4. Lean executable model.

That means the bundle should support references to:
1. function contract docs,
2. conformance CSV rows,
3. evidence ids,
4. correlation-ledger rows,
5. formal artifact refs.

This is more important for OxFunc than high-frequency internal event emission.

## 8. XLL and host-limitation rule
The Replay appliance must preserve the distinction between:
1. full OxFunc semantic target,
2. bounded verification seam through XLL or other host bridges.

Bundle fields should therefore allow:
1. `semantic_target_status`
2. `verification_surface`
3. `known_limitation`
4. `limitation_scope`
5. `limitation_artifact_ref`

This prevents a bundle diff from incorrectly classifying an XLL seam gap as a core semantic failure unless OxFunc itself says that is the right classification.

## 9. Event model for OxFunc
`OxFunc` should use a packet-first normalized event model.

Recommended mandatory event families:
1. `packet.started`
2. `row.executed`
3. `row.observed`
4. `row.mismatched`
5. `analysis.completed`
6. `evidence.promoted_locally`
7. `limitation.noted`

Large raw outputs should remain sidecar-backed CSV or JSON files referenced from the bundle.

## 10. Witness distillation design for OxFunc
OxFunc witness distillation must stay packet-first and row-first.

### 10.1 Reduction units
The OxFunc adapter should declare this hierarchy:
1. workset or packet,
2. manifest row cluster,
3. individual scenario row,
4. analysis-summary record,
5. invariant declaration,
6. limitation marker,
7. sidecar output partition.

### 10.2 Preservation predicates
Initial OxFunc predicate families should include:
1. same row mismatch or observed outcome class,
2. same evidence-id-backed claim failure,
3. same boundary-invariant failure or closure state,
4. same limitation classification,
5. same dual-run disagreement class.

### 10.3 Closure rules
At minimum, the adapter must enforce:
1. retaining a row also retains its manifest definition, run label, compatibility descriptor, and output refs,
2. retaining an evidence-backed mismatch also retains the linked evidence id and correlation-ledger refs,
3. retaining an invariant also retains the scenario ids that witness it,
4. retaining a limitation marker also retains the relevant verification-surface metadata.

### 10.4 Search strategy
OxFunc distillation should prefer:
1. packet elimination first,
2. row elimination second,
3. summary and limitation pruning third,
4. lane-owned manifest rewrites only where a workset declares them.

### 10.5 Rewrite rule
The generic Replay appliance must not fabricate a fake event stream for OxFunc just to reduce it.
If manifest rewrites are used, they must be declared by OxFunc as packet-safe transforms.

## 11. Performance notes for OxFunc
1. Do not instrument every internal function helper call for default replay mode.
2. Treat packet rows and summary analyses as the cheap semantic boundary.
3. Keep raw CSV outputs as sidecars rather than reserializing them repeatedly.
4. Reserve richer call-path traces for targeted forensic runs only.

## 12. Target docs for future incorporation
This addendum should eventually be reflected in:
1. a function-lane replay-adapter note under `docs/function-lane/`
2. `FUNCTION_LANE_EVIDENCE_ID_REGISTRY.md`
3. `FUNCTION_SLICE_CORRELATION_LEDGER.csv`
4. probe runtime requirements templates
5. execution-record templates
6. `FORMALIZATION_STRATEGY_EXECUTABLE_SEMANTIC_MODEL.md`
7. `CROSS_BOUNDARY_INVARIANT_CHECKLIST_TEMPLATE.md`

## 13. Summary
For `OxFunc`, the Replay appliance should look like:
1. manifest-driven empirical packet replay,
2. evidence-id-anchored bundle projection,
3. boundary-invariant and limitation-aware comparison,
4. packet-first witness distillation over rows, invariants, and limitation markers,
5. sidecar-preserved raw outputs with normalized summary and diff surfaces.
