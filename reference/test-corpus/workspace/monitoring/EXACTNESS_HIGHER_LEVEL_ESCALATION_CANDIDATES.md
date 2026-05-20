# Exactness Higher-Level Escalation Candidates

## 1. Purpose

This file records direct-function exactness lanes that were actively pushed through the current repos and agents, but remained blocked after multiple bounded arithmetic-order attempts.

Exactness target for the lanes recorded here:
- reproduce observed Excel machine bits,
- not the mathematically closest non-Excel result,
- and document any evidenced Excel deviation from correctly rounded math/library behavior when that matters to the implementation choice.

Only add a function here after:
- retained host evidence confirms the mismatch is still current,
- OxFml-side post-function rounding/canonicalization has been ruled out for the lane,
- local OxFunc/engine work has already tried multiple bounded arithmetic-order or kernel-level variants,
- and no safe local patch satisfied both the target row and broader pinned regressions.

## 2. Current escalation candidates

### 2.1 PMT / FTC-0377

Primary retained corpus row:
- `FTC-0377`
- formula: `=PMT(0.05/12,360,200000)`
- current retained host root: `target/triage/ftc-0377-0391-current-status-normal-batch-output`
- current retained mismatch:
  - OxFml: `-1073.6432460242763`
  - Excel: `-1073.6432460242781`

Adjacent direct witness now folded into the same lane:
- `FTC-0391`
- formula: `=PPMT(0.05/12,1,360,200000)`
- fresh retained host root: `target/triage/ftc-0377-0391-current-status-normal-batch-output`
- fresh retained mismatch:
  - OxFml: `-240.30991269094295`
  - Excel: `-240.3099126909447`
- fresh OxXlPlay direct machine witness from `.tmp/ftc-effect-pmt-witness-matrix/results.json`:
  - `PPMT(0.05/12,1,360,200000)` bits `0xC06E09EACE050723`

Current local/owner repo:
- `OxFunc`
- owning file:
  - `crates/oxfunc_core/src/functions/financial_time_value_family.rs`
- owning functions:
  - `pmt`
  - `growth`
  - `annuity_term`
  - `balance_equation`
  - `eval_pmt_surface`

Why this is escalated:
- OxFml repo-local inspection already ruled out a post-function evaluation/publication rounding seam for this direct-call cluster.
- OxFunc already resolved adjacent exactness lanes in the same campaign phase:
  - `SKEW` / `FTC-0374`
  - `KURT` / `FTC-0375`
  - `NPV` / `FTC-0382`
- PMT then received a bounded arithmetic-order pass with more than ten plausible variants.
- Result: no single non-branching arithmetic-order-only formulation satisfied both:
  1. exact `FTC-0377` convergence, and
  2. preservation of broader pinned annuity publication rows.

Pinned broader rows used during blocking pass:
- `PMT(0.05,10,1000,0,end)`
  - target bits: `0xc06030257a65e089`
- `PMT(0.08/12,10,10000,0,end)`
  - target bits: `0xc0903420dc087094`
- fresh adjacent direct witness from OxXlPlay matrix:
  - `PMT(0.05/12,360,200000)` bits `0xC090C692AF15F63A`
  - `IPMT(0.05/12,1,360,200000)` bits `0xC08A0AAAAAAAAAAB`
  - `PPMT(0.05/12,1,360,200000)` bits `0xC06E09EACE050723`

Key retained ledger outcome from OxFunc:
- current shipped formula preserves the broader pinned rows exactly, but misses `FTC-0377` by `7` ULPs.
- the only earlier tried formulation that hit `FTC-0377` exactly was the grouped `ln1p/expm1`-based scale form, but it regressed the broader pinned rows.
- fresh follow-on evidence now also shows `FTC-0391` / `PPMT` collapses into the same PMT/payment-publication substrate rather than standing as an independent local lane:
  - first-period `IPMT` is effectively fixed at `-pv * rate`
  - `PPMT = PMT - first_period_interest`
  - Excel direct witness bits for `PPMT` are consistent with the PMT-adjacent publication shift
