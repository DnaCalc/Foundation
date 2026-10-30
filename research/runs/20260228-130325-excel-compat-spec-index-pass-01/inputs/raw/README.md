# inputs/raw: saved Microsoft web pages

The 70 HTML files here are copies of Microsoft web pages, saved on 2026-02-28 as the inputs of
this run: 59 from support.microsoft.com, 10 from learn.microsoft.com and 1 from
techcommunity.microsoft.com. Their content is Microsoft's, copyright Microsoft Corporation, kept
as reference material. Each file's source is the canonical URL in its own `<link rel="canonical">`
element; `../../outputs/source_list.csv` and `../../outputs/source_digest.csv` map the file names
(`ECS-NNN`, `source_N`) to their URLs. The description column of `../../outputs/function_catalog_raw.csv`
and `function_catalog_full.csv` holds Microsoft's one-line function descriptions taken from
these pages, with each function's article in the `function_url` column.
