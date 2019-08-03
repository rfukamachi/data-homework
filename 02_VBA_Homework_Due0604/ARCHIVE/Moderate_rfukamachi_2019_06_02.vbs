Sub Moderate():
  'VARIABLE DECLARATIONS******************
  Dim wsheet As Worksheet
          
  Dim TickerGrp()     'unique tickers to be used as the key to the dict below
  
  Dim TickerTotals    'to be used as a dictionary for the totals
  Dim TickerOpens     'to be used as a dictionary for opening prices
  Dim TickerCloses    'to be used as a dictinary for closing prices
  
  Dim NextTicker As String
  Dim CurrentTicker As String
  Dim CurrentVol As Long
  Dim CurrentOpen As Long
  Dim CurrentClose As Long
  Dim NextDate As Long
  Dim CurrentDate As Long
  
  Dim LRow As Long
  Dim index As Long
  Dim ArrayIndex As Long
  
  Dim YearlyChangeRow As Long
  Dim YearlyChange As Double
  Dim PercentChange As Double
    
  For Each wsheet In Worksheets
  
      'VARIABLE DEFINITIONS******************
      Set TickerTotals = CreateObject("Scripting.dictionary")
      Set TickerOpens = CreateObject("Scripting.dictionary")
      Set TickerCloses = CreateObject("Scripting.dictionary")
      LRow = wsheet.UsedRange.Rows.Count    'LRow = UBound(TickerData)   <<also works and this is from class: Cells(Rows.Count, 1).End(xlUp).Row
      
      
      '**************************************
      '**************************************
      
      'PULL UNIQUE TICKERS*******************
      ArrayIndex = 0
      
      For index = 1 To LRow
        CurrentTicker = wsheet.Cells(index + 1, 1).Value
        
        'IF THIS IS THE FIRST ROUND:
        If ArrayIndex = 0 Then
          ReDim TickerGrp(ArrayIndex)
          TickerGrp(ArrayIndex) = CurrentTicker
          ArrayIndex = ArrayIndex + 1
          
        'IF THE STRING IS NOT FOUND:
        ElseIf (UBound(Filter(TickerGrp, CurrentTicker)) > -1) = False Then
          ReDim Preserve TickerGrp(0 To ArrayIndex)
          TickerGrp(ArrayIndex) = CurrentTicker
          ArrayIndex = ArrayIndex + 1
        
        'IF THE STRING FOUND BUT IS NOT AN EXACT MATCH:
        ElseIf ((UBound(Filter(TickerGrp, CurrentTicker)) > -1) = True) And (IsError(Application.Match(CurrentTicker, TickerGrp, 0))) Then
          ReDim Preserve TickerGrp(0 To ArrayIndex)
          TickerGrp(ArrayIndex) = CurrentTicker
          ArrayIndex = ArrayIndex + 1
        
        End If
      
      Next index
      
      
      'TEST TICKER GROUP LOGIC****************
      'Range("I1") = "Ticker"
      'For index = 0 To ArrayIndex
        'Cells(index + 2, 12) = TickerGrp(index)
      'Next index
      
      
      
      
      '**************************************
      'EASY SECTION
      '**************************************
      
      'DEFINE THE TOTALS DICTIONARY*********
      ArrayIndex = ArrayIndex - 1
      
      For index = 0 To ArrayIndex
        CurrentTicker = TickerGrp(index)
        CurrentVol = 0
        TickerTotals.Add CurrentTicker, CurrentVol
      Next index
      
      
      'ADD UP THE VOLUMES*******************
      For index = 1 To LRow
        CurrentTicker = wsheet.Cells(index + 1, 1).Value
        CurrentVol = wsheet.Cells(index + 1, 7).Value
        TickerTotals(CurrentTicker) = TickerTotals(CurrentTicker) + CurrentVol
      Next index
          
      
      '**************************************
      'MODERATE SECTION
      '**************************************
      
      'COLLECT THE FIRST OPENS OF THE YEAR***
      For index = 0 To ArrayIndex
        CurrentTicker = TickerGrp(index)
        CurrentOpen = 0
        TickerOpens.Add CurrentTicker, CurrentOpen
      Next index

      For index = 2 To LRow
        CurrentTicker = wsheet.Cells(index, 1).Value
        NextTicker = wsheet.Cells(index + 1, 1).Value
        
        If index = 2 Then
          TickerOpens(CurrentTicker) = wsheet.Cells(index, 3).Value
        ElseIf CurrentTicker <> NextTicker Then
          TickerOpens(NextTicker) = wsheet.Cells(index + 1, 3).Value
        End If
      
      Next index
      
      
      '**************************************
      '**************************************
      
      'COLLECT THE LAST CLOSES OF THE YEAR***
      For index = 0 To ArrayIndex
        CurrentTicker = TickerGrp(index)
        CurrentClose = 0
        TickerCloses.Add CurrentTicker, CurrentClose
      Next index

      For index = 2 To LRow
        CurrentTicker = wsheet.Cells(index, 1).Value
        NextTicker = wsheet.Cells(index + 1, 1).Value
        
        If CurrentTicker <> NextTicker Then
          TickerCloses(CurrentTicker) = wsheet.Cells(index, 6).Value
        End If
        
      Next index
      
      
      '**************************************
      '**************************************
      
      'DISPLAY RESULT TITLES*****************
      wsheet.Range("I1") = "Ticker"
      wsheet.Range("J1") = "Yearly Change"
      wsheet.Range("K1") = "Percent Change"
      wsheet.Range("L1") = "Total Stock Volume"
      
      'CALCULATE THE YEARLY CHANGE***********
      YearlyChangeRow = 2
      
      For index = 0 To ArrayIndex - 1
        CurrentTicker = TickerGrp(index)
        YearlyChange = TickerCloses(CurrentTicker) - TickerOpens(CurrentTicker)
        
        If YearlyChange = 0 Then
          PercentChange = 0
        Else
          PercentChange = YearlyChange / TickerOpens(CurrentTicker)
        End If
        
        wsheet.Cells(YearlyChangeRow, 9) = TickerTotals.keys()(index)
        wsheet.Cells(YearlyChangeRow, 10) = YearlyChange
        wsheet.Cells(YearlyChangeRow, 11) = PercentChange
        wsheet.Cells(YearlyChangeRow, 11).NumberFormat = "0.00%"
        wsheet.Cells(YearlyChangeRow, 12) = TickerTotals.items()(index)
        
        If YearlyChange < 0 Then
          wsheet.Cells(YearlyChangeRow, 10).Interior.ColorIndex = 3
        Else
          wsheet.Cells(YearlyChangeRow, 10).Interior.ColorIndex = 4
        End If
        
        YearlyChangeRow = YearlyChangeRow + 1
      Next index
      
           
      '**************************************
      '**************************************
      
      
      
      
      
      
      
      'TESTING ONLY:
      'For index = 0 To ArrayIndex
        'Cells(index + 2, 11) = TickerTotals.keys()(index)
        'Cells(index + 2, 12) = TickerTotals.items()(index)
      'Next index
      
  Next wsheet


End Sub



