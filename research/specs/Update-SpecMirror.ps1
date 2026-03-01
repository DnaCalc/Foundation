param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$specRoot = Join-Path $RepoRoot "research\specs"
$downloadsRoot = Join-Path $specRoot "downloads"
$seedPath = Join-Path $specRoot "spec_seeds.csv"
$indexCsvPath = Join-Path $specRoot "index.csv"
$indexMdPath = Join-Path $specRoot "index.md"

if (-not (Test-Path $seedPath)) {
    throw "Seed file not found: $seedPath"
}

New-Item -Path $downloadsRoot -ItemType Directory -Force | Out-Null

$runUtc = (Get-Date).ToUniversalTime()
$runId = $runUtc.ToString("yyyyMMdd-HHmmssZ")
$userAgent = "DnaCalc-SpecMirror/1.0"
$script:LatestDatedArtifactByKey = @{}

function Convert-ToBool {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    return $Value.Trim().ToLowerInvariant() -in @("1", "true", "yes", "y")
}

function Normalize-Url {
    param([string]$Url)
    if ([string]::IsNullOrWhiteSpace($Url)) { return $null }
    try {
        $uri = [Uri]$Url
        $builder = [UriBuilder]::new($uri)
        $builder.Fragment = ""
        if ($builder.Path -eq "") { $builder.Path = "/" }
        return $builder.Uri.AbsoluteUri.TrimEnd("/")
    }
    catch {
        return $null
    }
}

function Ensure-MarkdownUrl {
    param([string]$Url)
    if ($Url -notmatch "learn\.microsoft\.com/.*/openspecs/") {
        return $Url
    }
    if ($Url -match "accept=text/markdown") {
        return $Url
    }
    if ($Url.Contains("?")) {
        return "${Url}&accept=text/markdown"
    }
    return "${Url}?accept=text/markdown"
}

function Resolve-RelativeLink {
    param(
        [string]$BaseUrl,
        [string]$LinkValue
    )
    if ([string]::IsNullOrWhiteSpace($LinkValue)) { return $null }
    $trimmed = $LinkValue.Trim()
    if ($trimmed -match "^https?://") {
        return (Normalize-Url -Url $trimmed)
    }
    if ($trimmed.StartsWith("../")) {
        try {
            $resolved = [Uri]::new([Uri]$BaseUrl, $trimmed)
            return (Normalize-Url -Url $resolved.AbsoluteUri)
        }
        catch {
            return $null
        }
    }
    return $null
}

function Extract-LinksFromMarkdown {
    param([string]$Markdown)
    $out = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($m in [Regex]::Matches($Markdown, "https?://[^\s\)\]""'<>]+")) {
        $candidate = $m.Value.Trim().TrimEnd(".", ",", ";", ":")
        [void]$out.Add($candidate)
    }

    foreach ($m in [Regex]::Matches($Markdown, "\.\./[A-Za-z0-9\-_]+/[A-Za-z0-9\-_]+(?:#[A-Za-z0-9\-_]+)?")) {
        [void]$out.Add($m.Value)
    }

    return @($out)
}

function Make-SafeSegment {
    param([string]$Segment)
    $safe = $Segment
    foreach ($c in [IO.Path]::GetInvalidFileNameChars()) {
        $safe = $safe.Replace([string]$c, "_")
    }
    if ([string]::IsNullOrWhiteSpace($safe)) { return "_" }
    return $safe
}

function Get-LocalPathForUrl {
    param(
        [string]$Url,
        [bool]$AsMarkdownPage
    )
    $uri = [Uri]$Url
    $hostName = Make-SafeSegment -Segment $uri.Host.ToLowerInvariant()
    $segments = $uri.AbsolutePath.Trim("/") -split "/"
    if ($segments.Count -eq 1 -and [string]::IsNullOrWhiteSpace($segments[0])) {
        $segments = @("root")
    }

    $safeSegments = @()
    foreach ($segment in $segments) {
        $safeSegments += (Make-SafeSegment -Segment $segment)
    }

    if ($AsMarkdownPage) {
        $fileName = $safeSegments[-1] + ".md"
        if ($safeSegments.Count -gt 1) {
            $dirSegments = $safeSegments[0..($safeSegments.Count - 2)]
        }
        else {
            $dirSegments = @()
        }
    }
    else {
        $fileName = [Uri]::UnescapeDataString($safeSegments[-1])
        if ($safeSegments.Count -gt 1) {
            $dirSegments = $safeSegments[0..($safeSegments.Count - 2)]
        }
        else {
            $dirSegments = @()
        }
    }

    $targetDir = Join-Path $downloadsRoot $hostName
    foreach ($segment in $dirSegments) {
        $targetDir = Join-Path $targetDir $segment
    }
    New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
    return (Join-Path $targetDir $fileName)
}

