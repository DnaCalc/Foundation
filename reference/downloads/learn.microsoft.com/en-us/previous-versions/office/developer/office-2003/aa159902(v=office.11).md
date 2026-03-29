---
layout: Conceptual
title: Using Schemas with Word 2003 and Excel 2003 | Microsoft Docs
canonicalUrl: https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa159902(v=office.11)
locale: en-us
author: Archived
breadcrumb_path: /previous-versions/office/developer/office-2003/breadcrumb/toc.json
depot_name: MSDN.office-dev-office2003-archive-pr
document_id: 02e8748f-62ec-13f4-8fe0-a25d4fca7872
document_version_independent_id: 8010a315-7123-1a53-0695-607b966a97e9
gitcommit: https://docs-archive.visualstudio.com/DefaultCollection/docs-archive-project/_git/office-dev-archive-pr/commit/382e62baf073771e5a9562e3f2e9b91ca6f6e47a?path=/office-dev-office2003-reference-archive/aa159902(v=office.11).md&_a=contents
is_archived: true
ms.author: Archived
ms.date: 2010-01-08T00:00:00.0000000Z
ms.prod: office-2003
ms.topic: archived
ms:assetid: office|dno2k3ta|~\html\odc_of_wordxmschemas.htm
ms:contentKeyID: 3886898
ms:mtpsurl: https://msdn.microsoft.com/en-us/library/Aa159902(v=office.11)
mtps_version: v=office.11
original_content_git_url: https://docs-archive.visualstudio.com/DefaultCollection/docs-archive-project/_git/office-dev-archive-pr?path=/office-dev-office2003-reference-archive/aa159902(v=office.11).md&version=GBlive&_a=contents
page_type: conceptual
ROBOTS: NOINDEX,NOFOLLOW
search.ms_docsetname: office-dev-office2003-archive-pr
search.ms_product: MSDN
search.ms_sitename: Docs
search.mshattr.devlang: vba
site_name: Docs
toc_rel: toc.json
TOCTitle: Using Schemas with Word 2003 and Excel 2003
uhfHeaderId: MSDocsHeader-Archive
updated_at: 2018-04-13T20:16:00.0000000Z
word_count: 3431
asset_id: aa159902(v=office.11)
moniker_range_name: 
monikers: []
item_type: Content
platformId: 3664264c-a082-c70d-8960-8346194d025f
---

# Using Schemas with Word 2003 and Excel 2003 | Microsoft Docs

Mary Chipman MCW Technologies

April 2004

Applies to: Microsoft® Office Word 2003 Microsoft Office Excel 2003 Microsoft Office System

**Summary:** Mary Chipman provides an easy to follow introduction for working with the new XML functionality in the Microsoft Office System by walking through common XML tasks in Microsoft Office Word 2003 and Microsoft Office Excel 2003. She reviews attaching custom schemas, validating markup, using placeholders, working with XML maps in Excel, and more. (11 printed pages)

#### Contents

Introduction Work with Schemas in Word 2003 Work with Schemas in Excel 2002 and Excel 2003 Conclusion

## Introduction

Microsoft® Office Word 2003 and Microsoft Office Excel 2003 contain new functionality for using XML, allowing you to separate a document or worksheet's data from its presentation. You can use and modify the contents from other programs and exchange data with other systems.

Word and Excel each provide their own implementations of XML. Both support the ability to attach an XML schema or XSD, and map data to schema. You use a schema file when you want to control the syntax of an XML document. You can specify the data type of each element, create simple or complex types, add rules restricting the number of times a particular element can occur, and limit the ranges of values in an element. You can use schemas to validate XML data and to ensure predictability when exchanging data, and are a key feature in Microsoft Office System 2003. For example, you could use a schema file in Word to create a sales memo, and use it again in Excel to analyze sales data.

## Working with Schemas in Word 2003

**Important** The information set out in this topic is presented exclusively for the benefit and use of individuals and organizations The information set out in this section of this topic is presented exclusively for the benefit and use of individuals and organizations outside the United States and its territories or whose products were distributed by Microsoft before January 2010, when Microsoft removed an implementation of particular functionality related to custom XML from Word. This information may not be read or used by individuals or organizations in the United States or its territories whose products were licensed by Microsoft after January 10, 2010; those products will not behave the same as products licensed before that date or licenses for use outside the United States.

