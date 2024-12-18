object CheckInForm: TCheckInForm
  Left = 0
  Top = 0
  Caption = 'Patient / Check In'
  ClientHeight = 692
  ClientWidth = 622
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
    Width = 622
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      622
      41)
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 98
      Height = 15
      Caption = 'Appointment Date'
    end
    object LabelTotal: TLabel
      Left = 473
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
    Width = 622
    Height = 651
    ActivePage = TabPending
    Align = alClient
    TabOrder = 1
    object TabPending: TTabSheet
      Caption = 'Pending'
      object StringGridPending: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 207
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
        OnDblClick = StringGridPendingDblClick
        ExplicitHeight = 248
      end
      object Memo1: TMemo
        Left = 0
        Top = 248
        Width = 614
        Height = 373
        Align = alBottom
        Lines.Strings = (
          'Memo1')
        TabOrder = 1
      end
      object FlowPanelKiosksStatus: TFlowPanel
        Left = 0
        Top = 207
        Width = 614
        Height = 41
        Align = alBottom
        AutoSize = True
        TabOrder = 2
        ExplicitLeft = 360
        ExplicitTop = 136
        ExplicitWidth = 185
      end
    end
    object TabConfirming: TTabSheet
      Caption = 'Confirming'
      ImageIndex = 1
      object StringGridConfirming: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 621
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
      end
    end
    object TabConfirmed: TTabSheet
      Caption = 'Confirmed'
      ImageIndex = 2
      object StringGridConfirmed: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 621
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
      end
    end
    object TabNotConfirmed: TTabSheet
      Caption = 'Not Confirmed'
      ImageIndex = 3
      object StringGridNotConfirmed: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 621
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
      end
    end
    object TabCancelled: TTabSheet
      Caption = 'Cancelled'
      ImageIndex = 4
      object StringGridCancelled: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 621
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
      end
    end
    object TabCompleted: TTabSheet
      Caption = 'Completed'
      ImageIndex = 5
      object StringGridComleted: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 621
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
      end
    end
  end
end
