Attribute VB_Name = "VTC0021_CaesarCipher"
Option Explicit

Sub Main()
    Dim original As String
    Dim encoded As String
    Dim decoded As String
    Dim shift As Long

    Debug.Print "=== Caesar Cipher ==="
    Debug.Print ""

    shift = 3
    Debug.Print "Shift value: " & CStr(shift)
    Debug.Print ""

    ' Test case 1
    original = "HELLO WORLD"
    encoded = CaesarEncode(original, shift)
    decoded = CaesarDecode(encoded, shift)
    Debug.Print "Test 1:"
    Debug.Print "  Original: " & original
    Debug.Print "  Encoded:  " & encoded
    Debug.Print "  Decoded:  " & decoded
    Debug.Print ""

    ' Test case 2 - mixed case
    original = "The Quick Brown Fox Jumps Over The Lazy Dog"
    encoded = CaesarEncode(original, shift)
    decoded = CaesarDecode(encoded, shift)
    Debug.Print "Test 2:"
    Debug.Print "  Original: " & original
    Debug.Print "  Encoded:  " & encoded
    Debug.Print "  Decoded:  " & decoded
    Debug.Print ""

    ' Test case 3 - with numbers and punctuation (left unchanged)
    original = "Meet me at 12:30 PM!"
    encoded = CaesarEncode(original, shift)
    decoded = CaesarDecode(encoded, shift)
    Debug.Print "Test 3:"
    Debug.Print "  Original: " & original
    Debug.Print "  Encoded:  " & encoded
    Debug.Print "  Decoded:  " & decoded
    Debug.Print ""

    ' Test case 4 - wrap around Z
    original = "XYZ xyz"
    encoded = CaesarEncode(original, shift)
    decoded = CaesarDecode(encoded, shift)
    Debug.Print "Test 4 (wrap-around):"
    Debug.Print "  Original: " & original
    Debug.Print "  Encoded:  " & encoded
    Debug.Print "  Decoded:  " & decoded
    Debug.Print ""

    Debug.Print "Caesar cipher complete."
End Sub

Function CaesarEncode(ByVal text As String, ByVal shift As Long) As String
    Dim result As String
    Dim i As Long
    Dim ch As String
    Dim code As Long

    result = ""
    For i = 1 To Len(text)
        ch = Mid$(text, i, 1)
        code = Asc(ch)

        If code >= 65 And code <= 90 Then
            ' Uppercase A-Z
            code = ((code - 65 + shift) Mod 26) + 65
            result = result & Chr$(code)
        ElseIf code >= 97 And code <= 122 Then
            ' Lowercase a-z
            code = ((code - 97 + shift) Mod 26) + 97
            result = result & Chr$(code)
        Else
            ' Non-alpha characters pass through
            result = result & ch
        End If
    Next i

    CaesarEncode = result
End Function

Function CaesarDecode(ByVal text As String, ByVal shift As Long) As String
    ' Decoding is just encoding with (26 - shift)
    CaesarDecode = CaesarEncode(text, 26 - shift)
End Function
