Option Explicit

Sub Main()
    ' === Pipeline 1: Clean up a messy CSV line ===
    Debug.Print "=== Pipeline 1: Messy CSV Cleanup ==="

    Dim messy As String
    messy = "   apple ,  BANANA  , Cherry  ,  ,  date ,  "
    Debug.Print "Original:  [" & messy & "]"

    ' Step 1: Trim outer whitespace
    Dim trimmed As String
    trimmed = Trim(messy)
    Debug.Print "Trim:      [" & trimmed & "]"

    ' Step 2: Split on comma
    Dim parts() As String
    parts = Split(trimmed, ",")
    Debug.Print "Split:     " & (UBound(parts) - LBound(parts) + 1) & " parts"

    Dim i As Long
    For i = LBound(parts) To UBound(parts)
        Debug.Print "  parts(" & i & ") = [" & parts(i) & "]"
    Next i

    ' Step 3: Trim each part and convert to lowercase
    For i = LBound(parts) To UBound(parts)
        parts(i) = LCase(Trim(parts(i)))
    Next i

    Debug.Print "Trimmed+LCase:"
    For i = LBound(parts) To UBound(parts)
        Debug.Print "  parts(" & i & ") = [" & parts(i) & "]"
    Next i

    ' Step 4: Filter out empty strings
    Dim filtered() As String
    Dim count As Long
    count = 0
    For i = LBound(parts) To UBound(parts)
        If Len(parts(i)) > 0 Then
            count = count + 1
        End If
    Next i

    ReDim filtered(0 To count - 1)
    Dim j As Long
    j = 0
    For i = LBound(parts) To UBound(parts)
        If Len(parts(i)) > 0 Then
            filtered(j) = parts(i)
            j = j + 1
        End If
    Next i

    Debug.Print "Filtered:  " & count & " non-empty parts"
    For i = LBound(filtered) To UBound(filtered)
        Debug.Print "  filtered(" & i & ") = [" & filtered(i) & "]"
    Next i

    ' Step 5: Join back with consistent separator
    Dim result As String
    result = Join(filtered, ", ")
    Debug.Print "Joined:    [" & result & "]"

    ' === Pipeline 2: Replace and normalize whitespace ===
    Debug.Print ""
    Debug.Print "=== Pipeline 2: Whitespace Normalization ==="

    Dim raw As String
    raw = "  Hello    World   from    VBA  "
    Debug.Print "Original: [" & raw & "]"

    ' Step 1: Trim
    Dim s As String
    s = Trim(raw)
    Debug.Print "Trim:     [" & s & "]"

    ' Step 2: Collapse multiple spaces by repeated Replace
    Dim prev As String
    Do
        prev = s
        s = Replace(s, "  ", " ")
    Loop Until s = prev
    Debug.Print "Collapse: [" & s & "]"

    ' Step 3: Split on space
    Dim words() As String
    words = Split(s, " ")
    Debug.Print "Words:    " & (UBound(words) + 1) & " words"
    For i = LBound(words) To UBound(words)
        Debug.Print "  [" & words(i) & "]"
    Next i

    ' Step 4: Join with underscore
    result = Join(words, "_")
    Debug.Print "Joined:   [" & result & "]"

    ' === Pipeline 3: Search and replace chain ===
    Debug.Print ""
    Debug.Print "=== Pipeline 3: Search-Replace Chain ==="

    Dim template As String
    template = "Dear {NAME}, your order #{ORDER} ships on {DATE}."
    Debug.Print "Template:  " & template

    s = template
    s = Replace(s, "{NAME}", "Alice")
    Debug.Print "Replace 1: " & s
    s = Replace(s, "{ORDER}", "7042")
    Debug.Print "Replace 2: " & s
    s = Replace(s, "{DATE}", "2024-03-15")
    Debug.Print "Replace 3: " & s

    ' === Pipeline 4: LTrim / RTrim distinction ===
    Debug.Print ""
    Debug.Print "=== Pipeline 4: LTrim vs RTrim ==="

    Dim padded As String
    padded = "   center   "
    Debug.Print "Original:  [" & padded & "] (Len=" & Len(padded) & ")"
    Debug.Print "LTrim:     [" & LTrim(padded) & "] (Len=" & Len(LTrim(padded)) & ")"
    Debug.Print "RTrim:     [" & RTrim(padded) & "] (Len=" & Len(RTrim(padded)) & ")"
    Debug.Print "Trim:      [" & Trim(padded) & "] (Len=" & Len(Trim(padded)) & ")"

    ' === Pipeline 5: Split with different delimiters ===
    Debug.Print ""
    Debug.Print "=== Pipeline 5: Different Delimiters ==="

    Dim pathStr As String
    pathStr = "C:\Users\Admin\Documents\file.txt"
    Debug.Print "Path: " & pathStr

    Dim pathParts() As String
    pathParts = Split(pathStr, "\")
    Debug.Print "Split on '\': " & (UBound(pathParts) + 1) & " segments"
    For i = LBound(pathParts) To UBound(pathParts)
        Debug.Print "  [" & pathParts(i) & "]"
    Next i

    ' Rejoin with forward slash
    result = Join(pathParts, "/")
    Debug.Print "Unix-style: " & result

    Debug.Print ""
    Debug.Print "String pipeline complete."
End Sub
