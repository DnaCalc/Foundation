# Pass 20 - Reason-Code Dictionary and Coverage Hardening

## Purpose
Harden interesting-function classification by defining explicit reason-code semantics and an auditable evidence tracker scaffold.

Primary backlog link:
- `ECS-BL-11` in `17_follow_up_execution_backlog.md`

## Reason-code dictionary
| Reason code | Meaning | Typical risk surface |
|---|---|---|
| `volatile_or_recalc_sensitive` | Function result can change based on recalc/event context rather than only direct inputs | scheduler/invalidation parity risk |
| `grid_reference_sensitive` | Behavior depends on reference structure, address rewrites, or grid shape | structural-edit/reference rewrite risk |
| `dynamic_array_or_spill` | Function produces/consumes array shapes with spill behavior | spill blocking/shape propagation risk |
| `functional_lambda_family` | Function participates in LET/LAMBDA/helper semantics | parse/evaluation-order and binding risk |
| `external_data_or_services` | Function depends on external services/connectors/runtime context | capability/parity and determinism risk |
| `format_visible_behavior` | Result has formatting-visible semantics or common format side effects | display/value parity risk |
| `type_or_coercion_sensitive` | Result depends strongly on coercion and type conversion behavior | coercion truth-table risk |
| `cube_context` | Function participates in CUBE worksheet contract with external cube context | connector/availability and context risk |

## Current coverage metrics
Data source:
- `function_interest_index.csv`

Coverage summary:
1. Total interesting functions tracked: `71`.
2. Missing reason-code entries: `0`.
3. Multi-reason functions: `7`.
4. Tier distribution:
   - Tier 5: `5`
   - Tier 4: `43`
   - Tier 3: `23`
5. Reason-code counts (assignment frequency):
   - `cube_context`: `7`
   - `dynamic_array_or_spill`: `23`
   - `external_data_or_services`: `5`
   - `format_visible_behavior`: `6`
   - `functional_lambda_family`: `9`
   - `grid_reference_sensitive`: `14`
   - `type_or_coercion_sensitive`: `5`
   - `volatile_or_recalc_sensitive`: `9`

## New evidence-tracking scaffold
Added artifact:
- `function_reason_code_evidence_tracker.csv`
- `tier45_function_evidence_dossier.csv` (added in pass 24 for tier-5/4 source binding expansion)

Tracker columns:
- `function_name`
- `tier`
- `tier_label`
- `reason_codes`
- `evidence_source_ids`
- `evidence_probe_ids`
- `evidence_status`
- `review_status`
- `notes`

## Known limitations after this pass
1. Reason codes are fully assigned but not yet fully linked to source IDs/probe IDs row-by-row.
2. Evidence status is scaffolded (`pending`) and requires empirical completion.
3. Tier labels remain heuristic-risk labels, not proof of behavioral divergence.

## Pass-24 update (source-binding progress)
1. Tier-5/4 rows are now source-linked in `function_reason_code_evidence_tracker.csv`.
2. Tier-5/4 tracker status transitioned from scaffold `pending` to `source_bound` where triaged.
3. Catalog-only bindings remain explicit and queued for deeper source extraction + empirical verification.

## Required empirical linkage
Use this pass as Track A input for:
- `ECS-EB-040` reason-code empirical verification,
- `ECS-EB-041` evidence-ID sync and review-state hardening.

## Status decision
Reason-code taxonomy and coverage are now explicit and auditable at schema level; evidence completion remains a Track B execution task.
