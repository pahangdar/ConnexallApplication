unit EventManagerUnit;

interface

uses
  System.Classes, System.SysUtils, WebSocketClientUnit;

type
  TOnVerificationDoneEvent = procedure(Sender: TObject;
    AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>; SuccessStatusUpdate: Boolean) of object;


  TEventManager = class
  private
    FOnVerificationDone: TOnVerificationDoneEvent;

    class var FInstance: TEventManager;
    procedure HandleVerificationResult(Sender: TObject;
      AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>);
  public
    constructor Create;
    destructor Destroy; override;

    property OnVerificationDone: TOnVerificationDoneEvent read FOnVerificationDone write FOnVerificationDone;

    procedure NotifyAppointmentUpdated(const TableName: string);

    class function Instance: TEventManager;
  end;

implementation

uses
  AppointmentsAPIUnit;
{ TEventManager }

constructor TEventManager.Create;
begin
  inherited Create;
  TWebSocketClient.Instance.OnVerificationDone := HandleVerificationResult;
end;

destructor TEventManager.Destroy;
begin
  TWebSocketClient.Instance.OnVerificationDone := nil;
  inherited;
end;

procedure TEventManager.HandleVerificationResult(Sender: TObject;
    AppointmentID: Integer; Result: string; Details: TArray<TVerificationResultDetail>);
var
  SuccessStatusUpdate: Boolean;
begin
  SuccessStatusUpdate := TAppointmentsAPI.UpdateAppointmentStatus(AppointmentID, Result);
  if SuccessStatusUpdate and Assigned(FOnVerificationDone) then
    FOnVerificationDone(Self, AppointmentID, Result, Details, SuccessStatusUpdate);
end;

procedure TEventManager.NotifyAppointmentUpdated(const TableName: string);
begin
  TWebSocketClient.Instance.NotifyTableChange(TableName);
end;

class function TEventManager.Instance: TEventManager;
begin
  if not Assigned(FInstance) then
    FInstance := TEventManager.Create;
  Result := FInstance;
end;

initialization
  TEventManager.FInstance := nil;

finalization
  FreeAndNil(TEventManager.FInstance);

end.

