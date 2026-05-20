Option Explicit

Sub Main()
    Dim baseDate As Date
    Dim resultDate As Date
    Dim diffDays As Long
    Dim diffMonths As Long
    Dim diffYears As Long
    Dim diffHours As Long

    ' --- DateAdd: adding various intervals ---
    baseDate = DateSerial(2024, 3, 15)  ' March 15, 2024
    Debug.Print "=== DateAdd Demonstrations ==="
    Debug.Print "Base date: " & Format(baseDate, "yyyy-mm-dd")

    ' Add 10 days
    resultDate = DateAdd("d", 10, baseDate)
    Debug.Print "Add 10 days:   " & Format(resultDate, "yyyy-mm-dd")

    ' Add 3 months
    resultDate = DateAdd("m", 3, baseDate)
    Debug.Print "Add 3 months:  " & Format(resultDate, "yyyy-mm-dd")

    ' Subtract 1 year
    resultDate = DateAdd("yyyy", -1, baseDate)
    Debug.Print "Sub 1 year:    " & Format(resultDate, "yyyy-mm-dd")

    ' Add 6 hours
    resultDate = DateAdd("h", 6, baseDate)
    Debug.Print "Add 6 hours:   " & Format(resultDate, "yyyy-mm-dd hh:nn:ss")

    ' Add 90 minutes
    resultDate = DateAdd("n", 90, baseDate)
    Debug.Print "Add 90 minutes:" & Format(resultDate, "yyyy-mm-dd hh:nn:ss")

    ' Add 45 seconds
    resultDate = DateAdd("s", 45, baseDate)
    Debug.Print "Add 45 seconds:" & Format(resultDate, "yyyy-mm-dd hh:nn:ss")

    ' --- DateAdd edge case: month-end rollover ---
    Debug.Print ""
    Debug.Print "=== Month-End Rollover ==="
    baseDate = DateSerial(2024, 1, 31)  ' Jan 31
    Debug.Print "Start: " & Format(baseDate, "yyyy-mm-dd")
    resultDate = DateAdd("m", 1, baseDate)
    Debug.Print "Add 1 month: " & Format(resultDate, "yyyy-mm-dd") & " (Feb clamp)"
    resultDate = DateAdd("m", 2, baseDate)
    Debug.Print "Add 2 months:" & Format(resultDate, "yyyy-mm-dd") & " (Mar clamp)"

    ' --- DateDiff: computing differences ---
    Debug.Print ""
    Debug.Print "=== DateDiff Demonstrations ==="

    Dim startDate As Date
    Dim endDate As Date
    startDate = DateSerial(2020, 6, 1)
    endDate = DateSerial(2024, 3, 15)

    Debug.Print "From: " & Format(startDate, "yyyy-mm-dd")
    Debug.Print "To:   " & Format(endDate, "yyyy-mm-dd")

    diffDays = DateDiff("d", startDate, endDate)
    Debug.Print "Difference in days:   " & diffDays

    diffMonths = DateDiff("m", startDate, endDate)
    Debug.Print "Difference in months: " & diffMonths

    diffYears = DateDiff("yyyy", startDate, endDate)
    Debug.Print "Difference in years:  " & diffYears

    ' Hours between two date-times
    Dim dt1 As Date
    Dim dt2 As Date
    dt1 = CDate("2024-03-15 08:00:00")
    dt2 = CDate("2024-03-17 14:30:00")
    diffHours = DateDiff("h", dt1, dt2)
    Debug.Print ""
    Debug.Print "From: " & Format(dt1, "yyyy-mm-dd hh:nn:ss")
    Debug.Print "To:   " & Format(dt2, "yyyy-mm-dd hh:nn:ss")
    Debug.Print "Difference in hours: " & diffHours

    ' --- Weeks between dates ---
    Dim diffWeeks As Long
    diffWeeks = DateDiff("ww", startDate, endDate)
    Debug.Print ""
    Debug.Print "Weeks between " & Format(startDate, "yyyy-mm-dd") & " and " & Format(endDate, "yyyy-mm-dd") & ": " & diffWeeks

    ' --- Round-trip verification ---
    Debug.Print ""
    Debug.Print "=== Round-Trip Check ==="
    baseDate = DateSerial(2024, 7, 4)
    resultDate = DateAdd("d", 100, baseDate)
    Dim roundTrip As Long
    roundTrip = DateDiff("d", baseDate, resultDate)
    Debug.Print "Added 100 days, DateDiff reports: " & roundTrip & " days"
    Debug.Print "Round-trip matches: " & (roundTrip = 100)
End Sub
