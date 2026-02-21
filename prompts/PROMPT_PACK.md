# PROMPT_PACK.md — DNA Calc Improvement Prompts

Below is a “prompt pack” you can reuse. Each one assumes you’ll paste the four docs (**CHARTER**, **OPERATIONS**, **ARCHITECTURE_AND_REQUIREMENTS**, **BRAINSTORM_NOTES**) at the end.

I’ve written these so you can aim them at different kinds of helpers (spec-minded, concurrency-minded, UI/perf-minded, interop-minded, planning-minded).

---

## Universal wrapper (paste above any prompt)

```text
You will receive four documents: CHARTER.md, OPERATIONS.md, ARCHITECTURE_AND_REQUIREMENTS.md, and BRAINSTORM_NOTES.md.

Treat them as the current source of truth. If you find contradictions, list them explicitly and propose a single coherent resolution.

Output style:
- Be concrete and structured.
- Prefer checklists, tables, and small diagrams (ASCII is fine).
- When you propose changes, include exact section headings/IDs to edit.
- End with the smallest set of next actions that produce the biggest reduction in risk.
```

---

## 1) Green: “Spec stack gap finder”

```text
Read the docs and produce a “missing pieces” report for Round 0 (DnaVisiCalc) that is ruthless about scope.

Deliver:
1) The minimum set of semantic features required for DnaVisiCalc to be a meaningful pathfinder.
2) A list of underspecified terms (profile, meta-epoch, stabilization, stale, etc.) with proposed crisp definitions.
3) A ranked list of spec modules to write first (L0/L1/L2/L3/L4/L7), with dependencies.
4) A short list of non-goals for DnaVisiCalc that should be explicitly stated.
```

## 2) Green: “Lean module plan + theorem backlog”

```text
Assume Lean will prove the core calculus for DnaVisiCalc. Propose a Lean module layout and a theorem backlog that is realistically achievable.

Deliver:
- Module tree (filenames and responsibilities)
- Data types to define (values/errors/refs/ranges/expressions)
- Theorem list (determinism, rewrite correctness for one structural edit, etc.)
- A strategy for keeping proofs small (e.g., parameterize UDF/STREAM as an oracle)
- A tiny “alignment pack” plan: how Lean will emit bounded test instances that OCaml must match
```

## 3) Green: “TLA+ concurrency protocol model outline”

```text
Model-check the async/event-processing core with TLA+. Propose the smallest TLA+ model that still catches real bugs.

Deliver:
- State variables (epochs, snapshots, queues, in-flight, commit rules)
- Actions (SetCell, StructuralEdit, ExternalUpdate/STREAM update, TaskFinish, DropStale, Stabilize)
- Safety invariants (no stale commit, snapshot consistency, exclusive mutation atomicity)
- Liveness claims and fairness assumptions
- A plan for TLC configurations: smallest interesting bounds and how to scale them over time
```

## 4) Green: “OCaml oracle CLI contract + shrinker”

```text
Design the OCaml oracle as a CLI toolchain. Keep the interface stable and file-based.

Deliver:
- CLI commands (run trace, eval snapshot, shrink failing trace, explain mismatch)
- Canonical file formats needed (trace, snapshot, expected checkpoints, conformance report)
- Shrinker strategy (how to minimize traces while preserving failure)
- How to keep the oracle deliberately simple (and what it must not include)
- How to support both manual and auto recalc in the reference stepper
```

---

## 5) Red: “Rust engine architecture review (conformance-first)”

```text
Act as the Rust implementation lead. Propose an engine design that conforms to the protocol surface and supports async + multithread from day 1.

Deliver:
- Component diagram (coordinator, snapshot store, worker pool, caches)
- Data ownership rules (who mutates what, where locks are allowed, where they are forbidden)
- How epochs flow through the system and how stale/pending are represented
- Strategy for UDF execution (thread-safe vs serialized) without poisoning determinism
- Top performance risks and how to instrument them early
```

## 6) Blue: “.NET engine architecture review (independent compiler mindset)”

