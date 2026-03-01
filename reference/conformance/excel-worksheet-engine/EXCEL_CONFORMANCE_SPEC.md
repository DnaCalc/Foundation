# Excel Worksheet-Engine Conformance Specification

## 1. Purpose
This is the authoritative working conformance specification for the in-scope Excel worksheet-engine compatibility surface.

It is intended to drive:
1. implementation requirements,
2. conformance test planning/execution,
3. evidence-based compatibility decisions.

## 2. Scope
In scope:
1. Formula language semantics.
2. Built-in worksheet function set and interesting-function classification.
3. Sheet-visible value types/coercion behavior.
4. ListObject/Table semantics.
5. Cell formatting and conditional formatting behavior.
6. Version/platform caveats and release-channel awareness.

Out of scope (unchanged):
1. Power Query/M and DAX formula languages.
2. MDX internals (while CUBE worksheet functions remain in scope).

## 3. Normative Artifacts
1. Requirement corpus: `CONFORMANCE_REQUIREMENTS.csv`.
2. Source registry bridge: `SOURCE_BINDINGS.csv`.
3. Open/provisional lane register: `KNOWN_GAPS_AND_UNCERTAINTIES.md`.
4. Empirical registry: `../../empirical/findings_registry.jsonl`.
5. Prior authoritative source registry: `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/source_list.csv`.

## 4. Evidence Lineage Model
1. `ECS-*`: source ids from prior authoritative Excel source registry.
2. `REFX-*`: mirrored Open Spec entries under `reference/index.*`.
3. `EMP-*`: curated empirical findings promoted from empirical run artifacts.

Each requirement row must cite one or more evidence ids from this model.

## 5. Conformance Status Semantics
1. `normative`: requirement is required for conformance implementation/test gates.
2. `provisional`: requirement captures unresolved or conflicting evidence and must remain explicit; it is not a sole-release gate without waiver.

## 6. Function Set Baseline
1. Built-in worksheet function baseline count: `500` (from prior run catalog).
2. Tiered interesting-function model retained:
   - Tier 5 count: `5`
   - Tier 4 count: `43`
   - Tier 3 count: `23`
3. Full inventory and classification are referenced (not duplicated) from:
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_catalog_full.csv`
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_interest_index.csv`
   - `../../../research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/function_tier_summary.csv`

## 7. Source-of-Truth Rule for Implementation
Implementation and test decisions shall be derived from `CONFORMANCE_REQUIREMENTS.csv`, with evidence resolved through `SOURCE_BINDINGS.csv`.

When conflict exists between spec-derived and empirical-derived evidence:
1. keep both references explicit,
2. mark requirement `provisional` where needed,
3. record follow-up in `KNOWN_GAPS_AND_UNCERTAINTIES.md`.

## 8. Immediate Next-Step Usage
1. Bind current implementation tasks to requirement ids (`XLS-CF-*`).
2. Bind empirical probe/test outputs to the same requirement ids.
3. Promote additional high-value empirical findings to `EMP-*` ids before adding new provisional rows.
