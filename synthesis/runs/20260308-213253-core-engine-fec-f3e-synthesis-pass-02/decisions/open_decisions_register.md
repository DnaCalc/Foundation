# Open Decisions Register

Status update (2026-03-09): all ODR-001..ODR-008 items were locked in interview closure for this synthesis run.

## Locked Decisions
- ODR-001: Atomic commit publish bundle + strict no-op reject + structured reject-cause tracing.
- ODR-002: `CycleSemantics = PriorValueFallback | CycleError | Iterative` with explicit v0 mapping.
- ODR-003: `StreamSemanticsVersion = ExternalInvalidationV0 | TopicEnvelopeV1 | RtdLifecycleV2`.
- ODR-004: Strict overlay keying and watermark-based epoch-safe GC.
- ODR-005: Default-off ambient formatting observability; formula-semantic formatting lanes run through OxFml via FEC/F3E seam.
- ODR-006: Optional `VisibleFirst` with deterministic order and fairness bound default `max_deferred_waves=8`.
- ODR-007: Early tree-host spill analog explicitly deferred.
- ODR-008: `CURRENT_SPEC_SET.md` pointer hygiene rule locked.

## Remaining Open Items
- None at architecture-decision level for this interview scope.
- Next work is promotion edits and pack/gate execution.
