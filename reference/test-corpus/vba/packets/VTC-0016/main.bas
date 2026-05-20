Attribute VB_Name = "VTC0016_GCD"
Option Explicit

Sub Main()
    Debug.Print "=== GCD (Euclidean Algorithm) ==="
    Debug.Print ""

    ComputeAndPrintGCD 48, 18
    ComputeAndPrintGCD 56, 98
    ComputeAndPrintGCD 270, 192
    ComputeAndPrintGCD 17, 13
    ComputeAndPrintGCD 100, 75
    ComputeAndPrintGCD 0, 45
    ComputeAndPrintGCD 1071, 462

    Debug.Print "GCD computation complete."
End Sub

Sub ComputeAndPrintGCD(ByVal a As Long, ByVal b As Long)
    Dim result As Long

    Debug.Print "GCD(" & CStr(a) & ", " & CStr(b) & "):"
    result = GCD(a, b)
    Debug.Print "  = " & CStr(result)
    Debug.Print ""
End Sub

Function GCD(ByVal a As Long, ByVal b As Long) As Long
    Dim temp As Long

    ' Ensure non-negative
    If a < 0 Then a = -a
    If b < 0 Then b = -b

    Do While b <> 0
        Debug.Print "    " & CStr(a) & " = " & CStr(a \ b) & " * " & CStr(b) & " + " & CStr(a Mod b)
        temp = b
        b = a Mod b
        a = temp
    Loop

    GCD = a
End Function
