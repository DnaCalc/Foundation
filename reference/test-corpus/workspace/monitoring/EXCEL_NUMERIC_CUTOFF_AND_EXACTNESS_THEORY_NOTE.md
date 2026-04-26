# Excel Numeric Cutoff And Exactness Theory Note

## 1. Purpose

This note records the current Foundation understanding of the `FTC-0630` lane and its relationship to broader Excel numeric exactness behavior.

Current status:
- `FTC-0630` is now a deliberate Excel-emulation case, not an IEEE-754 preservation case,
- retained Excel evidence points to **two distinct Excel-side behaviors** near the tiny-number boundary,
- `FTC-0533` has been split into a separate root add/sub zero-reaching publication behavior,
- and the implementation decision is to model those behaviors in the engine rather than leave them as corpus blockers.

This note is now both an evidence-backed theory note and the policy record for the current implementation allocation.

## 1.1 2026-04-26 Decision Update

The current COM probe matrix tightened the ownership split:

- `=0.1+0.2-0.3` returns `0`.
- `=(0.1+0.2-0.3)` returns `5.551115123125783E-17`.
- `=(0.1+0.2-0.3)*1E17` returns `5.551115123125783`.
- `=IF(0.1+0.2-0.3,1,0)` returns `1`.
- `=(0.1+0.2-0.3)=0` returns `FALSE`.
- `=1E-17+(-2E-17)` returns `-1E-17`.
- `=0.300000000000001-0.3` returns `9.992007221626409E-16`.
- `=43.1-43.2+0.1` returns `-1.4155343563970746E-15`.
- `=(1E15+1)-1E15` returns `1`.

That means `FTC-0533` is not a generic "tiny final number becomes zero" rule. It is a root formula publication compensation for an ungrouped add/sub cancellation shape. The residue remains observable when the same expression is grouped, nested, used as a condition, compared, or scaled by an outer operation.

For `FTC-0630`, the same COM pass confirms the underflow split:

- `=2.2250738585072014E-308/10` is stored as `=0/10` and returns `0`.
- `=2.2250738585072100E-308/2` is stored with the literal preserved, but returns `0`.
- `=(2.2250738585072100E-308/2)*1E307` returns `0`.
- `=5E-308/2` returns `2.5E-308`.
- `=POWER(2,-1023)` returns `0`.
- `=POWER(2,-1022)` returns `2.2250738585072014E-308`.

Implementation allocation:

- OxFml owns lexical worksheet literal admission at the observed Excel cutoff near `2.22507385850721E-308`.
- OxFunc owns calculation-boundary flushing for finite denormalized/subnormal arithmetic and POWER results.
- OxFml owns root-only, ungrouped add/sub zero-reaching publication because that rule depends on formula shape, not just numeric operator semantics. The rule must remain absolutely tiny as well as cancellation-shaped; `FTC-0628` proves that large-scale meaningful deltas such as `1` must not be zeroed.

## 2. Primary anchor

Primary corpus anchor:
- `FTC-0630`
- formula: `=2.2250738585072014E-308/10`

Current retained mismatch shape:
- OxFml: `2.225073858507203e-309`
- Excel: `0.0`
- OxReplay mismatch label: `near_zero_residue`

But the newer retained evidence shows this is not just “OxFml kept a tiny residue while Excel rounded later”.
The Excel lane appears to have both:
- **literal canonicalization to zero** near the minimum positive boundary,
- and **post-evaluation zero flush** for at least some preserved-above-threshold literals whose result lands below that boundary.

## 3. Public/document evidence revisited

From the local mirror of Microsoft Support:

> `research/runs/20260228-130325-excel-compat-spec-index-pass-01/inputs/raw/ECS-033.html`

This is the mirrored page:
- `Excel specifications and limits - Microsoft Support`

Relevant retained lines now include:
- `Number precision` → `15 digits`
- `Smallest allowed positive number` → `2.2251E-308`
- `Smallest allowed negative number` → `-2.2251E-308`

This doc evidence matters because our retained Excel cutoff probes now sit extremely close to the documented minimum positive boundary.

## 4. Current retained evidence

### 4.1 Local OxFml witness pass

