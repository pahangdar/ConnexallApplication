unit CheckInFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.Generics.Collections,
  Vcl.Grids, AppointmentUnit, Vcl.Buttons, sgcBase_Classes, sgcSocket_Classes,
  sgcTCP_Classes, sgcWebSocket_Classes, sgcWebSocket_Classes_Indy,
  sgcWebSocket_Client, sgcWebSocket, System.Math, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Data.DB, Datasnap.DBClient,
  AppointmentsUtils, WebSocketClientUnit, AppointmentTabUnit, Vcl.Menus;

type
  TCheckInForm = class(TForm)
    PanelOptions: TPanel;
    DateTimePicker: TDateTimePicker;
    Label1: TLabel;
    PageControlAppointments: TPageControl;
    LabelTotal: TLabel;
    BitBtnRefresh: TBitBtn;
    Memo1: TMemo;
    FlowPanelKiosksStatus: TFlowPanel;
    ClientDataSet: TClientDataSet;
    PanelConnectionStatus: TPanel;
    LabelConnectionStatus: TLabel;
    BitBtnConnect: TBitBtn;
    PopupMenuAppointment: TPopupMenu;
    miPendingStartVerification: TMenuItem;
    miPendingCancel: TMenuItem;
    miNotConfirmedConfirmed: TMenuItem;
    miConfirmedComplete: TMenuItem;
    miNotConfirmedPending: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnRefreshClick(Sender: TObject);
    procedure BitBtnConnectClick(Sender: TObject);
    procedure miPendingStartVerificationClick(Sender: TObject);

    procedure SetupClientDataSet;
    procedure CheckConnectionStatus;
    procedure LoadAppointments(Appointments: TObjectList<TAppointment>);
    procedure LoadAppointmentsForSelectedDate;
    function  FilterAppointmentsByStatus(const Status: string): Integer;
    procedure SetFormSize;
    procedure InitializeTabs;
    procedure IncrementRecordCount(Status: TAppointmentStatus);
    procedure DecrementRecordCount(Status: TAppointmentStatus);
    procedure miPendingCancelClick(Sender: TObject);
    procedure miNotConfirmedConfirmedClick(Sender: TObject);
    procedure miConfirmedCompleteClick(Sender: TObject);
    procedure miNotConfirmedPendingClick(Sender: TObject);

  private
    { Private declarations }
    FWebSocketClient: TWebSocketClient;
    AppointmentTabs: array[TAppointmentStatus] of TAppointmentTab;
    procedure HandleKioskListChanged(Sender: TObject);
    procedure HandleVerificationResult(Sender: TObject;
       AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>; SuccessStatusUpdate: Boolean);
    procedure HandleRecievedMessage(Sender: TObject; const Message: string);
    procedure HandleAppIDAssigned(Sender: TObject);
  public
    { Public declarations }
    property WebSocketClient: TWebSocketClient read FWebSocketClient write FWebSocketClient;
  end;

var
  CheckInForm: TCheckInForm;

implementation

{$R *.dfm}

uses PatientUnit, DoctorUnit, MainFormUnit, AppointmentsDataAccessUnit,
      StartVerificationFormUnit, DataModuleUnit;

procedure TCheckInForm.IncrementRecordCount(Status: TAppointmentStatus);
begin
  if Assigned(AppointmentTabs[Status]) then
    AppointmentTabs[Status].IncrementRecordCount;
end;

procedure TCheckInForm.DecrementRecordCount(Status: TAppointmentStatus);
begin
  if Assigned(AppointmentTabs[Status]) then
    AppointmentTabs[Status].DecrementRecordCount;
end;

procedure TCheckInForm.InitializeTabs;
var
  Status: TAppointmentStatus;
begin
  for Status := Low(TAppointmentStatus) to High(TAppointmentStatus) do
    AppointmentTabs[Status] := TAppointmentTab.Create(
      Status,
      PageControlAppointments,
      AppointmentStatusToString(Status),
      ClientDataSet,
      FilterAppointmentsByStatus,
      PopupMenuAppointment
    );
end;

procedure TCheckInForm.LoadAppointmentsForSelectedDate;
var
  Appointments: TObjectList<TAppointment>;
  CountByStatus: array[TAppointmentStatus] of Integer;
  Status: TAppointmentStatus;
  Appointment: TAppointment;
