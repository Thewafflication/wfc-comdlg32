VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmDialogs
   BackColor       =   &H001F1411&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Common Dialog"
   ClientHeight    =   4860
   ClientWidth     =   7920
   StartUpPosition =   2  'CenterScreen
   Begin VB.Shape shpCard
      Height          =   300
      Left            =   0
      Top             =   0
      Width           =   300
   End
   Begin VB.Shape shpCardS1
      Height          =   300
      Left            =   0
      Top             =   0
      Width           =   300
   End
   Begin VB.Shape shpCardS2
      Height          =   300
      Left            =   0
      Top             =   0
      Width           =   300
   End
   Begin MSComDlg.CommonDialog Dialog1
      Left            =   7320
      Top             =   120
   End
   Begin VB.Label lblTitle
      BackStyle       =   0  'Transparent
      Caption         =   "Common Dialog"
      BeginProperty Font
         Name            =   "Segoe UI Semibold"
         Size            =   18
         Charset         =   0
         Weight          =   600
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00F5EBE8&
      Height          =   560
      Left            =   360
      Top             =   240
      Width           =   7200
   End
   Begin VB.Label lblHint
      Caption         =   "Choose a dialog. Each result is listed below."
      Height          =   300
      Left            =   360
      Top             =   840
      Width           =   7200
   End
   Begin VB.CommandButton cmdOpen
      Caption         =   "Open..."
      Height          =   495
      Left            =   360
      Style           =   1  'Graphical
      Top             =   1380
      Width           =   1500
   End
   Begin VB.CommandButton cmdColor
      Caption         =   "Color..."
      Height          =   495
      Left            =   1980
      Style           =   1  'Graphical
      Top             =   1380
      Width           =   1500
   End
   Begin VB.CommandButton cmdFont
      Caption         =   "Font..."
      Height          =   495
      Left            =   3600
      Style           =   1  'Graphical
      Top             =   1380
      Width           =   1500
   End
   Begin VB.Shape shpSwatch
      BorderColor     =   &H006B4A40&
      FillColor       =   &H00C6D63D&
      FillStyle       =   0  'Solid
      Height          =   495
      Left            =   7020
      Top             =   1380
      Width           =   540
   End
   Begin VB.Label lblResults
      BackStyle       =   0  'Transparent
      Height          =   1980
      Left            =   600
      Top             =   2300
      Width           =   6720
   End
End
Attribute VB_Name = "frmDialogs"
Option Explicit

Private mResults As String

' Adds a line to the results; the card shows the last eight.
Private Sub Report(ByVal text As String)
    Dim lines() As String, first As Long, i As Long, shown As String
    If mResults <> "" Then mResults = mResults & vbLf
    mResults = mResults & text
    lines = Split(mResults, vbLf)
    first = UBound(lines) - 7
    If first < 0 Then first = 0
    For i = first To UBound(lines)
        If shown <> "" Then shown = shown & vbCrLf
        shown = shown & lines(i)
    Next i
    mResults = Join(lines, vbLf)
    lblResults.Caption = shown
End Sub

Private Sub Form_Load()
    ThemeApply Me
    ThemeCard shpCard, shpCardS1, shpCardS2, 360, 2120, 7200, 2300, 15
    lblTitle.Font.Name = "Segoe UI Semibold"
    lblTitle.Font.Size = 18
    lblHint.Font.Size = 10
    lblHint.ForeColor = ThMuted
    lblResults.Font.Size = 10
    lblResults.BackStyle = 0
    shpSwatch.FillColor = ThAccent
    Dialog1.CancelError = True
    Dialog1.Filter = "Text (*.txt)|*.txt|All files|*.*"
    Report "Open...   choose a text file; its name is listed here."
    Report "Color...  choose a color; the swatch takes it."
    Report "Font...   choose a font; its name and size are listed."
End Sub

Private Sub cmdOpen_Click()
    On Error Resume Next
    Dialog1.ShowOpen
    If Err.Number = 0 Then
        Report "Open: " & Dialog1.FileName & " (" & Dialog1.FileTitle & ")"
    Else
        Report "Open: cancelled"
    End If
End Sub

Private Sub cmdColor_Click()
    On Error Resume Next
    Dialog1.ShowColor
    If Err.Number = 0 Then
        shpSwatch.FillColor = Dialog1.Color
        Report "Color: &H" & Hex$(Dialog1.Color)
    Else
        Report "Color: cancelled"
    End If
End Sub

Private Sub cmdFont_Click()
    On Error Resume Next
    Dialog1.Flags = 1
    Dialog1.ShowFont
    If Err.Number = 0 Then
        Report "Font: " & Dialog1.FontName & ", " & Dialog1.FontSize & " pt"
    Else
        Report "Font: cancelled"
    End If
End Sub
