#!/usr/bin/env python3
"""
Backfill generator for formula test corpus.
Adds ~374 entries (FTC-0627..FTC-1000) covering gaps in category targets
plus creative edge cases that push Excel's formula engine to its limits.

Dimensions explored:
- IEEE 754 / numeric boundary edge cases
- String extremes (length, encoding, coercion)
- Deep nesting and recursion limits
- LAMBDA as computational substrate (Y-combinator, Church encoding, SKI, CPS)
- Volatile/deterministic boundary
- Error propagation and cascade patterns
- Array shape edge cases (empty arrays, scalar-array coercion)
- Date system anomalies (Lotus 1900 bug, serial 0, rollover)
- Operator precedence traps
- Cross-type comparison semantics
"""

import json, os

JSONL_PATH = os.path.join(os.path.dirname(__file__), "..",
                          "reference", "test-corpus", "formula",
                          "single-cell", "formulas.jsonl")

# Count existing
with open(JSONL_PATH) as f:
    existing = sum(1 for _ in f)

seq = existing  # 0-based, so next entry is seq+1

def ftc(n):
    return f"FTC-{n:04d}"

def e(category, subcategory, formula, expected, tags,
      functions_exercised, complexity="basic",
      expected_type="number", expected_error=None,
      result_is_array=False, array_dimensions=None,
      let_bindings=0, deterministic=True,
      requires_locale=False, requires_date_system=None,
      operators=None, conformance=None, evidence=None,
      source_ids=None, provenance="authored",
      provenance_detail="AI-generated edge case for DnaCalc test corpus",
      notes=None):
    global seq
    seq += 1
    entry = {
        "test_id": ftc(seq),
        "formula": formula,
        "category": category,
        "subcategory": subcategory,
        "tags": tags,
        "complexity": complexity,
        "functions_exercised": functions_exercised,
        "operators_exercised": operators or [],
        "expected_result": expected,
        "expected_result_type": expected_type,
        "expected_error": expected_error,
        "result_is_array": result_is_array,
        "array_dimensions": array_dimensions,
        "let_bindings": let_bindings,
        "deterministic": deterministic,
        "requires_locale": requires_locale,
        "requires_date_system": requires_date_system,
        "conformance_req_ids": conformance or [],
        "evidence_ids": evidence or [],
        "source_ids": source_ids or [],
        "provenance": provenance,
        "provenance_detail": provenance_detail,
        "notes": notes
    }
    return entry

entries = []

# =============================================================================
# MATH_TRIG BACKFILL (+10)
# =============================================================================
entries.append(e("math_trig", "precision_boundary",
    '=ROUND(0.1+0.2, 15)', 0.3,
    ["ieee754", "precision", "classic_trap"],
    ["ROUND"], complexity="intermediate",
    operators=["+"],
    notes="Classic IEEE 754 trap: 0.1+0.2=0.30000000000000004; ROUND at 15 decimals"))

entries.append(e("math_trig", "large_number_arithmetic",
    '=(1E15+1)-1E15', 1.0,
    ["precision", "catastrophic_cancellation", "large_numbers"],
    [], operators=["+", "-"],
    notes="Tests precision at the edge of 15-digit significand"))

entries.append(e("math_trig", "large_number_precision_loss",
    '=(1E16+1)-1E16', 0.0,
    ["precision", "precision_loss", "ieee754"],
    [], operators=["+", "-"],
    notes="Beyond 15 digits: 1E16+1 loses the +1 entirely, result is 0 not 1"))

entries.append(e("math_trig", "denormalized_float",
    '=2.2250738585072014E-308/10', 2.225073858507201E-309,
    ["ieee754", "denormalized", "subnormal"],
    [], operators=["/"],
    notes="Division producing subnormal/denormalized float near minimum positive"))

entries.append(e("math_trig", "max_double",
    '=1.7976931348623157E+308*1', 1.7976931348623157E+308,
    ["ieee754", "max_value", "boundary"],
    [], operators=["*"],
    notes="Maximum finite double-precision value"))

entries.append(e("math_trig", "overflow_to_error",
    '=1.7976931348623157E+308*2', None,
    ["ieee754", "overflow", "num_error"],
    [], operators=["*"],
    expected_type="error", expected_error="#NUM!",
    notes="Overflow beyond MAX_DOUBLE produces #NUM!"))

entries.append(e("math_trig", "negative_zero",
    '=1/(-1E+308/1E+308)', -1.0,
    ["ieee754", "negative", "division"],
    [], operators=["/", "-"],
    notes="Intermediate step tests signed zero behavior; result is -1"))

entries.append(e("math_trig", "mod_negative",
    '=MOD(-7, 3)', 2,
    ["mod", "negative_dividend"],
    ["MOD"],
    notes="MOD with negative dividend: Excel returns non-negative remainder (differs from C % operator)"))

entries.append(e("math_trig", "power_fractional_negative",
    '=POWER(-8, 1/3)', None,
    ["power", "fractional_exponent", "negative_base"],
    ["POWER"], expected_type="error", expected_error="#NUM!",
    notes="Negative base with fractional exponent is #NUM! in Excel (no real cube root function)"))

entries.append(e("math_trig", "sumproduct_boolean_coercion",
    '=SUMPRODUCT(({1,2,3,4,5}>2)*{1,2,3,4,5})', 12,
    ["sumproduct", "boolean_coercion", "array"],
    ["SUMPRODUCT"], operators=["*", ">"],
    complexity="intermediate",
    notes="Boolean*number coercion inside SUMPRODUCT: (F,F,T,T,T)*(1,2,3,4,5) = 0+0+3+4+5=12"))

# =============================================================================
# TEXT_STRING BACKFILL (+34)
# =============================================================================
entries.append(e("text_string", "long_string_rept",
    '=LEN(REPT("A",32767))', 32767,
    ["long_string", "rept", "max_length"],
    ["LEN", "REPT"], complexity="intermediate",
    notes="Maximum string length in Excel: 32767 characters"))

entries.append(e("text_string", "rept_overflow",
    '=REPT("AB",16384)', None,
    ["long_string", "rept", "overflow"],
    ["REPT"], expected_type="error", expected_error="#VALUE!",
    notes="REPT producing >32767 chars (16384*2=32768) returns #VALUE!"))

entries.append(e("text_string", "char_null",
    '=CODE(CHAR(0))', 0,
    ["char", "null_character", "edge"],
    ["CODE", "CHAR"],
    notes="Null character CHAR(0) round-trip through CODE"))

entries.append(e("text_string", "unicode_emoji",
    '=LEN("😀")', 2,
    ["unicode", "emoji", "surrogate_pair"],
    ["LEN"],
    notes="Emoji is a surrogate pair in UTF-16, Excel LEN counts UTF-16 code units = 2"))

entries.append(e("text_string", "unicode_combining",
    '=LEN("é")', 2,
    ["unicode", "combining", "diacritical"],
    ["LEN"],
    notes="e + combining acute (U+0065 U+0301): LEN counts code units, not grapheme clusters"))

entries.append(e("text_string", "text_looks_like_number",
    '=ISNUMBER("123")', False,
    ["type_identity", "text_vs_number"],
    ["ISNUMBER"], expected_type="boolean",
    notes="String literal '123' is text, not number, even though it looks numeric"))

entries.append(e("text_string", "value_of_boolean_text",
    '=VALUE("TRUE")', None,
    ["value", "boolean_text", "error"],
    ["VALUE"], expected_type="error", expected_error="#VALUE!",
    notes="VALUE cannot parse the text 'TRUE' — it only parses numeric strings"))

entries.append(e("text_string", "text_comparison_case",
    '=EXACT("abc","ABC")', False,
    ["exact", "case_sensitive"],
    ["EXACT"], expected_type="boolean",
    notes="EXACT is case-sensitive unlike = operator"))

entries.append(e("text_string", "text_comparison_equal_case_insensitive",
    '="abc"="ABC"', True,
    ["comparison", "case_insensitive"],
    [], operators=["="], expected_type="boolean",
    notes="The = operator is case-INsensitive for strings in Excel"))

entries.append(e("text_string", "concat_number_coercion",
    '="Value: "&100', "Value: 100",
    ["concatenation", "coercion"],
    [], operators=["&"], expected_type="string",
    notes="& operator coerces number to text for concatenation"))

entries.append(e("text_string", "concat_boolean_coercion",
    '="Is: "&TRUE', "Is: TRUE",
    ["concatenation", "boolean_coercion"],
    [], operators=["&"], expected_type="string",
    notes="& operator coerces TRUE to text 'TRUE'"))

entries.append(e("text_string", "concat_error_propagation",
    '="X"&1/0', None,
    ["concatenation", "error_propagation"],
    [], operators=["&", "/"], expected_type="error", expected_error="#DIV/0!",
    notes="Error in & operand propagates"))

entries.append(e("text_string", "textjoin_with_arrays",
    '=TEXTJOIN(", ",TRUE,{"hello","","world"})', "hello, world",
    ["textjoin", "ignore_empty", "array"],
    ["TEXTJOIN"], expected_type="string", complexity="intermediate",
    notes="TEXTJOIN with ignore_empty=TRUE skips empty strings"))

entries.append(e("text_string", "substitute_all_occurrences",
    '=SUBSTITUTE("abcabc","a","X")', "XbcXbc",
    ["substitute", "global_replace"],
    ["SUBSTITUTE"], expected_type="string"))

entries.append(e("text_string", "substitute_nth_occurrence",
    '=SUBSTITUTE("abcabc","a","X",2)', "abcXbc",
    ["substitute", "nth_instance"],
    ["SUBSTITUTE"], expected_type="string",
    notes="4th arg limits replacement to the Nth occurrence"))

entries.append(e("text_string", "mid_beyond_length",
    '=MID("Hello",3,100)', "llo",
    ["mid", "beyond_length"],
    ["MID"], expected_type="string",
    notes="MID with num_chars exceeding remaining length returns what's available"))

entries.append(e("text_string", "find_not_found",
    '=FIND("z","Hello")', None,
    ["find", "not_found", "error"],
    ["FIND"], expected_type="error", expected_error="#VALUE!",
    notes="FIND returns #VALUE! when substring not found"))

entries.append(e("text_string", "text_format_fraction",
    '=TEXT(0.25,"# ?/?")', " 1/4",
    ["text_format", "fraction"],
    ["TEXT"], expected_type="string", complexity="intermediate",
    notes="TEXT formatting as fraction"))

entries.append(e("text_string", "text_format_scientific",
    '=TEXT(12345.6789,"0.00E+00")', "1.23E+04",
    ["text_format", "scientific"],
    ["TEXT"], expected_type="string"))

entries.append(e("text_string", "numbervalue_locale",
    '=NUMBERVALUE("1.234,56",",",".")', 1234.56,
    ["numbervalue", "locale", "decimal_separator"],
    ["NUMBERVALUE"], complexity="intermediate",
    notes="European format: comma=decimal, dot=group"))

entries.append(e("text_string", "textbefore_not_found",
    '=TEXTBEFORE("Hello","z")', None,
    ["textbefore", "not_found"],
    ["TEXTBEFORE"], expected_type="error", expected_error="#N/A",
    notes="TEXTBEFORE returns #N/A when delimiter not found"))

entries.append(e("text_string", "textafter_last",
    '=TEXTAFTER("a/b/c/d","/",-1)', "d",
    ["textafter", "last_occurrence"],
    ["TEXTAFTER"], expected_type="string",
    notes="Negative instance_num: search from end"))

entries.append(e("text_string", "textsplit_2d",
    '=INDEX(TEXTSPLIT("a.1,b.2,c.3",".","," ),2,2)', "2",
    ["textsplit", "2d_split", "index"],
    ["TEXTSPLIT", "INDEX"], expected_type="string", complexity="intermediate",
    result_is_array=False,
    notes="TEXTSPLIT with both col and row delimiters creates 2D array; INDEX picks element"))

entries.append(e("text_string", "char_concatenation_build",
    '=CHAR(72)&CHAR(101)&CHAR(108)&CHAR(108)&CHAR(111)', "Hello",
    ["char", "concatenation", "build_string"],
    ["CHAR"], operators=["&"], expected_type="string",
    notes="Building string character by character"))

entries.append(e("text_string", "nested_substitute",
    '=SUBSTITUTE(SUBSTITUTE(SUBSTITUTE("a1b2c3","a",""),"b",""),"c","")', "123",
    ["substitute", "nested", "strip_chars"],
    ["SUBSTITUTE"], expected_type="string", complexity="intermediate",
    notes="Nested SUBSTITUTE to strip multiple different characters"))

entries.append(e("text_string", "left_of_number",
    '=LEFT(12345,3)', "123",
    ["left", "number_coercion"],
    ["LEFT"], expected_type="string",
    notes="LEFT coerces number to text first, then takes left 3 chars"))

entries.append(e("text_string", "len_of_boolean",
    '=LEN(TRUE)', 4,
    ["len", "boolean_coercion"],
    ["LEN"],
    notes="LEN coerces TRUE to 'TRUE' (4 chars)"))

entries.append(e("text_string", "trim_internal_spaces",
    '=TRIM("  hello   world  ")', "hello world",
    ["trim", "internal_spaces"],
    ["TRIM"], expected_type="string",
    notes="TRIM removes leading/trailing AND collapses internal multiple spaces to single"))

entries.append(e("text_string", "clean_nonprintable",
    '=LEN(CLEAN(CHAR(1)&CHAR(2)&"hi"&CHAR(31)))', 2,
    ["clean", "nonprintable", "len"],
    ["CLEAN", "LEN", "CHAR"], operators=["&"],
    notes="CLEAN removes chars 0-31; only 'hi' remains"))

entries.append(e("text_string", "concat_vs_concatenate",
    '=CONCAT({"a","b","c"})', "abc",
    ["concat", "array_argument"],
    ["CONCAT"], expected_type="string",
    notes="CONCAT accepts arrays directly; CONCATENATE does not"))

entries.append(e("text_string", "upper_unicode",
    '=UPPER("straße")', "STRASSE",
    ["upper", "unicode", "german_eszett"],
    ["UPPER"], expected_type="string",
    notes="German ß uppercases to SS (or STRASSE) — locale-dependent behavior"))

entries.append(e("text_string", "search_wildcard",
    '=SEARCH("w*d","Hello world")', 7,
    ["search", "wildcard"],
    ["SEARCH"],
    notes="SEARCH supports wildcards; w*d finds 'world' starting at position 7"))

entries.append(e("text_string", "replace_vs_substitute",
    '=REPLACE("Hello",2,3,"XY")', "HXYo",
    ["replace", "positional"],
    ["REPLACE"], expected_type="string",
    notes="REPLACE is position-based: replace 3 chars starting at pos 2"))

entries.append(e("text_string", "valuetotext_formula_format",
    '=VALUETOTEXT({"a","b";"c","d"},1)', '{"a","b";"c","d"}',
    ["valuetotext", "array_format"],
    ["VALUETOTEXT"], expected_type="string", complexity="intermediate",
    notes="VALUETOTEXT with format=1 shows array in formula-friendly format"))

# =============================================================================
# STATISTICAL BACKFILL (+23)
# =============================================================================
entries.append(e("statistical", "stdev_single_value",
    '=STDEV({5})', None,
    ["stdev", "single_value", "div_zero"],
    ["STDEV"], expected_type="error", expected_error="#DIV/0!",
    notes="STDEV of single value is #DIV/0! (n-1 = 0)"))

entries.append(e("statistical", "stdevp_single_value",
    '=STDEV.P({5})', 0,
    ["stdevp", "single_value"],
    ["STDEV.P"],
    notes="STDEV.P of single value is 0 (population stdev)"))

entries.append(e("statistical", "average_mixed_types",
    '=AVERAGE({1,2,TRUE,"3",4})', 2.333333333333333,
    ["average", "mixed_types", "coercion"],
    ["AVERAGE"],
    notes="In array context, AVERAGE ignores TRUE and text '3', averages only 1,2,4 = 7/3"))

entries.append(e("statistical", "counta_vs_count",
    '=COUNTA({1,"hello",TRUE,2})-COUNT({1,"hello",TRUE,2})', 2,
    ["counta", "count", "type_counting"],
    ["COUNTA", "COUNT"], operators=["-"],
    notes="COUNTA counts all non-empty (4), COUNT counts only numbers (2), diff=2"))

entries.append(e("statistical", "countif_wildcard",
    '=COUNTIF({"apple","ape","application","banana"},"ap*")', 3,
    ["countif", "wildcard"],
    ["COUNTIF"], complexity="intermediate",
    notes="COUNTIF with wildcard ap* matches apple, ape, application"))

entries.append(e("statistical", "percentile_edge",
    '=PERCENTILE({1,2,3,4,5},0)', 1,
    ["percentile", "minimum"],
    ["PERCENTILE"],
    notes="PERCENTILE at 0th percentile = minimum value"))

entries.append(e("statistical", "percentile_edge_max",
    '=PERCENTILE({1,2,3,4,5},1)', 5,
    ["percentile", "maximum"],
    ["PERCENTILE"],
    notes="PERCENTILE at 100th percentile = maximum value"))

entries.append(e("statistical", "mode_no_repeats",
    '=MODE({1,2,3,4,5})', None,
    ["mode", "no_repeats", "na_error"],
    ["MODE"], expected_type="error", expected_error="#N/A",
    notes="MODE returns #N/A when no value repeats"))

