**1. Consolidated Best Output**

**Source Register**

| Source ID | Description |
|---|---|
| SRC-U1 | User instruction: no tool use; text-only synthesis |
| SRC-P1 | Prompt 1: abstraction-to-conformance mapping with source IDs |
| SRC-P2 | Prompt 2: abstraction-to-empirical mapping with run IDs and Excel anchors |
| SRC-P3 | Prompt 3: overlap/conflict cases + resolution policy |
| SRC-P4 | Prompt 4: prioritized backlog (spec-only, empirical-only, mixed) |
| SRC-P5 | Prompt 5: promotion notes for core model/reference docs |
| SRC-COD | Codex base output (provenance-first schema, backlog gating, unresolved anchors) |
| SRC-CLA | Claude base output (insufficient-evidence warning; anti-fabrication gate) |
| SRC-GEM | Gemini base output (candidate domain mappings/EMP findings, unverified in provided text) |
| SRC-RUN | Run ID: `20260301-203623-cell-abstraction-pass-03-conformance-mapping` |

**Prompt 1: Abstraction-to-Conformance Mapping**

| Map ID | Abstraction ID | Conformance Requirement | Mapped Claim | Status | Source IDs | Backlog ID |
|---|---|---|---|---|---|---|
| MAP-001 | AM-PROV-001 | Every mapped claim has provenance | Include `source_ids` on every row | met | SRC-P1, SRC-COD | - |
| MAP-002 | AM-BKL-001 | Unresolved claims are explicit | Require `backlog_id` when status is not `met` | met | SRC-COD | - |
| MAP-003 | AM-AUTO-001 | Mapping is automation-ready | Stable IDs + normalized statuses | met | SRC-COD | - |
| MAP-004 | AM-XCONF-001 | Provide abstraction-to-conformance crosswalk | This section provides the crosswalk | met | SRC-P1 | - |
| MAP-005 | AM-XEMP-001 | Include empirical anchors in conformance context | Requirement acknowledged; anchors incomplete in current text | partial | SRC-P2, SRC-COD | BL-EMP-001 |
| MAP-006 | AM-CONFLICT-001 | Define overlap/conflict governance | Policy defined below and applied | met | SRC-P3, SRC-COD, SRC-CLA | - |
| MAP-007 | AM-CELL-DOMAIN-001 | Domain-level cell abstractions mapped to authoritative refs | Gemini provides candidates, but provenance is unverified here | unresolved | SRC-GEM, SRC-CLA | BL-MIX-003 |

**Prompt 2: Abstraction-to-Empirical Mapping (Run + Excel Anchors)**

| Emp Map ID | Abstraction ID | Empirical Finding / Check | Run ID Anchor | Excel Version Anchor | Evidence State | Source IDs | Backlog ID |
|---|---|---|---|---|---|---|---|
| EMP-001 | AM-PROV-001 | Provenance field present in mapping artifacts | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-N/A(TEXT_ONLY)` | provisional | SRC-RUN, SRC-COD | BL-MIX-001 |
| EMP-002 | AM-BKL-001 | Non-met claims link to backlog IDs | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-N/A(TEXT_ONLY)` | provisional | SRC-RUN, SRC-COD | BL-MIX-002 |
| EMP-003 | AM-XEMP-001 | Required workbook/sheet/range anchors are missing | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-TBD` | unresolved | SRC-P2, SRC-COD | BL-EMP-001 |
| EMP-004 | AM-XRUN-001 | Single-run evidence only; no reproducibility/trend view | `20260301-203623-cell-abstraction-pass-03-conformance-mapping` | `XLS-TBD` | unresolved | SRC-RUN, SRC-COD | BL-EMP-002 |
| EMP-005 | AM-CELL-DOMAIN-001 | Candidate EMP set (`EMP-0001..EMP-0010`) reported by Gemini | `excel-probe-run-*` / `rtd-server-probe-01` (reported) | `O365/v2401` (reported) | candidate-unverified | SRC-GEM, SRC-CLA | BL-MIX-003 |

**Prompt 3: Overlap/Conflict Cases + Resolution Policy**

| Case ID | Overlap/Conflict | Resolution |
|---|---|---|
| OC-001 | Need output now vs insufficient primary artifacts | Deliver process-level mapping; mark domain-level claims unresolved |
| OC-002 | Gemini detailed findings vs missing provenance in provided text | Keep as candidate evidence only; no promotion |
| OC-003 | Prompt requires Excel anchors but text lacks workbook/sheet/range | Mark unresolved and backlog; do not infer missing anchors |
| OC-004 | Promotion pressure vs unresolved empirical evidence | Promote schema/process rules only; defer behavior claims |

Resolution policy:
1. Use evidence tiers: `verified-from-text` > `candidate-reported` > `inferred`.
2. Hard gates: every claim needs `source_ids`; every non-`met` claim needs `backlog_id`.
3. Empirical promotion gate: require `run_id` + normalized `excel_anchor` (`<workbook>@<version>:<sheet>!<range>`).
4. No fabrication rule: missing anchors remain unresolved.
5. If spec docs later conflict, apply precedence noted in AGENTS: `CHARTER` > `ARCHITECTURE_AND_REQUIREMENTS` > `OPERATIONS` > `notes`.

**Prompt 4: Prioritized Follow-Up Backlog**

| Backlog ID | Priority | Category | Task | Exit Criterion |
|---|---|---|---|---|
| BL-SPEC-001 | P0 | spec-only | Define canonical `excel_anchor` grammar and validator | Grammar approved; validator passes sample corpus |
| BL-SPEC-002 | P0 | spec-only | Extract authoritative abstraction inventory (`AM-*`) from core model docs | Complete abstraction list with IDs |
| BL-SPEC-003 | P1 | spec-only | Define formal rule for empirical override tags | Override policy documented and versioned |
| BL-EMP-001 | P0 | empirical-only | Populate workbook/version/sheet/range for all empirical rows | `XLS-TBD` count = 0 |
| BL-EMP-002 | P1 | empirical-only | Add at least one additional run per abstraction for reproducibility | Multi-run linkage available |
| BL-EMP-003 | P1 | empirical-only | Validate Gemini candidate EMP rows against primary artifacts | Each candidate marked verified/rejected |
| BL-MIX-001 | P0 | mixed evidence | Enforce provenance completeness check in checklist generation | 100% rows have non-empty `source_ids` |
| BL-MIX-002 | P0 | mixed evidence | Enforce unresolved-to-backlog linkage | 0 non-`met` rows without backlog |
| BL-MIX-003 | P1 | mixed evidence | Build conflict register for candidate vs verified claims | All conflicts resolved or explicitly deferred |

**Prompt 5: Promotion Notes**

Promote now:
- Add conformance evidence contract and gating semantics to [CORE_ENGINE_FORMAL_MODEL.md](C:/Work/DnaCalc/Foundation/CORE_ENGINE_FORMAL_MODEL.md).
- Add a register template to [CONFORMANCE_EVIDENCE_REGISTER.md](C:/Work/DnaCalc/Foundation/CONFORMANCE_EVIDENCE_REGISTER.md) (new/proposed).

Promotion draft:

```markdown
## Conformance Evidence Contract

