# Pass 15 - Version and Platform Guide

## Versioning posture
- Union across modern Excel versions/channels with explicit release-status notes.
- Compatibility Versions treated as workbook-scoped behavior-evolution signal.
- Pre-Excel-2007 legacy behavior not a primary axis.

## Platform posture
- Platform is a caveat axis, not primary taxonomy.
- Union behavior is target; platform quirks captured where explicit evidence exists.
- RTD and connector-dependent families require explicit platform caveat handling.

## Artifacts
- `platform_notes.md`
- `platform_probe_selected_functions.csv`

## Known unknowns
- Stable machine-readable per-function platform/build availability matrix.
- Practical parity behavior for externally-dependent functions across desktop/web/mobile variants.