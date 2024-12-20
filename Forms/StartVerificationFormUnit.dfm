object StartVerificationForm: TStartVerificationForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Start Verification'
  ClientHeight = 144
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  DesignSize = (
    392
    144)
  TextHeight = 15
  object Label1: TLabel
    Left = 11
    Top = 13
    Width = 75
    Height = 15
    Caption = 'Patient Name:'
  end
  object LabelPatientName: TLabel
    Left = 99
    Top = 13
    Width = 102
    Height = 15
    Caption = 'LabelPatientName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 11
    Top = 56
    Width = 78
    Height = 15
    Caption = 'Selected Kiosk:'
  end
  object ComboBoxKioskList: TComboBox
    Left = 99
    Top = 53
    Width = 169
    Height = 23
    TabOrder = 0
  end
  object BitBtnCancel: TBitBtn
    Left = 194
    Top = 109
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
    OnClick = BitBtnCancelClick
  end
  object BitBtnStart: TBitBtn
    Left = 306
    Top = 109
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start'
    Default = True
    NumGlyphs = 2
    TabOrder = 2
    OnClick = BitBtnStartClick
  end
end
