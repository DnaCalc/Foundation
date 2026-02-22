# DNA Calc / DnaVisiCalc Master Deep Research Run

## Executive Summary

1) **Excel’s public recalculation model cleanly decomposes into (a) dependency discovery, (b) a calculation order (“calculation chain”), and (c) execution—exactly the separation DNA Calc wants across OpLog → DocSnapshot → CalcDeltas.** Excel documentation explicitly describes a dependency tree and a calculation chain, and notes the chain can be revised during recalculation; separately, Open XML documentation clarifies that the persisted *calculationChain part* records only last calculation order—not true dependencies—so DNA Calc must treat “calc chain” as a cache/artifact, not the semantic source of truth. citeturn0search0turn0search4 fileciteturn0file0

2) **Thread-safe UDFs and parallel calculation are a compatibility landmine—and Microsoft’s XLL docs give a clean-room-safe rulebook for “thread-safe vs serialized” execution and which callbacks become illegal under MTR.** Microsoft’s multithreaded recalculation docs explain MTR and scaling controls; XLL registration docs warn that declaring a function thread-safe imposes restrictions (e.g., certain C API calls fail with `xlretNotThreadSafe`). This maps directly onto DNA Calc’s “lock discipline,” “deterministic mode,” and UDF scheduling constraints. citeturn0search12turn0search2turn0search18 fileciteturn0file0

3) **RTD semantics can be implemented clean-room using Microsoft’s documented COM contract (`IRtdServer`), and DNA Calc’s “STREAM replay bundles” concept is a direct fit for RTD topic lifecycle + `RefreshData`-style update delivery.** Microsoft documentation explains RTD servers must implement `IRtdServer` and shows how topics connect; the `ConnectData` docs describe when Excel attaches topics (file open, formula entry). This directly informs the OpExternalUpdate operation design and replay/minimization artifacts in the Green stack. citeturn0search3turn0search7turn0search11 fileciteturn0file0turn0file2

4) **Macro-enabled workbook preservation is best treated as “opaque blob + minimal metadata,” and Microsoft’s public macro packaging specs explicitly support that boundary.** DNA Calc’s requirement—store the VBA project as an opaque blob outside the core engine—aligns with the macro packaging specs that define how the workbook relates to a VBA Project part, and that constrain the VBA Project part’s relationships. citeturn7search1turn7search3turn7search7 fileciteturn0file0turn0file1

5) **Office Open XML is standardized (ECMA-376) but Excel compatibility requires tracking “standard vs Office/Excel extensions,” and Microsoft explicitly publishes implementation notes and extension specs that are admissible clean-room evidence inputs.** ECMA-376 (Dec 2021 edition) provides the baseline; Microsoft’s Open Specifications include Office implementation information for ECMA-376 and Excel-specific extensions to SpreadsheetML, and warn their content can update frequently—so these should drive profile/versioning decisions and evidence logs tied to compatibility claims. citeturn0search1turn0search5turn7search0 fileciteturn0file2turn0file1

6) **A strong prior exists for “minimal recalculation via a compact dependency/support graph,” with implementable algorithms and reference code pathways that match DNA Calc’s planned pipeline.** entity["people","Peter Sestoft","spreadsheet researcher"]’s technical reports describe core spreadsheet computation, dependency representations (“support graph”), and strategies for minimal recalculation, providing a clean-room foundation for requirements, OCaml oracle behaviors, and conformance fixtures. citeturn5search3turn5search2turn17search2 fileciteturn0file0turn0file2

7) **Existing open-source calc engines (especially HyperFormula) provide practical, inspectable designs for dependency graphs, volatile functions, and incremental updates—useful both as idea reservoirs and as “anti-requirements” (what to avoid) when targeting Excel parity.** HyperFormula publicly documents its dependency graph and volatile-function model; its repo scope (CRUD, undo/redo, clipboard support) overlaps DNA Calc’s pathfinder scaffolding even if semantics differ. citeturn5search0turn15search17turn18search0 fileciteturn0file0

8) **TLA+ is unusually well-aligned with the “epoch lattice + no stale commit + exclusive mutation windows” invariants in DNA Calc’s architecture, and industrial case studies show it’s viable and high-ROI.** entity["people","Leslie Lamport","tla+ creator"]’s book and tool docs establish the modeling and model-checking workflow; AWS’s published experience describes using specification/model checking to prevent subtle distributed-system bugs—directly supporting DNA Calc’s pack-gated, model-checked concurrency protocol posture. citeturn14search10turn14search2turn2search14 fileciteturn0file0turn0file2

9) **Deterministic regression minimization is not a “nice to have”: Delta Debugging provides a canonical algorithmic basis for DNA Calc’s minimized trace corpus and “regressions are assets” doctrine.** entity["people","Andreas Zeller","software engineering researcher"]’s Delta Debugging work formalizes automatic reduction of failure-inducing inputs to minimal repros, matching the “trace minimizer + replayable artifacts” described in operations doctrine. citeturn11search0 fileciteturn0file2turn0file1

10) **UI feasibility for “Excel-grade editing on a Canvas/WebGL grid” has strong evidence: production-grade canvas grids exist and web standards now clearly describe IME and clipboard event contracts—but the WebView substrate varies by Tauri platform and must be treated as a profile dimension.** Glide Data Grid demonstrates large-scale, canvas-based rendering with rich interaction; W3C Input Events and Clipboard API specs define the events required for IME and clipboard correctness; Tauri documents how it relies on system WebViews and lists per-platform WebView version behavior—so UI correctness packs must be scoped to the WebView profile. citeturn1search1turn8search0turn8search1turn1search0 fileciteturn0file0turn0file2

## Prioritized Reading Order

### Must read now

- **Excel Recalculation (dependency tree + calculation chain)** citeturn0search0  
- **Multithreaded recalculation in Excel (constraints for parallel compute + add-ins)** citeturn0search12  
- **Excel XLL SDK (registration, thread-safety constraints, callable surface)** citeturn0search14  
- **RealTimeData / `IRtdServer` (topic lifecycle hooks and update delivery surface)** citeturn0search3turn0search7  
- **Office Open XML baseline (ECMA-376, 5th edition, Dec 2021) + packaging model** citeturn0search1  
- **Microsoft Office implementation notes for ECMA-376 ([MS-OE376])** citeturn0search5  
- **Macro-enabled workbook structure ([MS-OFFMACRO2])—VBA project part relationships** citeturn7search1turn7search3  
- **A Spreadsheet Core Implementation in C# (Corecalc-era minimal engine foundations)** citeturn5search3  

### Soon

- **HyperFormula design docs (dependency graph + volatile functions + incremental edits)** citeturn5search0turn15search17  
- **Apache POI formula evaluation (cached results reality + extension/function gaps)** citeturn5search1turn5search9  
- **Specifying Systems (TLA+), plus TLC/Toolbox workflow** citeturn14search10turn14search2  
- **Apalache model checker for TLA+ (SMT-backed checking, inductive invariants)** citeturn2search1turn18search3  
- **Theorem Proving in Lean 4 (practical foundation for semantics proofs)** citeturn2search0  

