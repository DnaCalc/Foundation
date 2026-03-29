# DNA OneCalc Design Pack

Status: working draft  
Date: 2026-03-28  
Audience: product design, UX, interaction design, content design, repo bootstrap, and upstream seam clarification

## 1. What this pack is
This pack turns the UX foundation into the first practical design set for DNA OneCalc.

It is intended to be used for:
- initial visual design,
- low-fidelity product review,
- repo bootstrap planning,
- upstream UX-driven seam clarification,
- prompt input to the Ox* repos where UX consequences need to be made explicit.

It stays on the UX side of the boundary. It does **not** define frontend implementation details or library choices.

## 2. Design frame
DNA OneCalc should feel like a **Twin Oracle Workbench**, not a spreadsheet clone and not a generic replay shell.

The pack therefore assumes:
- a narrow single-node host,
- formula-centric authoring,
- explicit host profile and capability truth,
- first-class replay, comparison, explain, witness, and handoff,
- no implied workbook graph,
- no silent drift toward OxCalc-like grid behavior.

## 3. Pack contents
1. Shell and information architecture diagram
2. Screen inventory
3. Primary UX flows
4. Capability-gate matrix
5. Low-fidelity wireframes
6. Interaction and command model
7. Status and badging system
8. UX copy glossary
9. UX-driven upstream questions

## 4. One-page shell and IA
See:
- [Shell and information architecture diagram](./assets/01_shell_and_information_architecture.png)

### 4.1 Top-level areas
- **Workbench** — author, run, inspect, compare, replay, explain, retain, handoff
- **Scenario Library** — browse scenarios, runs, comparisons, witnesses, handoffs
- **Document / Instance Manager** — manage isolated scenarios in a persisted container without implying workbook semantics
- **Environment / Capability Center** — host profile, admitted surface, platform gates, replay floor, extension state

### 4.2 Main workbench regions
- **Context bar**
- **Library / lineage sidebar**
- **Authoring pane**
- **Explicit input / context pane**
- **Result + status pane**
- **X-Ray / Compare drawer**

### 4.3 IA rule
The product should not force users into a separate developer-only area to reach its core semantic surfaces.

## 5. Screen inventory
| Screen / surface | Purpose | Primary objects | Primary actions | Initial priority |
|---|---|---|---|---|
| Workbench | Main authoring and inspection surface | Scenario, Run | Edit, run, inspect, switch mode | P0 |
| Compare view | Compare DNA run vs observation or run vs run | Comparison, Observation | Inspect agreement, diff, explain | P0 |
| Scenario Library | Browse retained evidence corpus | Scenario, Run, Comparison, Witness, Handoff | Filter, reopen, fork, trace lineage | P0 |
| Handoff Review | Turn investigation into upstream packet | HandoffPacket | Review, warn, export | P0 |
| X-Ray drawer | Deep semantic inspection | Parse tree, Trace, Provenance, Replay state | Inspect, filter, jump | P0 |
| Document / Instance Manager | Manage isolated instances | Document, Scenario | Open, duplicate, rename, persist | P1 |
| Environment / Capability Center | Inspect what the host can honestly claim | Host profile, surface status, platform gates | Inspect, switch profile, read gates | P1 |
| Witness detail | Review retained mismatch evidence | Witness | Inspect, distill, quarantine / retain | P1 |
| Observation import / attach | Attach retained Excel evidence | Observation | Import, validate, attach | P1 |
| Extension center | Manage desktop-only extension state | Extension state | Inspect platform support, enable host extensions | P2 |

## 6. Primary UX flows

### 6.1 Flow A — Author and run
1. Open or create a scenario.
2. Enter or edit the formula in the workbench editor.
3. Use completion and signature help where available.
4. Resolve diagnostics or run with visible warning state.
5. Review result, type, shape, effective display, and run identity.
6. Open X-Ray tabs if deeper inspection is needed.

### 6.2 Flow B — Diagnose an error
1. Diagnostic appears inline and in the issue strip.
2. User navigates by stage: syntax, bind, semantic-plan, runtime.
3. Help panel shows current function or operator information if available.
4. User edits formula or input context and re-runs.
5. Diagnostics history remains tied to the scenario, not lost in transient UI state.

### 6.3 Flow C — Compare with Excel
1. Attach a retained observation or launch live Excel comparison on Windows.
2. Compare DNA run vs observation in compare view.
3. Review agreement by value, type, display, formatting, conditional formatting.
4. See source identity, projection status, and capture-loss markers directly in the header.
5. Open Diff and Explain without leaving the comparison workflow.

### 6.4 Flow D — Explain and retain witness
1. User identifies a divergence in compare view.
2. Explain tab shows the current best causal explanation record.
3. User retains the mismatch as a witness.
4. Witness becomes available in library lineage.
5. If distillation is not yet honestly supported, the UI says so instead of pretending.

### 6.5 Flow E — Emit handoff
1. User opens Handoff Review from a scenario, comparison, or witness.
2. Handoff pulls in scenario summary, host assumptions, comparison summary, witness identity, and replay lineage.
3. UI checks for missing destination, lossy source warnings, and missing evidence links.
4. User writes the requested upstream action.
5. Packet is saved or exported as a draft.

