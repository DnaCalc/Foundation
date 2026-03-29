# Claude Review Prompt For DNA OneCalc

Review the current `DnaOneCalc` plan as if you were performing an external design review for the DnaCalc program.

Context:
- Repository root for doctrine: `..\..\..\..`
- The active Foundation doctrine files are:
  1. `README.md`
  2. `CHARTER.md`
  3. `ARCHITECTURE_AND_REQUIREMENTS.md`
  4. `OPERATIONS.md`
  5. `notes/BRAINSTORM_NOTES.md`
- The active `DnaOneCalc` planning files are:
  1. `notes/DNA_ONECALC_INITIAL_SCOPE.md`
  2. `research/runs/20260326-200003-dna-onecalc-scope-pass-01/outputs/01_scope_and_host_profile_plan.md`
  3. `research/runs/20260326-200003-dna-onecalc-scope-pass-01/outputs/02_repo_readiness_and_outstanding_work.md`

Important current decisions already in the plan:
1. `DnaOneCalc` is not a new semantics lane; it is a downstream host and co-development program.
2. `OC-H1` is the `Explicit-Input Host` profile, not a generic worksheet environment.
3. Replay must have full visibility and controllability through the UI.
4. `Leptos` is the chosen UI framework.
5. `OxXlObs` and live Excel-observed comparison are Windows-only.
6. Desktop add-in support is planned only for Windows and Linux in the first add-in wave.
7. Hosted web and browser/WASM start without add-in support.
8. The strongest strategic direction currently named in the plan is `Twin Oracle Workbench`.

Review tasks:
1. Identify the most important findings, risks, contradictions, overreach, and missing work in the current plan.
2. Pay particular attention to doctrine alignment with Foundation `CHARTER.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `OPERATIONS.md`.
3. Answer this question directly:
   - `What’s the single smartest and most radically innovative and accretive and useful and compelling feature or direction we can consider for DnaOneCalc at this point?`
4. Take the plan one level deeper:
   - propose a tighter artifact model,
   - propose a sharper milestone ladder,
   - propose concrete early work packets,
   - call out what must be deferred.

Output format:
1. `Findings`
   - ordered by severity,
   - with concrete file references.
2. `Best Direction`
   - one direct answer.
3. `One Level Deeper`
   - 8 to 12 concrete work packets or planning packets.

Review stance:
- be rigorous and unsentimental,
- do not accept vague “we can figure it out later” claims,
- prefer a narrower honest scope over an inflated early promise,
- optimize for an executable repo bootstrap, not only for an inspiring product description.