### Later

- **Delta Debugging (ddmin-based test/trace minimization)** citeturn11search0  
- **MVCC + Snapshot Isolation background (to sharpen epoch/MVCC invariants)** citeturn3search0turn3search3  
- **CRDT/OT collaboration foundations (for op-log replication vs peer-to-peer futures)** citeturn1search3turn13search2  
- **High-performance grid UI references (Canvas grid + IME/clipboard + WebView substrate)** citeturn1search1turn8search0turn8search1turn1search0  
- **Design-for-evolution norms (SemVer + capability/negotiation patterns)** citeturn4search2turn9search20turn9search8  

## Research Map

**A. Spreadsheet recalculation engines (dependency graphs, calc chain, incremental recompute)**  
Excel’s documented distinction between dependency tree and calculation chain provides a clean-room behavioral contract for profile-defined recalc semantics and for the “CalcDeltas” pipeline (parse/bind/graph/invalidate/schedule/eval/commit). citeturn0search0 The fact that Open XML’s `calculationChain` part preserves only last-calculated order (not dependency structure) reinforces DNA Calc’s approach: dependencies must be derived and stored as first-class internal artifacts under a profile, while calc order traces remain caches/diagnostics. citeturn0search4 fileciteturn0file0 Implementable minimal-recalc designs are described in Corecalc-era work, and modern open-source engines document practical dependency-graph maintenance and volatile semantics. citeturn5search3turn5search0turn15search17

**B. Concurrency & event-processing correctness (epochs/MVCC, scheduling, cancellation)**  
Excel’s multithreaded recalculation rules plus “thread-safe UDF” constraints are the clean-room-compatible anchor for designing DNA Calc’s scheduler modes, UDF flags (volatile/thread-safe), and “deterministic mode” replay discipline. citeturn0search12turn0search2 DNA Calc’s epoch model reads like MVCC with snapshot pinning; MVCC and snapshot isolation references sharpen vocabulary and known anomaly classes, useful for drafting invariants and TLA+ properties. citeturn3search0turn3search3 fileciteturn0file0

**C. Formal methods for software + DSL semantics (Lean, refinement patterns)**  
Lean 4’s official book provides the practical basis for structuring semantics proofs, reusable lemmas, and proof engineering discipline that can align with an executable oracle and pack-gated requirements. citeturn2search0 DNA Calc’s intent to prove core semantics and structural rewrite soundness maps directly to Lean’s strengths in inductive definitions and equational reasoning, with proofs then feeding pack obligations. fileciteturn0file0turn0file2

**D. TLA+ for concurrency protocols (practical patterns and case studies)**  
TLA+’s standard workflow—write a specification and check models with TLC—matches DNA Calc’s stated “PACK.concurrent.epochs” and “archived minimized counterexample traces” approach. citeturn14search2turn14search10 Apalache provides an SMT-backed alternative, expanding feasible checking strategies (bounded safety + inductive invariants) that can complement TLC in the Green stack. citeturn2search1turn18search11 AWS’s published industrial experience supports the claim that this is practical value, not academic theater. citeturn2search14

**E. Excel interop (OOXML/xlsx/xlsm parts, macro blob handling, compatibility versions)**  
ECMA-376 is the baseline for Open XML packaging and markup; Microsoft’s “implementation information” ([MS-OE376]) and Excel extensions specs ([MS-XLSX]) are critical for Excel-grade interop under clean-room rules, because they describe known variances/extensions and update frequently. citeturn0search1turn0search5turn7search0 Macro-enabled workbook structure can be handled as “opaque blob + relationship integrity,” supported by standard macro packaging specs. citeturn7search1turn7search3turn7search12 fileciteturn0file0turn0file1

**F. XLL & RTD semantics (registration, marshalling, thread safety, volatility)**  
Microsoft’s XLL docs detail registration entry points and constraints; the xlfRegister docs explicitly encode thread-safety semantics and enforceable restrictions (e.g., failing non-thread-safe callbacks). citeturn0search14turn0search2 Volatility is explicitly specifiable for UDFs (VBA `Application.Volatile` and add-in guidance), which should map to profile-level numeric/staleness semantics and recalculation triggers. citeturn15search3turn15search5 RTD’s `IRtdServer` contract provides a defined lifecycle surface that DNA Calc can represent through explicit OpLog external-update operations plus replay bundles. citeturn0search3turn0search7 fileciteturn0file0turn0file2

**G. UI at scale (canvas/WebGL grids, DOM overlay editing, IME, virtualization, tile caching)**  
Glide Data Grid provides strong evidence for a “canvas grid + native-feeling editing” approach at large scale. citeturn1search1 W3C Input Events and Clipboard API specs clearly define the event pathways a spreadsheet editor must correctly handle (IME composition, beforeinput/input, clipboard read/write hooks), which should become explicit UI invariants and pack tests rather than “best-effort UI code.” citeturn8search0turn8search1 Tauri’s system-WebView approach and its per-platform WebView version behavior should be treated as part of the UI profile surface, because it changes event timing/compatibility and performance characteristics. citeturn1search0turn1search16 fileciteturn0file0turn0file2

**H. Collaboration (op-log replication, OT/CRDT lessons for spreadsheets)**  
CRDT fundamentals provide formal convergence concepts and tradeoffs; OT references document “intention preservation” and transformation-based co-editing. citeturn1search3turn13search2 For DNA Calc’s “server-sequenced op-log replication” preference, Raft’s replicated log model is a strong conceptual template for deterministically ordering operations, even if DNA Calc’s collaboration architecture doesn’t adopt Raft wholesale. citeturn4search3 fileciteturn0file0turn0file3turn0file2

**I. Design-for-evolution (profiles, capability negotiation, graceful degradation)**  
SemVer provides widely adopted language for version compatibility expectations; RFC 2703 describes a general capability-negotiation framework; Protobuf’s published guidance illustrates forward/backward compatibility behaviors that map well to “schema-defined protocol surfaces + feature gating.” citeturn4search2turn9search20turn9search8 These, combined with DNA Calc’s internal “profiles + feature gates + degrade policy classes,” create a concrete, auditable evolution story for the identical protocol surfaces across engines. fileciteturn0file0turn0file1turn0file2

## Annotated Bibliography

### Excel Recalculation (Microsoft Learn) citeturn0search0  
Type: docs

What it teaches us  
- Excel models recalculation as dependency tracking (“dependency tree”) plus an ordered recalculation plan (“calculation chain”) rather than naïve “re-run everything.” citeturn0search0  
- The calculation chain is an operational artifact that can be revised during recalculation when new dependencies are encountered. citeturn0search0  
- Volatility is first-class: Excel supports marking UDFs volatile and ties it to recalc behavior (relevant to profile semantics). citeturn15search7  