- OxXlPlay linkage proof at `.tmp/ftc-effect-pmt-witness-matrix/results.json` further tightened this: for the active mortgage case, Excel shows `12*PMT - CUMPRINC` is bit-identical to `CUMIPMT`, and `CUMIPMT + CUMPRINC - 12*PMT` evaluates to exact zero. So there is no separate cumulative-interest wrinkle to pursue here; the cumulative functions are aligned to the same PMT publication path.
- one additional bounded scratch pass on plausible PMT-side algebra also failed to produce a production-worthy family improvement:
  - tested scratch-only variants: `H2` merge-rate-into-numerator, `H3` discount-factor form, `H5` FMA numerator, `H2+H5`, `H3+H5`
  - widened host scoring surface: active `FTC-0377` plus `PMT(0.05/12,120,100000)`, `PMT(0.08/12,360,250000)`, `PMT(0.04/12,360,200000)`, matched floor `PMT(0.05,10,100)`, and `PMT(0.01,48,8000)`
  - results:
    - current `H0`: `1/6`
    - `H2`: `0/6`
    - `H3`: `0/6`
    - `H5`: `1/6`
    - `H2+H5`: `0/6`
    - `H3+H5`: `0/6`
  - no tested plausible regrouping improved the family without regression; `H2` and `H3` generally worsened the widened set, while `H5` was bit-identical to current on the active blocked rows.
- all current bounded local regroupings are now dominated or non-improving.

Concise bounded-variant summary:
- broader-row-safe but `FTC-0377`-missing:
  - current
- `FTC-0377`-exact but broader-row-regressing:
  - grouped `ln1p/expm1` present/future scale form (`group_b`)
- dominated / worse:
  - recurrence
  - recurrence_kahan
  - log1p
  - expm1
  - powf
  - exp2
  - ratio-over-term regroupings
  - quotient-difference regroupings
  - split-sum regroupings
  - fused-style regroupings tried in the final bounded pass

Recommended escalation payload for a higher-power agent:
- exact row set:
  - `=PMT(0.05/12,360,200000)`
  - `=PPMT(0.05/12,1,360,200000)`
  - `PMT(0.05,10,1000,0,end)`
  - `PMT(0.08/12,10,10000,0,end)`
  - widened PMT witness rows:
    - `=PMT(0.05/12,120,100000)`
    - `=PMT(0.08/12,360,250000)`
    - `=PMT(0.04/12,360,200000)`
    - `=PMT(0.01,48,8000)`
- target/current bits from the retained ledger
- the bounded-variant partition above, including the failed `H2` / `H3` / `H5` / `H2+H5` / `H3+H5` scratch pass
- the exact owner seams in `financial_time_value_family.rs`
- OxXlPlay linkage artifact `.tmp/ftc-effect-pmt-witness-matrix/results.json`
- the note that the issue appears to live on the shared annuity substrate, that `PPMT` should be treated as an adjacent payment-publication witness rather than an independent lane, and that no separate cumulative-interest wrinkle remains on the active mortgage case

### 2.2 RATE / FTC-0381

Primary retained corpus row:
- `FTC-0381`
- formula: `=RATE(360,-1073.64,200000)`
- current retained host root: `target/triage/ftc-0381-current-status-normal-batch-output`
- current retained mismatch:
  - OxFml: `0.0041666445363460975`
  - Excel: `0.004166644536345589`

Current local/owner repo:
- `OxFunc`
- owning file:
  - `crates/oxfunc_core/src/functions/financial_time_value_family.rs`
- owning functions:
  - `rate`
  - `balance_equation`
  - `growth`
  - `annuity_term`
- secondary numeric dependency:
  - `power_kernel`

