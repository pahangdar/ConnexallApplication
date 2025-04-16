object ChatBubbleFrame: TChatBubbleFrame
  Left = 0
  Top = 0
  Width = 430
  Height = 42
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  Align = alBottom
  AutoSize = True
  TabOrder = 0
  object PanelBubble: TPanel
    Left = 0
    Top = 0
    Width = 209
    Height = 42
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    TabOrder = 0
    object ShapeBorder: TShape
      Left = 10
      Top = 10
      Width = 189
      Height = 22
      Align = alClient
      Brush.Color = clSkyBlue
      Shape = stRoundRect
      ExplicitLeft = 200
      ExplicitTop = 16
      ExplicitWidth = 65
      ExplicitHeight = 65
    end
    object LabelMessage: TLabel
      Left = 11
      Top = 11
      Width = 200
      Height = 20
      AutoSize = False
      Caption = 'LabelMessage'
      WordWrap = True
    end
  end
end
