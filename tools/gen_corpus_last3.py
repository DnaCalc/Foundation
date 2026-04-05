#!/usr/bin/env python3
"""Last 3 entries to reach exactly 1000."""
import json, os

JSONL_PATH = os.path.join(os.path.dirname(__file__), "..",
                          "reference", "test-corpus", "formula",
                          "single-cell", "formulas.jsonl")

base = {"conformance_req_ids": [], "evidence_ids": [], "source_ids": [],
        "provenance": "authored",
        "provenance_detail": "AI-generated edge case for DnaCalc test corpus",
        "result_is_array": False, "array_dimensions": None,
        "deterministic": True, "requires_locale": False,
        "requires_date_system": None}

entries = [
    {**base, "test_id": "FTC-0998", "category": "nested_complex",
     "subcategory": "recursive_binary_search",
     "formula": '=LET(bsrch,LAMBDA(self,LAMBDA(arr,LAMBDA(target,LAMBDA(lo,LAMBDA(hi,IF(lo>hi,-1,LET(mid,INT((lo+hi)/2),val,INDEX(arr,mid),IF(val=target,mid,IF(val<target,self(self)(arr)(target)(mid+1)(hi),self(self)(arr)(target)(lo)(mid-1)))))))))),bsrch(bsrch)({10,20,30,40,50,60,70,80,90,100})(70)(1)(10))',
     "expected_result": 7, "expected_result_type": "number", "expected_error": None,
     "tags": ["binary_search", "recursion", "lambda"],
     "functions_exercised": ["LET", "LAMBDA", "IF", "INT", "INDEX"],
     "operators_exercised": ["+", "/", "-", ">", "=", "<"],
     "complexity": "expert", "let_bindings": 3,
     "notes": "Binary search via recursive LAMBDA: find 70 in sorted array, returns position 7"},

    {**base, "test_id": "FTC-0999", "category": "let_lambda_functional",
     "subcategory": "applicative_functor",
     "formula": '=LET(ap,LAMBDA(fArr,xArr,TOCOL(MAP(fArr,LAMBDA(f,MAP(xArr,LAMBDA(x,f(x))))))),fns,MAP({1,2,3},LAMBDA(n,LAMBDA(x,x*n))),SUM(ap(fns,{10,20,30})))',
     "expected_result": 360, "expected_result_type": "number", "expected_error": None,
     "tags": ["applicative", "functor", "higher_order", "map"],
     "functions_exercised": ["LET", "LAMBDA", "MAP", "TOCOL", "SUM"],
     "operators_exercised": ["*"],
     "complexity": "expert", "let_bindings": 2,
     "notes": "Applicative functor: apply array of functions to array of values. fns=[*1,*2,*3], vals=[10,20,30]. All combos: 10+20+30+20+40+60+30+60+90=360"},

    {**base, "test_id": "FTC-1000", "category": "nested_complex",
     "subcategory": "everything_formula",
     "formula": '=LET(data,SEQUENCE(10),evens,FILTER(data,MOD(data,2)=0),squares,MAP(evens,LAMBDA(x,x*x)),total,SUM(squares),mean,AVERAGE(squares),stdev,STDEV(squares),cv,ROUND(stdev/mean*100,1),zScores,MAP(squares,LAMBDA(x,ROUND((x-mean)/stdev,2))),minZ,MIN(zScores),maxZ,MAX(zScores),total+cv+minZ+maxZ)',
     "expected_result": None, "expected_result_type": "number", "expected_error": None,
     "tags": ["everything", "combined", "statistics", "lambda", "dynamic_array", "capstone"],
     "functions_exercised": ["LET", "SEQUENCE", "FILTER", "MOD", "MAP", "LAMBDA", "SUM", "AVERAGE", "STDEV", "ROUND", "MIN", "MAX"],
     "operators_exercised": ["=", "*", "+", "/", "-"],
     "complexity": "expert", "let_bindings": 10,
     "notes": "The capstone formula (#1000): generates data, filters, transforms, computes statistics, z-scores, and combines. Tests SEQUENCE+FILTER+MAP+statistical functions+LET chain together."},
]

# Calculate expected for FTC-1000
# data = 1..10, evens = {2,4,6,8,10}, squares = {4,16,36,64,100}
# total = 220, mean = 44, stdev = sqrt(((4-44)^2+(16-44)^2+(36-44)^2+(64-44)^2+(100-44)^2)/4)
# variances: 1600+784+64+400+3136 = 5984, stdev = sqrt(5984/4) = sqrt(1496) = 38.6782...
# cv = round(38.6782/44*100, 1) = round(87.905, 1) = 87.9
# zScores: (4-44)/38.678=-1.03, (16-44)/38.678=-0.72, (36-44)/38.678=-0.21, (64-44)/38.678=0.52, (100-44)/38.678=1.45
# minZ = -1.03, maxZ = 1.45
# result = 220 + 87.9 + (-1.03) + 1.45 = 308.32
import math
squares = [4, 16, 36, 64, 100]
total = sum(squares)  # 220
mean = total / 5  # 44
var = sum((x - mean)**2 for x in squares) / 4  # sample variance
stdev = math.sqrt(var)
cv = round(stdev / mean * 100, 1)
zscores = [round((x - mean) / stdev, 2) for x in squares]
minZ = min(zscores)
maxZ = max(zscores)
result = total + cv + minZ + maxZ
entries[2]["expected_result"] = result
entries[2]["notes"] += f" Expected: {total}+{cv}+{minZ}+{maxZ}={result}"

with open(JSONL_PATH, "a", encoding="utf-8") as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

print(f"Appended 3 entries (FTC-0998 to FTC-1000)")
print(f"Total entries in file: 1000")
print(f"FTC-1000 expected result: {result}")
print(f"  squares={squares}, total={total}, mean={mean}, stdev={stdev:.4f}, cv={cv}")
print(f"  zscores={zscores}, minZ={minZ}, maxZ={maxZ}")
