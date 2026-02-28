# Pass 17 - Follow-up Execution Backlog and Empirical Validation Plan

## Completeness statement
This backlog is the consolidated follow-up list from the full run output set. It is comprehensive relative to the current artifacts and contains no known blind-spot omissions from the run itself.

Backlog sources consolidated here:
- `research_index.md` (known-and-documented unknowns)
- `03_gap_closure_response.md` (remaining top unknowns)
- `06_tier5_semantics_response.md` (tier-5 unresolveds)
- `07_coercion_matrix_response.md` and `09_coercion_matrix_expansion_response.md` (coercion unknowns)
- `08_tier4_family_semantics_response.md` (tier-4 unresolveds)
- `10_formula_language_guide.md`, `13_table_semantics_guide.md`, `14_formatting_guide.md`, `15_version_platform_guide.md`
- `EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md` (intentional open work)

## Recommended execution model
Use two coordinated tracks:
- Track A (documentation and source synthesis): continue in this research run directory to keep continuity of source maps and known-unknown closure.
- Track B (empirical Excel conformance probes): start a dedicated run series (`excel-compat-empirical-pass-*`) because it will generate large machine artifacts, probe workbooks, harness scripts, and replay bundles with a different cadence.

This split keeps narrative and source curation readable while allowing large empirical pipelines to run continuously without bloating the documentation pass history.

## Structured execution list

### ECS-BL-01 - Empirical harness foundation and artifact contract (Priority P0)
Reference anchors: `EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md` (empirical corpus open), `08_tier4_family_semantics_response.md` (formal test corpus needed), `15_version_platform_guide.md` (platform caveat behavior).

Scope and expectation:
Define one stable empirical harness contract before deep semantic passes continue. The harness should accept scenario manifests, drive Excel automatically, capture observable sheet-level behavior, normalize outputs, and emit replayable evidence bundles. This is the enabling dependency for almost every remaining backlog item.

Expected outputs:
Deliver a manifest schema (`scenario_id`, workbook fixture, formula set, preconditions, operation sequence, calc mode, expected observation fields), runner adapters, and normalized observation schema. Include deterministic capture rules for values, errors, spills, formats, table expansions, and recalc-trigger outcomes.

Validation against Excel:
Primary automated lane should be Windows Excel Desktop via COM/VBA automation because it supports the broadest observable worksheet behavior. Add secondary probe lanes for web/Mac where feasible; record unsupported probes explicitly rather than dropping them. Every probe should emit raw capture, normalized capture, and a reproducible re-run command.

Prompt-ready brief:
Build the empirical harness contract and first runnable adapter set for Excel worksheet compatibility probes. Produce schemas, sample scenarios, runner commands, and one full evidence bundle example with deterministic replay instructions.

### ECS-BL-02 - Full per-function edge-case semantics matrix (500 functions) (Priority P0)
Reference anchors: `research_index.md` unknowns 1 and 5, `03_gap_closure_response.md` unknown 1, `EXCEL_COMPATIBILITY_RESEARCH_MASTER_GUIDE.md` open work.

Scope and expectation:
Expand from index-level coverage to function-level semantic detail for the entire catalog. For each function, capture argument typing/coercion behavior, error propagation, array lifting rules, volatility notes, and compatibility/version caveats. This is the core compatibility inventory needed for implementation-grade parity planning.

Expected outputs:
Produce a machine-readable matrix keyed by function name and scenario class, with evidence link(s), confidence, and unresolved markers. The matrix should separate documented behavior from empirically observed behavior and preserve source attribution at row level.

Validation against Excel:
Generate scenario templates per function family (numeric/text/date/reference/array/context-sensitive). Execute template packs through the empirical harness, then add function-specific edge probes where mismatches or unknowns remain. Track coverage percentage and unresolved count as explicit metrics.

Prompt-ready brief:
Create and populate a complete per-function semantic matrix for all worksheet functions, with evidence-backed rows, unresolved flags, and automated probe plans that can be replayed in Excel.

### ECS-BL-03 - Definitive volatility and recalc-trigger atlas (Priority P0)
Reference anchors: `research_index.md` unknown 2, `01_landscape_response.md` volatility gap notes, `06_tier5_semantics_response.md` recalculation details.

Scope and expectation:
Build a definitive map of volatility and recalculation triggers at function and context level. This includes always-volatile behavior, argument-conditional volatility, and externally invalidated behavior patterns that matter for scheduling and dependency invalidation semantics.

Expected outputs:
Produce a volatility atlas with reason codes, trigger classes, and source/evidence references. Include distinctions between function recalc on worksheet calculation, event-driven external updates, and context-dependent cases (for example functions whose volatility depends on arguments or environment).

Validation against Excel:
Automate controlled recalc experiments across manual/automatic modes and operation sequences (edit unrelated cell, structural edit, full recalc command, reopen workbook). Capture whether target formulas change or remain stable under each trigger path and platform.

