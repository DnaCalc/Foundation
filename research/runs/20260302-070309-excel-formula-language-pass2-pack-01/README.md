# Research Run: Excel Formula Language Pass-2 Pack 01

## Run ID
`20260302-070309-excel-formula-language-pass2-pack-01`

## Purpose
Prepare an executable empirical pass-2 pack for formula-language conformance lanes, based on the seeded scenario list in the reference conformance model.

## Snapshot
- Foundation commit: `b87d202d04681d7b37b7424bc2a07fab818c494a`
- Seed source copied from:
  - `reference/conformance/excel-worksheet-engine/model/EXCEL_FORMULA_LANGUAGE_PASS2_SCENARIO_SEED.csv`

## Layout
- `inputs/formula_language_pass2_scenario_seed.csv`: copied scenario seed.
- `outputs/formula_parse_pass2/`: generated scenarios, manifests, run/build scripts.
- `fixtures/formula_parse_pass2/`: workbook fixture targets.
- `logs/`: run setup notes.

## Workflow
1. Seed/refresh pack artifacts:
   - run `outputs/formula_parse_pass2/seed_pass2_assets.ps1`
2. Execute scenarios with Excel probe:
   - run `outputs/formula_parse_pass2/run_pass2.ps1`
3. Execute targeted manual-prep rerun:
   - run `outputs/formula_parse_pass2/run_pass2_manualprep.ps1`
4. Build summarized result artifacts:
   - run `outputs/formula_parse_pass2/build_pass2_outputs.ps1`

## Current Status (2026-03-02)
1. Pass-2 scenario corpus executed (`37/37`).
2. Summary from `PASS2_EXECUTION_REPORT.md`:
   - observed accepted: `35`
   - observed rejected: `2`
   - mismatch rows: `0`
   - run-failed rows: `0`
3. Targeted manual-prep rerun executed for:
   - `FMLP2-008`, `FMLP2-009`, `FMLP2-019`, `FMLP2-021`
