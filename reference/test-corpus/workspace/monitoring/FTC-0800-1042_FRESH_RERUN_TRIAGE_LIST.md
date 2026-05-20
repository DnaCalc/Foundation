# FTC-0800-1042 Fresh Rerun Triage List

Purpose:
- capture the fresh DnaOneCalc normal host-path rerun for the tail of the corpus,
- preserve the concrete non-green set as the next working list,
- give a practical owner-oriented order for proceeding.

## 1. Fresh rerun root

Retained output root:

> target/triage/ftc-0800-1042-normal-batch-output

Input batch:

> reference/test-corpus/workspace/batches/ftc-0800-1042-normal-batch.json

Coverage:
- `FTC-0800` through `FTC-1042` inclusive
- `243` total cases

Fresh counts:
- initial tail rerun: `Matched 216`, `Blocked 27`, `Mismatched 0`
- focused parser follow-up after OxFml commit `07fd4eb` at `target/triage/ftc-0837-0916-0987-1041-after-07fd4eb-normal-batch-output`:
  - `FTC-0837` -> `Matched`
  - `FTC-1041` -> `Matched`
  - `FTC-0916` -> initially still `Blocked`
  - `FTC-0987` -> initially still `Blocked`
- focused host-comparison follow-up after DnaOneCalc commit `dc6a0a4` at `target/triage/ftc-0916-0987-after-host-syntax-rejection-normalization-output`:
  - `FTC-0916` -> `Matched`
  - `FTC-0987` -> `Matched`
- focused dynamic-array proving rerun after OxFunc commit `5f6e2f7` at `target/triage/ftc-0833-0836-0917-after-5f6e2f7-normal-batch-output`:
  - `FTC-0833` -> `Matched`
  - `FTC-0836` -> `Matched`
  - `FTC-0917` -> `Matched`

## 2. Exact non-green set

Non-greens from the initial tail rerun were all `Blocked`.

Current active residual set after the focused parser, host-comparison, direct-call, and ad hoc decomposition reruns is:

- `FTC-0895`
- `FTC-0902`
- `FTC-0919`
- `FTC-0936`
- `FTC-0937`
- `FTC-0939`
- `FTC-0992`
- `FTC-0999`
- `FTC-1013`

Freshly cleared from the original tail rerun list:
- `FTC-0837` -> green after OxFml commit `07fd4eb`
- `FTC-1041` -> green after OxFml commit `07fd4eb`
- `FTC-0916` -> green after DnaOneCalc commit `dc6a0a4`
- `FTC-0987` -> green after DnaOneCalc commit `dc6a0a4`
- `FTC-0833` -> green after OxFunc commit `5f6e2f7`
- `FTC-0836` -> green after OxFunc commit `5f6e2f7`
- `FTC-0917` -> green after OxFunc commit `5f6e2f7`
- `FTC-0941` -> green after OxFunc commit `8c9d061`
- `FTC-0995` -> green after OxFunc commit `8c9d061`
- `FTC-0959` -> green after OxFunc commit `b357976`
- `FTC-0966` -> green after OxFunc commit `b357976`
- `FTC-0907` -> green after OxFunc commit `85502a3`
- `FTC-1032` -> green after OxFunc commit `85502a3`
- `FTC-0910` -> green after OxFunc commit `a8019d9`
- `FTC-0930` -> green after OxFunc commit `ef40c9a`
- `FTC-0981` -> current corpus-ID rerun is green at `target/triage/ftc-0902-0981-0999-1013-0886-current-status-normal-batch-output/cases/FTC-0981`; treat prior tail-rerun red as stale-current-status noise
- `FTC-0886` -> current corpus-ID rerun is green at `target/triage/ftc-0902-0981-0999-1013-0886-current-status-normal-batch-output/cases/FTC-0886`; decomposition still exposed an adjacent HSTACK empty-carrier seam, but the corpus row itself is now stale-current-status noise unless a fresh rerun reopens it
- `FTC-0828` -> current ad hoc host repro is green at `target/triage/ftc-0828-decomposition-normal-batch-output/cases/FTC-0828-INDEX-SORT-UNIQUE`; treat as stale-current-status noise unless a fresh corpus-ID rerun reopens it

