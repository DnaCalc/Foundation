[CmdletBinding()]
param(
    [string]$SourceMatrixPath = "research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/platform_availability_source_matrix_full_interest_seed.csv",
    [string]$ExistingAvailabilityMatrixPath = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/platform_availability/function_availability_matrix.csv",
    [string]$OutSourceMatrixPath = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/platform_availability/source_matrix_full_interest_enriched.csv",
    [string]$OutAvailabilityMatrixPath = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/platform_availability/function_availability_matrix.csv",
    [string]$OutFailuresPath = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/platform_availability/ECS-EB-037_extraction_failures.csv",
    [string]$OutReportPath = "research/runs/20260228-180047-excel-compat-empirical-pass-01/outputs/platform_availability/ECS-EB-037_EXECUTION_REPORT.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Normalize-Text {
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
    $decoded = [System.Net.WebUtility]::HtmlDecode($Text)
    $stripped = [regex]::Replace($decoded, '<[^>]+>', ' ')
    $normalized = [regex]::Replace($stripped, '\s+', ' ').Trim()
    if ([string]::IsNullOrWhiteSpace($normalized)) { return $null }
    return $normalized
}

function Get-AppliesToTokens {
    param([string]$Html)

    $tokens = New-Object System.Collections.Generic.List[string]

    $spanPattern = '<span[^>]*class\s*=\s*"[^"]*\bappliesToItem\b[^"]*"[^>]*>(.*?)</span>'
    $spanMatches = [regex]::Matches($Html, $spanPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline)
    foreach ($m in $spanMatches) {
        $token = Normalize-Text -Text $m.Groups[1].Value
        if ($token) { [void]$tokens.Add($token) }
    }

    if ($tokens.Count -eq 0) {
        $sectionPattern = '<section[^>]*class\s*=\s*"[^"]*\bsupAppliesToSection\b[^"]*"[^>]*>(.*?)</section>'
        $sectionMatch = [regex]::Match($Html, $sectionPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($sectionMatch.Success) {
            $sectionHtml = $sectionMatch.Groups[1].Value
            $itemPattern = '(<a[^>]*>(.*?)</a>)|(<span[^>]*role\s*=\s*"listitem"[^>]*>(.*?)</span>)'
            $itemMatches = [regex]::Matches($sectionHtml, $itemPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline)
            foreach ($m in $itemMatches) {
                $candidate = if ($m.Groups[2].Success) { $m.Groups[2].Value } else { $m.Groups[4].Value }
                $token = Normalize-Text -Text $candidate
                if ($token -and $token -ne 'Applies To') { [void]$tokens.Add($token) }
            }
        }
    }

    $seen = @{}
    $deduped = New-Object System.Collections.Generic.List[string]
    foreach ($t in $tokens) {
        if (-not $seen.ContainsKey($t)) {
            $seen[$t] = $true
            [void]$deduped.Add($t)
        }
    }
    return $deduped
}

function Fetch-AppliesTo {
    param(
        [string]$Url,
        [int]$MaxAttempts = 3
    )

    $candidateUrls = New-Object System.Collections.Generic.List[string]
    [void]$candidateUrls.Add($Url)
    if ($Url -match '/en-us/') {
        foreach ($locale in @('en-gb', 'en-au')) {
            [void]$candidateUrls.Add(($Url -replace '/en-us/', "/$locale/"))
        }
    }

    $errors = New-Object System.Collections.Generic.List[string]
    foreach ($candidateUrl in $candidateUrls) {
        $lastError = $null
        for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
            try {
                $response = Invoke-WebRequest -UseBasicParsing -Uri $candidateUrl -Headers @{ 'User-Agent' = 'DnaCalc-Foundation-ECS-EB-037/1.0' }
                $tokens = @(Get-AppliesToTokens -Html $response.Content)
                if ($tokens.Count -gt 0) {
                    return [pscustomobject]@{
                        success = $true
                        tokens = $tokens
                        error = ''
                        url_used = $candidateUrl
                    }
                }
                $lastError = 'No applies-to tokens found in page markup.'
            }
            catch {
                $lastError = $_.Exception.Message
            }
            Start-Sleep -Milliseconds (500 * $attempt)
        }

        if ($lastError) {
            [void]$errors.Add("$candidateUrl => $lastError")
        }
    }

    return [pscustomobject]@{
        success = $false
        tokens = @()
        error = ($errors -join ' || ')
        url_used = ''
    }
}