entries.append(e("statistical", "geomean_with_zero",
    '=GEOMEAN({1,0,3})', None,
    ["geomean", "zero_value", "num_error"],
    ["GEOMEAN"], expected_type="error", expected_error="#NUM!",
    notes="GEOMEAN cannot handle zero values"))

entries.append(e("statistical", "harmean_negative",
    '=HARMEAN({1,-2,3})', None,
    ["harmean", "negative", "num_error"],
    ["HARMEAN"], expected_type="error", expected_error="#NUM!",
    notes="HARMEAN requires all positive values"))

entries.append(e("statistical", "trimmean_proportion",
    '=TRIMMEAN({1,2,3,4,5,6,7,8,9,100},0.2)', 5.5,
    ["trimmean", "outlier_removal"],
    ["TRIMMEAN"], complexity="intermediate",
    notes="TRIMMEAN 20%: trims 1 from each end (10% each side), averages 2..9 = 44/8 = 5.5"))

entries.append(e("statistical", "rank_tie_behavior",
    '=RANK(3,{1,3,3,5})', 2,
    ["rank", "tie"],
    ["RANK"],
    notes="RANK assigns same rank to ties, skips next"))

entries.append(e("statistical", "frequency_bins",
    '=SUM(FREQUENCY({1,2,3,4,5,6,7,8,9,10},{3,6,9}))', 10,
    ["frequency", "bins", "sum"],
    ["FREQUENCY", "SUM"], complexity="intermediate",
    result_is_array=False,
    notes="FREQUENCY returns array with counts per bin; SUM of all bin counts = total count"))

entries.append(e("statistical", "correl_perfect",
    '=CORREL({1,2,3,4,5},{2,4,6,8,10})', 1,
    ["correl", "perfect_correlation"],
    ["CORREL"],
    notes="Perfect positive linear correlation = 1.0"))

entries.append(e("statistical", "correl_perfect_negative",
    '=CORREL({1,2,3,4,5},{10,8,6,4,2})', -1,
    ["correl", "negative_correlation"],
    ["CORREL"],
    notes="Perfect negative linear correlation = -1.0"))

entries.append(e("statistical", "norm_dist_standard",
    '=ROUND(NORM.DIST(0,0,1,TRUE),4)', 0.5,
    ["normal_distribution", "cdf", "standard"],
    ["NORM.DIST", "ROUND"],
    notes="Standard normal CDF at 0 = exactly 0.5"))

entries.append(e("statistical", "norm_inv_standard",
    '=ROUND(NORM.INV(0.975,0,1),6)', 1.959964,
    ["normal_distribution", "inverse", "critical_value"],
    ["NORM.INV", "ROUND"],
    notes="The famous 1.96 critical value for 95% confidence"))

entries.append(e("statistical", "binom_dist_exact",
    '=ROUND(BINOM.DIST(5,10,0.5,FALSE),10)', 0.2460937500,
    ["binomial", "probability_mass"],
    ["BINOM.DIST", "ROUND"],
    notes="P(X=5) for Binomial(10,0.5) = C(10,5)*0.5^10"))

entries.append(e("statistical", "median_even_count",
    '=MEDIAN({1,2,3,4})', 2.5,
    ["median", "even_count", "interpolation"],
    ["MEDIAN"],
    notes="Median of even-count array is average of two middle values"))

entries.append(e("statistical", "large_vs_small",
    '=LARGE({10,20,30,40,50},2)+SMALL({10,20,30,40,50},2)', 60,
    ["large", "small", "combined"],
    ["LARGE", "SMALL"], operators=["+"],
    notes="2nd largest (40) + 2nd smallest (20) = 60"))

entries.append(e("statistical", "averageif_criteria",
    '=AVERAGEIF({1,2,3,4,5,6},">3")', 5,
    ["averageif", "criteria"],
    ["AVERAGEIF"],
    notes="Average of values >3: (4+5+6)/3 = 5"))

entries.append(e("statistical", "maxifs_with_array",
    '=LET(v,{10,20,30,40,50},c,{"a","b","a","b","a"},MAXIFS(v,c,"a"))', 50,
    ["maxifs", "criteria", "let"],
    ["LET", "MAXIFS"], let_bindings=2, complexity="intermediate",
    notes="MAXIFS: maximum of values where criteria='a' → max(10,30,50) = 50"))

entries.append(e("statistical", "minifs_with_array",
    '=LET(v,{10,20,30,40,50},c,{"a","b","a","b","a"},MINIFS(v,c,"b"))', 20,
    ["minifs", "criteria", "let"],
    ["LET", "MINIFS"], let_bindings=2, complexity="intermediate",
    notes="MINIFS: minimum of values where criteria='b' → min(20,40) = 20"))

# =============================================================================
# DATE_TIME BACKFILL (+27)
# =============================================================================
entries.append(e("date_time", "lotus_1900_bug",
    '=DATEVALUE("1900-02-29")', 60,
    ["1900_system", "lotus_bug", "nonexistent_date"],
    ["DATEVALUE"], requires_date_system="1900",
    notes="Feb 29, 1900 did NOT exist, but Excel serial 60 = this phantom date (Lotus compatibility)"))

entries.append(e("date_time", "serial_day_one",
    '=DATEVALUE("1900-01-01")', 1,
    ["1900_system", "epoch"],
    ["DATEVALUE"], requires_date_system="1900",
    notes="Jan 1, 1900 = serial 1 in 1900 date system"))

entries.append(e("date_time", "serial_zero",
    '=TEXT(0,"yyyy-mm-dd")', "1900-01-00",
    ["1900_system", "serial_zero", "edge"],
    ["TEXT"], expected_type="string", requires_date_system="1900",
    notes="Serial 0 formats as Jan 0, 1900 — a date that doesn't exist"))

entries.append(e("date_time", "date_month_rollover",
    '=MONTH(DATE(2024,13,1))', 1,
    ["date_construction", "month_rollover"],
    ["MONTH", "DATE"],
    notes="Month 13 rolls over to January of next year"))

entries.append(e("date_time", "date_day_rollover",
    '=DAY(DATE(2024,1,32))', 1,
    ["date_construction", "day_rollover"],
    ["DAY", "DATE"],
    notes="Day 32 of January rolls over to Feb 1"))

entries.append(e("date_time", "date_negative_month",
    '=MONTH(DATE(2024,-1,1))', 11,
    ["date_construction", "negative_month"],
    ["MONTH", "DATE"],
    notes="Month -1 goes back: month 0=Dec prev year, month -1=Nov prev year"))

entries.append(e("date_time", "date_negative_month_year",
    '=YEAR(DATE(2024,-1,1))', 2023,
    ["date_construction", "negative_month", "year_rollback"],
    ["YEAR", "DATE"],
    notes="Year rolls back when month goes negative"))

entries.append(e("date_time", "leap_year_2000",
    '=DAY(DATE(2000,2,29))', 29,
    ["leap_year", "century_exception"],
    ["DAY", "DATE"],
    notes="2000 IS a leap year (divisible by 400)"))

entries.append(e("date_time", "not_leap_year_1900",
    '=DAY(DATE(1900,3,0))', 28,
    ["leap_year", "1900_not_leap"],
    ["DAY", "DATE"], requires_date_system="1900",
    notes="1900 is NOT a real leap year; DATE(1900,3,0) = Feb 28 in reality. But Excel treats serial 60 as Feb 29..."))

entries.append(e("date_time", "datedif_years",
    '=DATEDIF("2020-01-15","2024-03-20","Y")', 4,
    ["datedif", "years"],
    ["DATEDIF"],
    notes="Complete years between dates"))

entries.append(e("date_time", "datedif_months",
    '=DATEDIF("2024-01-15","2024-04-10","M")', 2,
    ["datedif", "months"],
    ["DATEDIF"],
    notes="Complete months: Jan15→Apr10 = 2 complete months (not 3, since 10<15)"))

entries.append(e("date_time", "datedif_md",
    '=DATEDIF("2024-01-15","2024-04-10","MD")', 26,
    ["datedif", "days_ignore_months"],
    ["DATEDIF"],
    notes="Days ignoring months and years: 15th to 10th next month = wraps: Mar has 31 days, 31-15+10=26"))

entries.append(e("date_time", "weekday_default",
    '=WEEKDAY(DATE(2024,1,1))', 2,
    ["weekday", "return_type"],
    ["WEEKDAY", "DATE"],
    notes="Jan 1, 2024 is Monday; default return_type 1 → Sunday=1, Monday=2"))

entries.append(e("date_time", "weekday_iso",
    '=WEEKDAY(DATE(2024,1,1),2)', 1,
    ["weekday", "iso", "return_type"],
    ["WEEKDAY", "DATE"],
    notes="Return type 2: Monday=1; Jan 1, 2024 is Monday"))

entries.append(e("date_time", "isoweeknum_year_boundary",
    '=ISOWEEKNUM(DATE(2024,12,30))', 1,
    ["isoweeknum", "year_boundary"],
    ["ISOWEEKNUM", "DATE"],
    notes="Dec 30, 2024 belongs to ISO week 1 of 2025"))

entries.append(e("date_time", "eomonth_february",
    '=DAY(EOMONTH(DATE(2024,1,15),1))', 29,
    ["eomonth", "leap_year", "february"],
    ["DAY", "EOMONTH", "DATE"],
    notes="End of month 1 month after Jan 2024 = Feb 29, 2024 (leap year)"))

entries.append(e("date_time", "eomonth_negative",
    '=MONTH(EOMONTH(DATE(2024,3,15),-1))', 2,
    ["eomonth", "negative_offset"],
    ["MONTH", "EOMONTH", "DATE"],
    notes="EOMONTH with -1: end of previous month (Feb)"))

entries.append(e("date_time", "edate_boundary",
    '=DAY(EDATE(DATE(2024,1,31),1))', 29,
    ["edate", "month_end_adjustment"],
    ["DAY", "EDATE", "DATE"],
    notes="Jan 31 + 1 month: Feb doesn't have 31, adjusts to Feb 29 (2024 leap)"))

entries.append(e("date_time", "time_precision",
    '=ROUND(TIME(0,0,1)*86400,0)', 1,
    ["time", "serial_precision"],
    ["ROUND", "TIME"], operators=["*"],
    notes="1 second as time serial * seconds/day should give back 1"))

entries.append(e("date_time", "time_overflow",
    '=HOUR(TIME(25,0,0))', 1,
    ["time", "overflow"],
    ["HOUR", "TIME"],
    notes="TIME(25,0,0) wraps: 25 mod 24 = 1 hour"))

entries.append(e("date_time", "networkdays_holiday",
    '=NETWORKDAYS(DATE(2024,12,23),DATE(2024,12,27),DATE(2024,12,25))', 3,
    ["networkdays", "holidays"],
    ["NETWORKDAYS", "DATE"],
    notes="Mon-Fri week minus Christmas (Wed): Mon,Tue,Thu,Fri minus Xmas = Mon,Tue,Thu,Fri but Xmas excluded = 4-1=3. Wait: 23=Mon,24=Tue,25=Wed(excluded),26=Thu,27=Fri = 4 working days"))

# Fix the above — let me recalculate:
# Dec 23 Mon, Dec 24 Tue, Dec 25 Wed (holiday), Dec 26 Thu, Dec 27 Fri
# Working days: 23,24,26,27 = 4 days
entries[-1]["expected_result"] = 4
entries[-1]["notes"] = "Mon-Fri week: 23(Mon),24(Tue),25(Wed=holiday),26(Thu),27(Fri) = 4 working days"

entries.append(e("date_time", "yearfrac_actual",
    '=ROUND(YEARFRAC(DATE(2024,1,1),DATE(2024,7,1),1),6)', 0.498634,
    ["yearfrac", "actual_actual"],
    ["ROUND", "YEARFRAC", "DATE"],
    notes="Actual/actual basis: 182 days / 366 days (2024 leap) = 0.497268... Hmm let me recalculate"))

# Recalculate: Jan1 to Jul1 2024: Jan=31, Feb=29, Mar=31, Apr=30, May=31, Jun=30 = 182 days
# 2024 is leap, so 366 days. 182/366 = 0.49726775956...
entries[-1]["expected_result"] = 0.497268
entries[-1]["notes"] = "Actual/actual basis (1): 182 days / 366 (leap year) = 0.497268"

entries.append(e("date_time", "date_subtraction",
    '=DATE(2024,12,31)-DATE(2024,1,1)', 365,
    ["date_arithmetic", "subtraction"],
    ["DATE"], operators=["-"],
    notes="Days between Jan 1 and Dec 31 in leap year 2024 = 365 (366 days in year, but Dec31-Jan1 = 365)"))

entries.append(e("date_time", "date_comparison",
    '=DATE(2024,1,31)>DATE(2024,2,1)', False,
    ["date_comparison", "serial_comparison"],
    ["DATE"], operators=[">"], expected_type="boolean",
    notes="Jan 31 < Feb 1 when compared as serials"))

entries.append(e("date_time", "days_function",
    '=DAYS(DATE(2025,1,1),DATE(2024,1,1))', 366,
    ["days", "leap_year"],
    ["DAYS", "DATE"],
    notes="Days from Jan 1 2024 to Jan 1 2025 = 366 (2024 is leap)"))

entries.append(e("date_time", "workday_skip_weekend",
    '=WEEKDAY(WORKDAY(DATE(2024,1,5),1),2)', 1,
    ["workday", "skip_weekend"],
    ["WEEKDAY", "WORKDAY", "DATE"],
    notes="Jan 5 2024 = Friday; +1 workday = Monday; WEEKDAY Monday(type2)=1"))

# =============================================================================
# FINANCIAL BACKFILL (+28)
# =============================================================================
entries.append(e("financial", "pmt_standard",
    '=ROUND(PMT(0.05/12,360,200000),2)', -1073.64,
    ["pmt", "mortgage"],
    ["ROUND", "PMT"], operators=["/"],
    notes="30-year mortgage at 5%: monthly payment on $200k"))

entries.append(e("financial", "pmt_zero_rate",
    '=PMT(0,12,1200)', -100,
    ["pmt", "zero_interest"],
    ["PMT"],
    notes="Zero interest: simple division 1200/12 = 100, negative for payment"))

entries.append(e("financial", "fv_compound",
    '=ROUND(FV(0.06/12,120,-100),2)', 16387.93,
    ["fv", "compound_interest"],
    ["ROUND", "FV"], operators=["/"],
    notes="$100/month for 10 years at 6% annual"))

entries.append(e("financial", "pv_annuity",
    '=ROUND(PV(0.08,10,-1000),2)', 6710.08,
    ["pv", "annuity"],
    ["ROUND", "PV"],
    notes="Present value of $1000/year for 10 years at 8%"))

entries.append(e("financial", "nper_solve",
    '=ROUND(NPER(0.06/12,-500,0,25000),2)', 44.74,
    ["nper", "savings_goal"],
    ["ROUND", "NPER"], operators=["/"],
    notes="Months to save $25k at $500/month, 6% annual"))

entries.append(e("financial", "rate_solve",
    '=ROUND(RATE(360,-1000,180000)*12,6)', 0.046498,
    ["rate", "solve_for_rate"],
    ["ROUND", "RATE"], operators=["*"],
    complexity="intermediate",
    notes="Solve for annual rate: 360 payments of $1000 on $180k loan"))

entries.append(e("financial", "npv_positive",
    '=ROUND(NPV(0.1,{-1000,300,400,500,600}),2)', 352.07,
    ["npv", "cash_flows"],
    ["ROUND", "NPV"], complexity="intermediate",
    notes="NPV of cash flow series at 10% discount. Note: NPV starts discounting from period 1"))

entries.append(e("financial", "irr_standard",
    '=ROUND(IRR({-1000,300,400,500,600}),6)', 0.225217,
    ["irr", "internal_rate"],
    ["ROUND", "IRR"], complexity="intermediate",
    notes="IRR where NPV=0"))

entries.append(e("financial", "mirr_reinvest",
    '=ROUND(MIRR({-1000,300,400,500,600},0.1,0.12),6)', 0.210622,
    ["mirr", "reinvestment_rate"],
    ["ROUND", "MIRR"], complexity="intermediate",
    notes="Modified IRR with 10% finance rate and 12% reinvestment rate"))

entries.append(e("financial", "sln_depreciation",
    '=SLN(10000,1000,5)', 1800,
    ["sln", "depreciation"],
    ["SLN"],
    notes="Straight-line: (10000-1000)/5 = 1800"))

entries.append(e("financial", "ddb_first_period",
    '=ROUND(DDB(10000,1000,5,1),2)', 4000,
    ["ddb", "depreciation", "double_declining"],
    ["ROUND", "DDB"],
    notes="Double declining balance: 10000 * 2/5 = 4000 in period 1"))

entries.append(e("financial", "syd_depreciation",
    '=ROUND(SYD(10000,1000,5,1),2)', 3000,
    ["syd", "depreciation"],
    ["ROUND", "SYD"],
    notes="Sum-of-years-digits: (10000-1000)*5/15 = 3000 in period 1"))

entries.append(e("financial", "ppmt_first_payment",
    '=ROUND(PPMT(0.05/12,1,360,200000),2)', -240.31,
    ["ppmt", "principal_portion"],
    ["ROUND", "PPMT"], operators=["/"],
    notes="Principal portion of first mortgage payment"))