## 3. Practical triage buckets

### 3.1 Straightforward dynamic-array / indexing / filtering / sorting semantics

These look like the cleanest next owner-local semantics lanes.

- `FTC-0828`
  - `=INDEX(SORT(UNIQUE({3,1,4,1,5,9,2,6,5,3})),1)`
  - OxFml `1.0` vs Excel `3.0`
  - read: direct dynamic-array/order/index disagreement
- `FTC-0833`
  - `=SUM(INDEX({10,20,30,40,50},SEQUENCE(3)))`
  - OxFml `#VALUE!` vs Excel `60.0`
  - read: direct `INDEX(...,SEQUENCE(...))` array-selection mismatch
- `FTC-0836`
  - `=INDEX(SORTBY({"a","b","c","d"},{2,1,2,1},{1,2,1,2}),1)`
  - OxFml `#VALUE!` vs Excel `"b"`
  - read: direct `SORTBY` ordering / projection mismatch
- `FTC-0907`
  - digit-check formula using `MAP(...FIND(TEXT(...)))`
  - OxFml `10x1` logical array of `TRUE` vs Excel scalar `TRUE`
  - fresh direct-host decomposition at `target/triage/ftc-1032-0907-residual-witnesses-normal-batch-output` now shows this reduces cleanly to single-array `AND` scalarization, not to a broader `MAP` / `FIND` / `TEXT` lane:
    - `=AND({TRUE;TRUE;TRUE})` -> OxFml array `{TRUE;TRUE;TRUE}` vs Excel scalar `TRUE`
    - `=AND({TRUE;FALSE;TRUE})` -> OxFml array `{TRUE;FALSE;TRUE}` vs Excel scalar `FALSE`
    - `=AND(MAP(SEQUENCE(3),LAMBDA(x,TRUE)))` shows the same shape mismatch
- `FTC-0910`
  - rolling-average formula using `MAP(...AVERAGE(INDEX(...SEQUENCE(...))))`
  - OxFml `#VALUE!` vs Excel `330.0`
  - OxFml local decomposition plus host proving at `target/triage/ftc-0910-decomposition-normal-batch-output` now show the first honest divergence is direct `INDEX` window extraction with a vector column selector, not `SEQUENCE` and not `AVERAGE`:
    - `=INDEX({10,20,30,40,50,60,70,80,90,100},,SEQUENCE(5,,1))` -> OxFml `#VALUE!` vs Excel `{10;20;30;40;50}`
    - `=INDEX({10,20,30,40,50,60,70,80,90,100},,SEQUENCE(5,,6))` -> OxFml `#VALUE!` vs Excel `{60;70;80;90;100}`
- `FTC-0917`
  - `=LET(data,{3,1,4,1,5,9,2,6},sorted,SORT(data),INDEX(sorted,1)*100+INDEX(sorted,COLUMNS(data)))`
  - OxFml `109.0` vs Excel `306.0`
  - read: `SORT` orientation/indexing disagreement
- `FTC-0930`
  - `=LET(m,{3,7,1;8,2,9;4,6,5},flat,TOCOL(m),sorted,SORT(flat,-1),INDEX(sorted,3))`
  - originally OxFml `#REF!` vs Excel `#VALUE!`
  - focused host decomposition at `target/triage/ftc-0930-decomposition-normal-batch-output` first showed:
    - `=TOCOL({3,7,1;8,2,9;4,6,5})` -> `Matched`
    - `=SORT(TOCOL({3,7,1;8,2,9;4,6,5}),-1)` -> `Matched` at `#VALUE!` on both sides
    - `=INDEX(SORT(TOCOL({3,7,1;8,2,9;4,6,5}),-1),3)` -> OxFml `#REF!` vs Excel `#VALUE!`
  - OxFunc then landed commit `ef40c9a` and focused rerun `target/triage/ftc-0930-after-ef40c9a-normal-batch-output` is now fully green:
    - direct `INDEX(SORT(TOCOL(...),-1),3)` witness -> `Matched` at `#VALUE!`
    - `FTC-0930` -> `Matched` at `#VALUE!`
