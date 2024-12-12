unit CheckInFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TCheckInForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckInForm: TCheckInForm;

implementation

{$R *.dfm}

procedure TCheckInForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  CheckInForm := nil;
end;

end.
