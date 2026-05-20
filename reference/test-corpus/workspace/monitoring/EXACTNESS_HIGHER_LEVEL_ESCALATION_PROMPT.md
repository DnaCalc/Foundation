# Exactness Higher-Level Escalation Prompt

Use this when handing the remaining exact-value annuity-substrate lane to a higher-power agent.

## Task

Investigate the remaining exact-value mismatches for the shared annuity substrate in `OxFunc`.

Current unresolved formulas:
- `FTC-0377` / `=PMT(0.05/12,360,200000)`
- `FTC-0391` / `=PPMT(0.05/12,1,360,200000)` as an adjacent PMT/payment-publication witness on the same annuity substrate
- `FTC-0381` / `=RATE(360,-1073.64,200000)`

Current resolved adjacent evidence:
- `FTC-0382` / `NPV` is already green after `7d81f8c`
- `FTC-0383` / `IRR` is already green after `3dc35ad`
- `FTC-0374` / `SKEW` and `FTC-0375` / `KURT` are already green and should not be reopened

## Guardrails

- Stay owner-correct in `OxFunc`; for exactness work here, that means reproducing observed Excel machine bits rather than preferring mathematically more accurate non-Excel values
- No tolerance-based greening
- No row-specific branching
- No surface/policy changes unless clearly required and explicitly justified
- Preserve broader pinned annuity rows, not just the anchor witness
- Treat `PMT` and `RATE` together at the annuity-substrate level, not as isolated leaves

## Owner files and functions

Primary file:
- `crates/oxfunc_core/src/functions/financial_time_value_family.rs`

Primary functions / substrate pieces:
- `pmt`
- `rate`
- `growth`
- `annuity_term`
- `balance_equation`
- `eval_pmt_surface`

Secondary numeric dependency noted during RATE work:
- `power_kernel`

## Retained host evidence

### PMT / FTC-0377

Host roots:
- `target/triage/ftc-0377-0391-current-status-normal-batch-output`
- `target/triage/post-power-residual-blocked-seven-normal-batch-output`

Current mismatch:
- OxFml: `-1073.6432460242763`
- Excel: `-1073.6432460242781`

Adjacent retained witness:
- `FTC-0391`
- fresh host roots:
  - `target/triage/ftc-0377-0391-current-status-normal-batch-output`
  - `target/triage/post-power-residual-blocked-seven-normal-batch-output`
- mismatch:
  - OxFml: `-240.30991269094295`
  - Excel: `-240.30991269094474`
- fresh direct Excel machine witnesses from OxXlPlay:
  - `PMT(0.05/12,360,200000)` bits `0xC090C692AF15F63A`
  - `IPMT(0.05/12,1,360,200000)` bits `0xC08A0AAAAAAAAAAB`
  - `PPMT(0.05/12,1,360,200000)` bits `0xC06E09EACE050723`

Pinned broader rows used during bounded local work:
- `PMT(0.05,10,1000,0,end)`
  - target bits: `0xc06030257a65e089`
- `PMT(0.08/12,10,10000,0,end)`
  - target bits: `0xc0903420dc087094`

### RATE / FTC-0381

Host roots:
- `target/triage/ftc-0381-current-status-normal-batch-output`
- `target/triage/post-power-residual-blocked-seven-normal-batch-output`

Current mismatch:
- OxFml: `0.0041666445363460975`
- Excel: `0.004166644536345589`
- fresh host roots:
  - `target/triage/ftc-0381-current-status-normal-batch-output`
  - `target/triage/post-power-residual-blocked-seven-normal-batch-output`

Pinned bits from local witness pass:
- current local / adapter:
  - value: `0.0041666445363460975`
  - bits: `0x3f71110b20485999`
- Excel target:
  - value: `0.004166644536345589`
  - bits: `0x3f71110b2048574f`

## What local bounded work already proved

### PMT

Local bounded arithmetic-order pass outcome:
- current shipped formula preserves broader pinned annuity rows exactly, but misses `FTC-0377` by `7` ULPs
- the only tried formulation that hit `FTC-0377` exactly was the grouped `ln1p/expm1`-based present/future-scale form (`group_b`)
- that exact-hitting formulation regressed the broader pinned annuity rows
- all other tried regroupings were dominated

Important partition:
- broader-row-safe but `FTC-0377`-missing:
  - current
- `FTC-0377`-exact but broader-row-regressing:
  - grouped `ln1p/expm1` present/future scale form (`group_b`)
- adjacent witness read:
  - `FTC-0391` / `PPMT` collapses into the same PMT/payment-publication lane because first-period `IPMT` is effectively fixed and `PPMT = PMT - first_period_interest`

### RATE

Local bounded solve/conditioning pass outcome:
- current `RATE_TOLERANCE = 1e-7` does affect the currently published local value
- but tightening solver tolerance alone does not reach Excel
- tighter solve on current `balance_equation` converged to:
  - `0.0041666445363455415`
  - bits: `0x3f71110b20485718`
- that refined value still misses Excel target `0x3f71110b2048574f`

Additional bounded conditioning probes tried and failed:
- grouped current-balance form:
  - `fv - adjust + factor * (pv + adjust)`
  - root stayed `0x3f71110b20485718`
- grouped `mul_add` form:
  - root stayed `0x3f71110b20485718`
- grouped `log1p/exp` balance form:
  - best root `0x3f71110b20485719` / `0x3f71110b2048571a`
- integer-period power-sum balance form:
  - root `0x3f71110b20485780`

Residual fact under current `balance_equation`:
- at Excel target: `1.0244548320770264e-8`
- at current local: `6.05359673500061e-8`

## Higher-level hypothesis to test

The remaining problem appears to be a shared annuity numeric-conditioning / publication-discipline issue inside `financial_time_value_family.rs`, not:
- a generic OxFml publication seam,
- not merely a stop-tolerance issue,
- and not a safe case-by-case patch per formula.

Specifically explain, if possible:
1. why grouped `ln1p/expm1` scaling fixes the PMT mortgage witness but regresses adjacent pinned annuity rows,
2. how the same PMT/publication substrate should account for the adjacent `PPMT` first-period witness,
3. why tighter RATE solve still converges to the wrong local value under multiple balance-evaluation variants,
4. whether a substrate-level reformulation can satisfy PMT, adjacent PPMT, and RATE without row-specific branching.

## Acceptance

Only count the escalation solved if:
- `FTC-0377` matches exactly,
- `FTC-0391` matches exactly,
- `FTC-0381` matches exactly,
- broader pinned annuity publication rows stay green,
- and no surface/policy workaround was needed without explicit justification.

Additional current context:
- DnaOneCalc compare-ready numeric witness drift is no longer a confounder for this bundle after commit `0e0a320` (`Preserve numeric witness lexemes in compare-ready replay`).
- So the remaining annuity rows should now be read as preserved-witness reds, not compare-ready serialization artifacts.

## Related internal references

> reference/test-corpus/workspace/monitoring/
- `EXACTNESS_EXCEL_BIT_REPRODUCTION_POLICY.md`
- `EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md`
- `NEXT_FORMULA_WORK_BOARD.md`
- `campaign-notes.jsonl`
