Option Explicit

Sub Main()
    Dim vOriginal As Variant
    Dim iVal As Integer
    Dim lVal As Long
    Dim dVal As Double
    Dim sVal As String
    Dim bVal As Boolean
    Dim vFromVal As Double
    Dim sFromStr As String

    ' === Chain 1: String -> Double -> Long -> Integer -> Boolean -> String ===
    Debug.Print "=== Chain 1: String through numeric types to Boolean ==="

    vOriginal = "123.456"
    Debug.Print "Step 0: """ & vOriginal & """ (TypeName=" & TypeName(vOriginal) & ")"

    dVal = CDbl(vOriginal)
    Debug.Print "Step 1: CDbl -> " & dVal & " (TypeName=" & TypeName(dVal) & ")"

    lVal = CLng(dVal)
    Debug.Print "Step 2: CLng -> " & lVal & " (TypeName=" & TypeName(lVal) & ")"

    iVal = CInt(lVal)
    Debug.Print "Step 3: CInt -> " & iVal & " (TypeName=" & TypeName(iVal) & ")"

    bVal = CBool(iVal)
    Debug.Print "Step 4: CBool -> " & bVal & " (TypeName=" & TypeName(bVal) & ")"

    sVal = CStr(bVal)
    Debug.Print "Step 5: CStr -> """ & sVal & """ (TypeName=" & TypeName(sVal) & ")"

    ' === Chain 2: Numeric -> Str -> Val round-trip ===
    Debug.Print ""
    Debug.Print "=== Chain 2: Str() and Val() round-trip ==="

    dVal = 3.14159
    Debug.Print "Start:  " & dVal & " (TypeName=" & TypeName(dVal) & ")"

    sFromStr = Str(dVal)
    Debug.Print "Str():  """ & sFromStr & """ (TypeName=" & TypeName(sFromStr) & ", Len=" & Len(sFromStr) & ")"

    vFromVal = Val(sFromStr)
    Debug.Print "Val():  " & vFromVal & " (TypeName=" & TypeName(vFromVal) & ")"

    Debug.Print "Round-trip match: " & (dVal = vFromVal)

    ' === Chain 3: Boolean -> numeric conversions ===
    Debug.Print ""
    Debug.Print "=== Chain 3: Boolean -> numeric values ==="

    bVal = True
    Debug.Print "True as Boolean: " & bVal
    Debug.Print "  CInt(True):  " & CInt(True)
    Debug.Print "  CLng(True):  " & CLng(True)
    Debug.Print "  CDbl(True):  " & CDbl(True)
    Debug.Print "  CStr(True):  """ & CStr(True) & """"

    bVal = False
    Debug.Print "False as Boolean: " & bVal
    Debug.Print "  CInt(False): " & CInt(False)
    Debug.Print "  CLng(False): " & CLng(False)
    Debug.Print "  CDbl(False): " & CDbl(False)

    ' === Chain 4: Val() with various string inputs ===
    Debug.Print ""
    Debug.Print "=== Chain 4: Val() parsing behavior ==="

    Debug.Print "Val(""42 cats""):   " & Val("42 cats")
    Debug.Print "Val(""  -7.5""):    " & Val("  -7.5")
    Debug.Print "Val(""abc""):       " & Val("abc")
    Debug.Print "Val(""1.2e3""):     " & Val("1.2e3")
    Debug.Print "Val(""&HFF""):      " & Val("&HFF")
    Debug.Print "Val(""&O77""):      " & Val("&O77")

    ' === Chain 5: CBool edge cases ===
    Debug.Print ""
    Debug.Print "=== Chain 5: CBool() conversions ==="

    Debug.Print "CBool(0):    " & CBool(0)
    Debug.Print "CBool(1):    " & CBool(1)
    Debug.Print "CBool(-1):   " & CBool(-1)
    Debug.Print "CBool(42):   " & CBool(42)
    Debug.Print "CBool(0.5):  " & CBool(0.5)

    ' === Chain 6: CInt rounding (banker's rounding) ===
    Debug.Print ""
    Debug.Print "=== Chain 6: CInt() banker's rounding ==="

    Debug.Print "CInt(2.5):  " & CInt(2.5)
    Debug.Print "CInt(3.5):  " & CInt(3.5)
    Debug.Print "CInt(4.5):  " & CInt(4.5)
    Debug.Print "CInt(5.5):  " & CInt(5.5)
    Debug.Print "CInt(2.4):  " & CInt(2.4)
    Debug.Print "CInt(2.6):  " & CInt(2.6)
    Debug.Print "CInt(-1.5): " & CInt(-1.5)
    Debug.Print "CInt(-2.5): " & CInt(-2.5)

    ' === VarType checks ===
    Debug.Print ""
    Debug.Print "=== VarType Constants ==="

    Dim v As Variant
    v = 42
    Debug.Print "VarType(42):      " & VarType(v) & " (vbLong=3? " & (VarType(v) = 3) & ")"
    v = "hello"
    Debug.Print "VarType(""hello""): " & VarType(v) & " (vbString=8? " & (VarType(v) = 8) & ")"
    v = 3.14
    Debug.Print "VarType(3.14):    " & VarType(v) & " (vbDouble=5? " & (VarType(v) = 5) & ")"
    v = True
    Debug.Print "VarType(True):    " & VarType(v) & " (vbBoolean=11? " & (VarType(v) = 11) & ")"
End Sub
