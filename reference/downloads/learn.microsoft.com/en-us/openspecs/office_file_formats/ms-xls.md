---
layout: Conceptual
title: '[MS-XLS]: Excel Binary File Format (.xls) Structure | Microsoft Learn'
canonicalUrl: https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-xls/cd03cb5f-ca02-4934-a391-bb674cb8aa06
ms.service: openspecs-office
ROBOTS: INDEX, FOLLOW
uhfHeaderId: MSDocsHeader-OpenSpecs
ms.topic: reference
ms.author: cindyle
protocol_rendering: true
description: Specifies the Excel Binary File Format (.xls) Structure, which is the binary file format used by Microsoft Excel 97,
locale: en-us
author: mrsgit09
document_id: f08f00a1-47c8-2232-c086-12e046422262
document_version_independent_id: 6394a3c7-a4fe-a94f-3771-5b65864f5687
updated_at: 2025-08-19T14:56:00.0000000Z
original_content_git_url: https://github.com/MicrosoftDocs/open_specs_office/blob/live/documentation/office_file_formats/MS-XLS/cd03cb5f-ca02-4934-a391-bb674cb8aa06.md
gitcommit: https://github.com/MicrosoftDocs/open_specs_office/blob/fae71a88253877120348cc3c2519e953bddf787f/documentation/office_file_formats/MS-XLS/cd03cb5f-ca02-4934-a391-bb674cb8aa06.md
git_commit_id: fae71a88253877120348cc3c2519e953bddf787f
site_name: Docs
depot_name: MSDN.open_specs_office
page_type: conceptual
toc_rel: toc.json
feedback_system: None
feedback_product_url: ''
feedback_help_link_type: ''
feedback_help_link_url: ''
word_count: 978
asset_id: office_file_formats/ms-xls/cd03cb5f-ca02-4934-a391-bb674cb8aa06
moniker_range_name: 
monikers: []
item_type: Content
source_path: documentation/office_file_formats/MS-XLS/cd03cb5f-ca02-4934-a391-bb674cb8aa06.md
cmProducts:
- https://authoring-docs-microsoft.poolparty.biz/devrel/60932d05-feee-4685-a73b-595e25dd9318
spProducts:
- https://authoring-docs-microsoft.poolparty.biz/devrel/c43bb58b-1190-419b-8d18-e6052371b599
platformId: 70872d53-c5a2-b65f-04d0-b7a977fbd35f
---

# [MS-XLS]: Excel Binary File Format (.xls) Structure | Microsoft Learn

Specifies the Excel Binary File Format (.xls) Structure, which is the binary file format used by Microsoft Excel 97, Microsoft Excel 2000, Microsoft Excel 2002, and Microsoft Office Excel 2003.

This page and associated content may be updated frequently. We recommend you subscribe to the [RSS feed](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d.rss) to receive update notifications.

## Published Version

| Date | Protocol Revision | Revision Class | Downloads |
| --- | --- | --- | --- |
| 8/19/2025 | 12.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-250819.docx) |

[Click here to download a zip file of all PDF files for Office File Formats.](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/Zip_Files/OfficeFileFormatsProtocols.zip)

## Previous Versions

| Date | Protocol Revision | Revision Class | Downloads |
| --- | --- | --- | --- |
| 5/20/2025 | 12.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-250520.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-250520.docx) |
| 8/20/2024 | 12.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-240820.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-240820.docx) |
| 4/16/2024 | 11.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-240416.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-240416.docx) |
| 5/16/2023 | 10.7 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-230516.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-230516.docx) |
| 2/21/2023 | 10.6 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-230221.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-230221.docx) |
| 11/15/2022 | 10.5 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-221115.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-221115.docx) |
| 8/16/2022 | 10.4 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-220816.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-220816.docx) |
| 5/17/2022 | 10.3 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-220517.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-220517.docx) |
| 2/15/2022 | 10.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-220215.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-220215.docx) |
| 11/16/2021 | 10.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-211116.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-211116.docx) |
| 8/17/2021 | 10.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-210817.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-210817.docx) |
| 4/22/2021 | 9.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-210422.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-210422.docx) |
| 6/18/2019 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-190618.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-190618.docx) |
| 3/19/2019 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-190319.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-190319.docx) |
| 12/11/2018 | 8.0 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-181211.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-181211.docx) |
| 8/28/2018 | 8.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-180828.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-180828.docx) |
| 4/27/2018 | 7.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-180427.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-180427.docx) |
| 12/12/2017 | 6.1 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-171212.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-171212.docx) |
| 9/19/2017 | 6.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-170919.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-170919.docx) |
| 6/20/2017 | 6.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-170620.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-170620.docx) |
| 10/17/2016 | 5.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-161017.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-161017.docx) |
| 9/14/2016 | 4.2 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-160914.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-160914.docx) |
| 8/23/2016 | 4.2 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-160823.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-160823.docx) |
| 7/15/2016 | 4.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-160715.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-160715.docx) |
| 9/4/2015 | 4.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-150904.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-150904.docx) |
| 3/16/2015 | 4.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-150316.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-150316.docx) |
| 10/30/2014 | 3.2 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-141030.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-141030.doc) |
| 7/31/2014 | 3.1 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-140731.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-140731.doc) |
| 4/30/2014 | 3.0 | Major | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-140430.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-140430.doc) |
| 2/10/2014 | 2.8 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-140210.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-140210.doc) |
| 11/18/2013 | 2.8 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-131118.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-131118.doc) |
| 7/30/2013 | 2.8 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-130730.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-130730.doc) |
| 2/11/2013 | 2.7 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-130211.pdf) | [DOCX](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-130211.doc) |
| 10/8/2012 | 2.7 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-121008.pdf) |
| 7/16/2012 | 2.6 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-120716.pdf) |
| 4/11/2012 | 2.6 | None | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-120411.pdf) |
| 1/20/2012 | 2.6 | Minor | [PDF](https://officeprotocoldocs-f5hpbjgea6b8gneq.b02.azurefd.net/files/MS-XLS/%5bMS-XLS%5d-120120.pdf) |
| 6/10/2011 | 2.05 | None |  |
| 3/18/2011 | 2.05 | None |  |
| 12/17/2010 | 2.05 | None |  |
| 11/15/2010 | 2.05 | None |  |
| 9/27/2010 | 2.05 | Minor |  |
| 7/23/2010 | 2.04 | None |  |
| 6/29/2010 | 2.04 | Editorial |  |
| 6/7/2010 | 2.03 | Minor |  |
| 4/30/2010 | 2.02 | Editorial |  |
| 3/31/2010 | 2.01 | Editorial |  |
| 2/19/2010 | 2.0 | Major |  |
| 11/6/2009 | 1.06 | Editorial |  |
| 8/28/2009 | 1.05 | Editorial |  |
| 7/13/2009 | 1.04 | Major |  |
| 1/16/2009 | 1.03 | Minor |  |
| 10/6/2008 | 1.02 | Minor |  |
| 8/15/2008 | 1.01 | Minor |  |
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