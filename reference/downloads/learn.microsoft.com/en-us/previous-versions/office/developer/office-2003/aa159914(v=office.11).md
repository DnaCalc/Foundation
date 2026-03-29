---
layout: Conceptual
title: 'Microsoft Office System and XML: Bringing XML to the Desktop | Microsoft Docs'
canonicalUrl: https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa159914(v=office.11)
locale: en-us
author: Archived
breadcrumb_path: /previous-versions/office/developer/office-2003/breadcrumb/toc.json
depot_name: MSDN.office-dev-office2003-archive-pr
document_id: 4e14ff8c-59b3-ae5e-d8e6-e62ef3100896
document_version_independent_id: f9a4ee4d-ff15-41ca-b6f9-16b809260b3d
gitcommit: https://docs-archive.visualstudio.com/DefaultCollection/docs-archive-project/_git/office-dev-archive-pr/commit/382e62baf073771e5a9562e3f2e9b91ca6f6e47a?path=/office-dev-office2003-reference-archive/aa159914(v=office.11).md&_a=contents
is_archived: true
ms.author: Archived
ms.date: 2010-01-08T00:00:00.0000000Z
ms.prod: office-2003
ms.topic: archived
ms:assetid: office|dno2k3ta|~\html\odc_xmlinoffice2003_summarydoc.htm
ms:contentKeyID: 3886910
ms:mtpsurl: https://msdn.microsoft.com/en-us/library/Aa159914(v=office.11)
mtps_version: v=office.11
original_content_git_url: https://docs-archive.visualstudio.com/DefaultCollection/docs-archive-project/_git/office-dev-archive-pr?path=/office-dev-office2003-reference-archive/aa159914(v=office.11).md&version=GBlive&_a=contents
page_type: conceptual
ROBOTS: NOINDEX,NOFOLLOW
search.ms_docsetname: office-dev-office2003-archive-pr
search.ms_product: MSDN
search.ms_sitename: Docs
search.mshattr.devlang: vba xml
site_name: Docs
toc_rel: toc.json
TOCTitle: 'Microsoft Office System and XML: Bringing XML to the Desktop'
uhfHeaderId: MSDocsHeader-Archive
updated_at: 2018-04-13T20:16:00.0000000Z
word_count: 3281
asset_id: aa159914(v=office.11)
moniker_range_name: 
monikers: []
item_type: Content
platformId: 129c9c7b-afa0-dd87-97fc-0582eb8050df
---

# Microsoft Office System and XML: Bringing XML to the Desktop | Microsoft Docs

Peter Kelly 3Sharp, LLC

September 2003

Applies to: Microsoft® Office System

**Summary:** Discover how the Microsoft Office System brings XML to the desktop through support for custom schemas in Microsoft Office Word 2003 and Microsoft Office Excel 2003, to Microsoft Office FrontPage 2003 as an authoring environment for XML-based sites and XML as the native file format for Microsoft Office InfoPath 2003. Read an overview of XML and how you can use it to retrieve data from Office documents. (9 printed pages)

**Important** The information set out in this topic is presented exclusively for the benefit and use of individuals and organizations outside the United States and its territories or whose products were distributed by Microsoft before January 2010, when Microsoft removed an implementation of particular functionality related to custom XML from Word. This information may not be read or used by individuals or organizations in the United States or its territories whose products were licensed by Microsoft after January 10, 2010; those products will not behave the same as products licensed before that date or licenses for use outside the United States.

#### Contents

Key Concepts and Definitions Overview of XML in the Microsoft Office System How XML Can Make the Microsoft Office System Data More Valuable The Power of XML in Specific Office 2003 Applications Getting the Most from XML Support in the Microsoft Office System Conclusion References

## Key Concepts and Definitions

**XML** eXtensible Markup Language is a metadata definition language used to describe data in a structured open format.

**XML Schema** Valid XML files used to define the structure for other XML Files.

**XSLT** eXtensible Stylesheet Language Transformation files – Used to transform the format and/or content of existing XML files.

**XPath** An XML Query language used to easily extract elements and data from XML documents.

## Overview of XML in the Microsoft Office System

Support for eXtensible Markup Language (XML) in both Microsoft® Office Excel 2003 and Microsoft Office Access 2003 is dramatically expanded from what was first offered in the Microsoft Office XP editions. In addition, Microsoft has also added a rich level of XML support to Microsoft Office Word 2003. For example, Word 2003 and Excel 2003 both support mapping of multiple custom designed schemas to documents, allowing information workers to create and manipulate rich content that is, at the same time, defined by XML. Microsoft Office FrontPage® 2003 allows site designers to create XML data driven sites and to build rich views on XML data using a What You See Is What You Get (WYSIWYG) tool.

