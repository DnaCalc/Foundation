Attribute VB_Name = "VTC0020_Stack"
Option Explicit

' Module-level stack state
Dim stackData(49) As Long   ' Fixed-size backing array (max 50 elements)
Dim stackTop As Long         ' Index of top element (-1 = empty)

Sub Main()
    Debug.Print "=== Stack via Array ==="
    Debug.Print ""

    ' Initialize stack
    StackInit

    Debug.Print "Pushing values onto stack:"
    StackPush 10
    StackPush 20
    StackPush 30
    StackPush 40
    StackPush 50

    Debug.Print ""
    Debug.Print "Stack size: " & CStr(StackSize())
    Debug.Print "Peek at top: " & CStr(StackPeek())
    Debug.Print ""

    Debug.Print "Popping values:"
    Dim val As Long
    val = StackPop()
    Debug.Print "  Popped: " & CStr(val)
    val = StackPop()
    Debug.Print "  Popped: " & CStr(val)

    Debug.Print ""
    Debug.Print "Stack size after 2 pops: " & CStr(StackSize())
    Debug.Print "Peek at top: " & CStr(StackPeek())
    Debug.Print ""

    Debug.Print "Pushing more values:"
    StackPush 60
    StackPush 70

    Debug.Print ""
    Debug.Print "Popping all remaining values:"
    Do While Not StackIsEmpty()
        val = StackPop()
        Debug.Print "  Popped: " & CStr(val)
    Loop

    Debug.Print ""
    Debug.Print "Stack is empty: " & CStr(StackIsEmpty())
    Debug.Print ""
    Debug.Print "Stack demonstration complete."
End Sub

Sub StackInit()
    stackTop = -1
    Debug.Print "Stack initialized (capacity: 50)"
    Debug.Print ""
End Sub

Sub StackPush(ByVal value As Long)
    If stackTop >= 49 Then
        Debug.Print "  Error: Stack overflow!"
        Exit Sub
    End If
    stackTop = stackTop + 1
    stackData(stackTop) = value
    Debug.Print "  Pushed: " & CStr(value) & " (size: " & CStr(StackSize()) & ")"
End Sub

Function StackPop() As Long
    If stackTop < 0 Then
        Debug.Print "  Error: Stack underflow!"
        StackPop = -1
        Exit Function
    End If
    StackPop = stackData(stackTop)
    stackTop = stackTop - 1
End Function

Function StackPeek() As Long
    If stackTop < 0 Then
        Debug.Print "  Error: Stack is empty!"
        StackPeek = -1
        Exit Function
    End If
    StackPeek = stackData(stackTop)
End Function

Function StackSize() As Long
    StackSize = stackTop + 1
End Function

Function StackIsEmpty() As Boolean
    StackIsEmpty = (stackTop < 0)
End Function
