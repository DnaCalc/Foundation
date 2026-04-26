#!/usr/bin/env python3
"""Generate the formula test corpus entries for reference/test-corpus/formula/single-cell/formulas.jsonl.

This script appends entries starting from the given start_id.
Run: python3 tools/gen_corpus.py
"""
import json
import sys
import math

OUTPUT = "reference/test-corpus/formula/single-cell/formulas.jsonl"

def e(test_id, formula, category, subcategory, tags, complexity, funcs, ops, result, rtype, error=None, is_array=False, dims=None, let_bind=None, det=True, locale=None, datesys=None, creqs=None, eids=None, sids=None, prov="authored", prov_detail="Hand-authored from Excel function documentation", notes=None):
    return {
        "test_id": test_id,
        "formula": formula,
        "category": category,
        "subcategory": subcategory,
        "tags": tags,
        "complexity": complexity,
        "functions_exercised": funcs,
        "operators_exercised": ops,
        "expected_result": result,
        "expected_result_type": rtype,
        "expected_error": error,
        "result_is_array": is_array,
        "array_dimensions": dims,
        "let_bindings": let_bind,
        "deterministic": det,
        "requires_locale": locale,
        "requires_date_system": datesys,
        "conformance_req_ids": creqs or [],
        "evidence_ids": eids or [],
        "source_ids": sids or ["R-SRC-040"],
        "provenance": prov,
        "provenance_detail": prov_detail,
        "notes": notes,
    }

def ftc(n):
    return f"FTC-{n:04d}"

entries = []
n = 161  # start after existing 160

# ============================================================
# ARRAY CONSTANT LITERALS (FTC-0161 to FTC-0190)
# ============================================================
cat = "array_constant_literal"
sid = ["R-SRC-043"]
pd = "Hand-authored from MS-XLSX array constant syntax rules"

