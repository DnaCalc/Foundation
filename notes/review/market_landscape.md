# Annex B: Spreadsheet Market and Technology Landscape

## 1. Market Size and Dynamics

- Spreadsheet software market: ~$10.25B (2024), projected ~$20.85B by 2033 (CAGR ~9.12%)
- Excel: ~$13.8B revenue, ~800M active users
- Google Sheets: ~$1.3B revenue, 160-180M users
- 72% of North American enterprises use spreadsheets extensively for financial modeling, planning, and BI

## 2. The Error Problem (Underserved Market)

Research by Panko/EuSpRIG shows:
- 86-94% of audited spreadsheets contain errors
- Average cell error rate: 3.9%
- Spreadsheets are "rarely tested"

This represents a massive market gap for a spreadsheet tool that reduces errors through better type systems, testing, or verification. DNA Calc's formal semantics could directly address this.

## 3. AI Integration (2025-2026)

**Microsoft Excel COPILOT()**: Native cell function accepting natural-language prompts, returning AI-generated results that recalculate when data changes. Rate limits: 100 calls per 10 minutes. Microsoft describes Excel as "shifting from formula-driven to instruction-driven."

**Google Sheets =AI()**: Powered by Gemini. Supports natural language prompts, data analysis, text summarization, sentiment evaluation, classification, and Python code generation.

**Implication for DNA Calc**: AI is creating a platform transition moment. If DNA Calc can combine formal semantics with AI-generated formulas (verifying AI output against formal specs), it would offer something neither Excel nor Google Sheets can: provably correct AI-assisted computation.

## 4. Promising Challenger Approaches

### Database-Spreadsheet Hybrids
- Airtable, Baserow (open-source), Teable (AI features), NocoBase

### AI-Native Spreadsheets
- Rows (Berlin, $32.7M total funding, "world's first AI Analyst")
- Coda (document/spreadsheet/app hybrid)

### Connected Spreadsheets
- Canvas (browser-based, connects SaaS + data warehouses to spreadsheet views)

### Non-Traditional Approaches
- **Doss + Materialize**: Streaming materialized views replace formulas. "Formulas that took minutes now complete in under a second at 10,000x scale."
- **Python-in-Excel**: Microsoft's Python integration enables data science workflows in spreadsheets
- **No-code app platforms (Glide, Tadabase)**: Convert spreadsheet data into applications

## 5. Incremental Computation Frameworks

| Framework | Best For | .NET Port? | Spreadsheet Relevance |
|-----------|----------|------------|----------------------|
| **Salsa** (Rust) | IDE/compiler queries | No | Demand-driven, memoized; proven in rust-analyzer |
| **Jane Street Incremental** (OCaml) | Finance, UI, spreadsheets | **Yes (F#)** | Explicitly designed for "spreadsheet-like recalculation" |
| **Skip** (Meta/SkipLabs) | Backend reactive services | No | Automatic dependency tracking and cache invalidation |
| **Differential Dataflow** (Rust) | Distributed analytics | No | Proven for large-scale incremental computation (Materialize) |
| **Adapton** (OCaml/Rust/Racket) | Research | No | Demand-driven model suited for visible-cell-only recomputation |

**Recommendation**: For the Rust engine, evaluate Salsa's incremental model (proven in rust-analyzer, parallel support coming in v3.0). For conceptual invariants, adopt Jane Street Incremental's discipline (necessary/stale/height/scope).

## 6. Potential Market Positions for DNA Calc

### Position A: Embeddable Engine (HyperFormula Competitor)
- Target: Developers building spreadsheet-powered applications
- Product: Rust crate + WASM module + .NET package
- Revenue: License fees + support contracts
- Competition: HyperFormula (GPL/proprietary), FormulaJS (small), Apache POI (Java)
- Advantage: Formally verified core, Rust performance, deterministic mode

### Position B: Compliance/Audit Spreadsheet
- Target: Regulated industries (finance, pharma, aerospace)
- Product: Desktop/web spreadsheet with deterministic computation, audit trail, formal guarantees
- Revenue: Enterprise licenses
- Competition: Excel (dominant but no formal guarantees), specialized audit tools
- Advantage: Only spreadsheet with provable computation semantics

### Position C: AI-Safe Computation Platform
- Target: Organizations using AI in decision-making
- Product: Spreadsheet where AI-generated formulas are formally verified before execution
- Revenue: SaaS subscription
- Competition: None (novel category)
- Advantage: Unique value proposition

### Position D: Open-Source Community Project
- Target: Developer/enthusiast community
- Product: Open-source spreadsheet engine and tools
- Revenue: Commercial support, dual licensing, consulting
- Competition: LibreOffice Calc, Gnumeric
- Advantage: Modern architecture, formal properties, Rust performance
