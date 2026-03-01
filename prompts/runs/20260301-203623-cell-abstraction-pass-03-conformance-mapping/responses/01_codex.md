## 1. Scope And Assumptions
- Scope is limited to the text in this thread only (`SRC-U1`).
- No repository files or prior run artifacts were read, so abstraction items are inferred from the run brief/prompt requirements (`INF-1`).
- Empirical anchoring is limited to run id `20260301-203623-cell-abstraction-pass-03-conformance-mapping` (`SRC-R1`).

**Source Register**

| Source ID | Provenance |
|---|---|
| SRC-U1 | User instruction: no tool use; work only from provided text |
| SRC-R1 | Run id: `20260301-203623-cell-abstraction-pass-03-conformance-mapping` |
| SRC-RB1 | Objective: explicit crosswalk from abstract model items to conformance requirements/references/empirical findings |
| SRC-RB2 | Constraint: every mapped claim must carry source provenance |
| SRC-RB3 | Constraint: unresolved items must be explicit backlog entries |
| SRC-RB4 | Constraint: output should support future automated conformance checklist generation |
| SRC-P1 | Prompt 1: abstraction-to-conformance mapping with source IDs |
| SRC-P2 | Prompt 2: abstraction-to-empirical mapping with run IDs and Excel anchors |
| SRC-P3 | Prompt 3: overlap/conflict and resolution policy |
| SRC-P4 | Prompt 4: prioritized follow-up backlog (spec-only, empirical-only, mixed) |
| SRC-P5 | Prompt 5: promotion notes for `CORE_ENGINE_FORMAL_MODEL.md` and/or reference docs |
| SRC-O1 | Required output sections (1..5) |
| SRC-A1 | AGENTS doctrine: doc conflict precedence (`CHARTER` > `ARCHITECTURE_AND_REQUIREMENTS` > `OPERATIONS` > `notes/BRAINSTORM_NOTES`) |

## 2. Response To Prompt Sequence

### 2.1 Prompt 1: Abstraction-to-Conformance Mapping (with source IDs)

| Map ID | Abstract Item ID | Abstract Item | Conformance Req ID | Requirement | Reference Anchor | Mapped Claim | Status | Basis | Source IDs | Backlog ID |
|---|---|---|---|---|---|---|---|---|---|---|
| MAP-001 | AM-PROV-001 | Provenance-bound claims | CR-001 | Every mapped claim must include provenance | RunBrief.Constraint.1 | All mapping rows in this response include `Source IDs` | met | direct | SRC-RB2, SRC-P1 | - |
| MAP-002 | AM-BKL-001 | Explicit unresolved evidence tracking | CR-002 | Unresolved items must remain explicit backlog entries | RunBrief.Constraint.2 | Partial/unresolved mappings link to backlog IDs | met | direct | SRC-RB3 | - |
| MAP-003 | AM-AUTO-001 | Automation-ready mapping schema | CR-003 | Output supports checklist generation | RunBrief.Constraint.3 | Stable IDs (`MAP-*`, `CR-*`, `BL-*`) and normalized statuses are used | met | inferred from direct requirement | SRC-RB4 | - |
| MAP-004 | AM-XCONF-001 | Abstraction-to-conformance crosswalk | CR-004 | Provide abstraction-to-conformance mapping table with source IDs | PromptSequence.1 | Section 2.1 fulfills required table | met | direct | SRC-P1 | - |
| MAP-005 | AM-XEMP-001 | Abstraction-to-empirical crosswalk | CR-005 | Provide abstraction-to-empirical table with run ID + Excel anchor | PromptSequence.2 | Section 2.2 includes run/Excel fields; Excel anchors remain missing | partial | direct | SRC-P2, SRC-R1 | BL-EMP-001 |
| MAP-006 | AM-CONFLICT-001 | Overlap/conflict governance | CR-006 | Identify overlaps/conflicts and define resolution policy | PromptSequence.3 | Section 2.3 defines precedence and handling rules | met | direct | SRC-P3 | - |
| MAP-007 | AM-BACKLOG-002 | Prioritized evidence backlog | CR-007 | Provide prioritized backlog across three evidence types | PromptSequence.4 | Section 5 provides prioritized spec-only / empirical-only / mixed backlog | met | direct | SRC-P4 | - |
| MAP-008 | AM-PROMO-001 | Promotion guidance to formal model/docs | CR-008 | Draft promotion notes for core model/reference docs | PromptSequence.5 | Section 4 includes promotion-ready draft text | met | direct | SRC-P5 | - |
| MAP-009 | AM-STRUCT-001 | Required sectioned output contract | CR-009 | Deliver the five required output sections | OutputSections | Response is organized into sections 1..5 exactly | met | direct | SRC-O1 | - |

