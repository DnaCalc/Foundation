*Posted by Codex agent on behalf of @govert*

# Degrade/Preserve Policy Matrix (Profiles + Extensions)

## Source-of-truth check
- Documents used: `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `notes/BRAINSTORM_NOTES.md`.
- Contradiction check: no hard conflicts found.
- Resolution for open ambiguity in `notes/BRAINSTORM_NOTES.md` ("export degradation: cell errors vs metadata/comments vs both"): use both, with machine-readable diagnostics as primary and cell/UI markers as user-visible projection.

## Policy vocabulary (normative)
- `Native`: feature is fully supported in current `profile_id/profile_version` and build capabilities.
- `Lowered`: feature is transformed to a supported subset with declared, deterministic rewrite rules.
- `Opaque`: feature is preserved byte-for-byte or payload-for-payload, but not semantically executed.
- `Rejected`: feature cannot be safely preserved or lowered for this operation/target; operation fails deterministically.

## Concrete matrix

| Policy state | Formula feature | Object model feature | File feature |
|---|---|---|---|
| `Native` | Parsed/bound/evaluated under active profile semantics. | Materialized in object model with full read/write semantics. | Adapter can parse + emit with semantic fidelity for target. |
| `Lowered` | Rewritten to profile-supported formula subset before eval/export; rewrite recorded in diagnostics. | Re-expressed as simpler supported constructs (for example style/effect flattening) with loss markers. | Export pipeline rewrites to target-safe constructs; emits explicit lossy/lossless flag. |
| `Opaque` | Formula extension payload stored but not evaluated; cell result is deterministic unsupported error. | Object subtree/payload attached as opaque extension on stable host ID; preserved on round-trip. | Unknown OOXML parts/relationships/content-types preserved and re-emitted unchanged where feasible. |
| `Rejected` | Formula cannot be parsed/lowered/preserved safely (for current operation) -> deterministic failure. | Feature requires mutation semantics unavailable in profile/build and cannot be safely stored as opaque. | Target/export mode cannot carry feature (and strict mode forbids lossy export) -> export fails. |

## Error mapping rules

### Internal diagnostic codes (stable)
- `DX1001 FormulaUnsupported`
- `DX1002 FormulaLowered`
- `DX1003 FormulaOpaque`
- `DX2001 ObjectUnsupported`
- `DX2002 ObjectLowered`
- `DX2003 ObjectOpaque`
- `DX3001 FileUnsupported`
- `DX3002 FileLowered`
- `DX3003 FileOpaquePreserved`
- `DX3004 ExportRejectedStrict`

### Cell/UI projection rules
| Condition | Internal code | Cell/UI projection | Automation projection |
|---|---|---|---|
| Unknown function token in active profile | `DX1001` | `#NAME?` | `severity=error`, `policy_state=rejected`, `feature_kind=formula` |
| Known feature but disabled in current profile/build | `DX1001` | `#N/A` with message "unsupported in profile" | same code + `required_profile` |
| Lowered formula with behavior caveat | `DX1002` | Computed value + warning badge | `severity=warning`, `policy_state=lowered` |
| Opaque formula extension (stored, not executed) | `DX1003` | `#N/A` with "preserved, not evaluated" | `policy_state=opaque`, `round_trip=true` |
| Object model lowered | `DX2002` | Rendered object + warning in inspector | warning diagnostic |
| Object model opaque only | `DX2003` | Placeholder/inspector entry "preserved extension" | info diagnostic with host object ID |
| Export blocked by strict target | `DX3004` | Export error dialog with actionable list | hard failure response with diagnostics array |

### Mode rules
- `Load/Open`: never crash; prefer `Opaque` over `Rejected` when persistence is possible.
- `Recalc`: unsupported semantics map to deterministic formula/object errors, never silent fallback.
- `Save native format`: preserve opaque payloads.
- `Export foreign target`:
  - `strict=true`: any unresolved `Lowered(lossy)` or `Opaque` required-by-target => `Rejected`.
  - `strict=false`: allow `Lowered`/`Opaque` with mandatory warnings + export manifest.

## Round-trip strategy for unknown OOXML parts and extensions

