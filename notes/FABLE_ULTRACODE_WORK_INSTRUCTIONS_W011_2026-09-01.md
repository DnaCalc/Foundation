# Fable Ultracode Work Instructions — DNA Calc Main Execution Path (W011 first)

**Status:** executable campaign pack for Fable Ultracode and its subagents. Working note, not Foundation doctrine.  
**Date:** 2026-09-01 (expanded from the shorter draft of the same filename)  
**Audience:** Fable Ultracode (orchestrator) and every subagent it assigns on this machine  
**Machine:** Windows, workspace `C:\Work\DnaCalc`, PowerShell  
**Exclusive occupancy:** this run and its subagents are the **only writers** in DNA Calc git repos for the duration. Coordinate among yourselves. Do not assume a human will unstick you mid-bead.  
**Companion truth (do not re-derive):** `Foundation/notes/PROGRAM_INVESTIGATION_2026-08-30.md`  
**Housekeeping already done (do not resume):** `Foundation/notes/HOUSEKEEPING_2026-08-31.md`  
**Length intent:** long enough to occupy a two-day Max run without inventing a second program. Short enough that beads, not this file, become execution state after Phase 0.

---

## 0. Read this first — the one-screen contract

You are not exploring DNA Calc. You are **closing the product seam a spreadsheet is for**, then deepening that same seam if credits remain.

**The only first-class outcome (Wave 1 — W011):**

> A DnaTreeCalc Calc host opens a small `.xlsx` through OxDoc, ingests it into `OxCalcDocumentContext`, lets the user edit `A1` from 7 to 10 so `B1` (`=A1*3`) recalculates to 30, saves, and reopens with formula text preserved and **cached `B1 = 30`**.

That is workset **W011** in `DnaTreeCalc` (`docs/ux/DNACALC_HOST_CORE_XLSX_NOTEBOOK_PROOF.md`, epic `dtc-hj2`). Host-core already recalculates **in-memory** workbooks (51 tests, `build_demo_workbook`). OxDoc already opens packages. OxCalc already ingests `oxdoc-model` and already has `w011_five_step_round_trip_contract` on **event streams**. **The missing edge is host wiring of real `.xlsx` bytes**, not a new engine.

**How you work:** beads (`br` / `bv --robot-*` only). Convert this pack into self-contained beads, polish them, then implement. After beads exist, **do not implement from this markdown**. This file is the plan. Beads are the execution state.

**How you spend Claude Max 200 (~2 days, ~75% remaining):** ~15% beads, ~55% Wave 1 implementation, ~15% same-fixture app/Excel evidence, ~15% Wave 2–3 execution-path deepening **only if Wave 1 is evidenced**. Stop when the outcome above is evidenced and remaining work would be cleanup, VBA, handbook, last-bit, or a crate split. Do not invent a second campaign.

**Hard stop if:** you are about to `git reset --hard`, force-push, add/remove a worktree, delete a branch listed in the housekeeping note, weaken a test, rewrite Foundation doctrine, revive `DnaOneCalc`, start OxVba/OxForms/handbook/last-bit, split `consumer.rs`, or pick a ready bead whose title is “create host-core skeleton” / “sample issue” / “Alpha issue”. Those are out of scope. File a bead if needed and return to the slice.

Use **ultrathink** on architecture, ownership, bead polish, and the save/cache trap. Do not ultrathink a gitignore, a status paragraph, or a 400-line CHARTER rewrite.

---

## 1. Who you are and what “good” looks like

Fable Ultracode is the orchestrator and the **only planner**. Subagents are **fungible generalists** (Jeffrey Emanuel / `agent-fungibility-philosophy`): any subagent can claim any **ready, in-scope** bead. Do not assign “the OxDoc agent” as a permanent role. If a subagent dies, another reads `AGENTS.md` + the bead and continues.

Jeffrey’s actual shipping loop (doodlestein, 2026-09-01): *“I usually just skim it myself and try to turn it into beads as quickly as possible so I can have a swarm implement it all. What matters is that the agents understand it well enough to implement the design correctly.”* You **are** that frontier planner. Subagents implement. Do not make every subagent re-plan W011.

**Good (Wave 1)** is git commits on `DnaTreeCalc` `main` (and OxDoc/OxCalc only if a proven typed gap requires it) plus tests that fail before the seam and pass after:

1. Fixture bytes open through `oxdoc_xlsx::open_host_owned_xlsx_source`.
2. Host owns that `HostOwnedXlsxSource` **and** an `OxCalcDocumentContext` / `WorkbookSession`.
3. Ingest via `OxCalcDocumentContext::load_workbook_model` or `load_workbook_model_from_access`.
4. `A1=7`, `B1` formula `=A1*3` (or engine-normalized `A1*3` — **assert both authored text and published value**; do not bikeshed the leading `=` if OxFml stores without it).
5. `WorkspaceIntent::EnterGridCell` (live Skin IR verb — **not** the older W011 name `EditGridCell`) on `A1` with `"10"` yields published `B1=30` and a `GridChanged` receipt.
6. Save through OxDoc; reopen; cached/published `B1` is `30`; formula text still the same formula.

**Not good:** more docs about W011; a demo that still only uses `build_demo_workbook()`; a ZIP rewrite that bypasses OxDoc; a host-side formula parser (`starts_with('=')` as authority); a claim of Excel fidelity without a retained compare of **this** fixture; closing `dtc-hj2` because “host-core exists.”

**Honesty language (OxCalc AGENTS, binding everywhere you report):**

- `Product status:` what a user or host can do.
- `Evidence:` the command/test that proved it.
- `Still open:` the next typed gap.
- Never call scaffolding “implemented.” Never say a feature is complete when the path is compile-only.

Never use the phrase “production ready.”

---

## 2. Credit budget (Claude Max 200, ~2 days, ~75% remaining)

Treat credits as scarce capital. Accretion beats motion. Two days is enough to **finish Wave 1 and deepen the same seam**. It is not enough to “improve DNA Calc” as an unbounded slogan.

### 2.1 Allocation

| Slice of budget | Spend on | Do not spend on |
|---|---|---|
| ~12–18% (Phase 0) | Reading this pack + investigation §§2, 5–7, 15–16, 19 + W011 proof doc **code pointers that still match**; converting to beads; **3–4** polish rounds until `br dep cycles` is empty and `bv --robot-triage` will not hand a subagent a skeleton/sample bead | 6–9 polish rounds that only rephrase; full `choose-the-best-skills` 10-phase fan-out (already done in §3); re-investigating OxVba/Handbook; writing a second plan file |
| ~50–55% (Wave 1) | Implementing ready **in-scope** beads on the xlsx seam; tests; commits; OxDoc/OxCalc **only** when a typed rejection actually blocks save/open/ingest of **this** fixture | Megacrate splits; crate-tier philosophy essays; UI skin redesign; VBA; last-bit ERFC; clippy-314 on `dnatreecalc-host`; RichTree session move (`dtc-c0wf.33`) |
| ~10–15% (Wave 1.5) | `dnacalc-app` open/save wiring + native/Tauri proof of the **same** fixture; optional browser click-through if wasm/oxdoc is already viable | A new notebook skin; worker redesign (`dtc-ajl.11`); formula-bar polish (`dtc-ajl.23`) as a lead activity |
| ~8–12% (Wave 2) | Same-fixture Excel observation via OxXlPlay/OxReplay **after** the slice is green | Expanding compare to arbitrary workbooks; handbook pages |
| leftover (Wave 3) | Deepen the **same** file-backed path: calc-mode on the loaded file; a second committed fixture with a cross-sheet formula; defined-name ingest if already in OxCalc projection | Cleanup, janitor, worktree archaeology, `consumer.rs` split |

### 2.2 Burn rules

