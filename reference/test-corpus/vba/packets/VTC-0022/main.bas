Attribute VB_Name = "VTC0022_Calculator"
Option Explicit

Sub Main()
    Debug.Print "=== Calculator (Select Case) ==="
    Debug.Print ""

    ' Demonstrate various arithmetic operations
    Calculate 42, "+", 18
    Calculate 100, "-", 37
    Calculate 7, "*", 8
    Calculate 144, "/", 12
    Calculate 17, "MOD", 5
    Calculate 2, "^", 10
    Calculate 99, "+", 1
    Calculate 50, "*", 0
    Calculate 10, "/", 3
    Calculate 256, "/", 0
    Calculate 15, "&", 3   ' Invalid operator test

    Debug.Print "Calculator complete."
End Sub

Sub Calculate(ByVal a As Double, ByVal op As String, ByVal b As Double)
    Dim result As Double
    Dim resultStr As String
    Dim valid As Boolean

    valid = True

    Select Case UCase$(op)
        Case "+"
            result = a + b
        Case "-"
            result = a - b
        Case "*"
            result = a * b
        Case "/"
            If b = 0 Then
                resultStr = "Error: Division by zero"
                valid = False
            Else
                result = a / b
            End If
        Case "MOD"
            If b = 0 Then
                resultStr = "Error: Division by zero"
                valid = False
            Else
                result = CLng(a) Mod CLng(b)
            End If
        Case "^"
            result = a ^ b
        Case Else
            resultStr = "Error: Unknown operator '" & op & "'"
            valid = False
    End Select

    If valid Then
        ' Format nicely: show integer result if whole number, otherwise 4 decimal places
        If result = Int(result) And Abs(result) < 1000000000# Then
            resultStr = CStr(CLng(result))
        Else
            resultStr = Format(result, "0.####")
        End If
    End If

    ' Format the expression
    Dim expr As String
    If a = Int(a) Then
        expr = CStr(CLng(a))
    Else
        expr = CStr(a)
    End If
    expr = expr & " " & op & " "
    If b = Int(b) Then
        expr = expr & CStr(CLng(b))
    Else
        expr = expr & CStr(b)
    End If

    Debug.Print "  " & expr & " = " & resultStr
End Sub
