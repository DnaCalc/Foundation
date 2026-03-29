# Replay Appliance Performance-Sensitive Design

## 1. Why performance must be designed now
Replay cannot be bolted on as slow logging:
1. `OxCalc` hot paths are candidate admission, publication, overlay reuse, and invalidation transitions.
2. `OxFml` hot paths are evaluator session and commit/reject boundaries.
3. `OxFunc` hot paths are often batch empirical probes where row volume matters more than per-step tracing.
4. `OxVba` hot paths are host calls, conformance runners, and policy-governed unsupported paths where determinism matters more than verbose emission.

If replay capture is too expensive:
1. lanes will keep side-stepping it,
2. data will be sampled incorrectly,
3. the bundle contract will become theory-only.

Witness distillation must therefore run as an offline consumer of replay bundles, not as a new hot-path burden.

## 2. Capture-mode ladder
The design must define five capture modes.

### 2.1 `off`
1. no replay artifacts,
2. only lane-local normal execution.

### 2.2 `counters`
1. deterministic counters only,
2. no required event bodies,
3. used for low-overhead economics and scale sweeps.

### 2.3 `summary`
1. run manifest,
2. scenario selection,
3. result states,
4. key views,
5. selected counters,
6. no full required event stream.

### 2.4 `replay`
1. required semantic event families,
2. required views,
3. required counters,
4. typed rejects,
5. enough data for deterministic replay and diff.

### 2.5 `forensic`
1. everything in `replay`,
2. richer trace payloads,
3. larger sidecars,
4. optional derivation and call-path details,
5. query-optimized indexes.

Rule:
1. packs must declare which mode they require,
2. `replay` is the minimum mode for pack-grade deterministic replay and semantic witness distillation,
3. `summary` may support coarse seed discovery but not full witness distillation,
4. `forensic` is never allowed to change semantic outcomes.

## 3. Event classes
To keep performance explicit, the appliance should classify emitted data.

### 3.1 Class A: mandatory semantic boundary events
Examples:
1. candidate admitted,
2. candidate built,
3. commit accepted,
4. commit rejected,
5. reader pinned or unpinned,
6. typed host policy denial,
7. scenario row executed with observed outcome.

Rules:
1. required in `replay` and `forensic`,
2. never sampled,
3. never silently dropped.

### 3.2 Class B: replay-useful enrichments
Examples:
1. dynamic dependency fact bodies,
2. spill blocker sets,
3. prepared-call provenance,
4. clause-level subdetail,
5. detailed host-projection fields.

Rules:
1. may be required by particular packs,
2. generally present in `forensic`,
3. may move to sidecars.

### 3.3 Class C: diagnostic or telemetry enrichments
Examples:
1. timing samples,
2. allocation snapshots,
3. per-phase wall-clock summaries,
4. advisory debug strings.

Rules:
1. optional,
2. may be sampled,
3. may be disabled in deterministic replay mode.

## 4. Hot-path emission rules
The hot path must obey these rules.

### 4.1 No hot-path JSON serialization
Emitters should not construct large JSON payloads on the hot path.

Preferred shape:
1. append minimal typed records to a local segment buffer,
2. hand them to a normalizer after the critical transition,
3. emit canonical JSON/JSONL only at flush or post-run normalization.

### 4.2 Preinterned identities
Frequent strings should be interned or dictionary-backed:
1. event kinds,
2. counter names,
3. lane ids,
4. schema ids,
5. stable object ids where possible.

### 4.3 Sidecar externalization
Large payload classes should be emitted by reference:
1. large parse trees,
2. bound formula snapshots,
3. prepared-call packets,
4. full workbook or host-state projections,
5. large empirical result tables.

The event or view stores:
1. content hash,
2. payload class,
3. optional byte count,
4. sidecar path ref.

### 4.4 Local segment buffers
Capture should use append-only per-thread, per-session, or per-scenario segment buffers where applicable.

This keeps:
1. lock contention low,
2. event ordering deterministic within scope,
3. flush points explicit at commit, reject, end-of-scenario, or end-of-run.

## 5. Normalization pipeline
The architecture should use a three-stage pipeline.

### 5.1 Stage N1: source capture
Lane-native emitters capture:
1. local typed events,
2. local counters,
3. local sidecars,
4. local views.

### 5.2 Stage N2: canonical normalization
After the hot path or at run end:
1. source records are validated,
2. normalized replay events are derived,
3. canonical file layout is emitted,
4. indexes are built,
5. projection gaps are reported explicitly.

This keeps the canonical bundle consistent without forcing all lanes to serialize through the same hot-path machinery.

### 5.3 Stage N3: witness distillation
Witness distillation runs after normalization and only against bundle-valid material.

Required steps:
1. derive seed refs from diff and explain outputs,
2. build a reduction-unit graph with closure edges,
3. run staged elimination and optional lane-declared rewrite passes,
4. evaluate the preservation predicate through replay or compare-only execution,
5. emit a reduced witness bundle and reduction manifest.

