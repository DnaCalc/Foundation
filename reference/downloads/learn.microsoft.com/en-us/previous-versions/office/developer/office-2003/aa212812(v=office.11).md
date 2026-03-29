---
layout: Conceptual
title: Overview of WordprocessingML [Word 2003 XML Reference] | Microsoft Docs
canonicalUrl: https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa212812(v=office.11)
locale: en-us
author: Archived
breadcrumb_path: /previous-versions/office/developer/office-2003/breadcrumb/toc.json
depot_name: MSDN.office-dev-office2003-archive-pr
document_id: a0a34185-f709-7fb6-1f5d-46188aeb4980
document_version_independent_id: fd33756a-9725-c6c5-af72-3134741be523
gitcommit: https://docs-archive.visualstudio.com/DefaultCollection/docs-archive-project/_git/office-dev-archive-pr/commit/382e62baf073771e5a9562e3f2e9b91ca6f6e47a?path=/office-dev-office2003-reference-archive/aa212812(v=office.11).md&_a=contents
is_archived: true
ms.author: Archived
ms.date: 2010-01-07T00:00:00.0000000Z
ms.prod: office-2003
ms.topic: archived
ms:assetid: office|wordxmlcdk|~\html\cdkprimerplaceholder_hv01113631.htm
ms:contentKeyID: 3928730
ms:mtpsurl: https://msdn.microsoft.com/en-us/library/Aa212812(v=office.11)
mtps_version: v=office.11
original_content_git_url: https://docs-archive.visualstudio.com/DefaultCollection/docs-archive-project/_git/office-dev-archive-pr?path=/office-dev-office2003-reference-archive/aa212812(v=office.11).md&version=GBlive&_a=contents
page_type: conceptual
ROBOTS: NOINDEX,NOFOLLOW
search.ms_docsetname: office-dev-office2003-archive-pr
search.ms_product: MSDN
search.ms_sitename: Docs
search.mshattr.devlang: xml
site_name: Docs
toc_rel: toc.json
TOCTitle: Overview of WordprocessingML [Word 2003 XML Reference]
uhfHeaderId: MSDocsHeader-Archive
updated_at: 2018-04-13T20:16:00.0000000Z
word_count: 419
asset_id: aa212812(v=office.11)
moniker_range_name: 
monikers: []
item_type: Content
platformId: 8a1e2125-e5c6-ecf9-2b7b-290566af541d
---

# Overview of WordprocessingML [Word 2003 XML Reference]

## Top-Level Elements, Namespace, Basic Document Structure

The top-level elements in a WordprocessingML document are:

- **[SmartTagType element](aa223695%28v=office.11%29)** describes a Smart Tag type used in the document.
- **[DocumentProperties element](aa223625%28v=office.11%29)** contains Office Document Properties.
- **[CustomDocumentProperties element](aa223620%28v=office.11%29)** contains Custom Office Document Properties.
- **[schemaLibrary element](aa212845%28v=office.11%29)** defines a collection of schemas that comprise a document's schema library.
- [**fonts element** (wordDocumentElt complexType)](aa213353%28v=office.11%29) contains font information
- [**frameset element** (wordDocumentElt complexType)](aa172695%28v=office.11%29) contains HTML Frameset definitions.
- [**styles element** (wordDocumentElt complexType)](aa196860%28v=office.11%29) contains style definitions.
- [**divs** element](aa196297%28v=office.11%29) contains HTML DIV information.
- [**shapeDefaults** element](aa196638%28v=office.11%29) contains drawing defaults.
- [**docOleData** element](aa196310%28v=office.11%29) contains supplemental data containing storages for OLE objects.
- [**docSuppData** element](aa196319%28v=office.11%29) contains supplemental data containing toolbar customizations, envelope data, and the Microsoft Visual Basic project.
- [**docPr** element](aa196312%28v=office.11%29) contains document options.
- [**shapeDefaults** element](aa196638%28v=office.11%29) contains the wrapper representing the shape defaults.
- [**bgPict** element](aa172405%28v=office.11%29) contains background picture information.
- [**body** element](aa172414%28v=office.11%29) contains the document body.

However, the simplest WordprocessingML document consists of just five elements (and a single namespace). The five elements are:

- [**wordDocument** element](aa174013%28v=office.11%29): The root element for a WordprocessingML document.
- [**body** element](aa172414%28v=office.11%29): The container for the displayable text.
- [**p** element](ee364458%28v=office.11%29): A paragraph.
- [**r** element](aa223687%28v=office.11%29): A contiguous set of WordprocessingML components with a consistent set of properties.
- [**t** element](aa175182%28v=office.11%29): A piece of text.

The namespace for the root WordprocessingML Schema (also known as the XML Document 2003 Schema) is "http://schemas.microsoft.com/office/word/2003/wordml". This namespace is normally associated with the WordprocessingML elements by using a prefix of "w." The simplest possible WordprocessingML document looks as follows:

```
<?xml version="1.0"?>
<w:wordDocument xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml">
    <w:body>
        <w:p>
            <w:r>
                <w:t>Hello, World.</w:t>
            </w:r>
        </w:p>
    </w:body>
</w:wordDocument>
```

The following figure shows the resulting document, displayed in Microsoft Office Word 2003.

![](images/aa212812.helloworld_za01141465(en-us,office.11).gif)

## Tying the Document to Microsoft Office Word 2003

If you save a Microsoft© Office Word 2003 document with the .xml extension, Windows treats the file like any other XML file. When the user double-clicks the file, for example, opens it in the standard XML processor (such as Microsoft Internet Explorer). However, adding the mso-application processing instruction specifies Word as the preferred application for processing the file. As a result, Word opens the XML document when the user double-clicks the document's icon. The following example shows the sample document with the mso-application element added:

```
<?xml version="1.0"?>
<?mso-application progid="Word.Document"?>
<w:wordDocument 
    xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml">
<w:body>
    <w:p>
        <w:r>
            <w:t>Hello, World.</w:t>
        </w:r>
    </w:p>
</w:body>

</w:wordDocument>
```

This topic is intended to serve as a brief introduction to WordprocessingML. For a complete overview, see "Overview of WordprocessingML" included in the [Office 2003 XML Reference Schemas](http://www.microsoft.com/downloads/details.aspx?familyid=fe118952-3547-420a-a412-00a2662442d9&amp;displaylang=en).

[©2004 Microsoft Corporation. All rights reserved.](https://msdn.microsoft.com/en-us/library/Aa214924) Permission to copy, display and distribute this document is available at: [http://msdn.microsoft.com/library/en-us/odcXMLRef/html/odcXMLRefLegalNotice.asp](http://r.office.microsoft.com/r/rlidawscontentredir?assetid=xt010988631033&amp;ctt=11&amp;origin=hv011232471033)