- `FTC-0941`
  - `=SUM(FILTER({1,2,3,4,5},ISNA(XMATCH({1,2,3,4,5},{2,4,6,8}))))`
  - OxFml `#CALC!` vs Excel `9.0`
  - read: direct `FILTER`/`XMATCH` boolean-mask semantics mismatch
- `FTC-0959`
  - `=LET(n,12,SUMPRODUCT(--(GCD(SEQUENCE(n),n)=1)))`
  - OxFml `#VALUE!` vs Excel `1.0`
  - read: direct `GCD`/array coercion mismatch
- `FTC-0966`
  - `=LET(probs,{0.5,0.25,0.125,0.125},H,-SUMPRODUCT(probs,LOG(probs,2)),ROUND(H,4))`
  - OxFml `#VALUE!` vs Excel `1.75`
  - read: direct `LOG`/array `SUMPRODUCT` mismatch
- `FTC-1032`
  - calendar-grid / `WRAPROWS` / `INDEX(...,1,0)` formula
  - original tail rerun was OxFml `21.0` vs Excel `0.0`, but focused follow-up proved a two-step reduction:
    - OxFunc commit `15a91ac` fixed the primary multi-arg `AND(array,array)` scalarization seam, and direct-host witnesses at `target/triage/ftc-1032-0907-and-witnesses-after-15a91ac-normal-batch-output` moved green for `=AND({FALSE;TRUE;TRUE},{TRUE;TRUE;TRUE})`, `=LET(grid,SEQUENCE(7),AND(grid>1,grid<=3))`, and `=IF(AND(...),SEQUENCE(3),0)`
    - the residual is now cleanly at direct `WRAPROWS` scalar-input semantics, proven at `target/triage/ftc-1032-0907-residual-witnesses-normal-batch-output`:
      - `=WRAPROWS(0,7)` -> OxFml array `{0,#N/A,#N/A,#N/A,#N/A,#N/A,#N/A}` vs Excel scalar `0`
      - `=INDEX(WRAPROWS(0,7),1,0)` -> same retained divergence
      - `=SUM(INDEX(WRAPROWS(0,7),1,0))` -> OxFml `#N/A` vs Excel `0`

### 3.2 Higher-order lambda / callable semantics gaps

These look like a separate higher-order evaluation lane rather than ordinary scalar function exactness.

