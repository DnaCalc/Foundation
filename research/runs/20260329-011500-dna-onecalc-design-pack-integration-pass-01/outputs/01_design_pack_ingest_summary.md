# DNA OneCalc Design Pack Ingest Summary

Source artifacts:
1. `C:\Temp\DnaOneCalcSpec\Review\DNA_OneCalc_Design_Pack.md`
2. `C:\Temp\DnaOneCalcSpec\Review\DNA_OneCalc_Design_Pack.zip`

Preserved extracted assets:
1. `inputs/design_pack/extracted/DNA_OneCalc_Design_Pack/assets/01_shell_and_information_architecture.png`
2. `inputs/design_pack/extracted/DNA_OneCalc_Design_Pack/assets/02_workbench_wireframe.png`
3. `inputs/design_pack/extracted/DNA_OneCalc_Design_Pack/assets/03_compare_wireframe.png`
4. `inputs/design_pack/extracted/DNA_OneCalc_Design_Pack/assets/04_scenario_library_wireframe.png`
5. `inputs/design_pack/extracted/DNA_OneCalc_Design_Pack/assets/05_handoff_review_wireframe.png`

What was adopted into the canonical spec:
1. `Twin Oracle Workbench` as the design frame.
2. The top-level product areas: Workbench, Scenario Library, Document/Instance Manager, and Environment/Capability Center.
3. The artifact-lineage presentation: Document -> Scenario -> Run -> Comparison -> Witness -> Handoff.
4. The first screen-priority set: Workbench, Compare, Scenario Library, Handoff Review, and X-Ray.
5. The first core flows: author/run, diagnose, compare, explain/retain, emit handoff, browse/reopen.
6. The keyboard-first and durable-drawer interaction rules.
7. The split status vocabularies for function-surface truth, higher-level product maturity, and comparison or observation reliability.

What was reconciled rather than copied literally:
1. The design pack's earlier `Promoted / Provisional / Deferred` labels were narrowed so they now govern scenario-family or product-surface maturity, not function-surface truth.
2. Function-surface truth now follows the newer OxFunc labels: `supported`, `preview`, `experimental`, `deferred`, `catalog_only`.
3. Observation or comparison reliability now follows the newer `direct`, `derived`, `lossy`, and `unavailable` rules rather than the earlier generic `Projected` wording.

Canonical destination updated:
1. `notes/DNA_ONECALC_SCOPE_AND_SPEC.md`
