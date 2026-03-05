# Formatting Hierarchy Findings (Focused Formal Pass)

Run metadata:
1. Run id: `specproc-20260304-231650`
2. Captured UTC: `2026-03-04T23:17:31.2663115Z`
3. Processor version: `0.1.0+bfb6434ac25d5142566edb9ebb7236cbee834cce`

This note isolates high-signal style-hierarchy/default/visibility anchors used for the formatting model update.

## 1. Style index and style-table lanes
1. Style-index correction signal:
   - `CONF-discovered-ms-oe376-220816-823374c7-0409` (`p:5904`)
   - `CONF-discovered-ms-oi29500-250218-d35cbb01-0387` (`p:5446`)
2. `cellXfs` + `cellStyleXfs` relationship underspec signal:
   - `SPEC-discovered-ms-oe376-220816-823374c7-07670` (`p:6726`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-07068` (`p:6315`)
3. `xfId` linkage overwrite signal:
   - `SPEC-discovered-ms-oe376-171212-fc69605e-19192` (`page:324:block:74`)

## 2. Differential format (`dxf`) lanes
1. `dxfId` optionality:
   - `SPEC-discovered-ms-oe376-220816-823374c7-07427` (`p:6464`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-06824` (`p:6050`)

## 3. Sheet defaults and layout lanes
1. `sheetFormatPr`/`baseColWidth` signals:
   - `SPEC-discovered-ms-oe376-220816-823374c7-07309` (`p:6365`)
   - `SPEC-discovered-ms-oe376-220816-823374c7-07310` (`p:6366`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-06711` (`p:5956`)
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-06712` (`p:5957`)

## 4. Number-format default tension
1. No-default signals for `numFmtId`:
   - `SPEC-discovered-ms-oi29500-250218-d35cbb01-06258`
   - `SPEC-discovered-ms-oe376-220816-823374c7-06881`
2. Constrained case signal (`numFmtId MUST equal 0`):
   - `CONF-discovered-ms-xlsx-250916-d16a975a-0067`

## 5. Formula visibility context (seed anchors)
Formal file-format specs above do not directly settle formula-level visibility of effective conditional formatting.
This lane is therefore paired with function-doc anchors and empirical probe planning:
1. `TEXT` function support page (`ECS-110`),
2. `CELL` function support page (`ECS-062`),
3. `INFO` function support page (`ECS-063`),
4. legacy compatibility probes (`GET.CELL`/XLM) treated as empirical-first, explicitly provisional.
