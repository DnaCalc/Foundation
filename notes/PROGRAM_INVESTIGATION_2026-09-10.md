# DNA Calc Program Investigation and Campaign Plan — 2026-09-10

**Title:** State of the program after W011, and the "Measured Excel" improvement campaign
**Investigation date:** 2026-09-10 (note landed 2026-09-14)
**Investigator:** Claude Opus 5 (Anthropic), Claude Code session under the Foundation coordination role; campaign-shaping decisions taken by the program owner and recorded in §1
**Target:** repositories directly under `C:\Work\DnaCalc`
**Status:** working note, not doctrine. The campaign plan in §3 was approved by the program owner on 2026-09-10. Doctrine changes it proposes (notably the OxCalc `CHARTER.md` §8 amendment in W1.7) still go through the normal promotion path.
**Predecessor:** `PROGRAM_INVESTIGATION_2026-08-30.md` (pre-W011). This note supersedes it as a *current-state* description, not as doctrine.

## 0. Method, evidence, and limitations

### 0.1 Method

1. **Read-only survey, twelve areas, each adversarially verified** (24 agents). Areas: OxCalc core mechanics; OxCalc Excel-semantics coverage; OxFml language coverage; OxFunc surface truth; OxDoc file boundary; DnaTreeCalc host state; substrate evolvability; performance and scale; fidelity harness; formal assurance; live work queue; a top-down Excel gap map. Each surveyor's load-bearing claims were handed to an independent refuter with instructions to go to the cited code and default to scepticism. Verdicts: 117 confirmed, 39 overstated, 11 understated, 7 refuted. The corrections are folded into §2.
2. **Three independent campaign designs, each attacked by a critic** (6 agents). Framings: engine-first correctness, substrate-first evolvability, evidence-first measurement. All three independently converged on the same first move (delete the faked iterative surface) and the same instrument (the offline cached-value differential); the critics independently found the same false-green trap. §3 is the synthesis.
3. **First-hand verification of every claim the plan rests on**, by the investigator, before writing: the `FileCached` pin at `consumer.rs:6209-6225`; the two `Rc<` sites in `oxfunc_value_types`; `CoercionError::EmptyCell` in `coercion.rs`; error rendering at `coordinator.rs:382`; the Excel-authored fixture bytes (`mc:Ignorable="x14ac xr xr2 xr3"`, `xr:uid`, cached `<v>` values incl. `t="e"` and `ca="1"`); the crate dependency edges used in the W0.1 decision (Appendix A).
4. **Corpus census** (W0.3, executed): every `.xlsx` under the program root outside `target/`, scanned for Excel authorship, sheet count, cells, formula cells, styles, shared/array/dataTable formulas, spill (`cm=`), `@`/`_xlfn.`, `calcChain` depth, `calcPr`, `date1904`, `iterate`. Full output in Appendix B.

### 0.2 Repository HEADs at investigation time

| Repo | HEAD | Date | Tree |
|---|---|---|---|
| Foundation | `3f5ef7b` | 2026-09-01 | clean, 1 ahead of origin |
| DnaTreeCalc | `9644443` | 2026-09-02 | clean |
| OxCalc | `60c6af72` | 2026-09-01 | clean |
| OxDoc | `786ef0c` | 2026-07-11 | clean |
| OxFml | `8bace71` | 2026-07-12 | clean |
| OxFunc | `3e3ebb4` | 2026-09-03 | **dirty**, 145 ahead of origin (the W109 last-bit lane; not inspected further) |
| OxXlPlay | `adcdb51` | 2026-09-02 | clean |
| OxReplay | `0b90052` | 2026-09-02 | clean |

All file:line citations below are against these HEADs.

### 0.3 Limitations

- **No cargo command was run.** This was a read-only investigation by doctrine (shared `target/` directories; see the DnaTreeCalc ICE note in the Foundation memory). Test counts quoted are from retained artifacts and bead close reasons, not fresh runs.
- **No live Excel observation was run.** The Excel-authored fixtures were inspected as bytes.
- Bead counts and `br ready` output are as of 2026-09-10.
- The OxFunc working tree was dirty and was not inspected beyond `git status`.
- Sizes marked S/M/L/XL are the critics' corrected estimates, not measurements.

---


---

## 1. Context

### Why this note exists

The 2026-08-30 investigation concluded the missing piece was a file-backed workbook lifecycle, and named one vertical slice. That campaign — **W011** — ran 2026-09-01 → 09-02 and **closed successfully**: the Tauri desktop shell opens `fixtures/w011/a1_times_three.xlsx` through OxDoc, ingests into `OxCalcDocumentContext`, edits `A1` 7→10 so `B1 =A1*3` recalculates to 30 live, saves through a native dialog, and the reopened bytes carry `<c r="B1"><f>A1*3</f><v>30</v></c>`. Evidenced at host-core, app dispatcher, human desktop click-through, and observed in real Excel via COM. Manual calc mode, cross-sheet and defined-name lanes are green on real bytes.

The question now is the next one: **what moves DNA Calc from a proven keyhole to something a person could fairly call an Excel equivalent — especially in the core calculation engine — while keeping the substrate able to evolve?**

### What the investigation found

A 12-area adversarially-verified survey (24 agents), plus three independently-designed campaigns each attacked by a critic, produced one finding that reorganises everything:

> **The machinery is better than the behaviour, the behaviour is better than the evidence — and the one instrument that would tell us which is which does not exist, is nearly free to build, and would give a false green if built naively.**

**The machinery is genuinely strong.** A two-layer cell-granular dependency index with compressed range edges and a 1024-cell block interval index; 12 typed dependency kinds; a spill ledger with blockers and ghost cells; a coherent per-transaction `WorkbookRecalcTick` with node-keyed splitmix64 RAND streams; typed escalation reasons (`GridSeededLaneOutcome`); a retained parent-linked revision graph with candidate overlays and rebase algebra; ~28 named 1M-cell workloads with retained counter artifacts (8 B/cell dense, 24 B/cell sparse, `SUM(A:A)` visits occupied slots not 2²⁰). And the program's single most valuable asset: **a reference-vs-optimized differential oracle that ships live in the product at `DualValidatedSampled{one_in:16}`**.

**The behaviour does not yet use most of it.** On the live `.xlsx` path: iterative calculation is a hardcoded 4-case table (`excel_match_iterative_fixture_surface`, `OxCalc/src/oxcalc-core/src/treecalc.rs:1726`) returning literal 11.0/22.0/102.0 keyed on `runtime_policy_id` *substrings*, which also emits a convergence diagnostic — so the only Excel-anchored coverage the calculation engine has is fabricated. Volatiles never re-fire (`WorkbookDirtySeed::Volatile` has no constructors anywhere). Almost every real edit escalates to whole-sheet mark-all, and `recalculate_sheet_with_cross_sheet_view` sets `topology_grew_since_recalc = true` **unconditionally** (`consumer.rs:10619`), so multi-sheet workbooks never ride the incremental lane at all. Above 10,000 formula cells mark-all **abandons topological ordering** — a silent stale-input cliff. `=A1+1` with blank `A1` returns `#VALUE!` where Excel returns `1`, and a unit test pins the wrong behaviour. `=TEXT(A1,"0.00")` returns `#VALUE!` because no `LocaleFormatContext` is built on the grid path. Dates render as serial numbers. The 1904 epoch is stored and never reaches evaluation.

