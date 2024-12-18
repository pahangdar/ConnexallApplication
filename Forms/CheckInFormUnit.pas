unit CheckInFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  Vcl.Grids, AppointmentUnit, Vcl.Buttons, sgcBase_Classes, sgcSocket_Classes,
  sgcTCP_Classes, sgcWebSocket_Classes, sgcWebSocket_Classes_Indy,
  sgcWebSocket_Client, sgcWebSocket, System.Math;

type
  TCheckInForm = class(TForm)
    PanelOptions: TPanel;
    DateTimePicker: TDateTimePicker;
    Label1: TLabel;
    PageControlAppointments: TPageControl;
    TabPending: TTabSheet;
    TabConfirming: TTabSheet;
    TabConfirmed: TTabSheet;
    TabNotConfirmed: TTabSheet;
    TabCancelled: TTabSheet;
    TabCompleted: TTabSheet;
    StringGridPending: TStringGrid;
    StringGridConfirming: TStringGrid;
    StringGridConfirmed: TStringGrid;
    StringGridNotConfirmed: TStringGrid;
    StringGridCancelled: TStringGrid;
    StringGridComleted: TStringGrid;
    LabelTotal: TLabel;
    BitBtnRefresh: TBitBtn;
    Memo1: TMemo;
    FlowPanelKiosksStatus: TFlowPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PopulateGrids(Appointments: TObjectList<TAppointment>);
    procedure SetupGrid(Grid: TStringGrid);
    procedure BitBtnRefreshClick(Sender: TObject);
    procedure StringGridPendingDblClick(Sender: TObject);
    procedure SetSize;
  private
    { Private declarations }
    procedure HandleKioskListChanged(Sender: TObject);
    procedure HandleVerificationResult(Sender: TObject);
  public
    { Public declarations }
  end;

var
  CheckInForm: TCheckInForm;

implementation

{$R *.dfm}

uses PatientUnit, DoctorUnit, MainFormUnit, AppointmentsDataAccessUnit, AppointmentsUtils, WebSocketClientUnit;

procedure TCheckInForm.HandleKioskListChanged(Sender: TObject);
var
  I: Integer;
  Kiosk: TKioskInfo;
  KioskPanel: TPanel;
  KioskShape: TShape;
  KioskLabel: TLabel;
begin
  //  WebSocketClient.GetActiveKioskApps;
  // Clear existing controls in KioskStatusPanel
  FlowPanelKiosksStatus.DisableAlign;
  try
    for I := FlowPanelKiosksStatus.ControlCount - 1 downto 0 do
      FlowPanelKiosksStatus.Controls[I].Free;

    // Iterate through the list of kiosks and create visual indicators
    for I := 0 to WebSocketClient.KioskList.Count - 1 do
    begin
      Kiosk := WebSocketClient.KioskList[I];

      // Create a panel for each kiosk
      KioskPanel := TPanel.Create(FlowPanelKiosksStatus);
      KioskPanel.Parent := FlowPanelKiosksStatus;
      KioskPanel.Align := alLeft;
      KioskPanel.Width := 150;
      KioskPanel.BevelOuter := bvNone;
      KioskPanel.Caption := '';

      // Create a shape for the status indicator
      KioskShape := TShape.Create(KioskPanel);
      KioskShape.Parent := KioskPanel;
      KioskShape.Shape := stCircle;
      KioskShape.Left := 10;
      KioskShape.Top := 10;
      KioskShape.Width := 20;
      KioskShape.Height := 20;
      KioskShape.Brush.Color := IfThen(Kiosk.Status = 'waiting', clGreen, clRed);
      KioskShape.Pen.Color := clBlack;

      // Create a label for the kiosk ID
      KioskLabel := TLabel.Create(KioskPanel);
      KioskLabel.Parent := KioskPanel;
      KioskLabel.Left := KioskShape.Left + KioskShape.Width + 10;
      KioskLabel.Top := 10;
      KioskLabel.Caption := Kiosk.AppID;
    end;
  finally
    FlowPanelKiosksStatus.EnableAlign;
  end;
end;

procedure TCheckInForm.HandleVerificationResult(Sender: TObject);
begin
  //ShowMessage('Verification is done.');
end;