Which DNA Calc module(s) it informs  
- **Profiles**: recalc triggers (manual/auto), volatility policy, dependency-extraction rules. fileciteturn0file0turn0file1  
- **DocSnapshot**: dependency graph as derived, versioned artifact pinned to an epoch. fileciteturn0file0  
- **CalcDeltas**: status signaling (“pending/ready/error” and stale visibility) closely matches the observable “user can trust what they see” intent. fileciteturn0file0  
- Packs: feeds `PACK.visicalc.core` and any Excel-differential packs for recalc semantics. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Write a profile-owned spec for **dependency discovery** vs **calculation order**, and require that any persisted “calc order” is treated as a cache/emitted artifact, never as semantic truth. citeturn0search0turn0search4  
- Create conformance fixtures that assert: (1) a minimal invalidation closure, (2) deterministic recalculation order under deterministic mode, and (3) correct stale/pending signaling at every epoch view. fileciteturn0file0turn0file2  

Credibility note  
- This is official documentation from entity["company","Microsoft","software vendor"] describing expected observable behavior of Excel recalculation. citeturn0search0  

### Multithreaded recalculation in Excel (Microsoft Learn) citeturn0search12  
Type: docs

What it teaches us  
- Excel has supported multithreaded recalculation since Excel 2007 and exposes configuration for concurrency, meaning parallel evaluation is part of the compatibility envelope. citeturn0search12  
- Parallelism interacts with UDF add-ins: thread-safe worksheet functions are possible but must obey rules. citeturn0search18turn0search2  
- Performance scaling is not “free”: thread overhead and scheduling decisions matter even in Excel’s model. citeturn0search12  

Which DNA Calc module(s) it informs  
- **Calc engine scheduler** (CalcDeltas pipeline): task scheduling, cancellation, and deterministic replay mode. fileciteturn0file0turn0file3  
- **Profiles / feature gates**: `thread_safe_udf` flag semantics, and whether deterministic mode constrains execution/commit order. fileciteturn0file0turn0file1  
- Packs: strengthens `PACK.concurrent.epochs` and any “parallel determinism policy” pack. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Specify a “parallel-but-replayable” rule: allow parallel work, but require deterministic commit ordering and event trace generation under deterministic mode. fileciteturn0file0turn0file2  
- Add a pack that forces UDF thread-safety violations to be *detectable* and *deterministic* (e.g., “thread-safe UDF cannot call forbidden callbacks”). citeturn0search2turn0search18  

Credibility note  
- Official Excel developer documentation describing a long-lived, shipped behavior surface. citeturn0search12  

### Excel XLL SDK API Function Reference (Microsoft Learn) citeturn0search14  
Type: docs

What it teaches us  
- The XLL SDK defines a concrete API surface for worksheet functions, callbacks, and XLL lifecycle entry points. citeturn0search14turn0search6  
- Thread safety is explicitly part of the registration contract; Excel enforces restrictions when a function is declared thread-safe. citeturn0search2  
- The C API is the compatibility ground truth for in-process add-ins; it must be modeled as an explicit boundary contract. citeturn0search18  

Which DNA Calc module(s) it informs  
- **Protocol surface** (identical Red/Blue): schema for UDF registration metadata (name, arity, volatility, thread-safe). fileciteturn0file0turn0file1  
- **External UDF/XLL integration boundary**: formal marshalling + lifecycle contracts; `PACK.udf.basic` and later full `PACK.xll.compat`. fileciteturn0file0turn0file2  
- **Determinism-first debugging**: contract-level failures must produce replayable traces for minimized regressions. fileciteturn0file1turn0file2  

How to apply it (actionable)  
- Treat “XLL host” as an adapter facade with a spec’d ABI boundary, even if the full host is later-round scope; implement the Pathfinder subset as a formally versioned “UDF pack.” fileciteturn0file0turn0file2  
- Encode flags and prohibition rules into a conformance pack (“thread-safe functions may not call these callbacks; violations produce deterministic errors”). citeturn0search2  

Credibility note  
- Official developer docs for the Excel XLL SDK surface and callback catalog. citeturn0search14  

### How to create a RealTimeData server for Excel (Microsoft Learn) citeturn0search3  
Type: docs

What it teaches us  
- An RTD server must implement `IRtdServer`, anchoring topic lifecycle and update delivery in a public contract. citeturn0search3turn0search7  
- RTD usage is formula-driven (`RTD(...)`), which mirrors DNA Calc’s planned `STREAM("topic")` pathfinder plus “full RTD lifecycle” future. citeturn0search3 fileciteturn0file0  
- Topic attachment timing (open workbook or entering formula) is observable behavior suitable for black-box conformance packs. citeturn0search7  

Which DNA Calc module(s) it informs  
- **OpLog**: external updates must be explicit operations (OpExternalUpdate) with dedupe/ordering/coalescing rules. fileciteturn0file0turn0file2  
- **Profiles / feature gates**: `FG_RTD_LIFECYCLE`, stream semantics versions, and collaboration policy for shared vs local oracle values. fileciteturn0file0turn0file3turn0file1  
- Packs: `PACK.stream.basic`, `PACK.stream.oracle.diff`, and concurrency integration in `PACK.concurrent.epochs`. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Specify RTD-like semantics as an *epoch-scoped external provider* that emits explicit ops plus a **replay bundle** (topic declarations + update envelopes + timing/ordering guarantees). fileciteturn0file0turn0file2  
- Build a black-box harness that drives RTD/STREAM scenarios and captures minimal replay bundles for regression corpuses. fileciteturn0file2turn0file1  

Credibility note  
- Official documentation for an Excel feature whose semantics are externally observable and contract-bound. citeturn0search3  

### Office Open XML file formats (ECMA-376, 5th edition) citeturn0search1  
Type: spec/standard

What it teaches us  
- The core packaging and markup model for `.xlsx/.xlsm` files is standardized and publicly implementable. citeturn0search1  
- OOXML is extensible by design (parts, relationships, content types), which aligns with DNA Calc’s “unknown parts round-trip” and “opaque attachments” doctrine. citeturn6search3turn0search1 fileciteturn0file1turn0file0  
- The standard is versioned (editions), enabling DNA Calc to treat “compatibility versions” as profile versions with evidence. citeturn0search1 fileciteturn0file0turn0file1  

Which DNA Calc module(s) it informs  
- **File adapters (outside core)**: read/write translation rules and opaque preservation pipeline. fileciteturn0file0turn0file2  
- **Profiles (interop profiles)**: define what “Native/Lowered/Opaque/Rejected” means per part/object-model facet. fileciteturn0file0turn0file1turn0file2  
- Packs: `PACK.interop.roundtrip.opaque` and `PACK.interop.degrade_matrix`. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Establish a “package-preservation contract”: if a part is unknown/unsupported, preserve bytes and relationship integrity, and surface diagnostics rather than dropping content. fileciteturn0file0turn0file1  
- Treat every interoperability claim as an evidence-linked profile statement, upgrading profile versions when semantics change. fileciteturn0file1turn0file2  

