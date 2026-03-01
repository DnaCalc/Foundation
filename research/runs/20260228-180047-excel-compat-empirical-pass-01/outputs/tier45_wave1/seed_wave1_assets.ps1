Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir "..\..\..\..\..")).Path
$scenarioDir = Join-Path $waveDir "scenarios"
$fixtureRootRel = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/tier45_wave1"

New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot $fixtureRootRel) | Out-Null

$source1 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/06_tier5_semantics_response.md"
$source2 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/08_tier4_family_semantics_response.md"
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
    (New-Scenario -ScenarioId "SCN-EB018-DYNARRAY-MIXED" -TaskId "ECS-EB-018" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = 1 },
        [ordered]@{ kind = "value"; address = "A2"; value = 2 },
        [ordered]@{ kind = "value"; address = "A3"; value = 3 },
        [ordered]@{ kind = "value"; address = "A4"; value = "x" }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C1"; args = [ordered]@{ formula = '=FILTER(A1:A4,A1:A4<>"x")' } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!D1"; args = [ordered]@{ formula = "=UNIQUE(A1:A4)" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!E1"; args = [ordered]@{ formula = "=SORT(A1:A4)" } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB019-LAMBDA-HELPER-EDGE" -TaskId "ECS-EB-019" -Writes @(
        [ordered]@{ kind = "value"; address = "A5"; value = 1 },
        [ordered]@{ kind = "value"; address = "B5"; value = 2 },
        [ordered]@{ kind = "value"; address = "A6"; value = 3 },
        [ordered]@{ kind = "value"; address = "B6"; value = 4 }
    ) -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C1"; args = [ordered]@{ formula = "=LAMBDA(x,x+1)(5)" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C2"; args = [ordered]@{ formula = "=LET(x,5,y,2,x+y)" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!C3"; args = [ordered]@{ formula = "=BYROW(A5:B6,LAMBDA(r,SUM(r)))" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!D3"; args = [ordered]@{ formula = "=MAP(A5:A6,LAMBDA(x,x*2))" } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB020-CUBE-CONTRACT" -TaskId "ECS-EB-020" -Writes @() -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A1"; args = [ordered]@{ formula = '=CUBEMEMBER("ThisWorkbookDataModel","[Measures].[NonExistent]")'; allow_error = $true } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A2"; args = [ordered]@{ formula = '=CUBEVALUE("ThisWorkbookDataModel",A1)'; allow_error = $true } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A3"; args = [ordered]@{ formula = '=CUBESET("ThisWorkbookDataModel","{}")'; allow_error = $true } },
        [ordered]@{ op = "recalc"; target = "workbook" }
    )),
    (New-Scenario -ScenarioId "SCN-EB021-EXTERNAL-REPLAY" -TaskId "ECS-EB-021" -Writes @() -Operations @(
        [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A1"; args = [ordered]@{ formula = '=WEBSERVICE("https://example.com")'; allow_error = $true } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A2"; args = [ordered]@{ formula = '=ENCODEURL("a b")' } },
        [ordered]@{ op = "edit_cell"; target = "Sheet1!A3"; args = [ordered]@{ formula = '=FILTERXML("<root><v>1</v></root>","//v")'; allow_error = $true } },
        [ordered]@{ op = "recalc"; target = "workbook" },
        [ordered]@{ op = "save"; target = "workbook" },
        [ordered]@{ op = "close"; target = "workbook" },
        [ordered]@{ op = "open"; target = "workbook" },
        [ordered]@{ op = "recalc"; target = "workbook" }
    ))
)

