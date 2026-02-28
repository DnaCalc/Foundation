Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir "..\..\..\..\..")).Path
$scenarioDir = Join-Path $waveDir "scenarios"
$fixtureRootRel = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/cf_wave1"

New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot $fixtureRootRel) | Out-Null

$source1 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/21_conditional_format_semantics_model_scaffold.md"
$source2 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/13_table_semantics_guide.md"
$source3 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/14_formatting_guide.md"

function New-Scenario {
    param(
        [string]$ScenarioId,
        [string]$TaskId,
        [object[]]$Writes,
        [object[]]$Operations
    )
    $fixture = "$fixtureRootRel/$ScenarioId.xlsx"
    [pscustomobject]@{
        scenario_id = $ScenarioId
        task_id = $TaskId
        fixture = $fixture
        writes = $Writes
        operations = $Operations
    }
}

$scenarioDefs = @(
    (New-Scenario -ScenarioId "SCN-EB031-CF-OVERLAP-STOP" -TaskId "ECS-EB-031" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = 1 },
        [ordered]@{ kind = "value"; address = "A2"; value = 2 },
        [ordered]@{ kind = "value"; address = "A3"; value = 3 }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "clear_cf"; target = "Sheet1!A1:A3" },
        [ordered]@{ op = "add_cf_expression"; target = "Sheet1!A1:A3"; args = [ordered]@{ formula = "=A1>=2"; interior_color = 255; stop_if_true = $true; set_first_priority = $true } },
        [ordered]@{ op = "add_cf_expression"; target = "Sheet1!A1:A3"; args = [ordered]@{ formula = "=A1<=2"; interior_color = 65280; stop_if_true = $false; set_last_priority = $true } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB032-CF-PRIORITY-TRANSITION" -TaskId "ECS-EB-032" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = 1 },
        [ordered]@{ kind = "value"; address = "A2"; value = 2 },
        [ordered]@{ kind = "value"; address = "A3"; value = 3 }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "clear_cf"; target = "Sheet1!A1:A3" },
        [ordered]@{ op = "add_cf_expression"; target = "Sheet1!A1:A3"; args = [ordered]@{ formula = "=A1>=2"; interior_color = 16711680; stop_if_true = $true; set_first_priority = $true } },
        [ordered]@{ op = "add_cf_expression"; target = "Sheet1!A1:A3"; args = [ordered]@{ formula = "=A1<=2"; interior_color = 65535; stop_if_true = $false; set_last_priority = $true } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "set_cf_stop_if_true"; target = "Sheet1!A1:A3"; args = [ordered]@{ index = 1; value = $false } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "set_cf_priority"; target = "Sheet1!A1:A3"; args = [ordered]@{ index = 2; set_first = $true } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB033-CF-TABLE-SPILL" -TaskId "ECS-EB-033" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = "Name" },
        [ordered]@{ kind = "value"; address = "B1"; value = "Val" },
        [ordered]@{ kind = "value"; address = "A2"; value = "x" },
        [ordered]@{ kind = "value"; address = "B2"; value = 1 },
        [ordered]@{ kind = "value"; address = "C1"; value = "Spill" }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "create_table"; target = "Sheet1!A1:B2"; args = [ordered]@{ name = "TblCfWave1"; has_headers = $true } },
        [ordered]@{ op = "clear_cf"; target = "Sheet1!B2:B20" },
        [ordered]@{ op = "add_cf_expression"; target = "Sheet1!B2:B20"; args = [ordered]@{ formula = '=$B2>=2'; interior_color = 16711680; stop_if_true = $false } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A3"; args = [ordered]@{ value = "y" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!B3"; args = [ordered]@{ value = 3 } },
        [ordered]@{ op = "clear_cf"; target = "Sheet1!C2:C20" },
        [ordered]@{ op = "add_cf_expression"; target = "Sheet1!C2:C20"; args = [ordered]@{ formula = "=C2>=2"; interior_color = 65535; stop_if_true = $false } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C2"; args = [ordered]@{ formula = "=SEQUENCE(3,1,1,1)" } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    ))
)

