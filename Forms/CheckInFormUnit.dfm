object CheckInForm: TCheckInForm
  Left = 0
  Top = 0
  Caption = 'Patient / Check In'
  ClientHeight = 433
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poMainFormCenter
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
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 98
      Height = 15
      Caption = 'Appointment Date'
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
    object Button1: TButton
      Left = 520
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object PageControlAppointments: TPageControl
    Left = 0
    Top = 41
    Width = 622
    Height = 392
    ActivePage = TabPending
    Align = alClient
    TabOrder = 1
    object TabPending: TTabSheet
      Caption = 'TabPending'
      object StringGridPending: TStringGrid
        Left = 0
        Top = 0
        Width = 614
        Height = 362
        Align = alClient
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        TabOrder = 0
      end
    end
    object TabConfirming: TTabSheet
      Caption = 'TabConfirming'
      ImageIndex = 1
    end
    object TabConfirmed: TTabSheet
      Caption = 'TabConfirmed'
      ImageIndex = 2
    end
    object TabNotConfirmed: TTabSheet
      Caption = 'TabNotConfirmed'
      ImageIndex = 3
    end
    object TabCancelled: TTabSheet
      Caption = 'TabCancelled'
      ImageIndex = 4
    end
    object TabCanceld: TTabSheet
      Caption = 'TabCanceld'
      ImageIndex = 5
    end
  end
end
