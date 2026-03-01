# Reference Runs

Managed run artifacts for reference-spec processing and conformance-candidate extraction.

Use layout:
- `reference/runs/<run-id>/README.md`
- `reference/runs/<run-id>/inputs/*`
- `reference/runs/<run-id>/outputs/*`
- `reference/runs/<run-id>/logs/*`

The `tools/spec-pack-processor` tool writes into `outputs/` and can be wrapped by run-manifest scripts that add explicit `inputs/` and `logs/` capture.
