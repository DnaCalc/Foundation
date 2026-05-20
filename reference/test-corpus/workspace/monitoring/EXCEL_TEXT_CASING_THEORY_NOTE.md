# Excel Text Casing Theory Note

## Purpose

Capture the current family-level theory for Excel worksheet text casing after the `FTC-0667` investigation, so later cases like Turkish `i` or Greek sigma are not treated as surprises.

This is a Foundation coordinator note. It synthesizes:
- retained local support/help references,
- local spec mirrors and processed Microsoft spec text already present in Foundation,
- OxXlPlay empirical probes,
- OxFunc repo-local witness matrices,
- and DnaOneCalc host rerun outcomes.

## Scope

Functions of interest:
- `UPPER`
- `LOWER`
- `PROPER`

Question:
- What rule family is Excel worksheet text casing following?
- Is it full Unicode special casing, locale-sensitive casing, a simpler one-codepoint model, or a legacy/VBA/NLS-like rule family?

## Working conclusion (short)

Current best working conclusion:
- Excel worksheet text casing is **not** full Unicode special casing.
- It also does **not** appear to use Turkish-locale-sensitive dotted-I behavior in the tested worksheet path.
- It appears closer to a **simple, mostly non-locale-sensitive casing model**, with at least some script-aware handling such as Greek final sigma.
- Therefore a one-off `ß` fix is useful but **not** a sufficient end-state theory.

Implementation posture implied by that conclusion:
- treat current `OxFunc` casing as transitional,
- prefer a shared Excel-style casing layer over raw platform/library casing calls,
- and do not broaden semantics beyond observed evidence without adding probes and witnesses.

## Evidence Sources

### A. Excel Support / help-page evidence

Live support/help pages were fetched directly during this pass:
- `UPPER function - Microsoft Support`
  - URL: `https://support.microsoft.com/en-us/office/upper-function-c11f29b3-d1a3-4537-8df6-04d0049963d6`
  - visible description found: `Converts text to uppercase.`
- `LOWER function - Microsoft Support`
  - URL: `https://support.microsoft.com/en-us/office/lower-function-3f21df02-a80c-44b2-afaf-81358f9fdeb4`
  - visible description found: `Converts all uppercase letters in a text string to lowercase.`
- `PROPER function - Microsoft Support`
  - URL: `https://support.microsoft.com/en-us/office/proper-function-52a5a283-e8b2-49be-8506-b2887b889f94`
  - visible description found: `Capitalizes the first letter in a text string and any other letters in text that follow any character other than a letter. Converts all other letters to lowercase letters.`

Retained help-index mirrors already in Foundation also record the same generic descriptions:
> research/runs/20260228-130325-excel-compat-spec-index-pass-01/outputs/
- `function_catalog_full.csv`

Relevant entries:
- `LOWER` → `Converts text to lowercase`
- `UPPER` → `Converts text to uppercase`
- `PROPER` → `Capitalizes the first letter in each word of a text value`

And the mirrored raw source pages carry the same summaries:
> research/runs/20260228-130325-excel-compat-spec-index-pass-01/inputs/raw/
- `source_1.html`
- `source_2.html`

Important limitation:
- these worksheet help pages are generic product/help descriptions;
- they do **not** specify Unicode expansion rules,
- they do **not** specify locale-sensitive Turkish-I behavior,
- and they do **not** explain what Excel does for `ß`, `ẞ`, sigma-final, or decomposed characters.

### B. Local Microsoft spec mirror evidence (VBA / adjacent Microsoft string stack)

Foundation already contains processed Microsoft VBA spec text that is relevant as adjacent evidence, even though it is not itself a worksheet-function specification.

Key retained passages from the processed MS-VBAL mirror:
> reference/runs/20260301-ms-vbal-pass05/outputs/docs/discovered-ms-vbal-1f6d62a5/segments.jsonl

Relevant passages:
- `LCase` runtime semantics:
  - `Returns a String that has been converted to lowercase.`
  - `Only uppercase letters are converted to lowercase; all lowercase letters and non-letter characters remain unchanged.`
- `UCase` runtime semantics:
  - `Returns a String that has been converted to uppercase.`
  - `Only lowercase letters are converted to uppercase; all uppercase letters and non-letter characters remain unchanged.`
- `StrConv` declaration includes an explicit `LocaleID` parameter.
- `VbStrConv` constants include:
  - `vbUpperCase`
  - `vbLowerCase`
  - `vbProperCase`

