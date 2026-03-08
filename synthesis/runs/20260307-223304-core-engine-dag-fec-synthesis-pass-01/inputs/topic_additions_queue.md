# Topic Additions Queue (Pre-Synthesis Intake)

Use this queue to add more discussion topics before formal synthesis execution.

## Intake Rules
1. Add each new topic as a separate entry with explicit scope and desired decision artifact.
2. Link each topic to one or more target docs/sections.
3. Mark proposed priority and whether it blocks synthesis promotion.

## Entry Template
```text
Topic ID:
Title:
Scope:
Why it matters:
Target docs/sections:
Related decisions (DEC-CALC-*):
Suggested evidence/probes:
Priority:
Blocking for synthesis: yes/no
Status: queued|discussing|stabilized
```

## Current queued additions
1. Topic ID: TQ-009
   Title: Cross-repo FEC/F3E redesign suitability and adoption gate
   Scope: Review DnaVisiCalc redesign (`4d4c7a6`) vs baseline (`9eac9e6`) and capture blocker-level gate for core seam adoption.
   Why it matters: Determines whether transactional seam is safe to promote into DNA Calc core engine model.
   Target docs/sections: `CORE_ENGINE_FORMAL_MODEL.md` (`3.18`, `5.4`, `6.4`), `ARCHITECTURE_AND_REQUIREMENTS.md` (`3.18`, `4 CONSTR-*`), `OPERATIONS.md` (`4`, `8` pack implications).
   Related decisions (DEC-CALC-*): `DEC-CALC-009`
   Suggested evidence/probes: seam trace rejection-path adversarial tests, snapshot-race contention harness, name-path incremental invalidation scenarios.
   Priority: high
   Blocking for synthesis: yes
   Status: stabilized (captured in `outputs/05_fec_f3e_redesign_review.md`)
2. Topic ID: TQ-010
   Title: Post-review b4 pointer bundle intake
   Scope: Use `ENGINE_FEC_F3E_FOUNDATION_UPDATED_SPEC_POINTERS_PROMPT.md` as the handoff source and ingest all pointer-linked spec, review, trace, and implementation docs.
   Why it matters: Aligns Foundation synthesis intake with the latest intended DnaVisiCalc handoff set.
   Target docs/sections: `CORE_ENGINE_FORMAL_MODEL.md` (`3.18`, `5.4`, `6.4`), `ARCHITECTURE_AND_REQUIREMENTS.md` (`3.18`), `OPERATIONS.md` (`4`, `8`).
   Related decisions (DEC-CALC-*): `DEC-CALC-009`
   Suggested evidence/probes: b4 trace schema validation, spill fail/recovery scenario coverage, coordinator contention harness planning.
   Priority: high
   Blocking for synthesis: yes
   Status: stabilized (captured in `outputs/06_fec_f3e_b4_pointer_intake.md`)