Why this is now a companion escalation candidate:
- current host rerun confirms the mismatch is still live and still only a tiny exact-value drift.
- OxFunc completed a witness-first bounded local pass and landed witness commit `12bfff9` (`tests: pin FTC-0381 RATE exactness witness gap`).
- The bounded pass showed that the current published local value is partly explained by the current early-stop tolerance, but tightening solver tolerance alone still does not reach the Excel target.
- Additional bounded balance-equation conditioning probes also failed to hit the Excel bits exactly.

Pinned witness bits:
- current local / adapter:
  - value: `0.0041666445363460975`
  - bits: `0x3f71110b20485999`
- Excel target:
  - value: `0.004166644536345589`
  - bits: `0x3f71110b2048574f`
- fresh host rerun under preserved compare-ready lexemes:
  - `target/triage/ftc-0381-current-status-normal-batch-output/cases/FTC-0381`
  - remains blocked with the same preserved values above

Key retained ledger outcome from OxFunc:
- under the current `balance_equation`, residuals are:
  - at Excel target: `1.0244548320770264e-8`
  - at current local: `6.05359673500061e-8`
- therefore current `RATE_TOLERANCE = 1e-7` does matter for the published local value.
- fresh scratch-only tolerance / exit sweep then confirmed this more sharply:
  - current `1e-7` tolerance lands at `0x3f71110b20485999` and stays there regardless of simple stability exits,
  - tightening to `1e-10` improves the active row materially to `0x3f71110b20485718`,
  - tighter settings `1e-13` / `1e-16` and simple rate-stability exits (`2u`, `4u`, `16u`) do not improve beyond that floor,
  - the matched control seed-inversion row stays non-regressed across the sweep.
- so the old early-stop hypothesis is only partial: tolerance tightening removes the premature-exit portion of the gap, but the solve still floors at:
  - `0.0041666445363455415`
  - bits: `0x3f71110b20485718`
- that refined value is still not the Excel target.

Additional bounded conditioning probes tried, not landed:
- grouped current-balance form:
  - `fv - adjust + factor * (pv + adjust)`
  - root stayed `0x3f71110b20485718`
- grouped `mul_add` form:
  - root stayed `0x3f71110b20485718`
- grouped `log1p/exp` balance form:
  - best root `0x3f71110b20485719` / `0x3f71110b2048571a`
- integer-period power-sum balance form:
  - root `0x3f71110b20485780`
- simple solver-exit refinements already tried in the new scratch sweep:
  - residual tolerances `1e-10`, `1e-13`, `1e-16`
  - rate-stability exits around `2`, `4`, `16` ULP
- none hit Excel exactly.

Current higher-level diagnosis:
- not just RATE-specific stopping tolerance,
- stopping tolerance explains the current published local value,
- but after tighter solve the exact mismatch remains,
- so the live seam looks like balance-equation evaluation conditioning on the shared annuity substrate, beyond RATE-specific iteration alone.
- fresh tolerance-sweep result is therefore strong parking evidence rather than a fresh local breakthrough: early-stop tightening is a legitimate partial improvement theory, but it does not close the lane.

Recommended escalation payload for a higher-power agent:
- exact retained host row and case path:
  - `target/triage/ftc-0381-0383-normal-batch-output/cases/FTC-0381`
- the witness commit `12bfff9`
- current/target bits above
- the tightened-solve outcome `0x3f71110b20485718`
- the bounded conditioning probe ledger above
- the explicit diagnosis that this sits on the annuity balance-evaluation substrate, not merely on early-stop tolerance

### 2.3 NORM.INV / FTC-0371

Primary retained corpus row:
- `FTC-0371`
- formula: `=NORM.INV(0.975,0,1)`
- current retained host root: `target/triage/norm-inv-lane-widening-normal-batch-output`
- current retained mismatch:
  - OxFml: `1.9599639845400538`
  - Excel: `1.9599639845400536`