Credibility note  
- ECMA International is a recognized standards body; ECMA-376 is a primary source for OOXML. citeturn0search1  

### Office implementation information for ECMA-376 ([MS-OE376], Microsoft Open Specifications) citeturn0search5  
Type: spec/docs

What it teaches us  
- Microsoft publicly documents how Office implements ECMA-376, including known variances/extensions, and signals that updates can occur—critical for “recency-aware” compatibility claims. citeturn0search5  
- The existence of a sanctioned “implementation info” layer supports a clean-room strategy: prefer published implementation notes over speculation. citeturn0search5 fileciteturn0file1  
- Provides a principled way to separate: standard baseline vs Excel/Office-specific behaviors, mapping well onto profiles and feature gates. citeturn0search5 fileciteturn0file0  

Which DNA Calc module(s) it informs  
- **Profiles + profile versions**: Excel-style compatibility versions can cite these documents as admissible evidence inputs. fileciteturn0file0turn0file1  
- **Interop packs**: differential/round-trip behavior and “never silently drop meaning” requirements. fileciteturn0file0turn0file2  

How to apply it (actionable)  
- Create a “source ledger” for each profile claim: ECMA section + MS-OE376 section + harness observation, all linked to REQ/INT/REAL identifiers. fileciteturn0file2turn0file1  
- Add a freshness rule: any MS-OE376-dependent claim must record the document’s last-updated timestamp at the time of stabilization. citeturn0search5 fileciteturn0file2  

Credibility note  
- Microsoft Open Specifications are explicit public compatibility guidance intended for implementers. citeturn0search5  

### Excel (.xlsx) Extensions to SpreadsheetML ([MS-XLSX], Microsoft Open Specifications) citeturn7search0  
Type: spec/docs

What it teaches us  
- Excel defines extensions beyond ISO/IEC OOXML that matter for real-world interoperability. citeturn7search0  
- This is a clean-room-safe path to “Excel-specific” OOXML semantics without reverse-engineering internals. citeturn7search0 fileciteturn0file1  
- Reinforces the need for profile-scoped feature gates and explicit degrade policies for unsupported extensions. citeturn7search0 fileciteturn0file0  

Which DNA Calc module(s) it informs  
- **File adapter interop profile**: extension parsing, preservation, and diagnostics. fileciteturn0file0turn0file2  
- **Profiles and negotiation**: capability manifest must declare which extension families are supported natively vs opaque. fileciteturn0file0turn0file2  

How to apply it (actionable)  
- Build an “extension inventory” per profile: each extension → {Native/Lowered/Opaque/Rejected} with tests and round-trip fixtures. fileciteturn0file0turn0file2  
- Use schema versioning and feature tokens to keep adapters evolvable without breaking engines. fileciteturn0file0turn0file1turn0file2  

Credibility note  
- Microsoft Open Specifications are primary sources for Excel-specific format behavior. citeturn7search0  

### Macro packaging for Office documents ([MS-OFFMACRO2], Microsoft Open Specifications) citeturn7search1  
Type: spec/docs

What it teaches us  
- Macro-enabled workbooks involve explicit/implicit relationships from the workbook part to macro-related parts (VBA project, macro sheets). citeturn7search1  
- The VBA Project part is treated as a constrained binary object in the package, supporting DNA Calc’s “opaque blob + minimal metadata” stance. citeturn7search3 fileciteturn0file0  
- Interop risks are about preserving structure and relationships, not about interpreting VBA internals (clean-room alignment). citeturn7search3 fileciteturn0file1  

Which DNA Calc module(s) it informs  
- **Doc object model**: VBA project blob storage and metadata surface (outside core calc). fileciteturn0file0turn0file1  
- **File adapters**: round-trip semantics for `.xlsm` (and any lowering pipeline) and diagnostic surfaces for “macro present but unsupported.” fileciteturn0file0turn0file2  
- Packs: interop round-trip + degrade matrix; macro preservation pack. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Implement a strict invariant: macro parts are never dropped silently; any removal requires an explicit op + diagnostic + evidence record. fileciteturn0file0turn0file2turn0file1  
- Add “macro integrity” fixtures that ensure the adapter preserves the VBA blob byte-for-byte when not edited. fileciteturn0file0turn0file2  

Credibility note  
- This is a Microsoft-published specification describing macro packaging as implemented in Office formats. citeturn7search1  

### Working with the calculation chain (Open XML docs) citeturn0search4  
Type: docs

What it teaches us  
- The persisted `calculationChain` part records *the order cells were last calculated*, not formula dependency structure. citeturn0search4  
- Therefore, Calc order persistence can be used as a performance/display optimization or diagnostic artifact, not as semantic ground truth. citeturn0search4  
- This distinction aligns with DNA Calc’s “inputs are truth; derived values are caches” doctrine for DocSnapshot/CalcDeltas. fileciteturn0file0  

Which DNA Calc module(s) it informs  
- **File adapters**: how to preserve/export calculation-chain metadata without treating it as authoritative. fileciteturn0file0turn0file2  
- **Profiles**: define whether/how calc-chain artifacts are emitted and validated under deterministic mode. fileciteturn0file0turn0file1  

How to apply it (actionable)  
- Define a profile rule: calc-chain export may be “best-effort,” but must never override dependency graph derivation. citeturn0search4  
- In conformance packs, use calc-chain consistency only as an auxiliary check (e.g., “matches our deterministic schedule output when enabled”), not as a required parity point. fileciteturn0file2turn0file0  

Credibility note  
- Official Open XML documentation that precisely scopes what the calc-chain part does and does not represent. citeturn0search4  

### A Spreadsheet Core Implementation in C# (Sestoft, ITU TR-2006-91) citeturn5search3  
Type: technical report

What it teaches us  
- A concrete, implementable “core spreadsheet” architecture including evaluation strategy, dependency handling, and engineering tradeoffs suitable for experimental systems. citeturn5search3  
- A clean conceptual model for recomputation rooted in dependency structure—useful for oracle design and cross-engine conformance fixtures. citeturn5search3  
- Provides a known starting point for minimal recalculation and structural edit considerations, consistent with DNA Calc’s pipeline framing. fileciteturn0file0turn0file3  

Which DNA Calc module(s) it informs  
- **Calc engine pipeline**: parse/bind/graph/invalidate/evaluate/commit phases and deterministic trace emission. fileciteturn0file0turn0file2  
- **Oracle + packs**: good substrate for OCaml reference behavior and fixture generation. fileciteturn0file0turn0file2  

How to apply it (actionable)  
- Use it as a “design comparator”: every planned optimization (incremental recompute, graph compaction, stable IDs) should be documented as a delta against a known baseline architecture. citeturn5search3  
- Extract a minimal set of canonical test scenarios (dependency fan-out, structural insert rewrite, volatile-like triggers) and encode them into `PACK.visicalc.core`. fileciteturn0file2turn0file0  

