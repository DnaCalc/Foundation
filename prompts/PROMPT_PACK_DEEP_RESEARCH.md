# PROMPT_PACK_DEEP_RESEARCH.md - DNA Calc Prompt Pack for Deep Research

Below is a **Deep Research prompt pack** tuned for **DNA Calc / DnaVisiCalc**. The first is a “master landscape” run; the rest are targeted runs you can do in parallel. Each prompt assumes you’ll paste your docs at the end.

---

## Run 1 — Master Deep Research (landscape + prioritized reading list)

```text
You are Green Team Research (Spec/Assurance). You will receive four documents: CHARTER.md, OPERATIONS.md, ARCHITECTURE_AND_REQUIREMENTS.md, BRAINSTORM_NOTES.md.

Mission for this research run:
Build a deeply relevant, clean-room-safe research dossier for DNA Calc / DnaVisiCalc. Gather public documents, specs, research papers, and open-source projects that directly support the key ideas and requirements in the docs. Favor primary sources and authoritative references. Include links.

Hard constraints:
- Clean-room: use only public sources and observable behavior writeups; do not rely on proprietary leaks or reverse-engineering internals.
- Focus: prefer sources that directly inform our spec stack (Lean semantics, TLA+ concurrency, oracle/testing, protocol versioning/profiles, Excel compatibility, XLL/RTD/VBA interfaces, UI grid performance, collaboration op-log).
- Recency: for unstable topics (Excel compatibility versions, Office APIs, WebView/Tauri behavior), prioritize the most recent reliable sources and call out dates.

Deliverables (structure exactly like this):
1) Executive Summary (10 bullets max): the top findings and why they matter for DnaVisiCalc and DnaCalc.
2) Prioritized Reading Order: 12–20 items, grouped into “Must read now / Soon / Later”.
3) Research Map (categories):
   A. Spreadsheet recalculation engines (dependency graphs, calc chain, incremental recompute)
   B. Concurrency & event-processing correctness (epochs/MVCC, scheduling, cancellation)
   C. Formal methods for software + DSL semantics (Lean, Coq/F*, refinement patterns)
   D. TLA+ for concurrency protocols (practical patterns and case studies)
   E. Excel interop (OOXML/xlsx/xlsm parts, macro blob handling, compatibility versions)
   F. XLL & RTD semantics (registration, marshalling, thread safety, volatility)
   G. UI at scale (canvas/WebGL grids, DOM overlay editing, IME, virtualization, tile caching)
   H. Collaboration (op-log replication, OT/CRDT lessons for spreadsheets)
   I. Design-for-evolution (profiles, capability negotiation, graceful degradation)
4) Annotated Bibliography:
   For each item, provide:
   - Title + link
   - Type: (paper/spec/docs/repo/blog)
   - What it teaches us (3 bullets)
   - Which DNA Calc module(s) it informs (reference the boundaries / profiles / packs concepts)
   - How to apply it (actionable)
   - Credibility note (why this source)
5) “Steal This Pattern” section:
   10–15 concrete patterns we should adopt (each 1–3 sentences) with supporting sources.
6) Risk Retirement Table:
   List the top 10 risks in the docs, and which sources/patterns help retire them (with links).
7) Gaps and Follow-up Queries:
   What you could not find or what is still ambiguous; propose exact search queries for a second run.

End with:
- A recommended set of 3 follow-up Deep Research runs (from the targeted prompts below) based on what you discovered.

Now ingest the docs (pasted below) and begin.

===DOCS===
[paste CHARTER.md, OPERATIONS.md, ARCHITECTURE_AND_REQUIREMENTS.md, BRAINSTORM_NOTES.md]
```

---

## Run 2 — Concurrency protocol & MVCC epochs (TLA+-first)

```text
You are researching only the concurrency/event-processing pillar for DNA Calc.

Goal:
Find the best public references and exemplars for:
- MVCC/snapshot consistency concepts applied to non-database systems
- generation/epoch tagging and stale result dropping patterns
- verified scheduling protocols and cancellation semantics
- real-world TLA+ models of similar systems (task scheduling, queues, state machines)
- refinement strategies: TLA+ protocol ↔ sequential spec ↔ implementation checks

Deliver:
- 10–15 best sources with annotated notes
- a shortlist of 3–5 TLA+ model patterns we can directly adapt
- common failure modes and the invariants that catch them
- recommended TLC configuration strategies for small-model discovery
- a “how to translate our terms into TLA+ state/actions” guide

===DOCS===
[paste the four docs]
```

---

## Run 3 — Excel interop: OOXML, XLSM, compatibility versions, clean-room evidence

