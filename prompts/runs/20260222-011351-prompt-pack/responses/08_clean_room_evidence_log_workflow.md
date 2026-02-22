*Posted by Codex agent on behalf of @govert*

# 08_clean_room_evidence_log_workflow

## Contradictions and Resolution
- No direct contradiction was found across `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, and `notes/BRAINSTORM_NOTES.md` on clean-room intent.
- Operational gap: clean-room evidence is mandated (`CHARTER.md` 2.1.6, 4; brainstorm section I) but there is no concrete lifecycle or record schema in operations requirements.

Proposed coherent resolution:

| Target doc | Exact heading/ID to add | Why |
|---|---|---|
| `OPERATIONS.md` | `## 8. Clean-room Evidence Workflow` | Makes capture/review/publish steps mandatory and repeatable. |
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `CONSTR-006: Compatibility claims require evidence records` | Prevents unbacked behavioral claims in spec/implementation. |
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `REAL-EVID-001: Evidence linkage for REQ/INT/REAL` | Makes traceability machine-checkable. |

## Practical Workflow

```text
Claim Intake -> Evidence Capture -> Harness Reproduction -> Spec Linkage -> Review Gate -> Publish + Pack Link
```

Checklist:
- Create a claim ticket with proposed behavior statement and candidate `REQ-/INT-/REAL-` IDs.
- Capture admissible evidence only (table below).
- Reproduce behavior with a committed harness and pinned Excel profile.
- Store artifacts (inputs, outputs, logs, hashes) and generate one evidence record.
- Link record to spec IDs and obligation pack(s).
- Run review gate (Green-owned; Red/Blue aware) before marking claim usable.

## 1) Admissible Evidence

| Class | Admissible | Required acceptance conditions | Not admissible |
|---|---|---|---|
| `DOC` | Public Microsoft docs, ISO/ECMA OOXML text, publicly accessible vendor notes | Public URL, access date, quote/section pointer, license-safe citation | Leaked/private docs, NDA material, internal emails, private support tickets |
| `OBS` | Observed Excel behavior from reproducible harness runs | Harness repo path + commit, deterministic input artifact, environment profile, rerun command, output hashes | Manual one-off observations without harness, screenshots without replay path |
| `MIXED` | Doc + observed run together for ambiguous areas | Both `DOC` and `OBS` fields complete; conflict status explicitly set | Hand-wavy "Excel does this" claims without linked artifacts |

Minimum rule to declare a compatibility claim:
- One `OBS` record is mandatory.
- One `DOC` record is strongly preferred; if absent, claim status must be `provisional` and feature-gated until corroborated.

## 2) Evidence Record Format (Required Fields)

Record schema (single markdown/json artifact per claim):

| Field | Required | Description |
|---|---|---|
| `evidence_id` | Yes | Stable ID, e.g. `EVID-2026-02-22-001` |
| `claim_id` | Yes | Human-stable claim key, e.g. `CLAIM-STRUCT-INSERT-REFSHIFT` |
| `status` | Yes | `provisional`, `accepted`, `superseded`, `rejected` |
| `evidence_class` | Yes | `DOC`, `OBS`, or `MIXED` |
| `behavior_statement` | Yes | Single testable sentence describing expected behavior |
| `excel_surface` | Yes | Formula, calc mode, file IO, UI, VBA blob, RTD/UDF, etc. |
| `excel_profile` | Yes | Profile key (see version section) |
| `excel_version_details` | Yes | Version/build/channel/OS/locale |
| `recalc_mode` | Yes | Manual/Auto and related options |
| `input_artifacts` | Yes | Paths + SHA256 hashes |
| `harness_ref` | Yes | Harness path + commit SHA + command line |
| `observed_output_artifacts` | Yes | Paths + SHA256 hashes |
| `public_sources` | Conditional | Required for `DOC`/`MIXED`; URL + section pointer + accessed date |
| `spec_links` | Yes | Linked `REQ-`, `INT-`, `REAL-` IDs |
| `pack_links` | Yes | Related obligation packs (if any) |
| `conflict_note` | Yes | `none` or explicit conflict text + chosen resolution |
| `review_signoff` | Yes | Reviewer role + date (Green required) |
| `supersedes` | Conditional | Prior `evidence_id` if replacing older record |

## 3) Linking Evidence to `REQ/INT/REAL`

Traceability model:

```text
REQ -> INT -> REAL -> EVID (1..n)
                   \-> PACK (verification)
```

Rules:
- Every `REAL-*` must link to at least one `accepted` evidence record.
- Every evidence record must link to at least one `REAL-*`; direct `REQ-*`-only links are not sufficient.
- `INT-*` links are allowed for context, but gating is done at `REAL-*` level.
- If one evidence record supports multiple `REAL-*`, all impacted IDs must be listed explicitly.
- If evidence conflicts with an existing `REAL-*`, set record status to `provisional`, open a spec issue, and block stabilization for affected profile until resolved.

## 4) Version-Dependent Excel Behavior (Compat Versions/Profiles)

Use profile keys that separate platform/channel/version realities:

| Profile key example | Intended scope |
|---|---|
| `excel.win.current` | Current Windows 365 channel under pinned build metadata |
| `excel.win.lt2019` | Legacy Windows compatibility line |
| `excel.mac.current` | Current macOS channel |
| `excel.web.current` | Excel for web behavior where relevant |

Handling policy:
- Evidence records must always include exact build/channel metadata; profile key alone is insufficient.
- Divergent behavior across profiles creates either:
  - separate `REAL-*` per profile, or
  - one `REAL-*` with explicit profile-conditional branches.
- No "silent averaging" of behavior across versions.
- If behavior is unknown for a supported profile, mark feature as `unsupported-for-profile` with deterministic diagnostics until evidence is captured.

## 5) Anti-Footgun Rules (Never Introduce)

Never add to repo/spec stack:
- Proprietary, leaked, NDA, or access-restricted Microsoft material.
- Decompiled/disassembled artifacts, internal symbol analysis, or reverse-engineered Excel internals.
- Customer/private workbooks or telemetry traces without explicit redistribution rights.
- Compatibility claims in docs/spec/PR text that lack an `evidence_id`.
- Spec assertions that cannot be reproduced by a committed harness command.
- "Magic" behavior copied from another implementation without linked clean-room evidence.
- Evidence files that omit version/build metadata or artifact hashes.

Repository hygiene guardrails:
- Enforce evidence schema in CI lint.
- Require `evidence_id` references for changes touching `REQ/INT/REAL` behavior.
- Reject records with missing harness commit or non-replayable steps.

## Smallest High-Impact Next Actions
1. Add `## 8. Clean-room Evidence Workflow` to `OPERATIONS.md` with the lifecycle and gate rules above.
2. Add `CONSTR-006` and `REAL-EVID-001` to `ARCHITECTURE_AND_REQUIREMENTS.md` to make evidence linkage mandatory.
3. Introduce a repository evidence template file and CI validator for required fields.
4. Backfill evidence for the top 5 high-risk Excel-compat `REAL-*` items before next profile stabilization.
