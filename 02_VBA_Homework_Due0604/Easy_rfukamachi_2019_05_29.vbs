Sub Easy():
    'VARIABLE DECLARATIONS******************
    Dim wsheet As Worksheet
            
    Dim TickerGrp()
    Dim TickerTotals
    
    Dim CurrentTicker As String
    Dim CurrentVol As Long
                
    Dim LRow As Long
    Dim index As Long
    Dim ArrayIndex As Long
    
    
    'VARIABLE DEFINITIONS******************
    Set wsheet = ActiveSheet
    Set TickerTotals = CreateObject("Scripting.dictionary")
    LRow = wsheet.UsedRange.Rows.Count    'LRow = UBound(TickerData)   <<also works
    
    
    '**************************************
    '**************************************
    
    'PULL UNIQUE TICKERS*******************
    ArrayIndex = 0
    
    For index = 1 To LRow
      CurrentTicker = Cells(index + 1, 1).Value
      
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
    '**************************************
    
    'DEFINE THE DICTIONARY*****************
    ArrayIndex = ArrayIndex - 1
    
    For index = 0 To ArrayIndex
      CurrentTicker = TickerGrp(index)
      CurrentVol = 0
      TickerTotals.Add CurrentTicker, CurrentVol
    Next index
    
    
    'ADD UP THE VOLUMES*******************
    For index = 1 To LRow
      CurrentTicker = Cells(index + 1, 1).Value
      CurrentVol = Cells(index + 1, 7).Value
      
      TickerTotals(CurrentTicker) = TickerTotals(CurrentTicker) + CurrentVol
    Next index
        
    
    
    
    '**************************************
    '**************************************
    
    'DISPLAY RESULTS***********************
    Range("I1") = "Ticker"
    Range("J1") = "Total Stock Volume"
    
    For index = 0 To ArrayIndex - 1
      Cells(index + 2, 9) = TickerTotals.keys()(index)
      Cells(index + 2, 10) = TickerTotals.items()(index)
    Next index
    
    
    
    
    
    
    'TESTING ONLY:
    'For index = 0 To ArrayIndex
      'Cells(index + 2, 11) = TickerTotals.keys()(index)
      'Cells(index + 2, 12) = TickerTotals.items()(index)
    'Next index
    

End Sub




