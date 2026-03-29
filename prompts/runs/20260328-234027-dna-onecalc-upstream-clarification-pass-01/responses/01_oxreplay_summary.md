---

## Summary

### Files changed (7)

| File | Change |
|---|---|
| `docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md` | **Rewritten.** Expanded from 9 to 12 sections. Added: embeddable surface catalog (Section 4), mode gate discipline with per-mode capability floor matrix (Section 6), artifact-lineage obligations with lossy/unpinned/capture-loss subsections and reliability badge (Section 7), OxXlObs input labeling and interpretation rules (Section 8), full UI visibility and control guidance (Section 9), scenario promotion caution (Section 10). |
| `docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md` | Section 6: expanded embeddable strata list, added prohibitions against embedding DNA ReCalc shell and locally extending shared id families, added cross-reference to consumption model. |
| `docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md` | Section 4: added mode-gating and lossy-input visibility obligations. Section 7 interpretation rule: added observation-source and mode-gating clauses. |
| `docs/spec/DNA_RECALC_HOST.md` | Section 4: expanded what non-ReCalc hosts may do (embed strata, gate modes), added explicit prohibition against embedding ReCalc as subsystem, added cross-reference. |
| `docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md` | Section 10: restructured into 5 subsections — consumer rule, labeling rule, comparison reliability badge, interpretation caution, platform rule. |
| `docs/spec/OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md` | Section 5: added subsection 5.1 for lossy and registry-unpinned input obligations with cross-reference. |
| `docs/spec/README.md` | Consumer note section: expanded to list what the consumption model covers and which supporting sections in other specs carry downstream-consumer detail. |

### Authoritative `OxReplay` doc set `DNA OneCalc` should now use

Primary entry point:
1. `docs/spec/OXREPLAY_DNA_ONECALC_CONSUMPTION_MODEL.md` — the single canonical consumption model

Supporting specs (in reading order per `docs/spec/README.md`):
1. `docs/spec/OXREPLAY_SCOPE_AND_BOUNDARY.md` — shared-mechanics-only boundary, Section 6 for downstream consumer rule
2. `docs/spec/OXREPLAY_BUNDLE_WITNESS_AND_REGISTRY_MODEL.md` — bundle/witness/registry mechanics, Section 5 for downstream artifact obligations
3. `docs/spec/OXREPLAY_ADAPTER_AND_CONFORMANCE_MODEL.md` — adapter boundaries and capability ladder, Sections 4 and 7 for downstream floor
4. `docs/spec/DNA_RECALC_HOST.md` — explicit non-OneCalc boundary, Section 4 for relationship
5. `docs/spec/DNA_RECALC_CLI_CONTRACT.md` — reference CLI surface (not for OneCalc embedding, but for understanding the generic host command shape)
6. `docs/spec/OXREPLAY_OXXLOBS_OBSERVATION_SEAM.md` — OxXlObs seam, Section 10 for OneCalc comparison use
7. `docs/spec/OXREPLAY_CAPABILITY_AND_PACK_TRACEABILITY.md` — capability-to-pack evidence chain
8. `docs/spec/OXREPLAY_WITNESS_LIFECYCLE_TRANSITIONS.md` — lifecycle transition model

### Remaining gaps that still belong in Foundation or sibling repos

1. **Foundation**: No dedicated `DNA OneCalc` replay-governance contract exists in Foundation; the current truth is the Foundation `DNA_ONECALC_SCOPE_AND_SPEC.md` note (Section 10) plus the `OxReplay` consumption model. If OneCalc grows large enough, a Foundation-level replay-governance note for downstream proving hosts may be warranted.
2. **OxReplay**: No app-facing `DNA OneCalc` host contract analogous to `DNA_RECALC_HOST.md` exists yet. Whether one should exist in `OxReplay` or in the `DnaOneCalc` repo is an open design question.
3. **OxXlObs**: The observation seam still lacks a formal adapter capability manifest and richer registry-pinned diff structure. This is `OxXlObs` upstream documentation debt.
4. **OxFunc**: No accepted direct `OxReplay` replay-intake floor exists yet. OneCalc consumes function semantics through `OxFml` rather than through a direct `OxFunc` replay adapter.
5. **OxVba**: No accepted local replay capability floor yet. Remains a later and narrower lane.
6. **Foundation**: Broad `C4.distill_valid` and `C5.pack_valid` claims for any lane remain later evidence lanes; the current `OxCalc` `C4` lifecycle-state gap (BLK-REPLAY-002) is still active.