$cases = @(
    [pscustomobject]@{ case_id = "T45W1-001"; scenario_id = "SCN-EB018-DYNARRAY-MIXED"; task_id = "ECS-EB-018"; function_name = "FILTER"; target = "Sheet1!C1"; expected_kind = "value"; expected_value = "1"; confidence = "medium"; notes = "FILTER mixed-type baseline first spill cell." },
    [pscustomobject]@{ case_id = "T45W1-002"; scenario_id = "SCN-EB018-DYNARRAY-MIXED"; task_id = "ECS-EB-018"; function_name = "FILTER"; target = "Sheet1!C3"; expected_kind = "value"; expected_value = "3"; confidence = "medium"; notes = "FILTER mixed-type baseline third spill cell." },
    [pscustomobject]@{ case_id = "T45W1-003"; scenario_id = "SCN-EB018-DYNARRAY-MIXED"; task_id = "ECS-EB-018"; function_name = "UNIQUE"; target = "Sheet1!D4"; expected_kind = "value"; expected_value = "x"; confidence = "low"; notes = "UNIQUE should retain text member in spill." },
    [pscustomobject]@{ case_id = "T45W1-004"; scenario_id = "SCN-EB018-DYNARRAY-MIXED"; task_id = "ECS-EB-018"; function_name = "SORT"; target = "Sheet1!E1"; expected_kind = "value"; expected_value = "1"; confidence = "low"; notes = "SORT mixed-type baseline first spill cell." },
    [pscustomobject]@{ case_id = "T45W1-010"; scenario_id = "SCN-EB019-LAMBDA-HELPER-EDGE"; task_id = "ECS-EB-019"; function_name = "LAMBDA"; target = "Sheet1!C1"; expected_kind = "value"; expected_value = "6"; confidence = "high"; notes = "Inline LAMBDA invocation baseline." },
    [pscustomobject]@{ case_id = "T45W1-011"; scenario_id = "SCN-EB019-LAMBDA-HELPER-EDGE"; task_id = "ECS-EB-019"; function_name = "LET"; target = "Sheet1!C2"; expected_kind = "value"; expected_value = "7"; confidence = "high"; notes = "LET binding baseline." },
    [pscustomobject]@{ case_id = "T45W1-012"; scenario_id = "SCN-EB019-LAMBDA-HELPER-EDGE"; task_id = "ECS-EB-019"; function_name = "BYROW"; target = "Sheet1!C4"; expected_kind = "value"; expected_value = "7"; confidence = "medium"; notes = "BYROW spill second row baseline." },
    [pscustomobject]@{ case_id = "T45W1-013"; scenario_id = "SCN-EB019-LAMBDA-HELPER-EDGE"; task_id = "ECS-EB-019"; function_name = "MAP"; target = "Sheet1!D4"; expected_kind = "value"; expected_value = "6"; confidence = "medium"; notes = "MAP spill second row baseline." },
    [pscustomobject]@{ case_id = "T45W1-020"; scenario_id = "SCN-EB020-CUBE-CONTRACT"; task_id = "ECS-EB-020"; function_name = "CUBEMEMBER"; target = "Sheet1!A1"; expected_kind = "formula_contains"; expected_value = "CUBEMEMBER"; confidence = "medium"; notes = "CUBE contract: formula entry acceptance." },
    [pscustomobject]@{ case_id = "T45W1-021"; scenario_id = "SCN-EB020-CUBE-CONTRACT"; task_id = "ECS-EB-020"; function_name = "CUBEVALUE"; target = "Sheet1!A2"; expected_kind = "formula_contains"; expected_value = "CUBEVALUE"; confidence = "medium"; notes = "CUBE contract: formula entry acceptance." },
    [pscustomobject]@{ case_id = "T45W1-022"; scenario_id = "SCN-EB020-CUBE-CONTRACT"; task_id = "ECS-EB-020"; function_name = "CUBESET"; target = "Sheet1!A3"; expected_kind = "formula_contains"; expected_value = "CUBESET"; confidence = "medium"; notes = "CUBE contract: formula entry acceptance." },
    [pscustomobject]@{ case_id = "T45W1-030"; scenario_id = "SCN-EB021-EXTERNAL-REPLAY"; task_id = "ECS-EB-021"; function_name = "ENCODEURL"; target = "Sheet1!A2"; expected_kind = "value"; expected_value = "a%20b"; confidence = "high"; notes = "ENCODEURL deterministic literal baseline." },
    [pscustomobject]@{ case_id = "T45W1-031"; scenario_id = "SCN-EB021-EXTERNAL-REPLAY"; task_id = "ECS-EB-021"; function_name = "ENCODEURL"; target = "Sheet1!A2"; expected_kind = "stable_replay"; expected_value = "1"; confidence = "high"; notes = "ENCODEURL value should remain stable across save/close/reopen/recalc." },
    [pscustomobject]@{ case_id = "T45W1-032"; scenario_id = "SCN-EB021-EXTERNAL-REPLAY"; task_id = "ECS-EB-021"; function_name = "WEBSERVICE"; target = "Sheet1!A1"; expected_kind = "probe"; expected_value = ""; confidence = "low"; notes = "WEBSERVICE external dependency probe across replay cycle." },
    [pscustomobject]@{ case_id = "T45W1-033"; scenario_id = "SCN-EB021-EXTERNAL-REPLAY"; task_id = "ECS-EB-021"; function_name = "FILTERXML"; target = "Sheet1!A3"; expected_kind = "stable_replay"; expected_value = "1"; confidence = "medium"; notes = "FILTERXML should stay stable under replay cycle when formula is accepted." }
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
            expected = [ordered]@{ question = "Capture tier4/tier5 function behavior and compare to case registry." }
            confidence = "medium"
        }
    }

    $scenario = [ordered]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        topic = "tier45_wave1"
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
        notes = "Tier4/5 wave1 empirical scenario."
    }

    $scenario | ConvertTo-Json -Depth 40 | Set-Content -Path $scenarioPath

    $manifestRows += [pscustomobject]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        priority = "P1"
        domain = "tier45"
        fixture = $sc.fixture
        scenario_file = "scenarios/$($sc.scenario_id).json"
        status = "planned"
        notes = "tier45_wave1"
    }
}

