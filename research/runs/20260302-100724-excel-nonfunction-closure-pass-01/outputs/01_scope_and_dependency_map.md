# Scope and Dependency Map

## Non-Function Closure Scope (This Run)
1. Formula-language closure lanes (`XLS-CF-FL-*`) excluding function-class policy decisions.
2. Link/reference behavior inside formula evaluation.
3. Table/ListObject + spill interaction lanes (`XLS-CF-TB-*`).
4. Formatting and conditional-format lanes (`XLS-CF-FM-*`).
5. Value/coercion lanes where closure is possible without function-definition policy choices (`XLS-CF-TV-*`).

## Provisional Lanes Targeted
| req_id | area | current_state | function_definition_dependency | run intent |
|---|---|---|---|---|
| XLS-CF-FL-010 | double-comma parser behavior | provisional | medium (function parser/evaluator policy affects accept/reject rationale) | refresh empirical matrix and tighten build-scoped wording |
| XLS-CF-FL-011 | dot-field parse/eval | provisional | low/medium (host-data linkage taxonomy overlaps function host-interaction model) | extend non-linked/link-linked evidence and tool capability notes |
| XLS-CF-TV-008 | aggregate range coercion | provisional | high (aggregate function semantic policy) | empirical refresh only; policy remains provisional pending function work |
| XLS-CF-TB-004 | structured-reference spill interaction | provisional | medium (dynamic-array semantics overlap function families) | targeted replay and explicit caveat wording |
| XLS-CF-FM-005 | CF spill-target behavior | provisional | low/medium (depends on spill outcomes, not function taxonomy directly) | targeted replay and explicit caveat wording |

## Function-Definition Blocker Register
These items are expected to remain blocked until interactive function-definition work:
1. Formal separation of volatile vs non-deterministic vs externally-invalidated function classes.
2. Host-interaction model during evaluation (UI/session/environment dependencies).
3. Per-function coercion/error policy taxonomy for high-interest classes.
4. Promotion decisions for function-adjacent provisional rows (`XLS-CF-TV-008`, `XLS-CF-FL-010` rationale boundaries).

## Open Questions In Scope for This Run
- ECM-Q-001, ECM-Q-005, ECM-Q-006, ECM-Q-009, ECM-Q-010 (non-function closure focus).

## Open Questions Deferred to Function-Definition Phase
- ECM-Q-003, ECM-Q-004, ECM-Q-008 and function-policy portions of ECM-Q-002.