Credibility note  
- University technical report by a leading spreadsheet implementation researcher, with code-centric focus suitable for clean-room engineering. citeturn5search3  

### HyperFormula dependency graph + volatility model citeturn5search0turn15search17  
Type: docs/repo

What it teaches us  
- A modern, documented approach to building and updating a spreadsheet dependency graph to compute correct and performant evaluation orders. citeturn5search0  
- A crisp model of volatile functions as “recalculate on volatile actions,” plus a practical list of built-in volatile examples (RAND/NOW/TODAY). citeturn15search17  
- How a headless engine productizes incremental updates, CRUD operations, and operational surfaces (even if semantics differ from Excel). citeturn18search0  

Which DNA Calc module(s) it informs  
- **Calc engine (DocSnapshot/CalcDeltas)**: practical data structures for dependency maintenance and incremental recompute. fileciteturn0file0turn0file3  
- **Profiles**: scoping volatile semantics and defining what triggers recomputation. fileciteturn0file0turn0file1  
- Packs: comparison-driven tests for “graph maintenance under edits” and “volatile trigger semantics,” plus regression fixtures. fileciteturn0file2turn0file1  

How to apply it (actionable)  
- Borrow the *documentation shape* (clear definitions + examples) as a template for profile docs, while keeping DSL semantics independent and Excel-targeted. citeturn5search0turn15search17  
- Use it as a “negative space” checklist: explicitly decide which constructs are out-of-scope for Pathfinder, and encode those as `Rejected/Opaque` behaviors rather than accidental gaps. fileciteturn0file0turn0file2turn0file1  

Credibility note  
- Publicly documented open-source engine with clear dependency-graph and volatility explanations, suitable for idea transfer without relying on proprietary internals. citeturn5search0turn18search0  

### Apache POI formula evaluation (Apache POI docs) citeturn5search1turn5search9  
Type: docs/repo docs

What it teaches us  
- Excel files store cached results for formulas, so display/loading behavior can rely on cached values even when an engine is not recalculating—important for DNA Calc’s cache/derived-value posture. citeturn5search1  
- Practical realities of partial function support and extension points for adding functions at runtime, which mirrors the need for feature gates and degrade classes. citeturn5search9  
- A real-world example of separating “file IO representation” from “evaluation engine,” aligned with DNA Calc’s adapter boundary. citeturn5search1 fileciteturn0file0  

Which DNA Calc module(s) it informs  
- **File adapters**: how cached values and formula storage appear in the wild, and what round-trip preservation implies. fileciteturn0file0turn0file2  
- **Degrade policy**: clear patterns for “not implemented” and safe failure modes. citeturn5search9 fileciteturn0file0turn0file2  

How to apply it (actionable)  
- Ensure your adapter contract distinguishes: (a) stored cached values, (b) derived computed values, and (c) “stale/pending” UI status—never conflating them. citeturn5search1 fileciteturn0file0  
- Treat function support gaps as profile-gated: unsupported functions become deterministic errors or opaque, never crashes. citeturn5search9 fileciteturn0file0turn0file1  

Credibility note  
- Apache POI is a long-standing, widely used library with detailed formula evaluation documentation based on actual Excel file behaviors. citeturn5search1  

### Specifying Systems (TLA+) (Lamport) citeturn14search10turn14search0  
Type: book (PDF)

What it teaches us  
- How to specify state machines and temporal properties in TLA+ and how to connect specs to model checking and proofs. citeturn14search0turn14search10  
- How to structure invariants and reason about concurrency and protocol correctness in a way that maps directly to DNA Calc’s epoch lattice and exclusivity rules. citeturn14search0 fileciteturn0file0  
- A foundation for building “PACK.concurrent.epochs” with TLC/Toolbox-driven counterexample capture. citeturn14search2turn14search7  

Which DNA Calc module(s) it informs  
- **Epoch model + coordinator**: no-stale-commit, snapshot pinning, exclusive structural edits, deterministic signaling. fileciteturn0file0turn0file2  
- **Packs**: model-checking gate definitions, counterexample trace archiving, and tiered configurations. fileciteturn0file2turn0file3  

How to apply it (actionable)  
- Start with a small TLA+ model that encodes: committed/stabilized epochs, value epochs, and a “no stale commit” invariant; then add external update ops and structural-edit exclusivity. fileciteturn0file0turn0file2  
- Require that every failed model check produces an artifact bundle that the trace minimizer can ingest. fileciteturn0file2turn0file1  

Credibility note  
- Primary source by the creator of TLA+, widely used in industry and academia, with official distribution. citeturn14search10  

### Apalache documentation (symbolic model checking for TLA+) citeturn2search1turn18search3  
Type: tool docs

What it teaches us  
- Apalache checks TLA+ specs using SMT-style encodings (e.g., via Z3), enabling bounded checking and inductive invariant workflows that complement TLC. citeturn18search3turn18search11  
- Helps scale certain verification tasks by using symbolic methods rather than purely explicit-state exploration. citeturn2search1  
- Expands the “pack menu”: model-check tiers can mix TLC and Apalache depending on state-space characteristics. citeturn18search11  

Which DNA Calc module(s) it informs  
- **TLA+ verification toolchain**: `PACK.concurrent.epochs` tier design (fast bounded checks vs deeper exhaustive runs). fileciteturn0file2turn0file0  
- **Artifact discipline**: standardized model configs and trace outputs for CI gating and archival. fileciteturn0file2turn0file1  

How to apply it (actionable)  
- Define pack tiers: “TLC quick smoke,” “Apalache bounded safety,” and “TLC deeper exploration,” each with frozen configs per profile. citeturn14search2turn18search11  
- Add a rule that any spec change touching epochs/stream ops triggers at least one Apalache run in CI due to its speed advantage on some classes of invariants. citeturn2search1 fileciteturn0file2  

Credibility note  
- Official project documentation for a widely referenced TLA+ model checking tool, with explicit methods and limitations. citeturn2search1turn18search3  

### Theorem Proving in Lean 4 (Lean community) citeturn2search0turn2search4  
Type: docs/book

What it teaches us  
- Practical foundations for writing definitions, theorems, and proofs in Lean 4, including tactics and structuring proof development. citeturn2search0turn2search4  
- Establishes the proof-engineering baseline for DNA Calc’s semantics proof obligations and structural rewrite lemmas. fileciteturn0file0turn0file3  
- Provides a shared vocabulary for cross-team proof review and for proving “determinism” properties where feasible. citeturn2search0 fileciteturn0file1  

Which DNA Calc module(s) it informs  
- **Lean semantics stack**: `PACK.lean.ocaml.alignment.core`, semantics proofs for Pathfinder DSL, structural rewrite lemma packs. fileciteturn0file2turn0file0  
- **Profiles**: formal semantics become profile-defining artifacts (semantics spine). fileciteturn0file1turn0file0  

