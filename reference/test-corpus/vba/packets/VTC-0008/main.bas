Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0008: Array Store and Load
    ' Store daily temperatures, read them back, compute stats
    ' --------------------------------------------------

    Dim temperatures(1 To 7) As Double
    Dim dayNames(1 To 7) As String
    Dim i As Long

    ' --- Store values ---
    Debug.Print "=== Storing daily high temperatures (Celsius) ==="

    dayNames(1) = "Monday"
    dayNames(2) = "Tuesday"
    dayNames(3) = "Wednesday"
    dayNames(4) = "Thursday"
    dayNames(5) = "Friday"
    dayNames(6) = "Saturday"
    dayNames(7) = "Sunday"

    temperatures(1) = 22.5
    temperatures(2) = 24.1
    temperatures(3) = 19.8
    temperatures(4) = 21.3
    temperatures(5) = 26.7
    temperatures(6) = 28.2
    temperatures(7) = 25.0

    ' --- Load and display ---
    Debug.Print ""
    Debug.Print "=== Weekly Temperature Report ==="

    For i = 1 To 7
        Debug.Print "  " & dayNames(i) & ": " & temperatures(i) & " C"
    Next i

    Debug.Print ""

    ' --- Compute statistics ---
    Debug.Print "=== Statistics ==="

    Dim total As Double
    Dim minTemp As Double
    Dim maxTemp As Double
    Dim minDay As String
    Dim maxDay As String

    total = 0
    minTemp = temperatures(1)
    maxTemp = temperatures(1)
    minDay = dayNames(1)
    maxDay = dayNames(1)

    For i = 1 To 7
        total = total + temperatures(i)
        If temperatures(i) < minTemp Then
            minTemp = temperatures(i)
            minDay = dayNames(i)
        End If
        If temperatures(i) > maxTemp Then
            maxTemp = temperatures(i)
            maxDay = dayNames(i)
        End If
    Next i

    Dim average As Double
    average = total / 7

    Debug.Print "Total:   " & total & " C"
    Debug.Print "Average: " & Round(average, 2) & " C"
    Debug.Print "Minimum: " & minTemp & " C (" & minDay & ")"
    Debug.Print "Maximum: " & maxTemp & " C (" & maxDay & ")"
    Debug.Print "Range:   " & (maxTemp - minTemp) & " C"
    Debug.Print ""

    ' --- Count days above average ---
    Debug.Print "=== Days above average (" & Round(average, 2) & " C) ==="

    Dim aboveCount As Long
    aboveCount = 0

    For i = 1 To 7
        If temperatures(i) > average Then
            Debug.Print "  " & dayNames(i) & ": " & temperatures(i) & " C"
            aboveCount = aboveCount + 1
        End If
    Next i

    Debug.Print "Count: " & aboveCount & " of 7 days"
End Sub
