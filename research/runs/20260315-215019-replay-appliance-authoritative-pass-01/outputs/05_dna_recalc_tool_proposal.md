# DNA ReCalc Tool Proposal

## 1. Tool identity
`DNA ReCalc` should be the shared tool surface for:
1. capture,
2. normalization,
3. replay,
4. diff,
5. explain,
6. witness distillation,
7. pack export,
8. bundle indexing and retention.

It is the operational face of the Replay appliance specification.

## 2. Role in the program
`DNA ReCalc` should sit in the Logistics layer.

It should provide one reusable command family across:
1. `OxCalc` `TraceCalc` and engine-diff workflows,
2. `OxFml` fixture, seam, and schema-witness workflows,
3. `OxFunc` manifest-driven empirical packet workflows,
4. `OxVba` conformance, policy, and clause-traced host workflows.

## 3. Tool components
The tool should consist of these components.

### 3.1 Bundle validator
Validates:
1. source-lane adapter output,
2. normalized bundle shape,
3. schema compatibility,
4. required field presence for the selected mode and pack,
5. declared adapter capability level and supporting conformance refs.

### 3.2 Normalizer
Transforms lane-native artifacts into the canonical replay bundle.

### 3.3 Replay executor
Replays:
1. event-oriented bundles,
2. scenario-oriented bundles,
3. manifest-row empirical packets where the replay surface is row comparison rather than step-by-step simulation.

### 3.4 Diff engine
Compares:
1. bundle to bundle,
2. lane run to oracle bundle,
3. current run to prior baseline,
4. required surfaces only or full forensic surfaces.

### 3.5 Explain engine
Builds queryable explanations over:
1. event sequences,
2. views,
3. reject sets,
4. counters,
5. clause and evidence bindings,
6. source refs.

### 3.6 Witness distiller
Produces reduced witnesses from bundles using explicit preservation predicates.

It should support:
1. bundle-subset reduction,
2. diff-guided reduction,
3. explain-guided reduction,
4. lane-declared rewrite transforms,
5. emission of reduced witness bundles and reduction manifests.

### 3.7 Pack exporter
Produces pack-grade outputs from bundles:
1. selected scenario subsets,
2. diff summaries,
3. evidence refs,
4. required views and counters,
5. minimized replay handles,
6. reduced witness refs where pack policy requires them.

### 3.8 Registry and lifecycle manager
Maintains:
1. canonical registry snapshots,
2. adapter capability manifests,
3. witness lifecycle transitions,
4. quarantine reasons,
5. promotion and supersession metadata.

## 4. Proposed command family

### 4.1 Capture and ingest
```text
dnarecalc ingest --lane oxcalc --source <path>
dnarecalc ingest --lane oxfml --source <path>
dnarecalc ingest --lane oxfunc --source <path>
dnarecalc ingest --lane oxvba --source <path>
```

### 4.2 Normalize and validate
```text
dnarecalc normalize --input <source-run-root> --out <bundle-root>
dnarecalc validate --bundle <bundle-root>
```

### 4.3 Replay and diff
```text
dnarecalc replay --bundle <bundle-root> --scenario <id>
dnarecalc diff --left <bundle-root> --right <bundle-root> --scope required
dnarecalc diff --left <bundle-root> --right <bundle-root> --scope forensic
```

### 4.4 Explain
```text
dnarecalc explain --bundle <bundle-root> --query why_changed --scenario <id>
dnarecalc explain --bundle <bundle-root> --query why_rejected --scenario <id>
dnarecalc explain --bundle <bundle-root> --query why_diff --left <path> --right <path>
```

### 4.5 Distill
```text
dnarecalc distill --bundle <bundle-root> --scenario <id> --predicate <predicate.json>
dnarecalc distill --bundle <bundle-root> --diff <diff_id> --strategy explain_guided
```

### 4.6 Governance
```text
dnarecalc validate-adapter --manifest <adapter_capability.json>
dnarecalc registry --family mismatch_kind --version current
dnarecalc witness-state --bundle <bundle-root> --witness <id> --state retained_shared
dnarecalc witness-state --bundle <bundle-root> --witness <id> --state quarantined --reason oracle_unstable
```

### 4.7 Pack and retention
```text
dnarecalc export-pack --bundle <bundle-root> --pack <pack-id>
dnarecalc index --bundle <bundle-root>
dnarecalc gc --bundle-root <path> --policy <policy-id>
```

## 5. Workspace contract
The tool should operate over bundle roots that follow the canonical layout from the architecture spec.