How to apply it (actionable)  
- Start by defining the Round 0 formula subset as an inductive AST + evaluation relation; then prove a small set of “disruptive structural rewrite” lemmas that match the chosen rewrite path. fileciteturn0file0turn0file2  
- Treat oracle results as a parameterized interpretation where needed (external UDFs/STREAM), matching the architecture’s “pure oracle” stance. fileciteturn0file0turn0file2  

Credibility note  
- Official Lean 4 learning material maintained by core community members and linked from Lean infrastructure. citeturn2search0turn2search4  

### Simplifying and Isolating Failure-Inducing Input (Delta Debugging) citeturn11search0  
Type: paper (PDF)

What it teaches us  
- `ddmin`-style reduction to automatically find minimal failure-inducing inputs, aligning with “minimized traces/cases.” citeturn11search0  
- A model for turning regressions into durable artifacts that shrink over time and remain replayable. citeturn11search0 fileciteturn0file2turn0file1  
- A principled basis for separating “diagnostic noise” from essential failure conditions—critical when dealing with concurrency traces and nondeterminism. citeturn11search3 fileciteturn0file0  

Which DNA Calc module(s) it informs  
- **OCaml oracle + trace toolchain**: trace minimizer design and artifacts. fileciteturn0file0turn0file2  
- **Operations doctrine**: “regressions are assets,” one-command readiness, and pack-driven minimization gates. fileciteturn0file2turn0file1  

How to apply it (actionable)  
- Standardize a trace format that can be deterministically replayed across Red/Blue/oracle, then apply ddmin to shrink op sequences and timing envelopes for stream/concurrency cases. fileciteturn0file2turn0file0  
- Treat “minimizer success” as a gate: no bug is closed until a minimized trace is in the corpus. fileciteturn0file2turn0file1  

Credibility note  
- Canonical, widely cited paper introducing delta debugging as a general-purpose reduction algorithm. citeturn11search0  

### MVCC + Snapshot Isolation references (PostgreSQL + Berenson et al.) citeturn3search0turn3search3  
Type: docs/paper

What it teaches us  
- MVCC explains how concurrent readers can observe consistent snapshots without blocking writers—conceptually aligned with DNA Calc epoch snapshot pinning. citeturn3search0 fileciteturn0file0  
- Snapshot isolation is precisely defined and known to have nuanced anomaly tradeoffs, sharpening what DNA Calc must and must not promise under concurrency. citeturn3search3  
- Provides a mature vocabulary for specifying isolation, visibility, and monotonic status rules (pending→ready) as invariants. citeturn3search0turn3search3 fileciteturn0file0  

Which DNA Calc module(s) it informs  
- **Epoch/MVCC model**: committed vs stabilized epoch semantics, snapshot reads, and GC/pinning policy framed formally. fileciteturn0file0turn0file3  
- **Concurrency packs**: invariants and counterexamples (e.g., avoiding stale commits). fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Define a precise “spreadsheet snapshot isolation” model: what a pinned snapshot guarantees about value visibility, stale markers, and “eventual stabilization.” fileciteturn0file0turn0file2  
- Use MVCC anomaly taxonomy as inspiration for adversarial test scenarios (concurrent update streams + structural edit exclusivity). citeturn3search3 fileciteturn0file0turn0file2  

Credibility note  
- PostgreSQL docs are authoritative practitioner references; Berenson et al. is a classic formalization of snapshot isolation and isolation-level ambiguities. citeturn3search0turn3search3  

### Collaboration foundations: CRDT + OT + deterministic log ordering citeturn1search3turn13search2turn4search3  
Type: papers/specs (PDF + docs)

What it teaches us  
- CRDTs formalize strong eventual consistency and convergence conditions (useful for evaluating “share doc vs share oracle values” collaboration choices). citeturn1search3 fileciteturn0file0turn0file3  
- OT documents intention/casuality/convergence concerns and provides a long history of practical co-editing constraints. citeturn13search2  
- Raft explains why a **server-sequenced replicated log** simplifies systems via a strong leader and ordered log replication—matching DNA Calc’s initial “server-sequenced OpLog” preference. citeturn4search3 fileciteturn0file0turn0file3  

Which DNA Calc module(s) it informs  
- **Collaboration seam**: OpLog replication envelope (idempotency, ordering metadata, transaction grouping). fileciteturn0file0turn0file2  
- **Profiles**: collaboration capability negotiation (single-writer vs multi-writer), and oracle value policy (local vs shared). fileciteturn0file0turn0file1turn0file3  
- Packs: `PACK.collab.replication.core` and any “structural edits under replication” pack. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Start with deterministic, server-sequenced OpLog replication and prove correctness under that model; push CRDT/OT exploration behind a feature gate/profile version. citeturn4search3turn1search3 fileciteturn0file0turn0file1  
- Require stable object/cell identity design when structural edits exist; otherwise replication + reference rewriting becomes untestable. fileciteturn0file3turn0file0  

Credibility note  
- CRDT and Raft are heavily cited primary sources; the Wave OT writeup is a rare, public engineering artifact on OT operation. citeturn1search3turn4search3turn13search2  

### UI at scale: Canvas grid + IME/clipboard + WebView substrate citeturn1search1turn8search0turn8search1turn1search0  
Type: repo + standards + platform docs

What it teaches us  
- Canvas-based grids can support very large datasets with “no DOM-per-cell,” matching DNA Calc’s intended UI architecture. citeturn1search1 fileciteturn0file0turn0file3  
- IME correctness and text editing require careful handling of standardized input events (beforeinput/input/composition), suggesting a DOM overlay editor is a necessity, not a preference. citeturn8search0 fileciteturn0file0  
- Clipboard interoperability is standards-defined and should be treated as a testable contract (copy/cut/paste hooks), not ad-hoc. citeturn8search1  
- Tauri’s system WebView dependency means platform differences can affect behavior; it documents WebView2’s update model and per-platform WebView usage. citeturn1search0turn1search16  

Which DNA Calc module(s) it informs  
- **UI reducer / RenderPlan IR**: deterministic UI testing strategy and geometry/hit-test invariants. fileciteturn0file0turn0file2  
- **Profiles**: UI behavior profiles may need to include “WebView substrate class” as a capability dimension. citeturn1search0turn1search16 fileciteturn0file0turn0file1  
- Packs: `PACK.ui.viewport` plus IME/clipboard packs. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Implement a RenderPlan-based test harness that validates geometry/hit-test invariants and applies deterministic input-event scripts (including IME sequences) across WebView targets. citeturn8search0turn1search0 fileciteturn0file2turn0file0  
- Treat clipboard and IME as “profile-gated obligations”: you’re compliant only when the pack passes for the declared WebView substrate. fileciteturn0file2turn0file1turn0file0  

Credibility note  
- Glide Data Grid is a real, inspectable implementation; W3C specs and Tauri official docs define the platform contracts. citeturn1search1turn8search0turn1search0  

