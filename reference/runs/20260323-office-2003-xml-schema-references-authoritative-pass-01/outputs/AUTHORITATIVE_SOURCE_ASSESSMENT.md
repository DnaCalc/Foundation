# Office 2003 XML Schema References Authoritative Source Assessment

Captured: `2026-03-23`

## Question

What is the best current authoritative Microsoft source for the historical package titled `Office 2003: XML Reference Schemas` / `Microsoft Office 2003 Edition XML Schema References`?

## Conclusion

The original combined Microsoft Download Center package is no longer available from current Microsoft endpoints. As of `2026-03-23`, the strongest surviving authoritative source is a **reconstructed official Microsoft source set** composed of:

1. the Microsoft Learn Open Specification Promise page that still explicitly names `Office 2003 XML Reference Schemas`,
2. archived Microsoft Learn Office 2003 pages that describe XML support across Office 2003 and directly reference the original download family,
3. archived Microsoft Learn Word 2003 XML SDK/reference pages that preserve the WordprocessingML reference corpus and still point back to the original package.

This run ingests that surviving Microsoft-authored source set and processes it into normalized reference artifacts.

## Why This Is The Right Authority Decision

### What does not survive cleanly

- The old Download Center page `https://www.microsoft.com/en-us/download/details.aspx?id=101` now returns `404`.
- The historical family identifier `fe118952-3547-420a-a412-00a2662442d9` is still visible in surviving Microsoft-authored material, but the original current-download surface is no longer functioning as an active official distribution point.
- A direct `download.microsoft.com` candidate for `Office2003XMLSchema.exe` was also checked during this pass and returned `404`.

So the original package identity survives, but the original downloadable package endpoint does not.

### What does survive officially

The following official Microsoft Learn pages survive and together establish the identity, scope, and surviving reference corpus of the package:

- `OFFICE2003-XML-OSP`
  - `MS-DEVCENTLP` still lists `Office 2003 XML Reference Schemas` under the Open Specification Promise.
- `OFFICE2003-XML-DESKTOP`
  - `Microsoft Office System and XML: Bringing XML to the Desktop` preserves the Office 2003 XML architecture context across Word, Excel, and InfoPath.
- `OFFICE2003-WORD-EXCEL-SCHEMAS`
  - `Using Schemas with Word 2003 and Excel 2003` preserves Microsoft-authored operational documentation for attaching and using schemas in both products.
- `WORD2003-XML-SDK-WELCOME`
  - `Welcome to the Microsoft Office Word 2003 XML Software Development Kit (SDK)` preserves the Word 2003 XML reference root and links to the Word SDK corpus.
- `WORD2003-WORDPROCESSINGML-OVERVIEW`
  - `Overview of WordprocessingML` explicitly says the complete overview is included in `Office 2003 XML Reference Schemas` and links to the historical download family.

This is the best currently retrievable official chain because it preserves both:

- the package identity and legal/program context, and
- the most detailed surviving schema-reference material on Microsoft-hosted properties.

## Scope Reconstructed From Official Sources

The surviving official Microsoft material identifies the original package as covering at least:

- `WordprocessingML` for Word 2003,
- `SpreadsheetML` for Excel 2003,
- `FormTemplate XML` / InfoPath 2003 schemas,
- additional Office 2003 schema material beyond Word and Excel.

That breadth is stated in surviving Microsoft-authored material outside this markdown-native subset as well, especially the Microsoft Source announcement from `2003-11-17`, which describes the Office 2003 XML Reference Schemas as including WordprocessingML, SpreadsheetML, and FormTemplate XML schemas.

## Ingested Official Sources In This Run

- `https://learn.microsoft.com/en-us/openspecs/dev_center/ms-devcentlp/1c24c7c8-28b0-4ce1-a47d-95fe1ff504bc`
- `https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa159914(v=office.11)`
- `https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa159902(v=office.11)`
- `https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa214923(v=office.11)`
- `https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa212812(v=office.11)`

## External Official Corroboration Used In The Assessment

These official Microsoft pages were consulted during source-finding, but were not added to the markdown-native subset index for this run:

- Microsoft Source announcement:
  - `https://news.microsoft.com/2003/11/17/microsoft-announces-availability-of-open-and-royalty-free-license-for-office-2003-xml-reference-schemas/`
- Microsoft Support article:
  - `https://support.microsoft.com/en-us/topic/how-to-extract-information-from-office-files-by-using-office-file-formats-and-schemas-5f5fafdd-2f22-8b71-4348-57484b5a9fc5`

These pages corroborate package scope and the historical family identifier, but the Microsoft Learn pages above were preferred as the ingest baseline because they are stable, markdown-fetchable, and directly processable by the Foundation reference pipeline.

## Resulting Library Position

This run should be treated as the current Foundation answer to:

`authoritative surviving Microsoft source for Office 2003 XML Reference Schemas`

It is not a claim that the original packaged EXE is presently retrievable from Microsoft. It is a claim that the ingested Microsoft Learn source set is the best current authoritative surviving source family.
