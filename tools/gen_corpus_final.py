#!/usr/bin/env python3
"""Final batch to bring corpus to ~1000 entries."""
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
      complexity="basic", expected_type="number", expected_error=None,
      result_is_array=False, array_dimensions=None, let_bindings=0,
      deterministic=True, requires_locale=False, requires_date_system=None,
      operators=None, notes=None):
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
        "deterministic": deterministic, "requires_locale": requires_locale,
        "requires_date_system": requires_date_system,
        "conformance_req_ids": [], "evidence_ids": [],
        "source_ids": [], "provenance": "authored",
        "provenance_detail": "AI-generated edge case for DnaCalc test corpus",
        "notes": notes
    }

entries = []

# ============================================================
# Church-encoded booleans
# ============================================================
entries.append(e("let_lambda_functional", "church_boolean_and",
    '=LET(TRUE_,LAMBDA(a,LAMBDA(b,a)),FALSE_,LAMBDA(a,LAMBDA(b,b)),AND_,LAMBDA(p,LAMBDA(q,p(q)(p))),toBool,LAMBDA(b,b(TRUE)(FALSE)),toBool(AND_(TRUE_)(FALSE_)))',
    False, ["church_encoding", "boolean", "and"], ["LET", "LAMBDA"],
    complexity="expert", expected_type="boolean", let_bindings=4,
    notes="Church booleans: TRUE=lam a b.a, FALSE=lam a b.b, AND=lam p q.p q p"))

entries.append(e("let_lambda_functional", "church_boolean_or",
    '=LET(TRUE_,LAMBDA(a,LAMBDA(b,a)),FALSE_,LAMBDA(a,LAMBDA(b,b)),OR_,LAMBDA(p,LAMBDA(q,p(p)(q))),toBool,LAMBDA(b,b(TRUE)(FALSE)),toBool(OR_(FALSE_)(TRUE_)))',
    True, ["church_encoding", "boolean", "or"], ["LET", "LAMBDA"],
    complexity="expert", expected_type="boolean", let_bindings=4,
    notes="Church OR: lam p q. p p q"))

entries.append(e("let_lambda_functional", "church_boolean_not",
    '=LET(TRUE_,LAMBDA(a,LAMBDA(b,a)),FALSE_,LAMBDA(a,LAMBDA(b,b)),NOT_,LAMBDA(p,p(FALSE_)(TRUE_)),toBool,LAMBDA(b,b(TRUE)(FALSE)),toBool(NOT_(TRUE_)))',
    False, ["church_encoding", "boolean", "not"], ["LET", "LAMBDA"],
    complexity="expert", expected_type="boolean", let_bindings=4,
    notes="Church NOT: lam p. p FALSE TRUE"))

entries.append(e("let_lambda_functional", "church_pair_fst",
    '=LET(PAIR,LAMBDA(a,LAMBDA(b,LAMBDA(f,f(a)(b)))),FST,LAMBDA(p,p(LAMBDA(a,LAMBDA(b,a)))),SND,LAMBDA(p,p(LAMBDA(a,LAMBDA(b,b)))),myPair,PAIR(42)(99),FST(myPair))',
    42, ["church_encoding", "pair", "projection"], ["LET", "LAMBDA"],
    complexity="expert", let_bindings=4,
    notes="Church pair: PAIR a b = lam f. f a b; FST extracts first"))

entries.append(e("let_lambda_functional", "church_pair_snd",
    '=LET(PAIR,LAMBDA(a,LAMBDA(b,LAMBDA(f,f(a)(b)))),FST,LAMBDA(p,p(LAMBDA(a,LAMBDA(b,a)))),SND,LAMBDA(p,p(LAMBDA(a,LAMBDA(b,b)))),myPair,PAIR(42)(99),SND(myPair))',
    99, ["church_encoding", "pair", "projection"], ["LET", "LAMBDA"],
    complexity="expert", let_bindings=4,
    notes="Church pair: SND extracts second element"))

# ============================================================
# More creative nested complex
# ============================================================
entries.append(e("nested_complex", "recursive_string_repeat",
    '=LET(rep,LAMBDA(self,LAMBDA(s,LAMBDA(n,IF(n<=0,"",IF(n=1,s,s&self(self)(s)(n-1)))))),rep(rep)("ab")(5))',
    "ababababab", ["recursion", "string", "repeat"], ["LET", "LAMBDA", "IF"],
    operators=["&", "-", "<=", "="], expected_type="string", let_bindings=1, complexity="advanced",
    notes='Recursive string repetition: "ab" * 5'))

