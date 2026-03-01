# ECS-EB-045 Empirical Divergence Minimization Routine (Wave 1)

## Goal
Reduce any mismatch/counter-signal case to the smallest reproducible scenario while preserving observed divergence.

## Procedure
1. Freeze environment metadata:
   - record Excel build/hash and runner commit from run manifest.
2. Pin one target assertion:
   - choose exactly one failing case row and one target cell.
3. Remove non-essential writes:
   - iteratively delete unrelated setup writes; rerun after each deletion.
4. Remove non-essential operations:
   - iteratively prune operations not required to trigger divergence.
5. Collapse ranges:
   - shrink affected ranges to the minimal cell span that still reproduces behavior.
6. Normalize formula shape:
   - simplify nested expressions while preserving mismatch class.
7. Capture minimized evidence bundle:
   - include original and minimized scenario JSON side-by-side.
8. Classify divergence:
   - expectation error, environment-dependent behavior, or potential Excel variance.

## Output contract
- `minimized_scenario.json`
- `minimized_evidence/`
- `delta_notes.md` (what was removed and why)
- link back to original case id and evidence bundle.
