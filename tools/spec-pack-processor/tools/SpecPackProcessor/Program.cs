using System.Diagnostics;
using System.Globalization;
using System.IO.Compression;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using UglyToad.PdfPig;

internal static class Program
{
    static readonly JsonSerializerOptions JsonIndented = new()
    {
        WriteIndented = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
        DictionaryKeyPolicy = JsonNamingPolicy.SnakeCaseLower
    };
    static readonly JsonSerializerOptions JsonCompact = new()
    {
        WriteIndented = false,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
        DictionaryKeyPolicy = JsonNamingPolicy.SnakeCaseLower
    };
    static readonly string InvocationCwd = Environment.GetEnvironmentVariable("SPEC_PACK_PROCESSOR_INVOKE_CWD") ?? Directory.GetCurrentDirectory();

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
                "run" => Run(args.Skip(1).ToArray()),
                _ => Fail($"Unknown command '{args[0]}'.")
            };
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex);
            return 1;
        }
    }

    static void Help() => Console.WriteLine("""
spec-pack-processor (C#)
  run --source-index <csv> --out <dir> [--filter <text>] [--max-docs N] [--include-ext .docx,.md,.pdf,.html,.htm]
""");

    static int Run(string[] args)
    {
        string sourceIndex = "reference/index.csv";
        string? outDir = null;
        string filter = string.Empty;
        int maxDocs = 0;
        string includeExt = ".docx,.md,.pdf,.html,.htm";

        for (int i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--source-index": sourceIndex = args[++i]; break;
                case "--out": outDir = args[++i]; break;
                case "--filter": filter = args[++i]; break;
                case "--max-docs": maxDocs = int.Parse(args[++i], CultureInfo.InvariantCulture); break;
                case "--include-ext": includeExt = args[++i]; break;
                default: return Fail($"Unknown option '{args[i]}'.");
            }
        }

        var indexPath = ResolvePath(sourceIndex);
        if (!File.Exists(indexPath)) return Fail($"Source index not found: {indexPath}");

        var runId = $"specproc-{DateTime.UtcNow:yyyyMMdd-HHmmss}";
        var outputRoot = ResolvePath(outDir ?? $"reference/runs/{runId}/outputs");
        var docsRoot = Path.Combine(outputRoot, "docs");
        var llmRoot = Path.Combine(outputRoot, "llm");
        Directory.CreateDirectory(docsRoot);
        Directory.CreateDirectory(llmRoot);

        var extSet = includeExt.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .Select(x => x.StartsWith('.') ? x.ToLowerInvariant() : "." + x.ToLowerInvariant())
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var rows = LoadRows(indexPath)
            .Where(r => string.Equals(r.Status, "downloaded", StringComparison.OrdinalIgnoreCase))
            .Where(r => !string.IsNullOrWhiteSpace(r.LocalPath) && File.Exists(r.LocalPath!))
            .Where(r => extSet.Contains(Path.GetExtension(r.LocalPath!).ToLowerInvariant()))
            .ToList();

        if (!string.IsNullOrWhiteSpace(filter))
        {
            rows = rows.Where(r => (r.SourceUrl?.Contains(filter, StringComparison.OrdinalIgnoreCase) ?? false) ||
                                   (r.LocalPath?.Contains(filter, StringComparison.OrdinalIgnoreCase) ?? false) ||
                                   (r.SourceId?.Contains(filter, StringComparison.OrdinalIgnoreCase) ?? false)).ToList();
        }
        if (maxDocs > 0) rows = rows.Take(maxDocs).ToList();

        var docSummaries = new List<DocSummary>();
        var allSpecItems = new List<SpecItem>();
        var allConformance = new List<ConformanceItem>();
        var allExcludedConformance = new List<ExcludedConformanceItem>();
        var allSentences = new List<SentenceRecord>();

        WriteSelectedSourcesCsv(Path.Combine(outputRoot, "selected_sources.csv"), rows);

        int iDoc = 0;
        foreach (var row in rows)
        {
            iDoc++;
            Console.WriteLine($"[{iDoc}/{rows.Count}] {row.LocalPath}");
            var summary = ProcessDocument(row, docsRoot, allSpecItems, allConformance, allExcludedConformance, allSentences);
            docSummaries.Add(summary);
        }

        WriteJsonl(Path.Combine(outputRoot, "spec_items.jsonl"), allSpecItems);
        WriteJsonl(Path.Combine(outputRoot, "conformance_items.jsonl"), allConformance);
        WriteJsonl(Path.Combine(outputRoot, "conformance_excluded.jsonl"), allExcludedConformance);
        WriteJsonl(Path.Combine(llmRoot, "classification_tasks.jsonl"), allSentences);
        WriteCsv(Path.Combine(outputRoot, "documents.csv"),
            ["document_id","source_id","source_url","local_path","sha256","extraction_status","extraction_mode","segments","sentences","spec_items","conformance","conformance_excluded","images","tables","pending","notes"],
            docSummaries.Select(s => new[] { s.DocumentId, s.SourceId, s.SourceUrl, s.LocalPath, s.Sha256, s.ExtractionStatus, s.ExtractionMode,
                s.SegmentCount.ToString(CultureInfo.InvariantCulture), s.SentenceCount.ToString(CultureInfo.InvariantCulture),
                s.SpecItemCount.ToString(CultureInfo.InvariantCulture), s.ConformanceCount.ToString(CultureInfo.InvariantCulture), s.ExcludedConformanceCount.ToString(CultureInfo.InvariantCulture), s.ImageCount.ToString(CultureInfo.InvariantCulture),
                s.TableCount.ToString(CultureInfo.InvariantCulture), s.PendingCount.ToString(CultureInfo.InvariantCulture), s.Notes ?? string.Empty }));

        var excludedByReason = allExcludedConformance
            .GroupBy(x => x.ExclusionReason)
            .OrderByDescending(g => g.Count())
            .ToDictionary(g => g.Key, g => g.Count(), StringComparer.OrdinalIgnoreCase);

        var runManifest = new
        {
            run_id = runId,
            captured_utc = Utc(),
            source_index = indexPath,
            docs_processed = docSummaries.Count,
            segments = docSummaries.Sum(d => d.SegmentCount),
            sentences = docSummaries.Sum(d => d.SentenceCount),
            spec_items = allSpecItems.Count,
            conformance_candidates = allConformance.Count,
            conformance_excluded = allExcludedConformance.Count,
            pending_items = docSummaries.Sum(d => d.PendingCount),
            tooling = ToolingInfo(),
            quality = new
            {
                excluded_by_reason = excludedByReason
            },
            outputs = new
            {
                documents_csv = Path.Combine(outputRoot, "documents.csv"),
                selected_sources_csv = Path.Combine(outputRoot, "selected_sources.csv"),
                spec_jsonl = Path.Combine(outputRoot, "spec_items.jsonl"),
                conformance_jsonl = Path.Combine(outputRoot, "conformance_items.jsonl"),
                conformance_excluded_jsonl = Path.Combine(outputRoot, "conformance_excluded.jsonl"),
                llm_tasks_jsonl = Path.Combine(llmRoot, "classification_tasks.jsonl")
            }
        };
        WriteJson(Path.Combine(outputRoot, "run_manifest.json"), runManifest);

        File.WriteAllText(Path.Combine(outputRoot, "README.md"), BuildRunReadme(runManifest, docSummaries, excludedByReason), Encoding.UTF8);

        Console.WriteLine($"Processed: {docSummaries.Count}");
        Console.WriteLine($"Conformance candidates: {allConformance.Count}");
        Console.WriteLine($"Output: {outputRoot}");
        return 0;
    }
    static DocSummary ProcessDocument(
        IndexRow row,
        string docsRoot,
        List<SpecItem> allSpecItems,
        List<ConformanceItem> allConformance,
        List<ExcludedConformanceItem> allExcludedConformance,
        List<SentenceRecord> allSentences)
    {
        var sourcePath = row.LocalPath!;
        var ext = Path.GetExtension(sourcePath).ToLowerInvariant();
        var docId = BuildDocId(row, sourcePath);
        var docOutDir = Path.Combine(docsRoot, docId);
        Directory.CreateDirectory(docOutDir);

        var imageDir = Path.Combine(docOutDir, "images");
        Directory.CreateDirectory(imageDir);

        var extracted = ext switch
        {
            ".docx" => ExtractDocx(sourcePath, imageDir),
            ".md" => ExtractMarkdown(sourcePath),
            ".html" or ".htm" => ExtractHtml(sourcePath),
            ".pdf" => ExtractPdf(sourcePath, docOutDir),
            _ => ExtractUnsupported($"Unsupported extension: {ext}")
        };

        int seq = 0;
        var segments = extracted.Segments.Select(s => new SegmentRecord
        {
            SegmentId = $"{docId}-SEG-{++seq:D6}",
            DocumentId = docId,
            Kind = s.Kind,
            Text = s.Text,
            IsBlank = s.IsBlank,
            Source = new SourceRef
            {
                SourceId = row.SourceId,
                SourceUrl = row.SourceUrl,
                LocalPath = sourcePath,
                Anchor = s.Anchor,
                Page = s.Page,
                Table = s.Table,
                Row = s.Row,
                Column = s.Column,
                RelationshipId = s.RelationshipId,
                ExtractedImagePath = s.ExtractedImagePath
            }
        }).ToList();

        var sentences = new List<SentenceRecord>();
        foreach (var seg in segments)
        {
            int part = 0;
            foreach (var sentence in SplitSentences(seg.Text))
            {
                var trimmed = NormalizeWhitespace(sentence);
                if (string.IsNullOrWhiteSpace(trimmed)) continue;
                part++;
                sentences.Add(new SentenceRecord
                {
                    SentenceId = $"{seg.SegmentId}-S{part:D2}",
                    SegmentId = seg.SegmentId,
                    DocumentId = seg.DocumentId,
                    Text = trimmed,
                    Informative = IsInformative(trimmed, seg.Kind),
                    NormativeLevel = NormativeLevel(trimmed),
                    TopicTags = Tags(trimmed, seg.Kind),
                    ClassificationSource = "heuristic",
                    Source = seg.Source
                });
            }
        }

        int cidx = 0;
        int sidx = 0;
        var specItems = new List<SpecItem>();
        var conformance = new List<ConformanceItem>();
        var excluded = new List<ExcludedConformanceItem>();
        foreach (var s in sentences.Where(x => x.Informative))
        {
            if (TryGetSpecExclusionReason(s.Text, s.TopicTags, out _))
            {
                continue;
            }

            sidx++;
            specItems.Add(new SpecItem
            {
                ItemId = $"SPEC-{docId}-{sidx:D5}",
                DocumentId = docId,
                SourceSentenceId = s.SentenceId,
                SpecLevel = IsNormative(s.NormativeLevel) ? "normative" : "informative",
                Statement = s.Text,
                TopicTags = s.TopicTags,
                Status = "candidate",
                Source = s.Source
            });

            if (!IsNormative(s.NormativeLevel))
            {
                continue;
            }

            if (TryGetConformanceExclusionReason(s.Text, s.TopicTags, out var reason))
            {
                excluded.Add(new ExcludedConformanceItem
                {
                    ItemId = $"CONF-EXCL-{docId}-{excluded.Count + 1:D4}",
                    DocumentId = docId,
                    SourceSentenceId = s.SentenceId,
                    NormativeLevel = s.NormativeLevel,
                    Statement = s.Text,
                    TopicTags = s.TopicTags,
                    ExclusionReason = reason,
                    Status = "excluded",
                    Source = s.Source
                });
                continue;
            }

            cidx++;
            conformance.Add(new ConformanceItem
            {
                ItemId = $"CONF-{docId}-{cidx:D4}",
                DocumentId = docId,
                SourceSentenceId = s.SentenceId,
                Priority = Priority(s.NormativeLevel),
                NormativeLevel = s.NormativeLevel,
                Statement = s.Text,
                TopicTags = s.TopicTags,
                VerificationHint = VerificationHint(s.TopicTags),
                Status = "candidate",
                Source = s.Source
            });
        }

        var sha = string.IsNullOrWhiteSpace(row.Sha256) ? Sha256(sourcePath) : row.Sha256!;

        WriteJsonl(Path.Combine(docOutDir, "segments.jsonl"), segments);
        WriteJsonl(Path.Combine(docOutDir, "sentences.jsonl"), sentences);
        WriteJsonl(Path.Combine(docOutDir, "spec_items.jsonl"), specItems);
        WriteJsonl(Path.Combine(docOutDir, "conformance_candidates.jsonl"), conformance);
        WriteJsonl(Path.Combine(docOutDir, "conformance_excluded.jsonl"), excluded);

        WriteJson(Path.Combine(docOutDir, "document_manifest.json"), new
        {
            document_id = docId,
            source_id = row.SourceId,
            source_url = row.SourceUrl,
            local_path = sourcePath,
            source_sha256 = sha,
            extraction_status = extracted.ExtractionStatus,
            extraction_mode = extracted.ExtractionMode,
            notes = extracted.Notes,
            artifacts = new
            {
                segments_jsonl = Path.Combine(docOutDir, "segments.jsonl"),
                sentences_jsonl = Path.Combine(docOutDir, "sentences.jsonl"),
                spec_items_jsonl = Path.Combine(docOutDir, "spec_items.jsonl"),
                conformance_candidates_jsonl = Path.Combine(docOutDir, "conformance_candidates.jsonl"),
                conformance_excluded_jsonl = Path.Combine(docOutDir, "conformance_excluded.jsonl"),
                images_dir = imageDir
            }
        });

        allSpecItems.AddRange(specItems);
        allConformance.AddRange(conformance);
        allExcludedConformance.AddRange(excluded);
        allSentences.AddRange(sentences);

        return new DocSummary
        {
            DocumentId = docId,
            SourceId = row.SourceId ?? string.Empty,
            SourceUrl = row.SourceUrl ?? string.Empty,
            LocalPath = sourcePath,
            Sha256 = sha,
            ExtractionStatus = extracted.ExtractionStatus,
            ExtractionMode = extracted.ExtractionMode,
            SegmentCount = segments.Count,
            SentenceCount = sentences.Count,
            SpecItemCount = specItems.Count,
            ConformanceCount = conformance.Count,
            ExcludedConformanceCount = excluded.Count,
            ImageCount = extracted.ImageCount,
            TableCount = extracted.TableCount,
            PendingCount = extracted.PendingCount,
            Notes = extracted.Notes
        };
    }

    static ExtractResult ExtractMarkdown(string path)
    {
        var result = new ExtractResult { ExtractionStatus = "ok", ExtractionMode = "markdown_native" };
        var lines = File.ReadAllLines(path);
        var startIndex = 0;

        // Skip YAML front matter commonly present in Microsoft Learn markdown exports.
        if (lines.Length > 0 && lines[0].Trim() == "---")
        {
            for (int i = 1; i < lines.Length; i++)
            {
                if (lines[i].Trim() == "---")
                {
                    startIndex = i + 1;
                    break;
                }
            }
        }
        var buffer = new List<string>();
        int startLine = 0;
        bool inCode = false;

        void Flush(int endLine)
        {
            if (buffer.Count == 0) return;
            var text = NormalizeWhitespace(string.Join(" ", buffer));
            if (!string.IsNullOrWhiteSpace(text))
            {
                result.Segments.Add(new SegmentDraft { Kind = "paragraph", Text = text, Anchor = $"L{startLine}-L{endLine}" });
            }
            buffer.Clear();
            startLine = 0;
        }

        for (int i = startIndex; i < lines.Length; i++)
        {
            var lineNo = i + 1;
            var trim = lines[i].Trim();

            if (string.IsNullOrWhiteSpace(trim)) { Flush(lineNo - 1); continue; }
            if (Regex.IsMatch(trim, @"^(ms|author|locale|document_id|updated_at|original_content_git_url|gitcommit|git_commit_id|site_name|depot_name|page_type|toc_rel|word_count|asset_id|item_type|source_path|canonicalUrl|breadcrumb_path)\s*:\s*", RegexOptions.IgnoreCase))
            {
                Flush(lineNo - 1);
                continue;
            }
            if (trim == "---")
            {
                Flush(lineNo - 1);
                continue;
            }

            if (trim.StartsWith("```") || trim.StartsWith("~~~")) { Flush(lineNo - 1); inCode = !inCode; continue; }
            if (inCode) continue;

            if (trim.StartsWith("#"))
            {
                Flush(lineNo - 1);
                result.Segments.Add(new SegmentDraft { Kind = "heading", Text = NormalizeWhitespace(trim.TrimStart('#').Trim()), Anchor = $"L{lineNo}" });
                continue;
            }

            if (Regex.IsMatch(trim, @"^([-*+]|[0-9]+\.)\s+"))
            {
                Flush(lineNo - 1);
                var listText = Regex.Replace(trim, @"^([-*+]|[0-9]+\.)\s+", "");
                result.Segments.Add(new SegmentDraft
                {
                    Kind = "list_item",
                    Text = NormalizeWhitespace(listText),
                    Anchor = $"L{lineNo}"
                });
                continue;
            }

            if (Regex.IsMatch(trim, @"!\[[^\]]*\]\([^)]+\)"))
            {
                Flush(lineNo - 1);
                foreach (Match m in Regex.Matches(trim, @"!\[(?<alt>[^\]]*)\]\((?<url>[^)]+)\)"))
                {
                    var alt = m.Groups["alt"].Value;
                    var url = m.Groups["url"].Value;
                    result.Segments.Add(new SegmentDraft { Kind = "image_ref", Text = string.IsNullOrWhiteSpace(alt) ? $"[image] {url}" : $"[image] {alt}", Anchor = $"L{lineNo}" });
                    result.ImageCount++;
                }
                continue;
            }

            if (trim.Contains('|') && trim.Count(c => c == '|') >= 2)
            {
                Flush(lineNo - 1);
                result.TableCount++;
                var cells = trim.Trim('|').Split('|');
                for (int c = 0; c < cells.Length; c++)
                {
                    var cellText = NormalizeWhitespace(cells[c]);
                    var blank = string.IsNullOrWhiteSpace(cellText);
                    result.Segments.Add(new SegmentDraft
                    {
                        Kind = "table_cell",
                        Text = blank ? "<blank>" : cellText,
                        Anchor = $"L{lineNo}",
                        Table = result.TableCount,
                        Row = 1,
                        Column = c + 1,
                        IsBlank = blank
                    });
                }
                continue;
            }

            if (buffer.Count == 0) startLine = lineNo;
            buffer.Add(trim);
        }

        Flush(lines.Length);
        return result;
    }

    static ExtractResult ExtractHtml(string path)
    {
        var result = new ExtractResult { ExtractionStatus = "ok", ExtractionMode = "html_text_strip" };
        var html = File.ReadAllText(path);

        html = Regex.Replace(html, @"(?is)<script\b[^>]*>.*?</script>", " ");
        html = Regex.Replace(html, @"(?is)<style\b[^>]*>.*?</style>", " ");

        int section = 0;
        foreach (Match m in Regex.Matches(html, @"(?is)<h[1-6][^>]*>(.*?)</h[1-6]>"))
        {
            section++;
            var text = HtmlToText(m.Groups[1].Value);
            if (!string.IsNullOrWhiteSpace(text))
            {
                result.Segments.Add(new SegmentDraft
                {
                    Kind = "heading",
                    Text = text,
                    Anchor = $"h:{section}"
                });
            }
        }

        int p = 0;
        foreach (Match m in Regex.Matches(html, @"(?is)<p\b[^>]*>(.*?)</p>"))
        {
            p++;
            var text = HtmlToText(m.Groups[1].Value);
            if (!string.IsNullOrWhiteSpace(text))
            {
                result.Segments.Add(new SegmentDraft
                {
                    Kind = "paragraph",
                    Text = text,
                    Anchor = $"p:{p}"
                });
            }
        }

        int li = 0;
        foreach (Match m in Regex.Matches(html, @"(?is)<li\b[^>]*>(.*?)</li>"))
        {
            li++;
            var text = HtmlToText(m.Groups[1].Value);
            if (!string.IsNullOrWhiteSpace(text))
            {
                result.Segments.Add(new SegmentDraft
                {
                    Kind = "list_item",
                    Text = text,
                    Anchor = $"li:{li}"
                });
            }
        }

        int tbl = 0;
        foreach (Match table in Regex.Matches(html, @"(?is)<table\b[^>]*>(.*?)</table>"))
        {
            tbl++;
            result.TableCount++;
            int row = 0;
            foreach (Match tr in Regex.Matches(table.Groups[1].Value, @"(?is)<tr\b[^>]*>(.*?)</tr>"))
            {
                row++;
                int col = 0;
                foreach (Match td in Regex.Matches(tr.Groups[1].Value, @"(?is)<t[hd]\b[^>]*>(.*?)</t[hd]>"))
                {
                    col++;
                    var text = HtmlToText(td.Groups[1].Value);
                    var blank = string.IsNullOrWhiteSpace(text);
                    result.Segments.Add(new SegmentDraft
                    {
                        Kind = "table_cell",
                        Text = blank ? "<blank>" : text,
                        Anchor = $"tbl:{tbl}",
                        Table = tbl,
                        Row = row,
                        Column = col,
                        IsBlank = blank
                    });
                }
            }
        }

        if (result.Segments.Count == 0)
        {
            var fallback = HtmlToText(html);
            var lines = fallback.Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            int i = 0;
            foreach (var line in lines)
            {
                i++;
                result.Segments.Add(new SegmentDraft
                {
                    Kind = "paragraph",
                    Text = line,
                    Anchor = $"line:{i}"
                });
            }
        }

        if (result.Segments.Count == 0)
        {
            result.ExtractionStatus = "warning";
            result.Notes = "Parsed HTML but emitted no segments.";
        }

        return result;
    }

    static string HtmlToText(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return string.Empty;
        var withBreaks = Regex.Replace(value, @"(?is)<br\s*/?>", "\n");
        var stripped = Regex.Replace(withBreaks, @"(?is)<[^>]+>", " ");
        return NormalizeWhitespace(WebUtility.HtmlDecode(stripped));
    }

    static ExtractResult ExtractDocx(string path, string imageDir)
    {
        var result = new ExtractResult { ExtractionStatus = "ok", ExtractionMode = "docx_openxml_zip" };
        using var archive = ZipFile.OpenRead(path);
        var docEntry = archive.GetEntry("word/document.xml");
        if (docEntry is null) return ExtractFailed("word/document.xml missing.");

        var relMap = LoadDocxRelationships(archive);
        var copied = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

        XDocument xdoc;
        using (var s = docEntry.Open()) xdoc = XDocument.Load(s, LoadOptions.PreserveWhitespace);

        XNamespace w = "http://schemas.openxmlformats.org/wordprocessingml/2006/main";
        XNamespace a = "http://schemas.openxmlformats.org/drawingml/2006/main";
        XNamespace r = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";
        XNamespace wp = "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing";

        var body = xdoc.Root?.Element(w + "body");
        if (body is null) return ExtractFailed("w:body missing.");

        int p = 0;
        int t = 0;
        int img = 0;

        foreach (var node in body.Elements())
        {
            if (node.Name == w + "p")
            {
                p++;
                var text = NormalizeWhitespace(string.Concat(node.Descendants(w + "t").Select(x => x.Value)));
                var style = node.Elements(w + "pPr").Elements(w + "pStyle").Attributes(w + "val").Select(x => x.Value).FirstOrDefault() ?? string.Empty;
                if (!string.IsNullOrWhiteSpace(text))
                {
                    result.Segments.Add(new SegmentDraft
                    {
                        Kind = style.StartsWith("Heading", StringComparison.OrdinalIgnoreCase) ? "heading" : "paragraph",
                        Text = text,
                        Anchor = $"p:{p}"
                    });
                }

                foreach (var drawing in node.Descendants(w + "drawing"))
                {
                    img++;
                    var relId = drawing.Descendants(a + "blip").Attributes(r + "embed").Select(x => x.Value).FirstOrDefault();
                    var docPr = drawing.Descendants(wp + "docPr").FirstOrDefault();
                    var alt = docPr?.Attribute("descr")?.Value ?? docPr?.Attribute("title")?.Value ?? docPr?.Attribute("name")?.Value ?? "image";

                    string? extractedImage = null;
                    if (!string.IsNullOrWhiteSpace(relId) && relMap.TryGetValue(relId, out var target))
                    {
                        extractedImage = CopyDocxImage(archive, target, imageDir, img, copied);
                    }

                    result.Segments.Add(new SegmentDraft
                    {
                        Kind = "image_ref",
                        Text = $"[image] {alt}",
                        Anchor = $"p:{p}",
                        RelationshipId = relId,
                        ExtractedImagePath = extractedImage
                    });
                    if (!string.IsNullOrWhiteSpace(extractedImage)) result.ImageCount++;
                }
            }
            else if (node.Name == w + "tbl")
            {
                t++;
                result.TableCount++;
                int row = 0;
                foreach (var rNode in node.Elements(w + "tr"))
                {
                    row++;
                    int col = 0;
                    foreach (var cell in rNode.Elements(w + "tc"))
                    {
                        col++;
                        var cellText = NormalizeWhitespace(string.Concat(cell.Descendants(w + "t").Select(x => x.Value)));
                        var blank = string.IsNullOrWhiteSpace(cellText);
                        result.Segments.Add(new SegmentDraft
                        {
                            Kind = "table_cell",
                            Text = blank ? "<blank>" : cellText,
                            Anchor = $"tbl:{t}",
                            Table = t,
                            Row = row,
                            Column = col,
                            IsBlank = blank
                        });
                    }
                }
            }
        }

        if (result.Segments.Count == 0)
        {
            result.ExtractionStatus = "warning";
            result.Notes = "Parsed but emitted no text segments.";
        }
        return result;
    }

    static Dictionary<string, string> LoadDocxRelationships(ZipArchive archive)
    {
        var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var relEntry = archive.GetEntry("word/_rels/document.xml.rels");
        if (relEntry is null) return map;
        XNamespace rel = "http://schemas.openxmlformats.org/package/2006/relationships";
        using var stream = relEntry.Open();
        var x = XDocument.Load(stream);
        foreach (var e in x.Descendants(rel + "Relationship"))
        {
            var id = e.Attribute("Id")?.Value;
            var target = e.Attribute("Target")?.Value;
            if (!string.IsNullOrWhiteSpace(id) && !string.IsNullOrWhiteSpace(target))
            {
                map[id!] = target!;
            }
        }
        return map;
    }

    static string? CopyDocxImage(ZipArchive archive, string target, string imageDir, int idx, Dictionary<string, string> copied)
    {
        if (copied.TryGetValue(target, out var existing)) return existing;
        var normalized = target.Replace('\\', '/').TrimStart('/');
        while (normalized.StartsWith("../", StringComparison.Ordinal)) normalized = normalized[3..];
        var zipPath = normalized.StartsWith("word/", StringComparison.OrdinalIgnoreCase) ? normalized : $"word/{normalized}";

        var entry = archive.GetEntry(zipPath);
        if (entry is null) return null;

        var safe = SafeFileName(Path.GetFileName(entry.FullName));
        var outPath = Path.Combine(imageDir, $"img-{idx:D4}-{safe}");
        using (var src = entry.Open())
        using (var dst = File.Create(outPath)) src.CopyTo(dst);

        copied[target] = outPath;
        return outPath;
    }

    static ExtractResult ExtractPdf(string path, string docOutDir)
    {
        var result = new ExtractResult { ExtractionStatus = "warning", ExtractionMode = "pdf_pending_ocr" };
        var artifactsDir = Path.Combine(docOutDir, "artifacts");
        Directory.CreateDirectory(artifactsDir);
        var txtPath = Path.Combine(artifactsDir, "pdf_text.txt");
        string? pigNote = null;

        if (TryPdfToText(path, txtPath, out var note) && File.Exists(txtPath))
        {
            AppendPdfSegmentsFromFormFeedText(result, File.ReadAllText(txtPath));
            result.ExtractionStatus = result.Segments.Count > 0 ? "ok" : "warning";
            result.ExtractionMode = "pdf_pdftotext";
            result.Notes = note ?? "Extracted with pdftotext.";
        }
        else if (TryPdfPigExtract(path, out var pages, out pigNote))
        {
            var pigTxtPath = Path.Combine(artifactsDir, "pdf_text_pdfpig.txt");
            var combinedText = string.Join('\f', pages);
            File.WriteAllText(pigTxtPath, combinedText, new UTF8Encoding(false));
            AppendPdfSegmentsFromFormFeedText(result, combinedText);
            result.ExtractionStatus = result.Segments.Count > 0 ? "ok" : "warning";
            result.ExtractionMode = "pdf_pdfpig";
            result.Notes = pigNote ?? "Extracted with PdfPig.";
        }
        else
        {
            result.PendingCount++;
            result.Segments.Add(new SegmentDraft
            {
                Kind = "pdf_pending",
                Text = "PDF extraction pending OCR/text pass.",
                Anchor = "pdf:pending"
            });
            result.Notes = $"{note ?? "pdftotext not found on PATH."} {(pigNote ?? "PdfPig extraction failed.")}".Trim();
        }

        return result;
    }

    static void AppendPdfSegmentsFromFormFeedText(ExtractResult result, string text)
    {
        var pages = text.Split('\f');
        int p = 0;
        foreach (var page in pages)
        {
            p++;
            var blocks = Regex.Split(page, "\\r?\\n\\s*\\r?\\n")
                .Select(NormalizeWhitespace)
                .Where(x => !string.IsNullOrWhiteSpace(x))
                .ToList();

            // Some extractors produce little/no paragraph breaks. Fall back to line-level chunks.
            if (blocks.Count <= 1)
            {
                var lineBlocks = page
                    .Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                    .Select(NormalizeWhitespace)
                    .Where(x => !string.IsNullOrWhiteSpace(x))
                    .ToList();
                if (lineBlocks.Count > 1) blocks = lineBlocks;
            }

            int b = 0;
            foreach (var block in blocks)
            {
                b++;
                result.Segments.Add(new SegmentDraft
                {
                    Kind = "paragraph",
                    Text = block,
                    Anchor = $"page:{p}:block:{b}",
                    Page = p
                });
            }
        }
    }

    static bool TryPdfPigExtract(string pdfPath, out List<string> pageTexts, out string? note)
    {
        pageTexts = [];
        note = null;
        try
        {
            using var document = PdfDocument.Open(pdfPath);
            foreach (var page in document.GetPages())
            {
                pageTexts.Add(ExtractPdfPigPageText(page));
            }
            note = $"Extracted with PdfPig ({pageTexts.Count} pages).";
            return pageTexts.Count > 0;
        }
        catch (Exception ex)
        {
            note = $"PdfPig extraction failed: {ex.Message}";
            return false;
        }
    }

    static string ExtractPdfPigPageText(UglyToad.PdfPig.Content.Page page)
    {
        var letters = page.Letters?.ToList();
        if (letters is null || letters.Count == 0)
        {
            return page.Text ?? string.Empty;
        }

        static double LineBucket(double bottom) => Math.Round(bottom * 2.0, MidpointRounding.AwayFromZero) / 2.0;

        var lineGroups = letters
            .GroupBy(l => LineBucket(l.GlyphRectangle.Bottom))
            .OrderByDescending(g => g.Key)
            .ToList();

        var lines = new List<string>(lineGroups.Count);
        foreach (var group in lineGroups)
        {
            var ordered = group.OrderBy(l => l.GlyphRectangle.Left).ToList();
            var sb = new StringBuilder(ordered.Count);
            double? prevRight = null;
            foreach (var letter in ordered)
            {
                var glyph = letter.Value;
                if (string.IsNullOrEmpty(glyph)) continue;
                if (glyph.Length == 1 && char.IsControl(glyph[0])) continue;
                if (prevRight.HasValue && letter.GlyphRectangle.Left - prevRight.Value > 1.5) sb.Append(' ');
                sb.Append(glyph);
                prevRight = letter.GlyphRectangle.Right;
            }

            var line = NormalizeWhitespace(sb.ToString());
            if (!string.IsNullOrWhiteSpace(line)) lines.Add(line);
        }

        return string.Join(Environment.NewLine, lines);
    }

    static bool TryPdfToText(string pdfPath, string textOut, out string? note)
    {
        note = null;
        var cmd = FindOnPath("pdftotext.exe") ?? FindOnPath("pdftotext");
        if (cmd is null) { note = "pdftotext not found on PATH."; return false; }

        var psi = new ProcessStartInfo
        {
            FileName = cmd,
            Arguments = $"-layout -enc UTF-8 \"{pdfPath}\" \"{textOut}\"",
            UseShellExecute = false,
            RedirectStandardError = true,
            RedirectStandardOutput = true,
            CreateNoWindow = true
        };

        using var p = Process.Start(psi);
        if (p is null) { note = "Failed to start pdftotext."; return false; }
        p.WaitForExit();
        var err = p.StandardError.ReadToEnd();
        if (p.ExitCode != 0) { note = $"pdftotext exit {p.ExitCode}: {err}"; return false; }
        if (!string.IsNullOrWhiteSpace(err)) note = $"pdftotext stderr: {err.Trim()}";
        return true;
    }

    static string? FindOnPath(string fileName)
    {
        var paths = (Environment.GetEnvironmentVariable("PATH") ?? string.Empty)
            .Split(Path.PathSeparator, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        foreach (var p in paths)
        {
            try
            {
                var candidate = Path.Combine(p, fileName);
                if (File.Exists(candidate)) return candidate;
            }
            catch { }
        }
        return null;
    }

    static ExtractResult ExtractFailed(string message) => new()
    {
        ExtractionStatus = "failed",
        ExtractionMode = "none",
        Notes = message,
        PendingCount = 1,
        Segments = { new SegmentDraft { Kind = "extraction_failed", Text = message, Anchor = "extract:failed" } }
    };

    static ExtractResult ExtractUnsupported(string message) => new()
    {
        ExtractionStatus = "skipped",
        ExtractionMode = "unsupported",
        Notes = message,
        PendingCount = 1,
        Segments = { new SegmentDraft { Kind = "unsupported", Text = message, Anchor = "extract:unsupported" } }
    };

    static List<IndexRow> LoadRows(string csvPath)
    {
        var lines = File.ReadAllLines(csvPath);
        if (lines.Length == 0) return [];

        var headers = ParseCsvLine(lines[0]);
        var map = headers.Select((h, i) => new { h, i }).ToDictionary(x => x.h, x => x.i, StringComparer.OrdinalIgnoreCase);
        string? Get(string[] cells, string name) => map.TryGetValue(name, out var idx) && idx < cells.Length ? cells[idx] : null;

        var list = new List<IndexRow>();
        foreach (var line in lines.Skip(1))
        {
            if (string.IsNullOrWhiteSpace(line)) continue;
            var cells = ParseCsvLine(line);
            list.Add(new IndexRow
            {
                SourceId = Get(cells, "source_id"),
                SourceUrl = Get(cells, "source_url"),
                LocalPath = Get(cells, "local_path"),
                Kind = Get(cells, "kind"),
                Status = Get(cells, "status"),
                Sha256 = Get(cells, "sha256")
            });
        }
        return list;
    }

    static string BuildDocId(IndexRow row, string localPath)
    {
        var sourceToken = row.SourceId;
        if (string.IsNullOrWhiteSpace(sourceToken))
        {
            var m = Regex.Match(localPath, @"MS-[A-Z0-9]+", RegexOptions.IgnoreCase);
            sourceToken = m.Success ? m.Value.ToUpperInvariant() : "DOC";
        }
        var stem = Path.GetFileNameWithoutExtension(localPath);
        var hash = Sha256(localPath);
        return $"{Slug(sourceToken!)}-{Slug(stem)}-{hash[..8]}";
    }

    static string Slug(string value)
    {
        var s = Regex.Replace(value.Trim().ToLowerInvariant(), @"[^a-z0-9]+", "-").Trim('-');
        return string.IsNullOrWhiteSpace(s) ? "item" : s;
    }

    static string SafeFileName(string fileName)
    {
        var invalid = Path.GetInvalidFileNameChars();
        var sb = new StringBuilder(fileName.Length);
        foreach (var ch in fileName) sb.Append(invalid.Contains(ch) ? '_' : ch);
        return sb.ToString();
    }

    static string Sha256(string path)
    {
        using var fs = File.OpenRead(path);
        using var sha = SHA256.Create();
        return Convert.ToHexString(sha.ComputeHash(fs)).ToLowerInvariant();
    }

    static List<string> SplitSentences(string text)
    {
        var normalized = NormalizeWhitespace(text);
        if (string.IsNullOrWhiteSpace(normalized)) return [];
        return Regex.Split(normalized, @"(?<=[\.\!\?;])\s+")
            .Select(x => x.Trim())
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .DefaultIfEmpty(normalized)
            .ToList();
    }

    static string NormalizeWhitespace(string value) => Regex.Replace(value ?? string.Empty, @"\s+", " ").Trim();

    static bool IsInformative(string text, string kind) =>
        !string.IsNullOrWhiteSpace(text)
        && kind is not "pdf_pending" and not "heading"
        && text != "<blank>"
        && text.Length >= 12;
    static bool IsNormative(string level) => level is "must" or "must_not" or "shall" or "should" or "may";

    static string NormativeLevel(string text)
    {
        if (Regex.IsMatch(text, @"\b(MUST NOT|SHALL NOT)\b")) return "must_not";
        if (Regex.IsMatch(text, @"\bMUST\b")) return "must";
        if (Regex.IsMatch(text, @"\bSHALL\b")) return "shall";
        if (Regex.IsMatch(text, @"\bSHOULD\b|\bRECOMMENDED\b")) return "should";
        if (Regex.IsMatch(text, @"\bMAY\b|\bOPTIONAL\b")) return "may";

        var s = text.ToLowerInvariant();
        if (Regex.IsMatch(s, @"\b(must not|shall not|cannot|can not|never)\b")) return "must_not";
        if (Regex.IsMatch(s, @"\bmust\b")) return "must";
        if (Regex.IsMatch(s, @"\bshall\b")) return "shall";
        if (Regex.IsMatch(s, @"\bshould\b|\brecommended\b")) return "should";
        if (Regex.IsMatch(s, @"\boptional\b")) return "may";
        return "none";
    }

    static List<string> Tags(string text, string kind)
    {
        var tags = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var s = text.ToLowerInvariant();
        if (kind == "heading") tags.Add("heading");
        if (kind == "table_cell") tags.Add("table");
        if (kind == "image_ref") tags.Add("image_artifact");
        if (s.Contains("grammar") || s.Contains("syntax") || s.Contains("abnf") || s.Contains("operator")) tags.Add("grammar");
        if (s.Contains("coerc") || s.Contains("convert") || s.Contains("type")) tags.Add("type_coercion");
        if (s.Contains("error") || s.Contains("#value") || s.Contains("#ref") || s.Contains("#n/a")) tags.Add("error_semantics");
        if (s.Contains("table") || s.Contains("structured reference") || s.Contains("listobject")) tags.Add("table_semantics");
        if (s.Contains("rtd") || s.Contains("volatile") || s.Contains("recalc") || s.Contains("external")) tags.Add("recalc_external");
        if (s.Contains("format") || s.Contains("number format") || s.Contains("conditional format")) tags.Add("formatting");
        if (s.Contains("compat") || s.Contains("version") || s.Contains("channel")) tags.Add("versioning");
        if (s.Contains("intellectual property rights notice")
            || s.Contains("trademarks")
            || s.Contains("no trade secrets")
            || s.Contains("reservation of rights")
            || s.Contains("license programs")
            || s.Contains("patents")
            || s.Contains("copyright")
            || s.Contains("no association with any real company"))
        {
            tags.Add("legal_notice");
        }
        if (s.Contains("these terms (in all caps) are used as defined in [rfc2119]")
            || s.Contains("all statements of optional behavior use either may"))
        {
            tags.Add("editorial_meta");
        }
        return tags.OrderBy(x => x, StringComparer.OrdinalIgnoreCase).ToList();
    }

    static string Priority(string level) => level switch
    {
        "must" or "must_not" or "shall" => "high",
        "should" => "medium",
        "may" => "low",
        _ => "low"
    };

    static string VerificationHint(List<string> tags)
    {
        if (tags.Contains("grammar")) return "parser_acceptance_corpus";
        if (tags.Contains("type_coercion")) return "coercion_truth_table_probe";
        if (tags.Contains("table_semantics")) return "table_mutation_probe";
        if (tags.Contains("recalc_external")) return "recalc_external_signal_probe";
        if (tags.Contains("formatting")) return "format_render_probe";
        return "doc_to_probe_mapping_review";
    }

    static bool TryGetConformanceExclusionReason(string text, List<string> topicTags, out string reason)
    {
        var s = text.ToLowerInvariant();
        if (topicTags.Contains("legal_notice", StringComparer.OrdinalIgnoreCase))
        {
            reason = "legal_notice";
            return true;
        }
        if (s.Contains("these terms (in all caps) are used as defined in [rfc2119]"))
        {
            reason = "normative_keyword_definition";
            return true;
        }
        if (s.StartsWith("all statements of optional behavior use either may", StringComparison.OrdinalIgnoreCase))
        {
            reason = "normative_keyword_definition";
            return true;
        }
        if (s.Contains("individual documents in the library are not updated at the same time")
            || s.Contains("section numbers in the documents may not match"))
        {
            reason = "document_library_metadata";
            return true;
        }

        reason = string.Empty;
        return false;
    }

    static bool TryGetSpecExclusionReason(string text, List<string> topicTags, out string reason)
    {
        var s = text.ToLowerInvariant();
        if (topicTags.Contains("legal_notice", StringComparer.OrdinalIgnoreCase))
        {
            reason = "legal_notice";
            return true;
        }
        if (s.Contains("intellectual property rights notice")
            || s.Contains("all rights reserved")
            || s.Contains("contact dochelp@microsoft.com"))
        {
            reason = "legal_or_support_meta";
            return true;
        }

        reason = string.Empty;
        return false;
    }

    static string BuildRunReadme(dynamic manifest, List<DocSummary> summaries, IReadOnlyDictionary<string, int> excludedByReason)
    {
        var sb = new StringBuilder();
        sb.AppendLine("# Processed Spec Run");
        sb.AppendLine();
        sb.AppendLine($"- Run ID: `{manifest.run_id}`");
        sb.AppendLine($"- Captured UTC: `{manifest.captured_utc}`");
        sb.AppendLine($"- Documents processed: `{manifest.docs_processed}`");
        sb.AppendLine($"- Segment count: `{manifest.segments}`");
        sb.AppendLine($"- Sentence count: `{manifest.sentences}`");
        sb.AppendLine($"- Spec items: `{manifest.spec_items}`");
        sb.AppendLine($"- Conformance candidates: `{manifest.conformance_candidates}`");
        sb.AppendLine($"- Conformance excluded: `{manifest.conformance_excluded}`");
        sb.AppendLine($"- Pending items: `{manifest.pending_items}`");
        sb.AppendLine();
        sb.AppendLine("## Pending Extraction");
        sb.AppendLine();
        var pending = summaries.Where(x => x.PendingCount > 0 || x.ExtractionStatus != "ok").ToList();
        if (pending.Count == 0) sb.AppendLine("- None");
        else foreach (var p in pending) sb.AppendLine($"- `{p.DocumentId}` status=`{p.ExtractionStatus}` pending=`{p.PendingCount}` mode=`{p.ExtractionMode}`");
        sb.AppendLine();
        sb.AppendLine("## Excluded Conformance Reasons");
        sb.AppendLine();
        if (excludedByReason.Count > 0)
        {
            foreach (var kv in excludedByReason.OrderByDescending(x => x.Value)) sb.AppendLine($"- `{kv.Key}`: `{kv.Value}`");
        }
        else
        {
            sb.AppendLine("- None");
        }
        return sb.ToString();
    }

    static Dictionary<string, object?> ToolingInfo() => new()
    {
        ["runner_name"] = "SpecPackProcessor",
        ["runner_version"] = typeof(Program).Assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion
            ?? typeof(Program).Assembly.GetName().Version?.ToString() ?? "0.0.0",
        ["runner_build_version"] = typeof(Program).Assembly.GetName().Version?.ToString() ?? "0.0.0",
        ["platform"] = Environment.OSVersion.ToString(),
        ["dotnet_runtime"] = Environment.Version.ToString(),
        ["working_directory"] = Directory.GetCurrentDirectory(),
        ["invocation_working_directory"] = InvocationCwd,
        ["git_commit"] = Git("rev-parse HEAD"),
        ["git_branch"] = Git("rev-parse --abbrev-ref HEAD"),
        ["git_dirty"] = !string.IsNullOrWhiteSpace(Git("status --porcelain"))
    };

    static string? Git(string args)
    {
        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = "git",
                Arguments = args,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true
            };
            using var p = Process.Start(psi);
            if (p is null) return null;
            var outText = p.StandardOutput.ReadToEnd().Trim();
            p.WaitForExit(3000);
            return p.ExitCode == 0 ? outText : null;
        }
        catch { return null; }
    }

    static string ResolvePath(string input) => Path.IsPathRooted(input) ? Path.GetFullPath(input) : Path.GetFullPath(Path.Combine(InvocationCwd, input));
    static string Utc() => DateTime.UtcNow.ToString("O", CultureInfo.InvariantCulture);
    static int Fail(string msg) { Console.Error.WriteLine(msg); return 1; }

    static void WriteJson<T>(string path, T value)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        File.WriteAllText(path, JsonSerializer.Serialize(value, JsonIndented), Encoding.UTF8);
    }

    static void WriteJsonl<T>(string path, IEnumerable<T> values)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        using var w = new StreamWriter(path, false, new UTF8Encoding(false));
        foreach (var v in values) w.WriteLine(JsonSerializer.Serialize(v, JsonCompact));
    }

    static void WriteCsv(string path, string[] headers, IEnumerable<string[]> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path)!);
        using var w = new StreamWriter(path, false, new UTF8Encoding(false));
        w.WriteLine(string.Join(',', headers.Select(CsvEscape)));
        foreach (var row in rows) w.WriteLine(string.Join(',', row.Select(CsvEscape)));
    }

    static void WriteSelectedSourcesCsv(string path, IEnumerable<IndexRow> rows)
    {
        WriteCsv(
            path,
            ["source_id", "source_url", "local_path", "kind", "status", "sha256"],
            rows.Select(r => new[]
            {
                r.SourceId ?? string.Empty,
                r.SourceUrl ?? string.Empty,
                r.LocalPath ?? string.Empty,
                r.Kind ?? string.Empty,
                r.Status ?? string.Empty,
                r.Sha256 ?? string.Empty
            }));
    }

    static string CsvEscape(string value)
    {
        if (value.Contains(',') || value.Contains('"') || value.Contains('\n') || value.Contains('\r'))
            return $"\"{value.Replace("\"", "\"\"")}\"";
        return value;
    }

    static string[] ParseCsvLine(string line)
    {
        var cells = new List<string>();
        var sb = new StringBuilder();
        bool inQuotes = false;
        for (int i = 0; i < line.Length; i++)
        {
            var ch = line[i];
            if (inQuotes)
            {
                if (ch == '"')
                {
                    if (i + 1 < line.Length && line[i + 1] == '"') { sb.Append('"'); i++; }
                    else inQuotes = false;
                }
                else sb.Append(ch);
            }
            else
            {
                if (ch == ',') { cells.Add(sb.ToString()); sb.Clear(); }
                else if (ch == '"') inQuotes = true;
                else sb.Append(ch);
            }
        }
        cells.Add(sb.ToString());
        return cells.ToArray();
    }

    sealed class IndexRow
    {
        public string? SourceId { get; init; }
        public string? SourceUrl { get; init; }
        public string? LocalPath { get; init; }
        public string? Kind { get; init; }
        public string? Status { get; init; }
        public string? Sha256 { get; init; }
    }

    sealed class ExtractResult
    {
        public string ExtractionStatus { get; set; } = "ok";
        public string ExtractionMode { get; set; } = "unknown";
        public string? Notes { get; set; }
        public int TableCount { get; set; }
        public int ImageCount { get; set; }
        public int PendingCount { get; set; }
        public List<SegmentDraft> Segments { get; } = [];
    }

    sealed class SegmentDraft
    {
        public required string Kind { get; init; }
        public required string Text { get; init; }
        public string? Anchor { get; init; }
        public int? Page { get; init; }
        public int? Table { get; init; }
        public int? Row { get; init; }
        public int? Column { get; init; }
        public bool IsBlank { get; init; }
        public string? RelationshipId { get; init; }
        public string? ExtractedImagePath { get; init; }
    }

    sealed class SourceRef
    {
        public string? SourceId { get; init; }
        public string? SourceUrl { get; init; }
        public string? LocalPath { get; init; }
        public string? Anchor { get; init; }
        public int? Page { get; init; }
        public int? Table { get; init; }
        public int? Row { get; init; }
        public int? Column { get; init; }
        public string? RelationshipId { get; init; }
        public string? ExtractedImagePath { get; init; }
    }

    sealed class SegmentRecord
    {
        public required string SegmentId { get; init; }
        public required string DocumentId { get; init; }
        public required string Kind { get; init; }
        public required string Text { get; init; }
        public bool IsBlank { get; init; }
        public required SourceRef Source { get; init; }
    }

    sealed class SentenceRecord
    {
        public required string SentenceId { get; init; }
        public required string SegmentId { get; init; }
        public required string DocumentId { get; init; }
        public required string Text { get; init; }
        public required bool Informative { get; init; }
        public required string NormativeLevel { get; init; }
        public required List<string> TopicTags { get; init; }
        public required string ClassificationSource { get; init; }
        public required SourceRef Source { get; init; }
    }

    sealed class ConformanceItem
    {
        public required string ItemId { get; init; }
        public required string DocumentId { get; init; }
        public required string SourceSentenceId { get; init; }
        public required string Priority { get; init; }
        public required string NormativeLevel { get; init; }
        public required string Statement { get; init; }
        public required List<string> TopicTags { get; init; }
        public required string VerificationHint { get; init; }
        public required string Status { get; init; }
        public required SourceRef Source { get; init; }
    }

    sealed class SpecItem
    {
        public required string ItemId { get; init; }
        public required string DocumentId { get; init; }
        public required string SourceSentenceId { get; init; }
        public required string SpecLevel { get; init; }
        public required string Statement { get; init; }
        public required List<string> TopicTags { get; init; }
        public required string Status { get; init; }
        public required SourceRef Source { get; init; }
    }

    sealed class ExcludedConformanceItem
    {
        public required string ItemId { get; init; }
        public required string DocumentId { get; init; }
        public required string SourceSentenceId { get; init; }
        public required string NormativeLevel { get; init; }
        public required string Statement { get; init; }
        public required List<string> TopicTags { get; init; }
        public required string ExclusionReason { get; init; }
        public required string Status { get; init; }
        public required SourceRef Source { get; init; }
    }

    sealed class DocSummary
    {
        public required string DocumentId { get; init; }
        public required string SourceId { get; init; }
        public required string SourceUrl { get; init; }
        public required string LocalPath { get; init; }
        public required string Sha256 { get; init; }
        public required string ExtractionStatus { get; init; }
        public required string ExtractionMode { get; init; }
        public required int SegmentCount { get; init; }
        public required int SentenceCount { get; init; }
        public required int SpecItemCount { get; init; }
        public required int ConformanceCount { get; init; }
        public required int ExcludedConformanceCount { get; init; }
        public required int ImageCount { get; init; }
        public required int TableCount { get; init; }
        public required int PendingCount { get; init; }
        public string? Notes { get; init; }
    }
}