### 2.2 Prompt 2: Abstraction-to-Empirical Mapping (run IDs + Excel anchors)

| Emp Map ID | Abstract Item ID | Empirical Finding / Check | Run ID Anchor | Excel Version Anchor | Evidence State | Basis | Source IDs | Backlog ID |
|---|---|---|---|---|---|---|---|---|
| EMP-001 | AM-PROV-001 | Mapping rows include provenance field | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-N/A(TEXT_ONLY)` | provisional | inferred from produced artifact | SRC-RB2, SRC-P1, SRC-R1 | BL-MIX-001 |
| EMP-002 | AM-BKL-001 | Unresolved/partial mapping rows carry backlog IDs | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-N/A(TEXT_ONLY)` | provisional | inferred from produced artifact | SRC-RB3, SRC-R1 | BL-MIX-002 |
| EMP-003 | AM-XEMP-001 | Excel anchors are required but not supplied in input evidence | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-TBD` | unresolved | direct | SRC-P2, SRC-R1 | BL-EMP-001 |
| EMP-004 | AM-XEMP-001 | Only one run anchor is available; no trend possible | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-TBD` | unresolved | direct | SRC-R1 | BL-EMP-002 |
| EMP-005 | AM-CONFLICT-001 | Conflict cases identified, not validated against external empirical set | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-N/A(TEXT_ONLY)` | partial | inferred | SRC-P3, SRC-R1 | BL-MIX-003 |
| EMP-006 | AM-AUTO-001 | Schema appears checklist-ready but generator execution not evidenced | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-N/A(TEXT_ONLY)` | partial | inferred | SRC-RB4, SRC-R1 | BL-SPEC-004 |

### 2.3 Prompt 3: Overlap/Conflict Cases and Resolution Policy

| Case ID | Overlap/Conflict | Risk | Resolution Policy | Source IDs |
|---|---|---|---|---|
| OC-001 | Prompt 1 (crosswalk) overlaps with provenance constraint | Incomplete traceability if one is treated optional | Treat provenance as a hard gate on every mapping row | SRC-P1, SRC-RB2 |
| OC-002 | Prompt 2 requires Excel anchors, but no Excel evidence exists in provided text | Fabricated/assumed empirical anchors | Mark `unresolved`; create empirical backlog; do not infer anchors | SRC-P2, SRC-U1 |
| OC-003 | Prompt 5 promotion pressure vs unresolved empirical evidence | Premature promotion of unverified claims | Promote schema/process rules now; defer empirical conclusions until evidence closure | SRC-P5, SRC-RB3 |
| OC-004 | Future spec-doc conflicts during promotion | Inconsistent normative interpretation | Apply AGENTS precedence: `CHARTER` > `ARCHITECTURE_AND_REQUIREMENTS` > `OPERATIONS` > `notes` | SRC-A1 |

**Resolution Policy (operational)**
1. Hard gates: provenance present, unresolved items backlog-linked (`SRC-RB2`, `SRC-RB3`).
2. Evidence sufficiency: empirical claims require run+Excel anchors; missing anchors remain unresolved (`SRC-P2`).
3. Promotion rule: only `met` schema/process items promote; empirical findings promote after backlog closure (`SRC-P5`, `SRC-RB3`).
4. Spec conflict rule: apply AGENTS precedence (`SRC-A1`).

### 2.4 Prompt 4
Prioritized backlog is provided in Section 5, grouped as requested: spec-only, empirical-only, mixed evidence (`SRC-P4`).

### 2.5 Prompt 5
Promotion-ready draft content is provided in Section 4 for:
- [CORE_ENGINE_FORMAL_MODEL.md](C:/Work/DnaCalc/Foundation/CORE_ENGINE_FORMAL_MODEL.md)
- A reference evidence register doc (proposed)

## 3. Uncertainties And Evidence Needs