$sourceRows = Import-Csv -Path $SourceMatrixPath
$carryRows = @($sourceRows | Where-Object { $_.applies_to_raw -ne '__PENDING_CAPTURE__' })
$pendingGroups = @($sourceRows | Where-Object { $_.applies_to_raw -eq '__PENDING_CAPTURE__' } | Group-Object function_name)

$runUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$expandedRows = New-Object System.Collections.Generic.List[object]
$failureRows = New-Object System.Collections.Generic.List[object]

foreach ($row in $carryRows) {
    [void]$expandedRows.Add($row)
}

foreach ($g in $pendingGroups) {
    $seed = $g.Group | Select-Object -First 1
    $fetch = Fetch-AppliesTo -Url $seed.source_url
    if ($fetch.success) {
        $note = if ($fetch.url_used -eq $seed.source_url) {
            'Applies-to extracted by ECS-EB-037 crawler.'
        }
        else {
            "Applies-to extracted by ECS-EB-037 crawler via fallback URL: $($fetch.url_used)"
        }

        foreach ($token in $fetch.tokens) {
            [void]$expandedRows.Add([pscustomobject]@{
                function_name = $seed.function_name
                source_title = $seed.source_title
                source_url = $seed.source_url
                applies_to_raw = $token
                source_capture_utc = $runUtc
                evidence_type = 'source_only'
                probe_status = 'pending'
                note = $note
            })
        }
    }
    else {
        [void]$expandedRows.Add([pscustomobject]@{
            function_name = $seed.function_name
            source_title = $seed.source_title
            source_url = $seed.source_url
            applies_to_raw = '__EXTRACTION_FAILED__'
            source_capture_utc = $runUtc
            evidence_type = 'source_only'
            probe_status = 'pending'
            note = "Applies-to extraction failed: $($fetch.error)"
        })

        [void]$failureRows.Add([pscustomobject]@{
            function_name = $seed.function_name
            source_url = $seed.source_url
            error = $fetch.error
            capture_utc = $runUtc
        })
    }
}

$sortedExpanded = $expandedRows | Sort-Object function_name, applies_to_raw
$outSourceDir = Split-Path -Path $OutSourceMatrixPath -Parent
if ($outSourceDir) { New-Item -ItemType Directory -Path $outSourceDir -Force | Out-Null }
$sortedExpanded | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $OutSourceMatrixPath

if ($failureRows.Count -gt 0) {
    $failureRows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $OutFailuresPath
}
else {
    if (Test-Path -LiteralPath $OutFailuresPath) { Remove-Item -LiteralPath $OutFailuresPath -Force }
}

$existingMatrix = @()
if (Test-Path -LiteralPath $ExistingAvailabilityMatrixPath) {
    $existingMatrix = Import-Csv -Path $ExistingAvailabilityMatrixPath
}

$existingByFunction = @{}
foreach ($row in $existingMatrix) {
    $existingByFunction[$row.function_name] = $row
}

function Get-MaxCaptureUtc {
    param([object[]]$Rows, [string]$Fallback)
    $times = @(foreach ($r in $Rows) {
        try {
            [DateTime]::Parse($r.source_capture_utc).ToUniversalTime()
        }
        catch {
            $null
        }
    })
    if ($times.Count -eq 0) { return $Fallback }
    return ($times | Sort-Object | Select-Object -Last 1).ToString('yyyy-MM-ddTHH:mm:ssZ')
}