- `FTC-0902`
  - recursive lambda row-builder
  - fresh decomposition at `target/triage/ftc-0902-decomposition-normal-batch-output` first showed this does not reduce to Pascal/HSTACK semantics:
    - `FTC-0902-WIT-HSTACK-CONTROL` -> `Matched` at `2.0`
    - `FTC-0902-WIT-SELF-CARRIER-CONTROL` (`=LET(row,LAMBDA(self,LAMBDA(n,n)),row(row)(7))`) -> `Blocked`
    - `FTC-0902-WIT-SELF-BASE`, `FTC-0902-WIT-SELF-STEP`, `FTC-0902-WIT-FULL-N1`, and retained `FTC-0902` all block with the same OxFml execution failure: only immediate, helper-bound, defined-name, or lambda-valued callable invocation is supported; callee evaluated to `Error`
  - repo-local OxFml follow-up then found the exact reduced witness set is likely entangled with the existing built-in-collision frontier rather than proving a fresh generic callable bug:
    - exact `row(...)` forms block locally
    - equivalent non-colliding forms using helper name `grow` are green locally
    - direct non-LET self-application is also green locally
  - DnaOneCalc host batch `target/triage/ftc-0902-grow-noncolliding-normal-batch-output` now confirms all non-colliding analogues are green end-to-end:
    - `grow(grow)(7)` -> `Matched` at `7.0`
    - recursive `grow(grow)(0)` -> `Matched` at `1.0`
    - full grow analogue at `n=1` -> `Matched` at `2.0`
    - full grow analogue at `n=5` -> `Matched` at `32.0`
  - fresh host boundary matrix `target/triage/builtin-name-callable-collision-boundary-normal-batch-output` now proves the broader rule family: callable-position collision alone is sufficient even without nesting; aliasing a colliding binding through a non-colliding LET name escapes the collision; and in nested self-application forms the outer callable position is what matters
  - concrete host examples from that matrix:
    - `=LET(row,LAMBDA(n,n),row(7))` -> OxFml `#VALUE!` vs Excel `programmatic_authoring_rejected` `0x800A03EC`
    - `=LET(row,LAMBDA(n,n),row(A1))` -> `Matched` `1.0` with observed Excel rewrite to `ROW(A1)`
    - `=LET(row,LAMBDA(self,LAMBDA(n,n)),g,row,g(row)(7))` -> `Matched` `7.0`
    - `=LET(row,LAMBDA(self,LAMBDA(n,n)),g,row,row(g)(7))` -> blocked / authoring-rejected
    - `T`, `SUM`, and `GCD` direct colliding forms also rewrite to the built-in and match built-in outputs, so ROW does not look special in the collision rule itself
  - OxFml landed commit `67a2429` (`Expand built-in callable collision frontier`) as a generic metadata-driven bind-boundary expansion for this family, not a ROW-specific patch
  - focused host proving rerun `target/triage/row-collision-frontier-after-67a2429-normal-batch-output` now shows the blocked ROW collision family aligned at the pre-execution / authoring frontier rather than falling through to OxFml runtime failure:
    - `=LET(row,LAMBDA(n,n),row(7))` -> `Matched` via typed pre-execution rejection
    - `=LET(row,LAMBDA(self,LAMBDA(n,n)),row(row)(7))` -> `Matched` via typed pre-execution rejection
    - `=LET(row,LAMBDA(self,LAMBDA(n,n)),g,row,row(g)(7))` -> `Matched` via typed pre-execution rejection
    - retained `FTC-0902` -> `Matched` via typed pre-execution rejection
    - accepted controls remain green (`ROW(A1)` -> `1.0`, aliased `g(7)` / `g(row)(7)` -> `7.0`, and direct `T` / `SUM` / `GCD` collision controls still mirror built-in outputs)
  - this closes `FTC-0902` as an active lane; preserve it as resolved evidence for the broader built-in callable-collision frontier
- `FTC-0981`
  - higher-order `SET(...)` lambda updater
  - earlier tail rerun was red, but fresh current-status corpus-ID rerun at `target/triage/ftc-0902-0981-0999-1013-0886-current-status-normal-batch-output/cases/FTC-0981` is now `Matched` with `219.0` on both sides; treat as stale-current-status noise unless a future rerun reopens it
- `FTC-0999`
  - applicative lambda / `MAP` / `TOCOL`
  - original status was OxFml `#VALUE!` vs Excel `#CALC!`
  - focused host decomposition at `target/triage/ftc-0999-decomposition-normal-batch-output` first showed the earliest live seam was array-of-lambdas construction / publication via `MAP`, not `TOCOL`, not `SUM`, and not lambda-element invocation:
    - `=LET(fns,MAP({1,2,3},LAMBDA(n,LAMBDA(x,x*n))),fns)` -> originally OxFml array `{#VALUE!,#VALUE!,#VALUE!}` vs Excel array `{#CALC!,#CALC!,#CALC!}`
    - `=LET(fns,MAP({1,2,3},LAMBDA(n,LAMBDA(x,x*n))),INDEX(fns,1)(10))` -> `Matched` at `10.0`
  - OxFml landed commit `7a4a9e0` (`Publish lambda array carriers as calc`) and focused host proof at `target/triage/ftc-0999-after-7a4a9e0-normal-batch-output` cleared that first publication seam
  - fresh residual decomposition at `target/triage/ftc-0999-residual-after-7a4a9e0-decomposition-normal-batch-output` then showed the next live seam was already at nested MAP application, not `TOCOL` and not `SUM`
  - separating batch `target/triage/higher-order-callable-boundary-separating-witnesses-normal-batch-output` narrowed that further to callable-parameter invocation inside `MAP`
  - OxFunc stopped cleanly on owner grounds, and OxFml then landed commit `837f2a0` (`Rehydrate callable MAP parameters`) for callable-carrier array rehydration before MAP-parameter invocation
  - focused host proving rerun `target/triage/ftc-0999-after-837f2a0-normal-batch-output` now shows the lane fully green:
    - `FTC-0999-WIT-MAP-CALLABLE-PARAM-10` -> `Matched` at array `{10,20,30}`
    - `FTC-0999-WIT-MAP-CALLABLE-PARAM-LET-G` -> `Matched` at array `{10,20,30}`
    - `FTC-0999-WIT-NESTED-MAP` -> `Matched` at `#CALC!`
    - `FTC-0999-WIT-FNS-BUILDER` -> `Matched` at array `{#CALC!,#CALC!,#CALC!}`
    - `FTC-0999-WIT-INVOKE-FIRST-FN` -> `Matched` at `10.0`
    - retained `FTC-0999` -> `Matched` at `#CALC!`
  - this lane is now cleared; preserve the decomposition chain as resolved evidence, not as an active live red