Prompt-ready brief:
Construct a definitive volatility and recalculation-trigger atlas for Excel worksheet functions, backed by reproducible probe scenarios and explicit reason codes.

### ECS-BL-04 - Tier-5 unresolved behavior closure (INDIRECT/OFFSET/RTD/NOW/TODAY) (Priority P0)
Reference anchors: `06_tier5_semantics_response.md` known unknowns, `12_value_types_guide.md` date-system linkage, `15_version_platform_guide.md` external/platform caveats.

Scope and expectation:
Close the highest-risk unresolveds for tier-5 functions with formalized scenarios and empirical evidence. Focus on dependency tracking under structural edits (`INDIRECT`, `OFFSET`), RTD lifecycle behavior, and date-system interactions for `NOW`/`TODAY` including cross-workbook copy/paste.

Expected outputs:
Publish a tier-5 closure report with scenario matrix, observed outcomes, divergence notes by platform/version, and confidence tags. Include explicit statements for behavior not automatable in non-Windows environments.

Validation against Excel:
Use structured operation scripts: create baseline workbook, apply row/column insert/delete and name/reference mutations, toggle calc mode, simulate RTD registration availability transitions, and switch date systems. Capture value, dependency impact, and recalculation timing markers.

Prompt-ready brief:
Run a tier-5 closure pass to resolve unresolved compatibility semantics for `INDIRECT`, `OFFSET`, `RTD`, `NOW`, and `TODAY` with operation-sequence probes and evidence bundles.

### ECS-BL-05 - Tier-4 and tier-3 interesting-function deep semantics (Priority P0)
Reference anchors: `research_index.md` unknown 5, `08_tier4_family_semantics_response.md` known unknowns, `11_function_catalog_guide.md` tier model.

Scope and expectation:
Deepen semantics for non-tier-5 interesting functions in a priority order: dynamic arrays and spill-shape functions, functional/LAMBDA helpers, CUBE family worksheet behavior, then external-data functions. Tier-3 should follow once tier-4 unknowns are materially reduced.

Expected outputs:
Deliver family-level semantic specs plus function-level edge-case tables for interesting sets, each with confidence and evidence references. Keep MDX internals out of scope while still documenting CUBE worksheet-visible behavior and connector prerequisites.

Validation against Excel:
Automate mixed-type array inputs, spill-blocking layouts, structured-reference intersections, and helper-function lambda invocation patterns. For CUBE/external-data families, include environment capability detection and classify not-testable conditions explicitly.

Prompt-ready brief:
Execute deep semantic passes for tier-4 and tier-3 interesting functions with family-first ordering, per-function edge-case artifacts, and automated probe coverage.

### ECS-BL-06 - Coercion truth tables and compatibility-version interactions (Priority P0)
Reference anchors: `07_coercion_matrix_response.md` unknowns, `09_coercion_matrix_expansion_response.md` low-confidence notes, `10_formula_language_guide.md` coercion formalization gap.

Scope and expectation:
Complete coercion truth tables across operator contexts, key function families, locale-sensitive parsing cases, and compatibility-version interactions. This backlog item should explicitly target current low-confidence regions in the expanded matrix.

Expected outputs:
Produce a normalized coercion truth-table dataset with dimensions for operand type, context, locale, compatibility setting, and observed outcome. Distinguish documented assertions from empirical-only observations and add confidence and replication metadata.

Validation against Excel:
Run locale-parameterized probe packs (for example decimal separators, date text parsing), dynamic-array mixed-type tests, and nested-expression precedence tests under multiple compatibility settings where available. Record both formula-result and error-code behavior.

Prompt-ready brief:
Expand the coercion matrices into a complete, evidence-tagged truth-table set across locales, compatibility settings, and mixed-type array contexts, with automated Excel probes.

### ECS-BL-07 - Formula language formal mapping for modern constructs (Priority P1)
Reference anchors: `10_formula_language_guide.md` known unknowns, `03_gap_closure_response.md` grammar coverage notes.

Scope and expectation:
Map modern formula constructs (dynamic array operators, lambda/helper expressions, structured references, new function forms) to the best available formal/public grammar anchors. Where no stable formal anchor exists, document a provisional grammar fragment with uncertainty tags.

Expected outputs:
Deliver a grammar mapping dossier that separates authoritative grammar artifacts from inferred extensions. Include open points requiring empirical disambiguation and link those points to probe scenarios.

Validation against Excel:
Use parse-acceptance probe workbooks and controlled formula variants to validate ambiguous grammar boundaries (accepted vs rejected syntax, normalization in formula bar, and recalculation behavior on accepted forms).

Prompt-ready brief:
Create a formal mapping dossier for modern Excel formula syntax, distinguishing authoritative grammar from provisional inferred grammar and linking ambiguities to empirical parse probes.

### ECS-BL-08 - Conditional formatting precedence and overlap semantics (Priority P1)
Reference anchors: `03_gap_closure_response.md` unknown 3, `14_formatting_guide.md` known unknowns.

