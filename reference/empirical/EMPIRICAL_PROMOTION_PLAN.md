# Empirical-to-Conformance Promotion Plan

## Goal
Unify conformance-source inputs in `reference/` by combining:
- spec-derived evidence from processed reference runs (`SPEC-*` lineage), and
- curated empirical findings from research runs (`EMP-*` lineage).

## Operating Model
1. Run empirical work in `research/runs/<run-id>/` and keep full raw evidence there.
2. Select only durable, high-value findings for promotion.
3. Register promoted findings in `reference/empirical/findings_registry.jsonl`.
4. Add a human summary entry in `reference/empirical/findings_index.md`.
5. Use `EMP-*` ids as citeable evidence in conformance requirement artifacts.

## Promotion Gate (minimum checklist)
- Finding is materially relevant to compatibility/conformance behavior.
- Claim is reproducible from linked evidence artifacts.
- Run metadata includes Excel version/build and `EXCEL.EXE` hash.
- Runner/tool identity and commit are captured.
- Source basis is clear: `empirical_only`, `empirical_plus_spec`, or `empirical_conflicts_spec`.

## Conflict Handling
- If empirical findings and spec-derived interpretation conflict:
  - retain both sources with explicit linkage,
  - mark finding as `provisional` unless independently reconfirmed,
  - add follow-up action for reconciliation or scope gating.

## Initial Rollout
1. Seed first promoted entries from existing high-signal empirical artifacts.
2. Link promoted `EMP-*` ids from active conformance requirement worklists.
3. Periodically review `provisional` findings for reconfirm/supersede/deprecate decisions.
