unit WebSocketClientUnit;

interface

uses
  sgcWebSocket, System.Classes, System.SysUtils, system.JSON, VCL.Dialogs, sgcWebSocket_Classes, System.Generics.Collections,
  PatientUnit;

type
  TKioskInfo = record
    AppID: string;
    Status: string;
  end;
  TVerificationResultDetail = record
    Question: string;
    IsCorrect: Boolean;
  end;
  TOnVerificationDoneEvent = procedure(Sender: TObject; AppointmentID: Integer;
    Result: string; Details: TArray<TVerificationResultDetail>; SuccessStatusUpdate: Boolean) of object;
  TRecievedMessageEvent = procedure(Sender: TObject; const Message: string) of object;

  TWebSocketClient = class
  private
    FWebSocket: TsgcWebSocketClient;
    FAppID: string;
    FKioskList: TList<TKioskInfo>;
    FOnKioskListChanged: TNotifyEvent;
    FOnVerificationDone: TOnVerificationDoneEvent;
    FOnRecievedMessage: TRecievedMessageEvent;
    FOnAppIDAssigned: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnError: TNotifyEvent;

    procedure HandleMessage(Connection: TsgcWSConnection; const Text: string);
    procedure UpdateKioskList(JSONArray: TJSONArray);
    procedure HandleConnect(Connection: TsgcWSConnection);
    procedure HandleDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure HandleError(Connection: TsgcWSConnection; const Error: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect;
    procedure RequestAppID;
    procedure GetActiveKioskApps;
    function StartVerification(AppointmentID: Integer; RequesterAppID: string; TargetAppID: string; PatientData: TPatient): Boolean;

    property AppID: string read FAppID;
    property WebSocket: TsgcWebSocketClient read FWebSocket;
    property KioskList: TList<TKioskInfo> read FKioskList;
    property OnKioskListChanged: TNotifyEvent read FOnKioskListChanged write FOnKioskListChanged;
    property OnVerificationDone: TOnVerificationDoneEvent read FOnVerificationDone write FOnVerificationDone;
    property OnRecievedMessage: TRecievedMessageEvent read FOnRecievedMessage write FOnRecievedMessage;
    property OnAppIDAssigned: TNotifyEvent read FOnAppIDAssigned write FOnAppIDAssigned;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnError: TNotifyEvent read FOnError write FOnError;
    function UpdateAppointmentStatus(AppointmentID: Integer; NewStatus: string): Boolean;
  end;

var
  WebSocketClient: TWebSocketClient;

implementation

{ TWebSocketClient }


uses
  AppointmentsDataAccessUnit;

constructor TWebSocketClient.Create;
begin
  FWebSocket := TsgcWebSocketClient.Create(nil);
  FWebSocket.Host := 'localhost';
  FWebSocket.Port := 8080;
  FWebSocket.Options.Parameters := '/';

  FWebSocket.TLS := false;
  FWebSocket.Specifications.RFC6455 := true;
  FWebSocket.Extensions.PerMessage_Deflate.Enabled := false;

  FWebSocket.OnMessage := HandleMessage;
  FWebSocket.OnConnect := HandleConnect;
  FWebSocket.OnDisconnect := HandleDisconnect;
  FWebSocket.OnError := HandleError;

  FKioskList := TList<TKioskInfo>.Create;
end;

destructor TWebSocketClient.Destroy;
begin
  FWebSocket.Free;
  FKioskList.Free;
  inherited;
end;

procedure TWebSocketClient.Connect;
begin
  FWebSocket.Active := True;
//  if FWebSocket.Active then
//    ShowMessage('Connected to WebSocket server.');
end;

procedure TWebSocketClient.HandleConnect(Connection: TsgcWSConnection);
begin
//  ShowMessage('Connected to WebSocket Server.');
  RequestAppID;
end;

procedure TWebSocketClient.HandleDisconnect(Connection: TsgcWSConnection; Code: Integer);
begin
  //ShowMessage('WebSocket disconnected. Code: ' + Code.ToString);
  FKioskList.Clear;
  FAppID := '';
  if Assigned(FOnAppIDAssigned) then
    FOnAppIDAssigned(Self);

  if Assigned(FOnDisconnect) then
    FOnDisconnect(Self);
end;

procedure TWebSocketClient.HandleError(Connection: TsgcWSConnection; const Error: string);
begin
  ShowMessage('WebSocket error: ' + Error);
  if Assigned(FOnError) then
    FOnError(Self);
end;

function TWebSocketClient.UpdateAppointmentStatus(AppointmentID: Integer; NewStatus: string): Boolean;
begin
  Result := TAppointmentsDataAccess.UpdateAppointmentStatus(AppointmentID, NewStatus);
//  if Result then
//    ShowMessage(Format('Appointment %d status updated to %s', [AppointmentID, NewStatus]))
//  else
//    ShowMessage(Format('Failed to update status for Appointment %d', [AppointmentID]));
end;

procedure TWebSocketClient.RequestAppID;
begin
  if FWebSocket.Active then
    FWebSocket.WriteData('{"type": "request_id", "appType": "delphi"}');
end;

procedure TWebSocketClient.GetActiveKioskApps;
begin
  if FWebSocket.Active then
    FWebSocket.WriteData('{"type": "get_active_kiosk_apps"}');
end;

function TWebSocketClient.StartVerification(AppointmentID: Integer; RequesterAppID: string; TargetAppID: string; PatientData: TPatient): Boolean;
var
  VerificationJSON: TJSONObject;
  PatientJSON: TJSONObject;
  NewStatus: string;
begin
  Result := false;
  if not FWebSocket.Active then
  begin
    raise Exception.Create('WebSocket connection is not active. Cannot send verification request.');
  end;

  VerificationJSON := TJSONObject.Create;
  try
    VerificationJSON.AddPair('type', 'start_verification');
    VerificationJSON.AddPair('appointmentId', TJSONNumber.Create(AppointmentID));
    VerificationJSON.AddPair('requesterAppID', RequesterAppID);
    VerificationJSON.AddPair('targetAppID', TargetAppID);

    PatientJSON := TJSONObject.Create;
    try
      PatientJSON.AddPair('firstName', PatientData.FirstName);
      PatientJSON.AddPair('lastName', PatientData.LastName);
      PatientJSON.AddPair('phoneNumber', PatientData.PhoneNumber);
      PatientJSON.AddPair('address', PatientData.Address);
      PatientJSON.AddPair('dateOfBirth', DateToStr(PatientData.DateOfBirth)); // Format the date as a string

      VerificationJSON.AddPair('patientData', PatientJSON.Clone as TJSONObject);
    finally
      PatientJSON.Free;
    end;

    // Send the JSON message
    FWebSocket.WriteData(VerificationJSON.ToJSON);
    NewStatus := 'Confirming';
    Result := UpdateAppointmentStatus(AppointmentID, NewStatus);
  finally
    VerificationJSON.Free;
  end;
end;

procedure TWebSocketClient.HandleMessage(Connection: TsgcWSConnection; const Text: string);
var
  JSONValue: TJSONValue;
  JSON, DetailJSON: TJSONObject;
  MsgType: string;
  AppointmentID: Integer;
  ResultValue: string;
  ResultDetails: TJSONArray;
  DetailArray: TArray<TVerificationResultDetail>;
  Detail: TVerificationResultDetail;
  I: Integer;
  SuccessStatusUpdate: Boolean;
begin
  JSON := nil;
  try
    JSON := TJSONObject.ParseJSONValue(Text) as TJSONObject;
    if not Assigned(JSON) then
      Exit;

    if Assigned(FOnRecievedMessage) then
      FOnRecievedMessage(Self, Text);

    MsgType := JSON.GetValue<string>('type');
    if MsgType = 'assign_id' then
    begin
      JSONValue := JSON.GetValue('appID');
      if Assigned(JSONValue) then
      begin
        FAppID := JSONValue.Value;
        GetActiveKioskApps;
        if Assigned(FOnAppIDAssigned) then
          FOnAppIDAssigned(Self);
        //        ShowMessage('AppID assigned: ' + FAppID);
      end
      else
        ShowMessage('Error on Requesting ID');
    end
    else if MsgType = 'active_kiosk_apps' then
    begin
      UpdateKioskList(JSON.GetValue<TJSONArray>('apps'));
      if Assigned(FOnKioskListChanged) then
        FOnKioskListChanged(Self);
    end
    else if MsgType = 'verification_result' then
    begin
      AppointmentID := JSON.GetValue<Integer>('appointmentId');
      ResultValue := JSON.GetValue<string>('result');
      ResultDetails := JSON.GetValue<TJSONArray>('resultDetails');
      SetLength(DetailArray, ResultDetails.Count);
      for I := 0 to ResultDetails.Count - 1 do
      begin
        DetailJSON := ResultDetails.Items[I] as TJSONObject;
        Detail.Question := DetailJSON.GetValue<string>('question');
        Detail.IsCorrect := DetailJSON.GetValue<Boolean>('isCorrect');
        DetailArray[I] := Detail;
      end;
      SuccessStatusUpdate := UpdateAppointmentStatus(AppointmentID, ResultValue);
      if Assigned(FOnVerificationDone) then
        FOnVerificationDone(Self, AppointmentID, ResultValue, DetailArray, SuccessStatusUpdate);
    end
    else if MsgType = 'kiosk_list_changed' then
    begin
      GetActiveKioskApps;
    end;
  finally
    JSON.Free;
  end;
end;

procedure TWebSocketClient.UpdateKioskList(JSONArray: TJSONArray);
var
  KioskJSON: TJSONObject;
  KioskInfo: TKioskInfo;
  I: Integer;
begin
  FKioskList.Clear;
  for I := 0 to JSONArray.Count - 1 do
  begin
    KioskJSON := JSONArray.Items[I] as TJSONObject;
    KioskInfo.AppID := KioskJSON.GetValue<string>('appID');
    KioskInfo.Status := KioskJSON.GetValue<string>('status');
    FKioskList.Add(KioskInfo);
  end;
end;

end.

