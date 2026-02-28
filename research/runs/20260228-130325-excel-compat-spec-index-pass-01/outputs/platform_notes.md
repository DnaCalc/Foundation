# Platform-Specific Notes (Union-First)

## Principle
Primary target is union behavior across platforms. Platform-specific differences are tracked as caveats, not as a primary taxonomy axis.

## Observed from selected function-page probes
- RTD:
  - Function page applies-to list includes desktop, Mac, and web variants.
  - Practical behavior is COM/automation-oriented in many enterprise setups; cross-platform parity should be treated as a testable unknown.
- CUBESET / CUBEVALUE:
  - Applies-to list includes desktop, Mac, web, and mobile variants.
  - Effective behavior depends on cube/data-model connectivity and connector capabilities; treat connector stack as the key variability axis.
- LAMBDA:
  - Applies-to list is narrower than legacy functions (focused on newer product lines).
- GROUPBY / PIVOTBY:
  - Applies-to signals indicate newer Microsoft 365/Excel 2024 era behavior.
  - Availability should be tracked by channel/build over time.

## Artifact
- `outputs/platform_probe_selected_functions.csv`

## Tracking rule
Whenever a platform-specific claim is added to compatibility requirements, link it to:
1. exact function page applies-to evidence,
2. date captured,
3. a reproducible behavior probe for confirmation.