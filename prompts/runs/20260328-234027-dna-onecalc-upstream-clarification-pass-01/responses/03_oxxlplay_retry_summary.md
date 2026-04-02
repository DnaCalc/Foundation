All edits are clean. Here is the summary.

---

## Changed Files

| File | Change |
|---|---|
| `docs/spec/OXXLPLAY_ONECALC_OBSERVATION_CONSUMER_CONTRACT.md` | **New.** Canonical `OxXlPlay`-side observation-consumer contract for `DNA OneCalc`. |
| `docs/spec/README.md` | Indexed the new doc as item 9, added a `Downstream consumer references` section. |
| `docs/spec/OXXLPLAY_SCOPE_AND_BOUNDARY.md` | Added `Platform scope` (Section 6) and `Downstream consumer contract` (Section 7) cross-link sections. |
| `docs/spec/OXXLPLAY_ARCHITECTURE_AND_CAPTURE_MODEL.md` | Added `Downstream surface classification rule` (Section 7) cross-link. |
| `docs/spec/OXXLPLAY_BUNDLE_EMISSION_AND_HANDOFF_MODEL.md` | Added `Downstream consumer labeling rule` (Section 7) cross-link for lossy-view interpretation. |
| `docs/IN_PROGRESS_FEATURE_WORKLIST.md` | Added `Downstream consumer contract status` section documenting the new contract and remaining gaps. |

## Authoritative OxXlPlay Doc Set For DNA OneCalc

The new consumer contract (Section 8) enumerates the full reference set. The primary entry point is:

**`docs/spec/OXXLPLAY_ONECALC_OBSERVATION_CONSUMER_CONTRACT.md`**

Supported by the existing spec docs for scope, capture model, provenance, bundle/handoff, capability ladder, and scenario register, plus W006/W007 test-run evidence.

## Remaining Gaps

1. Only one observation family (`xlplay_capture_values_formulae_001`) is exercised live.
2. Comparison envelope is narrow: cell value and formula text only.
3. No formatting, conditional-formatting, display-state, or error-surface observations exist.
4. The `OxCalc` comparison leg of W007 is open.
5. The normalized replay view is explicitly lossy.
6. The richer diff/equality envelope (OneCalc spec Section 17.2) is provisional, not current capability.
7. Adapter-manifest expectations between `OxXlPlay` and `OxReplay` have open clarification items.
