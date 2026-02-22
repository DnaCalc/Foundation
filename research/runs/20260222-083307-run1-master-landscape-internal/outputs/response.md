# Internal Deep Research Run 1 - Master Landscape

- Run ID: `20260222-083307-run1-master-landscape-internal`
- Topic ID: `R-TOPIC-001`
- Prompt basis: `prompts/PROMPT_PACK_DEEP_RESEARCH.md` Run 1
- Method: internal web-backed research with primary-source preference

## 1) Executive Summary (Top Findings)
- The strongest immediate technical anchors for DNA Calc are Excel recalculation semantics, OOXML/ODF standards, and formal verification workflows with TLA+/Lean.
- Microsoft documentation is detailed enough to drive baseline semantics for recalculation behavior, async UDFs, and RTD-oriented performance assumptions.
- `ECMA-376` + `ISO/IEC 29500` remain core for OOXML interop framing; ODF 1.3 is useful for alternate-system comparison and formula portability boundaries.
- Peter Sestoft's CoreCalc/Funcalc work is highly relevant to dependency graphs, minimal recalculation, and user-defined function abstractions inside spreadsheet metaphors.
- Felienne Hermans' publication corpus is directly useful for spreadsheet quality, maintainability, smell detection, testing, and realistic dataset-grounded evaluation.
- `asupersync` is a meaningful current reference for spec-first, determinism-minded, formal-artifact-aware engineering posture that maps well to DNA Calc doctrine.
- OpenClaw canonical source location is currently unresolved from the seeded GitHub path (404), so this requires a source-resolution subtask before deriving patterns.
- For UI scale, virtualization-first rendering patterns (e.g., explicit viewport/DOM virtualization) align with the DNA Calc canvas-grid architecture direction.
- For collaboration seam design, CRDT/OT literature remains useful for tradeoff framing even if Round 0 starts with server-sequenced OpLog replication.
- For design-for-evolution governance, compatibility/versioning discipline references (e.g., Protobuf compatibility guarantees) provide concrete policy patterns.

## 2) Prioritized Reading Order

### Must Read Now
1. Excel Recalculation (Microsoft Learn)
2. ECMA-376 / ISO-29500 (OOXML standard)
3. Specifying Systems (Lamport)
4. AWS formal methods experience (CACM)
5. FoundationDB transaction model (strict serializability + conflict ranges)
6. CoreCalc technical report (Sestoft)
7. Funcalc / Spreadsheet Technology report (Sestoft)
8. Felienne Hermans publication index (spreadsheet quality and evolution)
9. HyperFormula repository/docs (modern open-source engine shape)
10. ODF 1.3 standard (OpenFormula and cross-suite baseline)

### Soon
1. Excel performance and RTD changes (Microsoft Learn)
2. Apache POI formula evaluation internals
3. TLA+ Toolbox + Hyperbook
4. Apalache symbolic model checker docs
5. AG Grid virtualization docs (for UI architecture comparison)
6. Google Sheets API conceptual model (system-facing model, not full semantics)

### Later
1. Jepsen anomaly taxonomy pages for extended verification framing
2. Protobuf compatibility guidance for version-negotiation policy ideas
3. OpenOffice and WPS product/docs deep dive
4. OpenClaw source resolution and framework pattern extraction

## 3) Research Map

### A. Spreadsheet recalculation engines
- Microsoft Excel recalculation behavior and async UDF handling.
- HyperFormula as an actively maintained headless spreadsheet engine reference.
- Apache POI formula evaluator for cached-value and dependency update model patterns.
- CoreCalc/Funcalc for minimal recalculation and support graph techniques.

### B. Concurrency & event-processing correctness
- FoundationDB strict-serializable transactions and explicit conflict-range model.
- Cockroach transaction-layer docs as a modern MVCC+timestamp architecture example.
- Snapshot isolation critique paper as anomaly taxonomy anchor.

### C. Formal methods for DSL semantics
- Lean 4 theorem-proving documentation.
- OCaml manual/tooling as an executable reference/oracle implementation platform.

### D. TLA+ for protocol verification
- Lamport book + Toolbox + Hyperbook.
- AWS production-use case for practical return-on-formalization.
- Apalache docs for symbolic model checking beyond TLC.

