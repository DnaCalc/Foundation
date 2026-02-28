# Prompt Pass 6 - Tier-5 Critical Function Semantics

## Scope
Critical-interest functions: `INDIRECT`, `OFFSET`, `RTD`, `NOW`, `TODAY`.

## Behavior summary

| Function | Core semantics | Recalc/volatility | Notable errors | Compatibility-sensitive points |
|---|---|---|---|---|
| INDIRECT | Interprets text as reference (`A1`/`R1C1` depending on optional arg) and evaluates immediately. | Treated as volatile in recalculation guidance. | `#REF!` for invalid ref text, closed external workbook refs, and out-of-grid limits. | Reference indirection can obscure static dependency analysis and complicate incremental recalculation. |
| OFFSET | Returns a reference offset from a base reference by row/col and optional height/width. | Treated as volatile in recalculation guidance. | `#VALUE!` for invalid base reference; `#REF!` when offset crosses grid edge. | Reference-shape effects require robust dependency invalidation; often combined with aggregators. |
| RTD | Retrieves real-time data from registered COM automation RTD server (`ProgID`, `server`, topics). | Updates when server pushes changes and automatic calc mode is active. | `#N/A` if RTD server/add-in unavailable or not properly installed/registered. | External update semantics and server lifecycle handling are central for compatibility; local registration assumptions matter. |
| NOW | Returns current date-time serial value (`NOW()`). | Re-evaluates on worksheet calculation; not continuously ticking. | Typically no direct argument errors (no args). | If entered in General format, Excel may auto-switch cell format to regional date/time format. |
| TODAY | Returns current date serial value (`TODAY()`). | Re-evaluates on worksheet calculation; not continuously ticking. | Typically no direct argument errors (no args). | If entered in General format, Excel may auto-switch to Date format; ties to date-system serial semantics. |

## Additional notes
- Date serial semantics for `NOW`/`TODAY` tie into 1900 vs 1904 workbook date-system behavior; date-system conversion and cross-workbook paste rules should be tested explicitly.
- RTD page applies-to lists broad platform surface, but implementation dependencies remain COM-automation centric; practical cross-platform parity should be treated as empirical compatibility evidence.

## Source anchors used in pass 06
- INDIRECT function page.
- OFFSET function page.
- RTD function page.
- NOW function page.
- TODAY function page.
- Excel recalculation guidance.
- Date systems in Excel page.

## Known unknowns for tier-5 deep dive
1. Exact dependency-tracking behavior for `INDIRECT` and `OFFSET` under all structural edits.
2. RTD lifecycle edge cases under workbook open/close, calc mode transitions, and reconnect conditions.
3. Full interaction matrix for `NOW`/`TODAY` with workbook date-system toggles and cross-workbook copy/paste.