Each claim MUST include:
- claim_id
- abstraction_id
- requirement_id
- status (met|partial|unresolved|candidate)
- source_ids

Each empirical claim MUST also include:
- run_id
- excel_anchor (<workbook>@<version>:<sheet>!<range>)

If status != met, backlog_id is REQUIRED.

Promotion gates:
- Process/schema claims may be promoted when status = met.
- Empirical behavior claims may be promoted only after anchor-complete verification.
```

Do not promote now:
- Any domain-specific EMP override from SRC-GEM until BL-EMP-003 closes.

---

**2. Conflict Resolution Notes**

| Input | Kept | Modified | Rejected |
|---|---|---|---|
| Codex base | Provenance-first schema, backlog discipline, unresolved anchor handling | Framed as consolidated output with explicit evidence tiers | None |
| Claude base | Anti-fabrication rule and sufficiency gate | Converted from full refusal into gating policy while still delivering process-level output | Full-stop refusal |
| Gemini base | Candidate abstraction/finding ideas | Downgraded to `candidate-unverified` pending artifact validation | Any direct promotion of EMP claims as established fact |

---

**3. Residual Uncertainties**

| ID | Uncertainty | Impact | Needed to Close |
|---|---|---|---|
| U-001 | True domain abstraction inventory not present in provided text | Crosswalk remains process-level | Extract and cite concrete `AM-*` nodes from core docs |
| U-002 | No workbook/sheet/range Excel anchors | Empirical conformance cannot be verified | Populate normalized anchors per claim |
| U-003 | Single run ID in grounded evidence | No reproducibility/trend confidence | Add additional run IDs tied to same abstractions |
| U-004 | Gemini EMP set lacks primary provenance in this text | Risk of importing fabricated/incorrect behaviors | Verify each EMP row against source artifacts |
| U-005 | Automation contract not yet executable | Checklist generation may drift | Publish strict schema + validator + CI gate |

---

**4. Immediate Next Actions**

1. Approve the evidence contract text for promotion into [CORE_ENGINE_FORMAL_MODEL.md](C:/Work/DnaCalc/Foundation/CORE_ENGINE_FORMAL_MODEL.md).
2. Create or update [CONFORMANCE_EVIDENCE_REGISTER.md](C:/Work/DnaCalc/Foundation/CONFORMANCE_EVIDENCE_REGISTER.md) with required columns.
3. Execute BL-EMP-001 first: fill all `excel_anchor` fields to eliminate `XLS-TBD`.
4. Execute BL-EMP-003 second: verify Gemini EMP candidates and mark verified/rejected.
5. Enable BL-MIX-001 and BL-MIX-002 CI checks so provenance and backlog gates are enforced automatically.