- One expensive frontier (you) plans and polishes beads. Subagents implement ready beads. Jeffrey (2026-08-29): planning/beads with Fable+Sol, other agents implement. You **are** Fable. Do not make implementers redesign W011.
- If a bead would take more than one context window, split it **in plan space** (`br`) before coding.
- If you are generating status markdown instead of a failing-then-passing test, you are in ceremony. Stop. (`just-say-no-to-process-porn-and-ceremony`)
- Default concurrency: **two** implementers until `OpenXlsxBytes` + ingest is merged. Host-core `lib.rs`, `command.rs`, and `workbook.rs` are single-writer files. After ingest is on `main`, `bv --robot-plan` may justify up to four if files are disjoint.
- `bv --robot-next` is the picker **only after** the ready queue is safe (see §7). Until then, you (Fable) assign from the successor epic, not from the polluted global ready list.
- Push `main`/`master` when a bead that unblocks others closes, so a crashed agent resumes from GitHub. No force-push. No amending pushed commits.

### 2.3 Stop the campaign when

The Wave 1 outcome in §0 is evidenced, **even if budget remains**, unless you immediately start a **pre-authored Wave 2/3 bead** from this pack. Extra time does **not** authorize idea-wizard, a new epic, or “while we’re here” cleanup.

If Wave 1 save is **typed-blocked** on OxDoc (cannot refresh cached formula values, or rejects the fixture’s cell attributes), that is an honest campaign result **provided** open + ingest + edit + recalc of the loaded file works and the OxDoc gap is a failing test + handover bead. Remaining credits then go to **that typed OxDoc successor**, not to a different product.

### 2.4 Two-day clock (indicative, not a whip)

Assume you start immediately. Adjust, do not pad.

| Window | Fable (you) | Subagents |
|---|---|---|
| Hours 0–3 | Install ≤3 named skills; read §0/§3/§5/§10; `br` reconcile `dtc-hj2`; convert this pack to beads | None yet |
| Hours 3–6 | Polish 3–4 rounds; `br dep cycles`; `bv --robot-triage`; make ready queue safe | None yet |
| Rest of day 1 | Unstick ownership; review the ingest bead yourself | 2 fungible implementers on fixture + oxdoc deps + `OpenXlsxBytes` + ingest |
| Day 2 morning | Review edit/save beads yourself; do not rubber-stamp cache-on-save | 2–4 implementers on edit/recalc/save/reopen |
| Day 2 remaining | Wave 1.5 app wiring, then Wave 2 Excel compare of **this** fixture, then Wave 3 if green | Same swarm, still no specialist roles |

If Wave 1 is green before day 2 ends, **do not stop out of politeness**. Spend remaining Max on Wave 1.5 → 2 → 3 in that order. If Wave 1 is not green at the end of day 2, leave a typed blocker, passing tests for whatever landed, and a single status note. Do not thrash.

---

## 3. JSM skill selection (already ranked — do not re-run the full chooser)

The investigation already invoked `choose-the-best-skills-for-me-to-run-in-this-project`. Its **One Rule** is: recommend from evidence about **this** project at **this** juncture; RUN NOW is a portfolio of **at most three complementary campaigns**, not a leaderboard; every catalog skill gets a disposition; `unknown` is not absence; do not bulk-install.

This pack **is** the skill ledger for the Fable run. Do **not** write `docs/COMPREHENSIVE_ANALYSIS_OF_PROJECT_USED_FOR_AUTOMATED_SKILL_SELECTION.md` or `docs/RECOMMENDED_SKILLS_FOR_THIS_PROJECT.md` into any DNA Calc repo.

### 3.1 Envelope for this Fable run (granted 2026-09-01)

| Grant | Decision |
|---|---|
| Target | DNA Calc program, primary repo `C:\Work\DnaCalc\DnaTreeCalc`; OxDoc and OxCalc only for proven seam gaps; OxXlPlay/OxReplay only in Wave 2 on **this** fixture |
| Write chooser docs into lane `docs/` | **Denied** |
| Search remote cass | **Denied** (investigation exists; cass would re-litigate) |
| Authenticated jsm catalog | **Granted** — `jsm show` before first use |
| Install named skills below | **Granted**, at most **three missing installs** at a time, never `jsm install-all`, never `--related` by default |
| Auto-update `install_new` | Keep **disabled** |
| Commit skill-selection docs | **Denied** |
| Local Excel-DNA / `roscli` | **Not needed** for this run |
| `wtd` | Optional pane host; beads + Agent Mail preferred |

Inspect with `jsm show <name>` before first use. If a named RUN NOW skill is missing, `jsm install <name>` **one at a time**.

### 3.2 RUN NOW portfolio (exactly three complementary campaigns)

These are the chooser’s `plan-to-beads` recipe plus a fungible implementation campaign plus a slice-scoped conformance campaign. They are **not** three steps of one slogan.

**Campaign A — Plan to beads (prerequisite, Fable itself)**  
Skills, in order: `planning-workflow` (v6) → `beads-workflow` (v4, already installed) → `beads-bv` (v1)  
Chooser recipe name: `plan-to-beads`.  
Kickoff (paste into yourself before creating beads):

> Using /planning-workflow and /beads-workflow, convert `Foundation/notes/FABLE_ULTRACODE_WORK_INSTRUCTIONS_W011_2026-09-01.md` together with investigation §§5–7, 15–16, 19 and `DnaTreeCalc/docs/ux/DNACALC_HOST_CORE_XLSX_NOTEBOOK_PROOF.md` into beads with dependencies — so detailed that we never need to consult back to those markdown files. ONLY use the `br` tool to create/modify beads and dependencies. Then check each bead: is it optimal? Does it match **code** (`EnterGridCell`, host-core already exists, OxCalc R6 ingest already complete, `HostCommand` still lacks `OpenXlsxBytes`) rather than stale W011 bead titles? Then ONCE AGAIN. Validate with `br dep cycles` (must be empty) and `bv --robot-triage`. Use ultrathink. DO NOT OVERSIMPLIFY. DO NOT LOSE the stale-cache save proof.

Stop Campaign A when every Wave 1 goal maps to a bead, cycles are empty, and the ready queue will not offer skeleton/sample work to a swarm.

**Campaign B — Fungible implementation swarm (the spend)**  
Skills: `agent-fungibility-philosophy` (v4, already installed) + `beads-bv` + local `br`  
Every subagent gets the init prompt in §9.1. No specialist roles. After the ready queue is safe: `bv --robot-next` / `br ready`.  
Optional pair: `agent-mail` (v2) **only if** the Agent Mail MCP is actually available in the Fable session. Do not install it “just in case.” File reservations on `host-core` sources when two agents might touch `lib.rs`.

**Campaign C — Conformance of the slice (only after B has a green open/edit/save path)**  
Skill: `testing-conformance-harnesses` (v3)  
Build a **fixture matrix for this workbook class**, not a general Excel factory: open → edit → recalc → save → reopen, plus optional OxXlPlay/OxReplay compare of the **same** workbook. Golden round-trip of cached values. Pair with `testing-golden-artifacts` only if save bytes need a committed reopen transcript.

### 3.3 KEEP HANDY (invoke only when a bead needs them — do not install up front)

| Skill | When |
|---|---|
| `jsm-skill-router` | A bead is stuck and you suspect a specialist method; search, show, ask before install |
| `choose-the-best-skills-for-me-to-run-in-this-project` | **Do not re-run** unless Wave 1 is done and the human asks for the next program |
| `just-say-no-to-process-porn-and-ceremony` | Status docs multiply; beads close without tests; “we aligned the register” is the day’s output |
| `mock-code-finder` | A new host API compiles but `todo!` / empty `OpenXlsxBytes` / tests only mock OxDoc |
| `testing-golden-artifacts` | Save bytes need a committed golden reopen transcript |
| `repeatedly-apply-skill` | Bead **polish** only, 3–4 times, not 10; never to “keep improving the architecture” |
| `agent-ergonomics-and-intuitiveness-maximization-for-cli-tools` | Only if you must add a **tiny** host CLI to drive the fixture; not a product CLI rewrite |
| `slb` | Two-person rule if anyone proposes `rm -rf`, `git push --force`, `git reset --hard` — default answer is **refuse** |
| `dcg` | If a wrapper blocks a destructive command — treat the block as correct |
| `agent-mail` | Multi-agent file locks if the MCP is live |

