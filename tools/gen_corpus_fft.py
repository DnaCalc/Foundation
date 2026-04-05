#!/usr/bin/env python3
"""
Add FFT-derived formulas from pbartxl's Cooley-Tukey implementation.
Source: https://github.com/pbartxl/PBart-s-Lambda-functions/pull/1

These adapt pbartxl's FFT/IFFT/Convolution patterns into self-contained
single-cell formulas via LET bindings. The full FFT requires multiple
named LAMBDAs (FFTλ, I⊗S, I⊗B, Ω, cProductλ, etc.) — we inline the
essential pieces and test individual building blocks plus small-N FFTs.
"""
import json, os, math

JSONL_PATH = os.path.join(os.path.dirname(__file__), "..",
                          "reference", "test-corpus", "formula",
                          "single-cell", "formulas.jsonl")

with open(JSONL_PATH) as f:
    existing = sum(1 for _ in f)

seq = existing

def ftc(n):
    return f"FTC-{n:04d}"

SRC = ["R-SRC-124"]
PROV = "adapted"
PROV_DETAIL = "Adapted from pbartxl Cooley-Tukey FFT implementation (PR #1 on PBart-s-Lambda-functions repo)"

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
        "source_ids": SRC, "provenance": PROV,
        "provenance_detail": PROV_DETAIL,
        "notes": notes
    }

entries = []

# ============================================================
# Building blocks of the FFT
# ============================================================

# 1. Complex multiplication (cProductλ) — the core of butterfly operations
entries.append(e("let_lambda_functional", "complex_multiply_lambda",
    '=LET(cMul,LAMBDA(w,Z,LET(u,TAKE(w,,COLUMNS(w)/2),v,TAKE(w,,-COLUMNS(w)/2),X,TAKE(Z,,COLUMNS(Z)/2),Y,TAKE(Z,,-COLUMNS(Z)/2),HSTACK(u*X-v*Y,u*Y+v*X))),a,HSTACK(3,4),b,HSTACK(1,2),result,cMul(a,b),INDEX(result,1,1)+INDEX(result,1,2)*100)',
    -510, ["complex_multiply", "fft_building_block", "pbartxl"],
    ["LET", "LAMBDA", "TAKE", "COLUMNS", "HSTACK", "INDEX"],
    operators=["*", "-", "+", "/"], let_bindings=5, complexity="advanced",
    notes="Complex multiply (3+4i)*(1+2i) = (3-8)+(6+4)i = -5+10i. Encoded as HSTACK(re,im). Result: -5+10*100=-510"))

# 2. Complex number real/imaginary extraction (Rℓ, Im)
entries.append(e("let_lambda_functional", "complex_extract_parts",
    '=LET(z,HSTACK(3,4,-1,2),Re,LAMBDA(z,TAKE(z,,COLUMNS(z)/2)),Im,LAMBDA(z,TAKE(z,,-COLUMNS(z)/2)),SUM(Re(z))+SUM(Im(z))*100)',
    102, ["complex_extract", "fft_building_block", "pbartxl"],
    ["LET", "LAMBDA", "TAKE", "COLUMNS", "HSTACK", "SUM"],
    operators=["+", "*", "/"], let_bindings=3, complexity="intermediate",
    notes="Extract Re and Im from paired columns: z=[3,4,-1,2] → Re={3,-1}=2, Im={4,2}=6. 2+6*100=602. Wait: HSTACK(3,4,-1,2) is 1x4; Re=TAKE(,,2)={3,4}, Im=TAKE(,,-2)={-1,2}. SUM(Re)=7, SUM(Im)=1. 7+100=107"))

# Recalculate: HSTACK(3,4,-1,2) creates {3,4,-1,2}. COLUMNS=4, /2=2.
# TAKE(z,,2) = first 2 cols = {3,4}. TAKE(z,,-2) = last 2 cols = {-1,2}.
# SUM(Re) = 3+4 = 7. SUM(Im) = -1+2 = 1. Result = 7+1*100 = 107.
entries[-1]["expected_result"] = 107
entries[-1]["notes"] = "Extract Re/Im from paired-column complex: z={3,4,-1,2} → Re={3,4}=7, Im={-1,2}=1. 7+1*100=107"

