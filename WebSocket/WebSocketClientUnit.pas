unit WebSocketClientUnit;

interface
uses
  System.Classes, System.SysUtils, system.JSON, VCL.Dialogs, System.Generics.Collections,
  sgcWebSocket, sgcWebSocket_Classes, System.IniFiles, System.DateUtils,
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

  TOnVerificationDoneEvent = procedure(Sender: TObject;
    AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>) of object;

  TRecievedMessageEvent = procedure(Sender: TObject; const Message: string) of object;
  TOnTableUpdatedEvent = procedure(Sender: TObject; const TableName: string; WorkingDate: TDateTime) of object;

  TWebSocketClient = class
  private
    FWebSocket: TsgcWebSocketClient;
    FAppID: string;
    FKioskList: TList<TKioskInfo>;
    FWorkingDate: TDateTime;
    FOnKioskListChanged: TNotifyEvent;
    FOnVerificationDone: TOnVerificationDoneEvent;
    FOnRecievedMessage: TRecievedMessageEvent;
    FOnTableUpdated: TOnTableUpdatedEvent;
    FOnAppIDAssigned: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnError: TNotifyEvent;
    class var FInstance: TWebSocketClient;
    class function GetInstance: TWebSocketClient; static;
    procedure SetWorkingDate(const Value: TDateTime);
    procedure HandleMessage(Connection: TsgcWSConnection; const Text: string);
    procedure UpdateKioskList(JSONArray: TJSONArray);
    procedure HandleConnect(Connection: TsgcWSConnection);
    procedure HandleDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure HandleError(Connection: TsgcWSConnection; const Error: string);
    procedure Initialize;
    procedure UpdateWorkingDate(AWorkingDate: TDateTime = 0);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    function IsConnected: Boolean;
    procedure RequestAppID;
    procedure GetActiveKioskApps;
    function StartVerification(AppointmentID: Integer; RequesterAppID: string; TargetAppID: string; PatientData: TPatient): Boolean;
    procedure NotifyTableChange(ATableName: string);
    class property Instance: TWebSocketClient read GetInstance;
    property AppID: string read FAppID;
    property WebSocket: TsgcWebSocketClient read FWebSocket;
    property KioskList: TList<TKioskInfo> read FKioskList;
    property WorkingDate: TDateTime read FWorkingDate write SetWorkingDate;
    property OnKioskListChanged: TNotifyEvent read FOnKioskListChanged write FOnKioskListChanged;
    property OnVerificationDone: TOnVerificationDoneEvent read FOnVerificationDone write FOnVerificationDone;
    property OnRecievedMessage: TRecievedMessageEvent read FOnRecievedMessage write FOnRecievedMessage;
    property OnTableUpdated: TOnTableUpdatedEvent read FOnTableUpdated write FOnTableUpdated;
    property OnAppIDAssigned: TNotifyEvent read FOnAppIDAssigned write FOnAppIDAssigned;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnError: TNotifyEvent read FOnError write FOnError;
  end;

implementation

{ TWebSocketClient }

constructor TWebSocketClient.Create;
begin
  inherited Create;
  FWebSocket := TsgcWebSocketClient.Create(nil);
  Initialize;
  FWebSocket.OnMessage := HandleMessage;
  FWebSocket.OnConnect := HandleConnect;
  FWebSocket.OnDisconnect := HandleDisconnect;
  FWebSocket.OnError := HandleError;
  FKioskList := TList<TKioskInfo>.Create;
  FWorkingDate := Date;
end;

destructor TWebSocketClient.Destroy;
begin
  FWebSocket.Free;
  FKioskList.Free;
  inherited;
end;

procedure TWebSocketClient.Initialize;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    FWebSocket.Host := IniFile.ReadString('WebSocket', 'Host', '');
    FWebSocket.Port := IniFile.ReadInteger('WebSocket', 'Port', 8080);
    FWebSocket.Options.Parameters := IniFile.ReadString('WebSocket', 'Parameters', '/');
    FWebSocket.TLS := False;
    FWebSocket.Specifications.RFC6455 := True;
    FWebSocket.Extensions.PerMessage_Deflate.Enabled := False;
  finally
    IniFile.Free;
  end;
end;