### OOXML unknown parts
- Preserve tuple: `(part_uri, content_type, raw_bytes, relationships, owning package path)`.
- Preserve relationship graph edges for unknown parts (including external relationship metadata).
- Re-emit preserved parts unchanged unless owning host object is explicitly deleted by user action.

### Extension payloads (formula/object)
- Store as `OpaqueExtensionAttachment` keyed by stable host identity (cell/range/object/document).
- Mutation rules:
  - Host move/rename: attachment moves with host identity.
  - Host copy: attachment copied with provenance marker.
  - Host delete: attachment tombstoned; emit deletion diagnostic.

### Integrity checks
- On load/save, compute hash over preserved payload bytes and report mismatch as `DX3001` (file integrity warning/error by mode).

## Visibility to users and automation

### Diagnostics API shape
```json
{
  "diagnostic_id": "DX1003",
  "severity": "error|warning|info",
  "policy_state": "native|lowered|opaque|rejected",
  "feature_kind": "formula|object|file",
  "feature_id": "ext.formula.lambdaX",
  "message": "Preserved extension payload is not executable in this profile.",
  "location": {
    "sheet_id": "S1",
    "address": "B7",
    "object_id": null,
    "part_uri": null
  },
  "profile_required": "excel-interop@2",
  "profile_active": "visicalc-core@1",
  "build_capability": "calc.formula.core",
  "operation": "open|recalc|save|export",
  "target": "native|xlsx|xlsm|dif",
  "round_trip_preserved": true,
  "timestamp_epoch": 142
}
```

### Protocol surface additions (minimal)
- `QueryDiagnostics(filter)` -> returns stable codes + metadata.
- `SubscribeDiagnostics(since_epoch)` -> stream of new diagnostics.
- Capability manifest must declare per feature: `support_state` and allowed degrade states.

### User-visible surfaces
- Workbook-level "Compatibility/Interop" panel grouped by `feature_kind` and `policy_state`.
- Cell/object badges for local issues.
- Export preflight report listing blockers vs warnings.

## Minimum policies: DnaVisiCalc now vs DnaPreCalc later

| Policy capability | DnaVisiCalc (must have) | DnaPreCalc (defer/expand) |
|---|---|---|
| Policy enum (`Native/Lowered/Opaque/Rejected`) | Yes, end-to-end in engine + diagnostics | Keep, extend per-feature granularity |
| Deterministic unsupported error mapping | Yes (`DX1001/2001/3001` core) | Add richer subtype mapping and localization |
| Opaque storage for unknown payloads | Yes for document-level blobs + extension attachments needed for pathfinder interop seam | Full OOXML part/relationship preservation across all supported package shapes |
| Lowering pipeline | Minimal: formula rewrites needed for declared pathfinder subset only | Broad lowering library (formula/object/file) for Excel parity targets |
| Export strict vs permissive modes | Minimal preflight + deterministic block in strict mode | Full policy negotiation by target profile/version |
| Diagnostics API | Minimal query + subscribe + stable code schema | Add suppression policies, budgets, CI gates |
| UI compatibility surfacing | Minimal badges + workbook report | Full compatibility center with remediation actions |

## Proposed doc edits (exact headings/IDs)
- `ARCHITECTURE_AND_REQUIREMENTS.md`:
  - Extend `3.2 Profiles, Feature Gates, and Compatibility` with a normative degrade-state table.
  - Extend `3.8 File I/O (outside core, full fidelity)` with OOXML unknown-part preservation contract.
  - Extend `5. Core Requirements` with explicit diagnostics API requirement for unsupported/lowered/opaque/rejected outcomes.
- `OPERATIONS.md`:
  - Extend `4.1 Packs` with interop pack IDs for degrade/preserve conformance (for example `PACK.interop.degrade_matrix`, `PACK.interop.roundtrip.opaque`).

## Smallest next actions (highest risk reduction)
1. Freeze the diagnostic code set (`DX1001..DX3004`) and add it to capability manifest schema.
2. Implement an `OpaqueAttachmentStore` contract test: load -> save -> byte-hash equality for unknown payloads.
3. Add export preflight in strict/permissive modes with deterministic blocker list.
4. Add one conformance pack that asserts formula/object/file each exercise `Native/Lowered/Opaque/Rejected` at least once.
