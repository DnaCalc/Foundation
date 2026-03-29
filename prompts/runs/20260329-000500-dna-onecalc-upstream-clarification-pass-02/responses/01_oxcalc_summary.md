## Final Summary

### Files Changed

| File | What changed |
|---|---|
| `docs/spec/README.md` | Added item 6 to reading order (`CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`), and added a document-classification vocabulary for downstream hosts. |
| `docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` | Added a document-classification summary table; split companion docs into supporting vs temporary planning; added an interpretation model for the first deterministic upstream host packet; added cross-reference map. |
| `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md` | Strengthened the non-ownership statement, pointed downstream hosts to `CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` first, and made the host-packet non-adoption rule explicit. |
| `docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md` | Added classification label, non-adoption rule, and cross-link to the host-packet interpretation model. |
| `docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md` | Added explicit non-authority marker, classification label, supersession note, and stronger downstream reading order. |
| `docs/spec/core-engine/CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md` | Added classification label and stronger downstream-host reading guidance. |
| `docs/IN_PROGRESS_FEATURE_WORKLIST.md` | Updated IP-13 to point downstream hosts at `CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md` as the single entry point. |

### Authoritative Doc Set DNA OneCalc Should Now Use In OxCalc

Canonical local reference:
1. `README.md`
2. `CHARTER.md`
3. `OPERATIONS.md`
4. `CURRENT_BLOCKERS.md`
5. `docs/IN_PROGRESS_FEATURE_WORKLIST.md`
6. `docs/spec/README.md`
7. `docs/spec/core-engine/CORE_ENGINE_DOWNSTREAM_HOST_SEAM_REFERENCE.md`
8. `docs/spec/core-engine/CORE_ENGINE_ARCHITECTURE.md`
9. `docs/spec/core-engine/CORE_ENGINE_COORDINATOR_AND_PUBLICATION.md`
10. `docs/spec/core-engine/CORE_ENGINE_OXFML_SEAM.md`

Supporting companions:
11. `docs/spec/core-engine/CORE_ENGINE_OXFML_MINIMAL_UPSTREAM_HOST_INTERFACES.md`
12. `docs/spec/core-engine/CORE_ENGINE_TREECALC_SEMANTIC_COMPLETION_PLAN.md`

Temporary planning:
13. `docs/spec/core-engine/CORE_ENGINE_TREECALC_OXFML_SEAM_NEGOTIATION_MATRIX.md`

### Remaining Gaps
1. OxFml does not yet provide a single frozen DNA OneCalc integration contract.
2. Caller-anchor and address-mode carriage remains narrower-than-final.
3. Execution-restriction transport shape remains provisional.
4. Publication/topology consequence breadth remains provisional.
5. Broader registered-external execution semantics remain narrower than the eventual seam.
6. OxFml language-service integration still needs upstream closure.
7. No `Ox*` repo currently owns a stable `SpreadsheetML 2003` isolated-instance persistence contract.