| Uncertainty ID | Uncertainty | Impact | Evidence Needed | Backlog ID | Source IDs |
|---|---|---|---|---|---|
| U-001 | Concrete domain abstraction inventory is not present in provided text | Crosswalk is process-level, not domain-level | Extract abstraction list from formal model doc sections | BL-SPEC-002 | SRC-U1, SRC-RB1 |
| U-002 | Excel workbook/version/sheet anchors are absent | Empirical conformance cannot be fully verified | Provide workbook name, version, sheet, range per finding | BL-EMP-001 | SRC-P2 |
| U-003 | Only one run id is available | No trend or reproducibility checks | Add prior/subsequent run IDs linked to same abstraction IDs | BL-EMP-002 | SRC-R1 |
| U-004 | Checklist generator contract is not yet formalized | Automation may diverge across runs | Define strict schema and pass/fail semantics | BL-SPEC-004 | SRC-RB4 |
| U-005 | Reference-doc set beyond core model is unspecified | Promotion scope ambiguity | Enumerate target reference docs and ownership | BL-SPEC-003 | SRC-P5 |

## 4. Promotion-Ready Draft Content

**Draft for [CORE_ENGINE_FORMAL_MODEL.md](C:/Work/DnaCalc/Foundation/CORE_ENGINE_FORMAL_MODEL.md)**

```markdown
## Conformance Evidence Contract (Pass-03)

Each conformance claim MUST include:
- `claim_id`
- `abstraction_id`
- `requirement_id`
- `status` (`met|partial|unresolved|proposed`)
- `source_ids` (one or more source anchors)

Each empirical claim MUST also include:
- `run_id`
- `excel_anchor` (`<workbook>@<version>:<sheet>!<range>` or `XLS-N/A(TEXT_ONLY)`)

If `status != met`, `backlog_id` is REQUIRED.

Promotion rule:
- Promote schema/process claims when `met`.
- Keep empirical claims provisional until anchor-complete and verified.
```
Provenance: `SRC-RB2`, `SRC-RB3`, `SRC-RB4`, `SRC-P2`, `SRC-P5`.

**Draft for reference doc (proposed) [CONFORMANCE_EVIDENCE_REGISTER.md](C:/Work/DnaCalc/Foundation/CONFORMANCE_EVIDENCE_REGISTER.md)**

```markdown
## Conformance-Empirical Register

| claim_id | abstraction_id | requirement_id | run_id | excel_anchor | status | source_ids | backlog_id |
|---|---|---|---|---|---|---|---|
```
Provenance: `SRC-RB4`, `SRC-P1`, `SRC-P2`.

## 5. Follow-Up Backlog

| Backlog ID | Priority | Category | Task | Exit Criterion | Source IDs |
|---|---|---|---|---|---|
| BL-SPEC-001 | P0 | spec-only | Define canonical `excel_anchor` format and validation regex | Schema accepted and documented | SRC-P2, SRC-RB4 |
| BL-SPEC-002 | P0 | spec-only | Extract domain abstraction inventory into `AM-*` IDs from core model | Full abstraction list mapped to requirements | SRC-RB1 |
| BL-SPEC-003 | P1 | spec-only | Enumerate promotion target reference docs and ownership | Approved target-doc list | SRC-P5 |
| BL-SPEC-004 | P1 | spec-only | Define checklist generator pass/fail logic from mapping schema | Deterministic checklist spec published | SRC-RB4 |
| BL-EMP-001 | P0 | empirical-only | Populate Excel anchors (workbook/version/sheet/range) for all empirical claims | `XLS-TBD` count reaches zero | SRC-P2 |
| BL-EMP-002 | P1 | empirical-only | Add cross-run dataset (multiple run IDs per abstraction) | Trend-ready run linkage available | SRC-R1 |
| BL-EMP-003 | P1 | empirical-only | Validate provisional empirical findings against raw artifacts | Findings marked verified/unverified | SRC-P2 |
| BL-MIX-001 | P0 | mixed evidence | Auto-check provenance completeness across all mappings | 100% claims with non-empty `source_ids` | SRC-RB2, SRC-RB4 |
| BL-MIX-002 | P0 | mixed evidence | Enforce unresolved→backlog linkage in CI/checklist | 0 unresolved claims without backlog ID | SRC-RB3, SRC-RB4 |
| BL-MIX-003 | P1 | mixed evidence | Validate overlap/conflict cases against both docs and empirical outputs | Conflict register resolved or accepted with rationale | SRC-P3, SRC-A1 |
| BL-MIX-004 | P2 | mixed evidence | Promote only claims with aligned spec+empirical evidence | Promotion gate rule enforced in process | SRC-P5, SRC-RB3 |