Relevant local witness commit:
- `OxFml` commit `74bb5d3` — `Add FTC-0630 subnormal boundary witnesses`

Current local matrix:
- `=2.2250738585072014E-308/10` → `2.225073858507203e-309`
- `=2.2250738585072014E-308/2` → `1.1125369292536007e-308`
- `=2.2250738585072014E-308/100` → `2.2250738585072e-310`
- `=4.450147717014403E-308/10` → `4.4501477170144e-309`

Repo-local conclusion:
- OxFml preserves IEEE-754 subnormal values consistently across the currently tested local rows.
- That does **not** currently look like an unstable one-off bug.

### 4.2 Host-side underflow witness batch

Relevant retained host rerun root:

> `target/triage/ftc-0630-underflow-witness-batch-output/`

Key retained cases:
- `FTC-0630`
- `FTC-0630-WIT-1` = `=2.2250738585072014E-308`
- `FTC-0630-WIT-2` = `=2.2250738585072014E-308/2`

Observed retained Excel-side facts:
- `FTC-0630-WIT-1` capture suggested formula text canonicalized to `=0`
- `FTC-0630-WIT-2` capture suggested formula text canonicalized to `=0/2`
- `FTC-0630` capture suggested formula text canonicalized to `=0/10`

So the early conclusion became:
- Excel is not only zeroing tiny results later,
- it is also rewriting at least some tiny scientific literals into zero-shaped formulas.

### 4.3 Host-side cutoff-finding batch

Relevant retained host rerun root:

> `target/triage/ftc-0630-cutoff-batch-output/`

Key cases:
- `FTC-0630-CUT-1` = `=2.3E-308`
- `FTC-0630-CUT-2` = `=2.3E-308/2`
- `FTC-0630-CUT-3` = `=5E-308`
- `FTC-0630-CUT-4` = `=5E-308/2`

Observed retained behavior:
- `=2.3E-308` → matched, preserved nonzero literal/value
- `=2.3E-308/2` → formula preserved, but value became `0.0`
- `=5E-308` → matched
- `=5E-308/2` → matched

This is the strongest retained split evidence so far:
- Excel can preserve a tiny literal above the boundary,
- yet still flush a sufficiently tiny computed result to zero.

### 4.4 Excel-only literal cutoff probes

Relevant retained Excel-only probe outputs:
- `.tmp/ftc-0630-cutoff-probe/results.json`
- `.tmp/ftc-0630-cutoff-refine/results.json`
- `.tmp/ftc-0630-dual-threshold-probe/results.json`

Current retained literal cutoff result on the observed host/build:
- all probed literals through `=2.2250738585072099E-308` were rewritten to:
  - `formula_text = =0`
  - `cell_value = 0`
- the first preserved nonzero literal found was:
  - entered: `=2.2250738585072100E-308`
  - captured formula: `=2.22507385850721E-308`
  - captured value: `2.22507385850721E-308`

So the currently retained host/build-specific literal transition is:
- **rewrite-to-zero at and below `2.2250738585072099E-308`**
- **preserved scientific-literal rewrite by `2.2250738585072100E-308`**

This is strikingly close to the documented “smallest allowed positive number” boundary from Microsoft Support.

### 4.5 Excel-only dual-threshold probe

The later Excel-only dual-threshold probe tightened the split further.

Relevant retained outputs:
- `.tmp/ftc-0630-dual-threshold-probe/results.json`
- `.tmp/ftc-0630-dual-threshold-probe/output/literal_2099/capture.json`
- `.tmp/ftc-0630-dual-threshold-probe/output/literal_2100/capture.json`
- `.tmp/ftc-0630-dual-threshold-probe/output/half_2100/capture.json`

Observed retained behavior on the same host/build:
- literal rows from `=2.2250738585072090E-308` through `=2.2250738585072099E-308` all rewrote to `=0`
- `=2.2250738585072100E-308` became preserved as shortened scientific literal `=2.22507385850721E-308`
- `/2` rows beginning immediately above that preservation seam, including:
  - `=2.2250738585072100E-308/2`
  - `=2.2250738585072102E-308/2`
  - `=2.2250738585072104E-308/2`
  - `=2.2250738585072106E-308/2`
  - `=2.2250738585072108E-308/2`
  - `=2.2250738585072110E-308/2`
  all preserved formula text as a scientific-literal expression, but still produced:
  - `cell_value = 0`
  - `effective_display_text = 0`

