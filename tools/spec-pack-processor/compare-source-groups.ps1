param(
    [Parameter(Mandatory=$true)]
    [string]$RunOutputsDir,
    [string[]]$OfficialSourceIds = @('MS-VBAL','discovered'),
    [string[]]$ReferenceSourceIds = @('VBA-API-OVERVIEW','VBA-FUNCTIONS','VBA-LANG-UIHELP'),
    [string]$OfficialUrlContains = 'MS-VBAL'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$OfficialSourceIds = @($OfficialSourceIds | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
$ReferenceSourceIds = @($ReferenceSourceIds | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

$docsPath = Join-Path $RunOutputsDir 'documents.csv'
$specPath = Join-Path $RunOutputsDir 'spec_items.jsonl'
$conformancePath = Join-Path $RunOutputsDir 'conformance_items.jsonl'

if (-not (Test-Path $docsPath)) { throw "Missing: $docsPath" }
if (-not (Test-Path $specPath)) { throw "Missing: $specPath" }
if (-not (Test-Path $conformancePath)) { throw "Missing: $conformancePath" }

$docs = Import-Csv $docsPath
$spec = Get-Content $specPath | ForEach-Object { $_ | ConvertFrom-Json }
$conformance = Get-Content $conformancePath | ForEach-Object { $_ | ConvertFrom-Json }

function Normalize-Statement {
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
    $x = $Text.ToLowerInvariant()
    $x = [regex]::Replace($x, '\s+', ' ')
    $x = [regex]::Replace($x, '[^a-z0-9 ]', '')
    $x = $x.Trim()
    if ($x.Length -eq 0) { return $null }
    return $x
}

function New-SetFromRows {
    param($Rows)
    $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($row in $Rows) {
        $norm = Normalize-Statement -Text $row.statement
        if ($null -ne $norm) { [void]$set.Add($norm) }
    }
    return $set
}

function Compare-Sets {
    param(
        [System.Collections.Generic.HashSet[string]]$A,
        [System.Collections.Generic.HashSet[string]]$B
    )

    if ($null -eq $A) { $A = [System.Collections.Generic.HashSet[string]]::new() }
    if ($null -eq $B) { $B = [System.Collections.Generic.HashSet[string]]::new() }

    $inter = 0
    foreach ($x in $A) {
        if ($B.Contains($x)) { $inter++ }
    }

    $union = [Math]::Max(1, $A.Count + $B.Count - $inter)

    return [PSCustomObject]@{
        a = $A.Count
        b = $B.Count
        intersection = $inter
        a_only = $A.Count - $inter
        b_only = $B.Count - $inter
        jaccard = [Math]::Round(($inter / [double]$union), 4)
        a_covered_by_b = [Math]::Round(($inter / [double][Math]::Max(1, $A.Count)), 4)
        b_covered_by_a = [Math]::Round(($inter / [double][Math]::Max(1, $B.Count)), 4)
    }
}

$officialDocIds = @(
    $docs |
        Where-Object { $_.source_id -in $OfficialSourceIds -or $_.source_url -like "*$OfficialUrlContains*" } |
        Select-Object -ExpandProperty document_id
)

$referenceDocIds = @(
    $docs |
        Where-Object { $_.source_id -in $ReferenceSourceIds } |
        Select-Object -ExpandProperty document_id
)

$officialSpecSet = New-SetFromRows ($spec | Where-Object { $_.document_id -in $officialDocIds })
$referenceSpecSet = New-SetFromRows ($spec | Where-Object { $_.document_id -in $referenceDocIds })
$officialConfSet = New-SetFromRows ($conformance | Where-Object { $_.document_id -in $officialDocIds })
$referenceConfSet = New-SetFromRows ($conformance | Where-Object { $_.document_id -in $referenceDocIds })

$metrics = [PSCustomObject]@{
    generated_utc = (Get-Date).ToUniversalTime().ToString('o')
    official_doc_ids = $officialDocIds
    reference_doc_ids = $referenceDocIds
    official_vs_reference_spec = Compare-Sets -A $officialSpecSet -B $referenceSpecSet
    official_vs_reference_conformance = Compare-Sets -A $officialConfSet -B $referenceConfSet
}

$metricsPath = Join-Path $RunOutputsDir 'comparison_metrics.json'
$reportPath = Join-Path $RunOutputsDir 'comparison_report.md'

$metrics | ConvertTo-Json -Depth 6 | Out-File -FilePath $metricsPath -Encoding utf8

$report = @()
$report += '# Source Comparison Report'
$report += ''
$report += ("- Generated UTC: {0}" -f $metrics.generated_utc)
$report += ("- Official docs: {0}" -f $officialDocIds.Count)
$report += ("- Reference docs: {0}" -f $referenceDocIds.Count)
$report += ''
$report += '## Spec Items'
$report += ("- Official unique normalized spec items: {0}" -f $metrics.official_vs_reference_spec.a)
$report += ("- Reference unique normalized spec items: {0}" -f $metrics.official_vs_reference_spec.b)
$report += ("- Intersection: {0}" -f $metrics.official_vs_reference_spec.intersection)
$report += ("- Jaccard: {0}" -f $metrics.official_vs_reference_spec.jaccard)
$report += ("- Official covered by reference: {0}" -f $metrics.official_vs_reference_spec.a_covered_by_b)
$report += ("- Reference covered by official: {0}" -f $metrics.official_vs_reference_spec.b_covered_by_a)
$report += ''
$report += '## Conformance Items'
$report += ("- Official unique normalized conformance items: {0}" -f $metrics.official_vs_reference_conformance.a)
$report += ("- Reference unique normalized conformance items: {0}" -f $metrics.official_vs_reference_conformance.b)
$report += ("- Intersection: {0}" -f $metrics.official_vs_reference_conformance.intersection)
$report += ("- Jaccard: {0}" -f $metrics.official_vs_reference_conformance.jaccard)
$report += ("- Official covered by reference: {0}" -f $metrics.official_vs_reference_conformance.a_covered_by_b)
$report += ("- Reference covered by official: {0}" -f $metrics.official_vs_reference_conformance.b_covered_by_a)

$report -join "`n" | Out-File -FilePath $reportPath -Encoding utf8

Write-Host "Wrote: $metricsPath"
Write-Host "Wrote: $reportPath"
