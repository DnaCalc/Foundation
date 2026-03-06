You are Claude acting as a deep technical research analyst.

Task:
Produce a rigorous, source-grounded research dossier on DAG-based incremental computation theory and algorithms for a deterministic spreadsheet engine.

Important:
- Work in multiple explicit passes.
- Prefer primary sources (papers/specs/official docs/repos).
- Mark all synthesis-level conclusions as inference when not directly stated in sources.
- Include direct URLs and access dates.

==================================================
CONTEXT
==================================================
Target system resembles a spreadsheet computation core with:
- dependency graph construction and maintenance,
- incremental recomputation under edits,
- dynamic dependencies (INDIRECT-like behavior),
- cycle policy (error vs iterative),
- deterministic replay/conformance requirements,
- optional parallel scheduling,
- optional streaming/external update lanes.

Out of scope:
- product UX/business strategy,
- proprietary internals/reverse engineering,
- Power Query / DAX / non-worksheet formula languages.

==================================================
RESEARCH PASSES (MUST FOLLOW)
==================================================

Pass 1: Source Discovery + Triage
- Find and triage canonical sources for:
  1) fixed-point/lattice foundations,
  2) topological ordering + SCC theory,
  3) self-adjusting computation,
  4) incremental lambda calculus / change structures,
  5) differential/timely dataflow,
  6) dynamic cycle detection / dynamic topological order,
  7) build-system dependency/recompute theory,
  8) spreadsheet-specific recalc references.
- Output a ranked source shortlist with quality notes.

Pass 2: Theory Extraction
- Extract formal ideas and definitions from sources:
  - state models,
  - operator assumptions (monotonicity, partial orders),
  - convergence/stabilization conditions,
  - complexity claims.
- Separate direct source claims from your inferences.

Pass 3: Algorithm Mapping
- Map theory to algorithm families for:
  - static scheduling,
  - dynamic graph maintenance,
  - invalidation/recompute,
  - dynamic dependency handling,
  - optional streaming updates.
- Capture complexity and engineering constraints.

Pass 4: Comparative Evaluation
- Score each major family on:
  - semantic clarity,
  - proofability,
  - implementation complexity,
  - runtime potential,
  - spreadsheet dynamic-reference suitability,
  - determinism/replay friendliness.
- Use 1–5 scale with brief rationale per axis.

Pass 5: Transfer + Program Design
- Propose staged architecture:
  - Now (high-confidence baseline),
  - Next (medium-risk high-value),
  - Later (advanced/research lane).
- Provide candidate formal proof obligations and empirical experiment plan.

==================================================
SEED SOURCES YOU MUST COVER (AND EXPAND BEYOND)
==================================================
1. Tarski fixed-point theorem
2. Tarjan SCC and Kahn topological sorting classics
3. Self-Adjusting Computation line (Acar et al.; miniAdapton)
4. Incremental lambda calculus / Theory of Changes
5. Differential Dataflow + Timely Dataflow + Naiad
6. Build Systems à la Carte
7. Dynamic cycle detection / dynamic topological order papers
8. Spreadsheet recalc references (Excel recalc docs, Corecalc/Sestoft, HyperFormula dependency docs)

==================================================
OUTPUT FORMAT (EXACT HEADINGS)
==================================================
1. Executive Summary
2. Method and Source Selection
3. Pass 1 Results: Source Shortlist
4. Pass 2 Results: Theory and Mathematics
5. Pass 3 Results: Algorithm Family Map
6. Pass 4 Results: Comparative Scoring Matrix
7. Pass 5 Results: Transfer to Spreadsheet Engine
8. Candidate Formal Proof Obligations
9. Empirical Experiment Plan
10. Risks, Contradictions, and Open Questions
11. Annotated Bibliography

==================================================
QUALITY CONSTRAINTS
==================================================
- No unsupported best-practice assertions.
- Critical conclusions must cite at least two independent sources where possible.
- Explicitly flag contradictions across sources.
- Use citation tags [S1], [S2], ... and map them in bibliography.
- For each bibliography entry include:
  title, authors, venue/year (if known), URL, accessed date, and relevance.

Desired deliverable:
A dossier that can directly drive conformance requirement drafting, formal model planning, and implementation sequencing decisions.