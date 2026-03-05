# Formatting Formal Findings (Focused Pass)

Run metadata:
1. Run id: `specproc-20260304-231650`
2. Captured UTC: `2026-03-04T23:17:31.2663115Z`
3. Processor version: `0.1.0+bfb6434ac25d5142566edb9ebb7236cbee834cce`
4. Scope: focused extraction over `MS-XLSX`, `MS-OI29500`, `MS-OE376` artifacts and related Open Specs pages.

This note records the high-signal formatting findings that were incorporated into the worksheet-engine conformance/model docs.

## 1. Number-format language (formal lane)
1. `MS-OI29500` extracted candidate `CONF-discovered-ms-oi29500-250218-d35cbb01-0534` (`p:6366`): valid format-code lane references ABNF.
2. `MS-OI29500` extracted candidate `CONF-discovered-ms-oi29500-250218-d35cbb01-0535` (`p:6367`): ABNF must be adjusted for international number formats.
3. `MS-OE376` extracted candidates `CONF-discovered-ms-oe376-220816-823374c7-0550` (`p:6780`) and `...-0551` (`p:6781`) mirror the same signals.

## 2. Conditional-format formula constraints (formal lane)
1. `MS-OI29500` extracted candidates:
   - `...-1453`: CF formula shall not use array constants.
   - `...-1454`: CF formula shall not use structure references.
   - `...-1455`: CF formula shall not use union/intersection binary operators.
   - `...-1456`: CF formula shall not use 3-D references.
2. `MS-OE376` extracted candidates:
   - `...-1427`, `...-1428`, `...-1429`, `...-1430` with the same constraints.
3. Precedence-order signal appears in both specs:
   - `MS-OI29500`: `...-0099` / `...-0100`
   - `MS-OE376`: `...-0111`

## 3. Explicit underspecification signals
From extracted `spec_items.jsonl`:
1. `SPEC-discovered-ms-oi29500-250218-d35cbb01-07122` (`p:6365`): no restriction on `formatCode` size/content is specified.
2. `SPEC-discovered-ms-oi29500-250218-d35cbb01-06258` (`p:5746`): no default for `numFmtId` is specified.
3. Parallel signals are also present in extracted `MS-OE376` and legacy PDF variants.

## 4. Evidence-path reminder
Primary extracted files:
1. `docs/discovered-ms-oi29500-250218-d35cbb01/conformance_candidates.jsonl`
2. `docs/discovered-ms-oe376-220816-823374c7/conformance_candidates.jsonl`
3. `spec_items.jsonl`

These findings are treated as formal-source anchors with extraction-stage caveat: broad automated extraction can include noise, so only itemized anchors listed above were promoted.
