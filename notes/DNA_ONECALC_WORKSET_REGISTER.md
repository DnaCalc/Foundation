# DNA OneCalc Workset Register

Status: `recovered_seed_register`  
Date: 2026-03-29

## 1. Purpose
This note recovers the `DNA OneCalc` workset register that previously lived inside `DNA_ONECALC_SCOPE_AND_SPEC.md`.

It is retained because those worksets were the best planning breakdown currently available, even though the execution-tracking material has now been removed from the main engineering spec.

## 2. Use Rule
Use this note as:
1. the current recovered seed register for the future repo-local `WORKSET_REGISTER.md`,
2. the source for the first `DnaOneCalc` bead rollout,
3. a planning bridge between the Foundation engineering spec and the future repo-local bead graph.

Do not use this note as:
1. semantic authority over the OneCalc scope,
2. a replacement for the main engineering spec,
3. a substitute for the eventual repo-local workset register and `.beads/` graph.

## 3. Recovered Work Area Map
The worksets below were originally derived from the following engineering work areas:
1. `W1` Bootstrap, Governance, And Seam Freeze
2. `W2` UI And Runtime Proving
3. `W3` Formula Editing And Language-Service Integration
4. `W4` H0 Evaluation And Result Surface
5. `W5` Replay And Live Semantic X-Ray
6. `W6` Driven Single-Formula Host
7. `W7` Formatting And Effective Display
8. `W8` Persistence
9. `W9` Conditional Formatting
10. `W10` Excel Comparison
11. `W11` Extension ABI And Add-ins
12. `W12` Upstream Pressure, Corpus Governance, And Cleanup

## 4. Recovered Register

### WS-001 Repo Bootstrap And Control Set
1. maps_to: `W1.1`
2. depends_on: none
3. intent:
   bootstrap charter, host-profile matrix, meta-check contract, provisionality policy.

### WS-002 Upstream Seam Manifest And Pin Set
1. maps_to: `W1.2`
2. depends_on: `WS-001`
3. note:
   must consume the current OneCalc-facing docs from `OxFml`, `OxFunc`, `OxReplay`, `OxXlObs`, and the OxCalc seam-reference slice rather than relying on older Foundation-only assumptions.
4. intent:
   seam manifest, dependency pin set, and first emitted capability snapshot for the exact dependency set in use.

### WS-003 Artifact Schema And Handoff Schema Freeze
1. maps_to: `W1.3`
2. depends_on: `WS-001`, `WS-002`
3. note:
   should freeze the shared artifact envelope and lineage rules before persistence or replay UI work starts.
4. intent:
   stable schema and handoff basis for scenario, run, comparison, witness, and handoff artifacts.

### WS-004 Host Shell Proof Of Life
1. maps_to: `W2.1`
2. depends_on: `WS-001`, `WS-002`
3. intent:
   desktop and browser host proof, runtime-size notes, platform honesty record.

### WS-005 Editing And Shell Viability Spike
1. maps_to: `W2.2`
2. depends_on: `WS-004`
3. intent:
   keyboard, IME, shell-command-surface, and latency viability record plus any escape-hatch decision.

### WS-006 Immutable Edit And Diagnostics Baseline
1. maps_to: `W3.1`, `W3.2`
2. depends_on: `WS-002`, `WS-004`, `WS-005`
3. note:
   should land before broader run or replay work so editor-packet identity and diagnostic provenance are not backfilled later.
4. intent:
   real OxFml edit and diagnostics integration in the host editor.

### WS-007 Completion And Help Integration
1. maps_to: `W3.3`, `W3.4`
2. depends_on: `WS-006`, `WS-002`
3. note:
   depends on the OxFunc downstream metadata/help contract and labeling policy, not just the snapshot export file.
4. intent:
   deterministic completion, validated application, function help, and signature help.

### WS-008 H0 Execution And Result Surface
1. maps_to: `W4.1`, `W4.2`
2. depends_on: `WS-002`, `WS-004`
3. intent:
   first retained H0 scenario run and result display surface.

