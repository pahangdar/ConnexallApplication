program ConnexallApplication;

uses
  Vcl.Forms,
  MainFormUnit in 'Forms\MainFormUnit.pas' {MainForm},
  CheckInFormUnit in 'Forms\CheckInFormUnit.pas' {CheckInForm},
  Vcl.Themes,
  Vcl.Styles,
  PatientUnit in 'Modules\PatientUnit.pas',
  DoctorUnit in 'Modules\DoctorUnit.pas',
  AppointmentUnit in 'Modules\AppointmentUnit.pas',
  AppointmentsDataAccessUnit in 'DataAccess\AppointmentsDataAccessUnit.pas',
  DataModuleUnit in 'DataAccess\DataModuleUnit.pas' {DataModuleMain: TDataModule},
  AppointmentsUtils in 'Utils\AppointmentsUtils.pas',
  WebSocketClientUnit in 'WebSocket\WebSocketClientUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Connexall Application';
  TStyleManager.TrySetStyle('Lavender Classico');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDataModuleMain, DataModuleMain);
  //  Application.CreateForm(TCheckInForm, CheckInForm);
  Application.Run;
end.