### 6.6 Flow F — Browse and reopen prior evidence
1. User filters the Scenario Library by family, host profile, surface status, or witness presence.
2. User reopens a retained scenario or comparison.
3. Lineage is visible: scenario → run → comparison → witness → handoff.
4. User forks a scenario into a new investigation without mutating the retained original.

## 7. Capability-gate matrix

### 7.1 Mode-level matrix
| Mode / control | H0 | H1 | H2 | Windows desktop | Linux desktop | Browser / WASM | Replay dependency | Observation dependency | Current design note |
|---|---:|---:|---:|---:|---:|---:|---|---|---|
| DNA-only | Yes | Yes | Yes | Yes | Yes | Yes | none | none | default mode |
| Excel-observed (retained) | n/a | Yes | Yes | Yes | Yes | Yes | none or replay-backed view | retained observation | cross-platform retained inspection |
| Excel-observed (live) | n/a | Yes | Yes | Yes | No | No | none | live OxXlObs path | Windows-only |
| Twin compare (retained) | n/a | Yes | Yes | Yes | Yes | Yes | C2 for diff surfaces, C3 for explain | retained observation | promoted compare lane |
| Twin compare (live) | n/a | Yes | Yes | Yes | No | No | C2 / C3 for deeper replay-backed surfaces | live observation | Windows-only twin-oracle lane |
| Replay | Yes | Yes | Yes | Yes | Yes | Yes | C1 | none | use shared OxReplay runtime |
| Diff | n/a | Yes | Yes | Yes | Yes | Yes | C2 | optional | typed mismatch surface |
| Explain | n/a | Yes | Yes | Yes | Yes | Yes | C3 | optional | cause-oriented view |
| Distill | No | Hidden / gated | Hidden / gated | Hidden / gated | Hidden / gated | Hidden / gated | C4 | optional | not first promoted UX wave |
| Handoff | Yes | Yes | Yes | Yes | Yes | Yes | none, better with C2/C3 context | optional | can exist before distill |

### 7.2 Surface-level matrix
| Surface | H0 | H1 | H2 | Notes |
|---|---:|---:|---:|---|
| Formula editor | Yes | Yes | Yes | keyboard-first, diagnostics-first |
| Explicit input pane | Limited | Yes | Yes | H0 only shows minimal context; H1/H2 show real input slots |
| Bounded reference probe pane | No | Limited | Limited | only where the admitted seam genuinely requires it |
| Result + status pane | Yes | Yes | Yes | must always show visible host profile |
| Effective display | Yes | Yes | Yes | honest subset first |
| Formatting inspector | Limited | Yes | Yes | base formatting first |
| Conditional-formatting inspector | No | Limited | Limited | restricted isolated-instance subset first |
| Replay tab | Yes | Yes | Yes | requires validated replay artifact |
| Diff / Explain tabs | Limited | Yes | Yes | meaningful once comparison or replay artifacts exist |
| Extension center | No | No | Yes | desktop only; browser explicitly without native add-ins |
| VBA shim status | No | No | Future | Windows-first later lane |

### 7.3 Always-visible truth
These should remain visible in-context wherever they affect interpretation:
- current host profile (`OC-H0` / `OC-H1` / `OC-H2`)
- function-surface status (`Promoted` / `Provisional` / `Deferred`)
- replay capability floor (`C0`–`C3` now; do not imply `C4`/`C5`)
- source status (`DNA-only`, `Retained Excel`, `Live Excel`)
- projection status (`Direct`, `Projected`, `Projected — lossy`)
- platform gating (`Windows-only`, `Desktop only`, `Browser limited`)
- extension state (`Not in this host`, `Declared but unavailable`, `Enabled`)
- observation caveats (`capture-loss`, `uncertainty`, `projection`)

## 8. Low-fidelity wireframes
See:
- [Main workbench](./assets/02_workbench_wireframe.png)
- [Compare view](./assets/03_compare_wireframe.png)
- [Scenario library](./assets/04_scenario_library_wireframe.png)
- [Handoff review](./assets/05_handoff_review_wireframe.png)

### 8.1 Workbench requirements captured in the wireframe
- editor-first composition
- visible context bar with host truth
- explicit inputs separated from formula authoring
- result surface that distinguishes display from underlying value
- X-Ray surface inside the main workbench, not hidden elsewhere

### 8.2 Compare requirements captured in the wireframe
- DNA and Excel sources side by side
- explicit source / projection / Windows-only labeling
- typed agreement taxonomy
- direct path from diff to explain

### 8.3 Library requirements captured in the wireframe
- evidence corpus, not recent files
- persistent filters by host profile, surface status, witness, and handoff
- visible lineage chain

### 8.4 Handoff requirements captured in the wireframe
- automatic pull-through of retained context
- visible warnings for lossy sources and missing links
- explicit requested action and target lane

## 9. Interaction patterns and command model