Finally, Microsoft Office InfoPath™ 2003, the new information gathering program, uses XML as its native file format. With its support for customer-defined XML schemas and its built-in support for Web services, InfoPath can integrate with multiple line-of-business systems and it can operate within a company's business processes. 

By extensively supporting XML, the Microsoft Office System dramatically increases the value of the documents information workers produce. With the Microsoft Office System, spreadsheets, forms, databases, Web sites, and word processing documents are no longer end points for data; rather, they are part of the data management cycle, an integral piece of the infrastructure through which data flows. In fact, developers and power users can now design documents using the Microsoft Office System that can be used by information workers directly within the business logic and data flow of the organization.

For example, documents can be made to actively participate in enterprise applications. One way to accomplish this is through the use of Microsoft's smart tag and smart document technologies, both of which make it possible to associate an action with XML-defined content, such as updating a back-end system. While smart tags and smart documents are the subjects of another paper, they illustrate the powerful scenarios that are made possible when content is intelligently described by XML by using the Microsoft Office System.

## How XML Can Make the Microsoft Office System Data More Valuable

The use of XML in the Microsoft Office System can make content that information workers create more valuable. By decoupling the data contained within documents from other aspects of the document (layout, which application created it, and so on), the use of XML in the Microsoft Office System makes that data more available and accessible to developers and power users, more usable by organizations, and more capable of being integrated into existing business processes. For some great examples of powerful XML-based scenarios, see the following white paper: [The Microsoft Office System and XML: The Value of XML on the Desktop](http://go.microsoft.com/fwlink/?linkid=19813).

Traditionally, Office developers who wanted to retrieve data from Office documents have been forced to know and refer to the structure of the document. For example, a developer who created a solution that maps to a table in a Word document would have had to write code that locates the data in the context of the Word document's structure. If an information worker using the document added a table at the top of the document, they would render the data inaccessible to the developer's solution.

With XML, Office developers do not need to know WHERE in a document the data they desire to capture is located. They simply have to know WHAT is defined, or mapped, through an XML schema (XSD).

XML exposes the information in the document by describing it independently of any formatting information or data location. For example, the same data that before had to be located in some specific Excel cell or Word table can now be placed anywhere and simply contained by an XML element for **SalesData** (the element name is totally definable). Such data would look like:

```code
<SalesData>Data</SalesData>
```

Those familiar with HTML tagging will recognize this structure. The key here is that while HTML tagging describes how to render or display data, this XML tag describes the data itself. To retrieve the XML text "Data", which is contained by the SalesData tags, the developer simply uses the XPath query (which would look something like **selectSingleNode("/parents::SalesData**). Thus, regardless of where the information resides in the document, and regardless of how it is formatted, as long as it is tagged within the context of XML schema, it is accessible through XML.

## The Power of XML in Specific Office 2003 Applications

XML is a native file format for Microsoft Word 2003 and Excel 2002 and Excel 2003. Most information that can be saved in traditional .DOC or .XLS format, such as formatting information, author information, last modified date, etc, can all be saved in the form of XML elements. (Exceptions are noted in the following sections.) Figure 1 shows the XML view of a Word document:

![](images/aa159914.odc_xmlinoffice2003_summarydoc01(en-us,office.11).gif)

**Figure 1. A Word 2003 document**

Notice how, for example, the **Author** value (a standard Word property) is represented here as data defined by an XML tag:

```code
<o:Author>Nancy Buchanan</o:Author>
```

As a result, data can be easily detached from the document while maintaining all of the rich formatting and functionality that information workers are accustomed to within a traditional Microsoft Office document.

#### Word 2003

Microsoft Office Word 2003 supports industry-standard XML, and documents can be saved interchangeably between Word 2003 .DOC format and its native XML file format. Word 2003 supports customer-defined XSDs, and it has rich support for XSLT, allowing you to associate specific XSLTs with specific XSDs, for example.

Word 2003 provides a visual interface to facilitate mapping schemas to a document (see figure 2). Word 2003 has a Schema Library to which you can add multiple schemas. Once a schema within the Schema Library is attached to a document, power users or developers can graphically map schema elements from the XML structure task pane to the document itself.

Word 2003 is capable of understanding the strict requirements of a schema document and will launch validation errors when appropriate. For example, if an element specifies that its contents should be numeric, a validation error will result from entering text.

![](images/aa159914.odc_xmlinoffice2003_summarydoc02(en-us,office.11).gif)

**Figure 2. Word maps each field to an XML element**

In figure 2 above, the schema elements in the task pane at right are mapped to sections of the document. Now, the **Physician Name** field (middle left) is defined by the XML element "drname". Any other program or solution that uses this same schema will know how to find the doctor's name in this document.

In addition, using smart tags or smart documents, developers can attach logic to specific XML elements within the document. For example in the figure above, Contoso could build a solution to aid their salespeople when filling out the Receipt of Samples Form shown in the figure above. In such a solution, a custom-built DLL could retrieve the doctor's information from Contoso's internal records and automatically insert it into the proper fields based on the XML tags within the document.

#### Excel 2003

Power users or developers can attach a schema to an Excel 2003 document into which they can import XML data defined for those schemas. They can also open XML files directly and have Excel 2003 infer a schema from the structure of the document. In the .xls binary format, Excel documents can maintain XML mappings and retain all Excel features and properties. When saved as an .xml file, Excel documents maintain data structures and XML mappings (though they lose some of the rich, Excel-based features such as images, forms, embedded objects, and VBA code (see Help for a complete list)).

Within Excel 2003, elements can be mapped from the XML Structure task pane to cells within the spreadsheet. Developers and power users can map XML elements in any order to the spreadsheet and do not have to meet any requirements of the schema. Once the elements from the schema are mapped, the XML data can be imported and used just like any other data within the spreadsheet.

Once a spreadsheet has been mapped to XML, a number of powerful scenarios are possible. First, if you are mapping to dynamic data (through a Web query, Web service, a database query that exposes XML, or Access 2003, the usual Excel features (for example, Microsoft PivotChart® dynamic views) can now be used on up-to-date data. Excel 2003 allows an information worker to update the spreadsheet directly from the XML source data (through the same connection/authentication method that was set up originally) with one click.

Second, because data within Excel 2003 is now mapped, it is accessible to other systems. For example, an information worker that is accustomed to doing his company's financial reports in Excel can continue to use Excel, even if the final destination of that financial report data is, for example, a database. For more information, see the "Regulatory Compliance and Preparation of Financial Data" example in the following white paper: [The Microsoft Office System and XML: The Value of XML on the Desktop](http://go.microsoft.com/fwlink/?linkid=19813). In brief, though, the XML integration now makes it possible for the company's other systems to consume that data directly from the spreadsheet, regardless of whether cells have been moved.

#### InfoPath 2003

InfoPath 2003 streamlines the process of gathering information by enabling teams and organizations to easily create and work with rich, dynamic forms. InfoPath forms have some very compelling benefits, such as:

- Because they are electronic, InfoPath forms can be designed to dynamically adapt to a user's answers, making them more powerful and more usable
- Because data is collected electronically, the necessity for data reentry (as with paper forms) is eliminated
- InfoPath forms offer document-like features such as rich text editing and spell-checking

The power of InfoPath forms, though, extends way beyond usability. The XML support in InfoPath makes it possible to integrate the information collected in forms into a broad range of business processes (more on this below).

InfoPath was built from the ground up to work natively with XML and support customer-defined schemas that are based on the W3C XML Schema (XSD) standard. Simply put, InfoPath creates and edits XML documents. Designers and users experience the XML support in InfoPath in a variety of ways: as an XML authoring tool for designing forms; in the forms themselves, which are XML files; in the rich views of the forms, made possible by XSLT transformations; in support for Web services, which makes it easier to integrate with data sources and back-end systems.

InfoPath provides an easy-to-use WYSIWYG design mode that lets form designers create or modify form templates without writing any code. To design a new form, designers simply insert controls into a blank form. InfoPath automatically creates an XML schema in the background (which may be modified). Designers can also build a form from an existing schema (for example, an existing customer-defined schema that is part of a business process workflow design). InfoPath forms are always saved as XML files, and they contain a special Processing Instruction that identifies them as InfoPath files.

- Information workers interact with the InfoPath form through rich, formatted views. InfoPath provides validated, structured editing of XML data by showing the editing actions that are valid for the field or field group that is currently selected. This structured editing makes it possible to add and remove valid XML elements and attributes by working with groups of fields displayed in rich dynamic views, without seeing the elements and attributes.
- InfoPath solves a problem in the area of data gathering that could not be solved before the advent of XML: by providing forms that can grow by adding optional groups of fields and by using the hierarchical data model of XML, InfoPath adds the flexibility of word processor documents to the rigorous validation features of a forms application. Complex XSLT transformations are an integral part of this solution, providing dynamic, easy-to-use views of the XML data.

Because InfoPath supports customer-defined XML schemas and integrates with Web services, InfoPath forms can integrate with back-end and middle-tier systems. For example, a current business process might involve multiple front-end systems that have rigid interaction with their respective back-end, line-of-business applications.

With InfoPath, an organization could design a form that acts as the front-end to multiple back-end systems, simplifying the flow of information. Further, the organization could design a rich workflow around the form, using, for example, BizTalk Server to generate the business logic based on XML elements. Fundamentally, InfoPath helps to connect information workers directly to organizational information, giving them the ability to act on it, which leads to greater business impact. For some great examples of InfoPath forms-based business process solutions, see the "Field Service Execution and Management" and "Insurance Claims Processing" sections in the following white paper: [The Microsoft Office System and XML: The Value of XML on the Desktop](http://go.microsoft.com/fwlink/?linkid=19813).

#### FrontPage 2003

FrontPage 2003 supports XML in two key ways, both of which make it possible to connect a Web site with information in new ways. First, site designers will be able to create live Web sites–-Web sites in which users can interact with the data – using data from SharePoint lists or from other XML data sources. Other XML data sources can be XML files, XML-formatted query results from a line-of-business application, or a third-party service, to name a few.

Second, and related to the ability to create live connections to XML data sources, is the powerful ability to create and edit eXtensible Stylesheet Language Transformation (XSLT) files for viewing XML data. With FrontPage 2003, site designers get a WYSIWYG tool for creating data transforms. This feature supports Microsoft Word or XML files and Uniform Resource Locators (URLs) that return XML. FrontPage 2003 has all the tools necessary to handle and format XML data sources. Plus, site designers can save results from HTML forms in an XML file in a Web site, and build views of that XML data file. For an example of an FrontPage 2003 solution, see the "Marketing and Brand Reports" section in the following white paper: [The Microsoft Office System and XML: The Value of XML on the Desktop](http://go.microsoft.com/fwlink/?linkid=19813).

#### Access 2003

XML support in Access 2003 enables a wide range of notable capabilities, including the ability to:

- \*\*Export related tables \*\*Because Access databases are inherently relational, report data usually reside in multiple tables. For example, a list of sales orders may include data from tables containing the product list, order details, and other related information. Exporting the data thus requires exporting the related tables. Access 2003 can export data as XML and automatically include all the related details. Anyone who views the XML reports has access to all the data, from all related tables.
- \*\*Import or export the published XSD namespace \*\*In Access 2002, references to the older namespace prevented developers from validating XML schemas. Because developers can now validate Access 2003 XML schemas, those using Microsoft Visual Studio® .NET to build an application can utilize XML data exported from Access 2003 and integrate that data into larger business processes.
- **Apply an XSLT on export and import** Information workers can specify an XSL transform to be used when exporting and importing XML. This means workers can export a form with data to XML, and submit the data using a particular schema.
- \*\*Export presentation XSLs \*\*Information workers who are exporting Access data to XML can also choose to export a presentation XSL file. Access 2003 offers the option to export the XSL data. Access 2003 also generates a schema that matches the data being exported.

These capabilities enable advanced users and developers to make Access 2003 data more usable and more integrated with business processes.

## Getting the Most from XML Support in the Microsoft Office System

Because XML is extensible, you must do some up-front work to make support of XML in the Microsoft Office System work in your organization. For example, you must define the XML elements that data in documents will map to, and you must define the logic that uses that data. However, in the context of what can be gained, the up-front effort is well worth it. The sections below describe some of the general considerations for using XML and the Microsoft Office System within your environment.

#### Dependencies

In order to map XML elements to Word 2003 documents, a valid XML Schema must be designed. Careful consideration must be put into the design of the schema in order to support all variations of the document template.

It is recommended that the schema files and other solution files (for smart documents and smart tags) be stored on a Web server to which information workers have access.

#### Interoperability

XML support is a highly evolved feature in the Microsoft Office System. Documents with mapped schemas are viewable in older versions of Microsoft Office, but if they are saved in those versions all schema information will be lost. Older versions cannot make use of the XML schema information.

#### Security

Namespaces and schemas can serve as very descriptive examples of how your company's business processes work. Therefore, it is a good idea to be cautious about how schemas are distributed.

#### User Training

Information workers do not need to know how to build XML schemas. Generally, an organization will create a schema for a given document type and distribute it to users. Once the schema is attached, information workers need not even know that the content they create in their familiar Office applications is actually being tagged with XML.

## Conclusion

With the Microsoft Office System, the sharing of information between documents, databases and other applications is simplified through support for customer-defined XML schema. Users can freely contribute their thoughts and ideas, and developers do not have to worry about how they are going to process that information. Simply put, content in the Microsoft Office System becomes free-flowing, accessible data through the use of XML.

## References

For more information, see the following:

- [Microsoft Office System](http://go.microsoft.com/fwlink/?linkid=19874)
- [XML Schema Primer](http://go.microsoft.com/fwlink/?linkid=19875)
- [The Microsoft Office System and XML: XML in Action](https://msdn.microsoft.com/en-us/library/odc_xmlinoffice2003_ofofficesysxmlinaction%28v=office.11%29)

[© Microsoft Corporation. All rights reserved.](https://msdn.microsoft.com/en-us/library/ms369863)