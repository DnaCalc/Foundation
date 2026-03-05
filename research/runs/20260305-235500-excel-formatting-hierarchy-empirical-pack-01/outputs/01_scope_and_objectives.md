# Scope and Objectives

## Purpose
Define the empirical closure pack for formatting semantics that remain underspecified or profile-sensitive.

## Objectives
1. Confirm style hierarchy and precedence behavior from persisted workbook artifacts and runtime display outcomes.
2. Bound locale/regional influence on parse/render behavior for formatting lanes.
3. Identify origin and variability of defaults (font, size, sheet defaults, style baseline).
4. Determine what formula-evaluation surfaces can observe formatting state, especially conditional-format effects.

## Linked conformance lanes
1. `XLS-CF-FM-001`, `XLS-CF-FM-004`, `XLS-CF-FM-007`, `XLS-CF-FM-008`
2. New formatting hierarchy/default/visibility lanes added in current pass (`XLS-CF-FM-009..014`)
3. `ECM-Q-013` and newly added formatting open-question lanes in concrete model.

## Evidence contract
Each executed scenario should emit:
1. scenario manifest row with status and run metadata,
2. raw capture (`raw_capture.json`),
3. normalized capture (`normalized_capture.json`),
4. workbook artifact (before/after when mutation involved),
5. extracted workbook XML snippets for relevant style parts (`styles.xml`, sheet XML where needed).
