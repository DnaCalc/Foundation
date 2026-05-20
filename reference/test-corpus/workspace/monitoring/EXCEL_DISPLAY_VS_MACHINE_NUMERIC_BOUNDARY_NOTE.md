# Excel display-vs-machine numeric boundary note

## Scope

This note records the current bounded investigation for integer-looking or rounded Excel observations whose retained machine numeric payload is slightly different.

Primary anchor:
- `FTC-0254` — `=MULTINOMIAL(2,3,4)`

Adjacent audit set:
- `FTC-0365`
- `FTC-0366`
- `FTC-0369`
- `FTC-0375`
- `FTC-0383`
- `FTC-0399`

## Why this note exists

`FTC-0254` initially looked like the next small OxFunc exactness lane because the current host rerun retained:
- OxFml: `1260.0`
- Excel comparison payload: `1259.999999999999`

But both the authored corpus expectation and direct worksheet viewing point toward `1260` as the visible Excel result, so the first required question was whether our observation stack had invented the sub-integer residue.

## Live Excel evidence for FTC-0254

Repo-local OxXlPlay probe artifacts:

> .tmp/ftc-0254-multinomial-probe/
- `results.json`
- `workbook.xlsx`

> .tmp/ftc-0254-capture-run/output/
- `capture.json`

Observed Excel facts for `=MULTINOMIAL(2,3,4)`:
- `Formula` = `=MULTINOMIAL(2,3,4)`
- `Formula2` = `=MULTINOMIAL(2,3,4)`
- `Text` = `1260`
- expanded decimal display also remained `1260.000...`
- COM `Value2` was **not** exactly `1260.0`
- `Value2` round-trip string was `1259.999999999999`
- `Value2` bits were `0x4093AFFFFFFFFFFC`
- saved workbook XML cached `<v>` was `1259.9999999999991`

Current OxXlPlay capture for the same formula retained:
- `cell_value.value_repr` = `1260`
- `effective_display_text.value_repr` = `1260`
- `cell_value.comparison_value.value.number` = `1259.999999999999`

Additional direct worksheet witness from live Excel manual follow-up:
- `=MULTINOMIAL(2,3,4)=1260` returned `TRUE`
- `=SIGN(MULTINOMIAL(2,3,4)-1260)` returned `-1`

That pair is decisive for seam classification:
- arithmetic still reveals a tiny negative residue,
- but worksheet `=` does **not** behave like raw machine-double equality on this lane.

## Current root-cause read

Current evidence does **not** support the theory that OxXlPlay fabricated the residue from nowhere.

The stronger read is now a three-surface split:
1. Excel computes/caches a machine numeric slightly below `1260`.
2. Excel's display layer rounds that result to `1260`.
3. Excel arithmetic surfaces can still reveal the tiny residue.
4. Excel worksheet comparison via `=` can still return `TRUE` on that pair.
5. OxXlPlay `value_repr` follows display-like/PowerShell stringification behavior and shows `1260`.
6. OxXlPlay `comparison_value.number` preserves the underlying machine numeric witness.

So the immediate coordinator mistake risk was not "fix MULTINOMIAL in OxFunc first"; it was failing to distinguish:
- **display-facing Excel evidence**,
- **machine-numeric Excel evidence**, and
- **worksheet comparison semantics**.

## Relevant capture seam

Repo-local OxXlPlay read pinned the current split to `scripts/invoke-excel-observation.ps1`:
- `value_repr` for `cell_value` is produced through `Convert-CellValueToString` on `Value2`
- `comparison_value.number` is produced through `Get-RangeComparableValueEnvelope` → `Convert-RangeToOxFuncScalarComparableValue` → `Convert-InteropScalarPairToOxFuncScalarComparableValue`, which publishes `[double]$Value2`

That means the current stack intentionally preserves machine numeric payloads, even when display-like surfaces round to simpler text.

## Similar-case audit

Repo-local DnaOneCalc audit across current `target/triage` roots found that rounded `value_repr` vs more precise retained machine numeric payload is broad, not unique to `FTC-0254`.

High-signal examples:
- `FTC-0365` — display-like `1`, retained Excel numeric `0.9999999999999998`
- `FTC-0366` — display-like `-1`, retained Excel numeric `-0.9999999999999998`
- `FTC-0369` — display-like `1`, retained Excel numeric `0.9999999999999996`
- `FTC-0375` — display-like `-1.2`, retained Excel numeric `-1.1999999999999984`
- `FTC-0383` — display-like `0.163405600688989`, retained Excel numeric `0.16340560068898924`

