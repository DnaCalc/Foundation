#!/usr/bin/env python3
"""
Add formulas adapted from u/geminiikki's Reddit calendar formula.
Source: https://www.reddit.com/r/excel/comments/r9w3wb/comment/hngbd4v/
Thread: "What is the craziest formula you've ever used/seen?" by u/Redrumtac1

The original formula generates a full 12-month calendar in a single cell
using FILTERXML, CHOOSE, SEQUENCE, TEXT with conditional date formatting,
WEEKDAY, EOMONTH, TEXTJOIN, and TRANSPOSE. It references $A$1 for the year.

We can't use the original directly (cell refs, FILTERXML is Windows-only),
but we adapt the key techniques:
1. Calendar grid generation via DATE+WEEKDAY+SEQUENCE
2. Conditional TEXT formatting with date range brackets [<date] [>date]
3. Month-start weekday alignment
4. Full month grid including blank padding
5. TEXTJOIN-based string assembly patterns
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
      deterministic=True, operators=None, notes=None):
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
        "source_ids": ["R-SRC-125"],
        "provenance": "adapted",
        "provenance_detail": "Adapted from u/geminiikki Reddit calendar formula (r/excel 'craziest formula' thread)",
        "notes": notes
    }

entries = []

# 1. Core technique: first day of month weekday offset
entries.append(e("date_time", "weekday_offset_january",
    '=LET(yr,2024,m,1,firstDay,DATE(yr,m,1),WEEKDAY(firstDay,1))',
    2, ["weekday", "month_start", "calendar_grid", "reddit_calendar"],
    ["LET", "DATE", "WEEKDAY"],
    let_bindings=3, complexity="intermediate",
    notes="Jan 1 2024 = Monday. WEEKDAY type 1 (Sun=1): Monday=2. This offset determines column placement in calendar grid."))

# 2. Generate 42-day grid starting from Sunday before month start (6 weeks covers any month)
entries.append(e("date_time", "calendar_grid_42days",
    '=LET(yr,2024,m,1,firstDay,DATE(yr,m,1),gridStart,firstDay-WEEKDAY(firstDay,1)+1,days,SEQUENCE(42,,0),dates,gridStart+days,SUM(--(MONTH(dates)=m)))',
    31, ["calendar_grid", "42day_grid", "month_days", "reddit_calendar"],
    ["LET", "DATE", "WEEKDAY", "SEQUENCE", "SUM", "MONTH"],
    operators=["-", "+", "=", "--"], let_bindings=5, complexity="advanced",
    notes="42-day grid (6 weeks) starting from Sunday before Jan 1. Count days in January = 31."))

# 3. Conditional TEXT formatting — the brilliant technique from the original
# TEXT with [<date] and [>date] conditions blanks out-of-month days
entries.append(e("date_time", "conditional_text_date_format",
    '=LET(yr,2024,m,3,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),testDate,DATE(yr,m,15),TEXT(testDate,"[<"&firstDay&"] ;[>"&lastDay&"] ;dd"))',
    "15", ["conditional_text", "date_format", "bracket_conditions", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "TEXT"],
    operators=["&"], let_bindings=4, complexity="advanced", expected_type="string",
    notes="TEXT conditional formatting: [<firstDay] returns space, [>lastDay] returns space, otherwise 'dd'. March 15 is in range, returns '15'."))

# 4. Same technique but for out-of-range date (should return blank/space)
entries.append(e("date_time", "conditional_text_out_of_range",
    '=LET(yr,2024,m,3,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),testDate,DATE(yr,2,28),result,TEXT(testDate,"[<"&firstDay&"] ;[>"&lastDay&"] ;dd"),LEN(TRIM(result)))',
    0, ["conditional_text", "out_of_range", "blank", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "TEXT", "LEN", "TRIM"],
    operators=["&"], let_bindings=5, complexity="advanced",
    notes="Feb 28 is before March 1, so TEXT conditional returns space. TRIM+LEN = 0 (blank)."))

# 5. Day-of-week headers via TEXT+DATE
entries.append(e("text_string", "weekday_headers",
    '=LET(baseSun,DATE(2024,1,7),headers,TEXT(baseSun+SEQUENCE(1,7,,1)-1,"DDD"),INDEX(headers,1,1))',
    "Sun", ["weekday_headers", "text_format", "calendar", "reddit_calendar"],
    ["LET", "DATE", "TEXT", "SEQUENCE", "INDEX"],
    operators=["+", "-"], let_bindings=2, complexity="intermediate", expected_type="string",
    notes="Generate weekday abbreviations Sun-Sat by formatting sequential dates. Index 1 = Sun."))

# 6. Full month text grid with TEXTJOIN (mimicking the FILTERXML+TEXTJOIN pattern)
entries.append(e("text_string", "month_days_textjoin",
    '=LET(yr,2024,m,2,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),gridStart,firstDay-WEEKDAY(firstDay,1)+1,dates,gridStart+SEQUENCE(7,,0),dayTexts,MAP(dates,LAMBDA(d,IF(AND(d>=firstDay,d<=lastDay),TEXT(DAY(d),"00"),"  "))),TEXTJOIN(",",FALSE,dayTexts))',
    "  ,  ,  ,  ,01,02,03", ["textjoin", "calendar_row", "month_grid", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "WEEKDAY", "SEQUENCE", "MAP", "LAMBDA", "IF", "AND", "TEXT", "DAY", "TEXTJOIN"],
    operators=["-", "+", ">=", "<="], let_bindings=6, complexity="advanced", expected_type="string",
    notes="First week of Feb 2024: Thu=1st, so Sun-Wed blank, Thu-Sat = 01,02,03"))

# 7. Count weeks needed for a month (5 or 6)
entries.append(e("date_time", "weeks_in_month",
    '=LET(yr,2024,m,2,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),startWeekday,WEEKDAY(firstDay,1),daysInMonth,DAY(lastDay),CEILING.MATH((startWeekday-1+daysInMonth)/7))',
    5, ["weeks_in_month", "ceiling", "calendar_layout", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "WEEKDAY", "DAY", "CEILING.MATH"],
    operators=["-", "+", "/"], let_bindings=5, complexity="intermediate",
    notes="Feb 2024: starts Thu(5), 29 days. (5-1+29)/7 = 4.71, ceiling = 5 weeks needed."))

# 8. March 2024 needs 6 weeks
entries.append(e("date_time", "weeks_in_month_six",
    '=LET(yr,2024,m,3,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),startWeekday,WEEKDAY(firstDay,1),daysInMonth,DAY(lastDay),CEILING.MATH((startWeekday-1+daysInMonth)/7))',
    6, ["weeks_in_month", "six_weeks", "calendar_layout", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "WEEKDAY", "DAY", "CEILING.MATH"],
    operators=["-", "+", "/"], let_bindings=5, complexity="intermediate",
    notes="Mar 2024: starts Fri(6), 31 days. (6-1+31)/7 = 5.14, ceiling = 6 weeks."))

# 9. CHOOSE+SEQUENCE pattern (the backbone of the original formula's 13-column select)
entries.append(e("nested_complex", "choose_sequence_multicolumn",
    '=LET(cols,SEQUENCE(1,4),result,CHOOSE(cols,"Alpha","Bravo","Charlie","Delta"),INDEX(result,1,3))',
    "Charlie", ["choose", "sequence", "multi_column", "reddit_calendar"],
    ["LET", "SEQUENCE", "CHOOSE", "INDEX"],
    let_bindings=2, complexity="intermediate", expected_type="string",
    notes="CHOOSE driven by SEQUENCE generates multi-column output. The Reddit formula uses CHOOSE(SEQUENCE(1,13)) for header + 12 months."))

# 10. Month name from month number
entries.append(e("text_string", "month_name_from_number",
    '=TEXT(DATE(2024,7,1),"MMMM")',
    "July", ["month_name", "text_format", "reddit_calendar"],
    ["TEXT", "DATE"],
    complexity="basic", expected_type="string",
    notes="TEXT with MMMM format code gives full month name. Used in the calendar header."))

# 11. Full month grid — count non-blank entries to verify correct day generation
entries.append(e("nested_complex", "full_month_grid_count",
    '=LET(yr,2024,m,2,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),gridStart,firstDay-WEEKDAY(firstDay,1)+1,allDates,gridStart+SEQUENCE(42,,0),inMonth,--(AND(allDates>=firstDay)*(allDates<=lastDay)),SUM(inMonth))',
    29, ["calendar_grid", "full_month", "february_leap", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "WEEKDAY", "SEQUENCE", "SUM", "AND"],
    operators=["-", "+", ">=", "<=", "*", "--"], let_bindings=6, complexity="advanced",
    notes="Count days in Feb 2024 (leap year) from 42-day grid = 29"))

# Hmm, AND doesn't work element-wise on arrays like that. Fix:
entries[-1]["formula"] = '=LET(yr,2024,m,2,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),gridStart,firstDay-WEEKDAY(firstDay,1)+1,allDates,gridStart+SEQUENCE(42,,0),inMonth,(allDates>=firstDay)*(allDates<=lastDay),SUM(inMonth))'
entries[-1]["functions_exercised"] = ["LET", "DATE", "EOMONTH", "WEEKDAY", "SEQUENCE", "SUM"]

# 12. The TRANSPOSE+CHOOSE combination — verifying row/column swap
entries.append(e("dynamic_array", "transpose_choose_pattern",
    '=LET(data,CHOOSE(SEQUENCE(1,3),{1;2;3},{10;20;30},{100;200;300}),result,TRANSPOSE(data),INDEX(result,1,2))',
    2, ["transpose", "choose", "matrix_build", "reddit_calendar"],
    ["LET", "CHOOSE", "SEQUENCE", "TRANSPOSE", "INDEX"],
    let_bindings=2, complexity="intermediate",
    notes="CHOOSE builds columns, TRANSPOSE flips to rows. The Reddit formula builds 13 columns then transposes for display."))

# 13. The complete adapted calendar — single month, self-contained with LET
entries.append(e("nested_complex", "calendar_month_selfcontained",
    '=LET(yr,2024,m,1,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),gridStart,firstDay-WEEKDAY(firstDay,1)+1,week1,gridStart+SEQUENCE(1,7,,1)-1,dayNums,MAP(week1,LAMBDA(d,IF(AND(d>=firstDay,d<=lastDay),DAY(d),0))),SUM(dayNums))',
    6, ["calendar", "single_month", "self_contained", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "WEEKDAY", "SEQUENCE", "MAP", "LAMBDA", "IF", "AND", "DAY", "SUM"],
    operators=["-", "+", ">=", "<="], let_bindings=6, complexity="advanced",
    notes="First week of Jan 2024: Mon=1st, so only Mon-Sat have Jan days. Sum of first week day numbers: 1+2+3+4+5+6=21. Wait: Jan 1 2024=Mon. Sun before=Dec31. Week1: Sun(0),Mon(1),Tue(2),Wed(3),Thu(4),Fri(5),Sat(6). Sum=1+2+3+4+5+6=21"))

# Actually recalculate: gridStart = Jan1 - WEEKDAY(Jan1,1) + 1
# WEEKDAY(Jan1 2024, 1) = 2 (Monday, Sun=1). gridStart = Jan1 - 2 + 1 = Dec 31.
# week1 = Dec31,Jan1,Jan2,Jan3,Jan4,Jan5,Jan6
# Dec31 is before Jan1 so 0. Jan1-6 are in month: 1+2+3+4+5+6 = 21
entries[-1]["expected_result"] = 21
entries[-1]["notes"] = "First week of Jan 2024: starts Sun(Dec31=0), Mon-Sat = 1-6. Sum=21"

# 14. A modernized version of the calendar concept using newer dynamic array functions
entries.append(e("nested_complex", "modern_calendar_month",
    '=LET(yr,2024,m,1,firstDay,DATE(yr,m,1),lastDay,EOMONTH(firstDay,0),daysInMonth,DAY(lastDay),offset,WEEKDAY(firstDay,1)-1,grid,SEQUENCE(42),dayVals,IF(AND(grid>offset,grid<=offset+daysInMonth),grid-offset,0),weekly,WRAPROWS(dayVals,7),SUM(INDEX(weekly,1,0)))',
    21, ["modern_calendar", "wraprows", "dynamic_array", "reddit_calendar"],
    ["LET", "DATE", "EOMONTH", "DAY", "WEEKDAY", "SEQUENCE", "IF", "AND", "WRAPROWS", "SUM", "INDEX"],
    operators=["-", "+", ">", "<="], let_bindings=7, complexity="expert",
    notes="Modern approach: SEQUENCE(42) for slots, offset by weekday, WRAPROWS into weeks. First row of Jan 2024: 0+1+2+3+4+5+6=21"))

# Write entries
with open(JSONL_PATH, "a", encoding="utf-8") as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

total = existing + len(entries)
print(f"Appended {len(entries)} entries (FTC-{existing+1:04d} to FTC-{total:04d})")
print(f"Total entries in file: {total}")