function Write-FileAndGetMeta {
    param(
        [string]$Path,
        [object]$Content
    )
    if ($Content -is [byte[]]) {
        [IO.File]::WriteAllBytes($Path, $Content)
    }
    else {
        [IO.File]::WriteAllText($Path, [string]$Content, [Text.Encoding]::UTF8)
    }
    $item = Get-Item -LiteralPath $Path
    $hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
    return @{
        size_bytes = $item.Length
        sha256 = $hash
    }
}

function Get-FileMeta {
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path
    $hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
    return @{
        size_bytes = $item.Length
        sha256 = $hash
    }
}

function Is-OpenSpecsPageUrl {
    param([string]$Url)
    return $Url -match "^https://learn\.microsoft\.com/.*/openspecs/"
}

function Is-DownloadCandidateUrl {
    param([string]$Url)
    if (-not ($Url -match "^https?://")) { return $false }
    $hostName = ([Uri]$Url).Host.ToLowerInvariant()
    if ($hostName -notmatch "azurefd\.net|ecma-international\.org|oasis-open\.org|iso\.org|go\.microsoft\.com") {
        return $false
    }
    if ($Url -match "\.(pdf|docx|zip)(\?|$)") { return $true }
    return $false
}

function Get-DownloadStatus {
    param([string]$Url)
    if ($Url -match "Windows_Protocols\.zip") {
        return @{ status = "excluded_large_bundle"; note = "Large umbrella bundle not mirrored by default." }
    }
    if ($Url -match "/(?<spec>MS-[A-Z0-9]+)/(?:%5b|\[)(?<spec2>MS-[A-Z0-9]+)(?:%5d|\])-(?<date>\d{6})(?<suffix>-diff|-errata)?\.(?<ext>pdf|docx)($|\?)") {
        $suffix = if ($Matches.ContainsKey("suffix")) { $Matches["suffix"] } else { "" }
        if (-not [string]::IsNullOrWhiteSpace($suffix)) {
            return @{ status = "excluded_historical"; note = "Diff/errata artifact excluded." }
        }
        $key = "$($Matches.spec.ToUpperInvariant())|$($Matches.ext.ToLowerInvariant())"
        if ($script:LatestDatedArtifactByKey.ContainsKey($key) -and $script:LatestDatedArtifactByKey[$key] -eq $Url) {
            return @{ status = "include"; note = "Latest dated artifact for this spec/ext." }
        }
        return @{ status = "excluded_historical"; note = "Historical revision artifact (latest/current prioritized)." }
    }
    return @{ status = "include"; note = "" }
}

$rows = New-Object System.Collections.Generic.List[object]
$seenUrls = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$seedPageLinks = New-Object "System.Collections.Generic.Dictionary[string, string[]]"
$seedMarkdownCache = New-Object "System.Collections.Generic.Dictionary[string, string]"

$seeds = Import-Csv -Path $seedPath

foreach ($seed in $seeds) {
    $seedUrl = Normalize-Url -Url $seed.url
    if (-not $seedUrl) {
        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "seed"
                topic_group = $seed.topic_group
                source_id = $seed.seed_id
                source_url = $seed.url
                local_path = ""
                kind = "openspec_page"
                status = "failed"
                note = "Invalid seed URL."
                downloaded_utc = ""
                size_bytes = ""
                sha256 = ""
            })
        continue
    }

    $fetchUrl = Ensure-MarkdownUrl -Url $seedUrl
    try {
        $resp = Invoke-WebRequest -UseBasicParsing -Uri $fetchUrl -TimeoutSec 240 -Headers @{ "User-Agent" = $userAgent }
        $content = [string]$resp.Content
        $localPath = Get-LocalPathForUrl -Url $seedUrl -AsMarkdownPage $true
        $meta = Write-FileAndGetMeta -Path $localPath -Content $content
        $dlUtc = (Get-Date).ToUniversalTime().ToString("o")

        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "seed"
                topic_group = $seed.topic_group
                source_id = $seed.seed_id
                source_url = $seedUrl
                local_path = $localPath
                kind = "openspec_page"
                status = "downloaded"
                note = "Markdown mirror of seed page."
                downloaded_utc = $dlUtc
                size_bytes = $meta.size_bytes
                sha256 = $meta.sha256
            })
        [void]$seenUrls.Add($seedUrl)
        $seedMarkdownCache[$seed.seed_id] = $content

        $links = Extract-LinksFromMarkdown -Markdown $content
        $seedPageLinks[$seed.seed_id] = $links
    }
    catch {
        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "seed"
                topic_group = $seed.topic_group
                source_id = $seed.seed_id
                source_url = $seedUrl
                local_path = ""
                kind = "openspec_page"
                status = "failed"
                note = $_.Exception.Message
                downloaded_utc = ""
                size_bytes = ""
                sha256 = ""
            })
    }
}

