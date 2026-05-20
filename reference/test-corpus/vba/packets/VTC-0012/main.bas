Attribute VB_Name = "VTC0012_BinarySearch"
Option Explicit

Sub Main()
    Dim arr(11) As Long
    Dim i As Long
    Dim idx As Long

    ' Pre-sorted array
    arr(0) = 2
    arr(1) = 5
    arr(2) = 8
    arr(3) = 12
    arr(4) = 16
    arr(5) = 23
    arr(6) = 38
    arr(7) = 45
    arr(8) = 56
    arr(9) = 72
    arr(10) = 85
    arr(11) = 91

    Debug.Print "=== Binary Search ==="
    Debug.Print ""

    Debug.Print "Sorted array:"
    Dim line As String
    line = "  ["
    For i = 0 To 11
        If i > 0 Then line = line & ", "
        line = line & CStr(arr(i))
    Next i
    line = line & "]"
    Debug.Print line
    Debug.Print ""

    ' Search for values that exist and ones that don't
    Debug.Print "--- Searching for 23 ---"
    idx = BinarySearch(arr, 0, 11, 23)
    If idx >= 0 Then
        Debug.Print "  Found at index " & CStr(idx)
    Else
        Debug.Print "  Not found"
    End If
    Debug.Print ""

    Debug.Print "--- Searching for 72 ---"
    idx = BinarySearch(arr, 0, 11, 72)
    If idx >= 0 Then
        Debug.Print "  Found at index " & CStr(idx)
    Else
        Debug.Print "  Not found"
    End If
    Debug.Print ""

    Debug.Print "--- Searching for 2 (first element) ---"
    idx = BinarySearch(arr, 0, 11, 2)
    If idx >= 0 Then
        Debug.Print "  Found at index " & CStr(idx)
    Else
        Debug.Print "  Not found"
    End If
    Debug.Print ""

    Debug.Print "--- Searching for 50 (not in array) ---"
    idx = BinarySearch(arr, 0, 11, 50)
    If idx >= 0 Then
        Debug.Print "  Found at index " & CStr(idx)
    Else
        Debug.Print "  Not found"
    End If
    Debug.Print ""

    Debug.Print "Binary search complete."
End Sub

Function BinarySearch(ByRef arr() As Long, ByVal lo As Long, ByVal hi As Long, ByVal target As Long) As Long
    Dim mid As Long
    Dim step_ As Long

    step_ = 1

    Do While lo <= hi
        mid = lo + (hi - lo) \ 2
        Debug.Print "  Step " & CStr(step_) & ": lo=" & CStr(lo) & " hi=" & CStr(hi) & " mid=" & CStr(mid) & " arr(mid)=" & CStr(arr(mid))

        If arr(mid) = target Then
            BinarySearch = mid
            Exit Function
        ElseIf arr(mid) < target Then
            Debug.Print "    " & CStr(arr(mid)) & " < " & CStr(target) & " -> search right half"
            lo = mid + 1
        Else
            Debug.Print "    " & CStr(arr(mid)) & " > " & CStr(target) & " -> search left half"
            hi = mid - 1
        End If

        step_ = step_ + 1
    Loop

    BinarySearch = -1
End Function