### Design-for-evolution: SemVer + capability negotiation patterns citeturn4search2turn9search20turn9search8  
Type: spec + RFC + docs

What it teaches us  
- SemVer provides a well-known contract for how versions convey compatibility expectations, useful for profile versions and protocol surface versions. citeturn4search2 fileciteturn0file1turn0file0  
- RFC 2703 describes a general framework for expressing sender/receiver capabilities and negotiating parameters, matching DNA Calc’s capability negotiation requirement. citeturn9search20 fileciteturn0file0  
- Protobuf’s documentation offers concrete rules for forward/backward compatibility in schema evolution, useful as inspiration for IDL/schema discipline. citeturn9search8 fileciteturn0file2turn0file0  

Which DNA Calc module(s) it informs  
- **Protocol surface**: negotiation schema design and versioning strategy across Red/Blue engines and adapters. fileciteturn0file0turn0file1turn0file2  
- **Profiles + feature gates**: semantics spine and compatibility bump discipline. fileciteturn0file1turn0file0  
- Packs: “schema/negotiation conformance pack” and “graceful degradation matrix” packs. fileciteturn0file2turn0file0  

How to apply it (actionable)  
- Treat `profile_id + profile_version` as SemVer-like, then explicitly define what constitutes a breaking change in semantics vs in protocol surface. citeturn4search2 fileciteturn0file1turn0file0  
- Create a negotiation handshake that: (1) advertises supported versions/capabilities, (2) selects a mutually compatible profile, and (3) produces a machine-readable manifest included in every conformance report. citeturn9search20 fileciteturn0file2turn0file0  

Credibility note  
- SemVer and RFCs are canonical in software compatibility practice; Protobuf docs are a widely adopted, field-tested schema evolution reference. citeturn4search2turn9search20turn9search8  

## Steal This Pattern

1) **Treat the OpLog as the single source of truth; derive everything else.** Event sourcing’s “state is rebuilt by replaying events” matches the OpLog → snapshot discipline and makes replay/minimization first-class. citeturn4search1 fileciteturn0file0turn0file1

2) **Make “dependency discovery” and “execution order” two different artifacts.** Excel’s dependency tree vs calculation chain separation is a clean-room blueprint; persist last-known order as a cache, never as semantics. citeturn0search0turn0search4

3) **Explicit stale/pending status is part of the API contract, not UI decoration.** DNA Calc’s value_epoch + stale markers become enforceable once treated like MVCC visibility rules and validated by packs. citeturn3search0 fileciteturn0file0turn0file2

4) **Encode thread-safety as an enforceable callable-surface restriction.** Excel’s XLL docs show a hard rule: declaring thread-safe changes what you’re allowed to call; model this as a capability token + enforced traps. citeturn0search2turn0search18

5) **Model streaming updates as operations plus replay bundles.** RTD’s topic lifecycle provides the observable hooks; represent updates as explicit ops with ordering/dedupe/coalescing policies and maintain a replay envelope. citeturn0search3turn0search7 fileciteturn0file0turn0file2

6) **Preserve unknown OOXML parts byte-for-byte whenever feasible.** OOXML’s part/relationship model supports this; MS implementation notes + extension specs help decide what must be understood vs kept opaque. citeturn0search1turn0search5turn7search0 fileciteturn0file1turn0file0

7) **Treat macros as opaque packaging, not language semantics.** Macro packaging specs define how VBA project connects to the workbook; preserving the blob meets fidelity requirements without interpreting VBA. citeturn7search1turn7search3 fileciteturn0file0turn0file1

8) **Use TLA+ to lock down “no stale commit” and exclusivity windows early.** Encode invariants now, archive counterexamples, and gate stabilization on model checks. citeturn14search10turn14search2turn2search1 fileciteturn0file2turn0file0

9) **Use an SMT-backed checker (Apalache) as a “fast lane” for protocol iteration.** Bounded checks and inductive invariant workflows can keep cycle time low while preserving rigor. citeturn18search3turn18search11 fileciteturn0file2turn0file3

10) **Turn every regression into a minimized, replayable artifact.** Delta Debugging provides the algorithmic core; enforce as a gate in operations doctrine. citeturn11search0 fileciteturn0file2turn0file1

11) **Design UI editing around web standards, not browser quirks.** IME and clipboard have explicit W3C contracts; build deterministic test scripts against them and run across the WebView substrates you claim to support. citeturn8search0turn8search1turn1search0 fileciteturn0file2turn0file0

12) **Adopt “canvas grid + DOM overlay editor” as a proven performance/UX split.** Canvas grids can scale; DOM overlay handles IME/selection/clipboard. Glide Data Grid is a strong “it works in practice” reference. citeturn1search1turn8search0 fileciteturn0file0turn0file3

13) **Start collaboration with a deterministic, server-sequenced log.** A replicated log with a single ordering authority simplifies correctness claims; CRDT/OT remains possible behind a profile/version gate. citeturn4search3turn1search3 fileciteturn0file0turn0file3turn0file1

14) **Treat profiles as “semantic major versions” with capability negotiation.** SemVer-style expectations plus explicit negotiation (RFC-style) reduce accidental breaking changes and make degrade policies auditable. citeturn4search2turn9search20 fileciteturn0file1turn0file0

## Risk Retirement Table