begin
  for Status := Low(TAppointmentStatus) to High(TAppointmentStatus) do
    CountByStatus[Status] := 0;

  Appointments := TAppointmentsDataAccess.GetAppointmentsByDate(DateTimePicker.Date);
  try
    for Appointment in Appointments do
      Inc(CountByStatus[Appointment.Status]);

    for Status := Low(TAppointmentStatus) to High(TAppointmentStatus) do
      if Assigned(AppointmentTabs[Status]) then
         AppointmentTabs[Status].RecordCount := CountByStatus[Status];

    LoadAppointments(Appointments);
    self.LabelTotal.Caption := Format('Total Appointments: %d', [Appointments.Count]);
    self.ClientDataSet.First;
  finally
    Appointments.Free;
  end;
end;

procedure TCheckInForm.miConfirmedCompleteClick(Sender: TObject);
var
  AppointmentID: Integer;
begin
  AppointmentID := self.ClientDataSet.FieldByName('AppointmentID').AsInteger;
  if AppointmentID = 0 then
    Exit;

  if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
  begin
    ClientDataSet.Edit;
    ClientDataSet.FieldByName('Status').AsString := 'Completed';
    ClientDataSet.Post;
    DecrementRecordCount(Confirmed);
    IncrementRecordCount(Completed);
  end;
end;

procedure TCheckInForm.miNotConfirmedConfirmedClick(Sender: TObject);
var
  AppointmentID: Integer;
begin
  AppointmentID := self.ClientDataSet.FieldByName('AppointmentID').AsInteger;
  if AppointmentID = 0 then
    Exit;

  if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
  begin
    ClientDataSet.Edit;
    ClientDataSet.FieldByName('Status').AsString := 'Confirmed';
    ClientDataSet.Post;
    DecrementRecordCount(NotConfirmed);
    IncrementRecordCount(Confirmed);
  end;
end;

procedure TCheckInForm.miNotConfirmedPendingClick(Sender: TObject);
var
  AppointmentID: Integer;
begin
  AppointmentID := self.ClientDataSet.FieldByName('AppointmentID').AsInteger;
  if AppointmentID = 0 then
    Exit;

  if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
  begin
    ClientDataSet.Edit;
    ClientDataSet.FieldByName('Status').AsString := 'Pending';
    ClientDataSet.Post;
    DecrementRecordCount(NotConfirmed);
    IncrementRecordCount(Pending);
  end;
end;

procedure TCheckInForm.miPendingCancelClick(Sender: TObject);
var
  AppointmentID: Integer;
begin
  AppointmentID := self.ClientDataSet.FieldByName('AppointmentID').AsInteger;
  if AppointmentID = 0 then
    Exit;

  if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
  begin
    ClientDataSet.Edit;
    ClientDataSet.FieldByName('Status').AsString := 'Cancelled';
    ClientDataSet.Post;
    DecrementRecordCount(Pending);
    IncrementRecordCount(Cancelled);
  end;
end;

procedure TCheckInForm.miPendingStartVerificationClick(Sender: TObject);
var
  AppointmentID: Integer;
  Appointment: TAppointment;
  NewStatus: string;
  Success: Boolean;
begin
  if WebSocketClient.AppID = '' then
  begin
    ShowMessage('Error, Connection to Server is not ready!');
    exit;
  end;

  AppointmentID := self.ClientDataSet.FieldByName('AppointmentID').AsInteger;
  if AppointmentID = 0 then
    Exit;

  Appointment := nil;
  Appointment := TAppointmentsDataAccess.GetAppointment(AppointmentID);
  if Appointment.Status <> Pending then
  begin
    ShowMessage('Error: Sttus of this appointment is changed before');
    LoadAppointmentsForSelectedDate;
    Appointment.Free;
    exit;
  end;

  NewStatus := 'Confirming';
  try
    // Show kiosk selection form
    with StartVerificationForm do
    begin
      LabelPatientName.Caption := Appointment.Patient.GetFullName;
      PopulateKioskList(WebSocketClient.KioskList);
      ShowModal;
      if Confirmed and (SelectedKiosk <> '') then
      begin
        Success := WebSocketClient.StartVerification(
          Appointment.AppointmentID,
          WebSocketClient.AppID,
          SelectedKiosk,
          Appointment.Patient
        );
        if Success then
        begin
          if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
          begin
            ClientDataSet.Edit;
            ClientDataSet.FieldByName('Status').AsString := NewStatus;
            ClientDataSet.Post;
          end;

          DecrementRecordCount(Pending);
          IncrementRecordCount(Confirming);
        end
        else
          ShowMessage('Error updating appointment status in database.');
      end;
    end;
  finally
    Appointment.Free;
  end;
