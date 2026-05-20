Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0007: For-Next with GoSub
    ' Accumulate sum of squares using GoSub/Return
    ' --------------------------------------------------

    Dim currentValue As Long
    Dim squaredValue As Long
    Dim runningTotal As Long
    Dim counter As Long

    runningTotal = 0

    Debug.Print "=== Sum of squares using GoSub ==="
    Debug.Print "Computing 1^2 + 2^2 + 3^2 + ... + 10^2"
    Debug.Print ""

    For counter = 1 To 10
        currentValue = counter
        GoSub SquareAndAccumulate
        Debug.Print "  i=" & counter & "  squared=" & squaredValue & "  running total=" & runningTotal
    Next counter

    Debug.Print ""
    Debug.Print "Final sum of squares (1 to 10): " & runningTotal
    Debug.Print ""

    ' --- Second pass: weighted accumulation ---
    Debug.Print "=== Weighted score accumulator ==="
    Debug.Print "Scores: 85, 92, 78, 95, 88"
    Debug.Print "Weights: x1, x2, x3, x4, x5"
    Debug.Print ""

    Dim scores(1 To 5) As Long
    Dim weightedSum As Long
    Dim totalWeight As Long

    scores(1) = 85
    scores(2) = 92
    scores(3) = 78
    scores(4) = 95
    scores(5) = 88

    weightedSum = 0
    totalWeight = 0

    For counter = 1 To 5
        currentValue = scores(counter)
        GoSub ApplyWeight
    Next counter

    Debug.Print ""
    Debug.Print "Total weighted sum: " & weightedSum
    Debug.Print "Total weight:       " & totalWeight
    Debug.Print "Weighted average:   " & Round(CDbl(weightedSum) / CDbl(totalWeight), 2)

    Exit Sub

SquareAndAccumulate:
    squaredValue = currentValue * currentValue
    runningTotal = runningTotal + squaredValue
    Return

ApplyWeight:
    Dim weight As Long
    weight = counter
    weightedSum = weightedSum + (currentValue * weight)
    totalWeight = totalWeight + weight
    Debug.Print "  Score=" & currentValue & "  Weight=" & weight & "  Contribution=" & (currentValue * weight)
    Return
End Sub