Expanded retained host root for the shared direct-call core:
- `target/triage/norm-inv-algorithm-family-expanded-normal-batch-output`
- current retained headline:
  - `12 Matched / 46 Blocked / 0 Mismatched` across `58` focused cases
- retained simplifying fact:
  - Excel shows `NORM.INV(p,0,1) == NORM.S.INV(p)` pointwise on all `29` probed `p` values
  - current OxFml / OxFunc path also shows the same identity on all `29` probed `p` values
  - so this is one shared inverse-normal-core lane, not a separate affine `mean` / `sigma` lane

Current local/owner repo:
- `OxFunc`
- owning file:
  - `crates/oxfunc_core/src/functions/normal_log_family.rs`
- owning function family:
  - inverse normal / normal-log family helpers

Current implementation shape:
- effectively `Acklam + one Newton refinement`
- branch cuts at approximately `p = 0.02425` and `p = 0.97575`
- Newton refinement currently uses the normal CDF path via `erf`

Why this is escalated / parked rather than actively patched:
- fresh host evidence showed the mismatch is broad, not a single-anchor accident.
- shifted/scaled witnesses propagated the same last-bit drift, so the live seam is in the standardized inverse-normal core rather than the affine post-transform.
- scratch family work in OxFunc showed:
  - current `Acklam + Newton` scores `6/29` on the shared `29`-anchor direct-call set,
  - plain `Acklam` scores `1/29`,
  - pure `Wichura AS241` scores `11/29`,
  - `Wichura AS241 + one Newton` also scores `11/29`,
  - `Beasley-Springer-Moro` scores `1/29`,
  - older classical families tried locally (`Odeh-Evans AS70`, `Hastings AS 26.2.23`) also score only `1/29`.
- more plausible refinement-path rewrites on the same Wichura-like core did not beat the `11/29` ceiling.
- only implausible gated variants such as conditional Newton passes reached `15/29`, and those were explicitly rejected as likely overfit rather than plausible Excel code.

Important retained theory signals:
- fresh host evidence shows Excel is not perfectly bitwise antisymmetric around `p = 0.5` for this lane.
- representative complement-pair asymmetries were observed at:
  - `0.0001 / 0.9999`
  - `0.025 / 0.975`
  - `0.05 / 0.95`
- but simple asymmetric/gated workflows still looked less plausible than a real Excel-era implementation.
- current best theory boundary is therefore:
  - a Wichura-like or similarly classical inverse-normal core remains the most plausible family,
  - but the residual likely lives in coefficients, evaluation ordering, or intermediate precision rather than in a simple published-family swap.

Selected retained anchor table from the widened host batch:
- blocked:
  - `p=0.0001` -> OxFml `-3.7190164854556214`, Excel `-3.71901648545568`
  - `p=0.025` -> OxFml `-1.959963984540054`, Excel `-1.9599639845400538`
  - `p=0.075` -> OxFml `-1.4395314709384561`, Excel `-1.4395314709384572`
  - `p=0.425` -> OxFml `-0.18911842627279263`, Excel `-0.18911842627279254`
  - `p=0.95` -> OxFml `1.6448536269514726`, Excel `1.6448536269514715`
  - `p=0.975` -> OxFml `1.9599639845400538`, Excel `1.9599639845400536`
  - `p=0.9999` -> OxFml `3.719016485455677`, Excel `3.7190164854557084`
- matched:
  - `p=0.05` -> `-1.6448536269514726`
  - `p=0.15` -> `-1.0364333894937898`
  - `p=0.35` -> `-0.38532046640756784`
  - `p=0.4` -> `-0.2533471031357998`
  - `p=0.5` -> `0.0`
  - `p=0.925` -> `1.4395314709384563`

Retained stale-pin audit:
- tree test currently pins `norm_s_inv_kernel(0.975)` to `1.9599639845400538`
- fresh Excel host value is `1.9599639845400536`
- so the in-tree exact-value pin is stale and must not be treated as authoritative host evidence

