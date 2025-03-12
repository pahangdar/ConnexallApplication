unit StartVerificationFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, System.Generics.Collections,
  WebSocketClientUnit;

type
  TStartVerificationForm = class(TForm)
    Label1: TLabel;
    LabelPatientName: TLabel;
    ComboBoxKioskList: TComboBox;
    Label2: TLabel;
    BitBtnCancel: TBitBtn;
    BitBtnStart: TBitBtn;
    procedure BitBtnStartClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FSelectedKiosk: string;
    FConfirmed: Boolean;
  public
    { Public declarations }
    procedure PopulateKioskList(KioskList: TList<TKioskInfo>);
    property SelectedKiosk: string read FSelectedKiosk;
    property Confirmed: Boolean read FConfirmed;
  end;

var
  StartVerificationForm: TStartVerificationForm;

implementation

{$R *.dfm}

procedure TStartVerificationForm.BitBtnCancelClick(Sender: TObject);
begin
  FConfirmed := False;
  Close;
end;

procedure TStartVerificationForm.BitBtnStartClick(Sender: TObject);
begin
if ComboBoxKioskList.ItemIndex = -1 then
  begin
    ShowMessage('Please select a kiosk.');
    Exit;
  end;

  try
    FSelectedKiosk := ComboBoxKioskList.Items[ComboBoxKioskList.ItemIndex];
    FConfirmed := True;
    Close;
  except
    on E: Exception do
      ShowMessage('Error starting verification: ' + E.Message);
  end;
end;

procedure TStartVerificationForm.PopulateKioskList(KioskList: TList<TKioskInfo>);
var
  Kiosk: TKioskInfo;
begin
  ComboBoxKioskList.Items.Clear;
  try
    for Kiosk in KioskList do
    begin
      if Kiosk.Status = 'waiting' then
        ComboBoxKioskList.Items.Add(Kiosk.AppID);
    end;

    if ComboBoxKioskList.Items.Count > 0 then
    begin
      ComboBoxKioskList.ItemIndex := 0;
      BitBtnStart.Enabled := True;
    end
    else
    begin
      BitBtnStart.Enabled := False;
      ShowMessage('No available kiosks.');
    end;
  except
    on E: Exception do
      ShowMessage('Error populating kiosk list: ' + E.Message);
  end;
end;

end.