Scope and expectation:
Extract and formalize conditional-format evaluation order and conflict resolution semantics, including overlapping ranges, rule priority edits, stop-if-true behavior, and interactions with table expansion and spills.

Expected outputs:
Produce a conditional-format semantics matrix and a formalized rule-evaluation model at worksheet-observable level. Include explicit uncertainty tags for aspects that remain implementation-defined or platform-variant.

Validation against Excel:
Automate multi-rule workbooks with controlled overlapping targets and deterministic input changes. Capture resulting displayed formats and rule-manager state after each operation sequence, then compare against expected precedence model.

Prompt-ready brief:
Build a formal worksheet-visible model of conditional-format precedence and overlaps, backed by automated overlap-rule probes and reproducible evidence artifacts.

### ECS-BL-09 - Table/ListObject interaction matrix (Priority P1)
Reference anchors: `13_table_semantics_guide.md` known unknowns, `14_formatting_guide.md` spill/table interaction unknowns, `08_tier4_family_semantics_response.md` spill+structured-reference test-corpus need.

Scope and expectation:
Define table semantics at interaction depth: structured references with spills, coercion contexts, formatting propagation, auto-expand/auto-fill behavior, and dependency impacts of table growth/shrink operations.

Expected outputs:
Produce an interaction matrix and scenario catalog for table behavior under formula, format, and structure operations. Include platform/channel caveat markers and explicit unresolveds.

Validation against Excel:
Automate table mutation sequences (row append, column add, rename, resize), with formulas inside and outside tables referencing structured refs and spilled arrays. Capture formula rewrites, result changes, format changes, and any blocked-spill outcomes.

Prompt-ready brief:
Generate a deep interaction matrix for ListObject/Table behavior, especially structured-reference and spill interactions, with automated mutation-sequence probes.

### ECS-BL-10 - Platform/channel/build availability matrix and parity probes (Priority P1)
Reference anchors: `15_version_platform_guide.md` known unknowns, `03_gap_closure_response.md` unknown 2, `08_tier4_family_semantics_response.md` rollout matrix unknown.

Scope and expectation:
Build a machine-readable matrix for function availability and behavior caveats across major platform/channel/build combinations, with a focus on newer functions and externally dependent families. This item should continuously track moving-target rollout status.

Expected outputs:
Maintain a dated availability matrix with provenance fields (source page, capture date, empirical probe date). Include parity notes for externally dependent functions where platform support differs materially.

Validation against Excel:
Run capability probes by platform/channel where automation is available; otherwise ingest authoritative applies-to metadata and flag as source-only until probed. Use periodic recrawl + probe diffs to catch rollout changes.

Prompt-ready brief:
Create and maintain a dated, machine-readable platform/channel/build availability matrix for Excel functions, with empirical parity probes where automatable.

### ECS-BL-11 - Classification evidence hardening and reason-code coverage (Priority P2)
Reference anchors: `02_functions_response.md` pass-2 unknowns, `function_interest_index.csv`, `research_index.md`.

Scope and expectation:
Harden the interesting-function classification by attaching explicit reason codes and evidence links per function, including new M365-era functions as they appear. This turns the tier model into an auditable decision artifact rather than a one-time heuristic.

Expected outputs:
Publish a reason-code dictionary and a fully linked per-function classification table that maps each interesting designation to observable risk factors and source anchors. Add review status fields for later synthesis/policy promotion.

Validation against Excel:
For functions with weak source support, run targeted probes to confirm the reason code claim (for example volatility, spill-shape sensitivity, external dependency). Capture probe evidence IDs in the classification table.

Prompt-ready brief:
Add full reason-code and evidence-link coverage to the function interest classification so every tier assignment is auditable and reproducible.

## Empirical run planning baseline
Use a staged execution sequence:
1. Stand up harness contract and pilot probes (`ECS-BL-01`).
2. Close P0 semantic gaps (`ECS-BL-02` through `ECS-BL-06`).
3. Execute P1 formal/interaction expansions (`ECS-BL-07` through `ECS-BL-10`).
4. Finalize classification hardening and continuous maintenance (`ECS-BL-11`).

Each stage should emit:
- scenario manifests,
- generated workbook fixtures,
- raw observation captures,
- normalized result datasets,
- unresolved issue logs,
- minimizable repro bundles for divergence cases.

## Recommendation summary
For documentation synthesis and spec-index refinement, continue in this existing run directory so the narrative remains contiguous.

For empirical behavior extraction and automated Excel probing, start a dedicated empirical run series and maintain cross-links from this backlog document to each empirical run index.

Initial empirical-pass scaffolding and task catalogs now exist at:
- `../../20260228-180047-excel-compat-empirical-pass-01/README.md`
- `../../20260228-180047-excel-compat-empirical-pass-01/outputs/EMPIRICAL_TASK_INDEX.md`
