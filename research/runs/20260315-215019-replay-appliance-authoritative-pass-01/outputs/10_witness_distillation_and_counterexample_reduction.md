# Witness Distillation And Counterexample Reduction

## 1. Position
Witness distillation is a first-class Replay appliance capability.

It is the subsystem that turns a broad replayable divergence into the smallest retained witness that still proves a chosen fact.

It is not:
1. a profiler,
2. a heuristic log scrubber,
3. a generic source mutator,
4. a replacement for lane-owned scenario authoring.

## 2. Why this capability matters
Replay, diff, and explain make failures portable.
Witness distillation makes them accretive.

Without distillation:
1. retained failures stay larger than necessary,
2. pack-grade regression assets accumulate noise,
3. issue triage keeps repeating the same manual minimization work,
4. cross-lane divergences remain harder to compare than they need to be.

With distillation:
1. one large mismatch becomes one portable reduced witness,
2. pack promotion can point at the smallest proving asset,
3. new failures become easier to retain, classify, and re-run,
4. divergence archaeology becomes much cheaper.

## 3. Charter
Witness distillation exists to:
1. preserve a chosen semantic fact,
2. remove irrelevant material,
3. emit a smaller replay-closed witness,
4. record exactly how that witness was derived.

Success means the reduced witness is:
1. smaller,
2. replay-valid,
3. provenance-preserving,
4. auditable,
5. still sufficient for the declared predicate.

## 4. Core terms
1. `Preservation predicate`: the typed condition that must remain true after reduction.
2. `Reduction unit`: a removable or rewritable chunk declared by a lane adapter.
3. `Closure dependency`: a required retained dependency between units.
4. `Witness bundle`: the reduced replay bundle produced by distillation.
5. `Subset reduction`: distillation by removing units only.
6. `Rewrite reduction`: distillation using a lane-declared replay-safe transform.
7. `Explanatory-only witness`: a reduced output useful for reading but not yet pack-eligible.

## 5. Inputs and outputs
Witness distillation should accept:
1. one bundle plus one scenario or scenario set,
2. one diff id,
3. one explain record or explain query result,
4. one pack failure scope,
5. one lane-declared reject, invariant, clause, or oracle disagreement class.

Witness distillation must emit:
1. `ReplayReductionManifest`,
2. one reduced witness bundle,
3. one candidate journal recording attempted reductions,
4. one summary record with size delta and predicate outcome,
5. one witness lifecycle record.

Optional outputs:
1. intermediate candidate bundles,
2. ranked alternative witnesses,
3. lane-specific reduced source artifacts where the adapter supports them.

## 6. Preservation predicate model
Every distillation run must be driven by an explicit typed predicate.

Predicate kinds and reduction outcomes should come from canonical registries rather than lane-local free text.

### 6.1 Required predicate fields
1. `predicate_id`
2. `predicate_kind`
3. `scope_ref`
4. `required_outcome_refs`
5. `required_mismatch_kinds`
6. `required_supporting_refs`
7. `policy_ref`

### 6.2 Initial predicate families
1. preserve one diff mismatch class,
2. preserve one reject family,
3. preserve one non-publication reason,
4. preserve one invariant failure,
5. preserve one clause failure set,
6. preserve one oracle disagreement,
7. preserve one deferred-oracle state,
8. preserve one unsupported or denied result class,
9. preserve one evidence-backed claim failure.

### 6.3 Predicate evaluation outcomes
Every candidate evaluation must end in one of:
1. `preserved`,
2. `not_preserved`,
3. `invalid_candidate`,
4. `unsupported_candidate`,
5. `evaluation_failed`.

These outcomes must be journaled, not inferred.

## 7. Reduction unit model
The Replay appliance must never guess what a safe reduction unit is.
Each adapter declares the unit hierarchy it supports.

### 7.1 Common reduction-unit kinds
1. scenario selection,
2. phase block,
3. event group,
4. manifest row,
5. view slice,
6. reject record,
7. clause slice,
8. invariant declaration,
9. sidecar payload block,
10. configuration axis.

### 7.2 Lane-specific defaults
1. `OxCalc`: scenario, phase block, candidate/publish/reject event group, view slice, reject record, sidecar block.
2. `OxFml`: fixture case, lifecycle block, candidate or commit attempt, reject-context group, effect slice, artifact snapshot.
3. `OxFunc`: packet, row cluster, row, analysis summary, invariant, limitation marker, sidecar partition.
4. `OxVba`: conformance case, clause slice, profile or policy axis, host-projection field group, deferred-oracle item, sidecar set.

## 8. Closure rules
Reduction is only valid if replay closure is preserved.

Required closure classes:
1. identity closure,
2. causal closure,
3. scenario-input closure,
4. view-reconstruction closure,
5. evidence or clause closure,
6. configuration closure.

Examples:
1. retaining a publication mismatch also retains the producing candidate lineage,
2. retaining a reject also retains its typed reject context and triggering boundary,
3. retaining a clause failure also retains the case results and profile or policy fingerprint that make the clause meaningful,
4. retaining an OxFunc invariant also retains the scenario ids that witness that invariant.

## 9. Allowed transforms
The Replay appliance should support three transform families.

### 9.1 Subset transforms
Remove complete reduction units.

Examples:
1. drop an unused scenario,
2. drop optional sidecar blocks,
3. drop a view slice not referenced by the predicate.

### 9.2 Projection transforms
Remove payload detail while preserving semantic meaning.

Examples:
1. keep a sidecar hash and ref but drop inline payload text,
2. keep a reject family and typed context summary while dropping optional forensic enrichment.

### 9.3 Lane-declared rewrite transforms
Rewrite source material only if the lane adapter explicitly authorizes the transform and replay-validates the result.