It should also support:
1. temporary local output roots,
2. tracked evidence roots,
3. import-only mode for already emitted lane artifacts,
4. no-artifact mode where normalized bundle output goes to a temporary root,
5. witness-bundle output roots and reduction journals,
6. registry snapshots and witness lifecycle records.

## 6. Adapter model
`DNA ReCalc` should discover adapters by lane id and adapter schema version.

Each adapter should declare:
1. supported source schemas,
2. supported capture modes,
3. required inputs,
4. lossless and lossy projections,
5. sidecar classes,
6. target bundle schema compatibility,
7. reducible unit kinds,
8. closure rules,
9. safe rewrite transforms if any,
10. supported preservation predicate kinds,
11. claimed capability levels,
12. conformance artifact refs,
13. registry version refs.

## 7. Suggested initial implementation order

### 7.1 Phase 1: bundle and validator foundation
Deliver:
1. bundle layout,
2. schema validator,
3. adapter manifest contract,
4. index builder.

### 7.2 Phase 2: OxCalc first-class adapter
Reason:
1. `OxCalc` already has the strongest normalized scenario and oracle shape.
2. `TraceCalc` is the best proving ground for end-to-end replay, diff, and explain.

### 7.3 Phase 3: OxCalc witness distiller
Reason:
1. `TraceCalc` plus `engine_diff` already provides the clearest acceptance oracle for minimized witnesses.
2. The first practical value jump after replay and diff is turning broad engine mismatches into reduced retained witnesses.

### 7.4 Phase 4: OxFml seam adapter
Reason:
1. typed artifact families are already explicit,
2. candidate/commit/reject distinction is already mature,
3. schema witness packs directly benefit from the bundle contract.

### 7.5 Phase 5: OxFunc empirical packet adapter
Reason:
1. the empirical replay pattern is already productive,
2. scenario manifests and evidence ids are ready to benefit from shared diff/explain tooling,
3. it broadens the appliance beyond event-only engines.

### 7.6 Phase 6: OxVba conformance adapter
Reason:
1. its artifact surface is broad and valuable,
2. it needs replay-safe host projection rules,
3. it benefits heavily from shared bundle indexing and deferred-oracle explanation.

## 8. Tool success criteria
`DNA ReCalc` is useful when it can:
1. ingest a lane run without hand editing,
2. produce a stable normalized bundle,
3. validate the bundle,
4. replay or compare it deterministically,
5. explain a failure or divergence with source refs,
6. distill a divergence into a smaller replay-closed witness,
7. validate an adapter capability claim,
8. track witness lifecycle and quarantine explicitly,
9. export pack-grade artifacts.

## 9. Relationship to repo structure
The repo and host split is now:

1. `OxReplay` is the core shared replay repo and library family,
2. `DNA ReCalc` is the CLI, UI, and replay-host surface built on `OxReplay`.

Role split:
1. Foundation owns doctrine, architecture, governance, registries, and promotion policy,
2. lane repos own lane-native replay semantics and authoritative adapter meaning,
3. `OxReplay` owns the shared implementation substrate,
4. `DNA ReCalc` is the operational face of that substrate.

`OxReplay` must not become a new semantics lane.

It should own shared implementation for:
1. bundle validation and IO,
2. normalization orchestration,
3. replay and diff infrastructure,
4. explain and distillation core,
5. registry and lifecycle management,
6. adapter SDK, loader, and conformance harnesses.

Lane-local event semantics, reject semantics, and reduction permissions remain lane-owned even when exercised through `DNA ReCalc`.

## 10. Naming decision
Use:
1. `OxReplay` for the shared replay repo and library family,
2. `DNA ReCalc` for the CLI, UI, and replay-host surface,
3. `dna-replay-bundle/v1` for the first normalized bundle schema id family.

This keeps:
1. the implementation repo identity explicit,
2. the user-facing tool name expressive,
3. the serialized schema naming explicit and versionable.

## 11. Proposed near-term outcome
The smartest concrete near-term outcome is:
1. define the bundle contract,
2. prove the first adapter slices in `OxCalc` and `OxFml`,
3. stand up `OxReplay` around the validated shared bundle, diff, explain, and governance surfaces,
4. implement a predicate-driven witness distiller against `TraceCalc`,
5. make `PACK.replay.appliance` real through `DNA ReCalc`,
6. then widen to OxFunc and OxVba.

That sequence maximizes compounding value without blocking active lane work.
