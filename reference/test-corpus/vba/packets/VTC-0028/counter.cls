Option Explicit

Private mValue As Long

Public Property Get Value() As Long
    Value = mValue
End Property

Public Property Let Value(ByVal v As Long)
    mValue = v
End Property

Public Sub Increment()
    mValue = mValue + 1
End Sub

Public Sub Decrement()
    mValue = mValue - 1
End Sub

Public Sub Reset()
    mValue = 0
End Sub

Public Function ToString() As String
    ToString = "Counter(" & mValue & ")"
End Function
