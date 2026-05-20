Attribute VB_Name = "VTC0011_BubbleSort"
Option Explicit

Sub Main()
    Dim arr(9) As Long
    Dim i As Long

    ' Initialize array with unsorted values
    arr(0) = 64
    arr(1) = 34
    arr(2) = 25
    arr(3) = 12
    arr(4) = 22
    arr(5) = 11
    arr(6) = 90
    arr(7) = 1
    arr(8) = 45
    arr(9) = 78

    Debug.Print "=== Bubble Sort ==="
    Debug.Print ""

    Debug.Print "Before sorting:"
    PrintArray arr

    BubbleSort arr

    Debug.Print "After sorting:"
    PrintArray arr

    Debug.Print "Bubble sort complete."
End Sub

Sub BubbleSort(ByRef arr() As Long)
    Dim n As Long
    Dim i As Long
    Dim j As Long
    Dim temp As Long
    Dim swapped As Boolean

    n = UBound(arr) - LBound(arr) + 1

    For i = 0 To n - 2
        swapped = False
        For j = 0 To n - 2 - i
            If arr(j) > arr(j + 1) Then
                temp = arr(j)
                arr(j) = arr(j + 1)
                arr(j + 1) = temp
                swapped = True
            End If
        Next j
        Debug.Print "  Pass " & CStr(i + 1) & ": ";
        Dim k As Long
        Dim line As String
        line = ""
        For k = LBound(arr) To UBound(arr)
            If k > LBound(arr) Then line = line & ", "
            line = line & CStr(arr(k))
        Next k
        Debug.Print line
        If Not swapped Then
            Debug.Print "  (No swaps needed - array is sorted)"
            Exit For
        End If
    Next i
    Debug.Print ""
End Sub

Sub PrintArray(ByRef arr() As Long)
    Dim i As Long
    Dim line As String
    line = "  ["
    For i = LBound(arr) To UBound(arr)
        If i > LBound(arr) Then line = line & ", "
        line = line & CStr(arr(i))
    Next i
    line = line & "]"
    Debug.Print line
    Debug.Print ""
End Sub