### WS-009 Replay Capture And X-Ray Baseline
1. maps_to: `W5.1`, `W5.2`
2. depends_on: `WS-003`, `WS-008`
3. note:
   requires artifact-schema freeze first because replay and X-Ray surfaces become meaningless if run identity and lineage are still fluid.
4. intent:
   retained replay baseline, X-Ray baseline, and capability-snapshot attachment on retained runs.

### WS-010 Witness And Handoff Integration
1. maps_to: `W5.3`
2. depends_on: `WS-003`, `WS-009`
3. intent:
   retained witness flow, first handoff draft path, and first scenario-capsule export path.

### WS-011 H1 Driven Single-Formula Host
1. maps_to: `W6.1`
2. depends_on: `WS-008`, `WS-009`
3. note:
   depends on replay visibility because host-driving consequences and recalc triggers must be inspectable, not just executable.
4. intent:
   concrete driven-host model without sliding into worksheet semantics.

### WS-012 Driven Scenario Families And Version Comparison
1. maps_to: `W6.2`
2. depends_on: `WS-011`, `WS-002`
3. intent:
   reusable driven scenario families and version-to-version comparison flow without crossing into the OxCalc dereference seam.

### WS-013 Formatting And Effective Display
1. maps_to: `W7.1`, `W7.2`
2. depends_on: `WS-008`, `WS-009`, `WS-011`
3. note:
   depends on result-surface and replay capture because returned presentation hints and host style state must both remain inspectable.
4. intent:
   formatting truth, effective display, and first retained formatting-sensitive scenarios.

### WS-014 Persistence Mapping And Round-Trip
1. maps_to: `W8.1`, `W8.2`, `W8.3`
2. depends_on: `WS-003`, `WS-011`, `WS-013`
3. note:
   should not start hardening until artifact ids, host packet kinds, formatting carriage, and retained attachment discipline are already stable enough to round-trip and package honestly.
4. intent:
   SpreadsheetML persistence baseline plus scenario-capsule export and intake baseline.

### WS-015 Isolated-Instance Conditional-Formatting Subset
1. maps_to: `W9.1`
2. depends_on: `WS-013`, `WS-014`
3. intent:
   isolated-instance CF rule model and first retained conditional-formatting scenario families.

### WS-016 Windows Twin-Oracle Baseline
1. maps_to: `W10.1`
2. depends_on: `WS-009`, `WS-011`, `WS-013`
3. note:
   should use the OxXlObs OneCalc consumer contract and must preserve `direct`, `derived`, `unavailable`, and `lossy` distinctions in the first comparison UI.
4. intent:
   first real Windows-only compare lane against Excel-observed evidence.

### WS-017 Conditional-Formatting Comparison Families
1. maps_to: `W9.2`
2. depends_on: `WS-015`, `WS-016`
3. intent:
   first retained conditional-formatting comparison family plus any required OxXlObs widening requests.

### WS-018 First Proving Spine Family
1. maps_to: `W10.2`
2. depends_on: `WS-009`, `WS-012`, `WS-016`
3. intent:
   first promoted scenario family with retained DNA run, Excel observation where applicable, comparison, and explicit promotion-order record for formula-core, twin-oracle, and language-service spines.

### WS-019 Portable Extension ABI
1. maps_to: `W11.1`
2. depends_on: `WS-001`, `WS-011`
3. note:
   must align with the admitted Excel-SDK subset and the OneCalc host-driving model before the ABI is declared stable.
4. intent:
   explicit portable extension ABI contract by platform.

### WS-020 Add-In Registration And RTD
1. maps_to: `W11.2`
2. depends_on: `WS-012`, `WS-019`
3. intent:
   desktop-only extension path with explicit platform honesty.

### WS-021 Upstream Pressure And Corpus Hardening
1. maps_to: `W12.1`, `W12.2`
2. depends_on: `WS-010`, `WS-017`, `WS-018`, `WS-020`
3. note:
   should be the first cleanup wave after the proving spine, not a precondition to making the host real.
4. intent:
   upstream handoff discipline, capability-observatory diff usage, scenario-capsule-based evidence handoff, and corpus cleanup aligned to actual executable floors.
