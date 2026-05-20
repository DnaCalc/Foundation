Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0004: String Building
    ' Construct strings with Space, String$, Chr, and Asc
    ' --------------------------------------------------

    Dim padding As String
    Dim separator As String
    Dim letter As String
    Dim asciiCode As Long

    ' --- Space: generate whitespace ---
    Debug.Print "=== Space function ==="

    padding = Space(4)
    Debug.Print "No indent"
    Debug.Print padding & "Indented 4 spaces"
    Debug.Print padding & padding & "Indented 8 spaces"
    Debug.Print "Length of Space(4): " & Len(Space(4))
    Debug.Print "Length of Space(10): " & Len(Space(10))
    Debug.Print ""

    ' --- String$: repeat a character ---
    Debug.Print "=== String$ function ==="

    separator = String$(40, "-")
    Debug.Print separator
    Debug.Print "  Report Title"
    Debug.Print separator

    Debug.Print ""
    Debug.Print "String$(3, 65) = " & String$(3, 65)
    Debug.Print "(65 is ASCII for 'A', so we get three A's)"
    Debug.Print "String$(5, ""*"") = " & String$(5, "*")
    Debug.Print "String$(3, ""XY"") = " & String$(3, "XY")
    Debug.Print "(String$ uses only the first character)"
    Debug.Print ""

    ' --- Chr / Chr$: ASCII code to character ---
    Debug.Print "=== Chr function ==="

    Debug.Print "Chr$(65) = " & Chr$(65) & " (uppercase A)"
    Debug.Print "Chr$(66) = " & Chr$(66) & " (uppercase B)"
    Debug.Print "Chr$(97) = " & Chr$(97) & " (lowercase a)"
    Debug.Print "Chr$(48) = " & Chr$(48) & " (digit zero)"
    Debug.Print "Chr$(32) = [" & Chr$(32) & "] (space)"
    Debug.Print ""

    ' Build the alphabet using Chr
    Debug.Print "=== Building the alphabet with Chr ==="
    Dim alphabet As String
    Dim i As Long
    alphabet = ""
    For i = 65 To 90
        alphabet = alphabet & Chr$(i)
    Next i
    Debug.Print "Alphabet: " & alphabet
    Debug.Print ""

    ' --- Asc: character to ASCII code ---
    Debug.Print "=== Asc function ==="

    letter = "A"
    asciiCode = Asc(letter)
    Debug.Print "Asc(""A"") = " & asciiCode

    Debug.Print "Asc(""Z"") = " & Asc("Z")
    Debug.Print "Asc(""a"") = " & Asc("a")
    Debug.Print "Asc(""0"") = " & Asc("0")
    Debug.Print "Asc("" "") = " & Asc(" ")
    Debug.Print ""

    ' --- Round-trip: Chr(Asc(x)) == x ---
    Debug.Print "=== Round-trip verification ==="

    Dim testChar As String
    testChar = "M"
    Debug.Print "Original char: " & testChar
    Debug.Print "Asc(""M"") = " & Asc(testChar)
    Debug.Print "Chr$(Asc(""M"")) = " & Chr$(Asc(testChar))
    Debug.Print "Round-trip matches: " & (Chr$(Asc(testChar)) = testChar)

    Debug.Print ""
    Debug.Print "=== Simple bar chart using String$ ==="
    Debug.Print "Mon: " & String$(6, "#")  & " 6"
    Debug.Print "Tue: " & String$(9, "#")  & " 9"
    Debug.Print "Wed: " & String$(4, "#")  & " 4"
    Debug.Print "Thu: " & String$(11, "#") & " 11"
    Debug.Print "Fri: " & String$(8, "#")  & " 8"
End Sub