Interpretation:
- Microsoft’s adjacent VBA string-function/spec language is phrased in a very simple letter-conversion style.
- It suggests a legacy/simple conversion mindset rather than modern full-Unicode special casing semantics.
- `StrConv` exposes an explicit locale parameter, which is notable because worksheet `UPPER`/`LOWER`/`PROPER` help pages do **not** expose an analogous locale parameter.

This does **not** prove worksheet functions equal VBA functions, but it is useful evidence that Microsoft’s broader string-conversion ecosystem has a simpler/older semantic flavor unless locale is made explicit.

### C. OxXlPlay empirical Excel probe matrix

Empirical Excel probe was run in `OxXlPlay` against a broader matrix, not just `FTC-0667`.

Host context reported by the probe summary:
- Excel version: `16.0`
- Build: `19822`
- Host OS: `Microsoft Windows 11 Pro x64`
- Timezone: `South Africa Standard Time`
- `use_system_separators = true`
- decimal separator `.`
- thousands separator `NBSP`

Retained artifact paths reported by OxXlPlay:
- first widened pass summary: `OxXlPlay/.tmp/ftc-0667-casing-probe/results.json`
- first widened pass per-case bundles: `OxXlPlay/.tmp/ftc-0667-casing-probe/<case-id>/output/`
- boundary pass summary: `OxXlPlay/.tmp/ftc-0667-casing-boundary-probe/results.json`
- boundary pass per-case bundles: `OxXlPlay/.tmp/ftc-0667-casing-boundary-probe/<case-id>/output/`

Observed Excel results:
- `UPPER("straße")` → `STRAßE`
- `LOWER("STRAẞE")` → `straẞe`
- `PROPER("straße")` → `Straße`
- `UPPER("weiß")` → `WEIß`
- `UPPER("İstanbul")` → `İSTANBUL`
- `LOWER("İSTANBUL")` → `istanbul`
- `UPPER("istanbul")` → `ISTANBUL`
- `LOWER("I")` → `i`
- `LOWER("İ")` → `i`
- `UPPER("κόσμος")` → `ΚΟΣΜΟΣ`
- `LOWER("ΟΣ")` → `ος`
- `UPPER("café")` → `CAFÉ`

Important observations from the Excel matrix:
1. Excel does **not** uppercase `ß` to `SS`.
2. Excel does **not** lowercase `ẞ` to `ß` in the tested worksheet function path.
3. Excel does **not** show Turkish locale-sensitive dotted-I behavior:
   - `LOWER("İ")` became `i`, not `i` + combining dot above.
   - `UPPER("istanbul")` became `ISTANBUL`, not `İSTANBUL`.
4. Excel **does** show at least some script-aware behavior for Greek lowercasing:
   - `LOWER("ΟΣ")` → `ος`, which indicates final sigma handling.
5. Excel preserves ordinary accented Latin uppercase conversion:
   - `UPPER("café")` → `CAFÉ`.

### D. OxFunc local witness matrix

Relevant OxFunc commits reported during this pass:
- `458f1f8` — `Preserve sharp s in UPPER`
- `cda10fc` — `Add unicode casing matrix witnesses`
- `f95bf91` — `Document current unicode casing theory note`
- `4ec5230` — `Add shared worksheet text casing layer`
- `e592c3b` — `Expand worksheet casing boundary witnesses`

OxFunc repo-local matrix after the witness additions:
- `UPPER("straße")` → `STRAßE`
- `LOWER("STRAẞE")` → `straße`
- `PROPER("straße")` → `Straße`
- `UPPER("weiß")` → `WEIß`
- `PROPER("weiß")` → `Weiß`
- `UPPER("İstanbul")` → `İSTANBUL`
- `LOWER("İSTANBUL")` → `i̇stanbul` (`i` + combining dot above)
- `PROPER("İstanbul")` → `İstanbul`
- `UPPER("istanbul")` → `ISTANBUL`
- `LOWER("I")` → `i`
- `LOWER("İ")` → `i̇`
- `UPPER("κόσμος")` → `ΚΌΣΜΟΣ`
- `LOWER("ΚΌΣΜΟΣ")` → `κόσμος`
- `PROPER("κόσμος")` → `Κόσμος`
- `UPPER("café")` → `CAFÉ`
- `PROPER("café")` → `Café`
- `UPPER("Ångström")` → `ÅNGSTRÖM`
- `PROPER("Ångström")` → `Ångström`

