# Internal Deep Research Run 3 - Asupersync Deep Dive

- Run ID: `20260222-084640-run3-asupersync-deep-dive-internal`
- Topic ID: `R-TOPIC-003`
- Method: repo-first deep analysis + workflow inspection + history mining
- Date (UTC): 2026-02-22
- Target use: reference standard extraction for DNA Calc planning only (no direct incorporation yet)

## 1) Executive View

Asupersync is not just a Rust runtime codebase. It is a full-stack engineering system with six tightly coupled layers:

1. Doctrine layer: strict operating rules in `AGENTS.md` and bead-linked governance.
2. Semantics layer: spec text in `asupersync_plan_v4.md` and `asupersync_v4_formal_semantics.md`.
3. Mechanization layer: Lean model and theorem surface in `formal/lean/Asupersync.lean` plus TLA model in `formal/tla/Asupersync.tla`.
4. Conformance layer: machine-readable coverage, traceability, and refinement artifacts in `formal/lean/coverage/` and `conformance/`.
5. Runtime/test layer: deterministic lab runtime, replay traces, property tests, conformance tests, and benchmark suites.
6. Gate layer: CI workflows enforcing methodology gates, proof artifacts, and regression checks.

Bottom line: the standout quality is not any single algorithm, but the enforced coupling between semantics, proofs, tests, and CI artifact contracts.

## 2) How It Was Developed (Evidence-Based)

### 2.1 Repository pace and ownership

- First commit date: `2026-01-16`
- Latest commit date analyzed: `2026-02-22`
- Total commits on `HEAD`: `2689`
- Authors in history:
  - `Dicklesworthstone`: 2686
  - `Jeff Emanuel`: 3
- Tags discovered: `v0.1.0`, `v0.1.1`, `v0.2.0`, `v0.2.2`, `v0.2.3`, `v0.2.4`, `v0.2.5`

### 2.2 Development pattern

Observed by commit messages and per-file history:

- Day 1 bootstrap (`2026-01-16`): design spec + core runtime + oracle/testing foundations landed immediately.
- Rapid expansion (`2026-01-17` to `2026-02-04`): heavy runtime feature growth and formal-spec maturation.
- Formalization ramp (`2026-02-03` to `2026-02-20`): Lean file growth, coverage artifacts, conformance linking, and methodology gates.
- Hardening/perf tail (`2026-02-21` to `2026-02-22`): frequent perf/fix commits, especially scheduler/network/runtime cleanup.

Selected history metrics:

- Commit peaks by day include `2026-02-03` (287), `2026-02-01` (203), `2026-02-14` (203), `2026-02-16` (191).
- Conventional commit prefixes are heavily used:
  - `feat(...)`: 498
  - `fix(...)`: 456
  - `refactor(...)`: 175
  - `perf(...)`: 84
  - `docs(...)`: 53
- Semantics docs commit frequency:
  - `asupersync_plan_v4.md`: 15 commits (`2026-01-16` to `2026-02-04`)
  - `asupersync_v4_formal_semantics.md`: 15 commits (`2026-01-16` to `2026-02-04`)
- Formal implementation evolution:
  - `formal/lean/Asupersync.lean`: 49 commits (`2026-02-03` to `2026-02-16`)
  - `formal/lean/coverage/`: 27 commits (`2026-02-11` to `2026-02-20`)

Inference: this was executed as an aggressive spec-first sprint where implementation and verification infrastructure evolved in near lockstep, with strong single-owner coherence.

## 3) Project Scale and Document Corpus

### 3.1 High-level size

- Total tracked files (clone snapshot): `993`
- Rust files: `825`
- Markdown files: `41`
- Workflows: `8` YAML files (`2559` total workflow lines)
- Shell scripts: `26` (`5067` total script lines)
- Test files under `tests/`: `239` Rust files (`102659` lines)
- Main `src/` files: `510` Rust files (`390638` lines)

### 3.2 Core docs/spec sizes

