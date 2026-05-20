Option Explicit

Sub Main()
    Const ROWS As Long = 4
    Const COLS As Long = 5

    Dim matrix(0 To 3, 0 To 4) As Long
    Dim r As Long
    Dim c As Long
    Dim rowSum As Long
    Dim colSum As Long
    Dim grandTotal As Long
    Dim line As String

    ' === Fill the matrix with a pattern ===
    Debug.Print "=== Fill Matrix (" & ROWS & "x" & COLS & ") ==="
    For r = 0 To ROWS - 1
        For c = 0 To COLS - 1
            matrix(r, c) = (r + 1) * 10 + (c + 1)
        Next c
    Next r
    Debug.Print "Pattern: cell(r,c) = (r+1)*10 + (c+1)"

    ' === Print the matrix ===
    Debug.Print ""
    Debug.Print "=== Matrix Contents ==="

    ' Header row
    line = "     "
    For c = 0 To COLS - 1
        line = line & PadLeft("C" & c, 6)
    Next c
    Debug.Print line

    ' Data rows
    For r = 0 To ROWS - 1
        line = "R" & r & "   "
        For c = 0 To COLS - 1
            line = line & PadLeft(CStr(matrix(r, c)), 6)
        Next c
        Debug.Print line
    Next r

    ' === Row sums ===
    Debug.Print ""
    Debug.Print "=== Row Sums ==="
    grandTotal = 0
    For r = 0 To ROWS - 1
        rowSum = 0
        For c = 0 To COLS - 1
            rowSum = rowSum + matrix(r, c)
        Next c
        Debug.Print "  Row " & r & " sum: " & rowSum
        grandTotal = grandTotal + rowSum
    Next r

    ' === Column sums ===
    Debug.Print ""
    Debug.Print "=== Column Sums ==="
    For c = 0 To COLS - 1
        colSum = 0
        For r = 0 To ROWS - 1
            colSum = colSum + matrix(r, c)
        Next r
        Debug.Print "  Col " & c & " sum: " & colSum
    Next c

    Debug.Print ""
    Debug.Print "Grand total: " & grandTotal

    ' === Bounds inspection ===
    Debug.Print ""
    Debug.Print "=== Array Bounds ==="
    Debug.Print "Dimension 1: LBound=" & LBound(matrix, 1) & " UBound=" & UBound(matrix, 1)
    Debug.Print "Dimension 2: LBound=" & LBound(matrix, 2) & " UBound=" & UBound(matrix, 2)

    ' === Transpose into a new array ===
    Debug.Print ""
    Debug.Print "=== Transposed Matrix ==="
    Dim transposed(0 To 4, 0 To 3) As Long
    For r = 0 To ROWS - 1
        For c = 0 To COLS - 1
            transposed(c, r) = matrix(r, c)
        Next c
    Next r

    ' Print transposed
    line = "     "
    For c = 0 To ROWS - 1
        line = line & PadLeft("C" & c, 6)
    Next c
    Debug.Print line

    For r = 0 To COLS - 1
        line = "R" & r & "   "
        For c = 0 To ROWS - 1
            line = line & PadLeft(CStr(transposed(r, c)), 6)
        Next c
        Debug.Print line
    Next r

    ' === Diagonal (min of rows, cols) ===
    Debug.Print ""
    Debug.Print "=== Main Diagonal ==="
    Dim diagSize As Long
    If ROWS < COLS Then
        diagSize = ROWS
    Else
        diagSize = COLS
    End If

    Dim diagSum As Long
    diagSum = 0
    For r = 0 To diagSize - 1
        Debug.Print "  matrix(" & r & "," & r & ") = " & matrix(r, r)
        diagSum = diagSum + matrix(r, r)
    Next r
    Debug.Print "Diagonal sum: " & diagSum
End Sub

Function PadLeft(ByVal s As String, ByVal width As Long) As String
    If Len(s) >= width Then
        PadLeft = s
    Else
        PadLeft = Space(width - Len(s)) & s
    End If
End Function
