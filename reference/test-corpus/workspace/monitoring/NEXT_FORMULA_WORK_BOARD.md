# Next Formula Work Board

This board is the coordinator summary of what to work on next, based on the current retained notes in `campaign-notes.jsonl`.

Planning rule used here:
- sequence over schedule,
- do not reopen families whose real semantic mismatch was cleared and is now only policy-blocked,
- prefer durable capture-contract fixes over ad hoc policy relaxation when the real gap is missing retained context,
- prefer witness-deepening or fresh retained-red families over already-understood policy gates.

## 1. Active cross-repo rollout lane

The highest-value long-term lane is now the Excel render-context capture contract for locale-sensitive text comparison.

Use the dedicated notes here:

> reference/test-corpus/workspace/monitoring/EXCEL_RENDER_CONTEXT_CAPTURE_SPEC_AND_ROLLOUT.md

> reference/test-corpus/workspace/monitoring/EXCEL_SEPARATOR_FORMATTING_THEORY_NOTE.md

> reference/test-corpus/workspace/monitoring/EXCEL_NUMERIC_CUTOFF_AND_EXACTNESS_THEORY_NOTE.md

Current rollout target:
- replace the current blunt unpinned-render host block with a principled capture-driven contract,
- keep semantic scope unchanged,
- support one-hop render-context indirection so many tests can share one captured context object.

Planned owner sequence:
- `Foundation` — lock working contract and acceptance criteria,
- `OxXlPlay` — capture effective Excel render context as retained artifact(s),
- `DnaOneCalc` — resolve captured context and make comparison eligibility depend on it,
- `OxReplay` — preserve and expose render-context provenance/reliability in replay/diff/explain,
- `Foundation` — rerun the blocked family and verify the stronger contract.

Current rollout status:
- `Foundation`: working contract landed at `monitoring/EXCEL_RENDER_CONTEXT_CAPTURE_SPEC_AND_ROLLOUT.md`.
- `OxReplay`: first slice landed in commit `dc96b0b` (`Add one-hop render context support for display diff`).
- `OxXlPlay`: first slice landed in commit `2b303a4` (`Retain first-class Excel render context artifact`).
- `DnaOneCalc`: first slice landed in commit `1c25263` (`Add render context refs to verification batches`).
- `DnaOneCalc` then closed the host-consumption seam in commit `e5f8ac3` (`Consume captured render context in verification`).
- Cross-repo proving-family rerun at `target/triage/ftc-0288-1021-1023-1024-1028-1040-after-render-context-consumption/cases/` now shows the render-context path is exercised end-to-end on the host path:
  - `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` moved from policy-Blocked to `Matched` with trusted render-context provenance `oxxlplay_capture_artifact` and render_locale_source `oxxlplay_render_context_capture`.
  - `FTC-0288` remains blocked, but now as a real unequal-text case rather than a missing-context case.
- New empirical follow-up now narrows the surviving question further:
  - `FTC-0288` is separator-context-sensitive semantics, not a generic locale-policy block.
  - On the current default host state (`UseSystemSeparators = true`, thousands separator = NBSP), Excel observed `=TEXT(1234567.89,"#,##0.00") -> "1234,567.89"`.
  - When Excel was forced to `UseSystemSeparators = false`, `DecimalSeparator = "."`, `ThousandsSeparator = ","`, the same formula rendered `"1,234,567.89"`.
- Sibling repo progress on the active lane:
  - `OxFml` landed witness-first commit `42c9d3c` (`Add FTC-0288 separator-context witnesses`).
  - `OxFml` then landed active-anchor formatter commit `a1deee2` (`Honor separator context in TEXT grouping`), making `=TEXT(1234567.89,"#,##0.00")` separator-context-aware for the currently evidenced comma-thousands vs NBSP-thousands distinction.
  - `DnaOneCalc` landed prep commit `8383b96` (`Prepare verification locale context for render state`).
  - `DnaOneCalc` then landed follow-up commit `217c2f3` (`Import captured separator details from render context`), preserving captured `list_separator`, `date_separator`, and `time_separator` instead of dropping them.
  - `DnaOneCalc` then landed host semantic-delivery commit `3110e1c` (`Feed captured separators into verification locale context`), overriding concrete separator fields in the rerun `LocaleFormatContext.profile` before feeding `TypedContextQueryBundle`.
  - Proving rerun at `target/triage/ftc-0288-1021-1023-1024-1028-1040-after-separator-aware-rerun/cases/` is now fully green:
    - `FTC-0288`, `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` are all `Matched`.
  - Retained proof for `FTC-0288` now shows the separator-aware host path actually engaged:
    - `oxfml-execution-context.json` records `execution_phase = "post_capture_trusted_refresh"`,
    - the locale query-bundle profile now carries captured separators,
    - `oxfml-runtime-summary.json` and `oxfml-v1-replay-projection.json` both moved to `1234,567.89`,
    - and `commands/oxreplay-diff.json` is now equivalent.
- Adjacent Excel-only probing for date/time separators did **not** reproduce an FTC-0288-style dependency on numeric separator controls:
  - changing `UseSystemSeparators` / `DecimalSeparator` / `ThousandsSeparator` did not change `m/d/yyyy` or `h:mm:ss` outputs on the current host,
  - expanded retained matrix at `OxXlPlay/.tmp/ftc-date-time-separator-probe-expanded/results.json` also showed token-looking, quoted, and escaped slash/colon forms collapsing to the same rendered output on this host while preserving distinct `NumberFormat`/`NumberFormatLocal` syntax,
  - but the result is still not a full literal-vs-token proof because current host date/time separators are already `/` and `:` and Excel COM did not expose writable `DateSeparator` / `TimeSeparator` properties in that session.
- New separator-family widening evidence shows the comma lane is broader than the original active anchor:
  - `OxFml` landed witness-first commit `0397746` (`Add trailing-comma separator context witnesses`), adjacent-matrix commit `a5b87e3` (`Add FTC-0288 adjacent matrix witnesses`), and rule-edge witness commit `b5207e3` (`Add FTC-0288 rule edge witnesses`).
  - `OxXlPlay` landed retained empirical matrices at:
    - `OxXlPlay/.tmp/ftc-0288-adjacent-comma-matrix/results.json`
    - `OxXlPlay/.tmp/ftc-0288-comma-family-widen/results.json`
    - `OxXlPlay/.tmp/ftc-0288-decimal-token-probe/results.json`
  - Current Excel evidence now says separator-context sensitivity affects not only `#,##0.00`, but also shapes like `#,,`, `0,,`, `#,##0,,`, `#,,,`, `0,,,`, `#,##0,,,`, `#,###`, `#,##`, `##,##0.00`, `#.0,`, and `0.0,,"M"`.
  - Current surprise/non-surprise result: the widened Excel-backed rows did **not** expose a fresh OxFml mismatch; the local engine matched the tested matrices, so the family-level rule surface is broader than the original anchor but no new retained red has been found yet.

## 2. Active repo-assignment queue

Active exactness-convergence lane:
- Under the current exact-value policy, tiny direct-call float mismatches should now be actively characterized rather than casually parked.
- Routing rule now in use:
  - if retained evidence points to post-function evaluation/publication rounding or canonicalization, route to `OxFml`,
  - if retained evidence shows the direct-call function result passes through unchanged, route to `OxFunc` for function-evaluation convergence work.
- For the current stats/finance mini-cluster, `OxFml` repo-local inspection found no generic post-function numeric rounding/canonicalization seam; direct-call function results pass through unchanged from evaluation to publication/comparison.
- The first active slice was `OxFunc` convergence work on the direct function kernels `SKEW` / `FTC-0374` and `KURT` / `FTC-0375`.
- `OxFunc` first landed witness commit `2306666` (`test: pin skew and kurt exactness witnesses`) in `crates/oxfunc_core/tests/oxfml_seam_integration.rs`, confirming via Rust-side adapter witnesses that current local `SKEW`/`KURT` values matched current OxFml exactly while remaining bitwise unequal to the Excel targets.
- `OxFunc` then landed convergence commits:
  - `6d22abe` — `fix: align skew exactness with excel witness`
  - `d9a36d0` — `fix: align kurt exactness with excel witness`