**The evidence is thinner still, but not as thin as it first looked.** There *are* Excel-authored workbooks, and the W0.3 census (run 2026-09-10, artifact below) measured them exactly:

| | |
|---|---|
| Excel-authored workbooks (`<Application>Microsoft Excel</Application>`) | **174** of 181 readable |
| Total cells / formula cells | **1,104** / **481** |
| Formula cells, median / max per workbook | **1** / 212 — and 212 of the 481 (44%) are one function-recognition probe file |
| Multi-sheet workbooks | **0** (max sheets = 1) |
| Largest file | **14,955 bytes** |
| Styled cells (`s=`) | 35, across 21 workbooks |
| Shared formulas / CSE arrays / dataTable formulas / `cm=` spill cells / `@` | **0 / 0 / 0 / 0 / 0** |
| Cached error cells (`t="e"`) | 62, across 24 workbooks — genuinely useful for error-vocabulary conformance |
| `_xlfn.` references | 132, across 36 workbooks |
| `calcChain.xml` present | 129 workbooks — but only **18** have 4+ entries, i.e. a real order to compare |
| `date1904` | **1** workbook, and it contains **zero formulas** |
| `iterate="1"` | **2** workbooks (`iterateCount="10"`, `calcMode="manual"`) |
| `calcMode="manual"` | **62** workbooks (36% of the corpus) |

They carry real Excel bytes — `mc:Ignorable="x14ac xr xr2 xr3"`, `xr:uid`, `<row spans>`, `theme1.xml` — and are wired to nothing. But this is a **probe set, not a corpus**: it can bootstrap the instrument on day one and it can arbitrate almost none of the campaign's questions. Cross-sheet escalation, the >10k cliff, styled-cell saves, CSE arrays, spill, `@`, and scale all have **zero** representative workbooks.

### The decisive discovery, and its trap

**Excel already wrote its answers into the files.** Every formula cell in an Excel-saved workbook carries Excel's own computed result as `<v>` — including `t="e"` error values and `ca="1"` volatile markers. `SCN-EB024-OP-CORE.xlsx` literally contains `<c r="B1"><f>"2"+3</f><v>5</v></c>`, `<c r="B2" t="e"><f>"x"+1</f><v>#VALUE!</v></c>`, `<c r="B7" t="b"><f>1="1"</f><v>0</v></c>`. And OxDoc already parses them: `FormulaRecord.cached: Option<CalcValue>` (`oxdoc_ingest.rs:791`), resolved at `:1275`.

So a **cell-by-cell Excel-vs-DNA differential needs no live Excel at all**: open → ingest → recalc → diff computed against the value Excel itself cached. It runs offline, in CI, on a machine with no Office installed. That is the campaign's spine.

**The trap** — verified first-hand at `OxCalc/src/oxcalc-core/src/consumer.rs:6209-6225`: when OxFml **rejects** a formula, OxCalc publishes *Excel's own cached value* as a **persistent pin** with `PublishedValueProvenance::FileCached`. Data Tables, unknown formula kinds and shared-formula region members do the same via `NotCalcModeled`; a `CalcMode::Manual` workbook renders entirely from `FileCached`. **A naive comparator would score every formula the engine cannot handle as a PASS.** The instrument would launder the engine's refusals into a green number — reproducing at corpus scale exactly the self-certification this campaign exists to end.

The fix is a design decision, not a detail, and it governs the whole plan:

> **Provenance decides before value does. Only `PublishedValueProvenance::Calculated { tick_id }` may be scored `Match` or `Mismatch`. `FileCached` / `Stale` / `Degraded` / `NotCalcModeled` are `NotEvaluated{reason}`. And the campaign's primary number is not the mismatch count — it is `engine_calculated_cells / total_formula_cells`. "Green" must always mean *we evaluated X% of the corpus and matched*, never *we matched what we chose to evaluate*.**

### Why good machinery goes unused — the mechanism the campaign has to break

The item list above reads like a mess. It is not many problems; it is one, with five faces, and each face is evidenced:

1. **Two of everything.** The tree lane and the grid lane each carry their own dependency graph, scheduler, cycle detector, cache, epoch system and publication model, and share essentially nothing. So every feature lands in exactly one lane: `SetNumberFormat` is wired in the tree lane and absent from the grid; the entire formal corpus models the tree; the faked iterative table is in the tree and the grid — the `.xlsx` path — has zero iterative code. Machinery built for one lane is invisible from the other.
2. **The machine is what gets proven; the consumer is what runs.** `grid/machine/*` (~28k lines) holds the good machinery. `consumer.rs` (~31k lines) is what DnaTreeCalc actually calls. The 1M-cell counters were produced by the scale harness with materialisation limits 10–100× larger than the live consumer's 100,000-cell cap, on a hand-written R1C1 evaluator. The seeded incremental lane exists in the machine; the consumer sets `topology_grew_since_recalc = true` unconditionally and calls `rebuild_from_input` on Delete and on Manual-mode F9. The dirty-seed vocabulary includes `Volatile`; no production code constructs it. **The gap between machinery and behaviour is, almost literally, one file.**
3. **Escalation is legal, typed, honest — and free.** `GridSeededLaneOutcome` names five escalation reasons; escalating to mark-all is always *correct*; and OxCalc's own charter (§8) says "conservative full rebuild remains legal when compatibility cannot be proven". So every uncertain path escalates, nothing fails for escalating, and no published number anywhere gets worse. A licence with no accounting produces exactly this. The program's honesty culture — which is real and worth protecting — has made correctness-by-escalation the path of least resistance.
4. **The one oracle that could catch it is unwired at the last step.** The reference twin runs on 1-in-16 live recalcs, computes `differential_clean` (`grid_publication.rs:196`), and the host throws it away.
5. **Seams exist but carry no traffic.** `with_function_registry`, `reference_profiles.rs`, `CorrectnessFloorProfile`, the UDF dispatch descriptors — well designed, tested in isolation, never called from the live path. Unexercised seams rot, and they make every audit (including automated ones) read the wrong code as the running code.

**The structural fix is four moves, in this order — they are already in the waves below, but naming them as one move is what matters:**

- **A. Make escalation cost something** *(W1.7 + a one-sentence charter edit)*. Count every escalation reason on the live path per recalc; publish `escalation_rate` next to `coverage` on every instrument run; hold it inside the W1 wall-clock band. Amend OxCalc CHARTER §8 so a conservative full rebuild is legal only when it is counted, reported, and owned by a bead naming its incremental successor. This is cheap and it changes everything downstream, because escalation finally shows up somewhere.
- **B. Make the oracle fail** *(W1.5)*. `differential_clean` becomes a typed failure in tests, CI and the host, proven by injection at the blind sites. From then on, any behaviour that diverges from the reference twin is caught on live recalcs, not in a Vec.
- **C. Route the consumer through the machine, one edit shape at a time, each proven by a counter** *(W5)*. The sites are known and small: `consumer.rs:10619`, `clear_grid_cell`, Manual-mode F9, the new-cell write, the `Volatile` constructors, the `LocaleFormatContext` builder. Each lands with "cells actually evaluated below a named bound on a named workbook" — never with the outcome enum, which the code assigns itself.
- **D. Remove the alternatives, so the machine's path is the only path** *(W0.4, W3.4, W5b, W7)*. Delete the faked iterative surface. Demote the R1C1 second evaluator to a proved specialisation of OxFml, or delete it. Wire or delete every dead seam. And add an arch check in OxCalc — the same pattern DnaTreeCalc already runs for crate tiers — asserting that every production enum variant (`GridDirtySeed`, `WorkbookDirtySeed`, `GridSeededLaneOutcome`, the dependency kinds) has a non-test constructor and a counter. A seam that carries no traffic becomes a failing test, not a rot.

