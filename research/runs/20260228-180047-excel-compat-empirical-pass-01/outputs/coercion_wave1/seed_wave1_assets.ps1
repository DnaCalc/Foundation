Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$waveDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $waveDir "..\..\..\..\..")).Path
$scenarioDir = Join-Path $waveDir "scenarios"
$fixtureRootRel = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/coercion_wave1"

New-Item -ItemType Directory -Force -Path $scenarioDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot $fixtureRootRel) | Out-Null

$source1 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/07_coercion_matrix_response.md"
$source2 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/09_coercion_matrix_expansion_response.md"
$source3 = "../../20260228-130325-excel-compat-spec-index-pass-01/outputs/coercion_matrix_expanded.csv"

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

$autoCalcOps = @(
    [ordered]@{ op = "set_calc_mode"; target = "workbook"; args = [ordered]@{ mode = "automatic" } },
    [ordered]@{ op = "recalc"; target = "workbook" }
)

$scenarioDefs = @(
    (New-Scenario -ScenarioId "SCN-EB024-OP-CORE" -TaskId "ECS-EB-024" -Writes @(
        [ordered]@{ kind = "formula"; address = "B1"; value = '="2"+3' },
        [ordered]@{ kind = "formula"; address = "B2"; value = '="x"+1' },
        [ordered]@{ kind = "formula"; address = "B3"; value = "=TRUE*5" },
        [ordered]@{ kind = "formula"; address = "B4"; value = "=TRUE+1" },
        [ordered]@{ kind = "formula"; address = "B5"; value = "=FALSE+1" },
        [ordered]@{ kind = "formula"; address = "B6"; value = '=1&"a"' },
        [ordered]@{ kind = "formula"; address = "B7"; value = '=1="1"' },
        [ordered]@{ kind = "formula"; address = "B8"; value = "=TODAY()+1" },
        [ordered]@{ kind = "formula"; address = "B9"; value = "=TODAY()" },
        [ordered]@{ kind = "formula"; address = "B10"; value = "=B8-B9" }
    ) -Operations $autoCalcOps),
    (New-Scenario -ScenarioId "SCN-EB025-FUNCTION-CORE" -TaskId "ECS-EB-025" -Writes @(
        [ordered]@{ kind = "formula"; address = "B1"; value = '=N("abc")' },
        [ordered]@{ kind = "formula"; address = "B2"; value = "=N(TRUE)" },
        [ordered]@{ kind = "formula"; address = "B3"; value = "=N(5)" },
        [ordered]@{ kind = "formula"; address = "B4"; value = "=TYPE(1)" },
        [ordered]@{ kind = "formula"; address = "B5"; value = '=TYPE("x")' },
        [ordered]@{ kind = "formula"; address = "B6"; value = "=TYPE(TRUE)" },
        [ordered]@{ kind = "formula"; address = "B7"; value = "=TYPE(NA())" },
        [ordered]@{ kind = "formula"; address = "B8"; value = '=VALUE("123.45")' },
        [ordered]@{ kind = "formula"; address = "B9"; value = '=VALUE("abc")' },
        [ordered]@{ kind = "formula"; address = "B10"; value = "=T(123)" },
        [ordered]@{ kind = "formula"; address = "B11"; value = '=T("abc")' },
        [ordered]@{ kind = "formula"; address = "B12"; value = "=VALUETOTEXT(123.45)" },
        [ordered]@{ kind = "formula"; address = "B13"; value = "=VALUETOTEXT(NA())" }
    ) -Operations $autoCalcOps),
    (New-Scenario -ScenarioId "SCN-EB025-AGG-COERCION" -TaskId "ECS-EB-025" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = "1" },
        [ordered]@{ kind = "value"; address = "A2"; value = 2 },
        [ordered]@{ kind = "value"; address = "A3"; value = "x" },
        [ordered]@{ kind = "value"; address = "A4"; value = $true },
        [ordered]@{ kind = "value"; address = "A5"; value = "" },
        [ordered]@{ kind = "formula"; address = "B1"; value = '=SUM("1",2)' },
        [ordered]@{ kind = "formula"; address = "B2"; value = "=SUM(A1:A3)" },
        [ordered]@{ kind = "formula"; address = "B3"; value = '=AVERAGE("2",4)' },
        [ordered]@{ kind = "formula"; address = "B4"; value = "=AVERAGE(A1:A3)" },
        [ordered]@{ kind = "formula"; address = "B5"; value = "=COUNT(A1:A3)" },
        [ordered]@{ kind = "formula"; address = "B6"; value = "=COUNTA(A1:A3)" },
        [ordered]@{ kind = "formula"; address = "B7"; value = "=SUMPRODUCT(--(A1:A2))" },
        [ordered]@{ kind = "formula"; address = "B8"; value = '=IF("0",1,2)' },
        [ordered]@{ kind = "formula"; address = "B9"; value = '=IF("",1,2)' }
    ) -Operations $autoCalcOps),
    (New-Scenario -ScenarioId "SCN-EB026-NESTED-PRECEDENCE" -TaskId "ECS-EB-026" -Writes @(
        [ordered]@{ kind = "value"; address = "A1"; value = 1 },
        [ordered]@{ kind = "value"; address = "B1"; value = 4 },
        [ordered]@{ kind = "formula"; address = "B1"; value = "=1+2*3" },
        [ordered]@{ kind = "formula"; address = "B2"; value = "=(1+2)*3" },
        [ordered]@{ kind = "formula"; address = "B3"; value = '=--"1"+2' },
        [ordered]@{ kind = "formula"; address = "B4"; value = "=1&2+3" },
        [ordered]@{ kind = "formula"; address = "B5"; value = "=1+2&3" },
        [ordered]@{ kind = "formula"; address = "B6"; value = "=2^3*2" },
        [ordered]@{ kind = "formula"; address = "B7"; value = "=-2^2" },
        [ordered]@{ kind = "formula"; address = "B8"; value = "=(-2)^2" },
        [ordered]@{ kind = "formula"; address = "B9"; value = "=SUM(A1,,B1)" }
    ) -Operations $autoCalcOps)
)