entries.append(e("nested_complex", "recursive_count_char",
    '=LET(cnt,LAMBDA(self,LAMBDA(s,LAMBDA(ch,IF(LEN(s)=0,0,(LEFT(s,1)=ch)+self(self)(MID(s,2,LEN(s)-1))(ch))))),cnt(cnt)("mississippi")("s"))',
    4, ["recursion", "char_count", "string"], ["LET", "LAMBDA", "IF", "LEN", "LEFT", "MID"],
    operators=["+", "-", "="], let_bindings=1, complexity="advanced",
    notes='Count occurrences of "s" in "mississippi": 4'))

entries.append(e("nested_complex", "matrix_identity_check",
    '=LET(I,MAKEARRAY(3,3,LAMBDA(r,c,IF(r=c,1,0))),SUM(I))',
    3, ["matrix", "identity", "makearray"], ["LET", "MAKEARRAY", "LAMBDA", "IF", "SUM"],
    operators=["="], let_bindings=1, complexity="intermediate",
    notes="3x3 identity matrix: diagonal elements sum to 3"))

entries.append(e("nested_complex", "catalan_number",
    '=LET(n,5,FACT(2*n)/(FACT(n+1)*FACT(n)))',
    42, ["catalan", "combinatorics"], ["LET", "FACT"],
    operators=["*", "/", "+"], let_bindings=1, complexity="intermediate",
    notes="5th Catalan number: C(5) = 10!/(6!*5!) = 42"))

entries.append(e("nested_complex", "harmonic_number_100",
    '=ROUND(SUM(1/SEQUENCE(100)),6)',
    5.187378, ["harmonic", "series", "sum"], ["SUM", "SEQUENCE", "ROUND"],
    operators=["/"], complexity="intermediate",
    notes="H(100) = sum of 1/k for k=1..100"))

entries.append(e("nested_complex", "euler_totient_12",
    '=LET(n,12,SUMPRODUCT(--(GCD(SEQUENCE(n),n)=1)))',
    4, ["euler_totient", "number_theory"], ["LET", "SUMPRODUCT", "GCD", "SEQUENCE"],
    operators=["=", "--"], let_bindings=1, complexity="advanced",
    notes="Euler totient phi(12): {1,5,7,11} coprime to 12 = 4"))

entries.append(e("nested_complex", "dot_product_basic",
    '=SUMPRODUCT({1,2,3},{4,5,6})',
    32, ["dot_product", "vector"], ["SUMPRODUCT"],
    notes="Dot product: 1*4+2*5+3*6=32"))

entries.append(e("nested_complex", "cross_product_magnitude",
    '=LET(a,{1,2,3},b,{4,5,6},cx,INDEX(a,2)*INDEX(b,3)-INDEX(a,3)*INDEX(b,2),cy,INDEX(a,3)*INDEX(b,1)-INDEX(a,1)*INDEX(b,3),cz,INDEX(a,1)*INDEX(b,2)-INDEX(a,2)*INDEX(b,1),ROUND(SQRT(cx^2+cy^2+cz^2),6))',
    7.071068, ["cross_product", "vector", "magnitude"], ["LET", "INDEX", "SQRT", "ROUND"],
    operators=["*", "-", "^", "+"], let_bindings=5, complexity="advanced",
    notes="|a x b| where a={1,2,3}, b={4,5,6}: cross={-3,6,-3}, |cross|=sqrt(54)"))

entries.append(e("nested_complex", "combinatorial_sum_binomial",
    '=SUM(MAP(SEQUENCE(6,,0),LAMBDA(k,COMBIN(5,k))))',
    32, ["binomial_theorem", "combinatorics"], ["SUM", "MAP", "SEQUENCE", "LAMBDA", "COMBIN"],
    complexity="intermediate",
    notes="Sum of C(5,k) for k=0..5 = 2^5 = 32"))