- DnaOneCalc normal host rerun at `target/triage/ftc-0374-0375-after-d9a36d0` now shows both green:
  - `FTC-0374` → `Matched`
  - `FTC-0375` → `Matched`
- The next active direct-function exactness slice moved to the non-iterative financial pair:
  - `PMT` / `FTC-0377`
  - `NPV` / `FTC-0382`
- `OxFunc` then landed `7d81f8c` (`fix: align npv exactness and pin pmt witness`), and DnaOneCalc rerun `target/triage/ftc-0377-0382-after-7d81f8c` now shows:
  - `FTC-0382` → `Matched`
  - `FTC-0377` → still `Blocked`
- PMT then received an additional bounded arithmetic-order pass in OxFunc. That pass did not yield a single non-branching formulation that both hits `FTC-0377` exactly and preserves broader pinned annuity publication rows, so the PMT lane is now deep-blocked for higher-level assistance.
- Use the escalation bundle here:
  > reference/test-corpus/workspace/monitoring/EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md
- DnaOneCalc refreshed the iterative pair at `target/triage/ftc-0381-0383-normal-batch-output` and confirmed both were still current tiny exactness drift only at that point.
- `OxFunc` then landed witness commit `12bfff9` (`tests: pin FTC-0381 RATE exactness witness gap`) and completed a bounded local RATE pass. That pass showed the current published local RATE value is partly explained by early-stop tolerance, but tighter solve plus multiple balance-equation conditioning variants still did not reach the Excel bits exactly.
- So `RATE` is no longer just a generic follow-on; it is now bounded to a shared annuity balance-evaluation conditioning lane beyond RATE-specific stopping tolerance alone. Use the escalation bundle here:
  > reference/test-corpus/workspace/monitoring/EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md
  and the agent-ready handoff prompt here:
  > reference/test-corpus/workspace/monitoring/EXACTNESS_HIGHER_LEVEL_ESCALATION_PROMPT.md
- `OxFunc` then treated `IRR` on its own cashflow/`NPV` substrate, landed `3dc35ad` (`cashflow: refine IRR plateau publication exactness`), and DnaOneCalc rerun `target/triage/ftc-0383-only-normal-batch-output` now shows:
  - `FTC-0383` / `IRR` → `Matched`
- That leaves `PMT` and `RATE` as the remaining deep-blocked exactness escalation candidates from this mini-cluster.
- After parking that exactness slice, DnaOneCalc reran the earliest stale unresolved semantic batch `FTC-0046/0047/0048/0049/0063/0074/0086/0093` and found it fully green on the current host path, so it should not be reopened as a live routing family.
- The next fresh current-host family candidate after that stale batch was `FTC-0353`:
  - `=LET(d,{"a",1,"",2,"b"},COUNTBLANK(d))`
  - retained mismatch root: `target/triage/ftc-0254-0353-0365-0366-0369-0391-0393-0394-0395-0399-normal-batch-output`
  - OxFunc then landed `bda031d` (`countblank: shape opaque array value errors`), and DnaOneCalc rerun `target/triage/ftc-0353-only-normal-batch-output` now shows `FTC-0353` → `Matched` with aligned `1x5` array-of-`#VALUE!` payloads.
- That same rerun-first batch also showed the remaining live members there are now all tiny numeric exactness drifts, not fresh shape contradictions. The next active non-escalation slice should therefore come from those exactness rows rather than reopening stale or already-fixed semantics families.

Current read:
- `FTC-0176` and adjacent witness `FTC-0878` are now green after the OxFml IF wrapper-seam patch and normal host rerun.
- `FTC-0288` is green and parked unless a fresh separator-sensitive retained red appears.
- `FTC-0376` is now green after DnaOneCalc commit `f6e3616` canonicalized compare-ready array envelopes for OxReplay admission; this closed a DnaOneCalc → OxReplay handoff seam rather than an OxFml semantics bug.
- The original host rerun `target/triage/ftc-0370-0390-normal-batch-output` left `FTC-0374`, `FTC-0375`, `FTC-0377`, `FTC-0381`, `FTC-0382`, and `FTC-0383` blocked.
- After the OxFunc `SKEW`/`KURT` convergence commits, current host rerun `target/triage/ftc-0374-0375-after-d9a36d0` clears the first two.
- Current tighter exactness-cluster read:
  - `FTC-0374` was the clearest exactness witness, with retained diff detail explicitly reading `finite numeric comparison values differ by 1 ULP`; it is now resolved.
  - `FTC-0375` was the adjacent shared-kernel exactness witness; it is now resolved.
  - `FTC-0382` is now also resolved after the OxFunc `NPV` numeric-path change.
  - `FTC-0383` is now resolved after the OxFunc `IRR` plateau-publication refinement and host rerun.
  - `FTC-0377` and `FTC-0381` remain the live members of the mini-cluster.
  - `FTC-0377` / `PMT` is now a deep-blocked escalation candidate after multiple bounded arithmetic-order passes.
  - `FTC-0381` / `RATE` is now also bounded beyond simple stopping tolerance: current host/local publication is influenced by `RATE_TOLERANCE`, but tighter solve still misses Excel, so the remaining seam appears to be annuity balance-evaluation conditioning on the shared substrate.
- The former next non-exactness lane `FTC-0353` is now resolved:
  - DnaOneCalc retained compare-ready payloads originally showed OxFml scalar `{ kind: error, code: Value }` vs Excel `{ kind: array, shape: { rows: 1, cols: 5 }, cells: [[Value, Value, Value, Value, Value]] }`.
  - Current owner read was OxFunc-first doctrine work around `COUNTBLANK` array substitute handling / shaped error propagation, not an OxFml publication seam.
  - OxFunc commit `bda031d` implemented the bounded single-array-substitute fix and DnaOneCalc host rerun `target/triage/ftc-0353-only-normal-batch-output/cases/FTC-0353` is now green.
