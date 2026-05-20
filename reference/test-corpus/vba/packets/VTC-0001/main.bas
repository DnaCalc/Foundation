Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0001: Math Primitives
    ' Explore Abs, Sgn, Sqr, and Round with varied inputs
    ' --------------------------------------------------

    Dim temperature As Double
    Dim altitude As Long
    Dim area As Double
    Dim rawPrice As Double

    ' --- Abs: absolute value ---
    Debug.Print "=== Absolute Value (Abs) ==="

    temperature = -18.5
    Debug.Print "Temperature reading: " & temperature
    Debug.Print "Absolute value:      " & Abs(temperature)

    altitude = -350
    Debug.Print "Depth below sea level: " & altitude
    Debug.Print "Distance from sea level: " & Abs(altitude)

    Debug.Print "Abs(0) = " & Abs(0)
    Debug.Print ""

    ' --- Sgn: sign function ---
    Debug.Print "=== Sign Function (Sgn) ==="

    Dim profit As Double
    Dim breakEven As Double
    Dim loss As Double

    profit = 4250.75
    breakEven = 0
    loss = -892.3

    Debug.Print "Profit " & profit & " -> Sgn = " & Sgn(profit)
    Debug.Print "Break-even " & breakEven & " -> Sgn = " & Sgn(breakEven)
    Debug.Print "Loss " & loss & " -> Sgn = " & Sgn(loss)
    Debug.Print ""

    ' --- Sqr: square root ---
    Debug.Print "=== Square Root (Sqr) ==="

    area = 81
    Debug.Print "Area of square: " & area
    Debug.Print "Side length:    " & Sqr(area)

    area = 200
    Debug.Print "Area of square: " & area
    Debug.Print "Side length:    " & Sqr(area)

    Debug.Print "Sqr(0) = " & Sqr(0)
    Debug.Print "Sqr(1) = " & Sqr(1)
    Debug.Print ""

    ' --- Round: banker's rounding ---
    Debug.Print "=== Rounding (Round) ==="

    rawPrice = 19.876
    Debug.Print "Raw price: " & rawPrice
    Debug.Print "Rounded to 2 decimals: " & Round(rawPrice, 2)
    Debug.Print "Rounded to 1 decimal:  " & Round(rawPrice, 1)
    Debug.Print "Rounded to integer:    " & Round(rawPrice, 0)

    Dim bigNumber As Long
    bigNumber = 1234
    Debug.Print "Value: " & bigNumber
    Debug.Print "Round to nearest 10:   " & Round(bigNumber, -1)
    Debug.Print "Round to nearest 100:  " & Round(bigNumber, -2)

    Debug.Print ""
    Debug.Print "=== Combined: distance between two points ==="
    Dim dx As Double
    Dim dy As Double
    dx = -3
    dy = 4
    Debug.Print "dx = " & dx & ", dy = " & dy
    Debug.Print "Distance = Sqr(Abs(dx)^2 + Abs(dy)^2) = " & Sqr(Abs(dx) ^ 2 + Abs(dy) ^ 2)
End Sub