| Artifact | Bytes | Lines | Words (if md) | Why it matters |
|---|---:|---:|---:|---|
| `README.md` | 74439 | 889 | 8591 | Full project thesis + architecture + math foundations |
| `asupersync_plan_v4.md` | 49353 | 714 | 6681 | Design bible and invariants |
| `asupersync_v4_formal_semantics.md` | 52322 | 1282 | 6738 | Normative small-step semantics |
| `TESTING.md` | 37336 | 573 | 4300 | Deterministic artifact/test doctrine |
| `docs/integration.md` | 53946 | 1080 | 6169 | Integration-level behavior and expectations |
| `formal/lean/Asupersync.lean` | 193020 | 3835 | n/a | Mechanized semantics and theorem body |
| `formal/tla/Asupersync.tla` | 21564 | 435 | n/a | Bounded model-checking spec |
| `formal/lean/coverage/` (24 files total) | 317650 | n/a | n/a | Machine-readable proof coverage governance |

Important implication: the formal/spec/testing corpus is itself a substantial subsystem, not project decoration.

## 4) Formal Verification and Proof Stack

### 4.1 End-to-end chain

1. Normative semantics: `asupersync_v4_formal_semantics.md`
2. Lean mechanization: `formal/lean/Asupersync.lean`
3. TLA bounded model: `formal/tla/Asupersync.tla` + `formal/tla/Asupersync_MC.cfg`
4. Coverage ontology and proof governance: `formal/lean/coverage/*.json`
5. Conformance bridge for runtime/test linkage: `conformance/src/*`
6. CI proof jobs + proof artifact manifests: `.github/workflows/ci.yml`, `scripts/run_proof_checks.sh`

### 4.2 Current measured formal maturity (from machine-readable artifacts)

From `formal/lean/coverage/baseline_report_v1.json` and related files:

- Theorem surface inventory: `146` (`theorem_surface_inventory.json`)
- Step constructor coverage: `22/22 covered` (`step_constructor_coverage.json`)
- Canonical invariants tracked: `6`
  - `fully_proven`: 1
  - `partially_proven`: 3
  - `unproven`: 2

This is a strong signal: they track both completed and incomplete proof state explicitly, rather than claiming blanket formal completion.

### 4.3 TLA scope and limits

`formal/tla/Asupersync.tla` explicitly states bounded assumptions (finite sets, mask depth bound, simplified cancel reasons). This is a practical model-checking posture: bounded safety/liveness checks for critical invariants rather than an unbounded proof claim.

### 4.4 Conformance integration

`conformance/` and many `tests/lean_*` files indicate verification artifacts are validated as first-class CI inputs. The proof system is coupled to executable checks and schema validation.

## 5) Math-Heavy Components (Where the Heavy Math Actually Lands)

The math surface is unusually broad for a production-leaning runtime. Key examples:

- Severity lattice and algebraic outcome structure:
  - `asupersync_plan_v4.md` sections 3.1 and laws.
- Near-semiring / tropical budget composition:
  - `asupersync_plan_v4.md` sections 3.2/3.3
  - `README.md` algebra discussion.
- Mazurkiewicz trace equivalence and DPOR:
  - `asupersync_v4_formal_semantics.md` sections on trace equivalence and DPOR
  - `README.md` "Alien Artifact" sections.
- Geodesic schedule normalization and event-structure geometry:
  - `README.md` references + `src/trace/geodesic.rs` and related trace modules.
- Petri net / VASS framing for obligation accounting:
  - `asupersync_plan_v4.md` and formal semantics obligation accounting sections.
- Lyapunov-guided scheduler concepts:
  - `asupersync_plan_v4.md` scheduler section and corresponding test mentions in `TESTING.md`.
- Conformal calibration + e-process/anytime-valid monitoring:
  - `README.md` and lab/oracle module references.

Inference: this is a project deliberately blending formal methods, concurrency theory, and statistical validity methods into runtime operations and diagnostics.

## 6) Engineering Discipline and Tooling Stack Required

### 6.1 Build/runtime ecosystem