- Current next active slice after `FTC-0353`:
  - a rerun-first cluster from `target/triage/ftc-0254-0353-0365-0366-0369-0391-0393-0394-0395-0399-normal-batch-output`
  - current live members there are partitioned as:
    - weaker adjacent boundary-review: `FTC-0399`
    - broader financial exactness: `FTC-0391`, `FTC-0393`, `FTC-0394`, `FTC-0395`
  - `OxFunc` drove the smaller shared paired-stats kernel first, landed `e6b33f8` (`stats: refine paired correlation exactness`), and DnaOneCalc rerun `target/triage/ftc-0365-0366-0369-normal-batch-output` now shows:
    - `FTC-0365` → `Matched`
    - `FTC-0366` → `Matched`
    - `FTC-0369` → `Matched`
  - `FTC-0254` is now resolved on a widened empirical family, not just the anchor row. OxFunc landed `2f954b1` (`multinomial: widen machine-witness coverage`), and DnaOneCalc ad hoc host proving batch `target/triage/multinomial-widened-after-2f954b1-normal-batch-output` shows the widened family green for `=MULTINOMIAL(2,3,4)`, `=MULTINOMIAL(2,4,3)`, `=MULTINOMIAL(0,2,3)`, `=MULTINOMIAL(2,7)`, `=MULTINOMIAL(1,2,3,4)`, `=MULTINOMIAL(2,3,4,5)`, plus control `=FACT(9)/(FACT(2)*FACT(3)*FACT(4))`.
  - keep `EXCEL_DISPLAY_VS_MACHINE_NUMERIC_BOUNDARY_NOTE.md` as the durable doctrine record so worksheet `=` and display text are not misused as raw-numeric revealers in future lanes.
  - the next live direct-call financial exactness rows from the same retained batch remain:
    - `FTC-0391` / `PPMT(0.05/12,1,360,200000)` → Blocked, OxFml `-240.30991269094295`, Excel `-240.3099126909447`
    - `FTC-0393` / `CUMIPMT(0.05/12,360,200000,1,12,0)` → Blocked, OxFml `-9932.988261156379`, Excel `-9932.988261156375`
    - `FTC-0394` / `CUMPRINC(0.05/12,360,200000,1,12,0)` → Blocked, OxFml `-2950.7306911349797`, Excel `-2950.7306911349597`
    - `FTC-0395` / `EFFECT(0.05,12)` → Blocked, OxFml `0.051161897881732976`, Excel `0.05116189788173342`
  - current owner split from OxFunc repo-local discovery and witness commit `187828a` (`tests: pin financial exactness witness gaps`):
    - `FTC-0391` / `FTC-0395` live in `crates/oxfunc_core/src/functions/financial_time_value_family.rs`
    - `FTC-0393` / `FTC-0394` live in `crates/oxfunc_core/src/functions/cumulative_finance_family.rs`
    - all four currently still read as direct-call OxFunc exactness rows rather than OxFml publication seams.
    - updated bounded classification after the first follow-on OxFunc probe pass:
      - `FTC-0395` / `EFFECT` remains an isolated rate-conversion lane, and OxXlPlay witness widening now shows `NOMINAL(EFFECT(0.05,n),n)` returns a machine value just below `0.05` for `n = 2, 4, 12, 365`
      - `FTC-0391` / `PPMT` collapses into the existing PMT annuity-substrate escalation lane rather than standing as an independent fix lane
      - `FTC-0393` / `FTC-0394` originally looked like a separate cumulative-interest wrinkle, but OxXlPlay witness widening showed exact Excel closure identity `CUMIPMT + CUMPRINC - 12*PMT = 0` with machine values aligned to shared payment publication
  - OxFunc then landed `8348648` (`cumulative-finance: refine exact payment closure`) in `crates/oxfunc_core/src/functions/cumulative_finance_family.rs`, switching the duplicated cumulative lane to shared grouped payment publication and cumulative-interest closure.
  - fresh DnaOneCalc host rerun `target/triage/ftc-0391-0393-0394-0395-after-8348648-normal-batch-output` confirms:
      - `FTC-0393` → `Matched`
      - `FTC-0394` → `Matched`
      - `FTC-0391` → still `Blocked`
      - `FTC-0395` → still `Blocked`
  - OxFunc then landed `c8704ff` (`financial: refine EFFECT exact publication`) in `crates/oxfunc_core/src/functions/financial_time_value_family.rs`, routing `EFFECT` compounding through `power_kernel(base, periods)` on the integer-truncation lane.
  - fresh DnaOneCalc host rerun `target/triage/ftc-0391-0395-after-c8704ff-normal-batch-output` confirms:
      - `FTC-0395` → `Matched`
      - `FTC-0391` → still `Blocked`
  - DnaOneCalc then landed `0e0a320` (`Preserve numeric witness lexemes in compare-ready replay`), removing the local compare-ready 1-ULP mutation seam for numeric comparison values by preserving numeric witness lexemes symmetrically in both `materialize_compare_ready_normalized_replay(...)` and `materialize_compare_ready_projection(...)`.
  - focused follow-up rerun `target/triage/compare-ready-numeric-witness-followup-batch-output` confirms:
      - `FTC-0391` remains `Blocked`, but now on preserved witness values rather than DnaOneCalc compare-ready drift
      - `FTC-0393` remains `Matched` with preserved witness lexemes on both sides
      - `MULTI-WIT-5-FOLLOWUP` remains `Matched` without raw-vs-compare-ready decimal coalescing
  - current next live row from this set is therefore only `FTC-0391`, and it should be tracked with the existing PMT annuity-substrate escalation lane rather than reopened as a separate local fix lane.
- `FTC-0630` remains a distinct exactness-policy / underflow-boundary hold, not part of this direct-function convergence lane.
- Late-stage fallback only if needed: if a function resists exact convergence after many improvement rounds, record it explicitly as not fully characterized and escalate with retained function name, parameter values, and failed-attempt context; do not jump to that fallback while the local convergence lane is still productive.

Fresh tail-of-corpus rerun work is now tracked separately in:

> reference/test-corpus/workspace/monitoring/FTC-0800-1042_FRESH_RERUN_TRIAGE_LIST.md

Current tail-of-corpus coordinator read:
- initial rerun `target/triage/ftc-0800-1042-normal-batch-output` left `27` blocked rows in `FTC-0800+`.
- OxFml parser/authoring commit `07fd4eb` then cleared two concrete parser rows on a focused host rerun `target/triage/ftc-0837-0916-0987-1041-after-07fd4eb-normal-batch-output`:
  - `FTC-0837` -> `Matched`
  - `FTC-1041` -> `Matched`
- that same focused rerun left `FTC-0916` and `FTC-0987` blocked even though both sides were now authoring rejects, which exposed a narrow host comparison-path gap rather than another parser semantics lane.
- DnaOneCalc then landed `dc6a0a4` (`Normalize syntax rejection execution outcomes`), synthesizing OxFml pre-execution rejection execution_outcome only for explicit syntax/authoring diagnostic failures when Excel is already in the normalized pre-execution rejection lane; focused rerun `target/triage/ftc-0916-0987-after-host-syntax-rejection-normalization-output` now shows:
  - `FTC-0916` -> `Matched`
  - `FTC-0987` -> `Matched`
- formula-level decomposition on the clean dynamic-array quartet reduced the next honest direct-call candidates to narrow seams, not broad whole-formula evaluation:
  - `FTC-0833` -> direct `INDEX` vector-selector handling
  - `FTC-0836` -> direct `SORTBY` multi-key handling
  - `FTC-0917` -> direct horizontal `SORT` default-axis semantics
  - `FTC-0828` initially looked like a possible `UNIQUE`/horizontal-`SORT` lane, but a later ad hoc host decomposition batch `target/triage/ftc-0828-decomposition-normal-batch-output` showed the original formula and its intermediate controls all currently `Matched`; treat `FTC-0828` as stale-current-status noise unless a fresh corpus-ID rerun reopens it
- OxFunc then landed `5f6e2f7` (`dynamic-array: fix row-vector index sort seams`), and focused rerun `target/triage/ftc-0833-0836-0917-after-5f6e2f7-normal-batch-output` now shows:
  - `FTC-0833` -> `Matched`
  - `FTC-0836` -> `Matched`
  - `FTC-0917` -> `Matched`
- DnaOneCalc artifact-deepening also established that `FTC-0895`, `FTC-0919`, `FTC-0936`, `FTC-0937`, `FTC-0939`, and `FTC-0992` are Excel programmatic authoring-rejection / execution-outcome rows, not missing-Excel-value summary bugs and not fresh compare-ready drift.
- OxFml decomposition on the duplicate set-difference pair `FTC-0941` / `FTC-0995` narrowed the next clean direct-call seam to `ISNA` array-lifting over array-valued input: `XMATCH` already returned the expected mixed array locally, `FILTER(...,{TRUE,FALSE,TRUE,FALSE,TRUE})` already worked locally, and the composite failed because `ISNA(array)` collapsed to scalar `FALSE` instead of producing an elementwise logical mask.
- OxFunc then landed `8c9d061` (`predicates: lift ISNA over array inputs`), and focused rerun `target/triage/ftc-0941-0995-after-8c9d061-normal-batch-output` now shows:
  - `FTC-0941` -> `Matched`
  - `FTC-0995` -> `Matched`
- OxFml decomposition then reduced the next two current reds independently to direct array-input seams:
  - `FTC-0959` -> direct `GCD` array-input / array-lifting semantics
  - `FTC-0966` -> direct `LOG` array-input / array-lifting semantics
