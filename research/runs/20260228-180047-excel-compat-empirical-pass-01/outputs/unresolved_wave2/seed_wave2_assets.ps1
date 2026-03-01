Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$waveDir = $PSScriptRoot
$manifestPath = Join-Path $waveDir 'scenario_manifest_wave2.csv'

$rows = @(
    [pscustomobject]@{ scenario_id='SCN-EB018-DYNARRAY-MIXED'; task_id='ECS-EB-018'; priority='P0'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/scenarios/SCN-EB018-DYNARRAY-MIXED.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB019-LAMBDA-HELPER-EDGE'; task_id='ECS-EB-019'; priority='P0'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/scenarios/SCN-EB019-LAMBDA-HELPER-EDGE.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB021-EXTERNAL-REPLAY'; task_id='ECS-EB-021'; priority='P1'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/scenarios/SCN-EB021-EXTERNAL-REPLAY.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB024-OP-CORE'; task_id='ECS-EB-024'; priority='P1'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/scenarios/SCN-EB024-OP-CORE.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB025-AGG-COERCION'; task_id='ECS-EB-025'; priority='P0'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/scenarios/SCN-EB025-AGG-COERCION.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB025-FUNCTION-CORE'; task_id='ECS-EB-025'; priority='P1'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/scenarios/SCN-EB025-FUNCTION-CORE.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB026-NESTED-PRECEDENCE'; task_id='ECS-EB-026'; priority='P1'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/scenarios/SCN-EB026-NESTED-PRECEDENCE.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB033-CF-TABLE-SPILL'; task_id='ECS-EB-033'; priority='P0'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/scenarios/SCN-EB033-CF-TABLE-SPILL.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB034-STRUCTREF-SPILL'; task_id='ECS-EB-034'; priority='P0'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/scenarios/SCN-EB034-STRUCTREF-SPILL.json'; status='planned'; notes='Unresolved queue replay' },
    [pscustomobject]@{ scenario_id='SCN-EB044-REOPEN-DYNARRAY'; task_id='ECS-EB-044'; priority='P0'; domain='unresolved'; scenario_file='research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reopen_wave1/scenarios/SCN-EB044-REOPEN-DYNARRAY.json'; status='planned'; notes='Unresolved queue replay' }
)

$rows | Export-Csv -Path $manifestPath -NoTypeInformation

$readme = @(
    '# Unresolved Wave 2',
    '',
    '## Scope',
    'Replay unresolved/mismatch-bearing scenarios and synthesize a resolution matrix for deduplicated queue items.',
    '',
    '## Files',
    '- `scenario_manifest_wave2.csv`',
    '- `run_wave2.ps1`',
    '- `build_wave2_outputs.ps1`',
    '- `evidence/<scenario_id>/*`',
    '- `unresolved_resolution_matrix_wave2.csv`',
    '- `UNRESOLVED_WAVE2_REPORT.md`'
)
Set-Content -Path (Join-Path $waveDir 'README.md') -Value ($readme -join [Environment]::NewLine)

$runScript = @(
    '$ErrorActionPreference = "Stop"',
    '$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")',
    'Set-Location $repoRoot',
    '',
    '$fixtureDirs = @(',
    '  ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/tier45_wave1'',',
    '  ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/coercion_wave1'',',
    '  ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/cf_wave1'',',
    '  ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/table_wave1'',',
    '  ''research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/reopen_wave1''',
    ')',
    'foreach ($dir in $fixtureDirs) {',
    '  if (Test-Path $dir) { Remove-Item -Recurse -Force $dir }',
    '  New-Item -ItemType Directory -Force -Path $dir | Out-Null',
    '}',
    '',
    '$evidenceRoot = ''research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/evidence''',
    'if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }',
    'New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null',
    '',
    '& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/scenario_manifest_wave2.csv --base-dir . --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/evidence --visible false --timeout-sec 900',
    'if ($LASTEXITCODE -ne 0) { throw "unresolved_wave2 run-manifest failed with exit code $LASTEXITCODE" }',
    '',
    '& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/unresolved_wave2/build_wave2_outputs.ps1',
    'if ($LASTEXITCODE -ne 0) { throw "unresolved_wave2 output synthesis failed with exit code $LASTEXITCODE" }'
)
Set-Content -Path (Join-Path $waveDir 'run_wave2.ps1') -Value ($runScript -join [Environment]::NewLine)

"Seeded unresolved_wave2 manifest at $manifestPath"
