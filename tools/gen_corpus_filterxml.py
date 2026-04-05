#!/usr/bin/env python3
"""
Add FILTERXML test formulas. FILTERXML is a Windows-only Excel function
that parses XML strings and extracts values via XPath. It may be one of
the deferred functions in our engine — including it in the corpus lets us
discover that during testing.

Also includes the original Reddit calendar formula (adapted to be
self-contained via LET) as a stress-test specimen.
"""
import json, os

JSONL_PATH = os.path.join(os.path.dirname(__file__), "..",
                          "reference", "test-corpus", "formula",
                          "single-cell", "formulas.jsonl")

with open(JSONL_PATH) as f:
    existing = sum(1 for _ in f)

seq = existing

def ftc(n):
    return f"FTC-{n:04d}"

def e(category, subcategory, formula, expected, tags, functions_exercised,
      complexity="advanced", expected_type="number", expected_error=None,
      result_is_array=False, array_dimensions=None, let_bindings=0,
      deterministic=True, operators=None, source_ids=None, provenance="authored",
      provenance_detail="AI-generated for DnaCalc test corpus", notes=None):
    global seq
    seq += 1
    return {
        "test_id": ftc(seq), "formula": formula, "category": category,
        "subcategory": subcategory, "tags": tags, "complexity": complexity,
        "functions_exercised": functions_exercised,
        "operators_exercised": operators or [],
        "expected_result": expected, "expected_result_type": expected_type,
        "expected_error": expected_error, "result_is_array": result_is_array,
        "array_dimensions": array_dimensions, "let_bindings": let_bindings,
        "deterministic": deterministic, "requires_locale": False,
        "requires_date_system": None,
        "conformance_req_ids": [], "evidence_ids": [],
        "source_ids": source_ids or [],
        "provenance": provenance,
        "provenance_detail": provenance_detail,
        "notes": notes
    }

entries = []

# ============================================================
# FILTERXML basics — may be deferred/unimplemented
# ============================================================

entries.append(e("text_string", "filterxml_basic",
    '=FILTERXML("<a><b>1</b><b>2</b><b>3</b></a>","//b[1]")',
    "1", ["filterxml", "xpath", "basic", "windows_only"],
    ["FILTERXML"], complexity="intermediate", expected_type="string",
    notes="FILTERXML parses XML string and extracts via XPath. Windows-only function. May be deferred in our engine."))

entries.append(e("text_string", "filterxml_count",
    '=FILTERXML("<root><item>apple</item><item>banana</item><item>cherry</item></root>","count(//item)")',
    3, ["filterxml", "xpath", "count"],
    ["FILTERXML"], complexity="intermediate",
    notes="FILTERXML with XPath count() function. Returns 3 items."))

entries.append(e("text_string", "filterxml_sum",
    '=FILTERXML("<r><n>10</n><n>20</n><n>30</n></r>","sum(//n)")',
    60, ["filterxml", "xpath", "sum"],
    ["FILTERXML"], complexity="intermediate",
    notes="FILTERXML with XPath sum() aggregate"))

entries.append(e("text_string", "filterxml_split_string",
    '=LET(str,"one,two,three",xml,"<a><b>"&SUBSTITUTE(str,",","</b><b>")&"</b></a>",FILTERXML(xml,"//b[2]"))',
    "two", ["filterxml", "string_split", "substitute_xml"],
    ["LET", "FILTERXML", "SUBSTITUTE"],
    operators=["&"], let_bindings=2, complexity="advanced", expected_type="string",
    notes="Classic FILTERXML trick: split comma-separated string into array via XML, extract 2nd element. This is the core technique in the Reddit calendar formula."))

entries.append(e("text_string", "filterxml_split_array_sum",
    '=LET(str,"10,20,30,40",xml,"<a><b>"&SUBSTITUTE(str,",","</b><b>")&"</b></a>",SUM(FILTERXML(xml,"//b")))',
    100, ["filterxml", "split_to_numbers", "sum"],
    ["LET", "FILTERXML", "SUBSTITUTE", "SUM"],
    operators=["&"], let_bindings=2, complexity="advanced",
    notes="Split numeric CSV string via FILTERXML and SUM the resulting array: 10+20+30+40=100"))