```text
You are researching Excel compatibility and file-format interop for DNA Calc.

Goal:
Collect authoritative public sources for:
- OOXML structure relevant to formulas, shared strings, styles, and macros (.xlsm / vbaProject.bin)
- Excel “Compatibility Versions” feature (workbook-scoped calc semantics versioning)
- official docs on recalculation behavior and multithreaded recalc
- best practices for clean-room compatibility testing based on observed behavior
- round-trip preservation strategies for unknown parts/attachments

Deliver:
- an annotated source list prioritized by authority
- a “clean-room evidence log” pattern with examples
- a minimal subset of OOXML/macros facts DnaPreCalc must support end-to-end
- known pitfalls in .xlsm handling and how projects mitigate them

===DOCS===
[paste the four docs]
```

---

## Run 4 — XLL + RTD semantics (interfaces, marshalling, thread-safety)

```text
You are researching XLL and RTD semantics for DNA Calc, with focus on public sources only.

Goal:
Find the best references for:
- XLL function registration metadata and calling semantics
- marshalling types, memory ownership conventions, and lifecycle (“AutoFree”-like patterns) as documented publicly
- thread-safe vs non-thread-safe UDF execution constraints and multithreaded recalculation implications
- RTD server lifecycle, topics, update propagation, and how it interacts with calc
- practical compatibility harness approaches

Deliver:
- source list + key takeaways
- a matrix of required behaviors (registration, call, volatility, thread-safety, RTD update rules)
- recommendations for what DnaVisiCalc vs DnaPreCalc should include
- public test corpora ideas (if any) and how to structure ours

===DOCS===
[paste the four docs]
```

---

## Run 5 — UI at scale: canvas/WebGL grid + DOM editor overlay

```text
You are researching UI patterns for giant spreadsheet grids.

Goal:
Find high-quality sources and example projects covering:
- virtualized grid rendering via canvas/WebGL
- DOM overlay editing for IME/clipboard/selection
- tile caching, dirty rectangles, text measurement caching
- deterministic testing strategies (RenderPlan IR, geometry invariants, replayable input traces)
- performance pitfalls and proven fixes

Deliver:
- top sources + top open-source exemplars
- distilled “UI invariants” list we should test
- a recommended testing stack for reliability without screenshot brittleness
- key metrics and profiling approaches for smooth scrolling and edit latency

===DOCS===
[paste the four docs]
```

---

## Run 6 — Collaboration seam: OpLog replication + OT/CRDT lessons for spreadsheets

```text
You are researching collaboration architecture choices for DNA Calc.

Goal:
Collect the best public sources on:
- server-sequenced op logs and deterministic replication
- OT/CRDT lessons specifically for structured documents and spreadsheets
- identity under structural edits (rows/cols, ranges) and how systems handle it
- how collaboration interacts with recalculation and external data streams
- staged rollout approaches (presence first, multi-writer later)

Deliver:
- a “collaboration seam” design brief with sources
- a staged roadmap that fits DnaVisiCalc → DnaPreCalc → DnaCalc
- explicit recommendations on what to design-in early (without implementing fully)

===DOCS===
[paste the four docs]
```

---

## Run 7 — Spec stack and near-formal toolchain (Lean + OCaml oracle + packs)

```text
You are researching near-formal engineering workflows relevant to DNA Calc.

Goal:
Find the best public sources and exemplars for:
- Lean used for DSL semantics and proofs that stay maintainable
- combining theorem proving (Lean) with model checking (TLA+)
- executable reference oracles and differential testing (including shrink/minimization)
- “proof-adjacent” development: obligation packs, computed gates, conformance reporting
- managing multi-language toolchains without chaos (one-command workflows, hermetic envs)

Deliver:
- 10–15 sources + concrete patterns we can copy
- a recommended minimal set of proofs and a minimal set of model-check invariants for Pathfinder
- a pragmatic integration plan for Lean+TLA++OCaml oracle in CI
- common failure modes of near-formal projects and mitigations

===DOCS===
[paste the four docs]
```

---

## If you want a “multi-run” strategy

1. Run **Run 1** (landscape).
2. Then pick **two deep dives** based on what looks riskiest right now (usually Run 2 + Run 4, or Run 2 + Run 7).
3. Finally run **Run 3** once you commit to an Excel interop profile target.

---

### Small add-on you can paste into any run

If you want the model to output sources in a form you can directly convert to packs, add this at the end:

```text
Extra output requirement:
For the top 10 sources, propose a corresponding “obligation pack idea” (what it would test or prove) and a concrete acceptance criterion.
```

If you tell me which two areas you consider most uncertain right now (e.g., “RTD semantics” and “TLA+ modeling approach”), I’ll tailor a single combined Deep Research prompt that forces the model to return exactly what you need for next Orders.
