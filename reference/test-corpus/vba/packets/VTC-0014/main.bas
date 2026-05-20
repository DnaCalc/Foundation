Attribute VB_Name = "VTC0014_Factorial"
Option Explicit

Sub Main()
    Dim i As Long

    Debug.Print "=== Factorial (Recursive) ==="
    Debug.Print ""
    Debug.Print "Computing factorials of 0 through 12:"
    Debug.Print ""

    For i = 0 To 12
        Debug.Print "  " & CStr(i) & "! = " & CStr(Factorial(i))
    Next i

    Debug.Print ""
    Debug.Print "Note: 12! = 479001600 is near the Long upper limit (2147483647)."
    Debug.Print "Factorial computation complete."
End Sub

Function Factorial(ByVal n As Long) As Long
    If n <= 1 Then
        Factorial = 1
    Else
        Factorial = n * Factorial(n - 1)
    End If
End Function
