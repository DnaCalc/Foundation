# Open Decisions Register

## Status legend
1. `queued`: identified but not discussion-settled.
2. `stabilized`: discussion-settled for synthesis guidance; ready for doc-promotion pass.
3. `promoted`: applied to source-of-truth docs in a completed synthesis execution step.

## Decision list
| Decision ID | Title | Status | Blocking | Notes |
|---|---|---|---|---|
| DEC-CALC-001 | Overlay mutation semantics and publish boundaries | queued | yes | Coupled with async and fast-path rules |
| DEC-CALC-002 | Spill-region lifecycle and reference invalidation model | queued | yes | Needs virtual-region algebra and token-GC rules |
| DEC-CALC-003 | Pure-calc fast-path eligibility and fallback conditions | queued | yes | Must be deterministic and replay-safe |
| DEC-CALC-004 | FEC pre-resolution vs F3E semantic ownership contract | queued | yes | Boundary contract still open |
| DEC-CALC-005 | Async scheduler + epoch visibility + lock discipline model | queued | yes | Must satisfy CONSTR-008 |
| DEC-CALC-006 | Dynamic-reference profile tiers and promotion criteria | queued | yes | Requires profile-gated policy |
| DEC-CALC-007 | Formatting-sensitive calc overlay semantics and invalidation policy | stabilized | yes | Stable entry captured in outputs/03 |
| DEC-CALC-008 | Visibility-state model and optional visible-first scheduling policy | stabilized | yes | Stable entry captured in outputs/03 |
| DEC-CALC-009 | FEC/F3E transactional seam adoption gate and hardening obligations | stabilized | yes | Conditional-go review captured in outputs/05 |
