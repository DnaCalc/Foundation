Option Explicit

Sub Main()
    Dim c As New Counter

    Debug.Print "=== Counter Class Exercise ==="

    ' Initial state
    Debug.Print "Initial value: " & c.Value
    Debug.Print "  ToString: " & c.ToString()

    ' Increment several times
    Debug.Print ""
    Debug.Print "=== Increment ==="
    c.Increment
    Debug.Print "After Increment: " & c.Value
    c.Increment
    Debug.Print "After Increment: " & c.Value
    c.Increment
    Debug.Print "After Increment: " & c.Value
    Debug.Print "  ToString: " & c.ToString()

    ' Decrement
    Debug.Print ""
    Debug.Print "=== Decrement ==="
    c.Decrement
    Debug.Print "After Decrement: " & c.Value
    c.Decrement
    Debug.Print "After Decrement: " & c.Value
    Debug.Print "  ToString: " & c.ToString()

    ' Property Let: set value directly
    Debug.Print ""
    Debug.Print "=== Property Let ==="
    c.Value = 100
    Debug.Print "Set Value = 100: " & c.Value
    c.Increment
    Debug.Print "After Increment: " & c.Value
    Debug.Print "  ToString: " & c.ToString()

    ' Reset
    Debug.Print ""
    Debug.Print "=== Reset ==="
    c.Reset
    Debug.Print "After Reset: " & c.Value
    Debug.Print "  ToString: " & c.ToString()

    ' Decrement below zero (should work, negative values allowed)
    Debug.Print ""
    Debug.Print "=== Negative Values ==="
    c.Reset
    c.Decrement
    Debug.Print "After Reset + Decrement: " & c.Value
    c.Decrement
    Debug.Print "After another Decrement: " & c.Value
    Debug.Print "  ToString: " & c.ToString()

    ' Multiple instances
    Debug.Print ""
    Debug.Print "=== Multiple Instances ==="
    Dim c1 As New Counter
    Dim c2 As New Counter

    c1.Value = 10
    c2.Value = 20

    c1.Increment
    c2.Decrement

    Debug.Print "Counter1: " & c1.ToString()
    Debug.Print "Counter2: " & c2.ToString()
    Debug.Print "Independent: " & (c1.Value <> c2.Value)

    Debug.Print ""
    Debug.Print "Class exercise complete."
End Sub
