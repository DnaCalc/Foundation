Option Explicit

Sub Main()
    ' === Pattern 1: On Error GoTo <label> ===
    Debug.Print "=== Pattern 1: On Error GoTo Handler ==="
    TestGoToHandler

    ' === Pattern 2: On Error Resume Next ===
    Debug.Print ""
    Debug.Print "=== Pattern 2: On Error Resume Next ==="
    TestResumeNext

    ' === Pattern 3: Err.Raise for custom errors ===
    Debug.Print ""
    Debug.Print "=== Pattern 3: Err.Raise ==="
    TestErrRaise

    ' === Pattern 4: Nested error handling ===
    Debug.Print ""
    Debug.Print "=== Pattern 4: Error state inspection ==="
    TestErrorState

    Debug.Print ""
    Debug.Print "All error handling patterns completed."
End Sub

Sub TestGoToHandler()
    Dim result As Double

    On Error GoTo DivisionError

    Debug.Print "Attempting 10 / 2..."
    result = 10 / 2
    Debug.Print "  Result: " & result

    Debug.Print "Attempting 10 / 0..."
    result = 10 / 0
    Debug.Print "  This line should not execute"

    GoTo DoneSection

DivisionError:
    Debug.Print "  Caught error #" & Err.Number & ": " & Err.Description
    Resume DoneSection

DoneSection:
    On Error GoTo 0
    Debug.Print "  Handler section complete"
End Sub

Sub TestResumeNext()
    Dim val1 As Variant
    Dim val2 As Variant
    Dim val3 As Variant
    Dim i As Long

    On Error Resume Next

    ' Attempt a type mismatch
    Debug.Print "Assigning ""abc"" to a Date variable..."
    Dim d As Date
    d = CDate("not a date")
    Debug.Print "  Err.Number: " & Err.Number
    Debug.Print "  Err.Description: " & Err.Description

    ' Clear and try another
    Err.Clear
    Debug.Print ""
    Debug.Print "After Err.Clear:"
    Debug.Print "  Err.Number: " & Err.Number

    ' Overflow: CInt with a value too large
    Debug.Print ""
    Debug.Print "Attempting CInt(40000)..."
    Dim tooLarge As Integer
    tooLarge = CInt(40000)
    Debug.Print "  Err.Number: " & Err.Number
    Debug.Print "  Err.Description: " & Err.Description
    Err.Clear

    ' Array bounds
    Debug.Print ""
    Debug.Print "Attempting out-of-bounds array access..."
    Dim arr(2) As Long
    arr(0) = 10
    arr(1) = 20
    arr(2) = 30
    val1 = arr(5)
    Debug.Print "  Err.Number: " & Err.Number
    Debug.Print "  Err.Description: " & Err.Description
    Err.Clear

    On Error GoTo 0
    Debug.Print "  Resume Next section complete"
End Sub

Sub TestErrRaise()
    On Error GoTo CustomHandler

    Debug.Print "Raising custom error 513..."
    Err.Raise 513, "TestErrRaise", "This is a custom application error"
    Debug.Print "  This line should not execute"
    GoTo DoneRaise

CustomHandler:
    Debug.Print "  Caught error #" & Err.Number
    Debug.Print "  Source: " & Err.Source
    Debug.Print "  Description: " & Err.Description
    Resume DoneRaise

DoneRaise:
    On Error GoTo 0

    ' Raise with vbObjectError base
    On Error GoTo AppHandler
    Debug.Print ""
    Debug.Print "Raising vbObjectError + 1024..."
    Err.Raise vbObjectError + 1024, "TestErrRaise", "Application-defined error with vbObjectError base"
    GoTo DoneApp

AppHandler:
    Debug.Print "  Caught error #" & Err.Number
    Debug.Print "  Is negative (vbObjectError-based): " & (Err.Number < 0)
    Debug.Print "  Description: " & Err.Description
    Resume DoneApp

DoneApp:
    On Error GoTo 0
    Debug.Print "  Err.Raise section complete"
End Sub

Sub TestErrorState()
    On Error Resume Next

    ' Force an error
    Dim x As Long
    x = CLng("not a number")

    Debug.Print "Error state after CLng(""not a number""):"
    Debug.Print "  Err.Number:      " & Err.Number
    Debug.Print "  Err.Description: " & Err.Description
    Debug.Print "  Err.Source:      " & Err.Source

    ' Show that Err persists until cleared or new error
    Debug.Print ""
    Debug.Print "Err persists (no clear yet):"
    Debug.Print "  Err.Number: " & Err.Number

    Err.Clear
    Debug.Print ""
    Debug.Print "After Err.Clear:"
    Debug.Print "  Err.Number: " & Err.Number
    Debug.Print "  Err.Description: """ & Err.Description & """"

    On Error GoTo 0
    Debug.Print "  Error state inspection complete"
End Sub