### 3.4 NOT NOW (anti-signals — do not install for this run)

| Skill | Why not now |
|---|---|
| `git-repo-janitor`, `git-stash-janitor`, `git-worktree-branch-rationalization` | Housekeeping already done 2026-08-31; extra branches were **kept on purpose** |
| `reality-check-for-project`, `codebase-archaeology`, `codebase-report` | Investigation exists; re-running is credit burn |
| `idea-wizard`, `dueling-idea-wizards` | The outcome is chosen |
| `extreme-software-optimization`, `profiling-software-performance`, `running-the-gauntlet-on-your-rust-port` | Not a port; not a perf campaign |
| `de-monolithize-your-codebase-isomorphically`, `simplify-and-refactor-code-isomorphically` | Explicitly **do not** split `consumer.rs` / `oxdoc-xlsx` this run |
| `deadlock-finder-and-fixer` | No hang/GUI concurrency campaign (Jeffrey’s 2026-08-30 note is real; it is the wrong well) |
| Handbook / docs-site / `readme-writing` / `de-slopify` / `changelog-md-workmanship` | Publication is a parallel steward, not V1–V4 |
| SaaS / Next.js / billing / SEO skills | Wrong universe |
| `vibing-with-ntm` / `ntm` | Only if Fable **actually** spawns via ntm **and** beads are already polished. Fable’s own subagents are the swarm. Do not stand up a second swarm tool. |
| `lean-formal-feedback-loop` | Formal is not a Wave 1 gate |
| `library-updater` | Do not bump the world |
| `jsm install-all` | Forbidden |

### 3.5 Already installed on this machine (2026-09-01 `jsm list`)

- `choose-the-best-skills-for-me-to-run-in-this-project` v1 (2026-08-30)
- `beads-workflow` v4 (2026-07-10)
- `agent-fungibility-philosophy` v4 (2026-07-10)

Local (not jsm): `jsm-skill-router`, plus this machine’s `br` / `bv`.

**Allowed first installs (≤3, in this order):**

1. `planning-workflow`
2. `beads-bv`
3. `testing-conformance-harnesses` — may wait until Wave 1 is green; if you want it present for test-bead authoring during Campaign A, install it in the first three.

Fourth only after those exist **and** ceremony appears: `just-say-no-to-process-porn-and-ceremony`.

### 3.6 Local capabilities (do not globally install)

- Excel-DNA skill source: **not needed** for W011.
- `roscli`: **not needed** unless Handbook C# appears (it must not).
- `wtd`: optional for pane coordination.

---

## 4. Notes from Jeffrey Emanuel (@doodlestein) — operating language, not decoration

Incorporate as **commands you obey**, not as a bibliography dump. Sourced from his posts in the days around this pack (2026-08-29 through 2026-09-01) and from the beads/fungibility skills he ships.

1. **Beads are the execution state.** Long transcripts are a worse version of beads. After each bead, the durable state is the bead graph + git, not your chat. Discard reasoning; keep validated state.
2. **Turn the plan into beads quickly, then swarm.** Skim; implementers need beads that are correct, not a second novel (2026-09-01).
3. **Beads must be self-contained.** “Doesn’t matter much because all of that stuff needs to be turned into self-contained beads anyway.” (2026-08-29)
4. **Fable makes the plan and beads; other agents implement.** You are Fable. Subagents implement. Do not make subagents redesign W011. (2026-08-29: Fable+Sol for plan/beads; 2026-09-01: GPT Pro in a class of its own, Fable 5 also used together — here Fable **is** the planner.)
5. **Check beads N times, implement once** — N is **3–4 polish rounds** here, not 9, because credits must buy the slice. If polish flatlines, start a **fresh Fable context**, re-read AGENTS.md, then polish once more. Do not polish in a rotten context.
6. **Polish prompt (mandatory language, from `beads-workflow`):**

> Reread AGENTS.md so it's still fresh in your mind. Check over each bead super carefully— are you sure it makes sense? Is it optimal? Could we change anything to make the system work better for users? If so, revise the beads. It's a lot easier and faster to operate in "plan space" before we start implementing these things!  
> DO NOT OVERSIMPLIFY THINGS! DO NOT LOSE ANY FEATURES OR FUNCTIONALITY!  
> Also, make sure that as part of these beads, we include comprehensive unit tests and e2e test scripts with great, detailed logging so we can be sure that everything is working perfectly after implementation. Remember to ONLY use the `br` tool to create and modify the beads and to add the dependencies to beads. Use ultrathink.

7. **Agent-ergonomic rumination (2026-08-31). Adapt to this seam. Do not rebuild the program.** Paste this **once** after the first bead graph exists, then edit beads:

> OK, now I want you to think deeply about how to make the **xlsx open / ingest / EnterGridCell / recalc / save / reopen** path as agent-intuitive, agent-ergonomic, and agent-accretive as you can possibly imagine. Put yourself in the driver's seat and imagine that YOU are the one using this system and driving it. What would most enable you to do an awesome job understanding ownership (host vs OxDoc vs OxCalc) accurately and optimally controlling everything to drive the best and most accurate results possible, with the least expenditure of resources?  
> Then make all the requisite changes to the **beads** accordingly. Don't just think of the project as an assemblage of various parts: conceptualize it as one synthetic SYSTEM — Skin IR intent → host-core session → OxCalc document surface → OxFml → OxFunc, with OxDoc owning bytes — forming a tower of linked abstractions that are maximally legible to you as an agent. Really ruminate and meditate on all of this incredibly deeply before responding or taking any actions. Put exact types, exact tests, and exact forbidden shortcuts into the beads. DO NOT OVERSIMPLIFY. DO NOT LOSE the cached-B1-equals-30 save proof.

8. **Focus on what agents need to ship**, not human ceremony (2026-08-30). Do not add dashboards, extra registers, or “alignment workshops.”
9. **Init every subagent the same way** (fungibility exact prompt, §9.1). `bv --robot-next` after the queue is safe. No communication purgatory.
10. **Commit `.beads/issues.jsonl`.** `br sync --flush-only` does **not** run git. You add and commit. No git-hooks theatre.
11. **Never run bare `bv`.** Only `bv --robot-*`. Bare `bv` launches an interactive TUI and will wedge the session.
12. **Use `ultrathink`** on bead conversion, ownership, and the save/cache trap. Not on formatting.
13. **Good skills are rare** (2026-08-31). Use the named ones in §3. Do not invent a house process that duplicates them.
14. **Prompt revision trick** (2026-08-15): if a subagent’s task prompt is half-baked, **you** expand it before spawning; do not spawn on a vague bead.

---

## 5. Ground truth you must not re-discover

Read these; then stop reading program-wide. Prefer **code and tests** over W011 prose when they disagree.

### 5.1 Must-read set

| Must read | Why |
|---|---|
| This file | Your contract |
| `Foundation/notes/PROGRAM_INVESTIGATION_2026-08-30.md` §§2, 5–7, 15–16, 19 | What exists vs missing seam |
| `DnaTreeCalc/AGENTS.md`, `CHARTER.md` (incl. grid footnote), `OPERATIONS.md` | Host rules; **do not write siblings except handovers** from a TreeCalc agent |
| `DnaTreeCalc/docs/ux/DNACALC_HOST_CORE_XLSX_NOTEBOOK_PROOF.md` | W011 acceptance; treat **`EnterGridCell` as the live verb**; treat host-core as **already created** |
| `DnaTreeCalc/src/dnacalc-host-core/src/{lib.rs,workbook.rs,demo.rs,command.rs}` | Session already exists; xlsx was H2 non-goal; `HostCommand` still only `DispatchWorkspaceIntent` |
| `OxCalc/src/oxcalc-core/src/consumer.rs` (`load_workbook_model*`, `enter_grid_cell`, `recalculate_workbook`, `project_workbook_model_output`) | Engine ingest/edit/F9/project |
| `OxCalc/src/oxcalc-core/src/oxdoc_ingest.rs` test `w011_five_step_round_trip_contract` | The five-step contract **already passes on event streams** |
| `OxDoc/crates/oxdoc-xlsx/src/lib.rs` (`open_host_owned_xlsx_source`, `write_save_request`, `UnsupportedRoundTripFeature`) | File open/save; typed rejections |
| `OxDoc/docs/DOCUMENT_LIFECYCLE_AND_HOST_BOUNDARIES.md` | Host owns source + OxCalc context; OxDoc is stateless |
| `DnaTreeCalc/docs/WORKSET_REGISTER.md` W011 + epic `dtc-hj2` | Stale beads vs code |

