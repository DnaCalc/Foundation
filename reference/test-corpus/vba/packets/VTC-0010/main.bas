Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0010: Split and Join
    ' Parse delimited strings and reassemble them
    ' --------------------------------------------------

    Dim csvLine As String
    Dim fields() As String
    Dim i As Long

    ' --- Split: break a string into an array ---
    Debug.Print "=== Split a CSV line ==="

    csvLine = "Alice,Engineering,Senior,95000"
    Debug.Print "Input: " & csvLine

    fields = Split(csvLine, ",")
    Debug.Print "Number of fields: " & (UBound(fields) - LBound(fields) + 1)

    For i = LBound(fields) To UBound(fields)
        Debug.Print "  Field " & i & ": " & fields(i)
    Next i
    Debug.Print ""

    ' --- Join: reassemble with a different delimiter ---
    Debug.Print "=== Join with different delimiter ==="

    Dim tabSeparated As String
    tabSeparated = Join(fields, " | ")
    Debug.Print "Pipe-separated: " & tabSeparated
    Debug.Print ""

    ' --- Split with space delimiter ---
    Debug.Print "=== Split on spaces ==="

    Dim sentence As String
    Dim words() As String

    sentence = "The quick brown fox jumps over the lazy dog"
    Debug.Print "Sentence: " & sentence

    words = Split(sentence, " ")
    Debug.Print "Word count: " & (UBound(words) + 1)

    Debug.Print "First word: " & words(LBound(words))
    Debug.Print "Last word:  " & words(UBound(words))
    Debug.Print ""

    ' --- Practical: transform CSV data ---
    Debug.Print "=== Transform: CSV to formatted records ==="

    Dim dataLines(1 To 3) As String
    dataLines(1) = "Bob,Sales,Junior,52000"
    dataLines(2) = "Carol,Marketing,Lead,87000"
    dataLines(3) = "Dave,Engineering,Mid,78000"

    Dim record() As String
    Dim totalSalary As Long
    totalSalary = 0

    For i = 1 To 3
        record = Split(dataLines(i), ",")
        Debug.Print "  Name: " & record(0) & "  Dept: " & record(1) & "  Level: " & record(2) & "  Salary: $" & record(3)
        totalSalary = totalSalary + CLng(record(3))
    Next i

    Debug.Print "Total salary: $" & totalSalary
    Debug.Print ""

    ' --- Round-trip: Split then Join ---
    Debug.Print "=== Round-trip: Split then Join ==="

    Dim original As String
    Dim parts() As String
    Dim reassembled As String

    original = "red;green;blue;yellow"
    Debug.Print "Original:    " & original

    parts = Split(original, ";")
    reassembled = Join(parts, ";")
    Debug.Print "Reassembled: " & reassembled
    Debug.Print "Match: " & (original = reassembled)
    Debug.Print ""

    ' --- Change delimiter ---
    Debug.Print "=== Delimiter conversion ==="
    Debug.Print "Semicolons to commas:"
    Debug.Print "  Before: " & original
    Debug.Print "  After:  " & Join(Split(original, ";"), ", ")
End Sub
