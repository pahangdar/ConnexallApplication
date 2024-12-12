unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ToolWin, Vcl.Menus, Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    ToolBarMain: TToolBar;
    ImageListToolBarMain: TImageList;
    ToolButtonCheckIn: TToolButton;
    MenuPatient: TMenuItem;
    MnuItemCheckIn: TMenuItem;
    procedure ToolButtonCheckInClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses CheckInFormUnit;

procedure TMainForm.ToolButtonCheckInClick(Sender: TObject);
begin
  if not Assigned(CheckInForm) then
  begin
    CheckInForm := TCheckInForm.Create(Self);
  end;
  CheckInForm.Show;
end;

end.