entries.append(e("nested_complex", "stirling_approximation",
    '=LET(n,10,approx,SQRT(2*PI()*n)*(n/EXP(1))^n,exact,FACT(n),ROUND(exact/approx,4))',
    1.0084, ["stirling", "approximation", "factorial"], ["LET", "SQRT", "PI", "EXP", "FACT", "ROUND"],
    operators=["*", "/", "^"], let_bindings=3, complexity="advanced",
    notes="Stirling ratio for n=10: FACT(10)/stirling"))

entries.append(e("nested_complex", "taylor_sin_pi6",
    '=LET(x,PI()/6,approx,x-x^3/FACT(3)+x^5/FACT(5)-x^7/FACT(7)+x^9/FACT(9),ROUND(approx,10))',
    0.5, ["taylor_series", "sin", "approximation"], ["LET", "PI", "FACT", "ROUND"],
    operators=["-", "+", "^", "/"], let_bindings=2, complexity="advanced",
    notes="Taylor series for sin(pi/6): 5 terms gives excellent convergence to 0.5"))

entries.append(e("nested_complex", "ackermann_3_2",
    '=LET(ack,LAMBDA(self,LAMBDA(m,LAMBDA(n,IF(m=0,n+1,IF(n=0,self(self)(m-1)(1),self(self)(m-1)(self(self)(m)(n-1))))))),ack(ack)(3)(2))',
    29, ["ackermann", "recursion", "deep"], ["LET", "LAMBDA", "IF"],
    operators=["+", "-", "="], let_bindings=1, complexity="expert",
    notes="A(3,2)=29. Tests deep LAMBDA recursion limits."))

entries.append(e("nested_complex", "entropy_shannon",
    '=LET(probs,{0.5,0.25,0.125,0.125},H,-SUMPRODUCT(probs,LOG(probs,2)),ROUND(H,4))',
    1.75, ["entropy", "information_theory"], ["LET", "SUMPRODUCT", "LOG", "ROUND"],
    operators=["-"], let_bindings=2, complexity="advanced",
    notes="Shannon entropy: H = -sum(p*log2(p)) = 1.75 bits"))

entries.append(e("nested_complex", "cholesky_diagonal",
    '=LET(a11,4,a12,2,a22,5,L11,SQRT(a11),L21,a12/L11,L22,SQRT(a22-L21^2),ROUND(L11*L22,6))',
    4.0, ["cholesky", "matrix", "decomposition"], ["LET", "SQRT", "ROUND"],
    operators=["-", "/", "^", "*"], let_bindings=6, complexity="expert",
    notes="2x2 Cholesky: L11=2, L21=1, L22=2, diagonal product=4"))

# ============================================================
# More type coercion edge cases
# ============================================================
entries.append(e("type_coercion_edge", "array_comparison_sum",
    '=SUM(--(({1,2,3})=2))', 1,
    ["array_comparison", "boolean_sum"], ["SUM"],
    operators=["=", "--"],
    notes="Array comparison {1,2,3}=2 -> {F,T,F}, --converts, sum=1"))

entries.append(e("type_coercion_edge", "triple_true_addition",
    '=TRUE+TRUE+TRUE', 3,
    ["boolean", "triple_addition"], [],
    operators=["+"],
    notes="TRUE+TRUE+TRUE = 1+1+1 = 3"))

entries.append(e("type_coercion_edge", "date_is_number",
    '=ISNUMBER(DATE(2024,1,1))', True,
    ["date", "type_identity"], ["ISNUMBER", "DATE"],
    expected_type="boolean",
    notes="Dates are numbers (serials) in Excel"))

entries.append(e("type_coercion_edge", "negative_one_sqrt",
    '=(-1)^0.5', None,
    ["complex", "imaginary", "num_error"], [],
    operators=["^"], expected_type="error", expected_error="#NUM!",
    notes="Square root of -1 via ^: #NUM! (no complex support in standard formulas)"))

# ============================================================
# Dynamic array extras
# ============================================================
entries.append(e("dynamic_array", "lambda_filter_combined",
    '=SUM(FILTER(SEQUENCE(10),MAP(SEQUENCE(10),LAMBDA(x,AND(x>3,MOD(x,2)=1)))))',
    21, ["filter", "lambda", "combined"], ["SUM", "FILTER", "SEQUENCE", "MAP", "LAMBDA", "AND", "MOD"],
    operators=[">", "="], complexity="advanced",
    notes="Filter 1-10 where >3 AND odd: {5,7,9}, sum=21"))