Likely related recursive-lambda rows with incomplete Excel summary values:
- `FTC-0936`
- `FTC-0937`
- `FTC-0939`
- `FTC-0992`

### 3.3 Parser / authoring frontier lane

Current split after OxFml parser/authoring commit `07fd4eb` (`Fix parser authoring for error literals and quoted XML`):

Resolved parser/authoring rows:
- `FTC-0837`
  - `=SUM(TOCOL({1,2,#N/A;4,5,6},1))`
  - local root cause was error-literal tokenization/binding (`#N/A` was not previously admitted cleanly)
  - fresh DnaOneCalc rerun now `Matched` with `Error · #N/A` on both sides
- `FTC-1041`
  - `=FILTERXML("<items><item id=""1"">apple</item><item id=""2"">banana</item></items>","//item[@id=2]")`
  - local root cause was doubled-quote string-literal lexing inside the XML argument
  - fresh DnaOneCalc rerun now `Matched` with `Text · banana` on both sides

Residual authoring-reject rows from the original parser bucket were:
- `FTC-0916`
- `FTC-0987`

Current read after the focused host-side follow-up:
- the exact corpus formula is still unbalanced
- OxFml local parse still emits a single `expected ')'` diagnostic at EOF
- Excel still reports `programmatic_authoring_rejected` / `0x800A03EC` with normalized `execution_outcome`
- DnaOneCalc commit `dc6a0a4` (`Normalize syntax rejection execution outcomes`) safely narrowed the host comparison seam by synthesizing OxFml pre-execution rejection execution_outcome only for explicit syntax/authoring diagnostic failures
- fresh proving rerun `target/triage/ftc-0916-0987-after-host-syntax-rejection-normalization-output` now shows both rows `Matched` via typed execution_outcome equivalence

### 3.4 Error-class mismatches

These may collapse into the semantics lanes above, but should remain explicit during triage.

- `FTC-0886`
  - corpus-ID row is now `Matched` on fresh current-status rerun at `target/triage/ftc-0902-0981-0999-1013-0886-current-status-normal-batch-output/cases/FTC-0886`
  - decomposition batch `target/triage/ftc-0886-decomposition-normal-batch-output` still exposed an adjacent narrow seam worth remembering:
    - `TAKE(...,,0)` alone is `Matched` at `#CALC!`
    - `HSTACK` over branches where one side is an empty-carrier / `TAKE(...,,0)` result yields OxFml shaped arrays with embedded `#CALC!` while Excel collapses to scalar `#CALC!`
  - useful doctrinally, but not currently a live corpus mismatch
- `FTC-0999`
  - also listed above
  - OxFml `#VALUE!` vs Excel `#CALC!`
