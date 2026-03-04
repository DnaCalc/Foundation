# XLL SDK Registration and Types Reference (Working Digest)

## Purpose
Provide an implementation-facing digest of the Excel XLL SDK/C API material needed for function-definition work, especially:
1. registration model,
2. data type model (`pxTypeText`, `XLOPER/XLOPER12`, references),
3. caller/context and callback constraints.

This is a curated working reference, not a replacement for Microsoft source docs.

## Provenance
- Source family: Microsoft Learn, Excel C API / XLL SDK documentation.
- Accessed: 2026-03-02.
- Primary target docs are listed in Section 10.

## 1. Registration Model (`xlfRegister`, Form 1)
`xlfRegister` (Form 1) is the core registration call for exposing XLL functions/commands to Excel.

Key points:
1. Registration returns a register ID (`xltypeNum`) used for later invocation/unregistration paths.
2. Re-registering increments use count.
3. Registration also creates a hidden name that evaluates to register ID; cleanup typically includes `xlfSetName` on unregister flow.
4. `pxMacroType` controls command/function mode (worksheet/macro-sheet/command behavior surface).
5. `pxFunctionText` controls user-visible registered name and Function Wizard presence.
6. `pxCategory` controls Function Wizard grouping.

Related helpers:
1. `xlfRegisterId` can fetch existing ID or register-and-return if missing.
2. `xlfUnregister` (Form 1) decrements/unregisters by register ID.
3. `xlfEvaluate` can resolve register ID from registered name (when applicable).

## 2. Type Text (`pxTypeText`) Semantics
`pxTypeText` encodes return type, argument types, and several registration flags.

Core rules:
1. First character encodes return type.
2. Remaining characters encode argument types.
3. Additional suffix markers encode behavior flags (for example volatility/thread-safety).

Important behavior markers from `xlfRegister` docs:
1. `!`: mark worksheet function volatile.
2. `#`: register worksheet function as macro-sheet equivalent (expanded permissions, including handling of uncalculated cells and Class-2 info functions).
3. `$`: register as thread-safe (worksheet functions only; not combinable with macro-sheet equivalent in that form).
4. `&`: register as cluster-safe (worksheet functions only; cluster offload).

## 3. Data Type Codes (Working Subset)
The detailed tables are in Microsoft docs. Core practical subset for current planning:

1. Scalars:
   - `A/L` boolean,
   - `B/E` double,
   - `I/M` 16-bit int,
   - `J/N` 32-bit int.
2. Strings:
   - ANSI string forms (`C/D/F/G` forms),
   - Unicode forms in newer API (`C%/D%/F%/G%`).
3. Arrays:
   - `O` / `O%` argument-array forms,
   - `K` / `K%` `FP`/`FP12`.
4. Variant worksheet values:
   - `P`/`Q` (`XLOPER`/`XLOPER12` style value/array containers),
   - `R`/`U` value/array/reference-capable forms.
5. Async (newer API):
   - `X` async-handle marker in registration string.

## 4. Value and Reference Containers
For XLL integration, plan around:
1. `XLOPER` and `XLOPER12` multi-type containers,
2. reference-bearing forms (`xltypeRef`, `xltypeSRef`) and range semantics,
3. conversion and memory-management implications for dynamic strings/arrays/references.

Current function-definition implication:
1. Distinguish argument/reference normalization before function implementation logic.
2. Keep explicit whether function sees dereferenced value, reference object, or mixed depending on signature/registration.

## 5. Caller Context (`xlfCaller`)
`xlfCaller` is central for context-sensitive behavior:
1. It can return register ID, cell reference(s), menu/toolbar/object context, or error depending on invocation source.
2. In worksheet/UDF contexts it is the primary route for "who called me" semantics.
3. Return object may require explicit `xlFree` memory cleanup depending on returned type.

## 6. Invocation Surfaces
Once registered, XLL functions can be invoked from multiple Excel surfaces (worksheet formulas, names, certain dialogs/contexts, VBA `Application.Run`, etc.) with caveats.

Function-definition implication:
1. Host interaction and caller-context classes must not assume only direct worksheet invocation.

## 7. Callback Constraints and Threading
Excel C API callbacks (`Excel4/Excel12` families) are only valid when control is inside Excel-called XLL execution contexts.

Practical constraints:
1. Not valid from `DllMain`/OS loader events.
2. Not valid from arbitrary background threads (except specific async return path semantics where documented).
3. Thread-safe registration has explicit restrictions on thread-unsafe callbacks.

## 8. Memory Management Hooks
Relevant mechanisms:
1. `xlFree` for Excel-allocated callback results.
2. `xlAutoFree` / `xlAutoFree12` for add-in allocated return-memory cleanup patterns.

Function-definition implication:
1. Return adaptation and ownership model must be explicit in UDF surface contracts.

## 9. Open Items to Pull Into Function-Definition Work
1. Exact registration-signature policy rows for non-interesting function implementation campaign.
2. Explicit reference-argument classes (local/internal vs external/process-scope) in conformance schema.
3. Caller-context-dependent behavior policy (including conditional-format and VBA-call contexts).
4. Precision pass on thread-safe/cluster-safe constraints and prohibited callbacks by class.

## 10. Primary Sources
1. `xlfRegister (Form 1)`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/xlfregister-form-1
2. `Data types used by Excel`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/data-types-used-by-excel
3. `Accessing XLL code in Excel`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/accessing-xll-code-in-excel
4. `xlfRegisterId`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/xlfregisterid
5. `xlfUnregister (Form 1)`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/xlfunregister-form-1
6. `xlfCaller`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/xlfcaller
7. `xlUDF`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/xludf
8. `Calling into Excel from the DLL or XLL`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/calling-into-excel-from-the-dll-or-xll
9. `xlAutoRegister/xlAutoRegister12`  
   https://learn.microsoft.com/en-us/office/client-developer/excel/xlautoregister-xlautoregister12
10. `xlAutoFree/xlAutoFree12`  
    https://learn.microsoft.com/en-us/office/client-developer/excel/xlautofree-xlautofree12