entries.append(e("financial", "ipmt_first_payment",
    '=ROUND(IPMT(0.05/12,1,360,200000),2)', -833.33,
    ["ipmt", "interest_portion"],
    ["ROUND", "IPMT"], operators=["/"],
    notes="Interest portion of first payment: 200000*0.05/12"))

entries.append(e("financial", "cumipmt_total",
    '=ROUND(CUMIPMT(0.05/12,360,200000,1,360,0),2)', -186511.57,
    ["cumipmt", "total_interest"],
    ["ROUND", "CUMIPMT"], operators=["/"], complexity="intermediate",
    notes="Total interest over 30-year mortgage at 5% on $200k"))

entries.append(e("financial", "effect_nominal_roundtrip",
    '=ROUND(EFFECT(NOMINAL(0.05,12),12),10)', 0.05,
    ["effect", "nominal", "roundtrip"],
    ["ROUND", "EFFECT", "NOMINAL"], complexity="intermediate",
    notes="EFFECT(NOMINAL(r,n),n) should return r — round-trip identity"))

entries.append(e("financial", "dollarde_conversion",
    '=DOLLARDE(1.02,16)', 1.125,
    ["dollarde", "fraction_conversion"],
    ["DOLLARDE"],
    notes="1 and 2/16ths = 1.125 decimal"))

entries.append(e("financial", "dollarfr_conversion",
    '=DOLLARFR(1.125,16)', 1.02,
    ["dollarfr", "fraction_conversion"],
    ["DOLLARFR"],
    notes="1.125 decimal = 1 and 2/16ths"))

entries.append(e("financial", "pduration_double",
    '=ROUND(PDURATION(0.05,1000,2000),6)', 14.206699,
    ["pduration", "doubling_time"],
    ["ROUND", "PDURATION"],
    notes="Time to double at 5%: ln(2)/ln(1.05) ≈ 14.2067"))

entries.append(e("financial", "rri_return",
    '=ROUND(RRI(10,1000,2000),6)', 0.071773,
    ["rri", "equivalent_rate"],
    ["ROUND", "RRI"],
    notes="Rate for 1000 to grow to 2000 in 10 periods: 2^(1/10)-1"))

entries.append(e("financial", "fv_with_pv_and_pmt",
    '=ROUND(FV(0.06/12,60,-200,-5000),2)', 19690.21,
    ["fv", "combined_pv_pmt"],
    ["ROUND", "FV"], operators=["/"], complexity="intermediate",
    notes="FV combining initial deposit ($5000) and monthly payments ($200) at 6%"))

entries.append(e("financial", "pv_perpetuity_approx",
    '=ROUND(PV(0.05,1000,-1),2)', 20.0,
    ["pv", "perpetuity", "approximation"],
    ["ROUND", "PV"],
    notes="PV of $1/period for 1000 periods at 5% ≈ $20 (perpetuity limit = 1/0.05 = 20)"))

entries.append(e("financial", "disc_treasury",
    '=ROUND(DISC(DATE(2024,1,1),DATE(2024,7,1),99,100,2),6)', 0.019802,
    ["disc", "treasury"],
    ["ROUND", "DISC", "DATE"],
    notes="Discount rate for bond bought at 99, redeemed at 100"))

entries.append(e("financial", "xnpv_irregular",
    '=ROUND(XNPV(0.1,{-1000,500,600},{DATE(2024,1,1),DATE(2024,7,1),DATE(2025,1,1)}),2)', 30.72,
    ["xnpv", "irregular_cashflows"],
    ["ROUND", "XNPV", "DATE"], complexity="advanced",
    notes="XNPV with irregular timing of cash flows"))

entries.append(e("financial", "db_depreciation",
    '=ROUND(DB(10000,1000,5,1),2)', 3690.00,
    ["db", "fixed_declining"],
    ["ROUND", "DB"],
    notes="Fixed-declining balance depreciation, period 1"))

entries.append(e("financial", "accrint_semiannual",
    '=ROUND(ACCRINT(DATE(2024,1,1),DATE(2024,7,1),DATE(2024,4,1),0.05,1000,2),2)', 12.36,
    ["accrint", "accrued_interest"],
    ["ROUND", "ACCRINT", "DATE"], complexity="intermediate",
    notes="Accrued interest for semiannual bond"))

entries.append(e("financial", "received_at_maturity",
    '=ROUND(RECEIVED(DATE(2024,1,1),DATE(2024,7,1),990,0.05,2),2)', 1015.46,
    ["received", "zero_coupon"],
    ["ROUND", "RECEIVED", "DATE"],
    notes="Amount received at maturity for investment at discount"))

entries.append(e("financial", "tbillyield_calculation",
    '=ROUND(TBILLYIELD(DATE(2024,1,1),DATE(2024,7,1),98),6)', 0.040268,
    ["tbillyield", "treasury_bill"],
    ["ROUND", "TBILLYIELD", "DATE"],
    notes="T-bill yield from purchase price"))

# =============================================================================
# LET_LAMBDA_FUNCTIONAL BACKFILL (+57) — HERE'S WHERE IT GETS WILD
# =============================================================================

# --- Y-Combinator: anonymous recursion ---
entries.append(e("let_lambda_functional", "y_combinator_factorial",
    '=LET(Y,LAMBDA(f,LAMBDA(n,IF(n<=1,1,n*f(f)(n-1)))),Y(Y)(6))', 720,
    ["y_combinator", "anonymous_recursion", "factorial"],
    ["LET", "LAMBDA", "IF"], operators=["*", "-", "<="],
    let_bindings=1, complexity="expert",
    notes="Y-combinator pattern: self-application f(f) enables recursion without named binding"))

entries.append(e("let_lambda_functional", "y_combinator_fibonacci",
    '=LET(Y,LAMBDA(f,LAMBDA(n,IF(n<=1,n,f(f)(n-1)+f(f)(n-2)))),Y(Y)(10))', 55,
    ["y_combinator", "fibonacci", "anonymous_recursion"],
    ["LET", "LAMBDA", "IF"], operators=["+", "-", "<="],
    let_bindings=1, complexity="expert",
    notes="Fibonacci via Y-combinator — exponential blowup but works for small n"))

# --- Church Encoding: numbers as functions ---
entries.append(e("let_lambda_functional", "church_numerals",
    '=LET(ZERO,LAMBDA(f,LAMBDA(x,x)),SUCC,LAMBDA(n,LAMBDA(f,LAMBDA(x,f(n(f)(x))))),ADD,LAMBDA(m,LAMBDA(n,LAMBDA(f,LAMBDA(x,m(f)(n(f)(x)))))),toNum,LAMBDA(n,n(LAMBDA(x,x+1))(0)),two,SUCC(SUCC(ZERO)),three,SUCC(two),five,ADD(two)(three),toNum(five))', 5,
    ["church_encoding", "numerals", "functional_programming"],
    ["LET", "LAMBDA"], operators=["+"],
    let_bindings=7, complexity="expert",
    notes="Church numerals: numbers encoded as functions. ZERO=λf.λx.x, SUCC=λn.λf.λx.f(n f x), ADD=λm.λn.λf.λx.m f (n f x). Decoded via toNum."))

entries.append(e("let_lambda_functional", "church_multiplication",
    '=LET(ZERO,LAMBDA(f,LAMBDA(x,x)),SUCC,LAMBDA(n,LAMBDA(f,LAMBDA(x,f(n(f)(x))))),MUL,LAMBDA(m,LAMBDA(n,LAMBDA(f,m(n(f))))),toNum,LAMBDA(n,n(LAMBDA(x,x+1))(0)),two,SUCC(SUCC(ZERO)),three,SUCC(SUCC(SUCC(ZERO))),six,MUL(two)(three),toNum(six))', 6,
    ["church_encoding", "multiplication", "higher_order"],
    ["LET", "LAMBDA"], operators=["+"],
    let_bindings=7, complexity="expert",
    notes="Church multiplication: MUL=λm.λn.λf.m(n f) — compose n's successor m times"))

# --- SKI Combinator Calculus ---
entries.append(e("let_lambda_functional", "ski_combinators",
    '=LET(S,LAMBDA(x,LAMBDA(y,LAMBDA(z,x(z)(y(z))))),K,LAMBDA(x,LAMBDA(y,x)),I,LAMBDA(x,x),S(K)(K)(42))', 42,
    ["ski_calculus", "combinators", "theoretical_cs"],
    ["LET", "LAMBDA"],
    let_bindings=3, complexity="expert",
    notes="SKI combinator calculus in Excel! S(K)(K) reduces to I (identity). S x y z = xz(yz), K x y = x, I x = x"))

# --- Continuation-Passing Style ---
entries.append(e("let_lambda_functional", "cps_factorial",
    '=LET(factCPS,LAMBDA(self,LAMBDA(n,LAMBDA(k,IF(n<=1,k(1),self(self)(n-1)(LAMBDA(r,k(n*r))))))),factCPS(factCPS)(5)(LAMBDA(x,x)))', 120,
    ["continuation_passing", "cps", "factorial"],
    ["LET", "LAMBDA", "IF"], operators=["*", "-", "<="],
    let_bindings=1, complexity="expert",
    notes="Continuation-passing style: instead of returning, passes result to continuation k. Identity continuation LAMBDA(x,x) extracts final value."))

# --- Currying and Partial Application ---
entries.append(e("let_lambda_functional", "currying",
    '=LET(add,LAMBDA(a,LAMBDA(b,a+b)),add5,add(5),add5(3))', 8,
    ["currying", "partial_application"],
    ["LET", "LAMBDA"], operators=["+"],
    let_bindings=2, complexity="intermediate",
    notes="Currying: add returns a function; add5 is a partially applied function"))

entries.append(e("let_lambda_functional", "function_composition_pipe",
    '=LET(pipe,LAMBDA(f,LAMBDA(g,LAMBDA(x,g(f(x))))),double,LAMBDA(x,x*2),inc,LAMBDA(x,x+1),double_then_inc,pipe(double)(inc),double_then_inc(5))', 11,
    ["composition", "pipe", "higher_order"],
    ["LET", "LAMBDA"], operators=["*", "+"],
    let_bindings=4, complexity="intermediate",
    notes="Function composition (pipe): double(5)=10, then inc(10)=11"))

entries.append(e("let_lambda_functional", "compose_three",
    '=LET(comp,LAMBDA(f,LAMBDA(g,LAMBDA(x,f(g(x))))),sq,LAMBDA(x,x*x),dbl,LAMBDA(x,x*2),neg,LAMBDA(x,-x),comp(sq)(comp(dbl)(neg))(3))', 36,
    ["composition", "triple", "higher_order"],
    ["LET", "LAMBDA"], operators=["*", "-"],
    let_bindings=4, complexity="advanced",
    notes="Triple composition: neg(3)=-3, dbl(-3)=-6, sq(-6)=36"))

# --- Fixed-point iteration ---
entries.append(e("let_lambda_functional", "newton_sqrt",
    '=LET(step,LAMBDA(self,LAMBDA(x,LAMBDA(n,IF(n=0,x,self(self)((x+2/x)/2)(n-1))))),step(step)(1)(10))', 1.414213562373095,
    ["newton_method", "sqrt", "iteration"],
    ["LET", "LAMBDA", "IF"], operators=["+", "/", "-", "="],
    let_bindings=1, complexity="expert",
    notes="Newton's method for sqrt(2): x_{n+1} = (x + 2/x)/2, 10 iterations from x=1"))

# --- Functional data structures ---
entries.append(e("let_lambda_functional", "pair_cons_car_cdr",
    '=LET(CONS,LAMBDA(a,LAMBDA(b,LAMBDA(sel,IF(sel=0,a,b)))),CAR,LAMBDA(p,p(0)),CDR,LAMBDA(p,p(1)),pair,CONS(10)(20),CAR(pair)+CDR(pair))', 30,
    ["pair", "cons_car_cdr", "data_structure"],
    ["LET", "LAMBDA", "IF"], operators=["+", "="],
    let_bindings=4, complexity="advanced",
    notes="Lisp-style CONS/CAR/CDR pairs encoded as closures"))

entries.append(e("let_lambda_functional", "linked_list",
    '=LET(NIL,0,CONS,LAMBDA(h,LAMBDA(t,LAMBDA(sel,IF(sel=0,h,t)))),HEAD,LAMBDA(p,p(0)),TAIL,LAMBDA(p,p(1)),ISNIL,LAMBDA(p,p=0),lst,CONS(3)(CONS(2)(CONS(1)(NIL))),HEAD(lst)+HEAD(TAIL(lst))+HEAD(TAIL(TAIL(lst))))', 6,
    ["linked_list", "functional_data_structure"],
    ["LET", "LAMBDA", "IF"], operators=["+", "="],
    let_bindings=6, complexity="expert",
    notes="Linked list as nested closures: (3 → (2 → (1 → NIL))). Sum=3+2+1=6"))

# --- State machine via REDUCE ---
entries.append(e("let_lambda_functional", "state_machine_reduce",
    '=LET(transitions,{1,0,1,1,0},final,REDUCE(0,transitions,LAMBDA(state,input,IF(AND(state=0,input=1),1,IF(AND(state=1,input=0),0,state)))),final)', 0,
    ["state_machine", "reduce", "automaton"],
    ["LET", "REDUCE", "LAMBDA", "IF", "AND"],
    let_bindings=2, complexity="advanced",
    notes="Simple 2-state automaton via REDUCE: state 0+input 1→state 1, state 1+input 0→state 0. Sequence {1,0,1,1,0}: 0→1→0→1→1→0"))

# --- Memoized computation via SCAN ---
entries.append(e("let_lambda_functional", "fibonacci_scan",
    '=LET(n,10,fibs,SCAN(1,SEQUENCE(n-1),LAMBDA(acc,i,IF(i<=1,1,INDEX(SCAN(1,SEQUENCE(i-1),LAMBDA(a,j,IF(j<=1,1,0))),i-1)))),INDEX(fibs,n-1))', None,
    ["fibonacci", "scan", "memoization_attempt"],
    ["LET", "SCAN", "SEQUENCE", "LAMBDA", "IF", "INDEX"],
    let_bindings=2, complexity="expert",
    notes="Fibonacci attempt via SCAN — tests engine's handling of nested SCAN. May not work in all implementations."))
# Actually that's too complex and probably wrong. Let me use a simpler approach:

# Remove that last one and replace with correct fibonacci via pairs
entries.pop()
seq -= 1

entries.append(e("let_lambda_functional", "fibonacci_reduce_pair",
    '=LET(n,10,result,REDUCE({0,1},SEQUENCE(n-1),LAMBDA(pair,_,LET(a,INDEX(pair,1),b,INDEX(pair,2),HSTACK(b,a+b)))),INDEX(result,2))', 55,
    ["fibonacci", "reduce", "pair_accumulator"],
    ["LET", "REDUCE", "SEQUENCE", "LAMBDA", "INDEX", "HSTACK"],
    operators=["+"], let_bindings=5, complexity="advanced",
    notes="Fibonacci via REDUCE with pair accumulator: carry {F(n-1), F(n)} → {F(n), F(n+1)}"))

# --- pbartxl-style THUNK pattern ---
entries.append(e("let_lambda_functional", "thunk_deferred_evaluation",
    '=LET(THUNK,LAMBDA(val,LAMBDA(val)),force,LAMBDA(t,t()),expensive,THUNK(SUM(SEQUENCE(100))),force(expensive))', 5050,
    ["thunk", "deferred_evaluation", "pbartxl"],
    ["LET", "LAMBDA", "SUM", "SEQUENCE"],
    let_bindings=3, complexity="advanced",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="THUNK pattern adapted from pbartxl gist techniques",
    notes="THUNK wraps a value in a zero-arg lambda for deferred evaluation"))

# --- Monadic error handling ---
entries.append(e("let_lambda_functional", "maybe_monad",
    '=LET(Just,LAMBDA(v,LAMBDA(f,f(v))),Nothing,LAMBDA(f,NA()),bind,LAMBDA(m,LAMBDA(f,IFERROR(m(f),NA()))),safeDiv,LAMBDA(a,LAMBDA(b,IF(b=0,Nothing,Just(a/b)))),result,bind(safeDiv(10)(2))(LAMBDA(x,Just(x*3))),result(LAMBDA(x,x)))', 15,
    ["maybe_monad", "error_handling", "functional"],
    ["LET", "LAMBDA", "IF", "IFERROR", "NA"], operators=["/", "*", "="],
    let_bindings=4, complexity="expert",
    notes="Maybe monad in Excel: Just wraps a value, Nothing returns NA(). bind chains operations, short-circuiting on Nothing. 10/2=5, *3=15"))

# --- Higher-order: map over array ---
entries.append(e("let_lambda_functional", "manual_map",
    '=LET(arr,{1,2,3,4,5},fn,LAMBDA(x,x*x+1),SUM(MAP(arr,fn)))', 60,
    ["map", "higher_order", "sum"],
    ["LET", "MAP", "LAMBDA", "SUM"], operators=["*", "+"],
    let_bindings=2, complexity="intermediate",
    notes="MAP applies fn to each element: {2,5,10,17,26}, sum=60"))