class function TWebSocketClient.GetInstance: TWebSocketClient;
begin
  if not Assigned(FInstance) then
    FInstance := TWebSocketClient.Create;
  Result := FInstance;
end;

procedure TWebSocketClient.Connect;
begin
  FWebSocket.Active := True;
end;

procedure TWebSocketClient.Disconnect;
begin
  FWebSocket.Active := False;
end;

function TWebSocketClient.IsConnected: Boolean;
begin
  Result := FWebSocket.Active;
end;

procedure TWebSocketClient.HandleConnect(Connection: TsgcWSConnection);
begin
  RequestAppID;
end;

procedure TWebSocketClient.HandleDisconnect(Connection: TsgcWSConnection; Code: Integer);
begin
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

procedure TWebSocketClient.SetWorkingDate(const Value: TDateTime);
begin
  if FWorkingDate <> Value then
  begin
    FWorkingDate := Value;
    UpdateWorkingDate(Value);
  end;
end;

procedure TWebSocketClient.UpdateWorkingDate(AWorkingDate: TDateTime = 0);
var
  MessageJSON: TJSONObject;
  WorkingDateValue: string;
begin
  if not FWebSocket.Active then
    raise Exception.Create('WebSocket is not connected.');

  MessageJSON := TJSONObject.Create;
  try
     if AWorkingDate = 0 then
      WorkingDateValue := 'null'
    else
      WorkingDateValue := DateToStr(AWorkingDate);
    MessageJSON.AddPair('type', 'update_working_date');
    MessageJSON.AddPair('workingDate', WorkingDateValue);
    FWebSocket.WriteData(MessageJSON.ToJSON);
  finally
    MessageJSON.Free;
  end;
end;

procedure TWebSocketClient.NotifyTableChange(ATableName: string);
var
  MessageJSON: TJSONObject;
begin
  if not FWebSocket.Active then
    raise Exception.Create('WebSocket is not connected.');

  if(ATableName = '') then
    exit;

  MessageJSON := TJSONObject.Create;
  try
    MessageJSON.AddPair('type', 'notify_table_change');
    MessageJSON.AddPair('workingDate', DateToStr(FWorkingDate));
    MessageJSON.AddPair('table', ATableName);
    MessageJSON.AddPair('senderAppID', FAppID);
    FWebSocket.WriteData(MessageJSON.ToJSON);
  finally
    MessageJSON.Free;
  end;
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
  VerificationJSON, PatientJSON: TJSONObject;
begin
  if not FWebSocket.Active then
    raise Exception.Create('WebSocket is not connected.');
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
      PatientJSON.AddPair('dateOfBirth', DateToStr(PatientData.DateOfBirth));
      VerificationJSON.AddPair('patientData', PatientJSON.Clone as TJSONObject);
    finally
      PatientJSON.Free;
    end;
    FWebSocket.WriteData(VerificationJSON.ToJSON);
    Result := True;
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
  TableName, WorkingDateStr, SenderAppID: string;
  WorkingDate: TDateTime;
  I: Integer;
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
      if Assigned(FOnVerificationDone) then
        FOnVerificationDone(Self, AppointmentID, ResultValue, DetailArray);
    end
    else if MsgType = 'kiosk_list_changed' then
    begin
      GetActiveKioskApps;
    end
    else if MsgType = 'table_updated' then
    begin
      TableName := JSON.GetValue<string>('table');
      WorkingDateStr := JSON.GetValue<string>('workingDate');
      SenderAppID := JSON.GetValue<string>('senderAppID');
      if TryStrToDate(WorkingDateStr, WorkingDate) then
      begin
        if (SenderAppID <> FAppID) and Assigned(FOnTableUpdated) then
          FOnTableUpdated(Self, TableName, WorkingDate);
      end
      else
        ShowMessage('Invalid date format: ' + WorkingDateStr);
    end;
  finally
    JSON.Free;
  end;
end;

procedure TWebSocketClient.UpdateKioskList(JSONArray: TJSONArray);
var
  I: Integer;
  KioskJSON: TJSONObject;
  KioskInfo: TKioskInfo;
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

initialization
  TWebSocketClient.FInstance := nil;

finalization
  FreeAndNil(TWebSocketClient.FInstance);

end.

