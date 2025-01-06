unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ToolWin, Vcl.Menus, Vcl.StdCtrls, DataModuleUnit;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    ToolBarMain: TToolBar;
    ImageListToolBarMain: TImageList;
    ToolButtonCheckIn: TToolButton;
    MenuPatient: TMenuItem;
    MnuItemCheckIn: TMenuItem;
    procedure ToolButtonCheckInClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(DataModuleMain) then
    DataModuleMain.DisconnectFromDatabase;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if Assigned(DataModuleMain) then
    DataModuleMain.ConnectToDatabase;
end;

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
