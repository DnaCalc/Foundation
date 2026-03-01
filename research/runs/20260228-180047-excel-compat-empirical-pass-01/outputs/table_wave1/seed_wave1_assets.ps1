Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir "..\..\..\..\..")).Path
$scenarioDir = Join-Path $waveDir "scenarios"
$fixtureRootRel = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/table_wave1"

New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot $fixtureRootRel) | Out-Null

$source1 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/13_table_semantics_guide.md"
$source2 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/14_formatting_guide.md"
$source3 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/15_version_platform_guide.md"

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
    (New-Scenario -ScenarioId "SCN-EB034-STRUCTREF-SPILL" -TaskId "ECS-EB-034" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = "Item" },
        [ordered]@{ kind = "value"; address = "B1"; value = "Val" },
        [ordered]@{ kind = "value"; address = "C1"; value = "Calc" },
        [ordered]@{ kind = "value"; address = "A2"; value = "a" },
        [ordered]@{ kind = "value"; address = "B2"; value = 1 },
        [ordered]@{ kind = "value"; address = "A3"; value = "b" },
        [ordered]@{ kind = "value"; address = "B3"; value = 2 }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "create_table"; target = "Sheet1!A1:C3"; args = [ordered]@{ name = "TblMain"; has_headers = $true } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C2"; args = [ordered]@{ formula = "=[@Val]*2" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!D2"; args = [ordered]@{ formula = "=SUM(TblMain[Val])" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!E2"; args = [ordered]@{ formula = "=SEQUENCE(ROWS(TblMain[Val]),1,1,1)" } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A4"; args = [ordered]@{ value = "c" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!B4"; args = [ordered]@{ value = 3 } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB035-GROW-SHRINK-COERCION-FORMAT" -TaskId "ECS-EB-035" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = "Item" },
        [ordered]@{ kind = "value"; address = "B1"; value = "Val" },
        [ordered]@{ kind = "value"; address = "A2"; value = "a" },
        [ordered]@{ kind = "value"; address = "B2"; value = 1 },
        [ordered]@{ kind = "value"; address = "A3"; value = "b" },
        [ordered]@{ kind = "value"; address = "B3"; value = "2" },
        [ordered]@{ kind = "format"; address = "B2:B8"; value = "0.00" }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "create_table"; target = "Sheet1!A1:B3"; args = [ordered]@{ name = "TblResize"; has_headers = $true } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!D2"; args = [ordered]@{ formula = "=SUM(TblResize[Val])" } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A4"; args = [ordered]@{ value = "c" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!B4"; args = [ordered]@{ value = "4" } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "delete_row"; target = "Sheet1!4:4" },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB036-AUTOEXPAND-AUTOFILL" -TaskId "ECS-EB-036" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = "Key" },
        [ordered]@{ kind = "value"; address = "B1"; value = "Val" },
        [ordered]@{ kind = "value"; address = "C1"; value = "Calc" },
        [ordered]@{ kind = "value"; address = "A2"; value = 1 },
        [ordered]@{ kind = "value"; address = "B2"; value = 10 }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "create_table"; target = "Sheet1!A1:C2"; args = [ordered]@{ name = "TblPlatform"; has_headers = $true } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C2"; args = [ordered]@{ formula = "=[@Val]*10" } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A3"; args = [ordered]@{ value = 2 } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!B3"; args = [ordered]@{ value = 20 } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    ))
)

