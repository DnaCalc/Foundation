# Follow-up Queries and Pack Seeds

## Priority follow-up research prompts
1. Macro preservation deep pass:
   - "Compare xlsm/vbaProject roundtrip behavior for calamine + rust_xlsxwriter + umya-spreadsheet + Open XML SDK + POI on a fixed corpus."
2. Unknown-part preservation pass:
   - "Measure relationship and unknown part stability under open/save no-op operations."
3. Feature-parity pass:
   - "Build a per-feature matrix (tables/charts/comments/conditional formatting/data validation/images/names) with direct evidence references."
4. Performance pass:
   - "Benchmark large worksheet read/write and streaming memory footprint across shortlisted libraries."

## Proposed empirical pack identifiers
1. `PACK.ooxml.roundtrip.xlsm`
2. `PACK.ooxml.roundtrip.unknown_parts`
3. `PACK.ooxml.feature_matrix.core`
4. `PACK.ooxml.streaming.signature`

## Output contract suggestion
Each empirical run should emit:
1. corpus manifest,
2. per-library result table,
3. binary/package diff summary,
4. reproducibility metadata (tool version, commit hash, environment).