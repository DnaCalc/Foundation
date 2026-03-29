# DNA OneCalc -> OxFml Downstream Clarification Prompt

`DNA OneCalc` is the single-node proving host and user-facing application for the `OxFml` + `OxFunc` + `OxReplay` stack. It is meant to behave like one isolated Excel calculation cell or defined-name context, with explicit host inputs, formatting and conditional-formatting scope, full replay visibility and control in the UI, and Windows-only twin-oracle comparison against Excel through `OxXlObs`. It is not a worksheet engine and must not invent a second parser, binder, editor, or host-semantics truth locally.

You are working inside the OxFml repo.

Goal:
Improve the OxFml documentation set so DNA OneCalc has a clear, implementation-ready downstream contract for first integration. This is a docs-first pass. Do not change runtime code unless a tiny supporting doc-generation fix is unavoidable; if so, keep it minimal and explain why.

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
1. host profiles and packet taxonomy
2. formula editing and language-service integration
3. returned value surface
4. current conservative upstream consumption baseline
5. authoritative upstream reference set

Task:
Review the current OxFml docs named there and improve them so DNA OneCalc can consume OxFml without confusing:
1. default H0/H1 host packets,
2. bounded seam-sensitive probe packets,
3. editor and language-service packets that are integration-ready,
4. local-only or draft evidence surfaces,
5. richer result classes that remain narrower than full worksheet-host truth.

Priority outcomes:
1. Host/runtime subset:
   - Which exact fields are mandatory for default OneCalc H0/H1 execution?
   - Which fields are only required for bounded seam-sensitive probe packets?
   - Which fields are coordinator or TreeCalc reference material only, not part of the initial OneCalc host claim?
2. Packet taxonomy:
   - Confirm or refine a packet taxonomy for:
     - `ExplicitInputPacket`
     - `ReferenceProbePacket`
     - `StructuredReferenceProbePacket`
     - `RegisteredExternalProbePacket`
   - For each packet kind, list:
     - allowed extra fields,
     - forbidden fields,
     - currently exercised semantic lanes that require it.
3. Editor/language-service:
   - Freeze or near-freeze the first OneCalc-facing packet family for:
     - immutable formula edit request/result,
     - diagnostics,
     - deterministic completion,
     - validated completion application,
     - signature help,
     - function-help lookup.
   - State clearly which packet surfaces are already good enough for host integration and which remain local-only evidence.
4. Returned value surface:
   - State the current host obligations for:
     - ordinary value,
     - value with presentation,
     - typed host/provider outcome,
     - rich value or non-ordinary value.
   - State what OneCalc should render, persist, and replay-project for each class.
5. Not-authorized list:
   - Produce a short list of what the current OxFml draft does not authorize OneCalc to claim yet.

Important constraints:
1. DNA OneCalc must remain narrower than `OxCalc`.
2. Preserve OxFml ownership of parser, binder, editor, and evaluator-facing semantics.
3. Do not silently elevate draft or evidence-only packets into canonical host authority.
4. Keep packet names and field names where current canonical docs already use them.
5. Keep sequence-based planning language; no date commitments.

Deliverables:
1. Updated OxFml docs.
2. If needed, one new narrow canonical downstream-consumer clarification note.
3. A short final summary that lists:
   - files changed,
   - the authoritative OxFml doc set DNA OneCalc should now use,
   - remaining gaps that still need OxFunc, OxCalc seam, or Foundation coordination.

Verification:
1. Verify internal links and file references you touched.
2. Confirm there is no contradiction between `docs\spec\README.md` and the individual docs after your edits.
3. Do not touch archive docs unless adding a pointer that explicitly marks them historical.
