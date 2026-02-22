# Lean Module Plan + Theorem Backlog (DnaVisiCalc)

## Source-of-truth check
- Read and treated as authoritative: `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `notes/BRAINSTORM_NOTES.md`.
- Precedence applied: Charter > Architecture/Requirements > Operations > Brainstorm.

## Contradictions and resolution
- Hard contradictions found: none.
- Tension to resolve explicitly:
  - `ARCHITECTURE_AND_REQUIREMENTS.md` requires deterministic mode and also async/multithread scaffolding.
  - Resolution for Lean scope: prove deterministic sequential core semantics only; model concurrency in TLA+ and implementation packs, not in Lean.

## Assumptions (explicit)
- Lean covers Round-0 core calculus (expressions, refs/ranges, one structural rewrite) and not full Excel surface.
- UDF and STREAM are modeled as oracle calls with deterministic contracts in proof context.
- Numeric semantics use a compact, explicit subset suitable for pathfinder proofs.

## Module tree (filenames + responsibility)

```text
Lean/
  DnaVisiCalc/
    Core/
      Id.lean                 -- stable ids for sheets/cells/ranges (abstract but decidable)
      Value.lean              -- scalar values and runtime errors
      Ref.lean                -- cell refs, range refs, relative/absolute flags
      Range.lean              -- normalized rectangular ranges + membership helpers
      Expr.lean               -- expression AST (literals, refs, ops, function calls)
      Sheet.lean              -- sheet snapshot model and lookup primitives
      Oracle.lean             -- abstract UDF/STREAM oracle interfaces + laws
      Eval.lean               -- big-step evaluator over snapshot + oracle
      Dependency.lean         -- referenced-cells extraction for invalidation reasoning
    Rewrite/
      InsertRow.lean          -- structural edit spec: insert-row transformation
      RewriteExpr.lean        -- ref/range rewriting under row insertion
      RewriteSheet.lean       -- workbook/sheet rewrite + well-formedness preservation
    Proofs/
      EvalDeterminism.lean    -- determinism and totality-on-domain lemmas
      EvalMonotone.lean       -- sanity lemmas on unchanged cells/oracle invariants
      RewriteCorrectness.lean -- commuting theorem: rewrite-before/after-eval
      DependencySound.lean    -- deps extraction soundness (bounded/targeted)
    Alignment/
      BoundedGen.lean         -- bounded enumerators for snapshots/exprs/traces
      EmitJson.lean           -- JSON emission for alignment pack fixtures
      CheckpointSpec.lean     -- schema for expected checkpoints
    Main.lean                 -- exports used by packs/tooling
