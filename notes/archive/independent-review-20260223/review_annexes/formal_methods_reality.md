# Annex C: Formal Methods Cost/Benefit Analysis

## 1. The Cost of Formal Verification

### 1.1 Empirical Data

| Project | Code Size | Proof Effort | Cost Multiplier | Notes |
|---------|-----------|-------------|-----------------|-------|
| seL4 | 9,000 LOC (C+asm) | 20 person-years | ~5x (first-of-kind) | Estimated 8 py if redone |
| CompCert | ~100K LOC (compiler passes) | 6 person-years | ~2x | Modular structure helped |
| s2n-tls | Subset of TLS | Ongoing (CI/CD) | ~1.5x (incremental) | Continuous re-verification |
| AWS TLA+ | Models: 100-939 lines | 2-3 weeks/model | ~0.1x (spec only) | Finds bugs before code exists |

### 1.2 Scaling Laws

- A **quadratic relationship** exists between the size of a formal statement and its proof in interactive provers like Isabelle.
- For landmark projects, the cost multiplier is "probably well in excess of 10x."
- For many systems, the multiplier is "effectively infinity" because "we don't know how to verify something like MS Word."

### 1.3 Estimated Cost for DNA Calc

| Component | Estimated LOC | Verification Approach | Estimated Effort |
|-----------|--------------|----------------------|-----------------|
| Core formula evaluator | 5,000-15,000 | Lean semantics proofs | 2-6 person-years |
| Epoch/concurrency protocol | 200-500 (model) | TLA+ model checking | 2-6 person-weeks |
| Full calc engine | 50,000-200,000 | Full formal verification | 25-200+ person-years |
| File I/O adapters | 20,000-50,000 | Not formally verifiable | N/A |
| UI | 30,000-80,000 | Property-based testing | N/A |

**Conclusion**: Full formal verification of the entire system is infeasible. Targeted verification of critical components (epoch protocol via TLA+, core semantics subset via Lean) is feasible and high-value.

## 2. What Actually Gets Verified in Practice

### 2.1 AWS TLA+ Usage

7+ teams, 10+ large systems. Learning curve: 2-3 weeks. Key results:
- **DynamoDB**: 3 bugs found in 939-line PlusCal model. "Would never have been found through conventional testing."
- **S3**: 2 bugs found in 804-line model + more in proposed optimizations
- **EBS**: 3 bugs found in 102-line model
- **Kafka** (external): 4 edge cases that "could have led to data loss"

**The pattern**: Small models (100-900 lines), targeted invariants, engineering-accessible (2-3 week ramp-up), integrated with development workflow.

### 2.2 Lean 4 Industry Adoption (2025-2026)

- **AWS Cedar**: Authorization policy language verified in Lean 4
- **StarkWare**: Formal verification of Cairo semantics and STARK correctness in Lean 4
- **Harmonic AI**: $100M funding for "hallucination-free" AI using Lean 4 proofs
- **2025 ACM SIGPLAN Programming Languages Software Award** to Lean team

**The pattern**: Lean 4 is gaining industrial traction, primarily in security-critical and AI verification domains. Adoption is accelerating but still niche.

### 2.3 What Happens When Requirements Change

- Maintaining proofs as code evolves is a "dominant cost driver"
- Best practice: modular specifications and regular reviews
- Amazon's pragmatic approach: "incrementally refining parts of conventional prose design documents into PlusCal or TLA+"
- Proof maintenance is expected to favor formal verification "within a decade" due to maintenance cost savings

## 3. Recommendations for DNA Calc

### Do Now
- **TLA+ for epoch/concurrency protocol**: 2-6 weeks of effort. High ROI. The foundation documents already have an excellent model design (prompt response 03). Implement it.
- **Property-based testing**: Rust's proptest crate. Follow SQLite's model of massive random testing. This is the highest ROI testing approach for a calculation engine.
- **Fuzzing**: Rust's cargo-fuzz. Mutate formulas and data simultaneously. SQLite runs 1 billion fuzz mutations per day with 2 people.

### Do Later (After Implementation Exists)
- **Lean proofs for core formula semantics**: After the evaluator exists and the AST is stable. Proving properties of code that doesn't exist yet is wasted effort because the code will change.
- **Scaling signature suite**: After the engine can evaluate formulas. The design in prompt response 10 is good.

### Don't Do
- **Full formal verification of the engine**: Infeasible at any reasonable cost. Use testing instead.
- **OCaml oracle**: The effort to build and maintain a separate implementation in OCaml is better spent on more tests for the Rust engine. Use Excel observation harnesses for compatibility validation.
- **Lean proofs for file I/O or UI**: These domains are not amenable to formal verification and should rely on testing.

## 4. The Testing Alternative

SQLite's testing methodology provides a more practical quality model:

| Metric | SQLite | DNA Calc Target (Year 1) | DNA Calc Target (Year 3) |
|--------|--------|--------------------------|--------------------------|
| Test-to-code ratio | 590x | 10x | 100x |
| Branch coverage | 100% (TH3) | 80%+ | 95%+ |
| Fuzz mutations/day | 1 billion | 1 million | 100 million |
| Regression corpus size | 58,497 distinct cases | 1,000+ | 10,000+ |
| Bug-becomes-test policy | Mandatory | Mandatory from day 1 | Mandatory |

**The key insight**: SQLite achieves "alien artifact" quality through *testing at industrial scale*, not through formal proofs. For a spreadsheet engine, this is the more practical path. Formal methods (TLA+ for protocol, Lean for core semantics) complement but do not replace massive testing.
