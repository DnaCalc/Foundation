using System.Diagnostics;
using System.Globalization;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Win32;

internal static class Program
{
    static readonly JsonSerializerOptions JsonOptions = new() { WriteIndented = true };
    static readonly string InvocationCwd = Environment.GetEnvironmentVariable("EXCEL_PROBE_INVOKE_CWD")
        ?? Directory.GetCurrentDirectory();
    const int XlAutomatic = -4105;
    const int XlManual = -4135;
    const int XlSemiautomatic = 2;
    const int XlExpression = 2;

    sealed class WorkbookContext
    {
        public required dynamic Workbook { get; init; }
        public required string FixturePath { get; init; }
        public required bool FixturePreexisting { get; init; }
    }

    [STAThread]
    static int Main(string[] args)
    {
        try
        {
            if (args.Length == 0 || args[0] is "-h" or "--help" or "help")
            {
                Help();
                return 0;
            }
            return args[0] switch
            {
                "env" => CmdEnv(args.Skip(1).ToArray()),
                "run" => CmdRun(args.Skip(1).ToArray()),
                "run-manifest" => CmdRunManifest(args.Skip(1).ToArray()),
                _ => Fail($"Unknown command '{args[0]}'.")
            };
        }
        catch (Exception ex) { Console.Error.WriteLine(ex); return 1; }
    }

    static void Help() => Console.WriteLine("""
excel-probe (C#)
  env --out <dir>
  run --scenario <path> --out <dir> [--visible true|false] [--timeout-sec N]
  run-manifest --manifest <csv> --base-dir <dir> --out-root <dir> [--visible true|false] [--timeout-sec N]
""");

    static int CmdEnv(string[] args)
    {
        string? outDir = null;
        for (int i = 0; i < args.Length; i++) if (args[i] == "--out") outDir = args[++i]; else return Fail($"Unknown option '{args[i]}'.");
        if (string.IsNullOrWhiteSpace(outDir)) return Fail("--out is required.");
        var outPath = ResolveInputPath(outDir);
        Directory.CreateDirectory(outPath);
        var payload = new Dictionary<string, object?>
        {
            ["captured_utc"] = Utc(),
            ["platform"] = "windows_desktop",
            ["locale"] = CultureInfo.CurrentCulture.Name,
            ["excel_binary"] = ExcelBinary(),
            ["tooling"] = Tooling()
        };
        var path = Path.Combine(outPath, "excel_env_snapshot.json");
        WriteJson(path, payload);
        Console.WriteLine($"Wrote {path}");
        return 0;
    }

    static int CmdRun(string[] args)
    {
        string? scenario = null, outDir = null; bool visible = false; int timeout = 180;
        ParseRunArgs(args, ref scenario, ref outDir, ref visible, ref timeout);
        if (string.IsNullOrWhiteSpace(scenario)) return Fail("--scenario is required.");
        if (string.IsNullOrWhiteSpace(outDir)) return Fail("--out is required.");
        return ExecuteScenario(ResolveInputPath(scenario), ResolveInputPath(outDir), visible, timeout);
    }

    static int CmdRunManifest(string[] args)
    {
        string? manifest = null, baseDir = null, outRoot = null; bool visible = false; int timeout = 180;
        for (int i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--manifest": manifest = args[++i]; break;
                case "--base-dir": baseDir = args[++i]; break;
                case "--out-root": outRoot = args[++i]; break;
                case "--visible": visible = bool.Parse(args[++i]); break;
                case "--timeout-sec": timeout = int.Parse(args[++i], CultureInfo.InvariantCulture); break;
                default: return Fail($"Unknown option '{args[i]}'.");
            }
        }
        if (string.IsNullOrWhiteSpace(manifest) || string.IsNullOrWhiteSpace(baseDir) || string.IsNullOrWhiteSpace(outRoot))
            return Fail("--manifest, --base-dir and --out-root are required.");

        var lines = File.ReadAllLines(ResolveInputPath(manifest)).Where(l => !string.IsNullOrWhiteSpace(l)).ToList();
        if (lines.Count < 2) return Fail("Manifest has no scenario rows.");
        var headers = ParseCsvLine(lines[0]).ToArray();
        int iScenarioId = Array.IndexOf(headers, "scenario_id");
        int iScenarioFile = Array.IndexOf(headers, "scenario_file");
        if (iScenarioId < 0 || iScenarioFile < 0) return Fail("Manifest missing scenario_id/scenario_file columns.");

