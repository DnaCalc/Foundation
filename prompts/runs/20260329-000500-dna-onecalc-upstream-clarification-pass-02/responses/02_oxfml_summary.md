## Final Summary

### Files Changed
1. `docs/spec/OXFML_DNA_ONECALC_DOWNSTREAM_CONSUMER_CONTRACT.md` — new file, the single downstream-consumer clarification note for DNA OneCalc first integration
2. `docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md` — updated status rule and read-together list to point to the new contract doc; added a downstream consumer contract pointer section
3. `docs/spec/formula-language/OXFML_EDITOR_LANGUAGE_SERVICE_AND_HOST_INTEGRATION_PLAN.md` — added an integration-readiness classification for downstream hosts
4. `docs/spec/README.md` — added the new doc to the Bootstrap Set and canonical document groups

### Authoritative OxFml Doc Set DNA OneCalc Should Now Use
1. `docs/spec/OXFML_DNA_ONECALC_DOWNSTREAM_CONSUMER_CONTRACT.md`
2. `docs/spec/OXFML_HOST_RUNTIME_AND_EXTERNAL_REQUIREMENTS.md`
3. `docs/spec/OXFML_DNA_ONECALC_HOST_POLICY_BASELINE.md`
4. `docs/spec/OXFML_PUBLIC_API_AND_RUNTIME_SERVICE_SKETCH.md`
5. `docs/spec/formula-language/OXFML_EDITOR_LANGUAGE_SERVICE_AND_HOST_INTEGRATION_PLAN.md`
6. `docs/spec/OXFML_FIXTURE_HOST_AND_COORDINATOR_STANDIN_PACKET.md`

### Remaining Gaps
1. OxFunc still needs a frozen help/signature provider contract and stronger downstream integration baseline.
2. The OxCalc seam still needs a frozen immutable formula-edit packet, a frozen validated completion result packet, and clearer caller-anchor/address-mode carriage.
3. The OxFml/OxFunc `W052` registered-external seam still needs promotion into shared seam-freeze text.
4. No `Ox*`-owned stable `SpreadsheetML 2003` isolated-instance persistence contract exists yet.