$cases = @(
    [pscustomobject]@{ case_id = "TBW1-001"; scenario_id = "SCN-EB034-STRUCTREF-SPILL"; task_id = "ECS-EB-034"; family = "table_spill"; target = "Sheet1!D2"; expected_kind = "value"; expected_value = "6"; confidence = "medium"; notes = "SUM(TblMain[Val]) should update after auto-expand row append." },
    [pscustomobject]@{ case_id = "TBW1-002"; scenario_id = "SCN-EB034-STRUCTREF-SPILL"; task_id = "ECS-EB-034"; family = "table_spill"; target = "Sheet1!E4"; expected_kind = "value"; expected_value = "3"; confidence = "low"; notes = "SEQUENCE spill based on ROWS(TblMain[Val]) should extend with table growth." },
    [pscustomobject]@{ case_id = "TBW1-003"; scenario_id = "SCN-EB034-STRUCTREF-SPILL"; task_id = "ECS-EB-034"; family = "table_spill"; target = "Sheet1!C4"; expected_kind = "value"; expected_value = "6"; confidence = "medium"; notes = "Calculated column should auto-fill formula to appended table row." },
    [pscustomobject]@{ case_id = "TBW1-004"; scenario_id = "SCN-EB034-STRUCTREF-SPILL"; task_id = "ECS-EB-034"; family = "table_spill"; target = "Sheet1!C4"; expected_kind = "formula_contains"; expected_value = "[@Val]*2"; confidence = "low"; notes = "Auto-filled table formula should preserve structured reference pattern." },
    [pscustomobject]@{ case_id = "TBW1-010"; scenario_id = "SCN-EB035-GROW-SHRINK-COERCION-FORMAT"; task_id = "ECS-EB-035"; family = "table_resize"; target = "Sheet1!D2"; expected_kind = "transition_min_unique"; expected_value = "2"; confidence = "medium"; notes = "SUM should change during grow/shrink sequence." },
    [pscustomobject]@{ case_id = "TBW1-011"; scenario_id = "SCN-EB035-GROW-SHRINK-COERCION-FORMAT"; task_id = "ECS-EB-035"; family = "table_resize"; target = "Sheet1!D2"; expected_kind = "value"; expected_value = "3"; confidence = "medium"; notes = "Final SUM should return to baseline after deleting appended row." },
    [pscustomobject]@{ case_id = "TBW1-012"; scenario_id = "SCN-EB035-GROW-SHRINK-COERCION-FORMAT"; task_id = "ECS-EB-035"; family = "table_resize"; target = "Sheet1!B3"; expected_kind = "number_format"; expected_value = "0.00"; confidence = "high"; notes = "Number format should remain applied through resize sequence." },
    [pscustomobject]@{ case_id = "TBW1-020"; scenario_id = "SCN-EB036-AUTOEXPAND-AUTOFILL"; task_id = "ECS-EB-036"; family = "platform_divergence"; target = "Sheet1!C3"; expected_kind = "value"; expected_value = "200"; confidence = "medium"; notes = "Windows baseline for auto-expand + calculated column fill." },
    [pscustomobject]@{ case_id = "TBW1-021"; scenario_id = "SCN-EB036-AUTOEXPAND-AUTOFILL"; task_id = "ECS-EB-036"; family = "platform_divergence"; target = "Sheet1!C3"; expected_kind = "formula_contains"; expected_value = "[@Val]*10"; confidence = "low"; notes = "Windows baseline formula shape for platform divergence table." }
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
            expected = [ordered]@{ question = "Capture table/spill interaction outcomes and compare to case registry." }
            confidence = "medium"
        }
    }

    $scenario = [ordered]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        topic = "table_wave1"
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
        sources = @($source1, $source2, $source3)
        notes = "Table wave1 empirical scenario."
    }

    $scenario | ConvertTo-Json -Depth 40 | Set-Content -Path $scenarioPath

    $manifestRows += [pscustomobject]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        priority = "P1"
        domain = "table"
        fixture = $sc.fixture
        scenario_file = "scenarios/$($sc.scenario_id).json"
        status = "planned"
        notes = "table_wave1"
    }
}

$manifestRows | Export-Csv -Path (Join-Path $waveDir "scenario_manifest_wave1.csv") -NoTypeInformation
$cases | Export-Csv -Path (Join-Path $waveDir "table_case_registry_wave1.csv") -NoTypeInformation

$readmeContent = @'
# Table Wave 1

## Scope
Interleaved execution batch for table/listobject backlog items:
- `ECS-EB-034` structured-reference + spill interaction probes
- `ECS-EB-035` table growth/shrink + coercion/format probes
- `ECS-EB-036` platform-divergence baseline probes

## Files
- `table_case_registry_wave1.csv`
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `run_wave1.ps1`
- `build_wave1_outputs.ps1`
- `ECS-EB-034_table_spill_interaction_matrix_wave1.csv`
- `ECS-EB-035_table_resize_coercion_format_probe_wave1.csv`
- `ECS-EB-036_table_platform_divergence_probe_wave1.csv`
- `WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`
'@
Set-Content -Path (Join-Path $waveDir "README.md") -Value $readmeContent

$runContent = @'
$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/table_wave1"
$evidenceRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/evidence"

if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/evidence --visible false --timeout-sec 300
if ($LASTEXITCODE -ne 0) { throw "table_wave1 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/table_wave1/build_wave1_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "table_wave1 output synthesis failed with exit code $LASTEXITCODE" }
'@
Set-Content -Path (Join-Path $waveDir "run_wave1.ps1") -Value $runContent

Write-Host "Seeded table wave1 scenarios:" $scenarioDefs.Count "cases:" $cases.Count