### 9.1 Core commands
- **Run / Re-run**
- **Switch mode**
- **Open compare**
- **Open replay**
- **Open diff**
- **Open explain**
- **Retain witness**
- **Draft handoff**
- **Fork scenario**
- **Open capability center**

### 9.2 Keyboard-first defaults
- formula editor is the default focus target
- diagnostics are navigable by keyboard
- completion acceptance and dismissal are keyboard-first
- X-Ray tabs are keyboard-switchable
- compare filters and library filters are keyboard operable
- handoff review is completable without mouse-only interaction

### 9.3 Panel behavior
- the right-side deep inspection area should behave like a durable drawer / tabbed panel, not a fragile transient popover
- switching tabs should preserve scroll and filter state where reasonable
- compare and handoff should feel like modes of the same workbench, not unrelated routes

## 10. Status and badging system

### 10.1 Status vocabulary
| Category | Labels |
|---|---|
| Surface maturity | `Promoted`, `Provisional`, `Deferred` |
| Source type | `DNA`, `Excel (retained)`, `Excel (live)` |
| Projection | `Direct`, `Projected`, `Projected — lossy` |
| Platform | `Windows-only`, `Desktop only`, `Browser limited` |
| Replay floor | `C0`, `C1`, `C2`, `C3` |
| Evidence | `No observation`, `Observation attached`, `Witness retained`, `Handoff draft` |
| Run state | `Dirty`, `Ready`, `Ran`, `Compared` |

### 10.2 Copy rules
- never say “match” when only a lossy projection has been compared
- never say “supported” when a surface is only provisional or metadata-limited
- never let browser hosts imply native add-ins
- never let H1 authoring imply worksheet-grid semantics

## 11. UX copy glossary
| Term | Product meaning |
|---|---|
| **Scenario** | the authored formula investigation unit |
| **Run** | one concrete execution of a scenario |
| **Observation** | external truth, usually Excel-observed |
| **Comparison** | a typed comparison between two concrete outputs |
| **Witness** | retained mismatch evidence |
| **Handoff** | upstream-facing packet assembled from retained investigation context |
| **Host profile** | the current OneCalc execution envelope: `OC-H0`, `OC-H1`, `OC-H2` |
| **Capability floor** | the current replay capability level the UI depends on |
| **Projection status** | whether the displayed surface is direct or projected from another artifact |
| **Capture-loss** | explicit statement that some source truth was not preserved in capture or projection |
| **Promoted / Provisional / Deferred** | maturity labels for admitted product surfaces and scenario families |

## 12. Component inventory
- context bar
- formula editor
- diagnostics strip
- completion popup
- signature/help panel
- explicit input cards
- host context cards
- result summary card
- evidence badges
- X-Ray tab strip
- diff table / mismatch list
- explanation record panel
- witness summary card
- library filter rail
- lineage breadcrumb / graph
- handoff readiness checklist

## 13. UX-driven upstream questions
These are the design-pressure questions the pack exposes.

### 13.1 OxFml
- Which immutable edit, diagnostics, completion, and signature-help packets should be treated as bootstrap-stable for host UI integration?
- What stage identities must the UI be able to show directly?
- What exact payload shape is reliable enough for function-help invocation and active-argument guidance?

### 13.2 OxFunc
- What minimum help payload and gating metadata can the editor sidebar depend on?
- How should admitted surface status be projected so the UI can distinguish promoted vs provisional rows honestly?
- Which return-surface hints should the result pane expose first?

### 13.3 OxReplay
- Which replay identity, validation, diff, explain, and witness fields should be surfaced directly in the workbench header and X-Ray tabs?
- What is the smallest honest UX for C1/C2/C3 without implying C4/C5?
- Which lifecycle states and quarantine reasons need first-class labels?

### 13.4 OxXlObs
- What exact source / projection / capture-loss markers should appear in compare headers?
- Which observation fields are stable enough for cross-platform retained inspection?
- What is the correct visible distinction between live Excel and retained Excel artifacts?

### 13.5 OxCalc seam reference
- Which bounded reference-bearing probe packets are worth designing into H1 as visible probes without making the UI feel worksheet-like?
- Which coordinator-side packet facts should influence user-visible “probe context” labels?

### 13.6 OxVba and extensions
- What should the extension center promise now versus mark as later?
- Which platform warnings and packaging labels should be frozen before H2 UI design is widened?

## 14. Suggested immediate next pass
1. choose whether workbench modes are implemented as a tab strip, segmented mode bar, or command-mode layer
2. decide the default first-run view: editor-first or last-active pane
3. freeze the initial always-visible badge set
4. run a terminology review against the Ox* repo owners
5. convert the low-fidelity wireframes into a first visual language pass

## 15. Deliverables in this folder
- `DNA_OneCalc_Design_Pack.md` — this pack
- `assets/01_shell_and_information_architecture.png`
- `assets/02_workbench_wireframe.png`
- `assets/03_compare_wireframe.png`
- `assets/04_scenario_library_wireframe.png`
- `assets/05_handoff_review_wireframe.png`
