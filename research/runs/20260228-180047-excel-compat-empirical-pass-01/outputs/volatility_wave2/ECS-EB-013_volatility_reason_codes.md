# ECS-EB-013 - Volatility Reason-Code Mapping (Observed, Wave 2)

## Inputs
- `ECS-EB-012_volatility_context_probe.csv`
- `evidence/*/step_capture.json`

## Observed trigger classes
1. `always_volatile`: confirmed by `SCN-EB012-RAND-RECALC-CONTROL`.
2. `argument_conditional_context`: observed with `SCN-EB012-INFO-RECALC-MODE-TOGGLE`.
3. `stable_argument_variant`: observed with `CELL("address")`, `INFO("directory")`, and SUM control scenarios.
4. `lifecycle_sensitive`: observed in `CELL("filename")` close/open sequence (workbook-closed step captured).

## Interpretation for reason codes
- `volatile_or_recalc_sensitive` should be treated as a class containing multiple trigger subclasses (always-volatile and context-conditional), not a single uniform behavior.
- Candidate functions require per-argument profiling before assigning strong volatility expectations.

## Limits
- Wave 2 used one locale and one desktop platform lane.
- No external-data/RTD context included in this specific wave.
- Results are trigger-profile observations, not full semantic closure.
