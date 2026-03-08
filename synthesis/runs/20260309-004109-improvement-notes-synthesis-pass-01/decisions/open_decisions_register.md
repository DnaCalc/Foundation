# Open Decisions Register

Run: `20260309-004109-improvement-notes-synthesis-pass-01`
Date: 2026-03-09

Status summary:
- Immediate promotions completed for host ladder policy, promotion packet contract, dependency constitution policy, theory-to-pack register policy, and architecture constraints for semantic/runtime separation plus forensic replay traces.

## Deferred decisions

### ODR-009 Overlay Fallback Economics Contract
- Source: IMS015 (`notes/IMPROVEMENT_SUGGESTIONS_CODEX2.md`)
- Question: what exact counters/thresholds define acceptable incremental overlay reuse vs conservative rebuild fallback?
- Current status: deferred.
- Reason: requires pack-owner and runtime-telemetry schema agreement before doctrine freeze.
- Planned closure artifact: `PACK.overlay.fallback_economics` contract draft with metric schema and threshold policy.

### ODR-010 Experimental Lane Promotion Policy
- Source: IMS016 (`notes/IMPROVEMENT_SUGGESTIONS_CODEX2.md`)
- Question: should Foundation enforce a hard "single advanced experimental lane" rule at program level?
- Current status: deferred.
- Reason: needs cross-lane planning tradeoff decision and may conflict with parallel critical-path goals.
- Planned closure artifact: cross-repo policy proposal with risk/throughput impact analysis.

## No further blockers
- No blocker remains for the promotions executed in this pass.
- Deferred items are policy-shape decisions, not immediate architecture-correctness blockers.