$childPages = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($seed in $seeds) {
    if (-not (Convert-ToBool -Value $seed.expand_relative_openspecs)) { continue }
    if (-not $seedPageLinks.ContainsKey($seed.seed_id)) { continue }

    foreach ($rawLink in $seedPageLinks[$seed.seed_id]) {
        $resolved = Resolve-RelativeLink -BaseUrl $seed.url -LinkValue $rawLink
        if (-not $resolved) { continue }
        if (-not (Is-OpenSpecsPageUrl -Url $resolved)) { continue }
        [void]$childPages.Add($resolved)
    }
}

foreach ($pageUrl in ($childPages | Sort-Object)) {
    if ($seenUrls.Contains($pageUrl)) { continue }
    $fetchUrl = Ensure-MarkdownUrl -Url $pageUrl
    try {
        $resp = Invoke-WebRequest -UseBasicParsing -Uri $fetchUrl -TimeoutSec 240 -Headers @{ "User-Agent" = $userAgent }
        $content = [string]$resp.Content
        $localPath = Get-LocalPathForUrl -Url $pageUrl -AsMarkdownPage $true
        $meta = Write-FileAndGetMeta -Path $localPath -Content $content
        $dlUtc = (Get-Date).ToUniversalTime().ToString("o")

        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "expanded_child"
                topic_group = "office_standards"
                source_id = "MS-OFFSTANDLP"
                source_url = $pageUrl
                local_path = $localPath
                kind = "openspec_page"
                status = "downloaded"
                note = "Expanded from MS-OFFSTANDLP relative spec link."
                downloaded_utc = $dlUtc
                size_bytes = $meta.size_bytes
                sha256 = $meta.sha256
            })
        [void]$seenUrls.Add($pageUrl)

        $links = Extract-LinksFromMarkdown -Markdown $content
        $seedPageLinks["child::$pageUrl"] = $links
    }
    catch {
        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "expanded_child"
                topic_group = "office_standards"
                source_id = "MS-OFFSTANDLP"
                source_url = $pageUrl
                local_path = ""
                kind = "openspec_page"
                status = "failed"
                note = $_.Exception.Message
                downloaded_utc = ""
                size_bytes = ""
                sha256 = ""
            })
    }
}

$allDiscoveredLinks = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($entry in $seedPageLinks.GetEnumerator()) {
    foreach ($rawLink in $entry.Value) {
        if ($rawLink -match "^https?://") {
            $normalized = Normalize-Url -Url $rawLink
            if ($normalized) { [void]$allDiscoveredLinks.Add($normalized) }
        }
    }
}

foreach ($candidateUrl in $allDiscoveredLinks) {
    if ($candidateUrl -match "/(?<spec>MS-[A-Z0-9]+)/(?:%5b|\[)(?<spec2>MS-[A-Z0-9]+)(?:%5d|\])-(?<date>\d{6})(?<suffix>-diff|-errata)?\.(?<ext>pdf|docx)($|\?)") {
        $suffix = if ($Matches.ContainsKey("suffix")) { $Matches["suffix"] } else { "" }
        if (-not [string]::IsNullOrWhiteSpace($suffix)) { continue }
        $key = "$($Matches.spec.ToUpperInvariant())|$($Matches.ext.ToLowerInvariant())"
        $dateToken = $Matches.date
        if (-not $script:LatestDatedArtifactByKey.ContainsKey($key)) {
            $script:LatestDatedArtifactByKey[$key] = $candidateUrl
            continue
        }
        $existingUrl = $script:LatestDatedArtifactByKey[$key]
        if ($existingUrl -match "-(?<existingDate>\d{6})\.(pdf|docx)($|\?)") {
            if ($dateToken -gt $Matches.existingDate) {
                $script:LatestDatedArtifactByKey[$key] = $candidateUrl
            }
        }
    }
}

