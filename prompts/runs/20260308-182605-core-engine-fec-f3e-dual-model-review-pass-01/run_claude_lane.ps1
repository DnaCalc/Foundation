$ErrorActionPreference='Stop'
$run='prompts/runs/20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01'
$basePath=Join-Path $run 'inputs/base_prompt.md'
$respDir=Join-Path $run 'responses/claude'
$logsDir=Join-Path $run 'logs'

function Parse-ClaudeResult {
  param([string]$LogPath)
  $raw = Get-Content -Raw $LogPath

  # First try whole-document JSON
  try {
    $obj = $raw | ConvertFrom-Json
    if($obj.type -eq 'result' -and $null -ne $obj.result){ return [string]$obj.result }
  } catch {}

  # Then try JSON-per-line; keep last result object
  $lastResult = $null
  Get-Content -Path $LogPath | ForEach-Object {
    $line = $_.Trim()
    if([string]::IsNullOrWhiteSpace($line)){ return }
    try {
      $obj = $line | ConvertFrom-Json
      if($obj.type -eq 'result' -and $null -ne $obj.result){ $lastResult = [string]$obj.result }
    } catch {}
  }
  if($null -ne $lastResult){ return $lastResult }

  throw 'Claude JSON did not contain result field'
}

function Invoke-ClaudeRound {
  param(
    [string]$Stage,
    [string]$PromptText,
    [string]$LogName,
    [string]$OutName
  )
  $ts=[DateTime]::UtcNow.ToString('o')
  $logPath=Join-Path $logsDir $LogName
  $outPath=Join-Path $respDir $OutName
  $status='ok'
  $notes='completed'

  try {
    $PromptText | claude -p --model claude-opus-4-6 --effort high --permission-mode bypassPermissions --output-format json *> $logPath
    $resultText = Parse-ClaudeResult -LogPath $logPath
    Set-Content -Path $outPath -Value $resultText -Encoding UTF8
  } catch {
    $status='error'
    $notes=$_.Exception.Message
    Set-Content -Path $outPath -Value ("[ERROR] " + $_.Exception.Message) -Encoding UTF8
  }

  return [pscustomobject]@{
    timestamp_utc=$ts
    stage=$Stage
    model='claude_opus-4-6_high'
    status=$status
    output_file=$outPath
    log_file=$logPath
    notes=$notes
  }
}

$basePrompt=Get-Content -Raw $basePath

$round1Prompt=@"
You are model lane: Claude Opus 4.6 (high effort).
Execute the following task prompt exactly, including deliverable order.
You may use additional repository files if needed.

=== TASK PROMPT START ===
$basePrompt
=== TASK PROMPT END ===
"@

$runs=@()
$runs += Invoke-ClaudeRound -Stage 'round1_base' -PromptText $round1Prompt -LogName 'claude_v2_round1.json' -OutName '01_base.md'

if($runs[-1].status -eq 'ok'){
  $r1 = Get-Content -Raw (Join-Path $respDir '01_base.md')
  $round2Prompt=@"
You are model lane: Claude Opus 4.6 (high effort).
Self-review round 1 on the same task.

Required output shape:
1) Concise, rigorous critique of the prior answer.
2) Full revised answer that replaces it and preserves required deliverable order.

You may use additional repository files if needed.

=== TASK PROMPT START ===
$basePrompt
=== TASK PROMPT END ===

=== PRIOR ANSWER START ===
$r1
=== PRIOR ANSWER END ===
"@
  $runs += Invoke-ClaudeRound -Stage 'round2_review1' -PromptText $round2Prompt -LogName 'claude_v2_round2.json' -OutName '02_review1.md'
}

if($runs[-1].status -eq 'ok'){
  $r2 = Get-Content -Raw (Join-Path $respDir '02_review1.md')
  $round3Prompt=@"
You are model lane: Claude Opus 4.6 (high effort).
Self-review round 2 on the same task.

Required output shape:
1) Concise, rigorous critique of the revised answer.
2) Final revised answer that replaces it and preserves required deliverable order.

You may use additional repository files if needed.

=== TASK PROMPT START ===
$basePrompt
=== TASK PROMPT END ===

=== PRIOR REVISED ANSWER START ===
$r2
=== PRIOR REVISED ANSWER END ===
"@
  $runs += Invoke-ClaudeRound -Stage 'round3_review2_final' -PromptText $round3Prompt -LogName 'claude_v2_round3.json' -OutName '03_review2_final.md'
}

$runs | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'claude_model_runs.csv') -Encoding UTF8