- OxFunc then landed `b357976` (`math: admit direct GCD and LOG array inputs`), and focused rerun `target/triage/ftc-0959-0966-after-b357976-normal-batch-output` now shows:
  - `FTC-0959` -> `Matched`
  - `FTC-0966` -> `Matched`
- OxFml first reduced `FTC-1032` to multi-arg `AND` over array-valued inputs, and OxFunc then landed `15a91ac` (`and: scalarize multi-arg direct array calls`). Focused DnaOneCalc rerun `target/triage/ftc-1032-0907-and-witnesses-after-15a91ac-normal-batch-output` proved that primary seam was green, but not yet sufficient to clear `FTC-1032`.
- DnaOneCalc residual witness batch `target/triage/ftc-1032-0907-residual-witnesses-normal-batch-output` then narrowed the remaining active seams to:
  - `FTC-1032` -> direct `WRAPROWS` scalar-input semantics
  - `FTC-0907` -> single-array `AND` scalarization, not broader `MAP` / `FIND` / `TEXT`
- OxFunc then landed `85502a3` (`seams: scalarize direct AND and WRAPROWS residuals`), and focused DnaOneCalc rerun `target/triage/ftc-0907-1032-and-wraprows-after-85502a3-normal-batch-output` now shows all pinned seams and both corpus rows green:
  - `FTC-0907` -> `Matched`
  - `FTC-1032` -> `Matched`
  - `=WRAPROWS(0,7)` -> `Matched`
  - `=INDEX(WRAPROWS(0,7),1,0)` -> `Matched`
  - `=SUM(INDEX(WRAPROWS(0,7),1,0))` -> `Matched`
  - `=AND({TRUE;TRUE;TRUE})` -> `Matched`
  - `=AND({TRUE;FALSE;TRUE})` -> `Matched`
  - `=AND(MAP(SEQUENCE(3),LAMBDA(x,TRUE)))` -> `Matched`
- OxFml then also reduced `FTC-0910` cleanly, and DnaOneCalc host proving batch `target/triage/ftc-0910-decomposition-normal-batch-output` confirmed the first honest divergence was direct `INDEX(array, omitted_row, vector_column_selector)` window extraction, not `SEQUENCE` and not `AVERAGE`.
- OxFunc then landed `a8019d9` (`index: admit omitted-row selector arrays on row vectors`), and focused DnaOneCalc rerun `target/triage/ftc-0910-after-a8019d9-normal-batch-output` now shows the direct witnesses and the retained corpus row green:
  - `FTC-0910` -> `Matched` with OxFml `330.0` and Excel `330.0`
  - `=INDEX({10,20,30,40,50,60,70,80,90,100},,SEQUENCE(5,,1))` -> `Matched` as `{10;20;30;40;50}`
  - `=INDEX({10,20,30,40,50,60,70,80,90,100},,SEQUENCE(5,,6))` -> `Matched` as `{60;70;80;90;100}`
  - inherited witnesses `=AVERAGE(INDEX(...))` for both windows are also `Matched`
- So `FTC-0910` is now closed, and the next residual tail lane moves onward from the still-open set (`FTC-0886`, `FTC-0902`, `FTC-0930`, `FTC-0981`, `FTC-0999`, plus the authoring-rejection cluster and `FTC-1013` visibility).
- Focused host decomposition for `FTC-0930` at `target/triage/ftc-0930-decomposition-normal-batch-output` first pinned the next clean seam as `INDEX` error-class propagation over an errored source.
- OxFunc then landed `ef40c9a` (`index: propagate error-valued source results`), and focused DnaOneCalc rerun `target/triage/ftc-0930-after-ef40c9a-normal-batch-output` now shows:
  - `FTC-0930-WIT-INDEX-SORT-TOCOL-DESC` -> `Matched` at `#VALUE!`
  - `FTC-0930` -> `Matched` at `#VALUE!`
- So `FTC-0930` is now closed.
- Fresh current-status rerun `target/triage/ftc-0902-0981-0999-1013-0886-current-status-normal-batch-output` then removed more stale noise from the tail set:
  - `FTC-0981` -> `Matched` with OxFml `219.0` and Excel `219.0`
  - `FTC-0886` -> `Matched` with OxFml `#CALC!` and Excel `#CALC!`
- That same rerun identified the current real live reds in this slice as:
  - `FTC-0902` -> still blocked on a lambda/callable-boundary lane (no comparison value; OxFml rejection says only immediate/helper-bound/defined-name/lambda-valued callable invocation is supported)
  - `FTC-0999` -> still blocked with OxFml `#VALUE!` vs Excel `#CALC!`
  - `FTC-1013` -> still blocked with OxFml `2211.0` vs Excel `#DIV/0!`
- Decomposition side evidence from `target/triage/ftc-0886-decomposition-normal-batch-output` is still useful doctrinally even though `FTC-0886` itself is now green: adjacent witnesses show a narrow HSTACK empty-carrier / error-collapse seam, but that is not currently an active corpus-ID mismatch.
- Focused host decomposition for `FTC-0999` at `target/triage/ftc-0999-decomposition-normal-batch-output` now pins the first live seam as MAP publication of lambda-valued array results:
  - `=LET(fns,MAP({1,2,3},LAMBDA(n,LAMBDA(x,x*n))),fns)` -> OxFml array `{#VALUE!,#VALUE!,#VALUE!}` vs Excel array `{#CALC!,#CALC!,#CALC!}`
  - `=LET(fns,...,INDEX(fns,1)(10))` -> `Matched` at `10.0`
  - nested `MAP`, `TOCOL`, and final `SUM` only inherit the earlier mismatch
- Focused host decomposition for `FTC-1013` at `target/triage/ftc-1013-decomposition-normal-batch-output` now pins the first live seam as LET/LAMBDA case-insensitive name shadowing in the final inverse `MAP`, not trig kernels and not INDEX packing:
  - `FTC-1013-WIT-AR-MAP` -> `Matched`
  - `FTC-1013-WIT-INDEX-PACKING` -> `Matched`
  - `=LET(N,4,ks,SEQUENCE(N,,0),MAP(ks,LAMBDA(k,1/N)))` -> `Matched`
  - `=LET(N,4,ks,SEQUENCE(N,,0),MAP(ks,LAMBDA(n,1/N)))` -> OxFml `{0.25;0.25;0.25;0.25}` vs Excel `{#DIV/0!;1;0.5;0.3333333333333333}`
- No fresh active successor lane is currently established from retained evidence after `FTC-0999`.
- Repo split has now tightened further:
  - `FTC-0999` is now closed. After the earlier publication fix `7a4a9e0`, fresh decomposition at `target/triage/ftc-0999-residual-after-7a4a9e0-decomposition-normal-batch-output` and separating batch `target/triage/higher-order-callable-boundary-separating-witnesses-normal-batch-output` narrowed the remaining seam to callable-parameter invocation inside `MAP`. OxFunc stopped cleanly on owner grounds, OxFml landed commit `837f2a0` (`Rehydrate callable MAP parameters`), and focused host proving rerun `target/triage/ftc-0999-after-837f2a0-normal-batch-output` now shows:
    - `FTC-0999-WIT-MAP-CALLABLE-PARAM-10` -> `Matched` at array `{10,20,30}`
    - `FTC-0999-WIT-MAP-CALLABLE-PARAM-LET-G` -> `Matched` at array `{10,20,30}`
    - inherited `FTC-0999-WIT-NESTED-MAP` -> `Matched` at `#CALC!`
    - controls remain green at builder publication and direct `INDEX(fns,1)(10)` invocation
    - retained `FTC-0999` -> `Matched` at `#CALC!`
  - `FTC-0902` is now closed as a member of the broader built-in callable-collision frontier, not as a generic higher-order runtime bug. Host matrix `target/triage/builtin-name-callable-collision-boundary-normal-batch-output` first proved the rule family (callable-position collision alone is sufficient; aliasing escapes it; outer callable position is decisive in nested forms; ROW is not special except for accepted vs authoring-rejected built-in surfaces). OxFml then landed commit `67a2429` (`Expand built-in callable collision frontier`), and focused host proving rerun `target/triage/row-collision-frontier-after-67a2429-normal-batch-output` now shows the formerly blocked ROW collision family aligned at the pre-execution / authoring frontier:
    - direct colliding scalar, self-collision, inner-only collision, and retained `FTC-0902` are all now `Matched`
    - compare-ready projections now carry typed `execution_outcome` rejection metadata (`class_id = programmatic_formula_rejection`, `lane_reason_code = authoring_or_bind_rejected`, `outcome_kind = rejected`, `outcome_stage = pre_execution`)
    - accepted controls remain green (`ROW(A1)` -> `1.0`, aliased `g(7)` / `g(row)(7)` -> `7.0`, direct `T` / `SUM` / `GCD` collision controls still mirror built-in outputs)
  - `FTC-1013` is now closed: OxFml commit `ffdf2e9` (`Honor case-insensitive LET lambda shadowing`) proved green on focused DnaOneCalc rerun `target/triage/ftc-1013-shadowing-after-ffdf2e9-normal-batch-output`, including the retained row `FTC-1013` at `#DIV/0!` and the reduced witnesses.