        int failures = 0;
        foreach (var line in lines.Skip(1))
        {
            var cells = ParseCsvLine(line);
            if (cells.Length <= Math.Max(iScenarioId, iScenarioFile)) continue;
            var scenarioId = cells[iScenarioId].Trim();
            var scenarioFile = cells[iScenarioFile].Trim();
            var scenarioPath = Path.GetFullPath(Path.Combine(ResolveInputPath(baseDir), scenarioFile));
            var outDir = Path.GetFullPath(Path.Combine(ResolveInputPath(outRoot), scenarioId));
            Console.WriteLine($"Running {scenarioId}");
            if (ExecuteScenario(scenarioPath, outDir, visible, timeout) != 0) failures++;
        }
        return failures == 0 ? 0 : 2;
    }

    static void ParseRunArgs(string[] args, ref string? scenario, ref string? outDir, ref bool visible, ref int timeout)
    {
        for (int i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--scenario": scenario = args[++i]; break;
                case "--out": outDir = args[++i]; break;
                case "--visible": visible = bool.Parse(args[++i]); break;
                case "--timeout-sec": timeout = int.Parse(args[++i], CultureInfo.InvariantCulture); break;
                default: throw new ArgumentException($"Unknown option '{args[i]}'.");
            }
        }
    }

    static int ExecuteScenario(string scenarioPath, string outDir, bool visible, int timeoutSec)
    {
        Directory.CreateDirectory(outDir);
        var manifestPath = Path.Combine(outDir, "run_manifest.json");
        var rawPath = Path.Combine(outDir, "raw_capture.json");
        var normPath = Path.Combine(outDir, "normalized_capture.json");
        var stepCapturePath = Path.Combine(outDir, "step_capture.json");
        var stdoutPath = Path.Combine(outDir, "stdout.log");
        var stderrPath = Path.Combine(outDir, "stderr.log");

        string runId = $"run-{DateTime.UtcNow:yyyyMMdd-HHmmss}-{Guid.NewGuid():N}".Substring(0, 29);
        string start = Utc();
        JsonObject? scenario = null;
        dynamic? excel = null;
        dynamic? workbook = null;
        int? excelPid = null;
        var messageFilterInstalled = false;

        try
        {
            OleMessageFilter.Register();
            messageFilterInstalled = true;

            if (!File.Exists(scenarioPath)) throw new FileNotFoundException("Scenario file not found.", scenarioPath);
            scenario = JsonNode.Parse(File.ReadAllText(scenarioPath))?.AsObject() ?? throw new InvalidOperationException("Invalid scenario json");

            var tool = Tooling();
            var excelBinary = ExcelBinary();
            var sw = Stopwatch.StartNew();

            var t = Type.GetTypeFromProgID("Excel.Application", true) ?? throw new InvalidOperationException("Excel COM unavailable.");
            excel = Activator.CreateInstance(t)!;
            excel.Visible = visible;
            excel.DisplayAlerts = false;
            excel.ScreenUpdating = visible;
            excelPid = ExcelPid((int)excel.Hwnd);

            var wb = EnsureWorkbook(excel, scenario);
            workbook = wb.Workbook;
            var fixturePath = wb.FixturePath;
            var fixturePreexisting = wb.FixturePreexisting;
            var targets = CaptureTargets(scenario);
            var stepCaptures = new List<Dictionary<string, object?>>();
            stepCaptures.Add(CaptureStep(workbook, targets, "initial_after_setup", "setup"));

            var opTrace = new List<Dictionary<string, object?>>();
            foreach (var opNode in (scenario["operations"] as JsonArray ?? []))
            {
                if (sw.Elapsed > TimeSpan.FromSeconds(timeoutSec)) throw new TimeoutException($"Scenario timeout {timeoutSec}s.");
                var op = opNode!.AsObject();
                var opName = op["op"]?.GetValue<string>() ?? "unknown";
                var target = op["target"]?.GetValue<string>();
                var s = Utc();
                var allowError = (op["args"] as JsonObject)?.TryGetPropertyValue("allow_error", out var allowNode) == true
                    && allowNode is not null
                    && allowNode.GetValue<bool>();
                try
                {
                    workbook = InvokeOp(excel, workbook, op, fixturePath);
                    stepCaptures.Add(CaptureStep(workbook, targets, $"after_{opName}", opName));
                    opTrace.Add(new()
                    {
                        ["op"] = opName,
                        ["target"] = target,
                        ["started_utc"] = s,
                        ["finished_utc"] = Utc(),
                        ["status"] = "ok"
                    });
                }
                catch (Exception opEx) when (allowError)
                {
                    stepCaptures.Add(CaptureStep(workbook, targets, $"after_{opName}_allowed_error", opName));
                    opTrace.Add(new()
                    {
                        ["op"] = opName,
                        ["target"] = target,
                        ["started_utc"] = s,
                        ["finished_utc"] = Utc(),
                        ["status"] = "allowed_error",
                        ["message"] = opEx.Message
                    });
                }
            }

            if (workbook is not null) workbook.Save();

            var captures = new List<Dictionary<string, object?>>();
            foreach (var target in targets)
            {
                try { captures.Add(CellSnapshot(workbook, target)); }
                catch (Exception ex) { captures.Add(new() { ["target"] = target, ["status"] = "capture_error", ["message"] = ex.Message }); }
            }

            var calcMode = CalcModeName((int)excel.Calculation);
            var dateSystem = DateSystemName(workbook);
            var finish = Utc();
            var sourceRefs = (scenario["sources"] as JsonArray ?? []).Select(n => n?.GetValue<string>()).ToList();

            var manifest = new Dictionary<string, object?>
            {
                ["run_id"] = runId, ["task_id"] = scenario["task_id"]?.GetValue<string>() ?? "unknown", ["scenario_id"] = scenario["scenario_id"]?.GetValue<string>() ?? "unknown",
                ["runner_version"] = tool["runner_version"], ["runner_build_version"] = tool["runner_build_version"],
                ["start_utc"] = start, ["end_utc"] = finish, ["exit_status"] = "success", ["visible"] = visible, ["timeout_sec"] = timeoutSec,
                ["platform"] = "windows_desktop", ["excel_build"] = excelBinary["excel_file_version"], ["excel_channel"] = "unknown",
                ["calc_mode"] = calcMode, ["excel_app_version"] = JsonFriendly(excel.Version), ["excel_pid"] = excelPid, ["excel_process_snapshot"] = ProcessSnap(excelPid), ["excel_binary"] = excelBinary,
                ["date_system"] = dateSystem,
                ["fixture_path"] = fixturePath, ["fixture_preexisting"] = fixturePreexisting, ["operation_trace"] = opTrace, ["step_capture_enabled"] = true, ["tooling"] = tool
            };
            var raw = new Dictionary<string, object?> { ["run_id"] = runId, ["scenario"] = scenario, ["operation_trace"] = opTrace, ["step_captures"] = stepCaptures, ["captures"] = captures, ["error"] = null };
            var obs = captures.Select(c => c.TryGetValue("status", out var st) && Equals(st, "capture_error")
                ? new Dictionary<string, object?> { ["target"] = c["target"], ["kind"] = "value", ["status"] = "failed", ["value"] = null, ["metadata"] = new Dictionary<string, object?> { ["message"] = c["message"] } }
                : new Dictionary<string, object?> { ["target"] = c["target"], ["kind"] = "value", ["status"] = "observed", ["value"] = c["value"], ["metadata"] = new Dictionary<string, object?> { ["formula"] = c["formula"], ["display_text"] = c["display_text"], ["number_format"] = c["number_format"], ["has_formula"] = c["has_formula"] } }).ToList();
            var norm = new Dictionary<string, object?>
            {
                ["run_id"] = runId, ["task_id"] = scenario["task_id"]?.GetValue<string>() ?? "unknown", ["scenario_id"] = scenario["scenario_id"]?.GetValue<string>() ?? "unknown", ["timestamp_utc"] = finish,
                ["environment"] = new Dictionary<string, object?> { ["platform"] = "windows_desktop", ["excel_channel"] = "unknown", ["excel_build"] = excelBinary["excel_file_version"], ["locale"] = CultureInfo.CurrentCulture.Name, ["calc_mode"] = calcMode, ["date_system"] = dateSystem, ["capability_profile"] = "unknown", ["tooling"] = tool },
                ["observations"] = obs, ["comparison"] = new Dictionary<string, object?> { ["expected_profile"] = "scenario_expectations", ["result"] = "manual_review", ["mismatch_count"] = 0 },
                ["evidence"] = new Dictionary<string, object?> { ["raw_capture_ref"] = "raw_capture.json", ["step_capture_ref"] = "step_capture.json", ["rerun_command"] = $"dotnet run --project tools/excel-probe/tools/ExcelProbe/ExcelProbe.csproj -- run --scenario \"{scenarioPath}\" --out \"{outDir}\" --visible {visible.ToString().ToLowerInvariant()} --timeout-sec {timeoutSec}", ["source_refs"] = sourceRefs }
            };
            var stepCapturePayload = new Dictionary<string, object?>
            {
                ["run_id"] = runId,
                ["task_id"] = scenario["task_id"]?.GetValue<string>() ?? "unknown",
                ["scenario_id"] = scenario["scenario_id"]?.GetValue<string>() ?? "unknown",
                ["targets"] = targets,
                ["steps"] = stepCaptures
            };

            WriteJson(manifestPath, manifest);
            WriteJson(rawPath, raw);
            WriteJson(normPath, norm);
            WriteJson(stepCapturePath, stepCapturePayload);
            File.WriteAllText(stdoutPath, "Run completed successfully.\n", Encoding.UTF8);
            File.WriteAllText(stderrPath, "", Encoding.UTF8);
            return 0;
        }
        catch (Exception ex)
        {
            var tool = Tooling(); var excelBinary = SafeExcelBinary(); var end = Utc();
            WriteJson(manifestPath, new Dictionary<string, object?> {
                ["run_id"]=runId, ["task_id"]=scenario?["task_id"]?.GetValue<string>() ?? "unknown", ["scenario_id"]=scenario?["scenario_id"]?.GetValue<string>() ?? "unknown",
                ["runner_version"]=tool["runner_version"], ["runner_build_version"]=tool["runner_build_version"],
                ["start_utc"]=start, ["end_utc"]=end, ["exit_status"]="failed", ["visible"]=visible, ["timeout_sec"]=timeoutSec,
                ["platform"]="windows_desktop", ["excel_build"]=excelBinary.TryGetValue("excel_file_version", out var b) ? b : null, ["excel_channel"]="unknown",
                ["excel_pid"]=excelPid, ["excel_binary"]=excelBinary, ["tooling"]=tool, ["error"]=ex.ToString()
            });
            WriteJson(rawPath, new Dictionary<string, object?> { ["run_id"] = runId, ["error"] = ex.ToString() });
            WriteJson(normPath, new Dictionary<string, object?> {
                ["run_id"]=runId, ["task_id"]=scenario?["task_id"]?.GetValue<string>() ?? "unknown", ["scenario_id"]=scenario?["scenario_id"]?.GetValue<string>() ?? "unknown", ["timestamp_utc"]=end,
                ["environment"]=new Dictionary<string, object?> { ["platform"]="windows_desktop", ["excel_channel"]="unknown", ["excel_build"]=excelBinary.TryGetValue("excel_file_version", out var bb) ? bb : null, ["locale"]=CultureInfo.CurrentCulture.Name, ["calc_mode"]="unknown", ["date_system"]="unknown", ["capability_profile"]="unknown", ["tooling"]=tool },
                ["observations"]=Array.Empty<object>(), ["comparison"]=new Dictionary<string, object?> { ["expected_profile"]="scenario_expectations", ["result"]="manual_review", ["mismatch_count"]=0 },
                ["evidence"]=new Dictionary<string, object?> { ["raw_capture_ref"]="raw_capture.json", ["step_capture_ref"]="step_capture.json", ["rerun_command"]=$"dotnet run --project tools/excel-probe/tools/ExcelProbe/ExcelProbe.csproj -- run --scenario \"{scenarioPath}\" --out \"{outDir}\" --visible {visible.ToString().ToLowerInvariant()} --timeout-sec {timeoutSec}", ["source_refs"]=Array.Empty<object>() }
            });
            WriteJson(stepCapturePath, new Dictionary<string, object?> { ["run_id"] = runId, ["error"] = ex.ToString() });
            File.WriteAllText(stdoutPath, "", Encoding.UTF8);
            File.WriteAllText(stderrPath, ex + "\n", Encoding.UTF8);
            Console.Error.WriteLine(ex);
            return 1;
        }
        finally
        {
            if (messageFilterInstalled) OleMessageFilter.Revoke();
            try { if (workbook is not null) workbook.Close(true); } catch { }
            try { if (excel is not null) excel.Quit(); } catch { }
            ReleaseCom(workbook); ReleaseCom(excel);
            GC.Collect(); GC.WaitForPendingFinalizers();
            if (excelPid.HasValue) try { var p = Process.GetProcessById(excelPid.Value); if (!p.HasExited) p.Kill(true); } catch { }
        }
    }

    static WorkbookContext EnsureWorkbook(dynamic excel, JsonObject scenario)
    {
        var inputs = scenario["inputs"]?.AsObject() ?? throw new InvalidOperationException("inputs missing");
        var fixtureHint = inputs["workbook_fixture"]?.GetValue<string>() ?? throw new InvalidOperationException("inputs.workbook_fixture missing");
        var fixturePath = ResolveInputPath(fixtureHint);
        var fixturePreexisting = File.Exists(fixturePath);
        dynamic wb = fixturePreexisting ? excel.Workbooks.Open(fixturePath) : excel.Workbooks.Add();
        if (!fixturePreexisting) { var dir = Path.GetDirectoryName(fixturePath); if (!string.IsNullOrWhiteSpace(dir)) Directory.CreateDirectory(dir); wb.SaveAs(fixturePath, 51); }
        foreach (var setupNode in (inputs["sheet_setup"] as JsonArray ?? []))
        {
            var setup = setupNode!.AsObject();
            var sheetName = setup["sheet"]?.GetValue<string>() ?? throw new InvalidOperationException("sheet name missing");
            foreach (var writeNode in (setup["writes"] as JsonArray ?? [])) ApplyWrite(wb, sheetName, writeNode!.AsObject());
        }
        return new WorkbookContext
        {
            Workbook = wb,
            FixturePath = fixturePath,
            FixturePreexisting = fixturePreexisting
        };
    }

    static void ApplyWrite(dynamic wb, string sheetName, JsonObject write)
    {
        dynamic sheet = EnsureSheet(wb, sheetName);
        var address = write["address"]?.GetValue<string>() ?? throw new InvalidOperationException("write address missing");
        var kind = write["kind"]?.GetValue<string>() ?? throw new InvalidOperationException("write kind missing");
        var value = write["value"];
        switch (kind)
        {
            case "value": sheet.Range(address).Value2 = NodeToCom(value); break;
            case "formula": sheet.Range(address).Formula = value?.GetValue<string>() ?? ""; break;
            case "format": sheet.Range(address).NumberFormat = value?.GetValue<string>() ?? ""; break;
            case "name": if (value is JsonObject n) { var name = n["name"]?.GetValue<string>(); var refers = n["refers_to"]?.GetValue<string>(); if (!string.IsNullOrWhiteSpace(name) && !string.IsNullOrWhiteSpace(refers)) wb.Names.Add(name, refers); } break;
            default: throw new InvalidOperationException($"Unsupported write kind '{kind}'.");
        }
    }

    static dynamic EnsureSheet(dynamic wb, string name)
    {
        foreach (dynamic ws in wb.Worksheets) if (string.Equals(Convert.ToString(ws.Name, CultureInfo.InvariantCulture), name, StringComparison.Ordinal)) return ws;
        dynamic s = wb.Worksheets.Add(); s.Name = name; return s;
    }

    static dynamic? InvokeOp(dynamic excel, dynamic? wb, JsonObject op, string fixturePath)
    {
        var opName = op["op"]?.GetValue<string>() ?? throw new InvalidOperationException("op missing");
        var target = op["target"]?.GetValue<string>();
        var args = op["args"] as JsonObject;
        switch (opName)
        {
            case "set_calc_mode": excel.Calculation = (args?["mode"]?.GetValue<string>() ?? "").ToLowerInvariant() switch { "automatic" => XlAutomatic, "manual" => XlManual, "semiautomatic" => XlSemiautomatic, _ => throw new InvalidOperationException("invalid calc mode") }; return wb;
            case "recalc": excel.Calculate(); return wb;
            case "full_recalc": try { excel.CalculateFullRebuild(); } catch { excel.CalculateFull(); } return wb;
            case "sleep": { var ms = args?["milliseconds"]?.GetValue<int>() ?? args?["ms"]?.GetValue<int>() ?? 250; Thread.Sleep(ms); return wb; }
            case "set_date_system":
                {
                    var w = RequireWb(wb, opName);
                    var mode = (args?["system"]?.GetValue<string>() ?? "1900").Trim();
                    w.Date1904 = mode switch
                    {
                        "1904" => true,
                        "1900" => false,
                        _ => throw new InvalidOperationException("invalid date system (expected 1900 or 1904)")
                    };
                    return w;
                }
            case "edit_cell": { var w = RequireWb(wb, opName); var (sh, ad) = ParseTarget(target); dynamic ws = w.Worksheets.Item(sh); if (args?.TryGetPropertyValue("formula", out var f) == true && f is not null) ws.Range(ad).Formula = f.GetValue<string>(); else ws.Range(ad).Value2 = NodeToCom(args?["value"]); return w; }
            case "insert_row": { var w = RequireWb(wb, opName); var (sh, ad) = ParseTarget(target); w.Worksheets.Item(sh).Range(ad).EntireRow.Insert(); return w; }
            case "delete_row": { var w = RequireWb(wb, opName); var (sh, ad) = ParseTarget(target); w.Worksheets.Item(sh).Range(ad).EntireRow.Delete(); return w; }
            case "insert_column": { var w = RequireWb(wb, opName); var (sh, ad) = ParseTarget(target); w.Worksheets.Item(sh).Range(ad).EntireColumn.Insert(); return w; }
            case "delete_column": { var w = RequireWb(wb, opName); var (sh, ad) = ParseTarget(target); w.Worksheets.Item(sh).Range(ad).EntireColumn.Delete(); return w; }
            case "save": { var w = RequireWb(wb, opName); w.Save(); return w; }
            case "close": { var w = RequireWb(wb, opName); w.Close(true); ReleaseCom(w); return null; }
            case "open": if (wb is not null) { wb.Close(false); ReleaseCom(wb); } return excel.Workbooks.Open(fixturePath);
            case "copy_paste": { var w = RequireWb(wb, opName); var src = ParseTarget(args?["source"]?.GetValue<string>()); var dst = ParseTarget(args?["target"]?.GetValue<string>()); w.Worksheets.Item(src.sheet).Range(src.address).Copy(w.Worksheets.Item(dst.sheet).Range(dst.address)); return w; }
            case "copy_paste_from_workbook":
                {
                    var w = RequireWb(wb, opName);
                    var sourceFixtureHint = args?["source_workbook_fixture"]?.GetValue<string>()
                        ?? throw new InvalidOperationException("copy_paste_from_workbook requires args.source_workbook_fixture");
                    var sourceTarget = ParseTarget(args?["source"]?.GetValue<string>());
                    var destTarget = ParseTarget(target);
                    var sourcePath = ResolveInputPath(sourceFixtureHint);
                    if (!File.Exists(sourcePath)) throw new FileNotFoundException("source workbook fixture not found", sourcePath);

                    dynamic? sourceWb = null;
                    try
                    {
                        sourceWb = excel.Workbooks.Open(sourcePath);
                        var srcRange = sourceWb.Worksheets.Item(sourceTarget.sheet).Range(sourceTarget.address);
                        var dstRange = w.Worksheets.Item(destTarget.sheet).Range(destTarget.address);
                        srcRange.Copy(dstRange);
                    }
                    finally
                    {
                        try { if (sourceWb is not null) sourceWb.Close(false); } catch { }
                        ReleaseCom(sourceWb);
                    }
                    return w;
                }
            case "create_table":
                {
                    var w = RequireWb(wb, opName);
                    var (sh, ad) = ParseTarget(target);
                    var tableName = args?["name"]?.GetValue<string>();
                    var hasHeaders = args?["has_headers"]?.GetValue<bool>() ?? true;
                    dynamic ws = w.Worksheets.Item(sh);
                    dynamic rng = ws.Range(ad);
                    // 1 = xlSrcRange, 1 = xlYes, 2 = xlNo
                    dynamic lo = ws.ListObjects.Add(1, rng, Type.Missing, hasHeaders ? 1 : 2, Type.Missing);
                    if (!string.IsNullOrWhiteSpace(tableName)) lo.Name = tableName;
                    return w;
                }
            case "clear_cf":
                {
                    var w = RequireWb(wb, opName);
                    var (sh, ad) = ParseTarget(target);
                    dynamic ws = w.Worksheets.Item(sh);
                    dynamic rng = ws.Range(ad);
                    rng.FormatConditions.Delete();
                    return w;
                }
            case "add_cf_expression":
                {
                    var w = RequireWb(wb, opName);
                    var (sh, ad) = ParseTarget(target);
                    dynamic ws = w.Worksheets.Item(sh);
                    dynamic rng = ws.Range(ad);
                    var formula = args?["formula"]?.GetValue<string>() ?? throw new InvalidOperationException("add_cf_expression requires args.formula");
                    dynamic fc = rng.FormatConditions.Add(XlExpression, Type.Missing, formula, Type.Missing);

                    var interiorColor = ParseColor(args?["interior_color"]);
                    if (interiorColor.HasValue) fc.Interior.Color = interiorColor.Value;

                    var fontColor = ParseColor(args?["font_color"]);
                    if (fontColor.HasValue) fc.Font.Color = fontColor.Value;

                    if (args is not null && args.TryGetPropertyValue("bold", out var boldNode) && boldNode is not null)
                        fc.Font.Bold = boldNode.GetValue<bool>();

                    if (args is not null && args.TryGetPropertyValue("stop_if_true", out var stopNode) && stopNode is not null)
                        fc.StopIfTrue = stopNode.GetValue<bool>();

                    if (args?["set_first_priority"]?.GetValue<bool>() == true) fc.SetFirstPriority();
                    if (args?["set_last_priority"]?.GetValue<bool>() == true) fc.SetLastPriority();
                    return w;
                }
            case "set_cf_priority":
                {
                    var w = RequireWb(wb, opName);
                    var (sh, ad) = ParseTarget(target);
                    dynamic ws = w.Worksheets.Item(sh);
                    dynamic rng = ws.Range(ad);
                    var index = args?["index"]?.GetValue<int>() ?? 1;
                    dynamic fc = rng.FormatConditions.Item(index);

                    if (args is not null && args.TryGetPropertyValue("priority", out var priorityNode) && priorityNode is not null)
                        fc.Priority = priorityNode.GetValue<int>();

                    if (args?["set_first"]?.GetValue<bool>() == true) fc.SetFirstPriority();
                    if (args?["set_last"]?.GetValue<bool>() == true) fc.SetLastPriority();
                    return w;
                }
            case "set_cf_stop_if_true":
                {
                    var w = RequireWb(wb, opName);
                    var (sh, ad) = ParseTarget(target);
                    dynamic ws = w.Worksheets.Item(sh);
                    dynamic rng = ws.Range(ad);
                    var index = args?["index"]?.GetValue<int>() ?? 1;
                    var value = args?["value"]?.GetValue<bool>() ?? true;
                    dynamic fc = rng.FormatConditions.Item(index);
                    fc.StopIfTrue = value;
                    return w;
                }
            default: throw new InvalidOperationException($"Unsupported operation '{opName}'.");
        }
    }

    static object? TryCom(Func<object?> getter)
    {
        try { return JsonFriendly(getter()); }
        catch { return null; }
    }

    static int? ParseColor(JsonNode? node)
    {
        if (node is null) return null;

        try { return node.GetValue<int>(); }
        catch { }

        string? text = null;
        try { text = node.GetValue<string>(); }
        catch { }

        if (!string.IsNullOrWhiteSpace(text))
        {
            var s = text.Trim();
            if (s.StartsWith("#", StringComparison.Ordinal) && s.Length == 7)
            {
                var r = int.Parse(s.Substring(1, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                var g = int.Parse(s.Substring(3, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                var b = int.Parse(s.Substring(5, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16);
            }

            var parts = s.Split(',', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 3 &&
                int.TryParse(parts[0], NumberStyles.Integer, CultureInfo.InvariantCulture, out var r2) &&
                int.TryParse(parts[1], NumberStyles.Integer, CultureInfo.InvariantCulture, out var g2) &&
                int.TryParse(parts[2], NumberStyles.Integer, CultureInfo.InvariantCulture, out var b2))
            {
                return (r2 & 0xFF) | ((g2 & 0xFF) << 8) | ((b2 & 0xFF) << 16);
            }
        }

        if (node is JsonArray arr && arr.Count >= 3)
        {
            try
            {
                var r = arr[0]!.GetValue<int>();
                var g = arr[1]!.GetValue<int>();
                var b = arr[2]!.GetValue<int>();
                return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16);
            }
            catch { }
        }

        return null;
    }

    static Dictionary<string, object?> CellSnapshot(dynamic wb, string target)
    {
        var (sheet, address) = ParseTarget(target);
        dynamic cell = wb.Worksheets.Item(sheet).Range(address);
        dynamic? displayFormat = null;
        try { displayFormat = cell.DisplayFormat; } catch { }

        return new()
        {
            ["target"] = target,
            ["value"] = TryCom(() => cell.Value2),
            ["formula"] = TryCom(() => cell.Formula),
            ["display_text"] = TryCom(() => cell.Text),
            ["number_format"] = TryCom(() => cell.NumberFormat),
            ["has_formula"] = TryCom(() => cell.HasFormula),
            ["interior_color"] = TryCom(() => cell.Interior.Color),
            ["font_color"] = TryCom(() => cell.Font.Color),
            ["font_bold"] = TryCom(() => cell.Font.Bold),
            ["display_interior_color"] = displayFormat is null ? null : TryCom(() => displayFormat.Interior.Color),
            ["display_font_color"] = displayFormat is null ? null : TryCom(() => displayFormat.Font.Color),
            ["display_font_bold"] = displayFormat is null ? null : TryCom(() => displayFormat.Font.Bold),
            ["display_number_format"] = displayFormat is null ? null : TryCom(() => displayFormat.NumberFormat)
        };
    }

    static Dictionary<string, object?> CaptureStep(dynamic? wb, List<string> targets, string stepLabel, string operation)
    {
        var captures = new List<Dictionary<string, object?>>();
        foreach (var target in targets)
        {
            if (wb is null)
            {
                captures.Add(new Dictionary<string, object?>
                {
                    ["target"] = target,
                    ["status"] = "workbook_closed",
                    ["message"] = "Workbook was closed during this step."
                });
                continue;
            }

            try
            {
                captures.Add(CellSnapshot(wb, target));
            }
            catch (Exception ex)
            {
                captures.Add(new Dictionary<string, object?>
                {
                    ["target"] = target,
                    ["status"] = "capture_error",
                    ["message"] = ex.Message
                });
            }
        }

        return new Dictionary<string, object?>
        {
            ["step"] = stepLabel,
            ["operation"] = operation,
            ["timestamp_utc"] = Utc(),
            ["captures"] = captures
        };
    }

    static List<string> CaptureTargets(JsonObject scenario)
    {
        var targets = new List<string>();
        foreach (var e in (scenario["expectations"] as JsonArray ?? [])) { var t = e?["target"]?.GetValue<string>(); if (!string.IsNullOrWhiteSpace(t)) targets.Add(t); }
        if (targets.Count > 0) return targets.Distinct(StringComparer.Ordinal).ToList();
        foreach (var s in (scenario["inputs"]?["sheet_setup"] as JsonArray ?? []))
        {
            var sheet = s?["sheet"]?.GetValue<string>(); if (string.IsNullOrWhiteSpace(sheet)) continue;
            foreach (var w in (s?["writes"] as JsonArray ?? [])) { var a = w?["address"]?.GetValue<string>(); if (!string.IsNullOrWhiteSpace(a)) targets.Add($"{sheet}!{a}"); }
        }
        return targets.Distinct(StringComparer.Ordinal).ToList();
    }

    static (string sheet, string address) ParseTarget(string? t) { if (string.IsNullOrWhiteSpace(t)) throw new InvalidOperationException("target missing"); var i = t.IndexOf('!'); if (i <= 0 || i >= t.Length - 1) throw new InvalidOperationException($"invalid target '{t}'"); return (t[..i], t[(i + 1)..]); }
    static dynamic RequireWb(dynamic? wb, string op) { if (wb is null) throw new InvalidOperationException($"{op} requires open workbook"); return wb; }
    static string CalcModeName(int code) => code switch { XlAutomatic => "automatic", XlManual => "manual", XlSemiautomatic => "semiautomatic", _ => "unknown" };
    static string DateSystemName(dynamic? wb)
    {
        if (wb is null) return "unknown";
        try { return (bool)wb.Date1904 ? "1904" : "1900"; } catch { return "unknown"; }
    }

    // Office automation occasionally returns RPC_E_SERVERCALL_RETRYLATER.
    // Installing an OLE message filter enables automatic retry behavior.
    [ComImport, Guid("00000016-0000-0000-C000-000000000046"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMessageFilter
    {
        [PreserveSig] int HandleInComingCall(int dwCallType, IntPtr hTaskCaller, int dwTickCount, IntPtr lpInterfaceInfo);
        [PreserveSig] int RetryRejectedCall(IntPtr hTaskCallee, int dwTickCount, int dwRejectType);
        [PreserveSig] int MessagePending(IntPtr hTaskCallee, int dwTickCount, int dwPendingType);
    }

    sealed class OleMessageFilter : IMessageFilter
    {
        [DllImport("ole32.dll")]
        static extern int CoRegisterMessageFilter(IMessageFilter? newFilter, out IMessageFilter? oldFilter);

        public static void Register() => CoRegisterMessageFilter(new OleMessageFilter(), out _);

        public static void Revoke() => CoRegisterMessageFilter(null, out _);

        public int HandleInComingCall(int dwCallType, IntPtr hTaskCaller, int dwTickCount, IntPtr lpInterfaceInfo) => 0;

        public int RetryRejectedCall(IntPtr hTaskCallee, int dwTickCount, int dwRejectType)
        {
            // SERVERCALL_RETRYLATER (2): retry in 100 ms.
            return dwRejectType == 2 ? 100 : -1;
        }

        public int MessagePending(IntPtr hTaskCallee, int dwTickCount, int dwPendingType) => 2;
    }

    static string Utc() => DateTime.UtcNow.ToString("O", CultureInfo.InvariantCulture);
    static int Fail(string s) { Console.Error.WriteLine(s); return 1; }

    static object? NodeToCom(JsonNode? n)
    {
        if (n is null) return null;
        if (n is JsonValue v)
        {
            if (v.TryGetValue<bool>(out var b)) return b;
            if (v.TryGetValue<int>(out var i)) return i;
            if (v.TryGetValue<long>(out var l)) return l;
            if (v.TryGetValue<double>(out var d)) return d;
            if (v.TryGetValue<decimal>(out var m)) return (double)m;
            if (v.TryGetValue<string>(out var s)) return s;
        }
        return n.ToJsonString();
    }
    static object? JsonFriendly(object? v) => v switch
    {
        null => null, string s => s, bool b => b, int i => i, long l => l, double d when double.IsNaN(d) => "NaN", double d when double.IsPositiveInfinity(d) => "Infinity", double d when double.IsNegativeInfinity(d) => "-Infinity",
        double d => d, float f => f, decimal m => m, DateTime dt => dt.ToString("O", CultureInfo.InvariantCulture), Array a => a.Cast<object?>().Select(JsonFriendly).ToList(), _ when Marshal.IsComObject(v) => v.ToString(), _ => Convert.ToString(v, CultureInfo.InvariantCulture)
    };
    static void ReleaseCom(object? o) { try { if (o is not null && Marshal.IsComObject(o)) Marshal.FinalReleaseComObject(o); } catch { } }

    static string ExcelExe()
    {
        foreach (var c in new[] { @"C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE", @"C:\Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE" }) if (File.Exists(c)) return c;
        foreach (var k in new[] { @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\excel.exe", @"HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\excel.exe" }) { var v = Registry.GetValue(k, "", null) as string; if (!string.IsNullOrWhiteSpace(v) && File.Exists(v)) return v; }
        throw new FileNotFoundException("Could not locate EXCEL.EXE.");
    }
    static Dictionary<string, object?> ExcelBinary() { var exe = ExcelExe(); var fvi = FileVersionInfo.GetVersionInfo(exe); var hash = Convert.ToHexString(SHA256.HashData(File.ReadAllBytes(exe))); return new() { ["excel_exe_path"] = exe, ["excel_exe_sha256"] = hash, ["excel_file_version"] = fvi.FileVersion, ["excel_product_version"] = fvi.ProductVersion, ["excel_company_name"] = fvi.CompanyName, ["excel_product_name"] = fvi.ProductName }; }
    static Dictionary<string, object?> SafeExcelBinary() { try { return ExcelBinary(); } catch (Exception ex) { return new() { ["error"] = ex.Message }; } }
    static Dictionary<string, object?>? ProcessSnap(int? pid) { if (pid is null) return null; try { var p = Process.GetProcessById(pid.Value); return new() { ["pid"] = p.Id, ["name"] = p.ProcessName, ["executable_path"] = p.MainModule?.FileName, ["command_line"] = null, ["creation_date"] = p.StartTime.ToUniversalTime().ToString("O", CultureInfo.InvariantCulture) }; } catch { return null; } }
    static Dictionary<string, object?> Tooling()
    {
        var asm = Assembly.GetExecutingAssembly();
        var av = asm.GetName().Version?.ToString() ?? "unknown";
        var iv = asm.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion ?? av;
        var root = RepoRoot();
        return new()
        {
            ["runner_name"]="excel-probe", ["runner_language"]="C#", ["runner_version"]=iv, ["runner_build_version"]=av, ["dotnet_sdk_version"]=TryRun("dotnet","--version"), ["dotnet_runtime_version"]=Environment.Version.ToString(),
            ["repo_root"]=root, ["repo_git_commit"]=TryGit(root, "rev-parse HEAD"), ["repo_git_commit_short"]=TryGit(root, "rev-parse --short HEAD"), ["repo_git_is_dirty"]=Dirty(root)
        };
    }
    static string? RepoRoot() { foreach (var s in new[] { Directory.GetCurrentDirectory(), AppContext.BaseDirectory }) for (var d = new DirectoryInfo(s); d is not null; d = d.Parent) if (Directory.Exists(Path.Combine(d.FullName, ".git"))) return d.FullName; return null; }
    static string? TryGit(string? root, string args) => string.IsNullOrWhiteSpace(root) ? null : TryRun("git", $"-C \"{root}\" {args}");
    static bool? Dirty(string? root) { var s = TryGit(root, "status --porcelain"); return s is null ? null : !string.IsNullOrWhiteSpace(s); }
    static string? TryRun(string file, string args) { try { var p = Process.Start(new ProcessStartInfo { FileName = file, Arguments = args, UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true, CreateNoWindow = true }); if (p is null) return null; var o = p.StandardOutput.ReadToEnd(); p.WaitForExit(5000); return p.ExitCode == 0 ? o.Trim() : null; } catch { return null; } }
    static void WriteJson(string path, object value) { var d = Path.GetDirectoryName(path); if (!string.IsNullOrWhiteSpace(d)) Directory.CreateDirectory(d); File.WriteAllText(path, JsonSerializer.Serialize(value, JsonOptions), Encoding.UTF8); }
    static string ResolveInputPath(string path) => Path.IsPathRooted(path) ? path : Path.GetFullPath(Path.Combine(InvocationCwd, path));
    static string[] ParseCsvLine(string line)
    {
        var values = new List<string>();
        var sb = new StringBuilder();
        bool inQuotes = false;
        for (int i = 0; i < line.Length; i++)
        {
            var ch = line[i];
            if (ch == '"')
            {
                if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                {
                    sb.Append('"');
                    i++;
                }
                else
                {
                    inQuotes = !inQuotes;
                }
                continue;
            }
            if (ch == ',' && !inQuotes)
            {
                values.Add(sb.ToString());
                sb.Clear();
                continue;
            }
            sb.Append(ch);
        }
        values.Add(sb.ToString());
        return values.ToArray();
    }

    static int ExcelPid(int hwnd) { GetWindowThreadProcessId((nint)hwnd, out var pid); return (int)pid; }
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(nint hWnd, out uint lpdwProcessId);
}

