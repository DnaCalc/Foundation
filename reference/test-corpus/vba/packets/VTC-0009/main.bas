Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0009: Val/Str Type Conversion
    ' Convert between strings and numbers, verify round-trips
    ' --------------------------------------------------

    Dim numericValue As Double
    Dim textValue As String
    Dim integerValue As Long

    ' --- Val: string to number ---
    Debug.Print "=== Val (string to number) ==="

    Debug.Print "Val(""123"")      = " & Val("123")
    Debug.Print "Val(""  456  "")  = " & Val("  456  ")
    Debug.Print "Val(""3.14159"") = " & Val("3.14159")
    Debug.Print "Val(""-42"")     = " & Val("-42")
    Debug.Print "Val(""12abc"")   = " & Val("12abc")
    Debug.Print "Val(""abc"")     = " & Val("abc")
    Debug.Print "Val("""")        = " & Val("")
    Debug.Print ""

    ' --- Str: number to string ---
    Debug.Print "=== Str (number to string) ==="

    Debug.Print "Str(9)     = [" & Str(9) & "]"
    Debug.Print "Str(-9)    = [" & Str(-9) & "]"
    Debug.Print "Str(3.14)  = [" & Str(3.14) & "]"
    Debug.Print "Str(0)     = [" & Str(0) & "]"
    Debug.Print "(Note: Str adds a leading space for positive numbers)"
    Debug.Print ""

    ' --- Round-trip: Val(Str(x)) ---
    Debug.Print "=== Round-trip: Val(Str(x)) ==="

    integerValue = 9
    Debug.Print "Start:          " & integerValue
    Debug.Print "Str(9):         [" & Str(integerValue) & "]"
    Debug.Print "Val(Str(9)):    " & Val(Str(integerValue))
    Debug.Print "Match: " & (Val(Str(integerValue)) = integerValue)
    Debug.Print ""

    numericValue = 2718.28
    Debug.Print "Start:              " & numericValue
    Debug.Print "Str(2718.28):       [" & Str(numericValue) & "]"
    Debug.Print "Val(Str(2718.28)):  " & Val(Str(numericValue))
    Debug.Print "Match: " & (Val(Str(numericValue)) = numericValue)
    Debug.Print ""

    ' --- Round-trip: Str(Val(x)) ---
    Debug.Print "=== Round-trip: Str(Val(x)) ==="

    textValue = "750"
    Debug.Print "Start:               " & textValue
    Debug.Print "Val(""750""):          " & Val(textValue)
    Debug.Print "Str(Val(""750"")):     [" & Str(Val(textValue)) & "]"
    Debug.Print "Trim(Str(Val(x))):   [" & Trim(Str(Val(textValue))) & "]"
    Debug.Print ""

    ' --- CStr vs Str ---
    Debug.Print "=== CStr vs Str ==="
    Debug.Print "Str(42)  = [" & Str(42) & "] (leading space)"
    Debug.Print "CStr(42) = [" & CStr(42) & "] (no leading space)"
    Debug.Print ""

    ' --- Practical: parsing a price string ---
    Debug.Print "=== Practical: summing extracted numbers ==="

    Dim priceTexts(1 To 4) As String
    Dim totalPrice As Double

    priceTexts(1) = "19.99"
    priceTexts(2) = "5.50"
    priceTexts(3) = "123.00"
    priceTexts(4) = "7.95"

    totalPrice = 0
    Dim idx As Long
    For idx = 1 To 4
        Dim parsed As Double
        parsed = Val(priceTexts(idx))
        Debug.Print "  Val(""" & priceTexts(idx) & """) = " & parsed
        totalPrice = totalPrice + parsed
    Next idx

    Debug.Print "Total: " & totalPrice
    Debug.Print "As string: " & CStr(totalPrice)
End Sub
