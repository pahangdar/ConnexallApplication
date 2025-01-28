object CheckInForm: TCheckInForm
  Left = 0
  Top = 0
  Caption = 'Patient / Check In'
  ClientHeight = 692
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object PanelOptions: TPanel
    Left = 0
    Top = 0
    Width = 582
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      582
      41)
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 98
      Height = 15
      Caption = 'Appointment Date'
    end
    object LabelTotal: TLabel
      Left = 433
      Top = 13
      Width = 122
      Height = 15
      Anchors = [akTop, akRight]
      Caption = 'Total Appointments: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 473
    end
    object DateTimePicker: TDateTimePicker
      Left = 124
      Top = 8
      Width = 186
      Height = 23
      Date = 45639.000000000000000000
      Time = 0.429474560187372800
      TabOrder = 0
      OnChange = DateTimePickerChange
    end
    object BitBtnRefresh: TBitBtn
      Left = 316
      Top = 7
      Width = 77
      Height = 25
      Hint = 'Refresh Appointments'
      Caption = 'Refresh'
      Kind = bkRetry
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BitBtnRefreshClick
    end
  end
  object PageControlAppointments: TPageControl
    Left = 0
    Top = 41
    Width = 582
    Height = 395
    Align = alClient
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 479
    Width = 582
    Height = 213
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    Visible = False
  end
  object FlowPanelKiosksStatus: TFlowPanel
    Left = 0
    Top = 436
    Width = 582
    Height = 43
    Align = alBottom
    AutoSize = True
    Constraints.MinHeight = 41
    TabOrder = 3
    object PanelConnectionStatus: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 41
      BevelOuter = bvLowered
      TabOrder = 0
      object LabelConnectionStatus: TLabel
        Left = 10
        Top = 12
        Width = 32
        Height = 15
        Caption = 'Status'
      end
      object BitBtnConnect: TBitBtn
        Left = 104
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Connect'
        Kind = bkRetry
        NumGlyphs = 2
        TabOrder = 0
        OnClick = BitBtnConnectClick
      end
    end
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 363
    Top = 158
  end
  object PopupMenuAppointment: TPopupMenu
    Left = 432
    Top = 312
    object miPendingStartVerification: TMenuItem
      Caption = 'Start Verification'
      OnClick = miPendingStartVerificationClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miPendingCancel: TMenuItem
      Caption = 'Cancel'
      OnClick = miPendingCancelClick
    end
    object miNotConfirmedConfirmed: TMenuItem
      Caption = 'Confirmed'
      OnClick = miNotConfirmedConfirmedClick
    end
    object miConfirmedComplete: TMenuItem
      Caption = 'Complete'
      OnClick = miConfirmedCompleteClick
    end
    object miNotConfirmedPending: TMenuItem
      Caption = 'Pending'
      OnClick = miNotConfirmedPendingClick
    end
  end
end