| Risk drawn from the docs | Why it matters | Sources / patterns that retire it | Packs / profile levers |
|---|---|---|---|
| Determinism under parallelism (float reduction order, schedule nondeterminism) fileciteturn0file0turn0file3 | Cross-engine parity and minimized regressions become impossible if outcomes depend on race/order | Excel’s recalc model + MTR constraints; make deterministic mode explicit; model-check invariants with TLA+; enforce minimized traces via delta debugging citeturn0search0turn0search12turn14search10turn11search0 | Profile-defined numeric reduction policy; deterministic scheduler mode; `PACK.concurrent.epochs`; `PACK.scaling.signature`; trace minimizer gate fileciteturn0file2turn0file0 |
| “No stale commit” invariant violations (values committed against wrong epoch) fileciteturn0file0 | User trust and snapshot consistency break; collaboration replication becomes inconsistent | TLA+ invariants (Specifying Systems + TLC/Toolbox) + Apalache fast checks citeturn14search10turn14search2turn18search11 | `PACK.concurrent.epochs` + archived counterexamples; epoch-lattice spec locked per profile fileciteturn0file2turn0file0 |
| Structural edits overlapping with other mutations (exclusive mutation discipline) fileciteturn0file0turn0file3 | Reference rewriting correctness, replay determinism, and UI coherence all depend on atomic transforms | Encode exclusivity in TLA+ and in OpLog transaction schema; use Corecalc-era structural reasoning as baseline citeturn14search10turn5search3 | Exclusive mutation op type; `PACK.structural.insert` and concurrency-integration tests fileciteturn0file2turn0file0 |
| STREAM/RTD ordering + dedupe ambiguity fileciteturn0file0turn0file3 | External updates become irreproducible; collaboration policy unclear | RTD lifecycle contract; represent updates as explicit ops + replay bundles; pack ordering/dedupe behavior citeturn0search3turn0search7 | `stream_semantics_version`; `PACK.stream.basic`; stream replay bundle required artifact fileciteturn0file2turn0file0 |
| XLL/UDF thread-safety violations (deadlocks, illegal callbacks) fileciteturn0file0turn0file3 | Causes crashes, nondeterminism, or silent wrong results under MTR | XLL docs define enforceable restrictions; separate thread-safe vs serialized lanes; trap forbidden callbacks citeturn0search2turn0search14turn0search18 | `FG_UDF_THREADSAFE`; `PACK.udf.basic`; later full XLL marshalling pack fileciteturn0file2turn0file0 |
| Macro blob loss/corruption on round-trip (.xlsm fidelity) fileciteturn0file0turn0file1 | Breaks file fidelity claims; violates “never silently drop meaning” | Macro packaging specs + adapter invariant “preserve blob if not edited” citeturn7search1turn7search3 | `PACK.interop.roundtrip.opaque` + macro integrity fixtures; degrade policy: Opaque vs Rejected fileciteturn0file2turn0file0 |
| Unsupported OOXML parts dropped silently fileciteturn0file0turn0file1 | Data loss and broken compatibility claims | ECMA-376 packaging model + MS implementation notes + explicit degrade classes citeturn0search1turn0search5 | `PACK.interop.roundtrip.opaque` + `PACK.interop.degrade_matrix`; profile export lowering pipeline spec fileciteturn0file2turn0file0 |
| UI correctness non-testable at scale (hit-test/geometry drift, screenshot brittleness) fileciteturn0file0turn0file2 | UI regressions become subjective; performance optimizations become risky | RenderPlan determinism + geometry invariants; follow W3C input/clipboard semantics; canvas grid architecture reference citeturn8search0turn8search1turn1search1 | `PACK.ui.viewport`; WebView substrate as capability dimension (Tauri docs) citeturn1search0 fileciteturn0file2turn0file0 |
| Collaboration semantics explode (structural edits + replication + references) fileciteturn0file0turn0file3 | Multi-writer behavior becomes ambiguous; deterministic replay breaks | Start with server-sequenced oplog (Raft-style ordering concept); keep CRDT/OT behind profile gates; require stable IDs citeturn4search3turn1search3turn13search2 | `PACK.collab.replication.core`; profile gates for multi-writer; explicit identity strategy fileciteturn0file2turn0file0 |
| “Agentic coding weather” destabilizes processes (packs bypassed, artifacts drift) fileciteturn0file2turn0file3 | Without discipline, specs and engines diverge and “green” becomes meaningless | Enforce one-command readiness, computed obligation closure, and minimized regressions as gates; Delta Debugging provides a reduction backbone citeturn4search1turn11search0 | `meta check` gating; pack resolver closure; regression corpus required; Green veto discipline fileciteturn0file2turn0file1 |

## Gaps and Follow-up Queries

Some requirements in the docs are *architecturally clear* but still underspecified at the level needed to build clean-room conformance packs; these are the highest-value gaps for a second research run. fileciteturn0file0turn0file2turn0file3

**Gaps / ambiguities that remain**  
- **Exact Excel-compatibility surface for Round 0 profiles**: which functions/operators, what error semantics, what coercion rules, and what “compatibility versions” are targeted first. fileciteturn0file0turn0file3  
- **RTD lifecycle timing and threading details** that are observable (call ordering, reconnection behavior, update coalescing) and should become OpLog ordering/dedupe rules. fileciteturn0file0turn0file2  
- **XLL marshalling and lifetime contracts** for later rounds: what minimum subset can be specified now so that Pathfinder doesn’t paint the architecture into a corner. fileciteturn0file0turn0file3  
- **OOXML “preserve unknown parts” edge cases**: encryption, signatures, custom parts, embedded objects—what preservation guarantees are realistic under adapters. fileciteturn0file0turn0file2  
- **UI input fidelity** across WebViews: IME sequences, clipboard formats, and key event handling differences that should split UI profiles/capabilities. fileciteturn0file0turn0file2  
- **Collaboration identity model under structural edits**: stable IDs vs address-based identity and how reference rewriting composes with replication. fileciteturn0file3turn0file0  

**Exact search queries for Run 2**  
- “Excel RTD IRtdServer RefreshData timing call order ConnectData DisconnectData Heartbeat Threading Model”  
- “Excel XLL XLOPER12 memory ownership lifetime xlAutoOpen xlAutoClose thread safety restrictions xlretNotThreadSafe”  
- “MS-OFFMACRO2 vbaProject relationship type workbook part implicit relationship vba supplemental data vbaData.xml”  
- “MS-XLSX extensions list extLst workbook worksheet relationships compatibility behaviors”  
- “Excel calculation mode manual automatic dependency tree calculation chain volatile xlfVolatile behavior”  
- “Tauri WebView2 WKWebView WebKitGTK input events composition clipboard limitations February 2026”  
- “Spreadsheet collaboration structural edits stable identifiers reference rewriting op-log replication deterministic sequencing”  
- “TLA+ model checking patterns MVCC snapshot pinning cancellation invariants”  
- “Lean 4 small-step semantics determinism proof strategy for expression language + reference resolution”  

## Recommended Follow-up Deep Research Runs

- **Run 2 — Excel Interop Deep Dive (OOXML + macros + calc metadata + degrade matrix)**  
  Prompt focus: build a profile-scoped interoperability spec referencing ECMA-376 + Microsoft Open Specifications ([MS-OE376], [MS-XLSX], [MS-OFFMACRO2]) and produce a concrete “Native/Lowered/Opaque/Rejected” matrix with required round-trip fixtures. citeturn0search1turn0search5turn7search0turn7search1 fileciteturn0file0turn0file2turn0file1

- **Run 3 — Concurrency Protocol Verification (epochs, scheduling, external updates, deterministic replay)**  
  Prompt focus: write a TLA+ model plan (variables, actions, invariants) for committed/stabilized epochs, external update ops, exclusive mutation windows, and snapshot pinning; define TLC/Apalache tiered pack gates and artifact formats for counterexample minimization. citeturn14search10turn14search2turn18search11turn2search1 fileciteturn0file0turn0file2

- **Run 4 — Collaboration Semantics for Spreadsheets (op-log replication, structural edits, IDs, OT/CRDT evaluation)**  
  Prompt focus: compare “server-sequenced log” vs CRDT/OT approaches specifically under spreadsheet structural edits and reference rewriting; propose an operation schema and idempotency/causality envelope plus a first conformance pack (`PACK.collab.replication.core`) and test corpus strategy. citeturn4search3turn1search3turn13search2 fileciteturn0file0turn0file3turn0file2