**And the move the dual-profile decision makes unavoidable: one machine, two profiles** *(W5b)*. Face 1 is the deepest cause, and wiring does not remove it. The grid machine's dependency index already carries name, name-identity, table, sheet-span and dynamic-request kinds — it is already more general than a grid. The convergence target is: the grid machine becomes the single calculation core, parameterised by an address profile (`NodeKey` vs `ExcelGridCellAddress`) and a reference-resolution profile, with the tree lane a thin adapter over it. That is XL work, and it is the only way "both profiles, one cell model" stays true rather than asserted. It has to wait until the grid machine is proven on the live path (W5) and has to land before any second large feature goes into either lane.

### Intended outcome

When the campaign closes, all of these are demonstrably true:

1. One command runs a **provenance-first, cell-by-cell Excel-vs-DNA differential** over a licensed corpus of real Excel-authored workbooks — in CI — and reports **coverage and per-class divergence**, going red on regression.
2. The named wrong-answer classes are **fixed, or explicitly typed as unsupported** — never faked.
3. The substrate decisions that get strictly more expensive with time are **made now**, while they are still cheap (several are far cheaper than believed: `Rc`→`Arc` is **two struct fields**).
4. Both profiles — `strict-excel-grid` and `treecalc-v1` — are first-class and **share one cell model**.

### Owner decisions taken before planning

| Question | Decision |
|---|---|
| Which lane does the campaign serve? | **Both, explicitly dual-profile.** Neither lane forks the cell model. |
| Exit condition | **Real-workbook differential** — automated, single-command, cell-by-cell. |
| OxFunc last-bit exactness (W109/ERFC) | **Parallel lane; nothing in the campaign waits on it.** Closure language must not claim bit-exactness it has not earned. |
| Corpus source | **Public permissively-licensed research corpora** (Enron/EUSES/FUSE-class), licence and provenance recorded per corpus. |
| Excel oracle host | **Plan for both** — a swappable oracle: live COM when available, retained-artifact replay otherwise, same verdict path. |
| Campaign size | **Full program push**, multi-wave, across OxCalc / OxDoc / OxFml / OxFunc / DnaTreeCalc. |

---

## 2. Corrections to carry forward

Several widely-repeated claims in the program's own notes are wrong. Fix them in-band as they are touched.

| Claim in circulation | Reality (verified) |
|---|---|
| "No Excel-authored `.xlsx` exists anywhere in the program" | 173 exist (`Foundation/research/runs/**/fixtures/`, `OxCalc/docs/test-runs/excel-cycles/**`); 205+ program-wide. They are tiny and single-sheet, but they are real Excel bytes. |
| "Errors render as a Rust `Debug` string" | Already fixed: `coordinator.rs:382` renders via `oxfml_core::format::worksheet_error_text`. |
| "`Rc`→`Arc` is an XL migration" | Exactly **two** `Rc<` in `oxfunc_value_types` (`lib.rs:388` `rich`, `lib.rs:724` `handle: Rc<dyn OpaqueCallable>`), ~3 production construction sites. ~1 day of typing. The real constraint is `OpaqueCallable: Send + Sync` for LAMBDA closures. |
| "Explicit `@` is rejected before evaluation" | OxFml lexes it (`syntax/lexer.rs:52`), parses it at 4 sites, and binds `ImplicitIntersection`. The corpus contains **zero** `@`. **Reproduce the real failure before scoping any work.** |
| "`error_algebra` / the 3,700 dead profile lines should be deleted" | `error_algebra.rs` is imported non-test by `correctness_floor.rs:8`. ~1,600 of those lines are not deletable. The genuinely uncalled module is `reference_profiles.rs` (165 lines) — the one to **wire**, not delete. |
| "One OxFml front end per formula is pure wiring" | `calc-nhr4` was **attempted and reverted** (OxFml `e026cc0`, OxCalc `6ce9ce17`) after a measured **2.2× regression**; its recorded prerequisite is the Arc migration. |
| "DnaTreeCalc has no green test command" | It does, per package. `dtc-g43s` is a P3 affecting only multi-package co-testing, with the fix written in the bead. Hours, not a blocker. |
| "Copy the OxVba CI pattern" | There is **zero** CI in every campaign repo. Eight greenfield pipelines. Size it honestly. |
| "47 of 173 non-matches are the 15-digit boundary" | Misread. The run was 1042 cases → 869 matched / 126 mismatched / 47 **blocked**; 47 of the *126* are the display boundary. And the defect is on the **capture** side (`ObservedSurface.value_json` carries no raw f64 bits), not a missing engine publication rule. **Do not corrupt the engine to match a lossy capture.** |

---

## 3. The campaign

Nine waves. Each has a falsifiable exit. Waves are dependency-ordered; the parallel lanes below run alongside and nothing waits on them.

### W0 — Decide, prove, stop lying *(days)*

| # | Work | Detail |
|---|---|---|
| 0.1 | **Decide the harness's home** — DONE 2026-09-14, see Appendix A | Blocks everything in W1. `oxcalc-tracecalc-cli` cannot open `.xlsx` (2 deps), and `oxcalc-core` deliberately takes only `oxdoc-model`. **Recommended: a new crate in the DnaTreeCalc host tier** (`dnacalc-conform`, lib+bin) beside `dnacalc-host-core`, which already holds both handles since W011 widened the F-tier dependency check (`dnacalc-arch-gates`) to oxdoc, and which is the architecturally correct owner of the document lifecycle. Alternative considered and rejected: `OxDoc/crates/oxdoc-conformance` (already has `oxdoc-xlsx` + `compare_transcript`/`compare_events`/`compare_ledger`) would make OxDoc depend on OxCalc, inverting repo layering. |
| 0.2 | **Prove the false green before building on it** | Load one fixture whose formula OxFml rejects, recalc, read the published value, show it equals Excel's cache with `FileCached` provenance (`consumer.rs:6209-6225` → `:1714-1720`). Commit it as a test. Five minutes of work; it is what makes the comparator design correct instead of self-certifying. |
| 0.3 | **Census the corpus's size and shape** — ✅ **DONE 2026-09-10** | Per workbook: cells, formula cells, sheets, styled cells, `cm=`/richData, `calcChain` depth, `calcPr`. Results in §1 above and in full in Appendix B. The census method (zip + XML scan per worksheet part) should become a `dnacalc-conform census` subcommand in W1.2 so it is reproducible in-repo; Foundation's tooling policy disallows committing the Python that produced this first run. **Two consequences already folded into W1 and W2: the Manual-mode coverage trap, and the exact fixture shortfall.** |
| 0.4 | **Delete the faked iterative surface** | `treecalc.rs:1726`; land on the already-filed **`calc-9ouy.3`** (P1, OPEN). Withdraw in-band every W048/W055 conformance claim keyed on `excel_iter_two_node_order_001`, `excel_iter_three_node_order_001`, `excel_iter_fraction_precision_001`, `excel_ctro_indirect_iterative_self_001`. Replace with a **behavioural** tripwire (a property test that the tree iterative path returns a typed `IterativeCalcNotImplemented` for *every* input, those four ids included) — not a grep check, which only tests spelling. |
| 0.5 | **Negotiate writer slots** | DnaTreeCalc is running the W011 successor relay (`dtc-j7n8`) with an explicit one-implementer rule over `command.rs` / `lib.rs` / `workbook.rs`. Add `dnacalc-bench-host/src/services/verification_bundle.rs` (301 KB, shells `cargo run` into two other repos with hardcoded paths) to the single-writer list. |

