unit DataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, Vcl.Dialogs,
  WebSocketClientUnit;

type
  TDataModuleMain = class(TDataModule)
  private
    { Private declarations }
    FWebSocketClient: TWebSocketClient;
    FFDConnection: TFDConnection;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure ConnectToDatabase;
    procedure DisconnectFromDatabase;
    function GetWebSocketClient: TWebSocketClient;

    property FDConnection: TFDConnection read FFDConnection write FFDConnection;
  end;

var
  DataModuleMain: TDataModuleMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TDataModuleMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  try
    FFDConnection := TFDConnection.Create(Self);
    FFDConnection.DriverName := 'MSSQL';
    FFDConnection.Params.Add('Database=Connexall');
    FFDConnection.Params.Add('User_Name=sa');
    FFDConnection.Params.Add('Server=DESKTOP-3U2UH42\MSSQLSERVER2012');
    FFDConnection.Params.Add('DriverID=MSSQL');
    FFDConnection.LoginPrompt := False;
  except
    on E: Exception do
      raise Exception.Create('Error initializing FFDConnection: ' + E.Message);
  end;
end;

procedure TDataModuleMain.ConnectToDatabase;
begin
  if not FFDConnection.Connected then
  begin
    try
      FFDConnection.Connected := true;
    except
      on E: Exception do
        raise Exception.Create('Failed to connect to the database: ' + E.Message);
    end;
  end;
  FFDConnection.Connected := True;
end;

procedure TDataModuleMain.DisconnectFromDatabase;
begin
  if FFDConnection.Connected then
    FFDConnection.Connected := False;
end;

function TDataModuleMain.GetWebSocketClient: TWebSocketClient;
begin
  if not Assigned(FWebSocketClient) then
  begin
    FWebSocketClient := TWebSocketClient.Create;
    FWebSocketClient.Connect;
  end;
  Result := FWebSocketClient;
end;

end.
