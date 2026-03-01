---
layout: Conceptual
title: '[MS-XLSB]: Excel (.xlsb) Binary File Format | Microsoft Learn'
canonicalUrl: https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-xlsb/acc8aa92-1f02-4167-99f5-84f9f676b95a
ms.service: openspecs-office
ROBOTS: INDEX, FOLLOW
uhfHeaderId: MSDocsHeader-OpenSpecs
ms.topic: reference
ms.author: cindyle
protocol_rendering: true
description: Specifies the Excel (.xlsb) Binary File Format, which is a collection of records and structures that specify Excel workbook
locale: en-us
author: mrsgit09
document_id: 70bba702-e5d6-56fc-9272-1ffbf09060d5
document_version_independent_id: db532ca2-72c5-12a9-0ad8-20b931e1cf7e
updated_at: 2025-11-13T16:51:00.0000000Z
original_content_git_url: https://github.com/MicrosoftDocs/open_specs_office/blob/live/documentation/office_file_formats/MS-XLSB/acc8aa92-1f02-4167-99f5-84f9f676b95a.md
gitcommit: https://github.com/MicrosoftDocs/open_specs_office/blob/0a0723bc6d67bf18507ec34f5eaf44ce345c1551/documentation/office_file_formats/MS-XLSB/acc8aa92-1f02-4167-99f5-84f9f676b95a.md
git_commit_id: 0a0723bc6d67bf18507ec34f5eaf44ce345c1551
site_name: Docs
depot_name: MSDN.open_specs_office
page_type: conceptual
toc_rel: toc.json
feedback_system: None
feedback_product_url: ''
feedback_help_link_type: ''
feedback_help_link_url: ''
word_count: 1033
asset_id: office_file_formats/ms-xlsb/acc8aa92-1f02-4167-99f5-84f9f676b95a
moniker_range_name: 
monikers: []
item_type: Content
source_path: documentation/office_file_formats/MS-XLSB/acc8aa92-1f02-4167-99f5-84f9f676b95a.md
cmProducts:
- https://authoring-docs-microsoft.poolparty.biz/devrel/60932d05-feee-4685-a73b-595e25dd9318
spProducts:
- https://authoring-docs-microsoft.poolparty.biz/devrel/c43bb58b-1190-419b-8d18-e6052371b599
platformId: 70a48186-d6e8-4734-16ff-64cc88038e96
---

# [MS-XLSB]: Excel (.xlsb) Binary File Format | Microsoft Learn

Specifies the Excel (.xlsb) Binary File Format, which is a collection of records and structures that specify Excel workbook content. The content can include unstructured or semi-structured tables of numbers, text, or both numbers and text, formulas, external data connections, charts and images.

This page and associated content may be updated frequently. We recommend you subscribe to the [RSS feed](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d.rss) to receive update notifications.

## Published Version

| Date | Protocol Revision | Revision Class | Downloads |
| --- | --- | --- | --- |
| 11/13/2025 | 21.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-251113.docx) |

[Click here to download a zip file of all PDF files for Office File Formats.](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/Zip_Files/OfficeFileFormatsProtocols.zip)

## Previous Versions

| Date | Protocol Revision | Revision Class | Downloads |
| --- | --- | --- | --- |
| 9/16/2025 | 21.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250916.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250916.docx) |
| 8/19/2025 | 20.1 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250819.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250819.docx) |
| 5/20/2025 | 20.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250520.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250520.docx) |
| 4/4/2025 | 20.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250404.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250404.docx) |
| 2/18/2025 | 19.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250218.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-250218.docx) |
| 8/20/2024 | 18.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240820.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240820.docx) |
| 5/21/2024 | 17.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240521.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240521.docx) |
| 4/16/2024 | 17.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240416.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240416.docx) |
| 2/20/2024 | 16.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240220.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-240220.docx) |
| 5/17/2022 | 15.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-220517.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-220517.docx) |
| 2/15/2022 | 15.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-220215.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-220215.docx) |
| 11/16/2021 | 15.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-211116.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-211116.docx) |
| 8/17/2021 | 15.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-210817.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-210817.docx) |
| 4/22/2021 | 14.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-210422.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-210422.docx) |
| 2/16/2021 | 13.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-210216.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-210216.docx) |
| 8/18/2020 | 13.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-200818.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-200818.docx) |
| 2/19/2020 | 12.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-200219.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-200219.docx) |
| 9/24/2019 | 12.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-190924.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-190924.docx) |
| 3/19/2019 | 12.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-190319.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-190319.docx) |
| 1/11/2019 | 12.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-190111.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-190111.docx) |
| 12/11/2018 | 11.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-181211.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-181211.docx) |
| 8/28/2018 | 11.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-180828.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-180828.docx) |
| 4/27/2018 | 10.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-180427.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-180427.docx) |
| 12/12/2017 | 9.3 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-171212.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-171212.docx) |
| 9/19/2017 | 9.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-170919.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-170919.docx) |
| 6/20/2017 | 9.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-170620.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-170620.docx) |
| 1/18/2017 | 9.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-170118.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-170118.docx) |
| 10/17/2016 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-161017.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-161017.docx) |
| 9/29/2016 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-160929.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-160929.docx) |
| 9/14/2016 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-160914.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-160914.docx) |
| 7/15/2016 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-160715.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-160715.docx) |
| 9/4/2015 | 8.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-150904.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-150904.docx) |
| 3/16/2015 | 7.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-150316.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-150316.docx) |
| 10/30/2014 | 6.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-141030.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-141030.doc) |
| 7/31/2014 | 6.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-140731.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-140731.doc) |
| 4/30/2014 | 5.3 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-140430.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-140430.doc) |
| 2/10/2014 | 5.2 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-140210.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-140210.doc) |
| 11/18/2013 | 5.2 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-131118.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-131118.doc) |
| 7/30/2013 | 5.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-130730.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-130730.doc) |
| 2/11/2013 | 5.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-130211.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-130211.doc) |
| 10/8/2012 | 5.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-121008.pdf) |
| 7/16/2012 | 4.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-120716.pdf) |
| 4/11/2012 | 3.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-120411.pdf) |
| 1/20/2012 | 3.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLSB/%5bMS-XLSB%5d-120120.pdf) |
| 6/10/2011 | 2.6 | None |  |
| 3/18/2011 | 2.6 | Minor |  |
| 12/17/2010 | 2.05 | None |  |
| 11/15/2010 | 2.05 | None |  |
| 9/27/2010 | 2.05 | Minor |  |
| 7/23/2010 | 2.04 | None |  |
| 6/29/2010 | 2.04 | Editorial |  |
| 6/7/2010 | 2.03 | Editorial |  |
| 4/30/2010 | 2.02 | Editorial |  |
| 3/31/2010 | 2.01 | Editorial |  |
| 2/19/2010 | 2.0 | Major |  |
| 11/6/2009 | 1.07 | Editorial |  |
| 8/28/2009 | 1.06 | Editorial |  |
| 7/13/2009 | 1.05 | Major |  |
| 1/16/2009 | 1.04 | Minor |  |
| 12/12/2008 | 1.03 | Minor |  |
| 10/6/2008 | 1.02 | Minor |  |
| 6/27/2008 | 1.0 | New |  |

