# DNA OneCalc -> OxFunc Downstream Clarification Prompt

`DNA OneCalc` is the single-node proving host and user-facing application for the `OxFml` + `OxFunc` + `OxReplay` stack. It is meant to behave like one isolated Excel calculation cell or defined-name context, with explicit host inputs, formatting and conditional-formatting scope, full replay visibility and control in the UI, and Windows-only twin-oracle comparison against Excel through `OxXlPlay`. It is not a worksheet engine. For function metadata, help, and completion truth, it should consume `OxFunc` through stable documented surfaces rather than inferring broad support claims from implementation state.

You are working inside the OxFunc repo.

Goal:
Improve the OxFunc documentation set so DNA OneCalc has a clear downstream contract for function metadata, help, support-status labeling, and seam-heavy row honesty. This is a docs-first pass. Do not change runtime code unless a tiny supporting doc-generation fix is unavoidable; if so, keep it minimal and explain why.

Read first:
1. `.\README.md`
2. `.\CHARTER.md`
3. `.\OPERATIONS.md`
4. `.\docs\IN_PROGRESS_FEATURE_WORKLIST.md`
5. `.\CURRENT_BLOCKERS.md`

Then read the Foundation consumer doc:
1. `..\Foundation\notes\DNA_ONECALC_SCOPE_AND_SPEC.md`

Task:
Review the current OxFunc docs named there and improve them so DNA OneCalc has a stable reading of the current downstream metadata and help contract.

Priority outcomes:
1. Snapshot export interpretation:
   - Which fields in the current snapshot export are safe for OneCalc to treat as stable now?
   - Which fields are explicitly provisional or should be interpreted only as current-tree hints?
2. Help and signature contract:
   - What is the preferred first OneCalc-facing payload shape for:
     - function help,
     - argument help,
     - signature help metadata?
   - How should this align with the longer-term runtime provider or immutable snapshot direction?
3. Surface admission policy:
   - State the exact downstream reading of:
     - function-phase-complete rows,
     - `W050` deferred rows,
     - `W051` in-scope-not-complete rows.
   - Define how OneCalc should label each category in:
     - help,
     - completion,
     - product UI,
     - scenario metadata.
4. Focused seam-heavy rows:
   - Clarify the current honest status of:
     - `IMAGE`
     - `GROUPBY`
     - `PIVOTBY`
     - `CALL`
     - `REGISTER.ID`
     - `OP_IMPLICIT_INTERSECTION`
   - Distinguish:
     - true semantic incompleteness,
     - cross-repo seam freeze gap,
     - promotion or documentation lag.

Important constraints:
1. OneCalc’s current downstream metadata seed is the library-context snapshot export, but that export is a stabilization artifact, not a final ABI.
2. OneCalc must read the export through `W050` and `W051`, not as broad support truth by itself.
3. Do not overclaim runtime or help-surface stability where the docs only support current-tree evidence.
4. Keep sequence-based planning language; no date commitments.

Deliverables:
1. Updated OxFunc docs.
2. If needed, one new downstream metadata/help contract note and one surface-labeling policy note.
3. A short final summary that lists:
   - files changed,
   - the authoritative OxFunc doc set DNA OneCalc should now use,
   - remaining gaps that still need OxFml, OxReplay, OxVba, or Foundation coordination.

Verification:
1. Verify internal links and file references you touched.
2. Confirm the updated docs do not treat `W050` or `W051` rows as silently fully admitted.
3. Do not touch archive docs unless adding a pointer that explicitly marks them historical.