```

## Data types to define

### Values
- `Value`
  - `vNum` (pathfinder numeric type)
  - `vBool`
  - `vText`
  - `vBlank`
- `Error`
  - `eDiv0`, `eValue`, `eRef`, `eName`, `eNum`, `eNA`, `eNull`, `eNotImpl`
- `Result := Error ⊕ Value` (or equivalent sum type)

### References and ranges
- `Row`, `Col` as bounded naturals (proof-friendly)
- `CellRef`
  - `sheetId`, `row`, `col`, absolute flags for row/col
- `RangeRef`
  - `startRef`, `endRef` (normalized rectangle invariant)
- `RefTarget`
  - single cell or range

### Expressions
- `Expr`
  - literals (`Value`)
  - unary/binary ops
  - cell reference
  - range reference
  - conditional (`if`)
  - builtin call (`BuiltinFn`, list `Expr`)
  - `udfCall(name, args)`
  - `streamCall(topicExpr)`

### Snapshot model
- `SheetSnapshot`
  - dimensions/bounds
  - cell formula/value map
- `WorkbookSnapshot`
  - sheet map
  - profile info needed by evaluator

## Theorem backlog (realistically achievable)

## M0: Kernel theorems (must-have)
- `eval_deterministic`:
  - For fixed snapshot + oracle + expr, evaluation result is unique.
- `eval_ref_lookup_deterministic`:
  - Ref and range lookup produce unique targets/results.
- `eval_error_propagation_stable`:
  - For supported ops, error propagation is deterministic and rule-complete.
- `eval_preserves_blank_policy`:
  - Blank coercion policy is consistent with chosen profile subset.

## M1: Dependency and invalidation support
- `deps_sound_cell`:
  - If evaluating `e` reads cell `c`, then `c` is in `deps(e)`.
- `deps_sound_range`:
  - Any cell read through a range is included in dependency extraction.
- `deps_finite`:
  - Dependency set is finite under bounded snapshot assumptions.

## M2: Structural rewrite (one disruptive edit)
- Target edit: `InsertRow(sheet, r)`.
- `rewrite_ref_insert_row_correct`:
  - Ref rewrite matches row-shift spec for all affected refs.
- `rewrite_range_insert_row_correct`:
  - Range rewrite preserves intended included cells under insertion semantics.
- `rewrite_expr_insert_row_total`:
  - Rewrite is total for supported AST forms.
- `rewrite_sheet_wf_preserved`:
  - Snapshot invariants remain valid after insert-row rewrite.
- `eval_rewrite_commutes_insert_row`:
  - Evaluating rewritten expression on rewritten snapshot equals original-eval projected under edit semantics.

## M3: Alignment theorems for oracle pack
- `bounded_gen_wf`:
  - Generated bounded instances satisfy well-formedness invariants.
- `emit_json_roundtrip_schema`:
  - Emitted checkpoints conform to schema (Lean-side guarantee).
- `alignment_sound_seeded`:
  - For fixed seeds/bounds, Lean fixtures are reproducible.

## Strategy to keep proofs small
- Parameterize external effects:
  - Model UDF and STREAM through an `Oracle` interface with minimal laws:
    - determinism for fixed `(epoch, name/topic, args)`
    - declared domain/codomain validity
- Keep Lean in sequential core scope:
  - No scheduler or concurrency reasoning in Lean; delegate those to TLA+ packs.
- Use bounded naturals and normalized ranges:
  - Avoid heavy arithmetic side obligations.
- Prove by compositional lemmas:
  - One lemma per AST constructor, then fold into global theorem.
- Freeze a tiny builtin set for Round 0:
  - Arithmetic, comparison, `IF`, and one aggregate over normalized ranges.
- Separate executable extraction concerns:
  - Lean emits fixtures; OCaml executes independently; comparison happens in pack tooling.

## Tiny alignment-pack plan (Lean emits bounded instances, OCaml must match)

## Pack name
- `PACK.lean.ocaml.alignment.core`

## Flow
1. Lean `Alignment.BoundedGen` enumerates bounded workbooks + expressions + structural edit traces.
2. Lean `Alignment.EmitJson` writes fixtures:
   - `snapshot.json`
   - `trace.json`
   - `expected_checkpoints.json`
3. OCaml oracle CLI runs same fixtures and produces `actual_checkpoints.json`.
4. Pack comparator checks byte-stable canonical JSON equality.
5. Any mismatch is minimized by existing OCaml shrinker, then archived as regression case.

## Initial bounds (realistic)
- Sheets: `<= 2`
- Rows: `<= 4`
- Cols: `<= 4`
- Expr depth: `<= 3`
- Function arity: `<= 3`
- Structural traces: single `InsertRow` per case
- Seeded sample count per CI run: small fixed budget (fast deterministic gate)

## Artifacts
- `artifacts/lean-alignment/<profile>/<seed>/...`
- Conformance record appended to pack report for Green sign-off.

## Exact doc edits to lock this plan
- `ARCHITECTURE_AND_REQUIREMENTS.md`
  - Edit heading `## 6. Pathfinder Scope Anchor (DnaVisiCalc)`:
    - Add explicit line: Lean proves deterministic sequential core semantics and one structural edit (`InsertRow`) rewrite correctness.
- `OPERATIONS.md`
  - Edit heading `## 4.1 Packs`:
    - Add `PACK.lean.ocaml.alignment.core` with required artifacts and pass criteria.
- `OPERATIONS.md`
  - Edit heading `## 6. Tooling Interface Rules`:
    - Add canonical JSON schema requirement for Lean fixture emission and OCaml comparison.

## Smallest next actions (highest risk reduction)
1. Freeze Round-0 Lean AST + value/error types and publish as `Core` module contract.
2. Implement `eval_deterministic` before adding more builtins.
3. Lock `InsertRow` rewrite semantics and prove `rewrite_ref_insert_row_correct`.
4. Stand up `PACK.lean.ocaml.alignment.core` with very small bounds in CI.
5. Treat first mismatch as shrinker/regression pipeline test and keep the minimized case.
