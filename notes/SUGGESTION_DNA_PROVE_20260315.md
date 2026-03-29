# Suggestion: DNA Prove — Formally-Verified Excel Function Semantics Oracle

Status: `suggestion`
Date: 2026-03-15
Origin: strategic analysis of highest-leverage addition to DNA Calc program

## Context — What DNA Calc Uniquely Has

DNA Calc possesses an asset no other spreadsheet project in the world has: **deep, clean-room, empirically-verified, formally-proven knowledge of how Excel functions actually behave.** Forty-plus functions characterized to full semantic parity. 150 artifacts in function-lane. Lean proofs. Rust implementations. Coercion matrices. Version-scoped edge cases. Documented discrepancies between Microsoft's public documentation and actual Excel behavior. All built under strict clean-room discipline.

This knowledge is currently locked inside OxFunc's working artifacts and the project's internal doctrine. Nothing is externally visible. The independent review flagged this as "Doctrine Recursion" — formidable rigor with zero externally-exercisable artifacts.

Meanwhile: 86-94% of audited spreadsheets contain errors. AI systems generate Excel formulas without semantic verification. Regulated industries spend millions on manual spreadsheet audits. And no open, formal, machine-readable specification of Excel function semantics exists anywhere.

## The Suggestion

**DNA Prove: A formally-verified Excel function semantics oracle — published as an open Rust crate, compilable to WASM, and exposed as an MCP server for AI-assisted formula verification.**

### What It Is (Concretely)

A standalone library extracted from OxFunc's existing Rust function kernels and formal contracts, packaged so that any program can call Excel-compatible function evaluations backed by Lean-proven semantics.

Three delivery surfaces, built incrementally:

1. **Rust crate** (`dna-prove`): Embeddable function-call evaluation. Takes a function identifier + typed arguments, returns the Excel-correct result. Each function carries metadata: version scope, coercion behavior, edge-case classifications, formal proof coverage status. No formula parser required — this operates at the function-call level, below OxFml's territory.

2. **WASM package**: The same crate compiled to WebAssembly. Enables browser-based and Node.js-based function evaluation — directly useful for web spreadsheet projects, data validation pipelines, and educational tools.

3. **MCP server**: A Model Context Protocol tool server that AI assistants (Claude, etc.) can call to verify function behavior. "What does SUM do with a string argument?" → formally-verified answer with version scope and evidence references. This is the AI-safe computation angle the independent review flagged as genuinely novel.

### What It Is NOT

- Not a formula parser (that's OxFml's job)
- Not a spreadsheet engine (that's OxCalc/DNA TreeCalc)
- Not a competing lane (it's a thin packaging layer over existing OxFunc work)
- Not a spec publication exercise (it's executable, not documentary)

## Why This Is THE Answer

**Radically innovative:** The world's first formally-verified spreadsheet function evaluation library. No other project has the formal backing to make this claim. LibreCalc, Google Sheets, HyperFormula — all test-backed, none proof-backed. DNA Prove would be unprecedented.

**Maximally accretive:** Every function OxFunc completes (W014, W015, W016, and beyond) immediately expands the oracle's capability. Every Lean proof, every evidence pack, every coercion edge case — already being produced — feeds directly into the library's metadata. The work is already being done; this is about making it externally exercisable.

**Useful immediately:** Embed Excel-compatible function evaluation in CI pipelines, data validation, ETL workflows, web applications, or AI systems. Start with 40 functions — that's already more than enough for real use cases. SUM, IF, VLOOKUP, INDEX, MATCH, TEXTJOIN, EXACT — these cover the majority of real-world spreadsheet usage.

**Compelling:** "Evaluate Excel functions with formally-verified semantics" is a one-sentence pitch. For regulated industries (finance, pharma, energy), "provably correct spreadsheet computation" is not a nice-to-have — it's a compliance advantage. For AI companies, "verify AI-generated formulas against formal models" is an immediate differentiator.

**Non-interfering:** The library is a thin wrapper over OxFunc's existing `crates/` implementations. It doesn't redirect OxFunc's development — it CONSUMES its outputs. It doesn't compete with OxFml (no formula parsing). It doesn't compete with OxCalc (no dependency graph). It's a new delivery surface for existing work.

**Breaks the Doctrine Recursion:** It's the first EXECUTABLE, externally-visible artifact of the DNA Calc project. It proves the formal methods approach delivers practical value. It creates real-world testing pressure against the formal models. And it does this without compromising the rigor that makes the project unique.

**Seeds the ecosystem:** The charter envisions "a long-lived ecosystem of tools, add-ins, and automation." DNA Prove is the first tool in that ecosystem. Other projects can build on it: spreadsheet linters, formula auditors, educational tools, AI guardrails.

## What It Leads To

DNA Prove is not an endpoint — it's a keystone.

- When OxFml ships formula parsing → add it on top of DNA Prove → you get **DNA OneCalc** (single-node evaluator)
- When OxCalc ships the coordinator → add it on top → you get **DNA TreeCalc**
- When OxVba ships the runtime → integrate with DNA Prove for VBA function calls
- The MCP server becomes a live demonstration of DNA Calc's value proposition
- The open crate creates community, credibility, and real-world feedback

## The Unique Strategic Position

DNA Calc is building toward "a near-formal, state-of-the-art spreadsheet platform." Most people hear that and think: "so, a spreadsheet app?" DNA Prove reframes the narrative: DNA Calc is building **the verified computation layer for spreadsheet semantics** — and here's a library you can use today.

The AI angle is especially timely. AI systems increasingly generate formulas and spreadsheet logic. But there's no verification layer between "AI generated this formula" and "this formula is in a financial model." DNA Prove fills that gap with formal backing that no heuristic linter can match.

## Concrete Shape (Initial)

```
dna-prove/                    # New repo in DnaCalc family
├── CHARTER.md                # Lane charter (consumer of OxFunc, not a new dev lane)
├── AGENTS.md                 # Standard doctrine alignment
├── OPERATIONS.md             # Lightweight — this is a packaging/publishing lane
├── crates/
│   └── dna-prove/            # Core Rust crate
│       ├── src/
│       │   ├── lib.rs        # Public API: evaluate(FunctionId, &[Value]) -> Result
│       │   ├── functions/    # Re-exports from OxFunc crate(s)
│       │   ├── types/        # Value types, coercion, version scope
│       │   └── metadata/     # Formal coverage status, edge-case catalog
│       └── Cargo.toml
├── wasm/                     # WASM build target
├── mcp-server/               # MCP tool server
│   ├── src/
│   │   ├── main.rs
│   │   └── tools/            # evaluate_function, describe_function, check_edge_cases
│   └── Cargo.toml
└── tests/                    # Integration tests against OxFunc conformance data
```

## Open Questions

1. **OxFunc crate maturity:** How packagable are the current Rust function kernels in `crates/`? Can they be consumed as a library dependency, or are they tightly coupled to the OxFunc repo structure?

2. **Lean extraction:** Is there appetite to explore Lean code extraction (to C or via FFI) for a "verified core" path, or should the initial oracle rely purely on the Rust implementations with Lean proofs as documentation/metadata?

3. **Scope of initial release:** Start with a curated subset (the 20 most-used functions) or ship all 40+ from day one?

4. **Licensing:** The charter mentions clean-room discipline. Is there a licensing model in mind for open-source publication of function evaluation code?

5. **Does this direction resonate?** The alternatives considered were: (a) open specification corpus without executable code, (b) conformance test benchmark, (c) formula verification tool (depends on OxFml parser). DNA Prove was chosen because it's executable, buildable now, and doesn't depend on OxFml.