### 5.2 Observed facts (investigation + 2026-08-31 housekeeping + 2026-09-01 re-check)

- `dnacalc-host-core` `WorkbookSession` + `build_demo_workbook` + **51 tests**: in-memory edit/recalc **works**, including `=A1*10` and cross-sheet `Sheet2!A1 = Sheet1!A1+Sheet1!A5`.
- Host-core `Cargo.toml` depends on `oxcalc_core`, `oxfunc_core`, `dnacalc-skin-ir` — **no oxdoc**. Workspace `Cargo.toml` has **no `oxdoc*`** entries at all.
- `HostCommand` is `#[non_exhaustive]` with **only** `DispatchWorkspaceIntent`. Comments still say `OpenXlsxBytes` / `SaveActiveXlsx` are H2 non-goals and “land with the xlsx lane at R6.” R6 in OxCalc **already landed**. The host arms did not.
- OxCalc path-deps `oxdoc-model`. Hosts must glue `oxdoc-xlsx`. OxCalc R6 ingest is **COMPLETE** (`calc-5kqg.64` and follow-ons). R7 (multi-sheet, collections) is **unblocked**.
- OxCalc already proves the W011 **calc** slice: `enter_grid_cell_w011_fixture_slice_dependent_recalculates` and `w011_five_step_round_trip_contract` (load events → enter A1 `"10"` → project cached 30 → authored-delta is only A1 → reload). Your job is to put **real xlsx bytes** on the front and **OxDoc save** on the back of that already-green middle.
- OxDoc round-trip **rejects** (typed `UnsupportedRoundTripFeature`, never silent): cell add/remove, formula add/remove, formula text changes without synchronized FormulaTopology, edits to cells whose start tag carries attributes beyond `r`/`t` (so **styled cells `s="n"` reject**). Editing an **existing unstyled** `A1` value is the in-scope save. **Build the fixture so both cells already exist and A1 has no style attribute.**
- Formula-cell edits drop calcChain package edges by OxDoc policy. **Do not assert calcChain byte-identity.**
- Live intent is `WorkspaceIntent::EnterGridCell { grid, row, col, text }` (`dnacalc-skin-ir/src/intent.rs`). W011 text and some comments still say `EditGridCell`. **Code wins.** OxCalc `enter_grid_cell` even documents that the old typed rejection `FormulaEditingNotYetSupported` **no longer exists**. The W011 register line “formula content yields a typed rejection” is **stale**. Literal-only was an old W011 edit-scope; the engine now does the three-way branch (literal / formula / clear). Wave 1 still **only needs a literal edit of A1**; do not also take on formula-authoring UX.
- OxFml is the sole interpretation authority (`interpret_authored_input_text`). Hosts must not classify `=`.
- `WorkbookSession` / `OxCalcDocumentContext` are **`!Send` + `!Sync`** (`Rc<RichValue>`). Sessions stay on one thread. Do not add `Send` bounds. Wire receipts (`IntentReceipt`) **are** `Send + Sync`.
- `DnaOneCalc` is archived (`ARCHIVED.md` `61e3979`). Bench inside TreeCalc is OxFml-only (F-gate). Do not develop in DnaOneCalc.
- OxXlPlay `ValueTag::Empty` compile break was **fixed** (`1c9de3b`, 2026-08-31). Compare is Wave 2, not a blocker for open/save.
- Extra OxVba worktrees were **removed** 2026-08-31. Do not recreate them. Extra **branches were kept**.
- `dnacalc-app` currently seeds `build_demo_workbook()` (adapter tests). There is no file-picker path in the Calc app for xlsx yet.
- Live `br ready` in DnaTreeCalc (2026-09-01) **still offers** `dtc-hj2.3: W011 create Leptos-free dnacalc-host-core skeleton` and three sample issues (`dtc-pg91`, `dtc-juyd`, `dtc-ga2e`). Implementing those is a destructive tangent of a different kind: busywork that fights HEAD.

### 5.3 Do not read (credit sink / wrong era)

Foundation `ARCHITECTURE_AND_REQUIREMENTS.md` as implementation truth; DnaOneCalc UX novels; `docs/onecalc/**` except when a type name collides; OxVba AutoRun; Handbook organs; `DnaVisiCalc`; OxFunc last-bit; the 2026-05 stocktaking as present-day truth.

---

## 6. Architecture of the slice (observed vs target)

```
Skin / dnacalc-app
    WorkspaceIntent::EnterGridCell / HostCommand::OpenXlsxBytes / SaveActiveXlsx
        dnacalc-host-core  (owns OxDoc session + OxCalcDocumentContext)
            oxdoc-xlsx  open_host_owned_xlsx_source / write_save_request
            oxdoc-model events / WorkbookModelAccess / WorkbookModelOutput
            OxCalcDocumentContext::load_workbook_model*
            enter_grid_cell / recalculate_workbook / project_workbook_model_output
                OxFml bind/eval
                    OxFunc kernels
```

Host owns **two handles**: source package (OxDoc `HostOwnedXlsxSource`) and live calc (`WorkbookSession` / `OxCalcDocumentContext`). Skins never call OxDoc or OxCalc directly (W011 / Skin IR law).

`WorkspaceIntent` mutates the **open model**. `HostCommand` manages **documents, files, and layout**. That boundary is already written in `command.rs`. You add arms; you do not invent a third command enum.

### 6.1 Exact types (copy into beads)

| Role | Type / function | File |
|---|---|---|
| Open bytes | `oxdoc_xlsx::open_host_owned_xlsx_source<R: Read+Seek>(reader, LoadProfile) -> Result<HostOwnedXlsxSource, XlsxError>` | `OxDoc/crates/oxdoc-xlsx/src/lib.rs` ~1790 |
| Load profile | `LoadProfile::full()` for W011 (proof doc); values-only is the Default and is **not** enough if you need formula text | OxDoc |
| Ingest (events) | `OxCalcDocumentContext::load_workbook_model(create, events)` | `consumer.rs` ~8346 |
| Ingest (access) | `load_workbook_model_from_access(create, access)` | `consumer.rs` ~8364 |
| Create handle | `oxcalc_core::oxdoc_ingest::OxCalcWorkbookCreate` | OxCalc ingest |
| Edit | `WorkbookSession::enter_grid_cell(sheet, row, col, text)` → `OxCalcDocumentContext::enter_grid_cell` | `workbook.rs` ~379; `consumer.rs` ~5382 |
| Skin verb | `WorkspaceIntent::EnterGridCell { grid, row, col, text }` | `intent.rs` ~523 |
| F9 | `WorkspaceIntent::Recalculate` → `recalculate_workbook` | Automatic mode already recalc’d; second F9 is a no-op |
| Project for save | `OxCalcDocumentContext::project_workbook_model_output` → `WorkbookModelOutput` with `WholeModelProjection` | `consumer.rs` ~7600 |
| Save | `write_save_request` / `XlsxSaveRequest::round_trip` | OxDoc xlsx |
| Demo (not the proof) | `build_demo_workbook()` | `demo.rs` — keep it; do not call it W011 |

### 6.2 Calc-mode on load (do not get this wrong)

OxCalc load policy (D4 §6): `CalcMode::Automatic` issues one open-recalc (values become `Calculated`); `CalcMode::Manual` runs zero engine passes (values render `FileCached` until explicit `recalculate_workbook`). The W011 fixture should load as **Automatic** so B1 is 21 on open without an extra F9. A Wave 3 bead may add a Manual-mode fixture; Wave 1 must not mix the two.

### 6.3 Forbidden shortcuts