foreach ($downloadUrl in ($allDiscoveredLinks | Sort-Object)) {
    if (-not (Is-DownloadCandidateUrl -Url $downloadUrl)) { continue }

    $decision = Get-DownloadStatus -Url $downloadUrl
    if ($decision.status -ne "include") {
        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "discovered_download"
                topic_group = "mixed"
                source_id = "discovered"
                source_url = $downloadUrl
                local_path = ""
                kind = "download_artifact"
                status = $decision.status
                note = $decision.note
                downloaded_utc = ""
                size_bytes = ""
                sha256 = ""
            })
        continue
    }

    try {
        $localPath = Get-LocalPathForUrl -Url $downloadUrl -AsMarkdownPage $false
        Invoke-WebRequest -UseBasicParsing -Uri $downloadUrl -TimeoutSec 480 -Headers @{ "User-Agent" = $userAgent } -OutFile $localPath
        $meta = Get-FileMeta -Path $localPath
        $dlUtc = (Get-Date).ToUniversalTime().ToString("o")

        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "discovered_download"
                topic_group = "mixed"
                source_id = "discovered"
                source_url = $downloadUrl
                local_path = $localPath
                kind = "download_artifact"
                status = "downloaded"
                note = "Direct downloadable artifact mirror."
                downloaded_utc = $dlUtc
                size_bytes = $meta.size_bytes
                sha256 = $meta.sha256
            })
    }
    catch {
        $rows.Add([PSCustomObject]@{
                run_id = $runId
                source_scope = "discovered_download"
                topic_group = "mixed"
                source_id = "discovered"
                source_url = $downloadUrl
                local_path = ""
                kind = "download_artifact"
                status = "failed"
                note = $_.Exception.Message
                downloaded_utc = ""
                size_bytes = ""
                sha256 = ""
            })
    }
}

$orderedRows = $rows |
Sort-Object -Property @{ Expression = "kind"; Descending = $false }, @{ Expression = "status"; Descending = $false }, @{ Expression = "source_url"; Descending = $false }

$orderedRows | Export-Csv -Path $indexCsvPath -NoTypeInformation -Encoding UTF8

$statusGroups = $orderedRows | Group-Object -Property status | Sort-Object Name
$kindGroups = $orderedRows | Group-Object -Property kind | Sort-Object Name
$downloadedRows = $orderedRows | Where-Object { $_.status -eq "downloaded" }
$mustSeeds = $seeds | Where-Object { Convert-ToBool -Value $_.must_include }

$md = New-Object System.Text.StringBuilder
[void]$md.AppendLine("# Spec Mirror Index")
[void]$md.AppendLine("")
[void]$md.AppendLine("- Run ID: $runId")
[void]$md.AppendLine("- Run UTC: $($runUtc.ToString("yyyy-MM-dd HH:mm:ss 'UTC'"))")
[void]$md.AppendLine("- Seed file: research/specs/spec_seeds.csv")
[void]$md.AppendLine("")
[void]$md.AppendLine("## Status Counts")
[void]$md.AppendLine("")
foreach ($g in $statusGroups) {
    [void]$md.AppendLine("- $($g.Name): $($g.Count)")
}
[void]$md.AppendLine("")
[void]$md.AppendLine("## Kind Counts")
[void]$md.AppendLine("")
foreach ($g in $kindGroups) {
    [void]$md.AppendLine("- $($g.Name): $($g.Count)")
}
[void]$md.AppendLine("")
[void]$md.AppendLine("## Must-Include Seed Coverage")
[void]$md.AppendLine("")
foreach ($seed in $mustSeeds) {
    $seedUrl = Normalize-Url -Url $seed.url
    $row = $orderedRows | Where-Object { $_.kind -eq "openspec_page" -and $_.source_url -eq $seedUrl -and $_.status -eq "downloaded" } | Select-Object -First 1
    if ($null -ne $row) {
        [void]$md.AppendLine("- [$($seed.seed_id)]($seedUrl): mirrored at $($row.local_path) on $($row.downloaded_utc)")
    }
    else {
        [void]$md.AppendLine("- [$($seed.seed_id)]($seedUrl): NOT mirrored (check failures in index.csv)")
    }
}
[void]$md.AppendLine("")
[void]$md.AppendLine("## Downloaded Files")
[void]$md.AppendLine("")
[void]$md.AppendLine("| Kind | URL | Local Path | Downloaded UTC | Size (bytes) |")
[void]$md.AppendLine("| --- | --- | --- | --- | --- |")
foreach ($row in $downloadedRows) {
    $url = $row.source_url.Replace("|", "%7C")
    $local = $row.local_path.Replace("|", "%7C")
    [void]$md.AppendLine("| $($row.kind) | $url | $local | $($row.downloaded_utc) | $($row.size_bytes) |")
}

[IO.File]::WriteAllText($indexMdPath, $md.ToString(), [Text.Encoding]::UTF8)

Write-Host "Spec mirror update complete."
Write-Host "Run ID: $runId"
Write-Host "Index CSV: $indexCsvPath"
Write-Host "Index MD : $indexMdPath"
Write-Host "Downloaded items: $(@($downloadedRows).Count)"
