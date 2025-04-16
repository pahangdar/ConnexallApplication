object AIChatForm: TAIChatForm
  Left = 0
  Top = 0
  Caption = 'AI Chat'
  ClientHeight = 433
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object PanelChat: TPanel
    Left = 0
    Top = 328
    Width = 622
    Height = 105
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object PanelButton: TPanel
      Left = 512
      Top = 0
      Width = 110
      Height = 105
      Align = alRight
      TabOrder = 0
      object BtnAskAI: TBitBtn
        Left = 16
        Top = 32
        Width = 75
        Height = 25
        Caption = '&Send'
        Kind = bkRetry
        NumGlyphs = 2
        TabOrder = 0
        OnClick = BtnAskAIClick
      end
    end
    object MemoInput: TMemo
      Left = 0
      Top = 0
      Width = 512
      Height = 105
      Align = alClient
      Lines.Strings = (
        'count appointmanes base on their Status')
      TabOrder = 1
    end
  end
  object PageControlResults: TPageControl
    Left = 0
    Top = 0
    Width = 622
    Height = 328
    ActivePage = TabSheetResult
    Align = alClient
    TabOrder = 1
    object TabSheetChat: TTabSheet
      Caption = 'Chat'
      object ScrollBoxChat: TScrollBox
        Left = 0
        Top = 0
        Width = 614
        Height = 298
        VertScrollBar.Tracking = True
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object TabSheetSQL: TTabSheet
      Caption = 'SQL'
      ImageIndex = 1
      object MemoSQL: TMemo
        Left = 0
        Top = 0
        Width = 614
        Height = 298
        Align = alClient
        ReadOnly = True
        TabOrder = 0
      end
    end
    object TabSheetResult: TTabSheet
      Caption = 'Results'
      ImageIndex = 2
      object StringGridResults: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 298
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        TabOrder = 0
      end
    end
  end
end
