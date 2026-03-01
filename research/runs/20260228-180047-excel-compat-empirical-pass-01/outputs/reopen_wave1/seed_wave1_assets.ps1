Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir "..\..\..\..\..")).Path
$scenarioDir = Join-Path $waveDir "scenarios"
$fixtureRootRel = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/reopen_wave1"

New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot $fixtureRootRel) | Out-Null

function New-Scenario {
    param(
        [string]$ScenarioId,
        [object[]]$Writes,
        [object[]]$Operations
    )
    $fixture = "$fixtureRootRel/$ScenarioId.xlsx"
    [pscustomobject]@{
        scenario_id = $ScenarioId
        task_id = "ECS-EB-044"
        fixture = $fixture
        writes = $Writes
        operations = $Operations
    }
}

$scenarioDefs = @(
    (New-Scenario -ScenarioId "SCN-EB044-REOPEN-COERCION" -Writes @() -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A1"; args = [ordered]@{ formula = '=SUM("1",2)' } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A2"; args = [ordered]@{ formula = '=VALUE("123.45")' } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A3"; args = [ordered]@{ formula = "=TODAY()" } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "save"; target = "workbook" },
        [ordered]@{ op = "close"; target = "workbook" },
        [ordered]@{ op = "open"; target = "workbook" },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB044-REOPEN-DYNARRAY" -Writes @() -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!B1"; args = [ordered]@{ formula = "=SEQUENCE(3,1,1,1)" } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "save"; target = "workbook" },
        [ordered]@{ op = "close"; target = "workbook" },
        [ordered]@{ op = "open"; target = "workbook" },
        [ordered]@{ op = "recalc"; target = "workbook" }
    ))
)

$cases = @(
    [pscustomobject]@{ case_id = "RPDW1-001"; scenario_id = "SCN-EB044-REOPEN-COERCION"; target = "Sheet1!A1"; expected_kind = "stable_replay"; expected_value = "1"; notes = "SUM literal coercion should be stable across reopen." },
    [pscustomobject]@{ case_id = "RPDW1-002"; scenario_id = "SCN-EB044-REOPEN-COERCION"; target = "Sheet1!A1"; expected_kind = "value"; expected_value = "3"; notes = "SUM literal coercion baseline value." },
    [pscustomobject]@{ case_id = "RPDW1-003"; scenario_id = "SCN-EB044-REOPEN-COERCION"; target = "Sheet1!A2"; expected_kind = "stable_replay"; expected_value = "1"; notes = "VALUE text conversion should be stable across reopen." },
    [pscustomobject]@{ case_id = "RPDW1-004"; scenario_id = "SCN-EB044-REOPEN-COERCION"; target = "Sheet1!A2"; expected_kind = "value"; expected_value = "123.45"; notes = "VALUE literal baseline value." },
    [pscustomobject]@{ case_id = "RPDW1-005"; scenario_id = "SCN-EB044-REOPEN-DYNARRAY"; target = "Sheet1!B3"; expected_kind = "stable_replay"; expected_value = "1"; notes = "SEQUENCE spill tail should be stable across reopen." },
    [pscustomobject]@{ case_id = "RPDW1-006"; scenario_id = "SCN-EB044-REOPEN-DYNARRAY"; target = "Sheet1!B3"; expected_kind = "value"; expected_value = "3"; notes = "SEQUENCE spill tail baseline value." }
)

$manifestRows = @()
foreach ($sc in $scenarioDefs) {
    $scenarioPath = Join-Path $scenarioDir ($sc.scenario_id + ".json")
    $targets = @($cases | Where-Object { $_.scenario_id -eq $sc.scenario_id } | Select-Object -ExpandProperty target -Unique)
    $expectations = @()
    foreach ($t in $targets) {
        $expectations += [ordered]@{
            assertion_id = "ASSERT-$($sc.scenario_id)-$($t -replace '[^A-Za-z0-9]','_')"
            kind = "manual_review"
            target = $t
            expected = [ordered]@{ question = "Capture reopen determinism signal and compare against case registry." }
            confidence = "medium"
        }
    }

    $scenario = [ordered]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        topic = "reopen_wave1"
        priority = "P1"
        platform_target = @("windows_desktop")
        inputs = [ordered]@{
            workbook_fixture = $sc.fixture
            sheet_setup = @([ordered]@{ sheet = "Sheet1"; writes = $sc.writes })
        }
        operations = $sc.operations
        expectations = $expectations
        capture = [ordered]@{
            raw_capture = "raw_capture.json"
            normalized_capture = "normalized_capture.json"
            capture_fields = @("value","formula","display_text","number_format","calc_mode")
        }
        sources = @(
            "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/17_follow_up_execution_backlog.md",
            "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/09_coercion_matrix_expansion_response.md"
        )
        notes = "Reopen determinism wave1 scenario."
    }

    $scenario | ConvertTo-Json -Depth 40 | Set-Content -Path $scenarioPath

    $manifestRows += [pscustomobject]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        priority = "P1"
        domain = "reopen_determinism"
        fixture = $sc.fixture
        scenario_file = "scenarios/$($sc.scenario_id).json"
        status = "planned"
        notes = "reopen_wave1"
    }
}

$manifestRows | Export-Csv -Path (Join-Path $waveDir "scenario_manifest_wave1.csv") -NoTypeInformation
$cases | Export-Csv -Path (Join-Path $waveDir "reopen_case_registry_wave1.csv") -NoTypeInformation

$readmeContent = @'
# Reopen Wave 1

## Scope
Dedicated reopen-determinism probes for `ECS-EB-044`.

## Files
- `reopen_case_registry_wave1.csv`
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `run_wave1.ps1`
- `build_wave1_outputs.ps1`
- `ECS-EB-044_reopen_determinism_probe_wave1.csv`
- `WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`
'@
Set-Content -Path (Join-Path $waveDir "README.md") -Value $readmeContent

$runContent = @'
$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/reopen_wave1"
$evidenceRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reopen_wave1/evidence"

if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reopen_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reopen_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reopen_wave1/evidence --visible false --timeout-sec 300
if ($LASTEXITCODE -ne 0) { throw "reopen_wave1 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/reopen_wave1/build_wave1_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "reopen_wave1 output synthesis failed with exit code $LASTEXITCODE" }
'@
Set-Content -Path (Join-Path $waveDir "run_wave1.ps1") -Value $runContent

Write-Host "Seeded reopen wave1 scenarios:" $scenarioDefs.Count "cases:" $cases.Count
