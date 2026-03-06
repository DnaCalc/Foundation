You are a research agent producing a high-rigor technical dossier for a spreadsheet-style DAG computation engine.

Mission:
Build the most complete practical+theoretical synthesis you can on DAG-based incremental computation systems, with emphasis on mathematics, algorithm families, and implementation transfer to a deterministic spreadsheet engine (DNA Calc-like context).

Research mode requirements:
- Use web research with primary sources (papers/specs/official docs/repos) first.
- Spend substantial effort (deep pass), not a quick summary.
- Every nontrivial claim must be source-backed or explicitly marked as inference.
- Include direct links and access dates for all sources.

Context:
We are designing a spreadsheet computation core with:
- dependency graph maintenance under edits,
- incremental recomputation,
- dynamic dependencies (INDIRECT-like),
- cycle handling (error vs iterative),
- deterministic replay / conformance,
- optional parallel execution and optional streaming/external updates.

Out of scope:
- Product UX, business strategy, non-technical commentary.
- Proprietary internals or reverse engineering.
- Power Query / DAX / non-worksheet formula languages.

Seed sources you must include (and expand beyond):
1) Tarski fixed-point theorem (lattice-theoretic foundation)
2) Tarjan SCC / Kahn topological sorting classics
3) Self-Adjusting Computation line (Acar et al.; miniAdapton)
4) Incremental lambda calculus / Theory of Changes
5) Differential Dataflow + Timely Dataflow + Naiad
6) Build Systems à la Carte
7) Dynamic cycle detection / dynamic topological order papers
8) Spreadsheet-recalc references (Excel recalc docs, Corecalc/Sestoft, HyperFormula dependency docs)

Core research questions:
1) What is the best mathematical framing for spreadsheet DAG computation: fixed-point, trace repair, deltas, or hybrid?
2) Which algorithm families are strongest for:
   - static scheduling,
   - dynamic graph edits,
   - invalidation and stabilization,
   - dynamic dependency handling,
   - optional streaming/external updates?
3) What invariants and proof obligations are most valuable for formal verification?
4) Where are the true tradeoffs: complexity vs determinism vs throughput vs implementation risk?
5) What staged architecture is most defensible (baseline now, advanced later)?

Evaluation framework:
Score each major algorithm/theory family on:
- semantic clarity,
- proofability,
- implementation complexity,
- runtime performance potential,
- suitability for spreadsheet dynamic references,
- determinism/replay friendliness.
Use a 1–5 scale with short rationale per axis.

Required output structure (exact headings):
1. Executive Summary
2. Source Quality and Method
3. Theory Map (Math + Semantics)
4. Algorithm Family Map
5. Comparative Scoring Matrix
6. Transfer to Spreadsheet Engine Design
7. Formal Proof Obligations (candidate theorem statements)
8. Recommended Staged Architecture (Now / Next / Later)
9. Risk Register and Failure Modes
10. Open Uncertainties and Targeted Follow-up Experiments
11. Annotated Bibliography (with URLs and access dates)

Formatting constraints:
- Use concise but dense technical writing.
- Include tables where comparison helps.
- Distinguish:
  - Direct source-backed claims
  - Inferred synthesis claims
- For each major recommendation, cite at least 2 independent sources.

Citation format:
- In text: [R1], [R2], ...
- Bibliography entry includes: title, authors, venue/year (if known), URL, accessed date, and why it matters.

Quality bar:
- No handwavy “best practices” without sources.
- No single-source dependency for critical conclusions.
- Explicitly call out contradictions across sources and resolve them (or leave as open questions).

Deliverable goal:
A document that can immediately drive:
- conformance requirements drafting,
- formal model planning,
- empirical pack design,
- and implementation sequencing decisions.