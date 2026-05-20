Option Explicit

Sub Main()
    Dim numVal As Double
    Dim dateVal As Date
    Dim strVal As String

    ' === Number Formatting ===
    Debug.Print "=== Number Formatting ==="

    numVal = 1234567.891
    Debug.Print "Value: " & numVal
    Debug.Print "  #,##0.00       -> " & Format(numVal, "#,##0.00")
    Debug.Print "  #,##0          -> " & Format(numVal, "#,##0")
    Debug.Print "  0.00           -> " & Format(numVal, "0.00")
    Debug.Print "  0.0000         -> " & Format(numVal, "0.0000")
    Debug.Print "  $#,##0.00      -> " & Format(numVal, "$#,##0.00")
    Debug.Print "  0.00E+00       -> " & Format(numVal, "0.00E+00")

    numVal = 0.8675
    Debug.Print ""
    Debug.Print "Value: " & numVal
    Debug.Print "  0.00%          -> " & Format(numVal, "0.00%")
    Debug.Print "  Percent        -> " & Format(numVal, "Percent")
    Debug.Print "  0.0            -> " & Format(numVal, "0.0")

    ' Leading/trailing zeros
    numVal = 42
    Debug.Print ""
    Debug.Print "Value: " & numVal
    Debug.Print "  00000          -> " & Format(numVal, "00000")
    Debug.Print "  #####          -> " & Format(numVal, "#####")

    ' Negative number formatting
    numVal = -9876.5
    Debug.Print ""
    Debug.Print "Value: " & numVal
    Debug.Print "  #,##0.00       -> " & Format(numVal, "#,##0.00")
    Debug.Print "  #,##0.00;(#,##0.00) -> " & Format(numVal, "#,##0.00;(#,##0.00)")

    ' Zero value
    numVal = 0
    Debug.Print ""
    Debug.Print "Value: " & numVal
    Debug.Print "  #,##0.00       -> " & Format(numVal, "#,##0.00")
    Debug.Print "  #              -> [" & Format(numVal, "#") & "]"

    ' === Date Formatting ===
    Debug.Print ""
    Debug.Print "=== Date Formatting ==="

    dateVal = DateSerial(2024, 11, 5) + TimeSerial(14, 30, 45)
    Debug.Print "Value: " & CStr(dateVal)
    Debug.Print "  yyyy-mm-dd     -> " & Format(dateVal, "yyyy-mm-dd")
    Debug.Print "  dd/mm/yyyy     -> " & Format(dateVal, "dd/mm/yyyy")
    Debug.Print "  mmm dd, yyyy   -> " & Format(dateVal, "mmm dd, yyyy")
    Debug.Print "  mmmm dd, yyyy  -> " & Format(dateVal, "mmmm dd, yyyy")
    Debug.Print "  ddd            -> " & Format(dateVal, "ddd")
    Debug.Print "  dddd           -> " & Format(dateVal, "dddd")
    Debug.Print "  hh:nn:ss       -> " & Format(dateVal, "hh:nn:ss")
    Debug.Print "  hh:nn AM/PM    -> " & Format(dateVal, "hh:nn AM/PM")
    Debug.Print "  yyyy-mm-dd hh:nn:ss -> " & Format(dateVal, "yyyy-mm-dd hh:nn:ss")

    ' Named date formats
    Debug.Print ""
    Debug.Print "  General Date   -> " & Format(dateVal, "General Date")
    Debug.Print "  Long Date      -> " & Format(dateVal, "Long Date")
    Debug.Print "  Short Date     -> " & Format(dateVal, "Short Date")
    Debug.Print "  Long Time      -> " & Format(dateVal, "Long Time")
    Debug.Print "  Short Time     -> " & Format(dateVal, "Short Time")

    ' === String Formatting ===
    Debug.Print ""
    Debug.Print "=== String Formatting ==="

    strVal = "hello"
    Debug.Print "Value: """ & strVal & """"
    Debug.Print "  >              -> " & Format(strVal, ">")
    Debug.Print "  <              -> " & Format(strVal, "<")

    strVal = "Hello World"
    Debug.Print ""
    Debug.Print "Value: """ & strVal & """"
    Debug.Print "  >              -> " & Format(strVal, ">")
    Debug.Print "  <              -> " & Format(strVal, "<")

    ' === Named Number Formats ===
    Debug.Print ""
    Debug.Print "=== Named Number Formats ==="

    numVal = 5432.1
    Debug.Print "Value: " & numVal
    Debug.Print "  General Number -> " & Format(numVal, "General Number")
    Debug.Print "  Currency       -> " & Format(numVal, "Currency")
    Debug.Print "  Fixed          -> " & Format(numVal, "Fixed")
    Debug.Print "  Standard       -> " & Format(numVal, "Standard")
    Debug.Print "  Scientific     -> " & Format(numVal, "Scientific")
    Debug.Print "  Yes/No (1)     -> " & Format(1, "Yes/No")
    Debug.Print "  Yes/No (0)     -> " & Format(0, "Yes/No")
    Debug.Print "  True/False (1) -> " & Format(1, "True/False")
    Debug.Print "  On/Off (0)     -> " & Format(0, "On/Off")
End Sub
