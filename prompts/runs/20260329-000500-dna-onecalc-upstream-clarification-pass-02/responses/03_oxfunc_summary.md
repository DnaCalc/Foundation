## Final Summary

### Files Changed
| File | Change |
|------|--------|
| `docs/function-lane/OXFUNC_DOWNSTREAM_METADATA_AND_HELP_CONTRACT.md` | New. Downstream metadata, help, and signature contract for DNA OneCalc. |
| `docs/function-lane/OXFUNC_SURFACE_ADMISSION_AND_LABELING_POLICY.md` | New. Surface admission categories and labeling rules for downstream consumers. |
| `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1_README.md` | Updated with downstream consumer guidance, mandatory `W050`/`W051` overlay reading, stability tiers, help-payload pointer, and stabilization-artifact rule. |
| `docs/IN_PROGRESS_FEATURE_WORKLIST.md` | Updated IP-10 to reference the new downstream contract docs and to call out missing structured help/signature payloads. |
| `README.md` | Updated Core Files to list the two new downstream contract docs. |

### Authoritative OxFunc Doc Set DNA OneCalc Should Now Use
1. `README.md`
2. `CHARTER.md`
3. `OPERATIONS.md`
4. `docs/IN_PROGRESS_FEATURE_WORKLIST.md`
5. `CURRENT_BLOCKERS.md`
6. `docs/worksets/W050_DEFERRED_CURRENT_VERSION_SURFACE.md` and CSV
7. `docs/worksets/W051_IN_SCOPE_CURRENT_VERSION_NOT_COMPLETE_SURFACE.md` and CSV
8. `docs/function-lane/OXFUNC_DOWNSTREAM_METADATA_AND_HELP_CONTRACT.md`
9. `docs/function-lane/OXFUNC_SURFACE_ADMISSION_AND_LABELING_POLICY.md`
10. `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1_README.md`
11. `docs/function-lane/OXFUNC_LIBRARY_CONTEXT_SNAPSHOT_EXPORT_V1.csv`
12. `docs/function-lane/FUNCTION_SLICE_RUNTIME_LIBRARY_CONTEXT_PROVIDER_CONSUMER_MODEL_PRELIM.md`

### Remaining Gaps
1. Structured help prose per function
2. Per-argument names, descriptions, and type hints
3. Signature display strings
4. OxFml packetization of OxFunc help payloads into host-facing editor packets
5. Shared immutable formula-edit packet freeze
6. Runtime `LibraryContextProvider` / `LibraryContextSnapshot` materialization
7. `CALL` / `REGISTER.ID` registration seam packet freeze
8. `IMAGE` first-freeze promotion and return-surface closure
9. `GROUPBY` / `PIVOTBY` broader promotion and documentation
10. `OP_IMPLICIT_INTERSECTION` compatibility-version and serialization characterization
11. Localized help content