- Parse formulas in the host; `starts_with('=')` as authority.
- Add a `zip` crate to host-core to “just rewrite sharedStrings / `<v>`.”
- Evaluate `A1*3` in Rust without OxCalc.
- Keep the demo-only path and call it W011.
- Create A1/B1 in the host after opening an empty workbook, then save — OxDoc will reject **cell add**. The fixture file must already contain both cells.
- Style A1 in the fixture (`s="n"`). OxDoc will reject the value replace.
- `Send`/`Sync` the session.
- Pull `oxdoc*` or `oxcalc*` into TP crates (`dnacalc-stage-sheet`, skins, bench). host-core may take oxdoc because it already takes oxcalc (TC-adjacent). Bench F-gate must stay OxFml-only.
- WASM oxdoc as a Wave 1 gate (risk R9). Native/Tauri/byte-buffer first. Wasm spike is a named follow-on, not a blocker.

---

## 7. The stale-bead trap (do this before any swarm)

Live `br ready` (2026-09-01) will happily hand a fungible agent work that **fights HEAD**. If you spawn before reconciling, you will burn Max recreating `dnacalc-host-core` or implementing “First sample issue.”

### 7.1 First mechanical acts

```text
cd C:\Work\DnaCalc\DnaTreeCalc
br ready
br list --status in_progress
br epic status
bv --robot-triage
br show dtc-hj2
br show dtc-hj2.3
```

**Reconcile `dtc-hj2` with code before adding a parallel epic.** Close or retitle children that describe landed work, with evidence in the close reason:

| Bead (illustrative) | HEAD truth | Action |
|---|---|---|
| `dtc-hj2.3` create Leptos-free host-core skeleton | crate exists, 51 tests, TC-gate no Leptos | **Close** with `cargo test -p dnacalc-host-core` cited; do **not** implement a second host-core |
| “create EditGridCell” / literal-only rejection | `EnterGridCell` exists; formulas are accepted by the engine | Retitle remaining edit beads to `EnterGridCell`; do not restore `FormulaEditingNotYetSupported` |
| Sample issues `dtc-pg91`, `dtc-juyd`, `dtc-ga2e` | ceremony | Close as cancelled / not a product task, or demote to P4 and label `out-of-campaign` |
| `dtc-c0wf.33` Move TreeWorkspaceSession into host-core | real later work | Leave open; **do not pick**; not Wave 1–3 |
| `dtc-yo3` clippy-314 | hygiene | Leave open; do not pick |
| `dtc-z0i.19` sibling-offset corpus | W004 remainder | Leave open; do not pick |
| Bench CF / formula bar / worker alignment | product, not this seam | Leave open; do not pick |

If `dtc-hj2` is too polluted to repair in one sitting, create a **successor epic** (name it in the title, e.g. `W011 xlsx vertical slice — host glue`) at **P0/P1** whose children are the DAG in §8. Park stale `dtc-hj2` children as blocked-on-successor or closed-landed. The swarm must only see successor children as ready.

### 7.2 Ready-queue safety invariant

**Do not spawn implementers until** `br ready` in DnaTreeCalc, filtered to P0/P1, contains **only** Wave 1 (and later Wave 2/3) beads you just authored. If a sample or skeleton bead is still P1-ready, you have not finished Phase 0.

Optional: `br label add <id> w011-fable` on every in-campaign bead. Instruct subagents: claim only labeled beads.

---

## 8. Phase 0 — Beads (Fable, Campaign A)

Work in **`C:\Work\DnaCalc\DnaTreeCalc`** as the bead home for the campaign. If OxDoc or OxCalc need code, create **handover beads** in TreeCalc that describe the exact sibling change, then implement in that sibling **as beads in that sibling’s `.beads/`** (each repo already has `br`). Do not create a fake mega-beads repo at `C:\Work\DnaCalc`.

TreeCalc `AGENTS.md` says agents **must not write siblings**. Honor it: a TreeCalc subagent files a handover; **you spawn a subagent whose cwd is the sibling repo** for OxDoc/OxCalc beads.

### 8.1 Exact conversion prompt (run on yourself)

Use the beads-workflow exact prompt, with this file as `YOUR_PLAN_FILE`:

> OK so now read ALL of Foundation/notes/FABLE_ULTRACODE_WORK_INSTRUCTIONS_W011_2026-09-01.md and the W011 proof doc and investigation §§5–7, 15–16 and 19; please take ALL of that and elaborate on it and use it to create a comprehensive and granular set of beads for the xlsx vertical slice with tasks, subtasks, and dependency structure overlaid, with detailed comments so the whole thing is totally self-contained and self-documenting (background, reasoning, considerations, ownership, exact types, exact tests, forbidden shortcuts, log lines). The beads should be so detailed that we never need to consult back to the original markdown. Remember to ONLY use the `br` tool to create and modify the beads and add the dependencies. Use ultrathink.

Then polish 3–4 times with the standard polish prompt (§4.6). After polish round 1, run the agent-ergonomic rumination (§4.7) **once**. Then:

```text
br dep cycles          # must be empty
bv --robot-insights    # no cycles; look at bottlenecks
bv --robot-plan        # parallel tracks only after open/ingest exists
br sync --flush-only
git add .beads/ && git commit -m "beads: W011 xlsx vertical slice graph"
```

### 8.2 Bead quality bar (from beads-workflow anatomy)

Each implementation bead includes:

- **Background** — why, including “host-core already exists; this is glue.”
- **Technical approach** — files, types, function names from §6.1.
- **Success criteria** — observable, not “docs updated.”
- **Test plan** — unit test name + command + log lines the test must print (fixture path, A1 value, B1 formula, B1 cached).
- **Considerations** — OxDoc no-add-cell, no-style-on-A1, `!Send`, F-gate, EnterGridCell vs EditGridCell.
- **Forbidden shortcuts** — copied from §6.3.
- **Repo cwd** — TreeCalc / OxDoc / OxCalc.
- **“This is not done if only docs changed.”**

Self-contained; one coherent slice; deps explicit; testable; no lost W011 save-cache requirement; not oversimplified; no cycles.

### 8.3 Suggested bead DAG (refine; do not lose these)

Keep beads small enough for one agent/context. Names are illustrative; IDs come from `br`. Dependencies flow downward.

**Wave 1 — must**

1. **Reconcile W011 graph** — close landed `dtc-hj2.*`; document host-core as given; neutralize sample beads. *No product code.*
2. **Fixture xlsx** — committed binary: one sheet `Sheet1`, `A1` numeric 7 **unstyled**, `B1` formula `=A1*3` (or Excel’s stored form), cached B1=21. Built once via Excel or a checked-in binary; tests **must not** require live Excel to run. Prefer `DnaTreeCalc/fixtures/w011/a1_times_three.xlsx` (or OxDoc testdata referenced by content hash). Verify with OxDoc CLI inspect if present. *Acceptance:* a test opens the file through `open_host_owned_xlsx_source` and sees two cells (may live in OxDoc first, then host-core).
3. **host-core oxdoc deps** — add `oxdoc-xlsx` + `oxdoc-model` to workspace `[workspace.dependencies]` and to `dnacalc-host-core`. Do **not** add them to bench, skins, or stage crates. Run `dnacalc-arch-gates` tests. Update comments in `command.rs` / `lib.rs` that still say xlsx is an H2 non-goal. *Acceptance:* `cargo tree -p dnacalc-host-core -e normal` shows oxdoc; `cargo test -p dnacalc-arch-gates` still green.
4. **`HostCommand::OpenXlsxBytes`** — host owns `HostOwnedXlsxSource` (or equivalent session field). No calc yet, or calc empty. *Acceptance:* test opens fixture bytes; error type is OxDoc’s typed error, not `String`.
5. **Ingest** — from the owned source, `load_workbook_model` / `_from_access` into the `WorkbookSession` (replace or wrap the current “create empty + add sheets” path). Prefer access API if it does not require eager events (investigation R8 — **verify with a test**, do not guess). *Acceptance:* A1 value 7, B1 formula text visible, B1 published 21 under Automatic.
6. **Projection** — Skin IR grid projection from the loaded workbook (reuse `grid_projection_for`). Authored kind + formula source text must be visible (proof doc called this out as missing in 2026-07; **re-verify** `GridCellProjection` — if authored metadata already landed, do not rebuild it). *Acceptance:* snapshot/projection test.
7. **Edit/recalc** — `EnterGridCell` A1 `"10"`; B1 published 30; `GridChanged` (+ `GridCellEntered` receipt). Automatic vs explicit F9 per engine calc mode. *Acceptance:* host-core test mirroring `enter_grid_cell_w011_fixture_slice_dependent_recalculates` **on loaded xlsx bytes**.
8. **Save** — `project_workbook_model_output`; OxDoc `write_save_request`; **cached B1=30** on reopen through OxDoc (the trap). If OxDoc rejects, **do not bypass**; bead a typed OxDoc successor and keep host honest. *Acceptance:* save → `open_host_owned_xlsx_source` again → A1 10, B1 formula preserved, cached 30.
9. **App wiring** — `dnacalc-app` (and desktop if that is the native proof) open/save commands through `HostCommand`, not through skins calling OxDoc. Browser click-through if cheap; **native byte-buffer is the closure of Wave 1** (W011: “save proof is native; browser download completes it”).
10. **Charter footnote** — one paragraph: this repo hosts treecalc-v1 **and** strict-excel-grid via host-core. Not a rewrite. Only after tests exist.

