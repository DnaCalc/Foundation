Correctness confidence and spec clarity through Round 1 — that's a very focused lens. Here are ten improvements ranked by value-for-effort, drawn directly from the gaps surfaced across the source pack and the architecture synthesis.

---

**1. Split `topology_delta` into facts vs. interpretation**

This is finding F-002 from the report and it's the single cheapest high-impact change. Right now FEC emits `TopologyImpact` values like `SpillBlocked` that are *semantic judgments*, but the spec says the engine owns recalc policy. The fix is mechanical: rename the current `topology_delta` fields to `TopologyFact` (raw evidence — dependency sets changed, spill range coordinates, blocker cell IDs) and move the interpretation (`should I do full recalc or selective?`) into the engine's coordinator. This prevents a split-brain recalc bug class before it takes root, and it clarifies the FEC/F3E contract boundary for anyone reading the spec. Bump the trace schema to `b5`. Effort is small — a struct rename, a new engine-side interpretation function, and trace schema update.

**2. Add early-cutoff verification to incremental recalc**

The architecture report identified this as the highest-leverage single optimization, but the value here is primarily *correctness confidence*, not performance. By comparing each node's recomputed value against its previous value before propagating dirtiness, you get a built-in regression detector: any case where early cutoff produces a different result from full recalc is a bug. Wire it up with an assertion mode that runs both paths and compares. This directly satisfies DAG-PO-001 (acyclic from-scratch equivalence) empirically. The Salsa/rust-analyzer codebase has a well-documented pattern for this ("backdating" a node's `changed_at` revision). Effort is moderate — one new comparison step in the eval loop, one `RecalcState` transition (`Stale → Clean` without re-eval), and a verification harness.

**3. Formalize the session timeout and cleanup contract**

Finding F-012: a hung FEC session currently holds capability guards forever with no specified cleanup. Add `SESSION_TTL` (configurable, sensible default like 30s), auto-abort on expiry, and a new `SessionExpired` rejection class. This closes a real correctness hole (stale overlay state blocking epoch advancement) and makes the spec self-contained for any future implementer. It also forces you to define what "abort" means for overlay cleanup, which feeds directly into Layer Ω design clarity. Effort is small — a timer check in the coordinator, a new reject variant, and spec text.

**4. Write the spill priority tie-breaking rule into the spec**

Finding F-009 and open question OQ-005: when two formulas compete for the same spill region, evaluation order determines the winner, but evaluation order depends on topology that the spill conflict itself can alter. The fix is a one-paragraph normative rule: spill priority is determined by **cell-position order** (row-major, then column-major of the origin cell). This is deterministic, independent of evaluation order, and can be tested with a simple two-formula competing-spill scenario. Excel's behavior here is underdocumented, so DNA Calc gets to define cleaner semantics. Effort is tiny — spec text plus one or two targeted conformance tests.

**5. Extend the rejection taxonomy**

Finding F-013: the current b4 rejection taxonomy covers 9 classes, but at least 5 more are needed for Round 1: `SessionExpired`, `StructuralConflict` (row/col insert during active session), `ProfileVersionMismatch`, `DynamicRefOutOfBounds`, and `ResourceExhausted`. Each missing class means a real failure mode that currently gets silently swallowed or misclassified. Writing these out as spec text with preconditions and expected behavior also serves as a forcing function for thinking through edge cases. Effort is moderate — type definitions, spec text for each, and at least one seam test per new class.

**6. Add `SheetId` to `NodeId` now, before Round 1 forces it**

The formal model defines `NodeId = Cell(CellId) | Name(NameId) | Chart(ChartId)` without a sheet qualifier. VisiCalc is single-sheet, so this works today. But Round 1 (PreCalc) adds multi-sheet, and retrofitting `SheetId` into every node identity, every dependency edge, every trace artifact, and every conformance test is a painful migration. Adding it now while the surface area is small is cheap insurance. Effort is small-to-moderate — pervasive but mechanical type change, mostly compiler-guided in Rust.

**7. Build a from-scratch oracle test harness for dynamic references**

This directly addresses DAG-PO-007 (dynamic from-scratch consistency) and finding F-001 (dynamic references breaking the layer chain). The harness runs every formula containing INDIRECT/OFFSET twice: once via the normal incremental path, once via a clean from-scratch evaluation with no prior state. Results must be bit-identical. The 65-event dynamic retargeting trace shows the seam *works* in tested cases, but a property-based harness that generates arbitrary INDIRECT target sequences would catch the class of bugs where stale overlay state leaks across sessions. Effort is moderate — a proptest/QuickCheck-style generator for INDIRECT scenarios, plus the dual-eval comparison loop.

**8. Write the Layer Ω lifecycle spec**

Findings F-001, F-005, and F-007 all point to the same gap: the calc-time overlay (dynamic refs, tentative spill claims, late-bound deps) has no formal lifecycle definition. Specify when an overlay is created (at `open_session`), what it contains (`R_dynamic`, `D_dynamic`, `S'_spill`), how it interacts with the green tree (reads committed snapshot, writes are session-local), and how commit promotes or discards it. This doesn't require implementation yet — just spec text with clear invariants. It's the single most important piece of spec clarity for Round 1, because every dynamic-reference and spill-related design decision hangs off it. Effort is moderate — several pages of careful spec writing, informed by the architecture report's Ω rules.

**9. Add a conformance test for non-iterative cycle fallback semantics**

REQ-CALC-004 specifies that when iteration is disabled, circular references use Excel-style non-iterative fallback: circular reads use prior stabilized values when available, otherwise `0.0`, with a non-fatal diagnostic. This is one of the subtlest behavioral requirements and the most likely to have hidden divergence from Excel. A dedicated conformance test suite with at least these cases: simple two-cell cycle, multi-cell SCC, cycle involving a name, cycle where prior stabilized value exists vs. doesn't, and cycle with INDIRECT creating the circularity dynamically. Effort is moderate — test design requires care, implementation is straightforward.

**10. Publish a single-page "contract map" linking spec → requirements → conformance → packs**

Right now the traceability chain runs across at least seven documents: `SPEC_v0.md`, `ENGINE_REQUIREMENTS.md`, `ENGINE_API.md`, `ENGINE_CONFORMANCE_TESTS.md`, `ENGINE_FORMAL_PROPERTIES.md`, the DAG conformance/proof obligations, and the FEC/F3E redesign spec. A new contributor has no map showing which requirement satisfies which spec clause, which conformance test covers which requirement, and which empirical pack validates which proof obligation. A single-page cross-reference matrix (requirement ID → conformance test IDs → pack IDs → proof obligation IDs) would dramatically improve navigability and make gaps visible at a glance. This is the highest-leverage spec clarity improvement for a team-scale project. Effort is moderate — mostly editorial, but requires careful reading of all seven docs to build the linkage.

---

If I were sequencing these into a sprint, items 1, 3, 4, and 6 are all under a day each and could ship together as a "spec hardening" batch. Items 2, 5, and 7 form a natural "correctness infrastructure" batch. Items 8, 9, and 10 are the meatier spec-writing and conformance work that sets Round 1 up properly.