# 3. Twiddle factors (Ω) — roots of unity for FFT butterfly
entries.append(e("let_lambda_functional", "twiddle_factors_2point",
    '=LET(Omega,LAMBDA(n,sign,LET(k,SEQUENCE(n),theta,-sign*2*PI()*k/n,HSTACK(COS(theta),SIN(theta)))),w,Omega(2,1),ROUND(INDEX(w,1,1)+INDEX(w,2,1),10))',
    0.0, ["twiddle_factor", "roots_of_unity", "fft", "pbartxl"],
    ["LET", "LAMBDA", "SEQUENCE", "PI", "COS", "SIN", "HSTACK", "ROUND", "INDEX"],
    operators=["*", "-", "/", "+"], let_bindings=2, complexity="advanced",
    notes="2-point twiddle factors: W_2^0=1, W_2^1=-1. Sum of real parts = 1+(-1) = 0"))

# 4. Twiddle factors — 4-point, sum of imaginary parts
entries.append(e("let_lambda_functional", "twiddle_factors_4point",
    '=LET(Omega,LAMBDA(n,sign,LET(k,SEQUENCE(n),theta,-sign*2*PI()*k/n,HSTACK(COS(theta),SIN(theta)))),w,Omega(4,1),ROUND(SUM(TAKE(w,,-1)),10))',
    0.0, ["twiddle_factor", "4point", "fft", "pbartxl"],
    ["LET", "LAMBDA", "SEQUENCE", "PI", "COS", "SIN", "HSTACK", "ROUND", "SUM", "TAKE"],
    operators=["*", "-", "/"], let_bindings=2, complexity="advanced",
    notes="4-point twiddle: W_4^k for k=1..4. Im parts: sin(-π/2)+sin(-π)+sin(-3π/2)+sin(-2π) = -1+0+1+0 = 0"))

# 5. Wrapλ — the reshape utility used throughout (WRAPCOLS of TOCOL)
entries.append(e("let_lambda_functional", "wrap_reshape",
    '=LET(Wrap,LAMBDA(z,p,WRAPCOLS(TOCOL(z,,TRUE),p)),data,{1,2,3,4,5,6,7,8},wrapped,Wrap(data,4),INDEX(wrapped,2,1))',
    5, ["wrap", "reshape", "tocol_wrapcols", "pbartxl"],
    ["LET", "LAMBDA", "WRAPCOLS", "TOCOL", "INDEX"],
    let_bindings=3, complexity="intermediate",
    notes="Wrapλ reshapes flat array into columns of size p: {1,2,3,4,5,6,7,8} → {1,2,3,4;5,6,7,8}. Element [2,1]=5"))

# 6. Bit-reversal permutation stage (I⊗S) — one stage of the shuffle
entries.append(e("let_lambda_functional", "bit_reversal_stage",
    '=LET(Wrap,LAMBDA(z,p,WRAPCOLS(TOCOL(z,,TRUE),p)),IoS,LAMBDA(x,p,LET(w,Wrap(x,2),x0,TAKE(w,1),x1,TAKE(w,-1),y0,Wrap(x0,p),y1,Wrap(x1,p),VSTACK(y0,y1))),data,{1;2;3;4;5;6;7;8},result,IoS(data,2),INDEX(TOCOL(result),1)+INDEX(TOCOL(result),5)*100)',
    105, ["bit_reversal", "shuffle", "fft_stage", "pbartxl"],
    ["LET", "LAMBDA", "WRAPCOLS", "TOCOL", "TAKE", "VSTACK", "INDEX"],
    let_bindings=4, complexity="expert",
    notes="I⊗S bit-reversal shuffle separates even/odd indices. First element + 5th*100 tests the permutation"))

# 7. Small 2-point DFT via butterfly
entries.append(e("nested_complex", "dft_2point",
    '=LET(x,HSTACK(3,0,1,0),Re,LAMBDA(z,TAKE(z,,COLUMNS(z)/2)),Im,LAMBDA(z,TAKE(z,,-COLUMNS(z)/2)),x0,TAKE(x,1),x1,TAKE(x,-1),y0Re,INDEX(Re(x0),1,1)+INDEX(Re(x1),1,1),y1Re,INDEX(Re(x0),1,1)-INDEX(Re(x1),1,1),y0Re+y1Re*100)',
    204, ["dft", "2point", "butterfly", "pbartxl", "fft"],
    ["LET", "LAMBDA", "TAKE", "COLUMNS", "HSTACK", "INDEX"],
    operators=["+", "-", "/", "*"], let_bindings=7, complexity="advanced",
    notes="2-point DFT of [3,1]: X[0]=3+1=4, X[1]=3-1=2. Encoded: 4+2*100=204"))