entries.append(e("let_lambda_functional", "reduce_string_concat",
    '=REDUCE("",{"H","e","l","l","o"},LAMBDA(acc,ch,acc&ch))', "Hello",
    ["reduce", "string_building"],
    ["REDUCE", "LAMBDA"], operators=["&"],
    expected_type="string", complexity="intermediate",
    notes="REDUCE to concatenate array of characters into string"))

entries.append(e("let_lambda_functional", "scan_running_product",
    '=SUM(SCAN(1,{2,3,4,5},LAMBDA(acc,x,acc*x)))', 154,
    ["scan", "running_product"],
    ["SUM", "SCAN", "LAMBDA"], operators=["*"],
    complexity="intermediate",
    notes="Running product: {2,6,24,120}, sum=2+6+24+120=152. Wait: SCAN includes initial? No, SCAN returns {f(1,2), f(2,3),...} = {1*2, 2*3, 6*4, 24*5} = {2, 6, 24, 120}, sum=152"))

# Fix
entries[-1]["expected_result"] = 152
entries[-1]["notes"] = "Running product via SCAN: {2,6,24,120}, sum=152"

entries.append(e("let_lambda_functional", "makearray_multiplication_table",
    '=SUM(MAKEARRAY(3,3,LAMBDA(r,c,r*c)))', 36,
    ["makearray", "multiplication_table"],
    ["SUM", "MAKEARRAY", "LAMBDA"], operators=["*"],
    complexity="intermediate",
    notes="3x3 multiplication table: {1,2,3;2,4,6;3,6,9}, sum=36"))

entries.append(e("let_lambda_functional", "byrow_sum_each",
    '=SUM(BYROW({1,2,3;4,5,6;7,8,9},LAMBDA(r,MAX(r))))', 24,
    ["byrow", "row_max"],
    ["SUM", "BYROW", "LAMBDA", "MAX"],
    complexity="intermediate",
    notes="MAX of each row: {3,6,9}, sum=18. Wait: max(1,2,3)=3, max(4,5,6)=6, max(7,8,9)=9, sum=18"))

# Fix
entries[-1]["expected_result"] = 18
entries[-1]["notes"] = "MAX of each row: {3,6,9}, sum=18"

entries.append(e("let_lambda_functional", "bycol_product",
    '=SUM(BYCOL({1,2,3;4,5,6},LAMBDA(c,PRODUCT(c))))', 48,
    ["bycol", "column_product"],
    ["SUM", "BYCOL", "LAMBDA", "PRODUCT"],
    complexity="intermediate",
    notes="Product of each column: {1*4, 2*5, 3*6} = {4, 10, 18}, sum=32"))

# Fix: 4+10+18=32
entries[-1]["expected_result"] = 32
entries[-1]["notes"] = "Product of each column: {4,10,18}, sum=32"

entries.append(e("let_lambda_functional", "lambda_returning_lambda",
    '=LET(adder,LAMBDA(n,LAMBDA(x,x+n)),add3,adder(3),add7,adder(7),add3(10)+add7(10))', 30,
    ["closure", "factory", "returning_lambda"],
    ["LET", "LAMBDA"], operators=["+"],
    let_bindings=3, complexity="advanced",
    notes="Function factory: adder(3) returns λx.x+3; 13+17=30"))

entries.append(e("let_lambda_functional", "recursive_gcd_euclid",
    '=LET(gcd,LAMBDA(self,LAMBDA(a,LAMBDA(b,IF(b=0,a,self(self)(b)(MOD(a,b)))))),gcd(gcd)(252)(105))', 21,
    ["recursion", "gcd", "euclid"],
    ["LET", "LAMBDA", "IF", "MOD"], operators=["="],
    let_bindings=1, complexity="advanced",
    notes="Euclidean GCD via recursive LAMBDA: gcd(252,105)=gcd(105,42)=gcd(42,21)=gcd(21,0)=21"))

entries.append(e("let_lambda_functional", "recursive_sum_digits",
    '=LET(sumDig,LAMBDA(self,LAMBDA(n,IF(n<10,n,MOD(n,10)+self(self)(INT(n/10))))),sumDig(sumDig)(9876))', 30,
    ["recursion", "digit_sum"],
    ["LET", "LAMBDA", "IF", "MOD", "INT"], operators=["+", "/", "<"],
    let_bindings=1, complexity="advanced",
    notes="Recursive digit sum: 9+8+7+6=30"))

entries.append(e("let_lambda_functional", "recursive_power",
    '=LET(pow,LAMBDA(self,LAMBDA(b,LAMBDA(e,IF(e=0,1,b*self(self)(b)(e-1))))),pow(pow)(2)(10))', 1024,
    ["recursion", "power", "exponentiation"],
    ["LET", "LAMBDA", "IF"], operators=["*", "-", "="],
    let_bindings=1, complexity="advanced",
    notes="Recursive exponentiation: 2^10=1024"))

entries.append(e("let_lambda_functional", "recursive_reverse_string",
    '=LET(rev,LAMBDA(self,LAMBDA(s,IF(LEN(s)<=1,s,self(self)(MID(s,2,LEN(s)-1))&LEFT(s,1)))),rev(rev)("Hello"))', "olleH",
    ["recursion", "string_reverse"],
    ["LET", "LAMBDA", "IF", "LEN", "MID", "LEFT"], operators=["&", "-", "<="],
    let_bindings=1, complexity="advanced", expected_type="string",
    notes="Recursive string reversal via LAMBDA"))

entries.append(e("let_lambda_functional", "recursive_binary",
    '=LET(toBin,LAMBDA(self,LAMBDA(n,IF(n<=1,TEXT(n,"0"),self(self)(INT(n/2))&TEXT(MOD(n,2),"0")))),toBin(toBin)(42))', "101010",
    ["recursion", "binary_conversion"],
    ["LET", "LAMBDA", "IF", "TEXT", "INT", "MOD"], operators=["&", "/", "<="],
    let_bindings=1, complexity="advanced", expected_type="string",
    notes="Recursive decimal to binary: 42 = 101010"))

entries.append(e("let_lambda_functional", "recursive_collatz_length",
    '=LET(collatz,LAMBDA(self,LAMBDA(n,IF(n=1,0,1+IF(MOD(n,2)=0,self(self)(n/2),self(self)(3*n+1))))),collatz(collatz)(27))', 111,
    ["recursion", "collatz", "conjecture"],
    ["LET", "LAMBDA", "IF", "MOD"], operators=["+", "*", "/", "="],
    let_bindings=1, complexity="expert",
    notes="Collatz sequence length for 27 (famously long: 111 steps to reach 1)"))

entries.append(e("let_lambda_functional", "recursive_ackermann_small",
    '=LET(ack,LAMBDA(self,LAMBDA(m,LAMBDA(n,IF(m=0,n+1,IF(n=0,self(self)(m-1)(1),self(self)(m-1)(self(self)(m)(n-1))))))),ack(ack)(2)(3))', 9,
    ["recursion", "ackermann", "computability"],
    ["LET", "LAMBDA", "IF"], operators=["+", "-", "="],
    let_bindings=1, complexity="expert",
    notes="Ackermann function A(2,3)=9. Grows faster than any primitive recursive function. A(3,n) already huge."))

# --- pbartxl-style dictionary pattern ---
entries.append(e("let_lambda_functional", "dictionary_get",
    '=LET(dict,LAMBDA(key,SWITCH(key,"name","Alice","age",30,"city","NYC",NA())),dict("age"))', 30,
    ["dictionary", "switch_pattern", "pbartxl"],
    ["LET", "LAMBDA", "SWITCH", "NA"],
    let_bindings=1, complexity="intermediate",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="Dictionary pattern inspired by pbartxl functional techniques",
    notes="Dictionary as LAMBDA+SWITCH: O(1) lookup by key"))

entries.append(e("let_lambda_functional", "dictionary_keys",
    '=LET(KEYS,LAMBDA(dict,FILTER({"name","age","city"},NOT(ISERROR(MAP({"name","age","city"},dict))))),dict,LAMBDA(key,SWITCH(key,"name","Alice","age",30,NA())),COLUMNS(KEYS(dict)))', 2,
    ["dictionary", "keys", "filter", "pbartxl"],
    ["LET", "LAMBDA", "FILTER", "NOT", "ISERROR", "MAP", "SWITCH", "NA", "COLUMNS"],
    let_bindings=2, complexity="expert",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="Dictionary keys extraction adapted from pbartxl techniques",
    notes="Extract valid keys from dictionary by testing each against NA error"))

# --- Functional pipeline / applicative ---
entries.append(e("let_lambda_functional", "pipeline_operator_simulation",
    '=LET(pipe3,LAMBDA(v,f1,f2,f3,f3(f2(f1(v)))),sq,LAMBDA(x,x*x),neg,LAMBDA(x,-x),inc,LAMBDA(x,x+1),pipe3(4,sq,neg,inc))', -15,
    ["pipeline", "function_chaining"],
    ["LET", "LAMBDA"], operators=["*", "-", "+"],
    let_bindings=4, complexity="advanced",
    notes="Pipeline simulation: 4 → sq(4)=16 → neg(16)=-16 → inc(-16)=-15"))

# --- ISOMITTED for optional parameters ---
entries.append(e("let_lambda_functional", "isomitted_default",
    '=LET(greet,LAMBDA(name,[greeting],LET(g,IF(ISOMITTED(greeting),"Hello",greeting),g&", "&name&"!")),greet("World"))', "Hello, World!",
    ["isomitted", "optional_params", "default_values"],
    ["LET", "LAMBDA", "IF", "ISOMITTED"], operators=["&"],
    let_bindings=2, complexity="intermediate", expected_type="string",
    notes="ISOMITTED enables optional parameters with defaults"))

entries.append(e("let_lambda_functional", "isomitted_provided",
    '=LET(greet,LAMBDA(name,[greeting],LET(g,IF(ISOMITTED(greeting),"Hello",greeting),g&", "&name&"!")),greet("World","Hola"))', "Hola, World!",
    ["isomitted", "optional_params"],
    ["LET", "LAMBDA", "IF", "ISOMITTED"], operators=["&"],
    let_bindings=2, complexity="intermediate", expected_type="string",
    notes="ISOMITTED with explicit argument provided"))

# --- REDUCE as universal loop ---
entries.append(e("let_lambda_functional", "reduce_max",
    '=REDUCE(-1E+308,{5,3,8,1,9,2},LAMBDA(best,x,IF(x>best,x,best)))', 9,
    ["reduce", "maximum", "loop_pattern"],
    ["REDUCE", "LAMBDA", "IF"], operators=[">"],
    notes="Manual MAX via REDUCE — demonstrates REDUCE as universal loop"))

entries.append(e("let_lambda_functional", "reduce_count_if",
    '=REDUCE(0,{1,5,3,8,2,9,4,7},LAMBDA(cnt,x,cnt+IF(x>4,1,0)))', 4,
    ["reduce", "count_if", "conditional_accumulator"],
    ["REDUCE", "LAMBDA", "IF"], operators=["+", ">"],
    notes="Count elements >4 via REDUCE: {5,8,9,7} = 4 items"))

entries.append(e("let_lambda_functional", "reduce_flatten_strings",
    '=REDUCE("",{"a","b","c","d"},LAMBDA(acc,x,IF(acc="",x,acc&"-"&x)))', "a-b-c-d",
    ["reduce", "string_join"],
    ["REDUCE", "LAMBDA", "IF"], operators=["&", "="],
    expected_type="string",
    notes="String join with separator via REDUCE"))

# --- Deeply nested LET ---
entries.append(e("let_lambda_functional", "deep_let_chain",
    '=LET(a,1,b,a+1,c,b+1,d,c+1,e,d+1,f,e+1,g,f+1,h,g+1,i,h+1,j,i+1,j)', 10,
    ["let", "deep_chain", "sequential"],
    ["LET"], operators=["+"],
    let_bindings=10, complexity="intermediate",
    notes="10-deep LET chain, each binding referencing the previous"))

entries.append(e("let_lambda_functional", "let_shadow_binding",
    '=LET(x,10,y,LET(x,20,x+5),x+y)', 35,
    ["let", "shadowing", "scope"],
    ["LET"], operators=["+"],
    let_bindings=3, complexity="intermediate",
    notes="Inner LET shadows x=20, outer x=10. y=25, result=10+25=35"))

# --- MAP with complex transformations ---
entries.append(e("let_lambda_functional", "map_conditional",
    '=TEXTJOIN(",",TRUE,MAP({1,2,3,4,5,6},LAMBDA(x,IF(MOD(x,2)=0,"even","odd"))))', "odd,even,odd,even,odd,even",
    ["map", "conditional", "textjoin"],
    ["TEXTJOIN", "MAP", "LAMBDA", "IF", "MOD"], operators=["="],
    expected_type="string", complexity="intermediate",
    notes="MAP with conditional classification"))

entries.append(e("let_lambda_functional", "map_nested_lambda",
    '=SUM(MAP({1,2,3},LAMBDA(x,SUM(MAP({10,20,30},LAMBDA(y,x*y))))))', 360,
    ["map", "nested", "cartesian"],
    ["SUM", "MAP", "LAMBDA"], operators=["*"],
    complexity="advanced",
    notes="Nested MAP = cartesian product: each x maps over all y. 1*(60)+2*(60)+3*(60) = 60+120+180=360"))

# --- Closures capturing mutable state (accumulator) ---
entries.append(e("let_lambda_functional", "reduce_running_average",
    '=LET(data,{10,20,30,40,50},n,COLUMNS(data),result,REDUCE({0,0},data,LAMBDA(acc,x,LET(s,INDEX(acc,1)+x,c,INDEX(acc,2)+1,HSTACK(s,c)))),INDEX(result,1)/INDEX(result,2))', 30,
    ["reduce", "running_average", "pair_accumulator"],
    ["LET", "REDUCE", "LAMBDA", "INDEX", "HSTACK", "COLUMNS"],
    operators=["+", "/"], let_bindings=4, complexity="advanced",
    notes="Running sum and count in a pair accumulator, final division gives average=30"))

# --- pbartxl IDENT and composition ---
entries.append(e("let_lambda_functional", "ident_lambda",
    '=LET(IDENT,LAMBDA(x,x),IDENT(42))', 42,
    ["identity", "basic", "pbartxl"],
    ["LET", "LAMBDA"],
    let_bindings=1, complexity="basic",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="Identity combinator from pbartxl functional patterns"))

entries.append(e("let_lambda_functional", "const_combinator",
    '=LET(CONST,LAMBDA(a,LAMBDA(b,a)),always5,CONST(5),always5(99))', 5,
    ["const", "combinator", "k_combinator"],
    ["LET", "LAMBDA"],
    let_bindings=2, complexity="intermediate",
    notes="K combinator / CONST: always returns first argument regardless of second"))

entries.append(e("let_lambda_functional", "flip_combinator",
    '=LET(FLIP,LAMBDA(f,LAMBDA(a,LAMBDA(b,f(b)(a)))),sub,LAMBDA(a,LAMBDA(b,a-b)),rsub,FLIP(sub),rsub(3)(10))', 7,
    ["flip", "combinator", "argument_reversal"],
    ["LET", "LAMBDA"], operators=["-"],
    let_bindings=3, complexity="advanced",
    notes="FLIP reverses argument order: rsub(3)(10) = sub(10)(3) = 10-3 = 7"))

entries.append(e("let_lambda_functional", "twice_combinator",
    '=LET(TWICE,LAMBDA(f,LAMBDA(x,f(f(x)))),dbl,LAMBDA(x,x*2),TWICE(dbl)(3))', 12,
    ["twice", "combinator", "self_composition"],
    ["LET", "LAMBDA"], operators=["*"],
    let_bindings=2, complexity="intermediate",
    notes="TWICE applies a function twice: dbl(dbl(3)) = dbl(6) = 12"))

entries.append(e("let_lambda_functional", "power_combinator",
    '=LET(POW,LAMBDA(self,LAMBDA(f,LAMBDA(n,LAMBDA(x,IF(n=0,x,f(self(self)(f)(n-1)(x))))))),triple,LAMBDA(x,x*3),POW(POW)(triple)(4)(1))', 81,
    ["power_combinator", "iterated_application"],
    ["LET", "LAMBDA", "IF"], operators=["*", "-", "="],
    let_bindings=2, complexity="expert",
    notes="Apply function n times: triple^4(1) = 3^4 = 81"))

# --- LAMBDA with error handling patterns ---
entries.append(e("let_lambda_functional", "tryCatch_pattern",
    '=LET(tryCatch,LAMBDA(expr,fallback,IFERROR(expr,fallback)),tryCatch(1/0,-1))', -1,
    ["error_handling", "try_catch"],
    ["LET", "LAMBDA", "IFERROR"], operators=["/"],
    let_bindings=1, complexity="intermediate",
    notes="Try-catch pattern via IFERROR wrapped in LAMBDA"))

entries.append(e("let_lambda_functional", "safe_chain",
    '=LET(safe,LAMBDA(f,LAMBDA(x,IFERROR(f(x),NA()))),double,LAMBDA(x,x*2),safeDouble,safe(double),IFERROR(safeDouble("abc"),"caught"))', "caught",
    ["error_handling", "safe_wrapper", "higher_order"],
    ["LET", "LAMBDA", "IFERROR", "NA"], operators=["*"],
    let_bindings=3, complexity="advanced", expected_type="string",
    notes="safe() wraps any function in error handling. 'abc'*2 = #VALUE!, caught by safe"))

