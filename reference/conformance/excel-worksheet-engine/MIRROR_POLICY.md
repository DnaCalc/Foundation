# Foundation Mirror Policy (Excel Worksheet-Engine)

## 1. Purpose
Define how Foundation keeps read-only mirror copies of lane-owned specs without creating ownership drift.

## 2. Canonical Ownership Map
Canonical editable locations:
1. OxFml:
   - `C:/Work/DnaCalc/OxFml/docs/spec/fec-f3e/*`
   - `C:/Work/DnaCalc/OxFml/docs/spec/formula-language/*`
   - `C:/Work/DnaCalc/OxFml/docs/spec/formatting/*` (formula-semantic formatting clauses)
2. OxCalc:
   - `C:/Work/DnaCalc/OxCalc/docs/spec/core-engine/*`
   - `C:/Work/DnaCalc/OxCalc/docs/spec/visibility/*`
   - `C:/Work/DnaCalc/OxCalc/docs/spec/fec-f3e/*` (consumed mirrors; canonical remains OxFml)
3. Foundation:
   - doctrine/architecture/operations/conformance policy,
   - read-only mirror snapshots under `reference/conformance/excel-worksheet-engine/model/*`,
   - read-only mirror snapshots for `CORE_ENGINE_FORMAL_MODEL.md` and `CORE_ENGINE_THEORY_AND_ALTERNATIVE_PATHS.md`.

## 3. Edit Gate
Foundation mirror files are read-only by default.

Allowed edits in Foundation mirrors:
1. mirror-sync from canonical lane repos,
2. pointer/header metadata updates required by mirror policy,
3. link-rot or path updates that do not alter normative semantics.

Required for mirror-sync edits:
1. identify source canonical file path,
2. record source commit hash in commit message or run artifact,
3. avoid local-only normative divergence,
4. update mirror banner/pointer metadata if missing.

## 4. Naming and Header Convention
1. Existing legacy filenames may remain to preserve link stability.
2. Mirror markdown files must include:
   - title prefix containing `Foundation Mirror Copy`,
   - explicit `Read-only in Foundation` note,
   - canonical path pointer.
3. New mirror artifacts should use `_MIRROR` suffix when practical.

## 5. Conflict Rule
If canonical repo content conflicts with Foundation mirror content:
1. treat canonical repo as authoritative,
2. update Foundation mirror via mirror-sync,
3. open a synthesis note only if doctrine-level implications exist.