$cases = @(
    [pscustomobject]@{ case_id = "CW1-001"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B1"; formula = '="2"+3'; expected_kind = "value"; expected_value = "5"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "numeric text plus number" },
    [pscustomobject]@{ case_id = "CW1-002"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B2"; formula = '="x"+1'; expected_kind = "error"; expected_value = ""; expected_error = "#VALUE!"; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "non-numeric text plus number" },
    [pscustomobject]@{ case_id = "CW1-003"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B3"; formula = "=TRUE*5"; expected_kind = "value"; expected_value = "5"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "boolean multiply coercion" },
    [pscustomobject]@{ case_id = "CW1-004"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B4"; formula = "=TRUE+1"; expected_kind = "value"; expected_value = "2"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "boolean add coercion" },
    [pscustomobject]@{ case_id = "CW1-005"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B5"; formula = "=FALSE+1"; expected_kind = "value"; expected_value = "1"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "boolean add coercion false" },
    [pscustomobject]@{ case_id = "CW1-006"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B6"; formula = '=1&"a"'; expected_kind = "value"; expected_value = "1a"; expected_error = ""; confidence = "high"; source_anchor = "coercion_matrix_expanded"; notes = "concat coercion" },
    [pscustomobject]@{ case_id = "CW1-007"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B7"; formula = '=1="1"'; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "low"; source_anchor = "coercion_matrix_expanded"; notes = "comparison coercion probe" },
    [pscustomobject]@{ case_id = "CW1-008"; scenario_id = "SCN-EB024-OP-CORE"; task_id = "ECS-EB-024"; family = "operator"; target = "Sheet1!B10"; formula = "=B8-B9"; expected_kind = "value"; expected_value = "1"; expected_error = ""; confidence = "high"; source_anchor = "coercion_matrix_expanded"; notes = "date serial delta under arithmetic" },
    [pscustomobject]@{ case_id = "CW1-009"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B1"; formula = '=N("abc")'; expected_kind = "value"; expected_value = "0"; expected_error = ""; confidence = "high"; source_anchor = "support_n_function"; notes = "N text coercion" },
    [pscustomobject]@{ case_id = "CW1-010"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B2"; formula = "=N(TRUE)"; expected_kind = "value"; expected_value = "1"; expected_error = ""; confidence = "high"; source_anchor = "support_n_function"; notes = "N logical coercion" },
    [pscustomobject]@{ case_id = "CW1-011"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B4"; formula = "=TYPE(1)"; expected_kind = "value"; expected_value = "1"; expected_error = ""; confidence = "high"; source_anchor = "support_type_function"; notes = "TYPE number" },
    [pscustomobject]@{ case_id = "CW1-012"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B5"; formula = '=TYPE("x")'; expected_kind = "value"; expected_value = "2"; expected_error = ""; confidence = "high"; source_anchor = "support_type_function"; notes = "TYPE text" },
    [pscustomobject]@{ case_id = "CW1-013"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B6"; formula = "=TYPE(TRUE)"; expected_kind = "value"; expected_value = "4"; expected_error = ""; confidence = "high"; source_anchor = "support_type_function"; notes = "TYPE logical" },
    [pscustomobject]@{ case_id = "CW1-014"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B7"; formula = "=TYPE(NA())"; expected_kind = "value"; expected_value = "16"; expected_error = ""; confidence = "high"; source_anchor = "support_type_function"; notes = "TYPE error" },
    [pscustomobject]@{ case_id = "CW1-015"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B8"; formula = '=VALUE("123.45")'; expected_kind = "value"; expected_value = "123.45"; expected_error = ""; confidence = "high"; source_anchor = "support_value_function"; notes = "VALUE numeric text" },
    [pscustomobject]@{ case_id = "CW1-016"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B9"; formula = '=VALUE("abc")'; expected_kind = "error"; expected_value = ""; expected_error = "#VALUE!"; confidence = "high"; source_anchor = "support_value_function"; notes = "VALUE invalid text" },
    [pscustomobject]@{ case_id = "CW1-017"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B10"; formula = "=T(123)"; expected_kind = "value"; expected_value = ""; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "T numeric coercion" },
    [pscustomobject]@{ case_id = "CW1-018"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B11"; formula = '=T("abc")'; expected_kind = "value"; expected_value = "abc"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "T text pass-through" },
    [pscustomobject]@{ case_id = "CW1-019"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B12"; formula = "=VALUETOTEXT(123.45)"; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "VALUETOTEXT rendering probe" },
    [pscustomobject]@{ case_id = "CW1-020"; scenario_id = "SCN-EB025-FUNCTION-CORE"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B13"; formula = "=VALUETOTEXT(NA())"; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "VALUETOTEXT error rendering probe" },
    [pscustomobject]@{ case_id = "CW1-021"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B1"; formula = '=SUM("1",2)'; expected_kind = "value"; expected_value = "3"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "SUM direct-arg text numeric coercion" },
    [pscustomobject]@{ case_id = "CW1-022"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B2"; formula = "=SUM(A1:A3)"; expected_kind = "value"; expected_value = "2"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "SUM range text handling" },
    [pscustomobject]@{ case_id = "CW1-023"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B3"; formula = '=AVERAGE("2",4)'; expected_kind = "value"; expected_value = "3"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "AVERAGE direct-arg coercion" },
    [pscustomobject]@{ case_id = "CW1-024"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B4"; formula = "=AVERAGE(A1:A3)"; expected_kind = "value"; expected_value = "2"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "AVERAGE range text handling" },
    [pscustomobject]@{ case_id = "CW1-025"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B5"; formula = "=COUNT(A1:A3)"; expected_kind = "value"; expected_value = "1"; expected_error = ""; confidence = "high"; source_anchor = "coercion_matrix_expanded"; notes = "COUNT range handling" },
    [pscustomobject]@{ case_id = "CW1-026"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B6"; formula = "=COUNTA(A1:A3)"; expected_kind = "value"; expected_value = "3"; expected_error = ""; confidence = "high"; source_anchor = "coercion_matrix_expanded"; notes = "COUNTA range handling" },
    [pscustomobject]@{ case_id = "CW1-027"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B7"; formula = "=SUMPRODUCT(--(A1:A2))"; expected_kind = "value"; expected_value = "3"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "SUMPRODUCT unary coercion" },
    [pscustomobject]@{ case_id = "CW1-028"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B8"; formula = '=IF("0",1,2)'; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "low"; source_anchor = "coercion_matrix_expanded"; notes = "IF logical coercion probe non-empty text" },
    [pscustomobject]@{ case_id = "CW1-029"; scenario_id = "SCN-EB025-AGG-COERCION"; task_id = "ECS-EB-025"; family = "function"; target = "Sheet1!B9"; formula = '=IF("",1,2)'; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "low"; source_anchor = "coercion_matrix_expanded"; notes = "IF logical coercion probe empty text" },
    [pscustomobject]@{ case_id = "CW1-030"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B1"; formula = "=1+2*3"; expected_kind = "value"; expected_value = "7"; expected_error = ""; confidence = "high"; source_anchor = "support_operator_precedence"; notes = "precedence baseline" },
    [pscustomobject]@{ case_id = "CW1-031"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B2"; formula = "=(1+2)*3"; expected_kind = "value"; expected_value = "9"; expected_error = ""; confidence = "high"; source_anchor = "support_operator_precedence"; notes = "parentheses override precedence" },
    [pscustomobject]@{ case_id = "CW1-032"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B3"; formula = '=--"1"+2'; expected_kind = "value"; expected_value = "3"; expected_error = ""; confidence = "medium"; source_anchor = "coercion_matrix_expanded"; notes = "nested unary coercion precedence" },
    [pscustomobject]@{ case_id = "CW1-033"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B4"; formula = "=1&2+3"; expected_kind = "value"; expected_value = "15"; expected_error = ""; confidence = "medium"; source_anchor = "support_operator_precedence"; notes = "concat after addition precedence" },
    [pscustomobject]@{ case_id = "CW1-034"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B5"; formula = "=1+2&3"; expected_kind = "value"; expected_value = "33"; expected_error = ""; confidence = "medium"; source_anchor = "support_operator_precedence"; notes = "addition before concat precedence" },
    [pscustomobject]@{ case_id = "CW1-035"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B6"; formula = "=2^3*2"; expected_kind = "value"; expected_value = "16"; expected_error = ""; confidence = "high"; source_anchor = "support_operator_precedence"; notes = "power precedence" },
    [pscustomobject]@{ case_id = "CW1-036"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B7"; formula = "=-2^2"; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "low"; source_anchor = "coercion_matrix_expanded"; notes = "unary minus with exponent precedence probe" },
    [pscustomobject]@{ case_id = "CW1-037"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B8"; formula = "=(-2)^2"; expected_kind = "value"; expected_value = "4"; expected_error = ""; confidence = "high"; source_anchor = "support_operator_precedence"; notes = "parenthesized negative exponent" },
    [pscustomobject]@{ case_id = "CW1-038"; scenario_id = "SCN-EB026-NESTED-PRECEDENCE"; task_id = "ECS-EB-026"; family = "compat_precedence"; target = "Sheet1!B9"; formula = "=SUM(A1,,B1)"; expected_kind = "probe"; expected_value = ""; expected_error = ""; confidence = "low"; source_anchor = "coercion_matrix_expanded"; notes = "compatibility syntax ambiguity probe current build only" }
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
            expected = [ordered]@{ question = "Capture coercion outcome and compare against expected case registry." }
            confidence = "medium"
        }
    }

    $scenario = [ordered]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        topic = "coercion_wave1"
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
        notes = "Coercion wave1 empirical scenario."
    }

    $scenario | ConvertTo-Json -Depth 30 | Set-Content -Path $scenarioPath

    $manifestRows += [pscustomobject]@{
        scenario_id = $sc.scenario_id
        task_id = $sc.task_id
        priority = "P1"
        domain = "coercion"
        fixture = $sc.fixture
        scenario_file = "scenarios/$($sc.scenario_id).json"
        status = "planned"
        notes = "coercion_wave1"
    }
}

$manifestRows | Export-Csv -Path (Join-Path $waveDir "scenario_manifest_wave1.csv") -NoTypeInformation
$cases | Export-Csv -Path (Join-Path $waveDir "coercion_case_registry_wave1.csv") -NoTypeInformation

$readmeContent = @'
# Coercion Wave 1

## Scope
Interleaved execution batch for coercion backlog items:
- `ECS-EB-024` operator coercion truth table
- `ECS-EB-025` function-family coercion probes
- `ECS-EB-026` compatibility/nested precedence probes (current-build lane)
- `ECS-EB-027` confidence scoring synthesis

## Files
- `coercion_case_registry_wave1.csv`
- `scenario_manifest_wave1.csv`
- `scenarios/*.json`
- `run_wave1.ps1`
- `build_wave1_outputs.ps1`
- `ECS-EB-024_operator_coercion_truth_table_wave1.csv`
- `ECS-EB-025_function_family_coercion_probe_wave1.csv`
- `ECS-EB-026_compatibility_coercion_probe_wave1.csv`
- `ECS-EB-027_coercion_confidence_scores_wave1.csv`
- `WAVE1_EXECUTION_REPORT.md`
- `evidence/<scenario_id>/*`
'@
Set-Content -Path (Join-Path $waveDir "README.md") -Value $readmeContent

$runContent = @'
$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..\..")
Set-Location $repoRoot

$fixtureRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/fixtures/coercion_wave1"
$evidenceRoot = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/evidence"

if (Test-Path $fixtureRoot) { Remove-Item -Recurse -Force $fixtureRoot }
if (Test-Path $evidenceRoot) { Remove-Item -Recurse -Force $evidenceRoot }
New-Item -ItemType Directory -Force -Path $fixtureRoot | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceRoot | Out-Null

& research/tools/excel-probe/excel-probe.cmd run-manifest --manifest research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/scenario_manifest_wave1.csv --base-dir research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1 --out-root research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/evidence --visible false --timeout-sec 300
if ($LASTEXITCODE -ne 0) { throw "coercion_wave1 run-manifest failed with exit code $LASTEXITCODE" }

& powershell -NoProfile -ExecutionPolicy Bypass -File research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/coercion_wave1/build_wave1_outputs.ps1
if ($LASTEXITCODE -ne 0) { throw "coercion_wave1 output synthesis failed with exit code $LASTEXITCODE" }
'@
Set-Content -Path (Join-Path $waveDir "run_wave1.ps1") -Value $runContent

Write-Host "Seeded coercion wave1 scenarios:" $scenarioDefs.Count "cases:" $cases.Count
