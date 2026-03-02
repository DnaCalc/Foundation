# Targeted Pass-2c Lanes Report

Target scenarios:
- FMLP2-008, FMLP2-009, FMLP2-019, FMLP2-020, FMLP2-021, FMLP2-022

## Outcome summary
- FMLP2-008: observed=accepted, display="#FIELD!", linked_data_op=allowed_error, support_wb_op=
- FMLP2-009: observed=accepted, display="#FIELD!", linked_data_op=allowed_error, support_wb_op=
- FMLP2-019: observed=accepted, display="4", linked_data_op=, support_wb_op=
- FMLP2-020: observed=accepted, display="1", linked_data_op=, support_wb_op=
- FMLP2-021: observed=accepted, display="77", linked_data_op=, support_wb_op=ok
- FMLP2-022: observed=accepted, display="#REF!", linked_data_op=, support_wb_op=

## Notes
1. Linked-data conversion attempts are captured via `linked_data_operation_status` and may remain `allowed_error` where environment/service support is unavailable.
2. External-reference present lane depends on support workbook open behavior (`open_support_workbook`).
3. Name-resolution lane compares `=MyName` and `=Sheet1!MyName` against explicit workbook/sheet-scoped setup.
