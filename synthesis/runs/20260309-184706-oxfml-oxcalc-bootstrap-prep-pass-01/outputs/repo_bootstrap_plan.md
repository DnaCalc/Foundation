# Repo Bootstrap Plan

## Objective
Prepare reproducible initialization for `OxFml` and `OxCalc` with startup governance docs plus lane-owned specs.

## Decided Ownership (from Foundation doctrine)
1. OxFml owns formula-language and evaluator seam specs, including canonical FEC/F3E protocol files.
2. OxCalc owns multi-node coordinator and core-engine realization specs.
3. FEC/F3E coordinator-facing clauses are co-defined by OxCalc but canonically published in OxFml.
4. Foundation remains doctrine/conformance-policy owner and mirror host.

## Included in this pack
1. Bootstrap templates for repo-level `README`, `CHARTER`, `OPERATIONS`, and `docs/spec/README`.
2. Spec transfer manifest (`SPEC_TRANSFER_MANIFEST.csv`) with per-file authority-after-import.
3. Bootstrap script (`create_oxfml_oxcalc_repos.ps1`) with `-DryRun` and `-Overwrite` modes.
4. Source-run and hash capture under `inputs/`.

## Immediate post-bootstrap actions
1. Initialize git repos for `../OxFml` and `../OxCalc` if absent.
2. Run the bootstrap script once without `-DryRun`.
3. Validate imported file set and perform first local lane-specific edits in each new repo.
4. Update Foundation `SOURCE_BINDINGS.csv` `INT-*` path notes to show OxFml as canonical and Foundation as mirror.
5. Open first OxCalc -> OxFml handoff packet for coordinator-facing FEC/F3E clauses.

## Known follow-ups
1. Split mixed formatting/visibility modeling doc into lane-owned clauses over time (format semantics in OxFml, visibility policy in OxCalc).
2. Add `AGENTS.md` in new repos after repo creation, aligned to each repo path and doctrine.
