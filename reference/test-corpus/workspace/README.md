# Verification Workspace

Working directory for running formula verification batches against DnaOneCalc's `dnaonecalc-host verify-batch` command.

## Layout

- `prepare_batch.py` — converts corpus JSONL into the batch input JSON expected by `verify-batch`
- `batches/` — generated batch input files (gitignored)
- `results/` — verification output (gitignored)

## Quick Start

```bash
# Generate a small sample batch (first 20 formulas)
python prepare_batch.py --limit 20 -o batches/sample_20.json

# Generate a category-specific batch
python prepare_batch.py --category arithmetic_operators -o batches/arithmetic.json

# Generate the full corpus batch
python prepare_batch.py -o batches/full_corpus.json

# Run against dnaonecalc-host
cargo run -p dnaonecalc-host --manifest-path ../../DnaOneCalc/Cargo.toml -- \
  verify-batch --input batches/sample_20.json --output-root results/
```

## Options

| Flag | Description |
|---|---|
| `--limit N` | Take only the first N formulas |
| `--category CAT` | Filter to a specific category |
| `--tags TAG1,TAG2` | Filter to formulas containing any of these tags |
| `--deterministic-only` | Exclude non-deterministic formulas (RAND etc.) |
| `--excel` | Set `requires_excel_observation` and `excel_observation_available` to true |
| `--no-excel` | Set both to false (OxFml-only, default) |
| `-o PATH` | Output file path |