## Preview Versions

From time to time, Microsoft may publish a preview, or pre-release, version of an Open Specifications technical document for community review and feedback. To submit feedback for a preview version of a technical document, please follow any instructions specified for that document. If no instructions are indicated for the document, please provide feedback by using the [Open Specification Forums](https://aka.ms/AA9oo6c).

The preview period for a technical document varies. Additionally, not every technical document will be published for preview.

A preview version of this document may be available on the [Office File Formats - Preview Documents](../ms-offfflp/8299af2a-b10d-4576-915f-79e9b7416869) page. After the preview period, the most current version of the document is available on this page.

## Development Resources

Find resources for creating interoperable solutions for Microsoft software, services, hardware, and non-Microsoft products: 

[Plugfests and Events](https://msdn.microsoft.com/en-us/openspecifications/dn750988), [Test Tools](https://msdn.microsoft.com/en-us/openspecifications/dn750986), [Development Support](https://msdn.microsoft.com/en-us/openspecifications/cc816063), and [Open Specifications Dev Center](https://msdn.microsoft.com/en-us/openspecifications).

## Intellectual Property Rights Notice for Open Specifications Documentation

- **Technical Documentation. **Microsoft publishes Open Specifications documentation (“this documentation”) for protocols, file formats, data portability, computer languages, and standards support. Additionally, overview documents cover inter-protocol relationships and interactions.
- **Copyrights**. This documentation is covered by Microsoft copyrights. Regardless of any other terms that are contained in the terms of use for the Microsoft website that hosts this documentation, you can make copies of it in order to develop implementations of the technologies that are described in this documentation and can distribute portions of it in your implementations that use these technologies or in your documentation as necessary to properly document the implementation. You can also distribute in your implementation, with or without modification, any schemas, IDLs, or code samples that are included in the documentation. This permission also applies to any documents that are referenced in the Open Specifications documentation.
- **No Trade Secrets**. Microsoft does not claim any trade secret rights in this documentation.
- **Patents**. Microsoft has patents that might cover your implementations of the technologies described in the Open Specifications documentation. Neither this notice nor Microsoft's delivery of this documentation grants any licenses under those patents or any other Microsoft patents. However, a given Open Specifications document might be covered by the Microsoft [Open Specifications Promise](https://go.microsoft.com/fwlink/?LinkId=214445) or the [Microsoft Community Promise](https://go.microsoft.com/fwlink/?LinkId=214448). If you would prefer a written license, or if the technologies described in this documentation are not covered by the Open Specifications Promise or Community Promise, as applicable, patent licenses are available by contacting iplg@microsoft.com.
- **License Programs**. To see all of the protocols in scope under a specific license program and the associated patents, visit the [Patent Map](https://aka.ms/AA9ufj8).
- **Trademarks**. The names of companies and products contained in this documentation might be covered by trademarks or similar intellectual property rights. This notice does not grant any licenses under those rights. For a list of Microsoft trademarks, visit https://www.microsoft.com/trademarks.
- **Fictitious Names**. The example companies, organizations, products, domain names, email addresses, logos, people, places, and events that are depicted in this documentation are fictitious. No association with any real company, organization, product, domain name, email address, logo, person, place, or event is intended or should be inferred.

**Reservation of Rights**. All other rights are reserved, and this notice does not grant any rights other than as specifically described above, whether by implication, estoppel, or otherwise. 

**Tools**. The Open Specifications documentation does not require the use of Microsoft programming tools or programming environments in order for you to develop an implementation. If you have access to Microsoft programming tools and environments, you are free to take advantage of them. Certain Open Specifications documents are intended for use in conjunction with publicly available standards specifications and network programming art and, as such, assume that the reader either is familiar with the aforementioned material or has immediate access to it.

**Support.** For questions and support, please contact dochelp@microsoft.com.