# --- Complex LAMBDA patterns from pbartxl ---
entries.append(e("let_lambda_functional", "pbartxl_scanv",
    '=LET(SCANv,LAMBDA(init,arr,fn,REDUCE(init,arr,LAMBDA(acc,x,HSTACK(acc,fn(INDEX(acc,COLUMNS(acc)),x))))),result,SCANv(0,{1,2,3,4,5},LAMBDA(prev,x,prev+x)),SUM(result))', 35,
    ["scanv", "running_sum", "pbartxl"],
    ["LET", "LAMBDA", "REDUCE", "HSTACK", "INDEX", "COLUMNS", "SUM"],
    operators=["+"], let_bindings=2, complexity="expert",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="SCANv pattern adapted from pbartxl gist — SCAN that builds visible intermediate array",
    notes="Custom SCAN that accumulates into visible array via HSTACK: {0,1,3,6,10,15}, sum=35"))

entries.append(e("let_lambda_functional", "pbartxl_mapthunk",
    '=LET(THUNK,LAMBDA(v,LAMBDA(v)),tArr,MAP({10,20,30},LAMBDA(x,THUNK(x*2))),SUM(MAP(tArr,LAMBDA(t,t()))))', 120,
    ["thunk", "map", "deferred_array", "pbartxl"],
    ["LET", "LAMBDA", "MAP", "SUM"], operators=["*"],
    let_bindings=2, complexity="expert",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="MAP of THUNKs pattern from pbartxl — array of deferred computations",
    notes="Create array of thunks, then force them: {20,40,60}, sum=120"))

entries.append(e("let_lambda_functional", "pbartxl_byarr",
    '=LET(data,{1,2,3;4,5,6;7,8,9},rowSums,BYROW(data,LAMBDA(r,SUM(r))),colSums,BYCOL(data,LAMBDA(c,SUM(c))),SUM(rowSums)*SUM(colSums))', 2025,
    ["byrow", "bycol", "combined", "pbartxl"],
    ["LET", "BYROW", "BYCOL", "LAMBDA", "SUM"], operators=["*"],
    let_bindings=3, complexity="advanced",
    source_ids=["R-SRC-124"], provenance="adapted",
    provenance_detail="Combined BYROW/BYCOL pattern from pbartxl array techniques",
    notes="rowSums={6,15,24}=45, colSums={12,15,18}=45, product=2025"))

entries.append(e("let_lambda_functional", "recursive_flatten",
    '=LET(depth,LAMBDA(self,LAMBDA(arr,LAMBDA(d,IF(d=0,SUM(arr),self(self)(arr)(d-1))))),depth(depth)({1,2,3;4,5,6})(0))', 21,
    ["recursion", "depth_control"],
    ["LET", "LAMBDA", "IF", "SUM"], operators=["-", "="],
    let_bindings=1, complexity="advanced",
    notes="Recursive depth-controlled operation on arrays: at depth 0, just SUM"))

entries.append(e("let_lambda_functional", "lambda_memoize_pattern",
    '=LET(memo,REDUCE({0,0},SEQUENCE(10),LAMBDA(cache,i,LET(prev1,INDEX(cache,MAX(1,ROWS(cache)),1),prev2,INDEX(cache,MAX(1,ROWS(cache)-1),1),next,IF(i<=2,1,prev1+prev2),VSTACK(cache,HSTACK(next,i))))),INDEX(memo,11,1))', 55,
    ["memoization", "fibonacci", "cache_array"],
    ["LET", "REDUCE", "SEQUENCE", "LAMBDA", "INDEX", "MAX", "ROWS", "VSTACK", "HSTACK", "IF"],
    operators=["+", "-", "<="], let_bindings=5, complexity="expert",
    notes="Fibonacci with array-based memoization cache built via REDUCE+VSTACK"))

# =============================================================================
# DYNAMIC_ARRAY BACKFILL (+39)
# =============================================================================
entries.append(e("dynamic_array", "sequence_negative_step",
    '=SUM(SEQUENCE(5,1,10,-2))', 30,
    ["sequence", "negative_step"],
    ["SUM", "SEQUENCE"],
    notes="SEQUENCE(5,1,10,-2) = {10,8,6,4,2}, sum=30"))

entries.append(e("dynamic_array", "sequence_2d",
    '=SUM(SEQUENCE(3,3,1,1))', 45,
    ["sequence", "2d", "matrix"],
    ["SUM", "SEQUENCE"],
    notes="3x3 SEQUENCE: {1,2,3;4,5,6;7,8,9}, sum=45"))

entries.append(e("dynamic_array", "filter_empty_result",
    '=IFERROR(SUM(FILTER({1,2,3},FALSE)),"empty")', "empty",
    ["filter", "empty_result", "error"],
    ["IFERROR", "SUM", "FILTER"],
    expected_type="string",
    notes="FILTER with all-FALSE include returns #CALC! error; IFERROR catches it"))

entries.append(e("dynamic_array", "filter_multiple_criteria",
    '=SUM(FILTER({10,20,30,40,50},({10,20,30,40,50}>15)*({10,20,30,40,50}<45)))', 90,
    ["filter", "multiple_criteria", "boolean_multiply"],
    ["SUM", "FILTER"], operators=["*", ">", "<"],
    complexity="intermediate",
    notes="Filter 15<x<45: {20,30,40}, sum=90"))

entries.append(e("dynamic_array", "sort_descending",
    '=INDEX(SORT({3,1,4,1,5,9,2,6},-1),1)', 9,
    ["sort", "descending", "index"],
    ["INDEX", "SORT"],
    notes="Sort descending, first element = maximum"))

entries.append(e("dynamic_array", "sort_by_key",
    '=INDEX(SORTBY({"a","b","c","d"},{4,2,3,1}),1)', "d",
    ["sortby", "external_key"],
    ["INDEX", "SORTBY"], expected_type="string",
    notes="Sort strings by numeric keys; key 1 → 'd' comes first"))

entries.append(e("dynamic_array", "unique_rows",
    '=ROWS(UNIQUE({1;2;2;3;3;3}))', 3,
    ["unique", "count_distinct"],
    ["ROWS", "UNIQUE"],
    notes="3 unique values in {1,2,2,3,3,3}"))

entries.append(e("dynamic_array", "unique_exactly_once",
    '=SUM(UNIQUE({1,2,2,3,3,3},FALSE,TRUE))', 1,
    ["unique", "exactly_once"],
    ["SUM", "UNIQUE"],
    notes="UNIQUE with exactly_once=TRUE returns values appearing only once: {1}"))

entries.append(e("dynamic_array", "hstack_different_rows",
    '=ROWS(HSTACK({1;2;3},{10;20}))', 3,
    ["hstack", "mismatched_rows"],
    ["ROWS", "HSTACK"],
    notes="HSTACK with different row counts: extends shorter with #N/A"))

entries.append(e("dynamic_array", "vstack_mixed",
    '=ROWS(VSTACK({1,2,3},{4,5,6},{7,8,9}))', 3,
    ["vstack", "stacking"],
    ["ROWS", "VSTACK"],
    notes="VSTACK 3 row arrays into 3x3"))

entries.append(e("dynamic_array", "take_negative",
    '=SUM(TAKE({1,2,3,4,5},-3))', 12,
    ["take", "from_end"],
    ["SUM", "TAKE"],
    notes="TAKE with negative count takes from end: {3,4,5}, sum=12"))

entries.append(e("dynamic_array", "drop_negative",
    '=SUM(DROP({1,2,3,4,5},-2))', 6,
    ["drop", "from_end"],
    ["SUM", "DROP"],
    notes="DROP with negative count drops from end: {1,2,3}, sum=6"))

entries.append(e("dynamic_array", "expand_with_pad",
    '=SUM(EXPAND({1,2},1,5,0))', 3,
    ["expand", "padding"],
    ["SUM", "EXPAND"],
    notes="EXPAND {1,2} to 5 columns, pad with 0: {1,2,0,0,0}, sum=3"))

entries.append(e("dynamic_array", "tocol_2d",
    '=SUM(TOCOL({1,2;3,4;5,6}))', 21,
    ["tocol", "flatten"],
    ["SUM", "TOCOL"],
    notes="TOCOL flattens 2D to column: {1;2;3;4;5;6}, sum=21"))

entries.append(e("dynamic_array", "torow_2d",
    '=COLUMNS(TOROW({1;2;3;4;5}))', 5,
    ["torow", "transpose_to_row"],
    ["COLUMNS", "TOROW"],
    notes="TOROW converts column to row"))

entries.append(e("dynamic_array", "wraprows_basic",
    '=ROWS(WRAPROWS({1,2,3,4,5,6},3))', 2,
    ["wraprows", "reshape"],
    ["ROWS", "WRAPROWS"],
    notes="Wrap 6 elements into rows of 3: 2 rows"))

entries.append(e("dynamic_array", "wrapcols_basic",
    '=COLUMNS(WRAPCOLS({1,2,3,4,5,6},3))', 2,
    ["wrapcols", "reshape"],
    ["COLUMNS", "WRAPCOLS"],
    notes="Wrap 6 elements into columns of 3: 2 columns"))

entries.append(e("dynamic_array", "choosecols_reorder",
    '=SUM(CHOOSECOLS({10,20,30,40,50},{3,1,5}))', 90,
    ["choosecols", "reorder"],
    ["SUM", "CHOOSECOLS"],
    notes="Pick columns 3,1,5 from row: {30,10,50}, sum=90"))

entries.append(e("dynamic_array", "chooserows_negative",
    '=SUM(CHOOSEROWS({10;20;30;40;50},-1,-2))', 90,
    ["chooserows", "negative_index"],
    ["SUM", "CHOOSEROWS"],
    notes="Negative index counts from end: {50,40}, sum=90"))

entries.append(e("dynamic_array", "xlookup_reverse",
    '=XLOOKUP(30,{10,20,30,40,50},{"a","b","c","d","e"},-1,0,-1)', "c",
    ["xlookup", "reverse_search"],
    ["XLOOKUP"], expected_type="string",
    notes="XLOOKUP with search_mode=-1: search from last to first"))

entries.append(e("dynamic_array", "xlookup_horizontal",
    '=XLOOKUP("b",{"a","b","c"},{10,20,30})', 20,
    ["xlookup", "horizontal"],
    ["XLOOKUP"],
    notes="XLOOKUP in horizontal arrays"))

entries.append(e("dynamic_array", "xlookup_binary",
    '=XLOOKUP(25,{10,20,30,40,50},{"a","b","c","d","e"},,-1,2)', "b",
    ["xlookup", "binary_search", "approximate"],
    ["XLOOKUP"], expected_type="string",
    notes="Binary search mode (2): find <=25, returns 'b' for 20"))

entries.append(e("dynamic_array", "xmatch_wildcard",
    '=XMATCH("app*",{"banana","apple","cherry"},,2)', 2,
    ["xmatch", "wildcard"],
    ["XMATCH"],
    notes="XMATCH with wildcard match_mode=2"))

entries.append(e("dynamic_array", "randarray_dimensions",
    '=ROWS(RANDARRAY(5,3))*COLUMNS(RANDARRAY(5,3))', 15,
    ["randarray", "dimensions"],
    ["ROWS", "COLUMNS", "RANDARRAY"], operators=["*"],
    deterministic=False,
    notes="RANDARRAY(5,3) creates 5x3 array; product of dimensions = 15"))

entries.append(e("dynamic_array", "filter_sort_combine",
    '=INDEX(SORT(FILTER({5,3,8,1,9},({5,3,8,1,9}>3))),1)', 5,
    ["filter", "sort", "combined"],
    ["INDEX", "SORT", "FILTER"], operators=[">"],
    complexity="intermediate",
    notes="Filter >3 then sort ascending: {5,8,9}, first=5"))

entries.append(e("dynamic_array", "unique_sort_combine",
    '=INDEX(SORT(UNIQUE({3,1,4,1,5,9,2,6,5,3})),1)', 1,
    ["unique", "sort", "combined"],
    ["INDEX", "SORT", "UNIQUE"],
    complexity="intermediate",
    notes="Unique then sort: {1,2,3,4,5,6,9}, first=1"))

entries.append(e("dynamic_array", "sequence_filter_sum",
    '=SUM(FILTER(SEQUENCE(20),MOD(SEQUENCE(20),3)=0))', 63,
    ["sequence", "filter", "divisibility"],
    ["SUM", "FILTER", "SEQUENCE", "MOD"], operators=["="],
    complexity="intermediate",
    notes="Sum of 1..20 divisible by 3: 3+6+9+12+15+18=63"))

entries.append(e("dynamic_array", "hstack_vstack_compose",
    '=SUM(VSTACK(HSTACK({1,2},{3,4}),HSTACK({5,6},{7,8})))', 36,
    ["vstack", "hstack", "composed"],
    ["SUM", "VSTACK", "HSTACK"],
    notes="Build 2x4 from pieces, sum all = 1+2+3+4+5+6+7+8=36"))

entries.append(e("dynamic_array", "take_2d",
    '=SUM(TAKE({1,2,3;4,5,6;7,8,9},2,2))', 12,
    ["take", "2d", "submatrix"],
    ["SUM", "TAKE"],
    notes="TAKE first 2 rows and 2 cols: {1,2;4,5}, sum=12"))

entries.append(e("dynamic_array", "drop_2d",
    '=SUM(DROP({1,2,3;4,5,6;7,8,9},1,1))', 28,
    ["drop", "2d", "submatrix"],
    ["SUM", "DROP"],
    notes="DROP first row and col: {5,6;8,9}, sum=28"))

entries.append(e("dynamic_array", "sequence_as_index",
    '=SUM(INDEX({10,20,30,40,50},SEQUENCE(3)))', 60,
    ["sequence", "index", "multi_result"],
    ["SUM", "INDEX", "SEQUENCE"],
    notes="INDEX with array of indices: {10,20,30}, sum=60"))

entries.append(e("dynamic_array", "filter_or_criteria",
    '=SUM(FILTER({10,20,30,40,50},({10,20,30,40,50}<15)+({10,20,30,40,50}>35)))', 100,
    ["filter", "or_criteria"],
    ["SUM", "FILTER"], operators=["+", "<", ">"],
    complexity="intermediate",
    notes="OR criteria via +: <15 or >35 gives {10,40,50}, sum=100"))

entries.append(e("dynamic_array", "expand_2d",
    '=SUM(EXPAND({1},3,3,0))', 1,
    ["expand", "scalar_to_matrix"],
    ["SUM", "EXPAND"],
    notes="Expand single value to 3x3, pad with 0: sum=1"))

entries.append(e("dynamic_array", "sortby_multiple",
    '=INDEX(SORTBY({"a","b","c","d"},{2,1,2,1},{1,2,1,2}),1)', "b",
    ["sortby", "multi_key"],
    ["INDEX", "SORTBY"], expected_type="string", complexity="intermediate",
    notes="SORTBY with two sort keys: first by {2,1,2,1}, then by {1,2,1,2}"))

entries.append(e("dynamic_array", "tocol_ignore_errors",
    '=SUM(TOCOL({1,2,#N/A;4,5,6},1))', 18,
    ["tocol", "ignore_errors"],
    ["SUM", "TOCOL"],
    notes="TOCOL with ignore=1 skips errors: {1,2,4,5,6}, sum=18"))

entries.append(e("dynamic_array", "reduce_to_build_array",
    '=SUM(REDUCE(0,{1,2,3,4,5},LAMBDA(acc,x,acc+x^2)))', 55,
    ["reduce", "sum_of_squares"],
    ["SUM", "REDUCE", "LAMBDA"], operators=["+", "^"],
    complexity="intermediate",
    notes="Sum of squares via REDUCE: 1+4+9+16+25=55"))

entries.append(e("dynamic_array", "wraprows_pad",
    '=SUM(WRAPROWS({1,2,3,4,5},3,0))', 15,
    ["wraprows", "padding"],
    ["SUM", "WRAPROWS"],
    notes="Wrap 5 elements into rows of 3, pad with 0: {1,2,3;4,5,0}, sum=15"))

entries.append(e("dynamic_array", "wrapcols_pad",
    '=SUM(WRAPCOLS({1,2,3,4,5},3,0))', 15,
    ["wrapcols", "padding"],
    ["SUM", "WRAPCOLS"],
    notes="Wrap 5 elements into cols of 3, pad with 0: {1,4;2,5;3,0}, sum=15"))

entries.append(e("dynamic_array", "nested_sequence_filter_unique",
    '=SUM(UNIQUE(FILTER(MOD(SEQUENCE(30),7),MOD(SEQUENCE(30),7)<>0)))', 21,
    ["sequence", "filter", "unique", "nested"],
    ["SUM", "UNIQUE", "FILTER", "MOD", "SEQUENCE"], operators=["<>"],
    complexity="advanced",
    notes="Remainders mod 7 for 1..30, filter non-zero, unique: {1,2,3,4,5,6}, sum=21"))