**Exit:** harness home decided and recorded; the FileCached false-green demonstrated in a committed test; corpus shape published with per-workbook counts; the iterative fake gone with claims withdrawn and a behavioural tripwire in place.

---

### W1 — The instrument *(the campaign's spine)*

Build `dnacalc-conform` — argument-taking, no absolute paths.

**The runner.** Corpus dir → per workbook: OxDoc open (`LoadProfile::full()`) → OxCalc ingest → force full recalc → for every cell carrying both `<f>` and `<v>`, run the verdict ladder.

**The verdict ladder — provenance first, always:**

```
1. read GridPublishedCell.provenance and WorkbookTierALoadOutcome.bind_degradations
2. FileCached | Stale | Degraded | NotCalcModeled   -> NotEvaluated { reason }
   CalcMode::Manual whole-file                       -> NotEvaluated { manual_mode }
   volatile (ca="1") / RAND / NOW / TODAY            -> Excluded { nondeterministic }
3. only Calculated { tick_id }                       -> Match | Mismatch { class }
```

**The primary number is coverage.** `engine_calculated_cells / total_formula_cells`, per workbook and corpus-wide, printed on every run alongside per-class red. A class total without a denominator is meaningless. `Unclassified` must be zero — and *widening a class to reach zero requires a named bead*, or the rule is worthless.

| # | Work | Notes |
|---|---|---|
| 1.1 | Runner + verdict ladder + retained `divergence.v1.json` | Corpus sha256 set pinned into the artifact. |
| 1.2 | Reader-ceiling report | cannot-open / opened-with-ledger-degradation, per part and construct. This is the OxDoc backlog W6 will work from — the repo currently has one open P4 bead over an enormous known gap. |
| 1.3 | **Force a full recalc regardless of the file's `calcMode`** | **62 of the 174 corpus workbooks carry `calcMode="manual"`**, and per `consumer.rs:6407` a Manual workbook renders entirely from `FileCached` — evaluating nothing. Without a forced full recalc (Excel's Ctrl+Alt+F9 equivalent) those 62 workbooks contribute **zero coverage** and the instrument silently measures a third less than it appears to. |
| 1.4 | **The calcChain oracle** *(cheap, small)* | 129 corpus workbooks ship `xl/calcChain.xml` — **Excel's own dependency order**, free and offline, never used by this program. But the census shows only **18** have 4+ entries, so build it as a day of work, not a workstream. It is still the only available oracle for the scheduler itself, and it grows for free with the W2 corpus. |
| 1.5 | **Make the shipping reference twin fail loudly** | `differential_clean` is computed at `grid_publication.rs:196` and thrown away; the host drops it. Make mismatches a typed failure. Prove it by injecting wrong values at the **known-blind** sites: the >10k mark-all fall-through (`optimized_sheet.rs:3170+`), the cross-sheet escalation (`consumer.rs:10619`), and a cell whose value is FileCached-pinned. A leaf-arithmetic injection proves nothing. |
| 1.7 | **Count escalations on the live path** | Every `GridSeededLaneOutcome` escalation reason and every `rebuild_from_input` on the live consumer path becomes a per-recalc counter, reported by the instrument as `escalation_rate` beside `coverage`. Pair with a one-sentence amendment to OxCalc CHARTER §8: a conservative full rebuild is legal only when counted, reported, and owned by a bead naming its incremental successor. Until this lands, escalation is free and W5 has nothing to push against. |
| 1.6 | **First grid-engine wall-clock + allocation baseline** | Cold and single-cell-incremental, on three named workbooks, machine identity recorded, with an **explicit tolerance band**. The M-2 phase timers already exist (and compile to zero on wasm32 — note that). This must land *before* any `CalcValue` or scheduler change, or the campaign cannot detect the regressions it is about to cause. |

**Exit:** one command, run from a path it was not compiled with, produces a retained baseline carrying coverage %, per-class red, per-workbook denominators, and the corpus hash set. Injected wrong values at all three blind sites fail the twin check. Wall-clock baselines retained with bands.

---

### W2 — A corpus that can arbitrate

The existing 173 files bootstrap the instrument and cannot settle its questions: zero multi-sheet, 35 styled cells, median 5 cells.

| # | Work | Notes |
|---|---|---|
| 2.1 | Admit public research corpora | Enron / EUSES / FUSE-class. **Per-corpus licence and provenance recorded in the corpus manifest**, and a clean-room note: these are third-party workbooks used as black-box inputs, consistent with the charter's reproducible-observation rule. |
| 2.2 | **Admission thresholds, enforced by the runner** | ≥1 workbook >10,000 formula cells; ≥N multi-sheet; ≥N with >100 styled cells; ≥N with tables / CF / data validation; ≥N with spill (`cm=`); ≥N with external links. The runner **prints and fails on** admitted formula-cell count, sheet count and largest workbook — not just workbook ratio. |
| 2.3 | Author the missing fixture families in Excel | The census gives the exact shortfall — the probe set has **zero** of each of: multi-sheet workbooks (cross-sheet ref, cross-sheet *backward* ref, cross-sheet name), CSE array formulas, shared formulas, `cm=` spill cells, `@` / `_xlfn.SINGLE`, and any workbook over 15 KB. It has **one** `date1904` workbook and that workbook has **zero formulas**, so the 1904 check as currently imagined is vacuous; and **two** `iterate="1"` workbooks, which are exactly the W048 fixtures W0.4 is de-faking. Each of these is a mandatory W4/W5 exit condition with no probe behind it today. |
| 2.4 | Synthetic scale generator, Excel-round-tripped once | So the bytes are genuinely Excel-authored while the shape is chosen. |

**Exit:** corpus admitted above stated thresholds with licence lines; the runner fails below the committed floors; W1's baseline re-run and re-published on the real corpus.

---

### W3 — Substrate decisions, taken while they are cheap

Small, mostly parallel-safe, and each strictly more expensive later.

