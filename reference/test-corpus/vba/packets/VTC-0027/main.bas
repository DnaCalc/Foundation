Option Explicit

Sub Main()
    Dim col As New Collection
    Dim item As Variant
    Dim i As Long

    ' === Adding items without keys ===
    Debug.Print "=== Adding Items (no keys) ==="
    col.Add "Apple"
    col.Add "Banana"
    col.Add "Cherry"
    Debug.Print "Added 3 fruits. Count: " & col.Count

    ' === Access by index (1-based) ===
    Debug.Print ""
    Debug.Print "=== Access by Index ==="
    For i = 1 To col.Count
        Debug.Print "  col(" & i & ") = " & col(i)
    Next i

    ' === For Each iteration ===
    Debug.Print ""
    Debug.Print "=== For Each Iteration ==="
    For Each item In col
        Debug.Print "  -> " & item
    Next item

    ' === Adding items with keys ===
    Debug.Print ""
    Debug.Print "=== Adding Items with Keys ==="

    Dim colors As New Collection
    colors.Add "Red", "r"
    colors.Add "Green", "g"
    colors.Add "Blue", "b"
    Debug.Print "Added 3 colors with keys. Count: " & colors.Count

    ' Access by key
    Debug.Print "  colors(""r"") = " & colors("r")
    Debug.Print "  colors(""g"") = " & colors("g")
    Debug.Print "  colors(""b"") = " & colors("b")

    ' Access by index still works
    Debug.Print "  colors(1)    = " & colors(1)

    ' === Positional insertion: Before / After ===
    Debug.Print ""
    Debug.Print "=== Positional Insertion ==="

    Dim nums As New Collection
    nums.Add "Second"
    nums.Add "Fourth"
    Debug.Print "Initial: " & CollectionToString(nums)

    ' Add before index 1
    nums.Add "First", , 1
    Debug.Print "After Add ""First"" before 1: " & CollectionToString(nums)

    ' Add after index 3
    nums.Add "Fifth", , , 3
    Debug.Print "After Add ""Fifth"" after 3:  " & CollectionToString(nums)

    ' Add "Third" before index 3
    nums.Add "Third", , 3
    Debug.Print "After Add ""Third"" before 3: " & CollectionToString(nums)

    Debug.Print "Final count: " & nums.Count

    ' === Remove items ===
    Debug.Print ""
    Debug.Print "=== Remove Operations ==="

    Dim letters As New Collection
    letters.Add "A", "a"
    letters.Add "B", "b"
    letters.Add "C", "c"
    letters.Add "D", "d"
    letters.Add "E", "e"
    Debug.Print "Before: " & CollectionToString(letters) & " (Count=" & letters.Count & ")"

    ' Remove by index
    letters.Remove 2
    Debug.Print "Remove index 2: " & CollectionToString(letters) & " (Count=" & letters.Count & ")"

    ' Remove by key
    letters.Remove "d"
    Debug.Print "Remove key ""d"": " & CollectionToString(letters) & " (Count=" & letters.Count & ")"

    ' === Mixed types in a Collection ===
    Debug.Print ""
    Debug.Print "=== Mixed Types ==="

    Dim mixed As New Collection
    mixed.Add 42
    mixed.Add "Hello"
    mixed.Add 3.14
    mixed.Add True
    mixed.Add DateSerial(2024, 1, 1)

    For i = 1 To mixed.Count
        Debug.Print "  Item " & i & ": " & mixed(i) & " (TypeName=" & TypeName(mixed(i)) & ")"
    Next i

    ' === Error on duplicate key ===
    Debug.Print ""
    Debug.Print "=== Duplicate Key Error ==="

    Dim keyTest As New Collection
    keyTest.Add "First", "dup"

    On Error Resume Next
    keyTest.Add "Second", "dup"
    Debug.Print "Adding duplicate key ""dup"":"
    Debug.Print "  Err.Number: " & Err.Number
    Debug.Print "  Err.Description: " & Err.Description
    Err.Clear
    On Error GoTo 0

    ' === Error on invalid key lookup ===
    Debug.Print ""
    Debug.Print "=== Invalid Key Lookup ==="

    On Error Resume Next
    Dim badLookup As Variant
    badLookup = keyTest("nonexistent")
    Debug.Print "Accessing non-existent key:"
    Debug.Print "  Err.Number: " & Err.Number
    Debug.Print "  Err.Description: " & Err.Description
    Err.Clear
    On Error GoTo 0

    Debug.Print ""
    Debug.Print "Collection operations complete."
End Sub

Function CollectionToString(col As Collection) As String
    Dim result As String
    Dim v As Variant
    Dim first As Boolean

    result = "["
    first = True
    For Each v In col
        If Not first Then result = result & ", "
        result = result & CStr(v)
        first = False
    Next v
    result = result & "]"

    CollectionToString = result
End Function
