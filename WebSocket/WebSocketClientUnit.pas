unit WebSocketClientUnit;

interface

uses
  sgcWebSocket, System.Classes, System.SysUtils, system.JSON, VCL.Dialogs, sgcWebSocket_Classes, System.Generics.Collections;

type
  TKioskInfo = record
    AppID: string;
    Status: string;
  end;

  TWebSocketClient = class
  private
    FWebSocket: TsgcWebSocketClient;
    FAppID: string;
    FKioskList: TList<TKioskInfo>;
    FOnKioskListChanged: TNotifyEvent;
    FOnVerificationDone: TNotifyEvent;

    procedure HandleMessage(Connection: TsgcWSConnection; const Text: string);
    procedure UpdateKioskList(JSONArray: TJSONArray);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect;
    procedure RequestAppID;
    procedure GetActiveKioskApps;
    procedure StartVerification(AppointmentID: Integer; TargetAppID: string; PatientData: string);

    property AppID: string read FAppID;
    property KioskList: TList<TKioskInfo> read FKioskList;
    property OnKioskListChanged: TNotifyEvent read FOnKioskListChanged write FOnKioskListChanged;
    property OnVerificationDone: TNotifyEvent read FOnVerificationDone write FOnVerificationDone;
  end;

var
  WebSocketClient: TWebSocketClient;

implementation

uses CheckInFormUnit;

{ TWebSocketClient }

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
  if FWebSocket.Active then
    ShowMessage('Connected to WebSocket server.');
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

procedure TWebSocketClient.StartVerification(AppointmentID: Integer; TargetAppID: string; PatientData: string);
var
  VerificationJSON: string;
begin
  VerificationJSON := Format(
    '{"type": "start_verification", "appointmentId": %d, "requesterAppID": "%s", "targetAppID": "%s", "patientData": %s}',
    [AppointmentID, FAppID, TargetAppID, PatientData]);

  if FWebSocket.Active then
    FWebSocket.WriteData(VerificationJSON);
end;

procedure TWebSocketClient.HandleMessage(Connection: TsgcWSConnection; const Text: string);
var
  JSON: TJSONObject;
  JSONValue: TJSONValue;
  MsgType: string;
begin
  JSON := nil;
  try
    JSON := TJSONObject.ParseJSONValue(Text) as TJSONObject;
    if not Assigned(JSON) then
      Exit;
    CheckInForm.Memo1.Lines.Add(Text);
    MsgType := JSON.GetValue<string>('type');
    if MsgType = 'assign_id' then
    begin
      JSONValue := JSON.GetValue('appID');
      if Assigned(JSONValue) then
      begin
        FAppID := JSONValue.Value;
        GetActiveKioskApps;
        ShowMessage('AppID assigned: ' + FAppID);
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
      if Assigned(FOnVerificationDone) then
        FOnVerificationDone(Self);
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