- Follow-up sweep `target/triage/post-0999-next-candidate-sweep-normal-batch-output` reconfirmed `FTC-0981` is `Matched`, so no fresh non-hold next candidate is currently established. Fresh low-ID stale-noise checks since then also came back green:
  - `target/triage/ftc-1006-1007-watchlist-current-status-normal-batch-output` reconfirmed `FTC-1006` and `FTC-1007` are both `Matched`
  - representative old error-code case family `target/triage/ftc-0046-0048-0074-0093-error-code-current-status-normal-batch-output` is now all `Matched` (`FTC-0046`, `FTC-0048`, `FTC-0074`, `FTC-0093`), strongly suggesting adjacent `FTC-0047` / `FTC-0049` / `FTC-0063` / `FTC-0086` are stale compare-normalization noise too
  - fresh discovery tranche `target/triage/ftc-0151-0180-discovery-normal-batch-output` came back `30/30 Matched`, including previously noisy low-ID rows such as `FTC-0155`, `FTC-0157`, and `FTC-0176`
- Fresh full-corpus rerun `target/triage/full-corpus-1043-normal-batch-output-2026-04-23` materially resets the picture: `1043` total, `999 Matched`, `44 Blocked`, `0 Mismatched`. This is far greener than the current monitoring snapshot and means the remaining work is entirely in the blocked bucket.
- DnaOneCalc blocked-set summary from that fresh full rerun grouped the survivors as:
  - exactness / exact-policy holds: `FTC-0371`, `FTC-0377`, `FTC-0381`, `FTC-0391`, `FTC-0533`, `FTC-0630`
  - execution-outcome / programmatic-authoring cluster: `FTC-0050`, `FTC-0252`, `FTC-0253`, `FTC-0354`, `FTC-0355`, `FTC-0356`, `FTC-0362`, `FTC-0363`, `FTC-0602`, `FTC-0631`, `FTC-0632`, `FTC-0633`, `FTC-0675`, `FTC-0682`, `FTC-0691`, `FTC-0743`, `FTC-0750`, `FTC-0751`, `FTC-0757`, `FTC-0763`, `FTC-0771`, `FTC-0783`, `FTC-0895`, `FTC-0919`, `FTC-0936`, `FTC-0937`, `FTC-0939`, `FTC-0992`
  - genuinely live semantics/runtime candidates at that point: `FTC-0640`, `FTC-0654`, `FTC-0670`, `FTC-0692`, `FTC-0693`, `FTC-0696`, `FTC-0702`, `FTC-1043`
- Coordinated closure then cleared the top five fresh live lanes in one pass:
  - `OxFunc` commit `f8fa28f833ed937c3ab93fa5e1e569dfa07eaa5f` resolved `FTC-0670`, `FTC-0692`, `FTC-0693`, and `FTC-0702`
  - `OxFml` commit `d2dbbbd` resolved `FTC-1043`
  - focused DnaOneCalc proving rerun `target/triage/ftc-0670-0692-0693-0702-1043-after-f8fa28f-d2dbbbd-normal-batch-output` shows all five retained corpus rows and all five focused witnesses `Matched`
- Further owner-local closure then cleared the remaining serial-zero TEXT date seam:
  - `OxFunc` commit `3d4f9a83e9be9ec6dc7dee2f20344620c5059392` resolved `FTC-0696` by preserving Excel/Lotus-compatible serial-0 1900 date formatting in `locale_format.rs`
  - focused DnaOneCalc proving rerun `target/triage/ftc-0696-after-3d4f9a8-normal-batch-output` shows retained `FTC-0696` now `Matched` at `1900-01-00`, with boundary witnesses `=TEXT(1,"yyyy-mm-dd")` and `=TEXT(60,"yyyy-mm-dd")` also `Matched`
- `FTC-0654` then cleared on the rerouted OxFml lane:
  - `OxFml` commit `19fcfb9` resolved the unsupported `TEXT(...,"# ?/?")` fraction-placeholder seam in `crates/oxfml_core/src/format/number.rs`
  - focused DnaOneCalc proving rerun `target/triage/ftc-0654-after-19fcfb9-normal-batch-output` shows retained `FTC-0654` now `Matched` at `#VALUE!`, adjacent witness `=TEXT(0.5,"# ?/?")` also `Matched` at `#VALUE!`, and scientific control `=TEXT(12345.6789,"0.00E+00")` still green
- `FTC-0640` then cleared as the final fresh live non-exactness survivor from that shortlist:
  - `OxFunc` commit `ce9b4842e705a0e25191ea23d1a272a13af15f70` resolved the LEN surrogate-pair counting seam in `text_slice_family.rs`, while keeping `LENB` on the UTF-16-unit path in `text_b_compat_family.rs`
  - focused DnaOneCalc proving rerun `target/triage/ftc-0640-after-ce9b484-normal-batch-output` shows retained `FTC-0640` now `Matched` at `1`, and direct witness `=LEN("😀")` also `Matched` at `1`
- DnaOneCalc then closed the entire execution-outcome / programmatic-authoring cluster generically rather than row-by-row:
  - commit `2f71033` (`Normalize Formula2 authoring rejection execution outcomes`)
  - host rule: when Excel retains the stable Formula2 authoring rejection signature (`outcome_kind = programmatic_authoring_rejected`, `outcome_stage = programmatic_formula_authoring`, `error_kind = excel_com_formula_authoring_rejected`, `0x800A03EC`), synthesize the same typed pre-execution rejection compare-ready lane for OxFml instead of leaving the case blocked against an ordinary OxFml runtime value
  - focused proof batch `target/triage/execution-outcome-cluster-28-after-2f71033-normal-batch-output` shows the whole cluster green: `28 Matched / 0 Blocked / 0 Mismatched`
  - covered rows: `FTC-0050`, `FTC-0252`, `FTC-0253`, `FTC-0354`, `FTC-0355`, `FTC-0356`, `FTC-0362`, `FTC-0363`, `FTC-0602`, `FTC-0631`, `FTC-0632`, `FTC-0633`, `FTC-0675`, `FTC-0682`, `FTC-0691`, `FTC-0743`, `FTC-0750`, `FTC-0751`, `FTC-0757`, `FTC-0763`, `FTC-0771`, `FTC-0783`, `FTC-0895`, `FTC-0919`, `FTC-0936`, `FTC-0937`, `FTC-0939`, `FTC-0992`