- `FTC-1013`
  - originally OxFml `2211.0` vs Excel `#DIV/0!`
  - OxFml landed narrow local fix commit `ffdf2e9` (`Honor case-insensitive LET lambda shadowing`)
  - focused DnaOneCalc proving rerun `target/triage/ftc-1013-shadowing-after-ffdf2e9-normal-batch-output` now shows:
    - `FTC-1013` -> `Matched` at `#DIV/0!`
    - `FTC-1013-WIT-SHADOW-DIV-N` -> `Matched` at `{#DIV/0!;1;0.5;0.3333333333333333}`
    - `FTC-1013-WIT-CONV-MAP` -> `Matched` at `{#DIV/0!;2;1;0.6666666666666666}`
  - this lane is now cleared; keep as resolved evidence, not as an active live red

### 3.5 Excel programmatic authoring-rejection / execution-outcome cluster

This lane is now closed by DnaOneCalc host compare-normalization.

Tail rows in this slice:
- `FTC-0895`
- `FTC-0919`
- `FTC-0936`
- `FTC-0937`
- `FTC-0939`
- `FTC-0992`

Broader cluster owner-local closure:
- DnaOneCalc commit `2f71033` (`Normalize Formula2 authoring rejection execution outcomes`)
- focused proof batch `target/triage/execution-outcome-cluster-28-after-2f71033-normal-batch-output`
- result: `28 Matched / 0 Blocked / 0 Mismatched`

Common retained signature that now normalizes to typed pre-execution equivalence:
- `outcome_kind = programmatic_authoring_rejected`
- `outcome_stage = programmatic_formula_authoring`
- `error_kind = excel_com_formula_authoring_rejected`
- `0x800A03EC`
- `capture_artifacts_emitted = false`
- `oxxlplay/views/normalized-replay.json` contains only `execution_outcome`

Current closure read:
- these were honest execution-outcome mismatches caused by Excel Formula2/programmatic authoring rejection
- they were not missing-retention bugs
- they are now resolved generically on the host path rather than by repo-by-repo semantic fixes

## 4. Recommended working order

Proceed in this order unless fresh retained evidence changes the read:

1. No fresh current-status live red is currently established from retained evidence in this slice after the latest closures
   - post-closure watchlist checks are also green:
     - `target/triage/ftc-1006-1007-watchlist-current-status-normal-batch-output` -> `FTC-1006` and `FTC-1007` both `Matched`
     - `target/triage/ftc-0046-0048-0074-0093-error-code-current-status-normal-batch-output` -> representative old error-code family all `Matched`, supporting stale compare-normalization-noise read for adjacent `FTC-0047` / `FTC-0049` / `FTC-0063` / `FTC-0086`
     - `target/triage/ftc-0151-0180-discovery-normal-batch-output` -> `30/30 Matched`, so that next low-ID tranche did not surface a surviving live candidate either
2. Recently cleared or demoted from the same slice and worth preserving as resolved evidence
   - `FTC-0999` -> cleared after `837f2a0` host proof
   - `FTC-1013` -> cleared after `ffdf2e9` host proof
   - `FTC-0902` -> demoted to ROW-collision / witness-quality frontier after non-colliding host-green analogues
3. Recently closed execution-outcome family worth preserving as resolved evidence
   - `FTC-0895`, `FTC-0919`, `FTC-0936`, `FTC-0937`, `FTC-0939`, `FTC-0992`
   - broader closure proof: `target/triage/execution-outcome-cluster-28-after-2f71033-normal-batch-output`
4. Adjacent doctrine-only seams to remember, but not current corpus-ID reds
   - `FTC-0886` decomposition HSTACK empty-carrier collapse

## 5. Coordinator note

Use this file as the fresh tail-of-corpus working list rather than relying on stale raw `Open` monitor rows for `FTC-0800+`.

When a case or family goes green on a fresh rerun, fold the resolution into:
- `reference/test-corpus/workspace/monitoring/campaign-notes.jsonl`
- `reference/test-corpus/workspace/monitoring/NEXT_FORMULA_WORK_BOARD.md`

and keep this file as the durable starting snapshot for the 800-to-end sweep.
