# Prompt Pass 5 - Interesting Function Semantics (Focused)

## Priority order used
1. Tier 5 critical-interest (5 functions)
2. Tier 4 high-interest (43 functions)
3. Tier 3 medium-interest (23 functions)

## Family-level deepening (pass 05)
- Critical-interest cluster:
  - INDIRECT, OFFSET, RTD, NOW, TODAY
  - Focus: volatility/recalc sensitivity, dependency-shape implications, external update behavior, and format-visible behavior.
- Dynamic-array cluster:
  - Focus: spill shape, blocked spill, range-returning interactions, and introduction-version markers.
- Functional formula cluster:
  - LET, LAMBDA, and helper functions (MAP/BYROW/BYCOL/REDUCE/SCAN/MAKEARRAY/ISOMITTED).
  - Focus: formula-language expressiveness and compatibility profile impacts.
- CUBE cluster:
  - 7 functions (CUBEKPIMEMBER/CUBEMEMBER/CUBEMEMBERPROPERTY/CUBERANKEDMEMBER/CUBESET/CUBESETCOUNT/CUBEVALUE).
  - Focus: usage context, connector/dependency context, and compatibility risk flags.
  - MDX parsing/evaluation is explicitly out-of-scope.

## Result posture
- Full-catalog completeness is materially improved.
- High-interest families now have initial semantic framing suitable for deeper per-function passes.
- Known unknowns remain explicit for coercion matrices and full per-function edge-case semantics.