# ============================================================
# Engineering extras
# ============================================================
entries.append(e("engineering", "complex_arithmetic",
    '=ROUND(IMABS(IMSUM(COMPLEX(3,4),COMPLEX(1,-2))),6)', 4.472136,
    ["complex", "imabs", "imsum"], ["ROUND", "IMABS", "IMSUM", "COMPLEX"],
    complexity="intermediate",
    notes="|(3+4i)+(1-2i)| = |4+2i| = sqrt(20)"))

entries.append(e("engineering", "bitwise_fullcycle",
    '=BITXOR(BITOR(170,85),255)', 0,
    ["bitwise", "xor", "or"], ["BITXOR", "BITOR"],
    notes="170|85=255, 255 XOR 255=0"))

# ============================================================
# More nested complex to hit 1000
# ============================================================
entries.append(e("nested_complex", "sum_squares_formula",
    '=LET(n,10,n*(n+1)*(2*n+1)/6)', 385,
    ["sum_of_squares", "formula", "gauss"], ["LET"],
    operators=["*", "+", "/"], let_bindings=1,
    notes="Sum of squares formula: n(n+1)(2n+1)/6 = 385"))

entries.append(e("nested_complex", "sum_cubes_formula",
    '=LET(n,10,(n*(n+1)/2)^2)', 3025,
    ["sum_of_cubes", "formula"], ["LET"],
    operators=["*", "+", "/", "^"], let_bindings=1,
    notes="Sum of cubes = (n(n+1)/2)^2 = 55^2 = 3025"))

entries.append(e("nested_complex", "birthday_paradox",
    '=LET(n,23,prob,REDUCE(1,SEQUENCE(n-1,,1),LAMBDA(p,k,(365-k)/365*p)),ROUND(1-prob,4))',
    0.5073, ["birthday_paradox", "probability"], ["LET", "REDUCE", "SEQUENCE", "LAMBDA", "ROUND"],
    operators=["-", "/", "*"], let_bindings=2, complexity="advanced",
    notes="Birthday paradox: P(collision) with 23 people"))

entries.append(e("nested_complex", "monty_hall_formula",
    '=LET(n,3,win_switch,2/n,win_stay,1/n,win_switch>win_stay)',
    True, ["monty_hall", "probability"], ["LET"],
    operators=["/", ">"], let_bindings=3, expected_type="boolean",
    notes="Monty Hall: switching wins 2/3 > staying 1/3"))

entries.append(e("let_lambda_functional", "omega_safe",
    '=IFERROR(LET(omega,LAMBDA(x,x(x)),1),"safe")',
    1, ["omega", "combinator"], ["IFERROR", "LET", "LAMBDA"],
    let_bindings=1, complexity="advanced",
    notes="Omega combinator defined but not called. LET returns 1."))

entries.append(e("let_lambda_functional", "fixed_point_sqrt2",
    '=LET(fix,LAMBDA(self,LAMBDA(f,LAMBDA(x,LAMBDA(n,IF(n=0,x,self(self)(f)(f(x))(n-1)))))),improve,LAMBDA(x,(x+2/x)/2),ROUND(fix(fix)(improve)(1.0)(50),10))',
    1.4142135624, ["fixed_point", "iteration", "sqrt"], ["LET", "LAMBDA", "IF", "ROUND"],
    operators=["+", "/", "-", "="], let_bindings=2, complexity="expert",
    notes="Generic fixed-point iterator for sqrt(2)"))

entries.append(e("let_lambda_functional", "functional_lens_set",
    '=LET(SET,LAMBDA(arr,LAMBDA(idx,LAMBDA(val,LET(r,SEQUENCE(COLUMNS(arr)),IF(r=idx,val,INDEX(arr,r)))))),data,{10,20,30,40,50},modified,SET(data)(3)(99),SUM(modified))',
    219, ["lens", "get_set", "functional_update"], ["LET", "LAMBDA", "INDEX", "SEQUENCE", "COLUMNS", "IF", "SUM"],
    operators=["="], let_bindings=3, complexity="expert",
    notes="Functional lens SET: replace index 3 (30->99): 10+20+99+40+50=219"))

