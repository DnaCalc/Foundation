# FTC-0443 Excel shadowing alignment plan

## Case
- `FTC-0443`
- Formula:
  - `=LET(gcd,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),gcd(gcd,48,36))`

## Current status
- Initial normal `DnaOneCalc` corpus-path rerun:
  - `Blocked`
  - retained artifact: `target/triage/ftc-0443-normal-batch-output/cases/FTC-0443`
- Post-alignment normal `DnaOneCalc` corpus-path rerun:
  - `Matched`
  - retained artifact: `target/triage/ftc-0443-after-e6167cf/cases/FTC-0443`
- Current observed lane behavior after alignment:
  - `OxFml` local / host-side evaluation for exact case: `Error · #VALUE!`
  - Excel observation: `#VALUE!`

## Reclassification
This case should no longer be treated primarily as a recursive-LAMBDA support mismatch.

The stronger current diagnosis is:
- Excel supports recursive self-application of `LAMBDA`
- the mismatch frontier is built-in-name shadowing / callable resolution around `gcd` / `GCD`

## Evidence

### 1. DnaOneCalc normal corpus-path rerun
> target/triage/ftc-0443-normal-batch-output/cases/FTC-0443
- `comparison_status = Blocked`
- `oxfml-runtime-summary.json`
  - `evaluation_summary = "Number · 12"`
  - `comparison_value = {"kind":"number","number":12.0}`
- `excel-observation-summary.json`
  - `comparison_value = {"code":"Value","kind":"error"}`
  - `observed_formula_repr = "=LET(gcd,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),GCD(gcd,48,36))"`

### 2. OxXlPlay focused frontier probe
Minimal Excel probe matrix:
- exact case:
  - `=LET(gcd,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),gcd(gcd,48,36))`
  - Excel captured `#VALUE!`
- non-built-in binder variant:
  - `=LET(zzgcd,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),zzgcd(zzgcd,48,36))`
  - Excel captured value `12`
- uppercase built-in-colliding variant:
  - `=LET(GCD,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),GCD(GCD,48,36))`
  - Excel captured `#VALUE!`
- minimal recursion baseline:
  - `=LET(f,LAMBDA(self,n,IF(n=0,0,1+self(self,n-1))),f(f,3))`
  - Excel captured value `3`

Interpretation from the probe:
- recursion itself is supported
- case does not rescue `gcd` / `GCD`
- built-in-name collision is the likely frontier

### 3. Public documentation support
- Microsoft Support `LAMBDA` documentation:
  - `https://support.microsoft.com/en-us/office/lambda-function-bd212d27-1cd1-4321-a34a-ccbf254b8b67`
  - relevant public statement: if a `LAMBDA` calls itself and the call is circular, Excel can return `#NUM!` if there are too many recursive calls
  - this is public evidence that recursive `LAMBDA` is a supported Excel concept
- Microsoft Support `LET` documentation:
  - `https://support.microsoft.com/en-us/office/let-function-34842dd8-b92b-4d3f-b325-b8b8f9908999`
  - relevant public statement: LET names must be valid names and must start with a letter
  - no explicit public statement was found in this pass about built-in-function-name shadowing precedence, so empirical probe evidence remains decisive there

## Owning seam
- **Primary owner:** `OxFml`

Reason:
- the mismatch was not about low-level arithmetic or recursive evaluation capability
- it was a formula-language bind / callable-resolution rule in the presence of a LET-bound name that collides with a built-in function name
- `OxFunc` local evidence remained consistent with function semantics working once a callable was actually invoked
- the successful alignment landed in `OxFml` commit `e6167cf`

## Alignment goal
Bring `OxFml` into line with Excel for the callable-resolution frontier shown by `FTC-0443`:
- recursive self-application remains allowed in general
- but a LET-bound callable name that collides with a built-in function name must behave the way Excel behaves in callable position

## Landed alignment
`OxFml` commit `e6167cf` — `Align built-in colliding LET callable names`

What changed:
1. Added a bind/call-resolution rule so a helper-local LET name that case-insensitively collides with a built-in function resolves as the built-in in callable position.
2. Added durable local witnesses for:
   - exact `gcd` case => `#VALUE!`
   - non-built-in `zzgcd` case => `12`
   - generic recursive baseline => `3`
3. Host-path rerun confirmed corpus alignment:
   - `FTC-0443` moved from `Blocked` to `Matched`
   - `OxFml` side now emits `Error · #VALUE!`
   - Excel side remains `#VALUE!`
   - `replay_equivalent = true`

## Post-alignment retained evidence
> target/triage/ftc-0443-after-e6167cf/cases/FTC-0443
- `comparison_status = Matched`
- `oxfml-runtime-summary.json`
  - `evaluation_summary = "Error · #VALUE!"`
  - `comparison_value = {"code":"Value","kind":"error"}`
- `excel-observation-summary.json`
  - `comparison_value = {"code":"Value","kind":"error"}`
  - `observed_formula_repr = "=LET(gcd,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),GCD(gcd,48,36))"`

## Non-goals
- Do not revert to the older “recursion policy mismatch” framing
- Do not patch `OxFunc` numeric/runtime semantics unless new evidence shifts the frontier again
- Do not treat this as an `OxReplay` comparison-policy issue

## Coordinator assessment
This case is now resolved. The evidence supported a targeted `OxFml` bind/call-resolution alignment task rather than a broad recursion-semantics debate, and the post-alignment host rerun confirmed Excel parity for the exact corpus formula.
