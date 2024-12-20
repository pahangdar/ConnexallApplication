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
    ActivePage = TabPending
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 651
    object TabPending: TTabSheet
      Caption = 'Pending'
      OnShow = TabPendingShow
      object DBGridEhPendding: TDBGridEh
        Left = 0
        Top = 0
        Width = 574
        Height = 365
        Align = alClient
        DataSource = ClientDataSet
        DynProps = <>
        EvenRowColor = cl3DLight
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
        SearchPanel.Enabled = True
        TabOrder = 0
        OnDblClick = DBGridEhPenddingDblClick
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Time'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PatientName'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'DoctorName'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Status'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PhoneNumber'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'AppointmentID'
            Footers = <>
            Title.Caption = 'Apmt ID'
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'VerificationResult'
            Footers = <>
            Title.Caption = 'Verification Result'
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabConfirming: TTabSheet
      Caption = 'Confirming'
      ImageIndex = 1
      OnShow = TabConfirmingShow
      object DBGridEhConfirming: TDBGridEh
        Left = 0
        Top = 0
        Width = 574
        Height = 365
        Align = alClient
        DataSource = ClientDataSet
        DynProps = <>
        EvenRowColor = cl3DLight
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
        SearchPanel.Enabled = True
        TabOrder = 0
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Time'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PatientName'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'DoctorName'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Status'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PhoneNumber'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'AppointmentID'
            Footers = <>
            Title.Caption = 'Apmt ID'
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'VerificationResult'
            Footers = <>
            Title.Caption = 'Verification Result'
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabConfirmed: TTabSheet
      Caption = 'Confirmed'
      ImageIndex = 2
      OnShow = TabConfirmedShow
      object DBGridEhConfirmed: TDBGridEh
        Left = 0
        Top = 0
        Width = 574
        Height = 365
        Align = alClient
        DataSource = ClientDataSet
        DynProps = <>
        EvenRowColor = cl3DLight
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
        SearchPanel.Enabled = True
        TabOrder = 0
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Time'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PatientName'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'DoctorName'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Status'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PhoneNumber'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'AppointmentID'
            Footers = <>
            Title.Caption = 'Apmt ID'
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'VerificationResult'
            Footers = <>
            Title.Caption = 'Verification Result'
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabNotConfirmed: TTabSheet
      Caption = 'Not Confirmed'
      ImageIndex = 3
      OnShow = TabNotConfirmedShow
      object DBGridEhNotConfirmed: TDBGridEh
        Left = 0
        Top = 0
        Width = 574
        Height = 365
        Align = alClient
        DataSource = ClientDataSet
        DynProps = <>
        EvenRowColor = cl3DLight
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
        SearchPanel.Enabled = True
        TabOrder = 0
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Time'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PatientName'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'DoctorName'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Status'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PhoneNumber'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'AppointmentID'
            Footers = <>
            Title.Caption = 'Apmt ID'
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'VerificationResult'
            Footers = <>
            Title.Caption = 'Verification Result'
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabCancelled: TTabSheet
      Caption = 'Cancelled'
      ImageIndex = 4
      OnShow = TabCancelledShow
      object DBGridEhCancelled: TDBGridEh
        Left = 0
        Top = 0
        Width = 574
        Height = 365
        Align = alClient
        DataSource = ClientDataSet
        DynProps = <>
        EvenRowColor = cl3DLight
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
        SearchPanel.Enabled = True
        TabOrder = 0
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Time'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PatientName'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'DoctorName'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Status'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PhoneNumber'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'AppointmentID'
            Footers = <>
            Title.Caption = 'Apmt ID'
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'VerificationResult'
            Footers = <>
            Title.Caption = 'Verification Result'
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabCompleted: TTabSheet
      Caption = 'Completed'
      ImageIndex = 5
      OnShow = TabCompletedShow
      object DBGridEhCompleted: TDBGridEh
        Left = 0
        Top = 0
        Width = 574
        Height = 365
        Align = alClient
        DataSource = ClientDataSet
        DynProps = <>
        EvenRowColor = cl3DLight
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghExtendVertLines]
        SearchPanel.Enabled = True
        TabOrder = 0
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Time'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PatientName'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'DoctorName'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Status'
            Footers = <>
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'PhoneNumber'
            Footers = <>
            Width = 100
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Address'
            Footers = <>
            Width = 150
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'AppointmentID'
            Footers = <>
            Title.Caption = 'Apmt ID'
            Width = 60
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'VerificationResult'
            Footers = <>
            Title.Caption = 'Verification Result'
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
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
    ExplicitTop = 408
    ExplicitWidth = 574
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
    ExplicitWidth = 574
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
end