You can attach any custom XML schema to a Word document, as long as it adheres to the [World Wide Web Consortium (W3C) XML Schema recommendation](http://go.microsoft.com/fwlink/?linkid=24543). You cannot attach an invalid schema to a Word document. Once you attach the schema, you can map its XML tags to the contents of the document.

When you save your document as XML, Word saves both the WordProcessingML schema and the custom schema with the document, preserving the rich formatting of the Word document and the data as defined by the custom XML schema. You also have the option of saving only the custom XML data to a file. By default, Word validates the document to ensure that it conforms to the schema and saves the raw XML data only. Even if Word cannot validate the XML data against the custom schema, you can save the document as a Word document (.doc) or Word template (.dot). You cannot access or process the XML in the document without loading it in Word.

#### Attach a Custom Schema

To create an XML document:

1. On the **File** menu, click **New**. This displays the **New Document** task pane.
2. Click the **XML Document** link to create a document and display the **XML Structure** task pane.
3. On the **XML structure** task pane, click the **Templates andAdd-ins** link and then the **XML Schema** tab.
4. In the **Available XML schemas** list, select the schema to use. If the schema you want to use does not appear in the list, click **Add Schema** to add it.

**Figure 1** shows the **Templates and Add-ins** dialog box. In the **Schema validation options** section, the default is to validate the document against attached schemas and to disallow saving as XML if the schema is not valid. You can also add a schema to the existing document by clicking **Schema Library**. Click **XML Options** to set additional options for saving XML and for schema validation.

![](images/aa159902.odc_of_wordxlschemas_01(en-us,office.11).gif)

**Figure 1. Attaching a custom schema**

#### The Schema Library

When you attach a schema, Word adds it automatically to the schema library, the repository for schemas and XSLT files (style sheets). When Word opens an XML file in a namespace matching the namespace of one of the schemas in the library, Word automatically attaches that schema to the document. When you add an XSLT file to the schema library, Word also applies it automatically when an XML file matching the namespace is opened in Word. XSLT style sheets are special XML documents that specify transformations of other XML documents—you can use them to filter and format XML data. You can package schemas with other related files and add them to the schema library as whole solutions.

The schema library maintains the following information:

- A list of all schemas that were used
- A URI or namespace, which the schema library takes directly from the schema file. You can also use an optional alias. By default, the schema library lists a schema by its namespace, which is usually long and not very user-friendly. An alias allows you to refer to a schema with a more intuitive and user-friendly name.
- Solutions**and**XSLTs, which can range from a complex smart document solution to a basic XSLT. Word associates each solution or XSLT with a namespace. When a user opens an XML file, Word searches the list of solutions that are associated with the file's namespace.
- Manifests, which are schema files that point to the files to open when opening an XML document. For example, a manifest can point to a schema and an XSLT, or it can point to a smart document solution. Manifests ease deployment by allowing Office to update files in a central server location and fetched as needed by client applications.

**Figure 2** displays the **Edit Schema Properties** dialog box, activated when you click **Schema Settings** in the **Schema Library** dialog box. You can set properties and create an alias for a namespace. Note that you can also click **Browse** to modify the location of the selected schema, making it easy to centralize schema files in a shared location.

![](images/aa159902.odc_of_wordxlschemas_02(en-us,office.11).gif)

**Figure 2. Working with the Schema Library**

#### Mark Up Using the XML Structure Task Pane

Once you attach the schema, Word displays it in the **XML Structure** task pane. To mark up the document with XML tags, select the portions of the document that you want contained between the tags, and make a selection from the **Choose an element to apply to your current selection** list. **Figure 3** shows the **XML Structure** task pane with a schema displayed. The document is partially marked up, with the **memo** element applied to the entire document. The **to** element is applied to a table cell, and the remaining elements are not yet applied.

![](images/aa159902.odc_of_wordxlschemas_03(en-us,office.11).gif)

**Figure 3. The XML Structure task pane with a custom schema**

To remove an XML tag or element from the document, right-click the tag in the **XML Structure** task pane or in the document, and choose the **Remove &lt;tag name&gt; tag** option.

#### Validation

The red question mark icon to the left of the memo element indicates that there are required elements still missing in order for Word to validate the document against the attached schema. Once you apply all of the required elements, the question mark disappears.

#### Showing and Hiding XML Tags

You can toggle the display of the XML tags in the document by pressing **CTRL+SHIFT+X** or by clicking the **Show XML tagsin the document** check box in the **XML Structure** task pane.

#### Use Placeholder Text for Empty XML Tags

You can display placeholder text for empty elements in your XML document. Click the **XML Options** link at the bottom of the **XML Structure** task pane and select the box next to the option labeled **Show placeholder text for all empty elements**. When you hide the XML tags in the document, empty elements display the tag name in square brackets. When a user clicks the placeholder text and starts to type, the placeholder text disappears.

You can customize the text displayed in the brackets. To do so, right-click each element in the tree view of the **XML Structure** pane and choose **Attributes**. Fill in the text you want displayed and click **OK**. When you specify placeholder text in the Attributes dialog box, that individual element always uses your custom placeholder text, regardless of your **Show placeholder text for all empty elements** settings.

#### Saving XML Documents

You can save your XML documents in Word format as either a document (.doc) or template file (.dot). You can also use XML tags in a document that saved as HTML. Saving in Word format preserves the XML structure and data, but does not allow access to the raw XML from other processes. You need to open the document in Word to access the XML.

To save the document in XML format, choose the **XML document (XML)** option in the **Save As type** dialog box. There are two options for saving XML documents in Word:

- **Word Markup Language (WordProcessingML)**. This preserves the Word document, including formatting, hyperlinks, and paragraphs, as well as the XML structure and data.
- **Data only**. Word saves only the XML data that you mark up, and loses all other text and formatting. If you attached a separate schema, Word saves the data that you marked with elements from the attached schema. To save data only, click the **Save data only** checkbox located next to **Save** and **Cancel** in the **Save As** dialog box.

> 
> \*\***Note** \*\*If you click **Save** on the toolbar, or choose **Save** from the **File** menu, the document is saved in **Word Markup Language (WordProcessingML)**, the default setting.

When you save as an XML document or as data only, Word validates the document against the XML schema, unless you choose the option to turn validation off when you attach the schema. If there are validation errors, Word displays a dialog box offering to save the document as a Word document (.doc) or allowing you to cancel and fix the validation errors.

#### Saving with a Transform

To save an XML document with a transform to XSLT, check the **Apply transform** checkbox located next to **Save** and **Cancel**. Select the XML transform (XSLT), click **Open**, and then **Save**.

## Work with Schemas in Excel 2002 and Excel 2003

Microsoft Excel 2002 and Microsoft Office Excel 2003 support XML in a format designed specifically for Excel, called the XML Spreadsheet format (for both workbooks and templates). Data contained in an XML Spreadsheet is made available easily to other processes, and you can manipulate it in Excel. Excel adds additional XML features, allowing you to add arbitrary XML schemas to a workbook and to manipulate XML using visual tools to select, drag, and drop XML elements onto a worksheet. You can attach any custom XML schema to an Excel workbook as long as it adheres to the World Wide Web Consortium (W3C) XML Schema recommendation. You cannot attach an invalid schema to an Excel workbook. If you open an XML file in Excel that does not have an associated schema, Excel infers a schema based on the XML data file.

Once you add an XML schema to an Excel workbook, Excel creates an XML map that you can use to create mapped ranges and which Excel uses to manage the relationship between those mapped ranges and the elements in the XML schema. When you import or export XML data, Excel uses the map to relate the contents of a mapped range to elements in the schema. A workbook can contain many XML maps where each map is an independent entity. You can also have multiple maps refer to the same schema. The XML map must contain one root element, so if you add a schema that defines more than one root element, you must choose a single root element to use with the XML map.

#### Add an XML Map to a Workbook

1. On the **View** menu, click **Task Pane** to display the **XML Source** task pane

    -OR-

    Pressing **Ctrl+F1** and choose **XML Source** from the drop-down list.

    -OR-

    On the **Data** menu, point to **XML**, and then click **XML Source**.
2. Click **Workbook Maps** and then **Add**.
3. Go to the schema file and click **Open** and then **OK**.

    This attaches the schema and adds an XML map to the workbook. You can now drag schema elements onto the worksheet to map them. This does not automatically add any data to the workbook.

> 
> \*\*Note \*\*You need to import the data as a separate step after you have marked up the worksheet by mapping the desired elements.

    You can add more than one schema to a workbook. However, a single spreadsheet range can only accommodate one XML element. There cannot be overlap between two or more XML elements.

    **Figure 4** displays the **XML Source** task pane showing an XML map with a root node of Customers. Excel displays the child elements in a hierarchical view.

    ![](images/aa159902.odc_of_wordxlschemas_04(en-us,office.11).gif)

    **Figure 4. The XML Source task pane**
4. Click **Options** to customize mapping and to toggle the mapping borders. You can choose to preview sample data in the task pane, show or hide help text in the task pane, and automatically merge elements when mapping. You can also specify to use data as column headings when you map repeating elements to your worksheet.
5. Click **Workbook Maps** to bring up the **XML Maps** dialog box, which you can use to add, delete, or rename XML maps.
6. Click **Verify Map for Export** to check to see if Excel can export data using the currently selected map.

At the bottom of the task pane, you can see a link to **Tips for mapping XML** which, when clicked, brings up relevant information from the Excel help.

The icons displayed in the element list of the **XML Source** task pane have specific meanings. See the topic "About the XML Source Task Pane" in Microsoft Excel Help for a complete description of each icon.

#### Mapping with the XML Source Task Pane

The **XML Source** task pane displays the XML schemas in the workbook in a tree view. It also provides options to customize mapping behaviors and an entry point to the XML Maps dialog box.

You can map elements by dragging and dropping them onto the worksheet, or right-click each element and choose **Map element**. You can select non-adjacent elements by clicking one element, holding down the **Ctrl** key, and clicking additional elements. Once you select the elements, drag them to the worksheet location where you want them to appear. If the element is a repeating element, Excel creates an XML List in the location (cell) where you added the element.

#### Working with XML Lists

Excel automatically creates an XML list when one or more of the elements dragged onto the worksheet is a repeating element, whereas Excel maps non-repeating elements to single cells. Excel associates the columns in an XML list with an XML schema element by the XPath property of the column.

XML lists are row-based, meaning that they grow from the header row downwards. You cannot add new entries above existing rows. You also cannot transpose an XML list so that Excel adds new entries to the right.

#### XML Map Properties for Data Binding

When you import an XML data file into an existing mapping, or use a Data Retrieval Service Connection (.uxdc) file to connect to a data source, Excel creates an XML data binding. Each XML map can have only one data binding.

**To Refresh a Data Binding**

1. On the **List and XML** toolbar, click **Refresh**

    -OR-

    On the **Data** menu, in the **XML** node, click **Refresh XML Data**. The behavior of the refreshed data depends on the settings in the **XML Map Properties** dialog box, as shown in **Figure 5**.
2. Specify whether to append new data or overwrite existing data by configuring the options at the bottom of the dialog box in the **When refreshing/importing data** section.

    ![](images/aa159902.odc_of_wordxlschemas_05(en-us,office.11).gif)

    **Figure 5. The XML Map Properties dialog box**

Each XML map has the option to validate the XML data using the XML map's schema. Turn on XML schema validation using the checkbox under the **XML schema validation** heading.

Clearing the **Save data source definition in workbook** check box removes the XML binding from the workbook. It does not delete any data from the worksheet.

You can set other map properties, such as formatting and layout options when the number of rows in the data range changes while importing or refreshing data. You can also choose whether to overwrite existing data when importing or refreshing, or to append the new data to existing rows.

#### Working with Denormalized Data and List of Lists

Any time a single data point in an incoming XML data file is associated with one or more repeating elements and the single data point and repeating elements are in a single list, Excel renders the data in the list by denormalizing it. In other words, the data point only appears once in the XML file, but Excel associates it with multiple rows. Excel renders the data point multiple times, once on each related row.

You cannot export data to an XML file from an XML map containing denormalized data because there is ambiguity regarding to which of the many data points in the worksheet the single data point in the XML file is written. Such an XML map is not exportable. To remedy the situation, map the denormalized element to a single cell.

A list of lists occurs when a schema defines that an element that repeats can itself be the parent of repeating elements (for example, multiple Customer elements, each which contain multiple Orders elements, and so on). Because a single parent element is associated with a repeating child element, Excel denormalizes the data when it maps it in the same list.

#### To Save or Export a Mapped Range

To save the contents of the workbook in the **XML Spreadsheet** file format, on the **File** menu, click **Save As**.

1. In the **Save as type** list, click **XML Spreadsheet** and then click **Save**.

> 
> \*\*Note \*\*You can save a workbook in XML Spreadsheet format whether or not the workbook contains XML Maps. You can also save the spreadsheet in the traditional format as well. Saving in XML Spreadsheet format is simply another way to save the workbook.
2. To save your XML data only, on the **File** menu, click **Save As.**
3. In the **Save as type** list, click **XML Data**. This writes the data to a file defined by the XML schema associated with the XML map in your workbook. Other ways to save XML data only are on the **List and XML** toolbar, click **Export**, or on the **Data** menu, click **XML** and then **Export** to export data to an XML data file.

Excel validates the XML data file depending on your settings in the **XML Map Properties** dialog box. If XML schema validation is on, Excel provides an error message if the data fails to pass schema validation.

## Conclusion

A schema allows you to specify which elements, attributes, data types, and hierarchies to allow in an XML data file. You can use schema files to validate XML data and to ensure predictability when exchanging data. You can attach XML schemas to both Word documents and Excel workbooks as long as they adhere to the World Wide Web Consortium (W3C) XML Schema recommendation. Word uses the schema library to manage custom schemas, and Excel uses the **XML maps** collection. In Word, you use the **XML Structure** task pane to mark up a document. In Excel, you use the **XML Source** task pane to map elements to cells or to XML lists. You can toggle the display of XML tags in a Word document, but they are not visible in an Excel worksheet. Both Word and Excel support saving XML data in their own formats as WordProcessingML or XML Spreadsheet respectively, or as data-only XML files.

#### About the Author

Mary Chipman is a senior consultant with MCW Technologies and is based in Singer Island, FL. She has been a Microsoft MVP every year since 1995. She is the co-author of several books and develops courseware and training videos for AppDev for Microsoft Visual Studio® .NET and Microsoft SQL Server™.

[© Microsoft Corporation. All rights reserved.](https://msdn.microsoft.com/en-us/library/ms369863)