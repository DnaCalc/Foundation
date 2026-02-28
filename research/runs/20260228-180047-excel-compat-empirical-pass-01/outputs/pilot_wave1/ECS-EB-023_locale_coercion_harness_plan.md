# ECS-EB-023 Locale Coercion Harness Plan

## Objective
Build a locale-parameterized harness for coercion probes so parser-sensitive and format-sensitive behavior can be measured consistently across locales and compared against documented expectations.

## Inputs
- Scenario schema: `../artifacts/empirical_scenario_schema.v0.json`
- Normalized capture schema: `../artifacts/normalized_capture_schema.v0.json`
- Pilot locale seed: `ECS-EB-023_locale_matrix_seed.csv`
- Coercion baselines:
  - `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/coercion_matrix_seed.csv`
  - `../../20260228-130325-excel-compat-spec-index-pass-01/outputs/coercion_matrix_expanded.csv`

## Harness structure
1. Environment capture
   - Record OS locale, Excel UI locale, workbook locale-related settings (where observable), date system, and list/decimal separators.
2. Fixture generation
   - Build workbook fixtures with locale-sensitive text numerics and date strings.
   - Include both formula entry and value entry paths.
3. Probe execution
   - Execute formula families: `VALUE`, arithmetic coercion (`+`), text concatenation (`&`), `DATEVALUE`, `N`, and selected dynamic-array mixed-type cases.
4. Normalization
   - Capture raw values, error tokens, display text, and type code where available.
   - Normalize per scenario with locale metadata attached.
5. Comparison
   - Compare outcomes across locale tags and flag divergences by function/operator/context.

## Core questions for this pilot
1. Does numeric text parsing in `VALUE` differ deterministically by decimal separator locale?
2. Are date text parsing outcomes stable and explainable by locale date order?
3. Do operator coercions (`+`, `&`) produce locale-dependent divergences in mixed numeric-text inputs?
4. Are divergence outcomes reproducible across workbook reopen within the same locale setup?

## Execution sequence for pilot scenarios
1. Run `SCN-EB023-VALUE-LOCALE-COMMA`.
2. Run `SCN-EB023-DATEVALUE-LOCALE-TEXT`.
3. Capture normalized outputs and append to a locale comparison table.
4. If mismatches appear, generate minimized divergence scenarios with narrower inputs.

## Planned outputs
- `locale_coercion_probe_wave1.csv` (observed outcomes per locale/case)
- `locale_coercion_divergence_log.csv` (only mismatches and uncertain outcomes)
- `locale_coercion_replay_manifest.csv` (rerun commands by locale and scenario)

## Non-goals in this pilot
- Exhaustive all-locale coverage.
- Full function-family coercion closure (handled in `ECS-EB-024` and `ECS-EB-025`).

## Readiness criteria
- At least two locale scenarios executed with complete evidence bundles.
- Outcome rows include locale metadata and explicit reproducibility command.
- Divergences, if any, are clearly tagged as parser, format, or type-coercion class.
