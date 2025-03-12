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
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    procedure ToolButtonCheckInClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
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

procedure TMainForm.FormResize(Sender: TObject);
begin
  if Assigned(CheckInForm) then
    CheckInForm.SetFormSize;
end;

procedure TMainForm.ToolButtonCheckInClick(Sender: TObject);
begin
  if not Assigned(CheckInForm) then
  begin
    CheckInForm := TCheckInForm.Create(Self);
  end;

  CheckInForm.Show;
  CheckInForm.SetFormSize;
end;

end.
