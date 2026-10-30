VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmDialogs
   Caption         =   "Common Dialog"
   ClientHeight    =   2700
   ClientWidth     =   5400
   Begin MSComDlg.CommonDialog Dialog1
      Left            =   4800
      Top             =   120
   End
   Begin VB.CommandButton cmdOpen
      Caption         =   "Open..."
      Height          =   375
      Left            =   120
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdColor
      Caption         =   "Color..."
      Height          =   375
      Left            =   1440
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdFont
      Caption         =   "Font..."
      Height          =   375
      Left            =   2760
      Top             =   120
      Width           =   1215
   End
   Begin VB.ListBox lstResults
      Height          =   1815
      Left            =   120
      Top             =   720
      Width           =   5160
   End
End
Attribute VB_Name = "frmDialogs"
Option Explicit

Private Sub Form_Load()
    Dialog1.CancelError = True
    Dialog1.Filter = "Text (*.txt)|*.txt|All files|*.*"
    lstResults.AddItem "Choose a dialog; the result is listed here."
End Sub

Private Sub cmdOpen_Click()
    On Error Resume Next
    Dialog1.ShowOpen
    If Err.Number = 0 Then
        lstResults.AddItem "Open: " & Dialog1.FileName & " (" & Dialog1.FileTitle & ")"
    Else
        lstResults.AddItem "Open: cancelled"
    End If
End Sub

Private Sub cmdColor_Click()
    On Error Resume Next
    Dialog1.ShowColor
    If Err.Number = 0 Then lstResults.AddItem "Color: &H" & Hex$(Dialog1.Color)
End Sub

Private Sub cmdFont_Click()
    On Error Resume Next
    Dialog1.Flags = 1
    Dialog1.ShowFont
    If Err.Number = 0 Then lstResults.AddItem "Font: " & Dialog1.FontName & ", " & Dialog1.FontSize & " pt"
End Sub