- Rust nightly toolchain (`rust-toolchain.toml` and workflow pinning)
- `cargo fmt`, `cargo clippy -D warnings`, `cargo check`, `cargo test`, `cargo bench`
- Optional/advanced features such as `loom-tests`, tracing, metrics, and protocol subsystems

### 6.2 Formal/proof tooling

- Lean 4 + Lake (`formal/lean/lakefile.lean`, `formal/README.md`)
- TLA+ TLC (Java + `tla2tools.jar`) via `scripts/run_model_check.sh`
- Proof orchestration via `scripts/run_proof_checks.sh`

### 6.3 Verification and test tooling

- Property testing: proptest in CI (`property-tests.yml`)
- Conformance suite + thresholds (`conformance.yml`)
- Golden-output and benchmark baselines (`methodology-gates.yml`, `docs/benchmarking.md`)
- Deterministic replay/event artifacts (`docs/replay-debugging.md`, `TESTING.md`)

### 6.4 Process tooling

- Bead-linked work tracking and traceability metadata (`.beads`, bead IDs across docs)
- Machine-readable proof-governance documents in `formal/lean/coverage/`
- CI artifact upload and enforcement for proof/perf gates

### 6.5 Operational pattern

Methodology gate discipline is explicit:

1. Baseline benchmark comparison.
2. Flamegraph gate on hot-path changes.
3. Golden checksum behavioral equivalence gate.
4. Proof-note gate for safety-critical changes.

This prevents the common failure mode where formal docs drift from implementation and performance changes.

## 7) If DNA Calc Targets This Standard: Execution Blueprint

This is the practical "how to execute" extraction.

### Phase A: Minimal spec-proof backbone (must exist first)

- One normative semantics document for kernel operations.
- One Lean (or equivalent) mechanization scaffold.
- One bounded model-check artifact (TLA/TLC or equivalent).
- One machine-readable coverage matrix (rules/invariants/proof status).

### Phase B: Deterministic runtime evidence layer

- Deterministic lab mode with seed and trace replay.
- Canonical failure artifact bundle contract.
- Golden behavior snapshots for major semantic surfaces.

### Phase C: CI gates as policy, not preference

- Proof check job with manifest output.
- Baseline benchmark regression gates.
- Behavioral golden checksum gates.
- Mandatory evidence notes for safety-critical changes.

### Phase D: Math-heavy experiments behind stable contracts

- Keep advanced math modules (e.g., schedule geometry, topology, probabilistic evidence) optional behind clear interfaces.
- Require each experiment to map to executable invariants and deterministic artifacts.

### Phase E: Governance and traceability

- Every invariant has:
  - spec anchor,
  - theorem/proof anchor,
  - executable test anchor,
  - CI gate anchor.
- Maintain machine-readable coverage ledgers to track deltas over time.

## 8) What to Copy vs What to Adapt

Copy directly:

- Spec -> formal -> conformance -> CI coupling pattern.
- Deterministic artifact contracts.
- Gate-driven performance and proof discipline.

Adapt carefully:

- Full algorithmic breadth (DPOR + topology + conformal + e-process + semiring stack) should be staged; do not import all complexity at once.
- Single-author velocity is hard to replicate; DNA Calc should design for multi-owner execution from the start.

## 9) Important Reading Order for This Topic

1. `asupersync_plan_v4.md`
2. `asupersync_v4_formal_semantics.md`
3. `formal/README.md`
4. `formal/lean/Asupersync.lean`
5. `formal/lean/coverage/baseline_report_v1.json`
6. `TESTING.md`
7. `.github/workflows/methodology-gates.yml`
8. `scripts/run_proof_checks.sh`
9. `scripts/run_model_check.sh`
10. `docs/replay-debugging.md`
11. `docs/benchmarking.md`

## 10) Key Conclusion for DNA Calc

If Asupersync is the quality bar, then the true target is not just "better code"; it is an integrated operations model where semantics, proofs, tests, performance, and governance are continuously reconciled by machine-checkable artifacts and CI gates.

That model is transferable. The exact algorithm mix is optional; the coupling discipline is the non-optional part.