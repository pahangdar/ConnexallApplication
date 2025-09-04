object NotificationForm: TNotificationForm
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'NotificationForm'
  ClientHeight = 154
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  TextHeight = 15
  object LabelMessage: TLabel
    Left = 24
    Top = 16
    Width = 74
    Height = 15
    Caption = 'LabelMessage'
    WordWrap = True
  end
  object TimerClose: TTimer
    Interval = 3000
    OnTimer = TimerCloseTimer
    Left = 208
    Top = 32
  end
  object TimerFadeOut: TTimer
    OnTimer = TimerFadeOutTimer
    Left = 360
    Top = 54
  end
end