**Wave 2 — after Wave 1 green, same fixture**

11. **OxXlPlay observe** the fixture (open in Excel, A1=7, B1=21; after DNA save, A1=10, B1=30). PID-scope Excel. Not a required gate for host-core unit tests.
12. **OxReplay** value compare DNA vs Excel on this workbook only.

**Wave 3 — leftover Max, still execution path**

13. **Calc-mode** on a loaded file: Manual load shows FileCached 21 until F9; Automatic load calculates. Reuse existing `SetCalcMode` / `Recalculate` intents.
14. **Cross-sheet xlsx fixture** — Sheet2 formula referencing Sheet1, edit Sheet1, dependent updates, save/reopen. OxCalc already does this in-memory (`demo.rs`, consumer tests). This proves ingest+save of a second sheet, which OxCalc R7 already unblocked on the engine side.
15. **Defined-name ingest** only if `project_workbook_model_output` already re-emits names (it does, R6.66) **and** the fixture is still small. Do not invent a names manager UI (`dtc-ajl.25`).

**Parked — do not bead as ready work this run**

W004 remaining tree-reference work; W010 UDF; handbook SUM page; OxFunc 1-ULP discrete-dist; `dtc-c0wf.33` RichTree move; clippy-314; Bench CF; worker alignment; `consumer.rs` split; DnaOneCalc; OxVba/OxForms.

### 8.4 Every implementation bead’s test command

Prefer the narrowest command that proves the bead:

```text
cargo test -p dnacalc-host-core --offline -- --nocapture
cargo test -p dnacalc-host-core --offline <test_name> -- --nocapture
cargo test -p dnacalc-arch-gates --offline
cargo test -p dnacalc-app --offline
```

In OxDoc / OxCalc, run the **named** test, not `cargo test --workspace` as a first reflex (those workspaces are large). After an OxDoc save-path change, run the round-trip tests that assert `UnsupportedRoundTripFeature` still rejects cell add/remove — you must not accidentally loosen OxDoc to make W011 green.

---

## 9. Phase 1 — Implementation (Campaign B)

### 9.1 Subagent init prompt (give to every subagent verbatim)

```
First read ALL of the AGENTS.md file and README.md file in your cwd repo super carefully and understand ALL of both. Then read Foundation/notes/FABLE_ULTRACODE_WORK_INSTRUCTIONS_W011_2026-09-01.md section 0 and section 11 (guardrails). Then use your code investigation mode to understand only what the current bead names: dnacalc-host-core, OxCalcDocumentContext ingest, or oxdoc-xlsx open/save.

You are a fungible generalist. You do not own a layer.

Register with Agent Mail if available and introduce yourself. Check mail and respond. Do not get stuck in communication purgatory.

Use bv --robot-next (never bare bv) only after confirming the bead is labeled in-campaign / is a child of the W011 successor epic. If robot-next offers a skeleton, sample issue, clippy debt, RichTree move, Bench CF, or W004 bug, skip it and take the next in-campaign ready bead. Claim with br update --status in_progress. Implement only that bead. Verify with the tests named in the bead. Fresh-eyes the diff. br sync --flush-only; git add the touched files and .beads/issues.jsonl; commit; br close with a reason that cites the test.

If blocked on another repo, write a handover under DnaTreeCalc/docs/handovers/ and a blocker bead. Do not silently edit siblings unless the bead explicitly owns OxDoc or OxCalc and your cwd is that repo.

When unsure, bv --robot-next again. Use ultrathink for ownership and the cache-on-save trap only.
DO NOT OVERSIMPLIFY. DO NOT LOSE the cached-B1-equals-30 requirement.
```

### 9.2 Orchestrator loop

1. You stay on bottlenecks, ownership, and the save/cache bead. You do **not** implement every bead.
2. `bv --robot-plan` — at most 2–3 live implementers until ingest compiles (oxdoc+oxcalc in one crate is easy to conflict).
3. After ingest is on `main`, you may parallelize projection vs tests vs app wiring if `bv --robot-plan` shows disjoint files.
4. File reservations (Agent Mail) on `host-core` sources when two agents might touch `lib.rs` / `command.rs` / `workbook.rs`.
5. Replace dead agents with the **same** init prompt. Bead stays `in_progress` until closed or reopened. If a bead is `in_progress` with no agent for >2 hours, reopen it or reassign; do not leave zombies.
6. One in_progress bead per agent.
7. Bead ID is the Agent Mail thread id.

### 9.3 Repo write permissions

| Repo | Write? |
|---|---|
| `DnaTreeCalc` | **Yes** — primary |
| `OxDoc` | Only if save of **existing** unstyled A1/B1 is typed-rejected and a bead owns the fix |
| `OxCalc` | Only if ingest/load of the fixture is typed-rejected and a bead owns the fix |
| `OxFml` / `OxFunc` | **No** |
| `OxXlPlay` / `OxReplay` | Only Wave 2, fixture-scoped |
| `DnaOneCalc` | **Never** |
| `OxVba` / `OxForms` / `OxIde` / Handbook / Foundation doctrine | **Never** (Foundation: this notes file already exists; do not expand doctrine; a single status note in TreeCalc handovers is enough) |
| `DnaVisiCalc` | **Never** |
| `DnaOxIde` | **Never** (not even a git repo) |

Cross-repo: follow each target `AGENTS.md`. Spawn a subagent **in that repo directory**.

Ox-layer repos: completion language is scoped; scaffolding is not implementation; handoff sent ≠ behavior closed (OxCalc AGENTS Rules 1–5).

### 9.4 Commits

- One logical commit per closed bead (or per small stack if they are atomic).
- `br sync --flush-only` then `git add` sources + `.beads/issues.jsonl`.
- Push `main`/`master` when a bead that unblocks others is closed.
- No force-push. No amending pushed commits. No `git rebase` of published `main` except a **local** rebase onto `origin` if you are behind (DnaTreeCalc already taught this during housekeeping).
- Do not commit `target/`, `target-*`, `_housekeeping_delete_review`, `.scratch`, generated trunk `dist` WASM, Excel lock files (`~$*.xlsx`).
- Commit the W011 fixture `.xlsx`. Keep it tiny.

### 9.5 Verification floor (do not weaken)

Per TreeCalc AGENTS.md: never weaken, skip, or delete a real test to close a bead. If a check is wrong, fix it as its own bead.

W011 Excel anchor: **after** local save/reopen is green, optional OxXlPlay. Formal/Lean: not a gate.

If you touch crate layout: `cargo test -p dnacalc-arch-gates --offline`.

