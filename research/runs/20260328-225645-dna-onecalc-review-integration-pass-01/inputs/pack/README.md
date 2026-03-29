# DNA OneCalc Spec Pack

DNA Calc is a clean-room spreadsheet platform program aimed at Excel-level behavioral fidelity with stronger specification, replay, and verification discipline than a conventional application stack. The program is intentionally decomposed into long-lived ownership lanes such as formula semantics, function semantics, replay infrastructure, VBA hosting, and Excel observation, with proving hosts used to compose those lanes into focused products and validation environments.

At the current stage, the program is pursuing two major proving directions in parallel. One direction centers on `OxFml`, `OxFunc`, `OxReplay`, and `OxXlObs`, with `DNA OneCalc` acting as the first serious single-node proving host and product shell. The other direction centers on `OxCalc` and the early multi-node engine seam, which is intentionally separate so that OneCalc can remain narrow, fast-moving, and honest about what it does and does not own.

A central design principle across the project is that regressions should become durable assets. Replay bundles, minimized witnesses, Excel observation artifacts, and capability manifests are not treated as auxiliary logs; they are part of the program semantic and assurance spine. That is why the OneCalc pack combines the host spec with consolidated upstream lane references instead of treating those materials as secondary background reading.

This pack is intentionally compact. Rather than preserve the entire original hierarchy, it keeps one main OneCalc spec, one merged reference document per relevant upstream repo, and this README. Each merged reference file reproduces the underlying source documents in full and labels their original paths, so the pack remains self-contained while staying small enough to navigate easily.

## Relevant Sub-Projects

### Foundation
Foundation is the doctrine, architecture, and planning authority for the wider DNA Calc program. It owns the host progression, replay doctrine, project-wide constraints, and the consolidated OneCalc scope note in this pack, but it deliberately does not take semantic ownership away from the lane repos.

### OxFml
OxFml owns formula language semantics, evaluator behavior, host/runtime packets, FEC/F3E seam meaning, and the editor-grade language-service substrate. For DNA OneCalc, this is the primary semantic dependency because it defines how a formula is parsed, bound, evaluated, diagnosed, traced, and projected into replay artifacts.

### OxFunc
OxFunc owns the value universe and function or operator semantics that OxFml consumes. It is also the upstream source of function catalog truth, typed host-query bundles, return-surface hints, and the metadata that OneCalc needs for help, completion, admitted-surface declarations, and later native-extension integration.

### OxReplay
OxReplay is the shared replay infrastructure repo. It owns bundle validation, adapters, diff and explain surfaces, witness lifecycle mechanics, and the generic `DNA ReCalc` replay host, while allowing a downstream host like DNA OneCalc to embed those mechanics without collapsing the host boundary.

### OxXlObs
OxXlObs is the Windows-only Excel observation lane. It drives live Excel, captures provenance-rich observation artifacts, and emits replay-ready bundle seeds so that OneCalc can compare retained DNA runs against retained Excel observations without taking semantic authority over Excel itself.

### OxCalc
OxCalc owns the multi-node calculation engine and the coordinator-facing side of the evaluator seam. DNA OneCalc does not depend on OxCalc at runtime, but OxCalc remains an important seam-reference repo because its current downstream host notes and packet docs show what the shared OxFml interface really looks like under a serious consumer.

### OxVba
OxVba owns VBA compilation, runtime hosting, project modeling, and later add-in or host integration work. For OneCalc it is a staged-later dependency: highly relevant to the future native-extension and VBA-UDF story, but still at a design-heavy stage for add-in generation and broad host packaging.

## DNA OneCalc
DNA OneCalc is the single-node proving host and product shell that combines OxFml, OxFunc, OxReplay, and OxXlObs into an interactive `Twin Oracle Workbench`. Its core job is to let a user author a single formula scenario, drive that scenario through the evaluator and function stack, inspect semantic X-ray surfaces such as diagnostics, traces, replay state, and provenance, compare against Excel where the observation lane is mature enough, and then turn mismatches into retained witnesses and upstream work items rather than isolated debugging sessions.

## Document List

- `README.md`: Front-door overview of the DNA Calc program, the relevant sub-projects, DNA OneCalc, and the compact pack structure.
- `DNA_ONECALC_SCOPE_AND_SPEC.md`: The current canonical OneCalc scope, design, work breakdown, upstream-gap reading, and merged-reference index.
- `OXFML_REFERENCE.md`: Consolidated OxFml evaluator, host/runtime, FEC/F3E, language-service, formatting, conditional-formatting, and replay reference set.
- `OXFUNC_REFERENCE.md`: Consolidated OxFunc function/value semantics, snapshot/catalog metadata, typed host-query bundle, replay packet, and extension-seam reference set.
- `OXREPLAY_REFERENCE.md`: Consolidated OxReplay replay-consumption, bundle/witness, adapter/capability, and DNA ReCalc host reference set.
- `OXXLOBS_REFERENCE.md`: Consolidated OxXlObs Excel observation, provenance, bundle emission, capability, scenario, CLI, and retained evidence reference set.
- `OXCALC_REFERENCE.md`: Consolidated OxCalc seam-reference and coordinator-facing evaluator-consumer reference set.
- `OXVBA_REFERENCE.md`: Consolidated OxVba hosting, project model, platform profile, host bridge, and planned add-in/XLL reference set.
