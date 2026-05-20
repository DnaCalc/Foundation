using System.Diagnostics;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

static class Program
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        WriteIndented = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
    };

    private static readonly string[] DefaultPanes = ["OxReplay", "OxXlPlay", "DnaOneCalc", "OxFml", "OxFunc"];

    public static int Main(string[] args)
    {
        try
        {
            if (args.Length > 0 && args[0] == "--")
            {
                args = args.Skip(1).ToArray();
            }

            var command = args.Length == 0 ? "snapshot" : args[0];
            var rest = args.Skip(1).ToArray();

            return command switch
            {
                "snapshot" => Snapshot(ParseOptions(rest)),
                "watch" => Watch(ParseOptions(rest)),
                "help" or "-h" or "--help" => Help(),
                _ => Fail($"Unknown command '{command}'.")
            };
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex);
            return 1;
        }
    }

    private static int Help()
    {
        Console.WriteLine(
            """
            corpus-monitor

            Usage:
              corpus-monitor snapshot [options]
              corpus-monitor watch [options]

            Options:
              --repo-root <path>
              --results-root <path>
              --monitor-root <path>
              --workspace <name>              Default: DnaCalc
              --panes <comma-separated>       Default: OxReplay,OxXlPlay,DnaOneCalc,OxFml,OxFunc
              --capture-lines <n>             Default: 120
              --interval-seconds <n>          Default for watch: 60

            Writes:
              corpus-campaign-status.json / .md
              subagent-monitor-status.json / .md
            """);
        return 0;
    }

    private static int Fail(string message)
    {
        Console.Error.WriteLine(message);
        return 1;
    }

    private static Options ParseOptions(string[] args)
    {
        string? repoRoot = null;
        string? resultsRoot = null;
        string? monitorRoot = null;
        var workspace = "DnaCalc";
        var panes = DefaultPanes.ToArray();
        var captureLines = 120;
        var intervalSeconds = 60;

        for (var i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--repo-root":
                    repoRoot = RequireValue(args, ref i, "--repo-root");
                    break;
                case "--results-root":
                    resultsRoot = RequireValue(args, ref i, "--results-root");
                    break;
                case "--monitor-root":
                    monitorRoot = RequireValue(args, ref i, "--monitor-root");
                    break;
                case "--workspace":
                    workspace = RequireValue(args, ref i, "--workspace");
                    break;
                case "--panes":
                    panes = RequireValue(args, ref i, "--panes")
                        .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
                    break;
                case "--capture-lines":
                    captureLines = int.Parse(RequireValue(args, ref i, "--capture-lines"));
                    break;
                case "--interval-seconds":
                    intervalSeconds = int.Parse(RequireValue(args, ref i, "--interval-seconds"));
                    break;
                default:
                    throw new ArgumentException($"Unknown option '{args[i]}'.");
            }
        }

        repoRoot ??= FindRepoRoot(AppContext.BaseDirectory)
            ?? throw new InvalidOperationException("Could not locate Foundation repo root.");
        resultsRoot ??= Path.Combine(repoRoot, "reference", "test-corpus", "workspace", "results");
        monitorRoot ??= Path.Combine(repoRoot, "reference", "test-corpus", "workspace", "monitoring");

        return new Options(
            repoRoot,
            resultsRoot,
            monitorRoot,
            workspace,
            panes,
            captureLines,
            intervalSeconds);
    }

    private static string RequireValue(string[] args, ref int index, string option)
    {
        index++;
        if (index >= args.Length)
        {
            throw new ArgumentException($"Missing value for {option}.");
        }

        return args[index];
    }

    private static string? FindRepoRoot(string startPath)
    {
        var current = new DirectoryInfo(startPath);
        while (current is not null)
        {
            var charter = Path.Combine(current.FullName, "CHARTER.md");
            var workspace = Path.Combine(current.FullName, "reference", "test-corpus", "workspace");
            if (File.Exists(charter) && Directory.Exists(workspace))
            {
                return current.FullName;
            }

            current = current.Parent;
        }

        return null;
    }

    private static int Snapshot(Options options)
    {
        Directory.CreateDirectory(options.MonitorRoot);
        Directory.CreateDirectory(Path.Combine(options.MonitorRoot, "panes"));

        var notes = LoadNotes(Path.Combine(options.MonitorRoot, "campaign-notes.jsonl"));
        var campaign = BuildCampaignSnapshot(options, notes);
        var panes = BuildPaneSnapshot(options);

        WriteJson(Path.Combine(options.MonitorRoot, "corpus-campaign-status.json"), campaign);
        WriteJson(Path.Combine(options.MonitorRoot, "subagent-monitor-status.json"), panes);
        File.WriteAllText(Path.Combine(options.MonitorRoot, "corpus-campaign-status.md"), RenderCampaignMarkdown(campaign));
        File.WriteAllText(Path.Combine(options.MonitorRoot, "subagent-monitor-status.md"), RenderPaneMarkdown(panes));

        Console.WriteLine($"snapshot_at={campaign.GeneratedAtUtc:o}");
        Console.WriteLine($"cases.total={campaign.Cases.Count} open={campaign.Summary.OpenCases} matched={campaign.Summary.MatchedCases} blocked={campaign.Summary.BlockedCases}");
        Console.WriteLine($"panes.total={panes.Panes.Count} prompt_visible={panes.Panes.Count(p => p.PromptVisible)} capture_errors={panes.Panes.Count(p => p.CaptureError is not null)}");
        return 0;
    }

    private static int Watch(Options options)
    {
        while (true)
        {
            Snapshot(options);
            Console.WriteLine($"sleeping_seconds={options.IntervalSeconds}");
            Thread.Sleep(TimeSpan.FromSeconds(options.IntervalSeconds));
        }
    }

    private static Dictionary<string, CampaignNote> LoadNotes(string notesPath)
    {
        var notes = new Dictionary<string, CampaignNote>(StringComparer.OrdinalIgnoreCase);
        if (!File.Exists(notesPath))
        {
            return notes;
        }

        foreach (var rawLine in File.ReadLines(notesPath))
        {
            var line = rawLine.Trim();
            if (line.Length == 0)
            {
                continue;
            }

            var note = JsonSerializer.Deserialize<CampaignNote>(line);
            if (note?.CaseId is null)
            {
                continue;
            }

            notes[note.CaseId] = note;
        }

        return notes;
    }

    private static CampaignSnapshot BuildCampaignSnapshot(Options options, Dictionary<string, CampaignNote> notes)
    {
        var latestByCase = new Dictionary<string, CaseStatus>(StringComparer.OrdinalIgnoreCase);

        if (Directory.Exists(options.ResultsRoot))
        {
            foreach (var reportPath in Directory.EnumerateFiles(options.ResultsRoot, "verification-bundle-report.json", SearchOption.AllDirectories))
            {
                var reportWriteTimeUtc = File.GetLastWriteTimeUtc(reportPath);
                using var document = JsonDocument.Parse(File.ReadAllText(reportPath));
                if (!document.RootElement.TryGetProperty("bundle_id", out var bundleIdEl) ||
                    !document.RootElement.TryGetProperty("case_reports", out var casesEl) ||
                    casesEl.ValueKind != JsonValueKind.Array)
                {
                    continue;
                }

                var bundleId = bundleIdEl.GetString() ?? Path.GetFileName(Path.GetDirectoryName(reportPath) ?? reportPath);

                foreach (var caseEl in casesEl.EnumerateArray())
                {
                    var caseId = GetString(caseEl, "case_id");
                    if (string.IsNullOrWhiteSpace(caseId))
                    {
                        continue;
                    }

                    var status = GetString(caseEl, "comparison_status") ?? "Unknown";
                    var formula = GetString(caseEl, "entered_cell_text") ?? "";
                    if (!caseId.StartsWith("FTC-", StringComparison.OrdinalIgnoreCase))
                    {
                        continue;
                    }
                    var valueMatch = GetNullableBool(caseEl, "value_match");
                    var displayMatch = GetNullableBool(caseEl, "display_match");
                    var discrepancySummary = GetString(caseEl, "discrepancy_summary");
                    var replayMismatchKinds = GetStringArray(caseEl, "replay_mismatch_kinds");
                    var oxfmlSummary = TryGetNestedString(caseEl, "oxfml_summary", "evaluation_summary");
                    var excelObserved = TryGetNestedString(caseEl, "excel_summary", "observed_value_repr");
                    var excelDisplay = TryGetNestedString(caseEl, "excel_summary", "effective_display_text");

                    var note = notes.TryGetValue(caseId, out var foundNote) ? foundNote : null;
                    var issueFamily = note?.IssueFamily ?? ClassifyIssueFamily(status, valueMatch, displayMatch, formula, discrepancySummary);

                    var entry = new CaseStatus(
                        CaseId: caseId,
                        Formula: formula,
                        LatestStatus: status,
                        IssueFamily: issueFamily,
                        OwnerRepo: note?.OwnerRepo,
                        LocalReproStatus: note?.LocalReproStatus,
                        NextAction: note?.NextAction,
                        NeedsUserReview: note?.NeedsUserReview,
                        LastBundleId: bundleId,
                        LastReportPath: Path.GetRelativePath(options.RepoRoot, reportPath),
                        LastReportWriteTimeUtc: reportWriteTimeUtc,
                        ValueMatch: valueMatch,
                        DisplayMatch: displayMatch,
                        DiscrepancySummary: discrepancySummary,
                        ReplayMismatchKinds: replayMismatchKinds,
                        OxfmlEvaluationSummary: oxfmlSummary,
                        ExcelObservedValueRepr: excelObserved,
                        ExcelDisplayText: excelDisplay);

                    if (!latestByCase.TryGetValue(caseId, out var existing) || existing.LastReportWriteTimeUtc <= reportWriteTimeUtc)
                    {
                        latestByCase[caseId] = entry;
                    }
                }
            }
        }

        var cases = latestByCase.Values
            .OrderBy(c => c.CaseId, StringComparer.OrdinalIgnoreCase)
            .ToList();

        var summary = new CampaignSummary(
            cases.Count,
            cases.Count(c => string.Equals(c.LatestStatus, "Matched", StringComparison.OrdinalIgnoreCase)),
            cases.Count(c => string.Equals(c.LatestStatus, "Blocked", StringComparison.OrdinalIgnoreCase)),
            cases.Count(c => !string.Equals(c.LatestStatus, "Matched", StringComparison.OrdinalIgnoreCase)),
            cases.GroupBy(c => c.IssueFamily).OrderBy(g => g.Key).Select(g => new KeyCount(g.Key, g.Count())).ToList());

        return new CampaignSnapshot(DateTime.UtcNow, options.ResultsRoot, summary, cases);
    }

    private static PaneSnapshot BuildPaneSnapshot(Options options)
    {
        var paneStates = new List<PaneState>();
        var paneDir = Path.Combine(options.MonitorRoot, "panes");
        Directory.CreateDirectory(paneDir);

        foreach (var pane in options.Panes)
        {
            string? output = null;
            string? error = null;
            try
            {
                output = RunProcessCapture("wtd", $"capture {options.Workspace}/{pane} --lines {options.CaptureLines}");
            }
            catch (Exception ex)
            {
                error = ex.Message;
            }

            var excerptPath = Path.Combine(paneDir, $"{pane}.txt");
            if (output is not null)
            {
                File.WriteAllText(excerptPath, output);
            }

            paneStates.Add(new PaneState(
                pane,
                output is null ? null : Path.GetRelativePath(options.RepoRoot, excerptPath),
                ExtractLastValue(output, "execution_state"),
                ExtractLastValue(output, "open_lanes"),
                ExtractLastValue(output, "scope_completeness"),
                ExtractLastValue(output, "target_completeness"),
                PromptVisible(output),
                DetectMode(output),
                TailExcerpt(output, 12),
                error));
        }

        return new PaneSnapshot(DateTime.UtcNow, options.Workspace, paneStates);
    }

    private static string DetectMode(string? output)
    {
        if (string.IsNullOrWhiteSpace(output))
        {
            return "unknown";
        }

        if (ContainsWorkingIndicator(output))
        {
            return "working";
        }

        if (PromptVisible(output))
        {
            return "prompt_visible";
        }

        var state = ExtractLastValue(output, "execution_state");
        if (!string.IsNullOrWhiteSpace(state))
        {
            return state!;
        }

        return "captured";
    }

    private static bool PromptVisible(string? output)
    {
        if (string.IsNullOrWhiteSpace(output))
        {
            return false;
        }

        var tail = output.Split('\n')
            .Select(line => line.TrimEnd('\r'))
            .Where(line => !string.IsNullOrWhiteSpace(line))
            .TakeLast(8)
            .ToArray();

        return tail.Any(line => line.StartsWith("› "));
    }

    private static bool ContainsWorkingIndicator(string? output)
    {
        if (string.IsNullOrWhiteSpace(output))
        {
            return false;
        }

        var tail = output.Split('\n')
            .Select(line => line.TrimEnd('\r'))
            .Where(line => !string.IsNullOrWhiteSpace(line))
            .TakeLast(20)
            .ToArray();

        return tail.Any(line => line.StartsWith("◦ Working", StringComparison.Ordinal) ||
                                line.StartsWith("• Working", StringComparison.Ordinal));
    }

    private static string? ExtractLastValue(string? output, string key)
    {
        if (string.IsNullOrWhiteSpace(output))
        {
            return null;
        }

        var regex = new Regex($"^{Regex.Escape(key)}:\\s*(.+)$", RegexOptions.Multiline);
        var matches = regex.Matches(output);
        if (matches.Count == 0)
        {
            return null;
        }

        return matches[^1].Groups[1].Value.Trim();
    }

    private static string TailExcerpt(string? output, int lineCount)
    {
        if (string.IsNullOrWhiteSpace(output))
        {
            return "";
        }

        return string.Join(
            Environment.NewLine,
            output.Split('\n')
                .Select(line => line.TrimEnd('\r'))
                .TakeLast(lineCount));
    }

    private static string ClassifyIssueFamily(string status, bool? valueMatch, bool? displayMatch, string formula, string? discrepancySummary)
    {
        if (string.Equals(status, "Matched", StringComparison.OrdinalIgnoreCase))
        {
            return "matched";
        }

        if (string.Equals(status, "Blocked", StringComparison.OrdinalIgnoreCase))
        {
            return "blocked";
        }

        if (ContainsVolatileFunction(formula))
        {
            return "volatile_deferred";
        }

        if (valueMatch == true && displayMatch == false)
        {
            return "display_only";
        }

        if (!string.IsNullOrWhiteSpace(discrepancySummary) &&
            discrepancySummary.Contains("Display divergence:", StringComparison.OrdinalIgnoreCase) &&
            !discrepancySummary.Contains("Value divergence:", StringComparison.OrdinalIgnoreCase))
        {
            return "display_only";
        }

        return "semantic_or_runtime";
    }

    private static bool ContainsVolatileFunction(string formula)
    {
        return formula.Contains("RAND(", StringComparison.OrdinalIgnoreCase) ||
               formula.Contains("RANDBETWEEN(", StringComparison.OrdinalIgnoreCase) ||
               formula.Contains("RANDARRAY(", StringComparison.OrdinalIgnoreCase);
    }

    private static string? GetString(JsonElement element, string propertyName)
    {
        if (!element.TryGetProperty(propertyName, out var value))
        {
            return null;
        }

        return value.ValueKind switch
        {
            JsonValueKind.String => value.GetString(),
            JsonValueKind.Null => null,
            _ => value.ToString()
        };
    }

    private static bool? GetNullableBool(JsonElement element, string propertyName)
    {
        if (!element.TryGetProperty(propertyName, out var value))
        {
            return null;
        }

        return value.ValueKind switch
        {
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            _ => null
        };
    }

    private static string? TryGetNestedString(JsonElement parent, string childName, string propertyName)
    {
        if (!parent.TryGetProperty(childName, out var child) || child.ValueKind != JsonValueKind.Object)
        {
            return null;
        }

        return GetString(child, propertyName);
    }

    private static List<string> GetStringArray(JsonElement element, string propertyName)
    {
        var outList = new List<string>();
        if (!element.TryGetProperty(propertyName, out var value) || value.ValueKind != JsonValueKind.Array)
        {
            return outList;
        }

        foreach (var item in value.EnumerateArray())
        {
            if (item.ValueKind == JsonValueKind.String)
            {
                var text = item.GetString();
                if (!string.IsNullOrWhiteSpace(text))
                {
                    outList.Add(text);
                }
            }
        }

        return outList;
    }

    private static void WriteJson<T>(string path, T value)
    {
        File.WriteAllText(path, JsonSerializer.Serialize(value, JsonOptions));
    }

    private static string RenderCampaignMarkdown(CampaignSnapshot snapshot)
    {
        var sb = new StringBuilder();
        sb.AppendLine("# Corpus Campaign Status");
        sb.AppendLine();
        sb.AppendLine($"Generated: `{snapshot.GeneratedAtUtc:O}`");
        sb.AppendLine();
        sb.AppendLine("## Summary");
        sb.AppendLine();
        sb.AppendLine($"- Total cases tracked: `{snapshot.Summary.TotalCases}`");
        sb.AppendLine($"- Matched: `{snapshot.Summary.MatchedCases}`");
        sb.AppendLine($"- Blocked: `{snapshot.Summary.BlockedCases}`");
        sb.AppendLine($"- Open: `{snapshot.Summary.OpenCases}`");
        sb.AppendLine();
        sb.AppendLine("## Issue Families");
        sb.AppendLine();
        foreach (var family in snapshot.Summary.ByIssueFamily)
        {
            sb.AppendLine($"- `{family.Key}`: `{family.Count}`");
        }

        sb.AppendLine();
        sb.AppendLine("## Open Cases");
        sb.AppendLine();
        sb.AppendLine("| Case | Status | Family | Owner | Local | Bundle | Next Action |");
        sb.AppendLine("|---|---|---|---|---|---|---|");
        foreach (var item in snapshot.Cases.Where(c => !string.Equals(c.LatestStatus, "Matched", StringComparison.OrdinalIgnoreCase)))
        {
            sb.AppendLine($"| `{item.CaseId}` | `{item.LatestStatus}` | `{item.IssueFamily}` | `{item.OwnerRepo ?? ""}` | `{item.LocalReproStatus ?? ""}` | `{item.LastBundleId}` | {EscapePipe(item.NextAction ?? "")} |");
        }

        return sb.ToString();
    }

    private static string RenderPaneMarkdown(PaneSnapshot snapshot)
    {
        var sb = new StringBuilder();
        sb.AppendLine("# Subagent Monitor Status");
        sb.AppendLine();
        sb.AppendLine($"Generated: `{snapshot.GeneratedAtUtc:O}`");
        sb.AppendLine($"Workspace: `{snapshot.Workspace}`");
        sb.AppendLine();
        sb.AppendLine("| Pane | Mode | Execution | Open Lanes | Prompt Pending | Capture Error |");
        sb.AppendLine("|---|---|---|---|---|---|");
        foreach (var pane in snapshot.Panes)
        {
        sb.AppendLine($"| `{pane.Pane}` | `{pane.Mode}` | `{pane.ExecutionState ?? ""}` | {EscapePipe(pane.OpenLanes ?? "")} | `{pane.PromptVisible}` | {EscapePipe(pane.CaptureError ?? "")} |");
        }

        sb.AppendLine();
        foreach (var pane in snapshot.Panes)
        {
            sb.AppendLine($"## {pane.Pane}");
            sb.AppendLine();
            if (!string.IsNullOrWhiteSpace(pane.ExcerptPath))
            {
                sb.AppendLine($"Excerpt: `{pane.ExcerptPath}`");
                sb.AppendLine();
            }

            if (!string.IsNullOrWhiteSpace(pane.TailExcerpt))
            {
                sb.AppendLine("```text");
                sb.AppendLine(pane.TailExcerpt);
                sb.AppendLine("```");
                sb.AppendLine();
            }
        }

        return sb.ToString();
    }

    private static string EscapePipe(string text) => text.Replace("|", "\\|");

    private static string RunProcessCapture(string fileName, string arguments)
    {
        var psi = new ProcessStartInfo
        {
            FileName = fileName,
            Arguments = arguments,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi) ?? throw new InvalidOperationException($"Failed to start {fileName}.");
        var stdout = process.StandardOutput.ReadToEnd();
        var stderr = process.StandardError.ReadToEnd();
        process.WaitForExit();

        if (process.ExitCode != 0)
        {
            throw new InvalidOperationException($"{fileName} exited with code {process.ExitCode}: {stderr}".Trim());
        }

        return string.IsNullOrWhiteSpace(stdout) ? stderr : stdout;
    }
}

