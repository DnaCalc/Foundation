*Posted by Codex agent on behalf of @govert*

# Consistency Audit and Refactor Suggestions

## Source-of-Truth Resolution Order Used
`CHARTER.md` → `ARCHITECTURE_AND_REQUIREMENTS.md` → `OPERATIONS.md` → `notes/BRAINSTORM_NOTES.md`

## 1) Contradictions or Duplications with Recommended Resolution

| Type | Location | Finding | Recommended resolution |
|---|---|---|---|
| Duplication | `CHARTER.md` §3.1 and `OPERATIONS.md` §7 | Round naming (`DnaVisiCalc`, `DnaPreCalc`, `DnaSuperCalc`, `DnaCalc`) is duplicated verbatim. | Keep canonical naming in `CHARTER.md` only. Replace `OPERATIONS.md` §7 with a one-line reference to Charter. |
| Duplication | `CHARTER.md` §3.2 and `OPERATIONS.md` §2.1 | Team structure (Green/Red/Blue/Logistics) appears in both docs. | Keep role definitions and veto/process semantics in `OPERATIONS.md`; keep only high-level identity in `CHARTER.md`. |
| Category mix | `ARCHITECTURE_AND_REQUIREMENTS.md` §2 | “Requirements Taxonomy (how to write requirements)” is process/doctrine guidance inside architecture doc. | Move authoring guidance to `OPERATIONS.md` (new section), keep only the resulting requirement model/IDs in architecture doc. |
| Category mix | `ARCHITECTURE_AND_REQUIREMENTS.md` §7 | “Rounds 1–3 Forward Compatibility” is roadmap/program planning content, not architecture. | Move to `OPERATIONS.md` as round progression policy and exit-gate linkage. |
| Soft conflict (unresolved scope) | `ARCHITECTURE_AND_REQUIREMENTS.md` §3.6 vs `notes/BRAINSTORM_NOTES.md` §N | Architecture says Pathfinder UDFs include “scalar + optional range inputs (scoped decision)”; notes still list range scope as open. | Make a single explicit Round-0 decision in architecture requirements (with IDs), then remove that item from notes open questions. |
| Soft conflict (unresolved policy) | `CHARTER.md` §2.1 vs `notes/BRAINSTORM_NOTES.md` §F, §N | Charter requires determinism-first; notes keep float reduction/scheduling determinism policy open. | Add a normative determinism policy section in architecture (or profile spec reference) and track variants by profile version. |
| Coverage gap | `CHARTER.md` §4 and `OPERATIONS.md` | Clean-room doctrine exists, but operations doc lacks an explicit evidence workflow section. | Add an operations section defining evidence record workflow and linkage to REQ/INT/REAL IDs. |

## 2) Missing IDs/Sections That Should Exist

### Missing IDs
- `REQ-###` IDs are not present even though REQ taxonomy is declared.
- `INT-###` and `REAL-###` are shown as examples only; they need a complete paired catalog.
- `PACK-###` IDs are implied by names (`PACK.*`) but there is no stable ID schema, owner, or pass criteria table.
- `TERM-###` or equivalent glossary IDs are missing for overloaded terms (`stabilized`, `stale`, `pending`, `degrade`, `opaque`, `meta-epoch commit`).
- `DEC-###` (decision records) are missing for currently open policy choices in notes.

### Missing Sections
- `ARCHITECTURE_AND_REQUIREMENTS.md`: **Normative Definitions** section for status vocabulary and degradation modes.
- `ARCHITECTURE_AND_REQUIREMENTS.md`: **Requirements Catalog** section with full IDed REQ/INT/REAL entries.
- `OPERATIONS.md`: **Requirements Authoring and ID Rules** section (where taxonomy/process belongs).
- `OPERATIONS.md`: **Clean-room Evidence Workflow** section (admissible evidence, record format, review gates).
- `OPERATIONS.md`: **Open Decisions Register** section (links unresolved items to owners and due round).

## 3) Proposed Doc Edits (Exact Headings and Where to Move Text)

### Move/Refactor Plan

| Action | From | To | Exact heading(s) |
|---|---|---|---|
| Move roadmap content out of architecture | `ARCHITECTURE_AND_REQUIREMENTS.md` §7 | `OPERATIONS.md` | New `## 8. Round Progression and Exit Coupling` |
| Move requirement-writing doctrine out of architecture | `ARCHITECTURE_AND_REQUIREMENTS.md` §2 | `OPERATIONS.md` | New `## 9. Requirements Authoring Rules (REQ/CONSTR/INT/REAL)` |
| Remove duplicated round names | `OPERATIONS.md` §7 | Reference `CHARTER.md` §3.1 | Replace with `## 7. Round Name Reference` (single pointer line) |
| Reduce duplicated org details | `CHARTER.md` §3.2 detail bullets | Keep operational detail in `OPERATIONS.md` §2.1 | Keep concise role identity only in Charter |
| Normalize requirement catalog | `ARCHITECTURE_AND_REQUIREMENTS.md` §5 | Same file | Replace with `## 5. Requirements Catalog (REQ-###, INT-###, REAL-###)` |
| Add normative term definitions | distributed references | `ARCHITECTURE_AND_REQUIREMENTS.md` or `CHARTER.md` glossary | New `## 8. Normative Status Vocabulary` (if in Architecture) or expand `CHARTER.md` §5 |
| Operationalize clean-room doctrine | implicit in Charter/notes | `OPERATIONS.md` | New `## 10. Clean-Room Evidence and Review Gate` |
| Track unresolved notes as decisions | `notes/BRAINSTORM_NOTES.md` §N | `OPERATIONS.md` | New `## 11. Open Decisions Register (DEC-###)`; keep notes as ideation only |

### Minimal Structural Diagram

```text
CHARTER (mission/doctrine/glossary)
    -> ARCHITECTURE_AND_REQUIREMENTS (REQ/CONSTR/INT/REAL + architecture)
        -> OPERATIONS (packs/gates/process/tooling/decision control)
            -> BRAINSTORM_NOTES (non-normative idea backlog)
```

## 4) Docs Hygiene Checklist (Short)

- Add/update IDs for any normative statement (`REQ/CONSTR/INT/REAL/PACK/DEC`) in the same change.
- Keep one canonical home per topic; elsewhere, reference instead of duplicating text.
- Separate normative vs informative sections explicitly in each doc.
- If notes contain an open question that affects behavior, create a `DEC-###` entry with owner and target round.
- When terms drive tests/gates (`stale`, `stabilized`, `opaque`), define them once in a normative glossary.
- Require cross-doc link checks in review: each REQ must map to architecture and at least one pack/gate.
- For every moved section, leave a short pointer in old location for one revision cycle.

## Smallest Next Actions (Biggest Risk Reduction)

1. Create IDed requirements catalog in `ARCHITECTURE_AND_REQUIREMENTS.md` (first pass: REQ/INT/REAL only).
2. Move taxonomy/process text into `OPERATIONS.md` and add clean-room evidence workflow.
3. Delete duplicate round/team text and replace with canonical cross-references.
4. Convert notes open questions with behavioral impact into `DEC-###` entries with owners.