# =============================================================================
# LOOKUP_NONREF BACKFILL (+20)
# =============================================================================
entries.append(e("lookup_nonref", "vlookup_exact",
    '=VLOOKUP(3,{1,"a";2,"b";3,"c";4,"d"},2,FALSE)', "c",
    ["vlookup", "exact_match"],
    ["VLOOKUP"], expected_type="string",
    notes="Exact match VLOOKUP in array constant"))

entries.append(e("lookup_nonref", "vlookup_approximate",
    '=VLOOKUP(25,{10,"low";20,"med";30,"high";40,"max"},2,TRUE)', "med",
    ["vlookup", "approximate_match"],
    ["VLOOKUP"], expected_type="string",
    notes="Approximate match: 25 falls between 20 and 30, returns 'med'"))

entries.append(e("lookup_nonref", "vlookup_not_found",
    '=VLOOKUP(99,{1,"a";2,"b";3,"c"},2,FALSE)', None,
    ["vlookup", "not_found", "na_error"],
    ["VLOOKUP"], expected_type="error", expected_error="#N/A",
    notes="VLOOKUP exact match not found returns #N/A"))

entries.append(e("lookup_nonref", "hlookup_exact",
    '=HLOOKUP("b",{"a","b","c";10,20,30},2,FALSE)', 20,
    ["hlookup", "exact_match"],
    ["HLOOKUP"],
    notes="HLOOKUP in array constant"))

entries.append(e("lookup_nonref", "index_match_pattern",
    '=INDEX({100,200,300,400,500},MATCH(300,{100,200,300,400,500},0))', 300,
    ["index_match", "classic_pattern"],
    ["INDEX", "MATCH"], complexity="intermediate",
    notes="Classic INDEX/MATCH pattern"))

entries.append(e("lookup_nonref", "match_approximate",
    '=MATCH(25,{10,20,30,40,50},1)', 2,
    ["match", "approximate"],
    ["MATCH"],
    notes="MATCH with match_type=1: largest value ≤25 is at position 2 (value 20)"))

entries.append(e("lookup_nonref", "match_exact_not_found",
    '=MATCH(99,{10,20,30},0)', None,
    ["match", "not_found"],
    ["MATCH"], expected_type="error", expected_error="#N/A",
    notes="Exact match not found"))

entries.append(e("lookup_nonref", "choose_basic",
    '=CHOOSE(3,"a","b","c","d")', "c",
    ["choose", "basic"],
    ["CHOOSE"], expected_type="string"))

entries.append(e("lookup_nonref", "choose_out_of_range",
    '=CHOOSE(5,"a","b","c")', None,
    ["choose", "out_of_range"],
    ["CHOOSE"], expected_type="error", expected_error="#VALUE!",
    notes="CHOOSE index beyond available values"))

entries.append(e("lookup_nonref", "xlookup_default",
    '=XLOOKUP(99,{1,2,3},{"a","b","c"},"missing")', "missing",
    ["xlookup", "default_value"],
    ["XLOOKUP"], expected_type="string",
    notes="XLOOKUP with if_not_found default"))

entries.append(e("lookup_nonref", "xlookup_wildcard",
    '=XLOOKUP("app*",{"banana","apple","cherry"},{1,2,3},,2)', 2,
    ["xlookup", "wildcard"],
    ["XLOOKUP"],
    notes="XLOOKUP with wildcard match mode"))

entries.append(e("lookup_nonref", "xlookup_return_array",
    '=SUM(XLOOKUP("b",{"a","b","c"},{10,20,30;40,50,60}))', 70,
    ["xlookup", "return_array", "multi_column"],
    ["SUM", "XLOOKUP"], complexity="intermediate",
    notes="XLOOKUP returning multiple values (column): {20,50}, sum=70"))

entries.append(e("lookup_nonref", "xmatch_exact",
    '=XMATCH("c",{"a","b","c","d"})', 3,
    ["xmatch", "exact"],
    ["XMATCH"],
    notes="XMATCH exact match"))

entries.append(e("lookup_nonref", "xmatch_binary_asc",
    '=XMATCH(25,{10,20,30,40,50},-1,2)', 2,
    ["xmatch", "binary_search"],
    ["XMATCH"],
    notes="XMATCH binary search, find ≤25 → position 2 (value 20)"))

entries.append(e("lookup_nonref", "index_2d",
    '=INDEX({10,20,30;40,50,60;70,80,90},2,3)', 60,
    ["index", "2d"],
    ["INDEX"],
    notes="2D INDEX: row 2, col 3 = 60"))

entries.append(e("lookup_nonref", "index_entire_row",
    '=SUM(INDEX({10,20,30;40,50,60;70,80,90},2,0))', 150,
    ["index", "entire_row"],
    ["SUM", "INDEX"],
    notes="INDEX with col=0 returns entire row: {40,50,60}, sum=150"))

entries.append(e("lookup_nonref", "lookup_vector",
    '=LOOKUP(25,{10,20,30,40,50},{"a","b","c","d","e"})', "b",
    ["lookup", "vector_form"],
    ["LOOKUP"], expected_type="string",
    notes="LOOKUP vector form: finds largest ≤25 (=20) returns corresponding 'b'"))

entries.append(e("lookup_nonref", "vlookup_sorted_first_col",
    '=VLOOKUP(3,{3,"x";1,"y";3,"z"},2,FALSE)', "x",
    ["vlookup", "duplicate_key"],
    ["VLOOKUP"], expected_type="string",
    notes="VLOOKUP with duplicate keys returns first match"))

entries.append(e("lookup_nonref", "xlookup_last_match",
    '=XLOOKUP(3,{3,1,3,2},{10,20,30,40},,0,-1)', 30,
    ["xlookup", "last_match"],
    ["XLOOKUP"],
    notes="XLOOKUP search from end: finds last 3 → returns 30"))

entries.append(e("lookup_nonref", "choose_nested",
    '=CHOOSE(2,SUM({1,2,3}),PRODUCT({2,3,4}),MAX({5,6,7}))', 24,
    ["choose", "nested_functions"],
    ["CHOOSE", "SUM", "PRODUCT", "MAX"], complexity="intermediate",
    notes="CHOOSE with function expressions: picks 2nd = PRODUCT({2,3,4})=24"))

# =============================================================================
# TYPE_COERCION_EDGE BACKFILL (+23)
# =============================================================================
entries.append(e("type_coercion_edge", "empty_string_numeric",
    '=""+0', 0,
    ["empty_string", "numeric_coercion"],
    [], operators=["+"],
    notes="Empty string coerces to 0 in arithmetic context"))

entries.append(e("type_coercion_edge", "boolean_subtraction",
    '=TRUE-FALSE', 1,
    ["boolean", "arithmetic"],
    [], operators=["-"],
    notes="TRUE=1, FALSE=0 in arithmetic: 1-0=1"))

entries.append(e("type_coercion_edge", "boolean_not_equal_one",
    '=TRUE=1', True,
    ["boolean", "numeric_comparison"],
    [], operators=["="], expected_type="boolean",
    notes="TRUE equals 1 in comparison"))

entries.append(e("type_coercion_edge", "text_number_comparison",
    '="1">2', True,
    ["text_vs_number", "comparison"],
    [], operators=[">"], expected_type="boolean",
    notes="Text is ALWAYS greater than numbers in Excel comparisons (type ordering)"))

entries.append(e("type_coercion_edge", "text_text_numeric_comparison",
    '="10">"9"', False,
    ["text_text", "string_comparison"],
    [], operators=[">"], expected_type="boolean",
    notes="Text-to-text comparison is lexicographic: '1' < '9', so '10' < '9'"))

entries.append(e("type_coercion_edge", "sum_ignores_booleans",
    '=SUM({1,TRUE,3,FALSE,5})', 9,
    ["sum", "boolean_in_array"],
    ["SUM"],
    notes="SUM ignores booleans in array arguments: 1+3+5=9"))

entries.append(e("type_coercion_edge", "sum_ignores_text",
    '=SUM({1,"2",3})', 4,
    ["sum", "text_in_array"],
    ["SUM"],
    notes="SUM ignores text in array: 1+3=4"))

entries.append(e("type_coercion_edge", "product_with_boolean",
    '=PRODUCT({2,TRUE,3})', 6,
    ["product", "boolean_in_array"],
    ["PRODUCT"],
    notes="PRODUCT ignores TRUE in array: 2*3=6"))

entries.append(e("type_coercion_edge", "if_type_mismatch",
    '=IF(TRUE,"text",123)+1', None,
    ["if", "type_mismatch", "value_error"],
    ["IF"], operators=["+"],
    expected_type="error", expected_error="#VALUE!",
    notes="IF returns 'text', can't add 1 to text → #VALUE!"))

entries.append(e("type_coercion_edge", "unary_double_negative",
    '=--TRUE', 1,
    ["double_negative", "boolean_to_number"],
    [], operators=["-"],
    notes="Classic double-negative trick to coerce boolean to number"))

entries.append(e("type_coercion_edge", "multiply_boolean",
    '=TRUE*TRUE', 1,
    ["boolean_multiplication"],
    [], operators=["*"],
    notes="TRUE*TRUE = 1*1 = 1"))

entries.append(e("type_coercion_edge", "error_precedence_div0_na",
    '=1/0+NA()', None,
    ["error_precedence", "multiple_errors"],
    ["NA"], operators=["/", "+"],
    expected_type="error", expected_error="#DIV/0!",
    notes="When multiple errors: left-to-right evaluation, #DIV/0! evaluated first"))

entries.append(e("type_coercion_edge", "iferror_chain",
    '=IFERROR(IFERROR(1/0,SQRT(-1)),"fallback")', "fallback",
    ["iferror", "chain", "double_error"],
    ["IFERROR", "SQRT"], operators=["/"],
    expected_type="string",
    notes="Nested IFERROR: 1/0=#DIV/0!, fallback SQRT(-1)=#NUM!, final fallback 'fallback'"))

entries.append(e("type_coercion_edge", "comparison_chain_false",
    '=(1<2)+(2<3)', 2,
    ["comparison_chain", "boolean_addition"],
    [], operators=["<", "+"],
    notes="Each comparison returns TRUE(=1), 1+1=2"))

entries.append(e("type_coercion_edge", "percentage_operator",
    '=50%', 0.5,
    ["percentage", "operator"],
    [], operators=["%"],
    notes="Percentage operator divides by 100"))

entries.append(e("type_coercion_edge", "percentage_in_calc",
    '=100+100*10%', 110,
    ["percentage", "calculation"],
    [], operators=["+", "*", "%"],
    notes="10% = 0.1; 100 + 100*0.1 = 110"))

entries.append(e("type_coercion_edge", "implicit_intersection_scalar",
    '=SUM(IF({TRUE,FALSE,TRUE},{10,20,30}))', 40,
    ["implicit_intersection", "if_array"],
    ["SUM", "IF"],
    notes="IF with array condition: {10,FALSE,30}, SUM treats FALSE as 0 = 40"))

entries.append(e("type_coercion_edge", "n_function_coercion",
    '=N(TRUE)+N("hello")+N(42)', 43,
    ["n_function", "type_coercion"],
    ["N"], operators=["+"],
    notes="N(TRUE)=1, N('hello')=0, N(42)=42; sum=43"))

entries.append(e("type_coercion_edge", "t_function_coercion",
    '=T(123)&T("hi")&T(TRUE)', "hi",
    ["t_function", "text_coercion"],
    ["T"], operators=["&"], expected_type="string",
    notes="T(number)='', T('hi')='hi', T(bool)=''; concatenated = 'hi'"))

entries.append(e("type_coercion_edge", "comparison_empty_string",
    '=""=0', False,
    ["empty_string", "comparison", "not_equal"],
    [], operators=["="], expected_type="boolean",
    notes="Empty string does NOT equal 0 in comparison (despite coercing to 0 in arithmetic)"))

entries.append(e("type_coercion_edge", "type_function_values",
    '=TYPE(1)&TYPE("a")&TYPE(TRUE)&TYPE(NA())&TYPE({1,2})', "1216464",
    ["type_function", "all_types"],
    ["TYPE", "NA"], operators=["&"], expected_type="string",
    notes="TYPE: 1=number, 2=text, 16=error, 4=boolean, 64=array"))

entries.append(e("type_coercion_edge", "error_in_if_false_branch",
    '=IF(TRUE,1,1/0)', 1,
    ["if", "unevaluated_branch"],
    ["IF"], operators=["/"],
    notes="False branch of IF is not evaluated — no #DIV/0! error"))

entries.append(e("type_coercion_edge", "concat_vs_plus_coercion",
    '=LET(x,"5",y,3,(x&y)&" vs "&(x+y))', "53 vs 8",
    ["concat_vs_add", "dual_coercion"],
    ["LET"], operators=["&", "+"],
    let_bindings=2, expected_type="string",
    notes="& concatenates (text): '53'; + adds (numeric): 8"))

# =============================================================================
# ENGINEERING BACKFILL (+1)
# =============================================================================
entries.append(e("engineering", "convert_units",
    '=CONVERT(100,"cm","in")', 39.37007874015748,
    ["convert", "units"],
    ["CONVERT"],
    notes="100 cm to inches"))

# =============================================================================
# NESTED_COMPLEX BACKFILL (+72) — THE CREATIVE DEEP MAGIC
# =============================================================================

# --- Sorting via formulas ---
entries.append(e("nested_complex", "bubble_sort_reduce",
    '=LET(arr,{5,3,8,1,9,2},n,COLUMNS(arr),sorted,REDUCE(arr,SEQUENCE(n),LAMBDA(a,_,REDUCE(a,SEQUENCE(n-1),LAMBDA(b,j,LET(curr,INDEX(b,1,j),next,INDEX(b,1,j+1),IF(curr>next,LET(left,IF(j>1,TAKE(b,,j-1),TAKE(b,,0)),right,IF(j+1<n,DROP(b,,j+1),TAKE(b,,0)),HSTACK(left,next,curr,right)),b)))))),SUM(sorted))', 28,
    ["bubble_sort", "reduce", "array_manipulation"],
    ["LET", "REDUCE", "SEQUENCE", "LAMBDA", "INDEX", "IF", "TAKE", "DROP", "HSTACK", "SUM", "COLUMNS"],
    operators=["-", "+", ">", "<"], let_bindings=7, complexity="expert",
    notes="Bubble sort implemented purely in formulas via nested REDUCE. Sum verifies same elements: 5+3+8+1+9+2=28"))

entries.append(e("nested_complex", "prime_sieve",
    '=LET(n,30,nums,SEQUENCE(n-1,,2),primes,FILTER(nums,BYROW(MAKEARRAY(n-1,n-1,LAMBDA(r,c,IF(c+1<r+2,MOD(r+2,c+2)=0,FALSE))),LAMBDA(row,SUM(--row)))<2),SUM(primes))', None,
    ["prime_sieve", "eratosthenes", "makearray"],
    ["LET", "FILTER", "BYROW", "MAKEARRAY", "LAMBDA", "IF", "MOD", "SUM", "SEQUENCE"],
    operators=["=", "<", "+", "-"], let_bindings=3, complexity="expert",
    notes="Sieve of Eratosthenes in a formula. Complex but may hit size limits. Testing engine capability."))
# The above is speculative and hard to verify, let me replace with a simpler prime counter
entries.pop()
seq -= 1

entries.append(e("nested_complex", "count_primes_to_20",
    '=LET(n,20,nums,SEQUENCE(n-1,,2),divCounts,MAP(nums,LAMBDA(x,SUM(--(MOD(x,SEQUENCE(x-2,,2))=0)))),SUM(--(divCounts=0)))', 8,
    ["prime_counting", "map", "divisibility"],
    ["LET", "MAP", "LAMBDA", "SUM", "MOD", "SEQUENCE"],
    operators=["=", "-"], let_bindings=3, complexity="expert",
    notes="Count primes 2-20: for each number, count divisors 2..n-1; primes have 0 such divisors. {2,3,5,7,11,13,17,19}=8"))

entries.append(e("nested_complex", "matrix_determinant_2x2",
    '=LET(m,{3,7;1,5},INDEX(m,1,1)*INDEX(m,2,2)-INDEX(m,1,2)*INDEX(m,2,1))', 8,
    ["determinant", "matrix", "2x2"],
    ["LET", "INDEX"], operators=["*", "-"],
    let_bindings=1, complexity="intermediate",
    notes="2x2 determinant: ad-bc = 3*5-7*1 = 8"))

entries.append(e("nested_complex", "matrix_determinant_3x3",
    '=LET(m,{1,2,3;4,5,6;7,8,0},a,INDEX(m,1,1),b,INDEX(m,1,2),c,INDEX(m,1,3),d,INDEX(m,2,1),e,INDEX(m,2,2),f,INDEX(m,2,3),g,INDEX(m,3,1),h,INDEX(m,3,2),i,INDEX(m,3,3),a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g))', 27,
    ["determinant", "matrix", "3x3", "cofactor_expansion"],
    ["LET", "INDEX"], operators=["*", "-", "+"],
    let_bindings=10, complexity="advanced",
    notes="3x3 determinant via cofactor expansion: 1*(0-48)-2*(0-42)+3*(32-35) = -48+84-9=27"))

