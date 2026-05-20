Attribute VB_Name = "VTC0013_Fibonacci"
Option Explicit

Sub Main()
    Dim i As Long
    Dim a As Long
    Dim b As Long
    Dim temp As Long

    Debug.Print "=== Fibonacci Sequence (Iterative) ==="
    Debug.Print ""
    Debug.Print "Computing the first 20 Fibonacci numbers:"
    Debug.Print ""

    a = 0
    b = 1

    For i = 1 To 20
        Debug.Print "  F(" & CStr(i) & ") = " & CStr(a)
        temp = a + b
        a = b
        b = temp
    Next i

    Debug.Print ""

    ' Also print as a compact sequence
    Debug.Print "Compact sequence:"
    Dim line As String
    line = "  "
    a = 0
    b = 1
    For i = 1 To 20
        If i > 1 Then line = line & ", "
        line = line & CStr(a)
        temp = a + b
        a = b
        b = temp
    Next i
    Debug.Print line

    Debug.Print ""
    Debug.Print "Fibonacci computation complete."
End Sub