- That exhausts both the fresh non-exactness live shortlist and the remaining execution-outcome blob from the full-rerun bucket.
- Derived current corpus position is now `1037 Matched / 6 Blocked / 0 Mismatched`, pending a fresh single full-corpus restamp.
- Fresh residual host batch `target/triage/post-power-residual-blocked-seven-normal-batch-output` now shows the surviving blocked-only picture is actually a 6-row set, not 7: `FTC-0573` / `=ERFC(1)` is green on current host state.
- Current practical next step is the exactness lane under the explicit Excel-emulation policy recorded in `EXACTNESS_EXCEL_BIT_REPRODUCTION_POLICY.md`.
- Immediate active slice:
  - keep `ERFC` / `ERFC.PRECISE` visible on the parked exactness TODO / frontier list at current best `30fdfe4` while broader source/algorithm evidence is still missing; fresh residual batch `target/triage/post-power-residual-blocked-seven-normal-batch-output` confirms the corpus anchor `FTC-0573` itself is currently green and should not be counted in the surviving blocked set,
  - keep `FTC-0371` / `NORM.INV` on that parked frontier as well: the widened inverse-normal sweep established that current `Acklam + Newton` is not a good Excel theory, plausible classical families plateau near `11/29`, and the only better local scores came from implausible gated variants that should not be shipped,
  - keep `FTC-0377` / `PMT` with adjacent `FTC-0391` / `PPMT` parked as a re-confirmed annuity-substrate escalation lane after the latest non-improving bounded algebra pass,
  - keep `FTC-0381` / `RATE` parked on the same annuity-substrate escalation frontier as well: fresh current-status plus a bounded tolerance/exit sweep showed early-stop tightening is only a partial improvement and still floors well short of Excel bits,
  - `FTC-0635` / `POWER` is now resolved after OxFunc commit `92eb272`, which aligned negative-base reciprocal odd-integer roots to Excel via `exp(power * ln(abs(base)))` and simultaneously restored Excel `#NUM!` behavior for the `2/3` seam,
  - no active direct-function exactness implementation lane remains after `POWER`; the remaining blocked picture is parked frontier exactness plus non-function / underflow-boundary holds (`FTC-0533`, `FTC-0630`).

When choosing the next active repo lane, prefer continuing the exactness / exact-policy hold doctrine under explicit Excel-bit reproduction and only reopen a fresh non-exactness lane if a new retained red appears on a new rerun.

## 3. Recently stabilized family: TEXT/date-format host contradiction

This lane is no longer the next semantics target.

Family members:
- `FTC-1021`
- `FTC-1022`
- `FTC-1023`
- `FTC-1024`
- `FTC-1028`
- `FTC-1040`

Current conclusion:
- The earlier raw host-path `Error(Value)` family was real, but the underlying cause was not missing visible locale metadata or missing verification publication context.
- The real contradiction was hidden inside caller-supplied `LocaleFormatContext` engines.
- `DnaOneCalc` confirmed `verification_locale_context(...)` in `src/dnaonecalc-host/src/services/verification_bundle.rs` supplied local `HOST_TEST_LOCALE_VALUE_PARSER` and `HOST_TEST_FORMAT_CODE_ENGINE` trait objects under otherwise ordinary-looking `EnUs` / `System1900` metadata.
- `OxFml` commit `0b0ca98` now canonicalizes incoming locale contexts for host/runtime execution so OxFml preserves the caller's locale profile and date system but rewrites parser/formatter engines to OxFml's own runtime engines.
- After that fix, the previous five-case `Error(Value)` family cleared on the normal host path.
- `FTC-1022` is now fully `Matched`.
- The earlier raw host-path `Error(Value)` family is closed.
- The render-context rollout is now also demonstrated end-to-end on the host path after DnaOneCalc commit `e5f8ac3` consumed retained `oxxlplay/render-context.json` artifacts into effective host render context.
- `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` are now `Matched` under trusted render-context provenance `oxxlplay_capture_artifact` with render_locale_source `oxxlplay_render_context_capture`.
- `FTC-0288` remains the surviving member of the family, but now as a real unequal-text case rather than a generic locale-policy block.
- New empirical separator-mode probing showed that `FTC-0288` is more specific than a generic comma-formatting bug: the observed Excel result depends on the effective separator state.
- That makes `FTC-0288` a semantics-bearing witness about format-string component interpretation, specifically how `,` is treated relative to effective thousands-separator behavior and whether trusted captured separator state must feed evaluation semantics.

Retained rerun roots:

> target/triage/ftc-1021-1022-1023-1024-1028-1040-after-0b0ca98/cases/

> target/triage/ftc-0288-1021-1023-1024-1028-1040-after-render-context-consumption/cases/

## 4. Hold / defer queue

These formulas should remain visible, but current notes do not support immediate patch work.

