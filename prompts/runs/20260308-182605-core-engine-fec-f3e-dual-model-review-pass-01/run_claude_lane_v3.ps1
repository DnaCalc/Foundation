$ErrorActionPreference='Stop'
$run='prompts/runs/20260308-182605-core-engine-fec-f3e-dual-model-review-pass-01'
$respDir=Join-Path $run 'responses/claude'
$logsDir=Join-Path $run 'logs'
$basePath=(Resolve-Path (Join-Path $run 'inputs/base_prompt.md')).Path

function Parse-ClaudeResult([string]$logPath){
  $raw = Get-Content -Raw $logPath
  try {
    $obj = $raw | ConvertFrom-Json
    if($obj.type -eq 'result' -and $obj.result){ return [string]$obj.result }
  } catch {}
  $last=$null
  Get-Content $logPath | ForEach-Object {
    $line=$_.Trim(); if(!$line){ return }
    try { $o=$line|ConvertFrom-Json; if($o.type -eq 'result' -and $o.result){ $last=[string]$o.result } } catch {}
  }
  if($last){ return $last }
  throw 'no result field found'
}

function Invoke-Round([string]$stage,[string]$prompt,[string]$logName,[string]$outName){
  $ts=[DateTime]::UtcNow.ToString('o')
  $logPath=Join-Path $logsDir $logName
  $outPath=Join-Path $respDir $outName
  $status='ok'; $notes='completed'
  try {
    $prompt | claude -p --model claude-opus-4-6 --effort high --permission-mode bypassPermissions --output-format json *> $logPath
    $text = Parse-ClaudeResult $logPath
    Set-Content -Path $outPath -Value $text -Encoding UTF8
  } catch {
    $status='error'; $notes=$_.Exception.Message
    Set-Content -Path $outPath -Value ("[ERROR] " + $_.Exception.Message) -Encoding UTF8
  }
  [pscustomobject]@{timestamp_utc=$ts;stage=$stage;model='claude_opus-4-6_high';status=$status;output_file=$outPath;log_file=$logPath;notes=$notes}
}

$runs=@()
$p1=@"
Read and execute the task prompt at:
$basePath

Requirements:
- Follow the task prompt exactly, including deliverable order.
- You may inspect additional repository files if needed.
- Return only the full answer.
"@
$runs += Invoke-Round 'round1_base' $p1 'claude_v3_round1.json' '01_base.md'

if($runs[-1].status -eq 'ok'){
  $r1Path=(Resolve-Path (Join-Path $respDir '01_base.md')).Path
  $p2=@"
Self-review round 1 for the same task.

Read:
- task prompt: $basePath
- prior answer: $r1Path

Output requirements:
1) Concise rigorous critique of prior answer.
2) Full revised answer replacing it, preserving required deliverable order.

You may inspect additional repository files if needed.
"@
  $runs += Invoke-Round 'round2_review1' $p2 'claude_v3_round2.json' '02_review1.md'
}

if($runs[-1].status -eq 'ok'){
  $r2Path=(Resolve-Path (Join-Path $respDir '02_review1.md')).Path
  $p3=@"
Self-review round 2 for the same task.

Read:
- task prompt: $basePath
- revised answer: $r2Path

Output requirements:
1) Concise rigorous critique of revised answer.
2) Final revised answer replacing it, preserving required deliverable order.

You may inspect additional repository files if needed.
"@
  $runs += Invoke-Round 'round3_review2_final' $p3 'claude_v3_round3.json' '03_review2_final.md'
}

$runs | Export-Csv -NoTypeInformation -Path (Join-Path $logsDir 'claude_model_runs.csv') -Encoding UTF8