### E. DnaOneCalc host rerun for FTC-0667

After the OxFunc fix landed, DnaOneCalc reran `FTC-0667` on the normal host path.

Retained artifact path reported by DnaOneCalc:
- `DnaOneCalc/target/triage/ftc-0667-after-458f1f86/cases/FTC-0667`

Reported result:
- final status: `Matched`
- OxFml/OxFunc-side value: `STRAßE`
- Excel-side value: `STRAßE`
- replay equivalent: `true`

This confirms the single-case fix worked, but does **not** close the broader family theory.

## Synthesis

### What the generic help pages do and do not tell us

The Excel support/help pages for `UPPER`, `LOWER`, and `PROPER` are too generic to explain the observed behavior.

They say things like:
- `Converts text to uppercase`
- `Converts all uppercase letters in a text string to lowercase`
- `Capitalizes the first letter ... and converts all other letters to lowercase`

But they do **not** tell us:
- whether Unicode special casing is used,
- whether one-to-many expansions are allowed,
- whether locale-sensitive rules are in effect,
- whether the behavior is pinned to a locale or code page,
- or how Greek sigma and Turkish dotted-I are handled.

### What the empirical results rule out

The current Excel probe matrix strongly rules out **full Unicode special casing** for worksheet `UPPER`/`LOWER`/`PROPER`.

Specifically, full-Unicode-style expectations would have made at least some of these different:
- `ß` uppercasing behavior,
- `ẞ` lowercasing behavior,
- Turkish dotted-I lowercasing,
- Turkish `i` uppercasing under locale-sensitive rules.

### What the empirical results support

The evidence supports this working theory:
- Excel worksheet text casing is closer to a **simple non-locale-sensitive casing model**
- with **selected script-aware handling**, notably Greek final sigma
- and **without** the full set of Unicode special-casing expansions
- and **without** Turkish locale-sensitive dotted-I behavior in the tested worksheet path.

A good shorthand is:
- **not full Unicode special casing**
- **not Turkish-locale-aware worksheet casing**
- **closer to simple casing with some hand-coded/script-aware exceptions**

## Expanded empirical matrix and current local alignment

After the first theory pass, `OxXlPlay` widened the Excel matrix further and `OxFunc` responded with a shared worksheet text-casing layer.

Additional Excel observations from the widened probe:
- `LOWER("straße")` → `straße`
- `LOWER("WEIẞ")` → `weiẞ`
- `LOWER("WEIß")` → `weiß`
- `UPPER("ẞ")` → `ẞ`
- `LOWER("ß")` → `ß`
- `PROPER("weiß")` → `Weiß`
- `UPPER("ı")` → `I`
- `LOWER("ı")` → `ı`
- `UPPER("i")` → `I`
- `UPPER("İ")` → `İ`
- `LOWER("Istanbul")` → `istanbul`
- `LOWER("İstanbul")` → `istanbul`
- `PROPER("İSTANBUL")` → `Istanbul`
- `LOWER("ΟΣΟΣ")` → `οσος`
- `LOWER("ΣΟΣ")` → `σος`
- decomposed accent control: `UPPER("café")` → `CAFÉ` with decomposition preserved
- Latin precomposed single-codepoint pairs also behave simply in the observed host path:
  - `UPPER("æther")` → `ÆTHER`
  - `LOWER("ÆTHER")` → `æther`
  - `UPPER("œuvre")` → `ŒUVRE`
  - `LOWER("ŒUVRE")` → `œuvre`
- Dutch-like digraph/titlecase boundary:
  - `UPPER("ijssel")` → `IJSSEL`
  - `PROPER("ijssel")` → `Ijssel`
- Greek accent/diaeresis boundary:
  - `UPPER("μαΐου")` → `ΜΑΪΟΥ`
  - `LOWER("ΜΑΪΟΥ")` → `μαϊου`
  - `UPPER("αϊ")` → `ΑΪ`
  - `LOWER("ΑΪ")` → `αϊ`
- compatibility / expansion-prone boundary:
  - `UPPER("ﬀoo")` → `ﬀOO`
  - `LOWER("ﬀOO")` → `ﬀoo`
  - `UPPER("ǆuro")` → `ǄURO`
  - `LOWER("ǄURO")` → `ǆuro`
  - `PROPER("ǆURO")` → `Ǆuro`

