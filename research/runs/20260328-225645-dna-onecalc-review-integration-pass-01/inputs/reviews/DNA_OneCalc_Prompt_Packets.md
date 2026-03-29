# DNA OneCalc Upstream Prompt Pack

Date: 2026-03-28

This file is optimized for copy-paste into the relevant upstream repos.  
Each packet assumes the current OneCalc reading:
- OneCalc is a single-node proving host and serious product shell.
- It must stay narrower than `OxCalc`.
- It consumes `OxFml`, `OxFunc`, and `OxReplay` at runtime, uses `OxXlObs` for empirical Excel comparison, and treats `OxVba` as staged-later.
- It must keep replay/comparison first-class and preserve retained evidence lineage.
- It must keep the public host model explicit-input and non-grid, while allowing bounded reference-bearing probes where the current upstream seam genuinely requires them.

---

## Prompt Packet: `OxFml`

You are reviewing the current `OxFml` surfaces consumed by `DNA OneCalc`.

Context:
- `DNA OneCalc` is not a general spreadsheet grid host and must remain narrower than `OxCalc`.
- The current `OxFml` host/runtime draft is sufficient for first implementation planning, but it is not yet a fully frozen shared seam.
- `DNA OneCalc` needs a OneCalc-safe subset of the current host/runtime, editor/language-service, and result-surface contracts.
- `DNA OneCalc` must not invent a second parser/binder/editor truth locally.

Please produce a concrete downstream-consumer clarification packet that answers the following.

1. Host/runtime subset:
   - Which exact fields are mandatory for default OneCalc H0/H1 execution?
   - Which fields are only required for bounded seam-sensitive probe packets?
   - Which fields should be treated as coordinator/TreeCalc reference material, not part of the initial OneCalc host claim?

2. Packet taxonomy:
   - Confirm or refine a packet taxonomy for:
     - `ExplicitInputPacket`
     - `ReferenceProbePacket`
     - `StructuredReferenceProbePacket`
     - `RegisteredExternalProbePacket`
   - For each packet kind, list:
     - allowed extra fields,
     - forbidden fields,
     - currently exercised semantic lanes that require it.

3. Editor/language-service:
   - Freeze or near-freeze the first OneCalc-facing packet family for:
     - immutable formula edit request/result,
     - diagnostics,
     - deterministic completion,
     - validated completion application,
     - signature help,
     - function-help lookup.
   - State clearly which packet surfaces are already good enough for host integration and which remain local-only evidence.

4. Returned value surface:
   - State the current host obligations for:
     - ordinary value,
     - value with presentation,
     - typed host/provider outcome,
     - rich value / non-ordinary value.
   - State what OneCalc should render, persist, and replay-project for each class.

5. Not-authorized list:
   - Produce a short list of what the current `OxFml` draft does **not** authorize OneCalc to claim yet.

Output shape requested:
- one concise but implementation-ready note,
- a mandatory / probe-only / not-authorized classification,
- packet names and field names preserved where current docs already use them.

---

## Prompt Packet: `OxFunc`

You are reviewing the current `OxFunc` surfaces consumed by `DNA OneCalc`.

Context:
- OneCalc’s current downstream metadata seed is the library-context snapshot export, but that export is a stabilization artifact, not a final ABI.
- OneCalc must read the export through `W050` and `W051`, not as broad support truth by itself.
- OneCalc needs enough metadata and payload structure to power editor help, completion labeling, scenario metadata, and host honesty.

Please produce a concrete downstream clarification packet that answers the following.

1. Snapshot export interpretation:
   - Which fields in the current snapshot export are safe for OneCalc to treat as stable now?
   - Which fields are explicitly provisional or should be interpreted only as current-tree hints?

2. Help/signature contract:
   - What is the preferred first OneCalc-facing payload shape for:
     - function help,
     - argument help,
     - signature help metadata?
   - How should this align with the longer-term runtime provider / immutable snapshot direction?