Do **not** run `cargo clippy --workspace -- -D warnings` as a Wave 1 gate (`dnatreecalc-host` already carries ~314 clippy errors; chasing them is a tangent). Clippy the **touched host-core files** if cheap.

Do **not** require live Excel for host-core unit tests.

---

## 10. Waves 1.5–3 — if the slice is green and budget remains

In order. Stop when budget or quality is at risk. Each wave is pre-authored so you do not “get creative.”

### 10.1 Wave 1.5 — same fixture, visible host

- Wire `dnacalc-app` / desktop to `OpenXlsxBytes` / `SaveActiveXlsx`.
- Native or Tauri click-through of open → edit A1 7→10 → B1 shows 30 → save → reopen.
- Browser download click-through **only if** oxdoc-xlsx already builds for wasm. If not, file a named follow-on (`W011 wasm oxdoc spike`) as **open, not in progress**, and move on.
- Do **not** start a notebook visual redesign. SheetLens / notebook already dispatch `EnterGridCell`.

### 10.2 Wave 2 — Excel compare of **this** fixture (Campaign C)

- OxXlPlay compiles as of 2026-08-31. Observe the fixture in Excel; capture values.
- OxReplay diff DNA vs Excel on values for this workbook only.
- PID-scope any Excel process (OxXlPlay AGENTS). Do not disable Excel security globally.
- Do not claim bit-exactness of the whole Excel calc universe.

### 10.3 Wave 3 — deepen the file-backed path

- Calc-mode Manual vs Automatic on the loaded file.
- Second fixture: two sheets, cross-sheet formula, save/reopen.
- Defined names only as ingest/project proof, not UI.

Do **not** start W004 remaining tree-reference work, W010 UDF, handbook SUM page, or OxFunc 1-ULP discrete-dist unless the human says so.

---

## 11. Guardrails — destructive-tangent prevention

This section is **hard**. If a subagent’s impulse conflicts with it, the subagent stops.

### 11.1 Never

- `git reset --hard`, `git checkout --` on dirty trees you did not just create, `git push --force`, `git rebase` of published `main`/`master` except a local rebase onto `origin` when behind.
- `git worktree add` / `git worktree remove`. Worktrees were cleaned 2026-08-31.
- Delete local/remote branches listed in `HOUSEKEEPING_2026-08-31.md`. Extra branches were kept because uniqueness was unsure.
- `rm -rf` of `_housekeeping_delete_review` or OxFunc `target-*` (human later). Those directories are large on purpose.
- Edit `.beads/` JSONL by hand. Only `br`.
- Weakening, skipping, `#[ignore]` of a real test, or deleting tests to close a bead.
- `todo!()`, empty `unwrap()` on the open/save path, or `unimplemented!` behind a public `OpenXlsxBytes` that tests only mock.
- Bypass OxDoc with raw ZIP/XML in the host.
- Host-side formula classification.
- Revive DnaOneCalc; break Bench F-gate (Bench must not gain oxcalc).
- Pull ox* into TP crates. host-core may take oxdoc because it already takes oxcalc.
- Split `OxCalc/.../consumer.rs` or `oxdoc-xlsx` megacrate. If a file is painful, **contain** with a `// SEAM-OXDOC-...` comment and a successor bead.
- Install all JSM skills. Install at most three named missing skills.
- Run live Excel as a **required** gate for host-core unit tests.
- Claim Excel bit-exactness or W011 closed without the cached-30 reopen test.
- Communicate instead of coding (purgatory). One mail line when claiming a bead is enough.
- Pick ready work because it is ready. The ready queue is polluted.
- “Improve” Foundation doctrine, CHARTER beyond the one-paragraph dual-profile footnote, or handbook completeness.
- Add dependencies casually (`zip`, `calamine`, another xlsx crate). OxDoc is the xlsx crate.
- Disable git hooks, code signing, or Excel Protected View globally.
- Commit secrets, `.env`, or random Downloads xlsx with macros.

### 11.2 Always

- Read the owning repo `AGENTS.md` before the first edit in that repo.
- Claim bead → implement → test → fresh-eyes → commit → close.
- Prefer repairing ownership (logic in OxCalc vs host) over a local hack. If you must contain, comment and open a successor bead.
- If OxDoc cannot update cached formula values on round-trip, **stop and record a typed gap** with a failing test. That is an honest W011 successor, not a failed campaign, provided open+edit+recalc of a loaded file works.
- Three-axis language when reporting: what works for the user, evidence, still open.
- Keep the fixture unstyled and pre-populated.

### 11.3 Blast radius

| Surface | Rule |
|---|---|
| `dnacalc-host-core/src/lib.rs` | Single writer |
| `command.rs`, `workbook.rs` | Single writer until ingest+commands merge |
| `demo.rs` | Do not break the demo; add parallel xlsx tests |
| OxCalc `consumer.rs` | Read-mostly; no split; no drive-by refactors |
| OxDoc `oxdoc-xlsx/src/lib.rs` | Only if save of this fixture is typed-rejected; no policy loosening to “allow cell add” to make a bad fixture work |
| `dnacalc-arch-gates` | Must stay green if you touch deps |
| Git history | Append-only on `main`/`master` |

Default concurrency: **two** implementers until `OpenXlsxBytes`+ingest is merged. Then up to four if `bv --robot-plan` shows disjoint files.

### 11.4 Secrets, Excel, and the machine

- Exclusive occupancy of DNA Calc git repos. You may read. You may not assume other agents are idle outside your swarm.
- Do not start long `cargo test --workspace` in DnaTreeCalc (WASM/UI size) as a background tax. Targeted packages only.
- Do not fill the disk with new `target-*` trees. Use the existing `target/` per repo.
- OxFunc `target-*` directories are gitignored leftovers; do not delete; do not compile into them.
- Excel: PID-scope. Kill what you start. The W011 fixture is values+one formula only.

### 11.5 Honesty inventory (ceremony detector)

If any of these are true, you are off the rails. Invoke `just-say-no-to-process-porn-and-ceremony` and return to `bv --robot-next` on an in-campaign bead:

- More than one new `.md` in `docs/` that is not a handover or a test-required fixture note.
- Beads closed with “docs updated” and no test.
- A day of `dtc-hj2` retitling without a host-core oxdoc dependency.
- Subagents rewriting CHARTER instead of `OpenXlsxBytes`.
- `OpenXlsxBytes` exists but tests construct the workbook with `add_sheet` + `enter_grid_cell` and never read the fixture bytes.
- Save “works” because the test only checks `A1` and never re-reads B1’s cached value.
- A subagent is “cleaning” `consumer.rs`.
- A subagent is in `DnaOneCalc/` or `OxVba/`.
- Token burn on `jsm install` of a fourth+ skill.

### 11.6 Destructive-tangent playbook (if someone starts one)

| Tangent | Recovery |
|---|---|
| Implementing `dtc-hj2.3` skeleton | Stop; `git` restore; close the bead as landed |
| ZIP bypass of OxDoc | Revert; rewrite through OxDoc |
| Force-push / reset --hard | **Stop the swarm.** Do not try to “fix history.” Write the status note. Wait for the human. |
| Worktree add | Remove only the worktree **you** just created, after checking it has no unique commits |
| Weakened test | Restore the test; if your code fails it, your code is wrong |
| OxDoc loosened to allow cell add | Revert the policy change; fix the fixture instead |
| Swarm on clippy-314 | Abort those agents; return to W011 |

`slb` / `dcg`: if a two-person rule or destructive-command guard fires, the answer is **no**.

---

## 12. Coordination protocol

- Bead ID is the Agent Mail thread id.
- `br update <id> --status in_progress` before files change.
- One in_progress bead per agent.
- Handoffs: `DnaTreeCalc/docs/handovers/HANDOFF_OXDOC_W011_SAVE_CACHE.md` (name as needed). Keep handovers factual: failing test name, typed error, fixture hash.
- Status for humans: a **single** running note at `DnaTreeCalc/docs/handovers/W011_FABLE_RUN_STATUS.md` updated **only** at ingest-green, edit-green, save-green, or blocker. Not per thought.
- Do not mail Foundation. Do not open GitHub issues for chatter.
- `C:\Work\DnaCalc` is **not** a git repo and **not** a Cargo workspace. `cargo` and `br` run **per sibling repo**.

