Attribute VB_Name = "modTheme"
Option Explicit
'
' The look of the WFC games: a dark navy background, raised panels, light text
' and a teal accent. Colors are VB values (&HBBGGRR).
'
' A trimmed copy of tests/vb6games/ui/modTheme.bas of WFC (ThemeApply and
' ThemeCard only), so this example looks like the games do.
'
Public Const ThBack As Long = &H1F1411     ' window background
Public Const ThPanel As Long = &H33201B    ' raised surface
Public Const ThPanel2 As Long = &H452B25   ' buttons and inputs
Public Const ThLine As Long = &H5C3C35     ' borders
Public Const ThText As Long = &HF5EBE8     ' text
Public Const ThMuted As Long = &HBEA098    ' secondary text
Public Const ThAccent As Long = &HC6D63D   ' teal
Public Const ThAccent2 As Long = &H54B4FF  ' amber
Public Const ThGood As Long = &H8DD35F
Public Const ThBad As Long = &H816BFF
Public Const ThP1 As Long = &H4DD3FF       ' player one: yellow
Public Const ThP2 As Long = &H7A5CFF       ' player two: coral
Public Const ThBoard As Long = &H8F3E2D    ' game board blue
Public Const ThShadow1 As Long = &H0F0A08  ' near shadow
Public Const ThShadow2 As Long = &H17100D  ' far shadow
Public Const ThEdge As Long = &H6B4A40     ' light edge of a raised panel
Public Const ThFontSize As Single = 11      ' text size in points
Public Const ThFontName As String = "Segoe UI"  ' scalable, unlike MS Sans Serif

' Colors a form and its controls. A control whose Tag is "keep" is left alone
' (game boards, pictures); one whose Tag is "accent" is a highlighted button.
' Push buttons need Style = 1 (Graphical) in the form to take BackColor.
Public Sub ThemeApply(frm As Form)
    Dim c As Control
    frm.BackColor = ThBack
    On Error Resume Next
    For Each c In frm.Controls
        If c.Tag <> "keep" Then
            Select Case TypeName(c)
            Case "Label"
                c.ForeColor = ThText
                c.BackColor = ThBack
                c.BackStyle = 1
                c.Font.Name = ThFontName
                c.Font.Size = ThFontSize
                ' an auto-sized label grows to its new font
                If c.AutoSize Then
                    c.AutoSize = False
                    c.AutoSize = True
                    c.Caption = c.Caption
                End If
            Case "CommandButton"
                ' A VB6 push button has no ForeColor, so its text stays dark
                ' and the buttons are light (teal; amber when tagged accent).
                If c.Tag = "accent" Then
                    c.BackColor = ThAccent2
                Else
                    c.BackColor = ThAccent
                End If
                c.Font.Name = ThFontName
                c.Font.Size = ThFontSize
                c.Font.Bold = True
            Case "TextBox", "ComboBox", "ListBox"
                c.ForeColor = ThText
                c.BackColor = ThPanel2
                c.Font.Name = ThFontName
                c.Font.Size = ThFontSize
            Case "Frame", "CheckBox", "OptionButton"
                c.ForeColor = ThText
                c.BackColor = ThBack
                c.BackStyle = 1
                c.Font.Name = ThFontName
                c.Font.Size = ThFontSize
            End Select
        End If
    Next c
End Sub

' A raised panel with a thin border and a two-step shadow. The three shapes
' sit at the back of the form (shadows last); u is the size of one pixel in
' the form's own units (1 for pixel forms, 15 for twips).
Public Sub ThemeCard(card As Object, shadowA As Object, shadowB As Object, ByVal L As Single, ByVal T As Single, ByVal W As Single, ByVal H As Single, ByVal u As Single)
    shadowB.Left = L + 7 * u
    shadowB.Top = T + 9 * u
    shadowB.Width = W
    shadowB.Height = H
    shadowB.FillStyle = 0
    shadowB.FillColor = ThShadow2
    shadowB.BorderStyle = 0
    shadowA.Left = L + 3 * u
    shadowA.Top = T + 4 * u
    shadowA.Width = W
    shadowA.Height = H
    shadowA.FillStyle = 0
    shadowA.FillColor = ThShadow1
    shadowA.BorderStyle = 0
    card.Left = L
    card.Top = T
    card.Width = W
    card.Height = H
    card.FillStyle = 0
    card.FillColor = ThPanel
    card.BorderColor = ThEdge
    card.BorderWidth = 1
End Sub