# 8. Complex magnitude for verifying FFT output
entries.append(e("let_lambda_functional", "complex_magnitude",
    '=LET(cAbs,LAMBDA(z,LET(re,TAKE(z,,COLUMNS(z)/2),im,TAKE(z,,-COLUMNS(z)/2),SQRT(re^2+im^2))),z,HSTACK(3,4),ROUND(INDEX(cAbs(z),1,1),6))',
    5.0, ["complex_magnitude", "abs", "pbartxl"],
    ["LET", "LAMBDA", "TAKE", "COLUMNS", "HSTACK", "SQRT", "ROUND", "INDEX"],
    operators=["^", "+", "/"], let_bindings=2, complexity="intermediate",
    notes="|3+4i| = 5"))

# 9. 4-point DFT computed manually (verifiable)
entries.append(e("nested_complex", "dft_4point_dc_component",
    '=LET(x,{1;2;3;4},N,4,k,0,ROUND(SUM(x*COS(2*PI()*k*SEQUENCE(N,,0)/N)),6))',
    10.0, ["dft", "4point", "dc_component", "pbartxl"],
    ["LET", "SUM", "COS", "PI", "SEQUENCE", "ROUND"],
    operators=["*", "/"], let_bindings=3, complexity="advanced",
    notes="DFT X[0] (DC component) = sum of all values = 1+2+3+4 = 10"))

# 10. 4-point DFT at k=1 (real part)
entries.append(e("nested_complex", "dft_4point_k1_real",
    '=LET(x,{1;2;3;4},N,4,k,1,ROUND(SUM(x*COS(2*PI()*k*SEQUENCE(N,,0)/N)),6))',
    -2.0, ["dft", "4point", "frequency", "pbartxl"],
    ["LET", "SUM", "COS", "PI", "SEQUENCE", "ROUND"],
    operators=["*", "/"], let_bindings=3, complexity="advanced",
    notes="DFT X[1] real part for {1,2,3,4}: Re = sum(x_n * cos(2πn/4)) = 1*1+2*0+3*(-1)+4*0 = -2"))

# 11. 4-point DFT at k=1 (imaginary part)
entries.append(e("nested_complex", "dft_4point_k1_imag",
    '=LET(x,{1;2;3;4},N,4,k,1,ROUND(-SUM(x*SIN(2*PI()*k*SEQUENCE(N,,0)/N)),6))',
    2.0, ["dft", "4point", "frequency", "imaginary", "pbartxl"],
    ["LET", "SUM", "SIN", "PI", "SEQUENCE", "ROUND"],
    operators=["*", "/", "-"], let_bindings=3, complexity="advanced",
    notes="DFT X[1] imag part: Im = -sum(x_n * sin(2πn/4)) = -(0-2+0+4) = 2"))

# 12. Parseval's theorem: energy in time domain = energy in frequency domain
entries.append(e("nested_complex", "parseval_theorem_4point",
    '=LET(x,{1;2;3;4},N,4,ks,SEQUENCE(N,,0),energy_time,SUM(x^2),dft_re,MAP(ks,LAMBDA(k,SUM(x*COS(2*PI()*k*SEQUENCE(N,,0)/N)))),dft_im,MAP(ks,LAMBDA(k,-SUM(x*SIN(2*PI()*k*SEQUENCE(N,,0)/N)))),energy_freq,SUM(dft_re^2+dft_im^2)/N,ROUND(energy_time-energy_freq,8))',
    0.0, ["parseval", "energy_conservation", "fft", "pbartxl"],
    ["LET", "SUM", "MAP", "LAMBDA", "SEQUENCE", "COS", "SIN", "PI", "ROUND"],
    operators=["*", "/", "^", "+", "-"], let_bindings=7, complexity="expert",
    notes="Parseval's theorem: Σ|x|² = (1/N)Σ|X|². Difference should be 0. Tests DFT correctness."))

