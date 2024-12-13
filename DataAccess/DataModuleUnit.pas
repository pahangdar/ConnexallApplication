unit DataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef;

type
  TDataModuleMain = class(TDataModule)
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    FDConnection1: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConnectToDatabase;
  end;

var
  DataModuleMain: TDataModuleMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModuleMain.ConnectToDatabase;
begin
//  FDConnection.Params.Clear;
//  FDConnection.DriverName := 'MySQL';
//  FDConnection.Params.Add('Server=srv1540.hstgr.io');
//  FDConnection.Params.Add('Database=u522057862_connexall');
//  FDConnection.Params.Add('User_Name=u522057862_connexall');
//  FDConnection.Params.Add('Password=Azadiazadi6851#');

//  FDConnection.DriverName := 'MSSQL';
//  FDConnection.Params.Add('Server=DESKTOP-3U2UH42\MSSQLSERVER2012');
//  FDConnection.Params.Add('Database=Connexall');
//  FDConnection.Params.Add('User_Name=sa');
//  FDConnection.Params.Add('Password=Azadiazadi6851#');
//  FDConnection.LoginPrompt := False;
//  FDConnection.Connected := True;
  FDConnection1.Connected := True;
end;

end.