Examples:
1. a `TraceCalc` scenario simplification declared by OxCalc,
2. a fixture simplification declared by OxFml,
3. a manifest-row simplification declared by OxFunc,
4. a configuration narrowing declared by OxVba.

The generic Replay appliance must never invent these transforms on its own.

## 10. Search strategy
One strategy is not enough across all lanes.
The distiller should support explicit, versioned search strategies.

### 10.1 Required strategies
1. `hierarchy_first`
2. `explain_guided`
3. `delta_debug`
4. `rewrite_then_reduce`
5. `hybrid`

### 10.2 Recommended search order
1. seed from diff and explain refs,
2. remove large irrelevant scopes first,
3. narrow to the smallest unit hierarchy that still preserves the predicate,
4. try rewrite transforms only after subset reduction stalls,
5. stop when no smaller accepted candidate is found within policy bounds.

### 10.3 Candidate ordering
Candidate ordering should prefer:
1. larger predicted size reduction first,
2. units farthest from supporting refs,
3. sidecar and optional forensic material before required semantic boundaries,
4. low-cost evaluation candidates before expensive rewrites.

## 11. Acceptance oracle
Witness distillation depends on a precise acceptance oracle.

The oracle should be built from the existing Replay appliance stack:
1. replay,
2. diff,
3. explain,
4. adapter-declared validation.

Acceptance rule:
1. replay or compare the candidate,
2. compute the relevant diff or result-state surface,
3. evaluate the typed predicate,
4. return one of the journaled outcomes.

Important rule:
1. an acceptance oracle must be deterministic for the same candidate,
2. if the oracle is not deterministic, the reduction run must fail explicitly.

## 12. Canonical objects
The distillation subsystem should standardize three object families.

### 12.1 `ReplayPreservationPredicate`
Typed contract for what must remain true.

### 12.2 `ReplayReductionManifest`
Auditable log of how the witness was derived.

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

### 12.3 `WitnessBundle`
The reduced replay bundle itself.

Rules:
1. it should satisfy the normal bundle contract by default,
2. it should preserve provenance back to the source bundle,
3. it should carry an explicit reduced-witness role marker,
4. it should carry or reference a lifecycle record,
5. if it is explanatory-only, that status must be declared in the manifest.

## 13. Bundle and filesystem layout
The canonical replay bundle layout should reserve space for reductions:

```text
reductions/<reduction_id>/reduction_manifest.json
reductions/<reduction_id>/candidate_journal.jsonl
reductions/<reduction_id>/witness_bundle/*
indexes/reduction_index.csv
```

Portable rules:
1. the reduced witness may be nested or emitted as a sibling bundle, but the canonical manifest path must resolve it,
2. candidate journals may be summarized for retention but must preserve final accepted candidate lineage,
3. retained witnesses should be indexable by predicate kind, lane, pack tags, and source bundle id.

## 14. Performance model
Witness distillation is offline, but it still needs design discipline.

Rules:
1. it must never run on the hot capture path,
2. it should reuse normalized indexes and sidecar hashes,
3. it should prefer coarse-to-fine reduction,
4. it should memoize candidate results,
5. it should bound rewrite search,
6. it should avoid reopening large sidecars unless the predicate depends on them.

Capture-mode rule:
1. `replay` is the minimum mode for semantic witness distillation,
2. `summary` may support seed discovery only,
3. `forensic` may provide richer guidance but may not change predicate truth.

## 15. Pack and program integration
Witness distillation should integrate directly with packs.

Pack-facing uses:
1. retain one minimized witness for each promoted failure class,
2. attach reduced witness refs to divergence indexes,
3. require or recommend distillation for certain failure surfaces,
4. set witness-size ceilings for retained failure packs.

Program-facing uses:
1. issue triage,
2. nightly differential runs,
3. local debugging handoff,
4. promotion from local failure to pack-grade artifact.

Lifecycle rules:
1. explanatory-only witnesses are not pack-eligible,
2. quarantined witnesses are not pack-eligible,
3. retained and promoted witnesses must have explicit lifecycle state transitions.

## 16. Lane-specific design rules
1. `OxCalc`: preserve candidate-versus-publication truth; reduce scenario, event-group, and view-slice scopes before finer graph material.
2. `OxFml`: preserve canonical keys, fence context, and typed reject semantics; only OxFml may authorize formula or fixture rewrites.
3. `OxFunc`: stay packet-first and row-first; do not fabricate a fake event stream just to perform reduction.
4. `OxVba`: preserve replay identity as profile plus runtime plus policy; never depend on raw host handles.

## 17. Failure modes and non-goals
The distiller must fail explicitly when:
1. the predicate cannot be evaluated,
2. capture mode is insufficient,
3. the adapter does not declare safe reduction units for the requested scope,
4. replay closure cannot be maintained,
5. the oracle is nondeterministic.

These failures should feed witness lifecycle and quarantine policy rather than remaining only local console outcomes.

Non-goals:
1. global minimality proofs,
2. arbitrary semantic rewriting,
3. replacing lane-owned authoring formats,
4. hiding irreducible complexity behind a fake small witness.

## 18. Initial implementation order
1. OxCalc first, using `TraceCalc`, `engine_diff`, and view mismatches as the first acceptance oracle.
2. OxFml second, using typed commit or reject predicates and fixture families.
3. OxFunc third, using packet and row mismatches plus invariant closure.
4. OxVba fourth, using clause, gate, and host-projection predicates.

## 19. Resulting rule
The Replay appliance should not stop at replaying failures.
It should also be able to distill them into the smallest honest witness that the program can retain, diff, explain, and promote.
