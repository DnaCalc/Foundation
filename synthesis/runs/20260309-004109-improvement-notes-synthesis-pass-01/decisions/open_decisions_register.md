# Open Decisions Register

Run: `20260309-004109-improvement-notes-synthesis-pass-01`
Date: 2026-03-09

Status summary:
- Immediate promotions completed for host ladder policy, promotion packet contract, dependency constitution policy, theory-to-pack register policy, and architecture constraints for semantic/runtime separation plus forensic replay traces.
- Follow-up closure completed for ODR-009 and ODR-010 using accepted default policy decisions.

## Closed decisions

### ODR-009 Overlay Fallback Economics Contract
- Source: IMS015 (`notes/IMPROVEMENT_SUGGESTIONS_CODEX2.md`)
- Question: what exact counters/thresholds define acceptable incremental overlay reuse vs conservative rebuild fallback?
- Current status: locked (partial lock with staged calibration).
- Decision:
  - lock minimum counter schema now in doctrine/packs,
  - calibrate profile-specific pass/fail thresholds by pack owners as a follow-up contract task.
- Locked artifact updates:
  - `OPERATIONS.md` (`PACK.overlay.fallback_economics` counter schema + threshold policy notes).

### ODR-010 Experimental Lane Promotion Policy
- Source: IMS016 (`notes/IMPROVEMENT_SUGGESTIONS_CODEX2.md`)
- Question: should Foundation enforce a hard "single advanced experimental lane" rule at program level?
- Current status: locked.
- Decision:
  - no hard single-lane policy,
  - adopt bounded-lanes default: max two concurrent advanced lanes unless synthesis override,
  - require owner/objective/parity-packs/exit/kill-switch declarations for each lane.
- Locked artifact updates:
  - `OPERATIONS.md` (`8.15 Advanced Experimental Lane Policy`).

## No further blockers
- No blocker remains for the promotions executed in this pass.
- No open ODR items remain for this run.