entries.append(e("text_string", "filterxml_nth_word",
    '=LET(str,"The quick brown fox jumps",xml,"<a><b>"&SUBSTITUTE(str," ","</b><b>")&"</b></a>",FILTERXML(xml,"//b[3]"))',
    "brown", ["filterxml", "word_extraction", "nth_word"],
    ["LET", "FILTERXML", "SUBSTITUTE"],
    operators=["&"], let_bindings=2, complexity="intermediate", expected_type="string",
    notes="Extract Nth word from string using FILTERXML (split on spaces)"))

entries.append(e("text_string", "filterxml_unique_values",
    '=LET(str,"a,b,a,c,b,a",xml,"<a><b>"&SUBSTITUTE(str,",","</b><b>")&"</b></a>",FILTERXML(xml,"//b[not(.=preceding::b)]"))',
    None, ["filterxml", "distinct", "xpath_preceding"],
    ["LET", "FILTERXML", "SUBSTITUTE"],
    operators=["&"], let_bindings=2, complexity="expert", expected_type="string",
    result_is_array=True, array_dimensions="3x1",
    notes="FILTERXML with XPath distinct-values trick using preceding:: axis. Returns unique values. Result is array; first element should be 'a'."))

# Set expected to first element for testability
entries[-1]["expected_result"] = "a"
entries[-1]["result_is_array"] = False
entries[-1]["array_dimensions"] = None
entries[-1]["notes"] += " We test first element = 'a'."

# ============================================================
# The original Reddit calendar formula, adapted with LET
# ============================================================

# This is the monster formula, slightly simplified (one month) and
# self-contained with LET instead of $A$1 reference
entries.append(e("nested_complex", "reddit_calendar_one_month",
    '=LET(yr,2024,m,1,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),gridStart,firstDay-WEEKDAY(firstDay,1)+1,dates,gridStart+SEQUENCE(42,,0),dayStrs,MAP(dates,LAMBDA(d,IF(AND(d>=firstDay,d<=lastDay),TEXT(DAY(d),"00"),"  "))),monthName,TEXT(firstDay,"MMMM"),TEXTJOIN("|",FALSE,monthName,INDEX(dayStrs,1),INDEX(dayStrs,2),INDEX(dayStrs,3),INDEX(dayStrs,4),INDEX(dayStrs,5),INDEX(dayStrs,6),INDEX(dayStrs,7)))',
    "January|  |01|02|03|04|05|06",
    ["reddit_calendar", "full_month", "textjoin", "calendar_grid"],
    ["LET", "DATE", "EOMONTH", "WEEKDAY", "SEQUENCE", "MAP", "LAMBDA", "IF", "AND", "TEXT", "DAY", "TEXTJOIN", "INDEX"],
    operators=["-", "+", ">=", "<="], let_bindings=7, complexity="expert",
    expected_type="string",
    source_ids=["R-SRC-125"], provenance="adapted",
    provenance_detail="Adapted from u/geminiikki Reddit calendar formula — single month self-contained via LET",
    notes="One-month calendar first week: Jan 2024 starts Mon, so Sun=blank, Mon-Sat=01-06. Header + 7 day strings joined with |."))

# ============================================================
# WEBSERVICE (another Windows-only function that pairs with FILTERXML)
# ============================================================

entries.append(e("text_string", "filterxml_attribute",
    '=FILTERXML("<items><item id=""1"">apple</item><item id=""2"">banana</item></items>","//item[@id=2]")',
    "banana", ["filterxml", "xpath", "attribute_selector"],
    ["FILTERXML"], complexity="advanced", expected_type="string",
    notes="FILTERXML with XPath attribute selector. Selects item where id=2."))

entries.append(e("text_string", "filterxml_last",
    '=FILTERXML("<a><b>x</b><b>y</b><b>z</b></a>","//b[last()]")',
    "z", ["filterxml", "xpath", "last"],
    ["FILTERXML"], complexity="intermediate", expected_type="string",
    notes="XPath last() function to get final element"))

# Write entries
with open(JSONL_PATH, "a", encoding="utf-8") as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

total = existing + len(entries)
print(f"Appended {len(entries)} entries (FTC-{existing+1:04d} to FTC-{total:04d})")
print(f"Total entries in file: {total}")