procedure TCheckInForm.PopulateGrids(Appointments: TObjectList<TAppointment>);
var
  Appointment: TAppointment;
  RowIndex: Integer;

  procedure AddToGrid(Grid: TStringGrid; Appointment: TAppointment);
  begin
    RowIndex := Grid.RowCount ;
    Grid.RowCount := RowIndex + 1;
    Grid.Cells[0, RowIndex] := IntToStr(RowIndex);
    Grid.Cells[1, RowIndex] := FormatDateTime('hh:nn', Appointment.Time);
    Grid.Cells[2, RowIndex] := Appointment.Patient.GetFullName;
    Grid.Cells[3, RowIndex] := Appointment.Doctor.GetFullName;
    Grid.Cells[4, RowIndex] := AppointmentStatusToString(Appointment.Status);
  end;

  procedure AdjustGrid(Grid: TStringGrid; Status: TAppointmentStatus);
  var
    Col, Row: Integer;
    MaxWidth, CellWidth: Integer;
  begin
    for Col := 0 to Grid.ColCount - 1 do
    begin
      MaxWidth := 0;
      for Row := 0 to Grid.RowCount - 1 do
      begin
        CellWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, Row]) + 10;
        if CellWidth > MaxWidth then
          MaxWidth := CellWidth;
      end;
      Grid.ColWidths[Col] := MaxWidth;
    end;

    if Grid.RowCount > 1 then
      Grid.FixedRows :=1;

    if Grid.Parent is TTabSheet then
    begin
      TTabSheet(Grid.Parent).Caption := Format(AppointmentStatusToString(Status) + ' (%d)', [Grid.RowCount - 1]);
    end;
  end;

begin
  self.StringGridPending.RowCount := 1;
  StringGridConfirming.RowCount := 1;
  StringGridConfirmed.RowCount := 1;
  StringGridNotConfirmed.RowCount := 1;
  StringGridCancelled.RowCount := 1;
  StringGridComleted.RowCount := 1;

  for Appointment in Appointments do
  begin
    case Appointment.Status of
      Pending: AddToGrid(self.StringGridPending, Appointment);
      Confirming: AddToGrid(self.StringGridConfirming, Appointment);
      Confirmed: AddToGrid(self.StringGridConfirmed, Appointment);
      NotConfirmed: AddToGrid(self.StringGridNotConfirmed, Appointment);
      Cancelled: AddToGrid(self.StringGridCancelled, Appointment);
      Completed: AddToGrid(self.StringGridComleted, Appointment);
    end;
  end;

  AdjustGrid(self.StringGridPending, Pending);
  AdjustGrid(self.StringGridConfirming, Confirming);
  AdjustGrid(self.StringGridConfirmed, Confirmed);
  AdjustGrid(self.StringGridNotConfirmed, NotConfirmed);
  AdjustGrid(self.StringGridCancelled, Cancelled);
  AdjustGrid(self.StringGridComleted, Completed);
  self.PageControlAppointments.ActivePageIndex := 0;
end;

procedure TCheckInForm.SetupGrid(Grid: TStringGrid);
begin
  Grid.ColCount := 5;
  Grid.Cells[0, 0] := 'Seq#';
  Grid.Cells[1, 0] := 'Time';
  Grid.Cells[2, 0] := 'Patient Name';
  Grid.Cells[3, 0] := 'Doctor Name';
  Grid.Cells[4, 0] := 'Status';
end;

procedure TCheckInForm.StringGridPendingDblClick(Sender: TObject);
begin
  // Send start_verification message
  //  StartVerification(StringGridPending.Row);
  WebSocketClient.StartVerification(101, 'kiosk_1', '{"firstName": "John", "lastName": "Doe"}');
end;

procedure TCheckInForm.BitBtnRefreshClick(Sender: TObject);
begin
  self.DateTimePicker.OnChange(self.DateTimePicker);
end;

procedure TCheckInForm.DateTimePickerChange(Sender: TObject);
var
  Appointments: TObjectList<TAppointment>;
begin
  Appointments := TAppointmentsDataAccess.GetAppointmentsByDate(DateTimePicker.Date);
  try
    PopulateGrids(Appointments);
    self.LabelTotal.Caption := Format('Total Appointments: %d', [Appointments.Count]);
  finally
    Appointments.Free;
  end;
end;

procedure TCheckInForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  CheckInForm := nil;
  MainForm.ToolButtonCheckIn.Enabled := true;
end;

procedure TCheckInForm.FormCreate(Sender: TObject);
begin
  SetupGrid(self.StringGridPending);
  SetupGrid(self.StringGridConfirming);
  SetupGrid(self.StringGridConfirmed);
  SetupGrid(self.StringGridNotConfirmed);
  SetupGrid(self.StringGridCancelled);
  SetupGrid(self.StringGridComleted);

  WebSocketClient := TWebSocketClient.Create;
  WebSocketClient.OnKioskListChanged := HandleKioskListChanged;
  WebSocketClient.OnVerificationDone := HandleVerificationResult;

  WebSocketClient.Connect;
  WebSocketClient.RequestAppID;
  if WebSocketClient.AppID <> '' then
    self.HandleKioskListChanged(nil);
end;

procedure TCheckInForm.SetSize;
begin
  CheckInForm.Height := MainForm.Height - 170;
  CheckInForm.Top := 0;
  CheckInForm.Width := 500;
  CheckInForm.Left := MainForm.Width - CheckInForm.Width - 20;
end;

procedure TCheckInForm.FormShow(Sender: TObject);
begin
  MainForm.ToolButtonCheckIn.Enabled := false;
  self.DateTimePicker.Date := Date;
  if Assigned(self.DateTimePicker.OnChange) then
    self.DateTimePicker.OnChange(DateTimePicker);
end;

end.
