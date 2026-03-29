# DNA OneCalc -> OxCalc Doc Improvement Prompt

`DNA OneCalc` is the single-node proving host and user-facing application for the `OxFml` + `OxFunc` + `OxReplay` stack. It is meant to behave like one isolated Excel calculation cell or defined-name context, with explicit host inputs, formatting and conditional-formatting scope, full replay visibility and control in the UI, and Windows-only twin-oracle comparison against Excel through `OxXlObs`. It is not a worksheet engine and not an `OxCalc` runtime consumer, but it does rely on the `OxCalc` <-> `OxFml` seam docs as important reference material for the host packet shape it uses to drive `OxFml`.

You are working inside the OxCalc repo.

Goal:
Improve the OxCalc documentation set so it is a better authoritative reference surface for DNA OneCalc's use of the OxCalc<->OxFml seam. This is a docs-first pass. Do not change runtime code unless a tiny supporting doc-generation fix is unavoidable; if so, keep it minimal and explain why.

Read first:
1. `.\README.md`
2. `.\CHARTER.md`
3. `.\OPERATIONS.md`
4. `.\docs\spec\README.md`
5. `.\docs\IN_PROGRESS_FEATURE_WORKLIST.md`
6. `.\CURRENT_BLOCKERS.md`

Then read the Foundation consumer doc:
1. `..\Foundation\notes\DNA_ONECALC_SCOPE_AND_SPEC.md`

Focus especially on:
1. Section `4.1`
2. Section `7`
3. Section `9.4`
4. Section `10`
5. Section `12`
6. Section `19.6`
7. Section `19.8`

Task:
Review the current OxCalc docs named there and improve them so DNA OneCalc can reliably use OxCalc as seam-reference material without confusing:
1. canonical local seam-reference docs,
2. shared OxFml-owned seam authority,
3. temporary negotiation notes,
4. mirrors, archives, and historical material.

Priority outcomes:
1. Make the authoritative OxCalc seam-reference set unmistakable.
2. Make clear which docs are canonical local reference, which are temporary planning or negotiation companions, and which are historical only.
3. Tighten the description of the first deterministic upstream host packet and how it should be used by downstream hosts like DNA OneCalc as reference material only.
4. Improve any missing cross-links among:
   - `docs\spec\README.md`
   - `docs\spec\core-engine\CORE_ENGINE_OXFML_SEAM.md`
   - `docs\spec\core-engine\CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`
   - `docs\spec\core-engine\CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md`
   - `docs\spec\core-engine\CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`
   - `docs\IN_PROGRESS_FEATURE_WORKLIST.md`
5. If the current set still leaves a serious gap for DNA OneCalc, add one new canonical spec note in `docs\spec\core-engine\` that closes that gap. Keep it narrow and clearly scoped.

Important constraints:
1. OxCalc is not a runtime dependency of DNA OneCalc.
2. OxCalc docs must not claim canonical ownership of shared evaluator semantics that belong to OxFml.
3. Do not promote negotiation notes, handoffs, mirrors, or archive docs into canonical authority unless you also rewrite the authority model cleanly.
4. Be explicit about anything still provisional or narrower-than-final.
5. Keep sequence-based planning language; no date commitments.

Deliverables:
1. Updated OxCalc docs.
2. If needed, one new canonical narrow spec note.
3. A short final summary that lists:
   - files changed,
   - the authoritative doc set DNA OneCalc should now use in OxCalc,
   - remaining gaps that still need OxFml or Foundation coordination.

Verification:
1. Verify internal links and file references you touched.
2. Confirm there is no contradiction between `docs\spec\README.md` and the individual docs after your edits.
3. Do not touch archive docs unless adding a pointer that explicitly marks them historical.