| Case | Owner | Current note | Hold reason |
|---|---|---|---|
| `FTC-0406` | `DnaOneCalc` | `external_precision_delta_last_bit_only` | exact-value red; triage label improved, but still a policy/equality decision rather than a fix-ready bug |
| `FTC-0533` | `DnaOneCalc` | `exact_value_red_after_host_fix_zero_residue_case` | fresh current-status rerun at `target/triage/ftc-0533-0630-current-status-normal-batch-output/cases/FTC-0533` remains blocked with OxFml `5.551115123125783e-17` vs Excel `0.0`; near-zero residue vs exact zero remains intentionally red under exact policy |
| `FTC-0630` | `Foundation` | `underflow_boundary_theory_stabilized_hold_under_exact_policy` | fresh current-status rerun at `target/triage/ftc-0533-0630-current-status-normal-batch-output/cases/FTC-0630` remains blocked with OxFml `2.225073858507203e-309` vs Excel `0.0`. Current retained evidence still supports a separate underflow-boundary bucket: literal rewrite-to-zero through `2.2250738585072099E-308`, first preserved literal at `2.2250738585072100E-308`, and preserved-literal `/2` rows still flushing to zero. Keep visible, but do not open a semantics patch without an explicit policy decision or fresh host/build variation evidence |
| `FTC-0371` | `OxFunc / Foundation` | `parked_exactness_frontier_inverse_normal_theory_not_yet_production_ready` | current widened host root `target/triage/norm-inv-algorithm-family-expanded-normal-batch-output` confirms the shared `NORM.INV` / `NORM.S.INV` core is still blocked against fresh Excel bits, with primary anchor `FTC-0371` at OxFml `1.9599639845400538` vs Excel `1.9599639845400536`. Current OxFunc implementation is `Acklam + Newton`; scratch family work showed plausible classical families top out around `11/29`, while only implausible gated variants reach `15/29`. Park this lane for now rather than shipping ad hoc gates; see `EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md` and `tmp/support-intelligence/ERFC_NORMINV_exactness_support_prompt.md` for the retained theory package |
| `FTC-0377` | `OxFunc / Foundation` | `deep_blocked_exactness_escalation_candidate` | fresh current-status rerun at `target/triage/ftc-0377-0391-current-status-normal-batch-output/cases/FTC-0377` remains blocked with OxFml `-1073.6432460242763` vs Excel `-1073.6432460242781`. Follow-on host and OxXlPlay evidence now tightens the local picture: `FTC-0391` stays attached as an inherited `PPMT` witness, current PMT call path is not blocked on `POWER(1+0.05/12,360)`, and Excel shows the cumulative identities close exactly on the same payment publication path. One further bounded scratch pass on plausible PMT algebra (`H2` / `H3` / `H5` and combinations) failed to improve the widened witness family without regression, so this lane is now cleanly parkable pending higher-level annuity-substrate assistance; see `EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md` |
| `FTC-0381` | `OxFunc / Foundation` | `deep_blocked_exactness_escalation_candidate` | fresh current-status rerun at `target/triage/ftc-0381-current-status-normal-batch-output/cases/FTC-0381` remains blocked with OxFml `0.0041666445363460975` vs Excel `0.004166644536345589`. A fresh bounded tolerance/exit sweep confirmed early-stop tolerance is only a partial explanation: tightening improves the row from `0x3f71110b20485999` to `0x3f71110b20485718`, but no tested tolerance/stability setting reaches Excel `0x3f71110b2048574f`, and prior balance-conditioning probes already failed to land a production-worthy local fix. This lane is therefore re-parked as a clean annuity-substrate escalation candidate; see `EXACTNESS_HIGHER_LEVEL_ESCALATION_CANDIDATES.md` |
| `FTC-0635` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_negative_base_reciprocal_odd_root_alignment` | resolved by OxFunc commit `92eb272` (`power: align negative-base reciprocal odd roots to Excel via exp/ln`). Fresh DnaOneCalc reruns at `target/triage/ftc-0635-current-status-after-92eb272-normal-batch-output/cases/FTC-0635` and `target/triage/power-negative-base-odd-denominator-after-92eb272-normal-batch-output/cases/` show retained `FTC-0635` now `Matched` at `-1.9999999999999998`, adjacent `=POWER(-27,1/3)` now `Matched` at `-2.9999999999999996`, `=POWER(-32,1/5)` still `Matched` at `-2.0`, and the prior `=POWER(-8,2/3)` seam now correctly `Matched` at `#NUM!` |
| `FTC-0503` | `OxFunc` | `volatile_deferred` | explicitly deferred volatile RANDARRAY work |
| `FTC-0504` | `OxFunc` | `volatile_deferred` | explicitly deferred volatile RANDARRAY work |
| `FTC-1043` | `OxFml / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_hstack_empty_carrier_collapse_fix` | resolved by OxFml commit `d2dbbbd`; focused DnaOneCalc rerun `target/triage/ftc-0670-0692-0693-0702-1043-after-f8fa28f-d2dbbbd-normal-batch-output` shows retained `FTC-1043` now `Matched` at scalar `#CALC!`, with adjacent empty-carrier HSTACK witnesses also green |
| `FTC-0670` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_valuetotext_array_publication_fix` | resolved by OxFunc commit `f8fa28f833ed937c3ab93fa5e1e569dfa07eaa5f`; focused DnaOneCalc rerun shows retained `VALUETOTEXT({"a","b";"c","d"},1)` now `Matched` as the quoted `2x2` text array |
| `FTC-0702` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_date_1900_phantom_day_alignment` | resolved by the same OxFunc commit; focused DnaOneCalc rerun shows `DAY(DATE(1900,3,0))` now `Matched` at `29`, and adjacent witness `DATE(1900,3,0)` also `Matched` at serial `60` |
| `FTC-0696` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_serial_zero_lotus_compat_text_date_fix` | resolved by OxFunc commit `3d4f9a83e9be9ec6dc7dee2f20344620c5059392`; focused DnaOneCalc rerun `target/triage/ftc-0696-after-3d4f9a8-normal-batch-output` shows retained `TEXT(0,"yyyy-mm-dd")` now `Matched` at `1900-01-00`, with boundary witnesses `TEXT(1,...)` -> `1900-01-01` and `TEXT(60,...)` -> `1900-02-29` also green |
| `FTC-0654` | `OxFml / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_unsupported_text_fraction_placeholder_rejection` | resolved by OxFml commit `19fcfb9`; focused DnaOneCalc rerun `target/triage/ftc-0654-after-19fcfb9-normal-batch-output` shows retained `TEXT(0.25,"# ?/?")` now `Matched` at `#VALUE!`, adjacent `TEXT(0.5,"# ?/?")` also `Matched` at `#VALUE!`, and scientific control `TEXT(12345.6789,"0.00E+00")` remains green |
| `FTC-0640` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_len_surrogate_pair_count_fix` | resolved by OxFunc commit `ce9b4842e705a0e25191ea23d1a272a13af15f70`; focused DnaOneCalc rerun `target/triage/ftc-0640-after-ce9b484-normal-batch-output` shows retained `LEN("😀")` now `Matched` at `1`, with direct witness `=LEN("😀")` also green at `1`; `LENB` was kept on the UTF-16-unit path as a regression-control split |
| `FTC-0692` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_maxifs_direct_array_shape_fix` | resolved by the same OxFunc commit; focused DnaOneCalc rerun shows retained LET-wrapped corpus form now `Matched` at a `1x5` array of `#VALUE!`; keep treating the literal-only direct form as an Excel authoring-frontier separator, not a required green witness |
| `FTC-0693` | `OxFunc / DnaOneCalc` | `fixed_local_and_host_rerun_green_after_minifs_direct_array_shape_fix` | resolved by the same OxFunc commit; focused DnaOneCalc rerun shows retained LET-wrapped corpus form now `Matched` at a `1x5` array of `#VALUE!`; keep treating the literal-only direct form as an Excel authoring-frontier separator, not a required green witness |
| `FTC-0999` | `OxFml / DnaOneCalc` | `host_proved_green_after_callable_parameter_rehydration_fix` | focused host rerun after `837f2a0` shows both separated MAP-callable-parameter witnesses green, inherited nested-MAP witness green, controls preserved, and retained `FTC-0999` now `Matched` at `#CALC!` |
| `FTC-0902` | `Foundation / DnaCalc / OxFml` | `host_proved_green_at_generic_callable_collision_pre_execution_frontier` | focused host rerun after OxFml commit `67a2429` shows the blocked ROW collision family, including retained `FTC-0902`, now matches Excel at typed pre-execution rejection frontier rather than surfacing as live OxFml runtime failure |

## 5. Cross-case theory lane

Use the dedicated theory note here:

> reference/test-corpus/workspace/monitoring/EXCEL_TEXT_CASING_THEORY_NOTE.md

Current family-level conclusion:
- Excel worksheet `UPPER` / `LOWER` / `PROPER` are not following full Unicode special casing.
- `OxFunc` now has a shared worksheet text-casing layer after commit `4ec5230`, and commit `e592c3b` widened provisional boundary witnesses without another semantic rewrite.
- The current observed boundary is: mostly simple single-codepoint casing, preserved decomposition, no observed multi-codepoint expansion or Turkish-locale special casing on the tested host, plus selected Greek-aware behavior such as final sigma.
- The family is still not globally closed; future surprises such as locale/build variation and wider Greek/decomposition edges should be treated as expected theory work, not isolated anomalies.

## 6. Recently cleared from active work

Do not reopen these unless a fresh retained rerun turns them red again.