Recommended parked payload for higher-level assistance:
- exact retained host roots:
  - `target/triage/norm-inv-lane-widening-normal-batch-output`
  - `target/triage/norm-inv-algorithm-family-expanded-normal-batch-output`
- current owner file:
  - `crates/oxfunc_core/src/functions/normal_log_family.rs`
- family score ledger:
  - `Acklam + Newton = 6/29`
  - `Wichura AS241 = 11/29`
  - `Wichura AS241 + Newton = 11/29`
  - gated scratch best = `15/29` but rejected on plausibility grounds
- current theory prompt / support bundle:
  - `tmp/support-intelligence/ERFC_NORMINV_exactness_support_prompt.md`
- current recommendation:
  - park rather than ship a gated local improvement,
  - revisit when we have a stronger theory for coefficients / evaluation ordering / intermediate precision, or better external source lineage for Excel's inverse-normal implementation

## 3. Shared annuity-substrate escalation read

Combined reading across `PMT`, adjacent `PPMT`, and `RATE`:
- all unresolved annuity-substrate evidence lives in `crates/oxfunc_core/src/functions/financial_time_value_family.rs`.
- all depend on the same annuity substrate pieces:
  - `growth`
  - `annuity_term`
  - `balance_equation`
- but they fail in different ways:
  - `PMT` is a publication-expression problem where one grouped formulation hits the anchor row exactly but regresses broader pinned annuity rows,
  - `PPMT` is derivative evidence for the same payment-publication seam because first-period `IPMT` is effectively fixed and `PPMT = PMT - first_period_interest`,
  - `RATE` is a solve/evaluation-conditioning problem where tighter solve improves the value but still misses Excel under multiple balance-evaluation variants.

Current best higher-level hypothesis:
- the remaining gap is not a generic OxFml publication seam,
- and not merely a stop-tolerance issue,
- but rather a deeper shared annuity numeric-conditioning / publication-discipline question inside the OxFunc annuity substrate.

Recommended handoff focus for a higher-power agent:
- analyze `PMT` and `RATE` together at the annuity-identity level rather than as isolated formula leaves,
- preserve the current no-row-specific-branching rule,
- preserve broader pinned annuity rows,
- and look for a substrate-level formulation or solve/publication rule that explains both:
  - why grouped `ln1p/expm1` scaling fixes the PMT mortgage row but regresses adjacent pinned rows,
  - and why tighter RATE solve still converges to the wrong local optimum under the present `balance_equation` formulations.

## 4. Recently resolved adjacent lane

### 4.1 IRR / FTC-0383

Resolution summary:
- `OxFunc` landed `3dc35ad` (`cashflow: refine IRR plateau publication exactness`).
- DnaOneCalc host rerun `target/triage/ftc-0383-only-normal-batch-output` now shows `FTC-0383` as `Matched`.
- current retained matched values:
  - OxFml: `0.16340560068898924`
  - Excel: `0.16340560068898924`

Owner path that resolved it:
- `crates/oxfunc_core/src/functions/cashflow_rate_family.rs`
- `crates/oxfunc_core/tests/oxfml_seam_integration.rs`

Resolved theory note:
- this was not fixed by mere tolerance relaxation.
- the landed refinement keeps the existing `bounded_rate_solve`, then scans a small local ULP neighborhood on the periodic cashflow path, finds the contiguous plateau with minimal `abs(periodic_npv_with_t0(rate, cashflows))`, and publishes the midpoint of that plateau.
- for `FTC-0383`, the retained local plateau was:
  - `0x3fc4ea798778a1fc .. 0x3fc4ea798778a204`
  - Excel target `0x3fc4ea798778a200` sits at the midpoint of that minimal-residual plateau.

Practical guidance retained from the investigation:
- `IRR` was adjacent in the broad class of tiny root-solve exactness drift,
- but it was correctly treated on the cashflow/`NPV` substrate rather than bundled into the annuity-balance escalation used for `PMT` and `RATE`.