This matters because it shows the two cutoffs do **not** coincide on the observed host/build.
The literal can already be preserved while the evaluated result is still flushed to exact zero.

### 4.6 Host-side just-above-threshold batch

Relevant retained host rerun root:

> `target/triage/ftc-0630-cutoff-batch-2-output/`

Key retained cases:
- `FTC-0630-CUT2-L1` = `=2.24E-308`
- `FTC-0630-CUT2-D1` = `=2.24E-308/2`
- `FTC-0630-CUT2-L2` = `=2.26E-308`
- `FTC-0630-CUT2-D2` = `=2.26E-308/2`

Observed retained behavior:
- `=2.24E-308` → `Matched`
- `=2.26E-308` → `Matched`
- `=2.24E-308/2` → `Blocked` with preserved formula text and Excel value `0.0`
- `=2.26E-308/2` → `Blocked` with preserved formula text and Excel value `0.0`

Taken together with the earlier host batch:
- `=2.3E-308/2` still flushes to zero,
- while `=5E-308/2` remains nonzero and matches.

So the currently retained host-side range read is:
- literal-preservation cutoff is somewhere between the original failing literal family and `2.24E-308`,
- while the post-evaluation zero-flush threshold is still active for results around `1.12e-308`, `1.13e-308`, and `1.15e-308`,
- but is no longer active by `2.5e-308`.

## 5. Current best theory

Current best evidence-backed theory is that Excel has **at least two adjacent cutoff behaviors** here.

### 5.1 Behavior A — literal canonicalization cutoff

For authored worksheet scientific literals below a host/build-dependent threshold near the documented minimum positive number:
- Excel rewrites the formula itself to a zero-shaped form,
- for example `=0`, `=0/2`, `=0/10`.

This is not merely display formatting.
It is visible in retained formula text capture.

### 5.2 Behavior B — post-evaluation zero flush

For some literals above the literal-preservation threshold:
- Excel preserves the formula text as a scientific literal,
- but a sufficiently tiny computed result may still become exact zero.

Current retained witnesses include:
- `=2.2250738585072100E-308/2`
- `=2.2250738585072102E-308/2`
- `=2.2250738585072104E-308/2`
- `=2.2250738585072106E-308/2`
- `=2.2250738585072108E-308/2`
- `=2.2250738585072110E-308/2`
- `=2.24E-308/2`
- `=2.26E-308/2`
- `=2.3E-308/2`

Across those retained rows:
- formula text is preserved as a scientific-literal expression,
- yet Excel evaluates the result to `0.0`.

Current retained upper/lower bracket on the observed host/build:
- zero flush is still active for results around `1.112536929253605e-308` through `1.15e-308`,
- but is no longer active by `2.5e-308` (`=5E-308/2`).

### 5.3 Relationship between A and B

So the lane is not one phenomenon.
It appears to be:
1. an **authoring/canonicalization** cutoff for tiny literals,
2. plus an **evaluation/result** cutoff for tiny computed values.

## 6. Relationship to earlier exactness work

This lane should be considered together with earlier exactness observations, but not flattened into one generic rounding story.

### 6.1 Related but distinct clusters

#### Cluster 1 — finite precision / canonicalization
Examples and context:
- `FTC-0406` (`near_equal_last_bit`)
- `FTC-0573` (`near_equal_last_bit`)
- corpus precision-boundary examples like:
  - `FTC-0627` (`=ROUND(0.1+0.2, 15)`) with note about `0.30000000000000004`
  - `FTC-0629` (`=(1E16+1)-1E16`) with note about 15-digit precision loss
- Microsoft Support limits page saying `Number precision = 15 digits`

These suggest Excel has well-known finite-precision normalization/canonicalization behavior on the high-precision side.

#### Cluster 2 — near-zero / underflow cutoff
Examples and context:
- `FTC-0533` (`near_zero_residue`)
- `FTC-0630` (`near_zero_residue`)
- current tiny-scientific-literal probes around `2.2251E-308`

These suggest Excel also has distinct behavior near zero, including:
- zero flush of tiny results,
- and in this lane, literal rewrite to zero near the minimum positive boundary.

