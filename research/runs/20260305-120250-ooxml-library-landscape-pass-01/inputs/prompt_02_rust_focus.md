Rust-focused deep dive.

Questions:
1) Which Rust libraries provide meaningful Excel OOXML support today?
2) Which are write-only, read-only, or mixed?
3) How close are they to production-grade interop for .xlsx/.xlsm workflows?
4) What are realistic architecture patterns for DnaCalc:
   - pure Rust path
   - Rust + external adapter path
   - Rust + reference/oracle path
5) What capability gaps must be covered by custom implementation?

Output:
- Ranked Rust shortlist with rationale.
- Risk table for each candidate.
- Suggested proof-of-concept sequence.