end;

procedure TCheckInForm.HandleKioskListChanged(Sender: TObject);
var
  I: Integer;
  Kiosk: TKioskInfo;
  KioskPanel: TPanel;
  KioskShape: TShape;
  KioskLabel: TLabel;
begin
  FlowPanelKiosksStatus.DisableAlign;
  try
    for I := FlowPanelKiosksStatus.ControlCount - 1 downto 1 do
      FlowPanelKiosksStatus.Controls[I].Free;

    for I := 0 to WebSocketClient.KioskList.Count - 1 do
    begin
      Kiosk := WebSocketClient.KioskList[I];
      KioskPanel := TPanel.Create(FlowPanelKiosksStatus);
      KioskPanel.Parent := FlowPanelKiosksStatus;
      KioskPanel.Align := alLeft;
      KioskPanel.Width := 120;
      KioskPanel.BevelOuter := bvNone;
      KioskPanel.Caption := '';
      KioskShape := TShape.Create(KioskPanel);
      KioskShape.Parent := KioskPanel;
      KioskShape.Shape := stCircle;
      KioskShape.Left := 10;
      KioskShape.Top := 10;
      KioskShape.Width := 20;
      KioskShape.Height := 20;
      KioskShape.Brush.Color := IfThen(Kiosk.Status = 'waiting', clGreen, clRed);
      KioskShape.Pen.Color := clBlack;
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

procedure TCheckInForm.HandleVerificationResult(Sender: TObject;
  AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>; SuccessStatusUpdate: Boolean);
var
  Detail: TVerificationResultDetail;
  DetailsStr: string;
  ResultStatus: TAppointmentStatus;
begin
  DetailsStr := '';
  for Detail in Details do
    DetailsStr := DetailsStr + Format('%s: %s', [Detail.Question, BoolToStr(Detail.IsCorrect, True)]) + sLineBreak;

  if SuccessStatusUpdate then
  begin
    ClientDataSet.Filtered := false;
    if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
    begin
      ClientDataSet.Edit;
      ClientDataSet.FieldByName('Status').AsString := Result;
      ClientDataSet.Post;
    end;
    ClientDataSet.Filtered := true;
    if Result = 'Confirmed' then
       ResultStatus := Confirmed
    else
      ResultStatus := NotConfirmed;

    DecrementRecordCount(Confirming);
    IncrementRecordCount(ResultStatus);
  end
  else
    ShowMessage('Error updating appointment status in database.');



//  ShowMessage(Format('Verification Result for Appointment %d: %s', [AppointmentID, Result]) + sLineBreak +
//    'Details:' + sLineBreak + DetailsStr);
end;

procedure TCheckInForm.HandleRecievedMessage(Sender: TObject; const Message: string);
begin
  Memo1.Lines.Add(Message);
end;

procedure TCheckInForm.HandleAppIDAssigned(Sender: TObject);
begin
  HandleKioskListChanged(nil); // Initial update of kiosk list
  CheckConnectionStatus;
end;

procedure TCheckInForm.BitBtnConnectClick(Sender: TObject);
begin
  if not WebSocketClient.WebSocket.Active then
    WebSocketClient.Connect
  else
    WebSocketClient.RequestAppID;

  CheckConnectionStatus;
end;

procedure TCheckInForm.BitBtnRefreshClick(Sender: TObject);
begin
  LoadAppointmentsForSelectedDate;
end;

function TCheckInForm.FilterAppointmentsByStatus(const Status: string): Integer;
begin
  ClientDataSet.Filter := Format('Status = ''%s''', [Status]);
  ClientDataSet.Filtered := True;
  ClientDataSet.First;
  Result := ClientDataSet.RecordCount;
end;

procedure TCheckInForm.LoadAppointments(Appointments: TObjectList<TAppointment>);
var
  Appointment: TAppointment;