### E. Excel interop and file standards
- ECMA-376 / ISO-29500 for OOXML.
- ODF 1.3 for alternative open standard constraints and formula format baseline.

### F. XLL/RTD semantics
- Excel XLL SDK callback entry points (Excel4/Excel12 families).
- Excel RTD function behavior and thread-safety performance notes in modern M365.
- Office Add-ins custom functions model as a contrasting UDF architecture.

### G. UI at scale
- Tauri architecture and runtime model.
- Virtualized grid rendering references for viewport-limited DOM work.

### H. Collaboration models
- CRDT references (JSON CRDT, non-interleaving research).
- OT history references for collaborative editing consistency tradeoffs.

### I. Design-for-evolution
- Protobuf compatibility guarantees and best practices as concrete versioning policy examples.
- asupersync as a live reference for spec-first/failure-aware/runtime-governed design posture.

## 4) Annotated Bibliography (Selected)

1. **Excel Recalculation**  
   Link: https://learn.microsoft.com/en-us/office/client-developer/excel/excel-recalculation  
   Type: docs  
   Why it matters: concrete triggers/modes/async-UDF behavior for baseline semantics.

2. **ECMA-376 OOXML**  
   Link: https://ecma-international.org/publications-and-standards/standards/ecma-376/  
   Type: standard  
   Why it matters: canonical OOXML baseline for interop and round-trip policies.

3. **ODF 1.3 (OASIS)**  
   Link: https://www.oasis-open.org/standard/open-document-format-for-office-applications-opendocument-version-1-3/  
   Type: standard  
   Why it matters: non-Excel open document baseline, including OpenFormula.

4. **Specifying Systems (Lamport)**  
   Link: https://lamport.org/tla/book.html  
   Type: book/spec-method  
   Why it matters: primary TLA+ semantics and methodology reference.

5. **AWS Uses Formal Methods**  
   Link: https://cacm.acm.org/research/how-amazon-web-services-uses-formal-methods/  
   Type: paper/article  
   Why it matters: production evidence of TLA+ risk-reduction value.

6. **TLA+ Toolbox**  
   Link: https://lamport.azurewebsites.net/tla/toolbox.html  
   Type: tool docs  
   Why it matters: practical execution path for model-check workflows.

7. **Theorem Proving in Lean 4**  
   Link: https://leanprover.github.io/theorem_proving_in_lean4/  
   Type: docs/book  
   Why it matters: practical Lean proving workflow baseline.

8. **OCaml Manual**  
   Link: https://ocaml.org/manual/latest  
   Type: language docs  
   Why it matters: supports oracle CLI implementation direction.

9. **A Spreadsheet Core Implementation in C# (Sestoft)**  
   Link: https://en.itu.dk/Research/Technical-Reports/Technical-Reports-Archive/2006/TR-2006-91/  
   Type: technical report  
   Why it matters: direct architecture and minimal recalculation techniques.

10. **Spreadsheet Technology / Funcalc (Sestoft)**  
    Link: https://en.itu.dk/Research/Technical-Reports/Technical-Reports-Archive/2011/TR-2011-142/  
    Type: technical report  
    Why it matters: sheet-defined functions, specialization, performance techniques.

11. **Corecalc and Funcalc portal**  
    Link: https://www.itu.dk/~sestoft/funcalc/  
    Type: project page  
    Why it matters: implementation artifacts and code access point.

12. **Felienne Hermans publications**  
    Link: https://www.felienne.com/publications  
    Type: publication index  
    Why it matters: concentrated spreadsheet quality/evolution research corpus.

13. **A Maintainability Checklist for Spreadsheets**  
    Link: https://arxiv.org/abs/1401.7814  
    Type: paper  
    Why it matters: maintainability assessment framing.

14. **Enron spreadsheets dataset note (Hermans)**  
    Link: https://www.felienne.com/archives/3634  
    Type: dataset/blog pointer  
    Why it matters: realistic spreadsheet corpus context for tooling evaluation.

15. **HyperFormula repository**  
    Link: https://github.com/handsontable/hyperformula  
    Type: repo  
    Why it matters: modern headless engine design and operation surface.

