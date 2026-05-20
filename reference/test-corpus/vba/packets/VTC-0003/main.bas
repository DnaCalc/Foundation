Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0003: InStr and Case Conversion
    ' Search within strings and convert case
    ' --------------------------------------------------

    Dim emailAddress As String
    Dim searchPosition As Long
    Dim logMessage As String

    ' --- InStr: find substring position ---
    Debug.Print "=== InStr (find substring) ==="

    emailAddress = "jane.doe@example.com"
    Debug.Print "Email: " & emailAddress

    searchPosition = InStr(emailAddress, "@")
    Debug.Print "Position of '@': " & searchPosition

    Dim userName As String
    Dim domainName As String
    userName = Left(emailAddress, searchPosition - 1)
    domainName = Mid(emailAddress, searchPosition + 1)
    Debug.Print "User name: " & userName
    Debug.Print "Domain:    " & domainName
    Debug.Print ""

    ' --- InStr: searching from a specific position ---
    Debug.Print "=== InStr with start position ==="

    Dim csvLine As String
    Dim firstComma As Long
    Dim secondComma As Long

    csvLine = "Alice,Engineering,Senior"
    Debug.Print "CSV line: " & csvLine

    firstComma = InStr(1, csvLine, ",")
    Debug.Print "First comma at position:  " & firstComma

    secondComma = InStr(firstComma + 1, csvLine, ",")
    Debug.Print "Second comma at position: " & secondComma

    Debug.Print "Field 1: " & Left(csvLine, firstComma - 1)
    Debug.Print "Field 2: " & Mid(csvLine, firstComma + 1, secondComma - firstComma - 1)
    Debug.Print "Field 3: " & Mid(csvLine, secondComma + 1)
    Debug.Print ""

    ' --- InStr: substring not found ---
    Debug.Print "=== InStr when not found ==="

    Dim haystack As String
    haystack = "The quick brown fox"
    Debug.Print "Text: " & haystack
    Debug.Print "Search for 'fox':  " & InStr(haystack, "fox")
    Debug.Print "Search for 'cat':  " & InStr(haystack, "cat")
    Debug.Print "Search for 'THE':  " & InStr(haystack, "THE")
    Debug.Print "(InStr is case-sensitive: 'THE' not found in 'The...')"
    Debug.Print ""

    ' --- LCase and UCase ---
    Debug.Print "=== Case Conversion ==="

    logMessage = "Warning: Disk Space Low"
    Debug.Print "Original:   " & logMessage
    Debug.Print "Lowercase:  " & LCase(logMessage)
    Debug.Print "Uppercase:  " & UCase(logMessage)
    Debug.Print ""

    ' --- Case-insensitive search pattern ---
    Debug.Print "=== Case-insensitive search using LCase ==="

    Dim title As String
    Dim searchTerm As String

    title = "Introduction to VBA Programming"
    searchTerm = "vba"

    Debug.Print "Title:  " & title
    Debug.Print "Search: " & searchTerm

    Dim foundAt As Long
    foundAt = InStr(LCase(title), LCase(searchTerm))
    If foundAt > 0 Then
        Debug.Print "Found '" & searchTerm & "' at position " & foundAt & " (case-insensitive)"
    Else
        Debug.Print "Not found"
    End If

    Debug.Print ""
    Debug.Print "=== Mixed case normalization ==="
    Dim rawInput As String
    rawInput = "  hElLo WoRLd  "
    Debug.Print "Raw input:    [" & rawInput & "]"
    Debug.Print "Normalized:   [" & UCase(rawInput) & "]"
    Debug.Print "Length:       " & Len(rawInput)
End Sub
