Synthesis written to `responses/95_cross_synthesis.md`. Here's a summary of what I did:

**Source material:** Three independent model outputs (Codex, Claude, Gemini) responding to the 4-item prompt sequence on cell abstraction.

**Key synthesis decisions:**

- **Domains:** Adopted Codex's 9-domain decomposition as the most granular. Claude's Presentation domain is retained as a post-evaluation judgment form rather than a peer evaluation domain.
- **Profile parameterization (`Π`):** Adopted from Codex as the central architectural mechanism for cross-domain reuse. This was the biggest structural differentiator.
- **Environment symbol:** Used `Γ` (Claude/Gemini's standard PL convention) over Codex's `Σ`, but retained Codex's snapshot-provided semantics.
- **Rich result type `ρ`:** Adopted from Codex — `Ok(value, deps, events) | Fail(error, deps, events)` — since carrying dependency and trace data alongside the value is essential for conformance replay.
- **Inference rules:** Took Claude's concrete rule sketches (E-Lit, E-Ref, E-Div, E-Div0) and extended them with Codex's profile parameterization.
- **Gap inventory:** Union of all three models (6 spec-gaps, 9 empirical-gaps), using Claude's SG/EG prefix convention. Gemini's unique contribution (short-circuit evaluation) is captured as SG-6.

**5 residual uncertainties** flagged where the synthesis makes a provisional choice that needs validation, and **10 prioritized next actions** to drive the model forward.
