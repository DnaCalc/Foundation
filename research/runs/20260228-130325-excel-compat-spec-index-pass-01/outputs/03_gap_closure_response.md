# Prompt Pass 3 - Blind-Spot Closure and Final Index Structure

## Final index structure (recommended)
1. Formula language and reference semantics
   - Operator table (+ precedence)
   - Reference operators (`:`, space/intersection, comma/union, `@`, `#`)
   - A1/R1C1 references, names, external refs, table structured refs
2. Built-in function catalog
   - Canonical full list snapshot
   - Per-function metadata: category, first version marker, applies-to, interesting flags
3. Value model (sheet-visible)
   - Primitive and error values
   - Arrays/spill ranges
   - Compound/linked data records
   - Coercion and conversion functions
4. Table/ListObject semantics
   - Structured reference grammar + behavior
   - Calculated columns
   - Auto-expand/auto-fill behavior
5. Formatting semantics
   - Number format model and custom code grammar
   - Cell format limits and style constraints
   - Merge/unmerge behavior constraints
   - Conditional formatting (rule model, priority, overlap)
6. Version and release tracking
   - Compatibility Versions workbook setting
   - Channel rollout model and function availability tracking
7. Known unknowns backlog
   - Explicit unresolved items with desired evidence source

## Gap-closure outcomes
- Added explicit source coverage for compatibility versions and release-channel behavior.
- Added explicit source coverage for linked data types and formula field dereference.
- Added explicit source coverage for formal grammar and table structured reference grammar.
- Captured volatility and performance-sensitive function guidance from recalculation/performance docs.

## Remaining top unknowns
1. Fully authoritative, per-function edge-case matrix is still fragmented.
2. Exact channel/build availability for every newest function remains a moving target.
3. Conditional-format rule conflict semantics need deeper formal extraction from OOXML/open specs and behavior tests.