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
  WebSocketClientUnit;

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
    LabelTotal: TLabel;
    BitBtnRefresh: TBitBtn;
    Memo1: TMemo;
    FlowPanelKiosksStatus: TFlowPanel;
    DBGridEhPendding: TDBGridEh;
    ClientDataSet: TClientDataSet;
    PanelConnectionStatus: TPanel;
    LabelConnectionStatus: TLabel;
    BitBtnConnect: TBitBtn;
    DBGridEhConfirming: TDBGridEh;
    DBGridEhConfirmed: TDBGridEh;
    DBGridEhNotConfirmed: TDBGridEh;
    DBGridEhCancelled: TDBGridEh;
    DBGridEhCompleted: TDBGridEh;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnRefreshClick(Sender: TObject);
    procedure TabPendingShow(Sender: TObject);
    procedure BitBtnConnectClick(Sender: TObject);
    procedure DBGridEhPenddingDblClick(Sender: TObject);
    procedure TabConfirmingShow(Sender: TObject);
    procedure TabCancelledShow(Sender: TObject);
    procedure TabCompletedShow(Sender: TObject);
    procedure TabConfirmedShow(Sender: TObject);
    procedure TabNotConfirmedShow(Sender: TObject);

    procedure SetupClientDataSet;
    procedure CheckConnectionStatus;
    procedure LoadAppointments(Appointments: TObjectList<TAppointment>);
    procedure LoadAppointmentsForSelectedDate;
    procedure FilterAppointmentsByStatus(Status: string);
    procedure SetFormSize;

  private
    { Private declarations }
    procedure HandleKioskListChanged(Sender: TObject);
    procedure HandleVerificationResult(Sender: TObject;
       AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>);
    procedure HandleRecievedMessage(Sender: TObject; const Message: string);
    procedure HandleAppIDAssigned(Sender: TObject);
  public
    { Public declarations }
  end;

var
  CheckInForm: TCheckInForm;

implementation

{$R *.dfm}

uses PatientUnit, DoctorUnit, MainFormUnit, AppointmentsDataAccessUnit, AppointmentsUtils,
      StartVerificationFormUnit, DataModuleUnit;

procedure TCheckInForm.LoadAppointmentsForSelectedDate;
var
  Appointments: TObjectList<TAppointment>;
begin

  Appointments := TAppointmentsDataAccess.GetAppointmentsByDate(DateTimePicker.Date);
  try
    LoadAppointments(Appointments);
    self.LabelTotal.Caption := Format('Total Appointments: %d', [Appointments.Count]);
    self.ClientDataSet.First;
  finally
    Appointments.Free;
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
  AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>);
var
  Detail: TVerificationResultDetail;
  DetailsStr: string;
  Success: Boolean;
  NewStatus: string;
begin
  DetailsStr := '';
  for Detail in Details do
    DetailsStr := DetailsStr + Format('%s: %s', [Detail.Question, BoolToStr(Detail.IsCorrect, True)]) + sLineBreak;


  NewStatus := Result;

  Success := TAppointmentsDataAccess.UpdateAppointmentStatus(AppointmentID, NewStatus);
  if Success then
  begin
    if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
    begin
      ClientDataSet.Edit;
      ClientDataSet.FieldByName('Status').AsString := NewStatus;
      ClientDataSet.Post;
    end;
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

procedure TCheckInForm.TabCancelledShow(Sender: TObject);
begin
  FilterAppointmentsByStatus('Cancelled');
end;

procedure TCheckInForm.TabCompletedShow(Sender: TObject);
begin
  FilterAppointmentsByStatus('Completed');
end;

procedure TCheckInForm.TabConfirmedShow(Sender: TObject);
begin
  FilterAppointmentsByStatus('Confirmed');
end;

procedure TCheckInForm.TabConfirmingShow(Sender: TObject);
begin
  FilterAppointmentsByStatus('Confirming');
end;

procedure TCheckInForm.TabNotConfirmedShow(Sender: TObject);
begin
  FilterAppointmentsByStatus('Not Confirmed');
end;

procedure TCheckInForm.TabPendingShow(Sender: TObject);
begin
  FilterAppointmentsByStatus('Pending');
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

procedure TCheckInForm.FilterAppointmentsByStatus(Status: string);
begin
  ClientDataSet.Filter := Format('Status = ''%s''', [Status]);
  ClientDataSet.Filtered := True;
  ClientDataSet.First;
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

procedure TCheckInForm.DBGridEhPenddingDblClick(Sender: TObject);
var
  AppointmentID: Integer;
  Appointment: TAppointment;
  NewStatus: string;
  Success: Boolean;
begin
  AppointmentID := self.ClientDataSet.FieldByName('AppointmentID').AsInteger;
  if AppointmentID = 0 then
    Exit;
  Appointment := nil;
  Appointment := TAppointmentsDataAccess.GetAppointment(AppointmentID);
  if Appointment.Status <> Pending then
  begin
    ShowMessage('Error: Sttus of this appointment is changed before');
    LoadAppointmentsForSelectedDate;
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
        WebSocketClient.StartVerification(
          Appointment.AppointmentID,
          WebSocketClient.AppID,
          SelectedKiosk,
          Appointment.Patient
        );
        Success := TAppointmentsDataAccess.UpdateAppointmentStatus(AppointmentID, NewStatus);
        if Success then
        begin
          if ClientDataSet.Locate('AppointmentID', AppointmentID, []) then
          begin
            ClientDataSet.Edit;
            ClientDataSet.FieldByName('Status').AsString := NewStatus;
            ClientDataSet.Post;
          end;
        end
        else
          ShowMessage('Error updating appointment status in database.');
      end;
    end;
  finally
    Appointment.Free;
  end;
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

  WebSocketClient := DataModuleMain.GetWebSocketClient;
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