$cases = @(
    [pscustomobject]@{ case_id = "CFW1-001"; scenario_id = "SCN-EB031-CF-OVERLAP-STOP"; task_id = "ECS-EB-031"; family = "cf_overlap"; target = "Sheet1!A1"; expected_kind = "display_color"; expected_value = "65280"; confidence = "high"; notes = "A1 matches second rule only (green)." },
    [pscustomobject]@{ case_id = "CFW1-002"; scenario_id = "SCN-EB031-CF-OVERLAP-STOP"; task_id = "ECS-EB-031"; family = "cf_overlap"; target = "Sheet1!A2"; expected_kind = "display_color"; expected_value = "255"; confidence = "high"; notes = "A2 matches both; first rule stop-if-true should keep red." },
    [pscustomobject]@{ case_id = "CFW1-003"; scenario_id = "SCN-EB031-CF-OVERLAP-STOP"; task_id = "ECS-EB-031"; family = "cf_overlap"; target = "Sheet1!A3"; expected_kind = "display_color"; expected_value = "255"; confidence = "high"; notes = "A3 matches first rule only (red)." },
    [pscustomobject]@{ case_id = "CFW1-010"; scenario_id = "SCN-EB032-CF-PRIORITY-TRANSITION"; task_id = "ECS-EB-032"; family = "cf_priority_transition"; target = "Sheet1!A2"; expected_kind = "probe_transition"; expected_value = "2"; confidence = "medium"; notes = "A2 should expose at least two displayed-color states across stop-if-true/priority transitions." },
    [pscustomobject]@{ case_id = "CFW1-020"; scenario_id = "SCN-EB033-CF-TABLE-SPILL"; task_id = "ECS-EB-033"; family = "cf_table_spill"; target = "Sheet1!B3"; expected_kind = "display_color"; expected_value = "16711680"; confidence = "medium"; notes = "Appended table row should receive blue conditional format when B3>=2." },
    [pscustomobject]@{ case_id = "CFW1-021"; scenario_id = "SCN-EB033-CF-TABLE-SPILL"; task_id = "ECS-EB-033"; family = "cf_table_spill"; target = "Sheet1!C3"; expected_kind = "display_color"; expected_value = "65535"; confidence = "medium"; notes = "Spill target C3 should receive yellow conditional format for C3>=2." },
    [pscustomobject]@{ case_id = "CFW1-022"; scenario_id = "SCN-EB033-CF-TABLE-SPILL"; task_id = "ECS-EB-033"; family = "cf_table_spill"; target = "Sheet1!C4"; expected_kind = "display_color"; expected_value = "65535"; confidence = "medium"; notes = "Spill target C4 should receive yellow conditional format for C4>=2." }
)

$manifestRows = @()
foreach ($sc in $scenarioDefs) {
    $scenarioPath = Join-Path $scenarioDir ($sc.scenario_id + ".json")
    $targets = @($cases | Where-Object { $_.scenario_id -eq $sc.scenario_id } | Select-Object -ExpandProperty target)
    $expectations = @()
    foreach ($t in $targets) {
        $expectations += [ordered]@{
            assertion_id = "ASSERT-$($sc.scenario_id)-$($t -replace '[^A-Za-z0-9]','_')"
            kind = "manual_review"
            target = $t
            expected = [ordered]@{ question = "Capture conditional-format rendered outcome and compare to case registry." }
            confidence = "medium"
        }
    }

    $scenario = [ordered]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        topic = "cf_wave1"
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
            capture_fields = @("value","formula","display_text","number_format","display_interior_color","display_font_color","display_font_bold","display_number_format","calc_mode")
        }
        sources = @($source1, $source2, $source3)
        notes = "Conditional-format wave1 empirical scenario."
    }

    $scenario | ConvertTo-Json -Depth 40 | Set-Content -Path $scenarioPath

    $manifestRows += [pscustomobject]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        priority = "P1"
        domain = "conditional_format"
        fixture = $sc.fixture
        scenario_file = "scenarios/$($sc.scenario_id).json"
        status = "planned"
        notes = "cf_wave1"
    }
}

$manifestRows | Export-Csv -Path (Join-Path $waveDir "scenario_manifest_wave1.csv") -NoTypeInformation
$cases | Export-Csv -Path (Join-Path $waveDir "cf_case_registry_wave1.csv") -NoTypeInformation

$readmeContent = @'
# Conditional Format Wave 1

## Scope
Interleaved execution batch for conditional-format backlog items:
- `ECS-EB-031` overlap/stop-if-true fixture set
- `ECS-EB-032` priority/stop-if-true transition probes
- `ECS-EB-033` table + spill conditional-format interaction probes

## Files
- `cf_case_registry_wave1.csv`
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `run_wave1.ps1`
- `build_wave1_outputs.ps1`
- `ECS-EB-031_cf_overlap_fixture_manifest_wave1.csv`
- `ECS-EB-032_cf_stopiftrue_probe_wave1.csv`
- `ECS-EB-033_cf_table_spill_interaction_probe_wave1.csv`
- `WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`
'@
Set-Content -Path (Join-Path $waveDir "README.md") -Value $readmeContent

$runContent = @'
$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/cf_wave1"
$evidenceRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/evidence"

if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/evidence --visible false --timeout-sec 300
if ($LASTEXITCODE -ne 0) { throw "cf_wave1 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/cf_wave1/build_wave1_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "cf_wave1 output synthesis failed with exit code $LASTEXITCODE" }
'@
Set-Content -Path (Join-Path $waveDir "run_wave1.ps1") -Value $runContent

Write-Host "Seeded conditional-format wave1 scenarios:" $scenarioDefs.Count "cases:" $cases.Count