entries.append(e("let_lambda_functional", "tail_recursive_sum",
    '=LET(bounce,LAMBDA(self,LAMBDA(n,LAMBDA(acc,IF(n=0,acc,self(self)(n-1)(acc+n))))),bounce(bounce)(100)(0))',
    5050, ["trampoline", "tail_recursion", "sum"], ["LET", "LAMBDA", "IF"],
    operators=["-", "+", "="], let_bindings=1, complexity="advanced",
    notes="Tail-recursive sum 1..100: 5050"))

entries.append(e("nested_complex", "sigmoid_at_zero",
    '=LET(sigmoid,LAMBDA(x,1/(1+EXP(-x))),ROUND(sigmoid(0),1))',
    0.5, ["sigmoid", "activation"], ["LET", "LAMBDA", "EXP", "ROUND"],
    operators=["/", "+", "-"], let_bindings=1, complexity="intermediate",
    notes="Sigmoid(0) = 1/(1+e^0) = 0.5"))

entries.append(e("nested_complex", "softmax_max_element",
    '=LET(x,{1,2,3},ex,EXP(x),sm,ex/SUM(ex),ROUND(INDEX(sm,3),6))',
    0.665241, ["softmax", "probability"], ["LET", "EXP", "SUM", "ROUND", "INDEX"],
    operators=["/"], let_bindings=3, complexity="advanced",
    notes="Softmax of {1,2,3}: element 3 gets ~66.5%"))

entries.append(e("nested_complex", "mandelbrot_point",
    '=LET(cr,-0.5,ci,0.5,iter,LAMBDA(self,LAMBDA(zr,LAMBDA(zi,LAMBDA(n,IF(OR(n>=20,zr*zr+zi*zi>4),n,self(self)(zr*zr-zi*zi+cr)(2*zr*zi+ci)(n+1)))))),iter(iter)(0)(0)(0))',
    5, ["mandelbrot", "complex_iteration", "fractal"],
    ["LET", "LAMBDA", "IF", "OR"], operators=["*", "-", "+", ">", ">="],
    let_bindings=3, complexity="expert",
    notes="Single-point Mandelbrot: c=-0.5+0.5i escapes at iteration 5"))

entries.append(e("nested_complex", "deep_nesting_16_if",
    '=IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,IF(1,42,0),0),0),0),0),0),0),0),0),0),0),0),0),0),0),0)',
    42, ["deep_nesting", "if_chain", "16_levels"], ["IF"],
    complexity="intermediate",
    notes="16 levels of nested IF"))

entries.append(e("nested_complex", "bracket_depth_16",
    '=((((((((((((((((1+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)+1)',
    16, ["bracket_depth", "stress_test"], [],
    operators=["+"],
    notes="16 levels of nested parentheses"))

entries.append(e("nested_complex", "long_let_chain_20",
    '=LET(a,1,b,a+a,c,b+b,d,c+c,e,d+d,f,e+e,g,f+f,h,g+g,i,h+h,j,i+i,k,j+j,l,k+k,m,l+l,n,m+m,o,n+n,p,o+o,q,p+p,r,q+q,s,r+r,t,s+s,t)',
    1048576, ["long_formula", "let_chain", "doubling"], ["LET"],
    operators=["+"], let_bindings=20, complexity="advanced",
    notes="20-deep LET chain, each doubling: 2^20 = 1048576"))

entries.append(e("nested_complex", "roman_numeral_stress",
    '=LEN(ROMAN(3999))',
    15, ["roman", "max_value"], ["LEN", "ROMAN"],
    notes="ROMAN(3999)=MMMCMXCIX (15 chars) — max valid input"))

entries.append(e("nested_complex", "isbn_check_digit",
    '=LET(isbn,"013468599",digits,MAP(MID(isbn,SEQUENCE(9),1),LAMBDA(d,VALUE(d))),weights,SEQUENCE(9,,10,-1),chk,11-MOD(SUMPRODUCT(digits,weights),11),IF(chk=10,"X",TEXT(chk,"0")))',
    "2", ["isbn", "checksum", "validation"],
    ["LET", "MAP", "MID", "SEQUENCE", "LAMBDA", "VALUE", "SUMPRODUCT", "MOD", "IF", "TEXT"],
    operators=["-"], let_bindings=4, complexity="advanced", expected_type="string",
    notes="ISBN-10 check digit calculation"))

