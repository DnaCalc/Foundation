# DnaCalc Foundation

Working docs for the DNA Calc program foundation and planning.
DNA Calc is developed by DNA Kode.

**Current phase context (2026-03-09):**
The program has completed the DnaVisiCalc pathfinder phase — engine scope is exercised; formal artifact exit (Track B) remains outstanding.
Next focus shifts to two parallel lanes: **OxFml** (formula/evaluator lane with FEC/F3E spec ownership) using DNA OneCalc as the proving host, and **OxCalc** (core engine lane) starting with tree-only substrate via DNA TreeCalc.
Foundation remains the doctrine, architecture, and conformance policy owner. It does not own implementation or spec artifacts once they transfer to lane repos.
The Wave sequence A-G in `OPERATIONS.md` Section 10.3 governs execution order. Wave A ownership freeze and FEC/F3E spec transfer to OxFml are the immediate next actions.

Start with `CHARTER.md` for mission/doctrine, then `ARCHITECTURE_AND_REQUIREMENTS.md` for the system shape and constraints.
Use `CORE_ENGINE_FORMAL_MODEL.md` for ongoing core formal/semantic model work and extraction of formal details from architecture docs.
Use `CORE_ENGINE_THEORY_AND_ALTERNATIVE_PATHS.md` for theory-grounding, source-traceable synthesis coverage, and complementary paths-not-taken framing.
Use `OPERATIONS.md` for team/process mechanics, `notes/BRAINSTORM_NOTES.md` for captured ideas, and `prompts/` for reusable prompt packs.
Use `notes/README.md` for active-vs-archive notes indexing.
Use `notes/RUNNING_PROJECT_NOTES.md` as the active short-lived scratchpad.
Use `notes/RESEARCH_NOTES.md` for synthesized retained research knowledge.
Use `notes/THEORY_TO_PACK_REGISTER.md` for mapping theory claims to proof/pack/deferred obligations.
Use `notes/VISICALC_V0_SCOPE_ALIGNMENT_NOTES.md` for retained v0 scope-alignment notes and deferred expansion backlog from superseded pathfinder guidance docs.
For DnaVisiCalc Round 0 functional scope, treat `..\\DnaVisiCalc\\docs\\SPEC_v0.md`, `..\\DnaVisiCalc\\docs\\ENGINE_REQUIREMENTS.md`, and `..\\DnaVisiCalc\\docs\\ENGINE_API.md` as authoritative.
Use Foundation docs to hold doctrine, architecture framing, and process that remain consistent with that upstream scope.

Program map (working baseline):
- Component lanes: `Foundation`, `DnaVisiCalc`, `OxFunc`, `OxFml`, `OxCalc`, `OxVba`.
- Host progression: `DNA VbCalc` -> `DNA OneCalc` -> `DNA TreeCalc` -> `DNA PreCalc` -> `DNA SuperCalc` -> `DNA Calc`.
- Round names remain authoritative stage names; host names are execution vehicles.

See `prompts/README.md` for prompt execution guidance and run artifacts.
See `research/README.md` for topic/source registry and deep-research run artifacts.
See `reference/README.md` for reference-spec mirror, managed processing runs, and curated empirical conformance findings.
Active OxFunc function/value working docs now live in `..\OxFunc\docs\function-lane\`; Foundation keeps the Excel reference/spec corpus under `reference\`.
See `REFERENCE_SPEC_FORMAT_AND_CONFORMANCE.md` for the normalized reference/conformance artifact contract.
See `tools/README.md` for local tooling layout and policy notes.
See `synthesis/README.md` for synthesis-pass workflow and decision logging.
