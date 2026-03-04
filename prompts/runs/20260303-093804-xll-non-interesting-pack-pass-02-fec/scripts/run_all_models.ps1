param(
  [string]$RunDir
)

$ErrorActionPreference = 'Stop'
$promptPath = Join-Path $RunDir 'inputs/prompt_base.md'
$prompt = Get-Content -Path $promptPath -Raw
$logsDir = Join-Path $RunDir 'logs'
$respDir = Join-Path $RunDir 'responses'

function Extract-Response {
  param(
    [string]$Raw,
    [string]$Model
  )
  if ($Model -eq 'codex') {
    if ($Raw -match "(?s)\ncodex\r?\n(.*)") { return $Matches[1].Trim() }
    return $Raw.Trim()
  }
  if ($Model -eq 'claude') {
    if ($Raw -match "(?s)(# .*|## .*|1\. .*|Scope.*)") { return $Matches[1].Trim() }
    return $Raw.Trim()
  }
  if ($Model -eq 'gemini') {
    if ($Raw -match "(?s)(# .*|## .*|1\. .*|Scope.*)") { return $Matches[1].Trim() }
    return $Raw.Trim()
  }
  return $Raw.Trim()
}

$modelRuns = @()

# Codex
$ts = [DateTime]::UtcNow.ToString('o')
$log1 = Join-Path $logsDir '01_codex_base.log'
$resp1 = Join-Path $respDir '01_codex.md'
& codex exec --json -m gpt-5.3-codex -c 'model_reasoning_effort="xhigh"' $prompt *> $log1
$raw1 = Get-Content -Path $log1 -Raw
Set-Content -Path $resp1 -Value (Extract-Response -Raw $raw1 -Model 'codex') -Encoding UTF8
$modelRuns += [pscustomobject]@{timestamp_utc=$ts;stage='base';model='codex_gpt-5.3-codex_xhigh';status='ok';output_file=$resp1;log_file=$log1;notes='completed'}

# Claude
$ts = [DateTime]::UtcNow.ToString('o')
$log2 = Join-Path $logsDir '02_claude_base.log'
$resp2 = Join-Path $respDir '02_claude.md'
& claude -p $prompt --model claude-opus-4-6 --effort high *> $log2
$raw2 = Get-Content -Path $log2 -Raw
Set-Content -Path $resp2 -Value (Extract-Response -Raw $raw2 -Model 'claude') -Encoding UTF8
$modelRuns += [pscustomobject]@{timestamp_utc=$ts;stage='base';model='claude_opus-4-6_high';status='ok';output_file=$resp2;log_file=$log2;notes='completed'}

# Gemini
$ts = [DateTime]::UtcNow.ToString('o')
$log3 = Join-Path $logsDir '03_gemini_base.log'
$resp3 = Join-Path $respDir '03_gemini.md'
& gemini -p $prompt --model gemini-3.1-pro-preview *> $log3
$raw3 = Get-Content -Path $log3 -Raw
Set-Content -Path $resp3 -Value (Extract-Response -Raw $raw3 -Model 'gemini') -Encoding UTF8
$modelRuns += [pscustomobject]@{timestamp_utc=$ts;stage='base';model='gemini_3.1-pro-preview';status='ok';output_file=$resp3;log_file=$log3;notes='completed'}

$modelRuns | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'model_runs.csv') -Encoding UTF8

$manifest = @(
  'artifact,kind,path',
  "run_brief,input,$(Join-Path $RunDir 'inputs/run_brief.md')",
  "prompt_base,input,$(Join-Path $RunDir 'inputs/prompt_base.md')",
  "codex_response,response,$resp1",
  "claude_response,response,$resp2",
  "gemini_response,response,$resp3",
  "model_runs,log,$(Join-Path $logsDir 'model_runs.csv')"
)
Set-Content -Path (Join-Path $logsDir 'manifest.csv') -Value $manifest -Encoding UTF8