entries.append(e("nested_complex", "base_convert_hex",
    '=LET(n,255,hexChars,"0123456789ABCDEF",conv,LAMBDA(self,LAMBDA(val,IF(val<16,MID(hexChars,val+1,1),self(self)(INT(val/16))&MID(hexChars,MOD(val,16)+1,1)))),conv(conv)(n))',
    "FF", ["base_conversion", "hexadecimal", "recursion"],
    ["LET", "LAMBDA", "IF", "MID", "INT", "MOD"], operators=["&", "/", "+", "<"],
    let_bindings=3, complexity="expert", expected_type="string",
    notes="Recursive decimal to hex: 255 = FF"))

entries.append(e("nested_complex", "golden_ratio_cf",
    '=LET(step,LAMBDA(self,LAMBDA(n,IF(n=0,1,1+1/self(self)(n-1)))),ROUND(step(step)(20),10))',
    1.6180339887, ["golden_ratio", "continued_fraction"], ["LET", "LAMBDA", "IF", "ROUND"],
    operators=["+", "/", "-", "="], let_bindings=1, complexity="advanced",
    notes="Golden ratio via continued fraction: 1+1/(1+1/(1+...))"))

entries.append(e("nested_complex", "perfect_number_28",
    '=LET(n,28,SUM(FILTER(SEQUENCE(n-1),MOD(n,SEQUENCE(n-1))=0)))',
    28, ["perfect_number", "divisors"], ["LET", "SUM", "FILTER", "SEQUENCE", "MOD"],
    operators=["=", "-"], let_bindings=1, complexity="intermediate",
    notes="Sum of proper divisors of 28 = 28 (perfect number!)"))

entries.append(e("nested_complex", "set_intersection",
    '=SUM(FILTER({1,2,3,4,5},ISNUMBER(XMATCH({1,2,3,4,5},{2,4,6,8}))))',
    6, ["set_intersection", "filter_xmatch"], ["SUM", "FILTER", "ISNUMBER", "XMATCH"],
    complexity="intermediate",
    notes="{1,2,3,4,5} intersect {2,4,6,8} = {2,4}, sum=6"))

entries.append(e("nested_complex", "set_difference",
    '=SUM(FILTER({1,2,3,4,5},ISNA(XMATCH({1,2,3,4,5},{2,4,6,8}))))',
    9, ["set_difference", "filter_xmatch"], ["SUM", "FILTER", "ISNA", "XMATCH"],
    complexity="intermediate",
    notes="{1,2,3,4,5} minus {2,4,6,8} = {1,3,5}, sum=9"))

entries.append(e("nested_complex", "fibonacci_binet",
    '=LET(n,10,phi,(1+SQRT(5))/2,psi,(1-SQRT(5))/2,ROUND((phi^n-psi^n)/SQRT(5),0))',
    55, ["fibonacci", "binet", "closed_form"], ["LET", "SQRT", "ROUND"],
    operators=["+", "-", "/", "^"], let_bindings=3, complexity="intermediate",
    notes="Binet's formula: F(10) = 55"))

entries.append(e("nested_complex", "unique_permutations_mississippi",
    '=LET(word,"MISSISSIPPI",chars,MID(word,SEQUENCE(LEN(word)),1),uChars,UNIQUE(chars),counts,MAP(uChars,LAMBDA(c,SUM(--(chars=c)))),FACT(LEN(word))/PRODUCT(MAP(counts,LAMBDA(n,FACT(n)))))',
    34650, ["permutation", "multinomial"], ["LET", "MID", "SEQUENCE", "LEN", "UNIQUE", "MAP", "LAMBDA", "SUM", "FACT", "PRODUCT"],
    operators=["=", "/", "--"], let_bindings=4, complexity="expert",
    notes="Unique permutations of MISSISSIPPI: 11!/(1!*4!*4!*2!) = 34650"))

# Write all
with open(JSONL_PATH, "a", encoding="utf-8") as f:
    for entry in entries:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

total = existing + len(entries)
print(f"Appended {len(entries)} entries (FTC-{existing+1:04d} to FTC-{total:04d})")
print(f"Total entries in file: {total}")
