Attribute VB_Name = "VTC0019_FizzBuzz"
Option Explicit

Sub Main()
    Dim i As Long
    Dim output As String
    Dim fizzCount As Long
    Dim buzzCount As Long
    Dim fizzBuzzCount As Long
    Dim numberCount As Long

    Debug.Print "=== FizzBuzz (1 to 30) ==="
    Debug.Print ""

    fizzCount = 0
    buzzCount = 0
    fizzBuzzCount = 0
    numberCount = 0

    For i = 1 To 30
        If i Mod 15 = 0 Then
            output = "FizzBuzz"
            fizzBuzzCount = fizzBuzzCount + 1
        ElseIf i Mod 3 = 0 Then
            output = "Fizz"
            fizzCount = fizzCount + 1
        ElseIf i Mod 5 = 0 Then
            output = "Buzz"
            buzzCount = buzzCount + 1
        Else
            output = CStr(i)
            numberCount = numberCount + 1
        End If

        ' Right-align the number for neat output
        If i < 10 Then
            Debug.Print "   " & CStr(i) & ": " & output
        Else
            Debug.Print "  " & CStr(i) & ": " & output
        End If
    Next i

    Debug.Print ""
    Debug.Print "Summary:"
    Debug.Print "  FizzBuzz: " & CStr(fizzBuzzCount) & " times"
    Debug.Print "  Fizz:     " & CStr(fizzCount) & " times"
    Debug.Print "  Buzz:     " & CStr(buzzCount) & " times"
    Debug.Print "  Numbers:  " & CStr(numberCount) & " times"
    Debug.Print ""
    Debug.Print "FizzBuzz complete."
End Sub
