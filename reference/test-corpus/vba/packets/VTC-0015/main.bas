Attribute VB_Name = "VTC0015_SieveOfEratosthenes"
Option Explicit

Sub Main()
    Const LIMIT As Long = 100
    Dim sieve(100) As Boolean  ' True means composite (not prime)
    Dim i As Long
    Dim j As Long
    Dim count As Long
    Dim line As String

    Debug.Print "=== Sieve of Eratosthenes ==="
    Debug.Print ""
    Debug.Print "Finding all primes up to " & CStr(LIMIT) & ":"
    Debug.Print ""

    ' 0 and 1 are not prime
    sieve(0) = True
    sieve(1) = True

    ' Mark composites
    For i = 2 To CLng(Sqr(CDbl(LIMIT)))
        If Not sieve(i) Then
            Debug.Print "  Marking multiples of " & CStr(i) & " as composite"
            For j = i * i To LIMIT Step i
                sieve(j) = True
            Next j
        End If
    Next i

    Debug.Print ""
    Debug.Print "Primes up to " & CStr(LIMIT) & ":"

    ' Collect and print primes
    count = 0
    line = "  "
    For i = 2 To LIMIT
        If Not sieve(i) Then
            If count > 0 Then line = line & ", "
            line = line & CStr(i)
            count = count + 1
        End If
    Next i
    Debug.Print line

    Debug.Print ""
    Debug.Print "Total primes found: " & CStr(count)
    Debug.Print ""
    Debug.Print "Sieve of Eratosthenes complete."
End Sub