entries.append(e("nested_complex", "matrix_multiply_reduce",
    '=LET(A,{1,2;3,4},B,{5,6;7,8},r,ROWS(A),c,COLUMNS(B),result,MAKEARRAY(r,c,LAMBDA(i,j,SUMPRODUCT(INDEX(A,i,0),INDEX(B,0,j)))),SUM(result))', 134,
    ["matrix_multiply", "makearray", "sumproduct"],
    ["LET", "MAKEARRAY", "LAMBDA", "SUMPRODUCT", "INDEX", "ROWS", "COLUMNS", "SUM"],
    let_bindings=5, complexity="expert",
    notes="Matrix multiplication via MAKEARRAY+SUMPRODUCT: {19,22;43,50}, sum=134"))

entries.append(e("nested_complex", "euclidean_distance",
    '=LET(p1,{1,2,3},p2,{4,6,3},SQRT(SUM((p1-p2)^2)))', 5,
    ["euclidean_distance", "vector"],
    ["LET", "SQRT", "SUM"], operators=["-", "^"],
    let_bindings=2, complexity="intermediate",
    notes="3D Euclidean distance: sqrt((4-1)^2+(6-2)^2+(3-3)^2) = sqrt(9+16+0) = 5"))

entries.append(e("nested_complex", "weighted_average",
    '=LET(vals,{85,90,78,95},wts,{0.2,0.3,0.2,0.3},SUMPRODUCT(vals,wts)/SUM(wts))', 87.6,
    ["weighted_average", "sumproduct"],
    ["LET", "SUMPRODUCT", "SUM"], operators=["/"],
    let_bindings=2, complexity="intermediate",
    notes="Weighted average: (85*0.2+90*0.3+78*0.2+95*0.3)/(0.2+0.3+0.2+0.3) = 87.6"))

entries.append(e("nested_complex", "iqr_calculation",
    '=LET(d,{2,7,15,3,9,20,4,11,6,8},q1,QUARTILE(d,1),q3,QUARTILE(d,3),q3-q1)', 8.25,
    ["iqr", "interquartile_range", "quartile"],
    ["LET", "QUARTILE"], operators=["-"],
    let_bindings=3, complexity="intermediate",
    notes="IQR = Q3-Q1 for dataset"))

entries.append(e("nested_complex", "z_score_normalization",
    '=LET(d,{10,20,30,40,50},mu,AVERAGE(d),sigma,STDEV(d),zscores,MAP(d,LAMBDA(x,(x-mu)/sigma)),ROUND(SUM(zscores),10))', 0,
    ["z_score", "normalization", "statistics"],
    ["LET", "AVERAGE", "STDEV", "MAP", "LAMBDA", "ROUND", "SUM"],
    operators=["-", "/"], let_bindings=4, complexity="advanced",
    notes="Z-scores always sum to 0 (within floating-point precision)"))

entries.append(e("nested_complex", "running_max",
    '=SUM(SCAN(-1E+308,{3,1,4,1,5,9,2,6},LAMBDA(mx,x,MAX(mx,x))))', 39,
    ["running_max", "scan"],
    ["SUM", "SCAN", "LAMBDA", "MAX"],
    notes="Running maximum: {3,3,4,4,5,9,9,9}, sum=46. Wait let me recalc: 3+3+4+4+5+9+9+9=46"))

entries[-1]["expected_result"] = 46

entries.append(e("nested_complex", "fizzbuzz_single",
    '=LET(n,15,IF(MOD(n,15)=0,"FizzBuzz",IF(MOD(n,3)=0,"Fizz",IF(MOD(n,5)=0,"Buzz",n))))', "FizzBuzz",
    ["fizzbuzz", "conditional"],
    ["LET", "IF", "MOD"], operators=["="],
    let_bindings=1, expected_type="string",
    notes="Classic FizzBuzz for n=15"))

entries.append(e("nested_complex", "fizzbuzz_array",
    '=LET(nums,SEQUENCE(15),result,MAP(nums,LAMBDA(n,IF(MOD(n,15)=0,"FizzBuzz",IF(MOD(n,3)=0,"Fizz",IF(MOD(n,5)=0,"Buzz",TEXT(n,"0")))))),INDEX(result,15))', "FizzBuzz",
    ["fizzbuzz", "array", "map"],
    ["LET", "MAP", "LAMBDA", "IF", "MOD", "TEXT", "SEQUENCE", "INDEX"],
    operators=["="], let_bindings=2, complexity="advanced", expected_type="string",
    notes="FizzBuzz for 1-15 via MAP, verify 15th element"))

entries.append(e("nested_complex", "collatz_sequence_length",
    '=LET(collatz,LAMBDA(self,LAMBDA(n,LAMBDA(steps,IF(n=1,steps,IF(MOD(n,2)=0,self(self)(n/2)(steps+1),self(self)(3*n+1)(steps+1)))))),collatz(collatz)(6)(0))', 8,
    ["collatz", "recursion", "sequence"],
    ["LET", "LAMBDA", "IF", "MOD"], operators=["=", "/", "*", "+"],
    let_bindings=1, complexity="advanced",
    notes="Collatz sequence from 6: 6→3→10→5→16→8→4→2→1 = 8 steps"))

entries.append(e("nested_complex", "digit_sum_recursive",
    '=LET(digSum,LAMBDA(self,LAMBDA(n,IF(n<10,n,self(self)(MOD(n,10)+INT(n/10))))),digSum(digSum)(9999))', 9,
    ["digital_root", "recursion"],
    ["LET", "LAMBDA", "IF", "MOD", "INT"], operators=["+", "/", "<"],
    let_bindings=1, complexity="advanced",
    notes="Recursive digital root: 9999→36→9"))

entries.append(e("nested_complex", "tower_of_hanoi_count",
    '=LET(hanoi,LAMBDA(self,LAMBDA(n,IF(n=1,1,2*self(self)(n-1)+1))),hanoi(hanoi)(10))', 1023,
    ["tower_of_hanoi", "recursion", "classic"],
    ["LET", "LAMBDA", "IF"], operators=["*", "+", "-", "="],
    let_bindings=1, complexity="advanced",
    notes="Minimum moves for Tower of Hanoi: 2^n - 1 = 1023"))

entries.append(e("nested_complex", "compound_interest_schedule",
    '=LET(P,1000,r,0.05,n,12,t,5,final,REDUCE(P,SEQUENCE(n*t),LAMBDA(bal,_,bal*(1+r/n))),ROUND(final,2))', 1283.36,
    ["compound_interest", "reduce", "schedule"],
    ["LET", "REDUCE", "SEQUENCE", "LAMBDA", "ROUND"],
    operators=["*", "+", "/"], let_bindings=5, complexity="advanced",
    notes="Compound interest: $1000 at 5% compounded monthly for 5 years"))

entries.append(e("nested_complex", "pascal_triangle_row",
    '=LET(row,LAMBDA(self,LAMBDA(n,IF(n=0,{1},LET(prev,self(self)(n-1),padL,HSTACK(0,prev),padR,HSTACK(prev,0),padL+padR)))),SUM(row(row)(5)))', 32,
    ["pascal_triangle", "recursion", "array"],
    ["LET", "LAMBDA", "IF", "HSTACK", "SUM"], operators=["+"],
    let_bindings=4, complexity="expert",
    notes="Pascal's triangle row 5 via recursion: {1,5,10,10,5,1}, sum=32=2^5"))

entries.append(e("nested_complex", "geometric_series",
    '=LET(a,1,r,0.5,n,20,terms,a*r^(SEQUENCE(n)-1),SUM(terms))', 1.999999046325684,
    ["geometric_series", "convergence"],
    ["LET", "SUM", "SEQUENCE"], operators=["*", "^", "-"],
    let_bindings=4, complexity="intermediate",
    notes="Geometric series sum: 1+0.5+0.25+... converges to 2"))

entries.append(e("nested_complex", "pi_leibniz_approximation",
    '=LET(n,1000,terms,SEQUENCE(n),signs,(-1)^(terms-1),pi4,SUM(signs/(2*terms-1)),ROUND(pi4*4,4))', 3.1406,
    ["pi_approximation", "leibniz", "series"],
    ["LET", "SUM", "SEQUENCE", "ROUND"], operators=["^", "-", "/", "*"],
    let_bindings=4, complexity="advanced",
    notes="Leibniz formula for π/4: 1 - 1/3 + 1/5 - 1/7 + ... Slow convergence, 1000 terms ≈ 3.1406"))

entries.append(e("nested_complex", "e_approximation",
    '=LET(n,15,terms,SEQUENCE(n,,0),factorials,SCAN(1,SEQUENCE(n-1),LAMBDA(acc,i,acc*i)),allFact,VSTACK(1,factorials),ROUND(SUM(1/allFact),10))', 2.7182818285,
    ["e_approximation", "taylor_series", "factorial"],
    ["LET", "SEQUENCE", "SCAN", "LAMBDA", "VSTACK", "SUM", "ROUND"],
    operators=["*", "/"], let_bindings=4, complexity="advanced",
    notes="e = Σ 1/n! for n=0..14: converges rapidly"))

entries.append(e("nested_complex", "caesar_cipher",
    '=LET(msg,"HELLO",shift,3,enc,MAP(MID(msg,SEQUENCE(LEN(msg)),1),LAMBDA(ch,CHAR(MOD(CODE(ch)-65+shift,26)+65))),TEXTJOIN("",TRUE,enc))', "KHOOR",
    ["caesar_cipher", "encryption", "map"],
    ["LET", "MAP", "MID", "SEQUENCE", "LEN", "LAMBDA", "CHAR", "MOD", "CODE", "TEXTJOIN"],
    operators=["-", "+"], let_bindings=3, complexity="advanced", expected_type="string",
    notes="Caesar cipher shift+3: H→K, E→H, L→O, L→O, O→R"))

entries.append(e("nested_complex", "string_contains_all_digits",
    '=LET(s,"0a1b2c3d4e5f6g7h8i9j",digits,SEQUENCE(10,,0),allFound,AND(MAP(digits,LAMBDA(d,ISNUMBER(FIND(TEXT(d,"0"),s))))),allFound)', True,
    ["string_analysis", "digit_check", "map"],
    ["LET", "SEQUENCE", "AND", "MAP", "LAMBDA", "ISNUMBER", "FIND", "TEXT"],
    let_bindings=3, complexity="advanced", expected_type="boolean",
    notes="Check if string contains all digits 0-9"))

entries.append(e("nested_complex", "running_median_window3",
    '=LET(d,{1,5,2,8,3,7,4,6},n,COLUMNS(d),medians,MAP(SEQUENCE(n-2,,2),LAMBDA(i,MEDIAN(INDEX(d,,i-1),INDEX(d,,i),INDEX(d,,i+1)))),SUM(medians))', 30,
    ["running_median", "window", "map"],
    ["LET", "MAP", "SEQUENCE", "LAMBDA", "MEDIAN", "INDEX", "COLUMNS", "SUM"],
    operators=["-", "+"], let_bindings=3, complexity="advanced",
    notes="3-element sliding window median: {2,5,3,7,4,6}, sum=27. Let me recheck: median(1,5,2)=2, median(5,2,8)=5, median(2,8,3)=3, median(8,3,7)=7, median(3,7,4)=4, median(7,4,6)=6 → sum=27"))

entries[-1]["expected_result"] = 27

entries.append(e("nested_complex", "polynomial_evaluation",
    '=LET(coeffs,{3,2,-5,1},x,2,SUMPRODUCT(coeffs,x^SEQUENCE(COLUMNS(coeffs),,COLUMNS(coeffs)-1,-1)))', 27,
    ["polynomial", "horner", "evaluation"],
    ["LET", "SUMPRODUCT", "SEQUENCE", "COLUMNS"],
    operators=["^", "-"], let_bindings=2, complexity="intermediate",
    notes="Evaluate 3x³+2x²-5x+1 at x=2: 24+8-10+1=23. Wait: 3*8+2*4-5*2+1=24+8-10+1=23"))

entries[-1]["expected_result"] = 23

entries.append(e("nested_complex", "moving_average_5",
    '=LET(d,{10,20,30,40,50,60,70,80,90,100},w,5,n,COLUMNS(d),avgs,MAP(SEQUENCE(n-w+1,,w),LAMBDA(i,AVERAGE(INDEX(d,,SEQUENCE(w,,i-w+1))))),SUM(avgs))', 330,
    ["moving_average", "window", "map"],
    ["LET", "MAP", "SEQUENCE", "LAMBDA", "AVERAGE", "INDEX", "COLUMNS", "SUM"],
    operators=["-", "+"], let_bindings=4, complexity="advanced",
    notes="5-period moving average: {30,40,50,60,70,80}, sum=330"))

entries.append(e("nested_complex", "covariance_manual",
    '=LET(x,{1,2,3,4,5},y,{2,4,5,4,5},mx,AVERAGE(x),my,AVERAGE(y),n,COLUMNS(x),SUM((x-mx)*(y-my))/(n-1))', 1.5,
    ["covariance", "manual", "statistics"],
    ["LET", "AVERAGE", "SUM", "COLUMNS"], operators=["-", "*", "/"],
    let_bindings=5, complexity="advanced",
    notes="Sample covariance calculated manually"))

entries.append(e("nested_complex", "string_palindrome",
    '=LET(s,"racecar",rev,LAMBDA(self,LAMBDA(str,IF(LEN(str)<=1,str,self(self)(MID(str,2,LEN(str)-1))&LEFT(str,1)))),s=rev(rev)(s))', True,
    ["palindrome", "recursion", "string"],
    ["LET", "LAMBDA", "IF", "LEN", "MID", "LEFT"],
    operators=["&", "-", "<=", "="], let_bindings=2, complexity="advanced", expected_type="boolean",
    notes="Palindrome check via recursive string reversal"))

entries.append(e("nested_complex", "roman_numeral_roundtrip",
    '=ARABIC(ROMAN(1999))', 1999,
    ["roman", "arabic", "roundtrip"],
    ["ARABIC", "ROMAN"],
    notes="ROMAN→ARABIC round trip: 1999 = MCMXCIX → 1999"))

entries.append(e("nested_complex", "conditional_weighted_sum",
    '=LET(vals,{10,20,30,40,50},flags,{1,0,1,1,0},wts,{0.5,0.3,0.2,0.4,0.1},SUMPRODUCT(vals,flags,wts))', 21,
    ["conditional", "weighted_sum", "three_array"],
    ["LET", "SUMPRODUCT"], let_bindings=3, complexity="intermediate",
    notes="Three-way SUMPRODUCT: only flagged items contribute: 10*1*0.5+30*1*0.2+40*1*0.4=5+6+16=27. Wait: 10*0.5=5, 30*0.2=6, 40*0.4=16 → 27"))

entries[-1]["expected_result"] = 27

entries.append(e("nested_complex", "deep_nesting_16_levels",
    '=IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,42,0),0),0),0),0),0),0),0),0),0),0),0),0),0),0),0)', 42,
    ["deep_nesting", "if_chain", "16_levels"],
    ["IF"],
    complexity="intermediate",
    notes="16 levels of nested IF — testing parser and evaluator depth handling"))

entries.append(e("nested_complex", "bracket_depth_stress",
    '=((((((((((((((((1+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)', 16,
    ["bracket_depth", "stress_test"],
    [], operators=["+"],
    notes="16 levels of nested parentheses — parser stress test"))

entries.append(e("nested_complex", "cross_type_sorting",
    '=LET(data,{3,1,4,1,5,9,2,6},sorted,SORT(data),INDEX(sorted,1)*100+INDEX(sorted,COLUMNS(data)))', 109,
    ["sort", "min_max", "combined"],
    ["LET", "SORT", "INDEX", "COLUMNS"], operators=["*", "+"],
    let_bindings=2, complexity="intermediate",
    notes="Sort to get min(1) and max(9): 1*100+9=109"))

entries.append(e("nested_complex", "frequency_distribution",
    '=LET(data,{1,2,2,3,3,3,4,4,4,4},vals,UNIQUE(SORT(data)),counts,MAP(vals,LAMBDA(v,SUM(--(data=v)))),MAX(counts))', 4,
    ["frequency", "distribution", "mode_count"],
    ["LET", "UNIQUE", "SORT", "MAP", "LAMBDA", "SUM", "MAX"],
    operators=["=", "--"], let_bindings=3, complexity="advanced",
    notes="Find mode frequency: value 4 appears 4 times"))

entries.append(e("nested_complex", "haversine_distance",
    '=LET(lat1,RADIANS(40.7128),lon1,RADIANS(-74.006),lat2,RADIANS(51.5074),lon2,RADIANS(-0.1278),dlat,lat2-lat1,dlon,lon2-lon1,a,SIN(dlat/2)^2+COS(lat1)*COS(lat2)*SIN(dlon/2)^2,c,2*ASIN(SQRT(a)),R,6371,ROUND(R*c,0))', 5570,
    ["haversine", "great_circle", "geography"],
    ["LET", "RADIANS", "SIN", "COS", "ASIN", "SQRT", "ROUND"],
    operators=["-", "/", "^", "+", "*"], let_bindings=9, complexity="expert",
    notes="Great-circle distance NYC to London ≈ 5570 km via Haversine formula"))

entries.append(e("nested_complex", "binary_to_decimal_formula",
    '=LET(bin,"11010110",digits,MAP(MID(bin,SEQUENCE(LEN(bin)),1),LAMBDA(d,VALUE(d))),powers,2^(LEN(bin)-SEQUENCE(LEN(bin))),SUMPRODUCT(digits,powers))', 214,
    ["binary_conversion", "manual", "map"],
    ["LET", "MAP", "MID", "SEQUENCE", "LEN", "LAMBDA", "VALUE", "SUMPRODUCT"],
    operators=["^", "-"], let_bindings=3, complexity="advanced",
    notes="Binary to decimal conversion: 11010110 = 128+64+16+4+2 = 214"))

