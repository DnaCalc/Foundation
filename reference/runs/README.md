# Reference Runs

Managed run artifacts for reference-spec processing and conformance-candidate extraction.

Use layout:
- `reference/runs/<run-id>/README.md`
- `reference/runs/<run-id>/inputs/*`
- `reference/runs/<run-id>/outputs/*`
- `reference/runs/<run-id>/logs/*`

Minimum `inputs/` capture should include:
- source index reference and filter parameters,
- capture timestamp,
- Foundation commit hash used to run the tool.

The `tools/spec-pack-processor` tool writes into `outputs/` and should be wrapped by run-manifest scripts that add explicit `inputs/` and `logs/` capture.
