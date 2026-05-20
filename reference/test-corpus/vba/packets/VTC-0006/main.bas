Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0006: Date Construction
    ' Build dates with DateSerial and DateValue
    ' --------------------------------------------------

    Dim projectStart As Date
    Dim projectEnd As Date
    Dim milestone As Date

    ' --- DateSerial: construct from year, month, day ---
    Debug.Print "=== DateSerial ==="

    projectStart = DateSerial(2024, 1, 15)
    Debug.Print "Project start: " & projectStart
    Debug.Print "  Year:  " & Year(projectStart)
    Debug.Print "  Month: " & Month(projectStart)
    Debug.Print "  Day:   " & Day(projectStart)
    Debug.Print ""

    projectEnd = DateSerial(2024, 6, 30)
    Debug.Print "Project end:   " & projectEnd
    Debug.Print ""

    ' --- DateSerial with month overflow ---
    Debug.Print "=== DateSerial with overflow ==="
    Debug.Print "DateSerial(2024, 13, 1) wraps to next year:"
    milestone = DateSerial(2024, 13, 1)
    Debug.Print "  Result: " & milestone
    Debug.Print ""

    Debug.Print "DateSerial(2024, 1, 32) wraps to next month:"
    milestone = DateSerial(2024, 1, 32)
    Debug.Print "  Result: " & milestone
    Debug.Print ""

    ' --- DateValue: parse a date string ---
    Debug.Print "=== DateValue ==="

    Dim parsedDate As Date

    parsedDate = DateValue("March 15, 2024")
    Debug.Print "DateValue(""March 15, 2024"") = " & parsedDate

    parsedDate = DateValue("2024-07-04")
    Debug.Print "DateValue(""2024-07-04"")     = " & parsedDate
    Debug.Print ""

    ' --- Date arithmetic ---
    Debug.Print "=== Date arithmetic ==="

    Dim durationDays As Long
    durationDays = CLng(projectEnd - projectStart)
    Debug.Print "Project start: " & projectStart
    Debug.Print "Project end:   " & projectEnd
    Debug.Print "Duration:      " & durationDays & " days"
    Debug.Print ""

    ' --- Weekday information ---
    Debug.Print "=== Weekday ==="

    Dim checkDate As Date
    checkDate = DateSerial(2024, 12, 25)
    Debug.Print "Date: " & checkDate
    Debug.Print "Weekday number: " & Weekday(checkDate)
    Debug.Print "Weekday name:   " & WeekdayName(Weekday(checkDate))
    Debug.Print ""

    ' --- First and last day of a month ---
    Debug.Print "=== First and last day of month ==="

    Dim targetYear As Long
    Dim targetMonth As Long
    Dim firstDay As Date
    Dim lastDay As Date

    targetYear = 2024
    targetMonth = 2

    firstDay = DateSerial(targetYear, targetMonth, 1)
    lastDay = DateSerial(targetYear, targetMonth + 1, 0)

    Debug.Print "Month: " & targetMonth & "/" & targetYear
    Debug.Print "First day: " & firstDay
    Debug.Print "Last day:  " & lastDay
    Debug.Print "Days in month: " & Day(lastDay)
    Debug.Print "(2024 is a leap year, so February has 29 days)"
End Sub