These are important controls because several later went green only after OxFunc moved to the Excel **machine numeric** witness. So the pattern alone does **not** prove an observation bug.

Current strongest caution cases:
- `FTC-0254` — standout because Excel display-like evidence and OxFml both read `1260`, retained Excel machine numeric is slightly sub-integer, and live worksheet `=` still says the value equals `1260`
- `FTC-0399` — weaker adjacent candidate (`value_repr = 0.03`, retained Excel numeric `0.030000000000000027`)

## Current classification

- `FTC-0254` was **not** an OxXlPlay fabrication bug.
- `FTC-0254` was proven to sit on an **Excel comparison-vs-arithmetic-vs-display boundary**.
- Under the current project policy, that boundary did **not** remove `FTC-0254` from the exactness queue: the required target remained Excel's underlying numeric machine witness, not the rounded display result and not worksheet `=` behavior.
- That exactness lane is now resolved on a widened empirical family by OxFunc commit `2f954b1` (`multinomial: widen machine-witness coverage`), with DnaOneCalc host proving batch `target/triage/multinomial-widened-after-2f954b1-normal-batch-output` green for the widened MULTINOMIAL set plus exact factorial control.
- The doctrine note still remains necessary because the lane exposed two distinct coordinator risks:
  - confusing display-facing agreement with machine-numeric agreement, and
  - confusing compare-ready decimal canonicalization with float-tolerance or numeric mutation.

## Compare-ready decimal canonicalization seam

After the widened host batch turned green, one retained row (`MULTI-WIT-5` / `=MULTINOMIAL(1,2,3,4)`) showed an important reporting wrinkle:

- raw OxFml retained projection:
  - `comparison_views[].value.number = 12599.999999999995`
- compare-ready OxFml retained projection used for OxReplay diff:
  - `comparison_views[].value.number = 12599.999999999996`
- Excel compare-ready retained projection:
  - `comparison_views[].value.number = 12599.999999999996`
- OxReplay authoritative diff still reported:
  - `equivalent = true`

Follow-up coordination established the exact seam:
- OxReplay does **not** admit float tolerance or near-equality in authoritative compare-ready numeric comparison.
- DnaOneCalc compare-ready materialization (`materialize_compare_ready_projection(...)` and related normalization in `src/dnaonecalc-host/src/services/verification_bundle.rs`) round-trips `comparison_views.value.number` through `serde_json` parse / re-serialization.
- For this row, Rust / `serde_json` parse both decimal spellings `12599.999999999995` and `12599.999999999996` to the **same binary64**:
  - bits `0x40c89bfffffffffe`
- So this was **not** a tolerated numeric mismatch and **not** a mutated machine value; it was a retained raw-vs-compare-ready decimal-lexeme consistency seam.

Coordinator rule from this seam:
- treat compare-ready numeric equality as exact,
- but do not assume raw retained decimal spellings and compare-ready decimal spellings will always match textually when JSON numeric canonicalization is involved.

## Coordinator guidance

Until this boundary is classified more explicitly:
- do **not** treat worksheet `=` as a raw-machine-double revealer on this family
- continue OxFunc implementation work on `FTC-0254`, because the required target remains Excel's underlying numeric machine witness
- do **not** excuse a numeric mismatch merely because display-facing surfaces and worksheet `=` happen to agree
- treat adjacent integer-looking/rounded captures cautiously, especially when:
  - Excel display-like evidence and OxFml agree,
  - retained Excel machine numeric differs slightly,
  - and worksheet comparison formulas may still canonicalize that difference away

## Next questions

1. How should comparison summaries and monitoring explicitly distinguish display-facing agreement, arithmetic disagreement, and `=`-comparison agreement for near-integer captures?
2. Do earlier authored assumptions like `=0.1+0.2=0.3 -> FALSE` need provenance review before they are used as Excel-semantics doctrine?
3. Which lookup/match families share the same comparison canonicalization seam as worksheet `=`?
4. Does `FTC-0399` belong in the same boundary-review bucket, or is it still better explained as ordinary machine-numeric exactness?