begin
  // Ensure dataset is ready
  if not ClientDataSet.Active then
    SetupClientDataSet;

  // Add records to the ClientDataSet
  ClientDataSet.DisableControls;
  try
    ClientDataSet.EmptyDataSet;
    for Appointment in Appointments do
    begin
      ClientDataSet.Append;
      ClientDataSet.FieldByName('AppointmentID').AsInteger := Appointment.AppointmentID;
      ClientDataSet.FieldByName('Date').AsDateTime := Appointment.Date;
      ClientDataSet.FieldByName('Time').AsDateTime := Appointment.Time;
      ClientDataSet.FieldByName('Status').AsString := AppointmentStatusToString(Appointment.Status);
      ClientDataSet.FieldByName('PatientName').AsString := Appointment.Patient.GetFullName;
      ClientDataSet.FieldByName('DoctorName').AsString := Appointment.Doctor.GetFullName;
      ClientDataSet.FieldByName('PhoneNumber').AsString := Appointment.Patient.PhoneNumber;
      ClientDataSet.FieldByName('Address').AsString := Appointment.Patient.Address;
      ClientDataSet.Post;
    end;
  finally
    ClientDataSet.EnableControls;
  end;
end;

procedure TCheckInForm.DateTimePickerChange(Sender: TObject);
begin
  LoadAppointmentsForSelectedDate;
end;

procedure TCheckInForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WebSocketClient.OnKioskListChanged := nil;
  WebSocketClient.OnVerificationDone := nil;
  WebSocketClient.OnRecievedMessage := nil;
  WebSocketClient.OnAppIDAssigned := nil;
  Action := caFree;
  CheckInForm := nil;
  MainForm.ToolButtonCheckIn.Enabled := true;
end;

procedure TCheckInForm.SetupClientDataSet;
begin
  ClientDataSet.Close;
  ClientDataSet.FieldDefs.Clear;

  // Define fields based on the TAppointment structure
  ClientDataSet.FieldDefs.Add('AppointmentID', ftInteger);
  ClientDataSet.FieldDefs.Add('Date', ftDate);
  ClientDataSet.FieldDefs.Add('Time', ftTime);
  ClientDataSet.FieldDefs.Add('Status', ftString, 50);
  ClientDataSet.FieldDefs.Add('PatientName', ftString, 100);
  ClientDataSet.FieldDefs.Add('DoctorName', ftString, 100);
  ClientDataSet.FieldDefs.Add('PhoneNumber', ftString, 50);
  ClientDataSet.FieldDefs.Add('Address', ftString, 150);
  ClientDataSet.FieldDefs.Add('VerificationResult', ftString, 450);

  // Create the dataset
  ClientDataSet.CreateDataSet;
end;

procedure TCheckInForm.CheckConnectionStatus;
begin
  if not WebSocketClient.WebSocket.Active then
  begin
    self.LabelConnectionStatus.Caption := 'Not Connected';
    self.BitBtnConnect.Visible := true;
    ShowMessage('Error on Connecting to Kiosks'' Server');
  end
  else
    if WebSocketClient.AppID = '' then
    begin
      self.LabelConnectionStatus.Caption := 'Not Registerd';
      self.BitBtnConnect.Visible := true;
    end
    else
    begin
      self.LabelConnectionStatus.Caption := 'Connected as: ' + WebSocketClient.AppID;
      self.BitBtnConnect.Visible := false;
    end;
end;

procedure TCheckInForm.FormCreate(Sender: TObject);
begin
  SetupClientDataSet;
  InitializeTabs;

  FWebSocketClient := DataModuleMain.GetWebSocketClient;
  WebSocketClient.OnKioskListChanged := HandleKioskListChanged;
  WebSocketClient.OnVerificationDone := HandleVerificationResult;
  WebSocketClient.OnRecievedMessage := HandleRecievedMessage;
  WebSocketClient.OnAppIDAssigned := HandleAppIDAssigned;

  WebSocketClient.Connect;
  if WebSocketClient.AppID <> '' then
    HandleKioskListChanged(nil);
  CheckConnectionStatus;
end;

procedure TCheckInForm.SetFormSize;
begin
  CheckInForm.Width := 800;
  CheckInForm.Height := MainForm.Height - 170;
  CheckInForm.Top := 0;
  CheckInForm.Left := MainForm.Width - CheckInForm.Width - 20;
end;

procedure TCheckInForm.FormShow(Sender: TObject);
begin
  MainForm.ToolButtonCheckIn.Enabled := false;
  self.DateTimePicker.Date := Date;

  LoadAppointmentsForSelectedDate;

  self.PageControlAppointments.ActivePageIndex := 0;
end;

end.
