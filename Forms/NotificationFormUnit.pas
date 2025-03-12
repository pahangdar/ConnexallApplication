unit NotificationFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TNotificationForm = class(TForm)
    LabelMessage: TLabel;
    TimerClose: TTimer;
    TimerFadeOut: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
    procedure TimerFadeOutTimer(Sender: TObject);
  private
    { Private declarations }
    class var FInstance: TNotificationForm;
    class function GetInstance: TNotificationForm; static;
  public
    { Public declarations }
    destructor Destroy; override;
    procedure ShowNotification(const Msg: string);
    class procedure ShowAppNotification(const Msg: string);
  end;

//var
//  NotificationForm: TNotificationForm;

implementation

{$R *.dfm}

class function TNotificationForm.GetInstance: TNotificationForm;
begin
  if not Assigned(FInstance) then
    FInstance := TNotificationForm.Create(nil);
  Result := FInstance;
end;

procedure TNotificationForm.FormCreate(Sender: TObject);
begin
  // Set form properties
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  AlphaBlend := True;
  AlphaBlendValue := 220;  // Semi-transparent
  // Set label properties
  LabelMessage.AutoSize := True;
  LabelMessage.Font.Size := 10;
  LabelMessage.Font.Color := clWhite;
  LabelMessage.Font.Style := [fsBold];
  LabelMessage.Transparent := True;
  LabelMessage.Left := 10;
  LabelMessage.Top := 10;
  // Set form background
  Color := clBlack;
  // Initialize timers
//  TimerClose := TTimer.Create(Self);
  TimerClose.Interval := 3000;  // Auto-close after 3 sec
  TimerClose.Enabled := True;
//  TimerFadeOut := TTimer.Create(Self);
  TimerFadeOut.Interval := 100; // Slow fade out effect
  TimerFadeOut.OnTimer := TimerFadeOutTimer;
end;

procedure TNotificationForm.ShowNotification(const Msg: string);
var
  ScreenWidth, ScreenHeight: Integer;
begin
  LabelMessage.Caption := Msg;
  Width := LabelMessage.Width + 20;
  Height := LabelMessage.Height + 20;
  // Position at bottom-right corner of the screen
  ScreenWidth := Screen.WorkAreaWidth;
  ScreenHeight := Screen.WorkAreaHeight;
  Left := ScreenWidth - Width - 20;
  Top := ScreenHeight - Height - 20;
  AlphaBlendValue := 220;  // Reset transparency
  TimerClose.Enabled := False;
  TimerFadeOut.Enabled := False;

  TimerClose.Enabled := True;  // Start auto-close timer
  Show;
end;

procedure TNotificationForm.TimerCloseTimer(Sender: TObject);
begin
  TimerClose.Enabled := False;  // Stop close timer
  TimerFadeOut.Enabled := True; // Start fading out
end;

procedure TNotificationForm.TimerFadeOutTimer(Sender: TObject);
begin
  if AlphaBlendValue > 15 then
    AlphaBlendValue := AlphaBlendValue - 15
  else
  begin
    TimerFadeOut.Enabled := False; // Stop fade-out timer
    Hide; // Hide instead of closing
  end;
end;

// Singleton method to show notification
class procedure TNotificationForm.ShowAppNotification(const Msg: string);
begin
  GetInstance.ShowNotification(Msg);
end;

destructor TNotificationForm.Destroy;
begin
  FInstance := nil;
  inherited;
end;

initialization
  TNotificationForm.FInstance := nil;

finalization
  FreeAndNil(TNotificationForm.FInstance);

end.