| Case | Resolution note |
|---|---|
| `FTC-0401` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0402` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0403` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0404` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0407` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0408` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0450` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0505` | matched after OxFml commit `35f0849` and host rerun |
| `FTC-0541` | matched after OxFml fix and host rerun |
| `FTC-0561` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0572` | matched after DnaOneCalc commit `6319b43` |
| `FTC-0443` | matched after OxFml commit `e6167cf` |
| `FTC-1022` | matched after OxFml commit `0b0ca98` cleared the hidden locale-engine contradiction on the host path |
| `FTC-1021` | matched after DnaOneCalc commit `e5f8ac3` consumed captured render context on the host path |
| `FTC-1023` | matched after DnaOneCalc commit `e5f8ac3` consumed captured render context on the host path |
| `FTC-1024` | matched after DnaOneCalc commit `e5f8ac3` consumed captured render context on the host path |
| `FTC-1028` | matched after DnaOneCalc commit `e5f8ac3` consumed captured render context on the host path |
| `FTC-1040` | matched after DnaOneCalc commit `e5f8ac3` consumed captured render context on the host path |
| `FTC-0288` | matched after OxFml commit `a1deee2` plus DnaOneCalc commit `3110e1c` fed captured separators into the verification locale profile on the host rerun |
| `FTC-0374` | matched after OxFunc commit `6d22abe` specialized `skew_kernel` to explicit normalized-z cubic accumulation; DnaOneCalc rerun at `target/triage/ftc-0374-0375-after-d9a36d0/cases/FTC-0374` is now green |
| `FTC-0375` | matched after OxFunc commit `d9a36d0` specialized `kurt_kernel` to explicit normalized-z fourth-moment accumulation; DnaOneCalc rerun at `target/triage/ftc-0374-0375-after-d9a36d0/cases/FTC-0375` is now green |
| `FTC-0382` | matched after OxFunc commit `7d81f8c` switched `NPV` from per-term `powf` discount recomputation to a running multiplicative discount; DnaOneCalc rerun at `target/triage/ftc-0377-0382-after-7d81f8c/cases/FTC-0382` is now green |
| `FTC-0383` | matched after OxFunc commit `3dc35ad` refined `IRR` publication on the periodic cashflow path by publishing the midpoint of the local minimal-residual plateau; DnaOneCalc rerun at `target/triage/ftc-0383-only-normal-batch-output/cases/FTC-0383` is now green, and adjacent host confirmation batch `target/triage/ftc-0382-0383-after-3dc35ad/cases/` kept both `FTC-0382` and `FTC-0383` green together |
| `FTC-0399` | matched after OxFunc commit `14fba39` refined `DISC` publication in `discount_bill_yearfrac_family.rs` from `((redemption - pr) / redemption) / frac` to `(1.0 - pr / redemption) / frac`; fresh DnaOneCalc rerun at `target/triage/ftc-0399-after-14fba39-normal-batch-output/cases/FTC-0399` is now green with preserved Excel witness `0.030000000000000027` and no raw-vs-compare-ready drift |
| `FTC-0635` | matched after OxFunc commit `92eb272` narrowed negative-base non-integer handling to reciprocal odd-integer roots and aligned magnitude publication to Excel via `exp(power * ln(-base))`; DnaOneCalc reruns at `target/triage/ftc-0635-current-status-after-92eb272-normal-batch-output/cases/FTC-0635` and `target/triage/power-negative-base-odd-denominator-after-92eb272-normal-batch-output/cases/` show retained `FTC-0635` and the widened odd-denominator family green, including correction of the prior `=POWER(-8,2/3)` seam to `#NUM!` |
| `FTC-0254` | matched after OxFunc commit `2f954b1` widened machine-witness coverage on a multinomial-specific publication seam; DnaOneCalc ad hoc host proving batch at `target/triage/multinomial-widened-after-2f954b1-normal-batch-output/cases/` shows the widened MULTINOMIAL family green together with exact factorial control `=FACT(9)/(FACT(2)*FACT(3)*FACT(4))`. Follow-up on `MULTI-WIT-5` confirmed the authoritative compare-ready diff still uses exact numeric equality with no tolerance; the retained raw OxFml decimal `12599.999999999995` vs compare-ready decimal `12599.999999999996` is a same-binary64 (`0x40c89bfffffffffe`) JSON canonicalization seam, not a tolerated mismatch |
| `FTC-0353` | matched after OxFunc commit `bda031d` shaped single-array-substitute `COUNTBLANK` value errors to the incoming array shape; DnaOneCalc rerun at `target/triage/ftc-0353-only-normal-batch-output/cases/FTC-0353` is now green with aligned `1x5` array-of-`#VALUE!` payloads |
| `FTC-0365` | matched after OxFunc commit `e6b33f8` refined the shared paired-stats correlation kernel in `paired_stats_common.rs`; DnaOneCalc rerun at `target/triage/ftc-0365-0366-0369-normal-batch-output/cases/FTC-0365` is now green |
| `FTC-0366` | matched after the same OxFunc commit `e6b33f8`; DnaOneCalc rerun at `target/triage/ftc-0365-0366-0369-normal-batch-output/cases/FTC-0366` is now green |
| `FTC-0369` | matched after the same OxFunc commit `e6b33f8`; DnaOneCalc rerun at `target/triage/ftc-0365-0366-0369-normal-batch-output/cases/FTC-0369` is now green |
| `FTC-0376` | matched after DnaOneCalc commit `f6e3616` canonicalized compare-ready array envelopes from flat shaped cell lists into matrix payloads that OxReplay admits; proving rerun at `target/triage/ftc-0376-0300-normal-batch-output/cases/FTC-0376` is now green |
| `FTC-0176` | matched after OxFml commit `6d19213` vectorized IF array conditions at the wrapper seam; DnaOneCalc normal rerun at `target/triage/ftc-0176-0878-normal-batch-output/cases/FTC-0176` is now green |
| `FTC-0878` | adjacent omitted-false-branch witness matched after the same OxFml commit `6d19213`; DnaOneCalc normal rerun at `target/triage/ftc-0176-0878-normal-batch-output/cases/FTC-0878` is now green |
| `FTC-1006` | local OxFunc witness commit `cfa4f49` and DnaOneCalc host rerun both produced `201`; treat current corpus expected value `105` as expectation/provenance drift, not a repo bug |
| `FTC-1007` | local OxFunc witness commit `cfa4f49` and DnaOneCalc host rerun both produced `6`; treat current corpus expected value `204` as expectation/provenance drift, not a repo bug |

## 7. Coordinator operating order

1. Keep the render-context capture rollout note current as the durable record of the now-landed cross-repo path.
2. Treat the `FTC-0288` lane as a proven separator-aware host-execution success, not as an open blocked mismatch: the missing-context seam is closed, the semantic-delivery seam is closed, and the active anchor now matches under trusted captured separators.
3. Treat the current separator-family widening pass as informative but non-blocking: the family rule surface is broader than the original anchor, yet the widened Excel-backed rows did not surface a fresh retained mismatch.
4. Current best family-level hypothesis to retain:
   - comma behaves as semantic grouping/scaling only when the effective thousands separator is comma,
   - otherwise commas behave as picture/literal-position markers with right-to-left placeholder packing / one-shot grouping behavior,
   - and dot appears to participate in separator-role remapping under decimal-comma / thousands-period states rather than acting as an immutable decimal token.
5. Respect the current host ordering constraint: OxXlPlay-captured separator state still arrives after the initial OxFml execution, and the correct host pattern is now proven to be a post-capture trusted-context rerun with concrete separator overrides applied to `LocaleFormatContext.profile` before feeding `TypedContextQueryBundle`.
6. Keep exploring sibling separator-adjacent quirks beyond comma only when a fresh retained mismatch or a strategically important new witness justifies it. Current Excel-only evidence suggests slash/colon do not share the same dependency on numeric separator controls, but stronger proof would require a host/session where effective date/time separators differ from `/` and `:`.
7. Keep the text-casing family theory note current as new empirical casing cases are added.
8. Use `OxFunc` as the default ownership lane for worksheet text casing unless future evidence demonstrates a real host/context split.
9. Do not open another OxFunc semantics patch for worksheet casing until a retained Excel mismatch is demonstrated on the current seam.
10. If text-casing work resumes, prefer empirical host/build/locale variation probes before broadening local Unicode rules again.
11. Do not treat `FTC-0288` as just another locale-policy holdover anymore; it now has retained evidence of separator-context-sensitive semantics.
12. Keep `FTC-1021`, `FTC-1023`, `FTC-1024`, `FTC-1028`, and `FTC-1040` visible as cleared examples of the capture-contract lane, not fresh OxFml semantics targets.
13. Use `EXACTNESS_EXCEL_BIT_REPRODUCTION_POLICY.md` as the steering rule for direct-function exactness work: the target is observed Excel bits, not mathematically preferable results.
14. Keep `FTC-0406`, `FTC-0533`, and `FTC-0630` visible as explicit exactness-policy / numeric-boundary items, not casual fix targets.
15. Treat `FTC-0630` specifically as its own underflow-boundary bucket rather than folding it into ordinary `near_equal_last_bit` or generic `near_zero_residue` discussions; use `EXCEL_NUMERIC_CUTOFF_AND_EXACTNESS_THEORY_NOTE.md` as the durable record.
