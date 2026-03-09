# Open Decisions Register

Run: `20260309-072109-core-engine-program-layout-synthesis-pass-01`
Date: 2026-03-09

## Remaining open items

### ODR-CPL-001 Per-repo Charter Authoring Scope
- Status: deferred
- Decision: Foundation holds canonical map and governance rules; detailed implementation charters for OxFml/OxCalc/OxVba/host repos should be authored in those repos and handed back via managed-run promotion packets when they affect doctrine.

### ODR-CPL-002 Advanced Dynamic-Topo/SAC Baseline Promotion
- Status: deferred
- Decision: keep advanced dynamic-topology and SAC-inspired lanes inside bounded advanced-lane policy until parity and deterministic replay evidence clears promotion gates.

### ODR-CPL-003 Stage-2/Stage-3 Core Engine Gate Thresholds
- Status: open
- Decision: stage thresholds for concurrency, starvation bounds, and overlay economics are intentionally profile-calibrated by pack owners; doctrine remains threshold-agnostic at this stage.