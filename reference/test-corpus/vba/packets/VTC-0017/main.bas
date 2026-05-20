Attribute VB_Name = "VTC0017_StringReversal"
Option Explicit

Sub Main()
    Debug.Print "=== String Reversal ==="
    Debug.Print ""

    ReverseAndPrint "Hello, World!"
    ReverseAndPrint "racecar"
    ReverseAndPrint "VBA Programming"
    ReverseAndPrint "12345"
    ReverseAndPrint "a"
    ReverseAndPrint ""
    ReverseAndPrint "Was it a car or a cat I saw"

    Debug.Print "String reversal complete."
End Sub

Sub ReverseAndPrint(ByVal s As String)
    Dim reversed As String

    reversed = ReverseString(s)

    If Len(s) = 0 Then
        Debug.Print "  Original: (empty string)"
        Debug.Print "  Reversed: (empty string)"
    Else
        Debug.Print "  Original: """ & s & """"
        Debug.Print "  Reversed: """ & reversed & """"
    End If
    Debug.Print ""
End Sub

Function ReverseString(ByVal s As String) As String
    Dim result As String
    Dim i As Long
    Dim length As Long

    length = Len(s)
    If length = 0 Then
        ReverseString = ""
        Exit Function
    End If

    result = ""
    For i = length To 1 Step -1
        result = result & Mid$(s, i, 1)
    Next i

    ReverseString = result
End Function