3. Surface admission policy:
   - State the exact downstream reading of:
     - function-phase-complete rows,
     - `W050` deferred rows,
     - `W051` in-scope-not-complete rows.
   - Define how OneCalc should label each category in:
     - help,
     - completion,
     - product UI,
     - scenario metadata.

4. Focused seam-heavy rows:
   - Clarify the current honest status of:
     - `IMAGE`
     - `GROUPBY`
     - `PIVOTBY`
     - `CALL`
     - `REGISTER.ID`
     - `OP_IMPLICIT_INTERSECTION`
   - Distinguish:
     - true semantic incompleteness,
     - cross-repo seam freeze gap,
     - promotion/documentation lag.

Output shape requested:
- one downstream metadata/help contract note,
- one surface-labeling policy,
- one focused status block for the seam-heavy rows listed above.

---

## Prompt Packet: `OxReplay`

You are reviewing how `DNA OneCalc` should consume `OxReplay` as shared replay infrastructure.

Context:
- `DNA ReCalc` must remain the generic replay host.
- `DNA OneCalc` is a separate proving host that may embed replay, diff, explain, witness, and scenario-library controls in its own UI.
- OneCalc needs a practical downstream service contract without pretending that contract is the same thing as the `DNA ReCalc` host doctrine.
- OneCalc’s current honest replay floor is uneven across lanes and should stay labeled that way.

Please produce a concrete downstream clarification packet that answers the following.

1. Downstream replay service contract:
   - What exact in-process or wrapped service surface should OneCalc embed for:
     - validate bundle,
     - replay,
     - diff,
     - explain,
     - distill,
     - witness-state,
     - pack-export?
   - Which existing CLI/result schemas are the right baseline for that service surface?

2. Artifact lineage:
   - What exact lineage fields must OneCalc preserve in its own product artifacts when those artifacts rely on `OxReplay`?
   - Which fields are mandatory when the source input is lossy or registry-unpinned?

3. Mode gating:
   - What replay capability floor should OneCalc require to expose:
     - Replay
     - Diff
     - Explain
     - Distill
     - Handoff
   - What should remain labeled as later or experimental?

4. Lossy/provisional intake handling:
   - What exact UI/status requirements should apply when OneCalc consumes:
     - lossy observation projections,
     - registry-unpinned inputs,
     - provisional lane capability floors?

Output shape requested:
- one non-`DNA ReCalc` service contract note,
- one artifact-lineage requirements note,
- one current mode-gating note,
- one lossy/provisional intake handling guide.

---

## Prompt Packet: `OxXlObs`

You are reviewing the Excel observation surfaces that `DNA OneCalc` should compare against before the OneCalc build.

Context:
- OneCalc needs a serious Excel-facing evidence lane, but must not overclaim broad equivalence from the current retained observation path.
- The current live path is Windows-only.
- The current replay-facing normalized view is explicitly lossy.
- OneCalc needs a dedicated downstream comparison baseline, not just general observation docs.

Please produce a concrete downstream clarification packet that answers the following.

1. First comparison-ready family:
   - What is the first deterministic enough workbook/scenario family that OneCalc should rely on for retained comparison?

2. First equality/diff envelope:
   - Which surfaces belong in the first comparison envelope?
   - For each surface, classify whether it is:
     - directly observed,
     - derived,
     - unavailable,
     - capture-loss-labeled.

3. Downstream interpretation:
   - What exact limitations should OneCalc display when it consumes the current retained Excel evidence?
   - Which current retained shapes are acceptable for coarse replay/diff activation only?

4. Roadmap:
   - What is the intended next step beyond the current lossy normalized replay view?
   - When would a formal adapter manifest become useful or necessary?

Output shape requested:
- one OneCalc comparison baseline note,
- one first comparison envelope definition,
- one capture-loss/projection-status interpretation guide,
- one roadmap note for richer diff/equality structure.

---

## Prompt Packet: `OxCalc`

You are reviewing the current `OxCalc` seam-reference materials that `DNA OneCalc` should use without drifting into `OxCalc` host scope.