```text
Act as the .NET engine lead. Propose an independent implementation plan that will catch ambiguity in the spec.

Deliver:
- Architecture that mirrors protocol surfaces but uses idiomatic .NET concurrency patterns
- The top 10 “spec ambiguity traps” you predict will surface during implementation
- A plan for deterministic mode and for reproducing schedule-sensitive bugs
- A minimal internal IR or data layout that keeps performance acceptable
- How you would structure tests to triangulate: OCaml oracle vs .NET vs Rust
```

---

## 7) Logistics: “.NET meta tool and obligation resolver”

```text
Design the meta-control tooling as a .NET CLI (Green/Red/Blue/Logistics all use it). It must compute the affected DAG closure and run only required packs.

Deliver:
- Command list (check, resolve, run-pack, report, pin-profile, etc.)
- Inputs (docs, profile definitions, changed files) and outputs (capabilities, conformance reports)
- How obligation packs are declared (schema) and how the resolver computes closure
- Caching strategy to keep runtimes low
- CI integration plan and local dev ergonomics plan
```

## 8) Logistics: “Evidence log for clean-room Excel compatibility”

```text
Produce a clean-room compliance workflow that is practical.

Deliver:
- What constitutes admissible evidence (public docs, observed behavior with reproducible harness)
- An “evidence record” format (what fields are required)
- How evidence links to spec items (REQ/INT/REAL IDs)
- How to handle version-dependent Excel behavior (compat versions/profiles)
- Anti-footgun rules: what must never be introduced into the repo or spec stack
```

---

## 9) UI/Performance: “Canvas grid reliability and test strategy”

```text
Design the UI reliability approach for the Tauri + canvas grid + DOM editor stack.

Deliver:
- Minimal view-state reducer model (key states, transitions)
- Geometry/hit-test functions and invariants to property-test
- RenderPlan IR sketch (draw ops) and how to test it without screenshots
- Virtualization and caching plan (tiles, dirty rects, text measurement caching)
- What UI behavior belongs in model vs view vs adapter
```

## 10) Performance: “Scaling signature suite (Big-O smell detector)”

```text
Design the scaling characterization suite for DnaVisiCalc that produces early Big-O signals.

Deliver:
- Workload generators (chain, fan-in, fan-out, grid, random sparse, structural insert)
- Metrics and counters to collect per phase (parse/bind/closure/schedule/eval/commit)
- How to compute and report scaling slopes (log-log fits) and detect regressions
- Determinism rules for stable measurements
- How to store results as artifacts and gate regressions later
```

---

## 11) Interop: “Degrade gracefully without surprises”

```text
Given the profiles + extensions approach, produce a concrete degrade/preserve policy matrix.

Deliver:
- For each category (formula feature, object model feature, file feature), define: Native / Lowered / Opaque / Rejected
- Error mapping rules (what error shows up in non-supporting builds/export targets)
- Round-trip strategy for unknown OOXML parts and extension payloads
- How to make this visible to users and automation (diagnostics API shape)
- Minimal set of policies needed already in DnaVisiCalc vs deferred to DnaPreCalc
```

## 12) Collaboration: “OpLog replication seam and evolution plan”

```text
Design collaboration as an OpLog replication layer that can start deterministic (server-sequenced) and evolve later.

Deliver:
- Minimal op schema requirements for replication (idempotency, ordering, transaction grouping)
- Identity strategy for structural edits (what must be stable now vs later)
- How epochs and stabilization interact with remote ops
- What is shared vs local (doc vs calc vs oracle values)
- A staged plan: seam now, basic presence later, richer collaboration later
```

---

## 13) Planning: “Round 0→1→2→3 milestone map”

```text
Turn the docs into a 0→1→2→3 milestone map with hard exit criteria and artifact freezes.

Deliver:
- For each round (DnaVisiCalc, DnaPreCalc, DnaSuperCalc, DnaCalc):
  - objectives
  - non-goals
  - exit criteria
  - artifacts that must be frozen before proceeding
- Identify which risks are retired in each round and which remain
- Provide a small ‘first 30 days’ plan for DnaVisiCalc
```

## 14) Review: “Consistency audit and refactor suggestions for the docs”

```text
Audit the four documents for consistency, missing definitions, and places where categories are mixed (requirements vs architecture vs doctrine).

Deliver:
- A list of contradictions or duplications with recommended resolution
- A list of missing IDs/sections that should exist
- Proposed doc edits: exact headings and where to move text
- A short ‘docs hygiene’ checklist for future changes
```