### 12.1 Tool facts on this machine

- `jsm` → `C:\Users\GovertvanDrimmelen\AppData\Local\jsm\bin\jsm.exe`
- `br` → `C:\Users\GovertvanDrimmelen\.cargo\bin\br.exe`
- `bv` → `C:\Users\GovertvanDrimmelen\go\bin\bv.exe`
- `roscli` exists; you should not need it
- Shell is PowerShell. Do not write bash-only one-liners as the only instructions.

---

## 13. Acceptance evidence (campaign exit)

### 13.1 Wave 1 must-hold

1. Committed fixture `.xlsx` in DnaTreeCalc (or OxDoc testdata referenced by hash).
2. `dnacalc-host-core` depends on `oxdoc-xlsx` / `oxdoc-model`.
3. Test: open fixture → A1 is 7, B1 formula is `A1*3` / `=A1*3`, published B1 is 21 under Automatic.
4. Test: enter A1 `10` → B1 value 30 + `GridChanged`.
5. Test: save → reopen → A1 10, B1 formula preserved, **cached/published B1 30**.
6. Skins still do not import oxdoc/oxcalc (TP `cargo tree -e normal` if you touch stages).
7. Bench F-gate still green if you touched crate layout.
8. `br` graph: W011 successor children for the slice closed or blocked with typed OxDoc/OxCalc gaps.
9. Pushed to GitHub `DnaTreeCalc` `main` (and siblings if touched).
10. Demo workbook tests still pass. You did not sacrifice `build_demo_workbook`.

### 13.2 Honest partial (still a successful use of Max)

Open + ingest + edit/recalc of the loaded file is green, save is a **typed** OxDoc rejection with a failing test and a handover. Product status names what the user can do in-memory-on-loaded-file. Still open names the save-cache gap. Do **not** close W011.

### 13.3 Optional but valuable

OxXlPlay capture of the fixture; OxReplay value compare; native click-through; calc-mode test; cross-sheet xlsx fixture.

---

## 14. Kickoff script for Fable (do this in order, now)

1. `cd C:\Work\DnaCalc\DnaTreeCalc`
2. Read this file §0, §3, §5, §11.
3. `jsm show planning-workflow`; `jsm show beads-workflow`; `jsm show beads-bv`. Install missing ones only (`jsm install <name>`), max three. `testing-conformance-harnesses` may be the third, or wait until Wave 2.
4. `br ready` / `bv --robot-triage`. Reconcile `dtc-hj2`. Neutralize sample/skeleton ready work.
5. Run §8.1 conversion prompt. Create beads only with `br`.
6. Polish 3–4 rounds (§4.6) including one §4.7 rumination. `br dep cycles`. Commit `.beads/`.
7. Confirm ready queue is safe (§7.2).
8. Spawn fungible subagents with §9.1. You stay on bottlenecks and the save-cache bead.
9. Implement until §13 holds or a typed blocker is recorded.
10. If green and credits remain: Wave 1.5, then Campaign C on **this** fixture only, then Wave 3.
11. Stop. Do not start a second epic.

### 14.1 Paste-ready first message to yourself

> You are Fable Ultracode executing Foundation/notes/FABLE_ULTRACODE_WORK_INSTRUCTIONS_W011_2026-09-01.md. Exclusive writer with your subagents. Primary outcome: DnaTreeCalc opens the W011 xlsx through OxDoc, ingests OxCalc, EnterGridCell A1 7→10, B1=30, save/reopen cached 30. Do not re-investigate the program. Do not cleanup, VBA, handbook, last-bit, or DnaOneCalc. Convert this pack to self-contained beads with /planning-workflow and /beads-workflow (only `br`), polish 3–4 times without losing the cache-on-save proof, then swarm fungible implementers per /agent-fungibility-philosophy. Guardrails in §11 are hard. The ready queue is polluted — close landed skeleton beads before spawning. Use ultrathink on ownership. Check beads N times, implement once. Then go.

### 14.2 Paste-ready message to every subagent

Use §9.1 verbatim. Do not customize roles.

---

## 15. Mapping from investigation actions (do not restart finished work)

| Investigation action | Status for you |
|---|---|
| S1 OxXlPlay `ValueTag::Empty` | **Done** (2026-08-31, `1c9de3b`). Do not redo. |
| S2 Reconcile W011 beads | **Your first beads** |
| S3 OxFunc 1-ULP discrete-dist | **Out of scope** (do not weaken that test either) |
| S4 DnaOneCalc archive pointer | **Out of scope** (already archived) |
| V1–V4 oxdoc host glue + save | **This campaign Wave 1** |
| Action 8 Excel compare of fixture | Wave 2, after V4 |
| Action 9 Charter dual-profile sentence | After tests, not instead of tests |
| Action 10 OxVba worktrees | **Done**. Do not resume. |
| Housekeeping worktrees/branches | **Done**. Extra branches kept. |
| Cleanup plan §17 | Later, tied to delivery; not a lead activity |

Investigation decisions this pack treats as **already taken** by the human requesting this run:

1. W011 / xlsx vertical slice is the first integration outcome.
2. DnaOneCalc remains archived.
3. OxDoc cell add/remove is **out of scope** for the first save proof.
4. Named JSM skills in §3.5 may be installed (≤3).

---

## 16. What this campaign is not

It is not a DNA Calc rewrite. It is not Foundation dual-engine work. It is not proving 517 functions. It is not UserForms. It is not last-bit numeric. It is not a git janitor pass. It is not “make all ready beads green.”

It is the smallest path that lets a user **open a real workbook, change it, recalculate it, and save it** — the gap the investigation named as the thing a spreadsheet product is for — and then, if Max remains, the next inches of **that same path**.

When Wave 1 is evidenced, you have used Max credits accretively. Wave 2–3 are dessert on the same plate. Anything else is a different meal the human did not order.

---

## 17. Failure modes worth pre-registering

| Failure | What to do |
|---|---|
| Fixture created without B1 already present | Rebuild fixture; do not teach OxDoc to add cells |
| Fixture A1 has `s=` style | Rebuild unstyled; do not loosen OxDoc attribute policy |
| `load_workbook_model_from_access` still needs eager events (R8) | Use the events API; file a named OxDoc/OxCalc follow-on; do not block Wave 1 |
| Wasm oxdoc does not link (R9) | Native/bytes first; wasm is a parked bead |
| Save refreshes A1 but leaves B1 cached 21 | **This is the campaign.** Fail the test. Fix projection/save. Do not “assert A1 only” |
| Automatic load already 21, edit to 10 does not dirty B1 | Ownership bug in host wiring of `enter_grid_cell`; compare with OxCalc’s existing W011 test |
| Two agents edit `lib.rs` | Stop one; file reservation; serialize |
| Context rot mid-polish | Fresh Fable session; re-read AGENTS.md; do not polish in mud |
| Rate limit | Pause spawn; do not start Codex/Gemini as a new architecture. Fungible replacements, same prompt |
| `br dep cycles` nonempty | Fix in plan space before any code |

---

## 18. Skill kickoff block (chooser format)

**Campaign A expected artifact:** A bead graph covering every Wave 1 goal, no cycles, ready work visible in `bv`, skeleton/sample beads no longer P1-ready.  
**Campaign A stop:** every plan goal maps to a bead and `bv` shows no cycles.

**Campaign B expected artifact:** commits + tests for open/ingest/edit/save/reopen.  
**Campaign B stop:** §13.1 or honest partial §13.2.

**Campaign C expected artifact:** fixture matrix + optional Excel/Replay compare of **this** workbook.  
**Campaign C stop:** the matrix cells for this fixture are green or explicitly blocked on Excel not being installed.

Install lines:

```text
jsm install planning-workflow
jsm install beads-bv
jsm install testing-conformance-harnesses
```

Never: `jsm install-all`.

---

*Internal working note for agent execution. Not a public attribution surface. Not Foundation doctrine.*