But the current retained read is that `FTC-0533` and `FTC-0630` still do not belong in the same immediate sub-bucket:
- `FTC-0533` is an ordinary small arithmetic residue case (`=0.1+0.2-0.3`) without tiny-literal authoring/canonicalization behavior,
- while `FTC-0630` shows both literal-boundary rewriting and a separate post-evaluation zero-flush region.

### 6.2 Current synthesis

Most defensible current synthesis:
- Excel numeric behavior appears to involve **multiple exactness/canonicalization boundaries**, not one universal “Excel rounds odd things” rule.
- The 15-digit precision boundary and the near-zero underflow boundary are related in spirit, but they operate in different numeric regions and likely through different internal rules.
- `FTC-0406` and `FTC-0573` fit the ordinary finite exactness / ULP-class side better.
- `FTC-0533` is related as a near-zero arithmetic residue case, but still lacks the tiny-literal canonicalization behavior seen here.
- `FTC-0630` should therefore be treated as its own **near-zero/underflow-boundary** theory lane, not simply merged into last-bit-equality discussions or generic `near_zero_residue` notes.

## 7. What is proven vs not proven

### 7.1 Proven enough to rely on

Proven enough to rely on now:
- OxFml local behavior is internally consistent and IEEE-754 preserving for the currently tested tiny values.
- Excel has a literal rewrite-to-zero region near the documented minimum positive boundary.
- On the observed host/build, that literal rewrite region includes all tested rows through `2.2250738585072099E-308`, with first preserved literal found at `2.2250738585072100E-308`.
- Excel also has multiple retained cases of preserved literal + zero result, not just one (`=2.2250738585072100E-308/2`, `=2.24E-308/2`, `=2.26E-308/2`, `=2.3E-308/2`).
- Therefore the literal-canonicalization cutoff and post-evaluation zero-flush cutoff are distinct on the observed host/build.
- Therefore `FTC-0630` is broader than a single divide-by-10 oddity.

### 7.2 Not yet proven

Still not proven:
- the exact universal cutoff for all host/build combinations,
- the exact post-evaluation zero-flush cutoff on the observed host/build beyond the current bracket,
- whether workbook authoring path vs UI entry path vs COM path all share the same cutoff behavior,
- whether Excel ever preserves subnormal computed values in nearby regions under other host/build configurations.

## 8. Current implementation status

Semantics patches are now justified and implemented as explicit Excel emulation.

Current implementation read:
- `OxFml` zeroes worksheet numeric literals below the observed Excel literal-admission cutoff near `2.22507385850721E-308`.
- `OxFunc` flushes finite denormalized/subnormal arithmetic and POWER results to exact zero.
- `OxFml` applies the root-only add/sub zero-reaching publication rule for ungrouped root expressions only.

Current host/policy read:
- exact-value policy remains honest by documenting these as Excel behavior rather than mathematical exactness,
- `FTC-0533` remains separate from `FTC-0630` because it is formula-shape-sensitive cancellation publication,
- `FTC-0630` remains an underflow-boundary lane with literal admission and calculation-result flushing.

## 9. Reopen / next-step conditions

If this lane continues, best next step is narrow and empirical:
1. only tighten the literal-preservation cutoff further if a host/build-sensitive reason appears; the current host/build seam is already narrow enough to support theory work,
2. if needed, bracket the post-evaluation zero-flush threshold more tightly between the current retained ranges:
   - still zero by results around `1.112536929253605e-308` through `1.15e-308`
   - nonzero by `2.5e-308`
3. prefer host/build variation evidence before any semantics patch,
4. only then decide whether a policy note, corpus classification note, or implementation change is justified.

## 10. Parked guidance for now

Current guidance:
- treat `FTC-0630` as a real Excel underflow-boundary family,
- keep `FTC-0406`, `FTC-0533`, and `FTC-0573` visible as related exactness-policy context,
- but do not merge them into one generic explanation,
- keep `FTC-0630` in its own bucket rather than lumping it into ordinary `near_equal_last_bit` or generic `near_zero_residue` notes,
- keep the OxFml/OxFunc allocation above unless new Excel evidence shows a broader rule.