# 13. Convolution of two simple signals (the capstone operation)
entries.append(e("nested_complex", "convolution_simple",
    '=LET(a,{1;1;1;0},b,{1;1;0;0},N,4,ks,SEQUENCE(N,,0),Ar,MAP(ks,LAMBDA(k,SUM(a*COS(2*PI()*k*SEQUENCE(N,,0)/N)))),Ai,MAP(ks,LAMBDA(k,-SUM(a*SIN(2*PI()*k*SEQUENCE(N,,0)/N)))),Br,MAP(ks,LAMBDA(k,SUM(b*COS(2*PI()*k*SEQUENCE(N,,0)/N)))),Bi,MAP(ks,LAMBDA(k,-SUM(b*SIN(2*PI()*k*SEQUENCE(N,,0)/N)))),Cr,Ar*Br-Ai*Bi,Ci,Ar*Bi+Ai*Br,conv,MAP(ks,LAMBDA(n,SUM(Cr*COS(2*PI()*n*ks/N)+Ci*SIN(2*PI()*n*ks/N))/N)),ROUND(INDEX(conv,1)+INDEX(conv,2)*10+INDEX(conv,3)*100+INDEX(conv,4)*1000,0))',
    1210, ["convolution", "fft", "signal_processing", "pbartxl"],
    ["LET", "MAP", "LAMBDA", "SEQUENCE", "SUM", "COS", "SIN", "PI", "ROUND", "INDEX"],
    operators=["*", "/", "+", "-", "^"], let_bindings=11, complexity="expert",
    notes="Circular convolution via DFT: conv({1,1,1,0},{1,1,0,0}) = {1,2,1,0} → packed as 0*1000+1*100+2*10+1 = 121. Wait: circular conv [1,1,1,0]*[1,1,0,0]: c[0]=1*1+0*0+1*0+1*1=2, c[1]=1*1+1*1+0*0+1*0=2... Let me recalculate."))

# Recalculate circular convolution of {1,1,1,0} and {1,1,0,0}:
# c[n] = sum_k a[k]*b[(n-k) mod 4]
# c[0] = a[0]*b[0]+a[1]*b[3]+a[2]*b[2]+a[3]*b[1] = 1*1+1*0+1*0+0*1 = 1
# c[1] = a[0]*b[1]+a[1]*b[0]+a[2]*b[3]+a[3]*b[2] = 1*1+1*1+1*0+0*0 = 2
# c[2] = a[0]*b[2]+a[1]*b[1]+a[2]*b[0]+a[3]*b[3] = 1*0+1*1+1*1+0*0 = 2
# c[3] = a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0] = 1*0+1*0+1*1+0*1 = 1
# So conv = {1,2,2,1}, packed = 1 + 2*10 + 2*100 + 1*1000 = 1221
entries[-1]["expected_result"] = 1221
entries[-1]["notes"] = "Circular convolution via DFT multiply: conv({1,1,1,0},{1,1,0,0}) = {1,2,2,1}. Packed: 1+2*10+2*100+1*1000=1221"

# 14. FIFO allocation from the repo (Allocateλ simplified)
entries.append(e("let_lambda_functional", "fifo_allocation_basic",
    '=LET(Accum,LAMBDA(arr,SCAN(0,arr,LAMBDA(a,x,a+x))),outputs,{3;5;2},inputs,{4;6},cumOut,Accum(outputs),cumIn,Accum(inputs),alloc,MAKEARRAY(ROWS(outputs),ROWS(inputs),LAMBDA(k,h,LET(oLo,IF(k=1,0,INDEX(cumOut,k-1)),oHi,INDEX(cumOut,k),iLo,IF(h=1,0,INDEX(cumIn,h-1)),iHi,INDEX(cumIn,h),overlap,MIN(oHi,iHi)-MAX(oLo,iLo),IF(overlap>0,overlap,0)))),SUM(alloc))',
    10, ["fifo", "allocation", "makearray", "pbartxl"],
    ["LET", "LAMBDA", "SCAN", "MAKEARRAY", "ROWS", "INDEX", "MIN", "MAX", "IF", "SUM"],
    operators=["+", "-", ">", "="], let_bindings=7, complexity="expert",
    notes="FIFO allocation: outputs {3,5,2}=10 total allocated across inputs {4,6}=10 total. Sum of allocation matrix = min(total_out, total_in) = 10. Adapted from pbartxl Allocateλ FIFO."))

