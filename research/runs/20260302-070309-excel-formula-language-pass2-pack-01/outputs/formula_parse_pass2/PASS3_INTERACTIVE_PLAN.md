# Pass 3 - Initial Interactive Plan (Discussion/Review)

## Purpose
Define how pass-3 should run as a careful interactive session for policy decisions and targeted replay design, using pass-2 outputs plus pass-4/pass-5 artifacts.

## Pass-3 Focus
1. Decide policy wording confidence boundaries for provisional rules:
   - `FML-R-006` external references,
   - `FML-R-008` scoped names,
   - `FML-R-011` dot-field linked-data branch.
2. Confirm replay ordering and acceptance criteria from `PASS5_REPLAY_MANIFEST.csv`.
3. Decide any extra scenario variants needed before replay execution starts.
4. Confirm promotion gates (`provisional` -> `validated`) per rule family.

## Suggested Interactive Agenda
1. Review current evidence deltas:
   - pass-2 summary and targeted lanes,
   - pass-4 wording decisions,
   - pass-5 replay queue.
2. Walk rule-by-rule through `FML-R-006`, `FML-R-008`, `FML-R-011`, `FML-R-005`.
3. For each rule, decide one of:
   - keep as-is and replay,
   - refine wording now,
   - split into multiple provisional sub-rules.
4. Freeze replay order and execution contract for next run wave.

## Sync Loop for Pass-3
Use this short loop for each review cycle:
1. `sync-in`: capture current rule wording + latest evidence references.
2. `decision`: interactive review and explicit decision log line (accept/change/defer).
3. `sync-out`: patch docs (`CONCRETE_RULES`, `CONFORMANCE_MATRIX`, `OPEN_QUESTIONS`) in one batch.
4. `verify`: run consistency check (no orphan rule ids, probe ids, or open-question references).
5. `checkpoint`: append a dated entry to this doc with decisions and next action.

Loop constraints:
1. Do not run broad empirical batches inside pass-3 until policy wording decisions are frozen.
2. Keep unresolved items explicit; do not promote status without replay evidence.
3. Keep every pass-3 decision traceable to a rule id and source artifact path.

## Pass-4 / Pass-5 Interaction
1. Pass-4 provides wording baseline; pass-3 may revise it interactively.
2. Pass-5 provides replay queue baseline; pass-3 may reorder/split tasks.
3. Any pass-3 decision that changes replay scope must update `PASS5_REPLAY_MANIFEST.csv`.

## Exit Criteria for Pass-3
1. Decision log exists for each targeted provisional rule.
2. Replay manifest is approved for execution order and scope.
3. Sync-loop checklist has at least one completed cycle documented.