$manifestRows | Export-Csv -Path (Join-Path $waveDir "scenario_manifest_wave1.csv") -NoTypeInformation
$cases | Export-Csv -Path (Join-Path $waveDir "tier45_case_registry_wave1.csv") -NoTypeInformation

$readmeContent = @'
# Tier4/5 Wave 1

## Scope
Interleaved execution batch for tier-5 platform caveats and tier-4/3 deep semantics:
- `ECS-EB-018` dynamic-array mixed-type probes
- `ECS-EB-019` LAMBDA/helper edge probes
- `ECS-EB-020` CUBE contract probes
- `ECS-EB-021` external-data replay probes
- `ECS-EB-017` tier-5 platform caveat report synthesis
- `ECS-EB-022` tier-3 expansion queue synthesis

## Files
- `tier45_case_registry_wave1.csv`
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `run_wave1.ps1`
- `build_wave1_outputs.ps1`
- `ECS-EB-018_dynamic_array_mixed_type_probe_wave1.csv`
- `ECS-EB-019_lambda_helper_edge_probe_wave1.csv`
- `ECS-EB-020_cube_contract_probe_wave1.csv`
- `ECS-EB-021_external_data_replay_probe_wave1.csv`
- `ECS-EB-017_tier5_platform_caveat_report_wave1.md`
- `ECS-EB-022_tier3_expansion_queue_wave1.csv`
- `WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`
'@
Set-Content -Path (Join-Path $waveDir "README.md") -Value $readmeContent

$runContent = @'
$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/tier45_wave1"
$evidenceRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/evidence"

if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/evidence --visible false --timeout-sec 300
if ($LASTEXITCODE -ne 0) { throw "tier45_wave1 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/tier45_wave1/build_wave1_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "tier45_wave1 output synthesis failed with exit code $LASTEXITCODE" }
'@
Set-Content -Path (Join-Path $waveDir "run_wave1.ps1") -Value $runContent

Write-Host "Seeded tier45 wave1 scenarios:" $scenarioDefs.Count "cases:" $cases.Count