16. **Apache POI Formula Evaluation**  
    Link: https://poi.apache.org/components/spreadsheet/eval.html  
    Type: engineering docs  
    Why it matters: formula caching and evaluator architecture guidance.

17. **FoundationDB Developer Guide**  
    Link: https://apple.github.io/foundationdb/developer-guide.html  
    Type: docs  
    Why it matters: strict-serializable transactional model and conflict-range mechanics.

18. **A Critique of ANSI SQL Isolation Levels**  
    Link: https://arxiv.org/abs/cs/0701157  
    Type: paper  
    Why it matters: baseline anomaly/isolation terminology (including snapshot isolation).

19. **asupersync repository**  
    Link: https://github.com/Dicklesworthstone/asupersync  
    Type: repo  
    Why it matters: target reference for determinism/spec-first/runtime-correctness posture.

20. **Tauri start/architecture**  
    Link: https://tauri.app/start/  
    Type: framework docs  
    Why it matters: validates UI shell assumptions for desktop/web hybrid stack.

## 5) Steal-This-Pattern (Concrete Patterns)
- Use explicit operation log entries for all persistent and external updates.
- Keep cached/derived values separate from source-of-truth inputs.
- Treat stale/pending status as first-class observable state in UI/API.
- Enforce deterministic replay mode with canonical traces for debugging and conformance.
- Keep spec/proof/model artifacts in CI-visible folders, not ad hoc docs.
- Gate profile readiness via computed obligation packs, not checklists by memory.
- Make degradation classes explicit (`Native/Lowered/Opaque/Rejected`) and diagnostics-visible.
- Use constrained run durations and explicit conflict surfaces for concurrency testing.
- Prefer file/CLI interfaces between tools to reduce coupling and increase reproducibility.
- Keep one source registry with status tags (`pending/screened/adopted/rejected`) for evidence hygiene.

## 6) Risk Retirement Table (Top 10)
| Risk | Candidate source(s) | Retirement direction |
|---|---|---|
| Ambiguous recalculation semantics | Microsoft Excel recalculation docs | Codify baseline semantics and edge-trigger matrix |
| Weak external update model | Excel async/RTD docs + FoundationDB conflict model | Define explicit external op schema and ordering policy |
| Interop drift | ECMA-376 + ODF 1.3 | Define strict round-trip/preserve rules per profile |
| Unbounded concurrency ambiguity | TLA+ book/tooling + AWS case study | Build minimal model + invariants before implementation expansion |
| Non-replayable failures | asupersync + POI evaluator lessons | Require deterministic traces and replay tooling |
| UI scaling brittleness | Tauri + virtualization docs | Encode viewport/draw invariants and virtualization contracts |
| Collaboration seam indecision | CRDT/OT references + OpLog-first doctrine | Keep server-sequenced seam now, capture later expansion contract |
| Inadequate spreadsheet corpora | Sestoft + Felienne + corpus catalogs | Define benchmark corpus pipeline and annotation targets |
| Requirements/evidence disconnect | OASIS/ECMA + operations evidence workflow | Force REQ/REAL ↔ evidence linkage in run artifacts |
| Versioning policy ambiguity | protobuf compatibility guidance + semver spec | Formalize compatibility negotiation/version bump rules |

## 7) Gaps and Follow-up Queries
- OpenClaw canonical source location appears unresolved for seeded `petestei` GitHub path (404).
- WPS public technical internals are sparse compared to open-source suites.
- Need targeted source gathering for Google Sheets recalculation semantics (not only API model).

Suggested follow-up queries:
1. "official OpenClaw repository maintained by Peter Steinberger"
2. "Google Sheets recalculation engine behavior volatile functions iterative calculation"
3. "LibreOffice Calc dependency graph recalculation internals source code"
4. "asupersync development history architecture decisions deterministic replay"

## Recommended Follow-up Deep Research Runs
1. Run 2 (Concurrency protocol & MVCC epochs) - highest immediate risk retirement.
2. Targeted run on asupersync + OpenClaw design patterns for Design-for-Evolution doctrine hardening.
3. Spreadsheet systems landscape deep dive (OpenOffice/LibreOffice/WPS/Google Sheets/Numbers/Gnumeric).
