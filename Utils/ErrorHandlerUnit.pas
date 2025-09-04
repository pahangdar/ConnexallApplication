unit ErrorHandlerUnit;

interface

uses
  System.SysUtils, Vcl.Dialogs;

type
  TErrorHandler = class
  public
    class procedure HandleException(Sender: TObject; E: Exception);
    class procedure Log(const Msg: string); overload;
    class procedure Log(E: Exception); overload;
  end;

implementation

uses
  System.IOUtils;

class procedure TErrorHandler.HandleException(Sender: TObject; E: Exception);
begin
  Log(E);
  ShowMessage('Unexpected error: ' + E.Message);
end;

class procedure TErrorHandler.Log(const Msg: string);
begin
  TFile.AppendAllText('ErrorLog.txt',
    FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + Msg + sLineBreak);
end;

class procedure TErrorHandler.Log(E: Exception);
begin
  Log(E.ClassName + ': ' + E.Message);
end;

end.