entries.append(e("nested_complex", "standard_deviation_manual",
    '=LET(d,{2,4,4,4,5,5,7,9},n,COLUMNS(d),mu,AVERAGE(d),variance,SUM((d-mu)^2)/(n-1),ROUND(SQRT(variance),6))', 2.0,
    ["standard_deviation", "manual", "formula"],
    ["LET", "AVERAGE", "SUM", "SQRT", "COLUMNS", "ROUND"],
    operators=["-", "^", "/"], let_bindings=4, complexity="intermediate",
    notes="Manual std dev calculation for classic dataset {2,4,4,4,5,5,7,9}: σ=2.0"))

entries.append(e("nested_complex", "unique_permutation_count",
    '=LET(word,"MISSISSIPPI",chars,MID(word,SEQUENCE(LEN(word)),1),uChars,UNIQUE(chars),counts,MAP(uChars,LAMBDA(c,SUM(--(chars=c)))),FACT(LEN(word))/PRODUCT(MAP(counts,LAMBDA(n,FACT(n)))))', 34650,
    ["permutation", "multinomial", "string_analysis"],
    ["LET", "MID", "SEQUENCE", "LEN", "UNIQUE", "MAP", "LAMBDA", "SUM", "FACT", "PRODUCT"],
    operators=["=", "/", "--"], let_bindings=4, complexity="expert",
    notes="Unique permutations of MISSISSIPPI: 11!/(1!*4!*4!*2!) = 34650"))

entries.append(e("nested_complex", "linear_regression_slope",
    '=LET(x,{1,2,3,4,5},y,{2.1,3.9,6.2,7.8,10.1},n,COLUMNS(x),slope,(n*SUMPRODUCT(x,y)-SUM(x)*SUM(y))/(n*SUMSQ(x)-SUM(x)^2),ROUND(slope,2))', 1.98,
    ["linear_regression", "slope", "statistics"],
    ["LET", "SUMPRODUCT", "SUM", "SUMSQ", "COLUMNS", "ROUND"],
    operators=["*", "-", "/", "^"], let_bindings=3, complexity="advanced",
    notes="Manual slope calculation: m = (nΣxy - ΣxΣy)/(nΣx² - (Σx)²)"))

entries.append(e("nested_complex", "matrix_trace",
    '=LET(m,{1,2,3;4,5,6;7,8,9},SUM(MAP(SEQUENCE(3),LAMBDA(i,INDEX(m,i,i)))))', 15,
    ["matrix", "trace", "diagonal"],
    ["LET", "SUM", "MAP", "SEQUENCE", "LAMBDA", "INDEX"],
    let_bindings=1, complexity="intermediate",
    notes="Matrix trace (sum of diagonal): 1+5+9=15"))

entries.append(e("nested_complex", "matrix_transpose_manual",
    '=SUM(MAKEARRAY(2,3,LAMBDA(r,c,INDEX({1,2,3;4,5,6},c,r))))', 21,
    ["matrix", "transpose", "makearray"],
    ["SUM", "MAKEARRAY", "LAMBDA", "INDEX"],
    complexity="intermediate",
    notes="Manual transpose via MAKEARRAY: swap r,c in INDEX"))

entries.append(e("nested_complex", "recursive_power_fast",
    '=LET(fastpow,LAMBDA(self,LAMBDA(b,LAMBDA(e,IF(e=0,1,IF(MOD(e,2)=0,LET(half,self(self)(b)(e/2),half*half),b*self(self)(b)(e-1)))))),fastpow(fastpow)(2)(20))', 1048576,
    ["fast_exponentiation", "recursion", "divide_conquer"],
    ["LET", "LAMBDA", "IF", "MOD"], operators=["*", "/", "-", "="],
    let_bindings=2, complexity="expert",
    notes="Fast exponentiation by squaring: O(log n) multiplications. 2^20=1048576"))

entries.append(e("nested_complex", "isbn_checksum",
    '=LET(isbn,"013468599",digits,MAP(MID(isbn,SEQUENCE(9),1),LAMBDA(d,VALUE(d))),weights,SEQUENCE(9,,10,-1),check,11-MOD(SUMPRODUCT(digits,weights),11),IF(check=10,"X",TEXT(check,"0")))', "2",
    ["isbn", "checksum", "validation"],
    ["LET", "MAP", "MID", "SEQUENCE", "LAMBDA", "VALUE", "SUMPRODUCT", "MOD", "IF", "TEXT"],
    operators=["-"], let_bindings=4, complexity="advanced", expected_type="string",
    notes="ISBN-10 check digit calculation"))

entries.append(e("nested_complex", "luhn_check",
    '=LET(card,"79927398713",n,LEN(card),digits,MAP(SEQUENCE(n),LAMBDA(i,VALUE(MID(card,i,1)))),doubled,MAP(SEQUENCE(n),LAMBDA(i,LET(d,INDEX(digits,n-i+1),pos,i,IF(MOD(pos,2)=0,IF(d*2>9,d*2-9,d*2),d)))),MOD(SUM(doubled),10)=0)', True,
    ["luhn", "credit_card", "checksum"],
    ["LET", "LEN", "MAP", "SEQUENCE", "LAMBDA", "VALUE", "MID", "INDEX", "IF", "MOD", "SUM"],
    operators=["*", "-", ">", "="], let_bindings=5, complexity="expert", expected_type="boolean",
    notes="Luhn algorithm for credit card validation: 79927398713 is valid"))

entries.append(e("nested_complex", "nth_triangular_number",
    '=LET(n,100,n*(n+1)/2)', 5050,
    ["triangular_number", "gauss"],
    ["LET"], operators=["*", "+", "/"],
    let_bindings=1,
    notes="100th triangular number: n(n+1)/2 = 5050 (Gauss's formula)"))

entries.append(e("nested_complex", "array_flatten_filter_rank",
    '=LET(m,{3,7,1;8,2,9;4,6,5},flat,TOCOL(m),sorted,SORT(flat,-1),INDEX(sorted,3))', 7,
    ["flatten", "sort", "rank", "pipeline"],
    ["LET", "TOCOL", "SORT", "INDEX"],
    let_bindings=3, complexity="intermediate",
    notes="Flatten matrix, sort descending, get 3rd largest: 9,8,7 → 7"))

entries.append(e("nested_complex", "cumulative_distribution",
    '=LET(data,{1,2,3,4,5,6,7,8,9,10},n,COLUMNS(data),cdf,SCAN(0,data,LAMBDA(acc,x,acc+1/n)),INDEX(cdf,5))', 0.5,
    ["cumulative_distribution", "empirical_cdf"],
    ["LET", "SCAN", "LAMBDA", "INDEX", "COLUMNS"],
    operators=["+", "/"], let_bindings=3, complexity="intermediate",
    notes="Empirical CDF at 5th element: 5/10=0.5"))

entries.append(e("nested_complex", "count_words",
    '=LET(s,"  hello  world  foo  bar  ",trimmed,TRIM(s),LEN(trimmed)-LEN(SUBSTITUTE(trimmed," ",""))+1)', 4,
    ["word_count", "string_manipulation"],
    ["LET", "TRIM", "LEN", "SUBSTITUTE"], operators=["-", "+"],
    let_bindings=2, complexity="intermediate",
    notes="Count words by counting spaces in trimmed string + 1"))

entries.append(e("nested_complex", "roman_numeral_stress",
    '=LEN(ROMAN(3999))', 15,
    ["roman", "max_value", "stress"],
    ["LEN", "ROMAN"],
    notes="ROMAN(3999) = MMMCMXCIX (15 chars) — maximum valid input"))

entries.append(e("nested_complex", "recursive_list_reverse",
    '=LET(rev,LAMBDA(self,LAMBDA(arr,IF(COLUMNS(arr)<=1,arr,HSTACK(self(self)(DROP(arr,,1)),TAKE(arr,,1))))),SUM(rev(rev)({1,2,3,4,5})))', 15,
    ["array_reverse", "recursion", "hstack"],
    ["LET", "LAMBDA", "IF", "COLUMNS", "HSTACK", "DROP", "TAKE", "SUM"],
    operators=["<="], let_bindings=1, complexity="expert",
    notes="Recursive array reversal via TAKE+DROP+HSTACK; sum preserves: 15"))

entries.append(e("nested_complex", "recursive_flatten_nested",
    '=LET(data,{1,2,3;4,5,6;7,8,9},flat,TOCOL(data),SUM(FILTER(flat,flat>5)))', 30,
    ["flatten", "filter", "conditional_sum"],
    ["LET", "TOCOL", "SUM", "FILTER"], operators=[">"],
    let_bindings=2, complexity="intermediate",
    notes="Flatten then filter >5: {6,7,8,9}, sum=30"))

entries.append(e("nested_complex", "newton_cube_root",
    '=LET(target,27,step,LAMBDA(self,LAMBDA(x,LAMBDA(n,IF(n=0,x,self(self)((2*x+target/(x*x))/3)(n-1))))),ROUND(step(step)(1)(20),6))', 3,
    ["newton_method", "cube_root", "iteration"],
    ["LET", "LAMBDA", "IF", "ROUND"], operators=["*", "/", "+", "-", "="],
    let_bindings=2, complexity="expert",
    notes="Newton's method for cube root of 27: x_{n+1} = (2x + a/x²)/3"))

entries[-1]["expected_result"] = 3.0

entries.append(e("nested_complex", "golden_ratio_continued_fraction",
    '=LET(step,LAMBDA(self,LAMBDA(n,IF(n=0,1,1+1/self(self)(n-1)))),ROUND(step(step)(20),10))', 1.6180339887,
    ["golden_ratio", "continued_fraction", "recursion"],
    ["LET", "LAMBDA", "IF", "ROUND"], operators=["+", "/", "-", "="],
    let_bindings=1, complexity="advanced",
    notes="Golden ratio φ via continued fraction: 1+1/(1+1/(1+1/...))"))

entries.append(e("nested_complex", "sum_of_proper_divisors",
    '=LET(n,28,divisors,FILTER(SEQUENCE(n-1),MOD(n,SEQUENCE(n-1))=0),SUM(divisors))', 28,
    ["perfect_number", "divisors"],
    ["LET", "FILTER", "SEQUENCE", "MOD", "SUM"], operators=["=", "-"],
    let_bindings=2, complexity="intermediate",
    notes="Sum of proper divisors of 28 = 1+2+4+7+14 = 28 (perfect number!)"))

entries.append(e("nested_complex", "base_conversion_to_hex",
    '=LET(n,255,hexChars,"0123456789ABCDEF",result,LAMBDA(self,LAMBDA(val,IF(val<16,MID(hexChars,val+1,1),self(self)(INT(val/16))&MID(hexChars,MOD(val,16)+1,1)))),result(result)(n))', "FF",
    ["base_conversion", "hexadecimal", "recursion"],
    ["LET", "LAMBDA", "IF", "MID", "INT", "MOD"], operators=["&", "/", "+", "<"],
    let_bindings=3, complexity="expert", expected_type="string",
    notes="Recursive decimal to hex: 255 = FF"))

entries.append(e("nested_complex", "array_intersection",
    '=SUM(FILTER({1,2,3,4,5},ISNUMBER(XMATCH({1,2,3,4,5},{2,4,6,8}))))', 6,
    ["set_intersection", "filter", "xmatch"],
    ["SUM", "FILTER", "ISNUMBER", "XMATCH"],
    complexity="intermediate",
    notes="Set intersection of {1,2,3,4,5} ∩ {2,4,6,8} = {2,4}, sum=6"))

entries.append(e("nested_complex", "array_difference",
    '=SUM(FILTER({1,2,3,4,5},ISNA(XMATCH({1,2,3,4,5},{2,4,6,8}))))', 9,
    ["set_difference", "filter", "xmatch"],
    ["SUM", "FILTER", "ISNA", "XMATCH"],
    complexity="intermediate",
    notes="Set difference {1,2,3,4,5} \\ {2,4,6,8} = {1,3,5}, sum=9"))

entries.append(e("nested_complex", "encode_decode_roundtrip",
    '=LET(msg,"HELLO",encoded,MAP(MID(msg,SEQUENCE(LEN(msg)),1),LAMBDA(c,CODE(c))),decoded,MAP(encoded,LAMBDA(n,CHAR(n))),TEXTJOIN("",TRUE,decoded))', "HELLO",
    ["encode_decode", "roundtrip", "map"],
    ["LET", "MAP", "MID", "SEQUENCE", "LEN", "LAMBDA", "CODE", "CHAR", "TEXTJOIN"],
    let_bindings=3, complexity="advanced", expected_type="string",
    notes="Encode string to char codes and back: roundtrip identity test"))

entries.append(e("nested_complex", "fibonacci_closed_form_binet",
    '=LET(n,10,phi,(1+SQRT(5))/2,psi,(1-SQRT(5))/2,ROUND((phi^n-psi^n)/SQRT(5),0))', 55,
    ["fibonacci", "binet", "closed_form"],
    ["LET", "SQRT", "ROUND"], operators=["+", "-", "/", "^"],
    let_bindings=3, complexity="intermediate",
    notes="Binet's formula: F(n) = (φ^n - ψ^n)/√5 where φ=(1+√5)/2"))

entries.append(e("nested_complex", "statistics_dashboard",
    '=LET(d,{23,45,12,67,89,34,56,78,90,11},n,COLUMNS(d),mu,AVERAGE(d),med,MEDIAN(d),sd,STDEV(d),mn,MIN(d),mx,MAX(d),rng,mx-mn,mu+med+mn+mx)', 222.5,
    ["statistics", "dashboard", "combined"],
    ["LET", "AVERAGE", "MEDIAN", "STDEV", "MIN", "MAX", "COLUMNS"],
    operators=["-", "+"], let_bindings=8, complexity="intermediate",
    notes="Combined statistics: mean=50.5, median=50.5, min=11, max=90 → sum=202.5. Let me recheck: sorted={11,12,23,34,45,56,67,78,89,90}, mean=50.5, median=(45+56)/2=50.5, min=11, max=90 → 50.5+50.5+11+90=202"))

# Recalculate: (23+45+12+67+89+34+56+78+90+11)/10 = 505/10 = 50.5
# median = (45+56)/2 = 50.5
# min=11, max=90
# 50.5+50.5+11+90 = 202
entries[-1]["expected_result"] = 202

entries.append(e("nested_complex", "sigmoid_function",
    '=LET(sigmoid,LAMBDA(x,1/(1+EXP(-x))),ROUND(sigmoid(0),1))', 0.5,
    ["sigmoid", "neural_network", "activation"],
    ["LET", "LAMBDA", "EXP", "ROUND"], operators=["/", "+", "-"],
    let_bindings=1, complexity="intermediate",
    notes="Sigmoid function σ(0) = 1/(1+e^0) = 0.5"))

entries.append(e("nested_complex", "softmax_basic",
    '=LET(x,{1,2,3},ex,EXP(x),sm,ex/SUM(ex),ROUND(INDEX(sm,3),6))', 0.665241,
    ["softmax", "neural_network", "probability"],
    ["LET", "EXP", "SUM", "ROUND", "INDEX"], operators=["/"],
    let_bindings=3, complexity="advanced",
    notes="Softmax of {1,2,3}: largest element gets ~66.5% probability"))

entries.append(e("nested_complex", "mandelbrot_single_point",
    '=LET(cr,-0.5,ci,0.5,iterate,LAMBDA(self,LAMBDA(zr,LAMBDA(zi,LAMBDA(n,IF(OR(n>=20,zr*zr+zi*zi>4),n,self(self)(zr*zr-zi*zi+cr)(2*zr*zi+ci)(n+1)))))),iterate(iterate)(0)(0)(0))', 5,
    ["mandelbrot", "complex_iteration", "fractal"],
    ["LET", "LAMBDA", "IF", "OR"], operators=["*", "-", "+", ">", ">="],
    let_bindings=3, complexity="expert",
    notes="Single-point Mandelbrot iteration: z_{n+1} = z² + c where c = -0.5+0.5i. Escapes at iteration 5."))

# --- Finally, some formulas that test sheer formula LENGTH ---
entries.append(e("nested_complex", "long_formula_stress",
    '=LET(a,1,b,a+a,c,b+b,d,c+c,e,d+d,f,e+e,g,f+f,h,g+g,i,h+h,j,i+i,k,j+j,l,k+k,m,l+l,n,m+m,o,n+n,p,o+o,q,p+p,r,q+q,s,r+r,t,s+s,t)', 1048576,
    ["long_formula", "let_chain", "doubling", "stress"],
    ["LET"], operators=["+"],
    let_bindings=20, complexity="advanced",
    notes="20-deep LET chain, each doubling: 2^20 = 1048576. Tests max LET bindings."))

# Write all entries
with open(JSONL_PATH, "a", encoding="utf-8") as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

total = existing + len(entries)
print(f"Appended {len(entries)} entries (FTC-{existing+1:04d} to FTC-{total:04d})")
print(f"Total entries in file: {total}")
