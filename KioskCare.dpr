program KioskCare;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  System.SysUtils,
  MainFormUnit in 'Forms\MainFormUnit.pas' {MainForm},
  CheckInFormUnit in 'Forms\CheckInFormUnit.pas' {CheckInForm},
  Vcl.Themes,
  Vcl.Styles,
  PatientUnit in 'Modules\PatientUnit.pas',
  DoctorUnit in 'Modules\DoctorUnit.pas',
  AppointmentUnit in 'Modules\AppointmentUnit.pas',
  AppointmentsUtils in 'Utils\AppointmentsUtils.pas',
  WebSocketClientUnit in 'WebSocket\WebSocketClientUnit.pas',
  StartVerificationFormUnit in 'Forms\StartVerificationFormUnit.pas' {StartVerificationForm},
  AppointmentTabUnit in 'Modules\AppointmentTabUnit.pas',
  AppointmentsAPIUnit in 'DataAccess\AppointmentsAPIUnit.pas',
  EventManagerUnit in 'Utils\EventManagerUnit.pas',
  NotificationFormUnit in 'Forms\NotificationFormUnit.pas' {NotificationForm},
  ValidationUtils in 'Utils\ValidationUtils.pas',
  AIChatFormUnit in 'Forms\AIChatFormUnit.pas' {AIChatForm},
  ChatBubbleFrameUnit in 'Forms\ChatBubbleFrameUnit.pas' {ChatBubbleFrame: TFrame},
  ErrorHandlerUnit in 'Utils\ErrorHandlerUnit.pas',
  UIFormResizable in 'Interfaces\UIFormResizable.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sky');
  Application.Title := 'Kiosk-Care Application';

  try
    TWebSocketClient.Instance.Connect;
  except
    on E: Exception do
    begin
      TErrorHandler.Log(E);
      ShowMessage('Could not connect to WebSocket: ' + E.Message);
    end;
  end;

  Application.CreateForm(TMainForm, MainForm);
  Application.OnException := TErrorHandler.HandleException;
  Application.Run;
end.