| # | Decision | Now | Later |
|---|---|---|---|
| 3.1 | **`Rc` → `Arc` in `oxfunc_value_types`** (`lib.rs:388`, `:724`) + `OpaqueCallable: Send + Sync` | ~1 day | Permanent once a public API hardens around `!Send`. **Honest exit:** a real two-thread recalc on a named corpus workbook passing `DualValidated` — *or* the workstream is explicitly deferred with the blocker documented. Do **not** promote the `assert_send` audit out of `#[cfg(test)]` into a bare `const` — it would break the build, and `assert_send` going green proves nothing on its own. Coordinate with OxFml's live `fml-oh8` callable-subsystem epic. |
| 3.2 | **Reify the operation vocabulary** | days | A quarter, once the 56 ad-hoc `&mut self` verbs in `consumer.rs` become 90. Today the grid vocabulary is two variants (`SetCell`, `FillRange`) and the tree lane has a *richer* one (`StructuralEdit`). **Unify both — this is the dual-profile constraint's sharpest test.** |
| 3.3 | **Bind `{profile_id, profile_version}` to documents** | S–L | Unbounded once user documents exist. One vocabulary, not four; wire the written-but-dead `reference_profiles.rs`; a version mismatch becomes a typed error, not the current silent `continue`. |
| 3.4 | Verdict on the disconnected profile cluster | 1 week | Scope corrected: `reference_profiles.rs` (165 lines) is the uncalled one and should be **wired**; `error_algebra` is live via `correctness_floor`. Wire or delete — but stop letting the code that *looks* like the evolvability story be code that never runs. |
| 3.5 | Schema id becomes a real constant | S | The `oxfunc_value_types` wire id is hand-typed as a bare literal in 11+ places across three repos with zero validator. |
| 3.6 | Fix the lossy snapshot + add a migration ladder | M | `export_workspace_snapshot` (`consumer.rs:7914-7942`) **silently omits `state.grids`** — the engine's own serialisable format loses every cell, and `.dnatree.json` embeds it. Persisted state is strict-equality-or-reject with no migration path. |

**Exit:** each decision landed with a behavioural test, or explicitly deferred with a named bead and a stated trigger condition. No decision left implicit.

---

### W4 — Engine correctness

Census-ordered — **plus four mandatory families the probe corpus cannot rank but that are known wrong**.

**Mandatory regardless of census position:**

| Family | Where | Note |
|---|---|---|
| **Blank-cell coercion** | `OxFunc/crates/oxfunc_core/src/coercion.rs:13,81,94` — `CoreValue::Empty => Err(CoercionError::EmptyCell)` | Excel's most common formula shape. This is **OxFunc** — a fourth repo the designs kept mis-assigning — and the wrong behaviour is pinned by a test. |
| **Topological scheduling at every size** | `optimized_sheet.rs:2928-2932` guard; `invalidation.rs:2831` | **Do not just delete the 10,000 guard** — `next_ready_dirty_formula` is `pending.iter().find(...)`, i.e. O(P²), so deletion trades a wrong answer for a quadratic one. Replace with a real indegree / Kahn ready list. Must stay inside the W1 wall-clock band. |
| **1904 epoch + `calcPr`** | ingest → evaluation | 1462-day silent wrong-answer class. `fullCalcOnLoad` / `forceFullCalc` / `calcId` are not parsed, modeled or emitted anywhere. |
| **`LocaleFormatContext` on the grid eval path** | grid evaluator | `TEXT` / `VALUE` / `DOLLAR` / `FIXED` currently return `#VALUE!`. The engine exists in OxFml; a builder call is missing. |

