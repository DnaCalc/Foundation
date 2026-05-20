Option Explicit

Sub Main()
    ' --------------------------------------------------
    ' VTC-0005: Financial Functions (FV, PV, PMT)
    ' Time value of money calculations
    ' --------------------------------------------------

    Dim annualRate As Double
    Dim monthlyRate As Double
    Dim numPeriods As Long
    Dim payment As Double
    Dim presentValue As Double
    Dim futureValue As Double

    ' --- Scenario 1: Zero-rate savings (baseline) ---
    Debug.Print "=== Scenario 1: Zero interest rate ==="
    Debug.Print "Saving $200/month for 12 months at 0% interest"

    annualRate = 0
    monthlyRate = 0
    numPeriods = 12
    payment = -200

    futureValue = FV(monthlyRate, numPeriods, payment, 0, 0)
    Debug.Print "Future value: $" & futureValue
    Debug.Print "(At zero rate, FV is simply payment x periods)"
    Debug.Print ""

    ' --- Scenario 2: Simple savings plan ---
    Debug.Print "=== Scenario 2: Monthly savings at 5% annual ==="
    Debug.Print "Saving $500/month for 10 years at 5% annual"

    annualRate = 0.05
    monthlyRate = annualRate / 12
    numPeriods = 10 * 12
    payment = -500

    futureValue = FV(monthlyRate, numPeriods, payment, 0, 0)
    Debug.Print "Monthly rate:  " & Round(monthlyRate * 100, 4) & "%"
    Debug.Print "Total periods: " & numPeriods
    Debug.Print "Future value:  $" & Round(futureValue, 2)
    Debug.Print "Total paid in: $" & Abs(payment) * numPeriods
    Debug.Print "Interest earned: $" & Round(futureValue - Abs(payment) * numPeriods, 2)
    Debug.Print ""

    ' --- Scenario 3: Present value of a future sum ---
    Debug.Print "=== Scenario 3: Present value ==="
    Debug.Print "How much to invest now to have $50,000 in 5 years at 6%?"

    annualRate = 0.06
    monthlyRate = annualRate / 12
    numPeriods = 5 * 12
    futureValue = -50000

    presentValue = PV(monthlyRate, numPeriods, 0, futureValue, 0)
    Debug.Print "Target future value: $50,000"
    Debug.Print "Lump sum needed now: $" & Round(presentValue, 2)
    Debug.Print ""

    ' --- Scenario 4: Loan payment calculation ---
    Debug.Print "=== Scenario 4: Car loan payment ==="
    Debug.Print "Loan of $25,000 at 4.5% annual for 5 years"

    annualRate = 0.045
    monthlyRate = annualRate / 12
    numPeriods = 5 * 12
    presentValue = 25000

    payment = PMT(monthlyRate, numPeriods, presentValue, 0, 0)
    Debug.Print "Loan amount:     $" & presentValue
    Debug.Print "Monthly payment: $" & Round(Abs(payment), 2)
    Debug.Print "Total paid:      $" & Round(Abs(payment) * numPeriods, 2)
    Debug.Print "Total interest:  $" & Round(Abs(payment) * numPeriods - presentValue, 2)
    Debug.Print ""

    ' --- Scenario 5: Zero-rate loan (baseline) ---
    Debug.Print "=== Scenario 5: Zero-rate loan ==="
    Debug.Print "Borrow $1,200 at 0% for 12 months"

    payment = PMT(0, 12, 1200, 0, 0)
    Debug.Print "Monthly payment: $" & Round(Abs(payment), 2)
    Debug.Print "(At zero rate, payment is simply principal / periods)"
End Sub
