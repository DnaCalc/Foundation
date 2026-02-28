# Conference Brief - Core Engine Formal Model

## Objective
Run an extended, interactive planning process (including multiple agent perspectives) to evolve the core engine formal model without losing historical context or violating current v0 pathfinder scope boundaries.

## Guardrails
- Source-of-truth precedence remains: `CHARTER.md` > `ARCHITECTURE_AND_REQUIREMENTS.md` > `OPERATIONS.md` > supporting notes.
- DnaVisiCalc v0 functional scope authority remains: `SPEC_v0.md`, `ENGINE_REQUIREMENTS.md`, `ENGINE_API.md`.
- This run captures proposals and working analyses; it does not directly change doctrine.
- Use explicit uncertainty labels where semantics are incomplete.

## Suggested Session Cadence
1. Pick one bounded topic (for example reference normal form, cycle semantics, or op replay equivalence).
2. Capture competing model options with explicit invariants and tradeoffs.
3. Record proposed promotion target (`CORE_ENGINE_FORMAL_MODEL`, `ARCH`, `OPERATIONS`, or `defer`).
4. Track unresolved questions and required evidence for next session.

## Output Convention
Write each planning artifact to `responses/` with a timestamped filename.