internal sealed record Options(
    string RepoRoot,
    string ResultsRoot,
    string MonitorRoot,
    string Workspace,
    string[] Panes,
    int CaptureLines,
    int IntervalSeconds);

internal sealed record CampaignNote(
    [property: JsonPropertyName("case_id")] string? CaseId,
    [property: JsonPropertyName("owner_repo")] string? OwnerRepo,
    [property: JsonPropertyName("local_repro_status")] string? LocalReproStatus,
    [property: JsonPropertyName("issue_family")] string? IssueFamily,
    [property: JsonPropertyName("next_action")] string? NextAction,
    [property: JsonPropertyName("needs_user_review")] bool? NeedsUserReview);

internal sealed record KeyCount(string Key, int Count);

internal sealed record CampaignSummary(
    int TotalCases,
    int MatchedCases,
    int BlockedCases,
    int OpenCases,
    List<KeyCount> ByIssueFamily);

internal sealed record CaseStatus(
    string CaseId,
    string Formula,
    string LatestStatus,
    string IssueFamily,
    string? OwnerRepo,
    string? LocalReproStatus,
    string? NextAction,
    bool? NeedsUserReview,
    string LastBundleId,
    string LastReportPath,
    DateTime LastReportWriteTimeUtc,
    bool? ValueMatch,
    bool? DisplayMatch,
    string? DiscrepancySummary,
    List<string> ReplayMismatchKinds,
    string? OxfmlEvaluationSummary,
    string? ExcelObservedValueRepr,
    string? ExcelDisplayText);

internal sealed record CampaignSnapshot(
    DateTime GeneratedAtUtc,
    string ResultsRoot,
    CampaignSummary Summary,
    List<CaseStatus> Cases);

internal sealed record PaneState(
    string Pane,
    string? ExcerptPath,
    string? ExecutionState,
    string? OpenLanes,
    string? ScopeCompleteness,
    string? TargetCompleteness,
    bool PromptVisible,
    string Mode,
    string TailExcerpt,
    string? CaptureError);

internal sealed record PaneSnapshot(
    DateTime GeneratedAtUtc,
    string Workspace,
    List<PaneState> Panes);
