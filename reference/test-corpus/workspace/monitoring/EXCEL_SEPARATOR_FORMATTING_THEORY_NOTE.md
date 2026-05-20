# Excel Separator-Sensitive Number-Format Theory Note

## 1. Purpose

This note records the current Foundation understanding of the worksheet-number-format separator lane that was surfaced by `FTC-0288` and then widened across adjacent comma/scaling and decimal-token shapes.

This is a parking note, not a claim of full closure.

Current status:
- the active retained mismatch anchor is fixed honestly end-to-end,
- the family rule surface is now materially better understood,
- widened witness/probe passes did **not** expose a fresh retained red,
- so the lane can be parked unless a future separator-sensitive witness turns red.

## 2. Original anchor

Primary retained anchor:
- `FTC-0288`
- formula: `=TEXT(1234567.89,"#,##0.00")`

Observed Excel behavior:
- under default host state with effective thousands separator `NBSP`, Excel rendered `1234,567.89`
- when Excel was forced to active comma-thousands, the same format rendered `1,234,567.89`

That established that this was **not** a generic locale-policy problem and **not** a corpus-expectation typo.
It was a real separator-context-sensitive worksheet formatting semantics lane.

## 3. Current best rule hypothesis

Current best family-level hypothesis:

1. **Comma behaves as semantic grouping/scaling only when the effective thousands separator is comma.**
2. Otherwise, commas behave more like **picture/literal-position markers**.
3. In that non-comma-thousands mode, digits appear to be packed into the integer picture **right-to-left**, with leftover higher-order digits prepended to the first segment.
4. This yields the one-shot/literal-looking grouping outputs seen under NBSP-thousands.
5. **Dot does not appear to be an immutable decimal token.** Under decimal-comma / thousands-period states, dot also appears to participate in separator-role remapping rather than always meaning “decimal point”.
6. Quoted or escaped punctuation does **not** follow that same token remapping path; it behaves as literal punctuation.

This is still a working rule hypothesis, not a proof of the entire Excel formatting grammar.

## 4. What is now evidenced

### 4.1 Comma family is broader than the original anchor

The separator-sensitive family now includes at least these witnessed/probed shapes:
- `#,##0.00`
- `#,,`
- `0,,`
- `#,##0,,`
- `#,,,`
- `0,,,`
- `#,##0,,,`
- `#,###`
- `#,##`
- `##,##0.00`
- `#.0,`
- `0.0,,"M"`

### 4.2 Excel round-trips `TEXT(...)` and direct `NumberFormat` together

Across the widening passes so far:
- `TEXT(...)` output and direct worksheet `NumberFormat` output matched exactly for the tested rows.

That materially strengthens the claim that this is worksheet format semantics, not a `TEXT(...)`-only quirk.

### 4.3 Excel canonicalizes some odd grouping pictures

Under active comma-thousands, Excel sometimes normalizes odd grouping pictures on round-trip.
Examples seen in retained Excel-only matrices include shapes like:
- `#,## -> #,###`
- `#,#### -> ##,###`
- `###,## -> ##,###`
- `##,#### -> ###,###`

The rendered output still matched the worksheet text result.

### 4.4 Dot participates in separator-role remapping

Under forced:
- `DecimalSeparator=","`
- `ThousandsSeparator="."`

Excel worksheet outputs showed behavior consistent with dot being interpreted through the active separator map rather than as an immutable decimal token.

Examples from the retained probe set:
- `0.00 -> 1.235`
- `#.## -> 1.235`
- `#,##0.00 -> 1234567,89000`

Quoted/escaped dot variants did not follow the same token path.

## 5. Implementation status

### 5.1 OxFml

Relevant landed commits:
- `42c9d3c` — `Add FTC-0288 separator-context witnesses`
- `a1deee2` — `Honor separator context in TEXT grouping`
- `0397746` — `Add trailing-comma separator context witnesses`
- `a5b87e3` — `Add FTC-0288 adjacent matrix witnesses`
- `b5207e3` — `Add FTC-0288 rule edge witnesses`

Current implementation understanding:
- the active retained mismatch anchor was fixed in `crates/oxfml_core/src/format/number.rs`
- widened local witness sets now cover the original anchor plus adjacent comma/scaling and rule-edge shapes
- the widened Excel-backed rows tested so far did **not** expose a fresh local mismatch after the active anchor fix

### 5.2 DnaOneCalc

Relevant landed commits:
- `8383b96` — `Prepare verification locale context for render state`
- `217c2f3` — `Import captured separator details from render context`
- `3110e1c` — `Feed captured separators into verification locale context`

Current implementation understanding:
- the host comparison-consumption seam was already closed earlier for captured render context
- the remaining separator-aware execution seam was then closed by overriding concrete separator fields in the rerun `LocaleFormatContext.profile`
- the correct host pattern is now proven to be:
  1. capture Excel render context,
  2. import trusted separator state,
  3. rerun OxFml post-capture,
  4. feed concrete separator overrides through `TypedContextQueryBundle`.

### 5.3 OxXlPlay

Relevant retained Excel-only probe outputs:
- `.tmp/ftc-0288-grouping-semantics-probe/results.json`
- `.tmp/ftc-0288-separator-mode-probe/results.json`
- `.tmp/ftc-0288-adjacent-comma-matrix/results.json`
- `.tmp/ftc-0288-comma-family-widen/results.json`
- `.tmp/ftc-0288-decimal-token-probe/results.json`
- `.tmp/ftc-date-time-separator-probe/results.json`
- `.tmp/ftc-date-time-separator-probe-expanded/results.json`

## 6. What is proven vs not proven

### 6.1 Proven enough for parking

Proven enough to rely on:
- the original `FTC-0288` mismatch was real separator-sensitive worksheet semantics
- the host-side separator-aware rerun seam is necessary and now works end-to-end
- the family rule surface is broader than one format string
- the widened Excel-backed rows tested so far do **not** currently force another OxFml code change

### 6.2 Not proven globally

Still not proven:
- a complete formal grammar for all Excel separator-sensitive format semantics
- whether every mixed decimal/grouping/scaling combination follows the current hypothesis
- whether host/build/locale variation would change some of the observed rule boundaries
- whether date/time separator tokens `/` and `:` are truly literal or token-mapped under hosts whose effective date/time separators differ from `/` and `:`

## 7. Why the lane is parked

The lane is being parked because:
- the active retained red is green honestly,
- widened witness/probe passes broadened the theory substantially,
- and no fresh retained mismatch has appeared in the widened tested rows.

That means the right current state is:
- preserve the rule hypothesis,
- preserve the retained evidence set,
- avoid speculative broad rewrites without a new retained red.

## 8. Reopen conditions

Reopen this lane if any of the following happens:
- a fresh retained separator-sensitive mismatch appears in formula-corpus reruns,
- a future witness/probe row diverges between Excel and OxFml,
- a new host/build/locale matrix reveals contradictory token behavior,
- or a strategically important separator-sensitive family is needed for a nearby open red.

## 9. Parked guidance

If this lane resumes, prefer this order:
1. reproduce the new shape with worksheet-Excel evidence,
2. add OxFml witness coverage for the exact shape,
3. check whether the existing separator-aware host rerun path already carries the needed context,
4. patch only the smallest evidenced rule surface.

Do **not** reopen this lane from documentation analogy alone.
Use retained worksheet evidence first.
