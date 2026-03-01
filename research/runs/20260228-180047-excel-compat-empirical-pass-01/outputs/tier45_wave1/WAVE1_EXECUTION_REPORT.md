# Tier4/5 Wave 1 Execution Report

## Scope
Executed `ECS-EB-018/019/020/021` scenario probes and generated synthesis artifacts for `ECS-EB-017` and `ECS-EB-022`.

## Execution status
- Case rows: 15
- Matches expected: 10
- Mismatch rows: 4
- Probe rows: 1
- Run-failed rows: 0

## Key outcomes
1. Dynamic-array and LAMBDA/helper baseline probes now have wave-1 evidence rows.
2. CUBE function contract rows now capture formula-entry acceptance signal independent of connector success.
3. External-data replay rows now capture stability signals across save/close/open/recalc sequence.
4. Tier-5 platform caveat report and tier-3 expansion queue are generated from combined evidence.

## Artifacts
- `ECS-EB-018_dynamic_array_mixed_type_probe_wave1.csv`
- `ECS-EB-019_lambda_helper_edge_probe_wave1.csv`
- `ECS-EB-020_cube_contract_probe_wave1.csv`
- `ECS-EB-021_external_data_replay_probe_wave1.csv`
- `ECS-EB-017_tier5_platform_caveat_report_wave1.md`
- `ECS-EB-022_tier3_expansion_queue_wave1.csv`