Current state after `OxFunc` commit `4ec5230`:
- the supplied Excel-observed matrix now matches locally for the probed family rows,
- the implementation moved from a one-off `ß` carve-out toward a shared worksheet text-casing layer used by `UPPER`, `LOWER`, and `PROPER`,
- but the family is still not considered globally closed because wider Unicode/version/locale surfaces remain under-evidenced.

This means the earlier `ß` fix was a useful seam repair, but the more important step was moving to a shared policy layer once the widened matrix made the rule family concrete enough.

## Current best theory statement

Current best theory:

> Excel worksheet `UPPER`, `LOWER`, and `PROPER` do not appear to use full Unicode special casing. They behave more like a simple, largely non-locale-sensitive casing system with selected script-aware rules (for example Greek final sigma and some Greek accent handling), preserving many ordinary single-codepoint case pairs while avoiding Unicode-style expansion, normalization, and locale-sensitive Turkish-I rules in the observed worksheet path.

More operationally:
- ordinary single-codepoint Latin accent case changes appear to work,
- ordinary single-codepoint extended Latin pairs such as `æ/Æ` and `œ/Œ` also behave simply in the observed host path,
- one-to-many Unicode-style expansions are not supported in the observed worksheet path,
- decomposition is preserved rather than normalized,
- Turkish dotted/dotless-I behavior does not appear locale-sensitive in the observed worksheet path,
- `PROPER` behaves closer to `uppercase first cased unit + lowercase rest` than full Unicode titlecasing,
- some script-aware Greek behavior exists,
- and the exact boundary of those script-aware rules is still provisional.

## Implementation implication

Current OxFunc state is now on a better path:
- `458f1f8` should still be viewed as the original **stopgap seam fix**.
- `4ec5230` is the first principled family-level step because it introduces a shared worksheet text-casing layer rather than leaving `UPPER` / `LOWER` / `PROPER` split across raw library calls and ad hoc overrides.
- `e592c3b` widened provisional boundary witnesses without changing semantics again, which is the right discipline for the newly probed Unicode frontier.

Current ownership recommendation:
- default ownership belongs in `OxFunc`.
- reason: the observed behavior is worksheet text-function semantics, not merely host rendering or adapter formatting.
- host/context should remain a possible future seam only if later evidence shows profile-, build-, or locale-governed variation that cannot be expressed as ordinary function semantics.

Execution recommendation from the boundary pass:
1. keep worksheet text casing centralized behind the shared `OxFunc` layer,
2. do not broaden semantics again until new Excel observations show a real mismatch on the current seam,
3. treat newly widened OxFunc boundary rows as provisional witnesses unless they are backed by retained Excel observations,
4. make the next empirical widening about host/build/locale variation rather than immediately adding more local special cases.

Guardrails for future fixes:
- do not accept a single-case green result as proof of the family rule,
- do not import full Unicode special casing unless Excel evidence justifies it,
- do not assume worksheet casing inherits VBA/`StrConv` locale behavior just because the adjacent stack suggests it,
- do not move this out of `OxFunc` without evidence of a real host/context split,
- do not normalize decomposed input unless Excel evidence requires it,
- do not add multi-codepoint expansion behavior unless Excel evidence requires it,
- and do not merge broader casing changes unless the witness matrix is updated at the same time.

## Next probe expansion

To avoid future surprises, the next expansion should include:
- dotless `ı` explicitly,
- more sigma-final contexts,
- precomposed vs decomposed Unicode forms,
- additional accented Latin cases,
- any ligature/expansion-prone cases that Excel might simplify,
- and explicit cross-checking of whether observed behavior changes under different host locale settings.

Minimum matrix expectation for any future casing change:
- at least one German `ß` / `ẞ` case,
- at least one Turkish `I` / `İ` / `ı` case,
- at least one Greek sigma-final case,
- at least one accented Latin control,
- and one `PROPER` case to ensure the family stays aligned across all three functions.

## Coordinator conclusion

`FTC-0667` is green, but the family is not “solved.”

The durable conclusion is:
- we now have enough evidence to say Excel diverges from standard full-Unicode casing,
- and enough evidence to know this is a **family semantics problem**, not a one-case exception.

Future casing work should use this note as the baseline, so Turkish `i`, Greek sigma, and related Unicode edge cases are expected investigation targets rather than surprises.
