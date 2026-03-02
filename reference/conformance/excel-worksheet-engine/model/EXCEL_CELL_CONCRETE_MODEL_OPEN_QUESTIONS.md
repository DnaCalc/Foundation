# Excel Cell Concrete Model Open Questions

This ledger tracks unresolved questions for the Excel-first concrete cell model.

## Status Tags
- `spec-gap`: public specifications are incomplete/ambiguous for the required detail.
- `empirical-gap`: behavior must be confirmed or expanded with empirical runs.
- `conflict`: available evidence conflicts and needs reconciliation.

## Open Questions

| question_id | area | related_model_ids | related_requirement_ids | status | evidence_now | evidence_needed | closure_criteria |
|---|---|---|---|---|---|---|---|
| ECM-Q-001 | Formula grammar edge cases (`@`, `#`, intersection spacing, nested structured refs, scoped-name qualification) | ECM-FML-001;ECM-FML-002;ECM-FML-003 | XLS-CF-FL-001;XLS-CF-FL-002;XLS-CF-FL-003;XLS-CF-FL-004;XLS-CF-FL-009 | empirical-gap | ECS-003;ECS-004;ECS-005;ECS-008;ECS-012;ECS-EB-033;ECS-EB-035;ECS-EB-036;ECS-EB-037;ECS-EB-038;ECS-EB-040 | Cross-build/channel replay of pass-2 grammar corpus plus explicit wording for scoped-name qualification semantics | Grammar and precedence table is stable across targeted builds/channels and scoped-name behavior is policy-fixed |
| ECM-Q-011 | Modern helper-form syntax coverage (`LET`/`LAMBDA`/helper family) vs formal grammar anchors | ECM-FML-004 | XLS-CF-FL-006 | empirical-gap | ECS-008;ECS-041;ECS-042;ECS-EB-034 | Formal/behavioral tag matrix plus cross-build replay for helper corpus | Rule table covers helper forms with clear source-class labeling and build-scoped stability |
| ECM-Q-002 | Aggregate coercion split (direct args vs range refs) | ECM-COE-002 | XLS-CF-TV-008 | conflict | EMP-0003 | Expanded empirical matrix across builds + explicit policy row | Requirement can move from provisional with stable rule |
| ECM-Q-003 | SUMIF mixed reason-code behavior | ECM-FUN-001 | XLS-CF-FN-009 | conflict | ECS-108;EMP-0009 | Broader SUMIF criteria/value-shape matrix | Provisional lane narrowed to explicit version-scoped rule |
| ECM-Q-004 | Dynamic-array mixed-type counter-signals | ECM-EVL-003;ECM-FUN-002 | XLS-CF-FN-011;XLS-CF-TV-009 | conflict | EMP-0010 | Additional probes and grouped rule matrix | Counter-signals reconciled or formally caveated |
| ECM-Q-005 | Spill-target conditional-format behavior | ECM-FMT-003 | XLS-CF-FM-005 | conflict | ECS-028;ECS-030;EMP-0004 | Additional empirical CF priority/spill-target cases | Explicit stable rule or bounded caveat accepted |
| ECM-Q-006 | Structured-reference spill-growth mismatch | ECM-TBL-003 | XLS-CF-TB-004 | conflict | ECS-012;EMP-0005 | Additional table growth + spill interaction probes | Provisional lane resolved or stable caveat published |
| ECM-Q-007 | Locale-sensitive parse/coercion edge behavior | ECM-INP-003;ECM-COE-003 | XLS-CF-TV-003;XLS-CF-TV-007 | empirical-gap | ECS-019 | Multi-locale empirical matrix with version metadata | Locale behavior represented as explicit model axis |
| ECM-Q-008 | Function availability by channel/platform | ECM-FUN-001 | XLS-CF-VP-002;XLS-CF-VP-003 | empirical-gap | ECS-035;ECS-036 | Machine-readable capability capture from empirical probes | Availability map retained with dated build anchors |
| ECM-Q-009 | Dot-field parse/eval behavior outside linked-data payloads | ECM-FML-004;ECM-TYP-002 | XLS-CF-FL-011;XLS-CF-TV-005 | conflict | ECS-024;ECS-025;EMP-0002;ECS-EB-032 | Linked-data fixture primitive in runner + split matrix (linked vs non-linked); current conversion attempts recorded as allowed-error in this environment | Provisional row replaced with explicit bounded rule |
| ECM-Q-010 | Parser acceptance of double-comma argument gaps | ECM-INP-001;ECM-FML-004 | XLS-CF-FL-010 | conflict | EMP-0001;ECS-EB-031 | Expanded parser probes across channels/builds | Behavior narrowed to deterministic compatibility policy |

## Operating Rule
Keep this ledger synchronized with:
1. `KNOWN_GAPS_AND_UNCERTAINTIES.md` (workspace-level open lanes),
2. `EXCEL_CELL_CONCRETE_MODEL_TRACE.jsonl` (statement-level evidence binding),
3. `EXCEL_FORMULA_LANGUAGE_CONFORMANCE_MATRIX.csv` and `EXCEL_FORMULA_LANGUAGE_PASS2_PROBE_PLAN.md` for `ECM-FML-*` closure tracking.