**Census-ranked, then:** one error vocabulary end-to-end (OxDoc truncates unknown errors to `#N/A`; OxCalc carries a second, 7-vs-14-variant universe plus a dead precedence table) · legacy CSE arrays as one array formula instead of N wrong copies · lazy control forms beyond IF/IFERROR (IFS, CHOOSE, SWITCH, IFNA are eager) · union/intersection **values** (the only end-to-end test asserts `#REF!`) · `_xlfn.` normalisation (the corpus's most common modern-Excel artifact; 64 occurrences in one file) · Automatic-mode load stops full-recalculating when `calcId` matches · **transactional grid edits** (`apply_grid_edit` mutates authored truth at `consumer.rs:5233-5245` *before* recalc, and mints the revision only after `?` — so any engine error leaves committed state, dropped dirty seeds and no revision).

**Reproduce before scoping:** `@` implicit intersection. OxFml already handles it; the reported failure is elsewhere and nobody has reproduced it.

**Exit:** every mandatory family at zero on a **named probe workbook each**, independent of census rank; coverage strictly up; no `Match` count improved by a cell moving *into* `NotEvaluated`; every semantics change carries a profile-version bump.

---

### W5 — Scheduler truth: incremental, volatile, iterative

| # | Work | Notes |
|---|---|---|
| 5.1 | Kill the unconditional mark-all | `consumer.rs:10619`. **Cannot start until W2's multi-sheet fixtures exist** — otherwise it is untestable. |
| 5.2 | Stop discarding the retained valuation | `clear_grid_cell` (Delete key) and Manual-mode F9 both call `rebuild_from_input`, so Manual — the mode users pick *because* the workbook is large — guarantees a full rebuild. |
| 5.3 | Volatile seeds get real constructors | `GridDirtySeed::Volatile` is test-only; `WorkbookDirtySeed::Volatile` has none. **Behavioural test:** seed the provider (`WorkbookVolatileRandomProvider` is already `Send`), run two consecutive F9s, assert volatile cells change and non-volatile cells do not. Excluding RAND/NOW from comparison and calling the volatile check green is exactly the vacuous move to avoid. |
| 5.4 | **Real iterative/circular calculation in the grid lane** | Consumes ingested `IterationSettings`. A circular reference must stop failing the **edit verb**. **Dual-profile:** W0 removed the tree lane's (fake) iterative answer — this wave must give the tree lane a real one too, not leave it worse off. |
| 5.5 | Cost of an edit | Kill the per-edit deep clone of the valuation and both dependency indexes; publication is O(all authored cells) → delta; the host re-projects every sheet twice per commit (`dtc-j7n8.22`); wire `SetGridInterest` (an accepted no-op in the workbook lane); intern `ExcelGridCellAddress` (two heap `String`s per graph key). |
| 5.6 | Retry `calc-nhr4` | One OxFml front end per formula — **only after 3.1**, and only with the A/B measurement that caused the 2.2× revert. |

**Exit:** proven by **cells-actually-evaluated counters below a named bound** for four named edit shapes on multi-sheet corpus workbooks — not by `GridSeededLaneOutcome::Incremental`, which is a label the code assigns itself. `DualValidated` green throughout. Wall-clock inside the W1 band.

---

### W5b — One machine, two profiles *(runs alongside W6; XL)*

The convergence the dual-profile decision requires. Today the tree lane (`treecalc.rs` + `dependency.rs` + `coordinator.rs` + `recalc.rs`, ~13k lines) rebinds every formula and rebuilds `DependencyGraph` from scratch on every recalc, schedules every formula owner under `PullFullClosure`, and shares no scheduler, cycle detector, cache or epoch system with the grid machine.

Target: the grid machine (`grid/machine/*`) becomes the one calculation core, parameterised by an **address profile** (`NodeKey` vs `ExcelGridCellAddress`) and a **reference-resolution profile** (the already-written `reference_profiles.rs`), with `treecalc-v1` a thin adapter over it. The grid dependency index already models name, name-identity, table, sheet-span and dynamic-request kinds, so the tree's node graph is a subset, not a sibling.

Order inside the wave: (1) the operation vocabulary is already unified by W3.2; (2) move the tree lane's *reads* (published values, dependency facts, invalidation reasons) onto the grid machine behind the adapter, with the tree corpus tests as the oracle; (3) move the tree lane's recalc onto the grid scheduler; (4) delete the tree lane's private `DependencyGraph`, `Stage1RecalcTracker`, `EdgeValueCache` and cycle detector; (5) the iterative engine from W5.4 is then one implementation serving both profiles, which is how W0.4's deletion gets repaid on the tree side.

**Exit:** the tree corpus (`dnatreecalc-host` tests, `.dnatree.json` fixtures) is green with `treecalc.rs` no longer owning a dependency graph or scheduler; `grep -c "struct DependencyGraph" OxCalc/src/oxcalc-core/src/` is 1; both profiles pass the reference-twin check; the W1 wall-clock band holds for both.

---

### W6 — The file boundary

This is the hard ceiling on the product. OxDoc is clean-tree, dormant 8.5 weeks, with one open P4 bead over all of it — **staff it deliberately or the wave will not happen**.

Typed rejection taxonomy (≈198–246 sites → one `String` today) · **styled-cell value edit** (`cell_start_tag_supported_for_surgical_replacement`, `oxdoc-xlsx/src/lib.rs:8439` — a nine-line predicate rejecting any attribute but `r`/`t`) · **sharedStrings preservation on text edits** (today a text edit regenerates the whole table from flat strings, destroying rich text, phonetic guides and `xml:space` — silent corruption, not a refusal) · cell add · formula add/remove · sheet lifecycle · `FreshExport` becomes a real **New workbook / Save As** (today saving requires a backing source) · spill (`cm=`) representable · reader hardening against real Excel bytes **starting day one as a parallel lane**.

**Exit:** round-trip mode (open → edit N cells → save → reopen → diff, plus byte comparison of untouched parts) green over the corpus, with the allowlist **bounded as a fraction of corpus formula cells, not by class count**, and that fraction lower than a number named before the wave started. Plus: open → edit a styled cell → save → **opens in real Excel without a repair prompt**.

---

### W7 — Display truth

Number format and display text on `GridCellProjection` (which today carries row/col/value/value_epoch/authored/provenance and nothing else). This is a **three-way** unification, not two: `WorkspaceIntent::SetNumberFormat` is wired skin→host in the tree lane but stops before the engine — there is no engine-side model to unify *to*.

Build the display oracle **offline from `styles.xml` numFmt codes**, not from live COM. Then the 15-significant-digit question: fix the **capture** side first (`ObservedSurface.value_json` carries no raw f64 bits or xlcall error code) and only then decide whether an engine publication rule is warranted.

**Exit:** retained display-mismatch baseline; a real workbook renders dates as dates and errors as Excel codes in the desktop app; `SetNumberFormat` reaches the engine in both profiles.

---

### W8 — CI, oracle unification, closure

Eight greenfield pipelines (zero exist in the campaign repos; only `OxVba/.github/workflows/ci.yml`). The Excel leg is a **swappable oracle**: live COM when a Windows runner is available, retained-artifact replay otherwise, **same verdict path either way** — the offline cached-value differential already runs everywhere with no Office installed.

Pin the Excel build and make a pin mismatch a failure. One observation schema. Declare one canonical COM lineage of the four (OxXlPlay PowerShell 5,950 lines / Foundation `excel-probe` C# / OxFunc smart-fuzzer / OxFml oracle notes) and retire or retarget the rest. Turn the smart-fuzzer's 17k comparisons into a re-runnable check with a retained baseline.

**Exit — the campaign closure statement, with a coverage floor:**

> One command, in CI, on a machine that is not the owner's, opens the admitted corpus, evaluates ≥ X% of its formula cells in the engine (not from file cache), and matches Excel's own recorded values on all of them, with the Excel build recorded, the corpus hashed, and every allowlisted exclusion named with an owning bead.

---

## 4. Standing rules (not waves)

**Dual-profile discipline.** Every engine change lands in a form both profiles consume. The tree lane gets its own instrument slice and keeps an honest iterative answer. The cell model is not forked. Watch for this actively: all three independent designs asserted the constraint and then quietly served the grid lane only.

**Escalation is never free.** Every conservative fallback on the live path is counted, reported beside coverage, and owned by a bead naming its incremental successor. A seam with no production caller is a failing arch check, not a design intention. This is the rule that stops the "good machinery, unused" pattern from re-forming after the campaign.

**Honesty actions, in-band as touched.** The faked iterative table (W0.4) · the discarded `differential_mismatches` Vec (W1.4) · `scripts/onecalc/run-host-compare-regression.ps1`, a self-declared vacuous check that still ships · the red 1-ULP `finite_combinatoric_witnesses_match_excel_bits` test, neither fixed nor catalogued · `W046RustRefinementBridge.lean`, cited as the Lean↔Rust closure and not a refinement bridge · `CoreEngineW048CycleRegions.tla`, which cannot even parse · OxFml's open P0 pointing at the archived DnaOneCalc · the ~96 "ready" beads that are already implemented · the app silently dropping OxDoc's fidelity ledger and OxCalc's bind degradations on open.

**Parallel lanes, gating nothing.** OxFunc W109 exactness (per owner decision) · OxVba / OxForms · ExcelFunctionsHandbook · OxIde · OxVba's 34 stale worktrees (separate hygiene authorisation).

**Explicitly out of scope.** Charts · pivot tables · co-authoring / collaboration (the revision + candidate substrate is the natural home when it is wanted — it is not wanted now) · `.xlsb` · encryption · a second delivery engine (.NET) · formalisation (W049) — it would formalise the **legacy tree lane**, since the entire OxCalc formal corpus models the lane the product no longer calculates with. Revisit only after W5.

---

## 5. Orchestration

**Serialisation.** DnaTreeCalc has one shared `target/`; concurrent `cargo` invocations there produce rustc ICEs. One cargo at a time per repo; parallel agents only across repos; one committer per repo.

**Single-writer files.** `OxCalc/src/oxcalc-core/src/consumer.rs` (31.5k) · `grid/machine.rs` (28.4k) · `OxDoc/crates/oxdoc-xlsx/src/lib.rs` (~28.9k) · `DnaTreeCalc/src/dnacalc-bench-host/src/services/verification_bundle.rs` (301 KB, shells `cargo run` into two other repos with hardcoded paths) · the W011 relay's `command.rs` / `lib.rs` / `workbook.rs`.

**In-flight collision.** DnaTreeCalc is running `dtc-j7n8` with a one-implementer rule. Negotiate the slot in W0.5 before W1 starts.

**Beads.** One epic per wave, per repo, labelled for the campaign. Beads must be self-contained (implement from `br show <id>`, not from this document). Reconcile the stale ready queue first — several P0/P1 "ready" items are already implemented, and `br ready` is currently a misleading signal. Adopt the beads that already exist and match: `calc-9ouy.3` (delete the fake, P1 OPEN), `dtc-j7n8.22` / `.24`, `dtc-o4t1`, `dtc-g43s`, `oxreplay-5nn` / BLK-REPLAY-005.

**Staffing warning.** OxDoc (dormant 8.5 weeks, 1 open bead) and OxFml (dormant 8.5 weeks, four beads IN_PROGRESS since 2026-05-01, a P0 epic open, and a live `fml-oh8` epic) carry heavy load in W3/W4/W6. Neither is idle by choice, and semantic authority is visibly drifting downstream into OxCalc. Assign owners explicitly.

---

## 6. Verification

Run at each wave exit, and end-to-end at closure.

```bash
# The instrument — the campaign's primary signal (offline, no Excel needed)
dnacalc-conform diff --corpus <dir> --out runs/<id> --require-coverage 0.80
```

```bash
# Per-repo floors, one at a time (shared target dirs)
cargo test --workspace --offline --quiet
```

```bash
# DnaTreeCalc: per package until dtc-g43s is fixed
cargo test --offline -p dnacalc-host-core && cargo test --offline -p dnatreecalc-host
```

```bash
# Scheduler oracle: Excel's own dependency order, from the files
dnacalc-conform calcchain --corpus <dir> --compare-schedule
```

```bash
# Round-trip: open -> edit -> save -> reopen -> diff, plus untouched-part bytes
dnacalc-conform roundtrip --corpus <dir> --allowlist-budget 0.02
```

Manual checks that no command can replace: open a real multi-sheet workbook in the desktop shell and confirm dates render as dates, errors as `#DIV/0!`, a styled cell edits and saves, and the saved file opens in Excel with **no repair prompt**.

**Exit-condition hardening rules, applied to every wave:**
- Coverage is reported before divergence, always.
- A cell moving into `NotEvaluated` never improves a score.
- Allowlists are bounded as a fraction of corpus formula cells, and the fraction is named before the wave starts.
- Behavioural tests, never grep checks or self-assigned outcome enums.
- Injection tests target the known-blind sites, not leaf arithmetic.

---

## 7. Risks

| Risk | Mitigation |
|---|---|
| **The instrument gives a false green** via `FileCached` pinning — the single largest risk, and it would recreate the exact pathology the campaign exists to end. | Provenance decides before value does (W0.2 proves it first, W1.1 implements it). Coverage is the primary number. Hand-audit ≥20 `Match` verdicts at the W1 baseline confirming each came from `Calculated{tick_id}`. |
| **The corpus cannot arbitrate** — a green number over 5-cell single-sheet probes. | W2 admission thresholds, enforced by the runner, with admitted formula-cell count printed on every run. |
| **W4/W5 make the product slower before faster** — removing mark-all shortcuts and the >10k guard trades wall-clock for correctness, and someone will want to revert. | W1.5 lands the baseline *first*; the >10k guard is replaced with a real ready list rather than deleted; bands are explicit; a slow correct answer is a bug report, a fast wrong answer is a lost user. |
| **The dual-profile constraint is asserted and abandoned.** All three independent designs did exactly this. | A standing rule with its own check: the tree lane gets an instrument slice and keeps a real iterative answer; the operation vocabulary unifies both. |
| **OxDoc/OxFml staffing.** Two dormant repos carry the heaviest waves. | Named owners in W0; OxDoc reader hardening starts day one as a parallel lane with no upstream dependency. |
| **Coordination cost.** Four repos, single-writer god files, one CI, an in-flight relay. | W0.5 negotiates slots; per-repo committer; parallel work only across repos. |

---

## Appendix A. W0.1 decision record — the harness's home

**Decision (2026-09-14): the instrument is a new DnaTreeCalc workspace crate, `src/dnacalc-conform` (lib + bin), in the TC/Calc tier beside `dnacalc-host-core`.**

Evidence the decision rests on (all verified 2026-09-14):

| Candidate home | Dependency facts | Verdict |
|---|---|---|
| `OxCalc/src/oxcalc-tracecalc-cli` | `Cargo.toml` has exactly two dependencies: `oxcalc-core`, `oxcalc-tracecalc`. `oxcalc-core` takes only `oxdoc-model`, with an explicit comment: it is the "neutral document model … byte-free (serde-only)". Taking `oxdoc-xlsx` into OxCalc would reverse a deliberate boundary. | Rejected |
| `OxDoc/crates/oxdoc-conformance` | Already depends on `oxdoc-model`, `oxdoc-xlsx`, `zip`, and exposes `compare_transcript` / `compare_events` / `compare_ledger`. But it cannot recalculate: adding `oxcalc-core` would make OxDoc depend on OxCalc, inverting repo layering (OxCalc → oxdoc-model today). | Rejected |
| **`DnaTreeCalc/src/dnacalc-conform` (new)** | The workspace already declares `oxcalc_core`, `oxdoc_model`, `oxdoc_xlsx` and `oxdoc_conformance` as workspace dependencies (`Cargo.toml:50-59`). `dnacalc-host-core` already takes `oxcalc_core` + `oxdoc_model` + `oxdoc_xlsx` as normal dependencies and is the pinned inverted control of the crate-tier law (`dnacalc-arch-gates/tests/gates.rs`, "host-core may take OxDoc because it owns the file-backed workbook lifecycle"). `HostCommand::OpenXlsxBytes` → ingest → `WorkbookSession` → `recalculate_workbook` is the path the product runs. | **Chosen** |

The deciding argument is not convenience. The instrument has to measure **the path the product actually runs** — the live consumer path through `dnacalc-host-core`, not a harness path inside the engine repo. Face 2 of the mechanism in §1 ("the machine is what gets proven; the consumer is what runs") is exactly the failure a harness in OxCalc would repeat.

Constraints the new crate inherits:

1. TC tier: it may take `dnacalc-host-core`, `oxcalc_core`, `oxdoc_model`, `oxdoc_xlsx`, `oxdoc_conformance`. It must never be a dependency of any TP or TF crate, and must not be added to `TP_CRATES`. Add a positive-control test to `dnacalc-arch-gates` mirroring `inverted_control_host_core_contains_oxdoc`.
2. It reads `.xlsx` files from disk as bytes (`std::fs::read`) and hands them to `HostCommand::OpenXlsxBytes`; it does **not** take a zip crate of its own. Where it needs part-level facts (calcChain depth, `calcPr`, `cm=`), it goes through `oxdoc_conformance` / OxDoc's model events, per the host-core `Cargo.toml` rule "this repo never takes a zip crate or touches xlsx bytes itself".
3. It runs `recalculate_workbook` unconditionally after ingest, regardless of the file's `calcMode` (62 of 174 corpus files are `manual`; see §1).
4. It reads `PublishedValueProvenance` per cell and applies the verdict ladder in §3 W1 before any value comparison.
5. It takes the corpus directory and the output directory as arguments. No absolute machine paths in source.
6. DnaTreeCalc's shared `target/`: one cargo invocation at a time; the W011 relay's single-writer rule over `command.rs` / `lib.rs` / `workbook.rs` still applies. The new crate has its own files and does not need those.

Recorded as DnaTreeCalc epic `dtc-*` "W0 — Decide, prove, stop lying" (see the bead graph); W0.1 is closed with this record as its close reason.

## Appendix B. Corpus census (W0.3), 2026-09-10

Method: every `.xlsx` under `C:\Work\DnaCalc` outside `target/`, `node_modules/`, `.git/`; Excel authorship from `docProps/app.xml`; per-worksheet XML scanned for `<c`, `<f`, `s=`, `t="shared"`, `t="array"`, `t="dataTable"`, `t="e"`, `cm=`, `@` / `_xlfn.SINGLE`, `_xlfn.`; `xl/workbook.xml` for `calcPr`, `date1904`, `iterate`, `definedName`; `xl/calcChain.xml` entry count.

```text
==============================================================================
DNA CALC WORKBOOK CORPUS CENSUS  (W0.3)
==============================================================================
workbooks readable          : 181   (unreadable: 0)
Excel-authored (app.xml)    : 174

--- SCALE (Excel-authored only) ---
total cells                 : 1,104
total formula cells         : 481
formula cells  median / max : 1 / 212
cells          median / max : 5 / 216
sheets         max          : 1   multi-sheet workbooks: 0
file size      max          : 14,955 bytes

--- CONSTRUCT COVERAGE (Excel-authored: workbooks / total occurrences) ---
  calcChain.xml                 129 workbooks
  styles.xml                    174 workbooks
  sharedStrings.xml              38 workbooks
  tables/                        13 workbooks
  metadata.xml (spill cm=)        8 workbooks
  richData                        8 workbooks
  externalLinks/                  6 workbooks
  vbaProject.bin                  0 workbooks
  styled cells (s=)              35 occurrences   (21 workbooks)
  shared formulas                 0 occurrences   (0 workbooks)
  ARRAY (CSE) formulas            0 occurrences   (0 workbooks)
  dataTable formulas              0 occurrences   (0 workbooks)
  cached error cells t="e"       62 occurrences   (24 workbooks)
  cm= cells                       0 occurrences   (0 workbooks)
  @ / _xlfn.SINGLE                0 occurrences   (0 workbooks)
  _xlfn. refs                   132 occurrences   (36 workbooks)
  defined names                   9 occurrences   (4 workbooks)
  date1904 workbooks              1
  iterate=1 workbooks             2

--- BY BUCKET (Excel-authored) ---
  foundation-research     109 wb     431 formula cells    1037 cells
  oxcalc-test-runs         64 wb      49 formula cells      63 cells
  oxxlplay                  1 wb       1 formula cells       4 cells

--- TOP 12 BY FORMULA CELLS ---
    212 f    216 c  1sh  pirical-pass-01/fixtures/known_known_wave1/SCN-EK011-FUNCTION-RECOGNITION.xlsx
     14 f     20 c  1sh  20260228-180047-excel-compat-empirical-pass-01/fixtures/reason_code_wave1.xlsx
     13 f     13 c  1sh  -compat-empirical-pass-01/fixtures/coercion_wave1/SCN-EB025-FUNCTION-CORE.xlsx
     10 f     10 c  1sh  -excel-compat-empirical-pass-01/fixtures/coercion_wave1/SCN-EB024-OP-CORE.xlsx
      9 f     13 c  1sh  l-compat-empirical-pass-01/fixtures/coercion_wave1/SCN-EB025-AGG-COERCION.xlsx
      9 f     10 c  1sh  pat-empirical-pass-01/fixtures/coercion_wave1/SCN-EB026-NESTED-PRECEDENCE.xlsx
      9 f     20 c  1sh  l-compat-empirical-pass-01/fixtures/table_wave1/SCN-EB034-STRUCTREF-SPILL.xlsx
      9 f     20 c  1sh  xcel-nonfunction-closure-pass-01/fixtures/NFCP1-TBL-STRUCTREF-SPILL-fresh.xlsx
      5 f      8 c  1sh  -compat-empirical-pass-01/fixtures/known_known_wave1/SCN-EK024-TYPE-CODES.xlsx
      4 f      8 c  1sh  pat-empirical-pass-01/fixtures/known_known_wave1/SCN-EK012-TIER1-MATHSTAT.xlsx
      4 f      8 c  1sh  at-empirical-pass-01/fixtures/known_known_wave1/SCN-EK013-TIER1-TEXTLOGIC.xlsx
      4 f     10 c  1sh  at-empirical-pass-01/fixtures/known_known_wave1/SCN-EK014-LOOKUP-BASELINE.xlsx

--- NOT Excel-authored (hand-built fixtures) ---
  7 workbooks, 6 formula cells
   {'dnatreecalc': 4, 'oxxlplay': 2, 'elsewhere': 1}
--- calcChain usefulness (entries per workbook) ---
  1 entry     : 84
  2-3 entries : 27
  4+ entries  : 18   <-- the only ones with a real order to compare
       212 entries  l-pass-01/fixtures/known_known_wave1/SCN-EK011-FUNCTION-RECOGNITION.xlsx
        14 entries  28-180047-excel-compat-empirical-pass-01/fixtures/reason_code_wave1.xlsx
        13 entries  t-empirical-pass-01/fixtures/coercion_wave1/SCN-EB025-FUNCTION-CORE.xlsx
        10 entries  -compat-empirical-pass-01/fixtures/coercion_wave1/SCN-EB024-OP-CORE.xlsx
         9 entries  onfunction-closure-pass-01/fixtures/NFCP1-TBL-STRUCTREF-SPILL-fresh.xlsx
         9 entries  at-empirical-pass-01/fixtures/table_wave1/SCN-EB034-STRUCTREF-SPILL.xlsx
         9 entries  pirical-pass-01/fixtures/coercion_wave1/SCN-EB026-NESTED-PRECEDENCE.xlsx
         9 entries  at-empirical-pass-01/fixtures/coercion_wave1/SCN-EB025-AGG-COERCION.xlsx

--- workbooks with the seeds W4/W5 need ---
  date1904           1 wb : date_system_dest.xlsx
  iterate=1          2 wb : workbook.xlsx, workbook.xlsx
  tables/           13 wb : SCN-EB033-CF-TABLE-SPILL.xlsx, SCN-EB028-TABLE-BRACKET-REJECT.xlsx, SCN-EB028-TABLE-COL-ACCEPT.xlsx, SCN-EB028-TABLE-THISROW-ACCEPT.xlsx, SCN-EB029-NORM-TABLE-LOWERCASE.xlsx …
  externalLinks/     6 wb : FMLP2-021.xlsx, FMLP2-022.xlsx, NFCP1-LINK-MISSING-fresh.xlsx, NFCP1-LINK-PRESENT-CLOSED-fresh.xlsx, NFCP1-LINK-PRESENT-OPEN-UPD0-fresh.xlsx …
  metadata.xml       8 wb : SCN-EB028-FIELDVALUE-ACCEPT.xlsx, SCN-EB030-DOTFIELD-PROBE.xlsx, SCN-EK011-FUNCTION-RECOGNITION.xlsx, FMLP2-006.xlsx, FMLP2-007.xlsx …
  cached errors     24 wb : SCN-EB024-OP-CORE.xlsx, SCN-EB025-AGG-COERCION.xlsx, SCN-EB025-FUNCTION-CORE.xlsx, SCN-EB028-FIELDVALUE-ACCEPT.xlsx, SCN-EB030-AMBIG-INTERSECTION-SINGLE.xlsx …
  styled cells      21 wb : SCN-EB024-OP-CORE.xlsx, date_system_dest.xlsx, date_system_source.xlsx, SCN-EK011-FUNCTION-RECOGNITION.xlsx, SCN-EK026-VALUE-CONVERSION.xlsx …

--- calcPr settings seen ---
   110  <calcPr calcId="191029"/>
    62  <calcPr calcId="191029" calcMode="manual" concurrentCalc="0"/>
     2  <calcPr calcId="191029" calcMode="manual" iterate="1" iterateCount="10"/>
```

## Appendix C. Provenance of the survey and design runs

Survey, verification, design and critique transcripts for this investigation live in the Claude Code session directory `C:\Users\GovertvanDrimmelen\.claude\projects\C--Work-DnaCalc\795a6e8a-c258-4229-ac1b-915ebec45b80\` (workflow runs `wf_56628d44-02c` — 12 surveys + 12 refutations — and `wf_f1653b74-cf0` — 3 designs + 3 critiques). The durable state is this note and the bead graphs, not the transcripts; consult them only for provenance questions this note cannot answer.

---

*Posted as an internal Foundation working note. Not a public attribution surface.*