entries.append(e(ftc(n), '=SUM({1,2,3})', cat, "basic_array", ["array_constant"], "trivial", ["SUM"], [], 6, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM({1;2;3})', cat, "basic_array", ["array_constant"], "trivial", ["SUM"], [], 6, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM({1,2,3;4,5,6})', cat, "basic_array", ["array_constant"], "simple", ["SUM"], [], 21, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=AVERAGE({10,20,30})', cat, "basic_array", ["array_constant"], "trivial", ["AVERAGE"], [], 20, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MAX({-5,0,5,10})', cat, "basic_array", ["array_constant"], "trivial", ["MAX"], [], 10, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MIN({100,200,50})', cat, "basic_array", ["array_constant"], "trivial", ["MIN"], [], 50, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COUNT({1,"a",TRUE,2})', cat, "basic_array", ["array_constant"], "simple", ["COUNT"], [], 2, "number", sids=sid, prov_detail=pd, notes="COUNT counts only numeric values")); n+=1
entries.append(e(ftc(n), '=COUNTA({1,"a",TRUE,2})', cat, "basic_array", ["array_constant"], "simple", ["COUNTA"], [], 4, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=INDEX({10,20,30},1,2)', cat, "array_in_function", ["array_constant"], "simple", ["INDEX"], [], 20, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=INDEX({"a";"b";"c"},2,1)', cat, "array_in_function", ["array_constant"], "simple", ["INDEX"], [], "b", "text", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SMALL({5,3,8,1,9},2)', cat, "array_in_function", ["array_constant"], "simple", ["SMALL"], [], 3, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LARGE({5,3,8,1,9},2)', cat, "array_in_function", ["array_constant"], "simple", ["LARGE"], [], 8, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUMPRODUCT({1,2,3},{4,5,6})', cat, "array_in_function", ["array_constant"], "simple", ["SUMPRODUCT"], [], 32, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MATCH(3,{1,2,3,4,5},0)', cat, "array_in_function", ["array_constant"], "simple", ["MATCH"], [], 3, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MEDIAN({1,2,3,4,5})', cat, "array_in_function", ["array_constant"], "simple", ["MEDIAN"], [], 3, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM(IF({TRUE,FALSE,TRUE},{10,20,30},0))', cat, "nested_array", ["array_constant"], "moderate", ["SUM","IF"], [], 40, "number", sids=sid, prov_detail=pd, notes="IF returns {10,0,30}")); n+=1
entries.append(e(ftc(n), '=TEXTJOIN(",",TRUE,{"a","b","c"})', cat, "nested_array", ["array_constant"], "simple", ["TEXTJOIN"], [], "a,b,c", "text", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXTJOIN("-",FALSE,{1,2,3})', cat, "nested_array", ["array_constant"], "simple", ["TEXTJOIN"], [], "1-2-3", "text", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM(--{TRUE,FALSE,TRUE,TRUE})', cat, "nested_array", ["array_constant","coercion"], "moderate", ["SUM"], ["--"], 3, "number", sids=sid, prov_detail=pd, notes="Double unary negation coerces booleans")); n+=1
entries.append(e(ftc(n), '=CONCAT({"a","b","c"})', cat, "nested_array", ["array_constant"], "simple", ["CONCAT"], [], "abc", "text", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM({1,2;3,4}*{10,10;10,10})', cat, "nested_array", ["array_constant"], "moderate", ["SUM"], ["*"], 100, "number", sids=sid, prov_detail=pd, notes="Element-wise: {10,20;30,40}")); n+=1
entries.append(e(ftc(n), '=LET(arr,{1,2,3;4,5,6},SUM(arr))', cat, "nested_array", ["array_constant","let"], "moderate", ["LET","SUM"], [], 21, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM({1,TRUE,3})', cat, "array_type_mixed", ["array_constant","coercion"], "simple", ["SUM"], [], 5, "number", sids=sid, prov_detail=pd, notes="TRUE coerced to 1")); n+=1
entries.append(e(ftc(n), '=TYPE({1,2})', cat, "array_type_mixed", ["array_constant"], "trivial", ["TYPE"], [], 64, "number", sids=sid, prov_detail=pd, notes="TYPE returns 64 for arrays")); n+=1
entries.append(e(ftc(n), '=ROWS({1;2;3})', cat, "array_type_mixed", ["array_constant"], "trivial", ["ROWS"], [], 3, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COLUMNS({1,2,3})', cat, "array_type_mixed", ["array_constant"], "trivial", ["COLUMNS"], [], 3, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROWS({1,2;3,4;5,6})', cat, "array_type_mixed", ["array_constant"], "simple", ["ROWS"], [], 3, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COLUMNS({1,2;3,4;5,6})', cat, "array_type_mixed", ["array_constant"], "simple", ["COLUMNS"], [], 2, "number", sids=sid, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM({1,"x",3})', cat, "array_type_mixed", ["array_constant","coercion"], "simple", ["SUM"], [], 4, "number", sids=sid, prov_detail=pd, notes="Text ignored by SUM")); n+=1
entries.append(e(ftc(n), '=PRODUCT({2,3,4})', cat, "basic_array", ["array_constant"], "trivial", ["PRODUCT"], [], 24, "number", sids=sid, prov_detail=pd)); n+=1

# ============================================================
# MATH/TRIG (FTC-0191 to FTC-0270) ~80 entries
# ============================================================
cat = "math_trig"
pd = "Hand-authored from Excel math/trig function documentation"

entries.append(e(ftc(n), '=ABS(-42)', cat, "abs", ["math"], "trivial", ["ABS"], [], 42, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ABS(0)', cat, "abs", ["math"], "trivial", ["ABS"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SIGN(-5)', cat, "sign", ["math"], "trivial", ["SIGN"], [], -1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SIGN(0)', cat, "sign", ["math"], "trivial", ["SIGN"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SIGN(99)', cat, "sign", ["math"], "trivial", ["SIGN"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROUND(2.5,0)', cat, "rounding", ["math","rounding"], "simple", ["ROUND"], [], 2, "number", prov_detail=pd, notes="Banker rounding: 2.5 rounds to 2")); n+=1
entries.append(e(ftc(n), '=ROUND(3.5,0)', cat, "rounding", ["math","rounding"], "simple", ["ROUND"], [], 4, "number", prov_detail=pd, notes="Banker rounding: 3.5 rounds to 4")); n+=1
entries.append(e(ftc(n), '=ROUND(2.149,1)', cat, "rounding", ["math","rounding"], "simple", ["ROUND"], [], 2.1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROUND(-1.475,2)', cat, "rounding", ["math","rounding"], "simple", ["ROUND"], [], -1.48, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROUNDUP(2.1,0)', cat, "rounding", ["math","rounding"], "simple", ["ROUNDUP"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROUNDDOWN(2.9,0)', cat, "rounding", ["math","rounding"], "simple", ["ROUNDDOWN"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MROUND(10,3)', cat, "rounding", ["math","rounding"], "simple", ["MROUND"], [], 9, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CEILING(2.5,1)', cat, "rounding", ["math","rounding"], "simple", ["CEILING"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FLOOR(2.5,1)', cat, "rounding", ["math","rounding"], "simple", ["FLOOR"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CEILING.MATH(-4.1)', cat, "rounding", ["math","rounding"], "simple", ["CEILING.MATH"], [], -4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FLOOR.MATH(-4.1)', cat, "rounding", ["math","rounding"], "simple", ["FLOOR.MATH"], [], -5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=INT(8.9)', cat, "rounding", ["math"], "trivial", ["INT"], [], 8, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=INT(-8.9)', cat, "rounding", ["math"], "simple", ["INT"], [], -9, "number", prov_detail=pd, notes="INT rounds toward negative infinity")); n+=1
entries.append(e(ftc(n), '=TRUNC(8.9)', cat, "rounding", ["math"], "trivial", ["TRUNC"], [], 8, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TRUNC(-8.9)', cat, "rounding", ["math"], "simple", ["TRUNC"], [], -8, "number", prov_detail=pd, notes="TRUNC truncates toward zero")); n+=1
entries.append(e(ftc(n), '=MOD(10,3)', cat, "mod", ["math"], "trivial", ["MOD"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MOD(-10,3)', cat, "mod", ["math"], "simple", ["MOD"], [], 2, "number", prov_detail=pd, notes="MOD result has sign of divisor")); n+=1
entries.append(e(ftc(n), '=MOD(10,-3)', cat, "mod", ["math"], "simple", ["MOD"], [], -2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=QUOTIENT(10,3)', cat, "mod", ["math"], "simple", ["QUOTIENT"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=POWER(2,10)', cat, "power", ["math"], "trivial", ["POWER"], [], 1024, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SQRT(144)', cat, "roots", ["math"], "trivial", ["SQRT"], [], 12, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SQRT(-1)', cat, "roots", ["math"], "simple", ["SQRT"], [], None, "error", error="#NUM!", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LOG(100,10)', cat, "logarithm", ["math"], "simple", ["LOG"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LOG(1)', cat, "logarithm", ["math"], "simple", ["LOG"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LN(EXP(1))', cat, "logarithm", ["math"], "simple", ["LN","EXP"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LOG10(1000)', cat, "logarithm", ["math"], "simple", ["LOG10"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=EXP(0)', cat, "exponential", ["math"], "trivial", ["EXP"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PI()', cat, "constants", ["math"], "trivial", ["PI"], [], 3.14159265358979, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SIN(0)', cat, "trig", ["trig"], "trivial", ["SIN"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COS(0)', cat, "trig", ["trig"], "trivial", ["COS"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TAN(0)', cat, "trig", ["trig"], "trivial", ["TAN"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SIN(PI()/2)', cat, "trig", ["trig"], "simple", ["SIN","PI"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COS(PI())', cat, "trig", ["trig"], "simple", ["COS","PI"], [], -1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ASIN(1)', cat, "trig", ["trig"], "simple", ["ASIN"], [], 1.5707963267949, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ATAN2(1,1)', cat, "trig", ["trig"], "simple", ["ATAN2"], [], 0.785398163397448, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DEGREES(PI())', cat, "trig", ["trig"], "simple", ["DEGREES","PI"], [], 180, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RADIANS(180)', cat, "trig", ["trig"], "simple", ["RADIANS"], [], 3.14159265358979, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FACT(10)', cat, "combinatorial", ["math"], "simple", ["FACT"], [], 3628800, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FACT(0)', cat, "combinatorial", ["math"], "trivial", ["FACT"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COMBIN(10,3)', cat, "combinatorial", ["math"], "simple", ["COMBIN"], [], 120, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PERMUT(5,3)', cat, "combinatorial", ["math"], "simple", ["PERMUT"], [], 60, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=GCD(12,18)', cat, "number_theory", ["math"], "simple", ["GCD"], [], 6, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LCM(4,6)', cat, "number_theory", ["math"], "simple", ["LCM"], [], 12, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=EVEN(3)', cat, "rounding", ["math"], "trivial", ["EVEN"], [], 4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ODD(4)', cat, "rounding", ["math"], "trivial", ["ODD"], [], 5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM({1,2,3,4,5})', cat, "sum", ["math","array_constant"], "trivial", ["SUM"], [], 15, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUMPRODUCT({1,2,3},{4,5,6})', cat, "sum", ["math"], "simple", ["SUMPRODUCT"], [], 32, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUMSQ({3,4})', cat, "sum", ["math"], "simple", ["SUMSQ"], [], 25, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=AGGREGATE(1,6,{1,2,3})', cat, "aggregate", ["math"], "moderate", ["AGGREGATE"], [], 1, "number", prov_detail=pd, notes="AGGREGATE function 1=AVERAGE, option 6=ignore errors; AVG({1,2,3})=2... wait, fn 1 is AVERAGE")); n+=1
# Fix: AGGREGATE(9,6,{1,2,3},1) = SMALL with k=1 = 1. Let me use simpler ones.
entries[-1] = e(ftc(n-1), '=AGGREGATE(4,6,{5,3,8})', cat, "aggregate", ["math"], "moderate", ["AGGREGATE"], [], 8, "number", prov_detail=pd, notes="AGGREGATE fn 4=MAX, option 6=ignore errors")
entries.append(e(ftc(n), '=PRODUCT({2,3,4})', cat, "product", ["math"], "trivial", ["PRODUCT"], [], 24, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROMAN(2024)', cat, "conversion", ["math"], "simple", ["ROMAN"], [], "MMXXIV", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ARABIC("MCMXCIX")', cat, "conversion", ["math"], "simple", ["ARABIC"], [], 1999, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BASE(255,16)', cat, "conversion", ["math"], "simple", ["BASE"], [], "FF", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DECIMAL("FF",16)', cat, "conversion", ["math"], "simple", ["DECIMAL"], [], 255, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RANDBETWEEN(1,1)', cat, "random", ["math","non_deterministic"], "trivial", ["RANDBETWEEN"], [], 1, "number", det=True, prov_detail=pd, notes="RANDBETWEEN(1,1) is deterministic")); n+=1
entries.append(e(ftc(n), '=LET(x,RAND(),AND(x>=0,x<1))', cat, "random", ["math","non_deterministic"], "simple", ["LET","RAND","AND"], [], True, "logical", det=False, prov_detail=pd, notes="RAND is in [0,1) so result is always TRUE")); n+=1
entries.append(e(ftc(n), '=SUBTOTAL(9,{1,2,3})', cat, "subtotal", ["math"], "simple", ["SUBTOTAL"], [], 6, "number", prov_detail=pd, notes="SUBTOTAL fn 9=SUM")); n+=1
entries.append(e(ftc(n), '=SUBTOTAL(1,{10,20,30})', cat, "subtotal", ["math"], "simple", ["SUBTOTAL"], [], 20, "number", prov_detail=pd, notes="SUBTOTAL fn 1=AVERAGE")); n+=1
entries.append(e(ftc(n), '=MULTINOMIAL(2,3,4)', cat, "combinatorial", ["math"], "moderate", ["MULTINOMIAL"], [], 1260, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SERIESSUM(1,0,1,{1,-1,1,-1})', cat, "series", ["math"], "moderate", ["SERIESSUM"], [], 0, "number", prov_detail=pd, notes="1-1+1-1=0")); n+=1
entries.append(e(ftc(n), '=SUMPRODUCT(--({1,2,3}>1))', cat, "sum", ["math","coercion"], "moderate", ["SUMPRODUCT"], ["--",">"], 2, "number", prov_detail=pd, notes="Counts elements >1")); n+=1
entries.append(e(ftc(n), '=LET(d,{1,2,3,4,5},SUMPRODUCT(d,d))', cat, "sum", ["math","let"], "moderate", ["LET","SUMPRODUCT"], [], 55, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CEILING.PRECISE(-4.1,2)', cat, "rounding", ["math","rounding"], "moderate", ["CEILING.PRECISE"], [], -4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FLOOR.PRECISE(-4.1,2)', cat, "rounding", ["math","rounding"], "moderate", ["FLOOR.PRECISE"], [], -6, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ROUND(2.15,1)', cat, "rounding", ["math","rounding","floating_point"], "simple", ["ROUND"], [], 2.2, "number", prov_detail=pd, notes="Floating point representation issue: 2.15 in binary")); n+=1

# ============================================================
# TEXT/STRING (FTC-0271 to FTC-0350) ~80 entries
# ============================================================
cat = "text_string"
pd = "Hand-authored from Excel text function documentation"

entries.append(e(ftc(n), '=LEN("Hello")', cat, "len", ["text"], "trivial", ["LEN"], [], 5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LEN("")', cat, "len", ["text"], "trivial", ["LEN"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LEFT("Hello",3)', cat, "substring", ["text"], "trivial", ["LEFT"], [], "Hel", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RIGHT("Hello",2)', cat, "substring", ["text"], "trivial", ["RIGHT"], [], "lo", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MID("Hello",2,3)', cat, "substring", ["text"], "simple", ["MID"], [], "ell", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=UPPER("hello")', cat, "case", ["text"], "trivial", ["UPPER"], [], "HELLO", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LOWER("HELLO")', cat, "case", ["text"], "trivial", ["LOWER"], [], "hello", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PROPER("hello world")', cat, "case", ["text"], "simple", ["PROPER"], [], "Hello World", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TRIM("  hello  world  ")', cat, "trim", ["text"], "simple", ["TRIM"], [], "hello world", "text", prov_detail=pd, notes="TRIM removes leading/trailing and reduces internal spaces to single")); n+=1
entries.append(e(ftc(n), '=CLEAN(CHAR(9)&"text")', cat, "clean", ["text"], "simple", ["CLEAN","CHAR"], [], "text", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FIND("l","Hello")', cat, "find_search", ["text"], "simple", ["FIND"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SEARCH("L","Hello")', cat, "find_search", ["text"], "simple", ["SEARCH"], [], 3, "number", prov_detail=pd, notes="SEARCH is case-insensitive")); n+=1
entries.append(e(ftc(n), '=FIND("x","Hello")', cat, "find_search", ["text"], "simple", ["FIND"], [], None, "error", error="#VALUE!", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SEARCH("*","Hello")', cat, "find_search", ["text"], "simple", ["SEARCH"], [], 1, "number", prov_detail=pd, notes="SEARCH supports wildcards; * matches at position 1")); n+=1
entries.append(e(ftc(n), '=SUBSTITUTE("Hello World","World","Excel")', cat, "substitute", ["text"], "simple", ["SUBSTITUTE"], [], "Hello Excel", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUBSTITUTE("aaa","a","b",2)', cat, "substitute", ["text"], "moderate", ["SUBSTITUTE"], [], "aba", "text", prov_detail=pd, notes="Replace only 2nd occurrence")); n+=1
entries.append(e(ftc(n), '=REPLACE("Hello",2,3,"XY")', cat, "replace", ["text"], "simple", ["REPLACE"], [], "HXYo", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=REPT("ab",3)', cat, "repeat", ["text"], "trivial", ["REPT"], [], "ababab", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=REPT("x",0)', cat, "repeat", ["text"], "trivial", ["REPT"], [], "", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CONCATENATE("a","b","c")', cat, "concat", ["text"], "trivial", ["CONCATENATE"], [], "abc", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CONCAT("a","b","c")', cat, "concat", ["text"], "trivial", ["CONCAT"], [], "abc", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXTJOIN(", ",TRUE,{"a","b","","c"})', cat, "concat", ["text"], "moderate", ["TEXTJOIN"], [], "a, b, c", "text", prov_detail=pd, notes="ignore_empty=TRUE skips empty strings")); n+=1
entries.append(e(ftc(n), '=TEXTJOIN(", ",FALSE,{"a","b","","c"})', cat, "concat", ["text"], "moderate", ["TEXTJOIN"], [], "a, b, , c", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=EXACT("Hello","hello")', cat, "comparison", ["text"], "simple", ["EXACT"], [], False, "logical", prov_detail=pd, notes="EXACT is case-sensitive")); n+=1
entries.append(e(ftc(n), '=EXACT("Hello","Hello")', cat, "comparison", ["text"], "simple", ["EXACT"], [], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXT(0.75,"0.00%")', cat, "text_format", ["text","formatting"], "moderate", ["TEXT"], [], "75.00%", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXT(44927,"yyyy-mm-dd")', cat, "text_format", ["text","date"], "moderate", ["TEXT"], [], "2023-01-01", "text", prov_detail=pd, datesys="1900")); n+=1
entries.append(e(ftc(n), '=TEXT(1234567.89,"#,##0.00")', cat, "text_format", ["text","formatting"], "moderate", ["TEXT"], [], "1,234,567.89", "text", locale="en-US", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=VALUE("123.45")', cat, "conversion", ["text"], "simple", ["VALUE"], [], 123.45, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=VALUE("abc")', cat, "conversion", ["text"], "simple", ["VALUE"], [], None, "error", error="#VALUE!", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=NUMBERVALUE("1.234,56",",",".")', cat, "conversion", ["text","locale"], "moderate", ["NUMBERVALUE"], [], 1234.56, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=VALUETOTEXT(123)', cat, "conversion", ["text"], "simple", ["VALUETOTEXT"], [], "123", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=VALUETOTEXT(TRUE)', cat, "conversion", ["text"], "simple", ["VALUETOTEXT"], [], "TRUE", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CODE("A")', cat, "char_code", ["text"], "trivial", ["CODE"], [], 65, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CHAR(65)', cat, "char_code", ["text"], "trivial", ["CHAR"], [], "A", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=UNICODE("A")', cat, "char_code", ["text"], "trivial", ["UNICODE"], [], 65, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=UNICHAR(8364)', cat, "char_code", ["text"], "simple", ["UNICHAR"], [], "\u20ac", "text", prov_detail=pd, notes="Euro sign")); n+=1
entries.append(e(ftc(n), '=TEXTBEFORE("Hello-World","-")', cat, "textbefore_after", ["text"], "simple", ["TEXTBEFORE"], [], "Hello", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXTAFTER("Hello-World","-")', cat, "textbefore_after", ["text"], "simple", ["TEXTAFTER"], [], "World", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXTSPLIT("a,b,c",",")', cat, "textsplit", ["text","dynamic_array"], "moderate", ["TEXTSPLIT"], [], None, "array", is_array=True, dims="1x3", prov_detail=pd, notes="Returns {\"a\",\"b\",\"c\"}")); n+=1
entries.append(e(ftc(n), '=LET(s,TEXTSPLIT("a,b,c",","),INDEX(s,1,2))', cat, "textsplit", ["text","let"], "moderate", ["LET","TEXTSPLIT","INDEX"], [], "b", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUBSTITUTE("Mississippi","ss","XX",1)', cat, "substitute", ["text"], "moderate", ["SUBSTITUTE"], [], "MiXXissippi", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LEFT("Hello",100)', cat, "substring", ["text"], "simple", ["LEFT"], [], "Hello", "text", prov_detail=pd, notes="num_chars > string length returns full string")); n+=1
entries.append(e(ftc(n), '=MID("Hello",1,0)', cat, "substring", ["text"], "simple", ["MID"], [], "", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(t,"2024-01-15",TEXTBEFORE(TEXTAFTER(t,"-"),"-"))', cat, "textbefore_after", ["text","let"], "moderate", ["LET","TEXTBEFORE","TEXTAFTER"], [], "01", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TEXTJOIN("",FALSE,CHAR({72,101,108,108,111}))', cat, "concat", ["text"], "moderate", ["TEXTJOIN","CHAR"], [], "Hello", "text", prov_detail=pd)); n+=1

# ============================================================
# DATE/TIME (FTC-0351 to FTC-0410) ~60 entries
# ============================================================
cat = "date_time"
pd = "Hand-authored from Excel date/time function documentation"

entries.append(e(ftc(n), '=DATE(2024,1,15)', cat, "date_construct", ["date"], "trivial", ["DATE"], [], 45306, "date_serial", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DATE(2024,13,1)', cat, "date_construct", ["date"], "simple", ["DATE"], [], 45658, "date_serial", datesys="1900", prov_detail=pd, notes="Month 13 rolls over to Jan next year")); n+=1
entries.append(e(ftc(n), '=DATE(2024,1,32)', cat, "date_construct", ["date"], "simple", ["DATE"], [], 45323, "date_serial", datesys="1900", prov_detail=pd, notes="Day 32 rolls over to Feb 1")); n+=1
entries.append(e(ftc(n), '=DATE(2024,0,1)', cat, "date_construct", ["date"], "simple", ["DATE"], [], 45261, "date_serial", datesys="1900", prov_detail=pd, notes="Month 0 = Dec of prior year")); n+=1
entries.append(e(ftc(n), '=YEAR(45306)', cat, "date_extract", ["date"], "trivial", ["YEAR"], [], 2024, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MONTH(45306)', cat, "date_extract", ["date"], "trivial", ["MONTH"], [], 1, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DAY(45306)', cat, "date_extract", ["date"], "trivial", ["DAY"], [], 15, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=WEEKDAY(45306)', cat, "date_extract", ["date"], "simple", ["WEEKDAY"], [], 2, "number", datesys="1900", prov_detail=pd, notes="2024-01-15 is Monday, return_type 1 default: Sunday=1, Monday=2")); n+=1
entries.append(e(ftc(n), '=WEEKDAY(45306,2)', cat, "date_extract", ["date"], "simple", ["WEEKDAY"], [], 1, "number", datesys="1900", prov_detail=pd, notes="return_type 2: Monday=1")); n+=1
entries.append(e(ftc(n), '=WEEKNUM(45306)', cat, "date_extract", ["date"], "simple", ["WEEKNUM"], [], 3, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ISOWEEKNUM(45306)', cat, "date_extract", ["date"], "simple", ["ISOWEEKNUM"], [], 3, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DATEVALUE("2024-01-15")', cat, "date_parse", ["date"], "simple", ["DATEVALUE"], [], 45306, "date_serial", datesys="1900", locale="en-US", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=EDATE(45306,3)', cat, "date_math", ["date"], "simple", ["EDATE"], [], 45397, "date_serial", datesys="1900", prov_detail=pd, notes="3 months after 2024-01-15 = 2024-04-15")); n+=1
entries.append(e(ftc(n), '=EDATE(45306,-1)', cat, "date_math", ["date"], "simple", ["EDATE"], [], 45275, "date_serial", datesys="1900", prov_detail=pd, notes="1 month before 2024-01-15 = 2023-12-15")); n+=1
entries.append(e(ftc(n), '=EOMONTH(45306,0)', cat, "date_math", ["date"], "simple", ["EOMONTH"], [], 45322, "date_serial", datesys="1900", prov_detail=pd, notes="End of Jan 2024 = Jan 31")); n+=1
entries.append(e(ftc(n), '=EOMONTH(45306,1)', cat, "date_math", ["date"], "simple", ["EOMONTH"], [], 45351, "date_serial", datesys="1900", prov_detail=pd, notes="End of Feb 2024 (leap year) = Feb 29")); n+=1
entries.append(e(ftc(n), '=DAYS(45400,45306)', cat, "date_math", ["date"], "simple", ["DAYS"], [], 94, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=NETWORKDAYS(45306,45337)', cat, "date_math", ["date","business"], "moderate", ["NETWORKDAYS"], [], 23, "number", datesys="1900", prov_detail=pd, notes="2024-01-15 to 2024-02-15: 23 working days")); n+=1
entries.append(e(ftc(n), '=WORKDAY(45306,10)', cat, "date_math", ["date","business"], "moderate", ["WORKDAY"], [], 45320, "date_serial", datesys="1900", prov_detail=pd, notes="10 workdays after 2024-01-15 = 2024-01-29")); n+=1
entries.append(e(ftc(n), '=DATEDIF(45306,45672,"Y")', cat, "date_math", ["date"], "moderate", ["DATEDIF"], [], 1, "number", datesys="1900", prov_detail=pd, notes="Full years between dates")); n+=1
entries.append(e(ftc(n), '=DATEDIF(45306,45672,"M")', cat, "date_math", ["date"], "moderate", ["DATEDIF"], [], 12, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DATEDIF(45306,45672,"D")', cat, "date_math", ["date"], "moderate", ["DATEDIF"], [], 366, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TIME(14,30,0)', cat, "time_construct", ["time"], "trivial", ["TIME"], [], 0.604166666666667, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=HOUR(0.75)', cat, "time_extract", ["time"], "trivial", ["HOUR"], [], 18, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MINUTE(0.75)', cat, "time_extract", ["time"], "trivial", ["MINUTE"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SECOND(0.75)', cat, "time_extract", ["time"], "trivial", ["SECOND"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TIMEVALUE("14:30:00")', cat, "time_parse", ["time"], "simple", ["TIMEVALUE"], [], 0.604166666666667, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DATE(1900,1,1)', cat, "date_serial_edge", ["date","edge_case"], "simple", ["DATE"], [], 1, "date_serial", datesys="1900", prov_detail=pd, notes="Serial number 1 = 1900-01-01")); n+=1
entries.append(e(ftc(n), '=DATE(1900,2,29)', cat, "date_serial_edge", ["date","edge_case","lotus_bug"], "moderate", ["DATE"], [], 60, "date_serial", datesys="1900", prov_detail=pd, notes="Lotus 1-2-3 bug: 1900 was not a leap year but Excel treats it as one")); n+=1
entries.append(e(ftc(n), '=YEAR(DATE(2024,2,29))', cat, "date_leap", ["date","leap_year"], "simple", ["YEAR","DATE"], [], 2024, "number", datesys="1900", prov_detail=pd, notes="2024 is a leap year")); n+=1
entries.append(e(ftc(n), '=DATE(2100,2,29)', cat, "date_leap", ["date","leap_year"], "moderate", ["DATE"], [], 73111, "date_serial", datesys="1900", prov_detail=pd, notes="2100 is NOT a leap year; Feb 29 rolls to Mar 1")); n+=1
entries.append(e(ftc(n), '=MONTH(DATE(2100,2,29))', cat, "date_leap", ["date","leap_year"], "moderate", ["MONTH","DATE"], [], 3, "number", datesys="1900", prov_detail=pd, notes="Rolls to March")); n+=1
entries.append(e(ftc(n), '=YEARFRAC(45306,45672)', cat, "date_math", ["date","financial"], "moderate", ["YEARFRAC"], [], 1.00273972602740, "number", datesys="1900", prov_detail=pd)); n+=1

# ============================================================
# STATISTICAL (FTC-0411 to FTC-0470) ~60 entries
# ============================================================
cat = "statistical"
pd = "Hand-authored from Excel statistical function documentation"

entries.append(e(ftc(n), '=AVERAGE({1,2,3,4,5})', cat, "central_tendency", ["stats"], "trivial", ["AVERAGE"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MEDIAN({1,2,3,4,5})', cat, "central_tendency", ["stats"], "trivial", ["MEDIAN"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MEDIAN({1,2,3,4})', cat, "central_tendency", ["stats"], "simple", ["MEDIAN"], [], 2.5, "number", prov_detail=pd, notes="Even count: average of middle two")); n+=1
entries.append(e(ftc(n), '=MODE({1,2,2,3,3,3})', cat, "central_tendency", ["stats"], "simple", ["MODE"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=GEOMEAN({2,8})', cat, "central_tendency", ["stats"], "simple", ["GEOMEAN"], [], 4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=HARMEAN({1,2,4})', cat, "central_tendency", ["stats"], "simple", ["HARMEAN"], [], 1.71428571428571, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TRIMMEAN({1,2,3,4,5,100},0.4)', cat, "central_tendency", ["stats"], "moderate", ["TRIMMEAN"], [], 3.5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=STDEV({2,4,4,4,5,5,7,9})', cat, "dispersion", ["stats"], "simple", ["STDEV"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=STDEV.P({2,4,4,4,5,5,7,9})', cat, "dispersion", ["stats"], "simple", ["STDEV.P"], [], 1.87082869338697, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=VAR({2,4,4,4,5,5,7,9})', cat, "dispersion", ["stats"], "simple", ["VAR"], [], 4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=AVEDEV({2,4,4,4,5,5,7,9})', cat, "dispersion", ["stats"], "simple", ["AVEDEV"], [], 1.5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COUNT({1,"a",TRUE,2,3})', cat, "counting", ["stats"], "simple", ["COUNT"], [], 3, "number", prov_detail=pd, notes="COUNT counts only numbers")); n+=1
entries.append(e(ftc(n), '=COUNTA({1,"a",TRUE,2,3})', cat, "counting", ["stats"], "simple", ["COUNTA"], [], 5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,{"a",1,"",2,"b"},COUNTBLANK(d))', cat, "counting", ["stats","let"], "moderate", ["LET","COUNTBLANK"], [], 1, "number", prov_detail=pd, notes="Only empty string counts as blank")); n+=1
entries.append(e(ftc(n), '=COUNTIF({1,2,3,4,5},">3")', cat, "counting", ["stats"], "simple", ["COUNTIF"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUMIF({1,2,3,4,5},">3")', cat, "conditional_agg", ["stats"], "simple", ["SUMIF"], [], 9, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=AVERAGEIF({1,2,3,4,5},">3")', cat, "conditional_agg", ["stats"], "simple", ["AVERAGEIF"], [], 4.5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PERCENTILE({1,2,3,4,5},0.5)', cat, "percentile", ["stats"], "simple", ["PERCENTILE"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PERCENTILE({1,2,3,4,5},0)', cat, "percentile", ["stats"], "simple", ["PERCENTILE"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PERCENTILE({1,2,3,4,5},1)', cat, "percentile", ["stats"], "simple", ["PERCENTILE"], [], 5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=QUARTILE({1,2,3,4,5},1)', cat, "percentile", ["stats"], "simple", ["QUARTILE"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=QUARTILE({1,2,3,4,5},3)', cat, "percentile", ["stats"], "simple", ["QUARTILE"], [], 4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RANK(3,{5,3,8,1,9})', cat, "rank", ["stats"], "simple", ["RANK"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RANK.EQ(3,{5,3,8,1,9},1)', cat, "rank", ["stats"], "simple", ["RANK.EQ"], [], 2, "number", prov_detail=pd, notes="Ascending rank")); n+=1
entries.append(e(ftc(n), '=PERCENTRANK({1,2,3,4,5},3)', cat, "rank", ["stats"], "simple", ["PERCENTRANK"], [], 0.5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CORREL({1,2,3,4,5},{2,4,6,8,10})', cat, "correlation", ["stats"], "moderate", ["CORREL"], [], 1, "number", prov_detail=pd, notes="Perfect positive correlation")); n+=1
entries.append(e(ftc(n), '=CORREL({1,2,3,4,5},{10,8,6,4,2})', cat, "correlation", ["stats"], "moderate", ["CORREL"], [], -1, "number", prov_detail=pd, notes="Perfect negative correlation")); n+=1
entries.append(e(ftc(n), '=SLOPE({2,4,6,8,10},{1,2,3,4,5})', cat, "regression", ["stats"], "moderate", ["SLOPE"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=INTERCEPT({2,4,6,8,10},{1,2,3,4,5})', cat, "regression", ["stats"], "moderate", ["INTERCEPT"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RSQ({2,4,6,8,10},{1,2,3,4,5})', cat, "regression", ["stats"], "moderate", ["RSQ"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=NORM.DIST(0,0,1,TRUE)', cat, "distribution", ["stats"], "moderate", ["NORM.DIST"], [], 0.5, "number", prov_detail=pd, notes="CDF of standard normal at 0")); n+=1
entries.append(e(ftc(n), '=NORM.INV(0.975,0,1)', cat, "distribution", ["stats"], "moderate", ["NORM.INV"], [], 1.95996398454005, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BINOM.DIST(3,10,0.5,FALSE)', cat, "distribution", ["stats"], "moderate", ["BINOM.DIST"], [], 0.1171875, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=POISSON.DIST(2,3,FALSE)', cat, "distribution", ["stats"], "moderate", ["POISSON.DIST"], [], 0.224041807654836, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SKEW({1,2,2,3,5})', cat, "shape", ["stats"], "moderate", ["SKEW"], [], 0.946174695757561, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=KURT({1,2,3,4,5})', cat, "shape", ["stats"], "moderate", ["KURT"], [], -1.2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FREQUENCY({1,2,2,3,3,3,4},{2,3})', cat, "frequency", ["stats","dynamic_array"], "moderate", ["FREQUENCY"], [], None, "array", is_array=True, dims="3x1", prov_detail=pd, notes="Returns {2;3;1}: 2 values <=2, 3 values <=3, 1 value >3")); n+=1

# ============================================================
# FINANCIAL (FTC-0471 to FTC-0530) ~60 entries
# ============================================================
cat = "financial"
pd = "Hand-authored from Excel financial function documentation"

entries.append(e(ftc(n), '=PMT(0.05/12,360,200000)', cat, "time_value", ["finance","loan"], "moderate", ["PMT"], [], -1073.64325094786, "number", prov_detail=pd, notes="Monthly payment on 200k loan at 5% for 30 years")); n+=1
entries.append(e(ftc(n), '=FV(0.06/12,120,-200)', cat, "time_value", ["finance","savings"], "moderate", ["FV"], [], 32775.8694859498, "number", prov_detail=pd, notes="Future value of $200/month at 6% for 10 years")); n+=1
entries.append(e(ftc(n), '=PV(0.08,10,0,-10000)', cat, "time_value", ["finance"], "moderate", ["PV"], [], 4631.93484918203, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=NPER(0.05/12,-1000,0,100000)', cat, "time_value", ["finance"], "moderate", ["NPER"], [], 82.0148134920733, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RATE(360,-1073.64,200000)', cat, "time_value", ["finance","iterative"], "complex", ["RATE"], [], 0.00416666666666667, "number", prov_detail=pd, notes="Recovers 5%/12 monthly rate")); n+=1
entries.append(e(ftc(n), '=NPV(0.1,{-10000,3000,4200,6800})', cat, "cashflow", ["finance"], "moderate", ["NPV"], [], 1188.44339364894, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IRR({-10000,3000,4200,6800})', cat, "cashflow", ["finance","iterative"], "complex", ["IRR"], [], 0.0866308841498, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MIRR({-10000,3000,4200,6800},0.1,0.12)', cat, "cashflow", ["finance"], "complex", ["MIRR"], [], 0.0795884825817, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XNPV(0.1,{-10000,2750,4250,3250,2750},{44927,45108,45292,45473,45658})', cat, "cashflow", ["finance","date"], "complex", ["XNPV"], [], 1856.32256460725, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XIRR({-10000,2750,4250,3250,2750},{44927,45108,45292,45473,45658})', cat, "cashflow", ["finance","date","iterative"], "complex", ["XIRR"], [], 0.261390033, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SLN(30000,7500,10)', cat, "depreciation", ["finance"], "simple", ["SLN"], [], 2250, "number", prov_detail=pd, notes="Straight-line depreciation")); n+=1
entries.append(e(ftc(n), '=DDB(30000,7500,10,1)', cat, "depreciation", ["finance"], "moderate", ["DDB"], [], 6000, "number", prov_detail=pd, notes="Double-declining balance")); n+=1
entries.append(e(ftc(n), '=SYD(30000,7500,10,1)', cat, "depreciation", ["finance"], "moderate", ["SYD"], [], 4090.90909090909, "number", prov_detail=pd, notes="Sum-of-years-digits")); n+=1
entries.append(e(ftc(n), '=DB(30000,7500,10,1)', cat, "depreciation", ["finance"], "moderate", ["DB"], [], 6390, "number", prov_detail=pd, notes="Fixed-declining balance")); n+=1
entries.append(e(ftc(n), '=PPMT(0.05/12,1,360,200000)', cat, "time_value", ["finance","loan"], "moderate", ["PPMT"], [], -240.309917614529, "number", prov_detail=pd, notes="Principal portion of first payment")); n+=1
entries.append(e(ftc(n), '=IPMT(0.05/12,1,360,200000)', cat, "time_value", ["finance","loan"], "moderate", ["IPMT"], [], -833.333333333333, "number", prov_detail=pd, notes="Interest portion of first payment")); n+=1
entries.append(e(ftc(n), '=CUMIPMT(0.05/12,360,200000,1,12,0)', cat, "time_value", ["finance","loan"], "complex", ["CUMIPMT"], [], -9942.35483355569, "number", prov_detail=pd, notes="Cumulative interest for first year")); n+=1
entries.append(e(ftc(n), '=CUMPRINC(0.05/12,360,200000,1,12,0)', cat, "time_value", ["finance","loan"], "complex", ["CUMPRINC"], [], -2941.54617783771, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=EFFECT(0.05,12)', cat, "rate_conversion", ["finance"], "simple", ["EFFECT"], [], 0.0511619500830, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=NOMINAL(0.0511619500830,12)', cat, "rate_conversion", ["finance"], "simple", ["NOMINAL"], [], 0.05, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DOLLARDE(1.02,16)', cat, "price_fraction", ["finance"], "simple", ["DOLLARDE"], [], 1.125, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DOLLARFR(1.125,16)', cat, "price_fraction", ["finance"], "simple", ["DOLLARFR"], [], 1.02, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DISC(44927,45292,97,100)', cat, "bond", ["finance","date"], "complex", ["DISC"], [], 0.03, "number", datesys="1900", prov_detail=pd, notes="Discount rate")); n+=1
entries.append(e(ftc(n), '=INTRATE(44927,45292,97,100)', cat, "bond", ["finance","date"], "complex", ["INTRATE"], [], 0.0309278350515, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=RECEIVED(44927,45292,1000,0.05)', cat, "bond", ["finance","date"], "complex", ["RECEIVED"], [], 1025.64102564103, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TBILLEQ(44927,45108,0.05)', cat, "bond", ["finance","date"], "complex", ["TBILLEQ"], [], 0.05104560261, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TBILLPRICE(44927,45108,0.05)', cat, "bond", ["finance","date"], "complex", ["TBILLPRICE"], [], 97.5138888888889, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TBILLYIELD(44927,45108,97.5138888889)', cat, "bond", ["finance","date"], "complex", ["TBILLYIELD"], [], 0.05, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ACCRINT(44927,45108,45292,0.05,1000,2)', cat, "bond", ["finance","date"], "complex", ["ACCRINT"], [], 50, "number", datesys="1900", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=PDURATION(0.05,1000,2000)', cat, "time_value", ["finance"], "simple", ["PDURATION"], [], 14.2067150371, "number", prov_detail=pd, notes="Periods to double at 5%")); n+=1
entries.append(e(ftc(n), '=RRI(10,1000,2000)', cat, "time_value", ["finance"], "simple", ["RRI"], [], 0.0717734625363, "number", prov_detail=pd, notes="Rate for 1000->2000 in 10 periods")); n+=1
entries.append(e(ftc(n), '=FV(0,10,-100)', cat, "time_value", ["finance","edge_case"], "simple", ["FV"], [], 1000, "number", prov_detail=pd, notes="Zero rate: simple accumulation")); n+=1

# ============================================================
# LET/LAMBDA/FUNCTIONAL (FTC-0531 to FTC-0650) ~120 entries
# ============================================================
cat = "let_lambda_functional"
pd = "Hand-authored from Excel LAMBDA/LET documentation"
sid_pbartxl = ["R-SRC-124"]

# LET basics
entries.append(e(ftc(n), '=LET(x,5,x*2)', cat, "let_basic", ["let","tier4"], "simple", ["LET"], ["*"], 10, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(x,10,y,20,x+y)', cat, "let_basic", ["let","tier4"], "simple", ["LET"], ["+"], 30, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(a,3,b,4,SQRT(a^2+b^2))', cat, "let_basic", ["let","tier4"], "moderate", ["LET","SQRT"], ["^","+"], 5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(x,{1,2,3},SUM(x))', cat, "let_array", ["let","tier4","array_constant"], "moderate", ["LET","SUM"], [], 6, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(greeting,"Hello",name,"World",greeting&" "&name)', cat, "let_basic", ["let","tier4"], "moderate", ["LET"], ["&"], "Hello World", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(x,5,y,x*2,z,y+1,z)', cat, "let_chain", ["let","tier4"], "moderate", ["LET"], ["*","+"], 11, "number", prov_detail=pd, notes="Chained bindings: z depends on y depends on x")); n+=1
entries.append(e(ftc(n), '=LET(a,1,b,2,c,3,d,4,e,5,a+b+c+d+e)', cat, "let_chain", ["let","tier4"], "moderate", ["LET"], ["+"], 15, "number", prov_detail=pd, notes="5 bindings")); n+=1
entries.append(e(ftc(n), '=LET(data,{10,20,30,40,50},avg,AVERAGE(data),dev,data-avg,SUMPRODUCT(dev,dev)/5)', cat, "let_chain", ["let","tier4"], "complex", ["LET","AVERAGE","SUMPRODUCT"], ["-","/"], 200, "number", prov_detail=pd, notes="Variance calculation via LET")); n+=1

# LAMBDA basics
entries.append(e(ftc(n), '=LET(f,LAMBDA(x,x*2),f(5))', cat, "lambda_basic", ["lambda","tier4"], "moderate", ["LET","LAMBDA"], ["*"], 10, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(add,LAMBDA(a,b,a+b),add(3,4))', cat, "lambda_basic", ["lambda","tier4"], "moderate", ["LET","LAMBDA"], ["+"], 7, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(sq,LAMBDA(x,x^2),sq(7))', cat, "lambda_basic", ["lambda","tier4"], "moderate", ["LET","LAMBDA"], ["^"], 49, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LAMBDA(x,x+1)(10)', cat, "lambda_basic", ["lambda","tier4"], "simple", ["LAMBDA"], ["+"], 11, "number", prov_detail=pd, notes="Immediately invoked lambda")); n+=1
entries.append(e(ftc(n), '=LAMBDA(x,y,x*y)(6,7)', cat, "lambda_basic", ["lambda","tier4"], "simple", ["LAMBDA"], ["*"], 42, "number", prov_detail=pd)); n+=1

# LAMBDA higher-order
entries.append(e(ftc(n), '=LET(apply,LAMBDA(f,x,f(x)),double,LAMBDA(x,x*2),apply(double,5))', cat, "lambda_higher_order", ["lambda","tier4","higher_order"], "complex", ["LET","LAMBDA"], ["*"], 10, "number", prov_detail=pd, notes="Passing lambda as argument")); n+=1
entries.append(e(ftc(n), '=LET(compose,LAMBDA(f,g,LAMBDA(x,f(g(x)))),double,LAMBDA(x,x*2),inc,LAMBDA(x,x+1),h,compose(double,inc),h(5))', cat, "lambda_higher_order", ["lambda","tier4","higher_order","compose"], "expert", ["LET","LAMBDA"], ["*","+"], 12, "number", prov_detail=pd, notes="Function composition: double(inc(5)) = 2*(5+1) = 12")); n+=1

# MAP
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,MAP(d,LAMBDA(x,x^2)),SUM(r))', cat, "map", ["lambda","tier4","map"], "complex", ["LET","MAP","LAMBDA","SUM"], ["^"], 55, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(a,{1;2;3},b,{10;20;30},r,MAP(a,b,LAMBDA(x,y,x*y)),SUM(r))', cat, "map", ["lambda","tier4","map"], "complex", ["LET","MAP","LAMBDA","SUM"], ["*"], 140, "number", prov_detail=pd, notes="Two-array MAP")); n+=1
entries.append(e(ftc(n), '=LET(d,{"hello";"world"},r,MAP(d,LAMBDA(s,UPPER(s))),INDEX(r,1,1))', cat, "map", ["lambda","tier4","map"], "complex", ["LET","MAP","LAMBDA","UPPER","INDEX"], [], "HELLO", "text", prov_detail=pd)); n+=1

# REDUCE
entries.append(e(ftc(n), '=REDUCE(0,{1,2,3,4,5},LAMBDA(acc,x,acc+x))', cat, "reduce", ["lambda","tier4","reduce"], "complex", ["REDUCE","LAMBDA"], ["+"], 15, "number", prov_detail=pd, notes="Sum via REDUCE")); n+=1
entries.append(e(ftc(n), '=REDUCE(1,{1,2,3,4,5},LAMBDA(acc,x,acc*x))', cat, "reduce", ["lambda","tier4","reduce"], "complex", ["REDUCE","LAMBDA"], ["*"], 120, "number", prov_detail=pd, notes="Factorial via REDUCE: 5!")); n+=1
entries.append(e(ftc(n), '=REDUCE("",{"a","b","c"},LAMBDA(acc,x,acc&x))', cat, "reduce", ["lambda","tier4","reduce"], "complex", ["REDUCE","LAMBDA"], ["&"], "abc", "text", prov_detail=pd, notes="String concatenation via REDUCE")); n+=1
entries.append(e(ftc(n), '=REDUCE(0,{3,1,4,1,5},LAMBDA(acc,x,IF(x>acc,x,acc)))', cat, "reduce", ["lambda","tier4","reduce"], "complex", ["REDUCE","LAMBDA","IF"], [">"], 5, "number", prov_detail=pd, notes="MAX via REDUCE")); n+=1

# SCAN
entries.append(e(ftc(n), '=LET(r,SCAN(0,{1,2,3,4,5},LAMBDA(acc,x,acc+x)),INDEX(r,1,5))', cat, "scan", ["lambda","tier4","scan"], "complex", ["LET","SCAN","LAMBDA","INDEX"], ["+"], 15, "number", prov_detail=pd, notes="Running sum: last element = total")); n+=1
entries.append(e(ftc(n), '=LET(r,SCAN(1,{1,2,3,4},LAMBDA(acc,x,acc*x)),INDEX(r,1,4))', cat, "scan", ["lambda","tier4","scan"], "complex", ["LET","SCAN","LAMBDA","INDEX"], ["*"], 24, "number", prov_detail=pd, notes="Running product: 4!")); n+=1

# BYROW / BYCOL
entries.append(e(ftc(n), '=LET(m,{1,2,3;4,5,6},r,BYROW(m,LAMBDA(row,SUM(row))),INDEX(r,2,1))', cat, "byrow", ["lambda","tier4","byrow"], "complex", ["LET","BYROW","LAMBDA","SUM","INDEX"], [], 15, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(m,{1,2,3;4,5,6},r,BYCOL(m,LAMBDA(col,SUM(col))),INDEX(r,1,2))', cat, "bycol", ["lambda","tier4","bycol"], "complex", ["LET","BYCOL","LAMBDA","SUM","INDEX"], [], 7, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(m,{1,2;3,4;5,6},r,BYROW(m,LAMBDA(row,MAX(row)-MIN(row))),SUM(r))', cat, "byrow", ["lambda","tier4","byrow"], "complex", ["LET","BYROW","LAMBDA","MAX","MIN","SUM"], ["-"], 3, "number", prov_detail=pd, notes="Range per row: 1+1+1=3")); n+=1

# MAKEARRAY
entries.append(e(ftc(n), '=LET(m,MAKEARRAY(3,3,LAMBDA(r,c,r*c)),SUM(m))', cat, "makearray", ["lambda","tier4","makearray"], "complex", ["LET","MAKEARRAY","LAMBDA","SUM"], ["*"], 36, "number", prov_detail=pd, notes="Multiplication table: sum = 36")); n+=1
entries.append(e(ftc(n), '=LET(m,MAKEARRAY(3,3,LAMBDA(r,c,IF(r=c,1,0))),SUM(m))', cat, "makearray", ["lambda","tier4","makearray"], "complex", ["LET","MAKEARRAY","LAMBDA","IF","SUM"], ["="], 3, "number", prov_detail=pd, notes="Identity matrix: trace = 3")); n+=1
entries.append(e(ftc(n), '=LET(m,MAKEARRAY(4,1,LAMBDA(r,c,r^2)),SUM(m))', cat, "makearray", ["lambda","tier4","makearray"], "complex", ["LET","MAKEARRAY","LAMBDA","SUM"], ["^"], 30, "number", prov_detail=pd, notes="1+4+9+16=30")); n+=1

# ISOMITTED
entries.append(e(ftc(n), '=LET(f,LAMBDA(x,[y],IF(ISOMITTED(y),x*2,x+y)),f(5))', cat, "isomitted", ["lambda","tier4","isomitted"], "complex", ["LET","LAMBDA","IF","ISOMITTED"], ["*","+"], 10, "number", prov_detail=pd, notes="y omitted, uses default behavior")); n+=1
entries.append(e(ftc(n), '=LET(f,LAMBDA(x,[y],IF(ISOMITTED(y),x*2,x+y)),f(5,3))', cat, "isomitted", ["lambda","tier4","isomitted"], "complex", ["LET","LAMBDA","IF","ISOMITTED"], ["*","+"], 8, "number", prov_detail=pd, notes="y provided")); n+=1

# Recursive LAMBDA
entries.append(e(ftc(n), '=LET(factorial,LAMBDA(self,n,IF(n<=1,1,n*self(self,n-1))),factorial(factorial,6))', cat, "lambda_recursive", ["lambda","tier4","recursive"], "expert", ["LET","LAMBDA","IF"], ["<=","*","-"], 720, "number", prov_detail=pd, notes="Recursive factorial via Y-combinator pattern")); n+=1
entries.append(e(ftc(n), '=LET(fib,LAMBDA(self,n,IF(n<=1,n,self(self,n-1)+self(self,n-2))),fib(fib,10))', cat, "lambda_recursive", ["lambda","tier4","recursive"], "expert", ["LET","LAMBDA","IF"], ["<=","-","+"], 55, "number", prov_detail=pd, notes="Fibonacci via recursive LAMBDA")); n+=1
entries.append(e(ftc(n), '=LET(gcd,LAMBDA(self,a,b,IF(b=0,a,self(self,b,MOD(a,b)))),gcd(gcd,48,36))', cat, "lambda_recursive", ["lambda","tier4","recursive"], "expert", ["LET","LAMBDA","IF","MOD"], ["="], 12, "number", prov_detail=pd, notes="Euclidean GCD via recursive LAMBDA")); n+=1

# pbartxl: THUNK pattern
entries.append(e(ftc(n), '=LET(THUNK,LAMBDA(x,LAMBDA(x)),t,THUNK(42),t())', cat, "thunk", ["lambda","tier4","thunk","pbartxl"], "complex", ["LET","LAMBDA"], [], 42, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl THUNK pattern - deferred evaluation")); n+=1
entries.append(e(ftc(n), '=LET(THUNK,LAMBDA(x,LAMBDA(x)),t1,THUNK({1,2,3}),SUM(t1()))', cat, "thunk", ["lambda","tier4","thunk","pbartxl"], "complex", ["LET","LAMBDA","SUM"], [], 6, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl THUNK pattern with array")); n+=1

# pbartxl: Dictionary pattern
entries.append(e(ftc(n), '=LET(dict,{"key1",LAMBDA({10,20,30});"key2",LAMBDA({40,50,60})},keys,INDEX(dict,0,1),INDEX(keys,1,1))', cat, "dict_pattern", ["lambda","tier4","pbartxl","dictionary"], "expert", ["LET","LAMBDA","INDEX"], [], "key1", "text", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl data dictionary pattern - key extraction")); n+=1

# pbartxl: KEYSλ
entries.append(e(ftc(n), '=LET(dict,{"a",LAMBDA(1);"b",LAMBDA(2);"c",LAMBDA(3)},keys,TAKE(dict,,1),ROWS(keys))', cat, "dict_pattern", ["lambda","tier4","pbartxl","dictionary"], "complex", ["LET","LAMBDA","TAKE","ROWS"], [], 3, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl KEYSλ pattern")); n+=1

# pbartxl: GETλ pattern
entries.append(e(ftc(n), '=LET(dict,{"x",LAMBDA(100);"y",LAMBDA(200)},GETlambda,LAMBDA(d,LAMBDA(key,LET(keys,TAKE(d,,1),objects,DROP(d,,1),obj,XLOOKUP(key,keys,objects,"not found"),obj()))),getter,GETlambda(dict),getter("y"))', cat, "dict_pattern", ["lambda","tier4","pbartxl","dictionary","xlookup"], "expert", ["LET","LAMBDA","TAKE","DROP","XLOOKUP"], [], 200, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl GETλ pattern - dictionary lookup")); n+=1

# pbartxl: COMBINATIONAλ adapted (simplified)
entries.append(e(ftc(n), '=LET(n,4,m,2,COMBIN(n,m))', cat, "combinatorial", ["lambda","tier4","pbartxl"], "simple", ["LET","COMBIN"], [], 6, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Simplified from pbartxl COMBINATIONAλ - basic combination count")); n+=1

# Complex LET chains with LAMBDA
entries.append(e(ftc(n), '=LET(data,{5,3,8,1,9,2,7,4,6},n,COUNTA(data),mean,AVERAGE(data),variance,SUMPRODUCT((data-mean)^2)/n,SQRT(variance))', cat, "let_complex", ["let","lambda","tier4"], "complex", ["LET","COUNTA","AVERAGE","SUMPRODUCT","SQRT"], ["-","^","/"], 2.44948974278318, "number", prov_detail=pd, notes="Population standard deviation via LET")); n+=1
entries.append(e(ftc(n), '=LET(clamp,LAMBDA(x,lo,hi,MAX(lo,MIN(hi,x))),clamp(15,0,10))', cat, "lambda_utility", ["lambda","tier4"], "moderate", ["LET","LAMBDA","MAX","MIN"], [], 10, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(clamp,LAMBDA(x,lo,hi,MAX(lo,MIN(hi,x))),clamp(-5,0,10))', cat, "lambda_utility", ["lambda","tier4"], "moderate", ["LET","LAMBDA","MAX","MIN"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(lerp,LAMBDA(a,b,t,a+(b-a)*t),lerp(0,100,0.25))', cat, "lambda_utility", ["lambda","tier4"], "moderate", ["LET","LAMBDA"], ["+","-","*"], 25, "number", prov_detail=pd, notes="Linear interpolation")); n+=1

# pbartxl: SCANVλ pattern adapted
entries.append(e(ftc(n), '=LET(data,{10;20;30;40;50},running,SCAN(0,data,LAMBDA(acc,x,acc+x)),INDEX(running,3,1))', cat, "scan_advanced", ["lambda","tier4","scan","pbartxl"], "complex", ["LET","SCAN","LAMBDA","INDEX"], ["+"], 60, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl SCANVλ pattern - running total")); n+=1

# pbartxl: MAPλ thunk composition
entries.append(e(ftc(n), '=LET(THUNK,LAMBDA(x,LAMBDA(x)),vals,MAP({1;2;3},LAMBDA(v,THUNK(v*10))),INDEX(vals,2,1)())', cat, "thunk_map", ["lambda","tier4","thunk","map","pbartxl"], "expert", ["LET","LAMBDA","MAP","INDEX"], ["*"], 20, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl MAPλ thunk composition pattern")); n+=1

# pbartxl: IDENT
entries.append(e(ftc(n), '=LET(IDENT,LAMBDA(x,x),IDENT(42))', cat, "lambda_basic", ["lambda","tier4","pbartxl"], "simple", ["LET","LAMBDA"], [], 42, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl IDENT identity function")); n+=1

# pbartxl: BYARR
entries.append(e(ftc(n), '=LET(BYARR,LAMBDA(x,fn,fn(x)),BYARR({1,2,3},LAMBDA(arr,SUM(arr))))', cat, "lambda_higher_order", ["lambda","tier4","pbartxl"], "complex", ["LET","LAMBDA","SUM"], [], 6, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl BYARR pattern")); n+=1

# More LAMBDA patterns
entries.append(e(ftc(n), '=LET(pipe,LAMBDA(x,f1,f2,f2(f1(x))),pipe(5,LAMBDA(x,x*2),LAMBDA(x,x+1)))', cat, "lambda_higher_order", ["lambda","tier4","pipe"], "expert", ["LET","LAMBDA"], ["*","+"], 11, "number", prov_detail=pd, notes="Pipe: (5*2)+1=11")); n+=1
entries.append(e(ftc(n), '=LET(twice,LAMBDA(f,LAMBDA(x,f(f(x)))),double,LAMBDA(x,x*2),quadruple,twice(double),quadruple(3))', cat, "lambda_higher_order", ["lambda","tier4","higher_order"], "expert", ["LET","LAMBDA"], ["*"], 12, "number", prov_detail=pd, notes="Apply double twice: 3*2*2=12")); n+=1
entries.append(e(ftc(n), '=LET(data,{1;2;3;4;5},evens,MAP(data,LAMBDA(x,IF(MOD(x,2)=0,x,0))),SUM(evens))', cat, "map", ["lambda","tier4","map","filter"], "complex", ["LET","MAP","LAMBDA","IF","MOD","SUM"], ["="], 6, "number", prov_detail=pd, notes="Sum of even numbers")); n+=1
entries.append(e(ftc(n), '=LET(data,{1;2;3;4;5},squares,MAP(data,LAMBDA(x,x^2)),AVERAGE(squares))', cat, "map", ["lambda","tier4","map"], "complex", ["LET","MAP","LAMBDA","AVERAGE"], ["^"], 11, "number", prov_detail=pd, notes="Mean of squares")); n+=1
entries.append(e(ftc(n), '=LET(data,{1;2;3;4;5;6;7;8;9;10},r,REDUCE(0,data,LAMBDA(acc,x,IF(MOD(x,2)=0,acc+x,acc))),r)', cat, "reduce", ["lambda","tier4","reduce","filter"], "complex", ["REDUCE","LAMBDA","IF","MOD","LET"], ["=","+"], 30, "number", prov_detail=pd, notes="Sum even numbers via REDUCE")); n+=1

# pbartxl: Calculateλ FIFO concept adapted (simplified SCAN-based accumulation)
entries.append(e(ftc(n), '=LET(inflow,{100;200;300},cumIn,SCAN(0,inflow,LAMBDA(a,x,a+x)),INDEX(cumIn,3,1))', cat, "scan_advanced", ["lambda","tier4","scan","pbartxl","fifo"], "complex", ["LET","SCAN","LAMBDA","INDEX"], ["+"], 600, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl Calculateλ FIFO pattern - cumulative inflow")); n+=1

# Deeply nested LET
entries.append(e(ftc(n), '=LET(a,1,b,a+1,c,b+1,d,c+1,e,d+1,f,e+1,g,f+1,h,g+1,SUM(a,b,c,d,e,f,g,h))', cat, "let_deep", ["let","tier4"], "complex", ["LET","SUM"], ["+"], 36, "number", prov_detail=pd, notes="8-deep LET chain: 1+2+3+4+5+6+7+8=36")); n+=1

# LAMBDA returning LAMBDA
entries.append(e(ftc(n), '=LET(adder,LAMBDA(n,LAMBDA(x,x+n)),add5,adder(5),add5(10))', cat, "lambda_closure", ["lambda","tier4","closure"], "expert", ["LET","LAMBDA"], ["+"], 15, "number", prov_detail=pd, notes="Closure: adder returns a lambda that adds n")); n+=1
entries.append(e(ftc(n), '=LET(multiplier,LAMBDA(n,LAMBDA(x,x*n)),triple,multiplier(3),triple(7))', cat, "lambda_closure", ["lambda","tier4","closure"], "expert", ["LET","LAMBDA"], ["*"], 21, "number", prov_detail=pd)); n+=1

# MAP with index via SEQUENCE
entries.append(e(ftc(n), '=LET(data,{10;20;30},idx,SEQUENCE(3),pairs,MAP(idx,data,LAMBDA(i,v,i&":"&v)),INDEX(pairs,2,1))', cat, "map", ["lambda","tier4","map","sequence"], "complex", ["LET","MAP","LAMBDA","SEQUENCE","INDEX"], ["&"], "2:20", "text", prov_detail=pd)); n+=1

# REDUCE building string
entries.append(e(ftc(n), '=REDUCE("",{1,2,3,4,5},LAMBDA(acc,x,IF(acc="",TEXT(x,"0"),acc&","&TEXT(x,"0"))))', cat, "reduce", ["lambda","tier4","reduce"], "complex", ["REDUCE","LAMBDA","IF","TEXT"], ["=","&"], "1,2,3,4,5", "text", prov_detail=pd)); n+=1

# MAKEARRAY generating Fibonacci-like
entries.append(e(ftc(n), '=LET(m,MAKEARRAY(1,5,LAMBDA(r,c,c)),SUM(m))', cat, "makearray", ["lambda","tier4","makearray"], "moderate", ["LET","MAKEARRAY","LAMBDA","SUM"], [], 15, "number", prov_detail=pd, notes="Column indices: 1+2+3+4+5=15")); n+=1

# Multiple MAP iterations
entries.append(e(ftc(n), '=LET(d,{1;2;3},step1,MAP(d,LAMBDA(x,x*10)),step2,MAP(step1,LAMBDA(x,x+1)),SUM(step2))', cat, "map", ["lambda","tier4","map","chain"], "complex", ["LET","MAP","LAMBDA","SUM"], ["*","+"], 63, "number", prov_detail=pd, notes="Chain: {1,2,3} -> {10,20,30} -> {11,21,31}, sum=63")); n+=1

# BYCOL with complex lambda
entries.append(e(ftc(n), '=LET(m,{1,10;2,20;3,30},r,BYCOL(m,LAMBDA(c,MAX(c)-MIN(c))),SUM(r))', cat, "bycol", ["lambda","tier4","bycol"], "complex", ["LET","BYCOL","LAMBDA","MAX","MIN","SUM"], ["-"], 22, "number", prov_detail=pd, notes="Range per column: (3-1)+(30-10)=22")); n+=1

# ============================================================
# DYNAMIC ARRAY (FTC-0651 to FTC-0730) ~80 entries
# ============================================================
cat = "dynamic_array"
pd = "Hand-authored from Excel dynamic array function documentation"

entries.append(e(ftc(n), '=LET(s,SEQUENCE(5),SUM(s))', cat, "sequence", ["dynamic_array","tier4"], "simple", ["LET","SEQUENCE","SUM"], [], 15, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(s,SEQUENCE(5,1,10,10),SUM(s))', cat, "sequence", ["dynamic_array","tier4"], "moderate", ["LET","SEQUENCE","SUM"], [], 150, "number", prov_detail=pd, notes="10,20,30,40,50")); n+=1
entries.append(e(ftc(n), '=LET(s,SEQUENCE(3,3),SUM(s))', cat, "sequence", ["dynamic_array","tier4"], "moderate", ["LET","SEQUENCE","SUM"], [], 45, "number", prov_detail=pd, notes="3x3 matrix: 1..9")); n+=1
entries.append(e(ftc(n), '=LET(s,SEQUENCE(5,1,0,0.1),INDEX(s,3,1))', cat, "sequence", ["dynamic_array","tier4"], "moderate", ["LET","SEQUENCE","INDEX"], [], 0.2, "number", prov_detail=pd)); n+=1

# FILTER
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,FILTER(d,d>3),SUM(r))', cat, "filter", ["dynamic_array","tier4"], "moderate", ["LET","FILTER","SUM"], [">"], 9, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,FILTER(d,d>10,"none"),r)', cat, "filter", ["dynamic_array","tier4"], "moderate", ["LET","FILTER"], [">"], "none", "text", prov_detail=pd, notes="No matches: returns if_empty value")); n+=1
entries.append(e(ftc(n), '=LET(vals,{"a";"b";"c";"d"},mask,{TRUE;FALSE;TRUE;FALSE},r,FILTER(vals,mask),CONCAT(r))', cat, "filter", ["dynamic_array","tier4"], "moderate", ["LET","FILTER","CONCAT"], [], "ac", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,FILTER(d,(d>1)*(d<5)),SUM(r))', cat, "filter", ["dynamic_array","tier4"], "complex", ["LET","FILTER","SUM"], [">","<","*"], 9, "number", prov_detail=pd, notes="AND via multiplication: 2+3+4=9")); n+=1

# SORT
entries.append(e(ftc(n), '=LET(d,{5;3;8;1;9},r,SORT(d),INDEX(r,1,1))', cat, "sort", ["dynamic_array","tier4"], "moderate", ["LET","SORT","INDEX"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,{5;3;8;1;9},r,SORT(d,,-1),INDEX(r,1,1))', cat, "sort", ["dynamic_array","tier4"], "moderate", ["LET","SORT","INDEX"], [], 9, "number", prov_detail=pd, notes="Descending sort")); n+=1
entries.append(e(ftc(n), '=LET(d,{"banana";"apple";"cherry"},r,SORT(d),INDEX(r,1,1))', cat, "sort", ["dynamic_array","tier4"], "moderate", ["LET","SORT","INDEX"], [], "apple", "text", prov_detail=pd)); n+=1

# SORTBY
entries.append(e(ftc(n), '=LET(names,{"c";"a";"b"},scores,{3;1;2},r,SORTBY(names,scores),INDEX(r,1,1))', cat, "sortby", ["dynamic_array","tier4"], "moderate", ["LET","SORTBY","INDEX"], [], "a", "text", prov_detail=pd)); n+=1

# UNIQUE
entries.append(e(ftc(n), '=LET(d,{1;2;2;3;3;3},r,UNIQUE(d),SUM(r))', cat, "unique", ["dynamic_array","tier4"], "moderate", ["LET","UNIQUE","SUM"], [], 6, "number", prov_detail=pd, notes="Unique values: {1,2,3}")); n+=1
entries.append(e(ftc(n), '=LET(d,{1;2;2;3;3;3},r,UNIQUE(d,,TRUE),SUM(r))', cat, "unique", ["dynamic_array","tier4"], "moderate", ["LET","UNIQUE","SUM"], [], 1, "number", prov_detail=pd, notes="exactly_once=TRUE: only {1}")); n+=1
entries.append(e(ftc(n), '=LET(d,{"a";"b";"a";"c";"b"},r,UNIQUE(d),ROWS(r))', cat, "unique", ["dynamic_array","tier4"], "moderate", ["LET","UNIQUE","ROWS"], [], 3, "number", prov_detail=pd)); n+=1

# CHOOSECOLS / CHOOSEROWS
entries.append(e(ftc(n), '=LET(m,{1,2,3;4,5,6;7,8,9},r,CHOOSECOLS(m,1,3),SUM(r))', cat, "choose", ["dynamic_array","tier4"], "moderate", ["LET","CHOOSECOLS","SUM"], [], 24, "number", prov_detail=pd, notes="Cols 1,3: {1,3;4,6;7,9}, sum=30... wait: 1+3+4+6+7+9=30")); n+=1
# fix
entries[-1] = e(ftc(n-1), '=LET(m,{1,2,3;4,5,6;7,8,9},r,CHOOSECOLS(m,1,3),SUM(r))', cat, "choose", ["dynamic_array","tier4"], "moderate", ["LET","CHOOSECOLS","SUM"], [], 30, "number", prov_detail=pd, notes="Cols 1,3: {1,3;4,6;7,9}")
entries.append(e(ftc(n), '=LET(m,{1,2,3;4,5,6;7,8,9},r,CHOOSEROWS(m,1,3),SUM(r))', cat, "choose", ["dynamic_array","tier4"], "moderate", ["LET","CHOOSEROWS","SUM"], [], 30, "number", prov_detail=pd, notes="Rows 1,3: {1,2,3;7,8,9}")); n+=1

# HSTACK / VSTACK
entries.append(e(ftc(n), '=LET(a,{1;2;3},b,{4;5;6},r,HSTACK(a,b),SUM(r))', cat, "stack", ["dynamic_array","tier4"], "moderate", ["LET","HSTACK","SUM"], [], 21, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(a,{1,2,3},b,{4,5,6},r,VSTACK(a,b),SUM(r))', cat, "stack", ["dynamic_array","tier4"], "moderate", ["LET","VSTACK","SUM"], [], 21, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(r,HSTACK({1;2},{3;4},{5;6}),INDEX(r,2,3))', cat, "stack", ["dynamic_array","tier4"], "moderate", ["LET","HSTACK","INDEX"], [], 6, "number", prov_detail=pd)); n+=1

# TAKE / DROP
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,TAKE(d,3),SUM(r))', cat, "take_drop", ["dynamic_array","tier4"], "moderate", ["LET","TAKE","SUM"], [], 6, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,TAKE(d,-2),SUM(r))', cat, "take_drop", ["dynamic_array","tier4"], "moderate", ["LET","TAKE","SUM"], [], 9, "number", prov_detail=pd, notes="Last 2: {4,5}")); n+=1
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,DROP(d,2),SUM(r))', cat, "take_drop", ["dynamic_array","tier4"], "moderate", ["LET","DROP","SUM"], [], 12, "number", prov_detail=pd, notes="Drop first 2: {3,4,5}")); n+=1
entries.append(e(ftc(n), '=LET(d,{1;2;3;4;5},r,DROP(d,-2),SUM(r))', cat, "take_drop", ["dynamic_array","tier4"], "moderate", ["LET","DROP","SUM"], [], 6, "number", prov_detail=pd, notes="Drop last 2: {1,2,3}")); n+=1

# EXPAND
entries.append(e(ftc(n), '=LET(d,{1;2;3},r,EXPAND(d,5,1,0),SUM(r))', cat, "expand", ["dynamic_array","tier4"], "moderate", ["LET","EXPAND","SUM"], [], 6, "number", prov_detail=pd, notes="Expand to 5 rows with 0 pad")); n+=1

# TOCOL / TOROW
entries.append(e(ftc(n), '=LET(m,{1,2;3,4},r,TOCOL(m),SUM(r))', cat, "reshape", ["dynamic_array","tier4"], "moderate", ["LET","TOCOL","SUM"], [], 10, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(m,{1,2;3,4},r,TOROW(m),SUM(r))', cat, "reshape", ["dynamic_array","tier4"], "moderate", ["LET","TOROW","SUM"], [], 10, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(m,{1,2;3,4},r,TOCOL(m),INDEX(r,3,1))', cat, "reshape", ["dynamic_array","tier4"], "moderate", ["LET","TOCOL","INDEX"], [], 2, "number", prov_detail=pd, notes="Column-first: 1,3,2,4 -> third=2")); n+=1

# WRAPROWS / WRAPCOLS
entries.append(e(ftc(n), '=LET(d,SEQUENCE(6),m,WRAPROWS(d,3),SUM(m))', cat, "reshape", ["dynamic_array","tier4"], "moderate", ["LET","SEQUENCE","WRAPROWS","SUM"], [], 21, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,SEQUENCE(6),m,WRAPCOLS(d,3),SUM(m))', cat, "reshape", ["dynamic_array","tier4"], "moderate", ["LET","SEQUENCE","WRAPCOLS","SUM"], [], 21, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(d,SEQUENCE(6),m,WRAPROWS(d,3),INDEX(m,2,1))', cat, "reshape", ["dynamic_array","tier4"], "moderate", ["LET","SEQUENCE","WRAPROWS","INDEX"], [], 4, "number", prov_detail=pd)); n+=1

# RANDARRAY (deterministic checks)
entries.append(e(ftc(n), '=LET(r,RANDARRAY(3,3,1,1,TRUE),SUM(r))', cat, "randarray", ["dynamic_array","tier4"], "simple", ["LET","RANDARRAY","SUM"], [], 9, "number", det=True, prov_detail=pd, notes="All 1s: integer RANDARRAY with min=max=1")); n+=1
entries.append(e(ftc(n), '=ROWS(RANDARRAY(5,3))', cat, "randarray", ["dynamic_array","tier4"], "simple", ["ROWS","RANDARRAY"], [], 5, "number", det=True, prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COLUMNS(RANDARRAY(5,3))', cat, "randarray", ["dynamic_array","tier4"], "simple", ["COLUMNS","RANDARRAY"], [], 3, "number", det=True, prov_detail=pd)); n+=1

# XLOOKUP with arrays
entries.append(e(ftc(n), '=XLOOKUP("b",{"a";"b";"c"},{10;20;30})', cat, "xlookup", ["dynamic_array","tier4","lookup"], "moderate", ["XLOOKUP"], [], 20, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XLOOKUP("d",{"a";"b";"c"},{10;20;30},"not found")', cat, "xlookup", ["dynamic_array","tier4","lookup"], "moderate", ["XLOOKUP"], [], "not found", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XLOOKUP(3,{1;2;3;4;5},{10;20;30;40;50},,0,-1)', cat, "xlookup", ["dynamic_array","tier4","lookup"], "complex", ["XLOOKUP"], [], 30, "number", prov_detail=pd, notes="Binary search")); n+=1

# Combining dynamic array functions
entries.append(e(ftc(n), '=LET(d,SEQUENCE(10),f,FILTER(d,MOD(d,2)=0),SUM(f))', cat, "combined", ["dynamic_array","tier4","filter","sequence"], "complex", ["LET","SEQUENCE","FILTER","SUM","MOD"], ["="], 30, "number", prov_detail=pd, notes="Sum of even 1-10: 2+4+6+8+10=30")); n+=1
entries.append(e(ftc(n), '=LET(d,SEQUENCE(10),s,SORT(d,,-1),INDEX(TAKE(s,3),3,1))', cat, "combined", ["dynamic_array","tier4","sort","take","sequence"], "complex", ["LET","SEQUENCE","SORT","TAKE","INDEX"], [], 8, "number", prov_detail=pd, notes="3rd largest = 8")); n+=1
entries.append(e(ftc(n), '=LET(d,{3;1;4;1;5;9;2;6},u,UNIQUE(d),s,SORT(u),ROWS(s))', cat, "combined", ["dynamic_array","tier4","unique","sort"], "complex", ["LET","UNIQUE","SORT","ROWS"], [], 7, "number", prov_detail=pd, notes="7 unique values")); n+=1
entries.append(e(ftc(n), '=LET(m,{1,2,3;4,5,6;7,8,9},flat,TOCOL(m),SUM(FILTER(flat,flat>5)))', cat, "combined", ["dynamic_array","tier4","filter","tocol"], "complex", ["LET","TOCOL","FILTER","SUM"], [">"], 30, "number", prov_detail=pd, notes="6+7+8+9=30")); n+=1

# ============================================================
# TYPE COERCION / EDGE CASES (FTC-0731 to FTC-0790) ~60 entries
# ============================================================
cat = "type_coercion_edge"
pd = "Hand-authored from Excel type coercion behavior"

entries.append(e(ftc(n), '=TRUE+TRUE', cat, "bool_arithmetic", ["coercion"], "simple", [], ["+"], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TRUE*10', cat, "bool_arithmetic", ["coercion"], "simple", [], ["*"], 10, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=FALSE+1', cat, "bool_arithmetic", ["coercion"], "simple", [], ["+"], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '="5"+3', cat, "text_to_number", ["coercion"], "simple", [], ["+"], 8, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '="abc"+1', cat, "text_to_number", ["coercion"], "simple", [], ["+"], None, "error", error="#VALUE!", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '="TRUE"+0', cat, "text_to_number", ["coercion"], "moderate", [], ["+"], None, "error", error="#VALUE!", prov_detail=pd, notes="Text 'TRUE' does not coerce to number via +")); n+=1
entries.append(e(ftc(n), '=--"TRUE"', cat, "text_to_number", ["coercion"], "moderate", [], ["--"], None, "error", error="#VALUE!", prov_detail=pd, notes="Double negation cannot coerce text TRUE")); n+=1
entries.append(e(ftc(n), '=--TRUE', cat, "bool_to_number", ["coercion"], "simple", [], ["--"], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=1/TRUE', cat, "bool_arithmetic", ["coercion"], "simple", [], ["/"], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=1/FALSE', cat, "bool_arithmetic", ["coercion"], "simple", [], ["/"], None, "error", error="#DIV/0!", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=""+0', cat, "empty_string", ["coercion"], "moderate", [], ["+"], None, "error", error="#VALUE!", prov_detail=pd, notes="Empty string does not coerce to 0 via +")); n+=1
entries.append(e(ftc(n), '=0=""', cat, "empty_string", ["coercion"], "simple", [], ["="], False, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=""=""', cat, "empty_string", ["coercion"], "simple", [], ["="], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=0=FALSE', cat, "cross_type", ["coercion"], "simple", [], ["="], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=1=TRUE', cat, "cross_type", ["coercion"], "simple", [], ["="], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=""=FALSE', cat, "cross_type", ["coercion"], "simple", [], ["="], False, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=""=0', cat, "cross_type", ["coercion"], "simple", [], ["="], False, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=TRUE="TRUE"', cat, "cross_type", ["coercion"], "moderate", [], ["="], False, "logical", prov_detail=pd, notes="Boolean and text are different types")); n+=1
entries.append(e(ftc(n), '=1="1"', cat, "cross_type", ["coercion"], "moderate", [], ["="], False, "logical", prov_detail=pd, notes="Number and text are different types")); n+=1
entries.append(e(ftc(n), '=0.1+0.2=0.3', cat, "floating_point", ["coercion","floating_point"], "moderate", [], ["+","="], False, "logical", prov_detail=pd, notes="IEEE 754 floating point: 0.1+0.2 != 0.3")); n+=1
entries.append(e(ftc(n), '=0.1+0.2-0.3', cat, "floating_point", ["coercion","floating_point","excel_zero_reaching"], "moderate", [], ["+","-"], 0.0, "number", prov_detail=pd, notes="Excel root add/sub zero-reaching publication compensates the binary residue")); n+=1
entries.append(e(ftc(n), '=SUM(TRUE,FALSE,TRUE)', cat, "sum_bool", ["coercion"], "moderate", ["SUM"], [], 2, "number", prov_detail=pd, notes="SUM coerces boolean args to numbers")); n+=1
entries.append(e(ftc(n), '=AVERAGE(TRUE,FALSE)', cat, "avg_bool", ["coercion"], "moderate", ["AVERAGE"], [], 0.5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=SUM("1","2","3")', cat, "sum_text", ["coercion"], "moderate", ["SUM"], [], 6, "number", prov_detail=pd, notes="SUM coerces text args that look like numbers")); n+=1
entries.append(e(ftc(n), '=CONCATENATE(1,TRUE)', cat, "to_text", ["coercion"], "simple", ["CONCATENATE"], [], "1TRUE", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=1&TRUE', cat, "to_text", ["coercion"], "simple", [], ["&"], "1TRUE", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IF(2,"yes","no")', cat, "to_bool", ["coercion"], "simple", ["IF"], [], "yes", "text", prov_detail=pd, notes="Non-zero number is truthy")); n+=1
entries.append(e(ftc(n), '=IF(0,"yes","no")', cat, "to_bool", ["coercion"], "simple", ["IF"], [], "no", "text", prov_detail=pd, notes="Zero is falsy")); n+=1
entries.append(e(ftc(n), '=IF("TRUE","yes","no")', cat, "to_bool", ["coercion"], "moderate", ["IF"], [], None, "error", error="#VALUE!", prov_detail=pd, notes="Text cannot be used as logical condition")); n+=1
entries.append(e(ftc(n), '=IFERROR(1/0,0)+IFERROR(2/0,0)', cat, "error_propagation", ["coercion","error"], "moderate", ["IFERROR"], ["/","+"], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IFERROR(SQRT(-1),"err")', cat, "error_propagation", ["coercion","error"], "moderate", ["IFERROR","SQRT"], [], "err", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=NA()', cat, "error_values", ["error"], "trivial", ["NA"], [], None, "error", error="#N/A", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ISNA(NA())', cat, "error_values", ["error","information"], "simple", ["ISNA","NA"], [], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ISERROR(1/0)', cat, "error_values", ["error","information"], "simple", ["ISERROR"], ["/"], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ISNUMBER("123")', cat, "type_check", ["coercion","information"], "simple", ["ISNUMBER"], [], False, "logical", prov_detail=pd, notes="Text that looks numeric is still text")); n+=1
entries.append(e(ftc(n), '=ISNUMBER(VALUE("123"))', cat, "type_check", ["coercion","information"], "moderate", ["ISNUMBER","VALUE"], [], True, "logical", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LET(x,1/0,IFERROR(x,"caught"))', cat, "error_propagation", ["coercion","error","let"], "moderate", ["LET","IFERROR"], ["/"], "caught", "text", prov_detail=pd)); n+=1

# ============================================================
# ENGINEERING (FTC-0791 to FTC-0820) ~30 entries
# ============================================================
cat = "engineering"
pd = "Hand-authored from Excel engineering function documentation"

entries.append(e(ftc(n), '=HEX2DEC("FF")', cat, "base_conversion", ["engineering"], "simple", ["HEX2DEC"], [], 255, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DEC2HEX(255)', cat, "base_conversion", ["engineering"], "simple", ["DEC2HEX"], [], "FF", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BIN2DEC("11111111")', cat, "base_conversion", ["engineering"], "simple", ["BIN2DEC"], [], 255, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DEC2BIN(255)', cat, "base_conversion", ["engineering"], "simple", ["DEC2BIN"], [], None, "error", error="#NUM!", prov_detail=pd, notes="DEC2BIN max is 511 for positive, but result must fit 10 chars; 255=11111111 is 8 chars, should work")); n+=1
# fix: DEC2BIN(255) = "11111111" which is valid
entries[-1] = e(ftc(n-1), '=DEC2BIN(255)', cat, "base_conversion", ["engineering"], "simple", ["DEC2BIN"], [], "11111111", "text", prov_detail=pd)
entries.append(e(ftc(n), '=DEC2BIN(512)', cat, "base_conversion", ["engineering"], "simple", ["DEC2BIN"], [], None, "error", error="#NUM!", prov_detail=pd, notes="Exceeds DEC2BIN limit")); n+=1
entries.append(e(ftc(n), '=OCT2DEC("77")', cat, "base_conversion", ["engineering"], "simple", ["OCT2DEC"], [], 63, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DEC2OCT(63)', cat, "base_conversion", ["engineering"], "simple", ["DEC2OCT"], [], "77", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=HEX2BIN("F")', cat, "base_conversion", ["engineering"], "simple", ["HEX2BIN"], [], "1111", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BIN2HEX("1111")', cat, "base_conversion", ["engineering"], "simple", ["BIN2HEX"], [], "F", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CONVERT(1,"mi","km")', cat, "unit_conversion", ["engineering"], "moderate", ["CONVERT"], [], 1.609344, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CONVERT(100,"C","F")', cat, "unit_conversion", ["engineering"], "moderate", ["CONVERT"], [], 212, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CONVERT(1,"kg","lbm")', cat, "unit_conversion", ["engineering"], "moderate", ["CONVERT"], [], 2.20462262184878, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=COMPLEX(3,4)', cat, "complex_number", ["engineering"], "simple", ["COMPLEX"], [], "3+4i", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IMABS("3+4i")', cat, "complex_number", ["engineering"], "simple", ["IMABS"], [], 5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IMSUM("3+4i","1-2i")', cat, "complex_number", ["engineering"], "moderate", ["IMSUM"], [], "4+2i", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IMPRODUCT("3+4i","1-2i")', cat, "complex_number", ["engineering"], "moderate", ["IMPRODUCT"], [], "11-2i", "text", prov_detail=pd, notes="(3+4i)(1-2i)=3-6i+4i-8i^2=11-2i")); n+=1
entries.append(e(ftc(n), '=IMREAL("3+4i")', cat, "complex_number", ["engineering"], "simple", ["IMREAL"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=IMAGINARY("3+4i")', cat, "complex_number", ["engineering"], "simple", ["IMAGINARY"], [], 4, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DELTA(5,5)', cat, "engineering_misc", ["engineering"], "trivial", ["DELTA"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=DELTA(5,6)', cat, "engineering_misc", ["engineering"], "trivial", ["DELTA"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=GESTEP(5,4)', cat, "engineering_misc", ["engineering"], "trivial", ["GESTEP"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=GESTEP(3,4)', cat, "engineering_misc", ["engineering"], "trivial", ["GESTEP"], [], 0, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ERF(1)', cat, "engineering_misc", ["engineering"], "moderate", ["ERF"], [], 0.842700792949715, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=ERFC(1)', cat, "engineering_misc", ["engineering"], "moderate", ["ERFC"], [], 0.157299207050285, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BITAND(5,3)', cat, "bitwise", ["engineering"], "simple", ["BITAND"], [], 1, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BITOR(5,3)', cat, "bitwise", ["engineering"], "simple", ["BITOR"], [], 7, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BITXOR(5,3)', cat, "bitwise", ["engineering"], "simple", ["BITXOR"], [], 6, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BITLSHIFT(1,3)', cat, "bitwise", ["engineering"], "simple", ["BITLSHIFT"], [], 8, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=BITRSHIFT(8,3)', cat, "bitwise", ["engineering"], "simple", ["BITRSHIFT"], [], 1, "number", prov_detail=pd)); n+=1

# ============================================================
# LOOKUP NON-REF (FTC-0821 to FTC-0860) ~40 entries
# ============================================================
cat = "lookup_nonref"
pd = "Hand-authored from Excel lookup function documentation; rewritten with LET/array constants"

entries.append(e(ftc(n), '=VLOOKUP(2,{1,"a";2,"b";3,"c"},2,FALSE)', cat, "vlookup", ["lookup","let_rewrite"], "moderate", ["VLOOKUP"], [], "b", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=VLOOKUP(4,{1,"a";2,"b";3,"c"},2,FALSE)', cat, "vlookup", ["lookup","let_rewrite"], "moderate", ["VLOOKUP"], [], None, "error", error="#N/A", prov_detail=pd, notes="No match")); n+=1
entries.append(e(ftc(n), '=VLOOKUP(2.5,{1,10;2,20;3,30},2,TRUE)', cat, "vlookup", ["lookup","approximate"], "moderate", ["VLOOKUP"], [], 20, "number", prov_detail=pd, notes="Approximate match: 2.5 matches 2")); n+=1
entries.append(e(ftc(n), '=HLOOKUP("b",{"a","b","c";1,2,3},2,FALSE)', cat, "hlookup", ["lookup","let_rewrite"], "moderate", ["HLOOKUP"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XLOOKUP("b",{"a";"b";"c"},{10;20;30})', cat, "xlookup", ["lookup","tier4"], "moderate", ["XLOOKUP"], [], 20, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XLOOKUP("d",{"a";"b";"c"},{10;20;30},-1)', cat, "xlookup", ["lookup","tier4"], "moderate", ["XLOOKUP"], [], -1, "number", prov_detail=pd, notes="Not found: returns if_not_found")); n+=1
entries.append(e(ftc(n), '=XLOOKUP(25,{10;20;30;40;50},{100;200;300;400;500},,-1)', cat, "xlookup", ["lookup","tier4","approximate"], "complex", ["XLOOKUP"], [], 200, "number", prov_detail=pd, notes="Approximate match: next smaller")); n+=1
entries.append(e(ftc(n), '=XLOOKUP(25,{10;20;30;40;50},{100;200;300;400;500},,1)', cat, "xlookup", ["lookup","tier4","approximate"], "complex", ["XLOOKUP"], [], 300, "number", prov_detail=pd, notes="Approximate match: next larger")); n+=1
entries.append(e(ftc(n), '=XLOOKUP("*ello",{"Hello";"World";"Jello"},{1;2;3},,2)', cat, "xlookup", ["lookup","tier4","wildcard"], "complex", ["XLOOKUP"], [], 1, "number", prov_detail=pd, notes="Wildcard match")); n+=1
entries.append(e(ftc(n), '=INDEX({10,20,30;40,50,60},2,3)', cat, "index_match", ["lookup"], "simple", ["INDEX"], [], 60, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=MATCH("c",{"a","b","c","d"},0)', cat, "index_match", ["lookup"], "simple", ["MATCH"], [], 3, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=INDEX({"a","b","c","d"},1,MATCH("c",{"a","b","c","d"},0))', cat, "index_match", ["lookup"], "moderate", ["INDEX","MATCH"], [], "c", "text", prov_detail=pd, notes="INDEX/MATCH pattern")); n+=1
entries.append(e(ftc(n), '=CHOOSE(2,"a","b","c")', cat, "choose", ["lookup"], "simple", ["CHOOSE"], [], "b", "text", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=CHOOSE(4,"a","b","c")', cat, "choose", ["lookup"], "simple", ["CHOOSE"], [], None, "error", error="#VALUE!", prov_detail=pd, notes="Index out of range")); n+=1
entries.append(e(ftc(n), '=LET(data,{1,"a",100;2,"b",200;3,"c",300},key,2,row,MATCH(key,INDEX(data,,1),0),INDEX(data,row,3))', cat, "index_match", ["lookup","let"], "complex", ["LET","MATCH","INDEX"], [], 200, "number", prov_detail=pd, notes="INDEX/MATCH via LET")); n+=1
entries.append(e(ftc(n), '=XMATCH("b",{"a";"b";"c"})', cat, "xmatch", ["lookup","tier4"], "simple", ["XMATCH"], [], 2, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XMATCH("d",{"a";"b";"c"})', cat, "xmatch", ["lookup","tier4"], "simple", ["XMATCH"], [], None, "error", error="#N/A", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=XMATCH(25,{10;20;30;40;50},-1)', cat, "xmatch", ["lookup","tier4","approximate"], "moderate", ["XMATCH"], [], 2, "number", prov_detail=pd, notes="Next smaller match at position 2")); n+=1
entries.append(e(ftc(n), '=LET(lookup_tbl,{"apple",1.5;"banana",0.75;"cherry",3.0},fruit,"banana",price,XLOOKUP(fruit,INDEX(lookup_tbl,,1),INDEX(lookup_tbl,,2)),price*10)', cat, "xlookup", ["lookup","tier4","let"], "complex", ["LET","XLOOKUP","INDEX"], ["*"], 7.5, "number", prov_detail=pd)); n+=1
entries.append(e(ftc(n), '=LOOKUP(2.5,{1,2,3,4},{10,20,30,40})', cat, "lookup_classic", ["lookup"], "moderate", ["LOOKUP"], [], 20, "number", prov_detail=pd, notes="LOOKUP with approximate match")); n+=1

# ============================================================
# NESTED/COMPLEX COMBINATIONS (FTC-0861 to FTC-0960) ~100 entries
# ============================================================
cat = "nested_complex"
pd = "Hand-authored complex formula combinations"

entries.append(e(ftc(n), '=LET(data,{5,3,8,1,9,2,7,4,6},sorted,SORT(data,,1),n,COLUMNS(data),IF(MOD(n,2)=1,INDEX(sorted,1,INT(n/2)+1),(INDEX(sorted,1,n/2)+INDEX(sorted,1,n/2+1))/2))', cat, "statistical_complex", ["nested","let","sort"], "expert", ["LET","SORT","COLUMNS","IF","MOD","INDEX","INT"], ["=","/","+"], 5, "number", prov_detail=pd, notes="Median calculation from scratch")); n+=1
entries.append(e(ftc(n), '=LET(text,"Hello World 123",chars,MID(text,SEQUENCE(LEN(text)),1),digits,FILTER(chars,ISNUMBER(VALUE(IFERROR(chars*1,""))),""),CONCAT(digits))', cat, "text_extraction", ["nested","let","filter","mid","sequence"], "expert", ["LET","MID","SEQUENCE","LEN","FILTER","ISNUMBER","VALUE","IFERROR","CONCAT"], ["*"], "123", "text", prov_detail=pd, notes="Extract digits from string")); n+=1
entries.append(e(ftc(n), '=LET(n,10,seq,SEQUENCE(n),is_prime,MAP(seq,LAMBDA(x,IF(x<2,FALSE,AND(MOD(x,SEQUENCE(MAX(1,INT(SQRT(x)))-1,,2))<>0)))),SUM(--is_prime))', cat, "math_complex", ["nested","let","map","lambda","prime"], "expert", ["LET","SEQUENCE","MAP","LAMBDA","IF","AND","MOD","INT","SQRT","MAX","SUM"], ["<",">","=","-","--","<>"], 4, "number", prov_detail=pd, notes="Count primes 1-10: {2,3,5,7} = 4")); n+=1
entries.append(e(ftc(n), '=LET(a,{1,2;3,4},b,{5,6;7,8},r11,INDEX(a,1,1)*INDEX(b,1,1)+INDEX(a,1,2)*INDEX(b,2,1),r12,INDEX(a,1,1)*INDEX(b,1,2)+INDEX(a,1,2)*INDEX(b,2,2),r11+r12)', cat, "matrix_complex", ["nested","let","matrix"], "expert", ["LET","INDEX"], ["*","+"], 40+44, "number", prov_detail=pd, notes="Partial matrix multiply: top row of A*B")); n+=1
# Fix: r11=1*5+2*7=19, r12=1*6+2*8=22, sum=41
entries[-1] = e(ftc(n-1), '=LET(a,{1,2;3,4},b,{5,6;7,8},r11,INDEX(a,1,1)*INDEX(b,1,1)+INDEX(a,1,2)*INDEX(b,2,1),r12,INDEX(a,1,1)*INDEX(b,1,2)+INDEX(a,1,2)*INDEX(b,2,2),r11+r12)', cat, "matrix_complex", ["nested","let","matrix"], "expert", ["LET","INDEX"], ["*","+"], 41, "number", prov_detail=pd, notes="Partial matrix multiply: r11=19, r12=22, sum=41")
entries.append(e(ftc(n), '=LET(data,{85,92,78,95,88,76,91,83,97,72},n,COUNTA(data),mean,AVERAGE(data),sorted,SORT(data),q1,PERCENTILE(data,0.25),q3,PERCENTILE(data,0.75),iqr,q3-q1,iqr)', cat, "stats_complex", ["nested","let","percentile"], "expert", ["LET","COUNTA","AVERAGE","SORT","PERCENTILE"], ["-"], 12.25, "number", prov_detail=pd, notes="IQR calculation")); n+=1
entries.append(e(ftc(n), '=LET(principal,10000,rate,0.05,years,SEQUENCE(5),fv,MAP(years,LAMBDA(y,principal*(1+rate)^y)),INDEX(fv,5,1))', cat, "finance_complex", ["nested","let","map","lambda","finance"], "expert", ["LET","SEQUENCE","MAP","LAMBDA"], ["*","+","^"], 12762.8156250000, "number", prov_detail=pd, notes="Compound interest over 5 years")); n+=1
entries.append(e(ftc(n), '=LET(words,TEXTSPLIT("the quick brown fox jumps"," "),caps,MAP(words,LAMBDA(w,UPPER(LEFT(w,1))&MID(w,2,LEN(w)))),TEXTJOIN(" ",FALSE,caps))', cat, "text_complex", ["nested","let","map","lambda","text"], "expert", ["LET","TEXTSPLIT","MAP","LAMBDA","UPPER","LEFT","MID","LEN","TEXTJOIN"], ["&"], "The Quick Brown Fox Jumps", "text", prov_detail=pd, notes="Title case implementation")); n+=1
entries.append(e(ftc(n), '=LET(data,{3,1,4,1,5,9,2,6,5,3,5},unique_vals,UNIQUE(TOROW(data)),counts,MAP(unique_vals,LAMBDA(v,SUM(--(data=v)))),max_count,MAX(counts),mode_val,INDEX(FILTER(unique_vals,counts=max_count),1,1),mode_val)', cat, "stats_complex", ["nested","let","unique","map","lambda","filter"], "expert", ["LET","UNIQUE","TOROW","MAP","LAMBDA","SUM","MAX","INDEX","FILTER"], ["=","--"], 5, "number", prov_detail=pd, notes="Mode from scratch: 5 appears 3 times")); n+=1
entries.append(e(ftc(n), '=LET(n,5,seq,SEQUENCE(n),fact,REDUCE(1,seq,LAMBDA(acc,x,acc*x)),fact)', cat, "math_complex", ["nested","let","reduce","lambda"], "complex", ["LET","SEQUENCE","REDUCE","LAMBDA"], ["*"], 120, "number", prov_detail=pd, notes="5! via REDUCE")); n+=1
entries.append(e(ftc(n), '=LET(str,"racecar",chars,MID(str,SEQUENCE(LEN(str)),1),rev,MID(str,LEN(str)+1-SEQUENCE(LEN(str)),1),EXACT(CONCAT(chars),CONCAT(rev)))', cat, "text_complex", ["nested","let","palindrome"], "expert", ["LET","MID","SEQUENCE","LEN","EXACT","CONCAT"], ["+","-"], True, "logical", prov_detail=pd, notes="Palindrome check")); n+=1
entries.append(e(ftc(n), '=LET(nums,{15,28,36,42,55,63,77,84,91},divisible_by_7,FILTER(nums,MOD(nums,7)=0),SUM(divisible_by_7))', cat, "filter_complex", ["nested","let","filter","mod"], "complex", ["LET","FILTER","MOD","SUM"], ["="], 189, "number", prov_detail=pd, notes="Sum numbers divisible by 7: 28+42+63+77+84-77+91-91... let me recalc: 28+42+63+84=217")); n+=1
# fix: 28,42,63,77,84,91 are div by 7. Sum=28+42+63+77+84+91=385
entries[-1] = e(ftc(n-1), '=LET(nums,{15,28,36,42,55,63,77,84,91},divisible_by_7,FILTER(nums,MOD(nums,7)=0),SUM(divisible_by_7))', cat, "filter_complex", ["nested","let","filter","mod"], "complex", ["LET","FILTER","MOD","SUM"], ["="], 385, "number", prov_detail=pd, notes="28+42+63+77+84+91=385")
entries.append(e(ftc(n), '=LET(data,{1,2,3,4,5,6,7,8,9,10},running_avg,SCAN(0,SEQUENCE(COLUMNS(data)),LAMBDA(acc,i,AVERAGE(INDEX(data,1,SEQUENCE(i))))),INDEX(running_avg,1,COLUMNS(data)))', cat, "stats_complex", ["nested","let","scan","lambda","average"], "expert", ["LET","SCAN","SEQUENCE","COLUMNS","LAMBDA","AVERAGE","INDEX"], [], 5.5, "number", prov_detail=pd, notes="Running average: final = average of all = 5.5")); n+=1
entries.append(e(ftc(n), '=LET(a,{1,0,0;0,1,0;0,0,1},b,{1,2,3;4,5,6;7,8,9},SUMPRODUCT(a*b))', cat, "matrix_complex", ["nested","let","matrix","trace"], "complex", ["LET","SUMPRODUCT"], ["*"], 15, "number", prov_detail=pd, notes="Matrix trace via identity mask: 1+5+9=15")); n+=1
entries.append(e(ftc(n), '=LET(sentence,"hello world this is a test",words,TEXTSPLIT(sentence," "),lengths,MAP(words,LAMBDA(w,LEN(w))),MAX(lengths))', cat, "text_complex", ["nested","let","textsplit","map","lambda"], "complex", ["LET","TEXTSPLIT","MAP","LAMBDA","LEN","MAX"], [], 5, "number", prov_detail=pd, notes="Longest word length: hello/world = 5")); n+=1

# pbartxl: INJECTλ / SUBMATRIXλ concept adapted
entries.append(e(ftc(n), '=LET(arr,{1,2,3,4;5,6,7,8;9,10,11,12},sub,TAKE(DROP(arr,0,0),2,2),SUM(sub))', cat, "submatrix", ["nested","let","pbartxl","take","drop"], "complex", ["LET","TAKE","DROP","SUM"], [], 14, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl SUBMATRIXλ concept - extracting submatrix", notes="Top-left 2x2: 1+2+5+6=14")); n+=1

# pbartxl: FIFO-like accumulation
entries.append(e(ftc(n), '=LET(inflow,{100;200;150;250},outflow,{80;120;200;150},cumIn,SCAN(0,inflow,LAMBDA(a,x,a+x)),cumOut,SCAN(0,outflow,LAMBDA(a,x,a+x)),INDEX(cumIn,4,1)-INDEX(cumOut,4,1))', cat, "fifo_complex", ["nested","let","scan","lambda","pbartxl"], "expert", ["LET","SCAN","LAMBDA","INDEX"], ["+","-"], 150, "number", sids=sid_pbartxl, prov="adapted", prov_detail="Adapted from pbartxl Calculateλ FIFO pattern", notes="Net inventory: 700-550=150")); n+=1

# Complex type coercion in nested context
entries.append(e(ftc(n), '=LET(mixed,{1,TRUE,"3",FALSE,5},numeric,MAP(mixed,LAMBDA(v,IFERROR(--v,0))),SUM(numeric))', cat, "coercion_complex", ["nested","let","map","lambda","coercion"], "complex", ["LET","MAP","LAMBDA","IFERROR","SUM"], ["--"], 10, "number", prov_detail=pd, notes="Coerce mixed types: 1+1+3+0+5=10")); n+=1

# Nested IF cascade
entries.append(e(ftc(n), '=LET(score,75,grade,IF(score>=90,"A",IF(score>=80,"B",IF(score>=70,"C",IF(score>=60,"D","F")))),grade)', cat, "nested_if", ["nested","let","if"], "moderate", ["LET","IF"], [">="], "C", "text", prov_detail=pd)); n+=1

# Complex financial
entries.append(e(ftc(n), '=LET(cf,{-1000,200,300,400,500},r,0.1,years,SEQUENCE(COLUMNS(cf))-1,pv_factors,1/(1+r)^years,NPV_manual,SUMPRODUCT(cf,pv_factors),NPV_manual)', cat, "finance_complex", ["nested","let","finance"], "expert", ["LET","SEQUENCE","COLUMNS","SUMPRODUCT"], ["-","^","/","+"], 169.865446196676, "number", prov_detail=pd, notes="Manual NPV calculation")); n+=1

# String reversal
entries.append(e(ftc(n), '=LET(s,"ABCDE",n,LEN(s),chars,MID(s,n+1-SEQUENCE(n),1),CONCAT(chars))', cat, "text_complex", ["nested","let","reverse"], "complex", ["LET","LEN","MID","SEQUENCE","CONCAT"], ["+","-"], "EDCBA", "text", prov_detail=pd)); n+=1

# Weighted average
entries.append(e(ftc(n), '=LET(values,{80,90,70,100},weights,{0.2,0.3,0.2,0.3},SUMPRODUCT(values,weights))', cat, "stats_complex", ["nested","let"], "moderate", ["LET","SUMPRODUCT"], [], 86, "number", prov_detail=pd, notes="Weighted average")); n+=1

# FizzBuzz single value
entries.append(e(ftc(n), '=LET(n,15,IF(AND(MOD(n,3)=0,MOD(n,5)=0),"FizzBuzz",IF(MOD(n,3)=0,"Fizz",IF(MOD(n,5)=0,"Buzz",n))))', cat, "classic_problem", ["nested","let","if","mod"], "complex", ["LET","IF","AND","MOD"], ["="], "FizzBuzz", "text", prov_detail=pd)); n+=1

# Matrix determinant 2x2
entries.append(e(ftc(n), '=LET(m,{3,8;4,6},INDEX(m,1,1)*INDEX(m,2,2)-INDEX(m,1,2)*INDEX(m,2,1))', cat, "matrix_complex", ["nested","let","matrix","determinant"], "complex", ["LET","INDEX"], ["*","-"], -14, "number", prov_detail=pd, notes="2x2 determinant: 3*6-8*4=-14")); n+=1

# Euclidean distance
entries.append(e(ftc(n), '=LET(p1,{1,2,3},p2,{4,6,3},SQRT(SUMPRODUCT((p1-p2)^2)))', cat, "math_complex", ["nested","let"], "complex", ["LET","SQRT","SUMPRODUCT"], ["-","^"], 5, "number", prov_detail=pd, notes="Distance: sqrt(9+16+0)=5")); n+=1

# Conditional formatting logic
entries.append(e(ftc(n), '=LET(data,{85,42,91,67,78,55,93,71},threshold,70,above,FILTER(data,data>=threshold),AVERAGE(above))', cat, "filter_complex", ["nested","let","filter","average"], "complex", ["LET","FILTER","AVERAGE"], [">="], 83.6, "number", prov_detail=pd, notes="Average of values >= 70")); n+=1

# Nested REDUCE with complex accumulator
entries.append(e(ftc(n), '=LET(words,{"hello";"world";"test"},result,REDUCE("",words,LAMBDA(acc,w,IF(acc="",w,acc&", "&w))),result)', cat, "reduce_complex", ["nested","let","reduce","lambda"], "complex", ["LET","REDUCE","LAMBDA","IF"], ["=","&"], "hello, world, test", "text", prov_detail=pd, notes="Join with separator via REDUCE")); n+=1

# Running maximum
entries.append(e(ftc(n), '=LET(data,{3;1;4;1;5;9;2;6},running_max,SCAN(0,data,LAMBDA(mx,x,MAX(mx,x))),INDEX(running_max,6,1))', cat, "scan_complex", ["nested","let","scan","lambda"], "complex", ["LET","SCAN","LAMBDA","MAX","INDEX"], [], 9, "number", prov_detail=pd, notes="Running max at position 6 = 9")); n+=1

# Boolean array operations
entries.append(e(ftc(n), '=LET(data,{1,2,3,4,5,6,7,8,9,10},even,MOD(data,2)=0,gt5,data>5,both,even*gt5,SUM(both))', cat, "boolean_complex", ["nested","let","boolean","array"], "complex", ["LET","MOD","SUM"], ["=",">","*"], 3, "number", prov_detail=pd, notes="Even AND >5: 6,8,10 = 3 matches")); n+=1


# Write all entries
with open(OUTPUT, 'a', encoding='utf-8') as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + '\n')

print(f"Appended {len(entries)} entries (FTC-0161 to FTC-{160+len(entries):04d})")
print(f"Last test_id: {entries[-1]['test_id']}")

# Count total
with open(OUTPUT, 'r', encoding='utf-8') as f:
    total = sum(1 for _ in f)
print(f"Total entries in file: {total}")
