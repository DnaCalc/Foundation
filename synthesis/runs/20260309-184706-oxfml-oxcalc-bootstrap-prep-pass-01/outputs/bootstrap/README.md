# Bootstrap Pack: OxFml + OxCalc

This directory contains a ready-to-run bootstrap kit for creating `../OxFml` and `../OxCalc` from Foundation doctrine.

## What this pack does
1. Seeds each repo with startup governance docs:
   - `README.md`
   - `CHARTER.md`
   - `OPERATIONS.md`
   - `docs/spec/README.md`
2. Copies current authoritative source specs into each lane according to ownership.
3. Keeps Foundation as doctrine owner and conformance mirror host.

## Authority model
- OxFml owns FEC/F3E seam spec authority after bootstrap.
- OxCalc owns multi-node coordinator/core-engine implementation spec authority after bootstrap.
- Foundation remains doctrine and cross-lane conformance policy owner.

## Execute
From `Foundation` root:

```powershell
./synthesis/runs/20260309-184706-oxfml-oxcalc-bootstrap-prep-pass-01/outputs/bootstrap/create_oxfml_oxcalc_repos.ps1
```

Optional flags:

```powershell
./synthesis/runs/20260309-184706-oxfml-oxcalc-bootstrap-prep-pass-01/outputs/bootstrap/create_oxfml_oxcalc_repos.ps1 -DryRun
./synthesis/runs/20260309-184706-oxfml-oxcalc-bootstrap-prep-pass-01/outputs/bootstrap/create_oxfml_oxcalc_repos.ps1 -Overwrite
```

## Post-bootstrap required edits
1. In each new repo, update `AGENTS.md` repo path header if you copy one later.
2. In Foundation, update `reference/conformance/excel-worksheet-engine/SOURCE_BINDINGS.csv` `INT-*` paths to point to OxFml canonical files while retaining Foundation mirror notes.
3. Register first cross-repo handoff packet from OxCalc for coordinator-facing FEC/F3E clauses.
