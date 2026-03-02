# Excel Function Definition Preliminary Spec

## 1. Purpose
Define a preliminary, implementation-facing frame for Excel worksheet function semantics.

This document is intentionally not final:
1. it captures current decisions and unresolved policy choices,
2. it marks which non-function conformance lanes depend on these choices,
3. it prepares structured interactive review.

## 2. Scope
In scope:
1. Function semantic classes (pure, volatile, non-deterministic, host-interactive, external-source).
2. Invalidation/recalc trigger classes and observable consequences.
3. Function evaluation context dependencies (workbook/session/environment).
4. Error/coercion policy framing for function definitions.
5. Traceability from function-policy rows to `XLS-CF-*` lanes.

Out of scope:
1. Full per-function final semantics table for all 500 functions.
2. Workbook scheduler internals beyond worksheet-observable effects.

## 3. Preliminary Function Class System

### 3.1 Class Axes
Each function can carry multiple orthogonal tags:
1. `determinism_class`: `deterministic | pseudo_random | time_dependent | external_event_dependent`.
2. `volatility_class`: `nonvolatile | volatile_full | volatile_contextual`.
3. `host_interaction_class`: `none | workbook_state | application_state | environment_state | external_provider`.
4. `coercion_policy_class`: `strict | permissive_scalar | permissive_range_scan | mixed`.
5. `error_policy_class`: `strict_propagate | conditional_mask | branch_selective | custom`.

### 3.2 Working Definitions (Preliminary)
1. Volatile:
   - Function may recalc without direct dependency-graph input change.
   - Volatility is about invalidation policy, not necessarily about deterministic output.
2. Non-deterministic:
   - Function output can vary between evaluations with same explicit inputs and same workbook state.
   - Non-determinism can arise from time/random/external-source dependencies.
3. Host-interactive:
   - Function semantics depend on host/application/session state not fully represented in cell inputs.
   - Includes platform capability and feature availability boundaries.

### 3.3 Current High-Risk Class Anchors
1. `NOW`, `TODAY`: volatile + time-dependent.
2. `RAND`, `RANDARRAY`: volatile + pseudo-random.
3. `RTD`: external-event-dependent + external-provider.
4. `INDIRECT`, `OFFSET`: reference-structural functions with high dependency impact.
5. CUBE family (`CUBESET`, `CUBEVALUE`, etc.): external-provider class with deferred depth.

## 4. Invalidation and Recalc Trigger Model (Preliminary)
Trigger classes:
1. `T-DEP`: dependency graph input changed.
2. `T-VOL`: volatility tick (recalc cycle trigger without direct precedent edit).
3. `T-HOST`: host/application state changed (mode/session/calc-state axes).
4. `T-EXT`: external provider/event update.
5. `T-VERSION`: build/channel/platform behavior drift.

Preliminary rule:
1. Function definition rows must declare expected trigger classes.
2. Conformance probes must isolate trigger class in scenario design where feasible.

## 5. Coupling Into Non-Function Lanes
Function-definition decisions directly affect:
1. `XLS-CF-TV-008` aggregate coercion policy boundary.
2. `XLS-CF-FL-010` argument-gap rationale and parser/evaluator policy.
3. `XLS-CF-FL-005`, `XLS-CF-TB-004`, `XLS-CF-FM-005` where dynamic-array function semantics influence spill expectations.
4. `XLS-CF-FL-006` external-reference behavior interpretation in host/open-state contexts.

## 6. Evidence Model for This Lane
Evidence classes:
1. `spec_anchor`: public formal/help references (`ECS-*`, `REFX-*`).
2. `empirical_anchor`: promoted empirical findings (`EMP-*`).
3. `policy_decision`: explicit interactive decision logs (to be introduced in this lane).

Promotion principle:
1. Function-policy rows remain `draft` or `provisional` until supported by spec and/or empirical anchors with explicit policy decisions.

## 7. Immediate Next Step
Use `EXCEL_FUNCTION_DEFINITION_DISCUSSION.md` to resolve open policy decisions and then update `EXCEL_FUNCTION_DEFINITION_PRELIM_CONFORMANCE.csv`.