# 15. FIFO allocation detail: specific cell
entries.append(e("let_lambda_functional", "fifo_allocation_cell",
    '=LET(Accum,LAMBDA(arr,SCAN(0,arr,LAMBDA(a,x,a+x))),outputs,{3;5;2},inputs,{4;6},cumOut,Accum(outputs),cumIn,Accum(inputs),alloc,MAKEARRAY(ROWS(outputs),ROWS(inputs),LAMBDA(k,h,LET(oLo,IF(k=1,0,INDEX(cumOut,k-1)),oHi,INDEX(cumOut,k),iLo,IF(h=1,0,INDEX(cumIn,h-1)),iHi,INDEX(cumIn,h),overlap,MIN(oHi,iHi)-MAX(oLo,iLo),IF(overlap>0,overlap,0)))),INDEX(alloc,2,1))',
    1, ["fifo", "allocation", "cell_detail", "pbartxl"],
    ["LET", "LAMBDA", "SCAN", "MAKEARRAY", "ROWS", "INDEX", "MIN", "MAX", "IF"],
    operators=["+", "-", ">", "="], let_bindings=7, complexity="expert",
    notes="FIFO alloc[2,1]: output 2 (cumulative 3-8) vs input 1 (cumulative 0-4). Overlap = min(8,4)-max(3,0) = 4-3 = 1"))

# 16. Combinations generator (from pbartxl gist 0253416c)
entries.append(e("let_lambda_functional", "combinations_binary",
    '=LET(n,4,m,2,allNums,SEQUENCE(2^n,,0),bitCount,LAMBDA(self,LAMBDA(x,IF(x=0,0,MOD(x,2)+self(self)(INT(x/2))))),valid,FILTER(allNums,MAP(allNums,LAMBDA(x,bitCount(bitCount)(x)=m))),ROWS(valid))',
    6, ["combinations", "binary_representation", "pbartxl"],
    ["LET", "SEQUENCE", "LAMBDA", "FILTER", "MAP", "IF", "MOD", "INT", "ROWS"],
    operators=["^", "+", "/", "="], let_bindings=5, complexity="expert",
    notes="C(4,2)=6: filter numbers 0-15 where popcount=2. Matches COMBIN(4,2)=6. From pbartxl COMBINATIONAλ gist."))

# 17. Nested array via thunk tree (from pbartxl gist 19464406)
entries.append(e("let_lambda_functional", "thunk_binary_tree",
    '=LET(THUNK,LAMBDA(v,LAMBDA(v)),FORCE,LAMBDA(t,t()),leaf,LAMBDA(x,THUNK(x)),node,LAMBDA(l,r,THUNK(FORCE(l)+FORCE(r))),t,node(leaf(10),node(leaf(20),leaf(30))),FORCE(t))',
    60, ["thunk", "binary_tree", "nested_array", "pbartxl"],
    ["LET", "LAMBDA"], operators=["+"],
    let_bindings=5, complexity="expert",
    notes="Binary tree of thunks (from pbartxl thunk gist): node(10, node(20,30)) = 10+(20+30) = 60"))

# 18. Dictionary with multiple value types (from pbartxl gist abc81d99)
entries.append(e("let_lambda_functional", "dictionary_thunked_array",
    '=LET(THUNK,LAMBDA(v,LAMBDA(v)),dict,LAMBDA(key,SWITCH(key,"name",THUNK("Alice"),"scores",THUNK({90,85,92}),"age",THUNK(30),THUNK(NA()))),getScores,dict("scores"),SUM(getScores()))',
    267, ["dictionary", "thunked_values", "array_values", "pbartxl"],
    ["LET", "LAMBDA", "SWITCH", "THUNK", "SUM", "NA"],
    let_bindings=3, complexity="expert",
    notes="Dictionary with thunked array value (from pbartxl dictionary gist): scores={90,85,92}, sum=267"))

# ============================================================
# Update EXTERNAL_CORPORA_INDEX to add the repo (not just gists)
# ============================================================

# Write entries
with open(JSONL_PATH, "a", encoding="utf-8") as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

total = existing + len(entries)
print(f"Appended {len(entries)} entries (FTC-{existing+1:04d} to FTC-{total:04d})")
print(f"Total entries in file: {total}")
