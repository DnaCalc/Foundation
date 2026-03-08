$ErrorActionPreference='Stop'
$run='prompts/runs/20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01'
$basePath=Join-Path $run 'inputs/base_prompt.md'
$respDir=Join-Path $run 'responses/gpt54'
$logsDir=Join-Path $run 'logs'

function Invoke-GptRound {
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
    $PromptText | codex exec --json -m gpt-5.4 -c 'model_reasoning_effort="xhigh"' - *> $logPath

    $lines=Get-Content -Path $logPath
    $msgs=@()
    foreach($line in $lines){
      if([string]::IsNullOrWhiteSpace($line)){ continue }
      $obj=$line | ConvertFrom-Json
      if($obj.type -eq 'item.completed' -and $obj.item.type -eq 'agent_message'){
        $msgs += [string]$obj.item.text
      }
    }
    if($msgs.Count -eq 0){ throw 'No agent_message found in JSONL output' }
    $text = $msgs[-1]
    Set-Content -Path $outPath -Value $text -Encoding UTF8
  } catch {
    $status='error'
    $notes=$_.Exception.Message
    Set-Content -Path $outPath -Value ("[ERROR] " + $_.Exception.Message) -Encoding UTF8
  }

  return [pscustomobject]@{
    timestamp_utc=$ts
    stage=$Stage
    model='gpt-5.4_xhigh'
    status=$status
    output_file=$outPath
    log_file=$logPath
    notes=$notes
  }
}

$basePrompt=Get-Content -Raw $basePath
$round1Prompt=@"
You are model lane: GPT-5.4 with reasoning effort xhigh.
Execute the following task prompt exactly, including deliverable order.
You may use additional repository files if needed.

=== TASK PROMPT START ===
$basePrompt
=== TASK PROMPT END ===
"@

$runs=@()
$runs += Invoke-GptRound -Stage 'round1_base' -PromptText $round1Prompt -LogName 'gpt54_round1.jsonl' -OutName '01_base.md'

if($runs[-1].status -eq 'ok'){
  $r1 = Get-Content -Raw (Join-Path $respDir '01_base.md')
  $round2Prompt=@"
You are model lane: GPT-5.4 with reasoning effort xhigh.
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
  $runs += Invoke-GptRound -Stage 'round2_review1' -PromptText $round2Prompt -LogName 'gpt54_round2.jsonl' -OutName '02_review1.md'
}

if($runs[-1].status -eq 'ok'){
  $r2 = Get-Content -Raw (Join-Path $respDir '02_review1.md')
  $round3Prompt=@"
You are model lane: GPT-5.4 with reasoning effort xhigh.
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
  $runs += Invoke-GptRound -Stage 'round3_review2_final' -PromptText $round3Prompt -LogName 'gpt54_round3.jsonl' -OutName '03_review2_final.md'
}

$runs | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'gpt54_model_runs.csv') -Encoding UTF8
