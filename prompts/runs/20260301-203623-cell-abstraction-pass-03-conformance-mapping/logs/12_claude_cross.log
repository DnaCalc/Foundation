Now I have the full picture across all outputs. Here is the synthesis.

---

# Pass-03 Conformance Mapping: Cross-Model Synthesis

**Run:** `20260301-203623-cell-abstraction-pass-03-conformance-mapping`

---

## 1. Consolidated Best Output

### Source Register

| Source ID | Description |
|---|---|
| SRC-COD | Codex base output: process-level schema, provenance gating, backlog discipline |
| SRC-CLA | Claude base output: anti-fabrication refusal (converted to gating policy) |
| SRC-GEM | Gemini base output: domain-level Cell.* mappings and EMP-0001..0010 candidates |
| SRC-XC1 | Codex cross-synthesis (integrated all three bases) |
| SRC-P1..P5 | Prompt sequence items 1 through 5 |
| SRC-RUN | Run ID `20260301-203623-cell-abstraction-pass-03-conformance-mapping` |

### Prompt 1 — Abstraction-to-Conformance Mapping (with source IDs)

Two tiers are required: **process-level** (grounded in the run's own text) and **domain-level** (candidate, from Gemini, unverified against primary artifacts).

**Tier A — Process-Level (Verified)**

| Map ID | Abstraction ID | Conformance Requirement | Mapped Claim | Status | Source IDs | Backlog |
|---|---|---|---|---|---|---|
| MAP-001 | AM-PROV-001 | Every claim carries provenance | `source_ids` present on every row | met | SRC-P1, SRC-COD | — |
| MAP-002 | AM-BKL-001 | Unresolved items are explicit backlog entries | `backlog_id` required when status != met | met | SRC-COD | — |
| MAP-003 | AM-AUTO-001 | Output supports checklist generation | Stable IDs (`MAP-*`, `CR-*`, `BL-*`) + normalized statuses | met | SRC-COD | — |
| MAP-004 | AM-XCONF-001 | Abstraction-to-conformance crosswalk delivered | This section | met | SRC-P1 | — |
| MAP-005 | AM-XEMP-001 | Empirical anchors in conformance context | Anchors acknowledged; Excel anchors incomplete | partial | SRC-P2, SRC-COD | BL-EMP-001 |
| MAP-006 | AM-CONFLICT-001 | Overlap/conflict governance defined | Policy in Prompt 3 section | met | SRC-P3, SRC-COD, SRC-CLA | — |
| MAP-007 | AM-BACKLOG-001 | Prioritized backlog across three evidence types | Prompt 4 section | met | SRC-P4, SRC-COD | — |
| MAP-008 | AM-PROMO-001 | Promotion notes drafted | Prompt 5 section | met | SRC-P5, SRC-COD | — |
| MAP-009 | AM-STRUCT-001 | Five required output sections delivered | Sections 1..5 present | met | SRC-COD | — |

**Tier B — Domain-Level (Candidate-Unverified)**

These originate from Gemini. They are structurally plausible but **not grounded in artifacts available within this run's text**. Each must be verified against primary sources before promotion.

| Map ID | Formal Model Item | Conformance Domain | Candidate Source Ref | Status | Source IDs | Backlog |
|---|---|---|---|---|---|---|
| MAP-D01 | `Cell.Value.Type` | Scalar Types | `MS-OAUT_2.2.28` | candidate | SRC-GEM | BL-EMP-003 |
| MAP-D02 | `Cell.Value.Error` | Error Enumerations | `MS-VBAL_3.1.2` | candidate | SRC-GEM | BL-EMP-003 |
| MAP-D03 | `Cell.AST.RefR1C1` | Reference Syntax | `EXC-SPEC-REF-01` | candidate | SRC-GEM | BL-EMP-003 |
| MAP-D04 | `Cell.AST.RefA1` | Reference Syntax | `EXC-SPEC-REF-02` | candidate | SRC-GEM | BL-EMP-003 |
| MAP-D05 | `Cell.AST.StructRef` | Table References | `EXC-SPEC-TBL-01` | candidate | SRC-GEM | BL-EMP-003 |
| MAP-D06 | `Cell.Eval.Spill` | Dynamic Arrays | `EXC-SPEC-DA-01` | candidate | SRC-GEM | BL-EMP-003 |
| MAP-D07 | `Cell.Eval.Volatile` | Recalculation | `EXC-SPEC-CALC-01` | candidate | SRC-GEM | BL-EMP-003 |

### Prompt 2 — Abstraction-to-Empirical Mapping (run IDs + Excel version anchors)

**Tier A — Process-Level (Grounded)**

| Emp Map ID | Abstraction ID | Finding/Check | Run ID | Excel Anchor | State | Source IDs | Backlog |
|---|---|---|---|---|---|---|---|
| EMP-001 | AM-PROV-001 | Provenance field present in artifacts | SRC-RUN | `XLS-N/A(TEXT_ONLY)` | provisional | SRC-COD, SRC-RUN | BL-MIX-001 |
| EMP-002 | AM-BKL-001 | Non-met claims link to backlog | SRC-RUN | `XLS-N/A(TEXT_ONLY)` | provisional | SRC-COD, SRC-RUN | BL-MIX-002 |
| EMP-003 | AM-XEMP-001 | Excel anchors required but absent | SRC-RUN | `XLS-TBD` | unresolved | SRC-P2, SRC-COD | BL-EMP-001 |
| EMP-004 | AM-XEMP-001 | Single run; no trend possible | SRC-RUN | `XLS-TBD` | unresolved | SRC-COD | BL-EMP-002 |
| EMP-005 | AM-AUTO-001 | Schema appears checklist-ready; generator not executed | SRC-RUN | `XLS-N/A(TEXT_ONLY)` | partial | SRC-COD | BL-SPEC-004 |

**Tier B — Domain-Level (Candidate-Unverified)**

| Emp Map ID | Formal Model Item | Empirical Finding | Reported Run | Reported Excel Version | State | Source IDs | Backlog |
|---|---|---|---|---|---|---|---|
| EMP-D01 | `Cell.AST.Parse` | EMP-0001: Double comma null parameter intersection | `excel-probe-run-alpha` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D02 | `Cell.Eval.StructRef` | EMP-0002: Dotfield error handling divergence | `excel-probe-run-alpha` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D03 | `Cell.Value.Coercion` | EMP-0003: Aggregate text-to-zero coercion | `excel-probe-run-beta` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D04 | `Cell.Eval.SpillTarget` | EMP-0004: CF spill target async UI behavior | `excel-probe-run-beta` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D05 | `Cell.Eval.SpillTarget` | EMP-0005: Table structref spill bounds `#SPILL!` | `excel-probe-run-beta` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D06 | `Cell.Bind.RTD` | EMP-0006: RTD lifecycle disconnect thresholds | `rtd-server-probe-01` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D07 | `Cell.Value.Date` | EMP-0007: 1900/1904 cross-workbook coercion | `excel-probe-run-gamma` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D08 | `Cell.Eval.Volatile` | EMP-0008: Volatility masking in INDEX/IF | `excel-probe-run-gamma` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D09 | `Cell.Eval.Func` | EMP-0009: SUMIF mixed reason code on invalid criterion | `excel-probe-run-delta` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |
| EMP-D10 | `Cell.Eval.Array` | EMP-0010: Dynamic array mixed type propagation | `excel-probe-run-delta` | O365/v2401 | candidate | SRC-GEM | BL-EMP-003 |

### Prompt 3 — Overlap/Conflict Cases and Resolution Policy

| Case | Overlap/Conflict | Resolution |
|---|---|---|
| OC-001 | Need output now vs. insufficient primary artifacts in text | Deliver grounded process-level mapping; domain-level claims held as `candidate` |
| OC-002 | Gemini domain findings are detailed but lack provenance in run text | Retain as candidate evidence; no promotion until verified against source artifacts |
| OC-003 | Prompt 2 requires Excel anchors but text has no workbook/sheet/range | Mark `unresolved`; backlog BL-EMP-001; do not fabricate anchors |
| OC-004 | Prompt 5 promotion pressure vs. unresolved empirical claims | Promote schema/process rules now; defer all behavior/domain claims |
| OC-005 | Gemini "Empirical Preeminence" principle vs. Codex conservative gating | Adopt tiered policy: engine-is-truth applies only after empirical claim is verified; until then, spec governs |
| OC-006 | Gemini UI vs. Engine separation (EMP-0004 CF async) | Adopt: UI-layer findings logged but isolated from `CORE_ENGINE_FORMAL_MODEL` evaluation path |
| OC-007 | Future spec-doc conflicts during promotion | Apply AGENTS precedence: `CHARTER` > `ARCHITECTURE_AND_REQUIREMENTS` > `OPERATIONS` > `notes` |

**Integrated Resolution Policy**

1. **Evidence tiers:** `verified-from-artifact` > `candidate-reported` > `inferred`. Only `verified` claims promote.
2. **Hard gates:** Every claim must have `source_ids`. Every non-`met` claim must have `backlog_id`.
3. **Anti-fabrication rule** (from Claude): Missing data stays missing. No anchor inference, no placeholder-as-fact.
4. **Empirical promotion gate:** Requires `run_id` + normalized `excel_anchor` (`<workbook>@<version>:<sheet>!<range>`).
5. **Empirical preeminence** (from Gemini, scoped): Once an EMP claim is verified against engine output, it overrides spec where they conflict. Tag with `[EMPIRICAL_OVERRIDE]`.
6. **UI/Engine separation** (from Gemini): Async UI findings (e.g. CF spill coloring) are excluded from the synchronous engine formal model.
7. **Version scoping:** All empirical overrides are scoped to the evaluated Excel version. Legacy behavior requires a separate compatibility-mode flag.
8. **Spec conflict rule:** Apply AGENTS doc-precedence hierarchy.

### Prompt 4 — Prioritized Follow-Up Backlog

| Backlog ID | Priority | Category | Task | Exit Criterion |
|---|---|---|---|---|
| BL-SPEC-001 | P0 | spec-only | Define canonical `excel_anchor` grammar and validation regex | Grammar approved; validator passes sample corpus |
| BL-SPEC-002 | P0 | spec-only | Extract domain abstraction inventory (`AM-*` IDs) from `CORE_ENGINE_FORMAL_MODEL.md` and pass-01/02 outputs | Complete abstraction list with stable IDs |
| BL-SPEC-003 | P1 | spec-only | Enumerate promotion target reference docs and ownership | Approved target-doc list |
| BL-SPEC-004 | P1 | spec-only | Define checklist generator pass/fail logic from mapping schema | Deterministic checklist spec published |
| BL-SPEC-005 | P1 | spec-only | Define formal rule for `[EMPIRICAL_OVERRIDE]` tagging | Override policy documented and versioned |
| BL-SPEC-006 | P2 | spec-only | MS-VBAL deep dive: trace EMP-0002 dotfield error against VBA bit-flags | Conformance note or spec gap documented |
| BL-SPEC-007 | P2 | spec-only | RTD COM teardown spec scan (Microsoft Learn) to cross-reference EMP-0006 | Spec-side RTD lifecycle documented |
| BL-EMP-001 | P0 | empirical-only | Populate workbook/version/sheet/range for all empirical claims | `XLS-TBD` count = 0 |
| BL-EMP-002 | P1 | empirical-only | Add cross-run dataset (multiple run IDs per abstraction) for reproducibility | Multi-run linkage available |
| BL-EMP-003 | P0 | empirical-only | Verify Gemini candidate EMP-0001..EMP-0010 against primary artifacts | Each candidate marked verified or rejected |
| BL-EMP-004 | P1 | empirical-only | Author probe for `#SPILL!` inside iterative-calc cyclic references | Probe executed; finding registered |
| BL-EMP-005 | P1 | empirical-only | Author probe for implicit intersection (`@`) vs dynamic array spill boundary | Probe executed; finding registered |
| BL-MIX-001 | P0 | mixed | Enforce provenance completeness check in checklist generation | 100% rows have non-empty `source_ids` |
| BL-MIX-002 | P0 | mixed | Enforce unresolved-to-backlog linkage in CI | 0 non-`met` rows without `backlog_id` |
| BL-MIX-003 | P1 | mixed | Build conflict register for candidate vs verified claims | All conflicts resolved or deferred with rationale |
| BL-MIX-004 | P1 | mixed | Incorporate verified EMP findings into `CONFORMANCE_REQUIREMENTS.csv` as test harness flags | CSV updated with boolean flags per verified EMP |
| BL-MIX-005 | P2 | mixed | Promote only claims with aligned spec+empirical evidence | Promotion gate enforced in process |

### Prompt 5 — Promotion Notes

**Promote now** (schema/process — all `met`, fully grounded):

Target: `CORE_ENGINE_FORMAL_MODEL.md`

```markdown
## Conformance Evidence Contract (Pass-03)

Each conformance claim MUST include:
- `claim_id`
- `abstraction_id`
- `requirement_id`
- `status` (`met` | `partial` | `unresolved` | `candidate`)
- `source_ids` (one or more provenance anchors)

Each empirical claim MUST also include:
- `run_id`
- `excel_anchor` (`<workbook>@<version>:<sheet>!<range>` or `XLS-N/A(TEXT_ONLY)`)

If `status != met`, `backlog_id` is REQUIRED.

Promotion gates:
- Process/schema claims may promote when status = `met`.
- Empirical behavior claims may promote only after:
  (a) excel_anchor is populated and normalized, AND
  (b) finding is verified against primary engine output.
- Once verified, empirical findings that contradict spec are tagged
  `[EMPIRICAL_OVERRIDE]` and scoped to the evaluated Excel version.
- UI-layer observations are excluded from the synchronous engine
  evaluation model and tracked separately.
```

Target: `CONFORMANCE_EVIDENCE_REGISTER.md` (new, proposed)

```markdown
## Conformance-Empirical Register

| claim_id | abstraction_id | requirement_id | run_id | excel_anchor | status | source_ids | backlog_id |
|---|---|---|---|---|---|---|---|
```

**Do NOT promote now:**
- Any Gemini domain-level `Cell.*` mapping or `EMP-0001..EMP-0010` finding until BL-EMP-003 closes.
- Gemini's "Appendix B" crosswalk draft — it contains candidate content that has not been verified.

---

## 2. Conflict Resolution Notes

| Model | What was kept | What was modified | What was rejected |
|---|---|---|---|
| **Codex** | Process-level schema, source register, provenance-first discipline, backlog gating, all `BL-*` entries, promotion draft structure | Framed as Tier A within a two-tier system; added `candidate` status value | Nothing |
| **Claude** | Anti-fabrication principle — the core objection that generating domain claims without reading source files violates the provenance constraint | Converted from a full refusal into an operational gating rule (anti-fabrication gate + tiered evidence policy) | The complete refusal to produce any output |
| **Gemini** | Domain-level Cell.* abstraction vocabulary, EMP-0001..0010 candidate findings, "Empirical Preeminence" principle, UI/Engine separation rule, version-anchoring policy, specific backlog items (probes for cyclic spill, implicit intersection, MS-VBAL deep dive, RTD lifecycle) | All domain claims downgraded to `candidate-unverified`; empirical preeminence scoped to verified findings only; promotion draft held back pending verification | Direct promotion of any EMP finding as established fact; `MAPPED` status used by Gemini (replaced with `candidate`) |

**Key synthesis decision:** Claude was right in principle but wrong in conclusion. The correct response is not refusal — it is to produce what *can* be grounded (process-level mapping) while rigorously gating what cannot (domain-level claims). Codex demonstrated the process-level approach. Gemini provided the domain vocabulary and candidate content. The synthesis layers all three.

---

## 3. Residual Uncertainties

| ID | Uncertainty | Impact | What closes it |
|---|---|---|---|
| U-001 | True domain abstraction inventory (`AM-*` for Cell nodes) not present in run text | Crosswalk is process-level only; domain crosswalk is candidate | Extract from `CORE_ENGINE_FORMAL_MODEL.md` + pass-01/02 synthesis (BL-SPEC-002) |
| U-002 | No workbook/sheet/range Excel anchors exist anywhere in this run's input | Empirical conformance cannot be verified to spec | Populate normalized anchors per finding (BL-EMP-001) |
| U-003 | Single run ID in grounded evidence | No reproducibility or trend confidence | Add additional runs (BL-EMP-002) |
| U-004 | Gemini EMP-0001..0010 lack primary provenance within this text | Risk of importing incorrect or hallucinated behaviors into the formal model | Verify each against source artifacts (BL-EMP-003) |
| U-005 | Checklist generator contract is schema-only; no executable validator exists | Automation may drift across runs | Publish strict schema + validator + CI gate (BL-SPEC-004) |
| U-006 | RTD cascading dirty-state model under abrupt server termination within nested volatile arrays | Edge case not covered by any existing probe | New probe required (from Gemini's uncertainty list) |
| U-007 | `#SPILL!` behavior inside deliberate iterative-calc cyclic references | Unknown engine state for this edge case | New probe required (BL-EMP-004) |
| U-008 | Implicit intersection (`@`) vs dynamic array spill suppression boundary | Conformance mapping gap | Dedicated mapping matrix needed (BL-EMP-005) |

---

## 4. Immediate Next Actions

1. **Approve and commit** the Conformance Evidence Contract text into `CORE_ENGINE_FORMAL_MODEL.md`.
2. **Create** `CONFORMANCE_EVIDENCE_REGISTER.md` with the register template columns.
3. **Execute BL-SPEC-002 (P0):** Extract the real `AM-*` abstraction inventory from the core model doc and pass-01/02 outputs — this unblocks domain-level crosswalk.
4. **Execute BL-EMP-001 (P0):** Populate all `excel_anchor` fields to eliminate every `XLS-TBD`.
5. **Execute BL-EMP-003 (P0):** Verify Gemini's candidate EMP-0001..0010 rows against primary artifacts — mark each verified or rejected.
6. **Enable CI gates (BL-MIX-001 + BL-MIX-002):** Provenance completeness and unresolved-to-backlog linkage checks should be enforced automatically from this point forward.
7. **Re-run domain-level crosswalk** once BL-SPEC-002 and BL-EMP-003 are closed, with all models reading the actual source files.
