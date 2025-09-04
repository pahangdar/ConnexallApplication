unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ToolWin, Vcl.Menus, Vcl.StdCtrls,
  CheckInFormUnit, AIChatFormUnit, UIFormResizable;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    ToolBarMain: TToolBar;
    ImageListToolBarMain: TImageList;
    ToolButtonCheckIn: TToolButton;
    AppoinmentMenue: TMenuItem;
    MnuItemCheckIn: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    MnuItemAIChat: TMenuItem;
    ToolButtonAIChat: TToolButton;
    ToolButton9: TToolButton;
    WindowMenu: TMenuItem;
    miWindowsList: TMenuItem;
    procedure ToolButtonCheckInClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ToolButtonAIChatClick(Sender: TObject);
    procedure WindowMenuClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowForm(var FormRef: TForm; FormClass: TFormClass);
    procedure WindowMenuItemClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormResize(Sender: TObject);
  procedure ResizeIfSupported(AForm: TForm);
  var
    Resizable: IResizableForm;
  begin
    if Assigned(AForm) and Supports(AForm, IResizableForm, Resizable) then
      Resizable.SetFormSize;
  end;
begin
  ResizeIfSupported(CheckInForm);
  ResizeIfSupported(AIChatForm);
end;

procedure TMainForm.ShowForm(var FormRef: TForm; FormClass: TFormClass);
var
  Resizable: IResizableForm;
begin
  try
    if not Assigned(FormRef) then
    begin
      FormRef := FormClass.Create(Self);
      if Assigned(FormRef) and Supports(FormRef, IResizableForm, Resizable) then
      begin
        Resizable.SetFormSize;
      end;
    end;

    FormRef.Show;
    FormRef.BringToFront;
  except
    on E: Exception do
      MessageDlg('Error creating form: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.ToolButtonAIChatClick(Sender: TObject);
begin
  ShowForm(AIChatForm, TAIChatForm);
end;

procedure TMainForm.ToolButtonCheckInClick(Sender: TObject);
begin
  ShowForm(CheckInForm, TCheckInForm);
end;

procedure TMainForm.WindowMenuClick(Sender: TObject);
var
  I: Integer;
  MenuItem: TMenuItem;
begin
  // Clear old items, keep static ones if needed
  WindowMenu.Clear;

  // Re-add caption
  WindowMenu.Caption := 'Window';

  // Populate with open forms
  for I := 0 to Screen.FormCount - 1 do
  begin
    // Skip MainForm itself if you don’t want it listed
    if Screen.Forms[I] = Self then
      Continue;

    MenuItem := TMenuItem.Create(WindowMenu);
    MenuItem.Caption := Screen.Forms[I].Caption;
    MenuItem.Tag := NativeInt(Screen.Forms[I]); // store pointer in Tag
    MenuItem.OnClick := WindowMenuItemClick;
    WindowMenu.Add(MenuItem);
  end;

  if WindowMenu.Count = 0 then
  begin
    MenuItem := TMenuItem.Create(WindowMenu);
    MenuItem.Caption := '(No windows open)';
    MenuItem.Enabled := False;
    WindowMenu.Add(MenuItem);
  end;
end;

procedure TMainForm.WindowMenuItemClick(Sender: TObject);
var
  Frm: TForm;
begin
  Frm := TForm(TMenuItem(Sender).Tag);
  if Assigned(Frm) then
  begin
    Frm.Show;
    Frm.BringToFront;
  end;
end;

end.