Context:
- OneCalc does not depend on `OxCalc` at runtime.
- OneCalc still needs `OxCalc` seam-reference docs because they show how a serious consumer drives the shared OxFml seam.
- OneCalc must remain an explicit-input, non-grid, single-node host.

Please produce a concrete seam-reference clarification packet that answers the following.

1. Minimal packet narrowing:
   - From the current implementation-backed minimal upstream host interface packet, which fields should OneCalc treat as:
     - default requirements,
     - bounded probe-only requirements,
     - coordinator/TreeCalc-only reference material?

2. Residual topics:
   - Which current residual seam topics remain open and should therefore not silently become OneCalc product assumptions?

3. Seam-sync process:
   - If OneCalc pressures a shared OxFml packet change, what exact sync/update process should happen for the OxCalc seam-reference docs?

Output shape requested:
- one OneCalc-safe seam-reference subset note,
- one field classification table,
- one seam-sync update procedure.

---

## Prompt Packet: `OxVba`

You are reviewing the current `OxVba` surfaces relevant to `DNA OneCalc`.

Context:
- OneCalc’s first extension story is a portable native-extension ABI.
- OxVba is relevant, but much of the add-in/XLL story remains future direction.
- OneCalc needs a clean answer to “what can I rely on now?” versus “what is planned?”

Please produce a concrete downstream clarification packet that answers the following.

1. Current consumer floor:
   - What can a downstream product host honestly rely on today for embedded runtime hosting?

2. `.basproj` and output kinds:
   - Which parts of the current `.basproj` direction are stable enough to treat as real downstream design input now?
   - What is the honest current meaning of `Library` and `Addin` outputs for a downstream host?

3. Planned vs current:
   - Which parts of XLL/add-in generation are still planned only?
   - Which parts are executable current floor?

4. Platform constraints:
   - Which host/runtime capabilities are explicitly Windows-only?
   - What should a downstream host assume for Linux and WASM?

Output shape requested:
- one “current executable consumer floor” note,
- one “now vs planned” split,
- one platform constraint summary.

---

## Prompt Packet: `DNA OneCalc` bootstrap repo

You are preparing the bootstrap governance and seam freeze for the `DNA OneCalc` repo.

You must keep all of the following true:
- OneCalc stays narrower than `OxCalc`.
- OneCalc keeps replay and comparison first-class.
- OneCalc keeps the artifact spine explicit.
- OneCalc keeps the extension contract honest by platform.
- OneCalc remains centered on `Live Formula Semantic X-Ray`.
- OneCalc treats provisional upstream seams as real product constraints, not invisible implementation details.

Please produce the first repo bootstrap package containing:

1. `SEAM_MANIFEST`
2. `HOST_PROFILE_MATRIX`
3. `HOST_PACKET_KINDS`
4. `FUNCTION_SURFACE_POLICY`
5. `REPLAY_FLOOR_POLICY`
6. `DISPLAY_AND_FORMAT_MODEL`
7. `SCENARIO_SCHEMA`
8. `HANDOFF_PACKET_SCHEMA`
9. `SPREADSHEETML_2003_MAPPING_DECISION`
10. `PROVISIONALITY_BADGE_POLICY`

Specific requirements:
- Freeze `ExplicitInputPacket`, `ReferenceProbePacket`, `StructuredReferenceProbePacket`, and `RegisteredExternalProbePacket`.
- Adopt a promoted/provisional/deferred/pressure function-surface policy.
- Make worksheet-per-instance the default `SpreadsheetML 2003` mapping unless a stronger alternative is justified explicitly.
- Expose replay capability floor, projection status, and Windows-only live Excel comparison status in the UI model.
- Do not present `W050` or `W051` rows as settled parity by default.
- Do not treat current lossy `OxXlObs` replay-facing views as broad semantic equivalence truth.

Output shape requested:
- one concrete bootstrap packet with file names, purpose, minimum fields, and closeout gates.