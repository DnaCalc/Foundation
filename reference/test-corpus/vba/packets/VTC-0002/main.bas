Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0002: String Slicing
    ' Extract parts of strings using Left, Right, and Mid
    ' --------------------------------------------------

    Dim phoneNumber As String
    Dim filePath As String
    Dim productCode As String
    Dim sentence As String

    ' --- Left: extract from the beginning ---
    Debug.Print "=== Left (extract from start) ==="

    phoneNumber = "555-867-5309"
    Debug.Print "Phone number: " & phoneNumber
    Debug.Print "Area code (Left 3): " & Left(phoneNumber, 3)

    filePath = "C:\Reports\Q4\summary.xlsx"
    Debug.Print "File path: " & filePath
    Debug.Print "Drive letter (Left 2): " & Left(filePath, 2)
    Debug.Print ""

    ' --- Right: extract from the end ---
    Debug.Print "=== Right (extract from end) ==="

    Debug.Print "Phone number: " & phoneNumber
    Debug.Print "Last 4 digits (Right 4): " & Right(phoneNumber, 4)

    Debug.Print "File path: " & filePath
    Debug.Print "Extension (Right 5): " & Right(filePath, 5)
    Debug.Print ""

    ' --- Mid: extract from any position ---
    Debug.Print "=== Mid (extract from position) ==="

    productCode = "WH-2024-ELEC-0042"
    Debug.Print "Product code: " & productCode
    Debug.Print "Year (Mid 4, 4):     " & Mid(productCode, 4, 4)
    Debug.Print "Category (Mid 9, 4): " & Mid(productCode, 9, 4)
    Debug.Print "Sequence (Mid 14):   " & Mid(productCode, 14)
    Debug.Print ""

    ' --- Combining slicing operations ---
    Debug.Print "=== Practical example: parsing a date string ==="

    Dim dateString As String
    Dim yearPart As String
    Dim monthPart As String
    Dim dayPart As String

    dateString = "2024-03-15"
    Debug.Print "Date string: " & dateString

    yearPart = Left(dateString, 4)
    monthPart = Mid(dateString, 6, 2)
    dayPart = Right(dateString, 2)

    Debug.Print "Year:  " & yearPart
    Debug.Print "Month: " & monthPart
    Debug.Print "Day:   " & dayPart
    Debug.Print ""

    ' --- Edge cases ---
    Debug.Print "=== Edge cases ==="

    sentence = "Hello"
    Debug.Print "Word: " & sentence & " (length " & Len(sentence) & ")"
    Debug.Print "Left(5):  " & Left(sentence, 5)
    Debug.Print "Right(5): " & Right(sentence, 5)
    Debug.Print "Mid(1,5): " & Mid(sentence, 1, 5)
    Debug.Print "Left(1):  " & Left(sentence, 1)
    Debug.Print "Right(1): " & Right(sentence, 1)
    Debug.Print "Mid(3,1): " & Mid(sentence, 3, 1)
End Sub