Rule:
1. no distillation step may run on the source-lane hot path,
2. distillation should reuse normalized indexes and sidecar hashes instead of rebuilding source artifacts each iteration.

## 6. Ordering model
Replay portability requires deterministic ordering without over-relying on clocks.

### 6.1 Required ordering fields
1. `event_seq` within scenario/run scope,
2. `phase_kind`,
3. `causal_parent_ids`,
4. source-native sequence id where available.

### 6.2 Wall-clock rule
Wall-clock timestamps are allowed for provenance and performance analysis.
They are not allowed to be the only ordering basis for semantic replay.

## 7. Counter design
Counters should be first-class, cheap, and versioned.

Rules:
1. counters are not reconstructed from trace text after the fact,
2. counter schemas are explicit and source-versioned,
3. normalized bundles preserve both source counter names and normalized counter family mapping where useful.

High-value initial counter groups:
1. overlay reuse versus rebuild economics,
2. candidate accepted versus rejected counts,
3. typed reject family counts,
4. dynamic dependency activation or release counts,
5. pack-oriented scenario and failure counts,
6. clause coverage counts for `OxVba`.

## 8. Backpressure and failure policy
Backpressure must not produce silent semantic loss.

### 8.1 If sidecar writing stalls
Allowed:
1. queue sidecar references for later flush,
2. hold a bounded in-memory staging buffer,
3. downgrade optional Class C capture.

Not allowed:
1. silently dropping Class A semantic events,
2. mutating the observed semantic result to make capture easier.

### 8.2 If a required capture element cannot be emitted
The run must emit an explicit `capture_degraded` or `capture_failed` artifact with:
1. scope,
2. lost or unverified class,
3. reason,
4. whether the bundle remains replay-valid.

## 9. Distillation performance rules
Distillation is allowed to be more expensive than capture, but it still needs performance discipline.

Rules:
1. candidate evaluation should reuse one normalized bundle and materialized indexes wherever possible,
2. reduction should proceed coarse-to-fine so the tool removes large irrelevant regions before trying fine-grained edits,
3. explain-guided seed sets should be preferred over full-bundle brute force,
4. sidecar payload equality should use hashes and indexed summaries before reopening large payloads,
5. lane-declared rewrite transforms must be bounded and memoized so the search does not explode,
6. failed or unsupported candidate checks should be journaled once and reused by key.

## 10. Lane-specific performance weave

### 10.1 OxCalc
The Replay appliance should hook at:
1. scenario-step boundaries,
2. candidate admission,
3. candidate result construction,
4. reject emission,
5. publish,
6. pin and unpin transitions,
7. overlay retention or release points.

It should not require:
1. full payload serialization at every internal graph walk,
2. verbose logging inside every invalidation edge traversal.
3. Distillation should start at scenario, event-group, and view-slice granularity before it attempts finer node-level pruning.

### 10.2 OxFml
The Replay appliance should hook at:
1. `prepare`,
2. `open_session/capability_view`,
3. `execute`,
4. `candidate built`,
5. `commit accepted`,
6. `commit rejected`,
7. typed effect discovery boundaries.

It should not require:
1. reserializing full parse or bind artifacts on every event,
2. flattening prepared-call provenance into text.
3. Distillation should first drop optional artifact bodies and lifecycle phases before it tries lane-declared fixture rewrites.

### 10.3 OxFunc
The Replay appliance should treat many existing packets as batch artifacts:
1. manifests,
2. output rows,
3. analysis summaries,
4. execution records,
5. evidence ids.

This means the performant path is often:
1. direct row capture from the runner,
2. normalized packet-level events,
3. sidecar linkage to large raw CSV outputs.
4. Distillation should work packet-first and row-first, not by inventing deep internal event reductions.

### 10.4 OxVba
The Replay appliance should lean on existing artifact emission:
1. CSV and JSONL conformance outputs,
2. gate reports,
3. clause coverage records,
4. runner fingerprints.

This keeps replay cheap because many artifacts already exist at runner boundaries.

Additional distillation rule:
1. reduce by case, clause slice, and configuration axis before touching richer host sidecars.

## 11. Design targets
Initial non-binding design targets:
1. `counters` mode should aim for negligible overhead relative to current lane runs.
2. `summary` mode should be cheap enough to leave on in most CI-oriented runs.
3. `replay` mode should be cheap enough to use for pack-grade deterministic runs by default.
4. `forensic` mode may be heavier, but must remain deterministic and bounded.
5. Distillation should converge primarily through indexed reuse, staged reduction, and memoized predicate evaluation rather than repeated full-source regeneration.

These are design targets, not yet doctrine-level thresholds.

## 12. Resulting rule
The Replay appliance must be implemented as:
1. cheap mandatory boundaries,
2. explicit optional enrichments,
3. post-hot-path normalization,
4. sidecar-heavy large payload handling,
5. no silent semantic loss,
6. offline witness minimization built on top of bundle-valid capture.