---

### Quick tip for using these

For best results, run the same prompt twice:

* once asking for “minimal viable pathfinder”
* once asking for “future-proof shape”
  Then compare and keep only what survives both.

If you want, I can also give you a “triad prompt” template that you can run as three separate roles (Design / Assurance / Delivery) on the same question and then synthesize their outputs.


=========================================================================

Here’s a reusable **Triad Prompt** pattern that you can run as three separate chats (or three separate agent runs): **Design**, **Assurance**, and **Delivery**. Then there’s a fourth “Synthesis” prompt to merge them.

---

## Triad Prompt — Design

```text id="u0rxit"
You are the DESIGN voice (spec + structure). Use the four docs as source of truth.

Task: <PASTE THE QUESTION / TOPIC HERE>

Output:
1) Decision framing: what must be decided vs what can be deferred.
2) Proposed spec shape: modules, boundaries, and profile/feature-gate implications.
3) Crisp definitions for any new terms introduced.
4) A minimal viable scope (Pathfinder) and a forward-compatible scope (0→1→2→3).
5) The smallest set of doc edits needed (section headings + what to add/remove).
Constraints:
- Do not propose implementation details unless needed to make the spec testable.
- Prefer explicit versioning and graceful degradation rules.
```

## Triad Prompt — Assurance

```text id="t3at2r"
You are the ASSURANCE voice (validation, proofs, conformance, cases). Use the four docs as source of truth.

Task: <PASTE THE QUESTION / TOPIC HERE>

Output:
1) Failure modes: what can go wrong and how we’ll detect it.
2) Required obligation packs (Lean/TLA+/OCaml oracle/traces/perf) to claim readiness.
3) A test strategy: goldens, property tests, differential tests, shrink/minimization plan.
4) Proposed invariants and what tool checks each (Lean theorem vs TLA+ invariant vs runtime assertion).
5) Evidence requirements for Excel compatibility claims (if relevant).
Constraints:
- Aim for “machine-checkable” outcomes.
- Prefer deterministic modes for reproducibility.
- Call out any spec ambiguity that blocks validation.
```

## Triad Prompt — Delivery

```text id="50k1a0"
You are the DELIVERY voice (implementations: Red/Rust and Blue/.NET). Use the four docs as source of truth.

Task: <PASTE THE QUESTION / TOPIC HERE>

Output:
1) Implementation impact: what this means for both engines and the shared protocol surface.
2) A minimal implementable plan that passes the packs without overbuilding.
3) Risk hotspots for concurrency/performance/interop and how to instrument early.
4) Where the spec must be sharper to avoid divergent implementations.
5) A “first working demo” definition that proves end-to-end flow (ops→snapshot→deltas).
Constraints:
- Keep engines independent; do not rely on shared runtime dependencies.
- Respect architectural constraints (no hidden mutation paths; adapters outside core).
- Prefer designs that keep deterministic mode feasible.
```

---

## Triad Synthesis Prompt (run after you have the three outputs)

```text id="vhnge8"
You will be given three reports: DESIGN, ASSURANCE, DELIVERY for the same task.

Synthesize them into:
1) A single recommended decision set (what we do now vs later).
2) A unified plan with explicit sequencing: Spec → Packs → Implementations → Stabilization.
3) A list of required doc changes (exact headings/IDs).
4) A list of obligation packs and success criteria for “green.”
5) Open questions tagged by owner: Design vs Assurance vs Delivery.

Rules:
- If there is conflict, prefer the option that preserves evolvability and validation rigor.
- Keep Pathfinder scope minimal but future-compatible (0→1→2→3).
- The final plan must be actionable in one development cycle.
```

---

### One practical way to use it

Pick a concrete topic, e.g.:

* “Define STREAM + external updates semantics for DnaVisiCalc”
* “Define external UDF registration and execution model for Pathfinder”
* “Define structural insert operation and reference rewrite rules”

Run Design → Assurance → Delivery → Synthesis. Then turn the synthesis into Orders for the next tick.

If you want, tell me a topic you’re about to tackle first, and I’ll pre-fill the `<PASTE THE QUESTION / TOPIC HERE>` for the triad prompts with a well-scoped task statement.
