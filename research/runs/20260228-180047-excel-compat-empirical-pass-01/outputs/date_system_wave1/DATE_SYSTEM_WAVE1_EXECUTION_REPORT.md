# Date-System Wave 1 Execution Report

## Scope
Executed `ECS-EB-016` probes for NOW/TODAY under date-system toggles and cross-workbook copy/paste behavior.

## Execution status
- Scenarios executed: 5
- Success: 5
- Failure: 0

## Key outcomes
1. NOW/TODAY toggle scenarios showed serial/date-system effects with stable formula identity and expected observed transitions.
2. Cross-workbook copy of NOW/TODAY formulas remained formula-driven in destination workbook and reflected destination date-system changes.
3. Cross-workbook serial value copy preserved numeric serial while display text shifted across 1900/1904 date systems.

## Artifacts
- `now_today_date_system_probe.csv`
- `scenario_manifest_wave1.csv`
- `evidence/<scenario_id>/*`
