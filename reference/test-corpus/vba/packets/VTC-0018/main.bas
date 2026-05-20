Attribute VB_Name = "VTC0018_PalindromeCheck"
Option Explicit

Sub Main()
    Debug.Print "=== Palindrome Check ==="
    Debug.Print ""
    Debug.Print "Checking strings (case-insensitive, letters only):"
    Debug.Print ""

    CheckAndPrint "racecar"
    CheckAndPrint "hello"
    CheckAndPrint "Madam"
    CheckAndPrint "A man a plan a canal Panama"
    CheckAndPrint "level"
    CheckAndPrint "OpenAI"
    CheckAndPrint "Was it a car or a cat I saw"
    CheckAndPrint "noon"
    CheckAndPrint "abcba"
    CheckAndPrint "abcdef"

    Debug.Print "Palindrome check complete."
End Sub

Sub CheckAndPrint(ByVal s As String)
    Dim result As Boolean

    result = IsPalindrome(s)

    If result Then
        Debug.Print "  """ & s & """ -> True (palindrome)"
    Else
        Debug.Print "  """ & s & """ -> False"
    End If
End Sub

Function IsPalindrome(ByVal s As String) As Boolean
    Dim cleaned As String
    Dim i As Long
    Dim ch As String
    Dim left As Long
    Dim right As Long

    ' Strip non-alpha characters and convert to lowercase
    cleaned = ""
    For i = 1 To Len(s)
        ch = Mid$(s, i, 1)
        If (ch >= "A" And ch <= "Z") Or (ch >= "a" And ch <= "z") Then
            cleaned = cleaned & LCase$(ch)
        End If
    Next i

    If Len(cleaned) <= 1 Then
        IsPalindrome = True
        Exit Function
    End If

    ' Compare from both ends
    left = 1
    right = Len(cleaned)
    Do While left < right
        If Mid$(cleaned, left, 1) <> Mid$(cleaned, right, 1) Then
            IsPalindrome = False
            Exit Function
        End If
        left = left + 1
        right = right - 1
    Loop

    IsPalindrome = True
End Function
