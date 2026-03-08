$ErrorActionPreference='Stop'
$run='prompts/runs/20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01'
$respDir=Join-Path $run 'responses/gpt54'
$logsDir=Join-Path $run 'logs'
$basePromptPath=Join-Path $run 'inputs/base_prompt.md'

$r1PromptPath=Join-Path $run 'gpt54_round1_prompt.txt'
$r2PromptPath=Join-Path $run 'gpt54_round2_prompt.txt'
$r3PromptPath=Join-Path $run 'gpt54_round3_prompt.txt'

@"
Read and execute the task prompt in this file:
$basePromptPath

Do the full requested deliverables in the exact required order.
You may inspect additional repository files if needed; cite any extra files you actually used.
"@ | Set-Content -Path $r1PromptPath -Encoding UTF8

@"
You are doing self-review round 1 for the same task.
Read the task prompt file:
$basePromptPath

Read your prior answer file:
$(Join-Path $respDir '01_base.md')

Output format requirements:
1) A concise but rigorous critique of the prior answer (correctness, coherence, missing obligations, weak assumptions, traceability gaps).
2) Then a full revised answer that replaces the prior one and follows the task deliverable order exactly.

You may inspect additional repository files if needed; cite any extra files you actually used.
"@ | Set-Content -Path $r2PromptPath -Encoding UTF8

@"
You are doing self-review round 2 for the same task.
Read the task prompt file:
$basePromptPath

Read your prior revised answer file:
$(Join-Path $respDir '02_review1.md')

Output format requirements:
1) A concise but rigorous second-pass critique of the revised answer.
2) Then a final revised answer that replaces the previous version and follows the task deliverable order exactly.

You may inspect additional repository files if needed; cite any extra files you actually used.
"@ | Set-Content -Path $r3PromptPath -Encoding UTF8

function Run-GptRound {
  param(
    [string]$Stage,
    [string]$PromptFile,
    [string]$LogFile,
    [string]$OutFile
  )

  $ts=[DateTime]::UtcNow.ToString('o')
  $logPath=Join-Path $logsDir $LogFile
  $outPath=Join-Path $respDir $OutFile

  $prompt = Get-Content -Path $PromptFile -Raw
  & codex exec --json -m gpt-5.4 -c 'model_reasoning_effort="xhigh"' $prompt *> $logPath

  $text = ''
  $status='ok'
  $notes='completed'
  try {
    $lines = Get-Content -Path $logPath
    $msgs = @()
    foreach($line in $lines){
      if([string]::IsNullOrWhiteSpace($line)){ continue }
      $obj = $line | ConvertFrom-Json
      if($obj.type -eq 'item.completed' -and $obj.item.type -eq 'agent_message'){
        $msgs += [string]$obj.item.text
      }
    }
    if($msgs.Count -eq 0){ throw 'No agent_message found in JSONL log' }
    $text = ($msgs -join "`n`n")
    Set-Content -Path $outPath -Value $text -Encoding UTF8
  } catch {
    $status='error'
    $notes=$_.Exception.Message
    Set-Content -Path $outPath -Value ("[PARSE ERROR] " + $_.Exception.Message) -Encoding UTF8
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

$runs = @()
$runs += Run-GptRound -Stage 'round1_base' -PromptFile $r1PromptPath -LogFile 'gpt54_round1.jsonl' -OutFile '01_base.md'
if($runs[-1].status -ne 'ok'){
  $runs | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'gpt54_model_runs.csv') -Encoding UTF8
  throw 'Round 1 failed'
}

$runs += Run-GptRound -Stage 'round2_review1' -PromptFile $r2PromptPath -LogFile 'gpt54_round2.jsonl' -OutFile '02_review1.md'
if($runs[-1].status -ne 'ok'){
  $runs | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'gpt54_model_runs.csv') -Encoding UTF8
  throw 'Round 2 failed'
}

$runs += Run-GptRound -Stage 'round3_review2_final' -PromptFile $r3PromptPath -LogFile 'gpt54_round3.jsonl' -OutFile '03_review2_final.md'
$runs | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'gpt54_model_runs.csv') -Encoding UTF8