$availabilityRows = New-Object System.Collections.Generic.List[object]
$groups = $sortedExpanded | Group-Object function_name
foreach ($group in $groups) {
    $functionName = $group.Name
    $rows = $group.Group
    $first = $rows | Select-Object -First 1

    $tokens = @($rows | Where-Object { $_.applies_to_raw -and $_.applies_to_raw -ne '__PENDING_CAPTURE__' -and $_.applies_to_raw -ne '__EXTRACTION_FAILED__' } | Select-Object -ExpandProperty applies_to_raw -Unique)
    $sourceApplies = if ($tokens.Count -gt 0) { ($tokens -join ' | ') } else { '__PENDING_CAPTURE__' }

    $hasFailure = @($rows | Where-Object { $_.applies_to_raw -eq '__EXTRACTION_FAILED__' }).Count -gt 0
    $sourceStatus = if ($hasFailure) { 'source_incomplete' } else { 'source_only' }

    $old = $null
    if ($existingByFunction.ContainsKey($functionName)) {
        $old = $existingByFunction[$functionName]
    }

    $oldNotes = if ($old) { [string]$old.notes } else { '' }
    $mergeNote = "ECS-EB-037 merge updated source applies-to at $runUtc"
    $preservedNotes = @()
    if (-not [string]::IsNullOrWhiteSpace($oldNotes)) {
        foreach ($segment in ($oldNotes -split '\s\|\s')) {
            $trimmed = $segment.Trim()
            if ([string]::IsNullOrWhiteSpace($trimmed)) { continue }
            if ($trimmed.StartsWith('ECS-EB-037 merge updated source applies-to at ')) { continue }
            if ($trimmed -eq 'source extraction incomplete') { continue }
            $preservedNotes += $trimmed
        }
    }

    $noteSegments = @($preservedNotes + $mergeNote)
    if ($hasFailure) { $noteSegments += 'source extraction incomplete' }
    $notes = (($noteSegments | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique) -join ' | ')

    [void]$availabilityRows.Add([pscustomobject]@{
        function_name = $functionName
        source_url = $first.source_url
        source_applies_to = $sourceApplies
        source_capture_utc = Get-MaxCaptureUtc -Rows $rows -Fallback $runUtc
        source_status = $sourceStatus
        windows_desktop_status = if ($old) { $old.windows_desktop_status } else { 'unprobed' }
        mac_desktop_status = if ($old) { $old.mac_desktop_status } else { 'unprobed' }
        web_status = if ($old) { $old.web_status } else { 'unprobed' }
        mobile_status = if ($old) { $old.mobile_status } else { 'unprobed' }
        probe_status = if ($old) { $old.probe_status } else { 'queued' }
        last_probe_utc = if ($old) { $old.last_probe_utc } else { '' }
        evidence_bundle_ref = if ($old) { $old.evidence_bundle_ref } else { '' }
        notes = $notes
    })
}

$sortedAvailability = $availabilityRows | Sort-Object function_name
$outAvailDir = Split-Path -Path $OutAvailabilityMatrixPath -Parent
if ($outAvailDir) { New-Item -ItemType Directory -Path $outAvailDir -Force | Out-Null }
$sortedAvailability | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $OutAvailabilityMatrixPath

$completedFunctions = ($pendingGroups | Where-Object {
    $fn = $_.Name
    -not ($failureRows | Where-Object { $_.function_name -eq $fn })
}).Count

$failureStateNote = if ($failureRows.Count -eq 0) {
    'No rows are marked source_incomplete in the merged availability matrix.'
}
else {
    'Functions with extraction failures remain marked source_incomplete in the merged availability matrix.'
}

$report = @"
# ECS-EB-037 Execution Report

- Run UTC: $runUtc
- Source seed: $SourceMatrixPath
- Enriched source matrix: $OutSourceMatrixPath
- Availability matrix updated: $OutAvailabilityMatrixPath

## Summary
- Functions in source seed: $((($sourceRows | Select-Object -ExpandProperty function_name -Unique)).Count)
- Pending functions before run: $($pendingGroups.Count)
- Pending functions resolved this run: $completedFunctions
- Extraction failures: $($failureRows.Count)

## Notes
- Applies-to extraction uses Microsoft Support function pages (supAppliesToSection / appliesToItem).
- Existing probe-status columns were preserved from the prior availability matrix where present.
- $failureStateNote
"@

$report | Set-Content -Encoding UTF8 -Path $OutReportPath

Write-Host "ECS-EB-037 completed. Pending groups: $($pendingGroups.Count). Failures: $($failureRows.Count)."
